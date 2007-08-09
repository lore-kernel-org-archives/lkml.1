Return-Path: <linux-kernel-owner+w=401wt.eu-S1760669AbXHITVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669AbXHITVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 15:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbXHITUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 15:20:53 -0400
Received: from smtp114.sbc.mail.re2.yahoo.com ([68.142.229.91]:20313 "HELO
	smtp114.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754800AbXHITUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 15:20:52 -0400
X-YMail-OSG: 6RAIMmQVM1k5ygPEj16uvpaO29adRIRDHPW1ToVxxW37zSUYqYTCvWB1Z0aZuL4ne3oWF7omZM6u_BWsfezoNcDc2avNtkPGd6_EszNEAqDq0.3FiW0-
Date: Thu, 9 Aug 2007 14:20:45 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 4/4] VFS: allow filesystem to override mknod capability checks
Message-ID: <20070809192045.GA16682@vino.hallyn.com>
References: <20070809152744.519270818@szeredi.hu> <20070809152909.203254312@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070809152909.203254312@szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting miklos@szeredi.hu (miklos@szeredi.hu):
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add a new filesystem flag, that results in the VFS not checking if the
> current process has enough privileges to do an mknod().
> 
> This is needed on filesystems, where an unprivileged user may be able
> to create a device node, without causing security problems.
> 
> One such example is "mountlo" a loopback mount utility implemented
> with fuse and UML, which runs as an unprivileged userspace process.
> In this case the user does in fact have the right to create device
> nodes within the filesystem image, as long as the user has write
> access to the image.  Since the filesystem is mounted with "nodev",
> adding device nodes is not a security concern.

Could we enforce at do_new_mount() that if
type->fs_flags&FS_MKNOD_CHECKS_PERM then mnt_flags |= MS_NODEV?

> This feature is basically "fuse-only", so it does not make sense to
> change the semantics of ->mknod().
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
> 
> Index: linux/fs/namei.c
> ===================================================================
> --- linux.orig/fs/namei.c	2007-08-09 16:49:07.000000000 +0200
> +++ linux/fs/namei.c	2007-08-09 16:49:12.000000000 +0200
> @@ -1921,7 +1921,8 @@ int vfs_mknod(struct inode *dir, struct 
>  	if (error)
>  		return error;
>  
> -	if ((S_ISCHR(mode) || S_ISBLK(mode)) && !capable(CAP_MKNOD))
> +	if (!(dir->i_sb->s_type->fs_flags & FS_MKNOD_CHECKS_PERM) &&
> +	    (S_ISCHR(mode) || S_ISBLK(mode)) && !capable(CAP_MKNOD))
>  		return -EPERM;
>  
>  	if (!dir->i_op || !dir->i_op->mknod)
> Index: linux/include/linux/fs.h
> ===================================================================
> --- linux.orig/include/linux/fs.h	2007-08-09 16:49:07.000000000 +0200
> +++ linux/include/linux/fs.h	2007-08-09 16:49:12.000000000 +0200
> @@ -97,6 +97,7 @@ extern int dir_notify_enable;
>  #define FS_BINARY_MOUNTDATA 2
>  #define FS_HAS_SUBTYPE 4
>  #define FS_SAFE 8		/* Safe to mount by unprivileged users */
> +#define FS_MKNOD_CHECKS_PERM 16	/* FS checks if device creation is allowed */
>  #define FS_REVAL_DOT	16384	/* Check the paths ".", ".." for staleness */
>  #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move()
>  					 * during rename() internally.
> 
> --
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
