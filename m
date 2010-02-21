Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab0BUQux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 11:50:53 -0500
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:49971 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752098Ab0BUQuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 11:50:51 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-12.arcor-online.net AB7CF1B394D
From: Stefan Achatz <erazor_de@users.sourceforge.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 2/2] HID: documentation additions and elimination of legacy filenames for Roccat Kone driver
Date: Sun, 21 Feb 2010 17:50:45 +0100
User-Agent: KMail/1.9.9
Cc: Jiri Kosina <jkosina@suse.cz>, Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       wylda@volny.cz, Pavel Machek <pavel@suse.cz>,
       Alessandro Guido <ag@alessandroguido.name>,
       Tomas Hanak <tomas.hanak@gmail.com>, Jason Noble <nobleja@polezero.com>,
       simon.windows@gmail.com, Sean Hildebrand <silverwraithii@gmail.com>,
       Sid Boyce <sboyce@blueyonder.co.uk>, Henning Glawe <glaweh@debian.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201002200911.53900.stefan_achatz@web.de> <20100221081327.GB18298@core.coreip.homeip.net>
In-Reply-To: <20100221081327.GB18298@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002211750.45618.erazor_de@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch adds more documentation and renames sysfs attributes to eliminate my legacy naming.
 Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>

---
 drivers/hid/hid-roccat-kone.c |  265 +++++++++++++++++++++++++++--------------
 drivers/hid/hid-roccat-kone.h |    7 +-
 2 files changed, 178 insertions(+), 94 deletions(-)

diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index 94a2fb9..941f5b3 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -54,6 +54,11 @@ static void kone_set_profile_checksum(struct kone_profile *profile)
 	profile->checksum = cpu_to_le16(kone_calc_profile_checksum(profile));
 }
 
+/*
+ * Checks success after writing data to mouse
+ * On success returns 0
+ * On failure returns errno
+ */
 static int kone_check_write(struct usb_device *usb_dev)
 {
 	int len;
@@ -95,6 +100,11 @@ static int kone_check_write(struct usb_device *usb_dev)
 	}
 }
 
+/*
+ * Reads settings data from mouse and stores it in @buf
+ * On success returns 0
+ * On failure returns errno
+ */
 static int kone_get_settings(struct usb_device *usb_dev,
 		struct kone_settings *buf)
 {
@@ -112,6 +122,13 @@ static int kone_get_settings(struct usb_device *usb_dev,
 	return 0;
 }
 
+/*
+ * Write settings to mouse
+ * Reads and compares stored data with new data to prevent needless write
+ * Sets checksum of supplied data
+ * On success returns 0
+ * On failure returns errno
+ */
 static int kone_set_settings(struct usb_device *usb_dev,
 		struct kone_settings const *buf)
 {
@@ -167,6 +184,11 @@ static int kone_set_settings(struct usb_device *usb_dev,
 	return 0;
 }
 
+/*
+ * Stores number of startup profile in @result
+ * On success returns 0
+ * On failure returns errno
+ */
 static int kone_get_startup_profile(struct usb_device *usb_dev, int *result)
 {
 	struct kone_settings *buf;
@@ -187,6 +209,12 @@ static int kone_get_startup_profile(struct usb_device *usb_dev, int *result)
 	return 0;
 }
 
+/*
+ * Reads profile data from mouse and stores it in @buf
+ * @number: profile number to read
+ * On success returns 0
+ * On failure returns errno
+ */
 static int kone_get_profile(struct usb_device *usb_dev,
 		struct kone_profile *buf, int number)
 {
@@ -195,6 +223,11 @@ static int kone_get_profile(struct usb_device *usb_dev,
 	if (number < 1 || number > 5)
 		return -EINVAL;
 
+	/*
+	 * The manufacturer uses a control message of type class with interface
+	 * as recipient and provides the profile number as index parameter.
+	 * This is prevented in userspace by function check_ctrlrecip.
+	 */
 	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
 			USB_REQ_CLEAR_FEATURE, USB_TYPE_CLASS
 					| USB_RECIP_INTERFACE | USB_DIR_IN,
@@ -209,6 +242,15 @@ static int kone_get_profile(struct usb_device *usb_dev,
 	return 0;
 }
 
+/*
+ * Writes profile data to mouse
+ * Reads and compares stored data with new one to reduce unnecessary writes.
+ * Sets profile number and checksum of data, so one can copy profile data
+ * from one profile to another without usage of a userland tool.
+ * @number: profile number to write
+ * On success returns 0
+ * On failure returns errno
+ */
 static int kone_set_profile(struct usb_device *usb_dev, char const *buf,
 		int number)
 {
@@ -272,6 +314,11 @@ static int kone_set_profile(struct usb_device *usb_dev, char const *buf,
 	return 0;
 }
 
+/*
+ * Reads dpi setting from startup profile and stores it in @result
+ * On success returns 0
+ * On failure returns errno
+ */
 static int kone_get_profile_startup_dpi(struct usb_device *usb_dev, int number,
 		int *result)
 {
@@ -293,6 +340,11 @@ static int kone_get_profile_startup_dpi(struct usb_device *usb_dev, int number,
 	return 0;
 }
 
+/*
+ * Reads value of "fast-clip-weight" and stores it in @result
+ * On success returns 0
+ * On failure returns errno
+ */
 static int kone_get_weight(struct usb_device *usb_dev, int *result)
 {
 	int len;
@@ -315,6 +367,11 @@ static int kone_get_weight(struct usb_device *usb_dev, int *result)
 	return 0;
 }
 
+/*
+ * Reads firmware_version of mouse and stores it in @result
+ * On success returns 0
+ * On failure returns errno
+ */
 static int kone_get_firmware_version(struct usb_device *usb_dev, int *result)
 {
 	int len;
@@ -338,7 +395,7 @@ static int kone_get_firmware_version(struct usb_device *usb_dev, int *result)
 	return 0;
 }
 
-static ssize_t kone_set_settings_raw(struct device *dev,
+static ssize_t kone_sysfs_set_settings(struct device *dev,
 		struct device_attribute *attr, char const *buf, size_t size)
 {
 	struct hid_device *hdev = dev_get_drvdata(dev);
@@ -365,7 +422,7 @@ static ssize_t kone_set_settings_raw(struct device *dev,
 	return sizeof(struct kone_settings);
 }
 
-static ssize_t kone_show_settings_raw(struct device *dev,
+static ssize_t kone_sysfs_show_settings(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct usb_interface *intf = to_usb_interface(dev);
@@ -378,7 +435,7 @@ static ssize_t kone_show_settings_raw(struct device *dev,
 	return sizeof(struct kone_settings);
 }
 
-static ssize_t kone_get_profile_raw(struct device *dev, char *buf, int number)
+static ssize_t kone_sysfs_get_profile(struct device *dev, char *buf, int number)
 {
 	struct usb_interface *intf = to_usb_interface(dev);
 	struct usb_device *usb_dev = interface_to_usbdev(intf);
@@ -389,7 +446,7 @@ static ssize_t kone_get_profile_raw(struct device *dev, char *buf, int number)
 	return sizeof(struct kone_profile);
 }
 
-static ssize_t kone_set_profile_raw(struct device *dev, char const *buf,
+static ssize_t kone_sysfs_set_profile(struct device *dev, char const *buf,
 		size_t size, int number)
 {
 	struct usb_interface *intf = to_usb_interface(dev);
@@ -407,69 +464,70 @@ static ssize_t kone_set_profile_raw(struct device *dev, char const *buf,
 	return sizeof(struct kone_profile);
 }
 
-static ssize_t kone_show_profile_1_raw(struct device *dev,
+static ssize_t kone_sysfs_show_profile_1(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	return kone_get_profile_raw(dev, buf, 1);
+	return kone_sysfs_get_profile(dev, buf, 1);
 }
 
-static ssize_t kone_set_profile_1_raw(struct device *dev,
+static ssize_t kone_sysfs_set_profile_1(struct device *dev,
 		struct device_attribute *attr, char const *buf, size_t size)
 {
-	return kone_set_profile_raw(dev, buf, size, 1);
+	return kone_sysfs_set_profile(dev, buf, size, 1);
 }
 
-static ssize_t kone_show_profile_2_raw(struct device *dev,
+static ssize_t kone_sysfs_show_profile_2(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	return kone_get_profile_raw(dev, buf, 2);
+	return kone_sysfs_get_profile(dev, buf, 2);
 }
 
-static ssize_t kone_set_profile_2_raw(struct device *dev,
+static ssize_t kone_sysfs_set_profile_2(struct device *dev,
 		struct device_attribute *attr, char const *buf, size_t size)
 {
-	return kone_set_profile_raw(dev, buf, size, 2);
+	return kone_sysfs_set_profile(dev, buf, size, 2);
 }
 
-static ssize_t kone_show_profile_3_raw(struct device *dev,
+static ssize_t kone_sysfs_show_profile_3(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	return kone_get_profile_raw(dev, buf, 3);
+	return kone_sysfs_get_profile(dev, buf, 3);
 }
 
-static ssize_t kone_set_profile_3_raw(struct device *dev,
+static ssize_t kone_sysfs_set_profile_3(struct device *dev,
 		struct device_attribute *attr, char const *buf, size_t size)
 {
-	return kone_set_profile_raw(dev, buf, size, 3);
+	return kone_sysfs_set_profile(dev, buf, size, 3);
 }
 
-static ssize_t kone_show_profile_4_raw(struct device *dev,
+static ssize_t kone_sysfs_show_profile_4(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	return kone_get_profile_raw(dev, buf, 4);
+	return kone_sysfs_get_profile(dev, buf, 4);
 }
 
-static ssize_t kone_set_profile_4_raw(struct device *dev,
+static ssize_t kone_sysfs_set_profile_4(struct device *dev,
 		struct device_attribute *attr, char const *buf, size_t size)
 {
-	return kone_set_profile_raw(dev, buf, size, 4);
+	return kone_sysfs_set_profile(dev, buf, size, 4);
 }
 
-static ssize_t kone_show_profile_5_raw(struct device *dev,
+static ssize_t kone_sysfs_show_profile_5(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	return kone_get_profile_raw(dev, buf, 5);
+	return kone_sysfs_get_profile(dev, buf, 5);
 }
 
-static ssize_t kone_set_profile_5_raw(struct device *dev,
+static ssize_t kone_sysfs_set_profile_5(struct device *dev,
 		struct device_attribute *attr, char const *buf, size_t size)
 {
-	return kone_set_profile_raw(dev, buf, size, 5);
+	return kone_sysfs_set_profile(dev, buf, size, 5);
 }
 
 /*
- * helper to fill kone_device structure with actual values
- * returns 0 on success or error
+ * Helper to fill kone_device structure with actual values
+ * On success returns 0
+ * On failure returns errno
  */
 static int kone_device_set_actual_values(struct kone_device *kone,
 		struct device *dev, int both)
@@ -498,7 +556,7 @@ static int kone_device_set_actual_values(struct kone_device *kone,
 	return 0;
 }
 
-static ssize_t kone_show_actual_profile(struct device *dev,
+static ssize_t kone_sysfs_show_actual_profile(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct hid_device *hdev = dev_get_drvdata(dev);
@@ -511,7 +569,7 @@ static ssize_t kone_show_actual_profile(struct device *dev,
 	return snprintf(buf, PAGE_SIZE, "%d\n", kone->act_profile);
 }
 
-static ssize_t kone_show_actual_dpi_raw(struct device *dev,
+static ssize_t kone_sysfs_show_actual_dpi(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct hid_device *hdev = dev_get_drvdata(dev);
@@ -525,31 +583,7 @@ static ssize_t kone_show_actual_dpi_raw(struct device *dev,
 	return snprintf(buf, PAGE_SIZE, "%d\n", kone->act_dpi);
 }
 
-static ssize_t kone_show_actual_dpi(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct hid_device *hdev = dev_get_drvdata(dev);
-	struct kone_device *kone = hid_get_drvdata(hdev);
-	int err, dpi;
-	err = kone_device_set_actual_values(kone, dev, 1);
-	if (err)
-		return err;
-
-	dpi = kone->act_dpi;
-	switch (dpi) {
-	case 0:
-		break;
-	case 6:
-		dpi = 3200;
-		break;
-	default:
-		dpi = dpi * 400;
-	}
-
-	return snprintf(buf, PAGE_SIZE, "%ddpi\n", dpi);
-}
-
-static ssize_t kone_show_weight_raw(struct device *dev,
+static ssize_t kone_sysfs_show_weight(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct usb_interface *intf = to_usb_interface(dev);
@@ -562,7 +596,7 @@ static ssize_t kone_show_weight_raw(struct device *dev,
 	return snprintf(buf, PAGE_SIZE, "%d\n", weight);
 }
 
-static ssize_t kone_show_firmware_version_raw(struct device *dev,
+static ssize_t kone_sysfs_show_firmware_version(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct usb_interface *intf = to_usb_interface(dev);
@@ -575,8 +609,8 @@ static ssize_t kone_show_firmware_version_raw(struct device *dev,
 	return snprintf(buf, PAGE_SIZE, "%d\n", firmware_version);
 }
 
-static ssize_t kone_show_tcu(struct device *dev, struct device_attribute *attr,
-		char *buf)
+static ssize_t kone_sysfs_show_tcu(struct device *dev,
+		struct device_attribute *attr, char *buf)
 {
 	struct usb_interface *intf = to_usb_interface(dev);
 	struct usb_device *usb_dev = interface_to_usbdev(intf);
@@ -624,9 +658,8 @@ static int kone_tcu_command(struct usb_device *usb_dev, int number)
 	return 0;
 }
 
-/* integer of 0 deactivates tcu, 1 activates it */
-static ssize_t kone_set_tcu(struct device *dev, struct device_attribute *attr,
-		char const *buf, size_t size)
+static ssize_t kone_sysfs_set_tcu(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t size)
 {
 	struct usb_interface *intf = to_usb_interface(dev);
 	struct usb_device *usb_dev = interface_to_usbdev(intf);
@@ -692,7 +725,7 @@ static ssize_t kone_set_tcu(struct device *dev, struct device_attribute *attr,
 	return size;
 }
 
-static ssize_t kone_show_startup_profile(struct device *dev,
+static ssize_t kone_sysfs_show_startup_profile(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
@@ -703,7 +736,7 @@ static ssize_t kone_show_startup_profile(struct device *dev,
 	return snprintf(buf, PAGE_SIZE, "%d\n", result);
 }
 
-static ssize_t kone_set_startup_profile(struct device *dev,
+static ssize_t kone_sysfs_set_startup_profile(struct device *dev,
 		struct device_attribute *attr, char const *buf, size_t size)
 {
 	struct hid_device *hdev = dev_get_drvdata(dev);
@@ -747,48 +780,85 @@ static ssize_t kone_set_startup_profile(struct device *dev,
 	return size;
 }
 
-static ssize_t kone_show_driver_version(struct device *dev,
+/*
+ * This file is used by userland software to find devices that are handled by
+ * this driver. This provides a consistent way for actual and older kernels
+ * where this driver replaced usbhid instead of generic-usb.
+ * Driver capabilities are determined by version number.
+ */
+static ssize_t kone_sysfs_show_driver_version(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, DRIVER_VERSION "\n");
 }
 
-static DEVICE_ATTR(actual_dpi_raw, S_IRUGO, kone_show_actual_dpi_raw, NULL);
-static DEVICE_ATTR(actual_dpi, S_IRUGO, kone_show_actual_dpi, NULL);
-static DEVICE_ATTR(actual_profile, S_IRUGO, kone_show_actual_profile, NULL);
-static DEVICE_ATTR(weight_raw, S_IRUGO, kone_show_weight_raw, NULL);
-static DEVICE_ATTR(profile1_raw, S_IRUGO | S_IWUGO,
-		kone_show_profile_1_raw, kone_set_profile_1_raw);
-static DEVICE_ATTR(profile2_raw, S_IRUGO | S_IWUGO,
-		kone_show_profile_2_raw, kone_set_profile_2_raw);
-static DEVICE_ATTR(profile3_raw, S_IRUGO | S_IWUGO,
-		kone_show_profile_3_raw, kone_set_profile_3_raw);
-static DEVICE_ATTR(profile4_raw, S_IRUGO | S_IWUGO,
-		kone_show_profile_4_raw, kone_set_profile_4_raw);
-static DEVICE_ATTR(profile5_raw, S_IRUGO | S_IWUGO,
-		kone_show_profile_5_raw, kone_set_profile_5_raw);
-static DEVICE_ATTR(settings_raw, S_IRUGO | S_IWUGO,
-		kone_show_settings_raw, kone_set_settings_raw);
-static DEVICE_ATTR(firmware_version_raw, S_IRUGO,
-		kone_show_firmware_version_raw, NULL);
-static DEVICE_ATTR(tcu, S_IRUGO | S_IWUGO, kone_show_tcu, kone_set_tcu);
+/*
+ * Read actual dpi settings.
+ * Returns raw value for further processing. Refer to enum kone_polling_rates to
+ * get real value.
+ */
+static DEVICE_ATTR(actual_dpi, S_IRUGO, kone_sysfs_show_actual_dpi, NULL);
+
+static DEVICE_ATTR(actual_profile, S_IRUGO, kone_sysfs_show_actual_profile,
+		NULL);
+
+/*
+ * The mouse can be equipped with one of four supplied weights from 5 to 20
+ * grams which are recognized and its value can be read out.
+ * This returns the raw value reported by the mouse for easy evaluation by
+ * software. Refer to enum kone_weights to get corresponding real weight.
+ */
+static DEVICE_ATTR(weight, S_IRUGO, kone_sysfs_show_weight, NULL);
+
+static DEVICE_ATTR(profile1, S_IRUGO | S_IWUGO,
+		kone_sysfs_show_profile_1, kone_sysfs_set_profile_1);
+static DEVICE_ATTR(profile2, S_IRUGO | S_IWUGO,
+		kone_sysfs_show_profile_2, kone_sysfs_set_profile_2);
+static DEVICE_ATTR(profile3, S_IRUGO | S_IWUGO,
+		kone_sysfs_show_profile_3, kone_sysfs_set_profile_3);
+static DEVICE_ATTR(profile4, S_IRUGO | S_IWUGO,
+		kone_sysfs_show_profile_4, kone_sysfs_set_profile_4);
+static DEVICE_ATTR(profile5, S_IRUGO | S_IWUGO,
+		kone_sysfs_show_profile_5, kone_sysfs_set_profile_5);
+
+static DEVICE_ATTR(settings, S_IRUGO | S_IWUGO,
+		kone_sysfs_show_settings, kone_sysfs_set_settings);
+
+/*
+ * Prints firmware version stored in mouse as integer.
+ * The raw value reported by the mouse is returned for easy evaluation, to get
+ * the real version number the decimal point has to be shifted 2 positions to
+ * the left. E.g. a value of 138 means 1.38.
+ */
+static DEVICE_ATTR(firmware_version, S_IRUGO,
+		kone_sysfs_show_firmware_version, NULL);
+
+/*
+ * Prints state of Tracking Control Unit as number where 0 = off and 1 = on
+ * Writing 0 deactivates tcu and writing 1 calibrates and activates the tcu
+ */
+static DEVICE_ATTR(tcu, S_IRUGO | S_IWUGO, kone_sysfs_show_tcu,
+		kone_sysfs_set_tcu);
+
+/* Prints and takes the number of the profile the mouse starts with */
 static DEVICE_ATTR(startup_profile, S_IRUGO | S_IWUGO,
-		kone_show_startup_profile, kone_set_startup_profile);
+		kone_sysfs_show_startup_profile,
+		kone_sysfs_set_startup_profile);
+
 static DEVICE_ATTR(kone_driver_version, S_IRUGO,
-		kone_show_driver_version, NULL);
+		kone_sysfs_show_driver_version, NULL);
 
 static struct attribute *kone_attributes[] = {
-		&dev_attr_actual_dpi_raw.attr,
 		&dev_attr_actual_dpi.attr,
 		&dev_attr_actual_profile.attr,
-		&dev_attr_weight_raw.attr,
-		&dev_attr_profile1_raw.attr,
-		&dev_attr_profile2_raw.attr,
-		&dev_attr_profile3_raw.attr,
-		&dev_attr_profile4_raw.attr,
-		&dev_attr_profile5_raw.attr,
-		&dev_attr_settings_raw.attr,
-		&dev_attr_firmware_version_raw.attr,
+		&dev_attr_weight.attr,
+		&dev_attr_profile1.attr,
+		&dev_attr_profile2.attr,
+		&dev_attr_profile3.attr,
+		&dev_attr_profile4.attr,
+		&dev_attr_profile5.attr,
+		&dev_attr_settings.attr,
+		&dev_attr_firmware_version.attr,
 		&dev_attr_tcu.attr,
 		&dev_attr_startup_profile.attr,
 		&dev_attr_kone_driver_version.attr,
@@ -801,6 +871,13 @@ static struct attribute_group kone_attribute_group = {
 
 static int kone_create_files(struct usb_interface *intf)
 {
+	/*
+	 * Kone consists of a mouse and a keyboard part.
+	 * Adding sysfs files only to mousepart as information about
+	 * profile and dpi change is reported only in mouseevent.
+	 * There is no way to bind only to mousepart since IGNORE_MOUSE quirk
+	 * moved to hid-apple
+	 */
 	if (intf->cur_altsetting->desc.bInterfaceProtocol
 			== USB_INTERFACE_PROTOCOL_MOUSE)
 		return sysfs_create_group(&intf->dev.kobj,
@@ -882,6 +959,10 @@ static int kone_raw_event(struct hid_device *hdev, struct hid_report *report,
 	else
 		kone->last_tilt_state = event->tilt;
 
+	/*
+	 * handle special events and keep actual profile and dpi values
+	 * up to date
+	 */
 	switch (event->event) {
 	case kone_mouse_event_osd_dpi:
 		kone->act_dpi = event->value;
diff --git a/drivers/hid/hid-roccat-kone.h b/drivers/hid/hid-roccat-kone.h
index 14f5ebf..35a5806 100644
--- a/drivers/hid/hid-roccat-kone.h
+++ b/drivers/hid/hid-roccat-kone.h
@@ -21,11 +21,12 @@
 
 struct kone_device {
 	/*
-	 * Actual values might not get called that much so I store them when
-	 * they are at hand or get them only when needed.
+	 * Storing actual values since there is no way of getting this
+	 * information from the device.
 	 */
 	int act_profile, act_profile_valid;
 	int act_dpi, act_dpi_valid;
+	/* used for neutralizing abnormal tilt button behaviour */
 	int last_tilt_state;
 };
 
@@ -163,11 +164,13 @@ struct kone_mouse_event {
 };
 
 enum kone_mouse_events {
+	/* osd events are thought to be display on screen */
 	kone_mouse_event_osd_dpi = 0xa0,
 	kone_mouse_event_osd_profile = 0xb0,
 	/* TODO clarify meaning and occurence of kone_mouse_event_calibration */
 	kone_mouse_event_calibration = 0xc0,
 	kone_mouse_event_call_overlong_macro = 0xe0,
+	/* switch events notify if user changed values wiht mousebutton click */
 	kone_mouse_event_switch_dpi = 0xf0,
 	kone_mouse_event_switch_profile = 0xf1
 };
-- 
1.6.6

