Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbYIDNA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbYIDNA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 09:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbYIDM76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:59:58 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43582 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765AbYIDM7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:59:53 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, Anssi Hannula <anssi.hannula@gmail.com>,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/5] HID: move pantherlord FF processing
Date: Thu,  4 Sep 2008 14:59:43 +0200
Message-Id: <1220533187-21848-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the force feedback precessing into a separate module.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/hid/Kconfig             |   16 +++
 drivers/hid/Makefile            |    1 +
 drivers/hid/hid-core.c          |    2 +
 drivers/hid/hid-dummy.c         |    3 +
 drivers/hid/hid-ids.h           |    2 +
 drivers/hid/hid-pl.c            |  205 +++++++++++++++++++++++++++++++++++++++
 drivers/hid/usbhid/Kconfig      |    8 --
 drivers/hid/usbhid/Makefile     |    3 -
 drivers/hid/usbhid/hid-ff.c     |    4 -
 drivers/hid/usbhid/hid-plff.c   |  139 --------------------------
 drivers/hid/usbhid/hid-quirks.c |    1 -
 include/linux/hid.h             |    1 -
 12 files changed, 229 insertions(+), 156 deletions(-)
 create mode 100644 drivers/hid/hid-pl.c
 delete mode 100644 drivers/hid/usbhid/hid-plff.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 46337a2..7220e6f 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -199,6 +199,22 @@ config HID_MONTEREY
 	---help---
 	Support for Monterey Genius KB29E.
 
+config HID_PANTHERLORD
+	tristate "Pantherlord"
+	default m
+	depends on USB_HID
+	---help---
+	Support for PantherLord/GreenAsia based device support (including
+	force feedback).
+
+config PANTHERLORD_FF
+	bool "Force feedback support"
+	depends on HID_PANTHERLORD
+	select INPUT_FF_MEMLESS
+	help
+	  Say Y here if you have a PantherLord/GreenAsia based game controller
+	  or adapter and want to enable force feedback support for it.
+
 config HID_PETALYNX
 	tristate "Petalynx"
 	default m
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 300ee00..e607068 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_HID_GYRATION)	+= hid-gyration.o
 obj-$(CONFIG_HID_LOGITECH)	+= hid-logitech.o
 obj-$(CONFIG_HID_MICROSOFT)	+= hid-microsoft.o
 obj-$(CONFIG_HID_MONTEREY)	+= hid-monterey.o
+obj-$(CONFIG_HID_PANTHERLORD)	+= hid-pl.o
 obj-$(CONFIG_HID_PETALYNX)	+= hid-petalynx.o
 obj-$(CONFIG_HID_SAMSUNG)	+= hid-samsung.o
 obj-$(CONFIG_HID_SONY)		+= hid-sony.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 798bb0a..3a12bb6 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1411,6 +1411,7 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DELORME, USB_DEVICE_ID_DELORME_EARTHMATE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DELORME, USB_DEVICE_ID_DELORME_EM_LT20) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ESSENTIAL_REALITY, USB_DEVICE_ID_ESSENTIAL_REALITY_P5) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_GAMERON, USB_DEVICE_ID_GAMERON_DUAL_PSX_ADAPTOR) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH, 0x0001) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH, 0x0002) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH, 0x0003) },
@@ -1426,6 +1427,7 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GOTOP, USB_DEVICE_ID_SUPER_Q2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GOTOP, USB_DEVICE_ID_GOGOPEN) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GOTOP, USB_DEVICE_ID_PENPOWER) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, 0x0003) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GRETAGMACBETH, USB_DEVICE_ID_GRETAGMACBETH_HUEY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GRIFFIN, USB_DEVICE_ID_POWERMATE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GRIFFIN, USB_DEVICE_ID_SOUNDKNOB) },
diff --git a/drivers/hid/hid-dummy.c b/drivers/hid/hid-dummy.c
index 69dcf9b..2f5d9a1 100644
--- a/drivers/hid/hid-dummy.c
+++ b/drivers/hid/hid-dummy.c
@@ -40,6 +40,9 @@ static int __init hid_dummy_init(void)
 #ifdef CONFIG_HID_MONTEREY_MODULE
 	HID_COMPAT_CALL_DRIVER(monterey);
 #endif
+#ifdef CONFIG_HID_PANTHERLORD_MODULE
+	HID_COMPAT_CALL_DRIVER(pantherlord);
+#endif
 #ifdef CONFIG_HID_PETALYNX_MODULE
 	HID_COMPAT_CALL_DRIVER(petalynx);
 #endif
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 0784a09..a4d9695 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -373,6 +373,8 @@
 #define USB_DEVICE_ID_QUAD_USB_JOYPAD	0x8800
 #define USB_DEVICE_ID_DUAL_USB_JOYPAD	0x8866
 
+#define USB_VENDOR_ID_GREENASIA		0x0e8f
+
 #define USB_VENDOR_ID_WISEGROUP_LTD	0x6666
 #define USB_VENDOR_ID_WISEGROUP_LTD2	0x6677
 #define USB_DEVICE_ID_SMARTJOY_DUAL_PLUS 0x8802
diff --git a/drivers/hid/hid-pl.c b/drivers/hid/hid-pl.c
new file mode 100644
index 0000000..b450084
--- /dev/null
+++ b/drivers/hid/hid-pl.c
@@ -0,0 +1,205 @@
+/*
+ *  Force feedback support for PantherLord/GreenAsia based devices
+ *
+ *  The devices are distributed under various names and the same USB device ID
+ *  can be used in both adapters and actual game controllers.
+ *
+ *  0810:0001 "Twin USB Joystick"
+ *   - tested with PantherLord USB/PS2 2in1 Adapter
+ *   - contains two reports, one for each port (HID_QUIRK_MULTI_INPUT)
+ *
+ *  0e8f:0003 "GreenAsia Inc.    USB Joystick     "
+ *   - tested with Köng Gaming gamepad
+ *
+ *  Copyright (c) 2007 Anssi Hannula <anssi.hannula@gmail.com>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+
+/* #define DEBUG */
+
+#define debug(format, arg...) pr_debug("hid-plff: " format "\n" , ## arg)
+
+#include <linux/input.h>
+#include <linux/usb.h>
+#include <linux/hid.h>
+
+#include "hid-ids.h"
+
+#ifdef CONFIG_PANTHERLORD_FF
+#include "usbhid/usbhid.h"
+
+struct plff_device {
+	struct hid_report *report;
+};
+
+static int hid_plff_play(struct input_dev *dev, void *data,
+			 struct ff_effect *effect)
+{
+	struct hid_device *hid = input_get_drvdata(dev);
+	struct plff_device *plff = data;
+	int left, right;
+
+	left = effect->u.rumble.strong_magnitude;
+	right = effect->u.rumble.weak_magnitude;
+	debug("called with 0x%04x 0x%04x", left, right);
+
+	left = left * 0x7f / 0xffff;
+	right = right * 0x7f / 0xffff;
+
+	plff->report->field[0]->value[2] = left;
+	plff->report->field[0]->value[3] = right;
+	debug("running with 0x%02x 0x%02x", left, right);
+	usbhid_submit_report(hid, plff->report, USB_DIR_OUT);
+
+	return 0;
+}
+
+static int plff_init(struct hid_device *hid)
+{
+	struct plff_device *plff;
+	struct hid_report *report;
+	struct hid_input *hidinput;
+	struct list_head *report_list =
+			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
+	struct list_head *report_ptr = report_list;
+	struct input_dev *dev;
+	int error;
+
+	/* The device contains one output report per physical device, all
+	   containing 1 field, which contains 4 ff00.0002 usages and 4 16bit
+	   absolute values.
+
+	   The input reports also contain a field which contains
+	   8 ff00.0001 usages and 8 boolean values. Their meaning is
+	   currently unknown. */
+
+	if (list_empty(report_list)) {
+		printk(KERN_ERR "hid-plff: no output reports found\n");
+		return -ENODEV;
+	}
+
+	list_for_each_entry(hidinput, &hid->inputs, list) {
+
+		report_ptr = report_ptr->next;
+
+		if (report_ptr == report_list) {
+			printk(KERN_ERR "hid-plff: required output report is missing\n");
+			return -ENODEV;
+		}
+
+		report = list_entry(report_ptr, struct hid_report, list);
+		if (report->maxfield < 1) {
+			printk(KERN_ERR "hid-plff: no fields in the report\n");
+			return -ENODEV;
+		}
+
+		if (report->field[0]->report_count < 4) {
+			printk(KERN_ERR "hid-plff: not enough values in the field\n");
+			return -ENODEV;
+		}
+
+		plff = kzalloc(sizeof(struct plff_device), GFP_KERNEL);
+		if (!plff)
+			return -ENOMEM;
+
+		dev = hidinput->input;
+
+		set_bit(FF_RUMBLE, dev->ffbit);
+
+		error = input_ff_create_memless(dev, plff, hid_plff_play);
+		if (error) {
+			kfree(plff);
+			return error;
+		}
+
+		plff->report = report;
+		plff->report->field[0]->value[0] = 0x00;
+		plff->report->field[0]->value[1] = 0x00;
+		plff->report->field[0]->value[2] = 0x00;
+		plff->report->field[0]->value[3] = 0x00;
+		usbhid_submit_report(hid, plff->report, USB_DIR_OUT);
+	}
+
+	printk(KERN_INFO "hid-plff: Force feedback for PantherLord/GreenAsia "
+	       "devices by Anssi Hannula <anssi.hannula@gmail.com>\n");
+
+	return 0;
+}
+#else
+static inline int plff_init(struct hid_device *hid)
+{
+	return 0;
+}
+#endif
+
+static int pl_probe(struct hid_device *hdev, const struct hid_device_id *id)
+{
+	int ret;
+
+	if (id->driver_data)
+		hdev->quirks |= HID_QUIRK_MULTI_INPUT;
+
+	ret = hid_parse(hdev);
+	if (ret) {
+		dev_err(&hdev->dev, "parse failed\n");
+		goto err;
+	}
+
+	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT & ~HID_CONNECT_FF);
+	if (ret) {
+		dev_err(&hdev->dev, "hw start failed\n");
+		goto err;
+	}
+
+	plff_init(hdev);
+
+	return 0;
+err:
+	return ret;
+}
+
+static const struct hid_device_id pl_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_GAMERON, USB_DEVICE_ID_GAMERON_DUAL_PSX_ADAPTOR),
+		.driver_data = 1 }, /* Twin USB Joystick */
+	{ HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, 0x0003), }, /* GreenAsia Inc. USB Joystick */
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, pl_devices);
+
+static struct hid_driver pl_driver = {
+	.name = "pantherlord",
+	.id_table = pl_devices,
+	.probe = pl_probe,
+};
+
+static int pl_init(void)
+{
+	return hid_register_driver(&pl_driver);
+}
+
+static void pl_exit(void)
+{
+	hid_unregister_driver(&pl_driver);
+}
+
+module_init(pl_init);
+module_exit(pl_exit);
+MODULE_LICENSE("GPL");
+
+HID_COMPAT_LOAD_DRIVER(pantherlord);
diff --git a/drivers/hid/usbhid/Kconfig b/drivers/hid/usbhid/Kconfig
index 0e7e2e6..02c8228 100644
--- a/drivers/hid/usbhid/Kconfig
+++ b/drivers/hid/usbhid/Kconfig
@@ -44,14 +44,6 @@ config HID_PID
 	  feedback for it. Microsoft Sidewinder Force Feedback 2 is one of such
 	  devices.
 
-config PANTHERLORD_FF
-	bool "PantherLord/GreenAsia based device support"
-	depends on HID_FF
-	select INPUT_FF_MEMLESS if USB_HID
-	help
-	  Say Y here if you have a PantherLord/GreenAsia based game controller
-	  or adapter and want to enable force feedback support for it.
-
 config THRUSTMASTER_FF
 	bool "ThrustMaster devices support"
 	depends on HID_FF
diff --git a/drivers/hid/usbhid/Makefile b/drivers/hid/usbhid/Makefile
index 224c62d..0ee4803 100644
--- a/drivers/hid/usbhid/Makefile
+++ b/drivers/hid/usbhid/Makefile
@@ -13,9 +13,6 @@ endif
 ifeq ($(CONFIG_HID_PID),y)
 	usbhid-objs	+= hid-pidff.o
 endif
-ifeq ($(CONFIG_PANTHERLORD_FF),y)
-	usbhid-objs	+= hid-plff.o
-endif
 ifeq ($(CONFIG_THRUSTMASTER_FF),y)
 	usbhid-objs	+= hid-tmff.o
 endif
diff --git a/drivers/hid/usbhid/hid-ff.c b/drivers/hid/usbhid/hid-ff.c
index 8891f60..a868eef 100644
--- a/drivers/hid/usbhid/hid-ff.c
+++ b/drivers/hid/usbhid/hid-ff.c
@@ -50,10 +50,6 @@ struct hid_ff_initializer {
  * be a PID device
  */
 static struct hid_ff_initializer inits[] = {
-#ifdef CONFIG_PANTHERLORD_FF
-	{ 0x810, 0x0001, hid_plff_init }, /* "Twin USB Joystick" */
-	{ 0xe8f, 0x0003, hid_plff_init }, /* "GreenAsia Inc.    USB Joystick     " */
-#endif
 #ifdef CONFIG_THRUSTMASTER_FF
 	{ 0x44f, 0xb300, hid_tmff_init },
 	{ 0x44f, 0xb304, hid_tmff_init },
diff --git a/drivers/hid/usbhid/hid-plff.c b/drivers/hid/usbhid/hid-plff.c
deleted file mode 100644
index 9eb83cf..0000000
--- a/drivers/hid/usbhid/hid-plff.c
+++ /dev/null
@@ -1,139 +0,0 @@
-/*
- *  Force feedback support for PantherLord/GreenAsia based devices
- *
- *  The devices are distributed under various names and the same USB device ID
- *  can be used in both adapters and actual game controllers.
- *
- *  0810:0001 "Twin USB Joystick"
- *   - tested with PantherLord USB/PS2 2in1 Adapter
- *   - contains two reports, one for each port (HID_QUIRK_MULTI_INPUT)
- *
- *  0e8f:0003 "GreenAsia Inc.    USB Joystick     "
- *   - tested with Köng Gaming gamepad
- *
- *  Copyright (c) 2007 Anssi Hannula <anssi.hannula@gmail.com>
- */
-
-/*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- */
-
-
-/* #define DEBUG */
-
-#define debug(format, arg...) pr_debug("hid-plff: " format "\n" , ## arg)
-
-#include <linux/input.h>
-#include <linux/usb.h>
-#include <linux/hid.h>
-#include "usbhid.h"
-
-struct plff_device {
-	struct hid_report *report;
-};
-
-static int hid_plff_play(struct input_dev *dev, void *data,
-			 struct ff_effect *effect)
-{
-	struct hid_device *hid = input_get_drvdata(dev);
-	struct plff_device *plff = data;
-	int left, right;
-
-	left = effect->u.rumble.strong_magnitude;
-	right = effect->u.rumble.weak_magnitude;
-	debug("called with 0x%04x 0x%04x", left, right);
-
-	left = left * 0x7f / 0xffff;
-	right = right * 0x7f / 0xffff;
-
-	plff->report->field[0]->value[2] = left;
-	plff->report->field[0]->value[3] = right;
-	debug("running with 0x%02x 0x%02x", left, right);
-	usbhid_submit_report(hid, plff->report, USB_DIR_OUT);
-
-	return 0;
-}
-
-int hid_plff_init(struct hid_device *hid)
-{
-	struct plff_device *plff;
-	struct hid_report *report;
-	struct hid_input *hidinput;
-	struct list_head *report_list =
-			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
-	struct list_head *report_ptr = report_list;
-	struct input_dev *dev;
-	int error;
-
-	/* The device contains one output report per physical device, all
-	   containing 1 field, which contains 4 ff00.0002 usages and 4 16bit
-	   absolute values.
-
-	   The input reports also contain a field which contains
-	   8 ff00.0001 usages and 8 boolean values. Their meaning is
-	   currently unknown. */
-
-	if (list_empty(report_list)) {
-		printk(KERN_ERR "hid-plff: no output reports found\n");
-		return -ENODEV;
-	}
-
-	list_for_each_entry(hidinput, &hid->inputs, list) {
-
-		report_ptr = report_ptr->next;
-
-		if (report_ptr == report_list) {
-			printk(KERN_ERR "hid-plff: required output report is missing\n");
-			return -ENODEV;
-		}
-
-		report = list_entry(report_ptr, struct hid_report, list);
-		if (report->maxfield < 1) {
-			printk(KERN_ERR "hid-plff: no fields in the report\n");
-			return -ENODEV;
-		}
-
-		if (report->field[0]->report_count < 4) {
-			printk(KERN_ERR "hid-plff: not enough values in the field\n");
-			return -ENODEV;
-		}
-
-		plff = kzalloc(sizeof(struct plff_device), GFP_KERNEL);
-		if (!plff)
-			return -ENOMEM;
-
-		dev = hidinput->input;
-
-		set_bit(FF_RUMBLE, dev->ffbit);
-
-		error = input_ff_create_memless(dev, plff, hid_plff_play);
-		if (error) {
-			kfree(plff);
-			return error;
-		}
-
-		plff->report = report;
-		plff->report->field[0]->value[0] = 0x00;
-		plff->report->field[0]->value[1] = 0x00;
-		plff->report->field[0]->value[2] = 0x00;
-		plff->report->field[0]->value[3] = 0x00;
-		usbhid_submit_report(hid, plff->report, USB_DIR_OUT);
-	}
-
-	printk(KERN_INFO "hid-plff: Force feedback for PantherLord/GreenAsia "
-	       "devices by Anssi Hannula <anssi.hannula@gmail.com>\n");
-
-	return 0;
-}
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index d40f009..47ebe04 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -32,7 +32,6 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_AASHIMA, USB_DEVICE_ID_AASHIMA_PREDATOR, HID_QUIRK_BADPAD },
 	{ USB_VENDOR_ID_ALPS, USB_DEVICE_ID_IBM_GAMEPAD, HID_QUIRK_BADPAD },
 	{ USB_VENDOR_ID_CHIC, USB_DEVICE_ID_CHIC_GAMEPAD, HID_QUIRK_BADPAD },
-	{ USB_VENDOR_ID_GAMERON, USB_DEVICE_ID_GAMERON_DUAL_PSX_ADAPTOR, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_DRIVING, HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FLYING, HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FIGHTING, HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 164ce7f..260beba 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -760,7 +760,6 @@ void usbhid_set_leds(struct hid_device *hid);
 #ifdef CONFIG_HID_FF
 int hid_ff_init(struct hid_device *hid);
 
-int hid_plff_init(struct hid_device *hid);
 int hid_tmff_init(struct hid_device *hid);
 int hid_zpff_init(struct hid_device *hid);
 #ifdef CONFIG_HID_PID
-- 
1.6.0

