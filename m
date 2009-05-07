Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbZEGEr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbZEGEr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 00:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbZEGErR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 00:47:17 -0400
Received: from mail-qy0-f125.google.com ([209.85.221.125]:50878 "EHLO
	mail-qy0-f125.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbZEGErQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 00:47:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=s7Tc6WQjnm25Dr4GcoODrxjoChI2wXuZLiGwrjNkFNtUX9IXSs0A+T1e40ovyDI3Ol
         NDNdqVONT/nSUMEqGXDsW9fJuYciO9nStDcBe45oTB2GcOYeRemTRghOCLt/28od+sWx
         dJxONa5PSMUNMr6Dq7WgI0hMvP1dXW5zvjgeI=
MIME-Version: 1.0
Date: Thu, 7 May 2009 13:47:16 +0900
Message-ID: <90b950fc0905062147w4673308ak54b9d8e348c23ad9@mail.gmail.com>
Subject: [PATCH] Alpha Channel support for Samsung SoC Framebuffer driver.
From: InKi Dae <daeinki@gmail.com>
To: ben-linux@fluff.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports ARGB1888 and ARGB4888 for Samsung SoC Framebuffer
driver. (s3c-fb.c)

ARGB1888 and ARGB4888 is decided by var->transp.length and this
variable is set by s3c_fb_check_var().
In s3c_fb_check_var(), if var->vits_per_pixel is 25 or 28, then
var->transp.length would be 1 or 3.
Therefore alpha mode(ARGB1888 or ARGB4888) could be decided through
that variable.


For using alpha mode, you need setting the following:
This code should be added to your machine code as platform data.

static struct s3c_fb_pd_win xxx_fb_win0 = {
	/* this is to ensure we use win0 */
	.win_mode = {
		.pixclock		= (8+8+8+240)*(38+4+38+400),
		.left_margin	= 8,
		.right_margin	= 8,
		.upper_margin	= 38,
		.lower_margin	= 38,
		.hsync_len		= 8,
		.vsync_len		= 4,
		.xres			= 240,
		.yres			= 400,
	},
	.max_bpp		= 32,
	.default_bpp	= 24,
};

static struct s3c_fb_pd_win xxx_fb_win1 = {
	.win_mode = {
		.pixclock		= (8+8+8+240)*(38+4+38+400),
		.left_margin	= 8,
		.right_margin	= 8,
		.upper_margin	= 38,
		.lower_margin	= 38,
		.hsync_len		= 8,
		.vsync_len		= 4,
		.xres			= 240,
		.yres			= 400,
	},
	.max_bpp		= 32,
	.default_bpp	= 28,
};


static struct s3c_fb_platdata xxx_lcd_pdata __initdata = {
	.win[0]		= &ncp_fb_win0,
	.win[1]		= &ncp_fb_win1,
	.vidcon0	= VIDCON0_VIDOUT_RGB | VIDCON0_PNRMODE_RGB,
	.vidcon1	= VIDCON1_INV_HSYNC | VIDCON1_INV_VSYNC,
	.setup_gpio	= xxx_fb_gpio_setup,
};

s3c_fb_set_platdata(&xxx_lcd_pdata);


Above code sets pixelformat for window0 layer to RGB888 and window1
layer to ARGB4888.
I'll look forward to applying to mainline.

signed-off-by: InKi Dae. <inki.dae@samsung.com>

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
index e0e7899..55d2298 100644
--- a/drivers/video/s3c-fb.c
+++ b/drivers/video/s3c-fb.c
@@ -358,9 +358,16 @@ static int s3c_fb_set_par(struct fb_info *info)
 writel(data, regs + VIDOSD_B(win_no));

 data = var->xres * var->yres;
+
+ u32 osdc_data = 0;
+
+ osdc_data = VIDISD14C_ALPHA1_R(0xf) |
+  VIDISD14C_ALPHA1_G(0xf) |
+  VIDISD14C_ALPHA1_B(0xf);
+
 if (s3c_fb_has_osd_d(win_no)) {
  writel(data, regs + VIDOSD_D(win_no));
-  writel(0, regs + VIDOSD_C(win_no));
+  writel(osdc_data, regs + VIDOSD_C(win_no));
 } else
  writel(data, regs + VIDOSD_C(win_no));

@@ -409,8 +416,12 @@ static int s3c_fb_set_par(struct fb_info *info)
    data |= WINCON1_BPPMODE_19BPP_A1666;
   else
    data |= WINCON1_BPPMODE_18BPP_666;
-  } else if (var->transp.length != 0)
-   data |= WINCON1_BPPMODE_25BPP_A1888;
+  } else if (var->transp.length == 1)
+   data |= WINCON1_BPPMODE_25BPP_A1888
+    | WINCON1_BLD_PIX;
+  else if (var->transp.length == 4)
+   data |= WINCON1_BPPMODE_28BPP_A4888
+    | WINCON1_BLD_PIX | WINCON1_ALPHA_SEL;
  else
   data |= WINCON0_BPPMODE_24BPP_888;

@@ -418,6 +429,20 @@ static int s3c_fb_set_par(struct fb_info *info)
  break;
 }

+ /* It has no color key control register for window0 */
+ if (win_no > 0) {
+  u32 keycon0_data = 0, keycon1_data = 0;
+
+  keycon0_data = ~(WxKEYCON0_KEYBL_EN |
+    WxKEYCON0_KEYEN_F |
+    WxKEYCON0_DIRCON) | WxKEYCON0_COMPKEY(0);
+
+  keycon1_data = WxKEYCON1_COLVAL(0xffffff);
+
+  writel(keycon0_data, regs + WxKEYCONy(win_no-1, 0));
+  writel(keycon1_data, regs + WxKEYCONy(win_no-1, 1));
+ }
+
 writel(data, regs + WINCON(win_no));
 writel(0x0, regs + WINxMAP(win_no));
