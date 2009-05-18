Return-Path: <linux-kernel-owner+w=401wt.eu-S1758984AbZERQRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbZERQRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZERQOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:14:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:41488 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbZERQJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:29 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 11/32] whiteout: Add whiteout support to tmpfs
Date: Mon, 18 May 2009 18:09:07 +0200
Message-Id: <1242662968-11684-12-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for whiteouts to tmpfs.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
---
 mm/shmem.c |  150 ++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 136 insertions(+), 14 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 4103a23..b2e3904 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1774,6 +1774,76 @@ static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return 0;
 }
 
+static int shmem_rmdir(struct inode *dir, struct dentry *dentry);
+static int shmem_unlink(struct inode *dir, struct dentry *dentry);
+
+/*
+ * This is the whiteout support for tmpfs. It uses one singleton whiteout
+ * inode per superblock thus it is very similar to shmem_link().
+ */
+static int shmem_whiteout(struct inode *dir, struct dentry *old_dentry,
+			  struct dentry *new_dentry)
+{
+	struct shmem_sb_info *sbinfo = SHMEM_SB(dir->i_sb);
+	struct dentry *dentry;
+
+	if (!(dir->i_sb->s_flags & MS_WHITEOUT))
+		return -EPERM;
+
+	/* This gives us a proper initialized negative dentry */
+	dentry = simple_lookup(dir, new_dentry, NULL);
+	if (dentry && IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	/*
+	 * No ordinary (disk based) filesystem counts whiteouts as inodes;
+	 * but each new link needs a new dentry, pinning lowmem, and
+	 * tmpfs dentries cannot be pruned until they are unlinked.
+	 */
+	if (sbinfo->max_inodes) {
+		spin_lock(&sbinfo->stat_lock);
+		if (!sbinfo->free_inodes) {
+			spin_unlock(&sbinfo->stat_lock);
+			return -ENOSPC;
+		}
+		sbinfo->free_inodes--;
+		spin_unlock(&sbinfo->stat_lock);
+	}
+
+	if (old_dentry->d_inode) {
+		if (S_ISDIR(old_dentry->d_inode->i_mode))
+			shmem_rmdir(dir, old_dentry);
+		else
+			shmem_unlink(dir, old_dentry);
+	}
+
+	dir->i_size += BOGO_DIRENT_SIZE;
+	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+	/* Extra pinning count for the created dentry */
+	dget(new_dentry);
+	spin_lock(&new_dentry->d_lock);
+	new_dentry->d_flags |= DCACHE_WHITEOUT;
+	spin_unlock(&new_dentry->d_lock);
+	return 0;
+}
+
+static void shmem_d_instantiate(struct inode *dir, struct dentry *dentry,
+				struct inode *inode)
+{
+	if (d_is_whiteout(dentry)) {
+		/* Re-using an existing whiteout */
+		shmem_free_inode(dir->i_sb);
+		if (S_ISDIR(inode->i_mode))
+			inode->i_mode |= S_OPAQUE;
+	} else {
+		/* New dentry */
+		dir->i_size += BOGO_DIRENT_SIZE;
+		dget(dentry); /* Extra count - pin the dentry in core */
+	}
+	/* Will clear DCACHE_WHITEOUT flag */
+	d_instantiate(dentry, inode);
+
+}
 /*
  * File creation. Allocate an inode, and we're done..
  */
@@ -1798,15 +1868,16 @@ shmem_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 			iput(inode);
 			return error;
 		}
+
 		if (dir->i_mode & S_ISGID) {
 			inode->i_gid = dir->i_gid;
 			if (S_ISDIR(mode))
 				inode->i_mode |= S_ISGID;
 		}
-		dir->i_size += BOGO_DIRENT_SIZE;
+
+		shmem_d_instantiate(dir, dentry, inode);
+
 		dir->i_ctime = dir->i_mtime = CURRENT_TIME;
-		d_instantiate(dentry, inode);
-		dget(dentry); /* Extra count - pin the dentry in core */
 	}
 	return error;
 }
@@ -1844,12 +1915,11 @@ static int shmem_link(struct dentry *old_dentry, struct inode *dir, struct dentr
 	if (ret)
 		goto out;
 
-	dir->i_size += BOGO_DIRENT_SIZE;
+	shmem_d_instantiate(dir, dentry, inode);
+
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	inc_nlink(inode);
 	atomic_inc(&inode->i_count);	/* New dentry reference */
-	dget(dentry);		/* Extra pinning count for the created dentry */
-	d_instantiate(dentry, inode);
 out:
 	return ret;
 }
@@ -1858,21 +1928,61 @@ static int shmem_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
 
-	if (inode->i_nlink > 1 && !S_ISDIR(inode->i_mode))
-		shmem_free_inode(inode->i_sb);
+	if (d_is_whiteout(dentry) || (inode->i_nlink > 1 && !S_ISDIR(inode->i_mode)))
+		shmem_free_inode(dir->i_sb);
 
+	if (inode) {
+		inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+		drop_nlink(inode);
+	}
 	dir->i_size -= BOGO_DIRENT_SIZE;
-	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
-	drop_nlink(inode);
 	dput(dentry);	/* Undo the count from "create" - this does all the work */
 	return 0;
 }
 
+static void shmem_dir_unlink_whiteouts(struct inode *dir, struct dentry *dentry)
+{
+	if (!dentry->d_inode)
+		return;
+
+	/* Remove whiteouts from logical empty directory */
+	if (S_ISDIR(dentry->d_inode->i_mode) &&
+	    dentry->d_inode->i_sb->s_flags & MS_WHITEOUT) {
+		struct dentry *child, *next;
+		LIST_HEAD(list);
+
+		spin_lock(&dcache_lock);
+		list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child) {
+			spin_lock(&child->d_lock);
+			if (d_is_whiteout(child)) {
+				__d_drop(child);
+				if (!list_empty(&child->d_lru)) {
+					list_del(&child->d_lru);
+					dentry_stat.nr_unused--;
+				}
+				list_add(&child->d_lru, &list);
+			}
+			spin_unlock(&child->d_lock);
+		}
+		spin_unlock(&dcache_lock);
+
+		list_for_each_entry_safe(child, next, &list, d_lru) {
+			spin_lock(&child->d_lock);
+			list_del_init(&child->d_lru);
+			spin_unlock(&child->d_lock);
+
+			shmem_unlink(dentry->d_inode, child);
+		}
+	}
+}
+
 static int shmem_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	if (!simple_empty(dentry))
 		return -ENOTEMPTY;
 
+	/* Remove whiteouts from logical empty directory */
+	shmem_dir_unlink_whiteouts(dir, dentry);
 	drop_nlink(dentry->d_inode);
 	drop_nlink(dir);
 	return shmem_unlink(dir, dentry);
@@ -1881,7 +1991,7 @@ static int shmem_rmdir(struct inode *dir, struct dentry *dentry)
 /*
  * The VFS layer already does all the dentry stuff for rename,
  * we just have to decrement the usage count for the target if
- * it exists so that the VFS layer correctly free's it when it
+ * it exists so that the VFS layer correctly frees it when it
  * gets overwritten.
  */
 static int shmem_rename(struct inode *old_dir, struct dentry *old_dentry, struct inode *new_dir, struct dentry *new_dentry)
@@ -1892,7 +2002,12 @@ static int shmem_rename(struct inode *old_dir, struct dentry *old_dentry, struct
 	if (!simple_empty(new_dentry))
 		return -ENOTEMPTY;
 
+	if (d_is_whiteout(new_dentry))
+		shmem_unlink(new_dir, new_dentry);
+
 	if (new_dentry->d_inode) {
+		/* Remove whiteouts from logical empty directory */
+		shmem_dir_unlink_whiteouts(new_dir, new_dentry);
 		(void) shmem_unlink(new_dir, new_dentry);
 		if (they_are_dirs)
 			drop_nlink(old_dir);
@@ -1957,12 +2072,12 @@ static int shmem_symlink(struct inode *dir, struct dentry *dentry, const char *s
 		set_page_dirty(page);
 		page_cache_release(page);
 	}
+
+	shmem_d_instantiate(dir, dentry, inode);
+
 	if (dir->i_mode & S_ISGID)
 		inode->i_gid = dir->i_gid;
-	dir->i_size += BOGO_DIRENT_SIZE;
 	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
-	d_instantiate(dentry, inode);
-	dget(dentry);
 	return 0;
 }
 
@@ -2343,6 +2458,12 @@ static int shmem_fill_super(struct super_block *sb,
 	if (!root)
 		goto failed_iput;
 	sb->s_root = root;
+
+#ifdef CONFIG_TMPFS
+	if (!(sb->s_flags & MS_NOUSER))
+		sb->s_flags |= MS_WHITEOUT;
+#endif
+
 	return 0;
 
 failed_iput:
@@ -2447,6 +2568,7 @@ static const struct inode_operations shmem_dir_inode_operations = {
 	.rmdir		= shmem_rmdir,
 	.mknod		= shmem_mknod,
 	.rename		= shmem_rename,
+	.whiteout       = shmem_whiteout,
 #endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	.setattr	= shmem_notify_change,
-- 
1.6.1.3

