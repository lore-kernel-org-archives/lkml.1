Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab0CBUSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 15:18:00 -0500
Received: from mail.df.lth.se ([194.47.250.12]:59632 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756649Ab0CBUMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 15:12:49 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 4/5] DMAENGINE: COH 901 318 configure channel direction
Date: Tue,  2 Mar 2010 21:12:46 +0100
Message-Id: <1267560766-17822-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the COH 901 318 configure channel direction (to or from
device) dynamically, instead of being passed in from the platform
data. This was necessary in order to get the MMC/SD-card channel
bidirectional (all other channels on the U300 were either RX or
TX but this one was both). This also sets memcpy() alignent to
even 2^2 (32bit) boundaries, which makes the memcpy() stress tests
start working.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/coh901318.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index 544c462..1656fdc 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -928,6 +928,7 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	struct coh901318_chan *cohc = to_coh901318_chan(chan);
 	struct coh901318_lli *data;
 	struct coh901318_desc *cohd;
+	const struct coh901318_params *params;
 	struct scatterlist *sg;
 	int len = 0;
 	int size;
@@ -935,6 +936,7 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	u32 ctrl_chained = cohc_chan_param(cohc)->ctrl_lli_chained;
 	u32 ctrl = cohc_chan_param(cohc)->ctrl_lli;
 	u32 ctrl_last = cohc_chan_param(cohc)->ctrl_lli_last;
+	u32 config;
 	unsigned long flg;
 	int ret;
 
@@ -952,10 +954,14 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		/* Trigger interrupt after last lli */
 		ctrl_last |= COH901318_CX_CTRL_TC_IRQ_ENABLE;
 
+	params = cohc_chan_param(cohc);
+	config = params->config;
+
 	if (direction == DMA_TO_DEVICE) {
 		u32 tx_flags = COH901318_CX_CTRL_PRDD_SOURCE |
 			COH901318_CX_CTRL_SRC_ADDR_INC_ENABLE;
 
+		config |= COH901318_CX_CFG_RM_MEMORY_TO_PRIMARY;
 		ctrl_chained |= tx_flags;
 		ctrl_last |= tx_flags;
 		ctrl |= tx_flags;
@@ -963,12 +969,15 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		u32 rx_flags = COH901318_CX_CTRL_PRDD_DEST |
 			COH901318_CX_CTRL_DST_ADDR_INC_ENABLE;
 
+		config |= COH901318_CX_CFG_RM_PRIMARY_TO_MEMORY;
 		ctrl_chained |= rx_flags;
 		ctrl_last |= rx_flags;
 		ctrl |= rx_flags;
 	} else
 		goto err_direction;
 
+	coh901318_set_conf(cohc, config);
+
 	/* The dma only supports transmitting packages up to
 	 * MAX_DMA_PACKET_SIZE. Calculate to total number of
 	 * dma elemts required to send the entire sg list
@@ -1250,6 +1259,11 @@ static int __init coh901318_probe(struct platform_device *pdev)
 	base->dma_memcpy.device_issue_pending = coh901318_issue_pending;
 	base->dma_memcpy.device_terminate_all = coh901318_terminate_all;
 	base->dma_memcpy.dev = &pdev->dev;
+	/*
+	 * This controller can only access address at even 32bit boundaries,
+	 * i.e. 2^2
+	 */
+	base->dma_memcpy.copy_align = 2;
 	err = dma_async_device_register(&base->dma_memcpy);
 
 	if (err)
-- 
1.6.3.3

