Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407Ab0A2QI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab0A2QI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029Ab0A2QIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:08:53 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab0A2QIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:08:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=TCXJW7RGX1YWhz8TbVUhHq97+ZwfJyZel5an+aF+FFaDabZW0hJ9T4l+2qONVXyukj
         dW7xN+rh/ZXxhBskz//n02yVNsQHGyvW/1q03SpA8QVY6NQdDW5PQ4dzafz4zqkqF99o
         kDJe0wxivnBFOq/VULLI6HvfIxw9a/HNBfFBk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:08:42 +0100
Message-Id: <20100129160842.21495.25009.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 52/68] pata_it8213: move code to be re-used by ide2libata to pata_it8213.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_it8213: move code to be re-used by ide2libata to pata_it8213.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_it8213.c |  150 ----------------------------------------------
 drivers/ata/pata_it8213.h |  150 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 151 insertions(+), 149 deletions(-)

Index: b/drivers/ata/pata_it8213.c
===================================================================
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -43,155 +43,7 @@ static int it8213_pre_reset(struct ata_l
 	return ata_sff_prereset(link, deadline);
 }
 
-/**
- *	it8213_cable_detect	-	check for 40/80 pin
- *	@ap: Port
- *
- *	Perform cable detection for the 8213 ATA interface. This is
- *	different to the PIIX arrangement
- */
-
-static int it8213_cable_detect(struct ata_port *ap)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 tmp;
-	pci_read_config_byte(pdev, 0x42, &tmp);
-	if (tmp & 2)	/* The initial docs are incorrect */
-		return ATA_CBL_PATA40;
-	return ATA_CBL_PATA80;
-}
-
-static void it8213_set_timings(struct ata_port *ap, struct ata_device *adev,
-			       u8 pio, bool use_mwdma)
-{
-	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	u8 master_port		= ap->port_no ? 0x42 : 0x40;
-	u16 master_data;
-	int control = 0;
-
-	/*
-	 *	See Intel Document 298600-004 for the timing programing rules
-	 *	for PIIX/ICH. The 8213 is a clone so very similar
-	 */
-
-	static const	 /* ISP  RTC */
-	u8 timings[][2]	= { { 0, 0 },
-			    { 0, 0 },
-			    { 1, 0 },
-			    { 2, 1 },
-			    { 2, 3 }, };
-
-	if (pio > 1 || use_mwdma)
-		control |= 1;	/* TIME */
-	if (ata_pio_need_iordy(adev) || use_mwdma)
-		control |= 2;	/* IE */
-	/* Bit 2 is set for ATAPI on the IT8213 - reverse of ICH/PIIX */
-	if (adev->class != ATA_DEV_ATA)
-		control |= 4;	/* PPE */
-	/* If the drive MWDMA is faster than it can do PIO then
-	   we must force PIO into PIO0 */
-	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))
-		/* Enable DMA timing only */
-		control |= 8;	/* PIO cycles in PIO0 */
-
-	pci_read_config_word(dev, master_port, &master_data);
-
-	/* Set PPE, IE, and TIME as appropriate */
-	if (adev->devno == 0) {
-		master_data &= 0xCCF0;
-		master_data |= control;
-		master_data |= (timings[pio][0] << 12) |
-			(timings[pio][1] << 8);
-	} else {
-		u8 slave_data;
-
-		master_data &= 0xFF0F;
-		master_data |= (control << 4);
-
-		/* Slave timing in separate register */
-		pci_read_config_byte(dev, 0x44, &slave_data);
-		slave_data &= 0xF0;
-		slave_data |= (timings[pio][0] << 2) | timings[pio][1];
-		pci_write_config_byte(dev, 0x44, slave_data);
-	}
-
-	master_data |= 0x4000;	/* Ensure SITRE is set */
-	pci_write_config_word(dev, master_port, master_data);
-}
-
-/**
- *	it8213_set_piomode - Initialize host controller PATA PIO timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Device whose timings we are configuring
- *
- *	Set PIO mode for device, in host controller PCI config space.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void it8213_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	it8213_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0, 0);
-}
-
-/**
- *	it8213_set_dmamode - Initialize host controller PATA DMA timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Device to program
- *
- *	Set UDMA/MWDMA mode for device, in host controller PCI config space.
- *	This device is basically an ICH alike.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void it8213_set_dmamode (struct ata_port *ap, struct ata_device *adev)
-{
-	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	u8 speed		= adev->dma_mode;
-	int devid		= adev->devno;
-	u8 udma_enable;
-
-	pci_read_config_byte(dev, 0x48, &udma_enable);
-
-	if (speed >= XFER_UDMA_0) {
-		unsigned int udma = speed - XFER_UDMA_0;
-		u16 udma_timing;
-		u16 ideconf;
-		int u_clock, u_speed;
-
-		/* Clocks follow the PIIX style */
-		u_speed = min(2 - (udma & 1), udma);
-		if (udma > 4)
-			u_clock = 0x1000;	/* 100Mhz */
-		else if (udma > 2)
-			u_clock = 1;		/* 66Mhz */
-		else
-			u_clock = 0;		/* 33Mhz */
-
-		udma_enable |= (1 << devid);
-
-		/* Load the UDMA cycle time */
-		pci_read_config_word(dev, 0x4A, &udma_timing);
-		udma_timing &= ~(3 << (4 * devid));
-		udma_timing |= u_speed << (4 * devid);
-		pci_write_config_word(dev, 0x4A, udma_timing);
-
-		/* Load the clock selection */
-		pci_read_config_word(dev, 0x54, &ideconf);
-		ideconf &= ~(0x1001 << devid);
-		ideconf |= u_clock << devid;
-		pci_write_config_word(dev, 0x54, ideconf);
-	} else {
-		/* MWDMA is driven by the PIO timings. */
-		it8213_set_timings(ap, adev, ata_mwdma_to_pio(speed), 1);
-
-		udma_enable &= ~(1 << devid);
-	}
-	pci_write_config_byte(dev, 0x48, udma_enable);
-}
+#include "pata_it8213.h"
 
 static struct scsi_host_template it8213_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
Index: b/drivers/ata/pata_it8213.h
===================================================================
--- /dev/null
+++ b/drivers/ata/pata_it8213.h
@@ -0,0 +1,150 @@
+
+/**
+ *	it8213_cable_detect	-	check for 40/80 pin
+ *	@ap: Port
+ *
+ *	Perform cable detection for the 8213 ATA interface. This is
+ *	different to the PIIX arrangement
+ */
+
+static int it8213_cable_detect(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u8 tmp;
+	pci_read_config_byte(pdev, 0x42, &tmp);
+	if (tmp & 2)	/* The initial docs are incorrect */
+		return ATA_CBL_PATA40;
+	return ATA_CBL_PATA80;
+}
+
+static void it8213_set_timings(struct ata_port *ap, struct ata_device *adev,
+			       u8 pio, bool use_mwdma)
+{
+	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	u8 master_port		= ap->port_no ? 0x42 : 0x40;
+	u16 master_data;
+	int control = 0;
+
+	/*
+	 *	See Intel Document 298600-004 for the timing programing rules
+	 *	for PIIX/ICH. The 8213 is a clone so very similar
+	 */
+
+	static const	 /* ISP  RTC */
+	u8 timings[][2]	= { { 0, 0 },
+			    { 0, 0 },
+			    { 1, 0 },
+			    { 2, 1 },
+			    { 2, 3 }, };
+
+	if (pio > 1 || use_mwdma)
+		control |= 1;	/* TIME */
+	if (ata_pio_need_iordy(adev) || use_mwdma)
+		control |= 2;	/* IE */
+	/* Bit 2 is set for ATAPI on the IT8213 - reverse of ICH/PIIX */
+	if (adev->class != ATA_DEV_ATA)
+		control |= 4;	/* PPE */
+	/* If the drive MWDMA is faster than it can do PIO then
+	   we must force PIO into PIO0 */
+	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))
+		/* Enable DMA timing only */
+		control |= 8;	/* PIO cycles in PIO0 */
+
+	pci_read_config_word(dev, master_port, &master_data);
+
+	/* Set PPE, IE, and TIME as appropriate */
+	if (adev->devno == 0) {
+		master_data &= 0xCCF0;
+		master_data |= control;
+		master_data |= (timings[pio][0] << 12) |
+			(timings[pio][1] << 8);
+	} else {
+		u8 slave_data;
+
+		master_data &= 0xFF0F;
+		master_data |= (control << 4);
+
+		/* Slave timing in separate register */
+		pci_read_config_byte(dev, 0x44, &slave_data);
+		slave_data &= 0xF0;
+		slave_data |= (timings[pio][0] << 2) | timings[pio][1];
+		pci_write_config_byte(dev, 0x44, slave_data);
+	}
+
+	master_data |= 0x4000;	/* Ensure SITRE is set */
+	pci_write_config_word(dev, master_port, master_data);
+}
+
+/**
+ *	it8213_set_piomode - Initialize host controller PATA PIO timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: Device whose timings we are configuring
+ *
+ *	Set PIO mode for device, in host controller PCI config space.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void it8213_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	it8213_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0, 0);
+}
+
+/**
+ *	it8213_set_dmamode - Initialize host controller PATA DMA timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: Device to program
+ *
+ *	Set UDMA/MWDMA mode for device, in host controller PCI config space.
+ *	This device is basically an ICH alike.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void it8213_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	u8 speed		= adev->dma_mode;
+	int devid		= adev->devno;
+	u8 udma_enable;
+
+	pci_read_config_byte(dev, 0x48, &udma_enable);
+
+	if (speed >= XFER_UDMA_0) {
+		unsigned int udma = speed - XFER_UDMA_0;
+		u16 udma_timing;
+		u16 ideconf;
+		int u_clock, u_speed;
+
+		/* Clocks follow the PIIX style */
+		u_speed = min(2 - (udma & 1), udma);
+		if (udma > 4)
+			u_clock = 0x1000;	/* 100Mhz */
+		else if (udma > 2)
+			u_clock = 1;		/* 66Mhz */
+		else
+			u_clock = 0;		/* 33Mhz */
+
+		udma_enable |= (1 << devid);
+
+		/* Load the UDMA cycle time */
+		pci_read_config_word(dev, 0x4A, &udma_timing);
+		udma_timing &= ~(3 << (4 * devid));
+		udma_timing |= u_speed << (4 * devid);
+		pci_write_config_word(dev, 0x4A, udma_timing);
+
+		/* Load the clock selection */
+		pci_read_config_word(dev, 0x54, &ideconf);
+		ideconf &= ~(0x1001 << devid);
+		ideconf |= u_clock << devid;
+		pci_write_config_word(dev, 0x54, ideconf);
+	} else {
+		/* MWDMA is driven by the PIO timings. */
+		it8213_set_timings(ap, adev, ata_mwdma_to_pio(speed), 1);
+
+		udma_enable &= ~(1 << devid);
+	}
+	pci_write_config_byte(dev, 0x48, udma_enable);
+}
