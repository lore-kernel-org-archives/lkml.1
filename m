Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbYCIBpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbYCIBpt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 20:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbYCIBpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 20:45:38 -0500
Received: from mail.queued.net ([207.210.101.209]:2704 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273AbYCIBo4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 20:44:56 -0500
Date: Sat, 8 Mar 2008 20:48:33 -0500
From: Andres Salomon <dilinger@queued.net>
To: adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       info-linux@geode.amd.com, Jordan Crouse <jordan.crouse@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/6] gxfb: clean up register definitions
Message-ID: <20080308204833.56791446@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: this is a continuation of prior gxfb patches, and also depends upon the
MSR cleanup patch.  All those patches can be found here:

http://git.infradead.org/?p=geode.git;a=summary

This one simply makes register definitions consistent w/ the data book,
saving much sanity when attempting to double-check that register handling
is correct (especially in the later power management patches).



>From 38f7c2c2032c96bcd86c26771d06909e81aacca9 Mon Sep 17 00:00:00 2001
From: Andres Salomon <dilinger@debian.org>
Date: Mon, 25 Feb 2008 13:12:14 -0500
Subject: [PATCH] gxfb: clean up register definitions

This does the following in preparation for register saving:
  - moves the register definitions from video_gx.h and display_gx.h into
    gxfb.h.
  - renames GX_* registers to match their section (ie, VP_).
  - renames register bitfields to match the data sheet (ie,
    DC_DCFG_TGEN -> DC_DISPLAY_CFG_TGEN).
  - for DC registers, rather than defining to specific addresses, use
    an enum to number them sequentially and just multiply by 4(bytes) to
    access them (in read_dc/write_dc).
  - for VP and FP registers, use an enum and multiple by 8 (bytes).  They're
    64bit registers.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/geode/display_gx.c |   28 +++---
 drivers/video/geode/display_gx.h |   78 --------------
 drivers/video/geode/gxfb.h       |  220 ++++++++++++++++++++++++++++++++++++-
 drivers/video/geode/video_gx.c   |   92 ++++++++--------
 drivers/video/geode/video_gx.h   |   39 -------
 5 files changed, 275 insertions(+), 182 deletions(-)

diff --git a/drivers/video/geode/display_gx.c b/drivers/video/geode/display_gx.c
index ca8ab30..351468d 100644
--- a/drivers/video/geode/display_gx.c
+++ b/drivers/video/geode/display_gx.c
@@ -51,20 +51,21 @@ static void gx_set_mode(struct fb_info *info)
 	int vactive, vblankstart, vsyncstart, vsyncend, vblankend, vtotal;
 
 	/* Unlock the display controller registers. */
-	write_dc(DC_UNLOCK, DC_UNLOCK_CODE);
+	write_dc(DC_UNLOCK, DC_UNLOCK_UNLOCK);
 
 	gcfg = read_dc(DC_GENERAL_CFG);
 	dcfg = read_dc(DC_DISPLAY_CFG);
 
 	/* Disable the timing generator. */
-	dcfg &= ~(DC_DCFG_TGEN);
+	dcfg &= ~DC_DISPLAY_CFG_TGEN;
 	write_dc(DC_DISPLAY_CFG, dcfg);
 
 	/* Wait for pending memory requests before disabling the FIFO load. */
 	udelay(100);
 
 	/* Disable FIFO load and compression. */
-	gcfg &= ~(DC_GCFG_DFLE | DC_GCFG_CMPE | DC_GCFG_DECE);
+	gcfg &= ~(DC_GENERAL_CFG_DFLE | DC_GENERAL_CFG_CMPE |
+			DC_GENERAL_CFG_DECE);
 	write_dc(DC_GENERAL_CFG, gcfg);
 
 	/* Setup DCLK and its divisor. */
@@ -75,12 +76,13 @@ static void gx_set_mode(struct fb_info *info)
 	 */
 
 	/* Clear all unused feature bits. */
-	gcfg &= DC_GCFG_YUVM | DC_GCFG_VDSE;
+	gcfg &= DC_GENERAL_CFG_YUVM | DC_GENERAL_CFG_VDSE;
 	dcfg = 0;
 
 	/* Set FIFO priority (default 6/5) and enable. */
 	/* FIXME: increase fifo priority for 1280x1024 and higher modes? */
-	gcfg |= (6 << DC_GCFG_DFHPEL_POS) | (5 << DC_GCFG_DFHPSL_POS) | DC_GCFG_DFLE;
+	gcfg |= (6 << DC_GENERAL_CFG_DFHPEL_SHIFT) |
+		(5 << DC_GENERAL_CFG_DFHPSL_SHIFT) | DC_GENERAL_CFG_DFLE;
 
 	/* Framebuffer start offset. */
 	write_dc(DC_FB_ST_OFFSET, 0);
@@ -92,25 +94,25 @@ static void gx_set_mode(struct fb_info *info)
 
 
 	/* Enable graphics and video data and unmask address lines. */
-	dcfg |= DC_DCFG_GDEN | DC_DCFG_VDEN | DC_DCFG_A20M | DC_DCFG_A18M;
+	dcfg |= DC_DISPLAY_CFG_GDEN | DC_DISPLAY_CFG_VDEN |
+		DC_DISPLAY_CFG_A20M | DC_DISPLAY_CFG_A18M;
 
 	/* Set pixel format. */
 	switch (info->var.bits_per_pixel) {
 	case 8:
-		dcfg |= DC_DCFG_DISP_MODE_8BPP;
+		dcfg |= DC_DISPLAY_CFG_DISP_MODE_8BPP;
 		break;
 	case 16:
-		dcfg |= DC_DCFG_DISP_MODE_16BPP;
-		dcfg |= DC_DCFG_16BPP_MODE_565;
+		dcfg |= DC_DISPLAY_CFG_DISP_MODE_16BPP;
 		break;
 	case 32:
-		dcfg |= DC_DCFG_DISP_MODE_24BPP;
-		dcfg |= DC_DCFG_PALB;
+		dcfg |= DC_DISPLAY_CFG_DISP_MODE_24BPP;
+		dcfg |= DC_DISPLAY_CFG_PALB;
 		break;
 	}
 
 	/* Enable timing generator. */
-	dcfg |= DC_DCFG_TGEN;
+	dcfg |= DC_DISPLAY_CFG_TGEN;
 
 	/* Horizontal and vertical timings. */
 	hactive = info->var.xres;
@@ -144,7 +146,7 @@ static void gx_set_mode(struct fb_info *info)
 	par->vid_ops->configure_display(info);
 
 	/* Relock display controller registers */
-	write_dc(DC_UNLOCK, 0);
+	write_dc(DC_UNLOCK, DC_UNLOCK_LOCK);
 }
 
 static void gx_set_hw_palette_reg(struct fb_info *info, unsigned regno,
diff --git a/drivers/video/geode/display_gx.h b/drivers/video/geode/display_gx.h
index df94e4f..56e9d2e 100644
--- a/drivers/video/geode/display_gx.h
+++ b/drivers/video/geode/display_gx.h
@@ -19,82 +19,4 @@ extern struct geode_dc_ops gx_dc_ops;
 /* MSR that tells us if a TFT or CRT is attached */
 #define GLD_MSR_CONFIG_DM_FP 0x40
 
-/* Display controller registers */
-
-#define DC_UNLOCK 0x00
-#  define DC_UNLOCK_CODE 0x00004758
-
-#define DC_GENERAL_CFG 0x04
-#  define DC_GCFG_DFLE	      0x00000001
-#  define DC_GCFG_CURE	      0x00000002
-#  define DC_GCFG_ICNE	      0x00000004
-#  define DC_GCFG_VIDE	      0x00000008
-#  define DC_GCFG_CMPE	      0x00000020
-#  define DC_GCFG_DECE	      0x00000040
-#  define DC_GCFG_VGAE	      0x00000080
-#  define DC_GCFG_DFHPSL_MASK 0x00000F00
-#  define DC_GCFG_DFHPSL_POS	       8
-#  define DC_GCFG_DFHPEL_MASK 0x0000F000
-#  define DC_GCFG_DFHPEL_POS	      12
-#  define DC_GCFG_STFM	      0x00010000
-#  define DC_GCFG_FDTY	      0x00020000
-#  define DC_GCFG_VGAFT	      0x00040000
-#  define DC_GCFG_VDSE	      0x00080000
-#  define DC_GCFG_YUVM	      0x00100000
-#  define DC_GCFG_VFSL	      0x00800000
-#  define DC_GCFG_SIGE	      0x01000000
-#  define DC_GCFG_SGRE	      0x02000000
-#  define DC_GCFG_SGFR	      0x04000000
-#  define DC_GCFG_CRC_MODE    0x08000000
-#  define DC_GCFG_DIAG	      0x10000000
-#  define DC_GCFG_CFRW	      0x20000000
-
-#define DC_DISPLAY_CFG 0x08
-#  define DC_DCFG_TGEN            0x00000001
-#  define DC_DCFG_GDEN            0x00000008
-#  define DC_DCFG_VDEN            0x00000010
-#  define DC_DCFG_TRUP            0x00000040
-#  define DC_DCFG_DISP_MODE_MASK  0x00000300
-#  define DC_DCFG_DISP_MODE_8BPP  0x00000000
-#  define DC_DCFG_DISP_MODE_16BPP 0x00000100
-#  define DC_DCFG_DISP_MODE_24BPP 0x00000200
-#  define DC_DCFG_16BPP_MODE_MASK 0x00000c00
-#  define DC_DCFG_16BPP_MODE_565  0x00000000
-#  define DC_DCFG_16BPP_MODE_555  0x00000100
-#  define DC_DCFG_16BPP_MODE_444  0x00000200
-#  define DC_DCFG_DCEN            0x00080000
-#  define DC_DCFG_PALB            0x02000000
-#  define DC_DCFG_FRLK            0x04000000
-#  define DC_DCFG_VISL            0x08000000
-#  define DC_DCFG_FRSL            0x20000000
-#  define DC_DCFG_A18M            0x40000000
-#  define DC_DCFG_A20M            0x80000000
-
-#define DC_FB_ST_OFFSET 0x10
-
-#define DC_LINE_SIZE 0x30
-#  define DC_LINE_SIZE_FB_LINE_SIZE_MASK  0x000007ff
-#  define DC_LINE_SIZE_FB_LINE_SIZE_POS            0
-#  define DC_LINE_SIZE_CB_LINE_SIZE_MASK  0x007f0000
-#  define DC_LINE_SIZE_CB_LINE_SIZE_POS           16
-#  define DC_LINE_SIZE_VID_LINE_SIZE_MASK 0xff000000
-#  define DC_LINE_SIZE_VID_LINE_SIZE_POS          24
-
-#define DC_GFX_PITCH 0x34
-#  define DC_GFX_PITCH_FB_PITCH_MASK 0x0000ffff
-#  define DC_GFX_PITCH_FB_PITCH_POS           0
-#  define DC_GFX_PITCH_CB_PITCH_MASK 0xffff0000
-#  define DC_GFX_PITCH_CB_PITCH_POS          16
-
-#define DC_H_ACTIVE_TIMING 0x40
-#define DC_H_BLANK_TIMING  0x44
-#define DC_H_SYNC_TIMING   0x48
-#define DC_V_ACTIVE_TIMING 0x50
-#define DC_V_BLANK_TIMING  0x54
-#define DC_V_SYNC_TIMING   0x58
-
-#define DC_PAL_ADDRESS 0x70
-#define DC_PAL_DATA    0x74
-
-#define DC_GLIU0_MEM_OFFSET 0x84
 #endif /* !__DISPLAY_GX1_H__ */
diff --git a/drivers/video/geode/gxfb.h b/drivers/video/geode/gxfb.h
index 9775915..3367fdc 100644
--- a/drivers/video/geode/gxfb.h
+++ b/drivers/video/geode/gxfb.h
@@ -12,15 +12,223 @@
 #define _GXFB_H_
 
 
-#define read_dc(reg)		readl(par->dc_regs + (reg))
-#define write_dc(reg, val)	writel((val), par->dc_regs + (reg))
+/* Display Controller registers (table 6-38 from the data book) */
+enum dc_registers {
+	DC_UNLOCK = 0,
+	DC_GENERAL_CFG,
+	DC_DISPLAY_CFG,
+	DC_RSVD_0,
 
-#define read_vp(reg)		readl(par->vid_regs + (reg))
+	DC_FB_ST_OFFSET,
+	DC_CB_ST_OFFSET,
+	DC_CURS_ST_OFFSET,
+	DC_ICON_ST_OFFSET,
+
+	DC_VID_Y_ST_OFFSET,
+	DC_VID_U_ST_OFFSET,
+	DC_VID_V_ST_OFFSET,
+	DC_RSVD_1,
+
+	DC_LINE_SIZE,
+	DC_GFX_PITCH,
+	DC_VID_YUV_PITCH,
+	DC_RSVD_2,
+
+	DC_H_ACTIVE_TIMING,
+	DC_H_BLANK_TIMING,
+	DC_H_SYNC_TIMING,
+	DC_RSVD_3,
+
+	DC_V_ACTIVE_TIMING,
+	DC_V_BLANK_TIMING,
+	DC_V_SYNC_TIMING,
+	DC_RSVD_4,
+
+	DC_CURSOR_X,
+	DC_CURSOR_Y,
+	DC_ICON_X,
+	DC_LINE_CNT,
+
+	DC_PAL_ADDRESS,
+	DC_PAL_DATA,
+	DC_DFIFO_DIAG,
+	DC_CFIFO_DIAG,
+
+	DC_VID_DS_DELTA,
+	DC_GLIU0_MEM_OFFSET,
+	DC_RSVD_5,
+	DC_DV_ACC, /* 0x8c */
+};
+
+#define DC_UNLOCK_LOCK			0x00000000
+#define DC_UNLOCK_UNLOCK		0x00004758	/* magic value */
+
+#define DC_GENERAL_CFG_YUVM		(1 << 20)
+#define DC_GENERAL_CFG_VDSE		(1 << 19)
+#define DC_GENERAL_CFG_DFHPEL_SHIFT	12
+#define DC_GENERAL_CFG_DFHPSL_SHIFT	8
+#define DC_GENERAL_CFG_DECE		(1 << 6)
+#define DC_GENERAL_CFG_CMPE		(1 << 5)
+#define DC_GENERAL_CFG_VIDE		(1 << 3)
+#define DC_GENERAL_CFG_ICNE		(1 << 2)
+#define DC_GENERAL_CFG_CURE		(1 << 1)
+#define DC_GENERAL_CFG_DFLE		(1 << 0)
+
+#define DC_DISPLAY_CFG_A20M		(1 << 31)
+#define DC_DISPLAY_CFG_A18M		(1 << 30)
+#define DC_DISPLAY_CFG_PALB		(1 << 25)
+#define DC_DISPLAY_CFG_DISP_MODE_24BPP	(1 << 9)
+#define DC_DISPLAY_CFG_DISP_MODE_16BPP	(1 << 8)
+#define DC_DISPLAY_CFG_DISP_MODE_8BPP	(0)
+#define DC_DISPLAY_CFG_VDEN		(1 << 4)
+#define DC_DISPLAY_CFG_GDEN		(1 << 3)
+#define DC_DISPLAY_CFG_TGEN		(1 << 0)
+
+
+/*
+ * Video Processor registers (table 6-54).
+ * There is space for 64 bit values, but we never use more than the
+ * lower 32 bits.  The actual register save/restore code only bothers
+ * to restore those 32 bits.
+ */
+enum vp_registers {
+	VP_VCFG = 0,
+	VP_DCFG,
+
+	VP_VX,
+	VP_VY,
+
+	VP_VS,
+	VP_VCK,
+
+	VP_VCM,
+	VP_GAR,
+
+	VP_GDR,
+	VP_RSVD_0,
+
+	VP_MISC,
+	VP_CCS,
+
+	VP_RSVD_1,
+	VP_RSVD_2,
+
+	VP_RSVD_3,
+	VP_VDC,
+
+	VP_VCO,
+	VP_CRC,
+
+	VP_CRC32,
+	VP_VDE,
+
+	VP_CCK,
+	VP_CCM,
+
+	VP_CC1,
+	VP_CC2,
+
+	VP_A1X,
+	VP_A1Y,
+
+	VP_A1C,
+	VP_A1T,
+
+	VP_A2X,
+	VP_A2Y,
+
+	VP_A2C,
+	VP_A2T,
+
+	VP_A3X,
+	VP_A3Y,
+
+	VP_A3C,
+	VP_A3T,
+
+	VP_VRR,
+	VP_AWT,
+
+	VP_VTM, /* 0x130 */
+};
+
+#define VP_VCFG_VID_EN			(1 << 0)
+
+#define VP_DCFG_DAC_VREF		(1 << 26)
+#define VP_DCFG_GV_GAM			(1 << 21)
+#define VP_DCFG_VG_CK			(1 << 20)
+#define VP_DCFG_CRT_SYNC_SKW_DEFAULT	(1 << 16)
+#define VP_DCFG_CRT_SYNC_SKW		((1 << 14) | (1 << 15) | (1 << 16))
+#define VP_DCFG_CRT_VSYNC_POL		(1 << 9)
+#define VP_DCFG_CRT_HSYNC_POL		(1 << 8)
+#define VP_DCFG_FP_DATA_EN		(1 << 7)	/* undocumented */
+#define VP_DCFG_FP_PWR_EN		(1 << 6)	/* undocumented */
+#define VP_DCFG_DAC_BL_EN		(1 << 3)
+#define VP_DCFG_VSYNC_EN		(1 << 2)
+#define VP_DCFG_HSYNC_EN		(1 << 1)
+#define VP_DCFG_CRT_EN			(1 << 0)
+
+#define VP_MISC_GAM_EN			(1 << 0)
+#define VP_MISC_DACPWRDN		(1 << 10)
+#define VP_MISC_APWRDN			(1 << 11)
+
+
+/*
+ * Flat Panel registers (table 6-55).
+ * Also 64 bit registers; see above note about 32-bit handling.
+ */
+
+/* we're actually in the VP register space, starting at address 0x400 */
+#define VP_FP_START		0x400
+
+enum fp_registers {
+	FP_PT1 = 0,
+	FP_PT2,
+
+	FP_PM,
+	FP_DFC,
+
+	FP_BLFSR,
+	FP_RLFSR,
+
+	FP_FMI,
+	FP_FMD,
+
+	FP_RSVD_0,
+	FP_DCA,
+
+	FP_DMD,
+	FP_CRC,
+
+	FP_FBB, /* 0x460 */
+};
+
+#define FP_PT1_VSIZE_SHIFT		16		/* undocumented? */
+#define FP_PT1_VSIZE_MASK		0x7FF0000	/* undocumented? */
+
+#define FP_PT2_HSP			(1 << 22)
+#define FP_PT2_VSP			(1 << 23)
+
+#define FP_PM_P				(1 << 24)       /* panel power on */
+#define FP_PM_PANEL_PWR_UP		(1 << 3)        /* r/o */
+#define FP_PM_PANEL_PWR_DOWN		(1 << 2)        /* r/o */
+#define FP_PM_PANEL_OFF			(1 << 1)        /* r/o */
+#define FP_PM_PANEL_ON			(1 << 0)        /* r/o */
+
+#define FP_DFC_NFI			((1 << 4) | (1 << 5) | (1 << 6))
+
+
+/* register access functions */
+
+#define read_dc(reg)		readl(par->dc_regs + 4*(reg))
+#define write_dc(reg, val)	writel((val), par->dc_regs + 4*(reg))
+
+#define read_vp(reg)		readl(par->vid_regs + 8*(reg))
 #define write_vp(reg, val)	writel((uint32_t) (val), \
-					par->vid_regs + (reg))
+					par->vid_regs + 8*(reg))
 
-#define read_fp(reg)		readl(par->vid_regs + (reg))
+#define read_fp(reg)		readl(par->vid_regs + 8*(reg) + VP_FP_START)
 #define write_fp(reg, val)	writel((uint32_t) (val), \
-					par->vid_regs + (reg))
+					par->vid_regs + 8*(reg) + VP_FP_START)
 
 #endif
diff --git a/drivers/video/geode/video_gx.c b/drivers/video/geode/video_gx.c
index de43e29..51b03b7 100644
--- a/drivers/video/geode/video_gx.c
+++ b/drivers/video/geode/video_gx.c
@@ -193,16 +193,16 @@ gx_configure_tft(struct fb_info *info)
 
 	/* Turn off the panel */
 
-	fp = read_fp(GX_FP_PM);
-	fp &= ~GX_FP_PM_P;
-	write_fp(GX_FP_PM, fp);
+	fp = read_fp(FP_PM);
+	fp &= ~FP_PM_P;
+	write_fp(FP_PM, fp);
 
 	/* Set timing 1 */
 
-	fp = read_fp(GX_FP_PT1);
-	fp &= GX_FP_PT1_VSIZE_MASK;
-	fp |= info->var.yres << GX_FP_PT1_VSIZE_SHIFT;
-	write_fp(GX_FP_PT1, fp);
+	fp = read_fp(FP_PT1);
+	fp &= FP_PT1_VSIZE_MASK;
+	fp |= info->var.yres << FP_PT1_VSIZE_SHIFT;
+	write_fp(FP_PT1, fp);
 
 	/* Timing 2 */
 	/* Set bits that are always on for TFT */
@@ -212,27 +212,27 @@ gx_configure_tft(struct fb_info *info)
 	/* Configure sync polarity */
 
 	if (!(info->var.sync & FB_SYNC_VERT_HIGH_ACT))
-		fp |= GX_FP_PT2_VSP;
+		fp |= FP_PT2_VSP;
 
 	if (!(info->var.sync & FB_SYNC_HOR_HIGH_ACT))
-		fp |= GX_FP_PT2_HSP;
+		fp |= FP_PT2_HSP;
 
-	write_fp(GX_FP_PT2, fp);
+	write_fp(FP_PT2, fp);
 
 	/*  Set the dither control */
-	write_fp(GX_FP_DFC, 0x70);
+	write_fp(FP_DFC, FP_DFC_NFI);
 
 	/* Enable the FP data and power (in case the BIOS didn't) */
 
-	fp = read_vp(GX_DCFG);
-	fp |= GX_DCFG_FP_PWR_EN | GX_DCFG_FP_DATA_EN;
-	write_vp(GX_DCFG, fp);
+	fp = read_vp(VP_DCFG);
+	fp |= VP_DCFG_FP_PWR_EN | VP_DCFG_FP_DATA_EN;
+	write_vp(VP_DCFG, fp);
 
 	/* Unblank the panel */
 
-	fp = read_fp(GX_FP_PM);
-	fp |= GX_FP_PM_P;
-	write_fp(GX_FP_PM, fp);
+	fp = read_fp(FP_PM);
+	fp |= FP_PM_P;
+	write_fp(FP_PM, fp);
 }
 
 static void gx_configure_display(struct fb_info *info)
@@ -241,55 +241,55 @@ static void gx_configure_display(struct fb_info *info)
 	u32 dcfg, misc;
 
 	/* Write the display configuration */
-	dcfg = read_vp(GX_DCFG);
+	dcfg = read_vp(VP_DCFG);
 
 	/* Disable hsync and vsync */
-	dcfg &= ~(GX_DCFG_VSYNC_EN | GX_DCFG_HSYNC_EN);
-	write_vp(GX_DCFG, dcfg);
+	dcfg &= ~(VP_DCFG_VSYNC_EN | VP_DCFG_HSYNC_EN);
+	write_vp(VP_DCFG, dcfg);
 
 	/* Clear bits from existing mode. */
-	dcfg &= ~(GX_DCFG_CRT_SYNC_SKW_MASK
-		  | GX_DCFG_CRT_HSYNC_POL   | GX_DCFG_CRT_VSYNC_POL
-		  | GX_DCFG_VSYNC_EN        | GX_DCFG_HSYNC_EN);
+	dcfg &= ~(VP_DCFG_CRT_SYNC_SKW
+		  | VP_DCFG_CRT_HSYNC_POL   | VP_DCFG_CRT_VSYNC_POL
+		  | VP_DCFG_VSYNC_EN        | VP_DCFG_HSYNC_EN);
 
 	/* Set default sync skew.  */
-	dcfg |= GX_DCFG_CRT_SYNC_SKW_DFLT;
+	dcfg |= VP_DCFG_CRT_SYNC_SKW_DEFAULT;
 
 	/* Enable hsync and vsync. */
-	dcfg |= GX_DCFG_HSYNC_EN | GX_DCFG_VSYNC_EN;
+	dcfg |= VP_DCFG_HSYNC_EN | VP_DCFG_VSYNC_EN;
 
-	misc = read_vp(GX_MISC);
+	misc = read_vp(VP_MISC);
 
 	/* Disable gamma correction */
-	misc |= GX_MISC_GAM_EN;
+	misc |= VP_MISC_GAM_EN;
 
 	if (par->enable_crt) {
 
 		/* Power up the CRT DACs */
-		misc &= ~(GX_MISC_A_PWRDN | GX_MISC_DAC_PWRDN);
-		write_vp(GX_MISC, misc);
+		misc &= ~(VP_MISC_APWRDN | VP_MISC_DACPWRDN);
+		write_vp(VP_MISC, misc);
 
 		/* Only change the sync polarities if we are running
 		 * in CRT mode.  The FP polarities will be handled in
 		 * gxfb_configure_tft */
 		if (!(info->var.sync & FB_SYNC_HOR_HIGH_ACT))
-			dcfg |= GX_DCFG_CRT_HSYNC_POL;
+			dcfg |= VP_DCFG_CRT_HSYNC_POL;
 		if (!(info->var.sync & FB_SYNC_VERT_HIGH_ACT))
-			dcfg |= GX_DCFG_CRT_VSYNC_POL;
+			dcfg |= VP_DCFG_CRT_VSYNC_POL;
 	} else {
 		/* Power down the CRT DACs if in FP mode */
-		misc |= (GX_MISC_A_PWRDN | GX_MISC_DAC_PWRDN);
-		write_vp(GX_MISC, misc);
+		misc |= (VP_MISC_APWRDN | VP_MISC_DACPWRDN);
+		write_vp(VP_MISC, misc);
 	}
 
 	/* Enable the display logic */
 	/* Set up the DACS to blank normally */
 
-	dcfg |= GX_DCFG_CRT_EN | GX_DCFG_DAC_BL_EN;
+	dcfg |= VP_DCFG_CRT_EN | VP_DCFG_DAC_BL_EN;
 
 	/* Enable the external DAC VREF? */
 
-	write_vp(GX_DCFG, dcfg);
+	write_vp(VP_DCFG, dcfg);
 
 	/* Set up the flat panel (if it is enabled) */
 
@@ -323,26 +323,26 @@ static int gx_blank_display(struct fb_info *info, int blank_mode)
 	default:
 		return -EINVAL;
 	}
-	dcfg = read_vp(GX_DCFG);
-	dcfg &= ~(GX_DCFG_DAC_BL_EN
-		  | GX_DCFG_HSYNC_EN | GX_DCFG_VSYNC_EN);
+	dcfg = read_vp(VP_DCFG);
+	dcfg &= ~(VP_DCFG_DAC_BL_EN
+		  | VP_DCFG_HSYNC_EN | VP_DCFG_VSYNC_EN);
 	if (!blank)
-		dcfg |= GX_DCFG_DAC_BL_EN;
+		dcfg |= VP_DCFG_DAC_BL_EN;
 	if (hsync)
-		dcfg |= GX_DCFG_HSYNC_EN;
+		dcfg |= VP_DCFG_HSYNC_EN;
 	if (vsync)
-		dcfg |= GX_DCFG_VSYNC_EN;
-	write_vp(GX_DCFG, dcfg);
+		dcfg |= VP_DCFG_VSYNC_EN;
+	write_vp(VP_DCFG, dcfg);
 
 	/* Power on/off flat panel. */
 
 	if (par->enable_crt == 0) {
-		fp_pm = read_fp(GX_FP_PM);
+		fp_pm = read_fp(FP_PM);
 		if (blank_mode == FB_BLANK_POWERDOWN)
-			fp_pm &= ~GX_FP_PM_P;
+			fp_pm &= ~FP_PM_P;
 		else
-			fp_pm |= GX_FP_PM_P;
-		write_fp(GX_FP_PM, fp_pm);
+			fp_pm |= FP_PM_P;
+		write_fp(FP_PM, fp_pm);
 	}
 
 	return 0;
diff --git a/drivers/video/geode/video_gx.h b/drivers/video/geode/video_gx.h
index d21bca0..5457bd0 100644
--- a/drivers/video/geode/video_gx.h
+++ b/drivers/video/geode/video_gx.h
@@ -17,45 +17,6 @@ extern struct geode_vid_ops gx_vid_ops;
 #define GX_VP_PAD_SELECT_MASK          0x3FFFFFFF
 #define GX_VP_PAD_SELECT_TFT           0x1FFFFFFF
 
-/* Geode GX video processor registers */
-
-#define GX_DCFG		0x0008
-#  define GX_DCFG_CRT_EN		0x00000001
-#  define GX_DCFG_HSYNC_EN		0x00000002
-#  define GX_DCFG_VSYNC_EN		0x00000004
-#  define GX_DCFG_DAC_BL_EN		0x00000008
-#  define GX_DCFG_FP_PWR_EN		0x00000040
-#  define GX_DCFG_FP_DATA_EN		0x00000080
-#  define GX_DCFG_CRT_HSYNC_POL		0x00000100
-#  define GX_DCFG_CRT_VSYNC_POL		0x00000200
-#  define GX_DCFG_CRT_SYNC_SKW_MASK	0x0001C000
-#  define GX_DCFG_CRT_SYNC_SKW_DFLT	0x00010000
-#  define GX_DCFG_VG_CK			0x00100000
-#  define GX_DCFG_GV_GAM		0x00200000
-#  define GX_DCFG_DAC_VREF		0x04000000
-
-/* Geode GX MISC video configuration */
-
-#define GX_MISC 0x50
-#define GX_MISC_GAM_EN     0x00000001
-#define GX_MISC_DAC_PWRDN  0x00000400
-#define GX_MISC_A_PWRDN    0x00000800
-
-/* Geode GX flat panel display control registers */
-
-#define GX_FP_PT1 0x0400
-#define GX_FP_PT1_VSIZE_MASK 0x7FF0000
-#define GX_FP_PT1_VSIZE_SHIFT 16
-
-#define GX_FP_PT2 0x408
-#define GX_FP_PT2_VSP (1 << 23)
-#define GX_FP_PT2_HSP (1 << 22)
-
-#define GX_FP_PM 0x410
-#  define GX_FP_PM_P 0x01000000
-
-#define GX_FP_DFC 0x418
-
 /* Geode GX clock control MSRs */
 
 #  define MSR_GLCP_SYS_RSTPLL_DOTPREDIV2	(0x0000000000000002ull)
-- 
1.5.3.7

