Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605Ab0A2QH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0A2QH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641Ab0A2QHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:07:16 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab0A2QHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:07:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=mB8/rrOdbctu423zW/ZmXmtiALHDRsqAwhCrNIMSxUD9LxvE3VkVCAp9nCxyYqt5/m
         /I/s1DB6czB1K67Y37HgTuXxIiax+WwBddxm63LmYkme42CqLdRjxX8kQXQ+dW8y36bp
         JJ0r4sDTUb57i3CnX9R0MFHSV2jh7GMB/kk18=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:07:06 +0100
Message-Id: <20100129160706.21495.27690.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 37/68] pata_atiixp: move code to be re-used by ide2libata to pata_atiixp.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_atiixp: move code to be re-used by ide2libata to pata_atiixp.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_atiixp.c |  114 ---------------------------------------------
 drivers/ata/pata_atiixp.h |  116 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 117 insertions(+), 113 deletions(-)

Index: b/drivers/ata/pata_atiixp.c
===================================================================
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -24,28 +24,6 @@
 #define DRV_NAME "pata_atiixp"
 #define DRV_VERSION "0.4.6"
 
-enum {
-	ATIIXP_IDE_PIO_TIMING	= 0x40,
-	ATIIXP_IDE_MWDMA_TIMING	= 0x44,
-	ATIIXP_IDE_PIO_CONTROL	= 0x48,
-	ATIIXP_IDE_PIO_MODE	= 0x4a,
-	ATIIXP_IDE_UDMA_CONTROL	= 0x54,
-	ATIIXP_IDE_UDMA_MODE 	= 0x56
-};
-
-static int atiixp_cable_detect(struct ata_port *ap)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 udma;
-
-	/* Hack from drivers/ide/pci. Really we want to know how to do the
-	   raw detection not play follow the bios mode guess */
-	pci_read_config_byte(pdev, ATIIXP_IDE_UDMA_MODE + ap->port_no, &udma);
-	if ((udma & 0x07) >= 0x04 || (udma & 0x70) >= 0x40)
-		return  ATA_CBL_PATA80;
-	return ATA_CBL_PATA40;
-}
-
 /**
  *	atiixp_prereset	-	perform reset handling
  *	@link: ATA link
@@ -71,97 +49,7 @@ static int atiixp_prereset(struct ata_li
 	return ata_sff_prereset(link, deadline);
 }
 
-static DEFINE_SPINLOCK(atiixp_lock);
-
-/**
- *	atiixp_set_piomode	-	set PIO mode data
- *	@ap: ATA interface
- *	@adev: ATA device
- *
- *	Called to set the controller timings for PIO transfers.  We must
- *	load both the mode number and timing values into the controller.
- */
-
-static void atiixp_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	static u8 pio_timings[5] = { 0x5D, 0x47, 0x34, 0x22, 0x20 };
-
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	unsigned long flags;
-	int dn = 2 * ap->port_no + adev->devno;
-	int timing_shift = (16 * ap->port_no) + 8 * (adev->devno ^ 1);
-	int pio = adev->pio_mode - XFER_PIO_0;
-	u32 pio_timing_data;
-	u16 pio_mode_data;
-
-	spin_lock_irqsave(&atiixp_lock, flags);
-
-	pci_read_config_word(pdev, ATIIXP_IDE_PIO_MODE, &pio_mode_data);
-	pio_mode_data &= ~(0x7 << (4 * dn));
-	pio_mode_data |= pio << (4 * dn);
-	pci_write_config_word(pdev, ATIIXP_IDE_PIO_MODE, pio_mode_data);
-
-	pci_read_config_dword(pdev, ATIIXP_IDE_PIO_TIMING, &pio_timing_data);
-	pio_timing_data &= ~(0xFF << timing_shift);
-	pio_timing_data |= (pio_timings[pio] << timing_shift);
-	pci_write_config_dword(pdev, ATIIXP_IDE_PIO_TIMING, pio_timing_data);
-
-	spin_unlock_irqrestore(&atiixp_lock, flags);
-}
-
-/**
- *	atiixp_set_dmamode	-	set DMA mode data
- *	@ap: ATA interface
- *	@adev: ATA device
- *
- *	Called to do the DMA mode setup.
- */
-
-static void atiixp_set_dmamode(struct ata_port *ap, struct ata_device *adev)
-{
-	static u8 mwdma_timings[5] = { 0x77, 0x21, 0x20 };
-
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	unsigned long flags;
-	int dma = adev->dma_mode;
-	int dn = 2 * ap->port_no + adev->devno;
-	u16 tmp16;
-
-	spin_lock_irqsave(&atiixp_lock, flags);
-
-	pci_read_config_word(pdev, ATIIXP_IDE_UDMA_CONTROL, &tmp16);
-
-	if (adev->dma_mode >= XFER_UDMA_0) {
-		u16 udma_mode_data;
-
-		dma -= XFER_UDMA_0;
-
-		pci_read_config_word(pdev, ATIIXP_IDE_UDMA_MODE, &udma_mode_data);
-		udma_mode_data &= ~(0x7 << (4 * dn));
-		udma_mode_data |= dma << (4 * dn);
-		pci_write_config_word(pdev, ATIIXP_IDE_UDMA_MODE, udma_mode_data);
-
-		tmp16 |= (1 << dn);
-	} else {
-		int timing_shift = (16 * ap->port_no) + 8 * (adev->devno ^ 1);
-		u32 mwdma_timing_data;
-
-		dma -= XFER_MW_DMA_0;
-
-		pci_read_config_dword(pdev, ATIIXP_IDE_MWDMA_TIMING,
-				      &mwdma_timing_data);
-		mwdma_timing_data &= ~(0xFF << timing_shift);
-		mwdma_timing_data |= (mwdma_timings[dma] << timing_shift);
-		pci_write_config_dword(pdev, ATIIXP_IDE_MWDMA_TIMING,
-				       mwdma_timing_data);
-
-		tmp16 &= ~(1 << dn);
-	}
-
-	pci_write_config_word(pdev, ATIIXP_IDE_UDMA_CONTROL, tmp16);
-
-	spin_unlock_irqrestore(&atiixp_lock, flags);
-}
+#include "pata_atiixp.h"
 
 static struct scsi_host_template atiixp_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
Index: b/drivers/ata/pata_atiixp.h
===================================================================
--- /dev/null
+++ b/drivers/ata/pata_atiixp.h
@@ -0,0 +1,116 @@
+
+enum {
+	ATIIXP_IDE_PIO_TIMING	= 0x40,
+	ATIIXP_IDE_MWDMA_TIMING	= 0x44,
+	ATIIXP_IDE_PIO_CONTROL	= 0x48,
+	ATIIXP_IDE_PIO_MODE	= 0x4a,
+	ATIIXP_IDE_UDMA_CONTROL	= 0x54,
+	ATIIXP_IDE_UDMA_MODE 	= 0x56
+};
+
+static int atiixp_cable_detect(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u8 udma;
+
+	/* Hack from drivers/ide/pci. Really we want to know how to do the
+	   raw detection not play follow the bios mode guess */
+	pci_read_config_byte(pdev, ATIIXP_IDE_UDMA_MODE + ap->port_no, &udma);
+	if ((udma & 0x07) >= 0x04 || (udma & 0x70) >= 0x40)
+		return  ATA_CBL_PATA80;
+	return ATA_CBL_PATA40;
+}
+
+static DEFINE_SPINLOCK(atiixp_lock);
+
+/**
+ *	atiixp_set_piomode	-	set PIO mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Called to set the controller timings for PIO transfers.  We must
+ *	load both the mode number and timing values into the controller.
+ */
+
+static void atiixp_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	static u8 pio_timings[5] = { 0x5D, 0x47, 0x34, 0x22, 0x20 };
+
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	unsigned long flags;
+	int dn = 2 * ap->port_no + adev->devno;
+	int timing_shift = (16 * ap->port_no) + 8 * (adev->devno ^ 1);
+	int pio = adev->pio_mode - XFER_PIO_0;
+	u32 pio_timing_data;
+	u16 pio_mode_data;
+
+	spin_lock_irqsave(&atiixp_lock, flags);
+
+	pci_read_config_word(pdev, ATIIXP_IDE_PIO_MODE, &pio_mode_data);
+	pio_mode_data &= ~(0x7 << (4 * dn));
+	pio_mode_data |= pio << (4 * dn);
+	pci_write_config_word(pdev, ATIIXP_IDE_PIO_MODE, pio_mode_data);
+
+	pci_read_config_dword(pdev, ATIIXP_IDE_PIO_TIMING, &pio_timing_data);
+	pio_timing_data &= ~(0xFF << timing_shift);
+	pio_timing_data |= (pio_timings[pio] << timing_shift);
+	pci_write_config_dword(pdev, ATIIXP_IDE_PIO_TIMING, pio_timing_data);
+
+	spin_unlock_irqrestore(&atiixp_lock, flags);
+}
+
+/**
+ *	atiixp_set_dmamode	-	set DMA mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Called to do the DMA mode setup.
+ */
+
+static void atiixp_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	static u8 mwdma_timings[5] = { 0x77, 0x21, 0x20 };
+
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	unsigned long flags;
+	int dma = adev->dma_mode;
+	int dn = 2 * ap->port_no + adev->devno;
+	u16 tmp16;
+
+	spin_lock_irqsave(&atiixp_lock, flags);
+
+	pci_read_config_word(pdev, ATIIXP_IDE_UDMA_CONTROL, &tmp16);
+
+	if (adev->dma_mode >= XFER_UDMA_0) {
+		u16 udma_mode_data;
+
+		dma -= XFER_UDMA_0;
+
+		pci_read_config_word(pdev, ATIIXP_IDE_UDMA_MODE,
+				     &udma_mode_data);
+		udma_mode_data &= ~(0x7 << (4 * dn));
+		udma_mode_data |= dma << (4 * dn);
+		pci_write_config_word(pdev, ATIIXP_IDE_UDMA_MODE,
+				      udma_mode_data);
+
+		tmp16 |= (1 << dn);
+	} else {
+		int timing_shift = (16 * ap->port_no) + 8 * (adev->devno ^ 1);
+		u32 mwdma_timing_data;
+
+		dma -= XFER_MW_DMA_0;
+
+		pci_read_config_dword(pdev, ATIIXP_IDE_MWDMA_TIMING,
+				      &mwdma_timing_data);
+		mwdma_timing_data &= ~(0xFF << timing_shift);
+		mwdma_timing_data |= (mwdma_timings[dma] << timing_shift);
+		pci_write_config_dword(pdev, ATIIXP_IDE_MWDMA_TIMING,
+				       mwdma_timing_data);
+
+		tmp16 &= ~(1 << dn);
+	}
+
+	pci_write_config_word(pdev, ATIIXP_IDE_UDMA_CONTROL, tmp16);
+
+	spin_unlock_irqrestore(&atiixp_lock, flags);
+}
