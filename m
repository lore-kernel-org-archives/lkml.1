Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbZIOQUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbZIOQUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbZIOQUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:20:22 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56237 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbZIOQUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:20:08 -0400
From: Matthew Garrett <mjg@redhat.com>
To: rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/3] backlight: Transition drivers to new backlight API
Date: Tue, 15 Sep 2009 17:19:42 +0100
Message-Id: <1253031583-11286-2-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1253031583-11286-1-git-send-email-mjg@redhat.com>
References: <1253031583-11286-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 212.183.134.211
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mass transition of the backlight drivers to the new device allocation and
registration API.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/video.c                    |   25 ++++++++++++++++++++++---
 drivers/macintosh/via-pmu-backlight.c   |   14 +++++++++++---
 drivers/platform/x86/acer-wmi.c         |    5 +++--
 drivers/platform/x86/asus-laptop.c      |   21 +++++++++++++++++----
 drivers/platform/x86/asus_acpi.c        |   19 +++++++++++++++----
 drivers/platform/x86/compal-laptop.c    |   13 ++++++++++---
 drivers/platform/x86/dell-laptop.c      |   13 +++++++++++--
 drivers/platform/x86/eeepc-laptop.c     |   20 ++++++++++++++++----
 drivers/platform/x86/fujitsu-laptop.c   |   19 ++++++++++++++-----
 drivers/platform/x86/msi-laptop.c       |   13 ++++++++++---
 drivers/platform/x86/panasonic-laptop.c |   15 +++++++++++----
 drivers/platform/x86/sony-laptop.c      |   19 ++++++++++++++-----
 drivers/platform/x86/thinkpad_acpi.c    |   16 +++++++++++++---
 drivers/platform/x86/toshiba_acpi.c     |   20 ++++++++++++++++----
 drivers/usb/misc/appledisplay.c         |   21 ++++++++++++++++-----
 drivers/video/atmel_lcdfb.c             |   19 +++++++++++++++----
 drivers/video/aty/aty128fb.c            |   19 ++++++++++++++++---
 drivers/video/aty/atyfb_base.c          |   17 ++++++++++++++---
 drivers/video/aty/radeon_backlight.c    |   17 ++++++++++++++---
 drivers/video/backlight/atmel-pwm-bl.c  |   11 ++++++++---
 drivers/video/backlight/corgi_lcd.c     |   16 +++++++++++-----
 drivers/video/backlight/cr_bllcd.c      |   19 +++++++++++++++----
 drivers/video/backlight/da903x_bl.c     |   17 +++++++++++++----
 drivers/video/backlight/generic_bl.c    |   13 +++++++++++--
 drivers/video/backlight/hp680_bl.c      |   12 ++++++++++--
 drivers/video/backlight/jornada720_bl.c |   16 +++++++++++++---
 drivers/video/backlight/kb3886_bl.c     |   13 +++++++++++--
 drivers/video/backlight/locomolcd.c     |   13 +++++++++++--
 drivers/video/backlight/mbp_nvidia_bl.c |   15 +++++++++++++--
 drivers/video/backlight/omap1_bl.c      |   13 +++++++++++--
 drivers/video/backlight/progear_bl.c    |   12 ++++++++++--
 drivers/video/backlight/pwm_bl.c        |   15 ++++++++++++---
 drivers/video/backlight/tosa_bl.c       |   11 +++++++++--
 drivers/video/bf54x-lq043fb.c           |    7 +++++--
 drivers/video/bfin-t350mcqb-fb.c        |    7 +++++--
 drivers/video/nvidia/nv_backlight.c     |   17 ++++++++++++++---
 drivers/video/riva/fbdev.c              |   17 ++++++++++++++---
 37 files changed, 454 insertions(+), 115 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 60ea984..7a10fec 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -980,11 +980,29 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 			return;
 
 		sprintf(name, "acpi_video%d", count++);
-		device->backlight = backlight_device_register(name,
-			NULL, device, &acpi_backlight_ops);
+		device->backlight = backlight_alloc(name, NULL, device,
+						    &acpi_backlight_ops);
+
+		if (IS_ERR(device->backlight)) {
+			printk(KERN_ERR PREFIX
+			       "Unable to allocate backlight\n");
+			device->backlight = NULL;
+			return;
+		}
+
 		device->backlight->props.max_brightness = device->brightness->count-3;
 		kfree(name);
 
+		result = backlight_register(device->backlight);
+
+		if (result) {
+			printk(KERN_ERR PREFIX
+			       "Unable to register backlight\n");
+			backlight_destroy(device->backlight);
+			device->backlight = NULL;
+			return;
+		}
+
 		result = sysfs_create_link(&device->backlight->dev.kobj,
 					   &device->dev->dev.kobj, "device");
 		if (result)
@@ -2006,7 +2024,8 @@ static int acpi_video_bus_put_one_device(struct acpi_video_device *device)
 					    acpi_video_device_notify);
 	if (device->backlight) {
 		sysfs_remove_link(&device->backlight->dev.kobj, "device");
-		backlight_device_unregister(device->backlight);
+		backlight_unregister(device->backlight);
+		backlight_destroy(device->backlight);
 		device->backlight = NULL;
 	}
 	if (device->cdev) {
diff --git a/drivers/macintosh/via-pmu-backlight.c b/drivers/macintosh/via-pmu-backlight.c
index a348bb0..364bc5e 100644
--- a/drivers/macintosh/via-pmu-backlight.c
+++ b/drivers/macintosh/via-pmu-backlight.c
@@ -146,7 +146,7 @@ void __init pmu_backlight_init()
 {
 	struct backlight_device *bd;
 	char name[10];
-	int level, autosave;
+	int level, autosave, rc;
 
 	/* Special case for the old PowerBook since I can't test on it */
 	autosave =
@@ -161,9 +161,9 @@ void __init pmu_backlight_init()
 
 	snprintf(name, sizeof(name), "pmubl");
 
-	bd = backlight_device_register(name, NULL, NULL, &pmu_backlight_data);
+	bd = backlight_allocr(name, NULL, NULL, &pmu_backlight_data);
 	if (IS_ERR(bd)) {
-		printk(KERN_ERR "PMU Backlight registration failed\n");
+		printk(KERN_ERR "PMU Backlight allocation failed\n");
 		return;
 	}
 	uses_pmu_bl = 1;
@@ -185,6 +185,14 @@ void __init pmu_backlight_init()
 
 	bd->props.brightness = level;
 	bd->props.power = FB_BLANK_UNBLANK;
+	rc = backlight_register(bd);
+
+	if (rc) {
+		printk(KERN_ERR "PMU Backlight allocation failed\n");
+		backlight_destroy(bd);
+		return;
+	}
+
 	backlight_update_status(bd);
 
 	printk(KERN_INFO "PMU Backlight initialized (%s)\n", name);
diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index fb45f5e..ecc6d67 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -925,7 +925,7 @@ static int __devinit acer_backlight_init(struct device *dev)
 {
 	struct backlight_device *bd;
 
-	bd = backlight_device_register("acer-wmi", dev, NULL, &acer_bl_ops);
+	bd = backlight_alloc("acer-wmi", dev, NULL, &acer_bl_ops);
 	if (IS_ERR(bd)) {
 		printk(ACER_ERR "Could not register Acer backlight device\n");
 		acer_backlight_device = NULL;
@@ -943,7 +943,8 @@ static int __devinit acer_backlight_init(struct device *dev)
 
 static void acer_backlight_exit(void)
 {
-	backlight_device_unregister(acer_backlight_device);
+	backlight_unregister(acer_backlight_device);
+	backlight_destroy(acer_backlight_device);
 }
 
 /*
diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index db657bb..beb9bdf 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -1206,8 +1206,10 @@ static int asus_hotk_remove(struct acpi_device *device, int type)
 
 static void asus_backlight_exit(void)
 {
-	if (asus_backlight_device)
-		backlight_device_unregister(asus_backlight_device);
+	if (asus_backlight_device) {
+			backlight_unregister(asus_backlight_device);
+			backlight_destroy(asus_backlight_device);
+	}
 }
 
 #define  ASUS_LED_UNREGISTER(object)				\
@@ -1245,12 +1247,13 @@ static void __exit asus_laptop_exit(void)
 static int asus_backlight_init(struct device *dev)
 {
 	struct backlight_device *bd;
+	int rc;
 
 	if (brightness_set_handle && lcd_switch_handle) {
-		bd = backlight_device_register(ASUS_HOTK_FILE, dev,
+		bd = backlight_alloc(ASUS_HOTK_FILE, dev,
 					       NULL, &asusbl_ops);
 		if (IS_ERR(bd)) {
-			pr_err("Could not register asus backlight device\n");
+			pr_err("Could not allocate asus backlight device\n");
 			asus_backlight_device = NULL;
 			return PTR_ERR(bd);
 		}
@@ -1260,6 +1263,16 @@ static int asus_backlight_init(struct device *dev)
 		bd->props.max_brightness = 15;
 		bd->props.brightness = read_brightness(NULL);
 		bd->props.power = FB_BLANK_UNBLANK;
+
+		rc = backlight_register(bd);
+
+		if (rc) {
+			pr_err("Could not register asus backlight device\n");
+			asus_backlight_device = NULL;
+			backlight_destroy(bd);
+			return rc;
+		}
+
 		backlight_update_status(bd);
 	}
 	return 0;
diff --git a/drivers/platform/x86/asus_acpi.c b/drivers/platform/x86/asus_acpi.c
index ddf5240..39c5132 100644
--- a/drivers/platform/x86/asus_acpi.c
+++ b/drivers/platform/x86/asus_acpi.c
@@ -1409,8 +1409,10 @@ static struct backlight_ops asus_backlight_data = {
 
 static void asus_acpi_exit(void)
 {
-	if (asus_backlight_device)
-		backlight_device_unregister(asus_backlight_device);
+	if (asus_backlight_device) {
+			backlight_unregister(asus_backlight_device);
+			backlight_destroy(asus_backlight_device);
+	}
 
 	acpi_bus_unregister_driver(&asus_hotk_driver);
 	remove_proc_entry(PROC_ASUS, acpi_root_dir);
@@ -1450,16 +1452,25 @@ static int __init asus_acpi_init(void)
 		return -ENODEV;
 	}
 
-	asus_backlight_device = backlight_device_register("asus", NULL, NULL,
+	asus_backlight_device = backlight_alloc("asus", NULL, NULL,
 							  &asus_backlight_data);
 	if (IS_ERR(asus_backlight_device)) {
-		printk(KERN_ERR "Could not register asus backlight device\n");
+		printk(KERN_ERR "Could not allocate asus backlight device\n");
 		asus_backlight_device = NULL;
 		asus_acpi_exit();
 		return -ENODEV;
 	}
 	asus_backlight_device->props.max_brightness = 15;
 
+	result = backlight_register(asus_backlight_device);
+	if (result) {
+		printk(KERN_ERR "Coult not register asus backlight device\n");
+		backlight_destroy(asus_backlight_device);
+		asus_backlight_device = NULL;
+		asus_acpi_exit();
+		return -ENODEV;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index 11003bb..3e8510d 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -327,12 +327,17 @@ static int __init compal_init(void)
 	/* Register backlight stuff */
 
 	if (!acpi_video_backlight_support()) {
-		compalbl_device = backlight_device_register("compal-laptop", NULL, NULL,
+		compalbl_device = backlight_alloc("compal-laptop", NULL, NULL,
 							    &compalbl_ops);
 		if (IS_ERR(compalbl_device))
 			return PTR_ERR(compalbl_device);
 
 		compalbl_device->props.max_brightness = COMPAL_LCD_LEVEL_MAX-1;
+		ret = backlight_register(compalbl_device);
+		if (ret) {
+			backlight_destroy(compalbl_device);
+			return ret;
+		}
 	}
 
 	ret = platform_driver_register(&compal_driver);
@@ -375,7 +380,8 @@ fail_platform_driver:
 
 fail_backlight:
 
-	backlight_device_unregister(compalbl_device);
+	backlight_unregister(compalbl_device);
+	backlight_destroy(compalbl_device);
 
 	return ret;
 }
@@ -386,7 +392,8 @@ static void __exit compal_cleanup(void)
 	sysfs_remove_group(&compal_device->dev.kobj, &compal_attribute_group);
 	platform_device_unregister(compal_device);
 	platform_driver_unregister(&compal_driver);
-	backlight_device_unregister(compalbl_device);
+	backlight_unregister(compalbl_device);
+	backlight_destroy(compalbl_device);
 
 	printk(KERN_INFO "compal-laptop: driver unloaded.\n");
 }
diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 74909c4..413e313 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -350,7 +350,7 @@ static int __init dell_init(void)
 	}
 
 	if (max_intensity) {
-		dell_backlight_device = backlight_device_register(
+		dell_backlight_device = backlight_alloc(
 			"dell_backlight",
 			NULL, NULL,
 			&dell_ops);
@@ -364,6 +364,14 @@ static int __init dell_init(void)
 		dell_backlight_device->props.max_brightness = max_intensity;
 		dell_backlight_device->props.brightness =
 			dell_get_intensity(dell_backlight_device);
+
+		ret = backlight_register(dell_backlight_device);
+		if (ret) {
+			backlight_destroy(dell_backlight_device);
+			dell_backlight_device = NULL;
+			goto out;
+		}
+
 		backlight_update_status(dell_backlight_device);
 	}
 
@@ -381,7 +389,8 @@ out:
 
 static void __exit dell_exit(void)
 {
-	backlight_device_unregister(dell_backlight_device);
+	backlight_unregister(dell_backlight_device);
+	backlight_destroy(dell_backlight_device);
 	if (wifi_rfkill)
 		rfkill_unregister(wifi_rfkill);
 	if (bluetooth_rfkill)
diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 222ffb8..99f0e8c 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -1012,8 +1012,10 @@ static struct attribute_group hwmon_attribute_group = {
  */
 static void eeepc_backlight_exit(void)
 {
-	if (eeepc_backlight_device)
-		backlight_device_unregister(eeepc_backlight_device);
+	if (eeepc_backlight_device) {
+			backlight_unregister(eeepc_backlight_device);
+			backlight_destroy(eeepc_backlight_device);
+	}
 	eeepc_backlight_device = NULL;
 }
 
@@ -1137,11 +1139,12 @@ exit:
 static int eeepc_backlight_init(struct device *dev)
 {
 	struct backlight_device *bd;
+	int ret;
 
-	bd = backlight_device_register(EEEPC_HOTK_FILE, dev,
+	bd = backlight_alloc(EEEPC_HOTK_FILE, dev,
 				       NULL, &eeepcbl_ops);
 	if (IS_ERR(bd)) {
-		pr_err("Could not register eeepc backlight device\n");
+		pr_err("Could not allocate eeepc backlight device\n");
 		eeepc_backlight_device = NULL;
 		return PTR_ERR(bd);
 	}
@@ -1149,6 +1152,15 @@ static int eeepc_backlight_init(struct device *dev)
 	bd->props.max_brightness = 15;
 	bd->props.brightness = read_brightness(NULL);
 	bd->props.power = FB_BLANK_UNBLANK;
+
+	ret = backlight_register(eeepc_backlight_device);
+	if (ret) {
+		pr_err("Could not register eeepc backlight device\n");
+		backlight_destroy(eeepc_backlight_device);
+		eeepc_backlight_device = NULL;
+		return ret;
+	}
+
 	backlight_update_status(bd);
 	return 0;
 }
diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index 218b9a1..ec59be5 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -1128,13 +1128,18 @@ static int __init fujitsu_init(void)
 
 	if (!acpi_video_backlight_support()) {
 		fujitsu->bl_device =
-			backlight_device_register("fujitsu-laptop", NULL, NULL,
+			backlight_alloc("fujitsu-laptop", NULL, NULL,
 						  &fujitsubl_ops);
 		if (IS_ERR(fujitsu->bl_device))
 			return PTR_ERR(fujitsu->bl_device);
 		max_brightness = fujitsu->max_brightness;
 		fujitsu->bl_device->props.max_brightness = max_brightness - 1;
 		fujitsu->bl_device->props.brightness = fujitsu->brightness_level;
+		ret = backlight_register(fujitsu->bl_device);
+		if (ret) {
+			backlight_destroy(fujitsu->bl_device);
+			return ret;
+		}
 	}
 
 	ret = platform_driver_register(&fujitsupf_driver);
@@ -1180,8 +1185,10 @@ fail_hotkey:
 
 fail_backlight:
 
-	if (fujitsu->bl_device)
-		backlight_device_unregister(fujitsu->bl_device);
+	if (fujitsu->bl_device) {
+			backlight_unregister(fujitsu->bl_device);
+			backlight_destroy(fujitsu->bl_device);
+	}
 
 fail_platform_device2:
 
@@ -1216,8 +1223,10 @@ static void __exit fujitsu_cleanup(void)
 			   &fujitsupf_attribute_group);
 	platform_device_unregister(fujitsu->pf_device);
 	platform_driver_unregister(&fujitsupf_driver);
-	if (fujitsu->bl_device)
-		backlight_device_unregister(fujitsu->bl_device);
+	if (fujitsu->bl_device) {
+			backlight_unregister(fujitsu->bl_device);
+			backlight_destroy(fujitsu->bl_device);
+	}
 
 	acpi_bus_unregister_driver(&acpi_fujitsu_driver);
 
diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index 759763d..4a91572 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -351,11 +351,16 @@ static int __init msi_init(void)
 		printk(KERN_INFO "MSI: Brightness ignored, must be controlled "
 		       "by ACPI video driver\n");
 	} else {
-		msibl_device = backlight_device_register("msi-laptop-bl", NULL,
+		msibl_device = backlight_alloc("msi-laptop-bl", NULL,
 							 NULL, &msibl_ops);
 		if (IS_ERR(msibl_device))
 			return PTR_ERR(msibl_device);
 		msibl_device->props.max_brightness = MSI_LCD_LEVEL_MAX-1;
+		ret = backlight_register(msibl_device);
+		if (ret) {
+			backlight_destroy(msibl_device);
+			return ret;
+		}
 	}
 
 	ret = platform_driver_register(&msipf_driver);
@@ -403,7 +408,8 @@ fail_platform_driver:
 
 fail_backlight:
 
-	backlight_device_unregister(msibl_device);
+	backlight_unregister(msibl_device);
+	backlight_destroy(msibl_device);
 
 	return ret;
 }
@@ -414,7 +420,8 @@ static void __exit msi_cleanup(void)
 	sysfs_remove_group(&msipf_device->dev.kobj, &msipf_attribute_group);
 	platform_device_unregister(msipf_device);
 	platform_driver_unregister(&msipf_driver);
-	backlight_device_unregister(msibl_device);
+	backlight_unregister(msibl_device);
+	backlight_destroy(msibl_device);
 
 	/* Enable automatic brightness control again */
 	if (auto_brightness != 2)
diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index fe7cf01..f37e054 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -642,7 +642,7 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 	}
 
 	/* initialize backlight */
-	pcc->backlight = backlight_device_register("panasonic", NULL, pcc,
+	pcc->backlight = backlight_alloc("panasonic", NULL, pcc,
 						   &pcc_backlight_ops);
 	if (IS_ERR(pcc->backlight))
 		goto out_input;
@@ -650,7 +650,7 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 	if (!acpi_pcc_retrieve_biosdata(pcc, pcc->sinf)) {
 		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
 				 "Couldn't retrieve BIOS data\n"));
-		goto out_backlight;
+		goto out_backlight_alloc;
 	}
 
 	/* read the initial brightness setting from the hardware */
@@ -658,6 +658,10 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 					pcc->sinf[SINF_AC_MAX_BRIGHT];
 	pcc->backlight->props.brightness = pcc->sinf[SINF_AC_CUR_BRIGHT];
 
+	result = backlight_register(pcc->backlight);
+	if (result)
+		goto out_backlight_alloc;
+
 	/* read the initial sticky key mode from the hardware */
 	pcc->sticky_mode = pcc->sinf[SINF_STICKY_KEY];
 
@@ -669,7 +673,9 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 	return 0;
 
 out_backlight:
-	backlight_device_unregister(pcc->backlight);
+	backlight_unregister(pcc->backlight);
+out_backlight_alloc:
+	backlight_destroy(pcc->backlight);
 out_input:
 	input_unregister_device(pcc->input_dev);
 	/* no need to input_free_device() since core input API refcount and
@@ -708,7 +714,8 @@ static int acpi_pcc_hotkey_remove(struct acpi_device *device, int type)
 
 	sysfs_remove_group(&device->dev.kobj, &pcc_attr_group);
 
-	backlight_device_unregister(pcc->backlight);
+	backlight_unregister(pcc->backlight);
+	backlight_destroy(pcc->backlight);
 
 	input_unregister_device(pcc->input_dev);
 	/* no need to input_free_device() since core input API refcount and
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index dafaa4a..3a1dd85 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -1240,7 +1240,7 @@ static int sony_nc_add(struct acpi_device *device)
 		       "controlled by ACPI video driver\n");
 	} else if (ACPI_SUCCESS(acpi_get_handle(sony_nc_acpi_handle, "GBRT",
 						&handle))) {
-		sony_backlight_device = backlight_device_register("sony", NULL,
+		sony_backlight_device = backlight_alloc("sony", NULL,
 								  NULL,
 								  &sony_backlight_ops);
 
@@ -1253,6 +1253,11 @@ static int sony_nc_add(struct acpi_device *device)
 			    (sony_backlight_device);
 			sony_backlight_device->props.max_brightness =
 			    SONY_MAX_BRIGHTNESS - 1;
+			result = backlight_register(sony_backlight_device);
+			if (result) {
+				backlight_destroy(sony_backlight_device);
+				sony_backlight_device = NULL;
+			}
 		}
 
 	}
@@ -1309,8 +1314,10 @@ static int sony_nc_add(struct acpi_device *device)
 	sony_pf_remove();
 
       outbacklight:
-	if (sony_backlight_device)
-		backlight_device_unregister(sony_backlight_device);
+	if (sony_backlight_device) {
+			backlight_unregister(sony_backlight_device);
+			backlight_destroy(sony_backlight_device);
+	}
 
 	sony_laptop_remove_input();
 
@@ -1323,8 +1330,10 @@ static int sony_nc_remove(struct acpi_device *device, int type)
 {
 	struct sony_nc_value *item;
 
-	if (sony_backlight_device)
-		backlight_device_unregister(sony_backlight_device);
+	if (sony_backlight_device) {
+			backlight_unregister(sony_backlight_device);
+			backlight_destroy(sony_backlight_device);
+	}
 
 	sony_nc_acpi_device = NULL;
 
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index e856008..f9158fe 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -5763,11 +5763,11 @@ static int __init brightness_init(struct ibm_init_struct *iibm)
 		printk(TPACPI_INFO
 		       "detected a 16-level brightness capable ThinkPad\n");
 
-	ibm_backlight_device = backlight_device_register(
+	ibm_backlight_device = backlight_alloc(
 					TPACPI_BACKLIGHT_DEV_NAME, NULL, NULL,
 					&ibm_backlight_data);
 	if (IS_ERR(ibm_backlight_device)) {
-		printk(TPACPI_ERR "Could not register backlight device\n");
+		printk(TPACPI_ERR "Could not allocate backlight device\n");
 		return PTR_ERR(ibm_backlight_device);
 	}
 	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_BRGHT,
@@ -5785,6 +5785,15 @@ static int __init brightness_init(struct ibm_init_struct *iibm)
 	ibm_backlight_device->props.max_brightness =
 				(tp_features.bright_16levels)? 15 : 7;
 	ibm_backlight_device->props.brightness = b & TP_EC_BACKLIGHT_LVLMSK;
+
+	b = backlight_register(ibm_backlight_device);
+	if (b) {
+		printk(TPACPI_ERR "Could not register backlight device\n");
+		backlight_destroy(ibm_backlight_device);
+		return b;
+	}
+
+
 	backlight_update_status(ibm_backlight_device);
 
 	return 0;
@@ -5805,7 +5814,8 @@ static void brightness_exit(void)
 	if (ibm_backlight_device) {
 		vdbg_printk(TPACPI_DBG_EXIT | TPACPI_DBG_BRGHT,
 			    "calling backlight_device_unregister()\n");
-		backlight_device_unregister(ibm_backlight_device);
+		backlight_unregister(ibm_backlight_device);
+		backlight_destroy(ibm_backlight_device);
 	}
 
 	tpacpi_brightness_checkpoint_nvram();
diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 51c0a8b..b1da397 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -683,8 +683,10 @@ static void toshiba_acpi_exit(void)
 		rfkill_destroy(toshiba_acpi.bt_rfk);
 	}
 
-	if (toshiba_backlight_device)
-		backlight_device_unregister(toshiba_backlight_device);
+	if (toshiba_backlight_device) {
+			backlight_unregister(toshiba_backlight_device);
+			backlight_destroy(toshiba_backlight_device);
+	}
 
 	remove_device();
 
@@ -748,20 +750,30 @@ static int __init toshiba_acpi_init(void)
 		}
 	}
 
-	toshiba_backlight_device = backlight_device_register("toshiba",
+	toshiba_backlight_device = backlight_alloc("toshiba",
 						&toshiba_acpi.p_dev->dev,
 						NULL,
 						&toshiba_backlight_data);
         if (IS_ERR(toshiba_backlight_device)) {
 		ret = PTR_ERR(toshiba_backlight_device);
 
-		printk(KERN_ERR "Could not register toshiba backlight device\n");
+		printk(KERN_ERR "Could not allocate toshiba backlight device\n");
 		toshiba_backlight_device = NULL;
 		toshiba_acpi_exit();
 		return ret;
 	}
         toshiba_backlight_device->props.max_brightness = HCI_LCD_BRIGHTNESS_LEVELS - 1;
 
+	ret = backlight_register(toshiba_backlight_device);
+	if (ret) {
+		printk(KERN_ERR "Could not register toshiba backlight device\n");
+		backlight_destroy(toshiba_backlight_device);
+		toshiba_backlight_device = NULL;
+		toshiba_acpi_exit();
+		return ret;
+	}
+
+
 	/* Register rfkill switch for Bluetooth */
 	if (hci_get_bt_present(&bt_present) == HCI_SUCCESS && bt_present) {
 		toshiba_acpi.bt_rfk = rfkill_alloc(toshiba_acpi.bt_name,
diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
index 1d8e39a..6a6aeb1 100644
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -278,10 +278,10 @@ static int appledisplay_probe(struct usb_interface *iface,
 	/* Register backlight device */
 	snprintf(bl_name, sizeof(bl_name), "appledisplay%d",
 		atomic_inc_return(&count_displays) - 1);
-	pdata->bd = backlight_device_register(bl_name, NULL, pdata,
+	pdata->bd = backlight_alloc(bl_name, NULL, pdata,
 						&appledisplay_bl_data);
 	if (IS_ERR(pdata->bd)) {
-		dev_err(&iface->dev, "Backlight registration failed\n");
+		dev_err(&iface->dev, "Backlight allocation failed\n");
 		goto error;
 	}
 
@@ -300,6 +300,14 @@ static int appledisplay_probe(struct usb_interface *iface,
 	/* Set brightness in backlight device */
 	pdata->bd->props.brightness = brightness;
 
+	retval = backlight_register(pdata->bd);
+	if (retval) {
+		dev_err(&iface->dev, "Backlight registration failed\n");
+		backlight_destroy(pdata->bd);
+		goto error;
+	}
+
+
 	/* save our data pointer in the interface device */
 	usb_set_intfdata(iface, pdata);
 
@@ -316,8 +324,10 @@ error:
 					pdata->urbdata, pdata->urb->transfer_dma);
 			usb_free_urb(pdata->urb);
 		}
-		if (pdata->bd && !IS_ERR(pdata->bd))
-			backlight_device_unregister(pdata->bd);
+		if (pdata->bd && !IS_ERR(pdata->bd)) {
+				backlight_unregister(pdata->bd);
+				backlight_destroy(pdata->bd);
+		}
 		kfree(pdata->msgdata);
 	}
 	usb_set_intfdata(iface, NULL);
@@ -332,7 +342,8 @@ static void appledisplay_disconnect(struct usb_interface *iface)
 	if (pdata) {
 		usb_kill_urb(pdata->urb);
 		cancel_delayed_work(&pdata->work);
-		backlight_device_unregister(pdata->bd);
+		backlight_unregister(pdata->bd);
+		backlight_destroy(pdata->bd);
 		usb_buffer_free(pdata->udev, ACD_URB_BUFFER_LEN,
 			pdata->urbdata, pdata->urb->transfer_dma);
 		usb_free_urb(pdata->urb);
diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 2830ffd..2244bc1 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -118,16 +118,17 @@ static struct backlight_ops atmel_lcdc_bl_ops = {
 static void init_backlight(struct atmel_lcdfb_info *sinfo)
 {
 	struct backlight_device	*bl;
+	int ret;
 
 	sinfo->bl_power = FB_BLANK_UNBLANK;
 
 	if (sinfo->backlight)
 		return;
 
-	bl = backlight_device_register("backlight", &sinfo->pdev->dev,
+	bl = backlight_alloc("backlight", &sinfo->pdev->dev,
 			sinfo, &atmel_lcdc_bl_ops);
 	if (IS_ERR(bl)) {
-		dev_err(&sinfo->pdev->dev, "error %ld on backlight register\n",
+		dev_err(&sinfo->pdev->dev, "error %ld on backlight allocate\n",
 				PTR_ERR(bl));
 		return;
 	}
@@ -137,12 +138,22 @@ static void init_backlight(struct atmel_lcdfb_info *sinfo)
 	bl->props.fb_blank = FB_BLANK_UNBLANK;
 	bl->props.max_brightness = 0xff;
 	bl->props.brightness = atmel_bl_get_brightness(bl);
+
+	ret = backlight_register(bl);
+	if (ret) {
+		dev_err(&sinfo->pdev->dev, "error %d on backlight register\n",
+			ret);
+		backlight_destroy(bl);
+		return;
+	}
 }
 
 static void exit_backlight(struct atmel_lcdfb_info *sinfo)
 {
-	if (sinfo->backlight)
-		backlight_device_unregister(sinfo->backlight);
+	if (sinfo->backlight) {
+			backlight_unregister(sinfo->backlight);
+			backlight_destroy(sinfo->backlight);
+	}
 }
 
 #else
diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index e4e4d43..66293c1 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -1805,6 +1805,7 @@ static void aty128_bl_init(struct aty128fb_par *par)
 	struct fb_info *info = pci_get_drvdata(par->pdev);
 	struct backlight_device *bd;
 	char name[12];
+	int ret;
 
 	/* Could be extended to Rage128Pro LVDS output too */
 	if (par->chip_gen != rage_M3)
@@ -1817,10 +1818,10 @@ static void aty128_bl_init(struct aty128fb_par *par)
 
 	snprintf(name, sizeof(name), "aty128bl%d", info->node);
 
-	bd = backlight_device_register(name, info->dev, par, &aty128_bl_data);
+	bd = backlight_alloc(name, info->dev, par, &aty128_bl_data);
 	if (IS_ERR(bd)) {
 		info->bl_dev = NULL;
-		printk(KERN_WARNING "aty128: Backlight registration failed\n");
+		printk(KERN_WARNING "aty128: Backlight allocation failed\n");
 		goto error;
 	}
 
@@ -1832,6 +1833,17 @@ static void aty128_bl_init(struct aty128fb_par *par)
 	bd->props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd->props.brightness = bd->props.max_brightness;
 	bd->props.power = FB_BLANK_UNBLANK;
+
+	ret = backlight_register(bd);
+
+	if (ret) {
+		backlight_destroy(info->bl_dev);
+		info->bl_dev = NULL;
+		printk(KERN_WARNING "aty128: Backlight registration failed\n");
+		goto error;
+	}
+
+
 	backlight_update_status(bd);
 
 	printk("aty128: Backlight initialized (%s)\n", name);
@@ -1844,7 +1856,8 @@ error:
 
 static void aty128_bl_exit(struct backlight_device *bd)
 {
-	backlight_device_unregister(bd);
+	backlight_unregister(bd);
+	backlight_destroy(bd);
 	printk("aty128: Backlight unloaded\n");
 }
 #endif /* CONFIG_FB_ATY128_BACKLIGHT */
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index 63d3739..1327392 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -2175,6 +2175,7 @@ static void aty_bl_init(struct atyfb_par *par)
 	struct fb_info *info = pci_get_drvdata(par->pdev);
 	struct backlight_device *bd;
 	char name[12];
+	int ret;
 
 #ifdef CONFIG_PMAC_BACKLIGHT
 	if (!pmac_has_backlight_type("ati"))
@@ -2183,10 +2184,10 @@ static void aty_bl_init(struct atyfb_par *par)
 
 	snprintf(name, sizeof(name), "atybl%d", info->node);
 
-	bd = backlight_device_register(name, info->dev, par, &aty_bl_data);
+	bd = backlight_alloc(name, info->dev, par, &aty_bl_data);
 	if (IS_ERR(bd)) {
 		info->bl_dev = NULL;
-		printk(KERN_WARNING "aty: Backlight registration failed\n");
+		printk(KERN_WARNING "aty: Backlight allocation failed\n");
 		goto error;
 	}
 
@@ -2198,6 +2199,15 @@ static void aty_bl_init(struct atyfb_par *par)
 	bd->props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd->props.brightness = bd->props.max_brightness;
 	bd->props.power = FB_BLANK_UNBLANK;
+
+	ret = backlight_register(bd);
+	if (IS_ERR(bd)) {
+		backlight_destroy(bd);
+		info->bl_dev = NULL;
+		printk(KERN_WARNING "aty: Backlight registration failed\n");
+		goto error;
+	}
+
 	backlight_update_status(bd);
 
 	printk("aty: Backlight initialized (%s)\n", name);
@@ -2210,7 +2220,8 @@ error:
 
 static void aty_bl_exit(struct backlight_device *bd)
 {
-	backlight_device_unregister(bd);
+	backlight_unregister(bd);
+	backlight_destroy(bd);
 	printk("aty: Backlight unloaded\n");
 }
 
diff --git a/drivers/video/aty/radeon_backlight.c b/drivers/video/aty/radeon_backlight.c
index 1a056ad..72fecf1 100644
--- a/drivers/video/aty/radeon_backlight.c
+++ b/drivers/video/aty/radeon_backlight.c
@@ -137,6 +137,7 @@ void radeonfb_bl_init(struct radeonfb_info *rinfo)
 	struct backlight_device *bd;
 	struct radeon_bl_privdata *pdata;
 	char name[12];
+	int ret;
 
 	if (rinfo->mon1_type != MT_LCD)
 		return;
@@ -155,10 +156,10 @@ void radeonfb_bl_init(struct radeonfb_info *rinfo)
 
 	snprintf(name, sizeof(name), "radeonbl%d", rinfo->info->node);
 
-	bd = backlight_device_register(name, rinfo->info->dev, pdata, &radeon_bl_data);
+	bd = backlight_alloc(name, rinfo->info->dev, pdata, &radeon_bl_data);
 	if (IS_ERR(bd)) {
 		rinfo->info->bl_dev = NULL;
-		printk("radeonfb: Backlight registration failed\n");
+		printk(KERN_INFO "radeonfb: Backlight allocation failed\n");
 		goto error;
 	}
 
@@ -188,6 +189,15 @@ void radeonfb_bl_init(struct radeonfb_info *rinfo)
 	bd->props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd->props.brightness = bd->props.max_brightness;
 	bd->props.power = FB_BLANK_UNBLANK;
+
+	ret = backlight_register(bd);
+	if (ret) {
+		backlight_destroy(bd);
+		rinfo->info->bl_dev = NULL;
+		printk(KERN_INFO "radeonfb: Backlight registration failed\n");
+		goto error;
+	}
+
 	backlight_update_status(bd);
 
 	printk("radeonfb: Backlight initialized (%s)\n", name);
@@ -207,7 +217,8 @@ void radeonfb_bl_exit(struct radeonfb_info *rinfo)
 		struct radeon_bl_privdata *pdata;
 
 		pdata = bl_get_data(bd);
-		backlight_device_unregister(bd);
+		backlight_unregister(bd);
+		backlight_destroy(bd);
 		kfree(pdata);
 		rinfo->info->bl_dev = NULL;
 
diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index 505c082..deacfb1 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -165,7 +165,7 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
 			goto err_free_gpio;
 	}
 
-	bldev = backlight_device_register("atmel-pwm-bl",
+	bldev = backlight_alloc("atmel-pwm-bl",
 			&pdev->dev, pwmbl, &atmel_pwm_bl_ops);
 	if (IS_ERR(bldev)) {
 		retval = PTR_ERR(bldev);
@@ -187,11 +187,15 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
 
 	atmel_pwm_bl_set_intensity(bldev);
 
+	retval = backlight_register(bldev);
+	if (retval)
+		goto err_free_bl_dev;
+
 	return 0;
 
 err_free_bl_dev:
 	platform_set_drvdata(pdev, NULL);
-	backlight_device_unregister(bldev);
+	backlight_destroy(bldev);
 err_free_gpio:
 	if (pwmbl->gpio_on != -1)
 		gpio_free(pwmbl->gpio_on);
@@ -212,7 +216,8 @@ static int __exit atmel_pwm_bl_remove(struct platform_device *pdev)
 	}
 	pwm_channel_disable(&pwmbl->pwmc);
 	pwm_channel_free(&pwmbl->pwmc);
-	backlight_device_unregister(pwmbl->bldev);
+	backlight_unregister(pwmbl->bldev);
+	backlight_destroy(pwmbl->bldev);
 	platform_set_drvdata(pdev, NULL);
 	kfree(pwmbl);
 
diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index f8a4bb2..3da3571 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -558,7 +558,7 @@ static int __devinit corgi_lcd_probe(struct spi_device *spi)
 	lcd->power = FB_BLANK_POWERDOWN;
 	lcd->mode = (pdata) ? pdata->init_mode : CORGI_LCD_MODE_VGA;
 
-	lcd->bl_dev = backlight_device_register("corgi_bl", &spi->dev,
+	lcd->bl_dev = backlight_alloc("corgi_bl", &spi->dev,
 					lcd, &corgi_bl_ops);
 	if (IS_ERR(lcd->bl_dev)) {
 		ret = PTR_ERR(lcd->bl_dev);
@@ -570,20 +570,25 @@ static int __devinit corgi_lcd_probe(struct spi_device *spi)
 
 	ret = setup_gpio_backlight(lcd, pdata);
 	if (ret)
-		goto err_unregister_bl;
+		goto err_free_bl;
 
 	lcd->kick_battery = pdata->kick_battery;
 
 	dev_set_drvdata(&spi->dev, lcd);
 	corgi_lcd_set_power(lcd->lcd_dev, FB_BLANK_UNBLANK);
+
+	ret = backlight_register(lcd->bl_dev);
+	if (ret)
+		goto err_free_bl;
+
 	backlight_update_status(lcd->bl_dev);
 
 	lcd->limit_mask = pdata->limit_mask;
 	the_corgi_lcd = lcd;
 	return 0;
 
-err_unregister_bl:
-	backlight_device_unregister(lcd->bl_dev);
+err_free_bl:
+	backlight_destroy(lcd->bl_dev);
 err_unregister_lcd:
 	lcd_device_unregister(lcd->lcd_dev);
 err_free_lcd:
@@ -598,7 +603,8 @@ static int __devexit corgi_lcd_remove(struct spi_device *spi)
 	lcd->bl_dev->props.power = FB_BLANK_UNBLANK;
 	lcd->bl_dev->props.brightness = 0;
 	backlight_update_status(lcd->bl_dev);
-	backlight_device_unregister(lcd->bl_dev);
+	backlight_unregister(lcd->bl_dev);
+	backlight_destroy(lcd->bl_dev);
 
 	if (gpio_is_valid(lcd->gpio_backlight_on))
 		gpio_free(lcd->gpio_backlight_on);
diff --git a/drivers/video/backlight/cr_bllcd.c b/drivers/video/backlight/cr_bllcd.c
index b9fe62b..2a73cea 100644
--- a/drivers/video/backlight/cr_bllcd.c
+++ b/drivers/video/backlight/cr_bllcd.c
@@ -174,6 +174,7 @@ static int cr_backlight_probe(struct platform_device *pdev)
 	struct lcd_device *ldp;
 	struct cr_panel *crp;
 	u8 dev_en;
+	int ret;
 
 	lpc_dev = pci_get_device(PCI_VENDOR_ID_INTEL,
 					CRVML_DEVICE_LPC, NULL);
@@ -190,7 +191,7 @@ static int cr_backlight_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	bdp = backlight_device_register("cr-backlight",
+	bdp = backlight_alloc("cr-backlight",
 					&pdev->dev, NULL, &cr_backlight_ops);
 	if (IS_ERR(bdp)) {
 		pci_dev_put(lpc_dev);
@@ -199,7 +200,7 @@ static int cr_backlight_probe(struct platform_device *pdev)
 
 	ldp = lcd_device_register("cr-lcd", &pdev->dev, NULL, &cr_lcd_ops);
 	if (IS_ERR(ldp)) {
-		backlight_device_unregister(bdp);
+		backlight_destroy(bdp);
 		pci_dev_put(lpc_dev);
 		return PTR_ERR(bdp);
 	}
@@ -211,7 +212,7 @@ static int cr_backlight_probe(struct platform_device *pdev)
 	crp = kzalloc(sizeof(*crp), GFP_KERNEL);
 	if (!crp) {
 		lcd_device_unregister(ldp);
-		backlight_device_unregister(bdp);
+		backlight_destroy(bdp);
 		pci_dev_put(lpc_dev);
 		return -ENOMEM;
 	}
@@ -223,6 +224,15 @@ static int cr_backlight_probe(struct platform_device *pdev)
 	crp->cr_backlight_device->props.max_brightness = 0;
 	cr_backlight_set_intensity(crp->cr_backlight_device);
 
+	ret = backlight_register(bdp);
+	if (ret) {
+		kfree(crp);
+		lcd_device_unregister(ldp);
+		backlight_destroy(bdp);
+		pci_dev_put(lpc_dev);
+		return ret;
+	}
+
 	cr_lcd_set_power(crp->cr_lcd_device, FB_BLANK_UNBLANK);
 
 	platform_set_drvdata(pdev, crp);
@@ -238,7 +248,8 @@ static int cr_backlight_remove(struct platform_device *pdev)
 	crp->cr_backlight_device->props.max_brightness = 0;
 	cr_backlight_set_intensity(crp->cr_backlight_device);
 	cr_lcd_set_power(crp->cr_lcd_device, FB_BLANK_POWERDOWN);
-	backlight_device_unregister(crp->cr_backlight_device);
+	backlight_unregister(crp->cr_backlight_device);
+	backlight_destroy(crp->cr_backlight_device);
 	lcd_device_unregister(crp->cr_lcd_device);
 	pci_dev_put(lpc_dev);
 
diff --git a/drivers/video/backlight/da903x_bl.c b/drivers/video/backlight/da903x_bl.c
index 93bb434..87f6dc9 100644
--- a/drivers/video/backlight/da903x_bl.c
+++ b/drivers/video/backlight/da903x_bl.c
@@ -103,7 +103,7 @@ static int da903x_backlight_probe(struct platform_device *pdev)
 {
 	struct da903x_backlight_data *data;
 	struct backlight_device *bl;
-	int max_brightness;
+	int max_brightness, ret;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (data == NULL)
@@ -127,10 +127,10 @@ static int da903x_backlight_probe(struct platform_device *pdev)
 	data->da903x_dev = pdev->dev.parent;
 	data->current_brightness = 0;
 
-	bl = backlight_device_register(pdev->name, data->da903x_dev,
+	bl = backlight_alloc(pdev->name, data->da903x_dev,
 			data, &da903x_backlight_ops);
 	if (IS_ERR(bl)) {
-		dev_err(&pdev->dev, "failed to register backlight\n");
+		dev_err(&pdev->dev, "failed to allocate backlight\n");
 		kfree(data);
 		return PTR_ERR(bl);
 	}
@@ -138,6 +138,14 @@ static int da903x_backlight_probe(struct platform_device *pdev)
 	bl->props.max_brightness = max_brightness;
 	bl->props.brightness = max_brightness;
 
+	ret = backlight_register(bl);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register backlight\n");
+		backlight_destroy(bl);
+		kfree(data);
+		return ret;
+	}
+
 	platform_set_drvdata(pdev, bl);
 	backlight_update_status(bl);
 	return 0;
@@ -148,7 +156,8 @@ static int da903x_backlight_remove(struct platform_device *pdev)
 	struct backlight_device *bl = platform_get_drvdata(pdev);
 	struct da903x_backlight_data *data = bl_get_data(bl);
 
-	backlight_device_unregister(bl);
+	backlight_unregister(bl);
+	backlight_destroy(bl);
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/video/backlight/generic_bl.c b/drivers/video/backlight/generic_bl.c
index 6d27f62..903e3d7 100644
--- a/drivers/video/backlight/generic_bl.c
+++ b/drivers/video/backlight/generic_bl.c
@@ -81,6 +81,7 @@ static int genericbl_probe(struct platform_device *pdev)
 	struct generic_bl_info *machinfo = pdev->dev.platform_data;
 	const char *name = "generic-bl";
 	struct backlight_device *bd;
+	int ret;
 
 	bl_machinfo = machinfo;
 	if (!machinfo->limit_mask)
@@ -89,7 +90,7 @@ static int genericbl_probe(struct platform_device *pdev)
 	if (machinfo->name)
 		name = machinfo->name;
 
-	bd = backlight_device_register (name,
+	bd = backlight_alloc(name,
 		&pdev->dev, NULL, &genericbl_ops);
 	if (IS_ERR (bd))
 		return PTR_ERR (bd);
@@ -99,6 +100,13 @@ static int genericbl_probe(struct platform_device *pdev)
 	bd->props.max_brightness = machinfo->max_intensity;
 	bd->props.power = FB_BLANK_UNBLANK;
 	bd->props.brightness = machinfo->default_intensity;
+
+	ret = backlight_register(bd);
+	if (ret) {
+		backlight_destroy(bd);
+		return ret;
+	}
+
 	backlight_update_status(bd);
 
 	generic_backlight_device = bd;
@@ -115,7 +123,8 @@ static int genericbl_remove(struct platform_device *pdev)
 	bd->props.brightness = 0;
 	backlight_update_status(bd);
 
-	backlight_device_unregister(bd);
+	backlight_unregister(bd);
+	backlight_destroy(bd);
 
 	printk("Generic Backlight Driver Unloaded\n");
 	return 0;
diff --git a/drivers/video/backlight/hp680_bl.c b/drivers/video/backlight/hp680_bl.c
index 5be55a2..bff2817 100644
--- a/drivers/video/backlight/hp680_bl.c
+++ b/drivers/video/backlight/hp680_bl.c
@@ -106,8 +106,9 @@ static struct backlight_ops hp680bl_ops = {
 static int __init hp680bl_probe(struct platform_device *pdev)
 {
 	struct backlight_device *bd;
+	int ret;
 
-	bd = backlight_device_register ("hp680-bl", &pdev->dev, NULL,
+	bd = backlight_alloc("hp680-bl", &pdev->dev, NULL,
 		    &hp680bl_ops);
 	if (IS_ERR(bd))
 		return PTR_ERR(bd);
@@ -118,6 +119,12 @@ static int __init hp680bl_probe(struct platform_device *pdev)
 	bd->props.brightness = HP680_DEFAULT_INTENSITY;
 	hp680bl_send_intensity(bd);
 
+	ret = backlight_register(bd);
+	if (ret) {
+		backlight_destroy(bd);
+		return ret;
+	}
+
 	return 0;
 }
 
@@ -129,7 +136,8 @@ static int hp680bl_remove(struct platform_device *pdev)
 	bd->props.power = 0;
 	hp680bl_send_intensity(bd);
 
-	backlight_device_unregister(bd);
+	backlight_unregister(bd);
+	backlight_destroy(bd);
 
 	return 0;
 }
diff --git a/drivers/video/backlight/jornada720_bl.c b/drivers/video/backlight/jornada720_bl.c
index 7aed256..a9911dc 100644
--- a/drivers/video/backlight/jornada720_bl.c
+++ b/drivers/video/backlight/jornada720_bl.c
@@ -104,11 +104,12 @@ static int jornada_bl_probe(struct platform_device *pdev)
 	int ret;
 	struct backlight_device *bd;
 
-	bd = backlight_device_register(S1D_DEVICENAME, &pdev->dev, NULL, &jornada_bl_ops);
+	bd = backlight_alloc(S1D_DEVICENAME, &pdev->dev, NULL, &jornada_bl_ops);
 
 	if (IS_ERR(bd)) {
 		ret = PTR_ERR(bd);
-		printk(KERN_ERR "bl : failed to register device, err=%x\n", ret);
+		printk(KERN_ERR "bl : failed to allocate device, err=%x\n",
+		       ret);
 		return ret;
 	}
 
@@ -120,6 +121,14 @@ static int jornada_bl_probe(struct platform_device *pdev)
 	bd->props.max_brightness = BL_MAX_BRIGHT;
 	jornada_bl_update_status(bd);
 
+	ret = backlight_register(bd);
+	if (ret) {
+		backlight_destroy(bd);
+		printk(KERN_ERR "bl : failed to register device, err=%x\n",
+		       ret);
+		return ret;
+	}
+
 	platform_set_drvdata(pdev, bd);
 	printk(KERN_INFO "HP Jornada 700 series backlight driver\n");
 
@@ -130,7 +139,8 @@ static int jornada_bl_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bd = platform_get_drvdata(pdev);
 
-	backlight_device_unregister(bd);
+	backlight_unregister(bd);
+	backlight_destroy(bd);
 
 	return 0;
 }
diff --git a/drivers/video/backlight/kb3886_bl.c b/drivers/video/backlight/kb3886_bl.c
index a38fda1..8ac42ff 100644
--- a/drivers/video/backlight/kb3886_bl.c
+++ b/drivers/video/backlight/kb3886_bl.c
@@ -142,12 +142,13 @@ static struct backlight_ops kb3886bl_ops = {
 static int kb3886bl_probe(struct platform_device *pdev)
 {
 	struct kb3886bl_machinfo *machinfo = pdev->dev.platform_data;
+	int ret;
 
 	bl_machinfo = machinfo;
 	if (!machinfo->limit_mask)
 		machinfo->limit_mask = -1;
 
-	kb3886_backlight_device = backlight_device_register("kb3886-bl",
+	kb3886_backlight_device = backlight_alloc("kb3886-bl",
 		&pdev->dev, NULL, &kb3886bl_ops);
 	if (IS_ERR(kb3886_backlight_device))
 		return PTR_ERR(kb3886_backlight_device);
@@ -157,6 +158,13 @@ static int kb3886bl_probe(struct platform_device *pdev)
 	kb3886_backlight_device->props.max_brightness = machinfo->max_intensity;
 	kb3886_backlight_device->props.power = FB_BLANK_UNBLANK;
 	kb3886_backlight_device->props.brightness = machinfo->default_intensity;
+
+	ret = backlight_register(kb3886_backlight_device);
+	if (ret) {
+		backlight_destroy(kb3886_backlight_device);
+		return ret;
+	}
+
 	backlight_update_status(kb3886_backlight_device);
 
 	return 0;
@@ -166,7 +174,8 @@ static int kb3886bl_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bd = platform_get_drvdata(pdev);
 
-	backlight_device_unregister(bd);
+	backlight_unregister(bd);
+	backlight_destroy(bd);
 
 	return 0;
 }
diff --git a/drivers/video/backlight/locomolcd.c b/drivers/video/backlight/locomolcd.c
index 6b488b8..e686104 100644
--- a/drivers/video/backlight/locomolcd.c
+++ b/drivers/video/backlight/locomolcd.c
@@ -168,6 +168,7 @@ static int locomolcd_resume(struct locomo_dev *dev)
 static int locomolcd_probe(struct locomo_dev *ldev)
 {
 	unsigned long flags;
+	int ret;
 
 	local_irq_save(flags);
 	locomolcd_dev = ldev;
@@ -182,7 +183,8 @@ static int locomolcd_probe(struct locomo_dev *ldev)
 
 	local_irq_restore(flags);
 
-	locomolcd_bl_device = backlight_device_register("locomo-bl", &ldev->dev, NULL, &locomobl_data);
+	locomolcd_bl_device = backlight_alloc("locomo-bl", &ldev->dev, NULL,
+					      &locomobl_data);
 
 	if (IS_ERR (locomolcd_bl_device))
 		return PTR_ERR (locomolcd_bl_device);
@@ -192,6 +194,12 @@ static int locomolcd_probe(struct locomo_dev *ldev)
 	locomolcd_bl_device->props.brightness = 2;
 	locomolcd_set_intensity(locomolcd_bl_device);
 
+	ret = backlight_register(locomolcd_bl_device);
+	if (ret) {
+		backlight_destroy(locomolcd_bl_device);
+		return ret;
+	}
+
 	return 0;
 }
 
@@ -203,7 +211,8 @@ static int locomolcd_remove(struct locomo_dev *dev)
 	locomolcd_bl_device->props.power = 0;
 	locomolcd_set_intensity(locomolcd_bl_device);
 
-	backlight_device_unregister(locomolcd_bl_device);
+	backlight_unregister(locomolcd_bl_device);
+	backlight_destroy(locomolcd_bl_device);
 	local_irq_save(flags);
 	locomolcd_dev = NULL;
 	local_irq_restore(flags);
diff --git a/drivers/video/backlight/mbp_nvidia_bl.c b/drivers/video/backlight/mbp_nvidia_bl.c
index 3bb4c0a..1cc7c4e 100644
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -196,6 +196,8 @@ static const struct dmi_system_id __initdata mbp_device_table[] = {
 
 static int __init mbp_init(void)
 {
+	int ret;
+
 	if (!dmi_check_system(mbp_device_table))
 		return -ENODEV;
 
@@ -203,7 +205,7 @@ static int __init mbp_init(void)
 						"Macbook Pro backlight"))
 		return -ENXIO;
 
-	mbp_backlight_device = backlight_device_register("mbp_backlight",
+	mbp_backlight_device = backlight_alloc("mbp_backlight",
 					NULL, NULL, &driver_data->backlight_ops);
 	if (IS_ERR(mbp_backlight_device)) {
 		release_region(driver_data->iostart, driver_data->iolen);
@@ -213,6 +215,14 @@ static int __init mbp_init(void)
 	mbp_backlight_device->props.max_brightness = 15;
 	mbp_backlight_device->props.brightness =
 		driver_data->backlight_ops.get_brightness(mbp_backlight_device);
+
+	ret = backlight_register(mbp_backlight_device);
+	if (ret) {
+		backlight_destroy(mbp_backlight_device);
+		release_region(driver_data->iostart, driver_data->iolen);
+		return ret;
+	}
+
 	backlight_update_status(mbp_backlight_device);
 
 	return 0;
@@ -220,7 +230,8 @@ static int __init mbp_init(void)
 
 static void __exit mbp_exit(void)
 {
-	backlight_device_unregister(mbp_backlight_device);
+	backlight_unregister(mbp_backlight_device);
+	backlight_destroy(mbp_backlight_device);
 
 	release_region(driver_data->iostart, driver_data->iolen);
 }
diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index cbad67e..b8a707a 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -135,6 +135,7 @@ static int omapbl_probe(struct platform_device *pdev)
 	struct backlight_device *dev;
 	struct omap_backlight *bl;
 	struct omap_backlight_config *pdata = pdev->dev.platform_data;
+	int ret;
 
 	if (!pdata)
 		return -ENXIO;
@@ -145,7 +146,7 @@ static int omapbl_probe(struct platform_device *pdev)
 	if (unlikely(!bl))
 		return -ENOMEM;
 
-	dev = backlight_device_register("omap-bl", &pdev->dev, bl, &omapbl_ops);
+	dev = backlight_alloc("omap-bl", &pdev->dev, bl, &omapbl_ops);
 	if (IS_ERR(dev)) {
 		kfree(bl);
 		return PTR_ERR(dev);
@@ -166,6 +167,13 @@ static int omapbl_probe(struct platform_device *pdev)
 	dev->props.brightness = pdata->default_intensity;
 	omapbl_update_status(dev);
 
+	ret = backlight_register(dev);
+	if (ret) {
+		backlight_destroy(dev);
+		kfree(bl);
+		return ret;
+	}
+
 	printk(KERN_INFO "OMAP LCD backlight initialised\n");
 
 	return 0;
@@ -176,7 +184,8 @@ static int omapbl_remove(struct platform_device *pdev)
 	struct backlight_device *dev = platform_get_drvdata(pdev);
 	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
 
-	backlight_device_unregister(dev);
+	backlight_unregister(dev);
+	backlight_destroy(dev);
 	kfree(bl);
 
 	return 0;
diff --git a/drivers/video/backlight/progear_bl.c b/drivers/video/backlight/progear_bl.c
index 9edaf24..5331e37 100644
--- a/drivers/video/backlight/progear_bl.c
+++ b/drivers/video/backlight/progear_bl.c
@@ -63,6 +63,7 @@ static int progearbl_probe(struct platform_device *pdev)
 {
 	u8 temp;
 	struct backlight_device *progear_backlight_device;
+	int ret;
 
 	pmu_dev = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101, NULL);
 	if (!pmu_dev) {
@@ -81,7 +82,7 @@ static int progearbl_probe(struct platform_device *pdev)
 	pci_read_config_byte(sb_dev, SB_MPS1, &temp);
 	pci_write_config_byte(sb_dev, SB_MPS1, temp | 0x20);
 
-	progear_backlight_device = backlight_device_register("progear-bl",
+	progear_backlight_device = backlight_alloc("progear-bl",
 							     &pdev->dev, NULL,
 							     &progearbl_ops);
 	if (IS_ERR(progear_backlight_device))
@@ -94,13 +95,20 @@ static int progearbl_probe(struct platform_device *pdev)
 	progear_backlight_device->props.max_brightness = HW_LEVEL_MAX - HW_LEVEL_MIN;
 	progearbl_set_intensity(progear_backlight_device);
 
+	ret = backlight_register(progear_backlight_device);
+	if (ret) {
+		backlight_destroy(progear_backlight_device);
+		return ret;
+	}
+
 	return 0;
 }
 
 static int progearbl_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bd = platform_get_drvdata(pdev);
-	backlight_device_unregister(bd);
+	backlight_unregister(bd);
+	backlight_destroy(bd);
 
 	return 0;
 }
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 8871662..fcdf88d 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -97,16 +97,24 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	} else
 		dev_dbg(&pdev->dev, "got pwm for backlight\n");
 
-	bl = backlight_device_register(dev_name(&pdev->dev), &pdev->dev,
+	bl = backlight_alloc(dev_name(&pdev->dev), &pdev->dev,
 			pb, &pwm_backlight_ops);
 	if (IS_ERR(bl)) {
-		dev_err(&pdev->dev, "failed to register backlight\n");
+		dev_err(&pdev->dev, "failed to allocate backlight\n");
 		ret = PTR_ERR(bl);
 		goto err_bl;
 	}
 
 	bl->props.max_brightness = data->max_brightness;
 	bl->props.brightness = data->dft_brightness;
+
+	ret = backlight_register(bl);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register backlight\n");
+		backlight_destroy(bl);
+		goto err_bl;
+	}
+
 	backlight_update_status(bl);
 
 	platform_set_drvdata(pdev, bl);
@@ -128,7 +136,8 @@ static int pwm_backlight_remove(struct platform_device *pdev)
 	struct backlight_device *bl = platform_get_drvdata(pdev);
 	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
 
-	backlight_device_unregister(bl);
+	backlight_unregister(bl);
+	backlight_destroy(bl);
 	pwm_config(pb->pwm, 0, pb->period);
 	pwm_disable(pb->pwm);
 	pwm_free(pb->pwm);
diff --git a/drivers/video/backlight/tosa_bl.c b/drivers/video/backlight/tosa_bl.c
index 43edbad..bf6083c 100644
--- a/drivers/video/backlight/tosa_bl.c
+++ b/drivers/video/backlight/tosa_bl.c
@@ -99,7 +99,7 @@ static int __devinit tosa_bl_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, data);
 	data->i2c = client;
 
-	data->bl = backlight_device_register("tosa-bl", &client->dev,
+	data->bl = backlight_alloc("tosa-bl", &client->dev,
 			data, &bl_ops);
 	if (IS_ERR(data->bl)) {
 		ret = PTR_ERR(data->bl);
@@ -110,6 +110,12 @@ static int __devinit tosa_bl_probe(struct i2c_client *client,
 	data->bl->props.max_brightness = 512 - 1;
 	data->bl->props.power = FB_BLANK_UNBLANK;
 
+	ret = backlight_register(data->bl);
+	if (ret) {
+		backlight_destroy(data->bl);
+		goto err_reg;
+	}
+
 	backlight_update_status(data->bl);
 
 	return 0;
@@ -128,7 +134,8 @@ static int __devexit tosa_bl_remove(struct i2c_client *client)
 {
 	struct tosa_bl_data *data = i2c_get_clientdata(client);
 
-	backlight_device_unregister(data->bl);
+	backlight_unregister(data->bl);
+	backlight_destroy(data->bl);
 	data->bl = NULL;
 	i2c_set_clientdata(client, NULL);
 
diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index e49ae5e..4d5e157 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -676,12 +676,14 @@ static int __devinit bfin_bf54x_probe(struct platform_device *pdev)
 	}
 #ifndef NO_BL_SUPPORT
 	bl_dev =
-	    backlight_device_register("bf54x-bl", NULL, NULL,
+	    backlight_alloc("bf54x-bl", NULL, NULL,
 				      &bfin_lq043fb_bl_ops);
 	bl_dev->props.max_brightness = 255;
 
 	lcd_dev = lcd_device_register(DRIVER_NAME, &pdev->dev, NULL, &bfin_lcd_ops);
 	lcd_dev->props.max_contrast = 255, printk(KERN_INFO "Done.\n");
+
+	backlight_register(bl_dev);
 #endif
 
 	return 0;
@@ -725,7 +727,8 @@ static int __devexit bfin_bf54x_remove(struct platform_device *pdev)
 
 #ifndef NO_BL_SUPPORT
 	lcd_device_unregister(lcd_dev);
-	backlight_device_unregister(bl_dev);
+	backlight_unregister(bl_dev);
+	backlight_destroy(bl_dev);
 #endif
 
 	unregister_framebuffer(fbinfo);
diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index 5cc36cf..d39e7ff 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -570,12 +570,14 @@ static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 	}
 #ifndef NO_BL_SUPPORT
 	bl_dev =
-	    backlight_device_register("bf52x-bl", NULL, NULL,
+	    backlight_alloc("bf52x-bl", NULL, NULL,
 				      &bfin_lq043fb_bl_ops);
 	bl_dev->props.max_brightness = 255;
 
 	lcd_dev = lcd_device_register(DRIVER_NAME, NULL, &bfin_lcd_ops);
 	lcd_dev->props.max_contrast = 255, printk(KERN_INFO "Done.\n");
+
+	backlight_register(bl_dev);
 #endif
 
 	return 0;
@@ -618,7 +620,8 @@ static int __devexit bfin_t350mcqb_remove(struct platform_device *pdev)
 
 #ifndef NO_BL_SUPPORT
 	lcd_device_unregister(lcd_dev);
-	backlight_device_unregister(bl_dev);
+	backlight_unregister(bl_dev);
+	backlight_destroy(bl_dev);
 #endif
 
 	bfin_t350mcqb_request_ports(0);
diff --git a/drivers/video/nvidia/nv_backlight.c b/drivers/video/nvidia/nv_backlight.c
index 443e3c8..b701df6 100644
--- a/drivers/video/nvidia/nv_backlight.c
+++ b/drivers/video/nvidia/nv_backlight.c
@@ -97,6 +97,7 @@ void nvidia_bl_init(struct nvidia_par *par)
 	struct fb_info *info = pci_get_drvdata(par->pci_dev);
 	struct backlight_device *bd;
 	char name[12];
+	int ret;
 
 	if (!par->FlatPanel)
 		return;
@@ -109,10 +110,10 @@ void nvidia_bl_init(struct nvidia_par *par)
 
 	snprintf(name, sizeof(name), "nvidiabl%d", info->node);
 
-	bd = backlight_device_register(name, info->dev, par, &nvidia_bl_ops);
+	bd = backlight_alloc(name, info->dev, par, &nvidia_bl_ops);
 	if (IS_ERR(bd)) {
 		info->bl_dev = NULL;
-		printk(KERN_WARNING "nvidia: Backlight registration failed\n");
+		printk(KERN_WARNING "nvidia: Backlight allocation failed\n");
 		goto error;
 	}
 
@@ -124,6 +125,15 @@ void nvidia_bl_init(struct nvidia_par *par)
 	bd->props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd->props.brightness = bd->props.max_brightness;
 	bd->props.power = FB_BLANK_UNBLANK;
+
+	ret = backlight_register(bd);
+	if (ret) {
+		backlight_destroy(bd);
+		info->bl_dev = NULL;
+		printk(KERN_WARNING "nvidia: Backlight registration failed\n");
+		goto error;
+	}
+
 	backlight_update_status(bd);
 
 	printk("nvidia: Backlight initialized (%s)\n", name);
@@ -139,6 +149,7 @@ void nvidia_bl_exit(struct nvidia_par *par)
 	struct fb_info *info = pci_get_drvdata(par->pci_dev);
 	struct backlight_device *bd = info->bl_dev;
 
-	backlight_device_unregister(bd);
+	backlight_unregister(bd);
+	backlight_destroy(bd);
 	printk("nvidia: Backlight unloaded\n");
 }
diff --git a/drivers/video/riva/fbdev.c b/drivers/video/riva/fbdev.c
index d94c57f..0ab0a35 100644
--- a/drivers/video/riva/fbdev.c
+++ b/drivers/video/riva/fbdev.c
@@ -341,6 +341,7 @@ static void riva_bl_init(struct riva_par *par)
 	struct fb_info *info = pci_get_drvdata(par->pdev);
 	struct backlight_device *bd;
 	char name[12];
+	int ret;
 
 	if (!par->FlatPanel)
 		return;
@@ -353,10 +354,10 @@ static void riva_bl_init(struct riva_par *par)
 
 	snprintf(name, sizeof(name), "rivabl%d", info->node);
 
-	bd = backlight_device_register(name, info->dev, par, &riva_bl_ops);
+	bd = backlight_alloc(name, info->dev, par, &riva_bl_ops);
 	if (IS_ERR(bd)) {
 		info->bl_dev = NULL;
-		printk(KERN_WARNING "riva: Backlight registration failed\n");
+		printk(KERN_WARNING "riva: Backlight allocation failed\n");
 		goto error;
 	}
 
@@ -368,6 +369,15 @@ static void riva_bl_init(struct riva_par *par)
 	bd->props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd->props.brightness = bd->props.max_brightness;
 	bd->props.power = FB_BLANK_UNBLANK;
+
+	ret = backlight_register(bd);
+	if (ret) {
+		backlight_destroy(bd);
+		info->bl_dev = NULL;
+		printk(KERN_WARNING "riva: Backlight registration failed\n");
+		goto error;
+	}
+
 	backlight_update_status(bd);
 
 	printk("riva: Backlight initialized (%s)\n", name);
@@ -382,7 +392,8 @@ static void riva_bl_exit(struct fb_info *info)
 {
 	struct backlight_device *bd = info->bl_dev;
 
-	backlight_device_unregister(bd);
+	backlight_unregister(bd);
+	backlight_destroy(bd);
 	printk("riva: Backlight unloaded\n");
 }
 #else
-- 
1.6.2.5

