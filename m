Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbYBRQ32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbYBRQ32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbYBRQ3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:29:20 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42184 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbYBRQ3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:29:20 -0500
To: haveblue@us.ibm.com
CC: linux-kernel@vger.kernel.org, hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       haveblue@us.ibm.com
In-reply-to: <20080215223732.42E46571@kernel> (message from Dave Hansen on
	Fri, 15 Feb 2008 14:37:32 -0800)
Subject: Re: [PATCH 09/30] r/o bind mounts: drop write during emergency remount
References: <20080215223721.9E0A088A@kernel> <20080215223732.42E46571@kernel>
Message-Id: <E1JR8rj-0003ul-Di@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Feb 2008 17:29:15 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The emergency remount code forcibly removes FMODE_WRITE from
> filps.  The r/o bind mount code notices that this was done
> without a proper mnt_drop_write() and properly gives a
> warning.
> 
> This patch does a mnt_drop_write() to keep everything
> balanced.
> 	
> Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
> ---
> 
>  linux-2.6.git-dave/fs/super.c |   20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff -puN fs/super.c~robind-sysrq-fix fs/super.c
> --- linux-2.6.git/fs/super.c~robind-sysrq-fix	2008-02-15 13:25:46.000000000 -0800
> +++ linux-2.6.git-dave/fs/super.c	2008-02-15 13:25:46.000000000 -0800
> @@ -37,6 +37,7 @@
>  #include <linux/idr.h>
>  #include <linux/kobject.h>
>  #include <linux/mutex.h>
> +#include <linux/file.h>
>  #include <asm/uaccess.h>
>  
>  
> @@ -567,10 +568,25 @@ static void mark_files_ro(struct super_b
>  {
>  	struct file *f;
>  
> +retry:
>  	file_list_lock();
>  	list_for_each_entry(f, &sb->s_files, f_u.fu_list) {
> -		if (S_ISREG(f->f_path.dentry->d_inode->i_mode) && file_count(f))
> -			f->f_mode &= ~FMODE_WRITE;
> +		struct vfsmount *mnt;
> +		if (!S_ISREG(f->f_path.dentry->d_inode->i_mode))
> +		       continue;
> +		if (!file_count(f))
> +			continue;
> +		if (!(f->f_mode & FMODE_WRITE))
> +			continue;
> +		f->f_mode &= ~FMODE_WRITE;
> +		mnt = f->f_path.mnt;

AFAICS an mntget() is needed here to make sure mnt doesn't go away
after releasing file_list_lock.

Miklos

> +		file_list_unlock();
> +		/*
> +		 * This can sleep, so we can't hold
> +		 * the file_list_lock() spinlock.
> +		 */
> +		mnt_drop_write(mnt);
> +		goto retry;
>  	}
>  	file_list_unlock();
>  }
> _
> 
