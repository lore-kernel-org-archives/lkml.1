Return-Path: <linux-kernel-owner+w=401wt.eu-S1761477AbYCAJIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761477AbYCAJIs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758747AbYCAI7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:59:49 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:13216 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831AbYCAI71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:59:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=B44xsRfDG+rxzeDQJkhcOukClGpII0QS81tlfMKxY5tYKcOvBRqBSzPgkKcw96R1cF8oZpIv9PCfG9OUBz+q/dXARvkmizRP46BUKqVqLcq1UnaLSUEAEJWgEgF6t93YcOfdW8DSl/pK7K2BzUREz/36Y6bM2zBNMDDPXxBxFxg=
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 21/24] ide-tape: remove pipeline-specific members from struct ide_tape_obj
Date: Sat,  1 Mar 2008 09:58:45 +0100
Message-Id: <1204361928-30229-22-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of them have become unused after removing the pipelined
functionality - the rest is only being written to.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   95 +-----------------------------------------------
 1 files changed, 2 insertions(+), 93 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 68c9c09..9810253 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -323,26 +323,6 @@ typedef struct ide_tape_obj {
 	char *b_data;
 	int b_count;
 
-	/*
-	 * Pipeline parameters.
-	 *
-	 * To accomplish non-pipelined mode, we simply set the following
-	 * variables to zero (or NULL, where appropriate).
-	 */
-	/* Number of currently used stages */
-	int nr_stages;
-	/* Number of pending stages */
-	int nr_pending_stages;
-	/* We will not allocate more than this number of stages */
-	int max_stages, min_pipeline, max_pipeline;
-	/* The first stage which will be removed from the pipeline */
-	idetape_stage_t *first_stage;
-	/* The currently active stage */
-	idetape_stage_t *active_stage;
-	/* Will be serviced after the currently active request */
-	idetape_stage_t *next_stage;
-	/* New requests will be added to the pipeline here */
-	idetape_stage_t *last_stage;
 	/* Optional free stage which we can use */
 	int pages_per_stage;
 	/* Wasted space in each stage */
@@ -365,43 +345,8 @@ typedef struct ide_tape_obj {
 	/* the tape is write protected (hardware or opened as read-only) */
 	char write_prot;
 
-	/*
-	 * Limit the number of times a request can be postponed, to avoid an
-	 * infinite postpone deadlock.
-	 */
-	int postpone_cnt;
-
-	/*
-	 * Measures number of frames:
-	 *
-	 * 1. written/read to/from the driver pipeline (pipeline_head).
-	 * 2. written/read to/from the tape buffers (idetape_bh).
-	 * 3. written/read by the tape to/from the media (tape_head).
-	 */
-	int pipeline_head;
-	int buffer_head;
-	int tape_head;
-	int last_tape_head;
-
-	/* Speed control at the tape buffers input/output */
-	unsigned long insert_time;
+	/* size control at the tape buffers input/output */
 	int insert_size;
-	int insert_speed;
-	int max_insert_speed;
-	int measure_insert_time;
-
-	/* Speed regulation negative feedback loop */
-	int speed_control;
-	int pipeline_head_speed;
-	int controlled_pipeline_head_speed;
-	int uncontrolled_pipeline_head_speed;
-	int controlled_last_pipeline_head;
-	unsigned long uncontrolled_pipeline_head_time;
-	unsigned long controlled_pipeline_head_time;
-	int controlled_previous_pipeline_head;
-	int uncontrolled_previous_pipeline_head;
-	unsigned long controlled_previous_head_time;
-	unsigned long uncontrolled_previous_head_time;
 
 	u32 debug_mask;
 } idetape_tape_t;
@@ -1200,15 +1145,8 @@ static ide_startstop_t idetape_rw_callback(ide_drive_t *drive)
 	tape->avg_size += blocks * tape->blk_size;
 	tape->insert_size += blocks * tape->blk_size;
 	if (tape->insert_size > 1024 * 1024)
-		tape->measure_insert_time = 1;
-	if (tape->measure_insert_time) {
-		tape->measure_insert_time = 0;
-		tape->insert_time = jiffies;
 		tape->insert_size = 0;
-	}
-	if (time_after(jiffies, tape->insert_time))
-		tape->insert_speed = tape->insert_size / 1024 * HZ /
-					(jiffies - tape->insert_time);
+
 	if (time_after_eq(jiffies, tape->avg_time + HZ)) {
 		tape->avg_speed = tape->avg_size * HZ /
 				(jiffies - tape->avg_time) / 1024;
@@ -1313,9 +1251,6 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		drive->post_reset = 0;
 	}
 
-	if (time_after(jiffies, tape->insert_time))
-		tape->insert_speed = tape->insert_size / 1024 * HZ /
-					(jiffies - tape->insert_time);
 	if (!test_and_clear_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags) &&
 	    (stat & SEEK_STAT) == 0) {
 		if (postponed_rq == NULL) {
@@ -1339,16 +1274,12 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		return ide_stopped;
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_READ) {
-		tape->buffer_head++;
-		tape->postpone_cnt = 0;
 		pc = idetape_next_pc_storage(drive);
 		idetape_create_read_cmd(tape, pc, rq->current_nr_sectors,
 					(struct idetape_bh *)rq->special);
 		goto out;
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
-		tape->buffer_head++;
-		tape->postpone_cnt = 0;
 		pc = idetape_next_pc_storage(drive);
 		idetape_create_write_cmd(tape, pc, rq->current_nr_sectors,
 					 (struct idetape_bh *)rq->special);
@@ -2628,18 +2559,6 @@ static void idetape_add_settings(ide_drive_t *drive)
 
 	ide_add_setting(drive, "buffer", SETTING_READ, TYPE_SHORT, 0, 0xffff,
 			1, 2, (u16 *)&tape->caps[16], NULL);
-	ide_add_setting(drive, "pipeline_min", SETTING_RW, TYPE_INT, 1, 0xffff,
-			tape->stage_size / 1024, 1, &tape->min_pipeline, NULL);
-	ide_add_setting(drive, "pipeline", SETTING_RW, TYPE_INT, 1, 0xffff,
-			tape->stage_size / 1024, 1, &tape->max_stages, NULL);
-	ide_add_setting(drive, "pipeline_max", SETTING_RW, TYPE_INT, 1,	0xffff,
-			tape->stage_size / 1024, 1, &tape->max_pipeline, NULL);
-	ide_add_setting(drive, "pipeline_used",	SETTING_READ, TYPE_INT, 0,
-			0xffff,	tape->stage_size / 1024, 1, &tape->nr_stages,
-			NULL);
-	ide_add_setting(drive, "pipeline_pending", SETTING_READ, TYPE_INT, 0,
-			0xffff, tape->stage_size / 1024, 1,
-			&tape->nr_pending_stages, NULL);
 	ide_add_setting(drive, "speed", SETTING_READ, TYPE_SHORT, 0, 0xffff,
 			1, 1, (u16 *)&tape->caps[14], NULL);
 	ide_add_setting(drive, "stage", SETTING_READ, TYPE_INT,	0, 0xffff, 1,
@@ -2649,12 +2568,6 @@ static void idetape_add_settings(ide_drive_t *drive)
 			NULL);
 	ide_add_setting(drive, "dsc_overlap", SETTING_RW, TYPE_BYTE, 0, 1, 1,
 			1, &drive->dsc_overlap, NULL);
-	ide_add_setting(drive, "pipeline_head_speed_c", SETTING_READ, TYPE_INT,
-			0, 0xffff, 1, 1, &tape->controlled_pipeline_head_speed,
-			NULL);
-	ide_add_setting(drive, "pipeline_head_speed_u", SETTING_READ, TYPE_INT,
-			0, 0xffff, 1, 1,
-			&tape->uncontrolled_pipeline_head_speed, NULL);
 	ide_add_setting(drive, "avg_speed", SETTING_READ, TYPE_INT, 0, 0xffff,
 			1, 1, &tape->avg_speed, NULL);
 	ide_add_setting(drive, "debug_mask", SETTING_RW, TYPE_INT, 0, 0xffff, 1,
@@ -2699,8 +2612,6 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	tape->name[2] = '0' + minor;
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
 	tape->pc = tape->pc_stack;
-	tape->max_insert_speed = 10000;
-	tape->speed_control = 1;
 	*((unsigned short *) &gcw) = drive->id->config;
 
 	/* Command packet DRQ type */
@@ -2764,8 +2675,6 @@ static void ide_tape_release(struct kref *kref)
 	ide_drive_t *drive = tape->drive;
 	struct gendisk *g = tape->disk;
 
-	BUG_ON(tape->first_stage != NULL || tape->merge_stage_size);
-
 	drive->dsc_overlap = 0;
 	drive->driver_data = NULL;
 	device_destroy(idetape_sysfs_class, MKDEV(IDETAPE_MAJOR, tape->minor));
-- 
1.5.4.1

