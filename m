Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbXLUOPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbXLUOPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 09:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbXLUOP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 09:15:26 -0500
Received: from smtp-out.google.com ([216.239.33.17]:30510 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbXLUOPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 09:15:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=of3rd+ieMqWdctN15F4fAmh0vxrTogk+k8hQUXZexC1+GfyZGw/kod0kdiInr7gHX
	MMY/i80etOpJF3heo2JNw==
Message-ID: <d9885f0f0712210615h661ad458x2cf4e4d0e8868772@mail.gmail.com>
Date: Fri, 21 Dec 2007 06:15:13 -0800
From: "Abhishek Rai" <abhishekrai@google.com>
To: "Theodore Tso" <tytso@mit.edu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Andreas Dilger" <adilger@sun.com>, linux-kernel@vger.kernel.org,
       "Ken Chen" <kenchen@google.com>, "Mike Waychison" <mikew@google.com>
Subject: Re: [PATCH] Clustering indirect blocks in Ext3
In-Reply-To: <20071117025841.GK11339@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9885f0f0711152102h7a8270bfvd65605d8c00e6754@mail.gmail.com>
	 <20071115230219.1fe9338c.akpm@linux-foundation.org>
	 <20071116211133.GJ11339@thunk.org>
	 <d9885f0f0711161625u76c6e6dbgf3fbabe8a11e771b@mail.gmail.com>
	 <20071117025841.GK11339@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have implemented a revised patch that addresses the concerns raised
with the previous patch. To summarize, here were the three main
concerns:

1. Metacluster size is sensitive to average file size in the
block-group/file-system so how do we find a good metacluster size ?
The last discussion we had on this topic was to have multiple
metaclusters of different sizes per group and have direct blocks
overflow towards smaller metacluster sizes and indirect blocks
overflow towards bigger metaclusters. The overflowing from one
metacluster level to the next would happen only when none of the block
groups have any free blocks left at that metacluster level, IOW
overflowing was a file system wide event.

2. When indirect block allocation in metacluster fails, don't fully
fall back to old-style allocation scheme, instead fall back to
old-style scheme only for that block group and repeat this for each
block group: Now all this happens in ext3_new_blocks(). To control the
size of that function, created a few helper functions.

3. Don't have separate functions for allocating indirect and direct
blocks as there is considerable overlap especially in the journaling
code: Rolled the two functions into one ext3_new_blocks() function
which is directly called from ext3_alloc_branch() instead of via
ext3_alloc_blocks() (which is nuked now).

The current approach I've implemented is similar in principle but it
fixes a problem with the above scheme. The above scheme of overflowing
into the next "metacluster level" upon exhaustion of current
metacluster level across all block groups results in increased
fragmentation. E.g., say a block group BG1 ran out of blocks at
metacluster (mc) level X and now wants to use the next level. It
checks and find that a different block group BG2 still has free blocks
at mc level X so it starts using level X in BG2 which results in the
file getting fragmented. In the new patch, we'd continue using level
X+1 in BG1 to reduce overall fragmentation and so the new patch
results in overflow only within the same block group.

Also, I've chosen a simpler implementation for this multi-level
metaclustering scheme by not having real metacluster levels but by
having direct blocks and indirect blocks grow towards each other from
opposite ends of the block group. Both are conceptually the same. Now
the overflow condition is that direct block allocation cannot spill
into indirect block region (the metacluster) and vice versa unless it
has run out of free blocks in its own region. This information is now
available through a new memory-only per-block counter that keeps a
count of the number of free blocks in the non-metacluster region. This
also addresses Andreas Dilger's concern with the previous
implementation regarding metaclusters increasing fragmentation by
splitting the block group into two halves.

Putting metacluster at the end of the block group gives slightly
inferior sequential read throughput compared to putting it in the
beginning or the middle, but the difference is very tiny and exists
only for large files that span multiple block groups.

Since there are couple of ways in which this change differs from
before, I repeated the testing and performance evaluation. The new
change passed
fsx, fsstress, and bonnie - both with and without metaclustering.
Also, I checked that the block layout on disk is coming out to be what
one would expect from the code.

Here are the performance numbers. The setup was somewhat different
from the previous setup so I've gotten fresh numbers for the vanilla
case as well.

Setup:
RAM: 8GB
Disk: 400GB disk.
CPU: Dual core hyperthreaded

All measurements were taken 10 times or more until standard deviation
was <2%. Machine was rebooted between runs and file system freshly
formatted, also we made sure that there was nothing running on the
machine at the time of the test.

Notation:
- 'vanilla': regular ext3 without any changes
- 'mc': metaclustering ext3 (new)

Benchmark 1: Sequential write to a 10GB file followed by 'sync'
1. vanilla:
 Total: 3m39.1s
 User: 0.08
 System: 51.9s
2. mc:
 Total: 3m11.5s
 User: 0.06s
 System: 53.6s

Benchmark 2: Sequential read from a 10GB file.
Description: the file is created using same type of ext2 (mc or vanilla)
1. vanilla:
 Total: 3m6.5s
 User: 0.04s
 System: 13.4s
2. mc:
 Total: 3m7.0s
 User: 0.05s
 System: 13.1s

Benchmark 3: Random read from a 300GB file
Description: read using 512 byte chunk total 5MB
1. vanilla:
 Total: 3m57.0s
 User: ~0
 System: 0.8s
2. mc:
 Total: 3m56.4s
 User: ~0
 System: 0.9s

Benchmark 4: Random read from a 300GB file
Description: read using 512KB chunk total 1% size of the file
1. vanilla:
 Total: 4m50.3s
 User: ~0
 System: 3.9s
2. mc:
 Total: 4m56.9s
 User: ~0
 System: 3.9s

Benchmark 5: fsck
Description: Prepare a newly formated 400GB disk as follows: create
200 files of 0.5GB each, 100 files of 1GB each, 40 files of 2.5GB ech,
and 10 files of 10GB each. fsck command line: fsck -f -n
1. vanilla:
 Total: 11m25.3s
 User: 13.4s
 System: 13.2s
2. mc:
 Total: 3m11.0s
 User: 13.1s
 System: 12.9s


Note: I'll report results from kernbench and compilebench shortly.

Observations:
Sequential write performance is much better with metaclustering than
with vanilla. To better understand it, I ran the same benchmark with the
new code but with the metaclustering option turned off and I got the
same performance as vanilla which makes me believe that there is
something about metaclustering that helps write performance though I
don't have a very good handle of what that thing might be.

Thanks,
Abhishek

Signed-off-by: Abhishek Rai <abhishekrai@google.com>

diff -uprdN linux-2.6.23mm1-clean/fs/ext3/balloc.c
linux-2.6.23mm1-ext3mc/fs/ext3/balloc.c
--- linux-2.6.23mm1-clean/fs/ext3/balloc.c	2007-10-17 18:31:42.000000000 -0700
+++ linux-2.6.23mm1-ext3mc/fs/ext3/balloc.c	2007-12-21 05:34:35.000000000 -0800
@@ -33,6 +33,29 @@
  * super block.  Each descriptor contains the number of the bitmap block and
  * the free blocks count in the block.  The descriptors are loaded in memory
  * when a file system is mounted (see ext3_fill_super).
+ *
+ * A note on ext3 metaclustering:
+ *
+ * 	Start of						End of
+ * 	block group						block group
+ * 	 ________________________________________________________________
+ * 	|	NON-MC REGION			|	MC REGION	 |
+ * 	|					|Overflow		 |
+ * 	|Data blocks and			|data		Indirect |
+ * 	|overflow indirect blocks		|blocks		blocks	 |
+ * 	|----------> 				|------->	<--------|
+ * 	|________________________________________________________________|
+ *
+ * 	Every block group has at its end a semi-reserved region called the
+ * 	metacluster mostly used for allocating indirect blocks. Under normal
+ * 	circumstances, the metacluster is used only for allocating indirect
+ * 	blocks which are allocated in decreasing order of block numbers.
+ * 	The non-Metacluster region is used for data block allocation which are
+ * 	allocated in increasing order of block numbers. However, when the MC
+ * 	runs out of space, indirect blocks can be allocated in the non-MC
+ * 	region along with the data blocks in the forward direction. Similarly,
+ * 	when non-MC runs out of space, new data blocks are allocated in MC but
+ * 	in the forward direction.
  */


@@ -147,6 +170,88 @@ error_out:
 			block_group, bitmap_blk);
 	return NULL;
 }
+
+
+/*
+ * Count number of free blocks in a block group that don't lie in the
+ * metacluster region of the block group.
+ */
+static void
+ext3_init_grp_free_nonmc_blocks(struct super_block *sb,
+				struct buffer_head *bitmap_bh,
+				unsigned long block_group)
+{
+	struct ext3_sb_info *sbi = EXT3_SB(sb);
+	struct ext3_bg_info *bgi = &sbi->s_bginfo[block_group];
+
+	BUG_ON(!test_opt(sb, METACLUSTER));
+
+	spin_lock(sb_bgl_lock(sbi, block_group));
+	if (bgi->bgi_free_nonmc_blocks_count >= 0)
+		goto out;
+
+	bgi->bgi_free_nonmc_blocks_count =
+		ext3_count_free(bitmap_bh, sbi->s_nonmc_blocks_per_group/8);
+
+out:
+	spin_unlock(sb_bgl_lock(sbi, block_group));
+	BUG_ON(bgi->bgi_free_nonmc_blocks_count >
+		sbi->s_nonmc_blocks_per_group);
+}
+
+/*
+ * ext3_update_nonmc_block_count:
+ *	Update bgi_free_nonmc_blocks_count for block group 'group_no' following
+ *	an allocation or deallocation.
+ *
+ *	@group_no:	affected block group
+ *	@start:		start of the [de]allocated range
+ *	@count:		number of blocks [de]allocated
+ *	@allocation:	1 if blocks were allocated, 0 otherwise.
+ */
+static inline void
+ext3_update_nonmc_block_count(struct ext3_sb_info *sbi, unsigned long group_no,
+				ext3_grpblk_t start, unsigned long count,
+				int allocation)
+{
+	struct ext3_bg_info *bginfo = &sbi->s_bginfo[group_no];
+	ext3_grpblk_t change;
+
+	BUG_ON(bginfo->bgi_free_nonmc_blocks_count < 0);
+	BUG_ON(start >= sbi->s_nonmc_blocks_per_group);
+
+	change = min_t(ext3_grpblk_t, start + count,
+			sbi->s_nonmc_blocks_per_group) - start;
+
+	spin_lock(sb_bgl_lock(sbi, group_no));
+	BUG_ON(bginfo->bgi_free_nonmc_blocks_count >
+		sbi->s_nonmc_blocks_per_group);
+	BUG_ON(allocation && bginfo->bgi_free_nonmc_blocks_count < change);
+
+	bginfo->bgi_free_nonmc_blocks_count += (allocation ? -change : change);
+
+	BUG_ON(bginfo->bgi_free_nonmc_blocks_count >
+		sbi->s_nonmc_blocks_per_group);
+	spin_unlock(sb_bgl_lock(sbi, group_no));
+}
+
+/*
+ * allow_mc_alloc:
+ * 	Check if we can use metacluster region of a block group for general
+ * 	allocation if needed. Ideally, we should allow this only if
+ * 	bgi_free_nonmc_blocks_count == 0, but sometimes there is a small number
+ * 	of blocks which don't get allocated in the first pass, no point
+ * 	breaking our file at the metacluster boundary because of that, so we
+ * 	relax the limit to 8.
+ */
+static inline int allow_mc_alloc(struct ext3_sb_info *sbi,
+					struct ext3_bg_info *bgi,
+					ext3_grpblk_t blk)
+{
+	return !(blk >= 0 && blk >= sbi->s_nonmc_blocks_per_group &&
+		bgi->bgi_free_nonmc_blocks_count >= 8);
+}
+
 /*
  * The reservation window structure operations
  * --------------------------------------------
@@ -463,6 +568,7 @@ void ext3_free_blocks_sb(handle_t *handl
 	struct ext3_group_desc * desc;
 	struct ext3_super_block * es;
 	struct ext3_sb_info *sbi;
+	struct ext3_bg_info *bgi;
 	int err = 0, ret;
 	ext3_grpblk_t group_freed;

@@ -502,6 +608,13 @@ do_more:
 	if (!desc)
 		goto error_return;

+	if (test_opt(sb, METACLUSTER)) {
+		bgi = &sbi->s_bginfo[block_group];
+		if (bgi->bgi_free_nonmc_blocks_count < 0)
+			ext3_init_grp_free_nonmc_blocks(sb, bitmap_bh,
+							block_group);
+	}
+
 	if (in_range (le32_to_cpu(desc->bg_block_bitmap), block, count) ||
 	    in_range (le32_to_cpu(desc->bg_inode_bitmap), block, count) ||
 	    in_range (block, le32_to_cpu(desc->bg_inode_table),
@@ -621,6 +734,9 @@ do_more:
 	if (!err) err = ret;
 	*pdquot_freed_blocks += group_freed;

+	if (test_opt(sb, METACLUSTER) && bit < sbi->s_nonmc_blocks_per_group)
+		ext3_update_nonmc_block_count(sbi, block_group, bit, count, 0);
+
 	if (overflow && !err) {
 		block += count;
 		count = overflow;
@@ -726,6 +842,50 @@ bitmap_search_next_usable_block(ext3_grp
 	return -1;
 }

+static ext3_grpblk_t
+bitmap_find_prev_zero_bit(char *map, ext3_grpblk_t start, ext3_grpblk_t lowest)
+{
+	ext3_grpblk_t k, blk;
+
+	k = start & ~7;
+	while (lowest <= k) {
+		if (map[k/8] != '\255' &&
+			(blk = ext3_find_next_zero_bit(map, k + 8, k))
+			 < (k + 8))
+				return blk;
+
+		k -= 8;
+	}
+	return -1;
+}
+
+static ext3_grpblk_t
+bitmap_search_prev_usable_block(ext3_grpblk_t start, struct buffer_head *bh,
+					ext3_grpblk_t lowest)
+{
+	ext3_grpblk_t next;
+	struct journal_head *jh = bh2jh(bh);
+
+	/*
+	 * The bitmap search --- search backward alternately through the actual
+	 * bitmap and the last-committed copy until we find a bit free in
+	 * both
+	 */
+	while (start >= lowest) {
+		next = bitmap_find_prev_zero_bit(bh->b_data, start, lowest);
+		if (next < lowest)
+			return -1;
+		if (ext3_test_allocatable(next, bh))
+			return next;
+		jbd_lock_bh_state(bh);
+		if (jh->b_committed_data)
+			start = bitmap_find_prev_zero_bit(jh->b_committed_data,
+								next, lowest);
+		jbd_unlock_bh_state(bh);
+	}
+	return -1;
+}
+
 /**
  * find_next_usable_block()
  * @start:		the starting block (group relative) to find next
@@ -833,19 +993,27 @@ claim_block(spinlock_t *lock, ext3_grpbl
  *	file's own reservation window;
  *	Otherwise, the allocation range starts from the give goal block, ends at
  *	the block group's last block.
- *
- * If we failed to allocate the desired block then we may end up crossing to a
- * new bitmap.  In that case we must release write access to the old one via
- * ext3_journal_release_buffer(), else we'll run out of credits.
  */
 static ext3_grpblk_t
 ext3_try_to_allocate(struct super_block *sb, handle_t *handle, int group,
 			struct buffer_head *bitmap_bh, ext3_grpblk_t grp_goal,
 			unsigned long *count, struct ext3_reserve_window *my_rsv)
 {
+	struct ext3_sb_info *sbi = EXT3_SB(sb);
+	struct ext3_group_desc *gdp;
+	struct ext3_bg_info *bgi = NULL;
+	struct buffer_head *gdp_bh;
 	ext3_fsblk_t group_first_block;
 	ext3_grpblk_t start, end;
 	unsigned long num = 0;
+	const int metaclustering = test_opt(sb, METACLUSTER);
+
+	if (metaclustering)
+		bgi = &sbi->s_bginfo[group];
+
+	gdp = ext3_get_group_desc(sb, group, &gdp_bh);
+	if (!gdp)
+		goto fail_access;

 	/* we do allocation within the reservation window if we have a window */
 	if (my_rsv) {
@@ -890,8 +1058,10 @@ repeat:
 	}
 	start = grp_goal;

-	if (!claim_block(sb_bgl_lock(EXT3_SB(sb), group),
-		grp_goal, bitmap_bh)) {
+	if (metaclustering && !allow_mc_alloc(sbi, bgi, grp_goal))
+		goto fail_access;
+
+	if (!claim_block(sb_bgl_lock(sbi, group), grp_goal, bitmap_bh)) {
 		/*
 		 * The block was allocated by another thread, or it was
 		 * allocated and then freed by another thread
@@ -906,8 +1076,8 @@ repeat:
 	grp_goal++;
 	while (num < *count && grp_goal < end
 		&& ext3_test_allocatable(grp_goal, bitmap_bh)
-		&& claim_block(sb_bgl_lock(EXT3_SB(sb), group),
-				grp_goal, bitmap_bh)) {
+		&& (!metaclustering || allow_mc_alloc(sbi, bgi, grp_goal))
+		&& claim_block(sb_bgl_lock(sbi, group), grp_goal, bitmap_bh)) {
 		num++;
 		grp_goal++;
 	}
@@ -1138,7 +1308,9 @@ static int alloc_new_reservation(struct

 	/*
 	 * find_next_reservable_window() simply finds a reservable window
-	 * inside the given range(start_block, group_end_block).
+	 * inside the given range(start_block, group_end_block). The
+	 * reservation window must have a reservable free bit inside it for our
+	 * callers to work correctly.
 	 *
 	 * To make sure the reservation window has a free bit inside it, we
 	 * need to check the bitmap after we found a reservable window.
@@ -1170,10 +1342,17 @@ retry:
 			my_rsv->rsv_start - group_first_block,
 			bitmap_bh, group_end_block - group_first_block + 1);

-	if (first_free_block < 0) {
+	if (first_free_block < 0 ||
+		(test_opt(sb, METACLUSTER)
+		 && !allow_mc_alloc(EXT3_SB(sb), &EXT3_SB(sb)->s_bginfo[group],
+			 		first_free_block))) {
 		/*
-		 * no free block left on the bitmap, no point
-		 * to reserve the space. return failed.
+		 * No free block left on the bitmap, no point to reserve space,
+		 * return failed. We also fail here if metaclustering is enabled
+		 * and the first free block in the window lies in the
+		 * metacluster while there are free non-mc blocks in the block
+		 * group, such a window or any window following it is not useful
+		 * to us.
 		 */
 		spin_lock(rsv_lock);
 		if (!rsv_is_empty(&my_rsv->rsv_window))
@@ -1276,25 +1455,17 @@ ext3_try_to_allocate_with_rsv(struct sup
 			unsigned int group, struct buffer_head *bitmap_bh,
 			ext3_grpblk_t grp_goal,
 			struct ext3_reserve_window_node * my_rsv,
-			unsigned long *count, int *errp)
+			unsigned long *count)
 {
+	struct ext3_bg_info *bgi;
 	ext3_fsblk_t group_first_block, group_last_block;
 	ext3_grpblk_t ret = 0;
-	int fatal;
 	unsigned long num = *count;

-	*errp = 0;
-
-	/*
-	 * Make sure we use undo access for the bitmap, because it is critical
-	 * that we do the frozen_data COW on bitmap buffers in all cases even
-	 * if the buffer is in BJ_Forget state in the committing transaction.
-	 */
-	BUFFER_TRACE(bitmap_bh, "get undo access for new block");
-	fatal = ext3_journal_get_undo_access(handle, bitmap_bh);
-	if (fatal) {
-		*errp = fatal;
-		return -1;
+	if (test_opt(sb, METACLUSTER)) {
+		bgi = &EXT3_SB(sb)->s_bginfo[group];
+		if (bgi->bgi_free_nonmc_blocks_count < 0)
+			ext3_init_grp_free_nonmc_blocks(sb, bitmap_bh, group);
 	}

 	/*
@@ -1370,19 +1541,6 @@ ext3_try_to_allocate_with_rsv(struct sup
 		num = *count;
 	}
 out:
-	if (ret >= 0) {
-		BUFFER_TRACE(bitmap_bh, "journal_dirty_metadata for "
-					"bitmap block");
-		fatal = ext3_journal_dirty_metadata(handle, bitmap_bh);
-		if (fatal) {
-			*errp = fatal;
-			return -1;
-		}
-		return ret;
-	}
-
-	BUFFER_TRACE(bitmap_bh, "journal_release_buffer");
-	ext3_journal_release_buffer(handle, bitmap_bh);
 	return ret;
 }

@@ -1428,22 +1586,149 @@ int ext3_should_retry_alloc(struct super
 	return journal_force_commit_nested(EXT3_SB(sb)->s_journal);
 }

+/*
+ * ext3_alloc_indirect_blocks:
+ * 	Helper function for ext3_new_blocks. Allocates indirect blocks from the
+ * 	metacluster region only and stores their numbers in new_blocks[].
+ */
+int ext3_alloc_indirect_blocks(struct super_block *sb,
+			struct buffer_head *bitmap_bh,
+			struct ext3_group_desc *gdp,
+			int group_no, unsigned long indirect_blks,
+			ext3_fsblk_t new_blocks[])
+{
+	struct ext3_bg_info *bgi = &EXT3_SB(sb)->s_bginfo[group_no];
+	ext3_grpblk_t blk = EXT3_BLOCKS_PER_GROUP(sb) - 1;
+	ext3_grpblk_t mc_start = EXT3_SB(sb)->s_nonmc_blocks_per_group;
+	ext3_fsblk_t group_first_block;
+	int allocated = 0;
+
+	BUG_ON(!test_opt(sb, METACLUSTER));
+
+	/* This check is racy but that wouldn't harm us. */
+	if (bgi->bgi_free_nonmc_blocks_count >=
+		le16_to_cpu(gdp->bg_free_blocks_count))
+		return 0;
+
+	group_first_block = ext3_group_first_block_no(sb, group_no);
+	while (allocated < indirect_blks && blk >= mc_start) {
+		if (!ext3_test_allocatable(blk, bitmap_bh)) {
+			blk = bitmap_search_prev_usable_block(blk, bitmap_bh,
+								mc_start);
+			continue;
+		}
+		if (claim_block(sb_bgl_lock(EXT3_SB(sb), group_no), blk,
+				bitmap_bh)) {
+			new_blocks[allocated++] = group_first_block + blk;
+		} else {
+			/*
+			 * The block was allocated by another thread, or it
+			 * was allocated and then freed by another thread
+			 */
+			cpu_relax();
+		}
+		if (allocated < indirect_blks)
+			blk = bitmap_search_prev_usable_block(blk, bitmap_bh,
+								mc_start);
+	}
+	return allocated;
+}
+
+/*
+ * check_allocated_blocks:
+ * 	Helper function for ext3_new_blocks. Checks newly allocated block
+ * 	numbers.
+ */
+int check_allocated_blocks(ext3_fsblk_t blk, unsigned long num,
+				struct super_block *sb, int group_no,
+				struct ext3_group_desc *gdp,
+				struct buffer_head *bitmap_bh)
+{
+	struct ext3_super_block *es = EXT3_SB(sb)->s_es;
+	struct ext3_sb_info *sbi = EXT3_SB(sb);
+	ext3_fsblk_t grp_blk = blk - ext3_group_first_block_no(sb, group_no);
+
+	if (in_range(le32_to_cpu(gdp->bg_block_bitmap), blk, num) ||
+		in_range(le32_to_cpu(gdp->bg_inode_bitmap), blk, num) ||
+		in_range(blk, le32_to_cpu(gdp->bg_inode_table),
+				EXT3_SB(sb)->s_itb_per_group) ||
+		in_range(blk + num - 1, le32_to_cpu(gdp->bg_inode_table),
+				EXT3_SB(sb)->s_itb_per_group))
+		ext3_error(sb, "ext3_new_blocks",
+				"Allocating block in system zone - "
+				"blocks from "E3FSBLK", length %lu",
+				blk, num);
+
+#ifdef CONFIG_JBD_DEBUG
+	{
+		struct buffer_head *debug_bh;
+
+		/* Record bitmap buffer state in the newly allocated block */
+		debug_bh = sb_find_get_block(sb, blk);
+		if (debug_bh) {
+			BUFFER_TRACE(debug_bh, "state when allocated");
+			BUFFER_TRACE2(debug_bh, bitmap_bh, "bitmap state");
+			brelse(debug_bh);
+		}
+	}
+	jbd_lock_bh_state(bitmap_bh);
+	spin_lock(sb_bgl_lock(sbi, group_no));
+	if (buffer_jbd(bitmap_bh) && bh2jh(bitmap_bh)->b_committed_data) {
+		int i;
+
+		for (i = 0; i < num; i++) {
+			if (ext3_test_bit(grp_blk+i,
+					bh2jh(bitmap_bh)->b_committed_data))
+				printk(KERN_ERR "%s: block was unexpectedly set"
+					" in b_committed_data\n", __FUNCTION__);
+		}
+	}
+	ext3_debug("found bit %d\n", grp_blk);
+	spin_unlock(sb_bgl_lock(sbi, group_no));
+	jbd_unlock_bh_state(bitmap_bh);
+#endif
+
+	if (blk + num - 1 >= le32_to_cpu(es->s_blocks_count)) {
+		ext3_error(sb, "ext3_new_blocks",
+				"block("E3FSBLK") >= blocks count(%d) - "
+				"block_group = %d, es == %p ", blk,
+				le32_to_cpu(es->s_blocks_count), group_no, es);
+		return 1;
+	}
+
+	return 0;
+}
+
 /**
- * ext3_new_blocks() -- core block(s) allocation function
- * @handle:		handle to this transaction
- * @inode:		file inode
- * @goal:		given target block(filesystem wide)
- * @count:		target number of blocks to allocate
- * @errp:		error code
+ * ext3_new_blocks - allocate indirect blocks and direct blocks.
+ *	@handle:	handle to this transaction
+ *	@inode:		file inode
+ *	@goal:		given target block(filesystem wide)
+ * 	@indirect_blks	number of indirect blocks to allocate
+ * 	@blks		number of direct blocks to allocate
+ * 	@new_blocks	this will store the block numbers of indirect blocks
+ * 			and direct blocks upon return.
  *
- * ext3_new_blocks uses a goal block to assist allocation.  It tries to
- * allocate block(s) from the block group contains the goal block
first. If that
- * fails, it will try to allocate block(s) from other block groups without
- * any specific goal block.
+ * 	returns the number of direct blocks allocated. Fewer than requested
+ * 	number of direct blocks may be allocated but all requested indirect
+ * 	blocks must be allocated in order to return success.
  *
+ *	Without metaclustering, ext3_new_block allocates all blocks using a
+ *	goal block to assist allocation.  It tries to allocate block(s) from
+ *	the block group contains the goal block first. If that fails, it will
+ *	try to allocate block(s) from other block groups without any specific
+ *	goal block.
+ *
+ *	With metaclustering, the only difference is that indirect block
+ *	allocation is first attempted in the metacluster region of the same
+ *	block group failing which they are allocated along with direct blocks.
+ *
+ *	This function also updates quota and i_blocks field.
  */
-ext3_fsblk_t ext3_new_blocks(handle_t *handle, struct inode *inode,
-			ext3_fsblk_t goal, unsigned long *count, int *errp)
+int ext3_new_blocks(handle_t *handle, struct inode *inode,
+			ext3_fsblk_t goal, int indirect_blks, int blks,
+			ext3_fsblk_t new_blocks[4], int *errp)
+
 {
 	struct buffer_head *bitmap_bh = NULL;
 	struct buffer_head *gdp_bh;
@@ -1452,10 +1737,16 @@ ext3_fsblk_t ext3_new_blocks(handle_t *h
 	ext3_grpblk_t grp_target_blk;	/* blockgroup relative goal block */
 	ext3_grpblk_t grp_alloc_blk;	/* blockgroup-relative allocated block*/
 	ext3_fsblk_t ret_block;		/* filesyetem-wide allocated block */
+	ext3_fsblk_t group_first_block; /* first block in the group */
 	int bgi;			/* blockgroup iteration index */
 	int fatal = 0, err;
 	int performed_allocation = 0;
 	ext3_grpblk_t free_blocks;	/* number of free blocks in a group */
+	unsigned long ngroups;
+	unsigned long grp_mc_alloc;/* blocks allocated from mc in a group */
+	unsigned long grp_alloc;   /* blocks allocated outside mc in a group */
+	int indirect_blks_done = 0;/* total ind blocks allocated so far */
+	int blks_done = 0;	   /* total direct blocks allocated */
 	struct super_block *sb;
 	struct ext3_group_desc *gdp;
 	struct ext3_super_block *es;
@@ -1463,23 +1754,23 @@ ext3_fsblk_t ext3_new_blocks(handle_t *h
 	struct ext3_reserve_window_node *my_rsv = NULL;
 	struct ext3_block_alloc_info *block_i;
 	unsigned short windowsz = 0;
+	int i;
 #ifdef EXT3FS_DEBUG
 	static int goal_hits, goal_attempts;
 #endif
-	unsigned long ngroups;
-	unsigned long num = *count;

 	*errp = -ENOSPC;
 	sb = inode->i_sb;
 	if (!sb) {
-		printk("ext3_new_block: nonexistent device");
+		printk(KERN_INFO "ext3_new_blocks: nonexistent device");
+		*errp = -ENODEV;
 		return 0;
 	}

 	/*
 	 * Check quota for allocation of this block.
 	 */
-	if (DQUOT_ALLOC_BLOCK(inode, num)) {
+	if (DQUOT_ALLOC_BLOCK(inode, indirect_blks + blks)) {
 		*errp = -EDQUOT;
 		return 0;
 	}
@@ -1513,73 +1804,194 @@ ext3_fsblk_t ext3_new_blocks(handle_t *h
 	group_no = (goal - le32_to_cpu(es->s_first_data_block)) /
 			EXT3_BLOCKS_PER_GROUP(sb);
 	goal_group = group_no;
-retry_alloc:
-	gdp = ext3_get_group_desc(sb, group_no, &gdp_bh);
-	if (!gdp)
-		goto io_error;
-
-	free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
-	/*
-	 * if there is not enough free blocks to make a new resevation
-	 * turn off reservation for this allocation
-	 */
-	if (my_rsv && (free_blocks < windowsz)
-		&& (rsv_is_empty(&my_rsv->rsv_window)))
-		my_rsv = NULL;
-
-	if (free_blocks > 0) {
-		grp_target_blk = ((goal - le32_to_cpu(es->s_first_data_block)) %
-				EXT3_BLOCKS_PER_GROUP(sb));
-		bitmap_bh = read_block_bitmap(sb, group_no);
-		if (!bitmap_bh)
-			goto io_error;
-		grp_alloc_blk = ext3_try_to_allocate_with_rsv(sb, handle,
-					group_no, bitmap_bh, grp_target_blk,
-					my_rsv,	&num, &fatal);
-		if (fatal)
-			goto out;
-		if (grp_alloc_blk >= 0)
-			goto allocated;
-	}

+retry_alloc:
+	grp_target_blk = ((goal - le32_to_cpu(es->s_first_data_block)) %
+			EXT3_BLOCKS_PER_GROUP(sb));
 	ngroups = EXT3_SB(sb)->s_groups_count;
 	smp_rmb();

 	/*
-	 * Now search the rest of the groups.  We assume that
-	 * i and gdp correctly point to the last group visited.
+	 * Iterate over successive block groups for allocating (any) indirect
+	 * blocks and direct blocks until at least one direct block has been
+	 * allocated. If metaclustering is enabled, we try allocating indirect
+	 * blocks first in the metacluster region and then in the general
+	 * region and if that fails too, we repeat the same algorithm in the
+	 * next block group and so on. This not only keeps the indirect blocks
+	 * together in the metacluster, but also keeps them in close proximity
+	 * to their corresponding direct blocks.
+	 *
+	 * The search begins and ends at the goal group, though the second time
+	 * we are at the goal group we try allocating without a goal.
 	 */
-	for (bgi = 0; bgi < ngroups; bgi++) {
-		group_no++;
+	bgi = 0;
+	while (bgi < ngroups + 1) {
+		grp_mc_alloc = 0;
+
 		if (group_no >= ngroups)
 			group_no = 0;
+
 		gdp = ext3_get_group_desc(sb, group_no, &gdp_bh);
 		if (!gdp)
 			goto io_error;
+
 		free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
-		/*
-		 * skip this group if the number of
-		 * free blocks is less than half of the reservation
-		 * window size.
-		 */
-		if (free_blocks <= (windowsz/2))
-			continue;
+		if (group_no == goal_group) {
+			if (my_rsv && (free_blocks < windowsz)
+				&& (rsv_is_empty(&my_rsv->rsv_window)))
+				my_rsv = NULL;
+			if (free_blocks <= 0)
+				goto next;
+		} else if (free_blocks <= windowsz/2)
+			goto next;

-		brelse(bitmap_bh);
 		bitmap_bh = read_block_bitmap(sb, group_no);
 		if (!bitmap_bh)
 			goto io_error;
+
 		/*
-		 * try to allocate block(s) from this group, without a goal(-1).
+		 * Make sure we use undo access for the bitmap, because it is
+		 * critical that we do the frozen_data COW on bitmap buffers in
+		 * all cases even if the buffer is in BJ_Forget state in the
+		 * committing transaction.
+		 */
+		BUFFER_TRACE(bitmap_bh, "get undo access for new block");
+		fatal = ext3_journal_get_undo_access(handle, bitmap_bh);
+		if (fatal)
+			goto out;
+
+		/*
+		 * If metaclustering is enabled, first try to allocate indirect
+		 * blocks in the metacluster.
 		 */
+		if (test_opt(sb, METACLUSTER) &&
+			indirect_blks_done < indirect_blks)
+			grp_mc_alloc = ext3_alloc_indirect_blocks(sb,
+					bitmap_bh, gdp, group_no,
+					indirect_blks - indirect_blks_done,
+					new_blocks + indirect_blks_done);
+
+		/* Allocate data blocks and any leftover indirect blocks. */
+		grp_alloc = indirect_blks + blks
+				- (indirect_blks_done + grp_mc_alloc);
 		grp_alloc_blk = ext3_try_to_allocate_with_rsv(sb, handle,
-					group_no, bitmap_bh, -1, my_rsv,
-					&num, &fatal);
+					group_no, bitmap_bh, grp_target_blk,
+					my_rsv, &grp_alloc);
+		if (grp_alloc_blk < 0)
+			grp_alloc = 0;
+
+		/*
+		 * If we couldn't allocate anything, there is nothing more to
+		 * do with this block group, so move over to the next. But
+		 * before that We must release write access to the old one via
+		 * ext3_journal_release_buffer(), else we'll run out of credits.
+		 */
+		if (grp_mc_alloc == 0 && grp_alloc == 0) {
+			BUFFER_TRACE(bitmap_bh, "journal_release_buffer");
+			ext3_journal_release_buffer(handle, bitmap_bh);
+			goto next;
+		}
+
+		BUFFER_TRACE(bitmap_bh, "journal_dirty_metadata for "
+					"bitmap block");
+		fatal = ext3_journal_dirty_metadata(handle, bitmap_bh);
 		if (fatal)
 			goto out;
-		if (grp_alloc_blk >= 0)
+
+		ext3_debug("using block group %d(%d)\n",
+				group_no, gdp->bg_free_blocks_count);
+
+		BUFFER_TRACE(gdp_bh, "get_write_access");
+		fatal = ext3_journal_get_write_access(handle, gdp_bh);
+		if (fatal)
+			goto out;
+
+		/* Should this be called before ext3_journal_dirty_metadata? */
+		for (i = 0; i < grp_mc_alloc; i++) {
+			if (check_allocated_blocks(
+				new_blocks[indirect_blks_done + i], 1, sb,
+				group_no, gdp, bitmap_bh))
+				goto out;
+		}
+		if (grp_alloc > 0) {
+			ret_block = ext3_group_first_block_no(sb, group_no) +
+				grp_alloc_blk;
+			if (check_allocated_blocks(ret_block, grp_alloc, sb,
+						group_no, gdp, bitmap_bh))
+				goto out;
+		}
+
+		indirect_blks_done += grp_mc_alloc;
+		performed_allocation = 1;
+
+		/* The caller will add the new buffer to the journal. */
+		if (grp_alloc > 0)
+			ext3_debug("allocating block %lu. "
+					"Goal hits %d of %d.\n",
+					ret_block, goal_hits, goal_attempts);
+
+		spin_lock(sb_bgl_lock(sbi, group_no));
+		gdp->bg_free_blocks_count =
+			cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count) -
+					(grp_mc_alloc + grp_alloc));
+		spin_unlock(sb_bgl_lock(sbi, group_no));
+		percpu_counter_sub(&sbi->s_freeblocks_counter,
+				(grp_mc_alloc + grp_alloc));
+
+		BUFFER_TRACE(gdp_bh, "journal_dirty_metadata for "
+				"group descriptor");
+		err = ext3_journal_dirty_metadata(handle, gdp_bh);
+		if (!fatal)
+			fatal = err;
+
+		sb->s_dirt = 1;
+		if (fatal)
+			goto out;
+
+		brelse(bitmap_bh);
+		bitmap_bh = NULL;
+
+		if (grp_alloc == 0)
+			goto next;
+
+		/* Update block group non-mc block count since we used some. */
+		if (test_opt(sb, METACLUSTER) &&
+			grp_alloc_blk < sbi->s_nonmc_blocks_per_group)
+			ext3_update_nonmc_block_count(sbi, group_no,
+				grp_alloc_blk, grp_alloc, 1);
+
+		/*
+		 * Assign all the non-mc blocks that we allocated from this
+		 * block group.
+		 */
+		group_first_block = ext3_group_first_block_no(sb, group_no);
+		while (grp_alloc > 0 && indirect_blks_done < indirect_blks) {
+			new_blocks[indirect_blks_done++] =
+				group_first_block + grp_alloc_blk;
+			grp_alloc_blk++;
+			grp_alloc--;
+		}
+
+		if (grp_alloc > 0) {
+			blks_done = grp_alloc;
+			new_blocks[indirect_blks_done] =
+				group_first_block + grp_alloc_blk;
 			goto allocated;
+		}
+
+		/*
+		 * If we allocated something but not the minimum required,
+		 * it's OK to retry in this group as it might have more free
+		 * blocks.
+		 */
+		continue;
+
+next:
+		bgi++;
+		group_no++;
+		grp_target_blk = -1;
 	}
+
 	/*
 	 * We may end up a bogus ealier ENOSPC error due to
 	 * filesystem is "full" of reservations, but
@@ -1598,96 +2010,11 @@ retry_alloc:
 	goto out;

 allocated:
-
-	ext3_debug("using block group %d(%d)\n",
-			group_no, gdp->bg_free_blocks_count);
-
-	BUFFER_TRACE(gdp_bh, "get_write_access");
-	fatal = ext3_journal_get_write_access(handle, gdp_bh);
-	if (fatal)
-		goto out;
-
-	ret_block = grp_alloc_blk + ext3_group_first_block_no(sb, group_no);
-
-	if (in_range(le32_to_cpu(gdp->bg_block_bitmap), ret_block, num) ||
-	    in_range(le32_to_cpu(gdp->bg_inode_bitmap), ret_block, num) ||
-	    in_range(ret_block, le32_to_cpu(gdp->bg_inode_table),
-		      EXT3_SB(sb)->s_itb_per_group) ||
-	    in_range(ret_block + num - 1, le32_to_cpu(gdp->bg_inode_table),
-		      EXT3_SB(sb)->s_itb_per_group))
-		ext3_error(sb, "ext3_new_block",
-			    "Allocating block in system zone - "
-			    "blocks from "E3FSBLK", length %lu",
-			     ret_block, num);
-
-	performed_allocation = 1;
-
-#ifdef CONFIG_JBD_DEBUG
-	{
-		struct buffer_head *debug_bh;
-
-		/* Record bitmap buffer state in the newly allocated block */
-		debug_bh = sb_find_get_block(sb, ret_block);
-		if (debug_bh) {
-			BUFFER_TRACE(debug_bh, "state when allocated");
-			BUFFER_TRACE2(debug_bh, bitmap_bh, "bitmap state");
-			brelse(debug_bh);
-		}
-	}
-	jbd_lock_bh_state(bitmap_bh);
-	spin_lock(sb_bgl_lock(sbi, group_no));
-	if (buffer_jbd(bitmap_bh) && bh2jh(bitmap_bh)->b_committed_data) {
-		int i;
-
-		for (i = 0; i < num; i++) {
-			if (ext3_test_bit(grp_alloc_blk+i,
-					bh2jh(bitmap_bh)->b_committed_data)) {
-				printk("%s: block was unexpectedly set in "
-					"b_committed_data\n", __FUNCTION__);
-			}
-		}
-	}
-	ext3_debug("found bit %d\n", grp_alloc_blk);
-	spin_unlock(sb_bgl_lock(sbi, group_no));
-	jbd_unlock_bh_state(bitmap_bh);
-#endif
-
-	if (ret_block + num - 1 >= le32_to_cpu(es->s_blocks_count)) {
-		ext3_error(sb, "ext3_new_block",
-			    "block("E3FSBLK") >= blocks count(%d) - "
-			    "block_group = %d, es == %p ", ret_block,
-			le32_to_cpu(es->s_blocks_count), group_no, es);
-		goto out;
-	}
-
-	/*
-	 * It is up to the caller to add the new buffer to a journal
-	 * list of some description.  We don't know in advance whether
-	 * the caller wants to use it as metadata or data.
-	 */
-	ext3_debug("allocating block %lu. Goal hits %d of %d.\n",
-			ret_block, goal_hits, goal_attempts);
-
-	spin_lock(sb_bgl_lock(sbi, group_no));
-	gdp->bg_free_blocks_count =
-			cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count)-num);
-	spin_unlock(sb_bgl_lock(sbi, group_no));
-	percpu_counter_sub(&sbi->s_freeblocks_counter, num);
-
-	BUFFER_TRACE(gdp_bh, "journal_dirty_metadata for group descriptor");
-	err = ext3_journal_dirty_metadata(handle, gdp_bh);
-	if (!fatal)
-		fatal = err;
-
-	sb->s_dirt = 1;
-	if (fatal)
-		goto out;
-
 	*errp = 0;
-	brelse(bitmap_bh);
-	DQUOT_FREE_BLOCK(inode, *count-num);
-	*count = num;
-	return ret_block;
+	DQUOT_FREE_BLOCK(inode,
+			indirect_blks + blks - indirect_blks_done - blks_done);
+
+	return blks_done;

 io_error:
 	*errp = -EIO;
@@ -1700,7 +2027,13 @@ out:
 	 * Undo the block allocation
 	 */
 	if (!performed_allocation)
-		DQUOT_FREE_BLOCK(inode, *count);
+		DQUOT_FREE_BLOCK(inode, indirect_blks + blks);
+	/*
+	 * Free any indirect blocks we allocated already. If the transaction
+	 * has been aborted this is essentially a no-op.
+	 */
+	for (i = 0; i < indirect_blks_done; i++)
+		ext3_free_blocks(handle, inode, new_blocks[i], 1);
 	brelse(bitmap_bh);
 	return 0;
 }
@@ -1708,9 +2041,13 @@ out:
 ext3_fsblk_t ext3_new_block(handle_t *handle, struct inode *inode,
 			ext3_fsblk_t goal, int *errp)
 {
-	unsigned long count = 1;
+	ext3_fsblk_t new_blocks[4];

-	return ext3_new_blocks(handle, inode, goal, &count, errp);
+	ext3_new_blocks(handle, inode, goal, 0, 1, new_blocks, errp);
+	if (*errp)
+		return 0;
+
+	return new_blocks[0];
 }

 /**
diff -uprdN linux-2.6.23mm1-clean/fs/ext3/bitmap.c
linux-2.6.23mm1-ext3mc/fs/ext3/bitmap.c
--- linux-2.6.23mm1-clean/fs/ext3/bitmap.c	2007-10-17 18:31:42.000000000 -0700
+++ linux-2.6.23mm1-ext3mc/fs/ext3/bitmap.c	2007-12-20 18:12:17.000000000 -0800
@@ -11,8 +11,6 @@
 #include <linux/jbd.h>
 #include <linux/ext3_fs.h>

-#ifdef EXT3FS_DEBUG
-
 static const int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1,
2, 1, 1, 0};

 unsigned long ext3_count_free (struct buffer_head * map, unsigned int numchars)
@@ -27,6 +25,3 @@ unsigned long ext3_count_free (struct bu
 			nibblemap[(map->b_data[i] >> 4) & 0xf];
 	return (sum);
 }
-
-#endif  /*  EXT3FS_DEBUG  */
-
diff -uprdN linux-2.6.23mm1-clean/fs/ext3/inode.c
linux-2.6.23mm1-ext3mc/fs/ext3/inode.c
--- linux-2.6.23mm1-clean/fs/ext3/inode.c	2007-10-17 18:31:42.000000000 -0700
+++ linux-2.6.23mm1-ext3mc/fs/ext3/inode.c	2007-12-21 05:38:41.000000000 -0800
@@ -36,10 +36,33 @@
 #include <linux/mpage.h>
 #include <linux/uio.h>
 #include <linux/bio.h>
+#include <linux/sort.h>
 #include "xattr.h"
 #include "acl.h"

+typedef struct {
+	__le32	*p;
+	__le32	key;
+	struct buffer_head *bh;
+} Indirect;
+
+struct ext3_ind_read_info {
+	int                     count;
+	int                     seq_prefetch;
+	long                    size;
+	struct buffer_head      *bh[0];
+};
+
+# define EXT3_IND_READ_INFO_SIZE(_c)        \
+	(sizeof(struct ext3_ind_read_info) + \
+	 sizeof(struct buffer_head *) * (_c))
+
+# define EXT3_IND_READ_MAX     	(32)
+
 static int ext3_writepage_trans_blocks(struct inode *inode);
+static Indirect *ext3_read_indblocks(struct inode *inode, int iblock,
+				     int depth, int offsets[4],
+				     Indirect chain[4], int *err);

 /*
  * Test whether an inode is a fast symlink.
@@ -233,12 +256,6 @@ no_delete:
 	clear_inode(inode);	/* We must guarantee clearing of inode... */
 }

-typedef struct {
-	__le32	*p;
-	__le32	key;
-	struct buffer_head *bh;
-} Indirect;
-
 static inline void add_chain(Indirect *p, struct buffer_head *bh, __le32 *v)
 {
 	p->key = *(p->p = v);
@@ -352,18 +369,21 @@ static int ext3_block_to_path(struct ino
  *	the whole chain, all way to the data (returns %NULL, *err == 0).
  */
 static Indirect *ext3_get_branch(struct inode *inode, int depth, int *offsets,
-				 Indirect chain[4], int *err)
+				 Indirect chain[4], int ind_readahead, int *err)
 {
 	struct super_block *sb = inode->i_sb;
 	Indirect *p = chain;
 	struct buffer_head *bh;
+	int index;

 	*err = 0;
 	/* i_data is not going away, no lock needed */
 	add_chain (chain, NULL, EXT3_I(inode)->i_data + *offsets);
 	if (!p->key)
 		goto no_block;
-	while (--depth) {
+	for (index = 0; index < depth - 1; index++) {
+		if (ind_readahead && depth > 2 && index == depth - 2)
+			break;
 		bh = sb_bread(sb, le32_to_cpu(p->key));
 		if (!bh)
 			goto failure;
@@ -396,7 +416,11 @@ no_block:
  *	It is used when heuristic for sequential allocation fails.
  *	Rules are:
  *	  + if there is a block to the left of our position - allocate near it.
- *	  + if pointer will live in indirect block - allocate near that block.
+ *	  + If METACLUSTER options is not specified, allocate the data
+ *	  block close to the metadata block. Otherwise, if pointer will live in
+ *	  indirect block, we cannot allocate near the indirect block since
+ *	  indirect blocks are allocated in the metacluster, just put in the same
+ *	  cylinder group as the inode.
  *	  + if pointer will live in inode - allocate in the same
  *	    cylinder group.
  *
@@ -421,9 +445,11 @@ static ext3_fsblk_t ext3_find_near(struc
 			return le32_to_cpu(*p);
 	}

-	/* No such thing, so let's try location of indirect block */
-	if (ind->bh)
-		return ind->bh->b_blocknr;
+	if (!test_opt(inode->i_sb, METACLUSTER)) {
+		/* No such thing, so let's try location of indirect block */
+		if (ind->bh)
+			return ind->bh->b_blocknr;
+	}

 	/*
 	 * It is going to be referred to from the inode itself? OK, just put it
@@ -475,8 +501,7 @@ static ext3_fsblk_t ext3_find_goal(struc
  *	@blks: number of data blocks to be mapped.
  *	@blocks_to_boundary:  the offset in the indirect block
  *
- *	return the total number of blocks to be allocate, including the
- *	direct and indirect blocks.
+ *	return the total number of direct blocks to be allocated.
  */
 static int ext3_blks_to_allocate(Indirect *branch, int k, unsigned long blks,
 		int blocks_to_boundary)
@@ -505,75 +530,18 @@ static int ext3_blks_to_allocate(Indirec
 }

 /**
- *	ext3_alloc_blocks: multiple allocate blocks needed for a branch
- *	@indirect_blks: the number of blocks need to allocate for indirect
- *			blocks
- *
- *	@new_blocks: on return it will store the new block numbers for
- *	the indirect blocks(if needed) and the first direct block,
- *	@blks:	on return it will store the total number of allocated
- *		direct blocks
- */
-static int ext3_alloc_blocks(handle_t *handle, struct inode *inode,
-			ext3_fsblk_t goal, int indirect_blks, int blks,
-			ext3_fsblk_t new_blocks[4], int *err)
-{
-	int target, i;
-	unsigned long count = 0;
-	int index = 0;
-	ext3_fsblk_t current_block = 0;
-	int ret = 0;
-
-	/*
-	 * Here we try to allocate the requested multiple blocks at once,
-	 * on a best-effort basis.
-	 * To build a branch, we should allocate blocks for
-	 * the indirect blocks(if not allocated yet), and at least
-	 * the first direct block of this branch.  That's the
-	 * minimum number of blocks need to allocate(required)
-	 */
-	target = blks + indirect_blks;
-
-	while (1) {
-		count = target;
-		/* allocating blocks for indirect blocks and direct blocks */
-		current_block = ext3_new_blocks(handle,inode,goal,&count,err);
-		if (*err)
-			goto failed_out;
-
-		target -= count;
-		/* allocate blocks for indirect blocks */
-		while (index < indirect_blks && count) {
-			new_blocks[index++] = current_block++;
-			count--;
-		}
-
-		if (count > 0)
-			break;
-	}
-
-	/* save the new block number for the first direct block */
-	new_blocks[index] = current_block;
-
-	/* total number of blocks allocated for direct blocks */
-	ret = count;
-	*err = 0;
-	return ret;
-failed_out:
-	for (i = 0; i <index; i++)
-		ext3_free_blocks(handle, inode, new_blocks[i], 1);
-	return ret;
-}
-
-/**
  *	ext3_alloc_branch - allocate and set up a chain of blocks.
  *	@inode: owner
  *	@indirect_blks: number of allocated indirect blocks
  *	@blks: number of allocated direct blocks
+ *	@goal: goal for allocation
  *	@offsets: offsets (in the blocks) to store the pointers to next.
  *	@branch: place to store the chain in.
  *
- *	This function allocates blocks, zeroes out all but the last one,
+ *	returns error and number of direct blocks allocated via *blks
+ *
+ *	This function allocates indirect_blks + *blks, zeroes out all
+ *	indirect blocks,
  *	links them into chain and (if we are synchronous) writes them to disk.
  *	In other words, it prepares a branch that can be spliced onto the
  *	inode. It stores the information about that chain in the branch[], in
@@ -602,7 +570,7 @@ static int ext3_alloc_branch(handle_t *h
 	ext3_fsblk_t new_blocks[4];
 	ext3_fsblk_t current_block;

-	num = ext3_alloc_blocks(handle, inode, goal, indirect_blks,
+	num = ext3_new_blocks(handle, inode, goal, indirect_blks,
 				*blks, new_blocks, &err);
 	if (err)
 		return err;
@@ -799,17 +767,21 @@ int ext3_get_blocks_handle(handle_t *han
 	int blocks_to_boundary = 0;
 	int depth;
 	struct ext3_inode_info *ei = EXT3_I(inode);
-	int count = 0;
+	int count = 0, ind_readahead;
 	ext3_fsblk_t first_block = 0;

-
 	J_ASSERT(handle != NULL || create == 0);
 	depth = ext3_block_to_path(inode,iblock,offsets,&blocks_to_boundary);

 	if (depth == 0)
 		goto out;

-	partial = ext3_get_branch(inode, depth, offsets, chain, &err);
+	ind_readahead = !create && depth > 2;
+	partial = ext3_get_branch(inode, depth, offsets, chain,
+				  ind_readahead, &err);
+	if (!partial && ind_readahead)
+		partial = ext3_read_indblocks(inode, iblock, depth,
+					      offsets, chain, &err);

 	/* Simplest case - block found, no allocation needed */
 	if (!partial) {
@@ -844,7 +816,7 @@ int ext3_get_blocks_handle(handle_t *han
 	}

 	/* Next simple case - plain lookup or failed read of indirect block */
-	if (!create || err == -EIO)
+	if (!create || (err && err != -EAGAIN))
 		goto cleanup;

 	mutex_lock(&ei->truncate_mutex);
@@ -866,7 +838,8 @@ int ext3_get_blocks_handle(handle_t *han
 			brelse(partial->bh);
 			partial--;
 		}
-		partial = ext3_get_branch(inode, depth, offsets, chain, &err);
+		partial = ext3_get_branch(inode, depth, offsets, chain, 0,
+					&err);
 		if (!partial) {
 			count++;
 			mutex_unlock(&ei->truncate_mutex);
@@ -1974,7 +1947,7 @@ static Indirect *ext3_find_shared(struct
 	/* Make k index the deepest non-null offest + 1 */
 	for (k = depth; k > 1 && !offsets[k-1]; k--)
 		;
-	partial = ext3_get_branch(inode, k, offsets, chain, &err);
+	partial = ext3_get_branch(inode, k, offsets, chain, 0, &err);
 	/* Writer: pointers */
 	if (!partial)
 		partial = chain + k-1;
@@ -3297,3 +3270,560 @@ int ext3_change_inode_journal_flag(struc

 	return err;
 }
+
+/*
+ * ext3_ind_read_end_bio --
+ *
+ * 	bio callback for read IO issued from ext3_read_indblocks.
+ * 	May be called multiple times until the whole I/O completes at
+ * 	which point bio->bi_size = 0 and it frees read_info and bio.
+ * 	The first time it is called, first_bh is unlocked so that any sync
+ * 	waier can unblock.
+ */
+static void ext3_ind_read_end_bio(struct bio *bio, int err)
+{
+	struct ext3_ind_read_info *read_info = bio->bi_private;
+	struct buffer_head *bh;
+	int uptodate = !err && test_bit(BIO_UPTODATE, &bio->bi_flags);
+	int i;
+
+	if (err == -EOPNOTSUPP)
+		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
+
+	/* Wait for all buffers to finish - is this needed? */
+	if (bio->bi_size)
+		return;
+
+	for (i = 0; i < read_info->count; i++) {
+		bh = read_info->bh[i];
+		if (err == -EOPNOTSUPP)
+			set_bit(BH_Eopnotsupp, &bh->b_state);
+
+		if (uptodate) {
+			BUG_ON(buffer_uptodate(bh));
+			BUG_ON(ext3_buffer_prefetch(bh));
+			set_buffer_uptodate(bh);
+			if (read_info->seq_prefetch)
+				ext3_set_buffer_prefetch(bh);
+		}
+
+		unlock_buffer(bh);
+		brelse(bh);
+	}
+
+	kfree(read_info);
+	bio_put(bio);
+}
+
+/*
+ * ext3_get_max_read --
+ * 	@inode: inode of file.
+ * 	@block: block number in file (starting from zero).
+ * 	@offset_in_dind_block: offset of the indirect block inside it's
+ * 	parent doubly-indirect block.
+ *
+ *      Compute the maximum no. of indirect blocks that can be read
+ *      satisfying following constraints:
+ *              - Don't read indirect blocks beyond the end of current
+ *              doubly-indirect block.
+ *              - Don't read beyond eof.
+ */
+static inline unsigned long ext3_get_max_read(const struct inode *inode,
+						  int block,
+						  int offset_in_dind_block)
+{
+	const struct super_block *sb = inode->i_sb;
+	unsigned long max_read;
+	unsigned long ptrs = EXT3_ADDR_PER_BLOCK(inode->i_sb);
+	unsigned long ptrs_bits = EXT3_ADDR_PER_BLOCK_BITS(inode->i_sb);
+	unsigned long blocks_in_file =
+		(inode->i_size + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
+	unsigned long remaining_ind_blks_in_dind =
+		(ptrs >= offset_in_dind_block) ? (ptrs - offset_in_dind_block)
+					       : 0;
+	unsigned long remaining_ind_blks_before_eof =
+		((blocks_in_file - EXT3_NDIR_BLOCKS + ptrs - 1) >> ptrs_bits) -
+		((block - EXT3_NDIR_BLOCKS) >> ptrs_bits);
+
+	BUG_ON(block >= blocks_in_file);
+
+	max_read = min_t(unsigned long, remaining_ind_blks_in_dind,
+			 remaining_ind_blks_before_eof);
+
+	BUG_ON(max_read < 1);
+
+	return max_read;
+}
+
+static void ext3_read_indblocks_submit(struct bio **pbio,
+					struct ext3_ind_read_info **pread_info,
+					int *read_cnt, int seq_prefetch)
+{
+	struct bio *bio = *pbio;
+	struct ext3_ind_read_info *read_info = *pread_info;
+
+	BUG_ON(*read_cnt < 1);
+
+	read_info->seq_prefetch = seq_prefetch;
+	read_info->count = *read_cnt;
+	read_info->size = bio->bi_size;
+	bio->bi_private = read_info;
+	bio->bi_end_io = ext3_ind_read_end_bio;
+	submit_bio(READ, bio);
+
+	*pbio = NULL;
+	*pread_info = NULL;
+	*read_cnt = 0;
+}
+
+struct ind_block_info {
+	ext3_fsblk_t		blockno;
+	struct buffer_head	*bh;
+};
+
+static int ind_info_cmp(const void *a, const void *b)
+{
+	struct ind_block_info *info_a = (struct ind_block_info *)a;
+	struct ind_block_info *info_b = (struct ind_block_info *)b;
+
+	return info_a->blockno - info_b->blockno;
+}
+
+static void ind_info_swap(void *a, void *b, int size)
+{
+	struct ind_block_info *info_a = (struct ind_block_info *)a;
+	struct ind_block_info *info_b = (struct ind_block_info *)b;
+	struct ind_block_info tmp;
+
+	tmp = *info_a;
+	*info_a = *info_b;
+	*info_b = tmp;
+}
+
+/*
+ * ext3_read_indblocks_async --
+ *      @sb:            super block
+ *      @ind_blocks[]:  array of indirect block numbers on disk
+ *      @count:         maximum number of indirect blocks to read
+ *      @first_bh:      buffer_head for indirect block ind_blocks[0], may be
+ *                      NULL
+ *      @seq_prefetch:  if this is part of a sequential prefetch and buffers'
+ *                      prefetch bit must be set.
+ *      @blocks_done:   number of blocks considered for prefetching.
+ *
+ *      Issue a single bio request to read upto count buffers identified in
+ *      ind_blocks[]. Fewer than count buffers may be read in some cases:
+ *      - If a buffer is found to be uptodate and it's prefetch bit is set, we
+ *      don't look at any more buffers as they will most likely be in
the cache.
+ *      - We skip buffers we cannot lock without blocking (except for first_bh
+ *      if specified).
+ *      - We skip buffers beyond a certain range on disk.
+ *
+ *      This function must issue read on first_bh if specified unless of course
+ *      it's already uptodate.
+ */
+static int ext3_read_indblocks_async(struct super_block *sb,
+				     const __le32 ind_blocks[], int count,
+				     struct buffer_head *first_bh,
+				     int seq_prefetch,
+				     unsigned long *blocks_done)
+{
+	struct buffer_head *bh;
+	struct bio *bio = NULL;
+	struct ext3_ind_read_info *read_info = NULL;
+	int read_cnt = 0, blk;
+	ext3_fsblk_t prev_blk = 0, io_start_blk = 0, curr;
+	struct ind_block_info *ind_info = NULL;
+	int err = 0, ind_info_count = 0;
+
+	BUG_ON(count < 1);
+	/* Don't move this to ext3_get_max_read() since callers often need to
+	 * trim the count returned by that function. So this bound must only
+	 * be imposed at the last moment. */
+	count = min_t(unsigned long, count, EXT3_IND_READ_MAX);
+	*blocks_done = 0UL;
+
+	if (count == 1 && first_bh) {
+		lock_buffer(first_bh);
+		get_bh(first_bh);
+		first_bh->b_end_io = end_buffer_read_sync;
+		submit_bh(READ, first_bh);
+		*blocks_done = 1UL;
+		return 0;
+	}
+
+	ind_info = kmalloc(count * sizeof(*ind_info), GFP_KERNEL);
+	if (unlikely(!ind_info))
+		return -ENOMEM;
+
+	/*
+	 * First pass: sort block numbers for all indirect blocks that we'll
+	 * read. This allows us to scan blocks in sequenial order during the
+	 * second pass which helps coalasce requests to contiguous blocks.
+	 * Since we sort block numbers here instead of assuming any specific
+	 * layout on the disk, we have some protection against different
+	 * indirect block layout strategies as long as they keep all indirect
+	 * blocks close by.
+	 */
+	for (blk = 0; blk < count; blk++) {
+		curr = le32_to_cpu(ind_blocks[blk]);
+		if (!curr)
+			continue;
+
+		/*
+		 * Skip this block if it lies too far from blocks we have
+		 * already decided to read. "Too far" should typically indicate
+		 * lying on a different track on the disk. EXT3_IND_READ_MAX
+		 * seems reasonable for most disks.
+		 */
+		if (io_start_blk > 0 &&
+			(max(io_start_blk, curr) - min(io_start_blk, curr) >=
+				EXT3_IND_READ_MAX))
+			continue;
+
+		if (blk == 0 && first_bh) {
+			bh = first_bh;
+			get_bh(first_bh);
+		} else {
+			bh = sb_getblk(sb, curr);
+			if (unlikely(!bh)) {
+				err = -ENOMEM;
+				goto failure;
+			}
+		}
+
+		if (buffer_uptodate(bh)) {
+			if (ext3_buffer_prefetch(bh)) {
+				brelse(bh);
+				break;
+			}
+			brelse(bh);
+			continue;
+		}
+
+		if (io_start_blk == 0)
+			io_start_blk = curr;
+
+		ind_info[ind_info_count].blockno = curr;
+		ind_info[ind_info_count].bh = bh;
+		ind_info_count++;
+	}
+	*blocks_done = blk;
+
+	sort(ind_info, ind_info_count, sizeof(*ind_info),
+		ind_info_cmp, ind_info_swap);
+
+	/* Second pass: compose bio requests and issue them. */
+	for (blk = 0; blk < ind_info_count; blk++) {
+		bh = ind_info[blk].bh;
+		curr = ind_info[blk].blockno;
+
+		if (prev_blk > 0 && curr != prev_blk + 1) {
+			ext3_read_indblocks_submit(&bio, &read_info,
+						&read_cnt, seq_prefetch);
+			prev_blk = 0;
+		}
+
+		/* Lock the buffer without blocking, skipping any buffers
+		 * which would require us to block. first_bh when specified is
+		 * an exception as caller typically wants it to be read for
+		 * sure (e.g., ext3_read_indblocks_sync).
+		 */
+		if (bh == first_bh) {
+			lock_buffer(bh);
+		} else if (test_set_buffer_locked(bh)) {
+			brelse(bh);
+			continue;
+		}
+
+		/* Check again with the buffer locked. */
+		if (buffer_uptodate(bh)) {
+			if (ext3_buffer_prefetch(bh)) {
+				unlock_buffer(bh);
+				brelse(bh);
+				break;
+			}
+			unlock_buffer(bh);
+			brelse(bh);
+			continue;
+		}
+
+		if (read_cnt == 0) {
+			/* read_info freed in ext3_ind_read_end_bio(). */
+			read_info = kmalloc(EXT3_IND_READ_INFO_SIZE(count),
+					    GFP_KERNEL);
+			if (unlikely(!read_info)) {
+				err = -ENOMEM;
+				goto failure;
+			}
+
+			bio = bio_alloc(GFP_KERNEL, count);
+			if (unlikely(!bio)) {
+				err = -ENOMEM;
+				goto failure;
+			}
+			bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
+			bio->bi_bdev = bh->b_bdev;
+		}
+
+		if (bio_add_page(bio, bh->b_page, bh->b_size, bh_offset(bh))
+				< bh->b_size) {
+			brelse(bh);
+			if (read_cnt == 0)
+				goto failure;
+
+			break;
+		}
+
+		read_info->bh[read_cnt++] = bh;
+		prev_blk = curr;
+	}
+
+	if (read_cnt == 0)
+		goto done;
+
+	ext3_read_indblocks_submit(&bio, &read_info, &read_cnt, seq_prefetch);
+
+	kfree(ind_info);
+	return 0;
+
+failure:
+	while (--read_cnt >= 0) {
+		unlock_buffer(read_info->bh[read_cnt]);
+		brelse(read_info->bh[read_cnt]);
+	}
+	*blocks_done = 0UL;
+
+done:
+	kfree(read_info);
+
+	if (bio)
+		bio_put(bio);
+
+	kfree(ind_info);
+	return err;
+}
+
+/*
+ * ext3_read_indblocks_sync --
+ *      @sb:            super block
+ *      @ind_blocks[]:  array of indirect block numbers on disk
+ *      @count:         maximum number of indirect blocks to read
+ *      @first_bh:      buffer_head for indirect block ind_blocks[0], must be
+ *                      non-NULL.
+ *      @seq_prefetch:  set prefetch bit of buffers, used when this is part of
+ *                      a sequential prefetch.
+ *      @blocks_done:   number of blocks considered for prefetching.
+ *
+ *      Synchronously read at most count indirect blocks listed in
+ *      ind_blocks[]. This function calls ext3_read_indblocks_async() to do all
+ *      the hard work. It waits for read to complete on first_bh before
+ *      returning.
+ */
+
+static int ext3_read_indblocks_sync(struct super_block *sb,
+				    const __le32 ind_blocks[], int count,
+				    struct buffer_head *first_bh,
+				    int seq_prefetch,
+				    unsigned long *blocks_done)
+{
+	int err;
+
+	BUG_ON(count < 1);
+	BUG_ON(!first_bh);
+
+	err = ext3_read_indblocks_async(sb, ind_blocks, count, first_bh,
+					seq_prefetch, blocks_done);
+	if (err)
+		return err;
+
+	wait_on_buffer(first_bh);
+	if (!buffer_uptodate(first_bh))
+		err = -EIO;
+
+	/* if seq_prefetch != 0, ext3_read_indblocks_async() sets prefetch bit
+	 * for all buffers, but the first buffer for sync IO is never a prefetch
+	 * buffer since it's needed presently so mark it so.
+	 */
+	if (seq_prefetch)
+		ext3_clear_buffer_prefetch(first_bh);
+
+	BUG_ON(ext3_buffer_prefetch(first_bh));
+
+	return err;
+}
+
+/*
+ * ext3_read_indblocks --
+ *
+ * 	@inode: inode of file
+ * 	@iblock: block number inside file (starting from 0).
+ * 	@depth: depth of path from inode to data block.
+ * 	@offsets: array of offsets within blocks identified in 'chain'.
+ * 	@chain: array of Indirect with info about all levels of blocks until
+ * 	the data block.
+ * 	@err: error pointer.
+ *
+ * 	This function is called after reading all metablocks leading to 'iblock'
+ * 	except the (singly) indirect block. It reads the indirect block if not
+ * 	already in the cache and may also prefetch next few indirect blocks.
+ * 	It uses a combination of synchronous and asynchronous requests to
+ * 	accomplish this. We do prefetching even for random reads by reading
+ * 	ahead one indirect block since reads of size >=512KB have at least 12%
+ * 	chance of spanning two indirect blocks.
+ */
+
+static Indirect *ext3_read_indblocks(struct inode *inode, int iblock,
+				     int depth, int offsets[4],
+				     Indirect chain[4], int *err)
+{
+	struct super_block *sb = inode->i_sb;
+	struct buffer_head *first_bh, *prev_bh;
+	unsigned long max_read, blocks_done = 0;
+	__le32 *ind_blocks;
+
+	/* Must have doubly indirect block for prefetching indirect blocks. */
+	BUG_ON(depth <= 2);
+	BUG_ON(!chain[depth-2].key);
+
+	*err = 0;
+
+	/* Handle first block */
+	ind_blocks = chain[depth-2].p;
+	first_bh = sb_getblk(sb, le32_to_cpu(ind_blocks[0]));
+	if (unlikely(!first_bh)) {
+		printk(KERN_ERR "Failed to get block %u for sb %p\n",
+		       le32_to_cpu(ind_blocks[0]), sb);
+		goto failure;
+	}
+
+	BUG_ON(first_bh->b_size != sb->s_blocksize);
+
+	if (buffer_uptodate(first_bh)) {
+		/* Found the buffer in cache, either it was accessed recently or
+		 * it was prefetched while reading previous indirect block(s).
+		 * We need to figure out if we need to prefetch the following
+		 * indirect blocks.
+		 */
+		if (!ext3_buffer_prefetch(first_bh)) {
+			/* Either we've seen this indirect block before while
+			 * accessing another data block, or this is a random
+			 * read. In the former case, we must have done the
+			 * needful the first time we had a cache hit on this
+			 * indirect block, in the latter case we obviously
+			 * don't need to do any prefetching.
+			 */
+			goto done;
+		}
+
+		max_read = ext3_get_max_read(inode, iblock,
+					     offsets[depth-2]);
+
+		/* This indirect block is in the cache due to prefetching and
+		 * this is its first cache hit, clear the prefetch bit and
+		 * make sure the following blocks are also prefetched.
+		 */
+		ext3_clear_buffer_prefetch(first_bh);
+
+		if (max_read >= 2) {
+			/* ext3_read_indblocks_async() stops at the first
+			 * indirect block which has the prefetch bit set which
+			 * will most likely be the very next indirect block.
+			 */
+			ext3_read_indblocks_async(sb, &ind_blocks[1],
+						  max_read - 1,
+						  NULL, 1, &blocks_done);
+		}
+
+	} else {
+		/* Buffer is not in memory, we need to read it. If we are
+		 * reading sequentially from the previous indirect block, we
+		 * have just detected a sequential read and we must prefetch
+		 * some indirect blocks for future.
+		 */
+
+		max_read = ext3_get_max_read(inode, iblock,
+					     offsets[depth-2]);
+
+		if ((ind_blocks - (__le32 *)chain[depth-2].bh->b_data) >= 1) {
+			prev_bh = sb_getblk(sb, le32_to_cpu(ind_blocks[-1]));
+			if (buffer_uptodate(prev_bh) &&
+			    !ext3_buffer_prefetch(prev_bh)) {
+				/* Detected sequential read. */
+				brelse(prev_bh);
+
+				/* Sync read indirect block, also read the next
+				 * few indirect blocks.
+				 */
+				*err = ext3_read_indblocks_sync(sb, ind_blocks,
+							 max_read, first_bh, 1,
+							 &blocks_done);
+
+				if (*err)
+					goto out;
+
+				/* In case the very next indirect block is
+				 * discontiguous by a non-trivial amount,
+				 * ext3_read_indblocks_sync() above won't
+				 * prefetch it (indicated by blocks_done < 2).
+				 * So to help sequential read, schedule an
+				 * async request for reading the next
+				 * contiguous indirect block range (which
+				 * in metaclustering case would be the next
+				 * metacluster, without metaclustering it
+				 * would be the next indirect block). This is
+				 * expected to benefit the non-metaclustering
+				 * case.
+				 */
+				if (max_read >= 2 && blocks_done < 2)
+					ext3_read_indblocks_async(sb,
+							&ind_blocks[1],
+							max_read - 1,
+							NULL, 1, &blocks_done);
+
+				goto done;
+			}
+			brelse(prev_bh);
+		}
+
+		/* Either random read, or sequential detection failed above.
+		 * We always prefetch the next indirect block in this case
+		 * whenever possible.
+		 * This is because for random reads of size ~512KB, there is
+		 * >12% chance that a read will span two indirect blocks.
+		 */
+		*err = ext3_read_indblocks_sync(sb, ind_blocks,
+						(max_read >= 2) ? 2 : 1,
+						first_bh, 0, &blocks_done);
+		if (*err)
+			goto out;
+	}
+
+done:
+	/* Reader: pointers */
+	if (!verify_chain(chain, &chain[depth - 2])) {
+		brelse(first_bh);
+		goto changed;
+	}
+	add_chain(&chain[depth - 1], first_bh,
+		  (__le32*)first_bh->b_data + offsets[depth - 1]);
+	/* Reader: end */
+	if (!chain[depth - 1].key)
+		goto out;
+
+	BUG_ON(!buffer_uptodate(first_bh));
+	return NULL;
+
+changed:
+	*err = -EAGAIN;
+	goto out;
+failure:
+	*err = -EIO;
+out:
+	if (*err) {
+		ext3_debug("Error %d reading indirect blocks\n", *err);
+		return &chain[depth - 2];
+	} else
+		return &chain[depth - 1];
+}
+
diff -uprdN linux-2.6.23mm1-clean/fs/ext3/super.c
linux-2.6.23mm1-ext3mc/fs/ext3/super.c
--- linux-2.6.23mm1-clean/fs/ext3/super.c	2007-10-17 18:31:42.000000000 -0700
+++ linux-2.6.23mm1-ext3mc/fs/ext3/super.c	2007-12-20 18:11:14.000000000 -0800
@@ -625,6 +625,9 @@ static int ext3_show_options(struct seq_
 	else if (test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_WRITEBACK_DATA)
 		seq_puts(seq, ",data=writeback");

+	if (test_opt(sb, METACLUSTER))
+		seq_puts(seq, ",metacluster");
+
 	ext3_show_quota_options(seq, sb);

 	return 0;
@@ -758,7 +761,7 @@ enum {
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
-	Opt_grpquota
+	Opt_grpquota, Opt_metacluster
 };

 static match_table_t tokens = {
@@ -808,6 +811,7 @@ static match_table_t tokens = {
 	{Opt_quota, "quota"},
 	{Opt_usrquota, "usrquota"},
 	{Opt_barrier, "barrier=%u"},
+	{Opt_metacluster, "metacluster"},
 	{Opt_err, NULL},
 	{Opt_resize, "resize"},
 };
@@ -1140,6 +1144,9 @@ clear_qf_name:
 		case Opt_bh:
 			clear_opt(sbi->s_mount_opt, NOBH);
 			break;
+		case Opt_metacluster:
+			set_opt(sbi->s_mount_opt, METACLUSTER);
+			break;
 		default:
 			printk (KERN_ERR
 				"EXT3-fs: Unrecognized mount option \"%s\" "
@@ -1674,6 +1681,13 @@ static int ext3_fill_super (struct super
 	}
 	sbi->s_frags_per_block = 1;
 	sbi->s_blocks_per_group = le32_to_cpu(es->s_blocks_per_group);
+	if (test_opt(sb, METACLUSTER)) {
+		sbi->s_nonmc_blocks_per_group = sbi->s_blocks_per_group -
+			sbi->s_blocks_per_group / 12;
+		sbi->s_nonmc_blocks_per_group &= ~7;
+	} else
+		sbi->s_nonmc_blocks_per_group = sbi->s_blocks_per_group;
+
 	sbi->s_frags_per_group = le32_to_cpu(es->s_frags_per_group);
 	sbi->s_inodes_per_group = le32_to_cpu(es->s_inodes_per_group);
 	if (EXT3_INODE_SIZE(sb) == 0)
@@ -1783,6 +1797,18 @@ static int ext3_fill_super (struct super
 	sbi->s_rsv_window_head.rsv_goal_size = 0;
 	ext3_rsv_window_add(sb, &sbi->s_rsv_window_head);

+	if (test_opt(sb, METACLUSTER)) {
+		sbi->s_bginfo = kmalloc(sbi->s_groups_count *
+					sizeof(*sbi->s_bginfo), GFP_KERNEL);
+		if (!sbi->s_bginfo) {
+			printk(KERN_ERR "EXT3-fs: not enough memory\n");
+			goto failed_mount3;
+		}
+		for (i = 0; i < sbi->s_groups_count; i++)
+			sbi->s_bginfo[i].bgi_free_nonmc_blocks_count = -1;
+	} else
+		sbi->s_bginfo = NULL;
+
 	/*
 	 * set up enough so that it can read an inode
 	 */
@@ -1808,16 +1834,16 @@ static int ext3_fill_super (struct super
 	if (!test_opt(sb, NOLOAD) &&
 	    EXT3_HAS_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
 		if (ext3_load_journal(sb, es, journal_devnum))
-			goto failed_mount3;
+			goto failed_mount4;
 	} else if (journal_inum) {
 		if (ext3_create_journal(sb, es, journal_inum))
-			goto failed_mount3;
+			goto failed_mount4;
 	} else {
 		if (!silent)
 			printk (KERN_ERR
 				"ext3: No journal on filesystem on %s\n",
 				sb->s_id);
-		goto failed_mount3;
+		goto failed_mount4;
 	}

 	/* We have now updated the journal if required, so we can
@@ -1840,7 +1866,7 @@ static int ext3_fill_super (struct super
 		    (sbi->s_journal, 0, 0, JFS_FEATURE_INCOMPAT_REVOKE)) {
 			printk(KERN_ERR "EXT3-fs: Journal does not support "
 			       "requested data journaling mode\n");
-			goto failed_mount4;
+			goto failed_mount5;
 		}
 	default:
 		break;
@@ -1863,13 +1889,13 @@ static int ext3_fill_super (struct super
 	if (!sb->s_root) {
 		printk(KERN_ERR "EXT3-fs: get root inode failed\n");
 		iput(root);
-		goto failed_mount4;
+		goto failed_mount5;
 	}
 	if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root->i_size) {
 		dput(sb->s_root);
 		sb->s_root = NULL;
 		printk(KERN_ERR "EXT3-fs: corrupt root inode, run e2fsck\n");
-		goto failed_mount4;
+		goto failed_mount5;
 	}

 	ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY);
@@ -1901,8 +1927,10 @@ cantfind_ext3:
 		       sb->s_id);
 	goto failed_mount;

-failed_mount4:
+failed_mount5:
 	journal_destroy(sbi->s_journal);
+failed_mount4:
+	kfree(sbi->s_bginfo);
 failed_mount3:
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
diff -uprdN linux-2.6.23mm1-clean/include/linux/ext3_fs.h
linux-2.6.23mm1-ext3mc/include/linux/ext3_fs.h
--- linux-2.6.23mm1-clean/include/linux/ext3_fs.h	2007-10-17
18:31:43.000000000 -0700
+++ linux-2.6.23mm1-ext3mc/include/linux/ext3_fs.h	2007-12-21
05:40:05.000000000 -0800
@@ -380,6 +380,7 @@ struct ext3_inode {
 #define EXT3_MOUNT_QUOTA		0x80000 /* Some quota option set */
 #define EXT3_MOUNT_USRQUOTA		0x100000 /* "old" user quota */
 #define EXT3_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
+#define EXT3_MOUNT_METACLUSTER		0x400000 /* Indirect block clustering */

 /* Compatibility, for having both ext2_fs.h and ext3_fs.h included at once */
 #ifndef _LINUX_EXT2_FS_H
@@ -493,6 +494,7 @@ struct ext3_super_block {
 #ifdef __KERNEL__
 #include <linux/ext3_fs_i.h>
 #include <linux/ext3_fs_sb.h>
+#include <linux/buffer_head.h>
 static inline struct ext3_sb_info * EXT3_SB(struct super_block *sb)
 {
 	return sb->s_fs_info;
@@ -722,6 +724,11 @@ struct dir_private_info {
 	__u32		next_hash;
 };

+/* Special bh flag used by the metacluster readahead logic. */
+enum ext3_bh_state_bits {
+	EXT3_BH_PREFETCH = BH_JBD_Sentinel,
+};
+
 /* calculate the first block number of the group */
 static inline ext3_fsblk_t
 ext3_group_first_block_no(struct super_block *sb, unsigned long group_no)
@@ -730,6 +737,24 @@ ext3_group_first_block_no(struct super_b
 		le32_to_cpu(EXT3_SB(sb)->s_es->s_first_data_block);
 }

+static inline void
+ext3_set_buffer_prefetch(struct buffer_head *bh)
+{
+	set_bit(EXT3_BH_PREFETCH, &bh->b_state);
+}
+
+static inline void
+ext3_clear_buffer_prefetch(struct buffer_head *bh)
+{
+	clear_bit(EXT3_BH_PREFETCH, &bh->b_state);
+}
+
+static inline int
+ext3_buffer_prefetch(struct buffer_head *bh)
+{
+	return test_bit(EXT3_BH_PREFETCH, &bh->b_state);
+}
+
 /*
  * Special error return code only used by dx_probe() and its callers.
  */
@@ -752,8 +777,9 @@ extern int ext3_bg_has_super(struct supe
 extern unsigned long ext3_bg_num_gdb(struct super_block *sb, int group);
 extern ext3_fsblk_t ext3_new_block (handle_t *handle, struct inode *inode,
 			ext3_fsblk_t goal, int *errp);
-extern ext3_fsblk_t ext3_new_blocks (handle_t *handle, struct inode *inode,
-			ext3_fsblk_t goal, unsigned long *count, int *errp);
+extern int ext3_new_blocks(handle_t *handle, struct inode *inode,
+			ext3_fsblk_t goal, int indirect_blks, int blks,
+			ext3_fsblk_t new_blocks[], int *errp);
 extern void ext3_free_blocks (handle_t *handle, struct inode *inode,
 			ext3_fsblk_t block, unsigned long count);
 extern void ext3_free_blocks_sb (handle_t *handle, struct super_block *sb,
diff -uprdN linux-2.6.23mm1-clean/include/linux/ext3_fs_sb.h
linux-2.6.23mm1-ext3mc/include/linux/ext3_fs_sb.h
--- linux-2.6.23mm1-clean/include/linux/ext3_fs_sb.h	2007-10-17
18:31:43.000000000 -0700
+++ linux-2.6.23mm1-ext3mc/include/linux/ext3_fs_sb.h	2007-12-20
18:11:14.000000000 -0800
@@ -24,6 +24,8 @@
 #endif
 #include <linux/rbtree.h>

+struct ext3_bg_info;
+
 /*
  * third extended-fs super-block data in memory
  */
@@ -33,6 +35,7 @@ struct ext3_sb_info {
 	unsigned long s_inodes_per_block;/* Number of inodes per block */
 	unsigned long s_frags_per_group;/* Number of fragments in a group */
 	unsigned long s_blocks_per_group;/* Number of blocks in a group */
+	unsigned long s_nonmc_blocks_per_group;/* Number of non-metacluster
blocks in a group */
 	unsigned long s_inodes_per_group;/* Number of inodes in a group */
 	unsigned long s_itb_per_group;	/* Number of inode table blocks per group */
 	unsigned long s_gdb_count;	/* Number of group descriptor blocks */
@@ -67,6 +70,9 @@ struct ext3_sb_info {
 	struct rb_root s_rsv_window_root;
 	struct ext3_reserve_window_node s_rsv_window_head;

+	/* array of per-bg in-memory info */
+	struct ext3_bg_info *s_bginfo;
+
 	/* Journaling */
 	struct inode * s_journal_inode;
 	struct journal_s * s_journal;
@@ -83,4 +89,11 @@ struct ext3_sb_info {
 #endif
 };

+/*
+ * in-memory data associated with each block group.
+ */
+struct ext3_bg_info {
+	int bgi_free_nonmc_blocks_count;/* Number of free non-metacluster
blocks in group */
+};
+
 #endif	/* _LINUX_EXT3_FS_SB */
diff -uprdN linux-2.6.23mm1-clean/include/linux/jbd.h
linux-2.6.23mm1-ext3mc/include/linux/jbd.h
--- linux-2.6.23mm1-clean/include/linux/jbd.h	2007-10-17
18:31:43.000000000 -0700
+++ linux-2.6.23mm1-ext3mc/include/linux/jbd.h	2007-12-20
18:11:14.000000000 -0800
@@ -294,6 +294,7 @@ enum jbd_state_bits {
 	BH_State,		/* Pins most journal_head state */
 	BH_JournalHead,		/* Pins bh->b_private and jh->b_bh */
 	BH_Unshadow,		/* Dummy bit, for BJ_Shadow wakeup filtering */
+	BH_JBD_Sentinel,	/* Start bit for clients of jbd */
 };

 BUFFER_FNS(JBD, jbd)








On Nov 16, 2007 6:58 PM, Theodore Tso <tytso@mit.edu> wrote:
> The practice of starting search in the next block block in the
> metadata area only makes a difference for one indirect block, yes, but
> it's the right thing to do.  And if you fold the ext3_new_blocks and
> ext3_new_indirect_blocks(), it's really not that hard.  You can
> basically do something like this:
>
>         if (alloc_for_metadata)
>                 strategy = 0x132;
>         else
>                 strategy = 0x231;
>         for (; strategy; strategy = strategy >> 8) {
>                 switch (strategy & 0xF) {
>                 case 1:
>                      start = block_group_start;
>                      end = mc_start - 1;
>                      break;
>                 case 2:
>                      start = mc_start;
>                      end = mc_end;
>                      break;
>                 case 3:
>                      start = mc_end + 1;
>                      end = block_group_end;
>                      break;
>                 }
>                 <search region between start.. end>
>         }
>
> > We initially avoided making metaclustering a superblock tunable as we
> > didn't want to make any changes to the on-disk format as then ext4
> > extents are also a good option.
>
> Allocating a superblock field is no big deal.  I'll note further that
> metaclustering is not necessarily mutually exclusive with ext4
> extents.  Allocating the extent tree data blocks out of the
> metacluster blocks can be a good idea, depending on the average size
> of the blocks and how fragmented the filesystem gets (and hence how
> many contiguous extents can be expected).  If the filesystem is
> storing lots of really big files where being contiguous across
> multiple blockgroups are productive, then the metacluster area would
> actually be counterproductive.  And if files are all small so the
> extents fit the inode, the metadata cluster area wouldn't be necessary
> at all.  But if there are multiple external extent blocks in a block
> group, it would be useful for them to be allocated together.
>
> > If metaclustering gains acceptance
> > it might make sense to make it a superblock tunable. However, I would
> > avoid putting metacluster size into the superblock for the following
> > reason. Ideally, we should not have to bother about finding the sweet
> > spot of metacluster size as
> > (1) a given file system can be used for storing different kinds
> > of files at different times and it would be a pain to tune it every now
> > and then, and
>
> Yes, it doesn't make sense to retune the filesystem.  I was assuming
> that this would only be done at mke2fs time.
>
> > (2) it opens the possibility of doubting metcluster size for unrelated
> > ext3/fsck performance anomalies.
>
> I'm not sure I understand your concern.  The reality is that 99% of
> the time users will never change it from the defaults, but making it
> tunable makes it much, much easier for us to try various experiments
> to determine what is the best initial value for different workloads.
> What might get used for a Usenet news spool or a Squid cache might be
> quite different from series of DVD image files.
>
> > Allow me to propose a solution that will most likely address the above
> > issue and please ignore its complexity for a moment. Instead of a two
> > level partitioning in the block space between data blocks and
> > metacluster blocks, have a 3 or 4 level partitioning. E.g., a block
> > group with 'd' blocks can have d/32 blocks in metacluster level 1,
> > d/64 blocks in metacluster level 2, and d/128 blocks in metacluster
> > level 3 (define level 0 has having the remaining blocks = d - d/32 -
> > d/64 - d/128). Data block allocation starts looking for a free block
> > starting from the lowest possible level. If it is unable to find any
> > free blocks at that level in all block groups, it moves up a level and
> > so on. Indirect block allocation proceeds in the opposite direction
> > starting from higher levels. This approach has several benefits:
>
> That is clever.  Oh, one other thing.  You didn't mention what
> happened when the metacluster field was placed at the end of the block
> group.  I assume you tried that in your experiments; what were the
> results?  The obvious thing to do to avoid further fragmentation of
> the block group would be to put level 1 at the end of the block group,
> level 2 just before it, and level 3 before that, and then allocate the
> data blocks starting at the beginning of the block group, i.e:
>
> +----------------------------------+---------------+---------+-------+
> |     data                         | level 3       | level 2 | lvl 1 |
> +----------------------------------+---------------+---------+-------+
>
>
> > In traditional metaclustering, once we run out of metacluster blocks
> > or data blocks, all bets are off. This forces us to keep small
> > metaclusters in order to avoid this situation altogether. But with small
> > metaclusters, we cannot optimize indirect block allocation on file
> > systems with many small files (>48KB).There is only one glitch in
> > implementing this. If a block group doesn't have any free blocks at a
> > given level, we should be able to find that out quickly instead of
> > having to scan its entire bitmap. gdp->bg_free_blocks_count is not good
> > enough for this.
>
> Ideally, true, but this was a defect with the original metacluster
> scheme as well.  We could steal some bits in the block_group
> descriptor structure to indicate whether a particular level is full,
> though.  This would be another data format change that would require
> e2fsprogs support, though.
>
> Regards,
>
>                                                 - Ted
>
