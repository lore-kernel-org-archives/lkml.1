Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbYC2Rq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbYC2Rq7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 13:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbYC2RqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 13:46:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:49379 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbYC2RqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 13:46:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=od+b2Bfru91UVQdbVGZ/8ScKXVy/KuT0I7IPYcpYBSB7t3D1vyIdQyCo7MVfnwWUmUQi7sPdQRs5rNQHj7Tj/2ItHb6uiO9Fso88b/teXjGI//UDP4y5MZjmaoPeZqyv5IIPz/rvI9kZVCgj572/wXyi7b8C1dBpXrjszB6vJRA=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 4/5] ide-tape: improve buffer pages freeing strategy
Date: Sat, 29 Mar 2008 18:46:08 +0100
Message-Id: <1206812769-10065-5-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1206812769-10065-1-git-send-email-petkovbb@gmail.com>
References: <1206812769-10065-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of freeing pages one by one, free them 2^order-wise. Also, mv
__idetape_kfree_stage() to ide_tape_kfree_buffer().

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   37 +++++++++++++++++++------------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index cf4351c..dcaefef 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -583,20 +583,21 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	}
 }
 
-/* Free a stage along with its related buffers completely. */
-static void __idetape_kfree_stage(idetape_stage_t *stage)
+/* Free data buffers completely. */
+static void ide_tape_kfree_buffer(idetape_stage_t *stage)
 {
 	struct idetape_bh *prev_bh, *bh = stage->bh;
-	int size;
-
-	while (bh != NULL) {
-		if (bh->b_data != NULL) {
-			size = (int) bh->b_size;
-			while (size > 0) {
-				free_page((unsigned long) bh->b_data);
-				size -= PAGE_SIZE;
-				bh->b_data += PAGE_SIZE;
-			}
+
+	while (bh) {
+		u32 size = bh->b_size;
+
+		while (size) {
+			unsigned int order = fls(size >> PAGE_SHIFT)-1;
+
+			if (bh->b_data)
+				free_pages((unsigned long)bh->b_data, order);
+
+			size &= (order-1);
 		}
 		prev_bh = bh;
 		bh = bh->b_reqnext;
@@ -1373,7 +1374,7 @@ static idetape_stage_t *ide_tape_kmalloc_buffer(idetape_tape_t *tape, int full,
 		atomic_sub(tape->excess_bh_size, &bh->b_count);
 	return stage;
 abort:
-	__idetape_kfree_stage(stage);
+	ide_tape_kfree_buffer(stage);
 	return NULL;
 }
 
@@ -1649,7 +1650,7 @@ static int __idetape_discard_read_pipeline(ide_drive_t *drive)
 	clear_bit(IDETAPE_FLAG_FILEMARK, &tape->flags);
 	tape->merge_stage_size = 0;
 	if (tape->merge_stage != NULL) {
-		__idetape_kfree_stage(tape->merge_stage);
+		ide_tape_kfree_buffer(tape->merge_stage);
 		tape->merge_stage = NULL;
 	}
 
@@ -1828,7 +1829,7 @@ static void idetape_empty_write_pipeline(ide_drive_t *drive)
 		tape->merge_stage_size = 0;
 	}
 	if (tape->merge_stage != NULL) {
-		__idetape_kfree_stage(tape->merge_stage);
+		ide_tape_kfree_buffer(tape->merge_stage);
 		tape->merge_stage = NULL;
 	}
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
@@ -1866,7 +1867,7 @@ static int idetape_init_read(ide_drive_t *drive)
 							REQ_IDETAPE_READ, 0,
 							tape->merge_stage->bh);
 			if (bytes_read < 0) {
-				__idetape_kfree_stage(tape->merge_stage);
+				ide_tape_kfree_buffer(tape->merge_stage);
 				tape->merge_stage = NULL;
 				tape->chrdev_dir = IDETAPE_DIR_NONE;
 				return bytes_read;
@@ -2145,7 +2146,7 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 							REQ_IDETAPE_WRITE, 0,
 							tape->merge_stage->bh);
 			if (retval < 0) {
-				__idetape_kfree_stage(tape->merge_stage);
+				ide_tape_kfree_buffer(tape->merge_stage);
 				tape->merge_stage = NULL;
 				tape->chrdev_dir = IDETAPE_DIR_NONE;
 				return retval;
@@ -2512,7 +2513,7 @@ static void idetape_write_release(ide_drive_t *drive, unsigned int minor)
 	if (tape->merge_stage != NULL) {
 		idetape_pad_zeros(drive, tape->blk_size *
 				(tape->user_bs_factor - 1));
-		__idetape_kfree_stage(tape->merge_stage);
+		ide_tape_kfree_buffer(tape->merge_stage);
 		tape->merge_stage = NULL;
 	}
 	idetape_write_filemark(drive);
-- 
1.5.4.1

