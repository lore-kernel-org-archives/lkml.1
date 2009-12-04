Return-Path: <linux-kernel-owner+w=401wt.eu-S1752357AbZLDG7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbZLDG7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 01:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbZLDG7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 01:59:22 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50954 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbZLDG7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 01:59:21 -0500
To: Eric Paris <eparis@redhat.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, viro@zeniv.linux.org.uk, jmorris@namei.org,
       npiggin@suse.de, eparis@redhat.com, zohar@us.ibm.com, jack@suse.cz,
       jmalicki@metacarta.com, dsmith@redhat.com, serue@us.ibm.com, hch@lst.de,
       john@johnmccutchan.com, rlove@rlove.org, ebiederm@xmission.com,
       heiko.carstens@de.ibm.com, penguin-kernel@I-love.SAKURA.ne.jp,
       mszeredi@suse.cz, jens.axboe@oracle.com, akpm@linux-foundation.org,
       matthew@wil.cx, hugh.dickins@tiscali.co.uk,
       kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
       davem@davemloft.net, arnd@arndb.de, eric.dumazet@gmail.com
In-reply-to: <20091203195909.8925.6864.stgit@paris.rdu.redhat.com> (message
	from Eric Paris on Thu, 03 Dec 2009 14:59:10 -0500)
Subject: Re: [RFC PATCH 3/6] inotify: use alloc_file instead of doing it internally
References: <20091203195851.8925.30926.stgit@paris.rdu.redhat.com> <20091203195909.8925.6864.stgit@paris.rdu.redhat.com>
Message-Id: <E1NGS7k-0004lZ-Ju@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 04 Dec 2009 07:58:40 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Dec 2009, Eric Paris wrote:
> inotify basically duplicates everything from alloc-file and init-file.  Use
> the generic vfs functions instead.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Acked-by: Miklos Szeredi <miklos@szeredi.hu>

> ---
> 
>  fs/notify/inotify/inotify_user.c |   23 +++++++++--------------
>  1 files changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
> index c40894a..3e03803 100644
> --- a/fs/notify/inotify/inotify_user.c
> +++ b/fs/notify/inotify/inotify_user.c
> @@ -725,6 +725,7 @@ SYSCALL_DEFINE1(inotify_init1, int, flags)
>  	struct fsnotify_group *group;
>  	struct user_struct *user;
>  	struct file *filp;
> +	struct dentry *dentry;
>  	int fd, ret;
>  
>  	/* Check the IN_* constants for consistency.  */
> @@ -738,12 +739,6 @@ SYSCALL_DEFINE1(inotify_init1, int, flags)
>  	if (fd < 0)
>  		return fd;
>  
> -	filp = get_empty_filp();
> -	if (!filp) {
> -		ret = -ENFILE;
> -		goto out_put_fd;
> -	}
> -
>  	user = get_current_user();
>  	if (unlikely(atomic_read(&user->inotify_devs) >=
>  			inotify_max_user_instances)) {
> @@ -758,11 +753,12 @@ SYSCALL_DEFINE1(inotify_init1, int, flags)
>  		goto out_free_uid;
>  	}
>  
> -	filp->f_op = &inotify_fops;
> -	filp->f_path.mnt = mntget(inotify_mnt);
> -	filp->f_path.dentry = dget(inotify_mnt->mnt_root);
> -	filp->f_mapping = filp->f_path.dentry->d_inode->i_mapping;
> -	filp->f_mode = FMODE_READ;
> +	dentry = dget(inotify_mnt->mnt_root);
> +	filp = alloc_file(inotify_mnt, dentry, FMODE_READ, &inotify_fops);
> +	if (!filp) {
> +		ret = -ENFILE;
> +		goto out_dput;
> +	}
>  	filp->f_flags = O_RDONLY | (flags & O_NONBLOCK);
>  	filp->private_data = group;
>  
> @@ -771,11 +767,10 @@ SYSCALL_DEFINE1(inotify_init1, int, flags)
>  	fd_install(fd, filp);
>  
>  	return fd;
> -
> +out_dput:
> +	dput(dentry);
>  out_free_uid:
>  	free_uid(user);
> -	put_filp(filp);
> -out_put_fd:
>  	put_unused_fd(fd);
>  	return ret;
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
