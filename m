Return-Path: <linux-kernel-owner+w=401wt.eu-S1757774AbYCQGqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774AbYCQGqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 02:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbYCQGme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 02:42:34 -0400
Received: from hu-out-0506.google.com ([72.14.214.225]:30026 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbYCQGlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 02:41:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=FVN4/hGX6jcXRsuNPhhAWzqNxEGShleeJqal2b/+dQ5hECZIu0AJtIh4nV7TIe0S6Catj4lPjECgIy8fjIPJihatnsjBxP8yzCTFe4eE7YQ/oH/c1aCZ4JzPrpv1LkeYdCrbsh5w/luqzDIbnEpULB+HM5icNZiYn7Rs5988LnE=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 07/17] ide-tape: remove idetape_remove_stage_head()
Date: Mon, 17 Mar 2008 07:41:20 +0100
Message-Id: <1205736090-4435-8-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1205736090-4435-1-git-send-email-petkovbb@gmail.com>
References: <1205736090-4435-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   39 ---------------------------------------
 1 files changed, 0 insertions(+), 39 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 5a6b657..7e0f4fa 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -692,41 +692,6 @@ static void idetape_kfree_stage(idetape_tape_t *tape, idetape_stage_t *stage)
 }
 
 /*
- * Remove tape->first_stage from the pipeline. The caller should avoid race
- * conditions.
- */
-static void idetape_remove_stage_head(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	idetape_stage_t *stage;
-
-	debug_log(DBG_PROCS, "Enter %s\n", __func__);
-
-	if (tape->first_stage == NULL) {
-		printk(KERN_ERR "ide-tape: bug: tape->first_stage is NULL\n");
-		return;
-	}
-	if (tape->active_stage == tape->first_stage) {
-		printk(KERN_ERR "ide-tape: bug: Trying to free our active "
-				"pipeline stage\n");
-		return;
-	}
-	stage = tape->first_stage;
-	tape->first_stage = stage->next;
-	idetape_kfree_stage(tape, stage);
-	tape->nr_stages--;
-	if (tape->first_stage == NULL) {
-		tape->last_stage = NULL;
-		if (tape->next_stage != NULL)
-			printk(KERN_ERR "ide-tape: bug: tape->next_stage !="
-					" NULL\n");
-		if (tape->nr_stages)
-			printk(KERN_ERR "ide-tape: bug: nr_stages should be 0 "
-					"now\n");
-	}
-}
-
-/*
  * This will free all the pipeline stages starting from new_last_stage->next
  * to the end of the list, and point tape->last_stage to new_last_stage.
  */
@@ -762,7 +727,6 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
 	int error;
-	int remove_stage = 0;
 	idetape_stage_t *active_stage;
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
@@ -790,7 +754,6 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 		tape->active_data_rq = NULL;
 		tape->nr_pending_stages--;
 		if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
-			remove_stage = 1;
 			if (error) {
 				set_bit(IDETAPE_FLAG_PIPELINE_ERR,
 					&tape->flags);
@@ -831,8 +794,6 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 	}
 	ide_end_drive_cmd(drive, 0, 0);
 
-	if (remove_stage)
-		idetape_remove_stage_head(drive);
 	if (tape->active_data_rq == NULL)
 		clear_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags);
 	spin_unlock_irqrestore(&tape->lock, flags);
-- 
1.5.4.1

