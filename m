Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbZFHTbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbZFHTbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbZFHTXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:51 -0400
Received: from thunk.org ([69.25.196.29]:39601 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204AbZFHTXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:22 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: Vincent Minet <vincent@vincent-minet.net>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 27/49] ext4: Fix spinlock assertions on UP systems
Date: Mon,  8 Jun 2009 15:22:45 -0400
Message-Id: <1244488987-32564-28-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-27-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
 <1244488987-32564-2-git-send-email-tytso@mit.edu>
 <1244488987-32564-3-git-send-email-tytso@mit.edu>
 <1244488987-32564-4-git-send-email-tytso@mit.edu>
 <1244488987-32564-5-git-send-email-tytso@mit.edu>
 <1244488987-32564-6-git-send-email-tytso@mit.edu>
 <1244488987-32564-7-git-send-email-tytso@mit.edu>
 <1244488987-32564-8-git-send-email-tytso@mit.edu>
 <1244488987-32564-9-git-send-email-tytso@mit.edu>
 <1244488987-32564-10-git-send-email-tytso@mit.edu>
 <1244488987-32564-11-git-send-email-tytso@mit.edu>
 <1244488987-32564-12-git-send-email-tytso@mit.edu>
 <1244488987-32564-13-git-send-email-tytso@mit.edu>
 <1244488987-32564-14-git-send-email-tytso@mit.edu>
 <1244488987-32564-15-git-send-email-tytso@mit.edu>
 <1244488987-32564-16-git-send-email-tytso@mit.edu>
 <1244488987-32564-17-git-send-email-tytso@mit.edu>
 <1244488987-32564-18-git-send-email-tytso@mit.edu>
 <1244488987-32564-19-git-send-email-tytso@mit.edu>
 <1244488987-32564-20-git-send-email-tytso@mit.edu>
 <1244488987-32564-21-git-send-email-tytso@mit.edu>
 <1244488987-32564-22-git-send-email-tytso@mit.edu>
 <1244488987-32564-23-git-send-email-tytso@mit.edu>
 <1244488987-32564-24-git-send-email-tytso@mit.edu>
 <1244488987-32564-25-git-send-email-tytso@mit.edu>
 <1244488987-32564-26-git-send-email-tytso@mit.edu>
 <1244488987-32564-27-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vincent Minet <vincent@vincent-minet.net>

On UP systems without DEBUG_SPINLOCK, ext4_is_group_locked always fails
which triggers a BUG_ON() call.
This patch fixes it by using assert_spin_locked instead.

Signed-off-by: Vincent Minet <vincent@vincent-minet.net>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h    |    6 ------
 fs/ext4/mballoc.c |   10 +++++-----
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 149e02d..89190ae 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1583,12 +1583,6 @@ static inline void ext4_unlock_group(struct super_block *sb,
 	spin_unlock(ext4_group_lock_ptr(sb, group));
 }
 
-static inline int ext4_is_group_locked(struct super_block *sb,
-					ext4_group_t group)
-{
-	return spin_is_locked(ext4_group_lock_ptr(sb, group));
-}
-
 /*
  * Inodes and files operations
  */
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e76459c..541bd9a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -436,7 +436,7 @@ static void mb_free_blocks_double(struct inode *inode, struct ext4_buddy *e4b,
 
 	if (unlikely(e4b->bd_info->bb_bitmap == NULL))
 		return;
-	BUG_ON(!ext4_is_group_locked(sb, e4b->bd_group));
+	assert_spin_locked(ext4_group_lock_ptr(sb, e4b->bd_group));
 	for (i = 0; i < count; i++) {
 		if (!mb_test_bit(first + i, e4b->bd_info->bb_bitmap)) {
 			ext4_fsblk_t blocknr;
@@ -460,7 +460,7 @@ static void mb_mark_used_double(struct ext4_buddy *e4b, int first, int count)
 
 	if (unlikely(e4b->bd_info->bb_bitmap == NULL))
 		return;
-	BUG_ON(!ext4_is_group_locked(e4b->bd_sb, e4b->bd_group));
+	assert_spin_locked(ext4_group_lock_ptr(e4b->bd_sb, e4b->bd_group));
 	for (i = 0; i < count; i++) {
 		BUG_ON(mb_test_bit(first + i, e4b->bd_info->bb_bitmap));
 		mb_set_bit(first + i, e4b->bd_info->bb_bitmap);
@@ -1115,7 +1115,7 @@ static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 	struct super_block *sb = e4b->bd_sb;
 
 	BUG_ON(first + count > (sb->s_blocksize << 3));
-	BUG_ON(!ext4_is_group_locked(sb, e4b->bd_group));
+	assert_spin_locked(ext4_group_lock_ptr(sb, e4b->bd_group));
 	mb_check_buddy(e4b);
 	mb_free_blocks_double(inode, e4b, first, count);
 
@@ -1196,7 +1196,7 @@ static int mb_find_extent(struct ext4_buddy *e4b, int order, int block,
 	int ord;
 	void *buddy;
 
-	BUG_ON(!ext4_is_group_locked(e4b->bd_sb, e4b->bd_group));
+	assert_spin_locked(ext4_group_lock_ptr(e4b->bd_sb, e4b->bd_group));
 	BUG_ON(ex == NULL);
 
 	buddy = mb_find_buddy(e4b, order, &max);
@@ -1260,7 +1260,7 @@ static int mb_mark_used(struct ext4_buddy *e4b, struct ext4_free_extent *ex)
 
 	BUG_ON(start + len > (e4b->bd_sb->s_blocksize << 3));
 	BUG_ON(e4b->bd_group != ex->fe_group);
-	BUG_ON(!ext4_is_group_locked(e4b->bd_sb, e4b->bd_group));
+	assert_spin_locked(ext4_group_lock_ptr(e4b->bd_sb, e4b->bd_group));
 	mb_check_buddy(e4b);
 	mb_mark_used_double(e4b, start, len);
 
-- 
1.6.3.2.1.gb9f7d.dirty

