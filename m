Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169Ab0A2QKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab0A2QKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:10:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229Ab0A2QJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:09:57 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:47963 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab0A2QJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:09:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=JfmqdOesbeNnIgeNRAxrJ0t6zVDu10JsVeWixXIQtT6uLD9Nom2qAkoEfMmvgVD2R2
         TX4MKeLr+3e9v64t9OfbSn5bE9+yWDT3eGYio65otk22y3dUHw+fQw6e4SDApv9bFlU/
         dZo4rB+oHDewjL4AJYUqC2vwKURG1ytbQ2Sy4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:09:47 +0100
Message-Id: <20100129160947.21495.39530.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 62/68] pata_sl82c105: move code to be re-used by ide2libata to pata_sl82c105.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_sl82c105: move code to be re-used by ide2libata to pata_sl82c105.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_sl82c105.c |  106 --------------------------------------------
 drivers/ata/pata_sl82c105.h |  106 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 107 insertions(+), 105 deletions(-)

Index: b/drivers/ata/pata_sl82c105.c
===================================================================
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -28,18 +28,7 @@
 #define DRV_NAME "pata_sl82c105"
 #define DRV_VERSION "0.3.3"
 
-enum {
-	/*
-	 * SL82C105 PCI config register 0x40 bits.
-	 */
-	CTRL_IDE_IRQB	=	(1 << 30),
-	CTRL_IDE_IRQA   =	(1 << 28),
-	CTRL_LEGIRQ     =	(1 << 11),
-	CTRL_P1F16      =	(1 << 5),
-	CTRL_P1EN       =	(1 << 4),
-	CTRL_P0F16      =	(1 << 1),
-	CTRL_P0EN       =	(1 << 0)
-};
+#include "pata_sl82c105.h"
 
 /**
  *	sl82c105_pre_reset		-	probe begin
@@ -104,50 +93,6 @@ static void sl82c105_set_piomode(struct
 }
 
 /**
- *	sl82c105_configure_dmamode	-	set DMA mode in chip
- *	@ap: ATA interface
- *	@adev: ATA device
- *
- *	Load DMA cycle times into the chip ready for a DMA transfer
- *	to occur.
- */
-
-static void sl82c105_configure_dmamode(struct ata_port *ap, struct ata_device *adev)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	static u16 dma_timing[3] = {
-		0x707, 0x201, 0x200
-	};
-	u16 dummy;
-	int timing = 0x44 + (8 * ap->port_no) + (4 * adev->devno);
-	int dma = adev->dma_mode - XFER_MW_DMA_0;
-
-	pci_write_config_word(pdev, timing, dma_timing[dma]);
-	/* Can we lose this oddity of the old driver */
-	pci_read_config_word(pdev, timing, &dummy);
-}
-
-/**
- *	sl82c105_reset_engine	-	Reset the DMA engine
- *	@ap: ATA interface
- *
- *	The sl82c105 has some serious problems with the DMA engine
- *	when transfers don't run as expected or ATAPI is used. The
- *	recommended fix is to reset the engine each use using a chip
- *	test register.
- */
-
-static void sl82c105_reset_engine(struct ata_port *ap)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u16 val;
-
-	pci_read_config_word(pdev, 0x7E, &val);
-	pci_write_config_word(pdev, 0x7E, val | 4);
-	pci_write_config_word(pdev, 0x7E, val & ~4);
-}
-
-/**
  *	sl82c105_bmdma_start		-	DMA engine begin
  *	@qc: ATA command
  *
@@ -242,55 +187,6 @@ static struct ata_port_operations sl82c1
 	.prereset	= sl82c105_pre_reset,
 };
 
-/**
- *	sl82c105_bridge_revision	-	find bridge version
- *	@pdev: PCI device for the ATA function
- *
- *	Locates the PCI bridge associated with the ATA function and
- *	providing it is a Winbond 553 reports the revision. If it cannot
- *	find a revision or the right device it returns -1
- */
-
-static int sl82c105_bridge_revision(struct pci_dev *pdev)
-{
-	struct pci_dev *bridge;
-
-	/*
-	 * The bridge should be part of the same device, but function 0.
-	 */
-	bridge = pci_get_slot(pdev->bus,
-			       PCI_DEVFN(PCI_SLOT(pdev->devfn), 0));
-	if (!bridge)
-		return -1;
-
-	/*
-	 * Make sure it is a Winbond 553 and is an ISA bridge.
-	 */
-	if (bridge->vendor != PCI_VENDOR_ID_WINBOND ||
-	    bridge->device != PCI_DEVICE_ID_WINBOND_83C553 ||
-	    bridge->class >> 8 != PCI_CLASS_BRIDGE_ISA) {
-	    	pci_dev_put(bridge);
-		return -1;
-	}
-	/*
-	 * We need to find function 0's revision, not function 1
-	 */
-	pci_dev_put(bridge);
-	return bridge->revision;
-}
-
-static int sl82c105_fixup(struct device *dev)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	u32 val;
-
-	pci_read_config_dword(pdev, 0x40, &val);
-	val |= CTRL_P0EN | CTRL_P0F16 | CTRL_P1F16;
-	pci_write_config_dword(pdev, 0x40, val);
-
-	return 0;
-}
-
 static int sl82c105_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info_dma = {
Index: b/drivers/ata/pata_sl82c105.h
===================================================================
--- /dev/null
+++ b/drivers/ata/pata_sl82c105.h
@@ -0,0 +1,106 @@
+
+enum {
+	/*
+	 * SL82C105 PCI config register 0x40 bits.
+	 */
+	CTRL_IDE_IRQB	=	(1 << 30),
+	CTRL_IDE_IRQA   =	(1 << 28),
+	CTRL_LEGIRQ     =	(1 << 11),
+	CTRL_P1F16      =	(1 << 5),
+	CTRL_P1EN       =	(1 << 4),
+	CTRL_P0F16      =	(1 << 1),
+	CTRL_P0EN       =	(1 << 0)
+};
+
+/**
+ *	sl82c105_configure_dmamode	-	set DMA mode in chip
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Load DMA cycle times into the chip ready for a DMA transfer
+ *	to occur.
+ */
+
+static void sl82c105_configure_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	static u16 dma_timing[3] = {
+		0x707, 0x201, 0x200
+	};
+	u16 dummy;
+	int timing = 0x44 + (8 * ap->port_no) + (4 * adev->devno);
+	int dma = adev->dma_mode - XFER_MW_DMA_0;
+
+	pci_write_config_word(pdev, timing, dma_timing[dma]);
+	/* Can we lose this oddity of the old driver */
+	pci_read_config_word(pdev, timing, &dummy);
+}
+
+/**
+ *	sl82c105_reset_engine	-	Reset the DMA engine
+ *	@ap: ATA interface
+ *
+ *	The sl82c105 has some serious problems with the DMA engine
+ *	when transfers don't run as expected or ATAPI is used. The
+ *	recommended fix is to reset the engine each use using a chip
+ *	test register.
+ */
+
+static void sl82c105_reset_engine(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u16 val;
+
+	pci_read_config_word(pdev, 0x7E, &val);
+	pci_write_config_word(pdev, 0x7E, val | 4);
+	pci_write_config_word(pdev, 0x7E, val & ~4);
+}
+
+/**
+ *	sl82c105_bridge_revision	-	find bridge version
+ *	@pdev: PCI device for the ATA function
+ *
+ *	Locates the PCI bridge associated with the ATA function and
+ *	providing it is a Winbond 553 reports the revision. If it cannot
+ *	find a revision or the right device it returns -1
+ */
+
+static int sl82c105_bridge_revision(struct pci_dev *pdev)
+{
+	struct pci_dev *bridge;
+
+	/*
+	 * The bridge should be part of the same device, but function 0.
+	 */
+	bridge = pci_get_slot(pdev->bus,
+			       PCI_DEVFN(PCI_SLOT(pdev->devfn), 0));
+	if (!bridge)
+		return -1;
+
+	/*
+	 * Make sure it is a Winbond 553 and is an ISA bridge.
+	 */
+	if (bridge->vendor != PCI_VENDOR_ID_WINBOND ||
+	    bridge->device != PCI_DEVICE_ID_WINBOND_83C553 ||
+	    bridge->class >> 8 != PCI_CLASS_BRIDGE_ISA) {
+		pci_dev_put(bridge);
+		return -1;
+	}
+	/*
+	 * We need to find function 0's revision, not function 1
+	 */
+	pci_dev_put(bridge);
+	return bridge->revision;
+}
+
+static int sl82c105_fixup(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	u32 val;
+
+	pci_read_config_dword(pdev, 0x40, &val);
+	val |= CTRL_P0EN | CTRL_P0F16 | CTRL_P1F16;
+	pci_write_config_dword(pdev, 0x40, val);
+
+	return 0;
+}
