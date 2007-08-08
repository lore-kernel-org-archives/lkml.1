Return-Path: <linux-kernel-owner+w=401wt.eu-S965092AbXHHRUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965092AbXHHRUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936293AbXHHRTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:19:08 -0400
Received: from ns2.suse.de ([195.135.220.15]:37158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934019AbXHHRTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:19:03 -0400
Message-Id: <20070808171643.797533942@suse.de>
References: <20070808171622.632749741@suse.de>
User-Agent: quilt/0.46-1
Date: Wed, 08 Aug 2007 19:16:25 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: linux-kernel@vger.kernel.org
Cc: John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [RFC 03/10] Pass no unnecessary information to iop->permission
Content-Disposition: inline; filename=permission-args.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The various permission functions and the permission inode operation do
not need a full nameidata. Pass a struct vfs_lookup instead.

Signed-off-by: Andreas Gruenbacher <ag@bestbits.at>

---
 fs/afs/internal.h              |    4 +---
 fs/afs/security.c              |    2 +-
 fs/bad_inode.c                 |    2 +-
 fs/cifs/cifsfs.c               |    3 ++-
 fs/coda/dir.c                  |    2 +-
 fs/coda/pioctl.c               |    4 ++--
 fs/ecryptfs/inode.c            |   20 ++++++++++----------
 fs/exec.c                      |    4 ++--
 fs/ext2/acl.c                  |    2 +-
 fs/ext2/acl.h                  |    2 +-
 fs/ext3/acl.c                  |    2 +-
 fs/ext3/acl.h                  |    2 +-
 fs/ext4/acl.c                  |    2 +-
 fs/ext4/acl.h                  |    2 +-
 fs/fuse/dir.c                  |    4 ++--
 fs/gfs2/ops_inode.c            |    4 ++--
 fs/hfs/inode.c                 |    2 +-
 fs/hfsplus/inode.c             |    2 +-
 fs/inotify_user.c              |    2 +-
 fs/jffs2/acl.c                 |    2 +-
 fs/jffs2/acl.h                 |    2 +-
 fs/jfs/acl.c                   |    2 +-
 fs/jfs/jfs_acl.h               |    2 +-
 fs/namei.c                     |   34 +++++++++++++++++-----------------
 fs/nfs/dir.c                   |    8 ++++----
 fs/ocfs2/file.c                |    2 +-
 fs/ocfs2/file.h                |    3 +--
 fs/open.c                      |    8 ++++----
 fs/proc/base.c                 |    2 +-
 fs/proc/proc_sysctl.c          |    7 ++++---
 fs/reiserfs/xattr.c            |    3 ++-
 fs/smbfs/file.c                |    2 +-
 fs/utimes.c                    |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c    |    2 +-
 include/linux/coda_linux.h     |    2 +-
 include/linux/fs.h             |    6 +++---
 include/linux/nfs_fs.h         |    2 +-
 include/linux/reiserfs_xattr.h |    4 ++--
 include/linux/security.h       |   10 +++++-----
 include/linux/shmem_fs.h       |    2 +-
 mm/shmem_acl.c                 |    2 +-
 net/unix/af_unix.c             |    2 +-
 security/dummy.c               |    2 +-
 security/selinux/hooks.c       |    4 ++--
 44 files changed, 92 insertions(+), 92 deletions(-)

--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -469,8 +469,6 @@ extern bool afs_cm_incoming_call(struct 
 extern const struct inode_operations afs_dir_inode_operations;
 extern const struct file_operations afs_dir_file_operations;
 
-extern int afs_permission(struct inode *, int, struct nameidata *);
-
 /*
  * file.c
  */
@@ -607,7 +605,7 @@ extern void afs_clear_permits(struct afs
 extern void afs_cache_permit(struct afs_vnode *, struct key *, long);
 extern void afs_zap_permits(struct rcu_head *);
 extern struct key *afs_request_key(struct afs_cell *);
-extern int afs_permission(struct inode *, int, struct nameidata *);
+extern int afs_permission(struct inode *, int, struct vfs_lookup *);
 
 /*
  * server.c
--- a/fs/afs/security.c
+++ b/fs/afs/security.c
@@ -284,7 +284,7 @@ static int afs_check_permit(struct afs_v
  * - AFS ACLs are attached to directories only, and a file is controlled by its
  *   parent directory's ACL
  */
-int afs_permission(struct inode *inode, int mask, struct nameidata *nd)
+int afs_permission(struct inode *inode, int mask, struct vfs_lookup *lookup)
 {
 	struct afs_vnode *vnode = AFS_FS_I(inode);
 	afs_access_t access;
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -244,7 +244,7 @@ static int bad_inode_readlink(struct den
 }
 
 static int bad_inode_permission(struct inode *inode, int mask,
-			struct nameidata *nd)
+			struct vfs_lookup *lookup)
 {
 	return -EIO;
 }
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -234,7 +234,8 @@ cifs_statfs(struct dentry *dentry, struc
 				   longer available? */
 }
 
-static int cifs_permission(struct inode *inode, int mask, struct nameidata *nd)
+static int cifs_permission(struct inode *inode, int mask,
+		struct vfs_lookup *lookup)
 {
 	struct cifs_sb_info *cifs_sb;
 
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -137,7 +137,7 @@ exit:
 }
 
 
-int coda_permission(struct inode *inode, int mask, struct nameidata *nd)
+int coda_permission(struct inode *inode, int mask, struct vfs_lookup *lookup)
 {
         int error = 0;
  
--- a/fs/coda/pioctl.c
+++ b/fs/coda/pioctl.c
@@ -25,7 +25,7 @@
 
 /* pioctl ops */
 static int coda_ioctl_permission(struct inode *inode, int mask,
-				 struct nameidata *nd);
+				 struct vfs_lookup *lookup);
 static int coda_pioctl(struct inode * inode, struct file * filp, 
                        unsigned int cmd, unsigned long user_data);
 
@@ -43,7 +43,7 @@ const struct file_operations coda_ioctl_
 
 /* the coda pioctl inode ops */
 static int coda_ioctl_permission(struct inode *inode, int mask,
-				 struct nameidata *nd)
+				 struct vfs_lookup *lookup)
 {
         return 0;
 }
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -855,19 +855,19 @@ out:
 }
 
 static int
-ecryptfs_permission(struct inode *inode, int mask, struct nameidata *nd)
+ecryptfs_permission(struct inode *inode, int mask, struct vfs_lookup *lookup)
 {
 	int rc;
 
-        if (nd) {
-		struct vfsmount *vfsmnt_save = nd->lookup.path.mnt;
-		struct dentry *dentry_save = nd->lookup.path.dentry;
-
-		nd->lookup.path.mnt = ecryptfs_dentry_to_lower_mnt(nd->lookup.path.dentry);
-		nd->lookup.path.dentry = ecryptfs_dentry_to_lower(nd->lookup.path.dentry);
-		rc = permission(ecryptfs_inode_to_lower(inode), mask, nd);
-		nd->lookup.path.mnt = vfsmnt_save;
-		nd->lookup.path.dentry = dentry_save;
+        if (lookup) {
+		struct vfsmount *vfsmnt_save = lookup->path.mnt;
+		struct dentry *dentry_save = lookup->path.dentry;
+
+		lookup->path.mnt = ecryptfs_dentry_to_lower_mnt(lookup->path.dentry);
+		lookup->path.dentry = ecryptfs_dentry_to_lower(lookup->path.dentry);
+		rc = permission(ecryptfs_inode_to_lower(inode), mask, lookup);
+		lookup->path.mnt = vfsmnt_save;
+		lookup->path.dentry = dentry_save;
         } else
 		rc = permission(ecryptfs_inode_to_lower(inode), mask, NULL);
         return rc;
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -142,7 +142,7 @@ asmlinkage long sys_uselib(const char __
 	if (!S_ISREG(nd.lookup.path.dentry->d_inode->i_mode))
 		goto exit;
 
-	error = vfs_permission(&nd, MAY_READ | MAY_EXEC);
+	error = vfs_permission(&nd.lookup, MAY_READ | MAY_EXEC);
 	if (error)
 		goto exit;
 
@@ -683,7 +683,7 @@ struct file *open_exec(const char *name)
 		file = ERR_PTR(-EACCES);
 		if (!(nd.lookup.path.mnt->mnt_flags & MNT_NOEXEC) &&
 		    S_ISREG(inode->i_mode)) {
-			int err = vfs_permission(&nd, MAY_EXEC);
+			int err = vfs_permission(&nd.lookup, MAY_EXEC);
 			file = ERR_PTR(err);
 			if (!err) {
 				file = nameidata_to_filp(&nd, O_RDONLY);
--- a/fs/ext2/acl.c
+++ b/fs/ext2/acl.c
@@ -294,7 +294,7 @@ ext2_check_acl(struct inode *inode, int 
 }
 
 int
-ext2_permission(struct inode *inode, int mask, struct nameidata *nd)
+ext2_permission(struct inode *inode, int mask, struct vfs_lookup *lookup)
 {
 	return generic_permission(inode, mask, ext2_check_acl);
 }
--- a/fs/ext2/acl.h
+++ b/fs/ext2/acl.h
@@ -58,7 +58,7 @@ static inline int ext2_acl_count(size_t 
 #define EXT2_ACL_NOT_CACHED ((void *)-1)
 
 /* acl.c */
-extern int ext2_permission (struct inode *, int, struct nameidata *);
+extern int ext2_permission (struct inode *, int, struct vfs_lookup *);
 extern int ext2_acl_chmod (struct inode *);
 extern int ext2_init_acl (struct inode *, struct inode *);
 
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -299,7 +299,7 @@ ext3_check_acl(struct inode *inode, int 
 }
 
 int
-ext3_permission(struct inode *inode, int mask, struct nameidata *nd)
+ext3_permission(struct inode *inode, int mask, struct vfs_lookup *lookup)
 {
 	return generic_permission(inode, mask, ext3_check_acl);
 }
--- a/fs/ext3/acl.h
+++ b/fs/ext3/acl.h
@@ -58,7 +58,7 @@ static inline int ext3_acl_count(size_t 
 #define EXT3_ACL_NOT_CACHED ((void *)-1)
 
 /* acl.c */
-extern int ext3_permission (struct inode *, int, struct nameidata *);
+extern int ext3_permission (struct inode *, int, struct vfs_lookup *);
 extern int ext3_acl_chmod (struct inode *);
 extern int ext3_init_acl (handle_t *, struct inode *, struct inode *);
 
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -299,7 +299,7 @@ ext4_check_acl(struct inode *inode, int 
 }
 
 int
-ext4_permission(struct inode *inode, int mask, struct nameidata *nd)
+ext4_permission(struct inode *inode, int mask, struct vfs_lookup *lookup)
 {
 	return generic_permission(inode, mask, ext4_check_acl);
 }
--- a/fs/ext4/acl.h
+++ b/fs/ext4/acl.h
@@ -58,7 +58,7 @@ static inline int ext4_acl_count(size_t 
 #define EXT4_ACL_NOT_CACHED ((void *)-1)
 
 /* acl.c */
-extern int ext4_permission (struct inode *, int, struct nameidata *);
+extern int ext4_permission (struct inode *, int, struct vfs_lookup *);
 extern int ext4_acl_chmod (struct inode *);
 extern int ext4_init_acl (handle_t *, struct inode *, struct inode *);
 
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -792,7 +792,7 @@ static int fuse_access(struct inode *ino
  * access request is sent.  Execute permission is still checked
  * locally based on file mode.
  */
-static int fuse_permission(struct inode *inode, int mask, struct nameidata *nd)
+static int fuse_permission(struct inode *inode, int mask, struct vfs_lookup *lookup)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 
@@ -821,7 +821,7 @@ static int fuse_permission(struct inode 
 		if ((mask & MAY_EXEC) && !S_ISDIR(mode) && !(mode & S_IXUGO))
 			return -EACCES;
 
-		if (nd && (nd->lookup.flags & (LOOKUP_ACCESS | LOOKUP_CHDIR)))
+		if (lookup && (lookup->flags & (LOOKUP_ACCESS | LOOKUP_CHDIR)))
 			return fuse_access(inode, mask);
 		return 0;
 	}
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -861,7 +861,7 @@ static void *gfs2_follow_link(struct den
  * gfs2_permission -
  * @inode:
  * @mask:
- * @nd: passed from Linux VFS, ignored by us
+ * @lookup: passed from Linux VFS, ignored by us
  *
  * This may be called from the VFS directly, or from within GFS2 with the
  * inode locked, so we look to see if the glock is already locked and only
@@ -870,7 +870,7 @@ static void *gfs2_follow_link(struct den
  * Returns: errno
  */
 
-static int gfs2_permission(struct inode *inode, int mask, struct nameidata *nd)
+static int gfs2_permission(struct inode *inode, int mask, struct vfs_lookup *lookup)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_holder i_gh;
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -508,7 +508,7 @@ void hfs_clear_inode(struct inode *inode
 }
 
 static int hfs_permission(struct inode *inode, int mask,
-			  struct nameidata *nd)
+			  struct vfs_lookup *lookup)
 {
 	if (S_ISREG(inode->i_mode) && mask & MAY_EXEC)
 		return 0;
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -232,7 +232,7 @@ static void hfsplus_set_perms(struct ino
 	perms->dev = cpu_to_be32(HFSPLUS_I(inode).dev);
 }
 
-static int hfsplus_permission(struct inode *inode, int mask, struct nameidata *nd)
+static int hfsplus_permission(struct inode *inode, int mask, struct vfs_lookup *lookup)
 {
 	/* MAY_EXEC is also used for lookup, if no x bit is set allow lookup,
 	 * open_exec has the same test, so it's still not executable, if a x bit
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -349,7 +349,7 @@ static int find_inode(const char __user 
 	if (error)
 		return error;
 	/* you can only watch an inode if you have read permissions on it */
-	error = vfs_permission(nd, MAY_READ);
+	error = vfs_permission(nd.lookup, MAY_READ);
 	if (error)
 		path_release(nd);
 	return error;
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -302,7 +302,7 @@ static int jffs2_check_acl(struct inode 
 	return -EAGAIN;
 }
 
-int jffs2_permission(struct inode *inode, int mask, struct nameidata *nd)
+int jffs2_permission(struct inode *inode, int mask, struct vfs_lookup *lookup)
 {
 	return generic_permission(inode, mask, jffs2_check_acl);
 }
--- a/fs/jffs2/acl.h
+++ b/fs/jffs2/acl.h
@@ -28,7 +28,7 @@ struct jffs2_acl_header {
 
 #define JFFS2_ACL_NOT_CACHED ((void *)-1)
 
-extern int jffs2_permission(struct inode *, int, struct nameidata *);
+extern int jffs2_permission(struct inode *, int, struct vfs_lookup *);
 extern int jffs2_acl_chmod(struct inode *);
 extern int jffs2_init_acl(struct inode *, struct inode *);
 extern void jffs2_clear_acl(struct jffs2_inode_info *);
--- a/fs/jfs/acl.c
+++ b/fs/jfs/acl.c
@@ -140,7 +140,7 @@ static int jfs_check_acl(struct inode *i
 	return -EAGAIN;
 }
 
-int jfs_permission(struct inode *inode, int mask, struct nameidata *nd)
+int jfs_permission(struct inode *inode, int mask, struct vfs_lookup *lookup)
 {
 	return generic_permission(inode, mask, jfs_check_acl);
 }
--- a/fs/jfs/jfs_acl.h
+++ b/fs/jfs/jfs_acl.h
@@ -20,7 +20,7 @@
 
 #ifdef CONFIG_JFS_POSIX_ACL
 
-int jfs_permission(struct inode *, int, struct nameidata *);
+int jfs_permission(struct inode *, int, struct vfs_lookup *);
 int jfs_init_acl(tid_t, struct inode *, struct inode *);
 int jfs_setattr(struct dentry *, struct iattr *);
 
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -226,7 +226,7 @@ int generic_permission(struct inode *ino
 	return -EACCES;
 }
 
-int permission(struct inode *inode, int mask, struct nameidata *nd)
+int permission(struct inode *inode, int mask, struct vfs_lookup *lookup)
 {
 	umode_t mode = inode->i_mode;
 	int retval, submask;
@@ -254,24 +254,25 @@ int permission(struct inode *inode, int 
 	 * the fs is mounted with the "noexec" flag.
 	 */
 	if ((mask & MAY_EXEC) && S_ISREG(mode) && (!(mode & S_IXUGO) ||
-			(nd && nd->lookup.path.mnt && (nd->lookup.path.mnt->mnt_flags & MNT_NOEXEC))))
+			(lookup && lookup->path.mnt &&
+			 (lookup->path.mnt->mnt_flags & MNT_NOEXEC))))
 		return -EACCES;
 
 	/* Ordinary permission routines do not understand MAY_APPEND. */
 	submask = mask & ~MAY_APPEND;
 	if (inode->i_op && inode->i_op->permission)
-		retval = inode->i_op->permission(inode, submask, nd);
+		retval = inode->i_op->permission(inode, submask, lookup);
 	else
 		retval = generic_permission(inode, submask, NULL);
 	if (retval)
 		return retval;
 
-	return security_inode_permission(inode, mask, nd);
+	return security_inode_permission(inode, mask, lookup);
 }
 
 /**
  * vfs_permission  -  check for access rights to a given path
- * @nd:		lookup result that describes the path
+ * @lookup:	lookup result that describes the path
  * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
  *
  * Used to check for read/write/execute permissions on a path.
@@ -279,9 +280,9 @@ int permission(struct inode *inode, int 
  * for filesystem access without changing the "normal" uids which
  * are used for other things.
  */
-int vfs_permission(struct nameidata *nd, int mask)
+int vfs_permission(struct vfs_lookup *lookup, int mask)
 {
-	return permission(nd->lookup.path.dentry->d_inode, mask, nd);
+	return permission(lookup->path.dentry->d_inode, mask, lookup);
 }
 
 /**
@@ -429,8 +430,7 @@ static struct dentry * cached_lookup(str
  * short-cut DAC fails, then call permission() to do more
  * complete permission check.
  */
-static int exec_permission_lite(struct inode *inode,
-				       struct nameidata *nd)
+static int exec_permission_lite(struct inode *inode, struct vfs_lookup *lookup)
 {
 	umode_t	mode = inode->i_mode;
 
@@ -456,7 +456,7 @@ static int exec_permission_lite(struct i
 
 	return -EACCES;
 ok:
-	return security_inode_permission(inode, MAY_EXEC, nd);
+	return security_inode_permission(inode, MAY_EXEC, lookup);
 }
 
 /*
@@ -831,9 +831,9 @@ static fastcall int __link_path_walk(con
 		unsigned int c;
 
 		nd->lookup.flags |= LOOKUP_CONTINUE;
-		err = exec_permission_lite(inode, nd);
+		err = exec_permission_lite(inode, &nd->lookup);
 		if (err == -EAGAIN)
-			err = vfs_permission(nd, MAY_EXEC);
+			err = vfs_permission(&nd->lookup, MAY_EXEC);
  		if (err)
 			break;
 
@@ -1321,7 +1321,7 @@ static inline struct dentry * __lookup_h
 
 	inode = base->d_inode;
 
-	err = permission(inode, MAY_EXEC, nd);
+	err = permission(inode, MAY_EXEC, &nd->lookup);
 	dentry = ERR_PTR(err);
 	if (err)
 		goto out;
@@ -1473,13 +1473,13 @@ static int may_delete(struct inode *dir,
  *  4. We can't do it if dir is immutable (done in permission())
  */
 static inline int may_create(struct inode *dir, struct dentry *child,
-			     struct nameidata *nd)
+			     struct vfs_lookup *lookup)
 {
 	if (child->d_inode)
 		return -EEXIST;
 	if (IS_DEADDIR(dir))
 		return -ENOENT;
-	return permission(dir,MAY_WRITE | MAY_EXEC, nd);
+	return permission(dir,MAY_WRITE | MAY_EXEC, lookup);
 }
 
 /* 
@@ -1545,7 +1545,7 @@ void unlock_rename(struct dentry *p1, st
 int vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 		struct nameidata *nd)
 {
-	int error = may_create(dir, dentry, nd);
+	int error = may_create(dir, dentry, &nd->lookup);
 
 	if (error)
 		return error;
@@ -1579,7 +1579,7 @@ int may_open(struct nameidata *nd, int a
 	if (S_ISDIR(inode->i_mode) && (flag & FMODE_WRITE))
 		return -EISDIR;
 
-	error = vfs_permission(nd, acc_mode);
+	error = vfs_permission(&nd->lookup, acc_mode);
 	if (error)
 		return error;
 
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1955,7 +1955,7 @@ out:
 	return -EACCES;
 }
 
-int nfs_permission(struct inode *inode, int mask, struct nameidata *nd)
+int nfs_permission(struct inode *inode, int mask, struct vfs_lookup *lookup)
 {
 	struct rpc_cred *cred;
 	int res = 0;
@@ -1965,7 +1965,7 @@ int nfs_permission(struct inode *inode, 
 	if (mask == 0)
 		goto out;
 	/* Is this sys_access() ? */
-	if (nd != NULL && (nd->lookup.flags & LOOKUP_ACCESS))
+	if (lookup && (lookup->flags & LOOKUP_ACCESS))
 		goto force_lookup;
 
 	switch (inode->i_mode & S_IFMT) {
@@ -1974,8 +1974,8 @@ int nfs_permission(struct inode *inode, 
 		case S_IFREG:
 			/* NFSv4 has atomic_open... */
 			if (nfs_server_capable(inode, NFS_CAP_ATOMIC_OPEN)
-					&& nd != NULL
-					&& (nd->lookup.flags & LOOKUP_OPEN))
+					&& lookup
+					&& (lookup->flags & LOOKUP_OPEN))
 				goto out;
 			break;
 		case S_IFDIR:
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1091,7 +1091,7 @@ bail:
 	return err;
 }
 
-int ocfs2_permission(struct inode *inode, int mask, struct nameidata *nd)
+int ocfs2_permission(struct inode *inode, int mask, struct vfs_lookup *lookup)
 {
 	int ret;
 
--- a/fs/ocfs2/file.h
+++ b/fs/ocfs2/file.h
@@ -54,8 +54,7 @@ int ocfs2_lock_allocators(struct inode *
 int ocfs2_setattr(struct dentry *dentry, struct iattr *attr);
 int ocfs2_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		  struct kstat *stat);
-int ocfs2_permission(struct inode *inode, int mask,
-		     struct nameidata *nd);
+int ocfs2_permission(struct inode *inode, int mask, struct vfs_lookup *lookup);
 
 int ocfs2_should_update_atime(struct inode *inode,
 			      struct vfsmount *vfsmnt);
--- a/fs/open.c
+++ b/fs/open.c
@@ -244,7 +244,7 @@ static long do_sys_truncate(const char _
 	if (!S_ISREG(inode->i_mode))
 		goto dput_and_out;
 
-	error = vfs_permission(&nd, MAY_WRITE);
+	error = vfs_permission(&nd.lookup, MAY_WRITE);
 	if (error)
 		goto dput_and_out;
 
@@ -452,7 +452,7 @@ asmlinkage long sys_faccessat(int dfd, c
 	if (res)
 		goto out;
 
-	res = vfs_permission(&nd, mode);
+	res = vfs_permission(&nd.lookup, mode);
 	/* SuS v2 requires we report a read only fs too */
 	if(res || !(mode & S_IWOTH) ||
 	   special_file(nd.lookup.path.dentry->d_inode->i_mode))
@@ -486,7 +486,7 @@ asmlinkage long sys_chdir(const char __u
 	if (error)
 		goto out;
 
-	error = vfs_permission(&nd, MAY_EXEC);
+	error = vfs_permission(&nd.lookup, MAY_EXEC);
 	if (error)
 		goto dput_and_out;
 
@@ -537,7 +537,7 @@ asmlinkage long sys_chroot(const char __
 	if (error)
 		goto out;
 
-	error = vfs_permission(&nd, MAY_EXEC);
+	error = vfs_permission(&nd.lookup, MAY_EXEC);
 	if (error)
 		goto dput_and_out;
 
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1479,7 +1479,7 @@ static const struct file_operations proc
  * access /proc/self/fd after it has executed a setuid().
  */
 static int proc_fd_permission(struct inode *inode, int mask,
-				struct nameidata *nd)
+				struct vfs_lookup *lookup)
 {
 	int rv;
 
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -369,7 +369,8 @@ out:
 	return ret;
 }
 
-static int proc_sys_permission(struct inode *inode, int mask, struct nameidata *nd)
+static int proc_sys_permission(struct inode *inode, int mask,
+			       struct vfs_lookup *lookup)
 {
 	/*
 	 * sysctl entries that are not writeable,
@@ -402,10 +403,10 @@ static int proc_sys_permission(struct in
 	/* If we can't get a sysctl table entry the permission
 	 * checks on the cached mode will have to be enough.
 	 */
-	if (!nd || !depth)
+	if (!lookup || !depth)
 		goto out;
 
-	dentry = nd->lookup.path.dentry;
+	dentry = lookup->path.dentry;
 	table = do_proc_sys_lookup(dentry->d_parent, &dentry->d_name, &head);
 
 	/* If the entry does not exist deny permission */
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -1294,7 +1294,8 @@ static int reiserfs_check_acl(struct ino
 	return error;
 }
 
-int reiserfs_permission(struct inode *inode, int mask, struct nameidata *nd)
+int reiserfs_permission(struct inode *inode, int mask,
+			struct vfs_lookup *lookup)
 {
 	/*
 	 * We don't do permission checks on the internal objects.
--- a/fs/smbfs/file.c
+++ b/fs/smbfs/file.c
@@ -391,7 +391,7 @@ smb_file_release(struct inode *inode, st
  * privileges, so we need our own check for this.
  */
 static int
-smb_file_permission(struct inode *inode, int mask, struct nameidata *nd)
+smb_file_permission(struct inode *inode, int mask, struct vfs_lookup *lookup)
 {
 	int mode = inode->i_mode;
 	int error = 0;
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -111,7 +111,7 @@ long do_utimes(int dfd, char __user *fil
 				if (!(f->f_mode & FMODE_WRITE))
 					goto dput_and_out;
 			} else {
-				error = vfs_permission(&nd, MAY_WRITE);
+				error = vfs_permission(&nd.lookup, MAY_WRITE);
 				if (error)
 					goto dput_and_out;
 			}
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -605,7 +605,7 @@ STATIC int
 xfs_vn_permission(
 	struct inode	*inode,
 	int		mode,
-	struct nameidata *nd)
+	struct vfs_lookup *lookup)
 {
 	return -bhv_vop_access(vn_from_inode(inode), mode << 6, NULL);
 }
--- a/include/linux/coda_linux.h
+++ b/include/linux/coda_linux.h
@@ -37,7 +37,7 @@ extern const struct file_operations coda
 /* operations shared over more than one file */
 int coda_open(struct inode *i, struct file *f);
 int coda_release(struct inode *i, struct file *f);
-int coda_permission(struct inode *inode, int mask, struct nameidata *nd);
+int coda_permission(struct inode *inode, int mask, struct vfs_lookup *lookup);
 int coda_revalidate_inode(struct dentry *);
 int coda_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 int coda_setattr(struct dentry *, struct iattr *);
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1008,7 +1008,7 @@ extern void unlock_super(struct super_bl
 /*
  * VFS helper functions..
  */
-extern int vfs_permission(struct nameidata *, int);
+extern int vfs_permission(struct vfs_lookup *, int);
 extern int vfs_create(struct inode *, struct dentry *, int, struct nameidata *);
 extern int vfs_mkdir(struct inode *, struct dentry *, int);
 extern int vfs_mknod(struct inode *, struct dentry *, int, dev_t);
@@ -1147,7 +1147,7 @@ struct inode_operations {
 	void * (*follow_link) (struct dentry *, struct nameidata *);
 	void (*put_link) (struct dentry *, struct nameidata *, void *);
 	void (*truncate) (struct inode *);
-	int (*permission) (struct inode *, int, struct nameidata *);
+	int (*permission) (struct inode *, int, struct vfs_lookup *);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
 	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
@@ -1562,7 +1562,7 @@ extern int do_remount_sb(struct super_bl
 extern sector_t bmap(struct inode *, sector_t);
 #endif
 extern int notify_change(struct dentry *, struct iattr *);
-extern int permission(struct inode *, int, struct nameidata *);
+extern int permission(struct inode *, int, struct vfs_lookup *);
 extern int generic_permission(struct inode *, int,
 		int (*check_acl)(struct inode *, int));
 
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -288,7 +288,7 @@ extern struct inode *nfs_fhget(struct su
 extern int nfs_refresh_inode(struct inode *, struct nfs_fattr *);
 extern int nfs_post_op_update_inode(struct inode *inode, struct nfs_fattr *fattr);
 extern int nfs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
-extern int nfs_permission(struct inode *, int, struct nameidata *);
+extern int nfs_permission(struct inode *, int, struct vfs_lookup *);
 extern int nfs_access_get_cached(struct inode *, struct rpc_cred *, struct nfs_access_entry *);
 extern void nfs_access_add_cache(struct inode *, struct nfs_access_entry *);
 extern void nfs_access_zap_cache(struct inode *inode);
--- a/include/linux/reiserfs_xattr.h
+++ b/include/linux/reiserfs_xattr.h
@@ -55,8 +55,8 @@ int reiserfs_removexattr(struct dentry *
 int reiserfs_delete_xattrs(struct inode *inode);
 int reiserfs_chown_xattrs(struct inode *inode, struct iattr *attrs);
 int reiserfs_xattr_init(struct super_block *sb, int mount_flags);
-int reiserfs_permission(struct inode *inode, int mask, struct nameidata *nd);
-
+int reiserfs_permission(struct inode *inode, int mask,
+			struct vfs_lookup *lookup);
 int reiserfs_xattr_del(struct inode *, const char *);
 int reiserfs_xattr_get(const struct inode *, const char *, void *, size_t);
 int reiserfs_xattr_set(struct inode *, const char *, const void *, size_t, int);
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -350,7 +350,7 @@ struct request_sock;
  *	called when the actual read/write operations are performed.
  *	@inode contains the inode structure to check.
  *	@mask contains the permission mask.
- *     @nd contains the nameidata (may be NULL).
+ *     @lookup contains the vfs_lookup (may be NULL).
  *	Return 0 if permission is granted.
  * @inode_setattr:
  *	Check permission before setting file attributes.  Note that the kernel
@@ -1220,7 +1220,7 @@ struct security_operations {
 	                     struct inode *new_dir, struct dentry *new_dentry);
 	int (*inode_readlink) (struct dentry *dentry);
 	int (*inode_follow_link) (struct dentry *dentry, struct nameidata *nd);
-	int (*inode_permission) (struct inode *inode, int mask, struct nameidata *nd);
+	int (*inode_permission) (struct inode *inode, int mask, struct vfs_lookup *lookup);
 	int (*inode_setattr)	(struct dentry *dentry, struct iattr *attr);
 	int (*inode_getattr) (struct vfsmount *mnt, struct dentry *dentry);
         void (*inode_delete) (struct inode *inode);
@@ -1700,11 +1700,11 @@ static inline int security_inode_follow_
 }
 
 static inline int security_inode_permission (struct inode *inode, int mask,
-					     struct nameidata *nd)
+					     struct vfs_lookup *lookup)
 {
 	if (unlikely (IS_PRIVATE (inode)))
 		return 0;
-	return security_ops->inode_permission (inode, mask, nd);
+	return security_ops->inode_permission (inode, mask, lookup);
 }
 
 static inline int security_inode_setattr (struct dentry *dentry,
@@ -2408,7 +2408,7 @@ static inline int security_inode_follow_
 }
 
 static inline int security_inode_permission (struct inode *inode, int mask,
-					     struct nameidata *nd)
+					     struct vfs_lookup *lookup)
 {
 	return 0;
 }
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -41,7 +41,7 @@ static inline struct shmem_inode_info *S
 }
 
 #ifdef CONFIG_TMPFS_POSIX_ACL
-int shmem_permission(struct inode *, int, struct nameidata *);
+int shmem_permission(struct inode *, int, struct vfs_lookup *);
 int shmem_acl_init(struct inode *, struct inode *);
 void shmem_acl_destroy_inode(struct inode *);
 
--- a/mm/shmem_acl.c
+++ b/mm/shmem_acl.c
@@ -191,7 +191,7 @@ shmem_check_acl(struct inode *inode, int
  * shmem_permission  -  permission() inode operation
  */
 int
-shmem_permission(struct inode *inode, int mask, struct nameidata *nd)
+shmem_permission(struct inode *inode, int mask, struct vfs_lookup *lookup)
 {
 	return generic_permission(inode, mask, shmem_check_acl);
 }
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -729,7 +729,7 @@ static struct sock *unix_find_other(stru
 		err = path_lookup(sunname->sun_path, LOOKUP_FOLLOW, &nd);
 		if (err)
 			goto fail;
-		err = vfs_permission(&nd, MAY_WRITE);
+		err = vfs_permission(&nd.lookup, MAY_WRITE);
 		if (err)
 			goto put_fail;
 
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -323,7 +323,7 @@ static int dummy_inode_follow_link (stru
 	return 0;
 }
 
-static int dummy_inode_permission (struct inode *inode, int mask, struct nameidata *nd)
+static int dummy_inode_permission (struct inode *inode, int mask, struct vfs_lookup *lookup)
 {
 	return 0;
 }
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2250,11 +2250,11 @@ static int selinux_inode_follow_link(str
 }
 
 static int selinux_inode_permission(struct inode *inode, int mask,
-				    struct nameidata *nd)
+				    struct vfs_lookup *lookup)
 {
 	int rc;
 
-	rc = secondary_ops->inode_permission(inode, mask, nd);
+	rc = secondary_ops->inode_permission(inode, mask, lookup);
 	if (rc)
 		return rc;
 

