Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbYJASki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbYJASki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 14:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYJASkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 14:40:31 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:55440 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbYJASk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 14:40:29 -0400
Date: Wed, 1 Oct 2008 19:39:14 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Matt Mackall <mpm@selenic.com>
cc: Nick Piggin <npiggin@suse.de>, David Howells <dhowells@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: unify shmem and tiny-shmem
In-Reply-To: <1222818570.13453.5.camel@calx>
Message-ID: <Pine.LNX.4.64.0810011817060.19654@blonde.site>
References: <1222818570.13453.5.camel@calx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008, Matt Mackall wrote:

> (This applies on top of Nick's second tiny-shmem patch, which hasn't
> made it to mainline yet(!).

Gosh, thanks for mentioning that, you're right, it hasn't.  I saw
git pull updating mm/tiny-shmem.c a few days ago, and took it for
granted that that was the #ifndef CONFIG_MMU fixed version; but it
was the earlier one without that fix, despite us all knowing that
fix was needed.  I'd have pushed it myself for -rc8 if I'd realized
it was still missing: Nick, please push it to Linus a.s.a.p. (with 
Acks from Matt and David and me) - or ask me to do so (I'm not sure
when Andrew is back up and running).

> But as this deletes tiny-shmem.c, you can
> probably ignore the rejects.)
> 
> tiny-shmem shares most of its 130 lines of code with shmem and tends
> to break when particular bits of shmem get modified. Unifying saves
> code and makes keeping these two in sync much easier.
> 
> before:
>   14367	    392	     24	  14783	   39bf	mm/shmem.o
>     396      72       8     476	    1dc	mm/tiny-shmem.o
> 
> after:
>   14367	    392	     24	  14783	   39bf	mm/shmem.o
>     412	     72       8     492	    1ec	mm/shmem.o tiny
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>

That's much nicer than I'd been imagining, thanks Matt: I've no qualms
about the few #ifdefs you're adding to mm/shmem.c, it does seem an
outright improvement that you're bringing them together.

A few minor points.

> 
> diff -r 04ceba0d1126 -r 4d75a71b1e9d init/Kconfig
> --- a/init/Kconfig	Tue Sep 30 15:36:27 2008 -0500
> +++ b/init/Kconfig	Tue Sep 30 18:44:12 2008 -0500
> @@ -805,10 +805,6 @@
>  	boolean
>  	select PLIST
>  
> -config TINY_SHMEM
> -	default !SHMEM
> -	bool
> -

(It's slightly confusing that !CONFIG_SHMEM now builds mm/shmem.c;
but never mind, it's much more important to propagate oldconfigs aright.)

>  config BASE_SMALL
>  	int
>  	default 0 if BASE_FULL
> diff -r 04ceba0d1126 -r 4d75a71b1e9d mm/Makefile
> --- a/mm/Makefile	Tue Sep 30 15:36:27 2008 -0500
> +++ b/mm/Makefile	Tue Sep 30 18:44:12 2008 -0500
> @@ -9,7 +9,7 @@
>  
>  obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
>  			   maccess.o page_alloc.o page-writeback.o pdflush.o \
> -			   readahead.o swap.o truncate.o vmscan.o \
> +			   readahead.o swap.o truncate.o vmscan.o shmem.o \
>  			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
>  			   page_isolation.o mm_init.o $(mmu-y)
>  
> @@ -21,9 +21,7 @@
>  obj-$(CONFIG_NUMA) 	+= mempolicy.o
>  obj-$(CONFIG_SPARSEMEM)	+= sparse.o
>  obj-$(CONFIG_SPARSEMEM_VMEMMAP) += sparse-vmemmap.o
> -obj-$(CONFIG_SHMEM) += shmem.o
>  obj-$(CONFIG_TMPFS_POSIX_ACL) += shmem_acl.o
> -obj-$(CONFIG_TINY_SHMEM) += tiny-shmem.o
>  obj-$(CONFIG_SLOB) += slob.o
>  obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
>  obj-$(CONFIG_SLAB) += slab.o
> diff -r 04ceba0d1126 -r 4d75a71b1e9d mm/shmem.c
> --- a/mm/shmem.c	Tue Sep 30 15:36:27 2008 -0500
> +++ b/mm/shmem.c	Tue Sep 30 18:44:12 2008 -0500
> @@ -14,31 +14,39 @@
>   * Copyright (c) 2004, Luke Kenneth Casson Leighton <lkcl@lkcl.net>
>   * Copyright (c) 2004 Red Hat, Inc., James Morris <jmorris@redhat.com>
>   *
> + * tiny-shmem:
> + * Copyright (c) 2004, 2008 Matt Mackall <mpm@selenic.com>
> + *
>   * This file is released under the GPL.
>   */
>  
> +#include <linux/fs.h>
> +#include <linux/init.h>
> +#include <linux/vfs.h>
> +#include <linux/mount.h>
> +#include <linux/file.h>
> +#include <linux/mm.h>
> +#include <linux/module.h>
> +#include <linux/swap.h>
> +
> +static struct vfsmount *shm_mnt;
> +
> +#ifdef CONFIG_SHMEM
>  /*
>   * This virtual memory filesystem is heavily based on the ramfs. It
>   * extends ramfs by the ability to use swap and honor resource limits
>   * which makes it a completely usable filesystem.
>   */
>  
> -#include <linux/module.h>
> -#include <linux/init.h>
> -#include <linux/fs.h>
>  #include <linux/xattr.h>
>  #include <linux/exportfs.h>
>  #include <linux/generic_acl.h>
> -#include <linux/mm.h>
>  #include <linux/mman.h>
> -#include <linux/file.h>
> -#include <linux/swap.h>
>  #include <linux/pagemap.h>
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  #include <linux/backing-dev.h>
>  #include <linux/shmem_fs.h>
> -#include <linux/mount.h>
>  #include <linux/writeback.h>
>  #include <linux/vfs.h>
>  #include <linux/blkdev.h>
> @@ -2483,7 +2491,6 @@
>  	.get_sb		= shmem_get_sb,
>  	.kill_sb	= kill_litter_super,
>  };
> -static struct vfsmount *shm_mnt;
>  
>  static int __init init_tmpfs(void)
>  {
> @@ -2522,7 +2529,62 @@
>  	shm_mnt = ERR_PTR(error);
>  	return error;
>  }
> -module_init(init_tmpfs)
> +
> +#else /* !CONFIG_SHMEM */
> +
> +/*
> + * tiny-shmem: simple shmemfs and tmpfs using ramfs code
> + *
> + * This is intended for small system where the benefits of the full
> + * shmem code (swap-backed and resource-limited) are outweighed by
> + * their complexity. On systems without swap this code should be
> + * effectively equivalent, but much lighter weight.
> + */
> +
> +#include <linux/ramfs.h>
> +
> +static struct file_system_type tmpfs_fs_type = {
> +	.name		= "tmpfs",
> +	.get_sb		= ramfs_get_sb,
> +	.kill_sb	= kill_litter_super,
> +};
> +
> +static int __init init_tmpfs(void)
> +{
> +	BUG_ON(register_filesystem(&tmpfs_fs_type) != 0);
> +
> +	shm_mnt = kern_mount(&tmpfs_fs_type);
> +	BUG_ON(IS_ERR(shm_mnt));
> +
> +	return 0;
> +}
> +
> +int shmem_unuse(swp_entry_t entry, struct page *page)
> +{
> +	return 0;
> +}
> +
> +#ifndef CONFIG_MMU
> +unsigned long shmem_get_unmapped_area(struct file *file,
> +				      unsigned long addr,
> +				      unsigned long len,
> +				      unsigned long pgoff,
> +				      unsigned long flags)
> +{
> +	return ramfs_nommu_get_unmapped_area(file, addr, len, pgoff, flags);
> +}
> +#endif

This ifndef is the ugliest part of it: and looking into it, guess
what, shmem_get_unmapped_area() hasn't been used since 2.6.20 -
that's right, isn't it, David?

So please make a separate preliminary patch to remove it from
mm/tiny-shmem.c and include/linux/mm.h, so that little ugliness
never gets here - or if you think that's the wrong way around,
leave it to me to remove from mm/shmem.c later on.

> +
> +#define shmem_file_operations ramfs_file_operations
> +#define shmem_unacct_size(a, b)
> +#define shmem_vm_ops generic_file_vm_ops
> +#define shmem_get_inode ramfs_get_inode
> +#define SHMEM_MAX_BYTES LONG_MAX
> +#define shmem_acct_size(a, b) 0

I'd prefer to rearrange that:

#define shmem_vm_ops		generic_file_vm_ops
#define shmem_file_operations	ramfs_file_operations
#define shmem_get_inode		ramfs_get_inode
#define shmem_acct_size(a, b)	0
#define shmem_unacct_size(a, b)	do { } while (0)
#define SHMEM_MAX_BYTES		LLONG_MAX

Your LONG_MAX is too limiting, since it's on a loff_t:
CONFIG_SHMEM limits files according to the range of its swap
tables, but ramfs doesn't require that extra limitation, and
LONG_MAX could be too small on 32-bit.  And hopefully gcc will
optimize away the > LLONG_MAX test entirely.

> +
> +#endif /* CONFIG_SHMEM */
> +
> +/* common code */
>  
>  /**
>   * shmem_file_setup - get an unlinked file living in tmpfs
> @@ -2566,12 +2628,20 @@
>  	if (!inode)
>  		goto close_file;
>  
> +#ifdef CONFIG_SHMEM
>  	SHMEM_I(inode)->flags = flags & VM_ACCOUNT;
> +#endif
>  	d_instantiate(dentry, inode);
>  	inode->i_size = size;
>  	inode->i_nlink = 0;	/* It is unlinked */
>  	init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
> -			&shmem_file_operations);
> +		  &shmem_file_operations);

Hey! you didn't need to change that ;)

> +
> +#ifndef CONFIG_MMU
> +	error = ramfs_nommu_expand_for_mapping(inode, size);
> +	if (error)
> +		goto close_file;
> +#endif
>  	return file;
>  
>  close_file:
> @@ -2602,3 +2672,5 @@
>  	vma->vm_ops = &shmem_vm_ops;
>  	return 0;
>  }
> +
> +module_init(init_tmpfs)
> diff -r 04ceba0d1126 -r 4d75a71b1e9d mm/tiny-shmem.c
> --- a/mm/tiny-shmem.c	Tue Sep 30 15:36:27 2008 -0500
> +++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
> @@ -1,133 +0,0 @@
> -/*
> - * tiny-shmem.c: simple shmemfs and tmpfs using ramfs code
> - *
> - * Matt Mackall <mpm@selenic.com> January, 2004
> - * derived from mm/shmem.c and fs/ramfs/inode.c
> - *
> - * This is intended for small system where the benefits of the full
> - * shmem code (swap-backed and resource-limited) are outweighed by
> - * their complexity. On systems without swap this code should be
> - * effectively equivalent, but much lighter weight.
> - */
> -
> -#include <linux/fs.h>
> -#include <linux/init.h>
> -#include <linux/vfs.h>
> -#include <linux/mount.h>
> -#include <linux/file.h>
> -#include <linux/mm.h>
> -#include <linux/module.h>
> -#include <linux/swap.h>
> -#include <linux/ramfs.h>
> -
> -static struct file_system_type tmpfs_fs_type = {
> -	.name		= "tmpfs",
> -	.get_sb		= ramfs_get_sb,
> -	.kill_sb	= kill_litter_super,
> -};
> -
> -static struct vfsmount *shm_mnt;
> -
> -static int __init init_tmpfs(void)
> -{
> -	BUG_ON(register_filesystem(&tmpfs_fs_type) != 0);
> -
> -	shm_mnt = kern_mount(&tmpfs_fs_type);
> -	BUG_ON(IS_ERR(shm_mnt));
> -
> -	return 0;
> -}
> -module_init(init_tmpfs)
> -
> -/**
> - * shmem_file_setup - get an unlinked file living in tmpfs
> - * @name: name for dentry (to be seen in /proc/<pid>/maps
> - * @size: size to be set for the file
> - * @flags: vm_flags
> - */
> -struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags)
> -{
> -	int error;
> -	struct file *file;
> -	struct inode *inode;
> -	struct dentry *dentry, *root;
> -	struct qstr this;
> -
> -	if (IS_ERR(shm_mnt))
> -		return (void *)shm_mnt;
> -
> -	error = -ENOMEM;
> -	this.name = name;
> -	this.len = strlen(name);
> -	this.hash = 0; /* will go */
> -	root = shm_mnt->mnt_root;
> -	dentry = d_alloc(root, &this);
> -	if (!dentry)
> -		goto put_memory;
> -
> -	error = -ENFILE;
> -	file = get_empty_filp();
> -	if (!file)
> -		goto put_dentry;
> -
> -	error = -ENOSPC;
> -	inode = ramfs_get_inode(root->d_sb, S_IFREG | S_IRWXUGO, 0);
> -	if (!inode)
> -		goto close_file;
> -
> -	d_instantiate(dentry, inode);
> -	inode->i_size = size;
> -        inode->i_nlink = 0;     /* It is unlinked */
> -        init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
> -                        &ramfs_file_operations);
> -
> -#ifndef CONFIG_MMU
> -	error = ramfs_nommu_expand_for_mapping(inode, size);
> -	if (error)
> -		goto close_file;
> -#endif
> -	return file;
> -
> -close_file:
> -	put_filp(file);
> -put_dentry:
> -	dput(dentry);
> -put_memory:
> -	return ERR_PTR(error);
> -}
> -
> -/**
> - * shmem_zero_setup - setup a shared anonymous mapping
> - * @vma: the vma to be mmapped is prepared by do_mmap_pgoff
> - */
> -int shmem_zero_setup(struct vm_area_struct *vma)
> -{
> -	struct file *file;
> -	loff_t size = vma->vm_end - vma->vm_start;
> -
> -	file = shmem_file_setup("dev/zero", size, vma->vm_flags);
> -	if (IS_ERR(file))
> -		return PTR_ERR(file);
> -
> -	if (vma->vm_file)
> -		fput(vma->vm_file);
> -	vma->vm_file = file;
> -	vma->vm_ops = &generic_file_vm_ops;
> -	return 0;
> -}
> -
> -int shmem_unuse(swp_entry_t entry, struct page *page)
> -{
> -	return 0;
> -}
> -
> -#ifndef CONFIG_MMU
> -unsigned long shmem_get_unmapped_area(struct file *file,
> -				      unsigned long addr,
> -				      unsigned long len,
> -				      unsigned long pgoff,
> -				      unsigned long flags)
> -{
> -	return ramfs_nommu_get_unmapped_area(file, addr, len, pgoff, flags);
> -}
> -#endif

On a different but related subject:
do you think we need to retain the CONFIG_TMPFS option?  It's rather
odd these days, since everybody gets ramfs, and you give them tmpfs
via ramfs without CONFIG_SHMEM.  If anybody wants to cut out the
TMPFS code overhead these days, wouldn't they be using !CONFIG_SHMEM?

Hugh
