Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbYIQUP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbYIQUP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 16:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbYIQUPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 16:15:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753761AbYIQUPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 16:15:09 -0400
Date: Wed, 17 Sep 2008 13:14:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       mpm@selenic.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch] mm: tiny-shmem fix lor, mmap_sem vs i_mutex
Message-Id: <20080917131419.e6b7622e.akpm@linux-foundation.org>
In-Reply-To: <20080914221231.GG27080@wotan.suse.de>
References: <1221046892.30429.85.camel@twins.programming.kicks-ass.net>
	<20080910114755.GA9696@elte.hu>
	<20080910121217.GA16013@elte.hu>
	<20080910144812.GB18644@wotan.suse.de>
	<1221058864.30429.291.camel@twins.programming.kicks-ass.net>
	<20080910152651.GE18644@wotan.suse.de>
	<20080911082709.GA14378@elte.hu>
	<20080914073906.GA6184@elte.hu>
	<20080914004442.4f8e851f.akpm@linux-foundation.org>
	<20080914080631.GA10720@elte.hu>
	<20080914221231.GG27080@wotan.suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Sep 2008 00:12:31 +0200
Nick Piggin <npiggin@suse.de> wrote:

> tiny-shmem calls do_truncate in shmem_file_setup. do_truncate takes i_mutex,
> and shmem_file_setup is called with mmap_sem held. However i_mutex nests
> outside mmap_sem.
> 
> Copy the code in shmem.c to avoid this problem.
> 

It's a bit unfortunate (as in: arse-about) that we end up creating new
files deep within the mmap code, but I guess we won't be changing that
in a hurry.


> ---
> Index: linux-2.6/mm/tiny-shmem.c
> ===================================================================
> --- linux-2.6.orig/mm/tiny-shmem.c
> +++ linux-2.6/mm/tiny-shmem.c
> @@ -65,31 +65,25 @@ struct file *shmem_file_setup(char *name
>  	if (!dentry)
>  		goto put_memory;
>  
> +        error = -ENFILE;
> +        file = get_empty_filp();
> +        if (!file)
> +                goto put_dentry;
> +
>  	error = -ENOSPC;
>  	inode = ramfs_get_inode(root->d_sb, S_IFREG | S_IRWXUGO, 0);
>  	if (!inode)
> -		goto put_dentry;
> -
> -	d_instantiate(dentry, inode);
> -	error = -ENFILE;
> -	file = alloc_file(shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
> -			&ramfs_file_operations);
> -	if (!file)
> -		goto put_dentry;
> -
> -	inode->i_nlink = 0;	/* It is unlinked */
> -
> -	/* notify everyone as to the change of file size */
> -	error = do_truncate(dentry, size, 0, file);
> -	if (error < 0)
>  		goto close_file;
>  
> +        d_instantiate(dentry, inode);
> +        inode->i_size = size;
> +        inode->i_nlink = 0;     /* It is unlinked */
> +        init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
> +                        &ramfs_file_operations);
>  	return file;
>  
>  close_file:
>  	put_filp(file);
> -	return ERR_PTR(error);
> -
>  put_dentry:
>  	dput(dentry);
>  put_memory:

That's a fairly substantial change.  Was it runtime tested?
