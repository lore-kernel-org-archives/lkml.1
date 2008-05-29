Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbYE2Le6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbYE2Le6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 07:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYE2Ld2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 07:33:28 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56700 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbYE2LdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 07:33:21 -0400
Message-Id: <20080529113312.288347247@szeredi.hu>
References: <20080529113245.450308367@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 13:32:49 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@citi.umich.edu>, NeilBrown <neilb@suse.de>
Subject: [patch 4/8] nfsd: rename MAY_ flags
Content-Disposition: inline; filename=nfs_may_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Rename nfsd specific MAY_* flags to NFSD_MAY_* to make it clear, that
these are not used outside nfsd, and to avoid namespace conflicts with
the VFS.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: J. Bruce Fields <bfields@citi.umich.edu>
CC: NeilBrown <neilb@suse.de>
---
 fs/nfsd/lockd.c           |    2 -
 fs/nfsd/nfs2acl.c         |    7 ++--
 fs/nfsd/nfs3acl.c         |    5 +--
 fs/nfsd/nfs3proc.c        |    8 ++---
 fs/nfsd/nfs4proc.c        |   19 +++++++-----
 fs/nfsd/nfs4state.c       |    2 -
 fs/nfsd/nfsfh.c           |    2 -
 fs/nfsd/nfsproc.c         |    4 +-
 fs/nfsd/vfs.c             |   71 +++++++++++++++++++++++-----------------------
 include/linux/nfsd/nfsd.h |   20 ++++++------
 10 files changed, 73 insertions(+), 67 deletions(-)

Index: linux-2.6/fs/nfsd/nfs2acl.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfs2acl.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/fs/nfsd/nfs2acl.c	2008-05-29 12:46:23.000000000 +0200
@@ -40,7 +40,8 @@ static __be32 nfsacld_proc_getacl(struct
 	dprintk("nfsd: GETACL(2acl)   %s\n", SVCFH_fmt(&argp->fh));
 
 	fh = fh_copy(&resp->fh, &argp->fh);
-	if ((nfserr = fh_verify(rqstp, &resp->fh, 0, MAY_NOP)))
+	nfserr = fh_verify(rqstp, &resp->fh, 0, NFSD_MAY_NOP);
+	if (nfserr)
 		RETURN_STATUS(nfserr);
 
 	if (argp->mask & ~(NFS_ACL|NFS_ACLCNT|NFS_DFACL|NFS_DFACLCNT))
@@ -107,7 +108,7 @@ static __be32 nfsacld_proc_setacl(struct
 	dprintk("nfsd: SETACL(2acl)   %s\n", SVCFH_fmt(&argp->fh));
 
 	fh = fh_copy(&resp->fh, &argp->fh);
-	nfserr = fh_verify(rqstp, &resp->fh, 0, MAY_SATTR);
+	nfserr = fh_verify(rqstp, &resp->fh, 0, NFSD_MAY_SATTR);
 
 	if (!nfserr) {
 		nfserr = nfserrno( nfsd_set_posix_acl(
@@ -134,7 +135,7 @@ static __be32 nfsacld_proc_getattr(struc
 	dprintk("nfsd: GETATTR  %s\n", SVCFH_fmt(&argp->fh));
 
 	fh_copy(&resp->fh, &argp->fh);
-	return fh_verify(rqstp, &resp->fh, 0, MAY_NOP);
+	return fh_verify(rqstp, &resp->fh, 0, NFSD_MAY_NOP);
 }
 
 /*
Index: linux-2.6/fs/nfsd/nfs3acl.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfs3acl.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/fs/nfsd/nfs3acl.c	2008-05-29 12:46:23.000000000 +0200
@@ -36,7 +36,8 @@ static __be32 nfsd3_proc_getacl(struct s
 	__be32 nfserr = 0;
 
 	fh = fh_copy(&resp->fh, &argp->fh);
-	if ((nfserr = fh_verify(rqstp, &resp->fh, 0, MAY_NOP)))
+	nfserr = fh_verify(rqstp, &resp->fh, 0, NFSD_MAY_NOP);
+	if (nfserr)
 		RETURN_STATUS(nfserr);
 
 	if (argp->mask & ~(NFS_ACL|NFS_ACLCNT|NFS_DFACL|NFS_DFACLCNT))
@@ -101,7 +102,7 @@ static __be32 nfsd3_proc_setacl(struct s
 	__be32 nfserr = 0;
 
 	fh = fh_copy(&resp->fh, &argp->fh);
-	nfserr = fh_verify(rqstp, &resp->fh, 0, MAY_SATTR);
+	nfserr = fh_verify(rqstp, &resp->fh, 0, NFSD_MAY_SATTR);
 
 	if (!nfserr) {
 		nfserr = nfserrno( nfsd_set_posix_acl(
Index: linux-2.6/fs/nfsd/nfs3proc.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfs3proc.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/fs/nfsd/nfs3proc.c	2008-05-29 12:46:23.000000000 +0200
@@ -63,7 +63,7 @@ nfsd3_proc_getattr(struct svc_rqst *rqst
 		SVCFH_fmt(&argp->fh));
 
 	fh_copy(&resp->fh, &argp->fh);
-	nfserr = fh_verify(rqstp, &resp->fh, 0, MAY_NOP);
+	nfserr = fh_verify(rqstp, &resp->fh, 0, NFSD_MAY_NOP);
 	if (nfserr)
 		RETURN_STATUS(nfserr);
 
@@ -242,7 +242,7 @@ nfsd3_proc_create(struct svc_rqst *rqstp
 	attr   = &argp->attrs;
 
 	/* Get the directory inode */
-	nfserr = fh_verify(rqstp, dirfhp, S_IFDIR, MAY_CREATE);
+	nfserr = fh_verify(rqstp, dirfhp, S_IFDIR, NFSD_MAY_CREATE);
 	if (nfserr)
 		RETURN_STATUS(nfserr);
 
@@ -558,7 +558,7 @@ nfsd3_proc_fsinfo(struct svc_rqst * rqst
 	resp->f_maxfilesize = ~(u32) 0;
 	resp->f_properties = NFS3_FSF_DEFAULT;
 
-	nfserr = fh_verify(rqstp, &argp->fh, 0, MAY_NOP);
+	nfserr = fh_verify(rqstp, &argp->fh, 0, NFSD_MAY_NOP);
 
 	/* Check special features of the file system. May request
 	 * different read/write sizes for file systems known to have
@@ -597,7 +597,7 @@ nfsd3_proc_pathconf(struct svc_rqst * rq
 	resp->p_case_insensitive = 0;
 	resp->p_case_preserving = 1;
 
-	nfserr = fh_verify(rqstp, &argp->fh, 0, MAY_NOP);
+	nfserr = fh_verify(rqstp, &argp->fh, 0, NFSD_MAY_NOP);
 
 	if (nfserr == 0) {
 		struct super_block *sb = argp->fh.fh_dentry->d_inode->i_sb;
Index: linux-2.6/fs/nfsd/nfs4proc.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfs4proc.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/fs/nfsd/nfs4proc.c	2008-05-29 12:46:23.000000000 +0200
@@ -73,7 +73,7 @@ do_open_permission(struct svc_rqst *rqst
 	if (open->op_share_access & NFS4_SHARE_ACCESS_READ)
 		accmode |= MAY_READ;
 	if (open->op_share_access & NFS4_SHARE_ACCESS_WRITE)
-		accmode |= (MAY_WRITE | MAY_TRUNC);
+		accmode |= (MAY_WRITE | NFSD_MAY_TRUNC);
 	if (open->op_share_deny & NFS4_SHARE_DENY_WRITE)
 		accmode |= MAY_WRITE;
 
@@ -126,7 +126,8 @@ do_open_lookup(struct svc_rqst *rqstp, s
 			&resfh.fh_handle.fh_base, resfh.fh_handle.fh_size);
 
 	if (!created)
-		status = do_open_permission(rqstp, current_fh, open, MAY_NOP);
+		status = do_open_permission(rqstp, current_fh, open,
+					    NFSD_MAY_NOP);
 
 out:
 	fh_put(&resfh);
@@ -157,7 +158,8 @@ do_open_fhandle(struct svc_rqst *rqstp, 
 	open->op_truncate = (open->op_iattr.ia_valid & ATTR_SIZE) &&
 		(open->op_iattr.ia_size == 0);
 
-	status = do_open_permission(rqstp, current_fh, open, MAY_OWNER_OVERRIDE);
+	status = do_open_permission(rqstp, current_fh, open,
+				    NFSD_MAY_OWNER_OVERRIDE);
 
 	return status;
 }
@@ -186,7 +188,7 @@ nfsd4_open(struct svc_rqst *rqstp, struc
 		cstate->current_fh.fh_handle.fh_size = rp->rp_openfh_len;
 		memcpy(&cstate->current_fh.fh_handle.fh_base, rp->rp_openfh,
 				rp->rp_openfh_len);
-		status = fh_verify(rqstp, &cstate->current_fh, 0, MAY_NOP);
+		status = fh_verify(rqstp, &cstate->current_fh, 0, NFSD_MAY_NOP);
 		if (status)
 			dprintk("nfsd4_open: replay failed"
 				" restoring previous filehandle\n");
@@ -285,7 +287,7 @@ nfsd4_putfh(struct svc_rqst *rqstp, stru
 	cstate->current_fh.fh_handle.fh_size = putfh->pf_fhlen;
 	memcpy(&cstate->current_fh.fh_handle.fh_base, putfh->pf_fhval,
 	       putfh->pf_fhlen);
-	return fh_verify(rqstp, &cstate->current_fh, 0, MAY_NOP);
+	return fh_verify(rqstp, &cstate->current_fh, 0, NFSD_MAY_NOP);
 }
 
 static __be32
@@ -363,7 +365,8 @@ nfsd4_create(struct svc_rqst *rqstp, str
 
 	fh_init(&resfh, NFS4_FHSIZE);
 
-	status = fh_verify(rqstp, &cstate->current_fh, S_IFDIR, MAY_CREATE);
+	status = fh_verify(rqstp, &cstate->current_fh, S_IFDIR,
+			   NFSD_MAY_CREATE);
 	if (status == nfserr_symlink)
 		status = nfserr_notdir;
 	if (status)
@@ -445,7 +448,7 @@ nfsd4_getattr(struct svc_rqst *rqstp, st
 {
 	__be32 status;
 
-	status = fh_verify(rqstp, &cstate->current_fh, 0, MAY_NOP);
+	status = fh_verify(rqstp, &cstate->current_fh, 0, NFSD_MAY_NOP);
 	if (status)
 		return status;
 
@@ -730,7 +733,7 @@ _nfsd4_verify(struct svc_rqst *rqstp, st
 	int count;
 	__be32 status;
 
-	status = fh_verify(rqstp, &cstate->current_fh, 0, MAY_NOP);
+	status = fh_verify(rqstp, &cstate->current_fh, 0, NFSD_MAY_NOP);
 	if (status)
 		return status;
 
Index: linux-2.6/include/linux/nfsd/nfsd.h
===================================================================
--- linux-2.6.orig/include/linux/nfsd/nfsd.h	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/include/linux/nfsd/nfsd.h	2008-05-29 12:46:23.000000000 +0200
@@ -31,17 +31,17 @@
  * Special flags for nfsd_permission. These must be different from MAY_READ,
  * MAY_WRITE, and MAY_EXEC.
  */
-#define MAY_NOP			0
-#define MAY_SATTR		8
-#define MAY_TRUNC		16
-#define MAY_LOCK		32
-#define MAY_OWNER_OVERRIDE	64
-#define	MAY_LOCAL_ACCESS	128 /* IRIX doing local access check on device special file*/
-#if (MAY_SATTR | MAY_TRUNC | MAY_LOCK | MAY_OWNER_OVERRIDE | MAY_LOCAL_ACCESS) & (MAY_READ | MAY_WRITE | MAY_EXEC)
-# error "please use a different value for MAY_SATTR or MAY_TRUNC or MAY_LOCK or MAY_LOCAL_ACCESS or MAY_OWNER_OVERRIDE."
+#define NFSD_MAY_NOP			0
+#define NFSD_MAY_SATTR		8
+#define NFSD_MAY_TRUNC		16
+#define NFSD_MAY_LOCK		32
+#define NFSD_MAY_OWNER_OVERRIDE	64
+#define	NFSD_MAY_LOCAL_ACCESS	128 /* IRIX doing local access check on device special file*/
+#if (NFSD_MAY_SATTR | NFSD_MAY_TRUNC | NFSD_MAY_LOCK | NFSD_MAY_OWNER_OVERRIDE | NFSD_MAY_LOCAL_ACCESS) & (MAY_READ | MAY_WRITE | MAY_EXEC)
+# error "please use a different value for NFSD_MAY_SATTR or NFSD_MAY_TRUNC or NFSD_MAY_LOCK or NFSD_MAY_LOCAL_ACCESS or NFSD_MAY_OWNER_OVERRIDE."
 #endif
-#define MAY_CREATE		(MAY_EXEC|MAY_WRITE)
-#define MAY_REMOVE		(MAY_EXEC|MAY_WRITE|MAY_TRUNC)
+#define NFSD_MAY_CREATE		(MAY_EXEC|MAY_WRITE)
+#define NFSD_MAY_REMOVE		(MAY_EXEC|MAY_WRITE|NFSD_MAY_TRUNC)
 
 /*
  * Callback function for readdir
Index: linux-2.6/fs/nfsd/lockd.c
===================================================================
--- linux-2.6.orig/fs/nfsd/lockd.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/fs/nfsd/lockd.c	2008-05-29 12:46:23.000000000 +0200
@@ -35,7 +35,7 @@ nlm_fopen(struct svc_rqst *rqstp, struct
 	fh.fh_export = NULL;
 
 	exp_readlock();
-	nfserr = nfsd_open(rqstp, &fh, S_IFREG, MAY_LOCK, filp);
+	nfserr = nfsd_open(rqstp, &fh, S_IFREG, NFSD_MAY_LOCK, filp);
 	fh_put(&fh);
 	rqstp->rq_client = NULL;
 	exp_readunlock();
Index: linux-2.6/fs/nfsd/nfs4state.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfs4state.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/fs/nfsd/nfs4state.c	2008-05-29 12:46:23.000000000 +0200
@@ -2610,7 +2610,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 		 return nfserr_inval;
 
 	if ((status = fh_verify(rqstp, &cstate->current_fh,
-				S_IFREG, MAY_LOCK))) {
+				S_IFREG, NFSD_MAY_LOCK))) {
 		dprintk("NFSD: nfsd4_lock: permission denied!\n");
 		return status;
 	}
Index: linux-2.6/fs/nfsd/nfsfh.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfsfh.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/fs/nfsd/nfsfh.c	2008-05-29 12:46:23.000000000 +0200
@@ -280,7 +280,7 @@ fh_verify(struct svc_rqst *rqstp, struct
 	if (error)
 		goto out;
 
-	if (!(access & MAY_LOCK)) {
+	if (!(access & NFSD_MAY_LOCK)) {
 		/*
 		 * pseudoflavor restrictions are not enforced on NLM,
 		 * which clients virtually always use auth_sys for,
Index: linux-2.6/fs/nfsd/nfsproc.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfsproc.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/fs/nfsd/nfsproc.c	2008-05-29 12:46:23.000000000 +0200
@@ -65,7 +65,7 @@ nfsd_proc_getattr(struct svc_rqst *rqstp
 	dprintk("nfsd: GETATTR  %s\n", SVCFH_fmt(&argp->fh));
 
 	fh_copy(&resp->fh, &argp->fh);
-	nfserr = fh_verify(rqstp, &resp->fh, 0, MAY_NOP);
+	nfserr = fh_verify(rqstp, &resp->fh, 0, NFSD_MAY_NOP);
 	return nfsd_return_attrs(nfserr, resp);
 }
 
@@ -281,7 +281,7 @@ nfsd_proc_create(struct svc_rqst *rqstp,
 					nfserr = nfsd_permission(rqstp,
 								 newfhp->fh_export,
 								 newfhp->fh_dentry,
-								 MAY_WRITE|MAY_LOCAL_ACCESS);
+								 MAY_WRITE|NFSD_MAY_LOCAL_ACCESS);
 					if (nfserr && nfserr != nfserr_rofs)
 						goto out_unlock;
 				}
Index: linux-2.6/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.orig/fs/nfsd/vfs.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/fs/nfsd/vfs.c	2008-05-29 12:46:23.000000000 +0200
@@ -268,14 +268,14 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 {
 	struct dentry	*dentry;
 	struct inode	*inode;
-	int		accmode = MAY_SATTR;
+	int		accmode = NFSD_MAY_SATTR;
 	int		ftype = 0;
 	__be32		err;
 	int		host_err;
 	int		size_change = 0;
 
 	if (iap->ia_valid & (ATTR_ATIME | ATTR_MTIME | ATTR_SIZE))
-		accmode |= MAY_WRITE|MAY_OWNER_OVERRIDE;
+		accmode |= MAY_WRITE|NFSD_MAY_OWNER_OVERRIDE;
 	if (iap->ia_valid & ATTR_SIZE)
 		ftype = S_IFREG;
 
@@ -337,7 +337,8 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 	 */
 	if (iap->ia_valid & ATTR_SIZE) {
 		if (iap->ia_size < inode->i_size) {
-			err = nfsd_permission(rqstp, fhp->fh_export, dentry, MAY_TRUNC|MAY_OWNER_OVERRIDE);
+			err = nfsd_permission(rqstp, fhp->fh_export, dentry,
+					NFSD_MAY_TRUNC|NFSD_MAY_OWNER_OVERRIDE);
 			if (err)
 				goto out;
 		}
@@ -471,7 +472,7 @@ nfsd4_set_nfs4_acl(struct svc_rqst *rqst
 	unsigned int flags = 0;
 
 	/* Get inode */
-	error = fh_verify(rqstp, fhp, 0 /* S_IFREG */, MAY_SATTR);
+	error = fh_verify(rqstp, fhp, 0 /* S_IFREG */, NFSD_MAY_SATTR);
 	if (error)
 		return error;
 
@@ -579,7 +580,7 @@ struct accessmap {
 static struct accessmap	nfs3_regaccess[] = {
     {	NFS3_ACCESS_READ,	MAY_READ			},
     {	NFS3_ACCESS_EXECUTE,	MAY_EXEC			},
-    {	NFS3_ACCESS_MODIFY,	MAY_WRITE|MAY_TRUNC		},
+    {	NFS3_ACCESS_MODIFY,	MAY_WRITE|NFSD_MAY_TRUNC	},
     {	NFS3_ACCESS_EXTEND,	MAY_WRITE			},
 
     {	0,			0				}
@@ -588,9 +589,9 @@ static struct accessmap	nfs3_regaccess[]
 static struct accessmap	nfs3_diraccess[] = {
     {	NFS3_ACCESS_READ,	MAY_READ			},
     {	NFS3_ACCESS_LOOKUP,	MAY_EXEC			},
-    {	NFS3_ACCESS_MODIFY,	MAY_EXEC|MAY_WRITE|MAY_TRUNC	},
+    {	NFS3_ACCESS_MODIFY,	MAY_EXEC|MAY_WRITE|NFSD_MAY_TRUNC},
     {	NFS3_ACCESS_EXTEND,	MAY_EXEC|MAY_WRITE		},
-    {	NFS3_ACCESS_DELETE,	MAY_REMOVE			},
+    {	NFS3_ACCESS_DELETE,	NFSD_MAY_REMOVE			},
 
     {	0,			0				}
 };
@@ -605,8 +606,8 @@ static struct accessmap	nfs3_anyaccess[]
 	 */
     {	NFS3_ACCESS_READ,	MAY_READ			},
     {	NFS3_ACCESS_EXECUTE,	MAY_EXEC			},
-    {	NFS3_ACCESS_MODIFY,	MAY_WRITE|MAY_LOCAL_ACCESS	},
-    {	NFS3_ACCESS_EXTEND,	MAY_WRITE|MAY_LOCAL_ACCESS	},
+    {	NFS3_ACCESS_MODIFY,	MAY_WRITE|NFSD_MAY_LOCAL_ACCESS	},
+    {	NFS3_ACCESS_EXTEND,	MAY_WRITE|NFSD_MAY_LOCAL_ACCESS	},
 
     {	0,			0				}
 };
@@ -620,7 +621,7 @@ nfsd_access(struct svc_rqst *rqstp, stru
 	u32			query, result = 0, sresult = 0;
 	__be32			error;
 
-	error = fh_verify(rqstp, fhp, 0, MAY_NOP);
+	error = fh_verify(rqstp, fhp, 0, NFSD_MAY_NOP);
 	if (error)
 		goto out;
 
@@ -692,7 +693,7 @@ nfsd_open(struct svc_rqst *rqstp, struct
 	 * and (hopefully) checked permission - so allow OWNER_OVERRIDE
 	 * in case a chmod has now revoked permission.
 	 */
-	err = fh_verify(rqstp, fhp, type, access | MAY_OWNER_OVERRIDE);
+	err = fh_verify(rqstp, fhp, type, access | NFSD_MAY_OWNER_OVERRIDE);
 	if (err)
 		goto out;
 
@@ -1085,7 +1086,7 @@ nfsd_read(struct svc_rqst *rqstp, struct
 
 	if (file) {
 		err = nfsd_permission(rqstp, fhp->fh_export, fhp->fh_dentry,
-				MAY_READ|MAY_OWNER_OVERRIDE);
+				MAY_READ|NFSD_MAY_OWNER_OVERRIDE);
 		if (err)
 			goto out;
 		err = nfsd_vfs_read(rqstp, fhp, file, offset, vec, vlen, count);
@@ -1114,7 +1115,7 @@ nfsd_write(struct svc_rqst *rqstp, struc
 
 	if (file) {
 		err = nfsd_permission(rqstp, fhp->fh_export, fhp->fh_dentry,
-				MAY_WRITE|MAY_OWNER_OVERRIDE);
+				MAY_WRITE|NFSD_MAY_OWNER_OVERRIDE);
 		if (err)
 			goto out;
 		err = nfsd_vfs_write(rqstp, fhp, file, offset, vec, vlen, cnt,
@@ -1214,7 +1215,7 @@ nfsd_create(struct svc_rqst *rqstp, stru
 	if (isdotent(fname, flen))
 		goto out;
 
-	err = fh_verify(rqstp, fhp, S_IFDIR, MAY_CREATE);
+	err = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_CREATE);
 	if (err)
 		goto out;
 
@@ -1347,7 +1348,7 @@ nfsd_create_v3(struct svc_rqst *rqstp, s
 		goto out;
 	if (!(iap->ia_valid & ATTR_MODE))
 		iap->ia_mode = 0;
-	err = fh_verify(rqstp, fhp, S_IFDIR, MAY_CREATE);
+	err = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_CREATE);
 	if (err)
 		goto out;
 
@@ -1485,7 +1486,7 @@ nfsd_readlink(struct svc_rqst *rqstp, st
 	__be32		err;
 	int		host_err;
 
-	err = fh_verify(rqstp, fhp, S_IFLNK, MAY_NOP);
+	err = fh_verify(rqstp, fhp, S_IFLNK, NFSD_MAY_NOP);
 	if (err)
 		goto out;
 
@@ -1540,7 +1541,7 @@ nfsd_symlink(struct svc_rqst *rqstp, str
 	if (isdotent(fname, flen))
 		goto out;
 
-	err = fh_verify(rqstp, fhp, S_IFDIR, MAY_CREATE);
+	err = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_CREATE);
 	if (err)
 		goto out;
 	fh_lock(fhp);
@@ -1596,10 +1597,10 @@ nfsd_link(struct svc_rqst *rqstp, struct
 	__be32		err;
 	int		host_err;
 
-	err = fh_verify(rqstp, ffhp, S_IFDIR, MAY_CREATE);
+	err = fh_verify(rqstp, ffhp, S_IFDIR, NFSD_MAY_CREATE);
 	if (err)
 		goto out;
-	err = fh_verify(rqstp, tfhp, -S_IFDIR, MAY_NOP);
+	err = fh_verify(rqstp, tfhp, -S_IFDIR, NFSD_MAY_NOP);
 	if (err)
 		goto out;
 
@@ -1660,10 +1661,10 @@ nfsd_rename(struct svc_rqst *rqstp, stru
 	__be32		err;
 	int		host_err;
 
-	err = fh_verify(rqstp, ffhp, S_IFDIR, MAY_REMOVE);
+	err = fh_verify(rqstp, ffhp, S_IFDIR, NFSD_MAY_REMOVE);
 	if (err)
 		goto out;
-	err = fh_verify(rqstp, tfhp, S_IFDIR, MAY_CREATE);
+	err = fh_verify(rqstp, tfhp, S_IFDIR, NFSD_MAY_CREATE);
 	if (err)
 		goto out;
 
@@ -1757,7 +1758,7 @@ nfsd_unlink(struct svc_rqst *rqstp, stru
 	err = nfserr_acces;
 	if (!flen || isdotent(fname, flen))
 		goto out;
-	err = fh_verify(rqstp, fhp, S_IFDIR, MAY_REMOVE);
+	err = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_REMOVE);
 	if (err)
 		goto out;
 
@@ -1858,7 +1859,7 @@ out:
 __be32
 nfsd_statfs(struct svc_rqst *rqstp, struct svc_fh *fhp, struct kstatfs *stat)
 {
-	__be32 err = fh_verify(rqstp, fhp, 0, MAY_NOP);
+	__be32 err = fh_verify(rqstp, fhp, 0, NFSD_MAY_NOP);
 	if (!err && vfs_statfs(fhp->fh_dentry,stat))
 		err = nfserr_io;
 	return err;
@@ -1883,7 +1884,7 @@ nfsd_permission(struct svc_rqst *rqstp, 
 		.dentry = dentry,
 	};
 
-	if (acc == MAY_NOP)
+	if (acc == NFSD_MAY_NOP)
 		return 0;
 #if 0
 	dprintk("nfsd: permission 0x%x%s%s%s%s%s%s%s mode 0%o%s%s%s\n",
@@ -1891,10 +1892,10 @@ nfsd_permission(struct svc_rqst *rqstp, 
 		(acc & MAY_READ)?	" read"  : "",
 		(acc & MAY_WRITE)?	" write" : "",
 		(acc & MAY_EXEC)?	" exec"  : "",
-		(acc & MAY_SATTR)?	" sattr" : "",
-		(acc & MAY_TRUNC)?	" trunc" : "",
-		(acc & MAY_LOCK)?	" lock"  : "",
-		(acc & MAY_OWNER_OVERRIDE)? " owneroverride" : "",
+		(acc & NFSD_MAY_SATTR)?	" sattr" : "",
+		(acc & NFSD_MAY_TRUNC)?	" trunc" : "",
+		(acc & NFSD_MAY_LOCK)?	" lock"  : "",
+		(acc & NFSD_MAY_OWNER_OVERRIDE)? " owneroverride" : "",
 		inode->i_mode,
 		IS_IMMUTABLE(inode)?	" immut" : "",
 		IS_APPEND(inode)?	" append" : "",
@@ -1907,18 +1908,18 @@ nfsd_permission(struct svc_rqst *rqstp, 
 	 * system.  But if it is IRIX doing check on write-access for a 
 	 * device special file, we ignore rofs.
 	 */
-	if (!(acc & MAY_LOCAL_ACCESS))
-		if (acc & (MAY_WRITE | MAY_SATTR | MAY_TRUNC)) {
+	if (!(acc & NFSD_MAY_LOCAL_ACCESS))
+		if (acc & (MAY_WRITE | NFSD_MAY_SATTR | NFSD_MAY_TRUNC)) {
 			if (exp_rdonly(rqstp, exp) ||
 			    __mnt_is_readonly(exp->ex_path.mnt))
 				return nfserr_rofs;
 			if (/* (acc & MAY_WRITE) && */ IS_IMMUTABLE(inode))
 				return nfserr_perm;
 		}
-	if ((acc & MAY_TRUNC) && IS_APPEND(inode))
+	if ((acc & NFSD_MAY_TRUNC) && IS_APPEND(inode))
 		return nfserr_perm;
 
-	if (acc & MAY_LOCK) {
+	if (acc & NFSD_MAY_LOCK) {
 		/* If we cannot rely on authentication in NLM requests,
 		 * just allow locks, otherwise require read permission, or
 		 * ownership
@@ -1926,7 +1927,7 @@ nfsd_permission(struct svc_rqst *rqstp, 
 		if (exp->ex_flags & NFSEXP_NOAUTHNLM)
 			return 0;
 		else
-			acc = MAY_READ | MAY_OWNER_OVERRIDE;
+			acc = MAY_READ | NFSD_MAY_OWNER_OVERRIDE;
 	}
 	/*
 	 * The file owner always gets access permission for accesses that
@@ -1942,7 +1943,7 @@ nfsd_permission(struct svc_rqst *rqstp, 
 	 * We must trust the client to do permission checking - using "ACCESS"
 	 * with NFSv3.
 	 */
-	if ((acc & MAY_OWNER_OVERRIDE) &&
+	if ((acc & NFSD_MAY_OWNER_OVERRIDE) &&
 	    inode->i_uid == current->fsuid)
 		return 0;
 
@@ -1950,7 +1951,7 @@ nfsd_permission(struct svc_rqst *rqstp, 
 
 	/* Allow read access to binaries even when mode 111 */
 	if (err == -EACCES && S_ISREG(inode->i_mode) &&
-	    acc == (MAY_READ | MAY_OWNER_OVERRIDE))
+	    acc == (MAY_READ | NFSD_MAY_OWNER_OVERRIDE))
 		err = path_permission(&path, MAY_EXEC);
 
 	return err? nfserrno(err) : 0;

--
