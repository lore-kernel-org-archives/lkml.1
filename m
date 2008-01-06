Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbYAFBVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbYAFBVk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 20:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758508AbYAFBVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 20:21:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:49822 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbYAFBVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 20:21:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=C9RjP/uDaGoXaAT4U3NiNbGWJuDY+c9QQsWsWoICyMPWpHFGK2NXZTX82sF5iZcS4LPQTjW4hP0h7JsZjVBmFwFFl+TBTkxhJYNuOSg5UNN7f6pa7wUahMTS14PxY1D1wh2OOw2Rnx7wjodZiNidIafPMM0srtzcbszvlohjQU0=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 4/7] udf: replace loops coded with goto to real loops
Date: Sun,  6 Jan 2008 02:21:50 +0100
Message-Id: <1199582513-7915-4-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199582513-7915-1-git-send-email-marcin.slusarz@gmail.com>
References: <1199582513-7915-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 fs/udf/balloc.c |  309 ++++++++++++++++++++++++++++---------------------------
 1 files changed, 157 insertions(+), 152 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index d1d4b8f..5ce7926 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -183,46 +183,46 @@ static void udf_bitmap_free_blocks(struct super_block *sb,
 	block = bloc.logicalBlockNum + offset +
 		(sizeof(struct spaceBitmapDesc) << 3);
 
-do_more:
-	overflow = 0;
-	block_group = block >> (sb->s_blocksize_bits + 3);
-	bit = block % (sb->s_blocksize << 3);
+	do {
+		overflow = 0;
+		block_group = block >> (sb->s_blocksize_bits + 3);
+		bit = block % (sb->s_blocksize << 3);
 
-	/*
-	 * Check to see if we are freeing blocks across a group boundary.
-	 */
-	if (bit + count > (sb->s_blocksize << 3)) {
-		overflow = bit + count - (sb->s_blocksize << 3);
-		count -= overflow;
-	}
-	bitmap_nr = load_block_bitmap(sb, bitmap, block_group);
-	if (bitmap_nr < 0)
-		goto error_return;
+		/*
+		* Check to see if we are freeing blocks across a group boundary.
+		*/
+		if (bit + count > (sb->s_blocksize << 3)) {
+			overflow = bit + count - (sb->s_blocksize << 3);
+			count -= overflow;
+		}
+		bitmap_nr = load_block_bitmap(sb, bitmap, block_group);
+		if (bitmap_nr < 0)
+			goto error_return;
 
-	bh = bitmap->s_block_bitmap[bitmap_nr];
-	for (i = 0; i < count; i++) {
-		if (udf_set_bit(bit + i, bh->b_data)) {
-			udf_debug("bit %ld already set\n", bit + i);
-			udf_debug("byte=%2x\n",
-				  ((char *)bh->b_data)[(bit + i) >> 3]);
-		} else {
-			if (inode)
-				DQUOT_FREE_BLOCK(inode, 1);
-			udf_inc_free_space(sbi, sbi->s_partition, 1);
+		bh = bitmap->s_block_bitmap[bitmap_nr];
+		for (i = 0; i < count; i++) {
+			if (udf_set_bit(bit + i, bh->b_data)) {
+				udf_debug("bit %ld already set\n", bit + i);
+				udf_debug("byte=%2x\n",
+					((char *)bh->b_data)[(bit + i) >> 3]);
+			} else {
+				if (inode)
+					DQUOT_FREE_BLOCK(inode, 1);
+				udf_inc_free_space(sbi, sbi->s_partition, 1);
+			}
 		}
-	}
-	mark_buffer_dirty(bh);
-	if (overflow) {
-		block += count;
-		count = overflow;
-		goto do_more;
-	}
+		mark_buffer_dirty(bh);
+		if (overflow) {
+			block += count;
+			count = overflow;
+		}
+	} while (overflow);
+
 error_return:
 	sb->s_dirt = 1;
 	if (sbi->s_lvid_bh)
 		mark_buffer_dirty(sbi->s_lvid_bh);
 	mutex_unlock(&sbi->s_alloc_mutex);
-	return;
 }
 
 static int udf_bitmap_prealloc_blocks(struct super_block *sb,
@@ -246,39 +246,40 @@ static int udf_bitmap_prealloc_blocks(struct super_block *sb,
 	if (first_block + block_count > part_len)
 		block_count = part_len - first_block;
 
-repeat:
-	nr_groups = (sbi->s_partmaps[partition].s_partition_len +
-		     (sizeof(struct spaceBitmapDesc) << 3) +
-		     (sb->s_blocksize * 8) - 1) / (sb->s_blocksize * 8);
-	block = first_block + (sizeof(struct spaceBitmapDesc) << 3);
-	block_group = block >> (sb->s_blocksize_bits + 3);
-	group_start = block_group ? 0 : sizeof(struct spaceBitmapDesc);
+	do {
+		nr_groups = (sbi->s_partmaps[partition].s_partition_len +
+			(sizeof(struct spaceBitmapDesc) << 3) +
+			(sb->s_blocksize * 8) - 1) / (sb->s_blocksize * 8);
+		block = first_block + (sizeof(struct spaceBitmapDesc) << 3);
+		block_group = block >> (sb->s_blocksize_bits + 3);
+		group_start = block_group ? 0 : sizeof(struct spaceBitmapDesc);
 
-	bitmap_nr = load_block_bitmap(sb, bitmap, block_group);
-	if (bitmap_nr < 0)
-		goto out;
-	bh = bitmap->s_block_bitmap[bitmap_nr];
+		bitmap_nr = load_block_bitmap(sb, bitmap, block_group);
+		if (bitmap_nr < 0)
+			goto out;
+		bh = bitmap->s_block_bitmap[bitmap_nr];
 
-	bit = block % (sb->s_blocksize << 3);
+		bit = block % (sb->s_blocksize << 3);
 
-	while (bit < (sb->s_blocksize << 3) && block_count > 0) {
-		if (!udf_test_bit(bit, bh->b_data)) {
-			goto out;
-		} else if (DQUOT_PREALLOC_BLOCK(inode, 1)) {
-			goto out;
-		} else if (!udf_clear_bit(bit, bh->b_data)) {
-			udf_debug("bit already cleared for block %d\n", bit);
-			DQUOT_FREE_BLOCK(inode, 1);
-			goto out;
+		while (bit < (sb->s_blocksize << 3) && block_count > 0) {
+			if (!udf_test_bit(bit, bh->b_data))
+				goto out;
+			else if (DQUOT_PREALLOC_BLOCK(inode, 1))
+				goto out;
+			else if (!udf_clear_bit(bit, bh->b_data)) {
+				udf_debug("bit already cleared for block %d\n",
+					  bit);
+				DQUOT_FREE_BLOCK(inode, 1);
+				goto out;
+			}
+			block_count--;
+			alloc_count++;
+			bit++;
+			block++;
 		}
-		block_count--;
-		alloc_count++;
-		bit++;
-		block++;
-	}
-	mark_buffer_dirty(bh);
-	if (block_count > 0)
-		goto repeat;
+		mark_buffer_dirty(bh);
+	} while (block_count > 0);
+
 out:
 	if (udf_inc_free_space(sbi, partition, -alloc_count))
 		mark_buffer_dirty(sbi->s_lvid_bh);
@@ -298,117 +299,121 @@ static int udf_bitmap_new_block(struct super_block *sb,
 	struct buffer_head *bh = NULL;
 	char *ptr;
 	int newblock = 0;
+	bool bit_already_cleared;
 
 	*err = -ENOSPC;
 	mutex_lock(&sbi->s_alloc_mutex);
 
-repeat:
-	if (goal < 0 || goal >= sbi->s_partmaps[partition].s_partition_len)
-		goal = 0;
-
-	nr_groups = bitmap->s_nr_groups;
-	block = goal + (sizeof(struct spaceBitmapDesc) << 3);
-	block_group = block >> (sb->s_blocksize_bits + 3);
-	group_start = block_group ? 0 : sizeof(struct spaceBitmapDesc);
-
-	bitmap_nr = load_block_bitmap(sb, bitmap, block_group);
-	if (bitmap_nr < 0)
-		goto error_return;
-	bh = bitmap->s_block_bitmap[bitmap_nr];
-	ptr = memscan((char *)bh->b_data + group_start, 0xFF,
-		      sb->s_blocksize - group_start);
-
-	if ((ptr - ((char *)bh->b_data)) < sb->s_blocksize) {
-		bit = block % (sb->s_blocksize << 3);
-		if (udf_test_bit(bit, bh->b_data))
-			goto got_block;
-
-		end_goal = (bit + 63) & ~63;
-		bit = udf_find_next_one_bit(bh->b_data, end_goal, bit);
-		if (bit < end_goal)
-			goto got_block;
-
-		ptr = memscan((char *)bh->b_data + (bit >> 3), 0xFF,
-			      sb->s_blocksize - ((bit + 7) >> 3));
-		newbit = (ptr - ((char *)bh->b_data)) << 3;
-		if (newbit < sb->s_blocksize << 3) {
-			bit = newbit;
-			goto search_back;
-		}
-
-		newbit = udf_find_next_one_bit(bh->b_data,
-					       sb->s_blocksize << 3, bit);
-		if (newbit < sb->s_blocksize << 3) {
-			bit = newbit;
-			goto got_block;
-		}
-	}
+	do {
+		if (goal < 0 ||
+		    goal >= sbi->s_partmaps[partition].s_partition_len)
+			goal = 0;
 
-	for (i = 0; i < (nr_groups * 2); i++) {
-		block_group++;
-		if (block_group >= nr_groups)
-			block_group = 0;
+		nr_groups = bitmap->s_nr_groups;
+		block = goal + (sizeof(struct spaceBitmapDesc) << 3);
+		block_group = block >> (sb->s_blocksize_bits + 3);
 		group_start = block_group ? 0 : sizeof(struct spaceBitmapDesc);
 
 		bitmap_nr = load_block_bitmap(sb, bitmap, block_group);
 		if (bitmap_nr < 0)
 			goto error_return;
 		bh = bitmap->s_block_bitmap[bitmap_nr];
-		if (i < nr_groups) {
-			ptr = memscan((char *)bh->b_data + group_start, 0xFF,
-				      sb->s_blocksize - group_start);
-			if ((ptr - ((char *)bh->b_data)) < sb->s_blocksize) {
-				bit = (ptr - ((char *)bh->b_data)) << 3;
-				break;
+		ptr = memscan(bh->b_data + group_start, 0xFF,
+			sb->s_blocksize - group_start);
+
+		if ((ptr - bh->b_data) < sb->s_blocksize) {
+			bit = block % (sb->s_blocksize << 3);
+			if (udf_test_bit(bit, bh->b_data))
+				goto got_block;
+
+			end_goal = (bit + 63) & ~63;
+			bit = udf_find_next_one_bit(bh->b_data, end_goal, bit);
+			if (bit < end_goal)
+				goto got_block;
+
+			ptr = memscan(bh->b_data + (bit >> 3), 0xFF,
+				sb->s_blocksize - ((bit + 7) >> 3));
+			newbit = (ptr - bh->b_data) << 3;
+			if (newbit < sb->s_blocksize << 3) {
+				bit = newbit;
+				goto search_back;
+			}
+
+			newbit = udf_find_next_one_bit(bh->b_data,
+						sb->s_blocksize << 3, bit);
+			if (newbit < sb->s_blocksize << 3) {
+				bit = newbit;
+				goto got_block;
 			}
-		} else {
-			bit = udf_find_next_one_bit((char *)bh->b_data,
-						    sb->s_blocksize << 3,
-						    group_start << 3);
-			if (bit < sb->s_blocksize << 3)
-				break;
 		}
-	}
-	if (i >= (nr_groups * 2)) {
-		mutex_unlock(&sbi->s_alloc_mutex);
-		return newblock;
-	}
-	if (bit < sb->s_blocksize << 3)
-		goto search_back;
-	else
-		bit = udf_find_next_one_bit(bh->b_data, sb->s_blocksize << 3,
-					    group_start << 3);
-	if (bit >= sb->s_blocksize << 3) {
-		mutex_unlock(&sbi->s_alloc_mutex);
-		return 0;
-	}
+
+		for (i = 0; i < (nr_groups * 2); i++) {
+			block_group++;
+			if (block_group >= nr_groups)
+				block_group = 0;
+			group_start = block_group ?
+					0 : sizeof(struct spaceBitmapDesc);
+
+			bitmap_nr = load_block_bitmap(sb, bitmap, block_group);
+			if (bitmap_nr < 0)
+				goto error_return;
+			bh = bitmap->s_block_bitmap[bitmap_nr];
+			if (i < nr_groups) {
+				ptr = memscan(bh->b_data + group_start,
+					0xFF, sb->s_blocksize - group_start);
+				if ((ptr - bh->b_data) < sb->s_blocksize) {
+					bit = (ptr - bh->b_data) << 3;
+					break;
+				}
+			} else {
+				bit = udf_find_next_one_bit(bh->b_data,
+							sb->s_blocksize << 3,
+							group_start << 3);
+				if (bit < sb->s_blocksize << 3)
+					break;
+			}
+		}
+		if (i >= (nr_groups * 2)) {
+			mutex_unlock(&sbi->s_alloc_mutex);
+			return newblock;
+		}
+		if (bit < sb->s_blocksize << 3)
+			goto search_back;
+		else
+			bit = udf_find_next_one_bit(bh->b_data,
+							sb->s_blocksize << 3,
+							group_start << 3);
+		if (bit >= sb->s_blocksize << 3) {
+			mutex_unlock(&sbi->s_alloc_mutex);
+			return 0;
+		}
 
 search_back:
-	i = 0;
-	while (i < 7 && bit > (group_start << 3) &&
-	       udf_test_bit(bit - 1, bh->b_data)) {
-		++i;
-		--bit;
-	}
+		i = 0;
+		while (i < 7 && bit > (group_start << 3) &&
+				udf_test_bit(bit - 1, bh->b_data)) {
+			++i;
+			--bit;
+		}
 
 got_block:
 
-	/*
-	 * Check quota for allocation of this block.
-	 */
-	if (inode && DQUOT_ALLOC_BLOCK(inode, 1)) {
-		mutex_unlock(&sbi->s_alloc_mutex);
-		*err = -EDQUOT;
-		return 0;
-	}
+		/*
+		* Check quota for allocation of this block.
+		*/
+		if (inode && DQUOT_ALLOC_BLOCK(inode, 1)) {
+			mutex_unlock(&sbi->s_alloc_mutex);
+			*err = -EDQUOT;
+			return 0;
+		}
 
-	newblock = bit + (block_group << (sb->s_blocksize_bits + 3)) -
-		(sizeof(struct spaceBitmapDesc) << 3);
+		newblock = bit + (block_group << (sb->s_blocksize_bits + 3)) -
+			(sizeof(struct spaceBitmapDesc) << 3);
 
-	if (!udf_clear_bit(bit, bh->b_data)) {
-		udf_debug("bit already cleared for block %d\n", bit);
-		goto repeat;
-	}
+		bit_already_cleared = !udf_clear_bit(bit, bh->b_data);
+		if (bit_already_cleared)
+			udf_debug("bit already cleared for block %d\n", bit);
+	} while (bit_already_cleared);
 
 	mark_buffer_dirty(bh);
 
-- 
1.5.3.7

