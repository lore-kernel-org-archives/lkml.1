Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbXLWBvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbXLWBvx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbXLWBvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:51:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923AbXLWBvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:51:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=kzO6d7C8lVIXfWUuH2pPkswnw2CZEySgRFlbJgZGYNmeJ/WDRtEowziNJMn+BY4YX6pbk1vbWyCTBWLLcd+y3ZHW4fd5T3UmvxlbB8Zh1Ysqw4gooevf+JeWxHzRtT5vPb1yCmuefd7zsj68v5VZoGEwVuKWorAeypleCBdaySM=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 06/24] udf: convert UDF_SB_PARTITION macro to udf_sb_partition function
Date: Sun, 23 Dec 2007 02:50:56 +0100
Message-Id: <1198374674-12128-7-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
---
 fs/udf/balloc.c |   10 ++++----
 fs/udf/super.c  |   68 +++++++++++++++++++++++++++---------------------------
 fs/udf/udf_sb.h |    6 ++++-
 3 files changed, 44 insertions(+), 40 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index b5d09ae..e313d80 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -88,7 +88,7 @@ static int read_block_bitmap(struct super_block *sb,
 	kernel_lb_addr loc;
 
 	loc.logicalBlockNum = bitmap->s_extPosition;
-	loc.partitionReferenceNum = UDF_SB_PARTITION(sb);
+	loc.partitionReferenceNum = udf_sb_partition(sb);
 
 	bh = udf_tread(sb, udf_get_lb_pblock(sb, loc, block));
 	if (!bh) {
@@ -189,8 +189,8 @@ do_more:
 			if (inode)
 				DQUOT_FREE_BLOCK(inode, 1);
 			if (UDF_SB_LVIDBH(sb)) {
-				UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)] =
-					cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)]) + 1);
+				UDF_SB_LVID(sb)->freeSpaceTable[udf_sb_partition(sb)] =
+					cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[udf_sb_partition(sb)]) + 1);
 			}
 		}
 	}
@@ -433,8 +433,8 @@ static void udf_table_free_blocks(struct super_block *sb,
 	if (inode)
 		DQUOT_FREE_BLOCK(inode, count);
 	if (UDF_SB_LVIDBH(sb)) {
-		UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)] =
-			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)]) + count);
+		UDF_SB_LVID(sb)->freeSpaceTable[udf_sb_partition(sb)] =
+			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[udf_sb_partition(sb)]) + count);
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
 	}
 
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 10eaba7..452e6f6 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -840,7 +840,7 @@ static int udf_find_fileset(struct super_block *sb,
 			  fileset->logicalBlockNum,
 			  fileset->partitionReferenceNum);
 
-		UDF_SB_PARTITION(sb) = fileset->partitionReferenceNum;
+		udf_sb(sb)->s_partition = fileset->partitionReferenceNum;
 		udf_load_fileset(sb, bh, root);
 		brelse(bh);
 		return 0;
@@ -1566,7 +1566,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 		goto error_out;
 	}
 
-	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_READ_ONLY) {
+	if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_READ_ONLY) {
 		printk(KERN_NOTICE "UDF-fs: Partition marked readonly; forcing readonly mount\n");
 		sb->s_flags |= MS_RDONLY;
 	}
@@ -1612,17 +1612,17 @@ error_out:
 	if (UDF_SB_VAT(sb))
 		iput(UDF_SB_VAT(sb));
 	if (udf_sb_num_parts(sb)) {
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE)
-			iput(udf_sb_partmaps(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE)
-			iput(udf_sb_partmaps(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP)
-			UDF_SB_FREE_BITMAP(sb, UDF_SB_PARTITION(sb), s_uspace);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP)
-			UDF_SB_FREE_BITMAP(sb, UDF_SB_PARTITION(sb), s_fspace);
-		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) == UDF_SPARABLE_MAP15) {
+		if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_UNALLOC_TABLE)
+			iput(udf_sb_partmaps(sb)[udf_sb_partition(sb)].s_uspace.s_table);
+		if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_FREED_TABLE)
+			iput(udf_sb_partmaps(sb)[udf_sb_partition(sb)].s_fspace.s_table);
+		if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP)
+			UDF_SB_FREE_BITMAP(sb, udf_sb_partition(sb), s_uspace);
+		if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_FREED_BITMAP)
+			UDF_SB_FREE_BITMAP(sb, udf_sb_partition(sb), s_fspace);
+		if (UDF_SB_PARTTYPE(sb, udf_sb_partition(sb)) == UDF_SPARABLE_MAP15) {
 			for (i = 0; i < 4; i++)
-				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[i]);
+				brelse(UDF_SB_TYPESPAR(sb, udf_sb_partition(sb)).s_spar_map[i]);
 		}
 	}
 #ifdef CONFIG_UDF_NLS
@@ -1687,17 +1687,17 @@ static void udf_put_super(struct super_block *sb)
 	if (UDF_SB_VAT(sb))
 		iput(UDF_SB_VAT(sb));
 	if (udf_sb_num_parts(sb)) {
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE)
-			iput(udf_sb_partmaps(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE)
-			iput(udf_sb_partmaps(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP)
-			UDF_SB_FREE_BITMAP(sb, UDF_SB_PARTITION(sb), s_uspace);
-		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP)
-			UDF_SB_FREE_BITMAP(sb, UDF_SB_PARTITION(sb), s_fspace);
-		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) == UDF_SPARABLE_MAP15) {
+		if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_UNALLOC_TABLE)
+			iput(udf_sb_partmaps(sb)[udf_sb_partition(sb)].s_uspace.s_table);
+		if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_FREED_TABLE)
+			iput(udf_sb_partmaps(sb)[udf_sb_partition(sb)].s_fspace.s_table);
+		if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP)
+			UDF_SB_FREE_BITMAP(sb, udf_sb_partition(sb), s_uspace);
+		if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_FREED_BITMAP)
+			UDF_SB_FREE_BITMAP(sb, udf_sb_partition(sb), s_fspace);
+		if (UDF_SB_PARTTYPE(sb, udf_sb_partition(sb)) == UDF_SPARABLE_MAP15) {
 			for (i = 0; i < 4; i++)
-				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[i]);
+				brelse(UDF_SB_TYPESPAR(sb, udf_sb_partition(sb)).s_spar_map[i]);
 		}
 	}
 #ifdef CONFIG_UDF_NLS
@@ -1731,7 +1731,7 @@ static int udf_statfs(struct dentry *dentry, struct kstatfs *buf)
 
 	buf->f_type = UDF_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
-	buf->f_blocks = UDF_SB_PARTLEN(sb, UDF_SB_PARTITION(sb));
+	buf->f_blocks = UDF_SB_PARTLEN(sb, udf_sb_partition(sb));
 	buf->f_bfree = udf_count_free(sb);
 	buf->f_bavail = buf->f_bfree;
 	buf->f_files = (UDF_SB_LVIDBH(sb) ?
@@ -1764,7 +1764,7 @@ static unsigned int udf_count_free_bitmap(struct super_block *sb, struct udf_bit
 	lock_kernel();
 
 	loc.logicalBlockNum = bitmap->s_extPosition;
-	loc.partitionReferenceNum = UDF_SB_PARTITION(sb);
+	loc.partitionReferenceNum = udf_sb_partition(sb);
 	bh = udf_read_ptagged(sb, loc, 0, &ident);
 
 	if (!bh) {
@@ -1838,8 +1838,8 @@ static unsigned int udf_count_free(struct super_block *sb)
 	unsigned int accum = 0;
 
 	if (UDF_SB_LVIDBH(sb)) {
-		if (le32_to_cpu(UDF_SB_LVID(sb)->numOfPartitions) > UDF_SB_PARTITION(sb)) {
-			accum = le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[UDF_SB_PARTITION(sb)]);
+		if (le32_to_cpu(UDF_SB_LVID(sb)->numOfPartitions) > udf_sb_partition(sb)) {
+			accum = le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[udf_sb_partition(sb)]);
 			if (accum == 0xFFFFFFFF)
 				accum = 0;
 		}
@@ -1848,24 +1848,24 @@ static unsigned int udf_count_free(struct super_block *sb)
 	if (accum)
 		return accum;
 
-	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP) {
+	if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		accum += udf_count_free_bitmap(sb,
-					       udf_sb_partmaps(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_bitmap);
+					       udf_sb_partmaps(sb)[udf_sb_partition(sb)].s_uspace.s_bitmap);
 	}
-	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP) {
+	if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_FREED_BITMAP) {
 		accum += udf_count_free_bitmap(sb,
-					       udf_sb_partmaps(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_bitmap);
+					       udf_sb_partmaps(sb)[udf_sb_partition(sb)].s_fspace.s_bitmap);
 	}
 	if (accum)
 		return accum;
 
-	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE) {
+	if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_UNALLOC_TABLE) {
 		accum += udf_count_free_table(sb,
-					      udf_sb_partmaps(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
+					      udf_sb_partmaps(sb)[udf_sb_partition(sb)].s_uspace.s_table);
 	}
-	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE) {
+	if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_FREED_TABLE) {
 		accum += udf_count_free_table(sb,
-					      udf_sb_partmaps(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
+					      udf_sb_partmaps(sb)[udf_sb_partition(sb)].s_fspace.s_table);
 	}
 
 	return accum;
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 983565d..6eb9ef4 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -65,6 +65,11 @@ static inline __u16 udf_sb_num_parts(struct super_block *sb)
 	return udf_sb(sb)->s_partitions;
 }
 
+static inline __u16 udf_sb_partition(struct super_block *sb)
+{
+	return udf_sb(sb)->s_partition;
+}
+
 #define UDF_SB_ALLOC_PARTMAPS(X,Y)\
 {\
 	udf_sb(X)->s_partmaps = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
@@ -129,7 +134,6 @@ static inline __u16 udf_sb_num_parts(struct super_block *sb)
 #define UDF_SB_BITMAP(X,Y,Z,I)			( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_block_bitmap[I] )
 #define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_nr_groups )
 
-#define UDF_SB_PARTITION(X)			( udf_sb(X)->s_partition )
 #define UDF_SB_SESSION(X)			( udf_sb(X)->s_session )
 #define UDF_SB_ANCHOR(X)			( udf_sb(X)->s_anchor )
 #define UDF_SB_LASTBLOCK(X)			( udf_sb(X)->s_lastblock )
-- 
1.5.3.4

