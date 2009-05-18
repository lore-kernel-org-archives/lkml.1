Return-Path: <linux-kernel-owner+w=401wt.eu-S1757618AbZERQMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbZERQMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757286AbZERQLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:11:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:41557 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756205AbZERQJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:37 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 31/32] union-mount: tmpfs fallthru support
Date: Mon, 18 May 2009 18:09:27 +0200
Message-Id: <1242662968-11684-32-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora (Henson) <vaurora@redhat.com>

Add support for fallthru entries to tmpfs.

Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
---
 fs/dcache.c |    4 ++-
 fs/libfs.c  |   18 ++++++++++++++--
 mm/shmem.c  |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 71 insertions(+), 12 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 844a76a..2d4c24e 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2305,7 +2305,9 @@ resume:
 		struct list_head *tmp = next;
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
-		if (d_unhashed(dentry)||!dentry->d_inode)
+		if (d_unhashed(dentry)||(!dentry->d_inode &&
+					 !d_is_whiteout(dentry) &&
+					 !d_is_fallthru(dentry)))
 			continue;
 		if (!list_empty(&dentry->d_subdirs)) {
 			this_parent = dentry;
diff --git a/fs/libfs.c b/fs/libfs.c
index 49b4409..a362077 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -131,6 +131,7 @@ int dcache_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	struct dentry *cursor = filp->private_data;
 	struct list_head *p, *q = &cursor->d_u.d_child;
 	ino_t ino;
+	int d_type;
 	int i = filp->f_pos;
 
 	switch (i) {
@@ -156,14 +157,25 @@ int dcache_readdir(struct file * filp, void * dirent, filldir_t filldir)
 			for (p=q->next; p != &dentry->d_subdirs; p=p->next) {
 				struct dentry *next;
 				next = list_entry(p, struct dentry, d_u.d_child);
-				if (d_unhashed(next) || !next->d_inode)
+				if (d_unhashed(next) || (!next->d_inode && !d_is_fallthru(next)))
 					continue;
 
+				if (d_is_fallthru(next)) {
+					/* XXX Make up things we can
+					 * only get out of the inode.
+					 * Should probably really do a
+					 * lookup instead. */
+					ino = 100; /* XXX Made up number of no significance */
+					d_type = DT_UNKNOWN;
+				} else {
+					ino = next->d_inode->i_ino;
+					d_type = dt_type(next->d_inode);
+				}
+
 				spin_unlock(&dcache_lock);
 				if (filldir(dirent, next->d_name.name, 
 					    next->d_name.len, filp->f_pos, 
-					    next->d_inode->i_ino, 
-					    dt_type(next->d_inode)) < 0)
+					    ino, d_type) < 0)
 					return 0;
 				spin_lock(&dcache_lock);
 				/* next is still alive */
diff --git a/mm/shmem.c b/mm/shmem.c
index b2e3904..f8284ea 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1778,8 +1778,7 @@ static int shmem_rmdir(struct inode *dir, struct dentry *dentry);
 static int shmem_unlink(struct inode *dir, struct dentry *dentry);
 
 /*
- * This is the whiteout support for tmpfs. It uses one singleton whiteout
- * inode per superblock thus it is very similar to shmem_link().
+ * Create a dentry to signify a whiteout.
  */
 static int shmem_whiteout(struct inode *dir, struct dentry *old_dentry,
 			  struct dentry *new_dentry)
@@ -1810,8 +1809,8 @@ static int shmem_whiteout(struct inode *dir, struct dentry *old_dentry,
 		spin_unlock(&sbinfo->stat_lock);
 	}
 
-	if (old_dentry->d_inode) {
-		if (S_ISDIR(old_dentry->d_inode->i_mode))
+	if (old_dentry->d_inode || d_is_fallthru(old_dentry)) {
+		if (old_dentry->d_inode && S_ISDIR(old_dentry->d_inode->i_mode))
 			shmem_rmdir(dir, old_dentry);
 		else
 			shmem_unlink(dir, old_dentry);
@@ -1828,6 +1827,48 @@ static int shmem_whiteout(struct inode *dir, struct dentry *old_dentry,
 }
 
 static void shmem_d_instantiate(struct inode *dir, struct dentry *dentry,
+				struct inode *inode);
+
+/*
+ * Create a dentry to signify a fallthru.  A fallthru lets us read the
+ * low-level dentries into the dcache once on the first readdir() and
+ * then
+ */
+static int shmem_fallthru(struct inode *dir, struct dentry *dentry)
+{
+	struct shmem_sb_info *sbinfo = SHMEM_SB(dir->i_sb);
+
+	/* FIXME: this is stupid */
+	if (!(dir->i_sb->s_flags & MS_WHITEOUT))
+		return -EPERM;
+
+	if (dentry->d_inode || d_is_fallthru(dentry) || d_is_whiteout(dentry))
+		return -EEXIST;
+
+	/*
+	 * Each new link needs a new dentry, pinning lowmem, and tmpfs
+	 * dentries cannot be pruned until they are unlinked.
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
+	shmem_d_instantiate(dir, dentry, NULL);
+	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+
+	spin_lock(&dentry->d_lock);
+	dentry->d_flags |= DCACHE_FALLTHRU;
+	spin_unlock(&dentry->d_lock);
+	return 0;
+}
+
+static void shmem_d_instantiate(struct inode *dir, struct dentry *dentry,
 				struct inode *inode)
 {
 	if (d_is_whiteout(dentry)) {
@@ -1835,14 +1876,15 @@ static void shmem_d_instantiate(struct inode *dir, struct dentry *dentry,
 		shmem_free_inode(dir->i_sb);
 		if (S_ISDIR(inode->i_mode))
 			inode->i_mode |= S_OPAQUE;
+	} else if (d_is_fallthru(dentry)) {
+		shmem_free_inode(dir->i_sb);
 	} else {
 		/* New dentry */
 		dir->i_size += BOGO_DIRENT_SIZE;
 		dget(dentry); /* Extra count - pin the dentry in core */
 	}
-	/* Will clear DCACHE_WHITEOUT flag */
+	/* Will clear DCACHE_WHITEOUT and DCACHE_FALLTHRU flags */
 	d_instantiate(dentry, inode);
-
 }
 /*
  * File creation. Allocate an inode, and we're done..
@@ -1928,7 +1970,8 @@ static int shmem_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
 
-	if (d_is_whiteout(dentry) || (inode->i_nlink > 1 && !S_ISDIR(inode->i_mode)))
+	if (d_is_whiteout(dentry) || d_is_fallthru(dentry) ||
+	    (inode->i_nlink > 1 && !S_ISDIR(inode->i_mode)))
 		shmem_free_inode(dir->i_sb);
 
 	if (inode) {
@@ -1954,7 +1997,8 @@ static void shmem_dir_unlink_whiteouts(struct inode *dir, struct dentry *dentry)
 		spin_lock(&dcache_lock);
 		list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child) {
 			spin_lock(&child->d_lock);
-			if (d_is_whiteout(child)) {
+			/* Unlink fallthrus too */
+			if (d_is_whiteout(child) || d_is_fallthru(child)) {
 				__d_drop(child);
 				if (!list_empty(&child->d_lru)) {
 					list_del(&child->d_lru);
@@ -2569,6 +2613,7 @@ static const struct inode_operations shmem_dir_inode_operations = {
 	.mknod		= shmem_mknod,
 	.rename		= shmem_rename,
 	.whiteout       = shmem_whiteout,
+	.fallthru       = shmem_fallthru,
 #endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	.setattr	= shmem_notify_change,
-- 
1.6.1.3

