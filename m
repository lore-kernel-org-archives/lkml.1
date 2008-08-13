Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbYHMInw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbYHMInw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbYHMIje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:34 -0400
Received: from smtp.nokia.com ([192.100.105.134]:31887 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbYHMIjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:31 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: optimize deletions
Date: Wed, 13 Aug 2008 13:17:42 +0300
Message-Id: <1218622675-28853-14-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:03.0456 (UTC) FILETIME=[0A5AC200:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Every time anything is deleted, UBIFS writes the deletion inode
node twice - once in 'ubifs_jnl_update()' and the second time in
'ubifs_jnl_write_inode()'. However, the second write is not needed
if no commit happened after 'ubifs_jnl_update()'. This patch
checks that condition and avoids writing the deletion inode for
the second time.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/journal.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ubifs/super.c   |    6 +++-
 fs/ubifs/ubifs.h   |   12 +++++++--
 3 files changed, 73 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index 3bc3fc9..0bcee7d 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -604,6 +604,7 @@ int ubifs_jnl_update(struct ubifs_info *c, const struct inode *dir,
 			release_head(c, BASEHD);
 			goto out_finish;
 		}
+		ui->del_cmtno = c->cmt_no;
 	}
 
 	err = write_head(c, BASEHD, dent, len, &lnum, &dent_offs, sync);
@@ -821,6 +822,64 @@ out_free:
 }
 
 /**
+ * ubifs_jnl_write_inode - delete an inode.
+ * @c: UBIFS file-system description object
+ * @inode: inode to delete
+ *
+ * This function deletes inode @inode which includes removing it from orphans,
+ * deleting it from TNC and, in some cases, writing a deletion inode to the
+ * journal.
+ *
+ * When regular file inodes are unlinked or a directory inode is removed, the
+ * 'ubifs_jnl_update()' function write corresponding deletion inode and
+ * direntry to the media, and adds the inode to orphans. After this, when the
+ * last reference to this inode has been dropped, this function is called. In
+ * general, it has to write one more deletion inode to the media, because if
+ * a commit happened between 'ubifs_jnl_update()' and
+ * 'ubifs_jnl_delete_inode()', the deletion inode is not in the journal
+ * anymore, and in fact it might be not on the flash anymore, becouse it might
+ * have been garbage-collected already. And for optimization reasond UBIFS does
+ * not read the orphan area if it has been unmounted cleanly, so it would have
+ * no indication in the journal that there is a deleted inode which has to be
+ * removed from TNC.
+ *
+ * However, if there was no commit between 'ubifs_jnl_update()' and
+ * 'ubifs_jnl_delete_inode()', then there is no need to write the deletion
+ * inode to the media for the second time. And this is quite typical case.
+ *
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
+ */
+int ubifs_jnl_delete_inode(struct ubifs_info *c, const struct inode *inode)
+{
+	int err;
+	struct ubifs_inode *ui = ubifs_inode(inode);
+
+	ubifs_assert(inode->i_nlink == 0);
+
+	if (ui->del_cmtno != c->cmt_no)
+		/* A commit happened for sure */
+		return ubifs_jnl_write_inode(c, inode);
+
+	down_read(&c->commit_sem);
+	/*
+	 * Check commit number again, because the first test has been done
+	 * without @c->commit_sem, so a commit might have happened.
+	 */
+	if (ui->del_cmtno != c->cmt_no) {
+		up_read(&c->commit_sem);
+		return ubifs_jnl_write_inode(c, inode);
+	}
+
+	ubifs_delete_orphan(c, inode->i_ino);
+	err = ubifs_tnc_remove_ino(c, inode->i_ino);
+	if (err)
+		ubifs_ro_mode(c, err);
+	up_read(&c->commit_sem);
+	return err;
+}
+
+/**
  * ubifs_jnl_rename - rename a directory entry.
  * @c: UBIFS file-system description object
  * @old_dir: parent inode of directory entry to rename
@@ -928,6 +987,7 @@ int ubifs_jnl_rename(struct ubifs_info *c, const struct inode *old_dir,
 			release_head(c, BASEHD);
 			goto out_finish;
 		}
+		new_ui->del_cmtno = c->cmt_no;
 	}
 
 	err = write_head(c, BASEHD, dent, len, &lnum, &offs, sync);
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index cf1fb6c..6cc4175 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -341,13 +341,15 @@ static void ubifs_delete_inode(struct inode *inode)
 		goto out;
 
 	ui->ui_size = inode->i_size = 0;
-	err = ubifs_jnl_write_inode(c, inode);
+	err = ubifs_jnl_delete_inode(c, inode);
 	if (err)
 		/*
 		 * Worst case we have a lost orphan inode wasting space, so a
 		 * simple error message is ok here.
 		 */
-		ubifs_err("can't write inode %lu, error %d", inode->i_ino, err);
+		ubifs_err("can't delete inode %lu, error %d",
+			  inode->i_ino, err);
+
 out:
 	if (ui->dirty)
 		ubifs_release_dirty_inode_budget(c, ui);
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 21502b6..dfb4b93 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -322,6 +322,8 @@ struct ubifs_gced_idx_leb {
  * struct ubifs_inode - UBIFS in-memory inode description.
  * @vfs_inode: VFS inode description object
  * @creat_sqnum: sequence number at time of creation
+ * @del_cmtno: commit number corresponding to the time the inode was deleted,
+ *             protected by @c->commit_sem;
  * @xattr_size: summarized size of all extended attributes in bytes
  * @xattr_cnt: count of extended attributes this inode has
  * @xattr_names: sum of lengths of all extended attribute names belonging to
@@ -372,7 +374,10 @@ struct ubifs_gced_idx_leb {
  */
 struct ubifs_inode {
 	struct inode vfs_inode;
-	unsigned long long creat_sqnum;
+	union {
+		unsigned long long creat_sqnum;
+		unsigned long long del_cmtno;
+	};
 	unsigned int xattr_size;
 	unsigned int xattr_cnt;
 	unsigned int xattr_names;
@@ -779,7 +784,7 @@ struct ubifs_compressor {
 /**
  * struct ubifs_budget_req - budget requirements of an operation.
  *
- * @fast: non-zero if the budgeting should try to aquire budget quickly and
+ * @fast: non-zero if the budgeting should try to acquire budget quickly and
  *        should not try to call write-back
  * @recalculate: non-zero if @idx_growth, @data_growth, and @dd_growth fields
  *               have to be re-calculated
@@ -860,7 +865,7 @@ struct ubifs_mount_opts {
  * struct ubifs_info - UBIFS file-system description data structure
  * (per-superblock).
  * @vfs_sb: VFS @struct super_block object
- * @bdi: backing device info object to make VFS happy and disable readahead
+ * @bdi: backing device info object to make VFS happy and disable read-ahead
  *
  * @highest_inum: highest used inode number
  * @vfs_gen: VFS inode generation counter
@@ -1402,6 +1407,7 @@ int ubifs_jnl_update(struct ubifs_info *c, const struct inode *dir,
 int ubifs_jnl_write_data(struct ubifs_info *c, const struct inode *inode,
 			 const union ubifs_key *key, const void *buf, int len);
 int ubifs_jnl_write_inode(struct ubifs_info *c, const struct inode *inode);
+int ubifs_jnl_delete_inode(struct ubifs_info *c, const struct inode *inode);
 int ubifs_jnl_rename(struct ubifs_info *c, const struct inode *old_dir,
 		     const struct dentry *old_dentry,
 		     const struct inode *new_dir,
-- 
1.5.4.1

