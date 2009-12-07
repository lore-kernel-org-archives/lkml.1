Return-Path: <linux-kernel-owner+w=401wt.eu-S935456AbZLGQvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935456AbZLGQvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935369AbZLGQvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:51:08 -0500
Received: from havoc.gtf.org ([69.61.125.42]:49674 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935285AbZLGQvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:51:07 -0500
Date: Mon, 7 Dec 2009 11:51:12 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patch] libata fix
Message-ID: <20091207165112.GA14576@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

One of the commits had bugs caught in late review, and needed to be
reverted.  This commit was appended to the usual git branch(es).

Please pull from the "upstream-linus" branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the commit below.  If you have not yet pulled the previous
upstream-linus batch for libata, you will receive the contents of the
previous push + the commit below.  If you have pulled, you will only
receive the commit below.


commit 1b52f2a41c41052d2a7c78af0bd9b8b11d70f49a
Author: Jeff Garzik <jeff@garzik.org>
Date:   Mon Dec 7 11:41:25 2009 -0500

    Revert "pata_sis: Implement MWDMA for the UDMA 133 capable chips"
    
    This reverts commit f20941f334d8fdb6b598658979709b4e94cd034b.
    
    Sergei Shtylyov notes "You call min() on uncomparables [in
    mwdma_clip_to_pio()], i.e. mwdma_to_pio[] contains XFER_PIO_* and
    adev->pio_mode - XFER_PIO_0 yields you a mode number.  Thus the second
    argument will always "win" as a minimal one"
    
    Bartlomiej Zolnierkiewicz adds "There are more issues with the patch related
    to mwdma_clip_to_pio().  The function can return values between 0 and
    4 which obviously won't work well for the new code below for values
    >2 (i.e. resulting in out-of-bounds array access for the common-case
    of dev->pio_mode == XFER_PIO_4)."
    
    Bartlomiej Zolnierkiewicz also notes the patch is incomplete, failing to
    update MWDMA mode masks.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 8af0dc8..5c30d56 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -252,25 +252,24 @@ static void sis_100_set_piomode (struct ata_port *ap, struct ata_device *adev)
 }
 
 /**
- *	sis_133_do_piomode - Initialize host controller PATA PIO/DMA timings
+ *	sis_133_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device we are configuring for.
  *
  *	Set PIO mode for device, in host controller PCI config space. This
- *	function handles PIO set up for the later ATA133 devices. The same
- *	timings are used for MWDMA.
+ *	function handles PIO set up for the later ATA133 devices.
  *
  *	LOCKING:
  *	None (inherited from caller).
  */
 
-static void sis_133_do_piomode(struct ata_port *ap, struct ata_device *adev,
-					int speed)
+static void sis_133_set_piomode (struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int port = 0x40;
 	u32 t1;
 	u32 reg54;
+	int speed = adev->pio_mode - XFER_PIO_0;
 
 	const u32 timing133[] = {
 		0x28269000,	/* Recovery << 24 | Act << 16 | Ini << 12 */
@@ -306,42 +305,6 @@ static void sis_133_do_piomode(struct ata_port *ap, struct ata_device *adev,
 }
 
 /**
- *	sis_133_set_piomode - Initialize host controller PATA PIO timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Device we are configuring for.
- *
- *	Set PIO mode for device, in host controller PCI config space. This
- *	function handles PIO set up for the later ATA133 devices.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void sis_133_set_piomode (struct ata_port *ap, struct ata_device *adev)
-{
-
-	sis_133_do_piomode(ap, adev, adev->pio_mode - XFER_PIO_0);
-}
-
-/**
- *	mwdma_clip_to_pio		-	clip MWDMA mode
- *	@adev: device
- *
- *	As the SiS shared MWDMA and PIO timings we must program the equivalent
- *	PIO timing for the MWDMA mode but we must not program one higher than
- *	the permitted PIO timing of the device.
- */
-
-static int mwdma_clip_to_pio(struct ata_device *adev)
-{
-	const int mwdma_to_pio[3] = {
-		XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
-	};
-	return min(mwdma_to_pio[adev->dma_mode - XFER_MW_DMA_0],
-				adev->pio_mode - XFER_PIO_0);
-}
-
-/**
  *	sis_old_set_dmamode - Initialize host controller PATA DMA timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device to program
@@ -369,7 +332,6 @@ static void sis_old_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	if (adev->dma_mode < XFER_UDMA_0) {
 		/* bits 3-0 hold recovery timing bits 8-10 active timing and
 		   the higher bits are dependant on the device */
-		speed = mwdma_clip_to_pio(adev);
 		timing &= ~0x870F;
 		timing |= mwdma_bits[speed];
 	} else {
@@ -410,7 +372,6 @@ static void sis_66_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	if (adev->dma_mode < XFER_UDMA_0) {
 		/* bits 3-0 hold recovery timing bits 8-10 active timing and
 		   the higher bits are dependant on the device, bit 15 udma */
-		speed = mwdma_clip_to_pio(adev);
 		timing &= ~0x870F;
 		timing |= mwdma_bits[speed];
 	} else {
@@ -428,7 +389,7 @@ static void sis_66_set_dmamode (struct ata_port *ap, struct ata_device *adev)
  *	@adev: Device to program
  *
  *	Set UDMA/MWDMA mode for device, in host controller PCI config space.
- *	Handles later UDMA100 devices.
+ *	Handles UDMA66 and early UDMA100 devices.
  *
  *	LOCKING:
  *	None (inherited from caller).
@@ -439,25 +400,21 @@ static void sis_100_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
 	int drive_pci = sis_old_port_base(adev);
-	u16 timing;
+	u8 timing;
 
-	const u16 udma_bits[]  = {
-		0x8B00, 0x8700, 0x8500, 0x8300, 0x8200, 0x8100};
-	const u8 mwdma_bits[] = { 0x08, 0x32, 0x31 };
+	const u8 udma_bits[]  = { 0x8B, 0x87, 0x85, 0x83, 0x82, 0x81};
 
-	pci_read_config_word(pdev, drive_pci, &timing);
+	pci_read_config_byte(pdev, drive_pci + 1, &timing);
 
 	if (adev->dma_mode < XFER_UDMA_0) {
-		speed = mwdma_clip_to_pio(adev);
-		timing &= ~0x80FF;
-		timing |= mwdma_bits[speed];
+		/* NOT SUPPORTED YET: NEED DATA SHEET. DITTO IN OLD DRIVER */
 	} else {
 		/* Bit 7 is UDMA on/off, bit 0-3 are cycle time */
 		speed = adev->dma_mode - XFER_UDMA_0;
-		timing &= ~0x8F00;
+		timing &= ~0x8F;
 		timing |= udma_bits[speed];
 	}
-	pci_write_config_word(pdev, drive_pci, timing);
+	pci_write_config_byte(pdev, drive_pci + 1, timing);
 }
 
 /**
@@ -477,26 +434,21 @@ static void sis_133_early_set_dmamode (struct ata_port *ap, struct ata_device *a
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int speed = adev->dma_mode - XFER_MW_DMA_0;
 	int drive_pci = sis_old_port_base(adev);
-	u16 timing;
-	/* Bits 15-12  are timing */
-	static const u16 udma_bits[]  = {
-		0x8F00, 0x8A00, 0x8700, 0x8500, 0x8300, 0x8200, 0x8100
-	};
-	static const u8 mwdma_bits[] = { 0x08, 0x32, 0x31 };
+	u8 timing;
+	/* Low 4 bits are timing */
+	static const u8 udma_bits[]  = { 0x8F, 0x8A, 0x87, 0x85, 0x83, 0x82, 0x81};
 
-	pci_read_config_word(pdev, drive_pci, &timing);
+	pci_read_config_byte(pdev, drive_pci + 1, &timing);
 
 	if (adev->dma_mode < XFER_UDMA_0) {
-		speed = mwdma_clip_to_pio(adev);
-		timing &= ~0x80FF;
-		timing = mwdma_bits[speed];
+		/* NOT SUPPORTED YET: NEED DATA SHEET. DITTO IN OLD DRIVER */
 	} else {
 		/* Bit 7 is UDMA on/off, bit 0-3 are cycle time */
 		speed = adev->dma_mode - XFER_UDMA_0;
-		timing &= ~0x8F00;
+		timing &= ~0x8F;
 		timing |= udma_bits[speed];
 	}
-	pci_write_config_word(pdev, drive_pci, timing);
+	pci_write_config_byte(pdev, drive_pci + 1, timing);
 }
 
 /**
@@ -527,12 +479,13 @@ static void sis_133_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	if (reg54 & 0x40000000)
 		port = 0x70;
 	port += (8 * ap->port_no) +  (4 * adev->devno);
+
 	pci_read_config_dword(pdev, port, &t1);
 
 	if (adev->dma_mode < XFER_UDMA_0) {
-		speed = mwdma_clip_to_pio(adev);
-		sis_133_do_piomode(ap, adev, speed);
-		t1 &= ~4;	/* UDMA off */
+		t1 &= ~0x00000004;
+		/* FIXME: need data sheet to add MWDMA here. Also lacking on
+		   ide/pci driver */
 	} else {
 		speed = adev->dma_mode - XFER_UDMA_0;
 		/* if & 8 no UDMA133 - need info for ... */
