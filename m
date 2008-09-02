Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbYIBTt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbYIBTt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 15:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbYIBTtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 15:49:18 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:9758 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbYIBTtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 15:49:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=YcDSus5wtDLTnXmhtd5XpRlX50ggAV9FESSGoDV24rTws4J31bUN6X0qxv/0nTw3Mg
         n7Nx84bU3H9NdBdJz/N6u4ODKPJJKp+WECbWhSiVcXMts4JhbM+J8QGkBYbCaUTLT5Je
         WLgxJZkDz+X7zAJmLa5JtMtkpmP71d4p2ueAE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 02 Sep 2008 21:47:11 +0200
Message-Id: <20080902194711.14564.63625.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/8] ide: __ide_dma_end() -> ide_dma_end()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it:
- use EXPORT_SYMBOL_GPL() to match the rest of SFF DMA functions

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c          |    7 +++----
 drivers/ide/pci/alim15x3.c     |    2 +-
 drivers/ide/pci/cmd64x.c       |    4 ++--
 drivers/ide/pci/hpt366.c       |    6 +++---
 drivers/ide/pci/it821x.c       |    2 +-
 drivers/ide/pci/pdc202xx_old.c |    4 ++--
 drivers/ide/pci/siimage.c      |    2 +-
 drivers/ide/pci/sl82c105.c     |    2 +-
 drivers/ide/pci/tc86c001.c     |    2 +-
 include/linux/ide.h            |    2 +-
 10 files changed, 16 insertions(+), 17 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -531,7 +531,7 @@ void ide_dma_start(ide_drive_t *drive)
 EXPORT_SYMBOL_GPL(ide_dma_start);
 
 /* returns 1 on error, 0 otherwise */
-int __ide_dma_end (ide_drive_t *drive)
+int ide_dma_end(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
@@ -566,8 +566,7 @@ int __ide_dma_end (ide_drive_t *drive)
 	wmb();
 	return (dma_stat & 7) != 4 ? (0x10 | dma_stat) : 0;
 }
-
-EXPORT_SYMBOL(__ide_dma_end);
+EXPORT_SYMBOL_GPL(ide_dma_end);
 
 /* returns 1 if dma irq issued, 0 otherwise */
 int ide_dma_test_irq(ide_drive_t *drive)
@@ -880,7 +879,7 @@ const struct ide_dma_ops sff_dma_ops = {
 	.dma_setup		= ide_dma_setup,
 	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
-	.dma_end		= __ide_dma_end,
+	.dma_end		= ide_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -507,7 +507,7 @@ static const struct ide_dma_ops ali_dma_
 	.dma_setup		= ali15x3_dma_setup,
 	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
-	.dma_end		= __ide_dma_end,
+	.dma_end		= ide_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timeout		= ide_dma_timeout,
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -228,7 +228,7 @@ static int cmd648_dma_end(ide_drive_t *d
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	unsigned long base	= hwif->dma_base - (hwif->channel * 8);
-	int err			= __ide_dma_end(drive);
+	int err			= ide_dma_end(drive);
 	u8  irq_mask		= hwif->channel ? MRDMODE_INTR_CH1 :
 						  MRDMODE_INTR_CH0;
 	u8  mrdmode		= inb(base + 1);
@@ -248,7 +248,7 @@ static int cmd64x_dma_end(ide_drive_t *d
 	u8  irq_mask		= hwif->channel ? ARTTIM23_INTR_CH1 :
 						  CFR_INTR_CH0;
 	u8  irq_stat		= 0;
-	int err			= __ide_dma_end(drive);
+	int err			= ide_dma_end(drive);
 
 	(void) pci_read_config_byte(dev, irq_reg, &irq_stat);
 	/* clear the interrupt bit */
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -833,7 +833,7 @@ static int hpt370_dma_end(ide_drive_t *d
 		if (dma_stat & 0x01)
 			hpt370_irq_timeout(drive);
 	}
-	return __ide_dma_end(drive);
+	return ide_dma_end(drive);
 }
 
 static void hpt370_dma_timeout(ide_drive_t *drive)
@@ -875,7 +875,7 @@ static int hpt374_dma_end(ide_drive_t *d
 	pci_read_config_byte(dev, mcr_addr, &mcr);
 	if (bwsr & mask)
 		pci_write_config_byte(dev, mcr_addr, mcr | 0x30);
-	return __ide_dma_end(drive);
+	return ide_dma_end(drive);
 }
 
 /**
@@ -1454,7 +1454,7 @@ static const struct ide_dma_ops hpt36x_d
 	.dma_setup		= ide_dma_setup,
 	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
-	.dma_end		= __ide_dma_end,
+	.dma_end		= ide_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= hpt366_dma_lost_irq,
 	.dma_timeout		= ide_dma_timeout,
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -385,7 +385,7 @@ static int it821x_dma_end(ide_drive_t *d
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
-	int ret = __ide_dma_end(drive);
+	int ret = ide_dma_end(drive);
 	u8 unit = drive->dn & 1;
 
 	if(itdev->mwdma[unit] != MWDMA_OFF)
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -200,7 +200,7 @@ static int pdc202xx_dma_end(ide_drive_t 
 	}
 	if (drive->current_speed > XFER_UDMA_2)
 		pdc_old_disable_66MHz_clock(drive->hwif);
-	return __ide_dma_end(drive);
+	return ide_dma_end(drive);
 }
 
 static int pdc202xx_dma_test_irq(ide_drive_t *drive)
@@ -333,7 +333,7 @@ static const struct ide_dma_ops pdc20246
 	.dma_setup		= ide_dma_setup,
 	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
-	.dma_end		= __ide_dma_end,
+	.dma_end		= ide_dma_end,
 	.dma_test_irq		= pdc202xx_dma_test_irq,
 	.dma_lost_irq		= pdc202xx_dma_lost_irq,
 	.dma_timeout		= pdc202xx_dma_timeout,
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -713,7 +713,7 @@ static const struct ide_dma_ops sil_dma_
 	.dma_setup		= ide_dma_setup,
 	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
-	.dma_end		= __ide_dma_end,
+	.dma_end		= ide_dma_end,
 	.dma_test_irq		= siimage_dma_test_irq,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
Index: b/drivers/ide/pci/sl82c105.c
===================================================================
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -207,7 +207,7 @@ static int sl82c105_dma_end(ide_drive_t 
 
 	DBG(("%s(drive:%s)\n", __func__, drive->name));
 
-	ret = __ide_dma_end(drive);
+	ret = ide_dma_end(drive);
 
 	pci_write_config_word(dev, reg, drive->drive_data);
 
Index: b/drivers/ide/pci/tc86c001.c
===================================================================
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -186,7 +186,7 @@ static const struct ide_dma_ops tc86c001
 	.dma_setup		= ide_dma_setup,
 	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= tc86c001_dma_start,
-	.dma_end		= __ide_dma_end,
+	.dma_end		= ide_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timeout		= ide_dma_timeout,
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1430,7 +1430,7 @@ void ide_dma_host_set(ide_drive_t *, int
 extern int ide_dma_setup(ide_drive_t *);
 void ide_dma_exec_cmd(ide_drive_t *, u8);
 extern void ide_dma_start(ide_drive_t *);
-extern int __ide_dma_end(ide_drive_t *);
+int ide_dma_end(ide_drive_t *);
 int ide_dma_test_irq(ide_drive_t *);
 extern void ide_dma_lost_irq(ide_drive_t *);
 extern void ide_dma_timeout(ide_drive_t *);
