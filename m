Return-Path: <linux-kernel-owner+w=401wt.eu-S1758308AbYBDNsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308AbYBDNsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756253AbYBDNnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:43:14 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:58249 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217AbYBDNnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:43:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=vE9hGf3c0KKB7bfBJz3Xelm5XFr4hKcxqxLYy1S/UuWwYbyrZWZkI2P9v4J0nhiCeytrk7z59T9CJQXibryt24YYYbPJqH7IowHU2b+qdXDSDugBN2iTG/cyIHRAOeGGYjr2uKTUtrRQyx4P4Yyr41+eK9ndv+ZlLDQOuhRX0DU=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 06/22] ide-tape: struct idetape_tape_t: remove unused members
Date: Mon,  4 Feb 2008 14:40:24 +0100
Message-Id: <1202132440-26648-7-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- last_frame_position: only being written to once
- firmware_revision, product_id, vendor_id: used once, remove from struct
  idetape_tape_t and deal with them locally
- firmware_revision_num: only written to once
- tape_still_time_begin: completely unused
- tape_still_time: never written to; remove corresponding code chunk
- uncontrolled_last_pipeline_head: only once written to
- blocks_in_buffer: only written to

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   45 +++++++++++----------------------------------
 1 files changed, 11 insertions(+), 34 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index e0e8184..126e8a9 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -311,8 +311,6 @@ typedef struct ide_tape_obj {
 	u8 partition;
 	/* Current block */
 	unsigned int first_frame_position;
-	unsigned int last_frame_position;
-	unsigned int blocks_in_buffer;
 
 	/*
 	 *	Last error information
@@ -399,11 +397,6 @@ typedef struct ide_tape_obj {
 	int avg_size;
 	int avg_speed;
 
-	char vendor_id[10];
-	char product_id[18];
-	char firmware_revision[6];
-	int firmware_revision_num;
-
 	/* the door is currently locked */
 	int door_locked;
 	/* the tape hardware is write protected */
@@ -441,12 +434,6 @@ typedef struct ide_tape_obj {
 	int measure_insert_time;
 
 	/*
-	 * Measure tape still time, in milliseconds
-	 */
-	unsigned long tape_still_time_begin;
-	int tape_still_time;
-
-	/*
 	 * Speed regulation negative feedback loop
 	 */
 	int speed_control;
@@ -454,7 +441,6 @@ typedef struct ide_tape_obj {
 	int controlled_pipeline_head_speed;
 	int uncontrolled_pipeline_head_speed;
 	int controlled_last_pipeline_head;
-	int uncontrolled_last_pipeline_head;
 	unsigned long uncontrolled_pipeline_head_time;
 	unsigned long controlled_pipeline_head_time;
 	int controlled_previous_pipeline_head;
@@ -1696,8 +1682,6 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		drive->post_reset = 0;
 	}
 
-	if (tape->tape_still_time > 100 && tape->tape_still_time < 200)
-		tape->measure_insert_time = 1;
 	if (time_after(jiffies, tape->insert_time))
 		tape->insert_speed = tape->insert_size / 1024 * HZ / (jiffies - tape->insert_time);
 	idetape_calculate_speeds(drive);
@@ -2010,9 +1994,6 @@ static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
 			tape->partition = readpos[1];
 			tape->first_frame_position =
 				be32_to_cpu(*(u32 *)&readpos[4]);
-			tape->last_frame_position =
-				be32_to_cpu(*(u32 *)&readpos[8]);
-			tape->blocks_in_buffer = readpos[15];
 			set_bit(IDETAPE_ADDRESS_VALID, &tape->flags);
 			idetape_end_request(drive, 1, 0);
 		}
@@ -2541,7 +2522,7 @@ static void idetape_restart_speed_control (ide_drive_t *drive)
 
 	tape->restart_speed_control_req = 0;
 	tape->pipeline_head = 0;
-	tape->controlled_last_pipeline_head = tape->uncontrolled_last_pipeline_head = 0;
+	tape->controlled_last_pipeline_head = 0;
 	tape->controlled_previous_pipeline_head = tape->uncontrolled_previous_pipeline_head = 0;
 	tape->pipeline_head_speed = tape->controlled_pipeline_head_speed = 5000;
 	tape->uncontrolled_pipeline_head_speed = 0;
@@ -3438,9 +3419,9 @@ static int idetape_identify_device (ide_drive_t *drive)
 
 static void idetape_get_inquiry_results(ide_drive_t *drive)
 {
-	char *r;
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
+	char fw_rev[6], vendor_id[10], product_id[18];
 
 	idetape_create_inquiry_cmd(&pc);
 	if (idetape_queue_pc_tail(drive, &pc)) {
@@ -3448,20 +3429,16 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 				tape->name);
 		return;
 	}
-	memcpy(tape->vendor_id, &pc.buffer[8], 8);
-	memcpy(tape->product_id, &pc.buffer[16], 16);
-	memcpy(tape->firmware_revision, &pc.buffer[32], 4);
-
-	ide_fixstring(tape->vendor_id, 10, 0);
-	ide_fixstring(tape->product_id, 18, 0);
-	ide_fixstring(tape->firmware_revision, 6, 0);
-	r = tape->firmware_revision;
-	if (*(r + 1) == '.')
-		tape->firmware_revision_num = (*r - '0') * 100 +
-			(*(r + 2) - '0') * 10 +	*(r + 3) - '0';
+	memcpy(vendor_id, &pc.buffer[8], 8);
+	memcpy(product_id, &pc.buffer[16], 16);
+	memcpy(fw_rev, &pc.buffer[32], 4);
+
+	ide_fixstring(vendor_id, 10, 0);
+	ide_fixstring(product_id, 18, 0);
+	ide_fixstring(fw_rev, 6, 0);
+
 	printk(KERN_INFO "ide-tape: %s <-> %s: %s %s rev %s\n",
-			drive->name, tape->name, tape->vendor_id,
-			tape->product_id, tape->firmware_revision);
+			drive->name, tape->name, vendor_id, product_id, fw_rev);
 }
 
 /*
-- 
1.5.3.7

