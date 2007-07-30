Return-Path: <linux-kernel-owner+w=401wt.eu-S939518AbXG3QTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939518AbXG3QTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934545AbXG3QOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:14:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:58741 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934132AbXG3QOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:11 -0400
Message-Id: <20070730161325.092584388@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:44 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 21/26] union-mount: in-kernel file copy between union mounted filesystems
Content-Disposition: inline; filename=um/union-mount-copy-on-open.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces in-kernel file copy between union mounted
filesystems. When a file is opened for writing but resides on a lower (thus
read-only) layer of the union stack it is copied to the topmost union layer
first.

This patch uses the do_splice() for doing the in-kernel file copy.

Signed-off-by: Bharata B Rao <bharata@in.ibm.com>
Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/namei.c            |   73 ++++++++++-
 fs/union.c            |  312 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/union.h |    9 +
 3 files changed, 389 insertions(+), 5 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -994,7 +994,7 @@ static int __follow_mount(struct path *p
 	return res;
 }
 
-static void follow_mount(struct vfsmount **mnt, struct dentry **dentry)
+void follow_mount(struct vfsmount **mnt, struct dentry **dentry)
 {
 	while (d_mountpoint(*dentry)) {
 		struct vfsmount *mounted = lookup_mnt(*mnt, *dentry);
@@ -1213,6 +1213,21 @@ static fastcall int __link_path_walk(con
 		if (err)
 			break;
 
+		if ((nd->flags & LOOKUP_TOPMOST) &&
+		    (nd->um_flags & LAST_LOWLEVEL)) {
+			struct dentry *dentry;
+
+			dentry = union_create_topmost(nd, &this, &next);
+			if (IS_ERR(dentry)) {
+				err = PTR_ERR(dentry);
+				goto out_dput;
+			}
+			dput_path(&next, nd);
+			next.mnt = nd->mnt;
+			next.dentry = dentry;
+			nd->um_flags &= ~LAST_LOWLEVEL;
+		}
+
 		err = -ENOENT;
 		inode = next.dentry->d_inode;
 		if (!inode || S_ISWHT(inode->i_mode))
@@ -1267,6 +1282,22 @@ last_component:
 		err = do_lookup(nd, &this, &next);
 		if (err)
 			break;
+
+		if ((nd->flags & LOOKUP_TOPMOST) &&
+		    (nd->um_flags & LAST_LOWLEVEL)) {
+			struct dentry *dentry;
+
+			dentry = union_create_topmost(nd, &this, &next);
+			if (IS_ERR(dentry)) {
+				err = PTR_ERR(dentry);
+				goto out_dput;
+			}
+			dput_path(&next, nd);
+			next.mnt = nd->mnt;
+			next.dentry = dentry;
+			nd->um_flags &= ~LAST_LOWLEVEL;
+		}
+
 		inode = next.dentry->d_inode;
 		if ((lookup_flags & LOOKUP_FOLLOW)
 		    && inode && inode->i_op && inode->i_op->follow_link) {
@@ -1755,7 +1786,7 @@ out:
 	return err;
 }
 
-static int hash_lookup_union(struct nameidata *nd, struct qstr *name,
+int hash_lookup_union(struct nameidata *nd, struct qstr *name,
 			     struct path *path)
 {
 	struct path safe = { .dentry = nd->dentry, .mnt = nd->mnt };
@@ -2169,6 +2200,11 @@ int open_namei(int dfd, const char *path
 					 nd, flag);
 		if (error)
 			return error;
+		if (flag & FMODE_WRITE) {
+			error = union_copyup(nd, flag);
+			if (error)
+				return error;
+		}
 		goto ok;
 	}
 
@@ -2188,6 +2224,16 @@ int open_namei(int dfd, const char *path
 	if (nd->last_type != LAST_NORM || nd->last.name[nd->last.len])
 		goto exit;
 
+	/*
+	 * If this dentry is on an union mount we need the topmost dentry here.
+	 * This creates all topmost directories on the path to this dentry too.
+	 */
+	if (is_unionized(nd->dentry, nd->mnt)) {
+		error = union_relookup_topmost(nd, nd->flags & ~LOOKUP_PARENT);
+		if (error)
+			goto exit;
+	}
+
 	dir = nd->dentry;
 	nd->flags &= ~LOOKUP_PARENT;
 	mutex_lock(&dir->d_inode->i_mutex);
@@ -2235,10 +2281,21 @@ do_last:
 	if (path.dentry->d_inode->i_op && path.dentry->d_inode->i_op->follow_link)
 		goto do_link;
 
-	path_to_nameidata(&path, nd);
 	error = -EISDIR;
 	if (path.dentry->d_inode && S_ISDIR(path.dentry->d_inode->i_mode))
-		goto exit;
+		goto exit_dput;
+
+	/*
+	 * If this file is on a lower layer of the union stack, copy it to the
+	 * topmost layer before opening it
+	 */
+	if (path.dentry->d_inode && (path.dentry->d_parent != dir)) {
+		error = __union_copyup(&path, nd, &path);
+		if (error)
+			goto exit_dput;
+	}
+
+	path_to_nameidata(&path, nd);
 ok:
 	error = may_open(nd, acc_mode, flag);
 	if (error)
@@ -3437,9 +3494,15 @@ static int do_rename(int olddfd, const c
 	error = -ENOTEMPTY;
 	if (new.dentry == trap)
 		goto exit5;
+	/* renaming on unions is done by the user-space */
+	error = -EXDEV;
+	if (is_unionized(oldnd.dentry, oldnd.mnt))
+		goto exit5;
+	if (is_unionized(newnd.dentry, newnd.mnt))
+		goto exit5;
 
 	error = vfs_rename(old_dir->d_inode, old.dentry,
-				   new_dir->d_inode, new.dentry);
+			   new_dir->d_inode, new.dentry);
 exit5:
 	dput_path(&new, &newnd);
 exit4:
--- a/fs/union.c
+++ b/fs/union.c
@@ -20,6 +20,11 @@
 #include <linux/union.h>
 #include <linux/module.h>
 #include <linux/file.h>
+#include <linux/mm.h>
+#include <linux/quotaops.h>
+#include <linux/dnotify.h>
+#include <linux/security.h>
+#include <linux/pipe_fs_i.h>
 
 /*
  * This is borrowed from fs/inode.c. The hashtable for lookups. Somebody
@@ -798,3 +803,310 @@ out:
 	union_cache_free(&cb.list);
 	return res;
 }
+
+/*
+ * Union mount copyup support
+ */
+
+extern int hash_lookup_union(struct nameidata *, struct qstr *, struct path *);
+extern void follow_mount(struct vfsmount **, struct dentry **);
+
+/*
+ * union_relookup_topmost - lookup and create the topmost path to dentry
+ * @nd: pointer to nameidata
+ * @flags: lookup flags
+ */
+int union_relookup_topmost(struct nameidata *nd, int flags)
+{
+	int err;
+	char *kbuf, *name;
+	struct nameidata this;
+
+	kbuf = (char *)__get_free_page(GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	name = d_path(nd->dentry, nd->mnt, kbuf, PAGE_SIZE);
+	err = PTR_ERR(name);
+	if (IS_ERR(name))
+		goto free_page;
+
+	err = path_lookup(name, flags|LOOKUP_CREATE|LOOKUP_TOPMOST, &this);
+	if (err)
+		goto free_page;
+
+	path_release(nd);
+	nd->dentry = this.dentry;
+	nd->mnt = this.mnt;
+
+	/*
+	 * the nd->flags should be unchanged
+	 */
+	BUG_ON(this.um_flags & LAST_LOWLEVEL);
+	nd->um_flags &= ~LAST_LOWLEVEL;
+ free_page:
+	free_page((unsigned long)kbuf);
+	return err;
+}
+
+static void __update_fs_pwd(struct path *path, struct dentry *dentry,
+			    struct vfsmount *mnt)
+{
+	struct dentry *old_pwd = NULL;
+	struct vfsmount *old_pwdmnt = NULL;
+
+	write_lock(&current->fs->lock);
+	if (current->fs->pwd == path->dentry) {
+		old_pwd = current->fs->pwd;
+		old_pwdmnt = current->fs->pwdmnt;
+		current->fs->pwdmnt = mntget(mnt);
+		current->fs->pwd = dget(dentry);
+	}
+	write_unlock(&current->fs->lock);
+
+	if (old_pwd) {
+		dput(old_pwd);
+		mntput(old_pwdmnt);
+	}
+
+	return;
+}
+
+/*
+ * union_create_topmost - create the topmost path component
+ * @nd: pointer to nameidata of the base directory
+ * @name: pointer to file name
+ * @path: pointer to path of the overlaid file
+ *
+ * This is called by __link_path_walk() to create the directories on a path
+ * when it is called with LOOKUP_TOPMOST.
+ */
+struct dentry *union_create_topmost(struct nameidata *nd, struct qstr *name,
+				    struct path *path)
+{
+	struct dentry *dentry, *parent = nd->dentry;
+	int res, mode = path->dentry->d_inode->i_mode;
+
+	if (parent->d_sb == path->dentry->d_sb)
+		return ERR_PTR(-EEXIST);
+
+	mutex_lock(&parent->d_inode->i_mutex);
+	dentry = lookup_one_len_nd(name->name, nd->dentry, name->len, nd);
+	if (IS_ERR(dentry))
+		goto out_unlock;
+
+	switch (mode & S_IFMT) {
+	case S_IFREG:
+		/*
+		 * FIXME: Does this make any sense in this case?
+		 * Special case - lookup gave negative, but... we had foo/bar/
+		 * From the vfs_mknod() POV we just have a negative dentry -
+		 * all is fine. Let's be bastards - you had / on the end,you've
+		 * been asking for (non-existent) directory. -ENOENT for you.
+		 */
+		if (name->name[name->len] && !dentry->d_inode) {
+			dput(dentry);
+			dentry = ERR_PTR(-ENOENT);
+			goto out_unlock;
+		}
+
+		res = vfs_create(parent->d_inode, dentry, mode, nd);
+		if (res) {
+			dput(dentry);
+			dentry = ERR_PTR(res);
+			goto out_unlock;
+		}
+		break;
+	case S_IFDIR:
+		res = vfs_mkdir(parent->d_inode, dentry, mode);
+		if (res) {
+			dput(dentry);
+			dentry = ERR_PTR(res);
+			goto out_unlock;
+		}
+
+		res = append_to_union(nd->mnt, dentry, path->mnt,
+				      path->dentry);
+		if (res) {
+			dput(dentry);
+			dentry = ERR_PTR(res);
+			goto out_unlock;
+		}
+		break;
+	default:
+		dput(dentry);
+		dentry = ERR_PTR(-EINVAL);
+		goto out_unlock;
+	}
+
+	/* Really necessary ??? */
+/*	__update_fs_pwd(path, dentry, nd->mnt); */
+
+ out_unlock:
+	mutex_unlock(&parent->d_inode->i_mutex);
+	return dentry;
+}
+
+static int union_copy_file(struct dentry *old_dentry, struct vfsmount *old_mnt,
+			   struct dentry *new_dentry, struct vfsmount *new_mnt)
+{
+	int ret;
+	size_t size;
+	loff_t offset;
+	struct file *old_file, *new_file;
+
+	dget(old_dentry);
+	mntget(old_mnt);
+	old_file = dentry_open(old_dentry, old_mnt, O_RDONLY);
+	if (IS_ERR(old_file))
+		return PTR_ERR(old_file);
+
+	dget(new_dentry);
+	mntget(new_mnt);
+	new_file = dentry_open(new_dentry, new_mnt, O_WRONLY);
+	ret = PTR_ERR(new_file);
+	if (IS_ERR(new_file))
+		goto fput_old;
+
+	size = i_size_read(old_file->f_path.dentry->d_inode);
+	if (((size_t)size != size) || ((ssize_t)size != size)) {
+		ret = -EFBIG;
+		goto fput_new;
+	}
+
+	offset = 0;
+	ret = do_splice_direct(old_file, &offset, new_file, size,
+			       SPLICE_F_MOVE);
+	if (ret >= 0)
+		ret = 0;
+ fput_new:
+	fput(new_file);
+ fput_old:
+	fput(old_file);
+	return ret;
+}
+
+/**
+ * __union_copyup - copy a file to the topmost directory
+ * @old: pointer to path of the old file name
+ * @new_nd: pointer to nameidata of the topmost directory
+ * @new: pointer to path of the new file name
+ *
+ * The topmost directory @new_nd must already be locked. Creates the topmost
+ * file if it doesn't exist yet.
+ */
+int __union_copyup(struct path *old, struct nameidata *new_nd, struct path *new)
+{
+	struct dentry *dentry;
+	int error;
+
+	/* Maybe this should be -EINVAL */
+	if (S_ISDIR(old->dentry->d_inode->i_mode))
+		return -EISDIR;
+
+	if (new_nd->dentry != new->dentry->d_parent) {
+		dentry = lookup_one_len_nd(new->dentry->d_name.name,
+					   new_nd->dentry,
+					   new->dentry->d_name.len, new_nd);
+		if (IS_ERR(dentry))
+			return PTR_ERR(dentry);
+		error = -EEXIST;
+		if (dentry->d_inode && !S_ISWHT(dentry->d_inode->i_mode))
+			goto out;
+	} else
+		dentry = new->dentry;
+
+	if (!dentry->d_inode) {
+		error = vfs_create(new_nd->dentry->d_inode, dentry,
+				   old->dentry->d_inode->i_mode, new_nd);
+		if (error)
+			goto out;
+	}
+
+	error = union_copy_file(old->dentry, old->mnt, dentry, new_nd->mnt);
+	if (error) {
+		/* FIXME: are there return value we should not BUG() on ? */
+		BUG_ON(vfs_unlink(new_nd->dentry->d_inode, dentry));
+		goto out;
+	}
+
+	dput_path(new, new_nd);
+	new->dentry = dentry;
+	new->mnt = new_nd->mnt;
+out:
+	if (new->dentry != dentry)
+		dput(dentry);
+	return error;
+}
+
+/*
+ * union_copyup - copy a file to the topmost layer of the union stack
+ * @nd: nameidata pointer to the file
+ * @flags: flags given to open_namei
+ */
+int union_copyup(struct nameidata *nd, int flags)
+{
+	struct qstr this;
+	char *name;
+	struct dentry *dir;
+	struct path path;
+	int err;
+
+	if (!is_unionized(nd->dentry, nd->mnt))
+		return 0;
+	if (!S_ISREG(nd->dentry->d_inode->i_mode))
+		return 0;
+
+	/* safe the name for hash_lookup_union() */
+	this.len = nd->dentry->d_name.len;
+	this.hash = nd->dentry->d_name.hash;
+	name = kmalloc(this.len + 1, GFP_KERNEL);
+	if (!name)
+		return -ENOMEM;
+	this.name = name;
+	memcpy(name, nd->dentry->d_name.name, nd->dentry->d_name.len);
+	name[this.len] = 0;
+
+	err = union_relookup_topmost(nd, nd->flags|LOOKUP_PARENT);
+	if (err) {
+		kfree(name);
+		return err;
+	}
+	nd->flags &= ~LOOKUP_PARENT;
+
+	dir = nd->dentry;
+	mutex_lock(&dir->d_inode->i_mutex);
+	err = hash_lookup_union(nd, &this, &path);
+	mutex_unlock(&dir->d_inode->i_mutex);
+	kfree(name);
+	if (err)
+		return err;
+
+	err = -ENOENT;
+	if (!path.dentry->d_inode)
+		goto exit_dput;
+
+	/* Necessary?! I guess not ... */
+	follow_mount(&path.mnt, &path.dentry);
+
+	err = -ENOENT;
+	if (!path.dentry->d_inode)
+		goto exit_dput;
+
+	err = -EISDIR;
+	if (!S_ISREG(path.dentry->d_inode->i_mode))
+		goto exit_dput;
+
+	if (path.dentry->d_parent != nd->dentry) {
+		err = __union_copyup(&path, nd, &path);
+		if (err)
+			goto exit_dput;
+	}
+
+	path_to_nameidata(&path, nd);
+	return 0;
+
+exit_dput:
+	dput_path(&path, nd);
+	return err;
+}
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -54,6 +54,11 @@ extern int attach_mnt_union(struct vfsmo
 			    struct dentry *);
 extern void detach_mnt_union(struct vfsmount *);
 extern int readdir_union(struct file *, void *, filldir_t);
+extern int union_relookup_topmost(struct nameidata *, int);
+extern struct dentry *union_create_topmost(struct nameidata *, struct qstr *,
+					   struct path *);
+extern int __union_copyup(struct path *, struct nameidata *, struct path *);
+extern int union_copyup(struct nameidata *, int);
 
 #else /* CONFIG_UNION_MOUNT */
 
@@ -68,6 +73,10 @@ extern int readdir_union(struct file *, 
 #define __shrink_d_unions(x)		do { } while (0)
 #define attach_mnt_union(x, y, z)	do { } while (0)
 #define detach_mnt_union(x)		do { } while (0)
+#define union_relookup_topmost(x, y)	({ BUG(); (0); })
+#define union_create_topmost(x, y, z)	({ BUG(); (NULL); })
+#define __union_copyup(x, y, z)		({ BUG(); (0); })
+#define union_copyup(x, y)		({ (0); })
 
 #endif	/* CONFIG_UNION_MOUNT */
 

-- 

