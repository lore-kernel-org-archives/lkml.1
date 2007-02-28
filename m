Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbXB1SvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbXB1SvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 13:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932286AbXB1SvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 13:51:12 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48620 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290AbXB1SvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 13:51:10 -0500
Date: Wed, 28 Feb 2007 12:51:08 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Dmitriy Monakhov <dmonakhov@sw.ru>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ecryptfs: check xattr operation support fix
Message-ID: <20070228185108.GA3713@us.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <871wkaxlf7.fsf@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871wkaxlf7.fsf@sw.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 08:05:16PM +0300, Dmitriy Monakhov wrote:
>   - ecryptfs_write_inode_size_to_metadata() error code was ignored.
>   - i_op->setxattr() must be supported by lower fs because used below.
> 
> Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>

Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>

> ---
>  fs/ecryptfs/inode.c |    6 +++---
>  fs/ecryptfs/mmap.c  |    3 ++-
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index 27fd14a..9ccefad 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -168,9 +168,9 @@ static int grow_file(struct dentry *ecryptfs_dentry, struct file *lower_file,
>  		goto out;
>  	}
>  	i_size_write(inode, 0);
> -	ecryptfs_write_inode_size_to_metadata(lower_file, lower_inode, inode,
> -					      ecryptfs_dentry,
> -					      ECRYPTFS_LOWER_I_MUTEX_NOT_HELD);
> +	rc = ecryptfs_write_inode_size_to_metadata(lower_file, lower_inode,
> +			inode, ecryptfs_dentry,
> +			ECRYPTFS_LOWER_I_MUTEX_NOT_HELD);
>  	ecryptfs_inode_to_private(inode)->crypt_stat.flags |= ECRYPTFS_NEW_FILE;
>  out:
>  	return rc;
> diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
> index 1e5d2ba..416985f 100644
> --- a/fs/ecryptfs/mmap.c
> +++ b/fs/ecryptfs/mmap.c
> @@ -491,7 +491,8 @@ static int ecryptfs_write_inode_size_to_xattr(struct inode *lower_inode,
>  		goto out;
>  	}
>  	lower_dentry = ecryptfs_dentry_to_lower(ecryptfs_dentry);
> -	if (!lower_dentry->d_inode->i_op->getxattr) {
> +	if (!lower_dentry->d_inode->i_op->getxattr ||
> +			!lower_dentry->d_inode->i_op->setxattr) {
>  		printk(KERN_WARNING
>  		       "No support for setting xattr in lower filesystem\n");
>  		rc = -ENOSYS;
