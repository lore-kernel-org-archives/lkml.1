Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbYFDEmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbYFDEmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 00:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbYFDEmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 00:42:33 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39114 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbYFDEmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 00:42:32 -0400
To: mtk.manpages@googlemail.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@lst.de,
       miklos@szeredi.hu, viro@zeniv.linux.org.uk, jamie@shareable.org,
       drepper@redhat.com, linux-fsdevel@vger.kernel.org,
       subrata@linux.vnet.ibm.com
In-reply-to: <4845C4D2.8050408@gmail.com> (message from Michael Kerrisk on
	Wed, 04 Jun 2008 00:25:22 +0200)
Subject: Re: [parch 4/4] vfs: utimensat(): fix write access check for futimens()
References: <4845C4D2.8050408@gmail.com>
Message-Id: <E1K3kot-0007gz-U7@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 04 Jun 2008 06:41:55 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The POSIX.1 draft spec for futimens()/utimensat() says:
> 
>         Only a process with the effective user ID equal to the
>         user ID of the file, *or with write access to the file*,
>         or with appropriate privileges may use futimens() or
>         utimensat() with a null pointer as the times argument
>         or with both tv_nsec fields set to the special value
>         UTIME_NOW.
> 
> The important piece here is "with write access to the file", and
> this matters for futimens(), which deals with an argument that
> is a file descriptor referring to the file whose timestamps are
> being updated,  The standard is saying that the "writability"
> check is based on the file permissions, not the access mode with
> which the file is opened.  (This behavior is consistent with the
> semantics of FreeBSD's futimes().)  However, Linux is currently
> doing the latter -- futimens(fd, times) is a library
> function implemented as
> 
>        utimensat(fd, NULL, times, 0)
> 
> and within the utimensat() implementation we have the code:
> 
>                 f = fget(dfd);  // dfd is 'fd'
>                 ...
>                 if (f) {
>                         if (!(f->f_mode & FMODE_WRITE))
>                                 goto mnt_drop_write_and_out;
> 
> The check should instead be based on the file permissions.
> 
> Thanks to Miklos for pointing out how to do this check.
> 
> CC: Miklos Szeredi <miklos@szeredi.hu>
> CC: Al Viro <viro@zeniv.linux.org.uk>
> CC: Ulrich Drepper <drepper@redhat.com>
> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
> 
> --- linux-2.6.26-rc4/fs/utimes.c	2008-06-03 23:13:31.000000000 +0200
> +++ linux-2.6.26-rc4-utimensat-fix-v4/fs/utimes.c	2008-06-03 23:15:12.000000000 +0200
> @@ -137,7 +137,8 @@
> 
>  		if (!is_owner_or_cap(inode)) {
>  			if (f) {
> -				if (!(f->f_mode & FMODE_WRITE))
> +				error = permission(inode, MAY_WRITE, NULL);
> +				if (error)
>  					goto mnt_drop_write_and_out;
>  			} else {
>  				error = vfs_permission(&nd, MAY_WRITE);

At which point the "if (f)" and the "else" branches become equivalent
(the nameidata isn't interesting in the other case either).  So that
could be written as:

		if (!is_owner_or_cap(inode)) {
			error = permission(inode, MAY_WRITE, NULL);
			if (error)
				goto mnt_drop_write_and_out;
		}

Miklos
