Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbYE2Lg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbYE2Lg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 07:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbYE2Ldi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 07:33:38 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56712 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbYE2Ld0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 07:33:26 -0400
Message-Id: <20080529113316.944934442@szeredi.hu>
References: <20080529113245.450308367@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 13:32:52 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 7/8] vfs: clean up getattr API
Content-Disposition: inline; filename=path_getattr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Instead of a separate vfsmount and dentry arguments, pass a 'struct
path' to getattr related function.  Don't touch i_op->getattr()
though, because the vfsmount should be removed altogether.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 drivers/block/loop.c       |    2 +-
 fs/gfs2/ops_fstype.c       |    2 +-
 fs/nfsd/nfs3proc.c         |    5 +++--
 fs/nfsd/nfs3xdr.c          |    9 ++++++---
 fs/nfsd/nfs4xdr.c          |   10 +++++++---
 fs/nfsd/nfsproc.c          |   32 ++++++++++++++++++++------------
 fs/nfsd/nfsxdr.c           |    5 ++++-
 fs/nfsd/vfs.c              |    2 +-
 fs/stat.c                  |   16 ++++++++--------
 include/linux/fs.h         |    2 +-
 include/linux/nfsd/nfsd.h  |    1 +
 include/linux/security.h   |   10 ++++------
 security/dummy.c           |    2 +-
 security/security.c        |    6 +++---
 security/selinux/hooks.c   |    4 ++--
 security/smack/smack_lsm.c |    7 +++----
 16 files changed, 66 insertions(+), 49 deletions(-)

Index: linux-2.6/drivers/block/loop.c
===================================================================
--- linux-2.6.orig/drivers/block/loop.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/drivers/block/loop.c	2008-05-29 12:46:25.000000000 +0200
@@ -1007,7 +1007,7 @@ loop_get_status(struct loop_device *lo, 
 
 	if (lo->lo_state != Lo_bound)
 		return -ENXIO;
-	error = vfs_getattr(file->f_path.mnt, file->f_path.dentry, &stat);
+	error = path_getattr(&file->f_path, &stat);
 	if (error)
 		return error;
 	memset(info, 0, sizeof(*info));
Index: linux-2.6/fs/gfs2/ops_fstype.c
===================================================================
--- linux-2.6.orig/fs/gfs2/ops_fstype.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/fs/gfs2/ops_fstype.c	2008-05-29 12:46:25.000000000 +0200
@@ -952,7 +952,7 @@ static struct super_block* get_gfs2_sb(c
 		       dev_name);
 		goto out;
 	}
-	error = vfs_getattr(nd.path.mnt, nd.path.dentry, &stat);
+	error = path_getattr(&nd.path, &stat);
 
 	list_for_each_entry(s, &gfs2_fs_type.fs_supers, s_instances) {
 		if ((S_ISBLK(stat.mode) && s->s_dev == stat.rdev) ||
Index: linux-2.6/fs/nfsd/nfs3proc.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfs3proc.c	2008-05-29 12:46:23.000000000 +0200
+++ linux-2.6/fs/nfsd/nfs3proc.c	2008-05-29 12:46:25.000000000 +0200
@@ -58,6 +58,7 @@ nfsd3_proc_getattr(struct svc_rqst *rqst
 {
 	int	err;
 	__be32	nfserr;
+	struct path path;
 
 	dprintk("nfsd: GETATTR(3)  %s\n",
 		SVCFH_fmt(&argp->fh));
@@ -67,8 +68,8 @@ nfsd3_proc_getattr(struct svc_rqst *rqst
 	if (nfserr)
 		RETURN_STATUS(nfserr);
 
-	err = vfs_getattr(resp->fh.fh_export->ex_path.mnt,
-			  resp->fh.fh_dentry, &resp->stat);
+	fh_to_path(&resp->fh, &path);
+	err = path_getattr(&path, &resp->stat);
 	nfserr = nfserrno(err);
 
 	RETURN_STATUS(nfserr);
Index: linux-2.6/fs/nfsd/nfs3xdr.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfs3xdr.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/fs/nfsd/nfs3xdr.c	2008-05-29 12:46:25.000000000 +0200
@@ -217,8 +217,10 @@ encode_post_op_attr(struct svc_rqst *rqs
 	if (dentry && dentry->d_inode) {
 	        int err;
 		struct kstat stat;
+		struct path path;
 
-		err = vfs_getattr(fhp->fh_export->ex_path.mnt, dentry, &stat);
+		fh_to_path(fhp, &path);
+		err = path_getattr(&path, &stat);
 		if (!err) {
 			*p++ = xdr_one;		/* attributes follow */
 			lease_get_mtime(dentry->d_inode, &stat.mtime);
@@ -265,13 +267,14 @@ encode_wcc_data(struct svc_rqst *rqstp, 
  */
 void fill_post_wcc(struct svc_fh *fhp)
 {
+	struct path path;
 	int err;
 
 	if (fhp->fh_post_saved)
 		printk("nfsd: inode locked twice during operation.\n");
 
-	err = vfs_getattr(fhp->fh_export->ex_path.mnt, fhp->fh_dentry,
-			&fhp->fh_post_attr);
+	fh_to_path(fhp, &path);
+	err = path_getattr(&path, &fhp->fh_post_attr);
 	if (err)
 		fhp->fh_post_saved = 0;
 	else
Index: linux-2.6/fs/nfsd/nfs4xdr.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfs4xdr.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/fs/nfsd/nfs4xdr.c	2008-05-29 12:46:25.000000000 +0200
@@ -1456,6 +1456,7 @@ nfsd4_encode_fattr(struct svc_fh *fhp, s
 	int err;
 	int aclsupport = 0;
 	struct nfs4_acl *acl = NULL;
+	struct path path;
 
 	BUG_ON(bmval1 & NFSD_WRITEONLY_ATTRS_WORD1);
 	BUG_ON(bmval0 & ~NFSD_SUPPORTED_ATTRS_WORD0);
@@ -1467,7 +1468,9 @@ nfsd4_encode_fattr(struct svc_fh *fhp, s
 			goto out;
 	}
 
-	err = vfs_getattr(exp->ex_path.mnt, dentry, &stat);
+	path.mnt = exp->ex_path.mnt;
+	path.dentry = dentry;
+	err = path_getattr(&path, &stat);
 	if (err)
 		goto out_nfserr;
 	if ((bmval0 & (FATTR4_WORD0_FILES_FREE | FATTR4_WORD0_FILES_TOTAL |
@@ -1825,8 +1828,9 @@ out_acl:
 		 */
 		if (ignore_crossmnt == 0 &&
 		    exp->ex_path.mnt->mnt_root->d_inode == dentry->d_inode) {
-			err = vfs_getattr(exp->ex_path.mnt->mnt_parent,
-				exp->ex_path.mnt->mnt_mountpoint, &stat);
+			path.mnt = exp->ex_path.mnt->mnt_parent;
+			path.dentry = exp->ex_path.mnt->mnt_mountpoint;
+			err = path_getattr(&path, &stat);
 			if (err)
 				goto out_nfserr;
 		}
Index: linux-2.6/fs/nfsd/nfsproc.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfsproc.c	2008-05-29 12:46:23.000000000 +0200
+++ linux-2.6/fs/nfsd/nfsproc.c	2008-05-29 12:46:25.000000000 +0200
@@ -40,18 +40,24 @@ nfsd_proc_null(struct svc_rqst *rqstp, v
 static __be32
 nfsd_return_attrs(__be32 err, struct nfsd_attrstat *resp)
 {
-	if (err) return err;
-	return nfserrno(vfs_getattr(resp->fh.fh_export->ex_path.mnt,
-				    resp->fh.fh_dentry,
-				    &resp->stat));
+	struct path path;
+
+	if (err)
+		return err;
+
+	fh_to_path(&resp->fh, &path);
+	return nfserrno(path_getattr(&path, &resp->stat));
 }
 static __be32
 nfsd_return_dirop(__be32 err, struct nfsd_diropres *resp)
 {
-	if (err) return err;
-	return nfserrno(vfs_getattr(resp->fh.fh_export->ex_path.mnt,
-				    resp->fh.fh_dentry,
-				    &resp->stat));
+	struct path path;
+
+	if (err)
+		return err;
+
+	fh_to_path(&resp->fh, &path);
+	return nfserrno(path_getattr(&path, &resp->stat));
 }
 /*
  * Get a file's attributes
@@ -137,6 +143,7 @@ static __be32
 nfsd_proc_read(struct svc_rqst *rqstp, struct nfsd_readargs *argp,
 				       struct nfsd_readres  *resp)
 {
+	struct path path;
 	__be32	nfserr;
 
 	dprintk("nfsd: READ    %s %d bytes at %d\n",
@@ -163,10 +170,11 @@ nfsd_proc_read(struct svc_rqst *rqstp, s
 			   	  rqstp->rq_vec, argp->vlen,
 				  &resp->count);
 
-	if (nfserr) return nfserr;
-	return nfserrno(vfs_getattr(resp->fh.fh_export->ex_path.mnt,
-				    resp->fh.fh_dentry,
-				    &resp->stat));
+	if (nfserr)
+		return nfserr;
+
+	fh_to_path(&resp->fh, &path);
+	return nfserrno(path_getattr(&path, &resp->stat));
 }
 
 /*
Index: linux-2.6/fs/nfsd/nfsxdr.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfsxdr.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/fs/nfsd/nfsxdr.c	2008-05-29 12:46:25.000000000 +0200
@@ -207,7 +207,10 @@ encode_fattr(struct svc_rqst *rqstp, __b
 __be32 *nfs2svc_encode_fattr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp)
 {
 	struct kstat stat;
-	vfs_getattr(fhp->fh_export->ex_path.mnt, fhp->fh_dentry, &stat);
+	struct path path;
+
+	fh_to_path(fhp, &path);
+	path_getattr(&path, &stat);
 	return encode_fattr(rqstp, p, fhp, &stat);
 }
 
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2008-05-29 12:46:23.000000000 +0200
+++ linux-2.6/fs/nfsd/vfs.c	2008-05-29 12:46:25.000000000 +0200
@@ -130,7 +130,7 @@ out:
 	return err;
 }
 
-static void fh_to_path(struct svc_fh *fhp, struct path *path)
+void fh_to_path(struct svc_fh *fhp, struct path *path)
 {
 	path->dentry = fhp->fh_dentry;
 	path->mnt = fhp->fh_export->ex_path.mnt;
Index: linux-2.6/fs/stat.c
===================================================================
--- linux-2.6.orig/fs/stat.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/fs/stat.c	2008-05-29 12:46:25.000000000 +0200
@@ -37,23 +37,23 @@ void generic_fillattr(struct inode *inod
 
 EXPORT_SYMBOL(generic_fillattr);
 
-int vfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
+int path_getattr(struct path *path, struct kstat *stat)
 {
-	struct inode *inode = dentry->d_inode;
+	struct inode *inode = path->dentry->d_inode;
 	int retval;
 
-	retval = security_inode_getattr(mnt, dentry);
+	retval = security_inode_getattr(path);
 	if (retval)
 		return retval;
 
 	if (inode->i_op->getattr)
-		return inode->i_op->getattr(mnt, dentry, stat);
+		return inode->i_op->getattr(path->mnt, path->dentry, stat);
 
 	generic_fillattr(inode, stat);
 	return 0;
 }
 
-EXPORT_SYMBOL(vfs_getattr);
+EXPORT_SYMBOL(path_getattr);
 
 int vfs_stat_fd(int dfd, char __user *name, struct kstat *stat)
 {
@@ -62,7 +62,7 @@ int vfs_stat_fd(int dfd, char __user *na
 
 	error = __user_walk_fd(dfd, name, LOOKUP_FOLLOW, &nd);
 	if (!error) {
-		error = vfs_getattr(nd.path.mnt, nd.path.dentry, stat);
+		error = path_getattr(&nd.path, stat);
 		path_put(&nd.path);
 	}
 	return error;
@@ -82,7 +82,7 @@ int vfs_lstat_fd(int dfd, char __user *n
 
 	error = __user_walk_fd(dfd, name, 0, &nd);
 	if (!error) {
-		error = vfs_getattr(nd.path.mnt, nd.path.dentry, stat);
+		error = path_getattr(&nd.path, stat);
 		path_put(&nd.path);
 	}
 	return error;
@@ -101,7 +101,7 @@ int vfs_fstat(unsigned int fd, struct ks
 	int error = -EBADF;
 
 	if (f) {
-		error = vfs_getattr(f->f_path.mnt, f->f_path.dentry, stat);
+		error = path_getattr(&f->f_path, stat);
 		fput(f);
 	}
 	return error;
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-05-29 12:46:24.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-05-29 12:46:25.000000000 +0200
@@ -1977,7 +1977,7 @@ extern int page_symlink(struct inode *in
 extern const struct inode_operations page_symlink_inode_operations;
 extern int generic_readlink(struct dentry *, char __user *, int);
 extern void generic_fillattr(struct inode *, struct kstat *);
-extern int vfs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
+extern int path_getattr(struct path *, struct kstat *);
 void inode_add_bytes(struct inode *inode, loff_t bytes);
 void inode_sub_bytes(struct inode *inode, loff_t bytes);
 loff_t inode_get_bytes(struct inode *inode);
Index: linux-2.6/include/linux/nfsd/nfsd.h
===================================================================
--- linux-2.6.orig/include/linux/nfsd/nfsd.h	2008-05-29 12:46:23.000000000 +0200
+++ linux-2.6/include/linux/nfsd/nfsd.h	2008-05-29 12:46:25.000000000 +0200
@@ -71,6 +71,7 @@ int		nfsd_set_nrthreads(int n, int *);
 
 /* nfsd/vfs.c */
 int		fh_lock_parent(struct svc_fh *, struct dentry *);
+void		fh_to_path(struct svc_fh *, struct path *);
 int		nfsd_racache_init(int);
 void		nfsd_racache_shutdown(void);
 int		nfsd_cross_mnt(struct svc_rqst *rqstp, struct dentry **dpp,
Index: linux-2.6/include/linux/security.h
===================================================================
--- linux-2.6.orig/include/linux/security.h	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/include/linux/security.h	2008-05-29 12:46:25.000000000 +0200
@@ -418,8 +418,7 @@ static inline void security_free_mnt_opt
  *	Return 0 if permission is granted.
  * @inode_getattr:
  *	Check permission before obtaining file attributes.
- *	@mnt is the vfsmount where the dentry was looked up
- *	@dentry contains the dentry structure for the file.
+ *	@path the path to check
  *	Return 0 if permission is granted.
  * @inode_delete:
  *	@inode contains the inode structure for deleted inode.
@@ -1371,7 +1370,7 @@ struct security_operations {
 	int (*inode_follow_link) (struct dentry *dentry, struct nameidata *nd);
 	int (*inode_permission) (struct inode *inode, int mask);
 	int (*inode_setattr)	(struct dentry *dentry, struct iattr *attr);
-	int (*inode_getattr) (struct vfsmount *mnt, struct dentry *dentry);
+	int (*inode_getattr) (struct path *path);
 	void (*inode_delete) (struct inode *inode);
 	int (*inode_setxattr) (struct dentry *dentry, const char *name,
 			       const void *value, size_t size, int flags);
@@ -1642,7 +1641,7 @@ int security_inode_readlink(struct dentr
 int security_inode_follow_link(struct dentry *dentry, struct nameidata *nd);
 int security_inode_permission(struct inode *inode, int mask);
 int security_inode_setattr(struct dentry *dentry, struct iattr *attr);
-int security_inode_getattr(struct vfsmount *mnt, struct dentry *dentry);
+int security_inode_getattr(struct path *path);
 void security_inode_delete(struct inode *inode);
 int security_inode_setxattr(struct dentry *dentry, const char *name,
 			    const void *value, size_t size, int flags);
@@ -2042,8 +2041,7 @@ static inline int security_inode_setattr
 	return 0;
 }
 
-static inline int security_inode_getattr(struct vfsmount *mnt,
-					  struct dentry *dentry)
+static inline int security_inode_getattr(struct path *path)
 {
 	return 0;
 }
Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/security/dummy.c	2008-05-29 12:46:25.000000000 +0200
@@ -355,7 +355,7 @@ static int dummy_inode_setattr (struct d
 	return 0;
 }
 
-static int dummy_inode_getattr (struct vfsmount *mnt, struct dentry *dentry)
+static int dummy_inode_getattr(struct path *path)
 {
 	return 0;
 }
Index: linux-2.6/security/security.c
===================================================================
--- linux-2.6.orig/security/security.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/security/security.c	2008-05-29 12:46:25.000000000 +0200
@@ -478,11 +478,11 @@ int security_inode_setattr(struct dentry
 }
 EXPORT_SYMBOL_GPL(security_inode_setattr);
 
-int security_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
+int security_inode_getattr(struct path *path)
 {
-	if (unlikely(IS_PRIVATE(dentry->d_inode)))
+	if (unlikely(IS_PRIVATE(path->dentry->d_inode)))
 		return 0;
-	return security_ops->inode_getattr(mnt, dentry);
+	return security_ops->inode_getattr(path);
 }
 
 void security_inode_delete(struct inode *inode)
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2008-05-29 12:46:25.000000000 +0200
+++ linux-2.6/security/selinux/hooks.c	2008-05-29 12:46:25.000000000 +0200
@@ -2590,9 +2590,9 @@ static int selinux_inode_setattr(struct 
 	return dentry_has_perm(current, NULL, dentry, FILE__WRITE);
 }
 
-static int selinux_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
+static int selinux_inode_getattr(struct path *path)
 {
-	return dentry_has_perm(current, mnt, dentry, FILE__GETATTR);
+	return dentry_has_perm(current, path->mnt, path->dentry, FILE__GETATTR);
 }
 
 static int selinux_inode_setotherxattr(struct dentry *dentry, const char *name)
Index: linux-2.6/security/smack/smack_lsm.c
===================================================================
--- linux-2.6.orig/security/smack/smack_lsm.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/security/smack/smack_lsm.c	2008-05-29 12:46:25.000000000 +0200
@@ -552,14 +552,13 @@ static int smack_inode_setattr(struct de
 
 /**
  * smack_inode_getattr - Smack check for getting attributes
- * @mnt: unused
- * @dentry: the object
+ * @path: the object
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
-static int smack_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
+static int smack_inode_getattr(struct path *path)
 {
-	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
+	return smk_curacc(smk_of_inode(path->dentry->d_inode), MAY_READ);
 }
 
 /**

--
