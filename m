Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbYHQT4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbYHQT4g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbYHQT4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:56:06 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:50284 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbYHQT4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:56:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=lLlVdya4Y/sYnSBaHQGVwsRckByUDRdD2TIdOvm/V09k89Ipk0+XyB+dztA8iK5anH
         9LTkRZzKQChLIPe24OYnz8qH42FnoZk8p4GU/+UBfNu2NADlHs9egsDTnBI6/ev/zSIs
         hQ/LHcYD3G8PS4ZisV8CxkTya+9o+yE79I2lY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 17 Aug 2008 21:53:43 +0200
Message-Id: <20080817195343.13393.84173.sendpatchset@localhost.localdomain>
In-Reply-To: <20080817195336.13393.86030.sendpatchset@localhost.localdomain>
References: <20080817195336.13393.86030.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/9] ide: sanitize ide*_pm_* enums
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Move ide*_pm_* enums from ide-io.c to <linux/ide.h>.

* idedisk_pm_* -> ide_pm_*

* ide_pm_state_* -> ide_pm_*

* No need to set ide_pm_* enums to the fixed values.

* Uppercase ide_pm_* enums.

* Fix/update comments.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c |   62 ++++++++++++++++++---------------------------------
 drivers/ide/ide.c    |    4 +--
 include/linux/ide.h  |   34 +++++++++++++--------------
 3 files changed, 40 insertions(+), 60 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -132,21 +132,6 @@ int ide_end_request (ide_drive_t *drive,
 }
 EXPORT_SYMBOL(ide_end_request);
 
-/*
- * Power Management state machine. This one is rather trivial for now,
- * we should probably add more, like switching back to PIO on suspend
- * to help some BIOSes, re-do the door locking on resume, etc...
- */
-
-enum {
-	ide_pm_flush_cache	= ide_pm_state_start_suspend,
-	idedisk_pm_standby,
-
-	idedisk_pm_restore_pio	= ide_pm_state_start_resume,
-	idedisk_pm_idle,
-	ide_pm_restore_dma,
-};
-
 static void ide_complete_power_step(ide_drive_t *drive, struct request *rq, u8 stat, u8 error)
 {
 	struct request_pm_state *pm = rq->data;
@@ -155,20 +140,20 @@ static void ide_complete_power_step(ide_
 		return;
 
 	switch (pm->pm_step) {
-	case ide_pm_flush_cache:	/* Suspend step 1 (flush cache) complete */
+	case IDE_PM_FLUSH_CACHE:	/* Suspend step 1 (flush cache) */
 		if (pm->pm_state == PM_EVENT_FREEZE)
-			pm->pm_step = ide_pm_state_completed;
+			pm->pm_step = IDE_PM_COMPLETED;
 		else
-			pm->pm_step = idedisk_pm_standby;
+			pm->pm_step = IDE_PM_STANDBY;
 		break;
-	case idedisk_pm_standby:	/* Suspend step 2 (standby) complete */
-		pm->pm_step = ide_pm_state_completed;
+	case IDE_PM_STANDBY:		/* Suspend step 2 (standby) */
+		pm->pm_step = IDE_PM_COMPLETED;
 		break;
-	case idedisk_pm_restore_pio:	/* Resume step 1 complete */
-		pm->pm_step = idedisk_pm_idle;
+	case IDE_PM_RESTORE_PIO:	/* Resume step 1 (restore PIO) */
+		pm->pm_step = IDE_PM_IDLE;
 		break;
-	case idedisk_pm_idle:		/* Resume step 2 (idle) complete */
-		pm->pm_step = ide_pm_restore_dma;
+	case IDE_PM_IDLE:		/* Resume step 2 (idle)*/
+		pm->pm_step = IDE_PM_RESTORE_DMA;
 		break;
 	}
 }
@@ -181,7 +166,7 @@ static ide_startstop_t ide_start_power_s
 	memset(args, 0, sizeof(*args));
 
 	switch (pm->pm_step) {
-	case ide_pm_flush_cache:	/* Suspend step 1 (flush cache) */
+	case IDE_PM_FLUSH_CACHE:	/* Suspend step 1 (flush cache) */
 		if (drive->media != ide_disk)
 			break;
 		/* Not supported? Switch to next step now. */
@@ -195,27 +180,23 @@ static ide_startstop_t ide_start_power_s
 		else
 			args->tf.command = ATA_CMD_FLUSH;
 		goto out_do_tf;
-
-	case idedisk_pm_standby:	/* Suspend step 2 (standby) */
+	case IDE_PM_STANDBY:		/* Suspend step 2 (standby) */
 		args->tf.command = ATA_CMD_STANDBYNOW1;
 		goto out_do_tf;
-
-	case idedisk_pm_restore_pio:	/* Resume step 1 (restore PIO) */
+	case IDE_PM_RESTORE_PIO:	/* Resume step 1 (restore PIO) */
 		ide_set_max_pio(drive);
 		/*
-		 * skip idedisk_pm_idle for ATAPI devices
+		 * skip IDE_PM_IDLE for ATAPI devices
 		 */
 		if (drive->media != ide_disk)
-			pm->pm_step = ide_pm_restore_dma;
+			pm->pm_step = IDE_PM_RESTORE_DMA;
 		else
 			ide_complete_power_step(drive, rq, 0, 0);
 		return ide_stopped;
-
-	case idedisk_pm_idle:		/* Resume step 2 (idle) */
+	case IDE_PM_IDLE:		/* Resume step 2 (idle) */
 		args->tf.command = ATA_CMD_IDLEIMMEDIATE;
 		goto out_do_tf;
-
-	case ide_pm_restore_dma:	/* Resume step 3 (restore DMA) */
+	case IDE_PM_RESTORE_DMA:	/* Resume step 3 (restore DMA) */
 		/*
 		 * Right now, all we do is call ide_set_dma(drive),
 		 * we could be smarter and check for current xfer_speed
@@ -229,7 +210,8 @@ static ide_startstop_t ide_start_power_s
 		ide_set_dma(drive);
 		break;
 	}
-	pm->pm_step = ide_pm_state_completed;
+
+	pm->pm_step = IDE_PM_COMPLETED;
 	return ide_stopped;
 
 out_do_tf:
@@ -345,7 +327,7 @@ void ide_end_drive_cmd (ide_drive_t *dri
 			drive->name, rq->pm->pm_step, stat, err);
 #endif
 		ide_complete_power_step(drive, rq, stat, err);
-		if (pm->pm_step == ide_pm_state_completed)
+		if (pm->pm_step == IDE_PM_COMPLETED)
 			ide_complete_pm_request(drive, rq);
 		return;
 	}
@@ -778,11 +760,11 @@ static void ide_check_pm_state(ide_drive
 	struct request_pm_state *pm = rq->data;
 
 	if (blk_pm_suspend_request(rq) &&
-	    pm->pm_step == ide_pm_state_start_suspend)
+	    pm->pm_step == IDE_PM_START_SUSPEND)
 		/* Mark drive blocked when starting the suspend sequence. */
 		drive->dev_flags |= IDE_DFLAG_BLOCKED;
 	else if (blk_pm_resume_request(rq) &&
-		 pm->pm_step == ide_pm_state_start_resume) {
+		 pm->pm_step == IDE_PM_START_RESUME) {
 		/* 
 		 * The first thing we do on wakeup is to wait for BSY bit to
 		 * go away (with a looong timeout) as a drive on this hwif may
@@ -862,7 +844,7 @@ static ide_startstop_t start_request (id
 #endif
 			startstop = ide_start_power_step(drive, rq);
 			if (startstop == ide_stopped &&
-			    pm->pm_step == ide_pm_state_completed)
+			    pm->pm_step == IDE_PM_COMPLETED)
 				ide_complete_pm_request(drive, rq);
 			return startstop;
 		} else if (!rq->rq_disk && blk_special_request(rq))
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -388,7 +388,7 @@ static int generic_ide_suspend(struct de
 	rq->cmd_type = REQ_TYPE_PM_SUSPEND;
 	rq->special = &args;
 	rq->data = &rqpm;
-	rqpm.pm_step = ide_pm_state_start_suspend;
+	rqpm.pm_step = IDE_PM_START_SUSPEND;
 	if (mesg.event == PM_EVENT_PRETHAW)
 		mesg.event = PM_EVENT_FREEZE;
 	rqpm.pm_state = mesg.event;
@@ -427,7 +427,7 @@ static int generic_ide_resume(struct dev
 	rq->cmd_flags |= REQ_PREEMPT;
 	rq->special = &args;
 	rq->data = &rqpm;
-	rqpm.pm_step = ide_pm_state_start_resume;
+	rqpm.pm_step = IDE_PM_START_RESUME;
 	rqpm.pm_state = PM_EVENT_ON;
 
 	err = blk_execute_rq(drive->queue, NULL, rq, 1);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -957,36 +957,34 @@ static inline void ide_proc_unregister_d
 #endif
 
 /*
- * Power Management step value (rq->pm->pm_step).
+ * Power Management state machine (rq->pm->pm_step).
  *
- * The step value starts at 0 (ide_pm_state_start_suspend) for a
- * suspend operation or 1000 (ide_pm_state_start_resume) for a
- * resume operation.
- *
- * For each step, the core calls the subdriver start_power_step() first.
+ * For each step, the core calls ide_start_power_step() first.
  * This can return:
  *	- ide_stopped :	In this case, the core calls us back again unless
  *			step have been set to ide_power_state_completed.
  *	- ide_started :	In this case, the channel is left busy until an
  *			async event (interrupt) occurs.
- * Typically, start_power_step() will issue a taskfile request with
+ * Typically, ide_start_power_step() will issue a taskfile request with
  * do_rw_taskfile().
  *
- * Upon reception of the interrupt, the core will call complete_power_step()
+ * Upon reception of the interrupt, the core will call ide_complete_power_step()
  * with the error code if any. This routine should update the step value
  * and return. It should not start a new request. The core will call
- * start_power_step for the new step value, unless step have been set to
- * ide_power_state_completed.
- *
- * Subdrivers are expected to define their own additional power
- * steps from 1..999 for suspend and from 1001..1999 for resume,
- * other values are reserved for future use.
+ * ide_start_power_step() for the new step value, unless step have been
+ * set to IDE_PM_COMPLETED.
  */
-
 enum {
-	ide_pm_state_completed		= -1,
-	ide_pm_state_start_suspend	= 0,
-	ide_pm_state_start_resume	= 1000,
+	IDE_PM_START_SUSPEND,
+	IDE_PM_FLUSH_CACHE	= IDE_PM_START_SUSPEND,
+	IDE_PM_STANDBY,
+
+	IDE_PM_START_RESUME,
+	IDE_PM_RESTORE_PIO	= IDE_PM_START_RESUME,
+	IDE_PM_IDLE,
+	IDE_PM_RESTORE_DMA,
+
+	IDE_PM_COMPLETED,
 };
 
 /*
