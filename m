Return-Path: <linux-kernel-owner+w=401wt.eu-S933821AbXF2Sl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933821AbXF2Sl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 14:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbXF2SlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 14:41:18 -0400
Received: from smtp3.nextra.sk ([195.168.1.142]:4011 "EHLO mailhub3.nextra.sk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753309AbXF2SlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 14:41:17 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: daniel.ritz@gmx.ch
Subject: [PATCH] IRTOUCHSYSTEMS support for usbtouchscreen
Date: Fri, 29 Jun 2007 20:41:11 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_IJVhGvJ+bMFmEeU"
Message-Id: <200706292041.12056.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_IJVhGvJ+bMFmEeU
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,
this patch adds support for IRTOUCHSYSTEMS (or UNITOP) infrared touchscreens. 

The manufacturer (http://www.irtouch.com) provides only closed source drivers 
for specific kernel versions (looks like GPL violation, btw.) which I haven't 
even tried (as there's no chance that any of the modules could work with 
2.6.22-rc kernel). They also don't provide any protocol specification.

So I made this code (attached) after observing the data stream with usbmon for 
a while. If someone is interested in my observations, here are the results:

The touchscreen sends data in 8-byte packets.
BYTE 0 - unknown meaning, seen only one value: 0x54
BYTE 1 - unknown meaning, 3 lowest bits indicate touch state
        values seen: 0x81, 0x82 or 0x83
        bit 0 = set if the screen is touched and was not touched before (touch
        bit 1 = set if the screen is touched and was touched (dragging)
        bit 2 = set if the touch was ended (release)
BYTES 2 and 3 - X position, high-order-byte first, range = 0 to 0x0FFF
BYTES 4 and 5 - Y position, high-order-byte first, range = 0 to 0x0FFF
BYTE 6 - unknown meaning, seen only one value: 0xFF
BYTE 7 - unknown meaning, seen only one value: 0x00

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

-- 
Ondrej Zary

--Boundary-00=_IJVhGvJ+bMFmEeU
Content-Type: text/x-diff;
  charset="us-ascii";
  name="usbtouchscreen-add-irtouch.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="usbtouchscreen-add-irtouch.patch"

diff -ur linux-2.6.22-rc6-orig/drivers/input/touchscreen/Kconfig linux-2.6.22-rc6/drivers/input/touchscreen/Kconfig
--- linux-2.6.22-rc6-orig/drivers/input/touchscreen/Kconfig	2007-06-29 12:56:19.000000000 +0200
+++ linux-2.6.22-rc6/drivers/input/touchscreen/Kconfig	2007-06-29 13:01:38.000000000 +0200
@@ -177,6 +177,7 @@
 	  - some other eTurboTouch
 	  - Gunze AHL61
 	  - DMC TSC-10/25
+	  - IRTOUCHSYSTEMS/UNITOP
 
 	  Have a look at <http://linux.chapter7.ch/touchkit/> for
 	  a usage description and the required user-space stuff.
@@ -219,4 +220,9 @@
 	bool "DMC TSC-10/25 device support" if EMBEDDED
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
+config TOUCHSCREEN_USB_IRTOUCH
+	default y
+	bool "IRTOUCHSYSTEMS/UNITOP device support" if EMBEDDED
+	depends on TOUCHSCREEN_USB_COMPOSITE
+
 endif
Only in linux-2.6.22-rc6/drivers/input/touchscreen/: built-in.o
diff -ur linux-2.6.22-rc6-orig/drivers/input/touchscreen/usbtouchscreen.c linux-2.6.22-rc6/drivers/input/touchscreen/usbtouchscreen.c
--- linux-2.6.22-rc6-orig/drivers/input/touchscreen/usbtouchscreen.c	2007-06-29 12:56:19.000000000 +0200
+++ linux-2.6.22-rc6/drivers/input/touchscreen/usbtouchscreen.c	2007-06-29 13:01:48.000000000 +0200
@@ -9,6 +9,7 @@
  *  - eTurboTouch
  *  - Gunze AHL61
  *  - DMC TSC-10/25
+ *  - IRTOUCHSYSTEMS/UNITOP
  *
  * Copyright (C) 2004-2006 by Daniel Ritz <daniel.ritz@gmx.ch>
  * Copyright (C) by Todd E. Johnson (mtouchusb.c)
@@ -110,6 +111,7 @@
 	DEVTYPE_ETURBO,
 	DEVTYPE_GUNZE,
 	DEVTYPE_DMC_TSC10,
+	DEVTYPE_IRTOUCH,
 };
 
 static struct usb_device_id usbtouch_devices[] = {
@@ -150,6 +152,11 @@
 	{USB_DEVICE(0x0afa, 0x03e8), .driver_info = DEVTYPE_DMC_TSC10},
 #endif
 
+#ifdef CONFIG_TOUCHSCREEN_USB_IRTOUCH
+	{USB_DEVICE(0x595a, 0x0001), .driver_info = DEVTYPE_IRTOUCH},
+	{USB_DEVICE(0x6615, 0x0001), .driver_info = DEVTYPE_IRTOUCH},
+#endif
+
 	{}
 };
 
@@ -416,6 +423,21 @@
 
 
 /*****************************************************************************
+ * IRTOUCH Part
+ */
+#ifdef CONFIG_TOUCHSCREEN_USB_IRTOUCH
+static int irtouch_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
+{
+	dev->x = (pkt[3] << 8) | pkt[2];
+	dev->y = (pkt[5] << 8) | pkt[4];
+	dev->touch = (pkt[1] & 0x03) ? 1 : 0;
+
+	return 1;
+}
+#endif
+
+
+/*****************************************************************************
  * the different device descriptors
  */
 static struct usbtouch_device_info usbtouch_dev_info[] = {
@@ -504,6 +526,17 @@
 		.read_data	= dmc_tsc10_read_data,
 	},
 #endif
+
+#ifdef CONFIG_TOUCHSCREEN_USB_IRTOUCH
+	[DEVTYPE_IRTOUCH] = {
+		.min_xc		= 0x0,
+		.max_xc		= 0x0fff,
+		.min_yc		= 0x0,
+		.max_yc		= 0x0fff,
+		.rept_size	= 8,
+		.read_data	= irtouch_read_data,
+	},
+#endif
 };
 

--Boundary-00=_IJVhGvJ+bMFmEeU--
