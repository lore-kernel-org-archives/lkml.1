Return-Path: <linux-kernel-owner+w=401wt.eu-S1764050AbZD3Qzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764050AbZD3Qzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 12:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759533AbZD3Qzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 12:55:38 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:51874 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758805AbZD3Qzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 12:55:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=eBgD29G/nyhpZ0/EE9q/lYKBm0KYgYUZdaiAWJjO6Ud0A3ZPG4vZQaKrqy7JI4OEij
         oAIjXAix1L2/Hut2bgAQeyAiH9IgoQtGz/JxInJNN1eq8XhBb7DQk9ov+akzbJ+ZFzqX
         sPrMdozu0qJxPr3Wc7ULZdjdk1QBUZxB5qDLE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE fix
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Thu, 30 Apr 2009 19:00:03 +0200
Message-Id: <200904301900.04026.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix bogus ide-cd error messages being printed.


Linus, please pull from 'for-linus' branch of:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git for-linus

to receive the following updates:

 drivers/ide/ide-cd.c   |    9 ++++-----
 include/linux/blkdev.h |    1 +
 2 files changed, 5 insertions(+), 5 deletions(-)


Borislav Petkov (1):
      ide-cd: fix REQ_QUIET tests in cdrom_decode_status


diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 3d4e099..925eb9e 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -312,7 +312,6 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->rq;
 	int err, sense_key, do_end_request = 0;
-	u8 quiet = rq->cmd_flags & REQ_QUIET;
 
 	/* get the IDE error register */
 	err = ide_read_error(drive);
@@ -347,7 +346,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 		} else {
 			cdrom_saw_media_change(drive);
 
-			if (blk_fs_request(rq) && !quiet)
+			if (blk_fs_request(rq) && !blk_rq_quiet(rq))
 				printk(KERN_ERR PFX "%s: tray open\n",
 					drive->name);
 		}
@@ -382,7 +381,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 		 * No point in retrying after an illegal request or data
 		 * protect error.
 		 */
-		if (!quiet)
+		if (!blk_rq_quiet(rq))
 			ide_dump_status(drive, "command error", stat);
 		do_end_request = 1;
 		break;
@@ -391,14 +390,14 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 		 * No point in re-trying a zillion times on a bad sector.
 		 * If we got here the error is not correctable.
 		 */
-		if (!quiet)
+		if (!blk_rq_quiet(rq))
 			ide_dump_status(drive, "media error "
 					"(bad sector)", stat);
 		do_end_request = 1;
 		break;
 	case BLANK_CHECK:
 		/* disk appears blank? */
-		if (!quiet)
+		if (!blk_rq_quiet(rq))
 			ide_dump_status(drive, "media error (blank)",
 					stat);
 		do_end_request = 1;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ba54c83..6f841fb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -598,6 +598,7 @@ enum {
 				 blk_failfast_transport(rq) ||	\
 				 blk_failfast_driver(rq))
 #define blk_rq_started(rq)	((rq)->cmd_flags & REQ_STARTED)
+#define blk_rq_quiet(rq)	((rq)->cmd_flags & REQ_QUIET)
 
 #define blk_account_rq(rq)	(blk_rq_started(rq) && (blk_fs_request(rq) || blk_discard_rq(rq))) 
 
