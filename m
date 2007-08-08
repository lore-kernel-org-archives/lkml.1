Return-Path: <linux-kernel-owner+w=401wt.eu-S937629AbXHHRWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937629AbXHHRWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937340AbXHHRTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:19:16 -0400
Received: from mx1.suse.de ([195.135.220.2]:38769 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935248AbXHHRTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:19:04 -0400
Message-Id: <20070808171644.407320917@suse.de>
References: <20070808171622.632749741@suse.de>
User-Agent: quilt/0.46-1
Date: Wed, 08 Aug 2007 19:16:30 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: linux-kernel@vger.kernel.org
Cc: John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [RFC 08/10] Pass no NULL vfs_lookup to vfs_create
Content-Disposition: inline; filename=vfs_create-nameidata.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Never pass a NULL vfs_lookup to vfs_create() or iop->create by creating
temporary vfs_lookup objects where needed. Remove the obsolete NULL
checks.

Signed-off-by: Andreas Gruenbacher <ag@bestbits.at>

---
 fs/9p/vfs_inode.c |    4 ++--
 fs/cifs/dir.c     |    5 ++---
 fs/nfsd/vfs.c     |   36 +++++++++++++++++++++---------------
 ipc/mqueue.c      |   23 ++++++++++++++---------
 4 files changed, 39 insertions(+), 29 deletions(-)

--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -478,7 +478,7 @@ v9fs_vfs_create(struct inode *dir, struc
 	fid = NULL;
 	v9ses = v9fs_inode2v9ses(dir);
 	perm = unixmode2p9mode(v9ses, mode);
-	if (lookup && lookup->flags & LOOKUP_OPEN)
+	if (lookup->flags & LOOKUP_OPEN)
 		flags = lookup->intent.open.flags - 1;
 	else
 		flags = O_RDWR;
@@ -492,7 +492,7 @@ v9fs_vfs_create(struct inode *dir, struc
 	}
 
 	/* if we are opening a file, assign the open fid to the file */
-	if (lookup && lookup->flags & LOOKUP_OPEN) {
+	if (lookup->flags & LOOKUP_OPEN) {
 		filp = lookup_instantiate_filp(lookup, dentry,
 					       v9fs_open_created);
 		if (IS_ERR(filp)) {
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -153,7 +153,7 @@ cifs_create(struct inode *inode, struct 
 		return -ENOMEM;
 	}
 
-	if (lookup && (lookup->flags & LOOKUP_OPEN)) {
+	if (lookup->flags & LOOKUP_OPEN) {
 		int oflags = lookup->intent.open.flags;
 
 		desiredAccess = 0;
@@ -263,8 +263,7 @@ cifs_create(struct inode *inode, struct 
 				direntry->d_op = &cifs_dentry_ops;
 			d_instantiate(direntry, newinode);
 		}
-		if ((!lookup /* nfsd case - nfs srv does not set lookup */) ||
-			((lookup->flags & LOOKUP_OPEN) == FALSE)) {
+		if (!(lookup->flags & LOOKUP_OPEN)) {
 			/* mknod case - do not leave file open */
 			CIFSSMBClose(xid, pTcon, fileHandle);
 		} else if (newinode) {
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1139,7 +1139,8 @@ nfsd_create(struct svc_rqst *rqstp, stru
 		char *fname, int flen, struct iattr *iap,
 		int type, dev_t rdev, struct svc_fh *resfhp)
 {
-	struct dentry	*dentry, *dchild = NULL;
+	struct vfs_lookup lookup;
+	struct dentry	*dchild = NULL;
 	struct inode	*dirp;
 	__be32		err;
 	int		host_err;
@@ -1155,8 +1156,10 @@ nfsd_create(struct svc_rqst *rqstp, stru
 	if (err)
 		goto out;
 
-	dentry = fhp->fh_dentry;
-	dirp = dentry->d_inode;
+	lookup.path.dentry = fhp->fh_dentry;
+	lookup.path.mnt = fhp->fh_export->ex_mnt;
+	lookup.flags = 0;
+	dirp = lookup.path.dentry->d_inode;
 
 	err = nfserr_notdir;
 	if(!dirp->i_op || !dirp->i_op->lookup)
@@ -1168,7 +1171,7 @@ nfsd_create(struct svc_rqst *rqstp, stru
 	if (!resfhp->fh_dentry) {
 		/* called from nfsd_proc_mkdir, or possibly nfsd3_proc_create */
 		fh_lock_nested(fhp, I_MUTEX_PARENT);
-		dchild = lookup_one_len(fname, dentry, flen);
+		dchild = lookup_one_len(fname, lookup.path.dentry, flen);
 		host_err = PTR_ERR(dchild);
 		if (IS_ERR(dchild))
 			goto out_nfserr;
@@ -1182,8 +1185,8 @@ nfsd_create(struct svc_rqst *rqstp, stru
 			/* not actually possible */
 			printk(KERN_ERR
 				"nfsd_create: parent %s/%s not locked!\n",
-				dentry->d_parent->d_name.name,
-				dentry->d_name.name);
+				lookup.path.dentry->d_parent->d_name.name,
+				lookup.path.dentry->d_name.name);
 			err = nfserr_io;
 			goto out;
 		}
@@ -1194,7 +1197,7 @@ nfsd_create(struct svc_rqst *rqstp, stru
 	err = nfserr_exist;
 	if (dchild->d_inode) {
 		dprintk("nfsd_create: dentry %s/%s not negative!\n",
-			dentry->d_name.name, dchild->d_name.name);
+			lookup.path.dentry->d_name.name, dchild->d_name.name);
 		goto out; 
 	}
 
@@ -1208,7 +1211,7 @@ nfsd_create(struct svc_rqst *rqstp, stru
 	err = 0;
 	switch (type) {
 	case S_IFREG:
-		host_err = vfs_create(dirp, dchild, iap->ia_mode, NULL);
+		host_err = vfs_create(dirp, dchild, iap->ia_mode, &lookup);
 		break;
 	case S_IFDIR:
 		host_err = vfs_mkdir(dirp, dchild, iap->ia_mode);
@@ -1227,7 +1230,7 @@ nfsd_create(struct svc_rqst *rqstp, stru
 		goto out_nfserr;
 
 	if (EX_ISSYNC(fhp->fh_export)) {
-		err = nfserrno(nfsd_sync_dir(dentry));
+		err = nfserrno(nfsd_sync_dir(lookup.path.dentry));
 		write_inode_now(dchild->d_inode, 1);
 	}
 
@@ -1267,7 +1270,8 @@ nfsd_create_v3(struct svc_rqst *rqstp, s
 		struct svc_fh *resfhp, int createmode, u32 *verifier,
 	        int *truncp, int *created)
 {
-	struct dentry	*dentry, *dchild = NULL;
+	struct vfs_lookup lookup;
+	struct dentry	*dchild = NULL;
 	struct inode	*dirp;
 	__be32		err;
 	int		host_err;
@@ -1285,8 +1289,10 @@ nfsd_create_v3(struct svc_rqst *rqstp, s
 	if (err)
 		goto out;
 
-	dentry = fhp->fh_dentry;
-	dirp = dentry->d_inode;
+	lookup.path.dentry = fhp->fh_dentry;
+	lookup.path.mnt = fhp->fh_export->ex_mnt;
+	lookup.flags = 0;
+	dirp = lookup.path.dentry->d_inode;
 
 	/* Get all the sanity checks out of the way before
 	 * we lock the parent. */
@@ -1298,7 +1304,7 @@ nfsd_create_v3(struct svc_rqst *rqstp, s
 	/*
 	 * Compose the response file handle.
 	 */
-	dchild = lookup_one_len(fname, dentry, flen);
+	dchild = lookup_one_len(fname, lookup.path.dentry, flen);
 	host_err = PTR_ERR(dchild);
 	if (IS_ERR(dchild))
 		goto out_nfserr;
@@ -1352,14 +1358,14 @@ nfsd_create_v3(struct svc_rqst *rqstp, s
 		goto out;
 	}
 
-	host_err = vfs_create(dirp, dchild, iap->ia_mode, NULL);
+	host_err = vfs_create(dirp, dchild, iap->ia_mode, &lookup);
 	if (host_err < 0)
 		goto out_nfserr;
 	if (created)
 		*created = 1;
 
 	if (EX_ISSYNC(fhp->fh_export)) {
-		err = nfserrno(nfsd_sync_dir(dentry));
+		err = nfserrno(nfsd_sync_dir(lookup.path.dentry));
 		/* setattr will sync the child (or not) */
 	}
 
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -599,9 +599,11 @@ static int mq_attr_ok(struct mq_attr *at
 /*
  * Invoked when creating a new queue via sys_mq_open
  */
-static struct file *do_create(struct dentry *dir, struct dentry *dentry,
-			int oflag, mode_t mode, struct mq_attr __user *u_attr)
+static struct file *do_create(struct vfs_lookup *lookup, int oflag, mode_t mode,
+			      struct mq_attr __user *u_attr)
 {
+	struct dentry *dir = mqueue_mnt->mnt_root;
+	struct dentry *dentry = lookup->path.dentry;
 	struct mq_attr attr;
 	int ret;
 
@@ -617,7 +619,7 @@ static struct file *do_create(struct den
 	}
 
 	mode &= ~current->fs->umask;
-	ret = vfs_create(dir->d_inode, dentry, mode, NULL);
+	ret = vfs_create(dir->d_inode, dentry, mode, lookup);
 	dentry->d_fsdata = NULL;
 	if (ret)
 		goto out;
@@ -631,10 +633,11 @@ out:
 }
 
 /* Opens existing queue */
-static struct file *do_open(struct dentry *dentry, int oflag)
+static struct file *do_open(struct vfs_lookup *lookup, int oflag)
 {
 static int oflag2acc[O_ACCMODE] = { MAY_READ, MAY_WRITE,
 					MAY_READ | MAY_WRITE };
+	struct dentry *dentry = lookup->path.dentry;
 
 	if ((oflag & O_ACCMODE) == (O_RDWR | O_WRONLY)) {
 		dput(dentry);
@@ -654,6 +657,7 @@ static int oflag2acc[O_ACCMODE] = { MAY_
 asmlinkage long sys_mq_open(const char __user *u_name, int oflag, mode_t mode,
 				struct mq_attr __user *u_attr)
 {
+	struct vfs_lookup lookup;
 	struct dentry *dentry;
 	struct file *filp;
 	char *name;
@@ -676,7 +680,9 @@ asmlinkage long sys_mq_open(const char _
 		error = PTR_ERR(dentry);
 		goto out_err;
 	}
-	mntget(mqueue_mnt);
+	lookup.path.mnt = mntget(mqueue_mnt);
+	lookup.path.dentry = dentry;
+	lookup.flags = 0;
 
 	if (oflag & O_CREAT) {
 		if (dentry->d_inode) {	/* entry already exists */
@@ -684,17 +690,16 @@ asmlinkage long sys_mq_open(const char _
 			error = -EEXIST;
 			if (oflag & O_EXCL)
 				goto out;
-			filp = do_open(dentry, oflag);
+			filp = do_open(&lookup, oflag);
 		} else {
-			filp = do_create(mqueue_mnt->mnt_root, dentry,
-						oflag, mode, u_attr);
+			filp = do_create(&lookup, oflag, mode, u_attr);
 		}
 	} else {
 		error = -ENOENT;
 		if (!dentry->d_inode)
 			goto out;
 		audit_inode(name, dentry->d_inode);
-		filp = do_open(dentry, oflag);
+		filp = do_open(&lookup, oflag);
 	}
 
 	if (IS_ERR(filp)) {

