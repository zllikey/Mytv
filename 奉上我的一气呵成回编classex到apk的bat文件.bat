@echo off

set NAME=mytv

set filename=%NAME%.apk
set time1=%time:~0,2%%time:~3,2%%time:~6,2%



cd /d %~dp0
del /Q /F /S classes.dex *signed.apk *_classes.dex Signed_*>nul 2>NUL

echo 正在回编DEX
rem java -jar "smali.jar" Smali* -o "%NAME%_classes.dex">NUL 2>NUL
java -jar "./apktool/smali.jar" Smali* -o "classes.dex">NUL 2>NUL

if exist "classes.dex" (
echo 回编完成
rem ren *_classes.dex classes.dex

rem copy Smali_mytvhd_classes.dex classes.dex
echo 添加DEX到%filename%
rem "C:\Program Files\7-Zip\7z.exe" a -tzip -mx9 %filename% classes.dex>NUL 2>NUL
"./apktool/7z.exe" a -tzip %filename% classes.dex>NUL 2>NUL
echo 签名%filename%
java -jar "./apktool/signapk.jar" "./apktool/testkey.x509.pem" "./apktool/testkey.pk8" %filename% "Signed_%filename%" >nul 2>NUL
rem echo 安装%filename%
rem adb connect 127.0.0.1:5551
rem adb install -r Signed_*.apk
rem echo 安装完毕


) else (
echo 编译失败

)



set time2=%time:~0,2%%time:~3,2%%time:~6,2%
set /a time3=%time2%-%time1%
echo 用时%time3%秒
ping 127.1 -n 3 >NUL 2>NUL
exit
