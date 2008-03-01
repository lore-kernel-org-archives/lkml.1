Return-Path: <linux-kernel-owner+w=401wt.eu-S1762005AbYCAJFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762005AbYCAJFr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbYCAI7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:59:35 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:12899 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757200AbYCAI73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:59:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=GxVXgjXymhWC95fgeNh+gVw1ieoAgToyVPXoDnWmDZY6WjpG9bSPKRg7ktqZlOzn9Og31R5BhGo3yg7VFQD+cqZBE1XciyuL3M9Ob835FK3XE+ki0Z4bgf+cUqorTn1U5BNWWDEksc4tjniCUOPEpxQx07s2qdsRvCBHJV+xp8Q=
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 16/24] ide-tape: remove idetape_calculate_speeds
Date: Sat,  1 Mar 2008 09:58:40 +0100
Message-Id: <1204361928-30229-17-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   64 ------------------------------------------------
 1 files changed, 0 insertions(+), 64 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 93e42e6..cfc11bb 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1187,69 +1187,6 @@ static void idetape_create_mode_sense_cmd(struct ide_atapi_pc *pc, u8 page_code)
 	pc->idetape_callback = &idetape_pc_callback;
 }
 
-static void idetape_calculate_speeds(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-
-	if (time_after(jiffies,
-			tape->controlled_pipeline_head_time + 120 * HZ)) {
-		tape->controlled_previous_pipeline_head =
-			tape->controlled_last_pipeline_head;
-		tape->controlled_previous_head_time =
-			tape->controlled_pipeline_head_time;
-		tape->controlled_last_pipeline_head = tape->pipeline_head;
-		tape->controlled_pipeline_head_time = jiffies;
-	}
-	if (time_after(jiffies, tape->controlled_pipeline_head_time + 60 * HZ))
-		tape->controlled_pipeline_head_speed = (tape->pipeline_head -
-				tape->controlled_last_pipeline_head) * 32 * HZ /
-				(jiffies - tape->controlled_pipeline_head_time);
-	else if (time_after(jiffies, tape->controlled_previous_head_time))
-		tape->controlled_pipeline_head_speed = (tape->pipeline_head -
-				tape->controlled_previous_pipeline_head) * 32 *
-			HZ / (jiffies - tape->controlled_previous_head_time);
-
-	if (tape->nr_pending_stages < tape->max_stages/*- 1 */) {
-		/* -1 for read mode error recovery */
-		if (time_after(jiffies, tape->uncontrolled_previous_head_time +
-					10 * HZ)) {
-			tape->uncontrolled_pipeline_head_time = jiffies;
-			tape->uncontrolled_pipeline_head_speed =
-				(tape->pipeline_head -
-				 tape->uncontrolled_previous_pipeline_head) *
-				32 * HZ / (jiffies -
-					tape->uncontrolled_previous_head_time);
-		}
-	} else {
-		tape->uncontrolled_previous_head_time = jiffies;
-		tape->uncontrolled_previous_pipeline_head = tape->pipeline_head;
-		if (time_after(jiffies, tape->uncontrolled_pipeline_head_time +
-					30 * HZ))
-			tape->uncontrolled_pipeline_head_time = jiffies;
-
-	}
-	tape->pipeline_head_speed = max(tape->uncontrolled_pipeline_head_speed,
-					tape->controlled_pipeline_head_speed);
-
-	if (tape->speed_control == 1) {
-		if (tape->nr_pending_stages >= tape->max_stages / 2)
-			tape->max_insert_speed = tape->pipeline_head_speed +
-				(1100 - tape->pipeline_head_speed) * 2 *
-				(tape->nr_pending_stages - tape->max_stages / 2)
-				/ tape->max_stages;
-		else
-			tape->max_insert_speed = 500 +
-				(tape->pipeline_head_speed - 500) * 2 *
-				tape->nr_pending_stages / tape->max_stages;
-
-		if (tape->nr_pending_stages >= tape->max_stages * 99 / 100)
-			tape->max_insert_speed = 5000;
-	} else
-		tape->max_insert_speed = tape->speed_control;
-
-	tape->max_insert_speed = max(tape->max_insert_speed, 500);
-}
-
 static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
@@ -1402,7 +1339,6 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	if (time_after(jiffies, tape->insert_time))
 		tape->insert_speed = tape->insert_size / 1024 * HZ /
 					(jiffies - tape->insert_time);
-	idetape_calculate_speeds(drive);
 	if (!test_and_clear_bit(IDETAPE_FLAG_IGNORE_DSC, &tape->flags) &&
 	    (stat & SEEK_STAT) == 0) {
 		if (postponed_rq == NULL) {
-- 
1.5.4.1

