Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704Ab0ARR2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab0ARR2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299Ab0ARR2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:28:30 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52797 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab0ARRUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:20:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=YVRWrPDeV26HUmBKSUln3BtkovFQ7wynCi9vEwqEFdiCv9R9CgGCHmsgyJ6ZM4iqTP
         c/Gb208ujRz/ujbxL5bLy2d98a/34fhyqGniAB0C4/Fi/fnqgor95YxOe9QsmOv5LhRU
         +xL8i68ZJMkvtM34hKNAfjMnNjeddIDbe+0Z4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:18:47 +0100
Message-Id: <20100118171847.14623.38391.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 33/64] cy82c693: fix PIO timings calculations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cy82c693: fix PIO timings calculations

Just use the standard ide_timing_compute() helper to calculate
PIO timings.  This fixes many issues with the open-coded version
like using 16-bit timings when 8-bit ones should be used or not
accounting for the enhanced cycle time specified by the device.

Based on libata pata_cypress host driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cy82c693.c |  106 +++++++++----------------------------------------
 1 file changed, 20 insertions(+), 86 deletions(-)

Index: b/drivers/ide/cy82c693.c
===================================================================
--- a/drivers/ide/cy82c693.c
+++ b/drivers/ide/cy82c693.c
@@ -1,6 +1,7 @@
 /*
  *  Copyright (C) 1998-2000 Andreas S. Krebs (akrebs@altavista.net), Maintainer
  *  Copyright (C) 1998-2002 Andre Hedrick <andre@linux-ide.org>, Integrator
+ *  Copyright (C) 2007-2010 Bartlomiej Zolnierkiewicz
  *
  * CYPRESS CY82C693 chipset IDE controller
  *
@@ -81,80 +82,6 @@
 #define CY82_INDEX_CHANNEL1	0x31
 #define CY82_INDEX_TIMEOUT	0x32
 
-/* the min and max PCI bus speed in MHz - from datasheet */
-#define CY82C963_MIN_BUS_SPEED	25
-#define CY82C963_MAX_BUS_SPEED	33
-
-/* the struct for the PIO mode timings */
-typedef struct pio_clocks_s {
-	u8	address_time;	/* Address setup (clocks) */
-	u8	time_16r;	/* clocks for 16bit IOR (0xF0=Active/data, 0x0F=Recovery) */
-	u8	time_16w;	/* clocks for 16bit IOW (0xF0=Active/data, 0x0F=Recovery) */
-	u8	time_8;		/* clocks for 8bit (0xF0=Active/data, 0x0F=Recovery) */
-} pio_clocks_t;
-
-/*
- * calc clocks using bus_speed
- * returns (rounded up) time in bus clocks for time in ns
- */
-static int calc_clk(int time, int bus_speed)
-{
-	int clocks;
-
-	clocks = (time*bus_speed+999)/1000 - 1;
-
-	if (clocks < 0)
-		clocks = 0;
-
-	if (clocks > 0x0F)
-		clocks = 0x0F;
-
-	return clocks;
-}
-
-/*
- * compute the values for the clock registers for PIO
- * mode and pci_clk [MHz] speed
- *
- * NOTE: for mode 0,1 and 2 drives 8-bit IDE command control registers are used
- *       for mode 3 and 4 drives 8 and 16-bit timings are the same
- *
- */
-static void compute_clocks(u8 pio, pio_clocks_t *p_pclk)
-{
-	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
-	int clk1, clk2;
-	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
-
-	/* we don't check against CY82C693's min and max speed,
-	 * so you can play with the idebus=xx parameter
-	 */
-
-	/* let's calc the address setup time clocks */
-	p_pclk->address_time = (u8)calc_clk(t->setup, bus_speed);
-
-	/* let's calc the active and recovery time clocks */
-	clk1 = calc_clk(t->active, bus_speed);
-
-	/* calc recovery timing */
-	clk2 = t->cycle - t->active - t->setup;
-
-	clk2 = calc_clk(clk2, bus_speed);
-
-	clk1 = (clk1<<4)|clk2;	/* combine active and recovery clocks */
-
-	/* note: we use the same values for 16bit IOR and IOW
-	 *	those are all the same, since I don't have other
-	 *	timings than those from ide-lib.c
-	 */
-
-	p_pclk->time_16r = (u8)clk1;
-	p_pclk->time_16w = (u8)clk1;
-
-	/* what are good values for 8bit ?? */
-	p_pclk->time_8 = (u8)clk1;
-}
-
 /*
  * set DMA mode a specific channel for CY82C693
  */
@@ -190,8 +117,11 @@ static void cy82c693_set_pio_mode(ide_dr
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	pio_clocks_t pclk;
+	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
+	const unsigned long T = 1000000 / bus_speed;
 	unsigned int addrCtrl;
+	struct ide_timing t;
+	u8 time_16, time_8;
 
 	/* select primary or secondary channel */
 	if (hwif->index > 0) {  /* drive is on the secondary channel */
@@ -204,8 +134,12 @@ static void cy82c693_set_pio_mode(ide_dr
 		}
 	}
 
-	/* let's calc the values for this PIO mode */
-	compute_clocks(pio, &pclk);
+	ide_timing_compute(drive, XFER_PIO_0 + pio, &t, T, 1);
+
+	time_16 = clamp_val(t.recover - 1, 0, 15) |
+		  (clamp_val(t.active - 1, 0, 15) << 4);
+	time_8 = clamp_val(t.act8b - 1, 0, 15) |
+		 (clamp_val(t.rec8b - 1, 0, 15) << 4);
 
 	/* now let's write  the clocks registers */
 	if ((drive->dn & 1) == 0) {
@@ -217,13 +151,13 @@ static void cy82c693_set_pio_mode(ide_dr
 		pci_read_config_dword(dev, CY82_IDE_ADDRSETUP, &addrCtrl);
 
 		addrCtrl &= (~0xF);
-		addrCtrl |= (unsigned int)pclk.address_time;
+		addrCtrl |= clamp_val(t.setup - 1, 0, 15);
 		pci_write_config_dword(dev, CY82_IDE_ADDRSETUP, addrCtrl);
 
 		/* now let's set the remaining registers */
-		pci_write_config_byte(dev, CY82_IDE_MASTER_IOR, pclk.time_16r);
-		pci_write_config_byte(dev, CY82_IDE_MASTER_IOW, pclk.time_16w);
-		pci_write_config_byte(dev, CY82_IDE_MASTER_8BIT, pclk.time_8);
+		pci_write_config_byte(dev, CY82_IDE_MASTER_IOR, time_16);
+		pci_write_config_byte(dev, CY82_IDE_MASTER_IOW, time_16);
+		pci_write_config_byte(dev, CY82_IDE_MASTER_8BIT, time_8);
 	} else {
 		/*
 		 * set slave drive
@@ -233,13 +167,13 @@ static void cy82c693_set_pio_mode(ide_dr
 		pci_read_config_dword(dev, CY82_IDE_ADDRSETUP, &addrCtrl);
 
 		addrCtrl &= (~0xF0);
-		addrCtrl |= ((unsigned int)pclk.address_time<<4);
+		addrCtrl |= (clamp_val(t.setup - 1, 0, 15) << 4);
 		pci_write_config_dword(dev, CY82_IDE_ADDRSETUP, addrCtrl);
 
 		/* now let's set the remaining registers */
-		pci_write_config_byte(dev, CY82_IDE_SLAVE_IOR, pclk.time_16r);
-		pci_write_config_byte(dev, CY82_IDE_SLAVE_IOW, pclk.time_16w);
-		pci_write_config_byte(dev, CY82_IDE_SLAVE_8BIT, pclk.time_8);
+		pci_write_config_byte(dev, CY82_IDE_SLAVE_IOR, time_16);
+		pci_write_config_byte(dev, CY82_IDE_SLAVE_IOW, time_16);
+		pci_write_config_byte(dev, CY82_IDE_SLAVE_8BIT, time_8);
 	}
 }
 
@@ -325,6 +259,6 @@ static void __exit cy82c693_ide_exit(voi
 module_init(cy82c693_ide_init);
 module_exit(cy82c693_ide_exit);
 
-MODULE_AUTHOR("Andreas Krebs, Andre Hedrick");
+MODULE_AUTHOR("Andreas Krebs, Andre Hedrick, Bartlomiej Zolnierkiewicz");
 MODULE_DESCRIPTION("PCI driver module for the Cypress CY82C693 IDE");
 MODULE_LICENSE("GPL");
