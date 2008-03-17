Return-Path: <linux-kernel-owner+w=401wt.eu-S1757030AbYCQGo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030AbYCQGo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 02:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYCQGmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 02:42:22 -0400
Received: from hu-out-0506.google.com ([72.14.214.234]:30085 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYCQGli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 02:41:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=h9DMF18BJRg1h9rko+szs9L2AYK6dBkzPOJLzEgVvfyI+jOIKGjckMeJKfaAYjmzS7FTabS4b4ajaMqa3XGmobmQoqcrEEox+TGnnueGA/0055h12aT0qMHykxxYQ1pjzKwquJ2oaw8GdIK9UeZolA58q+gxHuKZTVnR+Al1xSY=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 13/17] ide-tape: remove pipelined mode tape control flags
Date: Mon, 17 Mar 2008 07:41:26 +0100
Message-Id: <1205736090-4435-14-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1205736090-4435-1-git-send-email-petkovbb@gmail.com>
References: <1205736090-4435-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   34 +++++-----------------------------
 1 files changed, 5 insertions(+), 29 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 5535356..1464383 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -204,19 +204,15 @@ enum {
 	/* 0 When the tape position is unknown */
 	IDETAPE_FLAG_ADDRESS_VALID	= (1 <<	1),
 	/* Device already opened */
-	IDETAPE_FLAG_BUSY			= (1 << 2),
-	/* Error detected in a pipeline stage */
-	IDETAPE_FLAG_PIPELINE_ERR	= (1 <<	3),
+	IDETAPE_FLAG_BUSY		= (1 << 2),
 	/* Attempt to auto-detect the current user block size */
-	IDETAPE_FLAG_DETECT_BS		= (1 << 4),
+	IDETAPE_FLAG_DETECT_BS		= (1 << 3),
 	/* Currently on a filemark */
-	IDETAPE_FLAG_FILEMARK		= (1 << 5),
+	IDETAPE_FLAG_FILEMARK		= (1 << 4),
 	/* DRQ interrupt device */
-	IDETAPE_FLAG_DRQ_INTERRUPT	= (1 << 6),
-	/* pipeline active */
-	IDETAPE_FLAG_PIPELINE_ACTIVE	= (1 << 7),
+	IDETAPE_FLAG_DRQ_INTERRUPT	= (1 << 5),
 	/* 0 = no tape is loaded, so we don't rewind after ejecting */
-	IDETAPE_FLAG_MEDIUM_PRESENT	= (1 << 8),
+	IDETAPE_FLAG_MEDIUM_PRESENT	= (1 << 6),
 };
 
 /* A pipeline stage. */
@@ -1721,12 +1717,6 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
 
 	debug_log(DBG_SENSE, "%s: cmd=%d\n", __func__, cmd);
 
-	if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
-		printk(KERN_ERR "ide-tape: bug: the pipeline is active in %s\n",
-				__func__);
-		return (0);
-	}
-
 	idetape_init_rq(&rq, cmd);
 	rq.rq_disk = tape->disk;
 	rq.special = (void *)bh;
@@ -1832,14 +1822,6 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 		}
 	}
 
-	if (!test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags)) {
-		if (tape->nr_pending_stages >= 3 * max_stages / 4) {
-			tape->measure_insert_time = 1;
-			tape->insert_time = jiffies;
-			tape->insert_size = 0;
-			tape->insert_speed = 0;
-		}
-	}
 	return 0;
 }
 
@@ -1859,9 +1841,6 @@ static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 
 	idetape_init_read(drive, tape->max_stages);
 
-	if (test_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags))
-		return 0;
-
 	return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
 				     tape->merge_stage->bh);
 }
@@ -2425,9 +2404,6 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 	if (!test_bit(IDETAPE_FLAG_ADDRESS_VALID, &tape->flags))
 		(void)idetape_rewind_tape(drive);
 
-	if (tape->chrdev_dir != IDETAPE_DIR_READ)
-		clear_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags);
-
 	/* Read block size and write protect status from drive. */
 	ide_tape_get_bsize_from_bdesc(drive);
 
-- 
1.5.4.1

