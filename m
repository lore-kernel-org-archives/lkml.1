Return-Path: <linux-kernel-owner+w=401wt.eu-S1760134AbZBBVmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760134AbZBBVmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759926AbZBBVlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:41:39 -0500
Received: from mail-bw0-f12.google.com ([209.85.218.12]:47527 "EHLO
	mail-bw0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759418AbZBBVlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:41:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=usPLuK9qmOdRu14d7zw21MsYwHDNWArSAjRYEGF5YkxcRNy9mK16sDDvZolpaYs+f4
         NChRWA2Emht72oxO6gd2G1sHaEyKdLfh4akjA+DgR5CjHSfAymNxyOGx2D7xOawNt13g
         6iuldTvwuGsXOhevt0rllFXIzyZUj6WqJhpMQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 02 Feb 2009 22:40:07 +0100
Message-Id: <20090202214007.17960.23147.sendpatchset@localhost.localdomain>
In-Reply-To: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
References: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
Subject: [PATCH 12/14] ide: use ide_complete_cmd() for head unload commands
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: use ide_complete_cmd() for head unload commands

Move handling of head unload commands from task_no_data_intr()
to ide_complete_cmd() and then use ide_complete_cmd() also for
head unload commands.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c       |   11 +++++++++++
 drivers/ide/ide-taskfile.c |   13 +++----------
 2 files changed, 14 insertions(+), 10 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -146,12 +146,23 @@ EXPORT_SYMBOL_GPL(ide_end_dequeued_reque
 void ide_complete_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat, u8 err)
 {
 	struct ide_taskfile *tf = &cmd->tf;
+	u8 tf_cmd = tf->command;
 
 	tf->error = err;
 	tf->status = stat;
 
 	drive->hwif->tp_ops->tf_read(drive, cmd);
 
+	if ((cmd->tf_flags & IDE_TFLAG_CUSTOM_HANDLER) &&
+	    tf_cmd == ATA_CMD_IDLEIMMEDIATE) {
+		if (tf->lbal != 0xc4) {
+			printk(KERN_ERR "%s: head unload failed!\n",
+			       drive->name);
+			ide_tf_dump(drive->name, tf);
+		} else
+			drive->dev_flags |= IDE_DFLAG_PARKED;
+	}
+
 	if (cmd->tf_flags & IDE_TFLAG_DYN)
 		kfree(cmd);
 }
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -146,22 +146,15 @@ static ide_startstop_t task_no_data_intr
 		return ide_error(drive, "task_no_data_intr", stat);
 	}
 
-	if (custom && tf->command == ATA_CMD_IDLEIMMEDIATE) {
-		hwif->tp_ops->tf_read(drive, cmd);
-		if (tf->lbal != 0xc4) {
-			printk(KERN_ERR "%s: head unload failed!\n",
-			       drive->name);
-			ide_tf_dump(drive->name, tf);
-		} else
-			drive->dev_flags |= IDE_DFLAG_PARKED;
-	} else if (custom && tf->command == ATA_CMD_SET_MULTI)
+	if (custom && tf->command == ATA_CMD_SET_MULTI)
 		drive->mult_count = drive->mult_req;
 
 	if (custom == 0 || tf->command == ATA_CMD_IDLEIMMEDIATE) {
 		struct request *rq = hwif->rq;
 		u8 err = ide_read_error(drive);
 
-		if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
+		if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE ||
+		    tf->command == ATA_CMD_IDLEIMMEDIATE)
 			ide_complete_cmd(drive, cmd, stat, err);
 		ide_complete_rq(drive, err);
 	}
