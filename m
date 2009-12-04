Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbZLDPfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbZLDPfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 10:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbZLDPfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 10:35:36 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:60362 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbZLDPff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 10:35:35 -0500
Date: Fri, 4 Dec 2009 09:35:32 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, viro@zeniv.linux.org.uk, jmorris@namei.org,
       npiggin@suse.de, zohar@us.ibm.com, jack@suse.cz, jmalicki@metacarta.com,
       dsmith@redhat.com, hch@lst.de, john@johnmccutchan.com, rlove@rlove.org,
       ebiederm@xmission.com, heiko.carstens@de.ibm.com,
       penguin-kernel@I-love.SAKURA.ne.jp, mszeredi@suse.cz,
       jens.axboe@oracle.com, akpm@linux-foundation.org, matthew@wil.cx,
       hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com,
       nishimura@mxp.nes.nec.co.jp, davem@davemloft.net, arnd@arndb.de,
       eric.dumazet@gmail.com
Subject: Re: [RFC PATCH 1/6] shmem: use alloc_file instead of init_file
Message-ID: <20091204153532.GD24550@us.ibm.com>
References: <20091203195851.8925.30926.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203195851.8925.30926.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric Paris (eparis@redhat.com):
> shmem uses get_empty_filp() and then init_file().  Their is no good reason
> not to just use alloc_file() like everything else.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

So,

Acked-by: Serge Hallyn <serue@us.ibm.com>

to the first 3 patches.  I'll review #4 when you resend.  In principle, ack
also to 5 and 6, but for the sake of out-of-tree filesystems I think deprecating
for a version or two would be worthwhile.  Of course, if your ima patches also
go through, then the out-of-three filesystems will spit out ima warnings anyway,
but they can consider that further pursuation to switch :)

Thanks, Eric.

-serge

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
>  	return file;
> 
> +#ifndef CONFIG_MMU
>  close_file:
> -	put_filp(file);
> +	fput(file);
> +#endif
>  put_dentry:
>  	dput(dentry);
>  put_memory:
