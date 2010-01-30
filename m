Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692Ab0A3Tu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab0A3Tu4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 14:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620Ab0A3TuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 14:50:23 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:50554 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab0A3TuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 14:50:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Daq6rsfohz6SqZiT5kB+81/7FDqtcb6PnzYpx1dUGUqfjqdEAyzRB4PUL7+B6szj+r
         VEKncka8CjEgvIqFaYAiO0OVlu5csut13EqjYs5ch3lTTDcjN9K2QzCRVlXaI5jThcAJ
         KSdSccjqxs5/krU/cm3fPS6/FvSGFsmmY4QaU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 30 Jan 2010 20:50:11 +0100
Message-Id: <20100130195011.30779.2992.sendpatchset@localhost>
In-Reply-To: <20100130194918.30779.25485.sendpatchset@localhost>
References: <20100130194918.30779.25485.sendpatchset@localhost>
Subject: [PATCH 8/9] pata_sil680: move code to be re-used by ide2libata to pata_sil680.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_sil680: move code to be re-used by ide2libata to pata_sil680.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_sil680.c |  236 ----------------------------------------------
 drivers/ata/pata_sil680.h |  235 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 236 insertions(+), 235 deletions(-)

Index: b/drivers/ata/pata_sil680.c
===================================================================
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -36,160 +36,7 @@
 
 #define SIL680_MMIO_BAR		5
 
-/**
- *	sil680_selreg		-	return register base
- *	@hwif: interface
- *	@r: config offset
- *
- *	Turn a config register offset into the right address in either
- *	PCI space or MMIO space to access the control register in question
- *	Thankfully this is a configuration operation so isnt performance
- *	criticial.
- */
-
-static unsigned long sil680_selreg(struct ata_port *ap, int r)
-{
-	unsigned long base = 0xA0 + r;
-	base += (ap->port_no << 4);
-	return base;
-}
-
-/**
- *	sil680_seldev		-	return register base
- *	@hwif: interface
- *	@r: config offset
- *
- *	Turn a config register offset into the right address in either
- *	PCI space or MMIO space to access the control register in question
- *	including accounting for the unit shift.
- */
-
-static unsigned long sil680_seldev(struct ata_port *ap, struct ata_device *adev, int r)
-{
-	unsigned long base = 0xA0 + r;
-	base += (ap->port_no << 4);
-	base |= adev->devno ? 2 : 0;
-	return base;
-}
-
-
-/**
- *	sil680_cable_detect	-	cable detection
- *	@ap: ATA port
- *
- *	Perform cable detection. The SIL680 stores this in PCI config
- *	space for us.
- */
-
-static int sil680_cable_detect(struct ata_port *ap)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	unsigned long addr = sil680_selreg(ap, 0);
-	u8 ata66;
-	pci_read_config_byte(pdev, addr, &ata66);
-	if (ata66 & 1)
-		return ATA_CBL_PATA80;
-	else
-		return ATA_CBL_PATA40;
-}
-
-/**
- *	sil680_set_piomode	-	set initial PIO mode data
- *	@ap: ATA interface
- *	@adev: ATA device
- *
- *	Program the SIL680 registers for PIO mode. Note that the task speed
- *	registers are shared between the devices so we must pick the lowest
- *	mode for command work.
- */
-
-static void sil680_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	static u16 speed_p[5] = { 0x328A, 0x2283, 0x1104, 0x10C3, 0x10C1 };
-	static u16 speed_t[5] = { 0x328A, 0x2283, 0x1281, 0x10C3, 0x10C1 };
-
-	unsigned long tfaddr = sil680_selreg(ap, 0x02);
-	unsigned long addr = sil680_seldev(ap, adev, 0x04);
-	unsigned long addr_mask = 0x80 + 4 * ap->port_no;
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	int pio = adev->pio_mode - XFER_PIO_0;
-	int lowest_pio = pio;
-	int port_shift = 4 * adev->devno;
-	u16 reg;
-	u8 mode;
-
-	struct ata_device *pair = ata_dev_pair(adev);
-
-	if (pair != NULL && adev->pio_mode > pair->pio_mode)
-		lowest_pio = pair->pio_mode - XFER_PIO_0;
-
-	pci_write_config_word(pdev, addr, speed_p[pio]);
-	pci_write_config_word(pdev, tfaddr, speed_t[lowest_pio]);
-
-	pci_read_config_word(pdev, tfaddr-2, &reg);
-	pci_read_config_byte(pdev, addr_mask, &mode);
-
-	reg &= ~0x0200;			/* Clear IORDY */
-	mode &= ~(3 << port_shift);	/* Clear IORDY and DMA bits */
-
-	if (ata_pio_need_iordy(adev)) {
-		reg |= 0x0200;		/* Enable IORDY */
-		mode |= 1 << port_shift;
-	}
-	pci_write_config_word(pdev, tfaddr-2, reg);
-	pci_write_config_byte(pdev, addr_mask, mode);
-}
-
-/**
- *	sil680_set_dmamode	-	set initial DMA mode data
- *	@ap: ATA interface
- *	@adev: ATA device
- *
- *	Program the MWDMA/UDMA modes for the sil680 k
- *	chipset. The MWDMA mode values are pulled from a lookup table
- *	while the chipset uses mode number for UDMA.
- */
-
-static void sil680_set_dmamode(struct ata_port *ap, struct ata_device *adev)
-{
-	static u8 ultra_table[2][7] = {
-		{ 0x0C, 0x07, 0x05, 0x04, 0x02, 0x01, 0xFF },	/* 100MHz */
-		{ 0x0F, 0x0B, 0x07, 0x05, 0x03, 0x02, 0x01 },	/* 133Mhz */
-	};
-	static u16 dma_table[3] = { 0x2208, 0x10C2, 0x10C1 };
-
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	unsigned long ma = sil680_seldev(ap, adev, 0x08);
-	unsigned long ua = sil680_seldev(ap, adev, 0x0C);
-	unsigned long addr_mask = 0x80 + 4 * ap->port_no;
-	int port_shift = adev->devno * 4;
-	u8 scsc, mode;
-	u16 multi, ultra;
-
-	pci_read_config_byte(pdev, 0x8A, &scsc);
-	pci_read_config_byte(pdev, addr_mask, &mode);
-	pci_read_config_word(pdev, ma, &multi);
-	pci_read_config_word(pdev, ua, &ultra);
-
-	/* Mask timing bits */
-	ultra &= ~0x3F;
-	mode &= ~(0x03 << port_shift);
-
-	/* Extract scsc */
-	scsc = (scsc & 0x30) ? 1 : 0;
-
-	if (adev->dma_mode >= XFER_UDMA_0) {
-		multi = 0x10C1;
-		ultra |= ultra_table[scsc][adev->dma_mode - XFER_UDMA_0];
-		mode |= (0x03 << port_shift);
-	} else {
-		multi = dma_table[adev->dma_mode - XFER_MW_DMA_0];
-		mode |= (0x02 << port_shift);
-	}
-	pci_write_config_byte(pdev, addr_mask, mode);
-	pci_write_config_word(pdev, ma, multi);
-	pci_write_config_word(pdev, ua, ultra);
-}
+#include "pata_sil680.h"
 
 static struct scsi_host_template sil680_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
@@ -202,87 +49,6 @@ static struct ata_port_operations sil680
 	.set_dmamode	= sil680_set_dmamode,
 };
 
-/**
- *	sil680_init_chip		-	chip setup
- *	@pdev: PCI device
- *
- *	Perform all the chip setup which must be done both when the device
- *	is powered up on boot and when we resume in case we resumed from RAM.
- *	Returns the final clock settings.
- */
-
-static u8 sil680_init_chip(struct pci_dev *pdev, int *try_mmio)
-{
-	u8 tmpbyte	= 0;
-
-	/* FIXME: double check */
-	pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE,
-			      pdev->revision ? 1 : 255);
-
-	pci_write_config_byte(pdev, 0x80, 0x00);
-	pci_write_config_byte(pdev, 0x84, 0x00);
-
-	pci_read_config_byte(pdev, 0x8A, &tmpbyte);
-
-	dev_dbg(&pdev->dev, "sil680: BA5_EN = %d clock = %02X\n",
-		tmpbyte & 1, tmpbyte & 0x30);
-
-	*try_mmio = 0;
-#ifdef CONFIG_PPC
-	if (machine_is(cell))
-		*try_mmio = (tmpbyte & 1) || pci_resource_start(pdev, 5);
-#endif
-
-	switch (tmpbyte & 0x30) {
-	case 0x00:
-		/* 133 clock attempt to force it on */
-		pci_write_config_byte(pdev, 0x8A, tmpbyte|0x10);
-		break;
-	case 0x30:
-		/* if clocking is disabled */
-		/* 133 clock attempt to force it on */
-		pci_write_config_byte(pdev, 0x8A, tmpbyte & ~0x20);
-		break;
-	case 0x10:
-		/* 133 already */
-		break;
-	case 0x20:
-		/* BIOS set PCI x2 clocking */
-		break;
-	}
-
-	pci_read_config_byte(pdev,   0x8A, &tmpbyte);
-	dev_dbg(&pdev->dev, "sil680: BA5_EN = %d clock = %02X\n",
-		tmpbyte & 1, tmpbyte & 0x30);
-
-	pci_write_config_byte(pdev,  0xA1, 0x72);
-	pci_write_config_word(pdev,  0xA2, 0x328A);
-	pci_write_config_dword(pdev, 0xA4, 0x62DD62DD);
-	pci_write_config_dword(pdev, 0xA8, 0x43924392);
-	pci_write_config_dword(pdev, 0xAC, 0x40094009);
-	pci_write_config_byte(pdev,  0xB1, 0x72);
-	pci_write_config_word(pdev,  0xB2, 0x328A);
-	pci_write_config_dword(pdev, 0xB4, 0x62DD62DD);
-	pci_write_config_dword(pdev, 0xB8, 0x43924392);
-	pci_write_config_dword(pdev, 0xBC, 0x40094009);
-
-	switch (tmpbyte & 0x30) {
-	case 0x00:
-		printk(KERN_INFO "sil680: 100MHz clock.\n");
-		break;
-	case 0x10:
-		printk(KERN_INFO "sil680: 133MHz clock.\n");
-		break;
-	case 0x20:
-		printk(KERN_INFO "sil680: Using PCI clock.\n");
-		break;
-	/* This last case is _NOT_ ok */
-	case 0x30:
-		printk(KERN_ERR "sil680: Clock disabled ?\n");
-	}
-	return tmpbyte & 0x30;
-}
-
 static int __devinit sil680_init_one(struct pci_dev *pdev,
 				     const struct pci_device_id *id)
 {
Index: b/drivers/ata/pata_sil680.h
===================================================================
--- /dev/null
+++ b/drivers/ata/pata_sil680.h
@@ -0,0 +1,235 @@
+/**
+ *	sil680_selreg		-	return register base
+ *	@hwif: interface
+ *	@r: config offset
+ *
+ *	Turn a config register offset into the right address in either
+ *	PCI space or MMIO space to access the control register in question
+ *	Thankfully this is a configuration operation so isnt performance
+ *	criticial.
+ */
+
+static unsigned long sil680_selreg(struct ata_port *ap, int r)
+{
+	unsigned long base = 0xA0 + r;
+	base += (ap->port_no << 4);
+	return base;
+}
+
+/**
+ *	sil680_seldev		-	return register base
+ *	@hwif: interface
+ *	@r: config offset
+ *
+ *	Turn a config register offset into the right address in either
+ *	PCI space or MMIO space to access the control register in question
+ *	including accounting for the unit shift.
+ */
+
+static unsigned long sil680_seldev(struct ata_port *ap, struct ata_device *adev, int r)
+{
+	unsigned long base = 0xA0 + r;
+	base += (ap->port_no << 4);
+	base |= adev->devno ? 2 : 0;
+	return base;
+}
+
+
+/**
+ *	sil680_cable_detect	-	cable detection
+ *	@ap: ATA port
+ *
+ *	Perform cable detection. The SIL680 stores this in PCI config
+ *	space for us.
+ */
+
+static int sil680_cable_detect(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	unsigned long addr = sil680_selreg(ap, 0);
+	u8 ata66;
+	pci_read_config_byte(pdev, addr, &ata66);
+	if (ata66 & 1)
+		return ATA_CBL_PATA80;
+	else
+		return ATA_CBL_PATA40;
+}
+
+/**
+ *	sil680_set_piomode	-	set initial PIO mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Program the SIL680 registers for PIO mode. Note that the task speed
+ *	registers are shared between the devices so we must pick the lowest
+ *	mode for command work.
+ */
+
+static void sil680_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	static u16 speed_p[5] = { 0x328A, 0x2283, 0x1104, 0x10C3, 0x10C1 };
+	static u16 speed_t[5] = { 0x328A, 0x2283, 0x1281, 0x10C3, 0x10C1 };
+
+	unsigned long tfaddr = sil680_selreg(ap, 0x02);
+	unsigned long addr = sil680_seldev(ap, adev, 0x04);
+	unsigned long addr_mask = 0x80 + 4 * ap->port_no;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	int pio = adev->pio_mode - XFER_PIO_0;
+	int lowest_pio = pio;
+	int port_shift = 4 * adev->devno;
+	u16 reg;
+	u8 mode;
+
+	struct ata_device *pair = ata_dev_pair(adev);
+
+	if (pair != NULL && adev->pio_mode > pair->pio_mode)
+		lowest_pio = pair->pio_mode - XFER_PIO_0;
+
+	pci_write_config_word(pdev, addr, speed_p[pio]);
+	pci_write_config_word(pdev, tfaddr, speed_t[lowest_pio]);
+
+	pci_read_config_word(pdev, tfaddr-2, &reg);
+	pci_read_config_byte(pdev, addr_mask, &mode);
+
+	reg &= ~0x0200;			/* Clear IORDY */
+	mode &= ~(3 << port_shift);	/* Clear IORDY and DMA bits */
+
+	if (ata_pio_need_iordy(adev)) {
+		reg |= 0x0200;		/* Enable IORDY */
+		mode |= 1 << port_shift;
+	}
+	pci_write_config_word(pdev, tfaddr-2, reg);
+	pci_write_config_byte(pdev, addr_mask, mode);
+}
+
+/**
+ *	sil680_set_dmamode	-	set initial DMA mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Program the MWDMA/UDMA modes for the sil680 k
+ *	chipset. The MWDMA mode values are pulled from a lookup table
+ *	while the chipset uses mode number for UDMA.
+ */
+
+static void sil680_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	static u8 ultra_table[2][7] = {
+		{ 0x0C, 0x07, 0x05, 0x04, 0x02, 0x01, 0xFF },	/* 100MHz */
+		{ 0x0F, 0x0B, 0x07, 0x05, 0x03, 0x02, 0x01 },	/* 133Mhz */
+	};
+	static u16 dma_table[3] = { 0x2208, 0x10C2, 0x10C1 };
+
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	unsigned long ma = sil680_seldev(ap, adev, 0x08);
+	unsigned long ua = sil680_seldev(ap, adev, 0x0C);
+	unsigned long addr_mask = 0x80 + 4 * ap->port_no;
+	int port_shift = adev->devno * 4;
+	u8 scsc, mode;
+	u16 multi, ultra;
+
+	pci_read_config_byte(pdev, 0x8A, &scsc);
+	pci_read_config_byte(pdev, addr_mask, &mode);
+	pci_read_config_word(pdev, ma, &multi);
+	pci_read_config_word(pdev, ua, &ultra);
+
+	/* Mask timing bits */
+	ultra &= ~0x3F;
+	mode &= ~(0x03 << port_shift);
+
+	/* Extract scsc */
+	scsc = (scsc & 0x30) ? 1 : 0;
+
+	if (adev->dma_mode >= XFER_UDMA_0) {
+		multi = 0x10C1;
+		ultra |= ultra_table[scsc][adev->dma_mode - XFER_UDMA_0];
+		mode |= (0x03 << port_shift);
+	} else {
+		multi = dma_table[adev->dma_mode - XFER_MW_DMA_0];
+		mode |= (0x02 << port_shift);
+	}
+	pci_write_config_byte(pdev, addr_mask, mode);
+	pci_write_config_word(pdev, ma, multi);
+	pci_write_config_word(pdev, ua, ultra);
+}
+
+/**
+ *	sil680_init_chip		-	chip setup
+ *	@pdev: PCI device
+ *
+ *	Perform all the chip setup which must be done both when the device
+ *	is powered up on boot and when we resume in case we resumed from RAM.
+ *	Returns the final clock settings.
+ */
+
+static u8 sil680_init_chip(struct pci_dev *pdev, int *try_mmio)
+{
+	u8 tmpbyte	= 0;
+
+	/* FIXME: double check */
+	pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE,
+			      pdev->revision ? 1 : 255);
+
+	pci_write_config_byte(pdev, 0x80, 0x00);
+	pci_write_config_byte(pdev, 0x84, 0x00);
+
+	pci_read_config_byte(pdev, 0x8A, &tmpbyte);
+
+	dev_dbg(&pdev->dev, "sil680: BA5_EN = %d clock = %02X\n",
+		tmpbyte & 1, tmpbyte & 0x30);
+
+	*try_mmio = 0;
+#ifdef CONFIG_PPC
+	if (machine_is(cell))
+		*try_mmio = (tmpbyte & 1) || pci_resource_start(pdev, 5);
+#endif
+
+	switch (tmpbyte & 0x30) {
+	case 0x00:
+		/* 133 clock attempt to force it on */
+		pci_write_config_byte(pdev, 0x8A, tmpbyte|0x10);
+		break;
+	case 0x30:
+		/* if clocking is disabled */
+		/* 133 clock attempt to force it on */
+		pci_write_config_byte(pdev, 0x8A, tmpbyte & ~0x20);
+		break;
+	case 0x10:
+		/* 133 already */
+		break;
+	case 0x20:
+		/* BIOS set PCI x2 clocking */
+		break;
+	}
+
+	pci_read_config_byte(pdev,   0x8A, &tmpbyte);
+	dev_dbg(&pdev->dev, "sil680: BA5_EN = %d clock = %02X\n",
+		tmpbyte & 1, tmpbyte & 0x30);
+
+	pci_write_config_byte(pdev,  0xA1, 0x72);
+	pci_write_config_word(pdev,  0xA2, 0x328A);
+	pci_write_config_dword(pdev, 0xA4, 0x62DD62DD);
+	pci_write_config_dword(pdev, 0xA8, 0x43924392);
+	pci_write_config_dword(pdev, 0xAC, 0x40094009);
+	pci_write_config_byte(pdev,  0xB1, 0x72);
+	pci_write_config_word(pdev,  0xB2, 0x328A);
+	pci_write_config_dword(pdev, 0xB4, 0x62DD62DD);
+	pci_write_config_dword(pdev, 0xB8, 0x43924392);
+	pci_write_config_dword(pdev, 0xBC, 0x40094009);
+
+	switch (tmpbyte & 0x30) {
+	case 0x00:
+		printk(KERN_INFO "sil680: 100MHz clock.\n");
+		break;
+	case 0x10:
+		printk(KERN_INFO "sil680: 133MHz clock.\n");
+		break;
+	case 0x20:
+		printk(KERN_INFO "sil680: Using PCI clock.\n");
+		break;
+	/* This last case is _NOT_ ok */
+	case 0x30:
+		printk(KERN_ERR "sil680: Clock disabled ?\n");
+	}
+	return tmpbyte & 0x30;
+}
