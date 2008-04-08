Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbYDHEF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbYDHEF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 00:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbYDHEFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 00:05:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:38372 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbYDHEFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 00:05:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=LnbG3Wow4uUx40G8vTbCbGZgAWxtCUmhzlLnqhe4mNJVYLjTYF/zRVWMWh0x4/ub6RdP5AVGNu8+uRt4n1EzsZVLo7c/AHOcD9UlInpNLSjpeBBhGwaj2iE4aElkpYJP7Um1AL8cFmvTOZ4tQCOlmPbfxRkmx0zizoB3t0YaB7M=
Message-ID: <f17812d70804072105r57413cc4gba7f66abb4724809@mail.gmail.com>
Date: Tue, 8 Apr 2008 12:05:16 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "linux-arm-kernel email list" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-fbdev-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] pxafb: move parallel LCD timing setup into dedicate function
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Mack" <daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 725710ec6cb3d846e83229f88e6a32099f9b1639 Mon Sep 17 00:00:00 2001
From: Eric Miao <eric.miao@marvell.com>
Date: Thu, 27 Mar 2008 12:01:22 +0800
Subject: [PATCH] pxafb: move parallel LCD timing setup into dedicate function

 the new_regs stuff has been removed, and all the setup (modification
 to those fbi->reg_*) is protected with IRQ disabled

   * disable IRQ is too heavy here, provided that no IRQ context will
     touch the fbi->reg_* and the only possible contending place is
     in the CPUFREQ_POSTCHANGE (task context), a mutex will be better,
     leave this for future improvement

Signed-off-by: eric miao <eric.miao@marvell.com>
---
 drivers/video/pxafb.c |   89 ++++++++++++++++++++++++++-----------------------
 drivers/video/pxafb.h |    8 ----
 2 files changed, 47 insertions(+), 50 deletions(-)

diff --git a/drivers/video/pxafb.c b/drivers/video/pxafb.c
index fb24ca3..c541a66 100644
--- a/drivers/video/pxafb.c
+++ b/drivers/video/pxafb.c
@@ -585,6 +585,43 @@ static int setup_frame_dma(struct pxafb_info
*fbi, int dma, int pal,
 	return 0;
 }

+static void setup_parallel_timing(struct pxafb_info *fbi,
+				  struct fb_var_screeninfo *var)
+{
+	unsigned int lines_per_panel, pcd = get_pcd(fbi, var->pixclock);
+
+	fbi->reg_lccr1 =
+		LCCR1_DisWdth(var->xres) +
+		LCCR1_HorSnchWdth(var->hsync_len) +
+		LCCR1_BegLnDel(var->left_margin) +
+		LCCR1_EndLnDel(var->right_margin);
+
+	/*
+	 * If we have a dual scan LCD, we need to halve
+	 * the YRES parameter.
+	 */
+	lines_per_panel = var->yres;
+	if ((fbi->lccr0 & LCCR0_SDS) == LCCR0_Dual)
+		lines_per_panel /= 2;
+
+	fbi->reg_lccr2 =
+		LCCR2_DisHght(lines_per_panel) +
+		LCCR2_VrtSnchWdth(var->vsync_len) +
+		LCCR2_BegFrmDel(var->upper_margin) +
+		LCCR2_EndFrmDel(var->lower_margin);
+
+	fbi->reg_lccr3 = fbi->lccr3 |
+		(var->sync & FB_SYNC_HOR_HIGH_ACT ?
+		 LCCR3_HorSnchH : LCCR3_HorSnchL) |
+		(var->sync & FB_SYNC_VERT_HIGH_ACT ?
+		 LCCR3_VrtSnchH : LCCR3_VrtSnchL);
+
+	if (pcd) {
+		fbi->reg_lccr3 |= LCCR3_PixClkDiv(pcd);
+		set_hsync_time(fbi, pcd);
+	}
+}
+
 /*
  * pxafb_activate_var():
  *	Configures LCD Controller based on entries in var parameter.
@@ -593,9 +630,7 @@ static int setup_frame_dma(struct pxafb_info *fbi,
int dma, int pal,
 static int pxafb_activate_var(struct fb_var_screeninfo *var,
 			      struct pxafb_info *fbi)
 {
-	struct pxafb_lcd_reg new_regs;
 	u_long flags;
-	u_int lines_per_panel, pcd = get_pcd(fbi, var->pixclock);
 	size_t nbytes;

 #if DEBUG_VAR
@@ -636,61 +671,31 @@ static int pxafb_activate_var(struct
fb_var_screeninfo *var,
 		printk(KERN_ERR "%s: invalid lower_margin %d\n",
 			fbi->fb.fix.id, var->lower_margin);
 #endif
+	/* Update shadow copy atomically */
+	local_irq_save(flags);
+
+	setup_parallel_timing(fbi, var);

-	new_regs.lccr0 = fbi->lccr0 |
+	fbi->reg_lccr0 = fbi->lccr0 |
 		(LCCR0_LDM | LCCR0_SFM | LCCR0_IUM | LCCR0_EFM |
 		 LCCR0_QDM | LCCR0_BM  | LCCR0_OUM);

-	new_regs.lccr1 =
-		LCCR1_DisWdth(var->xres) +
-		LCCR1_HorSnchWdth(var->hsync_len) +
-		LCCR1_BegLnDel(var->left_margin) +
-		LCCR1_EndLnDel(var->right_margin);
-
-	/*
-	 * If we have a dual scan LCD, we need to halve
-	 * the YRES parameter.
-	 */
-	lines_per_panel = var->yres;
-	if ((fbi->lccr0 & LCCR0_SDS) == LCCR0_Dual)
-		lines_per_panel /= 2;
-
-	new_regs.lccr2 =
-		LCCR2_DisHght(lines_per_panel) +
-		LCCR2_VrtSnchWdth(var->vsync_len) +
-		LCCR2_BegFrmDel(var->upper_margin) +
-		LCCR2_EndFrmDel(var->lower_margin);
+	fbi->reg_lccr3 |= pxafb_bpp_to_lccr3(var);

-	new_regs.lccr3 = fbi->lccr3 |
-		pxafb_bpp_to_lccr3(var) |
-		(var->sync & FB_SYNC_HOR_HIGH_ACT ?
-		 LCCR3_HorSnchH : LCCR3_HorSnchL) |
-		(var->sync & FB_SYNC_VERT_HIGH_ACT ?
-		 LCCR3_VrtSnchH : LCCR3_VrtSnchL);
+	nbytes = var->yres * fbi->fb.fix.line_length;

-	if (pcd)
-		new_regs.lccr3 |= LCCR3_PixClkDiv(pcd);
-
-	/* Update shadow copy atomically */
-	local_irq_save(flags);
-
-	nbytes = lines_per_panel * fbi->fb.fix.line_length;
-
-	if ((fbi->lccr0 & LCCR0_SDS) == LCCR0_Dual)
+	if ((fbi->lccr0 & LCCR0_SDS) == LCCR0_Dual) {
+		nbytes = nbytes / 2;
 		setup_frame_dma(fbi, DMA_LOWER, PAL_NONE, nbytes, nbytes);
+	}

 	if (var->bits_per_pixel >= 16)
 		setup_frame_dma(fbi, DMA_BASE, PAL_NONE, 0, nbytes);
 	else
 		setup_frame_dma(fbi, DMA_BASE, PAL_BASE, 0, nbytes);

-	fbi->reg_lccr0 = new_regs.lccr0;
-	fbi->reg_lccr1 = new_regs.lccr1;
-	fbi->reg_lccr2 = new_regs.lccr2;
-	fbi->reg_lccr3 = new_regs.lccr3;
 	fbi->reg_lccr4 = lcd_readl(fbi, LCCR4) & ~LCCR4_PAL_FOR_MASK;
 	fbi->reg_lccr4 |= (fbi->lccr4 & LCCR4_PAL_FOR_MASK);
-	set_hsync_time(fbi, pcd);
 	local_irq_restore(flags);

 	/*
diff --git a/drivers/video/pxafb.h b/drivers/video/pxafb.h
index f47f139..c627b83 100644
--- a/drivers/video/pxafb.h
+++ b/drivers/video/pxafb.h
@@ -21,14 +21,6 @@
  * for more details.
  */

-/* Shadows for LCD controller registers */
-struct pxafb_lcd_reg {
-	unsigned int lccr0;
-	unsigned int lccr1;
-	unsigned int lccr2;
-	unsigned int lccr3;
-};
-
 /* PXA LCD DMA descriptor */
 struct pxafb_dma_descriptor {
 	unsigned int fdadr;
-- 
1.5.4.3



-- 
Cheers
- eric
