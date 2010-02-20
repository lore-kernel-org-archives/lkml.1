Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab0BTIMA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 03:12:00 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:33050 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab0BTIL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 03:11:57 -0500
From: Stefan Achatz <stefan_achatz@web.de>
To: Jiri Kosina <jkosina@suse.cz>, Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       wylda@volny.cz, Pavel Machek <pavel@suse.cz>,
       Alessandro Guido <ag@alessandroguido.name>,
       Tomas Hanak <tomas.hanak@gmail.com>, Jason Noble <nobleja@polezero.com>,
       simon.windows@gmail.com, Sean Hildebrand <silverwraithii@gmail.com>,
       Sid Boyce <sboyce@blueyonder.co.uk>, Henning Glawe <glaweh@debian.org>
Subject: [PATCH] HID: add driver for Roccat Kone gaming mouse
Date: Sat, 20 Feb 2010 09:11:53 +0100
User-Agent: KMail/1.9.9
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002200911.53900.stefan_achatz@web.de>
X-Provags-ID: V01U2FsdGVkX1/gONgA1FQxVxq82nHiFcyTKrDEjOLlWLGqfWgK
	G53LfpE6yf1jRAhejU23cR6rVRQ/UiTC4SSDIgMg17UcjSIl3b
	VUa7HDqBWK/xpAG4f4GA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This Patch adds support for Kone gaming mouse from Roccat.
It provides access to profiles, settings, firmware, weight,
actual settings etc. through sysfs files.
Event handling of this mouse differs from standard hid behaviour
in that tilt button press is reported in each move event which
results in strange behaviour if not handled by the driver.
Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>

---
 drivers/hid/Kconfig           |    7 +
 drivers/hid/Makefile          |    1 +
 drivers/hid/hid-ids.h         |    3 +
 drivers/hid/hid-roccat-kone.c |  940 +++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-roccat-kone.h |  187 ++++++++
 5 files changed, 1138 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hid/hid-roccat-kone.c
 create mode 100644 drivers/hid/hid-roccat-kone.h

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 24d90ea..ac945a6 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -227,6 +227,13 @@ config HID_PETALYNX
 	---help---
 	Support for Petalynx Maxter remote control.
 
+config HID_ROCCAT_KONE
+	tristate "Roccat Kone" if EMBEDDED
+	depends on USB_HID
+	default !EMBEDDED
+	---help---
+	Support for Roccat Kone mouse.
+
 config HID_SAMSUNG
 	tristate "Samsung" if EMBEDDED
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 0de2dff..295d481 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_HID_MONTEREY)	+= hid-monterey.o
 obj-$(CONFIG_HID_NTRIG)		+= hid-ntrig.o
 obj-$(CONFIG_HID_PANTHERLORD)	+= hid-pl.o
 obj-$(CONFIG_HID_PETALYNX)	+= hid-petalynx.o
+obj-$(CONFIG_HID_ROCCAT_KONE)	+= hid-roccat-kone.o
 obj-$(CONFIG_HID_SAMSUNG)	+= hid-samsung.o
 obj-$(CONFIG_HID_SMARTJOYPLUS)	+= hid-sjoy.o
 obj-$(CONFIG_HID_SONY)		+= hid-sony.o
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 010368e..248cafc 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -382,6 +382,9 @@
 #define USB_VENDOR_ID_POWERCOM		0x0d9f
 #define USB_DEVICE_ID_POWERCOM_UPS	0x0002
 
+#define USB_VENDOR_ID_ROCCAT		0x1e7d
+#define USB_DEVICE_ID_ROCCAT_KONE	0x2ced
+
 #define USB_VENDOR_ID_SAITEK		0x06a3
 #define USB_DEVICE_ID_SAITEK_RUMBLEPAD	0xff17
 
diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
new file mode 100644
index 0000000..94a2fb9
--- /dev/null
+++ b/drivers/hid/hid-roccat-kone.c
@@ -0,0 +1,940 @@
+/*
+ * Roccat Kone driver for Linux
+ *
+ * Copyright (c) 2010 Stefan Achatz <erazor_de@users.sourceforge.net>
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
+#include <linux/input.h>
+#include <linux/hid.h>
+#include <linux/usb.h>
+#include <linux/module.h>
+#include "hid-ids.h"
+#include "hid-roccat-kone.h"
+
+static uint16_t kone_calc_profile_checksum(struct kone_profile const *profile)
+{
+	uint16_t checksum = 0;
+	unsigned char *address;
+	int i;
+	for (i = 0, address = (unsigned char *)profile;
+			i < sizeof(struct kone_profile) - 2; ++i, ++address) {
+		checksum += *address;
+	}
+	return checksum;
+}
+
+static uint16_t kone_calc_settings_checksum(
+		struct kone_settings const *settings)
+{
+	uint16_t checksum = 0;
+	unsigned char *address = (unsigned char *)settings;
+	int i;
+
+	for (i = 0; i < sizeof(struct kone_settings) - 2; ++i, ++address)
+		checksum += *address;
+
+	return checksum;
+}
+
+static void kone_set_settings_checksum(struct kone_settings *settings)
+{
+	settings->checksum = cpu_to_le16(kone_calc_settings_checksum(settings));
+}
+
+static void kone_set_profile_checksum(struct kone_profile *profile)
+{
+	profile->checksum = cpu_to_le16(kone_calc_profile_checksum(profile));
+}
+
+static int kone_check_write(struct usb_device *usb_dev)
+{
+	int len;
+	unsigned char *data;
+
+	data = kmalloc(1, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	do {
+		msleep(50);
+
+		len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
+				USB_REQ_CLEAR_FEATURE, USB_TYPE_CLASS
+						| USB_RECIP_INTERFACE
+						| USB_DIR_IN,
+				kone_command_confirm_write, 0, data, 1,
+				USB_CTRL_SET_TIMEOUT);
+
+		if (len != 1) {
+			kfree(data);
+			return -EIO;
+		}
+		/*
+		 * value of 3 seems to mean something like
+		 * "not finished yet, but it looks good"
+		 * So check again after a moment.
+		 */
+	} while (*data == 3);
+
+	if (*data == 1) { /* everything alright */
+		kfree(data);
+		return 0;
+	} else { /* unknown answer */
+		dev_err(&usb_dev->dev, "got retval %d when checking write\n",
+				*data);
+		kfree(data);
+		return -EIO;
+	}
+}
+
+static int kone_get_settings(struct usb_device *usb_dev,
+		struct kone_settings *buf)
+{
+	int len;
+
+	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
+			USB_REQ_CLEAR_FEATURE, USB_TYPE_CLASS
+					| USB_RECIP_INTERFACE | USB_DIR_IN,
+			kone_command_settings, 0, buf,
+			sizeof(struct kone_settings), USB_CTRL_SET_TIMEOUT);
+
+	if (len != sizeof(struct kone_settings))
+		return -EIO;
+
+	return 0;
+}
+
+static int kone_set_settings(struct usb_device *usb_dev,
+		struct kone_settings const *buf)
+{
+	struct kone_settings *settings, *original_settings;
+	int len, err;
+
+	settings = kmalloc(sizeof(struct kone_settings), GFP_KERNEL);
+	if (!settings)
+		return -ENOMEM;
+
+	memcpy(settings, buf, sizeof(struct kone_settings));
+
+	kone_set_settings_checksum(settings);
+
+	original_settings = kmalloc(sizeof(struct kone_settings), GFP_KERNEL);
+	if (!original_settings) {
+		kfree(settings);
+		return -ENOMEM;
+	}
+
+	err = kone_get_settings(usb_dev, original_settings);
+	if (err) {
+		kfree(original_settings);
+		kfree(settings);
+		return err;
+	}
+
+	if (memcmp(settings, original_settings, sizeof(struct kone_settings))
+			!= 0) {
+		len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
+				USB_REQ_SET_CONFIGURATION, USB_TYPE_CLASS
+						| USB_RECIP_INTERFACE
+						| USB_DIR_OUT,
+				kone_command_settings, 0, settings,
+				sizeof(struct kone_settings),
+				USB_CTRL_SET_TIMEOUT);
+
+		if (len != sizeof(struct kone_settings)) {
+			kfree(original_settings);
+			kfree(settings);
+			return -EIO;
+		}
+
+		if (kone_check_write(usb_dev)) {
+			kfree(original_settings);
+			kfree(settings);
+			return -EIO;
+		}
+	}
+
+	kfree(original_settings);
+	kfree(settings);
+	return 0;
+}
+
+static int kone_get_startup_profile(struct usb_device *usb_dev, int *result)
+{
+	struct kone_settings *buf;
+	int err;
+
+	buf = kmalloc(sizeof(struct kone_settings), GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	err = kone_get_settings(usb_dev, buf);
+	if (err) {
+		kfree(buf);
+		return err;
+	}
+
+	*result = buf->startup_profile;
+	kfree(buf);
+	return 0;
+}
+
+static int kone_get_profile(struct usb_device *usb_dev,
+		struct kone_profile *buf, int number)
+{
+	int len;
+
+	if (number < 1 || number > 5)
+		return -EINVAL;
+
+	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
+			USB_REQ_CLEAR_FEATURE, USB_TYPE_CLASS
+					| USB_RECIP_INTERFACE | USB_DIR_IN,
+			kone_command_profile, number, buf,
+			sizeof(struct kone_profile), USB_CTRL_SET_TIMEOUT);
+
+	if (len != sizeof(struct kone_profile)) {
+		dev_err(&usb_dev->dev, "wrong len %d\n", len);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int kone_set_profile(struct usb_device *usb_dev, char const *buf,
+		int number)
+{
+	struct kone_profile *profile, *original_profile;
+	int len, err, result;
+
+	if (number < 1 || number > 5)
+		return -EINVAL;
+
+	profile = kmalloc(sizeof(struct kone_profile), GFP_KERNEL);
+	if (!profile)
+		return -ENOMEM;
+
+	/* prepare profile to write */
+	memcpy(profile, buf, sizeof(struct kone_profile));
+	profile->profile = number;
+	kone_set_profile_checksum(profile);
+
+	/*
+	 * to reduce unnecessary writes read profile and compare with data
+	 * that should be written
+	 */
+	original_profile = kmalloc(sizeof(struct kone_profile), GFP_KERNEL);
+	if (!original_profile) {
+		kfree(profile);
+		return -ENOMEM;
+	}
+
+	err = kone_get_profile(usb_dev, original_profile, number);
+	if (err) {
+		kfree(original_profile);
+		kfree(profile);
+		return err;
+	}
+
+	result = memcmp(profile, original_profile, sizeof(struct kone_profile));
+	if (result != 0) {
+		len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
+				USB_REQ_SET_CONFIGURATION, USB_TYPE_CLASS
+						| USB_RECIP_INTERFACE
+						| USB_DIR_OUT,
+				kone_command_profile, number, profile,
+				sizeof(struct kone_profile),
+				USB_CTRL_SET_TIMEOUT);
+
+		if (len != sizeof(struct kone_profile)) {
+			kfree(original_profile);
+			kfree(profile);
+			return -EIO;
+		}
+
+		if (kone_check_write(usb_dev)) {
+			kfree(original_profile);
+			kfree(profile);
+			return -EIO;
+		}
+	}
+
+	kfree(original_profile);
+	kfree(profile);
+	return 0;
+}
+
+static int kone_get_profile_startup_dpi(struct usb_device *usb_dev, int number,
+		int *result)
+{
+	struct kone_profile *buf;
+	int err;
+
+	buf = kmalloc(sizeof(struct kone_profile), GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	err = kone_get_profile(usb_dev, buf, number);
+	if (err) {
+		kfree(buf);
+		return err;
+	}
+
+	*result = buf->dpi_value;
+	kfree(buf);
+	return 0;
+}
+
+static int kone_get_weight(struct usb_device *usb_dev, int *result)
+{
+	int len;
+	uint8_t *data;
+
+	data = kmalloc(1, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
+			USB_REQ_CLEAR_FEATURE, USB_TYPE_CLASS
+					| USB_RECIP_INTERFACE | USB_DIR_IN,
+			kone_command_weight, 0, data, 1, USB_CTRL_SET_TIMEOUT);
+
+	if (len != 1) {
+		kfree(data);
+		return -EIO;
+	}
+	*result = (int)*data;
+	return 0;
+}
+
+static int kone_get_firmware_version(struct usb_device *usb_dev, int *result)
+{
+	int len;
+	unsigned char *data;
+
+	data = kmalloc(2, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
+			USB_REQ_CLEAR_FEATURE, USB_TYPE_CLASS
+					| USB_RECIP_INTERFACE | USB_DIR_IN,
+			kone_command_firmware_version, 0, data, 2,
+			USB_CTRL_SET_TIMEOUT);
+
+	if (len != 2) {
+		kfree(data);
+		return -EIO;
+	}
+	*result = (int)*data;
+	return 0;
+}
+
+static ssize_t kone_set_settings_raw(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t size)
+{
+	struct hid_device *hdev = dev_get_drvdata(dev);
+	struct kone_device *kone = hid_get_drvdata(hdev);
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	int err;
+
+	if (size != sizeof(struct kone_settings))
+		return -EINVAL;
+
+	err = kone_set_settings(usb_dev, (struct kone_settings const *)buf);
+	if (err)
+		return err;
+
+	/*
+	 * If we get here, treat buf as okay (apart from checksum) and use value
+	 * of startup_profile as its at hand
+	 */
+	kone->act_profile = ((struct kone_settings *)buf)->startup_profile;
+	kone->act_profile_valid = 1;
+	kone->act_dpi_valid = 0;
+
+	return sizeof(struct kone_settings);
+}
+
+static ssize_t kone_show_settings_raw(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	int err;
+	err = kone_get_settings(usb_dev, (struct kone_settings *)buf);
+	if (err)
+		return err;
+
+	return sizeof(struct kone_settings);
+}
+
+static ssize_t kone_get_profile_raw(struct device *dev, char *buf, int number)
+{
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	int err;
+	err = kone_get_profile(usb_dev, (struct kone_profile *)buf, number);
+	if (err)
+		return err;
+	return sizeof(struct kone_profile);
+}
+
+static ssize_t kone_set_profile_raw(struct device *dev, char const *buf,
+		size_t size, int number)
+{
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct usb_device *usb_dev = interface_to_usbdev(intf);
+
+	int err;
+
+	if (size != sizeof(struct kone_profile))
+		return -EINVAL;
+
+	err = kone_set_profile(usb_dev, buf, number);
+	if (err)
+		return err;
+
+	return sizeof(struct kone_profile);
+}
+
+static ssize_t kone_show_profile_1_raw(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return kone_get_profile_raw(dev, buf, 1);
+}
+
+static ssize_t kone_set_profile_1_raw(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t size)
+{
+	return kone_set_profile_raw(dev, buf, size, 1);
+}
+
+static ssize_t kone_show_profile_2_raw(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return kone_get_profile_raw(dev, buf, 2);
+}
+
+static ssize_t kone_set_profile_2_raw(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t size)
+{
+	return kone_set_profile_raw(dev, buf, size, 2);
+}
+
+static ssize_t kone_show_profile_3_raw(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return kone_get_profile_raw(dev, buf, 3);
+}
+
+static ssize_t kone_set_profile_3_raw(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t size)
+{
+	return kone_set_profile_raw(dev, buf, size, 3);
+}
+
+static ssize_t kone_show_profile_4_raw(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return kone_get_profile_raw(dev, buf, 4);
+}
+
+static ssize_t kone_set_profile_4_raw(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t size)
+{
+	return kone_set_profile_raw(dev, buf, size, 4);
+}
+
+static ssize_t kone_show_profile_5_raw(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return kone_get_profile_raw(dev, buf, 5);
+}
+
+static ssize_t kone_set_profile_5_raw(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t size)
+{
+	return kone_set_profile_raw(dev, buf, size, 5);
+}
+
+/*
+ * helper to fill kone_device structure with actual values
+ * returns 0 on success or error
+ */
+static int kone_device_set_actual_values(struct kone_device *kone,
+		struct device *dev, int both)
+{
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	int err;
+
+	/* first make sure profile is valid */
+	if (!kone->act_profile_valid) {
+		err = kone_get_startup_profile(usb_dev, &kone->act_profile);
+		if (err)
+			return err;
+		kone->act_profile_valid = 1;
+	}
+
+	/* then get startup dpi value */
+	if (!kone->act_dpi_valid && both) {
+		err = kone_get_profile_startup_dpi(usb_dev, kone->act_profile,
+				&kone->act_dpi);
+		if (err)
+			return err;
+		kone->act_dpi_valid = 1;
+	}
+
+	return 0;
+}
+
+static ssize_t kone_show_actual_profile(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct hid_device *hdev = dev_get_drvdata(dev);
+	struct kone_device *kone = hid_get_drvdata(hdev);
+	int err;
+	err = kone_device_set_actual_values(kone, dev, 0);
+	if (err)
+		return err;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", kone->act_profile);
+}
+
+static ssize_t kone_show_actual_dpi_raw(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct hid_device *hdev = dev_get_drvdata(dev);
+	struct kone_device *kone = hid_get_drvdata(hdev);
+	int err;
+
+	err = kone_device_set_actual_values(kone, dev, 1);
+	if (err)
+		return err;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", kone->act_dpi);
+}
+
+static ssize_t kone_show_actual_dpi(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct hid_device *hdev = dev_get_drvdata(dev);
+	struct kone_device *kone = hid_get_drvdata(hdev);
+	int err, dpi;
+	err = kone_device_set_actual_values(kone, dev, 1);
+	if (err)
+		return err;
+
+	dpi = kone->act_dpi;
+	switch (dpi) {
+	case 0:
+		break;
+	case 6:
+		dpi = 3200;
+		break;
+	default:
+		dpi = dpi * 400;
+	}
+
+	return snprintf(buf, PAGE_SIZE, "%ddpi\n", dpi);
+}
+
+static ssize_t kone_show_weight_raw(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	int weight;
+	int retval;
+	retval = kone_get_weight(usb_dev, &weight);
+	if (retval)
+		return retval;
+	return snprintf(buf, PAGE_SIZE, "%d\n", weight);
+}
+
+static ssize_t kone_show_firmware_version_raw(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	int firmware_version;
+	int retval;
+	retval = kone_get_firmware_version(usb_dev, &firmware_version);
+	if (retval)
+		return retval;
+	return snprintf(buf, PAGE_SIZE, "%d\n", firmware_version);
+}
+
+static ssize_t kone_show_tcu(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	int err, result;
+	struct kone_settings *settings;
+
+	settings = kmalloc(sizeof(struct kone_settings), GFP_KERNEL);
+	if (!settings)
+		return -ENOMEM;
+
+	err = kone_get_settings(usb_dev, settings);
+	if (err) {
+		kfree(settings);
+		return err;
+	}
+
+	result = settings->tcu;
+	kfree(settings);
+	return snprintf(buf, PAGE_SIZE, "%d\n", result);
+}
+
+static int kone_tcu_command(struct usb_device *usb_dev, int number)
+{
+	int len;
+	char *value;
+
+	value = kmalloc(1, GFP_KERNEL);
+	if (!value)
+		return -ENOMEM;
+
+	*value = number;
+
+	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
+			USB_REQ_SET_CONFIGURATION, USB_TYPE_CLASS
+					| USB_RECIP_INTERFACE | USB_DIR_OUT,
+			kone_command_calibrate, 0, value, 1,
+			USB_CTRL_SET_TIMEOUT);
+
+	if (len != 1) {
+		kfree(value);
+		return -EIO;
+	}
+
+	kfree(value);
+	return 0;
+}
+
+/* integer of 0 deactivates tcu, 1 activates it */
+static ssize_t kone_set_tcu(struct device *dev, struct device_attribute *attr,
+		char const *buf, size_t size)
+{
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	int err;
+	unsigned long state;
+	struct kone_settings *settings;
+
+	err = strict_strtoul(buf, 10, &state);
+	if (err)
+		return err;
+
+	if (state != 0 && state != 1)
+		return -EINVAL;
+
+	if (state == 1) { /* state activate */
+		err = kone_tcu_command(usb_dev, 1);
+		if (err)
+			return err;
+		err = kone_tcu_command(usb_dev, 2);
+		if (err)
+			return err;
+		ssleep(5); /* tcu needs this time for calibration */
+		err = kone_tcu_command(usb_dev, 3);
+		if (err)
+			return err;
+		err = kone_tcu_command(usb_dev, 0);
+		if (err)
+			return err;
+		err = kone_tcu_command(usb_dev, 4);
+		if (err)
+			return err;
+		/*
+		 * Kone needs this time to settle things.
+		 * Reading settings too early will result in invalid data.
+		 * Roccat's driver waits 1 sec, maybe this time could be
+		 * shortened.
+		 */
+		ssleep(1);
+	}
+
+	settings = kmalloc(sizeof(struct kone_settings), GFP_KERNEL);
+	if (!settings)
+		return -ENOMEM;
+
+	err = kone_get_settings(usb_dev, settings);
+	if (err) {
+		kfree(settings);
+		return err;
+	}
+
+	/* only write settings back if activation state is different */
+	if (settings->tcu != state) {
+		settings->tcu = state;
+
+		err = kone_set_settings(usb_dev, settings);
+		if (err) {
+			kfree(settings);
+			return err;
+		}
+	}
+
+	kfree(settings);
+	return size;
+}
+
+static ssize_t kone_show_startup_profile(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int err, result;
+	err = kone_get_startup_profile(usb_dev, &result);
+	if (err)
+		return err;
+	return snprintf(buf, PAGE_SIZE, "%d\n", result);
+}
+
+static ssize_t kone_set_startup_profile(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t size)
+{
+	struct hid_device *hdev = dev_get_drvdata(dev);
+	struct kone_device *kone = hid_get_drvdata(hdev);
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	int err;
+	unsigned long new_profile;
+	struct kone_settings *settings;
+
+	err = strict_strtoul(buf, 10, &new_profile);
+	if (err)
+		return err;
+
+	if (new_profile  < 1 || new_profile > 5)
+		return -EINVAL;
+
+	settings = kmalloc(sizeof(struct kone_settings), GFP_KERNEL);
+	if (!settings)
+		return -ENOMEM;
+
+	err = kone_get_settings(usb_dev, settings);
+	if (err) {
+		kfree(settings);
+		return err;
+	}
+
+	settings->startup_profile = new_profile;
+
+	err = kone_set_settings(usb_dev, settings);
+	if (err) {
+		kfree(settings);
+		return err;
+	}
+
+	kone->act_profile = new_profile;
+	kone->act_profile_valid = 1;
+	kone->act_dpi_valid = 0;
+
+	kfree(settings);
+	return size;
+}
+
+static ssize_t kone_show_driver_version(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, DRIVER_VERSION "\n");
+}
+
+static DEVICE_ATTR(actual_dpi_raw, S_IRUGO, kone_show_actual_dpi_raw, NULL);
+static DEVICE_ATTR(actual_dpi, S_IRUGO, kone_show_actual_dpi, NULL);
+static DEVICE_ATTR(actual_profile, S_IRUGO, kone_show_actual_profile, NULL);
+static DEVICE_ATTR(weight_raw, S_IRUGO, kone_show_weight_raw, NULL);
+static DEVICE_ATTR(profile1_raw, S_IRUGO | S_IWUGO,
+		kone_show_profile_1_raw, kone_set_profile_1_raw);
+static DEVICE_ATTR(profile2_raw, S_IRUGO | S_IWUGO,
+		kone_show_profile_2_raw, kone_set_profile_2_raw);
+static DEVICE_ATTR(profile3_raw, S_IRUGO | S_IWUGO,
+		kone_show_profile_3_raw, kone_set_profile_3_raw);
+static DEVICE_ATTR(profile4_raw, S_IRUGO | S_IWUGO,
+		kone_show_profile_4_raw, kone_set_profile_4_raw);
+static DEVICE_ATTR(profile5_raw, S_IRUGO | S_IWUGO,
+		kone_show_profile_5_raw, kone_set_profile_5_raw);
+static DEVICE_ATTR(settings_raw, S_IRUGO | S_IWUGO,
+		kone_show_settings_raw, kone_set_settings_raw);
+static DEVICE_ATTR(firmware_version_raw, S_IRUGO,
+		kone_show_firmware_version_raw, NULL);
+static DEVICE_ATTR(tcu, S_IRUGO | S_IWUGO, kone_show_tcu, kone_set_tcu);
+static DEVICE_ATTR(startup_profile, S_IRUGO | S_IWUGO,
+		kone_show_startup_profile, kone_set_startup_profile);
+static DEVICE_ATTR(kone_driver_version, S_IRUGO,
+		kone_show_driver_version, NULL);
+
+static struct attribute *kone_attributes[] = {
+		&dev_attr_actual_dpi_raw.attr,
+		&dev_attr_actual_dpi.attr,
+		&dev_attr_actual_profile.attr,
+		&dev_attr_weight_raw.attr,
+		&dev_attr_profile1_raw.attr,
+		&dev_attr_profile2_raw.attr,
+		&dev_attr_profile3_raw.attr,
+		&dev_attr_profile4_raw.attr,
+		&dev_attr_profile5_raw.attr,
+		&dev_attr_settings_raw.attr,
+		&dev_attr_firmware_version_raw.attr,
+		&dev_attr_tcu.attr,
+		&dev_attr_startup_profile.attr,
+		&dev_attr_kone_driver_version.attr,
+		NULL
+};
+
+static struct attribute_group kone_attribute_group = {
+		.attrs = kone_attributes
+};
+
+static int kone_create_files(struct usb_interface *intf)
+{
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			== USB_INTERFACE_PROTOCOL_MOUSE)
+		return sysfs_create_group(&intf->dev.kobj,
+				&kone_attribute_group);
+	else
+		return 0;
+}
+
+static void kone_remove_files(struct usb_interface *intf)
+{
+	if (intf->cur_altsetting->desc.bInterfaceProtocol
+			== USB_INTERFACE_PROTOCOL_MOUSE)
+		sysfs_remove_group(&intf->dev.kobj, &kone_attribute_group);
+}
+
+static int kone_probe(struct hid_device *hdev, const struct hid_device_id *id)
+{
+	struct kone_device *kone;
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	int ret;
+
+	kone = kzalloc(sizeof(*kone), GFP_KERNEL);
+	if (!kone) {
+		dev_err(&hdev->dev, "can't alloc device descriptor\n");
+		return -ENOMEM;
+	}
+
+	hid_set_drvdata(hdev, kone);
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
+	ret = kone_create_files(intf);
+	if (ret) {
+		dev_err(&hdev->dev, "cannot create sysfs files\n");
+		goto err_stop;
+	}
+
+	return 0;
+err_stop:
+	hid_hw_stop(hdev);
+err_free:
+	kfree(kone);
+	return ret;
+}
+
+static void kone_remove(struct hid_device *hdev)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	kone_remove_files(intf);
+	hid_hw_stop(hdev);
+	kfree(hid_get_drvdata(hdev));
+}
+
+static int kone_raw_event(struct hid_device *hdev, struct hid_report *report,
+		u8 *data, int size)
+{
+	struct kone_device *kone = hid_get_drvdata(hdev);
+	struct kone_mouse_event *event = (struct kone_mouse_event *)data;
+
+	/* keyboard events should be processed by default handler */
+	if (size != 12)
+		return 0;
+
+	/* Firmware 1.38 introduced new behaviour for tilt buttons.
+	 * Pressed tilt button is reported in each movement event.
+	 * Workaround sends only one event per press.
+	 */
+	if (kone->last_tilt_state == event->tilt)
+		event->tilt = 0;
+	else
+		kone->last_tilt_state = event->tilt;
+
+	switch (event->event) {
+	case kone_mouse_event_osd_dpi:
+		kone->act_dpi = event->value;
+		kone->act_dpi_valid = 1;
+		dev_dbg(&hdev->dev, "osd dpi event. actual dpi %d (and %d)\n",
+				event->value, kone->act_dpi);
+		return 1; /* return 1 if event was handled */
+	case kone_mouse_event_switch_dpi:
+		kone->act_dpi = event->value;
+		kone->act_dpi_valid = 1;
+		dev_dbg(&hdev->dev, "switched dpi to %d\n", event->value);
+		return 1;
+	case kone_mouse_event_osd_profile:
+		kone->act_profile = event->value;
+		kone->act_profile_valid = 1;
+		dev_dbg(&hdev->dev, "osd profile event. actual profile %d\n",
+				event->value);
+		return 1;
+	case kone_mouse_event_switch_profile:
+		kone->act_profile = event->value;
+		kone->act_profile_valid = 1;
+		kone->act_dpi_valid = 0;
+		dev_dbg(&hdev->dev, "switched profile to %d\n", event->value);
+		return 1;
+	case kone_mouse_event_call_overlong_macro:
+		dev_dbg(&hdev->dev, "overlong macro called %d\n", event->macro);
+		return 1;
+	}
+
+	return 0; /* do further processing */
+}
+
+static const struct hid_device_id kone_devices[] = { { HID_USB_DEVICE(
+		USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONE) }, { } };
+MODULE_DEVICE_TABLE(hid, kone_devices);
+
+static struct hid_driver kone_driver = { .name = "kone",
+		.id_table = kone_devices, .probe = kone_probe,
+		.remove = kone_remove, .raw_event = kone_raw_event, };
+
+static int kone_init(void)
+{
+	return hid_register_driver(&kone_driver);
+}
+
+static void kone_exit(void)
+{
+	hid_unregister_driver(&kone_driver);
+}
+
+module_init(kone_init);
+module_exit(kone_exit);
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE(DRIVER_LICENSE);
diff --git a/drivers/hid/hid-roccat-kone.h b/drivers/hid/hid-roccat-kone.h
new file mode 100644
index 0000000..14f5ebf
--- /dev/null
+++ b/drivers/hid/hid-roccat-kone.h
@@ -0,0 +1,187 @@
+#ifndef __HID_ROCCAT_KONE_H
+#define __HID_ROCCAT_KONE_H
+
+/*
+ * Copyright (c) 2010 Stefan Achatz <erazor_de@users.sourceforge.net>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/types.h>
+
+#define DRIVER_VERSION "v0.2.4"
+#define DRIVER_AUTHOR "Stefan Achatz"
+#define DRIVER_DESC "USB Roccat Kone driver"
+#define DRIVER_LICENSE "GPL v2"
+
+struct kone_device {
+	/*
+	 * Actual values might not get called that much so I store them when
+	 * they are at hand or get them only when needed.
+	 */
+	int act_profile, act_profile_valid;
+	int act_dpi, act_dpi_valid;
+	int last_tilt_state;
+};
+
+#pragma pack(push)
+#pragma pack(1)
+
+struct kone_keystroke {
+	uint8_t key;
+	uint8_t action;
+	uint16_t period; /* in milliseconds */
+};
+
+enum kone_keystroke_buttons {
+	kone_keystroke_button_1 = 0xf0, /* left mouse button */
+	kone_keystroke_button_2 = 0xf1, /* right mouse button */
+	kone_keystroke_button_3 = 0xf2, /* wheel */
+	kone_keystroke_button_9 = 0xf3, /* side button up  \todo confirm */
+	kone_keystroke_button_8 = 0xf4 /* side button down \todo confirm */
+};
+
+enum kone_keystroke_actions {
+	kone_keystroke_action_press = 0,
+	kone_keystroke_action_release = 1
+};
+
+struct kone_button_info {
+	uint8_t number; /* range 1-8 */
+	uint8_t type;
+	uint8_t macro_type; /* 0 = short, 1 = overlong */
+	uint8_t macro_name[16]; /* can be max 15 chars long */
+	uint8_t set_name[16]; /* can be max 15 chars long */
+	uint8_t count;
+	struct kone_keystroke keystroke[20];
+};
+
+enum kone_button_info_types {
+	/* valid button types until firmware 1.32 */
+	kone_button_info_type_button_1 = 0x1, /* click (left mouse button) */
+	kone_button_info_type_button_2 = 0x2, /* menu (right mouse button)*/
+	kone_button_info_type_button_3 = 0x3, /* scroll (wheel) */
+	kone_button_info_type_double_click = 0x4,
+	kone_button_info_type_key = 0x5,
+	kone_button_info_type_macro = 0x6,
+	kone_button_info_type_off = 0x7,
+	/* TODO clarify function and rename */
+	kone_button_info_type_osd_xy_prescaling = 0x8,
+	kone_button_info_type_osd_dpi = 0x9,
+	kone_button_info_type_osd_profile = 0xa,
+	kone_button_info_type_button_9 = 0xb, /* ie forward */
+	kone_button_info_type_button_8 = 0xc, /* ie backward */
+	kone_button_info_type_dpi_up = 0xd, /* internal */
+	kone_button_info_type_dpi_down = 0xe, /* internal */
+	kone_button_info_type_button_7 = 0xf, /* tilt left */
+	kone_button_info_type_button_6 = 0x10, /* tilt right */
+	kone_button_info_type_profile_up = 0x11, /* internal */
+	kone_button_info_type_profile_down = 0x12, /* internal */
+	kone_button_info_type_overlong_macro = 0x106,
+	/* additional valid button types since firmware 1.38 */
+	kone_button_info_type_multimedia_open_player = 0x20,
+	kone_button_info_type_multimedia_next_track = 0x21,
+	kone_button_info_type_multimedia_prev_track = 0x22,
+	kone_button_info_type_multimedia_play_pause = 0x23,
+	kone_button_info_type_multimedia_stop = 0x24,
+	kone_button_info_type_multimedia_mute = 0x25,
+	kone_button_info_type_multimedia_volume_up = 0x26,
+	kone_button_info_type_multimedia_volume_down = 0x27
+};
+
+struct kone_light_info {
+	uint8_t number; /* number of light 1-5 */
+	uint8_t mod;   /* 1 = on, 2 = off */
+	uint8_t red;   /* range 0x00-0xff */
+	uint8_t green; /* range 0x00-0xff */
+	uint8_t blue;  /* range 0x00-0xff */
+};
+
+struct kone_profile {
+	uint16_t size; /* always 975 */
+	uint16_t unused; /* always 0 */
+	uint8_t profile; /* range 1-5 */
+	uint16_t main_sensitivity; /* range 100-1000 */
+	uint8_t xy_sensitivity_enabled; /* 1 = on, 2 = off */
+	uint16_t x_sensitivity; /* range 100-1000 */
+	uint16_t y_sensitivity; /* range 100-1000 */
+	uint8_t dpi_rate; /* bit 1 = 800, ... */
+	uint8_t dpi_value; /* range 1-6 */
+	uint8_t polling_rate; /* 1 = 125Hz, 2 = 500Hz, 3 = 1000Hz */
+	/* kone has no dcu
+	 * value is always 2 in firmwares <= 1.32 and
+	 * 1 in firmwares > 1.32
+	 */
+	uint8_t dcu_flag;
+	uint8_t light_effect_1; /* range 1-3 */
+	uint8_t light_effect_2; /* range 1-5 */
+	uint8_t light_effect_3; /* range 1-4 */
+	uint8_t light_effect_speed; /* range 0-255 */
+
+	struct kone_light_info light_info[5];
+	struct kone_button_info button_info[8];
+
+	uint16_t checksum; /* \brief holds checksum of struct */
+};
+
+enum kone_polling_rates {
+	kone_polling_rate_125 = 1,
+	kone_polling_rate_500 = 2,
+	kone_polling_rate_1000 = 3
+};
+
+struct kone_settings {
+	uint16_t size; /* always 36 */
+	uint8_t  startup_profile; /* 1-5 */
+	uint8_t	 unknown1;
+	uint8_t  tcu; /* 0 = off, 1 = on */
+	uint8_t  unknown2[23];
+	uint8_t  calibration_data[4];
+	uint8_t  unknown3[2];
+	uint16_t checksum;
+};
+
+/*
+ * 12 byte mouse event read by interrupt_read
+ */
+struct kone_mouse_event {
+	uint8_t report_number; /* always 1 */
+	uint8_t button;
+	uint16_t x;
+	uint16_t y;
+	uint8_t wheel; /* up = 1, down = -1 */
+	uint8_t tilt; /* right = 1, left = -1 */
+	uint8_t unknown;
+	uint8_t event;
+	uint8_t value;
+	uint8_t macro;
+};
+
+enum kone_mouse_events {
+	kone_mouse_event_osd_dpi = 0xa0,
+	kone_mouse_event_osd_profile = 0xb0,
+	/* TODO clarify meaning and occurence of kone_mouse_event_calibration */
+	kone_mouse_event_calibration = 0xc0,
+	kone_mouse_event_call_overlong_macro = 0xe0,
+	kone_mouse_event_switch_dpi = 0xf0,
+	kone_mouse_event_switch_profile = 0xf1
+};
+
+enum kone_commands {
+	kone_command_profile = 0x5a,
+	kone_command_settings = 0x15a,
+	kone_command_firmware_version = 0x25a,
+	kone_command_weight = 0x45a,
+	kone_command_calibrate = 0x55a,
+	kone_command_confirm_write = 0x65a,
+	kone_command_firmware = 0xe5a
+};
+
+#pragma pack(pop)
+
+#endif
-- 
1.6.6

