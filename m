Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbYAMUZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbYAMUZT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 15:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbYAMUWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 15:22:31 -0500
Received: from smtp114.plus.mail.re1.yahoo.com ([69.147.102.77]:48711 "HELO
	smtp114.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753702AbYAMUWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 15:22:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=PmTIV/Ruo0JQKVyLxU9mx9g01mcGZHH+PhlBuK0DYwyKD0etu8zIEsenJi1uKIJUTzZIXxggbsxlf0BgXbZhBHBm8lIv1idTOH8fiiJg2ZC/EkFsb8hf8wmwVk95LeSUC+v43p/8GH25c1jewgrQnuphft9EpDnOCxigLTTkiR0=  ;
X-YMail-OSG: ucUKAh4VM1n3p9XYOZHRc2WqRJPhgtRejbifUeFGs54J3GxDTDb7S8GNbldSb.00hdnPZIvNsA--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 6/12] ide-floppy: mv idefloppy_{should_,}report_error
Date: Sun, 13 Jan 2008 21:18:19 +0100
Message-Id: <1200255505-31418-7-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200255505-31418-6-git-send-email-bbpetkov@yahoo.de>
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-2-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-3-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-4-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-5-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-6-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to shortening the function name, move the printk-call into the
function thereby saving some code lines. Also, make the function out_of_line
since it is not on a performance critical path. Finally, rename the reworked
function to ide_floppy..().

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |   38 ++++++++++++++------------------------
 1 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 5004773..f1ae9af 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -739,18 +739,20 @@ static ide_startstop_t idefloppy_transfer_pc1 (ide_drive_t *drive)
 	return ide_started;
 }
 
-/**
- * idefloppy_should_report_error()
- *
- * Supresses error messages resulting from Medium not present
- */
-static inline int idefloppy_should_report_error(idefloppy_floppy_t *floppy)
+static void ide_floppy_report_error(idefloppy_floppy_t *floppy,
+		idefloppy_pc_t *pc)
 {
+	/* supress error messages resulting from Medium not present */
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
+
 }
 
 /*
@@ -777,15 +779,8 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
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
+				ide_floppy_report_error(floppy, pc);
 			/* Giving up */
 			pc->error = IDEFLOPPY_ERROR_GENERAL;
 		}
@@ -995,13 +990,8 @@ static ide_startstop_t idefloppy_do_request (ide_drive_t *drive, struct request
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
+			ide_floppy_report_error(floppy, floppy->failed_pc);
 		else
 			printk(KERN_ERR "ide-floppy: %s: I/O error\n",
 				drive->name);
-- 
1.5.3.7

