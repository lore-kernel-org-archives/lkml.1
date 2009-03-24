Return-Path: <linux-kernel-owner+w=401wt.eu-S1762679AbZCXQLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762679AbZCXQLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbZCXQGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:06:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:41840 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760755AbZCXQGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:06:40 -0400
From: Tejun Heo <tj@kernel.org>
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/14] ide-pm: don't abuse rq->data
Date: Wed, 25 Mar 2009 01:06:14 +0900
Message-Id: <1237910776-10983-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237910776-10983-1-git-send-email-tj@kernel.org>
References: <1237910776-10983-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 16:06:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup rq->data usage

ide-pm uses rq->data to carry pointer to struct request_pm_state
through request queue and rq->special is used to carray pointer to
local struct ide_cmd, which isn't necessary.  Use rq->special for
request_pm_state instead and use local ide_cmd in
ide_start_power_step().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/ide/ide-io.c |    2 +-
 drivers/ide/ide-pm.c |   36 ++++++++++++++----------------------
 2 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index c2e622f..9ad9bc1 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -364,7 +364,7 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 		if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
 			return execute_drive_cmd(drive, rq);
 		else if (blk_pm_request(rq)) {
-			struct request_pm_state *pm = rq->data;
+			struct request_pm_state *pm = rq->special;
 #ifdef DEBUG_PM
 			printk("%s: start_power_step(step: %d)\n",
 				drive->name, pm->pm_step);
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index bb7858e..84b8df4 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -7,7 +7,6 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq;
 	struct request_pm_state rqpm;
-	struct ide_cmd cmd;
 	int ret;
 
 	/* call ACPI _GTM only once */
@@ -15,11 +14,9 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 		ide_acpi_get_timing(hwif);
 
 	memset(&rqpm, 0, sizeof(rqpm));
-	memset(&cmd, 0, sizeof(cmd));
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_PM_SUSPEND;
-	rq->special = &cmd;
-	rq->data = &rqpm;
+	rq->special = &rqpm;
 	rqpm.pm_step = IDE_PM_START_SUSPEND;
 	if (mesg.event == PM_EVENT_PRETHAW)
 		mesg.event = PM_EVENT_FREEZE;
@@ -41,7 +38,6 @@ int generic_ide_resume(struct device *dev)
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq;
 	struct request_pm_state rqpm;
-	struct ide_cmd cmd;
 	int err;
 
 	/* call ACPI _PS0 / _STM only once */
@@ -53,12 +49,10 @@ int generic_ide_resume(struct device *dev)
 	ide_acpi_exec_tfs(drive);
 
 	memset(&rqpm, 0, sizeof(rqpm));
-	memset(&cmd, 0, sizeof(cmd));
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_PM_RESUME;
 	rq->cmd_flags |= REQ_PREEMPT;
-	rq->special = &cmd;
-	rq->data = &rqpm;
+	rq->special = &rqpm;
 	rqpm.pm_step = IDE_PM_START_RESUME;
 	rqpm.pm_state = PM_EVENT_ON;
 
@@ -77,7 +71,7 @@ int generic_ide_resume(struct device *dev)
 
 void ide_complete_power_step(ide_drive_t *drive, struct request *rq)
 {
-	struct request_pm_state *pm = rq->data;
+	struct request_pm_state *pm = rq->special;
 
 #ifdef DEBUG_PM
 	printk(KERN_INFO "%s: complete_power_step(step: %d)\n",
@@ -107,10 +101,8 @@ void ide_complete_power_step(ide_drive_t *drive, struct request *rq)
 
 ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *rq)
 {
-	struct request_pm_state *pm = rq->data;
-	struct ide_cmd *cmd = rq->special;
-
-	memset(cmd, 0, sizeof(*cmd));
+	struct request_pm_state *pm = rq->special;
+	struct ide_cmd cmd = { };
 
 	switch (pm->pm_step) {
 	case IDE_PM_FLUSH_CACHE:	/* Suspend step 1 (flush cache) */
@@ -123,12 +115,12 @@ ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *rq)
 			return ide_stopped;
 		}
 		if (ata_id_flush_ext_enabled(drive->id))
-			cmd->tf.command = ATA_CMD_FLUSH_EXT;
+			cmd.tf.command = ATA_CMD_FLUSH_EXT;
 		else
-			cmd->tf.command = ATA_CMD_FLUSH;
+			cmd.tf.command = ATA_CMD_FLUSH;
 		goto out_do_tf;
 	case IDE_PM_STANDBY:		/* Suspend step 2 (standby) */
-		cmd->tf.command = ATA_CMD_STANDBYNOW1;
+		cmd.tf.command = ATA_CMD_STANDBYNOW1;
 		goto out_do_tf;
 	case IDE_PM_RESTORE_PIO:	/* Resume step 1 (restore PIO) */
 		ide_set_max_pio(drive);
@@ -141,7 +133,7 @@ ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *rq)
 			ide_complete_power_step(drive, rq);
 		return ide_stopped;
 	case IDE_PM_IDLE:		/* Resume step 2 (idle) */
-		cmd->tf.command = ATA_CMD_IDLEIMMEDIATE;
+		cmd.tf.command = ATA_CMD_IDLEIMMEDIATE;
 		goto out_do_tf;
 	case IDE_PM_RESTORE_DMA:	/* Resume step 3 (restore DMA) */
 		/*
@@ -163,10 +155,10 @@ ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *rq)
 	return ide_stopped;
 
 out_do_tf:
-	cmd->tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	cmd->protocol = ATA_PROT_NODATA;
+	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	cmd.protocol = ATA_PROT_NODATA;
 
-	return do_rw_taskfile(drive, cmd);
+	return do_rw_taskfile(drive, &cmd);
 }
 
 /**
@@ -180,7 +172,7 @@ out_do_tf:
 void ide_complete_pm_rq(ide_drive_t *drive, struct request *rq)
 {
 	struct request_queue *q = drive->queue;
-	struct request_pm_state *pm = rq->data;
+	struct request_pm_state *pm = rq->special;
 	unsigned long flags;
 
 	ide_complete_power_step(drive, rq);
@@ -206,7 +198,7 @@ void ide_complete_pm_rq(ide_drive_t *drive, struct request *rq)
 
 void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
 {
-	struct request_pm_state *pm = rq->data;
+	struct request_pm_state *pm = rq->special;
 
 	if (blk_pm_suspend_request(rq) &&
 	    pm->pm_step == IDE_PM_START_SUSPEND)
-- 
1.6.0.2

