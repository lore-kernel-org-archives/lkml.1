Return-Path: <linux-kernel-owner+w=401wt.eu-S965286AbXIGKpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965286AbXIGKpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 06:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965124AbXIGKpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 06:45:21 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:59414 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965121AbXIGKpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 06:45:18 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: paulus@samba.org, shannon.nelson@intel.com
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       galak@kernel.crashing.org, Zhang Wei <wei.zhang@freescale.com>,
       Ebony Zhu <ebony.zhu@freescale.com>
Subject: [PATCH 5/5] Add DMA engine driver for Freescale MPC85xx processors.
Date: Fri,  7 Sep 2007 18:54:18 +0800
Message-Id: <11891624582950-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.2
X-OriginalArrivalTime: 07 Sep 2007 10:45:08.0652 (UTC) FILETIME=[28B34EC0:01C7F13C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The driver implements DMA engine API for Freescale MPC85xx DMA
controller, which could be used for MEM<-->MEM, IO_ADDR<-->MEM
and IO_ADDR<-->IO_ADDR data transfer.
The driver supports the Basic mode of Freescale MPC85xx DMA controller.
The MPC85xx processors supported include MPC8540/60, MPC8555, MPC8548,
MPC8641 and so on.
The support for MPC83xx(MPC8349, MPC8360) is experimental.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
Signed-off-by: Ebony Zhu <ebony.zhu@freescale.com>
---
 drivers/dma/Kconfig  |    8 +
 drivers/dma/Makefile |    1 +
 drivers/dma/fsldma.c |  995 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/fsldma.h |  188 ++++++++++
 4 files changed, 1192 insertions(+), 0 deletions(-)
 create mode 100644 drivers/dma/fsldma.c
 create mode 100644 drivers/dma/fsldma.h

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 8f670da..a99e925 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -40,4 +40,12 @@ config INTEL_IOP_ADMA
         ---help---
           Enable support for the Intel(R) IOP Series RAID engines.
 
+config FSL_DMA
+	bool "Freescale MPC85xx/MPC83xx DMA support"
+	depends on DMA_ENGINE && PPC
+	---help---
+	  Enable support for the Freescale DMA engine. Now, it support
+	  MPC8560/40, MPC8555, MPC8548 and MPC8641 processors.
+	  The MPC8349, MPC8360 support is experimental.
+
 endmenu
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index b3839b6..50ab26c 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_DMA_ENGINE) += dmaengine.o
 obj-$(CONFIG_NET_DMA) += iovlock.o
 obj-$(CONFIG_INTEL_IOATDMA) += ioatdma.o
 obj-$(CONFIG_INTEL_IOP_ADMA) += iop-adma.o
+obj-$(CONFIG_FSL_DMA) += fsldma.o
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
new file mode 100644
index 0000000..9e2d56b
--- /dev/null
+++ b/drivers/dma/fsldma.c
@@ -0,0 +1,995 @@
+/*
+ * Freescale MPC85xx, MPC83xx DMA Engine support
+ *
+ * Copyright (C) 2007 Freescale Semiconductor, Inc. All rights reserved.
+ *
+ * Author:
+ *   Zhang Wei <wei.zhang@freescale.com>, Jul 2007
+ *   Ebony Zhu <ebony.zhu@freescale.com>, May 2007
+ *
+ * Description:
+ *   DMA engine driver for Freescale MPC8540 DMA controller, which is
+ *   also fit for MPC8560, MPC8555, MPC8548, MPC8641, and etc.
+ *   The support for MPC8349 DMA contorller is also added. But it's
+ *   ONLY experimental for MPC8349 now.
+ *
+ * This is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/dmaengine.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmapool.h>
+#include <linux/of_platform.h>
+
+#include "fsldma.h"
+
+static LIST_HEAD(recy_ln_chain);	/* ld chain for recycle */
+static spinlock_t recy_ln_lock = SPIN_LOCK_UNLOCKED;
+
+static void dma_do_tasklet(unsigned long unused);
+static DECLARE_TASKLET(dma_tasklet, dma_do_tasklet, 0);
+
+#define to_fsl_chan(chan) container_of(chan, struct fsl_dma_chan, common)
+#define to_fsl_desc(lh) container_of(lh, struct fsl_desc_sw, node)
+#define tx_to_fsl_desc(tx) container_of(tx, struct fsl_desc_sw, async_tx)
+
+static void dma_init(struct fsl_dma_chan *fsl_chan)
+{
+	/* Reset the channel */
+	MIX_OUT(fsl_chan, &fsl_chan->reg_base->mr, 0, 32);
+
+	switch (fsl_chan->feature & FSL_DMA_IP_MASK) {
+	case FSL_DMA_IP_86XX:
+		/* Set the channel to below modes:
+		 * EIE - Error interrupt enable
+		 * EOSIE - End of segments interrupt enable (basic mode)
+		 * EOLNIE - End of links interrupt enable
+		 */
+		MIX_OUT(fsl_chan, &fsl_chan->reg_base->mr, FSL_DMA_MR_EIE
+				| FSL_DMA_MR_EOLNIE | FSL_DMA_MR_EOSIE, 32);
+		break;
+	case FSL_DMA_IP_83XX:
+		/* Set the channel to below modes:
+		 * EOTIE - End-of-transfer interrupt enable
+		 */
+		MIX_OUT(fsl_chan, &fsl_chan->reg_base->mr, FSL_DMA_MR_EOTIE,
+				32);
+		break;
+	}
+
+}
+
+static void set_sr(struct fsl_dma_chan *fsl_chan, dma_addr_t val)
+{
+	MIX_OUT(fsl_chan, &fsl_chan->reg_base->sr, val, 32);
+}
+
+static dma_addr_t get_sr(struct fsl_dma_chan *fsl_chan)
+{
+	return MIX_IN(fsl_chan, &fsl_chan->reg_base->sr, 32);
+}
+
+static void get_desc(struct fsl_dma_chan *fsl_chan, struct fsl_dma_ld_hw *hw,
+			struct fsl_ld_desc *ld)
+{
+	BUG_ON(!hw);
+
+	ld->src = MIX_TO_CPU(fsl_chan, hw->src_addr, 64);
+	ld->dest = MIX_TO_CPU(fsl_chan, hw->dst_addr, 64);
+	ld->count = MIX_TO_CPU(fsl_chan, hw->count, 32);
+	ld->next_ld_desc = MIX_TO_CPU(fsl_chan, hw->next_ln_addr, 64);
+
+	switch (fsl_chan->feature & FSL_DMA_IP_MASK) {
+	case FSL_DMA_IP_86XX:
+		ld->src &= (dma_addr_t)0x0000ffffffffffffull;
+		ld->dest &= (dma_addr_t)0x0000ffffffffffffull;
+		break;
+	case FSL_DMA_IP_83XX:
+		ld->next_ld_desc &= ~FSL_DMA_SNEN;
+		break;
+	}
+}
+
+static void set_desc(struct fsl_dma_chan *fsl_chan, struct fsl_dma_ld_hw *hw,
+			struct fsl_ld_desc *ld)
+{
+	hw->src_addr = (__mix64)CPU_TO_MIX(fsl_chan, ld->src, 64);
+	hw->dst_addr = (__mix64)CPU_TO_MIX(fsl_chan, ld->dest, 64);
+	hw->count = (__mix32)CPU_TO_MIX(fsl_chan, ld->count, 32);
+	hw->next_ln_addr = (__mix64)CPU_TO_MIX(fsl_chan, ld->next_ld_desc, 64);
+
+	switch (fsl_chan->feature & FSL_DMA_IP_MASK) {
+	case FSL_DMA_IP_86XX:
+		hw->src_addr.be |= CPU_TO_MIX(fsl_chan,
+					(u64)FSL_DMA_SATR_SREADTYPE_SNOOP_READ
+					<< 32, 64);
+		hw->dst_addr.be |= CPU_TO_MIX(fsl_chan,
+					(u64)FSL_DMA_DATR_DWRITETYPE_SNOOP_WRITE
+					<< 32, 64);
+		break;
+	case FSL_DMA_IP_83XX:
+		hw->next_ln_addr.le |= CPU_TO_MIX(fsl_chan, FSL_DMA_SNEN, 64);
+		break;
+	}
+}
+
+static void set_cdar(struct fsl_dma_chan *fsl_chan, dma_addr_t addr)
+{
+	MIX_OUT(fsl_chan, &fsl_chan->reg_base->cdar, addr | FSL_DMA_SNEN, 64);
+}
+
+static dma_addr_t get_cdar(struct fsl_dma_chan *fsl_chan)
+{
+	return MIX_IN(fsl_chan, &fsl_chan->reg_base->cdar, 64) & ~FSL_DMA_SNEN;
+}
+
+static void set_ndar(struct fsl_dma_chan *fsl_chan, dma_addr_t addr)
+{
+	MIX_OUT(fsl_chan, &fsl_chan->reg_base->ndar, addr, 64);
+}
+
+static dma_addr_t get_ndar(struct fsl_dma_chan *fsl_chan)
+{
+	return MIX_IN(fsl_chan, &fsl_chan->reg_base->ndar, 64);
+}
+
+static int dma_is_idle(struct fsl_dma_chan *fsl_chan)
+{
+	return (get_sr(fsl_chan) & FSL_DMA_SR_CB) == 0;
+}
+
+static void dma_start(struct fsl_dma_chan *fsl_chan)
+{
+	MIX_OUT(fsl_chan, &fsl_chan->reg_base->mr,
+		MIX_IN(fsl_chan, &fsl_chan->reg_base->mr, 32) | FSL_DMA_MR_CS,
+		32);
+}
+
+static void dma_halt(struct fsl_dma_chan *fsl_chan)
+{
+	MIX_OUT(fsl_chan, &fsl_chan->reg_base->mr,
+		MIX_IN(fsl_chan, &fsl_chan->reg_base->mr, 32) & ~FSL_DMA_MR_CS,
+		32);
+}
+
+static void set_ld_eol(struct fsl_dma_chan *fsl_chan,
+			struct fsl_desc_sw *desc)
+{
+	struct fsl_ld_desc ld;
+	get_desc(fsl_chan, &desc->hw, &ld);
+	ld.next_ld_desc |= FSL_DMA_EOL;
+	set_desc(fsl_chan, &desc->hw, &ld);
+}
+
+static void append_ld_queue(struct fsl_dma_chan *fsl_chan,
+		struct fsl_desc_sw *new_desc)
+{
+	struct fsl_ld_desc ld;
+	struct fsl_desc_sw *queue_tail = to_fsl_desc(fsl_chan->ld_queue.prev);
+
+	if (list_empty(&fsl_chan->ld_queue))
+		return;
+
+	get_desc(fsl_chan, &queue_tail->hw, &ld);
+	/* Link to the new descript physical address and
+	 * Enable End-of-segment interrupt for
+	 * the last link descriptor.
+	 * (the previous node's next link descriptor)
+	 */
+	ld.next_ld_desc = new_desc->async_tx.phys | FSL_DMA_EOSIE;
+	set_desc(fsl_chan, &queue_tail->hw, &ld);
+}
+
+static void fsl_dma_set_src(dma_addr_t addr,
+				struct dma_async_tx_descriptor *tx, int index)
+{
+	struct fsl_desc_sw *desc_node, *desc = tx_to_fsl_desc(tx);
+	struct fsl_dma_chan *fsl_chan = to_fsl_chan(tx->chan);
+
+	list_for_each_entry(desc_node, &desc->async_tx.tx_list, node) {
+		struct fsl_ld_desc ld;
+		get_desc(fsl_chan, &desc_node->hw, &ld);
+		ld.src = addr;
+		set_desc(fsl_chan, &desc_node->hw, &ld);
+		addr += FSL_DMA_BCR_MAX_CNT;
+	}
+}
+
+static void fsl_dma_set_dest(dma_addr_t addr,
+				struct dma_async_tx_descriptor *tx, int index)
+{
+	struct fsl_desc_sw *desc_node, *desc = tx_to_fsl_desc(tx);
+	struct fsl_dma_chan *fsl_chan = to_fsl_chan(tx->chan);
+
+	list_for_each_entry(desc_node, &desc->async_tx.tx_list, node) {
+		struct fsl_ld_desc ld;
+		get_desc(fsl_chan, &desc_node->hw, &ld);
+		ld.dest = addr;
+		set_desc(fsl_chan, &desc_node->hw, &ld);
+		addr += FSL_DMA_BCR_MAX_CNT;
+	}
+}
+
+static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
+{
+	struct fsl_desc_sw *desc = tx_to_fsl_desc(tx);
+	struct fsl_dma_chan *fsl_chan = to_fsl_chan(tx->chan);
+	unsigned long flags;
+	dma_cookie_t cookie;
+
+	/* cookie increment and adding to ld_queue must be atomic */
+	spin_lock_irqsave(&fsl_chan->desc_lock, flags);
+
+	cookie = fsl_chan->common.cookie;
+	cookie++;
+	if (cookie < 0)
+		cookie = 1;
+	desc->async_tx.cookie = cookie;
+	fsl_chan->common.cookie = desc->async_tx.cookie;
+
+	append_ld_queue(fsl_chan, desc);
+	list_splice_init(&desc->async_tx.tx_list, fsl_chan->ld_queue.prev);
+
+	spin_unlock_irqrestore(&fsl_chan->desc_lock, flags);
+
+	return cookie;
+}
+
+/**
+ * fsl_dma_alloc_descriptor - Allocate descriptor from channel's DMA pool.
+ *
+ * Return - The descriptor allocated. NULL for failed.
+ */
+static struct fsl_desc_sw *fsl_dma_alloc_descriptor(
+					struct fsl_dma_chan *fsl_chan,
+					gfp_t flags)
+{
+	dma_addr_t pdesc;
+	struct fsl_desc_sw *desc_sw;
+
+	desc_sw = dma_pool_alloc(fsl_chan->desc_pool, flags, &pdesc);
+	if (desc_sw) {
+		memset(desc_sw, 0, sizeof(struct fsl_desc_sw));
+		dma_async_tx_descriptor_init(&desc_sw->async_tx,
+						&fsl_chan->common);
+		desc_sw->async_tx.tx_set_src = fsl_dma_set_src;
+		desc_sw->async_tx.tx_set_dest = fsl_dma_set_dest;
+		desc_sw->async_tx.tx_submit = fsl_dma_tx_submit;
+		INIT_LIST_HEAD(&desc_sw->async_tx.tx_list);
+		desc_sw->async_tx.phys = pdesc;
+	}
+
+	return desc_sw;
+}
+
+
+/**
+ * fsl_dma_alloc_chan_resources - Allocate resources for DMA channel.
+ *
+ * This function will create a dma pool for descriptor allocation.
+ *
+ * Return - The number of descriptors allocated.
+ */
+static int fsl_dma_alloc_chan_resources(struct dma_chan *chan)
+{
+	struct fsl_dma_chan *fsl_chan = to_fsl_chan(chan);
+	LIST_HEAD(tmp_list);
+
+	/* We need the descriptor to be aligned to 32bytes
+	 * for meeting FSL DMA specification requirement.
+	 */
+	fsl_chan->desc_pool = dma_pool_create("fsl_dma_engine_desc_pool",
+			fsl_chan->device->dev, sizeof(struct fsl_desc_sw),
+			32, 0);
+	if (!fsl_chan->desc_pool) {
+		dev_err(fsl_chan->device->dev, "No memory for channel %d "
+			"descriptor dma pool.\n", fsl_chan->id);
+		return 0;
+	}
+
+	return 1;
+}
+
+/**
+ * fsl_dma_free_chan_resources - Free all resources of the channel.
+ */
+static void fsl_dma_free_chan_resources(struct dma_chan *chan)
+{
+	struct fsl_dma_chan *fsl_chan = to_fsl_chan(chan);
+	struct fsl_desc_sw *desc, *_desc;
+	unsigned long flags;
+
+	dev_dbg(fsl_chan->device->dev, "Free all channel resources.\n");
+	spin_lock_irqsave(&fsl_chan->desc_lock, flags);
+	list_for_each_entry_safe(desc, _desc, &fsl_chan->ld_queue, node) {
+#ifdef FSL_DMA_LD_DEBUG
+		dev_dbg(fsl_chan->device->dev,
+				"LD %p will be released.\n", desc);
+#endif
+		list_del(&desc->node);
+		/* free link descritpor */
+		dma_pool_free(fsl_chan->desc_pool, desc, desc->async_tx.phys);
+	}
+	spin_unlock_irqrestore(&fsl_chan->desc_lock, flags);
+	dma_pool_destroy(fsl_chan->desc_pool);
+}
+
+static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
+				struct dma_chan *chan, size_t len, int int_en)
+{
+	struct fsl_dma_chan *fsl_chan;
+	struct fsl_desc_sw *first = NULL, *prev = NULL, *new;
+	size_t copy;
+	struct fsl_dma_device *fdev;
+	LIST_HEAD(link_chain);
+
+	if (!chan)
+		return NULL;
+
+	if (!len)
+		return NULL;
+
+	fsl_chan = to_fsl_chan(chan);
+	fdev = fsl_chan->device;
+
+	do {
+		struct fsl_ld_desc ld;
+
+		/* Allocate the link descriptor from DMA pool */
+		new = fsl_dma_alloc_descriptor(fsl_chan, GFP_ATOMIC);
+		if (!new) {
+			dev_err(fdev->dev,
+					"No free memory for link descriptor\n");
+			return NULL;
+		}
+#ifdef FSL_DMA_LD_DEBUG
+		dev_dbg(fdev->dev, "new link desc alloc %p\n", new);
+#endif
+
+		copy = min(len, FSL_DMA_BCR_MAX_CNT);
+
+		memset(&ld, 0, sizeof(struct fsl_ld_desc));
+		ld.count = copy;
+		set_desc(fsl_chan, &new->hw, &ld);
+
+		if (!first)
+			first = new;
+		else {
+			get_desc(fsl_chan, &prev->hw, &ld);
+			ld.next_ld_desc = new->async_tx.phys;
+			set_desc(fsl_chan, &prev->hw, &ld);
+		}
+
+		new->async_tx.cookie = 0;
+		new->async_tx.ack = 1;
+
+		prev = new;
+		len -= copy;
+
+		/* Insert the link descriptor to the LD ring */
+		list_add_tail(&new->node, &first->async_tx.tx_list);
+	} while (len);
+
+	new->async_tx.ack = 0; /* client is in control of this ack */
+	new->async_tx.cookie = -EBUSY;
+
+	/* Set End-of-link to the last link descriptor of new list*/
+	set_ld_eol(fsl_chan, new);
+
+	return first ? &first->async_tx : NULL;
+}
+
+/**
+ * fsl_dma_update_completed_cookie - Update the completed cookie.
+ */
+static void fsl_dma_update_completed_cookie(struct fsl_dma_chan *fsl_chan)
+{
+	struct fsl_desc_sw *cur_desc;
+	dma_addr_t ld_phy;
+
+	ld_phy = get_cdar(fsl_chan) & FSL_DMA_NLDA_MASK;
+
+	if (ld_phy) {
+		cur_desc = (struct fsl_desc_sw *)bus_to_virt(ld_phy);
+
+		if (cur_desc->async_tx.cookie) {
+			if (dma_is_idle(fsl_chan))
+				fsl_chan->completed_cookie =
+					cur_desc->async_tx.cookie;
+			else
+				fsl_chan->completed_cookie =
+					cur_desc->async_tx.cookie - 1;
+		}
+	}
+}
+
+/**
+ * fsl_chan_ld_cleanup -- Clean up link descriptors
+ *
+ * This function clean up the ld_queue of DMA channel.
+ * If 'in_intr' is set, the function will move the link descriptor to
+ * the recycle list. Otherwise, free it directly.
+ */
+static void fsl_chan_ld_cleanup(struct fsl_dma_chan *fsl_chan, int in_intr)
+{
+	struct fsl_desc_sw *desc, *_desc;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fsl_chan->desc_lock, flags);
+
+	fsl_dma_update_completed_cookie(fsl_chan);
+	dev_dbg(fsl_chan->device->dev,
+			"chan completed_cookie = %d\n",
+			fsl_chan->completed_cookie);
+	list_for_each_entry_safe(desc, _desc, &fsl_chan->ld_queue, node) {
+		if (DMA_IN_PROGRESS == dma_async_is_complete(
+					desc->async_tx.cookie,
+					fsl_chan->completed_cookie,
+					fsl_chan->common.cookie))
+			break;
+
+		/* Remove from ld_queue list */
+		list_del(&desc->node);
+
+		/* If this function is called by interrupt action,
+		 * we just move to recycle list.
+		 * Otherwise, we free it.
+		 */
+		if (in_intr)
+			list_add_tail(&desc->node, &recy_ln_chain);
+		else {
+			/* Run the link descriptor callback function */
+			if (desc->async_tx.callback) {
+				spin_unlock_irqrestore(&fsl_chan->desc_lock,
+								flags);
+				dev_dbg(fsl_chan->device->dev,
+					"link descriptor %p callback\n", desc);
+				desc->async_tx.callback(
+						desc->async_tx.callback_param);
+				spin_lock_irqsave(&fsl_chan->desc_lock, flags);
+			}
+
+			dev_dbg(fsl_chan->device->dev,
+				"link descriptor %p will be recycle.\n", desc);
+			dma_pool_free(fsl_chan->desc_pool, desc,
+						desc->async_tx.phys);
+		}
+	}
+	spin_unlock_irqrestore(&fsl_chan->desc_lock, flags);
+}
+
+/**
+ * fsl_chan_xfer_ld_queue -- Transfer the link descriptors in channel
+ *                           ld_queue.
+ */
+static void fsl_chan_xfer_ld_queue(struct fsl_dma_chan *fsl_chan)
+{
+	struct list_head *ld_node;
+	dma_addr_t next_dest_addr;
+	unsigned long flags;
+
+	if (!dma_is_idle(fsl_chan))
+		return;
+
+	dma_halt(fsl_chan);
+
+	/* If there are some link descriptors
+	 * not transfered in queue. We need to start it.
+	 */
+	spin_lock_irqsave(&fsl_chan->desc_lock, flags);
+
+	/* Find the first un-transfer desciptor */
+	for (ld_node = fsl_chan->ld_queue.next;
+		(ld_node != &fsl_chan->ld_queue)
+			&& (DMA_SUCCESS == dma_async_is_complete(
+					to_fsl_desc(ld_node)->async_tx.cookie,
+					fsl_chan->completed_cookie,
+					fsl_chan->common.cookie));
+		ld_node = ld_node->next);
+
+	spin_unlock_irqrestore(&fsl_chan->desc_lock, flags);
+
+	if (ld_node != &fsl_chan->ld_queue) {
+		/* Get the ld start address from ld_queue */
+		next_dest_addr = to_fsl_desc(ld_node)->async_tx.phys;
+		dev_dbg(fsl_chan->device->dev,
+			"xfer LDs staring from 0x%016llx\n",
+			(u64)next_dest_addr);
+		set_cdar(fsl_chan, next_dest_addr);
+		dma_start(fsl_chan);
+	} else {
+		set_cdar(fsl_chan, 0);
+		set_ndar(fsl_chan, 0);
+	}
+}
+
+/**
+ * fsl_dma_memcpy_issue_pending -- Issue the DMA start command
+ */
+static void fsl_dma_memcpy_issue_pending(struct dma_chan *chan)
+{
+	struct fsl_dma_chan *fsl_chan = to_fsl_chan(chan);
+
+#ifdef FSL_DMA_LD_DEBUG
+	struct fsl_desc_sw *ld;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fsl_chan->desc_lock, flags);
+	if (list_empty(&fsl_chan->ld_queue)) {
+		spin_unlock_irqrestore(&fsl_chan->desc_lock, flags);
+		return;
+	}
+
+	dev_dbg(fsl_chan->device->dev, "--memcpy issue--\n");
+	list_for_each_entry(ld, &fsl_chan->ld_queue, node) {
+		int i;
+		dev_dbg(fsl_chan->device->dev, "Ch %d, LD %08x\n",
+				fsl_chan->id, ld->async_tx.phys);
+		for (i = 0; i < 8; i++)
+			dev_dbg(fsl_chan->device->dev,
+					"LD offset %d: %08x\n",
+					i, *(((u32 *)&ld->hw) + i));
+	}
+	dev_dbg(fsl_chan->device->dev, "----------------\n");
+	spin_unlock_irqrestore(&fsl_chan->desc_lock, flags);
+#endif
+
+	fsl_chan_xfer_ld_queue(fsl_chan);
+}
+
+static void fsl_dma_dependency_added(struct dma_chan *chan)
+{
+	struct fsl_dma_chan *fsl_chan = to_fsl_chan(chan);
+
+	fsl_chan_ld_cleanup(fsl_chan, 0);
+}
+
+/**
+ * fsl_dma_is_complete -- Determine the DMA status
+ */
+static enum dma_status fsl_dma_is_complete(struct dma_chan *chan,
+					dma_cookie_t cookie,
+					dma_cookie_t *done,
+					dma_cookie_t *used)
+{
+	struct fsl_dma_chan *fsl_chan = to_fsl_chan(chan);
+	dma_cookie_t last_used;
+	dma_cookie_t last_complete;
+
+	fsl_chan_ld_cleanup(fsl_chan, 0);
+
+	last_used = chan->cookie;
+	last_complete = fsl_chan->completed_cookie;
+
+	if (done)
+		*done = last_complete;
+
+	if (used)
+		*used = last_used;
+
+	return dma_async_is_complete(cookie, last_complete, last_used);
+}
+
+static irqreturn_t fsl_dma_chan_do_interrupt(int irq, void *data)
+{
+	struct fsl_dma_chan *fsl_chan = (struct fsl_dma_chan *)data;
+	dma_addr_t stat;
+
+	stat = get_sr(fsl_chan);
+	dev_dbg(fsl_chan->device->dev, "event: channel %d, stat = 0x%x\n",
+						fsl_chan->id, stat);
+	set_sr(fsl_chan, stat);		/* Clear the event register */
+
+	stat &= ~(FSL_DMA_SR_CB | FSL_DMA_SR_CH);
+	if (!stat)
+		return IRQ_NONE;
+
+	/* If the link descriptor segment transfer finishes,
+	 * we will recycle the used descriptor.
+	 */
+	if (stat & FSL_DMA_SR_EOSI) {
+		dev_dbg(fsl_chan->device->dev, "event: End-of-segments INT\n");
+		dev_dbg(fsl_chan->device->dev, "event: clndar 0x%016llx, "
+				"nlndar 0x%016llx\n", (u64)get_cdar(fsl_chan),
+				(u64)get_ndar(fsl_chan));
+		stat &= ~FSL_DMA_SR_EOSI;
+		fsl_chan_ld_cleanup(fsl_chan, 1);
+	}
+
+	/* If it current transfer is the end-of-transfer,
+	 * we should clear the Channel Start bit for
+	 * prepare next transfer.
+	 */
+	if (stat & (FSL_DMA_SR_EOLNI | FSL_DMA_SR_EOCDI)) {
+		dev_dbg(fsl_chan->device->dev, "event: End-of-link INT\n");
+		stat &= ~FSL_DMA_SR_EOLNI;
+		fsl_chan_xfer_ld_queue(fsl_chan);
+	}
+
+	if (stat)
+		dev_dbg(fsl_chan->device->dev, "event: unhandled sr 0x%02x\n",
+					stat);
+
+	dev_dbg(fsl_chan->device->dev, "event: Exit\n");
+	tasklet_hi_schedule(&dma_tasklet);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t fsl_dma_do_interrupt(int irq, void *data)
+{
+	struct fsl_dma_device *fdev = (struct fsl_dma_device *)data;
+	struct fsl_dma_chan *fsl_chan = NULL;
+	u32 gsr;
+	int ch_nr;
+	struct dma_chan *int_chan;
+
+	gsr = (fdev->feature & FSL_DMA_BIG_ENDIAN) ? in_be32(fdev->reg_base)
+			: in_le32(fdev->reg_base);
+	ch_nr = (32 - ffs(gsr)) / 8;
+
+	list_for_each_entry(int_chan, &fdev->common.channels, device_node)
+		if (to_fsl_chan(int_chan)->id == ch_nr)
+			fsl_chan = to_fsl_chan(int_chan);
+
+	return fsl_chan ? fsl_dma_chan_do_interrupt(irq, fsl_chan) : IRQ_NONE;
+
+}
+
+static void dma_do_tasklet(unsigned long unused)
+{
+	struct fsl_desc_sw *desc, *_desc;
+	unsigned long flags;
+
+	spin_lock_irqsave(&recy_ln_lock, flags);
+	list_for_each_entry_safe(desc, _desc, &recy_ln_chain, node) {
+		struct fsl_dma_chan *fsl_chan =
+					to_fsl_chan(desc->async_tx.chan);
+		/* Run the link descriptor callback function */
+		if (desc->async_tx.callback) {
+			spin_unlock_irqrestore(&recy_ln_lock, flags);
+			dev_dbg(fsl_chan->device->dev,
+				"dma_tasklet: link descriptor %p callback\n",
+				desc);
+			desc->async_tx.callback(
+					desc->async_tx.callback_param);
+			spin_lock_irqsave(&recy_ln_lock, flags);
+		}
+		/* Recycle it! */
+		list_del(&desc->node);
+		dev_dbg(fsl_chan->device->dev,
+			"dma_tasklet: link descriptor %p will be recycle.\n",
+			desc);
+		dma_pool_free(fsl_chan->desc_pool, desc,
+					desc->async_tx.phys);
+	}
+	spin_unlock_irqrestore(&recy_ln_lock, flags);
+}
+
+static int fsl_dma_self_test(struct fsl_dma_chan *fsl_chan)
+{
+	struct dma_chan *chan;
+	int err = 0;
+	dma_addr_t addr;
+	dma_cookie_t cookie;
+	u8 *src, *dest;
+	int i;
+	size_t test_size;
+	struct dma_async_tx_descriptor *tx1, *tx2, *tx3;
+	struct fsl_dma_device *fdev;
+
+	BUG_ON(!fsl_chan);
+
+	fdev = fsl_chan->device;
+	test_size = 4096;
+
+	src = kmalloc(test_size * 2, GFP_KERNEL);
+	if (!src) {
+		dev_err(fdev->dev,
+				"selftest: Can not alloc memory for test!\n");
+		err = -ENOMEM;
+		goto out;
+	}
+
+	dest = src + test_size;
+
+	for (i = 0; i < test_size; i++)
+		src[i] = (u8) i;
+
+	chan = &fsl_chan->common;
+
+	if (fsl_dma_alloc_chan_resources(chan) < 1) {
+		dev_err(fdev->dev,
+				"selftest: Can not alloc resources for DMA\n");
+		err = -ENODEV;
+		goto out;
+	}
+
+	/* TX 1 */
+	tx1 = fsl_dma_prep_memcpy(chan, test_size / 2, 0);
+	async_tx_ack(tx1);
+	addr = dma_map_single(chan->device->dev, src, test_size / 2,
+							DMA_TO_DEVICE);
+	fsl_dma_set_src(addr, tx1, 0);
+	addr = dma_map_single(chan->device->dev, dest, test_size / 2,
+							DMA_FROM_DEVICE);
+	fsl_dma_set_dest(addr, tx1, 0);
+
+	cookie = fsl_dma_tx_submit(tx1);
+	fsl_dma_memcpy_issue_pending(chan);
+
+	while (fsl_dma_is_complete(chan, cookie, NULL, NULL)
+			!= DMA_SUCCESS);
+
+	/* Test free and re-alloc channel resources */
+	fsl_dma_free_chan_resources(chan);
+
+	if (fsl_dma_alloc_chan_resources(chan) < 1) {
+		dev_err(fdev->dev,
+				"selftest: Can not alloc resources for DMA\n");
+		err = -ENODEV;
+		goto out;
+	}
+
+	/* Continue to test
+	 * TX 2
+	 */
+	tx2 = fsl_dma_prep_memcpy(chan, test_size / 4, 0);
+	async_tx_ack(tx2);
+	addr = dma_map_single(chan->device->dev, src + test_size / 2,
+					test_size / 4, DMA_TO_DEVICE);
+	fsl_dma_set_src(addr, tx2, 0);
+	addr = dma_map_single(chan->device->dev, dest + test_size / 2,
+					test_size / 4, DMA_FROM_DEVICE);
+	fsl_dma_set_dest(addr, tx2, 0);
+
+	/* TX 3 */
+	tx3 = fsl_dma_prep_memcpy(chan, test_size / 4, 0);
+	async_tx_ack(tx3);
+	addr = dma_map_single(chan->device->dev, src + test_size * 3 / 4,
+					test_size / 4, DMA_TO_DEVICE);
+	fsl_dma_set_src(addr, tx3, 0);
+	addr = dma_map_single(chan->device->dev, dest + test_size * 3 / 4,
+					test_size / 4, DMA_FROM_DEVICE);
+	fsl_dma_set_dest(addr, tx3, 0);
+
+	/* Test exchanging the prepared tx sort */
+	cookie = fsl_dma_tx_submit(tx3);
+	cookie = fsl_dma_tx_submit(tx2);
+
+	fsl_dma_memcpy_issue_pending(chan);
+	while (fsl_dma_is_complete(chan, cookie, NULL, NULL)
+			!= DMA_SUCCESS);
+	err = memcmp(src, dest, test_size);
+	if (err) {
+		for (i = 0; (*(src + i) == *(dest + i)) && (i < test_size);
+				i++);
+		dev_err(fdev->dev, "selftest: Test failed, data %d/%d is "
+				"error! src 0x%x, dest 0x%x\n",
+				i, test_size, *(src + i), *(dest + i));
+	}
+
+	fsl_dma_free_chan_resources(chan);
+
+out:
+	kfree(src);
+	return err;
+}
+
+static struct dma_chan *of_find_dma_chan_by_phandle(phandle phandle)
+{
+	struct device_node *np;
+	struct dma_chan *chan;
+	struct fsl_dma_device *fdev;
+
+	np = of_find_node_by_phandle(phandle);
+	if (!np || !of_device_is_compatible(np->parent, "fsl,dma"))
+		return NULL;
+
+	fdev = dev_get_drvdata(&of_find_device_by_node(np->parent)->dev);
+
+	list_for_each_entry(chan, &fdev->common.channels, device_node)
+		if (to_of_device(to_fsl_chan(chan)->chan_dev)->node == np)
+			return chan;
+	return NULL;
+}
+EXPORT_SYMBOL(of_find_dma_chan_by_phandle);
+
+static int __devinit of_fsl_dma_probe(struct of_device *dev,
+			const struct of_device_id *match)
+{
+	int err;
+	unsigned int irq;
+	struct fsl_dma_device *fdev;
+
+	fdev = kzalloc(sizeof(struct fsl_dma_device), GFP_KERNEL);
+	if (!fdev) {
+		dev_err(&dev->dev, "No enough memory for 'priv'\n");
+		err = -ENOMEM;
+		goto err;
+	}
+	fdev->dev = &dev->dev;
+	INIT_LIST_HEAD(&fdev->common.channels);
+
+	/* get DMA controller register base */
+	err = of_address_to_resource(dev->node, 0, &fdev->reg);
+	if (err) {
+		dev_err(&dev->dev, "Can't get %s property 'reg'\n",
+				dev->node->full_name);
+		goto err;
+	}
+
+	dev_info(&dev->dev, "Probe the Freescale DMA driver for %s "
+			"controller at 0x%08x...\n",
+			match->compatible, fdev->reg.start);
+	fdev->reg_base = ioremap(fdev->reg.start, fdev->reg.end
+						- fdev->reg.start + 1);
+
+	dma_cap_set(DMA_MEMCPY, fdev->common.cap_mask);
+	fdev->common.device_alloc_chan_resources = fsl_dma_alloc_chan_resources;
+	fdev->common.device_free_chan_resources = fsl_dma_free_chan_resources;
+	fdev->common.device_prep_dma_memcpy = fsl_dma_prep_memcpy;
+	fdev->common.device_is_tx_complete = fsl_dma_is_complete;
+	fdev->common.device_issue_pending = fsl_dma_memcpy_issue_pending;
+	fdev->common.device_dependency_added = fsl_dma_dependency_added;
+	fdev->common.dev = &dev->dev;
+
+	irq = irq_of_parse_and_map(dev->node, 0);
+	if (irq != NO_IRQ) {
+		err = request_irq(irq, &fsl_dma_do_interrupt, IRQF_SHARED,
+					"fsldma-device", fdev);
+		if (err) {
+			dev_err(&dev->dev, "DMA device request_irq error "
+				"with return %d\n", err);
+			goto err;
+		}
+	}
+
+	dev_set_drvdata(&(dev->dev), fdev);
+	dma_async_device_register(&fdev->common);
+	return 0;
+
+err:
+	iounmap(fdev->reg_base);
+	kfree(fdev);
+	return err;
+}
+
+static int __devinit of_fsl_dma_chan_probe(struct of_device *dev,
+			const struct of_device_id *match)
+{
+	struct fsl_dma_device *fdev;
+	struct fsl_dma_chan *new_fsl_chan;
+	int err;
+
+	fdev = dev_get_drvdata(dev->dev.parent);
+	BUG_ON(!fdev);
+
+	/* alloc channel */
+	new_fsl_chan = kzalloc(sizeof(struct fsl_dma_chan), GFP_KERNEL);
+	if (!new_fsl_chan) {
+		dev_err(&dev->dev, "No free memory for allocating "
+				"dma channels!\n");
+		err = -ENOMEM;
+		goto err;
+	}
+
+	/* get dma channel register base */
+	err = of_address_to_resource(dev->node, 0, &new_fsl_chan->reg);
+	if (err) {
+		dev_err(&dev->dev, "Can't get %s property 'reg'\n",
+				dev->node->full_name);
+		goto err;
+	}
+
+	if (strcmp(match->compatible, "fsl,mpc8540-dma-channel") == 0)
+		new_fsl_chan->feature = FSL_DMA_IP_86XX | FSL_DMA_BIG_ENDIAN;
+	else if (strcmp(match->compatible, "fsl,mpc8349-dma-channel") == 0)
+		new_fsl_chan->feature = FSL_DMA_IP_83XX | FSL_DMA_LITTLE_ENDIAN;
+	else {
+		dev_err(&dev->dev, "No channel operations!\n");
+		err = -EINVAL;
+		goto err;
+	}
+
+	if (!fdev->feature)
+		fdev->feature = new_fsl_chan->feature;
+
+	/* If the DMA device's feature is different than its channels',
+	 * report the bug.
+	 */
+	BUG_ON(fdev->feature != new_fsl_chan->feature);
+
+	new_fsl_chan->device = fdev;
+	new_fsl_chan->chan_dev = &dev->dev;
+	new_fsl_chan->reg_base = ioremap(new_fsl_chan->reg.start,
+			new_fsl_chan->reg.end - new_fsl_chan->reg.start + 1);
+
+	new_fsl_chan->id = ((new_fsl_chan->reg.start - 0x100) & 0xfff) >> 7;
+
+	/* Init the channel */
+	dma_init(new_fsl_chan);
+
+	/* Clear cdar registers */
+	set_cdar(new_fsl_chan, 0);
+
+	spin_lock_init(&new_fsl_chan->desc_lock);
+	INIT_LIST_HEAD(&new_fsl_chan->ld_queue);
+
+	new_fsl_chan->common.device = &fdev->common;
+
+	/* Add the channel to DMA device channel list */
+	list_add_tail(&new_fsl_chan->common.device_node,
+			&fdev->common.channels);
+	fdev->common.chancnt++;
+
+	new_fsl_chan->irq = irq_of_parse_and_map(dev->node, 0);
+	if (new_fsl_chan->irq != NO_IRQ) {
+		err = request_irq(new_fsl_chan->irq,
+					&fsl_dma_chan_do_interrupt, IRQF_SHARED,
+					"fsldma-channel", new_fsl_chan);
+		if (err) {
+			dev_err(&dev->dev, "DMA channel %s request_irq error "
+				"with return %d\n", dev->node->full_name, err);
+			goto err;
+		}
+	}
+
+	err = fsl_dma_self_test(new_fsl_chan);
+	if (err)
+		goto err;
+
+	dev_info(&dev->dev, "#%d (%s), irq %d\n", new_fsl_chan->id,
+				match->compatible, new_fsl_chan->irq);
+
+	return 0;
+err:
+	dma_halt(new_fsl_chan);
+	iounmap(new_fsl_chan->reg_base);
+	free_irq(new_fsl_chan->irq, new_fsl_chan);
+	list_del(&new_fsl_chan->common.device_node);
+	kfree(new_fsl_chan);
+	return err;
+}
+
+static struct of_device_id of_fsl_dma_ids[] = {
+	{ .compatible = "fsl,dma", },
+};
+
+static struct of_platform_driver of_fsl_dma_driver = {
+	.name = "of-fsl-dma",
+	.match_table = of_fsl_dma_ids,
+	.probe = of_fsl_dma_probe,
+};
+
+static __init int of_fsl_dma_init(void)
+{
+	return of_register_platform_driver(&of_fsl_dma_driver);
+}
+
+static struct of_device_id of_fsl_dma_chan_ids[] = {
+	{ .compatible = "fsl,mpc8540-dma-channel", },
+	{ .compatible = "fsl,mpc8349-dma-channel", },
+};
+
+static struct of_platform_driver of_fsl_dma_chan_driver = {
+	.name = "of-fsl-dma-channel",
+	.match_table = of_fsl_dma_chan_ids,
+	.probe = of_fsl_dma_chan_probe,
+};
+
+static __init int of_fsl_dma_chan_init(void)
+{
+	return of_register_platform_driver(&of_fsl_dma_chan_driver);
+}
+
+subsys_initcall(of_fsl_dma_init);
+device_initcall(of_fsl_dma_chan_init);
diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
new file mode 100644
index 0000000..05be9ed
--- /dev/null
+++ b/drivers/dma/fsldma.h
@@ -0,0 +1,188 @@
+/*
+ * Copyright (C) 2007 Freescale Semiconductor, Inc. All rights reserved.
+ *
+ * Author:
+ *   Zhang Wei <wei.zhang@freescale.com>, Jul 2007
+ *   Ebony Zhu <ebony.zhu@freescale.com>, May 2007
+ *
+ * Description:
+ *   This file defines data structures needed by Freescale
+ *   MPC8540 and MPC8349 DMA controller.
+ *
+ * This is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+#ifndef __FSLDMA_H
+#define __FSLDMA_H
+
+#include <linux/device.h>
+#include <linux/dmapool.h>
+#include <linux/dmaengine.h>
+
+#define FSL_DMA_MR_CS		0x00000001
+#define FSL_DMA_MR_CC		0x00000002
+#define FSL_DMA_MR_EIE		0x00000040
+#define FSL_DMA_MR_XFE		0x00000020
+#define FSL_DMA_MR_EOLNIE	0x00000100
+#define FSL_DMA_MR_EOLSIE	0x00000080
+#define FSL_DMA_MR_EOSIE	0x00000200
+#define FSL_DMA_MR_CDSM		0x00000010
+#define FSL_DMA_MR_CTM		0x00000004
+
+/* Special MR definition for MPC8349 */
+#define FSL_DMA_MR_EOTIE	0x00000080
+
+#define FSL_DMA_SR_CH		0x00000020
+#define FSL_DMA_SR_CB		0x00000004
+#define FSL_DMA_SR_TE		0x00000080
+#define FSL_DMA_SR_EOSI		0x00000002
+#define FSL_DMA_SR_EOLSI	0x00000001
+#define FSL_DMA_SR_EOCDI	0x00000001
+#define FSL_DMA_SR_EOLNI	0x00000008
+
+#define FSL_DMA_SATR_SBPATMU			0x20000000
+#define FSL_DMA_SATR_STRANSINT_RIO		0x00c00000
+#define FSL_DMA_SATR_SREADTYPE_SNOOP_READ	0x00050000
+#define FSL_DMA_SATR_SREADTYPE_BP_IORH		0x00020000
+#define FSL_DMA_SATR_SREADTYPE_BP_NREAD		0x00040000
+#define FSL_DMA_SATR_SREADTYPE_BP_MREAD		0x00070000
+
+#define FSL_DMA_DATR_DBPATMU			0x20000000
+#define FSL_DMA_DATR_DTRANSINT_RIO		0x00c00000
+#define FSL_DMA_DATR_DWRITETYPE_SNOOP_WRITE	0x00050000
+#define FSL_DMA_DATR_DWRITETYPE_BP_FLUSH	0x00010000
+
+#define FSL_DMA_EOL		((u64)0x1)
+#define FSL_DMA_SNEN		((u64)0x10)
+#define FSL_DMA_EOSIE		0x8
+#define FSL_DMA_NLDA_MASK	(~(u64)0x1f)
+
+#define FSL_DMA_BCR_MAX_CNT	0x03ffffffu
+
+#define FSL_DMA_DGSR_TE		0x80
+#define FSL_DMA_DGSR_CH		0x20
+#define FSL_DMA_DGSR_PE		0x10
+#define FSL_DMA_DGSR_EOLNI	0x08
+#define FSL_DMA_DGSR_CB		0x04
+#define FSL_DMA_DGSR_EOSI	0x02
+#define FSL_DMA_DGSR_EOLSI	0x01
+
+
+typedef union mix32 {
+	__le32	le;
+	__be32	be;
+} __mix32;
+
+typedef union mix64 {
+	__le64	le;
+	__be64	be;
+} __mix64;
+
+struct fsl_dma_ld_hw {
+	__mix64	src_addr;
+	__mix64	dst_addr;
+	__mix64	next_ln_addr;
+	__mix32	count;
+	__mix32	reserve;
+} __attribute__((aligned(32)));
+
+struct fsl_ld_desc {
+	dma_addr_t dest;
+	dma_addr_t src;
+	u32 count;
+	dma_addr_t next_ld_desc;
+};
+
+struct fsl_desc_sw {
+	struct fsl_dma_ld_hw hw;
+	struct list_head node;
+	struct dma_async_tx_descriptor async_tx;
+	struct list_head *ld;
+	void *priv;
+} __attribute__((aligned(32)));
+
+struct fsl_dma_chan_regs {
+	__mix32	mr;		/* 0x00 - Mode Register */
+	__mix32	sr;		/* 0x04 - Status Register */
+	__mix64	cdar;		/* 0x08 - Cureent descriptor address register */
+	__mix64	sar;		/* 0x10 - Source Address Register */
+	__mix64	dar;		/* 0x18 - Destination Address Register */
+	__mix32	bcr;		/* 0x20 - Byte Count Register */
+	__mix64	ndar;		/* 0x24 - Next Descriptor Address Register */
+};
+
+struct fsl_dma_device {
+	void __iomem *reg_base;		/* DGSR register base */
+	struct resource reg;		/* Resource for register */
+	struct device *dev;
+	struct dma_device common;
+	u32 feature;			/* The same as DMA channels */
+};
+
+/* Define macros for fsl_dma_chan->feature property */
+#define FSL_DMA_LITTLE_ENDIAN	0x00000000
+#define FSL_DMA_BIG_ENDIAN	0x00000001
+
+#define FSL_DMA_IP_MASK		0x00000ff0
+#define FSL_DMA_IP_86XX		0x00000010
+#define FSL_DMA_IP_83XX		0x00000020
+
+struct fsl_dma_chan {
+	struct fsl_dma_chan_regs __iomem *reg_base;
+	dma_cookie_t completed_cookie;	/* The maximum cookie completed */
+	spinlock_t desc_lock;
+	struct list_head ld_queue;	/* Link descriptors queue */
+	struct fsl_dma_device *device;
+	struct dma_chan common;
+	struct dma_pool *desc_pool;
+	struct device *chan_dev;
+	struct resource reg;		/* Resource for register */
+	int irq;
+	int id;				/* Raw id of this channel */
+	u32 feature;
+};
+
+#ifndef __powerpc64
+static u64 in_be64(const u64 __iomem *addr)
+{
+	return ((u64)in_be32((u32 *)addr) << 32) | (in_be32((u32 *)addr + 1));
+}
+
+static void out_be64(u64 __iomem *addr, u64 val)
+{
+	out_be32((u32 *)addr, val >> 32);
+	out_be32((u32 *)addr + 1, (u32)val);
+}
+
+/* There is no asm instructions for 64 bits reverse loads and stores */
+static u64 in_le64(const u64 __iomem *addr)
+{
+	return le64_to_cpu(in_be64(addr));
+}
+
+static void out_le64(u64 __iomem *addr, u64 val)
+{
+	out_be64(addr, cpu_to_le64(val));
+}
+#endif
+
+#define MIX_IN(fsl_chan, addr, width)					\
+		(((fsl_chan)->feature & FSL_DMA_BIG_ENDIAN) ?		\
+			in_be##width(&(addr)->be) : in_le##width(&(addr)->le))
+#define MIX_OUT(fsl_chan, addr, val, width)				\
+		(((fsl_chan)->feature & FSL_DMA_BIG_ENDIAN) ?		\
+			out_be##width(&(addr)->be, val) :		\
+			out_le##width(&(addr)->le, val))
+
+#define MIX_TO_CPU(fsl_chan, mix, width)				\
+		(((fsl_chan)->feature & FSL_DMA_BIG_ENDIAN) ?		\
+			be##width##_to_cpu((mix).be) :			\
+			le##width##_to_cpu((mix).le))
+#define CPU_TO_MIX(fsl_chan, mix, width)				\
+		(((fsl_chan)->feature & FSL_DMA_BIG_ENDIAN) ?		\
+			cpu_to_be##width(mix) : cpu_to_le##width(mix))
+
+#endif	/* __FSLDMA_H */
-- 
1.5.2

