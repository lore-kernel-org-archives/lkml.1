Return-Path: <linux-kernel-owner+w=401wt.eu-S933195AbYA3VTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195AbYA3VTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757015AbYA3VGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:06:47 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:26008 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759448AbYA3VGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:06:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=p2Xs7EMXgvx7+9lvEI3wQwZyw32Rdk2UCEkdBn1dthVd9rxLdHZnx1sCaFavAg8xZEn6jzBrc3QYAgZjp6JJpwUH1GYvUSV1XiAv1bYx+RdVz6g6qXKq886A3pcKG0bQ0oUlFHgcsXEzzMqGZqVGRF1FjhOy3/JGOOyxVnkMV5I=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 07/10] udf: replace all adds to little endians variables with le*_add_cpu
Date: Wed, 30 Jan 2008 22:03:57 +0100
Message-Id: <1201727040-6769-8-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com>
References: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace all:
	little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
	                                    expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
sparse didn't generate any new warning with this patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/balloc.c |   13 ++++---------
 fs/udf/ialloc.c |   12 ++++--------
 fs/udf/inode.c  |   16 ++++------------
 3 files changed, 12 insertions(+), 29 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index d721a1a..a95fcfe 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -149,8 +149,7 @@ static bool udf_add_free_space(struct udf_sb_info *sbi,
 		return false;
 
 	lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
-	lvid->freeSpaceTable[partition] = cpu_to_le32(le32_to_cpu(
-					lvid->freeSpaceTable[partition]) + cnt);
+	le32_add_cpu(&lvid->freeSpaceTable[partition], cnt);
 	return true;
 }
 
@@ -589,10 +588,8 @@ static void udf_table_free_blocks(struct super_block *sb,
 					sptr = oepos.bh->b_data + epos.offset;
 					aed = (struct allocExtDesc *)
 						oepos.bh->b_data;
-					aed->lengthAllocDescs =
-						cpu_to_le32(le32_to_cpu(
-							aed->lengthAllocDescs) +
-								adsize);
+					le32_add_cpu(&aed->lengthAllocDescs,
+							adsize);
 				} else {
 					sptr = iinfo->i_ext.i_data +
 								epos.offset;
@@ -645,9 +642,7 @@ static void udf_table_free_blocks(struct super_block *sb,
 				mark_inode_dirty(table);
 			} else {
 				aed = (struct allocExtDesc *)epos.bh->b_data;
-				aed->lengthAllocDescs =
-					cpu_to_le32(le32_to_cpu(
-					    aed->lengthAllocDescs) + adsize);
+				le32_add_cpu(&aed->lengthAllocDescs, adsize);
 				udf_update_tag(epos.bh->b_data, epos.offset);
 				mark_buffer_dirty(epos.bh);
 			}
diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
index 8436031..93b40cc 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -47,11 +47,9 @@ void udf_free_inode(struct inode *inode)
 		struct logicalVolIntegrityDescImpUse *lvidiu =
 							udf_sb_lvidiu(sbi);
 		if (S_ISDIR(inode->i_mode))
-			lvidiu->numDirs =
-				cpu_to_le32(le32_to_cpu(lvidiu->numDirs) - 1);
+			le32_add_cpu(&lvidiu->numDirs, -1);
 		else
-			lvidiu->numFiles =
-				cpu_to_le32(le32_to_cpu(lvidiu->numFiles) - 1);
+			le32_add_cpu(&lvidiu->numFiles, -1);
 
 		mark_buffer_dirty(sbi->s_lvid_bh);
 	}
@@ -105,11 +103,9 @@ struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
 		lvhd = (struct logicalVolHeaderDesc *)
 				(lvid->logicalVolContentsUse);
 		if (S_ISDIR(mode))
-			lvidiu->numDirs =
-				cpu_to_le32(le32_to_cpu(lvidiu->numDirs) + 1);
+			le32_add_cpu(&lvidiu->numDirs, 1);
 		else
-			lvidiu->numFiles =
-				cpu_to_le32(le32_to_cpu(lvidiu->numFiles) + 1);
+			le32_add_cpu(&lvidiu->numFiles, 1);
 		iinfo->i_unique = uniqueID = le64_to_cpu(lvhd->uniqueID);
 		if (!(++uniqueID & 0x00000000FFFFFFFFUL))
 			uniqueID += 16;
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 3483274..68db2ea 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1778,9 +1778,7 @@ int8_t udf_add_aext(struct inode *inode, struct extent_position *epos,
 
 			if (epos->bh) {
 				aed = (struct allocExtDesc *)epos->bh->b_data;
-				aed->lengthAllocDescs =
-					cpu_to_le32(le32_to_cpu(
-					aed->lengthAllocDescs) + adsize);
+				le32_add_cpu(&aed->lengthAllocDescs, adsize);
 			} else {
 				iinfo->i_lenAlloc += adsize;
 				mark_inode_dirty(inode);
@@ -1830,9 +1828,7 @@ int8_t udf_add_aext(struct inode *inode, struct extent_position *epos,
 		mark_inode_dirty(inode);
 	} else {
 		aed = (struct allocExtDesc *)epos->bh->b_data;
-		aed->lengthAllocDescs =
-			cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) +
-				    adsize);
+		le32_add_cpu(&aed->lengthAllocDescs, adsize);
 		if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
 				UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
 			udf_update_tag(epos->bh->b_data,
@@ -2046,9 +2042,7 @@ int8_t udf_delete_aext(struct inode *inode, struct extent_position epos,
 			mark_inode_dirty(inode);
 		} else {
 			aed = (struct allocExtDesc *)oepos.bh->b_data;
-			aed->lengthAllocDescs =
-				cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) -
-					    (2 * adsize));
+			le32_add_cpu(&aed->lengthAllocDescs, -(2 * adsize));
 			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
 			    UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
 				udf_update_tag(oepos.bh->b_data,
@@ -2065,9 +2059,7 @@ int8_t udf_delete_aext(struct inode *inode, struct extent_position epos,
 			mark_inode_dirty(inode);
 		} else {
 			aed = (struct allocExtDesc *)oepos.bh->b_data;
-			aed->lengthAllocDescs =
-				cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) -
-					    adsize);
+			le32_add_cpu(&aed->lengthAllocDescs, -adsize);
 			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
 			    UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
 				udf_update_tag(oepos.bh->b_data,
-- 
1.5.3.7

