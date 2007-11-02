Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbXKBObT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbXKBObT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 10:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbXKBObL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 10:31:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:37223 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924AbXKBObK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 10:31:10 -0400
Date: Fri, 2 Nov 2007 09:28:23 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: Trond Myklebust <Trond.Myklebust@netapp.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       nfs@lists.sourceforge.net, neilb@suse.de, bfields@fieldses.org,
       chuck.lever@oracle.com, Andrew Morton <akpm@osdl.org>
Subject: Re: LTP ustat01 test fails on NFSROOT
In-Reply-To: <1193335168.7705.39.camel@heimdal.trondhjem.org>
Message-ID: <Pine.LNX.4.64.0711020927530.25341@blarg.am.freescale.net>
References: <CBDE987B-0713-4D62-8122-054183E75410@kernel.crashing.org> 
 <1193188894.27073.20.camel@heimdal.trondhjem.org> 
 <1954B8FA-6E29-4FB7-86B0-EA43AF8F2AAF@kernel.crashing.org> 
 <2B2C1270-60FB-4830-A62C-D0357D2E1FB3@kernel.crashing.org>
 <1193335168.7705.39.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, Trond Myklebust wrote:

> Could you please try the following patch?
>
> Cheers
>   Trond

Its a new month so I'll ping again about sending this fix upstream to
linus for 2.6.24 :) ?

- k

> --------------------------------- CUT HERE -----------------------------
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date: Thu, 25 Oct 2007 13:56:10 -0400
> NFS: Fix the ustat() regression
>
> Since 2.6.18, the superblock sb->s_root has been a dummy dentry with a
> dummy inode. This breaks ustat(), which actually uses sb->s_root in a
> vfstat() call.
>
> Fix this by making the s_root a dummy alias to the directory inode that was
> used when creating the superblock.
>
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> ---
>
>  fs/nfs/getroot.c |   81 ++++++++++++++++++------------------------------------
>  1 files changed, 27 insertions(+), 54 deletions(-)
>
> diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
> index 522e5ad..0ee4384 100644
> --- a/fs/nfs/getroot.c
> +++ b/fs/nfs/getroot.c
> @@ -43,6 +43,25 @@
>  #define NFSDBG_FACILITY		NFSDBG_CLIENT
>
>  /*
> + * Set the superblock root dentry.
> + * Note that this function frees the inode in case of error.
> + */
> +static int nfs_superblock_set_dummy_root(struct super_block *sb, struct inode *inode)
> +{
> +	/* The mntroot acts as the dummy root dentry for this superblock */
> +	if (sb->s_root == NULL) {
> +		sb->s_root = d_alloc_root(inode);
> +		if (sb->s_root == NULL) {
> +			iput(inode);
> +			return -ENOMEM;
> +		}
> +		/* Circumvent igrab(): we know the inode is not being freed */
> +		atomic_inc(&inode->i_count);
> +	}
> +	return 0;
> +}
> +
> +/*
>   * get an NFS2/NFS3 root dentry from the root filehandle
>   */
>  struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh)
> @@ -54,33 +73,6 @@ struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh)
>  	struct inode *inode;
>  	int error;
>
> -	/* create a dummy root dentry with dummy inode for this superblock */
> -	if (!sb->s_root) {
> -		struct nfs_fh dummyfh;
> -		struct dentry *root;
> -		struct inode *iroot;
> -
> -		memset(&dummyfh, 0, sizeof(dummyfh));
> -		memset(&fattr, 0, sizeof(fattr));
> -		nfs_fattr_init(&fattr);
> -		fattr.valid = NFS_ATTR_FATTR;
> -		fattr.type = NFDIR;
> -		fattr.mode = S_IFDIR | S_IRUSR | S_IWUSR;
> -		fattr.nlink = 2;
> -
> -		iroot = nfs_fhget(sb, &dummyfh, &fattr);
> -		if (IS_ERR(iroot))
> -			return ERR_PTR(PTR_ERR(iroot));
> -
> -		root = d_alloc_root(iroot);
> -		if (!root) {
> -			iput(iroot);
> -			return ERR_PTR(-ENOMEM);
> -		}
> -
> -		sb->s_root = root;
> -	}
> -
>  	/* get the actual root for this mount */
>  	fsinfo.fattr = &fattr;
>
> @@ -96,6 +88,10 @@ struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh)
>  		return ERR_PTR(PTR_ERR(inode));
>  	}
>
> +	error = nfs_superblock_set_dummy_root(sb, inode);
> +	if (error != 0)
> +		return ERR_PTR(error);
> +
>  	/* root dentries normally start off anonymous and get spliced in later
>  	 * if the dentry tree reaches them; however if the dentry already
>  	 * exists, we'll pick it up at this point and use it as the root
> @@ -241,33 +237,6 @@ struct dentry *nfs4_get_root(struct super_block *sb, struct nfs_fh *mntfh)
>
>  	dprintk("--> nfs4_get_root()\n");
>
> -	/* create a dummy root dentry with dummy inode for this superblock */
> -	if (!sb->s_root) {
> -		struct nfs_fh dummyfh;
> -		struct dentry *root;
> -		struct inode *iroot;
> -
> -		memset(&dummyfh, 0, sizeof(dummyfh));
> -		memset(&fattr, 0, sizeof(fattr));
> -		nfs_fattr_init(&fattr);
> -		fattr.valid = NFS_ATTR_FATTR;
> -		fattr.type = NFDIR;
> -		fattr.mode = S_IFDIR | S_IRUSR | S_IWUSR;
> -		fattr.nlink = 2;
> -
> -		iroot = nfs_fhget(sb, &dummyfh, &fattr);
> -		if (IS_ERR(iroot))
> -			return ERR_PTR(PTR_ERR(iroot));
> -
> -		root = d_alloc_root(iroot);
> -		if (!root) {
> -			iput(iroot);
> -			return ERR_PTR(-ENOMEM);
> -		}
> -
> -		sb->s_root = root;
> -	}
> -
>  	/* get the info about the server and filesystem */
>  	error = nfs4_server_capabilities(server, mntfh);
>  	if (error < 0) {
> @@ -289,6 +258,10 @@ struct dentry *nfs4_get_root(struct super_block *sb, struct nfs_fh *mntfh)
>  		return ERR_PTR(PTR_ERR(inode));
>  	}
>
> +	error = nfs_superblock_set_dummy_root(sb, inode);
> +	if (error != 0)
> +		return ERR_PTR(error);
> +
>  	/* root dentries normally start off anonymous and get spliced in later
>  	 * if the dentry tree reaches them; however if the dentry already
>  	 * exists, we'll pick it up at this point and use it as the root
>
