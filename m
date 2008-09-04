Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbYIDNBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbYIDNBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 09:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758160AbYIDNAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 09:00:03 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43577 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671AbYIDM7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:59:53 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, Anssi Hannula <anssi.hannula@gmail.com>,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/5] HID: move thrustmaster FF processing
Date: Thu,  4 Sep 2008 14:59:44 +0200
Message-Id: <1220533187-21848-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0
In-Reply-To: <1220533187-21848-1-git-send-email-jirislaby@gmail.com>
References: <1220533187-21848-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/hid/Kconfig           |    9 ++
 drivers/hid/Makefile          |    1 +
 drivers/hid/hid-core.c        |    4 +
 drivers/hid/hid-dummy.c       |    3 +
 drivers/hid/hid-ids.h         |    2 +
 drivers/hid/hid-tmff.c        |  265 +++++++++++++++++++++++++++++++++++++++++
 drivers/hid/usbhid/Kconfig    |   11 --
 drivers/hid/usbhid/Makefile   |    3 -
 drivers/hid/usbhid/hid-ff.c   |    6 -
 drivers/hid/usbhid/hid-tmff.c |  232 ------------------------------------
 include/linux/hid.h           |    1 -
 11 files changed, 284 insertions(+), 253 deletions(-)
 create mode 100644 drivers/hid/hid-tmff.c
 delete mode 100644 drivers/hid/usbhid/hid-tmff.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 7220e6f..268fcd1 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -243,6 +243,15 @@ config HID_SUNPLUS
 	---help---
 	Support for Sunplus WDesktop input device.
 
+config THRUSTMASTER_FF
+	tristate "ThrustMaster devices support"
+	default m
+	depends on USB_HID
+	select INPUT_FF_MEMLESS
+	help
+	  Say Y here if you have a THRUSTMASTER FireStore Dual Power 2 or
+	  a THRUSTMASTER Ferrari GT Rumble Force or Force Feedback Wheel.
+
 endmenu
 
 endif # HID_SUPPORT
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index e607068..9bd6daf 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_HID_PETALYNX)	+= hid-petalynx.o
 obj-$(CONFIG_HID_SAMSUNG)	+= hid-samsung.o
 obj-$(CONFIG_HID_SONY)		+= hid-sony.o
 obj-$(CONFIG_HID_SUNPLUS)	+= hid-sunplus.o
+obj-$(CONFIG_THRUSTMASTER_FF)	+= hid-tmff.o
 
 obj-$(CONFIG_USB_HID)		+= usbhid/
 obj-$(CONFIG_USB_MOUSE)		+= usbhid/
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 3a12bb6..e6624d9 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1514,6 +1514,10 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PANJIT, 0x0003) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PANJIT, 0x0004) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SOUNDGRAPH, USB_DEVICE_ID_SOUNDGRAPH_IMON_LCD) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb651) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb654) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_VERNIER, USB_DEVICE_ID_VERNIER_LABPRO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_VERNIER, USB_DEVICE_ID_VERNIER_GOTEMP) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_VERNIER, USB_DEVICE_ID_VERNIER_SKIP) },
diff --git a/drivers/hid/hid-dummy.c b/drivers/hid/hid-dummy.c
index 2f5d9a1..ae122a1 100644
--- a/drivers/hid/hid-dummy.c
+++ b/drivers/hid/hid-dummy.c
@@ -55,6 +55,9 @@ static int __init hid_dummy_init(void)
 #ifdef CONFIG_HID_SUNPLUS_MODULE
 	HID_COMPAT_CALL_DRIVER(sunplus);
 #endif
+#ifdef CONFIG_THRUSTMASTER_FF_MODULE
+	HID_COMPAT_CALL_DRIVER(thrustmaster);
+#endif
 
 	return -EIO;
 }
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index a4d9695..30dcc93 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -348,6 +348,8 @@
 #define USB_VENDOR_ID_SUN		0x0430
 #define USB_DEVICE_ID_RARITAN_KVM_DONGLE	0xcdab
 
+#define USB_VENDOR_ID_THRUSTMASTER	0x044f
+
 #define USB_VENDOR_ID_SUNPLUS		0x04fc
 #define USB_DEVICE_ID_SUNPLUS_WDESKTOP	0x05d8
 
diff --git a/drivers/hid/hid-tmff.c b/drivers/hid/hid-tmff.c
new file mode 100644
index 0000000..7b85bbb
--- /dev/null
+++ b/drivers/hid/hid-tmff.c
@@ -0,0 +1,265 @@
+/*
+ * Force feedback support for various HID compliant devices by ThrustMaster:
+ *    ThrustMaster FireStorm Dual Power 2
+ * and possibly others whose device ids haven't been added.
+ *
+ *  Modified to support ThrustMaster devices by Zinx Verituse
+ *  on 2003-01-25 from the Logitech force feedback driver,
+ *  which is by Johann Deneux.
+ *
+ *  Copyright (c) 2003 Zinx Verituse <zinx@epicsol.org>
+ *  Copyright (c) 2002 Johann Deneux
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
+#include <linux/hid.h>
+#include <linux/input.h>
+#include <linux/usb.h>
+
+#include "hid-ids.h"
+
+#include "usbhid/usbhid.h"
+
+/* Usages for thrustmaster devices I know about */
+#define THRUSTMASTER_USAGE_FF	(HID_UP_GENDESK | 0xbb)
+
+static const signed short ff_rumble[] = {
+	FF_RUMBLE,
+	-1
+};
+
+static const signed short ff_joystick[] = {
+	FF_CONSTANT,
+	-1
+};
+
+struct tmff_device {
+	struct hid_report *report;
+	struct hid_field *ff_field;
+};
+
+/* Changes values from 0 to 0xffff into values from minimum to maximum */
+static inline int tmff_scale_u16(unsigned int in, int minimum, int maximum)
+{
+	int ret;
+
+	ret = (in * (maximum - minimum) / 0xffff) + minimum;
+	if (ret < minimum)
+		return minimum;
+	if (ret > maximum)
+		return maximum;
+	return ret;
+}
+
+/* Changes values from -0x80 to 0x7f into values from minimum to maximum */
+static inline int tmff_scale_s8(int in, int minimum, int maximum)
+{
+	int ret;
+
+	ret = (((in + 0x80) * (maximum - minimum)) / 0xff) + minimum;
+	if (ret < minimum)
+		return minimum;
+	if (ret > maximum)
+		return maximum;
+	return ret;
+}
+
+static int tmff_play(struct input_dev *dev, void *data, struct ff_effect *effect)
+{
+	struct hid_device *hid = input_get_drvdata(dev);
+	struct tmff_device *tmff = data;
+	struct hid_field *ff_field = tmff->ff_field;
+	int x, y;
+	int left, right;	/* Rumbling */
+
+	switch (effect->type) {
+	case FF_CONSTANT:
+		x = tmff_scale_s8(effect->u.ramp.start_level,
+					ff_field->logical_minimum,
+					ff_field->logical_maximum);
+		y = tmff_scale_s8(effect->u.ramp.end_level,
+					ff_field->logical_minimum,
+					ff_field->logical_maximum);
+
+		dbg_hid("(x, y)=(%04x, %04x)\n", x, y);
+		ff_field->value[0] = x;
+		ff_field->value[1] = y;
+		usbhid_submit_report(hid, tmff->report, USB_DIR_OUT);
+		break;
+
+	case FF_RUMBLE:
+		left = tmff_scale_u16(effect->u.rumble.weak_magnitude,
+					ff_field->logical_minimum,
+					ff_field->logical_maximum);
+		right = tmff_scale_u16(effect->u.rumble.strong_magnitude,
+					ff_field->logical_minimum,
+					ff_field->logical_maximum);
+
+		dbg_hid("(left,right)=(%08x, %08x)\n", left, right);
+		ff_field->value[0] = left;
+		ff_field->value[1] = right;
+		usbhid_submit_report(hid, tmff->report, USB_DIR_OUT);
+		break;
+	}
+	return 0;
+}
+
+static int tmff_init(struct hid_device *hid, const signed short *ff_bits)
+{
+	struct tmff_device *tmff;
+	struct hid_report *report;
+	struct list_head *report_list;
+	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
+	struct input_dev *input_dev = hidinput->input;
+	int error;
+	int i;
+
+	tmff = kzalloc(sizeof(struct tmff_device), GFP_KERNEL);
+	if (!tmff)
+		return -ENOMEM;
+
+	/* Find the report to use */
+	report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
+	list_for_each_entry(report, report_list, list) {
+		int fieldnum;
+
+		for (fieldnum = 0; fieldnum < report->maxfield; ++fieldnum) {
+			struct hid_field *field = report->field[fieldnum];
+
+			if (field->maxusage <= 0)
+				continue;
+
+			switch (field->usage[0].hid) {
+			case THRUSTMASTER_USAGE_FF:
+				if (field->report_count < 2) {
+					dev_warn(&hid->dev,
+						 "ignoring FF field with report_count < 2\n");
+					continue;
+				}
+
+				if (field->logical_maximum == field->logical_minimum) {
+					dev_warn(&hid->dev,
+						 "ignoring FF field with logical_maximum == logical_minimum\n");
+					continue;
+				}
+
+				if (tmff->report && tmff->report != report) {
+					dev_warn(&hid->dev,
+						 "ignoring FF field in other report\n");
+					continue;
+				}
+
+				if (tmff->ff_field && tmff->ff_field != field) {
+					dev_warn(&hid->dev,
+						 "ignoring duplicate FF field\n");
+					continue;
+				}
+
+				tmff->report = report;
+				tmff->ff_field = field;
+
+				for (i = 0; ff_bits[i] >= 0; i++)
+					set_bit(ff_bits[i], input_dev->ffbit);
+
+				break;
+
+			default:
+				dev_warn(&hid->dev,
+					 "ignoring unknown output usage %08x\n",
+					 field->usage[0].hid);
+				continue;
+			}
+		}
+	}
+
+	if (!tmff->report) {
+		err("cant find FF field in output reports\n");
+		error = -ENODEV;
+		goto fail;
+	}
+
+	error = input_ff_create_memless(input_dev, tmff, tmff_play);
+	if (error)
+		goto fail;
+
+	dev_info(&hid->dev,
+		 "Force feedback for ThrustMaster devices by Zinx Verituse <zinx@epicsol.org>\n");
+	return 0;
+
+fail:
+	kfree(tmff);
+	return error;
+}
+
+static int tm_probe(struct hid_device *hdev, const struct hid_device_id *id)
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
+	tmff_init(hdev, (void *)id->driver_data);
+
+	return 0;
+err:
+	return ret;
+}
+
+static const struct hid_device_id tm_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300),
+		.driver_data = (unsigned long)ff_rumble },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304),
+		.driver_data = (unsigned long)ff_rumble },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb651),	/* FGT Rumble Force Wheel */
+		.driver_data = (unsigned long)ff_rumble },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb654),	/* FGT Force Feedback Wheel */
+		.driver_data = (unsigned long)ff_joystick },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, tm_devices);
+
+static struct hid_driver tm_driver = {
+	.name = "thrustmaster",
+	.id_table = tm_devices,
+	.probe = tm_probe,
+};
+
+static int tm_init(void)
+{
+	return hid_register_driver(&tm_driver);
+}
+
+static void tm_exit(void)
+{
+	hid_unregister_driver(&tm_driver);
+}
+
+module_init(tm_init);
+module_exit(tm_exit);
+MODULE_LICENSE("GPL");
+
+HID_COMPAT_LOAD_DRIVER(thrustmaster);
diff --git a/drivers/hid/usbhid/Kconfig b/drivers/hid/usbhid/Kconfig
index 02c8228..c236fb3 100644
--- a/drivers/hid/usbhid/Kconfig
+++ b/drivers/hid/usbhid/Kconfig
@@ -44,17 +44,6 @@ config HID_PID
 	  feedback for it. Microsoft Sidewinder Force Feedback 2 is one of such
 	  devices.
 
-config THRUSTMASTER_FF
-	bool "ThrustMaster devices support"
-	depends on HID_FF
-	select INPUT_FF_MEMLESS if USB_HID
-	help
-	  Say Y here if you have a THRUSTMASTER FireStore Dual Power 2 or
-	  a THRUSTMASTER Ferrari GT Rumble Force or Force Feedback Wheel,
-	  and want to enable force feedback support for it.
-	  Note: if you say N here, this device will still be supported, but without
-	  force feedback.
-
 config ZEROPLUS_FF
 	bool "Zeroplus based game controller support"
 	depends on HID_FF
diff --git a/drivers/hid/usbhid/Makefile b/drivers/hid/usbhid/Makefile
index 0ee4803..dd3b863 100644
--- a/drivers/hid/usbhid/Makefile
+++ b/drivers/hid/usbhid/Makefile
@@ -13,9 +13,6 @@ endif
 ifeq ($(CONFIG_HID_PID),y)
 	usbhid-objs	+= hid-pidff.o
 endif
-ifeq ($(CONFIG_THRUSTMASTER_FF),y)
-	usbhid-objs	+= hid-tmff.o
-endif
 ifeq ($(CONFIG_ZEROPLUS_FF),y)
 	usbhid-objs	+= hid-zpff.o
 endif
diff --git a/drivers/hid/usbhid/hid-ff.c b/drivers/hid/usbhid/hid-ff.c
index a868eef..ed3a869 100644
--- a/drivers/hid/usbhid/hid-ff.c
+++ b/drivers/hid/usbhid/hid-ff.c
@@ -50,12 +50,6 @@ struct hid_ff_initializer {
  * be a PID device
  */
 static struct hid_ff_initializer inits[] = {
-#ifdef CONFIG_THRUSTMASTER_FF
-	{ 0x44f, 0xb300, hid_tmff_init },
-	{ 0x44f, 0xb304, hid_tmff_init },
-	{ 0x44f, 0xb651, hid_tmff_init }, /* FGT Rumble Force Wheel */
-	{ 0x44f, 0xb654, hid_tmff_init }, /* FGT Force Feedback Wheel */
-#endif
 #ifdef CONFIG_ZEROPLUS_FF
 	{ 0xc12, 0x0005, hid_zpff_init },
 	{ 0xc12, 0x0030, hid_zpff_init },
diff --git a/drivers/hid/usbhid/hid-tmff.c b/drivers/hid/usbhid/hid-tmff.c
deleted file mode 100644
index 451a8e6..0000000
--- a/drivers/hid/usbhid/hid-tmff.c
+++ /dev/null
@@ -1,232 +0,0 @@
-/*
- * Force feedback support for various HID compliant devices by ThrustMaster:
- *    ThrustMaster FireStorm Dual Power 2
- * and possibly others whose device ids haven't been added.
- *
- *  Modified to support ThrustMaster devices by Zinx Verituse
- *  on 2003-01-25 from the Logitech force feedback driver,
- *  which is by Johann Deneux.
- *
- *  Copyright (c) 2003 Zinx Verituse <zinx@epicsol.org>
- *  Copyright (c) 2002 Johann Deneux
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
-#include <linux/input.h>
-
-#undef DEBUG
-#include <linux/usb.h>
-
-#include <linux/hid.h>
-#include "usbhid.h"
-
-/* Usages for thrustmaster devices I know about */
-#define THRUSTMASTER_USAGE_FF	(HID_UP_GENDESK | 0xbb)
-
-struct dev_type {
-	u16 idVendor;
-	u16 idProduct;
-	const signed short *ff;
-};
-
-static const signed short ff_rumble[] = {
-	FF_RUMBLE,
-	-1
-};
-
-static const signed short ff_joystick[] = {
-	FF_CONSTANT,
-	-1
-};
-
-static const struct dev_type devices[] = {
-	{ 0x44f, 0xb300, ff_rumble },
-	{ 0x44f, 0xb304, ff_rumble },
-	{ 0x44f, 0xb651, ff_rumble },	/* FGT Rumble Force Wheel */
-	{ 0x44f, 0xb654, ff_joystick },	/* FGT Force Feedback Wheel */
-};
-
-struct tmff_device {
-	struct hid_report *report;
-	struct hid_field *ff_field;
-};
-
-/* Changes values from 0 to 0xffff into values from minimum to maximum */
-static inline int hid_tmff_scale_u16(unsigned int in,
-				int minimum, int maximum)
-{
-	int ret;
-
-	ret = (in * (maximum - minimum) / 0xffff) + minimum;
-	if (ret < minimum)
-		return minimum;
-	if (ret > maximum)
-		return maximum;
-	return ret;
-}
-
-/* Changes values from -0x80 to 0x7f into values from minimum to maximum */
-static inline int hid_tmff_scale_s8(int in,
-				    int minimum, int maximum)
-{
-	int ret;
-
-	ret = (((in + 0x80) * (maximum - minimum)) / 0xff) + minimum;
-	if (ret < minimum)
-		return minimum;
-	if (ret > maximum)
-		return maximum;
-	return ret;
-}
-
-static int hid_tmff_play(struct input_dev *dev, void *data, struct ff_effect *effect)
-{
-	struct hid_device *hid = input_get_drvdata(dev);
-	struct tmff_device *tmff = data;
-	struct hid_field *ff_field = tmff->ff_field;
-	int x, y;
-	int left, right;	/* Rumbling */
-
-	switch (effect->type) {
-	case FF_CONSTANT:
-		x = hid_tmff_scale_s8(effect->u.ramp.start_level,
-					ff_field->logical_minimum,
-					ff_field->logical_maximum);
-		y = hid_tmff_scale_s8(effect->u.ramp.end_level,
-					ff_field->logical_minimum,
-					ff_field->logical_maximum);
-
-		dbg_hid("(x, y)=(%04x, %04x)\n", x, y);
-		ff_field->value[0] = x;
-		ff_field->value[1] = y;
-		usbhid_submit_report(hid, tmff->report, USB_DIR_OUT);
-		break;
-
-	case FF_RUMBLE:
-		left = hid_tmff_scale_u16(effect->u.rumble.weak_magnitude,
-					ff_field->logical_minimum,
-					ff_field->logical_maximum);
-		right = hid_tmff_scale_u16(effect->u.rumble.strong_magnitude,
-					ff_field->logical_minimum,
-					ff_field->logical_maximum);
-
-		dbg_hid("(left,right)=(%08x, %08x)\n", left, right);
-		ff_field->value[0] = left;
-		ff_field->value[1] = right;
-		usbhid_submit_report(hid, tmff->report, USB_DIR_OUT);
-		break;
-	}
-	return 0;
-}
-
-int hid_tmff_init(struct hid_device *hid)
-{
-	struct tmff_device *tmff;
-	struct hid_report *report;
-	struct list_head *report_list;
-	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
-	struct input_dev *input_dev = hidinput->input;
-	const signed short *ff_bits = ff_joystick;
-	int error;
-	int i;
-
-	tmff = kzalloc(sizeof(struct tmff_device), GFP_KERNEL);
-	if (!tmff)
-		return -ENOMEM;
-
-	/* Find the report to use */
-	report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
-	list_for_each_entry(report, report_list, list) {
-		int fieldnum;
-
-		for (fieldnum = 0; fieldnum < report->maxfield; ++fieldnum) {
-			struct hid_field *field = report->field[fieldnum];
-
-			if (field->maxusage <= 0)
-				continue;
-
-			switch (field->usage[0].hid) {
-			case THRUSTMASTER_USAGE_FF:
-				if (field->report_count < 2) {
-					dev_warn(&hid->dev,
-						 "ignoring FF field with report_count < 2\n");
-					continue;
-				}
-
-				if (field->logical_maximum == field->logical_minimum) {
-					dev_warn(&hid->dev,
-						 "ignoring FF field with logical_maximum == logical_minimum\n");
-					continue;
-				}
-
-				if (tmff->report && tmff->report != report) {
-					dev_warn(&hid->dev,
-						 "ignoring FF field in other report\n");
-					continue;
-				}
-
-				if (tmff->ff_field && tmff->ff_field != field) {
-					dev_warn(&hid->dev,
-						 "ignoring duplicate FF field\n");
-					continue;
-				}
-
-				tmff->report = report;
-				tmff->ff_field = field;
-
-				for (i = 0; i < ARRAY_SIZE(devices); i++) {
-					if (input_dev->id.vendor == devices[i].idVendor &&
-					    input_dev->id.product == devices[i].idProduct) {
-						ff_bits = devices[i].ff;
-						break;
-					}
-				}
-
-				for (i = 0; ff_bits[i] >= 0; i++)
-					set_bit(ff_bits[i], input_dev->ffbit);
-
-				break;
-
-			default:
-				dev_warn(&hid->dev,
-					 "ignoring unknown output usage %08x\n",
-					 field->usage[0].hid);
-				continue;
-			}
-		}
-	}
-
-	if (!tmff->report) {
-		err("cant find FF field in output reports\n");
-		error = -ENODEV;
-		goto fail;
-	}
-
-	error = input_ff_create_memless(input_dev, tmff, hid_tmff_play);
-	if (error)
-		goto fail;
-
-	dev_info(&hid->dev,
-		 "Force feedback for ThrustMaster devices by Zinx Verituse <zinx@epicsol.org>\n");
-	return 0;
-
- fail:
-	kfree(tmff);
-	return error;
-}
-
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 260beba..2af65a7 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -760,7 +760,6 @@ void usbhid_set_leds(struct hid_device *hid);
 #ifdef CONFIG_HID_FF
 int hid_ff_init(struct hid_device *hid);
 
-int hid_tmff_init(struct hid_device *hid);
 int hid_zpff_init(struct hid_device *hid);
 #ifdef CONFIG_HID_PID
 int hid_pidff_init(struct hid_device *hid);
-- 
1.6.0

