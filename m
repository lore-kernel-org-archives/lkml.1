Return-Path: <linux-kernel-owner+w=401wt.eu-S1752275AbZLaINZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbZLaINZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 03:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbZLaINY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 03:13:24 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:43152 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbZLaINX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 03:13:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=lRLBLUav2vqVti86aw0cU0iwLWc2HY3Ne8Hse5hEX8MplnzQ8NN4CYemYbZuCANQqz
         0+7w4LTcbZ4HOyyrkJ3yv0Zf2hjjzId3FPOSAwEyL2I2vKTmU1f8oXu/GKMJq0lctkns
         AWLYvp/6ULp+7cWEYhCHWOM/8DuIbqQBSrApE=
MIME-Version: 1.0
Date: Thu, 31 Dec 2009 09:13:22 +0100
Message-ID: <3711715e0912310013u25e921cbqe6abb7c1621109e@mail.gmail.com>
Subject: [PATCH] HID: driver for BTC "Emprex 3009URF III Vista MCE Remote" 
	quirky remote
From: Wayne Thomas <waynethomas69@gmail.com>
To: jkosina@suse.cz, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HID: driver for BTC "Emprex 3009URF III Vista MCE Remote" quirky remote

The Behavior Tech. Computer Corp. (BTC) remote branded as "Emprex 3009URF III
Vista Remote Controller" uses non-standard mappings for all of its 'special
purpose' keys (0xffbc usage page).  Applies cleanly to 2.6.30 and 2.6.32
(other versions not tested).
scripts/scriptpatch.pl reports 13 styling errors in hid-btc.c
("break;" should be on trailing lines)
but have not changed them to maintain styling consistency with existing drivers.

Signed-off-by: Wayne Thomas <waynethomas69@gmail.com>

diff -uprN linux/drivers/hid/hid-btc.c linux-working/drivers/hid/hid-btc.c
--- linux/drivers/hid/hid-btc.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-working/drivers/hid/hid-btc.c	2009-12-13 13:41:34.000000000 +0100
@@ -0,0 +1,75 @@
+/*
+ *  HID driver for BTC Emprex remote
+ *
+ *  Copyright (c) 2009 Wayne Thomas
+ *  based on hid-topseed driver
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/hid.h>
+#include <linux/module.h>
+
+#include "hid-ids.h"
+
+#define btc_map_key_clear(c)	hid_map_usage_clear(hi, usage, bit, max, \
+					EV_KEY, (c))
+static int btc_input_mapping(struct hid_device *hdev, struct hid_input *hi,
+		struct hid_field *field, struct hid_usage *usage,
+		unsigned long **bit, int *max)
+{
+	if ((usage->hid & HID_USAGE_PAGE) != 0x0ffbc0000)
+		return 0;
+
+	switch (usage->hid & HID_USAGE) {
+	case 0x00d: btc_map_key_clear(KEY_MEDIA);	break;
+	case 0x024: btc_map_key_clear(KEY_MENU);	break;
+	case 0x048: btc_map_key_clear(KEY_TV2);		break;
+	case 0x025: btc_map_key_clear(KEY_TV);		break;
+	case 0x047: btc_map_key_clear(KEY_MP3);		break;
+	case 0x049: btc_map_key_clear(KEY_CAMERA);	break;
+	case 0x04a: btc_map_key_clear(KEY_VIDEO);	break;
+	case 0x050: btc_map_key_clear(KEY_RADIO);	break;
+	case 0x05b: btc_map_key_clear(KEY_RED);		break;
+	case 0x05c: btc_map_key_clear(KEY_GREEN);	break;
+	case 0x05d: btc_map_key_clear(KEY_YELLOW);	break;
+	case 0x05e: btc_map_key_clear(KEY_BLUE);	break;
+	case 0x05a: btc_map_key_clear(KEY_TEXT);	break;
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static const struct hid_device_id btc_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BTC, USB_DEVICE_ID_BTC_EMPREX_REMOTE) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, btc_devices);
+
+static struct hid_driver btc_driver = {
+	.name = "btc",
+	.id_table = btc_devices,
+	.input_mapping = btc_input_mapping,
+};
+
+static int btc_init(void)
+{
+	return hid_register_driver(&btc_driver);
+}
+
+static void btc_exit(void)
+{
+	hid_unregister_driver(&btc_driver);
+}
+
+module_init(btc_init);
+module_exit(btc_exit);
+MODULE_LICENSE("GPL");
diff -uprN linux/drivers/hid/hid-core.c linux-working/drivers/hid/hid-core.c
--- linux/drivers/hid/hid-core.c	2009-12-03 04:51:21.000000000 +0100
+++ linux-working/drivers/hid/hid-core.c	2009-12-13 13:44:19.000000000 +0100
@@ -1290,6 +1290,7 @@ static const struct hid_device_id hid_bl
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BTC, USB_DEVICE_ID_BTC_EMPREX_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHERRY, USB_DEVICE_ID_CHERRY_CYMOTION) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_TACTICAL_PAD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_1) },
diff -uprN linux/drivers/hid/hid-ids.h linux-working/drivers/hid/hid-ids.h
--- linux/drivers/hid/hid-ids.h	2009-12-03 04:51:21.000000000 +0100
+++ linux-working/drivers/hid/hid-ids.h	2009-12-13 13:45:06.000000000 +0100
@@ -113,6 +113,9 @@
 #define USB_VENDOR_ID_BERKSHIRE		0x0c98
 #define USB_DEVICE_ID_BERKSHIRE_PCWD	0x1140

+#define USB_VENDOR_ID_BTC		0x046e
+#define USB_DEVICE_ID_BTC_EMPREX_REMOTE	0x5578
+
 #define USB_VENDOR_ID_CH		0x068e
 #define USB_DEVICE_ID_CH_PRO_PEDALS	0x00f2
 #define USB_DEVICE_ID_CH_COMBATSTICK	0x00f4
diff -uprN linux/drivers/hid/Kconfig linux-working/drivers/hid/Kconfig
--- linux/drivers/hid/Kconfig	2009-12-03 04:51:21.000000000 +0100
+++ linux-working/drivers/hid/Kconfig	2009-12-13 13:46:58.000000000 +0100
@@ -80,6 +80,13 @@ config HID_BELKIN
 	---help---
 	Support for Belkin Flip KVM and Wireless keyboard.

+config HID_BTC
+	tristate "BTC Emprex remote control support" if EMBEDDED
+	depends on USB_HID
+	default y
+	---help---
+	Say Y if you have a BTC Emprex remote control.
+
 config HID_CHERRY
 	tristate "Cherry" if EMBEDDED
 	depends on USB_HID
diff -uprN linux/drivers/hid/Makefile linux-working/drivers/hid/Makefile
--- linux/drivers/hid/Makefile	2009-12-03 04:51:21.000000000 +0100
+++ linux-working/drivers/hid/Makefile	2009-12-13 13:48:21.000000000 +0100
@@ -22,6 +22,7 @@ endif
 obj-$(CONFIG_HID_A4TECH)	+= hid-a4tech.o
 obj-$(CONFIG_HID_APPLE)		+= hid-apple.o
 obj-$(CONFIG_HID_BELKIN)	+= hid-belkin.o
+obj-$(CONFIG_HID_BTC)		+= hid-btc.o
 obj-$(CONFIG_HID_CHERRY)	+= hid-cherry.o
 obj-$(CONFIG_HID_CHICONY)	+= hid-chicony.o
 obj-$(CONFIG_HID_CYPRESS)	+= hid-cypress.o
