Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbXEYAlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbXEYAlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 20:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbXEYAlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 20:41:14 -0400
Received: from havoc.gtf.org ([69.61.125.42]:55670 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbXEYAlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 20:41:12 -0400
Date: Thu, 24 May 2007 20:41:09 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070525004109.GA10496@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ata_piix.c     |    1 +
 drivers/ata/libata-core.c  |    4 +-
 drivers/ata/pata_hpt3x2n.c |    4 +-
 drivers/ata/pata_sis.c     |   46 ++++++++++++++++++++++----------------------
 drivers/ata/pata_via.c     |   29 +++++++++++++++++++++++++++
 5 files changed, 57 insertions(+), 27 deletions(-)

Alan Cox (3):
      hpt3x2n: Correct revision boundary
      pata_sis: Fix and clean up some timing setups
      pata_via: Handle laptops via DMI

Tejun Heo (3):
      ata_piix: add short 40c quirk for Acer Aspire 2030, take #2
      libata: don't consider 0xff as port empty if SStatus is available
      libata: -ENODEV during prereset isn't an error

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 0458811..9c07b88 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -578,6 +578,7 @@ static const struct ich_laptop ich_laptop[] = {
 	{ 0x27DF, 0x0005, 0x0280 },	/* ICH7 on Acer 5602WLMi */
 	{ 0x27DF, 0x1025, 0x0110 },	/* ICH7 on Acer 3682WLMi */
 	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
+	{ 0x24CA, 0x1025, 0x0061 },	/* ICH4 on ACER Aspire 2023WLMi */
 	/* end marker */
 	{ 0, }
 };
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index a6de57e..3ca9c61 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3022,7 +3022,7 @@ int ata_wait_ready(struct ata_port *ap, unsigned long deadline)
 
 		if (!(status & ATA_BUSY))
 			return 0;
-		if (status == 0xff)
+		if (!ata_port_online(ap) && status == 0xff)
 			return -ENODEV;
 		if (time_after(now, deadline))
 			return -EBUSY;
@@ -3368,7 +3368,7 @@ int ata_std_prereset(struct ata_port *ap, unsigned long deadline)
 	 */
 	if (!(ap->flags & ATA_FLAG_SKIP_D2H_BSY) && !ata_port_offline(ap)) {
 		rc = ata_wait_ready(ap, deadline);
-		if (rc) {
+		if (rc && rc != -ENODEV) {
 			ata_port_printk(ap, KERN_WARNING, "device not ready "
 					"(errno=%d), forcing hardreset\n", rc);
 			ehc->i.action |= ATA_EH_HARDRESET;
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index f25154a..e947433 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -521,8 +521,8 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 			/* 371N if rev > 1 */
 			break;
 		case PCI_DEVICE_ID_TTI_HPT372:
-			/* 372N if rev >= 1*/
-			if (class_rev == 0)
+			/* 372N if rev >= 2*/
+			if (class_rev < 2)
 				return -ENODEV;
 			break;
 		case PCI_DEVICE_ID_TTI_HPT302:
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index f223126..ec3ae93 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -73,14 +73,14 @@ static int sis_short_ata40(struct pci_dev *dev)
 }
 
 /**
- *	sis_port_base		-	return PCI configuration base for dev
+ *	sis_old_port_base		-	return PCI configuration base for dev
  *	@adev: device
  *
  *	Returns the base of the PCI configuration registers for this port
  *	number.
  */
 
-static int sis_port_base(struct ata_device *adev)
+static int sis_old_port_base(struct ata_device *adev)
 {
 	return  0x40 + (4 * adev->ap->port_no) +  (2 * adev->devno);
 }
@@ -211,7 +211,7 @@ static void sis_set_fifo(struct ata_port *ap, struct ata_device *adev)
 static void sis_old_set_piomode (struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
-	int port = sis_port_base(adev);
+	int port = sis_old_port_base(adev);
 	u8 t1, t2;
 	int speed = adev->pio_mode - XFER_PIO_0;
 
@@ -248,7 +248,7 @@ static void sis_old_set_piomode (struct ata_port *ap, struct ata_device *adev)
 static void sis_100_set_piomode (struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
-	int port = sis_port_base(adev);
+	int port = sis_old_port_base(adev);
 	int speed = adev->pio_mode - XFER_PIO_0;
 
 	const u8 actrec[] = { 0x00, 0x67, 0x44, 0x33, 0x31 };
@@ -328,7 +328,7 @@ static void sis_old_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
-	int drive_pci = sis_port_base(adev);
+	int drive_pci = sis_old_port_base(adev);
 	u16 timing;
 
 	const u16 mwdma_bits[] = { 0x707, 0x202, 0x202 };
@@ -367,7 +367,7 @@ static void sis_66_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
-	int drive_pci = sis_port_base(adev);
+	int drive_pci = sis_old_port_base(adev);
 	u16 timing;
 
 	const u16 mwdma_bits[] = { 0x707, 0x202, 0x202 };
@@ -378,12 +378,12 @@ static void sis_66_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	if (adev->dma_mode < XFER_UDMA_0) {
 		/* bits 3-0 hold recovery timing bits 8-10 active timing and
 		   the higer bits are dependant on the device, bit 15 udma */
-		timing &= ~ 0x870F;
+		timing &= ~0x870F;
 		timing |= mwdma_bits[speed];
 	} else {
 		/* Bit 15 is UDMA on/off, bit 12-14 are cycle time */
 		speed = adev->dma_mode - XFER_UDMA_0;
-		timing &= ~0x6000;
+		timing &= ~0xF000;
 		timing |= udma_bits[speed];
 	}
 	pci_write_config_word(pdev, drive_pci, timing);
@@ -405,22 +405,22 @@ static void sis_100_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
-	int drive_pci = sis_port_base(adev);
-	u16 timing;
+	int drive_pci = sis_old_port_base(adev);
+	u8 timing;
 
-	const u16 udma_bits[]  = { 0x8B00, 0x8700, 0x8500, 0x8300, 0x8200, 0x8100};
+	const u8 udma_bits[]  = { 0x8B, 0x87, 0x85, 0x83, 0x82, 0x81};
 
-	pci_read_config_word(pdev, drive_pci, &timing);
+	pci_read_config_byte(pdev, drive_pci + 1, &timing);
 
 	if (adev->dma_mode < XFER_UDMA_0) {
 		/* NOT SUPPORTED YET: NEED DATA SHEET. DITTO IN OLD DRIVER */
 	} else {
-		/* Bit 15 is UDMA on/off, bit 12-14 are cycle time */
+		/* Bit 7 is UDMA on/off, bit 0-3 are cycle time */
 		speed = adev->dma_mode - XFER_UDMA_0;
-		timing &= ~0x0F00;
+		timing &= ~0x8F;
 		timing |= udma_bits[speed];
 	}
-	pci_write_config_word(pdev, drive_pci, timing);
+	pci_write_config_byte(pdev, drive_pci + 1, timing);
 }
 
 /**
@@ -440,22 +440,22 @@ static void sis_133_early_set_dmamode (struct ata_port *ap, struct ata_device *a
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
-	int drive_pci = sis_port_base(adev);
-	u16 timing;
-
-	static const u16 udma_bits[]  = { 0x8F00, 0x8A00, 0x8700, 0x8500, 0x8300, 0x8200, 0x8100};
+	int drive_pci = sis_old_port_base(adev);
+	u8 timing;
+	/* Low 4 bits are timing */
+	static const u8 udma_bits[]  = { 0x8F, 0x8A, 0x87, 0x85, 0x83, 0x82, 0x81};
 
-	pci_read_config_word(pdev, drive_pci, &timing);
+	pci_read_config_byte(pdev, drive_pci + 1, &timing);
 
 	if (adev->dma_mode < XFER_UDMA_0) {
 		/* NOT SUPPORTED YET: NEED DATA SHEET. DITTO IN OLD DRIVER */
 	} else {
-		/* Bit 15 is UDMA on/off, bit 12-14 are cycle time */
+		/* Bit 7 is UDMA on/off, bit 0-3 are cycle time */
 		speed = adev->dma_mode - XFER_UDMA_0;
-		timing &= ~0x0F00;
+		timing &= ~0x8F;
 		timing |= udma_bits[speed];
 	}
-	pci_write_config_word(pdev, drive_pci, timing);
+	pci_write_config_byte(pdev, drive_pci + 1, timing);
 }
 
 /**
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index e4c71f7..708dfc0 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -60,6 +60,7 @@
 #include <linux/delay.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
+#include <linux/dmi.h>
 
 #define DRV_NAME "pata_via"
 #define DRV_VERSION "0.3.1"
@@ -122,6 +123,31 @@ static const struct via_isa_bridge {
 	{ NULL }
 };
 
+
+/*
+ *	Cable special cases
+ */
+
+static struct dmi_system_id cable_dmi_table[] = {
+	{
+		.ident = "Acer Ferrari 3400",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Acer,Inc."),
+			DMI_MATCH(DMI_BOARD_NAME, "Ferrari 3400"),
+		},
+	},
+	{ }
+};
+
+static int via_cable_override(struct pci_dev *pdev)
+{
+	/* Systems by DMI */
+	if (dmi_check_system(cable_dmi_table))
+		return 1;
+	return 0;
+}
+
+
 /**
  *	via_cable_detect	-	cable detection
  *	@ap: ATA port
@@ -139,6 +165,9 @@ static int via_cable_detect(struct ata_port *ap) {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u32 ata66;
 
+	if (via_cable_override(pdev))
+		return ATA_CBL_PATA40_SHORT;
+
 	/* Early chips are 40 wire */
 	if ((config->flags & VIA_UDMA) < VIA_UDMA_66)
 		return ATA_CBL_PATA40;
