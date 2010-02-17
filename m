Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab0BQVkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 16:40:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756798Ab0BQVkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 16:40:02 -0500
From: Matthew Garrett <mjg@redhat.com>
To: rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/2] backlight: Add support for exposing backlight types
Date: Wed, 17 Feb 2010 16:39:45 -0500
Message-Id: <1266442785-3998-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1266442785-3998-1-git-send-email-mjg@redhat.com>
References: <1266442785-3998-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There may be multiple ways of controlling the backlight on a given
machine. Allow drivers to expose the type of interface they are providing,
making it possible for userspace to make appropriate policy decisions.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 Documentation/ABI/stable/sysfs-class-backlight  |   10 ++++++++++
 drivers/acpi/video.c                            |    1 +
 drivers/gpu/drm/nouveau/nouveau_backlight.c     |    2 ++
 drivers/macintosh/via-pmu-backlight.c           |    1 +
 drivers/platform/x86/acer-wmi.c                 |    1 +
 drivers/platform/x86/asus-laptop.c              |    1 +
 drivers/platform/x86/asus_acpi.c                |    1 +
 drivers/platform/x86/classmate-laptop.c         |    1 +
 drivers/platform/x86/compal-laptop.c            |    1 +
 drivers/platform/x86/dell-laptop.c              |    1 +
 drivers/platform/x86/eeepc-laptop.c             |    1 +
 drivers/platform/x86/fujitsu-laptop.c           |    1 +
 drivers/platform/x86/msi-laptop.c               |    1 +
 drivers/platform/x86/msi-wmi.c                  |    1 +
 drivers/platform/x86/panasonic-laptop.c         |    1 +
 drivers/platform/x86/sony-laptop.c              |    1 +
 drivers/platform/x86/thinkpad_acpi.c            |    1 +
 drivers/platform/x86/toshiba_acpi.c             |    1 +
 drivers/staging/samsung-laptop/samsung-laptop.c |    1 +
 drivers/usb/misc/appledisplay.c                 |    1 +
 drivers/video/atmel_lcdfb.c                     |    1 +
 drivers/video/aty/aty128fb.c                    |    1 +
 drivers/video/aty/atyfb_base.c                  |    1 +
 drivers/video/aty/radeon_backlight.c            |    1 +
 drivers/video/backlight/adp5520_bl.c            |    1 +
 drivers/video/backlight/adx_bl.c                |    1 +
 drivers/video/backlight/atmel-pwm-bl.c          |    1 +
 drivers/video/backlight/backlight.c             |   15 +++++++++++++++
 drivers/video/backlight/corgi_lcd.c             |    1 +
 drivers/video/backlight/da903x_bl.c             |    1 +
 drivers/video/backlight/generic_bl.c            |    1 +
 drivers/video/backlight/hp680_bl.c              |    1 +
 drivers/video/backlight/jornada720_bl.c         |    1 +
 drivers/video/backlight/kb3886_bl.c             |    1 +
 drivers/video/backlight/locomolcd.c             |    1 +
 drivers/video/backlight/mbp_nvidia_bl.c         |    1 +
 drivers/video/backlight/omap1_bl.c              |    1 +
 drivers/video/backlight/progear_bl.c            |    1 +
 drivers/video/backlight/pwm_bl.c                |    1 +
 drivers/video/backlight/tosa_bl.c               |    1 +
 drivers/video/backlight/wm831x_bl.c             |    1 +
 drivers/video/bf54x-lq043fb.c                   |    1 +
 drivers/video/bfin-t350mcqb-fb.c                |    1 +
 drivers/video/nvidia/nv_backlight.c             |    1 +
 drivers/video/omap2/displays/panel-taal.c       |    2 ++
 drivers/video/riva/fbdev.c                      |    1 +
 include/linux/backlight.h                       |    8 ++++++++
 47 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-class-backlight b/Documentation/ABI/stable/sysfs-class-backlight
index 4d637e1..ef19627 100644
--- a/Documentation/ABI/stable/sysfs-class-backlight
+++ b/Documentation/ABI/stable/sysfs-class-backlight
@@ -34,3 +34,13 @@ Contact:	Richard Purdie <rpurdie@rpsys.net>
 Description:
 		Maximum brightness for <backlight>.
 Users:		HAL
+
+What:		/sys/class/backlight/<backlight>/type
+Date:		February 2010
+KernelVersion:	2.6.34
+Contact:	Matthew Garrett <mjg@redhat.com>
+Description:
+		The type of interface controlled by <backlight>.
+		"firmware": The driver uses a standard firmware interface
+		"platform": The driver uses a platform-specific interface
+		"gpu": The driver controls hardware registers directly
\ No newline at end of file
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 716b0e7..f07ed5b 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1006,6 +1006,7 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 
 		sprintf(name, "acpi_video%d", count++);
 		memset(&props, 0, sizeof(struct backlight_properties));
+		props.type = BACKLIGHT_FIRMWARE;
 		props.max_brightness = device->brightness->count - 3;
 		device->backlight = backlight_device_register(name, NULL, device,
 							      &acpi_backlight_ops,
diff --git a/drivers/gpu/drm/nouveau/nouveau_backlight.c b/drivers/gpu/drm/nouveau/nouveau_backlight.c
index 406228f..5bd28f2 100644
--- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
+++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
@@ -97,6 +97,7 @@ static int nouveau_nv40_backlight_init(struct drm_device *dev)
 		return 0;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = 31;
 	bd = backlight_device_register("nv_backlight", &dev->pdev->dev, dev,
 				       &nv40_bl_ops, &props);
@@ -120,6 +121,7 @@ static int nouveau_nv50_backlight_init(struct drm_device *dev)
 		return 0;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = 1025;
 	bd = backlight_device_register("nv_backlight", &dev->pdev->dev, dev,
 				       &nv50_bl_ops, &props);
diff --git a/drivers/macintosh/via-pmu-backlight.c b/drivers/macintosh/via-pmu-backlight.c
index c48cf8a..1ec118a 100644
--- a/drivers/macintosh/via-pmu-backlight.c
+++ b/drivers/macintosh/via-pmu-backlight.c
@@ -163,6 +163,7 @@ void __init pmu_backlight_init()
 	snprintf(name, sizeof(name), "pmubl");
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd = backlight_device_register(name, NULL, NULL, &pmu_backlight_data,
 				       &props);
diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 4d9b490..5f7c5e3 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -926,6 +926,7 @@ static int __devinit acer_backlight_init(struct device *dev)
 	struct backlight_device *bd;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = max_brightness;
 	bd = backlight_device_register("acer-wmi", dev, NULL, &acer_bl_ops,
 				       &props);
diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 940bac5..4dc8410 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -1365,6 +1365,7 @@ static int asus_backlight_init(struct device *dev)
 	if (brightness_set_handle && lcd_switch_handle) {
 		struct backlight_properties props;
 		memset(&props, 0, sizeof(struct backlight_properties));
+		props.type = BACKLIGHT_PLATFORM;
 		props.max_brightness = 15;
 		bd = backlight_device_register(ASUS_HOTK_FILE, dev, NULL,
 					       &asusbl_ops, &props);
diff --git a/drivers/platform/x86/asus_acpi.c b/drivers/platform/x86/asus_acpi.c
index 34e9cc7..4dc33f1 100644
--- a/drivers/platform/x86/asus_acpi.c
+++ b/drivers/platform/x86/asus_acpi.c
@@ -1510,6 +1510,7 @@ static int __init asus_acpi_init(void)
 	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = 15;
 	asus_backlight_device = backlight_device_register("asus", NULL, NULL,
 							  &asus_backlight_data,
diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x86/classmate-laptop.c
index f00635b..5399831 100644
--- a/drivers/platform/x86/classmate-laptop.c
+++ b/drivers/platform/x86/classmate-laptop.c
@@ -463,6 +463,7 @@ static int cmpc_bl_add(struct acpi_device *acpi)
 	struct backlight_device *bd;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = 7;
 	bd = backlight_device_register("cmpc_bl", &acpi->dev, acpi->handle,
 				       &cmpc_bl_ops, &props);
diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index 24110c5..db72ac0 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -328,6 +328,7 @@ static int __init compal_init(void)
 	if (!acpi_video_backlight_support()) {
 		struct backlight_properties props;
 		memset(&props, 0, sizeof(struct backlight_properties));
+		props.type = BACKLIGHT_PLATFORM;
 		props.max_brightness = COMPAL_LCD_LEVEL_MAX - 1;
 		compalbl_device = backlight_device_register("compal-laptop",
 							    NULL, NULL,
diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index f22c565..8138dd5 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -392,6 +392,7 @@ static int __init dell_init(void)
 	if (max_intensity) {
 		struct backlight_properties props;
 		memset(&props, 0, sizeof(struct backlight_properties));
+		props.type = BACKLIGHT_PLATFORM;
 		props.max_brightness = max_intensity;
 		dell_backlight_device = backlight_device_register("dell_backlight",
 								  &platform_device->dev,
diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index d5e5ed8..fadb5a0 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -1117,6 +1117,7 @@ static int eeepc_backlight_init(struct eeepc_laptop *eeepc)
 	struct backlight_device *bd;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = 15;
 	bd = backlight_device_register(EEEPC_LAPTOP_FILE,
 				       &eeepc->platform_device->dev, eeepc,
diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index c1074b3..8a555a0 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -1130,6 +1130,7 @@ static int __init fujitsu_init(void)
 
 		memset(&props, 0, sizeof(struct backlight_properties));
 		max_brightness = fujitsu->max_brightness;
+		props.type = BACKLIGHT_PLATFORM;
 		props.max_brightness = max_brightness - 1;
 		fujitsu->bl_device = backlight_device_register("fujitsu-laptop",
 							       NULL, NULL,
diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index cb4dc92..5c672f8 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -353,6 +353,7 @@ static int __init msi_init(void)
 	} else {
 		struct backlight_properties props;
 		memset(&props, 0, sizeof(struct backlight_properties));
+		props.type = BACKLIGHT_PLATFORM;
 		props.max_brightness = MSI_LCD_LEVEL_MAX - 1;
 		msibl_device = backlight_device_register("msi-laptop-bl", NULL,
 							 NULL, &msibl_ops,
diff --git a/drivers/platform/x86/msi-wmi.c b/drivers/platform/x86/msi-wmi.c
index fb7ccaa..62018a5 100644
--- a/drivers/platform/x86/msi-wmi.c
+++ b/drivers/platform/x86/msi-wmi.c
@@ -251,6 +251,7 @@ static int __init msi_wmi_init(void)
 	if (!acpi_video_backlight_support()) {
 		struct backlight_properties props;
 		memset(&props, 0, sizeof(struct backlight_properties));
+		props.type = BACKLIGHT_PLATFORM;
 		props.max_brightness = ARRAY_SIZE(backlight_map) - 1;
 		backlight = backlight_device_register(DRV_NAME, NULL, NULL,
 						      &msi_backlight_ops,
diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index c6efddd..e4f6d84 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -649,6 +649,7 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 	}
 	/* initialize backlight */
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = pcc->sinf[SINF_AC_MAX_BRIGHT];
 	pcc->backlight = backlight_device_register("panasonic", NULL, pcc,
 						   &pcc_backlight_ops, &props);
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index 87fc12d..0655048 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -1290,6 +1290,7 @@ static int sony_nc_add(struct acpi_device *device)
 						&handle))) {
 							struct backlight_properties props;
 		memset(&props, 0, sizeof(struct backlight_properties));
+		props.type = BACKLIGHT_PLATFORM;
 		props.max_brightness = SONY_MAX_BRIGHTNESS - 1;
 		sony_backlight_device = backlight_device_register("sony", NULL,
 								  NULL,
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 9466de0..839b481 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6242,6 +6242,7 @@ static int __init brightness_init(struct ibm_init_struct *iibm)
 		       "detected a 16-level brightness capable ThinkPad\n");
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = (tp_features.bright_16levels) ? 15 : 7;
 	ibm_backlight_device = backlight_device_register(TPACPI_BACKLIGHT_DEV_NAME,
 							 NULL, NULL,
diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 800bd4f..b0de00d 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -784,6 +784,7 @@ static int __init toshiba_acpi_init(void)
 		}
 	}
 
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = HCI_LCD_BRIGHTNESS_LEVELS - 1;
 	toshiba_backlight_device = backlight_device_register("toshiba",
 							     &toshiba_acpi.p_dev->dev,
diff --git a/drivers/staging/samsung-laptop/samsung-laptop.c b/drivers/staging/samsung-laptop/samsung-laptop.c
index 7490ad1..22631eb 100644
--- a/drivers/staging/samsung-laptop/samsung-laptop.c
+++ b/drivers/staging/samsung-laptop/samsung-laptop.c
@@ -485,6 +485,7 @@ static int __init samsung_init(void)
 
 	/* create a backlight device to talk to this one */
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = MAX_BRIGHT;
 	backlight_device = backlight_device_register("samsung", &sdev->dev,
 						     NULL, &backlight_ops,
diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
index 97aaac3..6bee158 100644
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -281,6 +281,7 @@ static int appledisplay_probe(struct usb_interface *iface,
 	snprintf(bl_name, sizeof(bl_name), "appledisplay%d",
 		atomic_inc_return(&count_displays) - 1);
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = 0xff;
 	pdata->bd = backlight_device_register(bl_name, NULL, pdata,
 					      &appledisplay_bl_data, &props);
diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 11de3bf..88d562c 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -126,6 +126,7 @@ static void init_backlight(struct atmel_lcdfb_info *sinfo)
 		return;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = 0xff;
 	bl = backlight_device_register("backlight", &sinfo->pdev->dev, sinfo,
 				       &atmel_lcdc_bl_ops, &props);
diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index 7694999..24b51e3 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -1819,6 +1819,7 @@ static void aty128_bl_init(struct aty128fb_par *par)
 	snprintf(name, sizeof(name), "aty128bl%d", info->node);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd = backlight_device_register(name, info->dev, par, &aty128_bl_data,
 				       &props);
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index 3d7cd1e..4ee7293 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -2245,6 +2245,7 @@ static void aty_bl_init(struct atyfb_par *par)
 	snprintf(name, sizeof(name), "atybl%d", info->node);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd = backlight_device_register(name, info->dev, par, &aty_bl_data,
 				       &props);
diff --git a/drivers/video/aty/radeon_backlight.c b/drivers/video/aty/radeon_backlight.c
index 94e94d8..f34ee9e 100644
--- a/drivers/video/aty/radeon_backlight.c
+++ b/drivers/video/aty/radeon_backlight.c
@@ -157,6 +157,7 @@ void radeonfb_bl_init(struct radeonfb_info *rinfo)
 	snprintf(name, sizeof(name), "radeonbl%d", rinfo->info->node);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd = backlight_device_register(name, rinfo->info->dev, pdata,
 				       &radeon_bl_data, &props);
diff --git a/drivers/video/backlight/adp5520_bl.c b/drivers/video/backlight/adp5520_bl.c
index 5183f0e..63943d2 100644
--- a/drivers/video/backlight/adp5520_bl.c
+++ b/drivers/video/backlight/adp5520_bl.c
@@ -302,6 +302,7 @@ static int __devinit adp5520_bl_probe(struct platform_device *pdev)
 	mutex_init(&data->lock);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = ADP5020_MAX_BRIGHTNESS;
 	bl = backlight_device_register(pdev->name, data->master, data,
 				       &adp5520_bl_ops, &props);
diff --git a/drivers/video/backlight/adx_bl.c b/drivers/video/backlight/adx_bl.c
index 5048fc5..5bfe82a 100644
--- a/drivers/video/backlight/adx_bl.c
+++ b/drivers/video/backlight/adx_bl.c
@@ -103,6 +103,7 @@ static int __devinit adx_backlight_probe(struct platform_device *pdev)
 	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = 0xff;
 	bldev = backlight_device_register(dev_name(&pdev->dev), &pdev->dev,
 					  bl, &adx_backlight_ops, &props);
diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index 2d97605..b42014b 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -167,6 +167,7 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
 	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = pdata->pwm_duty_max - pdata->pwm_duty_min;
 	bldev = backlight_device_register("atmel-pwm-bl", &pdev->dev, pwmbl,
 					  &atmel_pwm_bl_ops, &props);
diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 99ab972..9e4dd22 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -18,6 +18,12 @@
 #include <asm/backlight.h>
 #endif
 
+static const char *backlight_types[] = {
+	"gpu",
+	"platform",
+	"firmware",
+};
+
 #if defined(CONFIG_FB) || (defined(CONFIG_FB_MODULE) && \
 			   defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE))
 /* This callback gets called when something important happens inside a
@@ -168,6 +174,14 @@ static ssize_t backlight_store_brightness(struct device *dev,
 	return rc;
 }
 
+static ssize_t backlight_show_type(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct backlight_device *bd = to_backlight_device(dev);
+
+	return sprintf(buf, "%s\n", backlight_types[bd->props.type]);
+}
+
 static ssize_t backlight_show_max_brightness(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -233,6 +247,7 @@ static struct device_attribute bl_device_attributes[] = {
 	__ATTR(actual_brightness, 0444, backlight_show_actual_brightness,
 		     NULL),
 	__ATTR(max_brightness, 0444, backlight_show_max_brightness, NULL),
+	__ATTR(type, 0444, backlight_show_type, NULL),
 	__ATTR_NULL,
 };
 
diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index 73bdd84..c0f43d7 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -561,6 +561,7 @@ static int __devinit corgi_lcd_probe(struct spi_device *spi)
 	lcd->mode = (pdata) ? pdata->init_mode : CORGI_LCD_MODE_VGA;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = pdata->max_intensity;
 	lcd->bl_dev = backlight_device_register("corgi_bl", &spi->dev, lcd,
 						&corgi_bl_ops, &props);
diff --git a/drivers/video/backlight/da903x_bl.c b/drivers/video/backlight/da903x_bl.c
index 686e4a7..818b16b 100644
--- a/drivers/video/backlight/da903x_bl.c
+++ b/drivers/video/backlight/da903x_bl.c
@@ -135,6 +135,7 @@ static int da903x_backlight_probe(struct platform_device *pdev)
 		da903x_write(data->da903x_dev, DA9034_WLED_CONTROL2,
 				DA9034_WLED_ISET(pdata->output_current));
 
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = max_brightness;
 	bl = backlight_device_register(pdev->name, data->da903x_dev, data,
 				       &da903x_backlight_ops, &props);
diff --git a/drivers/video/backlight/generic_bl.c b/drivers/video/backlight/generic_bl.c
index 312ca61..f82ca63 100644
--- a/drivers/video/backlight/generic_bl.c
+++ b/drivers/video/backlight/generic_bl.c
@@ -91,6 +91,7 @@ static int genericbl_probe(struct platform_device *pdev)
 		name = machinfo->name;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = machinfo->max_intensity;
 	bd = backlight_device_register(name, &pdev->dev, NULL, &genericbl_ops,
 				       &props);
diff --git a/drivers/video/backlight/hp680_bl.c b/drivers/video/backlight/hp680_bl.c
index 267d23f..79cd0d1 100644
--- a/drivers/video/backlight/hp680_bl.c
+++ b/drivers/video/backlight/hp680_bl.c
@@ -109,6 +109,7 @@ static int __devinit hp680bl_probe(struct platform_device *pdev)
 	struct backlight_device *bd;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = HP680_MAX_INTENSITY;
 	bd = backlight_device_register("hp680-bl", &pdev->dev, NULL,
 				       &hp680bl_ops, &props);
diff --git a/drivers/video/backlight/jornada720_bl.c b/drivers/video/backlight/jornada720_bl.c
index 2f177b3..6ac9db7 100644
--- a/drivers/video/backlight/jornada720_bl.c
+++ b/drivers/video/backlight/jornada720_bl.c
@@ -106,6 +106,7 @@ static int jornada_bl_probe(struct platform_device *pdev)
 	struct backlight_device *bd;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = BL_MAX_BRIGHT;
 	bd = backlight_device_register(S1D_DEVICENAME, &pdev->dev, NULL,
 				       &jornada_bl_ops, &props);
diff --git a/drivers/video/backlight/kb3886_bl.c b/drivers/video/backlight/kb3886_bl.c
index f439a86..4c7dcd4 100644
--- a/drivers/video/backlight/kb3886_bl.c
+++ b/drivers/video/backlight/kb3886_bl.c
@@ -149,6 +149,7 @@ static int kb3886bl_probe(struct platform_device *pdev)
 		machinfo->limit_mask = -1;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = machinfo->max_intensity;
 	kb3886_backlight_device = backlight_device_register("kb3886-bl",
 							    &pdev->dev, NULL,
diff --git a/drivers/video/backlight/locomolcd.c b/drivers/video/backlight/locomolcd.c
index 7571bc2..20ffcf0 100644
--- a/drivers/video/backlight/locomolcd.c
+++ b/drivers/video/backlight/locomolcd.c
@@ -184,6 +184,7 @@ static int locomolcd_probe(struct locomo_dev *ldev)
 	local_irq_restore(flags);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = 4;
 	locomolcd_bl_device = backlight_device_register("locomo-bl",
 							&ldev->dev, NULL,
diff --git a/drivers/video/backlight/mbp_nvidia_bl.c b/drivers/video/backlight/mbp_nvidia_bl.c
index 0881358..f349422 100644
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -259,6 +259,7 @@ static int __init mbp_init(void)
 		return -ENXIO;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = 15;
 	mbp_backlight_device = backlight_device_register("mbp_backlight", NULL,
 							 NULL,
diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index 333d28e..ce9b006 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -145,6 +145,7 @@ static int omapbl_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = OMAPBL_MAX_INTENSITY;
 	dev = backlight_device_register("omap-bl", &pdev->dev, bl, &omapbl_ops,
 					&props);
diff --git a/drivers/video/backlight/progear_bl.c b/drivers/video/backlight/progear_bl.c
index 809278c..a650abf 100644
--- a/drivers/video/backlight/progear_bl.c
+++ b/drivers/video/backlight/progear_bl.c
@@ -84,6 +84,7 @@ static int progearbl_probe(struct platform_device *pdev)
 	pci_write_config_byte(sb_dev, SB_MPS1, temp | 0x20);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = HW_LEVEL_MAX - HW_LEVEL_MIN;
 	progear_backlight_device = backlight_device_register("progear-bl",
 							     &pdev->dev, NULL,
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index b89eebc..7dda261 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -102,6 +102,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 		dev_dbg(&pdev->dev, "got pwm for backlight\n");
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = data->max_brightness;
 	bl = backlight_device_register(dev_name(&pdev->dev), &pdev->dev, pb,
 				       &pwm_backlight_ops, &props);
diff --git a/drivers/video/backlight/tosa_bl.c b/drivers/video/backlight/tosa_bl.c
index f57bbf1..d071b3a 100644
--- a/drivers/video/backlight/tosa_bl.c
+++ b/drivers/video/backlight/tosa_bl.c
@@ -101,6 +101,7 @@ static int __devinit tosa_bl_probe(struct i2c_client *client,
 	data->i2c = client;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = 512 - 1;
 	data->bl = backlight_device_register("tosa-bl", &client->dev, data,
 					     &bl_ops, &props);
diff --git a/drivers/video/backlight/wm831x_bl.c b/drivers/video/backlight/wm831x_bl.c
index a431270..75aeee8 100644
--- a/drivers/video/backlight/wm831x_bl.c
+++ b/drivers/video/backlight/wm831x_bl.c
@@ -192,6 +192,7 @@ static int wm831x_backlight_probe(struct platform_device *pdev)
 	data->current_brightness = 0;
 	data->isink_reg = isink_reg;
 
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = max_isel;
 	bl = backlight_device_register("wm831x", &pdev->dev, data,
 				       &wm831x_backlight_ops, &props);
diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index 24f4a85..f3aba9d 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -677,6 +677,7 @@ static int __devinit bfin_bf54x_probe(struct platform_device *pdev)
 	}
 #ifndef NO_BL_SUPPORT
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = 255;
 	bl_dev = backlight_device_register("bf54x-bl", NULL, NULL,
 					   &bfin_lq043fb_bl_ops, &props);
diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index 8529c81..906b8c1 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -571,6 +571,7 @@ static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 	}
 #ifndef NO_BL_SUPPORT
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = 255;
 	bl_dev = backlight_device_register("bf52x-bl", NULL, NULL,
 					   &bfin_lq043fb_bl_ops, &props);
diff --git a/drivers/video/nvidia/nv_backlight.c b/drivers/video/nvidia/nv_backlight.c
index 2fb552a..c4baf46 100644
--- a/drivers/video/nvidia/nv_backlight.c
+++ b/drivers/video/nvidia/nv_backlight.c
@@ -111,6 +111,7 @@ void nvidia_bl_init(struct nvidia_par *par)
 	snprintf(name, sizeof(name), "nvidiabl%d", info->node);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd = backlight_device_register(name, info->dev, par, &nvidia_bl_ops,
 				       &props);
diff --git a/drivers/video/omap2/displays/panel-taal.c b/drivers/video/omap2/displays/panel-taal.c
index dd089bc..e6947fe 100644
--- a/drivers/video/omap2/displays/panel-taal.c
+++ b/drivers/video/omap2/displays/panel-taal.c
@@ -530,6 +530,8 @@ static int taal_probe(struct omap_dss_device *dssdev)
 		props.max_brightness = 255;
 	else
 		props.max_brightness = 127;
+
+	props.type = BACKLIGHT_GPU;
 	bldev = backlight_device_register("taal", &dssdev->dev, dssdev,
 					  &taal_bl_ops, &props);
 	if (IS_ERR(bldev)) {
diff --git a/drivers/video/riva/fbdev.c b/drivers/video/riva/fbdev.c
index 618f36b..161d93a 100644
--- a/drivers/video/riva/fbdev.c
+++ b/drivers/video/riva/fbdev.c
@@ -355,6 +355,7 @@ static void riva_bl_init(struct riva_par *par)
 	snprintf(name, sizeof(name), "rivabl%d", info->node);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_GPU;
 	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd = backlight_device_register(name, info->dev, par, &riva_bl_ops,
 				       &props);
diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index 5b4a267..08e1b56 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -32,6 +32,12 @@ enum backlight_update_reason {
 	BACKLIGHT_UPDATE_SYSFS,
 };
 
+enum backlight_type {
+	BACKLIGHT_GPU,
+	BACKLIGHT_PLATFORM,
+	BACKLIGHT_FIRMWARE,
+};
+
 struct backlight_device;
 struct fb_info;
 
@@ -62,6 +68,8 @@ struct backlight_properties {
 	/* FB Blanking active? (values as for power) */
 	/* Due to be removed, please use (state & BL_CORE_FBBLANK) */
 	int fb_blank;
+	/* Backlight type */
+	enum backlight_type type;
 	/* Flags used to signal drivers of state changes */
 	/* Upper 4 bits are reserved for driver internal use */
 	unsigned int state;
-- 
1.6.6.1

