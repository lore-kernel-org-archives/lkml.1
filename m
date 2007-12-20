Return-Path: <linux-kernel-owner+w=401wt.eu-S935017AbXLTO2C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935017AbXLTO2C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:28:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932956AbXLTOM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:12:59 -0500
Received: from mx1.suse.de ([195.135.220.2]:40952 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933025AbXLTOMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:12:53 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:46 2007
Message-Id: <20071220140946.618677120@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:44 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 34/47] Pass struct file down the inode_*xattr security LSM hooks
Content-Disposition: inline; filename=security-xattr-file.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows LSMs to also distinguish between file descriptor and path
access for the xattr operations. (The other relevant operations are
covered by the setattr hook.)

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/nfsd/vfs.c            |   12 +++++----
 fs/unionfs/copyup.c      |   12 +++++----
 fs/unionfs/xattr.c       |    9 +++----
 fs/xattr.c               |   60 +++++++++++++++++++++++++----------------------
 include/linux/security.h |   40 ++++++++++++++++++-------------
 include/linux/xattr.h    |   10 ++++---
 security/commoncap.c     |    4 +--
 security/dummy.c         |   10 ++++---
 security/security.c      |   21 +++++++++-------
 security/selinux/hooks.c |   10 ++++---
 10 files changed, 107 insertions(+), 81 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -413,7 +413,7 @@ static ssize_t nfsd_getxattr(struct dent
 {
 	ssize_t buflen;
 
-	buflen = vfs_getxattr(dentry, mnt, key, NULL, 0);
+	buflen = vfs_getxattr(dentry, mnt, key, NULL, 0, NULL);
 	if (buflen <= 0)
 		return buflen;
 
@@ -421,7 +421,7 @@ static ssize_t nfsd_getxattr(struct dent
 	if (!*buf)
 		return -ENOMEM;
 
-	return vfs_getxattr(dentry, mnt, key, *buf, buflen);
+	return vfs_getxattr(dentry, mnt, key, *buf, buflen, NULL);
 }
 #endif
 
@@ -447,7 +447,7 @@ set_nfsv4_acl_one(struct dentry *dentry,
 		goto out;
 	}
 
-	error = vfs_setxattr(dentry, mnt, key, buf, len, 0);
+	error = vfs_setxattr(dentry, mnt, key, buf, len, 0, NULL);
 out:
 	kfree(buf);
 	return error;
@@ -2067,12 +2067,14 @@ nfsd_set_posix_acl(struct svc_fh *fhp, i
 
 	mnt = fhp->fh_export->ex_path.mnt;
 	if (size)
-		error = vfs_setxattr(fhp->fh_dentry, mnt, name, value, size, 0);
+		error = vfs_setxattr(fhp->fh_dentry, mnt, name, value, size, 0,
+				     NULL);
 	else {
 		if (!S_ISDIR(inode->i_mode) && type == ACL_TYPE_DEFAULT)
 			error = 0;
 		else {
-			error = vfs_removexattr(fhp->fh_dentry, mnt, name);
+			error = vfs_removexattr(fhp->fh_dentry, mnt, name,
+						NULL);
 			if (error == -ENODATA)
 				error = 0;
 		}
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -37,7 +37,8 @@ static int copyup_xattrs(struct dentry *
 	char *name_list_buf = NULL;
 
 	/* query the actual size of the xattr list */
-	list_size = vfs_listxattr(old_lower_dentry, old_lower_mnt, NULL, 0);
+	list_size = vfs_listxattr(old_lower_dentry, old_lower_mnt, NULL, 0,
+				  NULL);
 	if (list_size <= 0) {
 		err = list_size;
 		goto out;
@@ -54,7 +55,7 @@ static int copyup_xattrs(struct dentry *
 
 	/* now get the actual xattr list of the source file */
 	list_size = vfs_listxattr(old_lower_dentry, old_lower_mnt, name_list,
-				  list_size);
+				  list_size, NULL);
 	if (list_size <= 0) {
 		err = list_size;
 		goto out;
@@ -74,7 +75,7 @@ static int copyup_xattrs(struct dentry *
 		/* Lock here since vfs_getxattr doesn't lock for us */
 		mutex_lock(&old_lower_dentry->d_inode->i_mutex);
 		size = vfs_getxattr(old_lower_dentry, old_lower_mnt, name_list,
-				    attr_value, XATTR_SIZE_MAX);
+				    attr_value, XATTR_SIZE_MAX, NULL);
 		mutex_unlock(&old_lower_dentry->d_inode->i_mutex);
 		if (size < 0) {
 			err = size;
@@ -86,7 +87,7 @@ static int copyup_xattrs(struct dentry *
 		}
 		/* Don't lock here since vfs_setxattr does it for us. */
 		err = vfs_setxattr(new_lower_dentry, new_lower_mnt, name_list,
-				   attr_value, size, 0);
+				   attr_value, size, 0, NULL);
 		/*
 		 * Selinux depends on "security.*" xattrs, so to maintain
 		 * the security of copied-up files, if Selinux is active,
@@ -97,7 +98,8 @@ static int copyup_xattrs(struct dentry *
 		if (err == -EPERM && !capable(CAP_FOWNER)) {
 			cap_raise(current->cap_effective, CAP_FOWNER);
 			err = vfs_setxattr(new_lower_dentry, new_lower_mnt,
-					   name_list, attr_value, size, 0);
+					   name_list, attr_value, size, 0,
+					   NULL);
 			cap_lower(current->cap_effective, CAP_FOWNER);
 		}
 		if (err < 0)
--- a/fs/unionfs/xattr.c
+++ b/fs/unionfs/xattr.c
@@ -57,7 +57,8 @@ ssize_t unionfs_getxattr(struct dentry *
 	lower_dentry = unionfs_lower_dentry(dentry);
 	lower_mnt = unionfs_lower_mnt(dentry);
 
-	err = vfs_getxattr(lower_dentry, lower_mnt, (char *) name, value, size);
+	err = vfs_getxattr(lower_dentry, lower_mnt, (char *) name, value, size,
+			   NULL);
 
 out:
 	unionfs_check_dentry(dentry);
@@ -90,7 +91,7 @@ int unionfs_setxattr(struct dentry *dent
 	lower_mnt = unionfs_lower_mnt(dentry);
 
 	err = vfs_setxattr(lower_dentry, lower_mnt, (char *) name,
-			   (void *) value, size, flags);
+			   (void *) value, size, flags, NULL);
 
 out:
 	unionfs_check_dentry(dentry);
@@ -120,7 +121,7 @@ int unionfs_removexattr(struct dentry *d
 	lower_dentry = unionfs_lower_dentry(dentry);
 	lower_mnt = unionfs_lower_mnt(dentry);
 
-	err = vfs_removexattr(lower_dentry, lower_mnt, (char *) name);
+	err = vfs_removexattr(lower_dentry, lower_mnt, (char *) name, NULL);
 
 out:
 	unionfs_check_dentry(dentry);
@@ -152,7 +153,7 @@ ssize_t unionfs_listxattr(struct dentry 
 	lower_mnt = unionfs_lower_mnt(dentry);
 
 	encoded_list = list;
-	err = vfs_listxattr(lower_dentry, lower_mnt, encoded_list, size);
+	err = vfs_listxattr(lower_dentry, lower_mnt, encoded_list, size, NULL);
 
 out:
 	unionfs_check_dentry(dentry);
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -68,7 +68,7 @@ xattr_permission(struct inode *inode, co
 
 int
 vfs_setxattr(struct dentry *dentry, struct vfsmount *mnt, char *name,
-	     void *value, size_t size, int flags)
+	     void *value, size_t size, int flags, struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -78,7 +78,7 @@ vfs_setxattr(struct dentry *dentry, stru
 		return error;
 
 	mutex_lock(&inode->i_mutex);
-	error = security_inode_setxattr(dentry, mnt, name, value, size, flags);
+	error = security_inode_setxattr(dentry, mnt, name, value, size, flags,						file);
 	if (error)
 		goto out;
 	error = -EOPNOTSUPP;
@@ -132,7 +132,7 @@ EXPORT_SYMBOL_GPL(xattr_getsecurity);
 
 ssize_t
 vfs_getxattr(struct dentry *dentry, struct vfsmount *mnt, char *name,
-	     void *value, size_t size)
+	     void *value, size_t size, struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -141,7 +141,7 @@ vfs_getxattr(struct dentry *dentry, stru
 	if (error)
 		return error;
 
-	error = security_inode_getxattr(dentry, mnt, name);
+	error = security_inode_getxattr(dentry, mnt, name, file);
 	if (error)
 		return error;
 
@@ -169,12 +169,12 @@ EXPORT_SYMBOL_GPL(vfs_getxattr);
 
 ssize_t
 vfs_listxattr(struct dentry *dentry, struct vfsmount *mnt, char *list,
-	      size_t size)
+	      size_t size, struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	ssize_t error;
 
-	error = security_inode_listxattr(dentry, mnt);
+	error = security_inode_listxattr(dentry, mnt, file);
 	if (error)
 		return error;
 	error = -EOPNOTSUPP;
@@ -190,7 +190,8 @@ vfs_listxattr(struct dentry *dentry, str
 EXPORT_SYMBOL_GPL(vfs_listxattr);
 
 int
-vfs_removexattr(struct dentry *dentry, struct vfsmount *mnt, char *name)
+vfs_removexattr(struct dentry *dentry, struct vfsmount *mnt, char *name,
+		struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -202,7 +203,7 @@ vfs_removexattr(struct dentry *dentry, s
 	if (error)
 		return error;
 
-	error = security_inode_removexattr(dentry, mnt, name);
+	error = security_inode_removexattr(dentry, mnt, name, file);
 	if (error)
 		return error;
 
@@ -222,7 +223,7 @@ EXPORT_SYMBOL_GPL(vfs_removexattr);
  */
 static long
 setxattr(struct dentry *dentry, struct vfsmount *mnt, char __user *name,
-	 void __user *value, size_t size, int flags)
+	 void __user *value, size_t size, int flags, struct file *file)
 {
 	int error;
 	void *kvalue = NULL;
@@ -249,7 +250,7 @@ setxattr(struct dentry *dentry, struct v
 		}
 	}
 
-	error = vfs_setxattr(dentry, mnt, kname, kvalue, size, flags);
+	error = vfs_setxattr(dentry, mnt, kname, kvalue, size, flags, file);
 	kfree(kvalue);
 	return error;
 }
@@ -267,7 +268,8 @@ sys_setxattr(char __user *path, char __u
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		return error;
-	error = setxattr(nd.path.dentry, nd.path.mnt, name, value, size, flags);
+	error = setxattr(nd.path.dentry, nd.path.mnt, name, value, size, flags,
+			 NULL);
 	mnt_drop_write(nd.path.mnt);
 	path_put(&nd.path);
 	return error;
@@ -286,7 +288,8 @@ sys_lsetxattr(char __user *path, char __
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		return error;
-	error = setxattr(nd.path.dentry, nd.path.mnt, name, value, size, flags);
+	error = setxattr(nd.path.dentry, nd.path.mnt, name, value, size, flags,
+			 NULL);
 	mnt_drop_write(nd.path.mnt);
 	path_put(&nd.path);
 	return error;
@@ -308,7 +311,7 @@ sys_fsetxattr(int fd, char __user *name,
 		goto out_fput;
 	dentry = f->f_path.dentry;
 	audit_inode(NULL, dentry);
-	error = setxattr(dentry, f->f_vfsmnt, name, value, size, flags);
+	error = setxattr(dentry, f->f_vfsmnt, name, value, size, flags, f);
 	mnt_drop_write(f->f_vfsmnt);
 out_fput:
 	fput(f);
@@ -320,7 +323,7 @@ out_fput:
  */
 static ssize_t
 getxattr(struct dentry *dentry, struct vfsmount *mnt, char __user *name,
-	 void __user *value, size_t size)
+	 void __user *value, size_t size, struct file *file)
 {
 	ssize_t error;
 	void *kvalue = NULL;
@@ -340,7 +343,7 @@ getxattr(struct dentry *dentry, struct v
 			return -ENOMEM;
 	}
 
-	error = vfs_getxattr(dentry, mnt, kname, kvalue, size);
+	error = vfs_getxattr(dentry, mnt, kname, kvalue, size, file);
 	if (error > 0) {
 		if (size && copy_to_user(value, kvalue, error))
 			error = -EFAULT;
@@ -363,7 +366,7 @@ sys_getxattr(char __user *path, char __u
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = getxattr(nd.path.dentry, nd.path.mnt, name, value, size);
+	error = getxattr(nd.path.dentry, nd.path.mnt, name, value, size, NULL);
 	path_put(&nd.path);
 	return error;
 }
@@ -378,7 +381,7 @@ sys_lgetxattr(char __user *path, char __
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = getxattr(nd.path.dentry, nd.path.mnt, name, value, size);
+	error = getxattr(nd.path.dentry, nd.path.mnt, name, value, size, NULL);
 	path_put(&nd.path);
 	return error;
 }
@@ -393,7 +396,7 @@ sys_fgetxattr(int fd, char __user *name,
 	if (!f)
 		return error;
 	audit_inode(NULL, f->f_path.dentry);
-	error = getxattr(f->f_path.dentry, f->f_path.mnt, name, value, size);
+	error = getxattr(f->f_path.dentry, f->f_path.mnt, name, value, size, f);
 	fput(f);
 	return error;
 }
@@ -403,7 +406,7 @@ sys_fgetxattr(int fd, char __user *name,
  */
 static ssize_t
 listxattr(struct dentry *dentry, struct vfsmount *mnt, char __user *list,
-	  size_t size)
+	  size_t size, struct file *file)
 {
 	ssize_t error;
 	char *klist = NULL;
@@ -416,7 +419,7 @@ listxattr(struct dentry *dentry, struct 
 			return -ENOMEM;
 	}
 
-	error = vfs_listxattr(dentry, mnt, klist, size);
+	error = vfs_listxattr(dentry, mnt, klist, size, file);
 	if (error > 0) {
 		if (size && copy_to_user(list, klist, error))
 			error = -EFAULT;
@@ -438,7 +441,7 @@ sys_listxattr(char __user *path, char __
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = listxattr(nd.path.dentry, nd.path.mnt, list, size);
+	error = listxattr(nd.path.dentry, nd.path.mnt, list, size, NULL);
 	path_put(&nd.path);
 	return error;
 }
@@ -452,7 +455,7 @@ sys_llistxattr(char __user *path, char _
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = listxattr(nd.path.dentry, nd.path.mnt, list, size);
+	error = listxattr(nd.path.dentry, nd.path.mnt, list, size, NULL);
 	path_put(&nd.path);
 	return error;
 }
@@ -467,7 +470,7 @@ sys_flistxattr(int fd, char __user *list
 	if (!f)
 		return error;
 	audit_inode(NULL, f->f_path.dentry);
-	error = listxattr(f->f_path.dentry, f->f_path.mnt, list, size);
+	error = listxattr(f->f_path.dentry, f->f_path.mnt, list, size, f);
 	fput(f);
 	return error;
 }
@@ -476,7 +479,8 @@ sys_flistxattr(int fd, char __user *list
  * Extended attribute REMOVE operations
  */
 static long
-removexattr(struct dentry *dentry, struct vfsmount *mnt, char __user *name)
+removexattr(struct dentry *dentry, struct vfsmount *mnt, char __user *name,
+	    struct file *file)
 {
 	int error;
 	char kname[XATTR_NAME_MAX + 1];
@@ -487,7 +491,7 @@ removexattr(struct dentry *dentry, struc
 	if (error < 0)
 		return error;
 
-	return vfs_removexattr(dentry, mnt, kname);
+	return vfs_removexattr(dentry, mnt, kname, file);
 }
 
 asmlinkage long
@@ -499,7 +503,7 @@ sys_removexattr(char __user *path, char 
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = removexattr(nd.path.dentry, nd.path.mnt, name);
+	error = removexattr(nd.path.dentry, nd.path.mnt, name, NULL);
 	path_put(&nd.path);
 	return error;
 }
@@ -513,7 +517,7 @@ sys_lremovexattr(char __user *path, char
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = removexattr(nd.path.dentry, nd.path.mnt, name);
+	error = removexattr(nd.path.dentry, nd.path.mnt, name, NULL);
 	path_put(&nd.path);
 	return error;
 }
@@ -530,7 +534,7 @@ sys_fremovexattr(int fd, char __user *na
 		return error;
 	dentry = f->f_path.dentry;
 	audit_inode(NULL, dentry);
-	error = removexattr(dentry, f->f_path.mnt, name);
+	error = removexattr(dentry, f->f_path.mnt, name, f);
 	fput(f);
 	return error;
 }
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -57,8 +57,8 @@ extern void cap_capset_set (struct task_
 extern int cap_bprm_set_security (struct linux_binprm *bprm);
 extern void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe);
 extern int cap_bprm_secureexec(struct linux_binprm *bprm);
-extern int cap_inode_setxattr(struct dentry *dentry, struct vfsmount *mnt, char *name, void *value, size_t size, int flags);
-extern int cap_inode_removexattr(struct dentry *dentry, struct vfsmount *mnt, char *name);
+extern int cap_inode_setxattr(struct dentry *dentry, struct vfsmount *mnt, char *name, void *value, size_t size, int flags, struct file *file);
+extern int cap_inode_removexattr(struct dentry *dentry, struct vfsmount *mnt, char *name, struct file *file);
 extern int cap_inode_need_killpriv(struct dentry *dentry);
 extern int cap_inode_killpriv(struct dentry *dentry);
 extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid, int flags);
@@ -1311,16 +1311,18 @@ struct security_operations {
 	int (*inode_getattr) (struct vfsmount *mnt, struct dentry *dentry);
         void (*inode_delete) (struct inode *inode);
 	int (*inode_setxattr) (struct dentry *dentry, struct vfsmount *mnt,
-			       char *name, void *value, size_t size, int flags);
+			       char *name, void *value, size_t size, int flags,
+			       struct file *file);
 	void (*inode_post_setxattr) (struct dentry *dentry,
 				     struct vfsmount *mnt,
 				     char *name, void *value,
 				     size_t size, int flags);
 	int (*inode_getxattr) (struct dentry *dentry, struct vfsmount *mnt,
-			       char *name);
-	int (*inode_listxattr) (struct dentry *dentry, struct vfsmount *mnt);
+			       char *name, struct file *file);
+	int (*inode_listxattr) (struct dentry *dentry, struct vfsmount *mnt,
+				struct file *file);
 	int (*inode_removexattr) (struct dentry *dentry, struct vfsmount *mnt,
-				  char *name);
+				  char *name, struct file *file);
 	int (*inode_need_killpriv) (struct dentry *dentry);
 	int (*inode_killpriv) (struct dentry *dentry);
 	int (*inode_getsecurity)(const struct inode *inode, const char *name, void **buffer, bool alloc);
@@ -1585,15 +1587,17 @@ int security_inode_setattr(struct dentry
 int security_inode_getattr(struct vfsmount *mnt, struct dentry *dentry);
 void security_inode_delete(struct inode *inode);
 int security_inode_setxattr(struct dentry *dentry, struct vfsmount *mnt,
-			    char *name, void *value, size_t size, int flags);
+			    char *name, void *value, size_t size, int flags,
+			    struct file *file);
 void security_inode_post_setxattr(struct dentry *dentry, struct vfsmount *mnt,
 				  char *name, void *value, size_t size,
 				  int flags);
 int security_inode_getxattr(struct dentry *dentry, struct vfsmount *mnt,
-			    char *name);
-int security_inode_listxattr(struct dentry *dentry, struct vfsmount *mnt);
+			    char *name, struct file *file);
+int security_inode_listxattr(struct dentry *dentry, struct vfsmount *mnt,
+			     struct file *file);
 int security_inode_removexattr(struct dentry *dentry, struct vfsmount *mnt,
-			       char *name);
+			       char *name, struct file *file);
 int security_inode_need_killpriv(struct dentry *dentry);
 int security_inode_killpriv(struct dentry *dentry);
 int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc);
@@ -1980,9 +1984,10 @@ static inline void security_inode_delete
 
 static inline int security_inode_setxattr (struct dentry *dentry,
 					   struct vfsmount *mnt, char *name,
-					   void *value, size_t size, int flags)
+					   void *value, size_t size, int flags,
+					   struct file *file)
 {
-	return cap_inode_setxattr(dentry, mnt, name, value, size, flags);
+	return cap_inode_setxattr(dentry, mnt, name, value, size, flags, file);
 }
 
 static inline void security_inode_post_setxattr (struct dentry *dentry,
@@ -1993,21 +1998,24 @@ static inline void security_inode_post_s
 { }
 
 static inline int security_inode_getxattr (struct dentry *dentry,
-					    struct vfsmount *mnt, char *name)
+					   struct vfsmount *mnt, char *name,
+					   struct file *file)
 {
 	return 0;
 }
 
 static inline int security_inode_listxattr (struct dentry *dentry,
-					    struct vfsmount *mnt)
+					   struct vfsmount *mnt,
+					   struct file *file)
 {
 	return 0;
 }
 
 static inline int security_inode_removexattr (struct dentry *dentry,
-					      struct vfsmount *mnt, char *name)
+					     struct vfsmount *mnt, char *name,
+					     struct file *file)
 {
-	return cap_inode_removexattr(dentry, mnt, name);
+	return cap_inode_removexattr(dentry, mnt, name, file);
 }
 
 static inline int security_inode_need_killpriv(struct dentry *dentry)
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -47,11 +47,13 @@ struct xattr_handler {
 };
 
 ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
-ssize_t vfs_getxattr(struct dentry *, struct vfsmount *, char *, void *, size_t);
-ssize_t vfs_listxattr(struct dentry *d, struct vfsmount *, char *list, size_t size);
+ssize_t vfs_getxattr(struct dentry *, struct vfsmount *, char *, void *,
+		     size_t, struct file *);
+ssize_t vfs_listxattr(struct dentry *d, struct vfsmount *, char *list,
+		      size_t size, struct file *);
 int vfs_setxattr(struct dentry *, struct vfsmount *, char *, void *, size_t,
-		 int);
-int vfs_removexattr(struct dentry *, struct vfsmount *, char *);
+		 int, struct file *);
+int vfs_removexattr(struct dentry *, struct vfsmount *, char *, struct file *);
 
 ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);
 ssize_t generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size);
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -380,7 +380,7 @@ int cap_bprm_secureexec (struct linux_bi
 }
 
 int cap_inode_setxattr(struct dentry *dentry, struct vfsmount *mnt, char *name,
-		       void *value, size_t size, int flags)
+		       void *value, size_t size, int flags, struct file *file)
 {
 	if (!strcmp(name, XATTR_NAME_CAPS)) {
 		if (!capable(CAP_SETFCAP))
@@ -394,7 +394,7 @@ int cap_inode_setxattr(struct dentry *de
 }
 
 int cap_inode_removexattr(struct dentry *dentry, struct vfsmount *mnt,
-			  char *name)
+			  char *name, struct file *file)
 {
 	if (!strcmp(name, XATTR_NAME_CAPS)) {
 		if (!capable(CAP_SETFCAP))
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -377,7 +377,7 @@ static void dummy_inode_delete (struct i
 
 static int dummy_inode_setxattr (struct dentry *dentry, struct vfsmount *mnt,
 				 char *name, void *value, size_t size,
-				 int flags)
+				 int flags, struct file *file)
 {
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
@@ -394,18 +394,20 @@ static void dummy_inode_post_setxattr (s
 }
 
 static int dummy_inode_getxattr (struct dentry *dentry,
-			          struct vfsmount *mnt, char *name)
+			          struct vfsmount *mnt, char *name,
+				  struct file *file)
 {
 	return 0;
 }
 
-static int dummy_inode_listxattr (struct dentry *dentry, struct vfsmount *mnt)
+static int dummy_inode_listxattr (struct dentry *dentry, struct vfsmount *mnt,
+				  struct file *file)
 {
 	return 0;
 }
 
 static int dummy_inode_removexattr (struct dentry *dentry, struct vfsmount *mnt,
-				    char *name)
+				    char *name, struct file *file)
 {
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
--- a/security/security.c
+++ b/security/security.c
@@ -461,12 +461,13 @@ void security_inode_delete(struct inode 
 }
 
 int security_inode_setxattr(struct dentry *dentry, struct vfsmount *mnt,
-			     char *name, void *value, size_t size, int flags)
+			    char *name, void *value, size_t size, int flags,
+			    struct file *file)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
 	return security_ops->inode_setxattr(dentry, mnt, name, value, size,
-					    flags);
+					    flags, file);
 }
 
 void security_inode_post_setxattr(struct dentry *dentry, struct vfsmount *mnt,
@@ -475,30 +476,32 @@ void security_inode_post_setxattr(struct
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return;
-	security_ops->inode_post_setxattr(dentry, mnt, name, value, size, flags);
+	security_ops->inode_post_setxattr(dentry, mnt, name, value, size,
+					 flags);
 }
 
 int security_inode_getxattr(struct dentry *dentry, struct vfsmount *mnt,
-			    char *name)
+			    char *name, struct file *file)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_getxattr(dentry, mnt, name);
+	return security_ops->inode_getxattr(dentry, mnt, name, file);
 }
 
-int security_inode_listxattr(struct dentry *dentry, struct vfsmount *mnt)
+int security_inode_listxattr(struct dentry *dentry, struct vfsmount *mnt,
+			     struct file *file)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_listxattr(dentry, mnt);
+	return security_ops->inode_listxattr(dentry, mnt, file);
 }
 
 int security_inode_removexattr(struct dentry *dentry, struct vfsmount *mnt,
-			       char *name)
+			       char *name, struct file *file)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_removexattr(dentry, mnt, name);
+	return security_ops->inode_removexattr(dentry, mnt, name, file);
 }
 
 int security_inode_need_killpriv(struct dentry *dentry)
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2561,7 +2561,7 @@ static int selinux_inode_setotherxattr(s
 
 static int selinux_inode_setxattr(struct dentry *dentry, struct vfsmount *mnt,
 				  char *name, void *value, size_t size,
-				  int flags)
+				  int flags, struct file *file)
 {
 	struct task_security_struct *tsec = current->security;
 	struct inode *inode = dentry->d_inode;
@@ -2637,18 +2637,20 @@ static void selinux_inode_post_setxattr(
 }
 
 static int selinux_inode_getxattr (struct dentry *dentry, struct vfsmount *mnt,
-				   char *name)
+				   char *name, struct file *file)
 {
 	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
 }
 
-static int selinux_inode_listxattr (struct dentry *dentry, struct vfsmount *mnt)
+static int selinux_inode_listxattr (struct dentry *dentry, struct vfsmount *mnt,
+				    struct file *file)
 {
 	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
 }
 
 static int selinux_inode_removexattr (struct dentry *dentry,
-				      struct vfsmount *mnt, char *name)
+				      struct vfsmount *mnt, char *name,
+				      struct file *file)
 {
 	if (strcmp(name, XATTR_NAME_SELINUX))
 		return selinux_inode_setotherxattr(dentry, name);

-- 

