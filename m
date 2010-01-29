Return-Path: <linux-kernel-owner+w=401wt.eu-S1751479Ab0A2QIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab0A2QIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029Ab0A2QIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:08:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:61728 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab0A2QIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:08:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=lFL7QxGkt1npDcGGg0lKPN+Kodg1Y1WAQPivc74zkY0b48NVK4+UfnNamSlLKNd9w4
         5Eea0AtUv6xiIVrUMjJ5G/Ghrbcbf+zHfZfIeEshjSo8jti+yuaUluqT7FTX+5OFYvu5
         t1zBHItUP8Df7RjbQDcxFAX52PWnBHF1UGvao=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:08:04 +0100
Message-Id: <20100129160804.21495.98303.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 46/68] pata_cs5535: move code to be re-used by ide2libata to pata_cs5535.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cs5535: move code to be re-used by ide2libata to pata_cs5535.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cs5535.c |  113 ---------------------------------------------
 drivers/ata/pata_cs5535.h |  114 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 115 insertions(+), 112 deletions(-)

Index: b/drivers/ata/pata_cs5535.c
===================================================================
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -41,118 +41,7 @@
 #define DRV_NAME	"cs5535"
 #define DRV_VERSION	"0.2.12"
 
-/*
- *	The Geode (Aka Athlon GX now) uses an internal MSR based
- *	bus system for control. Demented but there you go.
- */
-
-#define MSR_ATAC_BASE    	0x51300000
-#define ATAC_GLD_MSR_CAP 	(MSR_ATAC_BASE+0)
-#define ATAC_GLD_MSR_CONFIG    (MSR_ATAC_BASE+0x01)
-#define ATAC_GLD_MSR_SMI       (MSR_ATAC_BASE+0x02)
-#define ATAC_GLD_MSR_ERROR     (MSR_ATAC_BASE+0x03)
-#define ATAC_GLD_MSR_PM        (MSR_ATAC_BASE+0x04)
-#define ATAC_GLD_MSR_DIAG      (MSR_ATAC_BASE+0x05)
-#define ATAC_IO_BAR            (MSR_ATAC_BASE+0x08)
-#define ATAC_RESET             (MSR_ATAC_BASE+0x10)
-#define ATAC_CH0D0_PIO         (MSR_ATAC_BASE+0x20)
-#define ATAC_CH0D0_DMA         (MSR_ATAC_BASE+0x21)
-#define ATAC_CH0D1_PIO         (MSR_ATAC_BASE+0x22)
-#define ATAC_CH0D1_DMA         (MSR_ATAC_BASE+0x23)
-#define ATAC_PCI_ABRTERR       (MSR_ATAC_BASE+0x24)
-
-#define ATAC_BM0_CMD_PRIM      0x00
-#define ATAC_BM0_STS_PRIM      0x02
-#define ATAC_BM0_PRD           0x04
-
-#define CS5535_CABLE_DETECT    0x48
-
-/**
- *	cs5535_cable_detect	-	detect cable type
- *	@ap: Port to detect on
- *
- *	Perform cable detection for ATA66 capable cable. Return a libata
- *	cable type.
- */
-
-static int cs5535_cable_detect(struct ata_port *ap)
-{
-	u8 cable;
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-
-	pci_read_config_byte(pdev, CS5535_CABLE_DETECT, &cable);
-	if (cable & 1)
-		return ATA_CBL_PATA80;
-	else
-		return ATA_CBL_PATA40;
-}
-
-/**
- *	cs5535_set_piomode		-	PIO setup
- *	@ap: ATA interface
- *	@adev: device on the interface
- *
- *	Set our PIO requirements. The CS5535 is pretty clean about all this
- */
-
-static void cs5535_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	static const u16 pio_timings[5] = {
-		0xF7F4, 0xF173, 0x8141, 0x5131, 0x1131
-	};
-	static const u16 pio_cmd_timings[5] = {
-		0xF7F4, 0x53F3, 0x13F1, 0x5131, 0x1131
-	};
-	u32 reg, dummy;
-	struct ata_device *pair = ata_dev_pair(adev);
-
-	int mode = adev->pio_mode - XFER_PIO_0;
-	int cmdmode = mode;
-
-	/* Command timing has to be for the lowest of the pair of devices */
-	if (pair) {
-		int pairmode = pair->pio_mode - XFER_PIO_0;
-		cmdmode = min(mode, pairmode);
-		/* Write the other drive timing register if it changed */
-		if (cmdmode < pairmode)
-			wrmsr(ATAC_CH0D0_PIO + 2 * pair->devno,
-				pio_cmd_timings[cmdmode] << 16 | pio_timings[pairmode], 0);
-	}
-	/* Write the drive timing register */
-	wrmsr(ATAC_CH0D0_PIO + 2 * adev->devno,
-		pio_cmd_timings[cmdmode] << 16 | pio_timings[mode], 0);
-
-	/* Set the PIO "format 1" bit in the DMA timing register */
-	rdmsr(ATAC_CH0D0_DMA + 2 * adev->devno, reg, dummy);
-	wrmsr(ATAC_CH0D0_DMA + 2 * adev->devno, reg | 0x80000000UL, 0);
-}
-
-/**
- *	cs5535_set_dmamode		-	DMA timing setup
- *	@ap: ATA interface
- *	@adev: Device being configured
- *
- */
-
-static void cs5535_set_dmamode(struct ata_port *ap, struct ata_device *adev)
-{
-	static const u32 udma_timings[5] = {
-		0x7F7436A1, 0x7F733481, 0x7F723261, 0x7F713161, 0x7F703061
-	};
-	static const u32 mwdma_timings[3] = {
-		0x7F0FFFF3, 0x7F035352, 0x7F024241
-	};
-	u32 reg, dummy;
-	int mode = adev->dma_mode;
-
-	rdmsr(ATAC_CH0D0_DMA + 2 * adev->devno, reg, dummy);
-	reg &= 0x80000000UL;
-	if (mode >= XFER_UDMA_0)
-		reg |= udma_timings[mode - XFER_UDMA_0];
-	else
-		reg |= mwdma_timings[mode - XFER_MW_DMA_0];
-	wrmsr(ATAC_CH0D0_DMA + 2 * adev->devno, reg, 0);
-}
+#include "pata_cs5535.h"
 
 static struct scsi_host_template cs5535_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
Index: b/drivers/ata/pata_cs5535.h
===================================================================
--- /dev/null
+++ b/drivers/ata/pata_cs5535.h
@@ -0,0 +1,114 @@
+
+/*
+ *	The Geode (Aka Athlon GX now) uses an internal MSR based
+ *	bus system for control. Demented but there you go.
+ */
+
+#define MSR_ATAC_BASE    	0x51300000
+#define ATAC_GLD_MSR_CAP 	(MSR_ATAC_BASE+0)
+#define ATAC_GLD_MSR_CONFIG	(MSR_ATAC_BASE+0x01)
+#define ATAC_GLD_MSR_SMI	(MSR_ATAC_BASE+0x02)
+#define ATAC_GLD_MSR_ERROR	(MSR_ATAC_BASE+0x03)
+#define ATAC_GLD_MSR_PM		(MSR_ATAC_BASE+0x04)
+#define ATAC_GLD_MSR_DIAG	(MSR_ATAC_BASE+0x05)
+#define ATAC_IO_BAR		(MSR_ATAC_BASE+0x08)
+#define ATAC_RESET		(MSR_ATAC_BASE+0x10)
+#define ATAC_CH0D0_PIO		(MSR_ATAC_BASE+0x20)
+#define ATAC_CH0D0_DMA		(MSR_ATAC_BASE+0x21)
+#define ATAC_CH0D1_PIO		(MSR_ATAC_BASE+0x22)
+#define ATAC_CH0D1_DMA		(MSR_ATAC_BASE+0x23)
+#define ATAC_PCI_ABRTERR	(MSR_ATAC_BASE+0x24)
+
+#define ATAC_BM0_CMD_PRIM	0x00
+#define ATAC_BM0_STS_PRIM	0x02
+#define ATAC_BM0_PRD		0x04
+
+#define CS5535_CABLE_DETECT	0x48
+
+/**
+ *	cs5535_cable_detect	-	detect cable type
+ *	@ap: Port to detect on
+ *
+ *	Perform cable detection for ATA66 capable cable. Return a libata
+ *	cable type.
+ */
+
+static int cs5535_cable_detect(struct ata_port *ap)
+{
+	u8 cable;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+
+	pci_read_config_byte(pdev, CS5535_CABLE_DETECT, &cable);
+	if (cable & 1)
+		return ATA_CBL_PATA80;
+	else
+		return ATA_CBL_PATA40;
+}
+
+/**
+ *	cs5535_set_piomode		-	PIO setup
+ *	@ap: ATA interface
+ *	@adev: device on the interface
+ *
+ *	Set our PIO requirements. The CS5535 is pretty clean about all this
+ */
+
+static void cs5535_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	static const u16 pio_timings[5] = {
+		0xF7F4, 0xF173, 0x8141, 0x5131, 0x1131
+	};
+	static const u16 pio_cmd_timings[5] = {
+		0xF7F4, 0x53F3, 0x13F1, 0x5131, 0x1131
+	};
+	u32 reg, dummy;
+	struct ata_device *pair = ata_dev_pair(adev);
+
+	int mode = adev->pio_mode - XFER_PIO_0;
+	int cmdmode = mode;
+
+	/* Command timing has to be for the lowest of the pair of devices */
+	if (pair) {
+		int pairmode = pair->pio_mode - XFER_PIO_0;
+		cmdmode = min(mode, pairmode);
+		/* Write the other drive timing register if it changed */
+		if (cmdmode < pairmode)
+			wrmsr(ATAC_CH0D0_PIO + 2 * pair->devno,
+				pio_cmd_timings[cmdmode] << 16 |
+				pio_timings[pairmode], 0);
+	}
+	/* Write the drive timing register */
+	wrmsr(ATAC_CH0D0_PIO + 2 * adev->devno,
+		pio_cmd_timings[cmdmode] << 16 | pio_timings[mode], 0);
+
+	/* Set the PIO "format 1" bit in the DMA timing register */
+	rdmsr(ATAC_CH0D0_DMA + 2 * adev->devno, reg, dummy);
+	wrmsr(ATAC_CH0D0_DMA + 2 * adev->devno, reg | 0x80000000UL, 0);
+}
+
+/**
+ *	cs5535_set_dmamode		-	DMA timing setup
+ *	@ap: ATA interface
+ *	@adev: Device being configured
+ *
+ */
+
+static void cs5535_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	static const u32 udma_timings[5] = {
+		0x7F7436A1, 0x7F733481, 0x7F723261, 0x7F713161, 0x7F703061
+	};
+	static const u32 mwdma_timings[3] = {
+		0x7F0FFFF3, 0x7F035352, 0x7F024241
+	};
+	u32 reg, dummy;
+	int mode = adev->dma_mode;
+
+	rdmsr(ATAC_CH0D0_DMA + 2 * adev->devno, reg, dummy);
+	reg &= 0x80000000UL;
+	if (mode >= XFER_UDMA_0)
+		reg |= udma_timings[mode - XFER_UDMA_0];
+	else
+		reg |= mwdma_timings[mode - XFER_MW_DMA_0];
+	wrmsr(ATAC_CH0D0_DMA + 2 * adev->devno, reg, 0);
+}
