Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbXL0TDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbXL0TDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 14:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbXL0TCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 14:02:01 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:6105 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbXL0TB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 14:01:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=oe34BKHn4wBMnfUXMgs0VA9ZlcAD4/00hlfmM2Wokt0rU3UIe7Tf1iEXFKjT04rJzhQFZKfc4DwdGJ3e8Wzc/CBl1mCvCF+lbrHO5RSsciZjrl8P04TDMI7jS29ZLNvUq7t+b5pk2MP9kA4WyExVwiIlUBIlaOQ5XYj3uV/FqTk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org, bzolnier@gmail.com
Cc: Bryan Wu <bryan.wu@analog.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Date: Thu, 27 Dec 2007 20:12:52 +0100
Message-Id: <20071227191252.1357.76726.sendpatchset@localhost.localdomain>
In-Reply-To: <20071227191153.1357.63211.sendpatchset@localhost.localdomain>
References: <20071227191153.1357.63211.sendpatchset@localhost.localdomain>
Subject: [PATCH 8/9] ide: switch to DMA-mapping API
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* pci_map_sg() -> dma_map_sg() in ide_build_sglist().

* pci_unmap_sg() -> dma_unmap_sg() in ide_destroy_dmatable().

There should be no functionality changes caused by this patch except
for blackfin arch whose dma_[un]map_sg() implementation differs from
pci_[un]map_sg() one (on s390 arch there is no PCI, on avr32 and h8300
archs PCI is currently unsupported, on m32r arch PCI support depends
on BROKEN, on m68k arch PCI support depends on HADES which in turn
depends on BROKEN, on all other archs dma_[un]map_sg() functionality
matches with pci_[un]map_sg() one).

Cc: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
It seems like blackfin arch should be using <asm-generic/pci-dma-compat.h>
in <asm-blackfin/pci.h> or drivers still using PCI DMA-mapping API instead
of the generic one won't work but I'll leave this to blackfin gurus...

[ Bryan, could you please take a look?  Thanks. ]

 drivers/ide/ide-dma.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -85,6 +85,7 @@
 #include <linux/ide.h>
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -175,26 +176,26 @@ static int ide_dma_good_drive(ide_drive_
  *	@drive: the drive to build the DMA table for
  *	@rq: the request holding the sg list
  *
- *	Perform the PCI mapping magic necessary to access the source or
- *	target buffers of a request via PCI DMA. The lower layers of the
+ *	Perform the DMA mapping magic necessary to access the source or
+ *	target buffers of a request via DMA.  The lower layers of the
  *	kernel provide the necessary cache management so that we can
- *	operate in a portable fashion
+ *	operate in a portable fashion.
  */
 
 int ide_build_sglist(ide_drive_t *drive, struct request *rq)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	struct scatterlist *sg = hwif->sg_table;
 
 	ide_map_sg(drive, rq);
 
 	if (rq_data_dir(rq) == READ)
-		hwif->sg_dma_direction = PCI_DMA_FROMDEVICE;
+		hwif->sg_dma_direction = DMA_FROM_DEVICE;
 	else
-		hwif->sg_dma_direction = PCI_DMA_TODEVICE;
+		hwif->sg_dma_direction = DMA_TO_DEVICE;
 
-	return pci_map_sg(pdev, sg, hwif->sg_nents, hwif->sg_dma_direction);
+	return dma_map_sg(hwif->dev, sg, hwif->sg_nents,
+			  hwif->sg_dma_direction);
 }
 
 EXPORT_SYMBOL_GPL(ide_build_sglist);
@@ -308,9 +309,8 @@ EXPORT_SYMBOL_GPL(ide_build_dmatable);
 void ide_destroy_dmatable (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 
-	pci_unmap_sg(pdev, hwif->sg_table, hwif->sg_nents,
+	dma_unmap_sg(hwif->dev, hwif->sg_table, hwif->sg_nents,
 		     hwif->sg_dma_direction);
 }
 
