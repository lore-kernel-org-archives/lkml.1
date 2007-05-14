Return-Path: <linux-kernel-owner+w=401wt.eu-S1762422AbXENJgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762422AbXENJgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966142AbXENJgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:36:07 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57815 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966123AbXENJgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:36:03 -0400
Date: Mon, 14 May 2007 15:13:29 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: [RFC][PATCH 10/14] In-kernel file copy between union mounted filesystems
Message-ID: <20070514094329.GL4139@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070514093722.GB4139@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514093722.GB4139@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <j.blunck@tu-harburg.de>
Subject: In-kernel file copy between union mounted filesystems

This patch introduces in-kernel file copy between union mounted
filesystems. When a file is opened for writing but resides on a lower (thus
read-only) layer of the union stack it is copied to the topmost union layer
first.

This patch uses the do_splice_direct() for doing the in-kernel file copy.

Signed-off-by: Bharata B Rao <bharata@in.ibm.com>
Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
---
 fs/namei.c            |   46 +++++
 fs/union.c            |  415 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/namei.h |    2 
 include/linux/union.h |   14 +
 4 files changed, 476 insertions(+), 1 deletion(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -830,8 +830,17 @@ done:
 	path->mnt = mnt;
 	path->dentry = dentry;
 
-	if (nd->dentry->d_sb != dentry->d_sb)
+	/*
+	 * This should be checked after the following of unions.
+	 * Otherwise we might run into trouble creating directories
+	 * on mountpoints. :(
+	 * But maybe we shouldn't set the LAST_LOWLEVEL flag here
+	 * at all ... */
+	if (nd->dentry->d_sb != dentry->d_sb) {
 		path->mnt = find_mnt(dentry);
+		UM_DEBUG_UID("Setting LAST_LOWLEVEL for %s\n", name->name);
+		nd->um_flags |= LAST_LOWLEVEL;
+	}
 
 	__follow_mount(path);
 	follow_union_mount(&path->mnt, &path->dentry);
@@ -950,6 +959,14 @@ static fastcall int __link_path_walk(con
 		if (err)
 			break;
 
+		if ((nd->flags & LOOKUP_TOPMOST) &&
+		    (nd->um_flags & LAST_LOWLEVEL)) {
+			err = union_create_topdir(nd,&next.dentry,&next.mnt);
+			if (err)
+				goto out_dput;
+			nd->um_flags &= ~LAST_LOWLEVEL;
+		}
+
 		err = -ENOENT;
 		inode = next.dentry->d_inode;
 		if (!inode)
@@ -1005,6 +1022,15 @@ last_component:
 		err = do_lookup(nd, &this, &next);
 		if (err)
 			break;
+
+		if ((nd->flags & LOOKUP_TOPMOST) &&
+		    (nd->um_flags & LAST_LOWLEVEL)) {
+			err = union_create_topdir(nd,&next.dentry,&next.mnt);
+			if (err)
+				goto out_dput;
+			nd->um_flags &= ~LAST_LOWLEVEL;
+		}
+
 		inode = next.dentry->d_inode;
 		if ((lookup_flags & LOOKUP_FOLLOW)
 		    && inode && inode->i_op && inode->i_op->follow_link) {
@@ -1177,6 +1203,7 @@ static int fastcall do_path_lookup(int d
 
 	nd->last_type = LAST_ROOT; /* if there are only slashes... */
 	nd->flags = flags;
+	nd->um_flags = 0;
 	nd->depth = 0;
 
 	if (*name=='/') {
@@ -1756,9 +1783,18 @@ int open_namei(int dfd, const char *path
 					 nd, flag);
 		if (error)
 			return error;
+		/* test for WRONLY and RDWR - flag's special lower bits */
+		if (flag & 0x2) {
+			UM_DEBUG_UID("\"%s\" opened for writing\n", pathname);
+			error = union_copyup(nd, flag);
+			if (error)
+				return error;
+		}
 		goto ok;
 	}
 
+	UM_DEBUG_UID("open called with O_CREATE\n");
+
 	/*
 	 * Create - we need to know the parent.
 	 */
@@ -1775,6 +1811,8 @@ int open_namei(int dfd, const char *path
 	if (nd->last_type != LAST_NORM || nd->last.name[nd->last.len])
 		goto exit;
 
+	UM_DEBUG_UID("do_last now\n");
+
 	dir = nd->dentry;
 	nd->flags &= ~LOOKUP_PARENT;
 	mutex_lock(&dir->d_inode->i_mutex);
@@ -1828,6 +1866,12 @@ do_last:
 	error = -EISDIR;
 	if (path.dentry->d_inode && S_ISDIR(path.dentry->d_inode->i_mode))
 		goto exit;
+
+	if (flag & 0x2) {
+		error = union_copyup(nd, flag);
+		if (error)
+			goto exit;
+	}
 ok:
 	error = may_open(nd, acc_mode, flag);
 	if (error)
--- a/fs/union.c
+++ b/fs/union.c
@@ -15,6 +15,11 @@
 #include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/file.h>
+#include <linux/mm.h>
+#include <linux/quotaops.h>
+#include <linux/dnotify.h>
+#include <linux/security.h>
+#include <linux/pipe_fs_i.h>
 
 struct union_info * union_alloc(void)
 {
@@ -305,6 +310,53 @@ void __dput_union(struct dentry *dentry)
 	return;
 }
 
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
+	UM_DEBUG_UID("relookup the topmost dir for %s\n",
+		     nd->dentry->d_name.name);
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
+	/* If we are looking up the parent, copy the child details also */
+	if (flags & LOOKUP_PARENT) {
+		nd->last = this.last;
+		nd->last_type = this.last_type;
+	}
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
 void attach_mnt_union(struct vfsmount *mnt, struct nameidata *nd)
 {
 	struct dentry *tmp;
@@ -975,6 +1027,37 @@ int follow_union_mount(struct vfsmount *
 }
 
 /*
+ * @stack is a already existing union stack, @new is a dentry or a union stack
+ * which is overlaid by @stack. So the topmost dentry is in @stack.
+ */
+static void append_to_stack(struct dentry *stack, struct dentry *new)
+{
+	struct dentry *topmost;
+	struct dentry *prev = stack;
+	struct dentry *next = new;
+
+	BUG_ON(!stack);
+	BUG_ON(!new);
+
+	while (prev->d_overlaid)
+		prev = prev->d_overlaid;
+
+	if (prev->d_topmost)
+		topmost = prev->d_topmost;
+	else
+		topmost = stack;
+
+	while (next) {
+		next->d_topmost = topmost;
+		prev->d_overlaid = next;
+		prev = next;
+		next = next->d_overlaid;
+	}
+
+	return;
+}
+
+/*
  * Union mounts support for readdir.
  */
 
@@ -1372,3 +1455,335 @@ loff_t union_dir_llseek(struct file *fil
 	}
 	return -EINVAL;
 }
+
+/*
+ * Union mount copyup support
+ */
+
+/*
+ * Just do what vfs_create() would do, but the union mount way
+ */
+static struct dentry * union_create(struct dentry *parent, struct dentry *old,
+				    struct nameidata *nd)
+{
+	struct dentry *dentry;
+	int err, mode;
+
+	dentry = __lookup_hash_single(&old->d_name, parent, NULL);
+	if (IS_ERR(dentry))
+		goto exit;
+
+	err = -EEXIST;
+	if (dentry->d_inode) {
+		dput(dentry);
+		goto error;
+	}
+
+	err = -ENOENT;
+	if (IS_DEADDIR(parent->d_inode))
+		goto error;
+	err = -EACCES;	/* shouldn't it be ENOSYS? */
+	if (!parent->d_inode->i_op || !parent->d_inode->i_op->create)
+		goto error;
+
+	mode = old->d_inode->i_mode & S_IALLUGO;
+	mode |= S_IFREG;
+
+	err = security_inode_create(parent->d_inode, dentry, mode);
+	if (err)
+		goto error;
+
+	DQUOT_INIT(parent->d_inode);
+	err = parent->d_inode->i_op->create(parent->d_inode, dentry, mode, nd);
+	if (err)
+		goto error;
+
+	dentry->d_inode->i_uid = old->d_inode->i_uid;
+	dentry->d_inode->i_gid = old->d_inode->i_gid;
+	mark_inode_dirty(dentry->d_inode);
+exit:
+	return dentry;
+error:
+	return ERR_PTR(err);
+}
+
+/*
+ * Just do what vfs_mkdir() would do, but the union mount way
+ */
+static struct dentry * union_mkdir(struct dentry *parent, struct dentry *dir)
+{
+	struct dentry *dentry;
+	int err, mode;
+
+	dentry = __lookup_hash_single(&dir->d_name, parent, NULL);
+	if (IS_ERR(dentry))
+		goto exit;
+
+	err = -EEXIST;
+	if (dentry->d_inode) {
+		dput(dentry);
+		goto error;
+	}
+
+	err = -ENOENT;
+	if (IS_DEADDIR(parent->d_inode))
+		goto error;
+	err = -EPERM;
+	if (!parent->d_inode->i_op || !parent->d_inode->i_op->mkdir)
+		goto error;
+
+	mode = dir->d_inode->i_mode & (S_IRWXUGO|S_ISVTX);
+
+	err = security_inode_mkdir(parent->d_inode, dentry, mode);
+	if (err)
+		goto error;
+
+	DQUOT_INIT(parent->d_inode);
+	err = parent->d_inode->i_op->mkdir(parent->d_inode, dentry, mode);
+	if (err)
+		goto error;
+
+	dentry->d_inode->i_uid = dir->d_inode->i_uid;
+	dentry->d_inode->i_gid = dir->d_inode->i_gid;
+	mark_inode_dirty(dentry->d_inode);
+exit:
+	return dentry;
+error:
+	return ERR_PTR(err);
+}
+
+static void __update_fs_pwd(struct dentry *old, struct dentry *new)
+{
+	struct dentry *old_pwd = NULL;
+	struct vfsmount *old_pwdmnt = NULL;
+	struct vfsmount *new_pwdmnt = find_mnt(new);
+
+	write_lock(&current->fs->lock);
+	if (current->fs->pwd == old) {
+		old_pwd = current->fs->pwd;
+		old_pwdmnt = current->fs->pwdmnt;
+		current->fs->pwdmnt = mntget(new_pwdmnt);
+		current->fs->pwd = __dget(new);
+		UM_DEBUG_UID("replacing fs->pwd\n");
+		UM_DEBUG_UID("oldpwd: name=\"%s\", inode=%p, devname=%s\n",
+			     old_pwd->d_name.name, old_pwd->d_inode,
+			     old_pwdmnt->mnt_devname);
+		UM_DEBUG_UID("newpwd: name=\"%s\", inode=%p, devname=%s\n",
+			     new->d_name.name, new->d_inode,
+			     new_pwdmnt->mnt_devname);
+	}
+	write_unlock(&current->fs->lock);
+
+	if (old_pwd) {
+		__dput(old_pwd);
+		mntput(old_pwdmnt);
+	}
+
+	mntput(new_pwdmnt);
+
+	return;
+}
+
+struct dentry * union_create_topmost(struct nameidata *nd, struct dentry *old)
+{
+	struct dentry *dentry;
+	struct dentry *parent = nd->dentry;
+
+	UM_DEBUG_UID("dentry=%s\n", old->d_name.name);
+
+	BUG_ON(parent->d_sb == old->d_sb);
+	if (!S_ISREG(old->d_inode->i_mode)) {
+		UM_DEBUG("This filetype isn't supported!\n");
+		dentry = ERR_PTR(-EINVAL);
+		goto exit;
+	}
+
+	/*
+	 * Create the topmost regular file here.
+	 */
+	mutex_lock(&parent->d_inode->i_mutex);
+	dentry = union_create(parent, old, nd);
+	mutex_unlock(&parent->d_inode->i_mutex);
+	if (IS_ERR(dentry)) {
+		UM_DEBUG("some error occurred\n");
+		goto exit;
+	}
+
+exit:
+	return dentry;
+}
+
+int union_create_topdir(struct nameidata *nd,
+			struct dentry **dentry, struct vfsmount **mnt)
+{
+	struct dentry *topdir;
+	struct dentry *parent = nd->dentry;
+
+	UM_DEBUG_UID("dentry=%s\n", (*dentry)->d_name.name);
+
+	if (parent->d_sb == (*dentry)->d_sb)
+		return 0;
+
+	if (!S_ISDIR((*dentry)->d_inode->i_mode)) {
+		UM_DEBUG("Unsupported filetype!\n");
+		BUG();
+	}
+
+	/*
+	 * Create the topmost directory here.
+	 */
+	spin_lock(&(*dentry)->d_lock);
+	if (!(*dentry)->d_union) {
+		UM_DEBUG_LOCK("Allocate lock for \"%s\"\n",
+			      (*dentry)->d_name.name);
+		(*dentry)->d_union = union_alloc();
+		spin_unlock(&(*dentry)->d_lock);
+	} else {
+		spin_unlock(&(*dentry)->d_lock);
+		union_lock(*dentry);
+	}
+	mutex_lock(&parent->d_inode->i_mutex);
+	topdir = union_mkdir(parent, *dentry);
+	if (IS_ERR(topdir)) {
+		UM_DEBUG("some error occurred\n");
+		mutex_unlock(&parent->d_inode->i_mutex);
+		union_unlock(*dentry);
+		return PTR_ERR(topdir);
+	}
+
+	spin_lock(&topdir->d_lock);
+	if (topdir->d_union) {
+		UM_DEBUG("Aaargh! topdir \"%s\" already has a lock?!\n",
+			 topdir->d_name.name);
+		dump_stack();
+	}
+	topdir->d_union = union_get((*dentry)->d_union);
+	spin_unlock(&topdir->d_lock);
+	append_to_stack(topdir, *dentry);
+	__update_fs_pwd(*dentry, topdir);
+	*dentry = topdir;
+	mutex_unlock(&parent->d_inode->i_mutex);
+	union_unlock(*dentry);
+
+	if (nd->mnt != *mnt) {
+		mntput(*mnt);
+		*mnt = mntget(nd->mnt);
+	}
+
+	return 0;
+}
+
+int union_copy_file(struct dentry *old_dentry, struct vfsmount *old_mnt,
+		    struct dentry *new_dentry, struct vfsmount *new_mnt)
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
+ * union_copyup - copy a file to the topmost layer of the union stack
+ * @nd: nameidata pointer to the file
+ * @flags: flags given to open_namei
+ */
+int union_copyup(struct nameidata *nd, int flags)
+{
+	struct dentry *dir;
+	struct dentry *dentry;
+	int err;
+
+	if (!union_is_member(nd->dentry, nd->mnt))
+		return 0;
+	if (!S_ISREG(nd->dentry->d_inode->i_mode))
+		return 0;
+
+	err = union_relookup_topmost(nd, nd->flags|LOOKUP_PARENT);
+	if (err)
+		return err;
+
+	dir = nd->dentry;
+	nd->flags &= ~LOOKUP_PARENT;
+	union_lock(nd->dentry);
+	mutex_lock(&dir->d_inode->i_mutex);
+	dentry = __lookup_hash_kern_union(&nd->last, nd->dentry, nd);
+	err = PTR_ERR(dentry);
+	if (IS_ERR(dentry)) {
+		mutex_unlock(&dir->d_inode->i_mutex);
+		union_unlock(nd->dentry);
+		return err;
+	}
+
+	mutex_unlock(&dir->d_inode->i_mutex);
+	union_unlock(nd->dentry);
+
+	err = -ENOENT;
+	if (!dentry->d_inode)
+		goto exit_dput;
+
+	follow_mount(&nd->mnt, &dentry);
+
+	err = -ENOENT;
+	if (!dentry->d_inode)
+		goto exit_dput;
+
+	if (dentry->d_parent != dir) {
+		struct dentry *tmp;
+		struct vfsmount *old_mnt;
+
+		UM_DEBUG_UID("already exists -> copy file\n");
+		tmp = union_create_topmost(nd, dentry);
+		if (IS_ERR(tmp))
+			goto exit_dput;
+
+		old_mnt = find_mnt(dentry);
+		err = union_copy_file(dentry, old_mnt, tmp, nd->mnt);
+		if (err) {
+			int ret = vfs_unlink(tmp->d_inode, tmp);
+			BUG_ON(ret);
+			/* FIXME: not sure if there are return value
+			 * we should not BUG() on */
+		}
+		dput(dentry);
+		dentry = tmp;
+		mntput(old_mnt);
+	}
+
+	dput(nd->dentry);
+	nd->dentry = dentry;
+	return 0;
+
+exit_dput:
+	dput(dentry);
+	return err;
+}
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -59,6 +59,8 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LA
 #define LOOKUP_PARENT		16
 #define LOOKUP_NOALT		32
 #define LOOKUP_REVAL		64
+#define LOOKUP_TOPMOST	       128
+#define LOOKUP_WHT	       256
 /*
  * Intent data
  */
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -35,11 +35,25 @@ extern int readdir_union(struct file *, 
 
 extern loff_t union_dir_llseek(struct file *, loff_t, int);
 
+/* copy-up support */
+extern struct dentry * union_create_topmost(struct nameidata *, struct dentry *);
+extern int union_create_topdir(struct nameidata *, struct dentry **, struct vfsmount **);
+extern int union_is_member(struct dentry *, struct vfsmount *);
+extern int union_copy_file(struct dentry *, struct vfsmount *, struct dentry *, struct vfsmount *);
+extern int union_copyup(struct nameidata *, int);
+extern int union_relookup_topmost(struct nameidata *, int);
+
 #else	/* CONFIG_UNION_MOUNT */
 
 #define attach_mnt_union(mnt,nd) do { /* empty */ } while (0)
 #define detach_mnt_union(mnt,nd) do { /* empty */ } while (0)
 #define follow_union_mount(x,y) do { /* empty */ } while (0)
+#define union_create_topmost(x,y) ({ BUG(); ERR_PTR(-EINVAL); })
+#define union_create_topdir(x,y,z) ({ (0); })
+#define union_is_member(x,y) ({ (0); })
+#define union_copy_file(dentry1,mnt1,dentry2,mnt2) ({ (0); })
+#define union_copyup(x,y) ({ (0); })
+#define union_relookup_topmost(x,y) ({ (0); })
 
 #endif	/* CONFIG_UNION_MOUNT */
 
