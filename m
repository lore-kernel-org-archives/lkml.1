Return-Path: <linux-kernel-owner+w=401wt.eu-S1759299AbZKYRJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299AbZKYRJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933254AbZKYRJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:09:46 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:37967 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933137AbZKYRJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:09:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=xr+ob9/HpdCDgpxv5q6n9nuzGrAtn0R+nG76mzZcZmCzkGlRH86oOqWY537oaDS8tb
         wIZgHkyaGTMQYTp2GvwtfQYBQuwCaO7XZ/p+GI7FURqE6/Qs5gf1vZO8KprcdSHQNmT1
         D+56agOD/7+xxitNbpZfNK9C+LjsVpTy6KEHI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:09:03 +0100
Message-Id: <20091125170903.5446.45582.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 56/86] pata_oldpiix: unify code for programming PIO and MWDMA timings
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_oldpiix: unify code for programming PIO and MWDMA timings

It results in ~12% decrease in the driver LOC count and also ~5%
decrease in the driver binary size (as measured on x86-32).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_oldpiix.c |   88 +++++++++++++--------------------------------
 1 file changed, 27 insertions(+), 61 deletions(-)

Index: b/drivers/ata/pata_oldpiix.c
===================================================================
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -50,20 +50,9 @@ static int oldpiix_pre_reset(struct ata_
 	return ata_sff_prereset(link, deadline);
 }
 
-/**
- *	oldpiix_set_piomode - Initialize host controller PATA PIO timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Device whose timings we are configuring
- *
- *	Set PIO mode for device, in host controller PCI config space.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void oldpiix_set_piomode (struct ata_port *ap, struct ata_device *adev)
+static void oldpiix_set_timings(struct ata_port *ap, struct ata_device *adev,
+				u8 pio, bool use_mwdma)
 {
-	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
 	unsigned int idetm_port= ap->port_no ? 0x42 : 0x40;
 	u16 idetm_data;
@@ -82,14 +71,18 @@ static void oldpiix_set_piomode (struct 
 			    { 2, 1 },
 			    { 2, 3 }, };
 
-	if (pio > 1)
+	if (pio > 1 || use_mwdma)
 		control |= 1;	/* TIME */
-	if (ata_pio_need_iordy(adev))
+	if (ata_pio_need_iordy(adev) || use_mwdma)
 		control |= 2;	/* IE */
-
 	/* Intel specifies that the prefetch/posting is for disk only */
 	if (adev->class == ATA_DEV_ATA)
 		control |= 4;	/* PPE */
+	/* If the drive MWDMA is faster than it can do PIO then
+	   we must force PIO into PIO0 */
+	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))
+		/* Enable DMA timing only */
+		control |= 8;	/* PIO cycles in PIO0 */
 
 	pci_read_config_word(dev, idetm_port, &idetm_data);
 
@@ -113,6 +106,22 @@ static void oldpiix_set_piomode (struct 
 }
 
 /**
+ *	oldpiix_set_piomode - Initialize host controller PATA PIO timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: Device whose timings we are configuring
+ *
+ *	Set PIO mode for device, in host controller PCI config space.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void oldpiix_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	oldpiix_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0, 0);
+}
+
+/**
  *	oldpiix_set_dmamode - Initialize host controller PATA DMA timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device to program
@@ -125,58 +134,15 @@ static void oldpiix_set_piomode (struct 
 
 static void oldpiix_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 {
-	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	u8 idetm_port		= ap->port_no ? 0x42 : 0x40;
-	u16 idetm_data;
-
-	static const	 /* ISP  RTC */
-	u8 timings[][2]	= { { 0, 0 },
-			    { 0, 0 },
-			    { 1, 0 },
-			    { 2, 1 },
-			    { 2, 3 }, };
-
-	/*
-	 * MWDMA is driven by the PIO timings. We must also enable
-	 * IORDY unconditionally along with TIME1. PPE has already
-	 * been set when the PIO timing was set.
-	 */
+	/* MWDMA is driven by the PIO timings. */
 
 	unsigned int mwdma	= adev->dma_mode - XFER_MW_DMA_0;
-	unsigned int control;
 	const unsigned int needed_pio[3] = {
 		XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
 	};
 	int pio = needed_pio[mwdma] - XFER_PIO_0;
 
-	pci_read_config_word(dev, idetm_port, &idetm_data);
-
-	control = 3;	/* IORDY|TIME0 */
-	/* Intel specifies that the PPE functionality is for disk only */
-	if (adev->class == ATA_DEV_ATA)
-		control |= 4;	/* PPE enable */
-
-	/* If the drive MWDMA is faster than it can do PIO then
-	   we must force PIO into PIO0 */
-
-	if (adev->pio_mode < needed_pio[mwdma])
-		/* Enable DMA timing only */
-		control |= 8;	/* PIO cycles in PIO0 */
-
-	/* Mask out the relevant control and timing bits we will load. Also
-	   clear the other drive TIME register as a precaution */
-	if (adev->devno == 0) {
-		idetm_data &= 0xCCE0;
-		idetm_data |= control;
-	} else {
-		idetm_data &= 0xCC0E;
-		idetm_data |= (control << 4);
-	}
-	idetm_data |= (timings[pio][0] << 12) | (timings[pio][1] << 8);
-	pci_write_config_word(dev, idetm_port, idetm_data);
-
-	/* Track which port is configured */
-	ap->private_data = adev;
+	oldpiix_set_timings(ap, adev, pio, 1);
 }
 
 /**
