Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbYIYG3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbYIYG3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 02:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYIYG33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 02:29:29 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:49713 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbYIYG31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 02:29:27 -0400
Date: Thu, 25 Sep 2008 08:29:24 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, Alex Dubov <oakad@yahoo.com>
Subject: RFC: Driver for CB710/720 memory card reader (MMC part) - v2
Message-ID: <20080925062924.GA32105@rere.qmqm.pl>
References: <20080907215228.GA19193@rere.qmqm.pl> <20080909091800.37eccc0f@mjolnir.drzeus.cx> <20080909090613.GA22158@rere.qmqm.pl> <20080911201307.GA31730@rere.qmqm.pl> <20080912234302.GA19230@rere.qmqm.pl> <20080920130006.69d50cbb@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080920130006.69d50cbb@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thanks for your comments, Pierre - I have applied most of your
suggestions and replied to some below.

Changes in this version:
 - power management functions;
 - IRQ handler modifications: core driver uses RCU, MMC-specific handler
   uses spinlock only in the uncommon case of 'test' interrupt;
 - debugging printks converted to dev_dbg() and friends;
 - code split to files such that MMC specific parts are self-contained

This should be almost ready. mmc-test passes up to a point where it
tries non-sector-size writes to the card - I didn't have time to look
into this further, yet.

On Sat, Sep 20, 2008 at 01:00:06PM +0200, Pierre Ossman wrote:
> On Sat, 13 Sep 2008 01:43:02 +0200
> Micha³ Miros³aw <mirq-linux@rere.qmqm.pl> wrote:
> > +#define RDPORT(t, p) \
> > +	ioread##t(chip->iobase + (p))
[and other such functions]
> This is a pretty bad case of obfuscation. Don't construct macros that
> reference local variables (chip in this case). Also,
> iowrite16_rep(chip->iobase + CB700_FOO, buffer, 12); is quite readable
> as it is. Using standard kernel functions allows your code to be more
> accessible to other kernel hackers.

Sure. This was an attempt at imitating Perl-ish dynamically scoped
package-local variable. ;-)

> > +/* sg-to-PIO buffer */
[and its API]
> Why this complex system? Can't you use the handlers the kernel already
> provides? You also get a lot of special handling with those, e.g.
> highmem.

I looked at linux/lib/scatterlist.c and found nothing really useful. If
there were some preconditions always met for scatterlists - like that block
does not span multiple pages, or at least 16-byte block don't, then most
of this code can go away. It looks complicated, because it implements
a special iterator interface that always returns multiple-of-16-byte blocks
for reading or writing. This makes the PIO loops very simple and fast
(the bounce_buffer case was never triggered by mmc-block in my tests).

> > diff -urN empty/Makefile cb710-pre-20080913/Makefile
> > --- empty/Makefile	1970-01-01 01:00:00.000000000 +0100
> > +++ cb710-pre-20080913/Makefile	2008-09-12 20:56:39.000000000 +0200
> It's easier if you develop against the real kernel tree and send diffs
> for that.

Hmm. For me it was easier to have the driver out-of-tree, as it's
rebuilding went faster and all files are at hand. I will of course
make a proper diff against vanilla kernel when it's ready to go in.
I've put a .tgz at my server to make it easier for those that wan't
to test the driver with other kernel versions.

> > +static void cb710_mmc_enable_irq(struct cb710_chip *chip, int enable)
> > +{
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&chip->irq_lock, flags);
> > +	__cb710_mmc_enable_irq(chip, enable);
> > +	spin_unlock_irqrestore(&chip->irq_lock, flags);
> > +}
> This is a fairly useless wrapper. Look over how it is called instead.

Can you expand on this? Right now irq handler doesn't call
__cb710_mmc_enable_irq() but modifies registers itself. This will
change eventually.

> > +	if (flags & MMC_RSP_PRESENT) {
> > +		/* Windows driver set 01 at bits 4,3 except for
> > +		 * MMC_SET_BLOCKLEN. I assume that 00 here means no
> > +		 * response is expected.
> > +		 */
> > +		if (cmd->opcode != MMC_SET_BLOCKLEN)
> > +			cb_flags |= CB710_MMC_RSP_PRESENT;
> > +		else
> > +			cb_flags |= CB710_MMC_RSP_PRESENT_X;
> Looking at the opcode is not acceptable, so you need to figure out
> what's really going on here. MMC_SET_BLOCKLEN has a common R1 response,
> so I don't know why the Windows driver special treated it.

I removed this special-case for now and it still works.

> > +	if (rsp_opcode != ((cmd->flags & MMC_RSP_OPCODE) ? cmd->opcode : 0x3F))
> > +		cmd->error = -EILSEQ;
> This isn't terribly readable. Something like this would be better:
> 	if (cmd->flags & MMC_RSP_OPCODE) {
> 		if (rsp_opcode != cmd->opcode)
> 			cmd->error = -EILSEQ;
> 	} else {
> 		if (rsp_opcode != 0x3F)
> 			cmd->error = -EILSEQ;
> 	}

That's a lot of lines. I used another variable to make it clearer.

Thanks again for your comments,
Micha³ Miros³aw


diff -urN empty/cb710.h cb710/cb710.h
--- empty/cb710.h	1970-01-01 01:00:00.000000000 +0100
+++ cb710/cb710.h	2008-09-25 07:07:40.000000000 +0200
@@ -0,0 +1,131 @@
+/*
+ *  cb710/cb710.h
+ *
+ *  Copyright by Micha³ Miros³aw, 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef LINUX_CB710_DRIVER_H
+#define LINUX_CB710_DRIVER_H
+
+#include <linux/spinlock.h>
+#include <linux/mmc/host.h>
+#include <linux/pci.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+
+#define CB710_DRIVER_NAME "cb710"
+
+struct cb710_slot;
+
+typedef int (*cb710_irq_handler_t)(struct cb710_slot *);
+
+/* per-virtual-slot structure */
+struct cb710_slot {
+	struct platform_device	pdev;
+	void __iomem		*iobase;
+	cb710_irq_handler_t	irq_handler;	/* RCU */
+};
+
+/* per-device structure */
+struct cb710_chip {
+	struct pci_dev		*pdev;
+	void __iomem		*iobase;
+	unsigned		platform_id;
+	atomic_t		slots;		/* RCU */
+	unsigned		slot_mask;
+	struct cb710_slot	slot[0];
+};
+
+/* NOTE: cb710_chip.slots is modified only during device init/exit */
+
+/* cb710_chip.slot_mask values */
+#define CB710_SLOT_MMC		1
+#define CB710_SLOT_MS		2
+#define CB710_SLOT_SM		4
+
+/* slot port accessors - in case it turns out inX() is all that is needed */
+#define CB710_PORT_ACCESSORS(t) \
+static inline void cb710_write_port_##t(struct cb710_slot *slot,	\
+	unsigned port, u##t value)					\
+{									\
+	iowrite##t(value, slot->iobase + port);				\
+}									\
+									\
+static inline u##t cb710_read_port_##t(struct cb710_slot *slot,		\
+	unsigned port)							\
+{									\
+	return ioread##t(slot->iobase + port);				\
+}									\
+									\
+static inline void cb710_modify_port_##t(struct cb710_slot *slot,	\
+	unsigned port, u##t set, u##t clear)				\
+{									\
+	iowrite##t(							\
+		(ioread##t(slot->iobase + port) & ~clear)|set,		\
+		slot->iobase + port);					\
+}
+
+CB710_PORT_ACCESSORS(8)
+CB710_PORT_ACCESSORS(16)
+CB710_PORT_ACCESSORS(32)
+
+void cb710_pci_update_config_reg(struct pci_dev *pdev,
+	int reg, uint32_t and, uint32_t xor);
+
+/* some device struct walking */
+
+static inline struct cb710_slot *cb710_pdev_to_slot(
+	struct platform_device *pdev)
+{
+	return container_of(pdev, struct cb710_slot, pdev);
+}
+
+static inline struct cb710_chip *cb710_slot_to_chip(struct cb710_slot *slot)
+{
+	return dev_get_drvdata(slot->pdev.dev.parent);
+}
+
+static inline struct device *cb710_slot_dev(struct cb710_slot *slot)
+{
+	return &slot->pdev.dev;
+}
+
+static inline struct device *cb710_chip_dev(struct cb710_chip *chip)
+{
+	return &chip->pdev->dev;
+}
+
+/* helper functions */
+
+static inline void cb710_set_irq_handler(struct cb710_slot *slot,
+	cb710_irq_handler_t handler)
+{
+	rcu_assign_pointer(slot->irq_handler, handler);
+	synchronize_rcu();	/* sync to IRQ handler */
+}
+
+/* debugging aids */
+
+#ifdef DEBUG
+void cb710_dump_regs(struct cb710_chip *chip, unsigned dump);
+#else
+#define cb710_dump_regs(c, d) do {} while (0)
+#endif
+
+#define CB710_DUMP_REGS_MMC	0x0F
+#define CB710_DUMP_REGS_MS	0x30
+#define CB710_DUMP_REGS_SM	0xC0
+#define CB710_DUMP_REGS_ALL	0xFF
+#define CB710_DUMP_REGS_MASK	0xFF
+
+#define CB710_DUMP_ACCESS_8	0x100
+#define CB710_DUMP_ACCESS_16	0x200
+#define CB710_DUMP_ACCESS_32	0x400
+#define CB710_DUMP_ACCESS_ALL	0x700
+#define CB710_DUMP_ACCESS_MASK	0x700
+
+#endif /* LINUX_CB710_DRIVER_H */
diff -urN empty/cb710-mmc.h cb710/cb710-mmc.h
--- empty/cb710-mmc.h	1970-01-01 01:00:00.000000000 +0100
+++ cb710/cb710-mmc.h	2008-09-25 05:37:51.000000000 +0200
@@ -0,0 +1,114 @@
+/*
+ *  cb710/cb710-mmc.h
+ *
+ *  Copyright by Micha³ Miros³aw, 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef LINUX_CB710_MMC_H
+#define LINUX_CB710_MMC_H
+
+#include <linux/spinlock.h>
+#include <linux/mmc/host.h>
+#include <linux/pci.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include "cb710.h"
+
+/* per-MMC-reader structure */
+struct cb710_mmc_reader {
+	struct tasklet_struct finish_req_tasklet;
+	struct mmc_request *mrq;
+	spinlock_t irq_lock;
+	unsigned char last_power_mode;
+#ifdef VERBOSE_DEBUG
+	spinlock_t serialization_lock;
+	unsigned char active_req, active_ios;
+#endif
+};
+
+/* some device struct walking */
+
+static inline struct mmc_host *cb710_slot_to_mmc(struct cb710_slot *slot)
+{
+	return dev_get_drvdata(&slot->pdev.dev);
+}
+
+static inline struct cb710_slot *cb710_mmc_to_slot(struct mmc_host *mmc)
+{
+	struct platform_device *pdev = container_of(mmc_dev(mmc),
+		struct platform_device, dev);
+	return cb710_pdev_to_slot(pdev);
+}
+
+/* registers (this might be all wrong ;) */
+
+#define CB710_MMC_DATA_PORT		0x00
+
+#define CB710_MMC_CONFIG_PORT		0x04
+#define CB710_MMC_CONFIG0_PORT		0x04
+#define CB710_MMC_CONFIG1_PORT		0x05
+#define   CB710_MMC_C1_4BIT_DATA_BUS		0x40
+#define CB710_MMC_CONFIG2_PORT		0x06
+#define   CB710_MMC_C2_READ_PIO_SIZE_MASK	0x0F	/* N-1 */
+#define CB710_MMC_CONFIG3_PORT		0x07
+
+#define CB710_MMC_CONFIGB_PORT		0x08
+
+#define CB710_MMC_IRQ_ENABLE_PORT	0x0C
+#define   CB710_MMC_IE_CISTATUS_MASK		0x00009000
+#define CB710_MMC_IRQ_ENABLE0_PORT	0x0C
+#define CB710_MMC_IRQ_ENABLE1_PORT	0x0D
+#define   CB710_MMC_IE_IRQ_ENABLE		0x80
+#define   CB710_MMC_IE_CARD_INSERTION_STATUS	0x10
+
+#define CB710_MMC_STATUS_PORT		0x10
+#define   CB710_MMC_STATUS_ERROR_EVENTS		0x60FF
+#define CB710_MMC_STATUS0_PORT		0x10
+#define   CB710_MMC_S0_FIFO_UNDERFLOW		0x40
+#define CB710_MMC_STATUS1_PORT		0x11
+#define   CB710_MMC_S1_COMMAND_SENT		0x01
+#define   CB710_MMC_S1_DATA_TRANSFER_DONE	0x02
+#define   CB710_MMC_S1_PIO_TRANSFER_DONE	0x04
+#define   CB710_MMC_S1_CARD_CHANGED		0x10
+#define   CB710_MMC_S1_RESET			0x20
+#define CB710_MMC_STATUS2_PORT		0x12
+#define   CB710_MMC_S2_FIFO_READY		0x01
+#define   CB710_MMC_S2_FIFO_EMPTY		0x02
+#define   CB710_MMC_S2_BUSY_10			0x10
+#define   CB710_MMC_S2_BUSY_20			0x20
+#define CB710_MMC_STATUS3_PORT		0x13
+#define   CB710_MMC_S3_CARD_DETECTED		0x02
+#define   CB710_MMC_S3_WRITE_PROTECTED		0x04
+
+#define CB710_MMC_CMD_TYPE_PORT		0x14
+#define   CB710_MMC_RSP_TYPE_MASK		0x0007
+#define     CB710_MMC_RSP_R1			(0)
+#define     CB710_MMC_RSP_136			(5)
+#define     CB710_MMC_RSP_NO_CRC		(2)
+#define   CB710_MMC_RSP_PRESENT_MASK		0x0018
+#define     CB710_MMC_RSP_NONE			(0 << 3)
+#define     CB710_MMC_RSP_PRESENT		(1 << 3)
+#define     CB710_MMC_RSP_PRESENT_X		(2 << 3)
+#define   CB710_MMC_CMD_TYPE_MASK		0x0060
+#define     CB710_MMC_CMD_BC			(0 << 5)
+#define     CB710_MMC_CMD_BCR			(1 << 5)
+#define     CB710_MMC_CMD_AC			(2 << 5)
+#define     CB710_MMC_CMD_ADTC			(3 << 5)
+#define   CB710_MMC_DATA_READ			0x0080
+#define   CB710_MMC_CMD_CODE_MASK		0x3F00
+#define   CB710_MMC_CMD_CODE_SHIFT		8
+#define   CB710_MMC_IS_APP_CMD			0x4000
+#define   CB710_MMC_RSP_BUSY			0x8000
+
+#define CB710_MMC_CMD_PARAM_PORT	0x18
+#define CB710_MMC_TRANSFER_SIZE_PORT	0x1C
+#define CB710_MMC_RESPONSE0_PORT	0x20
+#define CB710_MMC_RESPONSE1_PORT	0x24
+#define CB710_MMC_RESPONSE2_PORT	0x28
+#define CB710_MMC_RESPONSE3_PORT	0x2C
+
+#endif /* LINUX_CB710_MMC_H */
diff -urN empty/cb710-sg.h cb710/cb710-sg.h
--- empty/cb710-sg.h	1970-01-01 01:00:00.000000000 +0100
+++ cb710/cb710-sg.h	2008-09-21 16:47:47.000000000 +0200
@@ -0,0 +1,49 @@
+/*
+ *  cb710/cb710-sg.h
+ *
+ *  Copyright by Micha³ Miros³aw, 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef LINUX_CB710_SG_H
+#define LINUX_CB710_SG_H
+
+#include <linux/scatterlist.h>		/* struct scatterlist */
+#include <linux/mm_types.h>		/* struct page */
+
+#define CB710_SG_BUFFER_BLOCK	16	/* power of two */
+#define CB710_SG_BUFFER_MASK	(~(CB710_SG_BUFFER_BLOCK - 1))
+
+struct cb710_sg_chain {
+	uint8_t bounce_buffer[CB710_SG_BUFFER_BLOCK];
+	struct scatterlist *sg;
+	unsigned int sg_num;
+	struct page *page;
+	void *mapped_page;
+	size_t cur_offset;
+	size_t need_advance;
+	unsigned page_no;
+	unsigned page_offset;
+	unsigned page_left;
+	unsigned need_bounce:1;
+	unsigned use_bounce:1;
+};
+
+void cb710_sg_init(struct cb710_sg_chain *buf,
+	struct scatterlist *sg, size_t nelem);
+int cb710_sg_next_buf(struct cb710_sg_chain *buf,
+	void **dataptr, size_t *len, int to_sg);
+void cb710_sg_abort(struct cb710_sg_chain *buf, int to_sg);
+
+#define cb710_sg_read_next(b, d, l) \
+	cb710_sg_next_buf((b), (d), (l), 0)
+#define cb710_sg_write_next(b, d, l) \
+	cb710_sg_next_buf((b), (d), (l), 1)
+#define cb710_sg_abort_read(b) \
+	cb710_sg_abort((b), 0)
+#define cb710_sg_abort_write(b) \
+	cb710_sg_abort((b), 1)
+
+#endif /* LINUX_CB710_SG_H */
diff -urN empty/core.c cb710/core.c
--- empty/core.c	1970-01-01 01:00:00.000000000 +0100
+++ cb710/core.c	2008-09-25 07:23:51.000000000 +0200
@@ -0,0 +1,300 @@
+/*
+ *  cb710/core.c
+ *
+ *  Copyright by Micha³ Miros³aw, 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/pci.h>
+#include <linux/idr.h>
+#include <linux/rcupdate.h>
+#include "cb710.h"
+
+static DEFINE_IDR(cb710_idr);
+static DEFINE_SPINLOCK(cb710_idr_lock);
+
+void cb710_pci_update_config_reg(struct pci_dev *pdev,
+	int reg, uint32_t mask, uint32_t xor)
+{
+	u32 rval;
+
+	pci_read_config_dword(pdev, reg, &rval);
+	rval = (rval & mask) ^ xor;
+	pci_write_config_dword(pdev, reg, rval);
+}
+EXPORT_SYMBOL_GPL(cb710_pci_update_config_reg);
+
+/* Some magic writes based on Windows driver init code */
+static int __devinit cb710_pci_configure(struct pci_dev *pdev)
+{
+	unsigned int devfn = PCI_DEVFN(PCI_SLOT(pdev->devfn), 0);
+	struct pci_dev *pdev0 = pci_get_slot(pdev->bus, devfn);
+	u32 val;
+
+	cb710_pci_update_config_reg(pdev, 0x48,
+		~0x000000FF, 0x0000003F);
+
+	pci_read_config_dword(pdev, 0x48, &val);
+	if (val & 0x80000000)
+		return 0;
+
+	if (!pdev0)
+		return -ENODEV;
+
+	if (pdev0->vendor == PCI_VENDOR_ID_ENE
+	    && pdev0->device == PCI_DEVICE_ID_ENE_720) {
+		cb710_pci_update_config_reg(pdev0, 0x8C,
+			~0x00F00000, 0x00100000);
+		cb710_pci_update_config_reg(pdev0, 0xB0,
+			~0x08000000, 0x08000000);
+	}
+
+	cb710_pci_update_config_reg(pdev0, 0x8C,
+		~0x00000F00, 0x00000200);
+	cb710_pci_update_config_reg(pdev0, 0x90,
+		~0x00060000, 0x00040000);
+
+	pci_dev_put(pdev0);
+
+	return 0;
+}
+
+static irqreturn_t cb710_irq_handler(int irq, void *data)
+{
+	struct cb710_chip *chip = data;
+	struct cb710_slot *slot = &chip->slot[0];
+	cb710_irq_handler_t handler_func;
+	irqreturn_t handled = IRQ_NONE;
+	int nr;
+
+	rcu_read_lock();
+	nr = atomic_read(&chip->slots);
+
+	while (nr--) {
+		handler_func = rcu_dereference(slot->irq_handler);
+		if (handler_func && handler_func(slot))
+			handled = IRQ_HANDLED;
+		++slot;
+	}
+
+	rcu_read_unlock();
+
+	return handled;
+}
+
+static int __devinit cb710_register_slot(struct cb710_chip *chip,
+	unsigned slot_mask, unsigned io_offset, const char *name)
+{
+	int nr = atomic_read(&chip->slots);
+	struct cb710_slot *slot = &chip->slot[nr];
+	int err;
+
+	dev_dbg(cb710_chip_dev(chip),
+		"register: %s.%d; slot %d; mask %d; IO offset: 0x%02X\n",
+		name, chip->platform_id, nr, slot_mask, io_offset);
+
+	slot->iobase = chip->iobase + io_offset;
+	slot->pdev.name = name;
+	slot->pdev.id = chip->platform_id;
+	slot->pdev.dev.parent = &chip->pdev->dev;
+	err = platform_device_register(&slot->pdev);
+
+	if (err)
+		return err;
+
+	chip->slot_mask |= slot_mask;
+	atomic_inc(&chip->slots);
+
+	/* XXX: can this be just left out/replaced by a memory barrier? */
+	synchronize_rcu();
+
+	return 0;
+}
+
+static void cb710_unregister_slot(struct cb710_chip *chip,
+	unsigned slot_mask)
+{
+	int nr;
+
+	if (!(chip->slot_mask & slot_mask))
+		return;
+
+	nr = atomic_sub_return(1, &chip->slots);
+	chip->slot_mask &= ~slot_mask;
+
+	synchronize_rcu();
+
+	platform_device_unregister(&chip->slot[nr].pdev);
+}
+
+#ifdef CONFIG_PM
+
+static int cb710_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
+	if (state.event & PM_EVENT_SLEEP)
+		pci_set_power_state(pdev, PCI_D3cold);
+	return 0;
+}
+
+static int cb710_resume(struct pci_dev *pdev)
+{
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+	return pcim_enable_device(pdev);
+}
+
+#endif /* CONFIG_PM */
+
+static int __devinit cb710_probe(struct pci_dev *pdev,
+	const struct pci_device_id *ent)
+{
+	struct cb710_chip *chip;
+	unsigned long flags;
+	u32 val;
+	int err;
+	int n = 0;
+
+	err = cb710_pci_configure(pdev);
+	if (err)
+		return err;
+
+	/* this is actually magic... */
+	pci_read_config_dword(pdev, 0x48, &val);
+	if (!(val & 0x80000000)) {
+		pci_write_config_dword(pdev, 0x48, val|0x71000000);
+		pci_read_config_dword(pdev, 0x48, &val);
+	}
+
+	dev_dbg(&pdev->dev, "PCI config[0x48] = 0x%08X\n", val);
+	if (!(val & 0x70000000))
+		return -ENODEV;
+	val = (val >> 28) & 7;
+	if (val & CB710_SLOT_MMC)
+		++n;
+	if (val & CB710_SLOT_MS)
+		++n;
+	if (val & CB710_SLOT_SM)
+		++n;
+
+	chip = devm_kzalloc(&pdev->dev,
+		sizeof(*chip) + n * sizeof(*chip->slot), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	err = pcim_enable_device(pdev);
+	if (err)
+		return err;
+
+	err = pcim_iomap_regions(pdev, 0x0001, CB710_DRIVER_NAME);
+	if (err)
+		return err;
+
+	chip->pdev = pdev;
+	chip->iobase = pcim_iomap_table(pdev)[0];
+
+	pci_set_drvdata(pdev, chip);
+
+	err = devm_request_irq(&pdev->dev, pdev->irq,
+		cb710_irq_handler, IRQF_SHARED, CB710_DRIVER_NAME, chip);
+	if (err)
+		return err;
+
+	if (!idr_pre_get(&cb710_idr, GFP_KERNEL))
+		return -ENOMEM;
+
+	spin_lock_irqsave(&cb710_idr_lock, flags);
+	err = idr_get_new(&cb710_idr, chip, &chip->platform_id);
+	spin_unlock_irqrestore(&cb710_idr_lock, flags);
+	if (err)
+		return err;
+
+	dev_info(&pdev->dev, "id %d, IO 0x%p, IRQ %d\n",
+		chip->platform_id, chip->iobase, pdev->irq);
+
+	if (val & CB710_SLOT_MMC) {	/* MMC/SD slot */
+		err = cb710_register_slot(chip,
+			CB710_SLOT_MMC, 0x00, "cb710-mmc");
+		if (err)
+			return err;
+	}
+
+	if (val & CB710_SLOT_MS) {	/* MemoryStick slot */
+		err = cb710_register_slot(chip,
+			CB710_SLOT_MS, 0x40, "cb710-ms");
+		if (err)
+			goto unreg_mmc;
+	}
+
+	if (val & CB710_SLOT_SM) {	/* SmartMedia slot */
+		err = cb710_register_slot(chip,
+			CB710_SLOT_SM, 0x60, "cb710-sm");
+		if (err)
+			goto unreg_ms;
+	}
+
+	return 0;
+unreg_ms:
+	cb710_unregister_slot(chip, CB710_SLOT_MS);
+unreg_mmc:
+	cb710_unregister_slot(chip, CB710_SLOT_MMC);
+	return err;
+}
+
+static void __devexit cb710_remove_one(struct pci_dev *pdev)
+{
+	struct cb710_chip *chip = pci_get_drvdata(pdev);
+	unsigned long flags;
+
+	cb710_unregister_slot(chip, CB710_SLOT_SM);
+	cb710_unregister_slot(chip, CB710_SLOT_MS);
+	cb710_unregister_slot(chip, CB710_SLOT_MMC);
+
+	spin_lock_irqsave(&cb710_idr_lock, flags);
+	idr_remove(&cb710_idr, chip->platform_id);
+	spin_unlock_irqrestore(&cb710_idr_lock, flags);
+}
+
+/* TODO: move to pci_ids.h before merging upstream */
+#define PCI_DEVICE_ID_ENE_710_FLASH	0x0510
+
+static const struct pci_device_id cb710_pci_tbl[] = {
+	{ PCI_VENDOR_ID_ENE, PCI_DEVICE_ID_ENE_710_FLASH,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{ 0, }
+};
+
+static struct pci_driver cb710_driver = {
+	.name = CB710_DRIVER_NAME,
+	.id_table = cb710_pci_tbl,
+	.probe = cb710_probe,
+	.remove = __devexit_p(cb710_remove_one),
+#ifdef CONFIG_PM
+	.suspend = cb710_suspend,
+	.resume = cb710_resume,
+#endif
+};
+
+static int __init cb710_init_module(void)
+{
+	return pci_register_driver(&cb710_driver);
+}
+
+static void __exit cb710_cleanup_module(void)
+{
+	pci_unregister_driver(&cb710_driver);
+}
+
+module_init(cb710_init_module);
+module_exit(cb710_cleanup_module);
+
+MODULE_AUTHOR("Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>");
+MODULE_DESCRIPTION("ENE CB710 memory card reader driver");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, cb710_pci_tbl);
diff -urN empty/debug.c cb710/debug.c
--- empty/debug.c	1970-01-01 01:00:00.000000000 +0100
+++ cb710/debug.c	2008-09-25 05:51:31.000000000 +0200
@@ -0,0 +1,120 @@
+/*
+ *  cb710/debug.c
+ *
+ *  Copyright by Micha³ Miros³aw, 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/pci.h>
+#include "cb710.h"
+
+#define CB710_REG_COUNT		0x80
+
+static const u16 allow[CB710_REG_COUNT/16] = {
+	0xFFF0, 0xFFFF, 0xFFFF, 0xFFFF,
+	0xFFF0, 0xFFFF, 0xFFFF, 0xFFFF,
+};
+static const char *const prefix[ARRAY_SIZE(allow)] = {
+	"MMC", "MMC", "MMC", "MMC",
+	"MS?", "MS?", "SM?", "SM?"
+};
+
+static inline int allow_reg_read(unsigned block, unsigned offset, unsigned bits)
+{
+	unsigned mask = (1 << bits/8) - 1;
+	offset *= bits/8;
+	return ((allow[block] >> offset) & mask) == mask;
+}
+
+#define CB710_READ_REGS_TEMPLATE(t)					\
+static void cb710_read_regs_##t(void __iomem *iobase,			\
+	u##t *reg, unsigned select)					\
+{									\
+	unsigned i, j;							\
+									\
+	for (i = 0; i < ARRAY_SIZE(allow); ++i, reg += 16/(t/8)) {	\
+		if (!select & (1 << i))					\
+			continue;					\
+									\
+		for (j = 0; j < 0x10/(t/8); ++j) {			\
+			if (!allow_reg_read(i, j, t))			\
+				continue;				\
+			reg[j] = ioread##t(iobase			\
+				+ (i << 4) + (j * (t/8)));		\
+		}							\
+	}								\
+}
+
+static const char cb710_regf_8[] = "%02X";
+static const char cb710_regf_16[] = "%04X";
+static const char cb710_regf_32[] = "%08X";
+static const char cb710_xes[] = "xxxxxxxx";
+
+#define CB710_DUMP_REGS_TEMPLATE(t)					\
+static void cb710_dump_regs_##t(struct device *dev,			\
+	const u##t *reg, unsigned select)				\
+{									\
+	const char *const xp = &cb710_xes[8 - t/4];			\
+	const char *const format = cb710_regf_##t;			\
+									\
+	char msg[100], *p;						\
+	unsigned i, j;							\
+									\
+	for (i = 0; i < ARRAY_SIZE(allow); ++i, reg += 16/(t/8)) {	\
+		if (!(select & (1 << i)))				\
+			continue;					\
+		p = msg;						\
+		for (j = 0; j < 0x10/(t/8); ++j) {			\
+			*p++ = ' ';					\
+			if (j == 8/(t/8))				\
+				*p++ = ' ';				\
+			if (allow_reg_read(i, j, t))			\
+				p += sprintf(p, format, reg[j]);	\
+			else						\
+				p += sprintf(p, "%s", xp);		\
+		}							\
+		dev_dbg(dev, "%s 0x%02X %s\n", prefix[i], i << 4, msg);	\
+	}								\
+}
+
+#define CB710_READ_AND_DUMP_REGS_TEMPLATE(t)				\
+static void cb710_read_and_dump_regs_##t(struct cb710_chip *chip,	\
+	unsigned select)						\
+{									\
+	u##t regs[CB710_REG_COUNT/sizeof(u##t)];			\
+									\
+	memset(&regs, 0, sizeof(regs));					\
+	cb710_read_regs_##t(chip->iobase, regs, select);		\
+	cb710_dump_regs_##t(cb710_chip_dev(chip), regs, select);	\
+}
+
+#define CB710_REG_ACCESS_TEMPLATES(t)		\
+  CB710_READ_REGS_TEMPLATE(t)			\
+  CB710_DUMP_REGS_TEMPLATE(t)			\
+  CB710_READ_AND_DUMP_REGS_TEMPLATE(t)
+
+CB710_REG_ACCESS_TEMPLATES(8)
+CB710_REG_ACCESS_TEMPLATES(16)
+CB710_REG_ACCESS_TEMPLATES(32)
+
+void cb710_dump_regs(struct cb710_chip *chip, unsigned select)
+{
+	if (!(select & CB710_DUMP_REGS_MASK))
+		select = CB710_DUMP_REGS_ALL;
+	if (!(select & CB710_DUMP_ACCESS_MASK))
+		select |= CB710_DUMP_ACCESS_8;
+
+	if (select & CB710_DUMP_ACCESS_32)
+		cb710_read_and_dump_regs_32(chip, select);
+	if (select & CB710_DUMP_ACCESS_16)
+		cb710_read_and_dump_regs_16(chip, select);
+	if (select & CB710_DUMP_ACCESS_8)
+		cb710_read_and_dump_regs_8(chip, select);
+}
+EXPORT_SYMBOL_GPL(cb710_dump_regs);
+
diff -urN empty/Makefile cb710/Makefile
--- empty/Makefile	1970-01-01 01:00:00.000000000 +0100
+++ cb710/Makefile	2008-09-25 07:02:28.000000000 +0200
@@ -0,0 +1,29 @@
+ifeq ($(KERNELRELEASE),)
+
+#KDIR	:= /usr/src/linux
+KDIR	:= /usr/src/jaja/build/rechot
+PWD     := $(shell pwd)
+
+.PHONY: module install clean
+module:
+	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules
+
+install:
+	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules_install
+
+clean:
+	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) clean
+	rm -f modules.order
+
+else	# kbuild part
+
+obj-m		:= cb710.o cb710-mmc.o
+
+cb710-y		:= core.o sgbuf.o
+cb710-mmc-y	:= mmc.o
+
+# debugging
+EXTRA_CFLAGS	:= -DDEBUG
+cb710-y		+= debug.o
+
+endif
diff -urN empty/mmc.c cb710/mmc.c
--- empty/mmc.c	1970-01-01 01:00:00.000000000 +0100
+++ cb710/mmc.c	2008-09-25 07:12:36.000000000 +0200
@@ -0,0 +1,822 @@
+/*
+ *  cb710/mmc.c
+ *
+ *  Copyright by Micha³ Miros³aw, 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include "cb710-mmc.h"
+#include "cb710-sg.h"
+
+static const u8 cb710_clock_divider_log2[8] = {
+/*	1, 2, 4, 8, 16, 32, 128, 512 */
+	0, 1, 2, 3,  4,  5,   7,   9
+};
+#define CB710_MAX_DIVIDER_IDX	\
+	(ARRAY_SIZE(cb710_clock_divider_log2) - 1)
+
+static const u8 cb710_src_freq_mhz[16] = {
+	33, 10, 20, 25, 30, 35, 40, 45,
+	50, 55, 60, 65, 70, 75, 80, 85
+};
+
+#ifdef VERBOSE_DEBUG
+static void verify_serialization(struct mmc_host *mmc,
+	unsigned char *counter, int inc)
+{
+	struct cb710_slot *slot = cb710_mmc_to_slot(mmc);
+	struct cb710_mmc_reader *reader = mmc_priv(mmc);
+	unsigned long flags;
+	int req, ios, cur;
+
+	spin_lock_irqsave(&reader->serialization_lock, flags);
+
+	if (inc)
+		cur = ++*counter;
+	else
+		cur = --*counter;
+	req = reader->active_req;
+	ios = reader->active_ios;
+
+	spin_unlock_irqrestore(&reader->serialization_lock, flags);
+
+	dev_info(cb710_slot_dev(slot),
+		"%s driver; counters now: ios=%d req=%d\n",
+		inc ? "entering" : "leaving", ios, req);
+	WARN_ON(cur > 1);
+}
+#else
+#define verify_serialization(h, c, i)
+#endif
+
+static void cb710_mmc_set_clock(struct mmc_host *mmc, int hz)
+{
+	struct cb710_slot *slot = cb710_mmc_to_slot(mmc);
+	struct pci_dev *pdev = cb710_slot_to_chip(slot)->pdev;
+	u32 src_freq_idx;
+	u32 divider_idx;
+	int src_hz;
+
+	/* this is magic, unverifiable for me, unless I get
+	 * MMC card with cables connected to bus signals */
+	pci_read_config_dword(pdev, 0x48, &src_freq_idx);
+	src_freq_idx = (src_freq_idx >> 16) & 0xF;
+	src_hz = cb710_src_freq_mhz[src_freq_idx] * 1000000;
+
+	for (divider_idx = 0; divider_idx < CB710_MAX_DIVIDER_IDX; ++divider_idx) {
+		if (hz >= src_hz >> cb710_clock_divider_log2[divider_idx])
+			break;
+	}
+
+	if (src_freq_idx)
+		divider_idx |= 0x8;
+
+	cb710_pci_update_config_reg(pdev, 0x40, ~0xF0000000, divider_idx << 28);
+
+	dev_dbg(cb710_slot_dev(slot),
+		"clock set to %d Hz, wanted %d Hz; flag = %d\n",
+		src_hz >> cb710_clock_divider_log2[divider_idx & 7],
+		hz, (divider_idx & 8) != 0);
+}
+
+static void __cb710_mmc_enable_irq(struct cb710_slot *slot, int enable)
+{
+	if (enable) {
+		/* look like interrupt is fired whenever
+		 * WORD[0x0C] & WORD[0x10] != 0;
+		 * let's verify it...
+		 *** bit 7 port 0x0D seems to be global interrupt enable
+		 */
+		cb710_write_port_8(slot, CB710_MMC_IRQ_ENABLE0_PORT, ~0x40);
+		cb710_write_port_8(slot, CB710_MMC_IRQ_ENABLE1_PORT,
+			CB710_MMC_IE_IRQ_ENABLE|CB710_MMC_IE_CARD_INSERTION_STATUS);
+	} else {
+		cb710_write_port_8(slot, CB710_MMC_IRQ_ENABLE0_PORT, 0);
+		cb710_write_port_8(slot, CB710_MMC_IRQ_ENABLE1_PORT, 0);
+	}
+}
+
+static void cb710_mmc_enable_irq(struct cb710_slot *slot, int enable)
+{
+	struct cb710_mmc_reader *reader = mmc_priv(cb710_slot_to_mmc(slot));
+	unsigned long flags;
+
+	spin_lock_irqsave(&reader->irq_lock, flags);
+	__cb710_mmc_enable_irq(slot, enable);
+	spin_unlock_irqrestore(&reader->irq_lock, flags);
+}
+
+static void cb710_mmc_reset_events(struct cb710_slot *slot)
+{
+	cb710_write_port_8(slot, CB710_MMC_STATUS0_PORT, 0xFF);
+	cb710_write_port_8(slot, CB710_MMC_STATUS1_PORT, 0xFF);
+	cb710_write_port_8(slot, CB710_MMC_STATUS2_PORT, 0xFF);
+}
+
+static int cb710_mmc_is_card_inserted(struct cb710_slot *slot)
+{
+	return cb710_read_port_8(slot, CB710_MMC_STATUS3_PORT)
+		& CB710_MMC_S3_CARD_DETECTED;
+}
+
+static void cb710_mmc_enable_4bit_data(struct cb710_slot *slot, int enable)
+{
+	dev_dbg(cb710_slot_dev(slot), "configuring %d-data-line%s mode\n",
+		enable ? 4 : 1, enable ? "s" : "");
+	if (enable)
+		cb710_modify_port_8(slot, CB710_MMC_CONFIG1_PORT,
+			CB710_MMC_C1_4BIT_DATA_BUS, 0);
+	else
+		cb710_modify_port_8(slot, CB710_MMC_CONFIG1_PORT,
+			0, CB710_MMC_C1_4BIT_DATA_BUS);
+}
+
+static int cb710_check_event(struct cb710_slot *slot, u8 what)
+{
+	u16 status;
+
+	status = cb710_read_port_16(slot, CB710_MMC_STATUS_PORT);
+
+	if (status & CB710_MMC_S0_FIFO_UNDERFLOW) {
+		/* it is just a guess, so log it */
+		dev_dbg(cb710_slot_dev(slot),
+			"CHECK : ignoring bit 6 in status %04X\n", status);
+		cb710_write_port_8(slot, CB710_MMC_STATUS0_PORT,
+			CB710_MMC_S0_FIFO_UNDERFLOW);
+		status &= ~CB710_MMC_S0_FIFO_UNDERFLOW;
+	}
+
+	if (status & CB710_MMC_STATUS_ERROR_EVENTS) {
+		dev_dbg(cb710_slot_dev(slot),
+			"CHECK : returning EIO on status %04X\n", status);
+		cb710_write_port_8(slot, CB710_MMC_STATUS0_PORT, status & 0xFF);
+		cb710_write_port_8(slot, CB710_MMC_STATUS1_PORT,
+			CB710_MMC_S1_RESET);
+		return -EIO;
+	}
+
+	/* 'what' is a bit in MMC_STATUS1 */
+	if ((status >> 8) & what) {
+		cb710_write_port_8(slot, CB710_MMC_STATUS1_PORT, what);
+		return 1;
+	}
+
+	return 0;
+}
+
+static int cb710_wait_for_event(struct cb710_slot *slot, u8 what)
+{
+	int err = 0;
+	unsigned limit = 2000000;	/* FIXME: real timeout */
+
+#ifdef DEBUG
+	u32 e, x;
+	e = cb710_read_port_32(slot, CB710_MMC_STATUS_PORT);
+#endif
+
+	while (!(err = cb710_check_event(slot, what))) {
+		if (!--limit) {
+			struct cb710_chip *chip = cb710_slot_to_chip(slot);
+			cb710_dump_regs(chip, CB710_DUMP_REGS_MMC);
+			err = -ETIMEDOUT;
+			break;
+		}
+		udelay(1);
+	}
+
+#ifdef DEBUG
+	x = cb710_read_port_32(slot, CB710_MMC_STATUS_PORT);
+
+	limit = 2000000 - limit;
+	if (limit > 100)
+		dev_dbg(cb710_slot_dev(slot),
+			"WAIT10: waited %d loops, what %d, entry val %08X, exit val %08X\n",
+			limit, what, e, x);
+#endif
+	return err < 0 ? err : 0;
+}
+
+
+static int cb710_wait_while_busy(struct cb710_slot *slot, uint8_t mask)
+{
+	unsigned limit = 500000;	/* FIXME: real timeout */
+	int err = 0;
+
+#ifdef DEBUG
+	u32 e, x;
+	e = cb710_read_port_32(slot, CB710_MMC_STATUS_PORT);
+#endif
+
+	while (cb710_read_port_8(slot, CB710_MMC_STATUS2_PORT) & mask) {
+		if (!--limit) {
+			struct cb710_chip *chip = cb710_slot_to_chip(slot);
+			cb710_dump_regs(chip, CB710_DUMP_REGS_MMC);
+			err = -ETIMEDOUT;
+			break;
+		}
+		udelay(1);
+	}
+
+#ifdef DEBUG
+	x = cb710_read_port_32(slot, CB710_MMC_STATUS_PORT);
+
+	limit = 500000 - limit;
+	if (limit > 100)
+		dev_dbg(cb710_slot_dev(slot),
+			"WAIT12: waited %d loops, mask %02X, entry val %08X, exit val %08X\n",
+			limit, mask, e, x);
+#endif
+	return 0;
+}
+
+static void cb710_mmc_set_transfer_size(struct cb710_slot *slot,
+	size_t count, size_t blocksize)
+{
+	cb710_wait_while_busy(slot, CB710_MMC_S2_BUSY_20);
+	cb710_write_port_32(slot, CB710_MMC_TRANSFER_SIZE_PORT,
+		((count - 1) << 16)|(blocksize - 1));
+
+	dev_vdbg(cb710_slot_dev(slot), "set up for %d block%s of %d bytes\n",
+		count, count == 1 ? "" : "s", blocksize);
+}
+
+static void cb710_mmc_fifo_hack(struct cb710_slot *slot)
+{
+	/* without this, received data is prepended with 8-bytes of zeroes */
+	u32 r1, r2;
+	int ok = 0;
+
+	r1 = cb710_read_port_32(slot, CB710_MMC_DATA_PORT);
+	r2 = cb710_read_port_32(slot, CB710_MMC_DATA_PORT);
+	if (cb710_read_port_8(slot, CB710_MMC_STATUS0_PORT)
+	    & CB710_MMC_S0_FIFO_UNDERFLOW) {
+		cb710_write_port_8(slot, CB710_MMC_STATUS0_PORT,
+			CB710_MMC_S0_FIFO_UNDERFLOW);
+		ok = 1;
+	}
+
+	dev_dbg(cb710_slot_dev(slot),
+		"FIFO-read-hack: expected STATUS0 bit was %s\n",
+		ok ? "set." : "NOT SET!");
+	dev_dbg(cb710_slot_dev(slot),
+		"FIFO-read-hack: dwords ignored: %08X %08X - %s\n",
+		r1, r2, (r1|r2) ? "BAD (NOT ZERO)!" : "ok");
+}
+
+static int cb710_mmc_receive(struct cb710_slot *slot, struct mmc_data *data)
+{
+	struct cb710_sg_chain sgc;
+	uint32_t *databuf;
+	size_t len;
+
+	cb710_sg_init(&sgc, data->sg, data->sg_len);
+
+	if (!cb710_sg_write_next(&sgc, (void **)&databuf, &len))
+		return 0;
+
+	cb710_modify_port_8(slot, CB710_MMC_CONFIG2_PORT,
+		15, CB710_MMC_C2_READ_PIO_SIZE_MASK);
+
+	cb710_mmc_fifo_hack(slot);
+
+	while (len >= 16) {
+		if (!(cb710_read_port_8(slot, CB710_MMC_STATUS2_PORT)
+		    & CB710_MMC_S2_FIFO_READY)) {
+			int err = cb710_wait_for_event(slot,
+				CB710_MMC_S1_PIO_TRANSFER_DONE);
+			if (err) {
+				cb710_sg_abort_write(&sgc);
+				return err;
+			}
+		}
+		ioread32_rep(slot->iobase + CB710_MMC_DATA_PORT, databuf, 4);
+
+		len -= 16;
+		databuf += 4;
+
+		if (!len && !cb710_sg_write_next(&sgc,
+				(void **)&databuf, &len))
+			return 0;
+	}
+
+	cb710_modify_port_8(slot, CB710_MMC_CONFIG2_PORT,
+		len - 1, CB710_MMC_C2_READ_PIO_SIZE_MASK);
+
+	if (!(cb710_read_port_8(slot, CB710_MMC_STATUS2_PORT)
+	    & CB710_MMC_S2_FIFO_READY)) {
+		int err = cb710_wait_for_event(slot,
+			CB710_MMC_S1_PIO_TRANSFER_DONE);
+		if (err) {
+			cb710_sg_abort_write(&sgc);
+			return err;
+		}
+	}
+
+	len = (len >= 8) ? 4 : 2;
+	ioread32_rep(slot->iobase + CB710_MMC_DATA_PORT, databuf, len);
+
+	if (cb710_sg_write_next(&sgc, (void **)&databuf, &len))
+		BUG();
+
+	return 0;
+}
+
+static int cb710_mmc_send(struct cb710_slot *slot, struct mmc_data *data)
+{
+	struct cb710_sg_chain sgc;
+	const uint32_t *databuf;
+	size_t datalen;
+
+	cb710_sg_init(&sgc, data->sg, data->sg_len);
+
+	cb710_modify_port_8(slot, CB710_MMC_CONFIG2_PORT,
+		0, CB710_MMC_C2_READ_PIO_SIZE_MASK);
+
+	while (cb710_sg_read_next(&sgc, (void **)&databuf, &datalen)) {
+		datalen = (datalen + 15) >> 4;
+		do {
+			if (!(cb710_read_port_8(slot, CB710_MMC_STATUS2_PORT)
+			    & CB710_MMC_S2_FIFO_EMPTY)) {
+				int err = cb710_wait_for_event(slot,
+					CB710_MMC_S1_PIO_TRANSFER_DONE);
+				if (err) {
+					cb710_sg_abort_read(&sgc);
+					return err;
+				}
+			}
+			iowrite32_rep(slot->iobase + CB710_MMC_DATA_PORT,
+				databuf, 4);
+			databuf += 4;
+		} while (--datalen);
+	}
+
+	return 0;
+}
+
+static u16 cb710_encode_cmd_flags(struct cb710_mmc_reader *reader,
+	struct mmc_command *cmd)
+{
+	unsigned int flags = cmd->flags;
+	u16 cb_flags = 0;
+
+	/* Windows driver returned 0 for commands for which no response
+	 * is expected. It happened that there were only two such commands
+	 * used: MMC_GO_IDLE_STATE and MMC_GO_INACTIVE_STATE so it might
+	 * as well be a bug in that driver.
+	 */
+
+	switch (flags & MMC_CMD_MASK) {
+	case MMC_CMD_AC:	cb_flags = CB710_MMC_CMD_AC;	break;
+	case MMC_CMD_ADTC:	cb_flags = CB710_MMC_CMD_ADTC;	break;
+	case MMC_CMD_BC:	cb_flags = CB710_MMC_CMD_BC;	break;
+	case MMC_CMD_BCR:	cb_flags = CB710_MMC_CMD_BCR;	break;
+	}
+
+	if (flags & MMC_RSP_BUSY)
+		cb_flags |= CB710_MMC_RSP_BUSY;
+
+	cb_flags |= cmd->opcode << CB710_MMC_CMD_CODE_SHIFT;
+
+#if 0
+	/* original driver set bit 14 for MMC/SD application
+	 * commands. There's no difference 'on the wire' and
+	 * it apparently works without it anyway.
+	 */
+	if (flags & MMC_CMD_IS_APPCMD)
+		cb_flags |= 0x4000;
+#endif
+
+	if (cmd->data && (cmd->data->flags & MMC_DATA_READ))
+		cb_flags |= CB710_MMC_DATA_READ;
+
+	if (flags & MMC_RSP_PRESENT) {
+		/* Windows driver set 01 at bits 4,3 except for
+		 * MMC_SET_BLOCKLEN where it set 10. Maybe the
+		 * hardware can do something special about this
+		 * command? The original driver looks buggy/incomplete
+		 * anyway so we ignore this for now.
+		 *
+		 * I assume that 00 here means no response is expected.
+		 */
+		cb_flags |= CB710_MMC_RSP_PRESENT;
+
+		if (flags & MMC_RSP_136)
+			cb_flags |= CB710_MMC_RSP_136;
+		if (!(flags & MMC_RSP_CRC))
+			cb_flags |= CB710_MMC_RSP_NO_CRC;
+	}
+
+	return cb_flags;
+}
+
+static void cb710_receive_response(struct cb710_slot *slot,
+	struct mmc_command *cmd)
+{
+	unsigned rsp_opcode, wanted_opcode;
+
+	/* Looks like final byte with CRC is always stripped (like SDHCI) */
+	if (cmd->flags & MMC_RSP_136) {
+		u32 resp[4];
+
+		resp[0] = cb710_read_port_32(slot, CB710_MMC_RESPONSE3_PORT);
+		resp[1] = cb710_read_port_32(slot, CB710_MMC_RESPONSE2_PORT);
+		resp[2] = cb710_read_port_32(slot, CB710_MMC_RESPONSE1_PORT);
+		resp[3] = cb710_read_port_32(slot, CB710_MMC_RESPONSE0_PORT);
+		rsp_opcode = resp[0] >> 24;
+
+		cmd->resp[0] = (resp[0] << 8)|(resp[1] >> 24);
+		cmd->resp[1] = (resp[1] << 8)|(resp[2] >> 24);
+		cmd->resp[2] = (resp[2] << 8)|(resp[3] >> 24);
+		cmd->resp[3] = (resp[3] << 8);
+	} else {
+		rsp_opcode = cb710_read_port_32(slot, CB710_MMC_RESPONSE1_PORT) & 0x3F;
+		cmd->resp[0] = cb710_read_port_32(slot, CB710_MMC_RESPONSE0_PORT);
+	}
+
+	wanted_opcode = (cmd->flags & MMC_RSP_OPCODE) ? cmd->opcode : 0x3F;
+	if (rsp_opcode != wanted_opcode)
+		cmd->error = -EILSEQ;
+}
+
+static int cb710_mmc_transfer_data(struct cb710_slot *slot,
+	struct mmc_data *data)
+{
+	int error, to;
+
+	if (data->flags & MMC_DATA_READ)
+		error = cb710_mmc_receive(slot, data);
+	else
+		error = cb710_mmc_send(slot, data);
+
+	to = cb710_wait_for_event(slot, CB710_MMC_S1_DATA_TRANSFER_DONE);
+	if (!error)
+		error = to;
+
+	if (!error)	/* TODO: proper counting */
+		data->bytes_xfered = data->blksz * data->blocks;
+	return error;
+}
+
+static int cb710_mmc_command(struct mmc_host *mmc, struct mmc_command *cmd)
+{
+	struct cb710_slot *slot = cb710_mmc_to_slot(mmc);
+	struct cb710_mmc_reader *reader = mmc_priv(mmc);
+	struct mmc_data *data = cmd->data;
+
+	u16 cb_cmd = cb710_encode_cmd_flags(reader, cmd);
+	dev_dbg(cb710_slot_dev(slot), "cmd request: 0x%04X\n", cb_cmd);
+
+	if (data)
+		cb710_mmc_set_transfer_size(slot, data->blocks, data->blksz);
+
+	cb710_wait_while_busy(slot, CB710_MMC_S2_BUSY_20|CB710_MMC_S2_BUSY_10);
+	cb710_write_port_16(slot, CB710_MMC_CMD_TYPE_PORT, cb_cmd);
+	cb710_wait_while_busy(slot, CB710_MMC_S2_BUSY_20);
+	cb710_write_port_32(slot, CB710_MMC_CMD_PARAM_PORT, cmd->arg);
+	cb710_mmc_reset_events(slot);
+	cb710_wait_while_busy(slot, CB710_MMC_S2_BUSY_20);
+	cb710_modify_port_8(slot, CB710_MMC_CONFIG0_PORT, 0x01, 0);
+
+	cmd->error = cb710_wait_for_event(slot, CB710_MMC_S1_COMMAND_SENT);
+	if (cmd->error)
+		return -1;
+
+	if (cmd->flags & MMC_RSP_PRESENT) {
+		cb710_receive_response(slot, cmd);
+		if (cmd->error)
+			return -1;
+	}
+
+	if (data)
+		data->error = cb710_mmc_transfer_data(slot, data);
+	return 0;
+}
+
+static void cb710_mmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
+{
+	struct cb710_slot *slot = cb710_mmc_to_slot(mmc);
+	struct cb710_mmc_reader *reader = mmc_priv(mmc);
+
+	verify_serialization(mmc, &reader->active_req, 1);
+
+	WARN_ON(reader->mrq != NULL);
+
+	reader->mrq = mrq;
+	cb710_mmc_enable_irq(slot, 1);
+
+	if (cb710_mmc_is_card_inserted(slot)) {
+		if (!cb710_mmc_command(mmc, mrq->cmd) && mrq->stop)
+			cb710_mmc_command(mmc, mrq->stop);
+		mdelay(1);
+	} else {
+		mrq->cmd->error = -ENOMEDIUM;
+	}
+
+	tasklet_schedule(&reader->finish_req_tasklet);
+
+	verify_serialization(mmc, &reader->active_req, 0);
+}
+
+static int cb710_mmc_powerup(struct cb710_slot *slot)
+{
+	struct cb710_chip *chip = cb710_slot_to_chip(slot);
+	int err;
+
+	/* a lot of magic; see comment in cb710_mmc_set_clock() */
+	dev_dbg(cb710_slot_dev(slot), "bus powerup\n");
+	cb710_dump_regs(chip, CB710_DUMP_REGS_MMC);
+	err = cb710_wait_while_busy(slot, CB710_MMC_S2_BUSY_20);
+	if (unlikely(err))
+		return err;
+	cb710_modify_port_8(slot, CB710_MMC_CONFIG1_PORT, 0x80, 0);
+	cb710_modify_port_8(slot, CB710_MMC_CONFIG3_PORT, 0x80, 0);
+	cb710_dump_regs(chip, CB710_DUMP_REGS_MMC);
+	mdelay(1);
+	dev_dbg(cb710_slot_dev(slot), "after delay 1\n");
+	cb710_dump_regs(chip, CB710_DUMP_REGS_MMC);
+	err = cb710_wait_while_busy(slot, CB710_MMC_S2_BUSY_20);
+	if (unlikely(err))
+		return err;
+	cb710_modify_port_8(slot, CB710_MMC_CONFIG1_PORT, 0x09, 0);
+	cb710_dump_regs(chip, CB710_DUMP_REGS_MMC);
+	mdelay(1);
+	dev_dbg(cb710_slot_dev(slot), "after delay 2\n");
+	cb710_dump_regs(chip, CB710_DUMP_REGS_MMC);
+	err = cb710_wait_while_busy(slot, CB710_MMC_S2_BUSY_20);
+	if (unlikely(err))
+		return err;
+	cb710_modify_port_8(slot, CB710_MMC_CONFIG1_PORT, 0, 0x08);
+	cb710_dump_regs(chip, CB710_DUMP_REGS_MMC);
+	mdelay(2);
+	dev_dbg(cb710_slot_dev(slot), "after delay 3\n");
+	cb710_dump_regs(chip, CB710_DUMP_REGS_MMC);
+	cb710_modify_port_8(slot, CB710_MMC_CONFIG0_PORT, 0x06, 0);
+	cb710_modify_port_8(slot, CB710_MMC_CONFIG1_PORT, 0x70, 0);
+	cb710_modify_port_8(slot, CB710_MMC_CONFIG2_PORT, 0x80, 0);
+	cb710_modify_port_8(slot, CB710_MMC_CONFIG3_PORT, 0x03, 0);
+	cb710_dump_regs(chip, CB710_DUMP_REGS_MMC);
+	err = cb710_wait_while_busy(slot, CB710_MMC_S2_BUSY_20);
+	if (unlikely(err))
+		return err;
+	/* This port behaves weird: quick byte reads of 0x08,0x09 return
+	 * 0xFF,0x00 after writing 0xFFFF to 0x08; it works correctly when
+	 * read/written from userspace...  What am I missing here?
+	 * (it doesn't depend on write-to-read delay)  --mq */
+	cb710_write_port_16(slot, CB710_MMC_CONFIGB_PORT, 0xFFFF);
+	cb710_modify_port_8(slot, CB710_MMC_CONFIG0_PORT, 0x06, 0);
+	cb710_dump_regs(chip, CB710_DUMP_REGS_MMC);
+	dev_dbg(cb710_slot_dev(slot), "bus powerup finished\n");
+
+	return cb710_check_event(slot, 0);
+}
+
+static void cb710_mmc_powerdown(struct cb710_slot *slot)
+{
+	cb710_modify_port_8(slot, CB710_MMC_CONFIG1_PORT, 0, 0x81);
+	cb710_modify_port_8(slot, CB710_MMC_CONFIG3_PORT, 0, 0x80);
+}
+
+static void cb710_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+{
+	struct cb710_slot *slot = cb710_mmc_to_slot(mmc);
+	struct cb710_mmc_reader *reader = mmc_priv(mmc);
+	int err;
+
+	verify_serialization(mmc, &reader->active_ios, 1);
+
+	cb710_mmc_set_clock(mmc, ios->clock);
+
+	if (!cb710_mmc_is_card_inserted(slot)) {
+		dev_dbg(cb710_slot_dev(slot),
+			"no card inserted - ignoring bus powerup request\n");
+		ios->power_mode = MMC_POWER_OFF;
+	}
+
+	if (ios->power_mode != reader->last_power_mode)
+	switch (ios->power_mode) {
+	case MMC_POWER_ON:
+		err = cb710_mmc_powerup(slot);
+		if (err) {
+			dev_warn(cb710_slot_dev(slot),
+				"powerup failed (%d)- retrying\n", err);
+			cb710_mmc_powerdown(slot);
+			udelay(1);
+			err = cb710_mmc_powerup(slot);
+			if (err)
+				dev_warn(cb710_slot_dev(slot),
+					"powerup retry failed (%d) - expect errors\n",
+					err);
+		}
+		reader->last_power_mode = MMC_POWER_ON;
+		break;
+	case MMC_POWER_OFF:
+		cb710_mmc_powerdown(slot);
+		reader->last_power_mode = MMC_POWER_OFF;
+		break;
+	case MMC_POWER_UP:
+	default:
+		/* ignore */;
+	}
+
+	cb710_mmc_enable_4bit_data(slot, ios->bus_width != MMC_BUS_WIDTH_1);
+
+	cb710_mmc_enable_irq(slot, 1);
+
+	verify_serialization(mmc, &reader->active_ios, 0);
+}
+
+static int cb710_mmc_get_ro(struct mmc_host *mmc)
+{
+	struct cb710_slot *slot = cb710_mmc_to_slot(mmc);
+
+	return cb710_read_port_8(slot, CB710_MMC_STATUS3_PORT)
+		& CB710_MMC_S3_WRITE_PROTECTED;
+}
+
+static int cb710_mmc_irq_handler(struct cb710_slot *slot)
+{
+	struct mmc_host *mmc = cb710_slot_to_mmc(slot);
+	struct cb710_mmc_reader *reader = mmc_priv(mmc);
+	u32 status, config1, config2, irqen;
+
+	status = cb710_read_port_32(slot, CB710_MMC_STATUS_PORT);
+	irqen = cb710_read_port_32(slot, CB710_MMC_IRQ_ENABLE_PORT);
+	config2 = cb710_read_port_32(slot, CB710_MMC_CONFIGB_PORT);
+	config1 = cb710_read_port_32(slot, CB710_MMC_CONFIG_PORT);
+
+	dev_dbg(cb710_slot_dev(slot), "interrupt; status: %08X, "
+		"ie: %08X, c2: %08X, c1: %08X\n",
+		status, irqen, config2, config1);
+
+	if (status & (CB710_MMC_S1_CARD_CHANGED << 8)) {
+		cb710_write_port_8(slot, CB710_MMC_STATUS1_PORT,
+			CB710_MMC_S1_CARD_CHANGED);
+		if ((irqen & CB710_MMC_IE_CISTATUS_MASK)
+		    == CB710_MMC_IE_CISTATUS_MASK)
+			mmc_detect_change(mmc, HZ/2);
+	} else {
+		dev_dbg(cb710_slot_dev(slot), "unknown interrupt\n");
+		spin_lock(&reader->irq_lock);
+		cb710_write_port_8(slot, CB710_MMC_IRQ_ENABLE0_PORT, 0x00);
+		cb710_write_port_8(slot, CB710_MMC_IRQ_ENABLE1_PORT,
+			CB710_MMC_IE_IRQ_ENABLE|CB710_MMC_IE_CARD_INSERTION_STATUS);
+		spin_unlock(&reader->irq_lock);
+	}
+
+	return 1;
+}
+
+static void cb710_mmc_finish_request_tasklet(unsigned long data)
+{
+	struct mmc_host *mmc = (void *)data;
+	struct cb710_mmc_reader *reader = mmc_priv(mmc);
+	struct mmc_request *mrq = reader->mrq;
+
+	reader->mrq = NULL;
+	mmc_request_done(mmc, mrq);
+}
+
+static const struct mmc_host_ops cb710_mmc_host = {
+	.request = cb710_mmc_request,
+	.set_ios = cb710_mmc_set_ios,
+	.get_ro = cb710_mmc_get_ro
+};
+
+#ifdef CONFIG_PM
+
+static int cb710_mmc_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct cb710_slot *slot = cb710_pdev_to_slot(pdev);
+	struct mmc_host *mmc = cb710_slot_to_mmc(slot);
+	int err;
+
+	err = mmc_suspend_host(mmc, state);
+	if (err)
+		return err;
+
+	cb710_mmc_enable_irq(slot, 0);
+	return 0;
+}
+
+static int cb710_mmc_resume(struct platform_device *pdev)
+{
+	struct cb710_slot *slot = cb710_pdev_to_slot(pdev);
+	struct mmc_host *mmc = cb710_slot_to_mmc(slot);
+
+	cb710_mmc_enable_irq(slot, 0);
+
+	return mmc_resume_host(mmc);
+}
+
+#endif /* CONFIG_PM */
+
+static int __devinit cb710_mmc_init(struct platform_device *pdev)
+{
+	struct cb710_slot *slot = cb710_pdev_to_slot(pdev);
+	struct cb710_chip *chip = cb710_slot_to_chip(slot);
+	struct mmc_host *mmc;
+	struct cb710_mmc_reader *reader;
+	int err;
+	u32 val;
+
+	mmc = mmc_alloc_host(sizeof(*reader), cb710_slot_dev(slot));
+	if (!mmc)
+		return -ENOMEM;
+
+	dev_set_drvdata(&pdev->dev, mmc);
+
+	/* harmless (maybe) magic */
+	pci_read_config_dword(chip->pdev, 0x48, &val);
+	val = cb710_src_freq_mhz[(val >> 16) & 0xF];
+	dev_dbg(cb710_slot_dev(slot), "source frequency: %dMHz\n", val);
+	val *= 1000000;
+
+	mmc->ops = &cb710_mmc_host;
+	mmc->f_max = val;
+	mmc->f_min = val >> cb710_clock_divider_log2[CB710_MAX_DIVIDER_IDX];
+	mmc->ocr_avail = MMC_VDD_32_33|MMC_VDD_33_34|MMC_VDD_34_35;
+	mmc->caps = MMC_CAP_4_BIT_DATA;
+
+	reader = mmc_priv(mmc);
+
+	tasklet_init(&reader->finish_req_tasklet,
+		cb710_mmc_finish_request_tasklet, (unsigned long)mmc);
+	spin_lock_init(&reader->irq_lock);
+#ifdef VERBOSE_DEBUG
+	spin_lock_init(&reader->serialization_lock);
+#endif
+	cb710_dump_regs(chip, CB710_DUMP_REGS_MMC);
+
+	cb710_mmc_enable_irq(slot, 0);
+	cb710_set_irq_handler(slot, cb710_mmc_irq_handler);
+
+	err = mmc_add_host(mmc);
+	if (likely(!err)) {
+		dev_dbg(cb710_slot_dev(slot), "mmc_hostname is %s\n",
+			mmc_hostname(mmc));
+		return 0;
+	}
+
+	dev_dbg(cb710_slot_dev(slot), "mmc_add_host() failed: %d\n", err);
+
+	mmc_free_host(mmc);
+	return err;
+}
+
+static int __devexit cb710_mmc_exit(struct platform_device *pdev)
+{
+	struct cb710_slot *slot = cb710_pdev_to_slot(pdev);
+	struct mmc_host *mmc = cb710_slot_to_mmc(slot);
+	struct cb710_mmc_reader *reader = mmc_priv(mmc);
+
+	mmc_remove_host(mmc);
+
+	/* XXX what if IRQ arrives now? */
+
+	cb710_mmc_enable_irq(slot, 0);
+	cb710_set_irq_handler(slot, NULL);
+
+	/* clear config ports - just in case */
+	cb710_write_port_32(slot, CB710_MMC_CONFIG_PORT, 0);
+	cb710_write_port_16(slot, CB710_MMC_CONFIGB_PORT, 0);
+
+	tasklet_kill(&reader->finish_req_tasklet);
+
+	mmc_free_host(mmc);
+	return 0;
+}
+
+static struct platform_driver cb710_mmc_driver = {
+	.driver.name = "cb710-mmc",
+	.probe = cb710_mmc_init,
+	.remove = __devexit_p(cb710_mmc_exit),
+#ifdef CONFIG_PM
+	.suspend = cb710_mmc_suspend,
+	.resume = cb710_mmc_resume,
+#endif
+};
+
+static int __init cb710_mmc_init_module(void)
+{
+	return platform_driver_register(&cb710_mmc_driver);
+}
+
+static void __exit cb710_mmc_cleanup_module(void)
+{
+	platform_driver_unregister(&cb710_mmc_driver);
+}
+
+module_init(cb710_mmc_init_module);
+module_exit(cb710_mmc_cleanup_module);
+
+MODULE_AUTHOR("Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>");
+MODULE_DESCRIPTION("ENE CB710 memory card reader driver - MMC/SD part");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:cb710-mmc");
diff -urN empty/sgbuf.c cb710/sgbuf.c
--- empty/sgbuf.c	1970-01-01 01:00:00.000000000 +0100
+++ cb710/sgbuf.c	2008-09-21 16:48:04.000000000 +0200
@@ -0,0 +1,206 @@
+/*
+ *  cb710/sgbuf.c
+ *
+ *  Copyright by Micha³ Miros³aw, 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/highmem.h>
+#include <linux/scatterlist.h>
+#include "cb710-sg.h"
+
+#ifdef VERBOSE_DEBUG
+#define sg_debug(fmt, arg...) \
+	pr_debug("sg[0x%p]: " fmt, buf, ##arg)
+#else
+#define sg_debug(fmt, arg...) \
+	do { if (0) pr_debug("sg[0x%p]: " fmt, buf, ##arg); } while (0)
+#endif
+
+static void cb710_sg_init_element(struct cb710_sg_chain *buf)
+{
+	buf->cur_offset = 0;
+	buf->page_offset = buf->sg->offset & ~PAGE_MASK;
+	buf->page_no = buf->sg->offset >> PAGE_SHIFT;
+	buf->page = nth_page(sg_page(buf->sg), buf->page_no);
+
+	sg_debug("moved to new scatterlist entry: first page +%d, poffs=%d, len=%d\n",
+		buf->page_no, buf->page_offset, buf->sg->length);
+}
+
+static void cb710_sg_unmap_page(struct cb710_sg_chain *buf, int to_sg)
+{
+	sg_debug("unmapping %s page\n", to_sg ? "written" : "read");
+
+	if (to_sg)
+		flush_kernel_dcache_page(buf->page);
+	kunmap_atomic(buf->mapped_page, KM_BIO_SRC_IRQ);
+	buf->mapped_page = NULL;
+}
+
+static int cb710_sg_advance(struct cb710_sg_chain *buf, int advance, int to_sg)
+{
+	size_t rlen;
+	unsigned page_end;
+
+	buf->cur_offset += advance;
+	buf->page_offset += advance;
+	rlen = buf->sg->length - buf->cur_offset;
+
+	sg_debug("advanced %d bytes; cur_offset=%d, page_offset=%d, rlen=%d\n",
+		advance, buf->cur_offset, buf->page_offset, rlen);
+
+	if (!rlen || buf->page_offset == PAGE_SIZE) {
+		if (buf->mapped_page)
+			cb710_sg_unmap_page(buf, to_sg);
+
+		if (!rlen) {
+			if (!--buf->sg_num) {
+				buf->need_bounce = 1;
+				return 0;
+			}
+			buf->sg = sg_next(buf->sg);
+			cb710_sg_init_element(buf);
+			rlen = buf->sg->length;
+		} else {
+			buf->page_offset = 0;
+			buf->page = nth_page(sg_page(buf->sg), ++buf->page_no);
+		}
+	}
+
+	page_end = (buf->page_offset + PAGE_SIZE) & PAGE_MASK;
+	buf->page_left = page_end - buf->page_offset;
+	if (buf->page_left > rlen)
+		buf->page_left = rlen;
+	if (buf->page_left < CB710_SG_BUFFER_BLOCK)
+		buf->need_bounce = 1;
+
+	if (!buf->mapped_page) {
+		buf->mapped_page = kmap_atomic(buf->page, KM_BIO_SRC_IRQ);
+		sg_debug("mapped new page: +%d @0x%p\n",
+			buf->page_no, buf->mapped_page);
+	}
+
+	return 1;
+}
+
+void cb710_sg_init(struct cb710_sg_chain *buf,
+	struct scatterlist *sg, size_t nelem)
+{
+	sg_debug("init: %d elements\n", nelem);
+	BUG_ON(!nelem);
+	BUG_ON(sg_is_chain(sg));
+
+	memset(buf, 0, sizeof(*buf));
+	buf->sg = sg;
+	buf->sg_num = nelem;
+	cb710_sg_init_element(buf);
+	cb710_sg_advance(buf, 0, 0);
+}
+EXPORT_SYMBOL_GPL(cb710_sg_init);
+
+static int cb710_sg_use_bounce(struct cb710_sg_chain *buf, int to_sg)
+{
+	size_t len = 0;
+	size_t bounce_offset = 0;
+
+	do {
+		len = CB710_SG_BUFFER_BLOCK - bounce_offset;
+		if (len > buf->sg->length - buf->cur_offset)
+			len = buf->sg->length - buf->cur_offset;
+
+		if (to_sg)
+			memcpy(buf->mapped_page + buf->page_offset,
+				buf->bounce_buffer + bounce_offset, len);
+		else
+			memcpy(buf->bounce_buffer + bounce_offset,
+				buf->mapped_page + buf->page_offset, len);
+
+		bounce_offset += len;
+	} while (cb710_sg_advance(buf, len, to_sg)
+		&& bounce_offset < CB710_SG_BUFFER_BLOCK);
+
+	sg_debug("%d bytes %s sg via bounce_buffer\n",
+		bounce_offset, to_sg ? "written to" : "to read from");
+	return bounce_offset;
+}
+
+static size_t cb710_sg_bounce_space(struct cb710_sg_chain *buf)
+{
+	struct scatterlist *sg;
+	unsigned i;
+	size_t len = buf->sg->length - buf->cur_offset;
+
+	if (len >= CB710_SG_BUFFER_BLOCK)
+		return CB710_SG_BUFFER_BLOCK;
+	if (buf->sg_num == 1)
+		return len;
+
+	for_each_sg(sg_next(buf->sg), sg, buf->sg_num - 1, i) {
+		len += sg->length;
+		if (len >= CB710_SG_BUFFER_BLOCK)
+			return CB710_SG_BUFFER_BLOCK;
+	}
+
+	return len;
+}
+
+int cb710_sg_next_buf(struct cb710_sg_chain *buf,
+	void **dataptr, size_t *len, int to_sg)
+{
+	sg_debug("next buffer to %s\n", to_sg ? "write" : "read");
+
+	if (buf->use_bounce) {
+		buf->use_bounce = 0;
+		cb710_sg_use_bounce(buf, 1);
+	}
+
+	if (buf->need_advance) {
+		cb710_sg_advance(buf, buf->need_advance, to_sg);
+		buf->need_advance = 0;
+	}
+
+	if (!buf->need_bounce) {
+		BUG_ON(!buf->mapped_page);
+
+		*dataptr = buf->mapped_page + buf->page_offset;
+		buf->need_advance = *len =
+			buf->page_left & CB710_SG_BUFFER_MASK;
+
+		sg_debug("%d bytes mapped directly\n", *len);
+		return 1;
+	}
+
+	if (!buf->sg_num)
+		return 0;
+
+	buf->need_bounce = 0;
+	*dataptr = &buf->bounce_buffer;
+
+	if (to_sg) {
+		*len = cb710_sg_bounce_space(buf);
+		buf->use_bounce = 1;
+
+		sg_debug("using bounce_buffer for writing %d bytes\n",
+			*len);
+	} else
+		*len = cb710_sg_use_bounce(buf, 0);
+
+	return *len != 0;
+}
+EXPORT_SYMBOL_GPL(cb710_sg_next_buf);
+
+void cb710_sg_abort(struct cb710_sg_chain *buf, int to_sg)
+{
+	sg_debug("aborting %s\n", to_sg ? "write" : "read");
+
+	if (buf->mapped_page)
+		cb710_sg_unmap_page(buf, to_sg);
+}
+EXPORT_SYMBOL_GPL(cb710_sg_abort);
+
