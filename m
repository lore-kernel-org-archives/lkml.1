Return-Path: <linux-kernel-owner+w=401wt.eu-S1755589AbZDFPza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbZDFPza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbZDFPyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:54:51 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:63584 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbZDFPys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:54:48 -0400
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: linux-mips@linux-mips.org
Cc: ralf@linux-mips.org, dan.j.williams@intel.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] DMA: TXx9 Soc DMA Controller driver (v2)
Date: Tue,  7 Apr 2009 00:54:47 +0900
Message-Id: <1239033288-3086-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the integrated DMAC of the TXx9 family.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
Changes since v1:
* fold long lines
* call dma_run_dependencies()
* add a comment for DMA_CTRL_ACK
* update copyright year
* simplify reservation of memcpy channel
* create a dma_device instance per channel

 arch/mips/include/asm/txx9/dmac.h |   48 ++
 drivers/dma/Kconfig               |    8 +
 drivers/dma/Makefile              |    1 +
 drivers/dma/txx9dmac.c            | 1615 +++++++++++++++++++++++++++++++++++++
 4 files changed, 1672 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/include/asm/txx9/dmac.h
 create mode 100644 drivers/dma/txx9dmac.c

diff --git a/arch/mips/include/asm/txx9/dmac.h b/arch/mips/include/asm/txx9/dmac.h
new file mode 100644
index 0000000..a87d1c3
--- /dev/null
+++ b/arch/mips/include/asm/txx9/dmac.h
@@ -0,0 +1,48 @@
+/*
+ * TXx9 SoC DMA Controller
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_TXX9_DMAC_H
+#define __ASM_TXX9_DMAC_H
+
+#include <linux/dmaengine.h>
+
+#define TXX9_DMA_MAX_NR_CHANNELS	4
+
+/**
+ * struct txx9dmac_platform_data - Controller configuration parameters
+ * @memcpy_chan: Channel used for DMA_MEMCPY
+ * @have_64bit_regs: DMAC have 64 bit registers
+ */
+struct txx9dmac_platform_data {
+	int	memcpy_chan;
+	bool	have_64bit_regs;
+};
+
+/**
+ * struct txx9dmac_chan_platform_data - Channel configuration parameters
+ * @dmac_dev: A platform device for DMAC
+ */
+struct txx9dmac_chan_platform_data {
+	struct platform_device *dmac_dev;
+};
+
+/**
+ * struct txx9dmac_slave - Controller-specific information about a slave
+ * @tx_reg: physical address of data register used for
+ *	memory-to-peripheral transfers
+ * @rx_reg: physical address of data register used for
+ *	peripheral-to-memory transfers
+ * @reg_width: peripheral register width
+ */
+struct txx9dmac_slave {
+	u64		tx_reg;
+	u64		rx_reg;
+	unsigned int	reg_width;
+};
+
+#endif /* __ASM_TXX9_DMAC_H */
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 48ea59e..3f7b09f 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -81,6 +81,14 @@ config MX3_IPU_IRQS
 	  To avoid bloating the irq_desc[] array we allocate a sufficient
 	  number of IRQ slots and map them dynamically to specific sources.
 
+config TXX9_DMAC
+	tristate "Toshiba TXx9 SoC DMA support"
+	depends on MACH_TX49XX || MACH_TX39XX
+	select DMA_ENGINE
+	help
+	  Support the TXx9 SoC internal DMA controller.  This can be
+	  integrated in chips such as the Toshiba TX4927/38/39.
+
 config DMA_ENGINE
 	bool
 
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 2e5dc96..a0b6564 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_FSL_DMA) += fsldma.o
 obj-$(CONFIG_MV_XOR) += mv_xor.o
 obj-$(CONFIG_DW_DMAC) += dw_dmac.o
 obj-$(CONFIG_MX3_IPU) += ipu/
+obj-$(CONFIG_TXX9_DMAC) += txx9dmac.o
diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
new file mode 100644
index 0000000..ce67602
--- /dev/null
+++ b/drivers/dma/txx9dmac.c
@@ -0,0 +1,1615 @@
+/*
+ * Driver for the TXx9 SoC DMA Controller
+ *
+ * Copyright (C) 2009 Atsushi Nemoto
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/delay.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/scatterlist.h>
+#include <asm/txx9/dmac.h>
+
+/*
+ * Design Notes:
+ *
+ * This DMAC have four channels and one FIFO buffer.  Each channel can
+ * be configured for memory-memory or device-memory transfer, but only
+ * one channel can do alignment-free memory-memory transfer at a time
+ * while the channel should occupy the FIFO buffer for effective
+ * transfers.
+ *
+ * Instead of dynamically assign the FIFO buffer to channels, I chose
+ * make one dedicated channel for memory-memory transfer.  The
+ * dedicated channel is public.  Other channels are private and used
+ * for slave transfer.  Some devices in the SoC are wired to certain
+ * DMA channel.
+ */
+
+#ifdef CONFIG_MACH_TX49XX
+#define TXX9_DMA_MAY_HAVE_64BIT_REGS
+#define TXX9_DMA_HAVE_CCR_LE
+#define TXX9_DMA_HAVE_SMPCHN
+#define TXX9_DMA_HAVE_IRQ_PER_CHAN
+#endif
+
+#ifdef TXX9_DMA_HAVE_SMPCHN
+#define TXX9_DMA_USE_SIMPLE_CHAIN
+#endif
+
+/*
+ * Redefine this macro to handle differences between 32- and 64-bit
+ * addressing, big vs. little endian, etc.
+ */
+#ifdef __BIG_ENDIAN
+#define TXX9_DMA_REG32(name)		u32 __pad_##name; u32 name
+#else
+#define TXX9_DMA_REG32(name)		u32 name; u32 __pad_##name
+#endif
+
+/* Hardware register definitions. */
+struct txx9dmac_cregs {
+#if defined(CONFIG_32BIT) && !defined(CONFIG_64BIT_PHYS_ADDR)
+	TXX9_DMA_REG32(CHAR);	/* Chain Address Register */
+#else
+	u64 CHAR;		/* Chain Address Register */
+#endif
+	u64 SAR;		/* Source Address Register */
+	u64 DAR;		/* Destination Address Register */
+	TXX9_DMA_REG32(CNTR);	/* Count Register */
+	TXX9_DMA_REG32(SAIR);	/* Source Address Increment Register */
+	TXX9_DMA_REG32(DAIR);	/* Destination Address Increment Register */
+	TXX9_DMA_REG32(CCR);	/* Channel Control Register */
+	TXX9_DMA_REG32(CSR);	/* Channel Status Register */
+};
+struct txx9dmac_cregs32 {
+	u32 CHAR;
+	u32 SAR;
+	u32 DAR;
+	u32 CNTR;
+	u32 SAIR;
+	u32 DAIR;
+	u32 CCR;
+	u32 CSR;
+};
+
+struct txx9dmac_regs {
+	/* per-channel registers */
+	struct txx9dmac_cregs	CHAN[TXX9_DMA_MAX_NR_CHANNELS];
+	u64	__pad[9];
+	u64	MFDR;		/* Memory Fill Data Register */
+	TXX9_DMA_REG32(MCR);	/* Master Control Register */
+};
+struct txx9dmac_regs32 {
+	struct txx9dmac_cregs32	CHAN[TXX9_DMA_MAX_NR_CHANNELS];
+	u32	__pad[9];
+	u32	MFDR;
+	u32	MCR;
+};
+
+/* bits for MCR */
+#define TXX9_DMA_MCR_EIS(ch)	(0x10000000<<(ch))
+#define TXX9_DMA_MCR_DIS(ch)	(0x01000000<<(ch))
+#define TXX9_DMA_MCR_RSFIF	0x00000080
+#define TXX9_DMA_MCR_FIFUM(ch)	(0x00000008<<(ch))
+#define TXX9_DMA_MCR_LE		0x00000004
+#define TXX9_DMA_MCR_RPRT	0x00000002
+#define TXX9_DMA_MCR_MSTEN	0x00000001
+
+/* bits for CCRn */
+#define TXX9_DMA_CCR_IMMCHN	0x20000000
+#define TXX9_DMA_CCR_USEXFSZ	0x10000000
+#define TXX9_DMA_CCR_LE		0x08000000
+#define TXX9_DMA_CCR_DBINH	0x04000000
+#define TXX9_DMA_CCR_SBINH	0x02000000
+#define TXX9_DMA_CCR_CHRST	0x01000000
+#define TXX9_DMA_CCR_RVBYTE	0x00800000
+#define TXX9_DMA_CCR_ACKPOL	0x00400000
+#define TXX9_DMA_CCR_REQPL	0x00200000
+#define TXX9_DMA_CCR_EGREQ	0x00100000
+#define TXX9_DMA_CCR_CHDN	0x00080000
+#define TXX9_DMA_CCR_DNCTL	0x00060000
+#define TXX9_DMA_CCR_EXTRQ	0x00010000
+#define TXX9_DMA_CCR_INTRQD	0x0000e000
+#define TXX9_DMA_CCR_INTENE	0x00001000
+#define TXX9_DMA_CCR_INTENC	0x00000800
+#define TXX9_DMA_CCR_INTENT	0x00000400
+#define TXX9_DMA_CCR_CHNEN	0x00000200
+#define TXX9_DMA_CCR_XFACT	0x00000100
+#define TXX9_DMA_CCR_SMPCHN	0x00000020
+#define TXX9_DMA_CCR_XFSZ(order)	(((order) << 2) & 0x0000001c)
+#define TXX9_DMA_CCR_XFSZ_1	TXX9_DMA_CCR_XFSZ(0)
+#define TXX9_DMA_CCR_XFSZ_2	TXX9_DMA_CCR_XFSZ(1)
+#define TXX9_DMA_CCR_XFSZ_4	TXX9_DMA_CCR_XFSZ(2)
+#define TXX9_DMA_CCR_XFSZ_8	TXX9_DMA_CCR_XFSZ(3)
+#define TXX9_DMA_CCR_XFSZ_X4	TXX9_DMA_CCR_XFSZ(4)
+#define TXX9_DMA_CCR_XFSZ_X8	TXX9_DMA_CCR_XFSZ(5)
+#define TXX9_DMA_CCR_XFSZ_X16	TXX9_DMA_CCR_XFSZ(6)
+#define TXX9_DMA_CCR_XFSZ_X32	TXX9_DMA_CCR_XFSZ(7)
+#define TXX9_DMA_CCR_MEMIO	0x00000002
+#define TXX9_DMA_CCR_SNGAD	0x00000001
+
+/* bits for CSRn */
+#define TXX9_DMA_CSR_CHNEN	0x00000400
+#define TXX9_DMA_CSR_STLXFER	0x00000200
+#define TXX9_DMA_CSR_XFACT	0x00000100
+#define TXX9_DMA_CSR_ABCHC	0x00000080
+#define TXX9_DMA_CSR_NCHNC	0x00000040
+#define TXX9_DMA_CSR_NTRNFC	0x00000020
+#define TXX9_DMA_CSR_EXTDN	0x00000010
+#define TXX9_DMA_CSR_CFERR	0x00000008
+#define TXX9_DMA_CSR_CHERR	0x00000004
+#define TXX9_DMA_CSR_DESERR	0x00000002
+#define TXX9_DMA_CSR_SORERR	0x00000001
+
+struct txx9dmac_chan {
+	struct dma_chan		chan;
+	struct dma_device	dma;
+	struct txx9dmac_dev	*ddev;
+	void __iomem		*ch_regs;
+#ifdef TXX9_DMA_HAVE_IRQ_PER_CHAN
+	struct tasklet_struct	tasklet;
+	int			irq;
+#endif
+	u32			ccr;
+
+	spinlock_t		lock;
+
+	/* these other elements are all protected by lock */
+	dma_cookie_t		completed;
+	struct list_head	active_list;
+	struct list_head	queue;
+	struct list_head	free_list;
+
+	unsigned int		descs_allocated;
+};
+
+struct txx9dmac_dev {
+	void __iomem		*regs;
+#ifndef TXX9_DMA_HAVE_IRQ_PER_CHAN
+	struct tasklet_struct	tasklet;
+	int			irq;
+	struct txx9dmac_chan	*chan[TXX9_DMA_MAX_NR_CHANNELS];
+#endif
+#ifdef TXX9_DMA_MAY_HAVE_64BIT_REGS
+	bool			have_64bit_regs;
+#endif
+	unsigned int		descsize;
+};
+
+static struct txx9dmac_chan *to_txx9dmac_chan(struct dma_chan *chan)
+{
+	return container_of(chan, struct txx9dmac_chan, chan);
+}
+
+static struct txx9dmac_cregs __iomem *__dma_regs(const struct txx9dmac_chan *dc)
+{
+	return dc->ch_regs;
+}
+
+static struct txx9dmac_cregs32 __iomem *__dma_regs32(
+	const struct txx9dmac_chan *dc)
+{
+	return dc->ch_regs;
+}
+
+static bool __is_dmac64(const struct txx9dmac_dev *ddev)
+{
+#ifdef TXX9_DMA_MAY_HAVE_64BIT_REGS
+	return ddev->have_64bit_regs;
+#else
+	return false;
+#endif
+}
+
+static bool is_dmac64(const struct txx9dmac_chan *dc)
+{
+	return __is_dmac64(dc->ddev);
+}
+
+#define channel64_readq(dc, name) \
+	__raw_readq(&(__dma_regs(dc)->name))
+#define channel64_writeq(dc, name, val) \
+	__raw_writeq((val), &(__dma_regs(dc)->name))
+#define channel64_readl(dc, name) \
+	__raw_readl(&(__dma_regs(dc)->name))
+#define channel64_writel(dc, name, val) \
+	__raw_writel((val), &(__dma_regs(dc)->name))
+
+#define channel32_readl(dc, name) \
+	__raw_readl(&(__dma_regs32(dc)->name))
+#define channel32_writel(dc, name, val) \
+	__raw_writel((val), &(__dma_regs32(dc)->name))
+
+#define channel_readq(dc, name) channel64_readq(dc, name)
+#define channel_writeq(dc, name, val) channel64_writeq(dc, name, val)
+#define channel_readl(dc, name) \
+	(is_dmac64(dc) ? \
+	 channel64_readl(dc, name) : channel32_readl(dc, name))
+#define channel_writel(dc, name, val) \
+	(is_dmac64(dc) ? \
+	 channel64_writel(dc, name, val) : channel32_writel(dc, name, val))
+
+static dma_addr_t channel64_read_CHAR(const struct txx9dmac_chan *dc)
+{
+	if (sizeof(__dma_regs(dc)->CHAR) == sizeof(u64))
+		return channel64_readq(dc, CHAR);
+	else
+		return channel64_readl(dc, CHAR);
+}
+
+static void channel64_write_CHAR(const struct txx9dmac_chan *dc, dma_addr_t val)
+{
+	if (sizeof(__dma_regs(dc)->CHAR) == sizeof(u64))
+		channel64_writeq(dc, CHAR, val);
+	else
+		channel64_writel(dc, CHAR, val);
+}
+
+#ifdef TXX9_DMA_HAVE_SMPCHN
+static dma_addr_t channel_read_CHAR(const struct txx9dmac_chan *dc)
+{
+	if (is_dmac64(dc))
+		return channel64_read_CHAR(dc);
+	else
+		return channel32_readl(dc, CHAR);
+}
+
+static void channel_write_CHAR(const struct txx9dmac_chan *dc, dma_addr_t val)
+{
+	if (is_dmac64(dc))
+		channel64_write_CHAR(dc, val);
+	else
+		channel32_writel(dc, CHAR, val);
+}
+#endif
+
+static struct txx9dmac_regs __iomem *__txx9dmac_regs(
+	const struct txx9dmac_dev *ddev)
+{
+	return ddev->regs;
+}
+
+static struct txx9dmac_regs32 __iomem *__txx9dmac_regs32(
+	const struct txx9dmac_dev *ddev)
+{
+	return ddev->regs;
+}
+
+#define dma64_readl(ddev, name) \
+	__raw_readl(&(__txx9dmac_regs(ddev)->name))
+#define dma64_writel(ddev, name, val) \
+	__raw_writel((val), &(__txx9dmac_regs(ddev)->name))
+
+#define dma32_readl(ddev, name) \
+	__raw_readl(&(__txx9dmac_regs32(ddev)->name))
+#define dma32_writel(ddev, name, val) \
+	__raw_writel((val), &(__txx9dmac_regs32(ddev)->name))
+
+#define dma_readl(ddev, name) \
+	(__is_dmac64(ddev) ? \
+	dma64_readl(ddev, name) : dma32_readl(ddev, name))
+#define dma_writel(ddev, name, val) \
+	(__is_dmac64(ddev) ? \
+	dma64_writel(ddev, name, val) : dma32_writel(ddev, name, val))
+
+#ifdef TXX9_DMA_USE_SIMPLE_CHAIN
+/* Hardware descriptor definition. (for simple-chain) */
+struct txx9dmac_hwdesc {
+#if defined(CONFIG_32BIT) && !defined(CONFIG_64BIT_PHYS_ADDR)
+	TXX9_DMA_REG32(CHAR);
+#else
+	u64 CHAR;
+#endif
+	u64 SAR;
+	u64 DAR;
+	TXX9_DMA_REG32(CNTR);
+};
+struct txx9dmac_hwdesc32 {
+	u32 CHAR;
+	u32 SAR;
+	u32 DAR;
+	u32 CNTR;
+};
+#else
+#define txx9dmac_hwdesc txx9dmac_cregs
+#define txx9dmac_hwdesc32 txx9dmac_cregs32
+#endif
+
+struct txx9dmac_desc {
+	/* FIRST values the hardware uses */
+	union {
+		struct txx9dmac_hwdesc hwdesc;
+		struct txx9dmac_hwdesc32 hwdesc32;
+	};
+
+	/* THEN values for driver housekeeping */
+	struct list_head		desc_node ____cacheline_aligned;
+	struct dma_async_tx_descriptor	txd;
+	size_t				len;
+};
+
+static struct device *chan2dev(struct dma_chan *chan)
+{
+	return &chan->dev->device;
+}
+static struct device *chan2parent(struct dma_chan *chan)
+{
+	return chan->dev->device.parent;
+}
+
+static struct txx9dmac_desc *
+txd_to_txx9dmac_desc(struct dma_async_tx_descriptor *txd)
+{
+	return container_of(txd, struct txx9dmac_desc, txd);
+}
+
+static dma_addr_t desc_read_CHAR(const struct txx9dmac_chan *dc,
+				 const struct txx9dmac_desc *desc)
+{
+	return is_dmac64(dc) ? desc->hwdesc.CHAR : desc->hwdesc32.CHAR;
+}
+
+static void desc_write_CHAR(const struct txx9dmac_chan *dc,
+			    struct txx9dmac_desc *desc, dma_addr_t val)
+{
+	if (is_dmac64(dc))
+		desc->hwdesc.CHAR = val;
+	else
+		desc->hwdesc32.CHAR = val;
+}
+
+#define TXX9_DMA_MAX_COUNT	0x04000000
+
+#define TXX9_DMA_INITIAL_DESC_COUNT	64
+
+static struct txx9dmac_desc *txx9dmac_first_active(struct txx9dmac_chan *dc)
+{
+	return list_entry(dc->active_list.next,
+			  struct txx9dmac_desc, desc_node);
+}
+
+#ifdef TXX9_DMA_HAVE_SMPCHN
+static struct txx9dmac_desc *txx9dmac_last_active(struct txx9dmac_chan *dc)
+{
+	return list_entry(dc->active_list.prev,
+			  struct txx9dmac_desc, desc_node);
+}
+#endif
+
+static struct txx9dmac_desc *txx9dmac_first_queued(struct txx9dmac_chan *dc)
+{
+	return list_entry(dc->queue.next, struct txx9dmac_desc, desc_node);
+}
+
+static struct txx9dmac_desc *txx9dmac_last_child(struct txx9dmac_desc *desc)
+{
+	if (!list_empty(&desc->txd.tx_list))
+		desc = list_entry(desc->txd.tx_list.prev,
+				  struct txx9dmac_desc, desc_node);
+	return desc;
+}
+
+static dma_cookie_t txx9dmac_tx_submit(struct dma_async_tx_descriptor *tx);
+
+static struct txx9dmac_desc *txx9dmac_desc_alloc(struct txx9dmac_chan *dc,
+						 gfp_t flags)
+{
+	struct txx9dmac_dev *ddev = dc->ddev;
+	struct txx9dmac_desc *desc;
+
+	desc = kzalloc(sizeof(*desc), flags);
+	if (!desc)
+		return NULL;
+	dma_async_tx_descriptor_init(&desc->txd, &dc->chan);
+	desc->txd.tx_submit = txx9dmac_tx_submit;
+	/* txd.flags will be overwritten in prep funcs */
+	desc->txd.flags = DMA_CTRL_ACK;
+	desc->txd.phys = dma_map_single(chan2parent(&dc->chan), &desc->hwdesc,
+					ddev->descsize, DMA_TO_DEVICE);
+	return desc;
+}
+
+static struct txx9dmac_desc *txx9dmac_desc_get(struct txx9dmac_chan *dc)
+{
+	struct txx9dmac_desc *desc, *_desc;
+	struct txx9dmac_desc *ret = NULL;
+	unsigned int i = 0;
+
+	spin_lock_bh(&dc->lock);
+	list_for_each_entry_safe(desc, _desc, &dc->free_list, desc_node) {
+		if (async_tx_test_ack(&desc->txd)) {
+			list_del(&desc->desc_node);
+			ret = desc;
+			break;
+		}
+		dev_dbg(chan2dev(&dc->chan), "desc %p not ACKed\n", desc);
+		i++;
+	}
+	spin_unlock_bh(&dc->lock);
+
+	dev_vdbg(chan2dev(&dc->chan), "scanned %u descriptors on freelist\n",
+		 i);
+	if (!ret) {
+		ret = txx9dmac_desc_alloc(dc, GFP_ATOMIC);
+		if (ret) {
+			spin_lock_bh(&dc->lock);
+			dc->descs_allocated++;
+			spin_unlock_bh(&dc->lock);
+		} else
+			dev_err(chan2dev(&dc->chan),
+				"not enough descriptors available\n");
+	}
+	return ret;
+}
+
+static void txx9dmac_sync_desc_for_cpu(struct txx9dmac_chan *dc,
+				       struct txx9dmac_desc *desc)
+{
+	struct txx9dmac_dev *ddev = dc->ddev;
+	struct txx9dmac_desc *child;
+
+	list_for_each_entry(child, &desc->txd.tx_list, desc_node)
+		dma_sync_single_for_cpu(chan2parent(&dc->chan),
+				child->txd.phys, ddev->descsize,
+				DMA_TO_DEVICE);
+	dma_sync_single_for_cpu(chan2parent(&dc->chan),
+			desc->txd.phys, ddev->descsize,
+			DMA_TO_DEVICE);
+}
+
+/*
+ * Move a descriptor, including any children, to the free list.
+ * `desc' must not be on any lists.
+ */
+static void txx9dmac_desc_put(struct txx9dmac_chan *dc,
+			      struct txx9dmac_desc *desc)
+{
+	if (desc) {
+		struct txx9dmac_desc *child;
+
+		txx9dmac_sync_desc_for_cpu(dc, desc);
+
+		spin_lock_bh(&dc->lock);
+		list_for_each_entry(child, &desc->txd.tx_list, desc_node)
+			dev_vdbg(chan2dev(&dc->chan),
+				 "moving child desc %p to freelist\n",
+				 child);
+		list_splice_init(&desc->txd.tx_list, &dc->free_list);
+		dev_vdbg(chan2dev(&dc->chan), "moving desc %p to freelist\n",
+			 desc);
+		list_add(&desc->desc_node, &dc->free_list);
+		spin_unlock_bh(&dc->lock);
+	}
+}
+
+/* Called with dc->lock held and bh disabled */
+static dma_cookie_t
+txx9dmac_assign_cookie(struct txx9dmac_chan *dc, struct txx9dmac_desc *desc)
+{
+	dma_cookie_t cookie = dc->chan.cookie;
+
+	if (++cookie < 0)
+		cookie = 1;
+
+	dc->chan.cookie = cookie;
+	desc->txd.cookie = cookie;
+
+	return cookie;
+}
+
+/*----------------------------------------------------------------------*/
+
+static void txx9dmac_dump_regs(struct txx9dmac_chan *dc)
+{
+	if (is_dmac64(dc))
+		dev_err(chan2dev(&dc->chan),
+			"  CHAR: %#llx SAR: %#llx DAR: %#llx CNTR: %#x"
+			" SAIR: %#x DAIR: %#x CCR: %#x CSR: %#x\n",
+			(u64)channel64_read_CHAR(dc),
+			channel64_readq(dc, SAR),
+			channel64_readq(dc, DAR),
+			channel64_readl(dc, CNTR),
+			channel64_readl(dc, SAIR),
+			channel64_readl(dc, DAIR),
+			channel64_readl(dc, CCR),
+			channel64_readl(dc, CSR));
+	else
+		dev_err(chan2dev(&dc->chan),
+			"  CHAR: %#x SAR: %#x DAR: %#x CNTR: %#x"
+			" SAIR: %#x DAIR: %#x CCR: %#x CSR: %#x\n",
+			channel32_readl(dc, CHAR),
+			channel32_readl(dc, SAR),
+			channel32_readl(dc, DAR),
+			channel32_readl(dc, CNTR),
+			channel32_readl(dc, SAIR),
+			channel32_readl(dc, DAIR),
+			channel32_readl(dc, CCR),
+			channel32_readl(dc, CSR));
+}
+
+static void txx9dmac_reset_chan(struct txx9dmac_chan *dc)
+{
+	channel_writel(dc, CCR, TXX9_DMA_CCR_CHRST);
+	if (is_dmac64(dc)) {
+		channel_writeq(dc, CHAR, 0);
+		channel_writeq(dc, SAR, 0);
+		channel_writeq(dc, DAR, 0);
+	} else {
+		channel_writel(dc, CHAR, 0);
+		channel_writel(dc, SAR, 0);
+		channel_writel(dc, DAR, 0);
+	}
+	channel_writel(dc, CNTR, 0);
+	channel_writel(dc, SAIR, 0);
+	channel_writel(dc, DAIR, 0);
+	channel_writel(dc, CCR, 0);
+	mmiowb();
+}
+
+/* Called with dc->lock held and bh disabled */
+static void txx9dmac_dostart(struct txx9dmac_chan *dc,
+			     struct txx9dmac_desc *first)
+{
+#ifdef TXX9_DMA_USE_SIMPLE_CHAIN
+	struct txx9dmac_slave *ds = dc->chan.private;
+#endif
+
+	dev_vdbg(chan2dev(&dc->chan), "dostart %u %p\n",
+		 first->txd.cookie, first);
+	/* ASSERT:  channel is idle */
+	if (channel_readl(dc, CSR) & TXX9_DMA_CSR_XFACT) {
+		dev_err(chan2dev(&dc->chan),
+			"BUG: Attempted to start non-idle channel\n");
+		txx9dmac_dump_regs(dc);
+		/* The tasklet will hopefully advance the queue... */
+		return;
+	}
+
+	if (is_dmac64(dc)) {
+		channel64_writel(dc, CNTR, 0);
+		channel64_writel(dc, CSR, 0xffffffff);
+#ifdef TXX9_DMA_USE_SIMPLE_CHAIN
+		if (ds) {
+			if (ds->tx_reg) {
+				channel64_writel(dc, SAIR, ds->reg_width);
+				channel64_writel(dc, DAIR, 0);
+			} else {
+				channel64_writel(dc, SAIR, 0);
+				channel64_writel(dc, DAIR, ds->reg_width);
+			}
+		} else {
+			channel64_writel(dc, SAIR, 8);
+			channel64_writel(dc, DAIR, 8);
+		}
+#else
+		channel64_writel(dc, SAIR, first->hwdesc.SAIR);
+		channel64_writel(dc, DAIR, first->hwdesc.DAIR);
+#endif
+		/* All 64-bit DMAC supports SMPCHN */
+		channel64_writel(dc, CCR, dc->ccr);
+		/* Writing a non zero value to CHAR will assert XFACT */
+		channel64_write_CHAR(dc, first->txd.phys);
+	} else {
+		channel32_writel(dc, CNTR, 0);
+		channel32_writel(dc, CSR, 0xffffffff);
+#ifdef TXX9_DMA_USE_SIMPLE_CHAIN
+		if (ds) {
+			if (ds->tx_reg) {
+				channel32_writel(dc, SAIR, ds->reg_width);
+				channel32_writel(dc, DAIR, 0);
+			} else {
+				channel32_writel(dc, SAIR, 0);
+				channel32_writel(dc, DAIR, ds->reg_width);
+			}
+		} else {
+			channel32_writel(dc, SAIR, 4);
+			channel32_writel(dc, DAIR, 4);
+		}
+#else
+		channel32_writel(dc, SAIR, first->hwdesc32.SAIR);
+		channel32_writel(dc, DAIR, first->hwdesc32.DAIR);
+#endif
+#ifdef TXX9_DMA_HAVE_SMPCHN
+		channel32_writel(dc, CCR, dc->ccr);
+		/* Writing a non zero value to CHAR will assert XFACT */
+		channel32_writel(dc, CHAR, first->txd.phys);
+#else
+		channel32_writel(dc, CHAR, first->txd.phys);
+		channel32_writel(dc, CCR, dc->ccr);
+#endif
+	}
+}
+
+/*----------------------------------------------------------------------*/
+
+static void
+txx9dmac_descriptor_complete(struct txx9dmac_chan *dc,
+			     struct txx9dmac_desc *desc)
+{
+	dma_async_tx_callback callback;
+	void *param;
+	struct dma_async_tx_descriptor *txd = &desc->txd;
+	struct txx9dmac_slave *ds = dc->chan.private;
+
+	dev_vdbg(chan2dev(&dc->chan), "descriptor %u %p complete\n",
+		 txd->cookie, desc);
+
+	dc->completed = txd->cookie;
+	callback = txd->callback;
+	param = txd->callback_param;
+
+	txx9dmac_sync_desc_for_cpu(dc, desc);
+	list_splice_init(&txd->tx_list, &dc->free_list);
+	list_move(&desc->desc_node, &dc->free_list);
+
+	/*
+	 * We use dma_unmap_page() regardless of how the buffers were
+	 * mapped before they were submitted...
+	 */
+	if (!ds) {
+		dma_addr_t dmaaddr;
+		if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
+			dmaaddr = is_dmac64(dc) ?
+				desc->hwdesc.DAR : desc->hwdesc32.DAR;
+			dma_unmap_page(chan2parent(&dc->chan), dmaaddr,
+				       desc->len, DMA_FROM_DEVICE);
+		}
+		if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
+			dmaaddr = is_dmac64(dc) ?
+				desc->hwdesc.SAR : desc->hwdesc32.SAR;
+			dma_unmap_page(chan2parent(&dc->chan), dmaaddr,
+				       desc->len, DMA_TO_DEVICE);
+		}
+	}
+
+	/*
+	 * The API requires that no submissions are done from a
+	 * callback, so we don't need to drop the lock here
+	 */
+	if (callback)
+		callback(param);
+	dma_run_dependencies(txd);
+}
+
+static void txx9dmac_dequeue(struct txx9dmac_chan *dc, struct list_head *list)
+{
+	struct txx9dmac_dev *ddev = dc->ddev;
+	struct txx9dmac_desc *desc;
+	struct txx9dmac_desc *prev = NULL;
+
+	BUG_ON(!list_empty(list));
+	do {
+		desc = txx9dmac_first_queued(dc);
+		if (prev) {
+			desc_write_CHAR(dc, prev, desc->txd.phys);
+			dma_sync_single_for_device(chan2parent(&dc->chan),
+				prev->txd.phys, ddev->descsize,
+				DMA_TO_DEVICE);
+		}
+		prev = txx9dmac_last_child(desc);
+		list_move_tail(&desc->desc_node, list);
+#ifdef TXX9_DMA_USE_SIMPLE_CHAIN
+		/* Make chain-completion interrupt happen */
+		if ((desc->txd.flags & DMA_PREP_INTERRUPT) &&
+		    !(dc->ccr & TXX9_DMA_CCR_INTENT))
+			break;
+#endif
+	} while (!list_empty(&dc->queue));
+}
+
+static void txx9dmac_complete_all(struct txx9dmac_chan *dc)
+{
+	struct txx9dmac_desc *desc, *_desc;
+	LIST_HEAD(list);
+
+	/*
+	 * Submit queued descriptors ASAP, i.e. before we go through
+	 * the completed ones.
+	 */
+	list_splice_init(&dc->active_list, &list);
+	if (!list_empty(&dc->queue)) {
+		txx9dmac_dequeue(dc, &dc->active_list);
+		txx9dmac_dostart(dc, txx9dmac_first_active(dc));
+	}
+
+	list_for_each_entry_safe(desc, _desc, &list, desc_node)
+		txx9dmac_descriptor_complete(dc, desc);
+}
+
+static void txx9dmac_dump_desc(struct txx9dmac_chan *dc,
+			       struct txx9dmac_hwdesc *desc)
+{
+	if (is_dmac64(dc)) {
+#ifdef TXX9_DMA_USE_SIMPLE_CHAIN
+		dev_crit(chan2dev(&dc->chan),
+			 "  desc: ch%#llx s%#llx d%#llx c%#x\n",
+			 (u64)desc->CHAR, desc->SAR, desc->DAR, desc->CNTR);
+#else
+		dev_crit(chan2dev(&dc->chan),
+			 "  desc: ch%#llx s%#llx d%#llx c%#x"
+			 " si%#x di%#x cc%#x cs%#x\n",
+			 (u64)desc->CHAR, desc->SAR, desc->DAR, desc->CNTR,
+			 desc->SAIR, desc->DAIR, desc->CCR, desc->CSR);
+#endif
+	} else {
+		struct txx9dmac_hwdesc32 *d = (struct txx9dmac_hwdesc32 *)desc;
+#ifdef TXX9_DMA_USE_SIMPLE_CHAIN
+		dev_crit(chan2dev(&dc->chan),
+			 "  desc: ch%#x s%#x d%#x c%#x\n",
+			 d->CHAR, d->SAR, d->DAR, d->CNTR);
+#else
+		dev_crit(chan2dev(&dc->chan),
+			 "  desc: ch%#x s%#x d%#x c%#x"
+			 " si%#x di%#x cc%#x cs%#x\n",
+			 d->CHAR, d->SAR, d->DAR, d->CNTR,
+			 d->SAIR, d->DAIR, d->CCR, d->CSR);
+#endif
+	}
+}
+
+static void txx9dmac_handle_error(struct txx9dmac_chan *dc, u32 csr)
+{
+	struct txx9dmac_desc *bad_desc;
+	struct txx9dmac_desc *child;
+	u32 errors;
+
+	/*
+	 * The descriptor currently at the head of the active list is
+	 * borked. Since we don't have any way to report errors, we'll
+	 * just have to scream loudly and try to carry on.
+	 */
+	dev_crit(chan2dev(&dc->chan), "Abnormal Chain Completion\n");
+	txx9dmac_dump_regs(dc);
+
+	bad_desc = txx9dmac_first_active(dc);
+	list_del_init(&bad_desc->desc_node);
+
+	/* Clear all error flags and try to restart the controller */
+	errors = csr & (TXX9_DMA_CSR_ABCHC |
+			TXX9_DMA_CSR_CFERR | TXX9_DMA_CSR_CHERR |
+			TXX9_DMA_CSR_DESERR | TXX9_DMA_CSR_SORERR);
+	channel_writel(dc, CSR, errors);
+
+	if (list_empty(&dc->active_list) && !list_empty(&dc->queue))
+		txx9dmac_dequeue(dc, &dc->active_list);
+	if (!list_empty(&dc->active_list))
+		txx9dmac_dostart(dc, txx9dmac_first_active(dc));
+
+	dev_crit(chan2dev(&dc->chan),
+		 "Bad descriptor submitted for DMA! (cookie: %d)\n",
+		 bad_desc->txd.cookie);
+	txx9dmac_dump_desc(dc, &bad_desc->hwdesc);
+	list_for_each_entry(child, &bad_desc->txd.tx_list, desc_node)
+		txx9dmac_dump_desc(dc, &child->hwdesc);
+	/* Pretend the descriptor completed successfully */
+	txx9dmac_descriptor_complete(dc, bad_desc);
+}
+
+static void txx9dmac_scan_descriptors(struct txx9dmac_chan *dc)
+{
+	dma_addr_t chain;
+	struct txx9dmac_desc *desc, *_desc;
+	struct txx9dmac_desc *child;
+	u32 csr;
+
+	if (is_dmac64(dc)) {
+		chain = channel64_read_CHAR(dc);
+		csr = channel64_readl(dc, CSR);
+		channel64_writel(dc, CSR, csr);
+	} else {
+		chain = channel32_readl(dc, CHAR);
+		csr = channel32_readl(dc, CSR);
+		channel32_writel(dc, CSR, csr);
+	}
+	/* For dynamic chain, we should look at XFACT instead of NCHNC */
+	if (!(csr & (TXX9_DMA_CSR_XFACT | TXX9_DMA_CSR_ABCHC))) {
+		/* Everything we've submitted is done */
+		txx9dmac_complete_all(dc);
+		return;
+	}
+	if (!(csr & TXX9_DMA_CSR_CHNEN))
+		chain = 0;	/* last descriptor of this chain */
+
+	dev_vdbg(chan2dev(&dc->chan), "scan_descriptors: char=%#llx\n",
+		 (u64)chain);
+
+	list_for_each_entry_safe(desc, _desc, &dc->active_list, desc_node) {
+		if (desc_read_CHAR(dc, desc) == chain) {
+			/* This one is currently in progress */
+			if (csr & TXX9_DMA_CSR_ABCHC)
+				goto scan_done;
+			return;
+		}
+
+		list_for_each_entry(child, &desc->txd.tx_list, desc_node)
+			if (desc_read_CHAR(dc, child) == chain) {
+				/* Currently in progress */
+				if (csr & TXX9_DMA_CSR_ABCHC)
+					goto scan_done;
+				return;
+			}
+
+		/*
+		 * No descriptors so far seem to be in progress, i.e.
+		 * this one must be done.
+		 */
+		txx9dmac_descriptor_complete(dc, desc);
+	}
+scan_done:
+	if (csr & TXX9_DMA_CSR_ABCHC) {
+		txx9dmac_handle_error(dc, csr);
+		return;
+	}
+
+	dev_err(chan2dev(&dc->chan),
+		"BUG: All descriptors done, but channel not idle!\n");
+
+	/* Try to continue after resetting the channel... */
+	txx9dmac_reset_chan(dc);
+
+	if (!list_empty(&dc->queue)) {
+		txx9dmac_dequeue(dc, &dc->active_list);
+		txx9dmac_dostart(dc, txx9dmac_first_active(dc));
+	}
+}
+
+static void txx9dmac_tasklet(unsigned long data)
+{
+	int irq;
+	u32 csr;
+	struct txx9dmac_chan *dc;
+
+#ifdef TXX9_DMA_HAVE_IRQ_PER_CHAN
+	dc = (struct txx9dmac_chan *)data;
+	csr = channel_readl(dc, CSR);
+	dev_vdbg(chan2dev(&dc->chan), "tasklet: status=%x\n", csr);
+
+	spin_lock(&dc->lock);
+	if (csr & (TXX9_DMA_CSR_ABCHC | TXX9_DMA_CSR_NCHNC |
+		   TXX9_DMA_CSR_NTRNFC))
+		txx9dmac_scan_descriptors(dc);
+	spin_unlock(&dc->lock);
+	irq = dc->irq;
+#else
+	struct txx9dmac_dev *ddev = (struct txx9dmac_dev *)data;
+	u32 mcr;
+	int i;
+
+	mcr = dma_readl(ddev, MCR);
+	dev_vdbg(ddev->chan[0]->dma.dev, "tasklet: mcr=%x\n", mcr);
+	for (i = 0; i < TXX9_DMA_MAX_NR_CHANNELS; i++) {
+		if ((mcr >> (24 + i)) & 0x11) {
+			dc = ddev->chan[i];
+			csr = channel_readl(dc, CSR);
+			dev_vdbg(chan2dev(&dc->chan), "tasklet: status=%x\n",
+				 csr);
+			spin_lock(&dc->lock);
+			if (csr & (TXX9_DMA_CSR_ABCHC | TXX9_DMA_CSR_NCHNC |
+				   TXX9_DMA_CSR_NTRNFC))
+				txx9dmac_scan_descriptors(dc);
+			spin_unlock(&dc->lock);
+		}
+	}
+	irq = ddev->irq;
+#endif
+
+	enable_irq(irq);
+}
+
+static irqreturn_t txx9dmac_interrupt(int irq, void *dev_id)
+{
+#ifdef TXX9_DMA_HAVE_IRQ_PER_CHAN
+	struct txx9dmac_chan *dc = dev_id;
+
+	dev_vdbg(chan2dev(&dc->chan), "interrupt: status=%#x\n",
+			channel_readl(dc, CSR));
+
+	tasklet_schedule(&dc->tasklet);
+#else
+	struct txx9dmac_dev *ddev = dev_id;
+
+	dev_vdbg(ddev->chan[0]->dma.dev, "interrupt: status=%#x\n",
+			dma_readl(ddev, MCR));
+
+	tasklet_schedule(&ddev->tasklet);
+#endif
+	/*
+	 * Just disable the interrupts. We'll turn them back on in the
+	 * softirq handler.
+	 */
+	disable_irq_nosync(irq);
+
+	return IRQ_HANDLED;
+}
+
+/*----------------------------------------------------------------------*/
+
+static dma_cookie_t txx9dmac_tx_submit(struct dma_async_tx_descriptor *tx)
+{
+	struct txx9dmac_desc *desc = txd_to_txx9dmac_desc(tx);
+	struct txx9dmac_chan *dc = to_txx9dmac_chan(tx->chan);
+	dma_cookie_t cookie;
+
+	spin_lock_bh(&dc->lock);
+	cookie = txx9dmac_assign_cookie(dc, desc);
+
+	dev_vdbg(chan2dev(tx->chan), "tx_submit: queued %u %p\n",
+		 desc->txd.cookie, desc);
+
+	list_add_tail(&desc->desc_node, &dc->queue);
+	spin_unlock_bh(&dc->lock);
+
+	return cookie;
+}
+
+static struct dma_async_tx_descriptor *
+txx9dmac_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
+		size_t len, unsigned long flags)
+{
+	struct txx9dmac_chan *dc = to_txx9dmac_chan(chan);
+	struct txx9dmac_dev *ddev = dc->ddev;
+	struct txx9dmac_desc *desc;
+	struct txx9dmac_desc *first;
+	struct txx9dmac_desc *prev;
+	size_t xfer_count;
+	size_t offset;
+
+	dev_vdbg(chan2dev(chan), "prep_dma_memcpy d%#llx s%#llx l%#zx f%#lx\n",
+		 (u64)dest, (u64)src, len, flags);
+
+	if (unlikely(!len)) {
+		dev_dbg(chan2dev(chan), "prep_dma_memcpy: length is zero!\n");
+		return NULL;
+	}
+
+	prev = first = NULL;
+
+	for (offset = 0; offset < len; offset += xfer_count) {
+		xfer_count = min_t(size_t, len - offset, TXX9_DMA_MAX_COUNT);
+		/*
+		 * Workaround for ERT-TX49H2-033, ERT-TX49H3-020,
+		 * ERT-TX49H4-016 (slightly conservative)
+		 */
+		if (__is_dmac64(ddev)) {
+			if (xfer_count > 0x100 &&
+			    (xfer_count & 0xff) >= 0xfa &&
+			    (xfer_count & 0xff) <= 0xff)
+				xfer_count -= 0x20;
+		} else {
+			if (xfer_count > 0x80 &&
+			    (xfer_count & 0x7f) >= 0x7e &&
+			    (xfer_count & 0x7f) <= 0x7f)
+				xfer_count -= 0x20;
+		}
+
+		desc = txx9dmac_desc_get(dc);
+		if (!desc) {
+			txx9dmac_desc_put(dc, first);
+			return NULL;
+		}
+
+		if (__is_dmac64(ddev)) {
+			desc->hwdesc.SAR = src + offset;
+			desc->hwdesc.DAR = dest + offset;
+			desc->hwdesc.CNTR = xfer_count;
+#ifndef TXX9_DMA_USE_SIMPLE_CHAIN
+			desc->hwdesc.SAIR = 8;
+			desc->hwdesc.DAIR = 8;
+			desc->hwdesc.CCR = dc->ccr | TXX9_DMA_CCR_XFACT;
+#endif
+		} else {
+			desc->hwdesc32.SAR = src + offset;
+			desc->hwdesc32.DAR = dest + offset;
+			desc->hwdesc32.CNTR = xfer_count;
+#ifndef TXX9_DMA_USE_SIMPLE_CHAIN
+			desc->hwdesc32.SAIR = 4;
+			desc->hwdesc32.DAIR = 4;
+			desc->hwdesc32.CCR = dc->ccr | TXX9_DMA_CCR_XFACT;
+#endif
+		}
+
+		if (!first) {
+			first = desc;
+		} else {
+			desc_write_CHAR(dc, prev, desc->txd.phys);
+			dma_sync_single_for_device(chan2parent(&dc->chan),
+					prev->txd.phys, ddev->descsize,
+					DMA_TO_DEVICE);
+			list_add_tail(&desc->desc_node,
+					&first->txd.tx_list);
+		}
+		prev = desc;
+	}
+
+#ifndef TXX9_DMA_USE_SIMPLE_CHAIN
+	if (flags & DMA_PREP_INTERRUPT) {
+		/* Trigger interrupt after last block */
+		if (__is_dmac64(ddev))
+			prev->hwdesc.CCR |= TXX9_DMA_CCR_INTENT;
+		else
+			prev->hwdesc32.CCR |= TXX9_DMA_CCR_INTENT;
+	}
+#endif
+
+	desc_write_CHAR(dc, prev, 0);
+	dma_sync_single_for_device(chan2parent(&dc->chan),
+			prev->txd.phys, ddev->descsize,
+			DMA_TO_DEVICE);
+
+	first->txd.flags = flags;
+	first->len = len;
+
+	return &first->txd;
+}
+
+static struct dma_async_tx_descriptor *
+txx9dmac_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
+		unsigned int sg_len, enum dma_data_direction direction,
+		unsigned long flags)
+{
+	struct txx9dmac_chan *dc = to_txx9dmac_chan(chan);
+	struct txx9dmac_dev *ddev = dc->ddev;
+	struct txx9dmac_slave *ds = chan->private;
+	struct txx9dmac_desc *prev;
+	struct txx9dmac_desc *first;
+	unsigned int i;
+	struct scatterlist *sg;
+
+	dev_vdbg(chan2dev(chan), "prep_dma_slave\n");
+
+	BUG_ON(!ds || !ds->reg_width);
+	if (ds->tx_reg)
+		BUG_ON(direction != DMA_TO_DEVICE);
+	else
+		BUG_ON(direction != DMA_FROM_DEVICE);
+	if (unlikely(!sg_len))
+		return NULL;
+
+	prev = first = NULL;
+
+	for_each_sg(sgl, sg, sg_len, i) {
+		struct txx9dmac_desc *desc;
+		dma_addr_t mem;
+
+		desc = txx9dmac_desc_get(dc);
+		if (!desc) {
+			txx9dmac_desc_put(dc, first);
+			return NULL;
+		}
+
+		mem = sg_dma_address(sg);
+
+		if (__is_dmac64(ddev)) {
+			if (direction == DMA_TO_DEVICE) {
+				desc->hwdesc.SAR = mem;
+				desc->hwdesc.DAR = ds->tx_reg;
+#ifndef TXX9_DMA_USE_SIMPLE_CHAIN
+				desc->hwdesc.SAIR = ds->reg_width;
+				desc->hwdesc.DAIR = 0;
+#endif
+			} else {
+				desc->hwdesc.SAR = ds->rx_reg;
+				desc->hwdesc.DAR = mem;
+#ifndef TXX9_DMA_USE_SIMPLE_CHAIN
+				desc->hwdesc.SAIR = 0;
+				desc->hwdesc.DAIR = ds->reg_width;
+#endif
+			}
+			desc->hwdesc.CNTR = sg_dma_len(sg);
+#ifndef TXX9_DMA_USE_SIMPLE_CHAIN
+			desc->hwdesc.CCR = dc->ccr | TXX9_DMA_CCR_XFACT;
+#endif
+		} else {
+			if (direction == DMA_TO_DEVICE) {
+				desc->hwdesc32.SAR = mem;
+				desc->hwdesc32.DAR = ds->tx_reg;
+#ifndef TXX9_DMA_USE_SIMPLE_CHAIN
+				desc->hwdesc32.SAIR = ds->reg_width;
+				desc->hwdesc32.DAIR = 0;
+#endif
+			} else {
+				desc->hwdesc32.SAR = ds->rx_reg;
+				desc->hwdesc32.DAR = mem;
+#ifndef TXX9_DMA_USE_SIMPLE_CHAIN
+				desc->hwdesc32.SAIR = 0;
+				desc->hwdesc32.DAIR = ds->reg_width;
+#endif
+			}
+			desc->hwdesc32.CNTR = sg_dma_len(sg);
+#ifndef TXX9_DMA_USE_SIMPLE_CHAIN
+			desc->hwdesc32.CCR = dc->ccr | TXX9_DMA_CCR_XFACT;
+#endif
+		}
+
+		if (!first) {
+			first = desc;
+		} else {
+			desc_write_CHAR(dc, prev, desc->txd.phys);
+			dma_sync_single_for_device(chan2parent(&dc->chan),
+					prev->txd.phys,
+					ddev->descsize,
+					DMA_TO_DEVICE);
+			list_add_tail(&desc->desc_node,
+					&first->txd.tx_list);
+		}
+		prev = desc;
+	}
+
+#ifndef TXX9_DMA_USE_SIMPLE_CHAIN
+	if (flags & DMA_PREP_INTERRUPT) {
+		/* Trigger interrupt after last block */
+		if (__is_dmac64(ddev))
+			prev->hwdesc.CCR |= TXX9_DMA_CCR_INTENT;
+		else
+			prev->hwdesc32.CCR |= TXX9_DMA_CCR_INTENT;
+	}
+#endif
+
+	desc_write_CHAR(dc, prev, 0);
+	dma_sync_single_for_device(chan2parent(&dc->chan),
+			prev->txd.phys, ddev->descsize,
+			DMA_TO_DEVICE);
+
+	first->txd.flags = flags;
+	first->len = 0;
+
+	return &first->txd;
+}
+
+static void txx9dmac_terminate_all(struct dma_chan *chan)
+{
+	struct txx9dmac_chan *dc = to_txx9dmac_chan(chan);
+	struct txx9dmac_desc *desc, *_desc;
+	LIST_HEAD(list);
+
+	dev_vdbg(chan2dev(chan), "terminate_all\n");
+	spin_lock_bh(&dc->lock);
+
+	txx9dmac_reset_chan(dc);
+
+	/* active_list entries will end up before queued entries */
+	list_splice_init(&dc->queue, &list);
+	list_splice_init(&dc->active_list, &list);
+
+	spin_unlock_bh(&dc->lock);
+
+	/* Flush all pending and queued descriptors */
+	list_for_each_entry_safe(desc, _desc, &list, desc_node)
+		txx9dmac_descriptor_complete(dc, desc);
+}
+
+static enum dma_status
+txx9dmac_is_tx_complete(struct dma_chan *chan,
+			dma_cookie_t cookie,
+		dma_cookie_t *done, dma_cookie_t *used)
+{
+	struct txx9dmac_chan *dc = to_txx9dmac_chan(chan);
+	dma_cookie_t last_used;
+	dma_cookie_t last_complete;
+	int ret;
+
+	last_complete = dc->completed;
+	last_used = chan->cookie;
+
+	ret = dma_async_is_complete(cookie, last_complete, last_used);
+	if (ret != DMA_SUCCESS) {
+		spin_lock_bh(&dc->lock);
+		txx9dmac_scan_descriptors(dc);
+		spin_unlock_bh(&dc->lock);
+
+		last_complete = dc->completed;
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
+#ifdef TXX9_DMA_HAVE_SMPCHN
+static void txx9dmac_chain_dynamic(struct txx9dmac_chan *dc,
+				   struct txx9dmac_desc *prev)
+{
+	struct txx9dmac_dev *ddev = dc->ddev;
+	struct txx9dmac_desc *desc;
+	LIST_HEAD(list);
+
+	prev = txx9dmac_last_child(prev);
+	txx9dmac_dequeue(dc, &list);
+	desc = list_entry(list.next, struct txx9dmac_desc, desc_node);
+	desc_write_CHAR(dc, prev, desc->txd.phys);
+	dma_sync_single_for_device(chan2parent(&dc->chan),
+				   prev->txd.phys, ddev->descsize,
+				   DMA_TO_DEVICE);
+	mmiowb();
+	if (!(channel_readl(dc, CSR) & TXX9_DMA_CSR_CHNEN) &&
+	    channel_read_CHAR(dc) == prev->txd.phys)
+		/* Restart chain DMA */
+		channel_write_CHAR(dc, desc->txd.phys);
+	list_splice_tail(&list, &dc->active_list);
+}
+#endif
+
+static void txx9dmac_issue_pending(struct dma_chan *chan)
+{
+	struct txx9dmac_chan *dc = to_txx9dmac_chan(chan);
+
+	spin_lock_bh(&dc->lock);
+
+	if (!list_empty(&dc->active_list))
+		txx9dmac_scan_descriptors(dc);
+	if (!list_empty(&dc->queue)) {
+		if (list_empty(&dc->active_list)) {
+			txx9dmac_dequeue(dc, &dc->active_list);
+			txx9dmac_dostart(dc, txx9dmac_first_active(dc));
+		}
+#ifdef TXX9_DMA_HAVE_SMPCHN
+		else {
+			struct txx9dmac_desc *prev = txx9dmac_last_active(dc);
+#ifdef TXX9_DMA_USE_SIMPLE_CHAIN
+			if (!(prev->txd.flags & DMA_PREP_INTERRUPT) ||
+			    (dc->ccr & TXX9_DMA_CCR_INTENT))
+				txx9dmac_chain_dynamic(dc, prev);
+#else
+			txx9dmac_chain_dynamic(dc, prev);
+#endif
+		}
+#endif
+	}
+
+	spin_unlock_bh(&dc->lock);
+}
+
+static int txx9dmac_alloc_chan_resources(struct dma_chan *chan)
+{
+	struct txx9dmac_chan *dc = to_txx9dmac_chan(chan);
+	struct txx9dmac_slave *ds = chan->private;
+	struct txx9dmac_desc *desc;
+	int i;
+
+	dev_vdbg(chan2dev(chan), "alloc_chan_resources\n");
+
+	/* ASSERT:  channel is idle */
+	if (channel_readl(dc, CSR) & TXX9_DMA_CSR_XFACT) {
+		dev_dbg(chan2dev(chan), "DMA channel not idle?\n");
+		return -EIO;
+	}
+
+	dc->completed = chan->cookie = 1;
+
+	dc->ccr = TXX9_DMA_CCR_IMMCHN | TXX9_DMA_CCR_INTENE;
+#ifdef TXX9_DMA_HAVE_SMPCHN
+#ifdef TXX9_DMA_USE_SIMPLE_CHAIN
+	dc->ccr |= TXX9_DMA_CCR_SMPCHN | TXX9_DMA_CCR_INTENC;
+#endif
+#else
+	dc->ccr |= TXX9_DMA_CCR_INTENC;
+#endif
+#if defined(TXX9_DMA_HAVE_CCR_LE) && defined(__LITTLE_ENDIAN)
+	dc->ccr |= TXX9_DMA_CCR_LE;
+#endif
+	if (chan->device->device_prep_dma_memcpy) {
+		if (ds)
+			return -EINVAL;
+		dc->ccr |= TXX9_DMA_CCR_XFSZ_X8;
+	} else {
+		if (!ds ||
+		    (ds->tx_reg && ds->rx_reg) || (!ds->tx_reg && !ds->rx_reg))
+			return -EINVAL;
+		dc->ccr |= TXX9_DMA_CCR_EXTRQ |
+			TXX9_DMA_CCR_XFSZ(__ffs(ds->reg_width));
+#ifdef TXX9_DMA_USE_SIMPLE_CHAIN
+		dc->ccr |= TXX9_DMA_CCR_INTENT;
+#endif
+	}
+
+	spin_lock_bh(&dc->lock);
+	i = dc->descs_allocated;
+	while (dc->descs_allocated < TXX9_DMA_INITIAL_DESC_COUNT) {
+		spin_unlock_bh(&dc->lock);
+
+		desc = txx9dmac_desc_alloc(dc, GFP_KERNEL);
+		if (!desc) {
+			dev_info(chan2dev(chan),
+				"only allocated %d descriptors\n", i);
+			spin_lock_bh(&dc->lock);
+			break;
+		}
+		txx9dmac_desc_put(dc, desc);
+
+		spin_lock_bh(&dc->lock);
+		i = ++dc->descs_allocated;
+	}
+	spin_unlock_bh(&dc->lock);
+
+	dev_dbg(chan2dev(chan),
+		"alloc_chan_resources allocated %d descriptors\n", i);
+
+	return i;
+}
+
+static void txx9dmac_free_chan_resources(struct dma_chan *chan)
+{
+	struct txx9dmac_chan *dc = to_txx9dmac_chan(chan);
+	struct txx9dmac_dev *ddev = dc->ddev;
+	struct txx9dmac_desc *desc, *_desc;
+	LIST_HEAD(list);
+
+	dev_dbg(chan2dev(chan), "free_chan_resources (descs allocated=%u)\n",
+			dc->descs_allocated);
+
+	/* ASSERT:  channel is idle */
+	BUG_ON(!list_empty(&dc->active_list));
+	BUG_ON(!list_empty(&dc->queue));
+	BUG_ON(channel_readl(dc, CSR) & TXX9_DMA_CSR_XFACT);
+
+	spin_lock_bh(&dc->lock);
+	list_splice_init(&dc->free_list, &list);
+	dc->descs_allocated = 0;
+	spin_unlock_bh(&dc->lock);
+
+	list_for_each_entry_safe(desc, _desc, &list, desc_node) {
+		dev_vdbg(chan2dev(chan), "  freeing descriptor %p\n", desc);
+		dma_unmap_single(chan2parent(chan), desc->txd.phys,
+				 ddev->descsize, DMA_TO_DEVICE);
+		kfree(desc);
+	}
+
+	dev_vdbg(chan2dev(chan), "free_chan_resources done\n");
+}
+
+/*----------------------------------------------------------------------*/
+
+static void txx9dmac_off(struct txx9dmac_dev *ddev)
+{
+	dma_writel(ddev, MCR, 0);
+	mmiowb();
+}
+
+static int __init txx9dmac_chan_probe(struct platform_device *pdev)
+{
+	struct txx9dmac_chan_platform_data *cpdata = pdev->dev.platform_data;
+	struct platform_device *dmac_dev = cpdata->dmac_dev;
+	struct txx9dmac_platform_data *pdata = dmac_dev->dev.platform_data;
+	struct txx9dmac_chan *dc;
+	int err;
+	int ch = pdev->id % TXX9_DMA_MAX_NR_CHANNELS;
+#ifdef TXX9_DMA_HAVE_IRQ_PER_CHAN
+	int irq;
+#endif
+
+	dc = devm_kzalloc(&pdev->dev, sizeof(*dc), GFP_KERNEL);
+	if (!dc)
+		return -ENOMEM;
+
+	dc->dma.dev = &pdev->dev;
+	dc->dma.device_alloc_chan_resources = txx9dmac_alloc_chan_resources;
+	dc->dma.device_free_chan_resources = txx9dmac_free_chan_resources;
+	dc->dma.device_terminate_all = txx9dmac_terminate_all;
+	dc->dma.device_is_tx_complete = txx9dmac_is_tx_complete;
+	dc->dma.device_issue_pending = txx9dmac_issue_pending;
+	if (pdata && pdata->memcpy_chan == ch) {
+		dc->dma.device_prep_dma_memcpy = txx9dmac_prep_dma_memcpy;
+		dma_cap_set(DMA_MEMCPY, dc->dma.cap_mask);
+	} else {
+		dc->dma.device_prep_slave_sg = txx9dmac_prep_slave_sg;
+		dma_cap_set(DMA_SLAVE, dc->dma.cap_mask);
+		dma_cap_set(DMA_PRIVATE, dc->dma.cap_mask);
+	}
+
+	INIT_LIST_HEAD(&dc->dma.channels);
+#ifdef TXX9_DMA_HAVE_IRQ_PER_CHAN
+	irq = platform_get_irq(dmac_dev, 0);
+	if (irq < 0)
+		return irq;
+	tasklet_init(&dc->tasklet, txx9dmac_tasklet, (unsigned long)dc);
+	dc->irq = irq + ch;
+	err = devm_request_irq(&pdev->dev, dc->irq, txx9dmac_interrupt,
+			       0, dev_name(&pdev->dev), dc);
+	if (err)
+		return err;
+#else
+	dc->ddev->chan[ch] = dc;
+#endif
+	dc->chan.device = &dc->dma;
+	list_add_tail(&dc->chan.device_node, &dc->chan.device->channels);
+	dc->chan.cookie = dc->completed = 1;
+
+	dc->ddev = platform_get_drvdata(dmac_dev);
+	dc->ch_regs = &__txx9dmac_regs(dc->ddev)->CHAN[ch];
+	spin_lock_init(&dc->lock);
+
+	INIT_LIST_HEAD(&dc->active_list);
+	INIT_LIST_HEAD(&dc->queue);
+	INIT_LIST_HEAD(&dc->free_list);
+
+	txx9dmac_reset_chan(dc);
+
+	platform_set_drvdata(pdev, dc);
+
+	err = dma_async_device_register(&dc->dma);
+	if (err)
+		return err;
+	dev_dbg(&pdev->dev, "TXx9 DMA Channel (dma%d%s%s)\n",
+		dc->dma.dev_id,
+		dma_has_cap(DMA_MEMCPY, dc->dma.cap_mask) ? " memcpy" : "",
+		dma_has_cap(DMA_SLAVE, dc->dma.cap_mask) ? " slave" : "");
+
+	return 0;
+}
+
+static int __exit txx9dmac_chan_remove(struct platform_device *pdev)
+{
+	struct txx9dmac_chan *dc = platform_get_drvdata(pdev);
+
+	dma_async_device_unregister(&dc->dma);
+#ifdef TXX9_DMA_HAVE_IRQ_PER_CHAN
+	tasklet_kill(&dc->tasklet);
+#else
+	dc->ddev->chan[pdev->id % TXX9_DMA_MAX_NR_CHANNELS] = NULL;
+#endif
+	return 0;
+}
+
+static int __init txx9dmac_probe(struct platform_device *pdev)
+{
+	struct txx9dmac_platform_data *pdata = pdev->dev.platform_data;
+	struct resource *io;
+	struct txx9dmac_dev *ddev;
+	u32 mcr;
+#ifndef TXX9_DMA_HAVE_IRQ_PER_CHAN
+	int irq;
+	int err;
+#endif
+
+	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!io)
+		return -EINVAL;
+
+	ddev = devm_kzalloc(&pdev->dev, sizeof(*ddev), GFP_KERNEL);
+	if (!ddev)
+		return -ENOMEM;
+
+	if (!devm_request_mem_region(&pdev->dev, io->start, resource_size(io),
+				     dev_name(&pdev->dev)))
+		return -EBUSY;
+
+	ddev->regs = devm_ioremap(&pdev->dev, io->start, resource_size(io));
+	if (!ddev->regs)
+		return -ENOMEM;
+#ifdef TXX9_DMA_MAY_HAVE_64BIT_REGS
+	ddev->have_64bit_regs = pdata->have_64bit_regs;
+#endif
+	if (__is_dmac64(ddev))
+		ddev->descsize = sizeof(struct txx9dmac_hwdesc);
+	else
+		ddev->descsize = sizeof(struct txx9dmac_hwdesc32);
+
+	/* force dma off, just in case */
+	txx9dmac_off(ddev);
+
+#ifndef TXX9_DMA_HAVE_IRQ_PER_CHAN
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+	tasklet_init(&ddev->tasklet, txx9dmac_tasklet, (unsigned long)ddev);
+	ddev->irq = irq;
+	err = devm_request_irq(&pdev->dev, irq, txx9dmac_interrupt, 0,
+			       dev_name(&pdev->dev), ddev);
+	if (err)
+		return err;
+#endif
+
+	mcr = TXX9_DMA_MCR_MSTEN;
+#if !defined(TXX9_DMA_HAVE_CCR_LE) && defined(__LITTLE_ENDIAN)
+	mcr |= TXX9_DMA_MCR_LE;
+#endif
+	if (pdata && pdata->memcpy_chan >= 0)
+		mcr |= TXX9_DMA_MCR_FIFUM(pdata->memcpy_chan);
+	dma_writel(ddev, MCR, mcr);
+
+	platform_set_drvdata(pdev, ddev);
+	return 0;
+}
+
+static int __exit txx9dmac_remove(struct platform_device *pdev)
+{
+	struct txx9dmac_dev *ddev = platform_get_drvdata(pdev);
+
+	txx9dmac_off(ddev);
+#ifndef TXX9_DMA_HAVE_IRQ_PER_CHAN
+	tasklet_kill(&ddev->tasklet);
+#endif
+	return 0;
+}
+
+static void txx9dmac_shutdown(struct platform_device *pdev)
+{
+	struct txx9dmac_dev *ddev = platform_get_drvdata(pdev);
+
+	txx9dmac_off(ddev);
+}
+
+static int txx9dmac_suspend_late(struct platform_device *pdev,
+				 pm_message_t mesg)
+{
+	struct txx9dmac_dev *ddev = platform_get_drvdata(pdev);
+
+	txx9dmac_off(ddev);
+	return 0;
+}
+
+static int txx9dmac_resume_early(struct platform_device *pdev)
+{
+	struct txx9dmac_dev *ddev = platform_get_drvdata(pdev);
+	struct txx9dmac_platform_data *pdata = pdev->dev.platform_data;
+	u32 mcr;
+
+	mcr = TXX9_DMA_MCR_MSTEN;
+#if !defined(TXX9_DMA_HAVE_CCR_LE) && defined(__LITTLE_ENDIAN)
+	mcr |= TXX9_DMA_MCR_LE;
+#endif
+	if (pdata && pdata->memcpy_chan >= 0)
+		mcr |= TXX9_DMA_MCR_FIFUM(pdata->memcpy_chan);
+	dma_writel(ddev, MCR, mcr);
+	return 0;
+
+}
+
+static struct platform_driver txx9dmac_chan_driver = {
+	.remove		= __exit_p(txx9dmac_chan_remove),
+	.driver = {
+		.name	= "txx9dmac-chan",
+	},
+};
+
+static struct platform_driver txx9dmac_driver = {
+	.remove		= __exit_p(txx9dmac_remove),
+	.shutdown	= txx9dmac_shutdown,
+	.suspend_late	= txx9dmac_suspend_late,
+	.resume_early	= txx9dmac_resume_early,
+	.driver = {
+		.name	= "txx9dmac",
+	},
+};
+
+static int __init txx9dmac_init(void)
+{
+	int rc;
+
+	rc = platform_driver_probe(&txx9dmac_driver, txx9dmac_probe);
+	if (!rc) {
+		rc = platform_driver_probe(&txx9dmac_chan_driver,
+					   txx9dmac_chan_probe);
+		if (rc)
+			platform_driver_unregister(&txx9dmac_driver);
+	}
+	return rc;
+}
+module_init(txx9dmac_init);
+
+static void __exit txx9dmac_exit(void)
+{
+	platform_driver_unregister(&txx9dmac_chan_driver);
+	platform_driver_unregister(&txx9dmac_driver);
+}
+module_exit(txx9dmac_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("TXx9 DMA Controller driver");
+MODULE_AUTHOR("Atsushi Nemoto <anemo@mba.ocn.ne.jp>");
-- 
1.5.6.3

