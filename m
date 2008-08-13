Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbYHMU4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbYHMU4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYHMUzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:55:53 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:45143 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbYHMUzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:55:52 -0400
From: York Sun <yorksun@freescale.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       galak@kernel.crashing.org, linux-fbdev-devel@lists.sourceforge.net,
       York Sun <yorksun@freescale.com>
Subject: [PATCH 1/2] Added virtual resolution and panning support.
Date: Wed, 13 Aug 2008 15:55:03 -0500
Message-Id: <12186609063047-git-send-email-yorksun@freescale.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12186609042933-git-send-email-yorksun@freescale.com>
References: <12186609042933-git-send-email-yorksun@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Application can now have the virtual resoltuion and use FBIOPAN_DISPLAY ioctl to pan.

Signed-off-by: York Sun <yorksun@freescale.com>
---
 drivers/video/fsl-diu-fb.c |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/video/fsl-diu-fb.c b/drivers/video/fsl-diu-fb.c
index 9cd36c2..d67e79b 100644
--- a/drivers/video/fsl-diu-fb.c
+++ b/drivers/video/fsl-diu-fb.c
@@ -778,6 +778,22 @@ static void unmap_video_memory(struct fb_info *info)
 }
 
 /*
+ * Using the fb_var_screeninfo in fb_info we set the aoi of this
+ * particular framebuffer. It is a light version of fsl_diu_set_par.
+ */
+static int fsl_diu_set_aoi(struct fb_info *info)
+{
+	struct fb_var_screeninfo *var = &info->var;
+	struct mfb_info *mfbi = info->par;
+	struct diu_ad *ad = mfbi->ad;
+
+	/* AOI should not be greater than display size */
+	ad->offset_xyi = cpu_to_le32((var->yoffset << 16) | var->xoffset);
+	ad->offset_xyd = cpu_to_le32((mfbi->y_aoi_d << 16) | mfbi->x_aoi_d);
+	return 0;
+}
+
+/*
  * Using the fb_var_screeninfo in fb_info we set the resolution of this
  * particular framebuffer. This function alters the fb_fix_screeninfo stored
  * in fb_info. It does not alter var in fb_info since we are using that
@@ -817,11 +833,11 @@ static int fsl_diu_set_par(struct fb_info *info)
 		diu_ops.get_pixel_format(var->bits_per_pixel,
 					 machine_data->monitor_port);
 	ad->addr    = cpu_to_le32(info->fix.smem_start);
-	ad->src_size_g_alpha = cpu_to_le32((var->yres << 12) |
-				var->xres) | mfbi->g_alpha;
-	/* fix me. AOI should not be greater than display size */
+	ad->src_size_g_alpha = cpu_to_le32((var->yres_virtual << 12) |
+				var->xres_virtual) | mfbi->g_alpha;
+	/* AOI should not be greater than display size */
 	ad->aoi_size 	= cpu_to_le32((var->yres << 16) | var->xres);
-	ad->offset_xyi = 0;
+	ad->offset_xyi = cpu_to_le32((var->yoffset << 16) | var->xoffset);
 	ad->offset_xyd = cpu_to_le32((mfbi->y_aoi_d << 16) | mfbi->x_aoi_d);
 
 	/* Disable chroma keying function */
@@ -921,6 +937,8 @@ static int fsl_diu_pan_display(struct fb_var_screeninfo *var,
 	else
 		info->var.vmode &= ~FB_VMODE_YWRAP;
 
+	fsl_diu_set_aoi(info);
+
 	return 0;
 }
 
@@ -989,7 +1007,7 @@ static int fsl_diu_ioctl(struct fb_info *info, unsigned int cmd,
 		pr_debug("set AOI display offset of index %d to (%d,%d)\n",
 				 mfbi->index, aoi_d.x_aoi_d, aoi_d.y_aoi_d);
 		fsl_diu_check_var(&info->var, info);
-		fsl_diu_set_par(info);
+		fsl_diu_set_aoi(info);
 		break;
 	case MFB_GET_AOID:
 		aoi_d.x_aoi_d = mfbi->x_aoi_d;
-- 
1.5.2.2

