Return-Path: <linux-kernel-owner+w=401wt.eu-S935131AbYEURVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935131AbYEURVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935865AbYEURQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:16:17 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33079 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935462AbYEURQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:16:08 -0400
Message-Id: <20080521171556.269531948@szeredi.hu>
References: <20080521171458.077908538@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 21 May 2008 19:15:08 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 10/14] vfs: pass flags to dentry_permission()
Content-Disposition: inline; filename=dentry_permission_flags.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Switch last argument of dentry_permission() from nameidata to flags.

This requires the MNT_NOEXEC checking to be moved from
dentry_permission() to vfs_permission().

The following dentry_permission() callers passed a non-NULL nameidata:

vfs_permission()

  This remained almost equivalent, except that ordering of the
  MNT_NOEXEC check and the IS_RDONLY/IS_IMMUTABLE checks has been
  changed.  However the IS_RDONLY check should never trigger, because
  of the per-mount read-only checking.  The IS_IMMUTABLE check returns
  the same error value (-EACCES) as the MNT_NOEXEC check, so this
  change is not visible.

lookup_hash()

  Make it call vfs_permission().

may_create()

  This does not always have the nameidata available, but it operates
  on a directory, so the MNT_NOEXEC check would never have triggered
  anyway.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ecryptfs/inode.c |    3 +--
 fs/namei.c          |   49 +++++++++++++++++++++++++------------------------
 fs/nfsd/nfsfh.c     |    2 +-
 fs/nfsd/vfs.c       |    5 ++---
 fs/xattr.c          |    2 +-
 include/linux/fs.h  |    2 +-
 ipc/mqueue.c        |    2 +-
 7 files changed, 32 insertions(+), 33 deletions(-)

Index: linux-2.6/fs/ecryptfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/inode.c	2008-05-21 16:38:28.000000000 +0200
+++ linux-2.6/fs/ecryptfs/inode.c	2008-05-21 17:44:30.000000000 +0200
@@ -811,9 +811,8 @@ static int
 ecryptfs_permission(struct dentry *dentry, int mask, int flags)
 {
 	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
-	struct nameidata nd = { .flags = flags };
 
-	return dentry_permission(lower_dentry, mask, &nd);
+	return dentry_permission(lower_dentry, mask, flags);
 }
 
 /**
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-21 17:33:07.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-21 17:55:13.000000000 +0200
@@ -226,14 +226,10 @@ int generic_permission(struct inode *ino
 	return -EACCES;
 }
 
-int dentry_permission(struct dentry *dentry, int mask, struct nameidata *nd)
+int dentry_permission(struct dentry *dentry, int mask, int flags)
 {
 	struct inode *inode = dentry->d_inode;
 	int retval, submask;
-	struct vfsmount *mnt = NULL;
-
-	if (nd)
-		mnt = nd->path.mnt;
 
 	if (mask & MAY_WRITE) {
 		umode_t mode = inode->i_mode;
@@ -252,20 +248,10 @@ int dentry_permission(struct dentry *den
 			return -EACCES;
 	}
 
-	if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode)) {
-		/*
-		 * MAY_EXEC on regular files is denied if the fs is mounted
-		 * with the "noexec" flag.
-		 */
-		if (mnt && (mnt->mnt_flags & MNT_NOEXEC))
-			return -EACCES;
-	}
-
 	/* Ordinary permission routines do not understand MAY_APPEND. */
 	submask = mask & ~MAY_APPEND;
 	if (inode->i_op && inode->i_op->permission) {
-		retval = inode->i_op->permission(dentry, submask,
-						 nd ? nd->flags : 0);
+		retval = inode->i_op->permission(dentry, submask, flags);
 		if (!retval) {
 			/*
 			 * Exec permission on a regular file is denied if none
@@ -288,7 +274,7 @@ int dentry_permission(struct dentry *den
 	if (retval)
 		return retval;
 
-	return security_inode_permission(inode, mask, nd ? nd->flags : 0);
+	return security_inode_permission(inode, mask, flags);
 }
 
 /**
@@ -303,7 +289,21 @@ int dentry_permission(struct dentry *den
  */
 int vfs_permission(struct nameidata *nd, int mask)
 {
-	return dentry_permission(nd->path.dentry, mask, nd);
+	struct dentry *dentry = nd->path.dentry;
+	struct inode *inode = dentry->d_inode;
+
+	if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode)) {
+		struct vfsmount *mnt = nd->path.mnt;
+
+		/*
+		 * MAY_EXEC on regular files is denied if the fs is mounted
+		 * with the "noexec" flag.
+		 */
+		if (mnt->mnt_flags & MNT_NOEXEC)
+			return -EACCES;
+	}
+
+	return dentry_permission(dentry, mask, nd->flags);
 }
 
 /**
@@ -320,7 +320,7 @@ int vfs_permission(struct nameidata *nd,
  */
 int file_permission(struct file *file, int mask)
 {
-	return dentry_permission(file->f_path.dentry, mask, NULL);
+	return dentry_permission(file->f_path.dentry, mask, 0);
 }
 
 /*
@@ -1343,7 +1343,7 @@ static struct dentry *lookup_hash(struct
 {
 	int err;
 
-	err = dentry_permission(nd->path.dentry, MAY_EXEC, nd);
+	err = vfs_permission(nd, MAY_EXEC);
 	if (err)
 		return ERR_PTR(err);
 	return __lookup_hash(&nd->last, nd->path.dentry, nd);
@@ -1391,7 +1391,7 @@ struct dentry *lookup_one_len(const char
 	if (err)
 		return ERR_PTR(err);
 
-	err = dentry_permission(base, MAY_EXEC, NULL);
+	err = dentry_permission(base, MAY_EXEC, 0);
 	if (err)
 		return ERR_PTR(err);
 	return __lookup_hash(&this, base, NULL);
@@ -1483,7 +1483,7 @@ static int may_delete(struct dentry *dir
 	BUG_ON(victim->d_parent->d_inode != dir);
 	audit_inode_child(victim->d_name.name, victim, dir);
 
-	error = dentry_permission(dir_dentry, MAY_WRITE | MAY_EXEC, NULL);
+	error = dentry_permission(dir_dentry, MAY_WRITE | MAY_EXEC, 0);
 	if (error)
 		return error;
 	if (IS_APPEND(dir))
@@ -1520,7 +1520,8 @@ static inline int may_create(struct dent
 		return -EEXIST;
 	if (IS_DEADDIR(dir_dentry->d_inode))
 		return -ENOENT;
-	return dentry_permission(dir_dentry, MAY_WRITE | MAY_EXEC, nd);
+	return dentry_permission(dir_dentry, MAY_WRITE | MAY_EXEC,
+				 nd ? nd->flags : 0);
 }
 
 /* 
@@ -2682,7 +2683,7 @@ static int vfs_rename_dir(struct inode *
 	 * we'll need to flip '..'.
 	 */
 	if (new_dir != old_dir) {
-		error = dentry_permission(old_dentry, MAY_WRITE, NULL);
+		error = dentry_permission(old_dentry, MAY_WRITE, 0);
 		if (error)
 			return error;
 	}
Index: linux-2.6/fs/nfsd/nfsfh.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfsfh.c	2008-05-21 16:36:07.000000000 +0200
+++ linux-2.6/fs/nfsd/nfsfh.c	2008-05-21 17:44:30.000000000 +0200
@@ -51,7 +51,7 @@ static int nfsd_acceptable(void *expv, s
 		/* make sure parents give x permission to user */
 		int err;
 		parent = dget_parent(tdentry);
-		err = dentry_permission(parent, MAY_EXEC, NULL);
+		err = dentry_permission(parent, MAY_EXEC, 0);
 		if (err < 0) {
 			dput(parent);
 			break;
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2008-05-21 16:36:07.000000000 +0200
+++ linux-2.6/fs/nfsd/vfs.c	2008-05-21 17:44:30.000000000 +0200
@@ -1942,13 +1942,12 @@ nfsd_permission(struct svc_rqst *rqstp, 
 	    inode->i_uid == current->fsuid)
 		return 0;
 
-	err = dentry_permission(dentry, acc & (MAY_READ|MAY_WRITE|MAY_EXEC),
-				NULL);
+	err = dentry_permission(dentry, acc & (MAY_READ|MAY_WRITE|MAY_EXEC), 0);
 
 	/* Allow read access to binaries even when mode 111 */
 	if (err == -EACCES && S_ISREG(inode->i_mode) &&
 	    acc == (MAY_READ | MAY_OWNER_OVERRIDE))
-		err = dentry_permission(dentry, MAY_EXEC, NULL);
+		err = dentry_permission(dentry, MAY_EXEC, 0);
 
 	return err? nfserrno(err) : 0;
 }
Index: linux-2.6/fs/xattr.c
===================================================================
--- linux-2.6.orig/fs/xattr.c	2008-05-21 16:36:07.000000000 +0200
+++ linux-2.6/fs/xattr.c	2008-05-21 17:44:30.000000000 +0200
@@ -65,7 +65,7 @@ xattr_permission(struct dentry *dentry, 
 			return -EPERM;
 	}
 
-	return dentry_permission(dentry, mask, NULL);
+	return dentry_permission(dentry, mask, 0);
 }
 
 static int
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-05-21 16:38:28.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-05-21 17:44:30.000000000 +0200
@@ -1758,7 +1758,7 @@ extern sector_t bmap(struct inode *, sec
 #endif
 extern int notify_change(struct dentry *, struct iattr *);
 extern int path_setattr(struct path *, struct iattr *);
-extern int dentry_permission(struct dentry *, int, struct nameidata *);
+extern int dentry_permission(struct dentry *, int, int);
 extern int generic_permission(struct inode *, int,
 		int (*check_acl)(struct inode *, int));
 
Index: linux-2.6/ipc/mqueue.c
===================================================================
--- linux-2.6.orig/ipc/mqueue.c	2008-05-21 16:36:07.000000000 +0200
+++ linux-2.6/ipc/mqueue.c	2008-05-21 17:44:30.000000000 +0200
@@ -653,7 +653,7 @@ static int oflag2acc[O_ACCMODE] = { MAY_
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (dentry_permission(dentry, oflag2acc[oflag & O_ACCMODE], NULL)) {
+	if (dentry_permission(dentry, oflag2acc[oflag & O_ACCMODE], 0)) {
 		dput(dentry);
 		mntput(mqueue_mnt);
 		return ERR_PTR(-EACCES);

--
