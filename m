Return-Path: <linux-kernel-owner+w=401wt.eu-S1758377AbYGATYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377AbYGATYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 15:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbYGATYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 15:24:37 -0400
Received: from mail.fieldses.org ([66.93.2.214]:35658 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbYGATYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 15:24:36 -0400
Date: Tue, 1 Jul 2008 15:24:29 -0400
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch] nfsd: clean up mnt_want_write calls
Message-ID: <20080701192429.GE23080@fieldses.org>
References: <E1KDg43-0005HY-QR@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KDg43-0005HY-QR@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 03:38:35PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Multiple mnt_want_write() calls in the switch statement looks really
> ugly.

Looks right to me; applied for 2.6.27; thanks, Miklos!

--b.

> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Acked-by: Christoph Hellwig <hch@infradead.org>
> ---
>  fs/nfsd/vfs.c |   25 +++++++++++--------------
>  1 file changed, 11 insertions(+), 14 deletions(-)
> 
> Index: linux-2.6/fs/nfsd/vfs.c
> ===================================================================
> --- linux-2.6.orig/fs/nfsd/vfs.c	2008-06-13 13:26:49.000000000 +0200
> +++ linux-2.6/fs/nfsd/vfs.c	2008-06-13 13:26:52.000000000 +0200
> @@ -1248,36 +1248,34 @@ nfsd_create(struct svc_rqst *rqstp, stru
>  		iap->ia_mode = 0;
>  	iap->ia_mode = (iap->ia_mode & S_IALLUGO) | type;
>  
> +	err = nfserr_inval;
> +	if (!S_ISREG(type) && !S_ISDIR(type) && !special_file(type)) {
> +		printk(KERN_WARNING "nfsd: bad file type %o in nfsd_create\n",
> +		       type);
> +		goto out;
> +	}
> +
> +	host_err = mnt_want_write(fhp->fh_export->ex_path.mnt);
> +	if (host_err)
> +		goto out_nfserr;
> +
>  	/*
>  	 * Get the dir op function pointer.
>  	 */
>  	err = 0;
>  	switch (type) {
>  	case S_IFREG:
> -		host_err = mnt_want_write(fhp->fh_export->ex_path.mnt);
> -		if (host_err)
> -			goto out_nfserr;
>  		host_err = vfs_create(dirp, dchild, iap->ia_mode, NULL);
>  		break;
>  	case S_IFDIR:
> -		host_err = mnt_want_write(fhp->fh_export->ex_path.mnt);
> -		if (host_err)
> -			goto out_nfserr;
>  		host_err = vfs_mkdir(dirp, dchild, iap->ia_mode);
>  		break;
>  	case S_IFCHR:
>  	case S_IFBLK:
>  	case S_IFIFO:
>  	case S_IFSOCK:
> -		host_err = mnt_want_write(fhp->fh_export->ex_path.mnt);
> -		if (host_err)
> -			goto out_nfserr;
>  		host_err = vfs_mknod(dirp, dchild, iap->ia_mode, rdev);
>  		break;
> -	default:
> -	        printk("nfsd: bad file type %o in nfsd_create\n", type);
> -		host_err = -EINVAL;
> -		goto out_nfserr;
>  	}
>  	if (host_err < 0) {
>  		mnt_drop_write(fhp->fh_export->ex_path.mnt);
> @@ -1289,7 +1287,6 @@ nfsd_create(struct svc_rqst *rqstp, stru
>  		write_inode_now(dchild->d_inode, 1);
>  	}
>  
> -
>  	err2 = nfsd_create_setattr(rqstp, resfhp, iap);
>  	if (err2)
>  		err = err2;
