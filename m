Return-Path: <linux-kernel-owner+w=401wt.eu-S1762421AbYAVDNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762421AbYAVDNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760104AbYAVDGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:06:49 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:32924 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758162AbYAVDGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:06:47 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 24/49] ext4: add block bitmap validation
Date: Mon, 21 Jan 2008 22:02:03 -0500
Message-Id: <1200970948-17903-25-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-24-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
 <1200970948-17903-5-git-send-email-tytso@mit.edu>
 <1200970948-17903-6-git-send-email-tytso@mit.edu>
 <1200970948-17903-7-git-send-email-tytso@mit.edu>
 <1200970948-17903-8-git-send-email-tytso@mit.edu>
 <1200970948-17903-9-git-send-email-tytso@mit.edu>
 <1200970948-17903-10-git-send-email-tytso@mit.edu>
 <1200970948-17903-11-git-send-email-tytso@mit.edu>
 <1200970948-17903-12-git-send-email-tytso@mit.edu>
 <1200970948-17903-13-git-send-email-tytso@mit.edu>
 <1200970948-17903-14-git-send-email-tytso@mit.edu>
 <1200970948-17903-15-git-send-email-tytso@mit.edu>
 <1200970948-17903-16-git-send-email-tytso@mit.edu>
 <1200970948-17903-17-git-send-email-tytso@mit.edu>
 <1200970948-17903-18-git-send-email-tytso@mit.edu>
 <1200970948-17903-19-git-send-email-tytso@mit.edu>
 <1200970948-17903-20-git-send-email-tytso@mit.edu>
 <1200970948-17903-21-git-send-email-tytso@mit.edu>
 <1200970948-17903-22-git-send-email-tytso@mit.edu>
 <1200970948-17903-23-git-send-email-tytso@mit.edu>
 <1200970948-17903-24-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

When a new block bitmap is read from disk in read_block_bitmap()
there are a few bits that should ALWAYS be set.  In particular,
the blocks given corresponding to block bitmap, inode bitmap and inode tables.
Validate the block bitmap against these blocks.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c |   99 ++++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 81 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index ff3428e..a9140ea 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -189,13 +189,65 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block * sb,
 	return desc;
 }
 
+static int ext4_valid_block_bitmap(struct super_block *sb,
+					struct ext4_group_desc *desc,
+					unsigned int block_group,
+					struct buffer_head *bh)
+{
+	ext4_grpblk_t offset;
+	ext4_grpblk_t next_zero_bit;
+	ext4_fsblk_t bitmap_blk;
+	ext4_fsblk_t group_first_block;
+
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+		/* with FLEX_BG, the inode/block bitmaps and itable
+		 * blocks may not be in the group at all
+		 * so the bitmap validation will be skipped for those groups
+		 * or it has to also read the block group where the bitmaps
+		 * are located to verify they are set.
+		 */
+		return 1;
+	}
+	group_first_block = ext4_group_first_block_no(sb, block_group);
+
+	/* check whether block bitmap block number is set */
+	bitmap_blk = ext4_block_bitmap(sb, desc);
+	offset = bitmap_blk - group_first_block;
+	if (!ext4_test_bit(offset, bh->b_data))
+		/* bad block bitmap */
+		goto err_out;
+
+	/* check whether the inode bitmap block number is set */
+	bitmap_blk = ext4_inode_bitmap(sb, desc);
+	offset = bitmap_blk - group_first_block;
+	if (!ext4_test_bit(offset, bh->b_data))
+		/* bad block bitmap */
+		goto err_out;
+
+	/* check whether the inode table block number is set */
+	bitmap_blk = ext4_inode_table(sb, desc);
+	offset = bitmap_blk - group_first_block;
+	next_zero_bit = ext4_find_next_zero_bit(bh->b_data,
+				offset + EXT4_SB(sb)->s_itb_per_group,
+				offset);
+	if (next_zero_bit >= offset + EXT4_SB(sb)->s_itb_per_group)
+		/* good bitmap for inode tables */
+		return 1;
+
+err_out:
+	ext4_error(sb, __FUNCTION__,
+			"Invalid block bitmap - "
+			"block_group = %d, block = %llu",
+			block_group, bitmap_blk);
+	return 0;
+}
 /**
  * read_block_bitmap()
  * @sb:			super block
  * @block_group:	given block group
  *
- * Read the bitmap for a given block_group, reading into the specified
- * slot in the superblock's bitmap cache.
+ * Read the bitmap for a given block_group,and validate the
+ * bits for block/inode/inode tables are set in the bitmaps
  *
  * Return buffer_head on success or NULL in case of failure.
  */
@@ -210,25 +262,36 @@ read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
 	if (!desc)
 		return NULL;
 	bitmap_blk = ext4_block_bitmap(sb, desc);
+	bh = sb_getblk(sb, bitmap_blk);
+	if (unlikely(!bh)) {
+		ext4_error(sb, __FUNCTION__,
+			    "Cannot read block bitmap - "
+			    "block_group = %d, block_bitmap = %llu",
+			    (int)block_group, (unsigned long long)bitmap_blk);
+		return NULL;
+	}
+	if (bh_uptodate_or_lock(bh))
+		return bh;
+
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
-		bh = sb_getblk(sb, bitmap_blk);
-		if (!buffer_uptodate(bh)) {
-			lock_buffer(bh);
-			if (!buffer_uptodate(bh)) {
-				ext4_init_block_bitmap(sb, bh, block_group,
-						       desc);
-				set_buffer_uptodate(bh);
-			}
-			unlock_buffer(bh);
-		}
-	} else {
-		bh = sb_bread(sb, bitmap_blk);
+		ext4_init_block_bitmap(sb, bh, block_group, desc);
+		set_buffer_uptodate(bh);
+		unlock_buffer(bh);
+		return bh;
 	}
-	if (!bh)
-		ext4_error (sb, __FUNCTION__,
+	if (bh_submit_read(bh) < 0) {
+		brelse(bh);
+		ext4_error(sb, __FUNCTION__,
 			    "Cannot read block bitmap - "
-			    "block_group = %lu, block_bitmap = %llu",
-			    block_group, bitmap_blk);
+			    "block_group = %d, block_bitmap = %llu",
+			    (int)block_group, (unsigned long long)bitmap_blk);
+		return NULL;
+	}
+	if (!ext4_valid_block_bitmap(sb, desc, block_group, bh)) {
+		brelse(bh);
+		return NULL;
+	}
+
 	return bh;
 }
 /*
-- 
1.5.4.rc3.31.g1271-dirty

