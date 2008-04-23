Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbYDWJhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbYDWJhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbYDWJhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:37:32 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51253 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbYDWJha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:37:30 -0400
To: mtk.manpages@googlemail.com
CC: linux-fsdevel@vger.kernel.org, drepper@redhat.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-man@vger.kernel.org
In-reply-to: <47FA9DA1.8040508@gmail.com> (message from Michael Kerrisk on
	Tue, 08 Apr 2008 00:18:09 +0200)
Subject: Re: [PATCH] utimensat() non-conformances and fixes
References: <47FA9DA1.8040508@gmail.com>
Message-Id: <E1JobPU-0007o5-6H@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 23 Apr 2008 11:37:04 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Please, please, please always CC linux-fsdevel on VFS related work.
It's even in MAINTAINERS now]

> --- linux-2.6.25-rc6-orig/fs/utimes.c	2008-04-07 22:25:08.000000000 +0200
> +++ linux-2.6.25-rc6/fs/utimes.c	2008-04-07 23:57:41.000000000 +0200
> @@ -95,27 +95,37 @@
> 
>  	/* Don't worry, the checks are done in inode_change_ok() */
>  	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
> -	if (times) {
> +	if (times && ! ((times[0].tv_nsec == UTIME_NOW &&
> +			 times[1].tv_nsec == UTIME_NOW) ||
> +			(times[0].tv_nsec == UTIME_OMIT &&
> +			 times[1].tv_nsec == UTIME_OMIT))) {
>  		error = -EPERM;
>                  if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
>                          goto dput_and_out;
> 
> -		if (times[0].tv_nsec == UTIME_OMIT)
> -			newattrs.ia_valid &= ~ATTR_ATIME;
> -		else if (times[0].tv_nsec != UTIME_NOW) {
> +		if (times[0].tv_nsec == UTIME_OMIT) {
> +			newattrs.ia_atime = inode->i_atime;
> +			newattrs.ia_valid |= ATTR_ATIME_SET;

This seems wrong.  Why exactly was this change made?

Setting the time to inode->i_atime is *not* the same as not setting
the time.  For some filesystems i_atime is just a cached value, that
may or may not match the actual last access time.  For those
filesystems this could have very strange effects.

> +		} else if (times[0].tv_nsec != UTIME_NOW) {
>  			newattrs.ia_atime.tv_sec = times[0].tv_sec;
>  			newattrs.ia_atime.tv_nsec = times[0].tv_nsec;
>  			newattrs.ia_valid |= ATTR_ATIME_SET;
>  		}
> 
> -		if (times[1].tv_nsec == UTIME_OMIT)
> -			newattrs.ia_valid &= ~ATTR_MTIME;
> -		else if (times[1].tv_nsec != UTIME_NOW) {
> +		if (times[1].tv_nsec == UTIME_OMIT) {
> +			newattrs.ia_mtime = inode->i_mtime;
> +			newattrs.ia_valid |= ATTR_MTIME_SET;

Ditto.

> +		} else if (times[1].tv_nsec != UTIME_NOW) {
>  			newattrs.ia_mtime.tv_sec = times[1].tv_sec;
>  			newattrs.ia_mtime.tv_nsec = times[1].tv_nsec;
>  			newattrs.ia_valid |= ATTR_MTIME_SET;
>  		}
> +
> +	} else if (unlikely(times && times[0].tv_nsec == UTIME_OMIT &&
> +			times[1].tv_nsec == UTIME_OMIT)) {
> +		newattrs.ia_valid &= ~(ATTR_ATIME | ATTR_MTIME | ATTR_CTIME);

So this is a no-op?  In which case this check could be moved to the
top of the function to just return zero.

Miklos

>  	} else {
> +		/* times is NULL, or both tv_nsec fields are UTIME_NOW */
>  		error = -EACCES;
>                  if (IS_IMMUTABLE(inode))
>                          goto dput_and_out;
> @@ -150,14 +160,6 @@
>  	if (utimes) {
>  		if (copy_from_user(&tstimes, utimes, sizeof(tstimes)))
>  			return -EFAULT;
> -		if ((tstimes[0].tv_nsec == UTIME_OMIT ||
> -		     tstimes[0].tv_nsec == UTIME_NOW) &&
> -		    tstimes[0].tv_sec != 0)
> -			return -EINVAL;
> -		if ((tstimes[1].tv_nsec == UTIME_OMIT ||
> -		     tstimes[1].tv_nsec == UTIME_NOW) &&
> -		    tstimes[1].tv_sec != 0)
> -			return -EINVAL;
> 
>  		/* Nothing to do, we must not even check the path.  */
>  		if (tstimes[0].tv_nsec == UTIME_OMIT &&
> 
> 
> ==================================================
