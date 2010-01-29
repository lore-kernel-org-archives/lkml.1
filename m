Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277Ab0A2QOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab0A2QOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:14:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755646Ab0A2QOC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:14:02 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab0A2QIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:08:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Gg6HsQT9Q6DAGpwqQu7Vz+2FfX1H4QF+yhFKXhj4vc50yIynwxKfC/WOK9mmPK1WaM
         DZCsr5E38HzdQAv2jtUVgPdmJ8UWKn/ANeg4ziAlJHhl+wSBCJVGgBTaDLcAjol8rtGh
         2qIuIni2hHm2Dg0nCVcrNWZhWF9YafAuRNrIo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:08:23 +0100
Message-Id: <20100129160823.21495.16081.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 49/68] cy82c693: convert to ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cy82c693: convert to ide2libata

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cypress.h |   30 ++++++++--
 drivers/ide/cy82c693.c     |  130 +--------------------------------------------
 2 files changed, 29 insertions(+), 131 deletions(-)

Index: b/drivers/ata/pata_cypress.h
===================================================================
--- a/drivers/ata/pata_cypress.h
+++ b/drivers/ata/pata_cypress.h
@@ -30,12 +30,31 @@ enum {
 
 static void cy82c693_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
+#ifndef __IDE2LIBATA
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	int bus_speed = 33;
+#else
+	struct pci_dev *pdev = ap->port_no ? to_pci_dev(ap->host->dev2)
+					   : to_pci_dev(ap->host->dev);
+	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
+#endif
+	const unsigned long T = 1000000 / bus_speed;
 	struct ata_timing t;
-	const unsigned long T = 1000000 / 33;
 	short time_16, time_8;
 	u32 addr;
 
+#ifdef __IDE2LIBATA
+	/* select primary or secondary channel */
+	if (ap->port_no > 0) {  /* drive is on the secondary channel */
+		pdev = pci_get_slot(pdev->bus, pdev->devfn + 1);
+		if (!pdev) {
+			printk(KERN_ERR "%s: tune_drive: "
+				"Cannot find secondary interface!\n",
+				adev->name);
+			return;
+		}
+	}
+#endif
 	ata_timing_compute(adev->id, adev->pio_mode, adev->pio_mode, &t, T, 1);
 
 	time_16 = clamp_val(t.recover - 1, 0, 15) |
@@ -79,10 +98,11 @@ static void cy82c693_set_dmamode(struct
 	int reg = CY82_INDEX_CHANNEL0 + ap->port_no;
 
 	/* Be afraid, be very afraid. Magic registers  in low I/O space */
-	outb(reg, 0x22);
-	outb(adev->dma_mode - XFER_MW_DMA_0, 0x23);
+	outb(reg, CY82_INDEX_PORT);
+	outb((adev->dma_mode - XFER_MW_DMA_0) |
+	     ((adev->dma_mode & 0x10) >> 2), CY82_DATA_PORT);
 
 	/* 0x50 gives the best behaviour on the Alpha's using this chip */
-	outb(CY82_INDEX_TIMEOUT, 0x22);
-	outb(0x50, 0x23);
+	outb(CY82_INDEX_TIMEOUT, CY82_INDEX_PORT);
+	outb(0x50, CY82_DATA_PORT);
 }
Index: b/drivers/ide/cy82c693.c
===================================================================
--- a/drivers/ide/cy82c693.c
+++ b/drivers/ide/cy82c693.c
@@ -18,130 +18,8 @@
 
 #define DRV_NAME "cy82c693"
 
-/*
- *	NOTE: the value for busmaster timeout is tricky and I got it by
- *	trial and error!  By using a to low value will cause DMA timeouts
- *	and drop IDE performance, and by using a to high value will cause
- *	audio playback to scatter.
- *	If you know a better value or how to calc it, please let me know.
- */
-
-/* twice the value written in cy82c693ub datasheet */
-#define BUSMASTER_TIMEOUT	0x50
-/*
- * the value above was tested on my machine and it seems to work okay
- */
-
-/* here are the offset definitions for the registers */
-#define CY82_IDE_CMDREG		0x04
-#define CY82_IDE_ADDRSETUP	0x48
-#define CY82_IDE_MASTER_IOR	0x4C
-#define CY82_IDE_MASTER_IOW	0x4D
-#define CY82_IDE_SLAVE_IOR	0x4E
-#define CY82_IDE_SLAVE_IOW	0x4F
-#define CY82_IDE_MASTER_8BIT	0x50
-#define CY82_IDE_SLAVE_8BIT	0x51
-
-#define CY82_INDEX_PORT		0x22
-#define CY82_DATA_PORT		0x23
-
-#define CY82_INDEX_CHANNEL0	0x30
-#define CY82_INDEX_CHANNEL1	0x31
-#define CY82_INDEX_TIMEOUT	0x32
-
-/*
- * set DMA mode a specific channel for CY82C693
- */
-
-static void cy82c693_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	const u8 mode = drive->dma_mode;
-	u8 single = (mode & 0x10) >> 4, index = 0, data = 0;
-
-	index = hwif->channel ? CY82_INDEX_CHANNEL1 : CY82_INDEX_CHANNEL0;
-
-	data = (mode & 3) | (single << 2);
-
-	outb(index, CY82_INDEX_PORT);
-	outb(data, CY82_DATA_PORT);
-
-	/*
-	 * note: below we set the value for Bus Master IDE TimeOut Register
-	 * I'm not absolutly sure what this does, but it solved my problem
-	 * with IDE DMA and sound, so I now can play sound and work with
-	 * my IDE driver at the same time :-)
-	 *
-	 * If you know the correct (best) value for this register please
-	 * let me know - ASK
-	 */
-
-	data = BUSMASTER_TIMEOUT;
-	outb(CY82_INDEX_TIMEOUT, CY82_INDEX_PORT);
-	outb(data, CY82_DATA_PORT);
-}
-
-static void cy82c693_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
-	const unsigned long T = 1000000 / bus_speed;
-	unsigned int addrCtrl;
-	struct ata_timing t;
-	u8 mode = drive->pio_mode, time_16, time_8;
-
-	/* select primary or secondary channel */
-	if (hwif->index > 0) {  /* drive is on the secondary channel */
-		dev = pci_get_slot(dev->bus, dev->devfn+1);
-		if (!dev) {
-			printk(KERN_ERR "%s: tune_drive: "
-				"Cannot find secondary interface!\n",
-				drive->name);
-			return;
-		}
-	}
-
-	ata_timing_compute(drive->id, mode, mode, &t, T, 1);
-
-	time_16 = clamp_val(t.recover - 1, 0, 15) |
-		  (clamp_val(t.active - 1, 0, 15) << 4);
-	time_8 = clamp_val(t.act8b - 1, 0, 15) |
-		 (clamp_val(t.rec8b - 1, 0, 15) << 4);
-
-	/* now let's write  the clocks registers */
-	if ((drive->dn & 1) == 0) {
-		/*
-		 * set master drive
-		 * address setup control register
-		 * is 32 bit !!!
-		 */
-		pci_read_config_dword(dev, CY82_IDE_ADDRSETUP, &addrCtrl);
-
-		addrCtrl &= (~0xF);
-		addrCtrl |= clamp_val(t.setup - 1, 0, 15);
-		pci_write_config_dword(dev, CY82_IDE_ADDRSETUP, addrCtrl);
-
-		/* now let's set the remaining registers */
-		pci_write_config_byte(dev, CY82_IDE_MASTER_IOR, time_16);
-		pci_write_config_byte(dev, CY82_IDE_MASTER_IOW, time_16);
-		pci_write_config_byte(dev, CY82_IDE_MASTER_8BIT, time_8);
-	} else {
-		/*
-		 * set slave drive
-		 * address setup control register
-		 * is 32 bit !!!
-		 */
-		pci_read_config_dword(dev, CY82_IDE_ADDRSETUP, &addrCtrl);
-
-		addrCtrl &= (~0xF0);
-		addrCtrl |= (clamp_val(t.setup - 1, 0, 15) << 4);
-		pci_write_config_dword(dev, CY82_IDE_ADDRSETUP, addrCtrl);
-
-		/* now let's set the remaining registers */
-		pci_write_config_byte(dev, CY82_IDE_SLAVE_IOR, time_16);
-		pci_write_config_byte(dev, CY82_IDE_SLAVE_IOW, time_16);
-		pci_write_config_byte(dev, CY82_IDE_SLAVE_8BIT, time_8);
-	}
-}
+#include <linux/ide2libata.h>
+#include "../ata/pata_cypress.h"
 
 static void __devinit init_iops_cy82c693(ide_hwif_t *hwif)
 {
@@ -157,8 +35,8 @@ static void __devinit init_iops_cy82c693
 }
 
 static const struct ide_port_ops cy82c693_port_ops = {
-	.set_pio_mode		= cy82c693_set_pio_mode,
-	.set_dma_mode		= cy82c693_set_dma_mode,
+	.set_pio_mode		= cy82c693_set_piomode,
+	.set_dma_mode		= cy82c693_set_dmamode,
 };
 
 static const struct ide_port_info cy82c693_chipset __devinitdata = {
