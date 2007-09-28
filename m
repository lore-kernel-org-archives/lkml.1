Return-Path: <linux-kernel-owner+w=401wt.eu-S1761214AbXI1Ckr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761214AbXI1Ckr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 22:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbXI1Cki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 22:40:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47556 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbXI1Ckh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 22:40:37 -0400
From: Neil Brown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 28 Sep 2007 12:40:27 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18172.27035.251565.338666@notabene.brown>
Cc: hch@infradead.org, trond.myklebust@fys.uio.no, adilger@clusterfs.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 2/2] VFS: allow filesystem to override mknod capability checks
In-Reply-To: message from Miklos Szeredi on Monday September 24
References: <E1IZmze-0003q9-00@dorka.pomaz.szeredi.hu>
	<E1IZn0c-0003qS-00@dorka.pomaz.szeredi.hu>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday September 24, miklos@szeredi.hu wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add a new super block flag, that results in the VFS not checking if
> the current process has enough privileges to do an mknod().
> 
> If this flag is set, all mounts for this super block will have the
> "nodev" flag implied.
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

I must admit that I don't feel very comfortable about this.  I wonder
how many more flags we might be tempted to add to allow
user-controlled filesystems to do interesting things.  Somehow I doubt
this will be the last, so we should be very careful allowing it to be
the first (or is it the second already?)

A more concrete comment on the patch:  Is it really necessary to
introduce IS_MNT_NODEV??  Why not simply test both the flags
(MS_MKNOD_NOCAP and MNT_NODEV) before allowing the mknod?  That would
localise the change to where is it really relevant.

Do we actually need a new flag?  Would not a combination of MS_NODEV
and MS_SETUSER achieve the same thing (near enough)?

Do you imagine this flag being set as a mount option (-o unprivmknod)
or does the filesystem set it itself?
If the latter, maybe this test should be moved down into the
filesystems ->mknod operation.  Most filesystems get
 
	if ((S_ISCHR(mode) || S_ISBLK(mode)) && !capable(CAP_MKNOD))
 		return -EPERM;

at the top of ->mknod.  fuse can do whatever it likes without
bothering common code.

According to fs.h, we only support 32 fs-independent mount-flags, and
over half are in use.  I'm not convinced we should spend one on such a
narrow requirement.

NeilBrown


> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
> 
> Index: linux/fs/namei.c
> ===================================================================
> --- linux.orig/fs/namei.c	2007-09-24 13:52:17.000000000 +0200
> +++ linux/fs/namei.c	2007-09-24 13:54:57.000000000 +0200
> @@ -1617,7 +1617,7 @@ int may_open(struct nameidata *nd, int a
>  	if (S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
>  	    	flag &= ~O_TRUNC;
>  	} else if (S_ISBLK(inode->i_mode) || S_ISCHR(inode->i_mode)) {
> -		if (nd->mnt->mnt_flags & MNT_NODEV)
> +		if (IS_MNT_NODEV(nd->mnt))
>  			return -EACCES;
>  
>  		flag &= ~O_TRUNC;
> @@ -1920,7 +1920,8 @@ int vfs_mknod(struct inode *dir, struct 
>  	if (error)
>  		return error;
>  
> -	if ((S_ISCHR(mode) || S_ISBLK(mode)) && !capable(CAP_MKNOD))
> +	if (!(dir->i_sb->s_flags & MS_MKNOD_NOCAP) &&
> +	    (S_ISCHR(mode) || S_ISBLK(mode)) && !capable(CAP_MKNOD))
>  		return -EPERM;
>  
>  	if (!dir->i_op || !dir->i_op->mknod)
> Index: linux/include/linux/fs.h
> ===================================================================
> --- linux.orig/include/linux/fs.h	2007-09-24 13:52:17.000000000 +0200
> +++ linux/include/linux/fs.h	2007-09-24 13:54:57.000000000 +0200
> @@ -130,6 +130,8 @@ extern int dir_notify_enable;
>  #define MS_SETUSER	(1<<23) /* set mnt_uid to current user */
>  #define MS_NOMNT	(1<<24) /* don't allow unprivileged submounts */
>  #define MS_KERNMOUNT	(1<<25) /* this is a kern_mount call */
> +#define MS_MKNOD_NOCAP	(1<<26) /* no capability check in mknod,
> +				   implies "nodev" */
>  #define MS_ACTIVE	(1<<30)
>  #define MS_NOUSER	(1<<31)
>  
> @@ -190,6 +192,10 @@ extern int dir_notify_enable;
>  #define IS_SWAPFILE(inode)	((inode)->i_flags & S_SWAPFILE)
>  #define IS_PRIVATE(inode)	((inode)->i_flags & S_PRIVATE)
>  
> +#define IS_MNT_NODEV(mnt)	(((mnt)->mnt_flags & MNT_NODEV) || \
> +				    ((mnt)->mnt_sb->s_flags & MS_MKNOD_NOCAP))
> +
> +
>  /* the read-only stuff doesn't really belong here, but any other place is
>     probably as bad and I don't want to create yet another include file. */
>  
> Index: linux/drivers/mtd/mtdsuper.c
> ===================================================================
> --- linux.orig/drivers/mtd/mtdsuper.c	2007-09-24 13:52:17.000000000 +0200
> +++ linux/drivers/mtd/mtdsuper.c	2007-09-24 13:54:57.000000000 +0200
> @@ -194,7 +194,7 @@ int get_sb_mtd(struct file_system_type *
>  	if (!S_ISBLK(nd.dentry->d_inode->i_mode))
>  		goto out;
>  
> -	if (nd.mnt->mnt_flags & MNT_NODEV) {
> +	if (IS_MNT_NODEV(nd.mnt)) {
>  		ret = -EACCES;
>  		goto out;
>  	}
> Index: linux/fs/block_dev.c
> ===================================================================
> --- linux.orig/fs/block_dev.c	2007-09-24 13:52:17.000000000 +0200
> +++ linux/fs/block_dev.c	2007-09-24 13:54:57.000000000 +0200
> @@ -1408,7 +1408,7 @@ struct block_device *lookup_bdev(const c
>  	if (!S_ISBLK(inode->i_mode))
>  		goto fail;
>  	error = -EACCES;
> -	if (nd.mnt->mnt_flags & MNT_NODEV)
> +	if (IS_MNT_NODEV(nd.mnt))
>  		goto fail;
>  	error = -ENOMEM;
>  	bdev = bd_acquire(inode);
> Index: linux/fs/namespace.c
> ===================================================================
> --- linux.orig/fs/namespace.c	2007-09-24 13:52:17.000000000 +0200
> +++ linux/fs/namespace.c	2007-09-24 13:54:57.000000000 +0200
> @@ -431,7 +431,6 @@ static int show_vfsmnt(struct seq_file *
>  	};
>  	static struct proc_fs_info mnt_info[] = {
>  		{ MNT_NOSUID, ",nosuid" },
> -		{ MNT_NODEV, ",nodev" },
>  		{ MNT_NOEXEC, ",noexec" },
>  		{ MNT_NOATIME, ",noatime" },
>  		{ MNT_NODIRATIME, ",nodiratime" },
> @@ -459,6 +458,8 @@ static int show_vfsmnt(struct seq_file *
>  		if (mnt->mnt_flags & fs_infop->flag)
>  			seq_puts(m, fs_infop->str);
>  	}
> +	if (IS_MNT_NODEV(mnt))
> +		seq_puts(m, ",nodev");
>  	if (mnt->mnt_flags & MNT_USER)
>  		seq_printf(m, ",user=%i", mnt->mnt_uid);
>  	if (mnt->mnt_sb->s_op->show_options)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
