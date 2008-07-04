Return-Path: <linux-kernel-owner+w=401wt.eu-S1757635AbYGDAkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbYGDAkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 20:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbYGDAk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 20:40:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:37017 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbYGDAkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 20:40:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,299,1212390000"; 
   d="scan'208";a="348640257"
Subject: dmaengine skip unmap (was: Re: [PATCH v4 5/6] dmaengine: Driver
	for the Synopsys DesignWare DMA controller)
From: Dan Williams <dan.j.williams@intel.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, kernel@avr32linux.org,
       "Nelson, Shannon" <shannon.nelson@intel.com>,
       David Brownell <david-b@pacbell.net>
In-Reply-To: <1214486603-23655-6-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com>
	 <1214486603-23655-2-git-send-email-haavard.skinnemoen@atmel.com>
	 <1214486603-23655-3-git-send-email-haavard.skinnemoen@atmel.com>
	 <1214486603-23655-4-git-send-email-haavard.skinnemoen@atmel.com>
	 <1214486603-23655-5-git-send-email-haavard.skinnemoen@atmel.com>
	 <1214486603-23655-6-git-send-email-haavard.skinnemoen@atmel.com>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 17:40:23 -0700
Message-Id: <1215132023.23470.15.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-26 at 06:23 -0700, Haavard Skinnemoen wrote:
> This adds a driver for the Synopsys DesignWare DMA controller (aka
> DMACA on AVR32 systems.) This DMA controller can be found integrated
> on the AT32AP7000 chip and is primarily meant for peripheral DMA
> transfer, but can also be used for memory-to-memory transfers.
> 
> This patch is based on a driver from David Brownell which was based on
> an older version of the DMA Engine framework. It also implements the
> proposed extensions to the DMA Engine API for slave DMA operations.
> 
> The dmatest client shows no problems, but there may still be room for
> improvement performance-wise. DMA slave transfer performance is
> definitely "good enough"; reading 100 MiB from an SD card running at ~20
> MHz yields ~7.2 MiB/s average transfer rate.
> 
> Full documentation for this controller can be found in the Synopsys
> DW AHB DMAC Databook:
> 
> http://www.synopsys.com/designware/docs/iip/DW_ahb_dmac/latest/doc/dw_ahb_dmac_db.pdf
> 
> The controller has lots of implementation options, so it's usually a
> good idea to check the data sheet of the chip it's intergrated on as
> well. The AT32AP7000 data sheet can be found here:
> 
> http://www.atmel.com/dyn/products/datasheets.asp?family_id=682
> 
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> 
[..]

> +static void
> +dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
> +{
> +       dma_async_tx_callback           callback;
> +       void                            *param;
> +       struct dma_async_tx_descriptor  *txd = &desc->txd;
> +
> +       dev_vdbg(&dwc->chan.dev, "descriptor %u complete\n", txd->cookie);
> +
> +       dwc->completed = txd->cookie;
> +       callback = txd->callback;
> +       param = txd->callback_param;
> +
> +       dwc_sync_desc_for_cpu(dwc, desc);
> +       list_splice_init(&txd->tx_list, &dwc->free_list);
> +       list_move(&desc->desc_node, &dwc->free_list);
> +
> +       /*
> +        * The API requires that no submissions are done from a
> +        * callback, so we don't need to drop the lock here
> +        */
> +       if (callback)
> +               callback(param);
> +}
> +

The one thing that stands out is that this driver does not unmap the
source or destination buffers (and I now notice that fsldma is not doing
this either, hmm...).  Yes, it is a no-op on avr32, for now, but the
dma-mapping-api assumes that dma_map is always paired with dma_unmap.  I
remember we discussed this earlier and that discussion inspired the
patch below.  The end result is that dw_dmac can try to automatically
dma_unmap the buffers unless an intelligent client, like the mmc driver,
has disabled unmap.

Thoughts?

----snip--->
async_tx: add DMA_COMPL_SKIP_{SRC,DEST}_UNMAP flags to control dma unmap

From: Dan Williams <dan.j.williams@intel.com>

In some cases client code may need the dma-driver to skip the unmap of source
and/or destination buffers.  Setting these flags indicates to the driver to
skip the unmap step.  In this regard async_xor is currently broken in that it
allows the destination buffer to be unmapped while an operation is still in
progress, i.e. when the number of sources exceeds the hardware channel's
maximum (fixed in a subsequent patch).

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/dma/ioat_dma.c    |   48 ++++++++++++++++++++++-----------------------
 drivers/dma/iop-adma.c    |   17 ++++++++++++----
 include/linux/dmaengine.h |    4 ++++
 3 files changed, 40 insertions(+), 29 deletions(-)


diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index 318e8a2..1be33ae 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -756,6 +756,27 @@ static void ioat_dma_cleanup_tasklet(unsigned long data)
 	       chan->reg_base + IOAT_CHANCTRL_OFFSET);
 }
 
+static void
+ioat_dma_unmap(struct ioat_dma_chan *ioat_chan, struct ioat_desc_sw *desc)
+{
+	/*
+	 * yes we are unmapping both _page and _single
+	 * alloc'd regions with unmap_page. Is this
+	 * *really* that bad?
+	 */
+	if (!(desc->async_tx.flags & DMA_COMPL_SKIP_DEST_UNMAP))
+		pci_unmap_page(ioat_chan->device->pdev,
+				pci_unmap_addr(desc, dst),
+				pci_unmap_len(desc, len),
+				PCI_DMA_FROMDEVICE);
+
+	if (!(desc->async_tx.flags & DMA_COMPL_SKIP_SRC_UNMAP))
+		pci_unmap_page(ioat_chan->device->pdev,
+				pci_unmap_addr(desc, src),
+				pci_unmap_len(desc, len),
+				PCI_DMA_TODEVICE);
+}
+
 /**
  * ioat_dma_memcpy_cleanup - cleanup up finished descriptors
  * @chan: ioat channel to be cleaned up
@@ -816,21 +837,7 @@ static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan)
 			 */
 			if (desc->async_tx.cookie) {
 				cookie = desc->async_tx.cookie;
-
-				/*
-				 * yes we are unmapping both _page and _single
-				 * alloc'd regions with unmap_page. Is this
-				 * *really* that bad?
-				 */
-				pci_unmap_page(ioat_chan->device->pdev,
-						pci_unmap_addr(desc, dst),
-						pci_unmap_len(desc, len),
-						PCI_DMA_FROMDEVICE);
-				pci_unmap_page(ioat_chan->device->pdev,
-						pci_unmap_addr(desc, src),
-						pci_unmap_len(desc, len),
-						PCI_DMA_TODEVICE);
-
+				ioat_dma_unmap(ioat_chan, desc);
 				if (desc->async_tx.callback) {
 					desc->async_tx.callback(desc->async_tx.callback_param);
 					desc->async_tx.callback = NULL;
@@ -889,16 +896,7 @@ static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan)
 				if (desc->async_tx.cookie) {
 					cookie = desc->async_tx.cookie;
 					desc->async_tx.cookie = 0;
-
-					pci_unmap_page(ioat_chan->device->pdev,
-						      pci_unmap_addr(desc, dst),
-						      pci_unmap_len(desc, len),
-						      PCI_DMA_FROMDEVICE);
-					pci_unmap_page(ioat_chan->device->pdev,
-						      pci_unmap_addr(desc, src),
-						      pci_unmap_len(desc, len),
-						      PCI_DMA_TODEVICE);
-
+					ioat_dma_unmap(ioat_chan, desc);
 					if (desc->async_tx.callback) {
 						desc->async_tx.callback(desc->async_tx.callback_param);
 						desc->async_tx.callback = NULL;
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 0ec0f43..0b2106e 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -82,11 +82,20 @@ iop_adma_run_tx_complete_actions(struct iop_adma_desc_slot *desc,
 			struct device *dev =
 				&iop_chan->device->pdev->dev;
 			u32 len = unmap->unmap_len;
-			u32 src_cnt = unmap->unmap_src_cnt;
-			dma_addr_t addr = iop_desc_get_dest_addr(unmap,
-				iop_chan);
+			enum dma_ctrl_flags flags = desc->async_tx.flags;
+			u32 src_cnt;
+			dma_addr_t addr;
+
+			if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
+				addr = iop_desc_get_dest_addr(unmap, iop_chan);
+				dma_unmap_page(dev, addr, len, DMA_FROM_DEVICE);
+			}
+
+			if (flags & DMA_COMPL_SKIP_SRC_UNMAP)
+				src_cnt = 0;
+			else
+				src_cnt = unmap->unmap_src_cnt;
 
-			dma_unmap_page(dev, addr, len, DMA_FROM_DEVICE);
 			while (src_cnt--) {
 				addr = iop_desc_get_src_addr(unmap,
 							iop_chan,
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index d08a5c5..78da5c5 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -102,10 +102,14 @@ enum dma_transaction_type {
  * @DMA_CTRL_ACK - the descriptor cannot be reused until the client
  * 	acknowledges receipt, i.e. has has a chance to establish any
  * 	dependency chains
+ * @DMA_COMPL_SKIP_SRC_UNMAP - set to disable dma-unmapping the source buffer(s)
+ * @DMA_COMPL_SKIP_DEST_UNMAP - set to disable dma-unmapping the destination(s)
  */
 enum dma_ctrl_flags {
 	DMA_PREP_INTERRUPT = (1 << 0),
 	DMA_CTRL_ACK = (1 << 1),
+	DMA_COMPL_SKIP_SRC_UNMAP = (1 << 2),
+	DMA_COMPL_SKIP_DEST_UNMAP = (1 << 3),
 };
 
 /**



