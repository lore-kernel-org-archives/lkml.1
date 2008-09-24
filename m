Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbYIXTjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbYIXTjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbYIXTis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:38:48 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:43242 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbYIXTir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:38:47 -0400
Date: Wed, 24 Sep 2008 20:29:39 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Nick Piggin <npiggin@suse.de>
cc: David Howells <dhowells@redhat.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Matt Mackall <mpm@selenic.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [patch] mm: tiny-shmem fix lor, mmap_sem vs i_mutex
In-Reply-To: <20080923053228.GA5825@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0809242026190.12147@blonde.site>
References: <20080914073906.GA6184@elte.hu> <20080914004442.4f8e851f.akpm@linux-foundation.org>
 <20080914080631.GA10720@elte.hu> <20080914221231.GG27080@wotan.suse.de>
 <20080917131419.e6b7622e.akpm@linux-foundation.org> <20080918111226.GD29968@elte.hu>
 <48D2ABFD.3040103@goop.org> <1221772310.4779.29.camel@calx>
 <1221877119.8533.2.camel@nimitz> <13787.1222095249@redhat.com>
 <20080923053228.GA5825@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008, Nick Piggin wrote:
> 
> RFC Quick patch to fix nommu anonymous shared memory without breaking
> locking...

Looks good to me, thanks Nick.
And I see David's Ack that it works, so
Acked-by: Hugh Dickins <hugh@veritas.com>

Please push to Andrew and/or Linus now git is broken for !MMU.

Hugh

> ---
> 
> Index: linux-2.6/include/linux/ramfs.h
> ===================================================================
> --- linux-2.6.orig/include/linux/ramfs.h
> +++ linux-2.6/include/linux/ramfs.h
> @@ -6,6 +6,7 @@ extern int ramfs_get_sb(struct file_syst
>  	 int flags, const char *dev_name, void *data, struct vfsmount *mnt);
>  
>  #ifndef CONFIG_MMU
> +extern int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize);
>  extern unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
>  						   unsigned long addr,
>  						   unsigned long len,
> Index: linux-2.6/mm/tiny-shmem.c
> ===================================================================
> --- linux-2.6.orig/mm/tiny-shmem.c
> +++ linux-2.6/mm/tiny-shmem.c
> @@ -80,6 +80,12 @@ struct file *shmem_file_setup(char *name
>          inode->i_nlink = 0;     /* It is unlinked */
>          init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
>                          &ramfs_file_operations);
> +
> +#ifndef CONFIG_MMU
> +	error = ramfs_nommu_expand_for_mapping(inode, size);
> +	if (error)
> +		goto close_file;
> +#endif
>  	return file;
>  
>  close_file:
> Index: linux-2.6/fs/ramfs/file-nommu.c
> ===================================================================
> --- linux-2.6.orig/fs/ramfs/file-nommu.c
> +++ linux-2.6/fs/ramfs/file-nommu.c
> @@ -58,7 +58,7 @@ const struct inode_operations ramfs_file
>   * size 0 on the assumption that it's going to be used for an mmap of shared
>   * memory
>   */
> -static int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
> +int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
>  {
>  	struct pagevec lru_pvec;
>  	unsigned long npages, xpages, loop, limit;
