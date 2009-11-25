Return-Path: <linux-kernel-owner+w=401wt.eu-S1758941AbZKYRDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbZKYRDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758922AbZKYRD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:03:28 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52887 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758915AbZKYRDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:03:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=okms36GrrYOXdxt/YGnsb+6/nRFiE37cAzfRLUlz3EibY+HPLmyO/Yg4eNPljGWPw7
         +tVTJ3qDG4tZajKcIymkoX3lNxdOcOgkrgFFFx6/HeNDSLM295YntZP5mfTbalLzygq5
         vfHSjbHcYMdMNcABJMVdYkIeYUbWgAoyhLnkA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:02:46 +0100
Message-Id: <20091125170246.5446.583.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 04/86] pata_artop: fix chipsets naming
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_artop: fix chipsets naming

6210, 6260[R] and 6280[R] are names used for AEC cards while
ARTOP chipset names are: 850, 860[R] and 865[R] respectively.

Fix the naming used in the driver to avoid confusion and make
it more consistent with pata_atp87x.c.

While at it:
- use atp86x_ prefix for functions used by all ATP86x chipsets
  (previously they were erroneously prefixed with artop6260_)
- use '133' instead of 'fast' to denote UDMA133 support
- use '6880' instead of '6280 + fast' to denote AEC6880 card
- fix documentation of ->prereset method
- fix typo in the documentation of ->qc_defer method
- fix few CodingStyle issues

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_artop.c |  111 +++++++++++++++++++++++------------------------
 1 file changed, 55 insertions(+), 56 deletions(-)

Index: b/drivers/ata/pata_artop.c
===================================================================
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -39,7 +39,7 @@
 
 static int clock = 0;
 
-static int artop6210_pre_reset(struct ata_link *link, unsigned long deadline)
+static int atp850_pre_reset(struct ata_link *link, unsigned long deadline)
 {
 	struct ata_port *ap = link->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
@@ -55,15 +55,14 @@ static int artop6210_pre_reset(struct at
 }
 
 /**
- *	artop6260_pre_reset	-	check for 40/80 pin
+ *	atp86x_pre_reset	-	probe begin
  *	@link: link
  *	@deadline: deadline jiffies for the operation
  *
- *	The ARTOP hardware reports the cable detect bits in register 0x49.
  *	Nothing complicated needed here.
  */
 
-static int artop6260_pre_reset(struct ata_link *link, unsigned long deadline)
+static int atp86x_pre_reset(struct ata_link *link, unsigned long deadline)
 {
 	static const struct pci_bits artop_enable_bits[] = {
 		{ 0x4AU, 1U, 0x02UL, 0x02UL },	/* port 0 */
@@ -81,13 +80,13 @@ static int artop6260_pre_reset(struct at
 }
 
 /**
- *	artop6260_cable_detect	-	identify cable type
+ *	atp86x_cable_detect	-	identify cable type
  *	@ap: Port
  *
  *	Identify the cable type for the ARTOP interface in question
  */
 
-static int artop6260_cable_detect(struct ata_port *ap)
+static int atp86x_cable_detect(struct ata_port *ap)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u8 tmp;
@@ -98,7 +97,7 @@ static int artop6260_cable_detect(struct
 }
 
 /**
- *	artop6210_load_piomode - Load a set of PATA PIO timings
+ *	atp850_load_piomode - Load a set of PATA PIO timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device
  *	@pio: PIO mode
@@ -111,7 +110,8 @@ static int artop6260_cable_detect(struct
  *	None (inherited from caller).
  */
 
-static void artop6210_load_piomode(struct ata_port *ap, struct ata_device *adev, unsigned int pio)
+static void atp850_load_piomode(struct ata_port *ap, struct ata_device *adev,
+				unsigned int pio)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int dn = adev->devno + 2 * ap->port_no;
@@ -125,7 +125,7 @@ static void artop6210_load_piomode(struc
 }
 
 /**
- *	artop6210_set_piomode - Initialize host controller PATA PIO timings
+ *	atp850_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device we are configuring
  *
@@ -138,13 +138,13 @@ static void artop6210_load_piomode(struc
  *	None (inherited from caller).
  */
 
-static void artop6210_set_piomode(struct ata_port *ap, struct ata_device *adev)
+static void atp850_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int dn = adev->devno + 2 * ap->port_no;
 	u8 ultra;
 
-	artop6210_load_piomode(ap, adev, adev->pio_mode - XFER_PIO_0);
+	atp850_load_piomode(ap, adev, adev->pio_mode - XFER_PIO_0);
 
 	/* Clear the UDMA mode bits (set_dmamode will redo this if needed) */
 	pci_read_config_byte(pdev, 0x54, &ultra);
@@ -153,19 +153,20 @@ static void artop6210_set_piomode(struct
 }
 
 /**
- *	artop6260_load_piomode - Initialize host controller PATA PIO timings
+ *	atp86x_load_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device we are configuring
  *	@pio: PIO mode
  *
- *	Set PIO mode for device, in host controller PCI config space. The
- *	ARTOP6260 and relatives store the timing data differently.
+ *	Set PIO mode for device, in host controller PCI config space.
+ *	The ATP860 and relatives store the timing data differently.
  *
  *	LOCKING:
  *	None (inherited from caller).
  */
 
-static void artop6260_load_piomode (struct ata_port *ap, struct ata_device *adev, unsigned int pio)
+static void atp86x_load_piomode(struct ata_port *ap, struct ata_device *adev,
+				unsigned int pio)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	int dn = adev->devno + 2 * ap->port_no;
@@ -179,7 +180,7 @@ static void artop6260_load_piomode (stru
 }
 
 /**
- *	artop6260_set_piomode - Initialize host controller PATA PIO timings
+ *	atp86x_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device we are configuring
  *
@@ -192,12 +193,12 @@ static void artop6260_load_piomode (stru
  *	None (inherited from caller).
  */
 
-static void artop6260_set_piomode(struct ata_port *ap, struct ata_device *adev)
+static void atp86x_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
 	u8 ultra;
 
-	artop6260_load_piomode(ap, adev, adev->pio_mode - XFER_PIO_0);
+	atp86x_load_piomode(ap, adev, adev->pio_mode - XFER_PIO_0);
 
 	/* Clear the UDMA mode bits (set_dmamode will redo this if needed) */
 	pci_read_config_byte(pdev, 0x44 + ap->port_no, &ultra);
@@ -206,7 +207,7 @@ static void artop6260_set_piomode(struct
 }
 
 /**
- *	artop6210_set_dmamode - Initialize host controller PATA PIO timings
+ *	atp850_set_dmamode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device whose timings we are configuring
  *
@@ -216,7 +217,7 @@ static void artop6260_set_piomode(struct
  *	None (inherited from caller).
  */
 
-static void artop6210_set_dmamode (struct ata_port *ap, struct ata_device *adev)
+static void atp850_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	unsigned int pio;
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
@@ -229,7 +230,7 @@ static void artop6210_set_dmamode (struc
 		pio = 4;
 
 	/* Load the PIO timing active/recovery bits */
-	artop6210_load_piomode(ap, adev, pio);
+	atp850_load_piomode(ap, adev, pio);
 
 	pci_read_config_byte(pdev, 0x54, &ultra);
 	ultra &= ~(3 << (2 * dn));
@@ -245,18 +246,18 @@ static void artop6210_set_dmamode (struc
 }
 
 /**
- *	artop6260_set_dmamode - Initialize host controller PATA PIO timings
+ *	atp86x_set_dmamode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device we are configuring
  *
- *	Set DMA mode for device, in host controller PCI config space. The
- *	ARTOP6260 and relatives store the timing data differently.
+ *	Set DMA mode for device, in host controller PCI config space.
+ *	The ATP860 and relatives store the timing data differently.
  *
  *	LOCKING:
  *	None (inherited from caller).
  */
 
-static void artop6260_set_dmamode (struct ata_port *ap, struct ata_device *adev)
+static void atp86x_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
@@ -268,7 +269,7 @@ static void artop6260_set_dmamode (struc
 		pio = 4;
 
 	/* Load the PIO timing active/recovery bits */
-	artop6260_load_piomode(ap, adev, pio);
+	atp86x_load_piomode(ap, adev, pio);
 
 	/* Add ultra DMA bits if in UDMA mode */
 	pci_read_config_byte(pdev, 0x44 + ap->port_no, &ultra);
@@ -283,13 +284,13 @@ static void artop6260_set_dmamode (struc
 }
 
 /**
- *	artop_6210_qc_defer	-	implement serialization
+ *	atp850_qc_defer	-	implement serialization
  *	@qc: command
  *
  *	Issue commands per host on this chip.
  */
 
-static int artop6210_qc_defer(struct ata_queued_cmd *qc)
+static int atp850_qc_defer(struct ata_queued_cmd *qc)
 {
 	struct ata_host *host = qc->ap->host;
 	struct ata_port *alt = host->ports[1 ^ qc->ap->port_no];
@@ -311,21 +312,21 @@ static struct scsi_host_template artop_s
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
-static struct ata_port_operations artop6210_ops = {
+static struct ata_port_operations atp850_ops = {
 	.inherits		= &ata_bmdma32_port_ops,
 	.cable_detect		= ata_cable_40wire,
-	.set_piomode		= artop6210_set_piomode,
-	.set_dmamode		= artop6210_set_dmamode,
-	.prereset		= artop6210_pre_reset,
-	.qc_defer		= artop6210_qc_defer,
+	.set_piomode		= atp850_set_piomode,
+	.set_dmamode		= atp850_set_dmamode,
+	.prereset		= atp850_pre_reset,
+	.qc_defer		= atp850_qc_defer,
 };
 
-static struct ata_port_operations artop6260_ops = {
+static struct ata_port_operations atp86x_ops = {
 	.inherits		= &ata_bmdma32_port_ops,
-	.cable_detect		= artop6260_cable_detect,
-	.set_piomode		= artop6260_set_piomode,
-	.set_dmamode		= artop6260_set_dmamode,
-	.prereset		= artop6260_pre_reset,
+	.cable_detect		= atp86x_cable_detect,
+	.set_piomode		= atp86x_set_piomode,
+	.set_dmamode		= atp86x_set_dmamode,
+	.prereset		= atp86x_pre_reset,
 };
 
 
@@ -346,33 +347,33 @@ static struct ata_port_operations artop6
 static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static int printed_version;
-	static const struct ata_port_info info_6210 = {
+	static const struct ata_port_info atp850_info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask 	= ATA_UDMA2,
-		.port_ops	= &artop6210_ops,
+		.port_ops	= &atp850_ops,
 	};
-	static const struct ata_port_info info_626x = {
+	static const struct ata_port_info atp860_info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask 	= ATA_UDMA4,
-		.port_ops	= &artop6260_ops,
+		.port_ops	= &atp86x_ops,
 	};
-	static const struct ata_port_info info_628x = {
+	static const struct ata_port_info atp865_info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask 	= ATA_UDMA5,
-		.port_ops	= &artop6260_ops,
+		.port_ops	= &atp86x_ops,
 	};
-	static const struct ata_port_info info_628x_fast = {
+	static const struct ata_port_info atp865_133_info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask 	= ATA_UDMA6,
-		.port_ops	= &artop6260_ops,
+		.port_ops	= &atp86x_ops,
 	};
 	const struct ata_port_info *ppi[] = { NULL, NULL };
 	int rc;
@@ -385,20 +386,19 @@ static int artop_init_one (struct pci_de
 	if (rc)
 		return rc;
 
-	if (id->driver_data == 0) {	/* 6210 variant */
-		ppi[0] = &info_6210;
+	if (id->driver_data == 0) {		/* AEC6210 */
+		ppi[0] = &atp850_info;
 		/* BIOS may have left us in UDMA, clear it before libata probe */
 		pci_write_config_byte(pdev, 0x54, 0);
-	}
-	else if (id->driver_data == 1)	/* 6260 */
-		ppi[0] = &info_626x;
-	else if (id->driver_data == 2)	{ /* 6280 or 6280 + fast */
+	} else if (id->driver_data == 1) {	/* AEC6260[R] */
+		ppi[0] = &atp860_info;
+	} else if (id->driver_data == 2) { 	/* AEC6280[R] */
 		unsigned long io = pci_resource_start(pdev, 4);
 		u8 reg;
 
-		ppi[0] = &info_628x;
-		if (inb(io) & 0x10)
-			ppi[0] = &info_628x_fast;
+		ppi[0] = &atp865_info;
+		if (inb(io) & 0x10)		/* AEC6880[R] */
+			ppi[0] = &atp865_133_info;
 		/* Mac systems come up with some registers not set as we
 		   will need them */
 
@@ -416,7 +416,6 @@ static int artop_init_one (struct pci_de
 		/* Enable IRQ output and burst mode */
 		pci_read_config_byte(pdev, 0x4a, &reg);
 		pci_write_config_byte(pdev, 0x4a, (reg & ~0x01) | 0x80);
-
 	}
 
 	BUG_ON(ppi[0] == NULL);
