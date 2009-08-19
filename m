Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbZHSSfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbZHSSfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 14:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbZHSSfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 14:35:41 -0400
Received: from ausxippc101.us.dell.com ([143.166.85.207]:39705 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbZHSSfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 14:35:39 -0400
X-Loopcount0: from 10.9.160.253
From: Mario Limonciello <Mario_Limonciello@Dell.com>
To: cezary.jackiewicz@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Mario Limonciello <Mario_Limonciello@Dell.com>
Subject: [PATCH 3/3] Drop platform sysfs attributes from compal-laptop
Date: Wed, 19 Aug 2009 13:36:20 -0500
Message-Id: <1250706980-10424-1-git-send-email-Mario_Limonciello@Dell.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Now that there is rfkill support, there is no need
 to manually grok the files in sysfs
Signed-off-by: Mario Limonciello <Mario_Limonciello@Dell.com>
---
 drivers/platform/x86/compal-laptop.c |  168 +---------------------------------
 1 files changed, 4 insertions(+), 164 deletions(-)

diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index da7ead6..2c1ff8f 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -26,17 +26,8 @@
 /*
  * comapl-laptop.c - Compal laptop support.
  *
- * This driver exports a few files in /sys/devices/platform/compal-laptop/:
- *
- *   wlan - wlan subsystem state: contains 0 or 1 (rw)
- *
- *   bluetooth - Bluetooth subsystem state: contains 0 or 1 (rw)
- *
- *   raw - raw value taken from embedded controller register (ro)
- *
- * In addition to these platform device attributes the driver
- * registers itself in the Linux backlight control subsystem and is
- * available to userspace under /sys/class/backlight/compal-laptop/.
+ * The driver registers itself with the rfkill subsystem and
+ * the Linux backlight control subsystem.
  *
  * This driver might work on other laptops produced by Compal. If you
  * want to try it you can pass force=1 as argument to the module which
@@ -165,67 +156,6 @@ err_wifi:
 	return ret;
 }
 
-static int set_wlan_state(int state)
-{
-	u8 result, value;
-
-	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
-
-	if ((result & KILLSWITCH_MASK) == 0)
-		return -EINVAL;
-	else {
-		if (state)
-			value = (u8) (result | WLAN_MASK);
-		else
-			value = (u8) (result & ~WLAN_MASK);
-		ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
-	}
-
-	return 0;
-}
-
-static int set_bluetooth_state(int state)
-{
-	u8 result, value;
-
-	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
-
-	if ((result & KILLSWITCH_MASK) == 0)
-		return -EINVAL;
-	else {
-		if (state)
-			value = (u8) (result | BT_MASK);
-		else
-			value = (u8) (result & ~BT_MASK);
-		ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
-	}
-
-	return 0;
-}
-
-static int get_wireless_state(int *wlan, int *bluetooth)
-{
-	u8 result;
-
-	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
-
-	if (wlan) {
-		if ((result & KILLSWITCH_MASK) == 0)
-			*wlan = 0;
-		else
-			*wlan = result & WLAN_MASK;
-	}
-
-	if (bluetooth) {
-		if ((result & KILLSWITCH_MASK) == 0)
-			*bluetooth = 0;
-		else
-			*bluetooth = (result & BT_MASK) >> 1;
-	}
-
-	return 0;
-}
-
 /* Backlight device stuff */
 
 static int bl_get_brightness(struct backlight_device *b)
@@ -246,86 +176,6 @@ static struct backlight_ops compalbl_ops = {
 
 static struct backlight_device *compalbl_device;
 
-/* Platform device */
-
-static ssize_t show_wlan(struct device *dev,
-	struct device_attribute *attr, char *buf)
-{
-	int ret, enabled;
-
-	ret = get_wireless_state(&enabled, NULL);
-	if (ret < 0)
-		return ret;
-
-	return sprintf(buf, "%i\n", enabled);
-}
-
-static ssize_t show_raw(struct device *dev,
-	struct device_attribute *attr, char *buf)
-{
-	u8 result;
-
-	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
-
-	return sprintf(buf, "%i\n", result);
-}
-
-static ssize_t show_bluetooth(struct device *dev,
-	struct device_attribute *attr, char *buf)
-{
-	int ret, enabled;
-
-	ret = get_wireless_state(NULL, &enabled);
-	if (ret < 0)
-		return ret;
-
-	return sprintf(buf, "%i\n", enabled);
-}
-
-static ssize_t store_wlan_state(struct device *dev,
-	struct device_attribute *attr, const char *buf, size_t count)
-{
-	int state, ret;
-
-	if (sscanf(buf, "%i", &state) != 1 || (state < 0 || state > 1))
-		return -EINVAL;
-
-	ret = set_wlan_state(state);
-	if (ret < 0)
-		return ret;
-
-	return count;
-}
-
-static ssize_t store_bluetooth_state(struct device *dev,
-	struct device_attribute *attr, const char *buf, size_t count)
-{
-	int state, ret;
-
-	if (sscanf(buf, "%i", &state) != 1 || (state < 0 || state > 1))
-		return -EINVAL;
-
-	ret = set_bluetooth_state(state);
-	if (ret < 0)
-		return ret;
-
-	return count;
-}
-
-static DEVICE_ATTR(bluetooth, 0644, show_bluetooth, store_bluetooth_state);
-static DEVICE_ATTR(wlan, 0644, show_wlan, store_wlan_state);
-static DEVICE_ATTR(raw, 0444, show_raw, NULL);
-
-static struct attribute *compal_attributes[] = {
-	&dev_attr_bluetooth.attr,
-	&dev_attr_wlan.attr,
-	&dev_attr_raw.attr,
-	NULL
-};
-
-static struct attribute_group compal_attribute_group = {
-	.attrs = compal_attributes
-};
 
 static struct platform_driver compal_driver = {
 	.driver = {
@@ -464,12 +314,7 @@ static int __init compal_init(void)
 
 	ret = platform_device_add(compal_device);
 	if (ret)
-		goto fail_platform_device1;
-
-	ret = sysfs_create_group(&compal_device->dev.kobj,
-		&compal_attribute_group);
-	if (ret)
-		goto fail_platform_device2;
+		goto fail_platform_device;
 
 	ret = setup_rfkill();
 	if (ret)
@@ -481,11 +326,7 @@ static int __init compal_init(void)
 	return 0;
 
 fail_rfkill:
-fail_platform_device2:
-
-	platform_device_del(compal_device);
-
-fail_platform_device1:
+fail_platform_device:
 
 	platform_device_put(compal_device);
 
@@ -503,7 +344,6 @@ fail_backlight:
 static void __exit compal_cleanup(void)
 {
 
-	sysfs_remove_group(&compal_device->dev.kobj, &compal_attribute_group);
 	platform_device_unregister(compal_device);
 	platform_driver_unregister(&compal_driver);
 	backlight_device_unregister(compalbl_device);
-- 
1.6.3.3

