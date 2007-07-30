Return-Path: <linux-kernel-owner+w=401wt.eu-S939111AbXG3QQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939111AbXG3QQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938076AbXG3QOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:14:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:40550 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764455AbXG3QOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:05 -0400
Message-Id: <20070730161324.070187663@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:33 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 10/26] VFS white-out handling
Content-Disposition: inline; filename=um/vfs-whiteout.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce white-out handling in the VFS.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/inode.c         |   22 ++
 fs/namei.c         |  417 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/readdir.c       |    6 
 include/linux/fs.h |    7 
 4 files changed, 441 insertions(+), 11 deletions(-)

--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1410,6 +1410,26 @@ void __init inode_init(unsigned long mem
 		INIT_HLIST_HEAD(&inode_hashtable[loop]);
 }
 
+/*
+ * Dummy default file-operations:
+ * Never open a whiteout. This is always a bug.
+ */
+static int whiteout_no_open(struct inode *irrelevant, struct file *dontcare)
+{
+	printk("WARNING: at %s:%d %s(): Attempted to open a whiteout!\n",
+	       __FILE__, __LINE__, __FUNCTION__);
+	/*
+	 * Nobody should ever be able to open a whiteout. On the other hand
+	 * this isn't fatal so lets just print a warning message.
+	 */
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
@@ -1423,6 +1443,8 @@ void init_special_inode(struct inode *in
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
@@ -887,7 +887,7 @@ static fastcall int __link_path_walk(con
 
 		err = -ENOENT;
 		inode = next.dentry->d_inode;
-		if (!inode)
+		if (!inode || S_ISWHT(inode->i_mode))
 			goto out_dput;
 		err = -ENOTDIR; 
 		if (!inode->i_op)
@@ -951,6 +951,8 @@ last_component:
 		err = -ENOENT;
 		if (!inode)
 			break;
+		if (S_ISWHT(inode->i_mode))
+			break;
 		if (lookup_flags & LOOKUP_DIRECTORY) {
 			err = -ENOTDIR; 
 			if (!inode->i_op || !inode->i_op->lookup)
@@ -1434,13 +1436,10 @@ static inline int check_sticky(struct in
  * 10. We don't allow removal of NFS sillyrenamed files; it's handled by
  *     nfs_async_unlink().
  */
-static int may_delete(struct inode *dir,struct dentry *victim,int isdir)
+static int __may_delete(struct inode *dir, struct dentry *victim, int isdir)
 {
 	int error;
 
-	if (!victim->d_inode)
-		return -ENOENT;
-
 	BUG_ON(victim->d_parent->d_inode != dir);
 	audit_inode_child(victim->d_name.name, victim->d_inode, dir);
 
@@ -1466,6 +1465,14 @@ static int may_delete(struct inode *dir,
 	return 0;
 }
 
+static int may_delete(struct inode *dir, struct dentry *victim, int isdir)
+{
+	if (!victim->d_inode || S_ISWHT(victim->d_inode->i_mode))
+		return -ENOENT;
+
+	return __may_delete(dir, victim, isdir);
+}
+
 /*	Check whether we can create an object with dentry child in directory
  *  dir.
  *  1. We can't do it if child already exists (open has special treatment for
@@ -1477,7 +1484,7 @@ static int may_delete(struct inode *dir,
 static inline int may_create(struct inode *dir, struct dentry *child,
 			     struct nameidata *nd)
 {
-	if (child->d_inode)
+	if (child->d_inode && !S_ISWHT(child->d_inode->i_mode))
 		return -EEXIST;
 	if (IS_DEADDIR(dir))
 		return -ENOENT;
@@ -1559,6 +1566,13 @@ int vfs_create(struct inode *dir, struct
 	error = security_inode_create(dir, dentry, mode);
 	if (error)
 		return error;
+
+	if (dentry->d_inode && S_ISWHT(dentry->d_inode->i_mode)) {
+		error = vfs_unlink_whiteout(dir, dentry);
+		if (error)
+			return error;
+	}
+
 	DQUOT_INIT(dir);
 	error = dir->i_op->create(dir, dentry, mode, nd);
 	if (!error)
@@ -1741,7 +1755,7 @@ do_last:
 	}
 
 	/* Negative dentry, just create the file */
-	if (!path.dentry->d_inode) {
+	if (!path.dentry->d_inode || S_ISWHT(path.dentry->d_inode->i_mode)) {
 		error = open_namei_create(nd, &path, flag, mode);
 		if (error)
 			goto exit;
@@ -1903,6 +1917,12 @@ int vfs_mknod(struct inode *dir, struct 
 	if (error)
 		return error;
 
+	if (dentry->d_inode && S_ISWHT(dentry->d_inode->i_mode)) {
+		error = vfs_unlink_whiteout(dir, dentry);
+		if (error)
+			return error;
+	}
+
 	DQUOT_INIT(dir);
 	error = dir->i_op->mknod(dir, dentry, mode, dev);
 	if (!error)
@@ -1969,6 +1989,7 @@ asmlinkage long sys_mknod(const char __u
 int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
 	int error = may_create(dir, dentry, NULL);
+	int opaque = 0;
 
 	if (error)
 		return error;
@@ -1981,10 +2002,20 @@ int vfs_mkdir(struct inode *dir, struct 
 	if (error)
 		return error;
 
+	if (dentry->d_inode && S_ISWHT(dentry->d_inode->i_mode)) {
+		error = vfs_unlink_whiteout(dir, dentry);
+		if (error)
+			return error;
+		opaque = 1;
+	}
+
 	DQUOT_INIT(dir);
 	error = dir->i_op->mkdir(dir, dentry, mode);
-	if (!error)
+	if (!error) {
 		fsnotify_mkdir(dir, dentry);
+		if (opaque)
+			dentry->d_inode->i_flags |= S_OPAQUE;
+	}
 	return error;
 }
 
@@ -2025,6 +2056,360 @@ asmlinkage long sys_mkdir(const char __u
 	return sys_mkdirat(AT_FDCWD, pathname, mode);
 }
 
+static int filldir_is_empty(void *__buf, const char *name, int namlen,
+			    loff_t offset, u64 ino, unsigned int d_type)
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
+static int directory_is_empty(struct dentry *dentry, struct vfsmount *mnt)
+{
+	struct file *file;
+	int err;
+	int is_empty = 1;
+
+	BUG_ON(!S_ISDIR(dentry->d_inode->i_mode));
+
+	/* references for the file pointer */
+	dget(dentry);
+	mntget(mnt);
+
+	file = dentry_open(dentry, mnt, O_RDONLY);
+	if (IS_ERR(file))
+		return 0;
+
+	err = vfs_readdir(file, filldir_is_empty, &is_empty);
+
+	fput(file);
+	return is_empty;
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
+	} else if (S_ISDIR(victim->d_inode->i_mode))
+		return -EISDIR;
+	if (victim->d_flags & DCACHE_NFSFS_RENAMED)
+		return -EBUSY;
+	return 0;
+}
+
+/*
+ * do_whiteout - whiteout a dentry, either when removing or renaming
+ * @dentry: the dentry to whiteout
+ *
+ * This is called by the VFS when removing or renaming files on an union mount.
+ * Must be called with nd->dentry->d_inode->i_mutex locked.
+ */
+static int do_whiteout(struct nameidata *nd, struct path *path, int isdir)
+{
+	struct path safe = { .dentry = dget(nd->dentry),
+			     .mnt = mntget(nd->mnt) };
+	struct dentry *dentry = path->dentry;
+	struct qstr name;
+	int err;
+
+	err = may_whiteout(dentry, isdir);
+	if (err)
+		goto out;
+
+	err = -ENOTEMPTY;
+	if (isdir && !directory_is_empty(path->dentry, path->mnt))
+		goto out;
+
+	/* safe the name for a later lookup */
+	err = -ENOMEM;
+	name.name = kmalloc(dentry->d_name.len, GFP_KERNEL);
+	if (!name.name)
+		goto out;
+	strncpy((char *)name.name, dentry->d_name.name, dentry->d_name.len);
+	name.len = dentry->d_name.len;
+	name.hash = dentry->d_name.hash;
+
+	/*
+	 * If the dentry to whiteout is on the topmost layer of
+	 * the union stack we must get rid of it first before
+	 * creating the whiteout.
+	 */
+	if (dentry->d_parent == nd->dentry) {
+		struct inode *dir = nd->dentry->d_inode;
+
+		if (isdir)
+			err = vfs_rmdir(dir, dentry);
+		else
+			err = vfs_unlink(dir, dentry);
+		if (err)
+			goto out_freename;
+	}
+
+	/*
+	 * Relookup the dentry to whiteout now. We should find a fresh negative
+	 * dentry by this time.
+	 */
+	dentry = __lookup_hash_kern(&name, nd->dentry, nd);
+	err = PTR_ERR(dentry);
+	if (IS_ERR(dentry))
+		goto out_freename;
+
+	dput(path->dentry);
+	if (path->mnt != safe.mnt)
+		mntput(path->mnt);
+	path->mnt = nd->mnt;
+	path->dentry = dentry;
+
+	err = vfs_whiteout(nd->dentry->d_inode, dentry);
+out_freename:
+	kfree(name.name);
+out:
+	pathput(&safe);
+	return err;
+}
+
+/*
+ * vfs_unlink_whiteout - Unlink a single whiteout from the system
+ * @dir: parent directory
+ * @dentry: the whiteout itself
+ *
+ * This is for unlinking a single whiteout. Don't use vfs_unlink() because we
+ * don't want any notification stuff etc. but basically it is the same stuff.
+ */
+int vfs_unlink_whiteout(struct inode *dir, struct dentry *dentry)
+{
+	int error;
+
+	if (!dentry->d_inode)
+		return -ENOENT;
+
+	error = __may_delete(dir, dentry, 0);
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
+	/*
+	 * We can call dentry_iput() since nobody could actually do something
+	 * useful with a whiteout. So dropping the reference to the inode
+	 * doesn't make a difference, does it?
+	 *
+	 * It turns the without dentry into a negative dentry ... hmm, couldn't
+	 * this race againt if(inode && S_ISWHT(inode->i_mode)) tests???
+	 */
+	if (!error) {
+		spin_lock(&dcache_lock);
+		spin_lock(&dentry->d_lock);
+		if (atomic_read(&dentry->d_count) == 1) {
+			struct inode *inode = dentry->d_inode;
+			dentry->d_inode = NULL;
+			list_del_init(&dentry->d_alias);
+			spin_unlock(&dentry->d_lock);
+			spin_unlock(&dcache_lock);
+			if (dentry->d_op && dentry->d_op->d_iput)
+				dentry->d_op->d_iput(dentry, inode);
+			else
+				iput(inode);
+		} else {
+			if (!d_unhashed(dentry))
+				__d_drop(dentry);
+			spin_unlock(&dentry->d_lock);
+			spin_unlock(&dcache_lock);
+			printk("WARNING: at %s:%d %s(): couldn't unlink\n",
+			       __FILE__, __LINE__, __FUNCTION__);
+			dump_stack();
+		}
+	}
+	return error;
+}
+
+static int __hash_one_len(const char *name, int len, struct qstr *this)
+{
+	unsigned long hash;
+	unsigned char c;
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
+struct unlink_whiteout_dirent {
+	struct dentry *parent;
+	struct list_head list;
+};
+
+static int filldir_unlink_whiteouts(void *buf, const char *name, int namlen,
+				    loff_t offset, u64 ino,
+				    unsigned int d_type)
+{
+	struct unlink_whiteout_dirent *dirent = buf;
+	struct dentry *dentry;
+	struct qstr this;
+	int res;
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
+	dentry = __lookup_hash_kern(&this, dirent->parent, NULL);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	spin_lock(&dcache_lock);
+	spin_lock(&dentry->d_lock);
+	__d_drop(dentry);
+	if (!list_empty(&dentry->d_lru)) {
+		list_del(&dentry->d_lru);
+		dentry_stat.nr_unused--;
+	}
+	list_add(&dentry->d_lru, &dirent->list);
+	spin_unlock(&dentry->d_lock);
+	spin_unlock(&dcache_lock);
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
+	struct inode *inode;
+	struct unlink_whiteout_dirent dirent =
+		{ .list = LIST_HEAD_INIT(dirent.list),
+		  .parent = dentry };
+	struct dentry *n;
+	int res;
+
+	dget(dentry);
+
+	/*
+	 * FIXME: This is bad, because we really don't want to open a new
+	 * file in the kernel but readdir needs a file pointer
+	 */
+	file = dentry_open(dentry, NULL, O_RDWR);
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
+		res = file->f_op->readdir(file, &dirent,
+					  filldir_unlink_whiteouts);
+		file_accessed(file);
+	}
+
+	list_for_each_entry_safe(dentry, n, &dirent.list, d_lru) {
+		list_del_init(&dentry->d_lru);
+		res = vfs_unlink_whiteout(inode, dentry);
+		WARN_ON(res);
+		dput(dentry);
+	}
+
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
@@ -2064,18 +2449,22 @@ int vfs_rmdir(struct inode *dir, struct 
 
 	DQUOT_INIT(dir);
 
-	mutex_lock(&dentry->d_inode->i_mutex);
+	mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
 	dentry_unhash(dentry);
 	if (d_mountpoint(dentry))
 		error = -EBUSY;
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
+out:
 	mutex_unlock(&dentry->d_inode->i_mutex);
 	if (!error) {
 		d_delete(dentry);
@@ -2243,6 +2632,12 @@ int vfs_symlink(struct inode *dir, struc
 	if (error)
 		return error;
 
+	if (dentry->d_inode && S_ISWHT(dentry->d_inode->i_mode)) {
+		error = vfs_unlink_whiteout(dir, dentry);
+		if (error)
+			return error;
+	}
+
 	DQUOT_INIT(dir);
 	error = dir->i_op->symlink(dir, dentry, oldname);
 	if (!error)
@@ -2296,7 +2691,7 @@ int vfs_link(struct dentry *old_dentry, 
 	struct inode *inode = old_dentry->d_inode;
 	int error;
 
-	if (!inode)
+	if (!inode || S_ISWHT(inode->i_mode))
 		return -ENOENT;
 
 	error = may_create(dir, new_dentry, NULL);
@@ -2570,7 +2965,7 @@ static int do_rename(int olddfd, const c
 		goto exit3;
 	/* source must exist */
 	error = -ENOENT;
-	if (!old.dentry->d_inode)
+	if (!old.dentry->d_inode || S_ISWHT(old.dentry->d_inode->i_mode))
 		goto exit4;
 	/* unless the source is a directory trailing slashes give -ENOTDIR */
 	if (!S_ISDIR(old.dentry->d_inode->i_mode)) {
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -148,6 +148,9 @@ static int filldir(void * __buf, const c
 	unsigned long d_ino;
 	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 2, sizeof(long));
 
+	if (d_type == DT_WHT)
+		return 0;
+
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
 		return -EINVAL;
@@ -233,6 +236,9 @@ static int filldir64(void * __buf, const
 	struct getdents_callback64 * buf = (struct getdents_callback64 *) __buf;
 	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 1, sizeof(u64));
 
+	if (d_type == DT_WHT)
+		return 0;
+
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
 		return -EINVAL;
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -97,6 +97,7 @@ extern int dir_notify_enable;
 #define FS_BINARY_MOUNTDATA 2
 #define FS_HAS_SUBTYPE 4
 #define FS_SAFE 8		/* Safe to mount by unprivileged users */
+#define FS_WHT		8192	/* FS supports whiteout filetype */
 #define FS_REVAL_DOT	16384	/* Check the paths ".", ".." for staleness */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move()
 					 * during rename() internally.
@@ -130,6 +131,7 @@ extern int dir_notify_enable;
 #define MS_NO_LEASES	(1<<22)	/* fs does not support leases */
 #define MS_SETUSER	(1<<23) /* set mnt_uid to current user */
 #define MS_NOMNT	(1<<24) /* don't allow unprivileged submounts */
+#define MS_WHITEOUT	(1<<25)	/* fs does support white-out filetype */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 
@@ -156,6 +158,7 @@ extern int dir_notify_enable;
 #define S_NOCMTIME	128	/* Do not update file c/mtime */
 #define S_SWAPFILE	256	/* Do not truncate: swapon got its bmaps */
 #define S_PRIVATE	512	/* Inode is fs-internal */
+#define S_OPAQUE	1024	/* Directory is opaque */
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system
@@ -190,6 +193,7 @@ extern int dir_notify_enable;
 #define IS_SWAPFILE(inode)	((inode)->i_flags & S_SWAPFILE)
 #define IS_PRIVATE(inode)	((inode)->i_flags & S_PRIVATE)
 #define IS_NO_LEASES(inode)	__IS_FLG(inode, MS_NO_LEASES)
+#define IS_OPAQUE(inode)	((inode)->i_flags & S_OPAQUE)
 
 /* the read-only stuff doesn't really belong here, but any other place is
    probably as bad and I don't want to create yet another include file. */
@@ -1087,6 +1091,8 @@ extern int vfs_link(struct dentry *, str
 extern int vfs_rmdir(struct inode *, struct dentry *);
 extern int vfs_unlink(struct inode *, struct dentry *);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
+extern int vfs_whiteout(struct inode *, struct dentry *);
+extern int vfs_unlink_whiteout(struct inode *, struct dentry *);
 
 /*
  * VFS dentry helper functions.
@@ -1212,6 +1218,7 @@ struct inode_operations {
 	int (*mkdir) (struct inode *,struct dentry *,int);
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (struct inode *,struct dentry *,int,dev_t);
+	int (*whiteout) (struct inode *, struct dentry *);
 	int (*rename) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *);
 	int (*readlink) (struct dentry *, char __user *,int);

-- 

