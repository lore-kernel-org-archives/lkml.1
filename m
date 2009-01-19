Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbZASNFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbZASNFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:05:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760181AbZASNDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:03:35 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:46104 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760693AbZASNDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:03:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=NbKuxpqMe882op7FFvoZnHgzNHgn+2XQwi+75NPtsP52LIvPi4pIjHqKLesN0/fL8T
         NMy/8BNWUb/0+G+fv/zulz4eDJ2XFyP5m6cPphAkoy5/hWbB7x5N6GJdFSSJtBhLNfEz
         VHCqQALfWF7VCzvppRmKNgPsShEC8pjHzKwME=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2009 14:03:49 +0100
Message-Id: <20090119130349.24745.81859.sendpatchset@localhost.localdomain>
In-Reply-To: <20090119130309.24745.40877.sendpatchset@localhost.localdomain>
References: <20090119130309.24745.40877.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/6] ide: move error handling code to ide-eh.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: move error handling code to ide-eh.c

Do some CodingStyle fixups in <linux/ide.h> while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Makefile   |    2 
 drivers/ide/ide-eh.c   |  427 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ide/ide-io.c   |  129 --------------
 drivers/ide/ide-iops.c |  299 ----------------------------------
 include/linux/ide.h    |   13 -
 5 files changed, 439 insertions(+), 431 deletions(-)

Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -6,7 +6,7 @@ EXTRA_CFLAGS				+= -Idrivers/ide
 
 ide-core-y += ide.o ide-ioctls.o ide-io.o ide-iops.o ide-lib.o ide-probe.o \
 	      ide-taskfile.o ide-pm.o ide-park.o ide-sysfs.o ide-devsets.o \
-	      ide-io-sff.o
+	      ide-io-sff.o ide-eh.o
 
 # core IDE code
 ide-core-$(CONFIG_IDE_XFER_MODE)	+= ide-pio-blacklist.o ide-xfer-mode.o
Index: b/drivers/ide/ide-eh.c
===================================================================
--- /dev/null
+++ b/drivers/ide/ide-eh.c
@@ -0,0 +1,427 @@
+
+#include <linux/kernel.h>
+#include <linux/ide.h>
+
+static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq,
+				     u8 stat, u8 err)
+{
+	ide_hwif_t *hwif = drive->hwif;
+
+	if ((stat & ATA_BUSY) ||
+	    ((stat & ATA_DF) && (drive->dev_flags & IDE_DFLAG_NOWERR) == 0)) {
+		/* other bits are useless when BUSY */
+		rq->errors |= ERROR_RESET;
+	} else if (stat & ATA_ERR) {
+		/* err has different meaning on cdrom and tape */
+		if (err == ATA_ABORTED) {
+			if ((drive->dev_flags & IDE_DFLAG_LBA) &&
+			    /* some newer drives don't support ATA_CMD_INIT_DEV_PARAMS */
+			    hwif->tp_ops->read_status(hwif) == ATA_CMD_INIT_DEV_PARAMS)
+				return ide_stopped;
+		} else if ((err & BAD_CRC) == BAD_CRC) {
+			/* UDMA crc error, just retry the operation */
+			drive->crc_count++;
+		} else if (err & (ATA_BBK | ATA_UNC)) {
+			/* retries won't help these */
+			rq->errors = ERROR_MAX;
+		} else if (err & ATA_TRK0NF) {
+			/* help it find track zero */
+			rq->errors |= ERROR_RECAL;
+		}
+	}
+
+	if ((stat & ATA_DRQ) && rq_data_dir(rq) == READ &&
+	    (hwif->host_flags & IDE_HFLAG_ERROR_STOPS_FIFO) == 0) {
+		int nsect = drive->mult_count ? drive->mult_count : 1;
+
+		ide_pad_transfer(drive, READ, nsect * SECTOR_SIZE);
+	}
+
+	if (rq->errors >= ERROR_MAX || blk_noretry_request(rq)) {
+		ide_kill_rq(drive, rq);
+		return ide_stopped;
+	}
+
+	if (hwif->tp_ops->read_status(hwif) & (ATA_BUSY | ATA_DRQ))
+		rq->errors |= ERROR_RESET;
+
+	if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
+		++rq->errors;
+		return ide_do_reset(drive);
+	}
+
+	if ((rq->errors & ERROR_RECAL) == ERROR_RECAL)
+		drive->special.b.recalibrate = 1;
+
+	++rq->errors;
+
+	return ide_stopped;
+}
+
+static ide_startstop_t ide_atapi_error(ide_drive_t *drive, struct request *rq,
+				       u8 stat, u8 err)
+{
+	ide_hwif_t *hwif = drive->hwif;
+
+	if ((stat & ATA_BUSY) ||
+	    ((stat & ATA_DF) && (drive->dev_flags & IDE_DFLAG_NOWERR) == 0)) {
+		/* other bits are useless when BUSY */
+		rq->errors |= ERROR_RESET;
+	} else {
+		/* add decoding error stuff */
+	}
+
+	if (hwif->tp_ops->read_status(hwif) & (ATA_BUSY | ATA_DRQ))
+		/* force an abort */
+		hwif->tp_ops->exec_command(hwif, ATA_CMD_IDLEIMMEDIATE);
+
+	if (rq->errors >= ERROR_MAX) {
+		ide_kill_rq(drive, rq);
+	} else {
+		if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
+			++rq->errors;
+			return ide_do_reset(drive);
+		}
+		++rq->errors;
+	}
+
+	return ide_stopped;
+}
+
+static ide_startstop_t __ide_error(ide_drive_t *drive, struct request *rq,
+				   u8 stat, u8 err)
+{
+	if (drive->media == ide_disk)
+		return ide_ata_error(drive, rq, stat, err);
+	return ide_atapi_error(drive, rq, stat, err);
+}
+
+/**
+ *	ide_error	-	handle an error on the IDE
+ *	@drive: drive the error occurred on
+ *	@msg: message to report
+ *	@stat: status bits
+ *
+ *	ide_error() takes action based on the error returned by the drive.
+ *	For normal I/O that may well include retries. We deal with
+ *	both new-style (taskfile) and old style command handling here.
+ *	In the case of taskfile command handling there is work left to
+ *	do
+ */
+
+ide_startstop_t ide_error(ide_drive_t *drive, const char *msg, u8 stat)
+{
+	struct request *rq;
+	u8 err;
+
+	err = ide_dump_status(drive, msg, stat);
+
+	rq = drive->hwif->rq;
+	if (rq == NULL)
+		return ide_stopped;
+
+	/* retry only "normal" I/O: */
+	if (!blk_fs_request(rq)) {
+		rq->errors = 1;
+		ide_end_drive_cmd(drive, stat, err);
+		return ide_stopped;
+	}
+
+	return __ide_error(drive, rq, stat, err);
+}
+EXPORT_SYMBOL_GPL(ide_error);
+
+static inline void ide_complete_drive_reset(ide_drive_t *drive, int err)
+{
+	struct request *rq = drive->hwif->rq;
+
+	if (rq && blk_special_request(rq) && rq->cmd[0] == REQ_DRIVE_RESET)
+		ide_end_request(drive, err ? err : 1, 0);
+}
+
+/* needed below */
+static ide_startstop_t do_reset1(ide_drive_t *, int);
+
+/*
+ * atapi_reset_pollfunc() gets invoked to poll the interface for completion
+ * every 50ms during an atapi drive reset operation.  If the drive has not yet
+ * responded, and we have not yet hit our maximum waiting time, then the timer
+ * is restarted for another 50ms.
+ */
+static ide_startstop_t atapi_reset_pollfunc(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 stat;
+
+	SELECT_DRIVE(drive);
+	udelay(10);
+	stat = hwif->tp_ops->read_status(hwif);
+
+	if (OK_STAT(stat, 0, ATA_BUSY))
+		printk(KERN_INFO "%s: ATAPI reset complete\n", drive->name);
+	else {
+		if (time_before(jiffies, hwif->poll_timeout)) {
+			ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20,
+					NULL);
+			/* continue polling */
+			return ide_started;
+		}
+		/* end of polling */
+		hwif->polling = 0;
+		printk(KERN_ERR "%s: ATAPI reset timed-out, status=0x%02x\n",
+			drive->name, stat);
+		/* do it the old fashioned way */
+		return do_reset1(drive, 1);
+	}
+	/* done polling */
+	hwif->polling = 0;
+	ide_complete_drive_reset(drive, 0);
+	return ide_stopped;
+}
+
+static void ide_reset_report_error(ide_hwif_t *hwif, u8 err)
+{
+	static const char *err_master_vals[] =
+		{ NULL, "passed", "formatter device error",
+		  "sector buffer error", "ECC circuitry error",
+		  "controlling MPU error" };
+
+	u8 err_master = err & 0x7f;
+
+	printk(KERN_ERR "%s: reset: master: ", hwif->name);
+	if (err_master && err_master < 6)
+		printk(KERN_CONT "%s", err_master_vals[err_master]);
+	else
+		printk(KERN_CONT "error (0x%02x?)", err);
+	if (err & 0x80)
+		printk(KERN_CONT "; slave: failed");
+	printk(KERN_CONT "\n");
+}
+
+/*
+ * reset_pollfunc() gets invoked to poll the interface for completion every 50ms
+ * during an ide reset operation. If the drives have not yet responded,
+ * and we have not yet hit our maximum waiting time, then the timer is restarted
+ * for another 50ms.
+ */
+static ide_startstop_t reset_pollfunc(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_port_ops *port_ops = hwif->port_ops;
+	u8 tmp;
+	int err = 0;
+
+	if (port_ops && port_ops->reset_poll) {
+		err = port_ops->reset_poll(drive);
+		if (err) {
+			printk(KERN_ERR "%s: host reset_poll failure for %s.\n",
+				hwif->name, drive->name);
+			goto out;
+		}
+	}
+
+	tmp = hwif->tp_ops->read_status(hwif);
+
+	if (!OK_STAT(tmp, 0, ATA_BUSY)) {
+		if (time_before(jiffies, hwif->poll_timeout)) {
+			ide_set_handler(drive, &reset_pollfunc, HZ/20, NULL);
+			/* continue polling */
+			return ide_started;
+		}
+		printk(KERN_ERR "%s: reset timed-out, status=0x%02x\n",
+			hwif->name, tmp);
+		drive->failures++;
+		err = -EIO;
+	} else  {
+		tmp = ide_read_error(drive);
+
+		if (tmp == 1) {
+			printk(KERN_INFO "%s: reset: success\n", hwif->name);
+			drive->failures = 0;
+		} else {
+			ide_reset_report_error(hwif, tmp);
+			drive->failures++;
+			err = -EIO;
+		}
+	}
+out:
+	hwif->polling = 0;	/* done polling */
+	ide_complete_drive_reset(drive, err);
+	return ide_stopped;
+}
+
+static void ide_disk_pre_reset(ide_drive_t *drive)
+{
+	int legacy = (drive->id[ATA_ID_CFS_ENABLE_2] & 0x0400) ? 0 : 1;
+
+	drive->special.all = 0;
+	drive->special.b.set_geometry = legacy;
+	drive->special.b.recalibrate  = legacy;
+
+	drive->mult_count = 0;
+	drive->dev_flags &= ~IDE_DFLAG_PARKED;
+
+	if ((drive->dev_flags & IDE_DFLAG_KEEP_SETTINGS) == 0 &&
+	    (drive->dev_flags & IDE_DFLAG_USING_DMA) == 0)
+		drive->mult_req = 0;
+
+	if (drive->mult_req != drive->mult_count)
+		drive->special.b.set_multmode = 1;
+}
+
+static void pre_reset(ide_drive_t *drive)
+{
+	const struct ide_port_ops *port_ops = drive->hwif->port_ops;
+
+	if (drive->media == ide_disk)
+		ide_disk_pre_reset(drive);
+	else
+		drive->dev_flags |= IDE_DFLAG_POST_RESET;
+
+	if (drive->dev_flags & IDE_DFLAG_USING_DMA) {
+		if (drive->crc_count)
+			ide_check_dma_crc(drive);
+		else
+			ide_dma_off(drive);
+	}
+
+	if ((drive->dev_flags & IDE_DFLAG_KEEP_SETTINGS) == 0) {
+		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0) {
+			drive->dev_flags &= ~IDE_DFLAG_UNMASK;
+			drive->io_32bit = 0;
+		}
+		return;
+	}
+
+	if (port_ops && port_ops->pre_reset)
+		port_ops->pre_reset(drive);
+
+	if (drive->current_speed != 0xff)
+		drive->desired_speed = drive->current_speed;
+	drive->current_speed = 0xff;
+}
+
+/*
+ * do_reset1() attempts to recover a confused drive by resetting it.
+ * Unfortunately, resetting a disk drive actually resets all devices on
+ * the same interface, so it can really be thought of as resetting the
+ * interface rather than resetting the drive.
+ *
+ * ATAPI devices have their own reset mechanism which allows them to be
+ * individually reset without clobbering other devices on the same interface.
+ *
+ * Unfortunately, the IDE interface does not generate an interrupt to let
+ * us know when the reset operation has finished, so we must poll for this.
+ * Equally poor, though, is the fact that this may a very long time to complete,
+ * (up to 30 seconds worstcase).  So, instead of busy-waiting here for it,
+ * we set a timer to poll at 50ms intervals.
+ */
+static ide_startstop_t do_reset1(ide_drive_t *drive, int do_not_try_atapi)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
+	const struct ide_port_ops *port_ops;
+	ide_drive_t *tdrive;
+	unsigned long flags, timeout;
+	int i;
+	DEFINE_WAIT(wait);
+
+	spin_lock_irqsave(&hwif->lock, flags);
+
+	/* We must not reset with running handlers */
+	BUG_ON(hwif->handler != NULL);
+
+	/* For an ATAPI device, first try an ATAPI SRST. */
+	if (drive->media != ide_disk && !do_not_try_atapi) {
+		pre_reset(drive);
+		SELECT_DRIVE(drive);
+		udelay(20);
+		tp_ops->exec_command(hwif, ATA_CMD_DEV_RESET);
+		ndelay(400);
+		hwif->poll_timeout = jiffies + WAIT_WORSTCASE;
+		hwif->polling = 1;
+		__ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20, NULL);
+		spin_unlock_irqrestore(&hwif->lock, flags);
+		return ide_started;
+	}
+
+	/* We must not disturb devices in the IDE_DFLAG_PARKED state. */
+	do {
+		unsigned long now;
+
+		prepare_to_wait(&ide_park_wq, &wait, TASK_UNINTERRUPTIBLE);
+		timeout = jiffies;
+		ide_port_for_each_present_dev(i, tdrive, hwif) {
+			if ((tdrive->dev_flags & IDE_DFLAG_PARKED) &&
+			    time_after(tdrive->sleep, timeout))
+				timeout = tdrive->sleep;
+		}
+
+		now = jiffies;
+		if (time_before_eq(timeout, now))
+			break;
+
+		spin_unlock_irqrestore(&hwif->lock, flags);
+		timeout = schedule_timeout_uninterruptible(timeout - now);
+		spin_lock_irqsave(&hwif->lock, flags);
+	} while (timeout);
+	finish_wait(&ide_park_wq, &wait);
+
+	/*
+	 * First, reset any device state data we were maintaining
+	 * for any of the drives on this interface.
+	 */
+	ide_port_for_each_dev(i, tdrive, hwif)
+		pre_reset(tdrive);
+
+	if (io_ports->ctl_addr == 0) {
+		spin_unlock_irqrestore(&hwif->lock, flags);
+		ide_complete_drive_reset(drive, -ENXIO);
+		return ide_stopped;
+	}
+
+	/*
+	 * Note that we also set nIEN while resetting the device,
+	 * to mask unwanted interrupts from the interface during the reset.
+	 * However, due to the design of PC hardware, this will cause an
+	 * immediate interrupt due to the edge transition it produces.
+	 * This single interrupt gives us a "fast poll" for drives that
+	 * recover from reset very quickly, saving us the first 50ms wait time.
+	 *
+	 * TODO: add ->softreset method and stop abusing ->set_irq
+	 */
+	/* set SRST and nIEN */
+	tp_ops->set_irq(hwif, 4);
+	/* more than enough time */
+	udelay(10);
+	/* clear SRST, leave nIEN (unless device is on the quirk list) */
+	tp_ops->set_irq(hwif, drive->quirk_list == 2);
+	/* more than enough time */
+	udelay(10);
+	hwif->poll_timeout = jiffies + WAIT_WORSTCASE;
+	hwif->polling = 1;
+	__ide_set_handler(drive, &reset_pollfunc, HZ/20, NULL);
+
+	/*
+	 * Some weird controller like resetting themselves to a strange
+	 * state when the disks are reset this way. At least, the Winbond
+	 * 553 documentation says that
+	 */
+	port_ops = hwif->port_ops;
+	if (port_ops && port_ops->resetproc)
+		port_ops->resetproc(drive);
+
+	spin_unlock_irqrestore(&hwif->lock, flags);
+	return ide_started;
+}
+
+/*
+ * ide_do_reset() is the entry point to the drive/interface reset code.
+ */
+
+ide_startstop_t ide_do_reset(ide_drive_t *drive)
+{
+	return do_reset1(drive, 0);
+}
+EXPORT_SYMBOL(ide_do_reset);
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -196,7 +196,7 @@ void ide_end_drive_cmd (ide_drive_t *dri
 }
 EXPORT_SYMBOL(ide_end_drive_cmd);
 
-static void ide_kill_rq(ide_drive_t *drive, struct request *rq)
+void ide_kill_rq(ide_drive_t *drive, struct request *rq)
 {
 	if (rq->rq_disk) {
 		struct ide_driver *drv;
@@ -207,133 +207,6 @@ static void ide_kill_rq(ide_drive_t *dri
 		ide_end_request(drive, 0, 0);
 }
 
-static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	if ((stat & ATA_BUSY) ||
-	    ((stat & ATA_DF) && (drive->dev_flags & IDE_DFLAG_NOWERR) == 0)) {
-		/* other bits are useless when BUSY */
-		rq->errors |= ERROR_RESET;
-	} else if (stat & ATA_ERR) {
-		/* err has different meaning on cdrom and tape */
-		if (err == ATA_ABORTED) {
-			if ((drive->dev_flags & IDE_DFLAG_LBA) &&
-			    /* some newer drives don't support ATA_CMD_INIT_DEV_PARAMS */
-			    hwif->tp_ops->read_status(hwif) == ATA_CMD_INIT_DEV_PARAMS)
-				return ide_stopped;
-		} else if ((err & BAD_CRC) == BAD_CRC) {
-			/* UDMA crc error, just retry the operation */
-			drive->crc_count++;
-		} else if (err & (ATA_BBK | ATA_UNC)) {
-			/* retries won't help these */
-			rq->errors = ERROR_MAX;
-		} else if (err & ATA_TRK0NF) {
-			/* help it find track zero */
-			rq->errors |= ERROR_RECAL;
-		}
-	}
-
-	if ((stat & ATA_DRQ) && rq_data_dir(rq) == READ &&
-	    (hwif->host_flags & IDE_HFLAG_ERROR_STOPS_FIFO) == 0) {
-		int nsect = drive->mult_count ? drive->mult_count : 1;
-
-		ide_pad_transfer(drive, READ, nsect * SECTOR_SIZE);
-	}
-
-	if (rq->errors >= ERROR_MAX || blk_noretry_request(rq)) {
-		ide_kill_rq(drive, rq);
-		return ide_stopped;
-	}
-
-	if (hwif->tp_ops->read_status(hwif) & (ATA_BUSY | ATA_DRQ))
-		rq->errors |= ERROR_RESET;
-
-	if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
-		++rq->errors;
-		return ide_do_reset(drive);
-	}
-
-	if ((rq->errors & ERROR_RECAL) == ERROR_RECAL)
-		drive->special.b.recalibrate = 1;
-
-	++rq->errors;
-
-	return ide_stopped;
-}
-
-static ide_startstop_t ide_atapi_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	if ((stat & ATA_BUSY) ||
-	    ((stat & ATA_DF) && (drive->dev_flags & IDE_DFLAG_NOWERR) == 0)) {
-		/* other bits are useless when BUSY */
-		rq->errors |= ERROR_RESET;
-	} else {
-		/* add decoding error stuff */
-	}
-
-	if (hwif->tp_ops->read_status(hwif) & (ATA_BUSY | ATA_DRQ))
-		/* force an abort */
-		hwif->tp_ops->exec_command(hwif, ATA_CMD_IDLEIMMEDIATE);
-
-	if (rq->errors >= ERROR_MAX) {
-		ide_kill_rq(drive, rq);
-	} else {
-		if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
-			++rq->errors;
-			return ide_do_reset(drive);
-		}
-		++rq->errors;
-	}
-
-	return ide_stopped;
-}
-
-static ide_startstop_t
-__ide_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
-{
-	if (drive->media == ide_disk)
-		return ide_ata_error(drive, rq, stat, err);
-	return ide_atapi_error(drive, rq, stat, err);
-}
-
-/**
- *	ide_error	-	handle an error on the IDE
- *	@drive: drive the error occurred on
- *	@msg: message to report
- *	@stat: status bits
- *
- *	ide_error() takes action based on the error returned by the drive.
- *	For normal I/O that may well include retries. We deal with
- *	both new-style (taskfile) and old style command handling here.
- *	In the case of taskfile command handling there is work left to
- *	do
- */
- 
-ide_startstop_t ide_error (ide_drive_t *drive, const char *msg, u8 stat)
-{
-	struct request *rq;
-	u8 err;
-
-	err = ide_dump_status(drive, msg, stat);
-
-	rq = drive->hwif->rq;
-	if (rq == NULL)
-		return ide_stopped;
-
-	/* retry only "normal" I/O: */
-	if (!blk_fs_request(rq)) {
-		rq->errors = 1;
-		ide_end_drive_cmd(drive, stat, err);
-		return ide_stopped;
-	}
-
-	return __ide_error(drive, rq, stat, err);
-}
-EXPORT_SYMBOL_GPL(ide_error);
-
 static void ide_tf_set_specify_cmd(ide_drive_t *drive, struct ide_taskfile *tf)
 {
 	tf->nsect   = drive->sect;
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -446,8 +446,8 @@ int ide_config_drive_speed(ide_drive_t *
  *
  * See also ide_execute_command
  */
-static void __ide_set_handler (ide_drive_t *drive, ide_handler_t *handler,
-		      unsigned int timeout, ide_expiry_t *expiry)
+void __ide_set_handler(ide_drive_t *drive, ide_handler_t *handler,
+		       unsigned int timeout, ide_expiry_t *expiry)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
@@ -517,301 +517,6 @@ void ide_execute_pkt_cmd(ide_drive_t *dr
 }
 EXPORT_SYMBOL_GPL(ide_execute_pkt_cmd);
 
-static inline void ide_complete_drive_reset(ide_drive_t *drive, int err)
-{
-	struct request *rq = drive->hwif->rq;
-
-	if (rq && blk_special_request(rq) && rq->cmd[0] == REQ_DRIVE_RESET)
-		ide_end_request(drive, err ? err : 1, 0);
-}
-
-/* needed below */
-static ide_startstop_t do_reset1(ide_drive_t *, int);
-
-/*
- * atapi_reset_pollfunc() gets invoked to poll the interface for completion
- * every 50ms during an atapi drive reset operation.  If the drive has not yet
- * responded, and we have not yet hit our maximum waiting time, then the timer
- * is restarted for another 50ms.
- */
-static ide_startstop_t atapi_reset_pollfunc(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	u8 stat;
-
-	SELECT_DRIVE(drive);
-	udelay(10);
-	stat = hwif->tp_ops->read_status(hwif);
-
-	if (OK_STAT(stat, 0, ATA_BUSY))
-		printk(KERN_INFO "%s: ATAPI reset complete\n", drive->name);
-	else {
-		if (time_before(jiffies, hwif->poll_timeout)) {
-			ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20,
-					NULL);
-			/* continue polling */
-			return ide_started;
-		}
-		/* end of polling */
-		hwif->polling = 0;
-		printk(KERN_ERR "%s: ATAPI reset timed-out, status=0x%02x\n",
-			drive->name, stat);
-		/* do it the old fashioned way */
-		return do_reset1(drive, 1);
-	}
-	/* done polling */
-	hwif->polling = 0;
-	ide_complete_drive_reset(drive, 0);
-	return ide_stopped;
-}
-
-static void ide_reset_report_error(ide_hwif_t *hwif, u8 err)
-{
-	static const char *err_master_vals[] =
-		{ NULL, "passed", "formatter device error",
-		  "sector buffer error", "ECC circuitry error",
-		  "controlling MPU error" };
-
-	u8 err_master = err & 0x7f;
-
-	printk(KERN_ERR "%s: reset: master: ", hwif->name);
-	if (err_master && err_master < 6)
-		printk(KERN_CONT "%s", err_master_vals[err_master]);
-	else
-		printk(KERN_CONT "error (0x%02x?)", err);
-	if (err & 0x80)
-		printk(KERN_CONT "; slave: failed");
-	printk(KERN_CONT "\n");
-}
-
-/*
- * reset_pollfunc() gets invoked to poll the interface for completion every 50ms
- * during an ide reset operation. If the drives have not yet responded,
- * and we have not yet hit our maximum waiting time, then the timer is restarted
- * for another 50ms.
- */
-static ide_startstop_t reset_pollfunc(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_port_ops *port_ops = hwif->port_ops;
-	u8 tmp;
-	int err = 0;
-
-	if (port_ops && port_ops->reset_poll) {
-		err = port_ops->reset_poll(drive);
-		if (err) {
-			printk(KERN_ERR "%s: host reset_poll failure for %s.\n",
-				hwif->name, drive->name);
-			goto out;
-		}
-	}
-
-	tmp = hwif->tp_ops->read_status(hwif);
-
-	if (!OK_STAT(tmp, 0, ATA_BUSY)) {
-		if (time_before(jiffies, hwif->poll_timeout)) {
-			ide_set_handler(drive, &reset_pollfunc, HZ/20, NULL);
-			/* continue polling */
-			return ide_started;
-		}
-		printk(KERN_ERR "%s: reset timed-out, status=0x%02x\n",
-			hwif->name, tmp);
-		drive->failures++;
-		err = -EIO;
-	} else  {
-		tmp = ide_read_error(drive);
-
-		if (tmp == 1) {
-			printk(KERN_INFO "%s: reset: success\n", hwif->name);
-			drive->failures = 0;
-		} else {
-			ide_reset_report_error(hwif, tmp);
-			drive->failures++;
-			err = -EIO;
-		}
-	}
-out:
-	hwif->polling = 0;	/* done polling */
-	ide_complete_drive_reset(drive, err);
-	return ide_stopped;
-}
-
-static void ide_disk_pre_reset(ide_drive_t *drive)
-{
-	int legacy = (drive->id[ATA_ID_CFS_ENABLE_2] & 0x0400) ? 0 : 1;
-
-	drive->special.all = 0;
-	drive->special.b.set_geometry = legacy;
-	drive->special.b.recalibrate  = legacy;
-
-	drive->mult_count = 0;
-	drive->dev_flags &= ~IDE_DFLAG_PARKED;
-
-	if ((drive->dev_flags & IDE_DFLAG_KEEP_SETTINGS) == 0 &&
-	    (drive->dev_flags & IDE_DFLAG_USING_DMA) == 0)
-		drive->mult_req = 0;
-
-	if (drive->mult_req != drive->mult_count)
-		drive->special.b.set_multmode = 1;
-}
-
-static void pre_reset(ide_drive_t *drive)
-{
-	const struct ide_port_ops *port_ops = drive->hwif->port_ops;
-
-	if (drive->media == ide_disk)
-		ide_disk_pre_reset(drive);
-	else
-		drive->dev_flags |= IDE_DFLAG_POST_RESET;
-
-	if (drive->dev_flags & IDE_DFLAG_USING_DMA) {
-		if (drive->crc_count)
-			ide_check_dma_crc(drive);
-		else
-			ide_dma_off(drive);
-	}
-
-	if ((drive->dev_flags & IDE_DFLAG_KEEP_SETTINGS) == 0) {
-		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0) {
-			drive->dev_flags &= ~IDE_DFLAG_UNMASK;
-			drive->io_32bit = 0;
-		}
-		return;
-	}
-
-	if (port_ops && port_ops->pre_reset)
-		port_ops->pre_reset(drive);
-
-	if (drive->current_speed != 0xff)
-		drive->desired_speed = drive->current_speed;
-	drive->current_speed = 0xff;
-}
-
-/*
- * do_reset1() attempts to recover a confused drive by resetting it.
- * Unfortunately, resetting a disk drive actually resets all devices on
- * the same interface, so it can really be thought of as resetting the
- * interface rather than resetting the drive.
- *
- * ATAPI devices have their own reset mechanism which allows them to be
- * individually reset without clobbering other devices on the same interface.
- *
- * Unfortunately, the IDE interface does not generate an interrupt to let
- * us know when the reset operation has finished, so we must poll for this.
- * Equally poor, though, is the fact that this may a very long time to complete,
- * (up to 30 seconds worstcase).  So, instead of busy-waiting here for it,
- * we set a timer to poll at 50ms intervals.
- */
-static ide_startstop_t do_reset1(ide_drive_t *drive, int do_not_try_atapi)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
-	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
-	const struct ide_port_ops *port_ops;
-	ide_drive_t *tdrive;
-	unsigned long flags, timeout;
-	int i;
-	DEFINE_WAIT(wait);
-
-	spin_lock_irqsave(&hwif->lock, flags);
-
-	/* We must not reset with running handlers */
-	BUG_ON(hwif->handler != NULL);
-
-	/* For an ATAPI device, first try an ATAPI SRST. */
-	if (drive->media != ide_disk && !do_not_try_atapi) {
-		pre_reset(drive);
-		SELECT_DRIVE(drive);
-		udelay(20);
-		tp_ops->exec_command(hwif, ATA_CMD_DEV_RESET);
-		ndelay(400);
-		hwif->poll_timeout = jiffies + WAIT_WORSTCASE;
-		hwif->polling = 1;
-		__ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20, NULL);
-		spin_unlock_irqrestore(&hwif->lock, flags);
-		return ide_started;
-	}
-
-	/* We must not disturb devices in the IDE_DFLAG_PARKED state. */
-	do {
-		unsigned long now;
-
-		prepare_to_wait(&ide_park_wq, &wait, TASK_UNINTERRUPTIBLE);
-		timeout = jiffies;
-		ide_port_for_each_present_dev(i, tdrive, hwif) {
-			if ((tdrive->dev_flags & IDE_DFLAG_PARKED) &&
-			    time_after(tdrive->sleep, timeout))
-				timeout = tdrive->sleep;
-		}
-
-		now = jiffies;
-		if (time_before_eq(timeout, now))
-			break;
-
-		spin_unlock_irqrestore(&hwif->lock, flags);
-		timeout = schedule_timeout_uninterruptible(timeout - now);
-		spin_lock_irqsave(&hwif->lock, flags);
-	} while (timeout);
-	finish_wait(&ide_park_wq, &wait);
-
-	/*
-	 * First, reset any device state data we were maintaining
-	 * for any of the drives on this interface.
-	 */
-	ide_port_for_each_dev(i, tdrive, hwif)
-		pre_reset(tdrive);
-
-	if (io_ports->ctl_addr == 0) {
-		spin_unlock_irqrestore(&hwif->lock, flags);
-		ide_complete_drive_reset(drive, -ENXIO);
-		return ide_stopped;
-	}
-
-	/*
-	 * Note that we also set nIEN while resetting the device,
-	 * to mask unwanted interrupts from the interface during the reset.
-	 * However, due to the design of PC hardware, this will cause an
-	 * immediate interrupt due to the edge transition it produces.
-	 * This single interrupt gives us a "fast poll" for drives that
-	 * recover from reset very quickly, saving us the first 50ms wait time.
-	 *
-	 * TODO: add ->softreset method and stop abusing ->set_irq
-	 */
-	/* set SRST and nIEN */
-	tp_ops->set_irq(hwif, 4);
-	/* more than enough time */
-	udelay(10);
-	/* clear SRST, leave nIEN (unless device is on the quirk list) */
-	tp_ops->set_irq(hwif, drive->quirk_list == 2);
-	/* more than enough time */
-	udelay(10);
-	hwif->poll_timeout = jiffies + WAIT_WORSTCASE;
-	hwif->polling = 1;
-	__ide_set_handler(drive, &reset_pollfunc, HZ/20, NULL);
-
-	/*
-	 * Some weird controller like resetting themselves to a strange
-	 * state when the disks are reset this way. At least, the Winbond
-	 * 553 documentation says that
-	 */
-	port_ops = hwif->port_ops;
-	if (port_ops && port_ops->resetproc)
-		port_ops->resetproc(drive);
-
-	spin_unlock_irqrestore(&hwif->lock, flags);
-	return ide_started;
-}
-
-/*
- * ide_do_reset() is the entry point to the drive/interface reset code.
- */
-
-ide_startstop_t ide_do_reset(ide_drive_t *drive)
-{
-	return do_reset1(drive, 0);
-}
-EXPORT_SYMBOL(ide_do_reset);
-
 /*
  * ide_wait_not_busy() waits for the currently selected device on the hwif
  * to report a non-busy status, see comments in ide_probe_port().
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1144,11 +1144,14 @@ int generic_ide_ioctl(ide_drive_t *, str
 extern int ide_vlb_clk;
 extern int ide_pci_clk;
 
-extern int ide_end_request (ide_drive_t *drive, int uptodate, int nrsecs);
-int ide_end_dequeued_request(ide_drive_t *drive, struct request *rq,
-			     int uptodate, int nr_sectors);
-
-extern void ide_set_handler (ide_drive_t *drive, ide_handler_t *handler, unsigned int timeout, ide_expiry_t *expiry);
+int ide_end_request(ide_drive_t *, int, int);
+int ide_end_dequeued_request(ide_drive_t *, struct request *, int, int);
+void ide_kill_rq(ide_drive_t *, struct request *);
+
+void __ide_set_handler(ide_drive_t *, ide_handler_t *, unsigned int,
+		       ide_expiry_t *);
+void ide_set_handler(ide_drive_t *, ide_handler_t *, unsigned int,
+		     ide_expiry_t *);
 
 void ide_execute_command(ide_drive_t *, u8, ide_handler_t *, unsigned int,
 			 ide_expiry_t *);
