Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbZDEGqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbZDEGqu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 02:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbZDEGqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 02:46:39 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:45395 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbZDEGqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 02:46:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=oytjisVr4z/4c2R3ggbXynuo7xowhKbVydD4tTz1Y3grzHgPRkubrulblUnbZRAEvU
         Z+rbSLh02KhjuXaLLc58f0IHcD9HkNVzZzNYEL2Cs3e8DNFCw0cgYDrBWQr3fzcRQcgC
         AuF6YnRRPfI+OfIh0/zdS/rZh0CYQ94yZrH+I=
Date: Sun, 5 Apr 2009 08:46:31 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] ide-cd: unify handling of fs and pc requests in
	cdrom_decode_status()
Message-ID: <20090405064631.GB774@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090403195757.31438.16866.sendpatchset@localhost.localdomain> <20090403195817.31438.45522.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090403195817.31438.45522.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 09:58:17PM +0200, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide-cd: unify handling of fs and pc requests in cdrom_decode_status()

Rediffed:
---
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Fri, 3 Apr 2009 21:58:17 +0200
Subject: [PATCH] ide-cd: unify handling of fs and pc requests in cdrom_decode_status()

Unify handling of fs and pc requests in cdrom_decode_status().

While at it:
- remove unreachable code

The only change in functionality is that for pc requests more
detailed error message will be printed for following sense keys:
* ILLEGAL_REQUEST
* DATA_PROTECT
* MEDIUM_ERROR
* BLANK_CHECK

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   69 +++++++++++++++++--------------------------------
 1 files changed, 24 insertions(+), 45 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 43db330..ffbaa6d 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -330,8 +330,8 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 		 */
 		rq->cmd_flags |= REQ_FAILED;
 		return 2;
-	} else if (blk_pc_request(rq) || rq->cmd_type == REQ_TYPE_ATA_PC) {
-		/* All other functions, except for READ. */
+	} else {
+		int do_end_request = 0;
 
 		/*
 		 * if we have an error, pass back CHECK_CONDITION as the
@@ -340,53 +340,16 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 		if (blk_pc_request(rq) && !rq->errors)
 			rq->errors = SAM_STAT_CHECK_CONDITION;
 
-		switch (sense_key) {
-		case NOT_READY:
-			cdrom_saw_media_change(drive);
-			break;
-		case UNIT_ATTENTION:
-			cdrom_saw_media_change(drive);
-			return 0;
-		case ILLEGAL_REQUEST:
-			/*
-			 * Don't print error message for this condition--
-			 * SFF8090i indicates that 5/24/00 is the correct
-			 * response to a request to close the tray if the
-			 * drive doesn't have that capability.
-			 * cdrom_log_sense() knows this!
-			 */
-			if (rq->cmd[0] == GPCMD_START_STOP_UNIT)
-				break;
-			/* fall-through */
-		default:
-			if (!quiet)
-				ide_dump_status(drive, "packet command error",
-						stat);
-		}
-
-		rq->cmd_flags |= REQ_FAILED;
-
-		/*
-		 * instead of playing games with moving completions around,
-		 * remove failed request completely and end it when the
-		 * request sense has completed
-		 */
-		goto end_request;
-
-	} else if (blk_fs_request(rq)) {
-		int do_end_request = 0;
-
-		/* handle errors from READ and WRITE requests */
-
 		if (blk_noretry_request(rq))
 			do_end_request = 1;
 
 		switch (sense_key) {
 		case NOT_READY:
-			if (rq_data_dir(rq) == READ) {
+			if (blk_fs_request(rq) == 0 ||
+			    rq_data_dir(rq) == READ) {
 				cdrom_saw_media_change(drive);
 
-				if (!quiet)
+				if (blk_fs_request(rq) && !quiet)
 					printk(KERN_ERR PFX "%s: tray open\n",
 						drive->name);
 			} else {
@@ -398,6 +361,8 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 		case UNIT_ATTENTION:
 			cdrom_saw_media_change(drive);
 
+			if (blk_fs_request(rq) == 0)
+				return 0;
 			/*
 			 * Arrange to retry the request but be sure to give up
 			 * if we've retried too many times.
@@ -406,6 +371,16 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 				do_end_request = 1;
 			break;
 		case ILLEGAL_REQUEST:
+			/*
+			 * Don't print error message for this condition--
+			 * SFF8090i indicates that 5/24/00 is the correct
+			 * response to a request to close the tray if the
+			 * drive doesn't have that capability.
+			 * cdrom_log_sense() knows this!
+			 */
+			if (rq->cmd[0] == GPCMD_START_STOP_UNIT)
+				break;
+			/* fall-through */
 		case DATA_PROTECT:
 			/*
 			 * No point in retrying after an illegal request or data
@@ -433,6 +408,8 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 			do_end_request = 1;
 			break;
 		default:
+			if (blk_fs_request(rq) == 0)
+				break;
 			if (err & ~ATA_ABORTED) {
 				/* go to the default handler for other errors */
 				ide_error(drive, "cdrom_decode_status", stat);
@@ -442,6 +419,11 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 				do_end_request = 1;
 		}
 
+		if (blk_fs_request(rq) == 0) {
+			rq->cmd_flags |= REQ_FAILED;
+			do_end_request = 1;
+		}
+
 		/*
 		 * End a request through request sense analysis when we have
 		 * sense data. We need this in order to perform end of media
@@ -457,9 +439,6 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 		if (stat & ATA_ERR)
 			cdrom_queue_request_sense(drive, NULL, NULL);
 		return 1;
-	} else {
-		blk_dump_rq_flags(rq, PFX "bad rq");
-		return 2;
 	}
 
 end_request:
-- 
1.6.2.1

-- 
Regards/Gruss,
    Boris.
