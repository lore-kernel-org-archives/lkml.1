Return-Path: <linux-kernel-owner+w=401wt.eu-S1759938AbYAJWJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938AbYAJWJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbYAJWI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:08:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:37438 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759379AbYAJWI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:08:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=i3lwCLcvMWjnlrNbyZs5X8JHer70x7cWKAsC0Man46nocsJmVXne7pSwBwQ3tbDM0v7YqgIDscgBZO3XlPiTabr6NbbO9ayGQ8GYir6xOmFMYB3BzvHpQuXrGjaoHS7vJgJcr5cYj4eHS0MltQq3sONdfOyVSUK8ZJKXSeq1MYg=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/16] udf: create common function for changing free space counter
Date: Thu, 10 Jan 2008 23:06:26 +0100
Message-Id: <1200002792-8449-11-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com>
References: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Jan Kara <jack@suse.cz>
CC: Christoph Hellwig <hch@infradead.org>
---
 fs/udf/balloc.c |   49 ++++++++++++++++++++-----------------------------
 1 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index dc9f8a9..78dbf1d 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -140,6 +140,20 @@ static inline int load_block_bitmap(struct super_block *sb,
 	return slot;
 }
 
+static bool udf_inc_free_space(struct udf_sb_info *sbi,
+				u16 partition, u32 cnt)
+{
+	struct logicalVolIntegrityDesc *lvid;
+
+	if (sbi->s_lvid_bh)
+		return false;
+
+	lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
+	lvid->freeSpaceTable[partition] = cpu_to_le32(le32_to_cpu(
+					lvid->freeSpaceTable[partition]) + cnt);
+	return true;
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
@@ -268,12 +278,8 @@ repeat:
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
@@ -404,12 +410,8 @@ got_block:
 
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
@@ -450,12 +452,8 @@ static void udf_table_free_blocks(struct super_block *sb,
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
@@ -719,10 +717,7 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
 
 	brelse(epos.bh);
 
-	if (alloc_count && sbi->s_lvid_bh) {
-		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
-		lvid->freeSpaceTable[partition] =
-			cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[partition]) - alloc_count);
+	if (alloc_count && udf_inc_free_space(sbi, partition, -alloc_count)) {
 		mark_buffer_dirty(sbi->s_lvid_bh);
 		sb->s_dirt = 1;
 	}
@@ -822,12 +817,8 @@ static int udf_table_new_block(struct super_block *sb,
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

