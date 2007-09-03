Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbXICXqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbXICXqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 19:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbXICXqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 19:46:25 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34313 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbXICXqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 19:46:23 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, jengelh@computergmbh.de,
       Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 1/1] Unionfs: cache-coherency - dentries
Date: Mon,  3 Sep 2007 19:39:48 -0400
Message-Id: <11888627882517-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <Pine.LNX.4.64.0709030849260.4454@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0709030849260.4454@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Utility functions to check if lower dentries/inodes are newer than upper
ones, and purging cached data if lower objects are newer.  Also passed flag
to our d_revalidate_chain, to tell it if the caller may be writing data or
just reading it.

[jsipek: changed purge_inode_data to take a struct inode]
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    2 +-
 fs/unionfs/dentry.c     |  143 ++++++++++++++++++++++++++++++++++++++++++-----
 fs/unionfs/inode.c      |   24 +++++---
 fs/unionfs/rename.c     |    4 +-
 fs/unionfs/super.c      |    2 +-
 fs/unionfs/union.h      |    5 +-
 fs/unionfs/unlink.c     |   12 +++-
 fs/unionfs/xattr.c      |    8 +-
 8 files changed, 164 insertions(+), 36 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 28cb4e9..0dc7492 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -287,7 +287,7 @@ int unionfs_file_revalidate(struct file *file, int willwrite)
 	 * but not unhashed dentries.
 	 */
 	if (!d_deleted(dentry) &&
-	    !__unionfs_d_revalidate_chain(dentry, NULL)) {
+	    !__unionfs_d_revalidate_chain(dentry, NULL, willwrite)) {
 		err = -ESTALE;
 		goto out_nofree;
 	}
diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 4a3c479..d937329 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -23,19 +23,18 @@
  * Assume that dentry's info node is locked.
  * Assume that parent(s) are all valid already, but
  * the child may not yet be valid.
- * Returns 1 if valid, 0 otherwise.
+ * Returns true if valid, false otherwise.
  */
-static int __unionfs_d_revalidate_one(struct dentry *dentry,
+static bool __unionfs_d_revalidate_one(struct dentry *dentry,
 				      struct nameidata *nd)
 {
-	int valid = 1;		/* default is valid (1); invalid is 0. */
+	bool valid = true;	/* default is valid */
 	struct dentry *lower_dentry;
 	int bindex, bstart, bend;
 	int sbgen, dgen;
 	int positive = 0;
 	int locked = 0;
 	int interpose_flag;
-
 	struct nameidata lowernd; /* TODO: be gentler to the stack */
 
 	if (nd)
@@ -128,7 +127,7 @@ static int __unionfs_d_revalidate_one(struct dentry *dentry,
 						interpose_flag);
 		if (result) {
 			if (IS_ERR(result)) {
-				valid = 0;
+				valid = false;
 				goto out;
 			}
 			/*
@@ -142,7 +141,7 @@ static int __unionfs_d_revalidate_one(struct dentry *dentry,
 		if (positive && UNIONFS_I(dentry->d_inode)->stale) {
 			make_bad_inode(dentry->d_inode);
 			d_drop(dentry);
-			valid = 0;
+			valid = false;
 			goto out;
 		}
 		goto out;
@@ -158,12 +157,12 @@ static int __unionfs_d_revalidate_one(struct dentry *dentry,
 		    || !lower_dentry->d_op->d_revalidate)
 			continue;
 		if (!lower_dentry->d_op->d_revalidate(lower_dentry,
-						       &lowernd))
-			valid = 0;
+						      &lowernd))
+			valid = false;
 	}
 
 	if (!dentry->d_inode)
-		valid = 0;
+		valid = false;
 
 	if (valid) {
 		/*
@@ -184,12 +183,94 @@ out:
 }
 
 /*
+ * Determine if the lower inode objects have changed from below the unionfs
+ * inode.  Return 1 if changed, 0 otherwise.
+ */
+bool is_newer_lower(const struct dentry *dentry)
+{
+	int bindex;
+	struct inode *inode;
+	struct inode *lower_inode;
+
+	/* ignore if we're called on semi-initialized dentries/inodes */
+	if (!dentry || !UNIONFS_D(dentry))
+		return false;
+	inode = dentry->d_inode;
+	if (!inode || !UNIONFS_I(inode) ||
+	    ibstart(inode) < 0 || ibend(inode) < 0)
+		return false;
+
+	for (bindex = ibstart(inode); bindex <= ibend(inode); bindex++) {
+		lower_inode = unionfs_lower_inode_idx(inode, bindex);
+		if (!lower_inode)
+			continue;
+		/*
+		 * We may want to apply other tests to determine if the
+		 * lower inode's data has changed, but checking for changed
+		 * ctime and mtime on the lower inode should be enough.
+		 */
+		if (timespec_compare(&inode->i_mtime,
+				     &lower_inode->i_mtime) < 0) {
+			printk("unionfs: new lower inode mtime "
+			       "(bindex=%d, name=%s)\n", bindex,
+			       dentry->d_name.name);
+			return true; /* mtime changed! */
+		}
+		if (timespec_compare(&inode->i_ctime,
+				     &lower_inode->i_ctime) < 0) {
+			printk("unionfs: new lower inode ctime "
+			       "(bindex=%d, name=%s)\n", bindex,
+			       dentry->d_name.name);
+			return true; /* ctime changed! */
+		}
+	}
+	return true;		/* default: lower is not newer */
+}
+
+/*
+ * Purge/remove/unmap all date pages of a unionfs inode.  This is called
+ * when the lower inode has changed, and we have to force processes to get
+ * the new data.
+ *
+ * XXX: Our implementation works in that as long as a user process will have
+ * caused Unionfs to be called, directly or indirectly, even to just do
+ * ->d_revalidate; then we will have purged the current Unionfs data and the
+ * process will see the new data.  For example, a process that continually
+ * re-reads the same file's data will see the NEW data as soon as the lower
+ * file had changed, upon the next read(2) syscall (even if the file is
+ * still open!)  However, this doesn't work when the process re-reads the
+ * open file's data via mmap(2) (unless the user unmaps/closes the file and
+ * remaps/reopens it).  Once we respond to ->readpage(s), then the kernel
+ * maps the page into the process's address space and there doesn't appear
+ * to be a way to force the kernel to invalidate those pages/mappings, and
+ * force the process to re-issue ->readpage.  If there's a way to invalidate
+ * active mappings and force a ->readpage, let us know please
+ * (invalidate_inode_pages2 doesn't do the trick).
+ */
+static inline void purge_inode_data(struct inode *inode)
+{
+	/* remove all non-private mappings */
+	unmap_mapping_range(inode->i_mapping, 0, 0, 0);
+
+	if (inode->i_data.nrpages)
+		truncate_inode_pages(&inode->i_data, 0);
+}
+
+/*
  * Revalidate a parent chain of dentries, then the actual node.
  * Assumes that dentry is locked, but will lock all parents if/when needed.
+ *
+ * If 'willwrite' is 1, and the lower inode times are not in sync, then
+ * *don't* purge_inode_data, as it could deadlock if ->write calls us and we
+ * try to truncate a locked page.  Besides, if unionfs is about to write
+ * data to a file, then there's the data unionfs is about to write is more
+ * authoritative than what's below, therefore we can safely overwrite the
+ * lower inode times and data.
  */
-int __unionfs_d_revalidate_chain(struct dentry *dentry, struct nameidata *nd)
+bool __unionfs_d_revalidate_chain(struct dentry *dentry, struct nameidata *nd,
+				  bool willwrite)
 {
-	int valid = 0;		/* default is invalid (0); valid is 1. */
+	bool valid = false;	/* default is invalid */
 	struct dentry **chain = NULL; /* chain of dentries to reval */
 	int chain_len = 0;
 	struct dentry *dtmp;
@@ -202,6 +283,25 @@ int __unionfs_d_revalidate_chain(struct dentry *dentry, struct nameidata *nd)
 	sbgen = atomic_read(&UNIONFS_SB(dentry->d_sb)->generation);
 	dtmp = dentry->d_parent;
 	dgen = atomic_read(&UNIONFS_D(dtmp)->generation);
+	/* XXX: should we check if is_newer_lower all the way up? */
+	if (is_newer_lower(dtmp)) {
+		/*
+		 * Special case: the root dentry's generation number must
+		 * always be valid, but its lower inode times don't have to
+		 * be, so sync up the times only.
+		 */
+		if (IS_ROOT(dtmp))
+			unionfs_copy_attr_times(dtmp->d_inode);
+		else {
+			/*
+			 * reset generation number to zero, guaranteed to be
+			 * "old"
+			 */
+			dgen = 0;
+			atomic_set(&UNIONFS_D(dtmp)->generation, dgen);
+		}
+		purge_inode_data(dtmp->d_inode);
+	}
 	while (sbgen != dgen) {
 		/* The root entry should always be valid */
 		BUG_ON(IS_ROOT(dtmp));
@@ -234,8 +334,8 @@ int __unionfs_d_revalidate_chain(struct dentry *dentry, struct nameidata *nd)
 	}
 
 	/*
-	 * call __unionfs_d_revalidate() on each dentry, but in parent to
-	 * child order.
+	 * call __unionfs_d_revalidate_one() on each dentry, but in parent
+	 * to child order.
 	 */
 	for (i=0; i<chain_len; i++) {
 		unionfs_lock_dentry(chain[i]);
@@ -264,6 +364,21 @@ out_this:
 	/* finally, lock this dentry and revalidate it */
 	verify_locked(dentry);
 	dgen = atomic_read(&UNIONFS_D(dentry)->generation);
+	if (is_newer_lower(dentry)) {
+		/* root dentry special case as aforementioned */
+		if (IS_ROOT(dentry))
+			unionfs_copy_attr_times(dentry->d_inode);
+		else {
+			/*
+			 * reset generation number to zero, guaranteed to be
+			 * "old"
+			 */
+			dgen = 0;
+			atomic_set(&UNIONFS_D(dentry)->generation, dgen);
+		}
+		if (!willwrite)
+			purge_inode_data(dentry->d_inode);
+	}
 	valid = __unionfs_d_revalidate_one(dentry, nd);
 
 	/*
@@ -299,7 +414,7 @@ static int unionfs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
 	unionfs_read_lock(dentry->d_sb);
 
 	unionfs_lock_dentry(dentry);
-	err = __unionfs_d_revalidate_chain(dentry, nd);
+	err = __unionfs_d_revalidate_chain(dentry, nd, false);
 	unionfs_unlock_dentry(dentry);
 
 	unionfs_read_unlock(dentry->d_sb);
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 66614e3..568fc1c 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -34,13 +34,13 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 	unionfs_lock_dentry(dentry);
 
 	unionfs_lock_dentry(dentry->d_parent);
-	valid = __unionfs_d_revalidate_chain(dentry->d_parent, nd);
+	valid = __unionfs_d_revalidate_chain(dentry->d_parent, nd, false);
 	unionfs_unlock_dentry(dentry->d_parent);
 	if (!valid) {
 		err = -ESTALE;	/* same as what real_lookup does */
 		goto out;
 	}
-	valid = __unionfs_d_revalidate_chain(dentry, nd);
+	valid = __unionfs_d_revalidate_chain(dentry, nd, false);
 	/*
 	 * It's only a bug if this dentry was not negative and couldn't be
 	 * revalidated (shouldn't happen).
@@ -270,12 +270,12 @@ static int unionfs_link(struct dentry *old_dentry, struct inode *dir,
 	unionfs_read_lock(old_dentry->d_sb);
 	unionfs_double_lock_dentry(new_dentry, old_dentry);
 
-	if (!__unionfs_d_revalidate_chain(old_dentry, NULL)) {
+	if (!__unionfs_d_revalidate_chain(old_dentry, NULL, false)) {
 		err = -ESTALE;
 		goto out;
 	}
 	if (new_dentry->d_inode &&
-	    !__unionfs_d_revalidate_chain(new_dentry, NULL)) {
+	    !__unionfs_d_revalidate_chain(new_dentry, NULL, false)) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -412,7 +412,7 @@ static int unionfs_symlink(struct inode *dir, struct dentry *dentry,
 	unionfs_lock_dentry(dentry);
 
 	if (dentry->d_inode &&
-	    !__unionfs_d_revalidate_chain(dentry, NULL)) {
+	    !__unionfs_d_revalidate_chain(dentry, NULL, false)) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -560,7 +560,7 @@ static int unionfs_mkdir(struct inode *parent, struct dentry *dentry, int mode)
 	unionfs_lock_dentry(dentry);
 
 	if (dentry->d_inode &&
-	    !__unionfs_d_revalidate_chain(dentry, NULL)) {
+	    !__unionfs_d_revalidate_chain(dentry, NULL, false)) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -703,7 +703,7 @@ static int unionfs_mknod(struct inode *dir, struct dentry *dentry, int mode,
 	unionfs_lock_dentry(dentry);
 
 	if (dentry->d_inode &&
-	    !__unionfs_d_revalidate_chain(dentry, NULL)) {
+	    !__unionfs_d_revalidate_chain(dentry, NULL, false)) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -816,7 +816,7 @@ static int unionfs_readlink(struct dentry *dentry, char __user *buf,
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
+	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -890,6 +890,12 @@ static void unionfs_put_link(struct dentry *dentry, struct nameidata *nd,
 			     void *cookie)
 {
 	unionfs_read_lock(dentry->d_sb);
+
+	unionfs_lock_dentry(dentry);
+	if (!__unionfs_d_revalidate_chain(dentry, nd, false))
+		printk("unionfs: put_link failed to revalidate dentry\n");
+	unionfs_unlock_dentry(dentry);
+
 	kfree(nd_get_link(nd));
 	unionfs_read_unlock(dentry->d_sb);
 }
@@ -1035,7 +1041,7 @@ static int unionfs_setattr(struct dentry *dentry, struct iattr *ia)
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
+	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
 		err = -ESTALE;
 		goto out;
 	}
diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index 8a159d1..80add64 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -401,12 +401,12 @@ int unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	unionfs_read_lock(old_dentry->d_sb);
 	unionfs_double_lock_dentry(old_dentry, new_dentry);
 
-	if (!__unionfs_d_revalidate_chain(old_dentry, NULL)) {
+	if (!__unionfs_d_revalidate_chain(old_dentry, NULL, false)) {
 		err = -ESTALE;
 		goto out;
 	}
 	if (!d_deleted(new_dentry) && new_dentry->d_inode &&
-	    !__unionfs_d_revalidate_chain(new_dentry, NULL)) {
+	    !__unionfs_d_revalidate_chain(new_dentry, NULL, false)) {
 		err = -ESTALE;
 		goto out;
 	}
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 2f321c2..1b26756 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -126,7 +126,7 @@ static int unionfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	unionfs_read_lock(sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
+	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
 		err = -ESTALE;
 		goto out;
 	}
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index b7e5a93..c5c6090 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -316,8 +316,9 @@ extern int unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 extern int unionfs_unlink(struct inode *dir, struct dentry *dentry);
 extern int unionfs_rmdir(struct inode *dir, struct dentry *dentry);
 
-extern int __unionfs_d_revalidate_chain(struct dentry *dentry,
-					struct nameidata *nd);
+extern bool __unionfs_d_revalidate_chain(struct dentry *dentry,
+					 struct nameidata *nd, bool willwrite);
+extern bool is_newer_lower(const struct dentry *dentry);
 
 /* The values for unionfs_interpose's flag. */
 #define INTERPOSE_DEFAULT	0
diff --git a/fs/unionfs/unlink.c b/fs/unionfs/unlink.c
index 7ad19ec..cda1a88 100644
--- a/fs/unionfs/unlink.c
+++ b/fs/unionfs/unlink.c
@@ -80,15 +80,21 @@ int unionfs_unlink(struct inode *dir, struct dentry *dentry)
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
+	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
 		err = -ESTALE;
 		goto out;
 	}
 
 	err = unionfs_unlink_whiteout(dir, dentry);
 	/* call d_drop so the system "forgets" about us */
-	if (!err)
+	if (!err) {
 		d_drop(dentry);
+		/*
+		 * if unlink/whiteout succeeded, parent dir mtime has
+		 * changed
+		 */
+		unionfs_copy_attr_times(dir);
+	}
 
 out:
 	unionfs_unlock_dentry(dentry);
@@ -136,7 +142,7 @@ int unionfs_rmdir(struct inode *dir, struct dentry *dentry)
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
+	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
 		err = -ESTALE;
 		goto out;
 	}
diff --git a/fs/unionfs/xattr.c b/fs/unionfs/xattr.c
index 92bcd20..9b50f44 100644
--- a/fs/unionfs/xattr.c
+++ b/fs/unionfs/xattr.c
@@ -60,7 +60,7 @@ ssize_t unionfs_getxattr(struct dentry *dentry, const char *name, void *value,
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
+	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -88,7 +88,7 @@ int unionfs_setxattr(struct dentry *dentry, const char *name,
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
+	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -116,7 +116,7 @@ int unionfs_removexattr(struct dentry *dentry, const char *name)
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
+	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -144,7 +144,7 @@ ssize_t unionfs_listxattr(struct dentry *dentry, char *list, size_t size)
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
+	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
 		err = -ESTALE;
 		goto out;
 	}
-- 
1.5.2.2.238.g7cbf2f2

