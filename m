Return-Path: <linux-kernel-owner+w=401wt.eu-S932656AbZKYRH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656AbZKYRH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932618AbZKYRHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:07:55 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57397 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456AbZKYRHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:07:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ZtaEHnoO0L/w6WupZsq686uXH2Xmy7CjWF8Y8296pKkTIg7sY4H1OLBSJRiKQjaaVM
         m8fyWA7y7bgJTBEHymC+UQR/n6YL5nqVembaObgZf5hoCW5ci5TBHD1zC8WG7Ogp8HId
         0ksZY5OGNjuYJ6Rs/WQ/V7IYA3j7shNftlhpE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:07:12 +0100
Message-Id: <20091125170712.5446.50300.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 41/86] pata_efar: unify code for programming PIO and MWDMA timings
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_it8213: unify code for programming PIO and MWDMA timings

It results in ~9% decrease in the driver LOC count and also ~6%
decrease in the driver binary size (as measured on x86-32).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_it8213.c |   87 +++++++++++++++-------------------------------
 1 file changed, 29 insertions(+), 58 deletions(-)

Index: b/drivers/ata/pata_it8213.c
===================================================================
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -61,20 +61,9 @@ static int it8213_cable_detect(struct at
 	return ATA_CBL_PATA80;
 }
 
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
-static void it8213_set_piomode (struct ata_port *ap, struct ata_device *adev)
+static void it8213_set_timings(struct ata_port *ap, struct ata_device *adev,
+			       u8 pio, bool use_mwdma)
 {
-	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
 	u8 master_port		= ap->port_no ? 0x42 : 0x40;
 	u16 master_data;
@@ -92,13 +81,18 @@ static void it8213_set_piomode (struct a
 			    { 2, 1 },
 			    { 2, 3 }, };
 
-	if (pio > 1)
+	if (pio > 1 || use_mwdma)
 		control |= 1;	/* TIME */
-	if (ata_pio_need_iordy(adev))	/* PIO 3/4 require IORDY */
+	if (ata_pio_need_iordy(adev) || use_mwdma)
 		control |= 2;	/* IE */
 	/* Bit 2 is set for ATAPI on the IT8213 - reverse of ICH/PIIX */
 	if (adev->class != ATA_DEV_ATA)
 		control |= 4;	/* PPE */
+	/* If the drive MWDMA is faster than it can do PIO then
+	   we must force PIO into PIO0 */
+	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))
+		/* Enable DMA timing only */
+		control |= 8;	/* PIO cycles in PIO0 */
 
 	pci_read_config_word(dev, master_port, &master_data);
 
@@ -127,6 +121,22 @@ static void it8213_set_piomode (struct a
 }
 
 /**
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
  *	it8213_set_dmamode - Initialize host controller PATA DMA timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device to program
@@ -141,23 +151,14 @@ static void it8213_set_piomode (struct a
 static void it8213_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	u16 master_data;
 	u8 speed		= adev->dma_mode;
 	int devid		= adev->devno;
 	u8 udma_enable;
 
-	static const	 /* ISP  RTC */
-	u8 timings[][2]	= { { 0, 0 },
-			    { 0, 0 },
-			    { 1, 0 },
-			    { 2, 1 },
-			    { 2, 3 }, };
-
-	pci_read_config_word(dev, 0x40, &master_data);
 	pci_read_config_byte(dev, 0x48, &udma_enable);
 
 	if (speed >= XFER_UDMA_0) {
-		unsigned int udma = adev->dma_mode - XFER_UDMA_0;
+		unsigned int udma = speed - XFER_UDMA_0;
 		u16 udma_timing;
 		u16 ideconf;
 		int u_clock, u_speed;
@@ -185,46 +186,16 @@ static void it8213_set_dmamode (struct a
 		ideconf |= u_clock << devid;
 		pci_write_config_word(dev, 0x54, ideconf);
 	} else {
-		/*
-		 * MWDMA is driven by the PIO timings. We must also enable
-		 * IORDY unconditionally along with TIME1. PPE has already
-		 * been set when the PIO timing was set.
-		 */
-		unsigned int mwdma	= adev->dma_mode - XFER_MW_DMA_0;
-		unsigned int control;
-		u8 slave_data;
+		/* MWDMA is driven by the PIO timings. */
+		unsigned int mwdma = speed - XFER_MW_DMA_0;
 		static const unsigned int needed_pio[3] = {
 			XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
 		};
 		int pio = needed_pio[mwdma] - XFER_PIO_0;
 
-		control = 3;	/* IORDY|TIME1 */
-
-		/* If the drive MWDMA is faster than it can do PIO then
-		   we must force PIO into PIO0 */
+		it8213_set_timings(ap, adev, pio, 1);
 
-		if (adev->pio_mode < needed_pio[mwdma])
-			/* Enable DMA timing only */
-			control |= 8;	/* PIO cycles in PIO0 */
-
-		if (devid) {	/* Slave */
-			master_data &= 0xFF4F;  /* Mask out IORDY|TIME1|DMAONLY */
-			master_data |= control << 4;
-			pci_read_config_byte(dev, 0x44, &slave_data);
-			slave_data &= 0xF0;
-			/* Load the matching timing */
-			slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << (ap->port_no ? 4 : 0);
-			pci_write_config_byte(dev, 0x44, slave_data);
-		} else { 	/* Master */
-			master_data &= 0xCCF4;	/* Mask out IORDY|TIME1|DMAONLY
-						   and master timing bits */
-			master_data |= control;
-			master_data |=
-				(timings[pio][0] << 12) |
-				(timings[pio][1] << 8);
-		}
 		udma_enable &= ~(1 << devid);
-		pci_write_config_word(dev, 0x40, master_data);
 	}
 	pci_write_config_byte(dev, 0x48, udma_enable);
 }
