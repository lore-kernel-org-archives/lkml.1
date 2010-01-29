Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833Ab0A2QJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab0A2QJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755738Ab0A2QJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:09:38 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab0A2QJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:09:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=fKB9SnNAQEAO8MTnQc0guDXGFffkmTNJOx1VSFPn7X1JaS4/+GINDgcYsejy9DRAmQ
         RThj2odrwErHRt5t/cZ0n+2kaHc5jpz9Gi4Fd4gLFGkqBX24wLROo4BUl+0HxMP7D19S
         E+2rjTSamEFPIHnmf+Sw5G7Q4Vd2iiWW37tF8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:09:28 +0100
Message-Id: <20100129160928.21495.87738.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 59/68] sc1200: convert to ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] sc1200: convert to ide2libata

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/sc1200.c |  113 +--------------------------------------------------
 1 file changed, 4 insertions(+), 109 deletions(-)

Index: b/drivers/ide/sc1200.c
===================================================================
--- a/drivers/ide/sc1200.c
+++ b/drivers/ide/sc1200.c
@@ -23,73 +23,8 @@
 
 #define DRV_NAME "sc1200"
 
-#define SC1200_REV_A	0x00
-#define SC1200_REV_B1	0x01
-#define SC1200_REV_B3	0x02
-#define SC1200_REV_C1	0x03
-#define SC1200_REV_D1	0x04
-
-#define PCI_CLK_33	0x00
-#define PCI_CLK_48	0x01
-#define PCI_CLK_66	0x02
-#define PCI_CLK_33A	0x03
-
-static unsigned short sc1200_get_pci_clock (void)
-{
-	unsigned char chip_id, silicon_revision;
-	unsigned int pci_clock;
-	/*
-	 * Check the silicon revision, as not all versions of the chip
-	 * have the register with the fast PCI bus timings.
-	 */
-	chip_id = inb (0x903c);
-	silicon_revision = inb (0x903d);
-
-	// Read the fast pci clock frequency
-	if (chip_id == 0x04 && silicon_revision < SC1200_REV_B1) {
-		pci_clock = PCI_CLK_33;
-	} else {
-		// check clock generator configuration (cfcc)
-		// the clock is in bits 8 and 9 of this word
-
-		pci_clock = inw (0x901e);
-		pci_clock >>= 8;
-		pci_clock &= 0x03;
-		if (pci_clock == PCI_CLK_33A)
-			pci_clock = PCI_CLK_33;
-	}
-	return pci_clock;
-}
-
-/*
- * Here are the standard PIO mode 0-4 timings for each "format".
- * Format-0 uses fast data reg timings, with slower command reg timings.
- * Format-1 uses fast timings for all registers, but won't work with all drives.
- */
-static const unsigned int sc1200_pio_timings[4][5] =
-	{{0x00009172, 0x00012171, 0x00020080, 0x00032010, 0x00040010},	// format0  33Mhz
-	 {0xd1329172, 0x71212171, 0x30200080, 0x20102010, 0x00100010},	// format1, 33Mhz
-	 {0xfaa3f4f3, 0xc23232b2, 0x513101c1, 0x31213121, 0x10211021},	// format1, 48Mhz
-	 {0xfff4fff4, 0xf35353d3, 0x814102f1, 0x42314231, 0x11311131}};	// format1, 66Mhz
-
-/*
- * After chip reset, the PIO timings are set to 0x00009172, which is not valid.
- */
-//#define SC1200_BAD_PIO(timings) (((timings)&~0x80000000)==0x00009172)
-
-static void sc1200_tunepio(ide_drive_t *drive, u8 pio)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct pci_dev *pdev = to_pci_dev(hwif->dev);
-	unsigned int basereg = hwif->channel ? 0x50 : 0x40, format = 0;
-
-	pci_read_config_dword(pdev, basereg + 4, &format);
-	format = (format >> 31) & 1;
-	if (format)
-		format += sc1200_get_pci_clock();
-	pci_write_config_dword(pdev, basereg + ((drive->dn & 1) << 3),
-			       sc1200_pio_timings[format][pio]);
-}
+#include <linux/ide2libata.h>
+#include "../ata/pata_sc1200.h"
 
 /*
  *	The SC1200 specifies that two drives sharing a cable cannot mix
@@ -122,46 +57,6 @@ out:
 	return mask;
 }
 
-static void sc1200_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	struct pci_dev		*dev = to_pci_dev(hwif->dev);
-	unsigned int		reg, timings;
-	unsigned short		pci_clock;
-	unsigned int		basereg = hwif->channel ? 0x50 : 0x40;
-	const u8		mode = drive->dma_mode;
-
-	static const u32 udma_timing[3][3] = {
-		{ 0x00921250, 0x00911140, 0x00911030 },
-		{ 0x00932470, 0x00922260, 0x00922140 },
-		{ 0x009436a1, 0x00933481, 0x00923261 },
-	};
-
-	static const u32 mwdma_timing[3][3] = {
-		{ 0x00077771, 0x00012121, 0x00002020 },
-		{ 0x000bbbb2, 0x00024241, 0x00013131 },
-		{ 0x000ffff3, 0x00035352, 0x00015151 },
-	};
-
-	pci_clock = sc1200_get_pci_clock();
-
-	/*
-	 * Note that each DMA mode has several timings associated with it.
-	 * The correct timing depends on the fast PCI clock freq.
-	 */
-
-	if (mode >= XFER_UDMA_0)
-		timings =  udma_timing[pci_clock][mode - XFER_UDMA_0];
-	else
-		timings = mwdma_timing[pci_clock][mode - XFER_MW_DMA_0];
-
-	if ((drive->dn & 1) == 0) {
-		pci_read_config_dword(dev, basereg + 4, &reg);
-		timings |= reg & 0x80000000;	/* preserve PIO format bit */
-		pci_write_config_dword(dev, basereg + 4, timings);
-	} else
-		pci_write_config_dword(dev, basereg + 12, timings);
-}
-
 /*  Replacement for the standard ide_dma_end action in
  *  dma_proc.
  *
@@ -218,7 +113,7 @@ static void sc1200_set_pio_mode(ide_hwif
 		return;
 	}
 
-	sc1200_tunepio(drive, pio);
+	sc1200_set_piomode(hwif, drive);
 }
 
 #ifdef CONFIG_PM
@@ -275,7 +170,7 @@ static int sc1200_resume (struct pci_dev
 
 static const struct ide_port_ops sc1200_port_ops = {
 	.set_pio_mode		= sc1200_set_pio_mode,
-	.set_dma_mode		= sc1200_set_dma_mode,
+	.set_dma_mode		= sc1200_set_dmamode,
 	.udma_filter		= sc1200_udma_filter,
 };
 
