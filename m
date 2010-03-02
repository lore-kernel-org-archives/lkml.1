Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab0CBXay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:30:54 -0500
Received: from kroah.org ([198.145.64.141]:38750 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab0CBX3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:53 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Lee, Chun-Yi" <jlee@novell.com>,
       Lennart Poettering <mzxreary@0pointer.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 60/62] msi-laptop: Detect 3G device exists by standard ec command
Date: Tue,  2 Mar 2010 15:28:59 -0800
Message-Id: <1267572541-410-60-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee, Chun-Yi <jlee@novell.com>

Detect 3G device exists by standard ec command. Driver will not create the threeg sysfs
file and threeg rfkill interface if there have no internal 3G device in MSI notebook/netbook.

Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/platform/x86/msi-laptop.c |   44 ++++++++++++++++++++++++++++--------
 1 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index af1b62f..c2b05da 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -79,6 +79,8 @@
 
 static int msi_laptop_resume(struct platform_device *device);
 
+#define MSI_STANDARD_EC_DEVICES_EXISTS_ADDRESS	0x2f
+
 static int force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
@@ -89,6 +91,7 @@ MODULE_PARM_DESC(auto_brightness, "Enable automatic brightness control (0: disab
 
 static bool old_ec_model;
 static int wlan_s, bluetooth_s, threeg_s;
+static int threeg_exists;
 
 /* Some MSI 3G netbook only have one fn key to control Wlan/Bluetooth/3G,
  * those netbook will load the SCM (windows app) to disable the original
@@ -224,6 +227,20 @@ static int get_wireless_state_ec_standard(void)
 	return 0;
 }
 
+static int get_threeg_exists(void)
+{
+	u8 rdata;
+	int result;
+
+	result = ec_read(MSI_STANDARD_EC_DEVICES_EXISTS_ADDRESS, &rdata);
+	if (result < 0)
+		return -1;
+
+	threeg_exists = !!(rdata & MSI_STANDARD_EC_3G_MASK);
+
+	return 0;
+}
+
 /* Backlight device stuff */
 
 static int bl_get_brightness(struct backlight_device *b)
@@ -561,15 +578,17 @@ static int rfkill_init(struct platform_device *sdev)
 	if (retval)
 		goto err_wlan;
 
-	rfk_threeg = rfkill_alloc("msi-threeg", &sdev->dev, RFKILL_TYPE_WWAN,
-				&rfkill_threeg_ops, NULL);
-	if (!rfk_threeg) {
-		retval = -ENOMEM;
-		goto err_threeg;
+	if (threeg_exists) {
+		rfk_threeg = rfkill_alloc("msi-threeg", &sdev->dev,
+				RFKILL_TYPE_WWAN, &rfkill_threeg_ops, NULL);
+		if (!rfk_threeg) {
+			retval = -ENOMEM;
+			goto err_threeg;
+		}
+		retval = rfkill_register(rfk_threeg);
+		if (retval)
+			goto err_threeg;
 	}
-	retval = rfkill_register(rfk_threeg);
-	if (retval)
-		goto err_threeg;
 
 	return 0;
 
@@ -649,6 +668,9 @@ static int __init msi_init(void)
 	if (force || dmi_check_system(msi_dmi_table))
 		old_ec_model = 1;
 
+	if (!old_ec_model)
+		get_threeg_exists();
+
 	if (!old_ec_model && dmi_check_system(msi_load_scm_models_dmi_table))
 		load_scm_model = 1;
 
@@ -694,7 +716,9 @@ static int __init msi_init(void)
 		goto fail_platform_device2;
 
 	if (!old_ec_model) {
-		ret = device_create_file(&msipf_device->dev, &dev_attr_threeg);
+		if (threeg_exists)
+			ret = device_create_file(&msipf_device->dev,
+						&dev_attr_threeg);
 		if (ret)
 			goto fail_platform_device2;
 	}
@@ -733,7 +757,7 @@ static void __exit msi_cleanup(void)
 {
 
 	sysfs_remove_group(&msipf_device->dev.kobj, &msipf_attribute_group);
-	if (!old_ec_model)
+	if (!old_ec_model && threeg_exists)
 		device_remove_file(&msipf_device->dev, &dev_attr_threeg);
 	platform_device_unregister(msipf_device);
 	platform_driver_unregister(&msipf_driver);
-- 
1.7.0.1

