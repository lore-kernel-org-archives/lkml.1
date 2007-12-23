Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbXLWB5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbXLWB5c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757676AbXLWB45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:56:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351AbXLWB4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:56:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=kieGJpLi/HYVhB7cieba83YXNSYrt9njyqbY+m1e2+vV245YfAVQXVg5fHmkwhqEbKbQEqRsG57HBbMKtRDThede0Ps8EqG/K+kc9lggE9vGB9hk0klJdLcijxjhch5txdixvdr1QsIO07BI4w7jDzL+i5HWL3CVoIpSsnaCVyM=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 21/24] udf: remove some UDF_SB_* macros
Date: Sun, 23 Dec 2007 02:51:11 +0100
Message-Id: <1198374674-12128-22-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove macros:
- UDF_SB_PARTTYPE
- UDF_SB_PARTROOT
- UDF_SB_PARTLEN
- UDF_SB_PARTVSN
- UDF_SB_PARTNUM
- UDF_SB_TYPESPAR
- UDF_SB_TYPEVIRT
- UDF_SB_PARTFUNC
- UDF_SB_PARTFLAGS
and replace all uses

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
---
 fs/udf/balloc.c    |   76 +++++++++++----------
 fs/udf/inode.c     |    2 +-
 fs/udf/partition.c |   49 ++++++++------
 fs/udf/super.c     |  191 ++++++++++++++++++++++++++++------------------------
 fs/udf/udf_sb.h    |   16 ++---
 5 files changed, 179 insertions(+), 155 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 23aae18..4fe8635 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -155,10 +155,10 @@ static void udf_bitmap_free_blocks(struct super_block *sb,
 
 	mutex_lock(&sbi->s_alloc_mutex);
 	if (bloc.logicalBlockNum < 0 ||
-	    (bloc.logicalBlockNum + count) > UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum)) {
+	    (bloc.logicalBlockNum + count) > udf_sb_partmap(sb, bloc.partitionReferenceNum)->s_partition_len) {
 		udf_debug("%d < %d || %d + %d > %d\n",
 			  bloc.logicalBlockNum, 0, bloc.logicalBlockNum, count,
-			  UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum));
+			  udf_sb_partmap(sb, bloc.partitionReferenceNum)->s_partition_len);
 		goto error_return;
 	}
 
@@ -219,16 +219,18 @@ static int udf_bitmap_prealloc_blocks(struct super_block *sb,
 	int bit, block, block_group, group_start;
 	int nr_groups, bitmap_nr;
 	struct buffer_head *bh;
+	__u32 part_len;
 
 	mutex_lock(&sbi->s_alloc_mutex);
-	if (first_block < 0 || first_block >= UDF_SB_PARTLEN(sb, partition))
+	part_len = udf_sb_partmap(sb, partition)->s_partition_len;
+	if (first_block < 0 || first_block >= part_len)
 		goto out;
 
-	if (first_block + block_count > UDF_SB_PARTLEN(sb, partition))
-		block_count = UDF_SB_PARTLEN(sb, partition) - first_block;
+	if (first_block + block_count > part_len)
+		block_count = part_len - first_block;
 
 repeat:
-	nr_groups = (UDF_SB_PARTLEN(sb, partition) +
+	nr_groups = (udf_sb_partmap(sb, partition)->s_partition_len +
 		     (sizeof(struct spaceBitmapDesc) << 3) +
 		     (sb->s_blocksize * 8) - 1) / (sb->s_blocksize * 8);
 	block = first_block + (sizeof(struct spaceBitmapDesc) << 3);
@@ -287,7 +289,7 @@ static int udf_bitmap_new_block(struct super_block *sb,
 	mutex_lock(&sbi->s_alloc_mutex);
 
 repeat:
-	if (goal < 0 || goal >= UDF_SB_PARTLEN(sb, partition))
+	if (goal < 0 || goal >= udf_sb_partmap(sb, partition)->s_partition_len)
 		goal = 0;
 
 	nr_groups = bitmap->s_nr_groups;
@@ -421,10 +423,10 @@ static void udf_table_free_blocks(struct super_block *sb,
 
 	mutex_lock(&sbi->s_alloc_mutex);
 	if (bloc.logicalBlockNum < 0 ||
-	    (bloc.logicalBlockNum + count) > UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum)) {
+	    (bloc.logicalBlockNum + count) > udf_sb_partmap(sb, bloc.partitionReferenceNum)->s_partition_len) {
 		udf_debug("%d < %d || %d + %d > %d\n",
 			  bloc.logicalBlockNum, 0, bloc.logicalBlockNum, count,
-			  UDF_SB_PARTLEN(sb, bloc.partitionReferenceNum));
+			  udf_sb_partmap(sb, bloc.partitionReferenceNum)->s_partition_len);
 		goto error_return;
 	}
 
@@ -627,7 +629,7 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
 	struct extent_position epos;
 	int8_t etype = -1;
 
-	if (first_block < 0 || first_block >= UDF_SB_PARTLEN(sb, partition))
+	if (first_block < 0 || first_block >= udf_sb_partmap(sb, partition)->s_partition_len)
 		return 0;
 
 	if (UDF_I_ALLOCTYPE(table) == ICBTAG_FLAG_AD_SHORT)
@@ -703,7 +705,7 @@ static int udf_table_new_block(struct super_block *sb,
 		return newblock;
 
 	mutex_lock(&sbi->s_alloc_mutex);
-	if (goal < 0 || goal >= UDF_SB_PARTLEN(sb, partition))
+	if (goal < 0 || goal >= udf_sb_partmap(sb, partition)->s_partition_len)
 		goal = 0;
 
 	/* We search for the closest matching block to goal. If we find a exact hit,
@@ -789,22 +791,23 @@ inline void udf_free_blocks(struct super_block *sb,
 			    uint32_t count)
 {
 	uint16_t partition = bloc.partitionReferenceNum;
+	struct udf_part_map *map = udf_sb_partmap(sb, partition);
 
-	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP) {
+	if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		return udf_bitmap_free_blocks(sb, inode,
-					      udf_sb_partmaps(sb)[partition].s_uspace.s_bitmap,
+					      map->s_uspace.s_bitmap,
 					      bloc, offset, count);
-	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_TABLE) {
+	} else if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_TABLE) {
 		return udf_table_free_blocks(sb, inode,
-					     udf_sb_partmaps(sb)[partition].s_uspace.s_table,
+					     map->s_uspace.s_table,
 					     bloc, offset, count);
-	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP) {
+	} else if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP) {
 		return udf_bitmap_free_blocks(sb, inode,
-					      udf_sb_partmaps(sb)[partition].s_fspace.s_bitmap,
+					      map->s_fspace.s_bitmap,
 					      bloc, offset, count);
-	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE) {
+	} else if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE) {
 		return udf_table_free_blocks(sb, inode,
-					     udf_sb_partmaps(sb)[partition].s_fspace.s_table,
+					     map->s_fspace.s_table,
 					     bloc, offset, count);
 	} else {
 		return;
@@ -816,21 +819,23 @@ inline int udf_prealloc_blocks(struct super_block *sb,
 			       uint16_t partition, uint32_t first_block,
 			       uint32_t block_count)
 {
-	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP) {
+	struct udf_part_map *map = udf_sb_partmap(sb, partition);
+
+	if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		return udf_bitmap_prealloc_blocks(sb, inode,
-						  udf_sb_partmaps(sb)[partition].s_uspace.s_bitmap,
+						  map->s_uspace.s_bitmap,
 						  partition, first_block, block_count);
-	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_TABLE) {
+	} else if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_TABLE) {
 		return udf_table_prealloc_blocks(sb, inode,
-						 udf_sb_partmaps(sb)[partition].s_uspace.s_table,
+						 map->s_uspace.s_table,
 						 partition, first_block, block_count);
-	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP) {
+	} else if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP) {
 		return udf_bitmap_prealloc_blocks(sb, inode,
-						  udf_sb_partmaps(sb)[partition].s_fspace.s_bitmap,
+						  map->s_fspace.s_bitmap,
 						  partition, first_block, block_count);
-	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE) {
+	} else if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE) {
 		return udf_table_prealloc_blocks(sb, inode,
-						 udf_sb_partmaps(sb)[partition].s_fspace.s_table,
+						 map->s_fspace.s_table,
 						 partition, first_block, block_count);
 	} else {
 		return 0;
@@ -842,23 +847,24 @@ inline int udf_new_block(struct super_block *sb,
 			 uint16_t partition, uint32_t goal, int *err)
 {
 	int ret;
+	struct udf_part_map *map = udf_sb_partmap(sb, partition);
 
-	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP) {
+	if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		ret = udf_bitmap_new_block(sb, inode,
-					   udf_sb_partmaps(sb)[partition].s_uspace.s_bitmap,
+					   map->s_uspace.s_bitmap,
 					   partition, goal, err);
 		return ret;
-	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_TABLE) {
+	} else if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_TABLE) {
 		return udf_table_new_block(sb, inode,
-					   udf_sb_partmaps(sb)[partition].s_uspace.s_table,
+					   map->s_uspace.s_table,
 					   partition, goal, err);
-	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP) {
+	} else if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP) {
 		return udf_bitmap_new_block(sb, inode,
-					    udf_sb_partmaps(sb)[partition].s_fspace.s_bitmap,
+					    map->s_fspace.s_bitmap,
 					    partition, goal, err);
-	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE) {
+	} else if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE) {
 		return udf_table_new_block(sb, inode,
-					   udf_sb_partmaps(sb)[partition].s_fspace.s_table,
+					   map->s_fspace.s_table,
 					   partition, goal, err);
 	} else {
 		*err = -EIO;
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 1cdb381..8aa0fc6 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1585,7 +1585,7 @@ struct inode *udf_iget(struct super_block *sb, kernel_lb_addr ino)
 	if (is_bad_inode(inode))
 		goto out_iput;
 
-	if (ino.logicalBlockNum >= UDF_SB_PARTLEN(sb, ino.partitionReferenceNum)) {
+	if (ino.logicalBlockNum >= udf_sb_partmap(sb, ino.partitionReferenceNum)->s_partition_len) {
 		udf_debug("block=%d, partition=%d out of range\n",
 			  ino.logicalBlockNum, ino.partitionReferenceNum);
 		make_bad_inode(inode);
diff --git a/fs/udf/partition.c b/fs/udf/partition.c
index 99640a6..4959d53 100644
--- a/fs/udf/partition.c
+++ b/fs/udf/partition.c
@@ -31,15 +31,17 @@
 inline uint32_t udf_get_pblock(struct super_block *sb, uint32_t block,
 			       uint16_t partition, uint32_t offset)
 {
+	struct udf_part_map *map;
 	if (partition >= udf_sb_num_parts(sb)) {
 		udf_debug("block=%d, partition=%d, offset=%d: invalid partition\n",
 			  block, partition, offset);
 		return 0xFFFFFFFF;
 	}
-	if (UDF_SB_PARTFUNC(sb, partition))
-		return UDF_SB_PARTFUNC(sb, partition)(sb, block, partition, offset);
+	map = udf_sb_partmap(sb, partition);
+	if (map->s_partition_func)
+		return map->s_partition_func(sb, block, partition, offset);
 	else
-		return UDF_SB_PARTROOT(sb, partition) + block + offset;
+		return map->s_partition_root + block + offset;
 }
 
 uint32_t udf_get_pblock_virt15(struct super_block *sb, uint32_t block,
@@ -49,12 +51,14 @@ uint32_t udf_get_pblock_virt15(struct super_block *sb, uint32_t block,
 	uint32_t newblock;
 	uint32_t index;
 	uint32_t loc;
+	struct udf_part_map *map;
 
-	index = (sb->s_blocksize - UDF_SB_TYPEVIRT(sb,partition).s_start_offset) / sizeof(uint32_t);
+	map = udf_sb_partmap(sb, partition);
+	index = (sb->s_blocksize - map->s_type_specific.s_virtual.s_start_offset) / sizeof(uint32_t);
 
-	if (block > UDF_SB_TYPEVIRT(sb,partition).s_num_entries) {
+	if (block > map->s_type_specific.s_virtual.s_num_entries) {
 		udf_debug("Trying to access block beyond end of VAT (%d max %d)\n",
-			  block, UDF_SB_TYPEVIRT(sb,partition).s_num_entries);
+			  block, map->s_type_specific.s_virtual.s_num_entries);
 		return 0xFFFFFFFF;
 	}
 
@@ -64,7 +68,7 @@ uint32_t udf_get_pblock_virt15(struct super_block *sb, uint32_t block,
 		index = block % (sb->s_blocksize / sizeof(uint32_t));
 	} else {
 		newblock = 0;
-		index = UDF_SB_TYPEVIRT(sb,partition).s_start_offset / sizeof(uint32_t) + block;
+		index = map->s_type_specific.s_virtual.s_start_offset / sizeof(uint32_t) + block;
 	}
 
 	loc = udf_block_map(udf_sb_vat_inode(sb), newblock);
@@ -100,11 +104,15 @@ uint32_t udf_get_pblock_spar15(struct super_block * sb, uint32_t block,
 {
 	int i;
 	struct sparingTable *st = NULL;
-	uint32_t packet = (block + offset) & ~(UDF_SB_TYPESPAR(sb,partition).s_packet_len - 1);
+	struct udf_part_map *map;
+	uint32_t packet;
+
+	map = udf_sb_partmap(sb, partition);
+	packet = (block + offset) & ~(map->s_type_specific.s_sparing.s_packet_len - 1);
 
 	for (i = 0; i < 4; i++) {
-		if (UDF_SB_TYPESPAR(sb,partition).s_spar_map[i] != NULL) {
-			st = (struct sparingTable *)UDF_SB_TYPESPAR(sb,partition).s_spar_map[i]->b_data;
+		if (map->s_type_specific.s_sparing.s_spar_map[i] != NULL) {
+			st = (struct sparingTable *)map->s_type_specific.s_sparing.s_spar_map[i]->b_data;
 			break;
 		}
 	}
@@ -115,14 +123,14 @@ uint32_t udf_get_pblock_spar15(struct super_block * sb, uint32_t block,
 				break;
 			} else if (le32_to_cpu(st->mapEntry[i].origLocation) == packet) {
 				return le32_to_cpu(st->mapEntry[i].mappedLocation) +
-					((block + offset) & (UDF_SB_TYPESPAR(sb,partition).s_packet_len - 1));
+					((block + offset) & (map->s_type_specific.s_sparing.s_packet_len - 1));
 			} else if (le32_to_cpu(st->mapEntry[i].origLocation) > packet) {
 				break;
 			}
 		}
 	}
 
-	return UDF_SB_PARTROOT(sb,partition) + block + offset;
+	return map->s_partition_root + block + offset;
 }
 
 int udf_relocate_blocks(struct super_block *sb, long old_block, long *new_block)
@@ -134,13 +142,14 @@ int udf_relocate_blocks(struct super_block *sb, long old_block, long *new_block)
 	int i, j, k, l;
 
 	for (i = 0; i < udf_sb_num_parts(sb); i++) {
-		if (old_block > UDF_SB_PARTROOT(sb,i) &&
-		    old_block < UDF_SB_PARTROOT(sb,i) + UDF_SB_PARTLEN(sb,i)) {
-			sdata = &UDF_SB_TYPESPAR(sb,i);
-			packet = (old_block - UDF_SB_PARTROOT(sb,i)) & ~(sdata->s_packet_len - 1);
+		struct udf_part_map *map = udf_sb_partmap(sb, i);
+		if (old_block > map->s_partition_root &&
+		    old_block < map->s_partition_root + map->s_partition_len) {
+			sdata = &map->s_type_specific.s_sparing;
+			packet = (old_block - map->s_partition_root) & ~(sdata->s_packet_len - 1);
 
 			for (j = 0; j < 4; j++) {
-				if (UDF_SB_TYPESPAR(sb,i).s_spar_map[j] != NULL) {
+				if (map->s_type_specific.s_sparing.s_spar_map[j] != NULL) {
 					st = (struct sparingTable *)sdata->s_spar_map[j]->b_data;
 					break;
 				}
@@ -160,11 +169,11 @@ int udf_relocate_blocks(struct super_block *sb, long old_block, long *new_block)
 						}
 					}
 					*new_block = le32_to_cpu(st->mapEntry[k].mappedLocation) +
-						((old_block - UDF_SB_PARTROOT(sb,i)) & (sdata->s_packet_len - 1));
+						((old_block - map->s_partition_root) & (sdata->s_packet_len - 1));
 					return 0;
 				} else if (le32_to_cpu(st->mapEntry[k].origLocation) == packet) {
 					*new_block = le32_to_cpu(st->mapEntry[k].mappedLocation) +
-						((old_block - UDF_SB_PARTROOT(sb,i)) & (sdata->s_packet_len - 1));
+						((old_block - map->s_partition_root) & (sdata->s_packet_len - 1));
 					return 0;
 				} else if (le32_to_cpu(st->mapEntry[k].origLocation) > packet) {
 					break;
@@ -185,7 +194,7 @@ int udf_relocate_blocks(struct super_block *sb, long old_block, long *new_block)
 						}
 					}
 					*new_block = le32_to_cpu(st->mapEntry[k].mappedLocation) +
-						((old_block - UDF_SB_PARTROOT(sb,i)) & (sdata->s_packet_len - 1));
+						((old_block - map->s_partition_root) & (sdata->s_packet_len - 1));
 					return 0;
 				}
 			}
diff --git a/fs/udf/super.c b/fs/udf/super.c
index f8c5794..33ccf66 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -795,8 +795,9 @@ static int udf_find_fileset(struct super_block *sb,
 		      fileset->logicalBlockNum == 0xFFFFFFFF &&
 		      fileset->partitionReferenceNum == 0xFFFF);
 		     newfileset.partitionReferenceNum--) {
-			lastblock = UDF_SB_PARTLEN(sb,
-					newfileset.partitionReferenceNum);
+			lastblock = udf_sb_partmap(sb,
+					newfileset.partitionReferenceNum)->
+						s_partition_len;
 			newfileset.logicalBlockNum = 0;
 
 			do {
@@ -904,23 +905,25 @@ static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 {
 	struct partitionDesc *p;
 	int i;
+	struct udf_part_map *map;
 
 	p = (struct partitionDesc *)bh->b_data;
 
 	for (i = 0; i < udf_sb_num_parts(sb); i++) {
+		map = udf_sb_partmap(sb, i);
 		udf_debug("Searching map: (%d == %d)\n",
-			  udf_sb_partmaps(sb)[i].s_partition_num, le16_to_cpu(p->partitionNumber));
-		if (udf_sb_partmaps(sb)[i].s_partition_num == le16_to_cpu(p->partitionNumber)) {
-			UDF_SB_PARTLEN(sb, i) = le32_to_cpu(p->partitionLength); /* blocks */
-			UDF_SB_PARTROOT(sb, i) = le32_to_cpu(p->partitionStartingLocation);
+			  map->s_partition_num, le16_to_cpu(p->partitionNumber));
+		if (map->s_partition_num == le16_to_cpu(p->partitionNumber)) {
+			map->s_partition_len = le32_to_cpu(p->partitionLength); /* blocks */
+			map->s_partition_root = le32_to_cpu(p->partitionStartingLocation);
 			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_READ_ONLY)
-				UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_READ_ONLY;
+				map->s_partition_flags |= UDF_PART_FLAG_READ_ONLY;
 			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_WRITE_ONCE)
-				UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_WRITE_ONCE;
+				map->s_partition_flags |= UDF_PART_FLAG_WRITE_ONCE;
 			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_REWRITABLE)
-				UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_REWRITABLE;
+				map->s_partition_flags |= UDF_PART_FLAG_REWRITABLE;
 			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_OVERWRITABLE)
-				UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_OVERWRITABLE;
+				map->s_partition_flags |= UDF_PART_FLAG_OVERWRITABLE;
 
 			if (!strcmp(p->partitionContents.ident,
 				    PD_PARTITION_CONTENTS_NSR02) ||
@@ -935,26 +938,26 @@ static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 						.partitionReferenceNum = i,
 					};
 
-					udf_sb_partmaps(sb)[i].s_uspace.s_table =
+					map->s_uspace.s_table =
 						udf_iget(sb, loc);
-					if (!udf_sb_partmaps(sb)[i].s_uspace.s_table) {
+					if (!map->s_uspace.s_table) {
 						udf_debug("cannot load unallocSpaceTable (part %d)\n", i);
 						return 1;
 					}
-					UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_UNALLOC_TABLE;
+					map->s_partition_flags |= UDF_PART_FLAG_UNALLOC_TABLE;
 					udf_debug("unallocSpaceTable (part %d) @ %ld\n",
-						  i, udf_sb_partmaps(sb)[i].s_uspace.s_table->i_ino);
+						  i, map->s_uspace.s_table->i_ino);
 				}
 				if (phd->unallocSpaceBitmap.extLength) {
 					UDF_SB_ALLOC_BITMAP(sb, i, s_uspace);
-					if (udf_sb_partmaps(sb)[i].s_uspace.s_bitmap != NULL) {
-						udf_sb_partmaps(sb)[i].s_uspace.s_bitmap->s_extLength =
+					if (map->s_uspace.s_bitmap != NULL) {
+						map->s_uspace.s_bitmap->s_extLength =
 							le32_to_cpu(phd->unallocSpaceBitmap.extLength);
-						udf_sb_partmaps(sb)[i].s_uspace.s_bitmap->s_extPosition =
+						map->s_uspace.s_bitmap->s_extPosition =
 							le32_to_cpu(phd->unallocSpaceBitmap.extPosition);
-						UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_UNALLOC_BITMAP;
+						map->s_partition_flags |= UDF_PART_FLAG_UNALLOC_BITMAP;
 						udf_debug("unallocSpaceBitmap (part %d) @ %d\n",
-							  i, udf_sb_partmaps(sb)[i].s_uspace.s_bitmap->s_extPosition);
+							  i, map->s_uspace.s_bitmap->s_extPosition);
 					}
 				}
 				if (phd->partitionIntegrityTable.extLength)
@@ -965,26 +968,26 @@ static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 						.partitionReferenceNum = i,
 					};
 
-					udf_sb_partmaps(sb)[i].s_fspace.s_table =
+					map->s_fspace.s_table =
 						udf_iget(sb, loc);
-					if (!udf_sb_partmaps(sb)[i].s_fspace.s_table) {
+					if (!map->s_fspace.s_table) {
 						udf_debug("cannot load freedSpaceTable (part %d)\n", i);
 						return 1;
 					}
-					UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_FREED_TABLE;
+					map->s_partition_flags |= UDF_PART_FLAG_FREED_TABLE;
 					udf_debug("freedSpaceTable (part %d) @ %ld\n",
-						  i, udf_sb_partmaps(sb)[i].s_fspace.s_table->i_ino);
+						  i, map->s_fspace.s_table->i_ino);
 				}
 				if (phd->freedSpaceBitmap.extLength) {
 					UDF_SB_ALLOC_BITMAP(sb, i, s_fspace);
-					if (udf_sb_partmaps(sb)[i].s_fspace.s_bitmap != NULL) {
-						udf_sb_partmaps(sb)[i].s_fspace.s_bitmap->s_extLength =
+					if (map->s_fspace.s_bitmap != NULL) {
+						map->s_fspace.s_bitmap->s_extLength =
 							le32_to_cpu(phd->freedSpaceBitmap.extLength);
-						udf_sb_partmaps(sb)[i].s_fspace.s_bitmap->s_extPosition =
+						map->s_fspace.s_bitmap->s_extPosition =
 							le32_to_cpu(phd->freedSpaceBitmap.extPosition);
-						UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_FREED_BITMAP;
+						map->s_partition_flags |= UDF_PART_FLAG_FREED_BITMAP;
 						udf_debug("freedSpaceBitmap (part %d) @ %d\n",
-							  i, udf_sb_partmaps(sb)[i].s_fspace.s_bitmap->s_extPosition);
+							  i, map->s_fspace.s_bitmap->s_extPosition);
 					}
 				}
 			}
@@ -998,8 +1001,9 @@ static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 		udf_debug("Partition (%d:%d type %x) starts at physical %d, "
 			  "block length %d\n",
 			  le16_to_cpu(p->partitionNumber), i,
-			  UDF_SB_PARTTYPE(sb, i), UDF_SB_PARTROOT(sb, i),
-			  UDF_SB_PARTLEN(sb, i));
+			  map->s_partition_type,
+			  map->s_partition_root,
+			  map->s_partition_len);
 	}
 	return 0;
 }
@@ -1020,22 +1024,23 @@ static int udf_load_logicalvol(struct super_block *sb, struct buffer_head *bh,
 	for (i = 0, offset = 0;
 	     i < udf_sb_num_parts(sb) && offset < le32_to_cpu(lvd->mapTableLength);
 	     i++, offset += ((struct genericPartitionMap *)&(lvd->partitionMaps[offset]))->partitionMapLength) {
+	     	struct udf_part_map *map = udf_sb_partmap(sb, i);
 		type = ((struct genericPartitionMap *)&(lvd->partitionMaps[offset]))->partitionMapType;
 		if (type == 1) {
 			struct genericPartitionMap1 *gpm1 = (struct genericPartitionMap1 *)&(lvd->partitionMaps[offset]);
-			UDF_SB_PARTTYPE(sb, i) = UDF_TYPE1_MAP15;
-			UDF_SB_PARTVSN(sb, i) = le16_to_cpu(gpm1->volSeqNum);
-			UDF_SB_PARTNUM(sb, i) = le16_to_cpu(gpm1->partitionNum);
-			UDF_SB_PARTFUNC(sb, i) = NULL;
+			map->s_partition_type = UDF_TYPE1_MAP15;
+			map->s_volumeseqnum = le16_to_cpu(gpm1->volSeqNum);
+			map->s_partition_num = le16_to_cpu(gpm1->partitionNum);
+			map->s_partition_func = NULL;
 		} else if (type == 2) {
 			struct udfPartitionMap2 *upm2 = (struct udfPartitionMap2 *)&(lvd->partitionMaps[offset]);
 			if (!strncmp(upm2->partIdent.ident, UDF_ID_VIRTUAL, strlen(UDF_ID_VIRTUAL))) {
 				if (le16_to_cpu(((__le16 *)upm2->partIdent.identSuffix)[0]) == 0x0150) {
-					UDF_SB_PARTTYPE(sb, i) = UDF_VIRTUAL_MAP15;
-					UDF_SB_PARTFUNC(sb, i) = udf_get_pblock_virt15;
+					map->s_partition_type = UDF_VIRTUAL_MAP15;
+					map->s_partition_func = udf_get_pblock_virt15;
 				} else if (le16_to_cpu(((__le16 *)upm2->partIdent.identSuffix)[0]) == 0x0200) {
-					UDF_SB_PARTTYPE(sb, i) = UDF_VIRTUAL_MAP20;
-					UDF_SB_PARTFUNC(sb, i) = udf_get_pblock_virt20;
+					map->s_partition_type = UDF_VIRTUAL_MAP20;
+					map->s_partition_func = udf_get_pblock_virt20;
 				}
 			} else if (!strncmp(upm2->partIdent.ident, UDF_ID_SPARABLE, strlen(UDF_ID_SPARABLE))) {
 				uint32_t loc;
@@ -1043,33 +1048,33 @@ static int udf_load_logicalvol(struct super_block *sb, struct buffer_head *bh,
 				struct sparingTable *st;
 				struct sparablePartitionMap *spm = (struct sparablePartitionMap *)&(lvd->partitionMaps[offset]);
 
-				UDF_SB_PARTTYPE(sb, i) = UDF_SPARABLE_MAP15;
-				UDF_SB_TYPESPAR(sb, i).s_packet_len = le16_to_cpu(spm->packetLength);
+				map->s_partition_type = UDF_SPARABLE_MAP15;
+				map->s_type_specific.s_sparing.s_packet_len = le16_to_cpu(spm->packetLength);
 				for (j = 0; j < spm->numSparingTables; j++) {
 					loc = le32_to_cpu(spm->locSparingTable[j]);
-					UDF_SB_TYPESPAR(sb, i).s_spar_map[j] =
+					map->s_type_specific.s_sparing.s_spar_map[j] =
 						udf_read_tagged(sb, loc, loc, &ident);
-					if (UDF_SB_TYPESPAR(sb, i).s_spar_map[j] != NULL) {
-						st = (struct sparingTable *)UDF_SB_TYPESPAR(sb, i).s_spar_map[j]->b_data;
+					if (map->s_type_specific.s_sparing.s_spar_map[j] != NULL) {
+						st = (struct sparingTable *)map->s_type_specific.s_sparing.s_spar_map[j]->b_data;
 						if (ident != 0 ||
 						    strncmp(st->sparingIdent.ident, UDF_ID_SPARING, strlen(UDF_ID_SPARING))) {
-							brelse(UDF_SB_TYPESPAR(sb, i).s_spar_map[j]);
-							UDF_SB_TYPESPAR(sb, i).s_spar_map[j] = NULL;
+							brelse(map->s_type_specific.s_sparing.s_spar_map[j]);
+							map->s_type_specific.s_sparing.s_spar_map[j] = NULL;
 						}
 					}
 				}
-				UDF_SB_PARTFUNC(sb, i) = udf_get_pblock_spar15;
+				map->s_partition_func = udf_get_pblock_spar15;
 			} else {
 				udf_debug("Unknown ident: %s\n",
 					  upm2->partIdent.ident);
 				continue;
 			}
-			UDF_SB_PARTVSN(sb, i) = le16_to_cpu(upm2->volSeqNum);
-			UDF_SB_PARTNUM(sb, i) = le16_to_cpu(upm2->partitionNum);
+			map->s_volumeseqnum = le16_to_cpu(upm2->volSeqNum);
+			map->s_partition_num = le16_to_cpu(upm2->partitionNum);
 		}
 		udf_debug("Partition (%d:%d) type %d on volume %d\n",
-			  i, UDF_SB_PARTNUM(sb, i), type,
-			  UDF_SB_PARTVSN(sb, i));
+			  i, map->s_partition_num, type,
+			  map->s_volumeseqnum);
 	}
 
 	if (fileset) {
@@ -1323,7 +1328,8 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 
 	for (i = 0; i < udf_sb_num_parts(sb); i++) {
 		kernel_lb_addr uninitialized_var(ino);
-		switch (UDF_SB_PARTTYPE(sb, i)) {
+		struct udf_part_map *map = udf_sb_partmap(sb, i);
+		switch (map->s_partition_type) {
 		case UDF_VIRTUAL_MAP15:
 		case UDF_VIRTUAL_MAP20:
 			if (!udf_sb_last_block(sb)) {
@@ -1338,11 +1344,12 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 			}
 
 			for (j = 0; j < udf_sb_num_parts(sb); j++) {
+				struct udf_part_map *map2 = udf_sb_partmap(sb, j);
 				if (j != i &&
-				    UDF_SB_PARTVSN(sb, i) == UDF_SB_PARTVSN(sb, j) &&
-				    UDF_SB_PARTNUM(sb, i) == UDF_SB_PARTNUM(sb, j)) {
+				    map->s_volumeseqnum == map2->s_volumeseqnum &&
+				    map->s_partition_num == map2->s_partition_num) {
 					ino.partitionReferenceNum = j;
-					ino.logicalBlockNum = udf_sb_last_block(sb) - UDF_SB_PARTROOT(sb, j);
+					ino.logicalBlockNum = udf_sb_last_block(sb) - map2->s_partition_root;
 					break;
 				}
 			}
@@ -1354,12 +1361,12 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 			if (!udf_sb_vat_inode(sb))
 				return 1;
 
-			if (UDF_SB_PARTTYPE(sb, i) == UDF_VIRTUAL_MAP15) {
-				UDF_SB_TYPEVIRT(sb, i).s_start_offset =
+			if (map->s_partition_type == UDF_VIRTUAL_MAP15) {
+				map->s_type_specific.s_virtual.s_start_offset =
 					udf_ext0_offset(udf_sb_vat_inode(sb));
-				UDF_SB_TYPEVIRT(sb, i).s_num_entries =
+				map->s_type_specific.s_virtual.s_num_entries =
 					(udf_sb_vat_inode(sb)->i_size - 36) >> 2;
-			} else if (UDF_SB_PARTTYPE(sb, i) == UDF_VIRTUAL_MAP20) {
+			} else if (map->s_partition_type == UDF_VIRTUAL_MAP20) {
 				struct buffer_head *bh = NULL;
 				uint32_t pos;
 
@@ -1367,16 +1374,18 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 				bh = sb_bread(sb, pos);
 				if (!bh)
 					return 1;
-				UDF_SB_TYPEVIRT(sb, i).s_start_offset =
+				map->s_type_specific.s_virtual.s_start_offset =
 					le16_to_cpu(((struct virtualAllocationTable20 *)bh->b_data +
 						     udf_ext0_offset(udf_sb_vat_inode(sb)))->lengthHeader) +
 					udf_ext0_offset(udf_sb_vat_inode(sb));
-				UDF_SB_TYPEVIRT(sb, i).s_num_entries = (udf_sb_vat_inode(sb)->i_size -
-									UDF_SB_TYPEVIRT(sb, i).s_start_offset) >> 2;
+				map->s_type_specific.s_virtual.s_num_entries = (udf_sb_vat_inode(sb)->i_size -
+									map->s_type_specific.s_virtual.s_start_offset) >> 2;
 				brelse(bh);
 			}
-			UDF_SB_PARTROOT(sb, i) = udf_get_pblock(sb, 0, i, 0);
-			UDF_SB_PARTLEN(sb, i) = UDF_SB_PARTLEN(sb, ino.partitionReferenceNum);
+			map->s_partition_root = udf_get_pblock(sb, 0, i, 0);
+			map->s_partition_len =
+				udf_sb_partmap(sb, ino.partitionReferenceNum)->
+								s_partition_len;
 		}
 	}
 	return 0;
@@ -1573,7 +1582,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 		goto error_out;
 	}
 
-	if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_READ_ONLY) {
+	if (udf_sb_partmap(sb, udf_sb_partition(sb))->s_partition_flags & UDF_PART_FLAG_READ_ONLY) {
 		printk(KERN_NOTICE "UDF-fs: Partition marked readonly; forcing readonly mount\n");
 		sb->s_flags |= MS_RDONLY;
 	}
@@ -1619,17 +1628,18 @@ error_out:
 	if (udf_sb_vat_inode(sb))
 		iput(udf_sb_vat_inode(sb));
 	if (udf_sb_num_parts(sb)) {
-		if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_UNALLOC_TABLE)
-			iput(udf_sb_partmaps(sb)[udf_sb_partition(sb)].s_uspace.s_table);
-		if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_FREED_TABLE)
-			iput(udf_sb_partmaps(sb)[udf_sb_partition(sb)].s_fspace.s_table);
-		if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP)
+		struct udf_part_map *map = udf_sb_partmap(sb, udf_sb_partition(sb));
+		if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_TABLE)
+			iput(map->s_uspace.s_table);
+		if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE)
+			iput(map->s_fspace.s_table);
+		if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP)
 			UDF_SB_FREE_BITMAP(sb, udf_sb_partition(sb), s_uspace);
-		if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_FREED_BITMAP)
+		if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP)
 			UDF_SB_FREE_BITMAP(sb, udf_sb_partition(sb), s_fspace);
-		if (UDF_SB_PARTTYPE(sb, udf_sb_partition(sb)) == UDF_SPARABLE_MAP15) {
+		if (map->s_partition_type == UDF_SPARABLE_MAP15) {
 			for (i = 0; i < 4; i++)
-				brelse(UDF_SB_TYPESPAR(sb, udf_sb_partition(sb)).s_spar_map[i]);
+				brelse(map->s_type_specific.s_sparing.s_spar_map[i]);
 		}
 	}
 #ifdef CONFIG_UDF_NLS
@@ -1694,17 +1704,18 @@ static void udf_put_super(struct super_block *sb)
 	if (udf_sb_vat_inode(sb))
 		iput(udf_sb_vat_inode(sb));
 	if (udf_sb_num_parts(sb)) {
-		if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_UNALLOC_TABLE)
-			iput(udf_sb_partmaps(sb)[udf_sb_partition(sb)].s_uspace.s_table);
-		if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_FREED_TABLE)
-			iput(udf_sb_partmaps(sb)[udf_sb_partition(sb)].s_fspace.s_table);
-		if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP)
+		struct udf_part_map *map = udf_sb_partmap(sb, udf_sb_partition(sb));
+		if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_TABLE)
+			iput(map->s_uspace.s_table);
+		if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE)
+			iput(map->s_fspace.s_table);
+		if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP)
 			UDF_SB_FREE_BITMAP(sb, udf_sb_partition(sb), s_uspace);
-		if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_FREED_BITMAP)
+		if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP)
 			UDF_SB_FREE_BITMAP(sb, udf_sb_partition(sb), s_fspace);
-		if (UDF_SB_PARTTYPE(sb, udf_sb_partition(sb)) == UDF_SPARABLE_MAP15) {
+		if (map->s_partition_type == UDF_SPARABLE_MAP15) {
 			for (i = 0; i < 4; i++)
-				brelse(UDF_SB_TYPESPAR(sb, udf_sb_partition(sb)).s_spar_map[i]);
+				brelse(map->s_type_specific.s_sparing.s_spar_map[i]);
 		}
 	}
 #ifdef CONFIG_UDF_NLS
@@ -1738,7 +1749,7 @@ static int udf_statfs(struct dentry *dentry, struct kstatfs *buf)
 
 	buf->f_type = UDF_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
-	buf->f_blocks = UDF_SB_PARTLEN(sb, udf_sb_partition(sb));
+	buf->f_blocks = udf_sb_partmap(sb, udf_sb_partition(sb))->s_partition_len;
 	buf->f_bfree = udf_count_free(sb);
 	buf->f_bavail = buf->f_bfree;
 	buf->f_files = (udf_sb_lvid_bh(sb) ?
@@ -1843,6 +1854,7 @@ static unsigned int udf_count_free_table(struct super_block *sb, struct inode *t
 static unsigned int udf_count_free(struct super_block *sb)
 {
 	unsigned int accum = 0;
+	struct udf_part_map *map;
 
 	if (udf_sb_lvid_bh(sb)) {
 		if (le32_to_cpu(udf_sb_lvid(sb)->numOfPartitions) > udf_sb_partition(sb)) {
@@ -1855,24 +1867,25 @@ static unsigned int udf_count_free(struct super_block *sb)
 	if (accum)
 		return accum;
 
-	if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP) {
+	map = udf_sb_partmap(sb, udf_sb_partition(sb));
+	if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		accum += udf_count_free_bitmap(sb,
-					       udf_sb_partmaps(sb)[udf_sb_partition(sb)].s_uspace.s_bitmap);
+					       map->s_uspace.s_bitmap);
 	}
-	if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_FREED_BITMAP) {
+	if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP) {
 		accum += udf_count_free_bitmap(sb,
-					       udf_sb_partmaps(sb)[udf_sb_partition(sb)].s_fspace.s_bitmap);
+					       map->s_fspace.s_bitmap);
 	}
 	if (accum)
 		return accum;
 
-	if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_UNALLOC_TABLE) {
+	if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_TABLE) {
 		accum += udf_count_free_table(sb,
-					      udf_sb_partmaps(sb)[udf_sb_partition(sb)].s_uspace.s_table);
+					      map->s_uspace.s_table);
 	}
-	if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_FREED_TABLE) {
+	if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE) {
 		accum += udf_count_free_table(sb,
-					      udf_sb_partmaps(sb)[udf_sb_partition(sb)].s_fspace.s_table);
+					      map->s_fspace.s_table);
 	}
 
 	return accum;
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index aee5942..a5805c5 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -48,6 +48,11 @@ static inline struct udf_part_map *udf_sb_partmaps(struct super_block *sb)
 	return udf_sb(sb)->s_partmaps;
 }
 
+static inline struct udf_part_map *udf_sb_partmap(struct super_block *sb, __u32 index)
+{
+	return udf_sb_partmaps(sb) + index;
+}
+
 static inline int __must_check udf_sb_alloc_partition_maps(struct super_block *sb, __u32 count)
 {
 	struct udf_sb_info *info = udf_sb(sb);
@@ -146,7 +151,7 @@ static inline void udf_update_revision(struct super_block *sb, __u16 revision)
 
 #define UDF_SB_ALLOC_BITMAP(X,Y,Z)\
 {\
-	int nr_groups = ((UDF_SB_PARTLEN((X),(Y)) + (sizeof(struct spaceBitmapDesc) << 3) +\
+	int nr_groups = ((udf_sb_partmap((X),(Y))->s_partition_len + (sizeof(struct spaceBitmapDesc) << 3) +\
 		((X)->s_blocksize * 8) - 1) / ((X)->s_blocksize * 8));\
 	int size = sizeof(struct udf_bitmap) + (sizeof(struct buffer_head *) * nr_groups);\
 	if (size <= PAGE_SIZE)\
@@ -182,15 +187,6 @@ static inline void udf_update_revision(struct super_block *sb, __u16 revision)
 #define UDF_SET_FLAG(X,Y)			( udf_sb(X)->s_flags |= ( 1 << (Y) ) )
 #define UDF_CLEAR_FLAG(X,Y)			( udf_sb(X)->s_flags &= ~( 1 << (Y) ) )
 
-#define UDF_SB_PARTTYPE(X,Y)			( udf_sb_partmaps(X)[(Y)].s_partition_type )
-#define UDF_SB_PARTROOT(X,Y)			( udf_sb_partmaps(X)[(Y)].s_partition_root )
-#define UDF_SB_PARTLEN(X,Y)			( udf_sb_partmaps(X)[(Y)].s_partition_len )
-#define UDF_SB_PARTVSN(X,Y)			( udf_sb_partmaps(X)[(Y)].s_volumeseqnum )
-#define UDF_SB_PARTNUM(X,Y)			( udf_sb_partmaps(X)[(Y)].s_partition_num )
-#define UDF_SB_TYPESPAR(X,Y)			( udf_sb_partmaps(X)[(Y)].s_type_specific.s_sparing )
-#define UDF_SB_TYPEVIRT(X,Y)			( udf_sb_partmaps(X)[(Y)].s_type_specific.s_virtual )
-#define UDF_SB_PARTFUNC(X,Y)			( udf_sb_partmaps(X)[(Y)].s_partition_func )
-#define UDF_SB_PARTFLAGS(X,Y)			( udf_sb_partmaps(X)[(Y)].s_partition_flags )
 #define UDF_SB_BITMAP(X,Y,Z,I)			( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_block_bitmap[I] )
 #define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_nr_groups )
 
-- 
1.5.3.4

