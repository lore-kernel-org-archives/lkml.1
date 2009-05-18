Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbZERQNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbZERQNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757465AbZERQM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:12:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:41534 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644AbZERQJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:35 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 24/32] union-mount: in-kernel file copy between union mounted filesystems
Date: Mon, 18 May 2009 18:09:20 +0200
Message-Id: <1242662968-11684-25-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces in-kernel file copy between union mounted
filesystems. When a file is opened for writing but resides on a lower (thus
read-only) layer of the union stack it is copied to the topmost union layer
first.

This patch uses the do_splice() for doing the in-kernel file copy.

Signed-off-by: Bharata B Rao <bharata@in.ibm.com>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
---
 fs/namei.c            |   63 +++++++++-
 fs/union.c            |  320 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/union.h |    7 +
 3 files changed, 386 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 9c38df3..91486bd 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1044,7 +1044,7 @@ static int __follow_mount(struct path *path)
 	return res;
 }
 
-static void follow_mount(struct vfsmount **mnt, struct dentry **dentry)
+void follow_mount(struct vfsmount **mnt, struct dentry **dentry)
 {
 	while (d_mountpoint(*dentry)) {
 		struct vfsmount *mounted = lookup_mnt(*mnt, *dentry);
@@ -1265,6 +1265,21 @@ static int __link_path_walk(const char *name, struct nameidata *nd)
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
+			path_put_conditional(&next, nd);
+			next.mnt = nd->path.mnt;
+			next.dentry = dentry;
+			nd->um_flags &= ~LAST_LOWLEVEL;
+		}
+
 		err = -ENOENT;
 		inode = next.dentry->d_inode;
 		if (!inode)
@@ -1314,6 +1329,22 @@ last_component:
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
+			path_put_conditional(&next, nd);
+			next.mnt = nd->path.mnt;
+			next.dentry = dentry;
+			nd->um_flags &= ~LAST_LOWLEVEL;
+		}
+
 		inode = next.dentry->d_inode;
 		if ((lookup_flags & LOOKUP_FOLLOW)
 		    && inode && inode->i_op->follow_link) {
@@ -1676,7 +1707,7 @@ out:
 	return err;
 }
 
-static int hash_lookup_union(struct nameidata *nd, struct qstr *name,
+int hash_lookup_union(struct nameidata *nd, struct qstr *name,
 			     struct path *path)
 {
 	struct path safe = { .dentry = nd->path.dentry, .mnt = nd->path.mnt };
@@ -2160,6 +2191,13 @@ struct file *do_filp_open(int dfd, const char *pathname,
 					 &nd, flag);
 		if (error)
 			return ERR_PTR(error);
+		if (unlikely((flag & FMODE_WRITE) &&
+			     is_unionized(nd.path.dentry, nd.path.mnt) &&
+			     S_ISREG(nd.path.dentry->d_inode->i_mode))) {
+			error = union_copyup(&nd, flag);
+			if (error)
+				return ERR_PTR(error);
+		}
 		goto ok;
 	}
 
@@ -2249,10 +2287,21 @@ do_last:
 	if (path.dentry->d_inode->i_op->follow_link)
 		goto do_link;
 
-	path_to_nameidata(&path, &nd);
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
+		error = __union_copyup(&path, &nd, &path);
+		if (error)
+			goto exit_dput;
+	}
+
+	path_to_nameidata(&path, &nd);
 ok:
 	/*
 	 * Consider:
@@ -3315,6 +3364,12 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	error = -ENOTEMPTY;
 	if (new.dentry == trap)
 		goto exit5;
+	/* renaming on unions is done by the user-space */
+	error = -EXDEV;
+	if (is_unionized(oldnd.path.dentry, oldnd.path.mnt))
+		goto exit5;
+	if (is_unionized(newnd.path.dentry, newnd.path.mnt))
+		goto exit5;
 
 	error = mnt_want_write(oldnd.path.mnt);
 	if (error)
diff --git a/fs/union.c b/fs/union.c
index 6e220bd..d21fe5f 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -20,6 +20,14 @@
 #include <linux/fs.h>
 #include <linux/mount.h>
 #include <linux/union.h>
+#include <linux/namei.h>
+#include <linux/file.h>
+#include <linux/mm.h>
+#include <linux/quotaops.h>
+#include <linux/dnotify.h>
+#include <linux/security.h>
+#include <linux/pipe_fs_i.h>
+#include <linux/splice.h>
 
 /*
  * This is borrowed from fs/inode.c. The hashtable for lookups. Somebody
@@ -336,6 +344,318 @@ int follow_union_mount(struct vfsmount **mnt, struct dentry **dentry)
 }
 
 /*
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
+static int union_relookup_topmost(struct nameidata *nd, int flags)
+{
+	int err;
+	char *kbuf, *name;
+	struct nameidata this;
+
+	kbuf = (char *)__get_free_page(GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	name = d_path(&nd->path, kbuf, PAGE_SIZE);
+	err = PTR_ERR(name);
+	if (IS_ERR(name))
+		goto free_page;
+
+	err = path_lookup(name, flags|LOOKUP_CREATE|LOOKUP_TOPMOST, &this);
+	if (err)
+		goto free_page;
+
+	path_put(&nd->path);
+	nd->path.dentry = this.path.dentry;
+	nd->path.mnt = this.path.mnt;
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
+	struct path old = { NULL, NULL };
+
+	write_lock(&current->fs->lock);
+	if (current->fs->pwd.dentry == path->dentry) {
+		old = current->fs->pwd;
+		path_get(&current->fs->pwd);
+	}
+	write_unlock(&current->fs->lock);
+
+	if (old.dentry)
+		path_put(&old);
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
+	struct dentry *dentry, *parent = nd->path.dentry;
+	int res, mode = path->dentry->d_inode->i_mode;
+
+	if (parent->d_sb == path->dentry->d_sb)
+		return ERR_PTR(-EEXIST);
+
+	mutex_lock(&parent->d_inode->i_mutex);
+	dentry = lookup_one_len(name->name, nd->path.dentry, name->len);
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
+		res = append_to_union(nd->path.mnt, dentry, path->mnt,
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
+	/* FIXME: Really necessary ??? */
+/*	__update_fs_pwd(path, dentry, nd->path.mnt); */
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
+	const struct cred *cred = current_cred();
+
+	dget(old_dentry);
+	mntget(old_mnt);
+	old_file = dentry_open(old_dentry, old_mnt, O_RDONLY, cred);
+	if (IS_ERR(old_file))
+		return PTR_ERR(old_file);
+
+	dget(new_dentry);
+	mntget(new_mnt);
+	new_file = dentry_open(new_dentry, new_mnt, O_WRONLY, cred);
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
+	if (new_nd->path.dentry != new->dentry->d_parent) {
+		dentry = lookup_one_len(new->dentry->d_name.name,
+					new_nd->path.dentry,
+					new->dentry->d_name.len);
+		if (IS_ERR(dentry))
+			return PTR_ERR(dentry);
+		error = -EEXIST;
+		if (dentry->d_inode)
+			goto out_dput;
+	} else
+		dentry = dget(new->dentry);
+
+	if (!dentry->d_inode) {
+		error = vfs_create(new_nd->path.dentry->d_inode, dentry,
+				   old->dentry->d_inode->i_mode, new_nd);
+		if (error)
+			goto out_dput;
+	}
+
+	error = union_copy_file(old->dentry, old->mnt, dentry,
+				new_nd->path.mnt);
+	if (error) {
+		/* FIXME: are there return value we should not BUG() on ? */
+		BUG_ON(vfs_unlink(new_nd->path.dentry->d_inode, dentry));
+		goto out_dput;
+	}
+
+	dput(new->dentry);
+	new->dentry = dentry;
+	if (new->mnt != new_nd->path.mnt)
+		mntput(new->mnt);
+	new->mnt = new_nd->path.mnt;
+	return error;
+
+out_dput:
+	dput(dentry);
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
+	if (!is_unionized(nd->path.dentry, nd->path.mnt))
+		return 0;
+	if (!S_ISREG(nd->path.dentry->d_inode->i_mode))
+		return 0;
+
+	/* safe the name for hash_lookup_union() */
+	this.len = nd->path.dentry->d_name.len;
+	this.hash = nd->path.dentry->d_name.hash;
+	name = kmalloc(this.len + 1, GFP_KERNEL);
+	if (!name)
+		return -ENOMEM;
+	this.name = name;
+	memcpy(name, nd->path.dentry->d_name.name, nd->path.dentry->d_name.len);
+	name[this.len] = 0;
+
+	err = union_relookup_topmost(nd, nd->flags|LOOKUP_PARENT);
+	if (err) {
+		kfree(name);
+		return err;
+	}
+	nd->flags &= ~LOOKUP_PARENT;
+
+	dir = nd->path.dentry;
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
+	if (path.dentry->d_parent != nd->path.dentry) {
+		err = __union_copyup(&path, nd, &path);
+		if (err)
+			goto exit_dput;
+	}
+
+	dput(nd->path.dentry);
+	if (nd->path.mnt != path.mnt)
+		mntput(nd->path.mnt);
+	nd->path = path;
+	return 0;
+
+exit_dput:
+	dput(path.dentry);
+	if (path.mnt != nd->path.mnt)
+		mntput(path.mnt);
+	return err;
+}
+
+/*
  * This must be called when unhashing a dentry. This is called with dcache_lock
  * and unhashes all unions this dentry is in.
  */
diff --git a/include/linux/union.h b/include/linux/union.h
index 0b6f356..405baa9 100644
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -53,6 +53,10 @@ extern void __shrink_d_unions(struct dentry *, struct list_head *);
 extern int attach_mnt_union(struct vfsmount *, struct vfsmount *,
 			    struct dentry *);
 extern void detach_mnt_union(struct vfsmount *);
+extern struct dentry *union_create_topmost(struct nameidata *, struct qstr *,
+					   struct path *);
+extern int __union_copyup(struct path *, struct nameidata *, struct path *);
+extern int union_copyup(struct nameidata *, int);
 
 #else /* CONFIG_UNION_MOUNT */
 
@@ -67,6 +71,9 @@ extern void detach_mnt_union(struct vfsmount *);
 #define __shrink_d_unions(x,y)		do { } while (0)
 #define attach_mnt_union(x, y, z)	do { } while (0)
 #define detach_mnt_union(x)		do { } while (0)
+#define union_create_topmost(x, y, z)	({ BUG(); (NULL); })
+#define __union_copyup(x, y, z)		({ BUG(); (0); })
+#define union_copyup(x, y)		({ (0); })
 
 #endif	/* CONFIG_UNION_MOUNT */
 #endif	/* __KERNEL__ */
-- 
1.6.1.3

