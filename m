Return-Path: <linux-kernel-owner+w=401wt.eu-S1759179AbYGDPPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179AbYGDPPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 11:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876AbYGDPPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 11:15:21 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:64493 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745AbYGDPPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 11:15:15 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH v5 2/2] dmaengine: Driver for the Synopsys DesignWare DMA controller
Date: Fri,  4 Jul 2008 17:15:01 +0200
Message-Id: <1215184501-32335-2-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1215184501-32335-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1215184501-32335-1-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 04 Jul 2008 15:15:10.0979 (UTC) FILETIME=[C060F530:01C8DDE8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a driver for the Synopsys DesignWare DMA controller (aka
DMACA on AVR32 systems.) This DMA controller can be found integrated
on the AT32AP7000 chip and is primarily meant for peripheral DMA
transfer, but can also be used for memory-to-memory transfers.

This patch is based on a driver from David Brownell which was based on
an older version of the DMA Engine framework. It also implements the
proposed extensions to the DMA Engine API for slave DMA operations.

The dmatest client shows no problems, but there may still be room for
improvement performance-wise. DMA slave transfer performance is
definitely "good enough"; reading 100 MiB from an SD card running at ~20
MHz yields ~7.2 MiB/s average transfer rate.

Full documentation for this controller can be found in the Synopsys
DW AHB DMAC Databook:

http://www.synopsys.com/designware/docs/iip/DW_ahb_dmac/latest/doc/dw_ahb_dmac_db.pdf

The controller has lots of implementation options, so it's usually a
good idea to check the data sheet of the chip it's intergrated on as
well. The AT32AP7000 data sheet can be found here:

http://www.atmel.com/dyn/products/datasheets.asp?family_id=682

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Changes since v4:
  * Use client_count instead of dma_chan_is_in_use()
  * Add missing include
  * Unmap buffers unless client told us not to

Changes since v3:
  * Update to latest DMA engine and DMA slave APIs
  * Embed the hw descriptor into the sw descriptor
  * Clean up and update MODULE_DESCRIPTION, copyright date, etc.

Changes since v2:
  * Dequeue all pending transfers in terminate_all()
  * Rename dw_dmac.h -> dw_dmac_regs.h
  * Define and use controller-specific dma_slave data
  * Fix up a few outdated comments
  * Define hardware registers as structs (doesn't generate better
    code, unfortunately, but it looks nicer.)
  * Get number of channels from platform_data instead of hardcoding it
    based on CONFIG_WHATEVER_CPU.
  * Give slave clients exclusive access to the channel
---
 arch/avr32/mach-at32ap/at32ap700x.c        |   27 +-
 drivers/dma/Kconfig                        |    9 +
 drivers/dma/Makefile                       |    1 +
 drivers/dma/dw_dmac.c                      | 1122 ++++++++++++++++++++++++++++
 drivers/dma/dw_dmac_regs.h                 |  225 ++++++
 include/asm-avr32/arch-at32ap/at32ap700x.h |   16 +
 include/linux/dw_dmac.h                    |   62 ++
 7 files changed, 1449 insertions(+), 13 deletions(-)
 create mode 100644 drivers/dma/dw_dmac.c
 create mode 100644 drivers/dma/dw_dmac_regs.h
 create mode 100644 include/linux/dw_dmac.h

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 0f24b4f..892e27e 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -7,6 +7,7 @@
  */
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/dw_dmac.h>
 #include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
@@ -599,6 +600,17 @@ static void __init genclk_init_parent(struct clk *clk)
 	clk->parent = parent;
 }
 
+static struct dw_dma_platform_data dw_dmac0_data = {
+	.nr_channels	= 3,
+};
+
+static struct resource dw_dmac0_resource[] = {
+	PBMEM(0xff200000),
+	IRQ(2),
+};
+DEFINE_DEV_DATA(dw_dmac, 0);
+DEV_CLK(hclk, dw_dmac0, hsb, 10);
+
 /* --------------------------------------------------------------------
  *  System peripherals
  * -------------------------------------------------------------------- */
@@ -705,17 +717,6 @@ static struct clk pico_clk = {
 	.users		= 1,
 };
 
-static struct resource dmaca0_resource[] = {
-	{
-		.start	= 0xff200000,
-		.end	= 0xff20ffff,
-		.flags	= IORESOURCE_MEM,
-	},
-	IRQ(2),
-};
-DEFINE_DEV(dmaca, 0);
-DEV_CLK(hclk, dmaca0, hsb, 10);
-
 /* --------------------------------------------------------------------
  * HMATRIX
  * -------------------------------------------------------------------- */
@@ -828,7 +829,7 @@ void __init at32_add_system_devices(void)
 	platform_device_register(&at32_eic0_device);
 	platform_device_register(&smc0_device);
 	platform_device_register(&pdc_device);
-	platform_device_register(&dmaca0_device);
+	platform_device_register(&dw_dmac0_device);
 
 	platform_device_register(&at32_tcb0_device);
 	platform_device_register(&at32_tcb1_device);
@@ -1891,7 +1892,7 @@ struct clk *at32_clock_list[] = {
 	&smc0_mck,
 	&pdc_hclk,
 	&pdc_pclk,
-	&dmaca0_hclk,
+	&dw_dmac0_hclk,
 	&pico_clk,
 	&pio0_mck,
 	&pio1_mck,
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index eab3691..e0f0e87 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -38,6 +38,15 @@ config INTEL_IOP_ADMA
 	help
 	  Enable support for the Intel(R) IOP Series RAID engines.
 
+config DW_DMAC
+	tristate "Synopsys DesignWare AHB DMA support"
+	depends on AVR32
+	select DMA_ENGINE
+	default y if CPU_AT32AP7000
+	help
+	  Support the Synopsys DesignWare AHB DMA controller.  This
+	  can be integrated in chips such as the Atmel AT32ap7000.
+
 config FSL_DMA
 	bool "Freescale MPC85xx/MPC83xx DMA support"
 	depends on PPC
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 2ff6d7f..beebae4 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_DMA_ENGINE) += dmaengine.o
 obj-$(CONFIG_NET_DMA) += iovlock.o
 obj-$(CONFIG_INTEL_IOATDMA) += ioatdma.o
+obj-$(CONFIG_DW_DMAC) += dw_dmac.o
 ioatdma-objs := ioat.o ioat_dma.o ioat_dca.o
 obj-$(CONFIG_INTEL_IOP_ADMA) += iop-adma.o
 obj-$(CONFIG_FSL_DMA) += fsldma.o
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
new file mode 100644
index 0000000..94df917
--- /dev/null
+++ b/drivers/dma/dw_dmac.c
@@ -0,0 +1,1122 @@
+/*
+ * Driver for the Synopsys DesignWare DMA Controller (aka DMACA on
+ * AVR32 systems.)
+ *
+ * Copyright (C) 2007-2008 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#include "dw_dmac_regs.h"
+
+/*
+ * This supports the Synopsys "DesignWare AHB Central DMA Controller",
+ * (DW_ahb_dmac) which is used with various AMBA 2.0 systems (not all
+ * of which use ARM any more).  See the "Databook" from Synopsys for
+ * information beyond what licensees probably provide.
+ *
+ * The driver has currently been tested only with the Atmel AT32AP7000,
+ * which does not support descriptor writeback.
+ */
+
+/* NOTE:  DMS+SMS is system-specific. We should get this information
+ * from the platform code somehow.
+ */
+#define DWC_DEFAULT_CTLLO	(DWC_CTLL_DST_MSIZE(0)		\
+				| DWC_CTLL_SRC_MSIZE(0)		\
+				| DWC_CTLL_DMS(0)		\
+				| DWC_CTLL_SMS(1)		\
+				| DWC_CTLL_LLP_D_EN		\
+				| DWC_CTLL_LLP_S_EN)
+
+/*
+ * This is configuration-dependent and usually a funny size like 4095.
+ * Let's round it down to the nearest power of two.
+ *
+ * Note that this is a transfer count, i.e. if we transfer 32-bit
+ * words, we can do 8192 bytes per descriptor.
+ *
+ * This parameter is also system-specific.
+ */
+#define DWC_MAX_COUNT	2048U
+
+/*
+ * Number of descriptors to allocate for each channel. This should be
+ * made configurable somehow; preferably, the clients (at least the
+ * ones using slave transfers) should be able to give us a hint.
+ */
+#define NR_DESCS_PER_CHANNEL	64
+
+/*----------------------------------------------------------------------*/
+
+/*
+ * Because we're not relying on writeback from the controller (it may not
+ * even be configured into the core!) we don't need to use dma_pool.  These
+ * descriptors -- and associated data -- are cacheable.  We do need to make
+ * sure their dcache entries are written back before handing them off to
+ * the controller, though.
+ */
+
+static struct dw_desc *dwc_first_active(struct dw_dma_chan *dwc)
+{
+	return list_entry(dwc->active_list.next, struct dw_desc, desc_node);
+}
+
+static struct dw_desc *dwc_first_queued(struct dw_dma_chan *dwc)
+{
+	return list_entry(dwc->queue.next, struct dw_desc, desc_node);
+}
+
+static struct dw_desc *dwc_desc_get(struct dw_dma_chan *dwc)
+{
+	struct dw_desc *desc, *_desc;
+	struct dw_desc *ret = NULL;
+	unsigned int i = 0;
+
+	spin_lock_bh(&dwc->lock);
+	list_for_each_entry_safe(desc, _desc, &dwc->free_list, desc_node) {
+		if (async_tx_test_ack(&desc->txd)) {
+			list_del(&desc->desc_node);
+			ret = desc;
+			break;
+		}
+		dev_dbg(&dwc->chan.dev, "desc %p not ACKed\n", desc);
+		i++;
+	}
+	spin_unlock_bh(&dwc->lock);
+
+	dev_vdbg(&dwc->chan.dev, "scanned %u descriptors on freelist\n", i);
+
+	return ret;
+}
+
+static void dwc_sync_desc_for_cpu(struct dw_dma_chan *dwc, struct dw_desc *desc)
+{
+	struct dw_desc	*child;
+
+	list_for_each_entry(child, &desc->txd.tx_list, desc_node)
+		dma_sync_single_for_cpu(dwc->chan.dev.parent,
+				child->txd.phys, sizeof(child->lli),
+				DMA_TO_DEVICE);
+	dma_sync_single_for_cpu(dwc->chan.dev.parent,
+			desc->txd.phys, sizeof(desc->lli),
+			DMA_TO_DEVICE);
+}
+
+/*
+ * Move a descriptor, including any children, to the free list.
+ * `desc' must not be on any lists.
+ */
+static void dwc_desc_put(struct dw_dma_chan *dwc, struct dw_desc *desc)
+{
+	if (desc) {
+		struct dw_desc *child;
+
+		dwc_sync_desc_for_cpu(dwc, desc);
+
+		spin_lock_bh(&dwc->lock);
+		list_for_each_entry(child, &desc->txd.tx_list, desc_node)
+			dev_vdbg(&dwc->chan.dev,
+					"moving child desc %p to freelist\n",
+					child);
+		list_splice_init(&desc->txd.tx_list, &dwc->free_list);
+		dev_vdbg(&dwc->chan.dev, "moving desc %p to freelist\n", desc);
+		list_add(&desc->desc_node, &dwc->free_list);
+		spin_unlock_bh(&dwc->lock);
+	}
+}
+
+/* Called with dwc->lock held and bh disabled */
+static dma_cookie_t
+dwc_assign_cookie(struct dw_dma_chan *dwc, struct dw_desc *desc)
+{
+	dma_cookie_t cookie = dwc->chan.cookie;
+
+	if (++cookie < 0)
+		cookie = 1;
+
+	dwc->chan.cookie = cookie;
+	desc->txd.cookie = cookie;
+
+	return cookie;
+}
+
+/*----------------------------------------------------------------------*/
+
+/* Called with dwc->lock held and bh disabled */
+static void dwc_dostart(struct dw_dma_chan *dwc, struct dw_desc *first)
+{
+	struct dw_dma	*dw = to_dw_dma(dwc->chan.device);
+
+	/* ASSERT:  channel is idle */
+	if (dma_readl(dw, CH_EN) & dwc->mask) {
+		dev_err(&dwc->chan.dev,
+			"BUG: Attempted to start non-idle channel\n");
+		dev_err(&dwc->chan.dev,
+			"  SAR: 0x%x DAR: 0x%x LLP: 0x%x CTL: 0x%x:%08x\n",
+			channel_readl(dwc, SAR),
+			channel_readl(dwc, DAR),
+			channel_readl(dwc, LLP),
+			channel_readl(dwc, CTL_HI),
+			channel_readl(dwc, CTL_LO));
+
+		/* The tasklet will hopefully advance the queue... */
+		return;
+	}
+
+	channel_writel(dwc, LLP, first->txd.phys);
+	channel_writel(dwc, CTL_LO,
+			DWC_CTLL_LLP_D_EN | DWC_CTLL_LLP_S_EN);
+	channel_writel(dwc, CTL_HI, 0);
+	channel_set_bit(dw, CH_EN, dwc->mask);
+}
+
+/*----------------------------------------------------------------------*/
+
+static void
+dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
+{
+	dma_async_tx_callback		callback;
+	void				*param;
+	struct dma_async_tx_descriptor	*txd = &desc->txd;
+
+	dev_vdbg(&dwc->chan.dev, "descriptor %u complete\n", txd->cookie);
+
+	dwc->completed = txd->cookie;
+	callback = txd->callback;
+	param = txd->callback_param;
+
+	dwc_sync_desc_for_cpu(dwc, desc);
+	list_splice_init(&txd->tx_list, &dwc->free_list);
+	list_move(&desc->desc_node, &dwc->free_list);
+
+	/*
+	 * We use dma_unmap_page() regardless of how the buffers were
+	 * mapped before they were submitted...
+	 */
+	if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP))
+		dma_unmap_page(dwc->chan.dev.parent, desc->lli.dar, desc->len,
+				DMA_FROM_DEVICE);
+	if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP))
+		dma_unmap_page(dwc->chan.dev.parent, desc->lli.sar, desc->len,
+				DMA_TO_DEVICE);
+
+	/*
+	 * The API requires that no submissions are done from a
+	 * callback, so we don't need to drop the lock here
+	 */
+	if (callback)
+		callback(param);
+}
+
+static void dwc_complete_all(struct dw_dma *dw, struct dw_dma_chan *dwc)
+{
+	struct dw_desc *desc, *_desc;
+	LIST_HEAD(list);
+
+	if (dma_readl(dw, CH_EN) & dwc->mask) {
+		dev_err(&dwc->chan.dev,
+			"BUG: XFER bit set, but channel not idle!\n");
+
+		/* Try to continue after resetting the channel... */
+		channel_clear_bit(dw, CH_EN, dwc->mask);
+		while (dma_readl(dw, CH_EN) & dwc->mask)
+			cpu_relax();
+	}
+
+	/*
+	 * Submit queued descriptors ASAP, i.e. before we go through
+	 * the completed ones.
+	 */
+	if (!list_empty(&dwc->queue))
+		dwc_dostart(dwc, dwc_first_queued(dwc));
+	list_splice_init(&dwc->active_list, &list);
+	list_splice_init(&dwc->queue, &dwc->active_list);
+
+	list_for_each_entry_safe(desc, _desc, &list, desc_node)
+		dwc_descriptor_complete(dwc, desc);
+}
+
+static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
+{
+	dma_addr_t llp;
+	struct dw_desc *desc, *_desc;
+	struct dw_desc *child;
+	u32 status_xfer;
+
+	/*
+	 * Clear block interrupt flag before scanning so that we don't
+	 * miss any, and read LLP before RAW_XFER to ensure it is
+	 * valid if we decide to scan the list.
+	 */
+	dma_writel(dw, CLEAR.BLOCK, dwc->mask);
+	llp = channel_readl(dwc, LLP);
+	status_xfer = dma_readl(dw, RAW.XFER);
+
+	if (status_xfer & dwc->mask) {
+		/* Everything we've submitted is done */
+		dma_writel(dw, CLEAR.XFER, dwc->mask);
+		dwc_complete_all(dw, dwc);
+		return;
+	}
+
+	dev_vdbg(&dwc->chan.dev, "scan_descriptors: llp=0x%x\n", llp);
+
+	list_for_each_entry_safe(desc, _desc, &dwc->active_list, desc_node) {
+		if (desc->lli.llp == llp)
+			/* This one is currently in progress */
+			return;
+
+		list_for_each_entry(child, &desc->txd.tx_list, desc_node)
+			if (child->lli.llp == llp)
+				/* Currently in progress */
+				return;
+
+		/*
+		 * No descriptors so far seem to be in progress, i.e.
+		 * this one must be done.
+		 */
+		dwc_descriptor_complete(dwc, desc);
+	}
+
+	dev_err(&dwc->chan.dev,
+		"BUG: All descriptors done, but channel not idle!\n");
+
+	/* Try to continue after resetting the channel... */
+	channel_clear_bit(dw, CH_EN, dwc->mask);
+	while (dma_readl(dw, CH_EN) & dwc->mask)
+		cpu_relax();
+
+	if (!list_empty(&dwc->queue)) {
+		dwc_dostart(dwc, dwc_first_queued(dwc));
+		list_splice_init(&dwc->queue, &dwc->active_list);
+	}
+}
+
+static void dwc_dump_lli(struct dw_dma_chan *dwc, struct dw_lli *lli)
+{
+	dev_printk(KERN_CRIT, &dwc->chan.dev,
+			"  desc: s0x%x d0x%x l0x%x c0x%x:%x\n",
+			lli->sar, lli->dar, lli->llp,
+			lli->ctlhi, lli->ctllo);
+}
+
+static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
+{
+	struct dw_desc *bad_desc;
+	struct dw_desc *child;
+
+	dwc_scan_descriptors(dw, dwc);
+
+	/*
+	 * The descriptor currently at the head of the active list is
+	 * borked. Since we don't have any way to report errors, we'll
+	 * just have to scream loudly and try to carry on.
+	 */
+	bad_desc = dwc_first_active(dwc);
+	list_del_init(&bad_desc->desc_node);
+	list_splice_init(&dwc->queue, dwc->active_list.prev);
+
+	/* Clear the error flag and try to restart the controller */
+	dma_writel(dw, CLEAR.ERROR, dwc->mask);
+	if (!list_empty(&dwc->active_list))
+		dwc_dostart(dwc, dwc_first_active(dwc));
+
+	/*
+	 * KERN_CRITICAL may seem harsh, but since this only happens
+	 * when someone submits a bad physical address in a
+	 * descriptor, we should consider ourselves lucky that the
+	 * controller flagged an error instead of scribbling over
+	 * random memory locations.
+	 */
+	dev_printk(KERN_CRIT, &dwc->chan.dev,
+			"Bad descriptor submitted for DMA!\n");
+	dev_printk(KERN_CRIT, &dwc->chan.dev,
+			"  cookie: %d\n", bad_desc->txd.cookie);
+	dwc_dump_lli(dwc, &bad_desc->lli);
+	list_for_each_entry(child, &bad_desc->txd.tx_list, desc_node)
+		dwc_dump_lli(dwc, &child->lli);
+
+	/* Pretend the descriptor completed successfully */
+	dwc_descriptor_complete(dwc, bad_desc);
+}
+
+static void dw_dma_tasklet(unsigned long data)
+{
+	struct dw_dma *dw = (struct dw_dma *)data;
+	struct dw_dma_chan *dwc;
+	u32 status_block;
+	u32 status_xfer;
+	u32 status_err;
+	int i;
+
+	status_block = dma_readl(dw, RAW.BLOCK);
+	status_xfer = dma_readl(dw, RAW.BLOCK);
+	status_err = dma_readl(dw, RAW.ERROR);
+
+	dev_vdbg(dw->dma.dev, "tasklet: status_block=%x status_err=%x\n",
+			status_block, status_err);
+
+	for (i = 0; i < dw->dma.chancnt; i++) {
+		dwc = &dw->chan[i];
+		spin_lock(&dwc->lock);
+		if (status_err & (1 << i))
+			dwc_handle_error(dw, dwc);
+		else if ((status_block | status_xfer) & (1 << i))
+			dwc_scan_descriptors(dw, dwc);
+		spin_unlock(&dwc->lock);
+	}
+
+	/*
+	 * Re-enable interrupts. Block Complete interrupts are only
+	 * enabled if the INT_EN bit in the descriptor is set. This
+	 * will trigger a scan before the whole list is done.
+	 */
+	channel_set_bit(dw, MASK.XFER, dw->all_chan_mask);
+	channel_set_bit(dw, MASK.BLOCK, dw->all_chan_mask);
+	channel_set_bit(dw, MASK.ERROR, dw->all_chan_mask);
+}
+
+static irqreturn_t dw_dma_interrupt(int irq, void *dev_id)
+{
+	struct dw_dma *dw = dev_id;
+	u32 status;
+
+	dev_vdbg(dw->dma.dev, "interrupt: status=0x%x\n",
+			dma_readl(dw, STATUS_INT));
+
+	/*
+	 * Just disable the interrupts. We'll turn them back on in the
+	 * softirq handler.
+	 */
+	channel_clear_bit(dw, MASK.XFER, dw->all_chan_mask);
+	channel_clear_bit(dw, MASK.BLOCK, dw->all_chan_mask);
+	channel_clear_bit(dw, MASK.ERROR, dw->all_chan_mask);
+
+	status = dma_readl(dw, STATUS_INT);
+	if (status) {
+		dev_err(dw->dma.dev,
+			"BUG: Unexpected interrupts pending: 0x%x\n",
+			status);
+
+		/* Try to recover */
+		channel_clear_bit(dw, MASK.XFER, (1 << 8) - 1);
+		channel_clear_bit(dw, MASK.BLOCK, (1 << 8) - 1);
+		channel_clear_bit(dw, MASK.SRC_TRAN, (1 << 8) - 1);
+		channel_clear_bit(dw, MASK.DST_TRAN, (1 << 8) - 1);
+		channel_clear_bit(dw, MASK.ERROR, (1 << 8) - 1);
+	}
+
+	tasklet_schedule(&dw->tasklet);
+
+	return IRQ_HANDLED;
+}
+
+/*----------------------------------------------------------------------*/
+
+static dma_cookie_t dwc_tx_submit(struct dma_async_tx_descriptor *tx)
+{
+	struct dw_desc		*desc = txd_to_dw_desc(tx);
+	struct dw_dma_chan	*dwc = to_dw_dma_chan(tx->chan);
+	dma_cookie_t		cookie;
+
+	spin_lock_bh(&dwc->lock);
+	cookie = dwc_assign_cookie(dwc, desc);
+
+	/*
+	 * REVISIT: We should attempt to chain as many descriptors as
+	 * possible, perhaps even appending to those already submitted
+	 * for DMA. But this is hard to do in a race-free manner.
+	 */
+	if (list_empty(&dwc->active_list)) {
+		dev_vdbg(&tx->chan->dev, "tx_submit: started %u\n",
+				desc->txd.cookie);
+		dwc_dostart(dwc, desc);
+		list_add_tail(&desc->desc_node, &dwc->active_list);
+	} else {
+		dev_vdbg(&tx->chan->dev, "tx_submit: queued %u\n",
+				desc->txd.cookie);
+
+		list_add_tail(&desc->desc_node, &dwc->queue);
+	}
+
+	spin_unlock_bh(&dwc->lock);
+
+	return cookie;
+}
+
+static struct dma_async_tx_descriptor *
+dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
+		size_t len, unsigned long flags)
+{
+	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	struct dw_desc		*desc;
+	struct dw_desc		*first;
+	struct dw_desc		*prev;
+	size_t			xfer_count;
+	size_t			offset;
+	unsigned int		src_width;
+	unsigned int		dst_width;
+	u32			ctllo;
+
+	dev_vdbg(&chan->dev, "prep_dma_memcpy d0x%x s0x%x l0x%zx f0x%lx\n",
+			dest, src, len, flags);
+
+	if (unlikely(!len)) {
+		dev_dbg(&chan->dev, "prep_dma_memcpy: length is zero!\n");
+		return NULL;
+	}
+
+	/*
+	 * We can be a lot more clever here, but this should take care
+	 * of the most common optimization.
+	 */
+	if (!((src | dest  | len) & 3))
+		src_width = dst_width = 2;
+	else if (!((src | dest | len) & 1))
+		src_width = dst_width = 1;
+	else
+		src_width = dst_width = 0;
+
+	ctllo = DWC_DEFAULT_CTLLO
+			| DWC_CTLL_DST_WIDTH(dst_width)
+			| DWC_CTLL_SRC_WIDTH(src_width)
+			| DWC_CTLL_DST_INC
+			| DWC_CTLL_SRC_INC
+			| DWC_CTLL_FC_M2M;
+	prev = first = NULL;
+
+	for (offset = 0; offset < len; offset += xfer_count << src_width) {
+		xfer_count = min_t(size_t, (len - offset) >> src_width,
+				DWC_MAX_COUNT);
+
+		desc = dwc_desc_get(dwc);
+		if (!desc)
+			goto err_desc_get;
+
+		desc->lli.sar = src + offset;
+		desc->lli.dar = dest + offset;
+		desc->lli.ctllo = ctllo;
+		desc->lli.ctlhi = xfer_count;
+
+		if (!first) {
+			first = desc;
+		} else {
+			prev->lli.llp = desc->txd.phys;
+			dma_sync_single_for_device(chan->dev.parent,
+					prev->txd.phys, sizeof(prev->lli),
+					DMA_TO_DEVICE);
+			list_add_tail(&desc->desc_node,
+					&first->txd.tx_list);
+		}
+		prev = desc;
+	}
+
+
+	if (flags & DMA_PREP_INTERRUPT)
+		/* Trigger interrupt after last block */
+		prev->lli.ctllo |= DWC_CTLL_INT_EN;
+
+	prev->lli.llp = 0;
+	dma_sync_single_for_device(chan->dev.parent,
+			prev->txd.phys, sizeof(prev->lli),
+			DMA_TO_DEVICE);
+
+	first->txd.flags = flags;
+	first->len = len;
+
+	return &first->txd;
+
+err_desc_get:
+	dwc_desc_put(dwc, first);
+	return NULL;
+}
+
+static struct dma_async_tx_descriptor *
+dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
+		unsigned int sg_len, enum dma_data_direction direction,
+		unsigned long flags)
+{
+	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	struct dw_dma_slave	*dws = dwc->dws;
+	struct dw_desc		*prev;
+	struct dw_desc		*first;
+	u32			ctllo;
+	dma_addr_t		reg;
+	unsigned int		reg_width;
+	unsigned int		mem_width;
+	unsigned int		i;
+	struct scatterlist	*sg;
+	size_t			total_len = 0;
+
+	dev_vdbg(&chan->dev, "prep_dma_slave\n");
+
+	if (unlikely(!dws || !sg_len))
+		return NULL;
+
+	reg_width = dws->slave.reg_width;
+	prev = first = NULL;
+
+	sg_len = dma_map_sg(chan->dev.parent, sgl, sg_len, direction);
+
+	switch (direction) {
+	case DMA_TO_DEVICE:
+		ctllo = (DWC_DEFAULT_CTLLO
+				| DWC_CTLL_DST_WIDTH(reg_width)
+				| DWC_CTLL_DST_FIX
+				| DWC_CTLL_SRC_INC
+				| DWC_CTLL_FC_M2P);
+		reg = dws->slave.tx_reg;
+		for_each_sg(sgl, sg, sg_len, i) {
+			struct dw_desc	*desc;
+			u32		len;
+			u32		mem;
+
+			desc = dwc_desc_get(dwc);
+			if (!desc) {
+				dev_err(&chan->dev,
+					"not enough descriptors available\n");
+				goto err_desc_get;
+			}
+
+			mem = sg_phys(sg);
+			len = sg_dma_len(sg);
+			mem_width = 2;
+			if (unlikely(mem & 3 || len & 3))
+				mem_width = 0;
+
+			desc->lli.sar = mem;
+			desc->lli.dar = reg;
+			desc->lli.ctllo = ctllo | DWC_CTLL_SRC_WIDTH(mem_width);
+			desc->lli.ctlhi = len >> mem_width;
+
+			if (!first) {
+				first = desc;
+			} else {
+				prev->lli.llp = desc->txd.phys;
+				dma_sync_single_for_device(chan->dev.parent,
+						prev->txd.phys,
+						sizeof(prev->lli),
+						DMA_TO_DEVICE);
+				list_add_tail(&desc->desc_node,
+						&first->txd.tx_list);
+			}
+			prev = desc;
+			total_len += len;
+		}
+		break;
+	case DMA_FROM_DEVICE:
+		ctllo = (DWC_DEFAULT_CTLLO
+				| DWC_CTLL_SRC_WIDTH(reg_width)
+				| DWC_CTLL_DST_INC
+				| DWC_CTLL_SRC_FIX
+				| DWC_CTLL_FC_P2M);
+
+		reg = dws->slave.rx_reg;
+		for_each_sg(sgl, sg, sg_len, i) {
+			struct dw_desc	*desc;
+			u32		len;
+			u32		mem;
+
+			desc = dwc_desc_get(dwc);
+			if (!desc) {
+				dev_err(&chan->dev,
+					"not enough descriptors available\n");
+				goto err_desc_get;
+			}
+
+			mem = sg_phys(sg);
+			len = sg_dma_len(sg);
+			mem_width = 2;
+			if (unlikely(mem & 3 || len & 3))
+				mem_width = 0;
+
+			desc->lli.sar = reg;
+			desc->lli.dar = mem;
+			desc->lli.ctllo = ctllo | DWC_CTLL_DST_WIDTH(mem_width);
+			desc->lli.ctlhi = len >> reg_width;
+
+			if (!first) {
+				first = desc;
+			} else {
+				prev->lli.llp = desc->txd.phys;
+				dma_sync_single_for_device(chan->dev.parent,
+						prev->txd.phys,
+						sizeof(prev->lli),
+						DMA_TO_DEVICE);
+				list_add_tail(&desc->desc_node,
+						&first->txd.tx_list);
+			}
+			prev = desc;
+			total_len += len;
+		}
+		break;
+	default:
+		return NULL;
+	}
+
+	if (flags & DMA_PREP_INTERRUPT)
+		/* Trigger interrupt after last block */
+		prev->lli.ctllo |= DWC_CTLL_INT_EN;
+
+	prev->lli.llp = 0;
+	dma_sync_single_for_device(chan->dev.parent,
+			prev->txd.phys, sizeof(prev->lli),
+			DMA_TO_DEVICE);
+
+	first->len = total_len;
+
+	return &first->txd;
+
+err_desc_get:
+	dwc_desc_put(dwc, first);
+	return NULL;
+}
+
+static void dwc_terminate_all(struct dma_chan *chan)
+{
+	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	struct dw_dma		*dw = to_dw_dma(chan->device);
+	struct dw_desc		*desc, *_desc;
+	LIST_HEAD(list);
+
+	/*
+	 * This is only called when something went wrong elsewhere, so
+	 * we don't really care about the data. Just disable the
+	 * channel. We still have to poll the channel enable bit due
+	 * to AHB/HSB limitations.
+	 */
+	spin_lock_bh(&dwc->lock);
+
+	channel_clear_bit(dw, CH_EN, dwc->mask);
+
+	while (dma_readl(dw, CH_EN) & dwc->mask)
+		cpu_relax();
+
+	/* active_list entries will end up before queued entries */
+	list_splice_init(&dwc->queue, &list);
+	list_splice_init(&dwc->active_list, &list);
+
+	spin_unlock_bh(&dwc->lock);
+
+	/* Flush all pending and queued descriptors */
+	list_for_each_entry_safe(desc, _desc, &list, desc_node)
+		dwc_descriptor_complete(dwc, desc);
+}
+
+static enum dma_status
+dwc_is_tx_complete(struct dma_chan *chan,
+		dma_cookie_t cookie,
+		dma_cookie_t *done, dma_cookie_t *used)
+{
+	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	dma_cookie_t		last_used;
+	dma_cookie_t		last_complete;
+	int			ret;
+
+	last_complete = dwc->completed;
+	last_used = chan->cookie;
+
+	ret = dma_async_is_complete(cookie, last_complete, last_used);
+	if (ret != DMA_SUCCESS) {
+		dwc_scan_descriptors(to_dw_dma(chan->device), dwc);
+
+		last_complete = dwc->completed;
+		last_used = chan->cookie;
+
+		ret = dma_async_is_complete(cookie, last_complete, last_used);
+	}
+
+	if (done)
+		*done = last_complete;
+	if (used)
+		*used = last_used;
+
+	return ret;
+}
+
+static void dwc_issue_pending(struct dma_chan *chan)
+{
+	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+
+	spin_lock_bh(&dwc->lock);
+	if (!list_empty(&dwc->queue))
+		dwc_scan_descriptors(to_dw_dma(chan->device), dwc);
+	spin_unlock_bh(&dwc->lock);
+}
+
+static int dwc_alloc_chan_resources(struct dma_chan *chan,
+		struct dma_client *client)
+{
+	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	struct dw_dma		*dw = to_dw_dma(chan->device);
+	struct dw_desc		*desc;
+	struct dma_slave	*slave;
+	struct dw_dma_slave	*dws;
+	int			i;
+	u32			cfghi;
+	u32			cfglo;
+
+	dev_vdbg(&chan->dev, "alloc_chan_resources\n");
+
+	/* Channels doing slave DMA can only handle one client. */
+	if (dwc->dws || client->slave) {
+		if (chan->client_count)
+			return -EBUSY;
+	}
+
+	/* ASSERT:  channel is idle */
+	if (dma_readl(dw, CH_EN) & dwc->mask) {
+		dev_dbg(&chan->dev, "DMA channel not idle?\n");
+		return -EIO;
+	}
+
+	dwc->completed = chan->cookie = 1;
+
+	cfghi = DWC_CFGH_FIFO_MODE;
+	cfglo = 0;
+
+	slave = client->slave;
+	if (slave) {
+		/*
+		 * We need controller-specific data to set up slave
+		 * transfers.
+		 */
+		BUG_ON(!slave->dma_dev || slave->dma_dev != dw->dma.dev);
+
+		dws = container_of(slave, struct dw_dma_slave, slave);
+
+		dwc->dws = dws;
+		cfghi = dws->cfg_hi;
+		cfglo = dws->cfg_lo;
+	} else {
+		dwc->dws = NULL;
+	}
+
+	channel_writel(dwc, CFG_LO, cfglo);
+	channel_writel(dwc, CFG_HI, cfghi);
+
+	/*
+	 * NOTE: some controllers may have additional features that we
+	 * need to initialize here, like "scatter-gather" (which
+	 * doesn't mean what you think it means), and status writeback.
+	 */
+
+	spin_lock_bh(&dwc->lock);
+	i = dwc->descs_allocated;
+	while (dwc->descs_allocated < NR_DESCS_PER_CHANNEL) {
+		spin_unlock_bh(&dwc->lock);
+
+		desc = kzalloc(sizeof(struct dw_desc), GFP_KERNEL);
+		if (!desc) {
+			dev_info(&chan->dev,
+				"only allocated %d descriptors\n", i);
+			spin_lock_bh(&dwc->lock);
+			break;
+		}
+
+		dma_async_tx_descriptor_init(&desc->txd, chan);
+		desc->txd.tx_submit = dwc_tx_submit;
+		desc->txd.flags = DMA_CTRL_ACK;
+		INIT_LIST_HEAD(&desc->txd.tx_list);
+		desc->txd.phys = dma_map_single(chan->dev.parent, &desc->lli,
+				sizeof(desc->lli), DMA_TO_DEVICE);
+		dwc_desc_put(dwc, desc);
+
+		spin_lock_bh(&dwc->lock);
+		i = ++dwc->descs_allocated;
+	}
+
+	/* Enable interrupts */
+	channel_set_bit(dw, MASK.XFER, dwc->mask);
+	channel_set_bit(dw, MASK.BLOCK, dwc->mask);
+	channel_set_bit(dw, MASK.ERROR, dwc->mask);
+
+	spin_unlock_bh(&dwc->lock);
+
+	dev_dbg(&chan->dev,
+		"alloc_chan_resources allocated %d descriptors\n", i);
+
+	return i;
+}
+
+static void dwc_free_chan_resources(struct dma_chan *chan)
+{
+	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	struct dw_dma		*dw = to_dw_dma(chan->device);
+	struct dw_desc		*desc, *_desc;
+	LIST_HEAD(list);
+
+	dev_dbg(&chan->dev, "free_chan_resources (descs allocated=%u)\n",
+			dwc->descs_allocated);
+
+	/* ASSERT:  channel is idle */
+	BUG_ON(!list_empty(&dwc->active_list));
+	BUG_ON(!list_empty(&dwc->queue));
+	BUG_ON(dma_readl(to_dw_dma(chan->device), CH_EN) & dwc->mask);
+
+	spin_lock_bh(&dwc->lock);
+	list_splice_init(&dwc->free_list, &list);
+	dwc->descs_allocated = 0;
+	dwc->dws = NULL;
+
+	/* Disable interrupts */
+	channel_clear_bit(dw, MASK.XFER, dwc->mask);
+	channel_clear_bit(dw, MASK.BLOCK, dwc->mask);
+	channel_clear_bit(dw, MASK.ERROR, dwc->mask);
+
+	spin_unlock_bh(&dwc->lock);
+
+	list_for_each_entry_safe(desc, _desc, &list, desc_node) {
+		dev_vdbg(&chan->dev, "  freeing descriptor %p\n", desc);
+		dma_unmap_single(chan->dev.parent, desc->txd.phys,
+				sizeof(desc->lli), DMA_TO_DEVICE);
+		kfree(desc);
+	}
+
+	dev_vdbg(&chan->dev, "free_chan_resources done\n");
+}
+
+/*----------------------------------------------------------------------*/
+
+static void dw_dma_off(struct dw_dma *dw)
+{
+	dma_writel(dw, CFG, 0);
+
+	channel_clear_bit(dw, MASK.XFER, dw->all_chan_mask);
+	channel_clear_bit(dw, MASK.BLOCK, dw->all_chan_mask);
+	channel_clear_bit(dw, MASK.SRC_TRAN, dw->all_chan_mask);
+	channel_clear_bit(dw, MASK.DST_TRAN, dw->all_chan_mask);
+	channel_clear_bit(dw, MASK.ERROR, dw->all_chan_mask);
+
+	while (dma_readl(dw, CFG) & DW_CFG_DMA_EN)
+		cpu_relax();
+}
+
+static int __init dw_probe(struct platform_device *pdev)
+{
+	struct dw_dma_platform_data *pdata;
+	struct resource		*io;
+	struct dw_dma		*dw;
+	size_t			size;
+	int			irq;
+	int			err;
+	int			i;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata || pdata->nr_channels > DW_DMA_MAX_NR_CHANNELS)
+		return -EINVAL;
+
+	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!io)
+		return -EINVAL;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	size = sizeof(struct dw_dma);
+	size += pdata->nr_channels * sizeof(struct dw_dma_chan);
+	dw = kzalloc(size, GFP_KERNEL);
+	if (!dw)
+		return -ENOMEM;
+
+	if (!request_mem_region(io->start, DW_REGLEN, pdev->dev.driver->name)) {
+		err = -EBUSY;
+		goto err_kfree;
+	}
+
+	memset(dw, 0, sizeof *dw);
+
+	dw->regs = ioremap(io->start, DW_REGLEN);
+	if (!dw->regs) {
+		err = -ENOMEM;
+		goto err_release_r;
+	}
+
+	dw->clk = clk_get(&pdev->dev, "hclk");
+	if (IS_ERR(dw->clk)) {
+		err = PTR_ERR(dw->clk);
+		goto err_clk;
+	}
+	clk_enable(dw->clk);
+
+	/* force dma off, just in case */
+	dw_dma_off(dw);
+
+	err = request_irq(irq, dw_dma_interrupt, 0, "dw_dmac", dw);
+	if (err)
+		goto err_irq;
+
+	platform_set_drvdata(pdev, dw);
+
+	tasklet_init(&dw->tasklet, dw_dma_tasklet, (unsigned long)dw);
+
+	dw->all_chan_mask = (1 << pdata->nr_channels) - 1;
+
+	INIT_LIST_HEAD(&dw->dma.channels);
+	for (i = 0; i < pdata->nr_channels; i++, dw->dma.chancnt++) {
+		struct dw_dma_chan	*dwc = &dw->chan[i];
+
+		dwc->chan.device = &dw->dma;
+		dwc->chan.cookie = dwc->completed = 1;
+		dwc->chan.chan_id = i;
+		list_add_tail(&dwc->chan.device_node, &dw->dma.channels);
+
+		dwc->ch_regs = &__dw_regs(dw)->CHAN[i];
+		spin_lock_init(&dwc->lock);
+		dwc->mask = 1 << i;
+
+		INIT_LIST_HEAD(&dwc->active_list);
+		INIT_LIST_HEAD(&dwc->queue);
+		INIT_LIST_HEAD(&dwc->free_list);
+
+		channel_clear_bit(dw, CH_EN, dwc->mask);
+	}
+
+	/* Clear/disable all interrupts on all channels. */
+	dma_writel(dw, CLEAR.XFER, dw->all_chan_mask);
+	dma_writel(dw, CLEAR.BLOCK, dw->all_chan_mask);
+	dma_writel(dw, CLEAR.SRC_TRAN, dw->all_chan_mask);
+	dma_writel(dw, CLEAR.DST_TRAN, dw->all_chan_mask);
+	dma_writel(dw, CLEAR.ERROR, dw->all_chan_mask);
+
+	channel_clear_bit(dw, MASK.XFER, dw->all_chan_mask);
+	channel_clear_bit(dw, MASK.BLOCK, dw->all_chan_mask);
+	channel_clear_bit(dw, MASK.SRC_TRAN, dw->all_chan_mask);
+	channel_clear_bit(dw, MASK.DST_TRAN, dw->all_chan_mask);
+	channel_clear_bit(dw, MASK.ERROR, dw->all_chan_mask);
+
+	dma_cap_set(DMA_MEMCPY, dw->dma.cap_mask);
+	dma_cap_set(DMA_SLAVE, dw->dma.cap_mask);
+	dw->dma.dev = &pdev->dev;
+	dw->dma.device_alloc_chan_resources = dwc_alloc_chan_resources;
+	dw->dma.device_free_chan_resources = dwc_free_chan_resources;
+
+	dw->dma.device_prep_dma_memcpy = dwc_prep_dma_memcpy;
+
+	dw->dma.device_prep_slave_sg = dwc_prep_slave_sg;
+	dw->dma.device_terminate_all = dwc_terminate_all;
+
+	dw->dma.device_is_tx_complete = dwc_is_tx_complete;
+	dw->dma.device_issue_pending = dwc_issue_pending;
+
+	dma_writel(dw, CFG, DW_CFG_DMA_EN);
+
+	printk(KERN_INFO "%s: DesignWare DMA Controller, %d channels\n",
+			pdev->dev.bus_id, dw->dma.chancnt);
+
+	dma_async_device_register(&dw->dma);
+
+	return 0;
+
+err_irq:
+	clk_disable(dw->clk);
+	clk_put(dw->clk);
+err_clk:
+	iounmap(dw->regs);
+	dw->regs = NULL;
+err_release_r:
+	release_resource(io);
+err_kfree:
+	kfree(dw);
+	return err;
+}
+
+static int __exit dw_remove(struct platform_device *pdev)
+{
+	struct dw_dma		*dw = platform_get_drvdata(pdev);
+	struct dw_dma_chan	*dwc, *_dwc;
+	struct resource		*io;
+
+	dw_dma_off(dw);
+	dma_async_device_unregister(&dw->dma);
+
+	free_irq(platform_get_irq(pdev, 0), dw);
+	tasklet_kill(&dw->tasklet);
+
+	list_for_each_entry_safe(dwc, _dwc, &dw->dma.channels,
+			chan.device_node) {
+		list_del(&dwc->chan.device_node);
+		channel_clear_bit(dw, CH_EN, dwc->mask);
+	}
+
+	clk_disable(dw->clk);
+	clk_put(dw->clk);
+
+	iounmap(dw->regs);
+	dw->regs = NULL;
+
+	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(io->start, DW_REGLEN);
+
+	kfree(dw);
+
+	return 0;
+}
+
+static void dw_shutdown(struct platform_device *pdev)
+{
+	struct dw_dma	*dw = platform_get_drvdata(pdev);
+
+	dw_dma_off(platform_get_drvdata(pdev));
+	clk_disable(dw->clk);
+}
+
+static int dw_suspend_late(struct platform_device *pdev, pm_message_t mesg)
+{
+	struct dw_dma	*dw = platform_get_drvdata(pdev);
+
+	dw_dma_off(platform_get_drvdata(pdev));
+	clk_disable(dw->clk);
+	return 0;
+}
+
+static int dw_resume_early(struct platform_device *pdev)
+{
+	struct dw_dma	*dw = platform_get_drvdata(pdev);
+
+	clk_enable(dw->clk);
+	dma_writel(dw, CFG, DW_CFG_DMA_EN);
+	return 0;
+
+}
+
+static struct platform_driver dw_driver = {
+	.remove		= __exit_p(dw_remove),
+	.shutdown	= dw_shutdown,
+	.suspend_late	= dw_suspend_late,
+	.resume_early	= dw_resume_early,
+	.driver = {
+		.name	= "dw_dmac",
+	},
+};
+
+static int __init dw_init(void)
+{
+	return platform_driver_probe(&dw_driver, dw_probe);
+}
+module_init(dw_init);
+
+static void __exit dw_exit(void)
+{
+	platform_driver_unregister(&dw_driver);
+}
+module_exit(dw_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Synopsys DesignWare DMA Controller driver");
+MODULE_AUTHOR("Haavard Skinnemoen <haavard.skinnemoen@atmel.com>");
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
new file mode 100644
index 0000000..00fdd18
--- /dev/null
+++ b/drivers/dma/dw_dmac_regs.h
@@ -0,0 +1,225 @@
+/*
+ * Driver for the Synopsys DesignWare AHB DMA Controller
+ *
+ * Copyright (C) 2005-2007 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/dw_dmac.h>
+
+#define DW_DMA_MAX_NR_CHANNELS	8
+
+/*
+ * Redefine this macro to handle differences between 32- and 64-bit
+ * addressing, big vs. little endian, etc.
+ */
+#define DW_REG(name)		u32 name; u32 __pad_##name
+
+/* Hardware register definitions. */
+struct dw_dma_chan_regs {
+	DW_REG(SAR);		/* Source Address Register */
+	DW_REG(DAR);		/* Destination Address Register */
+	DW_REG(LLP);		/* Linked List Pointer */
+	u32	CTL_LO;		/* Control Register Low */
+	u32	CTL_HI;		/* Control Register High */
+	DW_REG(SSTAT);
+	DW_REG(DSTAT);
+	DW_REG(SSTATAR);
+	DW_REG(DSTATAR);
+	u32	CFG_LO;		/* Configuration Register Low */
+	u32	CFG_HI;		/* Configuration Register High */
+	DW_REG(SGR);
+	DW_REG(DSR);
+};
+
+struct dw_dma_irq_regs {
+	DW_REG(XFER);
+	DW_REG(BLOCK);
+	DW_REG(SRC_TRAN);
+	DW_REG(DST_TRAN);
+	DW_REG(ERROR);
+};
+
+struct dw_dma_regs {
+	/* per-channel registers */
+	struct dw_dma_chan_regs	CHAN[DW_DMA_MAX_NR_CHANNELS];
+
+	/* irq handling */
+	struct dw_dma_irq_regs	RAW;		/* r */
+	struct dw_dma_irq_regs	STATUS;		/* r (raw & mask) */
+	struct dw_dma_irq_regs	MASK;		/* rw (set = irq enabled) */
+	struct dw_dma_irq_regs	CLEAR;		/* w (ack, affects "raw") */
+
+	DW_REG(STATUS_INT);			/* r */
+
+	/* software handshaking */
+	DW_REG(REQ_SRC);
+	DW_REG(REQ_DST);
+	DW_REG(SGL_REQ_SRC);
+	DW_REG(SGL_REQ_DST);
+	DW_REG(LAST_SRC);
+	DW_REG(LAST_DST);
+
+	/* miscellaneous */
+	DW_REG(CFG);
+	DW_REG(CH_EN);
+	DW_REG(ID);
+	DW_REG(TEST);
+
+	/* optional encoded params, 0x3c8..0x3 */
+};
+
+/* Bitfields in CTL_LO */
+#define DWC_CTLL_INT_EN		(1 << 0)	/* irqs enabled? */
+#define DWC_CTLL_DST_WIDTH(n)	((n)<<1)	/* bytes per element */
+#define DWC_CTLL_SRC_WIDTH(n)	((n)<<4)
+#define DWC_CTLL_DST_INC	(0<<7)		/* DAR update/not */
+#define DWC_CTLL_DST_DEC	(1<<7)
+#define DWC_CTLL_DST_FIX	(2<<7)
+#define DWC_CTLL_SRC_INC	(0<<7)		/* SAR update/not */
+#define DWC_CTLL_SRC_DEC	(1<<9)
+#define DWC_CTLL_SRC_FIX	(2<<9)
+#define DWC_CTLL_DST_MSIZE(n)	((n)<<11)	/* burst, #elements */
+#define DWC_CTLL_SRC_MSIZE(n)	((n)<<14)
+#define DWC_CTLL_S_GATH_EN	(1 << 17)	/* src gather, !FIX */
+#define DWC_CTLL_D_SCAT_EN	(1 << 18)	/* dst scatter, !FIX */
+#define DWC_CTLL_FC_M2M		(0 << 20)	/* mem-to-mem */
+#define DWC_CTLL_FC_M2P		(1 << 20)	/* mem-to-periph */
+#define DWC_CTLL_FC_P2M		(2 << 20)	/* periph-to-mem */
+#define DWC_CTLL_FC_P2P		(3 << 20)	/* periph-to-periph */
+/* plus 4 transfer types for peripheral-as-flow-controller */
+#define DWC_CTLL_DMS(n)		((n)<<23)	/* dst master select */
+#define DWC_CTLL_SMS(n)		((n)<<25)	/* src master select */
+#define DWC_CTLL_LLP_D_EN	(1 << 27)	/* dest block chain */
+#define DWC_CTLL_LLP_S_EN	(1 << 28)	/* src block chain */
+
+/* Bitfields in CTL_HI */
+#define DWC_CTLH_DONE		0x00001000
+#define DWC_CTLH_BLOCK_TS_MASK	0x00000fff
+
+/* Bitfields in CFG_LO. Platform-configurable bits are in <linux/dw_dmac.h> */
+#define DWC_CFGL_CH_SUSP	(1 << 8)	/* pause xfer */
+#define DWC_CFGL_FIFO_EMPTY	(1 << 9)	/* pause xfer */
+#define DWC_CFGL_HS_DST		(1 << 10)	/* handshake w/dst */
+#define DWC_CFGL_HS_SRC		(1 << 11)	/* handshake w/src */
+#define DWC_CFGL_MAX_BURST(x)	((x) << 20)
+#define DWC_CFGL_RELOAD_SAR	(1 << 30)
+#define DWC_CFGL_RELOAD_DAR	(1 << 31)
+
+/* Bitfields in CFG_HI. Platform-configurable bits are in <linux/dw_dmac.h> */
+#define DWC_CFGH_DS_UPD_EN	(1 << 5)
+#define DWC_CFGH_SS_UPD_EN	(1 << 6)
+
+/* Bitfields in SGR */
+#define DWC_SGR_SGI(x)		((x) << 0)
+#define DWC_SGR_SGC(x)		((x) << 20)
+
+/* Bitfields in DSR */
+#define DWC_DSR_DSI(x)		((x) << 0)
+#define DWC_DSR_DSC(x)		((x) << 20)
+
+/* Bitfields in CFG */
+#define DW_CFG_DMA_EN		(1 << 0)
+
+#define DW_REGLEN		0x400
+
+struct dw_dma_chan {
+	struct dma_chan		chan;
+	void __iomem		*ch_regs;
+	u8			mask;
+
+	spinlock_t		lock;
+
+	/* these other elements are all protected by lock */
+	dma_cookie_t		completed;
+	struct list_head	active_list;
+	struct list_head	queue;
+	struct list_head	free_list;
+
+	struct dw_dma_slave	*dws;
+
+	unsigned int		descs_allocated;
+};
+
+static inline struct dw_dma_chan_regs __iomem *
+__dwc_regs(struct dw_dma_chan *dwc)
+{
+	return dwc->ch_regs;
+}
+
+#define channel_readl(dwc, name) \
+	__raw_readl(&(__dwc_regs(dwc)->name))
+#define channel_writel(dwc, name, val) \
+	__raw_writel((val), &(__dwc_regs(dwc)->name))
+
+static inline struct dw_dma_chan *to_dw_dma_chan(struct dma_chan *chan)
+{
+	return container_of(chan, struct dw_dma_chan, chan);
+}
+
+
+struct dw_dma {
+	struct dma_device	dma;
+	void __iomem		*regs;
+	struct tasklet_struct	tasklet;
+	struct clk		*clk;
+
+	u8			all_chan_mask;
+
+	struct dw_dma_chan	chan[0];
+};
+
+static inline struct dw_dma_regs __iomem *__dw_regs(struct dw_dma *dw)
+{
+	return dw->regs;
+}
+
+#define dma_readl(dw, name) \
+	__raw_readl(&(__dw_regs(dw)->name))
+#define dma_writel(dw, name, val) \
+	__raw_writel((val), &(__dw_regs(dw)->name))
+
+#define channel_set_bit(dw, reg, mask) \
+	dma_writel(dw, reg, ((mask) << 8) | (mask))
+#define channel_clear_bit(dw, reg, mask) \
+	dma_writel(dw, reg, ((mask) << 8) | 0)
+
+static inline struct dw_dma *to_dw_dma(struct dma_device *ddev)
+{
+	return container_of(ddev, struct dw_dma, dma);
+}
+
+/* LLI == Linked List Item; a.k.a. DMA block descriptor */
+struct dw_lli {
+	/* values that are not changed by hardware */
+	dma_addr_t	sar;
+	dma_addr_t	dar;
+	dma_addr_t	llp;		/* chain to next lli */
+	u32		ctllo;
+	/* values that may get written back: */
+	u32		ctlhi;
+	/* sstat and dstat can snapshot peripheral register state.
+	 * silicon config may discard either or both...
+	 */
+	u32		sstat;
+	u32		dstat;
+};
+
+struct dw_desc {
+	/* FIRST values the hardware uses */
+	struct dw_lli			lli;
+
+	/* THEN values for driver housekeeping */
+	struct list_head		desc_node;
+	struct dma_async_tx_descriptor	txd;
+	size_t				len;
+};
+
+static inline struct dw_desc *
+txd_to_dw_desc(struct dma_async_tx_descriptor *txd)
+{
+	return container_of(txd, struct dw_desc, txd);
+}
diff --git a/include/asm-avr32/arch-at32ap/at32ap700x.h b/include/asm-avr32/arch-at32ap/at32ap700x.h
index 31e48b0..d18a305 100644
--- a/include/asm-avr32/arch-at32ap/at32ap700x.h
+++ b/include/asm-avr32/arch-at32ap/at32ap700x.h
@@ -30,4 +30,20 @@
 #define GPIO_PIN_PD(N)	(GPIO_PIOD_BASE + (N))
 #define GPIO_PIN_PE(N)	(GPIO_PIOE_BASE + (N))
 
+
+/*
+ * DMAC peripheral hardware handshaking interfaces, used with dw_dmac
+ */
+#define DMAC_MCI_RX		0
+#define DMAC_MCI_TX		1
+#define DMAC_DAC_TX		2
+#define DMAC_AC97_A_RX		3
+#define DMAC_AC97_A_TX		4
+#define DMAC_AC97_B_RX		5
+#define DMAC_AC97_B_TX		6
+#define DMAC_DMAREQ_0		7
+#define DMAC_DMAREQ_1		8
+#define DMAC_DMAREQ_2		9
+#define DMAC_DMAREQ_3		10
+
 #endif /* __ASM_ARCH_AT32AP700X_H__ */
diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
new file mode 100644
index 0000000..04d217b
--- /dev/null
+++ b/include/linux/dw_dmac.h
@@ -0,0 +1,62 @@
+/*
+ * Driver for the Synopsys DesignWare DMA Controller (aka DMACA on
+ * AVR32 systems.)
+ *
+ * Copyright (C) 2007 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef DW_DMAC_H
+#define DW_DMAC_H
+
+#include <linux/dmaengine.h>
+
+/**
+ * struct dw_dma_platform_data - Controller configuration parameters
+ * @nr_channels: Number of channels supported by hardware (max 8)
+ */
+struct dw_dma_platform_data {
+	unsigned int	nr_channels;
+};
+
+/**
+ * struct dw_dma_slave - Controller-specific information about a slave
+ * @slave: Generic information about the slave
+ * @ctl_lo: Platform-specific initializer for the CTL_LO register
+ * @cfg_hi: Platform-specific initializer for the CFG_HI register
+ * @cfg_lo: Platform-specific initializer for the CFG_LO register
+ */
+struct dw_dma_slave {
+	struct dma_slave	slave;
+	u32			cfg_hi;
+	u32			cfg_lo;
+};
+
+/* Platform-configurable bits in CFG_HI */
+#define DWC_CFGH_FCMODE		(1 << 0)
+#define DWC_CFGH_FIFO_MODE	(1 << 1)
+#define DWC_CFGH_PROTCTL(x)	((x) << 2)
+#define DWC_CFGH_SRC_PER(x)	((x) << 7)
+#define DWC_CFGH_DST_PER(x)	((x) << 11)
+
+/* Platform-configurable bits in CFG_LO */
+#define DWC_CFGL_PRIO(x)	((x) << 5)	/* priority */
+#define DWC_CFGL_LOCK_CH_XFER	(0 << 12)	/* scope of LOCK_CH */
+#define DWC_CFGL_LOCK_CH_BLOCK	(1 << 12)
+#define DWC_CFGL_LOCK_CH_XACT	(2 << 12)
+#define DWC_CFGL_LOCK_BUS_XFER	(0 << 14)	/* scope of LOCK_BUS */
+#define DWC_CFGL_LOCK_BUS_BLOCK	(1 << 14)
+#define DWC_CFGL_LOCK_BUS_XACT	(2 << 14)
+#define DWC_CFGL_LOCK_CH	(1 << 15)	/* channel lockout */
+#define DWC_CFGL_LOCK_BUS	(1 << 16)	/* busmaster lockout */
+#define DWC_CFGL_HS_DST_POL	(1 << 18)	/* dst handshake active low */
+#define DWC_CFGL_HS_SRC_POL	(1 << 19)	/* src handshake active low */
+
+static inline struct dw_dma_slave *to_dw_dma_slave(struct dma_slave *slave)
+{
+	return container_of(slave, struct dw_dma_slave, slave);
+}
+
+#endif /* DW_DMAC_H */
-- 
1.5.6

