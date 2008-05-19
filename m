Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbYESJuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbYESJuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 05:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbYESJum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 05:50:42 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36992 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbYESJul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 05:50:41 -0400
To: mtk.manpages@googlemail.com
CC: miklos@szeredi.hu, mtk.manpages@googlemail.com, drepper@redhat.com,
       viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <482F38A1.9070704@gmail.com> (message from Michael Kerrisk on
	Sat, 17 May 2008 21:57:21 +0200)
Subject: Re: [PATCH] utimensat() non-conformances and fixes -- version 2
References: <482D4665.4050401@gmail.com> <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu> <482F38A1.9070704@gmail.com>
Message-Id: <E1Jy20a-0007pv-Ij@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 19 May 2008 11:50:20 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Regarding your suggestions above, are you meaning something like the
> patch below?

Yes.

> The patch is a little less pretty than I'd like because of the need to
> return EACCES or EPERM depending on whether (times == NULL).  In
> particular, these lines in utimes.c:
> 
> +	if (!times && error == -EPERM)
> +		error = -EACCES;
> 
> seem a little fragile (but maybe I worry too much).

It's not only fragile, it's ugly as sin.  I'd rather do it this way:

- initialize error to zero
- if no write access then set error, and the ATTR_TIMES_UPDATE(*) flag
- set error2 from result of notify_change()
- if error is zero then return error2, otherwise return error

(*) I've been mulling over the name and perhaps ATTR_OWNER_CHECK would
be better, or something that implies that it's not really about
updating the times, but about checking the owner.

Also could you do the patch against the

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git vfs-cleanups

tree, which does big structural cleanups to do_utimes?

Thanks,
Miklos

> ========================
> 
> diff -ru linux-2.6.26-rc2/fs/attr.c linux-2.6.26-rc2-utimensat-fix/fs/attr.c
> --- linux-2.6.26-rc2/fs/attr.c	2008-01-24 23:58:37.000000000 +0100
> +++ linux-2.6.26-rc2-utimensat-fix/fs/attr.c	2008-05-16 21:56:51.000000000 +0200
> @@ -51,7 +51,8 @@
>  	}
> 
>  	/* Check for setting the inode time. */
> -	if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET)) {
> +	if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET |
> +			ATTR_TIMES_UPDATE)) {
>  		if (!is_owner_or_cap(inode))
>  			goto error;
>  	}
> diff -ru linux-2.6.26-rc2/fs/utimes.c linux-2.6.26-rc2-utimensat-fix/fs/utimes.c
> --- linux-2.6.26-rc2/fs/utimes.c	2008-05-15 10:33:20.000000000 +0200
> +++ linux-2.6.26-rc2-utimensat-fix/fs/utimes.c	2008-05-16 22:14:31.000000000 +0200
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
> @@ -102,11 +97,15 @@
>  	if (error)
>  		goto dput_and_out;
> 
> +	if (times && times[0].tv_nsec == UTIME_NOW &&
> +		     times[1].tv_nsec == UTIME_NOW)
> +		times = NULL;
> +
>  	/* Don't worry, the checks are done in inode_change_ok() */
>  	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
>  	if (times) {
>  		error = -EPERM;
> -                if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> +		if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
>  			goto mnt_drop_write_and_out;
> 
>  		if (times[0].tv_nsec == UTIME_OMIT)
> @@ -131,25 +130,39 @@
>  	 * UTIME_NOW, then need to check permissions, because
>  	 * inode_change_ok() won't do it.
>  	 */
> -	if (!times || (nsec_special(times[0].tv_nsec) &&
> -		       nsec_special(times[1].tv_nsec))) {
> +	if (!times) {
>  		error = -EACCES;
>                  if (IS_IMMUTABLE(inode))
>  			goto mnt_drop_write_and_out;
> 
> -		if (!is_owner_or_cap(inode)) {
> -			if (f) {
> -				if (!(f->f_mode & FMODE_WRITE))
> -					goto mnt_drop_write_and_out;
> -			} else {
> -				error = vfs_permission(&nd, MAY_WRITE);
> -				if (error)
> -					goto mnt_drop_write_and_out;
> -			}
> +		if (f) {
> +			if (!(f->f_mode & FMODE_WRITE))
> +				newattrs.ia_valid |= ATTR_TIMES_UPDATE;
> +		} else {
> +			error = vfs_permission(&nd, MAY_WRITE);
> +			if (error == -EACCES)
> +				newattrs.ia_valid |= ATTR_TIMES_UPDATE;
> +			else if (error)
> +				goto mnt_drop_write_and_out;
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
> +		newattrs.ia_valid |= ATTR_TIMES_UPDATE;
>  	}
> +
>  	mutex_lock(&inode->i_mutex);
>  	error = notify_change(dentry, &newattrs);
> +	if (!times && error == -EPERM)
> +		error = -EACCES;
> +		
>  	mutex_unlock(&inode->i_mutex);
>  mnt_drop_write_and_out:
>  	mnt_drop_write(mnt);
> diff -ru linux-2.6.26-rc2/include/linux/fs.h linux-2.6.26-rc2-utimensat-fix/include/linux/fs.h
> --- linux-2.6.26-rc2/include/linux/fs.h	2008-05-15 10:33:25.000000000 +0200
> +++ linux-2.6.26-rc2-utimensat-fix/include/linux/fs.h	2008-05-16 21:39:24.000000000 +0200
> @@ -317,22 +317,23 @@
>   * Attribute flags.  These should be or-ed together to figure out what
>   * has been changed!
>   */
> -#define ATTR_MODE	1
> -#define ATTR_UID	2
> -#define ATTR_GID	4
> -#define ATTR_SIZE	8
> -#define ATTR_ATIME	16
> -#define ATTR_MTIME	32
> -#define ATTR_CTIME	64
> -#define ATTR_ATIME_SET	128
> -#define ATTR_MTIME_SET	256
> -#define ATTR_FORCE	512	/* Not a change, but a change it */
> -#define ATTR_ATTR_FLAG	1024
> -#define ATTR_KILL_SUID	2048
> -#define ATTR_KILL_SGID	4096
> -#define ATTR_FILE	8192
> -#define ATTR_KILL_PRIV	16384
> -#define ATTR_OPEN	32768	/* Truncating from open(O_TRUNC) */
> +#define ATTR_MODE		1
> +#define ATTR_UID		2
> +#define ATTR_GID		4
> +#define ATTR_SIZE		8
> +#define ATTR_ATIME		16
> +#define ATTR_MTIME		32
> +#define ATTR_CTIME		64
> +#define ATTR_ATIME_SET		128
> +#define ATTR_MTIME_SET		256
> +#define ATTR_FORCE		512	/* Not a change, but a change it */
> +#define ATTR_ATTR_FLAG		1024
> +#define ATTR_KILL_SUID		2048
> +#define ATTR_KILL_SGID		4096
> +#define ATTR_FILE		8192
> +#define ATTR_KILL_PRIV		16384
> +#define ATTR_OPEN		32768	/* Truncating from open(O_TRUNC) */
> +#define ATTR_TIMES_UPDATE	65536
> 
>  /*
>   * This is the Inode Attributes structure, used for notify_change().  It
> 
