Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbYAFBVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbYAFBVZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 20:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbYAFBUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 20:20:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:49822 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbYAFBUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 20:20:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=VZPq+L1yWZOjz1VdIx8S0ITMy7Mt6kjJUKtmtFqUv0+4tY7ALjJODy/O3REaJa1q/ukUkIaGf3w6qCxgR4X80lIBkO6v4Ml5YLyA+v8UxweF8laCffUHtK3R7tkHddZ8zwPREqQJHT7aBax5vf1Vq9WKuDU+SBxNVGMU2wRUKok=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 3/7] udf: create common function for changing free space counter
Date: Sun,  6 Jan 2008 02:21:49 +0100
Message-Id: <1199582513-7915-3-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199582513-7915-1-git-send-email-marcin.slusarz@gmail.com>
References: <1199582513-7915-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 fs/udf/balloc.c |   49 ++++++++++++++++++++-----------------------------
 1 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 17b67dc..d1d4b8f 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -140,6 +140,20 @@ static inline int load_block_bitmap(struct super_block *sb,
 	return slot;
 }
 
+static inline bool udf_inc_free_space(struct udf_sb_info *sbi,
+				      u16 partition, u32 cnt)
+{
+	if (sbi->s_lvid_bh) {
+		struct logicalVolIntegrityDesc *lvid =
+					(struct logicalVolIntegrityDesc *)
+							sbi->s_lvid_bh->b_data;
+		lvid->freeSpaceTable[partition] =
+			cpu_to_le32(le32_to_cpu(
+					lvid->freeSpaceTable[partition]) + cnt);
+	}
+	return sbi->s_lvid_bh != NULL;
+}
+
 static void udf_bitmap_free_blocks(struct super_block *sb,
 				   struct inode *inode,
 				   struct udf_bitmap *bitmap,
@@ -194,11 +208,7 @@ do_more:
 		} else {
 			if (inode)
 				DQUOT_FREE_BLOCK(inode, 1);
-			if (sbi->s_lvid_bh) {
-				struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
-				lvid->freeSpaceTable[sbi->s_partition] =
-					cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[sbi->s_partition]) + 1);
-			}
+			udf_inc_free_space(sbi, sbi->s_partition, 1);
 		}
 	}
 	mark_buffer_dirty(bh);
@@ -270,12 +280,8 @@ repeat:
 	if (block_count > 0)
 		goto repeat;
 out:
-	if (sbi->s_lvid_bh) {
-		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
-		lvid->freeSpaceTable[partition] =
-			cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[partition]) - alloc_count);
+	if (udf_inc_free_space(sbi, partition, -alloc_count))
 		mark_buffer_dirty(sbi->s_lvid_bh);
-	}
 	sb->s_dirt = 1;
 	mutex_unlock(&sbi->s_alloc_mutex);
 	return alloc_count;
@@ -406,12 +412,8 @@ got_block:
 
 	mark_buffer_dirty(bh);
 
-	if (sbi->s_lvid_bh) {
-		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
-		lvid->freeSpaceTable[partition] =
-			cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[partition]) - 1);
+	if (udf_inc_free_space(sbi, partition, -1))
 		mark_buffer_dirty(sbi->s_lvid_bh);
-	}
 	sb->s_dirt = 1;
 	mutex_unlock(&sbi->s_alloc_mutex);
 	*err = 0;
@@ -452,12 +454,8 @@ static void udf_table_free_blocks(struct super_block *sb,
 	   could occure, but.. oh well */
 	if (inode)
 		DQUOT_FREE_BLOCK(inode, count);
-	if (sbi->s_lvid_bh) {
-		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
-		lvid->freeSpaceTable[sbi->s_partition] =
-			cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[sbi->s_partition]) + count);
+	if (udf_inc_free_space(sbi, sbi->s_partition, count))
 		mark_buffer_dirty(sbi->s_lvid_bh);
-	}
 
 	start = bloc.logicalBlockNum + offset;
 	end = bloc.logicalBlockNum + offset + count - 1;
@@ -721,10 +719,7 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
 
 	brelse(epos.bh);
 
-	if (alloc_count && sbi->s_lvid_bh) {
-		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
-		lvid->freeSpaceTable[partition] =
-			cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[partition]) - alloc_count);
+	if (alloc_count && udf_inc_free_space(sbi, partition, -alloc_count)) {
 		mark_buffer_dirty(sbi->s_lvid_bh);
 		sb->s_dirt = 1;
 	}
@@ -824,12 +819,8 @@ static int udf_table_new_block(struct super_block *sb,
 		udf_delete_aext(table, goal_epos, goal_eloc, goal_elen);
 	brelse(goal_epos.bh);
 
-	if (sbi->s_lvid_bh) {
-		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
-		lvid->freeSpaceTable[partition] =
-			cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[partition]) - 1);
+	if (udf_inc_free_space(sbi, partition, -1))
 		mark_buffer_dirty(sbi->s_lvid_bh);
-	}
 
 	sb->s_dirt = 1;
 	mutex_unlock(&sbi->s_alloc_mutex);
-- 
1.5.3.7

