Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbXLWBvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbXLWBvf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbXLWBvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:51:24 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692AbXLWBvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:51:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=v/11w8u0JswBYg6Od4GqM+pUVAeIY4RykuyDsuWZpUx9R1ffG9ar0/KhtrXqYowF6ub/Q1zQVjbjgHJlZKmmHAPq9H2qBRfuRpO8lXy014iIH7PbSjLQSF4Isl9L6RE9n/GNMNTVIx9yOg7OndXDJx8Az/J76P6hdaduaG6hIAw=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 05/24] udf: convert UDF_SB_NUMPARTS macro to udf_sb_num_parts function
Date: Sun, 23 Dec 2007 02:50:55 +0100
Message-Id: <1198374674-12128-6-git-send-email-marcin.slusarz@gmail.com>
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
 fs/udf/partition.c |    6 +++---
 fs/udf/super.c     |   20 ++++++++++----------
 fs/udf/udf_sb.h    |   10 +++++++---
 3 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/fs/udf/partition.c b/fs/udf/partition.c
index aaab24c..c904ddf 100644
--- a/fs/udf/partition.c
+++ b/fs/udf/partition.c
@@ -31,7 +31,7 @@
 inline uint32_t udf_get_pblock(struct super_block *sb, uint32_t block,
 			       uint16_t partition, uint32_t offset)
 {
-	if (partition >= UDF_SB_NUMPARTS(sb)) {
+	if (partition >= udf_sb_num_parts(sb)) {
 		udf_debug("block=%d, partition=%d, offset=%d: invalid partition\n",
 			  block, partition, offset);
 		return 0xFFFFFFFF;
@@ -133,7 +133,7 @@ int udf_relocate_blocks(struct super_block *sb, long old_block, long *new_block)
 	uint32_t packet;
 	int i, j, k, l;
 
-	for (i = 0; i < UDF_SB_NUMPARTS(sb); i++) {
+	for (i = 0; i < udf_sb_num_parts(sb); i++) {
 		if (old_block > UDF_SB_PARTROOT(sb,i) &&
 		    old_block < UDF_SB_PARTROOT(sb,i) + UDF_SB_PARTLEN(sb,i)) {
 			sdata = &UDF_SB_TYPESPAR(sb,i);
@@ -194,7 +194,7 @@ int udf_relocate_blocks(struct super_block *sb, long old_block, long *new_block)
 		} /* if old_block */
 	}
 
-	if (i == UDF_SB_NUMPARTS(sb)) {
+	if (i == udf_sb_num_parts(sb)) {
 		/* outside of partitions */
 		/* for now, fail =) */
 		return 1;
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 42de326..10eaba7 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -790,7 +790,7 @@ static int udf_find_fileset(struct super_block *sb,
 /* --> cvg: FIXME - is it reasonable? */
 		return 1;
 
-		for (newfileset.partitionReferenceNum = UDF_SB_NUMPARTS(sb) - 1;
+		for (newfileset.partitionReferenceNum = udf_sb_num_parts(sb) - 1;
 		     (newfileset.partitionReferenceNum != 0xFFFF &&
 		      fileset->logicalBlockNum == 0xFFFFFFFF &&
 		      fileset->partitionReferenceNum == 0xFFFF);
@@ -907,7 +907,7 @@ static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 
 	p = (struct partitionDesc *)bh->b_data;
 
-	for (i = 0; i < UDF_SB_NUMPARTS(sb); i++) {
+	for (i = 0; i < udf_sb_num_parts(sb); i++) {
 		udf_debug("Searching map: (%d == %d)\n",
 			  udf_sb_partmaps(sb)[i].s_partition_num, le16_to_cpu(p->partitionNumber));
 		if (udf_sb_partmaps(sb)[i].s_partition_num == le16_to_cpu(p->partitionNumber)) {
@@ -991,7 +991,7 @@ static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 			break;
 		}
 	}
-	if (i == UDF_SB_NUMPARTS(sb)) {
+	if (i == udf_sb_num_parts(sb)) {
 		udf_debug("Partition (%d) not found in partition map\n",
 			  le16_to_cpu(p->partitionNumber));
 	} else {
@@ -1016,7 +1016,7 @@ static int udf_load_logicalvol(struct super_block *sb, struct buffer_head *bh,
 	UDF_SB_ALLOC_PARTMAPS(sb, le32_to_cpu(lvd->numPartitionMaps));
 
 	for (i = 0, offset = 0;
-	     i < UDF_SB_NUMPARTS(sb) && offset < le32_to_cpu(lvd->mapTableLength);
+	     i < udf_sb_num_parts(sb) && offset < le32_to_cpu(lvd->mapTableLength);
 	     i++, offset += ((struct genericPartitionMap *)&(lvd->partitionMaps[offset]))->partitionMapLength) {
 		type = ((struct genericPartitionMap *)&(lvd->partitionMaps[offset]))->partitionMapType;
 		if (type == 1) {
@@ -1314,7 +1314,7 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 	} else
 		udf_debug("Using anchor in block %d\n", UDF_SB_ANCHOR(sb)[i]);
 
-	for (i = 0; i < UDF_SB_NUMPARTS(sb); i++) {
+	for (i = 0; i < udf_sb_num_parts(sb); i++) {
 		kernel_lb_addr uninitialized_var(ino);
 		switch (UDF_SB_PARTTYPE(sb, i)) {
 		case UDF_VIRTUAL_MAP15:
@@ -1330,7 +1330,7 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 				return 1;
 			}
 
-			for (j = 0; j < UDF_SB_NUMPARTS(sb); j++) {
+			for (j = 0; j < udf_sb_num_parts(sb); j++) {
 				if (j != i &&
 				    UDF_SB_PARTVSN(sb, i) == UDF_SB_PARTVSN(sb, j) &&
 				    UDF_SB_PARTNUM(sb, i) == UDF_SB_PARTNUM(sb, j)) {
@@ -1340,7 +1340,7 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 				}
 			}
 
-			if (j == UDF_SB_NUMPARTS(sb))
+			if (j == udf_sb_num_parts(sb))
 				return 1;
 
 			UDF_SB_VAT(sb) = udf_iget(sb, ino);
@@ -1561,7 +1561,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 			UDF_SET_FLAG(sb, UDF_FLAG_USE_STREAMS);
 	}
 
-	if (!UDF_SB_NUMPARTS(sb)) {
+	if (!udf_sb_num_parts(sb)) {
 		printk(KERN_WARNING "UDF-fs: No partition found (2)\n");
 		goto error_out;
 	}
@@ -1611,7 +1611,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 error_out:
 	if (UDF_SB_VAT(sb))
 		iput(UDF_SB_VAT(sb));
-	if (UDF_SB_NUMPARTS(sb)) {
+	if (udf_sb_num_parts(sb)) {
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE)
 			iput(udf_sb_partmaps(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE)
@@ -1686,7 +1686,7 @@ static void udf_put_super(struct super_block *sb)
 
 	if (UDF_SB_VAT(sb))
 		iput(UDF_SB_VAT(sb));
-	if (UDF_SB_NUMPARTS(sb)) {
+	if (udf_sb_num_parts(sb)) {
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE)
 			iput(udf_sb_partmaps(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE)
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index fa7fdff..983565d 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -60,14 +60,19 @@ static inline __u8 *udf_sb_volume_ident(struct super_block *sb)
 	return udf_sb(sb)->s_volume_ident;
 }
 
+static inline __u16 udf_sb_num_parts(struct super_block *sb)
+{
+	return udf_sb(sb)->s_partitions;
+}
+
 #define UDF_SB_ALLOC_PARTMAPS(X,Y)\
 {\
 	udf_sb(X)->s_partmaps = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
 	if (udf_sb_partmaps(X) != NULL) {\
-		UDF_SB_NUMPARTS(X) = Y;\
+		udf_sb(X)->s_partitions = Y;\
 		memset(udf_sb_partmaps(X), 0x00, sizeof(struct udf_part_map) * Y);\
 	} else {\
-		UDF_SB_NUMPARTS(X) = 0;\
+		udf_sb(X)->s_partitions = 0;\
 		udf_error(X, __FUNCTION__, "Unable to allocate space for %d partition maps", Y);\
 	}\
 }
@@ -124,7 +129,6 @@ static inline __u8 *udf_sb_volume_ident(struct super_block *sb)
 #define UDF_SB_BITMAP(X,Y,Z,I)			( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_block_bitmap[I] )
 #define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_nr_groups )
 
-#define UDF_SB_NUMPARTS(X)			( udf_sb(X)->s_partitions )
 #define UDF_SB_PARTITION(X)			( udf_sb(X)->s_partition )
 #define UDF_SB_SESSION(X)			( udf_sb(X)->s_session )
 #define UDF_SB_ANCHOR(X)			( udf_sb(X)->s_anchor )
-- 
1.5.3.4

