Return-Path: <linux-kernel-owner+w=401wt.eu-S1756459AbYEPQ7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbYEPQ7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYEPQ7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:59:31 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51891 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbYEPQ7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:59:30 -0400
To: mtk.manpages@googlemail.com
CC: miklos@szeredi.hu, drepper@redhat.com, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-man@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <482D4665.4050401@gmail.com> (message from Michael Kerrisk on
	Fri, 16 May 2008 10:31:33 +0200)
Subject: Re: [PATCH] utimensat() non-conformances and fixes -- version 2
References: <482D4665.4050401@gmail.com>
Message-Id: <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 16 May 2008 18:59:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a revised version of my earlier
> (http://article.gmane.org/gmane.linux.man/129/ ) patch to fix
> non-conformances in the utimensat() implementation.

The patch looks functionally correct.  But there are several things I
don't really like...

> --- linux-2.6.26-rc2/fs/utimes.c	2008-05-15 10:33:20.000000000 +0200
> +++ linux-2.6.26-rc2-mtk/fs/utimes.c	2008-05-16 07:33:02.000000000 +0200
> @@ -40,14 +40,9 @@
> 
>  #endif
> 
> -static bool nsec_special(long nsec)
> -{
> -	return nsec == UTIME_OMIT || nsec == UTIME_NOW;
> -}
> -
>  static bool nsec_valid(long nsec)
>  {
> -	if (nsec_special(nsec))
> +	if (nsec == UTIME_OMIT || nsec == UTIME_NOW)
>  		return true;
> 
>  	return nsec >= 0 && nsec <= 999999999;
> @@ -106,7 +101,9 @@
>  	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
>  	if (times) {
>  		error = -EPERM;
> -                if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> +		if (!(times[0].tv_nsec == UTIME_NOW &&
> +		      times[1].tv_nsec == UTIME_NOW) &&
> +		    (IS_IMMUTABLE(inode) || IS_APPEND(inode)))
>  			goto mnt_drop_write_and_out;
> 
>  		if (times[0].tv_nsec == UTIME_OMIT)
> @@ -131,9 +128,10 @@
>  	 * UTIME_NOW, then need to check permissions, because
>  	 * inode_change_ok() won't do it.
>  	 */
> -	if (!times || (nsec_special(times[0].tv_nsec) &&
> -		       nsec_special(times[1].tv_nsec))) {
> +	if (!times || (times[0].tv_nsec == UTIME_NOW &&
> +		       times[1].tv_nsec == UTIME_NOW)) {
>  		error = -EACCES;
> +

How about explicitly turning UTIME_NOW/UTIME_NOW into times = NULL at
the beginning of the function?  That would both simplify things and
also make it absolutely sure that the two cases are handled the same
way (which makes sense, and is also what the standard wants).

>                  if (IS_IMMUTABLE(inode))
>  			goto mnt_drop_write_and_out;
> 
> @@ -147,7 +145,20 @@
>  					goto mnt_drop_write_and_out;
>  			}
>  		}
> +	} else if (times && ((times[0].tv_nsec == UTIME_NOW &&
> +			      times[1].tv_nsec == UTIME_OMIT)
> +			     ||
> +			     (times[0].tv_nsec == UTIME_OMIT &&
> +			      times[1].tv_nsec == UTIME_NOW))) {
> +		error = -EPERM;
> +
> +		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
> +			goto mnt_drop_write_and_out;
> +
> +		if (!is_owner_or_cap(inode))
> +			goto mnt_drop_write_and_out;

I don't like adding _more_ owner checks to this function.  It would be
better if we were removing them: some weird filesystems want to do
their own permission checking and so the owner checks should really be
moved into inode_change_ok().

One way to do that could be to add a pseudo attribute flag,
e.g. ATTR_TIMES_UPDATE, that tells the permission checking code to
check the owner, even when neither ATTR_[AM]TIME_SET flag is set.

Even the check for the owner in the !times case could be removed, by
adding ATTR_TIMES_UPDATE only if we don't have write permission on the
file.  That's a cleanup I'd really be happy with.

All this may also be done with the ATTR_FORCE flag, but that would
mean:

  - modifying lots of call sites
  - making it impossible to selectively check the permission if
    multiple attributes are being modified (don't know if any callers
    want that though).

Miklos
