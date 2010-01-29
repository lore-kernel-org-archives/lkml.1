Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944Ab0A2QPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab0A2QPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958Ab0A2QPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:15:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:35978 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab0A2QHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:07:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=BMIuMsJTsBkM4m0nBbbt7Fpq26U+C3tJQ+cdgPaANSVcU2XXlP0b6XXIy8XKDg5X0F
         rnxV9iWYFh1yFJAvCwSyBv5Wc3BJOyOgaWl8s+OYgTaKaLnfGMXR4PbEIUQvuAoHXxDc
         7tp6vkVRCU5vBQswAzbRXIY3Sjd4v6qvUijMM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:07:12 +0100
Message-Id: <20100129160712.21495.19893.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 38/68] atiixp: convert to ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] atiixp: convert to ide2libata

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/atiixp.c |  126 +--------------------------------------------------
 1 file changed, 4 insertions(+), 122 deletions(-)

Index: b/drivers/ide/atiixp.c
===================================================================
--- a/drivers/ide/atiixp.c
+++ b/drivers/ide/atiixp.c
@@ -12,130 +12,12 @@
 
 #define DRV_NAME "atiixp"
 
-#define ATIIXP_IDE_PIO_TIMING		0x40
-#define ATIIXP_IDE_MDMA_TIMING		0x44
-#define ATIIXP_IDE_PIO_CONTROL		0x48
-#define ATIIXP_IDE_PIO_MODE		0x4a
-#define ATIIXP_IDE_UDMA_CONTROL		0x54
-#define ATIIXP_IDE_UDMA_MODE		0x56
-
-typedef struct {
-	u8 command_width;
-	u8 recover_width;
-} atiixp_ide_timing;
-
-static atiixp_ide_timing pio_timing[] = {
-	{ 0x05, 0x0d },
-	{ 0x04, 0x07 },
-	{ 0x03, 0x04 },
-	{ 0x02, 0x02 },
-	{ 0x02, 0x00 },
-};
-
-static atiixp_ide_timing mdma_timing[] = {
-	{ 0x07, 0x07 },
-	{ 0x02, 0x01 },
-	{ 0x02, 0x00 },
-};
-
-static DEFINE_SPINLOCK(atiixp_lock);
-
-/**
- *	atiixp_set_pio_mode	-	set host controller for PIO mode
- *	@hwif: port
- *	@drive: drive
- *
- *	Set the interface PIO mode.
- */
-
-static void atiixp_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	unsigned long flags;
-	int timing_shift = (drive->dn ^ 1) * 8;
-	u32 pio_timing_data;
-	u16 pio_mode_data;
-	const u8 pio = drive->pio_mode - XFER_PIO_0;
-
-	spin_lock_irqsave(&atiixp_lock, flags);
-
-	pci_read_config_word(dev, ATIIXP_IDE_PIO_MODE, &pio_mode_data);
-	pio_mode_data &= ~(0x07 << (drive->dn * 4));
-	pio_mode_data |= (pio << (drive->dn * 4));
-	pci_write_config_word(dev, ATIIXP_IDE_PIO_MODE, pio_mode_data);
-
-	pci_read_config_dword(dev, ATIIXP_IDE_PIO_TIMING, &pio_timing_data);
-	pio_timing_data &= ~(0xff << timing_shift);
-	pio_timing_data |= (pio_timing[pio].recover_width << timing_shift) |
-		 (pio_timing[pio].command_width << (timing_shift + 4));
-	pci_write_config_dword(dev, ATIIXP_IDE_PIO_TIMING, pio_timing_data);
-
-	spin_unlock_irqrestore(&atiixp_lock, flags);
-}
-
-/**
- *	atiixp_set_dma_mode	-	set host controller for DMA mode
- *	@hwif: port
- *	@drive: drive
- *
- *	Set a ATIIXP host controller to the desired DMA mode.  This involves
- *	programming the right timing data into the PCI configuration space.
- */
-
-static void atiixp_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	unsigned long flags;
-	int timing_shift = (drive->dn ^ 1) * 8;
-	u32 tmp32;
-	u16 tmp16;
-	u16 udma_ctl = 0;
-	const u8 speed = drive->dma_mode;
-
-	spin_lock_irqsave(&atiixp_lock, flags);
-
-	pci_read_config_word(dev, ATIIXP_IDE_UDMA_CONTROL, &udma_ctl);
-
-	if (speed >= XFER_UDMA_0) {
-		pci_read_config_word(dev, ATIIXP_IDE_UDMA_MODE, &tmp16);
-		tmp16 &= ~(0x07 << (drive->dn * 4));
-		tmp16 |= ((speed & 0x07) << (drive->dn * 4));
-		pci_write_config_word(dev, ATIIXP_IDE_UDMA_MODE, tmp16);
-
-		udma_ctl |= (1 << drive->dn);
-	} else if (speed >= XFER_MW_DMA_0) {
-		u8 i = speed & 0x03;
-
-		pci_read_config_dword(dev, ATIIXP_IDE_MDMA_TIMING, &tmp32);
-		tmp32 &= ~(0xff << timing_shift);
-		tmp32 |= (mdma_timing[i].recover_width << timing_shift) |
-			 (mdma_timing[i].command_width << (timing_shift + 4));
-		pci_write_config_dword(dev, ATIIXP_IDE_MDMA_TIMING, tmp32);
-
-		udma_ctl &= ~(1 << drive->dn);
-	}
-
-	pci_write_config_word(dev, ATIIXP_IDE_UDMA_CONTROL, udma_ctl);
-
-	spin_unlock_irqrestore(&atiixp_lock, flags);
-}
-
-static int atiixp_cable_detect(ide_hwif_t *hwif)
-{
-	struct pci_dev *pdev = to_pci_dev(hwif->dev);
-	u8 udma_mode = 0, ch = hwif->channel;
-
-	pci_read_config_byte(pdev, ATIIXP_IDE_UDMA_MODE + ch, &udma_mode);
-
-	if ((udma_mode & 0x07) >= 0x04 || (udma_mode & 0x70) >= 0x40)
-		return ATA_CBL_PATA80;
-	else
-		return ATA_CBL_PATA40;
-}
+#include <linux/ide2libata.h>
+#include <../ata/pata_atiixp.h>
 
 static const struct ide_port_ops atiixp_port_ops = {
-	.set_pio_mode		= atiixp_set_pio_mode,
-	.set_dma_mode		= atiixp_set_dma_mode,
+	.set_pio_mode		= atiixp_set_piomode,
+	.set_dma_mode		= atiixp_set_dmamode,
 	.cable_detect		= atiixp_cable_detect,
 };
 
