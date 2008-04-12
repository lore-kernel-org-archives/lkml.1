Return-Path: <linux-kernel-owner+w=401wt.eu-S1758081AbYDLSxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbYDLSxU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 14:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbYDLSvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 14:51:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:18134 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043AbYDLSvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 14:51:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=OZH8+3EBISNYltY8iZdQFiNdYaE1GI1Cz95NrFduXEwfkGoV3PETAZXw81Tv6IGUl2cE3aWmjOe3v9QPwaus+VPq7nov+JsGZgkpcXaZyPxzUMEJ5Di+qQUGWaRPl5k5VAPqJ6hd/1E+nby19U2SoaSBlG6wUpbnrfwtzB+Nc+k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 5/5] ide: remove ->dma_prdtable field from ide_hwif_t
Date: Sat, 12 Apr 2008 21:05:42 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804122105.42636.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Use 'hwif->dma_base + {4,8}' instead of hwif->dma_prdtable in
  {ide,scc}_dma_setup().

* Remove no longer needed ->dma_prdtable field from ide_hwif_t.

While at it:

* Use ATA_DMA_TABLE_OFS define.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c      |    7 +++----
 drivers/ide/pci/scc_pata.c |    3 +--
 include/linux/ide.h        |    1 -
 3 files changed, 4 insertions(+), 7 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -464,9 +464,10 @@ int ide_dma_setup(ide_drive_t *drive)
 
 	/* PRD table */
 	if (hwif->mmio)
-		writel(hwif->dmatable_dma, (void __iomem *)hwif->dma_prdtable);
+		writel(hwif->dmatable_dma,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_TABLE_OFS));
 	else
-		outl(hwif->dmatable_dma, hwif->dma_prdtable);
+		outl(hwif->dmatable_dma, hwif->dma_base + ATA_DMA_TABLE_OFS);
 
 	/* specify r/w */
 	hwif->OUTB(reading, hwif->dma_command);
@@ -860,8 +861,6 @@ void ide_setup_dma(ide_hwif_t *hwif, uns
 		hwif->dma_command	= hwif->dma_base + 0;
 	if (!hwif->dma_status)
 		hwif->dma_status	= hwif->dma_base + 2;
-	if (!hwif->dma_prdtable)
-		hwif->dma_prdtable	= hwif->dma_base + 4;
 
 	hwif->dma_ops = &sff_dma_ops;
 }
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -304,7 +304,7 @@ static int scc_dma_setup(ide_drive_t *dr
 	}
 
 	/* PRD table */
-	out_be32((void __iomem *)hwif->dma_prdtable, hwif->dmatable_dma);
+	out_be32((void __iomem *)(hwif->dma_base + 8), hwif->dmatable_dma);
 
 	/* specify r/w */
 	out_be32((void __iomem *)hwif->dma_command, reading);
@@ -804,7 +804,6 @@ static void __devinit init_hwif_scc(ide_
 
 	hwif->dma_command = hwif->dma_base;
 	hwif->dma_status = hwif->dma_base + 0x04;
-	hwif->dma_prdtable = hwif->dma_base + 0x08;
 
 	/* PTERADD */
 	out_be32((void __iomem *)(hwif->dma_base + 0x018), hwif->dmatable_dma);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -511,7 +511,6 @@ typedef struct hwif_s {
 	unsigned long	dma_base;	/* base addr for dma ports */
 	unsigned long	dma_command;	/* dma command register */
 	unsigned long	dma_status;	/* dma status register */
-	unsigned long	dma_prdtable;	/* actual prd table address */
 
 	unsigned long	config_data;	/* for use by chipset-specific code */
 	unsigned long	select_data;	/* for use by chipset-specific code */
