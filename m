Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbYLPHiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbYLPHiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 02:38:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbYLPHgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 02:36:24 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:41485 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbYLPHgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 02:36:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=al0raihqg1ialqaz7OADFs8Z7TGlK688gdWzJwIw+hvLbhRqqHzkvVpog6MGGAM49y
         s3Hvq7St6KU/X7bGwpy0gw8GjXB8TdjBP6ArWvkvTcnPqWuBE37Le0VR47Q8jrA9KoNB
         kPX/4MG38TZAUxPV4LwtPV86obw8LOXstD/U0=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 8/9] ide-atapi: replace pc->error with drive->pc_error
Date: Tue, 16 Dec 2008 08:36:08 +0100
Message-Id: <1229412969-3552-9-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229412969-3552-1-git-send-email-petkovbb@gmail.com>
References: <1229412969-3552-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c  |    3 ++-
 drivers/ide/ide-floppy.c |    6 +++---
 drivers/ide/ide-tape.c   |   20 ++++++++++----------
 include/linux/ide.h      |    1 +
 4 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index e514b47..160d085 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -124,6 +124,7 @@ void ide_init_pc(ide_drive_t *drive, struct ide_atapi_pc *pc)
 	drive->pc_buf_size = IDE_PC_BUFFER_SIZE;
 	drive->pc_flags = 0;
 	drive->pc_req_xfer = 0;
+	drive->pc_error = 0;
 }
 EXPORT_SYMBOL_GPL(ide_init_pc);
 
@@ -377,7 +378,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 			/* queued, but not started */
 			return ide_stopped;
 		}
-		pc->error = 0;
+		drive->pc_error = 0;
 
 		if ((drive->pc_flags & PC_FLAG_WAIT_FOR_DSC) &&
 		    (stat & ATA_DSC) == 0)
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 0977229..3d6345e 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -119,7 +119,7 @@ static void ide_floppy_callback(ide_drive_t *drive, int dsc)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
 	struct ide_atapi_pc *pc = drive->pc;
-	int uptodate = pc->error ? 0 : 1;
+	int uptodate = drive->pc_error ? 0 : 1;
 
 	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
 
@@ -132,7 +132,7 @@ static void ide_floppy_callback(ide_drive_t *drive, int dsc)
 	else if (pc->c[0] == GPCMD_REQUEST_SENSE) {
 		u8 *buf = pc->buf;
 
-		if (!pc->error) {
+		if (!drive->pc_error) {
 			floppy->sense_key = buf[2] & 0x0F;
 			floppy->asc = buf[12];
 			floppy->ascq = buf[13];
@@ -186,7 +186,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 		if (!(drive->pc_flags & PC_FLAG_SUPPRESS_ERROR))
 			ide_floppy_report_error(floppy, pc);
 		/* Giving up */
-		pc->error = IDEFLOPPY_ERROR_GENERAL;
+		drive->pc_error = IDEFLOPPY_ERROR_GENERAL;
 
 		floppy->failed_pc = NULL;
 		drive->pc_callback(drive, 0);
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 2bfa612..015b417 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -429,25 +429,25 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	    && pc->c[4] == 0 && pc->c[3] == 0 && pc->c[2] == 0) {
 		if (tape->sense_key == 5) {
 			/* don't report an error, everything's ok */
-			pc->error = 0;
+			drive->pc_error = 0;
 			/* don't retry read/write */
 			drive->pc_flags |= PC_FLAG_ABORT;
 		}
 	}
 	if (pc->c[0] == READ_6 && (sense[2] & 0x80)) {
-		pc->error = IDETAPE_ERROR_FILEMARK;
+		drive->pc_error = IDETAPE_ERROR_FILEMARK;
 		drive->pc_flags |= PC_FLAG_ABORT;
 	}
 	if (pc->c[0] == WRITE_6) {
 		if ((sense[2] & 0x40) || (tape->sense_key == 0xd
 		     && tape->asc == 0x0 && tape->ascq == 0x2)) {
-			pc->error = IDETAPE_ERROR_EOD;
+			drive->pc_error = IDETAPE_ERROR_EOD;
 			drive->pc_flags |= PC_FLAG_ABORT;
 		}
 	}
 	if (pc->c[0] == READ_6 || pc->c[0] == WRITE_6) {
 		if (tape->sense_key == 8) {
-			pc->error = IDETAPE_ERROR_EOD;
+			drive->pc_error = IDETAPE_ERROR_EOD;
 			drive->pc_flags |= PC_FLAG_ABORT;
 		}
 		if (!(drive->pc_flags & PC_FLAG_ABORT) && rq->data_len)
@@ -515,7 +515,7 @@ static void ide_tape_callback(ide_drive_t *drive, int dsc)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc = drive->pc;
-	int uptodate = pc->error ? 0 : 1;
+	int uptodate = drive->pc_error ? 0 : 1;
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
@@ -547,8 +547,8 @@ static void ide_tape_callback(ide_drive_t *drive, int dsc)
 		tape->first_frame += blocks;
 		rq->current_nr_sectors -= blocks;
 
-		if (pc->error)
-			uptodate = pc->error;
+		if (drive->pc_error)
+			uptodate = drive->pc_error;
 	} else if (pc->c[0] == READ_POSITION && uptodate) {
 		u8 *readpos = pc->buf;
 
@@ -685,7 +685,7 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
 						tape->ascq);
 			}
 			/* Giving up */
-			pc->error = IDETAPE_ERROR_GENERAL;
+			drive->pc_error = IDETAPE_ERROR_GENERAL;
 		}
 		tape->failed_pc = NULL;
 		drive->pc_callback(drive, 0);
@@ -746,9 +746,9 @@ static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 			ide_retry_pc(drive, tape->disk);
 			return ide_stopped;
 		}
-		pc->error = 0;
+		drive->pc_error = 0;
 	} else {
-		pc->error = IDETAPE_ERROR_GENERAL;
+		drive->pc_error = IDETAPE_ERROR_GENERAL;
 		tape->failed_pc = NULL;
 	}
 	drive->pc_callback(drive, 0);
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 0940db9..291600c 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -658,6 +658,7 @@ struct ide_drive_s {
 	unsigned long pc_flags;
 	int pc_req_xfer;
 	int pc_buf_size;
+	int pc_error;
 
 	/* callback for packet commands */
 	void (*pc_callback)(struct ide_drive_s *, int);
-- 
1.6.0.4

