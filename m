Return-Path: <linux-kernel-owner+w=401wt.eu-S965656AbXDIVWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965656AbXDIVWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965747AbXDIVWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:22:38 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:26169 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965656AbXDIVWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:22:37 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Juha Yrjola <juha.yrjola@solidboot.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 1/18] ARM: OMAP: Add DMA IRQ sanity checks
Date: Mon,  9 Apr 2007 17:22:06 -0400
Message-Id: <117615374683-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761537431635-git-send-email-tony@atomide.com>
References: <11761537431635-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juha Yrjola <juha.yrjola@solidboot.com>

Add DMA IRQ sanity checks

Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/dma.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

--- a/arch/arm/plat-omap/dma.c
+++ b/arch/arm/plat-omap/dma.c
@@ -925,10 +925,17 @@ static int omap2_dma_handle_ch(int ch)
 {
 	u32 status = OMAP_DMA_CSR_REG(ch);
 
-	if (!status)
+	if (!status) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING "Spurious DMA IRQ for lch %d\n", ch);
 		return 0;
-	if (unlikely(dma_chan[ch].dev_id == -1))
+	}
+	if (unlikely(dma_chan[ch].dev_id == -1)) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING "IRQ %04x for non-allocated DMA"
+					"channel %d\n", status, ch);
 		return 0;
+	}
 	if (unlikely(status & OMAP_DMA_DROP_IRQ))
 		printk(KERN_INFO
 		       "DMA synchronization event drop occurred with device "
@@ -959,11 +966,15 @@ static irqreturn_t omap2_dma_irq_handler(int irq, void *dev_id)
 	int i;
 
 	val = omap_readl(OMAP_DMA4_IRQSTATUS_L0);
-
-	for (i = 1; i <= OMAP_LOGICAL_DMA_CH_COUNT; i++) {
-		int active = val & (1 << (i - 1));
-		if (active)
-			omap2_dma_handle_ch(i - 1);
+	if (val == 0) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING "Spurious DMA IRQ\n");
+		return IRQ_HANDLED;
+	}
+	for (i = 0; i < OMAP_LOGICAL_DMA_CH_COUNT && val != 0; i++) {
+		if (val & 1)
+			omap2_dma_handle_ch(i);
+		val >>= 1;
 	}
 
 	return IRQ_HANDLED;
-- 
1.4.4.2

