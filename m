Return-Path: <linux-kernel-owner+w=401wt.eu-S1756448AbYFFKfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbYFFKfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 06:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbYFFKfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 06:35:03 -0400
Received: from mail.atmel.fr ([81.80.104.162]:64227 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663AbYFFKfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 06:35:00 -0400
Message-ID: <484912C5.6040708@atmel.com>
Date: Fri, 06 Jun 2008 12:34:45 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-fbdev-devel-bounces@lists.sourceforge.net,
       "Antonino A. Daplas" <adaplas@gmail.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: [RFC PATCH] atmel_lcdfb: avoid division by zero
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid division by zero in  atmel_lcdfb_check_var() function.

If pixclock is not specified while passing a var structure in 
the check_var() funtion, a division by zero occurs (when 
translating pixclock to KHz).

This patch adds a checking of this value and try to choose a 
video mode in the modelist.

The mode found in the probe function in added to the modelist.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Please tell me if it is a proper way to implement a mean of 
having a good var in check_var() function.
Is an -EINVAL error is legitimate in the case of a zero value 
for pixclock or bits_per_pixel (if I cannot find a good modeline) ?

 drivers/video/atmel_lcdfb.c |   36 ++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index b004036..f2e8d1b 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -256,6 +256,21 @@ static int atmel_lcdfb_alloc_video_memory(struct atmel_lcdfb_info *sinfo)
 	return 0;
 }
 
+static const struct fb_videomode *atmel_lcdfb_choose_mode(struct fb_var_screeninfo *var,
+						     struct fb_info *info)
+{
+	struct fb_videomode varfbmode;
+	const struct fb_videomode *fbmode = NULL;
+
+	fb_var_to_videomode(&varfbmode, var);
+	fbmode = fb_find_nearest_mode(&varfbmode, &info->modelist);
+	if (fbmode) {
+		fb_videomode_to_var(var, fbmode);
+	}
+	return fbmode;
+}
+
+
 /**
  *      atmel_lcdfb_check_var - Validates a var passed in.
  *      @var: frame buffer variable screen structure
@@ -289,6 +304,15 @@ static int atmel_lcdfb_check_var(struct fb_var_screeninfo *var,
 	clk_value_khz = clk_get_rate(sinfo->lcdc_clk) / 1000;
 
 	dev_dbg(dev, "%s:\n", __func__);
+
+	if (!(var->pixclock && var->bits_per_pixel)) {
+		/* choose a suitable mode if possible */
+		if (!atmel_lcdfb_choose_mode(var, info)) {
+			dev_err(dev, "needed value not specified\n");
+			return -EINVAL;
+		}
+	}
+
 	dev_dbg(dev, "  resolution: %ux%u\n", var->xres, var->yres);
 	dev_dbg(dev, "  pixclk:     %lu KHz\n", PICOS2KHZ(var->pixclock));
 	dev_dbg(dev, "  bpp:        %u\n", var->bits_per_pixel);
@@ -299,6 +323,13 @@ static int atmel_lcdfb_check_var(struct fb_var_screeninfo *var,
 		return -EINVAL;
 	}
 
+	/* Do not allow to have real resoulution larger than virtual */
+	if (var->xres > var->xres_virtual)
+		var->xres_virtual = var->xres;
+
+	if (var->yres > var->yres_virtual)
+		var->yres_virtual = var->yres;
+
 	/* Force same alignment for each line */
 	var->xres = (var->xres + 3) & ~3UL;
 	var->xres_virtual = (var->xres_virtual + 3) & ~3UL;
@@ -691,6 +722,7 @@ static int __init atmel_lcdfb_probe(struct platform_device *pdev)
 	struct fb_info *info;
 	struct atmel_lcdfb_info *sinfo;
 	struct atmel_lcdfb_info *pdata_sinfo;
+	struct fb_videomode fbmode;
 	struct resource *regs = NULL;
 	struct resource *map = NULL;
 	int ret;
@@ -853,6 +885,10 @@ static int __init atmel_lcdfb_probe(struct platform_device *pdev)
 		goto free_cmap;
 	}
 
+	/* add selected videomode to modelist */
+	fb_var_to_videomode(&fbmode, &info->var);
+	fb_add_videomode(&fbmode, &info->modelist);
+
 	/* Power up the LCDC screen */
 	if (sinfo->atmel_lcdfb_power_control)
 		sinfo->atmel_lcdfb_power_control(1);



