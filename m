Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600Ab0A2QJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab0A2QJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029Ab0A2QI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:08:59 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab0A2QI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:08:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Dj61voXcUQqFRgDaxyO6xLb5QLJO7jfAvEuMPrSwx17I8bg70hRHiCo7L25nw6pznp
         qqu0PcC0/QF0jqnjXz68e33rWJM7+1ol8zOsMEp0lxno3M8ZVVK07POFn6/2u0KMQhgx
         coF4rL8bvyGJx0eWHsjLTKpEYtBK7CxlV2dqc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:08:49 +0100
Message-Id: <20100129160849.21495.882.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 53/68] it8213: convert to ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] it8213: convert to ide2libata

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_it8213.h |   11 +++
 drivers/ide/it8213.c      |  138 +---------------------------------------------
 2 files changed, 13 insertions(+), 136 deletions(-)

Index: b/drivers/ata/pata_it8213.h
===================================================================
--- a/drivers/ata/pata_it8213.h
+++ b/drivers/ata/pata_it8213.h
@@ -141,9 +141,16 @@ static void it8213_set_dmamode(struct at
 		ideconf |= u_clock << devid;
 		pci_write_config_word(dev, 0x54, ideconf);
 	} else {
-		/* MWDMA is driven by the PIO timings. */
+		/* Normal DMA is driven by the PIO timings. */
+#ifdef __IDE2LIBATA
+		if (speed >= XFER_MW_DMA_0)
+			adev->pio_mode = ata_mwdma_to_pio(speed) + XFER_PIO_0;
+		else
+			adev->pio_mode = XFER_PIO_2; /* for SWDMA2 */
+		it8213_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0, 1);
+#else
 		it8213_set_timings(ap, adev, ata_mwdma_to_pio(speed), 1);
-
+#endif
 		udma_enable &= ~(1 << devid);
 	}
 	pci_write_config_byte(dev, 0x48, udma_enable);
Index: b/drivers/ide/it8213.c
===================================================================
--- a/drivers/ide/it8213.c
+++ b/drivers/ide/it8213.c
@@ -15,142 +15,12 @@
 
 #define DRV_NAME "it8213"
 
-/**
- *	it8213_set_pio_mode	-	set host controller for PIO mode
- *	@hwif: port
- *	@drive: drive
- *
- *	Set the interface PIO mode.
- */
-
-static void it8213_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	int is_slave		= drive->dn & 1;
-	int master_port		= 0x40;
-	int slave_port		= 0x44;
-	unsigned long flags;
-	u16 master_data;
-	u8 slave_data;
-	static DEFINE_SPINLOCK(tune_lock);
-	int control = 0;
-	const u8 pio = drive->pio_mode - XFER_PIO_0;
-
-	static const u8 timings[][2] = {
-					{ 0, 0 },
-					{ 0, 0 },
-					{ 1, 0 },
-					{ 2, 1 },
-					{ 2, 3 }, };
-
-	spin_lock_irqsave(&tune_lock, flags);
-	pci_read_config_word(dev, master_port, &master_data);
-
-	if (pio > 1)
-		control |= 1;	/* Programmable timing on */
-	if (drive->media != ide_disk)
-		control |= 4;	/* ATAPI */
-	if (ide_pio_need_iordy(drive, pio))
-		control |= 2;	/* IORDY */
-	if (is_slave) {
-		master_data |=  0x4000;
-		master_data &= ~0x0070;
-		master_data = master_data | (control << 4);
-		pci_read_config_byte(dev, slave_port, &slave_data);
-		slave_data = slave_data & 0xf0;
-		slave_data = slave_data | (timings[pio][0] << 2) | timings[pio][1];
-	} else {
-		master_data &= ~0x3307;
-		master_data = master_data | control;
-		master_data = master_data | (timings[pio][0] << 12) | (timings[pio][1] << 8);
-	}
-	pci_write_config_word(dev, master_port, master_data);
-	if (is_slave)
-		pci_write_config_byte(dev, slave_port, slave_data);
-	spin_unlock_irqrestore(&tune_lock, flags);
-}
-
-/**
- *	it8213_set_dma_mode	-	set host controller for DMA mode
- *	@hwif: port
- *	@drive: drive
- *
- *	Tune the ITE chipset for the DMA mode.
- */
-
-static void it8213_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	u8 maslave		= 0x40;
-	int a_speed		= 3 << (drive->dn * 4);
-	int u_flag		= 1 << drive->dn;
-	int v_flag		= 0x01 << drive->dn;
-	int w_flag		= 0x10 << drive->dn;
-	int u_speed		= 0;
-	u16			reg4042, reg4a;
-	u8			reg48, reg54, reg55;
-	const u8 speed		= drive->dma_mode;
-
-	pci_read_config_word(dev, maslave, &reg4042);
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
-		if (speed >= XFER_UDMA_5)
-			pci_write_config_byte(dev, 0x55, (u8) reg55|w_flag);
-		else
-			pci_write_config_byte(dev, 0x55, (u8) reg55 & ~w_flag);
-
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
-		it8213_set_pio_mode(hwif, drive);
-	}
-}
-
-static int it8213_cable_detect(ide_hwif_t *hwif)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	u8 reg42h = 0;
-
-	pci_read_config_byte(dev, 0x42, &reg42h);
-
-	return (reg42h & 0x02) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
-}
+#include <linux/ide2libata.h>
+#include "../ata/pata_it8213.h"
 
 static const struct ide_port_ops it8213_port_ops = {
-	.set_pio_mode		= it8213_set_pio_mode,
-	.set_dma_mode		= it8213_set_dma_mode,
+	.set_pio_mode		= it8213_set_piomode,
+	.set_dma_mode		= it8213_set_dmamode,
 	.cable_detect		= it8213_cable_detect,
 };
 
