Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbXGCU1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbXGCU1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 16:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759173AbXGCU1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 16:27:01 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:13213 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758467AbXGCU07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 16:26:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=KyCpffrdJZ6VRq26RjN23VJ7B2MBj03u+0+X4ZygKY1BD5RbBQuqv7Pk+7MwO7k6UIE5rr/q9ty/VRhkoZV0LPs1P795lOB5qIJwQ8tyF50F0mgX5s4nfDILXIa6Yva51F1ZgL0cLmLEwOo+OrnjLTBx8JIQgjZYWg+B5JvbOjw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
Date: Tue, 3 Jul 2007 22:30:56 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707032230.57088.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/ide-probe.c        |    4 ++--
 drivers/ide/ide-taskfile.c     |   12 ++++++++----
 drivers/ide/pci/amd74xx.c      |    8 +++-----
 drivers/ide/pci/hpt366.c       |   21 ++++++++++++++++-----
 drivers/ide/pci/it821x.c       |    3 +--
 drivers/ide/pci/pdc202xx_new.c |   10 ++++++++--
 drivers/ide/setup-pci.c        |   10 +++++++---
 7 files changed, 45 insertions(+), 23 deletions(-)


Alan Cox (1):
      ide: Fix a theoretical Ooops case

Albert Lee (1):
      ide: pdc202xx_new PLL input clock fix

Andrew Morton (1):
      ide: ide_scan_pcibus(): check __pci_register_driver return value

Bartlomiej Zolnierkiewicz (2):
      amd74xx: resume fix
      it821x: fix incorrect SWDMA mask

Masatake YAMATO (1):
      ide: never called printk statement in ide-taskfile.c::wait_drive_not_busy

Sergei Shtylyov (2):
      hpt366: blacklist MAXTOR STM3320620A for UltraDMA/66
      hpt366: use correct enablebits for HPT36x


diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 41bfa4d..f5ce22c 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -574,11 +574,11 @@ static inline u8 probe_for_drive (ide_drive_t *drive)
 			/* look for ATAPI device */
 			(void) do_probe(drive, WIN_PIDENTIFY);
 		}
-		if (strstr(drive->id->model, "E X A B Y T E N E S T"))
-			enable_nest(drive);
 		if (!drive->present)
 			/* drive not found */
 			return 0;
+		if (strstr(drive->id->model, "E X A B Y T E N E S T"))
+			enable_nest(drive);
 	
 		/* identification failed? */
 		if (!drive->id_read) {
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 30175c7..aa06daf 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -238,7 +238,7 @@ EXPORT_SYMBOL(task_no_data_intr);
 static u8 wait_drive_not_busy(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	int retries = 100;
+	int retries;
 	u8 stat;
 
 	/*
@@ -246,10 +246,14 @@ static u8 wait_drive_not_busy(ide_drive_t *drive)
 	 * This can take up to 10 usec, but we will wait max 1 ms
 	 * (drive_cmd_intr() waits that long).
 	 */
-	while (((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT) && retries--)
-		udelay(10);
+	for (retries = 0; retries < 100; retries++) {
+		if ((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT)
+			udelay(10);
+		else
+			break;
+	}
 
-	if (!retries)
+	if (stat & BUSY_STAT)
 		printk(KERN_ERR "%s: drive still BUSY!\n", drive->name);
 
 	return stat;
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index 9db1be8..a2be65f 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -1,5 +1,5 @@
 /*
- * Version 2.15
+ * Version 2.16
  *
  * AMD 755/756/766/8111 and nVidia nForce/2/2s/3/3s/CK804/MCP04
  * IDE driver for Linux.
@@ -244,10 +244,8 @@ static int amd_set_drive(ide_drive_t *drive, u8 speed)
 	struct ide_timing t, p;
 	int T, UT;
 
-	if (speed != XFER_PIO_SLOW && speed != drive->current_speed)
-		if (ide_config_drive_speed(drive, speed))
-			printk(KERN_WARNING "ide%d: Drive %d didn't accept speed setting. Oh, well.\n",
-				drive->dn >> 1, drive->dn & 1);
+	if (speed != XFER_PIO_SLOW)
+		ide_config_drive_speed(drive, speed);
 
 	T = 1000000000 / amd_clock;
 	UT = T / min_t(int, max_t(int, amd_config->flags & AMD_UDMA, 1), 2);
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index ce8a544..c33d0b0 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.04	Jun 4, 2007
+ * linux/drivers/ide/pci/hpt366.c		Version 1.06	Jun 27, 2007
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
@@ -182,6 +182,7 @@ static const char *bad_ata66_4[] = {
 	"IC35L040AVER07-0",
 	"IC35L060AVER07-0",
 	"WDC AC310200R",
+	"MAXTOR STM3320620A",
 	NULL
 };
 
@@ -1513,18 +1514,28 @@ static int __devinit init_setup_hpt366(struct pci_dev *dev, ide_pci_device_t *d)
 		goto init_single;
 
 	/*
-	 * HPT36x chips are single channel and
-	 * do not seem to have the channel enable bit...
+	 * HPT36x chips have one channel per function and have
+	 * both channel enable bits located differently and visible
+	 * to both functions -- really stupid design decision... :-(
+	 * Bit 4 is for the primary channel, bit 5 for the secondary.
 	 */
 	d->channels = 1;
-	d->enablebits[0].reg = 0;
+	d->enablebits[0].mask = d->enablebits[0].val = 0x10;
 
 	if ((dev2 = pci_get_slot(dev->bus, dev->devfn + 1)) != NULL) {
-	  	u8  pin1 = 0, pin2 = 0;
+		u8  mcr1 = 0, pin1 = 0, pin2 = 0;
 		int ret;
 
 		pci_set_drvdata(dev2, info[rev]);
 
+		/*
+		 * Now we'll have to force both channels enabled if
+		 * at least one of them has been enabled by BIOS...
+		 */
+		pci_read_config_byte(dev, 0x50, &mcr1);
+		if (mcr1 & 0x30)
+			pci_write_config_byte(dev, 0x50, mcr1 | 0x30);
+
 		pci_read_config_byte(dev,  PCI_INTERRUPT_PIN, &pin1);
 		pci_read_config_byte(dev2, PCI_INTERRUPT_PIN, &pin2);
 		if (pin1 != pin2 && dev->irq == dev2->irq) {
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index 4bd4bf0..3aeb7f1 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -1,6 +1,6 @@
 
 /*
- * linux/drivers/ide/pci/it821x.c		Version 0.15	Jun 2 2007
+ * linux/drivers/ide/pci/it821x.c		Version 0.16	Jul 3 2007
  *
  * Copyright (C) 2004		Red Hat <alan@redhat.com>
  * Copyright (C) 2007		Bartlomiej Zolnierkiewicz
@@ -660,7 +660,6 @@ static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 
 	hwif->ultra_mask = 0x7f;
 	hwif->mwdma_mask = 0x07;
-	hwif->swdma_mask = 0x07;
 
 	hwif->ide_dma_check = &it821x_config_drive_for_dma;
 	if (!(hwif->udma_four))
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index cc0bfdc..0765dce 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -306,11 +306,13 @@ static long __devinit read_counter(u32 dma_base)
  */
 static long __devinit detect_pll_input_clock(unsigned long dma_base)
 {
+	struct timeval start_time, end_time;
 	long start_count, end_count;
-	long pll_input;
+	long pll_input, usec_elapsed;
 	u8 scr1;
 
 	start_count = read_counter(dma_base);
+	do_gettimeofday(&start_time);
 
 	/* Start the test mode */
 	outb(0x01, dma_base + 0x01);
@@ -322,6 +324,7 @@ static long __devinit detect_pll_input_clock(unsigned long dma_base)
 	mdelay(10);
 
 	end_count = read_counter(dma_base);
+	do_gettimeofday(&end_time);
 
 	/* Stop the test mode */
 	outb(0x01, dma_base + 0x01);
@@ -333,7 +336,10 @@ static long __devinit detect_pll_input_clock(unsigned long dma_base)
 	 * Calculate the input clock in Hz
 	 * (the clock counter is 30 bit wide and counts down)
 	 */
-	pll_input = ((start_count - end_count) & 0x3ffffff) * 100;
+	usec_elapsed = (end_time.tv_sec - start_time.tv_sec) * 1000000 +
+		(end_time.tv_usec - start_time.tv_usec);
+	pll_input = ((start_count - end_count) & 0x3ffffff) / 10 *
+		(10000000 / usec_elapsed);
 
 	DBG("start[%ld] end[%ld]\n", start_count, end_count);
 
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 67035ba..c88d332 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -872,11 +872,15 @@ void __init ide_scan_pcibus (int scan_direction)
 	 *	are post init.
 	 */
 
-	list_for_each_safe(l, n, &ide_pci_drivers)
-	{
+	list_for_each_safe(l, n, &ide_pci_drivers) {
 		list_del(l);
 		d = list_entry(l, struct pci_driver, node);
-		__pci_register_driver(d, d->driver.owner, d->driver.mod_name);
+		if (__pci_register_driver(d, d->driver.owner,
+					d->driver.mod_name)) {
+			printk(KERN_ERR "%s: failed to register driver "
+					"for %s\n", __FUNCTION__,
+					 d->driver.mod_name);
+		}
 	}
 }
 #endif
