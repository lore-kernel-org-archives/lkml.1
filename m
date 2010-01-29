Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653Ab0A2QHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab0A2QHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019Ab0A2QHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:07:43 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab0A2QHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:07:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Gx9446YEyQ6o49b3QDg6l8QZp4MoJLPI72xvaWMYdk/1gbg4GM15K6iTQFR69zkuxi
         B2KU3wfQyp3zFzpXu9m/AYlSOL/DFNmIlL7EbinSIaJIOWAU3/NtLcbdfdlBN9Q6jfbo
         I+NmUDi2AXaudYlfv75gEZAXlr7IRJOb3B8dE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:07:31 +0100
Message-Id: <20100129160731.21495.95618.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 41/68] pata_cmd64x: convert to ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cmd64x: convert to ide2libata

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cmd64x.h |   35 +++++++-
 drivers/ide/cmd64x.c      |  195 +---------------------------------------------
 2 files changed, 41 insertions(+), 189 deletions(-)

Index: b/drivers/ata/pata_cmd64x.h
===================================================================
--- a/drivers/ata/pata_cmd64x.h
+++ b/drivers/ata/pata_cmd64x.h
@@ -56,7 +56,12 @@ static void cmd64x_set_timing(struct ata
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	struct ata_timing t;
+#ifndef __IDE2LIBATA
 	const unsigned long T = 1000000 / 33;
+#else
+	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
+	const unsigned long T = 1000000 / bus_speed;
+#endif
 	const u8 setup_data[] = { 0x40, 0x40, 0x40, 0x80, 0x00 };
 
 	u8 reg;
@@ -124,6 +129,11 @@ static void cmd64x_set_timing(struct ata
 
 	/* Load setup timing */
 	pci_read_config_byte(pdev, arttim, &reg);
+#ifdef __IDE2LIBATA
+	/* Avoid clearing the secondary channel's interrupt bit. */
+	if (ap->port_no)
+		reg &= ~ARTTIM23_INTR_CH1;
+#endif
 	reg &= 0x3F;
 	reg |= t.setup;
 	pci_write_config_byte(pdev, arttim, reg);
@@ -143,6 +153,13 @@ static void cmd64x_set_timing(struct ata
 
 static void cmd64x_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
+#ifdef __IDE2LIBATA
+	const u8 pio = adev->pio_mode - XFER_PIO_0;
+
+	/* Filter out the prefetch control values. */
+	if (pio == 8 || pio == 9)
+		return;
+#endif
 	cmd64x_set_timing(ap, adev, adev->pio_mode);
 }
 
@@ -161,13 +178,17 @@ static void cmd64x_set_dmamode(struct at
 	};
 
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 regU, regD;
+	u8 regU, regD = 0;
 
 	int pciU = UDIDETCR0 + 8 * ap->port_no;
+#ifndef __IDE2LIBATA
 	int pciD = BMIDESR0 + 8 * ap->port_no;
+#endif
 	int shift = 2 * adev->devno;
 
+#ifndef __IDE2LIBATA
 	pci_read_config_byte(pdev, pciD, &regD);
+#endif
 	pci_read_config_byte(pdev, pciU, &regU);
 
 	/* DMA bits off */
@@ -192,7 +213,9 @@ static void cmd64x_set_dmamode(struct at
 	regD |= 0x20 << adev->devno;
 
 	pci_write_config_byte(pdev, pciU, regU);
+#ifndef __IDE2LIBATA
 	pci_write_config_byte(pdev, pciD, regD);
+#endif
 }
 
 static int cmd64x_fixup(struct device *dev)
@@ -201,15 +224,23 @@ static int cmd64x_fixup(struct device *d
 	u8 mrdmode;
 
 	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
+	/* FIXME: pci_set_master() to ensure a good latency timer value */
+
+	/*
+	 * NOTE: although not mentioned in the PCI0646U specs,
+	 * bits 0-1 are write only and won't be read back as
+	 * set or not -- PCI0646U2 specs clarify this point.
+	 */
 	pci_read_config_byte(pdev, MRDMODE, &mrdmode);
 	mrdmode &= ~0x30;	/* IRQ set up */
 	mrdmode |= 0x02;	/* Memory read line enable */
 	pci_write_config_byte(pdev, MRDMODE, mrdmode);
 
+#ifndef __IDE2LIBATA
 	/* PPC specific fixup copied from old driver */
 #ifdef CONFIG_PPC
 	pci_write_config_byte(pdev, UDIDETCR0, 0xF0);
 #endif
-
+#endif
 	return 0;
 }
Index: b/drivers/ide/cmd64x.c
===================================================================
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -20,168 +20,8 @@
 
 #define DRV_NAME "cmd64x"
 
-/*
- * CMD64x specific registers definition.
- */
-#define CFR		0x50
-#define   CFR_INTR_CH0		0x04
-
-#define	CMDTIM		0x52
-#define	ARTTIM0		0x53
-#define	DRWTIM0		0x54
-#define ARTTIM1 	0x55
-#define DRWTIM1		0x56
-#define ARTTIM23	0x57
-#define   ARTTIM23_DIS_RA2	0x04
-#define   ARTTIM23_DIS_RA3	0x08
-#define   ARTTIM23_INTR_CH1	0x10
-#define DRWTIM2		0x58
-#define BRST		0x59
-#define DRWTIM3		0x5b
-
-#define BMIDECR0	0x70
-#define MRDMODE		0x71
-#define   MRDMODE_INTR_CH0	0x04
-#define   MRDMODE_INTR_CH1	0x08
-#define UDIDETCR0	0x73
-#define DTPR0		0x74
-#define BMIDECR1	0x78
-#define BMIDECSR	0x79
-#define UDIDETCR1	0x7B
-#define DTPR1		0x7C
-
-static void cmd64x_program_timings(ide_drive_t *drive, u8 mode)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
-	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
-	const unsigned long T = 1000000 / bus_speed;
-	static const u8 recovery_values[] =
-		{15, 15, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 0};
-	static const u8 setup_values[] = {0x40, 0x40, 0x40, 0x80, 0, 0xc0};
-	static const u8 arttim_regs[4] = {ARTTIM0, ARTTIM1, ARTTIM23, ARTTIM23};
-	static const u8 drwtim_regs[4] = {DRWTIM0, DRWTIM1, DRWTIM2, DRWTIM3};
-	struct ata_timing t;
-	u8 arttim = 0;
-
-	ata_timing_compute(drive->id, mode, drive->pio_mode, &t, T, 0);
-
-	/*
-	 * In case we've got too long recovery phase, try to lengthen
-	 * the active phase
-	 */
-	if (t.recover > 16) {
-		t.active += t.recover - 16;
-		t.recover = 16;
-	}
-	if (t.active > 16)		/* shouldn't actually happen... */
-		t.active = 16;
-
-	/*
-	 * Convert values to internal chipset representation
-	 */
-	t.recover = recovery_values[t.recover];
-	t.active &= 0x0f;
-
-	/* Program the active/recovery counts into the DRWTIM register */
-	pci_write_config_byte(dev, drwtim_regs[drive->dn],
-			      (t.active << 4) | t.recover);
-
-	/*
-	 * The primary channel has individual address setup timing registers
-	 * for each drive and the hardware selects the slowest timing itself.
-	 * The secondary channel has one common register and we have to select
-	 * the slowest address setup timing ourselves.
-	 */
-	if (hwif->channel) {
-		ide_drive_t *pair = ide_get_pair_dev(drive);
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
-	if (t.setup > 5)		/* shouldn't actually happen... */
-		t.setup = 5;
-
-	/*
-	 * Program the address setup clocks into the ARTTIM registers.
-	 * Avoid clearing the secondary channel's interrupt bit.
-	 */
-	(void) pci_read_config_byte (dev, arttim_regs[drive->dn], &arttim);
-	if (hwif->channel)
-		arttim &= ~ARTTIM23_INTR_CH1;
-	arttim &= ~0xc0;
-	arttim |= setup_values[t.setup];
-	(void) pci_write_config_byte(dev, arttim_regs[drive->dn], arttim);
-}
-
-/*
- * Attempts to set drive's PIO mode.
- * Special cases are 8: prefetch off, 9: prefetch on (both never worked)
- */
-
-static void cmd64x_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	const u8 pio = drive->pio_mode - XFER_PIO_0;
-
-	/*
-	 * Filter out the prefetch control values
-	 * to prevent PIO5 from being programmed
-	 */
-	if (pio == 8 || pio == 9)
-		return;
-
-	cmd64x_program_timings(drive, XFER_PIO_0 + pio);
-}
-
-static void cmd64x_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	u8 unit			= drive->dn & 0x01;
-	u8 regU = 0, pciU	= hwif->channel ? UDIDETCR1 : UDIDETCR0;
-	const u8 speed		= drive->dma_mode;
-
-	pci_read_config_byte(dev, pciU, &regU);
-	regU &= ~(unit ? 0xCA : 0x35);
-
-	switch(speed) {
-	case XFER_UDMA_5:
-		regU |= unit ? 0x0A : 0x05;
-		break;
-	case XFER_UDMA_4:
-		regU |= unit ? 0x4A : 0x15;
-		break;
-	case XFER_UDMA_3:
-		regU |= unit ? 0x8A : 0x25;
-		break;
-	case XFER_UDMA_2:
-		regU |= unit ? 0x42 : 0x11;
-		break;
-	case XFER_UDMA_1:
-		regU |= unit ? 0x82 : 0x21;
-		break;
-	case XFER_UDMA_0:
-		regU |= unit ? 0xC2 : 0x31;
-		break;
-	case XFER_MW_DMA_2:
-	case XFER_MW_DMA_1:
-	case XFER_MW_DMA_0:
-		cmd64x_program_timings(drive, speed);
-		break;
-	}
-
-	pci_write_config_byte(dev, pciU, regU);
-}
+#include <linux/ide2libata.h>
+#include "../ata/pata_cmd64x.h"
 
 static void cmd648_clear_irq(ide_drive_t *drive)
 {
@@ -265,52 +105,33 @@ static int cmd646_1_dma_end(ide_drive_t
 
 static int init_chipset_cmd64x(struct pci_dev *dev)
 {
-	u8 mrdmode = 0;
-
-	/* Set a good latency timer and cache line size value. */
-	(void) pci_write_config_byte(dev, PCI_LATENCY_TIMER, 64);
-	/* FIXME: pci_set_master() to ensure a good latency timer value */
-
-	/*
-	 * Enable interrupts, select MEMORY READ LINE for reads.
-	 *
-	 * NOTE: although not mentioned in the PCI0646U specs,
-	 * bits 0-1 are write only and won't be read back as
-	 * set or not -- PCI0646U2 specs clarify this point.
-	 */
-	(void) pci_read_config_byte (dev, MRDMODE, &mrdmode);
-	mrdmode &= ~0x30;
-	(void) pci_write_config_byte(dev, MRDMODE, (mrdmode | 0x02));
-
-	return 0;
+	return cmd64x_fixup(&dev->dev);
 }
 
 static int cmd64x_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev  *dev	= to_pci_dev(hwif->dev);
-	u8 bmidecsr = 0, mask	= hwif->channel ? 0x02 : 0x01;
 
 	switch (dev->device) {
 	case PCI_DEVICE_ID_CMD_648:
 	case PCI_DEVICE_ID_CMD_649:
- 		pci_read_config_byte(dev, BMIDECSR, &bmidecsr);
-		return (bmidecsr & mask) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
+		return cmd648_cable_detect(hwif);
 	default:
 		return ATA_CBL_PATA40;
 	}
 }
 
 static const struct ide_port_ops cmd64x_port_ops = {
-	.set_pio_mode		= cmd64x_set_pio_mode,
-	.set_dma_mode		= cmd64x_set_dma_mode,
+	.set_pio_mode		= cmd64x_set_piomode,
+	.set_dma_mode		= cmd64x_set_dmamode,
 	.clear_irq		= cmd64x_clear_irq,
 	.test_irq		= cmd64x_test_irq,
 	.cable_detect		= cmd64x_cable_detect,
 };
 
 static const struct ide_port_ops cmd648_port_ops = {
-	.set_pio_mode		= cmd64x_set_pio_mode,
-	.set_dma_mode		= cmd64x_set_dma_mode,
+	.set_pio_mode		= cmd64x_set_piomode,
+	.set_dma_mode		= cmd64x_set_dmamode,
 	.clear_irq		= cmd648_clear_irq,
 	.test_irq		= cmd648_test_irq,
 	.cable_detect		= cmd64x_cable_detect,
