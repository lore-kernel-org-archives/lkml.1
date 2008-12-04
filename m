Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302AbYLDId1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbYLDId1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 03:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbYLDIdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 03:33:17 -0500
Received: from smtp-out.neti.ee ([194.126.126.44]:51034 "EHLO smtp-out.neti.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbYLDIdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 03:33:16 -0500
X-Greylist: delayed 636 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Dec 2008 03:33:16 EST
X-SMTP-Auth-NETI-Businesmail: no
Message-ID: <4937933E.80207@liewenthal.ee>
Date: Thu, 04 Dec 2008 10:22:22 +0200
From: =?ISO-8859-1?Q?J=FCri_Reitel?= <juri.reitel@liewenthal.ee>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: USB serial gadget documentation and gserial.inf
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve linux documentation and add better gserial.inf file, now users 
will not have to find the usbser.sys by themselves

Signed-off-by: Kristjan Räts <kristjan.rats@liewenthal.ee>
Signed-off-by: Jüri Reitel <juri.reitel@liewenthal.ee>

diff --git a/Documentation/usb/gadget_serial.txt 
b/Documentation/usb/gadget_serial.txt
index 9b22bd1..b25e1e8 100644
--- a/Documentation/usb/gadget_serial.txt
+++ b/Documentation/usb/gadget_serial.txt
@@ -162,8 +162,10 @@ Signature="$Windows NT$"
 Class=Ports
 ClassGuid={4D36E978-E325-11CE-BFC1-08002BE10318}
 Provider=%LINUX%
-DriverVer=08/17/2004,0.0.2.0
+LayoutFile=layout.inf
+DriverVer=10/08/2008,1.0.2.0
 ; Copyright (C) 2004 Al Borchers (alborchers@steinerpoint.com)
+; Modified to use usbser.sys automatically from Windows installation 
directory
 
 [Manufacturer]
 %LINUX%=GSerialDeviceList
@@ -172,14 +174,15 @@ DriverVer=08/17/2004,0.0.2.0
 %GSERIAL%=GSerialInstall, USB\VID_0525&PID_A4A7
 
 [DestinationDirs]
-DefaultDestDir=10,System32\Drivers
+DefaultDestDir=12
+GSerialCopyFilesFake=12
 
 [GSerialInstall]
-CopyFiles=GSerialCopyFiles
+CopyFiles=GSerialCopyFilesFake
 AddReg=GSerialAddReg
 
-[GSerialCopyFiles]
-usbser.sys
+[GSerialCopyFilesFake]
+usbser.sys,,,0x20
 
 [GSerialAddReg]
 HKR,,DevLoader,,*ntkern
@@ -193,8 +196,8 @@ AddService = usbser,0x0002,GSerialService
 DisplayName = %GSERIAL_DISPLAY_NAME%
 ServiceType = 1                  ; SERVICE_KERNEL_DRIVER
 StartType = 3                    ; SERVICE_DEMAND_START
-ErrorControl = 1                 ; SERVICE_ERROR_NORMAL
-ServiceBinary = %10%\System32\Drivers\usbser.sys
+ErrorControl = 0                 ; SERVICE_ERROR_NORMAL
+ServiceBinary = %12%\usbser.sys
 LoadOrderGroup = Base
 
 [Strings]
@@ -203,37 +206,30 @@ GSERIAL = "Gadget Serial"
 GSERIAL_DISPLAY_NAME = "USB Gadget Serial Driver"
 -------------------- CUT HERE --------------------
 
-The "usbser.sys" file comes with various versions of Windows.
-For example, it can be found on Windows XP typically in
-
-  C:\WINDOWS\Driver Cache\i386\driver.cab
-
-Or it can be found on the Windows 98SE CD in the "win98" folder
-in the "DRIVER11.CAB" through "DRIVER20.CAB" cab files.  You will
-need the DOS "expand" program, the Cygwin "cabextract" program, or
-a similar program to unpack these cab files and extract "usbser.sys".
-
-For example, to extract "usbser.sys" into the current directory
-on Windows XP, open a DOS window and run a command like
-
-  expand C:\WINDOWS\Driver~1\i386\driver.cab -F:usbser.sys .
-
-(Thanks to Nishant Kamat for pointing out this DOS command.)
+This inf file will tell windows to use its usbser.sys file.
+If the file usbser.sys is not yet installed, Windows will
+find and install it automatically.  So there is no need to
+show the location of usbser.sys to Windows.
 
 When the gadget serial driver is loaded and the USB device connected
 to the Windows host with a USB cable, Windows should recognize the
-gadget serial device and ask for a driver.  Tell Windows to find the
-driver in the folder that contains "gserial.inf" and "usbser.sys".
+gadget serial device and ask for a driver.  Tell Windows to use the
+"gserial.inf" file.
 
 For example, on Windows XP, when the gadget serial device is first
 plugged in, the "Found New Hardware Wizard" starts up.  Select
 "Install from a list or specific location (Advanced)", then on
 the next screen select "Include this location in the search" and
-enter the path or browse to the folder containing "gserial.inf" and
-"usbser.sys".  Windows will complain that the Gadget Serial driver
+enter the path or browse to the folder containing "gserial.inf".
+Windows will complain that the Gadget Serial driver
 has not passed Windows Logo testing, but select "Continue anyway"
 and finish the driver installation.
 
+Another way is to install the driver via Winows API function
+::SetupCopyOEMInf(_T("gserial.inf"), NULL, SPOST_PATH,
+    SP_COPY_DELETESOURCE | SP_COPY_NOOVERWRITE,    NULL, 0, NULL, NULL
+);
+
 On Windows XP, in the "Device Manager" (under "Control Panel",
 "System", "Hardware") expand the "Ports (COM & LPT)" entry and you
 should see "Gadget Serial" listed as the driver for one of the COM

