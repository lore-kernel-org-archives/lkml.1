Return-Path: <linux-kernel-owner+w=401wt.eu-S1753560AbYK2I3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbYK2I3j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 03:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbYK2I33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 03:29:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbYK2I32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 03:29:28 -0500
Date: Sat, 29 Nov 2008 00:29:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mingo@redhat.com, val.henson@gmail.com
Subject: Re: [PATCH 1/2] relatime: Make atime updates more useful
Message-Id: <20081129002907.17f7714e.akpm@linux-foundation.org>
In-Reply-To: <20081126195457.GA3541@srcf.ucam.org>
References: <20081126195457.GA3541@srcf.ucam.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008 19:54:57 +0000 Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> Allow atime to be updated once per day even with relatime enabled. This 
> lets utilities like tmpreaper (which deletes files based on last access 
> time) continue working.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> ---
> 
> Updated version of Ingo's patch from last year - this section is 
> identical.
> 
> commit 2c145e187600ca961715fa82ae3ae7919d744bc9
> Author: Matthew Garrett <mjg@redhat.com>
> Date:   Wed Nov 26 17:44:07 2008 +0000
> 
>     Make relatime smarter
>     
>     Allow atime to be updated once per day even with relatime. This lets
>     utilities like tmpreaper (which delete files based on last access time)
>     continue working.
> 

Two changelogs always sends me into a panic.  It's easier when they are
identical ;)

> index 0487ddb..348fa16 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1179,6 +1179,41 @@ sector_t bmap(struct inode * inode, sector_t block)
>  }
>  EXPORT_SYMBOL(bmap);
>  
> +/*
> + * Relative atime updates frequency (default: 1 day):
> + */
> +int relatime_interval __read_mostly = 24*60*60;

I assume that it's global for the benefit of the second patch.

Yes, we do put a lot of extern-decls-in-C over in sysctl.c.  But that
doesn't make it good.  It would be better to add the declaration to a
header which is visible to all sites which use the symbol.

We should perhaps have a standalone sysctl-definitions.h for this
purpose, so we don't end up having to #include <everything> in
sysctl.c.

> +/*
> + * With relative atime, only update atime if the
> + * previous atime is earlier than either the ctime or
> + * mtime.
> + */
> +static int relatime_need_update(struct inode *inode, struct timespec now)
> +{
> +	/*
> +	 * Is mtime younger than atime? If yes, update atime:
> +	 */
> +	if (timespec_compare(&inode->i_mtime, &inode->i_atime) >= 0)
> +		return 1;
> +	/*
> +	 * Is ctime younger than atime? If yes, update atime:
> +	 */
> +	if (timespec_compare(&inode->i_ctime, &inode->i_atime) >= 0)
> +		return 1;
> +
> +	/*
> +	 * Is the previous atime value older than the update interval?
> +	 * If yes, update atime:
> +	 */
> +	if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= relatime_interval)
> +		return 1;

I dunno what type those tv_secs have, but the whole thing is cast to a
long and is then signed-compared with an integer.

Is this correct and intended?  I guess it is, but..  just checking?

> +	/*
> +	 * Good, we can skip the atime update:
> +	 */
> +	return 0;
> +}
> +
>  /**
>   *	touch_atime	-	update the access time
>   *	@mnt: mount the inode is accessed on
> @@ -1206,17 +1241,12 @@ void touch_atime(struct vfsmount *mnt, struct dentry *dentry)
>  		goto out;
>  	if ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode))
>  		goto out;
> -	if (mnt->mnt_flags & MNT_RELATIME) {
> -		/*
> -		 * With relative atime, only update atime if the previous
> -		 * atime is earlier than either the ctime or mtime.
> -		 */
> -		if (timespec_compare(&inode->i_mtime, &inode->i_atime) < 0 &&
> -		    timespec_compare(&inode->i_ctime, &inode->i_atime) < 0)
> -			goto out;
> -	}
>  
>  	now = current_fs_time(inode->i_sb);
> +
> +	if (mnt->mnt_flags & MNT_RELATIME)
> +		if (!relatime_need_update(inode, now))
> +			goto out;
>  	if (timespec_equal(&inode->i_atime, &now))
>  		goto out;

