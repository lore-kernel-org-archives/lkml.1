Return-Path: <linux-kernel-owner+w=401wt.eu-S1756677AbZBPAPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbZBPAPe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756183AbZBPAMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:12:44 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:34049 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168AbZBPAMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:12:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=QmS3lXMpotj5XKO8tsXL1owwbWRYpeKHVOZ7+T9b9ot83VousSqRGfhr/wE6WwuxHZ
         cgRaYJQodlKuTGSH5lAd/M57lEhXyf9m27xzpkQccUnPnM0VkOYT864ef+wFPG2DTQGQ
         yN52Li4aRHjr2xGS4sFgo0x3s3/XfX6gB3jH0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 16 Feb 2009 01:14:09 +0100
Message-Id: <20090216001409.27491.64048.sendpatchset@localhost.localdomain>
In-Reply-To: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
References: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
Subject: [PATCH 09/20] ide-cd: unify ide_cd_do_request() exit paths
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: unify ide_cd_do_request() exit paths

* Move cdrom_end_request() calls from cdrom_start_rw()
  and ide_cd_prepare_rw_request() to ide_cd_do_request().

* Unify ide_cd_do_request() exit paths.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -590,7 +590,6 @@ static ide_startstop_t ide_cd_prepare_rw
 				printk(KERN_ERR PFX "%s: %s: buffer botch (%u)\n",
 						drive->name, __func__,
 						rq->current_nr_sectors);
-				cdrom_end_request(drive, 0);
 				return ide_stopped;
 			}
 			rq->current_nr_sectors += nskip;
@@ -967,10 +966,8 @@ static ide_startstop_t cdrom_start_rw(id
 
 	if (write) {
 		/* disk has become write protected */
-		if (get_disk_ro(cd->disk)) {
-			cdrom_end_request(drive, 0);
+		if (get_disk_ro(cd->disk))
 			return ide_stopped;
-		}
 	} else {
 		/*
 		 * We may be retrying this request after an error.  Fix up any
@@ -982,10 +979,8 @@ static ide_startstop_t cdrom_start_rw(id
 	/* use DMA, if possible / writes *must* be hardware frame aligned */
 	if ((rq->nr_sectors & (sectors_per_frame - 1)) ||
 	    (rq->sector & (sectors_per_frame - 1))) {
-		if (write) {
-			cdrom_end_request(drive, 0);
+		if (write)
 			return ide_stopped;
-		}
 		drive->dma = 0;
 	} else
 		drive->dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
@@ -1040,6 +1035,7 @@ static ide_startstop_t ide_cd_do_request
 					sector_t block)
 {
 	struct ide_cmd cmd;
+	int uptodate = 0;
 
 	ide_debug_log(IDE_DBG_RQ, "cmd: 0x%x, block: %llu",
 				  rq->cmd[0], (unsigned long long)block);
@@ -1048,11 +1044,9 @@ static ide_startstop_t ide_cd_do_request
 		blk_dump_rq_flags(rq, "ide_cd_do_request");
 
 	if (blk_fs_request(rq)) {
-		if (cdrom_start_rw(drive, rq) == ide_stopped)
-			return ide_stopped;
-
-		if (ide_cd_prepare_rw_request(drive, rq) == ide_stopped)
-			return ide_stopped;
+		if (cdrom_start_rw(drive, rq) == ide_stopped ||
+		    ide_cd_prepare_rw_request(drive, rq) == ide_stopped)
+			goto out_end;
 	} else if (blk_sense_request(rq) || blk_pc_request(rq) ||
 		   rq->cmd_type == REQ_TYPE_ATA_PC) {
 		if (!rq->timeout)
@@ -1061,12 +1055,11 @@ static ide_startstop_t ide_cd_do_request
 		cdrom_do_block_pc(drive, rq);
 	} else if (blk_special_request(rq)) {
 		/* right now this can only be a reset... */
-		cdrom_end_request(drive, 1);
-		return ide_stopped;
+		uptodate = 1;
+		goto out_end;
 	} else {
 		blk_dump_rq_flags(rq, DRV_NAME " bad flags");
-		cdrom_end_request(drive, 0);
-		return ide_stopped;
+		goto out_end;
 	}
 
 	memset(&cmd, 0, sizeof(cmd));
@@ -1077,6 +1070,9 @@ static ide_startstop_t ide_cd_do_request
 	cmd.rq = rq;
 
 	return ide_issue_pc(drive, &cmd);
+out_end:
+	cdrom_end_request(drive, uptodate);
+	return ide_stopped;
 }
 
 /*
