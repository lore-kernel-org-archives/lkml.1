Return-Path: <linux-kernel-owner+w=401wt.eu-S1752231AbZLAELY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbZLAELY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 23:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbZLAELW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 23:11:22 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50728 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbZLAELS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 23:11:18 -0500
Date: Mon, 30 Nov 2009 23:10:58 -0500
Message-Id: <200912010410.nB14AwWh030303@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/41] union-mount: stop lookup when directory has S_OPAQUE flag set 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:23 PDT."
             <1256152779-10054-26-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-26-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> From: Jan Blunck <jblunck@suse.de>
> 
> Honor the S_OPAQUE flag in the union path lookup.

Was it intentional to have a separate patch which adds opaque directories
support, or should it be part of the larger patch #24?

> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/namei.c |   17 ++++++++++++++---
>  1 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index b279686..8ebbf4f 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -523,6 +523,9 @@ static int __cache_lookup_build_union(struct nameidata *nd, struct qstr *name,
>  			path_put(&last);
>  		last.dentry = dentry;
>  		last.mnt = mntget(nd->path.mnt);
> +
> +		if (IS_OPAQUE(last.dentry->d_inode))
> +			break;
>  	}
>  
>  	if (last.dentry != path->dentry)
> @@ -562,7 +565,8 @@ static int cache_lookup_union(struct nameidata *nd, struct qstr *name,
>  
>  		/* only directories can be part of a union stack */
>  		if (!path->dentry->d_inode ||
> -		    !S_ISDIR(path->dentry->d_inode->i_mode))
> +		    !S_ISDIR(path->dentry->d_inode->i_mode) ||
> +		    IS_OPAQUE(path->dentry->d_inode))
>  			goto out;
>  
>  		/* Build the union stack for this part */
> @@ -804,6 +808,9 @@ static int __real_lookup_build_union(struct nameidata *nd, struct qstr *name,
>  			path_put(&last);
>  		last.dentry = next.dentry;
>  		last.mnt = mntget(next.mnt);
> +
> +		if (IS_OPAQUE(last.dentry->d_inode))
> +			break;
>  	}
>  
>  	if (last.dentry != path->dentry)
> @@ -825,7 +832,8 @@ static int real_lookup_union(struct nameidata *nd, struct qstr *name,
>  
>  	/* only directories can be part of a union stack */
>  	if (!path->dentry->d_inode ||
> -	    !S_ISDIR(path->dentry->d_inode->i_mode))
> +	    !S_ISDIR(path->dentry->d_inode->i_mode) ||
> +	    IS_OPAQUE(path->dentry->d_inode))
>  		goto out;
>  
>  	/* Build the union stack for this part */
> @@ -1111,7 +1119,7 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
>  {
>  	int err;
>  
> -	if (IS_MNT_UNION(nd->path.mnt))
> +	if (IS_MNT_UNION(nd->path.mnt) && !IS_OPAQUE(nd->path.dentry->d_inode))
>  		goto need_union_lookup;
>  
>  	path->dentry = __d_lookup(nd->path.dentry, name);
> @@ -1676,6 +1684,9 @@ static int __hash_lookup_build_union(struct nameidata *nd, struct qstr *name,
>  			path_put(&last);
>  		last.dentry = next.dentry;
>  		last.mnt = mntget(next.mnt);
> +
> +		if (IS_OPAQUE(last.dentry->d_inode))
> +			break;
>  	}
>  
>  	if (last.dentry != path->dentry)
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Erez.
