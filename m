Return-Path: <linux-kernel-owner+w=401wt.eu-S1759592AbYERSsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592AbYERSsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756926AbYERSlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:41:21 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:28663 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757530AbYERSlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:41:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=lePH8ns4v6rF6V7TeJEjh+/WNB4vbXi/IXxHiw5L5h9zeZ5GHH4jAQhnl6WMudDz4O67eX0JSZJAGA2Zzwd/08wOFgnASR7xdAMdRAL+QwLkszj33IcapsqjhTDpKJyewKmO8Rx2VGVU/DnKsrhuiiRLIiGZ7RE4Ubx2sME/QX4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:58:40 +0200
Message-Id: <20080518185840.5636.48592.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 28/40] ide: add ide_transfer_pc() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add ide-atapi.c file for generic ATAPI support together with
  CONFIG_IDE_ATAPI config option.

* Add generic ide_transfer_pc() helper to ide-atapi.c and then
  convert ide-{floppy,tape,scsi} device drivers to use it.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig      |    6 ++++
 drivers/ide/Makefile     |    1 
 drivers/ide/ide-atapi.c  |   70 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ide/ide-floppy.c |   28 ------------------
 drivers/ide/ide-tape.c   |   56 +------------------------------------
 drivers/scsi/ide-scsi.c  |   30 +-------------------
 include/linux/ide.h      |    3 ++
 7 files changed, 85 insertions(+), 109 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -98,6 +98,9 @@ if BLK_DEV_IDE
 
 comment "Please see Documentation/ide/ide.txt for help/info on IDE drives"
 
+config IDE_ATAPI
+	bool
+
 config BLK_DEV_IDE_SATA
 	bool "Support for SATA (deprecated; conflicts with libata SATA driver)"
 	default n
@@ -201,6 +204,7 @@ config BLK_DEV_IDECD_VERBOSE_ERRORS
 
 config BLK_DEV_IDETAPE
 	tristate "Include IDE/ATAPI TAPE support"
+	select IDE_ATAPI
 	help
 	  If you have an IDE tape drive using the ATAPI protocol, say Y.
 	  ATAPI is a newer protocol used by IDE tape and CD-ROM drives,
@@ -223,6 +227,7 @@ config BLK_DEV_IDETAPE
 
 config BLK_DEV_IDEFLOPPY
 	tristate "Include IDE/ATAPI FLOPPY support"
+	select IDE_ATAPI
 	---help---
 	  If you have an IDE floppy drive which uses the ATAPI protocol,
 	  answer Y.  ATAPI is a newer protocol used by IDE CD-ROM/tape/floppy
@@ -246,6 +251,7 @@ config BLK_DEV_IDEFLOPPY
 config BLK_DEV_IDESCSI
 	tristate "SCSI emulation support"
 	depends on SCSI
+	select IDE_ATAPI
 	---help---
 	  WARNING: ide-scsi is no longer needed for cd writing applications!
 	  The 2.6 kernel supports direct writing to ide-cd, which eliminates
Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -14,6 +14,7 @@ EXTRA_CFLAGS				+= -Idrivers/ide
 ide-core-y += ide.o ide-io.o ide-iops.o ide-lib.o ide-probe.o ide-taskfile.o
 
 # core IDE code
+ide-core-$(CONFIG_IDE_ATAPI)		+= ide-atapi.o
 ide-core-$(CONFIG_BLK_DEV_IDEPCI)	+= setup-pci.o
 ide-core-$(CONFIG_BLK_DEV_IDEDMA)	+= ide-dma.o
 ide-core-$(CONFIG_IDE_PROC_FS)		+= ide-proc.o
Index: b/drivers/ide/ide-atapi.c
===================================================================
--- /dev/null
+++ b/drivers/ide/ide-atapi.c
@@ -0,0 +1,70 @@
+/*
+ * ATAPI support.
+ */
+
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/ide.h>
+
+static u8 ide_wait_ireason(ide_drive_t *drive, u8 ireason)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	int retries = 100;
+
+	while (retries-- && ((ireason & CD) == 0 || (ireason & IO))) {
+		printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
+				"a packet command, retrying\n", drive->name);
+		udelay(100);
+		ireason = hwif->INB(hwif->io_ports.nsect_addr);
+		if (retries == 0) {
+			printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
+					"a packet command, ignoring\n",
+					drive->name);
+			ireason |= CD;
+			ireason &= ~IO;
+		}
+	}
+
+	return ireason;
+}
+
+ide_startstop_t ide_transfer_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
+				ide_handler_t *handler, unsigned int timeout,
+				ide_expiry_t *expiry)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	ide_startstop_t startstop;
+	u8 ireason;
+
+	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
+		printk(KERN_ERR "%s: Strange, packet command initiated yet "
+				"DRQ isn't asserted\n", drive->name);
+		return startstop;
+	}
+
+	ireason = hwif->INB(hwif->io_ports.nsect_addr);
+	if (drive->media == ide_tape && !drive->scsi)
+		ireason = ide_wait_ireason(drive, ireason);
+
+	if ((ireason & CD) == 0 || (ireason & IO)) {
+		printk(KERN_ERR "%s: (IO,CoD) != (0,1) while issuing "
+				"a packet command\n", drive->name);
+		return ide_do_reset(drive);
+	}
+
+	/* Set the interrupt routine */
+	ide_set_handler(drive, handler, timeout, expiry);
+
+	/* Begin DMA, if necessary */
+	if (pc->flags & PC_FLAG_DMA_OK) {
+		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
+		hwif->dma_ops->dma_start(drive);
+	}
+
+	/* Send the actual packet */
+	if ((pc->flags & PC_FLAG_ZIP_DRIVE) == 0)
+		hwif->output_data(drive, NULL, pc->c, 12);
+
+	return ide_started;
+}
+EXPORT_SYMBOL_GPL(ide_transfer_pc);
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -532,25 +532,11 @@ static int idefloppy_transfer_pc2(ide_dr
 
 static ide_startstop_t idefloppy_transfer_pc1(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	struct ide_atapi_pc *pc = floppy->pc;
 	ide_expiry_t *expiry;
 	unsigned int timeout;
-	ide_startstop_t startstop;
-	u8 ireason;
 
-	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
-		printk(KERN_ERR "%s: Strange, packet command initiated yet "
-				"DRQ isn't asserted\n", drive->name);
-		return startstop;
-	}
-	ireason = hwif->INB(hwif->io_ports.nsect_addr);
-	if ((ireason & CD) == 0 || (ireason & IO)) {
-		printk(KERN_ERR "%s: (IO,CoD) != (0,1) while issuing "
-				"a packet command\n", drive->name);
-		return ide_do_reset(drive);
-	}
 	/*
 	 * The following delay solves a problem with ATAPI Zip 100 drives
 	 * where the Busy flag was apparently being deasserted before the
@@ -567,19 +553,7 @@ static ide_startstop_t idefloppy_transfe
 		expiry = NULL;
 	}
 
-	ide_set_handler(drive, &idefloppy_pc_intr, timeout, expiry);
-
-	/* Begin DMA, if necessary */
-	if (pc->flags & PC_FLAG_DMA_OK) {
-		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
-		hwif->dma_ops->dma_start(drive);
-	}
-
-	if ((pc->flags & PC_FLAG_ZIP_DRIVE) == 0)
-		/* Send the actual packet */
-		hwif->output_data(drive, NULL, floppy->pc->c, 12);
-
-	return ide_started;
+	return ide_transfer_pc(drive, pc, idefloppy_pc_intr, timeout, expiry);
 }
 
 static void ide_floppy_report_error(idefloppy_floppy_t *floppy,
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -947,64 +947,12 @@ static ide_startstop_t idetape_pc_intr(i
  * again, the callback function will be called and then we will handle the next
  * request.
  */
-
-static u8 ide_tape_wait_ireason(ide_drive_t *drive, u8 ireason)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	int retries = 100;
-
-	while (retries-- && ((ireason & CD) == 0 || (ireason & IO))) {
-		printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
-				"a packet command, retrying\n", drive->name);
-		udelay(100);
-		ireason = hwif->INB(hwif->io_ports.nsect_addr);
-		if (retries == 0) {
-			printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
-					"a packet command, ignoring\n",
-					drive->name);
-			ireason |= CD;
-			ireason &= ~IO;
-		}
-	}
-
-	return ireason;
-}
-
 static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	idetape_tape_t *tape = drive->driver_data;
-	struct ide_atapi_pc *pc = tape->pc;
-	ide_startstop_t startstop;
-	u8 ireason;
-
-	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
-		printk(KERN_ERR "%s: Strange, packet command initiated yet "
-				"DRQ isn't asserted\n", drive->name);
-		return startstop;
-	}
-
-	ireason = hwif->INB(hwif->io_ports.nsect_addr);
-	ireason = ide_tape_wait_ireason(drive, ireason);
-
-	if ((ireason & CD) == 0 || (ireason & IO)) {
-		printk(KERN_ERR "%s: (IO,CoD) != (0,1) while issuing "
-				"a packet command\n", drive->name);
-		return ide_do_reset(drive);
-	}
-	/* Set the interrupt routine */
-	ide_set_handler(drive, &idetape_pc_intr, IDETAPE_WAIT_CMD, NULL);
-
-	/* Begin DMA, if necessary */
-	if (pc->flags & PC_FLAG_DMA_OK) {
-		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
-		hwif->dma_ops->dma_start(drive);
-	}
-
-	/* Send the actual packet */
-	hwif->output_data(drive, NULL, pc->c, 12);
 
-	return ide_started;
+	return ide_transfer_pc(drive, tape->pc, idetape_pc_intr,
+			       IDETAPE_WAIT_CMD, NULL);
 }
 
 static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -453,36 +453,10 @@ static ide_startstop_t idescsi_pc_intr (
 
 static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-	struct ide_atapi_pc *pc = scsi->pc;
-	ide_startstop_t startstop;
-	u8 ireason;
-
-	if (ide_wait_stat(&startstop,drive,DRQ_STAT,BUSY_STAT,WAIT_READY)) {
-		printk(KERN_ERR "%s: Strange, packet command initiated yet "
-				"DRQ isn't asserted\n", drive->name);
-		return startstop;
-	}
-	ireason = hwif->INB(hwif->io_ports.nsect_addr);
-	if ((ireason & CD) == 0 || (ireason & IO)) {
-		printk(KERN_ERR "%s: (IO,CoD) != (0,1) while issuing "
-				"a packet command\n", drive->name);
-		return ide_do_reset (drive);
-	}
-
-	/* Set the interrupt routine */
-	ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
-
-	if (pc->flags & PC_FLAG_DMA_OK) {
-		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
-		hwif->dma_ops->dma_start(drive);
-	}
-
-	/* Send the actual packet */
-	hwif->output_data(drive, NULL, scsi->pc->c, 12);
 
-	return ide_started;
+	return ide_transfer_pc(drive, scsi->pc, idescsi_pc_intr,
+			       get_timeout(scsi->pc), idescsi_expiry);
 }
 
 static inline int idescsi_set_direction(struct ide_atapi_pc *pc)
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -952,6 +952,9 @@ extern int drive_is_ready(ide_drive_t *)
 
 void ide_pktcmd_tf_load(ide_drive_t *, u32, u16, u8);
 
+ide_startstop_t ide_transfer_pc(ide_drive_t *, struct ide_atapi_pc *,
+				ide_handler_t *, unsigned int, ide_expiry_t *);
+
 ide_startstop_t do_rw_taskfile(ide_drive_t *, ide_task_t *);
 
 void task_end_request(ide_drive_t *, struct request *, u8);
