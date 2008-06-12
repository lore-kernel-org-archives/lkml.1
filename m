Return-Path: <linux-kernel-owner+w=401wt.eu-S1759261AbYFLGp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261AbYFLGp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756574AbYFLGli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:41:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:8408 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbYFLGlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:41:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=UT4a57s2HovufRZPA8UtUWAXLpr9LOrTsitVDorGZOq0A36rdZA39nnNgm69qx855p
         aCiB2IS8RKERY6Rszwb9gdx+QttXT5pNd+e8y+5z4Znl7v9/2kdrgF2lGDRAjGWsEBgE
         YMchyAv4ct4PaV3wHSQToV0qN7SyNbtgvmKsk=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 08/18] ide-cd: simplify request issuing path
Date: Thu, 12 Jun 2008 08:41:00 +0200
Message-Id: <1213252870-20474-9-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

call cdrom_start_packet_command() only from the do_request()
routine. As a nice side effect, this improves code readability a bit.

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |   39 +++++++++++++++++++++------------------
 1 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index e9d9363..abf9af2 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -778,14 +778,12 @@ static ide_startstop_t cdrom_start_seek_continuation(ide_drive_t *drive)
 	return cdrom_transfer_packet_command(drive, rq, &cdrom_seek_intr);
 }
 
-static ide_startstop_t cdrom_start_seek(ide_drive_t *drive)
+static void cdrom_start_seek(ide_drive_t *drive)
 {
 	struct cdrom_info *info = drive->driver_data;
 
 	info->dma = 0;
 	info->start_seek = jiffies;
-	return cdrom_start_packet_command(drive, 0,
-					  cdrom_start_seek_continuation);
 }
 
 /*
@@ -1160,8 +1158,7 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 	if (write)
 		cd->devinfo.media_written = 1;
 
-	/* start sending the read/write request to the drive */
-	return cdrom_start_packet_command(drive, 32768, cdrom_start_rw_cont);
+	return ide_started;
 }
 
 static ide_startstop_t cdrom_do_newpc_cont(ide_drive_t *drive)
@@ -1174,7 +1171,7 @@ static ide_startstop_t cdrom_do_newpc_cont(ide_drive_t *drive)
 	return cdrom_transfer_packet_command(drive, rq, cdrom_newpc_intr);
 }
 
-static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
+static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 {
 	struct cdrom_info *info = drive->driver_data;
 
@@ -1202,10 +1199,6 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 		if ((rq->data_len & 15) || (addr & mask))
 			info->dma = 0;
 	}
-
-	/* start sending the command to the drive */
-	return cdrom_start_packet_command(drive, rq->data_len,
-					  cdrom_do_newpc_cont);
 }
 
 /*
@@ -1214,8 +1207,9 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 					sector_t block)
 {
-	ide_startstop_t action;
 	struct cdrom_info *info = drive->driver_data;
+	ide_handler_t *fn;
+	int xferlen;
 
 	if (blk_fs_request(rq)) {
 		if (info->cd_flags & IDE_CD_FLAG_SEEKING) {
@@ -1235,16 +1229,23 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 		}
 		if (rq_data_dir(rq) == READ &&
 		    IDE_LARGE_SEEK(info->last_block, block,
-				   IDECD_SEEK_THRESHOLD) &&
-		    drive->dsc_overlap)
-			action = cdrom_start_seek(drive);
-		else
-			action = cdrom_start_rw(drive, rq);
+			    IDECD_SEEK_THRESHOLD) &&
+		    drive->dsc_overlap) {
+			xferlen = 0;
+			fn = cdrom_start_seek_continuation;
+			cdrom_start_seek(drive);
+		} else {
+			xferlen = 32768;
+			fn = cdrom_start_rw_cont;
+			if (cdrom_start_rw(drive, rq) == ide_stopped)
+				return ide_stopped;
+		}
 		info->last_block = block;
-		return action;
 	} else if (blk_sense_request(rq) || blk_pc_request(rq) ||
 		   rq->cmd_type == REQ_TYPE_ATA_PC) {
-		return cdrom_do_block_pc(drive, rq);
+		xferlen = rq->data_len;
+		fn = cdrom_do_newpc_cont;
+		cdrom_do_block_pc(drive, rq);
 	} else if (blk_special_request(rq)) {
 		/* right now this can only be a reset... */
 		cdrom_end_request(drive, 1);
@@ -1254,6 +1255,8 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 		cdrom_end_request(drive, 0);
 		return ide_stopped;
 	}
+
+	return cdrom_start_packet_command(drive, xferlen, fn);
 }
 
 
-- 
1.5.5.1

