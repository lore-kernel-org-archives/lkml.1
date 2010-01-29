Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689Ab0A2QJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab0A2QJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:09:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644Ab0A2QJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:09:49 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:47963 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab0A2QJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:09:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=LwCI67crWs8lcjKlfHei01dz0w/aaYEtFRSE1NqJQbenOnq7sxeGMa3HsjWae1r/cs
         c3GlW+tMWZ011zniW7NJUyrcujhF7tTjWt92A0aDxwokUxmPSLpYQ6YJbFDXXZ+6WFFf
         dMqKwMSlMFO5PFjQRe9IspYPYxcTjaRYV2h6M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:09:34 +0100
Message-Id: <20100129160934.21495.43012.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 60/68] pata_serverworks: move cable handling to pata_serverworks.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_serverworks: move cable handling to pata_serverworks.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_serverworks.c |  282 ----------------------------------------
 drivers/ata/pata_serverworks.h |  283 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 284 insertions(+), 281 deletions(-)

Index: b/drivers/ata/pata_serverworks.c
===================================================================
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -14,18 +14,6 @@
  *
  * RCC/ServerWorks IDE driver for Linux
  *
- *   OSB4: `Open South Bridge' IDE Interface (fn 1)
- *         supports UDMA mode 2 (33 MB/s)
- *
- *   CSB5: `Champion South Bridge' IDE Interface (fn 1)
- *         all revisions support UDMA mode 4 (66 MB/s)
- *         revision A2.0 and up support UDMA mode 5 (100 MB/s)
- *
- *         *** The CSB5 does not provide ANY register ***
- *         *** to detect 80-conductor cable presence. ***
- *
- *   CSB6: `Champion South Bridge' IDE Interface (optional: third channel)
- *
  * Documentation:
  *	Available under NDA only. Errata info very hard to get.
  */
@@ -42,102 +30,7 @@
 #define DRV_NAME "pata_serverworks"
 #define DRV_VERSION "0.4.3"
 
-#define SVWKS_CSB5_REVISION_NEW	0x92 /* min PCI_REVISION_ID for UDMA5 (A2.0) */
-#define SVWKS_CSB6_REVISION	0xa0 /* min PCI_REVISION_ID for UDMA4 (A1.0) */
-
-/* Seagate Barracuda ATA IV Family drives in UDMA mode 5
- * can overrun their FIFOs when used with the CSB5 */
-
-static const char *csb_bad_ata100[] = {
-	"ST320011A",
-	"ST340016A",
-	"ST360021A",
-	"ST380021A",
-	NULL
-};
-
-/**
- *	oem_cable	-	Dell/Sun serverworks cable detection
- *	@ap: ATA port to do cable detect
- *
- *	Dell PowerEdge and Sun Cobalt 'Alpine' hide the 40/80 pin select
- *	for their interfaces in the top two bits of the subsystem ID.
- */
-
-static int oem_cable(struct ata_port *ap)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-
-	if (pdev->subsystem_device & (1 << (ap->port_no + 14)))
-		return ATA_CBL_PATA80;
-	return ATA_CBL_PATA40;
-}
-
-struct sv_cable_table {
-	int device;
-	int subvendor;
-	int (*cable_detect)(struct ata_port *ap);
-};
-
-static struct sv_cable_table cable_detect[] = {
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_VENDOR_ID_DELL, oem_cable },
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE,   PCI_VENDOR_ID_DELL, oem_cable },
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_VENDOR_ID_SUN,  oem_cable },
-	{ PCI_DEVICE_ID_SERVERWORKS_OSB4IDE,   PCI_ANY_ID, ata_cable_40wire  },
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_ANY_ID, ata_cable_unknown },
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE,   PCI_ANY_ID, ata_cable_unknown },
-	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2,  PCI_ANY_ID, ata_cable_unknown },
-	{ PCI_DEVICE_ID_SERVERWORKS_HT1000IDE, PCI_ANY_ID, ata_cable_unknown },
-	{ }
-};
-
-/**
- *	serverworks_cable_detect	-	cable detection
- *	@ap: ATA port
- *
- *	Perform cable detection according to the device and subvendor
- *	identifications
- */
-
-static int serverworks_cable_detect(struct ata_port *ap)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	struct sv_cable_table *cb = cable_detect;
-
-	while(cb->device) {
-		if (cb->device == pdev->device &&
-		    (cb->subvendor == pdev->subsystem_vendor ||
-		      cb->subvendor == PCI_ANY_ID)) {
-			return cb->cable_detect(ap);
-		}
-		cb++;
-	}
-
-	BUG();
-	return -1;	/* kill compiler warning */
-}
-
-/**
- *	serverworks_is_csb	-	Check for CSB or OSB
- *	@pdev: PCI device to check
- *
- *	Returns true if the device being checked is known to be a CSB
- *	series device.
- */
-
-static u8 serverworks_is_csb(struct pci_dev *pdev)
-{
-	switch (pdev->device) {
-		case PCI_DEVICE_ID_SERVERWORKS_CSB5IDE:
-		case PCI_DEVICE_ID_SERVERWORKS_CSB6IDE:
-		case PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2:
-		case PCI_DEVICE_ID_SERVERWORKS_HT1000IDE:
-			return 1;
-		default:
-			break;
-	}
-	return 0;
-}
+#include "pata_serverworks.h"
 
 /**
  *	serverworks_osb4_filter	-	mode selection filter
@@ -156,7 +49,6 @@ static unsigned long serverworks_osb4_fi
 	return ata_bmdma_mode_filter(adev, mask);
 }
 
-
 /**
  *	serverworks_csb_filter	-	mode selection filter
  *	@adev: ATA device
@@ -185,72 +77,6 @@ static unsigned long serverworks_csb_fil
 	return ata_bmdma_mode_filter(adev, mask);
 }
 
-/**
- *	serverworks_set_piomode	-	set initial PIO mode data
- *	@ap: ATA interface
- *	@adev: ATA device
- *
- *	Program the OSB4/CSB5 timing registers for PIO. The PIO register
- *	load is done as a simple lookup.
- */
-static void serverworks_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	static const u8 pio_mode[] = { 0x5d, 0x47, 0x34, 0x22, 0x20 };
-	int offset = 1 + 2 * ap->port_no - adev->devno;
-	int devbits = (2 * ap->port_no + adev->devno) * 4;
-	u16 csb5_pio;
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	int pio = adev->pio_mode - XFER_PIO_0;
-
-	pci_write_config_byte(pdev, 0x40 + offset, pio_mode[pio]);
-
-	/* The OSB4 just requires the timing but the CSB series want the
-	   mode number as well */
-	if (serverworks_is_csb(pdev)) {
-		pci_read_config_word(pdev, 0x4A, &csb5_pio);
-		csb5_pio &= ~(0x0F << devbits);
-		pci_write_config_word(pdev, 0x4A, csb5_pio | (pio << devbits));
-	}
-}
-
-/**
- *	serverworks_set_dmamode	-	set initial DMA mode data
- *	@ap: ATA interface
- *	@adev: ATA device
- *
- *	Program the MWDMA/UDMA modes for the serverworks OSB4/CSB5
- *	chipset. The MWDMA mode values are pulled from a lookup table
- *	while the chipset uses mode number for UDMA.
- */
-
-static void serverworks_set_dmamode(struct ata_port *ap, struct ata_device *adev)
-{
-	static const u8 dma_mode[] = { 0x77, 0x21, 0x20 };
-	int offset = 1 + 2 * ap->port_no - adev->devno;
-	int devbits = 2 * ap->port_no + adev->devno;
-	u8 ultra;
-	u8 ultra_cfg;
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-
-	pci_read_config_byte(pdev, 0x54, &ultra_cfg);
-	pci_read_config_byte(pdev, 0x56 + ap->port_no, &ultra);
-	ultra &= ~(0x0F << (adev->devno * 4));
-
-	if (adev->dma_mode >= XFER_UDMA_0) {
-		pci_write_config_byte(pdev, 0x44 + offset,  0x20);
-
-		ultra |= (adev->dma_mode - XFER_UDMA_0)
-					<< (adev->devno * 4);
-		ultra_cfg |=  (1 << devbits);
-	} else {
-		pci_write_config_byte(pdev, 0x44 + offset,
-			dma_mode[adev->dma_mode - XFER_MW_DMA_0]);
-		ultra_cfg &= ~(1 << devbits);
-	}
-	pci_write_config_byte(pdev, 0x56 + ap->port_no, ultra);
-	pci_write_config_byte(pdev, 0x54, ultra_cfg);
-}
-
 static struct scsi_host_template serverworks_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
@@ -268,112 +94,6 @@ static struct ata_port_operations server
 	.mode_filter	= serverworks_csb_filter,
 };
 
-static int serverworks_fixup_osb4(struct pci_dev *pdev)
-{
-	u32 reg;
-	struct pci_dev *isa_dev = pci_get_device(PCI_VENDOR_ID_SERVERWORKS,
-		  PCI_DEVICE_ID_SERVERWORKS_OSB4, NULL);
-	if (isa_dev) {
-		pci_read_config_dword(isa_dev, 0x64, &reg);
-		reg &= ~0x00002000; /* disable 600ns interrupt mask */
-		if (!(reg & 0x00004000))
-			printk(KERN_DEBUG DRV_NAME ": UDMA not BIOS enabled.\n");
-		reg |=  0x00004000; /* enable UDMA/33 support */
-		pci_write_config_dword(isa_dev, 0x64, reg);
-		pci_dev_put(isa_dev);
-		return 0;
-	}
-	printk(KERN_WARNING DRV_NAME ": Unable to find bridge.\n");
-	return -ENODEV;
-}
-
-static int serverworks_fixup_csb(struct pci_dev *pdev)
-{
-	u8 btr;
-
-	/* Third Channel Test */
-	if (!(PCI_FUNC(pdev->devfn) & 1)) {
-		struct pci_dev * findev = NULL;
-		u32 reg4c = 0;
-		findev = pci_get_device(PCI_VENDOR_ID_SERVERWORKS,
-			PCI_DEVICE_ID_SERVERWORKS_CSB5, NULL);
-		if (findev) {
-			pci_read_config_dword(findev, 0x4C, &reg4c);
-			reg4c &= ~0x000007FF;
-			reg4c |=  0x00000040;
-			reg4c |=  0x00000020;
-			pci_write_config_dword(findev, 0x4C, reg4c);
-			pci_dev_put(findev);
-		}
-	} else {
-		struct pci_dev * findev = NULL;
-		u8 reg41 = 0;
-
-		findev = pci_get_device(PCI_VENDOR_ID_SERVERWORKS,
-				PCI_DEVICE_ID_SERVERWORKS_CSB6, NULL);
-		if (findev) {
-			pci_read_config_byte(findev, 0x41, &reg41);
-			reg41 &= ~0x40;
-			pci_write_config_byte(findev, 0x41, reg41);
-			pci_dev_put(findev);
-		}
-	}
-	/* setup the UDMA Control register
-	 *
-	 * 1. clear bit 6 to enable DMA
-	 * 2. enable DMA modes with bits 0-1
-	 * 	00 : legacy
-	 * 	01 : udma2
-	 * 	10 : udma2/udma4
-	 * 	11 : udma2/udma4/udma5
-	 */
-	pci_read_config_byte(pdev, 0x5A, &btr);
-	btr &= ~0x40;
-	if (!(PCI_FUNC(pdev->devfn) & 1))
-		btr |= 0x2;
-	else
-		btr |= (pdev->revision >= SVWKS_CSB5_REVISION_NEW) ? 0x3 : 0x2;
-	pci_write_config_byte(pdev, 0x5A, btr);
-
-	return btr;
-}
-
-static void serverworks_fixup_ht1000(struct pci_dev *pdev)
-{
-	u8 btr;
-	/* Setup HT1000 SouthBridge Controller - Single Channel Only */
-	pci_read_config_byte(pdev, 0x5A, &btr);
-	btr &= ~0x40;
-	btr |= 0x3;
-	pci_write_config_byte(pdev, 0x5A, btr);
-}
-
-static int serverworks_fixup(struct pci_dev *pdev)
-{
-	int rc = 0;
-
-	/* Force master latency timer to 64 PCI clocks */
-	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x40);
-
-	switch (pdev->device) {
-	case PCI_DEVICE_ID_SERVERWORKS_OSB4IDE:
-		rc = serverworks_fixup_osb4(pdev);
-		break;
-	case PCI_DEVICE_ID_SERVERWORKS_CSB5IDE:
-		ata_pci_bmdma_clear_simplex(pdev);
-		/* fall through */
-	case PCI_DEVICE_ID_SERVERWORKS_CSB6IDE:
-	case PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2:
-		rc = serverworks_fixup_csb(pdev);
-		break;
-	case PCI_DEVICE_ID_SERVERWORKS_HT1000IDE:
-		serverworks_fixup_ht1000(pdev);
-		break;
-	}
-
-	return rc;
-}
-
 static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info[4] = {
Index: b/drivers/ata/pata_serverworks.h
===================================================================
--- /dev/null
+++ b/drivers/ata/pata_serverworks.h
@@ -0,0 +1,283 @@
+
+/*
+ *   OSB4: `Open South Bridge' IDE Interface (fn 1)
+ *         supports UDMA mode 2 (33 MB/s)
+ *
+ *   CSB5: `Champion South Bridge' IDE Interface (fn 1)
+ *         all revisions support UDMA mode 4 (66 MB/s)
+ *         revision A2.0 and up support UDMA mode 5 (100 MB/s)
+ *
+ *         *** The CSB5 does not provide ANY register ***
+ *         *** to detect 80-conductor cable presence. ***
+ *
+ *   CSB6: `Champion South Bridge' IDE Interface (optional: third channel)
+ */
+
+#define SVWKS_CSB5_REVISION_NEW	0x92 /* min PCI_REVISION_ID for UDMA5 (A2.0) */
+#define SVWKS_CSB6_REVISION	0xa0 /* min PCI_REVISION_ID for UDMA4 (A1.0) */
+
+/* Seagate Barracuda ATA IV Family drives in UDMA mode 5
+ * can overrun their FIFOs when used with the CSB5 */
+
+static const char *csb_bad_ata100[] = {
+	"ST320011A",
+	"ST340016A",
+	"ST360021A",
+	"ST380021A",
+	NULL
+};
+
+/**
+ *	oem_cable	-	Dell/Sun serverworks cable detection
+ *	@ap: ATA port to do cable detect
+ *
+ *	Dell PowerEdge and Sun Cobalt 'Alpine' hide the 40/80 pin select
+ *	for their interfaces in the top two bits of the subsystem ID.
+ */
+
+static int oem_cable(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+
+	if (pdev->subsystem_device & (1 << (ap->port_no + 14)))
+		return ATA_CBL_PATA80;
+	return ATA_CBL_PATA40;
+}
+
+struct sv_cable_table {
+	int device;
+	int subvendor;
+	int (*cable_detect)(struct ata_port *ap);
+};
+
+static struct sv_cable_table cable_detect[] = {
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_VENDOR_ID_DELL, oem_cable },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE,   PCI_VENDOR_ID_DELL, oem_cable },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_VENDOR_ID_SUN,  oem_cable },
+	{ PCI_DEVICE_ID_SERVERWORKS_OSB4IDE,   PCI_ANY_ID, ata_cable_40wire  },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB5IDE,   PCI_ANY_ID, ata_cable_unknown },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE,   PCI_ANY_ID, ata_cable_unknown },
+	{ PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2,  PCI_ANY_ID, ata_cable_unknown },
+	{ PCI_DEVICE_ID_SERVERWORKS_HT1000IDE, PCI_ANY_ID, ata_cable_unknown },
+	{ }
+};
+
+/**
+ *	serverworks_cable_detect	-	cable detection
+ *	@ap: ATA port
+ *
+ *	Perform cable detection according to the device and subvendor
+ *	identifications
+ */
+
+static int serverworks_cable_detect(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	struct sv_cable_table *cb = cable_detect;
+
+	while (cb->device) {
+		if (cb->device == pdev->device &&
+		    (cb->subvendor == pdev->subsystem_vendor ||
+		      cb->subvendor == PCI_ANY_ID)) {
+			return cb->cable_detect(ap);
+		}
+		cb++;
+	}
+
+	BUG();
+	return -1;	/* kill compiler warning */
+}
+
+/**
+ *	serverworks_is_csb	-	Check for CSB or OSB
+ *	@pdev: PCI device to check
+ *
+ *	Returns true if the device being checked is known to be a CSB
+ *	series device.
+ */
+
+static u8 serverworks_is_csb(struct pci_dev *pdev)
+{
+	switch (pdev->device) {
+	case PCI_DEVICE_ID_SERVERWORKS_CSB5IDE:
+	case PCI_DEVICE_ID_SERVERWORKS_CSB6IDE:
+	case PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2:
+	case PCI_DEVICE_ID_SERVERWORKS_HT1000IDE:
+		return 1;
+	default:
+		break;
+	}
+	return 0;
+}
+
+/**
+ *	serverworks_set_piomode	-	set initial PIO mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Program the OSB4/CSB5 timing registers for PIO. The PIO register
+ *	load is done as a simple lookup.
+ */
+static void serverworks_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	static const u8 pio_mode[] = { 0x5d, 0x47, 0x34, 0x22, 0x20 };
+	int offset = 1 + 2 * ap->port_no - adev->devno;
+	int devbits = (2 * ap->port_no + adev->devno) * 4;
+	u16 csb5_pio;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	int pio = adev->pio_mode - XFER_PIO_0;
+
+	pci_write_config_byte(pdev, 0x40 + offset, pio_mode[pio]);
+
+	/* The OSB4 just requires the timing but the CSB series want the
+	   mode number as well */
+	if (serverworks_is_csb(pdev)) {
+		pci_read_config_word(pdev, 0x4A, &csb5_pio);
+		csb5_pio &= ~(0x0F << devbits);
+		pci_write_config_word(pdev, 0x4A, csb5_pio | (pio << devbits));
+	}
+}
+
+/**
+ *	serverworks_set_dmamode	-	set initial DMA mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Program the MWDMA/UDMA modes for the serverworks OSB4/CSB5
+ *	chipset. The MWDMA mode values are pulled from a lookup table
+ *	while the chipset uses mode number for UDMA.
+ */
+
+static void serverworks_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	static const u8 dma_mode[] = { 0x77, 0x21, 0x20 };
+	int offset = 1 + 2 * ap->port_no - adev->devno;
+	int devbits = 2 * ap->port_no + adev->devno;
+	u8 ultra;
+	u8 ultra_cfg;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+
+	pci_read_config_byte(pdev, 0x54, &ultra_cfg);
+	pci_read_config_byte(pdev, 0x56 + ap->port_no, &ultra);
+	ultra &= ~(0x0F << (adev->devno * 4));
+
+	if (adev->dma_mode >= XFER_UDMA_0) {
+		pci_write_config_byte(pdev, 0x44 + offset,  0x20);
+
+		ultra |= (adev->dma_mode - XFER_UDMA_0)
+					<< (adev->devno * 4);
+		ultra_cfg |=  (1 << devbits);
+	} else {
+		pci_write_config_byte(pdev, 0x44 + offset,
+			dma_mode[adev->dma_mode - XFER_MW_DMA_0]);
+		ultra_cfg &= ~(1 << devbits);
+	}
+	pci_write_config_byte(pdev, 0x56 + ap->port_no, ultra);
+	pci_write_config_byte(pdev, 0x54, ultra_cfg);
+}
+
+static int serverworks_fixup_osb4(struct pci_dev *pdev)
+{
+	u32 reg;
+	struct pci_dev *isa_dev = pci_get_device(PCI_VENDOR_ID_SERVERWORKS,
+		  PCI_DEVICE_ID_SERVERWORKS_OSB4, NULL);
+	if (isa_dev) {
+		pci_read_config_dword(isa_dev, 0x64, &reg);
+		reg &= ~0x00002000; /* disable 600ns interrupt mask */
+		if (!(reg & 0x00004000))
+			printk(KERN_DEBUG DRV_NAME ": UDMA not BIOS enabled.\n");
+		reg |=  0x00004000; /* enable UDMA/33 support */
+		pci_write_config_dword(isa_dev, 0x64, reg);
+		pci_dev_put(isa_dev);
+		return 0;
+	}
+	printk(KERN_WARNING DRV_NAME ": Unable to find bridge.\n");
+	return -ENODEV;
+}
+
+static int serverworks_fixup_csb(struct pci_dev *pdev)
+{
+	u8 btr;
+
+	/* Third Channel Test */
+	if (!(PCI_FUNC(pdev->devfn) & 1)) {
+		struct pci_dev *findev = NULL;
+		u32 reg4c = 0;
+		findev = pci_get_device(PCI_VENDOR_ID_SERVERWORKS,
+			PCI_DEVICE_ID_SERVERWORKS_CSB5, NULL);
+		if (findev) {
+			pci_read_config_dword(findev, 0x4C, &reg4c);
+			reg4c &= ~0x000007FF;
+			reg4c |=  0x00000040;
+			reg4c |=  0x00000020;
+			pci_write_config_dword(findev, 0x4C, reg4c);
+			pci_dev_put(findev);
+		}
+	} else {
+		struct pci_dev *findev = NULL;
+		u8 reg41 = 0;
+
+		findev = pci_get_device(PCI_VENDOR_ID_SERVERWORKS,
+				PCI_DEVICE_ID_SERVERWORKS_CSB6, NULL);
+		if (findev) {
+			pci_read_config_byte(findev, 0x41, &reg41);
+			reg41 &= ~0x40;
+			pci_write_config_byte(findev, 0x41, reg41);
+			pci_dev_put(findev);
+		}
+	}
+	/* setup the UDMA Control register
+	 *
+	 * 1. clear bit 6 to enable DMA
+	 * 2. enable DMA modes with bits 0-1
+	 * 	00 : legacy
+	 * 	01 : udma2
+	 * 	10 : udma2/udma4
+	 * 	11 : udma2/udma4/udma5
+	 */
+	pci_read_config_byte(pdev, 0x5A, &btr);
+	btr &= ~0x40;
+	if (!(PCI_FUNC(pdev->devfn) & 1))
+		btr |= 0x2;
+	else
+		btr |= (pdev->revision >= SVWKS_CSB5_REVISION_NEW) ? 0x3 : 0x2;
+	pci_write_config_byte(pdev, 0x5A, btr);
+
+	return btr;
+}
+
+static void serverworks_fixup_ht1000(struct pci_dev *pdev)
+{
+	u8 btr;
+	/* Setup HT1000 SouthBridge Controller - Single Channel Only */
+	pci_read_config_byte(pdev, 0x5A, &btr);
+	btr &= ~0x40;
+	btr |= 0x3;
+	pci_write_config_byte(pdev, 0x5A, btr);
+}
+
+static int serverworks_fixup(struct pci_dev *pdev)
+{
+	int rc = 0;
+
+	/* Force master latency timer to 64 PCI clocks */
+	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x40);
+
+	switch (pdev->device) {
+	case PCI_DEVICE_ID_SERVERWORKS_OSB4IDE:
+		rc = serverworks_fixup_osb4(pdev);
+		break;
+	case PCI_DEVICE_ID_SERVERWORKS_CSB5IDE:
+		ata_pci_bmdma_clear_simplex(pdev);
+		/* fall through */
+	case PCI_DEVICE_ID_SERVERWORKS_CSB6IDE:
+	case PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2:
+		rc = serverworks_fixup_csb(pdev);
+		break;
+	case PCI_DEVICE_ID_SERVERWORKS_HT1000IDE:
+		serverworks_fixup_ht1000(pdev);
+		break;
+	}
+
+	return rc;
+}
