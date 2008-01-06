Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbYAFQwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbYAFQwE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759339AbYAFQu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:50:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:19805 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759183AbYAFQuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:50:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jiwNrdHVRAsVN1x6i1F42hcfD3apiVplkvr8ZKNmd3kpm/4He4hf4oMaW2Em7NX4+slty2tF1rEUMSeDgWnmYhlB+wviSAlRpT0nxso+q9TazcHcH32aA5NZLnB1cQMfopM1S4SoKW0Q3BksrqXnMGsNI99fih/TF/0FslXgX4E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 06 Jan 2008 18:02:41 +0100
Message-Id: <20080106170241.6861.69546.sendpatchset@localhost.localdomain>
In-Reply-To: <20080106170220.6861.4814.sendpatchset@localhost.localdomain>
References: <20080106170220.6861.4814.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/8] atiixp/cs5535/scc_pata: fix "idex=ata66" parameter handling
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't override the cable type if the "idex=ata66" parameter was used.

While at it:

* atiixp.c: factor out cable detection to atiixp_cable_detect() from
  init_hwif_atiixp().

* cs5535.c: pass 'ide_hwif_t *hwif' instead of 'struct pci_dev *dev' to
  cs5535_cable_detect().

* scc_pata.c: factor out cable detection to scc_cable_detect() from
  init_hwif_scc() and remove incorrect comment.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
+16 bytes
 drivers/ide/pci/atiixp.c   |   24 +++++++++++++++---------
 drivers/ide/pci/cs5535.c   |    8 ++++----
 drivers/ide/pci/scc_pata.c |    9 +++++++--
 3 files changed, 26 insertions(+), 15 deletions(-)

Index: b/drivers/ide/pci/atiixp.c
===================================================================
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -121,6 +121,19 @@ static void atiixp_set_dma_mode(ide_driv
 	spin_unlock_irqrestore(&atiixp_lock, flags);
 }
 
+static u8 __devinit atiixp_cable_detect(ide_hwif_t *hwif)
+{
+	struct pci_dev *pdev = to_pci_dev(hwif->dev);
+	u8 udma_mode = 0, ch = hwif->channel;
+
+	pci_read_config_byte(pdev, ATIIXP_IDE_UDMA_MODE + ch, &udma_mode);
+
+	if ((udma_mode & 0x07) >= 0x04 || (udma_mode & 0x70) >= 0x40)
+		return ATA_CBL_PATA80;
+	else
+		return ATA_CBL_PATA40;
+}
+
 /**
  *	init_hwif_atiixp		-	fill in the hwif for the ATIIXP
  *	@hwif: IDE interface
@@ -131,21 +144,14 @@ static void atiixp_set_dma_mode(ide_driv
 
 static void __devinit init_hwif_atiixp(ide_hwif_t *hwif)
 {
-	struct pci_dev *pdev = to_pci_dev(hwif->dev);
-	u8 udma_mode = 0, ch = hwif->channel;
-
 	hwif->set_pio_mode = &atiixp_set_pio_mode;
 	hwif->set_dma_mode = &atiixp_set_dma_mode;
 
 	if (!hwif->dma_base)
 		return;
 
-	pci_read_config_byte(pdev, ATIIXP_IDE_UDMA_MODE + ch, &udma_mode);
-
-	if ((udma_mode & 0x07) >= 0x04 || (udma_mode & 0x70) >= 0x40)
-		hwif->cbl = ATA_CBL_PATA80;
-	else
-		hwif->cbl = ATA_CBL_PATA40;
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+		hwif->cbl = atiixp_cable_detect(hwif);
 }
 
 static const struct ide_port_info atiixp_pci_info[] __devinitdata = {
Index: b/drivers/ide/pci/cs5535.c
===================================================================
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -155,8 +155,9 @@ static void cs5535_set_pio_mode(ide_driv
 	cs5535_set_speed(drive, XFER_PIO_0 + pio);
 }
 
-static u8 __devinit cs5535_cable_detect(struct pci_dev *dev)
+static u8 __devinit cs5535_cable_detect(ide_hwif_t *hwif)
 {
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u8 bit;
 
 	/* if a 80 wire cable was detected */
@@ -175,15 +176,14 @@ static u8 __devinit cs5535_cable_detect(
  */
 static void __devinit init_hwif_cs5535(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-
 	hwif->set_pio_mode = &cs5535_set_pio_mode;
 	hwif->set_dma_mode = &cs5535_set_dma_mode;
 
 	if (hwif->dma_base == 0)
 		return;
 
-	hwif->cbl = cs5535_cable_detect(dev);
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+		hwif->cbl = cs5535_cable_detect(hwif);
 }
 
 static const struct ide_port_info cs5535_chipset __devinitdata = {
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -644,6 +644,11 @@ static void __devinit init_iops_scc(ide_
 	init_mmio_iops_scc(hwif);
 }
 
+static u8 __devinit scc_cable_detect(ide_hwif_t *hwif)
+{
+	return ATA_CBL_PATA80;
+}
+
 /**
  *	init_hwif_scc	-	set up hwif
  *	@hwif: interface to set up
@@ -678,8 +683,8 @@ static void __devinit init_hwif_scc(ide_
 	else
 		hwif->ultra_mask = ATA_UDMA5; /* 100MHz */
 
-	/* we support 80c cable only. */
-	hwif->cbl = ATA_CBL_PATA80;
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+		hwif->cbl = scc_cable_detect(hwif);
 }
 
 #define DECLARE_SCC_DEV(name_str)			\
