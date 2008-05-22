Return-Path: <linux-kernel-owner+w=401wt.eu-S1757846AbYEVQux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846AbYEVQux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbYEVQu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:50:28 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36755 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382AbYEVQuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:50:14 -0400
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, trond.myklebust@fys.uio.no,
       linux-kernel@vger.kernel.org
Subject: [git patch] vfs: permission API cleanup (v2)
Message-Id: <E1JzDzC-0008MT-Hb@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 22 May 2008 18:49:50 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've committed this series to the vfs-cleanups tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git vfs-cleanups

Changes since yesterday's posting:

   - removed flags passed to ->permission() and path_permission()
   - renamed exec_permission() to check_execute()

Thanks to Al and Trond for the suggestions.

Miklos
---

Miklos Szeredi (12):
      hppfs: remove hppfs_permission
      gfs2: don't call permission()
      hpfs: don't call permission()
      hfsplus: remove hfsplus_permission()
      vfs: pass dentry to permission()
      vfs: don't use nameidata flags in ->permission()
      vfs: cleanup i_op->permission()
      security: don't pass nameidata to security_inode_permission()
      vfs: don't pass nameidata to dentry_permission()
      vfs: move executable checking into ->permission()
      vfs: create path_permission()
      vfs: don't use dentry_permission()

 Documentation/filesystems/Locking |    2 +-
 Documentation/filesystems/vfs.txt |    2 +-
 fs/afs/internal.h                 |    4 +-
 fs/afs/security.c                 |    3 +-
 fs/bad_inode.c                    |    3 +-
 fs/cifs/cifsfs.c                  |    5 +-
 fs/coda/dir.c                     |   10 ++-
 fs/coda/pioctl.c                  |    8 +-
 fs/ecryptfs/inode.c               |   20 +---
 fs/exec.c                         |    4 +-
 fs/ext2/acl.c                     |    4 +-
 fs/ext2/acl.h                     |    2 +-
 fs/ext3/acl.c                     |    4 +-
 fs/ext3/acl.h                     |    2 +-
 fs/ext4/acl.c                     |    4 +-
 fs/ext4/acl.h                     |    2 +-
 fs/fuse/dir.c                     |    8 +-
 fs/gfs2/inode.c                   |    6 +-
 fs/gfs2/inode.h                   |    1 +
 fs/gfs2/ops_file.c                |   11 ++-
 fs/gfs2/ops_inode.c               |   18 +++-
 fs/hfs/inode.c                    |    7 +-
 fs/hfsplus/inode.c                |   13 ---
 fs/hostfs/hostfs_kern.c           |    3 +-
 fs/hpfs/namei.c                   |    2 +-
 fs/hppfs/hppfs.c                  |    7 --
 fs/inotify_user.c                 |    2 +-
 fs/jffs2/acl.c                    |    4 +-
 fs/jffs2/acl.h                    |    2 +-
 fs/jfs/acl.c                      |    4 +-
 fs/jfs/jfs_acl.h                  |    2 +-
 fs/namei.c                        |  203 ++++++++++++++++++++-----------------
 fs/nfs/dir.c                      |   17 ++--
 fs/nfsd/nfsfh.c                   |   11 +-
 fs/nfsd/vfs.c                     |    8 +-
 fs/ocfs2/file.c                   |    3 +-
 fs/ocfs2/file.h                   |    3 +-
 fs/open.c                         |   15 ++--
 fs/proc/base.c                    |    4 +-
 fs/proc/proc_sysctl.c             |   11 ++-
 fs/reiserfs/xattr.c               |    4 +-
 fs/smbfs/file.c                   |   11 +-
 fs/utimes.c                       |    2 +-
 fs/xattr.c                        |   22 +++--
 fs/xfs/linux-2.6/xfs_iops.c       |    7 +-
 include/linux/coda_linux.h        |    2 +-
 include/linux/fs.h                |   16 +++-
 include/linux/namei.h             |    2 -
 include/linux/nfs_fs.h            |    2 +-
 include/linux/reiserfs_xattr.h    |    2 +-
 include/linux/security.h          |    8 +-
 include/linux/shmem_fs.h          |    2 +-
 ipc/mqueue.c                      |   15 ++-
 mm/shmem_acl.c                    |    4 +-
 net/unix/af_unix.c                |    2 +-
 security/dummy.c                  |    2 +-
 security/security.c               |    4 +-
 security/selinux/hooks.c          |    6 +-
 security/smack/smack_lsm.c        |    4 +-
 59 files changed, 296 insertions(+), 265 deletions(-)
---

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 8b22d7d..9801e87 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -44,7 +44,7 @@ ata *);
 	int (*readlink) (struct dentry *, char __user *,int);
 	int (*follow_link) (struct dentry *, struct nameidata *);
 	void (*truncate) (struct inode *);
-	int (*permission) (struct inode *, int, struct nameidata *);
+	int (*permission) (struct dentry *, int);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *, struct dentry *, struct kstat *);
 	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index b7522c6..a597097 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -326,7 +326,7 @@ struct inode_operations {
         void * (*follow_link) (struct dentry *, struct nameidata *);
         void (*put_link) (struct dentry *, struct nameidata *, void *);
 	void (*truncate) (struct inode *);
-	int (*permission) (struct inode *, int, struct nameidata *);
+	int (*permission) (struct dentry *, int);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
 	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 7102824..6aa93b1 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -469,8 +469,6 @@ extern bool afs_cm_incoming_call(struct afs_call *);
 extern const struct inode_operations afs_dir_inode_operations;
 extern const struct file_operations afs_dir_file_operations;
 
-extern int afs_permission(struct inode *, int, struct nameidata *);
-
 /*
  * file.c
  */
@@ -605,7 +603,7 @@ extern void afs_clear_permits(struct afs_vnode *);
 extern void afs_cache_permit(struct afs_vnode *, struct key *, long);
 extern void afs_zap_permits(struct rcu_head *);
 extern struct key *afs_request_key(struct afs_cell *);
-extern int afs_permission(struct inode *, int, struct nameidata *);
+extern int afs_permission(struct dentry *, int);
 
 /*
  * server.c
diff --git a/fs/afs/security.c b/fs/afs/security.c
index 3bcbece..dd53831 100644
--- a/fs/afs/security.c
+++ b/fs/afs/security.c
@@ -284,8 +284,9 @@ static int afs_check_permit(struct afs_vnode *vnode, struct key *key,
  * - AFS ACLs are attached to directories only, and a file is controlled by its
  *   parent directory's ACL
  */
-int afs_permission(struct inode *inode, int mask, struct nameidata *nd)
+int afs_permission(struct dentry *dentry, int mask)
 {
+	struct inode *inode = dentry->d_inode;
 	struct afs_vnode *vnode = AFS_FS_I(inode);
 	afs_access_t uninitialized_var(access);
 	struct key *key;
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index f1c2ea8..d1320bd 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -243,8 +243,7 @@ static int bad_inode_readlink(struct dentry *dentry, char __user *buffer,
 	return -EIO;
 }
 
-static int bad_inode_permission(struct inode *inode, int mask,
-			struct nameidata *nd)
+static int bad_inode_permission(struct dentry *dentry, int mask)
 {
 	return -EIO;
 }
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 427a7c6..bd16cc8 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -268,14 +268,15 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return 0;
 }
 
-static int cifs_permission(struct inode *inode, int mask, struct nameidata *nd)
+static int cifs_permission(struct dentry *dentry, int mask)
 {
+	struct inode *inode = dentry->d_inode;
 	struct cifs_sb_info *cifs_sb;
 
 	cifs_sb = CIFS_SB(inode->i_sb);
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
-		return 0;
+		return check_execute(inode, mask);
 	else /* file mode might have been restricted at mount time
 		on the client (above and beyond ACL on servers) for
 		servers which do not support setting and viewing mode bits,
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 3d2580e..51d1500 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -137,13 +137,19 @@ exit:
 }
 
 
-int coda_permission(struct inode *inode, int mask, struct nameidata *nd)
+int coda_permission(struct dentry *dentry, int mask)
 {
-        int error = 0;
+	struct inode *inode = dentry->d_inode;
+	int error = 0;
  
+	mask &= PERMISSION_MASK;
 	if (!mask)
 		return 0; 
 
+	error = check_execute(inode, mask);
+	if (error)
+		return error;
+
 	lock_kernel();
 
 	if (coda_cache_check(inode, mask))
diff --git a/fs/coda/pioctl.c b/fs/coda/pioctl.c
index c21a1f5..afb7836 100644
--- a/fs/coda/pioctl.c
+++ b/fs/coda/pioctl.c
@@ -24,8 +24,7 @@
 #include <linux/coda_psdev.h>
 
 /* pioctl ops */
-static int coda_ioctl_permission(struct inode *inode, int mask,
-				 struct nameidata *nd);
+static int coda_ioctl_permission(struct dentry *dentry, int mask);
 static int coda_pioctl(struct inode * inode, struct file * filp, 
                        unsigned int cmd, unsigned long user_data);
 
@@ -42,10 +41,9 @@ const struct file_operations coda_ioctl_operations = {
 };
 
 /* the coda pioctl inode ops */
-static int coda_ioctl_permission(struct inode *inode, int mask,
-				 struct nameidata *nd)
+static int coda_ioctl_permission(struct dentry *dentry, int mask)
 {
-        return 0;
+	return check_execute(dentry->d_inode, mask);
 }
 
 static int coda_pioctl(struct inode * inode, struct file * filp, 
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 5b0c334..f4074f7 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -808,22 +808,14 @@ out:
 }
 
 static int
-ecryptfs_permission(struct inode *inode, int mask, struct nameidata *nd)
+ecryptfs_permission(struct dentry *dentry, int mask)
 {
-	int rc;
+	struct path lower_path;
+
+	lower_path.mnt = ecryptfs_dentry_to_lower_mnt(dentry);
+	lower_path.dentry = ecryptfs_dentry_to_lower(dentry);
 
-        if (nd) {
-		struct vfsmount *vfsmnt_save = nd->path.mnt;
-		struct dentry *dentry_save = nd->path.dentry;
-
-		nd->path.mnt = ecryptfs_dentry_to_lower_mnt(nd->path.dentry);
-		nd->path.dentry = ecryptfs_dentry_to_lower(nd->path.dentry);
-		rc = permission(ecryptfs_inode_to_lower(inode), mask, nd);
-		nd->path.mnt = vfsmnt_save;
-		nd->path.dentry = dentry_save;
-        } else
-		rc = permission(ecryptfs_inode_to_lower(inode), mask, NULL);
-        return rc;
+	return path_permission(&lower_path, mask);
 }
 
 /**
diff --git a/fs/exec.c b/fs/exec.c
index b68682a..5924a42 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -116,7 +116,7 @@ asmlinkage long sys_uselib(const char __user * library)
 	if (!S_ISREG(nd.path.dentry->d_inode->i_mode))
 		goto exit;
 
-	error = vfs_permission(&nd, MAY_READ | MAY_EXEC);
+	error = path_permission(&nd.path, MAY_READ | MAY_EXEC);
 	if (error)
 		goto exit;
 
@@ -664,7 +664,7 @@ struct file *open_exec(const char *name)
 		struct inode *inode = nd.path.dentry->d_inode;
 		file = ERR_PTR(-EACCES);
 		if (S_ISREG(inode->i_mode)) {
-			int err = vfs_permission(&nd, MAY_EXEC);
+			int err = path_permission(&nd.path, MAY_EXEC);
 			file = ERR_PTR(err);
 			if (!err) {
 				file = nameidata_to_filp(&nd,
diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
index e58669e..124668a 100644
--- a/fs/ext2/acl.c
+++ b/fs/ext2/acl.c
@@ -294,9 +294,9 @@ ext2_check_acl(struct inode *inode, int mask)
 }
 
 int
-ext2_permission(struct inode *inode, int mask, struct nameidata *nd)
+ext2_permission(struct dentry *dentry, int mask)
 {
-	return generic_permission(inode, mask, ext2_check_acl);
+	return generic_permission(dentry->d_inode, mask, ext2_check_acl);
 }
 
 /*
diff --git a/fs/ext2/acl.h b/fs/ext2/acl.h
index 0bde85b..a8ebf60 100644
--- a/fs/ext2/acl.h
+++ b/fs/ext2/acl.h
@@ -58,7 +58,7 @@ static inline int ext2_acl_count(size_t size)
 #define EXT2_ACL_NOT_CACHED ((void *)-1)
 
 /* acl.c */
-extern int ext2_permission (struct inode *, int, struct nameidata *);
+extern int ext2_permission(struct dentry *, int);
 extern int ext2_acl_chmod (struct inode *);
 extern int ext2_init_acl (struct inode *, struct inode *);
 
diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
index a754d18..f8d1bea 100644
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -299,9 +299,9 @@ ext3_check_acl(struct inode *inode, int mask)
 }
 
 int
-ext3_permission(struct inode *inode, int mask, struct nameidata *nd)
+ext3_permission(struct dentry *dentry, int mask)
 {
-	return generic_permission(inode, mask, ext3_check_acl);
+	return generic_permission(dentry->d_inode, mask, ext3_check_acl);
 }
 
 /*
diff --git a/fs/ext3/acl.h b/fs/ext3/acl.h
index 0d1e627..d6cc255 100644
--- a/fs/ext3/acl.h
+++ b/fs/ext3/acl.h
@@ -58,7 +58,7 @@ static inline int ext3_acl_count(size_t size)
 #define EXT3_ACL_NOT_CACHED ((void *)-1)
 
 /* acl.c */
-extern int ext3_permission (struct inode *, int, struct nameidata *);
+extern int ext3_permission(struct dentry *, int);
 extern int ext3_acl_chmod (struct inode *);
 extern int ext3_init_acl (handle_t *, struct inode *, struct inode *);
 
diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 3c8dab8..097a518 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -299,9 +299,9 @@ ext4_check_acl(struct inode *inode, int mask)
 }
 
 int
-ext4_permission(struct inode *inode, int mask, struct nameidata *nd)
+ext4_permission(struct dentry *dentry, int mask)
 {
-	return generic_permission(inode, mask, ext4_check_acl);
+	return generic_permission(dentry->d_inode, mask, ext4_check_acl);
 }
 
 /*
diff --git a/fs/ext4/acl.h b/fs/ext4/acl.h
index 26a5c1a..f5289af 100644
--- a/fs/ext4/acl.h
+++ b/fs/ext4/acl.h
@@ -58,7 +58,7 @@ static inline int ext4_acl_count(size_t size)
 #define EXT4_ACL_NOT_CACHED ((void *)-1)
 
 /* acl.c */
-extern int ext4_permission (struct inode *, int, struct nameidata *);
+extern int ext4_permission(struct dentry *, int);
 extern int ext4_acl_chmod (struct inode *);
 extern int ext4_init_acl (handle_t *, struct inode *, struct inode *);
 
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 2060bf0..5cf0740 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -886,8 +886,9 @@ static int fuse_access(struct inode *inode, int mask)
  * access request is sent.  Execute permission is still checked
  * locally based on file mode.
  */
-static int fuse_permission(struct inode *inode, int mask, struct nameidata *nd)
+static int fuse_permission(struct dentry *dentry, int mask)
 {
+	struct inode *inode = dentry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	bool refreshed = false;
 	int err = 0;
@@ -921,8 +922,9 @@ static int fuse_permission(struct inode *inode, int mask, struct nameidata *nd)
 		   exist.  So if permissions are revoked this won't be
 		   noticed immediately, only after the attribute
 		   timeout has expired */
-	} else if (nd && (nd->flags & (LOOKUP_ACCESS | LOOKUP_CHDIR))) {
-		err = fuse_access(inode, mask);
+	} else if ((mask & PERM_OP_MASK) == PERM_OP_ACCESS ||
+		   (mask & PERM_OP_MASK) == PERM_OP_CHDIR) {
+		err = fuse_access(inode, mask & PERMISSION_MASK);
 	} else if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode)) {
 		if (!(inode->i_mode & S_IXUGO)) {
 			if (refreshed)
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 3a9ef52..3666c32 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -504,7 +504,7 @@ struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
 	}
 
 	if (!is_root) {
-		error = permission(dir, MAY_EXEC, NULL);
+		error = gfs2_do_permission(dir, MAY_EXEC);
 		if (error)
 			goto out;
 	}
@@ -667,7 +667,7 @@ static int create_ok(struct gfs2_inode *dip, const struct qstr *name,
 {
 	int error;
 
-	error = permission(&dip->i_inode, MAY_WRITE | MAY_EXEC, NULL);
+	error = gfs2_do_permission(&dip->i_inode, MAY_WRITE | MAY_EXEC);
 	if (error)
 		return error;
 
@@ -1134,7 +1134,7 @@ int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
 	if (IS_APPEND(&dip->i_inode))
 		return -EPERM;
 
-	error = permission(&dip->i_inode, MAY_WRITE | MAY_EXEC, NULL);
+	error = gfs2_do_permission(&dip->i_inode, MAY_WRITE | MAY_EXEC);
 	if (error)
 		return error;
 
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 580da45..49c1a3e 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -91,6 +91,7 @@ int gfs2_rmdiri(struct gfs2_inode *dip, const struct qstr *name,
 		struct gfs2_inode *ip);
 int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
 		   const struct gfs2_inode *ip);
+int gfs2_do_permission(struct inode *inode, int mask);
 int gfs2_ok_to_move(struct gfs2_inode *this, struct gfs2_inode *to);
 int gfs2_readlinki(struct gfs2_inode *ip, char **buf, unsigned int *len);
 int gfs2_glock_nq_atime(struct gfs2_holder *gh);
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index e1b7d52..68a3dd7 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -15,6 +15,7 @@
 #include <linux/uio.h>
 #include <linux/blkdev.h>
 #include <linux/mm.h>
+#include <linux/mount.h>
 #include <linux/fs.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/ext2_fs.h>
@@ -220,10 +221,14 @@ static int do_gfs2_set_flags(struct file *filp, u32 reqflags, u32 mask)
 	int error;
 	u32 new_flags, flags;
 
-	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
+	error = mnt_want_write(filp->f_path.mnt);
 	if (error)
 		return error;
 
+	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
+	if (error)
+		goto out_drop_write;
+
 	flags = ip->i_di.di_flags;
 	new_flags = (flags & ~mask) | (reqflags & mask);
 	if ((new_flags ^ flags) == 0)
@@ -242,7 +247,7 @@ static int do_gfs2_set_flags(struct file *filp, u32 reqflags, u32 mask)
 	    !capable(CAP_LINUX_IMMUTABLE))
 		goto out;
 	if (!IS_IMMUTABLE(inode)) {
-		error = permission(inode, MAY_WRITE, NULL);
+		error = gfs2_do_permission(inode, MAY_WRITE);
 		if (error)
 			goto out;
 	}
@@ -272,6 +277,8 @@ out_trans_end:
 	gfs2_trans_end(sdp);
 out:
 	gfs2_glock_dq_uninit(&gh);
+out_drop_write:
+	mnt_drop_write(filp->f_path.mnt);
 	return error;
 }
 
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 2686ad4..a9d6a63 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -163,7 +163,7 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 	if (error)
 		goto out;
 
-	error = permission(dir, MAY_WRITE | MAY_EXEC, NULL);
+	error = gfs2_do_permission(dir, MAY_WRITE | MAY_EXEC);
 	if (error)
 		goto out_gunlock;
 
@@ -669,7 +669,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 			}
 		}
 	} else {
-		error = permission(ndir, MAY_WRITE | MAY_EXEC, NULL);
+		error = gfs2_do_permission(ndir, MAY_WRITE | MAY_EXEC);
 		if (error)
 			goto out_gunlock;
 
@@ -704,7 +704,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	/* Check out the dir to be renamed */
 
 	if (dir_rename) {
-		error = permission(odentry->d_inode, MAY_WRITE, NULL);
+		error = gfs2_do_permission(odentry->d_inode, MAY_WRITE);
 		if (error)
 			goto out_gunlock;
 	}
@@ -891,7 +891,7 @@ static void *gfs2_follow_link(struct dentry *dentry, struct nameidata *nd)
  * Returns: errno
  */
 
-static int gfs2_permission(struct inode *inode, int mask, struct nameidata *nd)
+int gfs2_do_permission(struct inode *inode, int mask)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_holder i_gh;
@@ -905,13 +905,21 @@ static int gfs2_permission(struct inode *inode, int mask, struct nameidata *nd)
 		unlock = 1;
 	}
 
-	error = generic_permission(inode, mask, gfs2_check_acl);
+	if ((mask & MAY_WRITE) && IS_IMMUTABLE(inode))
+		error = -EACCES;
+	else
+		error = generic_permission(inode, mask, gfs2_check_acl);
 	if (unlock)
 		gfs2_glock_dq_uninit(&i_gh);
 
 	return error;
 }
 
+static int gfs2_permission(struct dentry *dentry, int mask)
+{
+	return gfs2_do_permission(dentry->d_inode, mask);
+}
+
 static int setattr_size(struct inode *inode, struct iattr *attr)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 97f8446..c87eeee 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -511,11 +511,12 @@ void hfs_clear_inode(struct inode *inode)
 	}
 }
 
-static int hfs_permission(struct inode *inode, int mask,
-			  struct nameidata *nd)
+static int hfs_permission(struct dentry *dentry, int mask)
 {
+	struct inode *inode = dentry->d_inode;
+
 	if (S_ISREG(inode->i_mode) && mask & MAY_EXEC)
-		return 0;
+		return check_execute(inode, mask);
 	return generic_permission(inode, mask, NULL);
 }
 
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 67e1c8b..369624c 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -238,18 +238,6 @@ static void hfsplus_set_perms(struct inode *inode, struct hfsplus_perm *perms)
 	perms->dev = cpu_to_be32(HFSPLUS_I(inode).dev);
 }
 
-static int hfsplus_permission(struct inode *inode, int mask, struct nameidata *nd)
-{
-	/* MAY_EXEC is also used for lookup, if no x bit is set allow lookup,
-	 * open_exec has the same test, so it's still not executable, if a x bit
-	 * is set fall back to standard permission check.
-	 */
-	if (S_ISREG(inode->i_mode) && mask & MAY_EXEC && !(inode->i_mode & 0111))
-		return 0;
-	return generic_permission(inode, mask, NULL);
-}
-
-
 static int hfsplus_file_open(struct inode *inode, struct file *file)
 {
 	if (HFSPLUS_IS_RSRC(inode))
@@ -283,7 +271,6 @@ static int hfsplus_file_release(struct inode *inode, struct file *file)
 static const struct inode_operations hfsplus_file_inode_operations = {
 	.lookup		= hfsplus_file_lookup,
 	.truncate	= hfsplus_file_truncate,
-	.permission	= hfsplus_permission,
 	.setxattr	= hfsplus_setxattr,
 	.getxattr	= hfsplus_getxattr,
 	.listxattr	= hfsplus_listxattr,
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 5222345..1bf36c1 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -822,8 +822,9 @@ int hostfs_rename(struct inode *from_ino, struct dentry *from,
 	return err;
 }
 
-int hostfs_permission(struct inode *ino, int desired, struct nameidata *nd)
+int hostfs_permission(struct dentry *dentry, int desired)
 {
+	struct inode *ino = dentry->d_inode;
 	char *name;
 	int r = 0, w = 0, x = 0, err;
 
diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
index d5ed786..e1fadd3 100644
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -415,7 +415,7 @@ again:
 		d_drop(dentry);
 		spin_lock(&dentry->d_lock);
 		if (atomic_read(&dentry->d_count) > 1 ||
-		    permission(inode, MAY_WRITE, NULL) ||
+		    generic_permission(inode, MAY_WRITE, NULL) ||
 		    !S_ISREG(inode->i_mode) ||
 		    get_write_access(inode)) {
 			spin_unlock(&dentry->d_lock);
diff --git a/fs/hppfs/hppfs.c b/fs/hppfs/hppfs.c
index 65077aa..2b3d182 100644
--- a/fs/hppfs/hppfs.c
+++ b/fs/hppfs/hppfs.c
@@ -655,20 +655,13 @@ static void *hppfs_follow_link(struct dentry *dentry, struct nameidata *nd)
 	return proc_dentry->d_inode->i_op->follow_link(proc_dentry, nd);
 }
 
-int hppfs_permission(struct inode *inode, int mask, struct nameidata *nd)
-{
-	return generic_permission(inode, mask, NULL);
-}
-
 static const struct inode_operations hppfs_dir_iops = {
 	.lookup		= hppfs_lookup,
-	.permission	= hppfs_permission,
 };
 
 static const struct inode_operations hppfs_link_iops = {
 	.readlink	= hppfs_readlink,
 	.follow_link	= hppfs_follow_link,
-	.permission	= hppfs_permission,
 };
 
 static struct inode *get_inode(struct super_block *sb, struct dentry *dentry)
diff --git a/fs/inotify_user.c b/fs/inotify_user.c
index 6676c06..254c7fb 100644
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -365,7 +365,7 @@ static int find_inode(const char __user *dirname, struct nameidata *nd,
 	if (error)
 		return error;
 	/* you can only watch an inode if you have read permissions on it */
-	error = vfs_permission(nd, MAY_READ);
+	error = path_permission(&nd->path, MAY_READ);
 	if (error)
 		path_put(&nd->path);
 	return error;
diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
index 4c80404..f1ecb8c 100644
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -314,9 +314,9 @@ static int jffs2_check_acl(struct inode *inode, int mask)
 	return -EAGAIN;
 }
 
-int jffs2_permission(struct inode *inode, int mask, struct nameidata *nd)
+int jffs2_permission(struct dentry *dentry, int mask)
 {
-	return generic_permission(inode, mask, jffs2_check_acl);
+	return generic_permission(dentry->d_inode, mask, jffs2_check_acl);
 }
 
 int jffs2_init_acl_pre(struct inode *dir_i, struct inode *inode, int *i_mode)
diff --git a/fs/jffs2/acl.h b/fs/jffs2/acl.h
index 0bb7f00..b5da329 100644
--- a/fs/jffs2/acl.h
+++ b/fs/jffs2/acl.h
@@ -28,7 +28,7 @@ struct jffs2_acl_header {
 
 #define JFFS2_ACL_NOT_CACHED ((void *)-1)
 
-extern int jffs2_permission(struct inode *, int, struct nameidata *);
+extern int jffs2_permission(struct dentry *, int);
 extern int jffs2_acl_chmod(struct inode *);
 extern int jffs2_init_acl_pre(struct inode *, struct inode *, int *);
 extern int jffs2_init_acl_post(struct inode *);
diff --git a/fs/jfs/acl.c b/fs/jfs/acl.c
index 4d84bdc..0b4c3a1 100644
--- a/fs/jfs/acl.c
+++ b/fs/jfs/acl.c
@@ -140,9 +140,9 @@ static int jfs_check_acl(struct inode *inode, int mask)
 	return -EAGAIN;
 }
 
-int jfs_permission(struct inode *inode, int mask, struct nameidata *nd)
+int jfs_permission(struct dentry *dentry, int mask)
 {
-	return generic_permission(inode, mask, jfs_check_acl);
+	return generic_permission(dentry->d_inode, mask, jfs_check_acl);
 }
 
 int jfs_init_acl(tid_t tid, struct inode *inode, struct inode *dir)
diff --git a/fs/jfs/jfs_acl.h b/fs/jfs/jfs_acl.h
index 455fa42..69f4af5 100644
--- a/fs/jfs/jfs_acl.h
+++ b/fs/jfs/jfs_acl.h
@@ -20,7 +20,7 @@
 
 #ifdef CONFIG_JFS_POSIX_ACL
 
-int jfs_permission(struct inode *, int, struct nameidata *);
+int jfs_permission(struct dentry *, int);
 int jfs_init_acl(tid_t, struct inode *, struct inode *);
 int jfs_setattr(struct dentry *, struct iattr *);
 
diff --git a/fs/namei.c b/fs/namei.c
index 1114bc0..83d0f37 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -185,6 +185,7 @@ int generic_permission(struct inode *inode, int mask,
 {
 	umode_t			mode = inode->i_mode;
 
+	mask &= PERMISSION_MASK;
 	if (current->fsuid == inode->i_uid)
 		mode >>= 6;
 	else {
@@ -226,13 +227,30 @@ int generic_permission(struct inode *inode, int mask,
 	return -EACCES;
 }
 
-int permission(struct inode *inode, int mask, struct nameidata *nd)
+/**
+ * check_execute - check for general execute permission on file
+ * @inode:	inode to check access rights for
+ * @mask:	right to check for
+ *
+ * Exec permission on a regular file is denied if none of the execute
+ * bits are set.
+ *
+ * This needs to be called by filesystems which define a
+ * ->permission() method, and don't call generic_permission().
+ */
+int check_execute(struct inode *inode, int mask)
 {
-	int retval, submask;
-	struct vfsmount *mnt = NULL;
+	if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode) &&
+	    !(inode->i_mode & S_IXUGO))
+		return -EACCES;
 
-	if (nd)
-		mnt = nd->path.mnt;
+	return 0;
+}
+
+static int dentry_permission(struct dentry *dentry, int mask)
+{
+	struct inode *inode = dentry->d_inode;
+	int retval, submask;
 
 	if (mask & MAY_WRITE) {
 		umode_t mode = inode->i_mode;
@@ -251,34 +269,13 @@ int permission(struct inode *inode, int mask, struct nameidata *nd)
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
-	if (inode->i_op && inode->i_op->permission) {
-		retval = inode->i_op->permission(inode, submask, nd);
-		if (!retval) {
-			/*
-			 * Exec permission on a regular file is denied if none
-			 * of the execute bits are set.
-			 *
-			 * This check should be done by the ->permission()
-			 * method.
-			 */
-			if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode) &&
-			    !(inode->i_mode & S_IXUGO))
-				return -EACCES;
-		}
-	} else {
+	if (inode->i_op && inode->i_op->permission)
+		retval = inode->i_op->permission(dentry, submask);
+	else
 		retval = generic_permission(inode, submask, NULL);
-	}
+
 	if (retval)
 		return retval;
 
@@ -286,12 +283,12 @@ int permission(struct inode *inode, int mask, struct nameidata *nd)
 	if (retval)
 		return retval;
 
-	return security_inode_permission(inode, mask, nd);
+	return security_inode_permission(inode, mask);
 }
 
 /**
- * vfs_permission  -  check for access rights to a given path
- * @nd:		lookup result that describes the path
+ * path_permission  -  check for access rights to a given path
+ * @path:	lookup result that describes the path
  * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
  *
  * Used to check for read/write/execute permissions on a path.
@@ -299,9 +296,23 @@ int permission(struct inode *inode, int mask, struct nameidata *nd)
  * for filesystem access without changing the "normal" uids which
  * are used for other things.
  */
-int vfs_permission(struct nameidata *nd, int mask)
+int path_permission(struct path *path, int mask)
 {
-	return permission(nd->path.dentry->d_inode, mask, nd);
+	struct dentry *dentry = path->dentry;
+	struct inode *inode = dentry->d_inode;
+
+	if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode)) {
+		struct vfsmount *mnt = path->mnt;
+
+		/*
+		 * MAY_EXEC on regular files is denied if the fs is mounted
+		 * with the "noexec" flag.
+		 */
+		if (mnt->mnt_flags & MNT_NOEXEC)
+			return -EACCES;
+	}
+
+	return dentry_permission(dentry, mask);
 }
 
 /**
@@ -309,16 +320,11 @@ int vfs_permission(struct nameidata *nd, int mask)
  * @file:	file to check access rights for
  * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
  *
- * Used to check for read/write/execute permissions on an already opened
- * file.
- *
- * Note:
- *	Do not use this function in new code.  All access checks should
- *	be done using vfs_permission().
+ * This is a helper for path_permission().
  */
 int file_permission(struct file *file, int mask)
 {
-	return permission(file->f_path.dentry->d_inode, mask, NULL);
+	return path_permission(&file->f_path, mask);
 }
 
 /*
@@ -459,8 +465,7 @@ static struct dentry * cached_lookup(struct dentry * parent, struct qstr * name,
  * short-cut DAC fails, then call permission() to do more
  * complete permission check.
  */
-static int exec_permission_lite(struct inode *inode,
-				       struct nameidata *nd)
+static int exec_permission_lite(struct inode *inode)
 {
 	umode_t	mode = inode->i_mode;
 
@@ -486,7 +491,7 @@ static int exec_permission_lite(struct inode *inode,
 
 	return -EACCES;
 ok:
-	return security_inode_permission(inode, MAY_EXEC, nd);
+	return security_inode_permission(inode, MAY_EXEC);
 }
 
 /*
@@ -891,9 +896,9 @@ static int __link_path_walk(const char *name, struct nameidata *nd)
 		unsigned int c;
 
 		nd->flags |= LOOKUP_CONTINUE;
-		err = exec_permission_lite(inode, nd);
+		err = exec_permission_lite(inode);
 		if (err == -EAGAIN)
-			err = vfs_permission(nd, MAY_EXEC);
+			err = path_permission(&nd->path, MAY_EXEC);
  		if (err)
 			break;
 
@@ -1341,7 +1346,7 @@ static struct dentry *lookup_hash(struct nameidata *nd)
 {
 	int err;
 
-	err = permission(nd->path.dentry->d_inode, MAY_EXEC, nd);
+	err = path_permission(&nd->path, MAY_EXEC);
 	if (err)
 		return ERR_PTR(err);
 	return __lookup_hash(&nd->last, nd->path.dentry, nd);
@@ -1389,7 +1394,7 @@ struct dentry *lookup_one_len(const char *name, struct dentry *base, int len)
 	if (err)
 		return ERR_PTR(err);
 
-	err = permission(base->d_inode, MAY_EXEC, NULL);
+	err = dentry_permission(base, MAY_EXEC);
 	if (err)
 		return ERR_PTR(err);
 	return __lookup_hash(&this, base, NULL);
@@ -1469,8 +1474,10 @@ static inline int check_sticky(struct inode *dir, struct inode *inode)
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
@@ -1479,7 +1486,7 @@ static int may_delete(struct inode *dir,struct dentry *victim,int isdir)
 	BUG_ON(victim->d_parent->d_inode != dir);
 	audit_inode_child(victim->d_name.name, victim, dir);
 
-	error = permission(dir,MAY_WRITE | MAY_EXEC, NULL);
+	error = dentry_permission(dir_dentry, MAY_WRITE | MAY_EXEC);
 	if (error)
 		return error;
 	if (IS_APPEND(dir))
@@ -1509,14 +1516,13 @@ static int may_delete(struct inode *dir,struct dentry *victim,int isdir)
  *  3. We should have write and exec permissions on dir
  *  4. We can't do it if dir is immutable (done in permission())
  */
-static inline int may_create(struct inode *dir, struct dentry *child,
-			     struct nameidata *nd)
+static inline int may_create(struct dentry *dir_dentry, struct dentry *child)
 {
 	if (child->d_inode)
 		return -EEXIST;
-	if (IS_DEADDIR(dir))
+	if (IS_DEADDIR(dir_dentry->d_inode))
 		return -ENOENT;
-	return permission(dir,MAY_WRITE | MAY_EXEC, nd);
+	return dentry_permission(dir_dentry, MAY_WRITE | MAY_EXEC);
 }
 
 /* 
@@ -1579,10 +1585,11 @@ void unlock_rename(struct dentry *p1, struct dentry *p2)
 	}
 }
 
-static int vfs_create(struct inode *dir, struct dentry *dentry, int mode,
-		struct nameidata *nd)
+static int vfs_create(struct dentry *dir_dentry, struct dentry *dentry,
+		      int mode,	struct nameidata *nd)
 {
-	int error = may_create(dir, dentry, nd);
+	struct inode *dir = dir_dentry->d_inode;
+	int error = may_create(dir_dentry, dentry);
 
 	if (error)
 		return error;
@@ -1607,7 +1614,7 @@ int path_create(struct path *dir_path, struct dentry *dentry, int mode,
 	int error = mnt_want_write(dir_path->mnt);
 
 	if (!error) {
-		error = vfs_create(dir_path->dentry->d_inode, dentry, mode, nd);
+		error = vfs_create(dir_path->dentry, dentry, mode, nd);
 		mnt_drop_write(dir_path->mnt);
 	}
 
@@ -1617,6 +1624,7 @@ EXPORT_SYMBOL(path_create);
 
 int may_open(struct nameidata *nd, int acc_mode, int flag)
 {
+	int op;
 	struct dentry *dentry = nd->path.dentry;
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -1644,7 +1652,8 @@ int may_open(struct nameidata *nd, int acc_mode, int flag)
 		flag &= ~O_TRUNC;
 	}
 
-	error = vfs_permission(nd, acc_mode);
+	op = (nd->flags & LOOKUP_OPEN) ? PERM_OP_OPEN : 0;
+	error = path_permission(&nd->path, acc_mode | op);
 	if (error)
 		return error;
 	/*
@@ -1708,7 +1717,7 @@ static int __open_namei_create(struct nameidata *nd, struct path *path,
 
 	if (!IS_POSIXACL(dir->d_inode))
 		mode &= ~current->fs->umask;
-	error = vfs_create(dir->d_inode, path->dentry, mode, nd);
+	error = vfs_create(dir, path->dentry, mode, nd);
 	mutex_unlock(&dir->d_inode->i_mutex);
 	dput(nd->path.dentry);
 	nd->path.dentry = path->dentry;
@@ -2034,9 +2043,11 @@ fail:
 }
 EXPORT_SYMBOL_GPL(lookup_create);
 
-static int vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
+static int vfs_mknod(struct dentry *dir_dentry, struct dentry *dentry,
+		     int mode, dev_t dev)
 {
-	int error = may_create(dir, dentry, NULL);
+	struct inode *dir = dir_dentry->d_inode;
+	int error = may_create(dir_dentry, dentry);
 
 	if (error)
 		return error;
@@ -2068,7 +2079,7 @@ int path_mknod(struct path *dir_path, struct dentry *dentry, int mode,
 	int error = mnt_want_write(dir_path->mnt);
 
 	if (!error) {
-		error = vfs_mknod(dir_path->dentry->d_inode, dentry, mode, dev);
+		error = vfs_mknod(dir_path->dentry, dentry, mode, dev);
 		mnt_drop_write(dir_path->mnt);
 	}
 
@@ -2131,9 +2142,10 @@ asmlinkage long sys_mknod(const char __user *filename, int mode, unsigned dev)
 	return sys_mknodat(AT_FDCWD, filename, mode, dev);
 }
 
-static int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+static int vfs_mkdir(struct dentry *dir_dentry, struct dentry *dentry, int mode)
 {
-	int error = may_create(dir, dentry, NULL);
+	struct inode *dir = dir_dentry->d_inode;
+	int error = may_create(dir_dentry, dentry);
 
 	if (error)
 		return error;
@@ -2158,7 +2170,7 @@ int path_mkdir(struct path *dir_path, struct dentry *dentry, int mode)
 	int error = mnt_want_write(dir_path->mnt);
 
 	if (!error) {
-		error = vfs_mkdir(dir_path->dentry->d_inode, dentry, mode);
+		error = vfs_mkdir(dir_path->dentry, dentry, mode);
 		mnt_drop_write(dir_path->mnt);
 	}
 
@@ -2231,9 +2243,10 @@ void dentry_unhash(struct dentry *dentry)
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
@@ -2269,7 +2282,7 @@ int path_rmdir(struct path *dir_path, struct dentry *dentry)
 	int error = mnt_want_write(dir_path->mnt);
 
 	if (!error) {
-		error = vfs_rmdir(dir_path->dentry->d_inode, dentry);
+		error = vfs_rmdir(dir_path->dentry, dentry);
 		mnt_drop_write(dir_path->mnt);
 	}
 
@@ -2324,9 +2337,10 @@ asmlinkage long sys_rmdir(const char __user *pathname)
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
@@ -2360,7 +2374,7 @@ int path_unlink(struct path *dir_path, struct dentry *dentry)
 	int error = mnt_want_write(dir_path->mnt);
 
 	if (!error) {
-		error = vfs_unlink(dir_path->dentry->d_inode, dentry);
+		error = vfs_unlink(dir_path->dentry, dentry);
 		mnt_drop_write(dir_path->mnt);
 	}
 
@@ -2437,9 +2451,11 @@ asmlinkage long sys_unlink(const char __user *pathname)
 	return do_unlinkat(AT_FDCWD, pathname);
 }
 
-static int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname)
+static int vfs_symlink(struct dentry *dir_dentry, struct dentry *dentry,
+		       const char *oldname)
 {
-	int error = may_create(dir, dentry, NULL);
+	struct inode *dir = dir_dentry->d_inode;
+	int error = may_create(dir_dentry, dentry);
 
 	if (error)
 		return error;
@@ -2464,9 +2480,7 @@ int path_symlink(struct path *dir_path, struct dentry *dentry,
 	int error = mnt_want_write(dir_path->mnt);
 
 	if (!error) {
-		struct inode *dir = dir_path->dentry->d_inode;
-
-		error = vfs_symlink(dir, dentry, oldname);
+		error = vfs_symlink(dir_path->dentry, dentry, oldname);
 		mnt_drop_write(dir_path->mnt);
 	}
 
@@ -2516,15 +2530,17 @@ asmlinkage long sys_symlink(const char __user *oldname, const char __user *newna
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
+	error = may_create(new_dir_dentry, new_dentry);
 	if (error)
 		return error;
 
@@ -2560,9 +2576,7 @@ int path_link(struct dentry *old_dentry, struct path *dir_path,
 	int error = mnt_want_write(dir_path->mnt);
 
 	if (!error) {
-		struct inode *dir = dir_path->dentry->d_inode;
-
-		error = vfs_link(old_dentry, dir, new_dentry);
+		error = vfs_link(old_dentry, dir_path->dentry, new_dentry);
 		mnt_drop_write(dir_path->mnt);
 	}
 
@@ -2672,7 +2686,7 @@ static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
 	 * we'll need to flip '..'.
 	 */
 	if (new_dir != old_dir) {
-		error = permission(old_dentry->d_inode, MAY_WRITE, NULL);
+		error = dentry_permission(old_dentry, MAY_WRITE);
 		if (error)
 			return error;
 	}
@@ -2732,9 +2746,11 @@ static int vfs_rename_other(struct inode *old_dir, struct dentry *old_dentry,
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
@@ -2742,14 +2758,14 @@ static int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (old_dentry->d_inode == new_dentry->d_inode)
  		return 0;
  
-	error = may_delete(old_dir, old_dentry, is_dir);
+	error = may_delete(old_dir_dentry, old_dentry, is_dir);
 	if (error)
 		return error;
 
 	if (!new_dentry->d_inode)
-		error = may_create(new_dir, new_dentry, NULL);
+		error = may_create(new_dir_dentry, new_dentry);
 	else
-		error = may_delete(new_dir, new_dentry, is_dir);
+		error = may_delete(new_dir_dentry, new_dentry, is_dir);
 	if (error)
 		return error;
 
@@ -2785,10 +2801,8 @@ int path_rename(struct path *old_dir_path, struct dentry *old_dentry,
 
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
 
@@ -3041,8 +3055,7 @@ EXPORT_SYMBOL(page_symlink);
 EXPORT_SYMBOL(page_symlink_inode_operations);
 EXPORT_SYMBOL(path_lookup);
 EXPORT_SYMBOL(vfs_path_lookup);
-EXPORT_SYMBOL(permission);
-EXPORT_SYMBOL(vfs_permission);
+EXPORT_SYMBOL(path_permission);
 EXPORT_SYMBOL(file_permission);
 EXPORT_SYMBOL(unlock_rename);
 EXPORT_SYMBOL(vfs_follow_link);
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index f288b3e..060bd4d 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1929,17 +1929,18 @@ int nfs_may_open(struct inode *inode, struct rpc_cred *cred, int openflags)
 	return nfs_do_access(inode, cred, nfs_open_permission_mask(openflags));
 }
 
-int nfs_permission(struct inode *inode, int mask, struct nameidata *nd)
+int nfs_permission(struct dentry *dentry, int mask)
 {
+	struct inode *inode = dentry->d_inode;
 	struct rpc_cred *cred;
 	int res = 0;
 
 	nfs_inc_stats(inode, NFSIOS_VFSACCESS);
 
-	if (mask == 0)
+	if ((mask & PERMISSION_MASK) == 0)
 		goto out;
 	/* Is this sys_access() ? */
-	if (nd != NULL && (nd->flags & LOOKUP_ACCESS))
+	if ((mask & PERM_OP_MASK) == PERM_OP_ACCESS)
 		goto force_lookup;
 
 	switch (inode->i_mode & S_IFMT) {
@@ -1947,9 +1948,8 @@ int nfs_permission(struct inode *inode, int mask, struct nameidata *nd)
 			goto out;
 		case S_IFREG:
 			/* NFSv4 has atomic_open... */
-			if (nfs_server_capable(inode, NFS_CAP_ATOMIC_OPEN)
-					&& nd != NULL
-					&& (nd->flags & LOOKUP_OPEN))
+			if (nfs_server_capable(inode, NFS_CAP_ATOMIC_OPEN) &&
+					(mask & PERM_OP_MASK) == PERM_OP_OPEN)
 				goto out;
 			break;
 		case S_IFDIR:
@@ -1969,12 +1969,15 @@ force_lookup:
 
 	cred = rpc_lookup_cred();
 	if (!IS_ERR(cred)) {
-		res = nfs_do_access(inode, cred, mask);
+		res = nfs_do_access(inode, cred, mask & PERMISSION_MASK);
 		put_rpccred(cred);
 	} else
 		res = PTR_ERR(cred);
 	unlock_kernel();
 out:
+	if (res == 0)
+		res = check_execute(inode, mask);
+
 	dfprintk(VFS, "NFS: permission(%s/%ld), mask=0x%x, res=%d\n",
 		inode->i_sb->s_id, inode->i_ino, mask, res);
 	return res;
diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index 100ae56..f8240ea 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -41,7 +41,7 @@ static int nfsd_acceptable(void *expv, struct dentry *dentry)
 	struct svc_export *exp = expv;
 	int rv;
 	struct dentry *tdentry;
-	struct dentry *parent;
+	struct path parent = { .mnt = exp->ex_path.mnt };
 
 	if (exp->ex_flags & NFSEXP_NOSUBTREECHECK)
 		return 1;
@@ -50,14 +50,15 @@ static int nfsd_acceptable(void *expv, struct dentry *dentry)
 	while (tdentry != exp->ex_path.dentry && !IS_ROOT(tdentry)) {
 		/* make sure parents give x permission to user */
 		int err;
-		parent = dget_parent(tdentry);
-		err = permission(parent->d_inode, MAY_EXEC, NULL);
+
+		parent.dentry = dget_parent(tdentry);
+		err = path_permission(&parent, MAY_EXEC);
 		if (err < 0) {
-			dput(parent);
+			dput(parent.dentry);
 			break;
 		}
 		dput(tdentry);
-		tdentry = parent;
+		tdentry = parent.dentry;
 	}
 	if (tdentry != exp->ex_path.dentry)
 		dprintk("nfsd_acceptable failed at %p %s\n", tdentry, tdentry->d_name.name);
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index d361354..ccda8ce 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1878,6 +1878,10 @@ nfsd_permission(struct svc_rqst *rqstp, struct svc_export *exp,
 {
 	struct inode	*inode = dentry->d_inode;
 	int		err;
+	struct path	path = {
+		.mnt = exp->ex_path.mnt,
+		.dentry = dentry,
+	};
 
 	if (acc == MAY_NOP)
 		return 0;
@@ -1942,12 +1946,12 @@ nfsd_permission(struct svc_rqst *rqstp, struct svc_export *exp,
 	    inode->i_uid == current->fsuid)
 		return 0;
 
-	err = permission(inode, acc & (MAY_READ|MAY_WRITE|MAY_EXEC), NULL);
+	err = path_permission(&path, acc & (MAY_READ|MAY_WRITE|MAY_EXEC));
 
 	/* Allow read access to binaries even when mode 111 */
 	if (err == -EACCES && S_ISREG(inode->i_mode) &&
 	    acc == (MAY_READ | MAY_OWNER_OVERRIDE))
-		err = permission(inode, MAY_EXEC, NULL);
+		err = path_permission(&path, MAY_EXEC);
 
 	return err? nfserrno(err) : 0;
 }
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 57e0d30..0a53a18 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1176,8 +1176,9 @@ bail:
 	return err;
 }
 
-int ocfs2_permission(struct inode *inode, int mask, struct nameidata *nd)
+int ocfs2_permission(struct dentry *dentry, int mask)
 {
+	struct inode *inode = dentry->d_inode;
 	int ret;
 
 	mlog_entry_void();
diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
index 048ddca..ef74fa7 100644
--- a/fs/ocfs2/file.h
+++ b/fs/ocfs2/file.h
@@ -62,8 +62,7 @@ int ocfs2_lock_allocators(struct inode *inode, struct ocfs2_dinode *di,
 int ocfs2_setattr(struct dentry *dentry, struct iattr *attr);
 int ocfs2_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		  struct kstat *stat);
-int ocfs2_permission(struct inode *inode, int mask,
-		     struct nameidata *nd);
+int ocfs2_permission(struct dentry *dentry, int mask);
 
 int ocfs2_should_update_atime(struct inode *inode,
 			      struct vfsmount *vfsmnt);
diff --git a/fs/open.c b/fs/open.c
index ceb18bc..6f9cbcc 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -267,7 +267,7 @@ static long do_sys_truncate(const char __user * path, loff_t length)
 	if (error)
 		goto dput_and_out;
 
-	error = vfs_permission(&nd, MAY_WRITE);
+	error = path_permission(&nd.path, MAY_WRITE);
 	if (error)
 		goto mnt_drop_write_and_out;
 
@@ -467,11 +467,11 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 	else
 		current->cap_effective = current->cap_permitted;
 
-	res = __user_walk_fd(dfd, filename, LOOKUP_FOLLOW|LOOKUP_ACCESS, &nd);
+	res = __user_walk_fd(dfd, filename, LOOKUP_FOLLOW, &nd);
 	if (res)
 		goto out;
 
-	res = vfs_permission(&nd, mode);
+	res = path_permission(&nd.path, mode | PERM_OP_ACCESS);
 	/* SuS v2 requires we report a read only fs too */
 	if(res || !(mode & S_IWOTH) ||
 	   special_file(nd.path.dentry->d_inode->i_mode))
@@ -509,12 +509,11 @@ asmlinkage long sys_chdir(const char __user * filename)
 	struct nameidata nd;
 	int error;
 
-	error = __user_walk(filename,
-			    LOOKUP_FOLLOW|LOOKUP_DIRECTORY|LOOKUP_CHDIR, &nd);
+	error = __user_walk(filename, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &nd);
 	if (error)
 		goto out;
 
-	error = vfs_permission(&nd, MAY_EXEC);
+	error = path_permission(&nd.path, MAY_EXEC | PERM_OP_CHDIR);
 	if (error)
 		goto dput_and_out;
 
@@ -543,7 +542,7 @@ asmlinkage long sys_fchdir(unsigned int fd)
 	if (!S_ISDIR(inode->i_mode))
 		goto out_putf;
 
-	error = file_permission(file, MAY_EXEC);
+	error = file_permission(file, MAY_EXEC | PERM_OP_CHDIR);
 	if (!error)
 		set_fs_pwd(current->fs, &file->f_path);
 out_putf:
@@ -561,7 +560,7 @@ asmlinkage long sys_chroot(const char __user * filename)
 	if (error)
 		goto out;
 
-	error = vfs_permission(&nd, MAY_EXEC);
+	error = path_permission(&nd.path, MAY_EXEC);
 	if (error)
 		goto dput_and_out;
 
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 808cbdc..2d74dbb 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1814,9 +1814,9 @@ static const struct file_operations proc_fd_operations = {
  * /proc/pid/fd needs a special permission handler so that a process can still
  * access /proc/self/fd after it has executed a setuid().
  */
-static int proc_fd_permission(struct inode *inode, int mask,
-				struct nameidata *nd)
+static int proc_fd_permission(struct dentry *dentry, int mask)
 {
+	struct inode *inode = dentry->d_inode;
 	int rv;
 
 	rv = generic_permission(inode, mask, NULL);
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 5acc001..f72fae4 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -343,7 +343,7 @@ out:
 	return ret;
 }
 
-static int proc_sys_permission(struct inode *inode, int mask, struct nameidata *nd)
+static int proc_sys_permission(struct dentry *dentry, int mask)
 {
 	/*
 	 * sysctl entries that are not writeable,
@@ -351,7 +351,7 @@ static int proc_sys_permission(struct inode *inode, int mask, struct nameidata *
 	 */
 	struct ctl_table_header *head;
 	struct ctl_table *table;
-	struct dentry *dentry;
+	struct inode *inode = dentry->d_inode;
 	int mode;
 	int depth;
 	int error;
@@ -359,6 +359,7 @@ static int proc_sys_permission(struct inode *inode, int mask, struct nameidata *
 	head = NULL;
 	depth = PROC_I(inode)->fd;
 
+	mask &= PERMISSION_MASK;
 	/* First check the cached permissions, in case we don't have
 	 * enough information to lookup the sysctl table entry.
 	 */
@@ -376,10 +377,9 @@ static int proc_sys_permission(struct inode *inode, int mask, struct nameidata *
 	/* If we can't get a sysctl table entry the permission
 	 * checks on the cached mode will have to be enough.
 	 */
-	if (!nd || !depth)
+	if (!depth)
 		goto out;
 
-	dentry = nd->path.dentry;
 	table = do_proc_sys_lookup(dentry->d_parent, &dentry->d_name, &head);
 
 	/* If the entry does not exist deny permission */
@@ -391,6 +391,9 @@ static int proc_sys_permission(struct inode *inode, int mask, struct nameidata *
 	error = sysctl_perm(head->root, table, mask);
 out:
 	sysctl_head_finish(head);
+	if (!error)
+		error = check_execute(inode, mask);
+
 	return error;
 }
 
diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 4125468..6d710e3 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -1270,8 +1270,10 @@ static int reiserfs_check_acl(struct inode *inode, int mask)
 	return error;
 }
 
-int reiserfs_permission(struct inode *inode, int mask, struct nameidata *nd)
+int reiserfs_permission(struct dentry *dentry, int mask)
 {
+	struct inode *inode = dentry->d_inode;
+
 	/*
 	 * We don't do permission checks on the internal objects.
 	 * Permissions are determined by the "owning" object.
diff --git a/fs/smbfs/file.c b/fs/smbfs/file.c
index efbe29a..7000dc2 100644
--- a/fs/smbfs/file.c
+++ b/fs/smbfs/file.c
@@ -408,18 +408,19 @@ smb_file_release(struct inode *inode, struct file * file)
  * privileges, so we need our own check for this.
  */
 static int
-smb_file_permission(struct inode *inode, int mask, struct nameidata *nd)
+smb_file_permission(struct dentry *dentry, int mask)
 {
-	int mode = inode->i_mode;
-	int error = 0;
+	int mode = dentry->d_inode->i_mode;
 
 	VERBOSE("mode=%x, mask=%x\n", mode, mask);
 
 	/* Look at user permissions */
+	mask &= PERMISSION_MASK;
 	mode >>= 6;
 	if ((mode & 7 & mask) != mask)
-		error = -EACCES;
-	return error;
+		return -EACCES;
+
+	return check_execute(dentry->d_inode, mask);
 }
 
 const struct file_operations smb_file_operations =
diff --git a/fs/utimes.c b/fs/utimes.c
index 2390e3a..3b85b0b 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -141,7 +141,7 @@ static int do_utimes_name(int dfd, char __user *filename,
 			goto out_path_put;
 
 		if (!is_owner_or_cap(inode)) {
-			error = vfs_permission(&nd, MAY_WRITE);
+			error = path_permission(&nd.path, MAY_WRITE);
 			if (error)
 				goto out_path_put;
 		}
diff --git a/fs/xattr.c b/fs/xattr.c
index 7eb9cd9..b403da3 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -26,8 +26,10 @@
  * because different namespaces have very different rules.
  */
 static int
-xattr_permission(struct inode *inode, const char *name, int mask)
+xattr_permission(struct path *path, const char *name, int mask)
 {
+	struct inode *inode = path->dentry->d_inode;
+
 	/*
 	 * We can never set or remove an extended attribute on a read-only
 	 * filesystem  or on an immutable / append-only inode.
@@ -63,17 +65,18 @@ xattr_permission(struct inode *inode, const char *name, int mask)
 			return -EPERM;
 	}
 
-	return permission(inode, mask, NULL);
+	return path_permission(path, mask);
 }
 
 static int
-vfs_setxattr(struct dentry *dentry, const char *name, const void *value,
+vfs_setxattr(struct path *path, const char *name, const void *value,
 		size_t size, int flags)
 {
+	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
 	int error;
 
-	error = xattr_permission(inode, name, MAY_WRITE);
+	error = xattr_permission(path, name, MAY_WRITE);
 	if (error)
 		return error;
 
@@ -108,7 +111,7 @@ int path_setxattr(struct path *path, const char *name, const void *value,
 	int error = mnt_want_write(path->mnt);
 
 	if (!error) {
-		error = vfs_setxattr(path->dentry, name, value, size, flags);
+		error = vfs_setxattr(path, name, value, size, flags);
 		mnt_drop_write(path->mnt);
 	}
 
@@ -150,7 +153,7 @@ path_getxattr(struct path *path, const char *name, void *value, size_t size)
 	struct inode *inode = dentry->d_inode;
 	int error;
 
-	error = xattr_permission(inode, name, MAY_READ);
+	error = xattr_permission(path, name, MAY_READ);
 	if (error)
 		return error;
 
@@ -202,15 +205,16 @@ path_listxattr(struct path *path, char *list, size_t size)
 EXPORT_SYMBOL_GPL(path_listxattr);
 
 static int
-vfs_removexattr(struct dentry *dentry, const char *name)
+vfs_removexattr(struct path *path, const char *name)
 {
+	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
 	int error;
 
 	if (!inode->i_op->removexattr)
 		return -EOPNOTSUPP;
 
-	error = xattr_permission(inode, name, MAY_WRITE);
+	error = xattr_permission(path, name, MAY_WRITE);
 	if (error)
 		return error;
 
@@ -232,7 +236,7 @@ int path_removexattr(struct path *path, const char *name)
 	int error = mnt_want_write(path->mnt);
 
 	if (!error) {
-		error = vfs_removexattr(path->dentry, name);
+		error = vfs_removexattr(path, name);
 		mnt_drop_write(path->mnt);
 	}
 
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 2bf287e..5b31e4a 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -588,11 +588,10 @@ xfs_check_acl(
 
 STATIC int
 xfs_vn_permission(
-	struct inode		*inode,
-	int			mask,
-	struct nameidata	*nd)
+	struct dentry		*dentry,
+	int			mask)
 {
-	return generic_permission(inode, mask, xfs_check_acl);
+	return generic_permission(dentry->d_inode, mask, xfs_check_acl);
 }
 #else
 #define xfs_vn_permission NULL
diff --git a/include/linux/coda_linux.h b/include/linux/coda_linux.h
index 31b7531..663559c 100644
--- a/include/linux/coda_linux.h
+++ b/include/linux/coda_linux.h
@@ -37,7 +37,7 @@ extern const struct file_operations coda_ioctl_operations;
 /* operations shared over more than one file */
 int coda_open(struct inode *i, struct file *f);
 int coda_release(struct inode *i, struct file *f);
-int coda_permission(struct inode *inode, int mask, struct nameidata *nd);
+int coda_permission(struct dentry *dentry, int mask);
 int coda_revalidate_inode(struct dentry *);
 int coda_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 int coda_setattr(struct dentry *, struct iattr *);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f7f273b..fb26e0f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -60,6 +60,16 @@ extern int dir_notify_enable;
 #define MAY_WRITE 2
 #define MAY_READ 4
 #define MAY_APPEND 8
+#define PERMISSION_MASK (MAY_EXEC | MAY_WRITE | MAY_READ | MAY_APPEND)
+
+/*
+ * Special "MAY_" flags for i_op->permission(), indicating the filesystem
+ * operation for which we are performing the permission check.
+ */
+#define PERM_OP_MASK	(0xf << 28)
+#define PERM_OP_OPEN	(0x1 << 28)
+#define PERM_OP_ACCESS	(0x2 << 28)
+#define PERM_OP_CHDIR	(0x3 << 28)
 
 #define FMODE_READ 1
 #define FMODE_WRITE 2
@@ -1123,7 +1133,7 @@ extern void unlock_super(struct super_block *);
 /*
  * VFS helper functions..
  */
-extern int vfs_permission(struct nameidata *, int);
+extern int path_permission(struct path *, int);
 extern int path_create(struct path *, struct dentry *, int, struct nameidata *);
 extern int path_mkdir(struct path *, struct dentry *, int);
 extern int path_mknod(struct path *, struct dentry *, int, dev_t);
@@ -1264,7 +1274,7 @@ struct inode_operations {
 	void * (*follow_link) (struct dentry *, struct nameidata *);
 	void (*put_link) (struct dentry *, struct nameidata *, void *);
 	void (*truncate) (struct inode *);
-	int (*permission) (struct inode *, int, struct nameidata *);
+	int (*permission) (struct dentry *, int);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
 	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
@@ -1758,9 +1768,9 @@ extern sector_t bmap(struct inode *, sector_t);
 #endif
 extern int notify_change(struct dentry *, struct iattr *);
 extern int path_setattr(struct path *, struct iattr *);
-extern int permission(struct inode *, int, struct nameidata *);
 extern int generic_permission(struct inode *, int,
 		int (*check_acl)(struct inode *, int));
+extern int check_execute(struct inode *, int);
 
 extern int get_write_access(struct inode *);
 extern int deny_write_access(struct file *);
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 24d88e9..75e8270 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -54,8 +54,6 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
  */
 #define LOOKUP_OPEN		(0x0100)
 #define LOOKUP_CREATE		(0x0200)
-#define LOOKUP_ACCESS		(0x0400)
-#define LOOKUP_CHDIR		(0x0800)
 
 extern int __user_walk(const char __user *, unsigned, struct nameidata *);
 extern int __user_walk_fd(int dfd, const char __user *, unsigned, struct nameidata *);
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 27d6a8d..07ef8a8 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -322,7 +322,7 @@ extern int nfs_refresh_inode(struct inode *, struct nfs_fattr *);
 extern int nfs_post_op_update_inode(struct inode *inode, struct nfs_fattr *fattr);
 extern int nfs_post_op_update_inode_force_wcc(struct inode *inode, struct nfs_fattr *fattr);
 extern int nfs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
-extern int nfs_permission(struct inode *, int, struct nameidata *);
+extern int nfs_permission(struct dentry *, int);
 extern int nfs_open(struct inode *, struct file *);
 extern int nfs_release(struct inode *, struct file *);
 extern int nfs_attribute_timeout(struct inode *inode);
diff --git a/include/linux/reiserfs_xattr.h b/include/linux/reiserfs_xattr.h
index 66a9681..91f9dbb 100644
--- a/include/linux/reiserfs_xattr.h
+++ b/include/linux/reiserfs_xattr.h
@@ -55,7 +55,7 @@ int reiserfs_removexattr(struct dentry *dentry, const char *name);
 int reiserfs_delete_xattrs(struct inode *inode);
 int reiserfs_chown_xattrs(struct inode *inode, struct iattr *attrs);
 int reiserfs_xattr_init(struct super_block *sb, int mount_flags);
-int reiserfs_permission(struct inode *inode, int mask, struct nameidata *nd);
+int reiserfs_permission(struct dentry *dentry, int mask);
 
 int reiserfs_xattr_del(struct inode *, const char *);
 int reiserfs_xattr_get(const struct inode *, const char *, void *, size_t);
diff --git a/include/linux/security.h b/include/linux/security.h
index 50737c7..030b137 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -407,7 +407,6 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	called when the actual read/write operations are performed.
  *	@inode contains the inode structure to check.
  *	@mask contains the permission mask.
- *	@nd contains the nameidata (may be NULL).
  *	Return 0 if permission is granted.
  * @inode_setattr:
  *	Check permission before setting file attributes.  Note that the kernel
@@ -1370,7 +1369,7 @@ struct security_operations {
 			     struct inode *new_dir, struct dentry *new_dentry);
 	int (*inode_readlink) (struct dentry *dentry);
 	int (*inode_follow_link) (struct dentry *dentry, struct nameidata *nd);
-	int (*inode_permission) (struct inode *inode, int mask, struct nameidata *nd);
+	int (*inode_permission) (struct inode *inode, int mask);
 	int (*inode_setattr)	(struct dentry *dentry, struct iattr *attr);
 	int (*inode_getattr) (struct vfsmount *mnt, struct dentry *dentry);
 	void (*inode_delete) (struct inode *inode);
@@ -1641,7 +1640,7 @@ int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
 			  struct inode *new_dir, struct dentry *new_dentry);
 int security_inode_readlink(struct dentry *dentry);
 int security_inode_follow_link(struct dentry *dentry, struct nameidata *nd);
-int security_inode_permission(struct inode *inode, int mask, struct nameidata *nd);
+int security_inode_permission(struct inode *inode, int mask);
 int security_inode_setattr(struct dentry *dentry, struct iattr *attr);
 int security_inode_getattr(struct vfsmount *mnt, struct dentry *dentry);
 void security_inode_delete(struct inode *inode);
@@ -2032,8 +2031,7 @@ static inline int security_inode_follow_link(struct dentry *dentry,
 	return 0;
 }
 
-static inline int security_inode_permission(struct inode *inode, int mask,
-					     struct nameidata *nd)
+static inline int security_inode_permission(struct inode *inode, int mask)
 {
 	return 0;
 }
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index f2d12d5..be2ae57 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -43,7 +43,7 @@ static inline struct shmem_inode_info *SHMEM_I(struct inode *inode)
 }
 
 #ifdef CONFIG_TMPFS_POSIX_ACL
-int shmem_permission(struct inode *, int, struct nameidata *);
+int shmem_permission(struct dentry *, int);
 int shmem_acl_init(struct inode *, struct inode *);
 void shmem_acl_destroy_inode(struct inode *);
 
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index c229691..265a27d 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -647,19 +647,22 @@ static struct file *do_open(struct dentry *dentry, int oflag)
 static int oflag2acc[O_ACCMODE] = { MAY_READ, MAY_WRITE,
 					MAY_READ | MAY_WRITE };
 
+	struct path path = {
+		.mnt = mqueue_mnt,
+		.dentry = dentry,
+	};
+
 	if ((oflag & O_ACCMODE) == (O_RDWR | O_WRONLY)) {
-		dput(dentry);
-		mntput(mqueue_mnt);
+		path_put(&path);
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (permission(dentry->d_inode, oflag2acc[oflag & O_ACCMODE], NULL)) {
-		dput(dentry);
-		mntput(mqueue_mnt);
+	if (path_permission(&path, oflag2acc[oflag & O_ACCMODE])) {
+		path_put(&path);
 		return ERR_PTR(-EACCES);
 	}
 
-	return dentry_open(dentry, mqueue_mnt, oflag);
+	return dentry_open(path.dentry, path.mnt, oflag);
 }
 
 asmlinkage long sys_mq_open(const char __user *u_name, int oflag, mode_t mode,
diff --git a/mm/shmem_acl.c b/mm/shmem_acl.c
index f5664c5..042f244 100644
--- a/mm/shmem_acl.c
+++ b/mm/shmem_acl.c
@@ -191,7 +191,7 @@ shmem_check_acl(struct inode *inode, int mask)
  * shmem_permission  -  permission() inode operation
  */
 int
-shmem_permission(struct inode *inode, int mask, struct nameidata *nd)
+shmem_permission(struct dentry *dentry, int mask)
 {
-	return generic_permission(inode, mask, shmem_check_acl);
+	return generic_permission(dentry->d_inode, mask, shmem_check_acl);
 }
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index abd4614..5401cb8 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -713,7 +713,7 @@ static struct sock *unix_find_other(struct net *net,
 		err = path_lookup(sunname->sun_path, LOOKUP_FOLLOW, &nd);
 		if (err)
 			goto fail;
-		err = vfs_permission(&nd, MAY_WRITE);
+		err = path_permission(&nd.path, MAY_WRITE);
 		if (err)
 			goto put_fail;
 
diff --git a/security/dummy.c b/security/dummy.c
index f50c6c3..e5ad811 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -345,7 +345,7 @@ static int dummy_inode_follow_link (struct dentry *dentry,
 	return 0;
 }
 
-static int dummy_inode_permission (struct inode *inode, int mask, struct nameidata *nd)
+static int dummy_inode_permission (struct inode *inode, int mask)
 {
 	return 0;
 }
diff --git a/security/security.c b/security/security.c
index 01f0acd..5fd5249 100644
--- a/security/security.c
+++ b/security/security.c
@@ -463,11 +463,11 @@ int security_inode_follow_link(struct dentry *dentry, struct nameidata *nd)
 	return security_ops->inode_follow_link(dentry, nd);
 }
 
-int security_inode_permission(struct inode *inode, int mask, struct nameidata *nd)
+int security_inode_permission(struct inode *inode, int mask)
 {
 	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
-	return security_ops->inode_permission(inode, mask, nd);
+	return security_ops->inode_permission(inode, mask);
 }
 
 int security_inode_setattr(struct dentry *dentry, struct iattr *attr)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 1c864c0..491bf88 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2579,15 +2579,15 @@ static int selinux_inode_follow_link(struct dentry *dentry, struct nameidata *na
 	return dentry_has_perm(current, NULL, dentry, FILE__READ);
 }
 
-static int selinux_inode_permission(struct inode *inode, int mask,
-				    struct nameidata *nd)
+static int selinux_inode_permission(struct inode *inode, int mask)
 {
 	int rc;
 
-	rc = secondary_ops->inode_permission(inode, mask, nd);
+	rc = secondary_ops->inode_permission(inode, mask);
 	if (rc)
 		return rc;
 
+	mask &= PERMISSION_MASK;
 	if (!mask) {
 		/* No permission to check.  Existence test. */
 		return 0;
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index b5c8f92..cee792f 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -515,14 +515,12 @@ static int smack_inode_rename(struct inode *old_inode,
  * smack_inode_permission - Smack version of permission()
  * @inode: the inode in question
  * @mask: the access requested
- * @nd: unused
  *
  * This is the important Smack hook.
  *
  * Returns 0 if access is permitted, -EACCES otherwise
  */
-static int smack_inode_permission(struct inode *inode, int mask,
-				  struct nameidata *nd)
+static int smack_inode_permission(struct inode *inode, int mask)
 {
 	/*
 	 * No permission to check. Existence test. Yup, it's there.
