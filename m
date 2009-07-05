Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbZGEOcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbZGEOcD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 10:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbZGEObw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 10:31:52 -0400
Received: from mtah21.telenor.se ([195.54.99.196]:53626 "EHLO
	mtah21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZGEObv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 10:31:51 -0400
X-Greylist: delayed 4487 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Jul 2009 10:31:50 EDT
X-SMTPAUTH-B2: 
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoCRAH9DUEpV4NNHPGdsb2JhbACBUZdAAQEBATdQr2qEEgU
X-IronPort-AV: E=Sophos;i="4.42,351,1243807200"; 
   d="scan'208";a="26678569"
Date: Sun, 5 Jul 2009 15:13:06 +0200
From: Jim Persson <jim-linux@nurd.se>
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: Daniel Ritz <daniel.ritz@gmx.ch>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH] usbtouchscreen: support for JASTEC/DigiTech DTR-02U USB
	touch controllers
Message-ID: <20090705131306.GC23869@nurd.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add support for the JASTEC/DigiTech DTR-02U USB touch screen
controllers. 

Signed-off-by: Jim Persson <jim-linux@nurd.se>
---
 drivers/input/touchscreen/Kconfig          |    6 +++++
 drivers/input/touchscreen/usbtouchscreen.c |   30 ++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 72e2712..a66e50a 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -406,6 +406,7 @@ config TOUCHSCREEN_USB_COMPOSITE
 	  - IRTOUCHSYSTEMS/UNITOP
 	  - IdealTEK URTC1000
 	  - GoTop Super_Q2/GogoPen/PenPower tablets
+	  - JASTEC USB Touch Controller/DigiTech DTR-02U
 
 	  Have a look at <http://linux.chapter7.ch/touchkit/> for
 	  a usage description and the required user-space stuff.
@@ -468,6 +469,11 @@ config TOUCHSCREEN_USB_GOTOP
 	bool "GoTop Super_Q2/GogoPen/PenPower tablet device support" if EMBEDDED
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
+config TOUCHSCREEN_USB_JASTEC
+	default y
+	bool "JASTEC/DigiTech DTR-02U USB touch controller device support" if EMBEDDED
+	depends on TOUCHSCREEN_USB_COMPOSITE
+
 config TOUCHSCREEN_TOUCHIT213
 	tristate "Sahara TouchIT-213 touchscreen"
 	select SERIO
diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index fb7cb9b..07c78c8 100644
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -13,6 +13,7 @@
  *  - IdealTEK URTC1000
  *  - General Touch
  *  - GoTop Super_Q2/GogoPen/PenPower tablets
+ *  - JASTEC USB touch controller/DigiTech DTR-02U
  *
  * Copyright (C) 2004-2007 by Daniel Ritz <daniel.ritz@gmx.ch>
  * Copyright (C) by Todd E. Johnson (mtouchusb.c)
@@ -118,6 +119,7 @@ enum {
 	DEVTYPE_IDEALTEK,
 	DEVTYPE_GENERAL_TOUCH,
 	DEVTYPE_GOTOP,
+	DEVTYPE_JASTEC,
 };
 
 #define USB_DEVICE_HID_CLASS(vend, prod) \
@@ -191,6 +193,10 @@ static struct usb_device_id usbtouch_devices[] = {
 	{USB_DEVICE(0x08f2, 0x00f4), .driver_info = DEVTYPE_GOTOP},
 #endif
 
+#ifdef CONFIG_TOUCHSCREEN_USB_JASTEC
+	{USB_DEVICE(0x0f92, 0x0001), .driver_info = DEVTYPE_JASTEC},
+#endif
+
 	{}
 };
 
@@ -563,6 +569,19 @@ static int gotop_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
 }
 #endif
 
+/*****************************************************************************
+ * JASTEC Part
+ */
+#ifdef CONFIG_TOUCHSCREEN_USB_JASTEC
+static int jastec_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
+{
+	dev->x = ((pkt[0] & 0x3f) << 6) | (pkt[2] & 0x3f);
+	dev->y = ((pkt[1] & 0x3f) << 6) | (pkt[3] & 0x3f);
+	dev->touch = (pkt[0] & 0x40) >> 6;
+	return 1;
+}
+#endif
+
 
 /*****************************************************************************
  * the different device descriptors
@@ -702,6 +721,17 @@ static struct usbtouch_device_info usbtouch_dev_info[] = {
 		.read_data	= gotop_read_data,
 	},
 #endif
+
+#ifdef CONFIG_TOUCHSCREEN_USB_JASTEC
+	[DEVTYPE_JASTEC] = {
+		.min_xc		= 0x0,
+		.max_xc		= 0x0fff,
+		.min_yc		= 0x0,
+		.max_yc		= 0x0fff,
+		.rept_size	= 4,
+		.read_data	= jastec_read_data,
+	},
+#endif
 };
 
 
-- 
1.6.0.4

