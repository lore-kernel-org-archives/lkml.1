Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952Ab0A2QKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab0A2QKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931Ab0A2QKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:10:07 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570Ab0A2QKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:10:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=MbbjiDKvlp7wuksEl2/p3PLBWi7GV4INB5IYlAAntW1kSiXHqhBZhx1yYKDbj5qjyK
         DF8LdZ1y8k7EPcQSE5FJRigecZMIQzU9ePktkWcls5TIORSGf3Ba1rO6En24JqQURG7s
         x6iVim3XeuKF2A5p3bc+yZD8SpcDahsozdXzw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:09:53 +0100
Message-Id: <20100129160953.21495.21479.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 63/68] sl82c105: convert to ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] sl82c105: convert to ide2libata

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_sl82c105.h |    4 +
 drivers/ide/sl82c105.c      |  103 +++-----------------------------------------
 2 files changed, 12 insertions(+), 95 deletions(-)

Index: b/drivers/ata/pata_sl82c105.h
===================================================================
--- a/drivers/ata/pata_sl82c105.h
+++ b/drivers/ata/pata_sl82c105.h
@@ -27,13 +27,17 @@ static void sl82c105_configure_dmamode(s
 	static u16 dma_timing[3] = {
 		0x707, 0x201, 0x200
 	};
+#ifndef __IDE2LIBATA
 	u16 dummy;
+#endif
 	int timing = 0x44 + (8 * ap->port_no) + (4 * adev->devno);
 	int dma = adev->dma_mode - XFER_MW_DMA_0;
 
 	pci_write_config_word(pdev, timing, dma_timing[dma]);
+#ifndef __IDE2LIBATA
 	/* Can we lose this oddity of the old driver */
 	pci_read_config_word(pdev, timing, &dummy);
+#endif
 }
 
 /**
Index: b/drivers/ide/sl82c105.c
===================================================================
--- a/drivers/ide/sl82c105.c
+++ b/drivers/ide/sl82c105.c
@@ -24,16 +24,8 @@
 
 #define DRV_NAME "sl82c105"
 
-/*
- * SL82C105 PCI config register 0x40 bits.
- */
-#define CTRL_IDE_IRQB   (1 << 30)
-#define CTRL_IDE_IRQA   (1 << 28)
-#define CTRL_LEGIRQ     (1 << 11)
-#define CTRL_P1F16      (1 << 5)
-#define CTRL_P1EN       (1 << 4)
-#define CTRL_P0F16      (1 << 1)
-#define CTRL_P0EN       (1 << 0)
+#include <linux/ide2libata.h>
+#include "../ata/pata_sl82c105.h"
 
 /*
  * Convert a PIO mode and cycle time to the required on/off times
@@ -89,25 +81,8 @@ static void sl82c105_set_pio_mode(ide_hw
 			  ide_pio_cycle_time(drive, pio), drv_ctrl);
 }
 
-/*
- * Configure the chipset for DMA mode.
- */
 static void sl82c105_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	static u16 mwdma_timings[] = {0x0707, 0x0201, 0x0200};
-	unsigned long timings = (unsigned long)ide_get_drivedata(drive);
-	u16 drv_ctrl;
-	const u8 speed = drive->dma_mode;
-
-	drv_ctrl = mwdma_timings[speed - XFER_MW_DMA_0];
-
-	/*
-	 * Store the DMA timings so that we can actually program
-	 * them when DMA will be turned on...
-	 */
-	timings &= 0x0000ffff;
-	timings |= (unsigned long)drv_ctrl << 16;
-	ide_set_drivedata(drive, (void *)timings);
 }
 
 static int sl82c105_test_irq(ide_hwif_t *hwif)
@@ -121,23 +96,6 @@ static int sl82c105_test_irq(ide_hwif_t
 }
 
 /*
- * The SL82C105 holds off all IDE interrupts while in DMA mode until
- * all DMA activity is completed.  Sometimes this causes problems (eg,
- * when the drive wants to report an error condition).
- *
- * 0x7e is a "chip testing" register.  Bit 2 resets the DMA controller
- * state machine.  We need to kick this to work around various bugs.
- */
-static inline void sl82c105_reset_host(struct pci_dev *dev)
-{
-	u16 val;
-
-	pci_read_config_word(dev, 0x7e, &val);
-	pci_write_config_word(dev, 0x7e, val | (1 << 2));
-	pci_write_config_word(dev, 0x7e, val & ~(1 << 2));
-}
-
-/*
  * If we get an IRQ timeout, it might be that the DMA state machine
  * got confused.  Fix from Todd Inglett.  Details from Winbond.
  *
@@ -171,7 +129,7 @@ static void sl82c105_dma_lost_irq(ide_dr
 		printk(KERN_INFO "sl82c105: DMA was enabled\n");
 	}
 
-	sl82c105_reset_host(dev);
+	sl82c105_reset_engine(hwif);
 }
 
 /*
@@ -184,22 +142,16 @@ static void sl82c105_dma_lost_irq(ide_dr
  */
 static void sl82c105_dma_start(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= drive->hwif;
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	int reg 		= 0x44 + drive->dn * 4;
-
-	pci_write_config_word(dev, reg,
-			      (unsigned long)ide_get_drivedata(drive) >> 16);
+	ide_hwif_t *hwif = drive->hwif;
 
-	sl82c105_reset_host(dev);
+	sl82c105_configure_dmamode(hwif, drive);
+	sl82c105_reset_engine(hwif);
 	ide_dma_start(drive);
 }
 
 static void sl82c105_dma_clear(ide_drive_t *drive)
 {
-	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
-
-	sl82c105_reset_host(dev);
+	sl82c105_reset_engine(drive->hwif);
 }
 
 static int sl82c105_dma_end(ide_drive_t *drive)
@@ -229,39 +181,6 @@ static void sl82c105_resetproc(ide_drive
 }
 
 /*
- * Return the revision of the Winbond bridge
- * which this function is part of.
- */
-static u8 sl82c105_bridge_revision(struct pci_dev *dev)
-{
-	struct pci_dev *bridge;
-
-	/*
-	 * The bridge should be part of the same device, but function 0.
-	 */
-	bridge = pci_get_bus_and_slot(dev->bus->number,
-			       PCI_DEVFN(PCI_SLOT(dev->devfn), 0));
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
-
-	return bridge->revision;
-}
-
-/*
  * Enable the PCI device
  * 
  * --BenH: It's arch fixup code that should enable channels that
@@ -271,13 +190,7 @@ static u8 sl82c105_bridge_revision(struc
  */
 static int init_chipset_sl82c105(struct pci_dev *dev)
 {
-	u32 val;
-
-	pci_read_config_dword(dev, 0x40, &val);
-	val |= CTRL_P0EN | CTRL_P0F16 | CTRL_P1F16;
-	pci_write_config_dword(dev, 0x40, val);
-
-	return 0;
+	return sl82c105_fixup(&dev->dev);
 }
 
 static const struct ide_port_ops sl82c105_port_ops = {
