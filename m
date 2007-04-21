Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbXDUNbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbXDUNbk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 09:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbXDUNbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 09:31:39 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41224 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442AbXDUNbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 09:31:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [patch 2/8] allow unprivileged umount
References: <20070420102532.385211890@szeredi.hu>
	<20070420102626.825263599@szeredi.hu>
Date: Sat, 21 Apr 2007 07:29:51 -0600
In-Reply-To: <20070420102626.825263599@szeredi.hu> (Miklos Szeredi's message
	of "Fri, 20 Apr 2007 12:25:34 +0200")
Message-ID: <m1slatkg8g.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> From: Miklos Szeredi <mszeredi@suse.cz>
>
> The owner doesn't need sysadmin capabilities to call umount().
>
> Similar behavior as umount(8) on mounts having "user=UID" option in
> /etc/mtab.  The difference is that umount also checks /etc/fstab,
> presumably to exclude another mount on the same mountpoint.
>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>
> Index: linux/fs/namespace.c
> ===================================================================
> --- linux.orig/fs/namespace.c	2007-04-20 11:55:05.000000000 +0200
> +++ linux/fs/namespace.c	2007-04-20 11:55:06.000000000 +0200
> @@ -659,6 +659,25 @@ static int do_umount(struct vfsmount *mn
>  }
>  
>  /*
> + * umount is permitted for
> + *  - sysadmin
> + *  - mount owner, if not forced umount
> + */
> +static bool permit_umount(struct vfsmount *mnt, int flags)
> +{
> +	if (capable(CAP_SYS_ADMIN))
> +		return true;
> +
> +	if (!(mnt->mnt_flags & MNT_USER))
> +		return false;
> +
> +	if (flags & MNT_FORCE)
> +		return false;
> +
> +	return mnt->mnt_uid == current->uid;
> +}

I think this should be:

static bool permit_umount(struct vfsmount *mnt, int flags)
{
	if ((mnt->mnt_uid != current->fsuid) &&	!capable(CAP_SETUID))
        	return false;

	if ((flags & MNT_FORCE) && !capable(CAP_SYS_ADMIN))
		return false;

	return true;
}

I.e. 
  MNT_USER gone.
  compare against fsuid.
  Only require setuid for unmounts unless force is specified.

  I suspect we can allow MNT_FORCE for non-privileged users 
  as well if we can trust the filesystem.

> +/*
>   * Now umount can handle mount points as well as block devices.
>   * This is important for filesystems which use unnamed block devices.
>   *
> @@ -681,7 +700,7 @@ asmlinkage long sys_umount(char __user *
>  		goto dput_and_out;
>  
>  	retval = -EPERM;
> -	if (!capable(CAP_SYS_ADMIN))
> +	if (!permit_umount(nd.mnt, flags))
>  		goto dput_and_out;
>  
>  	retval = do_umount(nd.mnt, flags);
>
> --
