Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbYCPVXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbYCPVXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 17:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYCPVXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 17:23:01 -0400
Received: from lixom.net ([66.141.50.11]:50145 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbYCPVW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 17:22:59 -0400
Date: Sun, 16 Mar 2008 16:30:02 -0500
From: Olof Johansson <olof@lixom.net>
To: dan.j.williams@intel.com, shannon.nelson@intel.com
Cc: linux-kernel@vger.kernel.org, pasemi-linux@ozlabs.org,
       linuxppc-dev@ozlabs.org, hskinnemoen@atmel.com
Subject: [PATCH v2] pasemi_dma: Driver for PA Semi PWRficient on-chip DMA
	engine
Message-ID: <20080316213002.GA2589@lixom.net>
References: <20080306233900.GA3969@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306233900.GA3969@lixom.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pasemi_dma: Driver for PA Semi PWRficient on-chip DMA engine

DMA copy offload driver for PA Semi PWRficient. It uses the
platform-specific functions to allocate channels, etc.

Signed-off-by: Olof Johansson <olof@lixom.net>

---

Changes since last post:

* Add DMA_INTERRUPT support and handling of the interrupt flag
* Fix interrupt handler for above and add tasklet
* Switch to spin_lock_bh() where possible
* Remove empty dependency_added() function since it's no longer
  used in the framework.
* Fix bug in "ring full" estimation.

Note that this still needs to go on top of the powerpc.git tree due to the
pasemi_dma.h updates that this driver depends on. I suggest merging this
through pasemi.git->powerpc.git->linus with an Acked-by from the DMA guys.


-Olof

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index a703def..e4fd7e5 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -37,6 +37,13 @@ config INTEL_IOP_ADMA
 	help
 	  Enable support for the Intel(R) IOP Series RAID engines.
 
+config PASEMI_DMA
+	tristate "PA Semi DMA Engine support"
+	depends on PPC_PASEMI
+	select DMA_ENGINE
+	help
+	  Enable support for the DMA Engine on PA Semi PWRficient SoCs
+
 config DMA_ENGINE
 	bool
 
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index b152cd8..72bf45c 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_NET_DMA) += iovlock.o
 obj-$(CONFIG_INTEL_IOATDMA) += ioatdma.o
 ioatdma-objs := ioat.o ioat_dma.o ioat_dca.o
 obj-$(CONFIG_INTEL_IOP_ADMA) += iop-adma.o
+obj-$(CONFIG_PASEMI_DMA) += pasemi_dma.o
diff --git a/drivers/dma/pasemi_dma.c b/drivers/dma/pasemi_dma.c
new file mode 100644
index 0000000..ad6235b
--- /dev/null
+++ b/drivers/dma/pasemi_dma.c
@@ -0,0 +1,532 @@
+/*
+ * Driver for the PA Semi PWRficient DMA Engine (copy parts)
+ * Copyright (c) 2007,2008 Olof Johansson, PA Semi, Inc
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
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
+
+#include <asm/pasemi_dma.h>
+
+#define MAX_CH	16
+#define MAX_XFER 0x40000
+#define RING_SZ	8192
+
+struct pasemi_dma_desc {
+	u64			src;
+	u64			dest;
+	dma_addr_t		src_dma;
+	dma_addr_t		dest_dma;
+	size_t			len;
+	struct list_head	node;
+	enum dma_prep_flags	flags;
+	struct dma_async_tx_descriptor async_tx;
+	struct pasemi_dma_chan *chan;
+};
+
+struct pasemi_dma_chan {
+	struct pasemi_dmachan chan;
+	spinlock_t	   ring_lock;	/* Protects the ring only */
+	spinlock_t	   desc_lock;	/* Protects the descriptor list */
+	struct pasemi_dma *dma_dev;
+	struct pasemi_dma_desc *ring_info[RING_SZ]; /* softc */
+	unsigned int	   next_to_fill;
+	unsigned int	   next_to_clean;
+	struct dma_chan	   common;
+	struct list_head   free_desc;
+	int		   desc_count;
+	int		   in_use;
+	struct tasklet_struct tasklet;
+};
+
+struct pasemi_dma {
+	struct pci_dev *pdev;
+	struct dma_device common;
+	struct pasemi_dma_chan *chans[MAX_CH];
+};
+
+static unsigned int channels = 4;
+module_param(channels, uint, S_IRUGO);
+MODULE_PARM_DESC(channels, "Number of channels for copy (default: 2)");
+
+#define to_pasemi_dma_chan(chan) container_of(chan, struct pasemi_dma_chan, \
+					      common)
+#define to_pasemi_dma_desc(lh) container_of(lh, struct pasemi_dma_desc, node)
+#define tx_to_desc_sw(tx) container_of(tx, struct pasemi_dma_desc, async_tx)
+
+static void pasemi_dma_clean(struct pasemi_dma_chan *chan)
+{
+	int old, new, i;
+	struct pasemi_dma_desc *desc;
+	dma_async_tx_callback callback;
+
+restart:
+	spin_lock_bh(&chan->desc_lock);
+
+	old = chan->next_to_clean;
+
+	new = *chan->chan.status & PAS_STATUS_PCNT_M;
+	new <<= 2;
+	new &= (RING_SZ-1);
+
+	if (old > new)
+		new += RING_SZ;
+
+	for (i = old; i < new; i += 4) {
+		if (unlikely(chan->chan.ring_virt[i & (RING_SZ-1)] & XCT_COPY_O))
+			break;
+		desc = chan->ring_info[i & (RING_SZ-1)];
+
+		callback = desc->async_tx.callback;
+		if (callback) {
+			/* Can't re-lock and just loop, since another cpu
+			 * might have came in here while we released the lock.
+			 * Instead, start all over again to re-read status words.
+			 */
+			chan->next_to_clean = i & (RING_SZ-1);
+			spin_unlock_bh(&chan->desc_lock);
+			callback(desc->async_tx.callback_param);
+			goto restart;
+		}
+
+		list_add_tail(&desc->node, &chan->free_desc);
+	}
+
+	chan->next_to_clean = i & (RING_SZ-1);
+
+	spin_unlock_bh(&chan->desc_lock);
+}
+
+static void pasemi_dma_tasklet(unsigned long data)
+{
+	struct pasemi_dma_chan *chan = (struct pasemi_dma_chan *)data;
+
+	pasemi_dma_clean(chan);
+}
+
+static int pasemi_dma_intr(int irq, void *data)
+{
+	struct pasemi_dma_chan *dma_chan = data;
+	const struct pasemi_dmachan *chan = &dma_chan->chan;
+	u64 status;
+	unsigned int reg;
+
+	status = *chan->status;
+
+	if (!(status & PAS_STATUS_CAUSE_M))
+		return IRQ_NONE;
+
+	reg = PAS_IOB_DMA_TXCH_RESET_PINTC | 
+		S_IOB_DMA_RXCH_RESET_PCNT(status & PAS_STATUS_PCNT_M);
+
+	if (status & PAS_STATUS_SOFT)
+		reg |= PAS_IOB_DMA_TXCH_RESET_SINTC;
+	if (status & PAS_STATUS_ERROR)
+		reg |= PAS_IOB_DMA_TXCH_RESET_DINTC;
+
+	tasklet_schedule(&dma_chan->tasklet);
+
+	if (reg)
+		pasemi_write_iob_reg(PAS_IOB_DMA_TXCH_RESET(chan->chno), reg);
+
+	return IRQ_HANDLED;
+}
+
+static int pasemi_dma_alloc_chan_resources(struct dma_chan *chan)
+{
+	struct pasemi_dma_chan *ch = to_pasemi_dma_chan(chan);
+	u32 val;
+	unsigned int cfg;
+	int ret, chno;
+
+	if (ch->in_use)
+		return RING_SZ;
+
+	spin_lock_init(&ch->ring_lock);
+	spin_lock_init(&ch->desc_lock);
+
+	chno = ch->chan.chno;
+
+	ret = pasemi_dma_alloc_ring(&ch->chan, RING_SZ);
+	if (ret) {
+		printk(KERN_INFO "pasemi_dma: Failed to allocate descriptor ring: %d\n", ret);
+		return ret;
+	}
+
+	ch->in_use = 1;
+
+	/* Set CNTTH to something large since we don't want to use count-based
+	 * interrupts, but we still need to take them.
+	 */
+	pasemi_write_iob_reg(PAS_IOB_DMA_TXCH_CFG(chno),
+			     PAS_IOB_DMA_TXCH_CFG_CNTTH(0xfff));
+
+	pasemi_write_iob_reg(PAS_IOB_DMA_TXCH_RESET(chno), 0x30);
+
+	pasemi_write_dma_reg(PAS_DMA_TXCHAN_BASEL(chno),
+			   PAS_DMA_TXCHAN_BASEL_BRBL(ch->chan.ring_dma));
+
+	val = PAS_DMA_TXCHAN_BASEU_BRBH(ch->chan.ring_dma >> 32);
+	val |= PAS_DMA_TXCHAN_BASEU_SIZ(ch->chan.ring_size >> 3);
+
+	pasemi_write_dma_reg(PAS_DMA_TXCHAN_BASEU(chno), val);
+
+	cfg = PAS_DMA_TXCHAN_CFG_TY_COPY |
+	      PAS_DMA_TXCHAN_CFG_UP |
+	      PAS_DMA_TXCHAN_CFG_LPDQ |
+	      PAS_DMA_TXCHAN_CFG_LPSQ |
+	      PAS_DMA_TXCHAN_CFG_WT(4);
+
+	pasemi_write_dma_reg(PAS_DMA_TXCHAN_CFG(chno), cfg);
+
+	pasemi_dma_start_chan(&ch->chan, PAS_DMA_TXCHAN_TCMDSTA_SZ |
+			     PAS_DMA_TXCHAN_TCMDSTA_DB |
+			     PAS_DMA_TXCHAN_TCMDSTA_DE |
+			     PAS_DMA_TXCHAN_TCMDSTA_DA);
+
+	ch->next_to_fill = 0;
+	ch->next_to_clean = 0;
+	ch->desc_count = 0;
+
+	return ch->chan.ring_size/4;
+}
+
+static void pasemi_dma_free_chan_resources(struct dma_chan *chan)
+{
+	struct pasemi_dma_chan *ch = to_pasemi_dma_chan(chan);
+
+	if (ch->in_use)
+		pasemi_dma_free_ring(&ch->chan);
+
+	ch->in_use = 0;
+
+	return;
+}
+
+static enum dma_status pasemi_dma_is_complete(struct dma_chan *chan,
+					      dma_cookie_t cookie,
+					      dma_cookie_t *done,
+					      dma_cookie_t *used)
+{
+	struct pasemi_dma_chan *ch = to_pasemi_dma_chan(chan);
+	dma_cookie_t clean, fill;
+	int tries = 1;
+	enum dma_status ret;
+
+	pasemi_dma_clean(ch);
+
+	do {
+		clean = (ch->next_to_clean - 4) & (RING_SZ-1);
+		fill = (ch->next_to_fill - 1) & (RING_SZ-1) ;
+
+		if (done)
+			*done = clean;
+		if (used)
+			*used = fill;
+
+		ret = dma_async_is_complete(cookie, clean, fill);
+	} while (ret != DMA_SUCCESS && --tries);
+
+	return ret;
+}
+
+
+static void pasemi_dma_issue_pending(struct dma_chan *chan)
+{
+	return;
+}
+
+
+static dma_cookie_t
+pasemi_tx_submit_memcpy(struct dma_async_tx_descriptor *tx)
+{
+	struct pasemi_dma_desc *desc = tx_to_desc_sw(tx);
+	struct pasemi_dma_chan *chan = desc->chan;
+	u64 xct[4], *ring;
+	int idx, len;
+
+	len = desc->len;
+	if (unlikely(!len)) {
+		xct[0] = XCT_COPY_DTY_PREF;
+		len = 1;
+	} else
+		xct[0] = 0;
+
+	/* Check if interrupt was requested */
+	if (desc->flags & DMA_PREP_INTERRUPT) 
+		xct[0] |= XCT_COPY_I;
+
+	xct[0] |= XCT_COPY_O | XCT_COPY_LLEN(len);
+	xct[1]  = XCT_PTR_LEN(len) | XCT_PTR_ADDR(desc->dest) | XCT_PTR_T;
+	xct[2]  = XCT_PTR_LEN(len) | XCT_PTR_ADDR(desc->src);
+	xct[3]  = 0;
+
+	spin_lock_bh(&chan->ring_lock);
+
+	idx = chan->next_to_fill;
+
+	ring = chan->chan.ring_virt;
+
+	/* This is where we copy stuff to the ring */
+
+	ring[idx & (RING_SZ-1)] = xct[0];
+	ring[(idx+1) & (RING_SZ-1)] = xct[1];
+	ring[(idx+2) & (RING_SZ-1)] = xct[2];
+	ring[(idx+3) & (RING_SZ-1)] = xct[3];
+
+	chan->next_to_fill = (chan->next_to_fill + 4) & (RING_SZ-1);
+
+	chan->ring_info[idx] = desc;
+
+	pasemi_write_dma_reg(PAS_DMA_TXCHAN_INCR(chan->chan.chno), 2);
+
+	spin_unlock_bh(&chan->ring_lock);
+	return idx;
+}
+
+static struct pasemi_dma_desc *
+pasemi_dma_alloc_descriptor(struct pasemi_dma_chan *ch, gfp_t flags)
+{
+	struct pasemi_dma_desc *desc;
+	int retries;
+
+retry:
+	spin_lock_bh(&ch->desc_lock);
+
+	if (!list_empty(&ch->free_desc)) {
+		desc = list_entry(ch->free_desc.next, struct pasemi_dma_desc,
+				  node);
+		list_del(&desc->node);
+		spin_unlock_bh(&ch->desc_lock);
+		return desc;
+	}
+
+	if (ch->desc_count >= (RING_SZ/4)) {
+		spin_unlock_bh(&ch->desc_lock);
+		if (!retries++) {
+			pasemi_dma_clean(ch);
+			goto retry;
+		}
+		return NULL;
+	}
+	ch->desc_count++;
+	spin_unlock_bh(&ch->desc_lock);
+
+	/* try to get another desc */
+	desc = kzalloc(sizeof(*desc), flags);
+	if (unlikely(!desc))
+		return NULL;
+
+	dma_async_tx_descriptor_init(&desc->async_tx, &ch->common);
+	desc->chan = ch;
+	INIT_LIST_HEAD(&desc->async_tx.tx_list);
+
+	/* will this ever happen? */
+	BUG_ON(!desc);
+
+	return desc;
+}
+
+static struct dma_async_tx_descriptor *
+pasemi_dma_prep_memcpy(struct dma_chan *chan, dma_addr_t dma_dest,
+		       dma_addr_t dma_src, size_t len, unsigned long flags)
+{
+	struct pasemi_dma_chan *ch = to_pasemi_dma_chan(chan);
+	struct pasemi_dma_desc *desc;
+
+	if (len >= MAX_XFER) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING "pasemi_dma: Copy request too long (%ld > %d)\n",
+			       len, MAX_XFER);
+		return NULL;
+	}
+
+	desc = pasemi_dma_alloc_descriptor(ch, GFP_KERNEL);
+	if (!desc)
+		return NULL;
+
+	desc->async_tx.tx_submit = pasemi_tx_submit_memcpy;
+	desc->len = len;
+	desc->dest = dma_dest;
+	desc->src = dma_src;
+	desc->flags = flags;
+
+	return &desc->async_tx;
+}
+
+/* The DMA API assumes there's a way to create an "interrupt only" descriptor.
+ * Our DMA engine doesn't have that concept, so let's create a dummy 1-byte
+ * prefetch descriptor just like 0-size memcpy, but with the _SE and _I bit set.
+ */
+static struct dma_async_tx_descriptor *
+pasemi_dma_prep_interrupt(struct dma_chan *chan)
+{
+	dma_addr_t dummy = to_pasemi_dma_chan(chan)->chan.ring_dma;
+
+	return pasemi_dma_prep_memcpy(chan, dummy, dummy, 0, DMA_PREP_INTERRUPT);
+}
+
+static int enumerate_dma_channels(struct pasemi_dma *device)
+{
+	int i, ret;
+	struct pasemi_dma_chan *ch;
+
+	device->common.chancnt = channels;
+
+	for (i = 0; i < device->common.chancnt; i++) {
+		ch = pasemi_dma_alloc_chan(TXCHAN, sizeof(*ch),
+					   offsetof(struct pasemi_dma_chan,
+						    chan));
+		ch->dma_dev = device;
+		ch->common.device = &device->common;
+		tasklet_init(&ch->tasklet, pasemi_dma_tasklet, (unsigned long)ch);
+		ret = request_irq(ch->chan.irq, &pasemi_dma_intr, IRQF_DISABLED,
+				  "pasemi_dma", ch);
+		if (ret) {
+			printk(KERN_INFO "pasemi_dma: request of irq %d failed: %d\n",
+			       ch->chan.irq, ret);
+			return ret;
+		}
+		INIT_LIST_HEAD(&ch->free_desc);
+		list_add_tail(&ch->common.device_node,
+			      &device->common.channels);
+	}
+	return device->common.chancnt;
+}
+
+static int __devinit pasemi_dma_probe(struct pci_dev *pdev,
+				      const struct pci_device_id *ent)
+{
+	int err;
+	struct pasemi_dma *device;
+	struct dma_device *dma_dev;
+
+	err = pci_enable_device(pdev);
+	if (err)
+		goto err_enable_device;
+
+	device = kzalloc(sizeof(*device), GFP_KERNEL);
+	if (!device) {
+		err = -ENOMEM;
+		goto err_kzalloc;
+	}
+
+	device->pdev = pdev;
+	pci_set_drvdata(pdev, device);
+
+	dma_dev = &device->common;
+
+	INIT_LIST_HEAD(&dma_dev->channels);
+	enumerate_dma_channels(device);
+
+	dma_cap_set(DMA_MEMCPY, dma_dev->cap_mask);
+	dma_cap_set(DMA_INTERRUPT, dma_dev->cap_mask);
+	dma_dev->device_alloc_chan_resources = pasemi_dma_alloc_chan_resources;
+	dma_dev->device_free_chan_resources = pasemi_dma_free_chan_resources;
+	dma_dev->device_prep_dma_memcpy = pasemi_dma_prep_memcpy;
+	dma_dev->device_prep_dma_interrupt = pasemi_dma_prep_interrupt;
+	dma_dev->device_is_tx_complete = pasemi_dma_is_complete;
+	dma_dev->device_issue_pending = pasemi_dma_issue_pending;
+	dma_dev->dev = &pdev->dev;
+
+	printk(KERN_INFO "PA Semi DMA Engine found, using %d channels for copy\n",
+		dma_dev->chancnt);
+
+	err = dma_async_device_register(dma_dev);
+
+	return err;
+
+err_kzalloc:
+	pci_disable_device(pdev);
+err_enable_device:
+
+	printk(KERN_ERR "PA Semi DMA Engine initialization failed\n");
+
+	return err;
+}
+
+static void pasemi_dma_shutdown(struct pci_dev *pdev)
+{
+	struct pasemi_dma *device;
+	device = pci_get_drvdata(pdev);
+
+	dma_async_device_unregister(&device->common);
+}
+
+static void __devexit pasemi_dma_remove(struct pci_dev *pdev)
+{
+	struct pasemi_dma *device;
+	struct dma_chan *chan, *_chan;
+	struct pasemi_dma_chan *pasemi_ch;
+
+	device = pci_get_drvdata(pdev);
+	dma_async_device_unregister(&device->common);
+
+	list_for_each_entry_safe(chan, _chan, &device->common.channels,
+				 device_node) {
+		pasemi_ch = to_pasemi_dma_chan(chan);
+		free_irq(pasemi_ch->chan.irq, pasemi_ch);
+		list_del(&chan->device_node);
+		pasemi_dma_free_chan(&pasemi_ch->chan);
+	}
+
+	pci_disable_device(pdev);
+	kfree(device);
+}
+
+static struct pci_device_id pasemi_dma_pci_tbl[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_PASEMI, 0xa007) },
+	{ }
+};
+MODULE_DEVICE_TABLE(pci, pasemi_dma_pci_tbl);
+
+static struct pci_driver pasemi_dma_pci_driver = {
+	.name	= "pasemi_dma",
+	.id_table = pasemi_dma_pci_tbl,
+	.probe	= pasemi_dma_probe,
+	.shutdown = pasemi_dma_shutdown,
+	.remove	= __devexit_p(pasemi_dma_remove),
+};
+
+
+static int __init pasemi_dma_init_module(void)
+{
+	int err;
+
+	err = pasemi_dma_init();
+	if (err)
+		return err;
+
+	return pci_register_driver(&pasemi_dma_pci_driver);
+}
+
+module_init(pasemi_dma_init_module);
+
+static void __exit pasemi_dma_exit_module(void)
+{
+	pci_unregister_driver(&pasemi_dma_pci_driver);
+}
+
+module_exit(pasemi_dma_exit_module);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Olof Johansson <olof@lixom.net>");
+MODULE_DESCRIPTION("PA Semi PWRficient DMA Engine driver");
