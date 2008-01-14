Return-Path: <linux-kernel-owner+w=401wt.eu-S1752903AbYANVsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbYANVsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755753AbYANVsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:48:37 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51940 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531AbYANVsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:48:35 -0500
Date: Mon, 14 Jan 2008 15:48:41 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, ebiederm@xmission.com, kzak@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org
Subject: Re: [patch 2/9] unprivileged mounts: allow unprivileged umount
Message-ID: <20080114214841.GB6704@sergelap.austin.ibm.com>
References: <20080108113502.184459371@szeredi.hu> <20080108113620.664824939@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108113620.664824939@szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> The owner doesn't need sysadmin capabilities to call umount().
> 
> Similar behavior as umount(8) on mounts having "user=UID" option in /etc/mtab.
> The difference is that umount also checks /etc/fstab, presumably to exclude
> another mount on the same mountpoint.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
> 
> Index: linux/fs/namespace.c
> ===================================================================
> --- linux.orig/fs/namespace.c	2008-01-03 20:52:38.000000000 +0100
> +++ linux/fs/namespace.c	2008-01-03 21:14:16.000000000 +0100
> @@ -894,6 +894,27 @@ static int do_umount(struct vfsmount *mn
>  	return retval;
>  }
> 
> +static bool is_mount_owner(struct vfsmount *mnt, uid_t uid)
> +{
> +	return (mnt->mnt_flags & MNT_USER) && mnt->mnt_uid == uid;
> +}
> +
> +/*
> + * umount is permitted for
> + *  - sysadmin
> + *  - mount owner, if not forced umount
> + */
> +static bool permit_umount(struct vfsmount *mnt, int flags)
> +{
> +	if (capable(CAP_SYS_ADMIN))
> +		return true;
> +
> +	if (flags & MNT_FORCE)
> +		return false;
> +
> +	return is_mount_owner(mnt, current->fsuid);
> +}
> +
>  /*
>   * Now umount can handle mount points as well as block devices.
>   * This is important for filesystems which use unnamed block devices.
> @@ -917,7 +938,7 @@ asmlinkage long sys_umount(char __user *
>  		goto dput_and_out;
> 
>  	retval = -EPERM;
> -	if (!capable(CAP_SYS_ADMIN))
> +	if (!permit_umount(nd.path.mnt, flags))
>  		goto dput_and_out;
> 
>  	retval = do_umount(nd.path.mnt, flags);
> 
> --
