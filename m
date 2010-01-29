Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473Ab0A2QIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab0A2QIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029Ab0A2QIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:08:45 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab0A2QIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:08:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=RzY/Ito5pmkV0zf+ApsR6TsxIGwsQ2as6YD/5dZPBq9OkqwhSAHeG3M7JKhxPYHJFf
         DoDw/yJEkhKh9o0pKIyNDOnl3yk7KQpx/1zN/iKuV0lQOTrdXOEDz0X0GeLUBqFQqUP/
         ooZ84GYz1cAGW22VJX/mEe9PbkPTPwAs5NFF4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:08:36 +0100
Message-Id: <20100129160836.21495.59042.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 51/68] slc90e66: convert to ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] slc90e66: convert to ide2libata

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_efar.h |   13 ++++-
 drivers/ide/slc90e66.c  |  113 ++----------------------------------------------
 2 files changed, 16 insertions(+), 110 deletions(-)

Index: b/drivers/ata/pata_efar.h
===================================================================
--- a/drivers/ata/pata_efar.h
+++ b/drivers/ata/pata_efar.h
@@ -146,7 +146,16 @@ static void efar_set_dmamode(struct ata_
 		pci_write_config_byte(dev, 0x48, udma_enable);
 
 		spin_unlock_irqrestore(&efar_lock, flags);
-	} else
-		/* MWDMA is driven by the PIO timings. */
+	} else {
+		/* Normal DMA is driven by the PIO timings. */
+#ifdef __IDE2LIBATA
+		if (speed >= XFER_MW_DMA_0)
+			adev->pio_mode = ata_mwdma_to_pio(speed) + XFER_PIO_0;
+		else
+			adev->pio_mode = XFER_PIO_2; /* for SWDMA2 */
+		efar_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0, 1);
+#else
 		efar_set_timings(ap, adev, ata_mwdma_to_pio(speed), 1);
+#endif
+	}
 }
Index: b/drivers/ide/slc90e66.c
===================================================================
--- a/drivers/ide/slc90e66.c
+++ b/drivers/ide/slc90e66.c
@@ -16,116 +16,13 @@
 
 #define DRV_NAME "slc90e66"
 
-static DEFINE_SPINLOCK(slc90e66_lock);
-
-static void slc90e66_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	int is_slave		= drive->dn & 1;
-	int master_port		= hwif->channel ? 0x42 : 0x40;
-	int slave_port		= 0x44;
-	unsigned long flags;
-	u16 master_data;
-	u8 slave_data;
-	int control = 0;
-	const u8 pio = drive->pio_mode - XFER_PIO_0;
-
-				     /* ISP  RTC */
-	static const u8 timings[][2] = {
-					{ 0, 0 },
-					{ 0, 0 },
-					{ 1, 0 },
-					{ 2, 1 },
-					{ 2, 3 }, };
-
-	spin_lock_irqsave(&slc90e66_lock, flags);
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
-	spin_unlock_irqrestore(&slc90e66_lock, flags);
-}
-
-static void slc90e66_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	u8 maslave		= hwif->channel ? 0x42 : 0x40;
-	int sitre = 0, a_speed	= 7 << (drive->dn * 4);
-	int u_speed = 0, u_flag = 1 << drive->dn;
-	u16			reg4042, reg44, reg48, reg4a;
-	const u8 speed		= drive->dma_mode;
-
-	pci_read_config_word(dev, maslave, &reg4042);
-	sitre = (reg4042 & 0x4000) ? 1 : 0;
-	pci_read_config_word(dev, 0x44, &reg44);
-	pci_read_config_word(dev, 0x48, &reg48);
-	pci_read_config_word(dev, 0x4a, &reg4a);
-
-	if (speed >= XFER_UDMA_0) {
-		u_speed = (speed - XFER_UDMA_0) << (drive->dn * 4);
-
-		if (!(reg48 & u_flag))
-			pci_write_config_word(dev, 0x48, reg48|u_flag);
-		if ((reg4a & a_speed) != u_speed) {
-			pci_write_config_word(dev, 0x4a, reg4a & ~a_speed);
-			pci_read_config_word(dev, 0x4a, &reg4a);
-			pci_write_config_word(dev, 0x4a, reg4a|u_speed);
-		}
-	} else {
-		const u8 mwdma_to_pio[] = { 0, 3, 4 };
-
-		if (reg48 & u_flag)
-			pci_write_config_word(dev, 0x48, reg48 & ~u_flag);
-		if (reg4a & a_speed)
-			pci_write_config_word(dev, 0x4a, reg4a & ~a_speed);
-
-		if (speed >= XFER_MW_DMA_0)
-			drive->pio_mode =
-				mwdma_to_pio[speed - XFER_MW_DMA_0] + XFER_PIO_0;
-		else
-			drive->pio_mode = XFER_PIO_2; /* for SWDMA2 */
-
-		slc90e66_set_pio_mode(hwif, drive);
-	}
-}
-
-static int slc90e66_cable_detect(ide_hwif_t *hwif)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	u8 reg47 = 0, mask = hwif->channel ? 0x01 : 0x02;
-
-	pci_read_config_byte(dev, 0x47, &reg47);
-
-	/* bit[0(1)]: 0:80, 1:40 */
-	return (reg47 & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
-}
+#include <linux/ide2libata.h>
+#include "../ata/pata_efar.h"
 
 static const struct ide_port_ops slc90e66_port_ops = {
-	.set_pio_mode		= slc90e66_set_pio_mode,
-	.set_dma_mode		= slc90e66_set_dma_mode,
-	.cable_detect		= slc90e66_cable_detect,
+	.set_pio_mode		= efar_set_piomode,
+	.set_dma_mode		= efar_set_dmamode,
+	.cable_detect		= efar_cable_detect,
 };
 
 static const struct ide_port_info slc90e66_chipset __devinitdata = {
