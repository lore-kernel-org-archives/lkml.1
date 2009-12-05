Return-Path: <linux-kernel-owner+w=401wt.eu-S932970AbZLEU0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970AbZLEU0q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 15:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757781AbZLEU0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 15:26:43 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:34523 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757735AbZLEU0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 15:26:42 -0500
X-Trace: 298051263/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.111.197/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.111.197
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvoAAOJQGktQKW/F/2dsb2JhbAAI1G6EMwQ
X-IronPort-AV: E=Sophos;i="4.47,347,1257120000"; 
   d="scan'208";a="298051263"
Date: Sat, 5 Dec 2009 20:26:39 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Eric Paris <eparis@redhat.com>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, viro@zeniv.linux.org.uk, jmorris@namei.org,
       npiggin@suse.de, zohar@us.ibm.com, jack@suse.cz, jmalicki@metacarta.com,
       dsmith@redhat.com, serue@us.ibm.com, hch@lst.de, john@johnmccutchan.com,
       rlove@rlove.org, ebiederm@xmission.com, heiko.carstens@de.ibm.com,
       penguin-kernel@I-love.SAKURA.ne.jp, mszeredi@suse.cz,
       jens.axboe@oracle.com, akpm@linux-foundation.org, matthew@wil.cx,
       hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com,
       nishimura@mxp.nes.nec.co.jp, davem@davemloft.net, arnd@arndb.de,
       eric.dumazet@gmail.com
Subject: Re: [RFC PATCH 02/15] shmem: use alloc_file instead of init_file
In-Reply-To: <20091204204656.18286.15131.stgit@paris.rdu.redhat.com>
Message-ID: <Pine.LNX.4.64.0912052023270.6368@sister.anvils>
References: <20091204204646.18286.24853.stgit@paris.rdu.redhat.com>
 <20091204204656.18286.15131.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009, Eric Paris wrote:

> shmem uses get_empty_filp() and then init_file().  Their is no good reason

                                                     There

> not to just use alloc_file() like everything else.
> 
> Acked-by: Miklos Szeredi <miklos@szeredi.hu>
> Signed-off-by: Eric Paris <eparis@redhat.com>

Right, what deterred me from using alloc_file() when it came in,
was that d_instantiate() done before the alloc_file().  But looking
through it now, I think it's okay, and I'm hoping you know it's okay.

Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

> ---
> 
>  mm/shmem.c |   17 +++++++----------
>  1 files changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index e7f8968..b212184 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2640,21 +2640,20 @@ struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags
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
>  	ima_counts_get(file);
>  
> @@ -2667,8 +2666,6 @@ struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags
>  #endif
>  	return file;
>  
> -close_file:
> -	put_filp(file);
>  put_dentry:
>  	dput(dentry);
>  put_memory:
