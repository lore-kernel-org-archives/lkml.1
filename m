Return-Path: <linux-kernel-owner+w=401wt.eu-S932938AbZIDGqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbZIDGqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 02:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932917AbZIDGqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 02:46:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:9784 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932698AbZIDGpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:45:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,330,1249282800"; 
   d="scan'208";a="723813490"
Subject: [PATCH 14/18] ioat3: interrupt descriptor support
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
Date: Thu, 03 Sep 2009 23:45:46 -0700
Message-ID: <20090904064546.7141.82403.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The async_tx api uses the DMA_INTERRUPT operation type to terminate a
chain of issued operations with a callback routine.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma_v3.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index bb57491..ff4afdc 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -120,7 +120,8 @@ static void ioat3_dma_unmap(struct ioat2_dma_chan *ioat,
 
 	switch (desc->hw->ctl_f.op) {
 	case IOAT_OP_COPY:
-		ioat_dma_unmap(chan, flags, len, desc->hw);
+		if (!desc->hw->ctl_f.null) /* skip 'interrupt' ops */
+			ioat_dma_unmap(chan, flags, len, desc->hw);
 		break;
 	case IOAT_OP_FILL: {
 		struct ioat_fill_descriptor *hw = desc->fill;
@@ -804,6 +805,38 @@ ioat3_prep_pqxor_val(struct dma_chan *chan, dma_addr_t *src,
 				    len, flags);
 }
 
+static struct dma_async_tx_descriptor *
+ioat3_prep_interrupt_lock(struct dma_chan *c, unsigned long flags)
+{
+	struct ioat2_dma_chan *ioat = to_ioat2_chan(c);
+	struct ioat_ring_ent *desc;
+	struct ioat_dma_descriptor *hw;
+	u16 idx;
+
+	if (ioat2_alloc_and_lock(&idx, ioat, 1) == 0)
+		desc = ioat2_get_ring_ent(ioat, idx);
+	else
+		return NULL;
+
+	hw = desc->hw;
+	hw->ctl = 0;
+	hw->ctl_f.null = 1;
+	hw->ctl_f.int_en = 1;
+	hw->ctl_f.fence = !!(flags & DMA_PREP_FENCE);
+	hw->ctl_f.compl_write = 1;
+	hw->size = NULL_DESC_BUFFER_SIZE;
+	hw->src_addr = 0;
+	hw->dst_addr = 0;
+
+	desc->txd.flags = flags;
+	desc->len = 1;
+
+	dump_desc_dbg(ioat, desc);
+
+	/* we leave the channel locked to ensure in order submission */
+	return &desc->txd;
+}
+
 static void __devinit ioat3_dma_test_callback(void *dma_async_param)
 {
 	struct completion *cmp = dma_async_param;
@@ -1098,6 +1131,10 @@ int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 	dma->device_alloc_chan_resources = ioat2_alloc_chan_resources;
 	dma->device_free_chan_resources = ioat2_free_chan_resources;
 	dma->device_is_tx_complete = ioat3_is_complete;
+
+	dma_cap_set(DMA_INTERRUPT, dma->cap_mask);
+	dma->device_prep_dma_interrupt = ioat3_prep_interrupt_lock;
+
 	cap = readl(device->reg_base + IOAT_DMA_CAP_OFFSET);
 	if (cap & IOAT_CAP_FILL_BLOCK) {
 		dma_cap_set(DMA_MEMSET, dma->cap_mask);

