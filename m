Return-Path: <linux-kernel-owner+w=401wt.eu-S1763026AbYCAJLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763026AbYCAJLa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756668AbYCAI77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:59:59 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:64814 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbYCAI7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:59:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=TsdKeL+umsY6B6u7ZcX6nFgsvARnBAziJqtjX8Tye6CMNmsihLBcqxOWZL5uAZm4meySk/Q5r9rzEWYyOqhU5xc7mjDSnc1RTUqU0R9+JEiS6PzrrP6nK0wiMsHeYHOKmkJ4St4T1TtrFELodHaAl8ORDodrrC1t6RAxgThYtQM=
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 01/24] ide-tape: remove idetape_pipeline_active()
Date: Sat,  1 Mar 2008 09:58:25 +0100
Message-Id: <1204361928-30229-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function was simply a wrapper for a test_bit() macro so remove it and
use the macro instead.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   29 +++++++++++------------------
 1 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 3f9fbd8..792c76e 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1605,14 +1605,6 @@ out:
 }
 
 /* Pipeline related functions */
-static inline int idetape_pipeline_active(idetape_tape_t *tape)
-{
-	int rc1, rc2;
-
-	rc1 = test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags);
-	rc2 = (tape->active_data_rq != NULL);
-	return rc1;
-}
 
 /*
  * The function below uses __get_free_page to allocate a pipeline stage, along
@@ -2058,7 +2050,7 @@ static int __idetape_discard_read_pipeline(ide_drive_t *drive)
 
 	spin_lock_irqsave(&tape->lock, flags);
 	tape->next_stage = NULL;
-	if (idetape_pipeline_active(tape))
+	if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags))
 		idetape_wait_for_request(drive, tape->active_data_rq);
 	spin_unlock_irqrestore(&tape->lock, flags);
 
@@ -2131,7 +2123,7 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
 
 	debug_log(DBG_SENSE, "%s: cmd=%d\n", __func__, cmd);
 
-	if (idetape_pipeline_active(tape)) {
+	if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
 		printk(KERN_ERR "ide-tape: bug: the pipeline is active in %s\n",
 				__func__);
 		return (0);
@@ -2162,8 +2154,7 @@ static void idetape_plug_pipeline(ide_drive_t *drive)
 
 	if (tape->next_stage == NULL)
 		return;
-	if (!idetape_pipeline_active(tape)) {
-		set_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags);
+	if (!test_and_set_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
 		idetape_activate_next_stage(drive);
 		(void) ide_do_drive_cmd(drive, tape->active_data_rq, ide_end);
 	}
@@ -2242,13 +2233,14 @@ static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
 	/* Attempt to allocate a new stage. Beware possible race conditions. */
 	while ((new_stage = idetape_kmalloc_stage(tape)) == NULL) {
 		spin_lock_irqsave(&tape->lock, flags);
-		if (idetape_pipeline_active(tape)) {
+		if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
 			idetape_wait_for_request(drive, tape->active_data_rq);
 			spin_unlock_irqrestore(&tape->lock, flags);
 		} else {
 			spin_unlock_irqrestore(&tape->lock, flags);
 			idetape_plug_pipeline(drive);
-			if (idetape_pipeline_active(tape))
+			if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE,
+					&tape->flags))
 				continue;
 			/*
 			 * The machine is short on memory. Fallback to non-
@@ -2277,7 +2269,7 @@ static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
 	 * starting to service requests, so that we will be able to keep up with
 	 * the higher speeds of the tape.
 	 */
-	if (!idetape_pipeline_active(tape)) {
+	if (!test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
 		if (tape->nr_stages >= tape->max_stages * 9 / 10 ||
 			tape->nr_stages >= tape->max_stages -
 			tape->uncontrolled_pipeline_head_speed * 3 * 1024 /
@@ -2304,10 +2296,11 @@ static void idetape_wait_for_pipeline(ide_drive_t *drive)
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
 
-	while (tape->next_stage || idetape_pipeline_active(tape)) {
+	while (tape->next_stage || test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE,
+						&tape->flags)) {
 		idetape_plug_pipeline(drive);
 		spin_lock_irqsave(&tape->lock, flags);
-		if (idetape_pipeline_active(tape))
+		if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags))
 			idetape_wait_for_request(drive, tape->active_data_rq);
 		spin_unlock_irqrestore(&tape->lock, flags);
 	}
@@ -2464,7 +2457,7 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 			new_stage = idetape_kmalloc_stage(tape);
 		}
 	}
-	if (!idetape_pipeline_active(tape)) {
+	if (!test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
 		if (tape->nr_pending_stages >= 3 * max_stages / 4) {
 			tape->measure_insert_time = 1;
 			tape->insert_time = jiffies;
-- 
1.5.4.1

