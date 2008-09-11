Return-Path: <linux-kernel-owner+w=401wt.eu-S1755726AbYIKUNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbYIKUNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 16:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYIKUNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 16:13:13 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:50575 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbYIKUNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:13:11 -0400
Date: Thu, 11 Sep 2008 22:13:07 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, Alex Dubov <oakad@yahoo.com>
Subject: Driver for CB710/720 memory card reader (MMC part)
Message-ID: <20080911201307.GA31730@rere.qmqm.pl>
References: <20080907215228.GA19193@rere.qmqm.pl> <20080909091800.37eccc0f@mjolnir.drzeus.cx> <20080909090613.GA22158@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080909090613.GA22158@rere.qmqm.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here's a rough version of a driver for CB710/720 memory card reader.
It was tested with Canon SDC-16M card and actually works... until
first command error as there's no good error recovery. Driver spits
out a lot of debugging output as it goes and currently when it starts
failing commands it's necessary to reload the module to get it
working again.

For the MMC part, TODO list includes at least:
 - split the driver to a bus-like common device driver and reader
   specific parts like tifm driver has
 - maybe get rid of sgbuf.c if there already is some similar API
   or more assumptions on scatterlist elements can be made

If you're brave enough to test this please do so, but I wouldn't
bet my important data on it. ;)

Best Regards,
Micha³ Miros³aw

This, obviously, is not ready to include anywhere.

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

diff -urN empty/cb710.h cb710-pre-20080911/cb710.h
--- empty/cb710.h	1970-01-01 01:00:00.000000000 +0100
+++ cb710-pre-20080911/cb710.h	2008-09-11 21:06:36.000000000 +0200
@@ -0,0 +1,158 @@
+/*
+ *  cb710/cb710.h
+ *
+ *  Copyleft by Micha³ Miros³aw, 2008
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
+
+#define CB710_DRIVER_NAME "cb710"
+
+/* per-device structure */
+struct cb710_chip {
+	struct pci_dev *pdev;
+	void __iomem *iobase;
+
+	spinlock_t irq_lock;
+	unsigned irq_enabled;
+
+	struct mmc_host *mmc;
+};
+
+#define RDPORT(t, p) \
+	ioread##t(chip->iobase + (p))
+#define WRPORT(t, p, v) \
+	do { iowrite##t((v), chip->iobase + (p)); \
+		(void)ioread8(chip->iobase + 0x13); } while (0)
+#define UPDPORT(t, p, v, m) \
+	do { \
+		iowrite##t( \
+			(ioread##t(chip->iobase + (p)) & ~(m)) | (v), \
+			chip->iobase + (p)); \
+		(void)ioread8(chip->iobase + 0x13); \
+	} while (0)
+#define S_RDPORT(t, p, b, c) \
+	ioread##t##_rep(chip->iobase + (p), (b), (c))
+#define S_WRPORT(t, p, b, c) \
+	do { \
+		iowrite##t##_rep(chip->iobase + (p), (b), (c)); \
+		(void)ioread8(chip->iobase + 0x13); \
+	} while (0)
+
+
+void __cb710_pci_update_config_reg(struct pci_dev *pdev,
+	int reg, uint32_t mask, uint32_t xor);
+#define cb710_pci_update_config_reg(d, r, m, x) \
+	__cb710_pci_update_config_reg((d), (r), ~(m), (x))
+
+/* sg-to-PIO buffer */
+#define CB710_SG_BUFFER_BLOCK	16	/* power of two */
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
+/* per-MMC-reader structure */
+struct cb710_mmc_reader {
+	struct tasklet_struct finish_req_tasklet;
+	struct mmc_request *mrq;
+	unsigned char last_power_mode;
+	unsigned char app_cmd;
+	spinlock_t serialization_lock;
+	unsigned char active_req, active_ios;
+};
+
+int __devinit cb710_mmc_init(struct cb710_chip *chip);
+void __devexit cb710_mmc_exit(struct cb710_chip *chip);
+int cb710_mmc_irq_handler(struct cb710_chip *chip);
+
+/* registers */
+
+#define CB710_MMC_DATA_PORT		0x00
+#define CB710_MMC_CONFIG_PORT		0x04
+#define CB710_MMC_CONFIG0_PORT		0x04
+#define CB710_MMC_CONFIG1_PORT		0x05
+#define   CB710_MMC_C1_4BIT_DATA_BUS		0x40
+#define CB710_MMC_CONFIG2_PORT	0x06
+#define   CB710_MMC_C2_READ_BLOCK_SIZE_MASK	0x0F	/* N-1 */
+#define CB710_MMC_CONFIG3_PORT	0x07
+#define CB710_MMC_INTERRUPT_ENABLE_PORT	0x0D
+#define   CB710_MMC_IE_IRQ_ENABLE		0x80
+#define   CB710_MMC_IE_CARD_INSERTION_STATUS	0x10
+#define CB710_MMC_STATUS_PORT		0x10
+#define CB710_MMC_STATUS0_PORT		0x10
+#define CB710_MMC_STATUS1_PORT		0x11
+#define   CB710_MMC_S1_CARD_CHANGED		0x10
+#define   CB710_MMC_S1_RESET			0x20	/* XXX really? */
+#define CB710_MMC_STATUS2_PORT		0x12
+#define CB710_MMC_STATUS3_PORT		0x13
+#define   CB710_MMC_S3_CARD_DETECTED		0x02
+#define   CB710_MMC_S3_WRITE_PROTECTED		0x04
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
+#define CB710_MMC_CMD_PARAM_PORT	0x18
+#define CB710_MMC_TRANSFER_SIZE_PORT	0x1C
+#define CB710_MMC_RESPONSE0_PORT	0x20
+#define CB710_MMC_RESPONSE1_PORT	0x24
+#define CB710_MMC_RESPONSE2_PORT	0x28
+#define CB710_MMC_RESPONSE3_PORT	0x2C
+
+void cb710_dump_regs(struct cb710_chip *chip, unsigned dump);
+#define CB710_DUMP_REGS_MMC	0x0F
+#define CB710_DUMP_REGS_MS	0x30
+#define CB710_DUMP_REGS_SM	0xC0
+#define CB710_DUMP_REGS_ALL	0xFF
+
+#endif /* LINUX_CB710_DRIVER_H */
diff -urN empty/main.c cb710-pre-20080911/main.c
--- empty/main.c	1970-01-01 01:00:00.000000000 +0100
+++ cb710-pre-20080911/main.c	2008-09-11 20:31:10.000000000 +0200
@@ -0,0 +1,238 @@
+/*
+ *  cb710/main.c
+ *
+ *  Copyleft by Micha³ Miros³aw, 2008
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
+void __cb710_pci_update_config_reg(struct pci_dev *pdev,
+	int reg, uint32_t mask, uint32_t xor)
+{
+	u32 rval;
+
+	pci_read_config_dword(pdev, reg, &rval);
+	rval = (rval & mask) ^ xor;
+	pci_write_config_dword(pdev, reg, rval);
+}
+
+void cb710_dump_regs(struct cb710_chip *chip, unsigned select)
+{
+	const unsigned allow[8] = {
+		0xFFF0, 0xFFFF, 0xFFFF, 0xFFFF,
+		0xFFF0, 0xFFFF, 0xFFFF, 0xFFFF,
+	};
+	const char *const prefix[sizeof(allow)/sizeof(*allow)] = {
+		"MMC", "MMC", "MMC", "MMC",
+		"MS?", "MS?", "SM?", "SM?"
+	};
+	u32 regs[sizeof(allow)/sizeof(*allow) << 2];
+
+	int i, j;
+	char msg[100], *p;
+
+	if (!select)
+		select = 0xFF;
+	if (!(select & 0x700))
+		select |= 0x100;
+
+#define reg(b, i) \
+	(((u##b*)regs)[(i) / (b/8)])
+#define allowed(b, i, j) \
+	(((allow[i >> 4] >> j) & ((1 << b/8)-1)) == ((1 << b/8)-1))
+#define dumpregs(b, f, x) { \
+	for (i = 0; i < (sizeof(allow)/sizeof(*allow) << 4); i += 0x10) { \
+		if (!(select & (1 << (i >> 4)))) \
+			continue; \
+		for (j = 0; j < 0x10; j += b/8) { \
+			if (allowed(b, i, j)) \
+				reg(b, i + j) = RDPORT(b, i + j); \
+		}; \
+	} \
+	for (i = 0; i < (sizeof(allow)/sizeof(*allow) << 4); i += 0x10) { \
+		if (!(select & (1 << (i >> 4)))) \
+			continue; \
+		p = msg; \
+		for (j = 0; j < 0x10; j += b/8) { \
+			if (allowed(b, i, j)) \
+				p += sprintf(p, " %s" f, (j == 8 ? " " : ""), \
+					reg(b, i + j)); \
+			else \
+				p += sprintf(p, " %s" x, (j == 8 ? " " : "")); \
+			udelay(1); \
+		} \
+		\
+		printk(KERN_INFO CB710_DRIVER_NAME ": %s 0x%02X %s\n", \
+			prefix[i >> 4], i, msg); \
+	} \
+	}
+
+	if (select & 0x400)
+		dumpregs(32, "%08X", "xxxxxxxx");
+	if (select & 0x200)
+		dumpregs(16, "%04X", "xxxx");
+	if (select & 0x100)
+		dumpregs( 8, "%02X", "xx");
+
+#undef dumpregs
+#undef allowed
+#undef reg
+}
+
+/* Some magic writes based on Windows driver init code */
+static int __devinit cb710_pci_configure(struct pci_dev *pdev)
+{
+	unsigned int devfn = PCI_DEVFN(PCI_SLOT(pdev->devfn), 0);
+	struct pci_dev *pdev0 = pci_get_slot(pdev->bus, devfn);
+	u32 val;
+
+	cb710_pci_update_config_reg(pdev, 0x48, 0xC0, 0x3F);
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
+		cb710_pci_update_config_reg(pdev0, 0x8C, 0xE00000, 0x100000);
+		cb710_pci_update_config_reg(pdev0, 0xB0, 0, 0x08000000);
+	}
+
+	cb710_pci_update_config_reg(pdev0, 0x8C, 0x0D00, 0x0200);
+	cb710_pci_update_config_reg(pdev0, 0x90, 0x020000, 0x040000);
+
+	pci_dev_put(pdev0);
+
+	return 0;
+}
+
+static irqreturn_t cb710_irq_handler(int irq, void *data)
+{
+	struct cb710_chip *chip = data;
+	unsigned flags;
+	int handled = 0;
+
+	spin_lock_irqsave(&chip->irq_lock, flags);
+
+	if (chip->irq_enabled & 0x01)
+		handled = cb710_mmc_irq_handler(chip) || handled;
+
+	spin_unlock_irqrestore(&chip->irq_lock, flags);
+
+	return handled ? IRQ_HANDLED : IRQ_NONE;
+}
+
+static int __devinit cb710_init_one(struct pci_dev *pdev,
+	const struct pci_device_id *ent)
+{
+	struct cb710_chip *chip;
+	u32 val;
+	int ok = 0;
+	int err;
+
+	chip = devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
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
+	spin_lock_init(&chip->irq_lock);
+	chip->pdev = pdev;
+	chip->iobase = pcim_iomap_table(pdev)[0];
+
+	pci_set_drvdata(pdev, chip);
+
+	pci_read_config_dword(pdev, 0x48, &val);
+	if (!(val & 0x80000000)) {
+		pci_write_config_dword(pdev, 0x48, val|0x71000000);
+		pci_read_config_dword(pdev, 0x48, &val);
+	}
+
+	err = cb710_pci_configure(pdev);
+	if (err)
+		return err;
+
+	err = devm_request_irq(&pdev->dev, pdev->irq,
+		cb710_irq_handler, IRQF_SHARED, "cb710", chip);
+	if (err)
+		return err;
+
+	dev_printk(KERN_INFO CB710_DRIVER_NAME ": ", &pdev->dev,
+		"IO 0x%p, IRQ %d\n", chip->iobase, pdev->irq);
+
+	printk(KERN_INFO CB710_DRIVER_NAME
+		": PCI config[0x48] = 0x%08X (%d %d %d %d %d %d)\n",
+		val,
+		!(val & 0x01000000),
+		(val >> 8) & 7,
+		!!(val & 0x10000000),
+		!!(val & 0x20000000),
+		!!(val & 0x40000000),
+		!(val & 0x02000000)
+	);
+
+	if (val & 0x10000000) {
+		err = cb710_mmc_init(chip);
+		if (!err)
+			++ok;
+	}
+
+	if (!ok && !err)
+		return -ENODEV;
+	/* XXX: will disappear after conversion to bus-type driver */
+	return ok ? 0 : err;
+}
+
+static void __devexit cb710_remove_one(struct pci_dev *pdev)
+{
+	struct cb710_chip *chip = pci_get_drvdata(pdev);
+
+	if (chip->mmc)
+		cb710_mmc_exit(chip);
+}
+
+static const struct pci_device_id cb710_pci_tbl[] = {
+	{ PCI_VENDOR_ID_ENE, 0x510, PCI_ANY_ID, PCI_ANY_ID, },
+	{ 0, }
+};
+
+static struct pci_driver cb710_driver = {
+	.name = "cb710",
+	.id_table = cb710_pci_tbl,
+	.probe = cb710_init_one,
+	.remove = __devexit_p(cb710_remove_one),
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
diff -urN empty/Makefile cb710-pre-20080911/Makefile
--- empty/Makefile	1970-01-01 01:00:00.000000000 +0100
+++ cb710-pre-20080911/Makefile	2008-09-11 20:03:07.000000000 +0200
@@ -0,0 +1,22 @@
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
+
+else	# kbuild part
+
+obj-m       := cb710.o
+cb710-y     := main.o mmc.o sgbuf.o
+
+endif
diff -urN empty/mmc.c cb710-pre-20080911/mmc.c
--- empty/mmc.c	1970-01-01 01:00:00.000000000 +0100
+++ cb710-pre-20080911/mmc.c	2008-09-11 21:08:02.000000000 +0200
@@ -0,0 +1,724 @@
+/*
+ *  cb710/mmc.c
+ *
+ *  Copyleft by Micha³ Miros³aw, 2008
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
+#include <linux/mmc/mmc.h>
+#include "cb710.h"
+
+static const u8 cb710_clock_divider_log2[8] = {
+/*	1, 2, 4, 8, 16, 32, 128, 512 */
+	0, 1, 2, 3,  4,  5,   7,   9
+};
+#define CB710_MMC_MAX_DIVIDER_LOG2 9
+
+static const u8 cb710_src_freq_mhz[16] = {
+	33, 10, 20, 25, 30, 35, 40, 45,
+	50, 55, 60, 65, 70, 75, 80, 85
+};
+
+static void verify_serialization(struct cb710_mmc_reader *reader, unsigned char *counter, int inc)
+{
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
+	printk(KERN_INFO CB710_DRIVER_NAME ": %s driver;"
+		"counters now: ios=%d req=%d\n",
+		inc ? "entering" : "leaving", ios, req);
+	WARN_ON(cur > 1);
+}
+
+static void cb710_mmc_set_clock(struct cb710_chip *chip, int hz)
+{
+	struct pci_dev *pdev = chip->pdev;
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
+	for (divider_idx = 0; divider_idx < 8; ++divider_idx) {
+		if (hz >= src_hz >> cb710_clock_divider_log2[divider_idx])
+			break;
+	}
+	if (divider_idx == 8)
+		--divider_idx;
+
+	if (src_freq_idx)
+		divider_idx |= 0x8;
+
+	cb710_pci_update_config_reg(pdev, 0x40, 0xF0000000, divider_idx << 28);
+
+	printk(KERN_INFO CB710_DRIVER_NAME
+		": %s: clock set to %d Hz, wanted %d Hz; flag = %d\n",
+		mmc_hostname(chip->mmc),
+		src_hz >> cb710_clock_divider_log2[divider_idx & 7],
+		hz, (divider_idx & 8) != 0);
+}
+
+static void __cb710_mmc_enable_irq(struct cb710_chip *chip, int enable)
+{
+	if (enable) {
+		chip->irq_enabled |= 0x01;
+		/* look like interrupt is fired whenever
+		 * WORD[0x0C] & WORD[0x10] != 0;
+		 * let's verify it...
+		 *** bit 7 port 0x0D seems to be global interrupt enable
+		 */
+		WRPORT(8, 0x0C, ~0x40);
+		WRPORT(8, 0x0D, 0x90);
+	} else {
+		chip->irq_enabled &= ~0x01;
+		WRPORT(8, 0x0C, 0);
+		WRPORT(8, 0x0D, 0);
+	}
+}
+
+static void cb710_mmc_enable_irq(struct cb710_chip *chip, int enable)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&chip->irq_lock, flags);
+	__cb710_mmc_enable_irq(chip, enable);
+	spin_unlock_irqrestore(&chip->irq_lock, flags);
+}
+
+static int cb710_mmc_is_card_inserted(struct cb710_chip *chip)
+{
+	return RDPORT(8, CB710_MMC_STATUS3_PORT)
+		& CB710_MMC_S3_CARD_DETECTED;
+}
+
+static void cb710_mmc_enable_4bit_data(struct cb710_chip *chip, int enable)
+{
+	printk(KERN_INFO CB710_DRIVER_NAME
+		": configuring %d-data-line%s mode\n",
+		enable ? 4 : 1, enable ? "s" : "");
+	UPDPORT(8, CB710_MMC_CONFIG1_PORT,
+		enable ? CB710_MMC_C1_4BIT_DATA_BUS : 0,
+		CB710_MMC_C1_4BIT_DATA_BUS);
+}
+
+static int cb710_check(struct cb710_chip *chip, int what)
+{
+	uint8_t status1, status2;
+
+	/* all this is magic */
+	BUG_ON(what < 2 || what > 4);
+
+	status1 = RDPORT(8, CB710_MMC_STATUS0_PORT);
+	status2 = RDPORT(8, CB710_MMC_STATUS1_PORT);
+
+	if (status1 & 0x40) {
+		printk(KERN_INFO CB710_DRIVER_NAME
+			": CHECK : ignoring bit S0=%02X & 0x40\n",
+			status1);
+		WRPORT(8, CB710_MMC_STATUS0_PORT, 0x40);
+		status1 &= ~0x40;
+	}
+
+	if (status1 || (status2 & 0x60)) {
+		printk(KERN_INFO CB710_DRIVER_NAME
+			": CHECK : returning EIO on status S0=%02X S1=%02X\n",
+			status1, status2);
+		WRPORT(8, CB710_MMC_STATUS0_PORT, status1);
+		WRPORT(8, CB710_MMC_STATUS1_PORT, 0x20);
+		return -EIO;
+	}
+
+	switch (what) {
+	case 2:		/* block transfer done */
+		if (!(status2 & 0x04))
+			break;
+		WRPORT(8, CB710_MMC_STATUS1_PORT, 0x04);
+		return 1;
+	case 3:		/* command sent */
+		if (!(status2 & 0x01))
+			break;
+		WRPORT(8, CB710_MMC_STATUS1_PORT, 0x01);
+		return 1;
+	case 4:		/* data transfer done */
+		if (!(status2 & 0x02))
+			break;
+		WRPORT(8, CB710_MMC_STATUS1_PORT, 0x02);
+		return 1;
+	}
+	return 0;
+}
+
+static int cb710_wait(struct cb710_chip *chip, int what)
+{
+	int err = 0;
+	unsigned limit = 2000000;	/* FIXME: real timeout */
+	u32 e = 0, x = 0;
+
+	e = RDPORT(32, CB710_MMC_STATUS_PORT);
+	while (!(err = cb710_check(chip, what))) {
+		if (!--limit) {
+			err = -ETIMEDOUT;
+			break;
+		}
+		udelay(1);
+	}
+	x = RDPORT(32, CB710_MMC_STATUS_PORT);
+#if 0
+	printk(KERN_INFO CB710_DRIVER_NAME ": waited %d loops, "
+		"WAIT10: what %d, entry val %08X, exit val %08X\n",
+		2000000 - limit, what, e, x);
+#endif
+	return err < 0 ? err : 0;
+}
+
+
+static int cb710_wait12(struct cb710_chip *chip, uint8_t mask)
+{
+	unsigned limit = 500000;	/* FIXME: real timeout */
+	u32 e, x;
+	int err = 0;
+
+	e = RDPORT(32, CB710_MMC_STATUS_PORT);
+	while (RDPORT(8, CB710_MMC_STATUS2_PORT) & mask) {
+		if (!--limit) {
+			err = -ETIMEDOUT;
+			break;
+		}
+		udelay(1);
+	}
+	x = RDPORT(32, CB710_MMC_STATUS_PORT);
+#if 0
+	printk(KERN_INFO CB710_DRIVER_NAME ": waited %d loops, "
+		"WAIT12: mask %02X, entry val %08X, exit val %08X\n",
+		500000 - limit, mask, e, x);
+#endif
+	return 0;
+}
+
+static void cb710_mmc_set_transfer_size(struct cb710_chip *chip,
+	size_t count, size_t blocksize)
+{
+	cb710_wait12(chip, 0x20);
+	WRPORT(32, CB710_MMC_TRANSFER_SIZE_PORT,
+		((count - 1) << 16)|(blocksize - 1));
+
+	printk(KERN_INFO CB710_DRIVER_NAME
+		": set up for %d block%s of %d bytes\n",
+		count, count == 1 ? "" : "s", blocksize);
+}
+
+static void cb710_mmc_fifo_hack(struct cb710_chip *chip)
+{
+	/* without this, received data is prepended with 8-bytes of zeroes */
+	u32 r1, r2;
+	int ok = 0;
+
+	r1 = RDPORT(32, CB710_MMC_DATA_PORT);
+	r2 = RDPORT(32, CB710_MMC_DATA_PORT);
+	if (RDPORT(8, CB710_MMC_STATUS0_PORT) & 0x40) {
+		WRPORT(8, CB710_MMC_STATUS0_PORT, 0x40);
+		ok = 1;
+	}
+
+	printk(KERN_INFO CB710_DRIVER_NAME ": FIFO-read-hack: "
+		"expected STATUS0 bit was %s dwords ignored: %08X %08X\n",
+		ok ? "set." : "NOT SET!", r1, r2);
+}
+
+static int cb710_mmc_receive(struct cb710_chip *chip, struct mmc_data *data)
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
+	UPDPORT(8, CB710_MMC_CONFIG2_PORT,
+		15, CB710_MMC_C2_READ_BLOCK_SIZE_MASK);
+
+	cb710_mmc_fifo_hack(chip);
+
+	while (len >= 16) {
+		if (!(RDPORT(8, CB710_MMC_STATUS2_PORT) & 0x01)) {
+			int err = cb710_wait(chip, 2);
+			if (err) {
+				cb710_sg_abort_write(&sgc);
+				return err;
+			}
+		}
+		S_RDPORT(32, CB710_MMC_DATA_PORT, databuf, 4);
+
+		len -= 16;
+		databuf += 4;
+
+		if (!len && !cb710_sg_write_next(&sgc,
+				(void **)&databuf, &len))
+			return 0;
+	}
+
+	UPDPORT(8, CB710_MMC_CONFIG2_PORT,
+		len - 1, CB710_MMC_C2_READ_BLOCK_SIZE_MASK);
+
+	if (RDPORT(8, CB710_MMC_STATUS2_PORT) & 0x01) {
+		int err = cb710_wait(chip, 2);
+		if (err) {
+			cb710_sg_abort_write(&sgc);
+			return err;
+		}
+	}
+
+	len = (len + 3) >> 2;
+	S_RDPORT(32, CB710_MMC_DATA_PORT, databuf, len);
+
+	if (cb710_sg_write_next(&sgc, (void **)&databuf, &len))
+		BUG();
+
+	return 0;
+}
+
+static int cb710_mmc_send(struct cb710_chip *chip, struct mmc_data *data)
+{
+	struct cb710_sg_chain sgc;
+	const uint32_t *databuf;
+	size_t datalen;
+
+	cb710_sg_init(&sgc, data->sg, data->sg_len);
+
+	UPDPORT(8, CB710_MMC_CONFIG2_PORT,
+		0, CB710_MMC_C2_READ_BLOCK_SIZE_MASK);
+
+	while (cb710_sg_read_next(&sgc, (void **)&databuf, &datalen)) {
+		datalen = (datalen + 15) >> 4;
+		do {
+			if (!(RDPORT(8, CB710_MMC_STATUS2_PORT) & 0x02)) {
+				int err = cb710_wait(chip, 2);
+				if (err) {
+					cb710_sg_abort_read(&sgc);
+					return err;
+				}
+			}
+			S_WRPORT(32, CB710_MMC_DATA_PORT, databuf, 4);
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
+	 * was expected. It happened that there were only two such commands
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
+/*	if (flags & MMC_CMD_IS_APP) */
+	if (reader->app_cmd) {
+		/* original driver set this bit for MMC/SD application
+		 * commands. It apparently works without it, but... oh well.
+		 */
+		cb_flags |= 0x4000;
+		reader->app_cmd = 0;
+	}
+
+	if (cmd->data && (cmd->data->flags & MMC_DATA_READ))
+		cb_flags |= CB710_MMC_DATA_READ;
+
+	if (flags & MMC_RSP_PRESENT) {
+		/* Windows driver set 01 at bits 4,3 except for
+		 * MMC_SET_BLOCKLEN. I assume that 00 here means no
+		 * response is expected.
+		 */
+		if (cmd->opcode != MMC_SET_BLOCKLEN)
+			cb_flags |= CB710_MMC_RSP_PRESENT;
+		else
+			cb_flags |= CB710_MMC_RSP_PRESENT_X;
+
+		if (flags & MMC_RSP_136)		/* R2 */
+			cb_flags |= CB710_MMC_RSP_136;
+		else if (!(flags & MMC_RSP_CRC))	/* R3 */
+			cb_flags |= CB710_MMC_RSP_NO_CRC;
+	}
+
+	return cb_flags;
+}
+
+static void cb710_mmc_reset_events(struct cb710_chip *chip)
+{
+	WRPORT(8, CB710_MMC_STATUS0_PORT, 0xFF);
+	WRPORT(8, CB710_MMC_STATUS1_PORT, 0xFF);
+	WRPORT(8, CB710_MMC_STATUS2_PORT, 0xFF);
+}
+
+static void cb710_receive_response(struct cb710_chip *chip,
+	struct mmc_command *cmd)
+{
+	unsigned rsp_opcode;
+
+	/* Looks like final byte with CRC is always stripped (like SDHCI) */
+	if (cmd->flags & MMC_RSP_136) {
+		u32 resp[4];
+
+		resp[0] = RDPORT(32, CB710_MMC_RESPONSE3_PORT);
+		resp[1] = RDPORT(32, CB710_MMC_RESPONSE2_PORT);
+		resp[2] = RDPORT(32, CB710_MMC_RESPONSE1_PORT);
+		resp[3] = RDPORT(32, CB710_MMC_RESPONSE0_PORT);
+		rsp_opcode = resp[0] >> 24;
+
+		cmd->resp[0] = (resp[0] << 8)|(resp[1] >> 24);
+		cmd->resp[1] = (resp[1] << 8)|(resp[2] >> 24);
+		cmd->resp[2] = (resp[2] << 8)|(resp[3] >> 24);
+		cmd->resp[3] = (resp[3] << 8);
+	} else {
+		rsp_opcode = RDPORT(32, CB710_MMC_RESPONSE1_PORT) & 0x3F;
+		cmd->resp[0] = RDPORT(32, CB710_MMC_RESPONSE0_PORT);
+	}
+
+	if (rsp_opcode != ((cmd->flags & MMC_RSP_OPCODE) ? cmd->opcode : 0x3F))
+		cmd->error = -EILSEQ;
+}
+
+static int cb710_mmc_transfer_data(struct cb710_chip *chip,
+	struct mmc_data *data)
+{
+	int error, to;
+
+	if (data->flags & MMC_DATA_READ)
+		error = cb710_mmc_receive(chip, data);
+	else
+		error = cb710_mmc_send(chip, data);
+
+	to = cb710_wait(chip, 4);
+	if (!error)
+		error = to;
+
+	if (!error)	/* TODO: proper counting */
+		data->bytes_xfered = data->blksz * data->blocks;
+	return error;
+}
+
+static int cb710_mmc_command(struct cb710_chip *chip, struct mmc_command *cmd)
+{
+	struct mmc_data *data = cmd->data;
+	struct cb710_mmc_reader *reader = mmc_priv(chip->mmc);
+
+	u16 cb_cmd = cb710_encode_cmd_flags(reader, cmd);
+	printk(KERN_INFO CB710_DRIVER_NAME ": %s: cmd request: 0x%04X\n",
+		mmc_hostname(chip->mmc), cb_cmd);
+
+	if (data)
+		cb710_mmc_set_transfer_size(chip, data->blocks, data->blksz);
+
+	cb710_wait12(chip, 0x30);
+	WRPORT(16, CB710_MMC_CMD_TYPE_PORT, cb_cmd);
+	cb710_wait12(chip, 0x20);
+	WRPORT(32, CB710_MMC_CMD_PARAM_PORT, cmd->arg);
+	cb710_mmc_reset_events(chip);
+	cb710_wait12(chip, 0x20);
+	UPDPORT(8, 0x04, 0x01, 0x01);
+
+	cmd->error = cb710_wait(chip, 3);
+	if (cmd->error)
+		return -1;
+
+	if (cmd->flags & MMC_RSP_PRESENT) {
+		cb710_receive_response(chip, cmd);
+		if (cmd->error)
+			return -1;
+	}
+
+	reader->app_cmd = (!reader->app_cmd && cmd->opcode == 55);
+
+	if (data)
+		data->error = cb710_mmc_transfer_data(chip, data);
+	return 0;
+}
+
+static void cb710_mmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
+{
+	struct cb710_chip *chip = dev_get_drvdata(mmc_dev(mmc));
+	struct cb710_mmc_reader *reader = mmc_priv(mmc);
+
+	verify_serialization(reader, &reader->active_req, 1);
+
+	WARN_ON(reader->mrq != NULL);
+
+	reader->mrq = mrq;
+	cb710_mmc_enable_irq(chip, 1);
+
+	if (cb710_mmc_is_card_inserted(chip)) {
+		if (!cb710_mmc_command(chip, mrq->cmd) && mrq->stop)
+			cb710_mmc_command(chip, mrq->stop);
+		mdelay(1);
+	} else {
+		mrq->cmd->error = -ENOMEDIUM;
+	}
+
+	tasklet_schedule(&reader->finish_req_tasklet);
+
+	verify_serialization(reader, &reader->active_req, 0);
+}
+
+static void cb710_mmc_powerup(struct cb710_chip *chip)
+{
+	/* a lot of magic; see comment in cb710_mmc_set_clock() */
+	struct cb710_mmc_reader *reader = mmc_priv(chip->mmc);
+
+	printk(KERN_INFO CB710_DRIVER_NAME ": powerup\n");
+	cb710_dump_regs(chip, 0x303);
+	cb710_wait12(chip, 0x20);
+	UPDPORT(8, 0x05, 0x80, 0);
+	UPDPORT(8, 0x07, 0x80, 0);
+	cb710_dump_regs(chip, 0x303);
+	mdelay(1);
+	printk(KERN_INFO CB710_DRIVER_NAME ": after delay 1\n");
+	cb710_dump_regs(chip, 0x303);
+	cb710_wait12(chip, 0x20);
+	UPDPORT(8, 0x05, 0x09, 0);
+	cb710_dump_regs(chip, 0x303);
+	mdelay(1);
+	printk(KERN_INFO CB710_DRIVER_NAME ": after delay 2\n");
+	cb710_dump_regs(chip, 0x303);
+	cb710_wait12(chip, 0x20);
+	UPDPORT(8, 0x05, 0, 0x08);
+	cb710_dump_regs(chip, 0x303);
+	mdelay(2);
+	printk(KERN_INFO CB710_DRIVER_NAME ": after delay 3\n");
+	cb710_dump_regs(chip, 0x303);
+	UPDPORT(8, 0x04, 0x06, 0);
+	UPDPORT(8, 0x05, 0x70, 0);
+	UPDPORT(8, 0x06, 0x80, 0);
+	UPDPORT(8, 0x07, 0x03, 0);
+	cb710_dump_regs(chip, 0x303);
+	cb710_wait12(chip, 0x20);
+	WRPORT(16, 0x08, 0xFFFF);
+	WRPORT(8, 0x09, 0xFF);
+	UPDPORT(8, 0x04, 0x06, 0);
+	cb710_dump_regs(chip, 0x303);
+	printk(KERN_INFO CB710_DRIVER_NAME ": finished\n");
+
+	reader->app_cmd = 0;
+}
+
+static void cb710_mmc_powerdown(struct cb710_chip *chip)
+{
+	struct cb710_mmc_reader *reader = mmc_priv(chip->mmc);
+
+	UPDPORT(8, 0x05, 0, 0x81);
+	UPDPORT(8, 0x07, 0, 0x80);
+	reader->app_cmd = 0;
+}
+
+static void cb710_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+{
+	struct cb710_chip *chip = dev_get_drvdata(mmc_dev(mmc));
+	struct cb710_mmc_reader *reader = mmc_priv(mmc);
+
+	verify_serialization(reader, &reader->active_ios, 1);
+
+	cb710_mmc_set_clock(chip, ios->clock);
+
+	if (!cb710_mmc_is_card_inserted(chip)) {
+		printk(KERN_INFO CB710_DRIVER_NAME
+			": no card inserted - ignoring bus powerup request\n");
+		ios->power_mode = MMC_POWER_OFF;
+	}
+
+	if (ios->power_mode != reader->last_power_mode)
+	switch (ios->power_mode) {
+	case MMC_POWER_ON:
+		cb710_mmc_powerup(chip);
+		reader->last_power_mode = MMC_POWER_ON;
+		break;
+	case MMC_POWER_OFF:
+		cb710_mmc_powerdown(chip);
+		reader->last_power_mode = MMC_POWER_OFF;
+		break;
+	case MMC_POWER_UP:
+	default:
+		/* ignore */;
+	}
+
+	cb710_mmc_enable_4bit_data(chip, ios->bus_width != MMC_BUS_WIDTH_1);
+
+	cb710_mmc_enable_irq(chip, 1);
+
+	verify_serialization(reader, &reader->active_ios, 0);
+}
+
+static int cb710_mmc_get_ro(struct mmc_host *mmc)
+{
+	struct cb710_chip *chip = dev_get_drvdata(mmc_dev(mmc));
+
+	return RDPORT(8, CB710_MMC_STATUS3_PORT)
+		& CB710_MMC_S3_WRITE_PROTECTED;
+}
+
+int cb710_mmc_irq_handler(struct cb710_chip *chip)
+{
+	u32 status, config1, config2, irqen;
+#if 0
+	if (!(RDPORT(8, CB710_MMC_STATUS1_PORT) & CB710_MMC_S1_INTERRUPT))
+		return 0;
+#endif
+	status = RDPORT(32, 0x10);
+	irqen = RDPORT(32, 0x0C);
+	config2 = RDPORT(32, 0x08);
+	config1 = RDPORT(32, 0x04);
+	printk(KERN_INFO CB710_DRIVER_NAME ": interrupt; status: %08X, "
+		"ie: %08X, c2: %08X, c3: %08X\n",
+		status, irqen, config2, config1);
+
+	if (status & (CB710_MMC_S1_CARD_CHANGED << 8)) {
+		WRPORT(8, CB710_MMC_STATUS1_PORT, CB710_MMC_S1_CARD_CHANGED);
+		mmc_detect_change(chip->mmc, HZ/2);
+	} else {
+		printk(KERN_INFO CB710_DRIVER_NAME ": unknown interrupt\n");
+		WRPORT(8, 0x0C, 0x00);
+		WRPORT(8, 0x0D, 0x90);
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
+	.get_ro = cb710_mmc_get_ro,
+	.enable_sdio_irq = NULL,
+};
+
+int __devinit cb710_mmc_init(struct cb710_chip *chip)
+{
+	struct mmc_host *mmc;
+	struct cb710_mmc_reader *reader;
+	int err;
+	u32 val;
+
+	mmc = mmc_alloc_host(sizeof(*reader), &chip->pdev->dev);
+	if (!mmc)
+		return -ENOMEM;
+
+	chip->mmc = mmc;
+
+	/* harmless (maybe) magic */
+	pci_read_config_dword(chip->pdev, 0x48, &val);
+	val = cb710_src_freq_mhz[(val >> 16) & 0xF];
+	printk(KERN_INFO CB710_DRIVER_NAME ": %s: source frequency: %dMHz\n",
+		mmc_hostname(mmc), val
+	);
+	val *= 1000000;
+
+	mmc->ops = &cb710_mmc_host;
+	mmc->f_max = val;
+	mmc->f_min = val >> CB710_MMC_MAX_DIVIDER_LOG2;
+	mmc->ocr_avail = MMC_VDD_32_33|MMC_VDD_33_34|MMC_VDD_34_35;
+	mmc->caps = MMC_CAP_4_BIT_DATA;
+
+	reader = mmc_priv(mmc);
+
+	tasklet_init(&reader->finish_req_tasklet,
+		cb710_mmc_finish_request_tasklet, (unsigned long)mmc);
+	spin_lock_init(&reader->serialization_lock);
+
+	cb710_dump_regs(chip, CB710_DUMP_REGS_MMC);
+#if 0
+	WRPORT(32, 0, 0);
+	WRPORT(8, CB710_MMC_CONFIG0_PORT, 0);
+	WRPORT(8, CB710_MMC_CONFIG1_PORT, 0);
+	WRPORT(8, CB710_MMC_CONFIG2_PORT, 0);
+	WRPORT(8, CB710_MMC_CONFIG3_PORT, 0);
+	WRPORT(16, 8, 0);
+	WRPORT(16, CB710_MMC_CMD_TYPE_PORT, 0);
+	WRPORT(8, CB710_MMC_STATUS0_PORT, ~0);
+	WRPORT(8, CB710_MMC_STATUS1_PORT, ~0);
+	WRPORT(8, CB710_MMC_STATUS2_PORT, ~0);
+	WRPORT(8, CB710_MMC_STATUS3_PORT, ~0);
+	msleep(3);
+	cb710_dump_regs(chip, CB710_DUMP_REGS_MMC);
+#endif
+
+	err = mmc_add_host(mmc);
+	if (!err)
+		return 0;
+
+	printk(KERN_INFO CB710_DRIVER_NAME ": %s: add_host failed: %d\n",
+		mmc_hostname(mmc), err);
+
+	chip->mmc = NULL;
+	mmc_free_host(mmc);
+
+	return err;
+}
+
+void __devexit cb710_mmc_exit(struct cb710_chip *chip)
+{
+	struct mmc_host *mmc = chip->mmc;
+	struct cb710_mmc_reader *reader = mmc_priv(mmc);
+
+	mmc_remove_host(mmc);
+
+	cb710_mmc_enable_irq(chip, 0);
+
+	/* clear config ports - just in case */
+	WRPORT(32, 0x04, 0);
+	WRPORT(16, 0x08, 0);
+
+	tasklet_kill(&reader->finish_req_tasklet);
+
+	chip->mmc = NULL;
+	mmc_free_host(mmc);
+}
+
diff -urN empty/sgbuf.c cb710-pre-20080911/sgbuf.c
--- empty/sgbuf.c	1970-01-01 01:00:00.000000000 +0100
+++ cb710-pre-20080911/sgbuf.c	2008-09-11 21:05:39.000000000 +0200
@@ -0,0 +1,196 @@
+/*
+ *  cb710/sgbuf.c
+ *
+ *  Copyleft by Micha³ Miros³aw, 2008
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/scatterlist.h>
+#include <linux/highmem.h>
+#include "cb710.h"
+
+#define CB710_SG_BUFFER_MASK  (~(CB710_SG_BUFFER_BLOCK - 1))
+
+static void cb710_sg_init_element(struct cb710_sg_chain *buf)
+{
+	buf->cur_offset = 0;
+	buf->page_offset = buf->sg->offset & ~PAGE_MASK;
+	buf->page_no = buf->sg->offset >> PAGE_SHIFT;
+	buf->page = nth_page(sg_page(buf->sg), buf->page_no);
+
+	printk(KERN_INFO "sg: moved to new scatterlist entry: "
+		"first page +%d, poffs=%d, len=%d\n",
+		buf->page_no, buf->page_offset, buf->sg->length);
+}
+
+static void cb710_sg_unmap_page(struct cb710_sg_chain *buf, int to_sg)
+{
+	printk(KERN_INFO "sg: unmapping %s page\n",
+		to_sg ? "written" : "read");
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
+	printk(KERN_INFO "sg: advanced %d bytes; "
+		"cur_offset=%d, page_offset=%d, rlen=%d\n",
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
+		printk(KERN_INFO "sg: mapped new page: +%d @0x%p\n",
+			buf->page_no, buf->mapped_page);
+	}
+
+	return 1;
+}
+
+void cb710_sg_init(struct cb710_sg_chain *buf,
+	struct scatterlist *sg, size_t nelem)
+{
+	printk(KERN_INFO "sg: init: %d elements\n", nelem);
+	BUG_ON(!nelem);
+
+	memset(buf, 0, sizeof(*buf));
+	buf->sg = sg;
+	buf->sg_num = nelem;
+	cb710_sg_init_element(buf);
+	cb710_sg_advance(buf, 0, 0);
+}
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
+	printk(KERN_INFO "sg: %d bytes %s sg via bounce_buffer\n",
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
+	printk(KERN_INFO "sg: next buffer to %s\n", to_sg ? "write" : "read");
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
+		printk(KERN_INFO "sg: %d bytes mapped directly\n", *len);
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
+		printk(KERN_INFO "sg: "
+			"using bounce_buffer for writing %d bytes\n", *len);
+		buf->use_bounce = 1;
+	} else
+		*len = cb710_sg_use_bounce(buf, 0);
+
+	return *len != 0;
+}
+
+void cb710_sg_abort(struct cb710_sg_chain *buf, int to_sg)
+{
+	printk(KERN_INFO "sg: aborting\n");
+
+	if (buf->mapped_page)
+		cb710_sg_unmap_page(buf, to_sg);
+}
