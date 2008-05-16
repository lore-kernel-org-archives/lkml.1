Return-Path: <linux-kernel-owner+w=401wt.eu-S1756946AbYEPJw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbYEPJw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 05:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbYEPJwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 05:52:47 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:49857 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752583AbYEPJwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 05:52:45 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com, Jiri Slaby <jirislaby@gmail.com>,
       Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 06/10] HID: move logitech report quirks
Date: Fri, 16 May 2008 11:49:19 +0200
Message-Id: <1210931362-18422-6-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1210931362-18422-5-git-send-email-jirislaby@gmail.com>
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-2-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-3-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-4-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-5-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move them from core code to a separate driver.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/Kconfig             |   13 +++++++
 drivers/hid/Makefile            |    2 +
 drivers/hid/hid-core.c          |    5 +++
 drivers/hid/hid-logitech.c      |   74 +++++++++++++++++++++++++++++++++++++++
 drivers/hid/usbhid/hid-quirks.c |   23 ------------
 include/linux/hid.h             |    1 -
 6 files changed, 94 insertions(+), 24 deletions(-)
 create mode 100644 drivers/hid/hid-logitech.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index cacf89e..066e8c0 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -67,4 +67,17 @@ config HIDRAW
 
 source "drivers/hid/usbhid/Kconfig"
 
+menu "Special HID drivers"
+	depends on HID
+
+config HID_LOGITECH
+	tristate "Logitech"
+	default m
+	depends on USB_HID
+	---help---
+	Support for some Logitech devices which breaks less or more
+	HID specification.
+
+endmenu
+
 endif # HID_SUPPORT
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 275dc52..cae036b 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -8,6 +8,8 @@ obj-$(CONFIG_HID)		+= hid.o
 hid-$(CONFIG_HID_DEBUG)		+= hid-debug.o
 hid-$(CONFIG_HIDRAW)		+= hidraw.o
 
+obj-$(CONFIG_HID_LOGITECH)	+= hid-logitech.o
+
 obj-$(CONFIG_USB_HID)		+= usbhid/
 obj-$(CONFIG_USB_MOUSE)		+= usbhid/
 obj-$(CONFIG_USB_KBD)		+= usbhid/
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 984d5d8..4b1b814 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -33,6 +33,8 @@
 #include <linux/hid-debug.h>
 #include <linux/hidraw.h>
 
+#include "hid-ids.h"
+
 /*
  * Version Information
  */
@@ -1124,6 +1126,9 @@ static const struct hid_device_id *hid_match_id(struct hid_device *hdev,
 }
 
 static const struct hid_device_id hid_blacklist[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER_2) },
 	{ }
 };
 
diff --git a/drivers/hid/hid-logitech.c b/drivers/hid/hid-logitech.c
new file mode 100644
index 0000000..5b145c9
--- /dev/null
+++ b/drivers/hid/hid-logitech.c
@@ -0,0 +1,74 @@
+/*
+ *  HID driver for some logitech "special" devices
+ *
+ *  Copyright (c) 1999 Andreas Gal
+ *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
+ *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
+ *  Copyright (c) 2006-2007 Jiri Kosina
+ *  Copyright (c) 2007 Paul Walmsley
+ *  Copyright (c) 2008 Jiri Slaby
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
+#define LOGITECH_RDESC	0x1
+
+/*
+ * Certain Logitech keyboards send in report #3 keys which are far
+ * above the logical maximum described in descriptor. This extends
+ * the original value of 0x28c of logical maximum to 0x104d
+ */
+static void lg_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+		unsigned int rsize)
+{
+	if (rsize >= 90 && rdesc[83] == 0x26
+			&& rdesc[84] == 0x8c
+			&& rdesc[85] == 0x02) {
+		dev_info(&hdev->dev, "fixing up Logitech keyboard report "
+				"descriptor\n");
+		rdesc[84] = rdesc[89] = 0x4d;
+		rdesc[85] = rdesc[90] = 0x10;
+	}
+}
+
+static const struct hid_device_id lg_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER),
+		.driver_data = LOGITECH_RDESC },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER),
+		.driver_data = LOGITECH_RDESC },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER_2),
+		.driver_data = LOGITECH_RDESC },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, lg_devices);
+
+static struct hid_driver lg_driver = {
+	.name = "logitech",
+	.id_table = lg_devices,
+	.report_fixup = lg_report_fixup,
+};
+
+static int lg_init(void)
+{
+	return hid_register_driver(&lg_driver);
+}
+
+static void lg_exit(void)
+{
+	hid_unregister_driver(&lg_driver);
+}
+
+module_init(lg_init);
+module_exit(lg_exit);
+MODULE_LICENSE("GPL");
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 7694edc..e2941b3 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -330,9 +330,6 @@ static const struct hid_rdesc_blacklist {
 
 	{ USB_VENDOR_ID_CHERRY, USB_DEVICE_ID_CHERRY_CYMOTION, HID_QUIRK_RDESC_CYMOTION },
 
-	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER, HID_QUIRK_RDESC_LOGITECH },
-	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER, HID_QUIRK_RDESC_LOGITECH },
-	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER_2, HID_QUIRK_RDESC_LOGITECH },
 	{ USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_DESKTOP_RECV_1028, HID_QUIRK_RDESC_MICROSOFT_RECV_1028 },
 
 	{ USB_VENDOR_ID_MONTEREY, USB_DEVICE_ID_GENIUS_KB29E, HID_QUIRK_RDESC_BUTTON_CONSUMER },
@@ -602,23 +599,6 @@ static void usbhid_fixup_cymotion_descriptor(char *rdesc, int rsize)
 	}
 }
 
-
-/*
- * Certain Logitech keyboards send in report #3 keys which are far
- * above the logical maximum described in descriptor. This extends
- * the original value of 0x28c of logical maximum to 0x104d
- */
-static void usbhid_fixup_logitech_descriptor(unsigned char *rdesc, int rsize)
-{
-	if (rsize >= 90 && rdesc[83] == 0x26
-			&& rdesc[84] == 0x8c
-			&& rdesc[85] == 0x02) {
-		printk(KERN_INFO "Fixing up Logitech keyboard report descriptor\n");
-		rdesc[84] = rdesc[89] = 0x4d;
-		rdesc[85] = rdesc[90] = 0x10;
-	}
-}
-
 static void usbhid_fixup_sunplus_wdesktop(unsigned char *rdesc, int rsize)
 {
 	if (rsize >= 107 && rdesc[104] == 0x26
@@ -744,9 +724,6 @@ static void __usbhid_fixup_report_descriptor(__u32 quirks, char *rdesc, unsigned
 	if ((quirks & HID_QUIRK_RDESC_CYMOTION))
 		usbhid_fixup_cymotion_descriptor(rdesc, rsize);
 
-	if (quirks & HID_QUIRK_RDESC_LOGITECH)
-		usbhid_fixup_logitech_descriptor(rdesc, rsize);
-
 	if (quirks & HID_QUIRK_RDESC_SWAPPED_MIN_MAX)
 		usbhid_fixup_cypress_descriptor(rdesc, rsize);
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index e4d718f..96f64d7 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -293,7 +293,6 @@ struct hid_item {
  */
 
 #define HID_QUIRK_RDESC_CYMOTION		0x00000001
-#define HID_QUIRK_RDESC_LOGITECH		0x00000002
 #define HID_QUIRK_RDESC_SWAPPED_MIN_MAX		0x00000004
 #define HID_QUIRK_RDESC_PETALYNX		0x00000008
 #define HID_QUIRK_RDESC_MACBOOK_JIS		0x00000010
-- 
1.5.4.5

