Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbYCQGqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbYCQGqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 02:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbYCQGmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 02:42:35 -0400
Received: from hu-out-0506.google.com ([72.14.214.237]:30537 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbYCQGlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 02:41:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=neUkXpx5XrN2CTvulum+V8TVmEza5rWkLGXDCpqnalbZTRBoml4sRj1RSHweD6gy1hOlcplVt/+pToEC6aa3OctkvcxAMF1Dh0N0H7ChWX8KrSWLAqD8WPLvkIkaWl3tOzLdOitf62Tzgx+TgNM/1e75TyaxihvsJaeIzLXVhhA=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 14/17] ide-tape: remove pipeline-specific members from struct ide_tape_obj
Date: Mon, 17 Mar 2008 07:41:27 +0100
Message-Id: <1205736090-4435-15-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1205736090-4435-1-git-send-email-petkovbb@gmail.com>
References: <1205736090-4435-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   79 ++++-------------------------------------------
 1 files changed, 7 insertions(+), 72 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 1464383..9ae42c3 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -307,12 +307,8 @@ typedef struct ide_tape_obj {
 	 * At most, there is only one ide-tape originated data transfer request
 	 * in the device request queue. This allows ide.c to easily service
 	 * requests from the other device when we postpone our active request.
-	 * In the pipelined operation mode, we use our internal pipeline
-	 * structure to hold more data requests. The data buffer size is chosen
-	 * based on the tape's recommendation.
 	 */
-	/* ptr to the request which is waiting in the device request queue */
-	struct request *active_data_rq;
+
 	/* Data buffer size chosen based on the tape's recommendation */
 	int stage_size;
 	idetape_stage_t *merge_stage;
@@ -321,26 +317,7 @@ typedef struct ide_tape_obj {
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
+	/* Pipeline parameters. */
 	int pages_per_stage;
 	/* Wasted space in each stage */
 	int excess_bh_size;
@@ -362,18 +339,6 @@ typedef struct ide_tape_obj {
 	/* the tape is write protected (hardware or opened as read-only) */
 	char write_prot;
 
-	/*
-	 * Limit the number of times a request can be postponed, to avoid an
-	 * infinite postpone deadlock.
-	 */
-	int postpone_cnt;
-
-	/* Speed control at the tape buffers input/output */
-	unsigned long insert_time;
-	int insert_size;
-	int insert_speed;
-	int measure_insert_time;
-
 	u32 debug_mask;
 } idetape_tape_t;
 
@@ -1172,17 +1137,7 @@ static ide_startstop_t idetape_rw_callback(ide_drive_t *drive)
 	int blocks = tape->pc->xferred / tape->blk_size;
 
 	tape->avg_size += blocks * tape->blk_size;
-	tape->insert_size += blocks * tape->blk_size;
-	if (tape->insert_size > 1024 * 1024)
-		tape->measure_insert_time = 1;
-	if (tape->measure_insert_time) {
-		tape->measure_insert_time = 0;
-		tape->insert_time = jiffies;
-		tape->insert_size = 0;
-	}
-	if (time_after(jiffies, tape->insert_time))
-		tape->insert_speed = tape->insert_size / 1024 * HZ /
-					(jiffies - tape->insert_time);
+
 	if (time_after_eq(jiffies, tape->avg_time + HZ)) {
 		tape->avg_speed = tape->avg_size * HZ /
 				(jiffies - tape->avg_time) / 1024;
@@ -1287,9 +1242,6 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		drive->post_reset = 0;
 	}
 
-	if (time_after(jiffies, tape->insert_time))
-		tape->insert_speed = tape->insert_size / 1024 * HZ /
-					(jiffies - tape->insert_time);
 	if (!test_and_clear_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags) &&
 	    (stat & SEEK_STAT) == 0) {
 		if (postponed_rq == NULL) {
@@ -1313,14 +1265,12 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		return ide_stopped;
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_READ) {
-		tape->postpone_cnt = 0;
 		pc = idetape_next_pc_storage(drive);
 		idetape_create_read_cmd(tape, pc, rq->current_nr_sectors,
 					(struct idetape_bh *)rq->special);
 		goto out;
 	}
 	if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
-		tape->postpone_cnt = 0;
 		pc = idetape_next_pc_storage(drive);
 		idetape_create_write_cmd(tape, pc, rq->current_nr_sectors,
 					 (struct idetape_bh *)rq->special);
@@ -1783,7 +1733,7 @@ static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
 				     blocks, tape->merge_stage->bh);
 }
 
-static int idetape_init_read(ide_drive_t *drive, int max_stages)
+static int idetape_init_read(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	int bytes_read;
@@ -1839,7 +1789,7 @@ static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 	if (test_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
 		return 0;
 
-	idetape_init_read(drive, tape->max_stages);
+	idetape_init_read(drive);
 
 	return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
 				     tape->merge_stage->bh);
@@ -1905,7 +1855,6 @@ static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd,
 	struct idetape_config {
 		int dsc_rw_frequency;
 		int dsc_media_access_frequency;
-		int nr_stages;
 	} config;
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
@@ -1915,11 +1864,9 @@ static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd,
 		if (copy_from_user(&config, argp, sizeof(config)))
 			return -EFAULT;
 		tape->best_dsc_rw_freq = config.dsc_rw_frequency;
-		tape->max_stages = config.nr_stages;
 		break;
 	case 0x0350:
 		config.dsc_rw_frequency = (int) tape->best_dsc_rw_freq;
-		config.nr_stages = tape->max_stages;
 		if (copy_to_user(argp, &config, sizeof(config)))
 			return -EFAULT;
 		break;
@@ -2006,7 +1953,7 @@ static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 			    (count % tape->blk_size) == 0)
 				tape->user_bs_factor = count / tape->blk_size;
 	}
-	rc = idetape_init_read(drive, tape->max_stages);
+	rc = idetape_init_read(drive);
 	if (rc < 0)
 		return rc;
 	if (count == 0)
@@ -2606,18 +2553,6 @@ static void idetape_add_settings(ide_drive_t *drive)
 
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
@@ -2734,7 +2669,7 @@ static void ide_tape_release(struct kref *kref)
 	ide_drive_t *drive = tape->drive;
 	struct gendisk *g = tape->disk;
 
-	BUG_ON(tape->first_stage != NULL || tape->merge_stage_size);
+	BUG_ON(tape->merge_stage_size);
 
 	drive->dsc_overlap = 0;
 	drive->driver_data = NULL;
-- 
1.5.4.1

