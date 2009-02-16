Return-Path: <linux-kernel-owner+w=401wt.eu-S1757147AbZBPAQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbZBPAQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756319AbZBPAM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:12:58 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:53581 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282AbZBPAM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:12:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=qbPujrB937PG4oIbOYvzfMjFjZSyaZEmvCqkn2ZlNiYoyvFywQp8xT9OTilKi4BKMl
         MlUR03A+Sw90YUbNrbwuxCrUZ010Vc57AVy4Q3h6d7jdROBhN9LLzPk5424o8M26OHT6
         EWnagSY54f5b7J/EgYLj17H/kcs7GgskZpjWI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 16 Feb 2009 01:14:22 +0100
Message-Id: <20090216001422.27491.17281.sendpatchset@localhost.localdomain>
In-Reply-To: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
References: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
Subject: [PATCH 11/20] ide-cd: unify cdrom_newpc_intr() exit paths
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: unify cdrom_newpc_intr() exit paths

* Move cdrom_end_request() calls from cdrom_decode_status()
  and ide_cd_check_ireason() to cdrom_newpc_intr().

* Unify cdrom_newpc_intr() exit paths.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   48 +++++++++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -291,7 +291,8 @@ static void cdrom_end_request(ide_drive_
 /*
  * Returns:
  * 0: if the request should be continued.
- * 1: if the request was ended.
+ * 1: if the request will be going through error recovery.
+ * 2: if the request should be ended.
  */
 static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 {
@@ -324,10 +325,7 @@ static int cdrom_decode_status(ide_drive
 		 * Just give up.
 		 */
 		rq->cmd_flags |= REQ_FAILED;
-		cdrom_end_request(drive, 0);
-		ide_error(drive, "request sense failure", stat);
-		return 1;
-
+		return 2;
 	} else if (blk_pc_request(rq) || rq->cmd_type == REQ_TYPE_ATA_PC) {
 		/* All other functions, except for READ. */
 
@@ -467,14 +465,12 @@ static int cdrom_decode_status(ide_drive
 		 */
 		if (stat & ATA_ERR)
 			cdrom_queue_request_sense(drive, NULL, NULL);
+		return 1;
 	} else {
 		blk_dump_rq_flags(rq, PFX "bad rq");
-		cdrom_end_request(drive, 0);
+		return 2;
 	}
 
-	/* retry, or handle the next request */
-	return 1;
-
 end_request:
 	if (stat & ATA_ERR) {
 		struct request_queue *q = drive->queue;
@@ -487,10 +483,9 @@ end_request:
 		hwif->rq = NULL;
 
 		cdrom_queue_request_sense(drive, rq->sense, rq);
+		return 1;
 	} else
-		cdrom_end_request(drive, 0);
-
-	return 1;
+		return 2;
 }
 
 /*
@@ -534,7 +529,6 @@ static int ide_cd_check_ireason(ide_driv
 	if (rq->cmd_type == REQ_TYPE_ATA_PC)
 		rq->cmd_flags |= REQ_FAILED;
 
-	cdrom_end_request(drive, 0);
 	return -1;
 }
 
@@ -736,7 +730,8 @@ static ide_startstop_t cdrom_newpc_intr(
 	xfer_func_t *xferfunc;
 	ide_expiry_t *expiry = NULL;
 	int dma_error = 0, dma, stat, thislen, uptodate = 0;
-	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0;
+	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0, rc;
+	int sense = blk_sense_request(rq);
 	unsigned int timeout;
 	u16 len;
 	u8 ireason;
@@ -756,8 +751,12 @@ static ide_startstop_t cdrom_newpc_intr(
 		}
 	}
 
-	if (cdrom_decode_status(drive, 0, &stat))
+	rc = cdrom_decode_status(drive, 0, &stat);
+	if (rc) {
+		if (rc == 2)
+			goto out_end;
 		return ide_stopped;
+	}
 
 	/* using dma, transfer is complete now */
 	if (dma) {
@@ -802,8 +801,6 @@ static ide_startstop_t cdrom_newpc_intr(
 					rq->cmd_flags |= REQ_FAILED;
 				uptodate = 0;
 			}
-			cdrom_end_request(drive, uptodate);
-			return ide_stopped;
 		} else if (!blk_pc_request(rq)) {
 			ide_cd_request_sense_fixup(drive, rq);
 			/* complain if we still have data left to transfer */
@@ -815,17 +812,16 @@ static ide_startstop_t cdrom_newpc_intr(
 	}
 
 	/* check which way to transfer data */
-	if (ide_cd_check_ireason(drive, rq, len, ireason, write))
-		return ide_stopped;
+	rc = ide_cd_check_ireason(drive, rq, len, ireason, write);
+	if (rc)
+		goto out_end;
 
 	if (blk_fs_request(rq)) {
 		if (write == 0) {
 			int nskip;
 
-			if (ide_cd_check_transfer_size(drive, len)) {
-				cdrom_end_request(drive, 0);
-				return ide_stopped;
-			}
+			if (ide_cd_check_transfer_size(drive, len))
+				goto out_end;
 
 			/*
 			 * First, figure out if we need to bit-bucket
@@ -918,7 +914,7 @@ static ide_startstop_t cdrom_newpc_intr(
 			else
 				rq->data += blen;
 		}
-		if (!write && blk_sense_request(rq))
+		if (sense && write == 0)
 			rq->sense_len += blen;
 	}
 
@@ -939,7 +935,7 @@ static ide_startstop_t cdrom_newpc_intr(
 	return ide_started;
 
 out_end:
-	if (blk_pc_request(rq)) {
+	if (blk_pc_request(rq) && rc == 0) {
 		unsigned int dlen = rq->data_len;
 
 		if (dma)
@@ -951,6 +947,8 @@ out_end:
 		hwif->rq = NULL;
 	} else {
 		cdrom_end_request(drive, uptodate);
+		if (sense && rc == 2)
+			ide_error(drive, "request sense failure", stat);
 	}
 	return ide_stopped;
 }
