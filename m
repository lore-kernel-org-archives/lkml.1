Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbYAXJbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbYAXJbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 04:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYAXJbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 04:31:32 -0500
Received: from mail.atmel.fr ([81.80.104.162]:40072 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbYAXJba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 04:31:30 -0500
Message-ID: <47985AC4.9070104@atmel.com>
Date: Thu, 24 Jan 2008 10:30:44 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-fbdev-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       Andrew Victor <linux@maxim.org.za>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [Linux-fbdev-devel] [PATCH] atmel_lcdfb: backlight control -
 tiny rework
References: <4790BB53.3080407@atmel.com>
In-Reply-To: <4790BB53.3080407@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tiny patch that removes not needed "inline" and renames 
function : exit_contrast() -> exit_backlight().
It adds the missing exit_backlight() in  probe() 
error path.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Follows comments from Andrew Morton and Haavard Skinnemoen.
Thanks to both of you.

 drivers/video/atmel_lcdfb.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -118,7 +118,7 @@ static struct backlight_ops atmel_lcdc_b
 	.get_brightness = atmel_bl_get_brightness,
 };
 
-static inline void init_backlight(struct atmel_lcdfb_info *sinfo)
+static void init_backlight(struct atmel_lcdfb_info *sinfo)
 {
 	struct backlight_device	*bl;
 
@@ -142,7 +142,7 @@ static inline void init_backlight(struct
 	bl->props.brightness = atmel_bl_get_brightness(bl);
 }
 
-static inline void exit_contrast(struct atmel_lcdfb_info *sinfo)
+static void exit_backlight(struct atmel_lcdfb_info *sinfo)
 {
 	if (sinfo->backlight)
 		backlight_device_unregister(sinfo->backlight);
@@ -150,18 +150,18 @@ static inline void exit_contrast(struct 
 
 #else
 
-static inline void init_backlight(struct atmel_lcdfb_info *sinfo)
+static void init_backlight(struct atmel_lcdfb_info *sinfo)
 {
 	dev_warn(&sinfo->pdev->dev, "backlight control is not available\n");
 }
 
-static inline void exit_contrast(struct atmel_lcdfb_info *sinfo)
+static void exit_backlight(struct atmel_lcdfb_info *sinfo)
 {
 }
 
 #endif
 
-static inline void init_contrast(struct atmel_lcdfb_info *sinfo)
+static void init_contrast(struct atmel_lcdfb_info *sinfo)
 {
 	/* have some default contrast/backlight settings */
 	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_CTR, contrast_ctr);
@@ -823,6 +823,7 @@ free_cmap:
 unregister_irqs:
 	free_irq(sinfo->irq_base, info);
 unmap_mmio:
+	exit_backlight(sinfo);
 	iounmap(sinfo->mmio);
 release_mem:
  	release_mem_region(info->fix.mmio_start, info->fix.mmio_len);
@@ -857,7 +858,7 @@ static int __exit atmel_lcdfb_remove(str
 	if (!sinfo)
 		return 0;
 
-	exit_contrast(sinfo);
+	exit_backlight(sinfo);
 	if (sinfo->atmel_lcdfb_power_control)
 		sinfo->atmel_lcdfb_power_control(0);
 	unregister_framebuffer(info);


