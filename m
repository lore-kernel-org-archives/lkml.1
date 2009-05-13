Return-Path: <linux-kernel-owner+w=401wt.eu-S1761436AbZEMUrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761436AbZEMUrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 16:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761458AbZEMUrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 16:47:16 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:40173 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761290AbZEMUrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 16:47:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=fpR6GWUGWcRHMBqeQXTG5u7aS9//oKFj5VJQspYPBI9hI0EQr/2Hxc7Zq4ectI+mAo
         N5BRkSuojDuToOxQNZcAbAWRgYOkfaV+bauLRwaJWWyRTpP1wnC3DW4Gk0naFMq9aJqA
         3MY4Zb0F9mow6YaU/Fauhnzj5lmbLoCnQduug=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 13 May 2009 22:51:46 +0200
Message-Id: <20090513205146.28638.37593.sendpatchset@localhost.localdomain>
In-Reply-To: <20090513205139.28638.87226.sendpatchset@localhost.localdomain>
References: <20090513205139.28638.87226.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/7] ide: BUG() on unknown requests
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unsupported requests should be never handed down to device drivers
and the best thing we can do upon discovering such request inside
driver's ->do_request method is to just BUG().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c     |    8 ++------
 drivers/ide/ide-disk.c   |    9 +--------
 drivers/ide/ide-floppy.c |    6 ++----
 drivers/ide/ide-tape.c   |   10 +---------
 4 files changed, 6 insertions(+), 27 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -831,12 +831,8 @@ static ide_startstop_t ide_cd_do_request
 		/* right now this can only be a reset... */
 		uptodate = 1;
 		goto out_end;
-	} else {
-		blk_dump_rq_flags(rq, DRV_NAME " bad flags");
-		if (rq->errors == 0)
-			rq->errors = -EIO;
-		goto out_end;
-	}
+	} else
+		BUG();
 
 	/* prepare sense request for this command */
 	ide_prep_sense(drive, rq);
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -184,14 +184,7 @@ static ide_startstop_t ide_do_rw_disk(id
 	ide_hwif_t *hwif = drive->hwif;
 
 	BUG_ON(drive->dev_flags & IDE_DFLAG_BLOCKED);
-
-	if (!blk_fs_request(rq)) {
-		blk_dump_rq_flags(rq, "ide_do_rw_disk - bad command");
-		if (rq->errors == 0)
-			rq->errors = -EIO;
-		ide_complete_rq(drive, -EIO, ide_rq_bytes(rq));
-		return ide_stopped;
-	}
+	BUG_ON(!blk_fs_request(rq));
 
 	ledtrig_ide_activity();
 
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -272,10 +272,8 @@ static ide_startstop_t ide_floppy_do_req
 	} else if (blk_pc_request(rq)) {
 		pc = &floppy->queued_pc;
 		idefloppy_blockpc_cmd(floppy, pc, rq);
-	} else {
-		blk_dump_rq_flags(rq, PFX "unsupported command in queue");
-		goto out_end;
-	}
+	} else
+		BUG();
 
 	ide_prep_sense(drive, rq);
 
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -620,15 +620,7 @@ static ide_startstop_t idetape_do_reques
 	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %u\n"
 		  (unsigned long long)blk_rq_pos(rq), blk_rq_sectors(rq));
 
-	if (!(blk_special_request(rq) || blk_sense_request(rq))) {
-		/* We do not support buffer cache originated requests. */
-		printk(KERN_NOTICE "ide-tape: %s: Unsupported request in "
-			"request queue (%d)\n", drive->name, rq->cmd_type);
-		if (blk_fs_request(rq) == 0 && rq->errors == 0)
-			rq->errors = -EIO;
-		ide_complete_rq(drive, -EIO, ide_rq_bytes(rq));
-		return ide_stopped;
-	}
+	BUG_ON(!(blk_special_request(rq) || blk_sense_request(rq)));
 
 	/* Retry a failed packet command */
 	if (drive->failed_pc && drive->pc->c[0] == REQUEST_SENSE) {
