Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbXLWB6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbXLWB6H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:58:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758301AbXLWB5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:57:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758275AbXLWB5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:57:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=KI2nVZsLBsr+ou/O0h+hNVJhloia9bRd6vTxZRwl8pLJkLbrbP3ELJ+PPz8jsEst23QhDF9ZHFs2YNsaQHF2kg78usy9iHKzTEUor42RXDsNWTLK8Ag/Uwpics+P/29Xg2b1WplZBe+XY2XWnVrvEmUJxHXf4XTv4C9BBrpjh9s=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 23/24] udf: convert UDF_SB_FREE_BITMAP macro to udf_sb_free_bitmap function
Date: Sun, 23 Dec 2007 02:51:13 +0100
Message-Id: <1198374674-12128-24-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

additionally fix sparse warnings:
fs/udf/super.c:1636:4: warning: symbol 'i' shadows an earlier one
fs/udf/super.c:1469:6: originally declared here
fs/udf/super.c:1638:4: warning: symbol 'i' shadows an earlier one
fs/udf/super.c:1469:6: originally declared here
fs/udf/super.c:1712:4: warning: symbol 'i' shadows an earlier one
fs/udf/super.c:1701:6: originally declared here
fs/udf/super.c:1714:4: warning: symbol 'i' shadows an earlier one
fs/udf/super.c:1701:6: originally declared here

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
---
 fs/udf/super.c  |    8 ++++----
 fs/udf/udf_sb.h |   31 ++++++++++++++-----------------
 2 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 1afea58..f6c911b 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1634,9 +1634,9 @@ error_out:
 		if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE)
 			iput(map->s_fspace.s_table);
 		if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP)
-			UDF_SB_FREE_BITMAP(sb, udf_sb_partition(sb), s_uspace);
+			udf_sb_free_bitmap(map->s_uspace.s_bitmap);
 		if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP)
-			UDF_SB_FREE_BITMAP(sb, udf_sb_partition(sb), s_fspace);
+			udf_sb_free_bitmap(map->s_fspace.s_bitmap);
 		if (map->s_partition_type == UDF_SPARABLE_MAP15) {
 			for (i = 0; i < 4; i++)
 				brelse(map->s_type_specific.s_sparing.s_spar_map[i]);
@@ -1710,9 +1710,9 @@ static void udf_put_super(struct super_block *sb)
 		if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE)
 			iput(map->s_fspace.s_table);
 		if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP)
-			UDF_SB_FREE_BITMAP(sb, udf_sb_partition(sb), s_uspace);
+			udf_sb_free_bitmap(map->s_uspace.s_bitmap);
 		if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP)
-			UDF_SB_FREE_BITMAP(sb, udf_sb_partition(sb), s_fspace);
+			udf_sb_free_bitmap(map->s_fspace.s_bitmap);
 		if (map->s_partition_type == UDF_SPARABLE_MAP15) {
 			for (i = 0; i < 4; i++)
 				brelse(map->s_type_specific.s_sparing.s_spar_map[i]);
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 4cf91f2..8fc2be9 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -171,27 +171,24 @@ static inline struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, __u
 	return bitmap;
 }
 
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
-		kfree(udf_sb_partmaps(X)[Y].Z.s_bitmap);\
-	else\
-		vfree(udf_sb_partmaps(X)[Y].Z.s_bitmap);\
+static inline void udf_sb_free_bitmap(struct udf_bitmap *bitmap)
+{
+	int i;
+	int nr_groups = bitmap->s_nr_groups;
+	int size = sizeof(struct udf_bitmap) + (sizeof(struct buffer_head *) * nr_groups);
+
+	for (i = 0; i < nr_groups; i++) {
+		if (bitmap->s_block_bitmap[i])
+			brelse(bitmap->s_block_bitmap[i]);
+	}
+	if (size <= PAGE_SIZE)
+		kfree(bitmap);
+	else
+		vfree(bitmap);
 }
 
 #define UDF_QUERY_FLAG(X,Y)			( udf_sb(X)->s_flags & ( 1 << (Y) ) )
 #define UDF_SET_FLAG(X,Y)			( udf_sb(X)->s_flags |= ( 1 << (Y) ) )
 #define UDF_CLEAR_FLAG(X,Y)			( udf_sb(X)->s_flags &= ~( 1 << (Y) ) )
 
-#define UDF_SB_BITMAP(X,Y,Z,I)			( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_block_bitmap[I] )
-#define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_nr_groups )
-
-
 #endif /* __LINUX_UDF_SB_H */
-- 
1.5.3.4

