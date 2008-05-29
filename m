Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbYE2Lfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbYE2Lfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 07:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbYE2Ldd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 07:33:33 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56707 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbYE2LdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 07:33:23 -0400
Message-Id: <20080529113314.181992948@szeredi.hu>
References: <20080529113245.450308367@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 13:32:50 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 5/8] vfs: annotate permission operations
Content-Disposition: inline; filename=permission_op.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add more PERM_OP_ flags to permission() calls.  This allows
filesystems like NFS and security modules like AppArmor to make
precise decisions about whent permissions need to be checked, and when
they will be checked later together with the actual operation.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c         |   16 ++++++++--------
 fs/nfsd/nfsfh.c    |    2 +-
 fs/open.c          |    6 +++---
 fs/utimes.c        |    2 +-
 fs/xattr.c         |    2 +-
 include/linux/fs.h |   19 +++++++++++++++++++
 6 files changed, 33 insertions(+), 14 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-29 12:46:24.000000000 +0200
@@ -492,7 +492,7 @@ static int exec_permission_lite(struct i
 
 	return -EACCES;
 ok:
-	return security_inode_permission(inode, MAY_EXEC);
+	return security_inode_permission(inode, MAY_LOOKUP);
 }
 
 /*
@@ -899,7 +899,7 @@ static int __link_path_walk(const char *
 		nd->flags |= LOOKUP_CONTINUE;
 		err = exec_permission_lite(inode);
 		if (err == -EAGAIN)
-			err = path_permission(&nd->path, MAY_EXEC);
+			err = path_permission(&nd->path, MAY_LOOKUP);
  		if (err)
 			break;
 
@@ -1174,7 +1174,7 @@ static int do_path_lookup(int dfd, const
 		if (!S_ISDIR(dentry->d_inode->i_mode))
 			goto fput_fail;
 
-		retval = file_permission(file, MAY_EXEC);
+		retval = file_permission(file, MAY_LOOKUP);
 		if (retval)
 			goto fput_fail;
 
@@ -1347,7 +1347,7 @@ static struct dentry *lookup_hash(struct
 {
 	int err;
 
-	err = path_permission(&nd->path, MAY_EXEC);
+	err = path_permission(&nd->path, MAY_LOOKUP);
 	if (err)
 		return ERR_PTR(err);
 	return __lookup_hash(&nd->last, nd->path.dentry, nd);
@@ -1395,7 +1395,7 @@ struct dentry *lookup_one_len(const char
 	if (err)
 		return ERR_PTR(err);
 
-	err = dentry_permission(base, MAY_EXEC);
+	err = dentry_permission(base, MAY_LOOKUP);
 	if (err)
 		return ERR_PTR(err);
 	return __lookup_hash(&this, base, NULL);
@@ -1487,7 +1487,7 @@ static int may_delete(struct dentry *dir
 	BUG_ON(victim->d_parent->d_inode != dir);
 	audit_inode_child(victim->d_name.name, victim, dir);
 
-	error = dentry_permission(dir_dentry, MAY_WRITE | MAY_EXEC);
+	error = dentry_permission(dir_dentry, MAY_DELETE);
 	if (error)
 		return error;
 	if (IS_APPEND(dir))
@@ -1523,7 +1523,7 @@ static inline int may_create(struct dent
 		return -EEXIST;
 	if (IS_DEADDIR(dir_dentry->d_inode))
 		return -ENOENT;
-	return dentry_permission(dir_dentry, MAY_WRITE | MAY_EXEC);
+	return dentry_permission(dir_dentry, MAY_CREATE);
 }
 
 /* 
@@ -2687,7 +2687,7 @@ static int vfs_rename_dir(struct inode *
 	 * we'll need to flip '..'.
 	 */
 	if (new_dir != old_dir) {
-		error = dentry_permission(old_dentry, MAY_WRITE);
+		error = dentry_permission(old_dentry, MAY_MOVE_DIR);
 		if (error)
 			return error;
 	}
Index: linux-2.6/fs/nfsd/nfsfh.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfsfh.c	2008-05-29 12:46:23.000000000 +0200
+++ linux-2.6/fs/nfsd/nfsfh.c	2008-05-29 12:46:24.000000000 +0200
@@ -52,7 +52,7 @@ static int nfsd_acceptable(void *expv, s
 		int err;
 
 		parent.dentry = dget_parent(tdentry);
-		err = path_permission(&parent, MAY_EXEC);
+		err = path_permission(&parent, MAY_LOOKUP);
 		if (err < 0) {
 			dput(parent.dentry);
 			break;
Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/fs/open.c	2008-05-29 12:46:24.000000000 +0200
@@ -513,7 +513,7 @@ asmlinkage long sys_chdir(const char __u
 	if (error)
 		goto out;
 
-	error = path_permission(&nd.path, MAY_EXEC | PERM_OP_CHDIR);
+	error = path_permission(&nd.path, MAY_CHDIR);
 	if (error)
 		goto dput_and_out;
 
@@ -542,7 +542,7 @@ asmlinkage long sys_fchdir(unsigned int 
 	if (!S_ISDIR(inode->i_mode))
 		goto out_putf;
 
-	error = file_permission(file, MAY_EXEC | PERM_OP_CHDIR);
+	error = file_permission(file, MAY_CHDIR);
 	if (!error)
 		set_fs_pwd(current->fs, &file->f_path);
 out_putf:
@@ -560,7 +560,7 @@ asmlinkage long sys_chroot(const char __
 	if (error)
 		goto out;
 
-	error = path_permission(&nd.path, MAY_EXEC);
+	error = path_permission(&nd.path, MAY_CHROOT);
 	if (error)
 		goto dput_and_out;
 
Index: linux-2.6/fs/utimes.c
===================================================================
--- linux-2.6.orig/fs/utimes.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/fs/utimes.c	2008-05-29 12:46:24.000000000 +0200
@@ -141,7 +141,7 @@ static int do_utimes_name(int dfd, char 
 			goto out_path_put;
 
 		if (!is_owner_or_cap(inode)) {
-			error = path_permission(&nd.path, MAY_WRITE);
+			error = path_permission(&nd.path, MAY_UTIMES);
 			if (error)
 				goto out_path_put;
 		}
Index: linux-2.6/fs/xattr.c
===================================================================
--- linux-2.6.orig/fs/xattr.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/fs/xattr.c	2008-05-29 12:46:24.000000000 +0200
@@ -65,7 +65,7 @@ xattr_permission(struct path *path, cons
 			return -EPERM;
 	}
 
-	return path_permission(path, mask);
+	return path_permission(path, mask | PERM_OP_XATTR);
 }
 
 static int
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-05-29 12:46:24.000000000 +0200
@@ -70,6 +70,25 @@ extern int dir_notify_enable;
 #define PERM_OP_OPEN	(0x1 << 28)
 #define PERM_OP_ACCESS	(0x2 << 28)
 #define PERM_OP_CHDIR	(0x3 << 28)
+#define PERM_OP_CHROOT	(0x4 << 28)
+#define PERM_OP_LOOKUP	(0x5 << 28)
+#define PERM_OP_CREATE	(0x6 << 28)
+#define PERM_OP_DELETE	(0x7 << 28)
+#define PERM_OP_MOVE_DIR	(0x8 << 28)
+#define PERM_OP_UTIMES	(0x9 << 28)
+#define PERM_OP_XATTR	(0xa << 28)
+
+/*
+ * Combined MAY_ flags
+ */
+#define MAY_CHDIR	(PERM_OP_CHDIR | MAY_EXEC)
+#define MAY_CHROOT	(PERM_OP_CHROOT | MAY_EXEC)
+#define MAY_LOOKUP	(PERM_OP_LOOKUP | MAY_EXEC)
+#define MAY_CREATE	(PERM_OP_CREATE | MAY_EXEC | MAY_WRITE)
+#define MAY_DELETE	(PERM_OP_DELETE | MAY_EXEC | MAY_WRITE)
+#define MAY_MOVE_DIR	(PERM_OP_MOVE_DIR | MAY_WRITE)
+#define MAY_UTIMES	(PERM_OP_UTIMES | MAY_WRITE)
+
 
 #define FMODE_READ 1
 #define FMODE_WRITE 2

--
