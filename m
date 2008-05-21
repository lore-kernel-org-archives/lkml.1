Return-Path: <linux-kernel-owner+w=401wt.eu-S936391AbYEURUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936391AbYEURUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935874AbYEURQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:16:14 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33074 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935553AbYEURQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:16:06 -0400
Message-Id: <20080521171552.347470100@szeredi.hu>
References: <20080521171458.077908538@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 21 May 2008 19:15:06 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 08/14] vfs: cleanup i_op->permission()
Content-Disposition: inline; filename=iop_permission_pass_dentry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Signature of i_op->permission() is changed from
	int (*permission) (struct inode *inode, int mask, struct nameidata *nd);
to
	int (*permission) (struct dentry *dentry, int mask, int flags);

Lots of filesystems need to be updated, but the only ones actually
making use of the dentry (instead of the inode) or flags are:

 - ecryptfs: uses both dentry and flags
 - fuse: checks LOOKUP_ACCESS and LOOKUP_CHDIR in flags
 - nfs: checks LOOKUP_ACCESS and LOOKUP_OPEN in flags
 - proc_sys_permission: uses the dentry

The new code should be equivalent to the old.

The only exception is that proc_sys_permission() will always have the
dentry available, based on which it can look up the sysctl table
entry, and use that to check permissions.  This should in theory make
the permission checking more consistent, although hopefully it won't
have any visible effect.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 Documentation/filesystems/Locking |    2 +-
 Documentation/filesystems/vfs.txt |    2 +-
 fs/afs/internal.h                 |    4 +---
 fs/afs/security.c                 |    3 ++-
 fs/bad_inode.c                    |    3 +--
 fs/cifs/cifsfs.c                  |    3 ++-
 fs/coda/dir.c                     |    5 +++--
 fs/coda/pioctl.c                  |    6 ++----
 fs/ecryptfs/inode.c               |   26 ++++----------------------
 fs/ext2/acl.c                     |    4 ++--
 fs/ext2/acl.h                     |    2 +-
 fs/ext3/acl.c                     |    4 ++--
 fs/ext3/acl.h                     |    2 +-
 fs/ext4/acl.c                     |    4 ++--
 fs/ext4/acl.h                     |    2 +-
 fs/fuse/dir.c                     |    5 +++--
 fs/gfs2/ops_inode.c               |    4 ++--
 fs/hfs/inode.c                    |    5 +++--
 fs/hostfs/hostfs_kern.c           |    3 ++-
 fs/jffs2/acl.c                    |    4 ++--
 fs/jffs2/acl.h                    |    2 +-
 fs/jfs/acl.c                      |    4 ++--
 fs/jfs/jfs_acl.h                  |    2 +-
 fs/namei.c                        |    3 ++-
 fs/nfs/dir.c                      |    8 ++++----
 fs/ocfs2/file.c                   |    3 ++-
 fs/ocfs2/file.h                   |    3 +--
 fs/proc/base.c                    |    4 ++--
 fs/proc/proc_sysctl.c             |    7 +++----
 fs/reiserfs/xattr.c               |    4 +++-
 fs/smbfs/file.c                   |    4 ++--
 fs/xfs/linux-2.6/xfs_iops.c       |    6 +++---
 include/linux/coda_linux.h        |    2 +-
 include/linux/fs.h                |    2 +-
 include/linux/nfs_fs.h            |    2 +-
 include/linux/reiserfs_xattr.h    |    2 +-
 include/linux/shmem_fs.h          |    2 +-
 mm/shmem_acl.c                    |    4 ++--
 38 files changed, 71 insertions(+), 86 deletions(-)

Index: linux-2.6/fs/afs/security.c
===================================================================
--- linux-2.6.orig/fs/afs/security.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/afs/security.c	2008-05-21 16:38:28.000000000 +0200
@@ -284,8 +284,9 @@ static int afs_check_permit(struct afs_v
  * - AFS ACLs are attached to directories only, and a file is controlled by its
  *   parent directory's ACL
  */
-int afs_permission(struct inode *inode, int mask, struct nameidata *nd)
+int afs_permission(struct dentry *dentry, int mask, int flags)
 {
+	struct inode *inode = dentry->d_inode;
 	struct afs_vnode *vnode = AFS_FS_I(inode);
 	afs_access_t uninitialized_var(access);
 	struct key *key;
Index: linux-2.6/fs/bad_inode.c
===================================================================
--- linux-2.6.orig/fs/bad_inode.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/bad_inode.c	2008-05-21 16:38:28.000000000 +0200
@@ -243,8 +243,7 @@ static int bad_inode_readlink(struct den
 	return -EIO;
 }
 
-static int bad_inode_permission(struct inode *inode, int mask,
-			struct nameidata *nd)
+static int bad_inode_permission(struct dentry *dentry, int mask, int flags)
 {
 	return -EIO;
 }
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-05-21 16:36:07.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-05-21 16:38:28.000000000 +0200
@@ -1264,7 +1264,7 @@ struct inode_operations {
 	void * (*follow_link) (struct dentry *, struct nameidata *);
 	void (*put_link) (struct dentry *, struct nameidata *, void *);
 	void (*truncate) (struct inode *);
-	int (*permission) (struct inode *, int, struct nameidata *);
+	int (*permission) (struct dentry *, int, int);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
 	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
Index: linux-2.6/fs/cifs/cifsfs.c
===================================================================
--- linux-2.6.orig/fs/cifs/cifsfs.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/cifs/cifsfs.c	2008-05-21 16:38:28.000000000 +0200
@@ -268,8 +268,9 @@ cifs_statfs(struct dentry *dentry, struc
 	return 0;
 }
 
-static int cifs_permission(struct inode *inode, int mask, struct nameidata *nd)
+static int cifs_permission(struct dentry *dentry, int mask, int flags)
 {
+	struct inode *inode = dentry->d_inode;
 	struct cifs_sb_info *cifs_sb;
 
 	cifs_sb = CIFS_SB(inode->i_sb);
Index: linux-2.6/fs/coda/dir.c
===================================================================
--- linux-2.6.orig/fs/coda/dir.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/coda/dir.c	2008-05-21 16:38:28.000000000 +0200
@@ -137,9 +137,10 @@ exit:
 }
 
 
-int coda_permission(struct inode *inode, int mask, struct nameidata *nd)
+int coda_permission(struct dentry *dentry, int mask, int flags)
 {
-        int error = 0;
+	struct inode *inode = dentry->d_inode;
+	int error = 0;
  
 	if (!mask)
 		return 0; 
Index: linux-2.6/fs/coda/pioctl.c
===================================================================
--- linux-2.6.orig/fs/coda/pioctl.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/coda/pioctl.c	2008-05-21 16:38:28.000000000 +0200
@@ -24,8 +24,7 @@
 #include <linux/coda_psdev.h>
 
 /* pioctl ops */
-static int coda_ioctl_permission(struct inode *inode, int mask,
-				 struct nameidata *nd);
+static int coda_ioctl_permission(struct dentry *dentry, int mask, int flags);
 static int coda_pioctl(struct inode * inode, struct file * filp, 
                        unsigned int cmd, unsigned long user_data);
 
@@ -42,8 +41,7 @@ const struct file_operations coda_ioctl_
 };
 
 /* the coda pioctl inode ops */
-static int coda_ioctl_permission(struct inode *inode, int mask,
-				 struct nameidata *nd)
+static int coda_ioctl_permission(struct dentry *dentry, int mask, int flags)
 {
         return 0;
 }
Index: linux-2.6/fs/ecryptfs/inode.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/inode.c	2008-05-21 16:36:42.000000000 +0200
+++ linux-2.6/fs/ecryptfs/inode.c	2008-05-21 16:38:28.000000000 +0200
@@ -808,30 +808,12 @@ out:
 }
 
 static int
-ecryptfs_permission(struct inode *inode, int mask, struct nameidata *nd)
+ecryptfs_permission(struct dentry *dentry, int mask, int flags)
 {
-	int rc;
+	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
+	struct nameidata nd = { .flags = flags };
 
-        if (nd) {
-		struct vfsmount *vfsmnt_save = nd->path.mnt;
-		struct dentry *dentry_save = nd->path.dentry;
-
-		nd->path.mnt = ecryptfs_dentry_to_lower_mnt(nd->path.dentry);
-		nd->path.dentry = ecryptfs_dentry_to_lower(nd->path.dentry);
-		rc = dentry_permission(nd->path.dentry, mask, nd);
-		nd->path.mnt = vfsmnt_save;
-		nd->path.dentry = dentry_save;
-	} else {
-		struct dentry *dentry = d_find_alias(inode);
-		struct dentry *lower_dentry;
-
-		rc = -ENOENT;
-		if (dentry) {
-			lower_dentry = ecryptfs_dentry_to_lower(dentry);
-			rc = dentry_permission(lower_dentry, mask, NULL);
-		}
-	}
-        return rc;
+	return dentry_permission(lower_dentry, mask, &nd);
 }
 
 /**
Index: linux-2.6/fs/ext2/acl.c
===================================================================
--- linux-2.6.orig/fs/ext2/acl.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/ext2/acl.c	2008-05-21 16:38:28.000000000 +0200
@@ -294,9 +294,9 @@ ext2_check_acl(struct inode *inode, int 
 }
 
 int
-ext2_permission(struct inode *inode, int mask, struct nameidata *nd)
+ext2_permission(struct dentry *dentry, int mask, int flags)
 {
-	return generic_permission(inode, mask, ext2_check_acl);
+	return generic_permission(dentry->d_inode, mask, ext2_check_acl);
 }
 
 /*
Index: linux-2.6/fs/ext3/acl.c
===================================================================
--- linux-2.6.orig/fs/ext3/acl.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/ext3/acl.c	2008-05-21 16:38:28.000000000 +0200
@@ -299,9 +299,9 @@ ext3_check_acl(struct inode *inode, int 
 }
 
 int
-ext3_permission(struct inode *inode, int mask, struct nameidata *nd)
+ext3_permission(struct dentry *dentry, int mask, int flags)
 {
-	return generic_permission(inode, mask, ext3_check_acl);
+	return generic_permission(dentry->d_inode, mask, ext3_check_acl);
 }
 
 /*
Index: linux-2.6/fs/ext4/acl.c
===================================================================
--- linux-2.6.orig/fs/ext4/acl.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/ext4/acl.c	2008-05-21 16:38:28.000000000 +0200
@@ -299,9 +299,9 @@ ext4_check_acl(struct inode *inode, int 
 }
 
 int
-ext4_permission(struct inode *inode, int mask, struct nameidata *nd)
+ext4_permission(struct dentry *dentry, int mask, int flags)
 {
-	return generic_permission(inode, mask, ext4_check_acl);
+	return generic_permission(dentry->d_inode, mask, ext4_check_acl);
 }
 
 /*
Index: linux-2.6/fs/fuse/dir.c
===================================================================
--- linux-2.6.orig/fs/fuse/dir.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/fuse/dir.c	2008-05-21 16:38:28.000000000 +0200
@@ -886,8 +886,9 @@ static int fuse_access(struct inode *ino
  * access request is sent.  Execute permission is still checked
  * locally based on file mode.
  */
-static int fuse_permission(struct inode *inode, int mask, struct nameidata *nd)
+static int fuse_permission(struct dentry *dentry, int mask, int flags)
 {
+	struct inode *inode = dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	bool refreshed = false;
 	int err = 0;
@@ -921,7 +922,7 @@ static int fuse_permission(struct inode 
 		   exist.  So if permissions are revoked this won't be
 		   noticed immediately, only after the attribute
 		   timeout has expired */
-	} else if (nd && (nd->flags & (LOOKUP_ACCESS | LOOKUP_CHDIR))) {
+	} else if (flags & (LOOKUP_ACCESS | LOOKUP_CHDIR)) {
 		err = fuse_access(inode, mask);
 	} else if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode)) {
 		if (!(inode->i_mode & S_IXUGO)) {
Index: linux-2.6/fs/gfs2/ops_inode.c
===================================================================
--- linux-2.6.orig/fs/gfs2/ops_inode.c	2008-05-21 16:01:35.000000000 +0200
+++ linux-2.6/fs/gfs2/ops_inode.c	2008-05-21 16:38:28.000000000 +0200
@@ -915,9 +915,9 @@ int gfs2_do_permission(struct inode *ino
 	return error;
 }
 
-static int gfs2_permission(struct inode *inode, int mask, struct nameidata *nd)
+static int gfs2_permission(struct dentry *dentry, int mask, int flags)
 {
-	return gfs2_do_permission(inode, mask);
+	return gfs2_do_permission(dentry->d_inode, mask);
 }
 
 static int setattr_size(struct inode *inode, struct iattr *attr)
Index: linux-2.6/fs/hfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hfs/inode.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/hfs/inode.c	2008-05-21 16:38:28.000000000 +0200
@@ -511,9 +511,10 @@ void hfs_clear_inode(struct inode *inode
 	}
 }
 
-static int hfs_permission(struct inode *inode, int mask,
-			  struct nameidata *nd)
+static int hfs_permission(struct dentry *dentry, int mask, int flags)
 {
+	struct inode *inode = dentry->d_inode;
+
 	if (S_ISREG(inode->i_mode) && mask & MAY_EXEC)
 		return 0;
 	return generic_permission(inode, mask, NULL);
Index: linux-2.6/fs/hostfs/hostfs_kern.c
===================================================================
--- linux-2.6.orig/fs/hostfs/hostfs_kern.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/hostfs/hostfs_kern.c	2008-05-21 16:38:28.000000000 +0200
@@ -822,8 +822,9 @@ int hostfs_rename(struct inode *from_ino
 	return err;
 }
 
-int hostfs_permission(struct inode *ino, int desired, struct nameidata *nd)
+int hostfs_permission(struct dentry *dentry, int desired, int flags)
 {
+	struct inode *ino = dentry->d_inode;
 	char *name;
 	int r = 0, w = 0, x = 0, err;
 
Index: linux-2.6/fs/jffs2/acl.c
===================================================================
--- linux-2.6.orig/fs/jffs2/acl.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/jffs2/acl.c	2008-05-21 16:38:28.000000000 +0200
@@ -314,9 +314,9 @@ static int jffs2_check_acl(struct inode 
 	return -EAGAIN;
 }
 
-int jffs2_permission(struct inode *inode, int mask, struct nameidata *nd)
+int jffs2_permission(struct dentry *dentry, int mask, int flags)
 {
-	return generic_permission(inode, mask, jffs2_check_acl);
+	return generic_permission(dentry->d_inode, mask, jffs2_check_acl);
 }
 
 int jffs2_init_acl_pre(struct inode *dir_i, struct inode *inode, int *i_mode)
Index: linux-2.6/fs/jfs/acl.c
===================================================================
--- linux-2.6.orig/fs/jfs/acl.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/jfs/acl.c	2008-05-21 16:38:28.000000000 +0200
@@ -140,9 +140,9 @@ static int jfs_check_acl(struct inode *i
 	return -EAGAIN;
 }
 
-int jfs_permission(struct inode *inode, int mask, struct nameidata *nd)
+int jfs_permission(struct dentry *dentry, int mask, int flags)
 {
-	return generic_permission(inode, mask, jfs_check_acl);
+	return generic_permission(dentry->d_inode, mask, jfs_check_acl);
 }
 
 int jfs_init_acl(tid_t tid, struct inode *inode, struct inode *dir)
Index: linux-2.6/fs/nfs/dir.c
===================================================================
--- linux-2.6.orig/fs/nfs/dir.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/nfs/dir.c	2008-05-21 16:38:28.000000000 +0200
@@ -1929,8 +1929,9 @@ int nfs_may_open(struct inode *inode, st
 	return nfs_do_access(inode, cred, nfs_open_permission_mask(openflags));
 }
 
-int nfs_permission(struct inode *inode, int mask, struct nameidata *nd)
+int nfs_permission(struct dentry *dentry, int mask, int flags)
 {
+	struct inode *inode = dentry->d_inode;
 	struct rpc_cred *cred;
 	int res = 0;
 
@@ -1939,7 +1940,7 @@ int nfs_permission(struct inode *inode, 
 	if (mask == 0)
 		goto out;
 	/* Is this sys_access() ? */
-	if (nd != NULL && (nd->flags & LOOKUP_ACCESS))
+	if (flags & LOOKUP_ACCESS)
 		goto force_lookup;
 
 	switch (inode->i_mode & S_IFMT) {
@@ -1948,8 +1949,7 @@ int nfs_permission(struct inode *inode, 
 		case S_IFREG:
 			/* NFSv4 has atomic_open... */
 			if (nfs_server_capable(inode, NFS_CAP_ATOMIC_OPEN)
-					&& nd != NULL
-					&& (nd->flags & LOOKUP_OPEN))
+					&& (flags & LOOKUP_OPEN))
 				goto out;
 			break;
 		case S_IFDIR:
Index: linux-2.6/include/linux/nfs_fs.h
===================================================================
--- linux-2.6.orig/include/linux/nfs_fs.h	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/include/linux/nfs_fs.h	2008-05-21 16:38:28.000000000 +0200
@@ -322,7 +322,7 @@ extern int nfs_refresh_inode(struct inod
 extern int nfs_post_op_update_inode(struct inode *inode, struct nfs_fattr *fattr);
 extern int nfs_post_op_update_inode_force_wcc(struct inode *inode, struct nfs_fattr *fattr);
 extern int nfs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
-extern int nfs_permission(struct inode *, int, struct nameidata *);
+extern int nfs_permission(struct dentry *, int, int);
 extern int nfs_open(struct inode *, struct file *);
 extern int nfs_release(struct inode *, struct file *);
 extern int nfs_attribute_timeout(struct inode *inode);
Index: linux-2.6/fs/ocfs2/file.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/file.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/ocfs2/file.c	2008-05-21 16:38:28.000000000 +0200
@@ -1176,8 +1176,9 @@ bail:
 	return err;
 }
 
-int ocfs2_permission(struct inode *inode, int mask, struct nameidata *nd)
+int ocfs2_permission(struct dentry *dentry, int mask, int flags)
 {
+	struct inode *inode = dentry->d_inode;
 	int ret;
 
 	mlog_entry_void();
Index: linux-2.6/fs/ocfs2/file.h
===================================================================
--- linux-2.6.orig/fs/ocfs2/file.h	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/ocfs2/file.h	2008-05-21 16:38:28.000000000 +0200
@@ -62,8 +62,7 @@ int ocfs2_lock_allocators(struct inode *
 int ocfs2_setattr(struct dentry *dentry, struct iattr *attr);
 int ocfs2_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		  struct kstat *stat);
-int ocfs2_permission(struct inode *inode, int mask,
-		     struct nameidata *nd);
+int ocfs2_permission(struct dentry *dentry, int mask, int flags);
 
 int ocfs2_should_update_atime(struct inode *inode,
 			      struct vfsmount *vfsmnt);
Index: linux-2.6/fs/proc/base.c
===================================================================
--- linux-2.6.orig/fs/proc/base.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/proc/base.c	2008-05-21 16:38:28.000000000 +0200
@@ -1814,9 +1814,9 @@ static const struct file_operations proc
  * /proc/pid/fd needs a special permission handler so that a process can still
  * access /proc/self/fd after it has executed a setuid().
  */
-static int proc_fd_permission(struct inode *inode, int mask,
-				struct nameidata *nd)
+static int proc_fd_permission(struct dentry *dentry, int mask, int flags)
 {
+	struct inode *inode = dentry->d_inode;
 	int rv;
 
 	rv = generic_permission(inode, mask, NULL);
Index: linux-2.6/fs/proc/proc_sysctl.c
===================================================================
--- linux-2.6.orig/fs/proc/proc_sysctl.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/proc/proc_sysctl.c	2008-05-21 16:38:28.000000000 +0200
@@ -343,7 +343,7 @@ out:
 	return ret;
 }
 
-static int proc_sys_permission(struct inode *inode, int mask, struct nameidata *nd)
+static int proc_sys_permission(struct dentry *dentry, int mask, int flags)
 {
 	/*
 	 * sysctl entries that are not writeable,
@@ -351,7 +351,7 @@ static int proc_sys_permission(struct in
 	 */
 	struct ctl_table_header *head;
 	struct ctl_table *table;
-	struct dentry *dentry;
+	struct inode *inode = dentry->d_inode;
 	int mode;
 	int depth;
 	int error;
@@ -376,10 +376,9 @@ static int proc_sys_permission(struct in
 	/* If we can't get a sysctl table entry the permission
 	 * checks on the cached mode will have to be enough.
 	 */
-	if (!nd || !depth)
+	if (!depth)
 		goto out;
 
-	dentry = nd->path.dentry;
 	table = do_proc_sys_lookup(dentry->d_parent, &dentry->d_name, &head);
 
 	/* If the entry does not exist deny permission */
Index: linux-2.6/fs/reiserfs/xattr.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/xattr.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/reiserfs/xattr.c	2008-05-21 16:38:28.000000000 +0200
@@ -1270,8 +1270,10 @@ static int reiserfs_check_acl(struct ino
 	return error;
 }
 
-int reiserfs_permission(struct inode *inode, int mask, struct nameidata *nd)
+int reiserfs_permission(struct dentry *dentry, int mask, int flags)
 {
+	struct inode *inode = dentry->d_inode;
+
 	/*
 	 * We don't do permission checks on the internal objects.
 	 * Permissions are determined by the "owning" object.
Index: linux-2.6/include/linux/reiserfs_xattr.h
===================================================================
--- linux-2.6.orig/include/linux/reiserfs_xattr.h	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/include/linux/reiserfs_xattr.h	2008-05-21 16:38:28.000000000 +0200
@@ -55,7 +55,7 @@ int reiserfs_removexattr(struct dentry *
 int reiserfs_delete_xattrs(struct inode *inode);
 int reiserfs_chown_xattrs(struct inode *inode, struct iattr *attrs);
 int reiserfs_xattr_init(struct super_block *sb, int mount_flags);
-int reiserfs_permission(struct inode *inode, int mask, struct nameidata *nd);
+int reiserfs_permission(struct dentry *dentry, int mask, int flags);
 
 int reiserfs_xattr_del(struct inode *, const char *);
 int reiserfs_xattr_get(const struct inode *, const char *, void *, size_t);
Index: linux-2.6/fs/smbfs/file.c
===================================================================
--- linux-2.6.orig/fs/smbfs/file.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/smbfs/file.c	2008-05-21 16:38:28.000000000 +0200
@@ -408,9 +408,9 @@ smb_file_release(struct inode *inode, st
  * privileges, so we need our own check for this.
  */
 static int
-smb_file_permission(struct inode *inode, int mask, struct nameidata *nd)
+smb_file_permission(struct dentry *dentry, int mask, int flags)
 {
-	int mode = inode->i_mode;
+	int mode = dentry->d_inode->i_mode;
 	int error = 0;
 
 	VERBOSE("mode=%x, mask=%x\n", mode, mask);
Index: linux-2.6/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_iops.c	2008-05-21 16:38:28.000000000 +0200
@@ -588,11 +588,11 @@ xfs_check_acl(
 
 STATIC int
 xfs_vn_permission(
-	struct inode		*inode,
+	struct dentry		*dentry,
 	int			mask,
-	struct nameidata	*nd)
+	int			flags)
 {
-	return generic_permission(inode, mask, xfs_check_acl);
+	return generic_permission(dentry->d_inode, mask, xfs_check_acl);
 }
 #else
 #define xfs_vn_permission NULL
Index: linux-2.6/include/linux/shmem_fs.h
===================================================================
--- linux-2.6.orig/include/linux/shmem_fs.h	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/include/linux/shmem_fs.h	2008-05-21 16:38:28.000000000 +0200
@@ -43,7 +43,7 @@ static inline struct shmem_inode_info *S
 }
 
 #ifdef CONFIG_TMPFS_POSIX_ACL
-int shmem_permission(struct inode *, int, struct nameidata *);
+int shmem_permission(struct dentry *, int, int);
 int shmem_acl_init(struct inode *, struct inode *);
 void shmem_acl_destroy_inode(struct inode *);
 
Index: linux-2.6/mm/shmem_acl.c
===================================================================
--- linux-2.6.orig/mm/shmem_acl.c	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/mm/shmem_acl.c	2008-05-21 16:38:28.000000000 +0200
@@ -191,7 +191,7 @@ shmem_check_acl(struct inode *inode, int
  * shmem_permission  -  permission() inode operation
  */
 int
-shmem_permission(struct inode *inode, int mask, struct nameidata *nd)
+shmem_permission(struct dentry *dentry, int mask, int flags)
 {
-	return generic_permission(inode, mask, shmem_check_acl);
+	return generic_permission(dentry->d_inode, mask, shmem_check_acl);
 }
Index: linux-2.6/fs/afs/internal.h
===================================================================
--- linux-2.6.orig/fs/afs/internal.h	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/afs/internal.h	2008-05-21 16:38:28.000000000 +0200
@@ -469,8 +469,6 @@ extern bool afs_cm_incoming_call(struct 
 extern const struct inode_operations afs_dir_inode_operations;
 extern const struct file_operations afs_dir_file_operations;
 
-extern int afs_permission(struct inode *, int, struct nameidata *);
-
 /*
  * file.c
  */
@@ -605,7 +603,7 @@ extern void afs_clear_permits(struct afs
 extern void afs_cache_permit(struct afs_vnode *, struct key *, long);
 extern void afs_zap_permits(struct rcu_head *);
 extern struct key *afs_request_key(struct afs_cell *);
-extern int afs_permission(struct inode *, int, struct nameidata *);
+extern int afs_permission(struct dentry *, int, int);
 
 /*
  * server.c
Index: linux-2.6/include/linux/coda_linux.h
===================================================================
--- linux-2.6.orig/include/linux/coda_linux.h	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/include/linux/coda_linux.h	2008-05-21 16:38:28.000000000 +0200
@@ -37,7 +37,7 @@ extern const struct file_operations coda
 /* operations shared over more than one file */
 int coda_open(struct inode *i, struct file *f);
 int coda_release(struct inode *i, struct file *f);
-int coda_permission(struct inode *inode, int mask, struct nameidata *nd);
+int coda_permission(struct dentry *dentry, int mask, int flags);
 int coda_revalidate_inode(struct dentry *);
 int coda_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 int coda_setattr(struct dentry *, struct iattr *);
Index: linux-2.6/fs/ext2/acl.h
===================================================================
--- linux-2.6.orig/fs/ext2/acl.h	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/ext2/acl.h	2008-05-21 16:38:28.000000000 +0200
@@ -58,7 +58,7 @@ static inline int ext2_acl_count(size_t 
 #define EXT2_ACL_NOT_CACHED ((void *)-1)
 
 /* acl.c */
-extern int ext2_permission (struct inode *, int, struct nameidata *);
+extern int ext2_permission(struct dentry *, int, int);
 extern int ext2_acl_chmod (struct inode *);
 extern int ext2_init_acl (struct inode *, struct inode *);
 
Index: linux-2.6/fs/ext3/acl.h
===================================================================
--- linux-2.6.orig/fs/ext3/acl.h	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/ext3/acl.h	2008-05-21 16:38:28.000000000 +0200
@@ -58,7 +58,7 @@ static inline int ext3_acl_count(size_t 
 #define EXT3_ACL_NOT_CACHED ((void *)-1)
 
 /* acl.c */
-extern int ext3_permission (struct inode *, int, struct nameidata *);
+extern int ext3_permission(struct dentry *, int, int);
 extern int ext3_acl_chmod (struct inode *);
 extern int ext3_init_acl (handle_t *, struct inode *, struct inode *);
 
Index: linux-2.6/fs/ext4/acl.h
===================================================================
--- linux-2.6.orig/fs/ext4/acl.h	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/ext4/acl.h	2008-05-21 16:38:28.000000000 +0200
@@ -58,7 +58,7 @@ static inline int ext4_acl_count(size_t 
 #define EXT4_ACL_NOT_CACHED ((void *)-1)
 
 /* acl.c */
-extern int ext4_permission (struct inode *, int, struct nameidata *);
+extern int ext4_permission(struct dentry *, int, int);
 extern int ext4_acl_chmod (struct inode *);
 extern int ext4_init_acl (handle_t *, struct inode *, struct inode *);
 
Index: linux-2.6/fs/jffs2/acl.h
===================================================================
--- linux-2.6.orig/fs/jffs2/acl.h	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/jffs2/acl.h	2008-05-21 16:38:28.000000000 +0200
@@ -28,7 +28,7 @@ struct jffs2_acl_header {
 
 #define JFFS2_ACL_NOT_CACHED ((void *)-1)
 
-extern int jffs2_permission(struct inode *, int, struct nameidata *);
+extern int jffs2_permission(struct dentry *, int, int);
 extern int jffs2_acl_chmod(struct inode *);
 extern int jffs2_init_acl_pre(struct inode *, struct inode *, int *);
 extern int jffs2_init_acl_post(struct inode *);
Index: linux-2.6/fs/jfs/jfs_acl.h
===================================================================
--- linux-2.6.orig/fs/jfs/jfs_acl.h	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/fs/jfs/jfs_acl.h	2008-05-21 16:38:28.000000000 +0200
@@ -20,7 +20,7 @@
 
 #ifdef CONFIG_JFS_POSIX_ACL
 
-int jfs_permission(struct inode *, int, struct nameidata *);
+int jfs_permission(struct dentry *, int, int);
 int jfs_init_acl(tid_t, struct inode *, struct inode *);
 int jfs_setattr(struct dentry *, struct iattr *);
 
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-21 16:36:07.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-21 16:38:28.000000000 +0200
@@ -264,7 +264,8 @@ int dentry_permission(struct dentry *den
 	/* Ordinary permission routines do not understand MAY_APPEND. */
 	submask = mask & ~MAY_APPEND;
 	if (inode->i_op && inode->i_op->permission) {
-		retval = inode->i_op->permission(inode, submask, nd);
+		retval = inode->i_op->permission(dentry, submask,
+						 nd ? nd->flags : 0);
 		if (!retval) {
 			/*
 			 * Exec permission on a regular file is denied if none
Index: linux-2.6/Documentation/filesystems/Locking
===================================================================
--- linux-2.6.orig/Documentation/filesystems/Locking	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/Documentation/filesystems/Locking	2008-05-21 16:38:28.000000000 +0200
@@ -44,7 +44,7 @@ ata *);
 	int (*readlink) (struct dentry *, char __user *,int);
 	int (*follow_link) (struct dentry *, struct nameidata *);
 	void (*truncate) (struct inode *);
-	int (*permission) (struct inode *, int, struct nameidata *);
+	int (*permission) (struct dentry *, int, int);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *, struct dentry *, struct kstat *);
 	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
Index: linux-2.6/Documentation/filesystems/vfs.txt
===================================================================
--- linux-2.6.orig/Documentation/filesystems/vfs.txt	2008-05-21 15:45:10.000000000 +0200
+++ linux-2.6/Documentation/filesystems/vfs.txt	2008-05-21 16:38:28.000000000 +0200
@@ -326,7 +326,7 @@ struct inode_operations {
         void * (*follow_link) (struct dentry *, struct nameidata *);
         void (*put_link) (struct dentry *, struct nameidata *, void *);
 	void (*truncate) (struct inode *);
-	int (*permission) (struct inode *, int, struct nameidata *);
+	int (*permission) (struct dentry *, int, int);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
 	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);

--
