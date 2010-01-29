Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716Ab0A2QJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab0A2QJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687Ab0A2QJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:09:21 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:47963 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574Ab0A2QJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:09:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=fp3grgR8Wm9nBzpsqf8w8VuWue8D/DJ5IMtX1ewCeulzmWaQ/DQsjGtifHT56XtmE0
         bseEkXZKpvP22s0nClxS4pImY9LESeXTkqeUtjN0zEnU0yuKsoMZguIcXCxiXJFLWqHY
         6/Lxcp78KDV49RtyO3s+iFKt0DrXKOloCOKwE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:09:09 +0100
Message-Id: <20100129160909.21495.27038.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 56/68] pata_pdc202xx_old: move code to be re-used by ide2libata to pata_pdc202xx_old.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_pdc202xx_old: move code to be re-used by ide2libata to pata_pdc202xx_old.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_pdc202xx_old.c |  109 ----------------------------------------
 drivers/ata/pata_pdc202xx_old.h |  109 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+), 108 deletions(-)

Index: b/drivers/ata/pata_pdc202xx_old.c
===================================================================
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -24,114 +24,7 @@
 #define DRV_NAME "pata_pdc202xx_old"
 #define DRV_VERSION "0.4.3"
 
-static int pdc2026x_cable_detect(struct ata_port *ap)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u16 cis;
-
-	pci_read_config_word(pdev, 0x50, &cis);
-	if (cis & (1 << (10 + ap->port_no)))
-		return ATA_CBL_PATA40;
-	return ATA_CBL_PATA80;
-}
-
-/**
- *	pdc202xx_configure_piomode	-	set chip PIO timing
- *	@ap: ATA interface
- *	@adev: ATA device
- *	@pio: PIO mode
- *
- *	Called to do the PIO mode setup. Our timing registers are shared
- *	so a configure_dmamode call will undo any work we do here and vice
- *	versa
- */
-
-static void pdc202xx_configure_piomode(struct ata_port *ap, struct ata_device *adev, int pio)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	int port = 0x60 + 8 * ap->port_no + 4 * adev->devno;
-	static u16 pio_timing[5] = {
-		0x0913, 0x050C , 0x0308, 0x0206, 0x0104
-	};
-	u8 r_ap, r_bp;
-
-	pci_read_config_byte(pdev, port, &r_ap);
-	pci_read_config_byte(pdev, port + 1, &r_bp);
-	r_ap &= ~0x3F;	/* Preserve ERRDY_EN, SYNC_IN */
-	r_bp &= ~0x1F;
-	r_ap |= (pio_timing[pio] >> 8);
-	r_bp |= (pio_timing[pio] & 0xFF);
-
-	if (ata_pio_need_iordy(adev))
-		r_ap |= 0x20;	/* IORDY enable */
-	if (adev->class == ATA_DEV_ATA)
-		r_ap |= 0x10;	/* FIFO enable */
-	pci_write_config_byte(pdev, port, r_ap);
-	pci_write_config_byte(pdev, port + 1, r_bp);
-}
-
-/**
- *	pdc202xx_set_piomode	-	set initial PIO mode data
- *	@ap: ATA interface
- *	@adev: ATA device
- *
- *	Called to do the PIO mode setup. Our timing registers are shared
- *	but we want to set the PIO timing by default.
- */
-
-static void pdc202xx_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	pdc202xx_configure_piomode(ap, adev, adev->pio_mode - XFER_PIO_0);
-}
-
-/**
- *	pdc202xx_configure_dmamode	-	set DMA mode in chip
- *	@ap: ATA interface
- *	@adev: ATA device
- *
- *	Load DMA cycle times into the chip ready for a DMA transfer
- *	to occur.
- */
-
-static void pdc202xx_set_dmamode(struct ata_port *ap, struct ata_device *adev)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	int port = 0x60 + 8 * ap->port_no + 4 * adev->devno;
-	static u8 udma_timing[6][2] = {
-		{ 0x60, 0x03 },	/* 33 Mhz Clock */
-		{ 0x40, 0x02 },
-		{ 0x20, 0x01 },
-		{ 0x40, 0x02 },	/* 66 Mhz Clock */
-		{ 0x20, 0x01 },
-		{ 0x20, 0x01 }
-	};
-	static u8 mdma_timing[3][2] = {
-		{ 0xe0, 0x0f },
-		{ 0x60, 0x04 },
-		{ 0x60, 0x03 },
-	};
-	u8 r_bp, r_cp;
-
-	pci_read_config_byte(pdev, port + 1, &r_bp);
-	pci_read_config_byte(pdev, port + 2, &r_cp);
-
-	r_bp &= ~0xE0;
-	r_cp &= ~0x0F;
-
-	if (adev->dma_mode >= XFER_UDMA_0) {
-		int speed = adev->dma_mode - XFER_UDMA_0;
-		r_bp |= udma_timing[speed][0];
-		r_cp |= udma_timing[speed][1];
-
-	} else {
-		int speed = adev->dma_mode - XFER_MW_DMA_0;
-		r_bp |= mdma_timing[speed][0];
-		r_cp |= mdma_timing[speed][1];
-	}
-	pci_write_config_byte(pdev, port + 1, r_bp);
-	pci_write_config_byte(pdev, port + 2, r_cp);
-
-}
+#include "pata_pdc202xx_old.h"
 
 /**
  *	pdc2026x_bmdma_start		-	DMA engine begin
Index: b/drivers/ata/pata_pdc202xx_old.h
===================================================================
--- /dev/null
+++ b/drivers/ata/pata_pdc202xx_old.h
@@ -0,0 +1,109 @@
+
+static int pdc2026x_cable_detect(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u16 cis;
+
+	pci_read_config_word(pdev, 0x50, &cis);
+	if (cis & (1 << (10 + ap->port_no)))
+		return ATA_CBL_PATA40;
+	return ATA_CBL_PATA80;
+}
+
+/**
+ *	pdc202xx_configure_piomode	-	set chip PIO timing
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *	@pio: PIO mode
+ *
+ *	Called to do the PIO mode setup. Our timing registers are shared
+ *	so a configure_dmamode call will undo any work we do here and vice
+ *	versa
+ */
+
+static void pdc202xx_configure_piomode(struct ata_port *ap, struct ata_device *adev, int pio)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	int port = 0x60 + 8 * ap->port_no + 4 * adev->devno;
+	static u16 pio_timing[5] = {
+		0x0913, 0x050C , 0x0308, 0x0206, 0x0104
+	};
+	u8 r_ap, r_bp;
+
+	pci_read_config_byte(pdev, port, &r_ap);
+	pci_read_config_byte(pdev, port + 1, &r_bp);
+	r_ap &= ~0x3F;	/* Preserve ERRDY_EN, SYNC_IN */
+	r_bp &= ~0x1F;
+	r_ap |= (pio_timing[pio] >> 8);
+	r_bp |= (pio_timing[pio] & 0xFF);
+
+	if (ata_pio_need_iordy(adev))
+		r_ap |= 0x20;	/* IORDY enable */
+	if (adev->class == ATA_DEV_ATA)
+		r_ap |= 0x10;	/* FIFO enable */
+	pci_write_config_byte(pdev, port, r_ap);
+	pci_write_config_byte(pdev, port + 1, r_bp);
+}
+
+/**
+ *	pdc202xx_set_piomode	-	set initial PIO mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Called to do the PIO mode setup. Our timing registers are shared
+ *	but we want to set the PIO timing by default.
+ */
+
+static void pdc202xx_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	pdc202xx_configure_piomode(ap, adev, adev->pio_mode - XFER_PIO_0);
+}
+
+/**
+ *	pdc202xx_configure_dmamode	-	set DMA mode in chip
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Load DMA cycle times into the chip ready for a DMA transfer
+ *	to occur.
+ */
+
+static void pdc202xx_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	int port = 0x60 + 8 * ap->port_no + 4 * adev->devno;
+	static u8 udma_timing[6][2] = {
+		{ 0x60, 0x03 },	/* 33 Mhz Clock */
+		{ 0x40, 0x02 },
+		{ 0x20, 0x01 },
+		{ 0x40, 0x02 },	/* 66 Mhz Clock */
+		{ 0x20, 0x01 },
+		{ 0x20, 0x01 }
+	};
+	static u8 mdma_timing[3][2] = {
+		{ 0xe0, 0x0f },
+		{ 0x60, 0x04 },
+		{ 0x60, 0x03 },
+	};
+	u8 r_bp, r_cp;
+
+	pci_read_config_byte(pdev, port + 1, &r_bp);
+	pci_read_config_byte(pdev, port + 2, &r_cp);
+
+	r_bp &= ~0xE0;
+	r_cp &= ~0x0F;
+
+	if (adev->dma_mode >= XFER_UDMA_0) {
+		int speed = adev->dma_mode - XFER_UDMA_0;
+		r_bp |= udma_timing[speed][0];
+		r_cp |= udma_timing[speed][1];
+
+	} else {
+		int speed = adev->dma_mode - XFER_MW_DMA_0;
+		r_bp |= mdma_timing[speed][0];
+		r_cp |= mdma_timing[speed][1];
+	}
+	pci_write_config_byte(pdev, port + 1, r_bp);
+	pci_write_config_byte(pdev, port + 2, r_cp);
+
+}
