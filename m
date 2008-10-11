Return-Path: <linux-kernel-owner+w=401wt.eu-S1759685AbYJKHj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685AbYJKHj4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758178AbYJKHhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 03:37:18 -0400
Received: from vms172073pub.verizon.net ([206.46.172.73]:32817 "EHLO
	vms172073pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbYJKHhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 03:37:16 -0400
Date: Sat, 11 Oct 2008 02:36:08 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 48/85] acer-wmi: Remove wireless and bluetooth sysfs entries
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Len Brown <len.brown@intel.com>
Message-id: <7d9a06de616f69374dab00396f27cf00962a72c9.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carlos Corbacho <carlos@strangeworlds.co.uk>

These are now replaced by the rfkill interface.

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/laptops/acer-wmi.txt |   28 ++---------
 drivers/misc/acer-wmi.c            |  101 ++++++++----------------------------
 2 files changed, 25 insertions(+), 104 deletions(-)

diff --git a/Documentation/laptops/acer-wmi.txt b/Documentation/laptops/acer-wmi.txt
index 69b5dd4..2b3a6b5 100644
--- a/Documentation/laptops/acer-wmi.txt
+++ b/Documentation/laptops/acer-wmi.txt
@@ -1,7 +1,7 @@
 Acer Laptop WMI Extras Driver
 http://code.google.com/p/aceracpi
-Version 0.1
-9th February 2008
+Version 0.2
+18th August 2008
 
 Copyright 2007-2008 Carlos Corbacho <carlos@strangeworlds.co.uk>
 
@@ -87,17 +87,7 @@ acer-wmi come with built-in wireless. However, should you feel so inclined to
 ever wish to remove the card, or swap it out at some point, please get in touch
 with me, as we may well be able to gain some data on wireless card detection.
 
-To read the status of the wireless radio (0=off, 1=on):
-cat /sys/devices/platform/acer-wmi/wireless
-
-To enable the wireless radio:
-echo 1 > /sys/devices/platform/acer-wmi/wireless
-
-To disable the wireless radio:
-echo 0 > /sys/devices/platform/acer-wmi/wireless
-
-To set the state of the wireless radio when loading acer-wmi, pass:
-wireless=X (where X is 0 or 1)
+The wireless radio is exposed through rfkill.
 
 Bluetooth
 *********
@@ -117,17 +107,7 @@ For the adventurously minded - if you want to buy an internal bluetooth
 module off the internet that is compatible with your laptop and fit it, then
 it will work just fine with acer-wmi.
 
-To read the status of the bluetooth module (0=off, 1=on):
-cat /sys/devices/platform/acer-wmi/wireless
-
-To enable the bluetooth module:
-echo 1 > /sys/devices/platform/acer-wmi/bluetooth
-
-To disable the bluetooth module:
-echo 0 > /sys/devices/platform/acer-wmi/bluetooth
-
-To set the state of the bluetooth module when loading acer-wmi, pass:
-bluetooth=X (where X is 0 or 1)
+Bluetooth is exposed through rfkill.
 
 3G
 **
diff --git a/drivers/misc/acer-wmi.c b/drivers/misc/acer-wmi.c
index e3e11e8..8708d31 100644
--- a/drivers/misc/acer-wmi.c
+++ b/drivers/misc/acer-wmi.c
@@ -125,21 +125,15 @@ enum interface_flags {
 
 static int max_brightness = 0xF;
 
-static int wireless = -1;
-static int bluetooth = -1;
 static int mailled = -1;
 static int brightness = -1;
 static int threeg = -1;
 static int force_series;
 
 module_param(mailled, int, 0444);
-module_param(wireless, int, 0444);
-module_param(bluetooth, int, 0444);
 module_param(brightness, int, 0444);
 module_param(threeg, int, 0444);
 module_param(force_series, int, 0444);
-MODULE_PARM_DESC(wireless, "Set initial state of Wireless hardware");
-MODULE_PARM_DESC(bluetooth, "Set initial state of Bluetooth hardware");
 MODULE_PARM_DESC(mailled, "Set initial state of Mail LED");
 MODULE_PARM_DESC(brightness, "Set initial LCD backlight brightness");
 MODULE_PARM_DESC(threeg, "Set initial state of 3G hardware");
@@ -147,8 +141,6 @@ MODULE_PARM_DESC(force_series, "Force a different laptop series");
 
 struct acer_data {
 	int mailled;
-	int wireless;
-	int bluetooth;
 	int threeg;
 	int brightness;
 };
@@ -851,8 +843,6 @@ static void __init acer_commandline_init(void)
 	 * capability isn't available on the given interface
 	 */
 	set_u32(mailled, ACER_CAP_MAILLED);
-	set_u32(wireless, ACER_CAP_WIRELESS);
-	set_u32(bluetooth, ACER_CAP_BLUETOOTH);
 	set_u32(threeg, ACER_CAP_THREEG);
 	set_u32(brightness, ACER_CAP_BRIGHTNESS);
 }
@@ -1057,40 +1047,30 @@ static void acer_rfkill_exit(void)
 }
 
 /*
- * Read/ write bool sysfs macro
+ * sysfs interface
  */
-#define show_set_bool(value, cap) \
-static ssize_t \
-show_bool_##value(struct device *dev, struct device_attribute *attr, \
-	char *buf) \
-{ \
+static ssize_t show_bool_threeg(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
 	u32 result; \
-	acpi_status status = get_u32(&result, cap); \
-	if (ACPI_SUCCESS(status)) \
-		return sprintf(buf, "%u\n", result); \
-	return sprintf(buf, "Read error\n"); \
-} \
-\
-static ssize_t \
-set_bool_##value(struct device *dev, struct device_attribute *attr, \
-	const char *buf, size_t count) \
-{ \
-	u32 tmp = simple_strtoul(buf, NULL, 10); \
-	acpi_status status = set_u32(tmp, cap); \
-		if (ACPI_FAILURE(status)) \
-			return -EINVAL; \
-	return count; \
-} \
-static DEVICE_ATTR(value, S_IWUGO | S_IRUGO | S_IWUSR, \
-	show_bool_##value, set_bool_##value);
-
-show_set_bool(wireless, ACER_CAP_WIRELESS);
-show_set_bool(bluetooth, ACER_CAP_BLUETOOTH);
-show_set_bool(threeg, ACER_CAP_THREEG);
+	acpi_status status = get_u32(&result, ACER_CAP_THREEG);
+	if (ACPI_SUCCESS(status))
+		return sprintf(buf, "%u\n", result);
+	return sprintf(buf, "Read error\n");
+}
+
+static ssize_t set_bool_threeg(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	u32 tmp = simple_strtoul(buf, NULL, 10);
+	acpi_status status = set_u32(tmp, ACER_CAP_THREEG);
+		if (ACPI_FAILURE(status))
+			return -EINVAL;
+	return count;
+}
+static DEVICE_ATTR(threeg, S_IWUGO | S_IRUGO | S_IWUSR, show_bool_threeg,
+	set_bool_threeg);
 
-/*
- * Read interface sysfs macro
- */
 static ssize_t show_interface(struct device *dev, struct device_attribute *attr,
 	char *buf)
 {
@@ -1180,16 +1160,6 @@ pm_message_t state)
 	if (!data)
 		return -ENOMEM;
 
-	if (has_cap(ACER_CAP_WIRELESS)) {
-		get_u32(&value, ACER_CAP_WIRELESS);
-		data->wireless = value;
-	}
-
-	if (has_cap(ACER_CAP_BLUETOOTH)) {
-		get_u32(&value, ACER_CAP_BLUETOOTH);
-		data->bluetooth = value;
-	}
-
 	if (has_cap(ACER_CAP_MAILLED)) {
 		get_u32(&value, ACER_CAP_MAILLED);
 		data->mailled = value;
@@ -1210,15 +1180,6 @@ static int acer_platform_resume(struct platform_device *device)
 	if (!data)
 		return -ENOMEM;
 
-	if (has_cap(ACER_CAP_WIRELESS))
-		set_u32(data->wireless, ACER_CAP_WIRELESS);
-
-	if (has_cap(ACER_CAP_BLUETOOTH))
-		set_u32(data->bluetooth, ACER_CAP_BLUETOOTH);
-
-	if (has_cap(ACER_CAP_THREEG))
-		set_u32(data->threeg, ACER_CAP_THREEG);
-
 	if (has_cap(ACER_CAP_MAILLED))
 		set_u32(data->mailled, ACER_CAP_MAILLED);
 
@@ -1243,12 +1204,6 @@ static struct platform_device *acer_platform_device;
 
 static int remove_sysfs(struct platform_device *device)
 {
-	if (has_cap(ACER_CAP_WIRELESS))
-		device_remove_file(&device->dev, &dev_attr_wireless);
-
-	if (has_cap(ACER_CAP_BLUETOOTH))
-		device_remove_file(&device->dev, &dev_attr_bluetooth);
-
 	if (has_cap(ACER_CAP_THREEG))
 		device_remove_file(&device->dev, &dev_attr_threeg);
 
@@ -1261,20 +1216,6 @@ static int create_sysfs(void)
 {
 	int retval = -ENOMEM;
 
-	if (has_cap(ACER_CAP_WIRELESS)) {
-		retval = device_create_file(&acer_platform_device->dev,
-			&dev_attr_wireless);
-		if (retval)
-			goto error_sysfs;
-	}
-
-	if (has_cap(ACER_CAP_BLUETOOTH)) {
-		retval = device_create_file(&acer_platform_device->dev,
-			&dev_attr_bluetooth);
-		if (retval)
-			goto error_sysfs;
-	}
-
 	if (has_cap(ACER_CAP_THREEG)) {
 		retval = device_create_file(&acer_platform_device->dev,
 			&dev_attr_threeg);
-- 
1.5.5.1

