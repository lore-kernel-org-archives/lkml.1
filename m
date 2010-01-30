Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607Ab0A3TuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab0A3TuU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 14:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554Ab0A3TuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 14:50:16 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:50554 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab0A3TuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 14:50:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ewDpv0kGESxbqASiPOxWvk3R2b8Nu+GaN/agqky6l2VD48EvvBTzCWRtoeS50tB8Rv
         CrgpWLD3YfOo1U+PWiO9/n741X/Ox1MYnvLoXnaxI8u4GJfToyifDpnwpRZHlecJddaO
         0joIb9lLxGOPfKESjuJn3kUlOQ1+BEONAjd10=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 30 Jan 2010 20:50:04 +0100
Message-Id: <20100130195004.30779.89524.sendpatchset@localhost>
In-Reply-To: <20100130194918.30779.25485.sendpatchset@localhost>
References: <20100130194918.30779.25485.sendpatchset@localhost>
Subject: [PATCH 7/9] cs5536: convert to ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cs5536: convert to ide2libata

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cs5536.h |   22 +++++
 drivers/ide/cs5536.c      |  189 +---------------------------------------------
 2 files changed, 26 insertions(+), 185 deletions(-)

Index: b/drivers/ata/pata_cs5536.h
===================================================================
--- a/drivers/ata/pata_cs5536.h
+++ b/drivers/ata/pata_cs5536.h
@@ -64,7 +64,11 @@ static int cs5536_write(struct pci_dev *
 
 static void cs5536_program_dtc(struct ata_device *adev, u8 tim)
 {
+#ifndef __IDE2LIBATA
 	struct pci_dev *pdev = to_pci_dev(adev->link->ap->host->dev);
+#else
+	struct pci_dev *pdev = to_pci_dev(adev->hwif->dev);
+#endif
 	int dshift = adev->devno ? IDE_D1_SHIFT : IDE_D0_SHIFT;
 	u32 dtc;
 
@@ -121,11 +125,19 @@ static void cs5536_set_piomode(struct at
 	int mode = adev->pio_mode - XFER_PIO_0;
 	int cmdmode = mode;
 	int cshift = adev->devno ? IDE_CAST_D1_SHIFT : IDE_CAST_D0_SHIFT;
+#ifdef __IDE2LIBATA
+	unsigned long timings = (unsigned long)ide_get_drivedata(adev);
+#endif
 	u32 cast;
 
 	if (pair)
 		cmdmode = min(mode, pair->pio_mode - XFER_PIO_0);
 
+#ifdef __IDE2LIBATA
+	timings &= (IDE_DRV_MASK << 8);
+	timings |= drv_timings[mode];
+	ide_set_drivedata(adev, (void *)timings);
+#endif
 	cs5536_program_dtc(adev, drv_timings[mode]);
 
 	cs5536_read(pdev, CAST, &cast);
@@ -160,7 +172,9 @@ static void cs5536_set_dmamode(struct at
 	u32 etc;
 	int mode = adev->dma_mode;
 	int dshift = adev->devno ? IDE_D1_SHIFT : IDE_D0_SHIFT;
-
+#ifdef __IDE2LIBATA
+	unsigned long timings = (unsigned long)ide_get_drivedata(adev);
+#endif
 	cs5536_read(pdev, ETC, &etc);
 
 	if (mode >= XFER_UDMA_0) {
@@ -168,7 +182,13 @@ static void cs5536_set_dmamode(struct at
 		etc |= udma_timings[mode - XFER_UDMA_0] << dshift;
 	} else { /* MWDMA */
 		etc &= ~(IDE_ETC_UDMA_MASK << dshift);
+#ifndef __IDE2LIBATA
 		cs5536_program_dtc(adev, mwdma_timings[mode - XFER_MW_DMA_0]);
+#else
+		timings &= IDE_DRV_MASK;
+		timings |= mwdma_timings[mode - XFER_MW_DMA_0] << 8;
+		ide_set_drivedata(adev, (void *)timings);
+#endif
 	}
 
 	cs5536_write(pdev, ETC, etc);
Index: b/drivers/ide/cs5536.c
===================================================================
--- a/drivers/ide/cs5536.c
+++ b/drivers/ide/cs5536.c
@@ -1,7 +1,7 @@
 /*
  * CS5536 PATA support
  * (C) 2007 Martin K. Petersen <mkp@mkp.net>
- * (C) 2009 Bartlomiej Zolnierkiewicz
+ * (C) 2009-2010 Bartlomiej Zolnierkiewicz
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -15,19 +15,6 @@
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- * Documentation:
- *	Available from AMD web site.
- *
- * The IDE timing registers for the CS5536 live in the Geode Machine
- * Specific Register file and not PCI config space.  Most BIOSes
- * virtualize the PCI registers so the chip looks like a standard IDE
- * controller.  Unfortunately not all implementations get this right.
- * In particular some have problems with unaligned accesses to the
- * virtualized PCI registers.  This driver always does full dword
- * writes to work around the issue.  Also, in case of a bad BIOS this
- * driver can be loaded with the "msr=1" parameter which forces using
- * the Machine Specific Registers to configure the device.
  */
 
 #include <linux/kernel.h>
@@ -39,174 +26,8 @@
 
 #define DRV_NAME	"cs5536"
 
-enum {
-	MSR_IDE_CFG		= 0x51300010,
-	PCI_IDE_CFG		= 0x40,
-
-	CFG			= 0,
-	DTC			= 2,
-	CAST			= 3,
-	ETC			= 4,
-
-	IDE_CFG_CHANEN		= (1 << 1),
-	IDE_CFG_CABLE		= (1 << 17) | (1 << 16),
-
-	IDE_D0_SHIFT		= 24,
-	IDE_D1_SHIFT		= 16,
-	IDE_DRV_MASK		= 0xff,
-
-	IDE_CAST_D0_SHIFT	= 6,
-	IDE_CAST_D1_SHIFT	= 4,
-	IDE_CAST_DRV_MASK	= 0x3,
-
-	IDE_CAST_CMD_SHIFT	= 24,
-	IDE_CAST_CMD_MASK	= 0xff,
-
-	IDE_ETC_UDMA_MASK	= 0xc0,
-};
-
-static int use_msr;
-
-static int cs5536_read(struct pci_dev *pdev, int reg, u32 *val)
-{
-	if (unlikely(use_msr)) {
-		u32 dummy;
-
-		rdmsr(MSR_IDE_CFG + reg, *val, dummy);
-		return 0;
-	}
-
-	return pci_read_config_dword(pdev, PCI_IDE_CFG + reg * 4, val);
-}
-
-static int cs5536_write(struct pci_dev *pdev, int reg, int val)
-{
-	if (unlikely(use_msr)) {
-		wrmsr(MSR_IDE_CFG + reg, val, 0);
-		return 0;
-	}
-
-	return pci_write_config_dword(pdev, PCI_IDE_CFG + reg * 4, val);
-}
-
-static void cs5536_program_dtc(ide_drive_t *drive, u8 tim)
-{
-	struct pci_dev *pdev = to_pci_dev(drive->hwif->dev);
-	int dshift = (drive->dn & 1) ? IDE_D1_SHIFT : IDE_D0_SHIFT;
-	u32 dtc;
-
-	cs5536_read(pdev, DTC, &dtc);
-	dtc &= ~(IDE_DRV_MASK << dshift);
-	dtc |= tim << dshift;
-	cs5536_write(pdev, DTC, dtc);
-}
-
-/**
- *	cs5536_cable_detect	-	detect cable type
- *	@hwif: Port to detect on
- *
- *	Perform cable detection for ATA66 capable cable.
- *
- *	Returns a cable type.
- */
-
-static int cs5536_cable_detect(ide_hwif_t *hwif)
-{
-	struct pci_dev *pdev = to_pci_dev(hwif->dev);
-	u32 cfg;
-
-	cs5536_read(pdev, CFG, &cfg);
-
-	if (cfg & IDE_CFG_CABLE)
-		return ATA_CBL_PATA80;
-	else
-		return ATA_CBL_PATA40;
-}
-
-/**
- *	cs5536_set_pio_mode		-	PIO timing setup
- *	@hwif: ATA port
- *	@drive: ATA device
- */
-
-static void cs5536_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	static const u8 drv_timings[5] = {
-		0x98, 0x55, 0x32, 0x21, 0x20,
-	};
-
-	static const u8 addr_timings[5] = {
-		0x2, 0x1, 0x0, 0x0, 0x0,
-	};
-
-	static const u8 cmd_timings[5] = {
-		0x99, 0x92, 0x90, 0x22, 0x20,
-	};
-
-	struct pci_dev *pdev = to_pci_dev(hwif->dev);
-	ide_drive_t *pair = ide_get_pair_dev(drive);
-	int cshift = (drive->dn & 1) ? IDE_CAST_D1_SHIFT : IDE_CAST_D0_SHIFT;
-	unsigned long timings = (unsigned long)ide_get_drivedata(drive);
-	u32 cast;
-	const u8 pio = drive->pio_mode - XFER_PIO_0;
-	u8 cmd_pio = pio;
-
-	if (pair)
-		cmd_pio = min_t(u8, pio, pair->pio_mode - XFER_PIO_0);
-
-	timings &= (IDE_DRV_MASK << 8);
-	timings |= drv_timings[pio];
-	ide_set_drivedata(drive, (void *)timings);
-
-	cs5536_program_dtc(drive, drv_timings[pio]);
-
-	cs5536_read(pdev, CAST, &cast);
-
-	cast &= ~(IDE_CAST_DRV_MASK << cshift);
-	cast |= addr_timings[pio] << cshift;
-
-	cast &= ~(IDE_CAST_CMD_MASK << IDE_CAST_CMD_SHIFT);
-	cast |= cmd_timings[cmd_pio] << IDE_CAST_CMD_SHIFT;
-
-	cs5536_write(pdev, CAST, cast);
-}
-
-/**
- *	cs5536_set_dma_mode		-	DMA timing setup
- *	@hwif: ATA port
- *	@drive: ATA device
- */
-
-static void cs5536_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	static const u8 udma_timings[6] = {
-		0xc2, 0xc1, 0xc0, 0xc4, 0xc5, 0xc6,
-	};
-
-	static const u8 mwdma_timings[3] = {
-		0x67, 0x21, 0x20,
-	};
-
-	struct pci_dev *pdev = to_pci_dev(hwif->dev);
-	int dshift = (drive->dn & 1) ? IDE_D1_SHIFT : IDE_D0_SHIFT;
-	unsigned long timings = (unsigned long)ide_get_drivedata(drive);
-	u32 etc;
-	const u8 mode = drive->dma_mode;
-
-	cs5536_read(pdev, ETC, &etc);
-
-	if (mode >= XFER_UDMA_0) {
-		etc &= ~(IDE_DRV_MASK << dshift);
-		etc |= udma_timings[mode - XFER_UDMA_0] << dshift;
-	} else { /* MWDMA */
-		etc &= ~(IDE_ETC_UDMA_MASK << dshift);
-		timings &= IDE_DRV_MASK;
-		timings |= mwdma_timings[mode - XFER_MW_DMA_0] << 8;
-		ide_set_drivedata(drive, (void *)timings);
-	}
-
-	cs5536_write(pdev, ETC, etc);
-}
+#include <linux/ide2libata.h>
+#include "../ata/pata_cs5536.h"
 
 static void cs5536_dma_start(ide_drive_t *drive)
 {
@@ -232,8 +53,8 @@ static int cs5536_dma_end(ide_drive_t *d
 }
 
 static const struct ide_port_ops cs5536_port_ops = {
-	.set_pio_mode		= cs5536_set_pio_mode,
-	.set_dma_mode		= cs5536_set_dma_mode,
+	.set_pio_mode		= cs5536_set_piomode,
+	.set_dma_mode		= cs5536_set_dmamode,
 	.cable_detect		= cs5536_cable_detect,
 };
 
