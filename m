Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794Ab0A2QJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab0A2QJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755738Ab0A2QJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:09:32 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab0A2QJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:09:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=je8TJD330cvE79mczxPiSKjqUplbLwSupqVzUJdeUWeEH4rj90P3JIpQGqBFw2PhLY
         vXQPYpJzmEqnNTqu2G7oPPPV5kVg7uDAm89IU1WPuy8WzB8XaeJvvBR7XqJLIqABS1yn
         Xwb19LXG2VgaV5jIT3ytoZhg6Ahz4hz/iJYh8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:09:15 +0100
Message-Id: <20100129160915.21495.44971.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 57/68] pdc202xx_old: convert to ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pdc202xx_old: convert to ide2libata

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_pdc202xx_old.h |   12 ++++++
 drivers/ide/pdc202xx_old.c      |   80 +++-------------------------------------
 2 files changed, 18 insertions(+), 74 deletions(-)

Index: b/drivers/ata/pata_pdc202xx_old.h
===================================================================
--- a/drivers/ata/pata_pdc202xx_old.h
+++ b/drivers/ata/pata_pdc202xx_old.h
@@ -1,7 +1,11 @@
 
 static int pdc2026x_cable_detect(struct ata_port *ap)
 {
+#ifndef __IDE2LIBATA
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+#else
+	struct pci_dev *pdev = to_pci_dev(ap->dev);
+#endif
 	u16 cis;
 
 	pci_read_config_word(pdev, 0x50, &cis);
@@ -23,7 +27,11 @@ static int pdc2026x_cable_detect(struct
 
 static void pdc202xx_configure_piomode(struct ata_port *ap, struct ata_device *adev, int pio)
 {
+#ifndef __IDE2LIBATA
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+#else
+	struct pci_dev *pdev = to_pci_dev(ap->dev);
+#endif
 	int port = 0x60 + 8 * ap->port_no + 4 * adev->devno;
 	static u16 pio_timing[5] = {
 		0x0913, 0x050C , 0x0308, 0x0206, 0x0104
@@ -70,7 +78,11 @@ static void pdc202xx_set_piomode(struct
 
 static void pdc202xx_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
+#ifndef __IDE2LIBATA
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+#else
+	struct pci_dev *pdev = to_pci_dev(ap->dev);
+#endif
 	int port = 0x60 + 8 * ap->port_no + 4 * adev->devno;
 	static u8 udma_timing[6][2] = {
 		{ 0x60, 0x03 },	/* 33 Mhz Clock */
Index: b/drivers/ide/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -21,66 +21,8 @@
 
 #define DRV_NAME "pdc202xx_old"
 
-static void pdc202xx_set_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	u8 drive_pci		= 0x60 + (drive->dn << 2);
-	const u8 speed		= drive->dma_mode;
-
-	u8			AP = 0, BP = 0, CP = 0;
-	u8			TA = 0, TB = 0, TC = 0;
-
-	pci_read_config_byte(dev, drive_pci,     &AP);
-	pci_read_config_byte(dev, drive_pci + 1, &BP);
-	pci_read_config_byte(dev, drive_pci + 2, &CP);
-
-	switch(speed) {
-		case XFER_UDMA_5:
-		case XFER_UDMA_4:	TB = 0x20; TC = 0x01; break;
-		case XFER_UDMA_2:	TB = 0x20; TC = 0x01; break;
-		case XFER_UDMA_3:
-		case XFER_UDMA_1:	TB = 0x40; TC = 0x02; break;
-		case XFER_UDMA_0:
-		case XFER_MW_DMA_2:	TB = 0x60; TC = 0x03; break;
-		case XFER_MW_DMA_1:	TB = 0x60; TC = 0x04; break;
-		case XFER_MW_DMA_0:	TB = 0xE0; TC = 0x0F; break;
-		case XFER_PIO_4:	TA = 0x01; TB = 0x04; break;
-		case XFER_PIO_3:	TA = 0x02; TB = 0x06; break;
-		case XFER_PIO_2:	TA = 0x03; TB = 0x08; break;
-		case XFER_PIO_1:	TA = 0x05; TB = 0x0C; break;
-		case XFER_PIO_0:
-		default:		TA = 0x09; TB = 0x13; break;
-	}
-
-	if (speed < XFER_SW_DMA_0) {
-		/*
-		 * preserve SYNC_INT / ERDDY_EN bits while clearing
-		 * Prefetch_EN / IORDY_EN / PA[3:0] bits of register A
-		 */
-		AP &= ~0x3f;
-		if (ide_pio_need_iordy(drive, speed - XFER_PIO_0))
-			AP |= 0x20;	/* set IORDY_EN bit */
-		if (drive->media == ide_disk)
-			AP |= 0x10;	/* set Prefetch_EN bit */
-		/* clear PB[4:0] bits of register B */
-		BP &= ~0x1f;
-		pci_write_config_byte(dev, drive_pci,     AP | TA);
-		pci_write_config_byte(dev, drive_pci + 1, BP | TB);
-	} else {
-		/* clear MB[2:0] bits of register B */
-		BP &= ~0xe0;
-		/* clear MC[3:0] bits of register C */
-		CP &= ~0x0f;
-		pci_write_config_byte(dev, drive_pci + 1, BP | TB);
-		pci_write_config_byte(dev, drive_pci + 2, CP | TC);
-	}
-}
-
-static void pdc202xx_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	drive->dma_mode = drive->pio_mode;
-	pdc202xx_set_mode(hwif, drive);
-}
+#include <linux/ide2libata.h>
+#include "../ata/pata_pdc202xx_old.h"
 
 static int pdc202xx_test_irq(ide_hwif_t *hwif)
 {
@@ -103,16 +45,6 @@ static int pdc202xx_test_irq(ide_hwif_t
 	}
 }
 
-static int pdc2026x_cable_detect(ide_hwif_t *hwif)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	u16 CIS, mask = hwif->channel ? (1 << 11) : (1 << 10);
-
-	pci_read_config_word(dev, 0x50, &CIS);
-
-	return (CIS & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
-}
-
 /*
  * Set the control register to use the 66MHz system
  * clock for UDMA 3/4/5 mode operation when necessary.
@@ -233,14 +165,14 @@ static void __devinit pdc202ata4_fixup_i
 	 IDE_HFLAG_OFF_BOARD)
 
 static const struct ide_port_ops pdc20246_port_ops = {
-	.set_pio_mode		= pdc202xx_set_pio_mode,
-	.set_dma_mode		= pdc202xx_set_mode,
+	.set_pio_mode		= pdc202xx_set_piomode,
+	.set_dma_mode		= pdc202xx_set_dmamode,
 	.test_irq		= pdc202xx_test_irq,
 };
 
 static const struct ide_port_ops pdc2026x_port_ops = {
-	.set_pio_mode		= pdc202xx_set_pio_mode,
-	.set_dma_mode		= pdc202xx_set_mode,
+	.set_pio_mode		= pdc202xx_set_piomode,
+	.set_dma_mode		= pdc202xx_set_dmamode,
 	.cable_detect		= pdc2026x_cable_detect,
 };
 
