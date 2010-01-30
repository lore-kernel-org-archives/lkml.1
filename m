Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188Ab0A3Ttj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab0A3Ttj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 14:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907Ab0A3Tth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 14:49:37 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:50554 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab0A3Ttd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 14:49:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=FxGS24d8OmQcIg1FGggcYanbRzRZbORcWpMz5V/dQb/IH5KtpbPUBLBcy2zngjBO2N
         uGL9bSp8fjJT5wWsVsMpAwyIBxGDDE/hCyjsZxguqcm0vMuwNpBva2ZKCthf4DKgzeEC
         OPlUlk64//gmA+U3j85A/ehYThTdk6j9X6I+w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 30 Jan 2010 20:49:25 +0100
Message-Id: <20100130194925.30779.34207.sendpatchset@localhost>
In-Reply-To: <20100130194918.30779.25485.sendpatchset@localhost>
References: <20100130194918.30779.25485.sendpatchset@localhost>
Subject: [PATCH 1/9] pata_cs5536: forward port changes from cs5536
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cs5536: forward port changes from cs5536

* Fix cable detection to also account for the slave device cable bit.

* Disable UDMA when programming MWDMA in cs5536_set_dmamode().

* Don't change UDMA settings in cs5536_set_piomode().

* Add cs5536_program_dtc() helper.

* Cleanup and uninline cs5536_[read,write]() methods.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cs5536.c |   99 +++++++++++++++++++---------------------------
 1 file changed, 42 insertions(+), 57 deletions(-)

Index: b/drivers/ata/pata_cs5536.c
===================================================================
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -1,6 +1,7 @@
 /*
  * pata_cs5536.c	- CS5536 PATA for new ATA layer
  *			  (C) 2007 Martin K. Petersen <mkp@mkp.net>
+ *			  (C) 2010 Bartlomiej Zolnierkiewicz
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -43,24 +44,16 @@
 #define DRV_VERSION	"0.0.7"
 
 enum {
-	CFG			= 0,
-	DTC			= 1,
-	CAST			= 2,
-	ETC			= 3,
-
-	MSR_IDE_BASE		= 0x51300000,
-	MSR_IDE_CFG		= (MSR_IDE_BASE + 0x10),
-	MSR_IDE_DTC		= (MSR_IDE_BASE + 0x12),
-	MSR_IDE_CAST		= (MSR_IDE_BASE + 0x13),
-	MSR_IDE_ETC		= (MSR_IDE_BASE + 0x14),
-
+	MSR_IDE_CFG		= 0x51300010,
 	PCI_IDE_CFG		= 0x40,
-	PCI_IDE_DTC		= 0x48,
-	PCI_IDE_CAST		= 0x4c,
-	PCI_IDE_ETC		= 0x50,
 
-	IDE_CFG_CHANEN		= 0x2,
-	IDE_CFG_CABLE		= 0x10000,
+	CFG			= 0,
+	DTC			= 2,
+	CAST			= 3,
+	ETC			= 4,
+
+	IDE_CFG_CHANEN		= (1 << 1),
+	IDE_CFG_CABLE		= (1 << 17) | (1 << 16),
 
 	IDE_D0_SHIFT		= 24,
 	IDE_D1_SHIFT		= 16,
@@ -72,47 +65,52 @@ enum {
 	IDE_CAST_CMD_MASK	= 0xff,
 	IDE_CAST_CMD_SHIFT	= 24,
 
-	IDE_ETC_NODMA		= 0x03,
+	IDE_ETC_UDMA_MASK	= 0xc0,
 };
 
 static int use_msr;
 
-static const u32 msr_reg[4] = {
-	MSR_IDE_CFG, MSR_IDE_DTC, MSR_IDE_CAST, MSR_IDE_ETC,
-};
-
-static const u8 pci_reg[4] = {
-	PCI_IDE_CFG, PCI_IDE_DTC, PCI_IDE_CAST, PCI_IDE_ETC,
-};
-
-static inline int cs5536_read(struct pci_dev *pdev, int reg, u32 *val)
+static int cs5536_read(struct pci_dev *pdev, int reg, u32 *val)
 {
 	if (unlikely(use_msr)) {
 		u32 dummy;
 
-		rdmsr(msr_reg[reg], *val, dummy);
+		rdmsr(MSR_IDE_CFG + reg, *val, dummy);
 		return 0;
 	}
 
-	return pci_read_config_dword(pdev, pci_reg[reg], val);
+	return pci_read_config_dword(pdev, PCI_IDE_CFG + reg * 4, val);
 }
 
-static inline int cs5536_write(struct pci_dev *pdev, int reg, int val)
+static int cs5536_write(struct pci_dev *pdev, int reg, int val)
 {
 	if (unlikely(use_msr)) {
-		wrmsr(msr_reg[reg], val, 0);
+		wrmsr(MSR_IDE_CFG + reg, val, 0);
 		return 0;
 	}
 
-	return pci_write_config_dword(pdev, pci_reg[reg], val);
+	return pci_write_config_dword(pdev, PCI_IDE_CFG + reg * 4, val);
+}
+
+static void cs5536_program_dtc(struct ata_device *adev, u8 tim)
+{
+	struct pci_dev *pdev = to_pci_dev(adev->link->ap->host->dev);
+	int dshift = adev->devno ? IDE_D1_SHIFT : IDE_D0_SHIFT;
+	u32 dtc;
+
+	cs5536_read(pdev, DTC, &dtc);
+	dtc &= ~(IDE_DRV_MASK << dshift);
+	dtc |= tim << dshift;
+	cs5536_write(pdev, DTC, dtc);
 }
 
 /**
  *	cs5536_cable_detect	-	detect cable type
  *	@ap: Port to detect on
  *
- *	Perform cable detection for ATA66 capable cable. Return a libata
- *	cable type.
+ *	Perform cable detection for ATA66 capable cable.
+ *
+ *	Returns a cable type.
  */
 
 static int cs5536_cable_detect(struct ata_port *ap)
@@ -122,7 +120,7 @@ static int cs5536_cable_detect(struct at
 
 	cs5536_read(pdev, CFG, &cfg);
 
-	if (cfg & (IDE_CFG_CABLE << ap->port_no))
+	if (cfg & IDE_CFG_CABLE)
 		return ATA_CBL_PATA80;
 	else
 		return ATA_CBL_PATA40;
@@ -152,19 +150,15 @@ static void cs5536_set_piomode(struct at
 	struct ata_device *pair = ata_dev_pair(adev);
 	int mode = adev->pio_mode - XFER_PIO_0;
 	int cmdmode = mode;
-	int dshift = adev->devno ? IDE_D1_SHIFT : IDE_D0_SHIFT;
 	int cshift = adev->devno ? IDE_CAST_D1_SHIFT : IDE_CAST_D0_SHIFT;
-	u32 dtc, cast, etc;
+	u32 cast;
 
 	if (pair)
 		cmdmode = min(mode, pair->pio_mode - XFER_PIO_0);
 
-	cs5536_read(pdev, DTC, &dtc);
-	cs5536_read(pdev, CAST, &cast);
-	cs5536_read(pdev, ETC, &etc);
+	cs5536_program_dtc(adev, drv_timings[mode]);
 
-	dtc &= ~(IDE_DRV_MASK << dshift);
-	dtc |= drv_timings[mode] << dshift;
+	cs5536_read(pdev, CAST, &cast);
 
 	cast &= ~(IDE_CAST_DRV_MASK << cshift);
 	cast |= addr_timings[mode] << cshift;
@@ -172,12 +166,7 @@ static void cs5536_set_piomode(struct at
 	cast &= ~(IDE_CAST_CMD_MASK << IDE_CAST_CMD_SHIFT);
 	cast |= cmd_timings[cmdmode] << IDE_CAST_CMD_SHIFT;
 
-	etc &= ~(IDE_DRV_MASK << dshift);
-	etc |= IDE_ETC_NODMA << dshift;
-
-	cs5536_write(pdev, DTC, dtc);
 	cs5536_write(pdev, CAST, cast);
-	cs5536_write(pdev, ETC, etc);
 }
 
 /**
@@ -198,25 +187,21 @@ static void cs5536_set_dmamode(struct at
 	};
 
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u32 dtc, etc;
+	u32 etc;
 	int mode = adev->dma_mode;
 	int dshift = adev->devno ? IDE_D1_SHIFT : IDE_D0_SHIFT;
 
-	if (mode >= XFER_UDMA_0) {
-		cs5536_read(pdev, ETC, &etc);
+	cs5536_read(pdev, ETC, &etc);
 
+	if (mode >= XFER_UDMA_0) {
 		etc &= ~(IDE_DRV_MASK << dshift);
 		etc |= udma_timings[mode - XFER_UDMA_0] << dshift;
-
-		cs5536_write(pdev, ETC, etc);
 	} else { /* MWDMA */
-		cs5536_read(pdev, DTC, &dtc);
-
-		dtc &= ~(IDE_DRV_MASK << dshift);
-		dtc |= mwdma_timings[mode - XFER_MW_DMA_0] << dshift;
-
-		cs5536_write(pdev, DTC, dtc);
+		etc &= ~(IDE_ETC_UDMA_MASK << dshift);
+		cs5536_program_dtc(adev, mwdma_timings[mode - XFER_MW_DMA_0]);
 	}
+
+	cs5536_write(pdev, ETC, etc);
 }
 
 static struct scsi_host_template cs5536_sht = {
