Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbZKQPHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbZKQPHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZKQPHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:07:30 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40515 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754191AbZKQPHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:07:25 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/5] pata_sis: Implement MWDMA for the UDMA 133 capable chips
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Date: Tue, 17 Nov 2009 14:51:17 +0000
Message-ID: <20091117145111.15430.67106.stgit@localhost.localdomain>
In-Reply-To: <20091117144450.15430.83450.stgit@localhost.localdomain>
References: <20091117144450.15430.83450.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej pointed out that while this got fixed in the old driver whoever
did it didn't port it across.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/ata/pata_sis.c |   91 ++++++++++++++++++++++++++++++++++++------------
 1 files changed, 69 insertions(+), 22 deletions(-)


diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 488e77b..d70ecec 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -252,24 +252,25 @@ static void sis_100_set_piomode (struct ata_port *ap, struct ata_device *adev)
 }
 
 /**
- *	sis_133_set_piomode - Initialize host controller PATA PIO timings
+ *	sis_133_do_piomode - Initialize host controller PATA PIO/DMA timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device we are configuring for.
  *
  *	Set PIO mode for device, in host controller PCI config space. This
- *	function handles PIO set up for the later ATA133 devices.
+ *	function handles PIO set up for the later ATA133 devices. The same
+ *	timings are used for MWDMA.
  *
  *	LOCKING:
  *	None (inherited from caller).
  */
 
-static void sis_133_set_piomode (struct ata_port *ap, struct ata_device *adev)
+static void sis_133_do_piomode(struct ata_port *ap, struct ata_device *adev,
+					int speed)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int port = 0x40;
 	u32 t1;
 	u32 reg54;
-	int speed = adev->pio_mode - XFER_PIO_0;
 
 	const u32 timing133[] = {
 		0x28269000,	/* Recovery << 24 | Act << 16 | Ini << 12 */
@@ -305,6 +306,42 @@ static void sis_133_set_piomode (struct ata_port *ap, struct ata_device *adev)
 }
 
 /**
+ *	sis_133_set_piomode - Initialize host controller PATA PIO timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: Device we are configuring for.
+ *
+ *	Set PIO mode for device, in host controller PCI config space. This
+ *	function handles PIO set up for the later ATA133 devices.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void sis_133_set_piomode (struct ata_port *ap, struct ata_device *adev)
+{
+
+	sis_133_do_piomode(ap, adev, adev->pio_mode - XFER_PIO_0);
+}
+
+/**
+ *	mwdma_clip_to_pio		-	clip MWDMA mode
+ *	@adev: device
+ *
+ *	As the SiS shared MWDMA and PIO timings we must program the equivalent
+ *	PIO timing for the MWDMA mode but we must not program one higher than
+ *	the permitted PIO timing of the device.
+ */
+
+static int mwdma_clip_to_pio(struct ata_device *adev)
+{
+	const int mwdma_to_pio[3] = {
+		XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
+	};
+	return min(mwdma_to_pio[adev->dma_mode - XFER_MW_DMA_0],
+				adev->pio_mode - XFER_PIO_0);
+}
+
+/**
  *	sis_old_set_dmamode - Initialize host controller PATA DMA timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device to program
@@ -332,6 +369,7 @@ static void sis_old_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	if (adev->dma_mode < XFER_UDMA_0) {
 		/* bits 3-0 hold recovery timing bits 8-10 active timing and
 		   the higher bits are dependant on the device */
+		speed = mwdma_clip_to_pio(adev);
 		timing &= ~0x870F;
 		timing |= mwdma_bits[speed];
 	} else {
@@ -372,6 +410,7 @@ static void sis_66_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	if (adev->dma_mode < XFER_UDMA_0) {
 		/* bits 3-0 hold recovery timing bits 8-10 active timing and
 		   the higher bits are dependant on the device, bit 15 udma */
+		speed = mwdma_clip_to_pio(adev);
 		timing &= ~0x870F;
 		timing |= mwdma_bits[speed];
 	} else {
@@ -389,7 +428,7 @@ static void sis_66_set_dmamode (struct ata_port *ap, struct ata_device *adev)
  *	@adev: Device to program
  *
  *	Set UDMA/MWDMA mode for device, in host controller PCI config space.
- *	Handles UDMA66 and early UDMA100 devices.
+ *	Handles later UDMA100 devices.
  *
  *	LOCKING:
  *	None (inherited from caller).
@@ -400,21 +439,25 @@ static void sis_100_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
 	int drive_pci = sis_old_port_base(adev);
-	u8 timing;
+	u16 timing;
 
-	const u8 udma_bits[]  = { 0x8B, 0x87, 0x85, 0x83, 0x82, 0x81};
+	const u16 udma_bits[]  = {
+		0x8B00, 0x8700, 0x8500, 0x8300, 0x8200, 0x8100};
+	const u8 mwdma_bits[] = { 0x08, 0x32, 0x31 };
 
-	pci_read_config_byte(pdev, drive_pci + 1, &timing);
+	pci_read_config_word(pdev, drive_pci, &timing);
 
 	if (adev->dma_mode < XFER_UDMA_0) {
-		/* NOT SUPPORTED YET: NEED DATA SHEET. DITTO IN OLD DRIVER */
+		speed = mwdma_clip_to_pio(adev);
+		timing &= ~0x80FF;
+		timing |= mwdma_bits[speed];
 	} else {
 		/* Bit 7 is UDMA on/off, bit 0-3 are cycle time */
 		speed = adev->dma_mode - XFER_UDMA_0;
-		timing &= ~0x8F;
+		timing &= ~0x8F00;
 		timing |= udma_bits[speed];
 	}
-	pci_write_config_byte(pdev, drive_pci + 1, timing);
+	pci_write_config_word(pdev, drive_pci, timing);
 }
 
 /**
@@ -434,21 +477,26 @@ static void sis_133_early_set_dmamode (struct ata_port *ap, struct ata_device *a
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
 	int drive_pci = sis_old_port_base(adev);
-	u8 timing;
-	/* Low 4 bits are timing */
-	static const u8 udma_bits[]  = { 0x8F, 0x8A, 0x87, 0x85, 0x83, 0x82, 0x81};
+	u16 timing;
+	/* Bits 15-12  are timing */
+	static const u16 udma_bits[]  = {
+		0x8F00, 0x8A00, 0x8700, 0x8500, 0x8300, 0x8200, 0x8100
+	};
+	static const u8 mwdma_bits[] = { 0x08, 0x32, 0x31 };
 
-	pci_read_config_byte(pdev, drive_pci + 1, &timing);
+	pci_read_config_word(pdev, drive_pci, &timing);
 
 	if (adev->dma_mode < XFER_UDMA_0) {
-		/* NOT SUPPORTED YET: NEED DATA SHEET. DITTO IN OLD DRIVER */
+		speed = mwdma_clip_to_pio(adev);
+		timing &= ~0x80FF;
+		timing = mwdma_bits[speed];
 	} else {
 		/* Bit 7 is UDMA on/off, bit 0-3 are cycle time */
 		speed = adev->dma_mode - XFER_UDMA_0;
-		timing &= ~0x8F;
+		timing &= ~0x8F00;
 		timing |= udma_bits[speed];
 	}
-	pci_write_config_byte(pdev, drive_pci + 1, timing);
+	pci_write_config_word(pdev, drive_pci, timing);
 }
 
 /**
@@ -479,13 +527,12 @@ static void sis_133_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	if (reg54 & 0x40000000)
 		port = 0x70;
 	port += (8 * ap->port_no) +  (4 * adev->devno);
-
 	pci_read_config_dword(pdev, port, &t1);
 
 	if (adev->dma_mode < XFER_UDMA_0) {
-		t1 &= ~0x00000004;
-		/* FIXME: need data sheet to add MWDMA here. Also lacking on
-		   ide/pci driver */
+		speed = mwdma_clip_to_pio(adev);
+		sis_133_do_piomode(ap, adev, speed);
+		t1 &= ~4;	/* UDMA off */
 	} else {
 		speed = adev->dma_mode - XFER_UDMA_0;
 		/* if & 8 no UDMA133 - need info for ... */

