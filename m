Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417Ab0A2QId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab0A2QId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373Ab0A2QIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:08:30 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab0A2QIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:08:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=dMfYSH11jXpQqmy9lEEezCkCEYzWfMcAXT2m7SekSRo99mI4GGMp/6MHd4bmUresLi
         yOMw5JCcw42CKUIroQZXkP9b7GQLoYZ21ic2004GaerpKqcX6pfRhNYEOU8P67FulHC0
         inxc3qfMdCUUeZcVU9g8Xnv6JiFCejRAdeavE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:08:16 +0100
Message-Id: <20100129160816.21495.94589.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 48/68] pata_cypress: move code to be re-used by ide2libata to pata_cypress.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cypress: move code to be re-used by ide2libata to pata_cypress.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cypress.c |   88 ---------------------------------------------
 drivers/ata/pata_cypress.h |   88 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+), 87 deletions(-)

Index: b/drivers/ata/pata_cypress.c
===================================================================
--- a/drivers/ata/pata_cypress.c
+++ b/drivers/ata/pata_cypress.c
@@ -20,93 +20,7 @@
 #define DRV_NAME "pata_cypress"
 #define DRV_VERSION "0.1.5"
 
-/* here are the offset definitions for the registers */
-
-enum {
-	CY82_IDE_CMDREG		= 0x04,
-	CY82_IDE_ADDRSETUP	= 0x48,
-	CY82_IDE_MASTER_IOR	= 0x4C,
-	CY82_IDE_MASTER_IOW	= 0x4D,
-	CY82_IDE_SLAVE_IOR	= 0x4E,
-	CY82_IDE_SLAVE_IOW	= 0x4F,
-	CY82_IDE_MASTER_8BIT	= 0x50,
-	CY82_IDE_SLAVE_8BIT	= 0x51,
-
-	CY82_INDEX_PORT		= 0x22,
-	CY82_DATA_PORT		= 0x23,
-
-	CY82_INDEX_CTRLREG1	= 0x01,
-	CY82_INDEX_CHANNEL0	= 0x30,
-	CY82_INDEX_CHANNEL1	= 0x31,
-	CY82_INDEX_TIMEOUT	= 0x32
-};
-
-/**
- *	cy82c693_set_piomode	-	set initial PIO mode data
- *	@ap: ATA interface
- *	@adev: ATA device
- *
- *	Called to do the PIO mode setup.
- */
-
-static void cy82c693_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	struct ata_timing t;
-	const unsigned long T = 1000000 / 33;
-	short time_16, time_8;
-	u32 addr;
-
-	ata_timing_compute(adev->id, adev->pio_mode, adev->pio_mode, &t, T, 1);
-
-	time_16 = clamp_val(t.recover - 1, 0, 15) |
-		  (clamp_val(t.active - 1, 0, 15) << 4);
-	time_8 = clamp_val(t.act8b - 1, 0, 15) |
-		 (clamp_val(t.rec8b - 1, 0, 15) << 4);
-
-	if (adev->devno == 0) {
-		pci_read_config_dword(pdev, CY82_IDE_ADDRSETUP, &addr);
-
-		addr &= ~0x0F;	/* Mask bits */
-		addr |= clamp_val(t.setup - 1, 0, 15);
-
-		pci_write_config_dword(pdev, CY82_IDE_ADDRSETUP, addr);
-		pci_write_config_byte(pdev, CY82_IDE_MASTER_IOR, time_16);
-		pci_write_config_byte(pdev, CY82_IDE_MASTER_IOW, time_16);
-		pci_write_config_byte(pdev, CY82_IDE_MASTER_8BIT, time_8);
-	} else {
-		pci_read_config_dword(pdev, CY82_IDE_ADDRSETUP, &addr);
-
-		addr &= ~0xF0;	/* Mask bits */
-		addr |= (clamp_val(t.setup - 1, 0, 15) << 4);
-
-		pci_write_config_dword(pdev, CY82_IDE_ADDRSETUP, addr);
-		pci_write_config_byte(pdev, CY82_IDE_SLAVE_IOR, time_16);
-		pci_write_config_byte(pdev, CY82_IDE_SLAVE_IOW, time_16);
-		pci_write_config_byte(pdev, CY82_IDE_SLAVE_8BIT, time_8);
-	}
-}
-
-/**
- *	cy82c693_set_dmamode	-	set initial DMA mode data
- *	@ap: ATA interface
- *	@adev: ATA device
- *
- *	Called to do the DMA mode setup.
- */
-
-static void cy82c693_set_dmamode(struct ata_port *ap, struct ata_device *adev)
-{
-	int reg = CY82_INDEX_CHANNEL0 + ap->port_no;
-
-	/* Be afraid, be very afraid. Magic registers  in low I/O space */
-	outb(reg, 0x22);
-	outb(adev->dma_mode - XFER_MW_DMA_0, 0x23);
-
-	/* 0x50 gives the best behaviour on the Alpha's using this chip */
-	outb(CY82_INDEX_TIMEOUT, 0x22);
-	outb(0x50, 0x23);
-}
+#include "pata_cypress.h"
 
 static struct scsi_host_template cy82c693_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
Index: b/drivers/ata/pata_cypress.h
===================================================================
--- /dev/null
+++ b/drivers/ata/pata_cypress.h
@@ -0,0 +1,88 @@
+
+/* here are the offset definitions for the registers */
+
+enum {
+	CY82_IDE_CMDREG		= 0x04,
+	CY82_IDE_ADDRSETUP	= 0x48,
+	CY82_IDE_MASTER_IOR	= 0x4C,
+	CY82_IDE_MASTER_IOW	= 0x4D,
+	CY82_IDE_SLAVE_IOR	= 0x4E,
+	CY82_IDE_SLAVE_IOW	= 0x4F,
+	CY82_IDE_MASTER_8BIT	= 0x50,
+	CY82_IDE_SLAVE_8BIT	= 0x51,
+
+	CY82_INDEX_PORT		= 0x22,
+	CY82_DATA_PORT		= 0x23,
+
+	CY82_INDEX_CTRLREG1	= 0x01,
+	CY82_INDEX_CHANNEL0	= 0x30,
+	CY82_INDEX_CHANNEL1	= 0x31,
+	CY82_INDEX_TIMEOUT	= 0x32
+};
+
+/**
+ *	cy82c693_set_piomode	-	set initial PIO mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Called to do the PIO mode setup.
+ */
+
+static void cy82c693_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	struct ata_timing t;
+	const unsigned long T = 1000000 / 33;
+	short time_16, time_8;
+	u32 addr;
+
+	ata_timing_compute(adev->id, adev->pio_mode, adev->pio_mode, &t, T, 1);
+
+	time_16 = clamp_val(t.recover - 1, 0, 15) |
+		  (clamp_val(t.active - 1, 0, 15) << 4);
+	time_8 = clamp_val(t.act8b - 1, 0, 15) |
+		 (clamp_val(t.rec8b - 1, 0, 15) << 4);
+
+	if (adev->devno == 0) {
+		pci_read_config_dword(pdev, CY82_IDE_ADDRSETUP, &addr);
+
+		addr &= ~0x0F;	/* Mask bits */
+		addr |= clamp_val(t.setup - 1, 0, 15);
+
+		pci_write_config_dword(pdev, CY82_IDE_ADDRSETUP, addr);
+		pci_write_config_byte(pdev, CY82_IDE_MASTER_IOR, time_16);
+		pci_write_config_byte(pdev, CY82_IDE_MASTER_IOW, time_16);
+		pci_write_config_byte(pdev, CY82_IDE_MASTER_8BIT, time_8);
+	} else {
+		pci_read_config_dword(pdev, CY82_IDE_ADDRSETUP, &addr);
+
+		addr &= ~0xF0;	/* Mask bits */
+		addr |= (clamp_val(t.setup - 1, 0, 15) << 4);
+
+		pci_write_config_dword(pdev, CY82_IDE_ADDRSETUP, addr);
+		pci_write_config_byte(pdev, CY82_IDE_SLAVE_IOR, time_16);
+		pci_write_config_byte(pdev, CY82_IDE_SLAVE_IOW, time_16);
+		pci_write_config_byte(pdev, CY82_IDE_SLAVE_8BIT, time_8);
+	}
+}
+
+/**
+ *	cy82c693_set_dmamode	-	set initial DMA mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Called to do the DMA mode setup.
+ */
+
+static void cy82c693_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	int reg = CY82_INDEX_CHANNEL0 + ap->port_no;
+
+	/* Be afraid, be very afraid. Magic registers  in low I/O space */
+	outb(reg, 0x22);
+	outb(adev->dma_mode - XFER_MW_DMA_0, 0x23);
+
+	/* 0x50 gives the best behaviour on the Alpha's using this chip */
+	outb(CY82_INDEX_TIMEOUT, 0x22);
+	outb(0x50, 0x23);
+}
