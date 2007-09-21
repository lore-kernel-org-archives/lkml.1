Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbXIUMfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbXIUMfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 08:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754807AbXIUMeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 08:34:10 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:41955 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbXIUMeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 08:34:02 -0400
Message-Id: <20070921123333.247493758@szeredi.hu>
References: <20070921122343.307289079@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 21 Sep 2007 14:23:46 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [patch 3/5] VFS: pass open file to ->xattr()
Content-Disposition: inline; filename=vfs_xattr_file.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Pass the open file into the filesystem's *xattr() methods.

This is needed to be able to correctly implement open-unlink-f*xattr
semantics, without having to resort to "silly-renaming".

Do this by adding a 'struct file *' parameter to i_op->*xattr().  For
f... variants pass the open file pointer, in other cases pass NULL.

This is safe from a compatibility standpoint, out-of-tree old stuff
will continue to work, but will get a warning at compile time.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/bad_inode.c
===================================================================
--- linux.orig/fs/bad_inode.c	2007-09-21 13:45:07.000000000 +0200
+++ linux/fs/bad_inode.c	2007-09-21 13:45:11.000000000 +0200
@@ -261,24 +261,25 @@ static int bad_inode_setattr(struct dent
 }
 
 static int bad_inode_setxattr(struct dentry *dentry, const char *name,
-		const void *value, size_t size, int flags)
+		const void *value, size_t size, int flags, struct file *file)
 {
 	return -EIO;
 }
 
 static ssize_t bad_inode_getxattr(struct dentry *dentry, const char *name,
-			void *buffer, size_t size)
+			void *buffer, size_t size, struct file *file)
 {
 	return -EIO;
 }
 
 static ssize_t bad_inode_listxattr(struct dentry *dentry, char *buffer,
-			size_t buffer_size)
+			size_t buffer_size, struct file *file)
 {
 	return -EIO;
 }
 
-static int bad_inode_removexattr(struct dentry *dentry, const char *name)
+static int bad_inode_removexattr(struct dentry *dentry, const char *name,
+				 struct file *file)
 {
 	return -EIO;
 }
Index: linux/fs/ext2/xattr.c
===================================================================
--- linux.orig/fs/ext2/xattr.c	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/ext2/xattr.c	2007-09-21 13:45:11.000000000 +0200
@@ -328,7 +328,8 @@ cleanup:
  * dentry->d_inode->i_mutex: don't care
  */
 ssize_t
-ext2_listxattr(struct dentry *dentry, char *buffer, size_t size)
+ext2_listxattr(struct dentry *dentry, char *buffer, size_t size,
+	       struct file *file)
 {
 	return ext2_xattr_list(dentry->d_inode, buffer, size);
 }
Index: linux/fs/ext2/xattr.h
===================================================================
--- linux.orig/fs/ext2/xattr.h	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/ext2/xattr.h	2007-09-21 13:45:11.000000000 +0200
@@ -61,7 +61,7 @@ extern struct xattr_handler ext2_xattr_a
 extern struct xattr_handler ext2_xattr_acl_default_handler;
 extern struct xattr_handler ext2_xattr_security_handler;
 
-extern ssize_t ext2_listxattr(struct dentry *, char *, size_t);
+extern ssize_t ext2_listxattr(struct dentry *, char *, size_t, struct file *);
 
 extern int ext2_xattr_get(struct inode *, int, const char *, void *, size_t);
 extern int ext2_xattr_set(struct inode *, int, const char *, const void *, size_t, int);
Index: linux/fs/ext3/xattr.c
===================================================================
--- linux.orig/fs/ext3/xattr.c	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/ext3/xattr.c	2007-09-21 13:45:11.000000000 +0200
@@ -143,7 +143,8 @@ ext3_xattr_handler(int name_index)
  * dentry->d_inode->i_mutex: don't care
  */
 ssize_t
-ext3_listxattr(struct dentry *dentry, char *buffer, size_t size)
+ext3_listxattr(struct dentry *dentry, char *buffer, size_t size,
+	       struct file *file)
 {
 	return ext3_xattr_list(dentry->d_inode, buffer, size);
 }
Index: linux/fs/ext3/xattr.h
===================================================================
--- linux.orig/fs/ext3/xattr.h	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/ext3/xattr.h	2007-09-21 13:45:11.000000000 +0200
@@ -64,7 +64,7 @@ extern struct xattr_handler ext3_xattr_a
 extern struct xattr_handler ext3_xattr_acl_default_handler;
 extern struct xattr_handler ext3_xattr_security_handler;
 
-extern ssize_t ext3_listxattr(struct dentry *, char *, size_t);
+extern ssize_t ext3_listxattr(struct dentry *, char *, size_t, struct file *);
 
 extern int ext3_xattr_get(struct inode *, int, const char *, void *, size_t);
 extern int ext3_xattr_list(struct inode *, char *, size_t);
Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2007-09-21 13:45:07.000000000 +0200
+++ linux/fs/fuse/dir.c	2007-09-21 13:45:11.000000000 +0200
@@ -1118,7 +1118,8 @@ static int fuse_getattr(struct vfsmount 
 }
 
 static int fuse_setxattr(struct dentry *entry, const char *name,
-			 const void *value, size_t size, int flags)
+			 const void *value, size_t size, int flags,
+			 struct file *file)
 {
 	struct inode *inode = entry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -1156,7 +1157,7 @@ static int fuse_setxattr(struct dentry *
 }
 
 static ssize_t fuse_getxattr(struct dentry *entry, const char *name,
-			     void *value, size_t size)
+			     void *value, size_t size, struct file *file)
 {
 	struct inode *inode = entry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -1205,7 +1206,8 @@ static ssize_t fuse_getxattr(struct dent
 	return ret;
 }
 
-static ssize_t fuse_listxattr(struct dentry *entry, char *list, size_t size)
+static ssize_t fuse_listxattr(struct dentry *entry, char *list, size_t size,
+			      struct file *file)
 {
 	struct inode *inode = entry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -1255,7 +1257,8 @@ static ssize_t fuse_listxattr(struct den
 	return ret;
 }
 
-static int fuse_removexattr(struct dentry *entry, const char *name)
+static int fuse_removexattr(struct dentry *entry, const char *name,
+			    struct file *file)
 {
 	struct inode *inode = entry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
Index: linux/fs/nfs/nfs3acl.c
===================================================================
--- linux.orig/fs/nfs/nfs3acl.c	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/nfs/nfs3acl.c	2007-09-21 13:45:11.000000000 +0200
@@ -7,7 +7,8 @@
 
 #define NFSDBG_FACILITY	NFSDBG_PROC
 
-ssize_t nfs3_listxattr(struct dentry *dentry, char *buffer, size_t size)
+ssize_t nfs3_listxattr(struct dentry *dentry, char *buffer, size_t size,
+		       struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	struct posix_acl *acl;
@@ -47,7 +48,7 @@ ssize_t nfs3_listxattr(struct dentry *de
 }
 
 ssize_t nfs3_getxattr(struct dentry *dentry, const char *name,
-		void *buffer, size_t size)
+		void *buffer, size_t size, struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	struct posix_acl *acl;
@@ -76,7 +77,7 @@ ssize_t nfs3_getxattr(struct dentry *den
 }
 
 int nfs3_setxattr(struct dentry *dentry, const char *name,
-	     const void *value, size_t size, int flags)
+	     const void *value, size_t size, int flags, struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	struct posix_acl *acl;
@@ -98,7 +99,7 @@ int nfs3_setxattr(struct dentry *dentry,
 	return error;
 }
 
-int nfs3_removexattr(struct dentry *dentry, const char *name)
+int nfs3_removexattr(struct dentry *dentry, const char *name, struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	int type;
Index: linux/fs/nfs/nfs4_fs.h
===================================================================
--- linux.orig/fs/nfs/nfs4_fs.h	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/nfs/nfs4_fs.h	2007-09-21 13:45:11.000000000 +0200
@@ -167,9 +167,11 @@ extern struct dentry_operations nfs4_den
 extern const struct inode_operations nfs4_dir_inode_operations;
 
 /* inode.c */
-extern ssize_t nfs4_getxattr(struct dentry *, const char *, void *, size_t);
-extern int nfs4_setxattr(struct dentry *, const char *, const void *, size_t, int);
-extern ssize_t nfs4_listxattr(struct dentry *, char *, size_t);
+extern ssize_t nfs4_getxattr(struct dentry *, const char *, void *, size_t,
+			     struct file *);
+extern int nfs4_setxattr(struct dentry *, const char *, const void *, size_t,
+			 int, struct file *);
+extern ssize_t nfs4_listxattr(struct dentry *, char *, size_t, struct file *);
 
 
 /* nfs4proc.c */
Index: linux/fs/nfs/nfs4proc.c
===================================================================
--- linux.orig/fs/nfs/nfs4proc.c	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/nfs/nfs4proc.c	2007-09-21 13:45:11.000000000 +0200
@@ -3598,7 +3598,7 @@ out:
 #define XATTR_NAME_NFSV4_ACL "system.nfs4_acl"
 
 int nfs4_setxattr(struct dentry *dentry, const char *key, const void *buf,
-		size_t buflen, int flags)
+		size_t buflen, int flags, struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 
@@ -3617,7 +3617,7 @@ int nfs4_setxattr(struct dentry *dentry,
  * But we'll follow ext2/ext3's lead by returning -EOPNOTSUPP for unsupported
  * attributes in kernel-managed attribute namespaces. */
 ssize_t nfs4_getxattr(struct dentry *dentry, const char *key, void *buf,
-		size_t buflen)
+		size_t buflen, struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 
@@ -3627,7 +3627,8 @@ ssize_t nfs4_getxattr(struct dentry *den
 	return nfs4_proc_get_acl(inode, buf, buflen);
 }
 
-ssize_t nfs4_listxattr(struct dentry *dentry, char *buf, size_t buflen)
+ssize_t nfs4_listxattr(struct dentry *dentry, char *buf, size_t buflen,
+		       struct file *file)
 {
 	size_t len = strlen(XATTR_NAME_NFSV4_ACL) + 1;
 
Index: linux/fs/revoked_inode.c
===================================================================
--- linux.orig/fs/revoked_inode.c	2007-09-21 13:45:07.000000000 +0200
+++ linux/fs/revoked_inode.c	2007-09-21 13:45:11.000000000 +0200
@@ -306,24 +306,27 @@ static int revoked_inode_setattr(struct 
 }
 
 static int revoked_inode_setxattr(struct dentry *dentry, const char *name,
-				  const void *value, size_t size, int flags)
+				  const void *value, size_t size, int flags,
+				  struct file *file)
 {
 	return -EBADF;
 }
 
 static ssize_t revoked_inode_getxattr(struct dentry *dentry, const char *name,
-				      void *buffer, size_t size)
+				      void *buffer, size_t size,
+				      struct file *file)
 {
 	return -EBADF;
 }
 
 static ssize_t revoked_inode_listxattr(struct dentry *dentry, char *buffer,
-				       size_t buffer_size)
+				       size_t buffer_size, struct file *file)
 {
 	return -EBADF;
 }
 
-static int revoked_inode_removexattr(struct dentry *dentry, const char *name)
+static int revoked_inode_removexattr(struct dentry *dentry, const char *name,
+				     struct file *file)
 {
 	return -EBADF;
 }
Index: linux/fs/xattr.c
===================================================================
--- linux.orig/fs/xattr.c	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/xattr.c	2007-09-21 13:45:11.000000000 +0200
@@ -67,9 +67,8 @@ xattr_permission(struct inode *inode, co
 	return permission(inode, mask, NULL);
 }
 
-int
-vfs_setxattr(struct dentry *dentry, char *name, void *value,
-		size_t size, int flags)
+static int vfs_fsetxattr(struct dentry *dentry, char *name, void *value,
+			 size_t size, int flags, struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -84,7 +83,8 @@ vfs_setxattr(struct dentry *dentry, char
 		goto out;
 	error = -EOPNOTSUPP;
 	if (inode->i_op->setxattr) {
-		error = inode->i_op->setxattr(dentry, name, value, size, flags);
+		error = inode->i_op->setxattr(dentry, name, value, size, flags,
+					      file);
 		if (!error) {
 			fsnotify_xattr(dentry);
 			security_inode_post_setxattr(dentry, name, value,
@@ -102,10 +102,16 @@ out:
 	mutex_unlock(&inode->i_mutex);
 	return error;
 }
+
+int vfs_setxattr(struct dentry *dentry, char *name, void *value,
+		 size_t size, int flags)
+{
+	return vfs_fsetxattr(dentry, name, value, size, flags, NULL);
+}
 EXPORT_SYMBOL_GPL(vfs_setxattr);
 
-ssize_t
-vfs_getxattr(struct dentry *dentry, char *name, void *value, size_t size)
+static ssize_t vfs_fgetxattr(struct dentry *dentry, char *name, void *value,
+			     size_t size, struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -119,7 +125,7 @@ vfs_getxattr(struct dentry *dentry, char
 		return error;
 
 	if (inode->i_op->getxattr)
-		error = inode->i_op->getxattr(dentry, name, value, size);
+		error = inode->i_op->getxattr(dentry, name, value, size, file);
 	else
 		error = -EOPNOTSUPP;
 
@@ -138,10 +144,17 @@ vfs_getxattr(struct dentry *dentry, char
 
 	return error;
 }
+
+ssize_t vfs_getxattr(struct dentry *dentry, char *name, void *value,
+		     size_t size)
+{
+	return vfs_fgetxattr(dentry, name, value, size, NULL);
+}
 EXPORT_SYMBOL_GPL(vfs_getxattr);
 
-ssize_t
-vfs_listxattr(struct dentry *d, char *list, size_t size)
+
+static ssize_t vfs_flistxattr(struct dentry *d, char *list, size_t size,
+			      struct file *file)
 {
 	ssize_t error;
 
@@ -150,7 +163,7 @@ vfs_listxattr(struct dentry *d, char *li
 		return error;
 	error = -EOPNOTSUPP;
 	if (d->d_inode->i_op && d->d_inode->i_op->listxattr) {
-		error = d->d_inode->i_op->listxattr(d, list, size);
+		error = d->d_inode->i_op->listxattr(d, list, size, file);
 	} else {
 		error = security_inode_listsecurity(d->d_inode, list, size);
 		if (size && error > size)
@@ -158,10 +171,15 @@ vfs_listxattr(struct dentry *d, char *li
 	}
 	return error;
 }
+
+ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size)
+{
+	return vfs_flistxattr(d, list, size, NULL);
+}
 EXPORT_SYMBOL_GPL(vfs_listxattr);
 
-int
-vfs_removexattr(struct dentry *dentry, char *name)
+static int vfs_fremovexattr(struct dentry *dentry, char *name,
+			    struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -178,13 +196,18 @@ vfs_removexattr(struct dentry *dentry, c
 		return error;
 
 	mutex_lock(&inode->i_mutex);
-	error = inode->i_op->removexattr(dentry, name);
+	error = inode->i_op->removexattr(dentry, name, file);
 	mutex_unlock(&inode->i_mutex);
 
 	if (!error)
 		fsnotify_xattr(dentry);
 	return error;
 }
+
+int vfs_removexattr(struct dentry *dentry, char *name)
+{
+	return vfs_fremovexattr(dentry, name, NULL);
+}
 EXPORT_SYMBOL_GPL(vfs_removexattr);
 
 
@@ -193,7 +216,7 @@ EXPORT_SYMBOL_GPL(vfs_removexattr);
  */
 static long
 setxattr(struct dentry *d, char __user *name, void __user *value,
-	 size_t size, int flags)
+	 size_t size, int flags, struct file *file)
 {
 	int error;
 	void *kvalue = NULL;
@@ -220,7 +243,7 @@ setxattr(struct dentry *d, char __user *
 		}
 	}
 
-	error = vfs_setxattr(d, kname, kvalue, size, flags);
+	error = vfs_fsetxattr(d, kname, kvalue, size, flags, file);
 	kfree(kvalue);
 	return error;
 }
@@ -235,7 +258,7 @@ sys_setxattr(char __user *path, char __u
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = setxattr(nd.dentry, name, value, size, flags);
+	error = setxattr(nd.dentry, name, value, size, flags, NULL);
 	path_release(&nd);
 	return error;
 }
@@ -250,7 +273,7 @@ sys_lsetxattr(char __user *path, char __
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = setxattr(nd.dentry, name, value, size, flags);
+	error = setxattr(nd.dentry, name, value, size, flags, NULL);
 	path_release(&nd);
 	return error;
 }
@@ -268,7 +291,7 @@ sys_fsetxattr(int fd, char __user *name,
 		return error;
 	dentry = f->f_path.dentry;
 	audit_inode(NULL, dentry);
-	error = setxattr(dentry, name, value, size, flags);
+	error = setxattr(dentry, name, value, size, flags, f);
 	fput(f);
 	return error;
 }
@@ -277,7 +300,8 @@ sys_fsetxattr(int fd, char __user *name,
  * Extended attribute GET operations
  */
 static ssize_t
-getxattr(struct dentry *d, char __user *name, void __user *value, size_t size)
+getxattr(struct dentry *d, char __user *name, void __user *value, size_t size,
+	 struct file *file)
 {
 	ssize_t error;
 	void *kvalue = NULL;
@@ -297,7 +321,7 @@ getxattr(struct dentry *d, char __user *
 			return -ENOMEM;
 	}
 
-	error = vfs_getxattr(d, kname, kvalue, size);
+	error = vfs_fgetxattr(d, kname, kvalue, size, file);
 	if (error > 0) {
 		if (size && copy_to_user(value, kvalue, error))
 			error = -EFAULT;
@@ -320,7 +344,7 @@ sys_getxattr(char __user *path, char __u
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = getxattr(nd.dentry, name, value, size);
+	error = getxattr(nd.dentry, name, value, size, NULL);
 	path_release(&nd);
 	return error;
 }
@@ -335,7 +359,7 @@ sys_lgetxattr(char __user *path, char __
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = getxattr(nd.dentry, name, value, size);
+	error = getxattr(nd.dentry, name, value, size, NULL);
 	path_release(&nd);
 	return error;
 }
@@ -350,7 +374,7 @@ sys_fgetxattr(int fd, char __user *name,
 	if (!f)
 		return error;
 	audit_inode(NULL, f->f_path.dentry);
-	error = getxattr(f->f_path.dentry, name, value, size);
+	error = getxattr(f->f_path.dentry, name, value, size, f);
 	fput(f);
 	return error;
 }
@@ -359,7 +383,7 @@ sys_fgetxattr(int fd, char __user *name,
  * Extended attribute LIST operations
  */
 static ssize_t
-listxattr(struct dentry *d, char __user *list, size_t size)
+listxattr(struct dentry *d, char __user *list, size_t size, struct file *file)
 {
 	ssize_t error;
 	char *klist = NULL;
@@ -372,7 +396,7 @@ listxattr(struct dentry *d, char __user 
 			return -ENOMEM;
 	}
 
-	error = vfs_listxattr(d, klist, size);
+	error = vfs_flistxattr(d, klist, size, file);
 	if (error > 0) {
 		if (size && copy_to_user(list, klist, error))
 			error = -EFAULT;
@@ -394,7 +418,7 @@ sys_listxattr(char __user *path, char __
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = listxattr(nd.dentry, list, size);
+	error = listxattr(nd.dentry, list, size, NULL);
 	path_release(&nd);
 	return error;
 }
@@ -408,7 +432,7 @@ sys_llistxattr(char __user *path, char _
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = listxattr(nd.dentry, list, size);
+	error = listxattr(nd.dentry, list, size, NULL);
 	path_release(&nd);
 	return error;
 }
@@ -423,7 +447,7 @@ sys_flistxattr(int fd, char __user *list
 	if (!f)
 		return error;
 	audit_inode(NULL, f->f_path.dentry);
-	error = listxattr(f->f_path.dentry, list, size);
+	error = listxattr(f->f_path.dentry, list, size, f);
 	fput(f);
 	return error;
 }
@@ -432,7 +456,7 @@ sys_flistxattr(int fd, char __user *list
  * Extended attribute REMOVE operations
  */
 static long
-removexattr(struct dentry *d, char __user *name)
+removexattr(struct dentry *d, char __user *name, struct file *file)
 {
 	int error;
 	char kname[XATTR_NAME_MAX + 1];
@@ -443,7 +467,7 @@ removexattr(struct dentry *d, char __use
 	if (error < 0)
 		return error;
 
-	return vfs_removexattr(d, kname);
+	return vfs_fremovexattr(d, kname, file);
 }
 
 asmlinkage long
@@ -455,7 +479,7 @@ sys_removexattr(char __user *path, char 
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = removexattr(nd.dentry, name);
+	error = removexattr(nd.dentry, name, NULL);
 	path_release(&nd);
 	return error;
 }
@@ -469,7 +493,7 @@ sys_lremovexattr(char __user *path, char
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = removexattr(nd.dentry, name);
+	error = removexattr(nd.dentry, name, NULL);
 	path_release(&nd);
 	return error;
 }
@@ -486,7 +510,7 @@ sys_fremovexattr(int fd, char __user *na
 		return error;
 	dentry = f->f_path.dentry;
 	audit_inode(NULL, dentry);
-	error = removexattr(dentry, name);
+	error = removexattr(dentry, name, f);
 	fput(f);
 	return error;
 }
@@ -541,7 +565,8 @@ xattr_resolve_name(struct xattr_handler 
  * Find the handler for the prefix and dispatch its get() operation.
  */
 ssize_t
-generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size)
+generic_getxattr(struct dentry *dentry, const char *name, void *buffer,
+		 size_t size, struct file *file)
 {
 	struct xattr_handler *handler;
 	struct inode *inode = dentry->d_inode;
@@ -557,7 +582,8 @@ generic_getxattr(struct dentry *dentry, 
  * list.
  */
 ssize_t
-generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
+generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size,
+		  struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	struct xattr_handler *handler, **handlers = inode->i_sb->s_xattr;
@@ -585,7 +611,8 @@ generic_listxattr(struct dentry *dentry,
  * Find the handler for the prefix and dispatch its set() operation.
  */
 int
-generic_setxattr(struct dentry *dentry, const char *name, const void *value, size_t size, int flags)
+generic_setxattr(struct dentry *dentry, const char *name, const void *value,
+		 size_t size, int flags, struct file *file)
 {
 	struct xattr_handler *handler;
 	struct inode *inode = dentry->d_inode;
@@ -603,7 +630,7 @@ generic_setxattr(struct dentry *dentry, 
  * any associated extended attribute.
  */
 int
-generic_removexattr(struct dentry *dentry, const char *name)
+generic_removexattr(struct dentry *dentry, const char *name, struct file *file)
 {
 	struct xattr_handler *handler;
 	struct inode *inode = dentry->d_inode;
Index: linux/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-09-21 13:45:07.000000000 +0200
+++ linux/fs/xfs/linux-2.6/xfs_iops.c	2007-09-21 13:45:11.000000000 +0200
@@ -666,7 +666,8 @@ xfs_vn_setxattr(
 	const char	*name,
 	const void	*data,
 	size_t		size,
-	int		flags)
+	int		flags,
+	struct file	*file)
 {
 	bhv_vnode_t	*vp = vn_from_inode(dentry->d_inode);
 	char		*attr = (char *)name;
@@ -696,7 +697,8 @@ xfs_vn_getxattr(
 	struct dentry	*dentry,
 	const char	*name,
 	void		*data,
-	size_t		size)
+	size_t		size,
+	struct file	*file)
 {
 	bhv_vnode_t	*vp = vn_from_inode(dentry->d_inode);
 	char		*attr = (char *)name;
@@ -725,7 +727,8 @@ STATIC ssize_t
 xfs_vn_listxattr(
 	struct dentry		*dentry,
 	char			*data,
-	size_t			size)
+	size_t			size,
+	struct file		*file)
 {
 	bhv_vnode_t		*vp = vn_from_inode(dentry->d_inode);
 	int			error, xflags = ATTR_KERNAMELS;
@@ -744,7 +747,8 @@ xfs_vn_listxattr(
 STATIC int
 xfs_vn_removexattr(
 	struct dentry	*dentry,
-	const char	*name)
+	const char	*name,
+	struct file	*file)
 {
 	bhv_vnode_t	*vp = vn_from_inode(dentry->d_inode);
 	char		*attr = (char *)name;
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2007-09-21 13:45:07.000000000 +0200
+++ linux/include/linux/fs.h	2007-09-21 13:45:11.000000000 +0200
@@ -1214,10 +1214,12 @@ struct inode_operations {
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *,
 			struct file *file);
-	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
-	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t);
-	ssize_t (*listxattr) (struct dentry *, char *, size_t);
-	int (*removexattr) (struct dentry *, const char *);
+	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int,
+			 struct file *);
+	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t,
+			     struct file *);
+	ssize_t (*listxattr) (struct dentry *, char *, size_t, struct file *);
+	int (*removexattr) (struct dentry *, const char *, struct file *);
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
 	long (*fallocate)(struct inode *inode, int mode, loff_t offset,
 			  loff_t len);
Index: linux/include/linux/nfs_fs.h
===================================================================
--- linux.orig/include/linux/nfs_fs.h	2007-09-21 13:45:07.000000000 +0200
+++ linux/include/linux/nfs_fs.h	2007-09-21 13:45:11.000000000 +0200
@@ -343,11 +343,12 @@ static inline struct rpc_cred *nfs_file_
  * linux/fs/nfs/xattr.c
  */
 #ifdef CONFIG_NFS_V3_ACL
-extern ssize_t nfs3_listxattr(struct dentry *, char *, size_t);
-extern ssize_t nfs3_getxattr(struct dentry *, const char *, void *, size_t);
+extern ssize_t nfs3_listxattr(struct dentry *, char *, size_t, struct file *);
+extern ssize_t nfs3_getxattr(struct dentry *, const char *, void *, size_t,
+			     struct file *);
 extern int nfs3_setxattr(struct dentry *, const char *,
-			const void *, size_t, int);
-extern int nfs3_removexattr (struct dentry *, const char *name);
+			const void *, size_t, int, struct file *);
+extern int nfs3_removexattr (struct dentry *, const char *name, struct file *);
 #else
 # define nfs3_listxattr NULL
 # define nfs3_getxattr NULL
Index: linux/include/linux/xattr.h
===================================================================
--- linux.orig/include/linux/xattr.h	2007-09-21 13:44:54.000000000 +0200
+++ linux/include/linux/xattr.h	2007-09-21 13:45:11.000000000 +0200
@@ -51,10 +51,14 @@ ssize_t vfs_listxattr(struct dentry *d, 
 int vfs_setxattr(struct dentry *, char *, void *, size_t, int);
 int vfs_removexattr(struct dentry *, char *);
 
-ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);
-ssize_t generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size);
-int generic_setxattr(struct dentry *dentry, const char *name, const void *value, size_t size, int flags);
-int generic_removexattr(struct dentry *dentry, const char *name);
+ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer,
+			 size_t size, struct file *);
+ssize_t generic_listxattr(struct dentry *dentry, char *buffer,
+			  size_t buffer_size, struct file *);
+int generic_setxattr(struct dentry *dentry, const char *name,
+		     const void *value, size_t size, int flags, struct file *);
+int generic_removexattr(struct dentry *dentry, const char *name,
+			struct file *);
 
 #endif  /*  __KERNEL__  */
 
Index: linux/fs/ext4/xattr.c
===================================================================
--- linux.orig/fs/ext4/xattr.c	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/ext4/xattr.c	2007-09-21 13:45:11.000000000 +0200
@@ -136,7 +136,8 @@ ext4_xattr_handler(int name_index)
  * dentry->d_inode->i_mutex: don't care
  */
 ssize_t
-ext4_listxattr(struct dentry *dentry, char *buffer, size_t size)
+ext4_listxattr(struct dentry *dentry, char *buffer, size_t size,
+	       struct file *file)
 {
 	return ext4_xattr_list(dentry->d_inode, buffer, size);
 }
Index: linux/fs/ext4/xattr.h
===================================================================
--- linux.orig/fs/ext4/xattr.h	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/ext4/xattr.h	2007-09-21 13:45:11.000000000 +0200
@@ -71,7 +71,7 @@ extern struct xattr_handler ext4_xattr_a
 extern struct xattr_handler ext4_xattr_acl_default_handler;
 extern struct xattr_handler ext4_xattr_security_handler;
 
-extern ssize_t ext4_listxattr(struct dentry *, char *, size_t);
+extern ssize_t ext4_listxattr(struct dentry *, char *, size_t, struct file *);
 
 extern int ext4_xattr_get(struct inode *, int, const char *, void *, size_t);
 extern int ext4_xattr_list(struct inode *, char *, size_t);
Index: linux/fs/gfs2/ops_inode.c
===================================================================
--- linux.orig/fs/gfs2/ops_inode.c	2007-09-21 13:45:07.000000000 +0200
+++ linux/fs/gfs2/ops_inode.c	2007-09-21 13:45:11.000000000 +0200
@@ -1064,7 +1064,8 @@ static int gfs2_getattr(struct vfsmount 
 }
 
 static int gfs2_setxattr(struct dentry *dentry, const char *name,
-			 const void *data, size_t size, int flags)
+			 const void *data, size_t size, int flags,
+			 struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	struct gfs2_ea_request er;
@@ -1084,7 +1085,7 @@ static int gfs2_setxattr(struct dentry *
 }
 
 static ssize_t gfs2_getxattr(struct dentry *dentry, const char *name,
-			     void *data, size_t size)
+			     void *data, size_t size, struct file *file)
 {
 	struct gfs2_ea_request er;
 
@@ -1099,7 +1100,8 @@ static ssize_t gfs2_getxattr(struct dent
 	return gfs2_ea_get(GFS2_I(dentry->d_inode), &er);
 }
 
-static ssize_t gfs2_listxattr(struct dentry *dentry, char *buffer, size_t size)
+static ssize_t gfs2_listxattr(struct dentry *dentry, char *buffer, size_t size,
+			      struct file *file)
 {
 	struct gfs2_ea_request er;
 
@@ -1110,7 +1112,8 @@ static ssize_t gfs2_listxattr(struct den
 	return gfs2_ea_list(GFS2_I(dentry->d_inode), &er);
 }
 
-static int gfs2_removexattr(struct dentry *dentry, const char *name)
+static int gfs2_removexattr(struct dentry *dentry, const char *name,
+			    struct file *file)
 {
 	struct gfs2_ea_request er;
 
Index: linux/fs/hfs/attr.c
===================================================================
--- linux.orig/fs/hfs/attr.c	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/hfs/attr.c	2007-09-21 13:45:11.000000000 +0200
@@ -14,7 +14,8 @@
 #include "btree.h"
 
 int hfs_setxattr(struct dentry *dentry, const char *name,
-		 const void *value, size_t size, int flags)
+		 const void *value, size_t size, int flags,
+		 struct file *unused_file)
 {
 	struct inode *inode = dentry->d_inode;
 	struct hfs_find_data fd;
@@ -57,7 +58,7 @@ out:
 }
 
 ssize_t hfs_getxattr(struct dentry *dentry, const char *name,
-			 void *value, size_t size)
+			 void *value, size_t size, struct file *unused_file)
 {
 	struct inode *inode = dentry->d_inode;
 	struct hfs_find_data fd;
@@ -103,7 +104,8 @@ out:
 
 #define HFS_ATTRLIST_SIZE (sizeof("hfs.creator")+sizeof("hfs.type"))
 
-ssize_t hfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
+ssize_t hfs_listxattr(struct dentry *dentry, char *buffer, size_t size,
+		      struct file *unused_file)
 {
 	struct inode *inode = dentry->d_inode;
 
Index: linux/fs/hfs/hfs_fs.h
===================================================================
--- linux.orig/fs/hfs/hfs_fs.h	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/hfs/hfs_fs.h	2007-09-21 13:45:11.000000000 +0200
@@ -197,10 +197,12 @@ extern void hfs_delete_inode(struct inod
 
 /* attr.c */
 extern int hfs_setxattr(struct dentry *dentry, const char *name,
-			const void *value, size_t size, int flags);
+			const void *value, size_t size, int flags,
+			struct file *);
 extern ssize_t hfs_getxattr(struct dentry *dentry, const char *name,
-			    void *value, size_t size);
-extern ssize_t hfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
+			    void *value, size_t size, struct file *);
+extern ssize_t hfs_listxattr(struct dentry *dentry, char *buffer, size_t size,
+			     struct file *);
 
 /* mdb.c */
 extern int hfs_mdb_get(struct super_block *);
Index: linux/fs/hfsplus/hfsplus_fs.h
===================================================================
--- linux.orig/fs/hfsplus/hfsplus_fs.h	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/hfsplus/hfsplus_fs.h	2007-09-21 13:45:11.000000000 +0200
@@ -335,10 +335,11 @@ void hfsplus_delete_inode(struct inode *
 int hfsplus_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 		  unsigned long arg);
 int hfsplus_setxattr(struct dentry *dentry, const char *name,
-		     const void *value, size_t size, int flags);
+		     const void *value, size_t size, int flags, struct file *);
 ssize_t hfsplus_getxattr(struct dentry *dentry, const char *name,
-			 void *value, size_t size);
-ssize_t hfsplus_listxattr(struct dentry *dentry, char *buffer, size_t size);
+			 void *value, size_t size, struct file *);
+ssize_t hfsplus_listxattr(struct dentry *dentry, char *buffer, size_t size,
+			  struct file *);
 
 /* options.c */
 int hfsplus_parse_options(char *, struct hfsplus_sb_info *);
Index: linux/fs/hfsplus/ioctl.c
===================================================================
--- linux.orig/fs/hfsplus/ioctl.c	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/hfsplus/ioctl.c	2007-09-21 13:45:11.000000000 +0200
@@ -83,7 +83,8 @@ int hfsplus_ioctl(struct inode *inode, s
 }
 
 int hfsplus_setxattr(struct dentry *dentry, const char *name,
-		     const void *value, size_t size, int flags)
+		     const void *value, size_t size, int flags,
+		     struct file *unused_file)
 {
 	struct inode *inode = dentry->d_inode;
 	struct hfs_find_data fd;
@@ -125,7 +126,7 @@ out:
 }
 
 ssize_t hfsplus_getxattr(struct dentry *dentry, const char *name,
-			 void *value, size_t size)
+			 void *value, size_t size, struct file *unused_file)
 {
 	struct inode *inode = dentry->d_inode;
 	struct hfs_find_data fd;
@@ -170,7 +171,8 @@ out:
 
 #define HFSPLUS_ATTRLIST_SIZE (sizeof("hfs.creator")+sizeof("hfs.type"))
 
-ssize_t hfsplus_listxattr(struct dentry *dentry, char *buffer, size_t size)
+ssize_t hfsplus_listxattr(struct dentry *dentry, char *buffer, size_t size,
+			  struct file *unused_file)
 {
 	struct inode *inode = dentry->d_inode;
 
Index: linux/fs/reiserfs/xattr.c
===================================================================
--- linux.orig/fs/reiserfs/xattr.c	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/reiserfs/xattr.c	2007-09-21 13:45:11.000000000 +0200
@@ -896,7 +896,7 @@ int reiserfs_chown_xattrs(struct inode *
  */
 ssize_t
 reiserfs_getxattr(struct dentry * dentry, const char *name, void *buffer,
-		  size_t size)
+		  size_t size, struct file *file)
 {
 	struct reiserfs_xattr_handler *xah = find_xattr_handler_prefix(name);
 	int err;
@@ -920,7 +920,7 @@ reiserfs_getxattr(struct dentry * dentry
  */
 int
 reiserfs_setxattr(struct dentry *dentry, const char *name, const void *value,
-		  size_t size, int flags)
+		  size_t size, int flags, struct file *file)
 {
 	struct reiserfs_xattr_handler *xah = find_xattr_handler_prefix(name);
 	int err;
@@ -950,7 +950,8 @@ reiserfs_setxattr(struct dentry *dentry,
  *
  * dentry->d_inode->i_mutex down
  */
-int reiserfs_removexattr(struct dentry *dentry, const char *name)
+int reiserfs_removexattr(struct dentry *dentry, const char *name,
+			 struct file *file)
 {
 	int err;
 	struct reiserfs_xattr_handler *xah = find_xattr_handler_prefix(name);
@@ -1027,7 +1028,8 @@ reiserfs_listxattr_filler(void *buf, con
  *
  * Preliminary locking: we down dentry->d_inode->i_mutex
  */
-ssize_t reiserfs_listxattr(struct dentry * dentry, char *buffer, size_t size)
+ssize_t reiserfs_listxattr(struct dentry * dentry, char *buffer, size_t size,
+			   struct file *unused_file)
 {
 	struct file *fp;
 	struct dentry *dir;
Index: linux/fs/unionfs/union.h
===================================================================
--- linux.orig/fs/unionfs/union.h	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/unionfs/union.h	2007-09-21 13:45:11.000000000 +0200
@@ -349,12 +349,14 @@ static inline void unionfs_xattr_kfree(c
 	kfree(p);
 }
 extern ssize_t unionfs_getxattr(struct dentry *dentry, const char *name,
-				void *value, size_t size);
-extern int unionfs_removexattr(struct dentry *dentry, const char *name);
+				void *value, size_t size, struct file *);
+extern int unionfs_removexattr(struct dentry *dentry, const char *name,
+			       struct file *);
 extern ssize_t unionfs_listxattr(struct dentry *dentry, char *list,
-				 size_t size);
+				 size_t size, struct file *);
 extern int unionfs_setxattr(struct dentry *dentry, const char *name,
-			    const void *value, size_t size, int flags);
+			    const void *value, size_t size, int flags,
+			    struct file *);
 #endif /* CONFIG_UNION_FS_XATTR */
 
 /* The root directory is unhashed, but isn't deleted. */
Index: linux/fs/unionfs/xattr.c
===================================================================
--- linux.orig/fs/unionfs/xattr.c	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/unionfs/xattr.c	2007-09-21 13:45:11.000000000 +0200
@@ -40,7 +40,7 @@ void *unionfs_xattr_alloc(size_t size, s
  * dentry->d_inode->i_mutex locked
  */
 ssize_t unionfs_getxattr(struct dentry *dentry, const char *name, void *value,
-			 size_t size)
+			 size_t size, struct file *file)
 {
 	struct dentry *lower_dentry = NULL;
 	int err = -EOPNOTSUPP;
@@ -69,7 +69,8 @@ out:
  * dentry->d_inode->i_mutex locked
  */
 int unionfs_setxattr(struct dentry *dentry, const char *name,
-		     const void *value, size_t size, int flags)
+		     const void *value, size_t size, int flags,
+		     struct file *file)
 {
 	struct dentry *lower_dentry = NULL;
 	int err = -EOPNOTSUPP;
@@ -98,7 +99,8 @@ out:
  * BKL held by caller.
  * dentry->d_inode->i_mutex locked
  */
-int unionfs_removexattr(struct dentry *dentry, const char *name)
+int unionfs_removexattr(struct dentry *dentry, const char *name,
+			struct file *file)
 {
 	struct dentry *lower_dentry = NULL;
 	int err = -EOPNOTSUPP;
@@ -126,7 +128,8 @@ out:
  * BKL held by caller.
  * dentry->d_inode->i_mutex locked
  */
-ssize_t unionfs_listxattr(struct dentry *dentry, char *list, size_t size)
+ssize_t unionfs_listxattr(struct dentry *dentry, char *list, size_t size,
+			  struct file *file)
 {
 	struct dentry *lower_dentry = NULL;
 	int err = -EOPNOTSUPP;
Index: linux/include/linux/reiserfs_xattr.h
===================================================================
--- linux.orig/include/linux/reiserfs_xattr.h	2007-09-21 13:44:54.000000000 +0200
+++ linux/include/linux/reiserfs_xattr.h	2007-09-21 13:45:11.000000000 +0200
@@ -47,11 +47,13 @@ struct reiserfs_xattr_handler {
 #define is_reiserfs_priv_object(inode) IS_PRIVATE(inode)
 #define has_xattr_dir(inode) (REISERFS_I(inode)->i_flags & i_has_xattr_dir)
 ssize_t reiserfs_getxattr(struct dentry *dentry, const char *name,
-			  void *buffer, size_t size);
+			  void *buffer, size_t size, struct file *);
 int reiserfs_setxattr(struct dentry *dentry, const char *name,
-		      const void *value, size_t size, int flags);
-ssize_t reiserfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
-int reiserfs_removexattr(struct dentry *dentry, const char *name);
+		      const void *value, size_t size, int flags, struct file *);
+ssize_t reiserfs_listxattr(struct dentry *dentry, char *buffer, size_t size,
+			   struct file *);
+int reiserfs_removexattr(struct dentry *dentry, const char *name,
+			 struct file *);
 int reiserfs_delete_xattrs(struct inode *inode);
 int reiserfs_chown_xattrs(struct inode *inode, struct iattr *attrs);
 int reiserfs_xattr_init(struct super_block *sb, int mount_flags);
Index: linux/fs/cifs/cifsfs.h
===================================================================
--- linux.orig/fs/cifs/cifsfs.h	2007-09-21 13:45:07.000000000 +0200
+++ linux/fs/cifs/cifsfs.h	2007-09-21 13:45:11.000000000 +0200
@@ -95,11 +95,12 @@ extern int cifs_readlink(struct dentry *
 			 int buflen);
 extern int cifs_symlink(struct inode *inode, struct dentry *direntry,
 			const char *symname);
-extern int	cifs_removexattr(struct dentry *, const char *);
+extern int	cifs_removexattr(struct dentry *, const char *, struct file *);
 extern int 	cifs_setxattr(struct dentry *, const char *, const void *,
-			size_t, int);
-extern ssize_t	cifs_getxattr(struct dentry *, const char *, void *, size_t);
-extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t);
+			size_t, int, struct file *);
+extern ssize_t	cifs_getxattr(struct dentry *, const char *, void *, size_t,
+			      struct file *);
+extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t, struct file *);
 extern int cifs_ioctl(struct inode *inode, struct file *filep,
 		       unsigned int command, unsigned long arg);
 #define CIFS_VERSION   "1.51"
Index: linux/fs/cifs/xattr.c
===================================================================
--- linux.orig/fs/cifs/xattr.c	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/cifs/xattr.c	2007-09-21 13:45:11.000000000 +0200
@@ -40,7 +40,8 @@
 
 
 
-int cifs_removexattr(struct dentry *direntry, const char *ea_name)
+int cifs_removexattr(struct dentry *direntry, const char *ea_name,
+		     struct file *file)
 {
 	int rc = -EOPNOTSUPP;
 #ifdef CONFIG_CIFS_XATTR
@@ -94,7 +95,8 @@ remove_ea_exit:
 }
 
 int cifs_setxattr(struct dentry *direntry, const char *ea_name,
-		  const void *ea_value, size_t value_size, int flags)
+		  const void *ea_value, size_t value_size, int flags,
+		  struct file *file)
 {
 	int rc = -EOPNOTSUPP;
 #ifdef CONFIG_CIFS_XATTR
@@ -200,7 +202,7 @@ set_ea_exit:
 }
 
 ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
-	void *ea_value, size_t buf_size)
+	void *ea_value, size_t buf_size, struct file *file)
 {
 	ssize_t rc = -EOPNOTSUPP;
 #ifdef CONFIG_CIFS_XATTR
@@ -318,7 +320,8 @@ get_ea_exit:
 	return rc;
 }
 
-ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t buf_size)
+ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t buf_size,
+		       struct file *file)
 {
 	ssize_t rc = -EOPNOTSUPP;
 #ifdef CONFIG_CIFS_XATTR
Index: linux/fs/ecryptfs/crypto.c
===================================================================
--- linux.orig/fs/ecryptfs/crypto.c	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/ecryptfs/crypto.c	2007-09-21 13:45:11.000000000 +0200
@@ -1445,7 +1445,7 @@ ecryptfs_write_metadata_to_xattr(struct 
 	int rc;
 
 	rc = ecryptfs_setxattr(ecryptfs_dentry, ECRYPTFS_XATTR_NAME, page_virt,
-			       size, 0);
+			       size, 0, NULL);
 	return rc;
 }
 
@@ -1640,7 +1640,7 @@ int ecryptfs_read_xattr_region(char *pag
 	int rc = 0;
 
 	size = ecryptfs_getxattr(ecryptfs_dentry, ECRYPTFS_XATTR_NAME,
-				 page_virt, ECRYPTFS_DEFAULT_EXTENT_SIZE);
+				 page_virt, ECRYPTFS_DEFAULT_EXTENT_SIZE, NULL);
 	if (size < 0) {
 		printk(KERN_DEBUG "Error attempting to read the [%s] "
 		       "xattr from the lower file; return value = [%zd]\n",
Index: linux/fs/ecryptfs/ecryptfs_kernel.h
===================================================================
--- linux.orig/fs/ecryptfs/ecryptfs_kernel.h	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/ecryptfs/ecryptfs_kernel.h	2007-09-21 13:45:11.000000000 +0200
@@ -587,10 +587,10 @@ int ecryptfs_open_lower_file(struct file
 			     struct vfsmount *lower_mnt, int flags);
 int ecryptfs_close_lower_file(struct file *lower_file);
 ssize_t ecryptfs_getxattr(struct dentry *dentry, const char *name, void *value,
-			  size_t size);
+			  size_t size, struct file *);
 int
 ecryptfs_setxattr(struct dentry *dentry, const char *name, const void *value,
-		  size_t size, int flags);
+		  size_t size, int flags, struct file *);
 int ecryptfs_read_xattr_region(char *page_virt, struct dentry *ecryptfs_dentry);
 int ecryptfs_process_helo(unsigned int transport, uid_t uid, pid_t pid);
 int ecryptfs_process_quit(uid_t uid, pid_t pid);
Index: linux/fs/ecryptfs/inode.c
===================================================================
--- linux.orig/fs/ecryptfs/inode.c	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/ecryptfs/inode.c	2007-09-21 13:45:11.000000000 +0200
@@ -967,7 +967,7 @@ out:
 
 int
 ecryptfs_setxattr(struct dentry *dentry, const char *name, const void *value,
-		  size_t size, int flags)
+		  size_t size, int flags, struct file *file)
 {
 	int rc = 0;
 	struct dentry *lower_dentry;
@@ -979,7 +979,7 @@ ecryptfs_setxattr(struct dentry *dentry,
 	}
 	mutex_lock(&lower_dentry->d_inode->i_mutex);
 	rc = lower_dentry->d_inode->i_op->setxattr(lower_dentry, name, value,
-						   size, flags);
+						   size, flags, NULL);
 	mutex_unlock(&lower_dentry->d_inode->i_mutex);
 out:
 	return rc;
@@ -987,7 +987,7 @@ out:
 
 ssize_t
 ecryptfs_getxattr(struct dentry *dentry, const char *name, void *value,
-		  size_t size)
+		  size_t size, struct file *file)
 {
 	int rc = 0;
 	struct dentry *lower_dentry;
@@ -999,14 +999,15 @@ ecryptfs_getxattr(struct dentry *dentry,
 	}
 	mutex_lock(&lower_dentry->d_inode->i_mutex);
 	rc = lower_dentry->d_inode->i_op->getxattr(lower_dentry, name, value,
-						   size);
+						   size, NULL);
 	mutex_unlock(&lower_dentry->d_inode->i_mutex);
 out:
 	return rc;
 }
 
 static ssize_t
-ecryptfs_listxattr(struct dentry *dentry, char *list, size_t size)
+ecryptfs_listxattr(struct dentry *dentry, char *list, size_t size,
+		   struct file *file)
 {
 	int rc = 0;
 	struct dentry *lower_dentry;
@@ -1017,13 +1018,15 @@ ecryptfs_listxattr(struct dentry *dentry
 		goto out;
 	}
 	mutex_lock(&lower_dentry->d_inode->i_mutex);
-	rc = lower_dentry->d_inode->i_op->listxattr(lower_dentry, list, size);
+	rc = lower_dentry->d_inode->i_op->listxattr(lower_dentry, list, size,
+						    NULL);
 	mutex_unlock(&lower_dentry->d_inode->i_mutex);
 out:
 	return rc;
 }
 
-static int ecryptfs_removexattr(struct dentry *dentry, const char *name)
+static int ecryptfs_removexattr(struct dentry *dentry, const char *name,
+				struct file *file)
 {
 	int rc = 0;
 	struct dentry *lower_dentry;
@@ -1034,7 +1037,7 @@ static int ecryptfs_removexattr(struct d
 		goto out;
 	}
 	mutex_lock(&lower_dentry->d_inode->i_mutex);
-	rc = lower_dentry->d_inode->i_op->removexattr(lower_dentry, name);
+	rc = lower_dentry->d_inode->i_op->removexattr(lower_dentry, name, NULL);
 	mutex_unlock(&lower_dentry->d_inode->i_mutex);
 out:
 	return rc;
Index: linux/fs/ecryptfs/mmap.c
===================================================================
--- linux.orig/fs/ecryptfs/mmap.c	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/ecryptfs/mmap.c	2007-09-21 13:45:11.000000000 +0200
@@ -532,7 +532,7 @@ static int ecryptfs_write_inode_size_to_
 	size = lower_dentry->d_inode->i_op->getxattr(lower_dentry,
 						     ECRYPTFS_XATTR_NAME,
 						     xattr_virt,
-						     PAGE_CACHE_SIZE);
+						     PAGE_CACHE_SIZE, NULL);
 	if (!lower_i_mutex_held)
 		mutex_unlock(&lower_dentry->d_inode->i_mutex);
 	if (size < 0)
@@ -544,7 +544,7 @@ static int ecryptfs_write_inode_size_to_
 		mutex_lock(&lower_dentry->d_inode->i_mutex);
 	rc = lower_dentry->d_inode->i_op->setxattr(lower_dentry,
 						   ECRYPTFS_XATTR_NAME,
-						   xattr_virt, size, 0);
+						   xattr_virt, size, 0, NULL);
 	if (!lower_i_mutex_held)
 		mutex_unlock(&lower_dentry->d_inode->i_mutex);
 	if (rc)
Index: linux/fs/jffs2/xattr.c
===================================================================
--- linux.orig/fs/jffs2/xattr.c	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/jffs2/xattr.c	2007-09-21 13:45:11.000000000 +0200
@@ -947,7 +947,8 @@ static struct xattr_handler *xprefix_to_
 	return ret;
 }
 
-ssize_t jffs2_listxattr(struct dentry *dentry, char *buffer, size_t size)
+ssize_t jffs2_listxattr(struct dentry *dentry, char *buffer, size_t size,
+			struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
Index: linux/fs/jffs2/xattr.h
===================================================================
--- linux.orig/fs/jffs2/xattr.h	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/jffs2/xattr.h	2007-09-21 13:45:11.000000000 +0200
@@ -97,7 +97,7 @@ extern struct xattr_handler *jffs2_xattr
 extern struct xattr_handler jffs2_user_xattr_handler;
 extern struct xattr_handler jffs2_trusted_xattr_handler;
 
-extern ssize_t jffs2_listxattr(struct dentry *, char *, size_t);
+extern ssize_t jffs2_listxattr(struct dentry *, char *, size_t, struct file *);
 #define jffs2_getxattr		generic_getxattr
 #define jffs2_setxattr		generic_setxattr
 #define jffs2_removexattr	generic_removexattr
Index: linux/fs/jfs/jfs_xattr.h
===================================================================
--- linux.orig/fs/jfs/jfs_xattr.h	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/jfs/jfs_xattr.h	2007-09-21 13:45:11.000000000 +0200
@@ -55,11 +55,13 @@ struct jfs_ea_list {
 extern int __jfs_setxattr(tid_t, struct inode *, const char *, const void *,
 			  size_t, int);
 extern int jfs_setxattr(struct dentry *, const char *, const void *, size_t,
-			int);
+			int, struct file *);
 extern ssize_t __jfs_getxattr(struct inode *, const char *, void *, size_t);
-extern ssize_t jfs_getxattr(struct dentry *, const char *, void *, size_t);
-extern ssize_t jfs_listxattr(struct dentry *, char *, size_t);
-extern int jfs_removexattr(struct dentry *, const char *);
+extern ssize_t jfs_getxattr(struct dentry *, const char *, void *, size_t,
+			    struct file *);
+extern ssize_t jfs_listxattr(struct dentry *, char *, size_t,
+			     struct file *);
+extern int jfs_removexattr(struct dentry *, const char *, struct file *);
 
 #ifdef CONFIG_JFS_SECURITY
 extern int jfs_init_security(tid_t, struct inode *, struct inode *);
Index: linux/fs/jfs/xattr.c
===================================================================
--- linux.orig/fs/jfs/xattr.c	2007-09-21 13:44:54.000000000 +0200
+++ linux/fs/jfs/xattr.c	2007-09-21 13:45:11.000000000 +0200
@@ -920,7 +920,7 @@ int __jfs_setxattr(tid_t tid, struct ino
 }
 
 int jfs_setxattr(struct dentry *dentry, const char *name, const void *value,
-		 size_t value_len, int flags)
+		 size_t value_len, int flags, struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	struct jfs_inode_info *ji = JFS_IP(inode);
@@ -1012,7 +1012,7 @@ ssize_t __jfs_getxattr(struct inode *ino
 }
 
 ssize_t jfs_getxattr(struct dentry *dentry, const char *name, void *data,
-		     size_t buf_size)
+		     size_t buf_size, struct file *file)
 {
 	int err;
 
@@ -1031,7 +1031,8 @@ static inline int can_list(struct jfs_ea
 		capable(CAP_SYS_ADMIN));
 }
 
-ssize_t jfs_listxattr(struct dentry * dentry, char *data, size_t buf_size)
+ssize_t jfs_listxattr(struct dentry * dentry, char *data, size_t buf_size,
+		      struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	char *buffer;
@@ -1084,7 +1085,7 @@ ssize_t jfs_listxattr(struct dentry * de
 	return size;
 }
 
-int jfs_removexattr(struct dentry *dentry, const char *name)
+int jfs_removexattr(struct dentry *dentry, const char *name, struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	struct jfs_inode_info *ji = JFS_IP(inode);
Index: linux/Documentation/filesystems/Locking
===================================================================
--- linux.orig/Documentation/filesystems/Locking	2007-09-21 13:45:07.000000000 +0200
+++ linux/Documentation/filesystems/Locking	2007-09-21 13:45:11.000000000 +0200
@@ -48,10 +48,12 @@ ata *);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *, struct dentry *, struct kstat *,
 			struct file *);
-	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
-	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t);
-	ssize_t (*listxattr) (struct dentry *, char *, size_t);
-	int (*removexattr) (struct dentry *, const char *);
+	int (*setxattr) (struct dentry *, const char *, const void *, size_t,
+			int, struct file *);
+	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t,
+			struct file *);
+	ssize_t (*listxattr) (struct dentry *, char *, size_t, struct file *);
+	int (*removexattr) (struct dentry *, const char *, struct file *);
 
 locking rules:
 	all may block, none have BKL
Index: linux/Documentation/filesystems/vfs.txt
===================================================================
--- linux.orig/Documentation/filesystems/vfs.txt	2007-09-21 13:45:07.000000000 +0200
+++ linux/Documentation/filesystems/vfs.txt	2007-09-21 13:45:11.000000000 +0200
@@ -344,10 +344,12 @@ struct inode_operations {
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *,
 			struct file *);
-	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
-	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t);
-	ssize_t (*listxattr) (struct dentry *, char *, size_t);
-	int (*removexattr) (struct dentry *, const char *);
+	int (*setxattr) (struct dentry *, const char *, const void *, size_t,
+			int, struct file *);
+	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t,
+			struct file *);
+	ssize_t (*listxattr) (struct dentry *, char *, size_t, struct file *);
+	int (*removexattr) (struct dentry *, const char *, struct file *);
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
 };
 

--
