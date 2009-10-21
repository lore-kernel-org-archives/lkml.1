Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZJUT3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZJUT3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbZJUT3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:29:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754952AbZJUTUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:20:33 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 13/41] whiteout: tmpfs whiteout support
Date: Wed, 21 Oct 2009 12:19:11 -0700
Message-Id: <1256152779-10054-14-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-13-git-send-email-vaurora@redhat.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
 <1256152779-10054-2-git-send-email-vaurora@redhat.com>
 <1256152779-10054-3-git-send-email-vaurora@redhat.com>
 <1256152779-10054-4-git-send-email-vaurora@redhat.com>
 <1256152779-10054-5-git-send-email-vaurora@redhat.com>
 <1256152779-10054-6-git-send-email-vaurora@redhat.com>
 <1256152779-10054-7-git-send-email-vaurora@redhat.com>
 <1256152779-10054-8-git-send-email-vaurora@redhat.com>
 <1256152779-10054-9-git-send-email-vaurora@redhat.com>
 <1256152779-10054-10-git-send-email-vaurora@redhat.com>
 <1256152779-10054-11-git-send-email-vaurora@redhat.com>
 <1256152779-10054-12-git-send-email-vaurora@redhat.com>
 <1256152779-10054-13-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

Add support for whiteout dentries to tmpfs.

XXX - Not sure this is the right patch to put the code for supporting
whiteouts in d_genocide().

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/dcache.c |    3 +-
 mm/shmem.c  |  149 +++++++++++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 137 insertions(+), 15 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 0fcae4b..1fae1df 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2280,7 +2280,8 @@ resume:
 		struct list_head *tmp = next;
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
-		if (d_unhashed(dentry)||!dentry->d_inode)
+		if (d_unhashed(dentry)||(!dentry->d_inode &&
+					 !d_is_whiteout(dentry)))
 			continue;
 		if (!list_empty(&dentry->d_subdirs)) {
 			this_parent = dentry;
diff --git a/mm/shmem.c b/mm/shmem.c
index d713239..2faa14b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1794,6 +1794,76 @@ static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
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
@@ -1823,10 +1893,10 @@ shmem_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
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
@@ -1864,12 +1934,11 @@ static int shmem_link(struct dentry *old_dentry, struct inode *dir, struct dentr
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
@@ -1878,21 +1947,61 @@ static int shmem_unlink(struct inode *dir, struct dentry *dentry)
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
@@ -1901,7 +2010,7 @@ static int shmem_rmdir(struct inode *dir, struct dentry *dentry)
 /*
  * The VFS layer already does all the dentry stuff for rename,
  * we just have to decrement the usage count for the target if
- * it exists so that the VFS layer correctly free's it when it
+ * it exists so that the VFS layer correctly frees it when it
  * gets overwritten.
  */
 static int shmem_rename(struct inode *old_dir, struct dentry *old_dentry, struct inode *new_dir, struct dentry *new_dentry)
@@ -1912,7 +2021,12 @@ static int shmem_rename(struct inode *old_dir, struct dentry *old_dentry, struct
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
@@ -1977,12 +2091,12 @@ static int shmem_symlink(struct inode *dir, struct dentry *dentry, const char *s
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
 
@@ -2363,6 +2477,12 @@ static int shmem_fill_super(struct super_block *sb,
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
@@ -2462,6 +2582,7 @@ static const struct inode_operations shmem_dir_inode_operations = {
 	.rmdir		= shmem_rmdir,
 	.mknod		= shmem_mknod,
 	.rename		= shmem_rename,
+	.whiteout       = shmem_whiteout,
 #endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	.setattr	= shmem_notify_change,
-- 
1.6.3.3

