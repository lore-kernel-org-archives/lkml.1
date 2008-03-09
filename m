Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbYCIPZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbYCIPZH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 11:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbYCIPYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 11:24:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:15146 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbYCIPYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 11:24:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=XkbWnwv7SmRklx8XAauBY9nZtrTdWugU2JiZOJywHaL8V7VTgiZTckZE8FjtuV4+b+TXCjfq4S4XLcHGaDp545tbHHNg3PGvzOcwJfbyk7EiXowkTupg5ILAnbjWGJZiEaMcNx6CKxYOpxeDqvhuMQloBIc3NVSFFJGMk3wOBGU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/7] ide-pmac: use ->init_dma method
Date: Sun, 9 Mar 2008 16:30:13 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803091630.13785.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Move pmif->dma_regs check from pmac_ide_setup_device() to
  pmac_ide_init_dma().

* Get 'pmif' from 'hwif->hwif_data' in pmac_ide_init_dma() and replace
  'pmac_ide_hwif_t *pmif' argument by 'const struct ide_port_info *d'.

* Add pmac_ide_init_dma() implementation for CONFIG_BLK_DEV_IDEDMA_PMAC=n
  case and convert the driver to use ->init_dma method.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ppc/pmac.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -409,7 +409,7 @@ kauai_lookup_timing(struct kauai_timing*
  */
 #define IDE_WAKEUP_DELAY	(1*HZ)
 
-static int pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif);
+static int pmac_ide_init_dma(ide_hwif_t *, const struct ide_port_info *);
 static int pmac_ide_build_dmatable(ide_drive_t *drive, struct request *rq);
 static void pmac_ide_selectproc(ide_drive_t *drive);
 static void pmac_ide_kauai_selectproc(ide_drive_t *drive);
@@ -931,11 +931,11 @@ static const struct ide_port_ops pmac_id
 };
 
 static const struct ide_port_info pmac_port_info = {
+	.init_dma		= pmac_ide_init_dma,
 	.chipset		= ide_pmac,
 	.port_ops		= &pmac_ide_port_ops,
 	.host_flags		= IDE_HFLAG_SET_PIO_MODE_KEEP_DMA |
 				  IDE_HFLAG_POST_SET_MODE |
-				  IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
 				  IDE_HFLAG_UNMASK_IRQS,
 	.pio_mask		= ATA_PIO4,
 	.mwdma_mask		= ATA_MWDMA2,
@@ -1067,10 +1067,7 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 #ifdef CONFIG_BLK_DEV_IDEDMA_PMAC
 	if (pmif->cable_80 == 0)
 		d.udma_mask &= ATA_UDMA2;
-	/* has a DBDMA controller channel */
-	if (pmif->dma_regs == 0 || pmac_ide_setup_dma(pmif, hwif) < 0)
 #endif
-		d.udma_mask = d.mwdma_mask = 0;
 
 	idx[0] = hwif->index;
 
@@ -1677,14 +1674,16 @@ pmac_ide_dma_lost_irq (ide_drive_t *driv
  * Allocate the data structures needed for using DMA with an interface
  * and fill the proper list of functions pointers
  */
-static int __devinit pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
+static int __devinit pmac_ide_init_dma(ide_hwif_t *hwif,
+				       const struct ide_port_info *d)
 {
+	pmac_ide_hwif_t *pmif = (pmac_ide_hwif_t *)hwif->hwif_data;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
 	/* We won't need pci_dev if we switch to generic consistent
 	 * DMA routines ...
 	 */
-	if (dev == NULL)
+	if (dev == NULL || pmif->dma_regs == 0)
 		return -ENODEV;
 	/*
 	 * Allocate space for the DBDMA commands.
@@ -1714,7 +1713,12 @@ static int __devinit pmac_ide_setup_dma(
 
 	return 0;
 }
-
+#else
+static int __devinit pmac_ide_init_dma(ide_hwif_t *hwif,
+				       const struct ide_port_info *d)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */
 
 module_init(pmac_ide_probe);
