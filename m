Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbYEOHYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbYEOHYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 03:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbYEOHYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 03:24:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34093 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbYEOHYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 03:24:07 -0400
Date: Thu, 15 May 2008 08:23:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 08/24] vfs: immutable inode checking cleanup
Message-ID: <20080515072358.GS13907@ZenIV.linux.org.uk>
References: <20080506091327.259950960@szeredi.hu> <20080506091416.025653274@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506091416.025653274@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- linux-2.6.orig/fs/attr.c	2008-05-06 11:04:29.000000000 +0200
> +++ linux-2.6/fs/attr.c	2008-05-06 11:04:35.000000000 +0200
> @@ -108,6 +108,12 @@ int notify_change(struct dentry * dentry
>  	struct timespec now;
>  	unsigned int ia_valid = attr->ia_valid;
>  
> +	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID |
> +			ATTR_ATIME_SET | ATTR_MTIME_SET)) {
> +		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
> +			return -EPERM;
> +	}
> +
>  	now = current_fs_time(inode->i_sb);
>  
>  	attr->ia_ctime = now;
> Index: linux-2.6/fs/utimes.c
> ===================================================================
> --- linux-2.6.orig/fs/utimes.c	2008-05-06 11:04:29.000000000 +0200
> +++ linux-2.6/fs/utimes.c	2008-05-06 11:04:35.000000000 +0200
> @@ -105,10 +105,6 @@ long do_utimes(int dfd, char __user *fil
>  	/* Don't worry, the checks are done in inode_change_ok() */
>  	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
>  	if (times) {
> -		error = -EPERM;
> -                if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> -			goto mnt_drop_write_and_out;
> -
>  		if (times[0].tv_nsec == UTIME_OMIT)
>  			newattrs.ia_valid &= ~ATTR_ATIME;
>  		else if (times[0].tv_nsec != UTIME_NOW) {

Erm...  What happens if we have UTIME_NOW on both and inode is marked
immutable?  AFAICS, you've just switched from -EPERM to -EACCES.
For append-only it's even more interesting - you go from -EPERM to
success.

It might or might not be the right thing to do, and the syscall is
new, but...  Do you have an ACK from Ulrich?
