Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab0BQVkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 16:40:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756767Ab0BQVkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 16:40:02 -0500
From: Matthew Garrett <mjg@redhat.com>
To: rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/2] backlight: Allow properties to be passed at registration
Date: Wed, 17 Feb 2010 16:39:44 -0500
Message-Id: <1266442785-3998-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Values such as max_brightness should be set before backlights are
registered, but the current API doesn't allow that. Add a parameter to
backlight_device_register and update drivers to ensure that they
set this correctly.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/video.c                            |    9 +++++--
 drivers/gpu/drm/nouveau/nouveau_backlight.c     |   12 +++++++---
 drivers/macintosh/via-pmu-backlight.c           |    7 ++++-
 drivers/platform/x86/acer-wmi.c                 |    7 ++++-
 drivers/platform/x86/asus-laptop.c              |    8 ++++--
 drivers/platform/x86/asus_acpi.c                |    7 ++++-
 drivers/platform/x86/classmate-laptop.c         |    8 ++++--
 drivers/platform/x86/compal-laptop.c            |   11 ++++++---
 drivers/platform/x86/dell-laptop.c              |   13 +++++++----
 drivers/platform/x86/eeepc-laptop.c             |    8 ++++--
 drivers/platform/x86/fujitsu-laptop.c           |   14 ++++++++----
 drivers/platform/x86/msi-laptop.c               |    7 ++++-
 drivers/platform/x86/msi-wmi.c                  |    9 +++++--
 drivers/platform/x86/panasonic-laptop.c         |   24 +++++++++++-----------
 drivers/platform/x86/sony-laptop.c              |    8 ++++--
 drivers/platform/x86/thinkpad_acpi.c            |   12 ++++++----
 drivers/platform/x86/toshiba_acpi.c             |   10 +++++---
 drivers/staging/samsung-laptop/samsung-laptop.c |    7 ++++-
 drivers/usb/misc/appledisplay.c                 |    7 +++--
 drivers/video/atmel_lcdfb.c                     |    8 ++++--
 drivers/video/aty/aty128fb.c                    |    7 ++++-
 drivers/video/aty/atyfb_base.c                  |    7 ++++-
 drivers/video/aty/radeon_backlight.c            |    7 ++++-
 drivers/video/backlight/adp5520_bl.c            |   11 +++++----
 drivers/video/backlight/adx_bl.c                |    8 ++++--
 drivers/video/backlight/atmel-pwm-bl.c          |    8 ++++--
 drivers/video/backlight/backlight.c             |    8 ++++++-
 drivers/video/backlight/corgi_lcd.c             |    8 ++++--
 drivers/video/backlight/cr_bllcd.c              |    8 +++---
 drivers/video/backlight/da903x_bl.c             |    7 +++--
 drivers/video/backlight/generic_bl.c            |    8 ++++--
 drivers/video/backlight/hp680_bl.c              |    8 ++++--
 drivers/video/backlight/jornada720_bl.c         |    7 ++++-
 drivers/video/backlight/kb3886_bl.c             |    8 +++++-
 drivers/video/backlight/locomolcd.c             |    8 +++++-
 drivers/video/backlight/mbp_nvidia_bl.c         |   10 ++++++--
 drivers/video/backlight/omap1_bl.c              |    7 ++++-
 drivers/video/backlight/progear_bl.c            |    7 ++++-
 drivers/video/backlight/pwm_bl.c                |    8 ++++--
 drivers/video/backlight/tosa_bl.c               |    8 ++++--
 drivers/video/backlight/wm831x_bl.c             |    7 +++--
 drivers/video/bf54x-lq043fb.c                   |    9 ++++---
 drivers/video/bfin-t350mcqb-fb.c                |    9 ++++---
 drivers/video/nvidia/nv_backlight.c             |    7 ++++-
 drivers/video/omap2/displays/panel-taal.c       |   15 ++++++++-----
 drivers/video/riva/fbdev.c                      |    7 ++++-
 include/linux/backlight.h                       |    3 +-
 47 files changed, 263 insertions(+), 148 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index b765790..716b0e7 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -992,6 +992,7 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 	}
 
 	if (acpi_video_backlight_support()) {
+		struct backlight_properties props;
 		int result;
 		static int count = 0;
 		char *name;
@@ -1004,12 +1005,14 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 			return;
 
 		sprintf(name, "acpi_video%d", count++);
-		device->backlight = backlight_device_register(name,
-			NULL, device, &acpi_backlight_ops);
+		memset(&props, 0, sizeof(struct backlight_properties));
+		props.max_brightness = device->brightness->count - 3;
+		device->backlight = backlight_device_register(name, NULL, device,
+							      &acpi_backlight_ops,
+							      &props);
 		kfree(name);
 		if (IS_ERR(device->backlight))
 			return;
-		device->backlight->props.max_brightness = device->brightness->count-3;
 
 		result = sysfs_create_link(&device->backlight->dev.kobj,
 					   &device->dev->dev.kobj, "device");
diff --git a/drivers/gpu/drm/nouveau/nouveau_backlight.c b/drivers/gpu/drm/nouveau/nouveau_backlight.c
index 20564f8..406228f 100644
--- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
+++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
@@ -89,19 +89,21 @@ static struct backlight_ops nv50_bl_ops = {
 
 static int nouveau_nv40_backlight_init(struct drm_device *dev)
 {
+	struct backlight_properties props;
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
 	struct backlight_device *bd;
 
 	if (!(nv_rd32(dev, NV40_PMC_BACKLIGHT) & NV40_PMC_BACKLIGHT_MASK))
 		return 0;
 
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = 31;
 	bd = backlight_device_register("nv_backlight", &dev->pdev->dev, dev,
-				       &nv40_bl_ops);
+				       &nv40_bl_ops, &props);
 	if (IS_ERR(bd))
 		return PTR_ERR(bd);
 
 	dev_priv->backlight = bd;
-	bd->props.max_brightness = 31;
 	bd->props.brightness = nv40_get_intensity(bd);
 	backlight_update_status(bd);
 
@@ -110,19 +112,21 @@ static int nouveau_nv40_backlight_init(struct drm_device *dev)
 
 static int nouveau_nv50_backlight_init(struct drm_device *dev)
 {
+	struct backlight_properties props;
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
 	struct backlight_device *bd;
 
 	if (!nv_rd32(dev, NV50_PDISPLAY_SOR_BACKLIGHT))
 		return 0;
 
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = 1025;
 	bd = backlight_device_register("nv_backlight", &dev->pdev->dev, dev,
-				       &nv50_bl_ops);
+				       &nv50_bl_ops, &props);
 	if (IS_ERR(bd))
 		return PTR_ERR(bd);
 
 	dev_priv->backlight = bd;
-	bd->props.max_brightness = 1025;
 	bd->props.brightness = nv50_get_intensity(bd);
 	backlight_update_status(bd);
 	return 0;
diff --git a/drivers/macintosh/via-pmu-backlight.c b/drivers/macintosh/via-pmu-backlight.c
index a348bb0..c48cf8a 100644
--- a/drivers/macintosh/via-pmu-backlight.c
+++ b/drivers/macintosh/via-pmu-backlight.c
@@ -144,6 +144,7 @@ void pmu_backlight_set_sleep(int sleep)
 
 void __init pmu_backlight_init()
 {
+	struct backlight_properties props;
 	struct backlight_device *bd;
 	char name[10];
 	int level, autosave;
@@ -161,13 +162,15 @@ void __init pmu_backlight_init()
 
 	snprintf(name, sizeof(name), "pmubl");
 
-	bd = backlight_device_register(name, NULL, NULL, &pmu_backlight_data);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
+	bd = backlight_device_register(name, NULL, NULL, &pmu_backlight_data,
+				       &props);
 	if (IS_ERR(bd)) {
 		printk(KERN_ERR "PMU Backlight registration failed\n");
 		return;
 	}
 	uses_pmu_bl = 1;
-	bd->props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	pmu_backlight_init_curve(0x7F, 0x46, 0x0E);
 
 	level = bd->props.max_brightness;
diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 07d14df..4d9b490 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -922,9 +922,13 @@ static struct backlight_ops acer_bl_ops = {
 
 static int __devinit acer_backlight_init(struct device *dev)
 {
+	struct backlight_properties props;
 	struct backlight_device *bd;
 
-	bd = backlight_device_register("acer-wmi", dev, NULL, &acer_bl_ops);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = max_brightness;
+	bd = backlight_device_register("acer-wmi", dev, NULL, &acer_bl_ops,
+				       &props);
 	if (IS_ERR(bd)) {
 		printk(ACER_ERR "Could not register Acer backlight device\n");
 		acer_backlight_device = NULL;
@@ -935,7 +939,6 @@ static int __devinit acer_backlight_init(struct device *dev)
 
 	bd->props.power = FB_BLANK_UNBLANK;
 	bd->props.brightness = max_brightness;
-	bd->props.max_brightness = max_brightness;
 	backlight_update_status(bd);
 	return 0;
 }
diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 61a1c75..940bac5 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -1363,8 +1363,11 @@ static int asus_backlight_init(struct device *dev)
 	struct backlight_device *bd;
 
 	if (brightness_set_handle && lcd_switch_handle) {
-		bd = backlight_device_register(ASUS_HOTK_FILE, dev,
-					       NULL, &asusbl_ops);
+		struct backlight_properties props;
+		memset(&props, 0, sizeof(struct backlight_properties));
+		props.max_brightness = 15;
+		bd = backlight_device_register(ASUS_HOTK_FILE, dev, NULL,
+					       &asusbl_ops, &props);
 		if (IS_ERR(bd)) {
 			pr_err("Could not register asus backlight device\n");
 			asus_backlight_device = NULL;
@@ -1373,7 +1376,6 @@ static int asus_backlight_init(struct device *dev)
 
 		asus_backlight_device = bd;
 
-		bd->props.max_brightness = 15;
 		bd->props.brightness = read_brightness(NULL);
 		bd->props.power = FB_BLANK_UNBLANK;
 		backlight_update_status(bd);
diff --git a/drivers/platform/x86/asus_acpi.c b/drivers/platform/x86/asus_acpi.c
index c1d2aee..34e9cc7 100644
--- a/drivers/platform/x86/asus_acpi.c
+++ b/drivers/platform/x86/asus_acpi.c
@@ -1482,6 +1482,7 @@ static void asus_acpi_exit(void)
 
 static int __init asus_acpi_init(void)
 {
+	struct backlight_properties props;
 	int result;
 
 	result = acpi_bus_register_driver(&asus_hotk_driver);
@@ -1508,15 +1509,17 @@ static int __init asus_acpi_init(void)
 		return -ENODEV;
 	}
 
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = 15;
 	asus_backlight_device = backlight_device_register("asus", NULL, NULL,
-							  &asus_backlight_data);
+							  &asus_backlight_data,
+							  &props);
 	if (IS_ERR(asus_backlight_device)) {
 		printk(KERN_ERR "Could not register asus backlight device\n");
 		asus_backlight_device = NULL;
 		asus_acpi_exit();
 		return -ENODEV;
 	}
-	asus_backlight_device->props.max_brightness = 15;
 
 	return 0;
 }
diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x86/classmate-laptop.c
index ed90082..f00635b 100644
--- a/drivers/platform/x86/classmate-laptop.c
+++ b/drivers/platform/x86/classmate-laptop.c
@@ -459,11 +459,13 @@ static struct backlight_ops cmpc_bl_ops = {
 
 static int cmpc_bl_add(struct acpi_device *acpi)
 {
+	struct backlight_properties props;
 	struct backlight_device *bd;
 
-	bd = backlight_device_register("cmpc_bl", &acpi->dev,
-				       acpi->handle, &cmpc_bl_ops);
-	bd->props.max_brightness = 7;
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = 7;
+	bd = backlight_device_register("cmpc_bl", &acpi->dev, acpi->handle,
+				       &cmpc_bl_ops, &props);
 	dev_set_drvdata(&acpi->dev, bd);
 	return 0;
 }
diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index 1a387e7..24110c5 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -326,12 +326,15 @@ static int __init compal_init(void)
 	/* Register backlight stuff */
 
 	if (!acpi_video_backlight_support()) {
-		compalbl_device = backlight_device_register("compal-laptop", NULL, NULL,
-							    &compalbl_ops);
+		struct backlight_properties props;
+		memset(&props, 0, sizeof(struct backlight_properties));
+		props.max_brightness = COMPAL_LCD_LEVEL_MAX - 1;
+		compalbl_device = backlight_device_register("compal-laptop",
+							    NULL, NULL,
+							    &compalbl_ops,
+							    &props);
 		if (IS_ERR(compalbl_device))
 			return PTR_ERR(compalbl_device);
-
-		compalbl_device->props.max_brightness = COMPAL_LCD_LEVEL_MAX-1;
 	}
 
 	ret = platform_driver_register(&compal_driver);
diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 3780994..f22c565 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -390,10 +390,14 @@ static int __init dell_init(void)
 	}
 
 	if (max_intensity) {
-		dell_backlight_device = backlight_device_register(
-			"dell_backlight",
-			&platform_device->dev, NULL,
-			&dell_ops);
+		struct backlight_properties props;
+		memset(&props, 0, sizeof(struct backlight_properties));
+		props.max_brightness = max_intensity;
+		dell_backlight_device = backlight_device_register("dell_backlight",
+								  &platform_device->dev,
+								  NULL,
+								  &dell_ops,
+								  &props);
 
 		if (IS_ERR(dell_backlight_device)) {
 			ret = PTR_ERR(dell_backlight_device);
@@ -401,7 +405,6 @@ static int __init dell_init(void)
 			goto fail_backlight;
 		}
 
-		dell_backlight_device->props.max_brightness = max_intensity;
 		dell_backlight_device->props.brightness =
 			dell_get_intensity(dell_backlight_device);
 		backlight_update_status(dell_backlight_device);
diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index e2be6bb..d5e5ed8 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -1113,18 +1113,20 @@ static int eeepc_backlight_notify(struct eeepc_laptop *eeepc)
 
 static int eeepc_backlight_init(struct eeepc_laptop *eeepc)
 {
+	struct backlight_properties props;
 	struct backlight_device *bd;
 
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = 15;
 	bd = backlight_device_register(EEEPC_LAPTOP_FILE,
-				       &eeepc->platform_device->dev,
-				       eeepc, &eeepcbl_ops);
+				       &eeepc->platform_device->dev, eeepc,
+				       &eeepcbl_ops, &props);
 	if (IS_ERR(bd)) {
 		pr_err("Could not register eeepc backlight device\n");
 		eeepc->backlight_device = NULL;
 		return PTR_ERR(bd);
 	}
 	eeepc->backlight_device = bd;
-	bd->props.max_brightness = 15;
 	bd->props.brightness = read_brightness(bd);
 	bd->props.power = FB_BLANK_UNBLANK;
 	backlight_update_status(bd);
diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index 5f3320d..c1074b3 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -1126,16 +1126,20 @@ static int __init fujitsu_init(void)
 	/* Register backlight stuff */
 
 	if (!acpi_video_backlight_support()) {
-		fujitsu->bl_device =
-			backlight_device_register("fujitsu-laptop", NULL, NULL,
-						  &fujitsubl_ops);
+		struct backlight_properties props;
+
+		memset(&props, 0, sizeof(struct backlight_properties));
+		max_brightness = fujitsu->max_brightness;
+		props.max_brightness = max_brightness - 1;
+		fujitsu->bl_device = backlight_device_register("fujitsu-laptop",
+							       NULL, NULL,
+							       &fujitsubl_ops,
+							       &props);
 		if (IS_ERR(fujitsu->bl_device)) {
 			ret = PTR_ERR(fujitsu->bl_device);
 			fujitsu->bl_device = NULL;
 			goto fail_sysfs_group;
 		}
-		max_brightness = fujitsu->max_brightness;
-		fujitsu->bl_device->props.max_brightness = max_brightness - 1;
 		fujitsu->bl_device->props.brightness = fujitsu->brightness_level;
 	}
 
diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index 759763d..cb4dc92 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -351,11 +351,14 @@ static int __init msi_init(void)
 		printk(KERN_INFO "MSI: Brightness ignored, must be controlled "
 		       "by ACPI video driver\n");
 	} else {
+		struct backlight_properties props;
+		memset(&props, 0, sizeof(struct backlight_properties));
+		props.max_brightness = MSI_LCD_LEVEL_MAX - 1;
 		msibl_device = backlight_device_register("msi-laptop-bl", NULL,
-							 NULL, &msibl_ops);
+							 NULL, &msibl_ops,
+							 &props);
 		if (IS_ERR(msibl_device))
 			return PTR_ERR(msibl_device);
-		msibl_device->props.max_brightness = MSI_LCD_LEVEL_MAX-1;
 	}
 
 	ret = platform_driver_register(&msipf_driver);
diff --git a/drivers/platform/x86/msi-wmi.c b/drivers/platform/x86/msi-wmi.c
index f5f70d4..fb7ccaa 100644
--- a/drivers/platform/x86/msi-wmi.c
+++ b/drivers/platform/x86/msi-wmi.c
@@ -249,12 +249,15 @@ static int __init msi_wmi_init(void)
 		goto err_uninstall_notifier;
 
 	if (!acpi_video_backlight_support()) {
-		backlight = backlight_device_register(DRV_NAME,
-				NULL, NULL, &msi_backlight_ops);
+		struct backlight_properties props;
+		memset(&props, 0, sizeof(struct backlight_properties));
+		props.max_brightness = ARRAY_SIZE(backlight_map) - 1;
+		backlight = backlight_device_register(DRV_NAME, NULL, NULL,
+						      &msi_backlight_ops,
+						      &props);
 		if (IS_ERR(backlight))
 			goto err_free_input;
 
-		backlight->props.max_brightness = ARRAY_SIZE(backlight_map) - 1;
 		err = bl_get(NULL);
 		if (err < 0)
 			goto err_free_backlight;
diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index fe7cf01..c6efddd 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -601,6 +601,7 @@ static int acpi_pcc_hotkey_resume(struct acpi_device *device)
 
 static int acpi_pcc_hotkey_add(struct acpi_device *device)
 {
+	struct backlight_properties props;
 	struct pcc_acpi *pcc;
 	int num_sifr, result;
 
@@ -638,24 +639,23 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 	if (result) {
 		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
 				  "Error installing keyinput handler\n"));
-		goto out_sinf;
+		goto out_hotkey;
 	}
 
-	/* initialize backlight */
-	pcc->backlight = backlight_device_register("panasonic", NULL, pcc,
-						   &pcc_backlight_ops);
-	if (IS_ERR(pcc->backlight))
-		goto out_input;
-
 	if (!acpi_pcc_retrieve_biosdata(pcc, pcc->sinf)) {
 		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
 				 "Couldn't retrieve BIOS data\n"));
-		goto out_backlight;
+		goto out_input;
 	}
+	/* initialize backlight */
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = pcc->sinf[SINF_AC_MAX_BRIGHT];
+	pcc->backlight = backlight_device_register("panasonic", NULL, pcc,
+						   &pcc_backlight_ops, &props);
+	if (IS_ERR(pcc->backlight))
+		goto out_sinf;
 
 	/* read the initial brightness setting from the hardware */
-	pcc->backlight->props.max_brightness =
-					pcc->sinf[SINF_AC_MAX_BRIGHT];
 	pcc->backlight->props.brightness = pcc->sinf[SINF_AC_CUR_BRIGHT];
 
 	/* read the initial sticky key mode from the hardware */
@@ -670,12 +670,12 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 
 out_backlight:
 	backlight_device_unregister(pcc->backlight);
+out_sinf:
+	kfree(pcc->sinf);
 out_input:
 	input_unregister_device(pcc->input_dev);
 	/* no need to input_free_device() since core input API refcount and
 	 * free()s the device */
-out_sinf:
-	kfree(pcc->sinf);
 out_hotkey:
 	kfree(pcc);
 
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index 3f71a60..87fc12d 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -1288,9 +1288,13 @@ static int sony_nc_add(struct acpi_device *device)
 		       "controlled by ACPI video driver\n");
 	} else if (ACPI_SUCCESS(acpi_get_handle(sony_nc_acpi_handle, "GBRT",
 						&handle))) {
+							struct backlight_properties props;
+		memset(&props, 0, sizeof(struct backlight_properties));
+		props.max_brightness = SONY_MAX_BRIGHTNESS - 1;
 		sony_backlight_device = backlight_device_register("sony", NULL,
 								  NULL,
-								  &sony_backlight_ops);
+								  &sony_backlight_ops,
+								  &props);
 
 		if (IS_ERR(sony_backlight_device)) {
 			printk(KERN_WARNING DRV_PFX "unable to register backlight device\n");
@@ -1299,8 +1303,6 @@ static int sony_nc_add(struct acpi_device *device)
 			sony_backlight_device->props.brightness =
 			    sony_backlight_get_brightness
 			    (sony_backlight_device);
-			sony_backlight_device->props.max_brightness =
-			    SONY_MAX_BRIGHTNESS - 1;
 		}
 
 	}
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index e67e4fe..9466de0 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6151,6 +6151,7 @@ static const struct tpacpi_quirk brightness_quirk_table[] __initconst = {
 
 static int __init brightness_init(struct ibm_init_struct *iibm)
 {
+	struct backlight_properties props;
 	int b;
 	unsigned long quirks;
 
@@ -6240,9 +6241,12 @@ static int __init brightness_init(struct ibm_init_struct *iibm)
 		printk(TPACPI_INFO
 		       "detected a 16-level brightness capable ThinkPad\n");
 
-	ibm_backlight_device = backlight_device_register(
-					TPACPI_BACKLIGHT_DEV_NAME, NULL, NULL,
-					&ibm_backlight_data);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = (tp_features.bright_16levels) ? 15 : 7;
+	ibm_backlight_device = backlight_device_register(TPACPI_BACKLIGHT_DEV_NAME,
+							 NULL, NULL,
+							 &ibm_backlight_data,
+							 &props);
 	if (IS_ERR(ibm_backlight_device)) {
 		int rc = PTR_ERR(ibm_backlight_device);
 		ibm_backlight_device = NULL;
@@ -6261,8 +6265,6 @@ static int __init brightness_init(struct ibm_init_struct *iibm)
 			"or not on your ThinkPad\n", TPACPI_MAIL);
 	}
 
-	ibm_backlight_device->props.max_brightness =
-				(tp_features.bright_16levels)? 15 : 7;
 	ibm_backlight_device->props.brightness = b & TP_EC_BACKLIGHT_LVLMSK;
 	backlight_update_status(ibm_backlight_device);
 
diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 77bf5d8..800bd4f 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -737,6 +737,7 @@ static int __init toshiba_acpi_init(void)
 	u32 hci_result;
 	bool bt_present;
 	int ret = 0;
+	struct backlight_properties props;
 
 	if (acpi_disabled)
 		return -ENODEV;
@@ -783,10 +784,12 @@ static int __init toshiba_acpi_init(void)
 		}
 	}
 
+	props.max_brightness = HCI_LCD_BRIGHTNESS_LEVELS - 1;
 	toshiba_backlight_device = backlight_device_register("toshiba",
-						&toshiba_acpi.p_dev->dev,
-						NULL,
-						&toshiba_backlight_data);
+							     &toshiba_acpi.p_dev->dev,
+							     NULL,
+							     &toshiba_backlight_data,
+							     &props);
         if (IS_ERR(toshiba_backlight_device)) {
 		ret = PTR_ERR(toshiba_backlight_device);
 
@@ -795,7 +798,6 @@ static int __init toshiba_acpi_init(void)
 		toshiba_acpi_exit();
 		return ret;
 	}
-        toshiba_backlight_device->props.max_brightness = HCI_LCD_BRIGHTNESS_LEVELS - 1;
 
 	/* Register rfkill switch for Bluetooth */
 	if (hci_get_bt_present(&bt_present) == HCI_SUCCESS && bt_present) {
diff --git a/drivers/staging/samsung-laptop/samsung-laptop.c b/drivers/staging/samsung-laptop/samsung-laptop.c
index 4877138..7490ad1 100644
--- a/drivers/staging/samsung-laptop/samsung-laptop.c
+++ b/drivers/staging/samsung-laptop/samsung-laptop.c
@@ -391,6 +391,7 @@ MODULE_DEVICE_TABLE(dmi, samsung_dmi_table);
 
 static int __init samsung_init(void)
 {
+	struct backlight_properties props;
 	struct sabi_retval sretval;
 	const char *testStr = "SECLINUX";
 	void __iomem *memcheck;
@@ -483,12 +484,14 @@ static int __init samsung_init(void)
 		goto error_no_platform;
 
 	/* create a backlight device to talk to this one */
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = MAX_BRIGHT;
 	backlight_device = backlight_device_register("samsung", &sdev->dev,
-						     NULL, &backlight_ops);
+						     NULL, &backlight_ops,
+						     &props);
 	if (IS_ERR(backlight_device))
 		goto error_no_backlight;
 
-	backlight_device->props.max_brightness = MAX_BRIGHT;
 	backlight_device->props.brightness = read_brightness();
 	backlight_device->props.power = FB_BLANK_UNBLANK;
 	backlight_update_status(backlight_device);
diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
index 1eb9e41..97aaac3 100644
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -202,6 +202,7 @@ static void appledisplay_work(struct work_struct *work)
 static int appledisplay_probe(struct usb_interface *iface,
 	const struct usb_device_id *id)
 {
+	struct backlight_properties props;
 	struct appledisplay *pdata;
 	struct usb_device *udev = interface_to_usbdev(iface);
 	struct usb_host_interface *iface_desc;
@@ -279,15 +280,15 @@ static int appledisplay_probe(struct usb_interface *iface,
 	/* Register backlight device */
 	snprintf(bl_name, sizeof(bl_name), "appledisplay%d",
 		atomic_inc_return(&count_displays) - 1);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = 0xff;
 	pdata->bd = backlight_device_register(bl_name, NULL, pdata,
-						&appledisplay_bl_data);
+					      &appledisplay_bl_data, &props);
 	if (IS_ERR(pdata->bd)) {
 		dev_err(&iface->dev, "Backlight registration failed\n");
 		goto error;
 	}
 
-	pdata->bd->props.max_brightness = 0xff;
-
 	/* Try to get brightness */
 	brightness = appledisplay_bl_get_brightness(pdata->bd);
 
diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 3d886c6..11de3bf 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -117,6 +117,7 @@ static struct backlight_ops atmel_lcdc_bl_ops = {
 
 static void init_backlight(struct atmel_lcdfb_info *sinfo)
 {
+	struct backlight_properties props;
 	struct backlight_device	*bl;
 
 	sinfo->bl_power = FB_BLANK_UNBLANK;
@@ -124,8 +125,10 @@ static void init_backlight(struct atmel_lcdfb_info *sinfo)
 	if (sinfo->backlight)
 		return;
 
-	bl = backlight_device_register("backlight", &sinfo->pdev->dev,
-			sinfo, &atmel_lcdc_bl_ops);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = 0xff;
+	bl = backlight_device_register("backlight", &sinfo->pdev->dev, sinfo,
+				       &atmel_lcdc_bl_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&sinfo->pdev->dev, "error %ld on backlight register\n",
 				PTR_ERR(bl));
@@ -135,7 +138,6 @@ static void init_backlight(struct atmel_lcdfb_info *sinfo)
 
 	bl->props.power = FB_BLANK_UNBLANK;
 	bl->props.fb_blank = FB_BLANK_UNBLANK;
-	bl->props.max_brightness = 0xff;
 	bl->props.brightness = atmel_bl_get_brightness(bl);
 }
 
diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index e4e4d43..7694999 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -1802,6 +1802,7 @@ static void aty128_bl_set_power(struct fb_info *info, int power)
 
 static void aty128_bl_init(struct aty128fb_par *par)
 {
+	struct backlight_properties props;
 	struct fb_info *info = pci_get_drvdata(par->pdev);
 	struct backlight_device *bd;
 	char name[12];
@@ -1817,7 +1818,10 @@ static void aty128_bl_init(struct aty128fb_par *par)
 
 	snprintf(name, sizeof(name), "aty128bl%d", info->node);
 
-	bd = backlight_device_register(name, info->dev, par, &aty128_bl_data);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
+	bd = backlight_device_register(name, info->dev, par, &aty128_bl_data,
+				       &props);
 	if (IS_ERR(bd)) {
 		info->bl_dev = NULL;
 		printk(KERN_WARNING "aty128: Backlight registration failed\n");
@@ -1829,7 +1833,6 @@ static void aty128_bl_init(struct aty128fb_par *par)
 		 63 * FB_BACKLIGHT_MAX / MAX_LEVEL,
 		219 * FB_BACKLIGHT_MAX / MAX_LEVEL);
 
-	bd->props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd->props.brightness = bd->props.max_brightness;
 	bd->props.power = FB_BLANK_UNBLANK;
 	backlight_update_status(bd);
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index 1ddeb4c..3d7cd1e 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -2232,6 +2232,7 @@ static struct backlight_ops aty_bl_data = {
 
 static void aty_bl_init(struct atyfb_par *par)
 {
+	struct backlight_properties props;
 	struct fb_info *info = pci_get_drvdata(par->pdev);
 	struct backlight_device *bd;
 	char name[12];
@@ -2243,7 +2244,10 @@ static void aty_bl_init(struct atyfb_par *par)
 
 	snprintf(name, sizeof(name), "atybl%d", info->node);
 
-	bd = backlight_device_register(name, info->dev, par, &aty_bl_data);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
+	bd = backlight_device_register(name, info->dev, par, &aty_bl_data,
+				       &props);
 	if (IS_ERR(bd)) {
 		info->bl_dev = NULL;
 		printk(KERN_WARNING "aty: Backlight registration failed\n");
@@ -2255,7 +2259,6 @@ static void aty_bl_init(struct atyfb_par *par)
 			    0x3F * FB_BACKLIGHT_MAX / MAX_LEVEL,
 			    0xFF * FB_BACKLIGHT_MAX / MAX_LEVEL);
 
-	bd->props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd->props.brightness = bd->props.max_brightness;
 	bd->props.power = FB_BLANK_UNBLANK;
 	backlight_update_status(bd);
diff --git a/drivers/video/aty/radeon_backlight.c b/drivers/video/aty/radeon_backlight.c
index 1a056ad..94e94d8 100644
--- a/drivers/video/aty/radeon_backlight.c
+++ b/drivers/video/aty/radeon_backlight.c
@@ -134,6 +134,7 @@ static struct backlight_ops radeon_bl_data = {
 
 void radeonfb_bl_init(struct radeonfb_info *rinfo)
 {
+	struct backlight_properties props;
 	struct backlight_device *bd;
 	struct radeon_bl_privdata *pdata;
 	char name[12];
@@ -155,7 +156,10 @@ void radeonfb_bl_init(struct radeonfb_info *rinfo)
 
 	snprintf(name, sizeof(name), "radeonbl%d", rinfo->info->node);
 
-	bd = backlight_device_register(name, rinfo->info->dev, pdata, &radeon_bl_data);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
+	bd = backlight_device_register(name, rinfo->info->dev, pdata,
+				       &radeon_bl_data, &props);
 	if (IS_ERR(bd)) {
 		rinfo->info->bl_dev = NULL;
 		printk("radeonfb: Backlight registration failed\n");
@@ -185,7 +189,6 @@ void radeonfb_bl_init(struct radeonfb_info *rinfo)
 		 63 * FB_BACKLIGHT_MAX / MAX_RADEON_LEVEL,
 		217 * FB_BACKLIGHT_MAX / MAX_RADEON_LEVEL);
 
-	bd->props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd->props.brightness = bd->props.max_brightness;
 	bd->props.power = FB_BLANK_UNBLANK;
 	backlight_update_status(bd);
diff --git a/drivers/video/backlight/adp5520_bl.c b/drivers/video/backlight/adp5520_bl.c
index 86d95c2..5183f0e 100644
--- a/drivers/video/backlight/adp5520_bl.c
+++ b/drivers/video/backlight/adp5520_bl.c
@@ -278,6 +278,7 @@ static const struct attribute_group adp5520_bl_attr_group = {
 
 static int __devinit adp5520_bl_probe(struct platform_device *pdev)
 {
+	struct backlight_properties props;
 	struct backlight_device *bl;
 	struct adp5520_bl *data;
 	int ret = 0;
@@ -300,17 +301,17 @@ static int __devinit adp5520_bl_probe(struct platform_device *pdev)
 
 	mutex_init(&data->lock);
 
-	bl = backlight_device_register(pdev->name, data->master,
-			data, &adp5520_bl_ops);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = ADP5020_MAX_BRIGHTNESS;
+	bl = backlight_device_register(pdev->name, data->master, data,
+				       &adp5520_bl_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
 		kfree(data);
 		return PTR_ERR(bl);
 	}
 
-	bl->props.max_brightness =
-		bl->props.brightness = ADP5020_MAX_BRIGHTNESS;
-
+	bl->props.brightness = ADP5020_MAX_BRIGHTNESS;
 	if (data->pdata->en_ambl_sens)
 		ret = sysfs_create_group(&bl->dev.kobj,
 			&adp5520_bl_attr_group);
diff --git a/drivers/video/backlight/adx_bl.c b/drivers/video/backlight/adx_bl.c
index d769b0b..5048fc5 100644
--- a/drivers/video/backlight/adx_bl.c
+++ b/drivers/video/backlight/adx_bl.c
@@ -70,6 +70,7 @@ static const struct backlight_ops adx_backlight_ops = {
 
 static int __devinit adx_backlight_probe(struct platform_device *pdev)
 {
+	struct backlight_properties props;
 	struct backlight_device *bldev;
 	struct resource *res;
 	struct adxbl *bl;
@@ -101,14 +102,15 @@ static int __devinit adx_backlight_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	bldev = backlight_device_register(dev_name(&pdev->dev), &pdev->dev, bl,
-			&adx_backlight_ops);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = 0xff;
+	bldev = backlight_device_register(dev_name(&pdev->dev), &pdev->dev,
+					  bl, &adx_backlight_ops, &props);
 	if (!bldev) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	bldev->props.max_brightness = 0xff;
 	bldev->props.brightness = 0xff;
 	bldev->props.power = FB_BLANK_UNBLANK;
 
diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index f625ffc..2d97605 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -120,6 +120,7 @@ static const struct backlight_ops atmel_pwm_bl_ops = {
 
 static int atmel_pwm_bl_probe(struct platform_device *pdev)
 {
+	struct backlight_properties props;
 	const struct atmel_pwm_bl_platform_data *pdata;
 	struct backlight_device *bldev;
 	struct atmel_pwm_bl *pwmbl;
@@ -165,8 +166,10 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
 			goto err_free_gpio;
 	}
 
-	bldev = backlight_device_register("atmel-pwm-bl",
-			&pdev->dev, pwmbl, &atmel_pwm_bl_ops);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = pdata->pwm_duty_max - pdata->pwm_duty_min;
+	bldev = backlight_device_register("atmel-pwm-bl", &pdev->dev, pwmbl,
+					  &atmel_pwm_bl_ops, &props);
 	if (IS_ERR(bldev)) {
 		retval = PTR_ERR(bldev);
 		goto err_free_gpio;
@@ -178,7 +181,6 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
 
 	/* Power up the backlight by default at middle intesity. */
 	bldev->props.power = FB_BLANK_UNBLANK;
-	bldev->props.max_brightness = pdata->pwm_duty_max - pdata->pwm_duty_min;
 	bldev->props.brightness = bldev->props.max_brightness / 2;
 
 	retval = atmel_pwm_bl_init_pwm(pwmbl);
diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 18829cf..99ab972 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -269,7 +269,8 @@ EXPORT_SYMBOL(backlight_force_update);
  * ERR_PTR() or a pointer to the newly allocated device.
  */
 struct backlight_device *backlight_device_register(const char *name,
-		struct device *parent, void *devdata, const struct backlight_ops *ops)
+	struct device *parent, void *devdata, const struct backlight_ops *ops,
+	const struct backlight_properties *props)
 {
 	struct backlight_device *new_bd;
 	int rc;
@@ -289,6 +290,11 @@ struct backlight_device *backlight_device_register(const char *name,
 	dev_set_name(&new_bd->dev, name);
 	dev_set_drvdata(&new_bd->dev, devdata);
 
+	/* Set default properties */
+	if (props)
+		memcpy(&new_bd->props, props,
+		       sizeof(struct backlight_properties));
+
 	rc = device_register(&new_bd->dev);
 	if (rc) {
 		kfree(new_bd);
diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index b4bcf80..73bdd84 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -533,6 +533,7 @@ err_free_backlight_on:
 
 static int __devinit corgi_lcd_probe(struct spi_device *spi)
 {
+	struct backlight_properties props;
 	struct corgi_lcd_platform_data *pdata = spi->dev.platform_data;
 	struct corgi_lcd *lcd;
 	int ret = 0;
@@ -559,13 +560,14 @@ static int __devinit corgi_lcd_probe(struct spi_device *spi)
 	lcd->power = FB_BLANK_POWERDOWN;
 	lcd->mode = (pdata) ? pdata->init_mode : CORGI_LCD_MODE_VGA;
 
-	lcd->bl_dev = backlight_device_register("corgi_bl", &spi->dev,
-					lcd, &corgi_bl_ops);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = pdata->max_intensity;
+	lcd->bl_dev = backlight_device_register("corgi_bl", &spi->dev, lcd,
+						&corgi_bl_ops, &props);
 	if (IS_ERR(lcd->bl_dev)) {
 		ret = PTR_ERR(lcd->bl_dev);
 		goto err_unregister_lcd;
 	}
-	lcd->bl_dev->props.max_brightness = pdata->max_intensity;
 	lcd->bl_dev->props.brightness = pdata->default_intensity;
 	lcd->bl_dev->props.power = FB_BLANK_UNBLANK;
 
diff --git a/drivers/video/backlight/cr_bllcd.c b/drivers/video/backlight/cr_bllcd.c
index da86db4..1cce603 100644
--- a/drivers/video/backlight/cr_bllcd.c
+++ b/drivers/video/backlight/cr_bllcd.c
@@ -170,6 +170,7 @@ static struct lcd_ops cr_lcd_ops = {
 
 static int cr_backlight_probe(struct platform_device *pdev)
 {
+	struct backlight_properties props;
 	struct backlight_device *bdp;
 	struct lcd_device *ldp;
 	struct cr_panel *crp;
@@ -190,8 +191,9 @@ static int cr_backlight_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	bdp = backlight_device_register("cr-backlight",
-					&pdev->dev, NULL, &cr_backlight_ops);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	bdp = backlight_device_register("cr-backlight", &pdev->dev, NULL,
+					&cr_backlight_ops, &props);
 	if (IS_ERR(bdp)) {
 		pci_dev_put(lpc_dev);
 		return PTR_ERR(bdp);
@@ -220,9 +222,7 @@ static int cr_backlight_probe(struct platform_device *pdev)
 	crp->cr_lcd_device = ldp;
 	crp->cr_backlight_device->props.power = FB_BLANK_UNBLANK;
 	crp->cr_backlight_device->props.brightness = 0;
-	crp->cr_backlight_device->props.max_brightness = 0;
 	cr_backlight_set_intensity(crp->cr_backlight_device);
-
 	cr_lcd_set_power(crp->cr_lcd_device, FB_BLANK_UNBLANK);
 
 	platform_set_drvdata(pdev, crp);
diff --git a/drivers/video/backlight/da903x_bl.c b/drivers/video/backlight/da903x_bl.c
index 74cdc64..686e4a7 100644
--- a/drivers/video/backlight/da903x_bl.c
+++ b/drivers/video/backlight/da903x_bl.c
@@ -105,6 +105,7 @@ static int da903x_backlight_probe(struct platform_device *pdev)
 	struct da9034_backlight_pdata *pdata = pdev->dev.platform_data;
 	struct da903x_backlight_data *data;
 	struct backlight_device *bl;
+	struct backlight_properties props;
 	int max_brightness;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
@@ -134,15 +135,15 @@ static int da903x_backlight_probe(struct platform_device *pdev)
 		da903x_write(data->da903x_dev, DA9034_WLED_CONTROL2,
 				DA9034_WLED_ISET(pdata->output_current));
 
-	bl = backlight_device_register(pdev->name, data->da903x_dev,
-			data, &da903x_backlight_ops);
+	props.max_brightness = max_brightness;
+	bl = backlight_device_register(pdev->name, data->da903x_dev, data,
+				       &da903x_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
 		kfree(data);
 		return PTR_ERR(bl);
 	}
 
-	bl->props.max_brightness = max_brightness;
 	bl->props.brightness = max_brightness;
 
 	platform_set_drvdata(pdev, bl);
diff --git a/drivers/video/backlight/generic_bl.c b/drivers/video/backlight/generic_bl.c
index e6d348e..312ca61 100644
--- a/drivers/video/backlight/generic_bl.c
+++ b/drivers/video/backlight/generic_bl.c
@@ -78,6 +78,7 @@ static const struct backlight_ops genericbl_ops = {
 
 static int genericbl_probe(struct platform_device *pdev)
 {
+	struct backlight_properties props;
 	struct generic_bl_info *machinfo = pdev->dev.platform_data;
 	const char *name = "generic-bl";
 	struct backlight_device *bd;
@@ -89,14 +90,15 @@ static int genericbl_probe(struct platform_device *pdev)
 	if (machinfo->name)
 		name = machinfo->name;
 
-	bd = backlight_device_register (name,
-		&pdev->dev, NULL, &genericbl_ops);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = machinfo->max_intensity;
+	bd = backlight_device_register(name, &pdev->dev, NULL, &genericbl_ops,
+				       &props);
 	if (IS_ERR (bd))
 		return PTR_ERR (bd);
 
 	platform_set_drvdata(pdev, bd);
 
-	bd->props.max_brightness = machinfo->max_intensity;
 	bd->props.power = FB_BLANK_UNBLANK;
 	bd->props.brightness = machinfo->default_intensity;
 	backlight_update_status(bd);
diff --git a/drivers/video/backlight/hp680_bl.c b/drivers/video/backlight/hp680_bl.c
index f7cc528..267d23f 100644
--- a/drivers/video/backlight/hp680_bl.c
+++ b/drivers/video/backlight/hp680_bl.c
@@ -105,16 +105,18 @@ static const struct backlight_ops hp680bl_ops = {
 
 static int __devinit hp680bl_probe(struct platform_device *pdev)
 {
+	struct backlight_properties props;
 	struct backlight_device *bd;
 
-	bd = backlight_device_register ("hp680-bl", &pdev->dev, NULL,
-		    &hp680bl_ops);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = HP680_MAX_INTENSITY;
+	bd = backlight_device_register("hp680-bl", &pdev->dev, NULL,
+				       &hp680bl_ops, &props);
 	if (IS_ERR(bd))
 		return PTR_ERR(bd);
 
 	platform_set_drvdata(pdev, bd);
 
-	bd->props.max_brightness = HP680_MAX_INTENSITY;
 	bd->props.brightness = HP680_DEFAULT_INTENSITY;
 	hp680bl_send_intensity(bd);
 
diff --git a/drivers/video/backlight/jornada720_bl.c b/drivers/video/backlight/jornada720_bl.c
index db9071f..2f177b3 100644
--- a/drivers/video/backlight/jornada720_bl.c
+++ b/drivers/video/backlight/jornada720_bl.c
@@ -101,10 +101,14 @@ static const struct backlight_ops jornada_bl_ops = {
 
 static int jornada_bl_probe(struct platform_device *pdev)
 {
+	struct backlight_properties props;
 	int ret;
 	struct backlight_device *bd;
 
-	bd = backlight_device_register(S1D_DEVICENAME, &pdev->dev, NULL, &jornada_bl_ops);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = BL_MAX_BRIGHT;
+	bd = backlight_device_register(S1D_DEVICENAME, &pdev->dev, NULL,
+				       &jornada_bl_ops, &props);
 
 	if (IS_ERR(bd)) {
 		ret = PTR_ERR(bd);
@@ -117,7 +121,6 @@ static int jornada_bl_probe(struct platform_device *pdev)
 	/* note. make sure max brightness is set otherwise
 	   you will get seemingly non-related errors when
 	   trying to change brightness */
-	bd->props.max_brightness = BL_MAX_BRIGHT;
 	jornada_bl_update_status(bd);
 
 	platform_set_drvdata(pdev, bd);
diff --git a/drivers/video/backlight/kb3886_bl.c b/drivers/video/backlight/kb3886_bl.c
index 939e7b8..f439a86 100644
--- a/drivers/video/backlight/kb3886_bl.c
+++ b/drivers/video/backlight/kb3886_bl.c
@@ -141,20 +141,24 @@ static const struct backlight_ops kb3886bl_ops = {
 
 static int kb3886bl_probe(struct platform_device *pdev)
 {
+	struct backlight_properties props;
 	struct kb3886bl_machinfo *machinfo = pdev->dev.platform_data;
 
 	bl_machinfo = machinfo;
 	if (!machinfo->limit_mask)
 		machinfo->limit_mask = -1;
 
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = machinfo->max_intensity;
 	kb3886_backlight_device = backlight_device_register("kb3886-bl",
-		&pdev->dev, NULL, &kb3886bl_ops);
+							    &pdev->dev, NULL,
+							    &kb3886bl_ops,
+							    &props);
 	if (IS_ERR(kb3886_backlight_device))
 		return PTR_ERR(kb3886_backlight_device);
 
 	platform_set_drvdata(pdev, kb3886_backlight_device);
 
-	kb3886_backlight_device->props.max_brightness = machinfo->max_intensity;
 	kb3886_backlight_device->props.power = FB_BLANK_UNBLANK;
 	kb3886_backlight_device->props.brightness = machinfo->default_intensity;
 	backlight_update_status(kb3886_backlight_device);
diff --git a/drivers/video/backlight/locomolcd.c b/drivers/video/backlight/locomolcd.c
index 00a9591..7571bc2 100644
--- a/drivers/video/backlight/locomolcd.c
+++ b/drivers/video/backlight/locomolcd.c
@@ -167,6 +167,7 @@ static int locomolcd_resume(struct locomo_dev *dev)
 
 static int locomolcd_probe(struct locomo_dev *ldev)
 {
+	struct backlight_properties props;
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -182,13 +183,16 @@ static int locomolcd_probe(struct locomo_dev *ldev)
 
 	local_irq_restore(flags);
 
-	locomolcd_bl_device = backlight_device_register("locomo-bl", &ldev->dev, NULL, &locomobl_data);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = 4;
+	locomolcd_bl_device = backlight_device_register("locomo-bl",
+							&ldev->dev, NULL,
+							&locomobl_data, &props);
 
 	if (IS_ERR (locomolcd_bl_device))
 		return PTR_ERR (locomolcd_bl_device);
 
 	/* Set up frontlight so that screen is readable */
-	locomolcd_bl_device->props.max_brightness = 4,
 	locomolcd_bl_device->props.brightness = 2;
 	locomolcd_set_intensity(locomolcd_bl_device);
 
diff --git a/drivers/video/backlight/mbp_nvidia_bl.c b/drivers/video/backlight/mbp_nvidia_bl.c
index 2e78b07..0881358 100644
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -250,6 +250,7 @@ static const struct dmi_system_id __initdata mbp_device_table[] = {
 
 static int __init mbp_init(void)
 {
+	struct backlight_properties props;
 	if (!dmi_check_system(mbp_device_table))
 		return -ENODEV;
 
@@ -257,14 +258,17 @@ static int __init mbp_init(void)
 						"Macbook Pro backlight"))
 		return -ENXIO;
 
-	mbp_backlight_device = backlight_device_register("mbp_backlight",
-					NULL, NULL, &driver_data->backlight_ops);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = 15;
+	mbp_backlight_device = backlight_device_register("mbp_backlight", NULL,
+							 NULL,
+							 &driver_data->backlight_ops,
+							 &props);
 	if (IS_ERR(mbp_backlight_device)) {
 		release_region(driver_data->iostart, driver_data->iolen);
 		return PTR_ERR(mbp_backlight_device);
 	}
 
-	mbp_backlight_device->props.max_brightness = 15;
 	mbp_backlight_device->props.brightness =
 		driver_data->backlight_ops.get_brightness(mbp_backlight_device);
 	backlight_update_status(mbp_backlight_device);
diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index a3a7f89..333d28e 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -132,6 +132,7 @@ static const struct backlight_ops omapbl_ops = {
 
 static int omapbl_probe(struct platform_device *pdev)
 {
+	struct backlight_properties props;
 	struct backlight_device *dev;
 	struct omap_backlight *bl;
 	struct omap_backlight_config *pdata = pdev->dev.platform_data;
@@ -143,7 +144,10 @@ static int omapbl_probe(struct platform_device *pdev)
 	if (unlikely(!bl))
 		return -ENOMEM;
 
-	dev = backlight_device_register("omap-bl", &pdev->dev, bl, &omapbl_ops);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = OMAPBL_MAX_INTENSITY;
+	dev = backlight_device_register("omap-bl", &pdev->dev, bl, &omapbl_ops,
+					&props);
 	if (IS_ERR(dev)) {
 		kfree(bl);
 		return PTR_ERR(dev);
@@ -160,7 +164,6 @@ static int omapbl_probe(struct platform_device *pdev)
 	omap_cfg_reg(PWL);	/* Conflicts with UART3 */
 
 	dev->props.fb_blank = FB_BLANK_UNBLANK;
-	dev->props.max_brightness = OMAPBL_MAX_INTENSITY;
 	dev->props.brightness = pdata->default_intensity;
 	omapbl_update_status(dev);
 
diff --git a/drivers/video/backlight/progear_bl.c b/drivers/video/backlight/progear_bl.c
index 2ec16de..809278c 100644
--- a/drivers/video/backlight/progear_bl.c
+++ b/drivers/video/backlight/progear_bl.c
@@ -61,6 +61,7 @@ static const struct backlight_ops progearbl_ops = {
 
 static int progearbl_probe(struct platform_device *pdev)
 {
+	struct backlight_properties props;
 	u8 temp;
 	struct backlight_device *progear_backlight_device;
 	int ret;
@@ -82,9 +83,12 @@ static int progearbl_probe(struct platform_device *pdev)
 	pci_read_config_byte(sb_dev, SB_MPS1, &temp);
 	pci_write_config_byte(sb_dev, SB_MPS1, temp | 0x20);
 
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = HW_LEVEL_MAX - HW_LEVEL_MIN;
 	progear_backlight_device = backlight_device_register("progear-bl",
 							     &pdev->dev, NULL,
-							     &progearbl_ops);
+							     &progearbl_ops,
+							     &props);
 	if (IS_ERR(progear_backlight_device)) {
 		ret = PTR_ERR(progear_backlight_device);
 		goto put_sb;
@@ -94,7 +98,6 @@ static int progearbl_probe(struct platform_device *pdev)
 
 	progear_backlight_device->props.power = FB_BLANK_UNBLANK;
 	progear_backlight_device->props.brightness = HW_LEVEL_MAX - HW_LEVEL_MIN;
-	progear_backlight_device->props.max_brightness = HW_LEVEL_MAX - HW_LEVEL_MIN;
 	progearbl_set_intensity(progear_backlight_device);
 
 	return 0;
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 9d2ec2a..b89eebc 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -65,6 +65,7 @@ static const struct backlight_ops pwm_backlight_ops = {
 
 static int pwm_backlight_probe(struct platform_device *pdev)
 {
+	struct backlight_properties props;
 	struct platform_pwm_backlight_data *data = pdev->dev.platform_data;
 	struct backlight_device *bl;
 	struct pwm_bl_data *pb;
@@ -100,15 +101,16 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	} else
 		dev_dbg(&pdev->dev, "got pwm for backlight\n");
 
-	bl = backlight_device_register(dev_name(&pdev->dev), &pdev->dev,
-			pb, &pwm_backlight_ops);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = data->max_brightness;
+	bl = backlight_device_register(dev_name(&pdev->dev), &pdev->dev, pb,
+				       &pwm_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
 		ret = PTR_ERR(bl);
 		goto err_bl;
 	}
 
-	bl->props.max_brightness = data->max_brightness;
 	bl->props.brightness = data->dft_brightness;
 	backlight_update_status(bl);
 
diff --git a/drivers/video/backlight/tosa_bl.c b/drivers/video/backlight/tosa_bl.c
index e14ce4d..f57bbf1 100644
--- a/drivers/video/backlight/tosa_bl.c
+++ b/drivers/video/backlight/tosa_bl.c
@@ -80,6 +80,7 @@ static const struct backlight_ops bl_ops = {
 static int __devinit tosa_bl_probe(struct i2c_client *client,
 		const struct i2c_device_id *id)
 {
+	struct backlight_properties props;
 	struct tosa_bl_data *data = kzalloc(sizeof(struct tosa_bl_data), GFP_KERNEL);
 	int ret = 0;
 	if (!data)
@@ -99,15 +100,16 @@ static int __devinit tosa_bl_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, data);
 	data->i2c = client;
 
-	data->bl = backlight_device_register("tosa-bl", &client->dev,
-			data, &bl_ops);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = 512 - 1;
+	data->bl = backlight_device_register("tosa-bl", &client->dev, data,
+					     &bl_ops, &props);
 	if (IS_ERR(data->bl)) {
 		ret = PTR_ERR(data->bl);
 		goto err_reg;
 	}
 
 	data->bl->props.brightness = 69;
-	data->bl->props.max_brightness = 512 - 1;
 	data->bl->props.power = FB_BLANK_UNBLANK;
 
 	backlight_update_status(data->bl);
diff --git a/drivers/video/backlight/wm831x_bl.c b/drivers/video/backlight/wm831x_bl.c
index e32add3..a431270 100644
--- a/drivers/video/backlight/wm831x_bl.c
+++ b/drivers/video/backlight/wm831x_bl.c
@@ -125,6 +125,7 @@ static int wm831x_backlight_probe(struct platform_device *pdev)
 	struct wm831x_backlight_pdata *pdata;
 	struct wm831x_backlight_data *data;
 	struct backlight_device *bl;
+	struct backlight_properties props;
 	int ret, i, max_isel, isink_reg, dcdc_cfg;
 
 	/* We need platform data */
@@ -191,15 +192,15 @@ static int wm831x_backlight_probe(struct platform_device *pdev)
 	data->current_brightness = 0;
 	data->isink_reg = isink_reg;
 
-	bl = backlight_device_register("wm831x", &pdev->dev,
-			data, &wm831x_backlight_ops);
+	props.max_brightness = max_isel;
+	bl = backlight_device_register("wm831x", &pdev->dev, data,
+				       &wm831x_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
 		kfree(data);
 		return PTR_ERR(bl);
 	}
 
-	bl->props.max_brightness = max_isel;
 	bl->props.brightness = max_isel;
 
 	platform_set_drvdata(pdev, bl);
diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index e49ae5e..24f4a85 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -531,6 +531,7 @@ static irqreturn_t bfin_bf54x_irq_error(int irq, void *dev_id)
 
 static int __devinit bfin_bf54x_probe(struct platform_device *pdev)
 {
+	struct backlight_properties props;
 	struct bfin_bf54xfb_info *info;
 	struct fb_info *fbinfo;
 	int ret;
@@ -675,10 +676,10 @@ static int __devinit bfin_bf54x_probe(struct platform_device *pdev)
 		goto out8;
 	}
 #ifndef NO_BL_SUPPORT
-	bl_dev =
-	    backlight_device_register("bf54x-bl", NULL, NULL,
-				      &bfin_lq043fb_bl_ops);
-	bl_dev->props.max_brightness = 255;
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = 255;
+	bl_dev = backlight_device_register("bf54x-bl", NULL, NULL,
+					   &bfin_lq043fb_bl_ops, &props);
 
 	lcd_dev = lcd_device_register(DRIVER_NAME, &pdev->dev, NULL, &bfin_lcd_ops);
 	lcd_dev->props.max_contrast = 255, printk(KERN_INFO "Done.\n");
diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index 2549c53..8529c81 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -448,6 +448,7 @@ static irqreturn_t bfin_t350mcqb_irq_error(int irq, void *dev_id)
 
 static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 {
+	struct backlight_properties props;
 	struct bfin_t350mcqbfb_info *info;
 	struct fb_info *fbinfo;
 	int ret;
@@ -569,10 +570,10 @@ static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 		goto out8;
 	}
 #ifndef NO_BL_SUPPORT
-	bl_dev =
-	    backlight_device_register("bf52x-bl", NULL, NULL,
-				      &bfin_lq043fb_bl_ops);
-	bl_dev->props.max_brightness = 255;
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = 255;
+	bl_dev = backlight_device_register("bf52x-bl", NULL, NULL,
+					   &bfin_lq043fb_bl_ops, &props);
 
 	lcd_dev = lcd_device_register(DRIVER_NAME, NULL, &bfin_lcd_ops);
 	lcd_dev->props.max_contrast = 255, printk(KERN_INFO "Done.\n");
diff --git a/drivers/video/nvidia/nv_backlight.c b/drivers/video/nvidia/nv_backlight.c
index 443e3c8..2fb552a 100644
--- a/drivers/video/nvidia/nv_backlight.c
+++ b/drivers/video/nvidia/nv_backlight.c
@@ -94,6 +94,7 @@ static struct backlight_ops nvidia_bl_ops = {
 
 void nvidia_bl_init(struct nvidia_par *par)
 {
+	struct backlight_properties props;
 	struct fb_info *info = pci_get_drvdata(par->pci_dev);
 	struct backlight_device *bd;
 	char name[12];
@@ -109,7 +110,10 @@ void nvidia_bl_init(struct nvidia_par *par)
 
 	snprintf(name, sizeof(name), "nvidiabl%d", info->node);
 
-	bd = backlight_device_register(name, info->dev, par, &nvidia_bl_ops);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
+	bd = backlight_device_register(name, info->dev, par, &nvidia_bl_ops,
+				       &props);
 	if (IS_ERR(bd)) {
 		info->bl_dev = NULL;
 		printk(KERN_WARNING "nvidia: Backlight registration failed\n");
@@ -121,7 +125,6 @@ void nvidia_bl_init(struct nvidia_par *par)
 		0x158 * FB_BACKLIGHT_MAX / MAX_LEVEL,
 		0x534 * FB_BACKLIGHT_MAX / MAX_LEVEL);
 
-	bd->props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd->props.brightness = bd->props.max_brightness;
 	bd->props.power = FB_BLANK_UNBLANK;
 	backlight_update_status(bd);
diff --git a/drivers/video/omap2/displays/panel-taal.c b/drivers/video/omap2/displays/panel-taal.c
index 1f01dfc..dd089bc 100644
--- a/drivers/video/omap2/displays/panel-taal.c
+++ b/drivers/video/omap2/displays/panel-taal.c
@@ -484,6 +484,7 @@ static struct attribute_group taal_attr_group = {
 
 static int taal_probe(struct omap_dss_device *dssdev)
 {
+	struct backlight_properties props;
 	struct taal_data *td;
 	struct backlight_device *bldev;
 	int r;
@@ -521,11 +522,16 @@ static int taal_probe(struct omap_dss_device *dssdev)
 
 	/* if no platform set_backlight() defined, presume DSI backlight
 	 * control */
+	memset(&props, 0, sizeof(struct backlight_properties));
 	if (!dssdev->set_backlight)
 		td->use_dsi_bl = true;
 
+	if (td->use_dsi_bl)
+		props.max_brightness = 255;
+	else
+		props.max_brightness = 127;
 	bldev = backlight_device_register("taal", &dssdev->dev, dssdev,
-			&taal_bl_ops);
+					  &taal_bl_ops, &props);
 	if (IS_ERR(bldev)) {
 		r = PTR_ERR(bldev);
 		goto err1;
@@ -535,13 +541,10 @@ static int taal_probe(struct omap_dss_device *dssdev)
 
 	bldev->props.fb_blank = FB_BLANK_UNBLANK;
 	bldev->props.power = FB_BLANK_UNBLANK;
-	if (td->use_dsi_bl) {
-		bldev->props.max_brightness = 255;
+	if (td->use_dsi_bl)
 		bldev->props.brightness = 255;
-	} else {
-		bldev->props.max_brightness = 127;
+	else
 		bldev->props.brightness = 127;
-	}
 
 	taal_bl_update_status(bldev);
 
diff --git a/drivers/video/riva/fbdev.c b/drivers/video/riva/fbdev.c
index d94c57f..618f36b 100644
--- a/drivers/video/riva/fbdev.c
+++ b/drivers/video/riva/fbdev.c
@@ -338,6 +338,7 @@ static struct backlight_ops riva_bl_ops = {
 
 static void riva_bl_init(struct riva_par *par)
 {
+	struct backlight_properties props;
 	struct fb_info *info = pci_get_drvdata(par->pdev);
 	struct backlight_device *bd;
 	char name[12];
@@ -353,7 +354,10 @@ static void riva_bl_init(struct riva_par *par)
 
 	snprintf(name, sizeof(name), "rivabl%d", info->node);
 
-	bd = backlight_device_register(name, info->dev, par, &riva_bl_ops);
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
+	bd = backlight_device_register(name, info->dev, par, &riva_bl_ops,
+				       &props);
 	if (IS_ERR(bd)) {
 		info->bl_dev = NULL;
 		printk(KERN_WARNING "riva: Backlight registration failed\n");
@@ -365,7 +369,6 @@ static void riva_bl_init(struct riva_par *par)
 		MIN_LEVEL * FB_BACKLIGHT_MAX / MAX_LEVEL,
 		FB_BACKLIGHT_MAX);
 
-	bd->props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd->props.brightness = bd->props.max_brightness;
 	bd->props.power = FB_BLANK_UNBLANK;
 	backlight_update_status(bd);
diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index ee377d7..5b4a267 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -103,7 +103,8 @@ static inline void backlight_update_status(struct backlight_device *bd)
 }
 
 extern struct backlight_device *backlight_device_register(const char *name,
-	struct device *dev, void *devdata, const struct backlight_ops *ops);
+	struct device *dev, void *devdata, const struct backlight_ops *ops,
+	const struct backlight_properties *props);
 extern void backlight_device_unregister(struct backlight_device *bd);
 extern void backlight_force_update(struct backlight_device *bd,
 				   enum backlight_update_reason reason);
-- 
1.6.6.1

