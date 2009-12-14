Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbZLNNaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbZLNNaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 08:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbZLNNax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 08:30:53 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:48618 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbZLNNaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 08:30:52 -0500
From: Vishnu Suresh <Vishnu@freescale.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, dan.j.williams@intel.com
Cc: B04825@freescale.com, R58472@freescale.com,
       Vishnu Suresh <Vishnu@freescale.com>
Subject: [PATCH v1] fsldma: Delete DMA_INTERRUPT capability
Date: Mon, 14 Dec 2009 19:00:23 +0530
Message-Id: <1260797423-7352-1-git-send-email-Vishnu@freescale.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DMA_INTERRUPT is a NULL transfer, triggering a
Programming Error. Though this Error is handled in
the driver with the fix given in "fsldma: Fix the DMA
halt when using DMA_INTERRUPT async_tx transfer."
<f79abb627f033c85a6088231f20c85bc4a9bd757>,
the RAID5 operation, which initiated the transaction
via Async_tx, hangs.

Hence, this patch removes the DMA_INTERRUPT capability
and the associated code from the driver.

Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
---
Changes with respect to v0
o. The functionality is removed instead of disabling as
   per comments
o. Rebased to linux-next as of 20091214

 drivers/dma/fsldma.c |   31 -------------------------------
 1 files changed, 0 insertions(+), 31 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 296f9e7..272097a 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -449,35 +449,6 @@ static void fsl_dma_free_chan_resources(struct dma_chan *chan)
 	fsl_chan->desc_pool = NULL;
 }
 
-static struct dma_async_tx_descriptor *
-fsl_dma_prep_interrupt(struct dma_chan *chan, unsigned long flags)
-{
-	struct fsl_dma_chan *fsl_chan;
-	struct fsl_desc_sw *new;
-
-	if (!chan)
-		return NULL;
-
-	fsl_chan = to_fsl_chan(chan);
-
-	new = fsl_dma_alloc_descriptor(fsl_chan);
-	if (!new) {
-		dev_err(fsl_chan->dev, "No free memory for link descriptor\n");
-		return NULL;
-	}
-
-	new->async_tx.cookie = -EBUSY;
-	new->async_tx.flags = flags;
-
-	/* Insert the link descriptor to the LD ring */
-	list_add_tail(&new->node, &new->tx_list);
-
-	/* Set End-of-link to the last link descriptor of new list*/
-	set_ld_eol(fsl_chan, new);
-
-	return &new->async_tx;
-}
-
 static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
 	struct dma_chan *chan, dma_addr_t dma_dest, dma_addr_t dma_src,
 	size_t len, unsigned long flags)
@@ -1200,11 +1171,9 @@ static int __devinit of_fsl_dma_probe(struct of_device *dev,
 						- fdev->reg.start + 1);
 
 	dma_cap_set(DMA_MEMCPY, fdev->common.cap_mask);
-	dma_cap_set(DMA_INTERRUPT, fdev->common.cap_mask);
 	dma_cap_set(DMA_SLAVE, fdev->common.cap_mask);
 	fdev->common.device_alloc_chan_resources = fsl_dma_alloc_chan_resources;
 	fdev->common.device_free_chan_resources = fsl_dma_free_chan_resources;
-	fdev->common.device_prep_dma_interrupt = fsl_dma_prep_interrupt;
 	fdev->common.device_prep_dma_memcpy = fsl_dma_prep_memcpy;
 	fdev->common.device_is_tx_complete = fsl_dma_is_complete;
 	fdev->common.device_issue_pending = fsl_dma_memcpy_issue_pending;
-- 
1.6.4.2

