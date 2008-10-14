Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbYJNOOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbYJNOOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 10:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYJNOOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 10:14:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42090 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbYJNOO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 10:14:29 -0400
Date: Tue, 14 Oct 2008 11:09:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Jiri Kosina <jikos@jikos.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] Adds a driver for Bright ABNT2 Brazilian keyboard
Message-ID: <20081014110913.22f28ea7@pedra.chehab.org>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This keyboard needs to reset the LEDS during probe.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/hid/Kconfig      |    7 ++++
 drivers/hid/Makefile     |    1 +
 drivers/hid/hid-bright.c |   71 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-core.c   |    1 +
 drivers/hid/hid-ids.h    |    3 ++
 5 files changed, 83 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hid/hid-bright.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 46337a2..14bc710 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -110,6 +110,13 @@ config HID_BELKIN
 	---help---
 	Support for Belkin Flip KVM and Wireless keyboard.
 
+config HID_BRIGHT
+	tristate "Bright"
+	default m
+	depends on USB_HID
+	---help---
+	Support for Bright ABNT-2 keyboard.
+
 config HID_CHERRY
 	tristate "Cherry"
 	default m
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 300ee00..f5a94f4 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -23,6 +23,7 @@ endif
 obj-$(CONFIG_HID_A4TECH)	+= hid-a4tech.o
 obj-$(CONFIG_HID_APPLE)		+= hid-apple.o
 obj-$(CONFIG_HID_BELKIN)	+= hid-belkin.o
+obj-$(CONFIG_HID_BRIGHT)	+= hid-bright.o
 obj-$(CONFIG_HID_CHERRY)	+= hid-cherry.o
 obj-$(CONFIG_HID_CHICONY)	+= hid-chicony.o
 obj-$(CONFIG_HID_CYPRESS)	+= hid-cypress.o
diff --git a/drivers/hid/hid-bright.c b/drivers/hid/hid-bright.c
new file mode 100644
index 0000000..38517a1
--- /dev/null
+++ b/drivers/hid/hid-bright.c
@@ -0,0 +1,71 @@
+/*
+ *  HID driver for some bright "special" devices
+ *
+ *  Copyright (c) 2008 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * Based on hid-dell driver
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
+static int bright_probe(struct hid_device *hdev, const struct hid_device_id *id)
+{
+	int ret;
+
+	ret = hid_parse(hdev);
+	if (ret) {
+		dev_err(&hdev->dev, "parse failed\n");
+		goto err_free;
+	}
+
+	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
+	if (ret) {
+		dev_err(&hdev->dev, "hw start failed\n");
+		goto err_free;
+	}
+
+	usbhid_set_leds(hdev);
+
+	return 0;
+err_free:
+	return ret;
+}
+
+static const struct hid_device_id bright_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BRIGHT, USB_DEVICE_ID_BRIGHT_ABNT2) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, bright_devices);
+
+static struct hid_driver bright_driver = {
+	.name = "bright",
+	.id_table = bright_devices,
+	.probe = bright_probe,
+};
+
+static int bright_init(void)
+{
+	return hid_register_driver(&bright_driver);
+}
+
+static void bright_exit(void)
+{
+	hid_unregister_driver(&bright_driver);
+}
+
+module_init(bright_init);
+module_exit(bright_exit);
+MODULE_LICENSE("GPL");
+
+HID_COMPAT_LOAD_DRIVER(bright);
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 08cc633..1fc1d5c 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1252,6 +1252,7 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BRIGHT, USB_DEVICE_ID_BRIGHT_ABNT2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHERRY, USB_DEVICE_ID_CHERRY_CYMOTION) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_TACTICAL_PAD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_1) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index b74c505..078ede0 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -99,6 +99,9 @@
 #define USB_VENDOR_ID_BELKIN           0x050d
 #define USB_DEVICE_ID_FLIP_KVM         0x3201
 
+#define USB_VENDOR_ID_BRIGHT		0x1241
+#define USB_DEVICE_ID_BRIGHT_ABNT2	0x1503
+
 #define USB_VENDOR_ID_BERKSHIRE		0x0c98
 #define USB_DEVICE_ID_BERKSHIRE_PCWD	0x1140
 
-- 
1.5.5.1

