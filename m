Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbXLULfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbXLULfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 06:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbXLULew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 06:34:52 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:50809 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbXLULev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 06:34:51 -0500
Date: Fri, 21 Dec 2007 12:34:46 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Use ilog2() in fs/namespace.c
Message-Id: <20071221123446.7a479700.dada1@cosmosbay.com>
In-Reply-To: <20071221022912.72b6274e.akpm@linux-foundation.org>
References: <4762C28A.4040002@cosmosbay.com>
	<20071221022912.72b6274e.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007 02:29:12 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 14 Dec 2007 18:51:06 +0100 Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
> > We can use ilog2() in fs/namespace.c to compute hash_bits and hash_mask at
> > compile time, not runtime.
> 
> Well noted.
> 
> > [namespace.patch  text/plain (1.4KB)]
> 
> argh. (save-as, read, copy-paste, s/^/> /g)
> 
> > --- a/fs/namespace.c
> > +++ b/fs/namespace.c
> > @@ -25,6 +25,7 @@
> >  #include <linux/security.h>
> >  #include <linux/mount.h>
> >  #include <linux/ramfs.h>
> > +#include <linux/log2.h>
> >  #include <asm/uaccess.h>
> >  #include <asm/unistd.h>
> >  #include "pnode.h"
> > @@ -36,7 +37,8 @@ __cacheline_aligned_in_smp DEFINE_SPINLOCK(vfsmount_lock);
> >  static int event;
> >  
> >  static struct list_head *mount_hashtable __read_mostly;
> > -static int hash_mask __read_mostly, hash_bits __read_mostly;
> > +#define hash_bits ilog2(PAGE_SIZE / sizeof(struct list_head))
> > +#define hash_mask ((1UL << hash_bits) - 1)
> >  static struct kmem_cache *mnt_cache __read_mostly;
> >  static struct rw_semaphore namespace_sem;
> >  
> > @@ -1828,24 +1830,7 @@ void __init mnt_init(void)
> >  	if (!mount_hashtable)
> >  		panic("Failed to allocate mount hash table\n");
> >  
> > -	/*
> > -	 * Find the power-of-two list-heads that can fit into the allocation..
> > -	 * We don't guarantee that "sizeof(struct list_head)" is necessarily
> > -	 * a power-of-two.
> > -	 */
> > -	nr_hash = PAGE_SIZE / sizeof(struct list_head);
> > -	hash_bits = 0;
> > -	do {
> > -		hash_bits++;
> > -	} while ((nr_hash >> hash_bits) != 0);
> > -	hash_bits--;
> > -
> > -	/*
> > -	 * Re-calculate the actual number of entries and the mask
> > -	 * from the number of bits we can fit.
> > -	 */
> >  	nr_hash = 1UL << hash_bits;
> > -	hash_mask = nr_hash - 1;
> >  
> >  	printk("Mount-cache hash table entries: %d\n", nr_hash);
> 
> Those #defines you now have there are foul.  Please, when there's a choice
> between doing it minimally and doing it right, let's do it right?
>

Indeed !

Thanks Andrew for taking the time and fixing my lazyness :(
Your version is much cleaner of course.

 
> Look what we can now do:
> 
> 
> --- a/fs/namespace.c~use-ilog2-in-fs-namespacec-fix
> +++ a/fs/namespace.c
> @@ -31,14 +31,15 @@
>  #include "pnode.h"
>  #include "internal.h"
>  
> +#define HASH_SHIFT ilog2(PAGE_SIZE / sizeof(struct list_head))
> +#define HASH_SIZE (1UL << HASH_SHIFT)
> +
>  /* spinlock for vfsmount related operations, inplace of dcache_lock */
>  __cacheline_aligned_in_smp DEFINE_SPINLOCK(vfsmount_lock);
>  
>  static int event;
>  
>  static struct list_head *mount_hashtable __read_mostly;
> -#define hash_bits ilog2(PAGE_SIZE / sizeof(struct list_head))
> -#define hash_mask ((1UL << hash_bits) - 1)
>  static struct kmem_cache *mnt_cache __read_mostly;
>  static struct rw_semaphore namespace_sem;
>  
> @@ -50,8 +51,8 @@ static inline unsigned long hash(struct 
>  {
>  	unsigned long tmp = ((unsigned long)mnt / L1_CACHE_BYTES);
>  	tmp += ((unsigned long)dentry / L1_CACHE_BYTES);
> -	tmp = tmp + (tmp >> hash_bits);
> -	return tmp & hash_mask;
> +	tmp = tmp + (tmp >> HASH_SHIFT);
> +	return tmp & (HASH_SIZE - 1);
>  }
>  
>  struct vfsmount *alloc_vfsmnt(const char *name)
> @@ -1815,9 +1816,7 @@ static void __init init_mount_tree(void)
>  
>  void __init mnt_init(void)
>  {
> -	struct list_head *d;
> -	unsigned int nr_hash;
> -	int i;
> +	unsigned u;
>  	int err;
>  
>  	init_rwsem(&namespace_sem);
> @@ -1830,18 +1829,11 @@ void __init mnt_init(void)
>  	if (!mount_hashtable)
>  		panic("Failed to allocate mount hash table\n");
>  
> -	nr_hash = 1UL << hash_bits;
> +	printk("Mount-cache hash table entries: %lu\n", HASH_SIZE);
>  
> -	printk("Mount-cache hash table entries: %d\n", nr_hash);
> +	for (u = 0; u < HASH_SIZE; u++)
> +		INIT_LIST_HEAD(&mount_hashtable[u]);
>  
> -	/* And initialize the newly allocated array */
> -	d = mount_hashtable;
> -	i = nr_hash;
> -	do {
> -		INIT_LIST_HEAD(d);
> -		d++;
> -		i--;
> -	} while (i);
>  	err = sysfs_init();
>  	if (err)
>  		printk(KERN_WARNING "%s: sysfs_init error: %d\n",
> _
> 
