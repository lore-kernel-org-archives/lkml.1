Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119Ab0A2QQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab0A2QQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960Ab0A2QQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:16:54 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab0A2QHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:07:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=XnqQSsVCF/FCpJJrjy5JxmIoNqEr/sm5SmcrhkcftjgFcz3Yw4E6a4WZJRy2zx3u/K
         UiGN4bK+rYa4/sginGNbCcOLu3gfFISuIuywYlwzqcysyrTpuPiB+jqPyxyJ6AHmBapy
         T/B+/bGyvtcR12hx/MhxISeVaBHzI/JI8leBc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:06:53 +0100
Message-Id: <20100129160653.21495.71701.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 35/68] pata_artop: move code to be re-used by ide2libata to pata_artop.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_artop: move code to be re-used by ide2libata to pata_artop.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_artop.c |  232 -----------------------------------------------
 drivers/ata/pata_artop.h |  230 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 231 insertions(+), 231 deletions(-)

Index: b/drivers/ata/pata_artop.c
===================================================================
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -56,205 +56,7 @@ static int atp8xx_prereset(struct ata_li
 	return ata_sff_prereset(link, deadline);
 }
 
-/**
- *	atp86x_cable_detect	-	identify cable type
- *	@ap: Port
- *
- *	Identify the cable type for the ARTOP interface in question
- */
-
-static int atp86x_cable_detect(struct ata_port *ap)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 tmp;
-	pci_read_config_byte(pdev, 0x49, &tmp);
-	if (tmp & (1 << ap->port_no))
-		return ATA_CBL_PATA40;
-	return ATA_CBL_PATA80;
-}
-
-/**
- *	atp850_load_piomode - Load a set of PATA PIO timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Device
- *	@pio: PIO mode
- *
- *	Set PIO mode for device, in host controller PCI config space. This
- *	is used both to set PIO timings in PIO mode and also to set the
- *	matching PIO clocking for UDMA, as well as the MWDMA timings.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void atp850_load_piomode(struct ata_port *ap, struct ata_device *adev,
-				unsigned int pio)
-{
-	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
-	int dn = adev->devno + 2 * ap->port_no;
-	const u16 timing[5] =
-		{ 0x0000, 0x000A, 0x0008, 0x0303, 0x0301 };
-
-	/* Load the PIO timing active/recovery bits */
-	pci_write_config_word(pdev, 0x40 + 2 * dn, timing[pio]);
-}
-
-/**
- *	atp850_set_piomode - Initialize host controller PATA PIO timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Device we are configuring
- *
- *	Set PIO mode for device, in host controller PCI config space. For
- *	ARTOP we must also clear the UDMA bits if we are not doing UDMA. In
- *	the event UDMA is used the later call to set_dmamode will set the
- *	bits as required.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void atp850_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
-	int dn = adev->devno + 2 * ap->port_no;
-	u8 ultra;
-
-	atp850_load_piomode(ap, adev, adev->pio_mode - XFER_PIO_0);
-
-	/* Clear the UDMA mode bits (set_dmamode will redo this if needed) */
-	pci_read_config_byte(pdev, 0x54, &ultra);
-	ultra &= ~(3 << (2 * dn));
-	pci_write_config_byte(pdev, 0x54, ultra);
-}
-
-/**
- *	atp86x_load_piomode - Initialize host controller PATA PIO timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Device we are configuring
- *	@pio: PIO mode
- *
- *	Set PIO mode for device, in host controller PCI config space.
- *	The ATP860 and relatives store the timing data differently.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void atp86x_load_piomode(struct ata_port *ap, struct ata_device *adev,
-				unsigned int pio)
-{
-	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
-	int dn = adev->devno + 2 * ap->port_no;
-	const u8 timing[5] =
-		{ 0x00, 0x0A, 0x08, 0x33, 0x31 };
-
-	/* Load the PIO timing active/recovery bits */
-	pci_write_config_byte(pdev, 0x40 + dn, timing[pio]);
-}
-
-/**
- *	atp86x_set_piomode - Initialize host controller PATA PIO timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Device we are configuring
- *
- *	Set PIO mode for device, in host controller PCI config space. For
- *	ARTOP we must also clear the UDMA bits if we are not doing UDMA. In
- *	the event UDMA is used the later call to set_dmamode will set the
- *	bits as required.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void atp86x_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
-	u8 ultra;
-
-	atp86x_load_piomode(ap, adev, adev->pio_mode - XFER_PIO_0);
-
-	/* Clear the UDMA mode bits (set_dmamode will redo this if needed) */
-	pci_read_config_byte(pdev, 0x44 + ap->port_no, &ultra);
-	ultra &= ~(7 << (4  * adev->devno));	/* One nibble per drive */
-	pci_write_config_byte(pdev, 0x44 + ap->port_no, ultra);
-}
-
-/**
- *	atp850_set_dmamode - Initialize host controller PATA PIO timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Device whose timings we are configuring
- *
- *	Set DMA mode for device, in host controller PCI config space.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void atp850_set_dmamode(struct ata_port *ap, struct ata_device *adev)
-{
-	unsigned int pio;
-	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
-	int dn = adev->devno + 2 * ap->port_no;
-	u8 ultra;
-
-	if (adev->dma_mode == XFER_MW_DMA_0)
-		pio = 1;
-	else
-		pio = 4;
-
-	/* Load the PIO timing active/recovery bits */
-	atp850_load_piomode(ap, adev, pio);
-
-	pci_read_config_byte(pdev, 0x54, &ultra);
-	ultra &= ~(3 << (2 * dn));
-
-	/* Add ultra DMA bits if in UDMA mode */
-	if (adev->dma_mode >= XFER_UDMA_0) {
-		u8 mode = (adev->dma_mode - XFER_UDMA_0) + 1;
-		if (mode == 0)
-			mode = 1;
-		ultra |= (mode << (2 * dn));
-	}
-	pci_write_config_byte(pdev, 0x54, ultra);
-}
-
-/**
- *	atp86x_set_dmamode - Initialize host controller PATA PIO timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Device we are configuring
- *
- *	Set DMA mode for device, in host controller PCI config space.
- *	The ATP860 and relatives store the timing data differently.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void atp86x_set_dmamode(struct ata_port *ap, struct ata_device *adev)
-{
-	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
-	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
-	u8 ultra;
-
-	if (adev->dma_mode == XFER_MW_DMA_0)
-		pio = 1;
-	else
-		pio = 4;
-
-	/* Load the PIO timing active/recovery bits */
-	atp86x_load_piomode(ap, adev, pio);
-
-	/* Add ultra DMA bits if in UDMA mode */
-	pci_read_config_byte(pdev, 0x44 + ap->port_no, &ultra);
-	ultra &= ~(7 << (4  * adev->devno));	/* One nibble per drive */
-	if (adev->dma_mode >= XFER_UDMA_0) {
-		u8 mode = adev->dma_mode - XFER_UDMA_0 + 1;
-		if (mode == 0)
-			mode = 1;
-		ultra |= (mode << (4 * adev->devno));
-	}
-	pci_write_config_byte(pdev, 0x44 + ap->port_no, ultra);
-}
+#include "pata_artop.h"
 
 /**
  *	atp850_qc_defer	-	implement serialization
@@ -302,38 +104,6 @@ static struct ata_port_operations atp86x
 	.prereset		= atp8xx_prereset,
 };
 
-static int atp8xx_fixup(struct device *dev)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-
-	if (pdev->device == 0x0005)
-		/* BIOS may have left us in UDMA, clear it before probe */
-		pci_write_config_byte(pdev, 0x54, 0);
-	else if (pdev->device == 0x0008 || pdev->device == 0x0009) {
-		u8 reg;
-
-		/* Mac systems come up with some registers not set as we
-		   will need them */
-
-		/* Clear reset & test bits */
-		pci_read_config_byte(pdev, 0x49, &reg);
-		pci_write_config_byte(pdev, 0x49, reg & ~ 0x30);
-
-		/* PCI latency must be > 0x80 for burst mode, tweak it
-		 * if required.
-		 */
-		pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &reg);
-		if (reg <= 0x80)
-			pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x90);
-
-		/* Enable IRQ output and burst mode */
-		pci_read_config_byte(pdev, 0x4a, &reg);
-		pci_write_config_byte(pdev, 0x4a, (reg & ~0x01) | 0x80);
-	}
-
-	return 0;
-}
-
 /**
  *	artop_init_one - Register ARTOP ATA PCI device with kernel services
  *	@pdev: PCI device to register
Index: b/drivers/ata/pata_artop.h
===================================================================
--- /dev/null
+++ b/drivers/ata/pata_artop.h
@@ -0,0 +1,230 @@
+
+/**
+ *	atp86x_cable_detect	-	identify cable type
+ *	@ap: Port
+ *
+ *	Identify the cable type for the ARTOP interface in question
+ */
+
+static int atp86x_cable_detect(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u8 tmp;
+	pci_read_config_byte(pdev, 0x49, &tmp);
+	if (tmp & (1 << ap->port_no))
+		return ATA_CBL_PATA40;
+	return ATA_CBL_PATA80;
+}
+
+/**
+ *	atp850_load_piomode - Load a set of PATA PIO timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: Device
+ *	@pio: PIO mode
+ *
+ *	Set PIO mode for device, in host controller PCI config space. This
+ *	is used both to set PIO timings in PIO mode and also to set the
+ *	matching PIO clocking for UDMA, as well as the MWDMA timings.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void atp850_load_piomode(struct ata_port *ap, struct ata_device *adev,
+				unsigned int pio)
+{
+	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	int dn = adev->devno + 2 * ap->port_no;
+	const u16 timing[5] = { 0x0000, 0x000A, 0x0008, 0x0303, 0x0301 };
+
+	/* Load the PIO timing active/recovery bits */
+	pci_write_config_word(pdev, 0x40 + 2 * dn, timing[pio]);
+}
+
+/**
+ *	atp850_set_piomode - Initialize host controller PATA PIO timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: Device we are configuring
+ *
+ *	Set PIO mode for device, in host controller PCI config space. For
+ *	ARTOP we must also clear the UDMA bits if we are not doing UDMA. In
+ *	the event UDMA is used the later call to set_dmamode will set the
+ *	bits as required.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void atp850_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	int dn = adev->devno + 2 * ap->port_no;
+	u8 ultra;
+
+	atp850_load_piomode(ap, adev, adev->pio_mode - XFER_PIO_0);
+
+	/* Clear the UDMA mode bits (set_dmamode will redo this if needed) */
+	pci_read_config_byte(pdev, 0x54, &ultra);
+	ultra &= ~(3 << (2 * dn));
+	pci_write_config_byte(pdev, 0x54, ultra);
+}
+
+/**
+ *	atp86x_load_piomode - Initialize host controller PATA PIO timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: Device we are configuring
+ *	@pio: PIO mode
+ *
+ *	Set PIO mode for device, in host controller PCI config space.
+ *	The ATP860 and relatives store the timing data differently.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void atp86x_load_piomode(struct ata_port *ap, struct ata_device *adev,
+				unsigned int pio)
+{
+	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	int dn = adev->devno + 2 * ap->port_no;
+	const u8 timing[5] = { 0x00, 0x0A, 0x08, 0x33, 0x31 };
+
+	/* Load the PIO timing active/recovery bits */
+	pci_write_config_byte(pdev, 0x40 + dn, timing[pio]);
+}
+
+/**
+ *	atp86x_set_piomode - Initialize host controller PATA PIO timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: Device we are configuring
+ *
+ *	Set PIO mode for device, in host controller PCI config space. For
+ *	ARTOP we must also clear the UDMA bits if we are not doing UDMA. In
+ *	the event UDMA is used the later call to set_dmamode will set the
+ *	bits as required.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void atp86x_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	u8 ultra;
+
+	atp86x_load_piomode(ap, adev, adev->pio_mode - XFER_PIO_0);
+
+	/* Clear the UDMA mode bits (set_dmamode will redo this if needed) */
+	pci_read_config_byte(pdev, 0x44 + ap->port_no, &ultra);
+	ultra &= ~(7 << (4  * adev->devno));	/* One nibble per drive */
+	pci_write_config_byte(pdev, 0x44 + ap->port_no, ultra);
+}
+
+/**
+ *	atp850_set_dmamode - Initialize host controller PATA PIO timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: Device whose timings we are configuring
+ *
+ *	Set DMA mode for device, in host controller PCI config space.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void atp850_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	unsigned int pio;
+	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	int dn = adev->devno + 2 * ap->port_no;
+	u8 ultra;
+
+	if (adev->dma_mode == XFER_MW_DMA_0)
+		pio = 1;
+	else
+		pio = 4;
+
+	/* Load the PIO timing active/recovery bits */
+	atp850_load_piomode(ap, adev, pio);
+
+	pci_read_config_byte(pdev, 0x54, &ultra);
+	ultra &= ~(3 << (2 * dn));
+
+	/* Add ultra DMA bits if in UDMA mode */
+	if (adev->dma_mode >= XFER_UDMA_0) {
+		u8 mode = (adev->dma_mode - XFER_UDMA_0) + 1;
+		if (mode == 0)
+			mode = 1;
+		ultra |= (mode << (2 * dn));
+	}
+	pci_write_config_byte(pdev, 0x54, ultra);
+}
+
+/**
+ *	atp86x_set_dmamode - Initialize host controller PATA PIO timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: Device we are configuring
+ *
+ *	Set DMA mode for device, in host controller PCI config space.
+ *	The ATP860 and relatives store the timing data differently.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void atp86x_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
+	struct pci_dev *pdev	= to_pci_dev(ap->host->dev);
+	u8 ultra;
+
+	if (adev->dma_mode == XFER_MW_DMA_0)
+		pio = 1;
+	else
+		pio = 4;
+
+	/* Load the PIO timing active/recovery bits */
+	atp86x_load_piomode(ap, adev, pio);
+
+	/* Add ultra DMA bits if in UDMA mode */
+	pci_read_config_byte(pdev, 0x44 + ap->port_no, &ultra);
+	ultra &= ~(7 << (4  * adev->devno));	/* One nibble per drive */
+	if (adev->dma_mode >= XFER_UDMA_0) {
+		u8 mode = adev->dma_mode - XFER_UDMA_0 + 1;
+		if (mode == 0)
+			mode = 1;
+		ultra |= (mode << (4 * adev->devno));
+	}
+	pci_write_config_byte(pdev, 0x44 + ap->port_no, ultra);
+}
+
+static int atp8xx_fixup(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (pdev->device == 0x0005)
+		/* BIOS may have left us in UDMA, clear it before probe */
+		pci_write_config_byte(pdev, 0x54, 0);
+	else if (pdev->device == 0x0008 || pdev->device == 0x0009) {
+		u8 reg;
+
+		/* Mac systems come up with some registers not set as we
+		   will need them */
+
+		/* Clear reset & test bits */
+		pci_read_config_byte(pdev, 0x49, &reg);
+		pci_write_config_byte(pdev, 0x49, reg & ~0x30);
+
+		/* PCI latency must be > 0x80 for burst mode, tweak it
+		 * if required.
+		 */
+		pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &reg);
+		if (reg <= 0x80)
+			pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x90);
+
+		/* Enable IRQ output and burst mode */
+		pci_read_config_byte(pdev, 0x4a, &reg);
+		pci_write_config_byte(pdev, 0x4a, (reg & ~0x01) | 0x80);
+	}
+
+	return 0;
+}
