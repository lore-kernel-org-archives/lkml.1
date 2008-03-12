Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbYCLVo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbYCLVo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 17:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbYCLVoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 17:44:00 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:64781 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738AbYCLVny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 17:43:54 -0400
From: York Sun <yorksun@freescale.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       York Sun <yorksun@freescale.com>
Subject: [PATCH 1/2] Driver for Freescale 8610 and 5121 DIU
Date: Wed, 12 Mar 2008 16:43:42 -0500
Message-Id: <12053582231281-git-send-email-yorksun@freescale.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12053582234100-git-send-email-yorksun@freescale.com>
References: <12053582234100-git-send-email-yorksun@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following features are supported:
plane 0 works as a regular frame buffer, can be accessed by /dev/fb0
plane 1 has two AOIs (area of interest), can be accessed by /dev/fb1 and /dev/fb2
plane 2 has two AOIs, can be accessed by /dev/fb3 and /dev/fb4
Special ioctls support AOIs

All /dev/fb* can be used as regular frame buffer devices, except hardware change can
only be made through /dev/fb0. Changing pixel clock has no effect on other fbs.

Limitation of usage of AOIs:
AOIs on the same plane can not be horizonally overlapped
AOIs have horizonal order, i.e. AOI0 should be always on top of AOI1
AOIs can not beyond phisical display area. Application should check AOI geometry
before changing physical resolution on /dev/fb0

required command line parameters to preallocate memory for frame buffer
diufb=15M

optional command line parameters to set modes and monitor
video=fslfb:[resolution][,bpp][,monitor]
Syntax:

Resolution
xres x yres-bpp@refresh_rate, the -bpp and @refresh_rate are optional
eg, 1024x768, 1280x1024, 1280x1024-32, 1280x1024@60, 1280x1024-32@60, 1280x480-32@60

Bpp
bpp=32, bpp=24, or bpp=16

Monitor
monitor=0, monitor=1, monitor=2
0 is DVI
1 is Single link LVDS
2 is Double link LVDS

Note: switching monitor is a board feather, not DIU feather. MPC8610HPCD has three
monitor ports to swtich to. MPC5121ADS doesn't have additional monitor port. So switching
monirot port for MPC5121ADS has no effect.

Signed-off-by: York Sun <yorksun@freescale.com>
---

This patch is targeting 2.6.26, adding new feature.

 Documentation/powerpc/booting-without-of.txt |   34 +
 arch/powerpc/boot/dts/mpc8610_hpcd.dts       |   13 +
 drivers/video/Kconfig                        |   10 +
 drivers/video/Makefile                       |    1 +
 drivers/video/fsl-diu-fb.c                   | 1634 ++++++++++++++++++++++++++
 drivers/video/fsl-diu-fb.h                   |  388 ++++++
 6 files changed, 2080 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/fsl-diu-fb.c
 create mode 100644 drivers/video/fsl-diu-fb.h

diff --git a/Documentation/powerpc/booting-without-of.txt b/Documentation/powerpc/booting-without-of.txt
index 7b4e8a7..f7ae14a 100644
--- a/Documentation/powerpc/booting-without-of.txt
+++ b/Documentation/powerpc/booting-without-of.txt
@@ -2816,6 +2816,40 @@ platforms are moved over to use the flattened-device-tree model.
 		   big-endian;
 	   };
 
+    r) Freescale Display Interface Unit
+
+    The Freescale DIU is a LCD controller, with proper hardware, it can also
+    drive DVI monitors.
+
+    Required properties:
+    - compatible : should be "fsl-diu".
+    - reg : should contain at least address and length of the DIU register
+      set.
+    - Interrupts : one DIU interrupt should be describe here.
+
+    Example (MPC8610HPCD)
+	diu@2c000 {
+		device_type = "lcd";
+		compatible = "fsl-diu";
+		reg = <0x2c000 100>;
+		interrupts = <72 2>;
+		interrupt-parent = <&mpic>;
+	};
+
+    s) Freescale on board FPGA
+
+    This is the memory-mapped registers for on board FPGA.
+
+    Required properities:
+    - compatible : should be "fsl,fpga-pixis".
+    - reg : should contain the address and the lenght of the FPPGA register
+      set.
+
+    Example (MPC8610HPCD)
+	fpga {
+		compatible = "fsl,fpga-pixis";
+		reg = <0xe8000000 20>;
+	};
 
    More devices will be defined as this spec matures.
 
diff --git a/arch/powerpc/boot/dts/mpc8610_hpcd.dts b/arch/powerpc/boot/dts/mpc8610_hpcd.dts
index 16c947b..78c67ee 100644
--- a/arch/powerpc/boot/dts/mpc8610_hpcd.dts
+++ b/arch/powerpc/boot/dts/mpc8610_hpcd.dts
@@ -45,6 +45,11 @@
 		reg = <0x00000000 0x20000000>;	// 512M at 0x0
 	};
 
+	fpga {
+		compatible = "fsl,fpga-pixis";
+		reg = <0xe8000000 20>;		// pixis at 0xe8000000
+	};
+
 	soc@e0000000 {
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -104,6 +109,14 @@
 			interrupt-parent = <&mpic>;
 		};
 
+		diu@2c000 {
+			device_type = "lcd";
+			compatible = "fsl-diu";
+			reg = <0x2c000 100>;
+			interrupts = <72 2>;
+			interrupt-parent = <&mpic>;
+		};
+
 		mpic: interrupt-controller@40000 {
 			clock-frequency = <0>;
 			interrupt-controller;
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 758435f..8923327 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -1766,6 +1766,16 @@ config FB_MBX_DEBUG
 
          If unsure, say N.
 
+config FB_FSL_DIU
+	tristate "Freescale MPC8610/MPC5121 DIU framebuffer support"
+	depends on FB && (MPC8610 || MPC5121)
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select PPC_LIB_RHEAP
+	---help---
+	  Framebuffer driver for the MPC8610/MPC5121 chip from Freescale
+
 config FB_W100
 	tristate "W100 frame buffer support"
 	depends on FB && PXA_SHARPSL
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index 83e02b3..fb09b5e 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -113,6 +113,7 @@ obj-$(CONFIG_FB_PS3)		  += ps3fb.o
 obj-$(CONFIG_FB_SM501)            += sm501fb.o
 obj-$(CONFIG_FB_XILINX)           += xilinxfb.o
 obj-$(CONFIG_FB_OMAP)             += omap/
+obj-$(CONFIG_FB_FSL_DIU)	  += fsl-diu-fb.o
 
 # Platform or fallback drivers go here
 obj-$(CONFIG_FB_UVESA)            += uvesafb.o
diff --git a/drivers/video/fsl-diu-fb.c b/drivers/video/fsl-diu-fb.c
new file mode 100644
index 0000000..4dd1990
--- /dev/null
+++ b/drivers/video/fsl-diu-fb.c
@@ -0,0 +1,1634 @@
+/*
+ * Copyright 2007 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ *  Freescale DIU Frame Buffer device driver
+ *
+ *  Authors: Hongjun Chen <hong-jun.chen@freescale.com>
+ *           Paul Widmer <paul.widmer@freescale.com>
+ *           Srikanth Srinivasan <srikanth.srinivasan@freescale.com>
+ *           York Sun <yorksun@freescale.com>
+ *  Copyright (C) Freescale Semicondutor, Inc. 2007. All rights reserved.
+ *
+ *   Based on imxfb.c Copyright (C) 2004 S.Hauer, Pengutronix
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/fb.h>
+#include <linux/init.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/clk.h>
+#include <asm/uaccess.h>
+
+#include <asm/of_platform.h>
+
+#include <sysdev/fsl_soc.h>
+#undef DEBUG
+#include "fsl-diu-fb.h"
+
+static int irq;
+static char *fb_mode = "1024x768-32@60";
+static int fb_enabled;
+static unsigned long default_bpp = 32;
+static ATOMIC_NOTIFIER_HEAD(fsl_diu_notifier_list);
+static int monitor_port;
+static struct diu_ad *dummy_ad;
+void *dummy_aoi_virt;
+
+#if defined(CONFIG_NOT_COHERENT_CACHE)
+unsigned int *coherence_data;
+unsigned long *coherence_data_phy;
+#endif
+
+static DEFINE_SPINLOCK(diu_lock);
+
+struct mfb_info {
+	int index;
+	int type;
+	char *id;
+	int registered;
+	int blank;
+	unsigned long pseudo_palette[16];
+	struct diu_ad *ad;
+	int cursor_reset;
+	unsigned char g_alpha;
+	unsigned int count;
+	int x_aoi_d;		/* aoi display x offset to physical screen */
+	int y_aoi_d;		/* aoi display y offset to physical screen */
+};
+
+
+struct mfb_info mfbi_p0 = {
+	.index = 0,
+	.type = MFB_TYPE_OUTPUT,
+	.id = "Panel0",
+	.registered = 0,
+	.count = 0,
+	.x_aoi_d = 0,
+	.y_aoi_d = 0,
+};
+
+struct mfb_info mfbi_p1_0 = {
+	.index = 1,
+	.type = MFB_TYPE_OUTPUT,
+	.id = "Panel1 AOI0",
+	.registered = 0,
+	.g_alpha = 0xff,
+	.count = 0,
+	.x_aoi_d = 0,
+	.y_aoi_d = 0,
+};
+
+struct mfb_info mfbi_p1_1 = {
+	.index = 2,
+	.type = MFB_TYPE_OUTPUT,
+	.id = "Panel1 AOI1",
+	.registered = 0,
+	.g_alpha = 0xff,
+	.count = 0,
+	.x_aoi_d = 0,
+	.y_aoi_d = 480,
+};
+
+struct mfb_info mfbi_p2_0 = {
+	.index = 3,
+	.type = MFB_TYPE_OUTPUT,
+	.id = "Panel2 AOI0",
+	.registered = 0,
+	.g_alpha = 0xff,
+	.count = 0,
+	.x_aoi_d = 640,
+	.y_aoi_d = 0,
+};
+
+struct mfb_info mfbi_p2_1 = {
+	.index = 4,
+	.type = MFB_TYPE_OUTPUT,
+	.id = "Panel2 AOI1",
+	.registered = 0,
+	.g_alpha = 0xff,
+	.count = 0,
+	.x_aoi_d = 640,
+	.y_aoi_d = 480,
+};
+
+static struct diu_hw dr = {
+	.mode = MFB_MODE1,
+	.reg_lock = __SPIN_LOCK_UNLOCKED(old_style_spin_init),
+};
+
+struct diu_pool pool;
+
+static struct fb_info fsl_diu_info[] = {
+	{.par = &mfbi_p0},
+	{.par = &mfbi_p1_0},
+	{.par = &mfbi_p1_1},
+	{.par = &mfbi_p2_0},
+	{.par = &mfbi_p2_1},
+};
+
+static void write_reg(u32 *reg, u32 value)
+{
+	unsigned long flag;
+
+	spin_lock_irqsave(&dr.reg_lock, flag);
+	*reg = value;
+	spin_unlock_irqrestore(&dr.reg_lock, flag);
+}
+
+static u32 read_reg(u32 *reg)
+{
+	u32 value;
+	unsigned long flag;
+
+	spin_lock_irqsave(&dr.reg_lock, flag);
+	value = *reg;
+	spin_unlock_irqrestore(&dr.reg_lock, flag);
+	return value;
+}
+
+static int fsl_diu_enable_panel(struct fb_info *info)
+{
+	struct mfb_info *pmfbi, *cmfbi, *mfbi = info->par;
+	struct diu *hw = dr.diu_reg;
+	struct diu_ad *ad = mfbi->ad;
+	int res = 0;
+
+	DPRINTK("Entered: enable_panel index %d\n", mfbi->index);
+	if (mfbi->type != MFB_TYPE_OFF) {
+		switch (mfbi->index) {
+		case 0:				/* plane 0 */
+			if (hw->desc[0] != ad->paddr)
+				write_reg(&(hw->desc[0]), ad->paddr);
+			break;
+		case 1:				/* plane 1 AOI 0 */
+			cmfbi = fsl_diu_info[2].par;
+			if (hw->desc[1] != ad->paddr) {	/* AOI0 closed */
+				if (cmfbi->count > 0)	/* AOI1 open */
+					ad->next_ad =
+						cpu_to_le32(cmfbi->ad->paddr);
+				else
+					ad->next_ad = 0;
+				write_reg(&(hw->desc[1]), ad->paddr);
+			}
+			break;
+		case 3:				/* plane 2 AOI 0 */
+			cmfbi = fsl_diu_info[4].par;
+			if (hw->desc[2] != ad->paddr) {	/* AOI0 closed */
+				if (cmfbi->count > 0)	/* AOI1 open */
+					ad->next_ad =
+						cpu_to_le32(cmfbi->ad->paddr);
+				else
+					ad->next_ad = 0;
+				write_reg(&(hw->desc[2]), ad->paddr);
+			}
+			break;
+		case 2:				/* plane 1 AOI 1 */
+			pmfbi = fsl_diu_info[1].par;
+			ad->next_ad = 0;
+			if (hw->desc[1] == dummy_ad->paddr) /* AOI0 closed */
+				write_reg(&(hw->desc[1]), ad->paddr);
+			else					/* AOI0 open */
+				pmfbi->ad->next_ad = cpu_to_le32(ad->paddr);
+			break;
+		case 4:				/* plane 2 AOI 1 */
+			pmfbi = fsl_diu_info[3].par;
+			ad->next_ad = 0;
+			if (hw->desc[2] == dummy_ad->paddr) /* AOI0 closed */
+				write_reg(&(hw->desc[2]), ad->paddr);
+			else				/* AOI0 was open */
+				pmfbi->ad->next_ad = cpu_to_le32(ad->paddr);
+			break;
+		default:
+			res = -EINVAL;
+			break;
+		}
+	} else
+		res = -EINVAL;
+	return res;
+}
+
+static int fsl_diu_disable_panel(struct fb_info *info)
+{
+	struct mfb_info *pmfbi, *cmfbi, *mfbi = info->par;
+	struct diu *hw = dr.diu_reg;
+	struct diu_ad *ad = mfbi->ad;
+	int res = 0;
+
+	DPRINTK("Entered: disable_panel\n");
+	switch (mfbi->index) {
+	case 0:					/* plane 0 */
+		if (hw->desc[0] != dummy_ad->paddr)
+			write_reg(&(hw->desc[0]), dummy_ad->paddr);
+		break;
+	case 1:					/* plane 1 AOI 0 */
+		cmfbi = fsl_diu_info[2].par;
+		if (cmfbi->count > 0)	/* AOI1 is open */
+			write_reg(&(hw->desc[1]), cmfbi->ad->paddr);
+					/* move AOI1 to the first */
+		else			/* AOI1 was closed */
+			write_reg(&(hw->desc[1]), dummy_ad->paddr);
+					/* close AOI 0 */
+		break;
+	case 3:					/* plane 2 AOI 0 */
+		cmfbi = fsl_diu_info[4].par;
+		if (cmfbi->count > 0)	/* AOI1 is open */
+			write_reg(&(hw->desc[2]), cmfbi->ad->paddr);
+					/* move AOI1 to the first */
+		else			/* AOI1 was closed */
+			write_reg(&(hw->desc[2]), dummy_ad->paddr);
+					/* close AOI 0 */
+		break;
+	case 2:					/* plane 1 AOI 1 */
+		pmfbi = fsl_diu_info[1].par;
+		if (hw->desc[1] != ad->paddr) {
+					/* AOI1 is not the first in the chain */
+			if (pmfbi->count > 0)
+					/* AOI0 is open, must be the first */
+				pmfbi->ad->next_ad = 0;
+		} else			/* AOI1 is the first in the chain */
+			write_reg(&(hw->desc[1]), dummy_ad->paddr);
+					/* close AOI 1 */
+		break;
+	case 4:					/* plane 2 AOI 1 */
+		pmfbi = fsl_diu_info[3].par;
+		if (hw->desc[2] != ad->paddr) {
+				/* AOI1 is not the first in the chain */
+			if (pmfbi->count > 0)
+				/* AOI0 is open, must be the first */
+				pmfbi->ad->next_ad = 0;
+		} else		/* AOI1 is the first in the chain */
+			write_reg(&(hw->desc[2]), dummy_ad->paddr);
+				/* close AOI 1 */
+		break;
+	default:
+		res = -EINVAL;
+		break;
+	}
+
+	return res;
+}
+
+static void enable_lcdc(struct fb_info *info)
+{
+	struct diu *hw = dr.diu_reg;
+
+	DPRINTK("Entered: enable_lcdc\n");
+	if (!fb_enabled) {
+		write_reg(&(hw->diu_mode), dr.mode);
+		fb_enabled++;
+	}
+}
+
+static void disable_lcdc(struct fb_info *info)
+{
+	struct diu *hw = dr.diu_reg;
+
+	DPRINTK("Entered: disable_lcdc\n");
+	if (fb_enabled) {
+		write_reg(&(hw->diu_mode), 0);
+		fb_enabled = 0;
+	}
+}
+
+/*
+ * Checks to see if the hardware supports the state requested by var passed
+ * in. This function does not alter the hardware state! If the var passed in
+ * is slightly off by what the hardware can support then we alter the var
+ * PASSED in to what we can do. If the hardware doesn't support mode change
+ * a -EINVAL will be returned by the upper layers.
+ */
+static int fsl_diu_check_var
+	(struct fb_var_screeninfo *var, struct fb_info *info)
+{
+	unsigned long htotal, vtotal;
+	struct mfb_info *pmfbi, *cmfbi, *mfbi = info->par;
+	int index = mfbi->index;
+
+	DPRINTK("Entered: fsl_diu_check_var\n");
+	DPRINTK("check_var xres: %d\n", var->xres);
+	DPRINTK("check_var yres: %d\n", var->yres);
+
+	if (var->xres_virtual < var->xres)
+		var->xres_virtual = var->xres;
+	if (var->yres_virtual < var->yres)
+		var->yres_virtual = var->yres;
+
+	if (var->xoffset < 0)
+		var->xoffset = 0;
+
+	if (var->yoffset < 0)
+		var->yoffset = 0;
+
+	if (var->xoffset + info->var.xres > info->var.xres_virtual)
+		var->xoffset = info->var.xres_virtual - info->var.xres;
+
+	if (var->yoffset + info->var.yres > info->var.yres_virtual)
+		var->yoffset = info->var.yres_virtual - info->var.yres;
+
+	if ((var->bits_per_pixel != 32) && (var->bits_per_pixel != 24) &&
+	    (var->bits_per_pixel != 16))
+		var->bits_per_pixel = default_bpp;
+
+	switch (var->bits_per_pixel) {
+	case 16:
+		var->red.length = 5;
+		var->red.offset = 11;
+		var->red.msb_right = 0;
+
+		var->green.length = 6;
+		var->green.offset = 5;
+		var->green.msb_right = 0;
+
+		var->blue.length = 5;
+		var->blue.offset = 0;
+		var->blue.msb_right = 0;
+
+		var->transp.length = 0;
+		var->transp.offset = 0;
+		var->transp.msb_right = 0;
+		break;
+	case 24:
+		var->red.length = 8;
+		var->red.offset = 0;
+		var->red.msb_right = 0;
+
+		var->green.length = 8;
+		var->green.offset = 8;
+		var->green.msb_right = 0;
+
+		var->blue.length = 8;
+		var->blue.offset = 16;
+		var->blue.msb_right = 0;
+
+		var->transp.length = 0;
+		var->transp.offset = 0;
+		var->transp.msb_right = 0;
+		break;
+	case 32:
+		var->red.length = 8;
+		var->red.offset = 16;
+		var->red.msb_right = 0;
+
+		var->green.length = 8;
+		var->green.offset = 8;
+		var->green.msb_right = 0;
+
+		var->blue.length = 8;
+		var->blue.offset = 0;
+		var->blue.msb_right = 0;
+
+		var->transp.length = 8;
+		var->transp.offset = 24;
+		var->transp.msb_right = 0;
+
+		break;
+	}
+	/* If the pixclock is below the minimum spec'd value then set to
+	 * refresh rate for 60Hz since this is supported by most monitors.
+	 * Refer to Documentation/fb/ for calculations.
+	 */
+	if ((var->pixclock < MIN_PIX_CLK) || (var->pixclock > MAX_PIX_CLK)) {
+		htotal = var->xres + var->right_margin + var->hsync_len +
+		    var->left_margin;
+		vtotal = var->yres + var->lower_margin + var->vsync_len +
+		    var->upper_margin;
+		var->pixclock = (vtotal * htotal * 6UL) / 100UL;
+		var->pixclock = KHZ2PICOS(var->pixclock);
+		DPRINTK("pixclock set for 60Hz refresh = %u ps\n",
+			var->pixclock);
+	}
+
+	var->height = -1;
+	var->width = -1;
+	var->grayscale = 0;
+
+	/* Copy nonstd field to/from sync for fbset usage */
+	var->sync |= var->nonstd;
+	var->nonstd |= var->sync;
+
+	/* check AOI position */
+	switch (index) {
+	case 0:
+		if (mfbi->x_aoi_d != 0)
+			mfbi->x_aoi_d = 0;
+		if (mfbi->y_aoi_d != 0)
+			mfbi->y_aoi_d = 0;
+		break;
+	case 1:			/* AOI 0 */
+	case 3:
+		cmfbi = fsl_diu_info[index+1].par;
+		if ((mfbi->x_aoi_d + var->xres) > fsl_diu_info[0].var.xres)
+			mfbi->x_aoi_d = fsl_diu_info[0].var.xres - var->xres;
+		if (mfbi->x_aoi_d < 0)
+			mfbi->x_aoi_d = 0;
+		if ((var->xres + mfbi->x_aoi_d) > fsl_diu_info[0].var.xres)
+			var->xres = fsl_diu_info[0].var.xres - mfbi->x_aoi_d;
+
+		if (cmfbi->count > 0) {		/* AOI1 is open */
+			if ((mfbi->y_aoi_d + var->yres) > cmfbi->y_aoi_d)
+				mfbi->y_aoi_d = cmfbi->y_aoi_d - var->yres;
+			if (mfbi->y_aoi_d < 0)
+				mfbi->y_aoi_d = 0;
+			if ((var->yres + mfbi->y_aoi_d) > cmfbi->y_aoi_d)
+				var->yres = cmfbi->y_aoi_d - mfbi->y_aoi_d;
+		} else {				/* AOI1 is close */
+			if ((mfbi->y_aoi_d + var->yres) >
+						fsl_diu_info[0].var.yres)
+				mfbi->y_aoi_d =
+					fsl_diu_info[0].var.yres - var->yres;
+			if (mfbi->y_aoi_d < 0)
+				mfbi->y_aoi_d = 0;
+			if ((var->yres + mfbi->y_aoi_d) >
+					fsl_diu_info[0].var.yres)
+				var->yres =
+				fsl_diu_info[0].var.yres - mfbi->y_aoi_d;
+		}
+		break;
+	case 2:			/* AOI 1 */
+	case 4:
+		pmfbi = fsl_diu_info[index-1].par;
+		if ((mfbi->x_aoi_d + var->xres) > fsl_diu_info[0].var.xres)
+			mfbi->x_aoi_d = fsl_diu_info[0].var.xres - var->xres;
+		if (mfbi->x_aoi_d < 0)
+			mfbi->x_aoi_d = 0;
+		if ((var->xres + mfbi->x_aoi_d) > fsl_diu_info[0].var.xres)
+			var->xres = fsl_diu_info[0].var.xres - mfbi->x_aoi_d;
+
+		if (pmfbi->count > 0) {		/* AOI0 is open */
+			if ((mfbi->y_aoi_d + var->yres) >
+						fsl_diu_info[0].var.yres)
+				mfbi->y_aoi_d =
+					fsl_diu_info[0].var.yres - var->yres;
+			if (mfbi->y_aoi_d <
+				(pmfbi->y_aoi_d+fsl_diu_info[index-1].var.yres))
+				mfbi->y_aoi_d =
+				pmfbi->y_aoi_d+fsl_diu_info[index-1].var.yres;
+			if ((var->yres + mfbi->y_aoi_d) >
+						fsl_diu_info[0].var.yres)
+				var->yres =  fsl_diu_info[0].var.yres
+						- mfbi->y_aoi_d;
+		} else {				/* AOI0 is close */
+			if ((mfbi->y_aoi_d + var->yres) >
+					fsl_diu_info[0].var.yres)
+				mfbi->y_aoi_d =
+					fsl_diu_info[0].var.yres - var->yres;
+			if (mfbi->y_aoi_d < 0)
+				mfbi->y_aoi_d = 0;
+			if ((var->yres + mfbi->y_aoi_d) >
+					fsl_diu_info[0].var.yres)
+				var->yres =
+				fsl_diu_info[0].var.yres - mfbi->y_aoi_d;
+		}
+		break;
+	}
+	return 0;
+}
+
+static void hide_cursor(struct fb_info *info)
+{
+	struct diu *pdiu = dr.diu_reg;
+	pdiu->cursor = 0;
+}
+
+static void show_cursor(struct fb_info *info)
+{
+	struct diu *pdiu = dr.diu_reg;
+	pdiu->cursor = pool.cursor.paddr + pool.cursor.offset;
+}
+
+/*
+ * Copies a cursor image from user space to the proper place in driver
+ * memory so that the hardware can display the cursor image *
+ */
+static void load_cursor_image(struct fb_info *info, u8 *data8,
+				     u16 bg, u16 fg, u32 w, u32 h)
+{
+	u16 *dst = (u16 *)(pool.cursor.vaddr + pool.cursor.offset);
+	int i, j;
+	u32 b;
+	u16 tmp;
+	u32 *data = (u32 *)data8;
+
+	w = (w + 1) & ~1;
+
+	for (i = 0; i < 32; i++) {
+		for (j = 0; j < 32; j++) {
+			b = *data++;
+			tmp = (b & (1 << 31)) ? b : bg;
+			*dst = cpu_to_be16(tmp);
+			dst++;
+		}
+	}
+}
+
+/*
+ * A cursor function that supports displaying a cursor image via hardware.
+ * Within the kernel, copy and invert rops are supported.  If exported
+ * to user space, only the copy rop will be supported.
+ */
+static int fsl_diu_cursor(struct fb_info *info, struct fb_cursor *cursor)
+{
+	struct mfb_info *mfbi = info->par;
+	struct diu *pdiu = dr.diu_reg;
+	u8 data[MAX_CURS * MAX_CURS/8];
+	int i, set = cursor->set;
+	u16 fg, bg;
+
+	if (cursor->image.width > MAX_CURS || cursor->image.height > MAX_CURS)
+		return -EINVAL;
+
+	hide_cursor(info);
+
+	if (mfbi->cursor_reset) {
+		set = FB_CUR_SETALL;
+		mfbi->cursor_reset = 0;
+	}
+
+	if (set & FB_CUR_SETSIZE)
+		memset_io(pool.cursor.vaddr + pool.cursor.offset,
+				0, MAX_CURS * MAX_CURS * 2);
+
+	if (set & FB_CUR_SETPOS) {
+		u32 xx, yy, temp;
+
+		yy = cursor->image.dy - info->var.yoffset;
+		xx = cursor->image.dx - info->var.xoffset;
+		temp = xx & 0xFFFF;
+		temp |= yy << 16;
+
+		write_reg(&(pdiu->curs_pos), temp);
+	}
+
+	if (set & (FB_CUR_SETSHAPE | FB_CUR_SETCMAP | FB_CUR_SETIMAGE)) {
+		u32 bg_idx = cursor->image.bg_color;
+		u32 fg_idx = cursor->image.fg_color;
+		u32 s_pitch = (cursor->image.width+7) >> 3;
+		u32 d_pitch = MAX_CURS/8;
+		u8 *dat = (u8 *) cursor->image.data;
+		u8 *msk = (u8 *) cursor->mask;
+		u8 *src;
+
+		src = kmalloc(s_pitch * cursor->image.height, GFP_ATOMIC);
+
+		switch (cursor->rop) {
+		case ROP_XOR:
+			for (i = 0; i < s_pitch * cursor->image.height; i++)
+				src[i] = dat[i] ^ msk[i];
+			break;
+		case ROP_COPY:
+		default:
+			for (i = 0; i < s_pitch * cursor->image.height; i++)
+				src[i] = dat[i] & msk[i];
+			break;
+		}
+
+		fb_pad_aligned_buffer(data, d_pitch, src, s_pitch,
+						cursor->image.height);
+		bg = ((info->cmap.red[bg_idx] & 0xe0) << 10) |
+			((info->cmap.green[bg_idx] & 0xe0) << 5) |
+			((info->cmap.blue[bg_idx] & 0xe0) >> 5) |
+			1 << 15;
+
+		fg = ((info->cmap.red[fg_idx] & 0xe0) << 10) |
+			((info->cmap.green[fg_idx] & 0xe0) << 5) |
+			((info->cmap.blue[fg_idx] & 0xe0) >> 5) |
+			1 << 15;
+
+		load_cursor_image(info, data, bg, fg,
+					 cursor->image.width,
+					 cursor->image.height);
+		kfree(src);
+	}
+
+	if (cursor->enable)
+		show_cursor(info);
+
+	return 0;
+}
+
+static void set_fix(struct fb_info *info)
+{
+	struct fb_fix_screeninfo *fix = &info->fix;
+	struct fb_var_screeninfo *var = &info->var;
+	struct mfb_info *mfbi = info->par;
+
+	DPRINTK("Entered: set_fix\n");
+	strncpy(fix->id, mfbi->id, strlen(mfbi->id));
+	fix->line_length = var->xres_virtual * var->bits_per_pixel / 8;
+	fix->type = FB_TYPE_PACKED_PIXELS;
+	fix->accel = FB_ACCEL_NONE;
+	fix->visual = FB_VISUAL_TRUECOLOR;
+	fix->xpanstep = 1;
+	fix->ypanstep = 1;
+}
+
+static void update_lcdc(struct fb_info *info)
+{
+	struct fb_var_screeninfo *var = &info->var;
+	struct mfb_info *mfbi = info->par;
+	struct diu *hw;
+	int i, j;
+	char __iomem *cursor_base, *gamma_table_base;
+
+	u32 temp;
+
+	DPRINTK("Entered: update_lcdc\n");
+
+	spin_lock_init(&dr.reg_lock);
+	hw = dr.diu_reg;
+
+	if (mfbi->type == MFB_TYPE_OFF) {
+		fsl_diu_disable_panel(info);
+		return;
+	}
+
+	platform_set_monitor_port(monitor_port);
+	gamma_table_base = pool.gamma.vaddr;
+	cursor_base = pool.cursor.vaddr;
+	/* Prep for DIU init  - gamma table, cursor table */
+
+	for (i = 0; i <= 2; i++)
+	   for (j = 0; j <= 255; j++)
+	      *gamma_table_base++ = j;
+
+	platform_set_gamma_table(monitor_port, pool.gamma.vaddr);
+
+	DPRINTK("update-lcdc: HW - %p\n Disabling DIU\n", hw);
+	disable_lcdc(info);
+
+	/* Program DIU registers */
+
+	write_reg(&(hw->gamma), pool.gamma.paddr);
+	write_reg(&(hw->cursor), pool.cursor.paddr);
+
+	write_reg(&(hw->bgnd), 0x007F7F7F); 	/* BGND */
+	write_reg(&(hw->bgnd_wb), 0); 		/* BGND_WB */
+	write_reg(&(hw->disp_size), (var->yres << 16 | var->xres));
+						/* DISP SIZE */
+	DPRINTK("DIU xres: %d\n", var->xres);
+	DPRINTK("DIU yres: %d\n", var->yres);
+
+	write_reg(&(hw->wb_size), 0); /* WB SIZE */
+	write_reg(&(hw->wb_mem_addr), 0); /* WB MEM ADDR */
+
+	/* Horizontal and vertical configuration register */
+	temp = var->left_margin << 22 | /* BP_H */
+	       var->hsync_len << 11 |   /* PW_H */
+	       var->right_margin;       /* FP_H */
+
+	write_reg(&(hw->hsyn_para), temp);
+
+	temp = var->upper_margin << 22 | /* BP_V */
+	       var->vsync_len << 11 |    /* PW_V  */
+	       var->lower_margin;        /* FP_V  */
+
+	write_reg(&(hw->vsyn_para), temp);
+
+	DPRINTK("DIU right_margin - %d\n", var->right_margin);
+	DPRINTK("DIU left_margin - %d\n", var->left_margin);
+	DPRINTK("DIU hsync_len - %d\n", var->hsync_len);
+	DPRINTK("DIU upper_margin - %d\n", var->upper_margin);
+	DPRINTK("DIU lower_margin - %d\n", var->lower_margin);
+	DPRINTK("DIU vsync_len - %d\n", var->vsync_len);
+	DPRINTK("DIU HSYNC - 0x%08x\n", hw->hsyn_para);
+	DPRINTK("DIU VSYNC - 0x%08x\n", hw->vsyn_para);
+
+	platform_set_pixel_clock(var->pixclock);
+
+	write_reg(&(hw->syn_pol), 0);	/* SYNC SIGNALS POLARITY */
+	write_reg(&(hw->thresholds), 0x00037800); /* The Thresholds */
+	write_reg(&(hw->int_status), 0);	/* INTERRUPT STATUS */
+	write_reg(&(hw->plut), 0x01F5F666);
+
+	/* Enable the DIU */
+	enable_lcdc(info);
+}
+
+static int map_video_memory(struct fb_info *info)
+{
+	DPRINTK("Entered: map_video_memory\n");
+	DPRINTK("info->var.xres_virtual = %d\n", info->var.xres_virtual);
+	DPRINTK("info->var.yres_virtual = %d\n", info->var.yres_virtual);
+	DPRINTK("info->fix.line_length  = %d\n", info->fix.line_length);
+
+	info->fix.smem_len = info->fix.line_length * info->var.yres_virtual;
+	DPRINTK("MAP_VIDEO_MEMORY: smem_len = %d\n", info->fix.smem_len);
+	info->screen_base = fsl_diu_alloc(info->fix.smem_len,
+					&info->fix.smem_start);
+	if (info->screen_base == 0) {
+		printk(KERN_ERR "Unable to allocate fb memory\n");
+		return -EBUSY;
+	}
+
+	info->screen_size = info->fix.smem_len;
+
+	DPRINTK("Allocated fb @ paddr=0x%08lx, size=%d.\n",
+				info->fix.smem_start,
+		info->fix.smem_len);
+	DPRINTK("screen base 0x%08lx\n", (long unsigned int) info->screen_base);
+
+	return 0;
+}
+
+static void unmap_video_memory(struct fb_info *info)
+{
+	DPRINTK("Entered: unmap_video_memory\n");
+	fsl_diu_free(info->screen_base, info->fix.smem_len);
+	info->screen_base = 0;
+	info->fix.smem_start = 0;
+	info->fix.smem_len = 0;
+}
+
+/*
+ * Using the fb_var_screeninfo in fb_info we set the resolution of this
+ * particular framebuffer. This function alters the fb_fix_screeninfo stored
+ * in fb_info. It does not alter var in fb_info since we are using that
+ * data. This means we depend on the data in var inside fb_info to be
+ * supported by the hardware. fsl_diu_check_var is always called before
+ * fsl_diu_set_par to ensure this.
+ */
+static int fsl_diu_set_par(struct fb_info *info)
+{
+	unsigned long len;
+	struct fb_var_screeninfo *var = &info->var;
+	struct mfb_info *mfbi = info->par;
+	struct diu_ad *ad = mfbi->ad;
+	struct diu *hw;
+
+	DPRINTK("Entered: fsl_diu_set_par\n");
+	hw = dr.diu_reg;
+
+	set_fix(info);
+	mfbi->cursor_reset = 1;
+
+	len = info->var.yres_virtual * info->fix.line_length;
+	/* Alloc & dealloc each time resolution/bpp change */
+	if (len != info->fix.smem_len) {
+		if (info->fix.smem_start)
+			unmap_video_memory(info);
+		DPRINTK("SET PAR: smem_len = %d\n", info->fix.smem_len);
+
+		/* Memory allocation for framebuffer */
+		if (map_video_memory(info)) {
+			printk(KERN_ERR "Unable to allocate fb memory 1\n");
+			return -ENOMEM;
+		}
+	}
+
+	ad->pix_fmt =
+		platform_get_pixel_format(var->bits_per_pixel, monitor_port);
+	ad->addr    = cpu_to_le32(info->fix.smem_start);
+	ad->src_size_g_alpha = cpu_to_le32((var->yres << 12) |
+				var->xres) | mfbi->g_alpha;
+	/* fix me. AOI should not be greater than display size */
+	ad->aoi_size 	= cpu_to_le32((var->yres << 16) | var->xres);
+	ad->offset_xyi = 0;
+	ad->offset_xyd = cpu_to_le32((mfbi->y_aoi_d << 16) | mfbi->x_aoi_d);
+
+	/* Disable chroma keying function */
+	ad->ckmax_r = 0;
+	ad->ckmax_g = 0;
+	ad->ckmax_b = 0;
+
+	ad->ckmin_r = 255;
+	ad->ckmin_g = 255;
+	ad->ckmin_b = 255;
+
+	if (mfbi->index == 0)
+		update_lcdc(info);
+	return 0;
+}
+
+/*
+ * Set a single color register. The values supplied have a 16 bit magnitude
+ * which needs to be scaled in this function for the hardware. Things to take
+ * into consideration are how many color registers, if any, are supported with
+ * the current color visual. With truecolor mode no color palettes are
+ * supported. Here a psuedo palette is created which we store the value in
+ * pseudo_palette in struct fb_info. For pseudocolor mode we have a limited
+ * color palette.
+ */
+static int fsl_diu_setcolreg(unsigned regno, unsigned red, unsigned green,
+			   unsigned blue, unsigned transp, struct fb_info *info)
+{
+	int ret = 1;
+
+	/*
+	 * If greyscale is true, then we convert the RGB value
+	 * to greyscale no matter what visual we are using.
+	 */
+	if (info->var.grayscale)
+		red = green = blue = (19595 * red + 38470 * green +
+				      7471 * blue) >> 16;
+	switch (info->fix.visual) {
+	case FB_VISUAL_TRUECOLOR:
+		/*
+		 * 16-bit True Colour.  We encode the RGB value
+		 * according to the RGB bitfield information.
+		 */
+		if (regno < 16) {
+			u32 *pal = info->pseudo_palette;
+			u32 v;
+
+#define CNVT_TOHW(val, width) ((((val)<<(width))+0x7FFF-(val))>>16)
+			red = CNVT_TOHW(red, info->var.red.length);
+			green = CNVT_TOHW(green, info->var.green.length);
+			blue = CNVT_TOHW(blue, info->var.blue.length);
+			transp = CNVT_TOHW(transp, info->var.transp.length);
+#undef CNVT_TOHW
+			v = (red << info->var.red.offset) |
+			    (green << info->var.green.offset) |
+			    (blue << info->var.blue.offset) |
+			    (transp << info->var.transp.offset);
+
+			pal[regno] = v;
+			ret = 0;
+		}
+		break;
+	case FB_VISUAL_STATIC_PSEUDOCOLOR:
+	case FB_VISUAL_PSEUDOCOLOR:
+		break;
+	}
+
+	return ret;
+}
+
+/*
+ * Pan (or wrap, depending on the `vmode' field) the display using the
+ * 'xoffset' and 'yoffset' fields of the 'var' structure. If the values
+ * don't fit, return -EINVAL.
+ */
+static int fsl_diu_pan_display(struct fb_var_screeninfo *var,
+			     struct fb_info *info)
+{
+	DPRINTK("Entered: fsl_diu_pan_display\n");
+	if ((info->var.xoffset == var->xoffset) &&
+	    (info->var.yoffset == var->yoffset))
+		return 0;	/* No change, do nothing */
+
+	if (var->xoffset < 0 || var->yoffset < 0
+	    || var->xoffset + info->var.xres > info->var.xres_virtual
+	    || var->yoffset + info->var.yres > info->var.yres_virtual)
+		return -EINVAL;
+
+	info->var.xoffset = var->xoffset;
+	info->var.yoffset = var->yoffset;
+
+	if (var->vmode & FB_VMODE_YWRAP)
+		info->var.vmode |= FB_VMODE_YWRAP;
+	else
+		info->var.vmode &= ~FB_VMODE_YWRAP;
+
+	return 0;
+}
+
+/*
+ * Blank the screen if blank_mode != 0, else unblank. Return 0 if blanking
+ * succeeded, != 0 if un-/blanking failed.
+ * blank_mode == 2: suspend vsync
+ * blank_mode == 3: suspend hsync
+ * blank_mode == 4: powerdown
+ */
+static int fsl_diu_blank(int blank_mode, struct fb_info *info)
+{
+	struct mfb_info *mfbi = info->par;
+
+	DPRINTK("Entered: fsl_diu_blank\n");
+	mfbi->blank = blank_mode;
+
+	switch (blank_mode) {
+	case FB_BLANK_VSYNC_SUSPEND:
+	case FB_BLANK_HSYNC_SUSPEND:
+	/* FIXME: fixes to enable_panel and enable lcdc needed */
+	case FB_BLANK_NORMAL:
+	/*	fsl_diu_disable_panel(info);*/
+		break;
+	case FB_BLANK_POWERDOWN:
+	/*	disable_lcdc(info);	*/
+		break;
+	case FB_BLANK_UNBLANK:
+	/*	fsl_diu_enable_panel(info);*/
+		break;
+	}
+
+	return 0;
+}
+
+static int fsl_diu_ioctl(struct fb_info *info, unsigned int cmd,
+		       unsigned long arg)
+{
+	struct mfb_info *mfbi = info->par;
+	struct diu_ad *ad = mfbi->ad;
+	struct mfb_chroma_key ck;
+	unsigned char global_alpha;
+	struct aoi_display_offset aoi_d;
+	__u32 pix_fmt;
+
+	DPRINTK("Entered: fsl_diu_ioctl\n");
+	switch (cmd) {
+	case MFB_SET_PIXFMT:
+		if (!arg)
+			return -EINVAL;
+		if (copy_from_user((void *)&pix_fmt, (void *)arg,
+				sizeof(pix_fmt)))
+			return -EFAULT;
+		ad->pix_fmt = pix_fmt;
+		DPRINTK("Set pixel format to 0x%08x\n", ad->pix_fmt);
+		break;
+	case MFB_GET_PIXFMT:
+		if (!arg)
+			return -EINVAL;
+		pix_fmt = ad->pix_fmt;
+		if (copy_to_user((void *)arg, (void *)&pix_fmt,
+				sizeof(pix_fmt)))
+			return -EFAULT;
+		DPRINTK("get pixel format 0x%08x\n", ad->pix_fmt);
+		break;
+	case MFB_SET_AOID:
+		if (!arg)
+			return -EINVAL;
+		if (copy_from_user((void *)&aoi_d, (void *)arg, sizeof(aoi_d)))
+			return -EFAULT;
+		mfbi->x_aoi_d = aoi_d.x_aoi_d;
+		mfbi->y_aoi_d = aoi_d.y_aoi_d;
+		DPRINTK("set AOI display offset of index %d to (%d,%d)\n",
+				 mfbi->index, aoi_d.x_aoi_d, aoi_d.y_aoi_d);
+		fsl_diu_check_var(&info->var, info);
+		fsl_diu_set_par(info);
+		break;
+	case MFB_GET_AOID:
+		if (!arg)
+			return -EINVAL;
+		aoi_d.x_aoi_d = mfbi->x_aoi_d;
+		aoi_d.y_aoi_d = mfbi->y_aoi_d;
+		if (copy_to_user((void *)arg, (void *)&aoi_d, sizeof(aoi_d)))
+			return -EFAULT;
+		DPRINTK("get AOI display offset of index %d (%d,%d)\n",
+				mfbi->index, aoi_d.x_aoi_d, aoi_d.y_aoi_d);
+		break;
+	case MFB_GET_ALPHA:
+		if (!arg)
+			return -EINVAL;
+		global_alpha = mfbi->g_alpha;
+		if (copy_to_user((void *)arg, (void *)&global_alpha,
+						sizeof(global_alpha)))
+			return -EFAULT;
+		DPRINTK("get global alpha of index %d\n", mfbi->index);
+		break;
+	case MFB_SET_ALPHA:
+		if (!arg)
+			return -EINVAL;
+
+		/* set panel information */
+		if (copy_from_user((void *)&global_alpha, (void *)arg,
+			sizeof(global_alpha)))
+			return -EFAULT;
+		ad->src_size_g_alpha = (ad->src_size_g_alpha & (~0xff)) |
+							(global_alpha & 0xff);
+		mfbi->g_alpha = global_alpha;
+		DPRINTK("set global alpha for index %d\n", mfbi->index);
+		break;
+	case MFB_SET_CHROMA_KEY:
+		if (!arg)
+			return -EINVAL;
+
+		/* set panel winformation */
+		if (copy_from_user((void *)&ck, (void *)arg, sizeof(ck)))
+			return -EFAULT;
+
+		if (ck.enable &&
+		   (ck.red_max < ck.red_min ||
+		    ck.green_max < ck.green_min ||
+		    ck.blue_max < ck.blue_min))
+			return -EINVAL;
+
+		if (!ck.enable) {
+			ad->ckmax_r = 0;
+			ad->ckmax_g = 0;
+			ad->ckmax_b = 0;
+			ad->ckmin_r = 255;
+			ad->ckmin_g = 255;
+			ad->ckmin_b = 255;
+		} else {
+			ad->ckmax_r = ck.red_max;
+			ad->ckmax_g = ck.green_max;
+			ad->ckmax_b = ck.blue_max;
+			ad->ckmin_r = ck.red_min;
+			ad->ckmin_g = ck.green_min;
+			ad->ckmin_b = ck.blue_min;
+		}
+		DPRINTK("set chroma key\n");
+		break;
+	case FBIOGET_GWINFO:
+		if (mfbi->type == MFB_TYPE_OFF)
+			return -ENODEV;
+
+		if (!arg)
+			return -EINVAL;
+
+		/* get graphic window information */
+		if (copy_to_user((void *)arg, (void *)ad, sizeof(*ad)))
+			return -EFAULT;
+		break;
+	case FBIOGET_HWCINFO:
+		DPRINTK("FBIOGET_HWCINFO:0x%08x\n", FBIOGET_HWCINFO);
+		break;
+	case FBIOPUT_MODEINFO:
+		DPRINTK("FBIOPUT_MODEINFO:0x%08x\n", FBIOPUT_MODEINFO);
+		break;
+	case FBIOGET_DISPINFO:
+		DPRINTK("FBIOGET_DISPINFO:0x%08x\n", FBIOGET_DISPINFO);
+		break;
+
+	default:
+		printk(KERN_ERR "Unknown ioctl command (0x%08X)\n", cmd);
+		return 0;
+	}
+
+	return 0;
+}
+
+/* turn on fb if count == 1
+ */
+static int fsl_diu_open(struct fb_info *info, int user)
+{
+	struct mfb_info *mfbi = info->par;
+	int res = 0;
+
+	spin_lock(&diu_lock);
+	mfbi->count++;
+	if (mfbi->count == 1) {
+		DPRINTK("open plane index %d\n", mfbi->index);
+		fsl_diu_check_var(&info->var, info);
+		fsl_diu_set_par(info);
+		res = fsl_diu_enable_panel(info);
+		if (res < 0)
+			mfbi->count--;
+	}
+
+	spin_unlock(&diu_lock);
+	return res;
+}
+
+/* turn off fb if count == 0
+ */
+static int fsl_diu_release(struct fb_info *info, int user)
+{
+	struct mfb_info *mfbi = info->par;
+	int res = 0;
+
+	spin_lock(&diu_lock);
+	mfbi->count--;
+	if (mfbi->count == 0) {
+		DPRINTK("release plane index %d\n", mfbi->index);
+		res = fsl_diu_disable_panel(info);
+		if (res < 0)
+			mfbi->count++;
+	}
+	spin_unlock(&diu_lock);
+	return res;
+}
+
+static struct fb_ops fsl_diu_ops = {
+	.owner = THIS_MODULE,
+	.fb_check_var = fsl_diu_check_var,
+	.fb_set_par = fsl_diu_set_par,
+	.fb_setcolreg = fsl_diu_setcolreg,
+	.fb_blank = fsl_diu_blank,
+	.fb_pan_display = fsl_diu_pan_display,
+	.fb_fillrect = cfb_fillrect,
+	.fb_copyarea = cfb_copyarea,
+	.fb_imageblit = cfb_imageblit,
+	.fb_ioctl = fsl_diu_ioctl,
+	.fb_open = fsl_diu_open,
+	.fb_release = fsl_diu_release,
+};
+
+static int init_fbinfo(struct fb_info *info,
+			       struct platform_device *pdev)
+{
+	struct mfb_info *mfbi = info->par;
+
+	DPRINTK("Entered: init_fbinfo\n");
+	info->device = NULL;
+	info->var.activate = FB_ACTIVATE_NOW;
+	info->fbops = &fsl_diu_ops;
+	info->flags = FBINFO_FLAG_DEFAULT;
+	info->pseudo_palette = &mfbi->pseudo_palette;
+
+	/* Allocate colormap */
+	fb_alloc_cmap(&info->cmap, 16, 0);
+	return 0;
+}
+
+static int install_fb(struct fb_info *info,
+			      struct platform_device *pdev)
+{
+	int rc;
+	struct mfb_info *mfbi = info->par;
+	const char *aoi_mode, *init_aoi_mode = "320x240";
+
+	DPRINTK("Entered: install_fb\n");
+	if (init_fbinfo(info, pdev))
+		return -EINVAL;
+
+	if (mfbi->index == 0)	/* plane 0 */
+		aoi_mode = fb_mode;
+	else
+		aoi_mode = init_aoi_mode;
+	DPRINTK("mode used = %s\n", aoi_mode);
+	rc = fb_find_mode(&info->var, info, aoi_mode, fsl_diu_mode_db,
+	     ARRAY_SIZE(fsl_diu_mode_db), &fsl_diu_default_mode, default_bpp);
+
+	switch (rc) {
+	case 1:
+		DPRINTK("using mode specified in @mode\n");
+		break;
+	case 2:
+		DPRINTK("using mode specified in @mode "
+			"with ignored refresh rate\n");
+		break;
+	case 3:
+		DPRINTK("using mode default mode\n");
+		break;
+	case 4:
+		DPRINTK("using mode from list\n");
+		break;
+	default:
+		DPRINTK("rc = %d\n", rc);
+		DPRINTK("failed to find mode\n");
+		return -EBUSY;
+		break;
+	}
+
+	DPRINTK("xres_virtual %d\n", info->var.xres_virtual);
+	DPRINTK("bits_per_pixel %d\n", info->var.bits_per_pixel);
+
+	DPRINTK("info->var.yres_virtual = %d\n", info->var.yres_virtual);
+	DPRINTK("info->fix.line_length = %d\n", info->fix.line_length);
+
+	if (mfbi->type == MFB_TYPE_OFF)
+		mfbi->blank = FB_BLANK_NORMAL;
+	else
+		mfbi->blank = FB_BLANK_UNBLANK;
+
+	if (fsl_diu_check_var(&info->var, info)) {
+		printk(KERN_ERR "fb_check_var failed");
+		fb_dealloc_cmap(&info->cmap);
+		return -EINVAL;
+	}
+
+	if (fsl_diu_set_par(info)) {
+		printk(KERN_ERR "fb_set_par failed");
+		fb_dealloc_cmap(&info->cmap);
+		return -EINVAL;
+	}
+
+	if (register_framebuffer(info) < 0) {
+		printk(KERN_ERR "register_framebuffer failed");
+		unmap_video_memory(info);
+		fb_dealloc_cmap(&info->cmap);
+		return -EINVAL;
+	}
+
+	mfbi->registered = 1;
+	printk(KERN_INFO "fb%d: %s fb device registered successfully.\n",
+		 info->node, info->fix.id);
+
+	return 0;
+}
+
+static void __exit uninstall_fb(struct fb_info *info)
+{
+	struct mfb_info *mfbi = info->par;
+
+	DPRINTK("Entered: uninstall_fb\n");
+	if (!mfbi->registered)
+		return;
+
+	unregister_framebuffer(info);
+	unmap_video_memory(info);
+	if (&info->cmap)
+		fb_dealloc_cmap(&info->cmap);
+
+	mfbi->registered = 0;
+}
+
+static irqreturn_t fsl_diu_isr(int irq, void *dev_id)
+{
+	struct diu *hw = dr.diu_reg;
+	unsigned int status = read_reg(&(hw->int_status));
+
+	if (status) {
+		/* This is the workaround for underrun */
+		if (status & INT_UNDRUN) {
+			out_be32(&(hw->diu_mode), 0);
+			DPRINTK("Err: DIU occurs underrun!\n");
+			udelay(1);
+			out_be32(&(hw->diu_mode), 1);
+		}
+#if defined(CONFIG_NOT_COHERENT_CACHE)
+		else if (status & INT_VSYNC) {
+			int i;
+			unsigned int *ptr;
+			ptr  = coherence_data;
+			for (i = 0; i < 1024*8; i++)
+				*ptr++ = 0;
+		}
+#endif
+		return IRQ_HANDLED;
+	}
+	return IRQ_NONE;
+}
+
+static void request_irq_local(void)
+{
+	unsigned long status, flags, ints;
+	struct diu *hw;
+	struct device_node *np;
+
+	DPRINTK("Entered: request_irq_local\n");
+	hw = dr.diu_reg;
+
+	/* Read to clear the status */
+	status = read_reg(&(hw->int_status));
+
+	np = of_find_compatible_node(NULL, NULL, "fsl-diu");
+	if (!np) {
+		printk(KERN_ERR "Err: can't find device node 'fsl-diu'\n");
+		return;
+	}
+
+	irq = irq_of_parse_and_map(np, 0);
+	of_node_put(np);
+	if (request_irq(irq, fsl_diu_isr, 0, "LCDC", 0))
+		pr_info("Request LCDC IRQ failed.\n");
+	else {
+		spin_lock_irqsave(&fsl_diu_notifier_list.lock, flags);
+		ints = INT_PARERR | INT_LS_BF_VS;
+#if !defined(CONFIG_NOT_COHERENT_CACHE)
+		ints |=	INT_VSYNC;
+#endif
+		if (dr.mode == MFB_MODE2 || dr.mode == MFB_MODE3)
+			ints |= INT_VSYNC_WB;
+
+		/* Read to clear the status */
+		status = read_reg(&(hw->int_status));
+		write_reg(&(hw->int_mask), ints);
+		spin_unlock_irqrestore(&fsl_diu_notifier_list.lock, flags);
+	}
+}
+
+static void free_irq_local(void)
+{
+	struct diu *hw = dr.diu_reg;
+
+	DPRINTK("Entered: free_irq_local\n");
+	/* Disable all LCDC interrupt */
+	write_reg(&(hw->int_mask), 0x1f);
+
+	free_irq(irq, 0);
+}
+
+int fsl_diu_register_client(struct notifier_block *nb)
+{
+	unsigned long flags;
+	int ret;
+	struct diu *hw = dr.diu_reg;
+	DPRINTK("Entered: fsl_diu_register_client\n");
+
+	ret = atomic_notifier_chain_register(&fsl_diu_notifier_list, nb);
+
+	spin_lock_irqsave(&fsl_diu_notifier_list.lock, flags);
+
+	/* Enable interrupt in case client has registered */
+	if (fsl_diu_notifier_list.head != NULL) {
+		unsigned long status;
+		unsigned long ints = INT_PARERR | INT_LS_BF_VS;
+
+#if !defined(CONFIG_NOT_COHERENT_CACHE)
+			ints |= INT_VSYNC;
+#endif
+
+		if (dr.mode == MFB_MODE2 || dr.mode == MFB_MODE3)
+			ints |= INT_VSYNC_WB;
+
+		/* Read to clear the status */
+		status = read_reg(&(hw->int_status));
+		write_reg(&(hw->int_mask), ints);
+	}
+
+	spin_unlock_irqrestore(&fsl_diu_notifier_list.lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(fsl_diu_register_client);
+
+int fsl_diu_unregister_client(struct notifier_block *nb)
+{
+	unsigned long flags;
+	int ret;
+	struct diu *hw = dr.diu_reg;
+
+	DPRINTK("Entered: fsl_diu_unregister_client\n");
+	ret = atomic_notifier_chain_unregister(&fsl_diu_notifier_list, nb);
+
+	spin_lock_irqsave(&fsl_diu_notifier_list.lock, flags);
+
+	/* Mask interrupt in case no client registered */
+	if (fsl_diu_notifier_list.head == NULL)
+		write_reg(&(hw->int_mask), 0x1f);
+
+	spin_unlock_irqrestore(&fsl_diu_notifier_list.lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(fsl_diu_unregister_client);
+
+#ifdef CONFIG_PM
+/*
+ * Power management hooks. Note that we won't be called from IRQ context,
+ * unlike the blank functions above, so we may sleep.
+ */
+static int fsl_diu_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	DPRINTK("Entered: fsl_diu_suspend\n");
+	disable_lcdc(&fsl_diu_info[0]);
+
+	return 0;
+}
+
+static int fsl_diu_resume(struct platform_device *pdev)
+{
+	DPRINTK("Entered: fsl_diu_resume\n");
+	enable_lcdc(&fsl_diu_info[0]);
+
+	return 0;
+}
+#endif				/* CONFIG_PM */
+
+/* Align to 64-bit(8-byte), 32-byte, etc. */
+static int allocate_buf(struct diu_addr *buf, u32 size, u32 bytes_align)
+{
+	u32 offset, ssize;
+	u32 mask;
+
+	DPRINTK("Entered: allocate_buf\n");
+	ssize = size + bytes_align;
+	buf->vaddr = dma_alloc_coherent(0, ssize,
+					(dma_addr_t *) &(buf->paddr),
+					GFP_DMA | GFP_KERNEL);
+	if (!buf->vaddr)
+		return -ENOMEM;
+
+	memset(buf->vaddr, 0, ssize);
+
+	mask = bytes_align - 1;
+	offset = (u32)buf->paddr & mask;
+	if (offset) {
+		buf->offset = bytes_align - offset;
+		buf->paddr = (u32)buf->paddr + offset;
+	} else
+		buf->offset = 0;
+	return 0;
+}
+
+static void free_buf(struct diu_addr *buf, u32 size, u32 bytes_align)
+{
+	DPRINTK("Entered: free_buf\n");
+	dma_free_coherent(0, size + bytes_align,
+				buf->vaddr, (buf->paddr - buf->offset));
+	return;
+}
+
+static ssize_t store_monitor(struct device *device,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	char **last = NULL;
+	int val, old_monitor_port;
+
+	val = simple_strtoul(buf, last, 0);
+
+	old_monitor_port = monitor_port;
+
+	monitor_port = platform_set_sysfs_monitor_port(val);
+
+	if (old_monitor_port != monitor_port) {
+				/* All AOIs need adjust pixel format */
+		fsl_diu_set_par(&fsl_diu_info[0]);
+		fsl_diu_set_par(&fsl_diu_info[1]);
+		fsl_diu_set_par(&fsl_diu_info[2]);
+		fsl_diu_set_par(&fsl_diu_info[3]);
+		fsl_diu_set_par(&fsl_diu_info[4]);
+	}
+	return count;
+}
+
+static ssize_t show_monitor(struct device *device,
+	struct device_attribute *attr, char *buf)
+{
+	return platform_show_monitor_port(monitor_port, buf);
+}
+
+static struct device_attribute device_attrs[] = {
+	__ATTR(monitor, S_IRUGO|S_IWUSR, show_monitor, store_monitor),
+};
+
+static int fsl_diu_probe(struct platform_device *pdev)
+{
+	struct mfb_info *mfbi;
+	unsigned long dummy_ad_addr;
+	int ret, i, error = 0;
+
+	DPRINTK("Entered: fsl_diu_probe\n");
+
+	/* Area descriptor memory pool aligns to 64-bit boundary */
+	allocate_buf(&pool.ad, sizeof(struct diu_ad) * FSL_AOI_NUM, 8);
+
+	/* Get memory for Gamma Table  - 32-byte aligned memory */
+	allocate_buf(&pool.gamma, 768, 32);
+
+	/* For performance, cursor bitmap buffer aligns to 32-byte boundary */
+	allocate_buf(&pool.cursor, MAX_CURS * MAX_CURS * 2, 32);
+
+	i = sizeof(fsl_diu_info) / sizeof(struct fb_info);
+	dummy_ad = (struct diu_ad *)((u32)pool.ad.vaddr + pool.ad.offset) + i;
+	dummy_ad->paddr = pool.ad.paddr + i * sizeof(struct diu_ad);
+	dummy_aoi_virt = fsl_diu_alloc(64, &dummy_ad_addr);
+	dummy_ad->addr = cpu_to_le32(dummy_ad_addr);
+	dummy_ad->pix_fmt = 0x88882317;
+	dummy_ad->src_size_g_alpha = cpu_to_le32((4 << 12) | 4);
+	dummy_ad->aoi_size = cpu_to_le32((4 << 16) |  2);
+	dummy_ad->offset_xyi = 0;
+	dummy_ad->offset_xyd = 0;
+	dummy_ad->next_ad = 0;
+	memset(dummy_aoi_virt, 0x00, 64);
+	write_reg(&(dr.diu_reg->desc[0]), dummy_ad->paddr);
+	write_reg(&(dr.diu_reg->desc[1]), dummy_ad->paddr);
+	write_reg(&(dr.diu_reg->desc[2]), dummy_ad->paddr);
+
+	for (i = 0; i < sizeof(fsl_diu_info) / sizeof(struct fb_info); i++) {
+		fsl_diu_info[i].fix.smem_start = 0;
+		mfbi = fsl_diu_info[i].par;
+		mfbi->ad = (struct diu_ad *)((u32)pool.ad.vaddr
+					+ pool.ad.offset) + i;
+		mfbi->ad->paddr = pool.ad.paddr + i * sizeof(struct diu_ad);
+		ret = install_fb(&fsl_diu_info[i], pdev);
+		if (ret) {
+			printk(KERN_ERR "Failed to register framebuffer %d\n",
+					i);
+			return ret;
+		}
+	}
+	for (i = 0; i < ARRAY_SIZE(device_attrs); i++) {
+		error = device_create_file(fsl_diu_info[0].dev,
+						&device_attrs[i]);
+
+		if (error)
+			break;
+	}
+
+	if (error) {
+		while (--i >= 0)
+			device_remove_file(fsl_diu_info[0].dev,
+						&device_attrs[i]);
+	}
+
+#if defined(CONFIG_NOT_COHERENT_CACHE)
+	coherence_data = fsl_diu_alloc(32*1024, &coherence_data_phy);
+#endif
+
+	request_irq_local();
+	return 0;
+}
+
+static struct platform_driver fsl_diu_driver = {
+	.driver = {
+		   .name = "fsl_diu",
+		   .owner = THIS_MODULE,
+		   },
+	.probe = fsl_diu_probe,
+#ifdef CONFIG_PM
+	.suspend = fsl_diu_suspend,
+	.resume = fsl_diu_resume,
+#endif
+};
+
+#ifndef MODULE
+static int __init fsl_diu_setup(char *options)
+{
+	char *opt;
+	int val;
+
+	DPRINTK("Entered: fsl_diu_setup\n");
+	if (!options || !*options)
+		return 0;
+
+	while ((opt = strsep(&options, ",")) != NULL) {
+		if (!*opt)
+			continue;
+		if (!strncmp(opt, "monitor=", 8)) {
+			val = simple_strtoul(opt + 8, NULL, 0);
+			if ((val == 0) || (val == 1) || (val == 2))
+				monitor_port = val;
+		} else if (!strncmp(opt, "bpp=", 4))
+			default_bpp = simple_strtoul(opt + 4, NULL, 0);
+		else
+			fb_mode = opt;
+	}
+
+	return 0;
+}
+#endif
+
+static struct platform_device fsl_diu_device = {
+	.name   = "fsl_diu",
+};
+
+int __init fsl_diu_init(void)
+{
+	struct device_node *np;
+	struct resource r;
+	int error;
+	DPRINTK("Entered: fsl_diu_init\n");
+	np = of_find_compatible_node(NULL, NULL, "fsl-diu");
+	if (!np) {
+		printk(KERN_ERR "Err: can't find device node 'fsl-diu'\n");
+		return -ENODEV;
+	}
+
+	of_address_to_resource(np, 0, &r);
+	of_node_put(np);
+
+	DPRINTK("%s, r.start: 0x%08x\n", __func__, r.start);
+
+	dr.diu_reg = ioremap(r.start, sizeof(struct diu));
+
+	write_reg(&(dr.diu_reg->diu_mode), 0);		/* disable DIU anyway*/
+
+	spin_lock_init(&dr.reg_lock);
+
+
+	/*
+	 * For kernel boot options (in 'video=xxxfb:<options>' format)
+	 */
+#ifndef MODULE
+	{
+		char *option;
+
+		if (fb_get_options("fslfb", &option))
+			return -ENODEV;
+		fsl_diu_setup(option);
+	}
+#endif
+	error = platform_driver_register(&fsl_diu_driver);
+
+	if (!error) {
+		error = platform_device_register(&fsl_diu_device);
+		if (error) {
+			printk(KERN_ERR "Err: "
+					"can't register FB device driver!\n");
+			platform_driver_unregister(&fsl_diu_driver);
+		}
+		printk(KERN_INFO "FSL_DIU_FB: registed FB device driver!\n");
+	}
+
+	return error;
+}
+
+void __exit fsl_diu_exit(void)
+{
+	int i;
+
+	DPRINTK("Entered: fsl_diu_exit\n");
+	free_irq_local();
+	for (i = sizeof(fsl_diu_info) / sizeof(struct fb_info); i > 0; i--)
+		uninstall_fb(&fsl_diu_info[i - 1]);
+
+	platform_driver_unregister(&fsl_diu_driver);
+	iounmap(dr.diu_reg);
+
+	free_buf(&pool.ad, sizeof(struct diu_ad) * FSL_AOI_NUM, 8);
+	free_buf(&pool.cursor, MAX_CURS * MAX_CURS * 2, 32);
+	fsl_diu_free(dummy_aoi_virt, 64);
+	return;
+}
+
+module_init(fsl_diu_init);
+module_exit(fsl_diu_exit);
+
+MODULE_AUTHOR("Freescale Semiconductor, Inc.");
+MODULE_DESCRIPTION("FSL DIU framebuffer driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/video/fsl-diu-fb.h b/drivers/video/fsl-diu-fb.h
new file mode 100644
index 0000000..294d0bf
--- /dev/null
+++ b/drivers/video/fsl-diu-fb.h
@@ -0,0 +1,388 @@
+/*
+ * Copyright 2007 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ *  Freescale DIU Frame Buffer device driver
+ *
+ *  Authors: Hongjun Chen <hong-jun.chen@freescale.com>
+ *           Paul Widmer <paul.widmer@freescale.com>
+ *           Srikanth Srinivasan <srikanth.srinivasan@freescale.com>
+ *           York Sun <yorksun@freescale.com>
+ *  Copyright (C) Freescale Semicondutor, Inc. 2007. All rights reserved.
+ *
+ *   Based on imxfb.c Copyright (C) 2004 S.Hauer, Pengutronix
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+#ifndef __FSL_DIU_FB_H__
+#define __FSL_DIU_FB_H__
+
+/* FIXME: This should be changed to dev_dbg this will be done as soon as
+ * we can obtain dev through the dts setup
+ */
+#ifdef DEBUG
+#define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt, __func__, ## args)
+#else
+#define DPRINTK(fmt, args...)
+#endif
+
+
+
+/* Arbitrary threshold to determine the allocation method
+ * See mpc8610fb_set_par(), map_video_memory(), and unmap_video_memory()
+ */
+#define MEM_ALLOC_THRESHOLD (1024*768*4+32)
+/* Minimum value that the pixel clock can be set to in pico seconds
+ * This is determined by platform clock/3 where the minimum platform
+ * clock is 533MHz. This gives 5629 pico seconds.
+ */
+#define MIN_PIX_CLK 5629
+#define MAX_PIX_CLK 96096
+
+#include <linux/types.h>
+
+struct mfb_alpha {
+	int enable;
+	int alpha;
+};
+
+struct mfb_chroma_key {
+	int enable;
+	__u8  red_max;
+	__u8  green_max;
+	__u8  blue_max;
+	__u8  red_min;
+	__u8  green_min;
+	__u8  blue_min;
+};
+
+struct aoi_display_offset {
+	int x_aoi_d;
+	int y_aoi_d;
+};
+
+#define MFB_SET_CHROMA_KEY	_IOW('M', 1, struct mfb_chroma_key)
+#define MFB_WAIT_FOR_VSYNC	_IOW('F', 0x20, u_int32_t)
+#define MFB_SET_BRIGHTNESS	_IOW('M', 3, __u8)
+
+#define MFB_SET_ALPHA		0x80014d00
+#define MFB_GET_ALPHA		0x40014d00
+#define MFB_SET_AOID		0x80084d04
+#define MFB_GET_AOID		0x40084d04
+#define MFB_SET_PIXFMT		0x80014d08
+#define MFB_GET_PIXFMT		0x40014d08
+
+#define FBIOGET_GWINFO		0x46E0
+#define FBIOPUT_GWINFO		0x46E1
+
+#ifdef __KERNEL__
+#include <linux/spinlock.h>
+
+/*
+ * These parameters give default parameters
+ * for video output 1024x768,
+ * FIXME - change timing to proper amounts
+ * hsync 31.5kHz, vsync 60Hz
+ */
+static struct fb_videomode __devinitdata fsl_diu_default_mode = {
+	.refresh	= 60,
+	.xres		= 1024,
+	.yres		= 768,
+	.pixclock	= 15385,
+	.left_margin	= 160,
+	.right_margin	= 24,
+	.upper_margin	= 29,
+	.lower_margin	= 3,
+	.hsync_len	= 136,
+	.vsync_len	= 6,
+	.sync		= FB_SYNC_COMP_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+	.vmode		= FB_VMODE_NONINTERLACED
+};
+
+static struct fb_videomode __devinitdata fsl_diu_mode_db[] = {
+	{
+		.name		= "1024x768-60",
+		.refresh	= 60,
+		.xres		= 1024,
+		.yres		= 768,
+		.pixclock	= 15385,
+		.left_margin	= 160,
+		.right_margin	= 24,
+		.upper_margin	= 29,
+		.lower_margin	= 3,
+		.hsync_len	= 136,
+		.vsync_len	= 6,
+		.sync		= FB_SYNC_COMP_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+		.vmode		= FB_VMODE_NONINTERLACED
+	},
+	{
+		.name		= "1024x768-70",
+		.refresh	= 70,
+		.xres		= 1024,
+		.yres		= 768,
+		.pixclock	= 16886,
+		.left_margin	= 3,
+		.right_margin	= 3,
+		.upper_margin	= 2,
+		.lower_margin	= 2,
+		.hsync_len	= 40,
+		.vsync_len	= 18,
+		.sync		= FB_SYNC_COMP_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+		.vmode		= FB_VMODE_NONINTERLACED
+	},
+	{
+		.name		= "1024x768-75",
+		.refresh	= 75,
+		.xres		= 1024,
+		.yres		= 768,
+		.pixclock	= 15009,
+		.left_margin	= 3,
+		.right_margin	= 3,
+		.upper_margin	= 2,
+		.lower_margin	= 2,
+		.hsync_len	= 80,
+		.vsync_len	= 32,
+		.sync		= FB_SYNC_COMP_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+		.vmode		= FB_VMODE_NONINTERLACED
+	},
+	{
+		.name		= "1280x1024-60",
+		.refresh	= 60,
+		.xres		= 1280,
+		.yres		= 1024,
+		.pixclock	= 9375,
+		.left_margin	= 38,
+		.right_margin	= 128,
+		.upper_margin	= 2,
+		.lower_margin	= 7,
+		.hsync_len	= 216,
+		.vsync_len	= 37,
+		.sync		= FB_SYNC_COMP_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+		.vmode		= FB_VMODE_NONINTERLACED
+	},
+	{
+		.name		= "1280x1024-70",
+		.refresh	= 70,
+		.xres		= 1280,
+		.yres		= 1024,
+		.pixclock	= 9380,
+		.left_margin	= 6,
+		.right_margin	= 6,
+		.upper_margin	= 4,
+		.lower_margin	= 4,
+		.hsync_len	= 60,
+		.vsync_len	= 94,
+		.sync		= FB_SYNC_COMP_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+		.vmode		= FB_VMODE_NONINTERLACED
+	},
+	{
+		.name		= "1280x1024-75",
+		.refresh	= 75,
+		.xres		= 1280,
+		.yres		= 1024,
+		.pixclock	= 9380,
+		.left_margin	= 6,
+		.right_margin	= 6,
+		.upper_margin	= 4,
+		.lower_margin	= 4,
+		.hsync_len	= 60,
+		.vsync_len	= 15,
+		.sync		= FB_SYNC_COMP_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+		.vmode		= FB_VMODE_NONINTERLACED
+	},
+	{
+		.name		= "320x240",		/* for AOI only */
+		.refresh	= 60,
+		.xres		= 320,
+		.yres		= 240,
+		.pixclock	= 15385,
+		.left_margin	= 0,
+		.right_margin	= 0,
+		.upper_margin	= 0,
+		.lower_margin	= 0,
+		.hsync_len	= 0,
+		.vsync_len	= 0,
+		.sync		= FB_SYNC_COMP_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+		.vmode		= FB_VMODE_NONINTERLACED
+	},
+	{
+		.name		= "1280x480-60",
+		.refresh	= 60,
+		.xres		= 1280,
+		.yres		= 480,
+		.pixclock	= 18939,
+		.left_margin	= 353,
+		.right_margin	= 47,
+		.upper_margin	= 39,
+		.lower_margin	= 4,
+		.hsync_len	= 8,
+		.vsync_len	= 2,
+		.sync		= FB_SYNC_COMP_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+		.vmode		= FB_VMODE_NONINTERLACED
+	},
+};
+/*
+ * These are the fields of area descriptor(in DDR memory) for every plane
+ */
+struct diu_ad {
+	/* Word 0(32-bit) in DDR memory */
+/* 	__u16 comp; */
+/* 	__u16 pixel_s:2; */
+/* 	__u16 pallete:1; */
+/* 	__u16 red_c:2; */
+/* 	__u16 green_c:2; */
+/* 	__u16 blue_c:2; */
+/* 	__u16 alpha_c:3; */
+/* 	__u16 byte_f:1; */
+/* 	__u16 res0:3; */
+
+	__u32 pix_fmt; /* hard coding pixel format */
+
+	/* Word 1(32-bit) in DDR memory */
+	__u32 addr;
+
+	/* Word 2(32-bit) in DDR memory */
+/* 	__u32 delta_xs:11; */
+/* 	__u32 res1:1; */
+/* 	__u32 delta_ys:11; */
+/* 	__u32 res2:1; */
+/* 	__u32 g_alpha:8; */
+	__u32 src_size_g_alpha;
+
+	/* Word 3(32-bit) in DDR memory */
+/* 	__u32 delta_xi:11; */
+/* 	__u32 res3:5; */
+/* 	__u32 delta_yi:11; */
+/* 	__u32 res4:3; */
+/* 	__u32 flip:2; */
+	__u32 aoi_size;
+
+	/* Word 4(32-bit) in DDR memory */
+	/*__u32 offset_xi:11;
+	__u32 res5:5;
+	__u32 offset_yi:11;
+	__u32 res6:5;
+	*/
+	__u32 offset_xyi;
+
+	/* Word 5(32-bit) in DDR memory */
+	/*__u32 offset_xd:11;
+	__u32 res7:5;
+	__u32 offset_yd:11;
+	__u32 res8:5; */
+	__u32 offset_xyd;
+
+
+	/* Word 6(32-bit) in DDR memory */
+	__u32 ckmax_r:8;
+	__u32 ckmax_g:8;
+	__u32 ckmax_b:8;
+	__u32 res9:8;
+
+	/* Word 7(32-bit) in DDR memory */
+	__u32 ckmin_r:8;
+	__u32 ckmin_g:8;
+	__u32 ckmin_b:8;
+	__u32 res10:8;
+/* 	__u32 res10:8; */
+
+	/* Word 8(32-bit) in DDR memory */
+	__u32 next_ad;
+
+	/* Word 9(32-bit) in DDR memory, just for 64-bit aligned */
+	__u32 paddr;
+} __attribute__ ((packed));
+
+/* DIU register map */
+struct diu {
+	__be32 desc[3];
+	__be32 gamma;
+	__be32 pallete;
+	__be32 cursor;
+	__be32 curs_pos;
+	__be32 diu_mode;
+	__be32 bgnd;
+	__be32 bgnd_wb;
+	__be32 disp_size;
+	__be32 wb_size;
+	__be32 wb_mem_addr;
+	__be32 hsyn_para;
+	__be32 vsyn_para;
+	__be32 syn_pol;
+	__be32 thresholds;
+	__be32 int_status;
+	__be32 int_mask;
+	__be32 colorbar[8];
+	__be32 filling;
+	__be32 plut;
+} __attribute__ ((packed));
+
+struct diu_hw {
+	struct diu *diu_reg;
+	spinlock_t reg_lock;
+
+	__u32 mode;		/* DIU operation mode */
+};
+
+struct diu_addr {
+	__u8 __iomem *vaddr;	/* Virtual address */
+	dma_addr_t paddr;	/* Physical address */
+	__u32 	   offset;
+};
+
+struct diu_pool {
+	struct diu_addr ad;
+	struct diu_addr gamma;
+	struct diu_addr pallete;
+	struct diu_addr cursor;
+};
+
+#define FSL_DIU_BASE_OFFSET	0x2C000	/* Offset of DIU */
+#define INT_LCDC		64	/* DIU interrupt number */
+
+#define FSL_AOI_NUM	6	/* 5 AOIs and one dummy AOI */
+				/* 1 for plane 0, 2 for plane 1&2 each */
+
+/* Minimum X and Y resolutions */
+#define MIN_XRES	64
+#define MIN_YRES	64
+
+/* HW cursor parameters */
+#define MAX_CURS		32
+
+/* Modes of operation of DIU */
+#define MFB_MODE0	0	/* DIU off */
+#define MFB_MODE1	1	/* All three planes output to display */
+#define MFB_MODE2	2	/* Plane 1 to display, planes 2+3 written back*/
+#define MFB_MODE3	3	/* All three planes written back to memory */
+#define MFB_MODE4	4	/* Color bar generation */
+
+/* INT_STATUS/INT_MASK field descriptions */
+#define INT_VSYNC	0x01	/* Vsync interrupt  */
+#define INT_VSYNC_WB	0x02	/* Vsync interrupt for write back operation */
+#define INT_UNDRUN	0x04	/* Under run exception interrupt */
+#define INT_PARERR	0x08	/* Display parameters error interrupt */
+#define INT_LS_BF_VS	0x10	/* Lines before vsync. interrupt */
+
+/* Panels'operation modes */
+#define MFB_TYPE_OUTPUT	0	/* Panel output to display */
+#define MFB_TYPE_OFF	1	/* Panel off */
+#define MFB_TYPE_WB	2	/* Panel written back to memory */
+#define MFB_TYPE_TEST	3	/* Panel generate color bar */
+
+void *fsl_diu_alloc(unsigned long size, unsigned long *phys);
+void fsl_diu_free(void *p, unsigned long size);
+unsigned int platform_get_pixel_format(unsigned int bits_per_pixel,
+						int monitor_port);
+void platform_set_gamma_table(int monitor_port, char *gamma_table_base);
+void platform_set_pixel_clock(unsigned int pixclock);
+ssize_t platform_show_monitor_port(int monitor_port, char *buf);
+int platform_set_monitor_port(int val);
+int platform_set_sysfs_monitor_port(int val);
+
+#endif /* __KERNEL__ */
+#endif /* __FSL_DIU_FB_H__ */
-- 
1.5.2.2

