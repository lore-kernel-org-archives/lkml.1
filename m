Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbZHUSx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbZHUSx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 14:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbZHUSx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 14:53:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:41793 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755552AbZHUSxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 14:53:25 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19JN6orCP9Jn3NkaWf5SzGorMyI9aZeeHz3yNEis6
	hnFj6YJvPFEa5f
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev-devel@lists.sourceforge.net, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH] viafb: remove unused video device stuff
Date: Fri, 21 Aug 2009 18:55:54 +0000
Message-Id: <1250880954-26822-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: remove unused video device stuff

This patch removes everything related to video devices from the driver
as it did not influence the driver operation. This patch does change the
userspace behaviour as it removes two IOCTLs and one module parameter.
But this is good as it removes useless stuff and helps the user to
figure out the options that do affect the driver behaviour (which are
still too many).

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 ioctl.h    |    6 +----
 viafbdev.c |   77 ------------------------------------------------------------
 viafbdev.h |    6 ----
 3 files changed, 1 insertions(+), 88 deletions(-)

diff --git a/drivers/video/via/ioctl.h b/drivers/video/via/ioctl.h
index 842fe30..de89980 100644
--- a/drivers/video/via/ioctl.h
+++ b/drivers/video/via/ioctl.h
@@ -50,8 +50,6 @@
 #define VIAFB_GET_GAMMA_LUT		0x56494124
 #define VIAFB_SET_GAMMA_LUT		0x56494125
 #define VIAFB_GET_GAMMA_SUPPORT_STATE	0x56494126
-#define VIAFB_SET_VIDEO_DEVICE		0x56494127
-#define VIAFB_GET_VIDEO_DEVICE		0x56494128
 #define VIAFB_SET_SECOND_MODE		0x56494129
 #define VIAFB_SYNC_SURFACE		0x56494130
 #define VIAFB_GET_DRIVER_CAPS		0x56494131
@@ -179,9 +177,7 @@ struct viafb_ioctl_setting {
 	unsigned short second_dev_bpp;
 	/* Indicate which device are primary display device. */
 	unsigned int primary_device;
-	/* Indicate which device will show video. only valid in duoview mode */
-	unsigned int video_device_status;
-	unsigned int struct_reserved[34];
+	unsigned int struct_reserved[35];
 	struct viafb_ioctl_lcd_attribute lcd_attributes;
 };
 
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 86835ee..924177c 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -36,9 +36,6 @@ static char *viafb_mode1 = "640x480";
 /* Added for specifying active devices.*/
 char *viafb_active_dev = "";
 
-/* Added for specifying video on devices.*/
-char *viafb_video_dev = "";
-
 /*Added for specify lcd output port*/
 char *viafb_lcd_port = "";
 char *viafb_dvi_port = "";
@@ -50,8 +47,6 @@ static void apply_second_mode_setting(struct fb_var_screeninfo
 	*sec_var);
 static void retrieve_device_setting(struct viafb_ioctl_setting
 	*setting_info);
-static void viafb_set_video_device(u32 video_dev_info);
-static void viafb_get_video_device(u32 *video_dev_info);
 
 static struct fb_ops viafb_ops;
 
@@ -488,7 +483,6 @@ static int viafb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
 
 	u32 __user *argp = (u32 __user *) arg;
 	u32 gpu32;
-	u32 video_dev_info = 0;
 
 	DEBUG_MSG(KERN_INFO "viafb_ioctl: 0x%X !!\n", cmd);
 	memset(&u, 0, sizeof(u));
@@ -720,15 +714,6 @@ static int viafb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
 		if (put_user(state_info, argp))
 			return -EFAULT;
 		break;
-	case VIAFB_SET_VIDEO_DEVICE:
-		get_user(video_dev_info, argp);
-		viafb_set_video_device(video_dev_info);
-		break;
-	case VIAFB_GET_VIDEO_DEVICE:
-		viafb_get_video_device(&video_dev_info);
-		if (put_user(video_dev_info, argp))
-			return -EFAULT;
-		break;
 	case VIAFB_SYNC_SURFACE:
 		DEBUG_MSG(KERN_INFO "lobo VIAFB_SYNC_SURFACE\n");
 		break;
@@ -1309,32 +1294,6 @@ static void viafb_set_device(struct device_t active_dev)
 	viafb_set_iga_path();
 }
 
-static void viafb_set_video_device(u32 video_dev_info)
-{
-	viaparinfo->video_on_crt = STATE_OFF;
-	viaparinfo->video_on_dvi = STATE_OFF;
-	viaparinfo->video_on_lcd = STATE_OFF;
-
-	/* Check available device to enable: */
-	if ((video_dev_info & CRT_Device) == CRT_Device)
-		viaparinfo->video_on_crt = STATE_ON;
-	else if ((video_dev_info & DVI_Device) == DVI_Device)
-		viaparinfo->video_on_dvi = STATE_ON;
-	else if ((video_dev_info & LCD_Device) == LCD_Device)
-		viaparinfo->video_on_lcd = STATE_ON;
-}
-
-static void viafb_get_video_device(u32 *video_dev_info)
-{
-	*video_dev_info = None_Device;
-	if (viaparinfo->video_on_crt == STATE_ON)
-		*video_dev_info |= CRT_Device;
-	else if (viaparinfo->video_on_dvi == STATE_ON)
-		*video_dev_info |= DVI_Device;
-	else if (viaparinfo->video_on_lcd == STATE_ON)
-		*video_dev_info |= LCD_Device;
-}
-
 static int get_primary_device(void)
 {
 	int primary_device = 0;
@@ -1506,18 +1465,6 @@ static void retrieve_device_setting(struct viafb_ioctl_setting
 		setting_info->device_status |= LCD_Device;
 	if (viafb_LCD2_ON == 1)
 		setting_info->device_status |= LCD2_Device;
-	if ((viaparinfo->video_on_crt == 1) && (viafb_CRT_ON == 1)) {
-		setting_info->video_device_status =
-			viaparinfo->crt_setting_info->iga_path;
-	} else if ((viaparinfo->video_on_dvi == 1) && (viafb_DVI_ON == 1)) {
-		setting_info->video_device_status =
-			viaparinfo->tmds_setting_info->iga_path;
-	} else if ((viaparinfo->video_on_lcd == 1) && (viafb_LCD_ON == 1)) {
-		setting_info->video_device_status =
-			viaparinfo->lvds_setting_info->iga_path;
-	} else {
-		setting_info->video_device_status = 0;
-	}
 
 	setting_info->samm_status = viafb_SAMM_ON;
 	setting_info->primary_device = get_primary_device();
@@ -1606,24 +1553,6 @@ static void parse_active_dev(void)
 	}
 }
 
-static void parse_video_dev(void)
-{
-	viaparinfo->video_on_crt = STATE_OFF;
-	viaparinfo->video_on_dvi = STATE_OFF;
-	viaparinfo->video_on_lcd = STATE_OFF;
-
-	if (!strncmp(viafb_video_dev, "CRT", 3)) {
-		/* Video on CRT */
-		viaparinfo->video_on_crt = STATE_ON;
-	} else if (!strncmp(viafb_video_dev, "DVI", 3)) {
-		/* Video on DVI */
-		viaparinfo->video_on_dvi = STATE_ON;
-	} else if (!strncmp(viafb_video_dev, "LCD", 3)) {
-		/* Video on LCD */
-		viaparinfo->video_on_lcd = STATE_ON;
-	}
-}
-
 static int parse_port(char *opt_str, int *output_interface)
 {
 	if (!strncmp(opt_str, "DVP0", 4))
@@ -2054,7 +1983,6 @@ static int __devinit via_pci_probe(void)
 	if (viafb_dual_fb)
 		viafb_SAMM_ON = 1;
 	parse_active_dev();
-	parse_video_dev();
 	parse_lcd_port();
 	parse_dvi_port();
 
@@ -2354,8 +2282,6 @@ static int __init viafb_setup(char *options)
 		else if (!strncmp(this_opt, "viafb_lcd_mode=", 15))
 			strict_strtoul(this_opt + 15, 0,
 				(unsigned long *)&viafb_lcd_mode);
-		else if (!strncmp(this_opt, "viafb_video_dev=", 16))
-			viafb_video_dev = kstrdup(this_opt + 16, GFP_KERNEL);
 		else if (!strncmp(this_opt, "viafb_lcd_port=", 15))
 			viafb_lcd_port = kstrdup(this_opt + 15, GFP_KERNEL);
 		else if (!strncmp(this_opt, "viafb_dvi_port=", 15))
@@ -2476,9 +2402,6 @@ module_param(viafb_lcd_mode, int, 0);
 MODULE_PARM_DESC(viafb_lcd_mode,
 	"Set Flat Panel mode(Default=OPENLDI)");
 
-module_param(viafb_video_dev, charp, 0);
-MODULE_PARM_DESC(viafb_video_dev, "Specify video devices.");
-
 module_param(viafb_lcd_port, charp, 0);
 MODULE_PARM_DESC(viafb_lcd_port, "Specify LCD output port.");
 
diff --git a/drivers/video/via/viafbdev.h b/drivers/video/via/viafbdev.h
index e5a247c..cd871f9 100644
--- a/drivers/video/via/viafbdev.h
+++ b/drivers/video/via/viafbdev.h
@@ -61,12 +61,6 @@ struct viafb_par {
 	struct lvds_setting_information *lvds_setting_info;
 	struct lvds_setting_information *lvds_setting_info2;
 	struct chip_information *chip_info;
-
-	/* some information related to video playing */
-	int video_on_crt;
-	int video_on_dvi;
-	int video_on_lcd;
-
 };
 
 extern unsigned int viafb_second_virtual_yres;
-- 
1.6.3.2

