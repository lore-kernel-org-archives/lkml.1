Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbZBPAQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbZBPAQc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbZBPANF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:13:05 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:34049 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338AbZBPANC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:13:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=XTdsBg+U/maJXUDHlBIN4NxirjP5KwcHn1sxS3sPODBR+X38eCVycz2Z4CgKhlvPXf
         4TolPfTwEKJu5tMU8o3E6st7e6SpjOnjYtLwgLDUagNdXW+IPZIZwjVNZPKO//nsy4DQ
         GichFHWUIG/0sC9J2Um5kRtKS5qLfLrcAX/Gk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 16 Feb 2009 01:14:29 +0100
Message-Id: <20090216001429.27491.36651.sendpatchset@localhost.localdomain>
In-Reply-To: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
References: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
Subject: [PATCH 12/20] ide-cd: remove cdrom_end_request()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: remove cdrom_end_request()

Inline cdrom_end_request() into cdrom_newpc_intr()
and ide_cd_do_request().

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   81 +++++++++++++++++++++++++++++----------------------
 1 file changed, 47 insertions(+), 34 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -260,34 +260,6 @@ static void ide_cd_complete_failed_rq(id
 		cdrom_analyze_sense_data(drive, NULL, sense);
 }
 
-static void cdrom_end_request(ide_drive_t *drive, int uptodate)
-{
-	struct request *rq = drive->hwif->rq;
-	int nsectors = rq->hard_cur_sectors;
-
-	ide_debug_log(IDE_DBG_FUNC, "cmd: 0x%x, uptodate: 0x%x, nsectors: %d",
-				    rq->cmd[0], uptodate, nsectors);
-
-	if (blk_sense_request(rq) && uptodate)
-		ide_cd_complete_failed_rq(drive, rq);
-
-	if (!rq->current_nr_sectors && blk_fs_request(rq))
-		uptodate = 1;
-	/* make sure it's fully ended */
-	if (blk_pc_request(rq))
-		nsectors = (rq->data_len + 511) >> 9;
-	if (!nsectors)
-		nsectors = 1;
-
-	ide_debug_log(IDE_DBG_FUNC, "uptodate: 0x%x, nsectors: %d",
-				    uptodate, nsectors);
-
-	if (blk_fs_request(rq) == 0 && uptodate <= 0 && rq->errors == 0)
-		rq->errors = -EIO;
-
-	ide_complete_rq(drive, uptodate ? 0 : -EIO, nsectors << 9);
-}
-
 /*
  * Returns:
  * 0: if the request should be continued.
@@ -730,7 +702,7 @@ static ide_startstop_t cdrom_newpc_intr(
 	xfer_func_t *xferfunc;
 	ide_expiry_t *expiry = NULL;
 	int dma_error = 0, dma, stat, thislen, uptodate = 0;
-	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0, rc;
+	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0, rc, nsectors;
 	int sense = blk_sense_request(rq);
 	unsigned int timeout;
 	u16 len;
@@ -897,8 +869,14 @@ static ide_startstop_t cdrom_newpc_intr(
 			rq->current_nr_sectors -= (blen >> 9);
 			rq->sector += (blen >> 9);
 
-			if (rq->current_nr_sectors == 0 && rq->nr_sectors)
-				cdrom_end_request(drive, 1);
+			if (rq->current_nr_sectors == 0 && rq->nr_sectors) {
+				nsectors = rq->hard_cur_sectors;
+
+				if (nsectors == 0)
+					nsectors = 1;
+
+				ide_complete_rq(drive, 0, nsectors << 9);
+			}
 		} else {
 			rq->data_len -= blen;
 
@@ -946,7 +924,28 @@ out_end:
 
 		hwif->rq = NULL;
 	} else {
-		cdrom_end_request(drive, uptodate);
+		if (sense && uptodate)
+			ide_cd_complete_failed_rq(drive, rq);
+
+		if (blk_fs_request(rq)) {
+			if (rq->current_nr_sectors == 0)
+				uptodate = 1;
+		} else {
+			if (uptodate <= 0 && rq->errors == 0)
+				rq->errors = -EIO;
+		}
+
+		/* make sure it's fully ended */
+		if (blk_pc_request(rq))
+			nsectors = (rq->data_len + 511) >> 9;
+		else
+			nsectors = rq->hard_cur_sectors;
+
+		if (nsectors == 0)
+			nsectors = 1;
+
+		ide_complete_rq(drive, uptodate ? 0 : -EIO, nsectors << 9);
+
 		if (sense && rc == 2)
 			ide_error(drive, "request sense failure", stat);
 	}
@@ -1035,7 +1034,7 @@ static ide_startstop_t ide_cd_do_request
 					sector_t block)
 {
 	struct ide_cmd cmd;
-	int uptodate = 0;
+	int uptodate = 0, nsectors;
 
 	ide_debug_log(IDE_DBG_RQ, "cmd: 0x%x, block: %llu",
 				  rq->cmd[0], (unsigned long long)block);
@@ -1071,7 +1070,21 @@ static ide_startstop_t ide_cd_do_request
 
 	return ide_issue_pc(drive, &cmd);
 out_end:
-	cdrom_end_request(drive, uptodate);
+	if (blk_fs_request(rq)) {
+		if (rq->current_nr_sectors == 0)
+			uptodate = 1;
+	} else {
+		if (uptodate <= 0 && rq->errors == 0)
+			rq->errors = -EIO;
+	}
+
+	nsectors = rq->hard_cur_sectors;
+
+	if (nsectors == 0)
+		nsectors = 1;
+
+	ide_complete_rq(drive, uptodate ? 0 : -EIO, nsectors << 9);
+
 	return ide_stopped;
 }
 
