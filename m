Return-Path: <linux-kernel-owner+w=401wt.eu-S1752670AbXCIJkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbXCIJkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 04:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbXCIJkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 04:40:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42387 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbXCIJkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 04:40:04 -0500
Date: Fri, 9 Mar 2007 09:40:00 +0000
From: Christoph Hellwig <hch@infradead.org>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, Michael Halcrow <mhalcrow@us.ibm.com>
Subject: Re: [PATCH 1/2] eCryptfs: convert lookup_one_len() to lookup_one_len_nd()
Message-ID: <20070309094000.GA28599@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org, Michael Halcrow <mhalcrow@us.ibm.com>
References: <11717026161843-git-send-email-jsipek@cs.sunysb.edu> <11717026163831-git-send-email-jsipek@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11717026163831-git-send-email-jsipek@cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 03:56:55AM -0500, Josef 'Jeff' Sipek wrote:
> From: Michael Halcrow <mhalcrow@us.ibm.com>
> 
> Call the new lookup_one_len_nd() rather than lookup_one_len().  This fixes an
> oops when stacked on NFS.
> 
> Note that there are still some issues with eCryptfs on NFS having to do with
> directory deletion (I'm not getting an oops, just an -EBUSY).

Biug NACK here.  This is just working around the broken lookup intents
code.  lookup_one_len still is a hack for some network filesystems that
unfortunately grew a few too many users.

There is a valid case for in-kernel lookups from an arbitrary point,
but lookup_one_len* is the wrong API for this.  The righ API for that
is a variant of path?lookup that takes a vfsmount + dentry pair.
Implementing this might be a good idea anyway to clean up the mess
do_path_lookup is currently.

> 
> Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
> ---
>  fs/ecryptfs/inode.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index 11f5e50..4c3d786 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -283,7 +283,9 @@ static struct dentry *ecryptfs_lookup(struct inode *dir, struct dentry *dentry,
>  	int rc = 0;
>  	struct dentry *lower_dir_dentry;
>  	struct dentry *lower_dentry;
> +	struct dentry *dentry_save;
>  	struct vfsmount *lower_mnt;
> +	struct vfsmount *mnt_save;
>  	char *encoded_name;
>  	unsigned int encoded_namelen;
>  	struct ecryptfs_crypt_stat *crypt_stat = NULL;
> @@ -310,9 +312,13 @@ static struct dentry *ecryptfs_lookup(struct inode *dir, struct dentry *dentry,
>  	}
>  	ecryptfs_printk(KERN_DEBUG, "encoded_name = [%s]; encoded_namelen "
>  			"= [%d]\n", encoded_name, encoded_namelen);
> -	lower_dentry = lookup_one_len(encoded_name, lower_dir_dentry,
> -				      encoded_namelen - 1);
> +	dentry_save = nd->dentry;
> +	mnt_save = nd->mnt;
> +	lower_dentry = lookup_one_len_nd(encoded_name, lower_dir_dentry,
> +					 (encoded_namelen - 1), nd);
>  	kfree(encoded_name);
> +	nd->mnt = mnt_save;
> +	nd->dentry = dentry_save;
>  	if (IS_ERR(lower_dentry)) {
>  		ecryptfs_printk(KERN_ERR, "ERR from lower_dentry\n");
>  		rc = PTR_ERR(lower_dentry);
> -- 
> 1.5.0.19.gddff
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
