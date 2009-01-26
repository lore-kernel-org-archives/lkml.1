Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbZAZTNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbZAZTNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 14:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbZAZTNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 14:13:25 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43313 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752029AbZAZTNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 14:13:24 -0500
Date: Mon, 26 Jan 2009 19:11:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jeff Garzik <jgarzik@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc libata sff 32bit PIO regression
Message-ID: <20090126191151.18b094e6@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0901211322010.15945@blonde.anvils>
References: <Pine.LNX.4.64.0901211322010.15945@blonde.anvils>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [PATCH] libata sff: 32bit PIO use 16bit on slop
> 
> 871af1210f13966ab911ed2166e4ab2ce775b99d libata: Add 32bit PIO support
> causes errors on a four-year-old ata_piix Dell Precision 670.  Using
> 16bit PIO instead of 32bit PIO on the odd 1, 2 or 3 chars fixes that.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

For the 3 bytes of slop it should use a single iowrite32 but otherwise
that seems ok. We do need to handle the FIFO setup on the AMD differently
if we do this - something like this:

pata_amd: Program FIFO

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

With 32bit PIO we can use the posted write buffers, but only for 32bit I/O
cycles. This means we must disable the FIFO for ATAPI where a final 16bit
cycle may occur.

Rework the FIFO logic so that we disable the FIFO then selectively re-enable
it when we set the timings on AMD devices. Also fix a case where we scribbled
on PCI config 0x41 of Nvidia chips when we shouldn't.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/ata/pata_amd.c |   78 +++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 60 insertions(+), 18 deletions(-)


diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 63719ab..c380a4e 100644
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
@@ -534,20 +583,13 @@ static int amd_reinit_one(struct pci_dev *pdev)
 	rc = ata_pci_device_do_resume(pdev);
 	if (rc)
 		return rc;
-
+	
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
