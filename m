Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbYA0Jt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbYA0Jt1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754346AbYA0Js6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:48:58 -0500
Received: from [212.23.103.76] ([212.23.103.76]:58596 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753942AbYA0Js4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:48:56 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 10/32] ide-tape: remove struct idetape_read_position_result_t
Date: Sun, 27 Jan 2008 10:47:58 +0100
Message-Id: <1201427300-3954-5-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

There should be no functional changes resulting from this patch.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |   49 +++++++++++++++++------------------------------
 1 files changed, 18 insertions(+), 31 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 31c1a20..9f1fc50 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -653,24 +653,6 @@ struct idetape_id_gcw {
 };
 
 /*
- *	READ POSITION packet command - Data Format (From Table 6-57)
- */
-typedef struct {
-	unsigned	reserved0_10	:2;	/* Reserved */
-	unsigned	bpu		:1;	/* Block Position Unknown */	
-	unsigned	reserved0_543	:3;	/* Reserved */
-	unsigned	eop		:1;	/* End Of Partition */
-	unsigned	bop		:1;	/* Beginning Of Partition */
-	u8		partition;		/* Partition Number */
-	u8		reserved2, reserved3;	/* Reserved */
-	u32		first_block;		/* First Block Location */
-	u32		last_block;		/* Last Block Location (Optional) */
-	u8		reserved12;		/* Reserved */
-	u8		blocks_in_buffer[3];	/* Blocks In Buffer - (Optional) */
-	u32		bytes_in_buffer;	/* Bytes In Buffer (Optional) */
-} idetape_read_position_result_t;
-
-/*
  *	Follows structures which are related to the SELECT SENSE / MODE SENSE
  *	packet commands. Those packet commands are still not supported
  *	by ide-tape.
@@ -2153,30 +2135,35 @@ static void idetape_wait_for_request (ide_drive_t *drive, struct request *rq)
 	spin_lock_irq(&tape->spinlock);
 }
 
-static ide_startstop_t idetape_read_position_callback (ide_drive_t *drive)
+static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_read_position_result_t *result;
+	u8 *readpos = tape->pc->buffer;
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	if (!tape->pc->error) {
-		result = (idetape_read_position_result_t *) tape->pc->buffer;
-		debug_log(DBG_SENSE, "BOP - %s\n", result->bop ? "Yes" : "No");
-		debug_log(DBG_SENSE, "EOP - %s\n", result->eop ? "Yes" : "No");
+		debug_log(DBG_SENSE, "BOP - %s\n",
+				!!(readpos[0] & 0x80) ? "Yes" : "No");
+		debug_log(DBG_SENSE, "EOP - %s\n",
+				!!(readpos[0] & 0x40) ? "Yes" : "No");
+
+		if (!!(readpos[0] & 0x4)) {
+			printk(KERN_INFO "ide-tape: Block location is unknown"
+					"to the tape\n");
 
-		if (result->bpu) {
-			printk(KERN_INFO "ide-tape: Block location is unknown to the tape\n");
 			clear_bit(IDETAPE_ADDRESS_VALID, &tape->flags);
 			idetape_end_request(drive, 0, 0);
 		} else {
 			debug_log(DBG_SENSE, "Block Location - %u\n",
-					ntohl(result->first_block));
-
-			tape->partition = result->partition;
-			tape->first_frame_position = ntohl(result->first_block);
-			tape->last_frame_position = ntohl(result->last_block);
-			tape->blocks_in_buffer = result->blocks_in_buffer[2];
+					be32_to_cpu(*(u32 *)&readpos[4]));
+
+			tape->partition = readpos[1];
+			tape->first_frame_position =
+				be32_to_cpu(*(u32 *)&readpos[4]);
+			tape->last_frame_position =
+				be32_to_cpu(*(u32 *)&readpos[8]);
+			tape->blocks_in_buffer = readpos[15];
 			set_bit(IDETAPE_ADDRESS_VALID, &tape->flags);
 			idetape_end_request(drive, 1, 0);
 		}
-- 
1.5.3.7

