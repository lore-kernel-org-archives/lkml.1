Return-Path: <linux-kernel-owner+w=401wt.eu-S1756131Ab0A2QOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab0A2QOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577Ab0A2QIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:08:23 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab0A2QIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:08:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=n7vAT1rg2ryjNUBn84xa8s3sLvKXgEX6gZi0RFOXiLpwJrYDNWPG89OSgcKKLPEFfj
         CD3kSzm/Ael7ngiD+PpQun5n/1HwDmixj/kFEyqZD/ojKRNitErz+LjhLpBdN70zi/Bn
         Sfh6MQsEq/833UPCbFT69pyObYJR+IDRZF7dw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:08:10 +0100
Message-Id: <20100129160810.21495.19266.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 47/68] cs5535: convert to ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cs5535: convert to ide2libata

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cs5535.c |  141 +--------------------------------------------------
 1 file changed, 4 insertions(+), 137 deletions(-)

Index: b/drivers/ide/cs5535.c
===================================================================
--- a/drivers/ide/cs5535.c
+++ b/drivers/ide/cs5535.c
@@ -28,145 +28,12 @@
 
 #define DRV_NAME "cs5535"
 
-#define MSR_ATAC_BASE		0x51300000
-#define ATAC_GLD_MSR_CAP	(MSR_ATAC_BASE+0)
-#define ATAC_GLD_MSR_CONFIG	(MSR_ATAC_BASE+0x01)
-#define ATAC_GLD_MSR_SMI	(MSR_ATAC_BASE+0x02)
-#define ATAC_GLD_MSR_ERROR	(MSR_ATAC_BASE+0x03)
-#define ATAC_GLD_MSR_PM		(MSR_ATAC_BASE+0x04)
-#define ATAC_GLD_MSR_DIAG	(MSR_ATAC_BASE+0x05)
-#define ATAC_IO_BAR		(MSR_ATAC_BASE+0x08)
-#define ATAC_RESET		(MSR_ATAC_BASE+0x10)
-#define ATAC_CH0D0_PIO		(MSR_ATAC_BASE+0x20)
-#define ATAC_CH0D0_DMA		(MSR_ATAC_BASE+0x21)
-#define ATAC_CH0D1_PIO		(MSR_ATAC_BASE+0x22)
-#define ATAC_CH0D1_DMA		(MSR_ATAC_BASE+0x23)
-#define ATAC_PCI_ABRTERR	(MSR_ATAC_BASE+0x24)
-#define ATAC_BM0_CMD_PRIM	0x00
-#define ATAC_BM0_STS_PRIM	0x02
-#define ATAC_BM0_PRD		0x04
-#define CS5535_CABLE_DETECT	0x48
-
-/* Format I PIO settings. We separate out cmd and data for safer timings */
-
-static unsigned int cs5535_pio_cmd_timings[5] =
-{ 0xF7F4, 0x53F3, 0x13F1, 0x5131, 0x1131 };
-static unsigned int cs5535_pio_dta_timings[5] =
-{ 0xF7F4, 0xF173, 0x8141, 0x5131, 0x1131 };
-
-static unsigned int cs5535_mwdma_timings[3] =
-{ 0x7F0FFFF3, 0x7F035352, 0x7f024241 };
-
-static unsigned int cs5535_udma_timings[5] =
-{ 0x7F7436A1, 0x7F733481, 0x7F723261, 0x7F713161, 0x7F703061 };
-
-/* Macros to check if the register is the reset value -  reset value is an
-   invalid timing and indicates the register has not been set previously */
-
-#define CS5535_BAD_PIO(timings) ( (timings&~0x80000000UL) == 0x00009172 )
-#define CS5535_BAD_DMA(timings) ( (timings & 0x000FFFFF) == 0x00077771 )
-
-/****
- *	cs5535_set_speed         -     Configure the chipset to the new speed
- *	@drive: Drive to set up
- *	@speed: desired speed
- *
- *	cs5535_set_speed() configures the chipset to a new speed.
- */
-static void cs5535_set_speed(ide_drive_t *drive, const u8 speed)
-{
-	u32 reg = 0, dummy;
-	u8 unit = drive->dn & 1;
-
-	/* Set the PIO timings */
-	if (speed < XFER_SW_DMA_0) {
-		ide_drive_t *pair = ide_get_pair_dev(drive);
-		u8 cmd, pioa;
-
-		cmd = pioa = speed - XFER_PIO_0;
-
-		if (pair) {
-			u8 piob = pair->pio_mode - XFER_PIO_0;
-
-			if (piob < cmd)
-				cmd = piob;
-		}
-
-		/* Write the speed of the current drive */
-		reg = (cs5535_pio_cmd_timings[cmd] << 16) |
-			cs5535_pio_dta_timings[pioa];
-		wrmsr(unit ? ATAC_CH0D1_PIO : ATAC_CH0D0_PIO, reg, 0);
-
-		/* And if nessesary - change the speed of the other drive */
-		rdmsr(unit ?  ATAC_CH0D0_PIO : ATAC_CH0D1_PIO, reg, dummy);
-
-		if (((reg >> 16) & cs5535_pio_cmd_timings[cmd]) !=
-			cs5535_pio_cmd_timings[cmd]) {
-			reg &= 0x0000FFFF;
-			reg |= cs5535_pio_cmd_timings[cmd] << 16;
-			wrmsr(unit ? ATAC_CH0D0_PIO : ATAC_CH0D1_PIO, reg, 0);
-		}
-
-		/* Set bit 31 of the DMA register for PIO format 1 timings */
-		rdmsr(unit ?  ATAC_CH0D1_DMA : ATAC_CH0D0_DMA, reg, dummy);
-		wrmsr(unit ? ATAC_CH0D1_DMA : ATAC_CH0D0_DMA,
-					reg | 0x80000000UL, 0);
-	} else {
-		rdmsr(unit ? ATAC_CH0D1_DMA : ATAC_CH0D0_DMA, reg, dummy);
-
-		reg &= 0x80000000UL;  /* Preserve the PIO format bit */
-
-		if (speed >= XFER_UDMA_0 && speed <= XFER_UDMA_4)
-			reg |= cs5535_udma_timings[speed - XFER_UDMA_0];
-		else if (speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2)
-			reg |= cs5535_mwdma_timings[speed - XFER_MW_DMA_0];
-		else
-			return;
-
-		wrmsr(unit ? ATAC_CH0D1_DMA : ATAC_CH0D0_DMA, reg, 0);
-	}
-}
-
-/**
- *	cs5535_set_dma_mode	-	set host controller for DMA mode
- *	@hwif: port
- *	@drive: drive
- *
- *	Programs the chipset for DMA mode.
- */
-
-static void cs5535_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	cs5535_set_speed(drive, drive->dma_mode);
-}
-
-/**
- *	cs5535_set_pio_mode	-	set host controller for PIO mode
- *	@hwif: port
- *	@drive: drive
- *
- *	A callback from the upper layers for PIO-only tuning.
- */
-
-static void cs5535_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	cs5535_set_speed(drive, drive->pio_mode);
-}
-
-static int cs5535_cable_detect(ide_hwif_t *hwif)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	u8 bit;
-
-	/* if a 80 wire cable was detected */
-	pci_read_config_byte(dev, CS5535_CABLE_DETECT, &bit);
-
-	return (bit & 1) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
-}
+#include <linux/ide2libata.h>
+#include "../ata/pata_cs5535.h"
 
 static const struct ide_port_ops cs5535_port_ops = {
-	.set_pio_mode		= cs5535_set_pio_mode,
-	.set_dma_mode		= cs5535_set_dma_mode,
+	.set_pio_mode		= cs5535_set_piomode,
+	.set_dma_mode		= cs5535_set_dmamode,
 	.cable_detect		= cs5535_cable_detect,
 };
 
