Return-Path: <linux-kernel-owner+w=401wt.eu-S1750959Ab0A2QRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750959Ab0A2QRD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:17:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754Ab0A2QGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:06:46 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab0A2QGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:06:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=pXO8Xg0jsxsIyoolGzVCIUu9VGdKG8nWDzzEhACvYt/l8MNpKkVavqe6dZcJA54z6q
         zNimSd4D8pxMKG7GQJ1ala3CqqqcYegT7rNSCcxoojfILz2j60vaDSoL3t+oBrj4xzje
         0AyR9cCaAAe9umfsSHj70nqwRIk++2r+d9kRI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:06:28 +0100
Message-Id: <20100129160628.21495.58007.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 31/68] pata_ali: move code to be re-used by ide2libata to pata_ali.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_ali: move code to be re-used by ide2libata to pata_ali.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_ali.c |  240 ------------------------------------------------
 drivers/ata/pata_ali.h |  241 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 241 insertions(+), 240 deletions(-)

Index: b/drivers/ata/pata_ali.c
===================================================================
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -45,33 +45,6 @@ static struct pci_dev *ali_isa_bridge;
 #include "pata_ali.h"
 
 /**
- *	ali_c2_cable_detect	-	cable detection
- *	@ap: ATA port
- *
- *	Perform cable detection for C2 and later revisions
- */
-
-static int ali_c2_cable_detect(struct ata_port *ap)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 ata66;
-
-	/* Certain laptops use short but suitable cables and don't
-	   implement the detect logic */
-
-	if (ali_cable_override(pdev))
-		return ATA_CBL_PATA40_SHORT;
-
-	/* Host view cable detect 0x4A bit 0 primary bit 1 secondary
-	   Bit set for 40 pin */
-	pci_read_config_byte(pdev, 0x4A, &ata66);
-	if (ata66 & (1 << ap->port_no))
-		return ATA_CBL_PATA40;
-	else
-		return ATA_CBL_PATA80;
-}
-
-/**
  *	ali_20_filter		-	filter for earlier ALI DMA
  *	@ap: ALi ATA port
  *	@adev: attached device
@@ -93,156 +66,6 @@ static unsigned long ali_20_filter(struc
 }
 
 /**
- *	ali_fifo_control	-	FIFO manager
- *	@ap: ALi channel to control
- *	@adev: device for FIFO control
- *	@on: 0 for off 1 for on
- *
- *	Enable or disable the FIFO on a given device. Because of the way the
- *	ALi FIFO works it provides a boost on ATA disk but can be confused by
- *	ATAPI and we must therefore manage it.
- */
-
-static void ali_fifo_control(struct ata_port *ap, struct ata_device *adev, int on)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	int pio_fifo = 0x54 + ap->port_no;
-	u8 fifo;
-	int shift = 4 * adev->devno;
-
-	/* ATA - FIFO on set nibble to 0x05, ATAPI - FIFO off, set nibble to
-	   0x00. Not all the docs agree but the behaviour we now use is the
-	   one stated in the BIOS Programming Guide */
-
-	pci_read_config_byte(pdev, pio_fifo, &fifo);
-	fifo &= ~(0x0F << shift);
-	fifo |= (on << shift);
-	pci_write_config_byte(pdev, pio_fifo, fifo);
-}
-
-/**
- *	ali_program_modes	-	load mode registers
- *	@ap: ALi channel to load
- *	@adev: Device the timing is for
- *	@t: timing data
- *	@ultra: UDMA timing or zero for off
- *
- *	Loads the timing registers for cmd/data and disable UDMA if
- *	ultra is zero. If ultra is set then load and enable the UDMA
- *	timing but do not touch the command/data timing.
- */
-
-static void ali_program_modes(struct ata_port *ap, struct ata_device *adev, struct ata_timing *t, u8 ultra)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	int cas = 0x58 + 4 * ap->port_no;	/* Command timing */
-	int cbt = 0x59 + 4 * ap->port_no;	/* Command timing */
-	int drwt = 0x5A + 4 * ap->port_no + adev->devno; /* R/W timing */
-	int udmat = 0x56 + ap->port_no;	/* UDMA timing */
-	int shift = 4 * adev->devno;
-	u8 udma;
-
-	if (t != NULL) {
-		t->setup = clamp_val(t->setup, 1, 8) & 7;
-		t->act8b = clamp_val(t->act8b, 1, 8) & 7;
-		t->rec8b = clamp_val(t->rec8b, 1, 16) & 15;
-		t->active = clamp_val(t->active, 1, 8) & 7;
-		t->recover = clamp_val(t->recover, 1, 16) & 15;
-
-		pci_write_config_byte(pdev, cas, t->setup);
-		pci_write_config_byte(pdev, cbt, (t->act8b << 4) | t->rec8b);
-		pci_write_config_byte(pdev, drwt, (t->active << 4) | t->recover);
-	}
-
-	/* Set up the UDMA enable */
-	pci_read_config_byte(pdev, udmat, &udma);
-	udma &= ~(0x0F << shift);
-	udma |= ultra << shift;
-	pci_write_config_byte(pdev, udmat, udma);
-}
-
-/**
- *	ali_set_piomode	-	set initial PIO mode data
- *	@ap: ATA interface
- *	@adev: ATA device
- *
- *	Program the ALi registers for PIO mode.
- */
-
-static void ali_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	struct ata_device *pair = ata_dev_pair(adev);
-	struct ata_timing t;
-	unsigned long T =  1000000000 / 33333;	/* PCI clock based */
-
-	ata_timing_compute(adev->id, adev->pio_mode, adev->pio_mode, &t, T, 1);
-	if (pair) {
-		struct ata_timing p;
-
-		ata_timing_compute(pair->id, pair->pio_mode, pair->pio_mode,
-				   &p, T, 1);
-		ata_timing_merge(&p, &t, &t, ATA_TIMING_SETUP|ATA_TIMING_8BIT);
-		if (pair->dma_mode) {
-			ata_timing_compute(pair->id, pair->dma_mode,
-					   pair->pio_mode, &p, T, 1);
-			ata_timing_merge(&p, &t, &t, ATA_TIMING_SETUP|ATA_TIMING_8BIT);
-		}
-	}
-
-	/* PIO FIFO is only permitted on ATA disk */
-	ali_fifo_control(ap, adev, (adev->class == ATA_DEV_ATA) ? 0x05 : 0x00);
-
-	ali_program_modes(ap, adev, &t, 0);
-}
-
-/**
- *	ali_set_dmamode	-	set initial DMA mode data
- *	@ap: ATA interface
- *	@adev: ATA device
- *
- *	Program the ALi registers for DMA mode.
- */
-
-static void ali_set_dmamode(struct ata_port *ap, struct ata_device *adev)
-{
-	static u8 udma_timing[7] = { 0xC, 0xB, 0xA, 0x9, 0x8, 0xF, 0xD };
-	struct ata_device *pair = ata_dev_pair(adev);
-	struct ata_timing t;
-	unsigned long T =  1000000000 / 33333;	/* PCI clock based */
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-
-
-	if (adev->class == ATA_DEV_ATA)
-		ali_fifo_control(ap, adev, 0x08);
-
-	if (adev->dma_mode >= XFER_UDMA_0) {
-		ali_program_modes(ap, adev, NULL, udma_timing[adev->dma_mode - XFER_UDMA_0]);
-		if (adev->dma_mode >= XFER_UDMA_3) {
-			u8 reg4b;
-			pci_read_config_byte(pdev, 0x4B, &reg4b);
-			reg4b |= 1;
-			pci_write_config_byte(pdev, 0x4B, reg4b);
-		}
-	} else {
-		ata_timing_compute(adev->id, adev->dma_mode, adev->pio_mode,
-				   &t, T, 1);
-		if (pair) {
-			struct ata_timing p;
-
-			ata_timing_compute(pair->id, pair->pio_mode,
-					   pair->pio_mode, &p, T, 1);
-			ata_timing_merge(&p, &t, &t, ATA_TIMING_SETUP|ATA_TIMING_8BIT);
-			if (pair->dma_mode) {
-				ata_timing_compute(pair->id, pair->dma_mode,
-						   pair->pio_mode, &p, T, 1);
-				ata_timing_merge(&p, &t, &t, ATA_TIMING_SETUP|ATA_TIMING_8BIT);
-			}
-		}
-		ali_program_modes(ap, adev, &t, 0);
-	}
-}
-
-/**
  *	ali_warn_atapi_dma	-	Warn about ATAPI DMA disablement
  *	@adev: Device
  *
@@ -388,69 +211,6 @@ static struct ata_port_operations ali_c5
 	.cable_detect	= ali_c2_cable_detect,
 };
 
-
-/**
- *	ali_init_chipset	-	chip setup function
- *	@dev: device of ATA controller
- *
- *	Perform the setup on the device that must be done both at boot
- *	and at resume time.
- */
-
-static int ali_init_chipset(struct device *dev)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	u8 tmp;
-	struct pci_dev *north;
-
-	/*
-	 * The chipset revision selects the driver operations and
-	 * mode data.
-	 */
-
-	if (pdev->revision <= 0x20) {
-		pci_read_config_byte(pdev, 0x53, &tmp);
-		tmp |= 0x03;
-		pci_write_config_byte(pdev, 0x53, tmp);
-	} else {
-		pci_read_config_byte(pdev, 0x4a, &tmp);
-		pci_write_config_byte(pdev, 0x4a, tmp | 0x20);
-		pci_read_config_byte(pdev, 0x4B, &tmp);
-		if (pdev->revision < 0xC2)
-			/* 1543-E/F, 1543C-C, 1543C-D, 1543C-E */
-			/* Clear CD-ROM DMA write bit */
-			tmp &= 0x7F;
-		/* Cable and UDMA */
-		if (pdev->revision >= 0xc2)
-			tmp |= 0x01;
-		pci_write_config_byte(pdev, 0x4B, tmp | 0x08);
-		/*
-		 * CD_ROM DMA on (0x53 bit 0). Enable this even if we want
-		 * to use PIO. 0x53 bit 1 (rev 20 only) - enable FIFO control
-		 * via 0x54/55.
-		 */
-		pci_read_config_byte(pdev, 0x53, &tmp);
-		if (pdev->revision >= 0xc7)
-			tmp |= 0x03;
-		else
-			tmp |= 0x01;	/* CD_ROM enable for DMA */
-		pci_write_config_byte(pdev, 0x53, tmp);
-	}
-	north = pci_get_bus_and_slot(0, PCI_DEVFN(0,0));
-	if (north && north->vendor == PCI_VENDOR_ID_AL && ali_isa_bridge) {
-		/* Configure the ALi bridge logic. For non ALi rely on BIOS.
-		   Set the south bridge enable bit */
-		pci_read_config_byte(ali_isa_bridge, 0x79, &tmp);
-		if (pdev->revision == 0xC2)
-			pci_write_config_byte(ali_isa_bridge, 0x79, tmp | 0x04);
-		else if (pdev->revision > 0xC2 && pdev->revision < 0xC5)
-			pci_write_config_byte(ali_isa_bridge, 0x79, tmp | 0x02);
-	}
-	pci_dev_put(north);
-	ata_pci_bmdma_clear_simplex(pdev);
-	return 0;
-}
-
 /**
  *	ali_init_one		-	discovery callback
  *	@pdev: PCI device ID
Index: b/drivers/ata/pata_ali.h
===================================================================
--- a/drivers/ata/pata_ali.h
+++ b/drivers/ata/pata_ali.h
@@ -38,3 +38,244 @@ static int ali_cable_override(struct pci
 		return 1;
 	return 0;
 }
+
+#ifdef __LINUX_LIBATA_H__
+/**
+ *	ali_c2_cable_detect	-	cable detection
+ *	@ap: ATA port
+ *
+ *	Perform cable detection for C2 and later revisions
+ */
+
+static int ali_c2_cable_detect(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u8 ata66;
+
+	/* Certain laptops use short but suitable cables and don't
+	   implement the detect logic */
+
+	if (ali_cable_override(pdev))
+		return ATA_CBL_PATA40_SHORT;
+
+	/* Host view cable detect 0x4A bit 0 primary bit 1 secondary
+	   Bit set for 40 pin */
+	pci_read_config_byte(pdev, 0x4A, &ata66);
+	if (ata66 & (1 << ap->port_no))
+		return ATA_CBL_PATA40;
+	else
+		return ATA_CBL_PATA80;
+}
+
+/**
+ *	ali_fifo_control	-	FIFO manager
+ *	@ap: ALi channel to control
+ *	@adev: device for FIFO control
+ *	@on: 0 for off 1 for on
+ *
+ *	Enable or disable the FIFO on a given device. Because of the way the
+ *	ALi FIFO works it provides a boost on ATA disk but can be confused by
+ *	ATAPI and we must therefore manage it.
+ */
+
+static void ali_fifo_control(struct ata_port *ap, struct ata_device *adev, int on)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	int pio_fifo = 0x54 + ap->port_no;
+	u8 fifo;
+	int shift = 4 * adev->devno;
+
+	/* ATA - FIFO on set nibble to 0x05, ATAPI - FIFO off, set nibble to
+	   0x00. Not all the docs agree but the behaviour we now use is the
+	   one stated in the BIOS Programming Guide */
+
+	pci_read_config_byte(pdev, pio_fifo, &fifo);
+	fifo &= ~(0x0F << shift);
+	fifo |= (on << shift);
+	pci_write_config_byte(pdev, pio_fifo, fifo);
+}
+
+/**
+ *	ali_program_modes	-	load mode registers
+ *	@ap: ALi channel to load
+ *	@adev: Device the timing is for
+ *	@t: timing data
+ *	@ultra: UDMA timing or zero for off
+ *
+ *	Loads the timing registers for cmd/data and disable UDMA if
+ *	ultra is zero. If ultra is set then load and enable the UDMA
+ *	timing but do not touch the command/data timing.
+ */
+
+static void ali_program_modes(struct ata_port *ap, struct ata_device *adev, struct ata_timing *t, u8 ultra)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	int cas = 0x58 + 4 * ap->port_no;	/* Command timing */
+	int cbt = 0x59 + 4 * ap->port_no;	/* Command timing */
+	int drwt = 0x5A + 4 * ap->port_no + adev->devno; /* R/W timing */
+	int udmat = 0x56 + ap->port_no;	/* UDMA timing */
+	int shift = 4 * adev->devno;
+	u8 udma;
+
+	if (t != NULL) {
+		t->setup = clamp_val(t->setup, 1, 8) & 7;
+		t->act8b = clamp_val(t->act8b, 1, 8) & 7;
+		t->rec8b = clamp_val(t->rec8b, 1, 16) & 15;
+		t->active = clamp_val(t->active, 1, 8) & 7;
+		t->recover = clamp_val(t->recover, 1, 16) & 15;
+
+		pci_write_config_byte(pdev, cas, t->setup);
+		pci_write_config_byte(pdev, cbt, (t->act8b << 4) | t->rec8b);
+		pci_write_config_byte(pdev, drwt, (t->active << 4) | t->recover);
+	}
+
+	/* Set up the UDMA enable */
+	pci_read_config_byte(pdev, udmat, &udma);
+	udma &= ~(0x0F << shift);
+	udma |= ultra << shift;
+	pci_write_config_byte(pdev, udmat, udma);
+}
+
+/**
+ *	ali_set_piomode	-	set initial PIO mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Program the ALi registers for PIO mode.
+ */
+
+static void ali_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct ata_device *pair = ata_dev_pair(adev);
+	struct ata_timing t;
+	unsigned long T =  1000000000 / 33333;	/* PCI clock based */
+
+	ata_timing_compute(adev->id, adev->pio_mode, adev->pio_mode, &t, T, 1);
+	if (pair) {
+		struct ata_timing p;
+
+		ata_timing_compute(pair->id, pair->pio_mode, pair->pio_mode,
+				   &p, T, 1);
+		ata_timing_merge(&p, &t, &t, ATA_TIMING_SETUP|ATA_TIMING_8BIT);
+		if (pair->dma_mode) {
+			ata_timing_compute(pair->id, pair->dma_mode,
+					   pair->pio_mode, &p, T, 1);
+			ata_timing_merge(&p, &t, &t, ATA_TIMING_SETUP|ATA_TIMING_8BIT);
+		}
+	}
+
+	/* PIO FIFO is only permitted on ATA disk */
+	ali_fifo_control(ap, adev, (adev->class == ATA_DEV_ATA) ? 0x05 : 0x00);
+
+	ali_program_modes(ap, adev, &t, 0);
+}
+
+/**
+ *	ali_set_dmamode	-	set initial DMA mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Program the ALi registers for DMA mode.
+ */
+
+static void ali_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	static u8 udma_timing[7] = { 0xC, 0xB, 0xA, 0x9, 0x8, 0xF, 0xD };
+	struct ata_device *pair = ata_dev_pair(adev);
+	struct ata_timing t;
+	unsigned long T =  1000000000 / 33333;	/* PCI clock based */
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+
+
+	if (adev->class == ATA_DEV_ATA)
+		ali_fifo_control(ap, adev, 0x08);
+
+	if (adev->dma_mode >= XFER_UDMA_0) {
+		ali_program_modes(ap, adev, NULL, udma_timing[adev->dma_mode - XFER_UDMA_0]);
+		if (adev->dma_mode >= XFER_UDMA_3) {
+			u8 reg4b;
+			pci_read_config_byte(pdev, 0x4B, &reg4b);
+			reg4b |= 1;
+			pci_write_config_byte(pdev, 0x4B, reg4b);
+		}
+	} else {
+		ata_timing_compute(adev->id, adev->dma_mode, adev->pio_mode,
+				   &t, T, 1);
+		if (pair) {
+			struct ata_timing p;
+
+			ata_timing_compute(pair->id, pair->pio_mode,
+					   pair->pio_mode, &p, T, 1);
+			ata_timing_merge(&p, &t, &t, ATA_TIMING_SETUP|ATA_TIMING_8BIT);
+			if (pair->dma_mode) {
+				ata_timing_compute(pair->id, pair->dma_mode,
+						   pair->pio_mode, &p, T, 1);
+				ata_timing_merge(&p, &t, &t, ATA_TIMING_SETUP|ATA_TIMING_8BIT);
+			}
+		}
+		ali_program_modes(ap, adev, &t, 0);
+	}
+}
+
+/**
+ *	ali_init_chipset	-	chip setup function
+ *	@dev: device of ATA controller
+ *
+ *	Perform the setup on the device that must be done both at boot
+ *	and at resume time.
+ */
+
+static int ali_init_chipset(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	u8 tmp;
+	struct pci_dev *north;
+
+	/*
+	 * The chipset revision selects the driver operations and
+	 * mode data.
+	 */
+
+	if (pdev->revision <= 0x20) {
+		pci_read_config_byte(pdev, 0x53, &tmp);
+		tmp |= 0x03;
+		pci_write_config_byte(pdev, 0x53, tmp);
+	} else {
+		pci_read_config_byte(pdev, 0x4a, &tmp);
+		pci_write_config_byte(pdev, 0x4a, tmp | 0x20);
+		pci_read_config_byte(pdev, 0x4B, &tmp);
+		if (pdev->revision < 0xC2)
+			/* 1543-E/F, 1543C-C, 1543C-D, 1543C-E */
+			/* Clear CD-ROM DMA write bit */
+			tmp &= 0x7F;
+		/* Cable and UDMA */
+		if (pdev->revision >= 0xc2)
+			tmp |= 0x01;
+		pci_write_config_byte(pdev, 0x4B, tmp | 0x08);
+		/*
+		 * CD_ROM DMA on (0x53 bit 0). Enable this even if we want
+		 * to use PIO. 0x53 bit 1 (rev 20 only) - enable FIFO control
+		 * via 0x54/55.
+		 */
+		pci_read_config_byte(pdev, 0x53, &tmp);
+		if (pdev->revision >= 0xc7)
+			tmp |= 0x03;
+		else
+			tmp |= 0x01;	/* CD_ROM enable for DMA */
+		pci_write_config_byte(pdev, 0x53, tmp);
+	}
+	north = pci_get_bus_and_slot(0, PCI_DEVFN(0,0));
+	if (north && north->vendor == PCI_VENDOR_ID_AL && ali_isa_bridge) {
+		/* Configure the ALi bridge logic. For non ALi rely on BIOS.
+		   Set the south bridge enable bit */
+		pci_read_config_byte(ali_isa_bridge, 0x79, &tmp);
+		if (pdev->revision == 0xC2)
+			pci_write_config_byte(ali_isa_bridge, 0x79, tmp | 0x04);
+		else if (pdev->revision > 0xC2 && pdev->revision < 0xC5)
+			pci_write_config_byte(ali_isa_bridge, 0x79, tmp | 0x02);
+	}
+	pci_dev_put(north);
+	ata_pci_bmdma_clear_simplex(pdev);
+	return 0;
+}
+#endif
