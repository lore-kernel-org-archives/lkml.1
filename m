Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbZDEJQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbZDEJQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 05:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbZDEJQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 05:16:14 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:30919 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbZDEJQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 05:16:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PbG99f+N8SYv4oYKEdHCiFG4XHaAqZvWOzViRfb+uZlxf7r2KshgiM4MQWy2N7wpD2
         PvP7KzzGNepeftg7T9z+tur/qOIsbMTM/3kHl1Tl42a9YRKqCJkyeZysEKCFqP4d3u0c
         0OvJQNwzotkVEiiFNs5bQrQZg7t4wCQ1J4L2I=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH 2/2] ide-cd: cdrom_decode_status: use return codes instead of naked numbers
Date: Sun,  5 Apr 2009 11:16:02 +0200
Message-Id: <1238922962-19727-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused SECTOR_SIZE while at it.

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |   22 ++++++++--------------
 drivers/ide/ide-cd.h |   12 ++++++------
 2 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 2aa13d8..1dc61fc 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -301,12 +301,6 @@ static int ide_cd_breathe(ide_drive_t *drive, struct request *rq)
 	}
 }
 
-/**
- * Returns:
- * 0: if the request should be continued.
- * 1: if the request will be going through error recovery.
- * 2: if the request should be ended.
- */
 static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -329,7 +323,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 		 * Just give up.
 		 */
 		rq->cmd_flags |= REQ_FAILED;
-		return 2;
+		return REQ_FAIL;
 	}
 
 	/* if we have an error, pass CHECK_CONDITION as the SCSI status byte */
@@ -343,7 +337,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 	case NOT_READY:
 		if (blk_fs_request(rq) && rq_data_dir(rq) == WRITE) {
 			if (ide_cd_breathe(drive, rq))
-				return 1;
+				return REQ_RECOVER;
 		} else {
 			cdrom_saw_media_change(drive);
 
@@ -357,7 +351,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 		cdrom_saw_media_change(drive);
 
 		if (blk_fs_request(rq) == 0)
-			return 0;
+			return REQ_CONT;
 
 		/*
 		 * Arrange to retry the request but be sure to give up if we've
@@ -409,7 +403,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 		if (err & ~ATA_ABORTED) {
 			/* go to the default handler for other errors */
 			ide_error(drive, "cdrom_decode_status", stat);
-			return 1;
+			return REQ_RECOVER;
 		} else if (++rq->errors > ERROR_MAX)
 			/* we've racked up too many retries, abort */
 			do_end_request = 1;
@@ -431,7 +425,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 	/* if we got a CHECK_CONDITION status, queue a request sense command */
 	if (stat & ATA_ERR)
 		cdrom_queue_request_sense(drive, NULL, NULL);
-	return 1;
+	return REQ_RECOVER;
 
 end_request:
 	if (stat & ATA_ERR) {
@@ -445,9 +439,9 @@ end_request:
 		hwif->rq = NULL;
 
 		cdrom_queue_request_sense(drive, rq->sense, rq);
-		return 1;
-	} else
-		return 2;
+		return REQ_RECOVER;
+	}
+	return REQ_FAIL;
 }
 
 /*
diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index 1d97101..7e17e70 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -18,15 +18,15 @@
 
 #define ATAPI_WAIT_WRITE_BUSY	(10 * HZ)
 
-/************************************************************************/
-
-#define SECTOR_BITS 		9
-#ifndef SECTOR_SIZE
-#define SECTOR_SIZE		(1 << SECTOR_BITS)
-#endif
+#define SECTOR_BITS		9
 #define SECTORS_PER_FRAME	(CD_FRAMESIZE >> SECTOR_BITS)
 #define SECTOR_BUFFER_SIZE	(CD_FRAMESIZE * 32)
 
+/* internal decode_status codes */
+#define REQ_CONT               0
+#define REQ_RECOVER            1
+#define REQ_FAIL               2
+
 /* Capabilities Page size including 8 bytes of Mode Page Header */
 #define ATAPI_CAPABILITIES_PAGE_SIZE		(8 + 20)
 #define ATAPI_CAPABILITIES_PAGE_PAD_SIZE	4
-- 
1.6.2.1

