Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbZEJBa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbZEJBa2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 21:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbZEJBaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 21:30:19 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:50897
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755520AbZEJBaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 21:30:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuoCAPfKBUp8qMNV/2dsb2JhbAAIvgAIjleCLBgIgTIF
X-IronPort-AV: E=Sophos;i="4.40,322,1238947200"; 
   d="scan'208";a="434868748"
Subject: [PATCH] atmel-lcdc: Fix pixclock upper bound detection
From: Ben Nizette <bn@niasdigital.com>
To: nicolas.ferre@atmel.com
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       kernel <kernel@avr32linux.org>
Content-Type: text/plain
Date: Sun, 10 May 2009 11:29:39 +1000
Message-Id: <1241918979.3246.10.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


AFAICT the code which checks that the requested pixclock value is within
bounds is incorrect.  It ensures that the lcdc core clock is at least
(bytes per pixel) times higher than the pixel clock rather than just
greater than or equal to.

There are tighter restrictions on the pixclock value as a function of
bus width for STN panels but even then it isn't a simple relationship as
currently checked for.  IMO either something like the below patch should
be applied or else more detailed checking logic should be implemented
which takes in to account the panel type as well.

CMIIW :-)

Signed-off-by: Ben Nizette <bn@niasdigital.com>

---
diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 9a577a8..5779641 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -351,7 +351,7 @@ static int atmel_lcdfb_check_var(struct fb_var_screeninfo *var,
 	dev_dbg(dev, "  bpp:        %u\n", var->bits_per_pixel);
 	dev_dbg(dev, "  clk:        %lu KHz\n", clk_value_khz);
 
-	if ((PICOS2KHZ(var->pixclock) * var->bits_per_pixel / 8) > clk_value_khz) {
+	if (PICOS2KHZ(var->pixclock) > clk_value_khz) {
 		dev_err(dev, "%lu KHz pixel clock is too fast\n", PICOS2KHZ(var->pixclock));
 		return -EINVAL;
 	}


