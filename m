Return-Path: <linux-kernel-owner+w=401wt.eu-S1758960AbZBBVlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960AbZBBVlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759431AbZBBVjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:39:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:10839 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759128AbZBBVjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:39:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=NXVc+nxShLAOKUwfKdt3tGQbulzuxio4814TmF8kS55BRAZZeKhj1CYAt+wWAaXmUE
         bMBQlQ1UltC8NLYIdYNCTC8jcYZGpPBR9r5ub8tzbwHtzoKuMMXEJ9PbMgi8jIMpqIVK
         O33eIkSsrKw6ks10YVxLoW09WyR34k3f8/ReI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 02 Feb 2009 22:40:29 +0100
Message-Id: <20090202214029.17960.54823.sendpatchset@localhost.localdomain>
In-Reply-To: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
References: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
Subject: [PATCH 14/14] ide: sanitize ide_finish_cmd()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: sanitize ide_finish_cmd()

* Move ide_end_request() call out from ide_finish_cmd() to its users.

* Use ide_finish_cmd() in task_no_data_intr().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c      |    5 ++++-
 drivers/ide/ide-taskfile.c |   24 +++++++++---------------
 2 files changed, 13 insertions(+), 16 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -98,7 +98,10 @@ ide_startstop_t ide_dma_intr(ide_drive_t
 		if (!dma_stat) {
 			struct ide_cmd *cmd = &hwif->cmd;
 
-			ide_finish_cmd(drive, cmd, stat);
+			if ((cmd->tf_flags & IDE_TFLAG_FS) == 0)
+				ide_finish_cmd(drive, cmd, stat);
+			else
+				ide_end_request(drive, 1, cmd->rq->nr_sectors);
 			return ide_stopped;
 		}
 		printk(KERN_ERR "%s: %s: bad DMA status (0x%02x)\n",
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -150,12 +150,8 @@ static ide_startstop_t task_no_data_intr
 		drive->mult_count = drive->mult_req;
 
 	if (custom == 0 || tf->command == ATA_CMD_IDLEIMMEDIATE ||
-	    tf->command == ATA_CMD_CHK_POWER) {
-		u8 err = ide_read_error(drive);
-
-		ide_complete_cmd(drive, cmd, stat, err);
-		ide_complete_rq(drive, err);
-	}
+	    tf->command == ATA_CMD_CHK_POWER)
+		ide_finish_cmd(drive, cmd, stat);
 
 	return ide_stopped;
 }
@@ -287,15 +283,10 @@ static void ide_error_cmd(ide_drive_t *d
 
 void ide_finish_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat)
 {
-	if ((cmd->tf_flags & IDE_TFLAG_FS) == 0) {
-		u8 err = ide_read_error(drive);
+	u8 err = ide_read_error(drive);
 
-		ide_complete_cmd(drive, cmd, stat, err);
-		ide_complete_rq(drive, err);
-		return;
-	}
-
-	ide_end_request(drive, 1, cmd->rq->nr_sectors);
+	ide_complete_cmd(drive, cmd, stat, err);
+	ide_complete_rq(drive, err);
 }
 
 /*
@@ -350,7 +341,10 @@ out_wait:
 	ide_set_handler(drive, &task_pio_intr, WAIT_WORSTCASE, NULL);
 	return ide_started;
 out_end:
-	ide_finish_cmd(drive, cmd, stat);
+	if ((cmd->tf_flags & IDE_TFLAG_FS) == 0)
+		ide_finish_cmd(drive, cmd, stat);
+	else
+		ide_end_request(drive, 1, cmd->rq->nr_sectors);
 	return ide_stopped;
 out_err:
 	ide_error_cmd(drive, cmd);
