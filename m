Return-Path: <linux-kernel-owner+w=401wt.eu-S1760797AbYCAJAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760797AbYCAJAb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbYCAI7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:59:11 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:1512 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbYCAI7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:59:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=N1vVj1WqwAfqnOl1hVYukXUOnHEV3HEFYaTeqWE7GbqMx82HFzEr5Ke3ZbyNO8/EsXHPVwiv3782ZX2Fy8czQqO1oLuojzwpeObAthv2O13AMsHhyc2X1Gk62sPlpefU5Qw+2ADKoSjs352u9YvhccJNTEVlvuc+Pcv3ApfvRAA=
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 08/24] ide-tape: remove pipeline-specific code from idetape_space_over_filemarks
Date: Sat,  1 Mar 2008 09:58:32 +0100
Message-Id: <1204361928-30229-9-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, remove idetape_wait_first_stage() too since it becomes unused.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   65 +-----------------------------------------------
 1 files changed, 1 insertions(+), 64 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 99d6b29..d4a2e73 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2143,19 +2143,6 @@ static void idetape_create_space_cmd(struct ide_atapi_pc *pc, int count, u8 cmd)
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
@@ -2446,73 +2433,23 @@ static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd,
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
 
 	if (mt_count == 0)
 		return 0;
+
 	if (MTBSF == mt_op || MTBSFM == mt_op) {
 		if (!sprev)
 			return -EIO;
 		mt_count = -mt_count;
 	}
 
-	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
-		/* its a read-ahead buffer, scan it for crossed filemarks. */
-		tape->merge_stage_size = 0;
-		if (test_and_clear_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
-			++count;
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
-				 *
-				 * This section should be moved to a separate
-				 * subroutine because similar operations are
-				 * done in __idetape_discard_read_pipeline(),
-				 * for example.
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
-		idetape_discard_read_pipeline(drive, 0);
-	}
-
-	/*
-	 * The filemark was not found in our internal pipeline;	now we can issue
-	 * the space command.
-	 */
 	switch (mt_op) {
 	case MTFSF:
 	case MTBSF:
-- 
1.5.4.1

