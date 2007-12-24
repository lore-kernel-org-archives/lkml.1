Return-Path: <linux-kernel-owner+w=401wt.eu-S1758402AbXLXALd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402AbXLXALd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 19:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757823AbXLXAKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 19:10:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:36145 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789AbXLXAKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 19:10:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=A2ynl4+KLgVb8afmDn7hI+w1dV+02cI1AQbixMDHNvnfy3N7/vX3Rs8K3/C9gjQuL4rF2coBerF/STsa1tk63AxOrmwxCunWH0s+gRDxCCkTtPNeiCbXzdTuAzY4XeOqnD7/lpu7gm/hDGy+RMUw8s3K+QqJQRvcXVWT7yrwaHQ=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 5/6] udf: convert some macros to functions
Date: Mon, 24 Dec 2007 01:10:21 +0100
Message-Id: <1198455022-27674-6-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198455022-27674-1-git-send-email-marcin.slusarz@gmail.com>
References: <1198455022-27674-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

convert UDF_SB_ALLOC_BITMAP macro to udf_sb_alloc_bitmap function
convert UDF_SB_FREE_BITMAP macro to udf_sb_free_bitmap function

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
CC: Christoph Hellwig <hch@infradead.org>
---
 fs/udf/super.c  |   49 +++++++++++++++++++++++++++++++++++++++++++------
 fs/udf/udf_sb.h |   38 --------------------------------------
 2 files changed, 43 insertions(+), 44 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index f138309..dc09c2d 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -932,6 +932,27 @@ static void udf_load_fileset(struct super_block *sb, struct buffer_head *bh,
 		  root->logicalBlockNum, root->partitionReferenceNum);
 }
 
+static struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, __u32 index)
+{
+	struct udf_part_map *map = &UDF_SB(sb)->s_partmaps[index];
+	int nr_groups = (map->s_partition_len + (sizeof(struct spaceBitmapDesc) << 3) +
+		(sb->s_blocksize * 8) - 1) / (sb->s_blocksize * 8);
+	int size = sizeof(struct udf_bitmap) + (sizeof(struct buffer_head *) * nr_groups);
+	struct udf_bitmap *bitmap;
+
+	if (size <= PAGE_SIZE)
+		bitmap = kmalloc(size, GFP_KERNEL);
+	else
+		bitmap = vmalloc(size);
+	if (bitmap != NULL) {
+		memset(bitmap, 0x00, size);
+		bitmap->s_block_bitmap = (struct buffer_head **)(bitmap + 1);
+		bitmap->s_nr_groups = nr_groups;
+	} else
+		udf_error(sb, __FUNCTION__, "Unable to allocate space for bitmap and %d buffer_head pointers", nr_groups);
+	return bitmap;
+}
+
 static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 {
 	struct partitionDesc *p;
@@ -982,7 +1003,7 @@ static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 						  i, map->s_uspace.s_table->i_ino);
 				}
 				if (phd->unallocSpaceBitmap.extLength) {
-					UDF_SB_ALLOC_BITMAP(sb, i, s_uspace);
+					map->s_uspace.s_bitmap = udf_sb_alloc_bitmap(sb, i);
 					if (map->s_uspace.s_bitmap != NULL) {
 						map->s_uspace.s_bitmap->s_extLength =
 							le32_to_cpu(phd->unallocSpaceBitmap.extLength);
@@ -1012,7 +1033,7 @@ static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 						  i, map->s_fspace.s_table->i_ino);
 				}
 				if (phd->freedSpaceBitmap.extLength) {
-					UDF_SB_ALLOC_BITMAP(sb, i, s_fspace);
+					map->s_fspace.s_bitmap = udf_sb_alloc_bitmap(sb, i);
 					if (map->s_fspace.s_bitmap != NULL) {
 						map->s_fspace.s_bitmap->s_extLength =
 							le32_to_cpu(phd->freedSpaceBitmap.extLength);
@@ -1501,6 +1522,22 @@ static void udf_close_lvid(struct super_block *sb)
 	}
 }
 
+static void udf_sb_free_bitmap(struct udf_bitmap *bitmap)
+{
+	int i;
+	int nr_groups = bitmap->s_nr_groups;
+	int size = sizeof(struct udf_bitmap) + (sizeof(struct buffer_head *) * nr_groups);
+
+	for (i = 0; i < nr_groups; i++)
+		if (bitmap->s_block_bitmap[i])
+			brelse(bitmap->s_block_bitmap[i]);
+
+	if (size <= PAGE_SIZE)
+		kfree(bitmap);
+	else
+		vfree(bitmap);
+}
+
 /*
  * udf_read_super
  *
@@ -1686,9 +1723,9 @@ error_out:
 		if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE)
 			iput(map->s_fspace.s_table);
 		if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP)
-			UDF_SB_FREE_BITMAP(sb, sbi->s_partition, s_uspace);
+			udf_sb_free_bitmap(map->s_uspace.s_bitmap);
 		if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP)
-			UDF_SB_FREE_BITMAP(sb, sbi->s_partition, s_fspace);
+			udf_sb_free_bitmap(map->s_fspace.s_bitmap);
 		if (map->s_partition_type == UDF_SPARABLE_MAP15)
 			for (i = 0; i < 4; i++)
 				brelse(map->s_type_specific.s_sparing.s_spar_map[i]);
@@ -1764,9 +1801,9 @@ static void udf_put_super(struct super_block *sb)
 		if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE)
 			iput(map->s_fspace.s_table);
 		if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP)
-			UDF_SB_FREE_BITMAP(sb, sbi->s_partition, s_uspace);
+			udf_sb_free_bitmap(map->s_uspace.s_bitmap);
 		if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP)
-			UDF_SB_FREE_BITMAP(sb, sbi->s_partition, s_fspace);
+			udf_sb_free_bitmap(map->s_fspace.s_bitmap);
 		if (map->s_partition_type == UDF_SPARABLE_MAP15)
 			for (i = 0; i < 4; i++)
 				brelse(map->s_type_specific.s_sparing.s_spar_map[i]);
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 4d3bd77..2c05f82 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -43,46 +43,8 @@ static inline struct udf_sb_info *UDF_SB(struct super_block *sb)
 
 struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct udf_sb_info *sbi);
 
-#define UDF_SB_ALLOC_BITMAP(X,Y,Z)\
-{\
-	struct udf_sb_info *sbi = UDF_SB(X);\
-	int nr_groups = ((sbi->s_partmaps[(Y)].s_partition_len + (sizeof(struct spaceBitmapDesc) << 3) +\
-		((X)->s_blocksize * 8) - 1) / ((X)->s_blocksize * 8));\
-	int size = sizeof(struct udf_bitmap) + (sizeof(struct buffer_head *) * nr_groups);\
-	if (size <= PAGE_SIZE)\
-		sbi->s_partmaps[(Y)].Z.s_bitmap = kmalloc(size, GFP_KERNEL);\
-	else\
-		sbi->s_partmaps[(Y)].Z.s_bitmap = vmalloc(size);\
-	if (sbi->s_partmaps[(Y)].Z.s_bitmap != NULL) {\
-		memset(sbi->s_partmaps[(Y)].Z.s_bitmap, 0x00, size);\
-		sbi->s_partmaps[(Y)].Z.s_bitmap->s_block_bitmap =\
-			(struct buffer_head **)(sbi->s_partmaps[(Y)].Z.s_bitmap + 1);\
-		sbi->s_partmaps[(Y)].Z.s_bitmap->s_nr_groups = nr_groups;\
-	} else {\
-		udf_error(X, __FUNCTION__, "Unable to allocate space for bitmap and %d buffer_head pointers", nr_groups);\
-	}\
-}
-
-#define UDF_SB_FREE_BITMAP(X,Y,Z)\
-{\
-	int i;\
-	int nr_groups = UDF_SB_BITMAP_NR_GROUPS(X,Y,Z);\
-	int size = sizeof(struct udf_bitmap) + (sizeof(struct buffer_head *) * nr_groups);\
-	for (i = 0; i < nr_groups; i++) {\
-		if (UDF_SB_BITMAP(X,Y,Z,i))\
-			brelse(UDF_SB_BITMAP(X,Y,Z,i));\
-	}\
-	if (size <= PAGE_SIZE)\
-		kfree(UDF_SB(X)->s_partmaps[Y].Z.s_bitmap);\
-	else\
-		vfree(UDF_SB(X)->s_partmaps[Y].Z.s_bitmap);\
-}
-
 #define UDF_QUERY_FLAG(X,Y)			( UDF_SB(X)->s_flags & ( 1 << (Y) ) )
 #define UDF_SET_FLAG(X,Y)			( UDF_SB(X)->s_flags |= ( 1 << (Y) ) )
 #define UDF_CLEAR_FLAG(X,Y)			( UDF_SB(X)->s_flags &= ~( 1 << (Y) ) )
 
-#define UDF_SB_BITMAP(X,Y,Z,I)			( UDF_SB(X)->s_partmaps[(Y)].Z.s_bitmap->s_block_bitmap[I] )
-#define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( UDF_SB(X)->s_partmaps[(Y)].Z.s_bitmap->s_nr_groups )
-
 #endif /* __LINUX_UDF_SB_H */
-- 
1.5.3.4

