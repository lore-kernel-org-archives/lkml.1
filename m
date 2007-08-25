Return-Path: <linux-kernel-owner+w=401wt.eu-S934447AbXHYTNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934447AbXHYTNE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 15:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764422AbXHYTMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 15:12:53 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:8040 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759762AbXHYTMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 15:12:52 -0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
To: bzolnier@gmail.com
Subject: [PATCH 2/4] hpt366: UltraDMA filter for SATA cards (take 2)
Date: Sat, 25 Aug 2007 23:15:30 +0400
User-Agent: KMail/1.5
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708252315.30189.sshtylyov@ru.mvista.com>
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

- move the HPT370[A] cases below the HPT36x case for consistency...

---
This version doesn't use explicit UltraDMA masks, so converting them to the
ATA_UDMA* is left for another, global patch.  This patch against the current
Linus' tree and unfortunately I was able to only compile test it since that
tree gives MODPOST warning and dies early on bootup.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

 drivers/ide/pci/hpt366.c |   78 ++++++++++++++++++++++++-----------------------
 1 files changed, 40 insertions(+), 38 deletions(-)

Index: linux-2.6/drivers/ide/pci/hpt366.c
===================================================================
--- linux-2.6.orig/drivers/ide/pci/hpt366.c
+++ linux-2.6/drivers/ide/pci/hpt366.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.11	Aug 11, 2007
+ * linux/drivers/ide/pci/hpt366.c		Version 1.12	Aug 25, 2007
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
 
@@ -524,36 +525,38 @@ static int check_in_drive_list(ide_drive
 
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
-		if (!HPT366_ALLOW_ATA66_4 ||
+		if (HPT366_ALLOW_ATA66_4 &&
 		    check_in_drive_list(drive, bad_ata66_4))
-			mask = 0x0f;
-		else
-			mask = 0x1f;
+			mask = ~0x10;
 
-		if (!HPT366_ALLOW_ATA66_3 ||
+		if (HPT366_ALLOW_ATA66_3 &&
 		    check_in_drive_list(drive, bad_ata66_3))
-			mask = 0x07;
+			mask = ~0x08;
 		break;
+	case HPT370 :
+	case HPT370A:
+		if (HPT370_ALLOW_ATA100_5 &&
+		    check_in_drive_list(drive, bad_ata100_5))
+			mask = ~0x20;
+
+		if (info->chip_type == HPT370A)
+			return mask;
+		break;
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

