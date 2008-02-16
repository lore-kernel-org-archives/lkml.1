Return-Path: <linux-kernel-owner+w=401wt.eu-S1759844AbYBPUNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759844AbYBPUNB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 15:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757157AbYBPUMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 15:12:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:12569 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779AbYBPUMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 15:12:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=EfktW753+6MTnqIwHhY6l5lRevy4Ykh90RPv+zazcCyAQRKBlyl4dyeF+J+PaSVNP9nlNBIjc3fes/c2MOgUx8BhEE3BxrBqrklJlNPv7YnBeABfQj8GTy3c+qfqQ+cXBJgXlhuRvhAo7KzKI99OgkBt4B+Jk7DxWx0MaS7k4l8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2008 21:26:47 +0100
Message-Id: <20080216202647.25536.6929.sendpatchset@localhost.localdomain>
In-Reply-To: <20080216202634.25536.78915.sendpatchset@localhost.localdomain>
References: <20080216202634.25536.78915.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/9] cmd640: remove cmd_drives[]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pass 'ide_drive_t *drive' to check_prefetch(), set_prefetch_mode(),
  program_drive_counts() and cmd640_set_mode().

* Remove no longer needed cmd_drives[].

* Inline setup_device_ptrs() helper in cmd640x_init().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/cmd640.c |   67 ++++++++++++++++++-----------------------------
 1 file changed, 27 insertions(+), 40 deletions(-)

Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -185,7 +185,6 @@ static DEFINE_SPINLOCK(cmd640_lock);
  * These are initialized to point at the devices we control
  */
 static ide_hwif_t  *cmd_hwif0, *cmd_hwif1;
-static ide_drive_t *cmd_drives[4];
 
 /*
  * Interface to access cmd640x registers
@@ -386,9 +385,8 @@ static void cmd640_dump_regs (void)
  * Check whether prefetch is on for a drive,
  * and initialize the unmask flags for safe operation.
  */
-static void __init check_prefetch (unsigned int index)
+static void __init check_prefetch(ide_drive_t *drive, unsigned int index)
 {
-	ide_drive_t *drive = cmd_drives[index];
 	u8 b = get_cmd640_reg(prefetch_regs[index]);
 
 	if (b & prefetch_masks[index]) {	/* is prefetch off? */
@@ -404,28 +402,13 @@ static void __init check_prefetch (unsig
 	}
 }
 
-/*
- * Figure out which devices we control
- */
-static void __init setup_device_ptrs (void)
-{
-	cmd_hwif0 = &ide_hwifs[0];
-	cmd_hwif1 = &ide_hwifs[1];
-
-	cmd_drives[0] = &cmd_hwif0->drives[0];
-	cmd_drives[1] = &cmd_hwif0->drives[1];
-	cmd_drives[2] = &cmd_hwif1->drives[0];
-	cmd_drives[3] = &cmd_hwif1->drives[1];
-}
-
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
 
 /*
  * Sets prefetch mode for a drive.
  */
-static void set_prefetch_mode (unsigned int index, int mode)
+static void set_prefetch_mode(ide_drive_t *drive, unsigned int index, int mode)
 {
-	ide_drive_t *drive = cmd_drives[index];
 	unsigned long flags;
 	int reg = prefetch_regs[index];
 	u8 b;
@@ -508,7 +491,7 @@ static void __init retrieve_drive_counts
  * This routine writes the prepared setup/active/recovery counts
  * for a drive into the cmd640 chipset registers to active them.
  */
-static void program_drive_counts (unsigned int index)
+static void program_drive_counts(ide_drive_t *drive, unsigned int index)
 {
 	unsigned long flags;
 	u8 setup_count    = setup_counts[index];
@@ -522,8 +505,11 @@ static void program_drive_counts (unsign
 	 * so we merge the timings, using the slowest value for each timing.
 	 */
 	if (index > 1) {
-		unsigned int mate;
-		if (cmd_drives[mate = index ^ 1]->present) {
+		ide_hwif_t *hwif = drive->hwif;
+		ide_drive_t *peer = &hwif->drives[!drive->select.b.unit];
+		unsigned int mate = index ^ 1;
+
+		if (peer->present) {
 			if (setup_count < setup_counts[mate])
 				setup_count = setup_counts[mate];
 			if (active_count < active_counts[mate])
@@ -562,7 +548,8 @@ static void program_drive_counts (unsign
 /*
  * Set a specific pio_mode for a drive
  */
-static void cmd640_set_mode (unsigned int index, u8 pio_mode, unsigned int cycle_time)
+static void cmd640_set_mode(ide_drive_t *drive, unsigned int index,
+			    u8 pio_mode, unsigned int cycle_time)
 {
 	int setup_time, active_time, recovery_time, clock_time;
 	u8 setup_count, active_count, recovery_count, recovery_count2, cycle_count;
@@ -611,7 +598,7 @@ static void cmd640_set_mode (unsigned in
 	 *	1) this is the wrong place to do it (proper is do_special() in ide.c)
 	 * 	2) in practice this is rarely, if ever, necessary
 	 */
-	program_drive_counts (index);
+	program_drive_counts(drive, index);
 }
 
 static void cmd640_set_pio_mode(ide_drive_t *drive, const u8 pio)
@@ -619,13 +606,6 @@ static void cmd640_set_pio_mode(ide_driv
 	unsigned int index = 0, cycle_time;
 	u8 b;
 
-	while (drive != cmd_drives[index]) {
-		if (++index > 3) {
-			printk(KERN_ERR "%s: bad news in %s\n",
-					drive->name, __FUNCTION__);
-			return;
-		}
-	}
 	switch (pio) {
 		case 6: /* set fast-devsel off */
 		case 7: /* set fast-devsel on */
@@ -638,13 +618,13 @@ static void cmd640_set_pio_mode(ide_driv
 
 		case 8: /* set prefetch off */
 		case 9: /* set prefetch on */
-			set_prefetch_mode(index, pio & 1);
+			set_prefetch_mode(drive, index, pio & 1);
 			printk("%s: %sabled cmd640 prefetch\n", drive->name, (pio & 1) ? "en" : "dis");
 			return;
 	}
 
 	cycle_time = ide_pio_cycle_time(drive, pio);
-	cmd640_set_mode(index, pio, cycle_time);
+	cmd640_set_mode(drive, index, pio, cycle_time);
 
 	printk("%s: selected cmd640 PIO mode%d (%dns)",
 		drive->name, pio, cycle_time);
@@ -764,11 +744,12 @@ static int __init cmd640x_init(void)
 	printk(KERN_INFO "cmd640: buggy cmd640%c interface on %s, config=0x%02x"
 			 "\n", 'a' + cmd640_chip_version - 1, bus_type, cfr);
 
+	cmd_hwif0 = &ide_hwifs[0];
+	cmd_hwif1 = &ide_hwifs[1];
+
 	/*
 	 * Initialize data for primary port
 	 */
-	setup_device_ptrs ();
-
 	oldnoprobe = cmd_hwif0->noprobe;
 	ide_init_port_hw(cmd_hwif0, &hw[0]);
 	cmd_hwif0->noprobe = oldnoprobe;
@@ -840,7 +821,13 @@ static int __init cmd640x_init(void)
 	 * Do not unnecessarily disturb any prior BIOS setup of these.
 	 */
 	for (index = 0; index < (2 + (second_port_cmd640 << 1)); index++) {
-		ide_drive_t *drive = cmd_drives[index];
+		ide_drive_t *drive;
+
+		if (index > 1)
+			drive = &cmd_hwif1->drives[index & 1];
+		else
+			drive = &cmd_hwif0->drives[index & 1];
+
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
 		if (drive->autotune || ((index > 1) && second_port_toggled)) {
 	 		/*
@@ -850,8 +837,8 @@ static int __init cmd640x_init(void)
 			setup_counts    [index] = 4;	/* max possible */
 			active_counts   [index] = 16;	/* max possible */
 			recovery_counts [index] = 16;	/* max possible */
-			program_drive_counts (index);
-			set_prefetch_mode (index, 0);
+			program_drive_counts(drive, index);
+			set_prefetch_mode(drive, index, 0);
 			printk("cmd640: drive%d timings/prefetch cleared\n", index);
 		} else {
 			/*
@@ -859,7 +846,7 @@ static int __init cmd640x_init(void)
 			 * This preserves any prior BIOS setup.
 			 */
 			retrieve_drive_counts (index);
-			check_prefetch (index);
+			check_prefetch(drive, index);
 			printk("cmd640: drive%d timings/prefetch(%s) preserved",
 				index, drive->no_io_32bit ? "off" : "on");
 			display_clocks(index);
@@ -868,7 +855,7 @@ static int __init cmd640x_init(void)
 		/*
 		 * Set the drive unmask flags to match the prefetch setting
 		 */
-		check_prefetch (index);
+		check_prefetch(drive, index);
 		printk("cmd640: drive%d timings/prefetch(%s) preserved\n",
 			index, drive->no_io_32bit ? "off" : "on");
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
