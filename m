Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbXLWB4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbXLWB4D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:56:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757542AbXLWBzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:55:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757523AbXLWBzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:55:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=SYYkbvxLEr/W+pJ2BTcuQrQJEdAByz3E6zkHktQvePn1JwR5NgHeHvLwkyW1q6BEpS94aYeNbOyz7Y1W2zMqAg25wDKLX8Cn4ES6tVmvVn5L+Or8JRCXSG8sfbOUlN/eynDc4lCgfq405Eh7YPatNC0KG4+vUKuKNcayjxmLOPg=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 17/24] udf: convert UDF_SB_VAT macro to udf_sb_vat_inode function
Date: Sun, 23 Dec 2007 02:51:07 +0100
Message-Id: <1198374674-12128-18-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- change UDF_SB_VAT macro to udf_sb_vat_inode inline function
- rename s_vat field to s_vat_inode

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
---
 fs/udf/partition.c        |    6 +++---
 fs/udf/super.c            |   24 ++++++++++++------------
 fs/udf/udf_sb.h           |    6 +++++-
 include/linux/udf_fs_sb.h |    2 +-
 4 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/fs/udf/partition.c b/fs/udf/partition.c
index c904ddf..99640a6 100644
--- a/fs/udf/partition.c
+++ b/fs/udf/partition.c
@@ -67,7 +67,7 @@ uint32_t udf_get_pblock_virt15(struct super_block *sb, uint32_t block,
 		index = UDF_SB_TYPEVIRT(sb,partition).s_start_offset / sizeof(uint32_t) + block;
 	}
 
-	loc = udf_block_map(UDF_SB_VAT(sb), newblock);
+	loc = udf_block_map(udf_sb_vat_inode(sb), newblock);
 
 	if (!(bh = sb_bread(sb, loc))) {
 		udf_debug("get_pblock(UDF_VIRTUAL_MAP:%p,%d,%d) VAT: %d[%d]\n",
@@ -79,13 +79,13 @@ uint32_t udf_get_pblock_virt15(struct super_block *sb, uint32_t block,
 
 	brelse(bh);
 
-	if (UDF_I_LOCATION(UDF_SB_VAT(sb)).partitionReferenceNum == partition) {
+	if (UDF_I_LOCATION(udf_sb_vat_inode(sb)).partitionReferenceNum == partition) {
 		udf_debug("recursive call to udf_get_pblock!\n");
 		return 0xFFFFFFFF;
 	}
 
 	return udf_get_pblock(sb, loc,
-			      UDF_I_LOCATION(UDF_SB_VAT(sb)).partitionReferenceNum,
+			      UDF_I_LOCATION(udf_sb_vat_inode(sb)).partitionReferenceNum,
 			      offset);
 }
 
diff --git a/fs/udf/super.c b/fs/udf/super.c
index c520543..dcab9e8 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1343,28 +1343,28 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 			if (j == udf_sb_num_parts(sb))
 				return 1;
 
-			UDF_SB_VAT(sb) = udf_iget(sb, ino);
-			if (!UDF_SB_VAT(sb))
+			udf_sb(sb)->s_vat_inode = udf_iget(sb, ino);
+			if (!udf_sb_vat_inode(sb))
 				return 1;
 
 			if (UDF_SB_PARTTYPE(sb, i) == UDF_VIRTUAL_MAP15) {
 				UDF_SB_TYPEVIRT(sb, i).s_start_offset =
-					udf_ext0_offset(UDF_SB_VAT(sb));
+					udf_ext0_offset(udf_sb_vat_inode(sb));
 				UDF_SB_TYPEVIRT(sb, i).s_num_entries =
-					(UDF_SB_VAT(sb)->i_size - 36) >> 2;
+					(udf_sb_vat_inode(sb)->i_size - 36) >> 2;
 			} else if (UDF_SB_PARTTYPE(sb, i) == UDF_VIRTUAL_MAP20) {
 				struct buffer_head *bh = NULL;
 				uint32_t pos;
 
-				pos = udf_block_map(UDF_SB_VAT(sb), 0);
+				pos = udf_block_map(udf_sb_vat_inode(sb), 0);
 				bh = sb_bread(sb, pos);
 				if (!bh)
 					return 1;
 				UDF_SB_TYPEVIRT(sb, i).s_start_offset =
 					le16_to_cpu(((struct virtualAllocationTable20 *)bh->b_data +
-						     udf_ext0_offset(UDF_SB_VAT(sb)))->lengthHeader) +
-					udf_ext0_offset(UDF_SB_VAT(sb));
-				UDF_SB_TYPEVIRT(sb, i).s_num_entries = (UDF_SB_VAT(sb)->i_size -
+						     udf_ext0_offset(udf_sb_vat_inode(sb)))->lengthHeader) +
+					udf_ext0_offset(udf_sb_vat_inode(sb));
+				UDF_SB_TYPEVIRT(sb, i).s_num_entries = (udf_sb_vat_inode(sb)->i_size -
 									UDF_SB_TYPEVIRT(sb, i).s_start_offset) >> 2;
 				brelse(bh);
 			}
@@ -1609,8 +1609,8 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	return 0;
 
 error_out:
-	if (UDF_SB_VAT(sb))
-		iput(UDF_SB_VAT(sb));
+	if (udf_sb_vat_inode(sb))
+		iput(udf_sb_vat_inode(sb));
 	if (udf_sb_num_parts(sb)) {
 		if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_UNALLOC_TABLE)
 			iput(udf_sb_partmaps(sb)[udf_sb_partition(sb)].s_uspace.s_table);
@@ -1684,8 +1684,8 @@ static void udf_put_super(struct super_block *sb)
 {
 	int i;
 
-	if (UDF_SB_VAT(sb))
-		iput(UDF_SB_VAT(sb));
+	if (udf_sb_vat_inode(sb))
+		iput(udf_sb_vat_inode(sb));
 	if (udf_sb_num_parts(sb)) {
 		if (UDF_SB_PARTFLAGS(sb, udf_sb_partition(sb)) & UDF_PART_FLAG_UNALLOC_TABLE)
 			iput(udf_sb_partmaps(sb)[udf_sb_partition(sb)].s_uspace.s_table);
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 53d77fc..fa09d50 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -118,6 +118,11 @@ static inline __u16 udf_sb_revision(struct super_block *sb)
 	return udf_sb(sb)->s_udfrev;
 }
 
+static inline struct inode *udf_sb_vat_inode(struct super_block *sb)
+{
+	return udf_sb(sb)->s_vat_inode;
+}
+
 #define UDF_SB_ALLOC_PARTMAPS(X,Y)\
 {\
 	udf_sb(X)->s_partmaps = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
@@ -182,6 +187,5 @@ static inline __u16 udf_sb_revision(struct super_block *sb)
 #define UDF_SB_BITMAP(X,Y,Z,I)			( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_block_bitmap[I] )
 #define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_nr_groups )
 
-#define UDF_SB_VAT(X)				( udf_sb(X)->s_vat )
 
 #endif /* __LINUX_UDF_SB_H */
diff --git a/include/linux/udf_fs_sb.h b/include/linux/udf_fs_sb.h
index dd16deb..9bc4735 100644
--- a/include/linux/udf_fs_sb.h
+++ b/include/linux/udf_fs_sb.h
@@ -109,7 +109,7 @@ struct udf_sb_info
 	struct nls_table	*s_nls_map;
 
 	/* VAT inode */
-	struct inode		*s_vat;
+	struct inode		*s_vat_inode;
 
 	struct mutex		s_alloc_mutex;
 };
-- 
1.5.3.4

