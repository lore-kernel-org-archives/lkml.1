Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbXKFAEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbXKFAEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 19:04:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755726AbXKFADx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 19:03:53 -0500
Received: from havoc.gtf.org ([69.61.125.42]:42894 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076AbXKFADv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 19:03:51 -0500
Date: Mon, 5 Nov 2007 19:03:50 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20071106000350.GA13094@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ata_piix.c         |    1 +
 drivers/ata/libata-core.c      |   39 ++++++++++++++++++++++++-------
 drivers/ata/pata_hpt37x.c      |   49 +++++++++++++++++++++++++++++----------
 drivers/ata/pata_serverworks.c |   11 ++++-----
 include/linux/ata.h            |   11 +++++++++
 include/linux/libata.h         |    1 +
 6 files changed, 84 insertions(+), 28 deletions(-)

Alan Cox (4):
      pata_serverworks: Fix problem with some drive combinations
      ata_piix: Add additional PCI identifier for 40 wire short cable
      pata_hpt37x: Fix outstanding bug reports on the HPT374 and 37x cable detect
      libata: handle broken cable reporting

Geert Uytterhoeven (1):
      libata and bogus LBA48 drives

Kristen Carlson Accardi (1):
      libata: Don't disable dipm with SET FEATURES

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index a4b2cb2..f08cca2 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -621,6 +621,7 @@ struct ich_laptop {
 static const struct ich_laptop ich_laptop[] = {
 	/* devid, subvendor, subdev */
 	{ 0x27DF, 0x0005, 0x0280 },	/* ICH7 on Acer 5602WLMi */
+	{ 0x27DF, 0x1025, 0x0102 },	/* ICH7 on Acer 5602aWLMi */
 	{ 0x27DF, 0x1025, 0x0110 },	/* ICH7 on Acer 3682WLMi */
 	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
 	{ 0x27DF, 0x103C, 0x30A1 },	/* ICH7 on HP Compaq nc2400 */
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 164c7d9..ec3ce12 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -676,10 +676,11 @@ static int ata_dev_set_dipm(struct ata_device *dev, enum link_pm policy)
 		if (rc)
 			return rc;
 
-		/* disable DIPM */
-		if (ata_dev_enabled(dev) && (dev->flags & ATA_DFLAG_DIPM))
-			err_mask = ata_dev_set_feature(dev,
-					SETFEATURES_SATA_DISABLE, SATA_DIPM);
+		/*
+		 * we don't have to disable DIPM since IPM flags
+		 * disallow transitions to SLUMBER, which effectively
+		 * disable DIPM if it does not support PARTIAL
+		 */
 		break;
 	case NOT_AVAILABLE:
 	case MAX_PERFORMANCE:
@@ -689,10 +690,11 @@ static int ata_dev_set_dipm(struct ata_device *dev, enum link_pm policy)
 		if (rc)
 			return rc;
 
-		/* disable DIPM */
-		if (ata_dev_enabled(dev) && (dev->flags & ATA_DFLAG_DIPM))
-			err_mask = ata_dev_set_feature(dev,
-					SETFEATURES_SATA_DISABLE, SATA_DIPM);
+		/*
+		 * we don't have to disable DIPM since IPM flags
+		 * disallow all transitions which effectively
+		 * disable DIPM anyway.
+		 */
 		break;
 	}
 
@@ -4239,6 +4241,10 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "ST340823A",		NULL,		ATA_HORKAGE_HPA_SIZE, },
 	{ "ST320413A",		NULL,		ATA_HORKAGE_HPA_SIZE, },
 
+	/* Devices which get the IVB wrong */
+	{ "QUANTUM FIREBALLlct10 05", "A03.0900", ATA_HORKAGE_IVB, },
+	{ "TSSTcorp CDDVDW SH-S202J", "SB00",	  ATA_HORKAGE_IVB, },
+
 	/* End Marker */
 	{ }
 };
@@ -4300,6 +4306,21 @@ static int ata_dma_blacklisted(const struct ata_device *dev)
 }
 
 /**
+ *	ata_is_40wire		-	check drive side detection
+ *	@dev: device
+ *
+ *	Perform drive side detection decoding, allowing for device vendors
+ *	who can't follow the documentation.
+ */
+
+static int ata_is_40wire(struct ata_device *dev)
+{
+	if (dev->horkage & ATA_HORKAGE_IVB)
+		return ata_drive_40wire_relaxed(dev->id);
+	return ata_drive_40wire(dev->id);
+}
+
+/**
  *	ata_dev_xfermask - Compute supported xfermask of the given device
  *	@dev: Device to compute xfermask for
  *
@@ -4368,7 +4389,7 @@ static void ata_dev_xfermask(struct ata_device *dev)
 	if (xfer_mask & (0xF8 << ATA_SHIFT_UDMA))
 		/* UDMA/44 or higher would be available */
 		if ((ap->cbl == ATA_CBL_PATA40) ||
-		    (ata_drive_40wire(dev->id) &&
+		    (ata_is_40wire(dev) &&
 		    (ap->cbl == ATA_CBL_PATA_UNK ||
 		     ap->cbl == ATA_CBL_PATA80))) {
 			ata_dev_printk(dev, KERN_WARNING,
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index e61cb1f..3816b86 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -295,7 +295,7 @@ static unsigned long hpt370_filter(struct ata_device *adev, unsigned long mask)
 
 static unsigned long hpt370a_filter(struct ata_device *adev, unsigned long mask)
 {
-	if (adev->class != ATA_DEV_ATA) {
+	if (adev->class == ATA_DEV_ATA) {
 		if (hpt_dma_blacklisted(adev, "UDMA100", bad_ata100_5))
 			mask &= ~ (0x1F << ATA_SHIFT_UDMA);
 	}
@@ -359,28 +359,25 @@ static int hpt374_pre_reset(struct ata_link *link, unsigned long deadline)
 		{ 0x50, 1, 0x04, 0x04 },
 		{ 0x54, 1, 0x04, 0x04 }
 	};
-	u16 mcr3, mcr6;
+	u16 mcr3;
 	u8 ata66;
 	struct ata_port *ap = link->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	unsigned int mcrbase = 0x50 + 4 * ap->port_no;
 
 	if (!pci_test_config_bits(pdev, &hpt37x_enable_bits[ap->port_no]))
 		return -ENOENT;
 
 	/* Do the extra channel work */
-	pci_read_config_word(pdev, 0x52, &mcr3);
-	pci_read_config_word(pdev, 0x56, &mcr6);
+	pci_read_config_word(pdev, mcrbase + 2, &mcr3);
 	/* Set bit 15 of 0x52 to enable TCBLID as input
-	   Set bit 15 of 0x56 to enable FCBLID as input
 	 */
-	pci_write_config_word(pdev, 0x52, mcr3 | 0x8000);
-	pci_write_config_word(pdev, 0x56, mcr6 | 0x8000);
+	pci_write_config_word(pdev, mcrbase + 2, mcr3 | 0x8000);
 	pci_read_config_byte(pdev, 0x5A, &ata66);
 	/* Reset TCBLID/FCBLID to output */
 	pci_write_config_word(pdev, 0x52, mcr3);
-	pci_write_config_word(pdev, 0x56, mcr6);
 
-	if (ata66 & (1 << ap->port_no))
+	if (ata66 & (2 >> ap->port_no))
 		ap->cbl = ATA_CBL_PATA40;
 	else
 		ap->cbl = ATA_CBL_PATA80;
@@ -844,6 +841,25 @@ static int hpt37x_calibrate_dpll(struct pci_dev *dev)
 	/* Never went stable */
 	return 0;
 }
+
+static u32 hpt374_read_freq(struct pci_dev *pdev)
+{
+	u32 freq;
+	unsigned long io_base = pci_resource_start(pdev, 4);
+	if (PCI_FUNC(pdev->devfn) & 1) {
+		struct pci_dev *pdev_0 = pci_get_slot(pdev->bus, pdev->devfn - 1);
+		/* Someone hot plugged the controller on us ? */
+		if (pdev_0 == NULL)
+			return 0;
+		io_base = pci_resource_start(pdev_0, 4);
+		freq = inl(io_base + 0x90);
+		pci_dev_put(pdev_0);
+	}
+	else
+		freq = inl(io_base + 0x90);
+	return freq;
+}
+
 /**
  *	hpt37x_init_one		-	Initialise an HPT37X/302
  *	@dev: PCI device
@@ -902,7 +918,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x0f,
+		.udma_mask = ATA_UDMA5,
 		.port_ops = &hpt370_port_ops
 	};
 	/* HPT370A - UDMA100 */
@@ -911,7 +927,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x0f,
+		.udma_mask = ATA_UDMA5,
 		.port_ops = &hpt370a_port_ops
 	};
 	/* HPT371, 372 and friends - UDMA133 */
@@ -1047,9 +1063,16 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		outb(0x0e, iobase + 0x9c);
 
 	/* Some devices do not let this value be accessed via PCI space
-	   according to the old driver */
+	   according to the old driver. In addition we must use the value
+	   from FN 0 on the HPT374 */
+
+	if (chip_table == &hpt374) {
+		freq = hpt374_read_freq(dev);
+		if (freq == 0)
+			return -ENODEV;
+	} else
+		freq = inl(iobase + 0x90);
 
-	freq = inl(iobase + 0x90);
 	if ((freq >> 12) != 0xABCDE) {
 		int i;
 		u8 sr;
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index df68806..8bed888 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -274,28 +274,27 @@ static void serverworks_set_dmamode(struct ata_port *ap, struct ata_device *adev
 {
 	static const u8 dma_mode[] = { 0x77, 0x21, 0x20 };
 	int offset = 1 + 2 * ap->port_no - adev->devno;
-	int devbits = (2 * ap->port_no + adev->devno);
+	int devbits = 2 * ap->port_no + adev->devno;
 	u8 ultra;
 	u8 ultra_cfg;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
 	pci_read_config_byte(pdev, 0x54, &ultra_cfg);
+	pci_read_config_byte(pdev, 0x56 + ap->port_no, &ultra);
+	ultra &= ~(0x0F << (adev->devno * 4));
 
 	if (adev->dma_mode >= XFER_UDMA_0) {
 		pci_write_config_byte(pdev, 0x44 + offset,  0x20);
 
-		pci_read_config_byte(pdev, 0x56 + ap->port_no, &ultra);
-		ultra &= ~(0x0F << (ap->port_no * 4));
 		ultra |= (adev->dma_mode - XFER_UDMA_0)
-					<< (ap->port_no * 4);
-		pci_write_config_byte(pdev, 0x56 + ap->port_no, ultra);
-
+					<< (adev->devno * 4);
 		ultra_cfg |=  (1 << devbits);
 	} else {
 		pci_write_config_byte(pdev, 0x44 + offset,
 			dma_mode[adev->dma_mode - XFER_MW_DMA_0]);
 		ultra_cfg &= ~(1 << devbits);
 	}
+	pci_write_config_byte(pdev, 0x56 + ap->port_no, ultra);
 	pci_write_config_byte(pdev, 0x54, ultra_cfg);
 }
 
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 61535e7..5c4e54a 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -425,6 +425,8 @@ static inline int ata_id_has_lba48(const u16 *id)
 {
 	if ((id[83] & 0xC000) != 0x4000)
 		return 0;
+	if (!ata_id_u64(id, 100))
+		return 0;
 	return id[83] & (1 << 10);
 }
 
@@ -535,6 +537,15 @@ static inline int ata_drive_40wire(const u16 *dev_id)
 	return 1;
 }
 
+static inline int ata_drive_40wire_relaxed(const u16 *dev_id)
+{
+	if (ata_id_is_sata(dev_id))
+		return 0;	/* SATA */
+	if ((dev_id[93] & 0x2000) == 0x2000)
+		return 0;	/* 80 wire */
+	return 1;
+}
+
 static inline int atapi_cdb_len(const u16 *dev_id)
 {
 	u16 tmp = dev_id[0] & 0x3;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 1e27785..56a5673 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -339,6 +339,7 @@ enum {
 	ATA_HORKAGE_SKIP_PM	= (1 << 5),	/* Skip PM operations */
 	ATA_HORKAGE_HPA_SIZE	= (1 << 6),	/* native size off by one */
 	ATA_HORKAGE_IPM		= (1 << 7),	/* Link PM problems */
+	ATA_HORKAGE_IVB		= (1 << 8),	/* cbl det validity bit bugs */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
