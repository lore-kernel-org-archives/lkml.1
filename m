Return-Path: <linux-kernel-owner+w=401wt.eu-S1765490AbXEWTWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765490AbXEWTWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 15:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbXEWTV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 15:21:56 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:6980 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbXEWTVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 15:21:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=eSV7OzldJAOFOcuiGcnDm4Mg923fCSNqwvrM7krnTNno52dfPh7Iu2Ehv/m1upx29H8RNN06VRn9W2yKivGd+/u6478D52oGyRPgyXmrItMQAGrAJKB02GAS5n1DnoVU+qgnYtaIymLNSO0frT//kE1/OfGY3Xic/q48QxdGOrs=
Date: Wed, 23 May 2007 22:44:36 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH]: UDF code style conversion to kernel style
Message-ID: <20070523184436.GA14771@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts UDF system coding style to kernel coding style.
There is no error fixing - just code cleanup. I attempted to make
the minimum changes as possible but the patch was growing and growing.
So there is a lot of code to review and that could be painful and boring.
I've it reviewed several times to assure that the patch does not break
current UDF system... but I've only one pair of eyes.

Any comments, suggestions and swearing are welcome. But don't be
expected for fast reply - I'm not mature kernel developer ;)

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

---

Andrew, this patch is over current -mm tree (I've assumed
that my prev patches were already applied).

 fs/udf/balloc.c    |  485 +++++++++++---------------
 fs/udf/dir.c       |   92 ++---
 fs/udf/directory.c |  148 ++++-----
 fs/udf/ecma_167.h  |  166 +++------
 fs/udf/file.c      |   68 ++--
 fs/udf/fsync.c     |    4 +-
 fs/udf/ialloc.c    |   36 +-
 fs/udf/inode.c     |  991 ++++++++++++++++++++++------------------------------
 fs/udf/lowlevel.c  |   15 +-
 fs/udf/misc.c      |  113 +++----
 fs/udf/namei.c     |  512 +++++++++++----------------
 fs/udf/osta_udf.h  |   53 +--
 fs/udf/partition.c |  117 +++----
 fs/udf/super.c     |  773 +++++++++++++++++------------------------
 fs/udf/symlink.c   |   22 +-
 fs/udf/truncate.c  |  123 +++----
 fs/udf/udf_sb.h    |   20 +-
 fs/udf/udfdecl.h   |   12 +-
 fs/udf/udfend.h    |   18 +
 fs/udf/udftime.c   |   73 ++--
 fs/udf/unicode.c   |  237 +++++--------
 21 files changed, 1689 insertions(+), 2389 deletions(-)


diff --git a/fs/udf/Makefile b/fs/udf/Makefile
diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 4cec910..ee7e839 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -51,8 +51,7 @@ static inline int find_next_one_bit (void * addr, int size, int offset)
 		return size;
 	size -= result;
 	offset &= (BITS_PER_LONG-1);
-	if (offset)
-	{
+	if (offset) {
 		tmp = leBPL_to_cpup(p++);
 		tmp &= ~0UL << offset;
 		if (size < BITS_PER_LONG)
@@ -62,8 +61,7 @@ static inline int find_next_one_bit (void * addr, int size, int offset)
 		size -= BITS_PER_LONG;
 		result += BITS_PER_LONG;
 	}
-	while (size & ~(BITS_PER_LONG-1))
-	{
+	while (size & ~(BITS_PER_LONG-1)) {
 		if ((tmp = leBPL_to_cpup(p++)))
 			goto found_middle;
 		result += BITS_PER_LONG;
@@ -82,7 +80,8 @@ found_middle:
 	find_next_one_bit((addr), (size), 0)
 
 static int read_block_bitmap(struct super_block * sb,
-	struct udf_bitmap *bitmap, unsigned int block, unsigned long bitmap_nr)
+			     struct udf_bitmap *bitmap,
+			     unsigned int block, unsigned long bitmap_nr)
 {
 	struct buffer_head *bh = NULL;
 	int retval = 0;
@@ -93,29 +92,27 @@ static int read_block_bitmap(struct super_block * sb,
 
 	bh = udf_tread(sb, udf_get_lb_pblock(sb, loc, block));
 	if (!bh)
-	{
 		retval = -EIO;
-	}
 	bitmap->s_block_bitmap[bitmap_nr] = bh;
 	return retval;
 }
 
 static int __load_block_bitmap(struct super_block * sb,
-	struct udf_bitmap *bitmap, unsigned int block_group)
+			       struct udf_bitmap *bitmap,
+			       unsigned int block_group)
 {
 	int retval = 0;
 	int nr_groups = bitmap->s_nr_groups;
 
 	if (block_group >= nr_groups)
-	{
-		udf_debug("block_group (%d) > nr_groups (%d)\n", block_group, nr_groups);
-	}
+		udf_debug("block_group (%d) > nr_groups (%d)\n",
+			  block_group, nr_groups);
 
-	if (bitmap->s_block_bitmap[block_group])
+	if (bitmap->s_block_bitmap[block_group]) {
 		return block_group;
-	else
-	{
-		retval = read_block_bitmap(sb, bitmap, block_group, block_group);
+	} else {
+		retval = read_block_bitmap(sb, bitmap, block_group,
+					   block_group);
 		if (retval < 0)
 			return retval;
 		return block_group;
@@ -123,7 +120,8 @@ static int __load_block_bitmap(struct super_block * sb,
 }
 
 static inline int load_block_bitmap(struct super_block * sb,
-	struct udf_bitmap *bitmap, unsigned int block_group)
+				    struct udf_bitmap *bitmap,
+				    unsigned int block_group)
 {
 	int slot;
 
@@ -139,9 +137,10 @@ static inline int load_block_bitmap(struct super_block * sb,
 }
 
 static void udf_bitmap_free_blocks(struct super_block * sb,
-	struct inode * inode,
-	struct udf_bitmap *bitmap,
-	kernel_lb_addr bloc, uint32_t offset, uint32_t count)
+				   struct inode * inode,
+				   struct udf_bitmap *bitmap,
+				   kernel_lb_addr bloc, uint32_t offset,
+				   uint32_t count)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct buffer_head * bh = NULL;
@@ -154,11 +153,10 @@ static void udf_bitmap_free_blocks(struct super_block * sb,
 
 	mutex_lock(&sbi->s_alloc_mutex);
 	if (bloc.logicalBlockNum < 0 ||
-		(bloc.logicalBlockNum + count) > UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum))
-	{
+	    (bloc.logicalBlockNum + count) > UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum)) {
 		udf_debug("%d < %d || %d + %d > %d\n",
-			bloc.logicalBlockNum, 0, bloc.logicalBlockNum, count,
-			UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum));
+			  bloc.logicalBlockNum, 0, bloc.logicalBlockNum, count,
+			  UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum));
 		goto error_return;
 	}
 
@@ -172,8 +170,7 @@ do_more:
 	/*
 	 * Check to see if we are freeing blocks across a group boundary.
 	 */
-	if (bit + count > (sb->s_blocksize << 3))
-	{
+	if (bit + count > (sb->s_blocksize << 3)) {
 		overflow = bit + count - (sb->s_blocksize << 3);
 		count -= overflow;
 	}
@@ -182,27 +179,21 @@ do_more:
 		goto error_return;
 
 	bh = bitmap->s_block_bitmap[bitmap_nr];
-	for (i=0; i < count; i++)
-	{
-		if (udf_set_bit(bit + i, bh->b_data))
-		{
+	for (i = 0; i < count; i++) {
+		if (udf_set_bit(bit + i, bh->b_data)) {
 			udf_debug("bit %ld already set\n", bit + i);
 			udf_debug("byte=%2x\n", ((char *)bh->b_data)[(bit + i) >> 3]);
-		}
-		else
-		{
+		} else {
 			if (inode)
 				DQUOT_FREE_BLOCK(inode, 1);
-			if (UDF_SB_LVIDBH(sb))
-			{
+			if (UDF_SB_LVIDBH(sb)) {
 				UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)] =
 					cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)])+1);
 			}
 		}
 	}
 	mark_buffer_dirty(bh);
-	if (overflow)
-	{
+	if (overflow) {
 		block += count;
 		count = overflow;
 		goto do_more;
@@ -216,9 +207,11 @@ error_return:
 }
 
 static int udf_bitmap_prealloc_blocks(struct super_block * sb,
-	struct inode * inode,
-	struct udf_bitmap *bitmap, uint16_t partition, uint32_t first_block,
-	uint32_t block_count)
+				      struct inode * inode,
+				      struct udf_bitmap *bitmap,
+				      uint16_t partition,
+				      uint32_t first_block,
+				      uint32_t block_count)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	int alloc_count = 0;
@@ -235,7 +228,8 @@ static int udf_bitmap_prealloc_blocks(struct super_block * sb,
 
 repeat:
 	nr_groups = (UDF_SB_PARTLEN(sb, partition) +
-		(sizeof(struct spaceBitmapDesc) << 3) + (sb->s_blocksize * 8) - 1) / (sb->s_blocksize * 8);
+		     (sizeof(struct spaceBitmapDesc) << 3) +
+		     (sb->s_blocksize * 8) - 1) / (sb->s_blocksize * 8);
 	block = first_block + (sizeof(struct spaceBitmapDesc) << 3);
 	block_group = block >> (sb->s_blocksize_bits + 3);
 	group_start = block_group ? 0 : sizeof(struct spaceBitmapDesc);
@@ -247,14 +241,12 @@ repeat:
 
 	bit = block % (sb->s_blocksize << 3);
 
-	while (bit < (sb->s_blocksize << 3) && block_count > 0)
-	{
-		if (!udf_test_bit(bit, bh->b_data))
+	while (bit < (sb->s_blocksize << 3) && block_count > 0) {
+		if (!udf_test_bit(bit, bh->b_data)) {
 			goto out;
-		else if (DQUOT_PREALLOC_BLOCK(inode, 1))
+		} else if (DQUOT_PREALLOC_BLOCK(inode, 1)) {
 			goto out;
-		else if (!udf_clear_bit(bit, bh->b_data))
-		{
+		} else if (!udf_clear_bit(bit, bh->b_data)) {
 			udf_debug("bit already cleared for block %d\n", bit);
 			DQUOT_FREE_BLOCK(inode, 1);
 			goto out;
@@ -268,8 +260,7 @@ repeat:
 	if (block_count > 0)
 		goto repeat;
 out:
-	if (UDF_SB_LVIDBH(sb))
-	{
+	if (UDF_SB_LVIDBH(sb)) {
 		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
 			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition])-alloc_count);
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
@@ -280,11 +271,13 @@ out:
 }
 
 static int udf_bitmap_new_block(struct super_block * sb,
-	struct inode * inode,
-	struct udf_bitmap *bitmap, uint16_t partition, uint32_t goal, int *err)
+				struct inode * inode,
+				struct udf_bitmap *bitmap,
+				uint16_t partition,
+				uint32_t goal, int *err)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
-	int newbit, bit=0, block, block_group, group_start;
+	int newbit, bit = 0, block, block_group, group_start;
 	int end_goal, nr_groups, bitmap_nr, i;
 	struct buffer_head *bh = NULL;
 	char *ptr;
@@ -306,37 +299,34 @@ repeat:
 	if (bitmap_nr < 0)
 		goto error_return;
 	bh = bitmap->s_block_bitmap[bitmap_nr];
-	ptr = memscan((char *)bh->b_data + group_start, 0xFF, sb->s_blocksize - group_start);
+	ptr = memscan((char *)bh->b_data + group_start, 0xFF,
+		      sb->s_blocksize - group_start);
 
-	if ((ptr - ((char *)bh->b_data)) < sb->s_blocksize)
-	{
+	if ((ptr - ((char *)bh->b_data)) < sb->s_blocksize) {
 		bit = block % (sb->s_blocksize << 3);
-
 		if (udf_test_bit(bit, bh->b_data))
-		{
 			goto got_block;
-		}
+
 		end_goal = (bit + 63) & ~63;
 		bit = udf_find_next_one_bit(bh->b_data, end_goal, bit);
 		if (bit < end_goal)
 			goto got_block;
+
 		ptr = memscan((char *)bh->b_data + (bit >> 3), 0xFF, sb->s_blocksize - ((bit + 7) >> 3));
 		newbit = (ptr - ((char *)bh->b_data)) << 3;
-		if (newbit < sb->s_blocksize << 3)
-		{
+		if (newbit < sb->s_blocksize << 3) {
 			bit = newbit;
 			goto search_back;
 		}
+
 		newbit = udf_find_next_one_bit(bh->b_data, sb->s_blocksize << 3, bit);
-		if (newbit < sb->s_blocksize << 3)
-		{
+		if (newbit < sb->s_blocksize << 3) {
 			bit = newbit;
 			goto got_block;
 		}
 	}
 
-	for (i=0; i<(nr_groups*2); i++)
-	{
+	for (i = 0; i < (nr_groups * 2); i++) {
 		block_group ++;
 		if (block_group >= nr_groups)
 			block_group = 0;
@@ -346,24 +336,22 @@ repeat:
 		if (bitmap_nr < 0)
 			goto error_return;
 		bh = bitmap->s_block_bitmap[bitmap_nr];
-		if (i < nr_groups)
-		{
-			ptr = memscan((char *)bh->b_data + group_start, 0xFF, sb->s_blocksize - group_start);
-			if ((ptr - ((char *)bh->b_data)) < sb->s_blocksize)
-			{
+		if (i < nr_groups) {
+			ptr = memscan((char *)bh->b_data + group_start, 0xFF,
+				      sb->s_blocksize - group_start);
+			if ((ptr - ((char *)bh->b_data)) < sb->s_blocksize) {
 				bit = (ptr - ((char *)bh->b_data)) << 3;
 				break;
 			}
-		}
-		else
-		{
-			bit = udf_find_next_one_bit((char *)bh->b_data, sb->s_blocksize << 3, group_start << 3);
+		} else {
+			bit = udf_find_next_one_bit((char *)bh->b_data,
+						    sb->s_blocksize << 3,
+						    group_start << 3);
 			if (bit < sb->s_blocksize << 3)
 				break;
 		}
 	}
-	if (i >= (nr_groups*2))
-	{
+	if (i >= (nr_groups * 2)) {
 		mutex_unlock(&sbi->s_alloc_mutex);
 		return newblock;
 	}
@@ -371,22 +359,21 @@ repeat:
 		goto search_back;
 	else
 		bit = udf_find_next_one_bit(bh->b_data, sb->s_blocksize << 3, group_start << 3);
-	if (bit >= sb->s_blocksize << 3)
-	{
+	if (bit >= sb->s_blocksize << 3) {
 		mutex_unlock(&sbi->s_alloc_mutex);
 		return 0;
 	}
 
 search_back:
-	for (i=0; i<7 && bit > (group_start << 3) && udf_test_bit(bit - 1, bh->b_data); i++, bit--);
+	for (i = 0; i < 7 && bit > (group_start << 3) && udf_test_bit(bit - 1, bh->b_data); i++, bit--)
+		; /* empty loop */
 
 got_block:
 
 	/*
 	 * Check quota for allocation of this block.
 	 */
-	if (inode && DQUOT_ALLOC_BLOCK(inode, 1))
-	{
+	if (inode && DQUOT_ALLOC_BLOCK(inode, 1)) {
 		mutex_unlock(&sbi->s_alloc_mutex);
 		*err = -EDQUOT;
 		return 0;
@@ -395,16 +382,14 @@ got_block:
 	newblock = bit + (block_group << (sb->s_blocksize_bits + 3)) -
 		(sizeof(struct spaceBitmapDesc) << 3);
 
-	if (!udf_clear_bit(bit, bh->b_data))
-	{
+	if (!udf_clear_bit(bit, bh->b_data)) {
 		udf_debug("bit already cleared for block %d\n", bit);
 		goto repeat;
 	}
 
 	mark_buffer_dirty(bh);
 
-	if (UDF_SB_LVIDBH(sb))
-	{
+	if (UDF_SB_LVIDBH(sb)) {
 		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
 			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition])-1);
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
@@ -421,9 +406,10 @@ error_return:
 }
 
 static void udf_table_free_blocks(struct super_block * sb,
-	struct inode * inode,
-	struct inode * table,
-	kernel_lb_addr bloc, uint32_t offset, uint32_t count)
+				  struct inode * inode,
+				  struct inode * table,
+				  kernel_lb_addr bloc, uint32_t offset,
+				  uint32_t count)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	uint32_t start, end;
@@ -435,11 +421,10 @@ static void udf_table_free_blocks(struct super_block * sb,
 
 	mutex_lock(&sbi->s_alloc_mutex);
 	if (bloc.logicalBlockNum < 0 ||
-		(bloc.logicalBlockNum + count) > UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum))
-	{
+	    (bloc.logicalBlockNum + count) > UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum)) {
 		udf_debug("%d < %d || %d + %d > %d\n",
-			bloc.logicalBlockNum, 0, bloc.logicalBlockNum, count,
-			UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum));
+			  bloc.logicalBlockNum, 0, bloc.logicalBlockNum, count,
+			  UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum));
 		goto error_return;
 	}
 
@@ -447,8 +432,7 @@ static void udf_table_free_blocks(struct super_block * sb,
 	   but.. oh well */
 	if (inode)
 		DQUOT_FREE_BLOCK(inode, count);
-	if (UDF_SB_LVIDBH(sb))
-	{
+	if (UDF_SB_LVIDBH(sb)) {
 		UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)] =
 			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)])+count);
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
@@ -462,74 +446,59 @@ static void udf_table_free_blocks(struct super_block * sb,
 	epos.block = oepos.block = UDF_I_LOCATION(table);
 	epos.bh = oepos.bh = NULL;
 
-	while (count && (etype =
-		udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1)
-	{
-		if (((eloc.logicalBlockNum + (elen >> sb->s_blocksize_bits)) ==
-			start))
-		{
-			if ((0x3FFFFFFF - elen) < (count << sb->s_blocksize_bits))
-			{
+	while (count &&
+	       (etype = udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1) {
+		if (((eloc.logicalBlockNum + (elen >> sb->s_blocksize_bits)) == start)) {
+			if ((0x3FFFFFFF - elen) < (count << sb->s_blocksize_bits)) {
 				count -= ((0x3FFFFFFF - elen) >> sb->s_blocksize_bits);
 				start += ((0x3FFFFFFF - elen) >> sb->s_blocksize_bits);
 				elen = (etype << 30) | (0x40000000 - sb->s_blocksize);
-			}
-			else
-			{
-				elen = (etype << 30) |
-					(elen + (count << sb->s_blocksize_bits));
+			} else {
+				elen = (etype << 30) | (elen + (count << sb->s_blocksize_bits));
 				start += count;
 				count = 0;
 			}
 			udf_write_aext(table, &oepos, eloc, elen, 1);
-		}
-		else if (eloc.logicalBlockNum == (end + 1))
-		{
-			if ((0x3FFFFFFF - elen) < (count << sb->s_blocksize_bits))
-			{
+		} else if (eloc.logicalBlockNum == (end + 1)) {
+			if ((0x3FFFFFFF - elen) < (count << sb->s_blocksize_bits)) {
 				count -= ((0x3FFFFFFF - elen) >> sb->s_blocksize_bits);
 				end -= ((0x3FFFFFFF - elen) >> sb->s_blocksize_bits);
-				eloc.logicalBlockNum -=
-					((0x3FFFFFFF - elen) >> sb->s_blocksize_bits);
+				eloc.logicalBlockNum -= ((0x3FFFFFFF - elen) >> sb->s_blocksize_bits);
 				elen = (etype << 30) | (0x40000000 - sb->s_blocksize);
-			}
-			else
-			{
+			} else {
 				eloc.logicalBlockNum = start;
-				elen = (etype << 30) |
-					(elen + (count << sb->s_blocksize_bits));
+				elen = (etype << 30) | (elen + (count << sb->s_blocksize_bits));
 				end -= count;
 				count = 0;
 			}
 			udf_write_aext(table, &oepos, eloc, elen, 1);
 		}
 
-		if (epos.bh != oepos.bh)
-		{
+		if (epos.bh != oepos.bh) {
 			i = -1;
 			oepos.block = epos.block;
 			brelse(oepos.bh);
 			get_bh(epos.bh);
 			oepos.bh = epos.bh;
 			oepos.offset = 0;
-		}
-		else
+		} else {
 			oepos.offset = epos.offset;
+		}
 	}
 
-	if (count)
-	{
-		/* NOTE: we CANNOT use udf_add_aext here, as it can try to allocate
-				 a new block, and since we hold the super block lock already
-				 very bad things would happen :)
-
-				 We copy the behavior of udf_add_aext, but instead of
-				 trying to allocate a new block close to the existing one,
-				 we just steal a block from the extent we are trying to add.
-
-				 It would be nice if the blocks were close together, but it
-				 isn't required.
-		*/
+	if (count) {
+		/*
+		 * NOTE: we CANNOT use udf_add_aext here, as it can try to allocate
+		 * a new block, and since we hold the super block lock already
+		 * very bad things would happen :)
+		 *
+		 * We copy the behavior of udf_add_aext, but instead of
+		 * trying to allocate a new block close to the existing one,
+		 * we just steal a block from the extent we are trying to add.
+		 *
+		 * It would be nice if the blocks were close together, but it
+		 * isn't required.
+		 */
 
 		int adsize;
 		short_ad *sad = NULL;
@@ -540,40 +509,35 @@ static void udf_table_free_blocks(struct super_block * sb,
 		elen = EXT_RECORDED_ALLOCATED |
 			(count << sb->s_blocksize_bits);
 
-		if (UDF_I_ALLOCTYPE(table) == ICBTAG_FLAG_AD_SHORT)
+		if (UDF_I_ALLOCTYPE(table) == ICBTAG_FLAG_AD_SHORT) {
 			adsize = sizeof(short_ad);
-		else if (UDF_I_ALLOCTYPE(table) == ICBTAG_FLAG_AD_LONG)
+		} else if (UDF_I_ALLOCTYPE(table) == ICBTAG_FLAG_AD_LONG) {
 			adsize = sizeof(long_ad);
-		else
-		{
+		} else {
 			brelse(oepos.bh);
 			brelse(epos.bh);
 			goto error_return;
 		}
 
-		if (epos.offset + (2 * adsize) > sb->s_blocksize)
-		{
+		if (epos.offset + (2 * adsize) > sb->s_blocksize) {
 			char *sptr, *dptr;
 			int loffset;
-	
+
 			brelse(oepos.bh);
 			oepos = epos;
 
 			/* Steal a block from the extent being free'd */
 			epos.block.logicalBlockNum = eloc.logicalBlockNum;
-			eloc.logicalBlockNum ++;
+			eloc.logicalBlockNum++;
 			elen -= sb->s_blocksize;
 
-			if (!(epos.bh = udf_tread(sb,
-				udf_get_lb_pblock(sb, epos.block, 0))))
-			{
+			if (!(epos.bh = udf_tread(sb, udf_get_lb_pblock(sb, epos.block, 0)))) {
 				brelse(oepos.bh);
 				goto error_return;
 			}
 			aed = (struct allocExtDesc *)(epos.bh->b_data);
 			aed->previousAllocExtLocation = cpu_to_le32(oepos.block.logicalBlockNum);
-			if (epos.offset + adsize > sb->s_blocksize)
-			{
+			if (epos.offset + adsize > sb->s_blocksize) {
 				loffset = epos.offset;
 				aed->lengthAllocDescs = cpu_to_le32(adsize);
 				sptr = UDF_I_DATA(inode) + epos.offset -
@@ -582,73 +546,59 @@ static void udf_table_free_blocks(struct super_block * sb,
 				dptr = epos.bh->b_data + sizeof(struct allocExtDesc);
 				memcpy(dptr, sptr, adsize);
 				epos.offset = sizeof(struct allocExtDesc) + adsize;
-			}
-			else
-			{
+			} else {
 				loffset = epos.offset + adsize;
 				aed->lengthAllocDescs = cpu_to_le32(0);
 				sptr = oepos.bh->b_data + epos.offset;
 				epos.offset = sizeof(struct allocExtDesc);
 
-				if (oepos.bh)
-				{
+				if (oepos.bh) {
 					aed = (struct allocExtDesc *)oepos.bh->b_data;
 					aed->lengthAllocDescs =
 						cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) + adsize);
-				}
-				else
-				{
+				} else {
 					UDF_I_LENALLOC(table) += adsize;
 					mark_inode_dirty(table);
 				}
 			}
 			if (UDF_SB_UDFREV(sb) >= 0x0200)
 				udf_new_tag(epos.bh->b_data, TAG_IDENT_AED, 3, 1,
-					epos.block.logicalBlockNum, sizeof(tag));
+					    epos.block.logicalBlockNum, sizeof(tag));
 			else
 				udf_new_tag(epos.bh->b_data, TAG_IDENT_AED, 2, 1,
-					epos.block.logicalBlockNum, sizeof(tag));
-			switch (UDF_I_ALLOCTYPE(table))
-			{
+					    epos.block.logicalBlockNum, sizeof(tag));
+
+			switch (UDF_I_ALLOCTYPE(table)) {
 				case ICBTAG_FLAG_AD_SHORT:
-				{
 					sad = (short_ad *)sptr;
 					sad->extLength = cpu_to_le32(
 						EXT_NEXT_EXTENT_ALLOCDECS |
 						sb->s_blocksize);
 					sad->extPosition = cpu_to_le32(epos.block.logicalBlockNum);
 					break;
-				}
 				case ICBTAG_FLAG_AD_LONG:
-				{
 					lad = (long_ad *)sptr;
 					lad->extLength = cpu_to_le32(
 						EXT_NEXT_EXTENT_ALLOCDECS |
 						sb->s_blocksize);
 					lad->extLocation = cpu_to_lelb(epos.block);
 					break;
-				}
 			}
-			if (oepos.bh)
-			{
+			if (oepos.bh) {
 				udf_update_tag(oepos.bh->b_data, loffset);
 				mark_buffer_dirty(oepos.bh);
-			}
-			else
+			} else {
 				mark_inode_dirty(table);
+			}
 		}
 
-		if (elen) /* It's possible that stealing the block emptied the extent */
-		{
+		if (elen) { /* It's possible that stealing the block emptied the extent */
 			udf_write_aext(table, &epos, eloc, elen, 1);
 
-			if (!epos.bh)
-			{
+			if (!epos.bh) {
 				UDF_I_LENALLOC(table) += adsize;
 				mark_inode_dirty(table);
-			}
-			else
-			{
+			} else {
 				aed = (struct allocExtDesc *)epos.bh->b_data;
 				aed->lengthAllocDescs =
 					cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) + adsize);
@@ -668,9 +618,10 @@ error_return:
 }
 
 static int udf_table_prealloc_blocks(struct super_block * sb,
-	struct inode * inode,
-	struct inode *table, uint16_t partition, uint32_t first_block,
-	uint32_t block_count)
+				     struct inode * inode,
+				     struct inode *table, uint16_t partition,
+				     uint32_t first_block,
+				     uint32_t block_count)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	int alloc_count = 0;
@@ -695,38 +646,33 @@ static int udf_table_prealloc_blocks(struct super_block * sb,
 	epos.bh = NULL;
 	eloc.logicalBlockNum = 0xFFFFFFFF;
 
-	while (first_block != eloc.logicalBlockNum && (etype =
-		udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1)
-	{
+	while (first_block != eloc.logicalBlockNum &&
+	       (etype = udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1) {
 		udf_debug("eloc=%d, elen=%d, first_block=%d\n",
-			eloc.logicalBlockNum, elen, first_block);
+			  eloc.logicalBlockNum, elen, first_block);
 		; /* empty loop body */
 	}
 
-	if (first_block == eloc.logicalBlockNum)
-	{
+	if (first_block == eloc.logicalBlockNum) {
 		epos.offset -= adsize;
-
 		alloc_count = (elen >> sb->s_blocksize_bits);
-		if (inode && DQUOT_PREALLOC_BLOCK(inode, alloc_count > block_count ? block_count : alloc_count))
+		if (inode && DQUOT_PREALLOC_BLOCK(inode, alloc_count > block_count ? block_count : alloc_count)) {
 			alloc_count = 0;
-		else if (alloc_count > block_count)
-		{
+		} else if (alloc_count > block_count) {
 			alloc_count = block_count;
 			eloc.logicalBlockNum += alloc_count;
 			elen -= (alloc_count << sb->s_blocksize_bits);
 			udf_write_aext(table, &epos, eloc, (etype << 30) | elen, 1);
-		}
-		else
+		} else {
 			udf_delete_aext(table, epos, eloc, (etype << 30) | elen);
-	}
-	else
+		}
+	} else {
 		alloc_count = 0;
+	}
 
 	brelse(epos.bh);
 
-	if (alloc_count && UDF_SB_LVIDBH(sb))
-	{
+	if (alloc_count && UDF_SB_LVIDBH(sb)) {
 		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
 			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition])-alloc_count);
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
@@ -737,8 +683,9 @@ static int udf_table_prealloc_blocks(struct super_block * sb,
 }
 
 static int udf_table_new_block(struct super_block * sb,
-	struct inode * inode,
-	struct inode *table, uint16_t partition, uint32_t goal, int *err)
+			       struct inode * inode,
+			       struct inode *table, uint16_t partition,
+			       uint32_t goal, int *err)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	uint32_t spread = 0xFFFFFFFF, nspread = 0xFFFFFFFF;
@@ -770,25 +717,21 @@ static int udf_table_new_block(struct super_block * sb,
 	epos.block = UDF_I_LOCATION(table);
 	epos.bh = goal_epos.bh = NULL;
 
-	while (spread && (etype =
-		udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1)
-	{
-		if (goal >= eloc.logicalBlockNum)
-		{
+	while (spread &&
+	       (etype = udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1) {
+		if (goal >= eloc.logicalBlockNum) {
 			if (goal < eloc.logicalBlockNum + (elen >> sb->s_blocksize_bits))
 				nspread = 0;
 			else
 				nspread = goal - eloc.logicalBlockNum -
 					(elen >> sb->s_blocksize_bits);
-		}
-		else
+		} else {
 			nspread = eloc.logicalBlockNum - goal;
+		}
 
-		if (nspread < spread)
-		{
+		if (nspread < spread) {
 			spread = nspread;
-			if (goal_epos.bh != epos.bh)
-			{
+			if (goal_epos.bh != epos.bh) {
 				brelse(goal_epos.bh);
 				goal_epos.bh = epos.bh;
 				get_bh(goal_epos.bh);
@@ -802,8 +745,7 @@ static int udf_table_new_block(struct super_block * sb,
 
 	brelse(epos.bh);
 
-	if (spread == 0xFFFFFFFF)
-	{
+	if (spread == 0xFFFFFFFF) {
 		brelse(goal_epos.bh);
 		mutex_unlock(&sbi->s_alloc_mutex);
 		return 0;
@@ -815,11 +757,10 @@ static int udf_table_new_block(struct super_block * sb,
 	/* This works, but very poorly.... */
 
 	newblock = goal_eloc.logicalBlockNum;
-	goal_eloc.logicalBlockNum ++;
+	goal_eloc.logicalBlockNum++;
 	goal_elen -= sb->s_blocksize;
 
-	if (inode && DQUOT_ALLOC_BLOCK(inode, 1))
-	{
+	if (inode && DQUOT_ALLOC_BLOCK(inode, 1)) {
 		brelse(goal_epos.bh);
 		mutex_unlock(&sbi->s_alloc_mutex);
 		*err = -EDQUOT;
@@ -832,8 +773,7 @@ static int udf_table_new_block(struct super_block * sb,
 		udf_delete_aext(table, goal_epos, goal_eloc, goal_elen);
 	brelse(goal_epos.bh);
 
-	if (UDF_SB_LVIDBH(sb))
-	{
+	if (UDF_SB_LVIDBH(sb)) {
 		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
 			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition])-1);
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
@@ -846,104 +786,83 @@ static int udf_table_new_block(struct super_block * sb,
 }
 
 inline void udf_free_blocks(struct super_block * sb,
-	struct inode * inode,
-	kernel_lb_addr bloc, uint32_t offset, uint32_t count)
+			    struct inode * inode,
+			    kernel_lb_addr bloc, uint32_t offset,
+			    uint32_t count)
 {
 	uint16_t partition = bloc.partitionReferenceNum;
 
-	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP)
-	{
+	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		return udf_bitmap_free_blocks(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_bitmap,
-			bloc, offset, count);
-	}
-	else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_TABLE)
-	{
+					      UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_bitmap,
+					      bloc, offset, count);
+	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_TABLE) {
 		return udf_table_free_blocks(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_table,
-			bloc, offset, count);
-	}
-	else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP)
-	{
+					     UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_table,
+					     bloc, offset, count);
+	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP) {
 		return udf_bitmap_free_blocks(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_bitmap,
-			bloc, offset, count);
-	}
-	else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE)
-	{
+					      UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_bitmap,
+					      bloc, offset, count);
+	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE) {
 		return udf_table_free_blocks(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_table,
-			bloc, offset, count);
-	}
-	else
+					     UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_table,
+					     bloc, offset, count);
+	} else {
 		return;
+	}
 }
 
 inline int udf_prealloc_blocks(struct super_block * sb,
-	struct inode * inode,
-	uint16_t partition, uint32_t first_block, uint32_t block_count)
+			       struct inode * inode,
+			       uint16_t partition, uint32_t first_block,
+			       uint32_t block_count)
 {
-	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP)
-	{
+	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		return udf_bitmap_prealloc_blocks(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_bitmap,
-			partition, first_block, block_count);
-	}
-	else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_TABLE)
-	{
+						  UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_bitmap,
+						  partition, first_block, block_count);
+	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_TABLE) {
 		return udf_table_prealloc_blocks(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_table,
-			partition, first_block, block_count);
-	}
-	else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP)
-	{
+						 UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_table,
+						 partition, first_block, block_count);
+	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP) {
 		return udf_bitmap_prealloc_blocks(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_bitmap,
-			partition, first_block, block_count);
-	}
-	else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE)
-	{
+						  UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_bitmap,
+						  partition, first_block, block_count);
+	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE) {
 		return udf_table_prealloc_blocks(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_table,
-			partition, first_block, block_count);
-	}
-	else
+						 UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_table,
+						 partition, first_block, block_count);
+	} else {
 		return 0;
+	}
 }
 
 inline int udf_new_block(struct super_block * sb,
-	struct inode * inode,
-	uint16_t partition, uint32_t goal, int *err)
+			 struct inode * inode,
+			 uint16_t partition, uint32_t goal, int *err)
 {
 	int ret;
 
-	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP)
-	{
+	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		ret = udf_bitmap_new_block(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_bitmap,
-			partition, goal, err);
+					   UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_bitmap,
+					   partition, goal, err);
 		return ret;
-	}
-	else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_TABLE)
-	{
+	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_TABLE) {
 		return udf_table_new_block(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_table,
-			partition, goal, err);
-	}
-	else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP)
-	{
+					   UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_table,
+					   partition, goal, err);
+	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP) {
 		return udf_bitmap_new_block(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_bitmap,
-			partition, goal, err);
-	}
-	else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE)
-	{
+					    UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_bitmap,
+					    partition, goal, err);
+	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE) {
 		return udf_table_new_block(sb, inode,
-			UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_table,
-			partition, goal, err);
-	}
-	else
-	{
+					   UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_table,
+					   partition, goal, err);
+	} else {
 		*err = -EIO;
 		return 0;
 	}
diff --git a/fs/udf/crc.c b/fs/udf/crc.c
diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index e45f86b..7ccd685 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -82,14 +82,12 @@ int udf_readdir(struct file *filp, void *dirent, filldir_t filldir)
 
 	lock_kernel();
 
-	if ( filp->f_pos == 0 ) 
-	{
-		if (filldir(dirent, ".", 1, filp->f_pos, dir->i_ino, DT_DIR) < 0)
-		{
+	if (filp->f_pos == 0) {
+		if (filldir(dirent, ".", 1, filp->f_pos, dir->i_ino, DT_DIR) < 0) {
 			unlock_kernel();
 			return 0;
 		}
-		filp->f_pos ++;
+		filp->f_pos++;
 	}
 
 	result = do_udf_readdir(dir, filp, filldir, dirent);
@@ -97,8 +95,8 @@ int udf_readdir(struct file *filp, void *dirent, filldir_t filldir)
  	return result;
 }
 
-static int 
-do_udf_readdir(struct inode * dir, struct file *filp, filldir_t filldir, void *dirent)
+static int do_udf_readdir(struct inode * dir, struct file *filp,
+			  filldir_t filldir, void *dirent)
 {
 	struct udf_fileident_bh fibh;
 	struct fileIdentDesc *fi=NULL;
@@ -117,7 +115,7 @@ do_udf_readdir(struct inode * dir, struct file *filp, filldir_t filldir, void *d
 	sector_t offset;
 	int i, num;
 	unsigned int dt_type;
-	struct extent_position epos = { NULL, 0, {0, 0}};
+	struct extent_position epos = {};
 
 	if (nf_pos >= size)
 		return 0;
@@ -126,35 +124,30 @@ do_udf_readdir(struct inode * dir, struct file *filp, filldir_t filldir, void *d
 		nf_pos = (udf_ext0_offset(dir) >> 2);
 
 	fibh.soffset = fibh.eoffset = (nf_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		fibh.sbh = fibh.ebh = NULL;
-	else if (inode_bmap(dir, nf_pos >> (dir->i_sb->s_blocksize_bits - 2),
-		&epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30))
-	{
+	} else if (inode_bmap(dir, nf_pos >> (dir->i_sb->s_blocksize_bits - 2),
+			      &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
-		if ((++offset << dir->i_sb->s_blocksize_bits) < elen)
-		{
+		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
 			else if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_LONG)
 				epos.offset -= sizeof(long_ad);
-		}
-		else
+		} else {
 			offset = 0;
+		}
 
-		if (!(fibh.sbh = fibh.ebh = udf_tread(dir->i_sb, block)))
-		{
+		if (!(fibh.sbh = fibh.ebh = udf_tread(dir->i_sb, block))) {
 			brelse(epos.bh);
 			return -EIO;
 		}
-	
-		if (!(offset & ((16 >> (dir->i_sb->s_blocksize_bits - 9))-1)))
-		{
+
+		if (!(offset & ((16 >> (dir->i_sb->s_blocksize_bits - 9)) - 1))) {
 			i = 16 >> (dir->i_sb->s_blocksize_bits - 9);
-			if (i+offset > (elen >> dir->i_sb->s_blocksize_bits))
+			if (i + offset > (elen >> dir->i_sb->s_blocksize_bits))
 				i = (elen >> dir->i_sb->s_blocksize_bits)-offset;
-			for (num=0; i>0; i--)
-			{
+			for (num = 0; i > 0; i--) {
 				block = udf_get_lb_pblock(dir->i_sb, eloc, offset+i);
 				tmp = udf_tgetblk(dir->i_sb, block);
 				if (tmp && !buffer_uptodate(tmp) && !buffer_locked(tmp))
@@ -162,28 +155,22 @@ do_udf_readdir(struct inode * dir, struct file *filp, filldir_t filldir, void *d
 				else
 					brelse(tmp);
 			}
-			if (num)
-			{
+			if (num) {
 				ll_rw_block(READA, num, bha);
-				for (i=0; i<num; i++)
+				for (i = 0; i < num; i++)
 					brelse(bha[i]);
 			}
 		}
-	}
-	else
-	{
+	} else {
 		brelse(epos.bh);
 		return -ENOENT;
 	}
 
-	while ( nf_pos < size )
-	{
+	while (nf_pos < size) {
 		filp->f_pos = nf_pos + 1;
 
 		fi = udf_fileident_read(dir, &nf_pos, &fibh, &cfi, &epos, &eloc, &elen, &offset);
-
-		if (!fi)
-		{
+		if (!fi) {
 			if (fibh.sbh != fibh.ebh)
 				brelse(fibh.ebh);
 			brelse(fibh.sbh);
@@ -194,45 +181,38 @@ do_udf_readdir(struct inode * dir, struct file *filp, filldir_t filldir, void *d
 		liu = le16_to_cpu(cfi.lengthOfImpUse);
 		lfi = cfi.lengthFileIdent;
 
-		if (fibh.sbh == fibh.ebh)
+		if (fibh.sbh == fibh.ebh) {
 			nameptr = fi->fileIdent + liu;
-		else
-		{
+		} else {
 			int poffset;	/* Unpaded ending offset */
 
 			poffset = fibh.soffset + sizeof(struct fileIdentDesc) + liu + lfi;
 
-			if (poffset >= lfi)
+			if (poffset >= lfi) {
 				nameptr = (char *)(fibh.ebh->b_data + poffset - lfi);
-			else
-			{
+			} else {
 				nameptr = fname;
 				memcpy(nameptr, fi->fileIdent + liu, lfi - poffset);
 				memcpy(nameptr + lfi - poffset, fibh.ebh->b_data, poffset);
 			}
 		}
 
-		if ( (cfi.fileCharacteristics & FID_FILE_CHAR_DELETED) != 0 )
-		{
-			if ( !UDF_QUERY_FLAG(dir->i_sb, UDF_FLAG_UNDELETE) )
+		if ((cfi.fileCharacteristics & FID_FILE_CHAR_DELETED) != 0) {
+			if (!UDF_QUERY_FLAG(dir->i_sb, UDF_FLAG_UNDELETE))
 				continue;
 		}
-		
-		if ( (cfi.fileCharacteristics & FID_FILE_CHAR_HIDDEN) != 0 )
-		{
-			if ( !UDF_QUERY_FLAG(dir->i_sb, UDF_FLAG_UNHIDE) )
+
+		if ((cfi.fileCharacteristics & FID_FILE_CHAR_HIDDEN) != 0) {
+			if (!UDF_QUERY_FLAG(dir->i_sb, UDF_FLAG_UNHIDE))
 				continue;
 		}
 
-		if ( cfi.fileCharacteristics & FID_FILE_CHAR_PARENT )
-		{
+		if (cfi.fileCharacteristics & FID_FILE_CHAR_PARENT) {
 			iblock = parent_ino(filp->f_path.dentry);
 			flen = 2;
 			memcpy(fname, "..", flen);
 			dt_type = DT_DIR;
-		}
-		else
-		{
+		} else {
 			kernel_lb_addr tloc = lelb_to_cpu(cfi.icb.extLocation);
 
 			iblock = udf_get_lb_pblock(dir->i_sb, tloc, 0);
@@ -240,10 +220,8 @@ do_udf_readdir(struct inode * dir, struct file *filp, filldir_t filldir, void *d
 			dt_type = DT_UNKNOWN;
 		}
 
-		if (flen)
-		{
-			if (filldir(dirent, fname, flen, filp->f_pos, iblock, dt_type) < 0)
-			{
+		if (flen) {
+			if (filldir(dirent, fname, flen, filp->f_pos, iblock, dt_type) < 0) {
 				if (fibh.sbh != fibh.ebh)
 					brelse(fibh.ebh);
 				brelse(fibh.sbh);
diff --git a/fs/udf/directory.c b/fs/udf/directory.c
index 198caa3..9a89ba5 100644
--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -19,10 +19,9 @@
 #include <linux/buffer_head.h>
 
 #if 0
-static uint8_t *
-udf_filead_read(struct inode *dir, uint8_t *tmpad, uint8_t ad_size,
-		kernel_lb_addr fe_loc, int *pos, int *offset,
-		struct buffer_head **bh, int *error)
+static uint8_t * udf_filead_read(struct inode *dir, uint8_t *tmpad, uint8_t ad_size,
+				 kernel_lb_addr fe_loc, int *pos, int *offset,
+				 struct buffer_head **bh, int *error)
 {
 	int loffset = *offset;
 	int block;
@@ -34,24 +33,20 @@ udf_filead_read(struct inode *dir, uint8_t *tmpad, uint8_t ad_size,
 	ad = (uint8_t *)(*bh)->b_data + *offset;
 	*offset += ad_size;
 
-	if (!ad)
-	{
+	if (!ad) {
 		brelse(*bh);
 		*error = 1;
 		return NULL;
 	}
 
-	if (*offset == dir->i_sb->s_blocksize)
-	{
+	if (*offset == dir->i_sb->s_blocksize) {
 		brelse(*bh);
 		block = udf_get_lb_pblock(dir->i_sb, fe_loc, ++*pos);
 		if (!block)
 			return NULL;
 		if (!(*bh = udf_tread(dir->i_sb, block)))
 			return NULL;
-	}
-	else if (*offset > dir->i_sb->s_blocksize)
-	{
+	} else if (*offset > dir->i_sb->s_blocksize) {
 		ad = tmpad;
 
 		remainder = dir->i_sb->s_blocksize - loffset;
@@ -67,17 +62,17 @@ udf_filead_read(struct inode *dir, uint8_t *tmpad, uint8_t ad_size,
 		memcpy((uint8_t *)ad + remainder, (*bh)->b_data, ad_size - remainder);
 		*offset = ad_size - remainder;
 	}
+
 	return ad;
 }
 #endif
 
-struct fileIdentDesc *
-udf_fileident_read(struct inode *dir, loff_t *nf_pos,
-	struct udf_fileident_bh *fibh,
-	struct fileIdentDesc *cfi,
-	struct extent_position *epos,
-	kernel_lb_addr *eloc, uint32_t *elen,
-	sector_t *offset)
+struct fileIdentDesc * udf_fileident_read(struct inode *dir, loff_t *nf_pos,
+					  struct udf_fileident_bh *fibh,
+					  struct fileIdentDesc *cfi,
+					  struct extent_position *epos,
+					  kernel_lb_addr *eloc, uint32_t *elen,
+					  sector_t *offset)
 {
 	struct fileIdentDesc *fi;
 	int i, num, block;
@@ -85,14 +80,12 @@ udf_fileident_read(struct inode *dir, loff_t *nf_pos,
 
 	fibh->soffset = fibh->eoffset;
 
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
-	{
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		fi = udf_get_fileident(UDF_I_DATA(dir) -
-			(UDF_I_EFE(dir) ?
-				sizeof(struct extendedFileEntry) :
-				sizeof(struct fileEntry)),
-			dir->i_sb->s_blocksize, &(fibh->eoffset));
-
+				       (UDF_I_EFE(dir) ?
+					sizeof(struct extendedFileEntry) :
+					sizeof(struct fileEntry)),
+				       dir->i_sb->s_blocksize, &(fibh->eoffset));
 		if (!fi)
 			return NULL;
 
@@ -103,17 +96,16 @@ udf_fileident_read(struct inode *dir, loff_t *nf_pos,
 		return fi;
 	}
 
-	if (fibh->eoffset == dir->i_sb->s_blocksize)
-	{
+	if (fibh->eoffset == dir->i_sb->s_blocksize) {
 		int lextoffset = epos->offset;
 
 		if (udf_next_aext(dir, epos, eloc, elen, 1) !=
-			(EXT_RECORDED_ALLOCATED >> 30))
+		    (EXT_RECORDED_ALLOCATED >> 30))
 			return NULL;
 
 		block = udf_get_lb_pblock(dir->i_sb, *eloc, *offset);
 
-		(*offset) ++;
+		(*offset)++;
 
 		if ((*offset << dir->i_sb->s_blocksize_bits) >= *elen)
 			*offset = 0;
@@ -125,13 +117,11 @@ udf_fileident_read(struct inode *dir, loff_t *nf_pos,
 			return NULL;
 		fibh->soffset = fibh->eoffset = 0;
 
-		if (!(*offset & ((16 >> (dir->i_sb->s_blocksize_bits - 9))-1)))
-		{
+		if (!(*offset & ((16 >> (dir->i_sb->s_blocksize_bits - 9)) - 1))) {
 			i = 16 >> (dir->i_sb->s_blocksize_bits - 9);
-			if (i+*offset > (*elen >> dir->i_sb->s_blocksize_bits))
+			if (i + *offset > (*elen >> dir->i_sb->s_blocksize_bits))
 				i = (*elen >> dir->i_sb->s_blocksize_bits)-*offset;
-			for (num=0; i>0; i--)
-			{
+			for (num = 0; i > 0; i--) {
 				block = udf_get_lb_pblock(dir->i_sb, *eloc, *offset+i);
 				tmp = udf_tgetblk(dir->i_sb, block);
 				if (tmp && !buffer_uptodate(tmp) && !buffer_locked(tmp))
@@ -139,43 +129,37 @@ udf_fileident_read(struct inode *dir, loff_t *nf_pos,
 				else
 					brelse(tmp);
 			}
-			if (num)
-			{
+			if (num) {
 				ll_rw_block(READA, num, bha);
-				for (i=0; i<num; i++)
+				for (i = 0; i < num; i++)
 					brelse(bha[i]);
 			}
 		}
-	}
-	else if (fibh->sbh != fibh->ebh)
-	{
+	} else if (fibh->sbh != fibh->ebh) {
 		brelse(fibh->sbh);
 		fibh->sbh = fibh->ebh;
 	}
 
 	fi = udf_get_fileident(fibh->sbh->b_data, dir->i_sb->s_blocksize,
-		&(fibh->eoffset));
+			       &(fibh->eoffset));
 
 	if (!fi)
 		return NULL;
 
 	*nf_pos += ((fibh->eoffset - fibh->soffset) >> 2);
 
-	if (fibh->eoffset <= dir->i_sb->s_blocksize)
-	{
+	if (fibh->eoffset <= dir->i_sb->s_blocksize) {
 		memcpy((uint8_t *)cfi, (uint8_t *)fi, sizeof(struct fileIdentDesc));
-	}
-	else if (fibh->eoffset > dir->i_sb->s_blocksize)
-	{
+	} else if (fibh->eoffset > dir->i_sb->s_blocksize) {
 		int lextoffset = epos->offset;
 
 		if (udf_next_aext(dir, epos, eloc, elen, 1) !=
-			(EXT_RECORDED_ALLOCATED >> 30))
+		    (EXT_RECORDED_ALLOCATED >> 30))
 			return NULL;
 
 		block = udf_get_lb_pblock(dir->i_sb, *eloc, *offset);
 
-		(*offset) ++;
+		(*offset)++;
 
 		if ((*offset << dir->i_sb->s_blocksize_bits) >= *elen)
 			*offset = 0;
@@ -188,62 +172,58 @@ udf_fileident_read(struct inode *dir, loff_t *nf_pos,
 		if (!(fibh->ebh = udf_tread(dir->i_sb, block)))
 			return NULL;
 
-		if (sizeof(struct fileIdentDesc) > - fibh->soffset)
-		{
+		if (sizeof(struct fileIdentDesc) > - fibh->soffset) {
 			int fi_len;
 
 			memcpy((uint8_t *)cfi, (uint8_t *)fi, - fibh->soffset);
 			memcpy((uint8_t *)cfi - fibh->soffset, fibh->ebh->b_data,
-				sizeof(struct fileIdentDesc) + fibh->soffset);
+			       sizeof(struct fileIdentDesc) + fibh->soffset);
 
 			fi_len = (sizeof(struct fileIdentDesc) + cfi->lengthFileIdent +
-				le16_to_cpu(cfi->lengthOfImpUse) + 3) & ~3;
+				  le16_to_cpu(cfi->lengthOfImpUse) + 3) & ~3;
 
 			*nf_pos += ((fi_len - (fibh->eoffset - fibh->soffset)) >> 2);
 			fibh->eoffset = fibh->soffset + fi_len;
-		}
-		else
-		{
+		} else {
 			memcpy((uint8_t *)cfi, (uint8_t *)fi, sizeof(struct fileIdentDesc));
 		}
 	}
+
 	return fi;
 }
 
-struct fileIdentDesc * 
-udf_get_fileident(void * buffer, int bufsize, int * offset)
+struct fileIdentDesc * udf_get_fileident(void * buffer, int bufsize, int * offset)
 {
 	struct fileIdentDesc *fi;
 	int lengthThisIdent;
 	uint8_t * ptr;
 	int padlen;
 
-	if ( (!buffer) || (!offset) ) {
+	if (!buffer || !offset) {
 		udf_debug("invalidparms\n, buffer=%p, offset=%p\n", buffer, offset);
 		return NULL;
 	}
 
 	ptr = buffer;
 
-	if ( (*offset > 0) && (*offset < bufsize) ) {
+	if (*offset > 0 && *offset < bufsize) {
 		ptr += *offset;
 	}
-	fi=(struct fileIdentDesc *)ptr;
-	if (le16_to_cpu(fi->descTag.tagIdent) != TAG_IDENT_FID)
-	{
+	fi = (struct fileIdentDesc *)ptr;
+	if (le16_to_cpu(fi->descTag.tagIdent) != TAG_IDENT_FID) {
 		udf_debug("0x%x != TAG_IDENT_FID\n",
-			le16_to_cpu(fi->descTag.tagIdent));
+			  le16_to_cpu(fi->descTag.tagIdent));
 		udf_debug("offset: %u sizeof: %lu bufsize: %u\n",
-			*offset, (unsigned long)sizeof(struct fileIdentDesc), bufsize);
+			  *offset, (unsigned long)sizeof(struct fileIdentDesc),
+			  bufsize);
 		return NULL;
 	}
-	if ( (*offset + sizeof(struct fileIdentDesc)) > bufsize )
-	{
+	if ((*offset + sizeof(struct fileIdentDesc)) > bufsize) {
 		lengthThisIdent = sizeof(struct fileIdentDesc);
-	}
-	else
+	} else {
 		lengthThisIdent = sizeof(struct fileIdentDesc) +
 			fi->lengthFileIdent + le16_to_cpu(fi->lengthOfImpUse);
+	}
 
 	/* we need to figure padding, too! */
 	padlen = lengthThisIdent % UDF_NAME_PAD;
@@ -255,32 +235,28 @@ udf_get_fileident(void * buffer, int bufsize, int * offset)
 }
 
 #if 0
-static extent_ad *
-udf_get_fileextent(void * buffer, int bufsize, int * offset)
+static extent_ad * udf_get_fileextent(void * buffer, int bufsize, int * offset)
 {
 	extent_ad * ext;
 	struct fileEntry *fe;
 	uint8_t * ptr;
 
-	if ( (!buffer) || (!offset) )
-	{
+	if (!buffer || !offset) {
 		printk(KERN_ERR "udf: udf_get_fileextent() invalidparms\n");
 		return NULL;
 	}
 
 	fe = (struct fileEntry *)buffer;
 
-	if ( le16_to_cpu(fe->descTag.tagIdent) != TAG_IDENT_FE )
-	{
+	if (le16_to_cpu(fe->descTag.tagIdent) != TAG_IDENT_FE) {
 		udf_debug("0x%x != TAG_IDENT_FE\n",
-			le16_to_cpu(fe->descTag.tagIdent));
+			  le16_to_cpu(fe->descTag.tagIdent));
 		return NULL;
 	}
 
-	ptr=(uint8_t *)(fe->extendedAttr) + le32_to_cpu(fe->lengthExtendedAttr);
+	ptr = (uint8_t *)(fe->extendedAttr) + le32_to_cpu(fe->lengthExtendedAttr);
 
-	if ( (*offset > 0) && (*offset < le32_to_cpu(fe->lengthAllocDescs)) )
-	{
+	if ((*offset > 0) && (*offset < le32_to_cpu(fe->lengthAllocDescs))) {
 		ptr += *offset;
 	}
 
@@ -291,18 +267,16 @@ udf_get_fileextent(void * buffer, int bufsize, int * offset)
 }
 #endif
 
-short_ad *
-udf_get_fileshortad(uint8_t *ptr, int maxoffset, int *offset, int inc)
+short_ad * udf_get_fileshortad(uint8_t *ptr, int maxoffset, int *offset, int inc)
 {
 	short_ad *sa;
 
-	if ( (!ptr) || (!offset) )
-	{
+	if (!ptr || !offset) {
 		printk(KERN_ERR "udf: udf_get_fileshortad() invalidparms\n");
 		return NULL;
 	}
 
-	if ( (*offset < 0) || ((*offset + sizeof(short_ad)) > maxoffset) )
+	if ((*offset < 0) || ((*offset + sizeof(short_ad)) > maxoffset))
 		return NULL;
 	else if ((sa = (short_ad *)ptr)->extLength == 0)
 		return NULL;
@@ -312,18 +286,16 @@ udf_get_fileshortad(uint8_t *ptr, int maxoffset, int *offset, int inc)
 	return sa;
 }
 
-long_ad *
-udf_get_filelongad(uint8_t *ptr, int maxoffset, int * offset, int inc)
+long_ad * udf_get_filelongad(uint8_t *ptr, int maxoffset, int * offset, int inc)
 {
 	long_ad *la;
 
-	if ( (!ptr) || (!offset) ) 
-	{
+	if (!ptr || !offset) {
 		printk(KERN_ERR "udf: udf_get_filelongad() invalidparms\n");
 		return NULL;
 	}
 
-	if ( (*offset < 0) || ((*offset + sizeof(long_ad)) > maxoffset) )
+	if ((*offset < 0) || ((*offset + sizeof(long_ad)) > maxoffset))
 		return NULL;
 	else if ((la = (long_ad *)ptr)->extLength == 0)
 		return NULL;
diff --git a/fs/udf/ecma_167.h b/fs/udf/ecma_167.h
index f81f2eb..c250b0e 100644
--- a/fs/udf/ecma_167.h
+++ b/fs/udf/ecma_167.h
@@ -38,8 +38,7 @@
 #define _ECMA_167_H 1
 
 /* Character set specification (ECMA 167r3 1/7.2.1) */
-typedef struct
-{
+typedef struct {
 	uint8_t		charSetType;
 	uint8_t		charSetInfo[63];
 } __attribute__ ((packed)) charspec;
@@ -58,8 +57,7 @@ typedef struct
 typedef uint8_t		dstring;
 
 /* Timestamp (ECMA 167r3 1/7.3) */
-typedef struct
-{
+typedef struct {
 	__le16		typeAndTimezone;
 	__le16		year;
 	uint8_t		month;
@@ -72,8 +70,7 @@ typedef struct
 	uint8_t		microseconds;
 } __attribute__ ((packed)) timestamp;
 
-typedef struct
-{
+typedef struct {
 	uint16_t	typeAndTimezone;
 	int16_t		year;
 	uint8_t		month;
@@ -94,8 +91,7 @@ typedef struct
 #define TIMESTAMP_TIMEZONE_MASK		0x0FFF
 
 /* Entity identifier (ECMA 167r3 1/7.4) */
-typedef struct
-{
+typedef struct {
 	uint8_t		flags;
 	uint8_t		ident[23];
 	uint8_t		identSuffix[8];
@@ -107,8 +103,7 @@ typedef struct
 
 /* Volume Structure Descriptor (ECMA 167r3 2/9.1) */
 #define VSD_STD_ID_LEN			5
-struct volStructDesc
-{
+struct volStructDesc {
 	uint8_t		structType;
 	uint8_t		stdIdent[VSD_STD_ID_LEN];
 	uint8_t		structVersion;
@@ -127,8 +122,7 @@ struct volStructDesc
 #define VSD_STD_ID_TEA01		"TEA01"	/* (2/9.3) */
 
 /* Beginning Extended Area Descriptor (ECMA 167r3 2/9.2) */
-struct beginningExtendedAreaDesc
-{
+struct beginningExtendedAreaDesc {
 	uint8_t		structType;
 	uint8_t		stdIdent[VSD_STD_ID_LEN];
 	uint8_t		structVersion;
@@ -136,8 +130,7 @@ struct beginningExtendedAreaDesc
 } __attribute__ ((packed));
 
 /* Terminating Extended Area Descriptor (ECMA 167r3 2/9.3) */
-struct terminatingExtendedAreaDesc
-{
+struct terminatingExtendedAreaDesc {
 	uint8_t		structType;
 	uint8_t		stdIdent[VSD_STD_ID_LEN];
 	uint8_t		structVersion;
@@ -145,8 +138,7 @@ struct terminatingExtendedAreaDesc
 } __attribute__ ((packed));
 
 /* Boot Descriptor (ECMA 167r3 2/9.4) */
-struct bootDesc
-{
+struct bootDesc {
 	uint8_t		structType;
 	uint8_t		stdIdent[VSD_STD_ID_LEN];
 	uint8_t		structVersion;
@@ -167,21 +159,18 @@ struct bootDesc
 #define BOOT_FLAGS_ERASE		0x01
 
 /* Extent Descriptor (ECMA 167r3 3/7.1) */
-typedef struct
-{
+typedef struct {
 	__le32		extLength;
 	__le32		extLocation;
 } __attribute__ ((packed)) extent_ad;
 
-typedef struct
-{
+typedef struct {
 	uint32_t	extLength;
 	uint32_t	extLocation;
 } kernel_extent_ad;
 
 /* Descriptor Tag (ECMA 167r3 3/7.2) */
-typedef struct
-{
+typedef struct {
 	__le16		tagIdent;
 	__le16		descVersion;
 	uint8_t		tagChecksum;
@@ -204,18 +193,16 @@ typedef struct
 #define TAG_IDENT_LVID			0x0009
 
 /* NSR Descriptor (ECMA 167r3 3/9.1) */
-struct NSRDesc
-{
+struct NSRDesc {
 	uint8_t		structType;
 	uint8_t		stdIdent[VSD_STD_ID_LEN];
 	uint8_t		structVersion;
 	uint8_t		reserved;
 	uint8_t		structData[2040];
 } __attribute__ ((packed));
-	
+
 /* Primary Volume Descriptor (ECMA 167r3 3/10.1) */
-struct primaryVolDesc
-{
+struct primaryVolDesc {
 	tag		descTag;
 	__le32		volDescSeqNum;
 	__le32		primaryVolDescNum;
@@ -244,8 +231,7 @@ struct primaryVolDesc
 #define PVD_FLAGS_VSID_COMMON		0x0001
 
 /* Anchor Volume Descriptor Pointer (ECMA 167r3 3/10.2) */
-struct anchorVolDescPtr
-{
+struct anchorVolDescPtr {
 	tag		descTag;
 	extent_ad	mainVolDescSeqExt;
 	extent_ad	reserveVolDescSeqExt;
@@ -253,8 +239,7 @@ struct anchorVolDescPtr
 } __attribute__ ((packed));
 
 /* Volume Descriptor Pointer (ECMA 167r3 3/10.3) */
-struct volDescPtr
-{
+struct volDescPtr {
 	tag		descTag;
 	__le32		volDescSeqNum;
 	extent_ad	nextVolDescSeqExt;
@@ -262,8 +247,7 @@ struct volDescPtr
 } __attribute__ ((packed));
 
 /* Implementation Use Volume Descriptor (ECMA 167r3 3/10.4) */
-struct impUseVolDesc
-{
+struct impUseVolDesc {
 	tag		descTag;
 	__le32		volDescSeqNum;
 	regid		impIdent;
@@ -271,8 +255,7 @@ struct impUseVolDesc
 } __attribute__ ((packed));
 
 /* Partition Descriptor (ECMA 167r3 3/10.5) */
-struct partitionDesc
-{
+struct partitionDesc {
 	tag		descTag;
 	__le32		volDescSeqNum;
 	__le16		partitionFlags;
@@ -307,8 +290,7 @@ struct partitionDesc
 #define PD_ACCESS_TYPE_OVERWRITABLE	0x00000004
 
 /* Logical Volume Descriptor (ECMA 167r3 3/10.6) */
-struct logicalVolDesc
-{
+struct logicalVolDesc {
 	tag		descTag;
 	__le32		volDescSeqNum;
 	charspec	descCharSet;
@@ -325,8 +307,7 @@ struct logicalVolDesc
 } __attribute__ ((packed));
 
 /* Generic Partition Map (ECMA 167r3 3/10.7.1) */
-struct genericPartitionMap
-{
+struct genericPartitionMap {
 	uint8_t		partitionMapType;
 	uint8_t		partitionMapLength;
 	uint8_t		partitionMapping[0];
@@ -338,8 +319,7 @@ struct genericPartitionMap
 #define GP_PARTITION_MAP_TYPE_2		0x02
 
 /* Type 1 Partition Map (ECMA 167r3 3/10.7.2) */
-struct genericPartitionMap1
-{
+struct genericPartitionMap1 {
 	uint8_t		partitionMapType;
 	uint8_t		partitionMapLength;
 	__le16		volSeqNum;
@@ -347,16 +327,14 @@ struct genericPartitionMap1
 } __attribute__ ((packed));
 
 /* Type 2 Partition Map (ECMA 167r3 3/10.7.3) */
-struct genericPartitionMap2
-{
+struct genericPartitionMap2 {
 	uint8_t		partitionMapType;
-	uint8_t		partitionMapLength; 
+	uint8_t		partitionMapLength;
 	uint8_t		partitionIdent[62];
 } __attribute__ ((packed));
 
 /* Unallocated Space Descriptor (ECMA 167r3 3/10.8) */
-struct unallocSpaceDesc
-{
+struct unallocSpaceDesc {
 	tag		descTag;
 	__le32		volDescSeqNum;
 	__le32		numAllocDescs;
@@ -364,15 +342,13 @@ struct unallocSpaceDesc
 } __attribute__ ((packed));
 
 /* Terminating Descriptor (ECMA 167r3 3/10.9) */
-struct terminatingDesc
-{
+struct terminatingDesc {
 	tag		descTag;
 	uint8_t		reserved[496];
 } __attribute__ ((packed));
 
 /* Logical Volume Integrity Descriptor (ECMA 167r3 3/10.10) */
-struct logicalVolIntegrityDesc
-{
+struct logicalVolIntegrityDesc {
 	tag		descTag;
 	timestamp	recordingDateAndTime;
 	__le32		integrityType;
@@ -390,52 +366,45 @@ struct logicalVolIntegrityDesc
 #define LVID_INTEGRITY_TYPE_CLOSE	0x00000001
 
 /* Recorded Address (ECMA 167r3 4/7.1) */
-typedef struct 
-{
+typedef struct {
 	__le32		logicalBlockNum;
 	__le16	 	partitionReferenceNum;
 } __attribute__ ((packed)) lb_addr;
 
 /* ... and its in-core analog */
-typedef struct 
-{
+typedef struct {
 	uint32_t		logicalBlockNum;
 	uint16_t	 	partitionReferenceNum;
 } kernel_lb_addr;
 
 /* Short Allocation Descriptor (ECMA 167r3 4/14.14.1) */
-typedef struct
-{
+typedef struct {
         __le32		extLength;
         __le32		extPosition;
 } __attribute__ ((packed)) short_ad;
 
 /* Long Allocation Descriptor (ECMA 167r3 4/14.14.2) */
-typedef struct
-{
+typedef struct {
 	__le32		extLength;
 	lb_addr		extLocation;
 	uint8_t		impUse[6];
 } __attribute__ ((packed)) long_ad;
 
-typedef struct
-{
+typedef struct {
 	uint32_t	extLength;
 	kernel_lb_addr	extLocation;
 	uint8_t		impUse[6];
 } kernel_long_ad;
 
 /* Extended Allocation Descriptor (ECMA 167r3 4/14.14.3) */
-typedef struct
-{
+typedef struct {
 	__le32		extLength;
 	__le32		recordedLength;
 	__le32		informationLength;
 	lb_addr		extLocation;
 } __attribute__ ((packed)) ext_ad;
 
-typedef struct
-{
+typedef struct {
 	uint32_t	extLength;
 	uint32_t	recordedLength;
 	uint32_t	informationLength;
@@ -458,8 +427,7 @@ typedef struct
 #define TAG_IDENT_EFE			0x010A
 
 /* File Set Descriptor (ECMA 167r3 4/14.1) */
-struct fileSetDesc
-{
+struct fileSetDesc {
 	tag		descTag;
 	timestamp	recordingDateAndTime;
 	__le16		interchangeLvl;
@@ -482,8 +450,7 @@ struct fileSetDesc
 } __attribute__ ((packed));
 
 /* Partition Header Descriptor (ECMA 167r3 4/14.3) */
-struct partitionHeaderDesc
-{
+struct partitionHeaderDesc {
 	short_ad	unallocSpaceTable;
 	short_ad	unallocSpaceBitmap;
 	short_ad	partitionIntegrityTable;
@@ -493,8 +460,7 @@ struct partitionHeaderDesc
 } __attribute__ ((packed));
 
 /* File Identifier Descriptor (ECMA 167r3 4/14.4) */
-struct fileIdentDesc
-{
+struct fileIdentDesc {
 	tag		descTag;
 	__le16		fileVersionNum;
 	uint8_t		fileCharacteristics;
@@ -514,16 +480,14 @@ struct fileIdentDesc
 #define FID_FILE_CHAR_METADATA		0x10
 
 /* Allocation Ext Descriptor (ECMA 167r3 4/14.5) */
-struct allocExtDesc
-{
+struct allocExtDesc {
 	tag		descTag;
 	__le32		previousAllocExtLocation;
 	__le32		lengthAllocDescs;
 } __attribute__ ((packed));
 
 /* ICB Tag (ECMA 167r3 4/14.6) */
-typedef struct
-{
+typedef struct {
 	__le32		priorRecordedNumDirectEntries;
 	__le16		strategyType;
 	__le16		strategyParameter;
@@ -576,23 +540,20 @@ typedef struct
 #define ICBTAG_FLAG_STREAM		0x2000
 
 /* Indirect Entry (ECMA 167r3 4/14.7) */
-struct indirectEntry
-{
+struct indirectEntry {
 	tag		descTag;
 	icbtag		icbTag;
 	long_ad		indirectICB;
 } __attribute__ ((packed));
 
 /* Terminal Entry (ECMA 167r3 4/14.8) */
-struct terminalEntry
-{
+struct terminalEntry {
 	tag		descTag;
 	icbtag		icbTag;
 } __attribute__ ((packed));
 
 /* File Entry (ECMA 167r3 4/14.9) */
-struct fileEntry
-{
+struct fileEntry {
 	tag		descTag;
 	icbtag		icbTag;
 	__le32		uid;
@@ -655,16 +616,14 @@ struct fileEntry
 #define FE_RECORD_DISPLAY_ATTR_3	0x03
 
 /* Extended Attribute Header Descriptor (ECMA 167r3 4/14.10.1) */
-struct extendedAttrHeaderDesc
-{
+struct extendedAttrHeaderDesc {
 	tag		descTag;
 	__le32		impAttrLocation;
 	__le32		appAttrLocation;
 } __attribute__ ((packed));
 
 /* Generic Format (ECMA 167r3 4/14.10.2) */
-struct genericFormat
-{
+struct genericFormat {
 	__le32		attrType;
 	uint8_t		attrSubtype;
 	uint8_t		reserved[3];
@@ -673,8 +632,7 @@ struct genericFormat
 } __attribute__ ((packed));
 
 /* Character Set Information (ECMA 167r3 4/14.10.3) */
-struct charSetInfo
-{
+struct charSetInfo {
 	__le32		attrType;
 	uint8_t		attrSubtype;
 	uint8_t		reserved[3];
@@ -685,8 +643,7 @@ struct charSetInfo
 } __attribute__ ((packed));
 
 /* Alternate Permissions (ECMA 167r3 4/14.10.4) */
-struct altPerms
-{
+struct altPerms {
 	__le32		attrType;
 	uint8_t		attrSubtype;
 	uint8_t		reserved[3];
@@ -697,8 +654,7 @@ struct altPerms
 } __attribute__ ((packed));
 
 /* File Times Extended Attribute (ECMA 167r3 4/14.10.5) */
-struct fileTimesExtAttr
-{
+struct fileTimesExtAttr {
 	__le32		attrType;
 	uint8_t		attrSubtype;
 	uint8_t		reserved[3];
@@ -715,8 +671,7 @@ struct fileTimesExtAttr
 #define FTE_BACKUP			0x00000002
 
 /* Information Times Extended Attribute (ECMA 167r3 4/14.10.6) */
-struct infoTimesExtAttr
-{
+struct infoTimesExtAttr {
 	__le32		attrType;
 	uint8_t		attrSubtype;
 	uint8_t		reserved[3];
@@ -727,8 +682,7 @@ struct infoTimesExtAttr
 } __attribute__ ((packed));
 
 /* Device Specification (ECMA 167r3 4/14.10.7) */
-struct deviceSpec
-{
+struct deviceSpec {
 	__le32		attrType;
 	uint8_t		attrSubtype;
 	uint8_t		reserved[3];
@@ -740,8 +694,7 @@ struct deviceSpec
 } __attribute__ ((packed));
 
 /* Implementation Use Extended Attr (ECMA 167r3 4/14.10.8) */
-struct impUseExtAttr
-{
+struct impUseExtAttr {
 	__le32		attrType;
 	uint8_t		attrSubtype;
 	uint8_t		reserved[3];
@@ -752,8 +705,7 @@ struct impUseExtAttr
 } __attribute__ ((packed));
 
 /* Application Use Extended Attribute (ECMA 167r3 4/14.10.9) */
-struct appUseExtAttr
-{
+struct appUseExtAttr {
 	__le32		attrType;
 	uint8_t		attrSubtype;
 	uint8_t		reserved[3];
@@ -773,8 +725,7 @@ struct appUseExtAttr
 
 
 /* Unallocated Space Entry (ECMA 167r3 4/14.11) */
-struct unallocSpaceEntry
-{
+struct unallocSpaceEntry {
 	tag		descTag;
 	icbtag		icbTag;
 	__le32		lengthAllocDescs;
@@ -782,8 +733,7 @@ struct unallocSpaceEntry
 } __attribute__ ((packed));
 
 /* Space Bitmap Descriptor (ECMA 167r3 4/14.12) */
-struct spaceBitmapDesc
-{
+struct spaceBitmapDesc {
 	tag		descTag;
 	__le32		numOfBits;
 	__le32		numOfBytes;
@@ -791,8 +741,7 @@ struct spaceBitmapDesc
 } __attribute__ ((packed));
 
 /* Partition Integrity Entry (ECMA 167r3 4/14.13) */
-struct partitionIntegrityEntry
-{
+struct partitionIntegrityEntry {
 	tag		descTag;
 	icbtag		icbTag;
 	timestamp	recordingDateAndTime;
@@ -815,15 +764,13 @@ struct partitionIntegrityEntry
 /* Extended Allocation Descriptor (ECMA 167r3 4/14.14.3) */
 
 /* Logical Volume Header Descriptor (ECMA 167r3 4/14.15) */
-struct logicalVolHeaderDesc
-{
+struct logicalVolHeaderDesc {
 	__le64		uniqueID;
 	uint8_t		reserved[24];
 } __attribute__ ((packed));
 
 /* Path Component (ECMA 167r3 4/14.16.1) */
-struct pathComponent
-{
+struct pathComponent {
 	uint8_t		componentType;
 	uint8_t		lengthComponentIdent;
 	__le16		componentFileVersionNum;
@@ -831,8 +778,7 @@ struct pathComponent
 } __attribute__ ((packed));
 
 /* File Entry (ECMA 167r3 4/14.17) */
-struct extendedFileEntry
-{
+struct extendedFileEntry {
 	tag		descTag;
 	icbtag		icbTag;
 	__le32		uid;
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 51b5764..8b0bc7f 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -55,6 +55,7 @@ static int udf_adinicb_readpage(struct file *file, struct page * page)
 	SetPageUptodate(page);
 	kunmap(page);
 	unlock_page(page);
+
 	return 0;
 }
 
@@ -71,28 +72,33 @@ static int udf_adinicb_writepage(struct page *page, struct writeback_control *wb
 	SetPageUptodate(page);
 	kunmap(page);
 	unlock_page(page);
+
 	return 0;
 }
 
-static int udf_adinicb_prepare_write(struct file *file, struct page *page, unsigned offset, unsigned to)
+static int udf_adinicb_prepare_write(struct file *file, struct page *page,
+				     unsigned offset, unsigned to)
 {
 	kmap(page);
 	return 0;
 }
 
-static int udf_adinicb_commit_write(struct file *file, struct page *page, unsigned offset, unsigned to)
+static int udf_adinicb_commit_write(struct file *file, struct page *page,
+				    unsigned offset, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
 	char *kaddr = page_address(page);
 
 	memcpy(UDF_I_DATA(inode) + UDF_I_LENEATTR(inode) + offset,
-		kaddr + offset, to - offset);
+	       kaddr + offset, to - offset);
 	mark_inode_dirty(inode);
 	SetPageUptodate(page);
 	kunmap(page);
+
 	/* only one page here */
 	if (to > inode->i_size)
 		inode->i_size = to;
+
 	return 0;
 }
 
@@ -105,7 +111,7 @@ const struct address_space_operations udf_adinicb_aops = {
 };
 
 static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
-			      unsigned long nr_segs, loff_t ppos)
+				  unsigned long nr_segs, loff_t ppos)
 {
 	ssize_t retval;
 	struct file *file = iocb->ki_filp;
@@ -113,25 +119,20 @@ static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	int err, pos;
 	size_t count = iocb->ki_left;
 
-	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB)
-	{
+	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB) {
 		if (file->f_flags & O_APPEND)
 			pos = inode->i_size;
 		else
 			pos = ppos;
 
 		if (inode->i_sb->s_blocksize < (udf_file_entry_alloc_offset(inode) +
-			pos + count))
-		{
+						pos + count)) {
 			udf_expand_file_adinicb(inode, pos + count, &err);
-			if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB)
-			{
+			if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB) {
 				udf_debug("udf_expand_adinicb: err=%d\n", err);
 				return err;
 			}
-		}
-		else
-		{
+		} else {
 			if (pos + count > inode->i_size)
 				UDF_I_LENALLOC(inode) = pos + count;
 			else
@@ -140,9 +141,9 @@ static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	}
 
 	retval = generic_file_aio_write(iocb, iov, nr_segs, ppos);
-
 	if (retval > 0)
 		mark_inode_dirty(inode);
+
 	return retval;
 }
 
@@ -180,48 +181,43 @@ static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
  *	July 1, 1997 - Andrew E. Mileski
  *	Written, tested, and released.
  */
-int udf_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-	unsigned long arg)
+int udf_ioctl(struct inode *inode, struct file *filp,
+	      unsigned int cmd, unsigned long arg)
 {
+	long old_block, new_block;
 	int result = -EINVAL;
 
-	if ( file_permission(filp, MAY_READ) != 0 )
-	{
+	if (file_permission(filp, MAY_READ) != 0) {
 		udf_debug("no permission to access inode %lu\n",
-						inode->i_ino);
+			  inode->i_ino);
 		return -EPERM;
 	}
 
-	if ( !arg )
-	{
+	if (!arg) {
 		udf_debug("invalid argument to udf_ioctl\n");
 		return -EINVAL;
 	}
 
-	switch (cmd)
-	{
+	switch (cmd) {
 		case UDF_GETVOLIDENT:
 			return copy_to_user((char __user *)arg,
-				UDF_SB_VOLIDENT(inode->i_sb), 32) ? -EFAULT : 0;
+					    UDF_SB_VOLIDENT(inode->i_sb), 32) ? -EFAULT : 0;
 		case UDF_RELOCATE_BLOCKS:
-		{
-			long old, new;
-
-			if (!capable(CAP_SYS_ADMIN)) return -EACCES;
-			if (get_user(old, (long __user *)arg)) return -EFAULT;
+			if (!capable(CAP_SYS_ADMIN))
+				return -EACCES;
+			if (get_user(old_block, (long __user *)arg))
+				return -EFAULT;
 			if ((result = udf_relocate_blocks(inode->i_sb,
-					old, &new)) == 0)
-				result = put_user(new, (long __user *)arg);
-
+							  old_block, &new_block)) == 0)
+				result = put_user(new_block, (long __user *)arg);
 			return result;
-		}
 		case UDF_GETEASIZE:
 			result = put_user(UDF_I_LENEATTR(inode), (int __user *)arg);
 			break;
 
 		case UDF_GETEABLOCK:
 			result = copy_to_user((char __user *)arg, UDF_I_DATA(inode),
-				UDF_I_LENEATTR(inode)) ? -EFAULT : 0;
+					      UDF_I_LENEATTR(inode)) ? -EFAULT : 0;
 			break;
 	}
 
@@ -242,12 +238,12 @@ int udf_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
  */
 static int udf_release_file(struct inode * inode, struct file * filp)
 {
-	if (filp->f_mode & FMODE_WRITE)
-	{
+	if (filp->f_mode & FMODE_WRITE) {
 		lock_kernel();
 		udf_discard_prealloc(inode);
 		unlock_kernel();
 	}
+
 	return 0;
 }
 
diff --git a/fs/udf/fsync.c b/fs/udf/fsync.c
index 6ded93e..6c67300 100644
--- a/fs/udf/fsync.c
+++ b/fs/udf/fsync.c
@@ -32,6 +32,7 @@ static int udf_fsync_inode(struct inode *, int);
 int udf_fsync_file(struct file * file, struct dentry *dentry, int datasync)
 {
 	struct inode *inode = dentry->d_inode;
+
 	return udf_fsync_inode(inode, datasync);
 }
 
@@ -45,6 +46,7 @@ static int udf_fsync_inode(struct inode *inode, int datasync)
 	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
 		return err;
 
-	err |= udf_sync_inode (inode);
+	err |= udf_sync_inode(inode);
+
 	return err ? -EIO : 0;
 }
diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
index 8206983..c022e94 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -50,7 +50,7 @@ void udf_free_inode(struct inode * inode)
 		else
 			UDF_SB_LVIDIU(sb)->numFiles =
 				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles) - 1);
-		
+
 		mark_buffer_dirty(sbi->s_lvidbh);
 	}
 	mutex_unlock(&sbi->s_alloc_mutex);
@@ -68,8 +68,7 @@ struct inode * udf_new_inode (struct inode *dir, int mode, int * err)
 
 	inode = new_inode(sb);
 
-	if (!inode)
-	{
+	if (!inode) {
 		*err = -ENOMEM;
 		return NULL;
 	}
@@ -82,16 +81,14 @@ struct inode * udf_new_inode (struct inode *dir, int mode, int * err)
 	UDF_I_STRAT4096(inode) = 0;
 
 	block = udf_new_block(dir->i_sb, NULL, UDF_I_LOCATION(dir).partitionReferenceNum,
-		start, err);
-	if (*err)
-	{
+			      start, err);
+	if (*err) {
 		iput(inode);
 		return NULL;
 	}
 
 	mutex_lock(&sbi->s_alloc_mutex);
-	if (UDF_SB_LVIDBH(sb))
-	{
+	if (UDF_SB_LVIDBH(sb)) {
 		struct logicalVolHeaderDesc *lvhd;
 		uint64_t uniqueID;
 		lvhd = (struct logicalVolHeaderDesc *)(UDF_SB_LVID(sb)->logicalVolContentsUse);
@@ -109,14 +106,13 @@ struct inode * udf_new_inode (struct inode *dir, int mode, int * err)
 	}
 	inode->i_mode = mode;
 	inode->i_uid = current->fsuid;
-	if (dir->i_mode & S_ISGID)
-	{
+	if (dir->i_mode & S_ISGID) {
 		inode->i_gid = dir->i_gid;
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
-	}
-	else
+	} else {
 		inode->i_gid = current->fsgid;
+	}
 
 	UDF_I_LOCATION(inode).logicalBlockNum = block;
 	UDF_I_LOCATION(inode).partitionReferenceNum = UDF_I_LOCATION(dir).partitionReferenceNum;
@@ -125,17 +121,20 @@ struct inode * udf_new_inode (struct inode *dir, int mode, int * err)
 	UDF_I_LENEATTR(inode) = 0;
 	UDF_I_LENALLOC(inode) = 0;
 	UDF_I_USE(inode) = 0;
-	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_EXTENDED_FE))
-	{
+	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_EXTENDED_FE)) {
 		UDF_I_EFE(inode) = 1;
 		UDF_UPDATE_UDFREV(inode->i_sb, UDF_VERS_USE_EXTENDED_FE);
 		UDF_I_DATA(inode) = kzalloc(inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry), GFP_KERNEL);
-	}
-	else
-	{
+	} else {
 		UDF_I_EFE(inode) = 0;
 		UDF_I_DATA(inode) = kzalloc(inode->i_sb->s_blocksize - sizeof(struct fileEntry), GFP_KERNEL);
 	}
+	if (!UDF_I_DATA(inode)) {
+		iput(inode);
+		*err = -ENOMEM;
+		mutex_unlock(&sbi->s_alloc_mutex);
+		return NULL;
+	}
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_AD_IN_ICB))
 		UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_IN_ICB;
 	else if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
@@ -148,8 +147,7 @@ struct inode * udf_new_inode (struct inode *dir, int mode, int * err)
 	mark_inode_dirty(inode);
 	mutex_unlock(&sbi->s_alloc_mutex);
 
-	if (DQUOT_ALLOC_INODE(inode))
-	{
+	if (DQUOT_ALLOC_INODE(inode)) {
 		DQUOT_DROP(inode);
 		inode->i_flags |= S_NOQUOTA;
 		inode->i_nlink = 0;
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index c846155..7d8c451 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -49,19 +49,20 @@ MODULE_LICENSE("GPL");
 static mode_t udf_convert_permissions(struct fileEntry *);
 static int udf_update_inode(struct inode *, int);
 static void udf_fill_inode(struct inode *, struct buffer_head *);
+static int udf_alloc_i_data(struct inode *inode, size_t size);
 static struct buffer_head *inode_getblk(struct inode *, sector_t, int *,
-	long *, int *);
+					long *, int *);
 static int8_t udf_insert_aext(struct inode *, struct extent_position,
-	kernel_lb_addr, uint32_t);
+			      kernel_lb_addr, uint32_t);
 static void udf_split_extents(struct inode *, int *, int, int,
-	kernel_long_ad [EXTENT_MERGE_SIZE], int *);
+			      kernel_long_ad [EXTENT_MERGE_SIZE], int *);
 static void udf_prealloc_extents(struct inode *, int, int,
-	 kernel_long_ad [EXTENT_MERGE_SIZE], int *);
+				 kernel_long_ad [EXTENT_MERGE_SIZE], int *);
 static void udf_merge_extents(struct inode *,
-	 kernel_long_ad [EXTENT_MERGE_SIZE], int *);
+			      kernel_long_ad [EXTENT_MERGE_SIZE], int *);
 static void udf_update_extents(struct inode *,
-	kernel_long_ad [EXTENT_MERGE_SIZE], int, int,
-	struct extent_position *);
+			       kernel_long_ad [EXTENT_MERGE_SIZE], int, int,
+			       struct extent_position *);
 static int udf_get_block(struct inode *, sector_t, struct buffer_head *, int);
 
 /*
@@ -96,6 +97,7 @@ void udf_delete_inode(struct inode * inode)
 
 	unlock_kernel();
 	return;
+
 no_delete:
 	clear_inode(inode);
 }
@@ -153,8 +155,7 @@ void udf_expand_file_adinicb(struct inode * inode, int newsize, int * err)
 	/* from now on we have normal address_space methods */
 	inode->i_data.a_ops = &udf_aops;
 
-	if (!UDF_I_LENALLOC(inode))
-	{
+	if (!UDF_I_LENALLOC(inode)) {
 		if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
 			UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_SHORT;
 		else
@@ -166,19 +167,18 @@ void udf_expand_file_adinicb(struct inode * inode, int newsize, int * err)
 	page = grab_cache_page(inode->i_mapping, 0);
 	BUG_ON(!PageLocked(page));
 
-	if (!PageUptodate(page))
-	{
+	if (!PageUptodate(page)) {
 		kaddr = kmap(page);
 		memset(kaddr + UDF_I_LENALLOC(inode), 0x00,
-			PAGE_CACHE_SIZE - UDF_I_LENALLOC(inode));
+		       PAGE_CACHE_SIZE - UDF_I_LENALLOC(inode));
 		memcpy(kaddr, UDF_I_DATA(inode) + UDF_I_LENEATTR(inode),
-			UDF_I_LENALLOC(inode));
+		       UDF_I_LENALLOC(inode));
 		flush_dcache_page(page);
 		SetPageUptodate(page);
 		kunmap(page);
 	}
 	memset(UDF_I_DATA(inode) + UDF_I_LENEATTR(inode), 0x00,
-		UDF_I_LENALLOC(inode));
+	       UDF_I_LENALLOC(inode));
 	UDF_I_LENALLOC(inode) = 0;
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
 		UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_SHORT;
@@ -210,8 +210,7 @@ struct buffer_head * udf_expand_dir_adinicb(struct inode *inode, int *block, int
 	else
 		alloctype = ICBTAG_FLAG_AD_LONG;
 
-	if (!inode->i_size)
-	{
+	if (!inode->i_size) {
 		UDF_I_ALLOCTYPE(inode) = alloctype;
 		mark_inode_dirty(inode);
 		return NULL;
@@ -219,13 +218,12 @@ struct buffer_head * udf_expand_dir_adinicb(struct inode *inode, int *block, int
 
 	/* alloc block, and copy data to it */
 	*block = udf_new_block(inode->i_sb, inode,
-		UDF_I_LOCATION(inode).partitionReferenceNum,
-		UDF_I_LOCATION(inode).logicalBlockNum, err);
-
+			       UDF_I_LOCATION(inode).partitionReferenceNum,
+			       UDF_I_LOCATION(inode).logicalBlockNum, err);
 	if (!(*block))
 		return NULL;
 	newblock = udf_get_pblock(inode->i_sb, *block,
-		UDF_I_LOCATION(inode).partitionReferenceNum, 0);
+				  UDF_I_LOCATION(inode).partitionReferenceNum, 0);
 	if (!newblock)
 		return NULL;
 	dbh = udf_tgetblk(inode->i_sb, newblock);
@@ -241,12 +239,10 @@ struct buffer_head * udf_expand_dir_adinicb(struct inode *inode, int *block, int
 	sfibh.sbh = sfibh.ebh = NULL;
 	dfibh.soffset = dfibh.eoffset = 0;
 	dfibh.sbh = dfibh.ebh = dbh;
-	while ( (f_pos < size) )
-	{
+	while (f_pos < size) {
 		UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_IN_ICB;
 		sfi = udf_fileident_read(inode, &f_pos, &sfibh, &cfi, NULL, NULL, NULL, NULL);
-		if (!sfi)
-		{
+		if (!sfi) {
 			brelse(dbh);
 			return NULL;
 		}
@@ -256,8 +252,7 @@ struct buffer_head * udf_expand_dir_adinicb(struct inode *inode, int *block, int
 		dfibh.eoffset += (sfibh.eoffset - sfibh.soffset);
 		dfi = (struct fileIdentDesc *)(dbh->b_data + dfibh.soffset);
 		if (udf_write_fi(inode, sfi, dfi, &dfibh, sfi->impUse,
-			sfi->fileIdent + le16_to_cpu(sfi->lengthOfImpUse)))
-		{
+				 sfi->fileIdent + le16_to_cpu(sfi->lengthOfImpUse))) {
 			UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_IN_ICB;
 			brelse(dbh);
 			return NULL;
@@ -282,14 +277,14 @@ struct buffer_head * udf_expand_dir_adinicb(struct inode *inode, int *block, int
 	return dbh;
 }
 
-static int udf_get_block(struct inode *inode, sector_t block, struct buffer_head *bh_result, int create)
+static int udf_get_block(struct inode *inode, sector_t block,
+			 struct buffer_head *bh_result, int create)
 {
 	int err, new;
 	struct buffer_head *bh;
 	unsigned long phys;
 
-	if (!create)
-	{
+	if (!create) {
 		phys = udf_block_map(inode, block);
 		if (phys)
 			map_bh(bh_result, inode->i_sb, phys);
@@ -305,10 +300,9 @@ static int udf_get_block(struct inode *inode, sector_t block, struct buffer_head
 	if (block < 0)
 		goto abort_negative;
 
-	if (block == UDF_I_NEXT_ALLOC_BLOCK(inode) + 1)
-	{
-		UDF_I_NEXT_ALLOC_BLOCK(inode) ++;
-		UDF_I_NEXT_ALLOC_GOAL(inode) ++;
+	if (block == UDF_I_NEXT_ALLOC_BLOCK(inode) + 1) {
+		UDF_I_NEXT_ALLOC_BLOCK(inode)++;
+		UDF_I_NEXT_ALLOC_GOAL(inode)++;
 	}
 
 	err = 0;
@@ -322,6 +316,7 @@ static int udf_get_block(struct inode *inode, sector_t block, struct buffer_head
 	if (new)
 		set_buffer_new(bh_result);
 	map_bh(bh_result, inode->i_sb, phys);
+
 abort:
 	unlock_kernel();
 	return err;
@@ -331,20 +326,18 @@ abort_negative:
 	goto abort;
 }
 
-static struct buffer_head *
-udf_getblk(struct inode *inode, long block, int create, int *err)
+static struct buffer_head * udf_getblk(struct inode *inode, long block,
+				       int create, int *err)
 {
+	struct buffer_head *bh;
 	struct buffer_head dummy;
 
 	dummy.b_state = 0;
 	dummy.b_blocknr = -1000;
 	*err = udf_get_block(inode, block, &dummy, create);
-	if (!*err && buffer_mapped(&dummy))
-	{
-		struct buffer_head *bh;
+	if (!*err && buffer_mapped(&dummy)) {
 		bh = sb_getblk(inode->i_sb, dummy.b_blocknr);
-		if (buffer_new(&dummy))
-		{
+		if (buffer_new(&dummy)) {
 			lock_buffer(bh);
 			memset(bh->b_data, 0x00, inode->i_sb->s_blocksize);
 			set_buffer_uptodate(bh);
@@ -353,33 +346,36 @@ udf_getblk(struct inode *inode, long block, int create, int *err)
 		}
 		return bh;
 	}
+
 	return NULL;
 }
 
 /* Extend the file by 'blocks' blocks, return the number of extents added */
 int udf_extend_file(struct inode *inode, struct extent_position *last_pos,
-	kernel_long_ad *last_ext, sector_t blocks)
+		    kernel_long_ad *last_ext, sector_t blocks)
 {
 	sector_t add;
 	int count = 0, fake = !(last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
 	struct super_block *sb = inode->i_sb;
-	kernel_lb_addr prealloc_loc = {0, 0};
+	kernel_lb_addr prealloc_loc = {};
 	int prealloc_len = 0;
 
 	/* The previous extent is fake and we should not extend by anything
 	 * - there's nothing to do... */
 	if (!blocks && fake)
 		return 0;
+
 	/* Round the last extent up to a multiple of block size */
 	if (last_ext->extLength & (sb->s_blocksize - 1)) {
 		last_ext->extLength =
 			(last_ext->extLength & UDF_EXTENT_FLAG_MASK) |
 			(((last_ext->extLength & UDF_EXTENT_LENGTH_MASK) +
-				sb->s_blocksize - 1) & ~(sb->s_blocksize - 1));
+			  sb->s_blocksize - 1) & ~(sb->s_blocksize - 1));
 		UDF_I_LENEXTENTS(inode) =
 			(UDF_I_LENEXTENTS(inode) + sb->s_blocksize - 1) &
-				~(sb->s_blocksize - 1);
+			~(sb->s_blocksize - 1);
 	}
+
 	/* Last extent are just preallocated blocks? */
 	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) == EXT_NOT_RECORDED_ALLOCATED) {
 		/* Save the extent so that we can reattach it to the end */
@@ -391,10 +387,11 @@ int udf_extend_file(struct inode *inode, struct extent_position *last_pos,
 		last_ext->extLocation.logicalBlockNum = 0;
        		last_ext->extLocation.partitionReferenceNum = 0;
 	}
+
 	/* Can we merge with the previous extent? */
 	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) == EXT_NOT_RECORDED_NOT_ALLOCATED) {
-		add = ((1<<30) - sb->s_blocksize - (last_ext->extLength &
-			UDF_EXTENT_LENGTH_MASK)) >> sb->s_blocksize_bits;
+		add = ((1 << 30) - sb->s_blocksize - (last_ext->extLength &
+						      UDF_EXTENT_LENGTH_MASK)) >> sb->s_blocksize_bits;
 		if (add > blocks)
 			add = blocks;
 		blocks -= add;
@@ -403,11 +400,12 @@ int udf_extend_file(struct inode *inode, struct extent_position *last_pos,
 
 	if (fake) {
 		udf_add_aext(inode, last_pos, last_ext->extLocation,
-			last_ext->extLength, 1);
+			     last_ext->extLength, 1);
 		count++;
-	}
-	else
+	} else {
 		udf_write_aext(inode, last_pos, last_ext->extLocation, last_ext->extLength, 1);
+	}
+
 	/* Managed to do everything necessary? */
 	if (!blocks)
 		goto out;
@@ -417,11 +415,12 @@ int udf_extend_file(struct inode *inode, struct extent_position *last_pos,
        	last_ext->extLocation.partitionReferenceNum = 0;
 	add = (1 << (30-sb->s_blocksize_bits)) - 1;
 	last_ext->extLength = EXT_NOT_RECORDED_NOT_ALLOCATED | (add << sb->s_blocksize_bits);
+
 	/* Create enough extents to cover the whole hole */
 	while (blocks > add) {
 		blocks -= add;
 		if (udf_add_aext(inode, last_pos, last_ext->extLocation,
-			last_ext->extLength, 1) == -1)
+				 last_ext->extLength, 1) == -1)
 			return -1;
 		count++;
 	}
@@ -429,10 +428,11 @@ int udf_extend_file(struct inode *inode, struct extent_position *last_pos,
 		last_ext->extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
 			(blocks << sb->s_blocksize_bits);
 		if (udf_add_aext(inode, last_pos, last_ext->extLocation,
-			last_ext->extLength, 1) == -1)
+				 last_ext->extLength, 1) == -1)
 			return -1;
 		count++;
 	}
+
 out:
 	/* Do we have some preallocated blocks saved? */
 	if (prealloc_len) {
@@ -442,6 +442,7 @@ out:
 		last_ext->extLength = prealloc_len;
 		count++;
 	}
+
 	/* last_pos should point to the last written extent... */
 	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_SHORT)
 		last_pos->offset -= sizeof(short_ad);
@@ -449,11 +450,12 @@ out:
 		last_pos->offset -= sizeof(long_ad);
 	else
 		return -1;
+
 	return count;
 }
 
 static struct buffer_head * inode_getblk(struct inode * inode, sector_t block,
-	int *err, long *phys, int *new)
+					 int *err, long *phys, int *new)
 {
 	static sector_t last_block;
 	struct buffer_head *result = NULL;
@@ -479,16 +481,13 @@ static struct buffer_head * inode_getblk(struct inode * inode, sector_t block,
 	/* find the extent which contains the block we are looking for.
        alternate between laarr[0] and laarr[1] for locations of the
        current extent, and the previous extent */
-	do
-	{
-		if (prev_epos.bh != cur_epos.bh)
-		{
+	do {
+		if (prev_epos.bh != cur_epos.bh) {
 			brelse(prev_epos.bh);
 			get_bh(cur_epos.bh);
 			prev_epos.bh = cur_epos.bh;
 		}
-		if (cur_epos.bh != next_epos.bh)
-		{
+		if (cur_epos.bh != next_epos.bh) {
 			brelse(cur_epos.bh);
 			get_bh(next_epos.bh);
 			cur_epos.bh = next_epos.bh;
@@ -513,26 +512,27 @@ static struct buffer_head * inode_getblk(struct inode * inode, sector_t block,
 		if (etype != (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))
 			pgoal = eloc.logicalBlockNum +
 				((elen + inode->i_sb->s_blocksize - 1) >>
-				inode->i_sb->s_blocksize_bits);
+				 inode->i_sb->s_blocksize_bits);
 
-		count ++;
+		count++;
 	} while (lbcount + elen <= b_off);
 
 	b_off -= lbcount;
 	offset = b_off >> inode->i_sb->s_blocksize_bits;
+
 	/* Move into indirect extent if we are at a pointer to it */
 	udf_next_aext(inode, &prev_epos, &eloc, &elen, 0);
 
-	/* if the extent is allocated and recorded, return the block
-       if the extent is not a multiple of the blocksize, round up */
+	/*
+	 * if the extent is allocated and recorded, return the block
+	 * if the extent is not a multiple of the blocksize, round up
+	 */
 
-	if (etype == (EXT_RECORDED_ALLOCATED >> 30))
-	{
-		if (elen & (inode->i_sb->s_blocksize - 1))
-		{
+	if (etype == (EXT_RECORDED_ALLOCATED >> 30)) {
+		if (elen & (inode->i_sb->s_blocksize - 1)) {
 			elen = EXT_RECORDED_ALLOCATED |
 				((elen + inode->i_sb->s_blocksize - 1) &
-				~(inode->i_sb->s_blocksize - 1));
+				 ~(inode->i_sb->s_blocksize - 1));
 			etype = udf_write_aext(inode, &cur_epos, eloc, elen, 1);
 		}
 		brelse(prev_epos.bh);
@@ -545,16 +545,14 @@ static struct buffer_head * inode_getblk(struct inode * inode, sector_t block,
 
 	last_block = block;
 	/* Are we beyond EOF? */
-	if (etype == -1)
-	{
+	if (etype == -1) {
 		int ret;
 
 		if (count) {
 			if (c)
 				laarr[0] = laarr[1];
 			startnum = 1;
-		}
-		else {
+		} else {
 			/* Create a fake extent when there's not one */
 			memset(&laarr[0].extLocation, 0x00, sizeof(kernel_lb_addr));
 			laarr[0].extLength = EXT_NOT_RECORDED_NOT_ALLOCATED;
@@ -584,18 +582,16 @@ static struct buffer_head * inode_getblk(struct inode * inode, sector_t block,
 			laarr[c].extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
 				inode->i_sb->s_blocksize;
 			memset(&laarr[c].extLocation, 0x00, sizeof(kernel_lb_addr));
-			count ++;
-			endnum ++;
+			count++;
+			endnum++;
 		}
-		endnum = c+1;
+		endnum = c + 1;
 		lastblock = 1;
-	}
-	else {
+	} else {
 		endnum = startnum = ((count > 2) ? 2 : count);
 
 		/* if the current extent is in position 0, swap it with the previous */
-		if (!c && count != 1)
-		{
+		if (!c && count != 1) {
 			laarr[2] = laarr[0];
 			laarr[0] = laarr[1];
 			laarr[1] = laarr[2];
@@ -603,37 +599,33 @@ static struct buffer_head * inode_getblk(struct inode * inode, sector_t block,
 		}
 
 		/* if the current block is located in an extent, read the next extent */
-		if ((etype = udf_next_aext(inode, &next_epos, &eloc, &elen, 0)) != -1)
-		{
-			laarr[c+1].extLength = (etype << 30) | elen;
-			laarr[c+1].extLocation = eloc;
-			count ++;
-			startnum ++;
-			endnum ++;
-		}
-		else {
+		if ((etype = udf_next_aext(inode, &next_epos, &eloc, &elen, 0)) != -1) {
+			laarr[c + 1].extLength = (etype << 30) | elen;
+			laarr[c + 1].extLocation = eloc;
+			count++;
+			startnum++;
+			endnum++;
+		} else {
 			lastblock = 1;
 		}
 	}
 
 	/* if the current extent is not recorded but allocated, get the
-		block in the extent corresponding to the requested block */
-	if ((laarr[c].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30))
+	 * block in the extent corresponding to the requested block */
+	if ((laarr[c].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
 		newblocknum = laarr[c].extLocation.logicalBlockNum + offset;
-	else /* otherwise, allocate a new block */
-	{
+	} else { /* otherwise, allocate a new block */
 		if (UDF_I_NEXT_ALLOC_BLOCK(inode) == block)
 			goal = UDF_I_NEXT_ALLOC_GOAL(inode);
 
-		if (!goal)
-		{
+		if (!goal) {
 			if (!(goal = pgoal))
 				goal = UDF_I_LOCATION(inode).logicalBlockNum + 1;
 		}
 
 		if (!(newblocknum = udf_new_block(inode->i_sb, inode,
-			UDF_I_LOCATION(inode).partitionReferenceNum, goal, err)))
-		{
+						  UDF_I_LOCATION(inode).partitionReferenceNum,
+						  goal, err))) {
 			brelse(prev_epos.bh);
 			*err = -ENOSPC;
 			return NULL;
@@ -642,8 +634,8 @@ static struct buffer_head * inode_getblk(struct inode * inode, sector_t block,
 	}
 
 	/* if the extent the requsted block is located in contains multiple blocks,
-       split the extent into at most three extents. blocks prior to requested
-       block, requested block, and blocks after requested block */
+	 * split the extent into at most three extents. blocks prior to requested
+	 * block, requested block, and blocks after requested block */
 	udf_split_extents(inode, &c, offset, newblocknum, laarr, &endnum);
 
 #ifdef UDF_PREALLOCATE
@@ -655,15 +647,14 @@ static struct buffer_head * inode_getblk(struct inode * inode, sector_t block,
 	udf_merge_extents(inode, laarr, &endnum);
 
 	/* write back the new extents, inserting new extents if the new number
-	of extents is greater than the old number, and deleting extents if
-	the new number of extents is less than the old number */
+	 * of extents is greater than the old number, and deleting extents if
+	 * the new number of extents is less than the old number */
 	udf_update_extents(inode, laarr, startnum, endnum, &prev_epos);
 
 	brelse(prev_epos.bh);
 
 	if (!(newblock = udf_get_pblock(inode->i_sb, newblocknum,
-		UDF_I_LOCATION(inode).partitionReferenceNum, 0)))
-	{
+					UDF_I_LOCATION(inode).partitionReferenceNum, 0))) {
 		return NULL;
 	}
 	*phys = newblock;
@@ -677,156 +668,136 @@ static struct buffer_head * inode_getblk(struct inode * inode, sector_t block,
 		udf_sync_inode(inode);
 	else
 		mark_inode_dirty(inode);
+
 	return result;
 }
 
 static void udf_split_extents(struct inode *inode, int *c, int offset, int newblocknum,
-	kernel_long_ad laarr[EXTENT_MERGE_SIZE], int *endnum)
+			      kernel_long_ad laarr[EXTENT_MERGE_SIZE], int *endnum)
 {
 	if ((laarr[*c].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30) ||
-		(laarr[*c].extLength >> 30) == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))
-	{
+	    (laarr[*c].extLength >> 30) == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30)) {
 		int curr = *c;
 		int blen = ((laarr[curr].extLength & UDF_EXTENT_LENGTH_MASK) +
-			inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits;
+			    inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits;
 		int8_t etype = (laarr[curr].extLength >> 30);
 
-		if (blen == 1)
+		if (blen == 1) {
 			;
-		else if (!offset || blen == offset + 1)
-		{
-			laarr[curr+2] = laarr[curr+1];
-			laarr[curr+1] = laarr[curr];
-		}
-		else
-		{
-			laarr[curr+3] = laarr[curr+1];
-			laarr[curr+2] = laarr[curr+1] = laarr[curr];
+		} else if (!offset || blen == offset + 1) {
+			laarr[curr + 2] = laarr[curr + 1];
+			laarr[curr + 1] = laarr[curr];
+		} else {
+			laarr[curr + 3] = laarr[curr + 1];
+			laarr[curr + 2] = laarr[curr + 1] = laarr[curr];
 		}
 
-		if (offset)
-		{
-			if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30))
-			{
+		if (offset) {
+			if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
 				udf_free_blocks(inode->i_sb, inode, laarr[curr].extLocation, 0, offset);
 				laarr[curr].extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
 					(offset << inode->i_sb->s_blocksize_bits);
 				laarr[curr].extLocation.logicalBlockNum = 0;
 				laarr[curr].extLocation.partitionReferenceNum = 0;
-			}
-			else
+			} else {
 				laarr[curr].extLength = (etype << 30) |
 					(offset << inode->i_sb->s_blocksize_bits);
-			curr ++;
-			(*c) ++;
-			(*endnum) ++;
+			}
+			curr++;
+			(*c)++;
+			(*endnum)++;
 		}
-		
+
 		laarr[curr].extLocation.logicalBlockNum = newblocknum;
 		if (etype == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))
 			laarr[curr].extLocation.partitionReferenceNum =
 				UDF_I_LOCATION(inode).partitionReferenceNum;
 		laarr[curr].extLength = EXT_RECORDED_ALLOCATED |
 			inode->i_sb->s_blocksize;
-		curr ++;
+		curr++;
 
-		if (blen != offset + 1)
-		{
+		if (blen != offset + 1) {
 			if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30))
 				laarr[curr].extLocation.logicalBlockNum += (offset + 1);
 			laarr[curr].extLength = (etype << 30) |
 				((blen - (offset + 1)) << inode->i_sb->s_blocksize_bits);
-			curr ++;
-			(*endnum) ++;
+			curr++;
+			(*endnum)++;
 		}
 	}
 }
 
 static void udf_prealloc_extents(struct inode *inode, int c, int lastblock,
-	 kernel_long_ad laarr[EXTENT_MERGE_SIZE], int *endnum)
+				 kernel_long_ad laarr[EXTENT_MERGE_SIZE], int *endnum)
 {
 	int start, length = 0, currlength = 0, i;
 
-	if (*endnum >= (c+1))
-	{
+	if (*endnum >= (c + 1)) {
 		if (!lastblock)
 			return;
 		else
 			start = c;
-	}
-	else
-	{
-		if ((laarr[c+1].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30))
-		{
+	} else {
+		if ((laarr[c + 1].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
 			start = c+1;
-			length = currlength = (((laarr[c+1].extLength & UDF_EXTENT_LENGTH_MASK) +
-				inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
-		}
-		else
+			length = currlength = (((laarr[c + 1].extLength & UDF_EXTENT_LENGTH_MASK) +
+						inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
+		} else {
 			start = c;
+		}
 	}
 
-	for (i=start+1; i<=*endnum; i++)
-	{
-		if (i == *endnum)
-		{
+	for (i = start + 1; i <= *endnum; i++) {
+		if (i == *endnum) {
 			if (lastblock)
 				length += UDF_DEFAULT_PREALLOC_BLOCKS;
-		}
-		else if ((laarr[i].extLength >> 30) == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))
+		} else if ((laarr[i].extLength >> 30) == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30)) {
 			length += (((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-				inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
-		else
+				    inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
+		} else {
 			break;
+		}
 	}
 
-	if (length)
-	{
+	if (length) {
 		int next = laarr[start].extLocation.logicalBlockNum +
 			(((laarr[start].extLength & UDF_EXTENT_LENGTH_MASK) +
-			inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
+			  inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
 		int numalloc = udf_prealloc_blocks(inode->i_sb, inode,
-			laarr[start].extLocation.partitionReferenceNum,
-			next, (UDF_DEFAULT_PREALLOC_BLOCKS > length ? length :
-				UDF_DEFAULT_PREALLOC_BLOCKS) - currlength);
-
-		if (numalloc)
-		{
-			if (start == (c+1))
+						   laarr[start].extLocation.partitionReferenceNum,
+						   next, (UDF_DEFAULT_PREALLOC_BLOCKS > length ? length :
+							  UDF_DEFAULT_PREALLOC_BLOCKS) - currlength);
+		if (numalloc) 	{
+			if (start == (c + 1)) {
 				laarr[start].extLength +=
 					(numalloc << inode->i_sb->s_blocksize_bits);
-			else
-			{
-				memmove(&laarr[c+2], &laarr[c+1],
-					sizeof(long_ad) * (*endnum - (c+1)));
-				(*endnum) ++;
-				laarr[c+1].extLocation.logicalBlockNum = next;
-				laarr[c+1].extLocation.partitionReferenceNum =
+			} else {
+				memmove(&laarr[c + 2], &laarr[c + 1],
+					sizeof(long_ad) * (*endnum - (c + 1)));
+				(*endnum)++;
+				laarr[c + 1].extLocation.logicalBlockNum = next;
+				laarr[c + 1].extLocation.partitionReferenceNum =
 					laarr[c].extLocation.partitionReferenceNum;
-				laarr[c+1].extLength = EXT_NOT_RECORDED_ALLOCATED |
+				laarr[c + 1].extLength = EXT_NOT_RECORDED_ALLOCATED |
 					(numalloc << inode->i_sb->s_blocksize_bits);
-				start = c+1;
+				start = c + 1;
 			}
 
-			for (i=start+1; numalloc && i<*endnum; i++)
-			{
+			for (i = start + 1; numalloc && i < *endnum; i++) {
 				int elen = ((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-					inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits;
+					    inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits;
 
-				if (elen > numalloc)
-				{
+				if (elen > numalloc) {
 					laarr[i].extLength -=
 						(numalloc << inode->i_sb->s_blocksize_bits);
 					numalloc = 0;
-				}
-				else
-				{
+				} else {
 					numalloc -= elen;
-					if (*endnum > (i+1))
-						memmove(&laarr[i], &laarr[i+1], 
-							sizeof(long_ad) * (*endnum - (i+1)));
-					i --;
-					(*endnum) --;
+					if (*endnum > (i + 1))
+						memmove(&laarr[i], &laarr[i + 1],
+							sizeof(long_ad) * (*endnum - (i + 1)));
+					i--;
+					(*endnum)--;
 				}
 			}
 			UDF_I_LENEXTENTS(inode) += numalloc << inode->i_sb->s_blocksize_bits;
@@ -835,82 +806,71 @@ static void udf_prealloc_extents(struct inode *inode, int c, int lastblock,
 }
 
 static void udf_merge_extents(struct inode *inode,
-	 kernel_long_ad laarr[EXTENT_MERGE_SIZE], int *endnum)
+			      kernel_long_ad laarr[EXTENT_MERGE_SIZE],
+			      int *endnum)
 {
 	int i;
 
-	for (i=0; i<(*endnum-1); i++)
+	for (i = 0; i < (*endnum - 1); i++)
 	{
-		if ((laarr[i].extLength >> 30) == (laarr[i+1].extLength >> 30))
-		{
+		if ((laarr[i].extLength >> 30) == (laarr[i + 1].extLength >> 30)) {
 			if (((laarr[i].extLength >> 30) == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30)) ||
-				((laarr[i+1].extLocation.logicalBlockNum - laarr[i].extLocation.logicalBlockNum) ==
-				(((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-				inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits)))
-			{
+			    ((laarr[i + 1].extLocation.logicalBlockNum - laarr[i].extLocation.logicalBlockNum) ==
+			     (((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
+			       inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits))) {
 				if (((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-					(laarr[i+1].extLength & UDF_EXTENT_LENGTH_MASK) +
-					inode->i_sb->s_blocksize - 1) & ~UDF_EXTENT_LENGTH_MASK)
-				{
-					laarr[i+1].extLength = (laarr[i+1].extLength -
-						(laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-						UDF_EXTENT_LENGTH_MASK) & ~(inode->i_sb->s_blocksize-1);
+				     (laarr[i + 1].extLength & UDF_EXTENT_LENGTH_MASK) +
+				     inode->i_sb->s_blocksize - 1) & ~UDF_EXTENT_LENGTH_MASK) {
+					laarr[i + 1].extLength = (laarr[i + 1].extLength -
+								  (laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
+								  UDF_EXTENT_LENGTH_MASK) & ~(inode->i_sb->s_blocksize - 1);
 					laarr[i].extLength = (laarr[i].extLength & UDF_EXTENT_FLAG_MASK) +
 						(UDF_EXTENT_LENGTH_MASK + 1) - inode->i_sb->s_blocksize;
-					laarr[i+1].extLocation.logicalBlockNum =
+					laarr[i + 1].extLocation.logicalBlockNum =
 						laarr[i].extLocation.logicalBlockNum +
 						((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) >>
-							inode->i_sb->s_blocksize_bits);
-				}
-				else
-				{
-					laarr[i].extLength = laarr[i+1].extLength +
+						 inode->i_sb->s_blocksize_bits);
+				} else {
+					laarr[i].extLength = laarr[i + 1].extLength +
 						(((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-						inode->i_sb->s_blocksize - 1) & ~(inode->i_sb->s_blocksize-1));
-					if (*endnum > (i+2))
-						memmove(&laarr[i+1], &laarr[i+2],
-							sizeof(long_ad) * (*endnum - (i+2)));
-					i --;
-					(*endnum) --;
+						  inode->i_sb->s_blocksize - 1) & ~(inode->i_sb->s_blocksize - 1));
+					if (*endnum > (i + 2))
+						memmove(&laarr[i + 1], &laarr[i + 2],
+							sizeof(long_ad) * (*endnum - (i + 2)));
+					i--;
+					(*endnum)--;
 				}
 			}
-		}
-		else if (((laarr[i].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30)) &&
-			((laarr[i+1].extLength >> 30) == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30)))
-		{
+		} else if (((laarr[i].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30)) &&
+			   ((laarr[i + 1].extLength >> 30) == (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))) {
 			udf_free_blocks(inode->i_sb, inode, laarr[i].extLocation, 0,
-				((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-				inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
+					((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
+					 inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
 			laarr[i].extLocation.logicalBlockNum = 0;
 			laarr[i].extLocation.partitionReferenceNum = 0;
 
 			if (((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-				(laarr[i+1].extLength & UDF_EXTENT_LENGTH_MASK) +
-				inode->i_sb->s_blocksize - 1) & ~UDF_EXTENT_LENGTH_MASK)
-			{
-				laarr[i+1].extLength = (laarr[i+1].extLength -
-					(laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-					UDF_EXTENT_LENGTH_MASK) & ~(inode->i_sb->s_blocksize-1);
+			     (laarr[i + 1].extLength & UDF_EXTENT_LENGTH_MASK) +
+			     inode->i_sb->s_blocksize - 1) & ~UDF_EXTENT_LENGTH_MASK) {
+				laarr[i + 1].extLength = (laarr[i + 1].extLength -
+							  (laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
+							  UDF_EXTENT_LENGTH_MASK) & ~(inode->i_sb->s_blocksize-1);
 				laarr[i].extLength = (laarr[i].extLength & UDF_EXTENT_FLAG_MASK) +
 					(UDF_EXTENT_LENGTH_MASK + 1) - inode->i_sb->s_blocksize;
-			}
-			else
-			{
+			} else {
 				laarr[i].extLength = laarr[i+1].extLength +
 					(((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-					inode->i_sb->s_blocksize - 1) & ~(inode->i_sb->s_blocksize-1));
-				if (*endnum > (i+2))
-					memmove(&laarr[i+1], &laarr[i+2],
-						sizeof(long_ad) * (*endnum - (i+2)));
-				i --;
-				(*endnum) --;
+					  inode->i_sb->s_blocksize - 1) & ~(inode->i_sb->s_blocksize-1));
+				if (*endnum > (i + 2))
+					memmove(&laarr[i + 1], &laarr[i + 2],
+						sizeof(long_ad) * (*endnum - (i + 2)));
+				i--;
+				(*endnum)--;
 			}
-		}
-		else if ((laarr[i].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30))
-		{
+		} else if ((laarr[i].extLength >> 30) == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
 			udf_free_blocks(inode->i_sb, inode, laarr[i].extLocation, 0,
-				((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
-			       inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
+					((laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) +
+					 inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits);
 			laarr[i].extLocation.logicalBlockNum = 0;
 			laarr[i].extLocation.partitionReferenceNum = 0;
 			laarr[i].extLength = (laarr[i].extLength & UDF_EXTENT_LENGTH_MASK) |
@@ -920,41 +880,37 @@ static void udf_merge_extents(struct inode *inode,
 }
 
 static void udf_update_extents(struct inode *inode,
-	kernel_long_ad laarr[EXTENT_MERGE_SIZE], int startnum, int endnum,
-	struct extent_position *epos)
+			       kernel_long_ad laarr[EXTENT_MERGE_SIZE],
+			       int startnum, int endnum,
+			       struct extent_position *epos)
 {
 	int start = 0, i;
 	kernel_lb_addr tmploc;
 	uint32_t tmplen;
 
-	if (startnum > endnum)
-	{
-		for (i=0; i<(startnum-endnum); i++)
+	if (startnum > endnum) {
+		for (i = 0; i < (startnum - endnum); i++)
 			udf_delete_aext(inode, *epos, laarr[i].extLocation,
-				laarr[i].extLength);
-	}
-	else if (startnum < endnum)
-	{
-		for (i=0; i<(endnum-startnum); i++)
-		{
+					laarr[i].extLength);
+	} else if (startnum < endnum) {
+		for (i = 0; i < (endnum - startnum); i++) {
 			udf_insert_aext(inode, *epos, laarr[i].extLocation,
-				laarr[i].extLength);
+					laarr[i].extLength);
 			udf_next_aext(inode, epos, &laarr[i].extLocation,
-				&laarr[i].extLength, 1);
-			start ++;
+				      &laarr[i].extLength, 1);
+			start++;
 		}
 	}
 
-	for (i=start; i<endnum; i++)
-	{
+	for (i = start; i < endnum; i++) {
 		udf_next_aext(inode, epos, &tmploc, &tmplen, 0);
 		udf_write_aext(inode, epos, laarr[i].extLocation,
-			laarr[i].extLength, 1);
+			       laarr[i].extLength, 1);
 	}
 }
 
 struct buffer_head * udf_bread(struct inode * inode, int block,
-	int create, int * err)
+			       int create, int * err)
 {
 	struct buffer_head * bh = NULL;
 
@@ -964,10 +920,13 @@ struct buffer_head * udf_bread(struct inode * inode, int block,
 
 	if (buffer_uptodate(bh))
 		return bh;
+
 	ll_rw_block(READ, 1, &bh);
+
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
 		return bh;
+
 	brelse(bh);
 	*err = -EIO;
 	return NULL;
@@ -985,33 +944,27 @@ void udf_truncate(struct inode * inode)
 		return;
 
 	lock_kernel();
-	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB)
-	{
+	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB) {
 		if (inode->i_sb->s_blocksize < (udf_file_entry_alloc_offset(inode) +
-			inode->i_size))
-		{
+						inode->i_size)) {
 			udf_expand_file_adinicb(inode, inode->i_size, &err);
-			if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB)
-			{
+			if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB) {
 				inode->i_size = UDF_I_LENALLOC(inode);
 				unlock_kernel();
 				return;
-			}
-			else
+			} else {
 				udf_truncate_extents(inode);
-		}
-		else
-		{
+			}
+		} else {
 			offset = inode->i_size & (inode->i_sb->s_blocksize - 1);
-			memset(UDF_I_DATA(inode) + UDF_I_LENEATTR(inode) + offset, 0x00, inode->i_sb->s_blocksize - offset - udf_file_entry_alloc_offset(inode));
+			memset(UDF_I_DATA(inode) + UDF_I_LENEATTR(inode) + offset, 0x00,
+			       inode->i_sb->s_blocksize - offset - udf_file_entry_alloc_offset(inode));
 			UDF_I_LENALLOC(inode) = inode->i_size;
 		}
-	}
-	else
-	{
+	} else {
 		block_truncate_page(inode->i_mapping, inode->i_size, udf_get_block);
 		udf_truncate_extents(inode);
-	}	
+	}
 
 	inode->i_mtime = inode->i_ctime = current_fs_time(inode->i_sb);
 	if (IS_SYNC(inode))
@@ -1021,8 +974,7 @@ void udf_truncate(struct inode * inode)
 	unlock_kernel();
 }
 
-static void
-__udf_read_inode(struct inode *inode)
+static void __udf_read_inode(struct inode *inode)
 {
 	struct buffer_head *bh = NULL;
 	struct fileEntry *fe;
@@ -1041,20 +993,17 @@ __udf_read_inode(struct inode *inode)
 	 *      i_op = NULL;
 	 */
 	bh = udf_read_ptagged(inode->i_sb, UDF_I_LOCATION(inode), 0, &ident);
-
-	if (!bh)
-	{
+	if (!bh) {
 		printk(KERN_ERR "udf: udf_read_inode(ino %ld) failed !bh\n",
-			inode->i_ino);
+		       inode->i_ino);
 		make_bad_inode(inode);
 		return;
 	}
 
 	if (ident != TAG_IDENT_FE && ident != TAG_IDENT_EFE &&
-		ident != TAG_IDENT_USE)
-	{
+	    ident != TAG_IDENT_USE) {
 		printk(KERN_ERR "udf: udf_read_inode(ino %ld) failed ident=%d\n",
-			inode->i_ino, ident);
+		       inode->i_ino, ident);
 		brelse(bh);
 		make_bad_inode(inode);
 		return;
@@ -1062,51 +1011,43 @@ __udf_read_inode(struct inode *inode)
 
 	fe = (struct fileEntry *)bh->b_data;
 
-	if (le16_to_cpu(fe->icbTag.strategyType) == 4096)
-	{
+	if (le16_to_cpu(fe->icbTag.strategyType) == 4096) {
 		struct buffer_head *ibh = NULL, *nbh = NULL;
 		struct indirectEntry *ie;
 
 		ibh = udf_read_ptagged(inode->i_sb, UDF_I_LOCATION(inode), 1, &ident);
-		if (ident == TAG_IDENT_IE)
-		{
-			if (ibh)
-			{
+		if (ident == TAG_IDENT_IE) {
+			if (ibh) {
 				kernel_lb_addr loc;
 				ie = (struct indirectEntry *)ibh->b_data;
-	
+
 				loc = lelb_to_cpu(ie->indirectICB.extLocation);
-	
-				if (ie->indirectICB.extLength && 
-					(nbh = udf_read_ptagged(inode->i_sb, loc, 0, &ident)))
-				{
+
+				if (ie->indirectICB.extLength &&
+				    (nbh = udf_read_ptagged(inode->i_sb, loc, 0, &ident))) {
 					if (ident == TAG_IDENT_FE ||
-						ident == TAG_IDENT_EFE)
-					{
-						memcpy(&UDF_I_LOCATION(inode), &loc, sizeof(kernel_lb_addr));
+					    ident == TAG_IDENT_EFE) {
+						memcpy(&UDF_I_LOCATION(inode), &loc,
+						       sizeof(kernel_lb_addr));
 						brelse(bh);
 						brelse(ibh);
 						brelse(nbh);
 						__udf_read_inode(inode);
 						return;
-					}
-					else
-					{
+					} else {
 						brelse(nbh);
 						brelse(ibh);
 					}
-				}
-				else
+				} else {
 					brelse(ibh);
+				}
 			}
-		}
-		else
+		} else {
 			brelse(ibh);
-	}
-	else if (le16_to_cpu(fe->icbTag.strategyType) != 4)
-	{
+		}
+	} else if (le16_to_cpu(fe->icbTag.strategyType) != 4) {
 		printk(KERN_ERR "udf: unsupported strategy type: %d\n",
-			le16_to_cpu(fe->icbTag.strategyType));
+		       le16_to_cpu(fe->icbTag.strategyType));
 		brelse(bh);
 		make_bad_inode(inode);
 		return;
@@ -1139,27 +1080,28 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 	UDF_I_LENALLOC(inode) = 0;
 	UDF_I_NEXT_ALLOC_BLOCK(inode) = 0;
 	UDF_I_NEXT_ALLOC_GOAL(inode) = 0;
-	if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_EFE)
-	{
+	if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_EFE) {
 		UDF_I_EFE(inode) = 1;
 		UDF_I_USE(inode) = 0;
-		UDF_I_DATA(inode) = kmalloc(inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry), GFP_KERNEL);
+		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry))) {
+			make_bad_inode(inode);
+			return;
+		}
 		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct extendedFileEntry), inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry));
-	}
-	else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_FE)
-	{
+	} else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_FE) {
 		UDF_I_EFE(inode) = 0;
 		UDF_I_USE(inode) = 0;
 		UDF_I_DATA(inode) = kmalloc(inode->i_sb->s_blocksize - sizeof(struct fileEntry), GFP_KERNEL);
+		if (udf_alloc_i_data(inode, inode->i_sb->s_blocksize - sizeof(struct fileEntry))) {
+			make_bad_inode(inode);
+			return;
+		}
 		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct fileEntry), inode->i_sb->s_blocksize - sizeof(struct fileEntry));
-	}
-	else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_USE)
-	{
+	} else if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_USE) {
 		UDF_I_EFE(inode) = 0;
 		UDF_I_USE(inode) = 1;
 		UDF_I_LENALLOC(inode) =
-			le32_to_cpu(
-				((struct unallocSpaceEntry *)bh->b_data)->lengthAllocDescs);
+			le32_to_cpu(((struct unallocSpaceEntry *)bh->b_data)->lengthAllocDescs);
 		UDF_I_DATA(inode) = kmalloc(inode->i_sb->s_blocksize - sizeof(struct unallocSpaceEntry), GFP_KERNEL);
 		memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct unallocSpaceEntry), inode->i_sb->s_blocksize - sizeof(struct unallocSpaceEntry));
 		return;
@@ -1167,59 +1109,49 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 
 	inode->i_uid = le32_to_cpu(fe->uid);
 	if (inode->i_uid == -1 || UDF_QUERY_FLAG(inode->i_sb,
-					UDF_FLAG_UID_IGNORE))
+						 UDF_FLAG_UID_IGNORE))
 		inode->i_uid = UDF_SB(inode->i_sb)->s_uid;
 
 	inode->i_gid = le32_to_cpu(fe->gid);
 	if (inode->i_gid == -1 || UDF_QUERY_FLAG(inode->i_sb,
-					UDF_FLAG_GID_IGNORE))
+						 UDF_FLAG_GID_IGNORE))
 		inode->i_gid = UDF_SB(inode->i_sb)->s_gid;
 
 	inode->i_nlink = le16_to_cpu(fe->fileLinkCount);
 	if (!inode->i_nlink)
 		inode->i_nlink = 1;
-	
+
 	inode->i_size = le64_to_cpu(fe->informationLength);
 	UDF_I_LENEXTENTS(inode) = inode->i_size;
 
 	inode->i_mode = udf_convert_permissions(fe);
 	inode->i_mode &= ~UDF_SB(inode->i_sb)->s_umask;
 
-	if (UDF_I_EFE(inode) == 0)
-	{
+	if (UDF_I_EFE(inode) == 0) {
 		inode->i_blocks = le64_to_cpu(fe->logicalBlocksRecorded) <<
 			(inode->i_sb->s_blocksize_bits - 9);
 
-		if ( udf_stamp_to_time(&convtime, &convtime_usec,
-			lets_to_cpu(fe->accessTime)) )
-		{
+		if (udf_stamp_to_time(&convtime, &convtime_usec,
+				      lets_to_cpu(fe->accessTime))) {
 			inode->i_atime.tv_sec = convtime;
 			inode->i_atime.tv_nsec = convtime_usec * 1000;
-		}
-		else
-		{
+		} else {
 			inode->i_atime = UDF_SB_RECORDTIME(inode->i_sb);
 		}
 
-		if ( udf_stamp_to_time(&convtime, &convtime_usec,
-			lets_to_cpu(fe->modificationTime)) )
-		{
+		if (udf_stamp_to_time(&convtime, &convtime_usec,
+				      lets_to_cpu(fe->modificationTime))) {
 			inode->i_mtime.tv_sec = convtime;
 			inode->i_mtime.tv_nsec = convtime_usec * 1000;
-		}
-		else
-		{
+		} else {
 			inode->i_mtime = UDF_SB_RECORDTIME(inode->i_sb);
 		}
 
-		if ( udf_stamp_to_time(&convtime, &convtime_usec,
-			lets_to_cpu(fe->attrTime)) )
-		{
+		if (udf_stamp_to_time(&convtime, &convtime_usec,
+				      lets_to_cpu(fe->attrTime))) {
 			inode->i_ctime.tv_sec = convtime;
 			inode->i_ctime.tv_nsec = convtime_usec * 1000;
-		}
-		else
-		{
+		} else {
 			inode->i_ctime = UDF_SB_RECORDTIME(inode->i_sb);
 		}
 
@@ -1227,53 +1159,39 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 		UDF_I_LENEATTR(inode) = le32_to_cpu(fe->lengthExtendedAttr);
 		UDF_I_LENALLOC(inode) = le32_to_cpu(fe->lengthAllocDescs);
 		offset = sizeof(struct fileEntry) + UDF_I_LENEATTR(inode);
-	}
-	else
-	{
-		inode->i_blocks = le64_to_cpu(efe->logicalBlocksRecorded) << 
+	} else {
+		inode->i_blocks = le64_to_cpu(efe->logicalBlocksRecorded) <<
 			(inode->i_sb->s_blocksize_bits - 9);
 
-		if ( udf_stamp_to_time(&convtime, &convtime_usec,
-			lets_to_cpu(efe->accessTime)) )
-		{
+		if (udf_stamp_to_time(&convtime, &convtime_usec,
+				      lets_to_cpu(efe->accessTime))) {
 			inode->i_atime.tv_sec = convtime;
 			inode->i_atime.tv_nsec = convtime_usec * 1000;
-		}
-		else
-		{
+		} else {
 			inode->i_atime = UDF_SB_RECORDTIME(inode->i_sb);
 		}
 
-		if ( udf_stamp_to_time(&convtime, &convtime_usec,
-			lets_to_cpu(efe->modificationTime)) )
-		{
+		if (udf_stamp_to_time(&convtime, &convtime_usec,
+				      lets_to_cpu(efe->modificationTime))) {
 			inode->i_mtime.tv_sec = convtime;
 			inode->i_mtime.tv_nsec = convtime_usec * 1000;
-		}
-		else
-		{
+		} else {
 			inode->i_mtime = UDF_SB_RECORDTIME(inode->i_sb);
 		}
 
-		if ( udf_stamp_to_time(&convtime, &convtime_usec,
-			lets_to_cpu(efe->createTime)) )
-		{
+		if (udf_stamp_to_time(&convtime, &convtime_usec,
+				      lets_to_cpu(efe->createTime))) {
 			UDF_I_CRTIME(inode).tv_sec = convtime;
 			UDF_I_CRTIME(inode).tv_nsec = convtime_usec * 1000;
-		}
-		else
-		{
+		} else {
 			UDF_I_CRTIME(inode) = UDF_SB_RECORDTIME(inode->i_sb);
 		}
 
-		if ( udf_stamp_to_time(&convtime, &convtime_usec,
-			lets_to_cpu(efe->attrTime)) )
-		{
+		if (udf_stamp_to_time(&convtime, &convtime_usec,
+				      lets_to_cpu(efe->attrTime))) {
 			inode->i_ctime.tv_sec = convtime;
 			inode->i_ctime.tv_nsec = convtime_usec * 1000;
-		}
-		else
-		{
+		} else {
 			inode->i_ctime = UDF_SB_RECORDTIME(inode->i_sb);
 		}
 
@@ -1283,86 +1201,74 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 		offset = sizeof(struct extendedFileEntry) + UDF_I_LENEATTR(inode);
 	}
 
-	switch (fe->icbTag.fileType)
-	{
+	switch (fe->icbTag.fileType) {
 		case ICBTAG_FILE_TYPE_DIRECTORY:
-		{
-			inode->i_op = &udf_dir_inode_operations;
+			inode->i_op = (struct inode_operations *)&udf_dir_inode_operations;
 			inode->i_fop = &udf_dir_operations;
 			inode->i_mode |= S_IFDIR;
 			inc_nlink(inode);
 			break;
-		}
 		case ICBTAG_FILE_TYPE_REALTIME:
 		case ICBTAG_FILE_TYPE_REGULAR:
 		case ICBTAG_FILE_TYPE_UNDEF:
-		{
 			if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB)
 				inode->i_data.a_ops = &udf_adinicb_aops;
 			else
 				inode->i_data.a_ops = &udf_aops;
-			inode->i_op = &udf_file_inode_operations;
+			inode->i_op = (struct inode_operations *)&udf_file_inode_operations;
 			inode->i_fop = &udf_file_operations;
 			inode->i_mode |= S_IFREG;
 			break;
-		}
 		case ICBTAG_FILE_TYPE_BLOCK:
-		{
 			inode->i_mode |= S_IFBLK;
 			break;
-		}
 		case ICBTAG_FILE_TYPE_CHAR:
-		{
 			inode->i_mode |= S_IFCHR;
 			break;
-		}
 		case ICBTAG_FILE_TYPE_FIFO:
-		{
 			init_special_inode(inode, inode->i_mode | S_IFIFO, 0);
 			break;
-		}
 		case ICBTAG_FILE_TYPE_SOCKET:
-		{
 			init_special_inode(inode, inode->i_mode | S_IFSOCK, 0);
 			break;
-		}
 		case ICBTAG_FILE_TYPE_SYMLINK:
-		{
 			inode->i_data.a_ops = &udf_symlink_aops;
 			inode->i_op = &page_symlink_inode_operations;
 			inode->i_mode = S_IFLNK|S_IRWXUGO;
 			break;
-		}
 		default:
-		{
 			printk(KERN_ERR "udf: udf_fill_inode(ino %ld) failed unknown file type=%d\n",
-				inode->i_ino, fe->icbTag.fileType);
+			       inode->i_ino, fe->icbTag.fileType);
 			make_bad_inode(inode);
 			return;
-		}
 	}
-	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode))
-	{
-		struct deviceSpec *dsea =
-			(struct deviceSpec *)
-				udf_get_extendedattr(inode, 12, 1);
-
-		if (dsea)
-		{
-			init_special_inode(inode, inode->i_mode, MKDEV(
-				le32_to_cpu(dsea->majorDeviceIdent),
-				le32_to_cpu(dsea->minorDeviceIdent)));
+	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
+		struct deviceSpec *dsea = (struct deviceSpec *)udf_get_extendedattr(inode, 12, 1);
+		if (dsea) {
+			init_special_inode(inode, inode->i_mode,
+					   MKDEV(le32_to_cpu(dsea->majorDeviceIdent),
+						 le32_to_cpu(dsea->minorDeviceIdent)));
 			/* Developer ID ??? */
-		}
-		else
-		{
+		} else {
 			make_bad_inode(inode);
 		}
 	}
 }
 
-static mode_t
-udf_convert_permissions(struct fileEntry *fe)
+static int udf_alloc_i_data(struct inode *inode, size_t size)
+{
+	UDF_I_DATA(inode) = kmalloc(size, GFP_KERNEL);
+
+	if (!UDF_I_DATA(inode)) {
+		printk(KERN_ERR "udf:udf_alloc_i_data (ino %ld) no free memory\n",
+		       inode->i_ino);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static mode_t udf_convert_permissions(struct fileEntry *fe)
 {
 	mode_t mode;
 	uint32_t permissions;
@@ -1399,9 +1305,11 @@ udf_convert_permissions(struct fileEntry *fe)
 int udf_write_inode(struct inode * inode, int sync)
 {
 	int ret;
+
 	lock_kernel();
 	ret = udf_update_inode(inode, sync);
 	unlock_kernel();
+
 	return ret;
 }
 
@@ -1410,8 +1318,7 @@ int udf_sync_inode(struct inode * inode)
 	return udf_update_inode(inode, 1);
 }
 
-static int
-udf_update_inode(struct inode *inode, int do_sync)
+static int udf_update_inode(struct inode *inode, int do_sync)
 {
 	struct buffer_head *bh = NULL;
 	struct fileEntry *fe;
@@ -1423,11 +1330,8 @@ udf_update_inode(struct inode *inode, int do_sync)
 	kernel_timestamp cpu_time;
 	int err = 0;
 
-	bh = udf_tread(inode->i_sb,
-		udf_get_lb_pblock(inode->i_sb, UDF_I_LOCATION(inode), 0));
-
-	if (!bh)
-	{
+	bh = udf_tread(inode->i_sb, udf_get_lb_pblock(inode->i_sb, UDF_I_LOCATION(inode), 0));
+	if (!bh) {
 		udf_debug("bread failure\n");
 		return -EIO;
 	}
@@ -1437,23 +1341,23 @@ udf_update_inode(struct inode *inode, int do_sync)
 	fe = (struct fileEntry *)bh->b_data;
 	efe = (struct extendedFileEntry *)bh->b_data;
 
-	if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_USE)
-	{
+	if (le16_to_cpu(fe->descTag.tagIdent) == TAG_IDENT_USE) {
 		struct unallocSpaceEntry *use =
 			(struct unallocSpaceEntry *)bh->b_data;
 
 		use->lengthAllocDescs = cpu_to_le32(UDF_I_LENALLOC(inode));
-		memcpy(bh->b_data + sizeof(struct unallocSpaceEntry), UDF_I_DATA(inode), inode->i_sb->s_blocksize - sizeof(struct unallocSpaceEntry));
-		crclen = sizeof(struct unallocSpaceEntry) + UDF_I_LENALLOC(inode) -
-			sizeof(tag);
+		memcpy(bh->b_data + sizeof(struct unallocSpaceEntry), UDF_I_DATA(inode),
+		       inode->i_sb->s_blocksize - sizeof(struct unallocSpaceEntry));
+		crclen = sizeof(struct unallocSpaceEntry) + UDF_I_LENALLOC(inode) - sizeof(tag);
 		use->descTag.tagLocation = cpu_to_le32(UDF_I_LOCATION(inode).logicalBlockNum);
 		use->descTag.descCRCLength = cpu_to_le16(crclen);
 		use->descTag.descCRC = cpu_to_le16(udf_crc((char *)use + sizeof(tag), crclen, 0));
 
 		use->descTag.tagChecksum = 0;
-		for (i=0; i<16; i++)
+		for (i = 0; i < 16; i++) {
 			if (i != 4)
 				use->descTag.tagChecksum += ((uint8_t *)&(use->descTag))[i];
+		}
 
 		mark_buffer_dirty(bh);
 		brelse(bh);
@@ -1485,23 +1389,19 @@ udf_update_inode(struct inode *inode, int do_sync)
 
 	fe->informationLength = cpu_to_le64(inode->i_size);
 
-	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode))
-	{
+	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
 		regid *eid;
 		struct deviceSpec *dsea =
-			(struct deviceSpec *)
-				udf_get_extendedattr(inode, 12, 1);
-
-		if (!dsea)
-		{
+			(struct deviceSpec *)udf_get_extendedattr(inode, 12, 1);
+		if (!dsea) {
 			dsea = (struct deviceSpec *)
 				udf_add_extendedattr(inode,
-					sizeof(struct deviceSpec) +
-					sizeof(regid), 12, 0x3);
+						     sizeof(struct deviceSpec) +
+						     sizeof(regid), 12, 0x3);
 			dsea->attrType = cpu_to_le32(12);
 			dsea->attrSubtype = 1;
 			dsea->attrLength = cpu_to_le32(sizeof(struct deviceSpec) +
-				sizeof(regid));
+						       sizeof(regid));
 			dsea->impUseLength = cpu_to_le32(sizeof(regid));
 		}
 		eid = (regid *)dsea->impUse;
@@ -1513,9 +1413,9 @@ udf_update_inode(struct inode *inode, int do_sync)
 		dsea->minorDeviceIdent = cpu_to_le32(iminor(inode));
 	}
 
-	if (UDF_I_EFE(inode) == 0)
-	{
-		memcpy(bh->b_data + sizeof(struct fileEntry), UDF_I_DATA(inode), inode->i_sb->s_blocksize - sizeof(struct fileEntry));
+	if (UDF_I_EFE(inode) == 0) {
+		memcpy(bh->b_data + sizeof(struct fileEntry), UDF_I_DATA(inode),
+		       inode->i_sb->s_blocksize - sizeof(struct fileEntry));
 		fe->logicalBlocksRecorded = cpu_to_le64(
 			(inode->i_blocks + (1 << (inode->i_sb->s_blocksize_bits - 9)) - 1) >>
 			(inode->i_sb->s_blocksize_bits - 9));
@@ -1535,31 +1435,27 @@ udf_update_inode(struct inode *inode, int do_sync)
 		fe->lengthAllocDescs = cpu_to_le32(UDF_I_LENALLOC(inode));
 		fe->descTag.tagIdent = cpu_to_le16(TAG_IDENT_FE);
 		crclen = sizeof(struct fileEntry);
-	}
-	else
-	{
-		memcpy(bh->b_data + sizeof(struct extendedFileEntry), UDF_I_DATA(inode), inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry));
+	} else {
+		memcpy(bh->b_data + sizeof(struct extendedFileEntry), UDF_I_DATA(inode),
+		       inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry));
 		efe->objectSize = cpu_to_le64(inode->i_size);
 		efe->logicalBlocksRecorded = cpu_to_le64(
 			(inode->i_blocks + (1 << (inode->i_sb->s_blocksize_bits - 9)) - 1) >>
 			(inode->i_sb->s_blocksize_bits - 9));
 
 		if (UDF_I_CRTIME(inode).tv_sec > inode->i_atime.tv_sec ||
-			(UDF_I_CRTIME(inode).tv_sec == inode->i_atime.tv_sec &&
-			 UDF_I_CRTIME(inode).tv_nsec > inode->i_atime.tv_nsec))
-		{
+		    (UDF_I_CRTIME(inode).tv_sec == inode->i_atime.tv_sec &&
+		     UDF_I_CRTIME(inode).tv_nsec > inode->i_atime.tv_nsec)) {
 			UDF_I_CRTIME(inode) = inode->i_atime;
 		}
 		if (UDF_I_CRTIME(inode).tv_sec > inode->i_mtime.tv_sec ||
-			(UDF_I_CRTIME(inode).tv_sec == inode->i_mtime.tv_sec &&
-			 UDF_I_CRTIME(inode).tv_nsec > inode->i_mtime.tv_nsec))
-		{
+		    (UDF_I_CRTIME(inode).tv_sec == inode->i_mtime.tv_sec &&
+		     UDF_I_CRTIME(inode).tv_nsec > inode->i_mtime.tv_nsec)) {
 			UDF_I_CRTIME(inode) = inode->i_mtime;
 		}
 		if (UDF_I_CRTIME(inode).tv_sec > inode->i_ctime.tv_sec ||
-			(UDF_I_CRTIME(inode).tv_sec == inode->i_ctime.tv_sec &&
-			 UDF_I_CRTIME(inode).tv_nsec > inode->i_ctime.tv_nsec))
-		{
+		    (UDF_I_CRTIME(inode).tv_sec == inode->i_ctime.tv_sec &&
+		     UDF_I_CRTIME(inode).tv_nsec > inode->i_ctime.tv_nsec)) {
 			UDF_I_CRTIME(inode) = inode->i_ctime;
 		}
 
@@ -1582,14 +1478,11 @@ udf_update_inode(struct inode *inode, int do_sync)
 		efe->descTag.tagIdent = cpu_to_le16(TAG_IDENT_EFE);
 		crclen = sizeof(struct extendedFileEntry);
 	}
-	if (UDF_I_STRAT4096(inode))
-	{
+	if (UDF_I_STRAT4096(inode)) {
 		fe->icbTag.strategyType = cpu_to_le16(4096);
 		fe->icbTag.strategyParameter = cpu_to_le16(1);
 		fe->icbTag.numEntries = cpu_to_le16(2);
-	}
-	else
-	{
+	} else {
 		fe->icbTag.strategyType = cpu_to_le16(4);
 		fe->icbTag.numEntries = cpu_to_le16(1);
 	}
@@ -1629,28 +1522,27 @@ udf_update_inode(struct inode *inode, int do_sync)
 	fe->descTag.descCRC = cpu_to_le16(udf_crc((char *)fe + sizeof(tag), crclen, 0));
 
 	fe->descTag.tagChecksum = 0;
-	for (i=0; i<16; i++)
+	for (i = 0; i < 16; i++) {
 		if (i != 4)
 			fe->descTag.tagChecksum += ((uint8_t *)&(fe->descTag))[i];
+	}
 
 	/* write the data blocks */
 	mark_buffer_dirty(bh);
-	if (do_sync)
-	{
+	if (do_sync) {
 		sync_dirty_buffer(bh);
-		if (buffer_req(bh) && !buffer_uptodate(bh))
-		{
+		if (buffer_req(bh) && !buffer_uptodate(bh)) {
 			printk("IO error syncing udf inode [%s:%08lx]\n",
-				inode->i_sb->s_id, inode->i_ino);
+			       inode->i_sb->s_id, inode->i_ino);
 			err = -EIO;
 		}
 	}
 	brelse(bh);
+
 	return err;
 }
 
-struct inode *
-udf_iget(struct super_block *sb, kernel_lb_addr ino)
+struct inode * udf_iget(struct super_block *sb, kernel_lb_addr ino)
 {
 	unsigned long block = udf_get_lb_pblock(sb, ino, 0);
 	struct inode *inode = iget_locked(sb, block);
@@ -1669,7 +1561,7 @@ udf_iget(struct super_block *sb, kernel_lb_addr ino)
 
 	if (ino.logicalBlockNum >= UDF_SB_PARTLEN(sb, ino.partitionReferenceNum)) {
 		udf_debug("block=%d, partition=%d out of range\n",
-			ino.logicalBlockNum, ino.partitionReferenceNum);
+			  ino.logicalBlockNum, ino.partitionReferenceNum);
 		make_bad_inode(inode);
 		goto out_iput;
 	}
@@ -1682,7 +1574,7 @@ udf_iget(struct super_block *sb, kernel_lb_addr ino)
 }
 
 int8_t udf_add_aext(struct inode *inode, struct extent_position *epos,
-	kernel_lb_addr eloc, uint32_t elen, int inc)
+		    kernel_lb_addr eloc, uint32_t elen, int inc)
 {
 	int adsize;
 	short_ad *sad = NULL;
@@ -1703,21 +1595,19 @@ int8_t udf_add_aext(struct inode *inode, struct extent_position *epos,
 	else
 		return -1;
 
-	if (epos->offset + (2 * adsize) > inode->i_sb->s_blocksize)
-	{
+	if (epos->offset + (2 * adsize) > inode->i_sb->s_blocksize) {
 		char *sptr, *dptr;
 		struct buffer_head *nbh;
 		int err, loffset;
 		kernel_lb_addr obloc = epos->block;
 
 		if (!(epos->block.logicalBlockNum = udf_new_block(inode->i_sb, NULL,
-			obloc.partitionReferenceNum, obloc.logicalBlockNum, &err)))
-		{
+								  obloc.partitionReferenceNum,
+								  obloc.logicalBlockNum, &err))) {
 			return -1;
 		}
 		if (!(nbh = udf_tgetblk(inode->i_sb, udf_get_lb_pblock(inode->i_sb,
-			epos->block, 0))))
-		{
+								       epos->block, 0)))) {
 			return -1;
 		}
 		lock_buffer(nbh);
@@ -1729,85 +1619,69 @@ int8_t udf_add_aext(struct inode *inode, struct extent_position *epos,
 		aed = (struct allocExtDesc *)(nbh->b_data);
 		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT))
 			aed->previousAllocExtLocation = cpu_to_le32(obloc.logicalBlockNum);
-		if (epos->offset + adsize > inode->i_sb->s_blocksize)
-		{
+		if (epos->offset + adsize > inode->i_sb->s_blocksize) {
 			loffset = epos->offset;
 			aed->lengthAllocDescs = cpu_to_le32(adsize);
 			sptr = ptr - adsize;
 			dptr = nbh->b_data + sizeof(struct allocExtDesc);
 			memcpy(dptr, sptr, adsize);
 			epos->offset = sizeof(struct allocExtDesc) + adsize;
-		}
-		else
-		{
+		} else {
 			loffset = epos->offset + adsize;
 			aed->lengthAllocDescs = cpu_to_le32(0);
 			sptr = ptr;
 			epos->offset = sizeof(struct allocExtDesc);
 
-			if (epos->bh)
-			{
+			if (epos->bh) {
 				aed = (struct allocExtDesc *)epos->bh->b_data;
 				aed->lengthAllocDescs =
 					cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) + adsize);
-			}
-			else
-			{
+			} else {
 				UDF_I_LENALLOC(inode) += adsize;
 				mark_inode_dirty(inode);
 			}
 		}
 		if (UDF_SB_UDFREV(inode->i_sb) >= 0x0200)
 			udf_new_tag(nbh->b_data, TAG_IDENT_AED, 3, 1,
-				epos->block.logicalBlockNum, sizeof(tag));
+				    epos->block.logicalBlockNum, sizeof(tag));
 		else
 			udf_new_tag(nbh->b_data, TAG_IDENT_AED, 2, 1,
-				epos->block.logicalBlockNum, sizeof(tag));
-		switch (UDF_I_ALLOCTYPE(inode))
-		{
+				    epos->block.logicalBlockNum, sizeof(tag));
+		switch (UDF_I_ALLOCTYPE(inode)) {
 			case ICBTAG_FLAG_AD_SHORT:
-			{
 				sad = (short_ad *)sptr;
-				sad->extLength = cpu_to_le32(
-					EXT_NEXT_EXTENT_ALLOCDECS |
-					inode->i_sb->s_blocksize);
+				sad->extLength = cpu_to_le32(EXT_NEXT_EXTENT_ALLOCDECS |
+							     inode->i_sb->s_blocksize);
 				sad->extPosition = cpu_to_le32(epos->block.logicalBlockNum);
 				break;
-			}
 			case ICBTAG_FLAG_AD_LONG:
-			{
 				lad = (long_ad *)sptr;
-				lad->extLength = cpu_to_le32(
-					EXT_NEXT_EXTENT_ALLOCDECS |
-					inode->i_sb->s_blocksize);
+				lad->extLength = cpu_to_le32(EXT_NEXT_EXTENT_ALLOCDECS |
+							     inode->i_sb->s_blocksize);
 				lad->extLocation = cpu_to_lelb(epos->block);
 				memset(lad->impUse, 0x00, sizeof(lad->impUse));
 				break;
-			}
 		}
-		if (epos->bh)
-		{
-			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+		if (epos->bh) {
+			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
+			    UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
 				udf_update_tag(epos->bh->b_data, loffset);
 			else
 				udf_update_tag(epos->bh->b_data, sizeof(struct allocExtDesc));
 			mark_buffer_dirty_inode(epos->bh, inode);
 			brelse(epos->bh);
-		}
-		else
+		} else {
 			mark_inode_dirty(inode);
+		}
 		epos->bh = nbh;
 	}
 
 	etype = udf_write_aext(inode, epos, eloc, elen, inc);
 
-	if (!epos->bh)
-	{
+	if (!epos->bh) {
 		UDF_I_LENALLOC(inode) += adsize;
 		mark_inode_dirty(inode);
-	}
-	else
-	{
+	} else {
 		aed = (struct allocExtDesc *)epos->bh->b_data;
 		aed->lengthAllocDescs =
 			cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) + adsize);
@@ -1822,72 +1696,67 @@ int8_t udf_add_aext(struct inode *inode, struct extent_position *epos,
 }
 
 int8_t udf_write_aext(struct inode *inode, struct extent_position *epos,
-    kernel_lb_addr eloc, uint32_t elen, int inc)
+		      kernel_lb_addr eloc, uint32_t elen, int inc)
 {
 	int adsize;
 	uint8_t *ptr;
+	short_ad *sad;
+	long_ad *lad;
 
 	if (!epos->bh)
 		ptr = UDF_I_DATA(inode) + epos->offset - udf_file_entry_alloc_offset(inode) + UDF_I_LENEATTR(inode);
 	else
 		ptr = epos->bh->b_data + epos->offset;
 
-	switch (UDF_I_ALLOCTYPE(inode))
-	{
+	switch (UDF_I_ALLOCTYPE(inode)) {
 		case ICBTAG_FLAG_AD_SHORT:
-		{
-			short_ad *sad = (short_ad *)ptr;
+			sad = (short_ad *)ptr;
 			sad->extLength = cpu_to_le32(elen);
 			sad->extPosition = cpu_to_le32(eloc.logicalBlockNum);
 			adsize = sizeof(short_ad);
 			break;
-		}
 		case ICBTAG_FLAG_AD_LONG:
-		{
-			long_ad *lad = (long_ad *)ptr;
+			lad = (long_ad *)ptr;
 			lad->extLength = cpu_to_le32(elen);
 			lad->extLocation = cpu_to_lelb(eloc);
 			memset(lad->impUse, 0x00, sizeof(lad->impUse));
 			adsize = sizeof(long_ad);
 			break;
-		}
 		default:
 			return -1;
 	}
 
-	if (epos->bh)
-	{
-		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
-		{
+	if (epos->bh) {
+		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
+		    UDF_SB_UDFREV(inode->i_sb) >= 0x0201) {
 			struct allocExtDesc *aed = (struct allocExtDesc *)epos->bh->b_data;
 			udf_update_tag(epos->bh->b_data,
-				le32_to_cpu(aed->lengthAllocDescs) + sizeof(struct allocExtDesc));
+				       le32_to_cpu(aed->lengthAllocDescs) + sizeof(struct allocExtDesc));
 		}
 		mark_buffer_dirty_inode(epos->bh, inode);
-	}
-	else
+	} else {
 		mark_inode_dirty(inode);
+	}
 
 	if (inc)
 		epos->offset += adsize;
+
 	return (elen >> 30);
 }
 
 int8_t udf_next_aext(struct inode *inode, struct extent_position *epos,
-	kernel_lb_addr *eloc, uint32_t *elen, int inc)
+		     kernel_lb_addr *eloc, uint32_t *elen, int inc)
 {
 	int8_t etype;
 
 	while ((etype = udf_current_aext(inode, epos, eloc, elen, inc)) ==
-		(EXT_NEXT_EXTENT_ALLOCDECS >> 30))
-	{
+	       (EXT_NEXT_EXTENT_ALLOCDECS >> 30)) {
 		epos->block = *eloc;
 		epos->offset = sizeof(struct allocExtDesc);
 		brelse(epos->bh);
-		if (!(epos->bh = udf_tread(inode->i_sb, udf_get_lb_pblock(inode->i_sb, epos->block, 0))))
-		{
+		if (!(epos->bh = udf_tread(inode->i_sb, udf_get_lb_pblock(inode->i_sb, epos->block, 0)))) {
 			udf_debug("reading block %d failed!\n",
-				udf_get_lb_pblock(inode->i_sb, epos->block, 0));
+				  udf_get_lb_pblock(inode->i_sb, epos->block, 0));
 			return -1;
 		}
 	}
@@ -1896,67 +1765,53 @@ int8_t udf_next_aext(struct inode *inode, struct extent_position *epos,
 }
 
 int8_t udf_current_aext(struct inode *inode, struct extent_position *epos,
-	kernel_lb_addr *eloc, uint32_t *elen, int inc)
+			kernel_lb_addr *eloc, uint32_t *elen, int inc)
 {
 	int alen;
 	int8_t etype;
 	uint8_t *ptr;
+	short_ad *sad;
+	long_ad *lad;
 
-	if (!epos->bh)
-	{
+
+	if (!epos->bh) {
 		if (!epos->offset)
 			epos->offset = udf_file_entry_alloc_offset(inode);
 		ptr = UDF_I_DATA(inode) + epos->offset - udf_file_entry_alloc_offset(inode) + UDF_I_LENEATTR(inode);
 		alen = udf_file_entry_alloc_offset(inode) + UDF_I_LENALLOC(inode);
-	}
-	else
-	{
+	} else {
 		if (!epos->offset)
 			epos->offset = sizeof(struct allocExtDesc);
 		ptr = epos->bh->b_data + epos->offset;
 		alen = sizeof(struct allocExtDesc) + le32_to_cpu(((struct allocExtDesc *)epos->bh->b_data)->lengthAllocDescs);
 	}
 
-	switch (UDF_I_ALLOCTYPE(inode))
-	{
+	switch (UDF_I_ALLOCTYPE(inode)) {
 		case ICBTAG_FLAG_AD_SHORT:
-		{
-			short_ad *sad;
-
 			if (!(sad = udf_get_fileshortad(ptr, alen, &epos->offset, inc)))
 				return -1;
-
 			etype = le32_to_cpu(sad->extLength) >> 30;
 			eloc->logicalBlockNum = le32_to_cpu(sad->extPosition);
 			eloc->partitionReferenceNum = UDF_I_LOCATION(inode).partitionReferenceNum;
 			*elen = le32_to_cpu(sad->extLength) & UDF_EXTENT_LENGTH_MASK;
 			break;
-		}
 		case ICBTAG_FLAG_AD_LONG:
-		{
-			long_ad *lad;
-
 			if (!(lad = udf_get_filelongad(ptr, alen, &epos->offset, inc)))
 				return -1;
-
 			etype = le32_to_cpu(lad->extLength) >> 30;
 			*eloc = lelb_to_cpu(lad->extLocation);
 			*elen = le32_to_cpu(lad->extLength) & UDF_EXTENT_LENGTH_MASK;
 			break;
-		}
 		default:
-		{
 			udf_debug("alloc_type = %d unsupported\n", UDF_I_ALLOCTYPE(inode));
 			return -1;
-		}
 	}
 
 	return etype;
 }
 
-static int8_t
-udf_insert_aext(struct inode *inode, struct extent_position epos,
-		kernel_lb_addr neloc, uint32_t nelen)
+static int8_t udf_insert_aext(struct inode *inode, struct extent_position epos,
+			      kernel_lb_addr neloc, uint32_t nelen)
 {
 	kernel_lb_addr oeloc;
 	uint32_t oelen;
@@ -1965,28 +1820,26 @@ udf_insert_aext(struct inode *inode, struct extent_position epos,
 	if (epos.bh)
 		get_bh(epos.bh);
 
-	while ((etype = udf_next_aext(inode, &epos, &oeloc, &oelen, 0)) != -1)
-	{
+	while ((etype = udf_next_aext(inode, &epos, &oeloc, &oelen, 0)) != -1) {
 		udf_write_aext(inode, &epos, neloc, nelen, 1);
-
 		neloc = oeloc;
 		nelen = (etype << 30) | oelen;
 	}
 	udf_add_aext(inode, &epos, neloc, nelen, 1);
 	brelse(epos.bh);
+
 	return (nelen >> 30);
 }
 
 int8_t udf_delete_aext(struct inode *inode, struct extent_position epos,
-	kernel_lb_addr eloc, uint32_t elen)
+		       kernel_lb_addr eloc, uint32_t elen)
 {
 	struct extent_position oepos;
 	int adsize;
 	int8_t etype;
 	struct allocExtDesc *aed;
 
-	if (epos.bh)
-	{
+	if (epos.bh) {
 		get_bh(epos.bh);
 		get_bh(epos.bh);
 	}
@@ -2002,11 +1855,9 @@ int8_t udf_delete_aext(struct inode *inode, struct extent_position epos,
 	if (udf_next_aext(inode, &epos, &eloc, &elen, 1) == -1)
 		return -1;
 
-	while ((etype = udf_next_aext(inode, &epos, &eloc, &elen, 1)) != -1)
-	{
+	while ((etype = udf_next_aext(inode, &epos, &eloc, &elen, 1)) != -1) {
 		udf_write_aext(inode, &oepos, eloc, (etype << 30) | elen, 1);
-		if (oepos.bh != epos.bh)
-		{
+		if (oepos.bh != epos.bh) {
 			oepos.block = epos.block;
 			brelse(oepos.bh);
 			get_bh(epos.bh);
@@ -2017,38 +1868,30 @@ int8_t udf_delete_aext(struct inode *inode, struct extent_position epos,
 	memset(&eloc, 0x00, sizeof(kernel_lb_addr));
 	elen = 0;
 
-	if (epos.bh != oepos.bh)
-	{
+	if (epos.bh != oepos.bh) {
 		udf_free_blocks(inode->i_sb, inode, epos.block, 0, 1);
 		udf_write_aext(inode, &oepos, eloc, elen, 1);
 		udf_write_aext(inode, &oepos, eloc, elen, 1);
-		if (!oepos.bh)
-		{
+		if (!oepos.bh) {
 			UDF_I_LENALLOC(inode) -= (adsize * 2);
 			mark_inode_dirty(inode);
-		}
-		else
-		{
+		} else {
 			aed = (struct allocExtDesc *)oepos.bh->b_data;
 			aed->lengthAllocDescs =
 				cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) - (2*adsize));
-			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
+			    UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
 				udf_update_tag(oepos.bh->b_data, oepos.offset - (2*adsize));
 			else
 				udf_update_tag(oepos.bh->b_data, sizeof(struct allocExtDesc));
 			mark_buffer_dirty_inode(oepos.bh, inode);
 		}
-	}
-	else
-	{
+	} else {
 		udf_write_aext(inode, &oepos, eloc, elen, 1);
-		if (!oepos.bh)
-		{
+		if (!oepos.bh) {
 			UDF_I_LENALLOC(inode) -= adsize;
 			mark_inode_dirty(inode);
-		}
-		else
-		{
+		} else {
 			aed = (struct allocExtDesc *)oepos.bh->b_data;
 			aed->lengthAllocDescs =
 				cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) - adsize);
@@ -2059,20 +1902,20 @@ int8_t udf_delete_aext(struct inode *inode, struct extent_position epos,
 			mark_buffer_dirty_inode(oepos.bh, inode);
 		}
 	}
-	
+
 	brelse(epos.bh);
 	brelse(oepos.bh);
+
 	return (elen >> 30);
 }
 
 int8_t inode_bmap(struct inode *inode, sector_t block, struct extent_position *pos,
-	kernel_lb_addr *eloc, uint32_t *elen, sector_t *offset)
+		  kernel_lb_addr *eloc, uint32_t *elen, sector_t *offset)
 {
 	loff_t lbcount = 0, bcount = (loff_t)block << inode->i_sb->s_blocksize_bits;
 	int8_t etype;
 
-	if (block < 0)
-	{
+	if (block < 0) {
 		printk(KERN_ERR "udf: inode_bmap: block < 0\n");
 		return -1;
 	}
@@ -2082,10 +1925,8 @@ int8_t inode_bmap(struct inode *inode, sector_t block, struct extent_position *p
 	pos->bh = NULL;
 	*elen = 0;
 
-	do
-	{
-		if ((etype = udf_next_aext(inode, pos, eloc, elen, 1)) == -1)
-		{
+	do {
+		if ((etype = udf_next_aext(inode, pos, eloc, elen, 1)) == -1) {
 			*offset = (bcount - lbcount) >> inode->i_sb->s_blocksize_bits;
 			UDF_I_LENEXTENTS(inode) = lbcount;
 			return -1;
@@ -2103,7 +1944,7 @@ long udf_block_map(struct inode *inode, sector_t block)
 	kernel_lb_addr eloc;
 	uint32_t elen;
 	sector_t offset;
-	struct extent_position epos = { NULL, 0, { 0, 0}};
+	struct extent_position epos = {};
 	int ret;
 
 	lock_kernel();
diff --git a/fs/udf/lowlevel.c b/fs/udf/lowlevel.c
index 0842161..ee02bff 100644
--- a/fs/udf/lowlevel.c
+++ b/fs/udf/lowlevel.c
@@ -26,8 +26,7 @@
 #include <linux/udf_fs.h>
 #include "udf_sb.h"
 
-unsigned int 
-udf_get_last_session(struct super_block *sb)
+unsigned int udf_get_last_session(struct super_block *sb)
 {
 	struct cdrom_multisession ms_info;
 	unsigned int vol_desc_start;
@@ -40,24 +39,20 @@ udf_get_last_session(struct super_block *sb)
 
 #define WE_OBEY_THE_WRITTEN_STANDARDS 1
 
-	if (i == 0)
-	{
+	if (i == 0) {
 		udf_debug("XA disk: %s, vol_desc_start=%d\n",
-			(ms_info.xa_flag ? "yes" : "no"), ms_info.addr.lba);
+			  (ms_info.xa_flag ? "yes" : "no"), ms_info.addr.lba);
 #if WE_OBEY_THE_WRITTEN_STANDARDS
 		if (ms_info.xa_flag) /* necessary for a valid ms_info.addr */
 #endif
 			vol_desc_start = ms_info.addr.lba;
-	}
-	else
-	{
+	} else {
 		udf_debug("CDROMMULTISESSION not supported: rc=%d\n", i);
 	}
 	return vol_desc_start;
 }
 
-unsigned long
-udf_get_last_block(struct super_block *sb)
+unsigned long udf_get_last_block(struct super_block *sb)
 {
 	struct block_device *bdev = sb->s_bdev;
 	unsigned long lblock = 0;
diff --git a/fs/udf/misc.c b/fs/udf/misc.c
index a2b2a98..b1c9e85 100644
--- a/fs/udf/misc.c
+++ b/fs/udf/misc.c
@@ -29,8 +29,7 @@
 #include "udf_i.h"
 #include "udf_sb.h"
 
-struct buffer_head *
-udf_tgetblk(struct super_block *sb, int block)
+struct buffer_head * udf_tgetblk(struct super_block *sb, int block)
 {
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_VARCONV))
 		return sb_getblk(sb, udf_fixed_to_variable(block));
@@ -38,8 +37,7 @@ udf_tgetblk(struct super_block *sb, int block)
 		return sb_getblk(sb, block);
 }
 
-struct buffer_head *
-udf_tread(struct super_block *sb, int block)
+struct buffer_head * udf_tread(struct super_block *sb, int block)
 {
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_VARCONV))
 		return sb_bread(sb, udf_fixed_to_variable(block));
@@ -47,9 +45,9 @@ udf_tread(struct super_block *sb, int block)
 		return sb_bread(sb, block);
 }
 
-struct genericFormat *
-udf_add_extendedattr(struct inode * inode, uint32_t size, uint32_t type,
-	uint8_t loc)
+struct genericFormat * udf_add_extendedattr(struct inode * inode,
+					    uint32_t size, uint32_t type,
+					    uint8_t loc)
 {
 	uint8_t *ea = NULL, *ad = NULL;
 	int offset;
@@ -57,10 +55,9 @@ udf_add_extendedattr(struct inode * inode, uint32_t size, uint32_t type,
 	int i;
 
 	ea = UDF_I_DATA(inode);
-	if (UDF_I_LENEATTR(inode))
+	if (UDF_I_LENEATTR(inode)) {
 		ad = UDF_I_DATA(inode) + UDF_I_LENEATTR(inode);
-	else
-	{
+	} else {
 		ad = ea;
 		size += sizeof(struct extendedAttrHeaderDesc);
 	}
@@ -70,27 +67,21 @@ udf_add_extendedattr(struct inode * inode, uint32_t size, uint32_t type,
 
 	/* TODO - Check for FreeEASpace */
 
-	if (loc & 0x01 && offset >= size)
-	{
+	if (loc & 0x01 && offset >= size) {
 		struct extendedAttrHeaderDesc *eahd;
 		eahd = (struct extendedAttrHeaderDesc *)ea;
 
-		if (UDF_I_LENALLOC(inode))
-		{
+		if (UDF_I_LENALLOC(inode)) {
 			memmove(&ad[size], ad, UDF_I_LENALLOC(inode));
 		}
 
-		if (UDF_I_LENEATTR(inode))
-		{
+		if (UDF_I_LENEATTR(inode)) {
 			/* check checksum/crc */
 			if (le16_to_cpu(eahd->descTag.tagIdent) != TAG_IDENT_EAHD ||
-				le32_to_cpu(eahd->descTag.tagLocation) != UDF_I_LOCATION(inode).logicalBlockNum)
-			{
+			    le32_to_cpu(eahd->descTag.tagLocation) != UDF_I_LOCATION(inode).logicalBlockNum) {
 				return NULL;
 			}
-		}
-		else
-		{
+		} else {
 			size -= sizeof(struct extendedAttrHeaderDesc);
 			UDF_I_LENEATTR(inode) += sizeof(struct extendedAttrHeaderDesc);
 			eahd->descTag.tagIdent = cpu_to_le16(TAG_IDENT_EAHD);
@@ -105,29 +96,23 @@ udf_add_extendedattr(struct inode * inode, uint32_t size, uint32_t type,
 		}
 
 		offset = UDF_I_LENEATTR(inode);
-		if (type < 2048)
-		{
-			if (le32_to_cpu(eahd->appAttrLocation) < UDF_I_LENEATTR(inode))
-			{
+		if (type < 2048) {
+			if (le32_to_cpu(eahd->appAttrLocation) < UDF_I_LENEATTR(inode)) {
 				uint32_t aal = le32_to_cpu(eahd->appAttrLocation);
 				memmove(&ea[offset - aal + size],
 					&ea[aal], offset - aal);
 				offset -= aal;
 				eahd->appAttrLocation = cpu_to_le32(aal + size);
 			}
-			if (le32_to_cpu(eahd->impAttrLocation) < UDF_I_LENEATTR(inode))
-			{
+			if (le32_to_cpu(eahd->impAttrLocation) < UDF_I_LENEATTR(inode)) {
 				uint32_t ial = le32_to_cpu(eahd->impAttrLocation);
 				memmove(&ea[offset - ial + size],
 					&ea[ial], offset - ial);
 				offset -= ial;
 				eahd->impAttrLocation = cpu_to_le32(ial + size);
 			}
-		}
-		else if (type < 65536)
-		{
-			if (le32_to_cpu(eahd->appAttrLocation) < UDF_I_LENEATTR(inode))
-			{
+		} else if (type < 65536) {
+			if (le32_to_cpu(eahd->appAttrLocation) < UDF_I_LENEATTR(inode)) {
 				uint32_t aal = le32_to_cpu(eahd->appAttrLocation);
 				memmove(&ea[offset - aal + size],
 					&ea[aal], offset - aal);
@@ -138,22 +123,22 @@ udf_add_extendedattr(struct inode * inode, uint32_t size, uint32_t type,
 		/* rewrite CRC + checksum of eahd */
 		crclen = sizeof(struct extendedAttrHeaderDesc) - sizeof(tag);
 		eahd->descTag.descCRCLength = cpu_to_le16(crclen);
-		eahd->descTag.descCRC = cpu_to_le16(udf_crc((char *)eahd + sizeof(tag), crclen, 0));
+		eahd->descTag.descCRC = cpu_to_le16(udf_crc((char *)eahd +
+							    sizeof(tag), crclen, 0));
 		eahd->descTag.tagChecksum = 0;
-		for (i=0; i<16; i++)
+		for (i = 0; i < 16; i++)
 			if (i != 4)
 				eahd->descTag.tagChecksum += ((uint8_t *)&(eahd->descTag))[i];
 		UDF_I_LENEATTR(inode) += size;
 		return (struct genericFormat *)&ea[offset];
 	}
-	if (loc & 0x02)
-	{
+	if (loc & 0x02) {
 	}
+
 	return NULL;
 }
 
-struct genericFormat *
-udf_get_extendedattr(struct inode *inode, uint32_t type, uint8_t subtype)
+struct genericFormat * udf_get_extendedattr(struct inode *inode, uint32_t type, uint8_t subtype)
 {
 	struct genericFormat *gaf;
 	uint8_t *ea = NULL;
@@ -161,18 +146,16 @@ udf_get_extendedattr(struct inode *inode, uint32_t type, uint8_t subtype)
 
 	ea = UDF_I_DATA(inode);
 
-	if (UDF_I_LENEATTR(inode))
-	{
+	if (UDF_I_LENEATTR(inode)) {
 		struct extendedAttrHeaderDesc *eahd;
 		eahd = (struct extendedAttrHeaderDesc *)ea;
 
 		/* check checksum/crc */
 		if (le16_to_cpu(eahd->descTag.tagIdent) != TAG_IDENT_EAHD ||
-			le32_to_cpu(eahd->descTag.tagLocation) != UDF_I_LOCATION(inode).logicalBlockNum)
-		{
+		    le32_to_cpu(eahd->descTag.tagLocation) != UDF_I_LOCATION(inode).logicalBlockNum) {
 			return NULL;
 		}
-	
+
 		if (type < 2048)
 			offset = sizeof(struct extendedAttrHeaderDesc);
 		else if (type < 65536)
@@ -180,8 +163,7 @@ udf_get_extendedattr(struct inode *inode, uint32_t type, uint8_t subtype)
 		else
 			offset = le32_to_cpu(eahd->appAttrLocation);
 
-		while (offset < UDF_I_LENEATTR(inode))
-		{
+		while (offset < UDF_I_LENEATTR(inode)) {
 			gaf = (struct genericFormat *)&ea[offset];
 			if (le32_to_cpu(gaf->attrType) == type && gaf->attrSubtype == subtype)
 				return gaf;
@@ -189,6 +171,7 @@ udf_get_extendedattr(struct inode *inode, uint32_t type, uint8_t subtype)
 				offset += le32_to_cpu(gaf->attrLength);
 		}
 	}
+
 	return NULL;
 }
 
@@ -202,8 +185,8 @@ udf_get_extendedattr(struct inode *inode, uint32_t type, uint8_t subtype)
  *	July 1, 1997 - Andrew E. Mileski
  *	Written, tested, and released.
  */
-struct buffer_head *
-udf_read_tagged(struct super_block *sb, uint32_t block, uint32_t location, uint16_t *ident)
+struct buffer_head * udf_read_tagged(struct super_block *sb, uint32_t block,
+				     uint32_t location, uint16_t *ident)
 {
 	tag *tag_p;
 	struct buffer_head *bh = NULL;
@@ -215,9 +198,9 @@ udf_read_tagged(struct super_block *sb, uint32_t block, uint32_t location, uint1
 		return NULL;
 
 	bh = udf_tread(sb, block + UDF_SB_SESSION(sb));
-	if (!bh)
-	{
-		udf_debug("block=%d, location=%d: read failed\n", block + UDF_SB_SESSION(sb), location);
+	if (!bh) {
+		udf_debug("block=%d, location=%d: read failed\n",
+			  block + UDF_SB_SESSION(sb), location);
 		return NULL;
 	}
 
@@ -225,13 +208,12 @@ udf_read_tagged(struct super_block *sb, uint32_t block, uint32_t location, uint1
 
 	*ident = le16_to_cpu(tag_p->tagIdent);
 
-	if ( location != le32_to_cpu(tag_p->tagLocation) )
-	{
+	if (location != le32_to_cpu(tag_p->tagLocation)) {
 		udf_debug("location mismatch block %u, tag %u != %u\n",
-			block + UDF_SB_SESSION(sb), le32_to_cpu(tag_p->tagLocation), location);
+			  block + UDF_SB_SESSION(sb), le32_to_cpu(tag_p->tagLocation), location);
 		goto error_out;
 	}
-	
+
 	/* Verify the tag checksum */
 	checksum = 0U;
 	for (i = 0; i < 4; i++)
@@ -245,33 +227,32 @@ udf_read_tagged(struct super_block *sb, uint32_t block, uint32_t location, uint1
 
 	/* Verify the tag version */
 	if (le16_to_cpu(tag_p->descVersion) != 0x0002U &&
-		le16_to_cpu(tag_p->descVersion) != 0x0003U)
-	{
+	    le16_to_cpu(tag_p->descVersion) != 0x0003U) {
 		udf_debug("tag version 0x%04x != 0x0002 || 0x0003 block %d\n",
-			le16_to_cpu(tag_p->descVersion), block);
+			  le16_to_cpu(tag_p->descVersion), block);
 		goto error_out;
 	}
 
 	/* Verify the descriptor CRC */
 	if (le16_to_cpu(tag_p->descCRCLength) + sizeof(tag) > sb->s_blocksize ||
-		le16_to_cpu(tag_p->descCRC) == udf_crc(bh->b_data + sizeof(tag),
-			le16_to_cpu(tag_p->descCRCLength), 0))
-	{
+	    le16_to_cpu(tag_p->descCRC) == udf_crc(bh->b_data + sizeof(tag),
+						   le16_to_cpu(tag_p->descCRCLength), 0)) {
 		return bh;
 	}
 	udf_debug("Crc failure block %d: crc = %d, crclen = %d\n",
-		block + UDF_SB_SESSION(sb), le16_to_cpu(tag_p->descCRC), le16_to_cpu(tag_p->descCRCLength));
+		  block + UDF_SB_SESSION(sb), le16_to_cpu(tag_p->descCRC),
+		  le16_to_cpu(tag_p->descCRCLength));
 
 error_out:
 	brelse(bh);
 	return NULL;
 }
 
-struct buffer_head *
-udf_read_ptagged(struct super_block *sb, kernel_lb_addr loc, uint32_t offset, uint16_t *ident)
+struct buffer_head * udf_read_ptagged(struct super_block *sb, kernel_lb_addr loc,
+				      uint32_t offset, uint16_t *ident)
 {
 	return udf_read_tagged(sb, udf_get_lb_pblock(sb, loc, offset),
-		loc.logicalBlockNum + offset, ident);
+			       loc.logicalBlockNum + offset, ident);
 }
 
 void udf_update_tag(char *data, int length)
@@ -285,13 +266,13 @@ void udf_update_tag(char *data, int length)
 	tptr->descCRCLength = cpu_to_le16(length);
 	tptr->descCRC = cpu_to_le16(udf_crc(data + sizeof(tag), length, 0));
 
-	for (i=0; i<16; i++)
+	for (i = 0; i < 16; i++)
 		if (i != 4)
 			tptr->tagChecksum += (uint8_t)(data[i]);
 }
 
 void udf_new_tag(char *data, uint16_t ident, uint16_t version, uint16_t snum,
-	uint32_t loc, int length)
+		 uint32_t loc, int length)
 {
 	tag *tptr = (tag *)data;
 	tptr->tagIdent = cpu_to_le16(ident);
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 51fe307..a439337 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -36,12 +36,13 @@ static inline int udf_match(int len1, const char *name1, int len2, const char *n
 {
 	if (len1 != len2)
 		return 0;
+
 	return !memcmp(name1, name2, len1);
 }
 
 int udf_write_fi(struct inode *inode, struct fileIdentDesc *cfi,
-	struct fileIdentDesc *sfi, struct udf_fileident_bh *fibh,
-	uint8_t *impuse, uint8_t *fileident)
+		 struct fileIdentDesc *sfi, struct udf_fileident_bh *fibh,
+		 uint8_t *impuse, uint8_t *fileident)
 {
 	uint16_t crclen = fibh->eoffset - fibh->soffset - sizeof(tag);
 	uint16_t crc;
@@ -59,14 +60,12 @@ int udf_write_fi(struct inode *inode, struct fileIdentDesc *cfi,
 
 	offset = fibh->soffset + sizeof(struct fileIdentDesc);
 
-	if (impuse)
-	{
-		if (adinicb || (offset + liu < 0))
+	if (impuse) {
+		if (adinicb || (offset + liu < 0)) {
 			memcpy((uint8_t *)sfi->impUse, impuse, liu);
-		else if (offset >= 0)
+		} else if (offset >= 0) {
 			memcpy(fibh->ebh->b_data + offset, impuse, liu);
-		else
-		{
+		} else {
 			memcpy((uint8_t *)sfi->impUse, impuse, -offset);
 			memcpy(fibh->ebh->b_data, impuse - offset, liu + offset);
 		}
@@ -74,14 +73,12 @@ int udf_write_fi(struct inode *inode, struct fileIdentDesc *cfi,
 
 	offset += liu;
 
-	if (fileident)
-	{
-		if (adinicb || (offset + lfi < 0))
+	if (fileident) {
+		if (adinicb || (offset + lfi < 0)) {
 			memcpy((uint8_t *)sfi->fileIdent + liu, fileident, lfi);
-		else if (offset >= 0)
+		} else if (offset >= 0) {
 			memcpy(fibh->ebh->b_data + offset, fileident, lfi);
-		else
-		{
+		} else {
 			memcpy((uint8_t *)sfi->fileIdent + liu, fileident, -offset);
 			memcpy(fibh->ebh->b_data, fileident - offset, lfi + offset);
 		}
@@ -89,53 +86,50 @@ int udf_write_fi(struct inode *inode, struct fileIdentDesc *cfi,
 
 	offset += lfi;
 
-	if (adinicb || (offset + padlen < 0))
+	if (adinicb || (offset + padlen < 0)) {
 		memset((uint8_t *)sfi->padding + liu + lfi, 0x00, padlen);
-	else if (offset >= 0)
+	} else if (offset >= 0) {
 		memset(fibh->ebh->b_data + offset, 0x00, padlen);
-	else
-	{
+	} else {
 		memset((uint8_t *)sfi->padding + liu + lfi, 0x00, -offset);
 		memset(fibh->ebh->b_data, 0x00, padlen + offset);
 	}
 
-	crc = udf_crc((uint8_t *)cfi + sizeof(tag), sizeof(struct fileIdentDesc) -
-		sizeof(tag), 0);
+	crc = udf_crc((uint8_t *)cfi + sizeof(tag),
+		      sizeof(struct fileIdentDesc) - sizeof(tag), 0);
 
-	if (fibh->sbh == fibh->ebh)
+	if (fibh->sbh == fibh->ebh) {
 		crc = udf_crc((uint8_t *)sfi->impUse,
-			crclen + sizeof(tag) - sizeof(struct fileIdentDesc), crc);
-	else if (sizeof(struct fileIdentDesc) >= -fibh->soffset)
+			      crclen + sizeof(tag) - sizeof(struct fileIdentDesc), crc);
+	} else if (sizeof(struct fileIdentDesc) >= -fibh->soffset) {
 		crc = udf_crc(fibh->ebh->b_data + sizeof(struct fileIdentDesc) + fibh->soffset,
-			crclen + sizeof(tag) - sizeof(struct fileIdentDesc), crc);
-	else
-	{
+			      crclen + sizeof(tag) - sizeof(struct fileIdentDesc), crc);
+	} else {
 		crc = udf_crc((uint8_t *)sfi->impUse,
-			-fibh->soffset - sizeof(struct fileIdentDesc), crc);
+			      -fibh->soffset - sizeof(struct fileIdentDesc), crc);
 		crc = udf_crc(fibh->ebh->b_data, fibh->eoffset, crc);
 	}
 
 	cfi->descTag.descCRC = cpu_to_le16(crc);
 	cfi->descTag.descCRCLength = cpu_to_le16(crclen);
 
-	for (i=0; i<16; i++)
+	for (i = 0; i < 16; i++) {
 		if (i != 4)
 			checksum += ((uint8_t *)&cfi->descTag)[i];
+	}
 
 	cfi->descTag.tagChecksum = checksum;
-	if (adinicb || (sizeof(struct fileIdentDesc) <= -fibh->soffset))
+	if (adinicb || (sizeof(struct fileIdentDesc) <= -fibh->soffset)) {
 		memcpy((uint8_t *)sfi, (uint8_t *)cfi, sizeof(struct fileIdentDesc));
-	else
-	{
+	} else {
 		memcpy((uint8_t *)sfi, (uint8_t *)cfi, -fibh->soffset);
 		memcpy(fibh->ebh->b_data, (uint8_t *)cfi - fibh->soffset,
-			sizeof(struct fileIdentDesc) + fibh->soffset);
+		       sizeof(struct fileIdentDesc) + fibh->soffset);
 	}
 
-	if (adinicb)
+	if (adinicb) {
 		mark_inode_dirty(inode);
-	else
-	{
+	} else {
 		if (fibh->sbh != fibh->ebh)
 			mark_buffer_dirty_inode(fibh->ebh, inode);
 		mark_buffer_dirty_inode(fibh->sbh, inode);
@@ -143,12 +137,11 @@ int udf_write_fi(struct inode *inode, struct fileIdentDesc *cfi,
 	return 0;
 }
 
-static struct fileIdentDesc *
-udf_find_entry(struct inode *dir, struct dentry *dentry,
-	struct udf_fileident_bh *fibh,
-	struct fileIdentDesc *cfi)
+static struct fileIdentDesc * udf_find_entry(struct inode *dir, struct dentry *dentry,
+					     struct udf_fileident_bh *fibh,
+					     struct fileIdentDesc *cfi)
 {
-	struct fileIdentDesc *fi=NULL;
+	struct fileIdentDesc *fi = NULL;
 	loff_t f_pos;
 	int block, flen;
 	char fname[UDF_NAME_LEN];
@@ -159,46 +152,38 @@ udf_find_entry(struct inode *dir, struct dentry *dentry,
 	kernel_lb_addr eloc;
 	uint32_t elen;
 	sector_t offset;
-	struct extent_position epos = { NULL, 0, { 0, 0}};
+	struct extent_position epos = {};
 
 	size = (udf_ext0_offset(dir) + dir->i_size) >> 2;
 	f_pos = (udf_ext0_offset(dir) >> 2);
 
 	fibh->soffset = fibh->eoffset = (f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		fibh->sbh = fibh->ebh = NULL;
-	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
-		&epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30))
-	{
+	} else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
+			      &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
-		if ((++offset << dir->i_sb->s_blocksize_bits) < elen)
-		{
+		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
 			else if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_LONG)
 				epos.offset -= sizeof(long_ad);
-		}
-		else
+		} else {
 			offset = 0;
+		}
 
-		if (!(fibh->sbh = fibh->ebh = udf_tread(dir->i_sb, block)))
-		{
+		if (!(fibh->sbh = fibh->ebh = udf_tread(dir->i_sb, block))) {
 			brelse(epos.bh);
 			return NULL;
 		}
-	}
-	else
-	{
+	} else {
 		brelse(epos.bh);
 		return NULL;
 	}
 
-	while ( (f_pos < size) )
-	{
+	while (f_pos < size) {
 		fi = udf_fileident_read(dir, &f_pos, fibh, cfi, &epos, &eloc, &elen, &offset);
-
-		if (!fi)
-		{
+		if (!fi) {
 			if (fibh->sbh != fibh->ebh)
 				brelse(fibh->ebh);
 			brelse(fibh->sbh);
@@ -209,54 +194,48 @@ udf_find_entry(struct inode *dir, struct dentry *dentry,
 		liu = le16_to_cpu(cfi->lengthOfImpUse);
 		lfi = cfi->lengthFileIdent;
 
-		if (fibh->sbh == fibh->ebh)
-		{
+		if (fibh->sbh == fibh->ebh) {
 			nameptr = fi->fileIdent + liu;
-		}
-		else
-		{
+		} else {
 			int poffset;	/* Unpaded ending offset */
 
 			poffset = fibh->soffset + sizeof(struct fileIdentDesc) + liu + lfi;
 
-			if (poffset >= lfi)
+			if (poffset >= lfi) {
 				nameptr = (uint8_t *)(fibh->ebh->b_data + poffset - lfi);
-			else
-			{
+			} else {
 				nameptr = fname;
 				memcpy(nameptr, fi->fileIdent + liu, lfi - poffset);
 				memcpy(nameptr + lfi - poffset, fibh->ebh->b_data, poffset);
 			}
 		}
 
-		if ( (cfi->fileCharacteristics & FID_FILE_CHAR_DELETED) != 0 )
-		{
-			if ( !UDF_QUERY_FLAG(dir->i_sb, UDF_FLAG_UNDELETE) )
+		if ((cfi->fileCharacteristics & FID_FILE_CHAR_DELETED) != 0) {
+			if (!UDF_QUERY_FLAG(dir->i_sb, UDF_FLAG_UNDELETE))
 				continue;
 		}
-	    
-		if ( (cfi->fileCharacteristics & FID_FILE_CHAR_HIDDEN) != 0 )
-		{
-			if ( !UDF_QUERY_FLAG(dir->i_sb, UDF_FLAG_UNHIDE) )
+
+		if ((cfi->fileCharacteristics & FID_FILE_CHAR_HIDDEN) != 0) {
+			if (!UDF_QUERY_FLAG(dir->i_sb, UDF_FLAG_UNHIDE))
 				continue;
 		}
 
 		if (!lfi)
 			continue;
 
-		if ((flen = udf_get_filename(dir->i_sb, nameptr, fname, lfi)))
-		{
-			if (udf_match(flen, fname, dentry->d_name.len, dentry->d_name.name))
-			{
+		if ((flen = udf_get_filename(dir->i_sb, nameptr, fname, lfi))) {
+			if (udf_match(flen, fname, dentry->d_name.len, dentry->d_name.name)) {
 				brelse(epos.bh);
 				return fi;
 			}
 		}
 	}
+
 	if (fibh->sbh != fibh->ebh)
 		brelse(fibh->ebh);
 	brelse(fibh->sbh);
 	brelse(epos.bh);
+
 	return NULL;
 }
 
@@ -293,25 +272,26 @@ udf_find_entry(struct inode *dir, struct dentry *dentry,
  *	Written, tested, and released.
  */
 
-static struct dentry *
-udf_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry * udf_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 {
 	struct inode *inode = NULL;
 	struct fileIdentDesc cfi;
 	struct udf_fileident_bh fibh;
 
-	if (dentry->d_name.len > UDF_NAME_LEN-2)
+	if (dentry->d_name.len > UDF_NAME_LEN - 2)
 		return ERR_PTR(-ENAMETOOLONG);
 
 	lock_kernel();
 #ifdef UDF_RECOVERY
 	/* temporary shorthand for specifying files by inode number */
-	if (!strncmp(dentry->d_name.name, ".B=", 3) )
-	{
-		kernel_lb_addr lb = { 0, simple_strtoul(dentry->d_name.name+3, NULL, 0) };
+	if (!strncmp(dentry->d_name.name, ".B=", 3)) {
+		kernel_lb_addr lb = {
+			.logicalBlockNum = 0,
+			.partitionReferenceNum = simple_strtoul(dentry->d_name.name + 3,
+								NULL, 0),
+		};
 		inode = udf_iget(dir->i_sb, lb);
-		if (!inode)
-		{
+		if (!inode) {
 			unlock_kernel();
 			return ERR_PTR(-EACCES);
 		}
@@ -319,31 +299,29 @@ udf_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 	else
 #endif /* UDF_RECOVERY */
 
-	if (udf_find_entry(dir, dentry, &fibh, &cfi))
-	{
+	if (udf_find_entry(dir, dentry, &fibh, &cfi)) {
 		if (fibh.sbh != fibh.ebh)
 			brelse(fibh.ebh);
 		brelse(fibh.sbh);
 
 		inode = udf_iget(dir->i_sb, lelb_to_cpu(cfi.icb.extLocation));
-		if ( !inode )
-		{
+		if (!inode) {
 			unlock_kernel();
 			return ERR_PTR(-EACCES);
 		}
 	}
 	unlock_kernel();
 	d_add(dentry, inode);
+
 	return NULL;
 }
 
-static struct fileIdentDesc *
-udf_add_entry(struct inode *dir, struct dentry *dentry,
-	struct udf_fileident_bh *fibh,
-	struct fileIdentDesc *cfi, int *err)
+static struct fileIdentDesc * udf_add_entry(struct inode *dir, struct dentry *dentry,
+					    struct udf_fileident_bh *fibh,
+					    struct fileIdentDesc *cfi, int *err)
 {
 	struct super_block *sb;
-	struct fileIdentDesc *fi=NULL;
+	struct fileIdentDesc *fi = NULL;
 	char name[UDF_NAME_LEN], fname[UDF_NAME_LEN];
 	int namelen;
 	loff_t f_pos;
@@ -357,50 +335,44 @@ udf_add_entry(struct inode *dir, struct dentry *dentry,
 	kernel_lb_addr eloc;
 	uint32_t elen;
 	sector_t offset;
-	struct extent_position epos = { NULL, 0, { 0, 0 }};
+	struct extent_position epos = {};
 
 	sb = dir->i_sb;
 
-	if (dentry)
-	{
-		if (!dentry->d_name.len)
-		{
+	if (dentry) {
+		if (!dentry->d_name.len) {
 			*err = -EINVAL;
 			return NULL;
 		}
-
-		if ( !(namelen = udf_put_filename(sb, dentry->d_name.name, name, dentry->d_name.len)))
-		{
+		if (!(namelen = udf_put_filename(sb, dentry->d_name.name, name,
+						 dentry->d_name.len))) {
 			*err = -ENAMETOOLONG;
 			return NULL;
 		}
-	}
-	else
+	} else {
 		namelen = 0;
+	}
 
 	nfidlen = (sizeof(struct fileIdentDesc) + namelen + 3) & ~3;
 
 	f_pos = (udf_ext0_offset(dir) >> 2);
 
 	fibh->soffset = fibh->eoffset = (f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		fibh->sbh = fibh->ebh = NULL;
-	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
-		&epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30))
-	{
+	} else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
+			      &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
-		if ((++offset << dir->i_sb->s_blocksize_bits) < elen)
-		{
+		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
 			else if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_LONG)
 				epos.offset -= sizeof(long_ad);
-		}
-		else
+		} else {
 			offset = 0;
+		}
 
-		if (!(fibh->sbh = fibh->ebh = udf_tread(dir->i_sb, block)))
-		{
+		if (!(fibh->sbh = fibh->ebh = udf_tread(dir->i_sb, block))) {
 			brelse(epos.bh);
 			*err = -EIO;
 			return NULL;
@@ -408,21 +380,16 @@ udf_add_entry(struct inode *dir, struct dentry *dentry,
 
 		block = UDF_I_LOCATION(dir).logicalBlockNum;
 
-	}
-	else
-	{
+	} else {
 		block = udf_get_lb_pblock(dir->i_sb, UDF_I_LOCATION(dir), 0);
 		fibh->sbh = fibh->ebh = NULL;
 		fibh->soffset = fibh->eoffset = sb->s_blocksize;
 		goto add;
 	}
 
-	while ( (f_pos < size) )
-	{
+	while (f_pos < size) {
 		fi = udf_fileident_read(dir, &f_pos, fibh, cfi, &epos, &eloc, &elen, &offset);
-
-		if (!fi)
-		{
+		if (!fi) {
 			if (fibh->sbh != fibh->ebh)
 				brelse(fibh->ebh);
 			brelse(fibh->sbh);
@@ -434,38 +401,33 @@ udf_add_entry(struct inode *dir, struct dentry *dentry,
 		liu = le16_to_cpu(cfi->lengthOfImpUse);
 		lfi = cfi->lengthFileIdent;
 
-		if (fibh->sbh == fibh->ebh)
+		if (fibh->sbh == fibh->ebh) {
 			nameptr = fi->fileIdent + liu;
-		else
-		{
+		} else {
 			int poffset;	/* Unpaded ending offset */
 
 			poffset = fibh->soffset + sizeof(struct fileIdentDesc) + liu + lfi;
 
-			if (poffset >= lfi)
+			if (poffset >= lfi) {
 				nameptr = (char *)(fibh->ebh->b_data + poffset - lfi);
-			else
-			{
+			} else {
 				nameptr = fname;
 				memcpy(nameptr, fi->fileIdent + liu, lfi - poffset);
 				memcpy(nameptr + lfi - poffset, fibh->ebh->b_data, poffset);
 			}
 		}
 
-		if ( (cfi->fileCharacteristics & FID_FILE_CHAR_DELETED) != 0 )
-		{
-			if (((sizeof(struct fileIdentDesc) + liu + lfi + 3) & ~3) == nfidlen)
-			{
+		if ((cfi->fileCharacteristics & FID_FILE_CHAR_DELETED) != 0) {
+			if (((sizeof(struct fileIdentDesc) + liu + lfi + 3) & ~3) == nfidlen) {
 				brelse(epos.bh);
 				cfi->descTag.tagSerialNum = cpu_to_le16(1);
 				cfi->fileVersionNum = cpu_to_le16(1);
 				cfi->fileCharacteristics = 0;
 				cfi->lengthFileIdent = namelen;
 				cfi->lengthOfImpUse = cpu_to_le16(0);
-				if (!udf_write_fi(dir, cfi, fi, fibh, NULL, name))
+				if (!udf_write_fi(dir, cfi, fi, fibh, NULL, name)) {
 					return fi;
-				else
-				{
+				} else {
 					*err = -EIO;
 					return NULL;
 				}
@@ -476,8 +438,7 @@ udf_add_entry(struct inode *dir, struct dentry *dentry,
 			continue;
 
 		if ((flen = udf_get_filename(dir->i_sb, nameptr, fname, lfi)) &&
-			udf_match(flen, fname, dentry->d_name.len, dentry->d_name.name))
-		{
+		    udf_match(flen, fname, dentry->d_name.len, dentry->d_name.name)) {
 			if (fibh->sbh != fibh->ebh)
 				brelse(fibh->ebh);
 			brelse(fibh->sbh);
@@ -491,8 +452,7 @@ add:
 	f_pos += nfidlen;
 
 	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB &&
-		sb->s_blocksize - fibh->eoffset < nfidlen)
-	{
+	    sb->s_blocksize - fibh->eoffset < nfidlen) {
 		brelse(epos.bh);
 		epos.bh = NULL;
 		fibh->soffset -= udf_ext0_offset(dir);
@@ -514,65 +474,54 @@ add:
 			epos.offset += sizeof(long_ad);
 	}
 
-	if (sb->s_blocksize - fibh->eoffset >= nfidlen)
-	{
+	if (sb->s_blocksize - fibh->eoffset >= nfidlen) {
 		fibh->soffset = fibh->eoffset;
 		fibh->eoffset += nfidlen;
-		if (fibh->sbh != fibh->ebh)
-		{
+		if (fibh->sbh != fibh->ebh) {
 			brelse(fibh->sbh);
 			fibh->sbh = fibh->ebh;
 		}
 
-		if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
-		{
+		if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 			block = UDF_I_LOCATION(dir).logicalBlockNum;
-			fi = (struct fileIdentDesc *)(UDF_I_DATA(dir) + fibh->soffset - udf_ext0_offset(dir) + UDF_I_LENEATTR(dir));
-		}
-		else
-		{
+			fi = (struct fileIdentDesc *)(UDF_I_DATA(dir) + fibh->soffset -
+						      udf_ext0_offset(dir) +
+						      UDF_I_LENEATTR(dir));
+		} else {
 			block = eloc.logicalBlockNum + ((elen - 1) >>
-				dir->i_sb->s_blocksize_bits);
+							dir->i_sb->s_blocksize_bits);
 			fi = (struct fileIdentDesc *)(fibh->sbh->b_data + fibh->soffset);
 		}
-	}
-	else
-	{
+	} else {
 		fibh->soffset = fibh->eoffset - sb->s_blocksize;
 		fibh->eoffset += nfidlen - sb->s_blocksize;
-		if (fibh->sbh != fibh->ebh)
-		{
+		if (fibh->sbh != fibh->ebh) {
 			brelse(fibh->sbh);
 			fibh->sbh = fibh->ebh;
 		}
 
 		block = eloc.logicalBlockNum + ((elen - 1) >>
-			dir->i_sb->s_blocksize_bits);
-
-		if (!(fibh->ebh = udf_bread(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2), 1, err)))
-		{
+						dir->i_sb->s_blocksize_bits);
+		fibh->ebh = udf_bread(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2), 1, err);
+		if (!fibh->ebh) {
 			brelse(epos.bh);
 			brelse(fibh->sbh);
 			return NULL;
 		}
 
-		if (!(fibh->soffset))
-		{
+		if (!fibh->soffset) {
 			if (udf_next_aext(dir, &epos, &eloc, &elen, 1) ==
-				(EXT_RECORDED_ALLOCATED >> 30))
-			{
+			    (EXT_RECORDED_ALLOCATED >> 30)) {
 				block = eloc.logicalBlockNum + ((elen - 1) >>
 					dir->i_sb->s_blocksize_bits);
+			} else {
+				block++;
 			}
-			else
-				block ++;
 
 			brelse(fibh->sbh);
 			fibh->sbh = fibh->ebh;
 			fi = (struct fileIdentDesc *)(fibh->sbh->b_data);
-		}
-		else
-		{
+		} else {
 			fi = (struct fileIdentDesc *)
 				(fibh->sbh->b_data + sb->s_blocksize + fibh->soffset);
 		}
@@ -586,17 +535,14 @@ add:
 	cfi->fileVersionNum = cpu_to_le16(1);
 	cfi->lengthFileIdent = namelen;
 	cfi->lengthOfImpUse = cpu_to_le16(0);
-	if (!udf_write_fi(dir, cfi, fi, fibh, NULL, name))
-	{
+	if (!udf_write_fi(dir, cfi, fi, fibh, NULL, name)) {
 		brelse(epos.bh);
 		dir->i_size += nfidlen;
 		if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
 			UDF_I_LENALLOC(dir) += nfidlen;
 		mark_inode_dirty(dir);
 		return fi;
-	}
-	else
-	{
+	} else {
 		brelse(epos.bh);
 		if (fibh->sbh != fibh->ebh)
 			brelse(fibh->ebh);
@@ -607,11 +553,13 @@ add:
 }
 
 static int udf_delete_entry(struct inode *inode, struct fileIdentDesc *fi,
-	struct udf_fileident_bh *fibh, struct fileIdentDesc *cfi)
+			    struct udf_fileident_bh *fibh, struct fileIdentDesc *cfi)
 {
 	cfi->fileCharacteristics |= FID_FILE_CHAR_DELETED;
+
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT))
 		memset(&(cfi->icb), 0x00, sizeof(long_ad));
+
 	return udf_write_fi(inode, cfi, fi, fibh, NULL, NULL);
 }
 
@@ -624,8 +572,7 @@ static int udf_create(struct inode *dir, struct dentry *dentry, int mode, struct
 
 	lock_kernel();
 	inode = udf_new_inode(dir, mode, &err);
-	if (!inode)
-	{
+	if (!inode) {
 		unlock_kernel();
 		return err;
 	}
@@ -634,13 +581,12 @@ static int udf_create(struct inode *dir, struct dentry *dentry, int mode, struct
 		inode->i_data.a_ops = &udf_adinicb_aops;
 	else
 		inode->i_data.a_ops = &udf_aops;
-	inode->i_op = &udf_file_inode_operations;
+	inode->i_op = (struct inode_operations *)&udf_file_inode_operations;
 	inode->i_fop = &udf_file_operations;
 	inode->i_mode = mode;
 	mark_inode_dirty(inode);
 
-	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err)))
-	{
+	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err))) {
 		inode->i_nlink --;
 		mark_inode_dirty(inode);
 		iput(inode);
@@ -652,8 +598,7 @@ static int udf_create(struct inode *dir, struct dentry *dentry, int mode, struct
 	*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
 		cpu_to_le32(UDF_I_UNIQUE(inode) & 0x00000000FFFFFFFFUL);
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
-	{
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		mark_inode_dirty(dir);
 	}
 	if (fibh.sbh != fibh.ebh)
@@ -661,6 +606,7 @@ static int udf_create(struct inode *dir, struct dentry *dentry, int mode, struct
 	brelse(fibh.sbh);
 	unlock_kernel();
 	d_instantiate(dentry, inode);
+
 	return 0;
 }
 
@@ -682,8 +628,7 @@ static int udf_mknod(struct inode * dir, struct dentry * dentry, int mode, dev_t
 
 	inode->i_uid = current->fsuid;
 	init_special_inode(inode, mode, rdev);
-	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err)))
-	{
+	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err))) {
 		inode->i_nlink --;
 		mark_inode_dirty(inode);
 		iput(inode);
@@ -695,8 +640,7 @@ static int udf_mknod(struct inode * dir, struct dentry * dentry, int mode, dev_t
 	*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
 		cpu_to_le32(UDF_I_UNIQUE(inode) & 0x00000000FFFFFFFFUL);
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
-	{
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		mark_inode_dirty(dir);
 	}
 	mark_inode_dirty(inode);
@@ -706,6 +650,7 @@ static int udf_mknod(struct inode * dir, struct dentry * dentry, int mode, dev_t
 	brelse(fibh.sbh);
 	d_instantiate(dentry, inode);
 	err = 0;
+
 out:
 	unlock_kernel();
 	return err;
@@ -728,10 +673,9 @@ static int udf_mkdir(struct inode * dir, struct dentry * dentry, int mode)
 	if (!inode)
 		goto out;
 
-	inode->i_op = &udf_dir_inode_operations;
+	inode->i_op = (struct inode_operations *)&udf_dir_inode_operations;
 	inode->i_fop = &udf_dir_operations;
-	if (!(fi = udf_add_entry(inode, NULL, &fibh, &cfi, &err)))
-	{
+	if (!(fi = udf_add_entry(inode, NULL, &fibh, &cfi, &err))) {
 		inode->i_nlink--;
 		mark_inode_dirty(inode);
 		iput(inode);
@@ -750,8 +694,7 @@ static int udf_mkdir(struct inode * dir, struct dentry * dentry, int mode)
 		inode->i_mode |= S_ISGID;
 	mark_inode_dirty(inode);
 
-	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err)))
-	{
+	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err))) {
 		inode->i_nlink = 0;
 		mark_inode_dirty(inode);
 		iput(inode);
@@ -770,6 +713,7 @@ static int udf_mkdir(struct inode * dir, struct dentry * dentry, int mode)
 		brelse(fibh.ebh);
 	brelse(fibh.sbh);
 	err = 0;
+
 out:
 	unlock_kernel();
 	return err;
@@ -785,47 +729,39 @@ static int empty_dir(struct inode *dir)
 	kernel_lb_addr eloc;
 	uint32_t elen;
 	sector_t offset;
-	struct extent_position epos = { NULL, 0, { 0, 0}};
+	struct extent_position epos = {};
 
 	f_pos = (udf_ext0_offset(dir) >> 2);
 
 	fibh.soffset = fibh.eoffset = (f_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
 
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		fibh.sbh = fibh.ebh = NULL;
-	else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
-		&epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30))
-	{
+	} else if (inode_bmap(dir, f_pos >> (dir->i_sb->s_blocksize_bits - 2),
+			      &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
-		if ((++offset << dir->i_sb->s_blocksize_bits) < elen)
-		{
+		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
 			else if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_LONG)
 				epos.offset -= sizeof(long_ad);
-		}
-		else
+		} else {
 			offset = 0;
+		}
 
-		if (!(fibh.sbh = fibh.ebh = udf_tread(dir->i_sb, block)))
-		{
+		if (!(fibh.sbh = fibh.ebh = udf_tread(dir->i_sb, block))) {
 			brelse(epos.bh);
 			return 0;
 		}
-	}
-	else
-	{
+	} else {
 		brelse(epos.bh);
 		return 0;
 	}
 
 
-	while ( (f_pos < size) )
-	{
+	while (f_pos < size) {
 		fi = udf_fileident_read(dir, &f_pos, &fibh, &cfi, &epos, &eloc, &elen, &offset);
-
-		if (!fi)
-		{
+		if (!fi) {
 			if (fibh.sbh != fibh.ebh)
 				brelse(fibh.ebh);
 			brelse(fibh.sbh);
@@ -833,8 +769,7 @@ static int empty_dir(struct inode *dir)
 			return 0;
 		}
 
-		if (cfi.lengthFileIdent && (cfi.fileCharacteristics & FID_FILE_CHAR_DELETED) == 0)
-		{
+		if (cfi.lengthFileIdent && (cfi.fileCharacteristics & FID_FILE_CHAR_DELETED) == 0) {
 			if (fibh.sbh != fibh.ebh)
 				brelse(fibh.ebh);
 			brelse(fibh.sbh);
@@ -842,10 +777,12 @@ static int empty_dir(struct inode *dir)
 			return 0;
 		}
 	}
+
 	if (fibh.sbh != fibh.ebh)
 		brelse(fibh.ebh);
 	brelse(fibh.sbh);
 	brelse(epos.bh);
+
 	return 1;
 }
 
@@ -875,8 +812,8 @@ static int udf_rmdir(struct inode * dir, struct dentry * dentry)
 		goto end_rmdir;
 	if (inode->i_nlink != 2)
 		udf_warning(inode->i_sb, "udf_rmdir",
-			"empty directory has nlink != 2 (%d)",
-			inode->i_nlink);
+			    "empty directory has nlink != 2 (%d)",
+			    inode->i_nlink);
 	clear_nlink(inode);
 	inode->i_size = 0;
 	inode_dec_link_count(dir);
@@ -887,6 +824,7 @@ end_rmdir:
 	if (fibh.sbh != fibh.ebh)
 		brelse(fibh.ebh);
 	brelse(fibh.sbh);
+
 out:
 	unlock_kernel();
 	return retval;
@@ -912,10 +850,9 @@ static int udf_unlink(struct inode * dir, struct dentry * dentry)
 	if (udf_get_lb_pblock(dir->i_sb, tloc, 0) != inode->i_ino)
 		goto end_unlink;
 
-	if (!inode->i_nlink)
-	{
+	if (!inode->i_nlink) {
 		udf_debug("Deleting nonexistent file (%lu), %d\n",
-			inode->i_ino, inode->i_nlink);
+			  inode->i_ino, inode->i_nlink);
 		inode->i_nlink = 1;
 	}
 	retval = udf_delete_entry(dir, fi, &fibh, &cfi);
@@ -931,6 +868,7 @@ end_unlink:
 	if (fibh.sbh != fibh.ebh)
 		brelse(fibh.ebh);
 	brelse(fibh.sbh);
+
 out:
 	unlock_kernel();
 	return retval;
@@ -942,7 +880,7 @@ static int udf_symlink(struct inode * dir, struct dentry * dentry, const char *
 	struct pathComponent *pc;
 	char *compstart;
 	struct udf_fileident_bh fibh;
-	struct extent_position epos = { NULL,  0, {0, 0}};
+	struct extent_position epos = {};
 	int eoffset, elen = 0;
 	struct fileIdentDesc *fi;
 	struct fileIdentDesc cfi;
@@ -960,14 +898,13 @@ static int udf_symlink(struct inode * dir, struct dentry * dentry, const char *
 	inode->i_data.a_ops = &udf_symlink_aops;
 	inode->i_op = &page_symlink_inode_operations;
 
-	if (UDF_I_ALLOCTYPE(inode) != ICBTAG_FLAG_AD_IN_ICB)
-	{
+	if (UDF_I_ALLOCTYPE(inode) != ICBTAG_FLAG_AD_IN_ICB) {
 		kernel_lb_addr eloc;
 		uint32_t elen;
 
 		block = udf_new_block(inode->i_sb, inode,
-			UDF_I_LOCATION(inode).partitionReferenceNum,
-			UDF_I_LOCATION(inode).logicalBlockNum, &err);
+				      UDF_I_LOCATION(inode).partitionReferenceNum,
+				      UDF_I_LOCATION(inode).logicalBlockNum, &err);
 		if (!block)
 			goto out_no_entry;
 		epos.block = UDF_I_LOCATION(inode);
@@ -981,7 +918,7 @@ static int udf_symlink(struct inode * dir, struct dentry * dentry, const char *
 		brelse(epos.bh);
 
 		block = udf_get_pblock(inode->i_sb, block,
-			UDF_I_LOCATION(inode).partitionReferenceNum, 0);
+				       UDF_I_LOCATION(inode).partitionReferenceNum, 0);
 		epos.bh = udf_tread(inode->i_sb, block);
 		lock_buffer(epos.bh);
 		memset(epos.bh->b_data, 0x00, inode->i_sb->s_blocksize);
@@ -989,17 +926,15 @@ static int udf_symlink(struct inode * dir, struct dentry * dentry, const char *
 		unlock_buffer(epos.bh);
 		mark_buffer_dirty_inode(epos.bh, inode);
 		ea = epos.bh->b_data + udf_ext0_offset(inode);
-	}
-	else
+	} else {
 		ea = UDF_I_DATA(inode) + UDF_I_LENEATTR(inode);
+	}
 
 	eoffset = inode->i_sb->s_blocksize - udf_ext0_offset(inode);
 	pc = (struct pathComponent *)ea;
 
-	if (*symname == '/')
-	{
-		do
-		{
+	if (*symname == '/') {
+		do {
 			symname++;
 		} while (*symname == '/');
 
@@ -1012,8 +947,7 @@ static int udf_symlink(struct inode * dir, struct dentry * dentry, const char *
 
 	err = -ENAMETOOLONG;
 
-	while (*symname)
-	{
+	while (*symname) {
 		if (elen + sizeof(struct pathComponent) > eoffset)
 			goto out_no_entry;
 
@@ -1021,25 +955,24 @@ static int udf_symlink(struct inode * dir, struct dentry * dentry, const char *
 
 		compstart = (char *)symname;
 
-		do
-		{
+		do {
 			symname++;
 		} while (*symname && *symname != '/');
 
 		pc->componentType = 5;
 		pc->lengthComponentIdent = 0;
 		pc->componentFileVersionNum = 0;
-		if (compstart[0] == '.')
-		{
-			if ((symname-compstart) == 1)
+		if (compstart[0] == '.') {
+			if ((symname - compstart) == 1)
 				pc->componentType = 4;
-			else if ((symname-compstart) == 2 && compstart[1] == '.')
+			else if ((symname - compstart) == 2 && compstart[1] == '.')
 				pc->componentType = 3;
 		}
 
-		if (pc->componentType == 5)
-		{
-			if ( !(namelen = udf_put_filename(inode->i_sb, compstart, name, symname-compstart)))
+		if (pc->componentType == 5) {
+			namelen = udf_put_filename(inode->i_sb, compstart, name,
+						   symname - compstart);
+			if (!namelen)
 				goto out_no_entry;
 
 			if (elen + sizeof(struct pathComponent) + namelen > eoffset)
@@ -1052,10 +985,8 @@ static int udf_symlink(struct inode * dir, struct dentry * dentry, const char *
 
 		elen += sizeof(struct pathComponent) + pc->lengthComponentIdent;
 
-		if (*symname)
-		{
-			do
-			{
+		if (*symname) {
+			do {
 				symname++;
 			} while (*symname == '/');
 		}
@@ -1071,8 +1002,7 @@ static int udf_symlink(struct inode * dir, struct dentry * dentry, const char *
 		goto out_no_entry;
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
 	cfi.icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(inode));
-	if (UDF_SB_LVIDBH(inode->i_sb))
-	{
+	if (UDF_SB_LVIDBH(inode->i_sb)) {
 		struct logicalVolHeaderDesc *lvhd;
 		uint64_t uniqueID;
 		lvhd = (struct logicalVolHeaderDesc *)(UDF_SB_LVID(inode->i_sb)->logicalVolContentsUse);
@@ -1085,8 +1015,7 @@ static int udf_symlink(struct inode * dir, struct dentry * dentry, const char *
 		mark_buffer_dirty(UDF_SB_LVIDBH(inode->i_sb));
 	}
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
-	{
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		mark_inode_dirty(dir);
 	}
 	if (fibh.sbh != fibh.ebh)
@@ -1106,7 +1035,7 @@ out_no_entry:
 }
 
 static int udf_link(struct dentry * old_dentry, struct inode * dir,
-	 struct dentry *dentry)
+		    struct dentry *dentry)
 {
 	struct inode *inode = old_dentry->d_inode;
 	struct udf_fileident_bh fibh;
@@ -1114,21 +1043,18 @@ static int udf_link(struct dentry * old_dentry, struct inode * dir,
 	int err;
 
 	lock_kernel();
-	if (inode->i_nlink >= (256<<sizeof(inode->i_nlink))-1)
-	{
+	if (inode->i_nlink >= (256 << sizeof(inode->i_nlink)) - 1) {
 		unlock_kernel();
 		return -EMLINK;
 	}
 
-	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err)))
-	{
+	if (!(fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err))) {
 		unlock_kernel();
 		return err;
 	}
 	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
 	cfi.icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(inode));
-	if (UDF_SB_LVIDBH(inode->i_sb))
-	{
+	if (UDF_SB_LVIDBH(inode->i_sb)) {
 		struct logicalVolHeaderDesc *lvhd;
 		uint64_t uniqueID;
 		lvhd = (struct logicalVolHeaderDesc *)(UDF_SB_LVID(inode->i_sb)->logicalVolContentsUse);
@@ -1141,10 +1067,10 @@ static int udf_link(struct dentry * old_dentry, struct inode * dir,
 		mark_buffer_dirty(UDF_SB_LVIDBH(inode->i_sb));
 	}
 	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
-	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB)
-	{
+	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		mark_inode_dirty(dir);
 	}
+
 	if (fibh.sbh != fibh.ebh)
 		brelse(fibh.ebh);
 	brelse(fibh.sbh);
@@ -1154,6 +1080,7 @@ static int udf_link(struct dentry * old_dentry, struct inode * dir,
 	atomic_inc(&inode->i_count);
 	d_instantiate(dentry, inode);
 	unlock_kernel();
+
 	return 0;
 }
 
@@ -1161,7 +1088,7 @@ static int udf_link(struct dentry * old_dentry, struct inode * dir,
  * higher-level routines.
  */
 static int udf_rename (struct inode * old_dir, struct dentry * old_dentry,
-	struct inode * new_dir, struct dentry * new_dentry)
+		       struct inode * new_dir, struct dentry * new_dentry)
 {
 	struct inode * old_inode = old_dentry->d_inode;
 	struct inode * new_inode = new_dentry->d_inode;
@@ -1172,49 +1099,41 @@ static int udf_rename (struct inode * old_dir, struct dentry * old_dentry,
 	kernel_lb_addr tloc;
 
 	lock_kernel();
-	if ((ofi = udf_find_entry(old_dir, old_dentry, &ofibh, &ocfi)))
-	{
+	if ((ofi = udf_find_entry(old_dir, old_dentry, &ofibh, &ocfi))) {
 		if (ofibh.sbh != ofibh.ebh)
 			brelse(ofibh.ebh);
 		brelse(ofibh.sbh);
 	}
 	tloc = lelb_to_cpu(ocfi.icb.extLocation);
 	if (!ofi || udf_get_lb_pblock(old_dir->i_sb, tloc, 0)
-					!= old_inode->i_ino)
+	    != old_inode->i_ino)
 		goto end_rename;
 
 	nfi = udf_find_entry(new_dir, new_dentry, &nfibh, &ncfi);
-	if (nfi)
-	{
-		if (!new_inode)
-		{
+	if (nfi) {
+		if (!new_inode) {
 			if (nfibh.sbh != nfibh.ebh)
 				brelse(nfibh.ebh);
 			brelse(nfibh.sbh);
 			nfi = NULL;
 		}
 	}
-	if (S_ISDIR(old_inode->i_mode))
-	{
+	if (S_ISDIR(old_inode->i_mode)) {
 		uint32_t offset = udf_ext0_offset(old_inode);
 
-		if (new_inode)
-		{
+		if (new_inode) {
 			retval = -ENOTEMPTY;
 			if (!empty_dir(new_inode))
 				goto end_rename;
 		}
 		retval = -EIO;
-		if (UDF_I_ALLOCTYPE(old_inode) == ICBTAG_FLAG_AD_IN_ICB)
-		{
+		if (UDF_I_ALLOCTYPE(old_inode) == ICBTAG_FLAG_AD_IN_ICB) {
 			dir_fi = udf_get_fileident(UDF_I_DATA(old_inode) -
-				(UDF_I_EFE(old_inode) ?
-					sizeof(struct extendedFileEntry) :
-					sizeof(struct fileEntry)),
-				old_inode->i_sb->s_blocksize, &offset);
-		}
-		else
-		{
+						   (UDF_I_EFE(old_inode) ?
+						    sizeof(struct extendedFileEntry) :
+						    sizeof(struct fileEntry)),
+						   old_inode->i_sb->s_blocksize, &offset);
+		} else {
 			dir_bh = udf_bread(old_inode, 0, 0, &retval);
 			if (!dir_bh)
 				goto end_rename;
@@ -1223,16 +1142,14 @@ static int udf_rename (struct inode * old_dir, struct dentry * old_dentry,
 		if (!dir_fi)
 			goto end_rename;
 		tloc = lelb_to_cpu(dir_fi->icb.extLocation);
-		if (udf_get_lb_pblock(old_inode->i_sb, tloc, 0)
-					!= old_dir->i_ino)
+		if (udf_get_lb_pblock(old_inode->i_sb, tloc, 0) != old_dir->i_ino)
 			goto end_rename;
 
 		retval = -EMLINK;
-		if (!new_inode && new_dir->i_nlink >= (256<<sizeof(new_dir->i_nlink))-1)
+		if (!new_inode && new_dir->i_nlink >= (256 << sizeof(new_dir->i_nlink)) - 1)
 			goto end_rename;
 	}
-	if (!nfi)
-	{
+	if (!nfi) {
 		nfi = udf_add_entry(new_dir, new_dentry, &nfibh, &ncfi, &retval);
 		if (!nfi)
 			goto end_rename;
@@ -1257,39 +1174,32 @@ static int udf_rename (struct inode * old_dir, struct dentry * old_dentry,
 	ofi = udf_find_entry(old_dir, old_dentry, &ofibh, &ocfi);
 	udf_delete_entry(old_dir, ofi, &ofibh, &ocfi);
 
-	if (new_inode)
-	{
+	if (new_inode) {
 		new_inode->i_ctime = current_fs_time(new_inode->i_sb);
 		inode_dec_link_count(new_inode);
 	}
 	old_dir->i_ctime = old_dir->i_mtime = current_fs_time(old_dir->i_sb);
 	mark_inode_dirty(old_dir);
 
-	if (dir_fi)
-	{
+	if (dir_fi) {
 		dir_fi->icb.extLocation = cpu_to_lelb(UDF_I_LOCATION(new_dir));
 		udf_update_tag((char *)dir_fi, (sizeof(struct fileIdentDesc) +
-			le16_to_cpu(dir_fi->lengthOfImpUse) + 3) & ~3);
-		if (UDF_I_ALLOCTYPE(old_inode) == ICBTAG_FLAG_AD_IN_ICB)
-		{
+						le16_to_cpu(dir_fi->lengthOfImpUse) + 3) & ~3);
+		if (UDF_I_ALLOCTYPE(old_inode) == ICBTAG_FLAG_AD_IN_ICB) {
 			mark_inode_dirty(old_inode);
-		}
-		else
+		} else {
 			mark_buffer_dirty_inode(dir_bh, old_inode);
+		}
 		inode_dec_link_count(old_dir);
-		if (new_inode)
-		{
+		if (new_inode) {
 			inode_dec_link_count(new_inode);
-		}
-		else
-		{
+		} else {
 			inc_nlink(new_dir);
 			mark_inode_dirty(new_dir);
 		}
 	}
 
-	if (ofi)
-	{
+	if (ofi) {
 		if (ofibh.sbh != ofibh.ebh)
 			brelse(ofibh.ebh);
 		brelse(ofibh.sbh);
@@ -1299,13 +1209,13 @@ static int udf_rename (struct inode * old_dir, struct dentry * old_dentry,
 
 end_rename:
 	brelse(dir_bh);
-	if (nfi)
-	{
+	if (nfi) {
 		if (nfibh.sbh != nfibh.ebh)
 			brelse(nfibh.ebh);
 		brelse(nfibh.sbh);
 	}
 	unlock_kernel();
+
 	return retval;
 }
 
diff --git a/fs/udf/osta_udf.h b/fs/udf/osta_udf.h
index e82aae6..b5eb1bf 100644
--- a/fs/udf/osta_udf.h
+++ b/fs/udf/osta_udf.h
@@ -65,30 +65,26 @@
 #define IS_DF_HARD_WRITE_PROTECT	0x01
 #define IS_DF_SOFT_WRITE_PROTECT	0x02
 
-struct UDFIdentSuffix
-{
+struct UDFIdentSuffix {
 	__le16		UDFRevision;
 	uint8_t		OSClass;
 	uint8_t		OSIdentifier;
 	uint8_t		reserved[4];
 } __attribute__ ((packed));
 
-struct impIdentSuffix
-{
+struct impIdentSuffix {
 	uint8_t		OSClass;
 	uint8_t		OSIdentifier;
 	uint8_t		reserved[6];
 } __attribute__ ((packed));
 
-struct appIdentSuffix
-{
+struct appIdentSuffix {
 	uint8_t		impUse[8];
 } __attribute__ ((packed));
 
 /* Logical Volume Integrity Descriptor (UDF 2.50 2.2.6) */
 /* Implementation Use (UDF 2.50 2.2.6.4) */
-struct logicalVolIntegrityDescImpUse
-{
+struct logicalVolIntegrityDescImpUse {
 	regid		impIdent;
 	__le32		numFiles;
 	__le32		numDirs;
@@ -100,8 +96,7 @@ struct logicalVolIntegrityDescImpUse
 
 /* Implementation Use Volume Descriptor (UDF 2.50 2.2.7) */
 /* Implementation Use (UDF 2.50 2.2.7.2) */
-struct impUseVolDescImpUse
-{
+struct impUseVolDescImpUse {
 	charspec	LVICharset;
 	dstring		logicalVolIdent[128];
 	dstring		LVInfo1[36];
@@ -111,8 +106,7 @@ struct impUseVolDescImpUse
 	uint8_t		impUse[128];
 } __attribute__ ((packed));
 
-struct udfPartitionMap2
-{
+struct udfPartitionMap2 {
 	uint8_t		partitionMapType;
 	uint8_t		partitionMapLength;
 	uint8_t		reserved1[2];
@@ -122,8 +116,7 @@ struct udfPartitionMap2
 } __attribute__ ((packed));
 
 /* Virtual Partition Map (UDF 2.50 2.2.8) */
-struct virtualPartitionMap
-{
+struct virtualPartitionMap {
 	uint8_t		partitionMapType;
 	uint8_t		partitionMapLength;
 	uint8_t		reserved1[2];
@@ -134,8 +127,7 @@ struct virtualPartitionMap
 } __attribute__ ((packed));
 
 /* Sparable Partition Map (UDF 2.50 2.2.9) */
-struct sparablePartitionMap
-{
+struct sparablePartitionMap {
 	uint8_t		partitionMapType;
 	uint8_t		partitionMapLength;
 	uint8_t		reserved1[2];
@@ -150,8 +142,7 @@ struct sparablePartitionMap
 } __attribute__ ((packed));
 
 /* Metadata Partition Map (UDF 2.4.0 2.2.10) */
-struct metadataPartitionMap
-{
+struct metadataPartitionMap {
 	uint8_t		partitionMapType;
 	uint8_t		partitionMapLength;
 	uint8_t		reserved1[2];
@@ -168,18 +159,16 @@ struct metadataPartitionMap
 } __attribute__ ((packed));
 
 /* Virtual Allocation Table (UDF 1.5 2.2.10) */
-struct virtualAllocationTable15
-{
+struct virtualAllocationTable15 {
 	__le32		VirtualSector[0];
 	regid		vatIdent;
 	__le32		previousVATICBLoc;
-} __attribute__ ((packed));  
+} __attribute__ ((packed));
 
 #define ICBTAG_FILE_TYPE_VAT15		0x00U
 
 /* Virtual Allocation Table (UDF 2.50 2.2.11) */
-struct virtualAllocationTable20
-{
+struct virtualAllocationTable20 {
 	__le16		lengthHeader;
 	__le16		lengthImpUse;
 	dstring		logicalVolIdent[128];
@@ -197,14 +186,12 @@ struct virtualAllocationTable20
 #define ICBTAG_FILE_TYPE_VAT20		0xF8U
 
 /* Sparing Table (UDF 2.50 2.2.12) */
-struct sparingEntry
-{
+struct sparingEntry {
 	__le32		origLocation;
 	__le32		mappedLocation;
 } __attribute__ ((packed));
 
-struct sparingTable
-{
+struct sparingTable {
 	tag 		descTag;
 	regid		sparingIdent;
 	__le16		reallocationTableLen;
@@ -220,8 +207,7 @@ struct sparingTable
 #define ICBTAG_FILE_TYPE_BITMAP		0xFC
 
 /* struct long_ad ICB - ADImpUse (UDF 2.50 2.2.4.3) */
-struct allocDescImpUse
-{
+struct allocDescImpUse {
 	__le16		flags;
 	uint8_t		impUse[4];
 } __attribute__ ((packed));
@@ -233,15 +219,13 @@ struct allocDescImpUse
 
 /* Implementation Use Extended Attribute (UDF 2.50 3.3.4.5) */
 /* FreeEASpace (UDF 2.50 3.3.4.5.1.1) */
-struct freeEaSpace
-{
+struct freeEaSpace {
 	__le16		headerChecksum;
 	uint8_t		freeEASpace[0];
 } __attribute__ ((packed));
 
 /* DVD Copyright Management Information (UDF 2.50 3.3.4.5.1.2) */
-struct DVDCopyrightImpUse 
-{
+struct DVDCopyrightImpUse {
 	__le16		headerChecksum;
 	uint8_t		CGMSInfo;
 	uint8_t		dataType;
@@ -250,8 +234,7 @@ struct DVDCopyrightImpUse
 
 /* Application Use Extended Attribute (UDF 2.50 3.3.4.6) */
 /* FreeAppEASpace (UDF 2.50 3.3.4.6.1) */
-struct freeAppEASpace
-{
+struct freeAppEASpace {
 	__le16		headerChecksum;
 	uint8_t		freeEASpace[0];
 } __attribute__ ((packed));
diff --git a/fs/udf/partition.c b/fs/udf/partition.c
index 467a261..5dc3465 100644
--- a/fs/udf/partition.c
+++ b/fs/udf/partition.c
@@ -14,7 +14,7 @@
  *
  * HISTORY
  *
- * 12/06/98 blf  Created file. 
+ * 12/06/98 blf  Created file.
  *
  */
 
@@ -28,12 +28,12 @@
 #include <linux/slab.h>
 #include <linux/buffer_head.h>
 
-inline uint32_t udf_get_pblock(struct super_block *sb, uint32_t block, uint16_t partition, uint32_t offset)
+inline uint32_t udf_get_pblock(struct super_block *sb, uint32_t block,
+			       uint16_t partition, uint32_t offset)
 {
-	if (partition >= UDF_SB_NUMPARTS(sb))
-	{
+	if (partition >= UDF_SB_NUMPARTS(sb)) {
 		udf_debug("block=%d, partition=%d, offset=%d: invalid partition\n",
-			block, partition, offset);
+			  block, partition, offset);
 		return 0xFFFFFFFF;
 	}
 	if (UDF_SB_PARTFUNC(sb, partition))
@@ -42,7 +42,8 @@ inline uint32_t udf_get_pblock(struct super_block *sb, uint32_t block, uint16_t
 		return UDF_SB_PARTROOT(sb, partition) + block + offset;
 }
 
-uint32_t udf_get_pblock_virt15(struct super_block *sb, uint32_t block, uint16_t partition, uint32_t offset)
+uint32_t udf_get_pblock_virt15(struct super_block *sb, uint32_t block,
+			       uint16_t partition, uint32_t offset)
 {
 	struct buffer_head *bh = NULL;
 	uint32_t newblock;
@@ -51,31 +52,26 @@ uint32_t udf_get_pblock_virt15(struct super_block *sb, uint32_t block, uint16_t
 
 	index = (sb->s_blocksize - UDF_SB_TYPEVIRT(sb,partition).s_start_offset) / sizeof(uint32_t);
 
-	if (block > UDF_SB_TYPEVIRT(sb,partition).s_num_entries)
-	{
+	if (block > UDF_SB_TYPEVIRT(sb,partition).s_num_entries) {
 		udf_debug("Trying to access block beyond end of VAT (%d max %d)\n",
-			block, UDF_SB_TYPEVIRT(sb,partition).s_num_entries);
+			  block, UDF_SB_TYPEVIRT(sb,partition).s_num_entries);
 		return 0xFFFFFFFF;
 	}
 
-	if (block >= index)
-	{
+	if (block >= index) {
 		block -= index;
 		newblock = 1 + (block / (sb->s_blocksize / sizeof(uint32_t)));
 		index = block % (sb->s_blocksize / sizeof(uint32_t));
-	}
-	else
-	{
+	} else {
 		newblock = 0;
 		index = UDF_SB_TYPEVIRT(sb,partition).s_start_offset / sizeof(uint32_t) + block;
 	}
 
 	loc = udf_block_map(UDF_SB_VAT(sb), newblock);
 
-	if (!(bh = sb_bread(sb, loc)))
-	{
+	if (!(bh = sb_bread(sb, loc))) {
 		udf_debug("get_pblock(UDF_VIRTUAL_MAP:%p,%d,%d) VAT: %d[%d]\n",
-			sb, block, partition, loc, index);
+			  sb, block, partition, loc, index);
 		return 0xFFFFFFFF;
 	}
 
@@ -83,50 +79,49 @@ uint32_t udf_get_pblock_virt15(struct super_block *sb, uint32_t block, uint16_t
 
 	brelse(bh);
 
-	if (UDF_I_LOCATION(UDF_SB_VAT(sb)).partitionReferenceNum == partition)
-	{
+	if (UDF_I_LOCATION(UDF_SB_VAT(sb)).partitionReferenceNum == partition) {
 		udf_debug("recursive call to udf_get_pblock!\n");
 		return 0xFFFFFFFF;
 	}
 
-	return udf_get_pblock(sb, loc, UDF_I_LOCATION(UDF_SB_VAT(sb)).partitionReferenceNum, offset);
+	return udf_get_pblock(sb, loc,
+			      UDF_I_LOCATION(UDF_SB_VAT(sb)).partitionReferenceNum,
+			      offset);
 }
 
-inline uint32_t udf_get_pblock_virt20(struct super_block *sb, uint32_t block, uint16_t partition, uint32_t offset)
+inline uint32_t udf_get_pblock_virt20(struct super_block *sb, uint32_t block,
+				      uint16_t partition, uint32_t offset)
 {
 	return udf_get_pblock_virt15(sb, block, partition, offset);
 }
 
-uint32_t udf_get_pblock_spar15(struct super_block *sb, uint32_t block, uint16_t partition, uint32_t offset)
+uint32_t udf_get_pblock_spar15(struct super_block *sb, uint32_t block,
+			       uint16_t partition, uint32_t offset)
 {
 	int i;
 	struct sparingTable *st = NULL;
 	uint32_t packet = (block + offset) & ~(UDF_SB_TYPESPAR(sb,partition).s_packet_len - 1);
 
-	for (i=0; i<4; i++)
-	{
-		if (UDF_SB_TYPESPAR(sb,partition).s_spar_map[i] != NULL)
-		{
+	for (i = 0; i < 4; i++) {
+		if (UDF_SB_TYPESPAR(sb,partition).s_spar_map[i] != NULL) {
 			st = (struct sparingTable *)UDF_SB_TYPESPAR(sb,partition).s_spar_map[i]->b_data;
 			break;
 		}
 	}
 
-	if (st)
-	{
-		for (i=0; i<le16_to_cpu(st->reallocationTableLen); i++)
-		{
-			if (le32_to_cpu(st->mapEntry[i].origLocation) >= 0xFFFFFFF0)
+	if (st) {
+		for (i = 0; i < le16_to_cpu(st->reallocationTableLen); i++) {
+			if (le32_to_cpu(st->mapEntry[i].origLocation) >= 0xFFFFFFF0) {
 				break;
-			else if (le32_to_cpu(st->mapEntry[i].origLocation) == packet)
-			{
+			} else if (le32_to_cpu(st->mapEntry[i].origLocation) == packet) {
 				return le32_to_cpu(st->mapEntry[i].mappedLocation) +
 					((block + offset) & (UDF_SB_TYPESPAR(sb,partition).s_packet_len - 1));
-			}
-			else if (le32_to_cpu(st->mapEntry[i].origLocation) > packet)
+			} else if (le32_to_cpu(st->mapEntry[i].origLocation) > packet) {
 				break;
+			}
 		}
 	}
+
 	return UDF_SB_PARTROOT(sb,partition) + block + offset;
 }
 
@@ -138,18 +133,14 @@ int udf_relocate_blocks(struct super_block *sb, long old_block, long *new_block)
 	uint32_t packet;
 	int i, j, k, l;
 
-	for (i=0; i<UDF_SB_NUMPARTS(sb); i++)
-	{
+	for (i = 0; i < UDF_SB_NUMPARTS(sb); i++) {
 		if (old_block > UDF_SB_PARTROOT(sb,i) &&
-		    old_block < UDF_SB_PARTROOT(sb,i) + UDF_SB_PARTLEN(sb,i))
-		{
+		    old_block < UDF_SB_PARTROOT(sb,i) + UDF_SB_PARTLEN(sb,i)) {
 			sdata = &UDF_SB_TYPESPAR(sb,i);
 			packet = (old_block - UDF_SB_PARTROOT(sb,i)) & ~(sdata->s_packet_len - 1);
 
-			for (j=0; j<4; j++)
-			{
-				if (UDF_SB_TYPESPAR(sb,i).s_spar_map[j] != NULL)
-				{
+			for (j = 0; j < 4; j++) {
+				if (UDF_SB_TYPESPAR(sb,i).s_spar_map[j] != NULL) {
 					st = (struct sparingTable *)sdata->s_spar_map[j]->b_data;
 					break;
 				}
@@ -158,14 +149,10 @@ int udf_relocate_blocks(struct super_block *sb, long old_block, long *new_block)
 			if (!st)
 				return 1;
 
-			for (k=0; k<le16_to_cpu(st->reallocationTableLen); k++)
-			{
-				if (le32_to_cpu(st->mapEntry[k].origLocation) == 0xFFFFFFFF)
-				{
-					for (; j<4; j++)
-					{
-						if (sdata->s_spar_map[j])
-						{
+			for (k = 0; k < le16_to_cpu(st->reallocationTableLen); k++) {
+				if (le32_to_cpu(st->mapEntry[k].origLocation) == 0xFFFFFFFF) {
+					for (; j < 4; j++) {
+						if (sdata->s_spar_map[j]) {
 							st = (struct sparingTable *)sdata->s_spar_map[j]->b_data;
 							st->mapEntry[k].origLocation = cpu_to_le32(packet);
 							udf_update_tag((char *)st, sizeof(struct sparingTable) + le16_to_cpu(st->reallocationTableLen) * sizeof(struct sparingEntry));
@@ -175,24 +162,19 @@ int udf_relocate_blocks(struct super_block *sb, long old_block, long *new_block)
 					*new_block = le32_to_cpu(st->mapEntry[k].mappedLocation) +
 						((old_block - UDF_SB_PARTROOT(sb,i)) & (sdata->s_packet_len - 1));
 					return 0;
-				}
-				else if (le32_to_cpu(st->mapEntry[k].origLocation) == packet)
-				{
+				} else if (le32_to_cpu(st->mapEntry[k].origLocation) == packet) {
 					*new_block = le32_to_cpu(st->mapEntry[k].mappedLocation) +
 						((old_block - UDF_SB_PARTROOT(sb,i)) & (sdata->s_packet_len - 1));
 					return 0;
-				}
-				else if (le32_to_cpu(st->mapEntry[k].origLocation) > packet)
+				} else if (le32_to_cpu(st->mapEntry[k].origLocation) > packet) {
 					break;
+				}
 			}
-			for (l=k; l<le16_to_cpu(st->reallocationTableLen); l++)
-			{
-				if (le32_to_cpu(st->mapEntry[l].origLocation) == 0xFFFFFFFF)
-				{
-					for (; j<4; j++)
-					{
-						if (sdata->s_spar_map[j])
-						{
+
+			for (l = k; l < le16_to_cpu(st->reallocationTableLen); l++) {
+				if (le32_to_cpu(st->mapEntry[l].origLocation) == 0xFFFFFFFF) {
+					for (; j < 4; j++) {
+						if (sdata->s_spar_map[j]) {
 							st = (struct sparingTable *)sdata->s_spar_map[j]->b_data;
 							mapEntry = st->mapEntry[l];
 							mapEntry.origLocation = cpu_to_le32(packet);
@@ -207,11 +189,12 @@ int udf_relocate_blocks(struct super_block *sb, long old_block, long *new_block)
 					return 0;
 				}
 			}
+
 			return 1;
-		}
+		} /* if old_block */
 	}
-	if (i == UDF_SB_NUMPARTS(sb))
-	{
+
+	if (i == UDF_SB_NUMPARTS(sb)) {
 		/* outside of partitions */
 		/* for now, fail =) */
 		return 1;
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 3a743d8..4ae927d 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -38,7 +38,7 @@
  *  12/20/98      find the free space bitmap (if it exists)
  */
 
-#include "udfdecl.h"    
+#include "udfdecl.h"
 
 #include <linux/blkdev.h>
 #include <linux/slab.h>
@@ -94,7 +94,8 @@ static int udf_statfs(struct dentry *, struct kstatfs *);
 
 /* UDF filesystem type */
 static int udf_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+		      int flags, const char *dev_name,
+		      void *data, struct vfsmount *mnt)
 {
 	return get_sb_bdev(fs_type, flags, dev_name, data, udf_fill_super, mnt);
 }
@@ -142,11 +143,11 @@ static int init_inodecache(void)
 {
 	udf_inode_cachep = kmem_cache_create("udf_inode_cache",
 					     sizeof(struct udf_inode_info),
-					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+					     0, (SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD),
 					     init_once, NULL);
-	if (udf_inode_cachep == NULL)
+	if (!udf_inode_cachep)
 		return -ENOMEM;
+
 	return 0;
 }
 
@@ -189,15 +190,19 @@ struct udf_options
 static int __init init_udf_fs(void)
 {
 	int err;
+
 	err = init_inodecache();
 	if (err)
 		goto out1;
 	err = register_filesystem(&udf_fstype);
 	if (err)
 		goto out;
+
 	return 0;
+
 out:
 	destroy_inodecache();
+
 out1:
 	return err;
 }
@@ -235,7 +240,7 @@ module_exit(exit_udf_fs)
  *
  *	The remaining are for debugging and disaster recovery:
  *
- *	novrs		Skip volume sequence recognition 
+ *	novrs		Skip volume sequence recognition
  *
  *	The following expect a offset from 0.
  *
@@ -275,36 +280,35 @@ enum {
 };
 
 static match_table_t tokens = {
-	{Opt_novrs, "novrs"},
-	{Opt_nostrict, "nostrict"},
-	{Opt_bs, "bs=%u"},
-	{Opt_unhide, "unhide"},
-	{Opt_undelete, "undelete"},
-	{Opt_noadinicb, "noadinicb"},
-	{Opt_adinicb, "adinicb"},
-	{Opt_shortad, "shortad"},
-	{Opt_longad, "longad"},
-	{Opt_uforget, "uid=forget"},
-	{Opt_uignore, "uid=ignore"},
-	{Opt_gforget, "gid=forget"},
-	{Opt_gignore, "gid=ignore"},
-	{Opt_gid, "gid=%u"},
-	{Opt_uid, "uid=%u"},
-	{Opt_umask, "umask=%o"},
-	{Opt_session, "session=%u"},
-	{Opt_lastblock, "lastblock=%u"},
-	{Opt_anchor, "anchor=%u"},
-	{Opt_volume, "volume=%u"},
-	{Opt_partition, "partition=%u"},
-	{Opt_fileset, "fileset=%u"},
-	{Opt_rootdir, "rootdir=%u"},
-	{Opt_utf8, "utf8"},
-	{Opt_iocharset, "iocharset=%s"},
-	{Opt_err, NULL}
+	{Opt_novrs,	"novrs"},
+	{Opt_nostrict,	"nostrict"},
+	{Opt_bs,	"bs=%u"},
+	{Opt_unhide,	"unhide"},
+	{Opt_undelete,	"undelete"},
+	{Opt_noadinicb,	"noadinicb"},
+	{Opt_adinicb,	"adinicb"},
+	{Opt_shortad,	"shortad"},
+	{Opt_longad,	"longad"},
+	{Opt_uforget,	"uid=forget"},
+	{Opt_uignore,	"uid=ignore"},
+	{Opt_gforget,	"gid=forget"},
+	{Opt_gignore,	"gid=ignore"},
+	{Opt_gid,	"gid=%u"},
+	{Opt_uid,	"uid=%u"},
+	{Opt_umask,	"umask=%o"},
+	{Opt_session,	"session=%u"},
+	{Opt_lastblock,	"lastblock=%u"},
+	{Opt_anchor,	"anchor=%u"},
+	{Opt_volume,	"volume=%u"},
+	{Opt_partition,	"partition=%u"},
+	{Opt_fileset,	"fileset=%u"},
+	{Opt_rootdir,	"rootdir=%u"},
+	{Opt_utf8,	"utf8"},
+	{Opt_iocharset,	"iocharset=%s"},
+	{Opt_err,	NULL}
 };
 
-static int
-udf_parse_options(char *options, struct udf_options *uopt)
+static int udf_parse_options(char *options, struct udf_options *uopt)
 {
 	char *p;
 	int option;
@@ -323,16 +327,14 @@ udf_parse_options(char *options, struct udf_options *uopt)
 	if (!options)
 		return 1;
 
-	while ((p = strsep(&options, ",")) != NULL)
-	{
+	while ((p = strsep(&options, ",")) != NULL) {
 		substring_t args[MAX_OPT_ARGS];
 		int token;
 		if (!*p)
 			continue;
 
 		token = match_token(p, tokens, args);
-		switch (token)
-		{
+		switch (token) {
 			case Opt_novrs:
 				uopt->novrs = 1;
 			case Opt_bs:
@@ -434,34 +436,34 @@ udf_parse_options(char *options, struct udf_options *uopt)
 				break;
 			default:
 				printk(KERN_ERR "udf: bad mount option \"%s\" "
-						"or missing value\n", p);
+				       "or missing value\n", p);
 			return 0;
 		}
 	}
 	return 1;
 }
 
-void
-udf_write_super(struct super_block *sb)
+void udf_write_super(struct super_block *sb)
 {
 	lock_kernel();
+
 	if (!(sb->s_flags & MS_RDONLY))
 		udf_open_lvid(sb);
 	sb->s_dirt = 0;
+
 	unlock_kernel();
 }
 
-static int
-udf_remount_fs(struct super_block *sb, int *flags, char *options)
+static int udf_remount_fs(struct super_block *sb, int *flags, char *options)
 {
 	struct udf_options uopt;
 
-	uopt.flags = UDF_SB(sb)->s_flags ;
-	uopt.uid   = UDF_SB(sb)->s_uid ;
-	uopt.gid   = UDF_SB(sb)->s_gid ;
-	uopt.umask = UDF_SB(sb)->s_umask ;
+	uopt.flags = UDF_SB(sb)->s_flags;
+	uopt.uid   = UDF_SB(sb)->s_uid;
+	uopt.gid   = UDF_SB(sb)->s_gid;
+	uopt.umask = UDF_SB(sb)->s_umask;
 
-	if ( !udf_parse_options(options, &uopt) )
+	if (!udf_parse_options(options, &uopt))
 		return -EINVAL;
 
 	UDF_SB(sb)->s_flags = uopt.flags;
@@ -512,27 +514,26 @@ udf_remount_fs(struct super_block *sb, int *flags, char *options)
  *	July 1, 1997 - Andrew E. Mileski
  *	Written, tested, and released.
  */
-static  int
-udf_set_blocksize(struct super_block *sb, int bsize)
+static  int udf_set_blocksize(struct super_block *sb, int bsize)
 {
 	if (!sb_min_blocksize(sb, bsize)) {
 		udf_debug("Bad block size (%d)\n", bsize);
 		printk(KERN_ERR "udf: bad block size (%d)\n", bsize);
 		return 0;
 	}
+
 	return sb->s_blocksize;
 }
 
-static int
-udf_vrs(struct super_block *sb, int silent)
+static int udf_vrs(struct super_block *sb, int silent)
 {
 	struct volStructDesc *vsd = NULL;
 	int sector = 32768;
 	int sectorsize;
 	struct buffer_head *bh = NULL;
-	int iso9660=0;
-	int nsr02=0;
-	int nsr03=0;
+	int iso9660 = 0;
+	int nsr02 = 0;
+	int nsr03 = 0;
 
 	/* Block size must be a multiple of 512 */
 	if (sb->s_blocksize & 511)
@@ -546,10 +547,9 @@ udf_vrs(struct super_block *sb, int silent)
 	sector += (UDF_SB_SESSION(sb) << sb->s_blocksize_bits);
 
 	udf_debug("Starting at sector %u (%ld byte sectors)\n",
-		(sector >> sb->s_blocksize_bits), sb->s_blocksize);
+		  (sector >> sb->s_blocksize_bits), sb->s_blocksize);
 	/* Process the sequence (if applicable) */
-	for (;!nsr02 && !nsr03; sector += sectorsize)
-	{
+	for (; !nsr02 && !nsr03; sector += sectorsize) {
 		/* Read a block */
 		bh = udf_tread(sb, sector >> sb->s_blocksize_bits);
 		if (!bh)
@@ -557,52 +557,40 @@ udf_vrs(struct super_block *sb, int silent)
 
 		/* Look for ISO  descriptors */
 		vsd = (struct volStructDesc *)(bh->b_data +
-			(sector & (sb->s_blocksize - 1)));
+					       (sector & (sb->s_blocksize - 1)));
 
-		if (vsd->stdIdent[0] == 0)
-		{
+		if (vsd->stdIdent[0] == 0) {
 			brelse(bh);
 			break;
-		}
-		else if (!strncmp(vsd->stdIdent, VSD_STD_ID_CD001, VSD_STD_ID_LEN))
-		{
+		} else if (!strncmp(vsd->stdIdent, VSD_STD_ID_CD001, VSD_STD_ID_LEN)) {
 			iso9660 = sector;
-			switch (vsd->structType)
-			{
-				case 0: 
+			switch (vsd->structType) {
+				case 0:
 					udf_debug("ISO9660 Boot Record found\n");
 					break;
-				case 1: 
+				case 1:
 					udf_debug("ISO9660 Primary Volume Descriptor found\n");
 					break;
-				case 2: 
+				case 2:
 					udf_debug("ISO9660 Supplementary Volume Descriptor found\n");
 					break;
-				case 3: 
+				case 3:
 					udf_debug("ISO9660 Volume Partition Descriptor found\n");
 					break;
-				case 255: 
+				case 255:
 					udf_debug("ISO9660 Volume Descriptor Set Terminator found\n");
 					break;
-				default: 
+				default:
 					udf_debug("ISO9660 VRS (%u) found\n", vsd->structType);
 					break;
 			}
-		}
-		else if (!strncmp(vsd->stdIdent, VSD_STD_ID_BEA01, VSD_STD_ID_LEN))
-		{
-		}
-		else if (!strncmp(vsd->stdIdent, VSD_STD_ID_TEA01, VSD_STD_ID_LEN))
-		{
+		} else if (!strncmp(vsd->stdIdent, VSD_STD_ID_BEA01, VSD_STD_ID_LEN)) {
+		} else if (!strncmp(vsd->stdIdent, VSD_STD_ID_TEA01, VSD_STD_ID_LEN)) {
 			brelse(bh);
 			break;
-		}
-		else if (!strncmp(vsd->stdIdent, VSD_STD_ID_NSR02, VSD_STD_ID_LEN))
-		{
+		} else if (!strncmp(vsd->stdIdent, VSD_STD_ID_NSR02, VSD_STD_ID_LEN)) {
 			nsr02 = sector;
-		}
-		else if (!strncmp(vsd->stdIdent, VSD_STD_ID_NSR03, VSD_STD_ID_LEN))
-		{
+		} else if (!strncmp(vsd->stdIdent, VSD_STD_ID_NSR03, VSD_STD_ID_LEN)) {
 			nsr03 = sector;
 		}
 		brelse(bh);
@@ -635,8 +623,7 @@ udf_vrs(struct super_block *sb, int silent)
  *	July 1, 1997 - Andrew E. Mileski
  *	Written, tested, and released.
  */
-static void
-udf_find_anchor(struct super_block *sb)
+static void udf_find_anchor(struct super_block *sb)
 {
 	int lastblock = UDF_SB_LASTBLOCK(sb);
 	struct buffer_head *bh = NULL;
@@ -644,8 +631,7 @@ udf_find_anchor(struct super_block *sb)
 	uint32_t location;
 	int i;
 
-	if (lastblock)
-	{
+	if (lastblock) {
 		int varlastblock = udf_variable_to_fixed(lastblock);
 		int last[] =  { lastblock, lastblock - 2,
 				lastblock - 150, lastblock - 152,
@@ -663,74 +649,54 @@ udf_find_anchor(struct super_block *sb)
 		 *  however, if the disc isn't closed, it could be 512 */
 
 		for (i = 0; !lastblock && i < ARRAY_SIZE(last); i++) {
-			if (last[i] < 0 || !(bh = sb_bread(sb, last[i])))
-			{
+			if (last[i] < 0 || !(bh = sb_bread(sb, last[i]))) {
 				ident = location = 0;
-			}
-			else
-			{
+			} else {
 				ident = le16_to_cpu(((tag *)bh->b_data)->tagIdent);
 				location = le32_to_cpu(((tag *)bh->b_data)->tagLocation);
 				brelse(bh);
 			}
 
-			if (ident == TAG_IDENT_AVDP)
-			{
-				if (location == last[i] - UDF_SB_SESSION(sb))
-				{
+			if (ident == TAG_IDENT_AVDP) {
+				if (location == last[i] - UDF_SB_SESSION(sb)) {
 					lastblock = UDF_SB_ANCHOR(sb)[0] = last[i] - UDF_SB_SESSION(sb);
 					UDF_SB_ANCHOR(sb)[1] = last[i] - 256 - UDF_SB_SESSION(sb);
-				}
-				else if (location == udf_variable_to_fixed(last[i]) - UDF_SB_SESSION(sb))
-				{
+				} else if (location == udf_variable_to_fixed(last[i]) - UDF_SB_SESSION(sb)) {
 					UDF_SET_FLAG(sb, UDF_FLAG_VARCONV);
 					lastblock = UDF_SB_ANCHOR(sb)[0] = udf_variable_to_fixed(last[i]) - UDF_SB_SESSION(sb);
 					UDF_SB_ANCHOR(sb)[1] = lastblock - 256 - UDF_SB_SESSION(sb);
-				}
-				else
+				} else {
 					udf_debug("Anchor found at block %d, location mismatch %d.\n",
-						last[i], location);
-			}
-			else if (ident == TAG_IDENT_FE || ident == TAG_IDENT_EFE)
-			{
+						  last[i], location);
+				}
+			} else if (ident == TAG_IDENT_FE || ident == TAG_IDENT_EFE) {
 				lastblock = last[i];
 				UDF_SB_ANCHOR(sb)[3] = 512;
-			}
-			else
-			{
-				if (last[i] < 256 || !(bh = sb_bread(sb, last[i] - 256)))
-				{
+			} else {
+				if (last[i] < 256 || !(bh = sb_bread(sb, last[i] - 256))) {
 					ident = location = 0;
-				}
-				else
-				{
+				} else {
 					ident = le16_to_cpu(((tag *)bh->b_data)->tagIdent);
 					location = le32_to_cpu(((tag *)bh->b_data)->tagLocation);
 					brelse(bh);
 				}
-	
+
 				if (ident == TAG_IDENT_AVDP &&
-					location == last[i] - 256 - UDF_SB_SESSION(sb))
-				{
+				    location == last[i] - 256 - UDF_SB_SESSION(sb)) {
 					lastblock = last[i];
 					UDF_SB_ANCHOR(sb)[1] = last[i] - 256;
-				}
-				else
-				{
-					if (last[i] < 312 + UDF_SB_SESSION(sb) || !(bh = sb_bread(sb, last[i] - 312 - UDF_SB_SESSION(sb))))
-					{
+				} else {
+					if (last[i] < 312 + UDF_SB_SESSION(sb) ||
+					    !(bh = sb_bread(sb, last[i] - 312 - UDF_SB_SESSION(sb)))) {
 						ident = location = 0;
-					}
-					else
-					{
+					} else {
 						ident = le16_to_cpu(((tag *)bh->b_data)->tagIdent);
 						location = le32_to_cpu(((tag *)bh->b_data)->tagLocation);
 						brelse(bh);
 					}
-	
+
 					if (ident == TAG_IDENT_AVDP &&
-						location == udf_variable_to_fixed(last[i]) - 256)
-					{
+					    location == udf_variable_to_fixed(last[i]) - 256) {
 						UDF_SET_FLAG(sb, UDF_FLAG_VARCONV);
 						lastblock = udf_variable_to_fixed(last[i]);
 						UDF_SB_ANCHOR(sb)[1] = lastblock - 256;
@@ -740,11 +706,9 @@ udf_find_anchor(struct super_block *sb)
 		}
 	}
 
-	if (!lastblock)
-	{
+	if (!lastblock) {
 		/* We havn't found the lastblock. check 312 */
-		if ((bh = sb_bread(sb, 312 + UDF_SB_SESSION(sb))))
-		{
+		if ((bh = sb_bread(sb, 312 + UDF_SB_SESSION(sb)))) {
 			ident = le16_to_cpu(((tag *)bh->b_data)->tagIdent);
 			location = le32_to_cpu(((tag *)bh->b_data)->tagLocation);
 			brelse(bh);
@@ -755,19 +719,14 @@ udf_find_anchor(struct super_block *sb)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(UDF_SB_ANCHOR(sb)); i++) {
-		if (UDF_SB_ANCHOR(sb)[i])
-		{
-			if (!(bh = udf_read_tagged(sb,
-				UDF_SB_ANCHOR(sb)[i], UDF_SB_ANCHOR(sb)[i], &ident)))
-			{
+		if (UDF_SB_ANCHOR(sb)[i]) {
+			if (!(bh = udf_read_tagged(sb, UDF_SB_ANCHOR(sb)[i],
+						   UDF_SB_ANCHOR(sb)[i], &ident))) {
 				UDF_SB_ANCHOR(sb)[i] = 0;
-			}
-			else
-			{
+			} else {
 				brelse(bh);
-				if ((ident != TAG_IDENT_AVDP) && (i ||
-					(ident != TAG_IDENT_FE && ident != TAG_IDENT_EFE)))
-				{
+				if ((ident != TAG_IDENT_AVDP) &&
+				    (i || (ident != TAG_IDENT_FE && ident != TAG_IDENT_EFE))) {
 					UDF_SB_ANCHOR(sb)[i] = 0;
 				}
 			}
@@ -777,89 +736,77 @@ udf_find_anchor(struct super_block *sb)
 	UDF_SB_LASTBLOCK(sb) = lastblock;
 }
 
-static int 
-udf_find_fileset(struct super_block *sb, kernel_lb_addr *fileset, kernel_lb_addr *root)
+static int udf_find_fileset(struct super_block *sb, kernel_lb_addr *fileset, kernel_lb_addr *root)
 {
 	struct buffer_head *bh = NULL;
 	long lastblock;
 	uint16_t ident;
 
 	if (fileset->logicalBlockNum != 0xFFFFFFFF ||
-		fileset->partitionReferenceNum != 0xFFFF)
-	{
+	    fileset->partitionReferenceNum != 0xFFFF) {
 		bh = udf_read_ptagged(sb, *fileset, 0, &ident);
 
-		if (!bh)
+		if (!bh) {
 			return 1;
-		else if (ident != TAG_IDENT_FSD)
-		{
+		} else if (ident != TAG_IDENT_FSD) {
 			brelse(bh);
 			return 1;
 		}
-			
+
 	}
 
-	if (!bh) /* Search backwards through the partitions */
-	{
+	if (!bh) { /* Search backwards through the partitions */
 		kernel_lb_addr newfileset;
 
+/* --> cvg: FIXME - is it reasonable? */
 		return 1;
-		
+
 		for (newfileset.partitionReferenceNum=UDF_SB_NUMPARTS(sb)-1;
-			(newfileset.partitionReferenceNum != 0xFFFF &&
-				fileset->logicalBlockNum == 0xFFFFFFFF &&
-				fileset->partitionReferenceNum == 0xFFFF);
-			newfileset.partitionReferenceNum--)
-		{
+		     (newfileset.partitionReferenceNum != 0xFFFF &&
+		      fileset->logicalBlockNum == 0xFFFFFFFF &&
+		      fileset->partitionReferenceNum == 0xFFFF);
+		     newfileset.partitionReferenceNum--) {
 			lastblock = UDF_SB_PARTLEN(sb, newfileset.partitionReferenceNum);
 			newfileset.logicalBlockNum = 0;
 
-			do
-			{
+			do {
 				bh = udf_read_ptagged(sb, newfileset, 0, &ident);
-				if (!bh)
-				{
-					newfileset.logicalBlockNum ++;
+				if (!bh) {
+					newfileset.logicalBlockNum++;
 					continue;
 				}
 
-				switch (ident)
-				{
+				switch (ident) {
 					case TAG_IDENT_SBD:
 					{
 						struct spaceBitmapDesc *sp;
 						sp = (struct spaceBitmapDesc *)bh->b_data;
 						newfileset.logicalBlockNum += 1 +
-							((le32_to_cpu(sp->numOfBytes) + sizeof(struct spaceBitmapDesc) - 1)
-								>> sb->s_blocksize_bits);
+							((le32_to_cpu(sp->numOfBytes) +
+							  sizeof(struct spaceBitmapDesc) - 1)
+							 >> sb->s_blocksize_bits);
 						brelse(bh);
 						break;
 					}
 					case TAG_IDENT_FSD:
-					{
 						*fileset = newfileset;
 						break;
-					}
 					default:
-					{
-						newfileset.logicalBlockNum ++;
+						newfileset.logicalBlockNum++;
 						brelse(bh);
 						bh = NULL;
 						break;
-					}
 				}
-			}
-			while (newfileset.logicalBlockNum < lastblock &&
-				fileset->logicalBlockNum == 0xFFFFFFFF &&
-				fileset->partitionReferenceNum == 0xFFFF);
+			} while (newfileset.logicalBlockNum < lastblock &&
+				 fileset->logicalBlockNum == 0xFFFFFFFF &&
+				 fileset->partitionReferenceNum == 0xFFFF);
 		}
 	}
 
 	if ((fileset->logicalBlockNum != 0xFFFFFFFF ||
-		fileset->partitionReferenceNum != 0xFFFF) && bh)
-	{
+	     fileset->partitionReferenceNum != 0xFFFF) && bh) {
 		udf_debug("Fileset at block=%d, partition=%d\n",
-			fileset->logicalBlockNum, fileset->partitionReferenceNum);
+			  fileset->logicalBlockNum, fileset->partitionReferenceNum);
 
 		UDF_SB_PARTITION(sb) = fileset->partitionReferenceNum;
 		udf_load_fileset(sb, bh, root);
@@ -869,8 +816,7 @@ udf_find_fileset(struct super_block *sb, kernel_lb_addr *fileset, kernel_lb_addr
 	return 1;
 }
 
-static void 
-udf_load_pvoldesc(struct super_block *sb, struct buffer_head *bh)
+static void udf_load_pvoldesc(struct super_block *sb, struct buffer_head *bh)
 {
 	struct primaryVolDesc *pvoldesc;
 	time_t recording;
@@ -880,37 +826,34 @@ udf_load_pvoldesc(struct super_block *sb, struct buffer_head *bh)
 
 	pvoldesc = (struct primaryVolDesc *)bh->b_data;
 
-	if ( udf_stamp_to_time(&recording, &recording_usec,
-		lets_to_cpu(pvoldesc->recordingDateAndTime)) )
-	{
+	if (udf_stamp_to_time(&recording, &recording_usec,
+			      lets_to_cpu(pvoldesc->recordingDateAndTime))) {
 		kernel_timestamp ts;
 		ts = lets_to_cpu(pvoldesc->recordingDateAndTime);
 		udf_debug("recording time %ld/%ld, %04u/%02u/%02u %02u:%02u (%x)\n",
-			recording, recording_usec,
-			ts.year, ts.month, ts.day, ts.hour, ts.minute, ts.typeAndTimezone);
+			  recording, recording_usec,
+			  ts.year, ts.month, ts.day, ts.hour,
+			  ts.minute, ts.typeAndTimezone);
 		UDF_SB_RECORDTIME(sb).tv_sec = recording;
 		UDF_SB_RECORDTIME(sb).tv_nsec = recording_usec * 1000;
 	}
 
-	if ( !udf_build_ustr(&instr, pvoldesc->volIdent, 32) )
-	{
-		if (udf_CS0toUTF8(&outstr, &instr))
-		{
-			strncpy( UDF_SB_VOLIDENT(sb), outstr.u_name,
+	if (!udf_build_ustr(&instr, pvoldesc->volIdent, 32)) {
+		if (udf_CS0toUTF8(&outstr, &instr)) {
+			strncpy(UDF_SB_VOLIDENT(sb), outstr.u_name,
 				outstr.u_len > 31 ? 31 : outstr.u_len);
 			udf_debug("volIdent[] = '%s'\n", UDF_SB_VOLIDENT(sb));
 		}
 	}
 
-	if ( !udf_build_ustr(&instr, pvoldesc->volSetIdent, 128) )
-	{
+	if (!udf_build_ustr(&instr, pvoldesc->volSetIdent, 128)) {
 		if (udf_CS0toUTF8(&outstr, &instr))
 			udf_debug("volSetIdent[] = '%s'\n", outstr.u_name);
 	}
 }
 
-static void 
-udf_load_fileset(struct super_block *sb, struct buffer_head *bh, kernel_lb_addr *root)
+static void udf_load_fileset(struct super_block *sb, struct buffer_head *bh,
+			     kernel_lb_addr *root)
 {
 	struct fileSetDesc *fset;
 
@@ -920,24 +863,21 @@ udf_load_fileset(struct super_block *sb, struct buffer_head *bh, kernel_lb_addr
 
 	UDF_SB_SERIALNUM(sb) = le16_to_cpu(fset->descTag.tagSerialNum);
 
-	udf_debug("Rootdir at block=%d, partition=%d\n", 
-		root->logicalBlockNum, root->partitionReferenceNum);
+	udf_debug("Rootdir at block=%d, partition=%d\n",
+		  root->logicalBlockNum, root->partitionReferenceNum);
 }
 
-static void 
-udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
+static void udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 {
 	struct partitionDesc *p;
 	int i;
 
 	p = (struct partitionDesc *)bh->b_data;
 
-	for (i=0; i<UDF_SB_NUMPARTS(sb); i++)
-	{
-		udf_debug("Searching map: (%d == %d)\n", 
-			UDF_SB_PARTMAPS(sb)[i].s_partition_num, le16_to_cpu(p->partitionNumber));
-		if (UDF_SB_PARTMAPS(sb)[i].s_partition_num == le16_to_cpu(p->partitionNumber))
-		{
+	for (i = 0; i < UDF_SB_NUMPARTS(sb); i++) {
+		udf_debug("Searching map: (%d == %d)\n",
+			  UDF_SB_PARTMAPS(sb)[i].s_partition_num, le16_to_cpu(p->partitionNumber));
+		if (UDF_SB_PARTMAPS(sb)[i].s_partition_num == le16_to_cpu(p->partitionNumber)) {
 			UDF_SB_PARTLEN(sb,i) = le32_to_cpu(p->partitionLength); /* blocks */
 			UDF_SB_PARTROOT(sb,i) = le32_to_cpu(p->partitionStartingLocation);
 			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_READ_ONLY)
@@ -950,79 +890,76 @@ udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 				UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_OVERWRITABLE;
 
 			if (!strcmp(p->partitionContents.ident, PD_PARTITION_CONTENTS_NSR02) ||
-				!strcmp(p->partitionContents.ident, PD_PARTITION_CONTENTS_NSR03))
-			{
+			    !strcmp(p->partitionContents.ident, PD_PARTITION_CONTENTS_NSR03)) {
 				struct partitionHeaderDesc *phd;
 
 				phd = (struct partitionHeaderDesc *)(p->partitionContentsUse);
-				if (phd->unallocSpaceTable.extLength)
-				{
-					kernel_lb_addr loc = { le32_to_cpu(phd->unallocSpaceTable.extPosition), i };
+				if (phd->unallocSpaceTable.extLength) {
+					kernel_lb_addr loc = {
+						.logicalBlockNum = le32_to_cpu(phd->unallocSpaceTable.extPosition),
+						.partitionReferenceNum = i,
+					};
 
 					UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table =
 						udf_iget(sb, loc);
 					UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_UNALLOC_TABLE;
 					udf_debug("unallocSpaceTable (part %d) @ %ld\n",
-						i, UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table->i_ino);
+						  i, UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table->i_ino);
 				}
-				if (phd->unallocSpaceBitmap.extLength)
-				{
+				if (phd->unallocSpaceBitmap.extLength) {
 					UDF_SB_ALLOC_BITMAP(sb, i, s_uspace);
-					if (UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap != NULL)
-					{
+					if (UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap != NULL) {
 						UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap->s_extLength =
 							le32_to_cpu(phd->unallocSpaceBitmap.extLength);
 						UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap->s_extPosition =
 							le32_to_cpu(phd->unallocSpaceBitmap.extPosition);
 						UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_UNALLOC_BITMAP;
 						udf_debug("unallocSpaceBitmap (part %d) @ %d\n",
-							i, UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap->s_extPosition);
+							  i, UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap->s_extPosition);
 					}
 				}
 				if (phd->partitionIntegrityTable.extLength)
 					udf_debug("partitionIntegrityTable (part %d)\n", i);
-				if (phd->freedSpaceTable.extLength)
-				{
-					kernel_lb_addr loc = { le32_to_cpu(phd->freedSpaceTable.extPosition), i };
+				if (phd->freedSpaceTable.extLength) {
+					kernel_lb_addr loc = {
+						.logicalBlockNum = le32_to_cpu(phd->freedSpaceTable.extPosition),
+						.partitionReferenceNum = i,
+					};
 
 					UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table =
 						udf_iget(sb, loc);
 					UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_FREED_TABLE;
 					udf_debug("freedSpaceTable (part %d) @ %ld\n",
-						i, UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table->i_ino);
+						  i, UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table->i_ino);
 				}
-				if (phd->freedSpaceBitmap.extLength)
-				{
+				if (phd->freedSpaceBitmap.extLength) {
 					UDF_SB_ALLOC_BITMAP(sb, i, s_fspace);
-					if (UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap != NULL)
-					{
+					if (UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap != NULL) {
 						UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap->s_extLength =
 							le32_to_cpu(phd->freedSpaceBitmap.extLength);
 						UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap->s_extPosition =
 							le32_to_cpu(phd->freedSpaceBitmap.extPosition);
 						UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_FREED_BITMAP;
 						udf_debug("freedSpaceBitmap (part %d) @ %d\n",
-							i, UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap->s_extPosition);
+							  i, UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap->s_extPosition);
 					}
 				}
 			}
 			break;
 		}
 	}
-	if (i == UDF_SB_NUMPARTS(sb))
-	{
-		udf_debug("Partition (%d) not found in partition map\n", le16_to_cpu(p->partitionNumber));
-	}
-	else
-	{
+	if (i == UDF_SB_NUMPARTS(sb)) {
+		udf_debug("Partition (%d) not found in partition map\n",
+			  le16_to_cpu(p->partitionNumber));
+	} else {
 		udf_debug("Partition (%d:%d type %x) starts at physical %d, block length %d\n",
-			le16_to_cpu(p->partitionNumber), i, UDF_SB_PARTTYPE(sb,i),
-			UDF_SB_PARTROOT(sb,i), UDF_SB_PARTLEN(sb,i));
+			  le16_to_cpu(p->partitionNumber), i, UDF_SB_PARTTYPE(sb,i),
+			  UDF_SB_PARTROOT(sb,i), UDF_SB_PARTLEN(sb,i));
 	}
 }
 
-static int 
-udf_load_logicalvol(struct super_block *sb, struct buffer_head * bh, kernel_lb_addr *fileset)
+static int udf_load_logicalvol(struct super_block *sb, struct buffer_head * bh,
+			       kernel_lb_addr *fileset)
 {
 	struct logicalVolDesc *lvd;
 	int i, j, offset;
@@ -1032,37 +969,27 @@ udf_load_logicalvol(struct super_block *sb, struct buffer_head * bh, kernel_lb_a
 
 	UDF_SB_ALLOC_PARTMAPS(sb, le32_to_cpu(lvd->numPartitionMaps));
 
-	for (i=0,offset=0;
-		 i<UDF_SB_NUMPARTS(sb) && offset<le32_to_cpu(lvd->mapTableLength);
-		 i++,offset+=((struct genericPartitionMap *)&(lvd->partitionMaps[offset]))->partitionMapLength)
-	{
+	for (i = 0,offset = 0;
+	     i < UDF_SB_NUMPARTS(sb) && offset < le32_to_cpu(lvd->mapTableLength);
+	     i++, offset += ((struct genericPartitionMap *)&(lvd->partitionMaps[offset]))->partitionMapLength) {
 		type = ((struct genericPartitionMap *)&(lvd->partitionMaps[offset]))->partitionMapType;
-		if (type == 1)
-		{
+		if (type == 1) {
 			struct genericPartitionMap1 *gpm1 = (struct genericPartitionMap1 *)&(lvd->partitionMaps[offset]);
 			UDF_SB_PARTTYPE(sb,i) = UDF_TYPE1_MAP15;
 			UDF_SB_PARTVSN(sb,i) = le16_to_cpu(gpm1->volSeqNum);
 			UDF_SB_PARTNUM(sb,i) = le16_to_cpu(gpm1->partitionNum);
 			UDF_SB_PARTFUNC(sb,i) = NULL;
-		}
-		else if (type == 2)
-		{
+		} else if (type == 2) {
 			struct udfPartitionMap2 *upm2 = (struct udfPartitionMap2 *)&(lvd->partitionMaps[offset]);
-			if (!strncmp(upm2->partIdent.ident, UDF_ID_VIRTUAL, strlen(UDF_ID_VIRTUAL)))
-			{
-				if (le16_to_cpu(((__le16 *)upm2->partIdent.identSuffix)[0]) == 0x0150)
-				{
+			if (!strncmp(upm2->partIdent.ident, UDF_ID_VIRTUAL, strlen(UDF_ID_VIRTUAL))) {
+				if (le16_to_cpu(((__le16 *)upm2->partIdent.identSuffix)[0]) == 0x0150) {
 					UDF_SB_PARTTYPE(sb,i) = UDF_VIRTUAL_MAP15;
 					UDF_SB_PARTFUNC(sb,i) = udf_get_pblock_virt15;
-				}
-				else if (le16_to_cpu(((__le16 *)upm2->partIdent.identSuffix)[0]) == 0x0200)
-				{
+				} else if (le16_to_cpu(((__le16 *)upm2->partIdent.identSuffix)[0]) == 0x0200) {
 					UDF_SB_PARTTYPE(sb,i) = UDF_VIRTUAL_MAP20;
 					UDF_SB_PARTFUNC(sb,i) = udf_get_pblock_virt20;
 				}
-			}
-			else if (!strncmp(upm2->partIdent.ident, UDF_ID_SPARABLE, strlen(UDF_ID_SPARABLE)))
-			{
+			} else if (!strncmp(upm2->partIdent.ident, UDF_ID_SPARABLE, strlen(UDF_ID_SPARABLE))) {
 				uint32_t loc;
 				uint16_t ident;
 				struct sparingTable *st;
@@ -1070,26 +997,21 @@ udf_load_logicalvol(struct super_block *sb, struct buffer_head * bh, kernel_lb_a
 
 				UDF_SB_PARTTYPE(sb,i) = UDF_SPARABLE_MAP15;
 				UDF_SB_TYPESPAR(sb,i).s_packet_len = le16_to_cpu(spm->packetLength);
-				for (j=0; j<spm->numSparingTables; j++)
-				{
+				for (j = 0; j < spm->numSparingTables; j++) {
 					loc = le32_to_cpu(spm->locSparingTable[j]);
 					UDF_SB_TYPESPAR(sb,i).s_spar_map[j] =
 						udf_read_tagged(sb, loc, loc, &ident);
-					if (UDF_SB_TYPESPAR(sb,i).s_spar_map[j] != NULL)
-					{
+					if (UDF_SB_TYPESPAR(sb,i).s_spar_map[j] != NULL) {
 						st = (struct sparingTable *)UDF_SB_TYPESPAR(sb,i).s_spar_map[j]->b_data;
 						if (ident != 0 ||
-							strncmp(st->sparingIdent.ident, UDF_ID_SPARING, strlen(UDF_ID_SPARING)))
-						{
+						    strncmp(st->sparingIdent.ident, UDF_ID_SPARING, strlen(UDF_ID_SPARING))) {
 							brelse(UDF_SB_TYPESPAR(sb,i).s_spar_map[j]);
 							UDF_SB_TYPESPAR(sb,i).s_spar_map[j] = NULL;
 						}
 					}
 				}
 				UDF_SB_PARTFUNC(sb,i) = udf_get_pblock_spar15;
-			}
-			else
-			{
+			} else {
 				udf_debug("Unknown ident: %s\n", upm2->partIdent.ident);
 				continue;
 			}
@@ -1097,20 +1019,20 @@ udf_load_logicalvol(struct super_block *sb, struct buffer_head * bh, kernel_lb_a
 			UDF_SB_PARTNUM(sb,i) = le16_to_cpu(upm2->partitionNum);
 		}
 		udf_debug("Partition (%d:%d) type %d on volume %d\n",
-			i, UDF_SB_PARTNUM(sb,i), type, UDF_SB_PARTVSN(sb,i));
+			  i, UDF_SB_PARTNUM(sb,i), type, UDF_SB_PARTVSN(sb,i));
 	}
 
-	if (fileset)
-	{
+	if (fileset) {
 		long_ad *la = (long_ad *)&(lvd->logicalVolContentsUse[0]);
 
 		*fileset = lelb_to_cpu(la->extLocation);
 		udf_debug("FileSet found in LogicalVolDesc at block=%d, partition=%d\n",
-			fileset->logicalBlockNum,
-			fileset->partitionReferenceNum);
+			  fileset->logicalBlockNum,
+			  fileset->partitionReferenceNum);
 	}
 	if (lvd->integritySeqExt.extLength)
 		udf_load_logicalvolint(sb, leea_to_cpu(lvd->integritySeqExt));
+
 	return 0;
 }
 
@@ -1118,26 +1040,24 @@ udf_load_logicalvol(struct super_block *sb, struct buffer_head * bh, kernel_lb_a
  * udf_load_logicalvolint
  *
  */
-static void
-udf_load_logicalvolint(struct super_block *sb, kernel_extent_ad loc)
+static void udf_load_logicalvolint(struct super_block *sb, kernel_extent_ad loc)
 {
 	struct buffer_head *bh = NULL;
 	uint16_t ident;
 
 	while (loc.extLength > 0 &&
-		(bh = udf_read_tagged(sb, loc.extLocation,
-			loc.extLocation, &ident)) &&
-		ident == TAG_IDENT_LVID)
-	{
+	       (bh = udf_read_tagged(sb, loc.extLocation,
+				     loc.extLocation, &ident)) &&
+	       ident == TAG_IDENT_LVID) {
 		UDF_SB_LVIDBH(sb) = bh;
-		
+
 		if (UDF_SB_LVID(sb)->nextIntegrityExt.extLength)
 			udf_load_logicalvolint(sb, leea_to_cpu(UDF_SB_LVID(sb)->nextIntegrityExt));
-		
+
 		if (UDF_SB_LVIDBH(sb) != bh)
 			brelse(bh);
 		loc.extLength -= sb->s_blocksize;
-		loc.extLocation ++;
+		loc.extLocation++;
 	}
 	if (UDF_SB_LVIDBH(sb) != bh)
 		brelse(bh);
@@ -1158,14 +1078,14 @@ udf_load_logicalvolint(struct super_block *sb, kernel_extent_ad loc)
  *	July 1, 1997 - Andrew E. Mileski
  *	Written, tested, and released.
  */
-static  int
-udf_process_sequence(struct super_block *sb, long block, long lastblock, kernel_lb_addr *fileset)
+static  int udf_process_sequence(struct super_block *sb, long block, long lastblock,
+				 kernel_lb_addr *fileset)
 {
 	struct buffer_head *bh = NULL;
 	struct udf_vds_record vds[VDS_POS_LENGTH];
 	struct generic_desc *gd;
 	struct volDescPtr *vdp;
-	int done=0;
+	int done = 0;
 	int i,j;
 	uint32_t vdsn;
 	uint16_t ident;
@@ -1174,28 +1094,24 @@ udf_process_sequence(struct super_block *sb, long block, long lastblock, kernel_
 	memset(vds, 0, sizeof(struct udf_vds_record) * VDS_POS_LENGTH);
 
 	/* Read the main descriptor sequence */
-	for (;(!done && block <= lastblock); block++)
-	{
+	for (; (!done && block <= lastblock); block++) {
 
 		bh = udf_read_tagged(sb, block, block, &ident);
-		if (!bh) 
+		if (!bh)
 			break;
 
 		/* Process each descriptor (ISO 13346 3/8.3-8.4) */
 		gd = (struct generic_desc *)bh->b_data;
 		vdsn = le32_to_cpu(gd->volDescSeqNum);
-		switch (ident)
-		{
+		switch (ident) {
 			case TAG_IDENT_PVD: /* ISO 13346 3/10.1 */
-				if (vdsn >= vds[VDS_POS_PRIMARY_VOL_DESC].volDescSeqNum)
-				{
+				if (vdsn >= vds[VDS_POS_PRIMARY_VOL_DESC].volDescSeqNum) {
 					vds[VDS_POS_PRIMARY_VOL_DESC].volDescSeqNum = vdsn;
 					vds[VDS_POS_PRIMARY_VOL_DESC].block = block;
 				}
 				break;
 			case TAG_IDENT_VDP: /* ISO 13346 3/10.3 */
-				if (vdsn >= vds[VDS_POS_VOL_DESC_PTR].volDescSeqNum)
-				{
+				if (vdsn >= vds[VDS_POS_VOL_DESC_PTR].volDescSeqNum) {
 					vds[VDS_POS_VOL_DESC_PTR].volDescSeqNum = vdsn;
 					vds[VDS_POS_VOL_DESC_PTR].block = block;
 
@@ -1207,8 +1123,7 @@ udf_process_sequence(struct super_block *sb, long block, long lastblock, kernel_
 				}
 				break;
 			case TAG_IDENT_IUVD: /* ISO 13346 3/10.4 */
-				if (vdsn >= vds[VDS_POS_IMP_USE_VOL_DESC].volDescSeqNum)
-				{
+				if (vdsn >= vds[VDS_POS_IMP_USE_VOL_DESC].volDescSeqNum) {
 					vds[VDS_POS_IMP_USE_VOL_DESC].volDescSeqNum = vdsn;
 					vds[VDS_POS_IMP_USE_VOL_DESC].block = block;
 				}
@@ -1218,49 +1133,42 @@ udf_process_sequence(struct super_block *sb, long block, long lastblock, kernel_
 					vds[VDS_POS_PARTITION_DESC].block = block;
 				break;
 			case TAG_IDENT_LVD: /* ISO 13346 3/10.6 */
-				if (vdsn >= vds[VDS_POS_LOGICAL_VOL_DESC].volDescSeqNum)
-				{
+				if (vdsn >= vds[VDS_POS_LOGICAL_VOL_DESC].volDescSeqNum) {
 					vds[VDS_POS_LOGICAL_VOL_DESC].volDescSeqNum = vdsn;
 					vds[VDS_POS_LOGICAL_VOL_DESC].block = block;
 				}
 				break;
 			case TAG_IDENT_USD: /* ISO 13346 3/10.8 */
-				if (vdsn >= vds[VDS_POS_UNALLOC_SPACE_DESC].volDescSeqNum)
-				{
+				if (vdsn >= vds[VDS_POS_UNALLOC_SPACE_DESC].volDescSeqNum) {
 					vds[VDS_POS_UNALLOC_SPACE_DESC].volDescSeqNum = vdsn;
 					vds[VDS_POS_UNALLOC_SPACE_DESC].block = block;
 				}
 				break;
 			case TAG_IDENT_TD: /* ISO 13346 3/10.9 */
 				vds[VDS_POS_TERMINATING_DESC].block = block;
-				if (next_e)
-				{
+				if (next_e) {
 					block = next_s;
 					lastblock = next_e;
 					next_s = next_e = 0;
-				}
-				else
+				} else {
 					done = 1;
+				}
 				break;
 		}
 		brelse(bh);
 	}
-	for (i=0; i<VDS_POS_LENGTH; i++)
-	{
-		if (vds[i].block)
-		{
+	for (i = 0; i < VDS_POS_LENGTH; i++) {
+		if (vds[i].block) {
 			bh = udf_read_tagged(sb, vds[i].block, vds[i].block, &ident);
 
-			if (i == VDS_POS_PRIMARY_VOL_DESC)
+			if (i == VDS_POS_PRIMARY_VOL_DESC) {
 				udf_load_pvoldesc(sb, bh);
-			else if (i == VDS_POS_LOGICAL_VOL_DESC)
+			} else if (i == VDS_POS_LOGICAL_VOL_DESC) {
 				udf_load_logicalvol(sb, bh, fileset);
-			else if (i == VDS_POS_PARTITION_DESC)
-			{
+			} else if (i == VDS_POS_PARTITION_DESC) {
 				struct buffer_head *bh2 = NULL;
 				udf_load_partdesc(sb, bh);
-				for (j=vds[i].block+1; j<vds[VDS_POS_TERMINATING_DESC].block; j++)
-				{
+				for (j = vds[i].block + 1; j <  vds[VDS_POS_TERMINATING_DESC].block; j++) {
 					bh2 = udf_read_tagged(sb, j, j, &ident);
 					gd = (struct generic_desc *)bh2->b_data;
 					if (ident == TAG_IDENT_PD)
@@ -1278,31 +1186,28 @@ udf_process_sequence(struct super_block *sb, long block, long lastblock, kernel_
 /*
  * udf_check_valid()
  */
-static int
-udf_check_valid(struct super_block *sb, int novrs, int silent)
+static int udf_check_valid(struct super_block *sb, int novrs, int silent)
 {
 	long block;
 
-	if (novrs)
-	{
+	if (novrs) {
 		udf_debug("Validity check skipped because of novrs option\n");
 		return 0;
 	}
 	/* Check that it is NSR02 compliant */
 	/* Process any "CD-ROM Volume Descriptor Set" (ECMA 167 2/8.3.1) */
-	else if ((block = udf_vrs(sb, silent)) == -1)
-	{
-		udf_debug("Failed to read byte 32768. Assuming open disc. Skipping validity check\n");
+	else if ((block = udf_vrs(sb, silent)) == -1) {
+		udf_debug("Failed to read byte 32768. Assuming open disc. "
+			  "Skipping validity check\n");
 		if (!UDF_SB_LASTBLOCK(sb))
 			UDF_SB_LASTBLOCK(sb) = udf_get_last_block(sb);
 		return 0;
-	}
-	else 
+	} else {
 		return !block;
+	}
 }
 
-static int
-udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
+static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 {
 	struct anchorVolDescPtr *anchor;
 	uint16_t ident;
@@ -1314,9 +1219,9 @@ udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 		return 1;
 
 	for (i = 0; i < ARRAY_SIZE(UDF_SB_ANCHOR(sb)); i++) {
-		if (UDF_SB_ANCHOR(sb)[i] && (bh = udf_read_tagged(sb,
-			UDF_SB_ANCHOR(sb)[i], UDF_SB_ANCHOR(sb)[i], &ident)))
-		{
+		if (UDF_SB_ANCHOR(sb)[i] &&
+		    (bh = udf_read_tagged(sb, UDF_SB_ANCHOR(sb)[i],
+					  UDF_SB_ANCHOR(sb)[i], &ident))) {
 			anchor = (struct anchorVolDescPtr *)bh->b_data;
 
 			/* Locate the main sequence */
@@ -1336,8 +1241,7 @@ udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 			/* Process the main & reserve sequences */
 			/* responsible for finding the PartitionDesc(s) */
 			if (!(udf_process_sequence(sb, main_s, main_e, fileset) &&
-				udf_process_sequence(sb, reserve_s, reserve_e, fileset)))
-			{
+			      udf_process_sequence(sb, reserve_s, reserve_e, fileset))) {
 				break;
 			}
 		}
@@ -1346,56 +1250,47 @@ udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 	if (i == ARRAY_SIZE(UDF_SB_ANCHOR(sb))) {
 		udf_debug("No Anchor block found\n");
 		return 1;
-	} else
+	} else {
 		udf_debug("Using anchor in block %d\n", UDF_SB_ANCHOR(sb)[i]);
+	}
 
-	for (i=0; i<UDF_SB_NUMPARTS(sb); i++)
-	{
-		switch UDF_SB_PARTTYPE(sb, i)
-		{
+	for (i = 0; i < UDF_SB_NUMPARTS(sb); i++) {
+		switch UDF_SB_PARTTYPE(sb, i) {
 			case UDF_VIRTUAL_MAP15:
 			case UDF_VIRTUAL_MAP20:
 			{
 				kernel_lb_addr ino;
 
-				if (!UDF_SB_LASTBLOCK(sb))
-				{
+				if (!UDF_SB_LASTBLOCK(sb)) {
 					UDF_SB_LASTBLOCK(sb) = udf_get_last_block(sb);
 					udf_find_anchor(sb);
 				}
 
-				if (!UDF_SB_LASTBLOCK(sb))
-				{
+				if (!UDF_SB_LASTBLOCK(sb)) {
 					udf_debug("Unable to determine Lastblock (For Virtual Partition)\n");
 					return 1;
 				}
 
-				for (j=0; j<UDF_SB_NUMPARTS(sb); j++)
-				{
+				for (j = 0; j < UDF_SB_NUMPARTS(sb); j++) {
 					if (j != i &&
-						UDF_SB_PARTVSN(sb,i) == UDF_SB_PARTVSN(sb,j) &&
-						UDF_SB_PARTNUM(sb,i) == UDF_SB_PARTNUM(sb,j))
-					{
+					    UDF_SB_PARTVSN(sb,i) == UDF_SB_PARTVSN(sb,j) &&
+					    UDF_SB_PARTNUM(sb,i) == UDF_SB_PARTNUM(sb,j)) {
 						ino.partitionReferenceNum = j;
 						ino.logicalBlockNum = UDF_SB_LASTBLOCK(sb) -
 							UDF_SB_PARTROOT(sb,j);
 						break;
 					}
 				}
-
 				if (j == UDF_SB_NUMPARTS(sb))
 					return 1;
 
 				if (!(UDF_SB_VAT(sb) = udf_iget(sb, ino)))
 					return 1;
 
-				if (UDF_SB_PARTTYPE(sb,i) == UDF_VIRTUAL_MAP15)
-				{
+				if (UDF_SB_PARTTYPE(sb,i) == UDF_VIRTUAL_MAP15) {
 					UDF_SB_TYPEVIRT(sb,i).s_start_offset = udf_ext0_offset(UDF_SB_VAT(sb));
 					UDF_SB_TYPEVIRT(sb,i).s_num_entries = (UDF_SB_VAT(sb)->i_size - 36) >> 2;
-				}
-				else if (UDF_SB_PARTTYPE(sb,i) == UDF_VIRTUAL_MAP20)
-				{
+				} else if (UDF_SB_PARTTYPE(sb,i) == UDF_VIRTUAL_MAP20) {
 					struct buffer_head *bh = NULL;
 					uint32_t pos;
 
@@ -1405,9 +1300,9 @@ udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 						return 1;
 					UDF_SB_TYPEVIRT(sb,i).s_start_offset =
 						le16_to_cpu(((struct virtualAllocationTable20 *)bh->b_data + udf_ext0_offset(UDF_SB_VAT(sb)))->lengthHeader) +
-							udf_ext0_offset(UDF_SB_VAT(sb));
+						udf_ext0_offset(UDF_SB_VAT(sb));
 					UDF_SB_TYPEVIRT(sb,i).s_num_entries = (UDF_SB_VAT(sb)->i_size -
-						UDF_SB_TYPEVIRT(sb,i).s_start_offset) >> 2;
+									       UDF_SB_TYPEVIRT(sb,i).s_start_offset) >> 2;
 					brelse(bh);
 				}
 				UDF_SB_PARTROOT(sb,i) = udf_get_pblock(sb, 0, i, 0);
@@ -1415,16 +1310,16 @@ udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 			}
 		}
 	}
+
 	return 0;
 }
 
 static void udf_open_lvid(struct super_block *sb)
 {
-	if (UDF_SB_LVIDBH(sb))
-	{
-		int i;
-		kernel_timestamp cpu_time;
+	kernel_timestamp cpu_time;
+	int i;
 
+	if (UDF_SB_LVIDBH(sb)) {
 		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
 		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
 		if (udf_time_to_stamp(&cpu_time, CURRENT_TIME))
@@ -1436,7 +1331,7 @@ static void udf_open_lvid(struct super_block *sb)
 			le16_to_cpu(UDF_SB_LVID(sb)->descTag.descCRCLength), 0));
 
 		UDF_SB_LVID(sb)->descTag.tagChecksum = 0;
-		for (i=0; i<16; i++)
+		for (i = 0; i < 16; i++)
 			if (i != 4)
 				UDF_SB_LVID(sb)->descTag.tagChecksum +=
 					((uint8_t *)&(UDF_SB_LVID(sb)->descTag))[i];
@@ -1447,12 +1342,11 @@ static void udf_open_lvid(struct super_block *sb)
 
 static void udf_close_lvid(struct super_block *sb)
 {
-	if (UDF_SB_LVIDBH(sb) &&
-		UDF_SB_LVID(sb)->integrityType == LVID_INTEGRITY_TYPE_OPEN)
-	{
-		int i;
-		kernel_timestamp cpu_time;
+	kernel_timestamp cpu_time;
+	int i;
 
+	if (UDF_SB_LVIDBH(sb) &&
+	    UDF_SB_LVID(sb)->integrityType == LVID_INTEGRITY_TYPE_OPEN) {
 		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
 		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
 		if (udf_time_to_stamp(&cpu_time, CURRENT_TIME))
@@ -1467,10 +1361,10 @@ static void udf_close_lvid(struct super_block *sb)
 
 		UDF_SB_LVID(sb)->descTag.descCRC =
 			cpu_to_le16(udf_crc((char *)UDF_SB_LVID(sb) + sizeof(tag),
-			le16_to_cpu(UDF_SB_LVID(sb)->descTag.descCRCLength), 0));
+					    le16_to_cpu(UDF_SB_LVID(sb)->descTag.descCRCLength), 0));
 
 		UDF_SB_LVID(sb)->descTag.tagChecksum = 0;
-		for (i=0; i<16; i++)
+		for (i = 0; i < 16; i++)
 			if (i != 4)
 				UDF_SB_LVID(sb)->descTag.tagChecksum +=
 					((uint8_t *)&(UDF_SB_LVID(sb)->descTag))[i];
@@ -1511,6 +1405,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	sbi = kmalloc(sizeof(struct udf_sb_info), GFP_KERNEL);
 	if (!sbi)
 		return -ENOMEM;
+
 	sb->s_fs_info = sbi;
 	memset(UDF_SB(sb), 0x00, sizeof(struct udf_sb_info));
 
@@ -1520,15 +1415,13 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 		goto error_out;
 
 	if (uopt.flags & (1 << UDF_FLAG_UTF8) &&
-	    uopt.flags & (1 << UDF_FLAG_NLS_MAP))
-	{
+	    uopt.flags & (1 << UDF_FLAG_NLS_MAP)) {
 		udf_error(sb, "udf_read_super",
-			"utf8 cannot be combined with iocharset\n");
+			  "utf8 cannot be combined with iocharset\n");
 		goto error_out;
 	}
 #ifdef CONFIG_UDF_NLS
-	if ((uopt.flags & (1 << UDF_FLAG_NLS_MAP)) && !uopt.nls_map)
-	{
+	if ((uopt.flags & (1 << UDF_FLAG_NLS_MAP)) && !uopt.nls_map) {
 		uopt.nls_map = load_nls_default();
 		if (!uopt.nls_map)
 			uopt.flags &= ~(1 << UDF_FLAG_NLS_MAP);
@@ -1564,8 +1457,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	UDF_SB_ANCHOR(sb)[2] = uopt.anchor;
 	UDF_SB_ANCHOR(sb)[3] = 256;
 
-	if (udf_check_valid(sb, uopt.novrs, silent)) /* read volume recognition sequences */
-	{
+	if (udf_check_valid(sb, uopt.novrs, silent)) { /* read volume recognition sequences */
 		printk("UDF-fs: No VRS found\n");
  		goto error_out;
 	}
@@ -1573,35 +1465,30 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	udf_find_anchor(sb);
 
 	/* Fill in the rest of the superblock */
-	sb->s_op = &udf_sb_ops;
+	sb->s_op = (struct super_operations *)&udf_sb_ops;
 	sb->dq_op = NULL;
 	sb->s_dirt = 0;
 	sb->s_magic = UDF_SUPER_MAGIC;
 	sb->s_time_gran = 1000;
 
-	if (udf_load_partition(sb, &fileset))
-	{
+	if (udf_load_partition(sb, &fileset)) {
 		printk("UDF-fs: No partition found (1)\n");
 		goto error_out;
 	}
 
 	udf_debug("Lastblock=%d\n", UDF_SB_LASTBLOCK(sb));
 
-	if ( UDF_SB_LVIDBH(sb) )
-	{
+	if (UDF_SB_LVIDBH(sb)) {
 		uint16_t minUDFReadRev = le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev);
 		uint16_t minUDFWriteRev = le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFWriteRev);
 		/* uint16_t maxUDFWriteRev = le16_to_cpu(UDF_SB_LVIDIU(sb)->maxUDFWriteRev); */
 
-		if (minUDFReadRev > UDF_MAX_READ_VERSION)
-		{
+		if (minUDFReadRev > UDF_MAX_READ_VERSION) {
 			printk("UDF-fs: minUDFReadRev=%x (max is %x)\n",
-				le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev),
-				UDF_MAX_READ_VERSION);
+			       le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev),
+			       UDF_MAX_READ_VERSION);
 			goto error_out;
-		}
-		else if (minUDFWriteRev > UDF_MAX_WRITE_VERSION)
-		{
+		} else if (minUDFWriteRev > UDF_MAX_WRITE_VERSION) {
 			sb->s_flags |= MS_RDONLY;
 		}
 
@@ -1613,8 +1500,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 			UDF_SET_FLAG(sb, UDF_FLAG_USE_STREAMS);
 	}
 
-	if ( !UDF_SB_NUMPARTS(sb) )
-	{
+	if (!UDF_SB_NUMPARTS(sb)) {
 		printk("UDF-fs: No partition found (2)\n");
 		goto error_out;
 	}
@@ -1624,20 +1510,19 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 		sb->s_flags |= MS_RDONLY;
 	}
 
-	if ( udf_find_fileset(sb, &fileset, &rootdir) )
-	{
+	if (udf_find_fileset(sb, &fileset, &rootdir)) {
 		printk("UDF-fs: No fileset found\n");
 		goto error_out;
 	}
 
-	if (!silent)
-	{
+	if (!silent) {
 		kernel_timestamp ts;
 		udf_time_to_stamp(&ts, UDF_SB_RECORDTIME(sb));
-		udf_info("UDF %s (%s) Mounting volume '%s', timestamp %04u/%02u/%02u %02u:%02u (%x)\n",
-			UDFFS_VERSION, UDFFS_DATE,
-			UDF_SB_VOLIDENT(sb), ts.year, ts.month, ts.day, ts.hour, ts.minute,
-			ts.typeAndTimezone);
+		udf_info("UDF %s (%s) Mounting volume '%s', "
+			 "timestamp %04u/%02u/%02u %02u:%02u (%x)\n",
+			 UDFFS_VERSION, UDFFS_DATE,
+			 UDF_SB_VOLIDENT(sb), ts.year, ts.month, ts.day, ts.hour, ts.minute,
+			 ts.typeAndTimezone);
 	}
 	if (!(sb->s_flags & MS_RDONLY))
 		udf_open_lvid(sb);
@@ -1645,18 +1530,16 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	/* Assign the root inode */
 	/* assign inodes by physical block number */
 	/* perhaps it's not extensible enough, but for now ... */
-	inode = udf_iget(sb, rootdir); 
-	if (!inode)
-	{
+	inode = udf_iget(sb, rootdir);
+	if (!inode) {
 		printk("UDF-fs: Error in udf_iget, block=%d, partition=%d\n",
-			rootdir.logicalBlockNum, rootdir.partitionReferenceNum);
+		       rootdir.logicalBlockNum, rootdir.partitionReferenceNum);
 		goto error_out;
 	}
 
 	/* Allocate a dentry for the root inode */
 	sb->s_root = d_alloc_root(inode);
-	if (!sb->s_root)
-	{
+	if (!sb->s_root) {
 		printk("UDF-fs: Couldn't allocate root dentry\n");
 		iput(inode);
 		goto error_out;
@@ -1667,8 +1550,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 error_out:
 	if (UDF_SB_VAT(sb))
 		iput(UDF_SB_VAT(sb));
-	if (UDF_SB_NUMPARTS(sb))
-	{
+	if (UDF_SB_NUMPARTS(sb)) {
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE)
 			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE)
@@ -1677,9 +1559,8 @@ error_out:
 			UDF_SB_FREE_BITMAP(sb,UDF_SB_PARTITION(sb),s_uspace);
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP)
 			UDF_SB_FREE_BITMAP(sb,UDF_SB_PARTITION(sb),s_fspace);
-		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) == UDF_SPARABLE_MAP15)
-		{
-			for (i=0; i<4; i++)
+		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) == UDF_SPARABLE_MAP15) {
+			for (i = 0; i < 4; i++)
 				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[i]);
 		}
 	}
@@ -1693,16 +1574,16 @@ error_out:
 	UDF_SB_FREE(sb);
 	kfree(sbi);
 	sb->s_fs_info = NULL;
+
 	return -EINVAL;
 }
 
 void udf_error(struct super_block *sb, const char *function,
-	const char *fmt, ...)
+	       const char *fmt, ...)
 {
 	va_list args;
 
-	if (!(sb->s_flags & MS_RDONLY))
-	{
+	if (!(sb->s_flags & MS_RDONLY)) {
 		/* mark sb error */
 		sb->s_dirt = 1;
 	}
@@ -1714,7 +1595,7 @@ void udf_error(struct super_block *sb, const char *function,
 }
 
 void udf_warning(struct super_block *sb, const char *function,
-	const char *fmt, ...)
+		 const char *fmt, ...)
 {
 	va_list args;
 
@@ -1722,7 +1603,7 @@ void udf_warning(struct super_block *sb, const char *function,
 	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
 	va_end(args);
 	printk(KERN_WARNING "UDF-fs warning (device %s): %s: %s\n",
-		sb->s_id, function, error_buf);
+	       sb->s_id, function, error_buf);
 }
 
 /*
@@ -1738,15 +1619,13 @@ void udf_warning(struct super_block *sb, const char *function,
  *	July 1, 1997 - Andrew E. Mileski
  *	Written, tested, and released.
  */
-static void
-udf_put_super(struct super_block *sb)
+static void udf_put_super(struct super_block *sb)
 {
 	int i;
 
 	if (UDF_SB_VAT(sb))
 		iput(UDF_SB_VAT(sb));
-	if (UDF_SB_NUMPARTS(sb))
-	{
+	if (UDF_SB_NUMPARTS(sb)) {
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE)
 			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE)
@@ -1755,9 +1634,8 @@ udf_put_super(struct super_block *sb)
 			UDF_SB_FREE_BITMAP(sb,UDF_SB_PARTITION(sb),s_uspace);
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP)
 			UDF_SB_FREE_BITMAP(sb,UDF_SB_PARTITION(sb),s_fspace);
-		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) == UDF_SPARABLE_MAP15)
-		{
-			for (i=0; i<4; i++)
+		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) == UDF_SPARABLE_MAP15) {
+			for (i = 0; i < 4; i++)
 				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[i]);
 		}
 	}
@@ -1786,8 +1664,7 @@ udf_put_super(struct super_block *sb)
  *	July 1, 1997 - Andrew E. Mileski
  *	Written, tested, and released.
  */
-static int
-udf_statfs(struct dentry *dentry, struct kstatfs *buf)
+static int udf_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
 
@@ -1797,8 +1674,8 @@ udf_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bfree = udf_count_free(sb);
 	buf->f_bavail = buf->f_bfree;
 	buf->f_files = (UDF_SB_LVIDBH(sb) ?
-		(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles) +
-		le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs)) : 0) + buf->f_bfree;
+			(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles) +
+			 le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs)) : 0) + buf->f_bfree;
 	buf->f_ffree = buf->f_bfree;
 	/* __kernel_fsid_t f_fsid */
 	buf->f_namelen = UDF_NAME_LEN-2;
@@ -1810,8 +1687,7 @@ static unsigned char udf_bitmap_lookup[16] = {
 	0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4
 };
 
-static unsigned int
-udf_count_free_bitmap(struct super_block *sb, struct udf_bitmap *bitmap)
+static unsigned int udf_count_free_bitmap(struct super_block *sb, struct udf_bitmap *bitmap)
 {
 	struct buffer_head *bh = NULL;
 	unsigned int accum = 0;
@@ -1830,13 +1706,10 @@ udf_count_free_bitmap(struct super_block *sb, struct udf_bitmap *bitmap)
 	loc.partitionReferenceNum = UDF_SB_PARTITION(sb);
 	bh = udf_read_ptagged(sb, loc, 0, &ident);
 
-	if (!bh)
-	{
+	if (!bh) {
 		printk(KERN_ERR "udf: udf_count_free failed\n");
 		goto out;
-	}
-	else if (ident != TAG_IDENT_SBD)
-	{
+	} else if (ident != TAG_IDENT_SBD) {
 		brelse(bh);
 		printk(KERN_ERR "udf: udf_count_free failed\n");
 		goto out;
@@ -1847,23 +1720,19 @@ udf_count_free_bitmap(struct super_block *sb, struct udf_bitmap *bitmap)
 	index = sizeof(struct spaceBitmapDesc); /* offset in first block only */
 	ptr = (uint8_t *)bh->b_data;
 
-	while ( bytes > 0 )
-	{
-		while ((bytes > 0) && (index < sb->s_blocksize))
-		{
+	while (bytes > 0) {
+		while (bytes > 0 && index < sb->s_blocksize) {
 			value = ptr[index];
-			accum += udf_bitmap_lookup[ value & 0x0f ];
-			accum += udf_bitmap_lookup[ value >> 4 ];
+			accum += udf_bitmap_lookup[value & 0x0f];
+			accum += udf_bitmap_lookup[value >> 4];
 			index++;
 			bytes--;
 		}
-		if ( bytes )
-		{
+		if (bytes) {
 			brelse(bh);
 			newblock = udf_get_lb_pblock(sb, loc, ++block);
 			bh = udf_tread(sb, newblock);
-			if (!bh)
-			{
+			if (!bh) {
 				udf_debug("read failed\n");
 				goto out;
 			}
@@ -1879,8 +1748,7 @@ out:
 	return accum;
 }
 
-static unsigned int
-udf_count_free_table(struct super_block *sb, struct inode * table)
+static unsigned int udf_count_free_table(struct super_block *sb, struct inode * table)
 {
 	unsigned int accum = 0;
 	uint32_t elen;
@@ -1894,26 +1762,23 @@ udf_count_free_table(struct super_block *sb, struct inode * table)
 	epos.offset = sizeof(struct unallocSpaceEntry);
 	epos.bh = NULL;
 
-	while ((etype = udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1)
+	while ((etype = udf_next_aext(table, &epos, &eloc, &elen, 1)) != -1) {
 		accum += (elen >> table->i_sb->s_blocksize_bits);
+	}
 	brelse(epos.bh);
 
 	unlock_kernel();
 
 	return accum;
 }
-	
-static unsigned int
-udf_count_free(struct super_block *sb)
+
+static unsigned int udf_count_free(struct super_block *sb)
 {
 	unsigned int accum = 0;
 
-	if (UDF_SB_LVIDBH(sb))
-	{
-		if (le32_to_cpu(UDF_SB_LVID(sb)->numOfPartitions) > UDF_SB_PARTITION(sb))
-		{
+	if (UDF_SB_LVIDBH(sb)) {
+		if (le32_to_cpu(UDF_SB_LVID(sb)->numOfPartitions) > UDF_SB_PARTITION(sb)) {
 			accum = le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)]);
-
 			if (accum == 0xFFFFFFFF)
 				accum = 0;
 		}
@@ -1922,28 +1787,24 @@ udf_count_free(struct super_block *sb)
 	if (accum)
 		return accum;
 
-	if (UDF_SB_PARTFLAGS(sb,UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP)
-	{
+	if (UDF_SB_PARTFLAGS(sb,UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		accum += udf_count_free_bitmap(sb,
-			UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_bitmap);
+					       UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_bitmap);
 	}
-	if (UDF_SB_PARTFLAGS(sb,UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP)
-	{
+	if (UDF_SB_PARTFLAGS(sb,UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP) {
 		accum += udf_count_free_bitmap(sb,
-			UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_bitmap);
+					       UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_bitmap);
 	}
 	if (accum)
 		return accum;
 
-	if (UDF_SB_PARTFLAGS(sb,UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE)
-	{
+	if (UDF_SB_PARTFLAGS(sb,UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE) {
 		accum += udf_count_free_table(sb,
-			UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
+					      UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
 	}
-	if (UDF_SB_PARTFLAGS(sb,UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE)
-	{
+	if (UDF_SB_PARTFLAGS(sb,UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE) {
 		accum += udf_count_free_table(sb,
-			UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
+					      UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
 	}
 
 	return accum;
diff --git a/fs/udf/symlink.c b/fs/udf/symlink.c
index 12613b6..501e54c 100644
--- a/fs/udf/symlink.c
+++ b/fs/udf/symlink.c
@@ -11,7 +11,7 @@
  *	Each contributing author retains all rights to their own work.
  *
  *  (C) 1998-2001 Ben Fennema
- *  (C) 1999 Stelias Computing Inc 
+ *  (C) 1999 Stelias Computing Inc
  *
  * HISTORY
  *
@@ -39,14 +39,11 @@ static void udf_pc_to_char(struct super_block *sb, char *from, int fromlen, char
 	int elen = 0;
 	char *p = to;
 
-	while (elen < fromlen)
-	{
+	while (elen < fromlen) {
 		pc = (struct pathComponent *)(from + elen);
-		switch (pc->componentType)
-		{
+		switch (pc->componentType) {
 			case 1:
-				if (pc->lengthComponentIdent == 0)
-				{
+				if (pc->lengthComponentIdent == 0) {
 					p = to;
 					*p++ = '/';
 				}
@@ -61,13 +58,14 @@ static void udf_pc_to_char(struct super_block *sb, char *from, int fromlen, char
 				/* that would be . - just ignore */
 				break;
 			case 5:
-				p += udf_get_filename(sb, pc->componentIdent, p, pc->lengthComponentIdent);
+				p += udf_get_filename(sb, pc->componentIdent, p,
+						      pc->lengthComponentIdent);
 				*p++ = '/';
 				break;
 		}
 		elen += sizeof(struct pathComponent) + pc->lengthComponentIdent;
 	}
-	if (p > to+1)
+	if (p > to + 1)
 		p[-1] = '\0';
 	else
 		p[0] = '\0';
@@ -82,10 +80,9 @@ static int udf_symlink_filler(struct file *file, struct page *page)
 	char *p = kmap(page);
 
 	lock_kernel();
-	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB)
+	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB) {
 		symlink = UDF_I_DATA(inode) + UDF_I_LENEATTR(inode);
-	else
-	{
+	} else {
 		bh = sb_bread(inode->i_sb, udf_block_map(inode, 0));
 
 		if (!bh)
@@ -102,6 +99,7 @@ static int udf_symlink_filler(struct file *file, struct page *page)
 	kunmap(page);
 	unlock_page(page);
 	return 0;
+
 out:
 	unlock_kernel();
 	SetPageError(page);
diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index 77975ae..ee79ad0 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -29,41 +29,38 @@
 #include "udf_sb.h"
 
 static void extent_trunc(struct inode * inode, struct extent_position *epos,
-	kernel_lb_addr eloc, int8_t etype, uint32_t elen, uint32_t nelen)
+			 kernel_lb_addr eloc, int8_t etype, uint32_t elen, uint32_t nelen)
 {
-	kernel_lb_addr neloc = { 0, 0 };
+	kernel_lb_addr neloc = {};
 	int last_block = (elen + inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits;
 	int first_block = (nelen + inode->i_sb->s_blocksize - 1) >> inode->i_sb->s_blocksize_bits;
 
-	if (nelen)
-	{
-		if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30))
-		{
+	if (nelen) {
+		if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
 			udf_free_blocks(inode->i_sb, inode, eloc, 0, last_block);
 			etype = (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30);
-		}
-		else
+		} else {
 			neloc = eloc;
+		}
 		nelen = (etype << 30) | nelen;
 	}
 
-	if (elen != nelen)
-	{
+	if (elen != nelen) {
 		udf_write_aext(inode, epos, neloc, nelen, 0);
-		if (last_block - first_block > 0)
-		{
+		if (last_block - first_block > 0) {
 			if (etype == (EXT_RECORDED_ALLOCATED >> 30))
 				mark_inode_dirty(inode);
 
 			if (etype != (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))
-				udf_free_blocks(inode->i_sb, inode, eloc, first_block, last_block - first_block);
+				udf_free_blocks(inode->i_sb, inode, eloc, first_block,
+						last_block - first_block);
 		}
 	}
 }
 
 void udf_discard_prealloc(struct inode * inode)
 {
-	struct extent_position epos = { NULL, 0, {0, 0}};
+	struct extent_position epos = {};
 	kernel_lb_addr eloc;
 	uint32_t elen, nelen;
 	uint64_t lbcount = 0;
@@ -71,7 +68,7 @@ void udf_discard_prealloc(struct inode * inode)
 	int adsize;
 
 	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB ||
-		inode->i_size == UDF_I_LENEXTENTS(inode))
+	    inode->i_size == UDF_I_LENEXTENTS(inode))
 		return;
 
 	if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_SHORT)
@@ -84,12 +81,10 @@ void udf_discard_prealloc(struct inode * inode)
 	epos.block = UDF_I_LOCATION(inode);
 
 	/* Find the last extent in the file */
-	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 1)) != -1)
-	{
+	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 1)) != -1) {
 		etype = netype;
 		lbcount += elen;
-		if (lbcount > inode->i_size && lbcount - elen < inode->i_size)
-		{
+		if (lbcount > inode->i_size && lbcount - elen < inode->i_size) {
 			WARN_ON(lbcount - inode->i_size >= inode->i_sb->s_blocksize);
 			nelen = elen - (lbcount - inode->i_size);
 			epos.offset -= adsize;
@@ -102,16 +97,15 @@ void udf_discard_prealloc(struct inode * inode)
 		epos.offset -= adsize;
 		lbcount -= elen;
 		extent_trunc(inode, &epos, eloc, etype, elen, 0);
-		if (!epos.bh)
-		{
+		if (!epos.bh) {
 			UDF_I_LENALLOC(inode) = epos.offset - udf_file_entry_alloc_offset(inode);
 			mark_inode_dirty(inode);
-		}
-		else
-		{
+		} else {
 			struct allocExtDesc *aed = (struct allocExtDesc *)(epos.bh->b_data);
-			aed->lengthAllocDescs = cpu_to_le32(epos.offset - sizeof(struct allocExtDesc));
-			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) || UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
+			aed->lengthAllocDescs = cpu_to_le32(epos.offset -
+							    sizeof(struct allocExtDesc));
+			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
+			    UDF_SB_UDFREV(inode->i_sb) >= 0x0201)
 				udf_update_tag(epos.bh->b_data, epos.offset);
 			else
 				udf_update_tag(epos.bh->b_data, sizeof(struct allocExtDesc));
@@ -127,7 +121,7 @@ void udf_discard_prealloc(struct inode * inode)
 void udf_truncate_extents(struct inode * inode)
 {
 	struct extent_position epos;
-	kernel_lb_addr eloc, neloc = { 0, 0 };
+	kernel_lb_addr eloc, neloc = {};
 	uint32_t elen, nelen = 0, indirect_ext_len = 0, lenalloc;
 	int8_t etype;
 	struct super_block *sb = inode->i_sb;
@@ -144,8 +138,7 @@ void udf_truncate_extents(struct inode * inode)
 
 	etype = inode_bmap(inode, first_block, &epos, &eloc, &elen, &offset);
 	byte_offset = (offset << sb->s_blocksize_bits) + (inode->i_size & (sb->s_blocksize-1));
-	if (etype != -1)
-	{
+	if (etype != -1) {
 		epos.offset -= adsize;
 		extent_trunc(inode, &epos, eloc, etype, elen, byte_offset);
 		epos.offset += adsize;
@@ -159,35 +152,30 @@ void udf_truncate_extents(struct inode * inode)
 		else
 			lenalloc -= sizeof(struct allocExtDesc);
 
-		while ((etype = udf_current_aext(inode, &epos, &eloc, &elen, 0)) != -1)
-		{
-			if (etype == (EXT_NEXT_EXTENT_ALLOCDECS >> 30))
-			{
+		while ((etype = udf_current_aext(inode, &epos, &eloc, &elen, 0)) != -1) {
+			if (etype == (EXT_NEXT_EXTENT_ALLOCDECS >> 30)) {
 				udf_write_aext(inode, &epos, neloc, nelen, 0);
-				if (indirect_ext_len)
-				{
+				if (indirect_ext_len) {
 					/* We managed to free all extents in the
 					 * indirect extent - free it too */
 					if (!epos.bh)
 						BUG();
 					udf_free_blocks(sb, inode, epos.block, 0, indirect_ext_len);
-				}
-				else
-				{
-					if (!epos.bh)
-					{
+				} else {
+					if (!epos.bh) {
 						UDF_I_LENALLOC(inode) = lenalloc;
 						mark_inode_dirty(inode);
-					}
-					else
-					{
-						struct allocExtDesc *aed = (struct allocExtDesc *)(epos.bh->b_data);
+					} else {
+						struct allocExtDesc *aed =
+							(struct allocExtDesc *)(epos.bh->b_data);
 						aed->lengthAllocDescs = cpu_to_le32(lenalloc);
-						if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) || UDF_SB_UDFREV(sb) >= 0x0201)
+						if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) ||
+						    UDF_SB_UDFREV(sb) >= 0x0201)
 							udf_update_tag(epos.bh->b_data, lenalloc +
-								sizeof(struct allocExtDesc));
+								       sizeof(struct allocExtDesc));
 						else
-							udf_update_tag(epos.bh->b_data, sizeof(struct allocExtDesc));
+							udf_update_tag(epos.bh->b_data,
+								       sizeof(struct allocExtDesc));
 						mark_buffer_dirty_inode(epos.bh, inode);
 					}
 				}
@@ -196,49 +184,38 @@ void udf_truncate_extents(struct inode * inode)
 				epos.block = eloc;
 				epos.bh = udf_tread(sb, udf_get_lb_pblock(sb, eloc, 0));
 				if (elen)
-					indirect_ext_len = (elen +
-						sb->s_blocksize - 1) >>
+					indirect_ext_len = (elen + sb->s_blocksize - 1) >>
 						sb->s_blocksize_bits;
 				else
 					indirect_ext_len = 1;
-			}
-			else
-			{
+			} else {
 				extent_trunc(inode, &epos, eloc, etype, elen, 0);
 				epos.offset += adsize;
 			}
 		}
 
-		if (indirect_ext_len)
-		{
+		if (indirect_ext_len) {
 			if (!epos.bh)
 				BUG();
 			udf_free_blocks(sb, inode, epos.block, 0, indirect_ext_len);
-		}
-		else
-		{
-			if (!epos.bh)
-			{
+		} else {
+			if (!epos.bh) {
 				UDF_I_LENALLOC(inode) = lenalloc;
 				mark_inode_dirty(inode);
-			}
-			else
-			{
+			} else {
 				struct allocExtDesc *aed = (struct allocExtDesc *)(epos.bh->b_data);
 				aed->lengthAllocDescs = cpu_to_le32(lenalloc);
-				if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) || UDF_SB_UDFREV(sb) >= 0x0201)
+				if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) ||
+				    UDF_SB_UDFREV(sb) >= 0x0201)
 					udf_update_tag(epos.bh->b_data, lenalloc +
-						sizeof(struct allocExtDesc));
+						       sizeof(struct allocExtDesc));
 				else
 					udf_update_tag(epos.bh->b_data, sizeof(struct allocExtDesc));
 				mark_buffer_dirty_inode(epos.bh, inode);
 			}
 		}
-	}
-	else if (inode->i_size)
-	{
-		if (byte_offset)
-		{
+	} else if (inode->i_size) {
+		if (byte_offset) {
 			kernel_long_ad extent;
 
 			/*
@@ -253,14 +230,14 @@ void udf_truncate_extents(struct inode * inode)
 				extent.extLocation.logicalBlockNum = 0;
 				extent.extLocation.partitionReferenceNum = 0;
 				extent.extLength = EXT_NOT_RECORDED_NOT_ALLOCATED;
-			}
-			else {
+			} else {
 				epos.offset -= adsize;
 				etype = udf_next_aext(inode, &epos,
-					&extent.extLocation, &extent.extLength, 0);
+						      &extent.extLocation, &extent.extLength, 0);
 				extent.extLength |= etype << 30;
 			}
-			udf_extend_file(inode, &epos, &extent, offset+((inode->i_size & (sb->s_blocksize-1)) != 0));
+			udf_extend_file(inode, &epos, &extent,
+					offset + ((inode->i_size & (sb->s_blocksize-1)) != 0));
 		}
 	}
 	UDF_I_LENEXTENTS(inode) = inode->i_size;
diff --git a/fs/udf/udf_i.h b/fs/udf/udf_i.h
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 3b2e6c8..3e937d3 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -41,8 +41,7 @@ static inline struct udf_sb_info *UDF_SB(struct super_block *sb)
 
 #define UDF_SB_FREE(X)\
 {\
-	if (UDF_SB(X))\
-	{\
+	if (UDF_SB(X)) {\
 		kfree(UDF_SB_PARTMAPS(X));\
 		UDF_SB_PARTMAPS(X) = NULL;\
 	}\
@@ -51,13 +50,10 @@ static inline struct udf_sb_info *UDF_SB(struct super_block *sb)
 #define UDF_SB_ALLOC_PARTMAPS(X,Y)\
 {\
 	UDF_SB_PARTMAPS(X) = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
-	if (UDF_SB_PARTMAPS(X) != NULL)\
-	{\
+	if (UDF_SB_PARTMAPS(X) != NULL) {\
 		UDF_SB_NUMPARTS(X) = Y;\
 		memset(UDF_SB_PARTMAPS(X), 0x00, sizeof(struct udf_part_map) * Y);\
-	}\
-	else\
-	{\
+	} else {\
 		UDF_SB_NUMPARTS(X) = 0;\
 		udf_error(X, __FUNCTION__, "Unable to allocate space for %d partition maps", Y);\
 	}\
@@ -72,15 +68,12 @@ static inline struct udf_sb_info *UDF_SB(struct super_block *sb)
 		UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap = kmalloc(size, GFP_KERNEL);\
 	else\
 		UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap = vmalloc(size);\
-	if (UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap != NULL)\
-	{\
+	if (UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap != NULL) {\
 		memset(UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap, 0x00, size);\
 		UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap->s_block_bitmap =\
 			(struct buffer_head **)(UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap + 1);\
 		UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap->s_nr_groups = nr_groups;\
-	}\
-	else\
-	{\
+	} else {\
 		udf_error(X, __FUNCTION__, "Unable to allocate space for bitmap and %d buffer_head pointers", nr_groups);\
 	}\
 }
@@ -90,8 +83,7 @@ static inline struct udf_sb_info *UDF_SB(struct super_block *sb)
 	int i;\
 	int nr_groups = UDF_SB_BITMAP_NR_GROUPS(X,Y,Z);\
 	int size = sizeof(struct udf_bitmap) + (sizeof(struct buffer_head *) * nr_groups);\
-	for (i=0; i<nr_groups; i++)\
-	{\
+	for (i = 0; i < nr_groups; i++) {\
 		if (UDF_SB_BITMAP(X,Y,Z,i))\
 			brelse(UDF_SB_BITMAP(X,Y,Z,i));\
 	}\
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index 67ded28..a6f787f 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -50,28 +50,24 @@ extern const struct address_space_operations udf_aops;
 extern const struct address_space_operations udf_adinicb_aops;
 extern const struct address_space_operations udf_symlink_aops;
 
-struct udf_fileident_bh
-{
+struct udf_fileident_bh {
 	struct buffer_head *sbh;
 	struct buffer_head *ebh;
 	int soffset;
 	int eoffset;
 };
 
-struct udf_vds_record
-{
+struct udf_vds_record {
 	uint32_t block;
 	uint32_t volDescSeqNum;
 };
 
-struct generic_desc
-{
+struct generic_desc {
 	tag		descTag;
 	__le32		volDescSeqNum;
 };
 
-struct ustr
-{
+struct ustr {
 	uint8_t u_cmpID;
 	uint8_t u_name[UDF_NAME_LEN-2];
 	uint8_t u_len;
diff --git a/fs/udf/udfend.h b/fs/udf/udfend.h
index 17d3788..c4bd120 100644
--- a/fs/udf/udfend.h
+++ b/fs/udf/udfend.h
@@ -7,74 +7,92 @@
 static inline kernel_lb_addr lelb_to_cpu(lb_addr in)
 {
 	kernel_lb_addr out;
+
 	out.logicalBlockNum = le32_to_cpu(in.logicalBlockNum);
 	out.partitionReferenceNum = le16_to_cpu(in.partitionReferenceNum);
+
 	return out;
 }
 
 static inline lb_addr cpu_to_lelb(kernel_lb_addr in)
 {
 	lb_addr out;
+
 	out.logicalBlockNum = cpu_to_le32(in.logicalBlockNum);
 	out.partitionReferenceNum = cpu_to_le16(in.partitionReferenceNum);
+
 	return out;
 }
 
 static inline kernel_timestamp lets_to_cpu(timestamp in)
 {
 	kernel_timestamp out;
+
 	memcpy(&out, &in, sizeof(timestamp));
 	out.typeAndTimezone = le16_to_cpu(in.typeAndTimezone);
 	out.year = le16_to_cpu(in.year);
+
 	return out;
 }
 
 static inline short_ad lesa_to_cpu(short_ad in)
 {
 	short_ad out;
+
 	out.extLength = le32_to_cpu(in.extLength);
 	out.extPosition = le32_to_cpu(in.extPosition);
+
 	return out;
 }
 
 static inline short_ad cpu_to_lesa(short_ad in)
 {
 	short_ad out;
+
 	out.extLength = cpu_to_le32(in.extLength);
 	out.extPosition = cpu_to_le32(in.extPosition);
+
 	return out;
 }
 
 static inline kernel_long_ad lela_to_cpu(long_ad in)
 {
 	kernel_long_ad out;
+
 	out.extLength = le32_to_cpu(in.extLength);
 	out.extLocation = lelb_to_cpu(in.extLocation);
+
 	return out;
 }
 
 static inline long_ad cpu_to_lela(kernel_long_ad in)
 {
 	long_ad out;
+
 	out.extLength = cpu_to_le32(in.extLength);
 	out.extLocation = cpu_to_lelb(in.extLocation);
+
 	return out;
 }
 
 static inline kernel_extent_ad leea_to_cpu(extent_ad in)
 {
 	kernel_extent_ad out;
+
 	out.extLength = le32_to_cpu(in.extLength);
 	out.extLocation = le32_to_cpu(in.extLocation);
+
 	return out;
 }
 
 static inline timestamp cpu_to_lets(kernel_timestamp in)
 {
 	timestamp out;
+
 	memcpy(&out, &in, sizeof(timestamp));
 	out.typeAndTimezone = cpu_to_le16(in.typeAndTimezone);
 	out.year = cpu_to_le16(in.year);
+
 	return out;
 }
 
diff --git a/fs/udf/udftime.c b/fs/udf/udftime.c
index 85d8dbe..6b0e5fc 100644
--- a/fs/udf/udftime.c
+++ b/fs/udf/udftime.c
@@ -18,18 +18,18 @@
    Boston, MA 02111-1307, USA.  */
 
 /*
- * dgb 10/02/98: ripped this from glibc source to help convert timestamps to unix time 
+ * dgb 10/02/98: ripped this from glibc source to help convert timestamps to unix time
  *     10/04/98: added new table-based lookup after seeing how ugly the gnu code is
  * blf 09/27/99: ripped out all the old code and inserted new table from
- *					John Brockmeyer (without leap second corrections)
- *				 rewrote udf_stamp_to_time and fixed timezone accounting in
-					udf_time_to_stamp.
+ *		 John Brockmeyer (without leap second corrections)
+ *		 rewrote udf_stamp_to_time and fixed timezone accounting in
+ *		 udf_time_to_stamp.
  */
 
 /*
  * We don't take into account leap seconds. This may be correct or incorrect.
  * For more NIST information (especially dealing with leap seconds), see:
- *  http://www.boulder.nist.gov/timefreq/pubs/bulletin/leapsecond.htm
+ * http://www.boulder.nist.gov/timefreq/pubs/bulletin/leapsecond.htm
  */
 
 #include <linux/types.h>
@@ -59,23 +59,23 @@ static const unsigned short int __mon_yday[2][13] =
 #define SPY(y,l,s) (SPD * (365*y+l)+s)
 
 static time_t year_seconds[MAX_YEAR_SECONDS]= {
-/*1970*/ SPY( 0, 0,0), SPY( 1, 0,0), SPY( 2, 0,0), SPY( 3, 1,0), 
-/*1974*/ SPY( 4, 1,0), SPY( 5, 1,0), SPY( 6, 1,0), SPY( 7, 2,0), 
-/*1978*/ SPY( 8, 2,0), SPY( 9, 2,0), SPY(10, 2,0), SPY(11, 3,0), 
-/*1982*/ SPY(12, 3,0), SPY(13, 3,0), SPY(14, 3,0), SPY(15, 4,0), 
-/*1986*/ SPY(16, 4,0), SPY(17, 4,0), SPY(18, 4,0), SPY(19, 5,0), 
-/*1990*/ SPY(20, 5,0), SPY(21, 5,0), SPY(22, 5,0), SPY(23, 6,0), 
-/*1994*/ SPY(24, 6,0), SPY(25, 6,0), SPY(26, 6,0), SPY(27, 7,0), 
-/*1998*/ SPY(28, 7,0), SPY(29, 7,0), SPY(30, 7,0), SPY(31, 8,0), 
-/*2002*/ SPY(32, 8,0), SPY(33, 8,0), SPY(34, 8,0), SPY(35, 9,0), 
-/*2006*/ SPY(36, 9,0), SPY(37, 9,0), SPY(38, 9,0), SPY(39,10,0), 
-/*2010*/ SPY(40,10,0), SPY(41,10,0), SPY(42,10,0), SPY(43,11,0), 
-/*2014*/ SPY(44,11,0), SPY(45,11,0), SPY(46,11,0), SPY(47,12,0), 
-/*2018*/ SPY(48,12,0), SPY(49,12,0), SPY(50,12,0), SPY(51,13,0), 
-/*2022*/ SPY(52,13,0), SPY(53,13,0), SPY(54,13,0), SPY(55,14,0), 
-/*2026*/ SPY(56,14,0), SPY(57,14,0), SPY(58,14,0), SPY(59,15,0), 
-/*2030*/ SPY(60,15,0), SPY(61,15,0), SPY(62,15,0), SPY(63,16,0), 
-/*2034*/ SPY(64,16,0), SPY(65,16,0), SPY(66,16,0), SPY(67,17,0), 
+/*1970*/ SPY( 0, 0,0), SPY( 1, 0,0), SPY( 2, 0,0), SPY( 3, 1,0),
+/*1974*/ SPY( 4, 1,0), SPY( 5, 1,0), SPY( 6, 1,0), SPY( 7, 2,0),
+/*1978*/ SPY( 8, 2,0), SPY( 9, 2,0), SPY(10, 2,0), SPY(11, 3,0),
+/*1982*/ SPY(12, 3,0), SPY(13, 3,0), SPY(14, 3,0), SPY(15, 4,0),
+/*1986*/ SPY(16, 4,0), SPY(17, 4,0), SPY(18, 4,0), SPY(19, 5,0),
+/*1990*/ SPY(20, 5,0), SPY(21, 5,0), SPY(22, 5,0), SPY(23, 6,0),
+/*1994*/ SPY(24, 6,0), SPY(25, 6,0), SPY(26, 6,0), SPY(27, 7,0),
+/*1998*/ SPY(28, 7,0), SPY(29, 7,0), SPY(30, 7,0), SPY(31, 8,0),
+/*2002*/ SPY(32, 8,0), SPY(33, 8,0), SPY(34, 8,0), SPY(35, 9,0),
+/*2006*/ SPY(36, 9,0), SPY(37, 9,0), SPY(38, 9,0), SPY(39,10,0),
+/*2010*/ SPY(40,10,0), SPY(41,10,0), SPY(42,10,0), SPY(43,11,0),
+/*2014*/ SPY(44,11,0), SPY(45,11,0), SPY(46,11,0), SPY(47,12,0),
+/*2018*/ SPY(48,12,0), SPY(49,12,0), SPY(50,12,0), SPY(51,13,0),
+/*2022*/ SPY(52,13,0), SPY(53,13,0), SPY(54,13,0), SPY(55,14,0),
+/*2026*/ SPY(56,14,0), SPY(57,14,0), SPY(58,14,0), SPY(59,15,0),
+/*2030*/ SPY(60,15,0), SPY(61,15,0), SPY(62,15,0), SPY(63,16,0),
+/*2034*/ SPY(64,16,0), SPY(65,16,0), SPY(66,16,0), SPY(67,17,0),
 /*2038*/ SPY(68,17,0)
 };
 
@@ -84,27 +84,24 @@ extern struct timezone sys_tz;
 #define SECS_PER_HOUR	(60 * 60)
 #define SECS_PER_DAY	(SECS_PER_HOUR * 24)
 
-time_t *
-udf_stamp_to_time(time_t *dest, long *dest_usec, kernel_timestamp src)
+time_t * udf_stamp_to_time(time_t *dest, long *dest_usec, kernel_timestamp src)
 {
 	int yday;
 	uint8_t type = src.typeAndTimezone >> 12;
 	int16_t offset;
 
-	if (type == 1)
-	{
+	if (type == 1) {
 		offset = src.typeAndTimezone << 4;
 		/* sign extent offset */
 		offset = (offset >> 4);
 		if (offset == -2047) /* unspecified offset */
 			offset = 0;
-	}
-	else
+	} else {
 		offset = 0;
+	}
 
 	if ((src.year < EPOCH_YEAR) ||
-		(src.year >= EPOCH_YEAR+MAX_YEAR_SECONDS))
-	{
+	    (src.year >= EPOCH_YEAR+MAX_YEAR_SECONDS)) {
 		*dest = -1;
 		*dest_usec = -1;
 		return NULL;
@@ -113,15 +110,14 @@ udf_stamp_to_time(time_t *dest, long *dest_usec, kernel_timestamp src)
 	*dest -= offset * 60;
 
 	yday = ((__mon_yday[__isleap (src.year)]
-		[src.month-1]) + (src.day-1));
-	*dest += ( ( (yday* 24) + src.hour ) * 60 + src.minute ) * 60 + src.second;
+		 [src.month - 1]) + (src.day - 1));
+	*dest += ( ( (yday * 24) + src.hour ) * 60 + src.minute ) * 60 + src.second;
 	*dest_usec = src.centiseconds * 10000 + src.hundredsOfMicroseconds * 100 + src.microseconds;
 	return dest;
 }
 
 
-kernel_timestamp *
-udf_time_to_stamp(kernel_timestamp *dest, struct timespec ts)
+kernel_timestamp * udf_time_to_stamp(kernel_timestamp *dest, struct timespec ts)
 {
 	long int days, rem, y;
 	const unsigned short int *ip;
@@ -146,14 +142,13 @@ udf_time_to_stamp(kernel_timestamp *dest, struct timespec ts)
 #define DIV(a,b) ((a) / (b) - ((a) % (b) < 0))
 #define LEAPS_THRU_END_OF(y) (DIV (y, 4) - DIV (y, 100) + DIV (y, 400))
 
-	while (days < 0 || days >= (__isleap(y) ? 366 : 365))
-	{
+	while (days < 0 || days >= (__isleap(y) ? 366 : 365)) {
 		long int yg = y + days / 365 - (days % 365 < 0);
 
 		/* Adjust DAYS and Y to match the guessed year.  */
 		days -= ((yg - y) * 365
-			+ LEAPS_THRU_END_OF (yg - 1)
-			- LEAPS_THRU_END_OF (y - 1));
+			 + LEAPS_THRU_END_OF (yg - 1)
+			 - LEAPS_THRU_END_OF (y - 1));
 		y = yg;
 	}
 	dest->year = y;
@@ -167,7 +162,7 @@ udf_time_to_stamp(kernel_timestamp *dest, struct timespec ts)
 	dest->centiseconds = ts.tv_nsec / 10000000;
 	dest->hundredsOfMicroseconds = (ts.tv_nsec / 1000 - dest->centiseconds * 10000) / 100;
 	dest->microseconds = (ts.tv_nsec / 1000 - dest->centiseconds * 10000 -
-		dest->hundredsOfMicroseconds * 100);
+			      dest->hundredsOfMicroseconds * 100);
 	return dest;
 }
 
diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
index 706c92e..42c10dc 100644
--- a/fs/udf/unicode.c
+++ b/fs/udf/unicode.c
@@ -31,12 +31,14 @@ static int udf_translate_to_linux(uint8_t *, uint8_t *, int, uint8_t *, int);
 
 static int udf_char_to_ustr(struct ustr *dest, const uint8_t *src, int strlen)
 {
-	if ( (!dest) || (!src) || (!strlen) || (strlen > UDF_NAME_LEN-2) )
+	if (!dest || !src || !strlen || strlen > UDF_NAME_LEN - 2)
 		return 0;
+
 	memset(dest, 0, sizeof(struct ustr));
 	memcpy(dest->u_name, src, strlen);
 	dest->u_cmpID = 0x08;
 	dest->u_len = strlen;
+
 	return strlen;
 }
 
@@ -47,14 +49,15 @@ int udf_build_ustr(struct ustr *dest, dstring *ptr, int size)
 {
 	int usesize;
 
-	if ( (!dest) || (!ptr) || (!size) )
+	if (!dest || !ptr || !size)
 		return -1;
 
 	memset(dest, 0, sizeof(struct ustr));
-	usesize= (size > UDF_NAME_LEN) ? UDF_NAME_LEN : size;
-	dest->u_cmpID=ptr[0];
-	dest->u_len=ptr[size-1];
-	memcpy(dest->u_name, ptr+1, usesize-1);
+	usesize = (size > UDF_NAME_LEN) ? UDF_NAME_LEN : size;
+	dest->u_cmpID = ptr[0];
+	dest->u_len = ptr[size - 1];
+	memcpy(dest->u_name, ptr + 1, usesize - 1);
+
 	return 0;
 }
 
@@ -63,13 +66,14 @@ int udf_build_ustr(struct ustr *dest, dstring *ptr, int size)
  */
 static int udf_build_ustr_exact(struct ustr *dest, dstring *ptr, int exactsize)
 {
-	if ( (!dest) || (!ptr) || (!exactsize) )
+	if (!dest || !ptr || !exactsize)
 		return -1;
 
 	memset(dest, 0, sizeof(struct ustr));
-	dest->u_cmpID=ptr[0];
-	dest->u_len=exactsize-1;
-	memcpy(dest->u_name, ptr+1, exactsize-1);
+	dest->u_cmpID = ptr[0];
+	dest->u_len = exactsize - 1;
+	memcpy(dest->u_name, ptr + 1, exactsize - 1);
+
 	return 0;
 }
 
@@ -108,22 +112,20 @@ int udf_CS0toUTF8(struct ustr *utf_o, struct ustr *ocu_i)
 	cmp_id = ocu_i->u_cmpID;
 	utf_o->u_len = 0;
 
-	if (ocu_len == 0)
-	{
+	if (ocu_len == 0) {
 		memset(utf_o, 0, sizeof(struct ustr));
 		utf_o->u_cmpID = 0;
 		utf_o->u_len = 0;
 		return 0;
 	}
 
-	if ((cmp_id != 8) && (cmp_id != 16))
-	{
-		printk(KERN_ERR "udf: unknown compression code (%d) stri=%s\n", cmp_id, ocu_i->u_name);
+	if (cmp_id != 8 && cmp_id != 16) {
+		printk(KERN_ERR "udf: unknown compression code (%d) stri=%s\n",
+		       cmp_id, ocu_i->u_name);
 		return 0;
 	}
 
-	for (i = 0; (i < ocu_len) && (utf_o->u_len <= (UDF_NAME_LEN-3)) ;)
-	{
+	for (i = 0; i < ocu_len && utf_o->u_len <= UDF_NAME_LEN - 3 ;) {
 
 		/* Expand OSTA compressed Unicode to Unicode */
 		c = ocu[i++];
@@ -131,21 +133,18 @@ int udf_CS0toUTF8(struct ustr *utf_o, struct ustr *ocu_i)
 			c = (c << 8) | ocu[i++];
 
 		/* Compress Unicode to UTF-8 */
-		if (c < 0x80U)
+		if (c < 0x80U) {
 			utf_o->u_name[utf_o->u_len++] = (uint8_t)c;
-		else if (c < 0x800U)
-		{
+		} else if (c < 0x800U) {
 			utf_o->u_name[utf_o->u_len++] = (uint8_t)(0xc0 | (c >> 6));
 			utf_o->u_name[utf_o->u_len++] = (uint8_t)(0x80 | (c & 0x3f));
-		}
-		else
-		{
+		} else {
 			utf_o->u_name[utf_o->u_len++] = (uint8_t)(0xe0 | (c >> 12));
 			utf_o->u_name[utf_o->u_len++] = (uint8_t)(0x80 | ((c >> 6) & 0x3f));
 			utf_o->u_name[utf_o->u_len++] = (uint8_t)(0x80 | (c & 0x3f));
 		}
 	}
-	utf_o->u_cmpID=8;
+	utf_o->u_cmpID = 8;
 
 	return utf_o->u_len;
 }
@@ -186,61 +185,46 @@ try_again:
 	u_len = 0U;
 	utf_char = 0U;
 	utf_cnt = 0U;
-	for (i = 0U; i < utf->u_len; i++)
-	{
+	for (i = 0U; i < utf->u_len; i++) {
 		c = (uint8_t)utf->u_name[i];
 
 		/* Complete a multi-byte UTF-8 character */
-		if (utf_cnt)
-		{
+		if (utf_cnt) {
 			utf_char = (utf_char << 6) | (c & 0x3fU);
 			if (--utf_cnt)
 				continue;
-		}
-		else
-		{
+		} else {
 			/* Check for a multi-byte UTF-8 character */
-			if (c & 0x80U)
-			{
+			if (c & 0x80U) {
 				/* Start a multi-byte UTF-8 character */
-				if ((c & 0xe0U) == 0xc0U)
-				{
+				if ((c & 0xe0U) == 0xc0U) {
 					utf_char = c & 0x1fU;
 					utf_cnt = 1;
-				}
-				else if ((c & 0xf0U) == 0xe0U)
-				{
+				} else if ((c & 0xf0U) == 0xe0U) {
 					utf_char = c & 0x0fU;
 					utf_cnt = 2;
-				}
-				else if ((c & 0xf8U) == 0xf0U)
-				{
+				} else if ((c & 0xf8U) == 0xf0U) {
 					utf_char = c & 0x07U;
 					utf_cnt = 3;
-				}
-				else if ((c & 0xfcU) == 0xf8U)
-				{
+				} else if ((c & 0xfcU) == 0xf8U) {
 					utf_char = c & 0x03U;
 					utf_cnt = 4;
-				}
-				else if ((c & 0xfeU) == 0xfcU)
-				{
+				} else if ((c & 0xfeU) == 0xfcU) {
 					utf_char = c & 0x01U;
 					utf_cnt = 5;
-				}
-				else
+				} else {
 					goto error_out;
+				}
 				continue;
-			} else
+			} else {
 				/* Single byte UTF-8 character (most common) */
 				utf_char = c;
+			}
 		}
 
 		/* Choose no compression if necessary */
-		if (utf_char > max_val)
-		{
-			if ( 0xffU == max_val )
-			{
+		if (utf_char > max_val) {
+			if (max_val == 0xffU) {
 				max_val = 0xffffU;
 				ocu[0] = (uint8_t)0x10U;
 				goto try_again;
@@ -248,22 +232,21 @@ try_again:
 			goto error_out;
 		}
 
-		if (max_val == 0xffffU)
-		{
+		if (max_val == 0xffffU) {
 			ocu[++u_len] = (uint8_t)(utf_char >> 8);
 		}
 		ocu[++u_len] = (uint8_t)(utf_char & 0xffU);
 	}
 
 
-	if (utf_cnt)
-	{
+	if (utf_cnt) {
 error_out:
 		ocu[++u_len] = '?';
 		printk(KERN_DEBUG "udf: bad UTF-8 character\n");
 	}
 
 	ocu[length - 1] = (uint8_t)u_len + 1;
+
 	return u_len + 1;
 }
 
@@ -280,29 +263,27 @@ static int udf_CS0toNLS(struct nls_table *nls, struct ustr *utf_o, struct ustr *
 	cmp_id = ocu_i->u_cmpID;
 	utf_o->u_len = 0;
 
-	if (ocu_len == 0)
-	{
+	if (ocu_len == 0) {
 		memset(utf_o, 0, sizeof(struct ustr));
 		utf_o->u_cmpID = 0;
 		utf_o->u_len = 0;
 		return 0;
 	}
 
-	if ((cmp_id != 8) && (cmp_id != 16))
-	{
-		printk(KERN_ERR "udf: unknown compression code (%d) stri=%s\n", cmp_id, ocu_i->u_name);
+	if (cmp_id != 8 && cmp_id != 16) {
+		printk(KERN_ERR "udf: unknown compression code (%d) stri=%s\n",
+		       cmp_id, ocu_i->u_name);
 		return 0;
 	}
 
-	for (i = 0; (i < ocu_len) && (utf_o->u_len <= (UDF_NAME_LEN-3)) ;)
-	{
+	for (i = 0; i < ocu_len && utf_o->u_len <= UDF_NAME_LEN - 3;) {
 		/* Expand OSTA compressed Unicode to Unicode */
 		c = ocu[i++];
 		if (cmp_id == 16)
 			c = (c << 8) | ocu[i++];
 
-		utf_o->u_len += nls->uni2char(c, &utf_o->u_name[utf_o->u_len], 
-			UDF_NAME_LEN - utf_o->u_len);
+		utf_o->u_len += nls->uni2char(c, &utf_o->u_name[utf_o->u_len],
+					      UDF_NAME_LEN - utf_o->u_len);
 	}
 	utf_o->u_cmpID=8;
 
@@ -321,19 +302,17 @@ static int udf_NLStoCS0(struct nls_table *nls, dstring *ocu, struct ustr *uni, i
 
 try_again:
 	u_len = 0U;
-	for (i = 0U; i < uni->u_len; i++)
-	{
+	for (i = 0U; i < uni->u_len; i++) {
 		len = nls->char2uni(&uni->u_name[i], uni->u_len-i, &uni_char);
 		if (len <= 0)
 			continue;
 
-		if (uni_char > max_val)
-		{
+		if (uni_char > max_val) {
 			max_val = 0xffffU;
 			ocu[0] = (uint8_t)0x10U;
 			goto try_again;
 		}
-		
+
 		if (max_val == 0xffffU)
 			ocu[++u_len] = (uint8_t)(uni_char >> 8);
 		ocu[++u_len] = (uint8_t)(uni_char & 0xffU);
@@ -349,35 +328,30 @@ int udf_get_filename(struct super_block *sb, uint8_t *sname, uint8_t *dname, int
 	struct ustr filename, unifilename;
 	int len;
 
-	if (udf_build_ustr_exact(&unifilename, sname, flen))
-	{
+	if (udf_build_ustr_exact(&unifilename, sname, flen)) {
 		return 0;
 	}
 
-	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UTF8))
-	{
-		if (!udf_CS0toUTF8(&filename, &unifilename) )
-		{
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UTF8)) {
+		if (!udf_CS0toUTF8(&filename, &unifilename)) {
 			udf_debug("Failed in udf_get_filename: sname = %s\n", sname);
 			return 0;
 		}
-	}
-	else if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP))
-	{
-		if (!udf_CS0toNLS(UDF_SB(sb)->s_nls_map, &filename, &unifilename) )
-		{
+	} else if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP)) {
+		if (!udf_CS0toNLS(UDF_SB(sb)->s_nls_map, &filename, &unifilename)) {
 			udf_debug("Failed in udf_get_filename: sname = %s\n", sname);
 			return 0;
 		}
-	}
-	else
+	} else {
 		return 0;
+	}
 
-	if ((len = udf_translate_to_linux(dname, filename.u_name, filename.u_len,
-		unifilename.u_name, unifilename.u_len)))
-	{
+	len = udf_translate_to_linux(dname, filename.u_name, filename.u_len,
+				     unifilename.u_name, unifilename.u_len);
+	if (len) {
 		return len;
 	}
+
 	return 0;
 }
 
@@ -386,70 +360,59 @@ int udf_put_filename(struct super_block *sb, const uint8_t *sname, uint8_t *dnam
 	struct ustr unifilename;
 	int namelen;
 
-	if ( !(udf_char_to_ustr(&unifilename, sname, flen)) )
-	{
+	if (!(udf_char_to_ustr(&unifilename, sname, flen))) {
 		return 0;
 	}
 
-	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UTF8))
-	{
-		if ( !(namelen = udf_UTF8toCS0(dname, &unifilename, UDF_NAME_LEN)) )
-		{
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UTF8)) {
+		namelen = udf_UTF8toCS0(dname, &unifilename, UDF_NAME_LEN);
+		if (!namelen) {
 			return 0;
 		}
-	}
-	else if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP))
-	{
-		if ( !(namelen = udf_NLStoCS0(UDF_SB(sb)->s_nls_map, dname, &unifilename, UDF_NAME_LEN)) )
-		{
+	} else if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP)) {
+		namelen = udf_NLStoCS0(UDF_SB(sb)->s_nls_map, dname, &unifilename, UDF_NAME_LEN);
+		if (!namelen) {
 			return 0;
 		}
-	}
-	else
+	} else {
 		return 0;
+	}
 
 	return namelen;
 }
 
 #define ILLEGAL_CHAR_MARK	'_'
-#define EXT_MARK			'.'
-#define CRC_MARK			'#'
-#define EXT_SIZE			5
+#define EXT_MARK		'.'
+#define CRC_MARK		'#'
+#define EXT_SIZE 		5
 
-static int udf_translate_to_linux(uint8_t *newName, uint8_t *udfName, int udfLen, uint8_t *fidName, int fidNameLen)
+static int udf_translate_to_linux(uint8_t *newName, uint8_t *udfName, int udfLen,
+				  uint8_t *fidName, int fidNameLen)
 {
-	int index, newIndex = 0, needsCRC = 0;	
+	int index, newIndex = 0, needsCRC = 0;
 	int extIndex = 0, newExtIndex = 0, hasExt = 0;
 	unsigned short valueCRC;
 	uint8_t curr;
 	const uint8_t hexChar[] = "0123456789ABCDEF";
 
-	if (udfName[0] == '.' && (udfLen == 1 ||
-		(udfLen == 2 && udfName[1] == '.')))
-	{
+	if (udfName[0] == '.' &&
+	    (udfLen == 1 || (udfLen == 2 && udfName[1] == '.'))) {
 		needsCRC = 1;
 		newIndex = udfLen;
 		memcpy(newName, udfName, udfLen);
-	}
-	else
-	{	
-		for (index = 0; index < udfLen; index++)
-		{
+	} else {
+		for (index = 0; index < udfLen; index++) {
 			curr = udfName[index];
-			if (curr == '/' || curr == 0)
-			{
+			if (curr == '/' || curr == 0) {
 				needsCRC = 1;
 				curr = ILLEGAL_CHAR_MARK;
-				while (index+1 < udfLen && (udfName[index+1] == '/' ||
-					udfName[index+1] == 0))
+				while (index + 1 < udfLen && (udfName[index + 1] == '/' ||
+							      udfName[index + 1] == 0))
 					index++;
-			}
-			if (curr == EXT_MARK && (udfLen - index - 1) <= EXT_SIZE)
-			{
-				if (udfLen == index + 1)
+			} if (curr == EXT_MARK && (udfLen - index - 1) <= EXT_SIZE) {
+				if (udfLen == index + 1) {
 					hasExt = 0;
-				else
-				{
+				} else {
 					hasExt = 1;
 					extIndex = index;
 					newExtIndex = newIndex;
@@ -461,26 +424,22 @@ static int udf_translate_to_linux(uint8_t *newName, uint8_t *udfName, int udfLen
 				needsCRC = 1;
 		}
 	}
-	if (needsCRC)
-	{
+	if (needsCRC) {
 		uint8_t ext[EXT_SIZE];
 		int localExtIndex = 0;
 
-		if (hasExt)
-		{
+		if (hasExt) {
 			int maxFilenameLen;
-			for(index = 0; index<EXT_SIZE && extIndex + index +1 < udfLen;
-				index++ )
-			{
+			for(index = 0; index < EXT_SIZE && extIndex + index + 1 < udfLen; index++) {
 				curr = udfName[extIndex + index + 1];
 
-				if (curr == '/' || curr == 0)
-				{
+				if (curr == '/' || curr == 0) {
 					needsCRC = 1;
 					curr = ILLEGAL_CHAR_MARK;
-					while(extIndex + index + 2 < udfLen && (index + 1 < EXT_SIZE
-						&& (udfName[extIndex + index + 2] == '/' ||
-							udfName[extIndex + index + 2] == 0)))
+					while(extIndex + index + 2 < udfLen &&
+					      (index + 1 < EXT_SIZE
+					       && (udfName[extIndex + index + 2] == '/' ||
+						   udfName[extIndex + index + 2] == 0)))
 						index++;
 				}
 				ext[localExtIndex++] = curr;
@@ -500,12 +459,12 @@ static int udf_translate_to_linux(uint8_t *newName, uint8_t *udfName, int udfLen
 		newName[newIndex++] = hexChar[(valueCRC & 0x00f0) >> 4];
 		newName[newIndex++] = hexChar[(valueCRC & 0x000f)];
 
-		if (hasExt)
-		{
+		if (hasExt) {
 			newName[newIndex++] = EXT_MARK;
-			for (index = 0;index < localExtIndex ;index++ )
+			for (index = 0; index < localExtIndex; index++)
 				newName[newIndex++] = ext[index];
 		}
 	}
+
 	return newIndex;
 }
