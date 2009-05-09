Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbZEIHtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbZEIHtv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 03:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZEIHqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 03:46:03 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:62473 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbZEIHpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 03:45:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=s3nJAlM8brItgEYVxLOog49ssWc7Kye2FcOab29wY8zslBp48t4N3qbr95dx48Zefe
         XVmfLF0ymriLqYYSM091XZgBAHsu9dtSJy+Y3AgLi0sKKTJ536F9uYkjozgbwb3J4VEX
         TuyBy32M5m64YhKcq1F5A3MThxQe1T388HRgk=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/14] ide-cd: use whole request_sense buffer in EH
Date: Sat,  9 May 2009 09:45:33 +0200
Message-Id: <1241855134-4984-14-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we use a static request_sense buffer, use it instead of the
first 18 bytes only. Also, remove sense-arg to cdrom_analyze_sense_data
and cdrom_log_sense since we can access it through drive->sense_data
now.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 1a58b38..f6fb29b 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -92,16 +92,16 @@ static void cdrom_saw_media_change(ide_drive_t *drive)
 	drive->atapi_flags &= ~IDE_AFLAG_TOC_VALID;
 }
 
-static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
-			   struct request_sense *sense)
+static int cdrom_log_sense(ide_drive_t *drive, struct request *rq)
 {
+	struct request_sense *sense = &drive->sense_data;
 	int log = 0;
 
-	ide_debug_log(IDE_DBG_SENSE, "sense_key: 0x%x", sense->sense_key);
-
 	if (!sense || !rq || (rq->cmd_flags & REQ_QUIET))
 		return 0;
 
+	ide_debug_log(IDE_DBG_SENSE, "sense_key: 0x%x", sense->sense_key);
+
 	switch (sense->sense_key) {
 	case NO_SENSE:
 	case RECOVERED_ERROR:
@@ -140,12 +140,12 @@ static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
 }
 
 static void cdrom_analyze_sense_data(ide_drive_t *drive,
-			      struct request *failed_command,
-			      struct request_sense *sense)
+				     struct request *failed_command)
 {
+	struct request_sense *sense = &drive->sense_data;
+	struct cdrom_info *info = drive->driver_data;
 	unsigned long sector;
 	unsigned long bio_sectors;
-	struct cdrom_info *info = drive->driver_data;
 
 	ide_debug_log(IDE_DBG_SENSE, "error_code: 0x%x, sense_key: 0x%x",
 				     sense->error_code, sense->sense_key);
@@ -154,7 +154,7 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
 		ide_debug_log(IDE_DBG_SENSE, "failed cmd: 0x%x",
 					     failed_command->cmd[0]);
 
-	if (!cdrom_log_sense(drive, failed_command, sense))
+	if (!cdrom_log_sense(drive, failed_command))
 		return;
 
 	/*
@@ -225,15 +225,14 @@ static void ide_cd_complete_failed_rq(ide_drive_t *drive, struct request *rq)
 			 * sense pointer set.
 			 */
 			memcpy(failed->sense, sense, 18);
-			sense = failed->sense;
 			failed->sense_len = rq->sense_len;
 		}
-		cdrom_analyze_sense_data(drive, failed, sense);
+		cdrom_analyze_sense_data(drive, failed);
 
 		if (ide_end_rq(drive, failed, -EIO, blk_rq_bytes(failed)))
 			BUG();
 	} else
-		cdrom_analyze_sense_data(drive, NULL, sense);
+		cdrom_analyze_sense_data(drive, NULL);
 }
 
 
-- 
1.6.2.4

