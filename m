Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab0CONaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 09:30:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49952 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab0CONau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 09:30:50 -0400
From: Luotao Fu <l.fu@pengutronix.de>
To: Russell King <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andres Salomon <dilinger@debian.org>,
       Alessandro Rubini <rubini@unipv.it>,
       Krzysztof Helt <krzysztof.h1@wp.pl>, Kevin Wells <wellsk40@gmail.com>,
       linux-kernel@vger.kernel.org, Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH] amba-clcd: add RGB444 support
Date: Mon, 15 Mar 2010 14:30:09 +0100
Message-Id: <1268659809-3609-1-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.7.0
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one adds RGB444 (bpp=12) support to amba clcd drivers. Tested on a lpc3250
based platform.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
 drivers/video/amba-clcd.c |   11 ++++++++---
 include/linux/amba/clcd.h |    7 ++++++-
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/video/amba-clcd.c b/drivers/video/amba-clcd.c
index a21efcd..5111a12 100644
--- a/drivers/video/amba-clcd.c
+++ b/drivers/video/amba-clcd.c
@@ -134,6 +134,11 @@ clcdfb_set_bitfields(struct clcd_fb *fb, struct fb_var_screeninfo *var)
 		var->blue.length	= var->bits_per_pixel;
 		var->blue.offset	= 0;
 		break;
+	case 12:
+		var->red.length		= 4;
+		var->green.length	= 4;
+		var->blue.length	= 4;
+		break;
 	case 16:
 		var->red.length = 5;
 		var->blue.length = 5;
@@ -161,7 +166,7 @@ clcdfb_set_bitfields(struct clcd_fb *fb, struct fb_var_screeninfo *var)
 	 * encoded in the pixel data.  Calculate their position from
 	 * the bitfield length defined above.
 	 */
-	if (ret == 0 && var->bits_per_pixel >= 16) {
+	if (ret == 0 && var->bits_per_pixel >= 12) {
 		if (fb->panel->cntl & CNTL_BGR) {
 			var->blue.offset = 0;
 			var->green.offset = var->blue.offset + var->blue.length;
@@ -200,6 +205,8 @@ static int clcdfb_set_par(struct fb_info *info)
 	struct clcd_fb *fb = to_clcd(info);
 	struct clcd_regs regs;
 
+	fb->board->decode(fb, &regs);
+
 	fb->fb.fix.line_length = fb->fb.var.xres_virtual *
 				 fb->fb.var.bits_per_pixel / 8;
 
@@ -208,8 +215,6 @@ static int clcdfb_set_par(struct fb_info *info)
 	else
 		fb->fb.fix.visual = FB_VISUAL_TRUECOLOR;
 
-	fb->board->decode(fb, &regs);
-
 	clcdfb_disable(fb);
 
 	writel(regs.tim0, fb->regs + CLCD_TIM0);
diff --git a/include/linux/amba/clcd.h b/include/linux/amba/clcd.h
index 8d0d491..7e0bcc7 100644
--- a/include/linux/amba/clcd.h
+++ b/include/linux/amba/clcd.h
@@ -53,6 +53,7 @@
 #define CNTL_LCDBPP2		(1 << 1)
 #define CNTL_LCDBPP4		(2 << 1)
 #define CNTL_LCDBPP8		(3 << 1)
+#define CNTL_LCDBPP12		(7 << 1)
 #define CNTL_LCDBPP16		(4 << 1)
 #define CNTL_LCDBPP16_565	(6 << 1)
 #define CNTL_LCDBPP24		(5 << 1)
@@ -209,6 +210,10 @@ static inline void clcdfb_decode(struct clcd_fb *fb, struct clcd_regs *regs)
 	case 8:
 		val |= CNTL_LCDBPP8;
 		break;
+	case 12:
+		fb->fb.var.bits_per_pixel = 16;
+		val |= CNTL_LCDBPP12;
+		break;
 	case 16:
 		/*
 		 * PL110 cannot choose between 5551 and 565 modes in
@@ -225,7 +230,7 @@ static inline void clcdfb_decode(struct clcd_fb *fb, struct clcd_regs *regs)
 		val |= CNTL_LCDBPP24;
 		break;
 	}
-
+	printk("**** %s: cntl val 0x%08x\n", __func__, val);
 	regs->cntl = val;
 	regs->pixclock = fb->fb.var.pixclock;
 }
-- 
1.7.0

