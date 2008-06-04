Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbYFDEiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbYFDEiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 00:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbYFDEh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 00:37:57 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39104 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbYFDEh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 00:37:56 -0400
To: mtk.manpages@googlemail.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@lst.de,
       miklos@szeredi.hu, viro@zeniv.linux.org.uk, jamie@shareable.org,
       drepper@redhat.com, linux-fsdevel@vger.kernel.org,
       subrata@linux.vnet.ibm.com
In-reply-to: <4845C4CA.5070403@gmail.com> (message from Michael Kerrisk on
	Wed, 04 Jun 2008 00:25:14 +0200)
Subject: Re: [parch 3/4] vfs: utimensat(): fix error checking for {UTIME_NOW,UTIME_OMIT}
 case
References: <4845C4CA.5070403@gmail.com>
Message-Id: <E1K3kkj-0007gR-Pb@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 04 Jun 2008 06:37:37 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The POSIX.1 draft spec for utimensat() says that to do anything
> other than setting both timestamps to a time other than the
> current time (i.e., times is not NULL, and both tv_nsec fields
> are not UTIME_NOW and both tv_nsec fields are not UTIME_OMIT),
> either:
> 
> a) the caller's effective user ID must match the file owner; or
> b) the caller must have appropriate privileges.
> 
> If this condition is violated, then the error EPERM should result.
> However, the current implementation does not generate EPERM if
> one tv_nsec field is UTIME_NOW while the other is UTIME_OMIT.
> It should give this error for that case.
> 
> This patch:
> 
> a) Repairs that problem.
> b) Removes the now unneeded nsec_special() helper function.
> 
> Miklos suggested an alternative idea, migrating the
> is_owner_or_cap() checks into fs/attr.c:inode_change_ok() via
> the use of an ATTR_OWNER_CHECK flag.  Maybe we could do that
> later, but for now I've gone with this version, which is
> simpler, and can be more easily read as being correct.

Wise decision.

> CC: Miklos Szeredi <miklos@szeredi.hu>
> CC: Al Viro <viro@zeniv.linux.org.uk>
> CC: Ulrich Drepper <drepper@redhat.com>
> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
> 
> 
> --- linux-2.6.26-rc4/fs/utimes.c	2008-06-03 23:11:53.000000000 +0200
> +++ linux-2.6.26-rc4-utimensat-fix-v4/fs/utimes.c	2008-06-03 23:04:48.000000000 +0200
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
> @@ -135,8 +130,7 @@
>  	 * UTIME_NOW, then need to check permissions, because
>  	 * inode_change_ok() won't do it.
>  	 */
> -	if (!times || (nsec_special(times[0].tv_nsec) &&
> -		       nsec_special(times[1].tv_nsec))) {
> +	if (!times) {

This can be restored to be the "else" branch of the "if (times)".

>  		error = -EACCES;
>                  if (IS_IMMUTABLE(inode))
>  			goto mnt_drop_write_and_out;
> @@ -151,6 +145,18 @@
>  					goto mnt_drop_write_and_out;
>  			}
>  		}
> +	} else if ((times[0].tv_nsec == UTIME_NOW &&
> +		    times[1].tv_nsec == UTIME_OMIT)
> +		  ||
> +		   (times[0].tv_nsec == UTIME_OMIT &&
> +		    times[1].tv_nsec == UTIME_NOW)) {

And I'd rather put this inside the "if (times)" for clarity.

> +		error =-EPERM;
> +
> +		if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> +			goto mnt_drop_write_and_out;

And then you would've realized, that this check was already done.

> +
> +		if (!is_owner_or_cap(inode))
> +			goto mnt_drop_write_and_out;

OK.

>  	}
>  	mutex_lock(&inode->i_mutex);
>  	error = notify_change(dentry, &newattrs);
> 
> 
> 
