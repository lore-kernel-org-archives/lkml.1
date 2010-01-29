Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493Ab0A2QQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab0A2QQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899Ab0A2QQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:16:21 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab0A2QHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:07:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=mmIB4r5gbOSbSuUy3KurHEQFtBYDrbGDVhwp8Zuqptvqi3dT2Smaiv4+kUIAwpdUE8
         /lczzvet8dySWWKkqIbOVzPp+UR08xTwUpnHeFPsA/XvLaR2P65jfFfWI4uDI5P16s57
         u5vilcGU1iJGDsIeti0w0Qqx1IsPLRZQNeQ8U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:06:59 +0100
Message-Id: <20100129160659.21495.7783.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 36/68] aec62xx: convert to ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] aec62xx: convert to ide2libata

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_artop.h |   97 +++++++++++++++++++++-----
 drivers/ide/aec62xx.c    |  172 ++---------------------------------------------
 2 files changed, 90 insertions(+), 179 deletions(-)

Index: b/drivers/ata/pata_artop.h
===================================================================
--- a/drivers/ata/pata_artop.h
+++ b/drivers/ata/pata_artop.h
@@ -16,11 +16,15 @@ static int atp86x_cable_detect(struct at
 	return ATA_CBL_PATA80;
 }
 
+/* The ARTOP has 33 Mhz and "over clocked" timing tables. */
+static int clock;
+
 /**
  *	atp850_load_piomode - Load a set of PATA PIO timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device
  *	@pio: PIO mode
+ *	@set_mwdma: set MWDMA mode flag
  *
  *	Set PIO mode for device, in host controller PCI config space. This
  *	is used both to set PIO timings in PIO mode and also to set the
@@ -31,14 +35,21 @@ static int atp86x_cable_detect(struct at
  */
 
 static void atp850_load_piomode(struct ata_port *ap, struct ata_device *adev,
-				unsigned int pio)
+				unsigned int pio, bool set_mwdma)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int dn = adev->devno + 2 * ap->port_no;
-	const u16 timing[5] = { 0x0000, 0x000A, 0x0008, 0x0303, 0x0301 };
+	const u16 timing[2][5] = {
+		{ 0x0000, 0x000A, 0x0008, 0x0303, 0x0301 },
+		{ 0x0700, 0x070A, 0x0708, 0x0403, 0x0401 }
+	};
+	u16 t = timing[clock][pio];
+
+	if (clock && set_mwdma && adev->dma_mode == XFER_MW_DMA_1)
+		t = 0x0402;
 
 	/* Load the PIO timing active/recovery bits */
-	pci_write_config_word(pdev, 0x40 + 2 * dn, timing[pio]);
+	pci_write_config_word(pdev, 0x40 + 2 * dn, t);
 }
 
 /**
@@ -58,15 +69,25 @@ static void atp850_load_piomode(struct a
 static void atp850_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+#ifdef __IDE2LIBATA
+	unsigned long flags;
+#endif
 	int dn = adev->devno + 2 * ap->port_no;
 	u8 ultra;
 
-	atp850_load_piomode(ap, adev, adev->pio_mode - XFER_PIO_0);
+#ifdef __IDE2LIBATA
+	local_irq_save(flags);
+#endif
+	atp850_load_piomode(ap, adev, adev->pio_mode - XFER_PIO_0, 0);
 
 	/* Clear the UDMA mode bits (set_dmamode will redo this if needed) */
 	pci_read_config_byte(pdev, 0x54, &ultra);
 	ultra &= ~(3 << (2 * dn));
 	pci_write_config_byte(pdev, 0x54, ultra);
+
+#ifdef __IDE2LIBATA
+	local_irq_restore(flags);
+#endif
 }
 
 /**
@@ -74,6 +95,7 @@ static void atp850_set_piomode(struct at
  *	@ap: Port whose timings we are configuring
  *	@adev: Device we are configuring
  *	@pio: PIO mode
+ *	@set_mwdma: set MWDMA mode flag
  *
  *	Set PIO mode for device, in host controller PCI config space.
  *	The ATP860 and relatives store the timing data differently.
@@ -83,14 +105,22 @@ static void atp850_set_piomode(struct at
  */
 
 static void atp86x_load_piomode(struct ata_port *ap, struct ata_device *adev,
-				unsigned int pio)
+				unsigned int pio, bool set_mwdma)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int dn = adev->devno + 2 * ap->port_no;
-	const u8 timing[5] = { 0x00, 0x0A, 0x08, 0x33, 0x31 };
+	const u8 timing[2][5] = {
+		{ 0x00, 0x0A, 0x08, 0x33, 0x31 },
+		{ 0x70, 0x7A, 0x78, 0x43, 0x41 }
+
+	};
+	u16 t = timing[clock][pio];
+
+	if (clock && set_mwdma && adev->dma_mode == XFER_MW_DMA_1)
+		t = 0x42;
 
 	/* Load the PIO timing active/recovery bits */
-	pci_write_config_byte(pdev, 0x40 + dn, timing[pio]);
+	pci_write_config_byte(pdev, 0x40 + dn, t);
 }
 
 /**
@@ -110,14 +140,24 @@ static void atp86x_load_piomode(struct a
 static void atp86x_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+#ifdef __IDE2LIBATA
+	unsigned long flags;
+#endif
 	u8 ultra;
 
-	atp86x_load_piomode(ap, adev, adev->pio_mode - XFER_PIO_0);
+#ifdef __IDE2LIBATA
+	local_irq_save(flags);
+#endif
+	atp86x_load_piomode(ap, adev, adev->pio_mode - XFER_PIO_0, 0);
 
 	/* Clear the UDMA mode bits (set_dmamode will redo this if needed) */
 	pci_read_config_byte(pdev, 0x44 + ap->port_no, &ultra);
 	ultra &= ~(7 << (4  * adev->devno));	/* One nibble per drive */
 	pci_write_config_byte(pdev, 0x44 + ap->port_no, ultra);
+
+#ifdef __IDE2LIBATA
+	local_irq_restore(flags);
+#endif
 }
 
 /**
@@ -133,8 +173,11 @@ static void atp86x_set_piomode(struct at
 
 static void atp850_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
-	unsigned int pio;
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+#ifdef __IDE2LIBATA
+	unsigned long flags;
+#endif
+	unsigned int pio;
 	int dn = adev->devno + 2 * ap->port_no;
 	u8 ultra;
 
@@ -143,20 +186,27 @@ static void atp850_set_dmamode(struct at
 	else
 		pio = 4;
 
+#ifdef __IDE2LIBATA
+	local_irq_save(flags);
+#endif
 	/* Load the PIO timing active/recovery bits */
-	atp850_load_piomode(ap, adev, pio);
+	atp850_load_piomode(ap, adev, pio, 1);
 
 	pci_read_config_byte(pdev, 0x54, &ultra);
 	ultra &= ~(3 << (2 * dn));
 
 	/* Add ultra DMA bits if in UDMA mode */
 	if (adev->dma_mode >= XFER_UDMA_0) {
-		u8 mode = (adev->dma_mode - XFER_UDMA_0) + 1;
+		u8 mode = (adev->dma_mode - XFER_UDMA_0) + 1 - clock;
 		if (mode == 0)
 			mode = 1;
 		ultra |= (mode << (2 * dn));
 	}
 	pci_write_config_byte(pdev, 0x54, ultra);
+
+#ifdef __IDE2LIBATA
+	local_irq_restore(flags);
+#endif
 }
 
 /**
@@ -173,8 +223,11 @@ static void atp850_set_dmamode(struct at
 
 static void atp86x_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
-	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+#ifdef __IDE2LIBATA
+	unsigned long flags;
+#endif
+	unsigned int pio;
 	u8 ultra;
 
 	if (adev->dma_mode == XFER_MW_DMA_0)
@@ -182,29 +235,38 @@ static void atp86x_set_dmamode(struct at
 	else
 		pio = 4;
 
+#ifdef __IDE2LIBATA
+	local_irq_save(flags);
+#endif
 	/* Load the PIO timing active/recovery bits */
-	atp86x_load_piomode(ap, adev, pio);
+	atp86x_load_piomode(ap, adev, pio, 1);
 
 	/* Add ultra DMA bits if in UDMA mode */
 	pci_read_config_byte(pdev, 0x44 + ap->port_no, &ultra);
 	ultra &= ~(7 << (4  * adev->devno));	/* One nibble per drive */
 	if (adev->dma_mode >= XFER_UDMA_0) {
-		u8 mode = adev->dma_mode - XFER_UDMA_0 + 1;
+		u8 mode = adev->dma_mode - XFER_UDMA_0 + 1 - clock;
 		if (mode == 0)
 			mode = 1;
 		ultra |= (mode << (4 * adev->devno));
 	}
 	pci_write_config_byte(pdev, 0x44 + ap->port_no, ultra);
+
+#ifdef __IDE2LIBATA
+	local_irq_restore(flags);
+#endif
 }
 
 static int atp8xx_fixup(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 
-	if (pdev->device == 0x0005)
+	if (pdev->device == 0x0005) {
 		/* BIOS may have left us in UDMA, clear it before probe */
+#ifndef __IDE2LIBATA
 		pci_write_config_byte(pdev, 0x54, 0);
-	else if (pdev->device == 0x0008 || pdev->device == 0x0009) {
+#endif
+	} else if (pdev->device == 0x0008 || pdev->device == 0x0009) {
 		u8 reg;
 
 		/* Mac systems come up with some registers not set as we
@@ -217,10 +279,11 @@ static int atp8xx_fixup(struct device *d
 		/* PCI latency must be > 0x80 for burst mode, tweak it
 		 * if required.
 		 */
+#ifndef __IDE2LIBATA
 		pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &reg);
 		if (reg <= 0x80)
 			pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x90);
-
+#endif
 		/* Enable IRQ output and burst mode */
 		pci_read_config_byte(pdev, 0x4a, &reg);
 		pci_write_config_byte(pdev, 0x4a, (reg & ~0x01) | 0x80);
Index: b/drivers/ide/aec62xx.c
===================================================================
--- a/drivers/ide/aec62xx.c
+++ b/drivers/ide/aec62xx.c
@@ -14,170 +14,22 @@
 
 #define DRV_NAME "aec62xx"
 
-struct chipset_bus_clock_list_entry {
-	u8 xfer_speed;
-	u8 chipset_settings;
-	u8 ultra_settings;
-};
-
-static const struct chipset_bus_clock_list_entry aec6xxx_33_base [] = {
-	{	XFER_UDMA_6,	0x31,	0x07	},
-	{	XFER_UDMA_5,	0x31,	0x06	},
-	{	XFER_UDMA_4,	0x31,	0x05	},
-	{	XFER_UDMA_3,	0x31,	0x04	},
-	{	XFER_UDMA_2,	0x31,	0x03	},
-	{	XFER_UDMA_1,	0x31,	0x02	},
-	{	XFER_UDMA_0,	0x31,	0x01	},
-
-	{	XFER_MW_DMA_2,	0x31,	0x00	},
-	{	XFER_MW_DMA_1,	0x31,	0x00	},
-	{	XFER_MW_DMA_0,	0x0a,	0x00	},
-	{	XFER_PIO_4,	0x31,	0x00	},
-	{	XFER_PIO_3,	0x33,	0x00	},
-	{	XFER_PIO_2,	0x08,	0x00	},
-	{	XFER_PIO_1,	0x0a,	0x00	},
-	{	XFER_PIO_0,	0x00,	0x00	},
-	{	0,		0x00,	0x00	}
-};
-
-static const struct chipset_bus_clock_list_entry aec6xxx_34_base [] = {
-	{	XFER_UDMA_6,	0x41,	0x06	},
-	{	XFER_UDMA_5,	0x41,	0x05	},
-	{	XFER_UDMA_4,	0x41,	0x04	},
-	{	XFER_UDMA_3,	0x41,	0x03	},
-	{	XFER_UDMA_2,	0x41,	0x02	},
-	{	XFER_UDMA_1,	0x41,	0x01	},
-	{	XFER_UDMA_0,	0x41,	0x01	},
-
-	{	XFER_MW_DMA_2,	0x41,	0x00	},
-	{	XFER_MW_DMA_1,	0x42,	0x00	},
-	{	XFER_MW_DMA_0,	0x7a,	0x00	},
-	{	XFER_PIO_4,	0x41,	0x00	},
-	{	XFER_PIO_3,	0x43,	0x00	},
-	{	XFER_PIO_2,	0x78,	0x00	},
-	{	XFER_PIO_1,	0x7a,	0x00	},
-	{	XFER_PIO_0,	0x70,	0x00	},
-	{	0,		0x00,	0x00	}
-};
-
-/*
- * TO DO: active tuning and correction of cards without a bios.
- */
-static u8 pci_bus_clock_list (u8 speed, struct chipset_bus_clock_list_entry * chipset_table)
-{
-	for ( ; chipset_table->xfer_speed ; chipset_table++)
-		if (chipset_table->xfer_speed == speed) {
-			return chipset_table->chipset_settings;
-		}
-	return chipset_table->chipset_settings;
-}
-
-static u8 pci_bus_clock_list_ultra (u8 speed, struct chipset_bus_clock_list_entry * chipset_table)
-{
-	for ( ; chipset_table->xfer_speed ; chipset_table++)
-		if (chipset_table->xfer_speed == speed) {
-			return chipset_table->ultra_settings;
-		}
-	return chipset_table->ultra_settings;
-}
-
-static void aec6210_set_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	struct ide_host *host	= pci_get_drvdata(dev);
-	struct chipset_bus_clock_list_entry *bus_clock = host->host_priv;
-	u16 d_conf		= 0;
-	u8 ultra = 0, ultra_conf = 0;
-	u8 tmp0 = 0, tmp1 = 0, tmp2 = 0;
-	const u8 speed = drive->dma_mode;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	/* 0x40|(2*drive->dn): Active, 0x41|(2*drive->dn): Recovery */
-	pci_read_config_word(dev, 0x40|(2*drive->dn), &d_conf);
-	tmp0 = pci_bus_clock_list(speed, bus_clock);
-	d_conf = ((tmp0 & 0xf0) << 4) | (tmp0 & 0xf);
-	pci_write_config_word(dev, 0x40|(2*drive->dn), d_conf);
-
-	tmp1 = 0x00;
-	tmp2 = 0x00;
-	pci_read_config_byte(dev, 0x54, &ultra);
-	tmp1 = ((0x00 << (2*drive->dn)) | (ultra & ~(3 << (2*drive->dn))));
-	ultra_conf = pci_bus_clock_list_ultra(speed, bus_clock);
-	tmp2 = ((ultra_conf << (2*drive->dn)) | (tmp1 & ~(3 << (2*drive->dn))));
-	pci_write_config_byte(dev, 0x54, tmp2);
-	local_irq_restore(flags);
-}
-
-static void aec6260_set_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	struct ide_host *host	= pci_get_drvdata(dev);
-	struct chipset_bus_clock_list_entry *bus_clock = host->host_priv;
-	u8 unit			= drive->dn & 1;
-	u8 tmp1 = 0, tmp2 = 0;
-	u8 ultra = 0, drive_conf = 0, ultra_conf = 0;
-	const u8 speed = drive->dma_mode;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	/* high 4-bits: Active, low 4-bits: Recovery */
-	pci_read_config_byte(dev, 0x40|drive->dn, &drive_conf);
-	drive_conf = pci_bus_clock_list(speed, bus_clock);
-	pci_write_config_byte(dev, 0x40|drive->dn, drive_conf);
-
-	pci_read_config_byte(dev, (0x44|hwif->channel), &ultra);
-	tmp1 = ((0x00 << (4*unit)) | (ultra & ~(7 << (4*unit))));
-	ultra_conf = pci_bus_clock_list_ultra(speed, bus_clock);
-	tmp2 = ((ultra_conf << (4*unit)) | (tmp1 & ~(7 << (4*unit))));
-	pci_write_config_byte(dev, (0x44|hwif->channel), tmp2);
-	local_irq_restore(flags);
-}
-
-static void aec_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	drive->dma_mode = drive->pio_mode;
-	hwif->port_ops->set_dma_mode(hwif, drive);
-}
+#include <linux/ide2libata.h>
+#include "../ata/pata_artop.h"
 
 static int init_chipset_aec62xx(struct pci_dev *dev)
 {
-	/* These are necessary to get AEC6280 Macintosh cards to work */
-	if ((dev->device == PCI_DEVICE_ID_ARTOP_ATP865) ||
-	    (dev->device == PCI_DEVICE_ID_ARTOP_ATP865R)) {
-		u8 reg49h = 0, reg4ah = 0;
-		/* Clear reset and test bits.  */
-		pci_read_config_byte(dev, 0x49, &reg49h);
-		pci_write_config_byte(dev, 0x49, reg49h & ~0x30);
-		/* Enable chip interrupt output.  */
-		pci_read_config_byte(dev, 0x4a, &reg4ah);
-		pci_write_config_byte(dev, 0x4a, reg4ah & ~0x01);
-		/* Enable burst mode. */
-		pci_read_config_byte(dev, 0x4a, &reg4ah);
-		pci_write_config_byte(dev, 0x4a, reg4ah | 0x80);
-	}
-
-	return 0;
-}
-
-static int atp86x_cable_detect(ide_hwif_t *hwif)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	u8 ata66 = 0, mask = hwif->channel ? 0x02 : 0x01;
-
-	pci_read_config_byte(dev, 0x49, &ata66);
-
-	return (ata66 & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
+	return atp8xx_fixup(&dev->dev);
 }
 
 static const struct ide_port_ops atp850_port_ops = {
-	.set_pio_mode		= aec_set_pio_mode,
-	.set_dma_mode		= aec6210_set_mode,
+	.set_pio_mode		= atp850_set_piomode,
+	.set_dma_mode		= atp850_set_dmamode,
 };
 
 static const struct ide_port_ops atp86x_port_ops = {
-	.set_pio_mode		= aec_set_pio_mode,
-	.set_dma_mode		= aec6260_set_mode,
+	.set_pio_mode		= atp86x_set_piomode,
+	.set_dma_mode		= atp86x_set_dmamode,
 	.cable_detect		= atp86x_cable_detect,
 };
 
@@ -253,16 +105,12 @@ static const struct ide_port_info aec62x
 
 static int __devinit aec62xx_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	const struct chipset_bus_clock_list_entry *bus_clock;
 	struct ide_port_info d;
 	u8 idx = id->driver_data;
-	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 	int err;
 
-	if (bus_speed <= 33)
-		bus_clock = aec6xxx_33_base;
-	else
-		bus_clock = aec6xxx_34_base;
+	if (ide_pci_clk > 33)
+		clock = 1;
 
 	err = pci_enable_device(dev);
 	if (err)
@@ -280,7 +128,7 @@ static int __devinit aec62xx_init_one(st
 		}
 	}
 
-	err = ide_pci_init_one(dev, &d, (void *)bus_clock);
+	err = ide_pci_init_one(dev, &d, NULL);
 	if (err)
 		pci_disable_device(dev);
 
