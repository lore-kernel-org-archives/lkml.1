Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbZCLOC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbZCLOC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 10:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbZCLOCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 10:02:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:54362 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754299AbZCLOCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 10:02:48 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX199vyRWaGV98zp9br+pmQiKZI1RBXt0awZi7qT1G4
	31Gkk1G3SbCMll
Date: Thu, 12 Mar 2009 15:02:54 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Dan Williams <dan.j.williams@intel.com>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, adaplas@gmail.com
Subject: [PATCH] i.MX31: fix panning, error handling, clean up
Message-ID: <Pine.LNX.4.64.0903121455050.4896@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. check for errors returned from clk_get()
2. fix "Unbalanced enable for IRQ 160"
3. fix transmit descriptor handling in panning
4. clean frame buffer on blank - useful for OLED displays
5. formatting clean up

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---

I was told drivers/video is sort of orphan (cc-ing the official maintainer 
in case this is not true), so, don't know to whom I actually shall send 
this. Originally the driver went in over Dan's dmaengine tree, so, he is 
on CC, the driver is for i.MX3x SoCs, hence Sascha Hauer, as a last 
resort, maybe Andrew will agree to take it directly.

 drivers/video/mx3fb.c |   56 +++++++++++++++++++++++++++---------------------
 1 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
index 3e84635..02014d2 100644
--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -400,12 +400,12 @@ static void sdc_disable_channel(struct mx3fb_info *mx3_fbi)
 static int sdc_set_window_pos(struct mx3fb_data *mx3fb, enum ipu_channel channel,
 			      int16_t x_pos, int16_t y_pos)
 {
-	x_pos += mx3fb->h_start_width;
-	y_pos += mx3fb->v_start_width;
-
 	if (channel != IDMAC_SDC_0)
 		return -EINVAL;
 
+	x_pos += mx3fb->h_start_width;
+	y_pos += mx3fb->v_start_width;
+
 	mx3fb_write_reg(mx3fb, (x_pos << 16) | y_pos, SDC_BG_POS);
 	return 0;
 }
@@ -491,11 +491,13 @@ static int sdc_init_panel(struct mx3fb_data *mx3fb, enum ipu_panel panel,
 	 * 2^4 to get fractional part, as long as we stay under ~250MHz and on
 	 * i.MX31 it (HSP_CLK) is <= 178MHz. Currently 128.267MHz
 	 */
-	dev_dbg(mx3fb->dev, "pixel clk = %d\n", pixel_clk);
-
 	ipu_clk = clk_get(mx3fb->dev, "ipu_clk");
-	div = clk_get_rate(ipu_clk) * 16 / pixel_clk;
-	clk_put(ipu_clk);
+	if (!IS_ERR(ipu_clk)) {
+		div = clk_get_rate(ipu_clk) * 16 / pixel_clk;
+		clk_put(ipu_clk);
+	} else {
+		div = 0;
+	}
 
 	if (div < 0x40) {	/* Divider less than 4 */
 		dev_dbg(mx3fb->dev,
@@ -503,6 +505,9 @@ static int sdc_init_panel(struct mx3fb_data *mx3fb, enum ipu_panel panel,
 		div = 0x40;
 	}
 
+	dev_dbg(mx3fb->dev, "pixel clk = %u, divider %u.%u\n",
+		pixel_clk, div >> 4, (div & 7) * 125);
+
 	spin_lock_irqsave(&mx3fb->lock, lock_flags);
 
 	/*
@@ -515,16 +520,16 @@ static int sdc_init_panel(struct mx3fb_data *mx3fb, enum ipu_panel panel,
 	/* DI settings */
 	old_conf = mx3fb_read_reg(mx3fb, DI_DISP_IF_CONF) & 0x78FFFFFF;
 	old_conf |= sig.datamask_en << DI_D3_DATAMSK_SHIFT |
-	    sig.clksel_en << DI_D3_CLK_SEL_SHIFT |
-	    sig.clkidle_en << DI_D3_CLK_IDLE_SHIFT;
+		sig.clksel_en << DI_D3_CLK_SEL_SHIFT |
+		sig.clkidle_en << DI_D3_CLK_IDLE_SHIFT;
 	mx3fb_write_reg(mx3fb, old_conf, DI_DISP_IF_CONF);
 
 	old_conf = mx3fb_read_reg(mx3fb, DI_DISP_SIG_POL) & 0xE0FFFFFF;
 	old_conf |= sig.data_pol << DI_D3_DATA_POL_SHIFT |
-	    sig.clk_pol << DI_D3_CLK_POL_SHIFT |
-	    sig.enable_pol << DI_D3_DRDY_SHARP_POL_SHIFT |
-	    sig.Hsync_pol << DI_D3_HSYNC_POL_SHIFT |
-	    sig.Vsync_pol << DI_D3_VSYNC_POL_SHIFT;
+		sig.clk_pol << DI_D3_CLK_POL_SHIFT |
+		sig.enable_pol << DI_D3_DRDY_SHARP_POL_SHIFT |
+		sig.Hsync_pol << DI_D3_HSYNC_POL_SHIFT |
+		sig.Vsync_pol << DI_D3_VSYNC_POL_SHIFT;
 	mx3fb_write_reg(mx3fb, old_conf, DI_DISP_SIG_POL);
 
 	switch (pixel_fmt) {
@@ -721,7 +726,6 @@ static int mx3fb_set_par(struct fb_info *fbi)
 	struct idmac_channel *ichan = mx3_fbi->idmac_channel;
 	struct idmac_video_param *video = &ichan->params.video;
 	struct scatterlist *sg = mx3_fbi->sg;
-	size_t screen_size;
 
 	dev_dbg(mx3fb->dev, "%s [%c]\n", __func__, list_empty(&ichan->queue) ? '-' : '+');
 
@@ -745,12 +749,10 @@ static int mx3fb_set_par(struct fb_info *fbi)
 		}
 	}
 
-	screen_size = fbi->fix.line_length * fbi->var.yres;
-
 	sg_init_table(&sg[0], 1);
 	sg_init_table(&sg[1], 1);
 
-	sg_dma_address(&sg[0])	= fbi->fix.smem_start;
+	sg_dma_address(&sg[0]) = fbi->fix.smem_start;
 	sg_set_page(&sg[0], virt_to_page(fbi->screen_base),
 		    fbi->fix.smem_len,
 		    offset_in_page(fbi->screen_base));
@@ -927,7 +929,7 @@ static int mx3fb_setcolreg(unsigned int regno, unsigned int red,
 	u32 val;
 	int ret = 1;
 
-	dev_dbg(fbi->device, "%s\n", __func__);
+	dev_dbg(fbi->device, "%s, regno = %u\n", __func__, regno);
 
 	mutex_lock(&mx3_fbi->mutex);
 	/*
@@ -973,9 +975,8 @@ static int mx3fb_blank(int blank, struct fb_info *fbi)
 	struct mx3fb_info *mx3_fbi = fbi->par;
 	struct mx3fb_data *mx3fb = mx3_fbi->mx3fb;
 
-	dev_dbg(fbi->device, "%s\n", __func__);
-
-	dev_dbg(fbi->device, "blank = %d\n", blank);
+	dev_dbg(fbi->device, "%s, blank = %d, base %p, len %u\n", __func__,
+		blank, fbi->screen_base, fbi->fix.smem_len);
 
 	if (mx3_fbi->blank == blank)
 		return 0;
@@ -988,8 +989,11 @@ static int mx3fb_blank(int blank, struct fb_info *fbi)
 	case FB_BLANK_VSYNC_SUSPEND:
 	case FB_BLANK_HSYNC_SUSPEND:
 	case FB_BLANK_NORMAL:
-		sdc_disable_channel(mx3_fbi);
 		sdc_set_brightness(mx3fb, 0);
+		memset((char *)fbi->screen_base, 0, fbi->fix.smem_len);
+		/* Give LCD time to update - enough for 50 and 60 Hz */
+		msleep(25);
+		sdc_disable_channel(mx3_fbi);
 		break;
 	case FB_BLANK_UNBLANK:
 		sdc_enable_channel(mx3_fbi);
@@ -1063,6 +1067,7 @@ static int mx3fb_pan_display(struct fb_var_screeninfo *var,
 		mutex_unlock(&mx3_fbi->mutex);
 		dev_info(fbi->device, "Panning failed due to %s\n", ret < 0 ?
 			 "user interrupt" : "timeout");
+		disable_irq(mx3_fbi->idmac_channel->eof_irq);
 		return ret ? : -ETIMEDOUT;
 	}
 
@@ -1073,6 +1078,9 @@ static int mx3fb_pan_display(struct fb_var_screeninfo *var,
 		    virt_to_page(fbi->screen_base + offset), fbi->fix.smem_len,
 		    offset_in_page(fbi->screen_base + offset));
 
+	if (mx3_fbi->txd)
+		async_tx_ack(mx3_fbi->txd);
+
 	txd = dma_chan->device->device_prep_slave_sg(dma_chan, sg +
 		mx3_fbi->cur_ipu_buf, 1, DMA_TO_DEVICE, DMA_PREP_INTERRUPT);
 	if (!txd) {
@@ -1099,8 +1107,6 @@ static int mx3fb_pan_display(struct fb_var_screeninfo *var,
 		return -EIO;
 	}
 
-	if (mx3_fbi->txd)
-		async_tx_ack(mx3_fbi->txd);
 	mx3_fbi->txd = txd;
 
 	fbi->var.xoffset = var->xoffset;
@@ -1506,7 +1512,7 @@ static struct platform_driver mx3fb_driver = {
  * example:
  * 	video=mx3fb:bpp=16
  */
-static int mx3fb_setup(void)
+static int __init mx3fb_setup(void)
 {
 #ifndef MODULE
 	char *opt, *options = NULL;
-- 
1.5.4

