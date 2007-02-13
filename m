Return-Path: <linux-kernel-owner+w=401wt.eu-S1161050AbXBMFNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161050AbXBMFNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 00:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161053AbXBMFNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 00:13:32 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54699 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161050AbXBMFNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 00:13:31 -0500
Date: Mon, 12 Feb 2007 21:11:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <hansendc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 12/22] elevate write count files are open()ed
Message-Id: <20070212211148.c9069c97.akpm@linux-foundation.org>
In-Reply-To: <20070209225337.C8EC7257@localhost.localdomain>
References: <20070209225329.27619A62@localhost.localdomain>
	<20070209225337.C8EC7257@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Feb 2007 14:53:37 -0800 Dave Hansen <hansendc@us.ibm.com> wrote:

> diff -puN fs/file_table.c~14-24-tricky-elevate-write-count-files-are-open-ed fs/file_table.c
> --- lxc/fs/file_table.c~14-24-tricky-elevate-write-count-files-are-open-ed	2007-02-09 14:26:54.000000000 -0800
> +++ lxc-dave/fs/file_table.c	2007-02-09 14:26:54.000000000 -0800
> @@ -209,8 +209,11 @@ void fastcall __fput(struct file *file)
>  	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL))
>  		cdev_put(inode->i_cdev);
>  	fops_put(file->f_op);
> -	if (file->f_mode & FMODE_WRITE)
> +	if (file->f_mode & FMODE_WRITE) {
>  		put_write_access(inode);
> +		if(!special_file(inode->i_mode))
> +			mnt_drop_write(mnt);
> +	}
>  	put_pid(file->f_owner.pid);
>  	put_user_ns(file->f_owner.user_ns);
>  	file_kill(file);
> diff -puN fs/namei.c~14-24-tricky-elevate-write-count-files-are-open-ed fs/namei.c
> --- lxc/fs/namei.c~14-24-tricky-elevate-write-count-files-are-open-ed	2007-02-09 14:26:54.000000000 -0800
> +++ lxc-dave/fs/namei.c	2007-02-09 14:26:54.000000000 -0800
> @@ -1548,8 +1548,17 @@ int may_open(struct nameidata *nd, int a
>  			return -EACCES;
>  
>  		flag &= ~O_TRUNC;
> -	} else if (IS_RDONLY(inode) && (flag & FMODE_WRITE))
> -		return -EROFS;
> +	} else if (flag & FMODE_WRITE) {
> +		/*
> +		 * effectively: !special_file()
> +		 * balanced by __fput()
> +		 */
> +		error = mnt_want_write(nd->mnt);
> +		if (error)
> +			return error;
> +		if (IS_RDONLY(inode))
> +			return -EROFS;
> +	}

yipes.  A new mount-wide spin_lock/unlock for each for-writing open() and close().
Can we have a microbenchmark on this please?

Are you sure that fget_light() and fput_light() don't accidentally bypass this
new logic?
