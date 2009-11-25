Return-Path: <linux-kernel-owner+w=401wt.eu-S933579AbZKYRLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579AbZKYRLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:11:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933241AbZKYRLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:11:04 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39574 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759378AbZKYRKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:10:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=mrYdtFeKnTT6WdiGxvR3u1OsBQ/QkpZvdi2uLLgDdTIVishSymlH71GspHFl0FiKn9
         NJHKXC/6JnczEWMz54KVU8IdGQSqa0AjP4am/wGDOn4XTjrXQu05C1kbjeNnQx7abmt4
         sJadF8uFTl+WRqQxy04h+9ONdGQsXpJ01GM0c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:10:10 +0100
Message-Id: <20091125171010.5446.8481.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 65/86] pata_rdc: unify code for programming PIO and MWDMA timings
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_rdc: unify code for programming PIO and MWDMA timings

It results in ~8% decrease in the driver LOC count and also ~8%
decrease in the driver binary size (as measured on x86-32).

Fix rdc_set_piomode() documentation while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_rdc.c |   99 ++++++++++++++++---------------------------------
 1 file changed, 33 insertions(+), 66 deletions(-)

Index: b/drivers/ata/pata_rdc.c
===================================================================
--- a/drivers/ata/pata_rdc.c
+++ b/drivers/ata/pata_rdc.c
@@ -85,20 +85,9 @@ static int rdc_pata_prereset(struct ata_
 	return ata_sff_prereset(link, deadline);
 }
 
-/**
- *	rdc_set_piomode - Initialize host controller PATA PIO timings
- *	@ap: Port whose timings we are configuring
- *	@adev: um
- *
- *	Set PIO mode for device, in host controller PCI config space.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void rdc_set_piomode(struct ata_port *ap, struct ata_device *adev)
+static void rdc_set_timings(struct ata_port *ap, struct ata_device *adev,
+			    u8 pio, bool use_mwdma)
 {
-	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
 	unsigned int is_slave	= (adev->devno != 0);
 	unsigned int master_port= ap->port_no ? 0x42 : 0x40;
@@ -115,13 +104,17 @@ static void rdc_set_piomode(struct ata_p
 			    { 2, 1 },
 			    { 2, 3 }, };
 
-	if (pio >= 2)
+	if (pio >= 2 || use_mwdma)
 		control |= 1;	/* TIME1 enable */
-	if (ata_pio_need_iordy(adev))
+	if (ata_pio_need_iordy(adev) || use_mwdma)
 		control |= 2;	/* IE enable */
-
 	if (adev->class == ATA_DEV_ATA)
 		control |= 4;	/* PPE enable */
+	/* If the drive MWDMA is faster than it can do PIO then
+	   we must force PIO into PIO0 */
+	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))
+		/* Enable DMA timing only */
+		control |= 8;	/* PIO cycles in PIO0 */
 
 	/* PIO configuration clears DTE unconditionally.  It will be
 	 * programmed in set_dmamode which is guaranteed to be called
@@ -163,6 +156,22 @@ static void rdc_set_piomode(struct ata_p
 }
 
 /**
+ *	rdc_set_piomode - Initialize host controller PATA PIO timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: Drive in question
+ *
+ *	Set PIO mode for device, in host controller PCI config space.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void rdc_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	rdc_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0, 0);
+}
+
+/**
  *	rdc_set_dmamode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Drive in question
@@ -176,28 +185,18 @@ static void rdc_set_piomode(struct ata_p
 static void rdc_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	u8 master_port		= ap->port_no ? 0x42 : 0x40;
-	u16 master_data;
 	u8 speed		= adev->dma_mode;
 	int devid		= adev->devno + 2 * ap->port_no;
 	u8 udma_enable		= 0;
 
-	static const	 /* ISP  RTC */
-	u8 timings[][2]	= { { 0, 0 },
-			    { 0, 0 },
-			    { 1, 0 },
-			    { 2, 1 },
-			    { 2, 3 }, };
-
-	pci_read_config_word(dev, master_port, &master_data);
-	pci_read_config_byte(dev, 0x48, &udma_enable);
-
 	if (speed >= XFER_UDMA_0) {
-		unsigned int udma = adev->dma_mode - XFER_UDMA_0;
+		unsigned int udma = speed - XFER_UDMA_0;
 		u16 udma_timing;
 		u16 ideconf;
 		int u_clock, u_speed;
 
+		pci_read_config_byte(dev, 0x48, &udma_enable);
+
 		/*
 		 * UDMA is handled by a combination of clock switching and
 		 * selection of dividers
@@ -226,50 +225,18 @@ static void rdc_set_dmamode(struct ata_p
 		ideconf &= ~(0x1001 << devid);
 		ideconf |= u_clock << devid;
 		pci_write_config_word(dev, 0x54, ideconf);
+
+		pci_write_config_byte(dev, 0x48, udma_enable);
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
 		const unsigned int needed_pio[3] = {
 			XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
 		};
 		int pio = needed_pio[mwdma] - XFER_PIO_0;
 
-		control = 3;	/* IORDY|TIME1 */
-
-		/* If the drive MWDMA is faster than it can do PIO then
-		   we must force PIO into PIO0 */
-
-		if (adev->pio_mode < needed_pio[mwdma])
-			/* Enable DMA timing only */
-			control |= 8;	/* PIO cycles in PIO0 */
-
-		if (adev->devno) {	/* Slave */
-			master_data &= 0xFF4F;  /* Mask out IORDY|TIME1|DMAONLY */
-			master_data |= control << 4;
-			pci_read_config_byte(dev, 0x44, &slave_data);
-			slave_data &= (ap->port_no ? 0x0f : 0xf0);
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
-
-		udma_enable &= ~(1 << devid);
-		pci_write_config_word(dev, master_port, master_data);
+		rdc_set_timings(ap, adev, pio, 1);
 	}
-	pci_write_config_byte(dev, 0x48, udma_enable);
 }
 
 static struct ata_port_operations rdc_pata_ops = {
