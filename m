Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab0CBXcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:32:17 -0500
Received: from kroah.org ([198.145.64.141]:38736 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab0CBX3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:51 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Lee, Chun-Yi" <jlee@novell.com>,
       Lennart Poettering <mzxreary@0pointer.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 57/62] msi-laptop: Add threeg sysfs file for support query 3G state by standard 66/62 ec command
Date: Tue,  2 Mar 2010 15:28:56 -0800
Message-Id: <1267572541-410-57-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee, Chun-Yi <jlee@novell.com>

Add threeg sysfs file for support query 3G state by standard 66/62 ec
command, the MSI standard ec interface supported this feature.

Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/platform/x86/msi-laptop.c |   31 ++++++++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index 323e994..1784d55 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -70,6 +70,7 @@
 #define MSI_STANDARD_EC_BLUETOOTH_MASK	(1 << 0)
 #define MSI_STANDARD_EC_WEBCAM_MASK	(1 << 1)
 #define MSI_STANDARD_EC_WLAN_MASK	(1 << 3)
+#define MSI_STANDARD_EC_3G_MASK		(1 << 4)
 
 static int force;
 module_param(force, bool, 0);
@@ -80,7 +81,7 @@ module_param(auto_brightness, int, 0);
 MODULE_PARM_DESC(auto_brightness, "Enable automatic brightness control (0: disabled; 1: enabled; 2: don't touch)");
 
 static bool old_ec_model;
-static int wlan_s, bluetooth_s;
+static int wlan_s, bluetooth_s, threeg_s;
 
 /* Hardware access */
 
@@ -169,6 +170,8 @@ static int get_wireless_state_ec_standard(void)
 
 	bluetooth_s = !!(rdata & MSI_STANDARD_EC_BLUETOOTH_MASK);
 
+	threeg_s = !!(rdata & MSI_STANDARD_EC_3G_MASK);
+
 	return 0;
 }
 
@@ -230,6 +233,23 @@ static ssize_t show_bluetooth(struct device *dev,
 	return sprintf(buf, "%i\n", enabled);
 }
 
+static ssize_t show_threeg(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+
+	int ret;
+
+	/* old msi ec not support 3G */
+	if (old_ec_model)
+		return -1;
+
+	ret = get_wireless_state_ec_standard();
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%i\n", threeg_s);
+}
+
 static ssize_t show_lcd_level(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
@@ -292,6 +312,7 @@ static DEVICE_ATTR(lcd_level, 0644, show_lcd_level, store_lcd_level);
 static DEVICE_ATTR(auto_brightness, 0644, show_auto_brightness, store_auto_brightness);
 static DEVICE_ATTR(bluetooth, 0444, show_bluetooth, NULL);
 static DEVICE_ATTR(wlan, 0444, show_wlan, NULL);
+static DEVICE_ATTR(threeg, 0444, show_threeg, NULL);
 
 static struct attribute *msipf_attributes[] = {
 	&dev_attr_lcd_level.attr,
@@ -412,6 +433,12 @@ static int __init msi_init(void)
 	if (ret)
 		goto fail_platform_device2;
 
+	if (!old_ec_model) {
+		ret = device_create_file(&msipf_device->dev, &dev_attr_threeg);
+		if (ret)
+			goto fail_platform_device2;
+	}
+
 	/* Disable automatic brightness control by default because
 	 * this module was probably loaded to do brightness control in
 	 * software. */
@@ -446,6 +473,8 @@ static void __exit msi_cleanup(void)
 {
 
 	sysfs_remove_group(&msipf_device->dev.kobj, &msipf_attribute_group);
+	if (!old_ec_model)
+		device_remove_file(&msipf_device->dev, &dev_attr_threeg);
 	platform_device_unregister(msipf_device);
 	platform_driver_unregister(&msipf_driver);
 	backlight_device_unregister(msibl_device);
-- 
1.7.0.1

