Return-Path: <linux-kernel-owner+w=401wt.eu-S1761528AbZBYUhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761528AbZBYUhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 15:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757535AbZBYUhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 15:37:01 -0500
Received: from havoc.gtf.org ([69.61.125.42]:45474 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756891AbZBYUg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 15:36:59 -0500
Date: Wed, 25 Feb 2009 15:36:57 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20090225203656.GA16221@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Notable notes:  Alan's two fixes haven't seen much testing, but they
really need to go in to work correctly with the 32bit PIO support
introduced in this release.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/pata_amd.c    |   76 +++++++++++++++++++++++++++++++++++----------
 drivers/ata/pata_it821x.c |    3 ++
 drivers/ata/pata_legacy.c |    7 ++--
 drivers/ata/sata_mv.c     |   20 +++++------
 4 files changed, 75 insertions(+), 31 deletions(-)

Alan Cox (2):
      [libata] pata_amd: program FIFO
      [libata] pata_legacy: for VLB 32bit PIO don't try tricks with slop

Mark Lord (1):
      sata_mv: fix SoC interrupt breakage

Ondrej Zary (1):
      pata_it821x: resume from hibernation fails with RAID volume

diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 63719ab..115b1cd 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -24,7 +24,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_amd"
-#define DRV_VERSION "0.3.11"
+#define DRV_VERSION "0.4.1"
 
 /**
  *	timing_setup		-	shared timing computation and load
@@ -145,6 +145,13 @@ static int amd_pre_reset(struct ata_link *link, unsigned long deadline)
 	return ata_sff_prereset(link, deadline);
 }
 
+/**
+ *	amd_cable_detect	-	report cable type
+ *	@ap: port
+ *
+ *	AMD controller/BIOS setups record the cable type in word 0x42
+ */
+
 static int amd_cable_detect(struct ata_port *ap)
 {
 	static const u32 bitmask[2] = {0x03, 0x0C};
@@ -158,6 +165,40 @@ static int amd_cable_detect(struct ata_port *ap)
 }
 
 /**
+ *	amd_fifo_setup		-	set the PIO FIFO for ATA/ATAPI
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Set the PCI fifo for this device according to the devices present
+ *	on the bus at this point in time. We need to turn the post write buffer
+ *	off for ATAPI devices as we may need to issue a word sized write to the
+ *	device as the final I/O
+ */
+
+static void amd_fifo_setup(struct ata_port *ap)
+{
+	struct ata_device *adev;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	static const u8 fifobit[2] = { 0xC0, 0x30};
+	u8 fifo = fifobit[ap->port_no];
+	u8 r;
+
+
+	ata_for_each_dev(adev, &ap->link, ENABLED) {
+		if (adev->class == ATA_DEV_ATAPI)
+			fifo = 0;
+	}
+	if (pdev->device == PCI_DEVICE_ID_AMD_VIPER_7411) /* FIFO is broken */
+		fifo = 0;
+
+	/* On the later chips the read prefetch bits become no-op bits */
+	pci_read_config_byte(pdev, 0x41, &r);
+	r &= ~fifobit[ap->port_no];
+	r |= fifo;
+	pci_write_config_byte(pdev, 0x41, r);
+}
+
+/**
  *	amd33_set_piomode	-	set initial PIO mode data
  *	@ap: ATA interface
  *	@adev: ATA device
@@ -167,21 +208,25 @@ static int amd_cable_detect(struct ata_port *ap)
 
 static void amd33_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
+	amd_fifo_setup(ap);
 	timing_setup(ap, adev, 0x40, adev->pio_mode, 1);
 }
 
 static void amd66_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
+	amd_fifo_setup(ap);
 	timing_setup(ap, adev, 0x40, adev->pio_mode, 2);
 }
 
 static void amd100_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
+	amd_fifo_setup(ap);
 	timing_setup(ap, adev, 0x40, adev->pio_mode, 3);
 }
 
 static void amd133_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
+	amd_fifo_setup(ap);
 	timing_setup(ap, adev, 0x40, adev->pio_mode, 4);
 }
 
@@ -397,6 +442,16 @@ static struct ata_port_operations nv133_port_ops = {
 	.set_dmamode	= nv133_set_dmamode,
 };
 
+static void amd_clear_fifo(struct pci_dev *pdev)
+{
+	u8 fifo;
+	/* Disable the FIFO, the FIFO logic will re-enable it as
+	   appropriate */
+	pci_read_config_byte(pdev, 0x41, &fifo);
+	fifo &= 0x0F;
+	pci_write_config_byte(pdev, 0x41, fifo);
+}
+
 static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info[10] = {
@@ -503,14 +558,8 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	if (type < 3)
 		ata_pci_bmdma_clear_simplex(pdev);
-
-	/* Check for AMD7411 */
-	if (type == 3)
-		/* FIFO is broken */
-		pci_write_config_byte(pdev, 0x41, fifo & 0x0F);
-	else
-		pci_write_config_byte(pdev, 0x41, fifo | 0xF0);
-
+	if (pdev->vendor == PCI_VENDOR_ID_AMD)
+		amd_clear_fifo(pdev);
 	/* Cable detection on Nvidia chips doesn't work too well,
 	 * cache BIOS programmed UDMA mode.
 	 */
@@ -536,18 +585,11 @@ static int amd_reinit_one(struct pci_dev *pdev)
 		return rc;
 
 	if (pdev->vendor == PCI_VENDOR_ID_AMD) {
-		u8 fifo;
-		pci_read_config_byte(pdev, 0x41, &fifo);
-		if (pdev->device == PCI_DEVICE_ID_AMD_VIPER_7411)
-			/* FIFO is broken */
-			pci_write_config_byte(pdev, 0x41, fifo & 0x0F);
-		else
-			pci_write_config_byte(pdev, 0x41, fifo | 0xF0);
+		amd_clear_fifo(pdev);
 		if (pdev->device == PCI_DEVICE_ID_AMD_VIPER_7409 ||
 		    pdev->device == PCI_DEVICE_ID_AMD_COBRA_7401)
 			ata_pci_bmdma_clear_simplex(pdev);
 	}
-
 	ata_host_resume(host);
 	return 0;
 }
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index f1bb2f9..b05b86a 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -557,6 +557,9 @@ static unsigned int it821x_read_id(struct ata_device *adev,
 		id[83] |= 0x4400;	/* Word 83 is valid and LBA48 */
 		id[86] |= 0x0400;	/* LBA48 on */
 		id[ATA_ID_MAJOR_VER] |= 0x1F;
+		/* Clear the serial number because it's different each boot
+		   which breaks validation on resume */
+		memset(&id[ATA_ID_SERNO], 0x20, ATA_ID_SERNO_LEN);
 	}
 	return err_mask;
 }
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 6c1d778..e3bc1b4 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -283,9 +283,10 @@ static void pdc20230_set_piomode(struct ata_port *ap, struct ata_device *adev)
 static unsigned int pdc_data_xfer_vlb(struct ata_device *dev,
 			unsigned char *buf, unsigned int buflen, int rw)
 {
-	if (ata_id_has_dword_io(dev->id)) {
+	int slop = buflen & 3;
+	/* 32bit I/O capable *and* we need to write a whole number of dwords */
+	if (ata_id_has_dword_io(dev->id) && (slop == 0 || slop == 3)) {
 		struct ata_port *ap = dev->link->ap;
-		int slop = buflen & 3;
 		unsigned long flags;
 
 		local_irq_save(flags);
@@ -735,7 +736,7 @@ static unsigned int vlb32_data_xfer(struct ata_device *adev, unsigned char *buf,
 	struct ata_port *ap = adev->link->ap;
 	int slop = buflen & 3;
 
-	if (ata_id_has_dword_io(adev->id)) {
+	if (ata_id_has_dword_io(adev->id) && (slop == 0 || slop == 3)) {
 		if (rw == WRITE)
 			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
 		else
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 4ae1a41..7007edd 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -3114,19 +3114,17 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 		writelfl(0, hc_mmio + HC_IRQ_CAUSE_OFS);
 	}
 
-	if (!IS_SOC(hpriv)) {
-		/* Clear any currently outstanding host interrupt conditions */
-		writelfl(0, mmio + hpriv->irq_cause_ofs);
+	/* Clear any currently outstanding host interrupt conditions */
+	writelfl(0, mmio + hpriv->irq_cause_ofs);
 
-		/* and unmask interrupt generation for host regs */
-		writelfl(hpriv->unmask_all_irqs, mmio + hpriv->irq_mask_ofs);
+	/* and unmask interrupt generation for host regs */
+	writelfl(hpriv->unmask_all_irqs, mmio + hpriv->irq_mask_ofs);
 
-		/*
-		 * enable only global host interrupts for now.
-		 * The per-port interrupts get done later as ports are set up.
-		 */
-		mv_set_main_irq_mask(host, 0, PCI_ERR);
-	}
+	/*
+	 * enable only global host interrupts for now.
+	 * The per-port interrupts get done later as ports are set up.
+	 */
+	mv_set_main_irq_mask(host, 0, PCI_ERR);
 done:
 	return rc;
 }
