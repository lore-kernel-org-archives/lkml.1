Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbYCMG46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbYCMG46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 02:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbYCMG4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 02:56:51 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:60805 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYCMG4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 02:56:50 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH] fsldma: Add a completed cookie updated action in DMA finish interrupt.
Date: Thu, 13 Mar 2008 14:54:20 +0800
Message-Id: <1205391260-4482-1-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
X-OriginalArrivalTime: 13 Mar 2008 06:56:44.0784 (UTC) FILETIME=[6637FF00:01C884D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch 'fsldma: do not cleanup descriptors in hardirq context'
(commit 222ccf9ab838a1ca7163969fabd2cddc10403fb5) removed descriptors
cleanup function to tasklet but the completed cookie do not updated.
Thus, the DMA controller will get lots of duplicated transfer
interrupts. Just make a completed cookie update in interrupt handler.
And keep other cleanup jobs in tasklet function.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 drivers/dma/fsldma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 5428f81..7c957c3 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -539,7 +539,6 @@ static void fsl_chan_ld_cleanup(struct fsl_dma_chan *fsl_chan)
 
 	spin_lock_irqsave(&fsl_chan->desc_lock, flags);
 
-	fsl_dma_update_completed_cookie(fsl_chan);
 	dev_dbg(fsl_chan->dev, "chan completed_cookie = %d\n",
 			fsl_chan->completed_cookie);
 	list_for_each_entry_safe(desc, _desc, &fsl_chan->ld_queue, node) {
@@ -710,6 +709,7 @@ static irqreturn_t fsl_dma_chan_do_interrupt(int irq, void *data)
 		dev_dbg(fsl_chan->dev, "event: clndar %p, nlndar %p\n",
 			(void *)get_cdar(fsl_chan), (void *)get_ndar(fsl_chan));
 		stat &= ~FSL_DMA_SR_EOSI;
+		fsl_dma_update_completed_cookie(fsl_chan);
 	}
 
 	/* If it current transfer is the end-of-transfer,
-- 
1.5.4

