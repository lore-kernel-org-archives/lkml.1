Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716Ab0A2QGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab0A2QGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600Ab0A2QGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:06:31 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab0A2QG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:06:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=PrLA5PdnH+NkrPLEbAzFZD3Rf2ZV1PVZX5sijfW5Odun6RXEkccaKBA/DY5DrYJDCL
         by4q2nCq/y/BiIrh4mLvhsUcwGUQAqXu70SovN52t77y9B6aVHMDFB1a+X2WDUOqck/a
         F8pogIDuB+t3vFhHt+qqNfJ2uxDjkx56voNYg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:06:22 +0100
Message-Id: <20100129160622.21495.74801.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 30/68] piix: convert to ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] piix: convert to ide2libata

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/ata_piix.h |   15 ++--
 drivers/ide/piix.c     |  182 ++-----------------------------------------------
 2 files changed, 19 insertions(+), 178 deletions(-)

Index: b/drivers/ata/ata_piix.h
===================================================================
--- a/drivers/ata/ata_piix.h
+++ b/drivers/ata/ata_piix.h
@@ -44,7 +44,6 @@ static int ich_short_ata40(struct pci_de
 	return 0;
 }
 
-#ifdef __LINUX_LIBATA_H__
 static DEFINE_SPINLOCK(piix_lock);
 
 static void piix_set_timings(struct ata_port *ap, struct ata_device *adev,
@@ -213,9 +212,18 @@ static void do_pata_set_dmamode(struct a
 		pci_write_config_byte(dev, 0x48, udma_enable);
 
 		spin_unlock_irqrestore(&piix_lock, flags);
-	} else
-		/* MWDMA is driven by the PIO timings. */
+	} else {
+		/* Normal DMA is driven by the PIO timings. */
+#ifdef __IDE2LIBATA
+		if (speed >= XFER_MW_DMA_0)
+			adev->pio_mode = ata_mwdma_to_pio(speed) + XFER_PIO_0;
+		else
+			adev->pio_mode = XFER_PIO_2; /* for SWDMA2 */
+		piix_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0, 1);
+#else
 		piix_set_timings(ap, adev, ata_mwdma_to_pio(speed), 1);
+#endif
+	}
 }
 
 /**
@@ -268,4 +276,3 @@ static int __devinit piix_check_450nx_er
 			   "A BIOS update may resolve this.\n");
 	return no_piix_dma;
 }
-#endif
Index: b/drivers/ide/piix.c
===================================================================
--- a/drivers/ide/piix.c
+++ b/drivers/ide/piix.c
@@ -55,142 +55,7 @@
 
 #define DRV_NAME "piix"
 
-static int no_piix_dma;
-
-/**
- *	piix_set_pio_mode	-	set host controller for PIO mode
- *	@port: port
- *	@drive: drive
- *
- *	Set the interface PIO mode based upon the settings done by AMI BIOS.
- */
-
-static void piix_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	int is_slave		= drive->dn & 1;
-	int master_port		= hwif->channel ? 0x42 : 0x40;
-	int slave_port		= 0x44;
-	unsigned long flags;
-	u16 master_data;
-	u8 slave_data;
-	static DEFINE_SPINLOCK(tune_lock);
-	int control = 0;
-	const u8 pio = drive->pio_mode - XFER_PIO_0;
-
-				     /* ISP  RTC */
-	static const u8 timings[][2]= {
-					{ 0, 0 },
-					{ 0, 0 },
-					{ 1, 0 },
-					{ 2, 1 },
-					{ 2, 3 }, };
-
-	/*
-	 * Master vs slave is synchronized above us but the slave register is
-	 * shared by the two hwifs so the corner case of two slave timeouts in
-	 * parallel must be locked.
-	 */
-	spin_lock_irqsave(&tune_lock, flags);
-	pci_read_config_word(dev, master_port, &master_data);
-
-	if (pio > 1)
-		control |= 1;	/* Programmable timing on */
-	if (drive->media == ide_disk)
-		control |= 4;	/* Prefetch, post write */
-	if (ide_pio_need_iordy(drive, pio))
-		control |= 2;	/* IORDY */
-	if (is_slave) {
-		master_data |=  0x4000;
-		master_data &= ~0x0070;
-		/* Set PPE, IE and TIME */
-		master_data |= control << 4;
-		pci_read_config_byte(dev, slave_port, &slave_data);
-		slave_data &= hwif->channel ? 0x0f : 0xf0;
-		slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) <<
-			       (hwif->channel ? 4 : 0);
-	} else {
-		master_data &= ~0x3307;
-		/* enable PPE, IE and TIME */
-		master_data |= control;
-		master_data |= (timings[pio][0] << 12) | (timings[pio][1] << 8);
-	}
-	pci_write_config_word(dev, master_port, master_data);
-	if (is_slave)
-		pci_write_config_byte(dev, slave_port, slave_data);
-	spin_unlock_irqrestore(&tune_lock, flags);
-}
-
-/**
- *	piix_set_dma_mode	-	set host controller for DMA mode
- *	@hwif: port
- *	@drive: drive
- *
- *	Set a PIIX host controller to the desired DMA mode.  This involves
- *	programming the right timing data into the PCI configuration space.
- */
-
-static void piix_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	u8 maslave		= hwif->channel ? 0x42 : 0x40;
-	int a_speed		= 3 << (drive->dn * 4);
-	int u_flag		= 1 << drive->dn;
-	int v_flag		= 0x01 << drive->dn;
-	int w_flag		= 0x10 << drive->dn;
-	int u_speed		= 0;
-	int			sitre;
-	u16			reg4042, reg4a;
-	u8			reg48, reg54, reg55;
-	const u8 speed		= drive->dma_mode;
-
-	pci_read_config_word(dev, maslave, &reg4042);
-	sitre = (reg4042 & 0x4000) ? 1 : 0;
-	pci_read_config_byte(dev, 0x48, &reg48);
-	pci_read_config_word(dev, 0x4a, &reg4a);
-	pci_read_config_byte(dev, 0x54, &reg54);
-	pci_read_config_byte(dev, 0x55, &reg55);
-
-	if (speed >= XFER_UDMA_0) {
-		u8 udma = speed - XFER_UDMA_0;
-
-		u_speed = min_t(u8, 2 - (udma & 1), udma) << (drive->dn * 4);
-
-		if (!(reg48 & u_flag))
-			pci_write_config_byte(dev, 0x48, reg48 | u_flag);
-		if (speed == XFER_UDMA_5) {
-			pci_write_config_byte(dev, 0x55, (u8) reg55|w_flag);
-		} else {
-			pci_write_config_byte(dev, 0x55, (u8) reg55 & ~w_flag);
-		}
-		if ((reg4a & a_speed) != u_speed)
-			pci_write_config_word(dev, 0x4a, (reg4a & ~a_speed) | u_speed);
-		if (speed > XFER_UDMA_2) {
-			if (!(reg54 & v_flag))
-				pci_write_config_byte(dev, 0x54, reg54 | v_flag);
-		} else
-			pci_write_config_byte(dev, 0x54, reg54 & ~v_flag);
-	} else {
-		const u8 mwdma_to_pio[] = { 0, 3, 4 };
-
-		if (reg48 & u_flag)
-			pci_write_config_byte(dev, 0x48, reg48 & ~u_flag);
-		if (reg4a & a_speed)
-			pci_write_config_word(dev, 0x4a, reg4a & ~a_speed);
-		if (reg54 & v_flag)
-			pci_write_config_byte(dev, 0x54, reg54 & ~v_flag);
-		if (reg55 & w_flag)
-			pci_write_config_byte(dev, 0x55, (u8) reg55 & ~w_flag);
-
-		if (speed >= XFER_MW_DMA_0)
-			drive->pio_mode =
-				mwdma_to_pio[speed - XFER_MW_DMA_0] + XFER_PIO_0;
-		else
-			drive->pio_mode = XFER_PIO_2; /* for SWDMA2 */
-
-		piix_set_pio_mode(hwif, drive);
-	}
-}
+static int piix_no_dma;
 
 /**
  *	init_chipset_ich	-	set up the ICH chipset
@@ -237,6 +102,7 @@ static void ich_clear_irq(ide_drive_t *d
 	outb(dma_stat, hwif->dma_base + ATA_DMA_STATUS);
 }
 
+#include <linux/ide2libata.h>
 #include "../ata/ata_piix.h"
 
 static int piix_cable_detect(ide_hwif_t *hwif)
@@ -263,22 +129,19 @@ static int piix_cable_detect(ide_hwif_t
 
 static void __devinit init_hwif_piix(ide_hwif_t *hwif)
 {
-	if (!hwif->dma_base)
-		return;
-
-	if (no_piix_dma)
+	if (hwif->dma_base && piix_no_dma)
 		hwif->ultra_mask = hwif->mwdma_mask = hwif->swdma_mask = 0;
 }
 
 static const struct ide_port_ops piix_port_ops = {
-	.set_pio_mode		= piix_set_pio_mode,
-	.set_dma_mode		= piix_set_dma_mode,
+	.set_pio_mode		= piix_set_piomode,
+	.set_dma_mode		= ich_set_dmamode, /* FIXME: needs more work */
 	.cable_detect		= piix_cable_detect,
 };
 
 static const struct ide_port_ops ich_port_ops = {
-	.set_pio_mode		= piix_set_pio_mode,
-	.set_dma_mode		= piix_set_dma_mode,
+	.set_pio_mode		= piix_set_piomode,
+	.set_dma_mode		= ich_set_dmamode,
 	.clear_irq		= ich_clear_irq,
 	.cable_detect		= piix_cable_detect,
 };
@@ -346,38 +209,10 @@ static const struct ide_port_info piix_p
  
 static int __devinit piix_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
+	piix_no_dma = piix_check_450nx_errata(dev);
 	return ide_pci_init_one(dev, &piix_pci_info[id->driver_data], NULL);
 }
 
-/**
- *	piix_check_450nx	-	Check for problem 450NX setup
- *	
- *	Check for the present of 450NX errata #19 and errata #25. If
- *	they are found, disable use of DMA IDE
- */
-
-static void __devinit piix_check_450nx(void)
-{
-	struct pci_dev *pdev = NULL;
-	u16 cfg;
-	while((pdev=pci_get_device(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82454NX, pdev))!=NULL)
-	{
-		/* Look for 450NX PXB. Check for problem configurations
-		   A PCI quirk checks bit 6 already */
-		pci_read_config_word(pdev, 0x41, &cfg);
-		/* Only on the original revision: IDE DMA can hang */
-		if (pdev->revision == 0x00)
-			no_piix_dma = 1;
-		/* On all revisions below 5 PXB bus lock must be disabled for IDE */
-		else if (cfg & (1<<14) && pdev->revision < 5)
-			no_piix_dma = 2;
-	}
-	if(no_piix_dma)
-		printk(KERN_WARNING DRV_NAME ": 450NX errata present, disabling IDE DMA.\n");
-	if(no_piix_dma == 2)
-		printk(KERN_WARNING DRV_NAME ": A BIOS update may resolve this.\n");
-}		
-
 static const struct pci_device_id piix_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371FB_0),  1 },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82371FB_1),  1 },
@@ -421,7 +256,6 @@ static struct pci_driver piix_pci_driver
 
 static int __init piix_ide_init(void)
 {
-	piix_check_450nx();
 	return ide_pci_register_driver(&piix_pci_driver);
 }
 
