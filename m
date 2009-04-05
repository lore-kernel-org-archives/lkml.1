Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbZDEGJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbZDEGJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 02:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbZDEGJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 02:09:19 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:50459 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789AbZDEGJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 02:09:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=eyyh/M2MQgf//oyqcH+QWCIbau1m9nS/5AtYKtaOIOYtdp9ntAmnxJ7KF3I3bfGdpA
         SNCLin+ZP22GKam1SLPhhn4O2aXtDK/Jx9hOG7/x4CtvXFk+NLCKL1/+yF8LDYkRrR0g
         s9S2ElqUSOcAWXl9IZRDPEDmXPGiAeIsW7VWs=
Date: Sun, 5 Apr 2009 08:09:11 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] ide-cd: convert cdrom_decode_status() to use
	switch statements
Message-ID: <20090405060911.GC4189@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090403195757.31438.16866.sendpatchset@localhost.localdomain> <20090403195810.31438.66965.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090403195810.31438.66965.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 09:58:10PM +0200, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide-cd: convert cdrom_decode_status() to use switch statements

Here's a rediffed version:
---
From: Borislav Petkov <petkovbb@gmail.com>
Date: Sun, 5 Apr 2009 08:07:17 +0200
Subject: [PATCH] ide-cd: convert cdrom_decode_status() to use switch statements

Convert cdrom_decode_status() to use switch statements in
preparation to unify handling of fs and pc requests.

While at it:
- remove superfluous comments and do minor CodingStyle fixups

There should be no functional changes caused by this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   57 ++++++++++++++++++++++++++++----------------------
 1 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index d95a2f0..df01b91 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -304,15 +304,14 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 		if (blk_pc_request(rq) && !rq->errors)
 			rq->errors = SAM_STAT_CHECK_CONDITION;
 
-		/* check for tray open */
-		if (sense_key == NOT_READY) {
+		switch (sense_key) {
+		case NOT_READY:
 			cdrom_saw_media_change(drive);
-		} else if (sense_key == UNIT_ATTENTION) {
-			/* check for media change */
+			break;
+		case UNIT_ATTENTION:
 			cdrom_saw_media_change(drive);
 			return 0;
-		} else if (sense_key == ILLEGAL_REQUEST &&
-			   rq->cmd[0] == GPCMD_START_STOP_UNIT) {
+		case ILLEGAL_REQUEST:
 			/*
 			 * Don't print error message for this condition--
 			 * SFF8090i indicates that 5/24/00 is the correct
@@ -320,9 +319,13 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 			 * drive doesn't have that capability.
 			 * cdrom_log_sense() knows this!
 			 */
-		} else if (!quiet) {
-			/* otherwise, print an error */
-			ide_dump_status(drive, "packet command error", stat);
+			if (rq->cmd[0] == GPCMD_START_STOP_UNIT)
+				break;
+			/* fall-through */
+		default:
+			if (!quiet)
+				ide_dump_status(drive, "packet command error",
+						stat);
 		}
 
 		rq->cmd_flags |= REQ_FAILED;
@@ -342,12 +345,11 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 		if (blk_noretry_request(rq))
 			do_end_request = 1;
 
-		if (sense_key == NOT_READY) {
-			/* tray open */
+		switch (sense_key) {
+		case NOT_READY:
 			if (rq_data_dir(rq) == READ) {
 				cdrom_saw_media_change(drive);
 
-				/* fail the request */
 				if (!quiet)
 					printk(KERN_ERR PFX "%s: tray open\n",
 						drive->name);
@@ -381,8 +383,8 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 					return 1;
 				}
 			}
-		} else if (sense_key == UNIT_ATTENTION) {
-			/* media change */
+		break;
+		case UNIT_ATTENTION:
 			cdrom_saw_media_change(drive);
 
 			/*
@@ -391,8 +393,9 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 			 */
 			if (++rq->errors > ERROR_MAX)
 				do_end_request = 1;
-		} else if (sense_key == ILLEGAL_REQUEST ||
-			   sense_key == DATA_PROTECT) {
+			break;
+		case ILLEGAL_REQUEST:
+		case DATA_PROTECT:
 			/*
 			 * No point in retrying after an illegal request or data
 			 * protect error.
@@ -400,7 +403,8 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 			if (!quiet)
 				ide_dump_status(drive, "command error", stat);
 			do_end_request = 1;
-		} else if (sense_key == MEDIUM_ERROR) {
+			break;
+		case MEDIUM_ERROR:
 			/*
 			 * No point in re-trying a zillion times on a bad
 			 * sector. If we got here the error is not correctable.
@@ -409,19 +413,22 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 				ide_dump_status(drive, "media error "
 						"(bad sector)",	stat);
 			do_end_request = 1;
-		} else if (sense_key == BLANK_CHECK) {
+			break;
+		case BLANK_CHECK:
 			/* disk appears blank ?? */
 			if (!quiet)
 				ide_dump_status(drive, "media error (blank)",
 						stat);
 			do_end_request = 1;
-		} else if ((err & ~ATA_ABORTED) != 0) {
-			/* go to the default handler for other errors */
-			ide_error(drive, "cdrom_decode_status", stat);
-			return 1;
-		} else if ((++rq->errors > ERROR_MAX)) {
-			/* we've racked up too many retries, abort */
-			do_end_request = 1;
+			break;
+		default:
+			if (err & ~ATA_ABORTED) {
+				/* go to the default handler for other errors */
+				ide_error(drive, "cdrom_decode_status", stat);
+				return 1;
+			} else if (++rq->errors > ERROR_MAX)
+				/* we've racked up too many retries, abort */
+				do_end_request = 1;
 		}
 
 		/*
-- 
1.6.2.1

-- 
Regards/Gruss,
    Boris.
