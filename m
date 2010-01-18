Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034Ab0ARRUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab0ARRUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:20:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755145Ab0ARRTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:19:51 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52797 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab0ARRTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:19:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=u9ds3gzl2NVMxNj0VbdZGDnwDzZZCtS7252jl/MCD54k4wGNwkdqIh2ttNeQW6/pE+
         9ZgGOzLJqSn+vuPFhCwmRIPBQb7L9U5T8eryUL9uHhMxbgpM6g3/4rkszXO5A+XI3FVs
         z486ZQuyGAtYy/S3Qy+zbSkqqu1hKeZwXnass=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:18:26 +0100
Message-Id: <20100118171826.14623.15282.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 31/64] cmd64x: fix PIO and MWDMA timings calculations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cmd64x: fix PIO and MWDMA timings calculations

Just use the standard ide_timing_compute() helper to calculate
PIO and MWDMA timings.  This fixes some issues with the open-coded
version like allowing faster MWDMA timings than the ones required
by the current PIO mode or not accounting for the enhanced MWDMA
cycle time specified by the device.

Based on libata pata_cmd64x host driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cmd64x.c |   88 ++++++++++++++++-----------------------------------
 1 file changed, 29 insertions(+), 59 deletions(-)

Index: b/drivers/ide/cmd64x.c
===================================================================
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -7,6 +7,7 @@
  * Copyright (C) 1998		David S. Miller (davem@redhat.com)
  *
  * Copyright (C) 1999-2002	Andre Hedrick <andre@linux-ide.org>
+ * Copyright (C) 2007-2010	Bartlomiej Zolnierkiewicz
  * Copyright (C) 2007,2009	MontaVista Software, Inc. <source@mvista.com>
  */
 
@@ -50,72 +51,45 @@
 #define UDIDETCR1	0x7B
 #define DTPR1		0x7C
 
-static u8 quantize_timing(int timing, int quant)
-{
-	return (timing + quant - 1) / quant;
-}
-
-/*
- * This routine calculates active/recovery counts and then writes them into
- * the chipset registers.
- */
-static void program_cycle_times (ide_drive_t *drive, int cycle_time, int active_time)
+static void cmd64x_program_timings(ide_drive_t *drive, u8 mode)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
-	int clock_time = 1000 / (ide_pci_clk ? ide_pci_clk : 33);
-	u8  cycle_count, active_count, recovery_count, drwtim;
+	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
+	const unsigned long T = 1000000 / bus_speed;
 	static const u8 recovery_values[] =
 		{15, 15, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 0};
+	static const u8 setup_values[] = {0x40, 0x40, 0x40, 0x80, 0, 0xc0};
+	static const u8 arttim_regs[4] = {ARTTIM0, ARTTIM1, ARTTIM23, ARTTIM23};
 	static const u8 drwtim_regs[4] = {DRWTIM0, DRWTIM1, DRWTIM2, DRWTIM3};
+	struct ide_timing t;
+	u8 arttim = 0;
 
-	cycle_count	= quantize_timing( cycle_time, clock_time);
-	active_count	= quantize_timing(active_time, clock_time);
-	recovery_count	= cycle_count - active_count;
+	ide_timing_compute(drive, mode, &t, T, 0);
 
 	/*
 	 * In case we've got too long recovery phase, try to lengthen
 	 * the active phase
 	 */
-	if (recovery_count > 16) {
-		active_count += recovery_count - 16;
-		recovery_count = 16;
+	if (t.recover > 16) {
+		t.active += t.recover - 16;
+		t.recover = 16;
 	}
-	if (active_count > 16)		/* shouldn't actually happen... */
-	 	active_count = 16;
+	if (t.active > 16)		/* shouldn't actually happen... */
+		t.active = 16;
 
 	/*
 	 * Convert values to internal chipset representation
 	 */
-	recovery_count = recovery_values[recovery_count];
- 	active_count  &= 0x0f;
+	t.recover = recovery_values[t.recover];
+	t.active &= 0x0f;
 
 	/* Program the active/recovery counts into the DRWTIM register */
-	drwtim = (active_count << 4) | recovery_count;
-	(void) pci_write_config_byte(dev, drwtim_regs[drive->dn], drwtim);
-}
+	pci_write_config_byte(dev, drwtim_regs[drive->dn],
+			      (t.active << 4) | t.recover);
 
-/*
- * This routine writes into the chipset registers
- * PIO setup/active/recovery timings.
- */
-static void cmd64x_tune_pio(ide_drive_t *drive, const u8 pio)
-{
-	ide_hwif_t *hwif	= drive->hwif;
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
-	struct ide_timing *t	= ide_timing_find_mode(XFER_PIO_0 + pio);
-	unsigned long setup_count;
-	unsigned int cycle_time;
-	u8 arttim = 0;
-
-	static const u8 setup_values[] = {0x40, 0x40, 0x40, 0x80, 0, 0xc0};
-	static const u8 arttim_regs[4] = {ARTTIM0, ARTTIM1, ARTTIM23, ARTTIM23};
-
-	cycle_time = ide_pio_cycle_time(drive, pio);
-
-	program_cycle_times(drive, cycle_time, t->active);
-
-	setup_count = quantize_timing(t->setup,
-			1000 / (ide_pci_clk ? ide_pci_clk : 33));
+	if (mode >= XFER_SW_DMA_0)
+		return;
 
 	/*
 	 * The primary channel has individual address setup timing registers
@@ -126,15 +100,15 @@ static void cmd64x_tune_pio(ide_drive_t
 	if (hwif->channel) {
 		ide_drive_t *pair = ide_get_pair_dev(drive);
 
-		ide_set_drivedata(drive, (void *)setup_count);
+		ide_set_drivedata(drive, (void *)(unsigned long)t.setup);
 
 		if (pair)
-			setup_count = max_t(u8, setup_count,
+			t.setup = max_t(u8, t.setup,
 					(unsigned long)ide_get_drivedata(pair));
 	}
 
-	if (setup_count > 5)		/* shouldn't actually happen... */
-		setup_count = 5;
+	if (t.setup > 5)		/* shouldn't actually happen... */
+		t.setup = 5;
 
 	/*
 	 * Program the address setup clocks into the ARTTIM registers.
@@ -144,7 +118,7 @@ static void cmd64x_tune_pio(ide_drive_t
 	if (hwif->channel)
 		arttim &= ~ARTTIM23_INTR_CH1;
 	arttim &= ~0xc0;
-	arttim |= setup_values[setup_count];
+	arttim |= setup_values[t.setup];
 	(void) pci_write_config_byte(dev, arttim_regs[drive->dn], arttim);
 }
 
@@ -162,7 +136,7 @@ static void cmd64x_set_pio_mode(ide_driv
 	if (pio == 8 || pio == 9)
 		return;
 
-	cmd64x_tune_pio(drive, pio);
+	cmd64x_program_timings(drive, XFER_PIO_0 + pio);
 }
 
 static void cmd64x_set_dma_mode(ide_drive_t *drive, const u8 speed)
@@ -197,13 +171,9 @@ static void cmd64x_set_dma_mode(ide_driv
 		regU |= unit ? 0xC2 : 0x31;
 		break;
 	case XFER_MW_DMA_2:
-		program_cycle_times(drive, 120, 70);
-		break;
 	case XFER_MW_DMA_1:
-		program_cycle_times(drive, 150, 80);
-		break;
 	case XFER_MW_DMA_0:
-		program_cycle_times(drive, 480, 215);
+		cmd64x_program_timings(drive, speed);
 		break;
 	}
 
@@ -471,6 +441,6 @@ static void __exit cmd64x_ide_exit(void)
 module_init(cmd64x_ide_init);
 module_exit(cmd64x_ide_exit);
 
-MODULE_AUTHOR("Eddie Dost, David Miller, Andre Hedrick");
+MODULE_AUTHOR("Eddie Dost, David Miller, Andre Hedrick, Bartlomiej Zolnierkiewicz");
 MODULE_DESCRIPTION("PCI driver module for CMD64x IDE");
 MODULE_LICENSE("GPL");
