Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256Ab0A2QPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab0A2QPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940Ab0A2QPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:15:33 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab0A2QHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:07:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=dkJR6ERLre+FbOBhIWGKiaIbB4sjs2QCkusfj5j83d5h/vBIdN5b0KmhAaNt8dB9a1
         HmKJ0iCFV2tnoAxVgcy4Z8eOnmp1/ED8an3p633QSEi9g1TKzY2LWLwpcUbqBmNgECx7
         Ypys/8QDXOLNJo+QPQGwPwjnDor62W1ymK+IA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:07:24 +0100
Message-Id: <20100129160724.21495.94049.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 40/68] pata_cmd64x: move code to be re-used by ide2libata to pata_cmd64x.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cmd64x: move code to be re-used by ide2libata to pata_cmd64x.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cmd64x.c |  215 ----------------------------------------------
 drivers/ata/pata_cmd64x.h |  215 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 216 insertions(+), 214 deletions(-)

Index: b/drivers/ata/pata_cmd64x.c
===================================================================
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -34,49 +34,7 @@
 #define DRV_NAME "pata_cmd64x"
 #define DRV_VERSION "0.2.5"
 
-/*
- * CMD64x specific registers definition.
- */
-
-enum {
-	CFR 		= 0x50,
-		CFR_INTR_CH0  = 0x04,
-	CMDTIM 		= 0x52,
-	ARTTIM0 	= 0x53,
-	DRWTIM0 	= 0x54,
-	ARTTIM1 	= 0x55,
-	DRWTIM1 	= 0x56,
-	ARTTIM23 	= 0x57,
-		ARTTIM23_DIS_RA2  = 0x04,
-		ARTTIM23_DIS_RA3  = 0x08,
-		ARTTIM23_INTR_CH1 = 0x10,
-	DRWTIM2 	= 0x58,
-	BRST 		= 0x59,
-	DRWTIM3 	= 0x5b,
-	BMIDECR0	= 0x70,
-	MRDMODE		= 0x71,
-		MRDMODE_INTR_CH0 = 0x04,
-		MRDMODE_INTR_CH1 = 0x08,
-	BMIDESR0	= 0x72,
-	UDIDETCR0	= 0x73,
-	DTPR0		= 0x74,
-	BMIDECR1	= 0x78,
-	BMIDECSR	= 0x79,
-	UDIDETCR1	= 0x7B,
-	DTPR1		= 0x7C
-};
-
-static int cmd648_cable_detect(struct ata_port *ap)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 r;
-
-	/* Check cable detect bits */
-	pci_read_config_byte(pdev, BMIDECSR, &r);
-	if (r & (1 << ap->port_no))
-		return ATA_CBL_PATA80;
-	return ATA_CBL_PATA40;
-}
+#include "pata_cmd64x.h"
 
 /**
  *	cmd64x_prereset	-	perform reset handling
@@ -113,158 +71,6 @@ out:
 }
 
 /**
- *	cmd64x_set_timing	-	set PIO and MWDMA timing
- *	@ap: ATA interface
- *	@adev: ATA device
- *	@mode: mode
- *
- *	Called to do the PIO and MWDMA mode setup.
- */
-
-static void cmd64x_set_timing(struct ata_port *ap, struct ata_device *adev, u8 mode)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	struct ata_timing t;
-	const unsigned long T = 1000000 / 33;
-	const u8 setup_data[] = { 0x40, 0x40, 0x40, 0x80, 0x00 };
-
-	u8 reg;
-
-	/* Port layout is not logical so use a table */
-	const u8 arttim_port[2][2] = {
-		{ ARTTIM0, ARTTIM1 },
-		{ ARTTIM23, ARTTIM23 }
-	};
-	const u8 drwtim_port[2][2] = {
-		{ DRWTIM0, DRWTIM1 },
-		{ DRWTIM2, DRWTIM3 }
-	};
-
-	int arttim = arttim_port[ap->port_no][adev->devno];
-	int drwtim = drwtim_port[ap->port_no][adev->devno];
-
-	/* ata_timing_compute is smart and will produce timings for MWDMA
-	   that don't violate the drives PIO capabilities. */
-	ata_timing_compute(adev->id, mode, adev->pio_mode, &t, T, 0);
-
-	if (ap->port_no) {
-		/* Slave has shared address setup */
-		struct ata_device *pair = ata_dev_pair(adev);
-
-		if (pair) {
-			struct ata_timing tp;
-
-			ata_timing_compute(pair->id, pair->pio_mode,
-					pair->pio_mode, &tp, T, 0);
-			ata_timing_merge(&t, &tp, &t, ATA_TIMING_SETUP);
-			if (pair->dma_mode) {
-				ata_timing_compute(pair->id, pair->dma_mode,
-						pair->pio_mode, &tp, T, 0);
-				ata_timing_merge(&tp, &t, &t, ATA_TIMING_SETUP);
-			}
-		}
-	}
-
-	printk(KERN_DEBUG DRV_NAME ": active %d recovery %d setup %d.\n",
-		t.active, t.recover, t.setup);
-	if (t.recover > 16) {
-		t.active += t.recover - 16;
-		t.recover = 16;
-	}
-	if (t.active > 16)
-		t.active = 16;
-
-	/* Now convert the clocks into values we can actually stuff into
-	   the chip */
-
-	if (t.recover == 16)
-		t.recover = 0;
-	else if (t.recover > 1)
-		t.recover--;
-	else
-		t.recover = 15;
-
-	if (t.setup > 4)
-		t.setup = 0xC0;
-	else
-		t.setup = setup_data[t.setup];
-
-	t.active &= 0x0F;	/* 0 = 16 */
-
-	/* Load setup timing */
-	pci_read_config_byte(pdev, arttim, &reg);
-	reg &= 0x3F;
-	reg |= t.setup;
-	pci_write_config_byte(pdev, arttim, reg);
-
-	/* Load active/recovery */
-	pci_write_config_byte(pdev, drwtim, (t.active << 4) | t.recover);
-}
-
-/**
- *	cmd64x_set_piomode	-	set initial PIO mode data
- *	@ap: ATA interface
- *	@adev: ATA device
- *
- *	Used when configuring the devices ot set the PIO timings. All the
- *	actual work is done by the PIO/MWDMA setting helper
- */
-
-static void cmd64x_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	cmd64x_set_timing(ap, adev, adev->pio_mode);
-}
-
-/**
- *	cmd64x_set_dmamode	-	set initial DMA mode data
- *	@ap: ATA interface
- *	@adev: ATA device
- *
- *	Called to do the DMA mode setup.
- */
-
-static void cmd64x_set_dmamode(struct ata_port *ap, struct ata_device *adev)
-{
-	static const u8 udma_data[] = {
-		0x30, 0x20, 0x10, 0x20, 0x10, 0x00
-	};
-
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 regU, regD;
-
-	int pciU = UDIDETCR0 + 8 * ap->port_no;
-	int pciD = BMIDESR0 + 8 * ap->port_no;
-	int shift = 2 * adev->devno;
-
-	pci_read_config_byte(pdev, pciD, &regD);
-	pci_read_config_byte(pdev, pciU, &regU);
-
-	/* DMA bits off */
-	regD &= ~(0x20 << adev->devno);
-	/* DMA control bits */
-	regU &= ~(0x30 << shift);
-	/* DMA timing bits */
-	regU &= ~(0x05 << adev->devno);
-
-	if (adev->dma_mode >= XFER_UDMA_0) {
-		/* Merge the timing value */
-		regU |= udma_data[adev->dma_mode - XFER_UDMA_0] << shift;
-		/* Merge the control bits */
-		regU |= 1 << adev->devno; /* UDMA on */
-		if (adev->dma_mode > XFER_UDMA_2) /* 15nS timing */
-			regU |= 4 << adev->devno;
-	} else {
-		regU &= ~ (1 << adev->devno);	/* UDMA off */
-		cmd64x_set_timing(ap, adev, adev->dma_mode);
-	}
-
-	regD |= 0x20 << adev->devno;
-
-	pci_write_config_byte(pdev, pciU, regU);
-	pci_write_config_byte(pdev, pciD, regD);
-}
-
-/**
  *	cmd648_dma_stop	-	DMA stop callback
  *	@qc: Command in progress
  *
@@ -325,25 +131,6 @@ static struct ata_port_operations cmd648
 	.cable_detect	= cmd648_cable_detect,
 };
 
-static int cmd64x_fixup(struct device *dev)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	u8 mrdmode;
-
-	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
-	pci_read_config_byte(pdev, MRDMODE, &mrdmode);
-	mrdmode &= ~0x30;	/* IRQ set up */
-	mrdmode |= 0x02;	/* Memory read line enable */
-	pci_write_config_byte(pdev, MRDMODE, mrdmode);
-
-	/* PPC specific fixup copied from old driver */
-#ifdef CONFIG_PPC
-	pci_write_config_byte(pdev, UDIDETCR0, 0xF0);
-#endif
-
-	return 0;
-}
-
 static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info cmd_info[6] = {
Index: b/drivers/ata/pata_cmd64x.h
===================================================================
--- /dev/null
+++ b/drivers/ata/pata_cmd64x.h
@@ -0,0 +1,215 @@
+
+/*
+ * CMD64x specific registers definition.
+ */
+
+enum {
+	CFR 		= 0x50,
+		CFR_INTR_CH0  = 0x04,
+	CMDTIM 		= 0x52,
+	ARTTIM0 	= 0x53,
+	DRWTIM0 	= 0x54,
+	ARTTIM1 	= 0x55,
+	DRWTIM1 	= 0x56,
+	ARTTIM23 	= 0x57,
+		ARTTIM23_DIS_RA2  = 0x04,
+		ARTTIM23_DIS_RA3  = 0x08,
+		ARTTIM23_INTR_CH1 = 0x10,
+	DRWTIM2 	= 0x58,
+	BRST 		= 0x59,
+	DRWTIM3 	= 0x5b,
+	BMIDECR0	= 0x70,
+	MRDMODE		= 0x71,
+		MRDMODE_INTR_CH0 = 0x04,
+		MRDMODE_INTR_CH1 = 0x08,
+	BMIDESR0	= 0x72,
+	UDIDETCR0	= 0x73,
+	DTPR0		= 0x74,
+	BMIDECR1	= 0x78,
+	BMIDECSR	= 0x79,
+	UDIDETCR1	= 0x7B,
+	DTPR1		= 0x7C
+};
+
+static int cmd648_cable_detect(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u8 r;
+
+	/* Check cable detect bits */
+	pci_read_config_byte(pdev, BMIDECSR, &r);
+	if (r & (1 << ap->port_no))
+		return ATA_CBL_PATA80;
+	return ATA_CBL_PATA40;
+}
+
+/**
+ *	cmd64x_set_timing	-	set PIO and MWDMA timing
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *	@mode: mode
+ *
+ *	Called to do the PIO and MWDMA mode setup.
+ */
+
+static void cmd64x_set_timing(struct ata_port *ap, struct ata_device *adev, u8 mode)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	struct ata_timing t;
+	const unsigned long T = 1000000 / 33;
+	const u8 setup_data[] = { 0x40, 0x40, 0x40, 0x80, 0x00 };
+
+	u8 reg;
+
+	/* Port layout is not logical so use a table */
+	const u8 arttim_port[2][2] = {
+		{ ARTTIM0, ARTTIM1 },
+		{ ARTTIM23, ARTTIM23 }
+	};
+	const u8 drwtim_port[2][2] = {
+		{ DRWTIM0, DRWTIM1 },
+		{ DRWTIM2, DRWTIM3 }
+	};
+
+	int arttim = arttim_port[ap->port_no][adev->devno];
+	int drwtim = drwtim_port[ap->port_no][adev->devno];
+
+	/* ata_timing_compute is smart and will produce timings for MWDMA
+	   that don't violate the drives PIO capabilities. */
+	ata_timing_compute(adev->id, mode, adev->pio_mode, &t, T, 0);
+
+	if (ap->port_no) {
+		/* Slave has shared address setup */
+		struct ata_device *pair = ata_dev_pair(adev);
+
+		if (pair) {
+			struct ata_timing tp;
+
+			ata_timing_compute(pair->id, pair->pio_mode,
+					pair->pio_mode, &tp, T, 0);
+			ata_timing_merge(&t, &tp, &t, ATA_TIMING_SETUP);
+			if (pair->dma_mode) {
+				ata_timing_compute(pair->id, pair->dma_mode,
+						pair->pio_mode, &tp, T, 0);
+				ata_timing_merge(&tp, &t, &t, ATA_TIMING_SETUP);
+			}
+		}
+	}
+
+	printk(KERN_DEBUG DRV_NAME ": active %d recovery %d setup %d.\n",
+		t.active, t.recover, t.setup);
+	if (t.recover > 16) {
+		t.active += t.recover - 16;
+		t.recover = 16;
+	}
+	if (t.active > 16)
+		t.active = 16;
+
+	/* Now convert the clocks into values we can actually stuff into
+	   the chip */
+
+	if (t.recover == 16)
+		t.recover = 0;
+	else if (t.recover > 1)
+		t.recover--;
+	else
+		t.recover = 15;
+
+	if (t.setup > 4)
+		t.setup = 0xC0;
+	else
+		t.setup = setup_data[t.setup];
+
+	t.active &= 0x0F;	/* 0 = 16 */
+
+	/* Load setup timing */
+	pci_read_config_byte(pdev, arttim, &reg);
+	reg &= 0x3F;
+	reg |= t.setup;
+	pci_write_config_byte(pdev, arttim, reg);
+
+	/* Load active/recovery */
+	pci_write_config_byte(pdev, drwtim, (t.active << 4) | t.recover);
+}
+
+/**
+ *	cmd64x_set_piomode	-	set initial PIO mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Used when configuring the devices ot set the PIO timings. All the
+ *	actual work is done by the PIO/MWDMA setting helper
+ */
+
+static void cmd64x_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	cmd64x_set_timing(ap, adev, adev->pio_mode);
+}
+
+/**
+ *	cmd64x_set_dmamode	-	set initial DMA mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Called to do the DMA mode setup.
+ */
+
+static void cmd64x_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	static const u8 udma_data[] = {
+		0x30, 0x20, 0x10, 0x20, 0x10, 0x00
+	};
+
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u8 regU, regD;
+
+	int pciU = UDIDETCR0 + 8 * ap->port_no;
+	int pciD = BMIDESR0 + 8 * ap->port_no;
+	int shift = 2 * adev->devno;
+
+	pci_read_config_byte(pdev, pciD, &regD);
+	pci_read_config_byte(pdev, pciU, &regU);
+
+	/* DMA bits off */
+	regD &= ~(0x20 << adev->devno);
+	/* DMA control bits */
+	regU &= ~(0x30 << shift);
+	/* DMA timing bits */
+	regU &= ~(0x05 << adev->devno);
+
+	if (adev->dma_mode >= XFER_UDMA_0) {
+		/* Merge the timing value */
+		regU |= udma_data[adev->dma_mode - XFER_UDMA_0] << shift;
+		/* Merge the control bits */
+		regU |= 1 << adev->devno; /* UDMA on */
+		if (adev->dma_mode > XFER_UDMA_2) /* 15nS timing */
+			regU |= 4 << adev->devno;
+	} else {
+		regU &= ~(1 << adev->devno);	/* UDMA off */
+		cmd64x_set_timing(ap, adev, adev->dma_mode);
+	}
+
+	regD |= 0x20 << adev->devno;
+
+	pci_write_config_byte(pdev, pciU, regU);
+	pci_write_config_byte(pdev, pciD, regD);
+}
+
+static int cmd64x_fixup(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	u8 mrdmode;
+
+	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
+	pci_read_config_byte(pdev, MRDMODE, &mrdmode);
+	mrdmode &= ~0x30;	/* IRQ set up */
+	mrdmode |= 0x02;	/* Memory read line enable */
+	pci_write_config_byte(pdev, MRDMODE, mrdmode);
+
+	/* PPC specific fixup copied from old driver */
+#ifdef CONFIG_PPC
+	pci_write_config_byte(pdev, UDIDETCR0, 0xF0);
+#endif
+
+	return 0;
+}
