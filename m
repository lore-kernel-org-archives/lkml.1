Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbYCIBqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbYCIBqa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 20:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYCIBpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 20:45:40 -0500
Received: from mail.queued.net ([207.210.101.209]:2716 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbYCIBpS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 20:45:18 -0500
Date: Sat, 8 Mar 2008 20:48:49 -0500
From: Andres Salomon <dilinger@queued.net>
To: adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       info-linux@geode.amd.com, Jordan Crouse <jordan.crouse@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/6] gxfb:stop sharing code with gx1fb
Message-ID: <20080308204849.672e750c@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4eaafb88c2231df7f726b1a8b9b6eb325137d8f8 Mon Sep 17 00:00:00 2001
From: Andres Salomon <dilinger@debian.org>
Date: Mon, 25 Feb 2008 15:54:47 -0500
Subject: [PATCH] gxfb: stop sharing code with gx1fb

We want to stop sharing stuff with gx1fb; it makes little sense.  There
were fields in geodefb_par that weren't being used, there was little point
to the DC/VP ops callbacks, etc.  This implements the following:

  - Create gxfb_par (based on geodefb_par), place it in gxfb.h
  - Drop display_gx.h and video_gx.h.  The last few patches moved most
    stuff into gxfb.h anyways, so there was very little left.
  - Drop the geode_{dc,vid}_ops stuff.  Un-static functions, add
    declarations to gxfb.h.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/geode/display_gx.c |   21 +++++++--------------
 drivers/video/geode/display_gx.h |   19 -------------------
 drivers/video/geode/gxfb.h       |   18 +++++++++++++++++-
 drivers/video/geode/gxfb_core.c  |   32 ++++++++++----------------------
 drivers/video/geode/video_gx.c   |   20 ++++++--------------
 drivers/video/geode/video_gx.h   |   16 ----------------
 6 files changed, 40 insertions(+), 86 deletions(-)
 delete mode 100644 drivers/video/geode/display_gx.h
 delete mode 100644 drivers/video/geode/video_gx.h

diff --git a/drivers/video/geode/display_gx.c b/drivers/video/geode/display_gx.c
index 351468d..b938a7f 100644
--- a/drivers/video/geode/display_gx.c
+++ b/drivers/video/geode/display_gx.c
@@ -18,8 +18,6 @@
 #include <asm/div64.h>
 #include <asm/delay.h>
 
-#include "geodefb.h"
-#include "display_gx.h"
 #include "gxfb.h"
 
 unsigned int gx_frame_buffer_size(void)
@@ -43,9 +41,9 @@ int gx_line_delta(int xres, int bpp)
 	return (xres * (bpp >> 3) + 7) & ~0x7;
 }
 
-static void gx_set_mode(struct fb_info *info)
+void gx_set_mode(struct fb_info *info)
 {
-	struct geodefb_par *par = info->par;
+	struct gxfb_par *par = info->par;
 	u32 gcfg, dcfg;
 	int hactive, hblankstart, hsyncstart, hsyncend, hblankend, htotal;
 	int vactive, vblankstart, vsyncstart, vsyncend, vblankend, vtotal;
@@ -69,7 +67,7 @@ static void gx_set_mode(struct fb_info *info)
 	write_dc(DC_GENERAL_CFG, gcfg);
 
 	/* Setup DCLK and its divisor. */
-	par->vid_ops->set_dclk(info);
+	gx_set_dclk_frequency(info);
 
 	/*
 	 * Setup new mode.
@@ -143,16 +141,16 @@ static void gx_set_mode(struct fb_info *info)
 	write_dc(DC_DISPLAY_CFG, dcfg);
 	write_dc(DC_GENERAL_CFG, gcfg);
 
-	par->vid_ops->configure_display(info);
+	gx_configure_display(info);
 
 	/* Relock display controller registers */
 	write_dc(DC_UNLOCK, DC_UNLOCK_LOCK);
 }
 
-static void gx_set_hw_palette_reg(struct fb_info *info, unsigned regno,
-				   unsigned red, unsigned green, unsigned blue)
+void gx_set_hw_palette_reg(struct fb_info *info, unsigned regno,
+		unsigned red, unsigned green, unsigned blue)
 {
-	struct geodefb_par *par = info->par;
+	struct gxfb_par *par = info->par;
 	int val;
 
 	/* Hardware palette is in RGB 8-8-8 format. */
@@ -163,8 +161,3 @@ static void gx_set_hw_palette_reg(struct fb_info *info, unsigned regno,
 	write_dc(DC_PAL_ADDRESS, regno);
 	write_dc(DC_PAL_DATA, val);
 }
-
-struct geode_dc_ops gx_dc_ops = {
-	.set_mode	 = gx_set_mode,
-	.set_palette_reg = gx_set_hw_palette_reg,
-};
diff --git a/drivers/video/geode/display_gx.h b/drivers/video/geode/display_gx.h
deleted file mode 100644
index ad556d3..0000000
--- a/drivers/video/geode/display_gx.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/*
- * Geode GX display controller
- *
- * Copyright (C) 2006 Arcom Control Systems Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-#ifndef __DISPLAY_GX_H__
-#define __DISPLAY_GX_H__
-
-unsigned int gx_frame_buffer_size(void);
-int gx_line_delta(int xres, int bpp);
-
-extern struct geode_dc_ops gx_dc_ops;
-
-#endif /* !__DISPLAY_GX1_H__ */
diff --git a/drivers/video/geode/gxfb.h b/drivers/video/geode/gxfb.h
index 19cf8ca..ec7d526 100644
--- a/drivers/video/geode/gxfb.h
+++ b/drivers/video/geode/gxfb.h
@@ -1,7 +1,7 @@
 /*
  * Copyright (C) 2008 Andres Salomon <dilinger@debian.org>
  *
- * Geode GX2 register tables
+ * Geode GX2 header information
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -11,6 +11,22 @@
 #ifndef _GXFB_H_
 #define _GXFB_H_
 
+struct gxfb_par {
+	int enable_crt;
+	void __iomem *dc_regs;
+	void __iomem *vid_regs;
+};
+
+unsigned int gx_frame_buffer_size(void);
+int gx_line_delta(int xres, int bpp);
+void gx_set_mode(struct fb_info *info);
+void gx_set_hw_palette_reg(struct fb_info *info, unsigned regno,
+		unsigned red, unsigned green, unsigned blue);
+
+void gx_set_dclk_frequency(struct fb_info *info);
+void gx_configure_display(struct fb_info *info);
+int gx_blank_display(struct fb_info *info, int blank_mode);
+
 
 /* Display Controller registers (table 6-38 from the data book) */
 enum dc_registers {
diff --git a/drivers/video/geode/gxfb_core.c b/drivers/video/geode/gxfb_core.c
index ee25774..12a9382 100644
--- a/drivers/video/geode/gxfb_core.c
+++ b/drivers/video/geode/gxfb_core.c
@@ -32,9 +32,6 @@
 #include <linux/pci.h>
 #include <asm/geode.h>
 
-#include "geodefb.h"
-#include "display_gx.h"
-#include "video_gx.h"
 #include "gxfb.h"
 
 static char *mode_option;
@@ -142,8 +139,6 @@ static int gxfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 
 static int gxfb_set_par(struct fb_info *info)
 {
-	struct geodefb_par *par = info->par;
-
 	if (info->var.bits_per_pixel > 8) {
 		info->fix.visual = FB_VISUAL_TRUECOLOR;
 		fb_dealloc_cmap(&info->cmap);
@@ -154,7 +149,7 @@ static int gxfb_set_par(struct fb_info *info)
 
 	info->fix.line_length = gx_line_delta(info->var.xres, info->var.bits_per_pixel);
 
-	par->dc_ops->set_mode(info);
+	gx_set_mode(info);
 
 	return 0;
 }
@@ -170,8 +165,6 @@ static int gxfb_setcolreg(unsigned regno, unsigned red, unsigned green,
 			   unsigned blue, unsigned transp,
 			   struct fb_info *info)
 {
-	struct geodefb_par *par = info->par;
-
 	if (info->var.grayscale) {
 		/* grayscale = 0.30*R + 0.59*G + 0.11*B */
 		red = green = blue = (red * 77 + green * 151 + blue * 28) >> 8;
@@ -194,7 +187,7 @@ static int gxfb_setcolreg(unsigned regno, unsigned red, unsigned green,
 		if (regno >= 256)
 			return -EINVAL;
 
-		par->dc_ops->set_palette_reg(info, regno, red, green, blue);
+		gx_set_hw_palette_reg(info, regno, red, green, blue);
 	}
 
 	return 0;
@@ -202,14 +195,12 @@ static int gxfb_setcolreg(unsigned regno, unsigned red, unsigned green,
 
 static int gxfb_blank(int blank_mode, struct fb_info *info)
 {
-	struct geodefb_par *par = info->par;
-
-	return par->vid_ops->blank_display(info, blank_mode);
+	return gx_blank_display(info, blank_mode);
 }
 
 static int __init gxfb_map_video_memory(struct fb_info *info, struct pci_dev *dev)
 {
-	struct geodefb_par *par = info->par;
+	struct gxfb_par *par = info->par;
 	int ret;
 
 	ret = pci_enable_device(dev);
@@ -266,11 +257,12 @@ static struct fb_ops gxfb_ops = {
 
 static struct fb_info * __init gxfb_init_fbinfo(struct device *dev)
 {
-	struct geodefb_par *par;
+	struct gxfb_par *par;
 	struct fb_info *info;
 
 	/* Alloc enough space for the pseudo palette. */
-	info = framebuffer_alloc(sizeof(struct geodefb_par) + sizeof(u32) * 16, dev);
+	info = framebuffer_alloc(sizeof(struct gxfb_par) + sizeof(u32) * 16,
+			dev);
 	if (!info)
 		return NULL;
 
@@ -296,7 +288,7 @@ static struct fb_info * __init gxfb_init_fbinfo(struct device *dev)
 	info->flags		= FBINFO_DEFAULT;
 	info->node		= -1;
 
-	info->pseudo_palette	= (void *)par + sizeof(struct geodefb_par);
+	info->pseudo_palette	= (void *)par + sizeof(struct gxfb_par);
 
 	info->var.grayscale	= 0;
 
@@ -305,7 +297,7 @@ static struct fb_info * __init gxfb_init_fbinfo(struct device *dev)
 
 static int __init gxfb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	struct geodefb_par *par;
+	struct gxfb_par *par;
 	struct fb_info *info;
 	int ret;
 	unsigned long val;
@@ -315,10 +307,6 @@ static int __init gxfb_probe(struct pci_dev *pdev, const struct pci_device_id *i
 		return -ENOMEM;
 	par = info->par;
 
-	/* GX display controller and GX video device. */
-	par->dc_ops  = &gx_dc_ops;
-	par->vid_ops = &gx_vid_ops;
-
 	if ((ret = gxfb_map_video_memory(info, pdev)) < 0) {
 		dev_err(&pdev->dev, "failed to map frame buffer or controller registers\n");
 		goto err;
@@ -378,7 +366,7 @@ static int __init gxfb_probe(struct pci_dev *pdev, const struct pci_device_id *i
 static void gxfb_remove(struct pci_dev *pdev)
 {
 	struct fb_info *info = pci_get_drvdata(pdev);
-	struct geodefb_par *par = info->par;
+	struct gxfb_par *par = info->par;
 
 	unregister_framebuffer(info);
 
diff --git a/drivers/video/geode/video_gx.c b/drivers/video/geode/video_gx.c
index bb77ccc..26df0ff 100644
--- a/drivers/video/geode/video_gx.c
+++ b/drivers/video/geode/video_gx.c
@@ -18,8 +18,6 @@
 #include <asm/msr.h>
 #include <asm/geode.h>
 
-#include "geodefb.h"
-#include "video_gx.h"
 #include "gxfb.h"
 
 
@@ -119,7 +117,7 @@ static const struct gx_pll_entry gx_pll_table_14MHz[] = {
 	{  4357, 0, 0x0000057D },	/* 229.5000 */
 };
 
-static void gx_set_dclk_frequency(struct fb_info *info)
+void gx_set_dclk_frequency(struct fb_info *info)
 {
 	const struct gx_pll_entry *pll_table;
 	int pll_table_len;
@@ -180,7 +178,7 @@ static void gx_set_dclk_frequency(struct fb_info *info)
 static void
 gx_configure_tft(struct fb_info *info)
 {
-	struct geodefb_par *par = info->par;
+	struct gxfb_par *par = info->par;
 	unsigned long val;
 	unsigned long fp;
 
@@ -235,9 +233,9 @@ gx_configure_tft(struct fb_info *info)
 	write_fp(FP_PM, fp);
 }
 
-static void gx_configure_display(struct fb_info *info)
+void gx_configure_display(struct fb_info *info)
 {
-	struct geodefb_par *par = info->par;
+	struct gxfb_par *par = info->par;
 	u32 dcfg, misc;
 
 	/* Write the display configuration */
@@ -297,9 +295,9 @@ static void gx_configure_display(struct fb_info *info)
 		gx_configure_tft(info);
 }
 
-static int gx_blank_display(struct fb_info *info, int blank_mode)
+int gx_blank_display(struct fb_info *info, int blank_mode)
 {
-	struct geodefb_par *par = info->par;
+	struct gxfb_par *par = info->par;
 	u32 dcfg, fp_pm;
 	int blank, hsync, vsync;
 
@@ -347,9 +345,3 @@ static int gx_blank_display(struct fb_info *info, int blank_mode)
 
 	return 0;
 }
-
-struct geode_vid_ops gx_vid_ops = {
-	.set_dclk	   = gx_set_dclk_frequency,
-	.configure_display = gx_configure_display,
-	.blank_display	   = gx_blank_display,
-};
diff --git a/drivers/video/geode/video_gx.h b/drivers/video/geode/video_gx.h
deleted file mode 100644
index 79f6e81..0000000
--- a/drivers/video/geode/video_gx.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * Geode GX video device
- *
- * Copyright (C) 2006 Arcom Control Systems Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-#ifndef __VIDEO_GX_H__
-#define __VIDEO_GX_H__
-
-extern struct geode_vid_ops gx_vid_ops;
-
-#endif /* !__VIDEO_GX_H__ */
-- 
1.5.3.7

