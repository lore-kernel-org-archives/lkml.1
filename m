Return-Path: <linux-kernel-owner+w=401wt.eu-S1030816AbXDPQLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030816AbXDPQLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 12:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030811AbXDPQLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 12:11:54 -0400
Received: from mx1.suse.de ([195.135.220.2]:50126 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030790AbXDPQLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 12:11:52 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Christoph Hellwig <hch@infradead.org>
Subject: [nameidata 1/2] Don't pass NULL nameidata to vfs_create
Date: Mon, 16 Apr 2007 18:11:30 +0200
User-Agent: KMail/1.9.5
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Tony Jones <tonyj@suse.de>
References: <20070412090809.917795000@suse.de> <20070412090836.207973000@suse.de> <20070412100628.GA25078@infradead.org>
In-Reply-To: <20070412100628.GA25078@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704161811.30364.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 April 2007 12:06, Christoph Hellwig wrote:
> Once again very strong NACK.  Every conditional passing of vfsmounts get my
> veto.  As mentioned last time if you really want this send a patch series
> first that passed the vfsmount consistantly.

I don't consider it fair to NACK this patch just because some other part of 
the kernel uses vfs_create() in the wrong way -- those are really independent 
issues. The bug is not that hard to fix though; here is a proposed patch on 
top of the other AppArmor patches.

The offenders are nfsd and the mqueue filesystem. Instantiate a struct 
nameidata there.

The .dentry and .mnt fields can easily be filled in in nfsd. The mqueue 
filesystem is somewhat special: files that mq_open creates are on an internal 
mount and the mqueue filesystem is not generally visible (it may or may not 
be mounted). When passing a regular vfsmount to vfs_create the files would 
appear disconnected while they actually are kernel-internal objects. Use a 
NULL vfsmount there to avoid that -- passing the kernel-internal vfsmount 
there wouldn't help, anyway.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

---
 fs/namei.c    |    7 ++++---
 fs/nfsd/vfs.c |   23 +++++++++++++++++++----
 ipc/mqueue.c  |    6 +++++-
 3 files changed, 28 insertions(+), 8 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1503,7 +1503,7 @@ int vfs_create(struct inode *dir, struct
 		return -EACCES;	/* shouldn't it be ENOSYS? */
 	mode &= S_IALLUGO;
 	mode |= S_IFREG;
-	error = security_inode_create(dir, dentry, nd ? nd->mnt : NULL, mode);
+	error = security_inode_create(dir, dentry, nd->mnt, mode);
 	if (error)
 		return error;
 	DQUOT_INIT(dir);
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1108,6 +1108,18 @@ nfsd_commit(struct svc_rqst *rqstp, stru
 }
 #endif /* CONFIG_NFSD_V3 */
 
+static inline int
+nfsd_do_create(struct inode *dir, struct dentry *child, struct vfsmount *mnt,
+	       int mode)
+{
+	struct nameidata nd = {
+		.dentry = child,
+		.mnt = mnt,
+	};
+
+	return vfs_create(dir, child, mode, &nd);
+}
+
 /*
  * Create a file (regular, directory, device, fifo); UNIX sockets 
  * not yet implemented.
@@ -1192,7 +1204,8 @@ nfsd_create(struct svc_rqst *rqstp, stru
 	err = 0;
 	switch (type) {
 	case S_IFREG:
-		host_err = vfs_create(dirp, dchild, iap->ia_mode, NULL);
+		host_err = nfsd_do_create(dirp, dchild, exp->ex_mnt,
+					  iap->ia_mode);
 		break;
 	case S_IFDIR:
 		host_err = vfs_mkdir(dirp, dchild, exp->ex_mnt, iap->ia_mode);
@@ -1253,6 +1266,7 @@ nfsd_create_v3(struct svc_rqst *rqstp, s
 	        int *truncp, int *created)
 {
 	struct dentry	*dentry, *dchild = NULL;
+	struct svc_export *exp;
 	struct inode	*dirp;
 	__be32		err;
 	int		host_err;
@@ -1271,6 +1285,7 @@ nfsd_create_v3(struct svc_rqst *rqstp, s
 		goto out;
 
 	dentry = fhp->fh_dentry;
+	exp = fhp->fh_export;
 	dirp = dentry->d_inode;
 
 	/* Get all the sanity checks out of the way before
@@ -1288,7 +1303,7 @@ nfsd_create_v3(struct svc_rqst *rqstp, s
 	if (IS_ERR(dchild))
 		goto out_nfserr;
 
-	err = fh_compose(resfhp, fhp->fh_export, dchild, fhp);
+	err = fh_compose(resfhp, exp, dchild, fhp);
 	if (err)
 		goto out;
 
@@ -1334,13 +1349,13 @@ nfsd_create_v3(struct svc_rqst *rqstp, s
 		goto out;
 	}
 
-	host_err = vfs_create(dirp, dchild, iap->ia_mode, NULL);
+	host_err = nfsd_do_create(dirp, dchild, exp->ex_mnt, iap->ia_mode);
 	if (host_err < 0)
 		goto out_nfserr;
 	if (created)
 		*created = 1;
 
-	if (EX_ISSYNC(fhp->fh_export)) {
+	if (EX_ISSYNC(exp)) {
 		err = nfserrno(nfsd_sync_dir(dentry));
 		/* setattr will sync the child (or not) */
 	}
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -604,6 +604,10 @@ static int mq_attr_ok(struct mq_attr *at
 static struct file *do_create(struct dentry *dir, struct dentry *dentry,
 			int oflag, mode_t mode, struct mq_attr __user *u_attr)
 {
+	struct nameidata nd = {
+		.dentry = dentry,
+		/* Not a regular create, so set .mnt to NULL. */
+	};
 	struct mq_attr attr;
 	int ret;
 
@@ -619,7 +623,7 @@ static struct file *do_create(struct den
 	}
 
 	mode &= ~current->fs->umask;
-	ret = vfs_create(dir->d_inode, dentry, mode, NULL);
+	ret = vfs_create(dir->d_inode, dentry, mode, &nd);
 	dentry->d_fsdata = NULL;
 	if (ret)
 		goto out;
