Return-Path: <linux-kernel-owner+w=401wt.eu-S1764860AbXH0WHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764860AbXH0WHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763457AbXH0WHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 18:07:31 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:59454 "EHLO
	viefep23-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762863AbXH0WH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 18:07:29 -0400
Content-Disposition: inline
From: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Ondrej Zary <linux@rainbow-software.org>
Subject: Fwd: [PATCH] IdealTEK URTC1000 support for usbtouchscreen
Date: Tue, 28 Aug 2007 00:07:39 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708280007.40457.daniel.ritz-ml@swissonline.ch>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, so here's the new patch, inline this time:

thanks. looks fine now. forwarding to Dmitry for mainline inclusion...

rgds
-daniel

-----------------

[PATCH] IdealTEK URTC1000 support for usbtouchscreen

This patch adds support for IdealTEK URTC1000 touchscreen controllers.

Documentation can be downloaded at 
http://projects.tbmn.org/cgi-bin/trac.cgi/wiki/urtc-1000

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>


diff -ur linux-2.6.23-rc3-orig/drivers/input/touchscreen/Kconfig linux-2.6.23-rc3/drivers/input/touchscreen/Kconfig
--- linux-2.6.23-rc3-orig/drivers/input/touchscreen/Kconfig	2007-08-21 15:32:50.000000000 +0200
+++ linux-2.6.23-rc3/drivers/input/touchscreen/Kconfig	2007-08-23 16:07:08.000000000 +0200
@@ -191,6 +191,7 @@
 	  - Gunze AHL61
 	  - DMC TSC-10/25
 	  - IRTOUCHSYSTEMS/UNITOP
+	  - IdealTEK URTC1000
 
 	  Have a look at <http://linux.chapter7.ch/touchkit/> for
 	  a usage description and the required user-space stuff.
@@ -238,4 +239,9 @@
 	bool "IRTOUCHSYSTEMS/UNITOP device support" if EMBEDDED
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
+config TOUCHSCREEN_USB_IDEALTEK
+	default y
+	bool "IdealTEK URTC1000 device support" if EMBEDDED
+	depends on TOUCHSCREEN_USB_COMPOSITE
+
 endif
diff -ur linux-2.6.23-rc3-orig/drivers/input/touchscreen/usbtouchscreen.c linux-2.6.23-rc3/drivers/input/touchscreen/usbtouchscreen.c
--- linux-2.6.23-rc3-orig/drivers/input/touchscreen/usbtouchscreen.c	2007-08-23 16:24:16.000000000 +0200
+++ linux-2.6.23-rc3/drivers/input/touchscreen/usbtouchscreen.c	2007-08-27 09:29:06.000000000 +0200
@@ -10,6 +10,7 @@
  *  - Gunze AHL61
  *  - DMC TSC-10/25
  *  - IRTOUCHSYSTEMS/UNITOP
+ *  - IdealTEK URTC1000
  *
  * Copyright (C) 2004-2006 by Daniel Ritz <daniel.ritz@gmx.ch>
  * Copyright (C) by Todd E. Johnson (mtouchusb.c)
@@ -92,7 +93,7 @@
 };
 
 
-#if defined(CONFIG_TOUCHSCREEN_USB_EGALAX) || defined(CONFIG_TOUCHSCREEN_USB_ETURBO)
+#if defined(CONFIG_TOUCHSCREEN_USB_EGALAX) || defined(CONFIG_TOUCHSCREEN_USB_ETURBO) || defined(CONFIG_TOUCHSCREEN_USB_IDEALTEK)
 #define MULTI_PACKET
 #endif
 
@@ -112,6 +113,7 @@
 	DEVTYPE_GUNZE,
 	DEVTYPE_DMC_TSC10,
 	DEVTYPE_IRTOUCH,
+	DEVTYPE_IDEALTEK,
 };
 
 static struct usb_device_id usbtouch_devices[] = {
@@ -157,6 +159,10 @@
 	{USB_DEVICE(0x6615, 0x0001), .driver_info = DEVTYPE_IRTOUCH},
 #endif
 
+#ifdef CONFIG_TOUCHSCREEN_USB_IDEALTEK
+	{USB_DEVICE(0x1391, 0x1000), .driver_info = DEVTYPE_IDEALTEK},
+#endif
+
 	{}
 };
 
@@ -438,6 +444,39 @@
 
 
 /*****************************************************************************
+ * IdealTEK URTC1000 Part
+ */
+#ifdef CONFIG_TOUCHSCREEN_USB_IDEALTEK
+static int idealtek_get_pkt_len(unsigned char *buf, int len)
+{
+	if (buf[0] & 0x80)
+		return 5;
+	if (buf[0] == 0x01)
+		return len;
+	return 0;
+}
+
+static int idealtek_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
+{
+	if ((pkt[0] & 0x98) == 0x88) {
+		/* touch data in IdealTEK mode */
+		dev->x = (pkt[1] << 5) | (pkt[2] >> 2);
+		dev->y = (pkt[3] << 5) | (pkt[4] >> 2);
+		dev->touch = (pkt[0] & 0x40) ? 1 : 0;
+		return 1;
+	} else if ((pkt[0] & 0x98) == 0x98) {
+		/* touch data in MT emulation mode */
+		dev->x = (pkt[2] << 5) | (pkt[1] >> 2);
+		dev->y = (pkt[4] << 5) | (pkt[3] >> 2);
+		dev->touch = (pkt[0] & 0x40) ? 1 : 0;
+		return 1;
+	}
+	return 0;
+}
+#endif
+
+
+/*****************************************************************************
  * the different device descriptors
  */
 static struct usbtouch_device_info usbtouch_dev_info[] = {
@@ -537,6 +576,20 @@
 		.read_data	= irtouch_read_data,
 	},
 #endif
+
+#ifdef CONFIG_TOUCHSCREEN_USB_IDEALTEK
+	[DEVTYPE_IDEALTEK] = {
+		.min_xc		= 0x0,
+		.max_xc		= 0x0fff,
+		.min_yc		= 0x0,
+		.max_yc		= 0x0fff,
+		.rept_size	= 8,
+		.flags		= USBTOUCH_FLG_BUFFER,
+		.process_pkt	= usbtouch_process_multi,
+		.get_pkt_len	= idealtek_get_pkt_len,
+		.read_data	= idealtek_read_data,
+	},
+#endif
 };
 
 


-- 
Ondrej Zary

-------------------------------------------------------
