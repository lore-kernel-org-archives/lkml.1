Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395AbYDHED1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbYDHED1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 00:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbYDHEDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 00:03:19 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:27495 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbYDHEDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 00:03:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=S3iMnktPmDLpe5nY3zSb1ANhzKo+4bNEAxgCmRMNeFguVEdp6MDyE7rylDgymG9nxnTAdZIJtJ1Jck+bFzFRnOBTiJ/Y+94V/PX8Tv8QNfQ+VWyz9FuW+sb0JyB8laitsaopYDdc+AgXMkoheiV4cXoXBvyRbqVGFT+whWi5aoc=
Message-ID: <f17812d70804072103s4fa2b6d4t57abfcda9d8e0b11@mail.gmail.com>
Date: Tue, 8 Apr 2008 12:03:16 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "linux-arm-kernel email list" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-fbdev-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] pxafb: introduce lcd_{read,write}l() to wrap the __raw_{read,write}l()
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 917ed27ddcaca455f7799f74a1db9a4497725de8 Mon Sep 17 00:00:00 2001
From: Eric Miao <eric.miao@marvell.com>
Date: Thu, 27 Mar 2008 09:28:32 +0800
Subject: [PATCH] pxafb: introduce lcd_{read,write}l() to wrap the
__raw_{read,write}l()

using __raw_{read,write}l() everywhere looks messy, introduce
lcd_{read,write}l() to get this cleaned up a bit

Signed-off-by: eric miao <eric.miao@marvell.com>
---
 drivers/video/pxafb.c |   50 +++++++++++++++++++++++++-----------------------
 1 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/drivers/video/pxafb.c b/drivers/video/pxafb.c
index 0031a5f..27d9fed 100644
--- a/drivers/video/pxafb.c
+++ b/drivers/video/pxafb.c
@@ -64,6 +64,9 @@
 #define LCCR3_INVALID_CONFIG_MASK	(LCCR3_HSP | LCCR3_VSP |\
 					 LCCR3_PCD | LCCR3_BPP)

+#define lcd_readl(f, off)	__raw_readl((f)->mmio_base + (off))
+#define lcd_writel(f, off, v)	__raw_writel((v), (f)->mmio_base + (off))
+
 static void (*pxafb_backlight_power)(int);
 static void (*pxafb_lcd_power)(int, struct fb_var_screeninfo *);

@@ -684,8 +687,7 @@ static int pxafb_activate_var(struct fb_var_screeninfo *var,
 	fbi->reg_lccr1 = new_regs.lccr1;
 	fbi->reg_lccr2 = new_regs.lccr2;
 	fbi->reg_lccr3 = new_regs.lccr3;
-	fbi->reg_lccr4 = __raw_readl(fbi->mmio_base + LCCR4) &
-				(~LCCR4_PAL_FOR_MASK);
+	fbi->reg_lccr4 = lcd_readl(fbi, LCCR4) & ~LCCR4_PAL_FOR_MASK;
 	fbi->reg_lccr4 |= (fbi->lccr4 & LCCR4_PAL_FOR_MASK);
 	set_hsync_time(fbi, pcd);
 	local_irq_restore(flags);
@@ -694,12 +696,12 @@ static int pxafb_activate_var(struct
fb_var_screeninfo *var,
 	 * Only update the registers if the controller is enabled
 	 * and something has changed.
 	 */
-	if ((__raw_readl(fbi->mmio_base + LCCR0) != fbi->reg_lccr0) ||
-	    (__raw_readl(fbi->mmio_base + LCCR1) != fbi->reg_lccr1) ||
-	    (__raw_readl(fbi->mmio_base + LCCR2) != fbi->reg_lccr2) ||
-	    (__raw_readl(fbi->mmio_base + LCCR3) != fbi->reg_lccr3) ||
-	    (__raw_readl(fbi->mmio_base + FDADR0) != fbi->fdadr[0]) ||
-	    (__raw_readl(fbi->mmio_base + FDADR1) != fbi->fdadr[1]))
+	if ((lcd_readl(fbi, LCCR0) != fbi->reg_lccr0) ||
+	    (lcd_readl(fbi, LCCR1) != fbi->reg_lccr1) ||
+	    (lcd_readl(fbi, LCCR2) != fbi->reg_lccr2) ||
+	    (lcd_readl(fbi, LCCR3) != fbi->reg_lccr3) ||
+	    (lcd_readl(fbi, FDADR0) != fbi->fdadr[0]) ||
+	    (lcd_readl(fbi, FDADR1) != fbi->fdadr[1]))
 		pxafb_schedule_work(fbi, C_REENABLE);

 	return 0;
@@ -785,14 +787,14 @@ static void pxafb_enable_controller(struct
pxafb_info *fbi)
 	clk_enable(fbi->clk);

 	/* Sequence from 11.7.10 */
-	__raw_writel(fbi->reg_lccr3, fbi->mmio_base + LCCR3);
-	__raw_writel(fbi->reg_lccr2, fbi->mmio_base + LCCR2);
-	__raw_writel(fbi->reg_lccr1, fbi->mmio_base + LCCR1);
-	__raw_writel(fbi->reg_lccr0 & ~LCCR0_ENB, fbi->mmio_base + LCCR0);
-
-	__raw_writel(fbi->fdadr[0], fbi->mmio_base + FDADR0);
-	__raw_writel(fbi->fdadr[1], fbi->mmio_base + FDADR1);
-	__raw_writel(fbi->reg_lccr0 | LCCR0_ENB, fbi->mmio_base + LCCR0);
+	lcd_writel(fbi, LCCR3, fbi->reg_lccr3);
+	lcd_writel(fbi, LCCR2, fbi->reg_lccr2);
+	lcd_writel(fbi, LCCR1, fbi->reg_lccr1);
+	lcd_writel(fbi, LCCR0, fbi->reg_lccr0 & ~LCCR0_ENB);
+
+	lcd_writel(fbi, FDADR0, fbi->fdadr[0]);
+	lcd_writel(fbi, FDADR1, fbi->fdadr[1]);
+	lcd_writel(fbi, LCCR0, fbi->reg_lccr0 | LCCR0_ENB);
 }

 static void pxafb_disable_controller(struct pxafb_info *fbi)
@@ -805,11 +807,11 @@ static void pxafb_disable_controller(struct
pxafb_info *fbi)
 	add_wait_queue(&fbi->ctrlr_wait, &wait);

 	/* Clear LCD Status Register */
-	__raw_writel(0xffffffff, fbi->mmio_base + LCSR);
+	lcd_writel(fbi, LCSR, 0xffffffff);

-	lccr0 = __raw_readl(fbi->mmio_base + LCCR0) & ~LCCR0_LDM;
-	__raw_writel(lccr0, fbi->mmio_base + LCCR0);
-	__raw_writel(lccr0 | LCCR0_DIS, fbi->mmio_base + LCCR0);
+	lccr0 = lcd_readl(fbi, LCCR0) & ~LCCR0_LDM;
+	lcd_writel(fbi, LCCR0, lccr0);
+	lcd_writel(fbi, LCCR0, lccr0 | LCCR0_DIS);

 	schedule_timeout(200 * HZ / 1000);
 	remove_wait_queue(&fbi->ctrlr_wait, &wait);
@@ -824,15 +826,15 @@ static void pxafb_disable_controller(struct
pxafb_info *fbi)
 static irqreturn_t pxafb_handle_irq(int irq, void *dev_id)
 {
 	struct pxafb_info *fbi = dev_id;
-	unsigned int lccr0, lcsr = __raw_readl(fbi->mmio_base + LCSR);
+	unsigned int lccr0, lcsr = lcd_readl(fbi, LCSR);

 	if (lcsr & LCSR_LDD) {
-		lccr0 = __raw_readl(fbi->mmio_base + LCCR0) | LCCR0_LDM;
-		__raw_writel(lccr0, fbi->mmio_base + LCCR0);
+		lccr0 = lcd_readl(fbi, LCCR0);
+		lcd_writel(fbi, LCCR0, lccr0 | LCCR0_LDM);
 		wake_up(&fbi->ctrlr_wait);
 	}

-	__raw_writel(lcsr, fbi->mmio_base + LCSR);
+	lcd_writel(fbi, LCSR, lcsr);
 	return IRQ_HANDLED;
 }

-- 
1.5.4.3



-- 
Cheers
- eric
