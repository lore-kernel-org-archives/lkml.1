Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbYBDNmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbYBDNmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbYBDNmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:42:08 -0500
Received: from wx-out-0506.google.com ([66.249.82.229]:38278 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbYBDNmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:42:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=BMss3YHaMGU4qe3L+/3FjkTaE6cmvx0Mv+I6OuLVZRqd5csgTLlJSFxaM6s5y5gis03cQRRvyAuxoZeaMnGBKMZKxIhAZGuJotM1C6bDUr1yZs8gsOSFFMB6k07hZz56iS0pHYTREa9qaaF/hE4KnLs0IOdSYZ9FNbVs7a24cfw=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 02/22] ide-tape: remove struct idetape_read_position_result_t
Date: Mon,  4 Feb 2008 14:40:20 +0100
Message-Id: <1202132440-26648-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   49 +++++++++++++++++------------------------------
 1 files changed, 18 insertions(+), 31 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 442d71c..c8c57ab 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -571,24 +571,6 @@ struct idetape_id_gcw {
 	unsigned protocol		:2;	/* Protocol type */
 };
 
-/*
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
 /* Structures related to the SELECT SENSE / MODE SENSE packet commands. */
 #define IDETAPE_BLOCK_DESCRIPTOR	0
 #define	IDETAPE_CAPABILITIES_PAGE	0x2a
@@ -1999,30 +1981,35 @@ static void idetape_wait_for_request (ide_drive_t *drive, struct request *rq)
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

