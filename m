Return-Path: <linux-kernel-owner+w=401wt.eu-S1757765AbXLWB4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765AbXLWB4b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757532AbXLWBz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:55:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757938AbXLWBz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:55:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=kJzaDJ+ThMwDZ1SABtXJHLegWGAqVOAWJ6N4906d7g5bT0M9U/o19n6lESzfNJJfu/owZbRYuYsTvQJrjNzSSm+pwZmTwYdFEydeQhb46ku6RM623k7skmqSwM7tZH2ZB65SnaAKzGr/+pkjcdWPeevGOUsHGzotBVcdiN90vNM=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 18/24] udf: convert UDF_SB_ALLOC_PARTMAPS macro to udf_sb_alloc_partition_maps function
Date: Sun, 23 Dec 2007 02:51:08 +0100
Message-Id: <1198374674-12128-19-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- change UDF_SB_ALLOC_PARTMAPS macro to udf_sb_alloc_partition_maps inline function
- convert kmalloc + memset to kzalloc
- check if kzalloc failed (partially)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
---
 fs/udf/super.c  |    6 ++++--
 fs/udf/udf_sb.h |   27 +++++++++++++++------------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index dcab9e8..4aef612 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1013,7 +1013,9 @@ static int udf_load_logicalvol(struct super_block *sb, struct buffer_head *bh,
 
 	lvd = (struct logicalVolDesc *)bh->b_data;
 
-	UDF_SB_ALLOC_PARTMAPS(sb, le32_to_cpu(lvd->numPartitionMaps));
+	i = udf_sb_alloc_partition_maps(sb, le32_to_cpu(lvd->numPartitionMaps));
+	if (i != 0)
+		return i;
 
 	for (i = 0, offset = 0;
 	     i < udf_sb_num_parts(sb) && offset < le32_to_cpu(lvd->mapTableLength);
@@ -1214,7 +1216,7 @@ static int udf_process_sequence(struct super_block *sb, long block,
 			if (i == VDS_POS_PRIMARY_VOL_DESC) {
 				udf_load_pvoldesc(sb, bh);
 			} else if (i == VDS_POS_LOGICAL_VOL_DESC) {
-				udf_load_logicalvol(sb, bh, fileset);
+				udf_load_logicalvol(sb, bh, fileset); /* TODO: check return value */
 			} else if (i == VDS_POS_PARTITION_DESC) {
 				struct buffer_head *bh2 = NULL;
 				if (udf_load_partdesc(sb, bh)) {
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index fa09d50..565c9ef 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -1,6 +1,8 @@
 #ifndef __LINUX_UDF_SB_H
 #define __LINUX_UDF_SB_H
 
+#include <linux/errno.h>
+
 /* Since UDF 2.01 is ISO 13346 based... */
 #define UDF_SUPER_MAGIC			0x15013346
 
@@ -46,6 +48,19 @@ static inline struct udf_part_map *udf_sb_partmaps(struct super_block *sb)
 	return udf_sb(sb)->s_partmaps;
 }
 
+static inline int __must_check udf_sb_alloc_partition_maps(struct super_block *sb, __u32 count)
+{
+	struct udf_sb_info *info = udf_sb(sb);
+	info->s_partmaps = kzalloc(sizeof(struct udf_part_map) * count, GFP_KERNEL);
+	if (info->s_partmaps != NULL)
+		info->s_partitions = count;
+	else {
+		info->s_partitions = 0;
+		udf_error(sb, __FUNCTION__, "Unable to allocate space for %d partition maps", count);
+	}
+	return info->s_partmaps != NULL ? 0 : -ENOMEM;
+}
+
 static inline void udf_sb_free(struct super_block *sb)
 {
 	struct udf_sb_info *sb_info = udf_sb(sb);
@@ -123,18 +138,6 @@ static inline struct inode *udf_sb_vat_inode(struct super_block *sb)
 	return udf_sb(sb)->s_vat_inode;
 }
 
-#define UDF_SB_ALLOC_PARTMAPS(X,Y)\
-{\
-	udf_sb(X)->s_partmaps = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
-	if (udf_sb_partmaps(X) != NULL) {\
-		udf_sb(X)->s_partitions = Y;\
-		memset(udf_sb_partmaps(X), 0x00, sizeof(struct udf_part_map) * Y);\
-	} else {\
-		udf_sb(X)->s_partitions = 0;\
-		udf_error(X, __FUNCTION__, "Unable to allocate space for %d partition maps", Y);\
-	}\
-}
-
 #define UDF_SB_ALLOC_BITMAP(X,Y,Z)\
 {\
 	int nr_groups = ((UDF_SB_PARTLEN((X),(Y)) + (sizeof(struct spaceBitmapDesc) << 3) +\
-- 
1.5.3.4

