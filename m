Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864AbZLDF7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbZLDF7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 00:59:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZLDF7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 00:59:08 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36110 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZLDF7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 00:59:07 -0500
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
In-reply-to: <20091203195851.8925.30926.stgit@paris.rdu.redhat.com> (message
	from Eric Paris on Thu, 03 Dec 2009 14:58:51 -0500)
Subject: Re: [RFC PATCH 1/6] shmem: use alloc_file instead of init_file
References: <20091203195851.8925.30926.stgit@paris.rdu.redhat.com>
Message-Id: <E1NGRBh-0004da-Cv@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 04 Dec 2009 06:58:41 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Dec 2009, Eric Paris wrote:
> shmem uses get_empty_filp() and then init_file().  Their is no good reason
> not to just use alloc_file() like everything else.

There's a more in this patch, though, and none of that is explained...

> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> ---
> 
>  mm/shmem.c |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 356dd99..831f8bb 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2640,32 +2640,32 @@ struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags
>  	if (!dentry)
>  		goto put_memory;
>  
> -	error = -ENFILE;
> -	file = get_empty_filp();
> -	if (!file)
> -		goto put_dentry;
> -
>  	error = -ENOSPC;
>  	inode = shmem_get_inode(root->d_sb, S_IFREG | S_IRWXUGO, 0, flags);
>  	if (!inode)
> -		goto close_file;
> +		goto put_dentry;
>  
>  	d_instantiate(dentry, inode);
>  	inode->i_size = size;
>  	inode->i_nlink = 0;	/* It is unlinked */
> -	init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
> -		  &shmem_file_operations);
> +
> +	error = -ENFILE;
> +	file = alloc_file(shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
> +			  &shmem_file_operations);
> +	if (!file)
> +		goto put_dentry;
>  
>  #ifndef CONFIG_MMU
>  	error = ramfs_nommu_expand_for_mapping(inode, size);
>  	if (error)
>  		goto close_file;
>  #endif
> -	ima_counts_get(file);

Where's this gone?

>  	return file;
>  
> +#ifndef CONFIG_MMU
>  close_file:

I suggest moving this piece of cleanup into the ifdef above, instead
of adding more ifdefs.

> -	put_filp(file);
> +	fput(file);

OK, put_filp() seems to have been wrong here, but please document it
in the changelog.

> +#endif
>  put_dentry:
>  	dput(dentry);
>  put_memory:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
