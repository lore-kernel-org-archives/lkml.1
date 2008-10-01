Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYJAKDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYJAKDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 06:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYJAKDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 06:03:20 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35223 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbYJAKDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 06:03:16 -0400
Date: Wed, 1 Oct 2008 12:53:01 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: jack@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] udf: don't pass structs on stack
Message-ID: <Pine.LNX.4.64.0810011252280.29644@sbz-30.cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Fix the udf code not to pass structs on stack where possible.

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/udf/balloc.c    |   59 +++++++++++++++++++++++--------------------
 fs/udf/dir.c       |    6 ++--
 fs/udf/directory.c |    6 ++--
 fs/udf/ialloc.c    |    4 +-
 fs/udf/inode.c     |   70 ++++++++++++++++++++++++++--------------------------
 fs/udf/misc.c      |    5 ++-
 fs/udf/namei.c     |   31 ++++++++++++----------
 fs/udf/super.c     |   22 ++++++++--------
 fs/udf/truncate.c  |   22 ++++++++--------
 fs/udf/udfdecl.h   |   20 +++++++++-----
 10 files changed, 129 insertions(+), 116 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 51bc2b3..c0e87db 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -92,7 +92,7 @@ static int read_block_bitmap(struct super_block *sb,
 	loc.logicalBlockNum = bitmap->s_extPosition;
 	loc.partitionReferenceNum = UDF_SB(sb)->s_partition;
 
-	bh = udf_tread(sb, udf_get_lb_pblock(sb, loc, block));
+	bh = udf_tread(sb, udf_get_lb_pblock(sb, &loc, block));
 	if (!bh)
 		retval = -EIO;
 
@@ -156,11 +156,13 @@ static bool udf_add_free_space(struct udf_sb_info *sbi,
 static void udf_bitmap_free_blocks(struct super_block *sb,
 				   struct inode *inode,
 				   struct udf_bitmap *bitmap,
-				   struct kernel_lb_addr bloc, uint32_t offset,
+				   struct kernel_lb_addr *bloc,
+				   uint32_t offset,
 				   uint32_t count)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct buffer_head *bh = NULL;
+	struct udf_part_map *partmap;
 	unsigned long block;
 	unsigned long block_group;
 	unsigned long bit;
@@ -169,17 +171,17 @@ static void udf_bitmap_free_blocks(struct super_block *sb,
 	unsigned long overflow;
 
 	mutex_lock(&sbi->s_alloc_mutex);
-	if (bloc.logicalBlockNum < 0 ||
-	    (bloc.logicalBlockNum + count) >
-		sbi->s_partmaps[bloc.partitionReferenceNum].s_partition_len) {
+	partmap = &sbi->s_partmaps[bloc->partitionReferenceNum];
+	if (bloc->logicalBlockNum < 0 ||
+	    (bloc->logicalBlockNum + count) >
+		partmap->s_partition_len) {
 		udf_debug("%d < %d || %d + %d > %d\n",
-			  bloc.logicalBlockNum, 0, bloc.logicalBlockNum, count,
-			  sbi->s_partmaps[bloc.partitionReferenceNum].
-							s_partition_len);
+			  bloc->logicalBlockNum, 0, bloc->logicalBlockNum,
+			  count, partmap->s_partition_len);
 		goto error_return;
 	}
 
-	block = bloc.logicalBlockNum + offset +
+	block = bloc->logicalBlockNum + offset +
 		(sizeof(struct spaceBitmapDesc) << 3);
 
 	do {
@@ -425,10 +427,12 @@ error_return:
 static void udf_table_free_blocks(struct super_block *sb,
 				  struct inode *inode,
 				  struct inode *table,
-				  struct kernel_lb_addr bloc, uint32_t offset,
+				  struct kernel_lb_addr *bloc,
+				  uint32_t offset,
 				  uint32_t count)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
+	struct udf_part_map *partmap;
 	uint32_t start, end;
 	uint32_t elen;
 	struct kernel_lb_addr eloc;
@@ -438,13 +442,13 @@ static void udf_table_free_blocks(struct super_block *sb,
 	struct udf_inode_info *iinfo;
 
 	mutex_lock(&sbi->s_alloc_mutex);
-	if (bloc.logicalBlockNum < 0 ||
-	    (bloc.logicalBlockNum + count) >
-		sbi->s_partmaps[bloc.partitionReferenceNum].s_partition_len) {
+	partmap = &sbi->s_partmaps[bloc->partitionReferenceNum];
+	if (bloc->logicalBlockNum < 0 ||
+	    (bloc->logicalBlockNum + count) >
+		partmap->s_partition_len) {
 		udf_debug("%d < %d || %d + %d > %d\n",
 			  bloc.logicalBlockNum, 0, bloc.logicalBlockNum, count,
-			  sbi->s_partmaps[bloc.partitionReferenceNum].
-							s_partition_len);
+			  partmap->s_partition_len);
 		goto error_return;
 	}
 
@@ -456,8 +460,8 @@ static void udf_table_free_blocks(struct super_block *sb,
 	if (udf_add_free_space(sbi, sbi->s_partition, count))
 		mark_buffer_dirty(sbi->s_lvid_bh);
 
-	start = bloc.logicalBlockNum + offset;
-	end = bloc.logicalBlockNum + offset + count - 1;
+	start = bloc->logicalBlockNum + offset;
+	end = bloc->logicalBlockNum + offset + count - 1;
 
 	epos.offset = oepos.offset = sizeof(struct unallocSpaceEntry);
 	elen = 0;
@@ -483,7 +487,7 @@ static void udf_table_free_blocks(struct super_block *sb,
 				start += count;
 				count = 0;
 			}
-			udf_write_aext(table, &oepos, eloc, elen, 1);
+			udf_write_aext(table, &oepos, &eloc, elen, 1);
 		} else if (eloc.logicalBlockNum == (end + 1)) {
 			if ((0x3FFFFFFF - elen) <
 					(count << sb->s_blocksize_bits)) {
@@ -502,7 +506,7 @@ static void udf_table_free_blocks(struct super_block *sb,
 				end -= count;
 				count = 0;
 			}
-			udf_write_aext(table, &oepos, eloc, elen, 1);
+			udf_write_aext(table, &oepos, &eloc, elen, 1);
 		}
 
 		if (epos.bh != oepos.bh) {
@@ -563,7 +567,7 @@ static void udf_table_free_blocks(struct super_block *sb,
 			elen -= sb->s_blocksize;
 
 			epos.bh = udf_tread(sb,
-					udf_get_lb_pblock(sb, epos.block, 0));
+					udf_get_lb_pblock(sb, &epos.block, 0));
 			if (!epos.bh) {
 				brelse(oepos.bh);
 				goto error_return;
@@ -635,7 +639,7 @@ static void udf_table_free_blocks(struct super_block *sb,
 
 		/* It's possible that stealing the block emptied the extent */
 		if (elen) {
-			udf_write_aext(table, &epos, eloc, elen, 1);
+			udf_write_aext(table, &epos, &eloc, elen, 1);
 
 			if (!epos.bh) {
 				iinfo->i_lenAlloc += adsize;
@@ -707,7 +711,7 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
 			alloc_count = block_count;
 			eloc.logicalBlockNum += alloc_count;
 			elen -= (alloc_count << sb->s_blocksize_bits);
-			udf_write_aext(table, &epos, eloc,
+			udf_write_aext(table, &epos, &eloc,
 					(etype << 30) | elen, 1);
 		} else
 			udf_delete_aext(table, epos, eloc,
@@ -814,7 +818,7 @@ static int udf_table_new_block(struct super_block *sb,
 	}
 
 	if (goal_elen)
-		udf_write_aext(table, &goal_epos, goal_eloc, goal_elen, 1);
+		udf_write_aext(table, &goal_epos, &goal_eloc, goal_elen, 1);
 	else
 		udf_delete_aext(table, goal_epos, goal_eloc, goal_elen);
 	brelse(goal_epos.bh);
@@ -828,12 +832,11 @@ static int udf_table_new_block(struct super_block *sb,
 	return newblock;
 }
 
-inline void udf_free_blocks(struct super_block *sb,
-			    struct inode *inode,
-			    struct kernel_lb_addr bloc, uint32_t offset,
-			    uint32_t count)
+void udf_free_blocks(struct super_block *sb, struct inode *inode,
+		     struct kernel_lb_addr *bloc, uint32_t offset,
+		     uint32_t count)
 {
-	uint16_t partition = bloc.partitionReferenceNum;
+	uint16_t partition = bloc->partitionReferenceNum;
 	struct udf_part_map *map = &UDF_SB(sb)->s_partmaps[partition];
 
 	if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP) {
diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index 19d3ae4..2efd4d5 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -80,7 +80,7 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
 			ret = -ENOENT;
 			goto out;
 		}
-		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
+		block = udf_get_lb_pblock(dir->i_sb, &eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(struct short_ad);
@@ -101,7 +101,7 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
 			if (i + offset > (elen >> dir->i_sb->s_blocksize_bits))
 				i = (elen >> dir->i_sb->s_blocksize_bits) - offset;
 			for (num = 0; i > 0; i--) {
-				block = udf_get_lb_pblock(dir->i_sb, eloc, offset + i);
+				block = udf_get_lb_pblock(dir->i_sb, &eloc, offset + i);
 				tmp = udf_tgetblk(dir->i_sb, block);
 				if (tmp && !buffer_uptodate(tmp) && !buffer_locked(tmp))
 					bha[num++] = tmp;
@@ -163,7 +163,7 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
 		} else {
 			struct kernel_lb_addr tloc = lelb_to_cpu(cfi.icb.extLocation);
 
-			iblock = udf_get_lb_pblock(dir->i_sb, tloc, 0);
+			iblock = udf_get_lb_pblock(dir->i_sb, &tloc, 0);
 			flen = udf_get_filename(dir->i_sb, nameptr, fname, lfi);
 			dt_type = DT_UNKNOWN;
 		}
diff --git a/fs/udf/directory.c b/fs/udf/directory.c
index 0ab251d..1d2c570 100644
--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -111,7 +111,7 @@ struct fileIdentDesc *udf_fileident_read(struct inode *dir, loff_t *nf_pos,
 		    (EXT_RECORDED_ALLOCATED >> 30))
 			return NULL;
 
-		block = udf_get_lb_pblock(dir->i_sb, *eloc, *offset);
+		block = udf_get_lb_pblock(dir->i_sb, eloc, *offset);
 
 		(*offset)++;
 
@@ -131,7 +131,7 @@ struct fileIdentDesc *udf_fileident_read(struct inode *dir, loff_t *nf_pos,
 			if (i + *offset > (*elen >> blocksize_bits))
 				i = (*elen >> blocksize_bits)-*offset;
 			for (num = 0; i > 0; i--) {
-				block = udf_get_lb_pblock(dir->i_sb, *eloc,
+				block = udf_get_lb_pblock(dir->i_sb, eloc,
 							  *offset + i);
 				tmp = udf_tgetblk(dir->i_sb, block);
 				if (tmp && !buffer_uptodate(tmp) &&
@@ -169,7 +169,7 @@ struct fileIdentDesc *udf_fileident_read(struct inode *dir, loff_t *nf_pos,
 		    (EXT_RECORDED_ALLOCATED >> 30))
 			return NULL;
 
-		block = udf_get_lb_pblock(dir->i_sb, *eloc, *offset);
+		block = udf_get_lb_pblock(dir->i_sb, eloc, *offset);
 
 		(*offset)++;
 
diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
index a4f2b3c..d8c3b3b 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -54,7 +54,7 @@ void udf_free_inode(struct inode *inode)
 	}
 	mutex_unlock(&sbi->s_alloc_mutex);
 
-	udf_free_blocks(sb, NULL, UDF_I(inode)->i_location, 0, 1);
+	udf_free_blocks(sb, NULL, &UDF_I(inode)->i_location, 0, 1);
 }
 
 struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
@@ -138,7 +138,7 @@ struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
 	iinfo->i_location.logicalBlockNum = block;
 	iinfo->i_location.partitionReferenceNum =
 				dinfo->i_location.partitionReferenceNum;
-	inode->i_ino = udf_get_lb_pblock(sb, iinfo->i_location, 0);
+	inode->i_ino = udf_get_lb_pblock(sb, &iinfo->i_location, 0);
 	inode->i_blocks = 0;
 	iinfo->i_lenEAttr = 0;
 	iinfo->i_lenAlloc = 0;
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 3d1cbd1..9e8652d 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -280,7 +280,7 @@ struct buffer_head *udf_expand_dir_adinicb(struct inode *inode, int *block,
 	epos.bh = NULL;
 	epos.block = iinfo->i_location;
 	epos.offset = udf_file_entry_alloc_offset(inode);
-	udf_add_aext(inode, &epos, eloc, elen, 0);
+	udf_add_aext(inode, &epos, &eloc, elen, 0);
 	/* UniqueID stuff */
 
 	brelse(epos.bh);
@@ -410,11 +410,11 @@ int udf_extend_file(struct inode *inode, struct extent_position *last_pos,
 	}
 
 	if (fake) {
-		udf_add_aext(inode, last_pos, last_ext->extLocation,
+		udf_add_aext(inode, last_pos, &last_ext->extLocation,
 			     last_ext->extLength, 1);
 		count++;
 	} else
-		udf_write_aext(inode, last_pos, last_ext->extLocation,
+		udf_write_aext(inode, last_pos, &last_ext->extLocation,
 				last_ext->extLength, 1);
 
 	/* Managed to do everything necessary? */
@@ -431,7 +431,7 @@ int udf_extend_file(struct inode *inode, struct extent_position *last_pos,
 	/* Create enough extents to cover the whole hole */
 	while (blocks > add) {
 		blocks -= add;
-		if (udf_add_aext(inode, last_pos, last_ext->extLocation,
+		if (udf_add_aext(inode, last_pos, &last_ext->extLocation,
 				 last_ext->extLength, 1) == -1)
 			return -1;
 		count++;
@@ -439,7 +439,7 @@ int udf_extend_file(struct inode *inode, struct extent_position *last_pos,
 	if (blocks) {
 		last_ext->extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
 			(blocks << sb->s_blocksize_bits);
-		if (udf_add_aext(inode, last_pos, last_ext->extLocation,
+		if (udf_add_aext(inode, last_pos, &last_ext->extLocation,
 				 last_ext->extLength, 1) == -1)
 			return -1;
 		count++;
@@ -448,7 +448,7 @@ int udf_extend_file(struct inode *inode, struct extent_position *last_pos,
 out:
 	/* Do we have some preallocated blocks saved? */
 	if (prealloc_len) {
-		if (udf_add_aext(inode, last_pos, prealloc_loc,
+		if (udf_add_aext(inode, last_pos, &prealloc_loc,
 				 prealloc_len, 1) == -1)
 			return -1;
 		last_ext->extLocation = prealloc_loc;
@@ -549,12 +549,12 @@ static struct buffer_head *inode_getblk(struct inode *inode, sector_t block,
 			elen = EXT_RECORDED_ALLOCATED |
 				((elen + inode->i_sb->s_blocksize - 1) &
 				 ~(inode->i_sb->s_blocksize - 1));
-			etype = udf_write_aext(inode, &cur_epos, eloc, elen, 1);
+			etype = udf_write_aext(inode, &cur_epos, &eloc, elen, 1);
 		}
 		brelse(prev_epos.bh);
 		brelse(cur_epos.bh);
 		brelse(next_epos.bh);
-		newblock = udf_get_lb_pblock(inode->i_sb, eloc, offset);
+		newblock = udf_get_lb_pblock(inode->i_sb, &eloc, offset);
 		*phys = newblock;
 		return NULL;
 	}
@@ -725,7 +725,7 @@ static void udf_split_extents(struct inode *inode, int *c, int offset,
 		if (offset) {
 			if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
 				udf_free_blocks(inode->i_sb, inode,
-						laarr[curr].extLocation,
+						&laarr[curr].extLocation,
 						0, offset);
 				laarr[curr].extLength =
 					EXT_NOT_RECORDED_NOT_ALLOCATED |
@@ -910,7 +910,7 @@ static void udf_merge_extents(struct inode *inode,
 				(EXT_NOT_RECORDED_ALLOCATED >> 30)) &&
 			   ((lip1->extLength >> 30) ==
 				(EXT_NOT_RECORDED_NOT_ALLOCATED >> 30))) {
-			udf_free_blocks(inode->i_sb, inode, li->extLocation, 0,
+			udf_free_blocks(inode->i_sb, inode, &li->extLocation, 0,
 					((li->extLength &
 					  UDF_EXTENT_LENGTH_MASK) +
 					 blocksize - 1) >> blocksize_bits);
@@ -944,7 +944,7 @@ static void udf_merge_extents(struct inode *inode,
 		} else if ((li->extLength >> 30) ==
 					(EXT_NOT_RECORDED_ALLOCATED >> 30)) {
 			udf_free_blocks(inode->i_sb, inode,
-					li->extLocation, 0,
+					&li->extLocation, 0,
 					((li->extLength &
 						UDF_EXTENT_LENGTH_MASK) +
 					 blocksize - 1) >> blocksize_bits);
@@ -982,7 +982,7 @@ static void udf_update_extents(struct inode *inode,
 
 	for (i = start; i < endnum; i++) {
 		udf_next_aext(inode, epos, &tmploc, &tmplen, 0);
-		udf_write_aext(inode, epos, laarr[i].extLocation,
+		udf_write_aext(inode, epos, &laarr[i].extLocation,
 			       laarr[i].extLength, 1);
 	}
 }
@@ -1075,7 +1075,7 @@ static void __udf_read_inode(struct inode *inode)
 	 *      i_nlink = 1
 	 *      i_op = NULL;
 	 */
-	bh = udf_read_ptagged(inode->i_sb, iinfo->i_location, 0, &ident);
+	bh = udf_read_ptagged(inode->i_sb, &iinfo->i_location, 0, &ident);
 	if (!bh) {
 		printk(KERN_ERR "udf: udf_read_inode(ino %ld) failed !bh\n",
 		       inode->i_ino);
@@ -1097,7 +1097,7 @@ static void __udf_read_inode(struct inode *inode)
 	if (fe->icbTag.strategyType == cpu_to_le16(4096)) {
 		struct buffer_head *ibh;
 
-		ibh = udf_read_ptagged(inode->i_sb, iinfo->i_location, 1,
+		ibh = udf_read_ptagged(inode->i_sb, &iinfo->i_location, 1,
 					&ident);
 		if (ident == TAG_IDENT_IE && ibh) {
 			struct buffer_head *nbh = NULL;
@@ -1108,7 +1108,7 @@ static void __udf_read_inode(struct inode *inode)
 			loc = lelb_to_cpu(ie->indirectICB.extLocation);
 
 			if (ie->indirectICB.extLength &&
-				(nbh = udf_read_ptagged(inode->i_sb, loc, 0,
+				(nbh = udf_read_ptagged(inode->i_sb, &loc, 0,
 							&ident))) {
 				if (ident == TAG_IDENT_FE ||
 					ident == TAG_IDENT_EFE) {
@@ -1395,7 +1395,7 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 
 	bh = udf_tread(inode->i_sb,
 			udf_get_lb_pblock(inode->i_sb,
-					  iinfo->i_location, 0));
+					  &iinfo->i_location, 0));
 	if (!bh) {
 		udf_debug("bread failure\n");
 		return -EIO;
@@ -1605,7 +1605,7 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 	return err;
 }
 
-struct inode *udf_iget(struct super_block *sb, struct kernel_lb_addr ino)
+struct inode *udf_iget(struct super_block *sb, struct kernel_lb_addr *ino)
 {
 	unsigned long block = udf_get_lb_pblock(sb, ino, 0);
 	struct inode *inode = iget_locked(sb, block);
@@ -1614,7 +1614,7 @@ struct inode *udf_iget(struct super_block *sb, struct kernel_lb_addr ino)
 		return NULL;
 
 	if (inode->i_state & I_NEW) {
-		memcpy(&UDF_I(inode)->i_location, &ino, sizeof(struct kernel_lb_addr));
+		memcpy(&UDF_I(inode)->i_location, ino, sizeof(struct kernel_lb_addr));
 		__udf_read_inode(inode);
 		unlock_new_inode(inode);
 	}
@@ -1622,10 +1622,10 @@ struct inode *udf_iget(struct super_block *sb, struct kernel_lb_addr ino)
 	if (is_bad_inode(inode))
 		goto out_iput;
 
-	if (ino.logicalBlockNum >= UDF_SB(sb)->
-			s_partmaps[ino.partitionReferenceNum].s_partition_len) {
+	if (ino->logicalBlockNum >= UDF_SB(sb)->
+			s_partmaps[ino->partitionReferenceNum].s_partition_len) {
 		udf_debug("block=%d, partition=%d out of range\n",
-			  ino.logicalBlockNum, ino.partitionReferenceNum);
+			  ino->logicalBlockNum, ino->partitionReferenceNum);
 		make_bad_inode(inode);
 		goto out_iput;
 	}
@@ -1638,7 +1638,7 @@ struct inode *udf_iget(struct super_block *sb, struct kernel_lb_addr ino)
 }
 
 int8_t udf_add_aext(struct inode *inode, struct extent_position *epos,
-		    struct kernel_lb_addr eloc, uint32_t elen, int inc)
+		    struct kernel_lb_addr *eloc, uint32_t elen, int inc)
 {
 	int adsize;
 	struct short_ad *sad = NULL;
@@ -1674,7 +1674,7 @@ int8_t udf_add_aext(struct inode *inode, struct extent_position *epos,
 		if (!epos->block.logicalBlockNum)
 			return -1;
 		nbh = udf_tgetblk(inode->i_sb, udf_get_lb_pblock(inode->i_sb,
-								 epos->block,
+								 &epos->block,
 								 0));
 		if (!nbh)
 			return -1;
@@ -1768,7 +1768,7 @@ int8_t udf_add_aext(struct inode *inode, struct extent_position *epos,
 }
 
 int8_t udf_write_aext(struct inode *inode, struct extent_position *epos,
-		      struct kernel_lb_addr eloc, uint32_t elen, int inc)
+		      struct kernel_lb_addr *eloc, uint32_t elen, int inc)
 {
 	int adsize;
 	uint8_t *ptr;
@@ -1787,13 +1787,13 @@ int8_t udf_write_aext(struct inode *inode, struct extent_position *epos,
 	case ICBTAG_FLAG_AD_SHORT:
 		sad = (struct short_ad *)ptr;
 		sad->extLength = cpu_to_le32(elen);
-		sad->extPosition = cpu_to_le32(eloc.logicalBlockNum);
+		sad->extPosition = cpu_to_le32(eloc->logicalBlockNum);
 		adsize = sizeof(struct short_ad);
 		break;
 	case ICBTAG_FLAG_AD_LONG:
 		lad = (struct long_ad *)ptr;
 		lad->extLength = cpu_to_le32(elen);
-		lad->extLocation = cpu_to_lelb(eloc);
+		lad->extLocation = cpu_to_lelb(*eloc);
 		memset(lad->impUse, 0x00, sizeof(lad->impUse));
 		adsize = sizeof(struct long_ad);
 		break;
@@ -1832,7 +1832,7 @@ int8_t udf_next_aext(struct inode *inode, struct extent_position *epos,
 		epos->block = *eloc;
 		epos->offset = sizeof(struct allocExtDesc);
 		brelse(epos->bh);
-		block = udf_get_lb_pblock(inode->i_sb, epos->block, 0);
+		block = udf_get_lb_pblock(inode->i_sb, &epos->block, 0);
 		epos->bh = udf_tread(inode->i_sb, block);
 		if (!epos->bh) {
 			udf_debug("reading block %d failed!\n", block);
@@ -1909,11 +1909,11 @@ static int8_t udf_insert_aext(struct inode *inode, struct extent_position epos,
 		get_bh(epos.bh);
 
 	while ((etype = udf_next_aext(inode, &epos, &oeloc, &oelen, 0)) != -1) {
-		udf_write_aext(inode, &epos, neloc, nelen, 1);
+		udf_write_aext(inode, &epos, &neloc, nelen, 1);
 		neloc = oeloc;
 		nelen = (etype << 30) | oelen;
 	}
-	udf_add_aext(inode, &epos, neloc, nelen, 1);
+	udf_add_aext(inode, &epos, &neloc, nelen, 1);
 	brelse(epos.bh);
 
 	return (nelen >> 30);
@@ -1946,7 +1946,7 @@ int8_t udf_delete_aext(struct inode *inode, struct extent_position epos,
 		return -1;
 
 	while ((etype = udf_next_aext(inode, &epos, &eloc, &elen, 1)) != -1) {
-		udf_write_aext(inode, &oepos, eloc, (etype << 30) | elen, 1);
+		udf_write_aext(inode, &oepos, &eloc, (etype << 30) | elen, 1);
 		if (oepos.bh != epos.bh) {
 			oepos.block = epos.block;
 			brelse(oepos.bh);
@@ -1959,9 +1959,9 @@ int8_t udf_delete_aext(struct inode *inode, struct extent_position epos,
 	elen = 0;
 
 	if (epos.bh != oepos.bh) {
-		udf_free_blocks(inode->i_sb, inode, epos.block, 0, 1);
-		udf_write_aext(inode, &oepos, eloc, elen, 1);
-		udf_write_aext(inode, &oepos, eloc, elen, 1);
+		udf_free_blocks(inode->i_sb, inode, &epos.block, 0, 1);
+		udf_write_aext(inode, &oepos, &eloc, elen, 1);
+		udf_write_aext(inode, &oepos, &eloc, elen, 1);
 		if (!oepos.bh) {
 			iinfo->i_lenAlloc -= (adsize * 2);
 			mark_inode_dirty(inode);
@@ -1978,7 +1978,7 @@ int8_t udf_delete_aext(struct inode *inode, struct extent_position epos,
 			mark_buffer_dirty_inode(oepos.bh, inode);
 		}
 	} else {
-		udf_write_aext(inode, &oepos, eloc, elen, 1);
+		udf_write_aext(inode, &oepos, &eloc, elen, 1);
 		if (!oepos.bh) {
 			iinfo->i_lenAlloc -= adsize;
 			mark_inode_dirty(inode);
@@ -2045,7 +2045,7 @@ long udf_block_map(struct inode *inode, sector_t block)
 
 	if (inode_bmap(inode, block, &epos, &eloc, &elen, &offset) ==
 						(EXT_RECORDED_ALLOCATED >> 30))
-		ret = udf_get_lb_pblock(inode->i_sb, eloc, offset);
+		ret = udf_get_lb_pblock(inode->i_sb, &eloc, offset);
 	else
 		ret = 0;
 
diff --git a/fs/udf/misc.c b/fs/udf/misc.c
index 6e164c7..9215700 100644
--- a/fs/udf/misc.c
+++ b/fs/udf/misc.c
@@ -255,11 +255,12 @@ error_out:
 	return NULL;
 }
 
-struct buffer_head *udf_read_ptagged(struct super_block *sb, struct kernel_lb_addr loc,
+struct buffer_head *udf_read_ptagged(struct super_block *sb,
+				     struct kernel_lb_addr *loc,
 				     uint32_t offset, uint16_t *ident)
 {
 	return udf_read_tagged(sb, udf_get_lb_pblock(sb, loc, offset),
-			       loc.logicalBlockNum + offset, ident);
+			       loc->logicalBlockNum + offset, ident);
 }
 
 void udf_update_tag(char *data, int length)
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 4926edd..071e4a8 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -171,7 +171,7 @@ static struct fileIdentDesc *udf_find_entry(struct inode *dir,
 		if (inode_bmap(dir, f_pos >> dir->i_sb->s_blocksize_bits, &epos,
 		    &eloc, &elen, &offset) != (EXT_RECORDED_ALLOCATED >> 30))
 			goto out_err;
-		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
+		block = udf_get_lb_pblock(dir->i_sb, &eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(struct short_ad);
@@ -284,11 +284,13 @@ static struct dentry *udf_lookup(struct inode *dir, struct dentry *dentry,
 #endif /* UDF_RECOVERY */
 
 	if (udf_find_entry(dir, dentry, &fibh, &cfi)) {
+		struct kernel_lb_addr loc;
 		if (fibh.sbh != fibh.ebh)
 			brelse(fibh.ebh);
 		brelse(fibh.sbh);
 
-		inode = udf_iget(dir->i_sb, lelb_to_cpu(cfi.icb.extLocation));
+		loc = lelb_to_cpu(cfi.icb.extLocation);
+		inode = udf_iget(dir->i_sb, &loc);
 		if (!inode) {
 			unlock_kernel();
 			return ERR_PTR(-EACCES);
@@ -352,11 +354,11 @@ static struct fileIdentDesc *udf_add_entry(struct inode *dir,
 		if (inode_bmap(dir, f_pos >> dir->i_sb->s_blocksize_bits, &epos,
 		    &eloc, &elen, &offset) != (EXT_RECORDED_ALLOCATED >> 30)) {
 			block = udf_get_lb_pblock(dir->i_sb,
-					dinfo->i_location, 0);
+					&dinfo->i_location, 0);
 			fibh->soffset = fibh->eoffset = sb->s_blocksize;
 			goto add;
 		}
-		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
+		block = udf_get_lb_pblock(dir->i_sb, &eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(struct short_ad);
@@ -413,7 +415,7 @@ add:
 			epos.offset -= sizeof(struct short_ad);
 		else if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
 			epos.offset -= sizeof(struct long_ad);
-		udf_write_aext(dir, &epos, eloc, elen, 1);
+		udf_write_aext(dir, &epos, &eloc, elen, 1);
 	}
 	f_pos += nfidlen;
 
@@ -725,7 +727,7 @@ static int empty_dir(struct inode *dir)
 	else if (inode_bmap(dir, f_pos >> dir->i_sb->s_blocksize_bits,
 			      &epos, &eloc, &elen, &offset) ==
 					(EXT_RECORDED_ALLOCATED >> 30)) {
-		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
+		block = udf_get_lb_pblock(dir->i_sb, &eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(struct short_ad);
@@ -789,7 +791,7 @@ static int udf_rmdir(struct inode *dir, struct dentry *dentry)
 
 	retval = -EIO;
 	tloc = lelb_to_cpu(cfi.icb.extLocation);
-	if (udf_get_lb_pblock(dir->i_sb, tloc, 0) != inode->i_ino)
+	if (udf_get_lb_pblock(dir->i_sb, &tloc, 0) != inode->i_ino)
 		goto end_rmdir;
 	retval = -ENOTEMPTY;
 	if (!empty_dir(inode))
@@ -835,7 +837,7 @@ static int udf_unlink(struct inode *dir, struct dentry *dentry)
 
 	retval = -EIO;
 	tloc = lelb_to_cpu(cfi.icb.extLocation);
-	if (udf_get_lb_pblock(dir->i_sb, tloc, 0) != inode->i_ino)
+	if (udf_get_lb_pblock(dir->i_sb, &tloc, 0) != inode->i_ino)
 		goto end_unlink;
 
 	if (!inode->i_nlink) {
@@ -914,7 +916,7 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
 				iinfo->i_location.partitionReferenceNum;
 		bsize = inode->i_sb->s_blocksize;
 		iinfo->i_lenExtents = bsize;
-		udf_add_aext(inode, &epos, eloc, bsize, 0);
+		udf_add_aext(inode, &epos, &eloc, bsize, 0);
 		brelse(epos.bh);
 
 		block = udf_get_pblock(inode->i_sb, block,
@@ -1120,7 +1122,7 @@ static int udf_rename(struct inode *old_dir, struct dentry *old_dentry,
 		brelse(ofibh.sbh);
 	}
 	tloc = lelb_to_cpu(ocfi.icb.extLocation);
-	if (!ofi || udf_get_lb_pblock(old_dir->i_sb, tloc, 0)
+	if (!ofi || udf_get_lb_pblock(old_dir->i_sb, &tloc, 0)
 	    != old_inode->i_ino)
 		goto end_rename;
 
@@ -1159,7 +1161,7 @@ static int udf_rename(struct inode *old_dir, struct dentry *old_dentry,
 		if (!dir_fi)
 			goto end_rename;
 		tloc = lelb_to_cpu(dir_fi->icb.extLocation);
-		if (udf_get_lb_pblock(old_inode->i_sb, tloc, 0) !=
+		if (udf_get_lb_pblock(old_inode->i_sb, &tloc, 0) !=
 				old_dir->i_ino)
 			goto end_rename;
 
@@ -1243,6 +1245,7 @@ end_rename:
 
 static struct dentry *udf_get_parent(struct dentry *child)
 {
+	struct kernel_lb_addr tloc;
 	struct dentry *parent;
 	struct inode *inode = NULL;
 	struct dentry dotdot;
@@ -1260,8 +1263,8 @@ static struct dentry *udf_get_parent(struct dentry *child)
 		brelse(fibh.ebh);
 	brelse(fibh.sbh);
 
-	inode = udf_iget(child->d_inode->i_sb,
-			 lelb_to_cpu(cfi.icb.extLocation));
+	tloc = lelb_to_cpu(cfi.icb.extLocation);
+	inode = udf_iget(child->d_inode->i_sb, &tloc);
 	if (!inode)
 		goto out_unlock;
 	unlock_kernel();
@@ -1291,7 +1294,7 @@ static struct dentry *udf_nfs_get_inode(struct super_block *sb, u32 block,
 
 	loc.logicalBlockNum = block;
 	loc.partitionReferenceNum = partref;
-	inode = udf_iget(sb, loc);
+	inode = udf_iget(sb, &loc);
 
 	if (inode == NULL)
 		return ERR_PTR(-ENOMEM);
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 99a9369..dc26cf8 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -820,7 +820,7 @@ static int udf_find_fileset(struct super_block *sb,
 
 	if (fileset->logicalBlockNum != 0xFFFFFFFF ||
 	    fileset->partitionReferenceNum != 0xFFFF) {
-		bh = udf_read_ptagged(sb, *fileset, 0, &ident);
+		bh = udf_read_ptagged(sb, fileset, 0, &ident);
 
 		if (!bh) {
 			return 1;
@@ -850,7 +850,7 @@ static int udf_find_fileset(struct super_block *sb,
 			newfileset.logicalBlockNum = 0;
 
 			do {
-				bh = udf_read_ptagged(sb, newfileset, 0,
+				bh = udf_read_ptagged(sb, &newfileset, 0,
 						      &ident);
 				if (!bh) {
 					newfileset.logicalBlockNum++;
@@ -959,7 +959,7 @@ static int udf_load_metadata_files(struct super_block *sb, int partition)
 	udf_debug("Metadata file location: block = %d part = %d\n",
 			  addr.logicalBlockNum, addr.partitionReferenceNum);
 
-	mdata->s_metadata_fe = udf_iget(sb, addr);
+	mdata->s_metadata_fe = udf_iget(sb, &addr);
 
 	if (mdata->s_metadata_fe == NULL) {
 		udf_warning(sb, __func__, "metadata inode efe not found, "
@@ -981,7 +981,7 @@ static int udf_load_metadata_files(struct super_block *sb, int partition)
 	udf_debug("Mirror metadata file location: block = %d part = %d\n",
 			  addr.logicalBlockNum, addr.partitionReferenceNum);
 
-	mdata->s_mirror_fe = udf_iget(sb, addr);
+	mdata->s_mirror_fe = udf_iget(sb, &addr);
 
 	if (mdata->s_mirror_fe == NULL) {
 		if (fe_error) {
@@ -1013,7 +1013,7 @@ static int udf_load_metadata_files(struct super_block *sb, int partition)
 		udf_debug("Bitmap file location: block = %d part = %d\n",
 			addr.logicalBlockNum, addr.partitionReferenceNum);
 
-		mdata->s_bitmap_fe = udf_iget(sb, addr);
+		mdata->s_bitmap_fe = udf_iget(sb, &addr);
 
 		if (mdata->s_bitmap_fe == NULL) {
 			if (sb->s_flags & MS_RDONLY)
@@ -1125,7 +1125,7 @@ static int udf_fill_partdesc_info(struct super_block *sb,
 			.partitionReferenceNum = p_index,
 		};
 
-		map->s_uspace.s_table = udf_iget(sb, loc);
+		map->s_uspace.s_table = udf_iget(sb, &loc);
 		if (!map->s_uspace.s_table) {
 			udf_debug("cannot load unallocSpaceTable (part %d)\n",
 					p_index);
@@ -1160,7 +1160,7 @@ static int udf_fill_partdesc_info(struct super_block *sb,
 			.partitionReferenceNum = p_index,
 		};
 
-		map->s_fspace.s_table = udf_iget(sb, loc);
+		map->s_fspace.s_table = udf_iget(sb, &loc);
 		if (!map->s_fspace.s_table) {
 			udf_debug("cannot load freedSpaceTable (part %d)\n",
 				p_index);
@@ -1201,7 +1201,7 @@ static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
 	/* VAT file entry is in the last recorded block */
 	ino.partitionReferenceNum = type1_index;
 	ino.logicalBlockNum = sbi->s_last_block - map->s_partition_root;
-	sbi->s_vat_inode = udf_iget(sb, ino);
+	sbi->s_vat_inode = udf_iget(sb, &ino);
 	if (!sbi->s_vat_inode)
 		return 1;
 
@@ -1991,7 +1991,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	/* Assign the root inode */
 	/* assign inodes by physical block number */
 	/* perhaps it's not extensible enough, but for now ... */
-	inode = udf_iget(sb, rootdir);
+	inode = udf_iget(sb, &rootdir);
 	if (!inode) {
 		printk(KERN_ERR "UDF-fs: Error in udf_iget, block=%d, "
 				"partition=%d\n",
@@ -2124,7 +2124,7 @@ static unsigned int udf_count_free_bitmap(struct super_block *sb,
 
 	loc.logicalBlockNum = bitmap->s_extPosition;
 	loc.partitionReferenceNum = UDF_SB(sb)->s_partition;
-	bh = udf_read_ptagged(sb, loc, 0, &ident);
+	bh = udf_read_ptagged(sb, &loc, 0, &ident);
 
 	if (!bh) {
 		printk(KERN_ERR "udf: udf_count_free failed\n");
@@ -2147,7 +2147,7 @@ static unsigned int udf_count_free_bitmap(struct super_block *sb,
 		bytes -= cur_bytes;
 		if (bytes) {
 			brelse(bh);
-			newblock = udf_get_lb_pblock(sb, loc, ++block);
+			newblock = udf_get_lb_pblock(sb, &loc, ++block);
 			bh = udf_tread(sb, newblock);
 			if (!bh) {
 				udf_debug("read failed\n");
diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index f2fad30..225527c 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -28,7 +28,7 @@
 #include "udf_sb.h"
 
 static void extent_trunc(struct inode *inode, struct extent_position *epos,
-			 struct kernel_lb_addr eloc, int8_t etype, uint32_t elen,
+			 struct kernel_lb_addr *eloc, int8_t etype, uint32_t elen,
 			 uint32_t nelen)
 {
 	struct kernel_lb_addr neloc = {};
@@ -43,12 +43,12 @@ static void extent_trunc(struct inode *inode, struct extent_position *epos,
 					last_block);
 			etype = (EXT_NOT_RECORDED_NOT_ALLOCATED >> 30);
 		} else
-			neloc = eloc;
+			neloc = *eloc;
 		nelen = (etype << 30) | nelen;
 	}
 
 	if (elen != nelen) {
-		udf_write_aext(inode, epos, neloc, nelen, 0);
+		udf_write_aext(inode, epos, &neloc, nelen, 0);
 		if (last_block - first_block > 0) {
 			if (etype == (EXT_RECORDED_ALLOCATED >> 30))
 				mark_inode_dirty(inode);
@@ -106,7 +106,7 @@ void udf_truncate_tail_extent(struct inode *inode)
 				       (unsigned)elen);
 			nelen = elen - (lbcount - inode->i_size);
 			epos.offset -= adsize;
-			extent_trunc(inode, &epos, eloc, etype, elen, nelen);
+			extent_trunc(inode, &epos, &eloc, etype, elen, nelen);
 			epos.offset += adsize;
 			if (udf_next_aext(inode, &epos, &eloc, &elen, 1) != -1)
 				printk(KERN_ERR "udf_truncate_tail_extent(): "
@@ -152,7 +152,7 @@ void udf_discard_prealloc(struct inode *inode)
 	if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
 		epos.offset -= adsize;
 		lbcount -= elen;
-		extent_trunc(inode, &epos, eloc, etype, elen, 0);
+		extent_trunc(inode, &epos, &eloc, etype, elen, 0);
 		if (!epos.bh) {
 			iinfo->i_lenAlloc =
 				epos.offset -
@@ -221,7 +221,7 @@ void udf_truncate_extents(struct inode *inode)
 		(inode->i_size & (sb->s_blocksize - 1));
 	if (etype != -1) {
 		epos.offset -= adsize;
-		extent_trunc(inode, &epos, eloc, etype, elen, byte_offset);
+		extent_trunc(inode, &epos, &eloc, etype, elen, byte_offset);
 		epos.offset += adsize;
 		if (byte_offset)
 			lenalloc = epos.offset;
@@ -236,12 +236,12 @@ void udf_truncate_extents(struct inode *inode)
 		while ((etype = udf_current_aext(inode, &epos, &eloc,
 						 &elen, 0)) != -1) {
 			if (etype == (EXT_NEXT_EXTENT_ALLOCDECS >> 30)) {
-				udf_write_aext(inode, &epos, neloc, nelen, 0);
+				udf_write_aext(inode, &epos, &neloc, nelen, 0);
 				if (indirect_ext_len) {
 					/* We managed to free all extents in the
 					 * indirect extent - free it too */
 					BUG_ON(!epos.bh);
-					udf_free_blocks(sb, inode, epos.block,
+					udf_free_blocks(sb, inode, &epos.block,
 							0, indirect_ext_len);
 				} else if (!epos.bh) {
 					iinfo->i_lenAlloc = lenalloc;
@@ -253,7 +253,7 @@ void udf_truncate_extents(struct inode *inode)
 				epos.offset = sizeof(struct allocExtDesc);
 				epos.block = eloc;
 				epos.bh = udf_tread(sb,
-						udf_get_lb_pblock(sb, eloc, 0));
+						udf_get_lb_pblock(sb, &eloc, 0));
 				if (elen)
 					indirect_ext_len =
 						(elen + sb->s_blocksize - 1) >>
@@ -261,7 +261,7 @@ void udf_truncate_extents(struct inode *inode)
 				else
 					indirect_ext_len = 1;
 			} else {
-				extent_trunc(inode, &epos, eloc, etype,
+				extent_trunc(inode, &epos, &eloc, etype,
 					     elen, 0);
 				epos.offset += adsize;
 			}
@@ -269,7 +269,7 @@ void udf_truncate_extents(struct inode *inode)
 
 		if (indirect_ext_len) {
 			BUG_ON(!epos.bh);
-			udf_free_blocks(sb, inode, epos.block, 0,
+			udf_free_blocks(sb, inode, &epos.block, 0,
 					indirect_ext_len);
 		} else if (!epos.bh) {
 			iinfo->i_lenAlloc = lenalloc;
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index 35f0b9b..9a2a9b6 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -62,8 +62,6 @@ static inline size_t udf_ext0_offset(struct inode *inode)
 		return 0;
 }
 
-#define udf_get_lb_pblock(sb,loc,offset) udf_get_pblock((sb), (loc).logicalBlockNum, (loc).partitionReferenceNum, (offset))
-
 /* computes tag checksum */
 u8 udf_tag_checksum(const struct tag *t);
 
@@ -124,7 +122,7 @@ extern int udf_ioctl(struct inode *, struct file *, unsigned int,
 		     unsigned long);
 
 /* inode.c */
-extern struct inode *udf_iget(struct super_block *, struct kernel_lb_addr);
+extern struct inode *udf_iget(struct super_block *, struct kernel_lb_addr *);
 extern int udf_sync_inode(struct inode *);
 extern void udf_expand_file_adinicb(struct inode *, int, int *);
 extern struct buffer_head *udf_expand_dir_adinicb(struct inode *, int *, int *);
@@ -140,9 +138,9 @@ extern int udf_extend_file(struct inode *, struct extent_position *,
 extern int8_t inode_bmap(struct inode *, sector_t, struct extent_position *,
 			 struct kernel_lb_addr *, uint32_t *, sector_t *);
 extern int8_t udf_add_aext(struct inode *, struct extent_position *,
-			   struct kernel_lb_addr, uint32_t, int);
+			   struct kernel_lb_addr *, uint32_t, int);
 extern int8_t udf_write_aext(struct inode *, struct extent_position *,
-			     struct kernel_lb_addr, uint32_t, int);
+			     struct kernel_lb_addr *, uint32_t, int);
 extern int8_t udf_delete_aext(struct inode *, struct extent_position,
 			      struct kernel_lb_addr, uint32_t);
 extern int8_t udf_next_aext(struct inode *, struct extent_position *,
@@ -160,7 +158,7 @@ extern struct genericFormat *udf_get_extendedattr(struct inode *, uint32_t,
 extern struct buffer_head *udf_read_tagged(struct super_block *, uint32_t,
 					   uint32_t, uint16_t *);
 extern struct buffer_head *udf_read_ptagged(struct super_block *,
-					    struct kernel_lb_addr, uint32_t,
+					    struct kernel_lb_addr *, uint32_t,
 					    uint16_t *);
 extern void udf_update_tag(char *, int);
 extern void udf_new_tag(char *, uint16_t, uint16_t, uint16_t, uint32_t, int);
@@ -182,6 +180,14 @@ extern uint32_t udf_get_pblock_meta25(struct super_block *, uint32_t, uint16_t,
 					  uint32_t);
 extern int udf_relocate_blocks(struct super_block *, long, long *);
 
+static inline uint32_t
+udf_get_lb_pblock(struct super_block *sb, struct kernel_lb_addr *loc,
+		  uint32_t offset)
+{
+	return udf_get_pblock(sb, loc->logicalBlockNum,
+			loc->partitionReferenceNum, offset);
+}
+
 /* unicode.c */
 extern int udf_get_filename(struct super_block *, uint8_t *, uint8_t *, int);
 extern int udf_put_filename(struct super_block *, const uint8_t *, uint8_t *,
@@ -200,7 +206,7 @@ extern void udf_truncate_extents(struct inode *);
 
 /* balloc.c */
 extern void udf_free_blocks(struct super_block *, struct inode *,
-			    struct kernel_lb_addr, uint32_t, uint32_t);
+			    struct kernel_lb_addr *, uint32_t, uint32_t);
 extern int udf_prealloc_blocks(struct super_block *, struct inode *, uint16_t,
 			       uint32_t, uint32_t);
 extern int udf_new_block(struct super_block *, struct inode *, uint16_t,
-- 
1.5.4.3

