Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbXHSS6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbXHSS6X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 14:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbXHSS6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 14:58:13 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:21877 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750991AbXHSS6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 14:58:11 -0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
To: bzolnier@gmail.com, rah@bash.sh
Subject: [PATCH 2/4] hpt366: UltraDMA filter for SATA cards (take 2)
Date: Sun, 19 Aug 2007 23:00:35 +0400
User-Agent: KMail/1.5
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708192300.35564.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Marvell bridge chips used on HighPoint SATA cards do not seem to support
the UltraDMA modes 1, 2, and 3 as well as any MWDMA modes, so the driver needs
to account for this in the udma_filter() method.  In order to achieve that, do
the following changes:

- install the method for all chips, not only HPT36x/370 and impove the code
  formatting by killing the extra tabs while at it;

- add to the end of the 'switch' statement in the method cases for HPT372[AN]
  and HPT374 chips upon which the known SATA cards are based;

- use hwif->ultra_mask as a default mask for the ide_dma_filter() method to
  behave correctly;

- move the HPT370[A] cases below the HPT36x case for consistency.

While at it, replace the explicit UltraDMA mode masks with ATA_UDMA* constants
all over the driver...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
This is against the current Linus tree and unfortunately I was able to only
compile test it since that tree gives MODPOST warning and dies early on bootup.
Will hopefully finish with the patch series next weekend...

 drivers/ide/pci/hpt366.c |   96 +++++++++++++++++++++++------------------------
 1 files changed, 49 insertions(+), 47 deletions(-)

Index: linux-2.6/drivers/ide/pci/hpt366.c
===================================================================
--- linux-2.6.orig/drivers/ide/pci/hpt366.c
+++ linux-2.6/drivers/ide/pci/hpt366.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.11	Aug 11, 2007
+ * linux/drivers/ide/pci/hpt366.c		Version 1.12	Aug 19, 2007
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
@@ -114,6 +114,7 @@
  *   unify HPT36x/37x timing setup code and the speedproc handlers by joining
  *   the register setting lists into the table indexed by the clock selected
  * - set the correct hwif->ultra_mask for each individual chip
+ * - add UltraDMA mode filtering for the HPT37[24] based SATA cards
  *	Sergei Shtylyov, <sshtylyov@ru.mvista.com> or <source@mvista.com>
  */
 
@@ -518,42 +519,44 @@ static int check_in_drive_list(ide_drive
 }
 
 /*
- *	Note for the future; the SATA hpt37x we must set
- *	either PIO or UDMA modes 0,4,5
+ * The Marvell bridge chips used on the HighPoint SATA cards do not seem
+ * to support the UltraDMA modes 1, 2, and 3 as well as any MWDMA modes...
  */
 
 static u8 hpt3xx_udma_filter(ide_drive_t *drive)
 {
-	struct hpt_info *info	= pci_get_drvdata(HWIF(drive)->pci_dev);
-	u8 mask;
+	ide_hwif_t *hwif	= HWIF(drive);
+	struct hpt_info *info	= pci_get_drvdata(hwif->pci_dev);
+	u8 mask 		= hwif->ultra_mask;
 
 	switch (info->chip_type) {
-	case HPT370A:
-		if (!HPT370_ALLOW_ATA100_5 ||
-		    check_in_drive_list(drive, bad_ata100_5))
-			return 0x1f;
-		else
-			return 0x3f;
-	case HPT370:
-		if (!HPT370_ALLOW_ATA100_5 ||
-		    check_in_drive_list(drive, bad_ata100_5))
-			mask = 0x1f;
-		else
-			mask = 0x3f;
-		break;
 	case HPT36x:
 		if (!HPT366_ALLOW_ATA66_4 ||
 		    check_in_drive_list(drive, bad_ata66_4))
-			mask = 0x0f;
-		else
-			mask = 0x1f;
+			mask = ATA_UDMA3;
 
 		if (!HPT366_ALLOW_ATA66_3 ||
 		    check_in_drive_list(drive, bad_ata66_3))
-			mask = 0x07;
+			mask = ATA_UDMA2;
 		break;
+	case HPT370:
+		if (!HPT370_ALLOW_ATA100_5 ||
+		    check_in_drive_list(drive, bad_ata100_5))
+			mask = ATA_UDMA4;
+		break;
+	case HPT370A:
+		if (!HPT370_ALLOW_ATA100_5 ||
+		    check_in_drive_list(drive, bad_ata100_5))
+			return ATA_UDMA4;
+	case HPT372 :
+	case HPT372A:
+	case HPT372N:
+	case HPT374 :
+		if (ide_dev_is_sata(drive->id))
+			mask &= ~0x0e;
+		/* Fall thru */
 	default:
-		return 0x7f;
+		return mask;
 	}
 
 	return check_in_drive_list(drive, bad_ata33) ? 0x00 : mask;
@@ -1236,25 +1239,24 @@ static unsigned int __devinit init_chips
 
 static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 {
-	struct pci_dev	*dev		= hwif->pci_dev;
-	struct hpt_info *info		= pci_get_drvdata(dev);
-	int serialize			= HPT_SERIALIZE_IO;
-	u8  scr1 = 0, ata66		= hwif->channel ? 0x01 : 0x02;
-	u8  chip_type			= info->chip_type;
-	u8  new_mcr, old_mcr 		= 0;
+	struct pci_dev	*dev	= hwif->pci_dev;
+	struct hpt_info *info	= pci_get_drvdata(dev);
+	int serialize		= HPT_SERIALIZE_IO;
+	u8  scr1 = 0, ata66	= hwif->channel ? 0x01 : 0x02;
+	u8  chip_type		= info->chip_type;
+	u8  new_mcr, old_mcr	= 0;
 
 	/* Cache the channel's MISC. control registers' offset */
-	hwif->select_data		= hwif->channel ? 0x54 : 0x50;
+	hwif->select_data	= hwif->channel ? 0x54 : 0x50;
 
-	hwif->tuneproc			= &hpt3xx_tune_drive;
-	hwif->speedproc			= &hpt3xx_tune_chipset;
-	hwif->quirkproc			= &hpt3xx_quirkproc;
-	hwif->intrproc			= &hpt3xx_intrproc;
-	hwif->maskproc			= &hpt3xx_maskproc;
-	hwif->busproc			= &hpt3xx_busproc;
+	hwif->tuneproc		= &hpt3xx_tune_drive;
+	hwif->speedproc		= &hpt3xx_tune_chipset;
+	hwif->quirkproc		= &hpt3xx_quirkproc;
+	hwif->intrproc		= &hpt3xx_intrproc;
+	hwif->maskproc		= &hpt3xx_maskproc;
+	hwif->busproc		= &hpt3xx_busproc;
 
-	if (chip_type <= HPT370A)
-		hwif->udma_filter	= &hpt3xx_udma_filter;
+	hwif->udma_filter	= &hpt3xx_udma_filter;
 
 	/*
 	 * HPT3xxN chips have some complications:
@@ -1504,19 +1506,19 @@ static int __devinit init_setup_hpt366(s
 		d->host_flags |= IDE_HFLAG_SINGLE;
 		d->enablebits[0].mask = d->enablebits[0].val = 0x10;
 
-		d->udma_mask = HPT366_ALLOW_ATA66_3 ?
-			      (HPT366_ALLOW_ATA66_4 ? 0x1f : 0x0f) : 0x07;
+		d->udma_mask = HPT366_ALLOW_ATA66_3 ? (HPT366_ALLOW_ATA66_4 ?
+			       ATA_UDMA4 : ATA_UDMA3) : ATA_UDMA2;
 		break;
 	case 3:
 	case 4:
-		d->udma_mask = HPT370_ALLOW_ATA100_5 ? 0x3f : 0x1f;
+		d->udma_mask = HPT370_ALLOW_ATA100_5 ? ATA_UDMA5 : ATA_UDMA4;
 		break;
 	default:
 		rev = 6;
 		/* fall thru */
 	case 5:
 	case 6:
-		d->udma_mask = HPT372_ALLOW_ATA133_6 ? 0x7f : 0x3f;
+		d->udma_mask = HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5;
 		break;
 	}
 
@@ -1577,7 +1579,7 @@ static ide_pci_device_t hpt366_chipsets[
 		.init_dma	= init_dma_hpt366,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.udma_mask	= HPT372_ALLOW_ATA133_6 ? 0x7f : 0x3f,
+		.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
 		.bootable	= OFF_BOARD,
 		.extra		= 240,
 		.pio_mask	= ATA_PIO4,
@@ -1589,7 +1591,7 @@ static ide_pci_device_t hpt366_chipsets[
 		.init_dma	= init_dma_hpt366,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.udma_mask	= HPT302_ALLOW_ATA133_6 ? 0x7f : 0x3f,
+		.udma_mask	= HPT302_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
 		.bootable	= OFF_BOARD,
 		.extra		= 240,
 		.pio_mask	= ATA_PIO4,
@@ -1601,7 +1603,7 @@ static ide_pci_device_t hpt366_chipsets[
 		.init_dma	= init_dma_hpt366,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.udma_mask	= HPT371_ALLOW_ATA133_6 ? 0x7f : 0x3f,
+		.udma_mask	= HPT371_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
 		.bootable	= OFF_BOARD,
 		.extra		= 240,
 		.pio_mask	= ATA_PIO4,
@@ -1613,7 +1615,7 @@ static ide_pci_device_t hpt366_chipsets[
 		.init_dma	= init_dma_hpt366,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.udma_mask	= 0x3f,
+		.udma_mask	= ATA_UDMA5,
 		.bootable	= OFF_BOARD,
 		.extra		= 240,
 		.pio_mask	= ATA_PIO4,
@@ -1625,7 +1627,7 @@ static ide_pci_device_t hpt366_chipsets[
 		.init_dma	= init_dma_hpt366,
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x50,0x04,0x04}, {0x54,0x04,0x04}},
-		.udma_mask	= HPT372_ALLOW_ATA133_6 ? 0x7f : 0x3f,
+		.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
 		.bootable	= OFF_BOARD,
 		.extra		= 240,
 		.pio_mask	= ATA_PIO4,

