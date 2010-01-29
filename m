Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329Ab0A2QII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab0A2QII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242Ab0A2QIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:08:00 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab0A2QH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:07:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=XDEezuDvoYAz942GT0sjTZ7WVFZdEEVjV59RZztV6WD9U3q1EPXUKx2t481H/mQR3S
         LO9Uhf36/TyF2hH1HbGJ0Ap61dfI2N+UDbDXL5vn11v/miGtVUx094nsVkUMdxlFEoYb
         saKScQvTpcHr6RvlHtO0TFUayKcirBgiCcHeQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:07:50 +0100
Message-Id: <20100129160750.21495.96663.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 44/68] pata_cs5530: move code to be re-used by ide2libata to pata_cs5530.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cs5530: move code to be re-used by ide2libata to pata_cs5530.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cs5530.c |  178 --------------------------------------------
 drivers/ata/pata_cs5530.h |  183 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 184 insertions(+), 177 deletions(-)

Index: b/drivers/ata/pata_cs5530.c
===================================================================
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -43,93 +43,7 @@ static void __iomem *cs5530_port_base(st
 	return (void __iomem *)((bmdma & ~0x0F) + 0x20 + 0x10 * ap->port_no);
 }
 
-/**
- *	cs5530_set_piomode		-	PIO setup
- *	@ap: ATA interface
- *	@adev: device on the interface
- *
- *	Set our PIO requirements. This is fairly simple on the CS5530
- *	chips.
- */
-
-static void cs5530_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	static const unsigned int cs5530_pio_timings[2][5] = {
-		{0x00009172, 0x00012171, 0x00020080, 0x00032010, 0x00040010},
-		{0xd1329172, 0x71212171, 0x30200080, 0x20102010, 0x00100010}
-	};
-	void __iomem *base = cs5530_port_base(ap);
-	u32 tuning;
-	int format;
-
-	/* Find out which table to use */
-	tuning = ioread32(base + 0x04);
-	format = (tuning & 0x80000000UL) ? 1 : 0;
-
-	/* Now load the right timing register */
-	if (adev->devno)
-		base += 0x08;
-
-	iowrite32(cs5530_pio_timings[format][adev->pio_mode - XFER_PIO_0], base);
-}
-
-/**
- *	cs5530_set_dmamode		-	DMA timing setup
- *	@ap: ATA interface
- *	@adev: Device being configured
- *
- *	We cannot mix MWDMA and UDMA without reloading timings each switch
- *	master to slave. We track the last DMA setup in order to minimise
- *	reloads.
- */
-
-static void cs5530_set_dmamode(struct ata_port *ap, struct ata_device *adev)
-{
-	void __iomem *base = cs5530_port_base(ap);
-	u32 tuning, timing = 0;
-	u8 reg;
-
-	/* Find out which table to use */
-	tuning = ioread32(base + 0x04);
-
-	switch(adev->dma_mode) {
-		case XFER_UDMA_0:
-			timing  = 0x00921250;break;
-		case XFER_UDMA_1:
-			timing  = 0x00911140;break;
-		case XFER_UDMA_2:
-			timing  = 0x00911030;break;
-		case XFER_MW_DMA_0:
-			timing  = 0x00077771;break;
-		case XFER_MW_DMA_1:
-			timing  = 0x00012121;break;
-		case XFER_MW_DMA_2:
-			timing  = 0x00002020;break;
-		default:
-			BUG();
-	}
-	/* Merge in the PIO format bit */
-	timing |= (tuning & 0x80000000UL);
-	if (adev->devno == 0) /* Master */
-		iowrite32(timing, base + 0x04);
-	else {
-		if (timing & 0x00100000)
-			tuning |= 0x00100000;	/* UDMA for both */
-		else
-			tuning &= ~0x00100000;	/* MWDMA for both */
-		iowrite32(tuning, base + 0x04);
-		iowrite32(timing, base + 0x0C);
-	}
-
-	/* Set the DMA capable bit in the BMDMA area */
-	reg = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
-	reg |= (1 << (5 + adev->devno));
-	iowrite8(reg, ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
-
-	/* Remember the last DMA setup we did */
-
-	ap->private_data = adev;
-}
+#include "pata_cs5530.h"
 
 /**
  *	cs5530_qc_issue		-	command issue
@@ -195,96 +109,6 @@ static int cs5530_is_palmax(void)
 	return 0;
 }
 
-
-/**
- *	cs5530_init_chip	-	Chipset init
- *	@gendev: device
- *
- *	Perform the chip initialisation work that is shared between both
- *	setup and resume paths
- */
-
-static int cs5530_init_chip(struct device *gendev)
-{
-	struct pci_dev *master_0 = NULL, *cs5530_0 = NULL, *dev = NULL;
-
-	while ((dev = pci_get_device(PCI_VENDOR_ID_CYRIX, PCI_ANY_ID, dev)) != NULL) {
-		switch (dev->device) {
-			case PCI_DEVICE_ID_CYRIX_PCI_MASTER:
-				master_0 = pci_dev_get(dev);
-				break;
-			case PCI_DEVICE_ID_CYRIX_5530_LEGACY:
-				cs5530_0 = pci_dev_get(dev);
-				break;
-		}
-	}
-	if (!master_0) {
-		printk(KERN_ERR DRV_NAME ": unable to locate PCI MASTER function\n");
-		goto fail_put;
-	}
-	if (!cs5530_0) {
-		printk(KERN_ERR DRV_NAME ": unable to locate CS5530 LEGACY function\n");
-		goto fail_put;
-	}
-
-	pci_set_master(cs5530_0);
-	pci_try_set_mwi(cs5530_0);
-
-	/*
-	 * Set PCI CacheLineSize to 16-bytes:
-	 * --> Write 0x04 into 8-bit PCI CACHELINESIZE reg of function 0 of the cs5530
-	 *
-	 * Note: This value is constant because the 5530 is only a Geode companion
-	 */
-
-	pci_write_config_byte(cs5530_0, PCI_CACHE_LINE_SIZE, 0x04);
-
-	/*
-	 * Disable trapping of UDMA register accesses (Win98 hack):
-	 * --> Write 0x5006 into 16-bit reg at offset 0xd0 of function 0 of the cs5530
-	 */
-
-	pci_write_config_word(cs5530_0, 0xd0, 0x5006);
-
-	/*
-	 * Bit-1 at 0x40 enables MemoryWriteAndInvalidate on internal X-bus:
-	 * The other settings are what is necessary to get the register
-	 * into a sane state for IDE DMA operation.
-	 */
-
-	pci_write_config_byte(master_0, 0x40, 0x1e);
-
-	/*
-	 * Set max PCI burst size (16-bytes seems to work best):
-	 *	   16bytes: set bit-1 at 0x41 (reg value of 0x16)
-	 *	all others: clear bit-1 at 0x41, and do:
-	 *	  128bytes: OR 0x00 at 0x41
-	 *	  256bytes: OR 0x04 at 0x41
-	 *	  512bytes: OR 0x08 at 0x41
-	 *	 1024bytes: OR 0x0c at 0x41
-	 */
-
-	pci_write_config_byte(master_0, 0x41, 0x14);
-
-	/*
-	 * These settings are necessary to get the chip
-	 * into a sane state for IDE DMA operation.
-	 */
-
-	pci_write_config_byte(master_0, 0x42, 0x00);
-	pci_write_config_byte(master_0, 0x43, 0xc1);
-
-	pci_dev_put(master_0);
-	pci_dev_put(cs5530_0);
-	return 0;
-fail_put:
-	if (master_0)
-		pci_dev_put(master_0);
-	if (cs5530_0)
-		pci_dev_put(cs5530_0);
-	return -EIO;
-}
-
 /**
  *	cs5530_init_one		-	Initialise a CS5530
  *	@dev: PCI device
Index: b/drivers/ata/pata_cs5530.h
===================================================================
--- /dev/null
+++ b/drivers/ata/pata_cs5530.h
@@ -0,0 +1,183 @@
+
+/**
+ *	cs5530_set_piomode		-	PIO setup
+ *	@ap: ATA interface
+ *	@adev: device on the interface
+ *
+ *	Set our PIO requirements. This is fairly simple on the CS5530
+ *	chips.
+ */
+
+static void cs5530_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	static const unsigned int cs5530_pio_timings[2][5] = {
+		{0x00009172, 0x00012171, 0x00020080, 0x00032010, 0x00040010},
+		{0xd1329172, 0x71212171, 0x30200080, 0x20102010, 0x00100010}
+	};
+	void __iomem *base = cs5530_port_base(ap);
+	u32 tuning;
+	int format;
+
+	/* Find out which table to use */
+	tuning = ioread32(base + 0x04);
+	format = (tuning & 0x80000000UL) ? 1 : 0;
+
+	/* Now load the right timing register */
+	if (adev->devno)
+		base += 0x08;
+
+	iowrite32(cs5530_pio_timings[format][adev->pio_mode - XFER_PIO_0],
+		  base);
+}
+
+/**
+ *	cs5530_set_dmamode		-	DMA timing setup
+ *	@ap: ATA interface
+ *	@adev: Device being configured
+ *
+ *	We cannot mix MWDMA and UDMA without reloading timings each switch
+ *	master to slave. We track the last DMA setup in order to minimise
+ *	reloads.
+ */
+
+static void cs5530_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	void __iomem *base = cs5530_port_base(ap);
+	u32 tuning, timing = 0;
+	u8 reg;
+
+	/* Find out which table to use */
+	tuning = ioread32(base + 0x04);
+
+	switch (adev->dma_mode) {
+	case XFER_UDMA_0:
+		timing  = 0x00921250; break;
+	case XFER_UDMA_1:
+		timing  = 0x00911140; break;
+	case XFER_UDMA_2:
+		timing  = 0x00911030; break;
+	case XFER_MW_DMA_0:
+		timing  = 0x00077771; break;
+	case XFER_MW_DMA_1:
+		timing  = 0x00012121; break;
+	case XFER_MW_DMA_2:
+		timing  = 0x00002020; break;
+	default:
+		BUG();
+	}
+	/* Merge in the PIO format bit */
+	timing |= (tuning & 0x80000000UL);
+	if (adev->devno == 0) /* Master */
+		iowrite32(timing, base + 0x04);
+	else {
+		if (timing & 0x00100000)
+			tuning |= 0x00100000;	/* UDMA for both */
+		else
+			tuning &= ~0x00100000;	/* MWDMA for both */
+		iowrite32(tuning, base + 0x04);
+		iowrite32(timing, base + 0x0C);
+	}
+
+	/* Set the DMA capable bit in the BMDMA area */
+	reg = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
+	reg |= (1 << (5 + adev->devno));
+	iowrite8(reg, ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
+
+	/* Remember the last DMA setup we did */
+
+	ap->private_data = adev;
+}
+
+
+/**
+ *	cs5530_init_chip	-	Chipset init
+ *	@gendev: device
+ *
+ *	Perform the chip initialisation work that is shared between both
+ *	setup and resume paths
+ */
+
+static int cs5530_init_chip(struct device *gendev)
+{
+	struct pci_dev *master_0 = NULL, *cs5530_0 = NULL, *dev = NULL;
+
+	while ((dev = pci_get_device(PCI_VENDOR_ID_CYRIX,
+					PCI_ANY_ID, dev)) != NULL) {
+		switch (dev->device) {
+		case PCI_DEVICE_ID_CYRIX_PCI_MASTER:
+			master_0 = pci_dev_get(dev);
+			break;
+		case PCI_DEVICE_ID_CYRIX_5530_LEGACY:
+			cs5530_0 = pci_dev_get(dev);
+			break;
+		}
+	}
+	if (!master_0) {
+		printk(KERN_ERR DRV_NAME
+			": unable to locate PCI MASTER function\n");
+		goto fail_put;
+	}
+	if (!cs5530_0) {
+		printk(KERN_ERR DRV_NAME
+			": unable to locate CS5530 LEGACY function\n");
+		goto fail_put;
+	}
+
+	pci_set_master(cs5530_0);
+	pci_try_set_mwi(cs5530_0);
+
+	/*
+	 * Set PCI CacheLineSize to 16-bytes:
+	 * --> Write 0x04 into 8-bit PCI CACHELINESIZE reg of function 0
+	 *
+	 * Note:
+	 * This value is constant because the 5530 is only a Geode companion
+	 */
+
+	pci_write_config_byte(cs5530_0, PCI_CACHE_LINE_SIZE, 0x04);
+
+	/*
+	 * Disable trapping of UDMA register accesses (Win98 hack):
+	 * --> Write 0x5006 into 16-bit reg at offset 0xd0 of function 0
+	 */
+
+	pci_write_config_word(cs5530_0, 0xd0, 0x5006);
+
+	/*
+	 * Bit-1 at 0x40 enables MemoryWriteAndInvalidate on internal X-bus:
+	 * The other settings are what is necessary to get the register
+	 * into a sane state for IDE DMA operation.
+	 */
+
+	pci_write_config_byte(master_0, 0x40, 0x1e);
+
+	/*
+	 * Set max PCI burst size (16-bytes seems to work best):
+	 *	   16bytes: set bit-1 at 0x41 (reg value of 0x16)
+	 *	all others: clear bit-1 at 0x41, and do:
+	 *	  128bytes: OR 0x00 at 0x41
+	 *	  256bytes: OR 0x04 at 0x41
+	 *	  512bytes: OR 0x08 at 0x41
+	 *	 1024bytes: OR 0x0c at 0x41
+	 */
+
+	pci_write_config_byte(master_0, 0x41, 0x14);
+
+	/*
+	 * These settings are necessary to get the chip
+	 * into a sane state for IDE DMA operation.
+	 */
+
+	pci_write_config_byte(master_0, 0x42, 0x00);
+	pci_write_config_byte(master_0, 0x43, 0xc1);
+
+	pci_dev_put(master_0);
+	pci_dev_put(cs5530_0);
+	return 0;
+fail_put:
+	if (master_0)
+		pci_dev_put(master_0);
+	if (cs5530_0)
+		pci_dev_put(cs5530_0);
+	return -EIO;
+}
