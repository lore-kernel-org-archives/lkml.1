Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052Ab0BZPUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 10:20:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965026Ab0BZPTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 10:19:11 -0500
From: Matthew Garrett <mjg@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
       Mario Limonciello <Mario_Limonciello@Dell.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       Matthew Garrett <mjg@redhat.com>,
       Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
Subject: [PATCH 03/14] compal-laptop: Replace sysfs support with rfkill support
Date: Fri, 26 Feb 2010 10:18:36 -0500
Message-Id: <1267197527-18062-4-git-send-email-mjg@redhat.com>
In-Reply-To: <1267197527-18062-1-git-send-email-mjg@redhat.com>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mario Limonciello <Mario_Limonciello@Dell.com>

This drops the support for manually groking the files in sysfs
to turn on and off the WLAN and BT for Compal laptops in favor
of platform rfkill support.

It has been combined into a single patch to not introduce regressions
in the process of simply adding rfkill support

Signed-off-by: Mario Limonciello <Mario_Limonciello@Dell.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
---
 drivers/platform/x86/compal-laptop.c |  201 +++++++++++-----------------------
 1 files changed, 63 insertions(+), 138 deletions(-)

diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index c78d254..2740b40 100644
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
@@ -51,6 +42,7 @@
 #include <linux/dmi.h>
 #include <linux/backlight.h>
 #include <linux/platform_device.h>
+#include <linux/rfkill.h>
 
 #define COMPAL_DRIVER_VERSION "0.2.6"
 
@@ -63,6 +55,10 @@
 #define WLAN_MASK	0x01
 #define BT_MASK 	0x02
 
+static struct rfkill *wifi_rfkill;
+static struct rfkill *bt_rfkill;
+static struct platform_device *compal_device;
+
 static int force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
@@ -88,65 +84,75 @@ static int get_lcd_level(void)
 	return (int) result;
 }
 
-static int set_wlan_state(int state)
+static int compal_rfkill_set(void *data, bool blocked)
 {
+	unsigned long radio = (unsigned long) data;
 	u8 result, value;
 
 	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
 
-	if ((result & KILLSWITCH_MASK) == 0)
-		return -EINVAL;
-	else {
-		if (state)
-			value = (u8) (result | WLAN_MASK);
-		else
-			value = (u8) (result & ~WLAN_MASK);
-		ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
-	}
+	if (!blocked)
+		value = (u8) (result | radio);
+	else
+		value = (u8) (result & ~radio);
+	ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
 
 	return 0;
 }
 
-static int set_bluetooth_state(int state)
+static void compal_rfkill_poll(struct rfkill *rfkill, void *data)
 {
-	u8 result, value;
+	u8 result;
+	bool hw_blocked;
 
 	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
 
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
+	hw_blocked = !(result & KILLSWITCH_MASK);
+	rfkill_set_hw_state(rfkill, hw_blocked);
 }
 
-static int get_wireless_state(int *wlan, int *bluetooth)
+static const struct rfkill_ops compal_rfkill_ops = {
+	.poll = compal_rfkill_poll,
+	.set_block = compal_rfkill_set,
+};
+
+static int setup_rfkill(void)
 {
-	u8 result;
+	int ret;
 
-	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
+	wifi_rfkill = rfkill_alloc("compal-wifi", &compal_device->dev,
+				RFKILL_TYPE_WLAN, &compal_rfkill_ops,
+				(void *) WLAN_MASK);
+	if (!wifi_rfkill)
+		return -ENOMEM;
 
-	if (wlan) {
-		if ((result & KILLSWITCH_MASK) == 0)
-			*wlan = 0;
-		else
-			*wlan = result & WLAN_MASK;
-	}
+	ret = rfkill_register(wifi_rfkill);
+	if (ret)
+		goto err_wifi;
 
-	if (bluetooth) {
-		if ((result & KILLSWITCH_MASK) == 0)
-			*bluetooth = 0;
-		else
-			*bluetooth = (result & BT_MASK) >> 1;
+	bt_rfkill = rfkill_alloc("compal-bluetooth", &compal_device->dev,
+				RFKILL_TYPE_BLUETOOTH, &compal_rfkill_ops,
+				(void *) BT_MASK);
+	if (!bt_rfkill) {
+		ret = -ENOMEM;
+		goto err_allocate_bt;
 	}
+	ret = rfkill_register(bt_rfkill);
+	if (ret)
+		goto err_register_bt;
 
 	return 0;
+
+err_register_bt:
+	rfkill_destroy(bt_rfkill);
+
+err_allocate_bt:
+	rfkill_unregister(wifi_rfkill);
+
+err_wifi:
+	rfkill_destroy(wifi_rfkill);
+
+	return ret;
 }
 
 /* Backlight device stuff */
@@ -169,86 +175,6 @@ static struct backlight_ops compalbl_ops = {
 
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
@@ -257,8 +183,6 @@ static struct platform_driver compal_driver = {
 	}
 };
 
-static struct platform_device *compal_device;
-
 /* Initialization */
 
 static int dmi_check_cb(const struct dmi_system_id *id)
@@ -389,23 +313,21 @@ static int __init compal_init(void)
 
 	ret = platform_device_add(compal_device);
 	if (ret)
-		goto fail_platform_device1;
+		goto fail_platform_device;
 
-	ret = sysfs_create_group(&compal_device->dev.kobj,
-		&compal_attribute_group);
+	ret = setup_rfkill();
 	if (ret)
-		goto fail_platform_device2;
+		goto fail_rfkill;
 
 	printk(KERN_INFO "compal-laptop: driver "COMPAL_DRIVER_VERSION
 		" successfully loaded.\n");
 
 	return 0;
 
-fail_platform_device2:
-
+fail_rfkill:
 	platform_device_del(compal_device);
 
-fail_platform_device1:
+fail_platform_device:
 
 	platform_device_put(compal_device);
 
@@ -423,10 +345,13 @@ fail_backlight:
 static void __exit compal_cleanup(void)
 {
 
-	sysfs_remove_group(&compal_device->dev.kobj, &compal_attribute_group);
 	platform_device_unregister(compal_device);
 	platform_driver_unregister(&compal_driver);
 	backlight_device_unregister(compalbl_device);
+	rfkill_unregister(wifi_rfkill);
+	rfkill_destroy(wifi_rfkill);
+	rfkill_unregister(bt_rfkill);
+	rfkill_destroy(bt_rfkill);
 
 	printk(KERN_INFO "compal-laptop: driver unloaded.\n");
 }
-- 
1.6.6.1

