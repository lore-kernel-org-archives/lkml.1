Return-Path: <linux-kernel-owner+w=401wt.eu-S1758586AbYFJUx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586AbYFJUx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758071AbYFJUuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:50:54 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:30333 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051AbYFJUuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:50:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Om9M0uW8UglKyWmu81gVW8eDFI6n7ET/yVl93GRag7fybfa+KYtLDVBhBq7Ng/zhLn
         GZr/SUbU8iIOu9xQ8mFywnaNGe7qidNzfPZ09yBZQ5AU1g+cnrEahYxnXYwtU1c2wTqO
         NzVA6DmZAOYlP2oNkC5Iu/pU+8SpFV8MmJNpU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 10 Jun 2008 22:52:30 +0200
Message-Id: <20080610205230.18469.16053.sendpatchset@localhost.localdomain>
In-Reply-To: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
References: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/14] ide: allow any command requesting DMA data phase for HDIO_DRIVE_TASKFILE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow any command requesting DMA data phase for HDIO_DRIVE_TASKFILE ioctl
and remove no longer needed task_dma_ok()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-taskfile.c |   22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -62,25 +62,6 @@ int taskfile_lib_get_identify (ide_drive
 	return ide_raw_taskfile(drive, &args, buf, 1);
 }
 
-static int inline task_dma_ok(ide_task_t *task)
-{
-	if (blk_fs_request(task->rq) || (task->tf_flags & IDE_TFLAG_FLAGGED))
-		return 1;
-
-	switch (task->tf.command) {
-		case WIN_WRITEDMA_ONCE:
-		case WIN_WRITEDMA:
-		case WIN_WRITEDMA_EXT:
-		case WIN_READDMA_ONCE:
-		case WIN_READDMA:
-		case WIN_READDMA_EXT:
-		case WIN_IDENTIFY_DMA:
-			return 1;
-	}
-
-	return 0;
-}
-
 static ide_startstop_t task_no_data_intr(ide_drive_t *);
 static ide_startstop_t set_geometry_intr(ide_drive_t *);
 static ide_startstop_t recal_intr(ide_drive_t *);
@@ -139,8 +120,7 @@ ide_startstop_t do_rw_taskfile (ide_driv
 				    WAIT_WORSTCASE, NULL);
 		return ide_started;
 	default:
-		if (task_dma_ok(task) == 0 || drive->using_dma == 0 ||
-		    dma_ops->dma_setup(drive))
+		if (drive->using_dma == 0 || dma_ops->dma_setup(drive))
 			return ide_stopped;
 		dma_ops->dma_exec_cmd(drive, tf->command);
 		dma_ops->dma_start(drive);
