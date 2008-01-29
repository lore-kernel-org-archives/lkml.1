Return-Path: <linux-kernel-owner+w=401wt.eu-S933558AbYA2SMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558AbYA2SMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbYA2SKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:10:32 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:58702 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753747AbYA2SKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:10:21 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: Shannon Nelson <shannon.nelson@intel.com>,
       David Brownell <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [RFC v2 4/5] dmaengine: Driver for the Synopsys DesignWare DMA controller
Date: Tue, 29 Jan 2008 19:10:12 +0100
Message-Id: <1201630213-31900-5-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1201630213-31900-4-git-send-email-hskinnemoen@atmel.com>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
 <1201630213-31900-2-git-send-email-hskinnemoen@atmel.com>
 <1201630213-31900-3-git-send-email-hskinnemoen@atmel.com>
 <1201630213-31900-4-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a driver for the Synopsys DesignWare DMA controller (aka
DMACA on AVR32 systems.) This DMA controller can be found integrated
on the AT32AP7000 chip and is primarily meant for peripheral DMA
transfer, but can also be used for memory-to-memory transfers.

The dmatest client shows no problems, but the performance is not as
good as it should be yet -- iperf shows a slight slowdown when
enabling TCP receive copy offload. This is probably because the
controller is set up to always do byte transfers; I'll try to optimize
this, but if someone can tell me if there any guaranteed alignment
requirements for the users of the DMA engine API, that would help a
lot.

This driver implements the new DMA_SLAVE capability and has been
tested with the Atmel MMC driver posted later in this series.

This patch is based on a driver from David Brownell which was based on
an older version of the DMA Engine framework. It also implements the
proposed extensions to the DMA Engine API for slave DMA operations.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 arch/avr32/mach-at32ap/at32ap700x.c        |   29 +-
 drivers/dma/Kconfig                        |    9 +
 drivers/dma/Makefile                       |    1 +
 drivers/dma/dw_dmac.c                      | 1120 ++++++++++++++++++++++++++++
 drivers/dma/dw_dmac.h                      |  256 +++++++
 include/asm-avr32/arch-at32ap/at32ap700x.h |   16 +
 6 files changed, 1418 insertions(+), 13 deletions(-)
 create mode 100644 drivers/dma/dw_dmac.c
 create mode 100644 drivers/dma/dw_dmac.h

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 14e61f0..4f130a8 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -451,6 +451,20 @@ static void __init genclk_init_parent(struct clk *clk)
 	clk->parent = parent;
 }
 
+/* REVISIT we may want a real struct for this driver's platform data,
+ * but for now we'll only use it to pass the number of DMA channels
+ * configured into this instance.  Also, most platform data here ought
+ * to be declared as "const" (not just this) ...
+ */
+static unsigned dw_dmac0_data = 3;
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
@@ -557,17 +571,6 @@ static struct clk pico_clk = {
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
@@ -667,7 +670,7 @@ void __init at32_add_system_devices(void)
 	platform_device_register(&at32_eic0_device);
 	platform_device_register(&smc0_device);
 	platform_device_register(&pdc_device);
-	platform_device_register(&dmaca0_device);
+	platform_device_register(&dw_dmac0_device);
 
 	platform_device_register(&at32_systc0_device);
 
@@ -1634,7 +1637,7 @@ struct clk *at32_clock_list[] = {
 	&smc0_mck,
 	&pdc_hclk,
 	&pdc_pclk,
-	&dmaca0_hclk,
+	&dw_dmac0_hclk,
 	&pico_clk,
 	&pio0_mck,
 	&pio1_mck,
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 1a727c1..76582db 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -37,6 +37,15 @@ config INTEL_IOP_ADMA
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
 config DMA_ENGINE
 	bool
 
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index cecfb60..0f3b24f 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_DMA_ENGINE) += dmaengine.o
 obj-$(CONFIG_NET_DMA) += iovlock.o
 obj-$(CONFIG_INTEL_IOATDMA) += ioatdma.o
+obj-$(CONFIG_DW_DMAC) += dw_dmac.o
 ioatdma-objs := ioat.o ioat_dma.o ioat_dca.o
 obj-$(CONFIG_INTEL_IOP_ADMA) += iop-adma.o
 obj-$(CONFIG_DMATEST) += dmatest.o
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
new file mode 100644
index 0000000..d5defc4
--- /dev/null
+++ b/drivers/dma/dw_dmac.c
@@ -0,0 +1,1120 @@
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
+/* #define DEBUG
+#define VERBOSE_DEBUG */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+
+/* NOTE:  DMS+SMS could be system-specific... */
+#define DWC_DEFAULT_CTLLO	(DWC_CTLL_DST_MSIZE(0)		\
+				| DWC_CTLL_SRC_MSIZE(0)		\
+				| DWC_CTLL_DMS(0)		\
+				| DWC_CTLL_SMS(1)		\
+				| DWC_CTLL_LLP_D_EN		\
+				| DWC_CTLL_LLP_S_EN)
+
+/*
+ * This is configuration-dependent and is usually a funny size like
+ * 4095. Let's round it down to the nearest power of two.
+ */
+#define DWC_MAX_LEN	2048
+
+/*
+ * This supports the Synopsis "DesignWare AHB Central DMA Controller",
+ * (DW_ahb_dmac) which is used with various AMBA 2.0 systems (not all
+ * of which use ARM any more).  See the "Databook" from Synopsis for
+ * information beyond what licensees probably provide.
+ *
+ * This "DMA Engine" framework is currently only a memcpy accelerator,
+ * so the **PRIMARY FUNCTIONALITY** of this controller is not available:
+ * hardware-synchronized DMA to/from external hardware or integrated
+ * peripherals (such as an MMC/SD controller or audio interface).
+ *
+ * The driver has currently been tested only with the Atmel AT32AP7000,
+ * which appears to be configured without writeback ... contrary to docs,
+ * unless there's a bug in dma-coherent memory allocation.
+ */
+
+#define USE_DMA_POOL
+#undef USE_FREELIST
+
+#ifdef USE_DMA_POOL
+#include <linux/dmapool.h>
+#else
+#include <linux/slab.h>
+#endif
+
+#include "dw_dmac.h"
+
+/*----------------------------------------------------------------------*/
+
+#define NR_DESCS_PER_CHANNEL	8
+
+/* Because we're not relying on writeback from the controller (it may not
+ * even be configured into the core!) we don't need to use dma_pool.  These
+ * descriptors -- and associated data -- are cacheable.  We do need to make
+ * sure their dcache entries are written back before handing them off to
+ * the controller, though.
+ */
+
+#ifdef USE_FREELIST
+#define	FREECNT		10		/* for fastpath allocations */
+#endif
+
+static struct dw_lli *
+dwc_lli_alloc(struct dw_dma_chan *dwc, gfp_t flags)
+{
+	struct dw_lli	*lli;
+
+#ifdef USE_DMA_POOL
+	dma_addr_t phys;
+
+	lli = dma_pool_alloc(dwc->lli_pool, flags, &phys);
+	if (likely(lli))
+		lli->phys = phys;
+#else
+	lli = kmem_cache_alloc(dwc->lli_pool, flags);
+	if (unlikely(!lli))
+		return NULL;
+	lli->phys = dma_map_single(dwc->dev, lli,
+			sizeof *lli, DMA_TO_DEVICE);
+#endif
+
+	return lli;
+}
+
+static inline void
+dwc_lli_free(struct dw_dma_chan *dwc, struct dw_lli *lli)
+{
+#ifdef USE_DMA_POOL
+	dma_pool_free(dwc->lli_pool, lli, lli->phys);
+#else
+	dma_unmap_single(dwc->dev, lli->phys, sizeof *lli, DMA_TO_DEVICE);
+	kmem_cache_free(dwc->lli_pool, lli);
+#endif
+}
+
+static inline void
+dwc_lli_sync_for_device(struct dw_dma_chan *dwc, struct dw_lli *lli)
+{
+#ifndef USE_DMA_POOL
+	dma_sync_single_for_device(dwc->dev, lli->phys,
+			sizeof(struct dw_lli), DMA_TO_DEVICE);
+#endif
+}
+
+static inline struct dw_lli *
+dwc_lli_get(struct dw_dma_chan *dwc, gfp_t flags)
+{
+	struct dw_lli	*lli;
+
+#ifdef USE_FREELIST
+	lli = dwc->free;
+
+	if (lli && FREECNT) {
+		dwc->free = lli->next;
+		dwc->freecnt--;
+	} else
+#endif
+		lli = dwc_lli_alloc(dwc, flags);
+
+	return lli;
+}
+
+static inline void
+dwc_lli_put(struct dw_dma_chan *dwc, struct dw_lli *lli)
+{
+#ifdef USE_FREELIST
+	if (dwc->freecnt < FREECNT) {
+		lli->ctllo = lli->ctlhi = 0;
+		lli->next = dwc->free;
+		dwc->free = lli;
+		dwc->freecnt++;
+	} else
+#endif
+		dwc_lli_free(dwc, lli);
+}
+
+static struct dw_desc *dwc_desc_get(struct dw_dma_chan *dwc)
+{
+	struct dw_desc *desc, *_desc;
+	struct dw_desc *ret = NULL;
+
+	spin_lock_bh(&dwc->lock);
+	list_for_each_entry_safe(desc, _desc, &dwc->free_list, desc_node) {
+		if (desc->slave.txd.ack) {
+			list_del(&desc->desc_node);
+			desc->slave.txd.ack = 0;
+			ret = desc;
+			break;
+		}
+	}
+	spin_unlock_bh(&dwc->lock);
+
+	return ret;
+}
+
+static void dwc_desc_put(struct dw_dma_chan *dwc, struct dw_desc *desc)
+{
+	spin_lock_bh(&dwc->lock);
+	list_add_tail(&desc->desc_node, &dwc->free_list);
+	spin_unlock_bh(&dwc->lock);
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
+	desc->slave.txd.cookie = cookie;
+
+	return cookie;
+}
+
+/*----------------------------------------------------------------------*/
+
+/* Called with dwc->lock held and bh disabled */
+static void dwc_dostart(struct dw_dma_chan *dwc, struct dw_lli *first)
+{
+	struct dw_dma	*dw = to_dw_dma(dwc->chan.device);
+
+	if (dma_readl(dw, CH_EN) & dwc->mask) {
+		dev_err(&dwc->chan.dev,
+			"BUG: Attempted to start non-idle channel\n");
+		dev_err(&dwc->chan.dev, "  new: %p last_lli: %p\n",
+			first, dwc->last_lli);
+		dev_err(&dwc->chan.dev,
+			"  first_queued: %p last_queued: %p\n",
+			dwc->first_queued, dwc->last_queued);
+		dev_err(&dwc->chan.dev,
+			"  LLP: 0x%x CTL: 0x%x:%08x\n",
+			channel_readl(dwc, LLP),
+			channel_readl(dwc, CTL_HI),
+			channel_readl(dwc, CTL_LO));
+
+		/* The tasklet will hopefully advance the queue... */
+		return;
+	}
+
+	/* ASSERT:  channel is idle */
+
+	channel_writel(dwc, LLP, first->phys);
+	channel_writel(dwc, CTL_LO,
+			DWC_CTLL_LLP_D_EN | DWC_CTLL_LLP_S_EN);
+	channel_writel(dwc, CTL_HI, 0);
+	channel_set_bit(dw, CH_EN, dwc->mask);
+}
+
+/*----------------------------------------------------------------------*/
+
+/*
+ * Move descriptors that have been queued up because the DMA
+ * controller was busy at the time of submission, to the "active"
+ * list. The caller must make sure that the DMA controller is
+ * kickstarted if necessary.
+ *
+ * Called with dwc->lock held and bh disabled.
+ */
+static void dwc_submit_queue(struct dw_dma_chan *dwc)
+{
+	dwc->last_lli = dwc->last_queued;
+	list_splice_init(&dwc->queue, dwc->active_list.prev);
+	dwc->first_queued = dwc->last_queued = NULL;
+}
+
+static void
+dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
+{
+	struct dw_lli *lli;
+
+	dev_vdbg(&dwc->chan.dev, "descriptor %u complete\n",
+			desc->slave.txd.cookie);
+
+	dwc->completed = desc->slave.txd.cookie;
+	for (lli = desc->first_lli; lli; lli = lli->next)
+		dwc_lli_put(dwc, lli);
+
+	desc->first_lli = NULL;
+	list_move(&desc->desc_node, &dwc->free_list);
+
+	/*
+	 * The API requires that no submissions are done from a
+	 * callback, so we don't need to drop the lock here
+	 */
+	if (desc->slave.txd.callback)
+		desc->slave.txd.callback(desc->slave.txd.callback_param);
+}
+
+static void dwc_complete_all(struct dw_dma *dw, struct dw_dma_chan *dwc)
+{
+	struct dw_desc *desc, *_desc;
+	LIST_HEAD(list);
+
+	/*
+	 * Submit queued descriptors ASAP, i.e. before we go through
+	 * the completed ones.
+	 */
+	list_splice_init(&dwc->active_list, &list);
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
+	dwc->last_lli = NULL;
+	if (dwc->first_queued) {
+		dwc_dostart(dwc, dwc->first_queued);
+		dwc_submit_queue(dwc);
+	}
+
+	list_for_each_entry_safe(desc, _desc, &list, desc_node)
+		dwc_descriptor_complete(dwc, desc);
+}
+
+static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
+{
+	dma_addr_t llp;
+	struct dw_desc *desc, *_desc;
+	struct dw_lli *lli, *next;
+	u32 status_xfer;
+
+	/*
+	 * Clear block interrupt flag before scanning so that we don't
+	 * miss any, and read LLP before RAW_XFER to ensure it is
+	 * valid if we decide to scan the list.
+	 */
+	dma_writel(dw, CLEAR_BLOCK, dwc->mask);
+	llp = channel_readl(dwc, LLP);
+	status_xfer = dma_readl(dw, RAW_XFER);
+
+	if (status_xfer & dwc->mask) {
+		/* Everything we've submitted is done */
+		dma_writel(dw, CLEAR_XFER, dwc->mask);
+		dwc_complete_all(dw, dwc);
+		return;
+	}
+
+	dev_vdbg(&dwc->chan.dev, "scan_descriptors: llp=0x%x\n", llp);
+
+	list_for_each_entry_safe(desc, _desc, &dwc->active_list, desc_node) {
+		for (lli = desc->first_lli ; lli; lli = next) {
+			next = lli->next;
+
+			dev_vdbg(&dwc->chan.dev, "  lli 0x%x done?\n",
+					lli->phys);
+			/*
+			 * The last descriptor can't be done because
+			 * the controller isn't idle.
+			 */
+			if (!next || next->phys == llp)
+				return;
+
+			/* Last LLI in a this descriptor? */
+			if (lli->last)
+				break;
+		}
+
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
+	dwc->last_lli = NULL;
+	if (dwc->first_queued) {
+		dwc_dostart(dwc, dwc->first_queued);
+		dwc_submit_queue(dwc);
+	}
+}
+
+static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
+{
+	struct dw_desc *bad_desc;
+	struct dw_desc *next_desc;
+	struct dw_lli *lli;
+
+	dwc_scan_descriptors(dw, dwc);
+
+	/*
+	 * The descriptor currently at the head of the active list is
+	 * borked. Since we don't have any way to report errors, we'll
+	 * just have to scream loudly and try to carry on.
+	 */
+	bad_desc = list_entry(dwc->active_list.next,
+			struct dw_desc, desc_node);
+	list_del_init(&bad_desc->desc_node);
+	if (dwc->first_queued)
+		dwc_submit_queue(dwc);
+
+	/* Clear the error flag and try to restart the controller */
+	dma_writel(dw, CLEAR_ERROR, dwc->mask);
+	if (!list_empty(&dwc->active_list)) {
+		next_desc = list_entry(dwc->active_list.next,
+				struct dw_desc, desc_node);
+		dwc_dostart(dwc, next_desc->first_lli);
+	}
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
+			"  cookie: %d\n", bad_desc->slave.txd.cookie);
+	for (lli = bad_desc->first_lli; lli; lli = lli->next)
+		dev_printk(KERN_CRIT, &dwc->chan.dev,
+			"  LLI: s/0x%x d/0x%x l/0x%x c/0x%x:%x\n",
+			lli->sar, lli->dar, lli->llp,
+			lli->ctlhi, lli->ctllo);
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
+	status_block = dma_readl(dw, RAW_BLOCK);
+	status_xfer = dma_readl(dw, RAW_BLOCK);
+	status_err = dma_readl(dw, RAW_ERROR);
+
+	dev_dbg(dw->dma.dev, "tasklet: status_block=%x status_err=%x\n",
+			status_block, status_err);
+
+	for (i = 0; i < NDMA; i++) {
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
+	channel_set_bit(dw, MASK_XFER, (1 << NDMA) - 1);
+	channel_set_bit(dw, MASK_BLOCK, (1 << NDMA) - 1);
+	channel_set_bit(dw, MASK_ERROR, (1 << NDMA) - 1);
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
+	channel_clear_bit(dw, MASK_XFER, (1 << NDMA) - 1);
+	channel_clear_bit(dw, MASK_BLOCK, (1 << NDMA) - 1);
+	channel_clear_bit(dw, MASK_ERROR, (1 << NDMA) - 1);
+
+	status = dma_readl(dw, STATUS_INT);
+	if (status) {
+		dev_err(dw->dma.dev,
+			"BUG: Unexpected interrupts pending: 0x%x\n",
+			status);
+
+		/* Try to recover */
+		channel_clear_bit(dw, MASK_XFER, (1 << 8) - 1);
+		channel_clear_bit(dw, MASK_BLOCK, (1 << 8) - 1);
+		channel_clear_bit(dw, MASK_SRC_TRAN, (1 << 8) - 1);
+		channel_clear_bit(dw, MASK_DST_TRAN, (1 << 8) - 1);
+		channel_clear_bit(dw, MASK_ERROR, (1 << 8) - 1);
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
+	struct dw_lli		*lli;
+	dma_cookie_t		cookie;
+
+	/* Make sure all descriptors are written to RAM */
+	for (lli = desc->first_lli; lli; lli = lli->next) {
+		dev_vdbg(&dwc->chan.dev,
+				"tx_submit: %x: s/%x d/%x p/%x h/%x l/%x\n",
+				lli->phys, lli->sar, lli->dar, lli->llp,
+				lli->ctlhi, lli->ctllo);
+		dwc_lli_sync_for_device(dwc, lli);
+	}
+
+	spin_lock_bh(&dwc->lock);
+	cookie = dwc_assign_cookie(dwc, desc);
+
+	/*
+	 * REVISIT: We should attempt to chain as many descriptors as
+	 * possible, perhaps even appending to those already submitted
+	 * for DMA. But this is hard to do in a race-free manner.
+	 */
+	if (dwc->last_queued || dwc->last_lli) {
+		dev_vdbg(&tx->chan->dev, "tx_submit: queued %u\n",
+				desc->slave.txd.cookie);
+
+		list_add_tail(&desc->desc_node, &dwc->queue);
+		dwc->last_queued = desc->last_lli;
+		if (!dwc->first_queued)
+			dwc->first_queued = desc->first_lli;
+	} else {
+		dev_vdbg(&tx->chan->dev, "tx_submit: started %u\n",
+				desc->slave.txd.cookie);
+
+		dwc_dostart(dwc, desc->first_lli);
+		list_add_tail(&desc->desc_node, &dwc->active_list);
+		dwc->last_lli = desc->last_lli;
+	}
+
+	spin_unlock_bh(&dwc->lock);
+
+	return cookie;
+}
+
+static struct dw_desc *dwc_prep_descriptor(struct dw_dma_chan *dwc,
+		u32 ctllo, dma_addr_t dest, dma_addr_t src,
+		size_t len, unsigned long flags)
+{
+	struct dma_chan		*chan = &dwc->chan;
+	struct dw_desc		*desc;
+	struct dw_lli		*prev, *lli;
+	unsigned int		offset;
+	size_t			block_len;
+
+	if (unlikely(!len))
+		return NULL;
+
+	desc = dwc_desc_get(dwc);
+	if (!desc)
+		return NULL;
+
+	dev_vdbg(&chan->dev, "  got descriptor %p\n", desc);
+
+	/*
+	 * Use block chaining, and "transfer type 10" with source and
+	 * destination addresses updated through LLP.  Terminate using
+	 * a dummy descriptor with invalid LLP.
+	 *
+	 * IMPORTANT:  here we assume the core is configured with each
+	 * channel supporting dma descriptor lists!
+	 */
+	prev = NULL;
+	for (offset = 0; offset < len; offset += block_len) {
+		size_t		max_len = DWC_MAX_LEN;
+
+		lli = dwc_lli_get(dwc, GFP_ATOMIC);
+		if (!lli)
+			goto err_lli_get;
+
+		block_len = min(len - offset, max_len);
+
+		if (!prev) {
+			desc->first_lli = lli;
+		} else {
+			prev->last = 0;
+			prev->llp = lli->phys;
+			prev->next = lli;
+		}
+		lli->sar = src + offset;
+		lli->dar = dest + offset;
+		lli->ctllo = ctllo;
+		lli->ctlhi = block_len;
+
+		prev = lli;
+
+		dev_vdbg(&chan->dev,
+			"  lli %p: src 0x%x dst 0x%x len %zu phys 0x%x\n",
+			lli, src, dest, block_len, lli->phys);
+	}
+
+	if (flags & DMA_PREP_INTERRUPT)
+		/* Trigger interrupt after last block */
+		prev->ctllo |= DWC_CTLL_INT_EN;
+
+	prev->next = NULL;
+	prev->llp = 0;
+	prev->last = 1;
+	desc->last_lli = prev;
+
+	return desc;
+
+err_lli_get:
+	for (lli = desc->first_lli; lli; lli = lli->next)
+		dwc_lli_put(dwc, lli);
+	dwc_desc_put(dwc, desc);
+	return NULL;
+}
+
+static struct dma_async_tx_descriptor *
+dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
+		size_t len, unsigned long flags)
+{
+	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	struct dw_desc		*desc;
+	u32			ctllo;
+
+	dev_vdbg(&chan->dev, "prep_dma_memcpy\n");
+
+	if (unlikely(!len))
+		return NULL;
+
+	/* FIXME: Try to use wider transfers when possible */
+	ctllo = DWC_DEFAULT_CTLLO
+			| DWC_CTLL_DST_WIDTH(0)
+			| DWC_CTLL_SRC_WIDTH(0)
+			| DWC_CTLL_DST_INC
+			| DWC_CTLL_SRC_INC
+			| DWC_CTLL_FC_M2M;
+
+	desc = dwc_prep_descriptor(dwc, ctllo, dest, src, len, flags);
+
+	return desc ? &desc->slave.txd : NULL;
+}
+
+static struct dma_slave_descriptor *dwc_prep_slave(struct dma_chan *chan,
+		dma_addr_t mem_addr,
+		enum dma_slave_direction direction,
+		enum dma_slave_width reg_width,
+		size_t len, unsigned long flags)
+{
+	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	struct dw_desc		*desc;
+	u32			ctllo;
+	dma_addr_t		dest, src;
+
+	dev_vdbg(&chan->dev, "prep_dma_slave\n");
+
+	/*
+	 * Sanity checks. Don't know if the alignment requirements
+	 * are always valid though...
+	 */
+	BUG_ON(!dwc->slave);
+	BUG_ON(mem_addr & ((1 << reg_width) - 1));
+	BUG_ON(len & ((1 << reg_width) - 1));
+
+	len >>= reg_width;
+	ctllo = DWC_DEFAULT_CTLLO
+		| DWC_CTLL_DST_WIDTH(reg_width)
+		| DWC_CTLL_SRC_WIDTH(reg_width);
+
+	switch (direction) {
+	case DMA_SLAVE_TO_MEMORY:
+		ctllo |= (DWC_CTLL_DST_INC
+				| DWC_CTLL_SRC_FIX
+				| DWC_CTLL_FC_P2M);
+		src = dwc->slave->rx_reg;
+		dest = mem_addr;
+		break;
+	case DMA_SLAVE_FROM_MEMORY:
+		ctllo |= (DWC_CTLL_DST_FIX
+				| DWC_CTLL_SRC_INC
+				| DWC_CTLL_FC_M2P);
+		src = mem_addr;
+		dest = dwc->slave->tx_reg;
+		break;
+	default:
+		return NULL;
+	}
+
+	desc = dwc_prep_descriptor(dwc, ctllo, dest, src, len, flags);
+
+	return desc ? &desc->slave : NULL;
+}
+
+static void dwc_terminate_all(struct dma_chan *chan)
+{
+	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	struct dw_dma		*dw = to_dw_dma(chan->device);
+
+	/*
+	 * This is only called when something went wrong elsewhere, so
+	 * we don't really care about the data. Just disable the
+	 * channel. We still have to poll the channel enable bit due
+	 * to AHB/HSB limitations.
+	 */
+	channel_clear_bit(dw, CH_EN, dwc->mask);
+
+	while (dma_readl(dw, CH_EN) & dwc->mask)
+		cpu_relax();
+}
+
+static void dwc_dependency_added(struct dma_chan *chan)
+{
+	/* FIXME: What is this hook supposed to do? */
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
+	if (dwc->last_queued)
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
+	int			i;
+	u32			cfghi;
+
+	dev_vdbg(&chan->dev, "alloc_chan_resources\n");
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
+
+	slave = client->slave;
+	if (slave) {
+		BUG_ON(slave->rx_handshake_id > 15);
+		BUG_ON(slave->tx_handshake_id > 15);
+
+		dwc->slave = slave;
+		cfghi |= DWC_CFGH_SRC_PER(slave->rx_handshake_id);
+		cfghi |= DWC_CFGH_DST_PER(slave->tx_handshake_id);
+	} else {
+		dwc->slave = NULL;
+	}
+
+	channel_writel(dwc, CFG_LO, 0);
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
+		dma_async_tx_descriptor_init(&desc->slave.txd, chan);
+		desc->slave.txd.ack = 1;
+		desc->slave.txd.tx_submit = dwc_tx_submit;
+
+		dev_vdbg(&chan->dev, "  adding descriptor %p\n", desc);
+
+		spin_lock_bh(&dwc->lock);
+		i = ++dwc->descs_allocated;
+		list_add_tail(&desc->desc_node, &dwc->free_list);
+	}
+
+	/* Enable interrupts */
+	channel_set_bit(dw, MASK_XFER, dwc->mask);
+	channel_set_bit(dw, MASK_BLOCK, dwc->mask);
+	channel_set_bit(dw, MASK_ERROR, dwc->mask);
+
+	spin_unlock_bh(&dwc->lock);
+
+	dev_vdbg(&chan->dev,
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
+	dev_vdbg(&chan->dev, "free_chan_resources (descs allocated=%u)\n",
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
+	dwc->slave = NULL;
+
+	/* Disable interrupts */
+	channel_clear_bit(dw, MASK_XFER, dwc->mask);
+	channel_clear_bit(dw, MASK_BLOCK, dwc->mask);
+	channel_clear_bit(dw, MASK_ERROR, dwc->mask);
+
+	spin_unlock_bh(&dwc->lock);
+
+	list_for_each_entry_safe(desc, _desc, &list, desc_node) {
+		dev_vdbg(&chan->dev, "  freeing descriptor %p\n", desc);
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
+	channel_clear_bit(dw, MASK_XFER, (1 << NDMA) - 1);
+	channel_clear_bit(dw, MASK_BLOCK, (1 << NDMA) - 1);
+	channel_clear_bit(dw, MASK_SRC_TRAN, (1 << NDMA) - 1);
+	channel_clear_bit(dw, MASK_DST_TRAN, (1 << NDMA) - 1);
+	channel_clear_bit(dw, MASK_ERROR, (1 << NDMA) - 1);
+
+	while (dma_readl(dw, CFG) & DW_CFG_DMA_EN)
+		cpu_relax();
+}
+
+static int __init dw_probe(struct platform_device *pdev)
+{
+	struct resource		*io;
+	struct dw_dma		*dw;
+#ifdef USE_DMA_POOL
+	struct dma_pool		*lli_pool;
+#else
+	struct kmem_cache	*lli_pool;
+#endif
+	int			irq;
+	int			err;
+	int			i;
+
+	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!io)
+		return -EINVAL;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	/* FIXME platform_data holds NDMA.  Use that to adjust the size
+	 * of this allocation to match the silicon, and channel init.
+	 */
+
+	dw = kzalloc(sizeof *dw, GFP_KERNEL);
+	if (!dw)
+		return -ENOMEM;
+
+	if (request_mem_region(io->start, DW_REGLEN,
+			pdev->dev.driver->name) == 0) {
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
+#ifdef USE_DMA_POOL
+	lli_pool = dma_pool_create(pdev->dev.bus_id, &pdev->dev,
+			sizeof(struct dw_lli), 4, 0);
+#else
+	lli_pool = kmem_cache_create(pdev->dev.bus_id,
+			sizeof(struct dw_lli), 4, 0, NULL);
+#endif
+	if (!lli_pool) {
+		err = -ENOMEM;
+		goto err_dma_pool;
+	}
+
+	dw->lli_pool = lli_pool;
+	platform_set_drvdata(pdev, dw);
+
+	tasklet_init(&dw->tasklet, dw_dma_tasklet, (unsigned long)dw);
+
+	INIT_LIST_HEAD(&dw->dma.channels);
+	for (i = 0; i < NDMA; i++, dw->dma.chancnt++) {
+		struct dw_dma_chan	*dwc = &dw->chan[i];
+
+		dwc->chan.device = &dw->dma;
+		dwc->chan.cookie = dwc->completed = 1;
+		dwc->chan.chan_id = i;
+		list_add_tail(&dwc->chan.device_node, &dw->dma.channels);
+
+		dwc->ch_regs = dw->regs + DW_DMAC_CHAN_BASE(i);
+		dwc->lli_pool = lli_pool;
+		spin_lock_init(&dwc->lock);
+		dwc->mask = 1 << i;
+
+		/* FIXME dmaengine API bug:  the dma_device isn't coupled
+		 * to the underlying hardware; so neither is the dma_chan.
+		 *
+		 * Workaround:  dwc->dev instead of dwc->chan.cdev.dev
+		 * (or eventually dwc->chan.dev.parent).
+		 */
+		dwc->dev = &pdev->dev;
+
+		INIT_LIST_HEAD(&dwc->active_list);
+		INIT_LIST_HEAD(&dwc->queue);
+		INIT_LIST_HEAD(&dwc->free_list);
+
+		channel_clear_bit(dw, CH_EN, dwc->mask);
+	}
+
+	/* Clear/disable all interrupts on all channels. */
+	dma_writel(dw, CLEAR_XFER, (1 << NDMA) - 1);
+	dma_writel(dw, CLEAR_BLOCK, (1 << NDMA) - 1);
+	dma_writel(dw, CLEAR_SRC_TRAN, (1 << NDMA) - 1);
+	dma_writel(dw, CLEAR_DST_TRAN, (1 << NDMA) - 1);
+	dma_writel(dw, CLEAR_ERROR, (1 << NDMA) - 1);
+
+	channel_clear_bit(dw, MASK_XFER, (1 << NDMA) - 1);
+	channel_clear_bit(dw, MASK_BLOCK, (1 << NDMA) - 1);
+	channel_clear_bit(dw, MASK_SRC_TRAN, (1 << NDMA) - 1);
+	channel_clear_bit(dw, MASK_DST_TRAN, (1 << NDMA) - 1);
+	channel_clear_bit(dw, MASK_ERROR, (1 << NDMA) - 1);
+
+	dma_cap_set(DMA_MEMCPY, dw->dma.cap_mask);
+	dma_cap_set(DMA_SLAVE, dw->dma.cap_mask);
+	dw->dma.dev = &pdev->dev;
+	dw->dma.device_alloc_chan_resources = dwc_alloc_chan_resources;
+	dw->dma.device_free_chan_resources = dwc_free_chan_resources;
+
+	dw->dma.device_prep_dma_memcpy = dwc_prep_dma_memcpy;
+
+	dw->dma.device_prep_slave = dwc_prep_slave;
+	dw->dma.device_terminate_all = dwc_terminate_all;
+
+	dw->dma.device_dependency_added = dwc_dependency_added;
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
+err_dma_pool:
+	free_irq(irq, dw);
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
+	dev_dbg(&pdev->dev, "dw_remove\n");
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
+#ifdef USE_DMA_POOL
+	dma_pool_destroy(dw->lli_pool);
+#else
+	kmem_cache_destroy(dw->lli_pool);
+#endif
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
+	dev_dbg(&pdev->dev, "dw_remove done\n");
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
+	BUILD_BUG_ON(NDMA > 8);
+	return platform_driver_probe(&dw_driver, dw_probe);
+}
+device_initcall(dw_init);
+
+static void __exit dw_exit(void)
+{
+	platform_driver_unregister(&dw_driver);
+}
+module_exit(dw_exit);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/dma/dw_dmac.h b/drivers/dma/dw_dmac.h
new file mode 100644
index 0000000..2f31656
--- /dev/null
+++ b/drivers/dma/dw_dmac.h
@@ -0,0 +1,256 @@
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
+/* REVISIT Synopsys provides a C header; use symbols from there instead? */
+
+/* per-channel registers */
+#define DW_DMAC_CHAN_SAR	0x000
+#define DW_DMAC_CHAN_DAR	0x008
+#define DW_DMAC_CHAN_LLP	0x010
+#define DW_DMAC_CHAN_CTL_LO	0x018
+#	define DWC_CTLL_INT_EN		(1 << 0)	/* irqs enabled? */
+#	define DWC_CTLL_DST_WIDTH(n)	((n)<<1)	/* bytes per element */
+#	define DWC_CTLL_SRC_WIDTH(n)	((n)<<4)
+#	define DWC_CTLL_DST_INC		(0<<7)		/* DAR update/not */
+#	define DWC_CTLL_DST_DEC		(1<<7)
+#	define DWC_CTLL_DST_FIX		(2<<7)
+#	define DWC_CTLL_SRC_INC		(0<<7)		/* SAR update/not */
+#	define DWC_CTLL_SRC_DEC		(1<<9)
+#	define DWC_CTLL_SRC_FIX		(2<<9)
+#	define DWC_CTLL_DST_MSIZE(n)	((n)<<11)	/* burst, #elements */
+#	define DWC_CTLL_SRC_MSIZE(n)	((n)<<14)
+#	define DWC_CTLL_S_GATH_EN	(1 << 17)	/* src gather, !FIX */
+#	define DWC_CTLL_D_SCAT_EN	(1 << 18)	/* dst scatter, !FIX */
+#	define DWC_CTLL_FC_M2M		(0 << 20)	/* mem-to-mem */
+#	define DWC_CTLL_FC_M2P		(1 << 20)	/* mem-to-periph */
+#	define DWC_CTLL_FC_P2M		(2 << 20)	/* periph-to-mem */
+#	define DWC_CTLL_FC_P2P		(3 << 20)	/* periph-to-periph */
+	/* plus 4 transfer types for peripheral-as-flow-controller */
+#	define DWC_CTLL_DMS(n)		((n)<<23)
+#	define DWC_CTLL_SMS(n)		((n)<<25)
+#	define DWC_CTLL_LLP_D_EN	(1 << 27)	/* dest block chain */
+#	define DWC_CTLL_LLP_S_EN	(1 << 28)	/* src block chain */
+#define DW_DMAC_CHAN_CTL_HI	0x01c
+#	define DWC_CTLH_DONE		0x00001000
+#	define DWC_CTLH_BLOCK_TS_MASK	0x00000fff
+#define DW_DMAC_CHAN_SSTAT	0x020
+#define DW_DMAC_CHAN_DSTAT	0x028
+#define DW_DMAC_CHAN_SSTATAR	0x030
+#define DW_DMAC_CHAN_DSTATAR	0x038
+#define DW_DMAC_CHAN_CFG_LO	0x040
+#	define DWC_CFGL_PRIO(x)		((x) << 5)	/* priority */
+#	define DWC_CFGL_CH_SUSP		(1 << 8)	/* pause xfer */
+#	define DWC_CFGL_FIFO_EMPTY	(1 << 9)	/* pause xfer */
+#	define DWC_CFGL_HS_DST		(1 << 10)	/* handshake w/dst */
+#	define DWC_CFGL_HS_SRC		(1 << 11)	/* handshake w/src */
+#	define DWC_CFGL_LOCK_CH_XFER	(0 << 12)	/* scope of LOCK_CH */
+#	define DWC_CFGL_LOCK_CH_BLOCK	(1 << 12)
+#	define DWC_CFGL_LOCK_CH_XACT	(2 << 12)
+#	define DWC_CFGL_LOCK_BUS_XFER	(0 << 14)	/* scope of LOCK_BUS */
+#	define DWC_CFGL_LOCK_BUS_BLOCK	(1 << 14)
+#	define DWC_CFGL_LOCK_BUS_XACT	(2 << 14)
+#	define DWC_CFGL_LOCK_CH		(1 << 15)	/* channel lockout */
+#	define DWC_CFGL_LOCK_BUS	(1 << 16)	/* busmaster lockout */
+#	define DWC_CFGL_HS_DST_POL	(1 << 18)
+#	define DWC_CFGL_HS_SRC_POL	(1 << 19)
+#	define DWC_CFGL_MAX_BURST(x)	((x) << 20)
+#	define DWC_CFGL_RELOAD_SAR	(1 << 30)
+#	define DWC_CFGL_RELOAD_DAR	(1 << 31)
+#define DW_DMAC_CHAN_CFG_HI	0x044
+#	define DWC_CFGH_FCMODE		(1 << 0)
+#	define DWC_CFGH_FIFO_MODE	(1 << 1)
+#	define DWC_CFGH_PROTCTL(x)	((x) << 2)
+#	define DWC_CFGH_DS_UPD_EN	(1 << 5)
+#	define DWC_CFGH_SS_UPD_EN	(1 << 6)
+#	define DWC_CFGH_SRC_PER(x)	((x) << 7)
+#	define DWC_CFGH_DST_PER(x)	((x) << 11)
+#define DW_DMAC_CHAN_SGR	0x048
+#	define DWC_SGR_SGI(x)		((x) << 0)
+#	define DWC_SGR_SGC(x)		((x) << 20)
+#define DW_DMAC_CHAN_DSR	0x050
+#	define DWC_DSR_DSI(x)		((x) << 0)
+#	define DWC_DSR_DSC(x)		((x) << 20)
+
+#define	DW_DMAC_CHAN_BASE(n)	((n)*0x58)
+
+/* irq handling */
+#define DW_DMAC_RAW_XFER	0x2c0		/* r */
+#define DW_DMAC_RAW_BLOCK	0x2c8
+#define DW_DMAC_RAW_SRC_TRAN	0x2d0
+#define DW_DMAC_RAW_DST_TRAN	0x2d8
+#define DW_DMAC_RAW_ERROR	0x2e0
+
+#define DW_DMAC_STATUS_XFER	0x2e8		/* r (raw & mask) */
+#define DW_DMAC_STATUS_BLOCK	0x2f0
+#define DW_DMAC_STATUS_SRC_TRAN	0x2f8
+#define DW_DMAC_STATUS_DST_TRAN	0x300
+#define DW_DMAC_STATUS_ERROR	0x308
+
+#define DW_DMAC_MASK_XFER	0x310		/* rw (set = irq enabled) */
+#define DW_DMAC_MASK_BLOCK	0x318
+#define DW_DMAC_MASK_SRC_TRAN	0x320
+#define DW_DMAC_MASK_DST_TRAN	0x328
+#define DW_DMAC_MASK_ERROR	0x330
+
+#define DW_DMAC_CLEAR_XFER	0x338		/* w (ack, affects "raw") */
+#define DW_DMAC_CLEAR_BLOCK	0x340
+#define DW_DMAC_CLEAR_SRC_TRAN	0x348
+#define DW_DMAC_CLEAR_DST_TRAN	0x350
+#define DW_DMAC_CLEAR_ERROR	0x358
+
+#define DW_DMAC_STATUS_INT	0x360		/* r */
+
+/* software handshaking */
+#define	DW_DMAC_REQ_SRC		0x368		/* rw */
+#define	DW_DMAC_REQ_DST		0x370
+#define	DW_DMAC_SGL_REQ_SRC	0x378
+#define	DW_DMAC_SGL_REQ_DST	0x380
+#define	DW_DMAC_LAST_SRC	0x388
+#define	DW_DMAC_LAST_DST	0x390
+
+/* miscellaneous */
+#define DW_DMAC_CFG		0x398		/* rw */
+#	define DW_CFG_DMA_EN		(1 << 0)
+#define DW_DMAC_CH_EN		0x3a0
+
+#define DW_DMAC_ID		0x3a8		/* r */
+#define DW_DMAC_TEST		0x3b0		/* rw */
+
+/* optional encoded params, 0x3c8..0x3 */
+
+#define DW_REGLEN		0x400
+
+
+/* How many channels ... potentially, up to 8 */
+#ifdef CONFIG_CPU_AT32AP7000
+#define	NDMA	3
+#endif
+
+#ifndef NDMA
+/* REVISIT want a better (static) solution than this */
+#warning system unrecognized, assuming max NDMA=8
+#define	NDMA	8
+#endif
+
+struct dw_dma_chan {
+	struct dma_chan		chan;
+	void __iomem		*ch_regs;
+#ifdef USE_DMA_POOL
+	struct dma_pool		*lli_pool;
+#else
+	struct kmem_cache	*lli_pool;
+#endif
+	struct device		*dev;
+
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
+	struct dw_lli		*last_lli;
+	struct dw_lli		*first_queued;
+	struct dw_lli		*last_queued;
+
+	struct dma_slave	*slave;
+
+	unsigned int		descs_allocated;
+};
+
+/* REVISIT these register access macros cause inefficient code: the st.w
+ * and ld.w displacements are all zero, never DW_DMAC_ constants embedded
+ * in the instructions.  GCC 4.0.2-atmel.0.99.2 issue?  Struct access is
+ * as efficient as one would expect...
+ */
+
+#define channel_readl(dwc, name) \
+	__raw_readl((dwc)->ch_regs + DW_DMAC_CHAN_##name)
+#define channel_writel(dwc, name, val) \
+	__raw_writel((val), (dwc)->ch_regs + DW_DMAC_CHAN_##name)
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
+#ifdef USE_DMA_POOL
+	struct dma_pool		*lli_pool;
+#else
+	struct kmem_cache	*lli_pool;
+#endif
+	struct tasklet_struct	tasklet;
+	struct clk		*clk;
+	struct dw_dma_chan	chan[NDMA];
+};
+
+#define dma_readl(dw, name) \
+	__raw_readl((dw)->regs + DW_DMAC_##name)
+#define dma_writel(dw, name, val) \
+	__raw_writel((val), (dw)->regs + DW_DMAC_##name)
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
+
+/* LLI == Linked List Item; a.k.a. DMA block descriptor */
+struct dw_lli {
+	/* FIRST values the hardware uses */
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
+
+	/* THEN values for driver housekeeping */
+	struct dw_lli	*next;
+	dma_addr_t	phys;
+	int		last;
+};
+
+struct dw_desc {
+	struct dw_lli	*first_lli;
+	struct dw_lli	*last_lli;
+
+	struct dma_slave_descriptor slave;
+	struct list_head desc_node;
+};
+
+static inline struct dw_desc *
+txd_to_dw_desc(struct dma_async_tx_descriptor *txd)
+{
+	return container_of(txd, struct dw_desc, slave.txd);
+}
+
+static inline struct dw_desc *
+sd_to_dw_desc(struct dma_slave_descriptor *sd)
+{
+	return container_of(sd, struct dw_desc, slave);
+}
diff --git a/include/asm-avr32/arch-at32ap/at32ap700x.h b/include/asm-avr32/arch-at32ap/at32ap700x.h
index 99684d6..064f5a9 100644
--- a/include/asm-avr32/arch-at32ap/at32ap700x.h
+++ b/include/asm-avr32/arch-at32ap/at32ap700x.h
@@ -32,4 +32,20 @@
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
-- 
1.5.3.8

