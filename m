Return-Path: <linux-kernel-owner+w=401wt.eu-S1763128AbZEOPXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763128AbZEOPXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 11:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761636AbZEOPXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 11:23:33 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:52231 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbZEOPXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 11:23:32 -0400
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: linux-mips@linux-mips.org
Cc: ralf@linux-mips.org, dan.j.williams@intel.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] txx9dmac: use dma_unmap_single if DMA_COMPL_{SRC,DEST}_UNMAP_SINGLE was set
Date: Sat, 16 May 2009 00:23:30 +0900
Message-Id: <1242401010-17017-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does not change actual behaviour since dma_unmap_page is just
an alias of dma_unmap_single on MIPS.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
This patch is against linux-mips.org linux-queue tree.
Please queue this or fold into "DMA: TXx9 Soc DMA Controller driver" patch.

 drivers/dma/txx9dmac.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
index 9aa9ea9..88dab52 100644
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -432,23 +432,27 @@ txx9dmac_descriptor_complete(struct txx9dmac_chan *dc,
 	list_splice_init(&txd->tx_list, &dc->free_list);
 	list_move(&desc->desc_node, &dc->free_list);
 
-	/*
-	 * We use dma_unmap_page() regardless of how the buffers were
-	 * mapped before they were submitted...
-	 */
 	if (!ds) {
 		dma_addr_t dmaaddr;
 		if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
 			dmaaddr = is_dmac64(dc) ?
 				desc->hwdesc.DAR : desc->hwdesc32.DAR;
-			dma_unmap_page(chan2parent(&dc->chan), dmaaddr,
-				       desc->len, DMA_FROM_DEVICE);
+			if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
+				dma_unmap_single(chan2parent(&dc->chan),
+					dmaaddr, desc->len, DMA_FROM_DEVICE);
+			else
+				dma_unmap_page(chan2parent(&dc->chan),
+					dmaaddr, desc->len, DMA_FROM_DEVICE);
 		}
 		if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
 			dmaaddr = is_dmac64(dc) ?
 				desc->hwdesc.SAR : desc->hwdesc32.SAR;
-			dma_unmap_page(chan2parent(&dc->chan), dmaaddr,
-				       desc->len, DMA_TO_DEVICE);
+			if (txd->flags & DMA_COMPL_SRC_UNMAP_SINGLE)
+				dma_unmap_single(chan2parent(&dc->chan),
+					dmaaddr, desc->len, DMA_TO_DEVICE);
+			else
+				dma_unmap_page(chan2parent(&dc->chan),
+					dmaaddr, desc->len, DMA_TO_DEVICE);
 		}
 	}
 
-- 
1.5.6.5

