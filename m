Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbYCHVWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbYCHVWM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 16:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYCHVVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 16:21:35 -0500
Received: from gv-out-0910.google.com ([216.239.58.185]:48365 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbYCHVVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 16:21:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=lhXl9IgN88LqAQu7xIZ8VlfynLgbmbHY2Q1o9KGtvjvhSJE1yr8Ko0/Hu/mSXG5n5XLXhzP4v+hfyhOtaejSgdMQp0eDQA7LeYtDeXS2HxiBde08AECXG1YooVrVJEgg0DJ3lyQEtHV2MBtdFDth5WFe0YadcWGHg2Ek5oKqNfQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/7] pdc202xx_old: remove init_dma_pdc202xx()
Date: Sat, 8 Mar 2008 22:30:31 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803082230.31377.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do PDC202xx specific DMA initialization in init_chipset_pdc202xx()
and remove no longer needed init_dma_pdc202xx().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/pdc202xx_old.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -263,12 +263,6 @@ static void pdc202xx_dma_timeout(ide_dri
 	ide_dma_timeout(drive);
 }
 
-static unsigned int __devinit init_chipset_pdc202xx(struct pci_dev *dev,
-							const char *name)
-{
-	return dev->irq;
-}
-
 static void __devinit init_hwif_pdc202xx(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
@@ -286,15 +280,14 @@ static void __devinit init_hwif_pdc202xx
 	hwif->ide_dma_test_irq = &pdc202xx_old_ide_dma_test_irq;
 }
 
-static void __devinit init_dma_pdc202xx(ide_hwif_t *hwif, unsigned long dmabase)
+static unsigned int __devinit init_chipset_pdc202xx(struct pci_dev *dev,
+						    const char *name)
 {
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
+	unsigned long dmabase = pci_resource_start(dev, 4);
 	u8 udma_speed_flag = 0, primary_mode = 0, secondary_mode = 0;
 
-	if (hwif->channel) {
-		ide_setup_dma(hwif, dmabase);
-		return;
-	}
+	if (dmabase == 0)
+		goto out;
 
 	udma_speed_flag	= inb(dmabase | 0x1f);
 	primary_mode	= inb(dmabase | 0x1a);
@@ -313,8 +306,8 @@ static void __devinit init_dma_pdc202xx(
 		outb(udma_speed_flag | 1, dmabase | 0x1f);
 		printk("%sACTIVE\n", (inb(dmabase | 0x1f) & 1) ? "" : "IN");
 	}
-
-	ide_setup_dma(hwif, dmabase);
+out:
+	return dev->irq;
 }
 
 static void __devinit pdc202ata4_fixup_irq(struct pci_dev *dev,
@@ -358,7 +351,6 @@ static const struct ide_port_ops pdc2026
 		.name		= name_str, \
 		.init_chipset	= init_chipset_pdc202xx, \
 		.init_hwif	= init_hwif_pdc202xx, \
-		.init_dma	= init_dma_pdc202xx, \
 		.port_ops	= &pdc2026x_port_ops, \
 		.host_flags	= IDE_HFLAGS_PDC202XX | extra_flags, \
 		.pio_mask	= ATA_PIO4, \
@@ -371,7 +363,6 @@ static const struct ide_port_info pdc202
 		.name		= "PDC20246",
 		.init_chipset	= init_chipset_pdc202xx,
 		.init_hwif	= init_hwif_pdc202xx,
-		.init_dma	= init_dma_pdc202xx,
 		.port_ops	= &pdc20246_port_ops,
 		.host_flags	= IDE_HFLAGS_PDC202XX,
 		.pio_mask	= ATA_PIO4,
