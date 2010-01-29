Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459Ab0A2QIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab0A2QIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434Ab0A2QIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:08:39 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab0A2QIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:08:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=gIAItMZ832/ts8Wpx6g9P9YTHVbD+0FigY+AbJaSiL4vgo8ZiMKzk8N+P9imc+rjVb
         YWocYCqGgzqzMxDBa5VKe3zz7fV2CVuCo3gSAG4aI3RQR6qpkSvc8iLYDkUlS9H8hOkV
         MGeP4IzHcadQnQcIYxJJr5IvQjN5BwRyJqAO8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:08:29 +0100
Message-Id: <20100129160829.21495.39844.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 50/68] pata_efar: move code to be re-used by ide2libata to pata_efar.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_efar: move code to be re-used by ide2libata to pata_efar.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_efar.c |  151 -----------------------------------------------
 drivers/ata/pata_efar.h |  152 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 153 insertions(+), 150 deletions(-)

Index: b/drivers/ata/pata_efar.c
===================================================================
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -49,156 +49,7 @@ static int efar_pre_reset(struct ata_lin
 	return ata_sff_prereset(link, deadline);
 }
 
-/**
- *	efar_cable_detect	-	check for 40/80 pin
- *	@ap: Port
- *
- *	Perform cable detection for the EFAR ATA interface. This is
- *	different to the PIIX arrangement
- */
-
-static int efar_cable_detect(struct ata_port *ap)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 tmp;
-
-	pci_read_config_byte(pdev, 0x47, &tmp);
-	if (tmp & (2 >> ap->port_no))
-		return ATA_CBL_PATA40;
-	return ATA_CBL_PATA80;
-}
-
-static DEFINE_SPINLOCK(efar_lock);
-
-static void efar_set_timings(struct ata_port *ap, struct ata_device *adev,
-			     u8 pio, bool use_mwdma)
-{
-	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	unsigned long flags;
-	unsigned int is_slave	= (adev->devno != 0);
-	u8 master_port		= ap->port_no ? 0x42 : 0x40;
-	u16 master_data;
-	u8 slave_data;
-	u8 udma_enable;
-	int control = 0;
-
-	/*
-	 *	See Intel Document 298600-004 for the timing programing rules
-	 *	for PIIX/ICH. The EFAR is a clone so very similar
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
-	/* Intel specifies that the prefetch/posting is for disk only */
-	if (adev->class == ATA_DEV_ATA)
-		control |= 4;	/* PPE */
-	/* If the drive MWDMA is faster than it can do PIO then
-	   we must force PIO into PIO0 */
-	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))
-		/* Enable DMA timing only */
-		control |= 8;	/* PIO cycles in PIO0 */
-
-	spin_lock_irqsave(&efar_lock, flags);
-
-	pci_read_config_word(dev, master_port, &master_data);
-
-	/* Set PPE, IE, and TIME as appropriate */
-	if (is_slave == 0) {
-		master_data &= 0xCCF0;
-		master_data |= control;
-		master_data |= (timings[pio][0] << 12) |
-			(timings[pio][1] << 8);
-	} else {
-		int shift = 4 * ap->port_no;
-
-		master_data &= 0xFF0F;
-		master_data |= (control << 4);
-
-		/* Slave timing in separate register */
-		pci_read_config_byte(dev, 0x44, &slave_data);
-		slave_data &= ap->port_no ? 0x0F : 0xF0;
-		slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << shift;
-	}
-
-	master_data |= 0x4000;	/* Ensure SITRE is set */
-	pci_write_config_word(dev, master_port, master_data);
-	if (is_slave)
-		pci_write_config_byte(dev, 0x44, slave_data);
-
-	pci_read_config_byte(dev, 0x48, &udma_enable);
-	udma_enable &= ~(1 << (2 * ap->port_no + adev->devno));
-	pci_write_config_byte(dev, 0x48, udma_enable);
-
-	spin_unlock_irqrestore(&efar_lock, flags);
-}
-
-/**
- *	efar_set_piomode - Initialize host controller PATA PIO timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Device to program
- *
- *	Set PIO mode for device, in host controller PCI config space.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void efar_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	efar_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0, 0);
-}
-
-/**
- *	efar_set_dmamode - Initialize host controller PATA DMA timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Device to program
- *
- *	Set UDMA/MWDMA mode for device, in host controller PCI config space.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void efar_set_dmamode (struct ata_port *ap, struct ata_device *adev)
-{
-	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	unsigned long flags;
-	u8 speed		= adev->dma_mode;
-	int devid		= adev->devno + 2 * ap->port_no;
-	u8 udma_enable;
-
-	if (speed >= XFER_UDMA_0) {
-		unsigned int udma = speed - XFER_UDMA_0;
-		u16 udma_timing;
-
-		spin_lock_irqsave(&efar_lock, flags);
-
-		pci_read_config_byte(dev, 0x48, &udma_enable);
-
-		udma_enable |= (1 << devid);
-
-		/* Load the UDMA mode number */
-		pci_read_config_word(dev, 0x4A, &udma_timing);
-		udma_timing &= ~(7 << (4 * devid));
-		udma_timing |= udma << (4 * devid);
-		pci_write_config_word(dev, 0x4A, udma_timing);
-
-		pci_write_config_byte(dev, 0x48, udma_enable);
-
-		spin_unlock_irqrestore(&efar_lock, flags);
-	} else
-		/* MWDMA is driven by the PIO timings. */
-		efar_set_timings(ap, adev, ata_mwdma_to_pio(speed), 1);
-}
+#include "pata_efar.h"
 
 static struct scsi_host_template efar_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
Index: b/drivers/ata/pata_efar.h
===================================================================
--- /dev/null
+++ b/drivers/ata/pata_efar.h
@@ -0,0 +1,152 @@
+
+/**
+ *	efar_cable_detect	-	check for 40/80 pin
+ *	@ap: Port
+ *
+ *	Perform cable detection for the EFAR ATA interface. This is
+ *	different to the PIIX arrangement
+ */
+
+static int efar_cable_detect(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u8 tmp;
+
+	pci_read_config_byte(pdev, 0x47, &tmp);
+	if (tmp & (2 >> ap->port_no))
+		return ATA_CBL_PATA40;
+	return ATA_CBL_PATA80;
+}
+
+static DEFINE_SPINLOCK(efar_lock);
+
+static void efar_set_timings(struct ata_port *ap, struct ata_device *adev,
+			     u8 pio, bool use_mwdma)
+{
+	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	unsigned long flags;
+	unsigned int is_slave	= (adev->devno != 0);
+	u8 master_port		= ap->port_no ? 0x42 : 0x40;
+	u16 master_data;
+	u8 slave_data;
+	u8 udma_enable;
+	int control = 0;
+
+	/*
+	 *	See Intel Document 298600-004 for the timing programing rules
+	 *	for PIIX/ICH. The EFAR is a clone so very similar
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
+	/* Intel specifies that the prefetch/posting is for disk only */
+	if (adev->class == ATA_DEV_ATA)
+		control |= 4;	/* PPE */
+	/* If the drive MWDMA is faster than it can do PIO then
+	   we must force PIO into PIO0 */
+	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))
+		/* Enable DMA timing only */
+		control |= 8;	/* PIO cycles in PIO0 */
+
+	spin_lock_irqsave(&efar_lock, flags);
+
+	pci_read_config_word(dev, master_port, &master_data);
+
+	/* Set PPE, IE, and TIME as appropriate */
+	if (is_slave == 0) {
+		master_data &= 0xCCF0;
+		master_data |= control;
+		master_data |= (timings[pio][0] << 12) |
+			(timings[pio][1] << 8);
+	} else {
+		int shift = 4 * ap->port_no;
+
+		master_data &= 0xFF0F;
+		master_data |= (control << 4);
+
+		/* Slave timing in separate register */
+		pci_read_config_byte(dev, 0x44, &slave_data);
+		slave_data &= ap->port_no ? 0x0F : 0xF0;
+		slave_data |=
+			((timings[pio][0] << 2) | timings[pio][1]) << shift;
+	}
+
+	master_data |= 0x4000;	/* Ensure SITRE is set */
+	pci_write_config_word(dev, master_port, master_data);
+	if (is_slave)
+		pci_write_config_byte(dev, 0x44, slave_data);
+
+	pci_read_config_byte(dev, 0x48, &udma_enable);
+	udma_enable &= ~(1 << (2 * ap->port_no + adev->devno));
+	pci_write_config_byte(dev, 0x48, udma_enable);
+
+	spin_unlock_irqrestore(&efar_lock, flags);
+}
+
+/**
+ *	efar_set_piomode - Initialize host controller PATA PIO timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: Device to program
+ *
+ *	Set PIO mode for device, in host controller PCI config space.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void efar_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	efar_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0, 0);
+}
+
+/**
+ *	efar_set_dmamode - Initialize host controller PATA DMA timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: Device to program
+ *
+ *	Set UDMA/MWDMA mode for device, in host controller PCI config space.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void efar_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	unsigned long flags;
+	u8 speed		= adev->dma_mode;
+	int devid		= adev->devno + 2 * ap->port_no;
+	u8 udma_enable;
+
+	if (speed >= XFER_UDMA_0) {
+		unsigned int udma = speed - XFER_UDMA_0;
+		u16 udma_timing;
+
+		spin_lock_irqsave(&efar_lock, flags);
+
+		pci_read_config_byte(dev, 0x48, &udma_enable);
+
+		udma_enable |= (1 << devid);
+
+		/* Load the UDMA mode number */
+		pci_read_config_word(dev, 0x4A, &udma_timing);
+		udma_timing &= ~(7 << (4 * devid));
+		udma_timing |= udma << (4 * devid);
+		pci_write_config_word(dev, 0x4A, udma_timing);
+
+		pci_write_config_byte(dev, 0x48, udma_enable);
+
+		spin_unlock_irqrestore(&efar_lock, flags);
+	} else
+		/* MWDMA is driven by the PIO timings. */
+		efar_set_timings(ap, adev, ata_mwdma_to_pio(speed), 1);
+}
