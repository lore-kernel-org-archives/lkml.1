Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbYC2RqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbYC2RqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 13:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYC2Rp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 13:45:59 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:23055 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbYC2Rp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 13:45:58 -0400
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 1/5] ide-tape: improve buffer allocation strategy
Date: Sat, 29 Mar 2008 18:46:05 +0100
Message-Id: <1206812769-10065-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1206812769-10065-1-git-send-email-petkovbb@gmail.com>
References: <1206812769-10065-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of allocating pages for the buffer one by one, take advantage of the
buddy alloc system and request them 2^order at a time. This increases the chance
for bigger buffer parts to be contigious and reduces loop iteration count. While
at it, rename function __idetape_kmalloc_stage() to ide_tape_kmalloc_buffer().

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   58 +++++++++++++++++++++++++++++------------------
 1 files changed, 36 insertions(+), 22 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 6752d47..b5ec669 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1290,20 +1290,20 @@ out:
 }
 
 /*
- * The function below uses __get_free_page to allocate a pipeline stage, along
- * with all the necessary small buffers which together make a buffer of size
+ * The function below uses __get_free_pages to allocate a data buffer of size
  * tape->stage_size (or a bit more). We attempt to combine sequential pages as
  * much as possible.
  *
- * It returns a pointer to the new allocated stage, or NULL if we can't (or
- * don't want to) allocate a stage.
+ * It returns a pointer to the newly allocated buffer, or NULL in case of
+ * failure.
  */
-static idetape_stage_t *__idetape_kmalloc_stage(idetape_tape_t *tape, int full,
+static idetape_stage_t *ide_tape_kmalloc_buffer(idetape_tape_t *tape, int full,
 						int clear)
 {
 	idetape_stage_t *stage;
 	struct idetape_bh *prev_bh, *bh;
 	int pages = tape->pages_per_stage;
+	unsigned int order, b_allocd;
 	char *b_data = NULL;
 
 	stage = kmalloc(sizeof(idetape_stage_t), GFP_KERNEL);
@@ -1315,32 +1315,43 @@ static idetape_stage_t *__idetape_kmalloc_stage(idetape_tape_t *tape, int full,
 	bh = stage->bh;
 	if (bh == NULL)
 		goto abort;
-	bh->b_reqnext = NULL;
-	bh->b_data = (char *) __get_free_page(GFP_KERNEL);
+
+	order = fls(pages) - 1;
+	bh->b_data = (char *) __get_free_pages(GFP_KERNEL, order);
 	if (!bh->b_data)
 		goto abort;
+	b_allocd = (1 << order) * PAGE_SIZE;
+	pages &= (order-1);
+
 	if (clear)
-		memset(bh->b_data, 0, PAGE_SIZE);
-	bh->b_size = PAGE_SIZE;
+		memset(bh->b_data, 0, b_allocd);
+	bh->b_reqnext = NULL;
+	bh->b_size = b_allocd;
 	atomic_set(&bh->b_count, full ? bh->b_size : 0);
 
-	while (--pages) {
-		b_data = (char *) __get_free_page(GFP_KERNEL);
+	while (pages) {
+		order = fls(pages) - 1;
+		b_data = (char *) __get_free_pages(GFP_KERNEL, order);
 		if (!b_data)
 			goto abort;
+		b_allocd = (1 << order) * PAGE_SIZE;
+
 		if (clear)
-			memset(b_data, 0, PAGE_SIZE);
-		if (bh->b_data == b_data + PAGE_SIZE) {
-			bh->b_size += PAGE_SIZE;
-			bh->b_data -= PAGE_SIZE;
+			memset(b_data, 0, b_allocd);
+
+		/* newly allocated page frames below buffer header or ...*/
+		if (bh->b_data == b_data + b_allocd) {
+			bh->b_size += b_allocd;
+			bh->b_data -= b_allocd;
 			if (full)
-				atomic_add(PAGE_SIZE, &bh->b_count);
+				atomic_add(b_allocd, &bh->b_count);
 			continue;
 		}
+		/* they are above the header */
 		if (b_data == bh->b_data + bh->b_size) {
-			bh->b_size += PAGE_SIZE;
+			bh->b_size += b_allocd;
 			if (full)
-				atomic_add(PAGE_SIZE, &bh->b_count);
+				atomic_add(b_allocd, &bh->b_count);
 			continue;
 		}
 		prev_bh = bh;
@@ -1351,10 +1362,13 @@ static idetape_stage_t *__idetape_kmalloc_stage(idetape_tape_t *tape, int full,
 		}
 		bh->b_reqnext = NULL;
 		bh->b_data = b_data;
-		bh->b_size = PAGE_SIZE;
+		bh->b_size = b_allocd;
 		atomic_set(&bh->b_count, full ? bh->b_size : 0);
 		prev_bh->b_reqnext = bh;
+
+		pages &= (order-1);
 	}
+
 	bh->b_size -= tape->excess_bh_size;
 	if (full)
 		atomic_sub(tape->excess_bh_size, &bh->b_count);
@@ -1837,7 +1851,7 @@ static int idetape_init_read(ide_drive_t *drive)
 					 " 0 now\n");
 			tape->merge_stage_size = 0;
 		}
-		tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0);
+		tape->merge_stage = ide_tape_kmalloc_buffer(tape, 0, 0);
 		if (!tape->merge_stage)
 			return -ENOMEM;
 		tape->chrdev_dir = IDETAPE_DIR_READ;
@@ -2115,7 +2129,7 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 				"should be 0 now\n");
 			tape->merge_stage_size = 0;
 		}
-		tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0);
+		tape->merge_stage = ide_tape_kmalloc_buffer(tape, 0, 0);
 		if (!tape->merge_stage)
 			return -ENOMEM;
 		tape->chrdev_dir = IDETAPE_DIR_WRITE;
@@ -2495,7 +2509,7 @@ static void idetape_write_release(ide_drive_t *drive, unsigned int minor)
 	idetape_tape_t *tape = drive->driver_data;
 
 	idetape_empty_write_pipeline(drive);
-	tape->merge_stage = __idetape_kmalloc_stage(tape, 1, 0);
+	tape->merge_stage = ide_tape_kmalloc_buffer(tape, 1, 0);
 	if (tape->merge_stage != NULL) {
 		idetape_pad_zeros(drive, tape->blk_size *
 				(tape->user_bs_factor - 1));
-- 
1.5.4.1

