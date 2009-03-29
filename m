Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbZC2Qjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbZC2Qjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbZC2Qhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:37:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:52659 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbZC2Qh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:37:29 -0400
Message-Id: <20090329155749.151733875@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Mon, 30 Mar 2009 02:55:45 +1100
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 06/14] fs: dcache scale d_unhashed
References: <20090329155539.275927173@nick.local0.net>
Content-Disposition: inline; filename=fs-dcache-scale-d_unhashed.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect d_unhashed(dentry) condition with d_lock.
---
 fs/dcache.c            |   46 +++++++++++++++++++++++++++++++++++-----------
 fs/libfs.c             |   29 ++++++++++++++++++++---------
 fs/seq_file.c          |    3 +++
 fs/sysfs/dir.c         |    8 +++++---
 include/linux/dcache.h |    3 +--
 5 files changed, 64 insertions(+), 25 deletions(-)

Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h
+++ linux-2.6/include/linux/dcache.h
@@ -343,6 +341,7 @@ static inline struct dentry *dget(struct
 }
 
 extern struct dentry * dget_locked(struct dentry *);
+extern struct dentry * dget_locked_dlock(struct dentry *);
 
 /**
  *	d_unhashed -	is dentry hashed
Index: linux-2.6/fs/sysfs/dir.c
===================================================================
--- linux-2.6.orig/fs/sysfs/dir.c
+++ linux-2.6/fs/sysfs/dir.c
@@ -521,10 +521,12 @@ static void sysfs_drop_dentry(struct sys
 repeat:
 	spin_lock(&dcache_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
-		if (d_unhashed(dentry))
-			continue;
-		dget_locked(dentry);
 		spin_lock(&dentry->d_lock);
+		if (d_unhashed(dentry)) {
+			spin_unlock(&dentry->d_lock);
+			continue;
+		}
+		dget_locked_dlock(dentry);
 		__d_drop(dentry);
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_lock);
Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c
+++ linux-2.6/fs/libfs.c
@@ -12,6 +12,11 @@
 
 #include <asm/uaccess.h>
 
+static inline int simple_positive(struct dentry *dentry)
+{
+	return dentry->d_inode && !d_unhashed(dentry);
+}
+
 int simple_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		   struct kstat *stat)
 {
@@ -101,8 +106,10 @@ loff_t dcache_dir_lseek(struct file *fil
 			while (n && p != &file->f_path.dentry->d_subdirs) {
 				struct dentry *next;
 				next = list_entry(p, struct dentry, d_u.d_child);
-				if (!d_unhashed(next) && next->d_inode)
+				spin_lock(&next->d_lock);
+				if (simple_positive(next))
 					n--;
+				spin_unlock(&next->d_lock);
 				p = p->next;
 			}
 			list_add_tail(&cursor->d_u.d_child, p);
@@ -156,9 +163,13 @@ int dcache_readdir(struct file * filp, v
 			for (p=q->next; p != &dentry->d_subdirs; p=p->next) {
 				struct dentry *next;
 				next = list_entry(p, struct dentry, d_u.d_child);
-				if (d_unhashed(next) || !next->d_inode)
+				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
+				if (!simple_positive(next)) {
+					spin_unlock(&next->d_lock);
 					continue;
+				}
 
+				spin_unlock(&next->d_lock);
 				spin_unlock(&dcache_lock);
 				if (filldir(dirent, next->d_name.name, 
 					    next->d_name.len, filp->f_pos, 
@@ -262,20 +273,20 @@ int simple_link(struct dentry *old_dentr
 	return 0;
 }
 
-static inline int simple_positive(struct dentry *dentry)
-{
-	return dentry->d_inode && !d_unhashed(dentry);
-}
-
 int simple_empty(struct dentry *dentry)
 {
 	struct dentry *child;
 	int ret = 0;
 
 	spin_lock(&dcache_lock);
-	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child)
-		if (simple_positive(child))
+	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child) {
+		spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
+		if (simple_positive(child)) {
+			spin_unlock(&child->d_lock);
 			goto out;
+		}
+		spin_unlock(&child->d_lock);
+	}
 	ret = 1;
 out:
 	spin_unlock(&dcache_lock);
Index: linux-2.6/fs/seq_file.c
===================================================================
--- linux-2.6.orig/fs/seq_file.c
+++ linux-2.6/fs/seq_file.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/mount.h>
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
@@ -460,7 +461,9 @@ int seq_path_root(struct seq_file *m, st
 		char *p;
 
 		spin_lock(&dcache_lock);
+		spin_lock(&vfsmount_lock);
 		p = __d_path(path, root, s, m->size - m->count);
+		spin_unlock(&vfsmount_lock);
 		spin_unlock(&dcache_lock);
 		err = PTR_ERR(p);
 		if (!IS_ERR(p)) {
Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -326,7 +326,9 @@ int d_invalidate(struct dentry * dentry)
 	 * If it's already been dropped, return OK.
 	 */
 	spin_lock(&dcache_lock);
+	spin_lock(&dentry->d_lock);
 	if (d_unhashed(dentry)) {
+		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_lock);
 		return 0;
 	}
@@ -335,6 +337,7 @@ int d_invalidate(struct dentry * dentry)
 	 * to get rid of unused child entries.
 	 */
 	if (!list_empty(&dentry->d_subdirs)) {
+		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_lock);
 		shrink_dcache_parent(dentry);
 		spin_lock(&dcache_lock);
@@ -386,6 +389,11 @@ struct dentry * dget_locked(struct dentr
 	return __dget_locked(dentry);
 }
 
+struct dentry * dget_locked_dlock(struct dentry *dentry)
+{
+	return __dget_locked_dlock(dentry);
+}
+
 /**
  * d_find_alias - grab a hashed alias of inode
  * @inode: inode in question
@@ -415,15 +423,18 @@ static struct dentry * __d_find_alias(st
 		next = tmp->next;
 		prefetch(next);
 		alias = list_entry(tmp, struct dentry, d_alias);
+		spin_lock(&alias->d_lock);
  		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
 			if (IS_ROOT(alias) &&
 			    (alias->d_flags & DCACHE_DISCONNECTED))
 				discon_alias = alias;
 			else if (!want_discon) {
-				__dget_locked(alias);
+				__dget_locked_dlock(alias);
+				spin_unlock(&alias->d_lock);
 				return alias;
 			}
 		}
+		spin_unlock(&alias->d_lock);
 	}
 	if (discon_alias)
 		__dget_locked(discon_alias);
@@ -706,8 +717,8 @@ static void shrink_dcache_for_umount_sub
 	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	dentry_lru_del_init(dentry);
-	spin_unlock(&dentry->d_lock);
 	__d_drop(dentry);
+	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 
 	for (;;) {
@@ -722,8 +733,8 @@ static void shrink_dcache_for_umount_sub
 					    d_u.d_child) {
 				spin_lock(&loop->d_lock);
 				dentry_lru_del_init(loop);
-				spin_unlock(&loop->d_lock);
 				__d_drop(loop);
+				spin_unlock(&loop->d_lock);
 				cond_resched_lock(&dcache_lock);
 			}
 			spin_unlock(&dcache_lock);
@@ -1997,7 +2006,8 @@ static int prepend_name(char **buffer, i
  * Returns a pointer into the buffer or an error code if the
  * path was too long.
  *
- * "buflen" should be positive. Caller holds the dcache_lock.
+ * "buflen" should be positive. Caller holds the dcache_lock and
+ * path->dentry->d_lock.
  *
  * If path is not reachable from the supplied root, then the value of
  * root is changed (without modifying refcounts).
@@ -2010,7 +2020,6 @@ char *__d_path(const struct path *path,
 	char *end = buffer + buflen;
 	char *retval;
 
-	spin_lock(&vfsmount_lock);
 	prepend(&end, &buflen, "\0", 1);
 	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
 		(prepend(&end, &buflen, " (deleted)", 10) != 0))
@@ -2046,7 +2055,6 @@ char *__d_path(const struct path *path,
 	}
 
 out:
-	spin_unlock(&vfsmount_lock);
 	return retval;
 
 global_root:
@@ -2099,8 +2107,12 @@ char *d_path(const struct path *path, ch
 	path_get(&root);
 	read_unlock(&current->fs->lock);
 	spin_lock(&dcache_lock);
+	spin_lock(&vfsmount_lock);
+	spin_lock(&path->dentry->d_lock);
 	tmp = root;
 	res = __d_path(path, &tmp, buf, buflen);
+	spin_unlock(&path->dentry->d_lock);
+	spin_unlock(&vfsmount_lock);
 	spin_unlock(&dcache_lock);
 	path_put(&root);
 	return res;
@@ -2136,6 +2148,7 @@ char *dentry_path(struct dentry *dentry,
 	char *retval;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dentry->d_lock);
 	prepend(&end, &buflen, "\0", 1);
 	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
 		(prepend(&end, &buflen, "//deleted", 9) != 0))
@@ -2157,9 +2170,11 @@ char *dentry_path(struct dentry *dentry,
 		retval = end;
 		dentry = parent;
 	}
+	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 	return retval;
 Elong:
+	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 	return ERR_PTR(-ENAMETOOLONG);
 }
@@ -2201,12 +2216,16 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 	error = -ENOENT;
 	/* Has the current directory has been unlinked? */
 	spin_lock(&dcache_lock);
+	spin_lock(&vfsmount_lock);
+	spin_lock(&pwd.dentry->d_lock);
 	if (IS_ROOT(pwd.dentry) || !d_unhashed(pwd.dentry)) {
 		unsigned long len;
 		struct path tmp = root;
 		char * cwd;
 
 		cwd = __d_path(&pwd, &tmp, page, PAGE_SIZE);
+		spin_unlock(&pwd.dentry->d_lock);
+		spin_unlock(&vfsmount_lock);
 		spin_unlock(&dcache_lock);
 
 		error = PTR_ERR(cwd);
@@ -2220,8 +2239,10 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 			if (copy_to_user(buf, cwd, len))
 				error = -EFAULT;
 		}
-	} else
+	} else {
+		spin_unlock(&pwd.dentry->d_lock);
 		spin_unlock(&dcache_lock);
+	}
 
 out:
 	path_put(&pwd);
@@ -2286,13 +2307,16 @@ resume:
 		struct list_head *tmp = next;
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
-		if (d_unhashed(dentry)||!dentry->d_inode)
+		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		if (d_unhashed(dentry) || !dentry->d_inode) {
+			spin_unlock(&dentry->d_lock);
 			continue;
+		}
 		if (!list_empty(&dentry->d_subdirs)) {
+			spin_unlock(&dentry->d_lock);
 			this_parent = dentry;
 			goto repeat;
 		}
-		spin_lock(&dentry->d_lock);
 		dentry->d_count--;
 		spin_unlock(&dentry->d_lock);
 	}


