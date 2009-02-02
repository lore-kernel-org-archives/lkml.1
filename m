Return-Path: <linux-kernel-owner+w=401wt.eu-S1759020AbZBBViS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020AbZBBViS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758708AbZBBVhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:37:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:13673 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758690AbZBBVg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:36:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Nuiyv/cKxRNu6Ab0OphC0uskwbik66YtaC6Ux708bWrPpUCWCHoi7TTPz41itiZS6N
         UXc3AATjHdjkKFoz3hAyh30oGMoXlxqsBkEFb/iIl/KWlitzoPTzXRTIH6yjrsvSSPQw
         5B5vJ91aG7X/qzPpZhIE0GHZSHa5HUh7mIrUQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 02 Feb 2009 22:37:54 +0100
Message-Id: <20090202213754.17960.49874.sendpatchset@localhost.localdomain>
In-Reply-To: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
References: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/14] ide: use ata_tf_protocols enums
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: use ata_tf_protocols enums

* Add IDE_TFLAG_MULTI_PIO taskfile flag and set it for commands
  using multi-PIO protocol.

* Use ata_tf_protocols enums instead of TASKFILE_* defines to
  denote command's protocol and then rename ->data_phase field
  to ->protocol.

* Remove no longer needed <linux/hdreg.h> includes.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c      |   34 ++++++------------
 drivers/ide/ide-disk_proc.c |    5 +-
 drivers/ide/ide-io.c        |   11 +----
 drivers/ide/ide-ioctls.c    |    2 -
 drivers/ide/ide-park.c      |    4 +-
 drivers/ide/ide-pm.c        |    5 +-
 drivers/ide/ide-taskfile.c  |   83 ++++++++++++++++++--------------------------
 include/linux/ide.h         |    3 +
 8 files changed, 58 insertions(+), 89 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -28,7 +28,6 @@
 #include <linux/mutex.h>
 #include <linux/leds.h>
 #include <linux/ide.h>
-#include <linux/hdreg.h>
 
 #include <asm/byteorder.h>
 #include <asm/irq.h>
@@ -53,15 +52,6 @@ static const u8 ide_rw_cmds[] = {
 	ATA_CMD_WRITE_EXT,
 };
 
-static const u8 ide_data_phases[] = {
-	TASKFILE_MULTI_IN,
-	TASKFILE_MULTI_OUT,
-	TASKFILE_IN,
-	TASKFILE_OUT,
-	TASKFILE_IN_DMA,
-	TASKFILE_OUT_DMA,
-};
-
 static void ide_tf_set_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 dma)
 {
 	u8 index, lba48, write;
@@ -69,17 +59,19 @@ static void ide_tf_set_cmd(ide_drive_t *
 	lba48 = (cmd->tf_flags & IDE_TFLAG_LBA48) ? 2 : 0;
 	write = (cmd->tf_flags & IDE_TFLAG_WRITE) ? 1 : 0;
 
-	if (dma)
+	if (dma) {
+		cmd->protocol = ATA_PROT_DMA;
 		index = 8;
-	else
-		index = drive->mult_count ? 0 : 4;
+	} else {
+		cmd->protocol = ATA_PROT_PIO;
+		if (drive->mult_count) {
+			cmd->tf_flags |= IDE_TFLAG_MULTI_PIO;
+			index = 0;
+		} else
+			index = 4;
+	}
 
 	cmd->tf.command = ide_rw_cmds[index + lba48 + write];
-
-	if (dma)
-		index = 8; /* fixup index */
-
-	cmd->data_phase = ide_data_phases[index / 2 + write];
 }
 
 /*
@@ -401,9 +393,9 @@ static void idedisk_prepare_flush(struct
 		cmd->tf.command = ATA_CMD_FLUSH_EXT;
 	else
 		cmd->tf.command = ATA_CMD_FLUSH;
-	cmd->tf_flags	 = IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE |
-			   IDE_TFLAG_DYN;
-	cmd->data_phase = TASKFILE_NO_DATA;
+	cmd->tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE |
+			IDE_TFLAG_DYN;
+	cmd->protocol = ATA_PROT_NODATA;
 
 	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
 	rq->cmd_flags |= REQ_SOFTBARRIER;
Index: b/drivers/ide/ide-disk_proc.c
===================================================================
--- a/drivers/ide/ide-disk_proc.c
+++ b/drivers/ide/ide-disk_proc.c
@@ -1,6 +1,5 @@
 #include <linux/kernel.h>
 #include <linux/ide.h>
-#include <linux/hdreg.h>
 
 #include "ide-disk.h"
 
@@ -30,8 +29,8 @@ static int get_smart_data(ide_drive_t *d
 	tf->lbam    = ATA_SMART_LBAM_PASS;
 	tf->lbah    = ATA_SMART_LBAH_PASS;
 	tf->command = ATA_CMD_SMART;
-	cmd.tf_flags	= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	cmd.data_phase	= TASKFILE_IN;
+	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	cmd.protocol = ATA_PROT_PIO;
 
 	return ide_raw_taskfile(drive, &cmd, buf, 1);
 }
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -40,7 +40,6 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/ide.h>
-#include <linux/hdreg.h>
 #include <linux/completion.h>
 #include <linux/reboot.h>
 #include <linux/cdrom.h>
@@ -216,7 +215,7 @@ static ide_startstop_t ide_disk_special(
 	struct ide_cmd cmd;
 
 	memset(&cmd, 0, sizeof(cmd));
-	cmd.data_phase = TASKFILE_NO_DATA;
+	cmd.protocol = ATA_PROT_NODATA;
 
 	if (s->b.set_geometry) {
 		s->b.set_geometry = 0;
@@ -310,15 +309,9 @@ static ide_startstop_t execute_drive_cmd
 	struct ide_cmd *cmd = rq->special;
 
 	if (cmd) {
-		switch (cmd->data_phase) {
-		case TASKFILE_MULTI_OUT:
-		case TASKFILE_OUT:
-		case TASKFILE_MULTI_IN:
-		case TASKFILE_IN:
+		if (cmd->protocol == ATA_PROT_PIO) {
 			ide_init_sg_cmd(cmd, rq->nr_sectors);
 			ide_map_sg(drive, rq);
-		default:
-			break;
 		}
 
 		return do_rw_taskfile(drive, cmd);
Index: b/drivers/ide/ide-ioctls.c
===================================================================
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -148,7 +148,7 @@ static int ide_cmd_ioctl(ide_drive_t *dr
 			       IDE_TFLAG_IN_NSECT;
 	}
 	tf->command = args[0];
-	cmd.data_phase = args[3] ? TASKFILE_IN : TASKFILE_NO_DATA;
+	cmd.protocol = args[3] ? ATA_PROT_PIO : ATA_PROT_NODATA;
 
 	if (args[3]) {
 		cmd.tf_flags |= IDE_TFLAG_IO_16BIT;
Index: b/drivers/ide/ide-park.c
===================================================================
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -1,6 +1,5 @@
 #include <linux/kernel.h>
 #include <linux/ide.h>
-#include <linux/hdreg.h>
 #include <linux/jiffies.h>
 #include <linux/blkdev.h>
 
@@ -80,8 +79,9 @@ ide_startstop_t ide_do_park_unpark(ide_d
 		tf->command = ATA_CMD_CHK_POWER;
 
 	cmd.tf_flags |= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	cmd.protocol = ATA_PROT_NODATA;
+
 	cmd.rq = rq;
-	cmd.data_phase = TASKFILE_NO_DATA;
 
 	return do_rw_taskfile(drive, &cmd);
 }
Index: b/drivers/ide/ide-pm.c
===================================================================
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -1,6 +1,5 @@
 #include <linux/kernel.h>
 #include <linux/ide.h>
-#include <linux/hdreg.h>
 
 int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 {
@@ -164,8 +163,8 @@ ide_startstop_t ide_start_power_step(ide
 	return ide_stopped;
 
 out_do_tf:
-	cmd->tf_flags	 = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	cmd->data_phase = TASKFILE_NO_DATA;
+	cmd->tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	cmd->protocol = ATA_PROT_NODATA;
 
 	return do_rw_taskfile(drive, cmd);
 }
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -47,8 +47,8 @@ int taskfile_lib_get_identify (ide_drive
 		cmd.tf.command = ATA_CMD_ID_ATA;
 	else
 		cmd.tf.command = ATA_CMD_ID_ATAPI;
-	cmd.tf_flags	= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	cmd.data_phase	= TASKFILE_IN;
+	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	cmd.protocol = ATA_PROT_PIO;
 
 	return ide_raw_taskfile(drive, &cmd, buf, 1);
 }
@@ -66,13 +66,11 @@ ide_startstop_t do_rw_taskfile(ide_drive
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	const struct ide_dma_ops *dma_ops = hwif->dma_ops;
 
-	if (orig_cmd->data_phase == TASKFILE_MULTI_IN ||
-	    orig_cmd->data_phase == TASKFILE_MULTI_OUT) {
-		if (!drive->mult_count) {
-			printk(KERN_ERR "%s: multimode not set!\n",
-					drive->name);
-			return ide_stopped;
-		}
+	if (orig_cmd->protocol == ATA_PROT_PIO &&
+	    (orig_cmd->tf_flags & IDE_TFLAG_MULTI_PIO) &&
+	    drive->mult_count == 0) {
+		printk(KERN_ERR "%s: multimode not set!\n", drive->name);
+		return ide_stopped;
 	}
 
 	if (orig_cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
@@ -87,17 +85,16 @@ ide_startstop_t do_rw_taskfile(ide_drive
 		tp_ops->tf_load(drive, cmd);
 	}
 
-	switch (cmd->data_phase) {
-	case TASKFILE_MULTI_OUT:
-	case TASKFILE_OUT:
-		tp_ops->exec_command(hwif, tf->command);
-		ndelay(400);	/* FIXME */
-		return pre_task_out_intr(drive, cmd);
-	case TASKFILE_MULTI_IN:
-	case TASKFILE_IN:
+	switch (cmd->protocol) {
+	case ATA_PROT_PIO:
+		if (cmd->tf_flags & IDE_TFLAG_WRITE) {
+			tp_ops->exec_command(hwif, tf->command);
+			ndelay(400);	/* FIXME */
+			return pre_task_out_intr(drive, cmd);
+		}
 		handler = task_in_intr;
 		/* fall-through */
-	case TASKFILE_NO_DATA:
+	case ATA_PROT_NODATA:
 		if (handler == NULL)
 			handler = task_no_data_intr;
 		ide_execute_command(drive, tf->command, handler,
@@ -115,9 +112,6 @@ ide_startstop_t do_rw_taskfile(ide_drive
 }
 EXPORT_SYMBOL_GPL(do_rw_taskfile);
 
-/*
- * Handler for commands without a data phase
- */
 static ide_startstop_t task_no_data_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -274,15 +268,10 @@ static void ide_pio_datablock(ide_drive_
 
 	touch_softlockup_watchdog();
 
-	switch (cmd->data_phase) {
-	case TASKFILE_MULTI_IN:
-	case TASKFILE_MULTI_OUT:
+	if (cmd->tf_flags & IDE_TFLAG_MULTI_PIO)
 		ide_pio_multi(drive, cmd, write);
-		break;
-	default:
+	else
 		ide_pio_sector(drive, cmd, write);
-		break;
-	}
 
 	drive->io_32bit = saved_io_32bit;
 }
@@ -293,22 +282,12 @@ static ide_startstop_t task_error(ide_dr
 	if (cmd->tf_flags & IDE_TFLAG_FS) {
 		int sectors = cmd->nsect - cmd->nleft;
 
-		switch (cmd->data_phase) {
-		case TASKFILE_IN:
-			if (cmd->nleft)
-				break;
-			/* fall through */
-		case TASKFILE_OUT:
-			sectors--;
-			break;
-		case TASKFILE_MULTI_IN:
-			if (cmd->nleft)
-				break;
-			/* fall through */
-		case TASKFILE_MULTI_OUT:
-			sectors -= drive->mult_count;
-		default:
-			break;
+		if (cmd->protocol == ATA_PROT_PIO &&
+		    ((cmd->tf_flags & IDE_TFLAG_WRITE) || cmd->nleft == 0)) {
+			if (cmd->tf_flags & IDE_TFLAG_MULTI_PIO)
+				sectors -= drive->mult_count;
+			else
+				sectors--;
 		}
 
 		if (sectors > 0)
@@ -421,7 +400,7 @@ static ide_startstop_t pre_task_out_intr
 			  drive->bad_wstat, WAIT_DRQ)) {
 		printk(KERN_ERR "%s: no DRQ after issuing %sWRITE%s\n",
 			drive->name,
-			cmd->data_phase == TASKFILE_MULTI_OUT ? "MULT" : "",
+			(cmd->tf_flags & IDE_TFLAG_MULTI_PIO) ? "MULT" : "",
 			(drive->dev_flags & IDE_DFLAG_LBA48) ? "_EXT" : "");
 		return startstop;
 	}
@@ -470,7 +449,7 @@ EXPORT_SYMBOL(ide_raw_taskfile);
 
 int ide_no_data_taskfile(ide_drive_t *drive, struct ide_cmd *cmd)
 {
-	cmd->data_phase = TASKFILE_NO_DATA;
+	cmd->protocol = ATA_PROT_NODATA;
 
 	return ide_raw_taskfile(drive, cmd, NULL, 0);
 }
@@ -541,7 +520,6 @@ int ide_taskfile_ioctl(ide_drive_t *driv
 	memcpy(&cmd.tf_array[6], req_task->io_ports,
 	       HDIO_DRIVE_TASK_HDR_SIZE);
 
-	cmd.data_phase = req_task->data_phase;
 	cmd.tf_flags   = IDE_TFLAG_IO_16BIT | IDE_TFLAG_DEVICE |
 			 IDE_TFLAG_IN_TF;
 
@@ -586,10 +564,12 @@ int ide_taskfile_ioctl(ide_drive_t *driv
 		/* fixup data phase if needed */
 		if (req_task->data_phase == TASKFILE_IN_DMAQ ||
 		    req_task->data_phase == TASKFILE_IN_DMA)
-			cmd.data_phase = TASKFILE_OUT_DMA;
+			cmd.tf_flags |= IDE_TFLAG_WRITE;
 	}
 
-	switch (cmd.data_phase) {
+	cmd.protocol = ATA_PROT_DMA;
+
+	switch (req_task->data_phase) {
 		case TASKFILE_MULTI_OUT:
 			if (!drive->mult_count) {
 				/* (hs): give up if multcount is not set */
@@ -599,8 +579,10 @@ int ide_taskfile_ioctl(ide_drive_t *driv
 				err = -EPERM;
 				goto abort;
 			}
+			cmd.tf_flags |= IDE_TFLAG_MULTI_PIO;
 			/* fall through */
 		case TASKFILE_OUT:
+			cmd.protocol = ATA_PROT_PIO;
 			/* fall through */
 		case TASKFILE_OUT_DMAQ:
 		case TASKFILE_OUT_DMA:
@@ -617,8 +599,10 @@ int ide_taskfile_ioctl(ide_drive_t *driv
 				err = -EPERM;
 				goto abort;
 			}
+			cmd.tf_flags |= IDE_TFLAG_MULTI_PIO;
 			/* fall through */
 		case TASKFILE_IN:
+			cmd.protocol = ATA_PROT_PIO;
 			/* fall through */
 		case TASKFILE_IN_DMAQ:
 		case TASKFILE_IN_DMA:
@@ -626,6 +610,7 @@ int ide_taskfile_ioctl(ide_drive_t *driv
 			data_buf = inbuf;
 			break;
 		case TASKFILE_NO_DATA:
+			cmd.protocol = ATA_PROT_NODATA;
 			break;
 		default:
 			err = -EFAULT;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -298,6 +298,7 @@ enum {
 	/* struct ide_cmd was allocated using kmalloc() */
 	IDE_TFLAG_DYN			= (1 << 27),
 	IDE_TFLAG_FS			= (1 << 28),
+	IDE_TFLAG_MULTI_PIO		= (1 << 29),
 };
 
 enum {
@@ -343,7 +344,7 @@ struct ide_cmd {
 	};
 	u8			ftf_flags;	/* for TASKFILE ioctl */
 	u32			tf_flags;
-	int			data_phase;
+	int			protocol;
 
 	int			sg_nents;	  /* number of sg entries */
 	int			sg_dma_direction; /* DMA transfer direction */
