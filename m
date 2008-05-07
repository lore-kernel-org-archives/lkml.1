Return-Path: <linux-kernel-owner+w=401wt.eu-S1757683AbYEGJ4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683AbYEGJ4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 05:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbYEGJ4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 05:56:36 -0400
Received: from mail.atmel.fr ([81.80.104.162]:38673 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbYEGJ4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 05:56:34 -0400
Message-ID: <48218B3F.5030705@atmel.com>
Date: Wed, 07 May 2008 12:58:07 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Icedove 1.5.0.14pre (X11/20080208)
MIME-Version: 1.0
To: linux-arm-kernel@lists.arm.linux.org.uk,
       Andrew Victor <linux@maxim.org.za>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] atmel_lcdfb: fix initialization of a pre-allocated framebuffer
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix initialization of framebuffer not calling ioremap_writecombine() function 
and not using internal SRAM for at91sam9rl.

This is a little rework of the
"Don't initialize a pre-allocated framebuffer" patch that corrects the
call to ioremap_writecombine() function.

It also cuts the use of internal SRAM for at91sam9rl : it is a bit small
for a framebuffer.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91sam9261_devices.c |    4 ++--
 arch/arm/mach-at91/at91sam9rl_devices.c  |   21 ---------------------
 2 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
index 728bb8f..0babb64 100644
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -544,10 +544,10 @@ void __init at91_add_device_lcdc(struct atmel_lcdfb_info *data)
 		struct resource *fb_res = &lcdc_resources[2];
 		size_t fb_len = fb_res->end - fb_res->start + 1;
 
-		fb = ioremap_writecombine(fb_res->start, fb_len);
+		fb = ioremap(fb_res->start, fb_len);
 		if (fb) {
 			memset(fb, 0, fb_len);
-			iounmap(fb, fb_len);
+			iounmap(fb);
 		}
 	}
 	lcdc_data = *data;
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index 0546898..450db30 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -332,13 +332,6 @@ static struct resource lcdc_resources[] = {
 		.end	= AT91SAM9RL_ID_LCDC,
 		.flags	= IORESOURCE_IRQ,
 	},
-#if defined(CONFIG_FB_INTSRAM)
-	[2] = {
-		.start	= AT91SAM9RL_SRAM_BASE,
-		.end	= AT91SAM9RL_SRAM_BASE + AT91SAM9RL_SRAM_SIZE - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-#endif
 };
 
 static struct platform_device at91_lcdc_device = {
@@ -381,20 +374,6 @@ void __init at91_add_device_lcdc(struct atmel_lcdfb_info *data)
 	at91_set_B_periph(AT91_PIN_PC24, 0);	/* LCDD22 */
 	at91_set_B_periph(AT91_PIN_PC25, 0);	/* LCDD23 */
 
-#ifdef CONFIG_FB_INTSRAM
-	{
-		void __iomem *fb;
-		struct resource *fb_res = &lcdc_resources[2];
-		size_t fb_len = fb_res->end - fb_res->start + 1;
-
-		fb = ioremap_writecombine(fb_res->start, fb_len);
-		if (fb) {
-			memset(fb, 0, fb_len);
-			iounmap(fb, fb_len);
-		}
-	}
-#endif
-
 	lcdc_data = *data;
 	platform_device_register(&at91_lcdc_device);
 }
-- 
1.5.3.7

