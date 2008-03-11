Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYCKD1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYCKD1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 23:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYCKD1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 23:27:35 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:40138 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbYCKD1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 23:27:34 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 2/2] Add device_prep_dma_interrupt support to fsldma.c
Date: Tue, 11 Mar 2008 11:25:17 +0800
Message-Id: <1205205917-21861-2-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1205205917-21861-1-git-send-email-wei.zhang@freescale.com>
References: <1205205917-21861-1-git-send-email-wei.zhang@freescale.com>
X-OriginalArrivalTime: 11 Mar 2008 03:27:16.0433 (UTC) FILETIME=[CE125410:01C88327]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a bug that I assigned DMA_INTERRUPT capability to fsldma
but missing device_prep_dma_interrupt function. For a bug in
dmaengine.c the driver passed BUG_ON() checking. The patch fixes it.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 drivers/dma/fsldma.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 5dfedf3..5428f81 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -406,6 +406,32 @@ static void fsl_dma_free_chan_resources(struct dma_chan *chan)
 	dma_pool_destroy(fsl_chan->desc_pool);
 }
 
+static struct dma_async_tx_descriptor *fsl_dma_prep_interrupt(
+						struct dma_chan *chan)
+{
+	struct fsl_dma_chan *fsl_chan;
+	struct fsl_desc_sw *new;
+
+	if (!chan)
+		return NULL;
+
+	fsl_chan = to_fsl_chan(chan);
+
+	new = fsl_dma_alloc_descriptor(fsl_chan);
+	if (!new) {
+		dev_err(fsl_chan->dev, "No free memory for link descriptor\n");
+		return NULL;
+	}
+
+	new->async_tx.cookie = -EBUSY;
+	new->async_tx.ack = 0;
+
+	/* Set End-of-link to the last link descriptor of new list*/
+	set_ld_eol(fsl_chan, new);
+
+	return &new->async_tx;
+}
+
 static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
 	struct dma_chan *chan, dma_addr_t dma_dest, dma_addr_t dma_src,
 	size_t len, unsigned long flags)
@@ -1020,6 +1046,7 @@ static int __devinit of_fsl_dma_probe(struct of_device *dev,
 	dma_cap_set(DMA_INTERRUPT, fdev->common.cap_mask);
 	fdev->common.device_alloc_chan_resources = fsl_dma_alloc_chan_resources;
 	fdev->common.device_free_chan_resources = fsl_dma_free_chan_resources;
+	fdev->common.device_prep_dma_interrupt = fsl_dma_prep_interrupt;
 	fdev->common.device_prep_dma_memcpy = fsl_dma_prep_memcpy;
 	fdev->common.device_is_tx_complete = fsl_dma_is_complete;
 	fdev->common.device_issue_pending = fsl_dma_memcpy_issue_pending;
-- 
1.5.4

