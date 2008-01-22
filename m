Return-Path: <linux-kernel-owner+w=401wt.eu-S1761990AbYAVDMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761990AbYAVDMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757436AbYAVDGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:06:45 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:32924 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759988AbYAVDGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:06:43 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 08/49] ext4:  Fix sparse warnings.
Date: Mon, 21 Jan 2008 22:01:47 -0500
Message-Id: <1200970948-17903-9-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-8-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
 <1200970948-17903-5-git-send-email-tytso@mit.edu>
 <1200970948-17903-6-git-send-email-tytso@mit.edu>
 <1200970948-17903-7-git-send-email-tytso@mit.edu>
 <1200970948-17903-8-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Fix sparse warnings related to static functions
and local variables.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c       |    6 +++---
 fs/ext4/inode.c         |   18 +++++++++++-------
 fs/ext4/super.c         |    3 +++
 include/linux/ext4_fs.h |    2 ++
 4 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6853722..754c0d3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1088,7 +1088,7 @@ static ext4_lblk_t ext4_ext_next_leaf_block(struct inode *inode,
  * then we have to correct all indexes above.
  * TODO: do we need to correct tree in all cases?
  */
-int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
+static int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
 				struct ext4_ext_path *path)
 {
 	struct ext4_extent_header *eh;
@@ -1535,7 +1535,7 @@ ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
  * It's used in truncate case only, thus all requests are for
  * last index in the block only.
  */
-int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
+static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
 			struct ext4_ext_path *path)
 {
 	struct buffer_head *bh;
@@ -1806,7 +1806,7 @@ ext4_ext_more_to_rm(struct ext4_ext_path *path)
 	return 1;
 }
 
-int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
+static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
 {
 	struct super_block *sb = inode->i_sb;
 	int depth = ext_depth(inode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1ee19c9..76ceba2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2052,11 +2052,11 @@ static void ext4_clear_blocks(handle_t *handle, struct inode *inode,
 	for (p = first; p < last; p++) {
 		u32 nr = le32_to_cpu(*p);
 		if (nr) {
-			struct buffer_head *bh;
+			struct buffer_head *tbh;
 
 			*p = 0;
-			bh = sb_find_get_block(inode->i_sb, nr);
-			ext4_forget(handle, 0, inode, bh, nr);
+			tbh = sb_find_get_block(inode->i_sb, nr);
+			ext4_forget(handle, 0, inode, tbh, nr);
 		}
 	}
 
@@ -2324,8 +2324,10 @@ void ext4_truncate(struct inode *inode)
 			return;
 	}
 
-	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
-		return ext4_ext_truncate(inode, page);
+	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
+		ext4_ext_truncate(inode, page);
+		return;
+	}
 
 	handle = start_transaction(inode);
 	if (IS_ERR(handle)) {
@@ -3163,8 +3165,10 @@ ext4_reserve_inode_write(handle_t *handle, struct inode *inode,
  * Expand an inode by new_extra_isize bytes.
  * Returns 0 on success or negative error number on failure.
  */
-int ext4_expand_extra_isize(struct inode *inode, unsigned int new_extra_isize,
-			struct ext4_iloc iloc, handle_t *handle)
+static int ext4_expand_extra_isize(struct inode *inode,
+				   unsigned int new_extra_isize,
+				   struct ext4_iloc iloc,
+				   handle_t *handle)
 {
 	struct ext4_inode *raw_inode;
 	struct ext4_xattr_ibody_header *header;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4d7f33f..7be27db 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1644,6 +1644,9 @@ static ext4_fsblk_t descriptor_loc(struct super_block *sb,
 
 
 static int ext4_fill_super (struct super_block *sb, void *data, int silent)
+				__releases(kernel_sem)
+				__acquires(kernel_sem)
+
 {
 	struct buffer_head * bh;
 	struct ext4_super_block *es = NULL;
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 429dbfc..1a27433 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -893,6 +893,8 @@ extern ext4_fsblk_t ext4_new_block (handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, int *errp);
 extern ext4_fsblk_t ext4_new_blocks (handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp);
+extern ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
+			ext4_fsblk_t goal, unsigned long *count, int *errp);
 extern void ext4_free_blocks (handle_t *handle, struct inode *inode,
 			ext4_fsblk_t block, unsigned long count);
 extern void ext4_free_blocks_sb (handle_t *handle, struct super_block *sb,
-- 
1.5.4.rc3.31.g1271-dirty

