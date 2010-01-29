Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406Ab0A2QEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab0A2QEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150Ab0A2QD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:03:59 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab0A2QDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:03:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=kgYvmxle0HFXt5lb5RIApGDaI5uKSGAhJHEjXKsXuTDU85v82Kfks8lJ5vH+032zYG
         VNcYOD3DrrBuAXb1hBejO/d0mV19+uGMI990qTDuoopRjMPTkCRAAIBR/s9HRt6obeg+
         M+KjTX0AaLdftTqebmm0F4BnZdMXI4dcqqdnA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:03:47 +0100
Message-Id: <20100129160347.21495.50289.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 06/68] ide: switch to generic ATA timings code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: switch to generic ATA timings code

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig         |    1 
 drivers/ide/Makefile        |    1 
 drivers/ide/ali14xx.c       |    2 
 drivers/ide/alim15x3.c      |   45 +++++----
 drivers/ide/amd74xx.c       |   11 +-
 drivers/ide/at91_ide.c      |    9 +
 drivers/ide/cmd640.c        |    4 
 drivers/ide/cmd64x.c        |   17 +--
 drivers/ide/cy82c693.c      |    6 -
 drivers/ide/ht6560b.c       |    3 
 drivers/ide/ide-timings.c   |  217 --------------------------------------------
 drivers/ide/ide-xfer-mode.c |   25 +++++
 drivers/ide/palm_bk3710.c   |    7 -
 drivers/ide/pmac.c          |    6 -
 drivers/ide/qd65xx.c        |    2 
 drivers/ide/sl82c105.c      |    2 
 drivers/ide/tx4938ide.c     |    2 
 drivers/ide/via82cxxx.c     |   11 +-
 include/linux/ide.h         |   35 -------
 19 files changed, 94 insertions(+), 312 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -61,6 +61,7 @@ config IDE_XFER_MODE
 
 config IDE_TIMINGS
 	bool
+	select ATA_TIMINGS
 	select IDE_XFER_MODE
 
 config IDE_ATAPI
Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -10,7 +10,6 @@ ide-core-y += ide.o ide-ioctls.o ide-io.
 
 # core IDE code
 ide-core-$(CONFIG_IDE_XFER_MODE)	+= ide-pio-blacklist.o ide-xfer-mode.o
-ide-core-$(CONFIG_IDE_TIMINGS)		+= ide-timings.o
 ide-core-$(CONFIG_IDE_ATAPI)		+= ide-atapi.o
 ide-core-$(CONFIG_BLK_DEV_IDEPCI)	+= setup-pci.o
 ide-core-$(CONFIG_BLK_DEV_IDEDMA)	+= ide-dma.o
Index: b/drivers/ide/ali14xx.c
===================================================================
--- a/drivers/ide/ali14xx.c
+++ b/drivers/ide/ali14xx.c
@@ -117,7 +117,7 @@ static void ali14xx_set_pio_mode(ide_hwi
 	unsigned long flags;
 	int bus_speed = ide_vlb_clk ? ide_vlb_clk : 50;
 	const u8 pio = drive->pio_mode - XFER_PIO_0;
-	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
+	const struct ata_timing *t = ata_timing_find_mode(XFER_PIO_0 + pio);
 
 	/* calculate timing, according to PIO mode */
 	time1 = ide_pio_cycle_time(drive, pio);
Index: b/drivers/ide/alim15x3.c
===================================================================
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -62,7 +62,7 @@ static void ali_fifo_control(ide_hwif_t
 }
 
 static void ali_program_timings(ide_hwif_t *hwif, ide_drive_t *drive,
-				struct ide_timing *t, u8 ultra)
+				struct ata_timing *t, u8 ultra)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	int port = hwif->channel ? 0x5c : 0x58;
@@ -104,19 +104,22 @@ static void ali_set_pio_mode(ide_hwif_t
 	ide_drive_t *pair = ide_get_pair_dev(drive);
 	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 	unsigned long T =  1000000 / bus_speed; /* PCI clock based */
-	struct ide_timing t;
+	struct ata_timing t;
 
-	ide_timing_compute(drive, drive->pio_mode, &t, T, 1);
+	ata_timing_compute(drive->id, drive->pio_mode, drive->pio_mode,
+			&t, T, 1);
 	if (pair) {
-		struct ide_timing p;
+		struct ata_timing p;
 
-		ide_timing_compute(pair, pair->pio_mode, &p, T, 1);
-		ide_timing_merge(&p, &t, &t,
-			IDE_TIMING_SETUP | IDE_TIMING_8BIT);
+		ata_timing_compute(pair->id, pair->pio_mode, pair->pio_mode,
+				&p, T, 1);
+		ata_timing_merge(&p, &t, &t,
+			ATA_TIMING_SETUP | ATA_TIMING_8BIT);
 		if (pair->dma_mode) {
-			ide_timing_compute(pair, pair->dma_mode, &p, T, 1);
-			ide_timing_merge(&p, &t, &t,
-				IDE_TIMING_SETUP | IDE_TIMING_8BIT);
+			ata_timing_compute(pair->id, pair->dma_mode,
+					pair->pio_mode, &p, T, 1);
+			ata_timing_merge(&p, &t, &t,
+				ATA_TIMING_SETUP | ATA_TIMING_8BIT);
 		}
 	}
 
@@ -170,21 +173,23 @@ static void ali_set_dma_mode(ide_hwif_t
 	unsigned long T		=  1000000 / bus_speed; /* PCI clock based */
 	const u8 speed		= drive->dma_mode;
 	u8 tmpbyte		= 0x00;
-	struct ide_timing t;
+	struct ata_timing t;
 
 	if (speed < XFER_UDMA_0) {
-		ide_timing_compute(drive, drive->dma_mode, &t, T, 1);
+		ata_timing_compute(drive->id, drive->dma_mode, drive->pio_mode,
+				&t, T, 1);
 		if (pair) {
-			struct ide_timing p;
+			struct ata_timing p;
 
-			ide_timing_compute(pair, pair->pio_mode, &p, T, 1);
-			ide_timing_merge(&p, &t, &t,
-				IDE_TIMING_SETUP | IDE_TIMING_8BIT);
+			ata_timing_compute(pair->id, pair->pio_mode,
+					pair->pio_mode, &p, T, 1);
+			ata_timing_merge(&p, &t, &t,
+				ATA_TIMING_SETUP | ATA_TIMING_8BIT);
 			if (pair->dma_mode) {
-				ide_timing_compute(pair, pair->dma_mode,
-						&p, T, 1);
-				ide_timing_merge(&p, &t, &t,
-					IDE_TIMING_SETUP | IDE_TIMING_8BIT);
+				ata_timing_compute(pair->id, pair->dma_mode,
+						pair->pio_mode, &p, T, 1);
+				ata_timing_merge(&p, &t, &t,
+					ATA_TIMING_SETUP | ATA_TIMING_8BIT);
 			}
 		}
 		ali_program_timings(hwif, drive, &t, 0);
Index: b/drivers/ide/amd74xx.c
===================================================================
--- a/drivers/ide/amd74xx.c
+++ b/drivers/ide/amd74xx.c
@@ -48,7 +48,7 @@ static inline u8 amd_offset(struct pci_d
  */
 
 static void amd_set_speed(struct pci_dev *dev, u8 dn, u8 udma_mask,
-			  struct ide_timing *timing)
+			  struct ata_timing *timing)
 {
 	u8 t = 0, offset = amd_offset(dev);
 
@@ -83,7 +83,7 @@ static void amd_set_drive(ide_hwif_t *hw
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	ide_drive_t *peer = ide_get_pair_dev(drive);
-	struct ide_timing t, p;
+	struct ata_timing t, p;
 	int T, UT;
 	u8 udma_mask = hwif->ultra_mask;
 	const u8 speed = drive->dma_mode;
@@ -91,11 +91,12 @@ static void amd_set_drive(ide_hwif_t *hw
 	T = 1000000000 / amd_clock;
 	UT = (udma_mask == ATA_UDMA2) ? T : (T / 2);
 
-	ide_timing_compute(drive, speed, &t, T, UT);
+	ata_timing_compute(drive->id, speed, drive->pio_mode, &t, T, UT);
 
 	if (peer) {
-		ide_timing_compute(peer, peer->pio_mode, &p, T, UT);
-		ide_timing_merge(&p, &t, &t, IDE_TIMING_8BIT);
+		ata_timing_compute(peer->id, peer->pio_mode,
+				   peer->pio_mode, &p, T, UT);
+		ata_timing_merge(&p, &t, &t, ATA_TIMING_8BIT);
 	}
 
 	if (speed == XFER_UDMA_5 && amd_clock <= 33333) t.udma = 1;
Index: b/drivers/ide/at91_ide.c
===================================================================
--- a/drivers/ide/at91_ide.c
+++ b/drivers/ide/at91_ide.c
@@ -107,7 +107,7 @@ static unsigned int calc_mck_cycles(unsi
 }
 
 static void apply_timings(const u8 chipselect, const u8 pio,
-			  const struct ide_timing *timing, int use_iordy)
+			  const struct ata_timing *timing, int use_iordy)
 {
 	unsigned int t0, t1, t2, t6z;
 	unsigned int cycle, setup, pulse, data_float;
@@ -174,14 +174,14 @@ static void at91_ide_output_data(ide_dri
 
 static void at91_ide_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	struct ide_timing *timing;
+	const struct ata_timing *timing;
 	u8 chipselect = hwif->select_data;
 	int use_iordy = 0;
 	const u8 pio = drive->pio_mode - XFER_PIO_0;
 
 	pdbg("chipselect %u pio %u\n", chipselect, pio);
 
-	timing = ide_timing_find_mode(XFER_PIO_0 + pio);
+	timing = ata_timing_find_mode(XFER_PIO_0 + pio);
 	BUG_ON(!timing);
 
 	if (ide_pio_need_iordy(drive, pio))
@@ -311,7 +311,8 @@ static int __init at91_ide_probe(struct
 	}
 
 	/* setup Static Memory Controller - PIO 0 as default */
-	apply_timings(board->chipselect, 0, ide_timing_find_mode(XFER_PIO_0), 0);
+	apply_timings(board->chipselect, 0,
+		      ata_timing_find_mode(XFER_PIO_0), 0);
 
 	/* with GPIO interrupt we have to do quirks in handler */
 	if (board->irq_pin >= PIN_BASE)
Index: b/drivers/ide/cmd640.c
===================================================================
--- a/drivers/ide/cmd640.c
+++ b/drivers/ide/cmd640.c
@@ -513,7 +513,7 @@ static void program_drive_counts(ide_dri
 static void cmd640_set_mode(ide_drive_t *drive, unsigned int index,
 			    u8 pio_mode, unsigned int cycle_time)
 {
-	struct ide_timing *t;
+	const struct ata_timing *t;
 	int setup_time, active_time, recovery_time, clock_time;
 	u8 setup_count, active_count, recovery_count, recovery_count2, cycle_count;
 	int bus_speed;
@@ -526,7 +526,7 @@ static void cmd640_set_mode(ide_drive_t
 	if (pio_mode > 5)
 		pio_mode = 5;
 
-	t = ide_timing_find_mode(XFER_PIO_0 + pio_mode);
+	t = ata_timing_find_mode(XFER_PIO_0 + pio_mode);
 	setup_time  = t->setup;
 	active_time = t->active;
 
Index: b/drivers/ide/cmd64x.c
===================================================================
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -62,10 +62,10 @@ static void cmd64x_program_timings(ide_d
 	static const u8 setup_values[] = {0x40, 0x40, 0x40, 0x80, 0, 0xc0};
 	static const u8 arttim_regs[4] = {ARTTIM0, ARTTIM1, ARTTIM23, ARTTIM23};
 	static const u8 drwtim_regs[4] = {DRWTIM0, DRWTIM1, DRWTIM2, DRWTIM3};
-	struct ide_timing t;
+	struct ata_timing t;
 	u8 arttim = 0;
 
-	ide_timing_compute(drive, mode, &t, T, 0);
+	ata_timing_compute(drive->id, mode, drive->pio_mode, &t, T, 0);
 
 	/*
 	 * In case we've got too long recovery phase, try to lengthen
@@ -98,14 +98,15 @@ static void cmd64x_program_timings(ide_d
 		ide_drive_t *pair = ide_get_pair_dev(drive);
 
 		if (pair) {
-			struct ide_timing tp;
+			struct ata_timing tp;
 
-			ide_timing_compute(pair, pair->pio_mode, &tp, T, 0);
-			ide_timing_merge(&t, &tp, &t, IDE_TIMING_SETUP);
+			ata_timing_compute(pair->id, pair->pio_mode,
+					pair->pio_mode, &tp, T, 0);
+			ata_timing_merge(&t, &tp, &t, ATA_TIMING_SETUP);
 			if (pair->dma_mode) {
-				ide_timing_compute(pair, pair->dma_mode,
-						&tp, T, 0);
-				ide_timing_merge(&tp, &t, &t, IDE_TIMING_SETUP);
+				ata_timing_compute(pair->id, pair->dma_mode,
+						pair->pio_mode, &tp, T, 0);
+				ata_timing_merge(&tp, &t, &t, ATA_TIMING_SETUP);
 			}
 		}
 	}
Index: b/drivers/ide/cy82c693.c
===================================================================
--- a/drivers/ide/cy82c693.c
+++ b/drivers/ide/cy82c693.c
@@ -86,8 +86,8 @@ static void cy82c693_set_pio_mode(ide_hw
 	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 	const unsigned long T = 1000000 / bus_speed;
 	unsigned int addrCtrl;
-	struct ide_timing t;
-	u8 time_16, time_8;
+	struct ata_timing t;
+	u8 mode = drive->pio_mode, time_16, time_8;
 
 	/* select primary or secondary channel */
 	if (hwif->index > 0) {  /* drive is on the secondary channel */
@@ -100,7 +100,7 @@ static void cy82c693_set_pio_mode(ide_hw
 		}
 	}
 
-	ide_timing_compute(drive, drive->pio_mode, &t, T, 1);
+	ata_timing_compute(drive->id, mode, mode, &t, T, 1);
 
 	time_16 = clamp_val(t.recover - 1, 0, 15) |
 		  (clamp_val(t.active - 1, 0, 15) << 4);
Index: b/drivers/ide/ht6560b.c
===================================================================
--- a/drivers/ide/ht6560b.c
+++ b/drivers/ide/ht6560b.c
@@ -205,7 +205,8 @@ static u8 ht_pio2timings(ide_drive_t *dr
 
         if (pio) {
 		unsigned int cycle_time;
-		struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
+		const struct ata_timing *t =
+			ata_timing_find_mode(XFER_PIO_0 + pio);
 
 		cycle_time = ide_pio_cycle_time(drive, pio);
 
Index: b/drivers/ide/ide-timings.c
===================================================================
--- a/drivers/ide/ide-timings.c
+++ /dev/null
@@ -1,217 +0,0 @@
-/*
- *  Copyright (c) 1999-2001 Vojtech Pavlik
- *  Copyright (c) 2007-2008 Bartlomiej Zolnierkiewicz
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- *
- * Should you need to contact me, the author, you can do so either by
- * e-mail - mail your message to <vojtech@ucw.cz>, or by paper mail:
- * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
- */
-
-#include <linux/kernel.h>
-#include <linux/ide.h>
-#include <linux/module.h>
-
-/*
- * PIO 0-5, MWDMA 0-2 and UDMA 0-6 timings (in nanoseconds).
- * These were taken from ATA/ATAPI-6 standard, rev 0a, except
- * for PIO 5, which is a nonstandard extension and UDMA6, which
- * is currently supported only by Maxtor drives.
- */
-
-static struct ide_timing ide_timing[] = {
-
-	{ XFER_UDMA_6,     0,   0,   0,   0,   0,   0,   0,  15 },
-	{ XFER_UDMA_5,     0,   0,   0,   0,   0,   0,   0,  20 },
-	{ XFER_UDMA_4,     0,   0,   0,   0,   0,   0,   0,  30 },
-	{ XFER_UDMA_3,     0,   0,   0,   0,   0,   0,   0,  45 },
-
-	{ XFER_UDMA_2,     0,   0,   0,   0,   0,   0,   0,  60 },
-	{ XFER_UDMA_1,     0,   0,   0,   0,   0,   0,   0,  80 },
-	{ XFER_UDMA_0,     0,   0,   0,   0,   0,   0,   0, 120 },
-
-	{ XFER_MW_DMA_4,  25,   0,   0,   0,  55,  20,  80,   0 },
-	{ XFER_MW_DMA_3,  25,   0,   0,   0,  65,  25, 100,   0 },
-	{ XFER_MW_DMA_2,  25,   0,   0,   0,  70,  25, 120,   0 },
-	{ XFER_MW_DMA_1,  45,   0,   0,   0,  80,  50, 150,   0 },
-	{ XFER_MW_DMA_0,  60,   0,   0,   0, 215, 215, 480,   0 },
-
-	{ XFER_SW_DMA_2,  60,   0,   0,   0, 120, 120, 240,   0 },
-	{ XFER_SW_DMA_1,  90,   0,   0,   0, 240, 240, 480,   0 },
-	{ XFER_SW_DMA_0, 120,   0,   0,   0, 480, 480, 960,   0 },
-
-	{ XFER_PIO_6,     10,  55,  20,  80,  55,  20,  80,   0 },
-	{ XFER_PIO_5,     15,  65,  25, 100,  65,  25, 100,   0 },
-	{ XFER_PIO_4,     25,  70,  25, 120,  70,  25, 120,   0 },
-	{ XFER_PIO_3,     30,  80,  70, 180,  80,  70, 180,   0 },
-
-	{ XFER_PIO_2,     30, 290,  40, 330, 100,  90, 240,   0 },
-	{ XFER_PIO_1,     50, 290,  93, 383, 125, 100, 383,   0 },
-	{ XFER_PIO_0,     70, 290, 240, 600, 165, 150, 600,   0 },
-
-	{ XFER_PIO_SLOW, 120, 290, 240, 960, 290, 240, 960,   0 },
-
-	{ 0xff }
-};
-
-struct ide_timing *ide_timing_find_mode(u8 speed)
-{
-	struct ide_timing *t;
-
-	for (t = ide_timing; t->mode != speed; t++)
-		if (t->mode == 0xff)
-			return NULL;
-	return t;
-}
-EXPORT_SYMBOL_GPL(ide_timing_find_mode);
-
-u16 ide_pio_cycle_time(ide_drive_t *drive, u8 pio)
-{
-	u16 *id = drive->id;
-	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
-	u16 cycle = 0;
-
-	if (id[ATA_ID_FIELD_VALID] & 2) {
-		if (ata_id_has_iordy(drive->id))
-			cycle = id[ATA_ID_EIDE_PIO_IORDY];
-		else
-			cycle = id[ATA_ID_EIDE_PIO];
-
-		/* conservative "downgrade" for all pre-ATA2 drives */
-		if (pio < 3 && cycle < t->cycle)
-			cycle = 0; /* use standard timing */
-
-		/* Use the standard timing for the CF specific modes too */
-		if (pio > 4 && ata_id_is_cfa(id))
-			cycle = 0;
-	}
-
-	return cycle ? cycle : t->cycle;
-}
-EXPORT_SYMBOL_GPL(ide_pio_cycle_time);
-
-#define ENOUGH(v, unit)		(((v) - 1) / (unit) + 1)
-#define EZ(v, unit)		((v) ? ENOUGH(v, unit) : 0)
-
-static void ide_timing_quantize(struct ide_timing *t, struct ide_timing *q,
-				int T, int UT)
-{
-	q->setup   = EZ(t->setup   * 1000,  T);
-	q->act8b   = EZ(t->act8b   * 1000,  T);
-	q->rec8b   = EZ(t->rec8b   * 1000,  T);
-	q->cyc8b   = EZ(t->cyc8b   * 1000,  T);
-	q->active  = EZ(t->active  * 1000,  T);
-	q->recover = EZ(t->recover * 1000,  T);
-	q->cycle   = EZ(t->cycle   * 1000,  T);
-	q->udma    = EZ(t->udma    * 1000, UT);
-}
-
-void ide_timing_merge(struct ide_timing *a, struct ide_timing *b,
-		      struct ide_timing *m, unsigned int what)
-{
-	if (what & IDE_TIMING_SETUP)
-		m->setup   = max(a->setup,   b->setup);
-	if (what & IDE_TIMING_ACT8B)
-		m->act8b   = max(a->act8b,   b->act8b);
-	if (what & IDE_TIMING_REC8B)
-		m->rec8b   = max(a->rec8b,   b->rec8b);
-	if (what & IDE_TIMING_CYC8B)
-		m->cyc8b   = max(a->cyc8b,   b->cyc8b);
-	if (what & IDE_TIMING_ACTIVE)
-		m->active  = max(a->active,  b->active);
-	if (what & IDE_TIMING_RECOVER)
-		m->recover = max(a->recover, b->recover);
-	if (what & IDE_TIMING_CYCLE)
-		m->cycle   = max(a->cycle,   b->cycle);
-	if (what & IDE_TIMING_UDMA)
-		m->udma    = max(a->udma,    b->udma);
-}
-EXPORT_SYMBOL_GPL(ide_timing_merge);
-
-int ide_timing_compute(ide_drive_t *drive, u8 speed,
-		       struct ide_timing *t, int T, int UT)
-{
-	u16 *id = drive->id;
-	struct ide_timing *s, p;
-
-	/*
-	 * Find the mode.
-	 */
-	s = ide_timing_find_mode(speed);
-	if (s == NULL)
-		return -EINVAL;
-
-	/*
-	 * Copy the timing from the table.
-	 */
-	*t = *s;
-
-	/*
-	 * If the drive is an EIDE drive, it can tell us it needs extended
-	 * PIO/MWDMA cycle timing.
-	 */
-	if (id[ATA_ID_FIELD_VALID] & 2) {	/* EIDE drive */
-		memset(&p, 0, sizeof(p));
-
-		if (speed >= XFER_PIO_0 && speed < XFER_SW_DMA_0) {
-			if (speed <= XFER_PIO_2)
-				p.cycle = p.cyc8b = id[ATA_ID_EIDE_PIO];
-			else if ((speed <= XFER_PIO_4) ||
-				 (speed == XFER_PIO_5 && !ata_id_is_cfa(id)))
-				p.cycle = p.cyc8b = id[ATA_ID_EIDE_PIO_IORDY];
-		} else if (speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2)
-			p.cycle = id[ATA_ID_EIDE_DMA_MIN];
-
-		ide_timing_merge(&p, t, t, IDE_TIMING_CYCLE | IDE_TIMING_CYC8B);
-	}
-
-	/*
-	 * Convert the timing to bus clock counts.
-	 */
-	ide_timing_quantize(t, t, T, UT);
-
-	/*
-	 * Even in DMA/UDMA modes we still use PIO access for IDENTIFY,
-	 * S.M.A.R.T and some other commands. We have to ensure that the
-	 * DMA cycle timing is slower/equal than the fastest PIO timing.
-	 */
-	if (speed >= XFER_SW_DMA_0) {
-		ide_timing_compute(drive, drive->pio_mode, &p, T, UT);
-		ide_timing_merge(&p, t, t, IDE_TIMING_ALL);
-	}
-
-	/*
-	 * Lengthen active & recovery time so that cycle time is correct.
-	 */
-	if (t->act8b + t->rec8b < t->cyc8b) {
-		t->act8b += (t->cyc8b - (t->act8b + t->rec8b)) / 2;
-		t->rec8b = t->cyc8b - t->act8b;
-	}
-
-	if (t->active + t->recover < t->cycle) {
-		t->active += (t->cycle - (t->active + t->recover)) / 2;
-		t->recover = t->cycle - t->active;
-	}
-
-	/* In a few cases quantisation may produce enough errors to
-	   leave t->cycle too low for the sum of active and recovery
-	   if so we must correct this */
-	if (t->active + t->recover > t->cycle)
-		t->cycle = t->active + t->recover;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ide_timing_compute);
Index: b/drivers/ide/ide-xfer-mode.c
===================================================================
--- a/drivers/ide/ide-xfer-mode.c
+++ b/drivers/ide/ide-xfer-mode.c
@@ -118,6 +118,31 @@ int ide_pio_need_iordy(ide_drive_t *driv
 }
 EXPORT_SYMBOL_GPL(ide_pio_need_iordy);
 
+u16 ide_pio_cycle_time(ide_drive_t *drive, u8 pio)
+{
+	u16 *id = drive->id;
+	const struct ata_timing *t = ata_timing_find_mode(XFER_PIO_0 + pio);
+	u16 cycle = 0;
+
+	if (id[ATA_ID_FIELD_VALID] & 2) {
+		if (ata_id_has_iordy(drive->id))
+			cycle = id[ATA_ID_EIDE_PIO_IORDY];
+		else
+			cycle = id[ATA_ID_EIDE_PIO];
+
+		/* conservative "downgrade" for all pre-ATA2 drives */
+		if (pio < 3 && cycle < t->cycle)
+			cycle = 0; /* use standard timing */
+
+		/* Use the standard timing for the CF specific modes too */
+		if (pio > 4 && ata_id_is_cfa(id))
+			cycle = 0;
+	}
+
+	return cycle ? cycle : t->cycle;
+}
+EXPORT_SYMBOL_GPL(ide_pio_cycle_time);
+
 int ide_set_pio_mode(ide_drive_t *drive, const u8 mode)
 {
 	ide_hwif_t *hwif = drive->hwif;
Index: b/drivers/ide/palm_bk3710.c
===================================================================
--- a/drivers/ide/palm_bk3710.c
+++ b/drivers/ide/palm_bk3710.c
@@ -112,13 +112,12 @@ static void palm_bk3710_setdmamode(void
 				   unsigned short min_cycle,
 				   unsigned int mode)
 {
+	const struct ata_timing *t = ata_timing_find_mode(mode);
 	u8 td, tkw, t0;
 	u32 val32;
 	u16 val16;
-	struct ide_timing *t;
 	int cycletime;
 
-	t = ide_timing_find_mode(mode);
 	cycletime = max_t(int, t->cycle, min_cycle);
 
 	/* DMA Data Setup */
@@ -144,11 +143,9 @@ static void palm_bk3710_setpiomode(void
 				   unsigned int dev, unsigned int cycletime,
 				   unsigned int mode)
 {
+	const struct ata_timing *t = ata_timing_find_mode(XFER_PIO_0 + mode);
 	u8 t2, t2i, t0;
 	u32 val32;
-	struct ide_timing *t;
-
-	t = ide_timing_find_mode(XFER_PIO_0 + mode);
 
 	/* PIO Data Setup */
 	t0 = DIV_ROUND_UP(cycletime, ideclk_period);
Index: b/drivers/ide/pmac.c
===================================================================
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -503,7 +503,7 @@ static void pmac_ide_set_pio_mode(ide_hw
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
 	const u8 pio = drive->pio_mode - XFER_PIO_0;
-	struct ide_timing *tim = ide_timing_find_mode(XFER_PIO_0 + pio);
+	const struct ata_timing *tim = ata_timing_find_mode(XFER_PIO_0 + pio);
 	u32 *timings, t;
 	unsigned accessTicks, recTicks;
 	unsigned accessTime, recTime;
@@ -612,7 +612,7 @@ set_timings_udma_ata4(u32 *timings, u8 s
 static int
 set_timings_udma_ata6(u32 *pio_timings, u32 *ultra_timings, u8 speed)
 {
-	struct ide_timing *t = ide_timing_find_mode(speed);
+	const struct ata_timing *t = ata_timing_find_mode(speed);
 	u32 tr;
 
 	if (speed > XFER_UDMA_5 || t == NULL)
@@ -630,7 +630,7 @@ set_timings_udma_ata6(u32 *pio_timings,
 static int
 set_timings_udma_shasta(u32 *pio_timings, u32 *ultra_timings, u8 speed)
 {
-	struct ide_timing *t = ide_timing_find_mode(speed);
+	const struct ata_timing *t = ata_timing_find_mode(speed);
 	u32 tr;
 
 	if (speed > XFER_UDMA_6 || t == NULL)
Index: b/drivers/ide/qd65xx.c
===================================================================
--- a/drivers/ide/qd65xx.c
+++ b/drivers/ide/qd65xx.c
@@ -212,7 +212,7 @@ static void qd6500_set_pio_mode(ide_hwif
 static void qd6580_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	const u8 pio = drive->pio_mode - XFER_PIO_0;
-	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
+	const struct ata_timing *t = ata_timing_find_mode(XFER_PIO_0 + pio);
 	unsigned int cycle_time;
 	int active_time   = 175;
 	int recovery_time = 415; /* worst case values from the dos driver */
Index: b/drivers/ide/sl82c105.c
===================================================================
--- a/drivers/ide/sl82c105.c
+++ b/drivers/ide/sl82c105.c
@@ -41,7 +41,7 @@
  */
 static unsigned int get_pio_timings(ide_drive_t *drive, u8 pio)
 {
-	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
+	const struct ata_timing *t = ata_timing_find_mode(XFER_PIO_0 + pio);
 	unsigned int cmd_on, cmd_off;
 	u8 iordy = 0;
 
Index: b/drivers/ide/tx4938ide.c
===================================================================
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -23,7 +23,7 @@ static void tx4938ide_tune_ebusc(unsigne
 				 unsigned int gbus_clock,
 				 u8 pio)
 {
-	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
+	const struct ata_timing *t = ata_timing_find_mode(XFER_PIO_0 + pio);
 	u64 cr = __raw_readq(&tx4938_ebuscptr->cr[ebus_ch]);
 	unsigned int sp = (cr >> 4) & 3;
 	unsigned int clock = gbus_clock / (4 - sp);
Index: b/drivers/ide/via82cxxx.c
===================================================================
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -122,7 +122,7 @@ struct via82cxxx_dev
  *	via_set_speed writes timing values to the chipset registers
  */
 
-static void via_set_speed(ide_hwif_t *hwif, u8 dn, struct ide_timing *timing)
+static void via_set_speed(ide_hwif_t *hwif, u8 dn, struct ata_timing *timing)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct ide_host *host = pci_get_drvdata(dev);
@@ -182,7 +182,7 @@ static void via_set_drive(ide_hwif_t *hw
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	struct ide_host *host = pci_get_drvdata(dev);
 	struct via82cxxx_dev *vdev = host->host_priv;
-	struct ide_timing t, p;
+	struct ata_timing t, p;
 	unsigned int T, UT;
 	const u8 speed = drive->dma_mode;
 
@@ -196,11 +196,12 @@ static void via_set_drive(ide_hwif_t *hw
 	default:	UT = T;
 	}
 
-	ide_timing_compute(drive, speed, &t, T, UT);
+	ata_timing_compute(drive->id, speed, drive->pio_mode, &t, T, UT);
 
 	if (peer) {
-		ide_timing_compute(peer, peer->pio_mode, &p, T, UT);
-		ide_timing_merge(&p, &t, &t, IDE_TIMING_8BIT);
+		ata_timing_compute(peer->id, peer->pio_mode,
+				   peer->pio_mode, &p, T, UT);
+		ata_timing_merge(&p, &t, &t, ATA_TIMING_8BIT);
 	}
 
 	via_set_speed(hwif, drive->dn, &t);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1459,44 +1459,11 @@ extern void ide_toggle_bounce(ide_drive_
 u64 ide_get_lba_addr(struct ide_cmd *, int);
 u8 ide_dump_status(ide_drive_t *, const char *, u8);
 
-struct ide_timing {
-	u8  mode;
-	u8  setup;	/* t1 */
-	u16 act8b;	/* t2 for 8-bit io */
-	u16 rec8b;	/* t2i for 8-bit io */
-	u16 cyc8b;	/* t0 for 8-bit io */
-	u16 active;	/* t2 or tD */
-	u16 recover;	/* t2i or tK */
-	u16 cycle;	/* t0 */
-	u16 udma;	/* t2CYCTYP/2 */
-};
-
-enum {
-	IDE_TIMING_SETUP	= (1 << 0),
-	IDE_TIMING_ACT8B	= (1 << 1),
-	IDE_TIMING_REC8B	= (1 << 2),
-	IDE_TIMING_CYC8B	= (1 << 3),
-	IDE_TIMING_8BIT		= IDE_TIMING_ACT8B | IDE_TIMING_REC8B |
-				  IDE_TIMING_CYC8B,
-	IDE_TIMING_ACTIVE	= (1 << 4),
-	IDE_TIMING_RECOVER	= (1 << 5),
-	IDE_TIMING_CYCLE	= (1 << 6),
-	IDE_TIMING_UDMA		= (1 << 7),
-	IDE_TIMING_ALL		= IDE_TIMING_SETUP | IDE_TIMING_8BIT |
-				  IDE_TIMING_ACTIVE | IDE_TIMING_RECOVER |
-				  IDE_TIMING_CYCLE | IDE_TIMING_UDMA,
-};
-
-struct ide_timing *ide_timing_find_mode(u8);
-u16 ide_pio_cycle_time(ide_drive_t *, u8);
-void ide_timing_merge(struct ide_timing *, struct ide_timing *,
-		      struct ide_timing *, unsigned int);
-int ide_timing_compute(ide_drive_t *, u8, struct ide_timing *, int, int);
-
 #ifdef CONFIG_IDE_XFER_MODE
 int ide_scan_pio_blacklist(char *);
 const char *ide_xfer_verbose(u8);
 int ide_pio_need_iordy(ide_drive_t *, const u8);
+u16 ide_pio_cycle_time(ide_drive_t *, u8);
 int ide_set_pio_mode(ide_drive_t *, u8);
 int ide_set_dma_mode(ide_drive_t *, u8);
 void ide_set_pio(ide_drive_t *, u8);
