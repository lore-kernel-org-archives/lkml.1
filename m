Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbXKWPjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbXKWPjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 10:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756121AbXKWPix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 10:38:53 -0500
Received: from mail.atmel.fr ([81.80.104.162]:45412 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756111AbXKWPiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 10:38:52 -0500
X-Greylist: delayed 1600 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Nov 2007 10:38:51 EST
Message-ID: <4746EDD6.6060301@atmel.com>
Date: Fri, 23 Nov 2007 16:12:22 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net
CC: Andrew Victor <linux@maxim.org.za>,
       Patrice Vilchez <patrice.vilchez@atmel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Anti Sullin <anti.sullin@artecdesign.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] atmel_lcdfb: LCDC startup fix
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anti Sullin <anti.sullin@artecdesign.ee>

This patch adds an additional loop, that delays turning off the DMA 
until the LCDC core has been turned off. This prevents the picture 
to be shifted some random length when the kernel re-initializes
the LCDC.

Signed-off-by: Anti Sullin <anti.sullin@artecdesign.ee>
Signed-off-by: Andrew Victor <andrew@sanpeople.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---

Without this patch, the LCDC keeps running for some small time 
after the PWRCON:LCD_PWR has been cleared ; the FIFO suffers 
an underrun and on re-starting the LCDC the FIFO data 
stays shifted.
This behavior has been seen and fixed on AT91SAM9261-EK and 
two custom AT91SAM9261 boards, all of them having different 
LCD panels.

Thanks a lot to Anti Sullin for submitting this patch (long 
time ago).

--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -268,6 +268,10 @@
 	/* Turn off the LCD controller and the DMA controller */
 	lcdc_writel(sinfo, ATMEL_LCDC_PWRCON, sinfo->guard_time << ATMEL_LCDC_GUARDT_OFFSET);
 
+	/* Wait for the LCDC core to become idle */
+	while (lcdc_readl(sinfo, ATMEL_LCDC_PWRCON) & ATMEL_LCDC_BUSY)
+		msleep(10);
+
 	lcdc_writel(sinfo, ATMEL_LCDC_DMACON, 0);
 
 	if (info->var.bits_per_pixel == 1)
