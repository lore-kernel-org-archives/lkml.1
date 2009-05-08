Return-Path: <linux-kernel-owner+w=401wt.eu-S1762321AbZEHPYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762321AbZEHPYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755778AbZEHPYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:24:32 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:50378 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762747AbZEHPY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:24:28 -0400
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 May 2009 11:24:26 EDT
Date: Fri, 8 May 2009 17:16:22 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq@rere.qmqm.pl>
To: Pierre Ossman <pierre@ossman.eu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH/RFC 2.6.29.2] Driver for CB710/720 memory card reader (MMC
	part) - v4
Message-ID: <20090508151622.GA23006@rere.qmqm.pl>
References: <20080909090613.GA22158@rere.qmqm.pl> <20080911201307.GA31730@rere.qmqm.pl> <20080912234302.GA19230@rere.qmqm.pl> <20080920130006.69d50cbb@mjolnir.drzeus.cx> <20080925062924.GA32105@rere.qmqm.pl> <20081004215122.0626cd7b@mjolnir.drzeus.cx> <20081029141146.GA17741@rere.qmqm.pl> <20081114220658.38f0645c@mjolnir.drzeus.cx> <20090201185435.GA9165@rere.qmqm.pl> <20090221134603.6bc3c385@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090221134603.6bc3c385@mjolnir.ossman.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is next version of the CB710 SD/MMC reader driver. As in previous
versions the code is divided in two parts - virtual 'bus' driver that
handles PCI device and registers three new devices one per card reader
type. The other device handles SD/MMC part of the reader.

Key changes from v3:
 - kerneldoc for sg_mapping_iterator extension
 - free/restore IRQ during suspend/resume
 - protect slot->irq_handler by spinlock instead of RCU
 - remove verify_serialization()
 - Kconfig
 - complete patch for linux kernel 2.6.29.2

My patches for sg_mapping_iterator extension went to /dev/null, so I have
incorporated them to the cb710 core driver module for now. Probably someone
with more karma points should look at them (sgbuf2.{c,h}) and push further
if they are of any value to other driver writers.

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

diff -urN linux-2.6.29.2/drivers/misc/cb710/core.c cb710-tree/drivers/misc/cb710/core.c
--- linux-2.6.29.2/drivers/misc/cb710/core.c	1970-01-01 01:00:00.000000000 +0100
+++ cb710-tree/drivers/misc/cb710/core.c	2009-05-04 20:31:59.000000000 +0200
@@ -0,0 +1,356 @@
+/*
+ *  cb710/core.c
+ *
+ *  Copyright by Micha³ Miros³aw, 2008-2009
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <linux/idr.h>
+#include <linux/cb710.h>
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
+	irqreturn_t handled = IRQ_NONE;
+	unsigned nr;
+
+	spin_lock(&chip->irq_lock); /* incl. smp_rmb() */
+
+	for (nr = chip->slots; nr; ++slot, --nr) {
+		cb710_irq_handler_t handler_func = slot->irq_handler;
+		if (handler_func && handler_func(slot))
+			handled = IRQ_HANDLED;
+	}
+
+	spin_unlock(&chip->irq_lock);
+
+	return handled;
+}
+
+static void cb710_release_slot(struct device *dev)
+{
+#ifdef CONFIG_CB710_DEBUG_ASSUMPTIONS
+	struct cb710_slot *slot = cb710_pdev_to_slot(to_platform_device(dev));
+	struct cb710_chip *chip = cb710_slot_to_chip(slot);
+
+	/* slot struct can be freed now */
+	atomic_dec(&chip->slot_refs_count);
+#endif
+}
+
+static int __devinit cb710_register_slot(struct cb710_chip *chip,
+	unsigned slot_mask, unsigned io_offset, const char *name)
+{
+	int nr = chip->slots;
+	struct cb710_slot *slot = &chip->slot[nr];
+	int err;
+
+	dev_dbg(cb710_chip_dev(chip),
+		"register: %s.%d; slot %d; mask %d; IO offset: 0x%02X\n",
+		name, chip->platform_id, nr, slot_mask, io_offset);
+
+	/* slot->irq_handler == NULL here; this needs to be
+	 * seen before platform_device_register() */
+	++chip->slots;
+	smp_wmb();
+
+	slot->iobase = chip->iobase + io_offset;
+	slot->pdev.name = name;
+	slot->pdev.id = chip->platform_id;
+	slot->pdev.dev.parent = &chip->pdev->dev;
+	slot->pdev.dev.release = cb710_release_slot;
+
+	err = platform_device_register(&slot->pdev);
+
+#ifdef CONFIG_CB710_DEBUG_ASSUMPTIONS
+	atomic_inc(&chip->slot_refs_count);
+#endif
+
+	if (err) {
+		/* device_initialize() called from platform_device_register()
+		 * wants this on error path */
+		platform_device_put(&slot->pdev);
+
+		/* slot->irq_handler == NULL here anyway, so no lock needed */
+		--chip->slots;
+		return err;
+	}
+
+	chip->slot_mask |= slot_mask;
+
+	return 0;
+}
+
+static void cb710_unregister_slot(struct cb710_chip *chip,
+	unsigned slot_mask)
+{
+	int nr = chip->slots - 1;
+
+	if (!(chip->slot_mask & slot_mask))
+		return;
+
+	platform_device_unregister(&chip->slot[nr].pdev);
+
+	/* complementary to spin_unlock() in cb710_set_irq_handler() */
+	smp_rmb();
+	BUG_ON(chip->slot[nr].irq_handler != NULL);
+
+	/* slot->irq_handler == NULL here, so no lock needed */
+	--chip->slots;
+	chip->slot_mask &= ~slot_mask;
+}
+
+void cb710_set_irq_handler(struct cb710_slot *slot,
+	cb710_irq_handler_t handler)
+{
+	struct cb710_chip *chip = cb710_slot_to_chip(slot);
+	unsigned long flags;
+
+	spin_lock_irqsave(&chip->irq_lock, flags);
+	slot->irq_handler = handler;
+	spin_unlock_irqrestore(&chip->irq_lock, flags);
+}
+EXPORT_SYMBOL_GPL(cb710_set_irq_handler);
+
+#ifdef CONFIG_PM
+
+static int cb710_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct cb710_chip *chip = pci_get_drvdata(pdev);
+
+	free_irq(pdev->irq, chip);
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
+	if (state.event & PM_EVENT_SLEEP)
+		pci_set_power_state(pdev, PCI_D3cold);
+	return 0;
+}
+
+static int cb710_resume(struct pci_dev *pdev)
+{
+	struct cb710_chip *chip = pci_get_drvdata(pdev);
+	int err;
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+	err = pcim_enable_device(pdev);
+	if (err)
+		return err;
+
+	return devm_request_irq(&pdev->dev, pdev->irq,
+		cb710_irq_handler, IRQF_SHARED, KBUILD_MODNAME, chip);
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
+	err = pcim_iomap_regions(pdev, 0x0001, KBUILD_MODNAME);
+	if (err)
+		return err;
+
+	chip->pdev = pdev;
+	chip->iobase = pcim_iomap_table(pdev)[0];
+
+	pci_set_drvdata(pdev, chip);
+
+	err = devm_request_irq(&pdev->dev, pdev->irq,
+		cb710_irq_handler, IRQF_SHARED, KBUILD_MODNAME, chip);
+	if (err)
+		return err;
+
+	do {
+		if (!idr_pre_get(&cb710_idr, GFP_KERNEL))
+			return -ENOMEM;
+
+		spin_lock_irqsave(&cb710_idr_lock, flags);
+		err = idr_get_new(&cb710_idr, chip, &chip->platform_id);
+		spin_unlock_irqrestore(&cb710_idr_lock, flags);
+
+		if (err && err != -EAGAIN)
+			return err;
+	} while (err);
+
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
+
+#ifdef CONFIG_CB710_DEBUG_ASSUMPTIONS
+	BUG_ON(atomic_read(&chip->slot_refs_count) != 0);
+#endif
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
+#ifdef CONFIG_CB710_DEBUG_ASSUMPTIONS
+	BUG_ON(atomic_read(&chip->slot_refs_count) != 0);
+#endif
+
+	spin_lock_irqsave(&cb710_idr_lock, flags);
+	idr_remove(&cb710_idr, chip->platform_id);
+	spin_unlock_irqrestore(&cb710_idr_lock, flags);
+}
+
+static const struct pci_device_id cb710_pci_tbl[] = {
+	{ PCI_VENDOR_ID_ENE, PCI_DEVICE_ID_ENE_CB710_FLASH,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{ 0, }
+};
+
+static struct pci_driver cb710_driver = {
+	.name = KBUILD_MODNAME,
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
diff -urN linux-2.6.29.2/drivers/misc/cb710/debug.c cb710-tree/drivers/misc/cb710/debug.c
--- linux-2.6.29.2/drivers/misc/cb710/debug.c	1970-01-01 01:00:00.000000000 +0100
+++ cb710-tree/drivers/misc/cb710/debug.c	2009-05-04 20:29:38.000000000 +0200
@@ -0,0 +1,119 @@
+/*
+ *  cb710/debug.c
+ *
+ *  Copyright by Micha³ Miros³aw, 2008-2009
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/cb710.h>
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
diff -urN linux-2.6.29.2/drivers/misc/cb710/Kconfig cb710-tree/drivers/misc/cb710/Kconfig
--- linux-2.6.29.2/drivers/misc/cb710/Kconfig	1970-01-01 01:00:00.000000000 +0100
+++ cb710-tree/drivers/misc/cb710/Kconfig	2009-05-04 20:29:38.000000000 +0200
@@ -0,0 +1,21 @@
+config CB710_CORE
+	tristate "ENE CB710/720 Flash memory card reader support"
+	depends on PCI
+	help
+	  This option enables support for PCI ENE CB710/720 Flash memory card
+	  reader found in some laptops (ie. some versions of HP Compaq nx9500).
+
+	  You will also have to select some flash card format drivers (MMC/SD,
+	  MemoryStick).
+
+	  This driver can also be built as a module. If so, the module
+	  will be called cb710.
+
+config CB710_DEBUG
+	bool "Enable driver debugging"
+	depends on CB710_CORE != n
+	default n
+	help
+	  This is an option for use by developers; most people should
+	  say N here.  This adds a lot of debugging output to dmesg.
+
diff -urN linux-2.6.29.2/drivers/misc/cb710/Makefile cb710-tree/drivers/misc/cb710/Makefile
--- linux-2.6.29.2/drivers/misc/cb710/Makefile	1970-01-01 01:00:00.000000000 +0100
+++ cb710-tree/drivers/misc/cb710/Makefile	2009-05-04 20:29:38.000000000 +0200
@@ -0,0 +1,4 @@
+obj-$(CONFIG_CB710_CORE)	+= cb710.o
+
+cb710-y				:= core.o sgbuf2.o
+cb710-$(CONFIG_CB710_DEBUG)	+= debug.o
diff -urN linux-2.6.29.2/drivers/misc/cb710/sgbuf2.c cb710-tree/drivers/misc/cb710/sgbuf2.c
--- linux-2.6.29.2/drivers/misc/cb710/sgbuf2.c	1970-01-01 01:00:00.000000000 +0100
+++ cb710-tree/drivers/misc/cb710/sgbuf2.c	2009-05-04 20:29:38.000000000 +0200
@@ -0,0 +1,150 @@
+/*
+ *  cb710/sgbuf2.c
+ *
+ *  Copyright by Micha³ Miros³aw, 2008-2009
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sgbuf2.h>
+
+static bool sg_dwiter_next(struct sg_mapping_iter *miter)
+{
+	if (sg_miter_next(miter)) {
+		miter->consumed = 0;
+		return true;
+	} else
+		return false;
+}
+
+static bool sg_dwiter_is_at_end(struct sg_mapping_iter *miter)
+{
+	return miter->length == miter->consumed && !sg_dwiter_next(miter);
+}
+
+static uint32_t sg_dwiter_read_buffer(struct sg_mapping_iter *miter)
+{
+	size_t len, left = 4;
+	uint32_t data;
+	void *addr = &data;
+
+	do {
+		len = min(miter->length - miter->consumed, left);
+		memcpy(addr, miter->addr + miter->consumed, len);
+		miter->consumed += len;
+		left -= len;
+		if (!left)
+			return data;
+		addr += len;
+	} while (sg_dwiter_next(miter));
+
+	memset(addr, 0, left);
+	return data;
+}
+
+static inline bool needs_unaligned_copy(const void *ptr)
+{
+#ifdef HAVE_EFFICIENT_UNALIGNED_ACCESS
+	return false;
+#else
+	return ((ptr - NULL) & 3) != 0;
+#endif
+}
+
+static bool sg_dwiter_get_next_block(struct sg_mapping_iter *miter, uint32_t **ptr)
+{
+	size_t len;
+
+	if (sg_dwiter_is_at_end(miter))
+		return true;
+
+	len = miter->length - miter->consumed;
+
+	if (likely(len >= 4 && !needs_unaligned_copy(
+			miter->addr + miter->consumed))) {
+		*ptr = miter->addr + miter->consumed;
+		miter->consumed += 4;
+		return true;
+	}
+
+	return false;
+}
+
+/**
+ * sg_dwiter_read_next_block() - get next 32-bit word from sg buffer
+ * @miter: sg mapping iterator used for reading
+ *
+ * Description:
+ *   Returns 32-bit word starting at byte pointed to by @miter@
+ *   handling any alignment issues.  Bytes past the buffer's end
+ *   are not accessed (read) but are returned as zeroes.  @miter@
+ *   is advanced by 4 bytes or to the end of buffer whichever is
+ *   closer.
+ *
+ * Context:
+ *   Same requirements as in sg_miter_next().
+ *
+ * Returns:
+ *   32-bit word just read.
+ */
+uint32_t sg_dwiter_read_next_block(struct sg_mapping_iter *miter)
+{
+	uint32_t *ptr = NULL;
+
+	if (likely(sg_dwiter_get_next_block(miter, &ptr)))
+		return ptr ? *ptr : 0;
+
+	return sg_dwiter_read_buffer(miter);
+}
+EXPORT_SYMBOL_GPL(sg_dwiter_read_next_block);
+
+static void sg_dwiter_write_slow(struct sg_mapping_iter *miter, uint32_t data)
+{
+	size_t len, left = 4;
+	void *addr = &data;
+
+	do {
+		len = min(miter->length - miter->consumed, left);
+		memcpy(miter->addr, addr, len);
+		miter->consumed += len;
+		left -= len;
+		if (!left)
+			return;
+		addr += len;
+		flush_kernel_dcache_page(miter->page);
+	} while (sg_dwiter_next(miter));
+}
+
+/**
+ * sg_dwiter_write_next_block() - write next 32-bit word to sg buffer
+ * @miter: sg mapping iterator used for writing
+ *
+ * Description:
+ *   Writes 32-bit word starting at byte pointed to by @miter@
+ *   handling any alignment issues.  Bytes which would be written
+ *   past the buffer's end are silently discarded. @miter@ is
+ *   advanced by 4 bytes or to the end of buffer whichever is closer.
+ *
+ * Context:
+ *   Same requirements as in sg_miter_next().
+ */
+void sg_dwiter_write_next_block(struct sg_mapping_iter *miter, uint32_t data)
+{
+	uint32_t *ptr = NULL;
+
+	if (likely(sg_dwiter_get_next_block(miter, &ptr))) {
+		if (ptr)
+			*ptr = data;
+		else
+			return;
+	} else
+		sg_dwiter_write_slow(miter, data);
+
+	if (miter->length == miter->consumed)
+		flush_kernel_dcache_page(miter->page);
+}
+EXPORT_SYMBOL_GPL(sg_dwiter_write_next_block);
+
diff -urN linux-2.6.29.2/drivers/misc/Kconfig cb710-tree/drivers/misc/Kconfig
--- linux-2.6.29.2/drivers/misc/Kconfig	2009-05-04 20:39:00.000000000 +0200
+++ cb710-tree/drivers/misc/Kconfig	2009-05-04 20:38:42.000000000 +0200
@@ -225,5 +225,6 @@
 
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
+source "drivers/misc/cb710/Kconfig"
 
 endif # MISC_DEVICES
diff -urN linux-2.6.29.2/drivers/misc/Makefile cb710-tree/drivers/misc/Makefile
--- linux-2.6.29.2/drivers/misc/Makefile	2009-05-04 20:39:04.000000000 +0200
+++ cb710-tree/drivers/misc/Makefile	2009-05-04 20:38:44.000000000 +0200
@@ -20,3 +20,4 @@
 obj-$(CONFIG_HP_ILO)		+= hpilo.o
 obj-$(CONFIG_C2PORT)		+= c2port/
 obj-y				+= eeprom/
+obj-y				+= cb710/
diff -urN linux-2.6.29.2/drivers/mmc/host/cb710-mmc.c cb710-tree/drivers/mmc/host/cb710-mmc.c
--- linux-2.6.29.2/drivers/mmc/host/cb710-mmc.c	1970-01-01 01:00:00.000000000 +0100
+++ cb710-tree/drivers/mmc/host/cb710-mmc.c	2009-05-04 20:34:25.000000000 +0200
@@ -0,0 +1,805 @@
+/*
+ *  cb710/mmc.c
+ *
+ *  Copyright by Micha³ Miros³aw, 2008-2009
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
+#include <linux/sgbuf2.h>
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
+static void __cb710_mmc_enable_irq(struct cb710_slot *slot,
+	unsigned short enable, unsigned short mask)
+{
+	/* clear global IE
+	 * - it gets set later if any interrupt sources are enabled */
+	mask |= CB710_MMC_IE_IRQ_ENABLE;
+
+	/* look like interrupt is fired whenever
+	 * WORD[0x0C] & WORD[0x10] != 0;
+	 * -> bit 15 port 0x0C seems to be global interrupt enable
+	 */
+
+	enable = (cb710_read_port_16(slot, CB710_MMC_IRQ_ENABLE_PORT)
+		& ~mask) | enable;
+
+	if (enable)
+		enable |= CB710_MMC_IE_IRQ_ENABLE;
+
+	cb710_write_port_16(slot, CB710_MMC_IRQ_ENABLE_PORT, enable);
+}
+
+static void cb710_mmc_enable_irq(struct cb710_slot *slot,
+	unsigned short enable, unsigned short mask)
+{
+	struct cb710_mmc_reader *reader = mmc_priv(cb710_slot_to_mmc(slot));
+	unsigned long flags;
+
+	spin_lock_irqsave(&reader->irq_lock, flags);
+	/* this is the only thing irq_lock protects */
+	__cb710_mmc_enable_irq(slot, enable, mask);
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
+#ifdef CONFIG_CB710_DEBUG
+	u32 e, x;
+	e = cb710_read_port_32(slot, CB710_MMC_STATUS_PORT);
+#endif
+
+	while (!(err = cb710_check_event(slot, what))) {
+		if (!--limit) {
+			cb710_dump_regs(cb710_slot_to_chip(slot),
+				CB710_DUMP_REGS_MMC);
+			err = -ETIMEDOUT;
+			break;
+		}
+		udelay(1);
+	}
+
+#ifdef CONFIG_CB710_DEBUG
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
+#ifdef CONFIG_CB710_DEBUG
+	u32 e, x;
+	e = cb710_read_port_32(slot, CB710_MMC_STATUS_PORT);
+#endif
+
+	while (cb710_read_port_8(slot, CB710_MMC_STATUS2_PORT) & mask) {
+		if (!--limit) {
+			cb710_dump_regs(cb710_slot_to_chip(slot),
+				CB710_DUMP_REGS_MMC);
+			err = -ETIMEDOUT;
+			break;
+		}
+		udelay(1);
+	}
+
+#ifdef CONFIG_CB710_DEBUG
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
+static int cb710_mmc_receive_pio(struct cb710_slot *slot,
+	struct sg_mapping_iter *miter, size_t dw_count)
+{
+	if (!(cb710_read_port_8(slot, CB710_MMC_STATUS2_PORT) & CB710_MMC_S2_FIFO_READY)) {
+		int err = cb710_wait_for_event(slot,
+			CB710_MMC_S1_PIO_TRANSFER_DONE);
+		if (err)
+			return err;
+	}
+
+	sg_dwiter_write_from_io(miter,
+		slot->iobase + CB710_MMC_DATA_PORT, dw_count);
+
+	return 0;
+}
+
+static bool cb710_is_transfer_size_supported(struct mmc_data *data)
+{
+	return !(data->blksz & 15 && (data->blocks != 1 || data->blksz != 8));
+}
+
+static int cb710_mmc_receive(struct cb710_slot *slot, struct mmc_data *data)
+{
+	struct sg_mapping_iter miter;
+	size_t len, blocks = data->blocks;
+	int err = 0;
+
+	/* TODO: I don't know how/if the hardware handles non-16B-boundary blocks
+	 * except single 8B block */
+	if (unlikely(data->blksz & 15 && (data->blocks != 1 || data->blksz != 8)))
+		return -EINVAL;
+
+	sg_miter_start(&miter, data->sg, data->sg_len, 0);
+
+	cb710_modify_port_8(slot, CB710_MMC_CONFIG2_PORT,
+		15, CB710_MMC_C2_READ_PIO_SIZE_MASK);
+
+	cb710_mmc_fifo_hack(slot);
+
+	while (blocks-- > 0) {
+		len = data->blksz;
+
+		while (len >= 16) {
+			err = cb710_mmc_receive_pio(slot, &miter, 4);
+			if (err)
+				goto out;
+			len -= 16;
+		}
+
+		if (!len)
+			continue;
+
+		cb710_modify_port_8(slot, CB710_MMC_CONFIG2_PORT,
+			len - 1, CB710_MMC_C2_READ_PIO_SIZE_MASK);
+
+		len = (len >= 8) ? 4 : 2;
+		err = cb710_mmc_receive_pio(slot, &miter, len);
+		if (err)
+			goto out;
+	}
+out:
+	sg_miter_stop_writing(&miter);
+	return err;
+}
+
+static int cb710_mmc_send(struct cb710_slot *slot, struct mmc_data *data)
+{
+	struct sg_mapping_iter miter;
+	size_t len, blocks = data->blocks;
+	int err = 0;
+
+	/* TODO: I don't know how/if the hardware handles multiple
+	 * non-16B-boundary blocks */
+	if (unlikely(data->blocks > 1 && data->blksz & 15))
+		return -EINVAL;
+
+	sg_miter_start(&miter, data->sg, data->sg_len, 0);
+
+	cb710_modify_port_8(slot, CB710_MMC_CONFIG2_PORT,
+		0, CB710_MMC_C2_READ_PIO_SIZE_MASK);
+
+	while (blocks-- > 0) {
+		len = (data->blksz + 15) >> 4;
+		do {
+			if (!(cb710_read_port_8(slot, CB710_MMC_STATUS2_PORT)
+			    & CB710_MMC_S2_FIFO_EMPTY)) {
+				err = cb710_wait_for_event(slot,
+					CB710_MMC_S1_PIO_TRANSFER_DONE);
+				if (err)
+					goto out;
+			}
+			sg_dwiter_read_to_io(&miter,
+				slot->iobase + CB710_MMC_DATA_PORT, 4);
+		} while (--len);
+	}
+out:
+	sg_miter_stop(&miter);
+	return err;
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
+	 *
+	 * Original driver set bit 14 for MMC/SD application
+	 * commands. There's no difference 'on the wire' and
+	 * it apparently works without it anyway.
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
+	/* Looks like final byte with CRC is always stripped (same as SDHCI) */
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
+	if (!error)
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
+	if (data) {
+		if (!cb710_is_transfer_size_supported(data)) {
+			data->error = -EINVAL;
+			return -1;
+		}
+		cb710_mmc_set_transfer_size(slot, data->blocks, data->blksz);
+	}
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
+	WARN_ON(reader->mrq != NULL);
+
+	reader->mrq = mrq;
+	cb710_mmc_enable_irq(slot, CB710_MMC_IE_TEST_MASK, 0);
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
+}
+
+static int cb710_mmc_powerup(struct cb710_slot *slot)
+{
+#ifdef CONFIG_CB710_DEBUG
+	struct cb710_chip *chip = cb710_slot_to_chip(slot);
+#endif
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
+	 * (it doesn't depend on write-to-read delay) */
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
+	cb710_mmc_enable_irq(slot, CB710_MMC_IE_TEST_MASK, 0);
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
+		/* ack the event */
+		cb710_write_port_8(slot, CB710_MMC_STATUS1_PORT,
+			CB710_MMC_S1_CARD_CHANGED);
+		if ((irqen & CB710_MMC_IE_CISTATUS_MASK)
+		    == CB710_MMC_IE_CISTATUS_MASK)
+			mmc_detect_change(mmc, HZ/5);
+	} else {
+		dev_dbg(cb710_slot_dev(slot), "unknown interrupt (test)\n");
+		spin_lock(&reader->irq_lock);
+		__cb710_mmc_enable_irq(slot, 0, CB710_MMC_IE_TEST_MASK);
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
+	cb710_mmc_enable_irq(slot, 0, ~0);
+	return 0;
+}
+
+static int cb710_mmc_resume(struct platform_device *pdev)
+{
+	struct cb710_slot *slot = cb710_pdev_to_slot(pdev);
+	struct mmc_host *mmc = cb710_slot_to_mmc(slot);
+
+	cb710_mmc_enable_irq(slot, 0, ~0);
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
+	mmc->ocr_avail = MMC_VDD_32_33|MMC_VDD_33_34;
+	mmc->caps = MMC_CAP_4_BIT_DATA;
+
+	reader = mmc_priv(mmc);
+
+	tasklet_init(&reader->finish_req_tasklet,
+		cb710_mmc_finish_request_tasklet, (unsigned long)mmc);
+	spin_lock_init(&reader->irq_lock);
+	cb710_dump_regs(chip, CB710_DUMP_REGS_MMC);
+
+	cb710_mmc_enable_irq(slot, 0, ~0);
+	cb710_set_irq_handler(slot, cb710_mmc_irq_handler);
+
+	err = mmc_add_host(mmc);
+	if (unlikely(err))
+		goto err_free_mmc;
+
+	dev_dbg(cb710_slot_dev(slot), "mmc_hostname is %s\n",
+		mmc_hostname(mmc));
+
+	cb710_mmc_enable_irq(slot, CB710_MMC_IE_CARD_INSERTION_STATUS, 0);
+
+	return 0;
+
+err_free_mmc:
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
+	cb710_mmc_enable_irq(slot, 0, CB710_MMC_IE_CARD_INSERTION_STATUS);
+
+	mmc_remove_host(mmc);
+
+	/* IRQs should be disabled now, but let's stay on the safe side */
+	cb710_mmc_enable_irq(slot, 0, ~0);
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
diff -urN linux-2.6.29.2/drivers/mmc/host/cb710-mmc.h cb710-tree/drivers/mmc/host/cb710-mmc.h
--- linux-2.6.29.2/drivers/mmc/host/cb710-mmc.h	1970-01-01 01:00:00.000000000 +0100
+++ cb710-tree/drivers/mmc/host/cb710-mmc.h	2009-05-04 20:34:15.000000000 +0200
@@ -0,0 +1,104 @@
+/*
+ *  cb710/cb710-mmc.h
+ *
+ *  Copyright by Micha³ Miros³aw, 2008-2009
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef LINUX_CB710_MMC_H
+#define LINUX_CB710_MMC_H
+
+#include <linux/cb710.h>
+
+/* per-MMC-reader structure */
+struct cb710_mmc_reader {
+	struct tasklet_struct finish_req_tasklet;
+	struct mmc_request *mrq;
+	spinlock_t irq_lock;
+	unsigned char last_power_mode;
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
+#define   CB710_MMC_IE_TEST_MASK		0x00BF
+#define   CB710_MMC_IE_CARD_INSERTION_STATUS	0x1000
+#define   CB710_MMC_IE_IRQ_ENABLE		0x8000
+#define   CB710_MMC_IE_CISTATUS_MASK		\
+		(CB710_MMC_IE_CARD_INSERTION_STATUS|CB710_MMC_IE_IRQ_ENABLE)
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
diff -urN linux-2.6.29.2/drivers/mmc/host/Kconfig cb710-tree/drivers/mmc/host/Kconfig
--- linux-2.6.29.2/drivers/mmc/host/Kconfig	2009-05-04 20:39:37.000000000 +0200
+++ cb710-tree/drivers/mmc/host/Kconfig	2009-05-04 20:38:22.000000000 +0200
@@ -213,3 +213,15 @@
 	  This provides support for the SD/MMC cell found in TC6393XB,
 	  T7L66XB and also ipaq ASIC3
 
+config MMC_CB710
+	tristate "ENE CB710 MMC/SD Interface support"
+	depends on PCI
+	select CB710_CORE
+	help
+	  This option enables support for MMC/SD part of ENE CB710/720 Flash
+	  memory card reader found in some laptops (ie. some versions of
+	  HP Compaq nx9500).
+
+	  This driver can also be built as a module. If so, the module
+	  will be called cb710-mmc.
+
diff -urN linux-2.6.29.2/drivers/mmc/host/Makefile cb710-tree/drivers/mmc/host/Makefile
--- linux-2.6.29.2/drivers/mmc/host/Makefile	2009-05-04 20:39:18.000000000 +0200
+++ cb710-tree/drivers/mmc/host/Makefile	2009-05-04 20:38:26.000000000 +0200
@@ -27,4 +27,5 @@
 obj-$(CONFIG_MMC_S3C)   	+= s3cmci.o
 obj-$(CONFIG_MMC_SDRICOH_CS)	+= sdricoh_cs.o
 obj-$(CONFIG_MMC_TMIO)		+= tmio_mmc.o
+obj-$(CONFIG_MMC_CB710)	+= cb710-mmc.o
 
diff -urN linux-2.6.29.2/include/linux/cb710.h cb710-tree/include/linux/cb710.h
--- linux-2.6.29.2/include/linux/cb710.h	1970-01-01 01:00:00.000000000 +0100
+++ cb710-tree/include/linux/cb710.h	2009-05-04 20:29:59.000000000 +0200
@@ -0,0 +1,134 @@
+/*
+ *  cb710/cb710.h
+ *
+ *  Copyright by Micha³ Miros³aw, 2008-2009
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef LINUX_CB710_DRIVER_H
+#define LINUX_CB710_DRIVER_H
+
+#ifdef CONFIG_CB710_DEBUG
+#define DEBUG
+#endif
+
+/* verify assumptions on platform_device framework */
+#define CONFIG_CB710_DEBUG_ASSUMPTIONS
+
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/pci.h>
+#include <linux/platform_device.h>
+#include <linux/mmc/host.h>
+
+struct cb710_slot;
+
+typedef int (*cb710_irq_handler_t)(struct cb710_slot *);
+
+/* per-virtual-slot structure */
+struct cb710_slot {
+	struct platform_device	pdev;
+	void __iomem		*iobase;
+	cb710_irq_handler_t	irq_handler;
+};
+
+/* per-device structure */
+struct cb710_chip {
+	struct pci_dev		*pdev;
+	void __iomem		*iobase;
+	unsigned		platform_id;
+#ifdef CONFIG_CB710_DEBUG_ASSUMPTIONS
+	atomic_t		slot_refs_count;
+#endif
+	unsigned		slot_mask;
+	unsigned		slots;
+	spinlock_t		irq_lock;
+	struct cb710_slot	slot[0];
+};
+
+/* NOTE: cb710_chip.slots is modified only during device init/exit and
+ * they are all serialized wrt themselves */
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
+void cb710_set_irq_handler(struct cb710_slot *slot,
+	cb710_irq_handler_t handler);
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
+/* debugging aids */
+
+#ifdef CONFIG_CB710_DEBUG
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
diff -urN linux-2.6.29.2/include/linux/pci_ids.h cb710-tree/include/linux/pci_ids.h
--- linux-2.6.29.2/include/linux/pci_ids.h	2009-03-24 00:12:14.000000000 +0100
+++ cb710-tree/include/linux/pci_ids.h	2009-05-04 20:31:45.000000000 +0200
@@ -2077,6 +2077,7 @@
 #define PCI_VENDOR_ID_MAINPINE		0x1522
 #define PCI_DEVICE_ID_MAINPINE_PBRIDGE	0x0100
 #define PCI_VENDOR_ID_ENE		0x1524
+#define PCI_DEVICE_ID_ENE_CB710_FLASH	0x0510
 #define PCI_DEVICE_ID_ENE_CB712_SD	0x0550
 #define PCI_DEVICE_ID_ENE_CB712_SD_2	0x0551
 #define PCI_DEVICE_ID_ENE_CB714_SD	0x0750
diff -urN linux-2.6.29.2/include/linux/sgbuf2.h cb710-tree/include/linux/sgbuf2.h
--- linux-2.6.29.2/include/linux/sgbuf2.h	1970-01-01 01:00:00.000000000 +0100
+++ cb710-tree/include/linux/sgbuf2.h	2009-05-04 20:29:59.000000000 +0200
@@ -0,0 +1,104 @@
+/*
+ *  cb710/sgbuf2.h
+ *
+ *  Copyright by Micha³ Miros³aw, 2008-2009
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef LINUX_CB710_SG_H
+#define LINUX_CB710_SG_H
+
+#include <linux/highmem.h>
+#include <linux/scatterlist.h>
+
+/**
+ * sg_miter_stop_writing - stop mapping iteration after writing
+ * @miter: sg mapping iter to be stopped
+ *
+ * Description:
+ *   Stops mapping iterator @miter.  @miter should have been started
+ *   started using sg_miter_start().  A stopped iteration can be
+ *   resumed by calling sg_miter_next() on it.  This is useful when
+ *   resources (kmap) need to be released during iteration.
+ *
+ *   This is a convenience wrapper that will be optimized out for arches
+ *   that don't need flush_kernel_dcache_page().
+ *
+ * Context:
+ *   IRQ disabled if the SG_MITER_ATOMIC is set.  Don't care otherwise.
+ */
+static inline void sg_miter_stop_writing(struct sg_mapping_iter *miter)
+{
+	if (miter->page)
+		flush_kernel_dcache_page(miter->page);
+	sg_miter_stop(miter);
+}
+
+/*
+ * 32-bit PIO mapping sg iterator
+ *
+ * Hides scatterlist access issues - fragment boundaries, alignment, page
+ * mapping - for drivers using 32-bit-word-at-a-time-PIO (ie. PCI devices
+ * without DMA support).
+ *
+ * Best-case reading (transfer from device):
+ *   sg_miter_start();
+ *   sg_dwiter_write_from_io();
+ *   sg_miter_stop_writing();
+ *
+ * Best-case writing (transfer to device):
+ *   sg_miter_start();
+ *   sg_dwiter_read_to_io();
+ *   sg_miter_stop();
+ */
+
+uint32_t sg_dwiter_read_next_block(struct sg_mapping_iter *miter);
+void sg_dwiter_write_next_block(struct sg_mapping_iter *miter, uint32_t data);
+
+/**
+ * sg_dwiter_write_from_io - transfer data to mapped buffer from 32-bit IO port
+ * @miter: sg mapping iter
+ * @port: PIO port - IO or MMIO address
+ * @count: number of 32-bit words to transfer
+ *
+ * Description:
+ *   Reads @count 32-bit words from register @port and stores it in
+ *   buffer iterated by @miter.  Data that would overflow the buffer
+ *   is silently ignored.  Iterator is advanced by 4*@count bytes
+ *   or to the buffer's end whichever is closer.
+ *
+ * Context:
+ *   IRQ disabled if the SG_MITER_ATOMIC is set.  Don't care otherwise.
+ */
+static inline void sg_dwiter_write_from_io(struct sg_mapping_iter *miter,
+	void __iomem *port, size_t count)
+{
+	while (count-- > 0)
+		sg_dwiter_write_next_block(miter, ioread32(port));
+}
+
+/**
+ * sg_dwiter_read_to_io - transfer data to 32-bit IO port from mapped buffer
+ * @miter: sg mapping iter
+ * @port: PIO port - IO or MMIO address
+ * @count: number of 32-bit words to transfer
+ *
+ * Description:
+ *   Writes @count 32-bit words to register @port from buffer iterated
+ *   through @miter.  If buffer ends before @count words are written
+ *   missing data is replaced by zeroes. @miter is advanced by 4*@count
+ *   bytes or to the buffer's end whichever is closer.
+ *
+ * Context:
+ *   IRQ disabled if the SG_MITER_ATOMIC is set.  Don't care otherwise.
+ */
+static inline void sg_dwiter_read_to_io(struct sg_mapping_iter *miter,
+	void __iomem *port, size_t count)
+{
+	while (count-- > 0)
+		iowrite32(sg_dwiter_read_next_block(miter), port);
+}
+
+#endif /* LINUX_CB710_SG_H */
