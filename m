Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956Ab0ANK03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab0ANK03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 05:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932093Ab0ANK02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 05:26:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48296 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755716Ab0ANK00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 05:26:26 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, stable@kernel.org
Subject: [PATCH 2.6.33] s3c-fb: Fix divide by zero and broken output
Date: Thu, 14 Jan 2010 10:26:23 +0000
Message-Id: <1263464783-14434-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100114102027.GC437@rakim.wolfsonmicro.main>
References: <20100114102027.GC437@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 600ce1a0faafeed1ce6bcfd421bc040b941cbbc1.  ("fix clock setting
for Samsung SoC Framebuffer") introduced a mandatory refresh parameter
to the platform data for the S3C framebuffer but did not introduce any
validation code, causing existing platforms (none of which have refresh
set) to divide by zero whenever the framebuffer is configured,
generating warnings and unusable output.

Ben Dooks noted several problems with the patch:

 - The platform data supplies the pixclk directly and should already
   have taken care of the refresh rate.
 - The addition of a window ID parameter doesn't help since only the
   root framebuffer can control the pixclk.
 - pixclk is specified in picoseconds (rather than Hz) as the patch
   assumed.

and suggests reverting the commit so do that.  Without fixing this no
mainline user of the driver will produce output.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@kernel.org
---
 drivers/video/s3c-fb.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
index adf9632..e2e7afd 100644
--- a/drivers/video/s3c-fb.c
+++ b/drivers/video/s3c-fb.c
@@ -211,21 +211,23 @@ static int s3c_fb_check_var(struct fb_var_screeninfo *var,
 
 /**
  * s3c_fb_calc_pixclk() - calculate the divider to create the pixel clock.
- * @id: window id.
  * @sfb: The hardware state.
  * @pixclock: The pixel clock wanted, in picoseconds.
  *
  * Given the specified pixel clock, work out the necessary divider to get
  * close to the output frequency.
  */
-static int s3c_fb_calc_pixclk(unsigned char id, struct s3c_fb *sfb, unsigned int pixclk)
+static int s3c_fb_calc_pixclk(struct s3c_fb *sfb, unsigned int pixclk)
 {
-	struct s3c_fb_pd_win *win = sfb->pdata->win[id];
 	unsigned long clk = clk_get_rate(sfb->bus_clk);
+	unsigned long long tmp;
 	unsigned int result;
 
-	pixclk *= win->win_mode.refresh;
-	result = clk / pixclk;
+	tmp = (unsigned long long)clk;
+	tmp *= pixclk;
+
+	do_div(tmp, 1000000000UL);
+	result = (unsigned int)tmp / 1000;
 
 	dev_dbg(sfb->dev, "pixclk=%u, clk=%lu, div=%d (%lu)\n",
 		pixclk, clk, result, clk / result);
@@ -265,7 +267,6 @@ static int s3c_fb_set_par(struct fb_info *info)
 	struct s3c_fb *sfb = win->parent;
 	void __iomem *regs = sfb->regs;
 	int win_no = win->index;
-	u32 osdc_data = 0;
 	u32 data;
 	u32 pagewidth;
 	int clkdiv;
@@ -301,7 +302,7 @@ static int s3c_fb_set_par(struct fb_info *info)
 	/* use window 0 as the basis for the lcd output timings */
 
 	if (win_no == 0) {
-		clkdiv = s3c_fb_calc_pixclk(win_no, sfb, var->pixclock);
+		clkdiv = s3c_fb_calc_pixclk(sfb, var->pixclock);
 
 		data = sfb->pdata->vidcon0;
 		data &= ~(VIDCON0_CLKVAL_F_MASK | VIDCON0_CLKDIR);
@@ -358,6 +359,8 @@ static int s3c_fb_set_par(struct fb_info *info)
 
 	data = var->xres * var->yres;
 
+	u32 osdc_data = 0;
+
 	osdc_data = VIDISD14C_ALPHA1_R(0xf) |
 		VIDISD14C_ALPHA1_G(0xf) |
 		VIDISD14C_ALPHA1_B(0xf);
-- 
1.6.6

