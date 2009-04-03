Return-Path: <linux-kernel-owner+w=401wt.eu-S1760425AbZDCH70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425AbZDCH70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 03:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbZDCH6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 03:58:52 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:57463 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbZDCH6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 03:58:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ad7d9pGEFhpC144xSakb5IxNPT/VLGSSx1O5FYQabZHdsLk8MDiG1/lalxp+ZGANxz
         J1VuSIXCqSfZz4ez/WnCOgrHGorfF4i3eYNqoMUYDkEXmucO4NimtsM2lmZOtV9rpfra
         UHpETy/kg7V5HJfthdiemhnbOrvcg3+GsiUxw=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH 3/3] ide-cd: cdrom_decode_status: simplify do_end_request logic
Date: Fri,  3 Apr 2009 09:58:39 +0200
Message-Id: <1238745519-19389-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set do_end_request per default which results in several lines removed
and simplifying code flow. Also, add defines for cdrom_decode_status's
return codes instead of naked numbers.

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |   35 ++++++++++++-----------------------
 drivers/ide/ide-cd.h |    9 ++++++---
 2 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index bc37027..59a8bc2 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -301,17 +301,11 @@ static int ide_cd_breathe(ide_drive_t *drive, struct request *rq)
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
 	struct request *rq = hwif->rq;
-	int err, sense_key, do_end_request;
+	int err, sense_key, do_end_request = 1;
 
 	/* get the IDE error register */
 	err = ide_read_error(drive);
@@ -328,7 +322,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 		 * Just give up.
 		 */
 		rq->cmd_flags |= REQ_FAILED;
-		return 2;
+		return REQ_FAIL;
 	}
 
 	/* if we got an error, pass CHECK_CONDITION as the scsi status byte */
@@ -342,18 +336,17 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 	case NOT_READY:
 		if (blk_fs_request(rq) && (rq_data_dir(rq) == WRITE)) {
 			if (ide_cd_breathe(drive, rq))
-				return 1;
+				return REQ_RECOVER;
 		} else {
 			cdrom_saw_media_change(drive);
 			printk(KERN_ERR PFX "%s: tray open\n", drive->name);
 		}
-		do_end_request = 1;
 		break;
 
 	case UNIT_ATTENTION:
 		cdrom_saw_media_change(drive);
 		if (blk_pc_request(rq) || rq->cmd_type == REQ_TYPE_ATA_PC)
-			return 0;
+			return REQ_CONT;
 		break;
 
 	case ILLEGAL_REQUEST:
@@ -365,10 +358,10 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 		 *
 		 * cdrom_log_sense() knows this!
 		 */
-		if (rq->cmd[0] != GPCMD_START_STOP_UNIT) {
+		if (rq->cmd[0] != GPCMD_START_STOP_UNIT)
 			ide_dump_status(drive, "command error", stat);
-			do_end_request = 1;
-		}
+		else
+			do_end_request = 0;
 		break;
 
 	case MEDIUM_ERROR:
@@ -377,28 +370,24 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 		 * got here the error is not correctable.
 		 */
 		ide_dump_status(drive, "media error (bad sector)", stat);
-		do_end_request = 1;
 		break;
 
 	case BLANK_CHECK:
 		/* disk appears blank ?? */
 		ide_dump_status(drive, "media error (blank)", stat);
-		do_end_request = 1;
 		break;
 
 	default:
 		if (err & ~ATA_ABORTED) {
 			/* go to the default handler for other errors */
 			ide_error(drive, "cdrom_decode_status", stat);
-			return 1;
+			return REQ_RECOVER;
 		}
 
 		if (!(rq->cmd_flags & REQ_QUIET)) {
 			ide_dump_status(drive, "command error", stat);
 			blk_dump_rq_flags(rq, PFX "failing rq");
 		}
-
-		do_end_request = 1;
 		break;
 	}
 
@@ -415,7 +404,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 	if (stat & ATA_ERR)
 		cdrom_queue_request_sense(drive, NULL, NULL);
 
-	return 1;
+	return REQ_RECOVER;
 
 end_request:
 	if (stat & ATA_ERR) {
@@ -429,9 +418,9 @@ end_request:
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
index 1d97101..a233896 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -18,15 +18,18 @@
 
 #define ATAPI_WAIT_WRITE_BUSY	(10 * HZ)
 
-/************************************************************************/
-
-#define SECTOR_BITS 		9
+#define SECTOR_BITS		9
 #ifndef SECTOR_SIZE
 #define SECTOR_SIZE		(1 << SECTOR_BITS)
 #endif
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

