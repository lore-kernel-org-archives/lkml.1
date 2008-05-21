Return-Path: <linux-kernel-owner+w=401wt.eu-S936300AbYEURTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936300AbYEURTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935750AbYEURQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:16:08 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33068 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935400AbYEURQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:16:00 -0400
Message-Id: <20080521171551.453155765@szeredi.hu>
References: <20080521171458.077908538@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 21 May 2008 19:15:05 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 07/14] vfs: pass dentry to permission()
Content-Disposition: inline; filename=dentry_permission.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

The following patches clean up the i_op->permission() method and the
related VFS API.

Here's an overview of the changes:

 - ->permission() is passed a dentry instead of an inode
 - ->permission() is passed a integer flags parameter instead of a
   nameidata pointer
 - all nameidata pointer passing is removed from the permission API
 - the check for execute bit on regular files is moved into ->permission()
 - the permission() and vfs_permission() functions are consolidated to
   a common path_permission() function
 - file_permission() becomes just a helper to call path_permission()

This patch:

Rename permission() to dentry_permission() and pass a dentry to it
instead of an inode.

For ecryptfs this is done with a temparary hack using d_find_alias(),
which will be removed by the next patch.

Otherwise this can be trivially done by passing the dentry down to
functions calling permission().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ecryptfs/inode.c |   14 +++++-
 fs/namei.c          |  105 ++++++++++++++++++++++++++++------------------------
 fs/nfsd/nfsfh.c     |    2 
 fs/nfsd/vfs.c       |    5 +-
 fs/xattr.c          |   12 +++--
 include/linux/fs.h  |    2 
 ipc/mqueue.c        |    2 
 7 files changed, 81 insertions(+), 61 deletions(-)

Index: linux-2.6/fs/ecryptfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/inode.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/ecryptfs/inode.c	2008-05-21 16:36:42.000000000 +0200
@@ -818,11 +818,19 @@ ecryptfs_permission(struct inode *inode,
 
 		nd->path.mnt = ecryptfs_dentry_to_lower_mnt(nd->path.dentry);
 		nd->path.dentry = ecryptfs_dentry_to_lower(nd->path.dentry);
-		rc = permission(ecryptfs_inode_to_lower(inode), mask, nd);
+		rc = dentry_permission(nd->path.dentry, mask, nd);
 		nd->path.mnt = vfsmnt_save;
 		nd->path.dentry = dentry_save;
-        } else
-		rc = permission(ecryptfs_inode_to_lower(inode), mask, NULL);
+	} else {
+		struct dentry *dentry = d_find_alias(inode);
+		struct dentry *lower_dentry;
+
+		rc = -ENOENT;
+		if (dentry) {
+			lower_dentry = ecryptfs_dentry_to_lower(dentry);
+			rc = dentry_permission(lower_dentry, mask, NULL);
+		}
+	}
         return rc;
 }
 
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-21 16:36:07.000000000 +0200
@@ -226,8 +226,9 @@ int generic_permission(struct inode *ino
 	return -EACCES;
 }
 
-int permission(struct inode *inode, int mask, struct nameidata *nd)
+int dentry_permission(struct dentry *dentry, int mask, struct nameidata *nd)
 {
+	struct inode *inode = dentry->d_inode;
 	int retval, submask;
 	struct vfsmount *mnt = NULL;
 
@@ -301,7 +302,7 @@ int permission(struct inode *inode, int 
  */
 int vfs_permission(struct nameidata *nd, int mask)
 {
-	return permission(nd->path.dentry->d_inode, mask, nd);
+	return dentry_permission(nd->path.dentry, mask, nd);
 }
 
 /**
@@ -318,7 +319,7 @@ int vfs_permission(struct nameidata *nd,
  */
 int file_permission(struct file *file, int mask)
 {
-	return permission(file->f_path.dentry->d_inode, mask, NULL);
+	return dentry_permission(file->f_path.dentry, mask, NULL);
 }
 
 /*
@@ -1341,7 +1342,7 @@ static struct dentry *lookup_hash(struct
 {
 	int err;
 
-	err = permission(nd->path.dentry->d_inode, MAY_EXEC, nd);
+	err = dentry_permission(nd->path.dentry, MAY_EXEC, nd);
 	if (err)
 		return ERR_PTR(err);
 	return __lookup_hash(&nd->last, nd->path.dentry, nd);
@@ -1389,7 +1390,7 @@ struct dentry *lookup_one_len(const char
 	if (err)
 		return ERR_PTR(err);
 
-	err = permission(base->d_inode, MAY_EXEC, NULL);
+	err = dentry_permission(base, MAY_EXEC, NULL);
 	if (err)
 		return ERR_PTR(err);
 	return __lookup_hash(&this, base, NULL);
@@ -1469,8 +1470,10 @@ static inline int check_sticky(struct in
  * 10. We don't allow removal of NFS sillyrenamed files; it's handled by
  *     nfs_async_unlink().
  */
-static int may_delete(struct inode *dir,struct dentry *victim,int isdir)
+static int may_delete(struct dentry *dir_dentry, struct dentry *victim,
+		      int isdir)
 {
+	struct inode *dir = dir_dentry->d_inode;
 	int error;
 
 	if (!victim->d_inode)
@@ -1479,7 +1482,7 @@ static int may_delete(struct inode *dir,
 	BUG_ON(victim->d_parent->d_inode != dir);
 	audit_inode_child(victim->d_name.name, victim, dir);
 
-	error = permission(dir,MAY_WRITE | MAY_EXEC, NULL);
+	error = dentry_permission(dir_dentry, MAY_WRITE | MAY_EXEC, NULL);
 	if (error)
 		return error;
 	if (IS_APPEND(dir))
@@ -1509,14 +1512,14 @@ static int may_delete(struct inode *dir,
  *  3. We should have write and exec permissions on dir
  *  4. We can't do it if dir is immutable (done in permission())
  */
-static inline int may_create(struct inode *dir, struct dentry *child,
+static inline int may_create(struct dentry *dir_dentry, struct dentry *child,
 			     struct nameidata *nd)
 {
 	if (child->d_inode)
 		return -EEXIST;
-	if (IS_DEADDIR(dir))
+	if (IS_DEADDIR(dir_dentry->d_inode))
 		return -ENOENT;
-	return permission(dir,MAY_WRITE | MAY_EXEC, nd);
+	return dentry_permission(dir_dentry, MAY_WRITE | MAY_EXEC, nd);
 }
 
 /* 
@@ -1579,10 +1582,11 @@ void unlock_rename(struct dentry *p1, st
 	}
 }
 
-static int vfs_create(struct inode *dir, struct dentry *dentry, int mode,
-		struct nameidata *nd)
+static int vfs_create(struct dentry *dir_dentry, struct dentry *dentry,
+		      int mode,	struct nameidata *nd)
 {
-	int error = may_create(dir, dentry, nd);
+	struct inode *dir = dir_dentry->d_inode;
+	int error = may_create(dir_dentry, dentry, nd);
 
 	if (error)
 		return error;
@@ -1607,7 +1611,7 @@ int path_create(struct path *dir_path, s
 	int error = mnt_want_write(dir_path->mnt);
 
 	if (!error) {
-		error = vfs_create(dir_path->dentry->d_inode, dentry, mode, nd);
+		error = vfs_create(dir_path->dentry, dentry, mode, nd);
 		mnt_drop_write(dir_path->mnt);
 	}
 
@@ -1708,7 +1712,7 @@ static int __open_namei_create(struct na
 
 	if (!IS_POSIXACL(dir->d_inode))
 		mode &= ~current->fs->umask;
-	error = vfs_create(dir->d_inode, path->dentry, mode, nd);
+	error = vfs_create(dir, path->dentry, mode, nd);
 	mutex_unlock(&dir->d_inode->i_mutex);
 	dput(nd->path.dentry);
 	nd->path.dentry = path->dentry;
@@ -2034,9 +2038,11 @@ fail:
 }
 EXPORT_SYMBOL_GPL(lookup_create);
 
-static int vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
+static int vfs_mknod(struct dentry *dir_dentry, struct dentry *dentry,
+		     int mode, dev_t dev)
 {
-	int error = may_create(dir, dentry, NULL);
+	struct inode *dir = dir_dentry->d_inode;
+	int error = may_create(dir_dentry, dentry, NULL);
 
 	if (error)
 		return error;
@@ -2068,7 +2074,7 @@ int path_mknod(struct path *dir_path, st
 	int error = mnt_want_write(dir_path->mnt);
 
 	if (!error) {
-		error = vfs_mknod(dir_path->dentry->d_inode, dentry, mode, dev);
+		error = vfs_mknod(dir_path->dentry, dentry, mode, dev);
 		mnt_drop_write(dir_path->mnt);
 	}
 
@@ -2131,9 +2137,10 @@ asmlinkage long sys_mknod(const char __u
 	return sys_mknodat(AT_FDCWD, filename, mode, dev);
 }
 
-static int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+static int vfs_mkdir(struct dentry *dir_dentry, struct dentry *dentry, int mode)
 {
-	int error = may_create(dir, dentry, NULL);
+	struct inode *dir = dir_dentry->d_inode;
+	int error = may_create(dir_dentry, dentry, NULL);
 
 	if (error)
 		return error;
@@ -2158,7 +2165,7 @@ int path_mkdir(struct path *dir_path, st
 	int error = mnt_want_write(dir_path->mnt);
 
 	if (!error) {
-		error = vfs_mkdir(dir_path->dentry->d_inode, dentry, mode);
+		error = vfs_mkdir(dir_path->dentry, dentry, mode);
 		mnt_drop_write(dir_path->mnt);
 	}
 
@@ -2231,9 +2238,10 @@ void dentry_unhash(struct dentry *dentry
 	spin_unlock(&dcache_lock);
 }
 
-static int vfs_rmdir(struct inode *dir, struct dentry *dentry)
+static int vfs_rmdir(struct dentry *dir_dentry, struct dentry *dentry)
 {
-	int error = may_delete(dir, dentry, 1);
+	struct inode *dir = dir_dentry->d_inode;
+	int error = may_delete(dir_dentry, dentry, 1);
 
 	if (error)
 		return error;
@@ -2269,7 +2277,7 @@ int path_rmdir(struct path *dir_path, st
 	int error = mnt_want_write(dir_path->mnt);
 
 	if (!error) {
-		error = vfs_rmdir(dir_path->dentry->d_inode, dentry);
+		error = vfs_rmdir(dir_path->dentry, dentry);
 		mnt_drop_write(dir_path->mnt);
 	}
 
@@ -2324,9 +2332,10 @@ asmlinkage long sys_rmdir(const char __u
 	return do_rmdir(AT_FDCWD, pathname);
 }
 
-static int vfs_unlink(struct inode *dir, struct dentry *dentry)
+static int vfs_unlink(struct dentry *dir_dentry, struct dentry *dentry)
 {
-	int error = may_delete(dir, dentry, 0);
+	struct inode *dir = dir_dentry->d_inode;
+	int error = may_delete(dir_dentry, dentry, 0);
 
 	if (error)
 		return error;
@@ -2360,7 +2369,7 @@ int path_unlink(struct path *dir_path, s
 	int error = mnt_want_write(dir_path->mnt);
 
 	if (!error) {
-		error = vfs_unlink(dir_path->dentry->d_inode, dentry);
+		error = vfs_unlink(dir_path->dentry, dentry);
 		mnt_drop_write(dir_path->mnt);
 	}
 
@@ -2437,9 +2446,11 @@ asmlinkage long sys_unlink(const char __
 	return do_unlinkat(AT_FDCWD, pathname);
 }
 
-static int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname)
+static int vfs_symlink(struct dentry *dir_dentry, struct dentry *dentry,
+		       const char *oldname)
 {
-	int error = may_create(dir, dentry, NULL);
+	struct inode *dir = dir_dentry->d_inode;
+	int error = may_create(dir_dentry, dentry, NULL);
 
 	if (error)
 		return error;
@@ -2464,9 +2475,7 @@ int path_symlink(struct path *dir_path, 
 	int error = mnt_want_write(dir_path->mnt);
 
 	if (!error) {
-		struct inode *dir = dir_path->dentry->d_inode;
-
-		error = vfs_symlink(dir, dentry, oldname);
+		error = vfs_symlink(dir_path->dentry, dentry, oldname);
 		mnt_drop_write(dir_path->mnt);
 	}
 
@@ -2516,15 +2525,17 @@ asmlinkage long sys_symlink(const char _
 	return sys_symlinkat(oldname, AT_FDCWD, newname);
 }
 
-static int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_dentry)
+static int vfs_link(struct dentry *old_dentry, struct dentry *new_dir_dentry,
+		    struct dentry *new_dentry)
 {
+	struct inode *dir = new_dir_dentry->d_inode;
 	struct inode *inode = old_dentry->d_inode;
 	int error;
 
 	if (!inode)
 		return -ENOENT;
 
-	error = may_create(dir, new_dentry, NULL);
+	error = may_create(new_dir_dentry, new_dentry, NULL);
 	if (error)
 		return error;
 
@@ -2560,9 +2571,7 @@ int path_link(struct dentry *old_dentry,
 	int error = mnt_want_write(dir_path->mnt);
 
 	if (!error) {
-		struct inode *dir = dir_path->dentry->d_inode;
-
-		error = vfs_link(old_dentry, dir, new_dentry);
+		error = vfs_link(old_dentry, dir_path->dentry, new_dentry);
 		mnt_drop_write(dir_path->mnt);
 	}
 
@@ -2672,7 +2681,7 @@ static int vfs_rename_dir(struct inode *
 	 * we'll need to flip '..'.
 	 */
 	if (new_dir != old_dir) {
-		error = permission(old_dentry->d_inode, MAY_WRITE, NULL);
+		error = dentry_permission(old_dentry, MAY_WRITE, NULL);
 		if (error)
 			return error;
 	}
@@ -2732,9 +2741,11 @@ static int vfs_rename_other(struct inode
 	return error;
 }
 
-static int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-		      struct inode *new_dir, struct dentry *new_dentry)
+static int vfs_rename(struct dentry *old_dir_dentry, struct dentry *old_dentry,
+		      struct dentry *new_dir_dentry, struct dentry *new_dentry)
 {
+	struct inode *old_dir = old_dir_dentry->d_inode;
+	struct inode *new_dir = new_dir_dentry->d_inode;
 	int error;
 	int is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
 	const char *old_name;
@@ -2742,14 +2753,14 @@ static int vfs_rename(struct inode *old_
 	if (old_dentry->d_inode == new_dentry->d_inode)
  		return 0;
  
-	error = may_delete(old_dir, old_dentry, is_dir);
+	error = may_delete(old_dir_dentry, old_dentry, is_dir);
 	if (error)
 		return error;
 
 	if (!new_dentry->d_inode)
-		error = may_create(new_dir, new_dentry, NULL);
+		error = may_create(new_dir_dentry, new_dentry, NULL);
 	else
-		error = may_delete(new_dir, new_dentry, is_dir);
+		error = may_delete(new_dir_dentry, new_dentry, is_dir);
 	if (error)
 		return error;
 
@@ -2785,10 +2796,8 @@ int path_rename(struct path *old_dir_pat
 
 	error = mnt_want_write(mnt);
 	if (!error) {
-		struct inode *old_dir = old_dir_path->dentry->d_inode;
-		struct inode *new_dir = new_dir_path->dentry->d_inode;
-
-		error = vfs_rename(old_dir, old_dentry, new_dir, new_dentry);
+		error = vfs_rename(old_dir_path->dentry, old_dentry,
+				   new_dir_path->dentry, new_dentry);
 		mnt_drop_write(mnt);
 	}
 
@@ -3041,7 +3050,7 @@ EXPORT_SYMBOL(page_symlink);
 EXPORT_SYMBOL(page_symlink_inode_operations);
 EXPORT_SYMBOL(path_lookup);
 EXPORT_SYMBOL(vfs_path_lookup);
-EXPORT_SYMBOL(permission);
+EXPORT_SYMBOL(dentry_permission);
 EXPORT_SYMBOL(vfs_permission);
 EXPORT_SYMBOL(file_permission);
 EXPORT_SYMBOL(unlock_rename);
Index: linux-2.6/fs/nfsd/nfsfh.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfsfh.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/nfsd/nfsfh.c	2008-05-21 16:36:07.000000000 +0200
@@ -51,7 +51,7 @@ static int nfsd_acceptable(void *expv, s
 		/* make sure parents give x permission to user */
 		int err;
 		parent = dget_parent(tdentry);
-		err = permission(parent->d_inode, MAY_EXEC, NULL);
+		err = dentry_permission(parent, MAY_EXEC, NULL);
 		if (err < 0) {
 			dput(parent);
 			break;
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2008-05-21 15:45:45.000000000 +0200
+++ linux-2.6/fs/nfsd/vfs.c	2008-05-21 16:36:07.000000000 +0200
@@ -1942,12 +1942,13 @@ nfsd_permission(struct svc_rqst *rqstp, 
 	    inode->i_uid == current->fsuid)
 		return 0;
 
-	err = permission(inode, acc & (MAY_READ|MAY_WRITE|MAY_EXEC), NULL);
+	err = dentry_permission(dentry, acc & (MAY_READ|MAY_WRITE|MAY_EXEC),
+				NULL);
 
 	/* Allow read access to binaries even when mode 111 */
 	if (err == -EACCES && S_ISREG(inode->i_mode) &&
 	    acc == (MAY_READ | MAY_OWNER_OVERRIDE))
-		err = permission(inode, MAY_EXEC, NULL);
+		err = dentry_permission(dentry, MAY_EXEC, NULL);
 
 	return err? nfserrno(err) : 0;
 }
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-05-21 16:36:07.000000000 +0200
@@ -1758,7 +1758,7 @@ extern sector_t bmap(struct inode *, sec
 #endif
 extern int notify_change(struct dentry *, struct iattr *);
 extern int path_setattr(struct path *, struct iattr *);
-extern int permission(struct inode *, int, struct nameidata *);
+extern int dentry_permission(struct dentry *, int, struct nameidata *);
 extern int generic_permission(struct inode *, int,
 		int (*check_acl)(struct inode *, int));
 
Index: linux-2.6/fs/xattr.c
===================================================================
--- linux-2.6.orig/fs/xattr.c	2008-05-21 15:45:45.000000000 +0200
+++ linux-2.6/fs/xattr.c	2008-05-21 16:36:07.000000000 +0200
@@ -26,8 +26,10 @@
  * because different namespaces have very different rules.
  */
 static int
-xattr_permission(struct inode *inode, const char *name, int mask)
+xattr_permission(struct dentry *dentry, const char *name, int mask)
 {
+	struct inode *inode = dentry->d_inode;
+
 	/*
 	 * We can never set or remove an extended attribute on a read-only
 	 * filesystem  or on an immutable / append-only inode.
@@ -63,7 +65,7 @@ xattr_permission(struct inode *inode, co
 			return -EPERM;
 	}
 
-	return permission(inode, mask, NULL);
+	return dentry_permission(dentry, mask, NULL);
 }
 
 static int
@@ -73,7 +75,7 @@ vfs_setxattr(struct dentry *dentry, cons
 	struct inode *inode = dentry->d_inode;
 	int error;
 
-	error = xattr_permission(inode, name, MAY_WRITE);
+	error = xattr_permission(dentry, name, MAY_WRITE);
 	if (error)
 		return error;
 
@@ -150,7 +152,7 @@ path_getxattr(struct path *path, const c
 	struct inode *inode = dentry->d_inode;
 	int error;
 
-	error = xattr_permission(inode, name, MAY_READ);
+	error = xattr_permission(dentry, name, MAY_READ);
 	if (error)
 		return error;
 
@@ -210,7 +212,7 @@ vfs_removexattr(struct dentry *dentry, c
 	if (!inode->i_op->removexattr)
 		return -EOPNOTSUPP;
 
-	error = xattr_permission(inode, name, MAY_WRITE);
+	error = xattr_permission(dentry, name, MAY_WRITE);
 	if (error)
 		return error;
 
Index: linux-2.6/ipc/mqueue.c
===================================================================
--- linux-2.6.orig/ipc/mqueue.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/ipc/mqueue.c	2008-05-21 16:36:07.000000000 +0200
@@ -653,7 +653,7 @@ static int oflag2acc[O_ACCMODE] = { MAY_
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (permission(dentry->d_inode, oflag2acc[oflag & O_ACCMODE], NULL)) {
+	if (dentry_permission(dentry, oflag2acc[oflag & O_ACCMODE], NULL)) {
 		dput(dentry);
 		mntput(mqueue_mnt);
 		return ERR_PTR(-EACCES);

--
