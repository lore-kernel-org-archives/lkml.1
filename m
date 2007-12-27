Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbXL0TCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbXL0TCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 14:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbXL0TBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 14:01:31 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:6066 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbXL0TB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 14:01:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=l6KGukfv0kaGH2MO5aVHl7cBipxujXqiMQDxMcS7t1i482PBF/nVA0vqjBJIzRCO8cJ6YctIcle0AmdDn+pExcHZ27aAklzfZdTrc2g2klZ1vID0Za66E5p4rj3DB/pRQMbEPwTzjkbr39XUug3DVyiEJJfPiAoyqAIHpCtfj5Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org, bzolnier@gmail.com
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 27 Dec 2007 20:12:23 +0100
Message-Id: <20071227191223.1357.78845.sendpatchset@localhost.localdomain>
In-Reply-To: <20071227191153.1357.63211.sendpatchset@localhost.localdomain>
References: <20071227191153.1357.63211.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/9] ide: use ide_destroy_dmatable() instead of pci_unmap_sg()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ide_destroy_dmatable() in:
* ide-dma.c::ide_build_dmatable()
* sgiioc4.c::sgiioc4_build_dma_table()
* pmac.c::pmac_ide_{build,destroy}_dmatable()

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c     |    8 ++++----
 drivers/ide/pci/sgiioc4.c |    3 +--
 drivers/ide/ppc/pmac.c    |   14 +++++---------
 3 files changed, 10 insertions(+), 15 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -282,12 +282,12 @@ int ide_build_dmatable (ide_drive_t *dri
 			*--table |= cpu_to_le32(0x80000000);
 		return count;
 	}
+
 	printk(KERN_ERR "%s: empty DMA table?\n", drive->name);
+
 use_pio_instead:
-	pci_unmap_sg(hwif->pci_dev,
-		     hwif->sg_table,
-		     hwif->sg_nents,
-		     hwif->sg_dma_direction);
+	ide_destroy_dmatable(drive);
+
 	return 0; /* revert to PIO for this request */
 }
 
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -517,8 +517,7 @@ sgiioc4_build_dma_table(ide_drive_t * dr
 	}
 
 use_pio_instead:
-	pci_unmap_sg(hwif->pci_dev, hwif->sg_table, hwif->sg_nents,
-		     hwif->sg_dma_direction);
+	ide_destroy_dmatable(drive);
 
 	return 0;		/* revert to PIO for this request */
 }
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1535,11 +1535,10 @@ pmac_ide_build_dmatable(ide_drive_t *dri
 	}
 
 	printk(KERN_DEBUG "%s: empty DMA table?\n", drive->name);
- use_pio_instead:
-	pci_unmap_sg(hwif->pci_dev,
-		     hwif->sg_table,
-		     hwif->sg_nents,
-		     hwif->sg_dma_direction);
+
+use_pio_instead:
+	ide_destroy_dmatable(drive);
+
 	return 0; /* revert to PIO for this request */
 }
 
@@ -1548,12 +1547,9 @@ static void
 pmac_ide_destroy_dmatable (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct pci_dev *dev = HWIF(drive)->pci_dev;
-	struct scatterlist *sg = hwif->sg_table;
-	int nents = hwif->sg_nents;
 
 	if (nents) {
-		pci_unmap_sg(dev, sg, nents, hwif->sg_dma_direction);
+		ide_destroy_dmatable(drive);
 		hwif->sg_nents = 0;
 	}
 }
