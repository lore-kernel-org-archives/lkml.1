Return-Path: <linux-kernel-owner+w=401wt.eu-S1422726AbXDDSUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422726AbXDDSUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934099AbXDDSNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:13:45 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:39528 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934096AbXDDSNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:13:20 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Imre Deak <imre.deak@solidboot.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 71/90] ARM: OMAP: add SoSSI clock (remove manual checking of SoSSI state from idle)
Date: Wed,  4 Apr 2007 14:05:50 -0400
Message-Id: <11757101613869-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757101581123-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!
 it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <
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

diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
index 49efe90..743029a 100644
--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
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
diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
index 2d86b10..c64785e 100644
--- a/arch/arm/plat-omap/dma.c
+++ b/arch/arm/plat-omap/dma.c
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
diff --git a/include/asm-arm/arch-omap/dma.h b/include/asm-arm/arch-omap/dma.h
index d591d05..d2701d8 100644
--- a/include/asm-arm/arch-omap/dma.h
+++ b/include/asm-arm/arch-omap/dma.h
@@ -417,7 +417,6 @@ extern void omap_free_lcd_dma(void);
 extern void omap_setup_lcd_dma(void);
 extern void omap_enable_lcd_dma(void);
 extern void omap_stop_lcd_dma(void);
-extern int  omap_lcd_dma_ext_running(void);
 extern void omap_set_lcd_dma_ext_controller(int external);
 extern void omap_set_lcd_dma_single_transfer(int single);
 extern void omap_set_lcd_dma_b1(unsigned long addr, u16 fb_xres, u16 fb_yres,
-- 
1.4.4.2

