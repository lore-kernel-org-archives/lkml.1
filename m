Return-Path: <linux-kernel-owner+w=401wt.eu-S965951AbXDIV13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965951AbXDIV13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030258AbXDIV0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:26:51 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:29279 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965940AbXDIV0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:26:17 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Imre Deak <imre.deak@solidboot.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4/6] ARM: OMAP: add SoSSI clock (remove manual checking of SoSSI state from idle)
Date: Mon,  9 Apr 2007 17:25:42 -0400
Message-Id: <11761539581152-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761539553166-git-send-email-tony@atomide.com>
References: <1176153944991-git-send-email-tony@atomide.com> <1176153948771-git-send-email-tony@atomide.com> <11761539511877-git-send-email-tony@atomide.com> <11761539553166-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Imre Deak <imre.deak@solidboot.com>

The SoSSI driver should already take care of this by enabling / disabling
its clock when necessary, so this legacy callout from the PM idle code
is not needed any more.

Signed-off-by: Imre Deak <imre.deak@solidboot.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/pm.c        |    5 +----
 arch/arm/plat-omap/dma.c        |    6 ------
 include/asm-arm/arch-omap/dma.h |    1 -
 3 files changed, 1 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/arm/mach-omap1/pm.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/pm.c	2007-04-09 16:38:12.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap1/pm.c	2007-04-09 16:39:10.000000000 -0400
@@ -155,11 +155,8 @@ void omap_pm_idle(void)
 	use_idlect1 = omap_dm_timer_modify_idlect_mask(use_idlect1);
 #endif
 
-	if (omap_dma_running()) {
+	if (omap_dma_running())
 		use_idlect1 &= ~(1 << 6);
-		if (omap_lcd_dma_ext_running())
-			use_idlect1 &= ~(1 << 12);
-	}
 
 	/* We should be able to remove the do_sleep variable and multiple
 	 * tests above as soon as drivers, timer and DMA code have been fixed.
Index: linux-2.6/arch/arm/plat-omap/dma.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-omap/dma.c	2007-04-09 16:39:05.000000000 -0400
+++ linux-2.6/arch/arm/plat-omap/dma.c	2007-04-09 16:39:10.000000000 -0400
@@ -1347,11 +1347,6 @@ void omap_stop_lcd_dma(void)
 	omap_writew(w, OMAP1610_DMA_LCD_CTRL);
 }
 
-int omap_lcd_dma_ext_running(void)
-{
-	return lcd_dma.ext_ctrl && lcd_dma.active;
-}
-
 /*----------------------------------------------------------------------------*/
 
 static int __init omap_init_dma(void)
@@ -1493,7 +1488,6 @@ EXPORT_SYMBOL(omap_free_lcd_dma);
 EXPORT_SYMBOL(omap_enable_lcd_dma);
 EXPORT_SYMBOL(omap_setup_lcd_dma);
 EXPORT_SYMBOL(omap_stop_lcd_dma);
-EXPORT_SYMBOL(omap_lcd_dma_ext_running);
 EXPORT_SYMBOL(omap_set_lcd_dma_b1);
 EXPORT_SYMBOL(omap_set_lcd_dma_single_transfer);
 EXPORT_SYMBOL(omap_set_lcd_dma_ext_controller);
Index: linux-2.6/include/asm-arm/arch-omap/dma.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/dma.h	2007-04-09 16:38:12.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/dma.h	2007-04-09 16:39:10.000000000 -0400
@@ -417,7 +417,6 @@ extern void omap_free_lcd_dma(void);
 extern void omap_setup_lcd_dma(void);
 extern void omap_enable_lcd_dma(void);
 extern void omap_stop_lcd_dma(void);
-extern int  omap_lcd_dma_ext_running(void);
 extern void omap_set_lcd_dma_ext_controller(int external);
 extern void omap_set_lcd_dma_single_transfer(int single);
 extern void omap_set_lcd_dma_b1(unsigned long addr, u16 fb_xres, u16 fb_yres,
