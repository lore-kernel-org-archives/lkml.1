Return-Path: <linux-kernel-owner+w=401wt.eu-S1755632Ab0ARRZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab0ARRZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551Ab0ARRZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:25:55 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:51627 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab0ARRWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:22:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=F76yqC0weYNyiNj4BThEENqPXvk0yp6JZs7j7VaIiMvBI8vmm3/nrAWm4916MeCjp+
         i3lGvde+Tr7tdjYPQJmrwf76OROoigozi8U/cm0HM+VXVrR/CsdSTVqrYvVdwPI8BGCf
         +CZna/sAYcITFNgKZ2oEjLWDcWApZUDcTaDfc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:21:19 +0100
Message-Id: <20100118172119.14623.62147.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 53/64] alim15x3: fix handling of DMA timings
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] alim15x3: fix handling of DMA timings

Stop depending on the BIOS setup.

Based on libata pata_ali host driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/alim15x3.c |   55 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 16 deletions(-)

Index: b/drivers/ide/alim15x3.c
===================================================================
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -61,6 +61,25 @@ static void ali_fifo_control(ide_hwif_t
 	pci_write_config_byte(pdev, pio_fifo, fifo);
 }
 
+static void ali_program_timings(ide_hwif_t *hwif, ide_drive_t *drive,
+				struct ide_timing *t)
+{
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
+	int port = hwif->channel ? 0x5c : 0x58;
+	u8 unit = drive->dn & 1;
+
+	t->setup = clamp_val(t->setup, 1, 8) & 7;
+	t->act8b = clamp_val(t->act8b, 1, 8) & 7;
+	t->rec8b = clamp_val(t->rec8b, 1, 16) & 15;
+	t->active = clamp_val(t->active, 1, 8) & 7;
+	t->recover = clamp_val(t->recover, 1, 16) & 15;
+
+	pci_write_config_byte(dev, port, t->setup);
+	pci_write_config_byte(dev, port + 1, (t->act8b << 4) | t->rec8b);
+	pci_write_config_byte(dev, port + unit + 2,
+			      (t->active << 4) | t->recover);
+}
+
 /**
  *	ali_set_pio_mode	-	set host controller for PIO mode
  *	@hwif: port
@@ -71,12 +90,9 @@ static void ali_fifo_control(ide_hwif_t
 
 static void ali_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	ide_drive_t *pair = ide_get_pair_dev(drive);
 	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 	unsigned long T =  1000000 / bus_speed; /* PCI clock based */
-	int port = hwif->channel ? 0x5c : 0x58;
-	u8 unit = drive->dn & 1;
 	struct ide_timing t;
 
 	ide_timing_compute(drive, drive->pio_mode, &t, T, 1);
@@ -93,21 +109,12 @@ static void ali_set_pio_mode(ide_hwif_t
 		}
 	}
 
-	t.setup = clamp_val(t.setup, 1, 8) & 7;
-	t.act8b = clamp_val(t.act8b, 1, 8) & 7;
-	t.rec8b = clamp_val(t.rec8b, 1, 16) & 15;
-	t.active = clamp_val(t.active, 1, 8) & 7;
-	t.recover = clamp_val(t.recover, 1, 16) & 15;
-
 	/* 
 	 * PIO mode => ATA FIFO on, ATAPI FIFO off
 	 */
 	ali_fifo_control(hwif, drive, (drive->media == ide_disk) ? 0x05 : 0x00);
 
-	pci_write_config_byte(dev, port, t.setup);
-	pci_write_config_byte(dev, port + 1, (t.act8b << 4) | t.rec8b);
-	pci_write_config_byte(dev, port + unit + 2,
-			      (t.active << 4) | t.recover);
+	ali_program_timings(hwif, drive, &t);
 }
 
 /**
@@ -146,11 +153,15 @@ static u8 ali_udma_filter(ide_drive_t *d
 static void ali_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	ide_drive_t *pair	= ide_get_pair_dev(drive);
+	int bus_speed		= ide_pci_clk ? ide_pci_clk : 33;
+	unsigned long T		=  1000000 / bus_speed; /* PCI clock based */
 	const u8 speed		= drive->dma_mode;
 	u8 speed1		= speed;
 	u8 unit			= drive->dn & 1;
 	u8 tmpbyte		= 0x00;
 	int m5229_udma		= (hwif->channel) ? 0x57 : 0x56;
+	struct ide_timing t;
 
 	if (speed == XFER_UDMA_6)
 		speed1 = 0x47;
@@ -164,9 +175,21 @@ static void ali_set_dma_mode(ide_hwif_t
 		tmpbyte &= ultra_enable;
 		pci_write_config_byte(dev, m5229_udma, tmpbyte);
 
-		/*
-		 * FIXME: Oh, my... DMA timings are never set.
-		 */
+		ide_timing_compute(drive, drive->dma_mode, &t, T, 1);
+		if (pair) {
+			struct ide_timing p;
+
+			ide_timing_compute(pair, pair->pio_mode, &p, T, 1);
+			ide_timing_merge(&p, &t, &t,
+				IDE_TIMING_SETUP | IDE_TIMING_8BIT);
+			if (pair->dma_mode) {
+				ide_timing_compute(pair, pair->dma_mode,
+						&p, T, 1);
+				ide_timing_merge(&p, &t, &t,
+					IDE_TIMING_SETUP | IDE_TIMING_8BIT);
+			}
+		}
+		ali_program_timings(hwif, drive, &t);
 	} else {
 		pci_read_config_byte(dev, m5229_udma, &tmpbyte);
 		tmpbyte &= (0x0f << ((1-unit) << 2));
