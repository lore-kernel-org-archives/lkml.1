Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbZJUTVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbZJUTVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbZJUTVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:21:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754917AbZJUTVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:21:14 -0400
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
       Bharata B Rao <bharata@in.ibm.com>, Jan Blunck <jblunck@suse.de>
Subject: [PATCH 27/41] union-mount: in-kernel file copy between union mounted filesystems
Date: Wed, 21 Oct 2009 12:19:25 -0700
Message-Id: <1256152779-10054-28-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-27-git-send-email-vaurora@redhat.com>
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
 <1256152779-10054-14-git-send-email-vaurora@redhat.com>
 <1256152779-10054-15-git-send-email-vaurora@redhat.com>
 <1256152779-10054-16-git-send-email-vaurora@redhat.com>
 <1256152779-10054-17-git-send-email-vaurora@redhat.com>
 <1256152779-10054-18-git-send-email-vaurora@redhat.com>
 <1256152779-10054-19-git-send-email-vaurora@redhat.com>
 <1256152779-10054-20-git-send-email-vaurora@redhat.com>
 <1256152779-10054-21-git-send-email-vaurora@redhat.com>
 <1256152779-10054-22-git-send-email-vaurora@redhat.com>
 <1256152779-10054-23-git-send-email-vaurora@redhat.com>
 <1256152779-10054-24-git-send-email-vaurora@redhat.com>
 <1256152779-10054-25-git-send-email-vaurora@redhat.com>
 <1256152779-10054-26-git-send-email-vaurora@redhat.com>
 <1256152779-10054-27-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces in-kernel file copy between union mounted
filesystems. When a file is opened for writing but resides on a lower (thus
read-only) layer of the union stack it is copied to the topmost union layer
first.

This patch uses the do_splice() for doing the in-kernel file copy.

XXX - Optimize for non-union mounts in union mount enabled kernels
(esp. call to is_unionized() in do_filp_open()).

XXX - "flags" argument to union_copyup() is unused - bug?  Leftover
code?

Signed-off-by: Bharata B Rao <bharata@in.ibm.com>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c            |   64 +++++++++-
 fs/union.c            |  316 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/union.h |    7 +
 3 files changed, 383 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index fb463ac..f7ef769 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1050,7 +1050,7 @@ static int __follow_mount(struct path *path)
 	return res;
 }
 
-static void follow_mount(struct path *path)
+void follow_mount(struct path *path)
 {
 	while (d_mountpoint(path->dentry)) {
 		struct vfsmount *mounted = lookup_mnt(path);
@@ -1284,6 +1284,21 @@ static int __link_path_walk(const char *name, struct nameidata *nd)
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
@@ -1333,6 +1348,22 @@ last_component:
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
@@ -1709,7 +1740,7 @@ out:
 	return err;
 }
 
-static int hash_lookup_union(struct nameidata *nd, struct qstr *name,
+int hash_lookup_union(struct nameidata *nd, struct qstr *name,
 			     struct path *path)
 {
 	struct path safe = { .dentry = nd->path.dentry, .mnt = nd->path.mnt };
@@ -2208,6 +2239,12 @@ struct file *do_filp_open(int dfd, const char *pathname,
 					 &nd, flag);
 		if (error)
 			return ERR_PTR(error);
+		if (unlikely(flag & FMODE_WRITE)) {
+			/* Check for union, etc. in union_copyup */
+			error = union_copyup(&nd, flag /* XXX not used */);
+			if (error)
+				return ERR_PTR(error);
+		}
 		goto ok;
 	}
 
@@ -2311,10 +2348,23 @@ do_last:
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
+	if (path.dentry->d_inode &&
+	    (path.dentry->d_parent != dir) &&
+	    S_ISREG(path.dentry->d_inode->i_mode)) {
+		error = __union_copyup(&path, &nd, &path);
+		if (error)
+			goto exit_dput;
+	}
+
+	path_to_nameidata(&path, &nd);
 ok:
 	/*
 	 * Consider:
@@ -3472,6 +3522,12 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
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
index 341fc03..de31fc9 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -21,6 +21,14 @@
 #include <linux/mount.h>
 #include <linux/fs_struct.h>
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
@@ -337,6 +345,314 @@ int follow_union_mount(struct vfsmount **mnt, struct dentry **dentry)
 }
 
 /*
+ * Union mount copyup support
+ */
+
+extern int hash_lookup_union(struct nameidata *, struct qstr *, struct path *);
+extern void follow_mount(struct path *path);
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
+	res = mnt_want_write(nd->path.mnt);
+	if (res)
+		return ERR_PTR(res);
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
+ out_unlock:
+	mutex_unlock(&parent->d_inode->i_mutex);
+	mnt_drop_write(nd->path.mnt);
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
+		mutex_lock(&new_nd->path.dentry->d_inode->i_mutex);
+		dentry = lookup_one_len(new->dentry->d_name.name,
+					new_nd->path.dentry,
+					new->dentry->d_name.len);
+		mutex_unlock(&new_nd->path.dentry->d_inode->i_mutex);
+		if (IS_ERR(dentry))
+			return PTR_ERR(dentry);
+		error = -EEXIST;
+		if (dentry->d_inode)
+			goto out_dput;
+	} else
+		dentry = dget(new->dentry);
+
+	error = mnt_want_write(new_nd->path.mnt);
+	if (error)
+		goto out_dput;
+
+	if (!dentry->d_inode) {
+		error = vfs_create(new_nd->path.dentry->d_inode, dentry,
+				   old->dentry->d_inode->i_mode, new_nd);
+		if (error)
+			goto out_drop_write;
+	}
+
+	BUG_ON(!S_ISREG(old->dentry->d_inode->i_mode));
+	error = union_copy_file(old->dentry, old->mnt, dentry,
+				new_nd->path.mnt);
+	if (error) {
+		/* FIXME: are there return value we should not
+		 * BUG() on ? */
+		BUG_ON(vfs_unlink(new_nd->path.dentry->d_inode,
+				  dentry));
+		goto out_drop_write;
+	}
+
+	mnt_drop_write(new_nd->path.mnt);
+	dput(new->dentry);
+	new->dentry = dentry;
+	if (new->mnt != new_nd->path.mnt)
+		mntput(new->mnt);
+	new->mnt = new_nd->path.mnt;
+	return error;
+
+out_drop_write:
+	mnt_drop_write(new_nd->path.mnt);
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
+	follow_mount(&path);
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
1.6.3.3

