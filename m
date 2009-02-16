Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbZBPASP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbZBPASP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbZBPANi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:13:38 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:28417 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503AbZBPANg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:13:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=okf4QaIeuvmVkKGbWPgQFQ/TuHsP2dPRqgujZog22WHpQPhns4+rG31ptOe2WHJxxD
         WV5mE2GU1wljlN6o5u1Whz3DpbvxsHN3cs1M2xoEAaGMxgy8tK7O5YB7fDMQ7wzesBw4
         5qTlpE/EQM4i/axkWIsQ7nH38SSnM2ma05gEA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 16 Feb 2009 01:15:01 +0100
Message-Id: <20090216001501.27491.50243.sendpatchset@localhost.localdomain>
In-Reply-To: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
References: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
Subject: [PATCH 17/20] ide-cd: merge ide_cd_prepare_rw_request() into cdrom_start_rw()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: merge ide_cd_prepare_rw_request() into cdrom_start_rw()

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -501,17 +501,6 @@ static int ide_cd_check_ireason(ide_driv
 	return -1;
 }
 
-static ide_startstop_t ide_cd_prepare_rw_request(ide_drive_t *drive,
-						 struct request *rq)
-{
-	ide_debug_log(IDE_DBG_RQ, "rq->cmd_flags: 0x%x", rq->cmd_flags);
-
-	/* set up the command */
-	rq->timeout = ATAPI_WAIT_PC;
-
-	return ide_started;
-}
-
 static void ide_cd_request_sense_fixup(ide_drive_t *drive, struct request *rq)
 {
 	ide_debug_log(IDE_DBG_FUNC, "rq->cmd[0]: 0x%x", rq->cmd[0]);
@@ -863,9 +852,9 @@ static ide_startstop_t cdrom_start_rw(id
 	unsigned short sectors_per_frame =
 		queue_hardsect_size(q) >> SECTOR_BITS;
 
-	ide_debug_log(IDE_DBG_RQ, "rq->cmd[0]: 0x%x, write: 0x%x, "
+	ide_debug_log(IDE_DBG_RQ, "rq->cmd[0]: 0x%x, rq->cmd_flags: 0x%x, "
 				  "secs_per_frame: %u",
-				  rq->cmd[0], write, sectors_per_frame);
+				  rq->cmd[0], rq->cmd_flags, sectors_per_frame);
 
 	if (write) {
 		/* disk has become write protected */
@@ -890,6 +879,8 @@ static ide_startstop_t cdrom_start_rw(id
 	if (write)
 		cd->devinfo.media_written = 1;
 
+	rq->timeout = ATAPI_WAIT_PC;
+
 	return ide_started;
 }
 
@@ -946,10 +937,8 @@ static ide_startstop_t ide_cd_do_request
 		blk_dump_rq_flags(rq, "ide_cd_do_request");
 
 	if (blk_fs_request(rq)) {
-		if (cdrom_start_rw(drive, rq) == ide_stopped ||
-		    ide_cd_prepare_rw_request(drive, rq) == ide_stopped) {
+		if (cdrom_start_rw(drive, rq) == ide_stopped)
 			goto out_end;
-		}
 	} else if (blk_sense_request(rq) || blk_pc_request(rq) ||
 		   rq->cmd_type == REQ_TYPE_ATA_PC) {
 		if (!rq->timeout)
