Return-Path: <linux-kernel-owner+w=401wt.eu-S965927AbXENJhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965927AbXENJhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966227AbXENJgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:36:41 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48875 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966218AbXENJgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:36:37 -0400
Date: Mon, 14 May 2007 15:13:58 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: [RFC][PATCH 11/14] VFS whiteout handling
Message-ID: <20070514094358.GM4139@in.ibm.com>
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
Subject: VFS whiteout handling

Introduce white-out handling in the VFS.

Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 fs/inode.c            |   17 +
 fs/namei.c            |  476 ++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/readdir.c          |   10 +
 fs/union.c            |  104 ++++++++++
 include/linux/fs.h    |    4 
 include/linux/union.h |    6 
 6 files changed, 605 insertions(+), 12 deletions(-)

--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1421,6 +1421,21 @@ void __init inode_init(unsigned long mem
 		INIT_HLIST_HEAD(&inode_hashtable[loop]);
 }
 
+/*
+ * Dummy default file-operations:
+ * Never open a whiteout. This is always a bug.
+ */
+static int whiteout_no_open(struct inode *irrelevant, struct file *dontcare)
+{
+	printk("Attemp to open a whiteout!\n");
+	WARN_ON(1);
+	return -ENXIO;
+}
+
+static struct file_operations def_wht_fops = {
+	.open		= whiteout_no_open,
+};
+
 void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
 {
 	inode->i_mode = mode;
@@ -1434,6 +1449,8 @@ void init_special_inode(struct inode *in
 		inode->i_fop = &def_fifo_fops;
 	else if (S_ISSOCK(mode))
 		inode->i_fop = &bad_sock_fops;
+	else if (S_ISWHT(mode))
+		inode->i_fop = &def_wht_fops;
 	else
 		printk(KERN_DEBUG "init_special_inode: bogus i_mode (%o)\n",
 		       mode);
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -969,7 +969,7 @@ static fastcall int __link_path_walk(con
 
 		err = -ENOENT;
 		inode = next.dentry->d_inode;
-		if (!inode)
+		if (!inode || S_ISWHT(inode->i_mode))
 			goto out_dput;
 		err = -ENOTDIR; 
 		if (!inode->i_op)
@@ -1043,6 +1043,12 @@ last_component:
 		err = -ENOENT;
 		if (!inode)
 			break;
+		if (S_ISWHT(inode->i_mode)) {
+			UM_DEBUG_UID("found a whiteout\n");
+			break;
+			//if (!(nd->flags & LOOKUP_WHT))
+			//    break;
+		}
 		if (lookup_flags & LOOKUP_DIRECTORY) {
 			err = -ENOTDIR; 
 			if (!inode->i_op || !inode->i_op->lookup)
@@ -1556,7 +1562,7 @@ static int may_delete(struct inode *dir,
 static inline int may_create(struct inode *dir, struct dentry *child,
 			     struct nameidata *nd)
 {
-	if (child->d_inode)
+	if (child->d_inode && !S_ISWHT(child->d_inode->i_mode))
 		return -EEXIST;
 	if (IS_DEADDIR(dir))
 		return -ENOENT;
@@ -1623,6 +1629,82 @@ void unlock_rename(struct dentry *p1, st
 	}
 }
 
+/*
+ * __vfs_unlink_whiteout - Unlink a single whiteout from the system
+ * @dir: parent directory
+ * @dentry: the whiteout itself
+ *
+ * This is for unlinking a single whiteout. Don't use vfs_unlink() because we
+ * don't want any notification stuff etc. but basically it is the same stuff.
+ */
+static int
+__vfs_unlink_whiteout(struct inode *dir, struct dentry *dentry)
+{
+	int error = may_delete(dir, dentry, 0);
+
+	if (error)
+		return error;
+
+	if (!dir->i_op || !dir->i_op->unlink)
+		return -EPERM;
+
+	DQUOT_INIT(dir);
+
+	mutex_lock(&dentry->d_inode->i_mutex);
+	if (d_mountpoint(dentry))
+		error = -EBUSY;
+	else {
+		error = security_inode_unlink(dir, dentry);
+		if (!error)
+			error = dir->i_op->unlink(dir, dentry);
+	}
+	mutex_unlock(&dentry->d_inode->i_mutex);
+
+	/* We don't d_delete() NFS sillyrenamed files--they still exist. */
+	if (!error && !(dentry->d_flags & DCACHE_NFSFS_RENAMED)) {
+		d_delete(dentry);
+		//inode_dir_notify(dir, DN_DELETE);
+	}
+	return error;
+}
+
+/*
+ * vfs_unlink_whiteout - unlink and relookup the whiteout
+ *
+ * This is what you want to call from vfs_* functions to remove a whiteout. It
+ * unlinks the whiteout dentry and relookups it afterwards.
+ */
+static int
+vfs_unlink_whiteout(struct inode *dir, struct dentry **dp)
+{
+	struct dentry *dentry = *dp;
+	struct dentry *parent = dentry->d_parent;
+	struct qstr name;
+	int error;
+
+	BUG_ON(dir != parent->d_inode);
+
+	error = -ENOMEM;
+	name.name = kmalloc(dentry->d_name.len, GFP_KERNEL);
+	if (!name.name)
+		goto out;
+	strncpy((char *)name.name, dentry->d_name.name, dentry->d_name.len);
+	name.len = dentry->d_name.len;
+	name.hash = dentry->d_name.hash;
+
+	error = __vfs_unlink_whiteout(dir, dentry);
+	if (error)
+		goto out_freename;
+
+	__dput_single(dentry);
+	*dp = __lookup_hash_single(&name, parent, NULL);
+	BUG_ON(IS_ERR(*dp));	/* Hmm, very hard response here */
+out_freename:
+	kfree(name.name);
+out:
+	return error;
+}
+
 int vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 		struct nameidata *nd)
 {
@@ -1638,6 +1720,13 @@ int vfs_create(struct inode *dir, struct
 	error = security_inode_create(dir, dentry, mode);
 	if (error)
 		return error;
+
+	if (dentry->d_inode && S_ISWHT(dentry->d_inode->i_mode)) {
+		error = vfs_unlink_whiteout(dir, &dentry);
+		if (error)
+			return error;
+	}
+
 	DQUOT_INIT(dir);
 	error = dir->i_op->create(dir, dentry, mode, nd);
 	if (!error)
@@ -1833,7 +1922,14 @@ do_last:
 	}
 
 	/* Negative dentry, just create the file */
-	if (!path.dentry->d_inode) {
+	if (!path.dentry->d_inode || S_ISWHT(path.dentry->d_inode->i_mode)) {
+		if (path.dentry->d_parent != dir) {
+			UM_DEBUG_UID("found a lower layers whiteout\n");
+			dput(path.dentry);
+			path.dentry = __lookup_hash_single(&nd->last, dir, nd);
+			goto do_last;
+		}
+
 		error = open_namei_create(nd, &path, flag, mode);
 		if (error)
 			goto exit;
@@ -1949,6 +2045,17 @@ do_link:
 struct dentry *lookup_create(struct nameidata *nd, int is_dir)
 {
 	struct dentry *dentry = ERR_PTR(-EEXIST);
+	int error;
+
+	if (union_is_member(nd->dentry, nd->mnt)) {
+		error = union_relookup_topmost(nd, nd->flags & ~LOOKUP_PARENT);
+		if (error) {
+			/* FIXME: This really sucks */
+			mutex_lock_nested(&nd->dentry->d_inode->i_mutex,
+					  I_MUTEX_PARENT);
+			goto fail;
+		}
+	}
 
 	mutex_lock_nested(&nd->dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	/*
@@ -1968,6 +2075,15 @@ struct dentry *lookup_create(struct name
 	if (IS_ERR(dentry))
 		goto fail;
 
+	/* Special case - we found a whiteout */
+	if (dentry->d_inode && S_ISWHT(dentry->d_inode->i_mode)) {
+		if (dentry->d_parent != nd->dentry) {
+			UM_DEBUG_UID("found a lower layers whiteout\n");
+			dput(dentry);
+			dentry = __lookup_hash_single(&nd->last,nd->dentry,nd);
+		}
+	}
+
 	/*
 	 * Special case - lookup gave negative, but... we had foo/bar/
 	 * From the vfs_mknod() POV we just have a negative dentry -
@@ -2002,6 +2118,12 @@ int vfs_mknod(struct inode *dir, struct 
 	if (error)
 		return error;
 
+	if (dentry->d_inode && S_ISWHT(dentry->d_inode->i_mode)) {
+		error = vfs_unlink_whiteout(dir, &dentry);
+		if (error)
+			return error;
+	}
+
 	DQUOT_INIT(dir);
 	error = dir->i_op->mknod(dir, dentry, mode, dev);
 	if (!error)
@@ -2067,6 +2189,7 @@ asmlinkage long sys_mknod(const char __u
 int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
 	int error = may_create(dir, dentry, NULL);
+	int opaque;
 
 	if (error)
 		return error;
@@ -2079,10 +2202,23 @@ int vfs_mkdir(struct inode *dir, struct 
 	if (error)
 		return error;
 
+	if (dentry->d_inode && S_ISWHT(dentry->d_inode->i_mode)) {
+		error = vfs_unlink_whiteout(dir, &dentry);
+		if (error)
+			return error;
+		opaque = 1;
+	} else
+		opaque = 0;
+
 	DQUOT_INIT(dir);
 	error = dir->i_op->mkdir(dir, dentry, mode);
-	if (!error)
+	if (!error) {
 		fsnotify_mkdir(dir, dentry);
+#ifdef CONFIG_UNION_MOUNT
+		if (opaque && dentry->d_parent->d_overlaid)
+			dentry->d_inode->i_flags |= S_OPAQUE;
+#endif
+	}
 	return error;
 }
 
@@ -2124,6 +2260,225 @@ asmlinkage long sys_mkdir(const char __u
 	return sys_mkdirat(AT_FDCWD, pathname, mode);
 }
 
+/* Checks on the victiom for whiteout */
+static inline int may_whiteout(struct dentry *victim, int isdir)
+{
+	if (!victim->d_inode || S_ISWHT(victim->d_inode->i_mode))
+		return -ENOENT;
+	if (IS_APPEND(victim->d_inode) || IS_IMMUTABLE(victim->d_inode))
+		return -EPERM;
+	if (isdir) {
+		if (!S_ISDIR(victim->d_inode->i_mode))
+			return -ENOTDIR;
+		if (IS_ROOT(victim))
+			return -EBUSY;
+		if (!union_dir_is_empty(victim))
+			return -ENOTEMPTY;
+	} else if (S_ISDIR(victim->d_inode->i_mode))
+		return -EISDIR;
+	if (victim->d_flags & DCACHE_NFSFS_RENAMED)
+		return -EBUSY;
+	return 0;
+}
+
+/*
+ * We try to whiteout a dentry. dir is the parent of the whiteout.
+ * Whiteouts can be vfs_unlink'ed.
+ */
+int vfs_whiteout(struct inode *dir, struct dentry *dentry)
+{
+	int err;
+
+	BUG_ON(dentry->d_parent->d_inode != dir);
+
+	/* from may_create() */
+	if (dentry->d_inode)
+		return -EEXIST;
+	if (IS_DEADDIR(dir))
+		return -ENOENT;
+	err = permission(dir, MAY_WRITE | MAY_EXEC, NULL);
+	if (err)
+		return err;
+
+	/* from may_delete() */
+	if (IS_APPEND(dir))
+		return -EPERM;
+	/* We don't call check_sticky() here because d_inode == NULL */
+
+	if (!dir->i_op || !dir->i_op->whiteout)
+		return -EOPNOTSUPP;
+
+	err = dir->i_op->whiteout(dir, dentry);
+	/* Ignore quota and fsnotify */
+	return err;
+}
+
+/*
+ * do_whiteout - whiteout a dentry, either when removing or renaming
+ * @dentry: the dentry to whiteout
+ *
+ * This is called by the VFS when removing or renaming files on an union mount.
+ */
+static int do_whiteout(struct dentry *parent, struct dentry *dentry, int isdir)
+{
+	int err;
+	struct qstr name;
+
+	UM_DEBUG_UID("parent=\"%s\", dentry=\"%s\", isdir=%d\n",
+		     parent->d_name.name, dentry->d_name.name, isdir);
+
+	err = may_whiteout(dentry, isdir);
+	if (err)
+		goto out;
+
+	err = -ENOMEM;
+	name.name = kmalloc(dentry->d_name.len, GFP_KERNEL);
+	if (!name.name)
+		goto out;
+	strncpy((char *)name.name, dentry->d_name.name, dentry->d_name.len);
+	name.len = dentry->d_name.len;
+	name.hash = dentry->d_name.hash;
+
+	/*
+	 * TODO: Should we BUG_ON(dentry->d_parent != parent) ?
+	 */
+	if (dentry->d_parent == parent) {
+		if (isdir)
+			err = vfs_rmdir(parent->d_inode, dentry);
+		else
+			err = vfs_unlink(parent->d_inode, dentry);
+		dput(dentry);
+		if (err)
+			goto out_freename;
+	}
+
+	/*
+	 * Relookup the dentry to whiteout now. By this time, the dentry is
+	 * dput'ed in vfs_rmdir or vfs_unlink and we should find a fresh
+	 * negative dentry.
+	 */
+	dentry = __lookup_hash_single(&name, parent, NULL);
+	err = PTR_ERR(dentry);
+	if (IS_ERR(dentry))
+		goto out_freename;
+
+	err = vfs_whiteout(parent->d_inode, dentry);
+	__dput_single(dentry);
+out_freename:
+	kfree(name.name);
+out:
+	return err;
+}
+
+static int
+__hash_one_len(const char *name, int len, struct qstr *this)
+{
+	unsigned long hash;
+	unsigned int c;
+
+	hash = init_name_hash();
+	while (len--) {
+		c = *(const unsigned char *)name++;
+		if (c == '/' || c == '\0')
+			return -EINVAL;
+		hash = partial_name_hash(c, hash);
+	}
+	this->hash = end_name_hash(hash);
+	return 0;
+}
+
+static int unlink_whiteouts_filldir(void *buf, const char *name, int namlen,
+			   loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct dentry *parent = buf;
+	struct dentry *dentry;
+	struct qstr this;
+	int res;
+
+	switch (namlen) {
+	case 2:
+		if (name[1] != '.')
+			break;
+	case 1:
+		if (name[0] != '.')
+			break;
+		return 0;
+	}
+
+	UM_DEBUG_UID("name=\"%s\", d_type=%d\n", name, d_type);
+
+	if (d_type != DT_WHT)
+		return 0;
+
+	this.name = name;
+	this.len = namlen;
+	res = __hash_one_len(name, namlen, &this);
+	if (res)
+		return res;
+
+	dentry = __lookup_hash_single(&this, parent, NULL);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	res = __vfs_unlink_whiteout(parent->d_inode, dentry);
+	__dput_single(dentry);
+	return res;
+}
+
+/*
+ * do_unlink_whiteouts - remove all whiteouts of an "empty" directory
+ * @dentry: the directories dentry
+ *
+ * Before removing a directory from the file system, we have to make sure
+ * that there are no stale whiteouts in it. Therefore we call readdir() with
+ * a special filldir helper to remove all the whiteouts.
+ *
+ * XXX: Don't call any security and permission checks here (If we aren't
+ * allowed to go here, we shouldn't be here at all). Same with i_mutex, don't
+ * touch it here.
+ */
+static int do_unlink_whiteouts(struct dentry *dentry)
+{
+	struct file *file;
+	struct vfsmount *mnt;
+	struct inode *inode;
+	int res;
+
+	dget(dentry);
+	mnt = find_mnt(dentry);
+
+	/*
+	 * FIXME: This is bad, because we really don't want to open a new
+	 * file in the kernel but readdir needs a file pointer
+	 */
+	file = dentry_open(dentry, mnt, O_RDWR);
+	if (IS_ERR(file)) {
+		printk(KERN_ERR "%s: dentry_open failed (%ld)\n",
+		       __FUNCTION__, PTR_ERR(file));
+		return PTR_ERR(file);
+	}
+
+	inode = file->f_path.dentry->d_inode;
+
+	res = -ENOTDIR;
+	if (!file->f_op || !file->f_op->readdir)
+		goto out_fput;
+
+	res = -ENOENT;
+	if (!IS_DEADDIR(inode)) {
+		res = file->f_op->readdir(file, (void *)file->f_path.dentry,
+					  unlink_whiteouts_filldir);
+		file_accessed(file);
+	}
+out_fput:
+	fput(file);
+	if (unlikely(res))
+		printk(KERN_ERR "%s: readdir failed (%d)\n",
+		       __FUNCTION__, res);
+	return res;
+}
+
+
 /*
  * We try to drop the dentry early: we should have
  * a usage count of 2 if we're the only user of this
@@ -2153,8 +2508,12 @@ void dentry_unhash(struct dentry *dentry
 
 int vfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
-	int error = may_delete(dir, dentry, 1);
+	int error;
 
+	if (!dentry->d_inode || S_ISWHT(dentry->d_inode->i_mode))
+		return -ENOENT;
+
+	error = may_delete(dir, dentry, 1);
 	if (error)
 		return error;
 
@@ -2170,11 +2529,15 @@ int vfs_rmdir(struct inode *dir, struct 
 	else {
 		error = security_inode_rmdir(dir, dentry);
 		if (!error) {
+			error = do_unlink_whiteouts(dentry);
+			if (error)
+				goto out;
 			error = dir->i_op->rmdir(dir, dentry);
 			if (!error)
 				dentry->d_inode->i_flags |= S_DEAD;
 		}
 	}
+ out:
 	mutex_unlock(&dentry->d_inode->i_mutex);
 	if (!error) {
 		d_delete(dentry);
@@ -2215,8 +2578,41 @@ static long do_rmdir(int dfd, const char
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
 		goto exit2;
-	error = vfs_rmdir(nd.dentry->d_inode, dentry);
-	dput(dentry);
+
+	if (!union_is_member(nd.dentry, nd.mnt)) {
+		/* Not a member of union, normal removal */
+		error = vfs_rmdir(nd.dentry->d_inode, dentry);
+		dput(dentry);
+		goto exit2;
+	}
+
+	if (dentry->d_parent == nd.dentry) {
+		/*
+		 * Topmost dentry of the union. Check if there
+		 * is a dentry of same name in the lower layers.
+		 * If so create a whiteout before unlinking.
+		 * Else normal removal.
+		 */
+		if (present_in_lower(dentry, &nd))
+			error = do_whiteout(nd.dentry, dentry, 1);
+		else {
+			error = vfs_rmdir(nd.dentry->d_inode, dentry);
+			dput(dentry);
+		}
+	} else {
+		/*
+		 * Lower layer dentry of the union. Relookup
+		 * the dentry in the top layer(which should return
+		 * a negative dentry) create a whiteout there.
+		 */
+		dput(dentry);
+		dentry = __lookup_hash_single(&nd.last, nd.dentry, &nd);
+		error = PTR_ERR(dentry);
+		if (IS_ERR(dentry))
+			goto exit2;
+		error = vfs_whiteout(nd.dentry->d_inode, dentry);
+		__dput_single(dentry);
+	}
 exit2:
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
 exit1:
@@ -2295,10 +2691,44 @@ static long do_unlinkat(int dfd, const c
 		inode = dentry->d_inode;
 		if (inode)
 			atomic_inc(&inode->i_count);
-		error = vfs_unlink(nd.dentry->d_inode, dentry);
-	exit2:
-		dput(dentry);
+
+		if (!union_is_member(nd.dentry, nd.mnt)) {
+			/* Not a member of union, normal removal */
+			error = vfs_unlink(nd.dentry->d_inode, dentry);
+			dput(dentry);
+			goto exit2;
+		}
+
+		/* TODO: fix this code duplication with do_rmdir() */
+		if (dentry->d_parent == nd.dentry) {
+			/*
+			 * Topmost dentry of the union. Check if there
+			 * is a dentry of same name in the lower layers.
+			 * If so create a whiteout before unlinking.
+			 * Else normal removal.
+			 */
+			if (present_in_lower(dentry, &nd))
+				error = do_whiteout(nd.dentry, dentry, 0);
+			else {
+				error = vfs_unlink(nd.dentry->d_inode, dentry);
+				dput(dentry);
+			}
+		} else {
+			/*
+			 * Lower layer dentry of the union. Relookup
+			 * the dentry in the top layer(which should return
+			 * a negative dentry) create a whiteout there.
+			 */
+			dput(dentry);
+			dentry = __lookup_hash_single(&nd.last, nd.dentry, &nd);
+			error = PTR_ERR(dentry);
+			if (IS_ERR(dentry))
+				goto exit2;
+			error = vfs_whiteout(nd.dentry->d_inode, dentry);
+			__dput_single(dentry);
+		}
 	}
+exit2:
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
 	if (inode)
 		iput(inode);	/* truncate the inode here */
@@ -2311,6 +2741,7 @@ exit:
 slashes:
 	error = !dentry->d_inode ? -ENOENT :
 		S_ISDIR(dentry->d_inode->i_mode) ? -EISDIR : -ENOTDIR;
+	dput(dentry);
 	goto exit2;
 }
 
@@ -2344,6 +2775,12 @@ int vfs_symlink(struct inode *dir, struc
 	if (error)
 		return error;
 
+	if (dentry->d_inode && S_ISWHT(dentry->d_inode->i_mode)) {
+		error = vfs_unlink_whiteout(dir, &dentry);
+		if (error)
+			return error;
+	}
+
 	DQUOT_INIT(dir);
 	error = dir->i_op->symlink(dir, dentry, oldname);
 	if (!error)
@@ -2398,7 +2835,7 @@ int vfs_link(struct dentry *old_dentry, 
 	struct inode *inode = old_dentry->d_inode;
 	int error;
 
-	if (!inode)
+	if (!inode || S_ISWHT(inode->i_mode))
 		return -ENOENT;
 
 	error = may_create(dir, new_dentry, NULL);
@@ -2674,7 +3111,7 @@ static int do_rename(int olddfd, const c
 		goto exit3;
 	/* source must exist */
 	error = -ENOENT;
-	if (!old_dentry->d_inode)
+	if (!old_dentry->d_inode || S_ISWHT(old_dentry->d_inode->i_mode))
 		goto exit4;
 	/* unless the source is a directory trailing slashes give -ENOTDIR */
 	if (!S_ISDIR(old_dentry->d_inode->i_mode)) {
@@ -2696,6 +3133,21 @@ static int do_rename(int olddfd, const c
 	error = -ENOTEMPTY;
 	if (new_dentry == trap)
 		goto exit5;
+	error = -EXDEV;
+	/* renaming of directories on unions isn't implemented, yet */
+	if (union_is_member(old_dentry, oldnd.mnt)) {
+		error = -EOPNOTSUPP;
+		if (S_ISDIR(old_dentry->d_inode->i_mode))
+			goto exit5;
+		error = -EXDEV;
+		if (oldnd.um_flags & LAST_LOWLEVEL)
+			goto exit5;
+	}
+	if (union_is_member(new_dentry, newnd.mnt)) {
+		error = -EXDEV;
+		if (newnd.um_flags & LAST_LOWLEVEL)
+			goto exit5;
+	}
 
 	error = vfs_rename(old_dir->d_inode, old_dentry,
 				   new_dir->d_inode, new_dentry);
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -148,6 +148,11 @@ static int filldir(void * __buf, const c
 	unsigned long d_ino;
 	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 2, sizeof(long));
 
+#ifdef CONFIG_UNION_MOUNT
+	if (d_type == DT_WHT)
+		return 0;
+#endif /* CONFIG_UNION_MOUNT */
+
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
 		return -EINVAL;
@@ -233,6 +238,11 @@ static int filldir64(void * __buf, const
 	struct getdents_callback64 * buf = (struct getdents_callback64 *) __buf;
 	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 1, sizeof(u64));
 
+#ifdef CONFIG_UNION_MOUNT
+	if (d_type == DT_WHT)
+		return 0;
+#endif /* CONFIG_UNION_MOUNT */
+
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
 		return -EINVAL;
--- a/fs/union.c
+++ b/fs/union.c
@@ -594,6 +594,9 @@ lookup_union:
 	if (!S_ISDIR(topmost->d_inode->i_mode))
 		goto out;
 
+	if (IS_OPAQUE(topmost->d_inode))
+		goto out;
+
 	if (!revalidate_union(topmost)) {
 		__dput_single(topmost);
 		topmost = NULL;
@@ -664,6 +667,8 @@ lookup_union:
 		dentry->d_topmost = topmost;
 		last->d_overlaid = dentry;
 		last = dentry;
+		if (IS_OPAQUE(last->d_inode))
+			break;
 		parent = parent->d_overlaid;
 	}
 
@@ -822,6 +827,8 @@ static int __lookup_union(struct dentry 
 	loop:
 		__dput(nd.dentry);
 		mntput(nd.mnt);
+		if (IS_OPAQUE(last->d_inode))
+			break;
 		parent = parent->d_overlaid;
 	}
 
@@ -912,6 +919,9 @@ lookup_union:
 	if (!parent->d_overlaid || !S_ISDIR(topmost->d_inode->i_mode))
 		goto out;
 
+	if (IS_OPAQUE(topmost->d_inode))
+		goto out;
+
 	do {
 		struct vfsmount *mnt = find_mnt(topmost);
 		UM_DEBUG_UID("name=\"%s\", inode=%p, device=%s\n",
@@ -988,6 +998,9 @@ lookup_union:
 	if (!parent->d_overlaid || !S_ISDIR(topmost->d_inode->i_mode))
 		goto out;
 
+	if (IS_OPAQUE(topmost->d_inode))
+		goto out;
+
 	do {
 		struct vfsmount *mnt = find_mnt(topmost);
 		UM_DEBUG_UID("name=\"%s\", inode=%p, device=%s\n",
@@ -1787,3 +1800,94 @@ exit_dput:
 	dput(dentry);
 	return err;
 }
+
+static int
+filldir_dummy(void *__buf, const char *name, int namlen, loff_t offset,
+	      u64 ino, unsigned int d_type)
+{
+	int *is_empty = (int *)__buf;
+
+	switch (namlen) {
+	case 2:
+		if (name[1] != '.')
+			break;
+	case 1:
+		if (name[0] != '.')
+			break;
+		return 0;
+	}
+
+	if (d_type == DT_WHT)
+		return 0;
+
+	(*is_empty) = 0;
+	return 0;
+}
+
+int
+union_dir_is_empty(struct dentry *dentry)
+{
+	struct file *file;
+	struct vfsmount *mnt;
+	int err;
+	int is_empty = 1;
+
+	BUG_ON(!S_ISDIR(dentry->d_inode->i_mode));
+
+	dget(dentry);
+	mnt = find_mnt(dentry);
+
+	file = dentry_open(dentry, mnt, O_RDONLY);
+	if (IS_ERR(file))
+		return 0;
+
+	err = vfs_readdir(file, filldir_dummy, &is_empty);
+	UM_DEBUG("err=%d, is_empty=%d\n", err, is_empty);
+
+	fput(file);
+	return is_empty;
+}
+
+int present_in_lower(struct dentry *dentry, struct nameidata *nd)
+{
+	int err = 0;
+	struct dentry *parent = nd->dentry->d_overlaid;
+	struct dentry *tmp;
+	struct nameidata nd_tmp;
+	struct qstr this;
+
+	this.name = nd->last.name;
+	this.len = nd->last.len;
+
+	while (parent) {
+		this.hash = nd->last.hash;
+		nd_tmp.dentry = dget(parent);
+		nd_tmp.mnt = find_mnt(parent);
+	        mutex_lock(&parent->d_inode->i_mutex);
+		tmp = __lookup_hash_single(&this, nd_tmp.dentry, &nd_tmp);
+		mutex_unlock(&parent->d_inode->i_mutex);
+		/*
+		 * If there is an error in lookup, we return 0 concluding
+		 * that this dentry is not present in lower layers.
+		 */
+		if (IS_ERR(tmp))
+			goto out;
+
+		if (tmp->d_inode) {
+			__dput_single(tmp);
+			err = 1;
+			goto out;
+		}
+
+		__dput_single(tmp);
+		mntput(nd_tmp.mnt);
+		dput(nd_tmp.dentry);
+		parent = parent->d_overlaid;
+	}
+
+	return err;
+out:
+	mntput(nd_tmp.mnt);
+	dput(nd_tmp.dentry);
+	return err;
+}
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -157,6 +157,7 @@ extern int dir_notify_enable;
 #define S_NOCMTIME	128	/* Do not update file c/mtime */
 #define S_SWAPFILE	256	/* Do not truncate: swapon got its bmaps */
 #define S_PRIVATE	512	/* Inode is fs-internal */
+#define S_OPAQUE	1024	/* Directory is opaque */
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system
@@ -190,6 +191,7 @@ extern int dir_notify_enable;
 #define IS_NOCMTIME(inode)	((inode)->i_flags & S_NOCMTIME)
 #define IS_SWAPFILE(inode)	((inode)->i_flags & S_SWAPFILE)
 #define IS_PRIVATE(inode)	((inode)->i_flags & S_PRIVATE)
+#define IS_OPAQUE(inode)	((inode)->i_flags & S_OPAQUE)
 
 /* the read-only stuff doesn't really belong here, but any other place is
    probably as bad and I don't want to create yet another include file. */
@@ -1050,6 +1052,7 @@ extern int vfs_link(struct dentry *, str
 extern int vfs_rmdir(struct inode *, struct dentry *);
 extern int vfs_unlink(struct inode *, struct dentry *);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
+extern int vfs_whiteout(struct inode *, struct dentry *);
 
 /*
  * VFS dentry helper functions.
@@ -1175,6 +1178,7 @@ struct inode_operations {
 	int (*mkdir) (struct inode *,struct dentry *,int);
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (struct inode *,struct dentry *,int,dev_t);
+	int (*whiteout) (struct inode *, struct dentry *);
 	int (*rename) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *);
 	int (*readlink) (struct dentry *, char __user *,int);
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -43,6 +43,10 @@ extern int union_copy_file(struct dentry
 extern int union_copyup(struct nameidata *, int);
 extern int union_relookup_topmost(struct nameidata *, int);
 
+/* vfs whiteout support */
+extern int union_dir_is_empty(struct dentry *);
+extern int present_in_lower(struct dentry *, struct nameidata *);
+
 #else	/* CONFIG_UNION_MOUNT */
 
 #define attach_mnt_union(mnt,nd) do { /* empty */ } while (0)
@@ -54,6 +58,8 @@ extern int union_relookup_topmost(struct
 #define union_copy_file(dentry1,mnt1,dentry2,mnt2) ({ (0); })
 #define union_copyup(x,y) ({ (0); })
 #define union_relookup_topmost(x,y) ({ (0); })
+#define union_dir_is_empty(x) ({ (1); })
+#define present_in_lower(x, y)	({ (0); })
 
 #endif	/* CONFIG_UNION_MOUNT */
 
