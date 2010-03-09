Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab0CIQTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:19:40 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:47886 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118Ab0CIQTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:19:36 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH] fbdev: bfin-lq035q1-fb: respect new PPI mode platform field
Date: Tue,  9 Mar 2010 11:22:52 -0500
Message-Id: <1268151772-28815-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

This lets us support the new BF527-EZKIT V2.1 via platform resources
tweaks only.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/video/bfin-lq035q1-fb.c |  252 ++++++++++++++++++++++----------------
 1 files changed, 146 insertions(+), 106 deletions(-)

diff --git a/drivers/video/bfin-lq035q1-fb.c b/drivers/video/bfin-lq035q1-fb.c
index 0387236..0c50de9 100644
--- a/drivers/video/bfin-lq035q1-fb.c
+++ b/drivers/video/bfin-lq035q1-fb.c
@@ -60,47 +60,13 @@
 #define LCD_X_RES		320	/* Horizontal Resolution */
 #define LCD_Y_RES		240	/* Vertical Resolution */
 #define	DMA_BUS_SIZE		16
+#define U_LINE			4	/* Blanking Lines */
 
-#define USE_RGB565_16_BIT_PPI
-
-#ifdef USE_RGB565_16_BIT_PPI
-#define LCD_BPP		16	/* Bit Per Pixel */
-#define CLOCKS_PER_PIX	1
-#define CPLD_PIPELINE_DELAY_COR 0	/* NO CPLB */
-#endif
 
 /* Interface 16/18-bit TFT over an 8-bit wide PPI using a small Programmable Logic Device (CPLD)
  * http://blackfin.uclinux.org/gf/project/stamp/frs/?action=FrsReleaseBrowse&frs_package_id=165
  */
 
-#ifdef USE_RGB565_8_BIT_PPI
-#define LCD_BPP		16	/* Bit Per Pixel */
-#define CLOCKS_PER_PIX	2
-#define CPLD_PIPELINE_DELAY_COR 3	/* RGB565 */
-#endif
-
-#ifdef USE_RGB888_8_BIT_PPI
-#define LCD_BPP		24	/* Bit Per Pixel */
-#define CLOCKS_PER_PIX	3
-#define CPLD_PIPELINE_DELAY_COR 5	/* RGB888 */
-#endif
-
-	/*
-	 * HS and VS timing parameters (all in number of PPI clk ticks)
-	 */
-
-#define U_LINE		4				/* Blanking Lines */
-
-#define H_ACTPIX	(LCD_X_RES * CLOCKS_PER_PIX)	/* active horizontal pixel */
-#define H_PERIOD	(336 * CLOCKS_PER_PIX)		/* HS period */
-#define H_PULSE		(2 * CLOCKS_PER_PIX)				/* HS pulse width */
-#define H_START		(7 * CLOCKS_PER_PIX + CPLD_PIPELINE_DELAY_COR)	/* first valid pixel */
-
-#define	V_LINES		(LCD_Y_RES + U_LINE)		/* total vertical lines */
-#define V_PULSE		(2 * CLOCKS_PER_PIX)		/* VS pulse width (1-5 H_PERIODs) */
-#define V_PERIOD	(H_PERIOD * V_LINES)		/* VS period */
-
-#define ACTIVE_VIDEO_MEM_OFFSET		((U_LINE / 2) * LCD_X_RES * (LCD_BPP / 8))
 
 #define BFIN_LCD_NBR_PALETTE_ENTRIES	256
 
@@ -109,12 +75,6 @@
 #define PPI_PORT_CFG_01			0x10
 #define PPI_POLS_1			0x8000
 
-#if (CLOCKS_PER_PIX > 1)
-#define PPI_PMODE (DLEN_8 | PACK_EN)
-#else
-#define PPI_PMODE (DLEN_16)
-#endif
-
 #define LQ035_INDEX			0x74
 #define LQ035_DATA			0x76
 
@@ -138,6 +98,15 @@ struct bfin_lq035q1fb_info {
 	int irq;
 	spinlock_t lock;	/* lock */
 	u32 pseudo_pal[16];
+
+	u32 lcd_bpp;
+	u32 h_actpix;
+	u32 h_period;
+	u32 h_pulse;
+	u32 h_start;
+	u32 v_lines;
+	u32 v_pulse;
+	u32 v_period;
 };
 
 static int nocursor;
@@ -233,16 +202,69 @@ static int lq035q1_backlight(struct bfin_lq035q1fb_info *info, unsigned arg)
 	return 0;
 }
 
+static int bfin_lq035q1_calc_timing(struct bfin_lq035q1fb_info *fbi)
+{
+	unsigned long clocks_per_pix, cpld_pipeline_delay_cor;
+
+	/*
+	 * Interface 16/18-bit TFT over an 8-bit wide PPI using a small
+	 * Programmable Logic Device (CPLD)
+	 * http://blackfin.uclinux.org/gf/project/stamp/frs/?action=FrsReleaseBrowse&frs_package_id=165
+	 */
+
+	switch (fbi->disp_info->ppi_mode) {
+	case USE_RGB565_16_BIT_PPI:
+		fbi->lcd_bpp = 16;
+		clocks_per_pix = 1;
+		cpld_pipeline_delay_cor = 0;
+		break;
+	case USE_RGB565_8_BIT_PPI:
+		fbi->lcd_bpp = 16;
+		clocks_per_pix = 2;
+		cpld_pipeline_delay_cor = 3;
+		break;
+	case USE_RGB888_8_BIT_PPI:
+		fbi->lcd_bpp = 24;
+		clocks_per_pix = 3;
+		cpld_pipeline_delay_cor = 5;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/*
+	 * HS and VS timing parameters (all in number of PPI clk ticks)
+	 */
+
+	fbi->h_actpix = (LCD_X_RES * clocks_per_pix);	/* active horizontal pixel */
+	fbi->h_period = (336 * clocks_per_pix);		/* HS period */
+	fbi->h_pulse = (2 * clocks_per_pix);				/* HS pulse width */
+	fbi->h_start = (7 * clocks_per_pix + cpld_pipeline_delay_cor);	/* first valid pixel */
+
+	fbi->v_lines = (LCD_Y_RES + U_LINE);		/* total vertical lines */
+	fbi->v_pulse = (2 * clocks_per_pix);		/* VS pulse width (1-5 H_PERIODs) */
+	fbi->v_period =	(fbi->h_period * fbi->v_lines);	/* VS period */
+
+	return 0;
+}
+
 static void bfin_lq035q1_config_ppi(struct bfin_lq035q1fb_info *fbi)
 {
-	bfin_write_PPI_DELAY(H_START);
-	bfin_write_PPI_COUNT(H_ACTPIX - 1);
-	bfin_write_PPI_FRAME(V_LINES);
+	unsigned ppi_pmode;
+
+	if (fbi->disp_info->ppi_mode == USE_RGB565_16_BIT_PPI)
+		ppi_pmode = DLEN_16;
+	else
+		ppi_pmode = (DLEN_8 | PACK_EN);
+
+	bfin_write_PPI_DELAY(fbi->h_start);
+	bfin_write_PPI_COUNT(fbi->h_actpix - 1);
+	bfin_write_PPI_FRAME(fbi->v_lines);
 
 	bfin_write_PPI_CONTROL(PPI_TX_MODE |	   /* output mode , PORT_DIR */
 				PPI_XFER_TYPE_11 | /* sync mode XFR_TYPE */
 				PPI_PORT_CFG_01 |  /* two frame sync PORT_CFG */
-				PPI_PMODE |	   /* 8/16 bit data length / PACK_EN? */
+				ppi_pmode |	   /* 8/16 bit data length / PACK_EN? */
 				PPI_POLS_1);	   /* faling edge syncs POLS */
 }
 
@@ -271,19 +293,19 @@ static void bfin_lq035q1_stop_timers(void)
 
 }
 
-static void bfin_lq035q1_init_timers(void)
+static void bfin_lq035q1_init_timers(struct bfin_lq035q1fb_info *fbi)
 {
 
 	bfin_lq035q1_stop_timers();
 
-	set_gptimer_period(TIMER_HSYNC_id, H_PERIOD);
-	set_gptimer_pwidth(TIMER_HSYNC_id, H_PULSE);
+	set_gptimer_period(TIMER_HSYNC_id, fbi->h_period);
+	set_gptimer_pwidth(TIMER_HSYNC_id, fbi->h_pulse);
 	set_gptimer_config(TIMER_HSYNC_id, TIMER_MODE_PWM | TIMER_PERIOD_CNT |
 				      TIMER_TIN_SEL | TIMER_CLK_SEL|
 				      TIMER_EMU_RUN);
 
-	set_gptimer_period(TIMER_VSYNC_id, V_PERIOD);
-	set_gptimer_pwidth(TIMER_VSYNC_id, V_PULSE);
+	set_gptimer_period(TIMER_VSYNC_id, fbi->v_period);
+	set_gptimer_pwidth(TIMER_VSYNC_id, fbi->v_pulse);
 	set_gptimer_config(TIMER_VSYNC_id, TIMER_MODE_PWM | TIMER_PERIOD_CNT |
 				      TIMER_TIN_SEL | TIMER_CLK_SEL |
 				      TIMER_EMU_RUN);
@@ -293,21 +315,21 @@ static void bfin_lq035q1_init_timers(void)
 static void bfin_lq035q1_config_dma(struct bfin_lq035q1fb_info *fbi)
 {
 
+
 	set_dma_config(CH_PPI,
 		       set_bfin_dma_config(DIR_READ, DMA_FLOW_AUTO,
 					   INTR_DISABLE, DIMENSION_2D,
 					   DATA_SIZE_16,
 					   DMA_NOSYNC_KEEP_DMA_BUF));
-	set_dma_x_count(CH_PPI, (LCD_X_RES * LCD_BPP) / DMA_BUS_SIZE);
+	set_dma_x_count(CH_PPI, (LCD_X_RES * fbi->lcd_bpp) / DMA_BUS_SIZE);
 	set_dma_x_modify(CH_PPI, DMA_BUS_SIZE / 8);
-	set_dma_y_count(CH_PPI, V_LINES);
+	set_dma_y_count(CH_PPI, fbi->v_lines);
 
 	set_dma_y_modify(CH_PPI, DMA_BUS_SIZE / 8);
 	set_dma_start_addr(CH_PPI, (unsigned long)fbi->fb_buffer);
 
 }
 
-#if (CLOCKS_PER_PIX == 1)
 static const u16 ppi0_req_16[] = {P_PPI0_CLK, P_PPI0_FS1, P_PPI0_FS2,
 			    P_PPI0_D0, P_PPI0_D1, P_PPI0_D2,
 			    P_PPI0_D3, P_PPI0_D4, P_PPI0_D5,
@@ -315,22 +337,27 @@ static const u16 ppi0_req_16[] = {P_PPI0_CLK, P_PPI0_FS1, P_PPI0_FS2,
 			    P_PPI0_D9, P_PPI0_D10, P_PPI0_D11,
 			    P_PPI0_D12, P_PPI0_D13, P_PPI0_D14,
 			    P_PPI0_D15, 0};
-#else
-static const u16 ppi0_req_16[] = {P_PPI0_CLK, P_PPI0_FS1, P_PPI0_FS2,
+
+static const u16 ppi0_req_8[] = {P_PPI0_CLK, P_PPI0_FS1, P_PPI0_FS2,
 			    P_PPI0_D0, P_PPI0_D1, P_PPI0_D2,
 			    P_PPI0_D3, P_PPI0_D4, P_PPI0_D5,
 			    P_PPI0_D6, P_PPI0_D7, 0};
-#endif
 
-static inline void bfin_lq035q1_free_ports(void)
+static inline void bfin_lq035q1_free_ports(unsigned ppi16)
 {
-	peripheral_free_list(ppi0_req_16);
+	if (ppi16)
+		peripheral_free_list(ppi0_req_16);
+	else
+		peripheral_free_list(ppi0_req_8);
+
 	if (ANOMALY_05000400)
 		gpio_free(P_IDENT(P_PPI0_FS3));
 }
 
-static int __devinit bfin_lq035q1_request_ports(struct platform_device *pdev)
+static int __devinit bfin_lq035q1_request_ports(struct platform_device *pdev,
+						unsigned ppi16)
 {
+	int ret;
 	/* ANOMALY_05000400 - PPI Does Not Start Properly In Specific Mode:
 	 * Drive PPI_FS3 Low
 	 */
@@ -341,7 +368,12 @@ static int __devinit bfin_lq035q1_request_ports(struct platform_device *pdev)
 		gpio_direction_output(P_IDENT(P_PPI0_FS3), 0);
 	}
 
-	if (peripheral_request_list(ppi0_req_16, DRIVER_NAME)) {
+	if (ppi16)
+		ret = peripheral_request_list(ppi0_req_16, DRIVER_NAME);
+	else
+		ret = peripheral_request_list(ppi0_req_8, DRIVER_NAME);
+
+	if (ret) {
 		dev_err(&pdev->dev, "requesting peripherals failed\n");
 		return -EFAULT;
 	}
@@ -363,7 +395,7 @@ static int bfin_lq035q1_fb_open(struct fb_info *info, int user)
 
 		bfin_lq035q1_config_dma(fbi);
 		bfin_lq035q1_config_ppi(fbi);
-		bfin_lq035q1_init_timers();
+		bfin_lq035q1_init_timers(fbi);
 
 		/* start dma */
 		enable_dma(CH_PPI);
@@ -401,12 +433,9 @@ static int bfin_lq035q1_fb_release(struct fb_info *info, int user)
 static int bfin_lq035q1_fb_check_var(struct fb_var_screeninfo *var,
 				     struct fb_info *info)
 {
-	switch (var->bits_per_pixel) {
-#if (LCD_BPP == 24)
-	case 24:/* TRUECOLOUR, 16m */
-#else
-	case 16:/* DIRECTCOLOUR, 64k */
-#endif
+	struct bfin_lq035q1fb_info *fbi = info->par;
+
+	if (var->bits_per_pixel == fbi->lcd_bpp) {
 		var->red.offset = info->var.red.offset;
 		var->green.offset = info->var.green.offset;
 		var->blue.offset = info->var.blue.offset;
@@ -419,8 +448,7 @@ static int bfin_lq035q1_fb_check_var(struct fb_var_screeninfo *var,
 		var->red.msb_right = 0;
 		var->green.msb_right = 0;
 		var->blue.msb_right = 0;
-		break;
-	default:
+	} else {
 		pr_debug("%s: depth not supported: %u BPP\n", __func__,
 			 var->bits_per_pixel);
 		return -EINVAL;
@@ -527,6 +555,7 @@ static int __devinit bfin_lq035q1_probe(struct platform_device *pdev)
 {
 	struct bfin_lq035q1fb_info *info;
 	struct fb_info *fbinfo;
+	u32 active_video_mem_offset;
 	int ret;
 
 	ret = request_dma(CH_PPI, DRIVER_NAME"_CH_PPI");
@@ -549,6 +578,12 @@ static int __devinit bfin_lq035q1_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, fbinfo);
 
+	ret = bfin_lq035q1_calc_timing(info);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed PPI Mode\n");
+		goto out3;
+	}
+
 	strcpy(fbinfo->fix.id, DRIVER_NAME);
 
 	fbinfo->fix.type = FB_TYPE_PACKED_PIXELS;
@@ -570,46 +605,48 @@ static int __devinit bfin_lq035q1_probe(struct platform_device *pdev)
 	fbinfo->var.xres_virtual = LCD_X_RES;
 	fbinfo->var.yres = LCD_Y_RES;
 	fbinfo->var.yres_virtual = LCD_Y_RES;
-	fbinfo->var.bits_per_pixel = LCD_BPP;
+	fbinfo->var.bits_per_pixel = info->lcd_bpp;
 
 	if (info->disp_info->mode & LQ035_BGR) {
-#if (LCD_BPP == 24)
-		fbinfo->var.red.offset = 0;
-		fbinfo->var.green.offset = 8;
-		fbinfo->var.blue.offset = 16;
-#else
-		fbinfo->var.red.offset = 0;
-		fbinfo->var.green.offset = 5;
-		fbinfo->var.blue.offset = 11;
-#endif
+		if (info->lcd_bpp == 24) {
+			fbinfo->var.red.offset = 0;
+			fbinfo->var.green.offset = 8;
+			fbinfo->var.blue.offset = 16;
+		} else {
+			fbinfo->var.red.offset = 0;
+			fbinfo->var.green.offset = 5;
+			fbinfo->var.blue.offset = 11;
+		}
 	} else {
-#if (LCD_BPP == 24)
-		fbinfo->var.red.offset = 16;
-		fbinfo->var.green.offset = 8;
-		fbinfo->var.blue.offset = 0;
-#else
-		fbinfo->var.red.offset = 11;
-		fbinfo->var.green.offset = 5;
-		fbinfo->var.blue.offset = 0;
-#endif
+		if (info->lcd_bpp == 24) {
+			fbinfo->var.red.offset = 16;
+			fbinfo->var.green.offset = 8;
+			fbinfo->var.blue.offset = 0;
+		} else {
+			fbinfo->var.red.offset = 11;
+			fbinfo->var.green.offset = 5;
+			fbinfo->var.blue.offset = 0;
+		}
 	}
 
 	fbinfo->var.transp.offset = 0;
 
-#if (LCD_BPP == 24)
-	fbinfo->var.red.length = 8;
-	fbinfo->var.green.length = 8;
-	fbinfo->var.blue.length = 8;
-#else
-	fbinfo->var.red.length = 5;
-	fbinfo->var.green.length = 6;
-	fbinfo->var.blue.length = 5;
-#endif
+	if (info->lcd_bpp == 24) {
+		fbinfo->var.red.length = 8;
+		fbinfo->var.green.length = 8;
+		fbinfo->var.blue.length = 8;
+	} else {
+		fbinfo->var.red.length = 5;
+		fbinfo->var.green.length = 6;
+		fbinfo->var.blue.length = 5;
+	}
 
 	fbinfo->var.transp.length = 0;
 
-	fbinfo->fix.smem_len = LCD_X_RES * LCD_Y_RES * LCD_BPP / 8
-				+ ACTIVE_VIDEO_MEM_OFFSET;
+	active_video_mem_offset = ((U_LINE / 2) * LCD_X_RES * (info->lcd_bpp / 8));
+
+	fbinfo->fix.smem_len = LCD_X_RES * LCD_Y_RES * info->lcd_bpp / 8
+				+ active_video_mem_offset;
 
 	fbinfo->fix.line_length = fbinfo->var.xres_virtual *
 	    fbinfo->var.bits_per_pixel / 8;
@@ -628,8 +665,8 @@ static int __devinit bfin_lq035q1_probe(struct platform_device *pdev)
 		goto out3;
 	}
 
-	fbinfo->screen_base = (void *)info->fb_buffer + ACTIVE_VIDEO_MEM_OFFSET;
-	fbinfo->fix.smem_start = (int)info->fb_buffer + ACTIVE_VIDEO_MEM_OFFSET;
+	fbinfo->screen_base = (void *)info->fb_buffer + active_video_mem_offset;
+	fbinfo->fix.smem_start = (int)info->fb_buffer + active_video_mem_offset;
 
 	fbinfo->fbops = &bfin_lq035q1_fb_ops;
 
@@ -642,7 +679,8 @@ static int __devinit bfin_lq035q1_probe(struct platform_device *pdev)
 		goto out4;
 	}
 
-	ret = bfin_lq035q1_request_ports(pdev);
+	ret = bfin_lq035q1_request_ports(pdev,
+			info->disp_info->ppi_mode == USE_RGB565_16_BIT_PPI);
 	if (ret) {
 		dev_err(&pdev->dev, "couldn't request gpio port\n");
 		goto out6;
@@ -692,7 +730,7 @@ static int __devinit bfin_lq035q1_probe(struct platform_device *pdev)
 	}
 
 	dev_info(&pdev->dev, "%dx%d %d-bit RGB FrameBuffer initialized\n",
-		LCD_X_RES, LCD_Y_RES, LCD_BPP);
+		LCD_X_RES, LCD_Y_RES, info->lcd_bpp);
 
 	return 0;
 
@@ -704,7 +742,8 @@ static int __devinit bfin_lq035q1_probe(struct platform_device *pdev)
  out8:
 	free_irq(info->irq, info);
  out7:
-	bfin_lq035q1_free_ports();
+	bfin_lq035q1_free_ports(info->disp_info->ppi_mode ==
+				USE_RGB565_16_BIT_PPI);
  out6:
 	fb_dealloc_cmap(&fbinfo->cmap);
  out4:
@@ -741,7 +780,8 @@ static int __devexit bfin_lq035q1_remove(struct platform_device *pdev)
 
 	fb_dealloc_cmap(&fbinfo->cmap);
 
-	bfin_lq035q1_free_ports();
+	bfin_lq035q1_free_ports(info->disp_info->ppi_mode ==
+				USE_RGB565_16_BIT_PPI);
 
 	platform_set_drvdata(pdev, NULL);
 	framebuffer_release(fbinfo);
@@ -780,7 +820,7 @@ static int bfin_lq035q1_resume(struct device *dev)
 
 		bfin_lq035q1_config_dma(info);
 		bfin_lq035q1_config_ppi(info);
-		bfin_lq035q1_init_timers();
+		bfin_lq035q1_init_timers(info);
 
 		/* start dma */
 		enable_dma(CH_PPI);
-- 
1.7.0.2

