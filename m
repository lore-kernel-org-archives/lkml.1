Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087Ab0A2QKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab0A2QKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550Ab0A2QKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:10:42 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab0A2QKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:10:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=YMZZvYt7qbQ5DMSTqy2LVCIW8AJrRNVVbu38wrwnD9HO9zko6X4iuH8fX/H+NQwj+l
         kgpAexbEZsb7tCiSu8BS5dlm041tF7Vecu8MQQuky9enrx6qujkhEKXKkx/rv6ZmW8yw
         FPCkNUEgcAvqD0NiPwV5fP9QgIaAugXFeckl8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:10:26 +0100
Message-Id: <20100129161026.21495.14661.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 68/68] via82cxxx: convert to ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] via82cxxx: convert to ide2libata

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_via.h  |    8 -
 drivers/ide/via82cxxx.c |  261 ++++--------------------------------------------
 2 files changed, 28 insertions(+), 241 deletions(-)

Index: b/drivers/ata/pata_via.h
===================================================================
--- a/drivers/ata/pata_via.h
+++ b/drivers/ata/pata_via.h
@@ -1,5 +1,4 @@
 
-#ifdef __LINUX_LIBATA_H__
 enum {
 	VIA_BAD_PREQ	= 0x01, /* Crashes if PREQ# till DDACK# set */
 	VIA_BAD_CLK66	= 0x02, /* 66 MHz clock doesn't work correctly */
@@ -12,7 +11,7 @@ enum {
 };
 
 enum {
-	VIA_IDFLAG_SINGLE = (1 << 0), /* single channel controller */
+	VIA_IDFLAG_SINGLE = (1 << 1), /* single channel controller */
 };
 
 /*
@@ -57,7 +56,6 @@ static const struct via_isa_bridge {
 	{ "vtxxxx",	PCI_DEVICE_ID_VIA_ANON,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ NULL }
 };
-#endif
 
 #include <linux/dmi.h>
 
@@ -88,7 +86,6 @@ static int via_cable_override(struct pci
 	return 0;
 }
 
-#ifdef __LINUX_LIBATA_H__
 /**
  *	via_do_set_mode	-	set transfer mode data
  *	@ap: ATA interface
@@ -110,7 +107,9 @@ static void via_do_set_mode(struct ata_p
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	struct ata_device *peer = ata_dev_pair(adev);
 	struct ata_timing t, p;
+#ifndef __IDE2LIBATA
 	static int via_clock = 33333;	/* Bus clock in kHZ */
+#endif
 	unsigned long T =  1000000000 / via_clock;
 	unsigned long UT = T;
 	int ut;
@@ -268,4 +267,3 @@ static void via_fixup(struct pci_dev *pd
 		pci_write_config_dword(pdev, 0x50, timing);
 	}
 }
-#endif
Index: b/drivers/ide/via82cxxx.c
===================================================================
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -36,177 +36,20 @@
 
 #define DRV_NAME "via82cxxx"
 
-#define VIA_IDE_ENABLE		0x40
-#define VIA_IDE_CONFIG		0x41
-#define VIA_FIFO_CONFIG		0x43
-#define VIA_MISC_1		0x44
-#define VIA_MISC_2		0x45
-#define VIA_MISC_3		0x46
-#define VIA_DRIVE_TIMING	0x48
-#define VIA_8BIT_TIMING		0x4e
-#define VIA_ADDRESS_SETUP	0x4c
-#define VIA_UDMA_TIMING		0x50
-
-#define VIA_BAD_PREQ		0x01 /* Crashes if PREQ# till DDACK# set */
-#define VIA_BAD_CLK66		0x02 /* 66 MHz clock doesn't work correctly */
-#define VIA_SET_FIFO		0x04 /* Needs to have FIFO split set */
-#define VIA_NO_UNMASK		0x08 /* Doesn't work with IRQ unmasking on */
-#define VIA_BAD_ID		0x10 /* Has wrong vendor ID (0x1107) */
-#define VIA_BAD_AST		0x20 /* Don't touch Address Setup Timing */
-#define VIA_SATA_PATA		0x80 /* SATA/PATA combined configuration */
-
-enum {
-	VIA_IDFLAG_SINGLE = (1 << 1), /* single channel controller */
-};
-
-/*
- * VIA SouthBridge chips.
- */
-
-static struct via_isa_bridge {
-	char *name;
-	u16 id;
-	u8 rev_min;
-	u8 rev_max;
-	u8 udma_mask;
-	u8 flags;
-} via_isa_bridges[] = {
-	{ "vx855",	PCI_DEVICE_ID_VIA_VX855,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST | VIA_SATA_PATA },
-	{ "vx800",	PCI_DEVICE_ID_VIA_VX800,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST | VIA_SATA_PATA },
-	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST | VIA_SATA_PATA },
-	{ "vt8261",	PCI_DEVICE_ID_VIA_8261,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
-	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
-	{ "vt6410",	PCI_DEVICE_ID_VIA_6410,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
-	{ "vt6415",	PCI_DEVICE_ID_VIA_6410,     0x00, 0xff, ATA_UDMA6, VIA_BAD_AST },
-	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
-	{ "vt8237",	PCI_DEVICE_ID_VIA_8237,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
-	{ "vt8237a",	PCI_DEVICE_ID_VIA_8237A,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
-	{ "vt8235",	PCI_DEVICE_ID_VIA_8235,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
-	{ "vt8233a",	PCI_DEVICE_ID_VIA_8233A,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
-	{ "vt8233c",	PCI_DEVICE_ID_VIA_8233C_0,  0x00, 0x2f, ATA_UDMA5, },
-	{ "vt8233",	PCI_DEVICE_ID_VIA_8233_0,   0x00, 0x2f, ATA_UDMA5, },
-	{ "vt8231",	PCI_DEVICE_ID_VIA_8231,     0x00, 0x2f, ATA_UDMA5, },
-	{ "vt82c686b",	PCI_DEVICE_ID_VIA_82C686,   0x40, 0x4f, ATA_UDMA5, },
-	{ "vt82c686a",	PCI_DEVICE_ID_VIA_82C686,   0x10, 0x2f, ATA_UDMA4, },
-	{ "vt82c686",	PCI_DEVICE_ID_VIA_82C686,   0x00, 0x0f, ATA_UDMA2, VIA_BAD_CLK66 },
-	{ "vt82c596b",	PCI_DEVICE_ID_VIA_82C596,   0x10, 0x2f, ATA_UDMA4, },
-	{ "vt82c596a",	PCI_DEVICE_ID_VIA_82C596,   0x00, 0x0f, ATA_UDMA2, VIA_BAD_CLK66 },
-	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x47, 0x4f, ATA_UDMA2, VIA_SET_FIFO },
-	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x40, 0x46, ATA_UDMA2, VIA_SET_FIFO | VIA_BAD_PREQ },
-	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x30, 0x3f, ATA_UDMA2, VIA_SET_FIFO },
-	{ "vt82c586a",	PCI_DEVICE_ID_VIA_82C586_0, 0x20, 0x2f, ATA_UDMA2, VIA_SET_FIFO },
-	{ "vt82c586",	PCI_DEVICE_ID_VIA_82C586_0, 0x00, 0x0f,      0x00, VIA_SET_FIFO },
-	{ "vt82c576",	PCI_DEVICE_ID_VIA_82C576,   0x00, 0x2f,      0x00, VIA_SET_FIFO | VIA_NO_UNMASK },
-	{ "vt82c576",	PCI_DEVICE_ID_VIA_82C576,   0x00, 0x2f,      0x00, VIA_SET_FIFO | VIA_NO_UNMASK | VIA_BAD_ID },
-	{ "vtxxxx",	PCI_DEVICE_ID_VIA_ANON,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
-	{ NULL }
-};
-
 static unsigned int via_clock;
 static char *via_dma[] = { "16", "25", "33", "44", "66", "100", "133" };
 
+#include <linux/ide2libata.h>
+#include "../ata/pata_via.h"
+
 struct via82cxxx_dev
 {
-	struct via_isa_bridge *via_config;
+	const struct via_isa_bridge *via_config;
 	unsigned int via_80w;
 	u8 cached_device[2];
 };
 
 /**
- *	via_set_speed			-	write timing registers
- *	@dev: PCI device
- *	@dn: device
- *	@timing: IDE timing data to use
- *
- *	via_set_speed writes timing values to the chipset registers
- */
-
-static void via_set_speed(ide_hwif_t *hwif, u8 dn, struct ata_timing *timing)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	struct ide_host *host = pci_get_drvdata(dev);
-	struct via82cxxx_dev *vdev = host->host_priv;
-	u8 t;
-
-	if (~vdev->via_config->flags & VIA_BAD_AST) {
-		pci_read_config_byte(dev, VIA_ADDRESS_SETUP, &t);
-		t = (t & ~(3 << ((3 - dn) << 1))) | ((clamp_val(timing->setup, 1, 4) - 1) << ((3 - dn) << 1));
-		pci_write_config_byte(dev, VIA_ADDRESS_SETUP, t);
-	}
-
-	pci_write_config_byte(dev, VIA_8BIT_TIMING + (1 - (dn >> 1)),
-		((clamp_val(timing->act8b, 1, 16) - 1) << 4) | (clamp_val(timing->rec8b, 1, 16) - 1));
-
-	pci_write_config_byte(dev, VIA_DRIVE_TIMING + (3 - dn),
-		((clamp_val(timing->active, 1, 16) - 1) << 4) | (clamp_val(timing->recover, 1, 16) - 1));
-
-	switch (vdev->via_config->udma_mask) {
-	case ATA_UDMA2: t = timing->udma ? (0xe0 | (clamp_val(timing->udma, 2, 5) - 2)) : 0x03; break;
-	case ATA_UDMA4: t = timing->udma ? (0xe8 | (clamp_val(timing->udma, 2, 9) - 2)) : 0x0f; break;
-	case ATA_UDMA5: t = timing->udma ? (0xe0 | (clamp_val(timing->udma, 2, 9) - 2)) : 0x07; break;
-	case ATA_UDMA6: t = timing->udma ? (0xe0 | (clamp_val(timing->udma, 2, 9) - 2)) : 0x07; break;
-	}
-
-	/* Set UDMA unless device is not UDMA capable */
-	if (vdev->via_config->udma_mask) {
-		u8 udma_etc;
-
-		pci_read_config_byte(dev, VIA_UDMA_TIMING + 3 - dn, &udma_etc);
-
-		/* clear transfer mode bit */
-		udma_etc &= ~0x20;
-
-		if (timing->udma) {
-			/* preserve 80-wire cable detection bit */
-			udma_etc &= 0x10;
-			udma_etc |= t;
-		}
-
-		pci_write_config_byte(dev, VIA_UDMA_TIMING + 3 - dn, udma_etc);
-	}
-}
-
-/**
- *	via_set_drive		-	configure transfer mode
- *	@hwif: port
- *	@drive: Drive to set up
- *
- *	via_set_drive() computes timing values configures the chipset to
- *	a desired transfer mode.  It also can be called by upper layers.
- */
-
-static void via_set_drive(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	ide_drive_t *peer = ide_get_pair_dev(drive);
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	struct ide_host *host = pci_get_drvdata(dev);
-	struct via82cxxx_dev *vdev = host->host_priv;
-	struct ata_timing t, p;
-	unsigned int T, UT;
-	const u8 speed = drive->dma_mode;
-
-	T = 1000000000 / via_clock;
-
-	switch (vdev->via_config->udma_mask) {
-	case ATA_UDMA2: UT = T;   break;
-	case ATA_UDMA4: UT = T/2; break;
-	case ATA_UDMA5: UT = T/3; break;
-	case ATA_UDMA6: UT = T/4; break;
-	default:	UT = T;
-	}
-
-	ata_timing_compute(drive->id, speed, drive->pio_mode, &t, T, UT);
-
-	if (peer) {
-		ata_timing_compute(peer->id, peer->pio_mode,
-				   peer->pio_mode, &p, T, UT);
-		ata_timing_merge(&p, &t, &t, ATA_TIMING_8BIT);
-	}
-
-	via_set_speed(hwif, drive->dn, &t);
-}
-
-/**
  *	via_set_pio_mode	-	set host controller for PIO mode
  *	@hwif: port
  *	@drive: drive
@@ -216,8 +59,20 @@ static void via_set_drive(ide_hwif_t *hw
 
 static void via_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	drive->dma_mode = drive->pio_mode;
-	via_set_drive(hwif, drive);
+	const struct via_isa_bridge *config = drive->hwif->host->host_priv;
+	int set_ast = (config->flags & VIA_BAD_AST) ? 0 : 1;
+
+	via_do_set_mode(hwif, drive, drive->pio_mode, set_ast,
+			config->udma_mask);
+}
+
+static void via_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
+{
+	const struct via_isa_bridge *config = drive->hwif->host->host_priv;
+	int set_ast = (config->flags & VIA_BAD_AST) ? 0 : 1;
+
+	via_do_set_mode(hwif, drive, drive->dma_mode, set_ast,
+			config->udma_mask);
 }
 
 static u8 via_udma_filter(ide_drive_t *drive)
@@ -238,25 +93,6 @@ static u8 via_udma_filter(ide_drive_t *d
 	return hwif->ultra_mask;
 }
 
-static struct via_isa_bridge *via_config_find(struct pci_dev **isa)
-{
-	struct via_isa_bridge *via_config;
-
-	for (via_config = via_isa_bridges;
-	     via_config->id != PCI_DEVICE_ID_VIA_ANON; via_config++)
-		if ((*isa = pci_get_device(PCI_VENDOR_ID_VIA +
-			!!(via_config->flags & VIA_BAD_ID),
-			via_config->id, NULL))) {
-
-			if ((*isa)->revision >= via_config->rev_min &&
-			    (*isa)->revision <= via_config->rev_max)
-				break;
-			pci_dev_put(*isa);
-		}
-
-	return via_config;
-}
-
 /*
  * Check and handle 80-wire cable presence
  */
@@ -316,60 +152,16 @@ static int init_chipset_via82cxxx(struct
 {
 	struct ide_host *host = pci_get_drvdata(dev);
 	struct via82cxxx_dev *vdev = host->host_priv;
-	struct via_isa_bridge *via_config = vdev->via_config;
-	u8 t, v;
 	u32 u;
 
-	/*
-	 * Detect cable and configure Clk66
-	 */
-	pci_read_config_dword(dev, VIA_UDMA_TIMING, &u);
-
+	pci_read_config_dword(dev, 0x50, &u);
 	via_cable_detect(vdev, u);
 
-	if (via_config->udma_mask == ATA_UDMA4) {
-		/* Enable Clk66 */
-		pci_write_config_dword(dev, VIA_UDMA_TIMING, u|0x80008);
-	} else if (via_config->flags & VIA_BAD_CLK66) {
-		/* Would cause trouble on 596a and 686 */
-		pci_write_config_dword(dev, VIA_UDMA_TIMING, u & ~0x80008);
-	}
-
-	/*
-	 * Check whether interfaces are enabled.
-	 */
-
-	pci_read_config_byte(dev, VIA_IDE_ENABLE, &v);
-
-	/*
-	 * Set up FIFO sizes and thresholds.
-	 */
-
-	pci_read_config_byte(dev, VIA_FIFO_CONFIG, &t);
-
-	/* Disable PREQ# till DDACK# */
-	if (via_config->flags & VIA_BAD_PREQ) {
-		/* Would crash on 586b rev 41 */
-		t &= 0x7f;
-	}
-
-	/* Fix FIFO split between channels */
-	if (via_config->flags & VIA_SET_FIFO) {
-		t &= (t & 0x9f);
-		switch (v & 3) {
-			case 2: t |= 0x00; break;	/* 16 on primary */
-			case 1: t |= 0x60; break;	/* 16 on secondary */
-			case 3: t |= 0x20; break;	/* 8 pri 8 sec */
-		}
-	}
-
-	pci_write_config_byte(dev, VIA_FIFO_CONFIG, t);
+	via_fixup(dev, vdev->via_config);
 
 	return 0;
 }
 
-#include "../ata/pata_via.h"
-
 static int via82cxxx_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
@@ -390,7 +182,7 @@ static int via82cxxx_cable_detect(ide_hw
 
 static const struct ide_port_ops via_port_ops = {
 	.set_pio_mode		= via_set_pio_mode,
-	.set_dma_mode		= via_set_drive,
+	.set_dma_mode		= via_set_dma_mode,
 	.cable_detect		= via82cxxx_cable_detect,
 	.udma_filter		= via_udma_filter,
 };
@@ -466,8 +258,7 @@ static const struct ide_port_info via82c
 
 static int __devinit via_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	struct pci_dev *isa = NULL;
-	struct via_isa_bridge *via_config;
+	const struct via_isa_bridge *via_config;
 	struct via82cxxx_dev *vdev;
 	int rc;
 	u8 idx = id->driver_data;
@@ -478,19 +269,17 @@ static int __devinit via_init_one(struct
 	/*
 	 * Find the ISA bridge and check we know what it is.
 	 */
-	via_config = via_config_find(&isa);
+	via_config = via_config_find();
 
 	/*
 	 * Print the boot message.
 	 */
-	printk(KERN_INFO DRV_NAME " %s: VIA %s (rev %02x) IDE %sDMA%s\n",
-		pci_name(dev), via_config->name, isa->revision,
+	printk(KERN_INFO DRV_NAME " %s: VIA %s IDE %sDMA%s\n",
+		pci_name(dev), via_config->name,
 		via_config->udma_mask ? "U" : "MW",
 		via_dma[via_config->udma_mask ?
 			(fls(via_config->udma_mask) - 1) : 0]);
 
-	pci_dev_put(isa);
-
 	/*
 	 * Determine system bus clock.
 	 */
