Return-Path: <linux-kernel-owner+w=401wt.eu-S1760535AbZLKEgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760535AbZLKEgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:36:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758980AbZLKEgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:05 -0500
Received: from kroah.org ([198.145.64.141]:52886 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759126AbZLKEfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:40 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:29 2009
Message-Id: <20091211042729.262525249@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:24:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Kara <jack@suse.cz>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [09/90] ext4: Fix possible deadlock between ext4_truncate() and ext4_get_blocks()
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0009-ext4-Fix-possible-deadlock-between-ext4_truncate-and.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
During truncate we are sometimes forced to start a new transaction as
the amount of blocks to be journaled is both quite large and hard to
predict. So far we restarted a transaction while holding i_data_sem
and that violates lock ordering because i_data_sem ranks below a
transaction start (and it can lead to a real deadlock with
ext4_get_blocks() mapping blocks in some page while having a
transaction open).

(cherry picked from commit 487caeef9fc08c0565e082c40a8aaf58dad92bbb)

We fix the problem by dropping the i_data_sem before restarting the
transaction and acquire it afterwards. It's slightly subtle that this
works:

1) By the time ext4_truncate() is called, all the page cache for the
truncated part of the file is dropped so get_block() should not be
called on it (we only have to invalidate extent cache after we
reacquire i_data_sem because some extent from not-truncated part could
extend also into the part we are going to truncate).

2) Writes, migrate or defrag hold i_mutex so they are stopped for all
the time of the truncate.

This bug has been found and analyzed by Theodore Tso <tytso@mit.edu>.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ext4.h    |    1 +
 fs/ext4/extents.c |   15 ++++++++++++---
 fs/ext4/inode.c   |   23 +++++++++++++++++++----
 3 files changed, 32 insertions(+), 7 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1370,6 +1370,7 @@ extern int ext4_change_inode_journal_fla
 extern int ext4_get_inode_loc(struct inode *, struct ext4_iloc *);
 extern int ext4_can_truncate(struct inode *inode);
 extern void ext4_truncate(struct inode *);
+extern int ext4_truncate_restart_trans(handle_t *, struct inode *, int nblocks);
 extern void ext4_set_inode_flags(struct inode *);
 extern void ext4_get_inode_flags(struct ext4_inode_info *);
 extern int ext4_alloc_da_blocks(struct inode *inode);
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -93,7 +93,9 @@ static void ext4_idx_store_pblock(struct
 	ix->ei_leaf_hi = cpu_to_le16((unsigned long) ((pb >> 31) >> 1) & 0xffff);
 }
 
-static int ext4_ext_journal_restart(handle_t *handle, int needed)
+static int ext4_ext_truncate_extend_restart(handle_t *handle,
+					    struct inode *inode,
+					    int needed)
 {
 	int err;
 
@@ -104,7 +106,14 @@ static int ext4_ext_journal_restart(hand
 	err = ext4_journal_extend(handle, needed);
 	if (err <= 0)
 		return err;
-	return ext4_journal_restart(handle, needed);
+	err = ext4_truncate_restart_trans(handle, inode, needed);
+	/*
+	 * We have dropped i_data_sem so someone might have cached again
+	 * an extent we are going to truncate.
+	 */
+	ext4_ext_invalidate_cache(inode);
+
+	return err;
 }
 
 /*
@@ -2138,7 +2147,7 @@ ext4_ext_rm_leaf(handle_t *handle, struc
 		}
 		credits += 2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
 
-		err = ext4_ext_journal_restart(handle, credits);
+		err = ext4_ext_truncate_extend_restart(handle, inode, credits);
 		if (err)
 			goto out;
 
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -192,11 +192,24 @@ static int try_to_extend_transaction(han
  * so before we call here everything must be consistently dirtied against
  * this transaction.
  */
-static int ext4_journal_test_restart(handle_t *handle, struct inode *inode)
+ int ext4_truncate_restart_trans(handle_t *handle, struct inode *inode,
+				 int nblocks)
 {
+	int ret;
+
+	/*
+	 * Drop i_data_sem to avoid deadlock with ext4_get_blocks At this
+	 * moment, get_block can be called only for blocks inside i_size since
+	 * page cache has been already dropped and writes are blocked by
+	 * i_mutex. So we can safely drop the i_data_sem here.
+	 */
 	BUG_ON(EXT4_JOURNAL(inode) == NULL);
 	jbd_debug(2, "restarting handle %p\n", handle);
-	return ext4_journal_restart(handle, blocks_for_truncate(inode));
+	up_write(&EXT4_I(inode)->i_data_sem);
+	ret = ext4_journal_restart(handle, blocks_for_truncate(inode));
+	down_write(&EXT4_I(inode)->i_data_sem);
+
+	return ret;
 }
 
 /*
@@ -3659,7 +3672,8 @@ static void ext4_clear_blocks(handle_t *
 			ext4_handle_dirty_metadata(handle, inode, bh);
 		}
 		ext4_mark_inode_dirty(handle, inode);
-		ext4_journal_test_restart(handle, inode);
+		ext4_truncate_restart_trans(handle, inode,
+					    blocks_for_truncate(inode));
 		if (bh) {
 			BUFFER_TRACE(bh, "retaking write access");
 			ext4_journal_get_write_access(handle, bh);
@@ -3870,7 +3884,8 @@ static void ext4_free_branches(handle_t
 				return;
 			if (try_to_extend_transaction(handle, inode)) {
 				ext4_mark_inode_dirty(handle, inode);
-				ext4_journal_test_restart(handle, inode);
+				ext4_truncate_restart_trans(handle, inode,
+					    blocks_for_truncate(inode));
 			}
 
 			ext4_free_blocks(handle, inode, nr, 1, 1);


