Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab0CHQEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 11:04:34 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:44628 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328Ab0CHQEc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 11:04:32 -0500
From: Stefan Achatz <stefan_achatz@web.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4/4] Added locks for sysfs attributes and internal data.
Date: Mon, 8 Mar 2010 17:04:29 +0100
User-Agent: KMail/1.9.9
Cc: Jiri Kosina <jkosina@suse.cz>, Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       wylda@volny.cz, Pavel Machek <pavel@suse.cz>,
       Alessandro Guido <ag@alessandroguido.name>,
       Tomas Hanak <tomas.hanak@gmail.com>, Jason Noble <nobleja@polezero.com>,
       simon.windows@gmail.com, Sean Hildebrand <silverwraithii@gmail.com>,
       Sid Boyce <sboyce@blueyonder.co.uk>, Henning Glawe <glaweh@debian.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201002200911.53900.stefan_achatz@web.de> <31758929.1286552.1266912188132.JavaMail.fmail@mwmweb006> <20100226074422.GA17062@core.coreip.homeip.net>
In-Reply-To: <20100226074422.GA17062@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <201003081704.30119.stefan_achatz@web.de>
X-Provags-ID: V01U2FsdGVkX1/eVzn4EophXVJGk6DECe0mCz6s8Npen45Tp2hO
	ul/WKHOWnIierA5vX+wfTZJVY7wBb2IAle22M6jsu/5ryFzx4c
	fab27Z9dlc53Lsz/JYwA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 47678162da8e374d6f132db21d89b718ee5cfbd1 Mon Sep 17 00:00:00 2001
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Date: Mon, 8 Mar 2010 16:54:19 +0100
Subject: [PATCH 4/4] Added locks for sysfs attributes and internal data.

Added mutex lock to prevent different processes from accessing
sysfs attributes at the same time.
Added spin lock for internal data.
---
 drivers/hid/hid-roccat-kone.c |  246 ++++++++++++++++++++++++++++------------
 drivers/hid/hid-roccat-kone.h |    9 +-
 2 files changed, 179 insertions(+), 76 deletions(-)

diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index 941f5b3..eded7d4 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -223,11 +223,6 @@ static int kone_get_profile(struct usb_device *usb_dev,
 	if (number < 1 || number > 5)
 		return -EINVAL;
 
-	/*
-	 * The manufacturer uses a control message of type class with interface
-	 * as recipient and provides the profile number as index parameter.
-	 * This is prevented in userspace by function check_ctrlrecip.
-	 */
 	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
 			USB_REQ_CLEAR_FEATURE, USB_TYPE_CLASS
 					| USB_RECIP_INTERFACE | USB_DIR_IN,
@@ -398,16 +393,18 @@ static int kone_get_firmware_version(struct usb_device *usb_dev, int *result)
 static ssize_t kone_sysfs_set_settings(struct device *dev,
 		struct device_attribute *attr, char const *buf, size_t size)
 {
-	struct hid_device *hdev = dev_get_drvdata(dev);
-	struct kone_device *kone = hid_get_drvdata(hdev);
-	struct usb_interface *intf = to_usb_interface(dev);
-	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
 	int err;
+	unsigned long flags;
 
 	if (size != sizeof(struct kone_settings))
 		return -EINVAL;
 
+	mutex_lock(&kone->kone_lock);
 	err = kone_set_settings(usb_dev, (struct kone_settings const *)buf);
+	mutex_unlock(&kone->kone_lock);
+
 	if (err)
 		return err;
 
@@ -415,9 +412,10 @@ static ssize_t kone_sysfs_set_settings(struct device *dev,
 	 * If we get here, treat buf as okay (apart from checksum) and use value
 	 * of startup_profile as its at hand
 	 */
+	spin_lock_irqsave(&kone->actual_lock, flags);
 	kone->act_profile = ((struct kone_settings *)buf)->startup_profile;
-	kone->act_profile_valid = 1;
-	kone->act_dpi_valid = 0;
+	kone->act_dpi = -1;
+	spin_unlock_irqrestore(&kone->actual_lock, flags);
 
 	return sizeof(struct kone_settings);
 }
@@ -425,10 +423,14 @@ static ssize_t kone_sysfs_set_settings(struct device *dev,
 static ssize_t kone_sysfs_show_settings(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct usb_interface *intf = to_usb_interface(dev);
-	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
 	int err;
+
+	mutex_lock(&kone->kone_lock);
 	err = kone_get_settings(usb_dev, (struct kone_settings *)buf);
+	mutex_unlock(&kone->kone_lock);
+
 	if (err)
 		return err;
 
@@ -437,10 +439,14 @@ static ssize_t kone_sysfs_show_settings(struct device *dev,
 
 static ssize_t kone_sysfs_get_profile(struct device *dev, char *buf, int number)
 {
-	struct usb_interface *intf = to_usb_interface(dev);
-	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
 	int err;
+
+	mutex_lock(&kone->kone_lock);
 	err = kone_get_profile(usb_dev, (struct kone_profile *)buf, number);
+	mutex_unlock(&kone->kone_lock);
+
 	if (err)
 		return err;
 	return sizeof(struct kone_profile);
@@ -449,15 +455,17 @@ static ssize_t kone_sysfs_get_profile(struct device *dev, char *buf, int number)
 static ssize_t kone_sysfs_set_profile(struct device *dev, char const *buf,
 		size_t size, int number)
 {
-	struct usb_interface *intf = to_usb_interface(dev);
-	struct usb_device *usb_dev = interface_to_usbdev(intf);
-
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
 	int err;
 
 	if (size != sizeof(struct kone_profile))
 		return -EINVAL;
 
+	mutex_lock(&kone->kone_lock);
 	err = kone_set_profile(usb_dev, buf, number);
+	mutex_unlock(&kone->kone_lock);
+
 	if (err)
 		return err;
 
@@ -525,32 +533,68 @@ static ssize_t kone_sysfs_set_profile_5(struct device *dev,
 }
 
 /*
- * Helper to fill kone_device structure with actual values
- * On success returns 0
- * On failure returns errno
+ * Fills act_profile in kone_device.
+ * Also writes result in @result.
+ * Once act_profile is valid, its not getting invalid any more.
+ * Returns on success 0, on failure errno
  */
-static int kone_device_set_actual_values(struct kone_device *kone,
-		struct device *dev, int both)
+static int kone_device_set_actual_profile(struct kone_device *kone,
+		struct device *dev, int *result)
 {
-	struct usb_interface *intf = to_usb_interface(dev);
-	struct usb_device *usb_dev = interface_to_usbdev(intf);
-	int err;
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int err, temp;
+	unsigned long flags;
 
-	/* first make sure profile is valid */
-	if (!kone->act_profile_valid) {
-		err = kone_get_startup_profile(usb_dev, &kone->act_profile);
+	spin_lock_irqsave(&kone->actual_lock, flags);
+	if (kone->act_profile == -1) {
+		spin_unlock_irqrestore(&kone->actual_lock, flags);
+		err = kone_get_startup_profile(usb_dev, &temp);
 		if (err)
 			return err;
-		kone->act_profile_valid = 1;
+		spin_lock_irq(&kone->actual_lock);
+		kone->act_profile = temp;
+		spin_unlock_irqrestore(&kone->actual_lock, flags);
+		if (result)
+			*result = temp;
+	} else {
+		if (result)
+			*result = kone->act_profile;
+		spin_unlock_irqrestore(&kone->actual_lock, flags);
 	}
+	return 0;
+}
+
+/*
+ * Fills act_dpi in kone_device.
+ * Also writes result in @result.
+ * On success returns 0
+ * On failure returns errno
+ */
+static int kone_device_set_actual_dpi(struct kone_device *kone,
+		struct device *dev, int *result)
+{
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int err, temp;
+	unsigned long flags;
+
+	kone_device_set_actual_profile(kone, dev, NULL);
 
-	/* then get startup dpi value */
-	if (!kone->act_dpi_valid && both) {
+	spin_lock_irqsave(&kone->actual_lock, flags);
+	if (kone->act_dpi == -1) {
+		spin_unlock_irqrestore(&kone->actual_lock, flags);
 		err = kone_get_profile_startup_dpi(usb_dev, kone->act_profile,
-				&kone->act_dpi);
+				&temp);
 		if (err)
 			return err;
-		kone->act_dpi_valid = 1;
+		spin_lock_irqsave(&kone->actual_lock, flags);
+		kone->act_dpi = temp;
+		spin_unlock_irqrestore(&kone->actual_lock, flags);
+		if (result)
+			*result = temp;
+	} else {
+		if (result)
+			*result = kone->act_dpi;
+		spin_unlock_irqrestore(&kone->actual_lock, flags);
 	}
 
 	return 0;
@@ -559,38 +603,47 @@ static int kone_device_set_actual_values(struct kone_device *kone,
 static ssize_t kone_sysfs_show_actual_profile(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct hid_device *hdev = dev_get_drvdata(dev);
-	struct kone_device *kone = hid_get_drvdata(hdev);
-	int err;
-	err = kone_device_set_actual_values(kone, dev, 0);
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+	int err, temp = 0;
+
+	mutex_lock(&kone->kone_lock);
+	err = kone_device_set_actual_profile(kone, dev, &temp);
+	mutex_unlock(&kone->kone_lock);
+
 	if (err)
 		return err;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", kone->act_profile);
+	return snprintf(buf, PAGE_SIZE, "%d\n", temp);
 }
 
 static ssize_t kone_sysfs_show_actual_dpi(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct hid_device *hdev = dev_get_drvdata(dev);
-	struct kone_device *kone = hid_get_drvdata(hdev);
-	int err;
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+	int err, temp = 0;
+
+	mutex_lock(&kone->kone_lock);
+	err = kone_device_set_actual_dpi(kone, dev, &temp);
+	mutex_unlock(&kone->kone_lock);
 
-	err = kone_device_set_actual_values(kone, dev, 1);
 	if (err)
 		return err;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", kone->act_dpi);
+	return snprintf(buf, PAGE_SIZE, "%d\n", temp);
 }
 
 static ssize_t kone_sysfs_show_weight(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct usb_interface *intf = to_usb_interface(dev);
-	struct usb_device *usb_dev = interface_to_usbdev(intf);
-	int weight;
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int weight = 0;
 	int retval;
+
+	mutex_lock(&kone->kone_lock);
 	retval = kone_get_weight(usb_dev, &weight);
+	mutex_unlock(&kone->kone_lock);
+
 	if (retval)
 		return retval;
 	return snprintf(buf, PAGE_SIZE, "%d\n", weight);
@@ -599,11 +652,15 @@ static ssize_t kone_sysfs_show_weight(struct device *dev,
 static ssize_t kone_sysfs_show_firmware_version(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct usb_interface *intf = to_usb_interface(dev);
-	struct usb_device *usb_dev = interface_to_usbdev(intf);
-	int firmware_version;
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int firmware_version = 0;
 	int retval;
+
+	mutex_lock(&kone->kone_lock);
 	retval = kone_get_firmware_version(usb_dev, &firmware_version);
+	mutex_unlock(&kone->kone_lock);
+
 	if (retval)
 		return retval;
 	return snprintf(buf, PAGE_SIZE, "%d\n", firmware_version);
@@ -612,8 +669,8 @@ static ssize_t kone_sysfs_show_firmware_version(struct device *dev,
 static ssize_t kone_sysfs_show_tcu(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct usb_interface *intf = to_usb_interface(dev);
-	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
 	int err, result;
 	struct kone_settings *settings;
 
@@ -621,7 +678,10 @@ static ssize_t kone_sysfs_show_tcu(struct device *dev,
 	if (!settings)
 		return -ENOMEM;
 
+	mutex_lock(&kone->kone_lock);
 	err = kone_get_settings(usb_dev, settings);
+	mutex_unlock(&kone->kone_lock);
+
 	if (err) {
 		kfree(settings);
 		return err;
@@ -661,8 +721,8 @@ static int kone_tcu_command(struct usb_device *usb_dev, int number)
 static ssize_t kone_sysfs_set_tcu(struct device *dev,
 		struct device_attribute *attr, char const *buf, size_t size)
 {
-	struct usb_interface *intf = to_usb_interface(dev);
-	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
 	int err;
 	unsigned long state;
 	struct kone_settings *settings;
@@ -674,23 +734,35 @@ static ssize_t kone_sysfs_set_tcu(struct device *dev,
 	if (state != 0 && state != 1)
 		return -EINVAL;
 
+	mutex_lock(&kone->kone_lock);
+
 	if (state == 1) { /* state activate */
 		err = kone_tcu_command(usb_dev, 1);
-		if (err)
+		if (err) {
+			mutex_unlock(&kone->kone_lock);
 			return err;
+		}
 		err = kone_tcu_command(usb_dev, 2);
-		if (err)
+		if (err) {
+			mutex_unlock(&kone->kone_lock);
 			return err;
+		}
 		ssleep(5); /* tcu needs this time for calibration */
 		err = kone_tcu_command(usb_dev, 3);
-		if (err)
+		if (err) {
+			mutex_unlock(&kone->kone_lock);
 			return err;
+		}
 		err = kone_tcu_command(usb_dev, 0);
-		if (err)
+		if (err) {
+			mutex_unlock(&kone->kone_lock);
 			return err;
+		}
 		err = kone_tcu_command(usb_dev, 4);
-		if (err)
+		if (err) {
+			mutex_unlock(&kone->kone_lock);
 			return err;
+		}
 		/*
 		 * Kone needs this time to settle things.
 		 * Reading settings too early will result in invalid data.
@@ -701,11 +773,14 @@ static ssize_t kone_sysfs_set_tcu(struct device *dev,
 	}
 
 	settings = kmalloc(sizeof(struct kone_settings), GFP_KERNEL);
-	if (!settings)
+	if (!settings) {
+		mutex_unlock(&kone->kone_lock);
 		return -ENOMEM;
+	}
 
 	err = kone_get_settings(usb_dev, settings);
 	if (err) {
+		mutex_unlock(&kone->kone_lock);
 		kfree(settings);
 		return err;
 	}
@@ -716,11 +791,14 @@ static ssize_t kone_sysfs_set_tcu(struct device *dev,
 
 		err = kone_set_settings(usb_dev, settings);
 		if (err) {
+			mutex_unlock(&kone->kone_lock);
 			kfree(settings);
 			return err;
 		}
 	}
 
+	mutex_unlock(&kone->kone_lock);
+
 	kfree(settings);
 	return size;
 }
@@ -728,23 +806,27 @@ static ssize_t kone_sysfs_set_tcu(struct device *dev,
 static ssize_t kone_sysfs_show_startup_profile(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
 	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
 	int err, result;
+
+	mutex_lock(&kone->kone_lock);
 	err = kone_get_startup_profile(usb_dev, &result);
+	mutex_unlock(&kone->kone_lock);
+
 	if (err)
 		return err;
+
 	return snprintf(buf, PAGE_SIZE, "%d\n", result);
 }
 
 static ssize_t kone_sysfs_set_startup_profile(struct device *dev,
 		struct device_attribute *attr, char const *buf, size_t size)
 {
-	struct hid_device *hdev = dev_get_drvdata(dev);
-	struct kone_device *kone = hid_get_drvdata(hdev);
-	struct usb_interface *intf = to_usb_interface(dev);
-	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
 	int err;
-	unsigned long new_profile;
+	unsigned long new_profile, flags;
 	struct kone_settings *settings;
 
 	err = strict_strtoul(buf, 10, &new_profile);
@@ -758,8 +840,11 @@ static ssize_t kone_sysfs_set_startup_profile(struct device *dev,
 	if (!settings)
 		return -ENOMEM;
 
+	mutex_lock(&kone->kone_lock);
+
 	err = kone_get_settings(usb_dev, settings);
 	if (err) {
+		mutex_unlock(&kone->kone_lock);
 		kfree(settings);
 		return err;
 	}
@@ -767,16 +852,21 @@ static ssize_t kone_sysfs_set_startup_profile(struct device *dev,
 	settings->startup_profile = new_profile;
 
 	err = kone_set_settings(usb_dev, settings);
+
+	mutex_unlock(&kone->kone_lock);
+
 	if (err) {
 		kfree(settings);
 		return err;
 	}
 
+	spin_lock_irqsave(&kone->actual_lock, flags);
 	kone->act_profile = new_profile;
-	kone->act_profile_valid = 1;
-	kone->act_dpi_valid = 0;
+	kone->act_dpi = -1;
+	spin_unlock_irqrestore(&kone->actual_lock, flags);
 
 	kfree(settings);
+
 	return size;
 }
 
@@ -904,6 +994,10 @@ static int kone_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		dev_err(&hdev->dev, "can't alloc device descriptor\n");
 		return -ENOMEM;
 	}
+	mutex_init(&kone->kone_lock);
+	spin_lock_init(&kone->actual_lock);
+	kone->act_dpi = -1;
+	kone->act_profile = -1;
 
 	hid_set_drvdata(hdev, kone);
 	ret = hid_parse(hdev);
@@ -965,26 +1059,30 @@ static int kone_raw_event(struct hid_device *hdev, struct hid_report *report,
 	 */
 	switch (event->event) {
 	case kone_mouse_event_osd_dpi:
+		spin_lock(&kone->actual_lock);
 		kone->act_dpi = event->value;
-		kone->act_dpi_valid = 1;
-		dev_dbg(&hdev->dev, "osd dpi event. actual dpi %d (and %d)\n",
-				event->value, kone->act_dpi);
+		spin_unlock(&kone->actual_lock);
+		dev_dbg(&hdev->dev, "osd dpi event. actual dpi %d\n",
+				event->value);
 		return 1; /* return 1 if event was handled */
 	case kone_mouse_event_switch_dpi:
+		spin_lock(&kone->actual_lock);
 		kone->act_dpi = event->value;
-		kone->act_dpi_valid = 1;
+		spin_unlock(&kone->actual_lock);
 		dev_dbg(&hdev->dev, "switched dpi to %d\n", event->value);
 		return 1;
 	case kone_mouse_event_osd_profile:
+		spin_lock(&kone->actual_lock);
 		kone->act_profile = event->value;
-		kone->act_profile_valid = 1;
+		spin_unlock(&kone->actual_lock);
 		dev_dbg(&hdev->dev, "osd profile event. actual profile %d\n",
 				event->value);
 		return 1;
 	case kone_mouse_event_switch_profile:
+		spin_lock(&kone->actual_lock);
 		kone->act_profile = event->value;
-		kone->act_profile_valid = 1;
-		kone->act_dpi_valid = 0;
+		kone->act_dpi = -1;
+		spin_unlock(&kone->actual_lock);
 		dev_dbg(&hdev->dev, "switched profile to %d\n", event->value);
 		return 1;
 	case kone_mouse_event_call_overlong_macro:
diff --git a/drivers/hid/hid-roccat-kone.h b/drivers/hid/hid-roccat-kone.h
index 35a5806..9878f05 100644
--- a/drivers/hid/hid-roccat-kone.h
+++ b/drivers/hid/hid-roccat-kone.h
@@ -24,10 +24,15 @@ struct kone_device {
 	 * Storing actual values since there is no way of getting this
 	 * information from the device.
 	 */
-	int act_profile, act_profile_valid;
-	int act_dpi, act_dpi_valid;
+	int act_profile, act_dpi;
+	/* ensuring actual values are only accessed by one task at a time */
+	spinlock_t actual_lock;
+
 	/* used for neutralizing abnormal tilt button behaviour */
 	int last_tilt_state;
+
+	/* ensuring only one sysfs task accesses hardware at a time */
+	struct mutex kone_lock;
 };
 
 #pragma pack(push)
-- 
1.6.6.1

