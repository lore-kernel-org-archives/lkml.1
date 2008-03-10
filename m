Return-Path: <linux-kernel-owner+w=401wt.eu-S1752346AbYCJNxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbYCJNxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 09:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbYCJNww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 09:52:52 -0400
Received: from mail.atmel.fr ([81.80.104.162]:61166 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbYCJNwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 09:52:51 -0400
Message-ID: <47D53CFC.8050907@atmel.com>
Date: Mon, 10 Mar 2008 14:51:56 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-fbdev-devel@lists.sourceforge.net,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>
CC: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       David Brownell <david-b@pacbell.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Sedji GAOUAOU <sedji.gaouaou@atmel.com>,
       Patrice VILCHEZ <patrice.vilchez@atmel.com>,
       Andrew Victor <linux@maxim.org.za>
Subject: [PATCH] atmel_lcdfb: suspend/resume support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Teach atmel_lcdfb driver how to suspend/resume.

Note that the backlight control should probably do more of the same stuff:
turning off display power (more than just the backlight) and stopping the
clocks (and dma to drive the no-longer-seen display).  No point in wasting
power to generate images that can't be observed, after all...

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
It applies on top of :
atmel_lcdfb-dont-initialize-a-pre-allocated-framebuffer.patch
already in the -mm tree.

 drivers/video/atmel_lcdfb.c |   36 ++++++++++++++++++++++++++++++++++--
 include/video/atmel_lcdc.h  |    1 +
 2 files changed, 35 insertions(+), 2 deletions(-)

--- linux-2.6.x-rc.orig/drivers/video/atmel_lcdfb.c
+++ linux-2.6.x-rc/drivers/video/atmel_lcdfb.c
@@ -909,10 +909,42 @@ static int __exit atmel_lcdfb_remove(str
 	return 0;
 }
 
+#ifdef CONFIG_PM
+
+static int atmel_lcdfb_suspend(struct platform_device *pdev, pm_message_t mesg)
+{
+	struct fb_info *info = platform_get_drvdata(pdev);
+	struct atmel_lcdfb_info *sinfo = info->par;
+
+	sinfo->saved_lcdcon = lcdc_readl(sinfo, ATMEL_LCDC_CONTRAST_VAL);
+	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_CTR, 0);
+	if (sinfo->atmel_lcdfb_power_control)
+		sinfo->atmel_lcdfb_power_control(0);
+	atmel_lcdfb_stop_clock(sinfo);
+	return 0;
+}
+
+static int atmel_lcdfb_resume(struct platform_device *pdev)
+{
+	struct fb_info *info = platform_get_drvdata(pdev);
+	struct atmel_lcdfb_info *sinfo = info->par;
+
+	atmel_lcdfb_start_clock(sinfo);
+	if (sinfo->atmel_lcdfb_power_control)
+		sinfo->atmel_lcdfb_power_control(1);
+	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_CTR, sinfo->saved_lcdcon);
+	return 0;
+}
+
+#else
+#define atmel_lcdfb_suspend	NULL
+#define atmel_lcdfb_resume	NULL
+#endif
+
 static struct platform_driver atmel_lcdfb_driver = {
 	.remove		= __exit_p(atmel_lcdfb_remove),
-
-// FIXME need suspend, resume
+	.suspend	= atmel_lcdfb_suspend,
+	.resume		= atmel_lcdfb_resume,
 
 	.driver		= {
 		.name	= "atmel_lcdfb",
--- linux-2.6.x-rc.orig/include/video/atmel_lcdc.h
+++ linux-2.6.x-rc/include/video/atmel_lcdc.h
@@ -39,6 +39,7 @@ struct atmel_lcdfb_info {
 	u8			bl_power;
 #endif
 	bool			lcdcon_is_backlight;
+	u8			saved_lcdcon;
 
 	u8			default_bpp;
 	unsigned int		default_lcdcon2;

