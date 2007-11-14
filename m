Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbXKNKfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbXKNKfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 05:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbXKNKfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 05:35:25 -0500
Received: from de01egw01.freescale.net ([192.88.165.102]:55690 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbXKNKfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 05:35:24 -0500
From: Zhang Wei <wei.zhang@freescale.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, olof@lixom.net,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH] Fix the issue of fsldma driver's VIRT_TO_BUS dependence in Kconfig.
Date: Wed, 14 Nov 2007 18:44:29 +0800
Message-Id: <119503706990-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.2
X-OriginalArrivalTime: 14 Nov 2007 10:35:10.0783 (UTC) FILETIME=[086EBCF0:01C826AA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove virt_to_bus(), just using the saved phy address to match.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 drivers/dma/fsldma.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 71e1c32..899b0c0 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -495,15 +495,20 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
  */
 static void fsl_dma_update_completed_cookie(struct fsl_dma_chan *fsl_chan)
 {
-	struct fsl_desc_sw *cur_desc;
+	struct fsl_desc_sw *cur_desc, *desc;
 	dma_addr_t ld_phy;
 
 	ld_phy = get_cdar(fsl_chan) & FSL_DMA_NLDA_MASK;
 
 	if (ld_phy) {
-		cur_desc = (struct fsl_desc_sw *)bus_to_virt(ld_phy);
-
-		if (cur_desc->async_tx.cookie) {
+		cur_desc = NULL;
+		list_for_each_entry(desc, &fsl_chan->ld_queue, node)
+			if (desc->async_tx.phys == ld_phy) {
+				cur_desc = desc;
+				break;
+			}
+
+		if (cur_desc && cur_desc->async_tx.cookie) {
 			if (dma_is_idle(fsl_chan))
 				fsl_chan->completed_cookie =
 					cur_desc->async_tx.cookie;
-- 
1.5.2

