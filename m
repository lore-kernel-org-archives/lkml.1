Return-Path: <linux-kernel-owner+w=401wt.eu-S1761551AbYAKMHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761551AbYAKMHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 07:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758010AbYAKMD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 07:03:57 -0500
Received: from smtp115.plus.mail.re1.yahoo.com ([69.147.102.78]:34571 "HELO
	smtp115.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759053AbYAKMDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:03:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=wV9oIjindAJ6gK63S15kXKmGjSofA4encZ9oak7fXDgM97m0MJ+6PL15DPcSIiSZClSnwAsHrWxE/k9BymkGvkrxYg/RiO9b31DCpLQ+oa1MeM35QbYrNrrLKQ0takOulUvlqQ5PbYr133Mgy/f4ggsUlIOTzyPj9kvuA2bRwPY=  ;
X-YMail-OSG: bwvSo1EVM1mN9VuIARfe3UFGJVL_UNlSesMx1L8lgGVZ8rwhYaglr9N0N2D1gC.uWC_JRHG11A--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej@gollum.tnic, Zolnierkiewicz@gollum.tnic, <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 14/21] ide-floppy: mv idefloppy_{should_,}report_error
Date: Fri, 11 Jan 2008 12:58:12 +0100
Message-Id: <1200052699-28420-15-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200052699-28420-14-git-send-email-bbpetkov@yahoo.de>
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-2-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-3-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-4-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-5-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-6-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-7-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-8-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-9-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-10-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-11-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-12-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-13-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-14-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to shortening the function name, move the printk-call into the
function thereby saving some code lines. Also, make the function out_of_line
since it is not on a performance critical path.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |   37 ++++++++++++++-----------------------
 1 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 49d83a1..b718615 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -707,16 +707,18 @@ static ide_startstop_t idefloppy_transfer_pc1(ide_drive_t *drive)
 	return ide_started;
 }
 
-/*
- * Suppresses error messages resulting from Medium not present.
- */
-static inline int idefloppy_should_report_error(idefloppy_floppy_t *floppy)
+static void idefloppy_report_error(idefloppy_floppy_t *floppy,
+		idefloppy_pc_t *pc)
 {
 	if (floppy->sense_key == 0x02 &&
 	    floppy->asc       == 0x3a &&
 	    floppy->ascq      == 0x00)
-		return 0;
-	return 1;
+		return;
+
+	printk(KERN_ERR "ide-floppy: %s: I/O error, pc = %2x, key = %2x, "
+			"asc = %2x, ascq = %2x\n",
+			floppy->drive->name, pc->c[0], floppy->sense_key,
+			floppy->asc, floppy->ascq);
 }
 
 static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
@@ -741,15 +743,8 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 		 *	a legitimate error code was received.
 		 */
 		if (!test_bit(PC_ABORT, &pc->flags)) {
-			if (!test_bit(PC_SUPPRESS_ERROR, &pc->flags)) {
-				if (idefloppy_should_report_error(floppy))
-					printk(KERN_ERR "ide-floppy: %s: I/O error, "
-					       "pc = %2x, key = %2x, "
-					       "asc = %2x, ascq = %2x\n",
-					       drive->name, pc->c[0],
-					       floppy->sense_key,
-					       floppy->asc, floppy->ascq);
-			}
+			if (!test_bit(PC_SUPPRESS_ERROR, &pc->flags))
+				idefloppy_report_error(floppy, pc);
 			/* Giving up */
 			pc->error = IDEFLOPPY_ERROR_GENERAL;
 		}
@@ -958,16 +953,12 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 			rq->nr_sectors, rq->current_nr_sectors);
 
 	if (rq->errors >= ERROR_MAX) {
-		if (floppy->failed_pc != NULL) {
-			if (idefloppy_should_report_error(floppy))
-				printk(KERN_ERR "ide-floppy: %s: I/O error, pc = %2x,"
-				       " key = %2x, asc = %2x, ascq = %2x\n",
-				       drive->name, floppy->failed_pc->c[0],
-				       floppy->sense_key, floppy->asc, floppy->ascq);
-		}
+		if (floppy->failed_pc != NULL)
+			idefloppy_report_error(floppy, floppy->failed_pc);
 		else
 			printk(KERN_ERR "ide-floppy: %s: I/O error\n",
-				drive->name);
+					drive->name);
+
 		idefloppy_do_end_request(drive, 0, 0);
 		return ide_stopped;
 	}
-- 
1.5.3.7

