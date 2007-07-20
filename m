Return-Path: <linux-kernel-owner+w=401wt.eu-S937306AbXGTAqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937306AbXGTAqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 20:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932088AbXGTAp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 20:45:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:23318 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761656AbXGTAp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 20:45:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,559,1175497200"; 
   d="scan'208";a="270540401"
From: Shannon Nelson <shannon.nelson@intel.com>
Subject: [PATCH 3/7] I/OAT: code cleanup from checkpatch output
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, jeff@garzik.org, dan.j.williams@intel.com,
       christopher.leech@intel.com, peter.p.waskiewicz.jr@intel.com
Date: Thu, 19 Jul 2007 17:45:02 -0700
Message-ID: <20070720004502.13564.1245.stgit@localhost.localdomain>
In-Reply-To: <20070720004403.13564.14294.stgit@localhost.localdomain>
References: <20070720004403.13564.14294.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Take care of a bunch of little code nits in ioatdma files

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
---

 drivers/dma/ioat_dma.c |  200 +++++++++++++++++++++++++++---------------------
 1 files changed, 111 insertions(+), 89 deletions(-)

diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index 52e2ac2..0a56361 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -1,10 +1,10 @@
 /*
- * Copyright(c) 2004 - 2006 Intel Corporation. All rights reserved.
+ * Intel I/OAT DMA Linux driver
+ * Copyright(c) 2004 - 2007 Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
  *
  * This program is distributed in the hope that it will be useful, but WITHOUT
  * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
@@ -12,11 +12,12 @@
  * more details.
  *
  * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc., 59
- * Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
  *
- * The full GNU General Public License is included in this distribution in the
- * file called COPYING.
  */
 
 /*
@@ -35,17 +36,22 @@
 #include "ioatdma_registers.h"
 #include "ioatdma_hw.h"
 
+#define INITIAL_IOAT_DESC_COUNT 128
+
 #define to_ioat_chan(chan) container_of(chan, struct ioat_dma_chan, common)
 #define to_ioat_device(dev) container_of(dev, struct ioat_device, common)
 #define to_ioat_desc(lh) container_of(lh, struct ioat_desc_sw, node)
 #define tx_to_ioat_desc(tx) container_of(tx, struct ioat_desc_sw, async_tx)
 
 /* internal functions */
-static int __devinit ioat_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
+static void ioat_dma_start_null_desc(struct ioat_dma_chan *ioat_chan);
+static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan);
+static int __devinit ioat_probe(struct pci_dev *pdev,
+				const struct pci_device_id *ent);
 static void ioat_shutdown(struct pci_dev *pdev);
 static void __devexit ioat_remove(struct pci_dev *pdev);
 
-static int enumerate_dma_channels(struct ioat_device *device)
+static int ioat_dma_enumerate_channels(struct ioat_device *device)
 {
 	u8 xfercap_scale;
 	u32 xfercap;
@@ -73,13 +79,14 @@ static int enumerate_dma_channels(struct ioat_device *device)
 		/* This should be made common somewhere in dmaengine.c */
 		ioat_chan->common.device = &device->common;
 		list_add_tail(&ioat_chan->common.device_node,
-		              &device->common.channels);
+			      &device->common.channels);
 	}
 	return device->common.chancnt;
 }
 
-static void
-ioat_set_src(dma_addr_t addr, struct dma_async_tx_descriptor *tx, int index)
+static void ioat_set_src(dma_addr_t addr,
+			 struct dma_async_tx_descriptor *tx,
+			 int index)
 {
 	struct ioat_desc_sw *iter, *desc = tx_to_ioat_desc(tx);
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(tx->chan);
@@ -93,8 +100,9 @@ ioat_set_src(dma_addr_t addr, struct dma_async_tx_descriptor *tx, int index)
 
 }
 
-static void
-ioat_set_dest(dma_addr_t addr, struct dma_async_tx_descriptor *tx, int index)
+static void ioat_set_dest(dma_addr_t addr,
+			  struct dma_async_tx_descriptor *tx,
+			  int index)
 {
 	struct ioat_desc_sw *iter, *desc = tx_to_ioat_desc(tx);
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(tx->chan);
@@ -107,8 +115,7 @@ ioat_set_dest(dma_addr_t addr, struct dma_async_tx_descriptor *tx, int index)
 	}
 }
 
-static dma_cookie_t
-ioat_tx_submit(struct dma_async_tx_descriptor *tx)
+static dma_cookie_t ioat_tx_submit(struct dma_async_tx_descriptor *tx)
 {
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(tx->chan);
 	struct ioat_desc_sw *desc = tx_to_ioat_desc(tx);
@@ -141,13 +148,13 @@ ioat_tx_submit(struct dma_async_tx_descriptor *tx)
 	if (append)
 		writeb(IOAT_CHANCMD_APPEND,
 			ioat_chan->reg_base + IOAT_CHANCMD_OFFSET);
-	
+
 	return cookie;
 }
 
 static struct ioat_desc_sw *ioat_dma_alloc_descriptor(
-	struct ioat_dma_chan *ioat_chan,
-	gfp_t flags)
+					struct ioat_dma_chan *ioat_chan,
+					gfp_t flags)
 {
 	struct ioat_dma_descriptor *desc;
 	struct ioat_desc_sw *desc_sw;
@@ -177,10 +184,6 @@ static struct ioat_desc_sw *ioat_dma_alloc_descriptor(
 	return desc_sw;
 }
 
-#define INITIAL_IOAT_DESC_COUNT 128
-
-static void ioat_start_null_desc(struct ioat_dma_chan *ioat_chan);
-
 /* returns the actual number of allocated descriptors */
 static int ioat_dma_alloc_chan_resources(struct dma_chan *chan)
 {
@@ -199,16 +202,17 @@ static int ioat_dma_alloc_chan_resources(struct dma_chan *chan)
 	if (chanctrl & IOAT_CHANCTRL_CHANNEL_IN_USE)
 		return -EBUSY;
 
-        /* Setup register to interrupt and write completion status on error */
+	/* Setup register to interrupt and write completion status on error */
 	chanctrl = IOAT_CHANCTRL_CHANNEL_IN_USE |
 		IOAT_CHANCTRL_ERR_INT_EN |
 		IOAT_CHANCTRL_ANY_ERR_ABORT_EN |
 		IOAT_CHANCTRL_ERR_COMPLETION_EN;
-        writew(chanctrl, ioat_chan->reg_base + IOAT_CHANCTRL_OFFSET);
+	writew(chanctrl, ioat_chan->reg_base + IOAT_CHANCTRL_OFFSET);
 
 	chanerr = readl(ioat_chan->reg_base + IOAT_CHANERR_OFFSET);
 	if (chanerr) {
-		printk("IOAT: CHANERR = %x, clearing\n", chanerr);
+		dev_err(&ioat_chan->device->pdev->dev,
+			"ioatdma: CHANERR = %x, clearing\n", chanerr);
 		writel(chanerr, ioat_chan->reg_base + IOAT_CHANERR_OFFSET);
 	}
 
@@ -216,7 +220,8 @@ static int ioat_dma_alloc_chan_resources(struct dma_chan *chan)
 	for (i = 0; i < INITIAL_IOAT_DESC_COUNT; i++) {
 		desc = ioat_dma_alloc_descriptor(ioat_chan, GFP_KERNEL);
 		if (!desc) {
-			printk(KERN_ERR "IOAT: Only %d initial descriptors\n", i);
+			dev_err(&ioat_chan->device->pdev->dev,
+				"ioatdma: Only %d initial descriptors\n", i);
 			break;
 		}
 		list_add_tail(&desc->node, &tmp_list);
@@ -229,8 +234,8 @@ static int ioat_dma_alloc_chan_resources(struct dma_chan *chan)
 	/* doing 2 32bit writes to mmio since 1 64b write doesn't work */
 	ioat_chan->completion_virt =
 		pci_pool_alloc(ioat_chan->device->completion_pool,
-		               GFP_KERNEL,
-		               &ioat_chan->completion_addr);
+			       GFP_KERNEL,
+			       &ioat_chan->completion_addr);
 	memset(ioat_chan->completion_virt, 0,
 	       sizeof(*ioat_chan->completion_virt));
 	writel(((u64) ioat_chan->completion_addr) & 0x00000000FFFFFFFF,
@@ -238,12 +243,10 @@ static int ioat_dma_alloc_chan_resources(struct dma_chan *chan)
 	writel(((u64) ioat_chan->completion_addr) >> 32,
 	       ioat_chan->reg_base + IOAT_CHANCMP_OFFSET_HIGH);
 
-	ioat_start_null_desc(ioat_chan);
+	ioat_dma_start_null_desc(ioat_chan);
 	return i;
 }
 
-static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan);
-
 static void ioat_dma_free_chan_resources(struct dma_chan *chan)
 {
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
@@ -273,12 +276,13 @@ static void ioat_dma_free_chan_resources(struct dma_chan *chan)
 	spin_unlock_bh(&ioat_chan->desc_lock);
 
 	pci_pool_free(ioat_device->completion_pool,
-	              ioat_chan->completion_virt,
-	              ioat_chan->completion_addr);
+		      ioat_chan->completion_virt,
+		      ioat_chan->completion_addr);
 
 	/* one is ok since we left it on there on purpose */
 	if (in_use_descs > 1)
-		printk(KERN_ERR "IOAT: Freeing %d in use descriptors!\n",
+		dev_err(&ioat_chan->device->pdev->dev,
+			"ioatdma: Freeing %d in use descriptors!\n",
 			in_use_descs - 1);
 
 	ioat_chan->last_completion = ioat_chan->completion_addr = 0;
@@ -289,8 +293,10 @@ static void ioat_dma_free_chan_resources(struct dma_chan *chan)
 	writew(chanctrl, ioat_chan->reg_base + IOAT_CHANCTRL_OFFSET);
 }
 
-static struct dma_async_tx_descriptor *
-ioat_dma_prep_memcpy(struct dma_chan *chan, size_t len, int int_en)
+static struct dma_async_tx_descriptor *ioat_dma_prep_memcpy(
+						struct dma_chan *chan,
+						size_t len,
+						int int_en)
 {
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
 	struct ioat_desc_sw *first, *prev, *new;
@@ -354,12 +360,11 @@ ioat_dma_prep_memcpy(struct dma_chan *chan, size_t len, int int_en)
 	return new ? &new->async_tx : NULL;
 }
 
-
 /**
- * ioat_dma_memcpy_issue_pending - push potentially unrecognized appended descriptors to hw
+ * ioat_dma_memcpy_issue_pending - push potentially unrecognized appended
+ *                                 descriptors to hw
  * @chan: DMA channel handle
  */
-
 static void ioat_dma_memcpy_issue_pending(struct dma_chan *chan)
 {
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
@@ -371,15 +376,15 @@ static void ioat_dma_memcpy_issue_pending(struct dma_chan *chan)
 	}
 }
 
-static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *chan)
+static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan)
 {
 	unsigned long phys_complete;
 	struct ioat_desc_sw *desc, *_desc;
 	dma_cookie_t cookie = 0;
 
-	prefetch(chan->completion_virt);
+	prefetch(ioat_chan->completion_virt);
 
-	if (!spin_trylock(&chan->cleanup_lock))
+	if (!spin_trylock(&ioat_chan->cleanup_lock))
 		return;
 
 	/* The completion writeback can happen at any time,
@@ -389,26 +394,27 @@ static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *chan)
 
 #if (BITS_PER_LONG == 64)
 	phys_complete =
-	chan->completion_virt->full & IOAT_CHANSTS_COMPLETED_DESCRIPTOR_ADDR;
+	ioat_chan->completion_virt->full & IOAT_CHANSTS_COMPLETED_DESCRIPTOR_ADDR;
 #else
-	phys_complete = chan->completion_virt->low & IOAT_LOW_COMPLETION_MASK;
+	phys_complete = ioat_chan->completion_virt->low & IOAT_LOW_COMPLETION_MASK;
 #endif
 
-	if ((chan->completion_virt->full & IOAT_CHANSTS_DMA_TRANSFER_STATUS) ==
-		IOAT_CHANSTS_DMA_TRANSFER_STATUS_HALTED) {
-		printk("IOAT: Channel halted, chanerr = %x\n",
-			readl(chan->reg_base + IOAT_CHANERR_OFFSET));
+	if ((ioat_chan->completion_virt->full & IOAT_CHANSTS_DMA_TRANSFER_STATUS) ==
+				IOAT_CHANSTS_DMA_TRANSFER_STATUS_HALTED) {
+		dev_err(&ioat_chan->device->pdev->dev,
+			"ioatdma: Channel halted, chanerr = %x\n",
+			readl(ioat_chan->reg_base + IOAT_CHANERR_OFFSET));
 
 		/* TODO do something to salvage the situation */
 	}
 
-	if (phys_complete == chan->last_completion) {
-		spin_unlock(&chan->cleanup_lock);
+	if (phys_complete == ioat_chan->last_completion) {
+		spin_unlock(&ioat_chan->cleanup_lock);
 		return;
 	}
 
-	spin_lock_bh(&chan->desc_lock);
-	list_for_each_entry_safe(desc, _desc, &chan->used_desc, node) {
+	spin_lock_bh(&ioat_chan->desc_lock);
+	list_for_each_entry_safe(desc, _desc, &ioat_chan->used_desc, node) {
 
 		/*
 		 * Incoming DMA requests may use multiple descriptors, due to
@@ -418,31 +424,36 @@ static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *chan)
 		if (desc->async_tx.cookie) {
 			cookie = desc->async_tx.cookie;
 
-			/* yes we are unmapping both _page and _single alloc'd
-			   regions with unmap_page. Is this *really* that bad?
-			*/
-			pci_unmap_page(chan->device->pdev,
+			/*
+			 * yes we are unmapping both _page and _single alloc'd
+			 * regions with unmap_page. Is this *really* that bad?
+			 */
+			pci_unmap_page(ioat_chan->device->pdev,
 					pci_unmap_addr(desc, dst),
 					pci_unmap_len(desc, dst_len),
 					PCI_DMA_FROMDEVICE);
-			pci_unmap_page(chan->device->pdev,
+			pci_unmap_page(ioat_chan->device->pdev,
 					pci_unmap_addr(desc, src),
 					pci_unmap_len(desc, src_len),
 					PCI_DMA_TODEVICE);
 		}
 
 		if (desc->async_tx.phys != phys_complete) {
-			/* a completed entry, but not the last, so cleanup
+			/*
+			 * a completed entry, but not the last, so cleanup
 			 * if the client is done with the descriptor
 			 */
 			if (desc->async_tx.ack) {
 				list_del(&desc->node);
-				list_add_tail(&desc->node, &chan->free_desc);
+				list_add_tail(&desc->node,
+					      &ioat_chan->free_desc);
 			} else
 				desc->async_tx.cookie = 0;
 		} else {
-			/* last used desc. Do not remove, so we can append from
-			   it, but don't look at it next time, either */
+			/*
+			 * last used desc. Do not remove, so we can append from
+			 * it, but don't look at it next time, either
+			 */
 			desc->async_tx.cookie = 0;
 
 			/* TODO check status bits? */
@@ -450,13 +461,13 @@ static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *chan)
 		}
 	}
 
-	spin_unlock_bh(&chan->desc_lock);
+	spin_unlock_bh(&ioat_chan->desc_lock);
 
-	chan->last_completion = phys_complete;
+	ioat_chan->last_completion = phys_complete;
 	if (cookie != 0)
-		chan->completed_cookie = cookie;
+		ioat_chan->completed_cookie = cookie;
 
-	spin_unlock(&chan->cleanup_lock);
+	spin_unlock(&ioat_chan->cleanup_lock);
 }
 
 static void ioat_dma_dependency_added(struct dma_chan *chan)
@@ -477,11 +488,10 @@ static void ioat_dma_dependency_added(struct dma_chan *chan)
  * @done: if not %NULL, updated with last completed transaction
  * @used: if not %NULL, updated with last used transaction
  */
-
 static enum dma_status ioat_dma_is_complete(struct dma_chan *chan,
-                                            dma_cookie_t cookie,
-                                            dma_cookie_t *done,
-                                            dma_cookie_t *used)
+					    dma_cookie_t cookie,
+					    dma_cookie_t *done,
+					    dma_cookie_t *used)
 {
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
 	dma_cookie_t last_used;
@@ -492,7 +502,7 @@ static enum dma_status ioat_dma_is_complete(struct dma_chan *chan,
 	last_complete = ioat_chan->completed_cookie;
 
 	if (done)
-		*done= last_complete;
+		*done = last_complete;
 	if (used)
 		*used = last_used;
 
@@ -506,7 +516,7 @@ static enum dma_status ioat_dma_is_complete(struct dma_chan *chan,
 	last_complete = ioat_chan->completed_cookie;
 
 	if (done)
-		*done= last_complete;
+		*done = last_complete;
 	if (used)
 		*used = last_used;
 
@@ -549,13 +559,13 @@ static irqreturn_t ioat_do_interrupt(int irq, void *data)
 
 	attnstatus = readl(instance->reg_base + IOAT_ATTNSTATUS_OFFSET);
 
-	printk(KERN_ERR "ioatdma error: interrupt! status %lx\n", attnstatus);
+	printk(KERN_ERR "ioatdma: interrupt! status %lx\n", attnstatus);
 
 	writeb(intrctrl, instance->reg_base + IOAT_INTRCTRL_OFFSET);
 	return IRQ_HANDLED;
 }
 
-static void ioat_start_null_desc(struct ioat_dma_chan *ioat_chan)
+static void ioat_dma_start_null_desc(struct ioat_dma_chan *ioat_chan)
 {
 	struct ioat_desc_sw *desc;
 
@@ -619,9 +629,11 @@ static int ioat_self_test(struct ioat_device *device)
 
 	/* Start copy, using first DMA channel */
 	dma_chan = container_of(device->common.channels.next,
-	                        struct dma_chan,
-	                        device_node);
+				struct dma_chan,
+				device_node);
 	if (ioat_dma_alloc_chan_resources(dma_chan) < 1) {
+		dev_err(&device->pdev->dev,
+			"selftest cannot allocate chan resource\n");
 		err = -ENODEV;
 		goto out;
 	}
@@ -639,12 +651,14 @@ static int ioat_self_test(struct ioat_device *device)
 	msleep(1);
 
 	if (ioat_dma_is_complete(dma_chan, cookie, NULL, NULL) != DMA_SUCCESS) {
-		printk(KERN_ERR "ioatdma: Self-test copy timed out, disabling\n");
+		dev_err(&device->pdev->dev,
+			"ioatdma: Self-test copy timed out, disabling\n");
 		err = -ENODEV;
 		goto free_resources;
 	}
 	if (memcmp(src, dest, IOAT_TEST_SIZE)) {
-		printk(KERN_ERR "ioatdma: Self-test copy failed compare, disabling\n");
+		dev_err(&device->pdev->dev,
+			"ioatdma: Self-test copy failed compare, disabling\n");
 		err = -ENODEV;
 		goto free_resources;
 	}
@@ -658,7 +672,7 @@ out:
 }
 
 static int __devinit ioat_probe(struct pci_dev *pdev,
-                                const struct pci_device_id *ent)
+				const struct pci_device_id *ent)
 {
 	int err;
 	unsigned long mmio_start, mmio_len;
@@ -702,7 +716,9 @@ static int __devinit ioat_probe(struct pci_dev *pdev,
 		goto err_dma_pool;
 	}
 
-	device->completion_pool = pci_pool_create("completion_pool", pdev, sizeof(u64), SMP_CACHE_BYTES, SMP_CACHE_BYTES);
+	device->completion_pool = pci_pool_create("completion_pool", pdev,
+						  sizeof(u64), SMP_CACHE_BYTES,
+						  SMP_CACHE_BYTES);
 	if (!device->completion_pool) {
 		err = -ENOMEM;
 		goto err_completion_pool;
@@ -724,22 +740,26 @@ static int __devinit ioat_probe(struct pci_dev *pdev,
 
 	device->reg_base = reg_base;
 
-	writeb(IOAT_INTRCTRL_MASTER_INT_EN, device->reg_base + IOAT_INTRCTRL_OFFSET);
+	writeb(IOAT_INTRCTRL_MASTER_INT_EN,
+	       device->reg_base + IOAT_INTRCTRL_OFFSET);
 	pci_set_master(pdev);
 
 	INIT_LIST_HEAD(&device->common.channels);
-	enumerate_dma_channels(device);
+	ioat_dma_enumerate_channels(device);
 
 	dma_cap_set(DMA_MEMCPY, device->common.cap_mask);
-	device->common.device_alloc_chan_resources = ioat_dma_alloc_chan_resources;
-	device->common.device_free_chan_resources = ioat_dma_free_chan_resources;
+	device->common.device_alloc_chan_resources =
+						ioat_dma_alloc_chan_resources;
+	device->common.device_free_chan_resources =
+						ioat_dma_free_chan_resources;
 	device->common.device_prep_dma_memcpy = ioat_dma_prep_memcpy;
 	device->common.device_is_tx_complete = ioat_dma_is_complete;
 	device->common.device_issue_pending = ioat_dma_memcpy_issue_pending;
 	device->common.device_dependency_added = ioat_dma_dependency_added;
 	device->common.dev = &pdev->dev;
-	printk(KERN_INFO "Intel(R) I/OAT DMA Engine found, %d channels\n",
-		device->common.chancnt);
+	printk(KERN_INFO " "
+		 "ioatdma: Intel(R) I/OAT DMA Engine found, %d channels\n",
+		 device->common.chancnt);
 
 	err = ioat_self_test(device);
 	if (err)
@@ -765,7 +785,8 @@ err_set_dma_mask:
 	pci_disable_device(pdev);
 err_enable_device:
 
-	printk(KERN_ERR "Intel(R) I/OAT DMA Engine initialization failed\n");
+	printk(KERN_INFO " "
+		"ioatdma: Intel(R) I/OAT DMA Engine initialization failed\n");
 
 	return err;
 }
@@ -797,7 +818,8 @@ static void __devexit ioat_remove(struct pci_dev *pdev)
 	iounmap(device->reg_base);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-	list_for_each_entry_safe(chan, _chan, &device->common.channels, device_node) {
+	list_for_each_entry_safe(chan, _chan,
+				 &device->common.channels, device_node) {
 		ioat_chan = to_ioat_chan(chan);
 		list_del(&chan->device_node);
 		kfree(ioat_chan);
