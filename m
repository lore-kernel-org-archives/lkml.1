Return-Path: <linux-kernel-owner+w=401wt.eu-S1760554AbYAFQxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760554AbYAFQxg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758252AbYAFQvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:51:36 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:18967 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759583AbYAFQvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:51:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=wix1cwaMGh5Oh3gKZrZ/E6pSlz2j1zP+rgkilidDXG/7stGgE+a89JfkgV9D9q/9f7ZqJ+tXI1y2y19nLL/Nw9hHPeJgZrC35GjfOGOKKC81n0EUzsQ45w3xbGs52cqMIJJi6/BTRob0u+2+SJkrLkOr7ZBg/zNmDXx0Gwwj7KU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 06 Jan 2008 18:03:17 +0100
Message-Id: <20080106170317.6861.77734.sendpatchset@localhost.localdomain>
In-Reply-To: <20080106170220.6861.4814.sendpatchset@localhost.localdomain>
References: <20080106170220.6861.4814.sendpatchset@localhost.localdomain>
Subject: [PATCH 8/8] ide: add ->cable_detect method to ide_hwif_t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add ->cable_detect method to ide_hwif_t.

* Call the new method in ide_init_port() if:
  - the host supports UDMA modes > UDMA2 ('hwif->ultra_mask & 78')
  - DMA initialization was successful (if hwif->dma_base is not set
    ide_init_port() sets hwif->ultra_mask to zero)
  - "idex=ata66" is not used ('hwif->cbl != ATA_CBL_PATA40_SHORT')

* Convert PCI host drivers to use ->cable_detect method.

While at it:

* Factor out cable detection to separate functions (if not already done).

* hpt366.c/it8213.c/slc90e66.c:
  - don't check cable type if "idex=ata66" is used

* pdc202xx_new.c:
  - add __devinit tag to pdcnew_cable_detect()

* pdc202xx_old.c:
  - rename pdc202xx_old_cable_detect() to pdc2026x_old_cable_detect()
  - add __devinit tag to pdc2026x_old_cable_detect()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-105 bytes
 drivers/ide/ide-probe.c        |    5 ++
 drivers/ide/pci/aec62xx.c      |   25 +++++-------
 drivers/ide/pci/alim15x3.c     |    5 --
 drivers/ide/pci/amd74xx.c      |   18 ++++----
 drivers/ide/pci/atiixp.c       |    6 --
 drivers/ide/pci/cmd64x.c       |    5 --
 drivers/ide/pci/cs5535.c       |    6 --
 drivers/ide/pci/hpt366.c       |   84 ++++++++++++++++++++++-------------------
 drivers/ide/pci/it8213.c       |   21 +++++-----
 drivers/ide/pci/it821x.c       |    5 --
 drivers/ide/pci/jmicron.c      |    6 --
 drivers/ide/pci/pdc202xx_new.c |    8 ---
 drivers/ide/pci/pdc202xx_old.c |   10 ++--
 drivers/ide/pci/piix.c         |    7 ---
 drivers/ide/pci/scc_pata.c     |    3 -
 drivers/ide/pci/serverworks.c  |    9 ----
 drivers/ide/pci/siimage.c      |    5 --
 drivers/ide/pci/sis5513.c      |    5 --
 drivers/ide/pci/slc90e66.c     |   19 +++++----
 drivers/ide/pci/tc86c001.c     |   24 +++++++----
 drivers/ide/pci/via82cxxx.c    |    6 --
 include/linux/ide.h            |    2 
 22 files changed, 137 insertions(+), 147 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1343,6 +1343,11 @@ static void ide_init_port(ide_hwif_t *hw
 	/* call chipset specific routine for each enabled port */
 	if (d->init_hwif)
 		d->init_hwif(hwif);
+
+	if (hwif->cable_detect && (hwif->ultra_mask & 0x78)) {
+		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+			hwif->cbl = hwif->cable_detect(hwif);
+	}
 }
 
 int ide_device_add_all(u8 idx[MAX_HWIFS], const struct ide_port_info *d)
Index: b/drivers/ide/pci/aec62xx.c
===================================================================
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -166,6 +166,16 @@ static unsigned int __devinit init_chips
 	return dev->irq;
 }
 
+static u8 __devinit atp86x_cable_detect(ide_hwif_t *hwif)
+{
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+	u8 ata66 = 0, mask = hwif->channel ? 0x02 : 0x01;
+
+	pci_read_config_byte(dev, 0x49, &ata66);
+
+	return (ata66 & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
+}
+
 static void __devinit init_hwif_aec62xx(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
@@ -174,21 +184,10 @@ static void __devinit init_hwif_aec62xx(
 
 	if (dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF)
 		hwif->set_dma_mode = &aec6210_set_mode;
-	else
+	else {
 		hwif->set_dma_mode = &aec6260_set_mode;
 
-	if (hwif->dma_base == 0)
-		return;
-
-	if (dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF)
-		return;
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT) {
-		u8 ata66 = 0, mask = hwif->channel ? 0x02 : 0x01;
-
-		pci_read_config_byte(dev, 0x49, &ata66);
-
-		hwif->cbl = (ata66 & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
+		hwif->cable_detect = atp86x_cable_detect;
 	}
 }
 
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -666,13 +666,12 @@ static void __devinit init_hwif_common_a
 	hwif->set_dma_mode = &ali_set_dma_mode;
 	hwif->udma_filter = &ali_udma_filter;
 
+	hwif->cable_detect = ata66_ali15x3;
+
 	if (hwif->dma_base == 0)
 		return;
 
 	hwif->dma_setup = &ali15x3_dma_setup;
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = ata66_ali15x3(hwif);
 }
 
 /**
Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -199,6 +199,14 @@ static unsigned int __devinit init_chips
 	return dev->irq;
 }
 
+static u8 __devinit amd_cable_detect(ide_hwif_t *hwif)
+{
+	if ((amd_80w >> hwif->channel) & 1)
+		return ATA_CBL_PATA80;
+	else
+		return ATA_CBL_PATA40;
+}
+
 static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
@@ -209,15 +217,7 @@ static void __devinit init_hwif_amd74xx(
 	hwif->set_pio_mode = &amd_set_pio_mode;
 	hwif->set_dma_mode = &amd_set_drive;
 
-	if (!hwif->dma_base)
-		return;
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT) {
-		if ((amd_80w >> hwif->channel) & 1)
-			hwif->cbl = ATA_CBL_PATA80;
-		else
-			hwif->cbl = ATA_CBL_PATA40;
-	}
+	hwif->cable_detect = amd_cable_detect;
 }
 
 #define IDE_HFLAGS_AMD \
Index: b/drivers/ide/pci/atiixp.c
===================================================================
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -147,11 +147,7 @@ static void __devinit init_hwif_atiixp(i
 	hwif->set_pio_mode = &atiixp_set_pio_mode;
 	hwif->set_dma_mode = &atiixp_set_dma_mode;
 
-	if (!hwif->dma_base)
-		return;
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = atiixp_cable_detect(hwif);
+	hwif->cable_detect = atiixp_cable_detect;
 }
 
 static const struct ide_port_info atiixp_pci_info[] __devinitdata = {
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -393,6 +393,8 @@ static void __devinit init_hwif_cmd64x(i
 	hwif->set_pio_mode = &cmd64x_set_pio_mode;
 	hwif->set_dma_mode = &cmd64x_set_dma_mode;
 
+	hwif->cable_detect = ata66_cmd64x;
+
 	if (!hwif->dma_base)
 		return;
 
@@ -411,9 +413,6 @@ static void __devinit init_hwif_cmd64x(i
 	if (dev->device == PCI_DEVICE_ID_CMD_646 && dev->revision < 5)
 		hwif->ultra_mask = 0x00;
 
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = ata66_cmd64x(hwif);
-
 	switch (dev->device) {
 	case PCI_DEVICE_ID_CMD_648:
 	case PCI_DEVICE_ID_CMD_649:
Index: b/drivers/ide/pci/cs5535.c
===================================================================
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -179,11 +179,7 @@ static void __devinit init_hwif_cs5535(i
 	hwif->set_pio_mode = &cs5535_set_pio_mode;
 	hwif->set_dma_mode = &cs5535_set_dma_mode;
 
-	if (hwif->dma_base == 0)
-		return;
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = cs5535_cable_detect(hwif);
+	hwif->cable_detect = cs5535_cable_detect;
 }
 
 static const struct ide_port_info cs5535_chipset __devinitdata = {
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1279,12 +1279,55 @@ static unsigned int __devinit init_chips
 	return dev->irq;
 }
 
+static u8 __devinit hpt3xx_cable_detect(ide_hwif_t *hwif)
+{
+	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
+	struct hpt_info *info	= pci_get_drvdata(dev);
+	u8 chip_type		= info->chip_type;
+	u8 scr1 = 0, ata66	= hwif->channel ? 0x01 : 0x02;
+
+	/*
+	 * The HPT37x uses the CBLID pins as outputs for MA15/MA16
+	 * address lines to access an external EEPROM.  To read valid
+	 * cable detect state the pins must be enabled as inputs.
+	 */
+	if (chip_type == HPT374 && (PCI_FUNC(dev->devfn) & 1)) {
+		/*
+		 * HPT374 PCI function 1
+		 * - set bit 15 of reg 0x52 to enable TCBLID as input
+		 * - set bit 15 of reg 0x56 to enable FCBLID as input
+		 */
+		u8  mcr_addr = hwif->select_data + 2;
+		u16 mcr;
+
+		pci_read_config_word(dev, mcr_addr, &mcr);
+		pci_write_config_word(dev, mcr_addr, (mcr | 0x8000));
+		/* now read cable id register */
+		pci_read_config_byte(dev, 0x5a, &scr1);
+		pci_write_config_word(dev, mcr_addr, mcr);
+	} else if (chip_type >= HPT370) {
+		/*
+		 * HPT370/372 and 374 pcifn 0
+		 * - clear bit 0 of reg 0x5b to enable P/SCBLID as inputs
+		 */
+		u8 scr2 = 0;
+
+		pci_read_config_byte(dev, 0x5b, &scr2);
+		pci_write_config_byte(dev, 0x5b, (scr2 & ~1));
+		/* now read cable id register */
+		pci_read_config_byte(dev, 0x5a, &scr1);
+		pci_write_config_byte(dev, 0x5b,  scr2);
+	} else
+		pci_read_config_byte(dev, 0x5a, &scr1);
+
+	return (scr1 & ata66) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
+}
+
 static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	struct hpt_info *info	= pci_get_drvdata(dev);
 	int serialize		= HPT_SERIALIZE_IO;
-	u8  scr1 = 0, ata66	= hwif->channel ? 0x01 : 0x02;
 	u8  chip_type		= info->chip_type;
 	u8  new_mcr, old_mcr	= 0;
 
@@ -1301,6 +1344,8 @@ static void __devinit init_hwif_hpt366(i
 	hwif->udma_filter	= &hpt3xx_udma_filter;
 	hwif->mdma_filter	= &hpt3xx_mdma_filter;
 
+	hwif->cable_detect	= hpt3xx_cable_detect;
+
 	/*
 	 * HPT3xxN chips have some complications:
 	 *
@@ -1346,43 +1391,6 @@ static void __devinit init_hwif_hpt366(i
 	if (hwif->dma_base == 0)
 		return;
 
-	/*
-	 * The HPT37x uses the CBLID pins as outputs for MA15/MA16
-	 * address lines to access an external EEPROM.  To read valid
-	 * cable detect state the pins must be enabled as inputs.
-	 */
-	if (chip_type == HPT374 && (PCI_FUNC(dev->devfn) & 1)) {
-		/*
-		 * HPT374 PCI function 1
-		 * - set bit 15 of reg 0x52 to enable TCBLID as input
-		 * - set bit 15 of reg 0x56 to enable FCBLID as input
-		 */
-		u8  mcr_addr = hwif->select_data + 2;
-		u16 mcr;
-
-		pci_read_config_word (dev, mcr_addr, &mcr);
-		pci_write_config_word(dev, mcr_addr, (mcr | 0x8000));
-		/* now read cable id register */
-		pci_read_config_byte (dev, 0x5a, &scr1);
-		pci_write_config_word(dev, mcr_addr, mcr);
-	} else if (chip_type >= HPT370) {
-		/*
-		 * HPT370/372 and 374 pcifn 0
-		 * - clear bit 0 of reg 0x5b to enable P/SCBLID as inputs
-		 */
-		u8 scr2 = 0;
-
-		pci_read_config_byte (dev, 0x5b, &scr2);
-		pci_write_config_byte(dev, 0x5b, (scr2 & ~1));
-		/* now read cable id register */
-		pci_read_config_byte (dev, 0x5a, &scr1);
-		pci_write_config_byte(dev, 0x5b,  scr2);
-	} else
-		pci_read_config_byte (dev, 0x5a, &scr1);
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = (scr1 & ata66) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
-
 	if (chip_type >= HPT374) {
 		hwif->ide_dma_test_irq	= &hpt374_ide_dma_test_irq;
 		hwif->ide_dma_end	= &hpt374_ide_dma_end;
Index: b/drivers/ide/pci/it8213.c
===================================================================
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -143,6 +143,16 @@ static void it8213_set_dma_mode(ide_driv
 	}
 }
 
+static u8 __devinit it8213_cable_detect(ide_hwif_t *hwif)
+{
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+	u8 reg42h = 0;
+
+	pci_read_config_byte(dev, 0x42, &reg42h);
+
+	return (reg42h & 0x02) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
+}
+
 /**
  *	init_hwif_it8213	-	set up hwif structs
  *	@hwif: interface to set up
@@ -152,19 +162,10 @@ static void it8213_set_dma_mode(ide_driv
 
 static void __devinit init_hwif_it8213(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	u8 reg42h = 0;
-
 	hwif->set_dma_mode = &it8213_set_dma_mode;
 	hwif->set_pio_mode = &it8213_set_pio_mode;
 
-	if (!hwif->dma_base)
-		return;
-
-	pci_read_config_byte(dev, 0x42, &reg42h);
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = (reg42h & 0x02) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
+	hwif->cable_detect = it8213_cable_detect;
 }
 
 
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -579,14 +579,13 @@ static void __devinit init_hwif_it821x(i
 	} else
 		hwif->host_flags |= IDE_HFLAG_NO_SET_MODE;
 
+	hwif->cable_detect = ata66_it821x;
+
 	if (hwif->dma_base == 0)
 		return;
 
 	hwif->ultra_mask = ATA_UDMA6;
 	hwif->mwdma_mask = ATA_MWDMA2;
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = ata66_it821x(hwif);
 }
 
 static void __devinit it8212_disable_raid(struct pci_dev *dev)
Index: b/drivers/ide/pci/jmicron.c
===================================================================
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -111,11 +111,7 @@ static void __devinit init_hwif_jmicron(
 	hwif->set_pio_mode = &jmicron_set_pio_mode;
 	hwif->set_dma_mode = &jmicron_set_dma_mode;
 
-	if (hwif->dma_base == 0)
-		return;
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = ata66_jmicron(hwif);
+	hwif->cable_detect = ata66_jmicron;
 }
 
 static const struct ide_port_info jmicron_chipset __devinitdata = {
Index: b/drivers/ide/pci/pdc202xx_new.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -197,7 +197,7 @@ static void pdcnew_set_pio_mode(ide_driv
 	}
 }
 
-static u8 pdcnew_cable_detect(ide_hwif_t *hwif)
+static u8 __devinit pdcnew_cable_detect(ide_hwif_t *hwif)
 {
 	if (get_indexed_reg(hwif, 0x0b) & 0x04)
 		return ATA_CBL_PATA40;
@@ -456,11 +456,7 @@ static void __devinit init_hwif_pdc202ne
 	hwif->quirkproc = &pdcnew_quirkproc;
 	hwif->resetproc = &pdcnew_reset;
 
-	if (hwif->dma_base == 0)
-		return;
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = pdcnew_cable_detect(hwif);
+	hwif->cable_detect = pdcnew_cable_detect;
 }
 
 static struct pci_dev * __devinit pdc20270_get_dev2(struct pci_dev *dev)
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -140,7 +140,7 @@ static void pdc202xx_set_pio_mode(ide_dr
 	pdc202xx_set_mode(drive, XFER_PIO_0 + pio);
 }
 
-static u8 pdc202xx_old_cable_detect (ide_hwif_t *hwif)
+static u8 __devinit pdc2026x_old_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u16 CIS = 0, mask = (hwif->channel) ? (1<<11) : (1<<10);
@@ -311,9 +311,12 @@ static void __devinit init_hwif_pdc202xx
 
 	hwif->quirkproc = &pdc202xx_quirkproc;
 
-	if (dev->device != PCI_DEVICE_ID_PROMISE_20246)
+	if (dev->device != PCI_DEVICE_ID_PROMISE_20246) {
 		hwif->resetproc = &pdc202xx_reset;
 
+		hwif->cable_detect = pdc2026x_old_cable_detect;
+	}
+
 	if (hwif->dma_base == 0)
 		return;
 
@@ -321,9 +324,6 @@ static void __devinit init_hwif_pdc202xx
 	hwif->dma_timeout = &pdc202xx_dma_timeout;
 
 	if (dev->device != PCI_DEVICE_ID_PROMISE_20246) {
-		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-			hwif->cbl = pdc202xx_old_cable_detect(hwif);
-
 		hwif->dma_start = &pdc202xx_old_ide_dma_start;
 		hwif->ide_dma_end = &pdc202xx_old_ide_dma_end;
 	} 
Index: b/drivers/ide/pci/piix.c
===================================================================
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -290,14 +290,11 @@ static void __devinit init_hwif_piix(ide
 	hwif->set_pio_mode = &piix_set_pio_mode;
 	hwif->set_dma_mode = &piix_set_dma_mode;
 
+	hwif->cable_detect = piix_cable_detect;
+
 	if (!hwif->dma_base)
 		return;
 
-	if (hwif->ultra_mask & 0x78) {
-		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-			hwif->cbl = piix_cable_detect(hwif);
-	}
-
 	if (no_piix_dma)
 		hwif->ultra_mask = hwif->mwdma_mask = hwif->swdma_mask = 0;
 }
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -683,8 +683,7 @@ static void __devinit init_hwif_scc(ide_
 	else
 		hwif->ultra_mask = ATA_UDMA5; /* 100MHz */
 
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = scc_cable_detect(hwif);
+	hwif->cable_detect = scc_cable_detect;
 }
 
 #define DECLARE_SCC_DEV(name_str)			\
Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -346,13 +346,8 @@ static void __devinit init_hwif_svwks (i
 	hwif->set_dma_mode = &svwks_set_dma_mode;
 	hwif->udma_filter = &svwks_udma_filter;
 
-	if (!hwif->dma_base)
-		return;
-
-	if (dev->device != PCI_DEVICE_ID_SERVERWORKS_OSB4IDE) {
-		if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-			hwif->cbl = ata66_svwks(hwif);
-	}
+	if (dev->device != PCI_DEVICE_ID_SERVERWORKS_OSB4IDE)
+		hwif->cable_detect = ata66_svwks;
 }
 
 #define IDE_HFLAGS_SVWKS \
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -827,15 +827,14 @@ static void __devinit init_hwif_siimage(
 	} else
 		hwif->udma_filter = &sil_pata_udma_filter;
 
+	hwif->cable_detect = ata66_siimage;
+
 	if (hwif->dma_base == 0)
 		return;
 
 	if (sata)
 		hwif->host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
 
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = ata66_siimage(hwif);
-
 	if (hwif->mmio) {
 		hwif->ide_dma_test_irq = &siimage_mmio_ide_dma_test_irq;
 	} else {
Index: b/drivers/ide/pci/sis5513.c
===================================================================
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -565,13 +565,12 @@ static void __devinit init_hwif_sis5513 
 	if (chipset_family >= ATA_133)
 		hwif->udma_filter = sis5513_ata133_udma_filter;
 
+	hwif->cable_detect = ata66_sis5513;
+
 	if (hwif->dma_base == 0)
 		return;
 
 	hwif->ultra_mask = udma_rates[chipset_family];
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = ata66_sis5513(hwif);
 }
 
 static const struct ide_port_info sis5513_chipset __devinitdata = {
Index: b/drivers/ide/pci/slc90e66.c
===================================================================
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -118,23 +118,26 @@ static void slc90e66_set_dma_mode(ide_dr
 	}
 }
 
-static void __devinit init_hwif_slc90e66 (ide_hwif_t *hwif)
+static u8 __devinit slc90e66_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	u8 reg47 = 0;
-	u8 mask = hwif->channel ? 0x01 : 0x02;  /* bit0:Primary */
+	u8 reg47 = 0, mask = hwif->channel ? 0x01 : 0x02;
 
+	pci_read_config_byte(dev, 0x47, &reg47);
+
+	/* bit[0(1)]: 0:80, 1:40 */
+	return (reg47 & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
+}
+
+static void __devinit init_hwif_slc90e66(ide_hwif_t *hwif)
+{
 	hwif->set_pio_mode = &slc90e66_set_pio_mode;
 	hwif->set_dma_mode = &slc90e66_set_dma_mode;
 
-	pci_read_config_byte(dev, 0x47, &reg47);
-
 	if (hwif->dma_base == 0)
 		return;
 
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		/* bit[0(1)]: 0:80, 1:40 */
-		hwif->cbl = (reg47 & mask) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
+	hwif->cable_detect = slc90e66_cable_detect;
 }
 
 static const struct ide_port_info slc90e66_chipset __devinitdata = {
Index: b/drivers/ide/pci/tc86c001.c
===================================================================
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -160,6 +160,19 @@ static int tc86c001_busproc(ide_drive_t 
 	return 0;
 }
 
+static u8 __devinit tc86c001_cable_detect(ide_hwif_t *hwif)
+{
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+	unsigned long sc_base = pci_resource_start(dev, 5);
+	u16 scr1 = inw(sc_base + 0x00);
+
+	/*
+	 * System Control  1 Register bit 13 (PDIAGN):
+	 * 0=80-pin cable, 1=40-pin cable
+	 */
+	return (scr1 & 0x2000) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
+}
+
 static void __devinit init_hwif_tc86c001(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
@@ -183,6 +196,8 @@ static void __devinit init_hwif_tc86c001
 
 	hwif->busproc	= &tc86c001_busproc;
 
+	hwif->cable_detect = tc86c001_cable_detect;
+
 	if (!hwif->dma_base)
 		return;
 
@@ -196,15 +211,6 @@ static void __devinit init_hwif_tc86c001
 	hwif->rqsize	 = 0xffff;
 
 	hwif->dma_start 	= &tc86c001_dma_start;
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT) {
-		/*
-		 * System Control  1 Register bit 13 (PDIAGN):
-		 * 0=80-pin cable, 1=40-pin cable
-		 */
-		scr1 = inw(sc_base + 0x00);
-		hwif->cbl = (scr1 & 0x2000) ? ATA_CBL_PATA40 : ATA_CBL_PATA80;
-	}
 }
 
 static unsigned int __devinit init_chipset_tc86c001(struct pci_dev *dev,
Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -424,11 +424,7 @@ static void __devinit init_hwif_via82cxx
 	hwif->set_pio_mode = &via_set_pio_mode;
 	hwif->set_dma_mode = &via_set_drive;
 
-	if (!hwif->dma_base)
-		return;
-
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
-		hwif->cbl = via82cxxx_cable_detect(hwif);
+	hwif->cable_detect = via82cxxx_cable_detect;
 }
 
 static const struct ide_port_info via82cxxx_chipset __devinitdata = {
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -535,6 +535,8 @@ typedef struct hwif_s {
 	u8 (*mdma_filter)(ide_drive_t *);
 	u8 (*udma_filter)(ide_drive_t *);
 
+	u8 (*cable_detect)(struct hwif_s *);
+
 	void (*ata_input_data)(ide_drive_t *, void *, u32);
 	void (*ata_output_data)(ide_drive_t *, void *, u32);
 
