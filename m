Return-Path: <linux-kernel-owner+w=401wt.eu-S1758515AbYIDNBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515AbYIDNBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 09:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757800AbYIDNAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 09:00:00 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43583 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbYIDM7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:59:53 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, Anssi Hannula <anssi.hannula@gmail.com>,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 3/5] HID: move zeroplus FF processing
Date: Thu,  4 Sep 2008 14:59:45 +0200
Message-Id: <1220533187-21848-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0
In-Reply-To: <1220533187-21848-2-git-send-email-jirislaby@gmail.com>
References: <1220533187-21848-1-git-send-email-jirislaby@gmail.com>
 <1220533187-21848-2-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/hid/Kconfig           |    8 ++
 drivers/hid/Makefile          |    1 +
 drivers/hid/hid-core.c        |    2 +
 drivers/hid/hid-dummy.c       |    3 +
 drivers/hid/hid-ids.h         |    2 +
 drivers/hid/hid-zpff.c        |  162 +++++++++++++++++++++++++++++++++++++++++
 drivers/hid/usbhid/Kconfig    |    8 --
 drivers/hid/usbhid/Makefile   |    3 -
 drivers/hid/usbhid/hid-ff.c   |    4 -
 drivers/hid/usbhid/hid-zpff.c |  107 ---------------------------
 include/linux/hid.h           |    1 -
 11 files changed, 178 insertions(+), 123 deletions(-)
 create mode 100644 drivers/hid/hid-zpff.c
 delete mode 100644 drivers/hid/usbhid/hid-zpff.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 268fcd1..e4d5263 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -252,6 +252,14 @@ config THRUSTMASTER_FF
 	  Say Y here if you have a THRUSTMASTER FireStore Dual Power 2 or
 	  a THRUSTMASTER Ferrari GT Rumble Force or Force Feedback Wheel.
 
+config ZEROPLUS_FF
+	tristate "Zeroplus based game controller support"
+	default m
+	depends on USB_HID
+	select INPUT_FF_MEMLESS
+	help
+	  Say Y here if you have a Zeroplus based game controller.
+
 endmenu
 
 endif # HID_SUPPORT
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 9bd6daf..767f295 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_HID_SAMSUNG)	+= hid-samsung.o
 obj-$(CONFIG_HID_SONY)		+= hid-sony.o
 obj-$(CONFIG_HID_SUNPLUS)	+= hid-sunplus.o
 obj-$(CONFIG_THRUSTMASTER_FF)	+= hid-tmff.o
+obj-$(CONFIG_ZEROPLUS_FF)	+= hid-zpff.o
 
 obj-$(CONFIG_USB_HID)		+= usbhid/
 obj-$(CONFIG_USB_MOUSE)		+= usbhid/
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index e6624d9..92c16e1 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1528,6 +1528,8 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP, USB_DEVICE_ID_1_PHIDGETSERVO_20) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP, USB_DEVICE_ID_8_8_4_IF_KIT) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_YEALINK, USB_DEVICE_ID_YEALINK_P1K_P4K_B2K) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0005) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0030) },
 	{ }
 };
 
diff --git a/drivers/hid/hid-dummy.c b/drivers/hid/hid-dummy.c
index ae122a1..54d1fb6 100644
--- a/drivers/hid/hid-dummy.c
+++ b/drivers/hid/hid-dummy.c
@@ -58,6 +58,9 @@ static int __init hid_dummy_init(void)
 #ifdef CONFIG_THRUSTMASTER_FF_MODULE
 	HID_COMPAT_CALL_DRIVER(thrustmaster);
 #endif
+#ifdef CONFIG_ZEROPLUS_FF_MODULE
+	HID_COMPAT_CALL_DRIVER(zeroplus);
+#endif
 
 	return -EIO;
 }
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 30dcc93..11b0720 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -375,6 +375,8 @@
 #define USB_DEVICE_ID_QUAD_USB_JOYPAD	0x8800
 #define USB_DEVICE_ID_DUAL_USB_JOYPAD	0x8866
 
+#define USB_VENDOR_ID_ZEROPLUS		0x0c12
+
 #define USB_VENDOR_ID_GREENASIA		0x0e8f
 
 #define USB_VENDOR_ID_WISEGROUP_LTD	0x6666
diff --git a/drivers/hid/hid-zpff.c b/drivers/hid/hid-zpff.c
new file mode 100644
index 0000000..9ed04ee
--- /dev/null
+++ b/drivers/hid/hid-zpff.c
@@ -0,0 +1,162 @@
+/*
+ *  Force feedback support for Zeroplus based devices
+ *
+ *  Copyright (c) 2005, 2006 Anssi Hannula <anssi.hannula@gmail.com>
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
+#include <linux/hid.h>
+#include <linux/input.h>
+#include <linux/usb.h>
+
+#include "hid-ids.h"
+
+#include "usbhid/usbhid.h"
+
+struct zpff_device {
+	struct hid_report *report;
+};
+
+static int zpff_play(struct input_dev *dev, void *data,
+			 struct ff_effect *effect)
+{
+	struct hid_device *hid = input_get_drvdata(dev);
+	struct zpff_device *zpff = data;
+	int left, right;
+
+	/*
+	 * The following is specified the other way around in the Zeroplus
+	 * datasheet but the order below is correct for the XFX Executioner;
+	 * however it is possible that the XFX Executioner is an exception
+	 */
+
+	left = effect->u.rumble.strong_magnitude;
+	right = effect->u.rumble.weak_magnitude;
+	dbg_hid("called with 0x%04x 0x%04x\n", left, right);
+
+	left = left * 0x7f / 0xffff;
+	right = right * 0x7f / 0xffff;
+
+	zpff->report->field[2]->value[0] = left;
+	zpff->report->field[3]->value[0] = right;
+	dbg_hid("running with 0x%02x 0x%02x\n", left, right);
+	usbhid_submit_report(hid, zpff->report, USB_DIR_OUT);
+
+	return 0;
+}
+
+static int zpff_init(struct hid_device *hid)
+{
+	struct zpff_device *zpff;
+	struct hid_report *report;
+	struct hid_input *hidinput = list_entry(hid->inputs.next,
+						struct hid_input, list);
+	struct list_head *report_list =
+			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
+	struct input_dev *dev = hidinput->input;
+	int error;
+
+	if (list_empty(report_list)) {
+		printk(KERN_ERR "hid-zpff: no output report found\n");
+		return -ENODEV;
+	}
+
+	report = list_entry(report_list->next, struct hid_report, list);
+
+	if (report->maxfield < 4) {
+		printk(KERN_ERR "hid-zpff: not enough fields in report\n");
+		return -ENODEV;
+	}
+
+	zpff = kzalloc(sizeof(struct zpff_device), GFP_KERNEL);
+	if (!zpff)
+		return -ENOMEM;
+
+	set_bit(FF_RUMBLE, dev->ffbit);
+
+	error = input_ff_create_memless(dev, zpff, zpff_play);
+	if (error) {
+		kfree(zpff);
+		return error;
+	}
+
+	zpff->report = report;
+	zpff->report->field[0]->value[0] = 0x00;
+	zpff->report->field[1]->value[0] = 0x02;
+	zpff->report->field[2]->value[0] = 0x00;
+	zpff->report->field[3]->value[0] = 0x00;
+	usbhid_submit_report(hid, zpff->report, USB_DIR_OUT);
+
+	printk(KERN_INFO "Force feedback for Zeroplus based devices by "
+	       "Anssi Hannula <anssi.hannula@gmail.com>\n");
+
+	return 0;
+}
+
+static int zp_probe(struct hid_device *hdev, const struct hid_device_id *id)
+{
+	int ret;
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
+	zpff_init(hdev);
+
+	return 0;
+err:
+	return ret;
+}
+
+static const struct hid_device_id zp_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0005) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0030) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, zp_devices);
+
+static struct hid_driver zp_driver = {
+	.name = "zeroplus",
+	.id_table = zp_devices,
+	.probe = zp_probe,
+};
+
+static int zp_init(void)
+{
+	return hid_register_driver(&zp_driver);
+}
+
+static void zp_exit(void)
+{
+	hid_unregister_driver(&zp_driver);
+}
+
+module_init(zp_init);
+module_exit(zp_exit);
+MODULE_LICENSE("GPL");
+
+HID_COMPAT_LOAD_DRIVER(zeroplus);
diff --git a/drivers/hid/usbhid/Kconfig b/drivers/hid/usbhid/Kconfig
index c236fb3..3cfc076 100644
--- a/drivers/hid/usbhid/Kconfig
+++ b/drivers/hid/usbhid/Kconfig
@@ -44,14 +44,6 @@ config HID_PID
 	  feedback for it. Microsoft Sidewinder Force Feedback 2 is one of such
 	  devices.
 
-config ZEROPLUS_FF
-	bool "Zeroplus based game controller support"
-	depends on HID_FF
-	select INPUT_FF_MEMLESS if USB_HID
-	help
-	  Say Y here if you have a Zeroplus based game controller and want to
-	  enable force feedback for it.
-
 config USB_HIDDEV
 	bool "/dev/hiddev raw HID device support"
 	depends on USB_HID
diff --git a/drivers/hid/usbhid/Makefile b/drivers/hid/usbhid/Makefile
index dd3b863..5c460fc 100644
--- a/drivers/hid/usbhid/Makefile
+++ b/drivers/hid/usbhid/Makefile
@@ -13,9 +13,6 @@ endif
 ifeq ($(CONFIG_HID_PID),y)
 	usbhid-objs	+= hid-pidff.o
 endif
-ifeq ($(CONFIG_ZEROPLUS_FF),y)
-	usbhid-objs	+= hid-zpff.o
-endif
 ifeq ($(CONFIG_HID_FF),y)
 	usbhid-objs	+= hid-ff.o
 endif
diff --git a/drivers/hid/usbhid/hid-ff.c b/drivers/hid/usbhid/hid-ff.c
index ed3a869..eca01a6 100644
--- a/drivers/hid/usbhid/hid-ff.c
+++ b/drivers/hid/usbhid/hid-ff.c
@@ -50,10 +50,6 @@ struct hid_ff_initializer {
  * be a PID device
  */
 static struct hid_ff_initializer inits[] = {
-#ifdef CONFIG_ZEROPLUS_FF
-	{ 0xc12, 0x0005, hid_zpff_init },
-	{ 0xc12, 0x0030, hid_zpff_init },
-#endif
 	{ 0,	 0,	 hid_pidff_init}  /* Matches anything */
 };
 
diff --git a/drivers/hid/usbhid/hid-zpff.c b/drivers/hid/usbhid/hid-zpff.c
deleted file mode 100644
index 5a68827..0000000
--- a/drivers/hid/usbhid/hid-zpff.c
+++ /dev/null
@@ -1,107 +0,0 @@
-/*
- *  Force feedback support for Zeroplus based devices
- *
- *  Copyright (c) 2005, 2006 Anssi Hannula <anssi.hannula@gmail.com>
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
-#include <linux/input.h>
-#include <linux/usb.h>
-#include <linux/hid.h>
-#include "usbhid.h"
-
-struct zpff_device {
-	struct hid_report *report;
-};
-
-static int hid_zpff_play(struct input_dev *dev, void *data,
-			 struct ff_effect *effect)
-{
-	struct hid_device *hid = input_get_drvdata(dev);
-	struct zpff_device *zpff = data;
-	int left, right;
-
-	/*
-	 * The following is specified the other way around in the Zeroplus
-	 * datasheet but the order below is correct for the XFX Executioner;
-	 * however it is possible that the XFX Executioner is an exception
-	 */
-
-	left = effect->u.rumble.strong_magnitude;
-	right = effect->u.rumble.weak_magnitude;
-	dbg_hid("called with 0x%04x 0x%04x\n", left, right);
-
-	left = left * 0x7f / 0xffff;
-	right = right * 0x7f / 0xffff;
-
-	zpff->report->field[2]->value[0] = left;
-	zpff->report->field[3]->value[0] = right;
-	dbg_hid("running with 0x%02x 0x%02x\n", left, right);
-	usbhid_submit_report(hid, zpff->report, USB_DIR_OUT);
-
-	return 0;
-}
-
-int hid_zpff_init(struct hid_device *hid)
-{
-	struct zpff_device *zpff;
-	struct hid_report *report;
-	struct hid_input *hidinput = list_entry(hid->inputs.next,
-						struct hid_input, list);
-	struct list_head *report_list =
-			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
-	struct input_dev *dev = hidinput->input;
-	int error;
-
-	if (list_empty(report_list)) {
-		printk(KERN_ERR "hid-zpff: no output report found\n");
-		return -ENODEV;
-	}
-
-	report = list_entry(report_list->next, struct hid_report, list);
-
-	if (report->maxfield < 4) {
-		printk(KERN_ERR "hid-zpff: not enough fields in report\n");
-		return -ENODEV;
-	}
-
-	zpff = kzalloc(sizeof(struct zpff_device), GFP_KERNEL);
-	if (!zpff)
-		return -ENOMEM;
-
-	set_bit(FF_RUMBLE, dev->ffbit);
-
-	error = input_ff_create_memless(dev, zpff, hid_zpff_play);
-	if (error) {
-		kfree(zpff);
-		return error;
-	}
-
-	zpff->report = report;
-	zpff->report->field[0]->value[0] = 0x00;
-	zpff->report->field[1]->value[0] = 0x02;
-	zpff->report->field[2]->value[0] = 0x00;
-	zpff->report->field[3]->value[0] = 0x00;
-	usbhid_submit_report(hid, zpff->report, USB_DIR_OUT);
-
-	printk(KERN_INFO "Force feedback for Zeroplus based devices by "
-	       "Anssi Hannula <anssi.hannula@gmail.com>\n");
-
-	return 0;
-}
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 2af65a7..6cf0357 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -760,7 +760,6 @@ void usbhid_set_leds(struct hid_device *hid);
 #ifdef CONFIG_HID_FF
 int hid_ff_init(struct hid_device *hid);
 
-int hid_zpff_init(struct hid_device *hid);
 #ifdef CONFIG_HID_PID
 int hid_pidff_init(struct hid_device *hid);
 #else
-- 
1.6.0

