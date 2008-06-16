Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbYFPRUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbYFPRUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 13:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYFPRUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 13:20:34 -0400
Received: from mail.fieldses.org ([66.93.2.214]:58344 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485AbYFPRUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 13:20:32 -0400
Date: Mon, 16 Jun 2008 13:20:25 -0400
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch] nfsd: rename MAY_ flags
Message-ID: <20080616172025.GB26231@fieldses.org>
References: <E1K8ClB-0006XX-Hz@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1K8ClB-0006XX-Hz@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 01:20:29PM +0200, Miklos Szeredi wrote:
> Bruce,
> 
> Could you please take care of this patch for 2.6.27?

Yep, thanks.  I've fixed one small comment typo (below) but applied it
otherwise unchanged to my for-2.6.27 branch at

	git://linux-nfs.org/~bfields/linux.git for-2.6.27

--b.

> 
> Thanks,
> Miklos
> 
> --
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Rename nfsd_permission() specific MAY_* flags to NFSD_MAY_* to make it
> clear, that these are not used outside nfsd, and to avoid name and
> number space conflicts with the VFS.
> 
> [comment from hch: rename MAY_READ, MAY_WRITE and MAY_EXEC as well]
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/nfsd/lockd.c           |    2 
>  fs/nfsd/nfs2acl.c         |    7 +-
>  fs/nfsd/nfs3acl.c         |    5 +-
>  fs/nfsd/nfs3proc.c        |    8 +--
>  fs/nfsd/nfs4proc.c        |   23 +++++----
>  fs/nfsd/nfs4state.c       |    6 +-
>  fs/nfsd/nfsfh.c           |    2 
>  fs/nfsd/nfsproc.c         |    8 +--
>  fs/nfsd/vfs.c             |  115 +++++++++++++++++++++++-----------------------
>  include/linux/nfsd/nfsd.h |   26 +++++-----
>  10 files changed, 105 insertions(+), 97 deletions(-)
> 
> Index: linux-2.6/fs/nfsd/lockd.c
> ===================================================================
> --- linux-2.6.orig/fs/nfsd/lockd.c	2008-06-11 10:16:09.000000000 +0200
> +++ linux-2.6/fs/nfsd/lockd.c	2008-06-13 13:35:43.000000000 +0200
> @@ -35,7 +35,7 @@ nlm_fopen(struct svc_rqst *rqstp, struct
>  	fh.fh_export = NULL;
>  
>  	exp_readlock();
> -	nfserr = nfsd_open(rqstp, &fh, S_IFREG, MAY_LOCK, filp);
> +	nfserr = nfsd_open(rqstp, &fh, S_IFREG, NFSD_MAY_LOCK, filp);
>  	fh_put(&fh);
>  	rqstp->rq_client = NULL;
>  	exp_readunlock();
> Index: linux-2.6/fs/nfsd/nfs2acl.c
> ===================================================================
> --- linux-2.6.orig/fs/nfsd/nfs2acl.c	2008-06-11 10:16:09.000000000 +0200
> +++ linux-2.6/fs/nfsd/nfs2acl.c	2008-06-13 13:35:43.000000000 +0200
> @@ -40,7 +40,8 @@ static __be32 nfsacld_proc_getacl(struct
>  	dprintk("nfsd: GETACL(2acl)   %s\n", SVCFH_fmt(&argp->fh));
>  
>  	fh = fh_copy(&resp->fh, &argp->fh);
> -	if ((nfserr = fh_verify(rqstp, &resp->fh, 0, MAY_NOP)))
> +	nfserr = fh_verify(rqstp, &resp->fh, 0, NFSD_MAY_NOP);
> +	if (nfserr)
>  		RETURN_STATUS(nfserr);
>  
>  	if (argp->mask & ~(NFS_ACL|NFS_ACLCNT|NFS_DFACL|NFS_DFACLCNT))
> @@ -107,7 +108,7 @@ static __be32 nfsacld_proc_setacl(struct
>  	dprintk("nfsd: SETACL(2acl)   %s\n", SVCFH_fmt(&argp->fh));
>  
>  	fh = fh_copy(&resp->fh, &argp->fh);
> -	nfserr = fh_verify(rqstp, &resp->fh, 0, MAY_SATTR);
> +	nfserr = fh_verify(rqstp, &resp->fh, 0, NFSD_MAY_SATTR);
>  
>  	if (!nfserr) {
>  		nfserr = nfserrno( nfsd_set_posix_acl(
> @@ -134,7 +135,7 @@ static __be32 nfsacld_proc_getattr(struc
>  	dprintk("nfsd: GETATTR  %s\n", SVCFH_fmt(&argp->fh));
>  
>  	fh_copy(&resp->fh, &argp->fh);
> -	return fh_verify(rqstp, &resp->fh, 0, MAY_NOP);
> +	return fh_verify(rqstp, &resp->fh, 0, NFSD_MAY_NOP);
>  }
>  
>  /*
> Index: linux-2.6/fs/nfsd/nfs3acl.c
> ===================================================================
> --- linux-2.6.orig/fs/nfsd/nfs3acl.c	2008-06-11 10:16:09.000000000 +0200
> +++ linux-2.6/fs/nfsd/nfs3acl.c	2008-06-13 13:35:43.000000000 +0200
> @@ -36,7 +36,8 @@ static __be32 nfsd3_proc_getacl(struct s
>  	__be32 nfserr = 0;
>  
>  	fh = fh_copy(&resp->fh, &argp->fh);
> -	if ((nfserr = fh_verify(rqstp, &resp->fh, 0, MAY_NOP)))
> +	nfserr = fh_verify(rqstp, &resp->fh, 0, NFSD_MAY_NOP);
> +	if (nfserr)
>  		RETURN_STATUS(nfserr);
>  
>  	if (argp->mask & ~(NFS_ACL|NFS_ACLCNT|NFS_DFACL|NFS_DFACLCNT))
> @@ -101,7 +102,7 @@ static __be32 nfsd3_proc_setacl(struct s
>  	__be32 nfserr = 0;
>  
>  	fh = fh_copy(&resp->fh, &argp->fh);
> -	nfserr = fh_verify(rqstp, &resp->fh, 0, MAY_SATTR);
> +	nfserr = fh_verify(rqstp, &resp->fh, 0, NFSD_MAY_SATTR);
>  
>  	if (!nfserr) {
>  		nfserr = nfserrno( nfsd_set_posix_acl(
> Index: linux-2.6/fs/nfsd/nfs3proc.c
> ===================================================================
> --- linux-2.6.orig/fs/nfsd/nfs3proc.c	2008-06-11 10:16:09.000000000 +0200
> +++ linux-2.6/fs/nfsd/nfs3proc.c	2008-06-13 13:35:43.000000000 +0200
> @@ -63,7 +63,7 @@ nfsd3_proc_getattr(struct svc_rqst *rqst
>  		SVCFH_fmt(&argp->fh));
>  
>  	fh_copy(&resp->fh, &argp->fh);
> -	nfserr = fh_verify(rqstp, &resp->fh, 0, MAY_NOP);
> +	nfserr = fh_verify(rqstp, &resp->fh, 0, NFSD_MAY_NOP);
>  	if (nfserr)
>  		RETURN_STATUS(nfserr);
>  
> @@ -242,7 +242,7 @@ nfsd3_proc_create(struct svc_rqst *rqstp
>  	attr   = &argp->attrs;
>  
>  	/* Get the directory inode */
> -	nfserr = fh_verify(rqstp, dirfhp, S_IFDIR, MAY_CREATE);
> +	nfserr = fh_verify(rqstp, dirfhp, S_IFDIR, NFSD_MAY_CREATE);
>  	if (nfserr)
>  		RETURN_STATUS(nfserr);
>  
> @@ -558,7 +558,7 @@ nfsd3_proc_fsinfo(struct svc_rqst * rqst
>  	resp->f_maxfilesize = ~(u32) 0;
>  	resp->f_properties = NFS3_FSF_DEFAULT;
>  
> -	nfserr = fh_verify(rqstp, &argp->fh, 0, MAY_NOP);
> +	nfserr = fh_verify(rqstp, &argp->fh, 0, NFSD_MAY_NOP);
>  
>  	/* Check special features of the file system. May request
>  	 * different read/write sizes for file systems known to have
> @@ -597,7 +597,7 @@ nfsd3_proc_pathconf(struct svc_rqst * rq
>  	resp->p_case_insensitive = 0;
>  	resp->p_case_preserving = 1;
>  
> -	nfserr = fh_verify(rqstp, &argp->fh, 0, MAY_NOP);
> +	nfserr = fh_verify(rqstp, &argp->fh, 0, NFSD_MAY_NOP);
>  
>  	if (nfserr == 0) {
>  		struct super_block *sb = argp->fh.fh_dentry->d_inode->i_sb;
> Index: linux-2.6/fs/nfsd/nfs4proc.c
> ===================================================================
> --- linux-2.6.orig/fs/nfsd/nfs4proc.c	2008-06-11 10:16:09.000000000 +0200
> +++ linux-2.6/fs/nfsd/nfs4proc.c	2008-06-13 13:48:21.000000000 +0200
> @@ -71,11 +71,11 @@ do_open_permission(struct svc_rqst *rqst
>  		return nfserr_inval;
>  
>  	if (open->op_share_access & NFS4_SHARE_ACCESS_READ)
> -		accmode |= MAY_READ;
> +		accmode |= NFSD_MAY_READ;
>  	if (open->op_share_access & NFS4_SHARE_ACCESS_WRITE)
> -		accmode |= (MAY_WRITE | MAY_TRUNC);
> +		accmode |= (NFSD_MAY_WRITE | NFSD_MAY_TRUNC);
>  	if (open->op_share_deny & NFS4_SHARE_DENY_WRITE)
> -		accmode |= MAY_WRITE;
> +		accmode |= NFSD_MAY_WRITE;
>  
>  	status = fh_verify(rqstp, current_fh, S_IFREG, accmode);
>  
> @@ -126,7 +126,8 @@ do_open_lookup(struct svc_rqst *rqstp, s
>  			&resfh.fh_handle.fh_base, resfh.fh_handle.fh_size);
>  
>  	if (!created)
> -		status = do_open_permission(rqstp, current_fh, open, MAY_NOP);
> +		status = do_open_permission(rqstp, current_fh, open,
> +					    NFSD_MAY_NOP);
>  
>  out:
>  	fh_put(&resfh);
> @@ -157,7 +158,8 @@ do_open_fhandle(struct svc_rqst *rqstp, 
>  	open->op_truncate = (open->op_iattr.ia_valid & ATTR_SIZE) &&
>  		(open->op_iattr.ia_size == 0);
>  
> -	status = do_open_permission(rqstp, current_fh, open, MAY_OWNER_OVERRIDE);
> +	status = do_open_permission(rqstp, current_fh, open,
> +				    NFSD_MAY_OWNER_OVERRIDE);
>  
>  	return status;
>  }
> @@ -186,7 +188,7 @@ nfsd4_open(struct svc_rqst *rqstp, struc
>  		cstate->current_fh.fh_handle.fh_size = rp->rp_openfh_len;
>  		memcpy(&cstate->current_fh.fh_handle.fh_base, rp->rp_openfh,
>  				rp->rp_openfh_len);
> -		status = fh_verify(rqstp, &cstate->current_fh, 0, MAY_NOP);
> +		status = fh_verify(rqstp, &cstate->current_fh, 0, NFSD_MAY_NOP);
>  		if (status)
>  			dprintk("nfsd4_open: replay failed"
>  				" restoring previous filehandle\n");
> @@ -285,7 +287,7 @@ nfsd4_putfh(struct svc_rqst *rqstp, stru
>  	cstate->current_fh.fh_handle.fh_size = putfh->pf_fhlen;
>  	memcpy(&cstate->current_fh.fh_handle.fh_base, putfh->pf_fhval,
>  	       putfh->pf_fhlen);
> -	return fh_verify(rqstp, &cstate->current_fh, 0, MAY_NOP);
> +	return fh_verify(rqstp, &cstate->current_fh, 0, NFSD_MAY_NOP);
>  }
>  
>  static __be32
> @@ -363,7 +365,8 @@ nfsd4_create(struct svc_rqst *rqstp, str
>  
>  	fh_init(&resfh, NFS4_FHSIZE);
>  
> -	status = fh_verify(rqstp, &cstate->current_fh, S_IFDIR, MAY_CREATE);
> +	status = fh_verify(rqstp, &cstate->current_fh, S_IFDIR,
> +			   NFSD_MAY_CREATE);
>  	if (status == nfserr_symlink)
>  		status = nfserr_notdir;
>  	if (status)
> @@ -445,7 +448,7 @@ nfsd4_getattr(struct svc_rqst *rqstp, st
>  {
>  	__be32 status;
>  
> -	status = fh_verify(rqstp, &cstate->current_fh, 0, MAY_NOP);
> +	status = fh_verify(rqstp, &cstate->current_fh, 0, NFSD_MAY_NOP);
>  	if (status)
>  		return status;
>  
> @@ -730,7 +733,7 @@ _nfsd4_verify(struct svc_rqst *rqstp, st
>  	int count;
>  	__be32 status;
>  
> -	status = fh_verify(rqstp, &cstate->current_fh, 0, MAY_NOP);
> +	status = fh_verify(rqstp, &cstate->current_fh, 0, NFSD_MAY_NOP);
>  	if (status)
>  		return status;
>  
> Index: linux-2.6/fs/nfsd/nfs4state.c
> ===================================================================
> --- linux-2.6.orig/fs/nfsd/nfs4state.c	2008-06-11 10:16:09.000000000 +0200
> +++ linux-2.6/fs/nfsd/nfs4state.c	2008-06-13 13:48:37.000000000 +0200
> @@ -1722,9 +1722,9 @@ nfsd4_process_open2(struct svc_rqst *rqs
>  		/* Stateid was not found, this is a new OPEN */
>  		int flags = 0;
>  		if (open->op_share_access & NFS4_SHARE_ACCESS_READ)
> -			flags |= MAY_READ;
> +			flags |= NFSD_MAY_READ;
>  		if (open->op_share_access & NFS4_SHARE_ACCESS_WRITE)
> -			flags |= MAY_WRITE;
> +			flags |= NFSD_MAY_WRITE;
>  		status = nfs4_new_open(rqstp, &stp, dp, current_fh, flags);
>  		if (status)
>  			goto out;
> @@ -2610,7 +2610,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
>  		 return nfserr_inval;
>  
>  	if ((status = fh_verify(rqstp, &cstate->current_fh,
> -				S_IFREG, MAY_LOCK))) {
> +				S_IFREG, NFSD_MAY_LOCK))) {
>  		dprintk("NFSD: nfsd4_lock: permission denied!\n");
>  		return status;
>  	}
> Index: linux-2.6/fs/nfsd/nfsfh.c
> ===================================================================
> --- linux-2.6.orig/fs/nfsd/nfsfh.c	2008-06-11 10:16:11.000000000 +0200
> +++ linux-2.6/fs/nfsd/nfsfh.c	2008-06-13 13:35:43.000000000 +0200
> @@ -279,7 +279,7 @@ fh_verify(struct svc_rqst *rqstp, struct
>  	if (error)
>  		goto out;
>  
> -	if (!(access & MAY_LOCK)) {
> +	if (!(access & NFSD_MAY_LOCK)) {
>  		/*
>  		 * pseudoflavor restrictions are not enforced on NLM,
>  		 * which clients virtually always use auth_sys for,
> Index: linux-2.6/fs/nfsd/nfsproc.c
> ===================================================================
> --- linux-2.6.orig/fs/nfsd/nfsproc.c	2008-06-11 10:16:09.000000000 +0200
> +++ linux-2.6/fs/nfsd/nfsproc.c	2008-06-13 13:52:26.000000000 +0200
> @@ -65,7 +65,7 @@ nfsd_proc_getattr(struct svc_rqst *rqstp
>  	dprintk("nfsd: GETATTR  %s\n", SVCFH_fmt(&argp->fh));
>  
>  	fh_copy(&resp->fh, &argp->fh);
> -	nfserr = fh_verify(rqstp, &resp->fh, 0, MAY_NOP);
> +	nfserr = fh_verify(rqstp, &resp->fh, 0, NFSD_MAY_NOP);
>  	return nfsd_return_attrs(nfserr, resp);
>  }
>  
> @@ -215,11 +215,11 @@ nfsd_proc_create(struct svc_rqst *rqstp,
>  		SVCFH_fmt(dirfhp), argp->len, argp->name);
>  
>  	/* First verify the parent file handle */
> -	nfserr = fh_verify(rqstp, dirfhp, S_IFDIR, MAY_EXEC);
> +	nfserr = fh_verify(rqstp, dirfhp, S_IFDIR, NFSD_MAY_EXEC);
>  	if (nfserr)
>  		goto done; /* must fh_put dirfhp even on error */
>  
> -	/* Check for MAY_WRITE in nfsd_create if necessary */
> +	/* Check for NFSD_MAY_WRITE in nfsd_create if necessary */
>  
>  	nfserr = nfserr_acces;
>  	if (!argp->len)
> @@ -281,7 +281,7 @@ nfsd_proc_create(struct svc_rqst *rqstp,
>  					nfserr = nfsd_permission(rqstp,
>  								 newfhp->fh_export,
>  								 newfhp->fh_dentry,
> -								 MAY_WRITE|MAY_LOCAL_ACCESS);
> +								 NFSD_MAY_WRITE|NFSD_MAY_LOCAL_ACCESS);
>  					if (nfserr && nfserr != nfserr_rofs)
>  						goto out_unlock;
>  				}
> Index: linux-2.6/fs/nfsd/vfs.c
> ===================================================================
> --- linux-2.6.orig/fs/nfsd/vfs.c	2008-06-13 13:31:07.000000000 +0200
> +++ linux-2.6/fs/nfsd/vfs.c	2008-06-13 13:54:09.000000000 +0200
> @@ -144,7 +144,7 @@ nfsd_lookup_dentry(struct svc_rqst *rqst
>  	dprintk("nfsd: nfsd_lookup(fh %s, %.*s)\n", SVCFH_fmt(fhp), len,name);
>  
>  	/* Obtain dentry and export. */
> -	err = fh_verify(rqstp, fhp, S_IFDIR, MAY_EXEC);
> +	err = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_EXEC);
>  	if (err)
>  		return err;
>  
> @@ -262,14 +262,14 @@ nfsd_setattr(struct svc_rqst *rqstp, str
>  {
>  	struct dentry	*dentry;
>  	struct inode	*inode;
> -	int		accmode = MAY_SATTR;
> +	int		accmode = NFSD_MAY_SATTR;
>  	int		ftype = 0;
>  	__be32		err;
>  	int		host_err;
>  	int		size_change = 0;
>  
>  	if (iap->ia_valid & (ATTR_ATIME | ATTR_MTIME | ATTR_SIZE))
> -		accmode |= MAY_WRITE|MAY_OWNER_OVERRIDE;
> +		accmode |= NFSD_MAY_WRITE|NFSD_MAY_OWNER_OVERRIDE;
>  	if (iap->ia_valid & ATTR_SIZE)
>  		ftype = S_IFREG;
>  
> @@ -331,7 +331,8 @@ nfsd_setattr(struct svc_rqst *rqstp, str
>  	 */
>  	if (iap->ia_valid & ATTR_SIZE) {
>  		if (iap->ia_size < inode->i_size) {
> -			err = nfsd_permission(rqstp, fhp->fh_export, dentry, MAY_TRUNC|MAY_OWNER_OVERRIDE);
> +			err = nfsd_permission(rqstp, fhp->fh_export, dentry,
> +					NFSD_MAY_TRUNC|NFSD_MAY_OWNER_OVERRIDE);
>  			if (err)
>  				goto out;
>  		}
> @@ -462,7 +463,7 @@ nfsd4_set_nfs4_acl(struct svc_rqst *rqst
>  	unsigned int flags = 0;
>  
>  	/* Get inode */
> -	error = fh_verify(rqstp, fhp, 0 /* S_IFREG */, MAY_SATTR);
> +	error = fh_verify(rqstp, fhp, 0 /* S_IFREG */, NFSD_MAY_SATTR);
>  	if (error)
>  		return error;
>  
> @@ -563,20 +564,20 @@ struct accessmap {
>  	int		how;
>  };
>  static struct accessmap	nfs3_regaccess[] = {
> -    {	NFS3_ACCESS_READ,	MAY_READ			},
> -    {	NFS3_ACCESS_EXECUTE,	MAY_EXEC			},
> -    {	NFS3_ACCESS_MODIFY,	MAY_WRITE|MAY_TRUNC		},
> -    {	NFS3_ACCESS_EXTEND,	MAY_WRITE			},
> +    {	NFS3_ACCESS_READ,	NFSD_MAY_READ			},
> +    {	NFS3_ACCESS_EXECUTE,	NFSD_MAY_EXEC			},
> +    {	NFS3_ACCESS_MODIFY,	NFSD_MAY_WRITE|NFSD_MAY_TRUNC	},
> +    {	NFS3_ACCESS_EXTEND,	NFSD_MAY_WRITE			},
>  
>      {	0,			0				}
>  };
>  
>  static struct accessmap	nfs3_diraccess[] = {
> -    {	NFS3_ACCESS_READ,	MAY_READ			},
> -    {	NFS3_ACCESS_LOOKUP,	MAY_EXEC			},
> -    {	NFS3_ACCESS_MODIFY,	MAY_EXEC|MAY_WRITE|MAY_TRUNC	},
> -    {	NFS3_ACCESS_EXTEND,	MAY_EXEC|MAY_WRITE		},
> -    {	NFS3_ACCESS_DELETE,	MAY_REMOVE			},
> +    {	NFS3_ACCESS_READ,	NFSD_MAY_READ			},
> +    {	NFS3_ACCESS_LOOKUP,	NFSD_MAY_EXEC			},
> +    {	NFS3_ACCESS_MODIFY,	NFSD_MAY_EXEC|NFSD_MAY_WRITE|NFSD_MAY_TRUNC},
> +    {	NFS3_ACCESS_EXTEND,	NFSD_MAY_EXEC|NFSD_MAY_WRITE	},
> +    {	NFS3_ACCESS_DELETE,	NFSD_MAY_REMOVE			},
>  
>      {	0,			0				}
>  };
> @@ -589,10 +590,10 @@ static struct accessmap	nfs3_anyaccess[]
>  	 * mainly at mode bits, and we make sure to ignore read-only
>  	 * filesystem checks
>  	 */
> -    {	NFS3_ACCESS_READ,	MAY_READ			},
> -    {	NFS3_ACCESS_EXECUTE,	MAY_EXEC			},
> -    {	NFS3_ACCESS_MODIFY,	MAY_WRITE|MAY_LOCAL_ACCESS	},
> -    {	NFS3_ACCESS_EXTEND,	MAY_WRITE|MAY_LOCAL_ACCESS	},
> +    {	NFS3_ACCESS_READ,	NFSD_MAY_READ			},
> +    {	NFS3_ACCESS_EXECUTE,	NFSD_MAY_EXEC			},
> +    {	NFS3_ACCESS_MODIFY,	NFSD_MAY_WRITE|NFSD_MAY_LOCAL_ACCESS	},
> +    {	NFS3_ACCESS_EXTEND,	NFSD_MAY_WRITE|NFSD_MAY_LOCAL_ACCESS	},
>  
>      {	0,			0				}
>  };
> @@ -606,7 +607,7 @@ nfsd_access(struct svc_rqst *rqstp, stru
>  	u32			query, result = 0, sresult = 0;
>  	__be32			error;
>  
> -	error = fh_verify(rqstp, fhp, 0, MAY_NOP);
> +	error = fh_verify(rqstp, fhp, 0, NFSD_MAY_NOP);
>  	if (error)
>  		goto out;
>  
> @@ -678,7 +679,7 @@ nfsd_open(struct svc_rqst *rqstp, struct
>  	 * and (hopefully) checked permission - so allow OWNER_OVERRIDE
>  	 * in case a chmod has now revoked permission.
>  	 */
> -	err = fh_verify(rqstp, fhp, type, access | MAY_OWNER_OVERRIDE);
> +	err = fh_verify(rqstp, fhp, type, access | NFSD_MAY_OWNER_OVERRIDE);
>  	if (err)
>  		goto out;
>  
> @@ -689,7 +690,7 @@ nfsd_open(struct svc_rqst *rqstp, struct
>  	 * or any access when mandatory locking enabled
>  	 */
>  	err = nfserr_perm;
> -	if (IS_APPEND(inode) && (access & MAY_WRITE))
> +	if (IS_APPEND(inode) && (access & NFSD_MAY_WRITE))
>  		goto out;
>  	/*
>  	 * We must ignore files (but only files) which might have mandatory
> @@ -706,14 +707,14 @@ nfsd_open(struct svc_rqst *rqstp, struct
>  	 * Check to see if there are any leases on this file.
>  	 * This may block while leases are broken.
>  	 */
> -	host_err = break_lease(inode, O_NONBLOCK | ((access & MAY_WRITE) ? FMODE_WRITE : 0));
> +	host_err = break_lease(inode, O_NONBLOCK | ((access & NFSD_MAY_WRITE) ? FMODE_WRITE : 0));
>  	if (host_err == -EWOULDBLOCK)
>  		host_err = -ETIMEDOUT;
>  	if (host_err) /* NOMEM or WOULDBLOCK */
>  		goto out_nfserr;
>  
> -	if (access & MAY_WRITE) {
> -		if (access & MAY_READ)
> +	if (access & NFSD_MAY_WRITE) {
> +		if (access & NFSD_MAY_READ)
>  			flags = O_RDWR|O_LARGEFILE;
>  		else
>  			flags = O_WRONLY|O_LARGEFILE;
> @@ -1069,12 +1070,12 @@ nfsd_read(struct svc_rqst *rqstp, struct
>  
>  	if (file) {
>  		err = nfsd_permission(rqstp, fhp->fh_export, fhp->fh_dentry,
> -				MAY_READ|MAY_OWNER_OVERRIDE);
> +				NFSD_MAY_READ|NFSD_MAY_OWNER_OVERRIDE);
>  		if (err)
>  			goto out;
>  		err = nfsd_vfs_read(rqstp, fhp, file, offset, vec, vlen, count);
>  	} else {
> -		err = nfsd_open(rqstp, fhp, S_IFREG, MAY_READ, &file);
> +		err = nfsd_open(rqstp, fhp, S_IFREG, NFSD_MAY_READ, &file);
>  		if (err)
>  			goto out;
>  		err = nfsd_vfs_read(rqstp, fhp, file, offset, vec, vlen, count);
> @@ -1098,13 +1099,13 @@ nfsd_write(struct svc_rqst *rqstp, struc
>  
>  	if (file) {
>  		err = nfsd_permission(rqstp, fhp->fh_export, fhp->fh_dentry,
> -				MAY_WRITE|MAY_OWNER_OVERRIDE);
> +				NFSD_MAY_WRITE|NFSD_MAY_OWNER_OVERRIDE);
>  		if (err)
>  			goto out;
>  		err = nfsd_vfs_write(rqstp, fhp, file, offset, vec, vlen, cnt,
>  				stablep);
>  	} else {
> -		err = nfsd_open(rqstp, fhp, S_IFREG, MAY_WRITE, &file);
> +		err = nfsd_open(rqstp, fhp, S_IFREG, NFSD_MAY_WRITE, &file);
>  		if (err)
>  			goto out;
>  
> @@ -1136,7 +1137,8 @@ nfsd_commit(struct svc_rqst *rqstp, stru
>  	if ((u64)count > ~(u64)offset)
>  		return nfserr_inval;
>  
> -	if ((err = nfsd_open(rqstp, fhp, S_IFREG, MAY_WRITE, &file)) != 0)
> +	err = nfsd_open(rqstp, fhp, S_IFREG, NFSD_MAY_WRITE, &file);
> +	if (err)
>  		return err;
>  	if (EX_ISSYNC(fhp->fh_export)) {
>  		if (file->f_op && file->f_op->fsync) {
> @@ -1197,7 +1199,7 @@ nfsd_create(struct svc_rqst *rqstp, stru
>  	if (isdotent(fname, flen))
>  		goto out;
>  
> -	err = fh_verify(rqstp, fhp, S_IFDIR, MAY_CREATE);
> +	err = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_CREATE);
>  	if (err)
>  		goto out;
>  
> @@ -1331,7 +1333,7 @@ nfsd_create_v3(struct svc_rqst *rqstp, s
>  		goto out;
>  	if (!(iap->ia_valid & ATTR_MODE))
>  		iap->ia_mode = 0;
> -	err = fh_verify(rqstp, fhp, S_IFDIR, MAY_CREATE);
> +	err = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_CREATE);
>  	if (err)
>  		goto out;
>  
> @@ -1468,7 +1470,7 @@ nfsd_readlink(struct svc_rqst *rqstp, st
>  	__be32		err;
>  	int		host_err;
>  
> -	err = fh_verify(rqstp, fhp, S_IFLNK, MAY_NOP);
> +	err = fh_verify(rqstp, fhp, S_IFLNK, NFSD_MAY_NOP);
>  	if (err)
>  		goto out;
>  
> @@ -1523,7 +1525,7 @@ nfsd_symlink(struct svc_rqst *rqstp, str
>  	if (isdotent(fname, flen))
>  		goto out;
>  
> -	err = fh_verify(rqstp, fhp, S_IFDIR, MAY_CREATE);
> +	err = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_CREATE);
>  	if (err)
>  		goto out;
>  	fh_lock(fhp);
> @@ -1588,10 +1590,10 @@ nfsd_link(struct svc_rqst *rqstp, struct
>  	__be32		err;
>  	int		host_err;
>  
> -	err = fh_verify(rqstp, ffhp, S_IFDIR, MAY_CREATE);
> +	err = fh_verify(rqstp, ffhp, S_IFDIR, NFSD_MAY_CREATE);
>  	if (err)
>  		goto out;
> -	err = fh_verify(rqstp, tfhp, -S_IFDIR, MAY_NOP);
> +	err = fh_verify(rqstp, tfhp, -S_IFDIR, NFSD_MAY_NOP);
>  	if (err)
>  		goto out;
>  
> @@ -1658,10 +1660,10 @@ nfsd_rename(struct svc_rqst *rqstp, stru
>  	__be32		err;
>  	int		host_err;
>  
> -	err = fh_verify(rqstp, ffhp, S_IFDIR, MAY_REMOVE);
> +	err = fh_verify(rqstp, ffhp, S_IFDIR, NFSD_MAY_REMOVE);
>  	if (err)
>  		goto out;
> -	err = fh_verify(rqstp, tfhp, S_IFDIR, MAY_CREATE);
> +	err = fh_verify(rqstp, tfhp, S_IFDIR, NFSD_MAY_CREATE);
>  	if (err)
>  		goto out;
>  
> @@ -1765,7 +1767,7 @@ nfsd_unlink(struct svc_rqst *rqstp, stru
>  	err = nfserr_acces;
>  	if (!flen || isdotent(fname, flen))
>  		goto out;
> -	err = fh_verify(rqstp, fhp, S_IFDIR, MAY_REMOVE);
> +	err = fh_verify(rqstp, fhp, S_IFDIR, NFSD_MAY_REMOVE);
>  	if (err)
>  		goto out;
>  
> @@ -1831,7 +1833,7 @@ nfsd_readdir(struct svc_rqst *rqstp, str
>  	struct file	*file;
>  	loff_t		offset = *offsetp;
>  
> -	err = nfsd_open(rqstp, fhp, S_IFDIR, MAY_READ, &file);
> +	err = nfsd_open(rqstp, fhp, S_IFDIR, NFSD_MAY_READ, &file);
>  	if (err)
>  		goto out;
>  
> @@ -1872,7 +1874,7 @@ out:
>  __be32
>  nfsd_statfs(struct svc_rqst *rqstp, struct svc_fh *fhp, struct kstatfs *stat)
>  {
> -	__be32 err = fh_verify(rqstp, fhp, 0, MAY_NOP);
> +	__be32 err = fh_verify(rqstp, fhp, 0, NFSD_MAY_NOP);
>  	if (!err && vfs_statfs(fhp->fh_dentry,stat))
>  		err = nfserr_io;
>  	return err;
> @@ -1893,18 +1895,18 @@ nfsd_permission(struct svc_rqst *rqstp, 
>  	struct inode	*inode = dentry->d_inode;
>  	int		err;
>  
> -	if (acc == MAY_NOP)
> +	if (acc == NFSD_MAY_NOP)
>  		return 0;
>  #if 0
>  	dprintk("nfsd: permission 0x%x%s%s%s%s%s%s%s mode 0%o%s%s%s\n",
>  		acc,
> -		(acc & MAY_READ)?	" read"  : "",
> -		(acc & MAY_WRITE)?	" write" : "",
> -		(acc & MAY_EXEC)?	" exec"  : "",
> -		(acc & MAY_SATTR)?	" sattr" : "",
> -		(acc & MAY_TRUNC)?	" trunc" : "",
> -		(acc & MAY_LOCK)?	" lock"  : "",
> -		(acc & MAY_OWNER_OVERRIDE)? " owneroverride" : "",
> +		(acc & NFSD_MAY_READ)?	" read"  : "",
> +		(acc & NFSD_MAY_WRITE)?	" write" : "",
> +		(acc & NFSD_MAY_EXEC)?	" exec"  : "",
> +		(acc & NFSD_MAY_SATTR)?	" sattr" : "",
> +		(acc & NFSD_MAY_TRUNC)?	" trunc" : "",
> +		(acc & NFSD_MAY_LOCK)?	" lock"  : "",
> +		(acc & NFSD_MAY_OWNER_OVERRIDE)? " owneroverride" : "",
>  		inode->i_mode,
>  		IS_IMMUTABLE(inode)?	" immut" : "",
>  		IS_APPEND(inode)?	" append" : "",
> @@ -1917,18 +1919,18 @@ nfsd_permission(struct svc_rqst *rqstp, 
>  	 * system.  But if it is IRIX doing check on write-access for a 
>  	 * device special file, we ignore rofs.
>  	 */
> -	if (!(acc & MAY_LOCAL_ACCESS))
> -		if (acc & (MAY_WRITE | MAY_SATTR | MAY_TRUNC)) {
> +	if (!(acc & NFSD_MAY_LOCAL_ACCESS))
> +		if (acc & (NFSD_MAY_WRITE | NFSD_MAY_SATTR | NFSD_MAY_TRUNC)) {
>  			if (exp_rdonly(rqstp, exp) ||
>  			    __mnt_is_readonly(exp->ex_path.mnt))
>  				return nfserr_rofs;
> -			if (/* (acc & MAY_WRITE) && */ IS_IMMUTABLE(inode))
> +			if (/* (acc & NFSD_MAY_WRITE) && */ IS_IMMUTABLE(inode))
>  				return nfserr_perm;
>  		}
> -	if ((acc & MAY_TRUNC) && IS_APPEND(inode))
> +	if ((acc & NFSD_MAY_TRUNC) && IS_APPEND(inode))
>  		return nfserr_perm;
>  
> -	if (acc & MAY_LOCK) {
> +	if (acc & NFSD_MAY_LOCK) {
>  		/* If we cannot rely on authentication in NLM requests,
>  		 * just allow locks, otherwise require read permission, or
>  		 * ownership
> @@ -1936,7 +1938,7 @@ nfsd_permission(struct svc_rqst *rqstp, 
>  		if (exp->ex_flags & NFSEXP_NOAUTHNLM)
>  			return 0;
>  		else
> -			acc = MAY_READ | MAY_OWNER_OVERRIDE;
> +			acc = NFSD_MAY_READ | NFSD_MAY_OWNER_OVERRIDE;
>  	}
>  	/*
>  	 * The file owner always gets access permission for accesses that
> @@ -1952,15 +1954,16 @@ nfsd_permission(struct svc_rqst *rqstp, 
>  	 * We must trust the client to do permission checking - using "ACCESS"
>  	 * with NFSv3.
>  	 */
> -	if ((acc & MAY_OWNER_OVERRIDE) &&
> +	if ((acc & NFSD_MAY_OWNER_OVERRIDE) &&
>  	    inode->i_uid == current->fsuid)
>  		return 0;
>  
> +	/* This assumes  NFS_MAY_{READ,WRITE,EXEC} == MAY_{READ,WRITE,EXEC} */
>  	err = permission(inode, acc & (MAY_READ|MAY_WRITE|MAY_EXEC), NULL);
>  
>  	/* Allow read access to binaries even when mode 111 */
>  	if (err == -EACCES && S_ISREG(inode->i_mode) &&
> -	    acc == (MAY_READ | MAY_OWNER_OVERRIDE))
> +	    acc == (NFSD_MAY_READ | NFSD_MAY_OWNER_OVERRIDE))
>  		err = permission(inode, MAY_EXEC, NULL);
>  
>  	return err? nfserrno(err) : 0;
> Index: linux-2.6/include/linux/nfsd/nfsd.h
> ===================================================================
> --- linux-2.6.orig/include/linux/nfsd/nfsd.h	2008-06-11 10:16:12.000000000 +0200
> +++ linux-2.6/include/linux/nfsd/nfsd.h	2008-06-13 13:57:07.000000000 +0200
> @@ -28,20 +28,20 @@
>  #define NFSD_SUPPORTED_MINOR_VERSION	0
>  
>  /*
> - * Special flags for nfsd_permission. These must be different from MAY_READ,
> - * MAY_WRITE, and MAY_EXEC.
> + * Flags for nfsd_permission
>   */
> -#define MAY_NOP			0
> -#define MAY_SATTR		8
> -#define MAY_TRUNC		16
> -#define MAY_LOCK		32
> -#define MAY_OWNER_OVERRIDE	64
> -#define	MAY_LOCAL_ACCESS	128 /* IRIX doing local access check on device special file*/
> -#if (MAY_SATTR | MAY_TRUNC | MAY_LOCK | MAY_OWNER_OVERRIDE | MAY_LOCAL_ACCESS) & (MAY_READ | MAY_WRITE | MAY_EXEC)
> -# error "please use a different value for MAY_SATTR or MAY_TRUNC or MAY_LOCK or MAY_LOCAL_ACCESS or MAY_OWNER_OVERRIDE."
> -#endif
> -#define MAY_CREATE		(MAY_EXEC|MAY_WRITE)
> -#define MAY_REMOVE		(MAY_EXEC|MAY_WRITE|MAY_TRUNC)
> +#define NFSD_MAY_NOP		0
> +#define NFSD_MAY_EXEC		1 /* == MAY_EXEC */
> +#define NFSD_MAY_WRITE		2 /* == MAY_WRITE */
> +#define NFSD_MAY_READ		4 /* == MAY_READ */
> +#define NFSD_MAY_SATTR		8
> +#define NFSD_MAY_TRUNC		16
> +#define NFSD_MAY_LOCK		32
> +#define NFSD_MAY_OWNER_OVERRIDE	64
> +#define NFSD_MAY_LOCAL_ACCESS	128 /* IRIX doing local access check on device special file*/
> +
> +#define NFSD_MAY_CREATE		(NFSD_MAY_EXEC|NFSD_MAY_WRITE)
> +#define NFSD_MAY_REMOVE		(NFSD_MAY_EXEC|NFSD_MAY_WRITE|NFSD_MAY_TRUNC)
>  
>  /*
>   * Callback function for readdir
