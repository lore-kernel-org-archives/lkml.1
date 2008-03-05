Return-Path: <linux-kernel-owner+w=401wt.eu-S1764793AbYCEWzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764793AbYCEWzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760059AbYCEWwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:52:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:55831 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758859AbYCEWwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:52:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=O85WLabHlioSIf8aTdfEKXXSiASJap81FsKFAv0d8Ia7beowC7cQRdJnHcJp7I1YD2VpZJ/r4187b1XFOT3HGw0j17mlDum3X1Mr3y+Hxaftl/2j9/rcGkUeiG78pkVsG60dcwQEIVTjkBI6M31KsDI9cqjgA3FpDpeiF9auvjc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/3] ide: remove ->cds field from ide_hwif_t
Date: Thu, 6 Mar 2008 00:02:45 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803060002.45507.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Use hwif->name instead of cds->name in ide_allocate_dma_engine().

* Use pci_name(dev) instead of cds->name in init_dma_pdc202xx().

* Remove no longer needed ->cds field from ide_hwif_t.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c          |    2 +-
 drivers/ide/pci/pdc202xx_old.c |    5 +++--
 drivers/ide/setup-pci.c        |    1 -
 include/linux/ide.h            |    2 --
 4 files changed, 4 insertions(+), 6 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -833,7 +833,7 @@ static int ide_allocate_dma_engine(ide_h
 		return 0;
 
 	printk(KERN_ERR "%s: -- Error, unable to allocate DMA table.\n",
-	       hwif->cds->name);
+			hwif->name);
 
 	return 1;
 }
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -288,6 +288,7 @@ static void __devinit init_hwif_pdc202xx
 
 static void __devinit init_dma_pdc202xx(ide_hwif_t *hwif, unsigned long dmabase)
 {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u8 udma_speed_flag = 0, primary_mode = 0, secondary_mode = 0;
 
 	if (hwif->channel) {
@@ -300,14 +301,14 @@ static void __devinit init_dma_pdc202xx(
 	secondary_mode	= inb(dmabase | 0x1b);
 	printk(KERN_INFO "%s: (U)DMA Burst Bit %sABLED " \
 		"Primary %s Mode " \
-		"Secondary %s Mode.\n", hwif->cds->name,
+		"Secondary %s Mode.\n", pci_name(dev),
 		(udma_speed_flag & 1) ? "EN" : "DIS",
 		(primary_mode & 1) ? "MASTER" : "PCI",
 		(secondary_mode & 1) ? "MASTER" : "PCI" );
 
 	if (!(udma_speed_flag & 1)) {
 		printk(KERN_INFO "%s: FORCING BURST BIT 0x%02x->0x%02x ",
-			hwif->cds->name, udma_speed_flag,
+			pci_name(dev), udma_speed_flag,
 			(udma_speed_flag|1));
 		outb(udma_speed_flag | 1, dmabase | 0x1f);
 		printk("%sACTIVE\n", (inb(dmabase | 0x1f) & 1) ? "" : "IN");
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -321,7 +321,6 @@ static ide_hwif_t *ide_hwif_configure(st
 	ide_init_port_hw(hwif, &hw);
 
 	hwif->dev = &dev->dev;
-	hwif->cds = d;
 
 	return hwif;
 }
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -447,8 +447,6 @@ typedef struct hwif_s {
 
 	struct device *dev;
 
-	const struct ide_port_info *cds;	/* chipset device struct */
-
 	ide_ack_intr_t *ack_intr;
 
 	void (*rw_disk)(ide_drive_t *, struct request *);
