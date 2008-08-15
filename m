Return-Path: <linux-kernel-owner+w=401wt.eu-S1757241AbYHODOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbYHODOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 23:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYHODN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 23:13:57 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:3768 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbYHODN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 23:13:56 -0400
From: Bob Copeland <me@bobcopeland.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       snakebyte@gmx.de, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/2] omfs: fix oops when file metadata is corrupted
Date: Thu, 14 Aug 2008 23:13:42 -0400
Message-Id: <1218770022-31956-2-git-send-email-me@bobcopeland.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A fuzzed fileystem image failed with OMFS when the extent count was
used in a loop without being checked against the max number of extents.
It also provoked a signed division for an array index that was checked
as if unsigned, leading to index by -1.

omfsck will be updated to fix these cases, in the meantime bail out
gracefully.

Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 fs/omfs/bitmap.c |    5 +++--
 fs/omfs/file.c   |   33 ++++++++++++++++++++++++++-------
 2 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/fs/omfs/bitmap.c b/fs/omfs/bitmap.c
index 697663b..e1c0ec0 100644
--- a/fs/omfs/bitmap.c
+++ b/fs/omfs/bitmap.c
@@ -92,7 +92,7 @@ int omfs_allocate_block(struct super_block *sb, u64 block)
 	struct buffer_head *bh;
 	struct omfs_sb_info *sbi = OMFS_SB(sb);
 	int bits_per_entry = 8 * sb->s_blocksize;
-	int map, bit;
+	unsigned int map, bit;
 	int ret = 0;
 	u64 tmp;
 
@@ -176,7 +176,8 @@ int omfs_clear_range(struct super_block *sb, u64 block, int count)
 	struct omfs_sb_info *sbi = OMFS_SB(sb);
 	int bits_per_entry = 8 * sb->s_blocksize;
 	u64 tmp;
-	int map, bit, ret;
+	unsigned int map, bit;
+	int ret;
 
 	tmp = block;
 	bit = do_div(tmp, bits_per_entry);
diff --git a/fs/omfs/file.c b/fs/omfs/file.c
index 7e24990..834b233 100644
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -26,6 +26,13 @@ static int omfs_sync_file(struct file *file, struct dentry *dentry,
 	return err ? -EIO : 0;
 }
 
+static u32 omfs_max_extents(struct omfs_sb_info *sbi, int offset)
+{
+	return (sbi->s_sys_blocksize - offset -
+		sizeof(struct omfs_extent)) /
+		sizeof(struct omfs_extent_entry) + 1;
+}
+
 void omfs_make_empty_table(struct buffer_head *bh, int offset)
 {
 	struct omfs_extent *oe = (struct omfs_extent *) &bh->b_data[offset];
@@ -45,6 +52,7 @@ int omfs_shrink_inode(struct inode *inode)
 	struct buffer_head *bh;
 	u64 next, last;
 	u32 extent_count;
+	u32 max_extents;
 	int ret;
 
 	/* traverse extent table, freeing each entry that is greater
@@ -62,15 +70,18 @@ int omfs_shrink_inode(struct inode *inode)
 		goto out;
 
 	oe = (struct omfs_extent *)(&bh->b_data[OMFS_EXTENT_START]);
+	max_extents = omfs_max_extents(sbi, OMFS_EXTENT_START);
 
 	for (;;) {
 
-		if (omfs_is_bad(sbi, (struct omfs_header *) bh->b_data, next)) {
-			brelse(bh);
-			goto out;
-		}
+		if (omfs_is_bad(sbi, (struct omfs_header *) bh->b_data, next))
+			goto out_brelse;
 
 		extent_count = be32_to_cpu(oe->e_extent_count);
+
+		if (extent_count > max_extents)
+			goto out_brelse;
+
 		last = next;
 		next = be64_to_cpu(oe->e_next);
 		entry = &oe->e_entry;
@@ -98,10 +109,14 @@ int omfs_shrink_inode(struct inode *inode)
 		if (!bh)
 			goto out;
 		oe = (struct omfs_extent *) (&bh->b_data[OMFS_EXTENT_CONT]);
+		max_extents = omfs_max_extents(sbi, OMFS_EXTENT_CONT);
 	}
 	ret = 0;
 out:
 	return ret;
+out_brelse:
+	brelse(bh);
+	return ret;
 }
 
 static void omfs_truncate(struct inode *inode)
@@ -154,9 +169,7 @@ static int omfs_grow_extent(struct inode *inode, struct omfs_extent *oe,
 			goto out;
 		}
 	}
-	max_count = (sbi->s_sys_blocksize - OMFS_EXTENT_START -
-		sizeof(struct omfs_extent)) /
-		sizeof(struct omfs_extent_entry) + 1;
+	max_count = omfs_max_extents(sbi, OMFS_EXTENT_START);
 
 	/* TODO: add a continuation block here */
 	if (be32_to_cpu(oe->e_extent_count) > max_count-1)
@@ -225,6 +238,7 @@ static int omfs_get_block(struct inode *inode, sector_t block,
 	sector_t next, offset;
 	int ret;
 	u64 new_block;
+	u32 max_extents;
 	int extent_count;
 	struct omfs_extent *oe;
 	struct omfs_extent_entry *entry;
@@ -238,6 +252,7 @@ static int omfs_get_block(struct inode *inode, sector_t block,
 		goto out;
 
 	oe = (struct omfs_extent *)(&bh->b_data[OMFS_EXTENT_START]);
+	max_extents = omfs_max_extents(sbi, OMFS_EXTENT_START);
 	next = inode->i_ino;
 
 	for (;;) {
@@ -249,6 +264,9 @@ static int omfs_get_block(struct inode *inode, sector_t block,
 		next = be64_to_cpu(oe->e_next);
 		entry = &oe->e_entry;
 
+		if (extent_count > max_extents)
+			goto out_brelse;
+
 		offset = find_block(inode, entry, block, extent_count, &remain);
 		if (offset > 0) {
 			ret = 0;
@@ -266,6 +284,7 @@ static int omfs_get_block(struct inode *inode, sector_t block,
 		if (!bh)
 			goto out;
 		oe = (struct omfs_extent *) (&bh->b_data[OMFS_EXTENT_CONT]);
+		max_extents = omfs_max_extents(sbi, OMFS_EXTENT_CONT);
 	}
 	if (create) {
 		ret = omfs_grow_extent(inode, oe, &new_block);
-- 
1.5.4.2.182.gb3092


