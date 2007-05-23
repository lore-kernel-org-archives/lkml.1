Return-Path: <linux-kernel-owner+w=401wt.eu-S934528AbXEWOHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934528AbXEWOHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 10:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764440AbXEWOHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 10:07:24 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34520 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763224AbXEWOHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 10:07:21 -0400
Date: Wed, 23 May 2007 15:12:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH] Be more paranoid about controller setup and initial setup
 (for testing)
Message-ID: <20070523151215.768561d0@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'd be interested in feedback on the effects of the following
particularly on systems that currently fail with libata, and especially
on non-PC systems where the firmware hasn't neccessarily initialized the
disk before Linux takes control

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/drivers/ata/libata-core.c linux-2.6.22-rc1-mm1/drivers/ata/libata-core.c
--- linux.vanilla-2.6.22-rc1-mm1/drivers/ata/libata-core.c	2007-05-18 16:22:53.000000000 +0100
+++ linux-2.6.22-rc1-mm1/drivers/ata/libata-core.c	2007-05-23 14:39:00.567356504 +0100
@@ -3099,6 +3109,7 @@
 			     unsigned long deadline)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
+	int i;
 
 	DPRINTK("ata%u: bus reset via SRST\n", ap->print_id);
 
@@ -3120,6 +3131,27 @@
 	 * Old drivers/ide uses the 2mS rule and then waits for ready
 	 */
 	msleep(150);
+	
+	/* If we issued an SRST then an ATA drive (not ATAPI)
+	 * may have changed configuration and be in PIO0 timing. If
+	 * we did a hard reset (or are coming from power on) this is
+	 * true for ATA or ATAPI. Until we've set a suitable controller
+	 * mode we should not touch the bus as we may be talking too fast.
+	 */
+
+	for (i = 0; i < ATA_MAX_DEVICES; i++)
+		ap->device[i].pio_mode = XFER_PIO_0;
+
+	/* If the controller has a pio mode setup function then use
+	   it to set the chipset to rights. Don't touch the DMA setup
+	   as that will be dealt with when revalidating */
+	if (ap->ops->set_piomode) {
+		for (i = 0; i < ATA_MAX_DEVICES; i++) {
+			if (devmask & (1 << i))
+				ap->ops->set_piomode(ap, &ap->device[i]);
+		}
+	}
+
 
 	/* Before we perform post reset processing we want to see if
 	 * the bus shows 0xFF because the odd clown forgets the D7
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/drivers/ata/pata_sis.c linux-2.6.22-rc1-mm1/drivers/ata/pata_sis.c
--- linux.vanilla-2.6.22-rc1-mm1/drivers/ata/pata_sis.c	2007-05-18 16:21:46.000000000 +0100
+++ linux-2.6.22-rc1-mm1/drivers/ata/pata_sis.c	2007-05-23 14:38:11.006890840 +0100
@@ -73,14 +73,14 @@
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
@@ -149,6 +149,9 @@
 	if (!pci_test_config_bits(pdev, &sis_enable_bits[ap->port_no]))
 		return -ENOENT;
 
+	/* Clear the FIFO settings. We can't enable the FIFO until
+	   we know we are poking at a disk */
+	pci_write_config_byte(pdev, 0x4B, 0);
 	return ata_std_prereset(ap, deadline);
 }
 
@@ -211,7 +214,7 @@
 static void sis_old_set_piomode (struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
-	int port = sis_port_base(adev);
+	int port = sis_old_port_base(adev);
 	u8 t1, t2;
 	int speed = adev->pio_mode - XFER_PIO_0;
 
@@ -248,7 +251,7 @@
 static void sis_100_set_piomode (struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
-	int port = sis_port_base(adev);
+	int port = sis_old_port_base(adev);
 	int speed = adev->pio_mode - XFER_PIO_0;
 
 	const u8 actrec[] = { 0x00, 0x67, 0x44, 0x33, 0x31 };
@@ -328,7 +331,7 @@
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
-	int drive_pci = sis_port_base(adev);
+	int drive_pci = sis_old_port_base(adev);
 	u16 timing;
 
 	const u16 mwdma_bits[] = { 0x707, 0x202, 0x202 };
@@ -367,7 +370,7 @@
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
-	int drive_pci = sis_port_base(adev);
+	int drive_pci = sis_old_port_base(adev);
 	u16 timing;
 
 	const u16 mwdma_bits[] = { 0x707, 0x202, 0x202 };
@@ -378,12 +381,12 @@
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
@@ -405,22 +408,22 @@
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
-	int drive_pci = sis_port_base(adev);
-	u16 timing;
+	int drive_pci = sis_old_port_base(adev);
+	u8 timing;
 
-	const u16 udma_bits[]  = { 0x8B00, 0x8700, 0x8500, 0x8300, 0x8200, 0x8100};
+	const u16 udma_bits[]  = { 0x8B, 0x87, 0x85, 0x83, 0x82, 0x81};
 
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
@@ -440,22 +443,22 @@
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
