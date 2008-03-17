Return-Path: <linux-kernel-owner+w=401wt.eu-S1752978AbYCQGmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbYCQGmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 02:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbYCQGmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 02:42:10 -0400
Received: from hu-out-0506.google.com ([72.14.214.233]:30015 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbYCQGlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 02:41:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=BXjRWYwmdYJ3k+wqtJg7/AKgBIxhoHhcc650JeAOoqP+sp9qIOB4UPj/iZtgfF5YyfhK46zsukvmx1eKMaQQkXYIcoGcWAvA5k/M4HZu0uNHMoMpr3zbzrLyiqPDGghpgPXDH2ojrIs6jnZRRcWHuldTw5wBxvThP0EtolZ+kI8=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 05/17] ide-tape: remove pipeline-specific code in idetape_space_over_filemarks()
Date: Mon, 17 Mar 2008 07:41:18 +0100
Message-Id: <1205736090-4435-6-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1205736090-4435-1-git-send-email-petkovbb@gmail.com>
References: <1205736090-4435-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we don't do pipeline read-ahead anymore, we don't have to look for
filemarks we have crossed. Therefore, remove the code chunk that does that and
pass on the command to the tape. As a side effect, remove unused
idetape_wait_first_stage().

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   52 ------------------------------------------------
 1 files changed, 0 insertions(+), 52 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index d4a94d5..3b324bb 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1983,19 +1983,6 @@ static void idetape_create_space_cmd(struct ide_atapi_pc *pc, int count, u8 cmd)
 	pc->idetape_callback = &idetape_pc_callback;
 }
 
-static void idetape_wait_first_stage(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	unsigned long flags;
-
-	if (tape->first_stage == NULL)
-		return;
-	spin_lock_irqsave(&tape->lock, flags);
-	if (tape->active_stage == tape->first_stage)
-		idetape_wait_for_request(drive, tape->active_data_rq);
-	spin_unlock_irqrestore(&tape->lock, flags);
-}
-
 /* Queue up a character device originated write request. */
 static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
 {
@@ -2221,19 +2208,11 @@ static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd,
 	return 0;
 }
 
-/*
- * The function below is now a bit more complicated than just passing the
- * command to the tape since we may have crossed some filemarks during our
- * pipelined read-ahead mode. As a minor side effect, the pipeline enables us to
- * support MTFSFM when the filemark is in our internal pipeline even if the tape
- * doesn't support spacing over filemarks in the reverse direction.
- */
 static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 					int mt_count)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc pc;
-	unsigned long flags;
 	int retval, count = 0;
 	int sprev = !!(tape->caps[4] & 0x20);
 
@@ -2246,42 +2225,11 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
 	}
 
 	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
-		/* its a read-ahead buffer, scan it for crossed filemarks. */
 		tape->merge_stage_size = 0;
 		if (test_and_clear_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
 			++count;
-		while (tape->first_stage != NULL) {
-			if (count == mt_count) {
-				if (mt_op == MTFSFM)
-					set_bit(IDETAPE_FLAG_FILEMARK,
-						&tape->flags);
-				return 0;
-			}
-			spin_lock_irqsave(&tape->lock, flags);
-			if (tape->first_stage == tape->active_stage) {
-				/*
-				 * We have reached the active stage in the read
-				 * pipeline. There is no point in allowing the
-				 * drive to continue reading any farther, so we
-				 * stop the pipeline.
-				 */
-				tape->next_stage = NULL;
-				spin_unlock_irqrestore(&tape->lock, flags);
-				idetape_wait_first_stage(drive);
-				tape->next_stage = tape->first_stage->next;
-			} else
-				spin_unlock_irqrestore(&tape->lock, flags);
-			if (tape->first_stage->rq.errors ==
-					IDETAPE_ERROR_FILEMARK)
-				++count;
-			idetape_remove_stage_head(drive);
-		}
 	}
 
-	/*
-	 * The filemark was not found in our internal pipeline;	now we can issue
-	 * the space command.
-	 */
 	switch (mt_op) {
 	case MTFSF:
 	case MTBSF:
-- 
1.5.4.1

