Return-Path: <linux-kernel-owner+w=401wt.eu-S1758288AbZAMH5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbZAMH5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 02:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbZAMH53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 02:57:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755629AbZAMH51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 02:57:27 -0500
Date: Mon, 12 Jan 2009 23:55:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, bernds_cb1@t-online.de,
       rgetz@blackfin.uclinux.org, vapier.adi@gmail.com, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] NOMMU: Make VMAs per MM as for MMU-mode linux
 [ver #3]
Message-Id: <20090112235550.2d6be428.akpm@linux-foundation.org>
In-Reply-To: <20090108125407.28454.29221.stgit@warthog.procyon.org.uk>
References: <20090108125346.28454.90871.stgit@warthog.procyon.org.uk>
	<20090108125407.28454.29221.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Jan 2009 12:54:07 +0000 David Howells <dhowells@redhat.com> wrote:

> Make VMAs per mm_struct as for MMU-mode linux.
> 
>
> ...
>
> --- a/fs/proc/meminfo.c
> +++ b/fs/proc/meminfo.c
> @@ -74,6 +74,9 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>  		"LowTotal:       %8lu kB\n"
>  		"LowFree:        %8lu kB\n"
>  #endif
> +#ifndef CONFIG_MMU
> +		"MmapCopy:       %8lu kB\n"
> +#endif
>  		"SwapTotal:      %8lu kB\n"
>  		"SwapFree:       %8lu kB\n"
>  		"Dirty:          %8lu kB\n"
> @@ -116,6 +119,9 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>  		K(i.totalram-i.totalhigh),
>  		K(i.freeram-i.freehigh),
>  #endif
> +#ifndef CONFIG_MMU
> +		K((unsigned long) atomic_read(&mmap_pages_allocated)),
> +#endif

This is slightly wrong, as atomic_read() returns "int".  It will show
weird results on 64-bit nommu machines which allocate more than 2G pages :)

>  		K(i.totalswap),
>  		K(i.freeswap),
>  		K(global_page_state(NR_FILE_DIRTY)),
>
> ...
>
> +static int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma)
> +{
> +	unsigned long ino = 0;
> +	struct file *file;
> +	dev_t dev = 0;
> +	int flags, len;
> +
> +	flags = vma->vm_flags;
> +	file = vma->vm_file;
> +
> +	if (file) {
> +		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
> +		dev = inode->i_sb->s_dev;
> +		ino = inode->i_ino;
> +	}
> +
> +	seq_printf(m,
> +		   "%08lx-%08lx %c%c%c%c %08lx %02x:%02x %lu %n",
> +		   vma->vm_start,
> +		   vma->vm_end,
> +		   flags & VM_READ ? 'r' : '-',
> +		   flags & VM_WRITE ? 'w' : '-',
> +		   flags & VM_EXEC ? 'x' : '-',
> +		   flags & VM_MAYSHARE ? flags & VM_SHARED ? 'S' : 's' : 'p',
> +		   vma->vm_pgoff << PAGE_SHIFT,

This will overflow at file offsets >4G?

> +		   MAJOR(dev), MINOR(dev), ino, &len);
> +
> +	if (file) {
> +		len = 25 + sizeof(void *) * 6 - len;
> +		if (len < 1)
> +			len = 1;
> +		seq_printf(m, "%*c", len, ' ');
> +		seq_path(m, &file->f_path, "");
> +	}
> +
> +	seq_putc(m, '\n');
> +	return 0;
> +}
> +
>
> ...
>
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -2472,3 +2472,13 @@ void mm_drop_all_locks(struct mm_struct *mm)
>  
>  	mutex_unlock(&mm_all_locks_mutex);
>  }
> +
> +/*
> + * initialise the VMA slab
> + */
> +void __init mmap_init(void)
> +{
> +	vm_area_cachep = kmem_cache_create("vm_area_struct",
> +			sizeof(struct vm_area_struct), 0,
> +			SLAB_PANIC, NULL);

We have the KMEM_CACHE() macro for this.

It was initially added because we'd been through a period of changing
the kmem_cache_create() arguments every ten minutes and we got tired of
patching zillions of callsites.

(I see this was copy-n-pasted from fork.c.  Why was it moved?)

>
> ...
>
> +	vm_region_jar = kmem_cache_create("vm_region_jar",
> +					  sizeof(struct vm_region), 0,
> +					  SLAB_PANIC, NULL);
> +	vm_area_cachep = kmem_cache_create("vm_area_struct",
> +					   sizeof(struct vm_area_struct), 0,
> +					   SLAB_PANIC, NULL);

dittoes

> -#endif /* DEBUG */
>  
>  /*
> - * add a VMA into a process's mm_struct in the appropriate place in the list
> - * - should be called with mm->mmap_sem held writelocked
> + * validate the region tree
> + * - the caller must hold the region lock
>   */
> -static void add_vma_to_mm(struct mm_struct *mm, struct vm_list_struct *vml)
> +#ifdef CONFIG_DEBUG_NOMMU_REGIONS
> +static noinline void validate_nommu_regions(void)
>  {
> -	struct vm_list_struct **ppv;
> +	struct vm_region *region, *last;
> +	struct rb_node *p, *lastp;
>  
> -	for (ppv = &current->mm->context.vmlist; *ppv; ppv = &(*ppv)->next)
> -		if ((*ppv)->vma->vm_start > vml->vma->vm_start)
> -			break;
> +	lastp = rb_first(&nommu_region_tree);
> +	if (!lastp)
> +		return;
> +
> +	last = rb_entry(lastp, struct vm_region, vm_rb);
> +	if (unlikely(last->vm_end <= last->vm_start))
> +		BUG();

open-coded BUG_ON()

> +	while ((p = rb_next(lastp))) {
> +		region = rb_entry(p, struct vm_region, vm_rb);

`region' could be local to this block, if one feels so inclined.

> +		last = rb_entry(lastp, struct vm_region, vm_rb);
> +
> +		if (unlikely(region->vm_end <= region->vm_start))
> +			BUG();
> +		if (unlikely(region->vm_start < last->vm_end))
> +			BUG();

BUG_ON()

> -	vml->next = *ppv;
> -	*ppv = vml;
> +		lastp = p;
> +	}
>  }
> +#else
> +#define validate_nommu_regions() do {} while(0)

There's no need to implement this in cpp...

>
> ...
>
> -static inline struct vm_area_struct *find_vma_exact(struct mm_struct *mm,
> -						    unsigned long addr)
> +static void free_page_series(unsigned long from, unsigned long to)
>  {
> -	struct vm_list_struct *vml;
> -
> -	/* search the vm_start ordered list */
> -	for (vml = mm->context.vmlist; vml; vml = vml->next) {
> -		if (vml->vma->vm_start == addr)
> -			return vml->vma;
> -		if (vml->vma->vm_start > addr)
> -			break;
> +	for (; from < to; from += PAGE_SIZE) {
> +		struct page *page = virt_to_page(from);
> +
> +		kdebug("- free %lx", from);
> +		atomic_dec(&mmap_pages_allocated);

This isn't counting "pages allocated".  It's counting page *refcounts*.
Now, perhaps these pages will always have a refcount of 1 (why?), in
which case things happen to work out.  But if so, the next line isn't
needed:

> +		if (page_count(page) != 1)

should be "== 1", surely?

> +			kdebug("free page %p [%d]", page, page_count(page));
> +		put_page(page);
>  	}
> -
> -	return NULL;
>  }
>  
>  /*
> - * find a VMA in the global tree
> + * release a reference to a region
> + * - the caller must hold the region semaphore, which this releases

"for writing"

>
> ...
>
> +int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
> +{
> +	struct vm_area_struct *vma;
> +	struct rb_node *rb;
> +	unsigned long end = start + len;
> +	int ret;
>  
> -	update_hiwater_vm(mm);
> -	mm->total_vm -= len >> PAGE_SHIFT;
> +	kenter(",%lx,%zx", start, len);
>  
> -#ifdef DEBUG
> -	show_process_blocks();
> -#endif
> +	if (len == 0)
> +		return -EINVAL;
> +
> +	/* find the first potentially overlapping VMA */
> +	vma = find_vma(mm, start);
> +	if (!vma) {
> +		printk(KERN_WARNING
> +		       "munmap of memory not mmapped by process %d (%s):"
> +		       " 0x%lx-0x%lx\n",
> +		       current->pid, current->comm, start, start + len - 1);

Unprivileged userspace can spam logs?  Perhaps not a concern on typical
nommu systems.  But buggy userspace can spam logs, too, which _is_ a
problem?

> +		return -EINVAL;
> +	}
>  
> +	/* we're allowed to split an anonymous VMA but not a file-backed one */
> +	if (vma->vm_file) {
> +		do {
> +			if (start > vma->vm_start) {
> +				kleave(" = -EINVAL [miss]");
> +				return -EINVAL;
> +			}
> +			if (end == vma->vm_end)
> +				goto erase_whole_vma;
> +			rb = rb_next(&vma->vm_rb);
> +			vma = rb_entry(rb, struct vm_area_struct, vm_rb);
> +		} while (rb);
> +		kleave(" = -EINVAL [split file]");
> +		return -EINVAL;
> +	} else {
> +		/* the chunk must be a subset of the VMA found */
> +		if (start == vma->vm_start && end == vma->vm_end)
> +			goto erase_whole_vma;
> +		if (start < vma->vm_start || end > vma->vm_end) {
> +			kleave(" = -EINVAL [superset]");
> +			return -EINVAL;
> +		}
> +		if (start & ~PAGE_MASK) {
> +			kleave(" = -EINVAL [unaligned start]");
> +			return -EINVAL;
> +		}
> +		if (end != vma->vm_end && end & ~PAGE_MASK) {
> +			kleave(" = -EINVAL [unaligned split]");
> +			return -EINVAL;
> +		}
> +		if (start != vma->vm_start && end != vma->vm_end) {
> +			ret = split_vma(mm, vma, start, 1);
> +			if (ret < 0) {
> +				kleave(" = %d [split]", ret);
> +				return ret;
> +			}
> +		}
> +		return shrink_vma(mm, vma, start, end);
> +	}
> +
> +erase_whole_vma:
> +	delete_vma_from_mm(vma);
> +	delete_vma(mm, vma);
> +	kleave(" = 0");
>  	return 0;
>  }
>
> ...
>

