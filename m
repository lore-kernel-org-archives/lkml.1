Return-Path: <linux-kernel-owner+w=401wt.eu-S1758677AbZJEIn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbZJEIn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 04:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758628AbZJEIn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 04:43:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35336 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbZJEIn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 04:43:26 -0400
From: Anuj Aggarwal <anuj.aggarwal@ti.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: svenkatr@ti.com, tony@atomide.com, Anuj Aggarwal <anuj.aggarwal@ti.com>
Subject: [PATCH v2] SDMA: Fixing bug in omap_dma_set_global_params()
Date: Mon,  5 Oct 2009 14:12:43 +0530
Message-Id: <1254732163-3509-1-git-send-email-anuj.aggarwal@ti.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argument tparams was not being used to program
global register GCR.HI_THREAD_RESERVED. This patch fixes the same.

Signed-off-by: Anuj Aggarwal <anuj.aggarwal@ti.com>
---
 arch/arm/plat-omap/dma.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
index fd3154a..0eb676d 100644
--- a/arch/arm/plat-omap/dma.c
+++ b/arch/arm/plat-omap/dma.c
@@ -829,10 +829,10 @@ EXPORT_SYMBOL(omap_free_dma);
  *
  * @param arb_rate
  * @param max_fifo_depth
- * @param tparams - Number of thereads to reserve : DMA_THREAD_RESERVE_NORM
- * 						    DMA_THREAD_RESERVE_ONET
- * 						    DMA_THREAD_RESERVE_TWOT
- * 						    DMA_THREAD_RESERVE_THREET
+ * @param tparams - Number of threads to reserve : DMA_THREAD_RESERVE_NORM
+ * 						   DMA_THREAD_RESERVE_ONET
+ * 						   DMA_THREAD_RESERVE_TWOT
+ * 						   DMA_THREAD_RESERVE_THREET
  */
 void
 omap_dma_set_global_params(int arb_rate, int max_fifo_depth, int tparams)
@@ -844,11 +844,14 @@ omap_dma_set_global_params(int arb_rate, int max_fifo_depth, int tparams)
 		return;
 	}
 
+	if (max_fifo_depth == 0)
+		max_fifo_depth = 1;
 	if (arb_rate == 0)
 		arb_rate = 1;
 
-	reg = (arb_rate & 0xff) << 16;
-	reg |= (0xff & max_fifo_depth);
+	reg = 0xff & max_fifo_depth;
+	reg |= (0x3 & tparams) << 12;
+	reg |= (arb_rate & 0xff) << 16;
 
 	dma_write(reg, GCR);
 }
-- 
1.6.2.4

