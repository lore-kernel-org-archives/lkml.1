Return-Path: <linux-kernel-owner+w=401wt.eu-S1758414AbXLWB5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414AbXLWB5r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757763AbXLWB5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:57:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbXLWB5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:57:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=oRbnzn5SLAkWyThXzOLoPRQ2BDNWvYRsdfpkqLvPcAPEgBksES+w+SHDUv7AK1tCg4CB0gHzj37JmirQ41t08fu5iYf+/pc/2LFu7VozptD8PtQkxbgArw4kEEnoCHQaaMI6GLjpupunm1TBo4HdjJIPrKIuixfCFORBdlZt7gM=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 22/24] udf: convert UDF_SB_ALLOC_BITMAP macro to udf_sb_alloc_bitmap function
Date: Sun, 23 Dec 2007 02:51:12 +0100
Message-Id: <1198374674-12128-23-git-send-email-marcin.slusarz@gmail.com>
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
 fs/udf/super.c  |    4 ++--
 fs/udf/udf_sb.h |   37 ++++++++++++++++++++-----------------
 2 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 33ccf66..1afea58 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -949,7 +949,7 @@ static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 						  i, map->s_uspace.s_table->i_ino);
 				}
 				if (phd->unallocSpaceBitmap.extLength) {
-					UDF_SB_ALLOC_BITMAP(sb, i, s_uspace);
+					map->s_uspace.s_bitmap = udf_sb_alloc_bitmap(sb, i);
 					if (map->s_uspace.s_bitmap != NULL) {
 						map->s_uspace.s_bitmap->s_extLength =
 							le32_to_cpu(phd->unallocSpaceBitmap.extLength);
@@ -979,7 +979,7 @@ static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 						  i, map->s_fspace.s_table->i_ino);
 				}
 				if (phd->freedSpaceBitmap.extLength) {
-					UDF_SB_ALLOC_BITMAP(sb, i, s_fspace);
+					map->s_fspace.s_bitmap = udf_sb_alloc_bitmap(sb, i);
 					if (map->s_fspace.s_bitmap != NULL) {
 						map->s_fspace.s_bitmap->s_extLength =
 							le32_to_cpu(phd->freedSpaceBitmap.extLength);
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index a5805c5..4cf91f2 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -2,6 +2,7 @@
 #define __LINUX_UDF_SB_H
 
 #include <linux/errno.h>
+#include <linux/vmalloc.h>
 
 /* Since UDF 2.01 is ISO 13346 based... */
 #define UDF_SUPER_MAGIC			0x15013346
@@ -149,23 +150,25 @@ static inline void udf_update_revision(struct super_block *sb, __u16 revision)
 		udf_sb(sb)->s_udfrev = revision;
 }
 
-#define UDF_SB_ALLOC_BITMAP(X,Y,Z)\
-{\
-	int nr_groups = ((udf_sb_partmap((X),(Y))->s_partition_len + (sizeof(struct spaceBitmapDesc) << 3) +\
-		((X)->s_blocksize * 8) - 1) / ((X)->s_blocksize * 8));\
-	int size = sizeof(struct udf_bitmap) + (sizeof(struct buffer_head *) * nr_groups);\
-	if (size <= PAGE_SIZE)\
-		udf_sb_partmaps(X)[(Y)].Z.s_bitmap = kmalloc(size, GFP_KERNEL);\
-	else\
-		udf_sb_partmaps(X)[(Y)].Z.s_bitmap = vmalloc(size);\
-	if (udf_sb_partmaps(X)[(Y)].Z.s_bitmap != NULL) {\
-		memset(udf_sb_partmaps(X)[(Y)].Z.s_bitmap, 0x00, size);\
-		udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_block_bitmap =\
-			(struct buffer_head **)(udf_sb_partmaps(X)[(Y)].Z.s_bitmap + 1);\
-		udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_nr_groups = nr_groups;\
-	} else {\
-		udf_error(X, __FUNCTION__, "Unable to allocate space for bitmap and %d buffer_head pointers", nr_groups);\
-	}\
+static inline struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, __u32 index)
+{
+	struct udf_part_map *map = udf_sb_partmap(sb, index);
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
 }
 
 #define UDF_SB_FREE_BITMAP(X,Y,Z)\
-- 
1.5.3.4

