Return-Path: <linux-kernel-owner+w=401wt.eu-S1762981AbYCAJKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762981AbYCAJKr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758111AbYCAI74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:59:56 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:64804 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbYCAI7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:59:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=VsTd7/z4VyqNz+0U+2HUO12FezcGnwDw4k5ObhQ+lSYeGcXKRzehc16w6qEUBWDPL6XI7nMXn14JFW0xpUHqwinBpdqixK0aOUo2Pj6hEbqlrnrCt++uFN6QuzLzjsziZEZkdwXpwvk6e57TNUoB2UvR2OK6eZ8DPRYBY6ghFdM=
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 04/24] ide-tape: remove pipeline-specific code from idetape_chrdev_write
Date: Sat,  1 Mar 2008 09:58:28 +0100
Message-Id: <1204361928-30229-5-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, remove unused stage-parameter from idetape_copy_stage_from_user()

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index e919d41..4a064c1 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1700,7 +1700,7 @@ static idetape_stage_t *idetape_kmalloc_stage(idetape_tape_t *tape)
 }
 
 static int idetape_copy_stage_from_user(idetape_tape_t *tape,
-		idetape_stage_t *stage, const char __user *buf, int n)
+					const char __user *buf, int n)
 {
 	struct idetape_bh *bh = tape->bh;
 	int count;
@@ -2696,8 +2696,6 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 
 	/* Initialize write operation */
 	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
-		if (tape->chrdev_dir == IDETAPE_DIR_READ)
-			idetape_discard_read_pipeline(drive, 1);
 		if (tape->merge_stage || tape->merge_stage_size) {
 			printk(KERN_ERR "ide-tape: merge_stage_size "
 				"should be 0 now\n");
@@ -2729,8 +2727,6 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	}
 	if (count == 0)
 		return (0);
-	if (tape->restart_speed_control_req)
-		idetape_restart_speed_control(drive);
 	if (tape->merge_stage_size) {
 		if (tape->merge_stage_size >= tape->stage_size) {
 			printk(KERN_ERR "ide-tape: bug: merge buf too big\n");
@@ -2739,8 +2735,7 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 		actually_written = min((unsigned int)
 				(tape->stage_size - tape->merge_stage_size),
 				(unsigned int)count);
-		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf,
-						 actually_written))
+		if (idetape_copy_stage_from_user(tape, buf, actually_written))
 				ret = -EFAULT;
 		buf += actually_written;
 		tape->merge_stage_size += actually_written;
@@ -2756,8 +2751,7 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	}
 	while (count >= tape->stage_size) {
 		ssize_t retval;
-		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf,
-						 tape->stage_size))
+		if (idetape_copy_stage_from_user(tape, buf, tape->stage_size))
 			ret = -EFAULT;
 		buf += tape->stage_size;
 		count -= tape->stage_size;
@@ -2768,8 +2762,7 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 	}
 	if (count) {
 		actually_written += count;
-		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf,
-						 count))
+		if (idetape_copy_stage_from_user(tape, buf, count))
 			ret = -EFAULT;
 		tape->merge_stage_size += count;
 	}
-- 
1.5.4.1

