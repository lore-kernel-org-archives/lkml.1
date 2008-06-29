Return-Path: <linux-kernel-owner+w=401wt.eu-S1760513AbYF2LBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760513AbYF2LBB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 07:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbYF2K7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 06:59:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:56961 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbYF2K7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 06:59:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=whcXaubKt/VRUQ4dSIKvkvagtV1cVIFbjhFgy9PLwNAU2H+AoVeRSc+v+Q2lkRGu9R
         L5Gi4SFE7SwOEXRo2d0H13fRBmj5ZGi6hAIQNwyYIAyYxGhfqvX4Qmj2i9ukbKF0rVH7
         uxuHXmYiBXDlCDSj0Zpc8FcXY1R7tZL8fXUCI=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 04/16] ide-scsi: use drive->pc_callback instead of pc->callback
Date: Sun, 29 Jun 2008 12:59:07 +0200
Message-Id: <1214737159-1078-5-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
References: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |   10 ++--------
 drivers/scsi/ide-scsi.c |    5 +++--
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index c3c161a..0e8b6f5 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -30,10 +30,7 @@ ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	debug_log("Enter %s - interrupt handler\n", __func__);
 
 	if (pc->flags & PC_FLAG_TIMEDOUT) {
-		if (drive->media == ide_floppy || drive->media == ide_tape)
-			drive->pc_callback(drive);
-		else
-			pc->callback(drive);
+		drive->pc_callback(drive);
 		return ide_stopped;
 	}
 
@@ -99,10 +96,7 @@ cmd_finished:
 			return ide_stopped;
 		}
 		/* Command finished - Call the callback function */
-		if (drive->media == ide_floppy || drive->media == ide_tape)
-			drive->pc_callback(drive);
-		else
-			pc->callback(drive);
+		drive->pc_callback(drive);
 		return ide_stopped;
 	}
 
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 683bce3..a6c2c5f 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -228,7 +228,6 @@ static int idescsi_check_condition(ide_drive_t *drive,
 	rq->cmd_type = REQ_TYPE_SENSE;
 	rq->cmd_flags |= REQ_PREEMPT;
 	pc->timeout = jiffies + WAIT_READY;
-	pc->callback = ide_scsi_callback;
 	/* NOTE! Save the failed packet command in "rq->buffer" */
 	rq->buffer = (void *) failed_cmd->special;
 	pc->scsi_cmd = ((struct ide_atapi_pc *) failed_cmd->special)->scsi_cmd;
@@ -478,6 +477,9 @@ static void idescsi_setup (ide_drive_t *drive, idescsi_scsi_t *scsi)
 #if IDESCSI_DEBUG_LOG
 	set_bit(IDESCSI_LOG_CMD, &scsi->log);
 #endif /* IDESCSI_DEBUG_LOG */
+
+	drive->pc_callback = ide_scsi_callback;
+
 	idescsi_add_settings(drive);
 }
 
@@ -630,7 +632,6 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 	pc->scsi_cmd = cmd;
 	pc->done = done;
 	pc->timeout = jiffies + cmd->timeout_per_command;
-	pc->callback = ide_scsi_callback;
 
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: que %lu, cmd = ", drive->name, cmd->serial_number);
-- 
1.5.5.4

