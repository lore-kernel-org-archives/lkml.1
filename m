Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbYC1ADV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbYC1ADV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbYC1ADK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:03:10 -0400
Received: from mail.queued.net ([207.210.101.209]:1777 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbYC1ADI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:03:08 -0400
Date: Thu, 27 Mar 2008 20:03:46 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, info-linux@geode.amd.com,
       jordan.crouse@amd.com
Subject: [PATCH 1/7] lxfb: create GP/DC/VP/FP-specific handlers rather than
 using readl/writel
Message-ID: <20080327200346.34c22c9c@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This creates read_gp/write_gp, read_dc/write_dc, read_vp/write_vp, and
read_fp/write_fp for reading and updating those registers.  Note that
we don't follow the 'DF' naming; those will be renamed to VP shortly.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/geode/lxfb.h      |   43 +++++++++++
 drivers/video/geode/lxfb_core.c |    9 +--
 drivers/video/geode/lxfb_ops.c  |  151 ++++++++++++++++++---------------------
 3 files changed, 116 insertions(+), 87 deletions(-)

diff --git a/drivers/video/geode/lxfb.h b/drivers/video/geode/lxfb.h
index 8c83a1b..60579f4 100644
--- a/drivers/video/geode/lxfb.h
+++ b/drivers/video/geode/lxfb.h
@@ -188,4 +188,47 @@ void lx_set_palette_reg(struct fb_info *, unsigned int, unsigned int,
 #define  GP_BS_BLT_BUSY    (1 << 0)
 #define  GP_BS_CB_EMPTY    (1 << 4)
 
+
+/* register access functions */
+
+static inline uint32_t read_gp(struct lxfb_par *par, int reg)
+{
+	return readl(par->gp_regs + reg);
+}
+
+static inline void write_gp(struct lxfb_par *par, int reg, uint32_t val)
+{
+	writel(val, par->gp_regs + reg);
+}
+
+static inline uint32_t read_dc(struct lxfb_par *par, int reg)
+{
+	return readl(par->dc_regs + reg);
+}
+
+static inline void write_dc(struct lxfb_par *par, int reg, uint32_t val)
+{
+	writel(val, par->dc_regs + reg);
+}
+
+static inline uint32_t read_vp(struct lxfb_par *par, int reg)
+{
+	return readl(par->df_regs + reg);
+}
+
+static inline void write_vp(struct lxfb_par *par, int reg, uint32_t val)
+{
+	writel(val, par->df_regs + reg);
+}
+
+static inline uint32_t read_fp(struct lxfb_par *par, int reg)
+{
+	return readl(par->df_regs + reg);
+}
+
+static inline void write_fp(struct lxfb_par *par, int reg, uint32_t val)
+{
+	writel(val, par->df_regs + reg);
+}
+
 #endif
diff --git a/drivers/video/geode/lxfb_core.c b/drivers/video/geode/lxfb_core.c
index eb6b881..a1d14e0 100644
--- a/drivers/video/geode/lxfb_core.c
+++ b/drivers/video/geode/lxfb_core.c
@@ -366,12 +366,9 @@ static int __init lxfb_map_video_memory(struct fb_info *info,
 	if (par->df_regs == NULL)
 		return ret;
 
-	writel(DC_UNLOCK_CODE, par->dc_regs + DC_UNLOCK);
-
-	writel(info->fix.smem_start & 0xFF000000,
-	       par->dc_regs + DC_PHY_MEM_OFFSET);
-
-	writel(0, par->dc_regs + DC_UNLOCK);
+	write_dc(par, DC_UNLOCK, DC_UNLOCK_CODE);
+	write_dc(par, DC_PHY_MEM_OFFSET, info->fix.smem_start & 0xFF000000);
+	write_dc(par, DC_UNLOCK, 0);
 
 	dev_info(&dev->dev, "%d KB of video memory at 0x%lx\n",
 		 info->fix.smem_len / 1024, info->fix.smem_start);
diff --git a/drivers/video/geode/lxfb_ops.c b/drivers/video/geode/lxfb_ops.c
index a52c180..6efd60e 100644
--- a/drivers/video/geode/lxfb_ops.c
+++ b/drivers/video/geode/lxfb_ops.c
@@ -160,49 +160,48 @@ static void lx_graphics_disable(struct fb_info *info)
 
 	/* Note:  This assumes that the video is in a quitet state */
 
-	writel(0, par->df_regs + DF_ALPHA_CONTROL_1);
-	writel(0, par->df_regs + DF_ALPHA_CONTROL_1 + 32);
-	writel(0, par->df_regs + DF_ALPHA_CONTROL_1 + 64);
+	write_vp(par, DF_ALPHA_CONTROL_1, 0);
+	write_vp(par, DF_ALPHA_CONTROL_1 + 32, 0);
+	write_vp(par, DF_ALPHA_CONTROL_1 + 64, 0);
 
 	/* Turn off the VGA and video enable */
-	val = readl (par->dc_regs + DC_GENERAL_CFG) &
-		~(DC_GCFG_VGAE | DC_GCFG_VIDE);
+	val = read_dc(par, DC_GENERAL_CFG) & ~(DC_GCFG_VGAE | DC_GCFG_VIDE);
 
-	writel(val, par->dc_regs + DC_GENERAL_CFG);
+	write_dc(par, DC_GENERAL_CFG, val);
 
-	val = readl(par->df_regs + DF_VIDEO_CFG) & ~DF_VCFG_VID_EN;
-	writel(val, par->df_regs + DF_VIDEO_CFG);
+	val = read_vp(par, DF_VIDEO_CFG) & ~DF_VCFG_VID_EN;
+	write_vp(par, DF_VIDEO_CFG, val);
 
-	writel( DC_IRQ_MASK | DC_VSYNC_IRQ_MASK |
-		DC_IRQ_STATUS | DC_VSYNC_IRQ_STATUS,
-		par->dc_regs + DC_IRQ);
+	write_dc(par, DC_IRQ, DC_IRQ_MASK | DC_VSYNC_IRQ_MASK | DC_IRQ_STATUS |
+			DC_VSYNC_IRQ_STATUS);
 
-	val = readl(par->dc_regs + DC_GENLCK_CTRL) & ~DC_GENLCK_ENABLE;
-	writel(val, par->dc_regs + DC_GENLCK_CTRL);
+	val = read_dc(par, DC_GENLCK_CTRL) & ~DC_GENLCK_ENABLE;
+	write_dc(par, DC_GENLCK_CTRL, val);
 
-	val = readl(par->dc_regs + DC_COLOR_KEY) & ~DC_CLR_KEY_ENABLE;
-	writel(val & ~DC_CLR_KEY_ENABLE, par->dc_regs + DC_COLOR_KEY);
+	val = read_dc(par, DC_COLOR_KEY) & ~DC_CLR_KEY_ENABLE;
+	write_dc(par, DC_COLOR_KEY, val & ~DC_CLR_KEY_ENABLE);
 
 	/* We don't actually blank the panel, due to the long latency
 	   involved with bringing it back */
 
-	val = readl(par->df_regs + DF_MISC) | DF_MISC_DAC_PWRDN;
-	writel(val, par->df_regs + DF_MISC);
+	val = read_vp(par, DF_MISC) | DF_MISC_DAC_PWRDN;
+	write_vp(par, DF_MISC, val);
 
 	/* Turn off the display */
 
-	val = readl(par->df_regs + DF_DISPLAY_CFG);
-	writel(val & ~(DF_DCFG_CRT_EN | DF_DCFG_HSYNC_EN | DF_DCFG_VSYNC_EN |
-		       DF_DCFG_DAC_BL_EN), par->df_regs + DF_DISPLAY_CFG);
+	val = read_vp(par, DF_DISPLAY_CFG);
+	write_vp(par, DF_DISPLAY_CFG, val &
+			~(DF_DCFG_CRT_EN | DF_DCFG_HSYNC_EN |
+			DF_DCFG_VSYNC_EN | DF_DCFG_DAC_BL_EN));
 
-	gcfg = readl(par->dc_regs + DC_GENERAL_CFG);
+	gcfg = read_dc(par, DC_GENERAL_CFG);
 	gcfg &= ~(DC_GCFG_CMPE | DC_GCFG_DECE);
-	writel(gcfg, par->dc_regs + DC_GENERAL_CFG);
+	write_dc(par, DC_GENERAL_CFG, gcfg);
 
 	/* Turn off the TGEN */
-	val = readl(par->dc_regs + DC_DISPLAY_CFG);
+	val = read_dc(par, DC_DISPLAY_CFG);
 	val &= ~DC_DCFG_TGEN;
-	writel(val, par->dc_regs + DC_DISPLAY_CFG);
+	write_dc(par, DC_DISPLAY_CFG, val);
 
 	/* Wait 1000 usecs to ensure that the TGEN is clear */
 	udelay(1000);
@@ -210,12 +209,12 @@ static void lx_graphics_disable(struct fb_info *info)
 	/* Turn off the FIFO loader */
 
 	gcfg &= ~DC_GCFG_DFLE;
-	writel(gcfg, par->dc_regs + DC_GENERAL_CFG);
+	write_dc(par, DC_GENERAL_CFG, gcfg);
 
 	/* Lastly, wait for the GP to go idle */
 
 	do {
-		val = readl(par->gp_regs + GP_BLT_STATUS);
+		val = read_gp(par, GP_BLT_STATUS);
 	} while ((val & GP_BS_BLT_BUSY) || !(val & GP_BS_CB_EMPTY));
 }
 
@@ -225,11 +224,11 @@ static void lx_graphics_enable(struct fb_info *info)
 	u32 temp, config;
 
 	/* Set the video request register */
-	writel(0, par->df_regs + DF_VIDEO_REQUEST);
+	write_vp(par, DF_VIDEO_REQUEST, 0);
 
 	/* Set up the polarities */
 
-	config = readl(par->df_regs + DF_DISPLAY_CFG);
+	config = read_vp(par, DF_DISPLAY_CFG);
 
 	config &= ~(DF_DCFG_CRT_SYNC_SKW_MASK | DF_DCFG_PWR_SEQ_DLY_MASK |
 		  DF_DCFG_CRT_HSYNC_POL     | DF_DCFG_CRT_VSYNC_POL);
@@ -246,12 +245,9 @@ static void lx_graphics_enable(struct fb_info *info)
 	if (par->output & OUTPUT_PANEL) {
 		u32 msrlo, msrhi;
 
-		writel(DF_DEFAULT_TFT_PMTIM1,
-		       par->df_regs + DF_PANEL_TIM1);
-		writel(DF_DEFAULT_TFT_PMTIM2,
-		       par->df_regs + DF_PANEL_TIM2);
-		writel(DF_DEFAULT_TFT_DITHCTL,
-		       par->df_regs + DF_DITHER_CONTROL);
+		write_fp(par, DF_PANEL_TIM1, DF_DEFAULT_TFT_PMTIM1);
+		write_fp(par, DF_PANEL_TIM2, DF_DEFAULT_TFT_PMTIM2);
+		write_fp(par, DF_DITHER_CONTROL, DF_DEFAULT_TFT_DITHCTL);
 
 		msrlo = DF_DEFAULT_TFT_PAD_SEL_LOW;
 		msrhi = DF_DEFAULT_TFT_PAD_SEL_HIGH;
@@ -264,27 +260,24 @@ static void lx_graphics_enable(struct fb_info *info)
 			DF_DCFG_VSYNC_EN | DF_DCFG_DAC_BL_EN;
 	}
 
-	writel(config, par->df_regs + DF_DISPLAY_CFG);
+	write_vp(par, DF_DISPLAY_CFG, config);
 
 	/* Turn the CRT dacs back on */
 
 	if (par->output & OUTPUT_CRT) {
-		temp = readl(par->df_regs + DF_MISC);
+		temp = read_vp(par, DF_MISC);
 		temp &= ~(DF_MISC_DAC_PWRDN  | DF_MISC_A_PWRDN);
-		writel(temp, par->df_regs + DF_MISC);
+		write_vp(par, DF_MISC, temp);
 	}
 
 	/* Turn the panel on (if it isn't already) */
 
 	if (par->output & OUTPUT_PANEL) {
-		temp = readl(par->df_regs + DF_FP_PM);
+		temp = read_fp(par, DF_FP_PM);
 
 		if (!(temp & 0x09))
-			writel(temp | DF_FP_PM_P, par->df_regs + DF_FP_PM);
+			write_fp(par, DF_FP_PM, temp | DF_FP_PM_P);
 	}
-
-	temp = readl(par->df_regs + DF_MISC);
-	temp = readl(par->df_regs + DF_DISPLAY_CFG);
 }
 
 unsigned int lx_framebuffer_size(void)
@@ -314,7 +307,7 @@ void lx_set_mode(struct fb_info *info)
 	int vactive, vblankstart, vsyncstart, vsyncend, vblankend, vtotal;
 
 	/* Unlock the DC registers */
-	writel(DC_UNLOCK_CODE, par->dc_regs + DC_UNLOCK);
+	write_dc(par, DC_UNLOCK, DC_UNLOCK_CODE);
 
 	lx_graphics_disable(info);
 
@@ -341,22 +334,22 @@ void lx_set_mode(struct fb_info *info)
 	/* Clear the various buffers */
 	/* FIXME:  Adjust for panning here */
 
-	writel(0, par->dc_regs + DC_FB_START);
-	writel(0, par->dc_regs + DC_CB_START);
-	writel(0, par->dc_regs + DC_CURSOR_START);
+	write_dc(par, DC_FB_START, 0);
+	write_dc(par, DC_CB_START, 0);
+	write_dc(par, DC_CURSOR_START, 0);
 
 	/* FIXME: Add support for interlacing */
 	/* FIXME: Add support for scaling */
 
-	val = readl(par->dc_regs + DC_GENLCK_CTRL);
+	val = read_dc(par, DC_GENLCK_CTRL);
 	val &= ~(DC_GC_ALPHA_FLICK_ENABLE |
 		 DC_GC_FLICKER_FILTER_ENABLE | DC_GC_FLICKER_FILTER_MASK);
 
 	/* Default scaling params */
 
-	writel((0x4000 << 16) | 0x4000, par->dc_regs + DC_GFX_SCALE);
-	writel(0, par->dc_regs + DC_IRQ_FILT_CTL);
-	writel(val, par->dc_regs + DC_GENLCK_CTRL);
+	write_dc(par, DC_GFX_SCALE, (0x4000 << 16) | 0x4000);
+	write_dc(par, DC_IRQ_FILT_CTL, 0);
+	write_dc(par, DC_GENLCK_CTRL, val);
 
 	/* FIXME:  Support compression */
 
@@ -372,15 +365,15 @@ void lx_set_mode(struct fb_info *info)
 	max = info->fix.line_length * info->var.yres;
 	max = (max + 0x3FF) & 0xFFFFFC00;
 
-	writel(max | DC_DV_TOP_ENABLE, par->dc_regs + DC_DV_TOP);
+	write_dc(par, DC_DV_TOP, max | DC_DV_TOP_ENABLE);
 
-	val = readl(par->dc_regs + DC_DV_CTL) & ~DC_DV_LINE_SIZE_MASK;
-	writel(val | dv, par->dc_regs + DC_DV_CTL);
+	val = read_dc(par, DC_DV_CTL) & ~DC_DV_LINE_SIZE_MASK;
+	write_dc(par, DC_DV_CTL, val | dv);
 
 	size = info->var.xres * (info->var.bits_per_pixel >> 3);
 
-	writel(info->fix.line_length >> 3, par->dc_regs + DC_GRAPHICS_PITCH);
-	writel((size + 7) >> 3, par->dc_regs + DC_LINE_SIZE);
+	write_dc(par, DC_GRAPHICS_PITCH, info->fix.line_length >> 3);
+	write_dc(par, DC_LINE_SIZE, (size + 7) >> 3);
 
 	/* Set default watermark values */
 
@@ -437,35 +430,31 @@ void lx_set_mode(struct fb_info *info)
 	vblankend = vsyncend + info->var.upper_margin;
 	vtotal = vblankend;
 
-	writel((hactive - 1) | ((htotal - 1) << 16),
-	       par->dc_regs + DC_H_ACTIVE_TIMING);
-	writel((hblankstart - 1) | ((hblankend - 1) << 16),
-	       par->dc_regs + DC_H_BLANK_TIMING);
-	writel((hsyncstart - 1) | ((hsyncend - 1) << 16),
-	       par->dc_regs + DC_H_SYNC_TIMING);
-
-	writel((vactive - 1) | ((vtotal - 1) << 16),
-	       par->dc_regs + DC_V_ACTIVE_TIMING);
-
-	writel((vblankstart - 1) | ((vblankend - 1) << 16),
-	       par->dc_regs + DC_V_BLANK_TIMING);
+	write_dc(par, DC_H_ACTIVE_TIMING, (hactive - 1) | ((htotal - 1) << 16));
+	write_dc(par, DC_H_BLANK_TIMING,
+			(hblankstart - 1) | ((hblankend - 1) << 16));
+	write_dc(par, DC_H_SYNC_TIMING,
+			(hsyncstart - 1) | ((hsyncend - 1) << 16));
 
-	writel((vsyncstart - 1)  | ((vsyncend - 1) << 16),
-	       par->dc_regs + DC_V_SYNC_TIMING);
+	write_dc(par, DC_V_ACTIVE_TIMING, (vactive - 1) | ((vtotal - 1) << 16));
+	write_dc(par, DC_V_BLANK_TIMING,
+			(vblankstart - 1) | ((vblankend - 1) << 16));
+	write_dc(par, DC_V_SYNC_TIMING,
+			(vsyncstart - 1) | ((vsyncend - 1) << 16));
 
-	writel( (info->var.xres - 1) << 16 | (info->var.yres - 1),
-		par->dc_regs + DC_FB_ACTIVE);
+	write_dc(par, DC_FB_ACTIVE,
+			(info->var.xres - 1) << 16 | (info->var.yres - 1));
 
 	/* And re-enable the graphics output */
 	lx_graphics_enable(info);
 
 	/* Write the two main configuration registers */
-	writel(dcfg, par->dc_regs + DC_DISPLAY_CFG);
-	writel(0, par->dc_regs + DC_ARB_CFG);
-	writel(gcfg, par->dc_regs + DC_GENERAL_CFG);
+	write_dc(par, DC_DISPLAY_CFG, dcfg);
+	write_dc(par, DC_ARB_CFG, 0);
+	write_dc(par, DC_GENERAL_CFG, gcfg);
 
 	/* Lock the DC registers */
-	writel(0, par->dc_regs + DC_UNLOCK);
+	write_dc(par, DC_UNLOCK, 0);
 }
 
 void lx_set_palette_reg(struct fb_info *info, unsigned regno,
@@ -480,8 +469,8 @@ void lx_set_palette_reg(struct fb_info *info, unsigned regno,
 	val |= (green)      & 0x00ff00;
 	val |= (blue  >> 8) & 0x0000ff;
 
-	writel(regno, par->dc_regs + DC_PAL_ADDRESS);
-	writel(val, par->dc_regs + DC_PAL_DATA);
+	write_dc(par, DC_PAL_ADDRESS, regno);
+	write_dc(par, DC_PAL_DATA, val);
 }
 
 int lx_blank_display(struct fb_info *info, int blank_mode)
@@ -511,7 +500,7 @@ int lx_blank_display(struct fb_info *info, int blank_mode)
 		return -EINVAL;
 	}
 
-	dcfg = readl(par->df_regs + DF_DISPLAY_CFG);
+	dcfg = read_vp(par, DF_DISPLAY_CFG);
 	dcfg &= ~(DF_DCFG_DAC_BL_EN
 		  | DF_DCFG_HSYNC_EN | DF_DCFG_VSYNC_EN);
 	if (!blank)
@@ -520,17 +509,17 @@ int lx_blank_display(struct fb_info *info, int blank_mode)
 		dcfg |= DF_DCFG_HSYNC_EN;
 	if (vsync)
 		dcfg |= DF_DCFG_VSYNC_EN;
-	writel(dcfg, par->df_regs + DF_DISPLAY_CFG);
+	write_vp(par, DF_DISPLAY_CFG, dcfg);
 
 	/* Power on/off flat panel */
 
 	if (par->output & OUTPUT_PANEL) {
-		fp_pm = readl(par->df_regs + DF_FP_PM);
+		fp_pm = read_fp(par, DF_FP_PM);
 		if (blank_mode == FB_BLANK_POWERDOWN)
 			fp_pm &= ~DF_FP_PM_P;
 		else
 			fp_pm |= DF_FP_PM_P;
-		writel(fp_pm, par->df_regs + DF_FP_PM);
+		write_fp(par, DF_FP_PM, fp_pm);
 	}
 
 	return 0;
-- 
1.5.3.7

