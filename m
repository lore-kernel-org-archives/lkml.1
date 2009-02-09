Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbZBIUCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbZBIUCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 15:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757469AbZBIUA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 15:00:27 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:48124 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078AbZBIUAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 15:00:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=JVxR4AlnttUnklQW6JfuDy+W46GuYUIfkbrQ1GlMPJ5DAqkOtjGmkYojB3NHubk92J
         xIxqguZBqU9yN38qy+2r98vqwQZ0RQdoWYyVGYE04CQEeLAlzcHn341IWcq9d8d1Narm
         8l4zKCCLVW1qEt7y8i29sAxIHbu+ZgwxOeJSY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 09 Feb 2009 21:01:36 +0100
Message-Id: <20090209200136.7985.65451.sendpatchset@localhost.localdomain>
In-Reply-To: <20090209200042.7985.94247.sendpatchset@localhost.localdomain>
References: <20090209200042.7985.94247.sendpatchset@localhost.localdomain>
Subject: [PATCH 7/9] ide: pass number of bytes to complete to ide_complete_rq()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: pass number of bytes to complete to ide_complete_rq()

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c    |    2 +-
 drivers/ide/ide-eh.c       |    2 +-
 drivers/ide/ide-floppy.c   |    2 +-
 drivers/ide/ide-io.c       |    8 ++++----
 drivers/ide/ide-tape.c     |    2 +-
 drivers/ide/ide-taskfile.c |    2 +-
 include/linux/ide.h        |    2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -392,7 +392,7 @@ static ide_startstop_t ide_pc_intr(ide_d
 
 		if (blk_special_request(rq)) {
 			rq->errors = 0;
-			ide_complete_rq(drive, 0);
+			ide_complete_rq(drive, 0, blk_rq_bytes(rq));
 		} else {
 			if (blk_fs_request(rq) == 0 && uptodate <= 0) {
 				if (rq->errors == 0)
Index: b/drivers/ide/ide-eh.c
===================================================================
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -134,7 +134,7 @@ ide_startstop_t ide_error(ide_drive_t *d
 			return ide_stopped;
 		}
 		rq->errors = err;
-		ide_complete_rq(drive, err ? -EIO : 0);
+		ide_complete_rq(drive, err ? -EIO : 0, blk_rq_bytes(rq));
 		return ide_stopped;
 	}
 
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -261,7 +261,7 @@ static ide_startstop_t ide_floppy_do_req
 
 		if (blk_special_request(rq)) {
 			rq->errors = 0;
-			ide_complete_rq(drive, 0);
+			ide_complete_rq(drive, 0, blk_rq_bytes(rq));
 			return ide_stopped;
 		} else
 			goto out_end;
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -137,13 +137,13 @@ void ide_complete_cmd(ide_drive_t *drive
 		kfree(cmd);
 }
 
-int ide_complete_rq(ide_drive_t *drive, int error)
+int ide_complete_rq(ide_drive_t *drive, int error, unsigned int nr_bytes)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->rq;
 	int rc;
 
-	rc = blk_end_request(rq, error, blk_rq_bytes(rq));
+	rc = blk_end_request(rq, error, nr_bytes);
 	if (rc == 0)
 		hwif->rq = NULL;
 
@@ -160,7 +160,7 @@ void ide_kill_rq(ide_drive_t *drive, str
 
 	if ((media == ide_floppy || media == ide_tape) && drv_req) {
 		rq->errors = 0;
-		ide_complete_rq(drive, 0);
+		ide_complete_rq(drive, 0, blk_rq_bytes(rq));
 	} else {
 		if (media == ide_tape)
 			rq->errors = IDE_DRV_ERROR_GENERAL;
@@ -308,7 +308,7 @@ static ide_startstop_t execute_drive_cmd
  	printk("%s: DRIVE_CMD (null)\n", drive->name);
 #endif
 	rq->errors = 0;
-	ide_complete_rq(drive, 0);
+	ide_complete_rq(drive, 0, blk_rq_bytes(rq));
 
  	return ide_stopped;
 }
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -778,7 +778,7 @@ static ide_startstop_t idetape_do_reques
 					"Two DSC requests were queued\n");
 			drive->failed_pc = NULL;
 			rq->errors = 0;
-			ide_complete_rq(drive, 0);
+			ide_complete_rq(drive, 0, blk_rq_bytes(rq));
 			return ide_stopped;
 		}
 
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -294,7 +294,7 @@ void ide_finish_cmd(ide_drive_t *drive, 
 
 	ide_complete_cmd(drive, cmd, stat, err);
 	rq->errors = err;
-	ide_complete_rq(drive, err ? -EIO : 0);
+	ide_complete_rq(drive, err ? -EIO : 0, blk_rq_bytes(rq));
 }
 
 /*
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1163,7 +1163,7 @@ extern int ide_devset_execute(ide_drive_
 			      const struct ide_devset *setting, int arg);
 
 void ide_complete_cmd(ide_drive_t *, struct ide_cmd *, u8, u8);
-int ide_complete_rq(ide_drive_t *, int);
+int ide_complete_rq(ide_drive_t *, int, unsigned int);
 
 void ide_tf_dump(const char *, struct ide_taskfile *);
 
