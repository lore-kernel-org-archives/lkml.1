Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbYKIQ1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbYKIQ1t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 11:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbYKIQZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 11:25:14 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:40170 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbYKIQZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 11:25:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=aQDLja4YOVaj0/FcDiN1cjxrbd9BpFiepWbB/oZgbgitnHnxzqujlwjD7a6d1h70G9
         iT6Y707OC0x3tZ59cG9tVGPV0i8bLEDWW7brcaMW6pHPaxNz1pgUOEs1XFKuncnkcKW9
         177Cxc+3zFL2ZloOZpp7d66+qaMG5aRq3UYG8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 09 Nov 2008 17:23:09 +0100
Message-Id: <20081109162309.18999.22607.sendpatchset@localhost.localdomain>
In-Reply-To: <20081109162219.18999.74912.sendpatchset@localhost.localdomain>
References: <20081109162219.18999.74912.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/11] ide: move Power Management support to ide-pm.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: move Power Management support to ide-pm.c

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Makefile |    2 
 drivers/ide/ide-io.c |  157 ----------------------------------
 drivers/ide/ide-pm.c |  233 +++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ide/ide.c    |   74 ----------------
 include/linux/ide.h  |    8 +
 5 files changed, 242 insertions(+), 232 deletions(-)

Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -5,7 +5,7 @@
 EXTRA_CFLAGS				+= -Idrivers/ide
 
 ide-core-y += ide.o ide-ioctls.o ide-io.o ide-iops.o ide-lib.o ide-probe.o \
-	      ide-taskfile.o ide-park.o ide-pio-blacklist.o
+	      ide-taskfile.o ide-pm.o ide-park.o ide-pio-blacklist.o
 
 # core IDE code
 ide-core-$(CONFIG_IDE_TIMINGS)		+= ide-timings.o
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -120,96 +120,6 @@ int ide_end_request (ide_drive_t *drive,
 }
 EXPORT_SYMBOL(ide_end_request);
 
-static void ide_complete_power_step(ide_drive_t *drive, struct request *rq)
-{
-	struct request_pm_state *pm = rq->data;
-
-#ifdef DEBUG_PM
-	printk(KERN_INFO "%s: complete_power_step(step: %d)\n",
-		drive->name, pm->pm_step);
-#endif
-	if (drive->media != ide_disk)
-		return;
-
-	switch (pm->pm_step) {
-	case IDE_PM_FLUSH_CACHE:	/* Suspend step 1 (flush cache) */
-		if (pm->pm_state == PM_EVENT_FREEZE)
-			pm->pm_step = IDE_PM_COMPLETED;
-		else
-			pm->pm_step = IDE_PM_STANDBY;
-		break;
-	case IDE_PM_STANDBY:		/* Suspend step 2 (standby) */
-		pm->pm_step = IDE_PM_COMPLETED;
-		break;
-	case IDE_PM_RESTORE_PIO:	/* Resume step 1 (restore PIO) */
-		pm->pm_step = IDE_PM_IDLE;
-		break;
-	case IDE_PM_IDLE:		/* Resume step 2 (idle)*/
-		pm->pm_step = IDE_PM_RESTORE_DMA;
-		break;
-	}
-}
-
-static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *rq)
-{
-	struct request_pm_state *pm = rq->data;
-	ide_task_t *args = rq->special;
-
-	memset(args, 0, sizeof(*args));
-
-	switch (pm->pm_step) {
-	case IDE_PM_FLUSH_CACHE:	/* Suspend step 1 (flush cache) */
-		if (drive->media != ide_disk)
-			break;
-		/* Not supported? Switch to next step now. */
-		if (ata_id_flush_enabled(drive->id) == 0 ||
-		    (drive->dev_flags & IDE_DFLAG_WCACHE) == 0) {
-			ide_complete_power_step(drive, rq);
-			return ide_stopped;
-		}
-		if (ata_id_flush_ext_enabled(drive->id))
-			args->tf.command = ATA_CMD_FLUSH_EXT;
-		else
-			args->tf.command = ATA_CMD_FLUSH;
-		goto out_do_tf;
-	case IDE_PM_STANDBY:		/* Suspend step 2 (standby) */
-		args->tf.command = ATA_CMD_STANDBYNOW1;
-		goto out_do_tf;
-	case IDE_PM_RESTORE_PIO:	/* Resume step 1 (restore PIO) */
-		ide_set_max_pio(drive);
-		/*
-		 * skip IDE_PM_IDLE for ATAPI devices
-		 */
-		if (drive->media != ide_disk)
-			pm->pm_step = IDE_PM_RESTORE_DMA;
-		else
-			ide_complete_power_step(drive, rq);
-		return ide_stopped;
-	case IDE_PM_IDLE:		/* Resume step 2 (idle) */
-		args->tf.command = ATA_CMD_IDLEIMMEDIATE;
-		goto out_do_tf;
-	case IDE_PM_RESTORE_DMA:	/* Resume step 3 (restore DMA) */
-		/*
-		 * Right now, all we do is call ide_set_dma(drive),
-		 * we could be smarter and check for current xfer_speed
-		 * in struct drive etc...
-		 */
-		if (drive->hwif->dma_ops == NULL)
-			break;
-		if (drive->dev_flags & IDE_DFLAG_USING_DMA)
-			ide_set_dma(drive);
-		break;
-	}
-
-	pm->pm_step = IDE_PM_COMPLETED;
-	return ide_stopped;
-
-out_do_tf:
-	args->tf_flags	 = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	args->data_phase = TASKFILE_NO_DATA;
-	return do_rw_taskfile(drive, args);
-}
-
 /**
  *	ide_end_dequeued_request	-	complete an IDE I/O
  *	@drive: IDE device for the I/O
@@ -234,39 +144,6 @@ int ide_end_dequeued_request(ide_drive_t
 }
 EXPORT_SYMBOL_GPL(ide_end_dequeued_request);
 
-
-/**
- *	ide_complete_pm_request - end the current Power Management request
- *	@drive: target drive
- *	@rq: request
- *
- *	This function cleans up the current PM request and stops the queue
- *	if necessary.
- */
-static void ide_complete_pm_request (ide_drive_t *drive, struct request *rq)
-{
-	struct request_queue *q = drive->queue;
-	unsigned long flags;
-
-#ifdef DEBUG_PM
-	printk("%s: completing PM request, %s\n", drive->name,
-	       blk_pm_suspend_request(rq) ? "suspend" : "resume");
-#endif
-	spin_lock_irqsave(q->queue_lock, flags);
-	if (blk_pm_suspend_request(rq)) {
-		blk_stop_queue(q);
-	} else {
-		drive->dev_flags &= ~IDE_DFLAG_BLOCKED;
-		blk_start_queue(q);
-	}
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
-	drive->hwif->hwgroup->rq = NULL;
-
-	if (blk_end_request(rq, 0, 0))
-		BUG();
-}
-
 /**
  *	ide_end_drive_cmd	-	end an explicit drive command
  *	@drive: command 
@@ -695,40 +572,6 @@ static ide_startstop_t ide_special_rq(id
 	}
 }
 
-static void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
-{
-	struct request_pm_state *pm = rq->data;
-
-	if (blk_pm_suspend_request(rq) &&
-	    pm->pm_step == IDE_PM_START_SUSPEND)
-		/* Mark drive blocked when starting the suspend sequence. */
-		drive->dev_flags |= IDE_DFLAG_BLOCKED;
-	else if (blk_pm_resume_request(rq) &&
-		 pm->pm_step == IDE_PM_START_RESUME) {
-		/* 
-		 * The first thing we do on wakeup is to wait for BSY bit to
-		 * go away (with a looong timeout) as a drive on this hwif may
-		 * just be POSTing itself.
-		 * We do that before even selecting as the "other" device on
-		 * the bus may be broken enough to walk on our toes at this
-		 * point.
-		 */
-		ide_hwif_t *hwif = drive->hwif;
-		int rc;
-#ifdef DEBUG_PM
-		printk("%s: Wakeup request inited, waiting for !BSY...\n", drive->name);
-#endif
-		rc = ide_wait_not_busy(hwif, 35000);
-		if (rc)
-			printk(KERN_WARNING "%s: bus not ready on wakeup\n", drive->name);
-		SELECT_DRIVE(drive);
-		hwif->tp_ops->set_irq(hwif, 1);
-		rc = ide_wait_not_busy(hwif, 100000);
-		if (rc)
-			printk(KERN_WARNING "%s: drive not ready on wakeup\n", drive->name);
-	}
-}
-
 /**
  *	start_request	-	start of I/O and command issuing for IDE
  *
Index: b/drivers/ide/ide-pm.c
===================================================================
--- /dev/null
+++ b/drivers/ide/ide-pm.c
@@ -0,0 +1,233 @@
+#include <linux/kernel.h>
+#include <linux/ide.h>
+#include <linux/hdreg.h>
+
+int generic_ide_suspend(struct device *dev, pm_message_t mesg)
+{
+	ide_drive_t *drive = dev->driver_data, *pair = ide_get_pair_dev(drive);
+	ide_hwif_t *hwif = HWIF(drive);
+	struct request *rq;
+	struct request_pm_state rqpm;
+	ide_task_t args;
+	int ret;
+
+	/* call ACPI _GTM only once */
+	if ((drive->dn & 1) == 0 || pair == NULL)
+		ide_acpi_get_timing(hwif);
+
+	memset(&rqpm, 0, sizeof(rqpm));
+	memset(&args, 0, sizeof(args));
+	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq->cmd_type = REQ_TYPE_PM_SUSPEND;
+	rq->special = &args;
+	rq->data = &rqpm;
+	rqpm.pm_step = IDE_PM_START_SUSPEND;
+	if (mesg.event == PM_EVENT_PRETHAW)
+		mesg.event = PM_EVENT_FREEZE;
+	rqpm.pm_state = mesg.event;
+
+	ret = blk_execute_rq(drive->queue, NULL, rq, 0);
+	blk_put_request(rq);
+
+	/* call ACPI _PS3 only after both devices are suspended */
+	if (ret == 0 && ((drive->dn & 1) || pair == NULL))
+		ide_acpi_set_state(hwif, 0);
+
+	return ret;
+}
+
+int generic_ide_resume(struct device *dev)
+{
+	ide_drive_t *drive = dev->driver_data, *pair = ide_get_pair_dev(drive);
+	ide_hwif_t *hwif = HWIF(drive);
+	struct request *rq;
+	struct request_pm_state rqpm;
+	ide_task_t args;
+	int err;
+
+	/* call ACPI _PS0 / _STM only once */
+	if ((drive->dn & 1) == 0 || pair == NULL) {
+		ide_acpi_set_state(hwif, 1);
+		ide_acpi_push_timing(hwif);
+	}
+
+	ide_acpi_exec_tfs(drive);
+
+	memset(&rqpm, 0, sizeof(rqpm));
+	memset(&args, 0, sizeof(args));
+	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq->cmd_type = REQ_TYPE_PM_RESUME;
+	rq->cmd_flags |= REQ_PREEMPT;
+	rq->special = &args;
+	rq->data = &rqpm;
+	rqpm.pm_step = IDE_PM_START_RESUME;
+	rqpm.pm_state = PM_EVENT_ON;
+
+	err = blk_execute_rq(drive->queue, NULL, rq, 1);
+	blk_put_request(rq);
+
+	if (err == 0 && dev->driver) {
+		ide_driver_t *drv = to_ide_driver(dev->driver);
+
+		if (drv->resume)
+			drv->resume(drive);
+	}
+
+	return err;
+}
+
+void ide_complete_power_step(ide_drive_t *drive, struct request *rq)
+{
+	struct request_pm_state *pm = rq->data;
+
+#ifdef DEBUG_PM
+	printk(KERN_INFO "%s: complete_power_step(step: %d)\n",
+		drive->name, pm->pm_step);
+#endif
+	if (drive->media != ide_disk)
+		return;
+
+	switch (pm->pm_step) {
+	case IDE_PM_FLUSH_CACHE:	/* Suspend step 1 (flush cache) */
+		if (pm->pm_state == PM_EVENT_FREEZE)
+			pm->pm_step = IDE_PM_COMPLETED;
+		else
+			pm->pm_step = IDE_PM_STANDBY;
+		break;
+	case IDE_PM_STANDBY:		/* Suspend step 2 (standby) */
+		pm->pm_step = IDE_PM_COMPLETED;
+		break;
+	case IDE_PM_RESTORE_PIO:	/* Resume step 1 (restore PIO) */
+		pm->pm_step = IDE_PM_IDLE;
+		break;
+	case IDE_PM_IDLE:		/* Resume step 2 (idle)*/
+		pm->pm_step = IDE_PM_RESTORE_DMA;
+		break;
+	}
+}
+
+ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *rq)
+{
+	struct request_pm_state *pm = rq->data;
+	ide_task_t *args = rq->special;
+
+	memset(args, 0, sizeof(*args));
+
+	switch (pm->pm_step) {
+	case IDE_PM_FLUSH_CACHE:	/* Suspend step 1 (flush cache) */
+		if (drive->media != ide_disk)
+			break;
+		/* Not supported? Switch to next step now. */
+		if (ata_id_flush_enabled(drive->id) == 0 ||
+		    (drive->dev_flags & IDE_DFLAG_WCACHE) == 0) {
+			ide_complete_power_step(drive, rq);
+			return ide_stopped;
+		}
+		if (ata_id_flush_ext_enabled(drive->id))
+			args->tf.command = ATA_CMD_FLUSH_EXT;
+		else
+			args->tf.command = ATA_CMD_FLUSH;
+		goto out_do_tf;
+	case IDE_PM_STANDBY:		/* Suspend step 2 (standby) */
+		args->tf.command = ATA_CMD_STANDBYNOW1;
+		goto out_do_tf;
+	case IDE_PM_RESTORE_PIO:	/* Resume step 1 (restore PIO) */
+		ide_set_max_pio(drive);
+		/*
+		 * skip IDE_PM_IDLE for ATAPI devices
+		 */
+		if (drive->media != ide_disk)
+			pm->pm_step = IDE_PM_RESTORE_DMA;
+		else
+			ide_complete_power_step(drive, rq);
+		return ide_stopped;
+	case IDE_PM_IDLE:		/* Resume step 2 (idle) */
+		args->tf.command = ATA_CMD_IDLEIMMEDIATE;
+		goto out_do_tf;
+	case IDE_PM_RESTORE_DMA:	/* Resume step 3 (restore DMA) */
+		/*
+		 * Right now, all we do is call ide_set_dma(drive),
+		 * we could be smarter and check for current xfer_speed
+		 * in struct drive etc...
+		 */
+		if (drive->hwif->dma_ops == NULL)
+			break;
+		if (drive->dev_flags & IDE_DFLAG_USING_DMA)
+			ide_set_dma(drive);
+		break;
+	}
+
+	pm->pm_step = IDE_PM_COMPLETED;
+	return ide_stopped;
+
+out_do_tf:
+	args->tf_flags	 = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	args->data_phase = TASKFILE_NO_DATA;
+	return do_rw_taskfile(drive, args);
+}
+
+/**
+ *	ide_complete_pm_request - end the current Power Management request
+ *	@drive: target drive
+ *	@rq: request
+ *
+ *	This function cleans up the current PM request and stops the queue
+ *	if necessary.
+ */
+void ide_complete_pm_request(ide_drive_t *drive, struct request *rq)
+{
+	struct request_queue *q = drive->queue;
+	unsigned long flags;
+
+#ifdef DEBUG_PM
+	printk("%s: completing PM request, %s\n", drive->name,
+	       blk_pm_suspend_request(rq) ? "suspend" : "resume");
+#endif
+	spin_lock_irqsave(q->queue_lock, flags);
+	if (blk_pm_suspend_request(rq)) {
+		blk_stop_queue(q);
+	} else {
+		drive->dev_flags &= ~IDE_DFLAG_BLOCKED;
+		blk_start_queue(q);
+	}
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	drive->hwif->hwgroup->rq = NULL;
+
+	if (blk_end_request(rq, 0, 0))
+		BUG();
+}
+
+void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
+{
+	struct request_pm_state *pm = rq->data;
+
+	if (blk_pm_suspend_request(rq) &&
+	    pm->pm_step == IDE_PM_START_SUSPEND)
+		/* Mark drive blocked when starting the suspend sequence. */
+		drive->dev_flags |= IDE_DFLAG_BLOCKED;
+	else if (blk_pm_resume_request(rq) &&
+		 pm->pm_step == IDE_PM_START_RESUME) {
+		/*
+		 * The first thing we do on wakeup is to wait for BSY bit to
+		 * go away (with a looong timeout) as a drive on this hwif may
+		 * just be POSTing itself.
+		 * We do that before even selecting as the "other" device on
+		 * the bus may be broken enough to walk on our toes at this
+		 * point.
+		 */
+		ide_hwif_t *hwif = drive->hwif;
+		int rc;
+#ifdef DEBUG_PM
+		printk("%s: Wakeup request inited, waiting for !BSY...\n", drive->name);
+#endif
+		rc = ide_wait_not_busy(hwif, 35000);
+		if (rc)
+			printk(KERN_WARNING "%s: bus not ready on wakeup\n", drive->name);
+		SELECT_DRIVE(drive);
+		hwif->tp_ops->set_irq(hwif, 1);
+		rc = ide_wait_not_busy(hwif, 100000);
+		if (rc)
+			printk(KERN_WARNING "%s: drive not ready on wakeup\n", drive->name);
+	}
+}
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -388,80 +388,6 @@ ide_ext_devset_rw_sync(unmaskirq, unmask
 ide_ext_devset_rw_sync(using_dma, using_dma);
 __IDE_DEVSET(pio_mode, DS_SYNC, NULL, set_pio_mode);
 
-static int generic_ide_suspend(struct device *dev, pm_message_t mesg)
-{
-	ide_drive_t *drive = dev->driver_data, *pair = ide_get_pair_dev(drive);
-	ide_hwif_t *hwif = HWIF(drive);
-	struct request *rq;
-	struct request_pm_state rqpm;
-	ide_task_t args;
-	int ret;
-
-	/* call ACPI _GTM only once */
-	if ((drive->dn & 1) == 0 || pair == NULL)
-		ide_acpi_get_timing(hwif);
-
-	memset(&rqpm, 0, sizeof(rqpm));
-	memset(&args, 0, sizeof(args));
-	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
-	rq->cmd_type = REQ_TYPE_PM_SUSPEND;
-	rq->special = &args;
-	rq->data = &rqpm;
-	rqpm.pm_step = IDE_PM_START_SUSPEND;
-	if (mesg.event == PM_EVENT_PRETHAW)
-		mesg.event = PM_EVENT_FREEZE;
-	rqpm.pm_state = mesg.event;
-
-	ret = blk_execute_rq(drive->queue, NULL, rq, 0);
-	blk_put_request(rq);
-
-	/* call ACPI _PS3 only after both devices are suspended */
-	if (ret == 0 && ((drive->dn & 1) || pair == NULL))
-		ide_acpi_set_state(hwif, 0);
-
-	return ret;
-}
-
-static int generic_ide_resume(struct device *dev)
-{
-	ide_drive_t *drive = dev->driver_data, *pair = ide_get_pair_dev(drive);
-	ide_hwif_t *hwif = HWIF(drive);
-	struct request *rq;
-	struct request_pm_state rqpm;
-	ide_task_t args;
-	int err;
-
-	/* call ACPI _PS0 / _STM only once */
-	if ((drive->dn & 1) == 0 || pair == NULL) {
-		ide_acpi_set_state(hwif, 1);
-		ide_acpi_push_timing(hwif);
-	}
-
-	ide_acpi_exec_tfs(drive);
-
-	memset(&rqpm, 0, sizeof(rqpm));
-	memset(&args, 0, sizeof(args));
-	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
-	rq->cmd_type = REQ_TYPE_PM_RESUME;
-	rq->cmd_flags |= REQ_PREEMPT;
-	rq->special = &args;
-	rq->data = &rqpm;
-	rqpm.pm_step = IDE_PM_START_RESUME;
-	rqpm.pm_state = PM_EVENT_ON;
-
-	err = blk_execute_rq(drive->queue, NULL, rq, 1);
-	blk_put_request(rq);
-
-	if (err == 0 && dev->driver) {
-		ide_driver_t *drv = to_ide_driver(dev->driver);
-
-		if (drv->resume)
-			drv->resume(drive);
-	}
-
-	return err;
-}
-
 /**
  * ide_device_get	-	get an additional reference to a ide_drive_t
  * @drive:	device to get a reference to
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1109,6 +1109,14 @@ enum {
 	IDE_PM_COMPLETED,
 };
 
+int generic_ide_suspend(struct device *, pm_message_t);
+int generic_ide_resume(struct device *);
+
+void ide_complete_power_step(ide_drive_t *, struct request *);
+ide_startstop_t ide_start_power_step(ide_drive_t *, struct request *);
+void ide_complete_pm_request(ide_drive_t *, struct request *);
+void ide_check_pm_state(ide_drive_t *, struct request *);
+
 /*
  * Subdrivers support.
  *
