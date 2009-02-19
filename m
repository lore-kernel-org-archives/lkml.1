Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbZBSKLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbZBSKLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 05:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbZBSKLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 05:11:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753993AbZBSKLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 05:11:41 -0500
Date: Thu, 19 Feb 2009 02:10:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH 09/10] percpu: implement new dynamic percpu allocator
Message-Id: <20090219021015.aac6ea43.akpm@linux-foundation.org>
In-Reply-To: <1234958676-27618-10-git-send-email-tj@kernel.org>
References: <1234958676-27618-1-git-send-email-tj@kernel.org>
	<1234958676-27618-10-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009 21:04:35 +0900 Tejun Heo <tj@kernel.org> wrote:

> Impact: new scalable dynamic percpu allocator which allows dynamic
>         percpu areas to be accessed the same way as static ones
> 
> Implement scalable dynamic percpu allocator which can be used for both
> static and dynamic percpu areas.  This will allow static and dynamic
> areas to share faster direct access methods.  This feature is optional
> and enabled only when CONFIG_HAVE_DYNAMIC_PER_CPU_AREA is defined by
> arch.  Please read comment on top of mm/percpu.c for details.
> 
>
> ...
>
> +static void *percpu_modalloc(unsigned long size, unsigned long align,
> +			     const char *name)
> +{
> +	void *ptr;
> +
> +	if (align > PAGE_SIZE) {
> +		printk(KERN_WARNING "%s: per-cpu alignment %li > %li\n",
> +		       name, align, PAGE_SIZE);

It used to be the case that PAGE_SIZE has type `unsigned' on some
architectures and `unsigned long' on others.  I don't know if that was
fixed - probably not.

> +		align = PAGE_SIZE;
> +	}
> +
> +	ptr = __alloc_percpu(size, align);
> +	if (!ptr)
> +		printk(KERN_WARNING
> +		       "Could not allocate %lu bytes percpu data\n", size);

A dump_stack() here would be useful.

> +	return ptr;
> +}
> +
> +static void percpu_modfree(void *freeme)
> +{
> +	free_percpu(freeme);
> +}
> +
> +#else /* ... !CONFIG_HAVE_DYNAMIC_PER_CPU_AREA */
> +
>
> ...
>
> +/*
> + * linux/mm/percpu.c - percpu memory allocator
> + *
> + * Copyright (C) 2009		SUSE Linux Products GmbH
> + * Copyright (C) 2009		Tejun Heo <tj@kernel.org>
> + *
> + * This file is released under the GPLv2.
> + *
> + * This is percpu allocator which can handle both static and dynamic
> + * areas.  Percpu areas are allocated in chunks in vmalloc area.  Each
> + * chunk is consisted of num_possible_cpus() units and the first chunk
> + * is used for static percpu variables in the kernel image (special
> + * boot time alloc/init handling necessary as these areas need to be
> + * brought up before allocation services are running).  Unit grows as
> + * necessary and all units grow or shrink in unison.  When a chunk is
> + * filled up, another chunk is allocated.  ie. in vmalloc area
> + *
> + *  c0                           c1                         c2
> + *  -------------------          -------------------        ------------
> + * | u0 | u1 | u2 | u3 |        | u0 | u1 | u2 | u3 |      | u0 | u1 | u
> + *  -------------------  ......  -------------------  ....  ------------
> + *
> + * Allocation is done in offset-size areas of single unit space.  Ie,
> + * when UNIT_SIZE is 128k, an area at 134k of 512 bytes occupies 512
> + * bytes at 6k of c1:u0, c1:u1, c1:u2 and c1:u3.  Percpu access can be
> + * done by configuring percpu base registers UNIT_SIZE apart.
> + *
> + * There are usually many small percpu allocations many of them as
> + * small as 4 bytes.  The allocator organizes chunks into lists
> + * according to free size and tries to allocate from the fullest one.
> + * Each chunk keeps the maximum contiguous area size hint which is
> + * guaranteed to be eqaul to or larger than the maximum contiguous
> + * area in the chunk.  This helps the allocator not to iterate the
> + * chunk maps unnecessarily.
> + *
> + * Allocation state in each chunk is kept using an array of integers.
> + * A positive value represents free region and negative allocated.
> + * Allocation inside a chunk is done by scanning this map sequentially
> + * and serving the first matching entry.  This is mostly copied from
> + * the percpu_modalloc() allocator.  Chunks are also linked into a rb
> + * tree to ease address to chunk mapping during free.
> + *
> + * To use this allocator, arch code should do the followings.
> + *
> + * - define CONFIG_HAVE_DYNAMIC_PER_CPU_AREA
> + *
> + * - define __addr_to_pcpu_ptr() and __pcpu_ptr_to_addr() to translate
> + *   regular address to percpu pointer and back
> + *
> + * - use pcpu_setup_static() during percpu area initialization to
> + *   setup kernel static percpu area
> + */

afacit nobody has answered your "is num_possible_cpus() ever a lot
larger than num_online_cpus()" question.

It is fairly important.

> +#include <linux/bitmap.h>
> +#include <linux/bootmem.h>
> +#include <linux/list.h>
> +#include <linux/mm.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/percpu.h>
> +#include <linux/pfn.h>
> +#include <linux/rbtree.h>
> +#include <linux/slab.h>
> +#include <linux/vmalloc.h>
> +
> +#include <asm/cacheflush.h>
> +#include <asm/tlbflush.h>
> +
> +#define PCPU_MIN_UNIT_PAGES_SHIFT	4	/* also max alloc size */
> +#define PCPU_SLOT_BASE_SHIFT		5	/* 1-31 shares the same slot */
> +#define PCPU_DFL_MAP_ALLOC		16	/* start a map with 16 ents */
> +
> +struct pcpu_chunk {
> +	struct list_head	list;		/* linked to pcpu_slot lists */
> +	struct rb_node		rb_node;	/* key is chunk->vm->addr */
> +	int			free_size;

what's this?

> +	int			contig_hint;	/* max contiguous size hint */
> +	struct vm_struct	*vm;

?

> +	int			map_used;	/* # of map entries used */
> +	int			map_alloc;	/* # of map entries allocated */
> +	int			*map;

?

> +	struct page		*page[];	/* #cpus * UNIT_PAGES */

"pages" ;)

> +};
> +
> +#define SIZEOF_STRUCT_PCPU_CHUNK					\
> +	(sizeof(struct pcpu_chunk) +					\
> +	 (num_possible_cpus() << PCPU_UNIT_PAGES_SHIFT) * sizeof(struct page *))

This macro generates real code.  It is misleading to pretend that it is
a compile-time constant.  Suggest that it be converted to a plain old C
function.

> +static int __pcpu_unit_pages_shift = PCPU_MIN_UNIT_PAGES_SHIFT;
> +static int __pcpu_unit_pages;
> +static int __pcpu_unit_shift;
> +static int __pcpu_unit_size;
> +static int __pcpu_chunk_size;
> +static int __pcpu_nr_slots;
> +
> +/* currently everything is power of two, there's no hard dependency on it tho */
> +#define PCPU_UNIT_PAGES_SHIFT	((int)__pcpu_unit_pages_shift)
> +#define PCPU_UNIT_PAGES		((int)__pcpu_unit_pages)
> +#define PCPU_UNIT_SHIFT		((int)__pcpu_unit_shift)
> +#define PCPU_UNIT_SIZE		((int)__pcpu_unit_size)
> +#define PCPU_CHUNK_SIZE		((int)__pcpu_chunk_size)
> +#define PCPU_NR_SLOTS		((int)__pcpu_nr_slots)

hm.  Why do these exist?

Again, they look like compile-time constants, but aren't.

> +/* the address of the first chunk which starts with the kernel static area */
> +void *pcpu_base_addr;
> +EXPORT_SYMBOL_GPL(pcpu_base_addr);
> +
>
> ...
>
> +/**
> + * pcpu_realloc - versatile realloc
> + * @p: the current pointer (can be NULL for new allocations)
> + * @size: the current size (can be 0 for new allocations)
> + * @new_size: the wanted new size (can be 0 for free)

So the allocator doesn't internally record the size of each hunk?

<squints at the undocumented `free_size'>

> + * More robust realloc which can be used to allocate, resize or free a
> + * memory area of arbitrary size.  If the needed size goes over
> + * PAGE_SIZE, kernel VM is used.
> + *
> + * RETURNS:
> + * The new pointer on success, NULL on failure.
> + */
> +static void *pcpu_realloc(void *p, size_t size, size_t new_size)
> +{
> +	void *new;
> +
> +	if (new_size <= PAGE_SIZE)
> +		new = kmalloc(new_size, GFP_KERNEL);
> +	else
> +		new = vmalloc(new_size);
> +	if (new_size && !new)
> +		return NULL;
> +
> +	memcpy(new, p, min(size, new_size));
> +	if (new_size > size)
> +		memset(new + size, 0, new_size - size);
> +
> +	if (size <= PAGE_SIZE)
> +		kfree(p);
> +	else
> +		vfree(p);
> +
> +	return new;
> +}

This function can be called under spinlock if new_size>PAGE_SIZE and
the kernel won't (I think) warn.  If new_size<=PAGE_SIZE, the kernel
will warn.

Methinks vmalloc() should have a might_sleep().  Dunno.

> +/**
> + * pcpu_chunk_relocate - put chunk in the appropriate chunk slot
> + * @chunk: chunk of interest
> + * @oslot: the previous slot it was on
> + *
> + * This function is called after an allocation or free changed @chunk.
> + * New slot according to the changed state is determined and @chunk is
> + * moved to the slot.

Locking requirements?

> + */
> +static void pcpu_chunk_relocate(struct pcpu_chunk *chunk, int oslot)
> +{
> +	int nslot = pcpu_chunk_slot(chunk);
> +
> +	if (oslot != nslot) {
> +		if (oslot < nslot)
> +			list_move(&chunk->list, &pcpu_slot[nslot]);
> +		else
> +			list_move_tail(&chunk->list, &pcpu_slot[nslot]);
> +	}
> +}
> +
>
> ...
>
> +static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
> +{
> +	int oslot = pcpu_chunk_slot(chunk);
> +	int max_contig = 0;
> +	int i, off;
> +
> +	/*
> +	 * The static chunk initially doesn't have map attached
> +	 * because kmalloc wasn't available during init.  Give it one.
> +	 */
> +	if (unlikely(!chunk->map)) {
> +		chunk->map = pcpu_realloc(NULL, 0,
> +				PCPU_DFL_MAP_ALLOC * sizeof(chunk->map[0]));
> +		if (!chunk->map)
> +			return -ENOMEM;
> +
> +		chunk->map_alloc = PCPU_DFL_MAP_ALLOC;
> +		chunk->map[chunk->map_used++] = -pcpu_static_size;
> +		if (chunk->free_size)
> +			chunk->map[chunk->map_used++] = chunk->free_size;
> +	}
> +
> +	for (i = 0, off = 0; i < chunk->map_used; off += abs(chunk->map[i++])) {
> +		bool is_last = i + 1 == chunk->map_used;
> +		int head, tail;
> +
> +		/* extra for alignment requirement */
> +		head = ALIGN(off, align) - off;
> +		BUG_ON(i == 0 && head != 0);
> +
> +		if (chunk->map[i] < 0)
> +			continue;
> +		if (chunk->map[i] < head + size) {
> +			max_contig = max(chunk->map[i], max_contig);
> +			continue;
> +		}
> +
> +		/*
> +		 * If head is small or the previous block is free,
> +		 * merge'em.  Note that 'small' is defined as smaller
> +		 * than sizeof(int), which is very small but isn't too
> +		 * uncommon for percpu allocations.
> +		 */
> +		if (head && (head < sizeof(int) || chunk->map[i - 1] > 0)) {
> +			if (chunk->map[i - 1] > 0)
> +				chunk->map[i - 1] += head;
> +			else {
> +				chunk->map[i - 1] -= head;
> +				chunk->free_size -= head;
> +			}
> +			chunk->map[i] -= head;
> +			off += head;
> +			head = 0;
> +		}
> +
> +		/* if tail is small, just keep it around */
> +		tail = chunk->map[i] - head - size;
> +		if (tail < sizeof(int))
> +			tail = 0;
> +
> +		/* split if warranted */
> +		if (head || tail) {
> +			if (pcpu_split_block(chunk, i, head, tail))
> +				return -ENOMEM;
> +			if (head) {
> +				i++;
> +				off += head;
> +				max_contig = max(chunk->map[i - 1], max_contig);
> +			}
> +			if (tail)
> +				max_contig = max(chunk->map[i + 1], max_contig);
> +		}
> +
> +		/* update hint and mark allocated */
> +		if (is_last)
> +			chunk->contig_hint = max_contig; /* fully scanned */
> +		else
> +			chunk->contig_hint = max(chunk->contig_hint,
> +						 max_contig);
> +
> +		chunk->free_size -= chunk->map[i];
> +		chunk->map[i] = -chunk->map[i];

When pcpu_chunk.map gets documented, please also explain the
significance of negative entries in there.

> +		pcpu_chunk_relocate(chunk, oslot);
> +		return off;
> +	}
> +
> +	chunk->contig_hint = max_contig;	/* fully scanned */
> +	pcpu_chunk_relocate(chunk, oslot);
> +	return -ENOSPC;

"No space left on device".

This is not a disk drive.

> +}
> +
>
> ...
>
> +static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, size_t off,
> +				  size_t size, bool flush)
> +{
> +	int page_start = PFN_DOWN(off);
> +	int page_end = PFN_UP(off + size);
> +	int unmap_start = -1;
> +	int uninitialized_var(unmap_end);
> +	unsigned int cpu;
> +	int i;
> +
> +	for (i = page_start; i < page_end; i++) {
> +		for_each_possible_cpu(cpu) {
> +			struct page **pagep = pcpu_chunk_pagep(chunk, cpu, i);
> +
> +			if (!*pagep)
> +				continue;
> +
> +			__free_page(*pagep);
> +			*pagep = NULL;

Why did *pagep get zeroed?  Needs comment?

> +			unmap_start = unmap_start < 0 ? i : unmap_start;
> +			unmap_end = i + 1;
> +		}
> +	}
> +
> +	if (unmap_start >= 0)
> +		pcpu_unmap(chunk, unmap_start, unmap_end, flush);
> +}
> +
>
> ...
>
> +/**
> + * pcpu_populate_chunk - populate and map an area of a pcpu_chunk
> + * @chunk: chunk of interest
> + * @off: offset to the area to populate
> + * @size: size of the area to populate
> + *
> + * For each cpu, populate and map pages [@page_start,@page_end) into
> + * @chunk.  The area is cleared on return.
> + */
> +static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
> +{
> +	const gfp_t alloc_mask = GFP_KERNEL | __GFP_HIGHMEM | __GFP_COLD;

A designed decision has been made to not permit the caller to specify
the allocation mode?

Usually a mistake.  Probably appropriate in this case.  Should be
mentioned up-front and discussed a bit.

> +	int page_start = PFN_DOWN(off);
> +	int page_end = PFN_UP(off + size);
> +	int map_start = -1;
> +	int map_end;
> +	unsigned int cpu;
> +	int i;
> +
> +	for (i = page_start; i < page_end; i++) {
> +		if (pcpu_chunk_page_occupied(chunk, i)) {
> +			if (map_start >= 0) {
> +				if (pcpu_map(chunk, map_start, map_end))
> +					goto err;
> +				map_start = -1;
> +			}
> +			continue;
> +		}
> +
> +		map_start = map_start < 0 ? i : map_start;
> +		map_end = i + 1;
> +
> +		for_each_possible_cpu(cpu) {
> +			struct page **pagep = pcpu_chunk_pagep(chunk, cpu, i);
> +
> +			*pagep = alloc_pages_node(cpu_to_node(cpu),
> +						  alloc_mask, 0);
> +			if (!*pagep)
> +				goto err;
> +		}
> +	}
> +
> +	if (map_start >= 0 && pcpu_map(chunk, map_start, map_end))
> +		goto err;
> +
> +	for_each_possible_cpu(cpu)
> +		memset(chunk->vm->addr + (cpu << PCPU_UNIT_SHIFT) + off, 0,
> +		       size);
> +
> +	return 0;
> +err:
> +	/* likely under heavy memory pressure, give memory back */
> +	pcpu_depopulate_chunk(chunk, off, size, true);
> +	return -ENOMEM;
> +}
> +
> +static void free_pcpu_chunk(struct pcpu_chunk *chunk)
> +{
> +	if (!chunk)
> +		return;

afaict this test is unneeded.

> +	if (chunk->vm)
> +		free_vm_area(chunk->vm);

I didn't check whether this one is needed.

> +	pcpu_realloc(chunk->map, chunk->map_alloc * sizeof(chunk->map[0]), 0);
> +	kfree(chunk);
> +}
> +
>
> ...
>
> +/**
> + * __alloc_percpu - allocate percpu area
> + * @size: size of area to allocate
> + * @align: alignment of area (max PAGE_SIZE)
> + *
> + * Allocate percpu area of @size bytes aligned at @align.  Might
> + * sleep.  Might trigger writeouts.
> + *
> + * RETURNS:
> + * Percpu pointer to the allocated area on success, NULL on failure.
> + */
> +void *__alloc_percpu(size_t size, size_t align)
> +{
> +	void *ptr = NULL;
> +	struct pcpu_chunk *chunk;
> +	int slot, off, err;
> +
> +	if (unlikely(!size))
> +		return NULL;

hm.  Why do we do this?  Perhaps emitting this warning:

> +	if (unlikely(size > PAGE_SIZE << PCPU_MIN_UNIT_PAGES_SHIFT ||
> +		     align > PAGE_SIZE)) {
> +		printk(KERN_WARNING "illegal size (%zu) or align (%zu) for "
> +		       "percpu allocation\n", size, align);

would be more appropriate.

> +		return NULL;
> +	}
> +
> +	mutex_lock(&pcpu_mutex);

OK, so we do GFP_KERNEL allocations under this lock, so vast amounts of
kernel code (filesystems, page reclaim, block/io) are not allowed to do
per-cpu allocations.

I doubt if there's a problem with that, but it's worth pointing out.

> +	/* allocate area */
> +	for (slot = pcpu_size_to_slot(size); slot < PCPU_NR_SLOTS; slot++) {
> +		list_for_each_entry(chunk, &pcpu_slot[slot], list) {
> +			if (size > chunk->contig_hint)
> +				continue;
> +			err = pcpu_alloc_area(chunk, size, align);
> +			if (err >= 0) {
> +				off = err;
> +				goto area_found;
> +			}
> +			if (err != -ENOSPC)
> +				goto out_unlock;
> +		}
> +	}
> +
> +	/* hmmm... no space left, create a new chunk */
> +	err = -ENOMEM;

This statement is unneeded.

> +	chunk = alloc_pcpu_chunk();
> +	if (!chunk)
> +		goto out_unlock;
> +	pcpu_chunk_relocate(chunk, -1);
> +	pcpu_chunk_addr_insert(chunk);
> +
> +	err = pcpu_alloc_area(chunk, size, align);
> +	if (err < 0)
> +		goto out_unlock;
> +	off = err;

It would be cleaner to do

	off = pcpu_alloc_area(chunk, size, align);
	if (off < 0)
		goto out_unlock;

> +area_found:
> +	/* populate, map and clear the area */
> +	if (pcpu_populate_chunk(chunk, off, size)) {
> +		pcpu_free_area(chunk, off);
> +		goto out_unlock;
> +	}
> +
> +	ptr = __addr_to_pcpu_ptr(chunk->vm->addr + off);
> +out_unlock:
> +	mutex_unlock(&pcpu_mutex);
> +	return ptr;
> +}
> +EXPORT_SYMBOL_GPL(__alloc_percpu);
> +
>
> ...
>
> +/**
> + * free_percpu - free percpu area
> + * @ptr: pointer to area to free
> + *
> + * Free percpu area @ptr.  Might sleep.
> + */
> +void free_percpu(void *ptr)
> +{
> +	void *addr = __pcpu_ptr_to_addr(ptr);
> +	struct pcpu_chunk *chunk;
> +	int off;
> +
> +	if (!ptr)
> +		return;

Do we ever do this?  Should it be permitted?  Should we warn?

> +	mutex_lock(&pcpu_mutex);
> +
> +	chunk = pcpu_chunk_addr_search(addr);
> +	off = addr - chunk->vm->addr;
> +
> +	pcpu_free_area(chunk, off);
> +
> +	/* the chunk became fully free, kill one if there are other free ones */
> +	if (chunk->free_size == PCPU_UNIT_SIZE) {
> +		struct pcpu_chunk *pos;
> +
> +		list_for_each_entry(pos,
> +				    &pcpu_slot[pcpu_chunk_slot(chunk)], list)
> +			if (pos != chunk) {
> +				pcpu_kill_chunk(pos);
> +				break;
> +			}
> +	}
> +
> +	mutex_unlock(&pcpu_mutex);
> +}
> +EXPORT_SYMBOL_GPL(free_percpu);
> +
> +/**
> + * pcpu_setup_static - initialize kernel static percpu area
> + * @populate_pte_fn: callback to allocate pagetable
> + * @pages: num_possible_cpus() * PFN_UP(cpu_size) pages
> + *
> + * Initialize kernel static percpu area.  The caller should allocate
> + * all the necessary pages and pass them in @pages.
> + * @populate_pte_fn() is called on each page to be used for percpu
> + * mapping and is responsible for making sure all the necessary page
> + * tables for the page is allocated.
> + *
> + * RETURNS:
> + * The determined PCPU_UNIT_SIZE which can be used to initialize
> + * percpu access.
> + */
> +size_t __init pcpu_setup_static(pcpu_populate_pte_fn_t populate_pte_fn,
> +				struct page **pages, size_t cpu_size)
> +{
> +	static struct vm_struct static_vm;
> +	struct pcpu_chunk *static_chunk;
> +	int nr_cpu_pages = DIV_ROUND_UP(cpu_size, PAGE_SIZE);
> +	unsigned int cpu;
> +	int err, i;
> +
> +	while (1 << __pcpu_unit_pages_shift < nr_cpu_pages)
> +		__pcpu_unit_pages_shift++;

Is there an ilog2() hiding in there somewhere?

> +	pcpu_static_size = cpu_size;
> +	__pcpu_unit_pages = 1 << __pcpu_unit_pages_shift;
> +	__pcpu_unit_shift = PAGE_SHIFT + __pcpu_unit_pages_shift;
> +	__pcpu_unit_size = 1 << __pcpu_unit_shift;
> +	__pcpu_chunk_size = num_possible_cpus() * __pcpu_unit_size;
> +	__pcpu_nr_slots = pcpu_size_to_slot(__pcpu_unit_size) + 1;
> +
> +	/* allocate chunk slots */
> +	pcpu_slot = alloc_bootmem(PCPU_NR_SLOTS * sizeof(pcpu_slot[0]));
> +	for (i = 0; i < PCPU_NR_SLOTS; i++)
> +		INIT_LIST_HEAD(&pcpu_slot[i]);
> +
> +	/* init and register vm area */
> +	static_vm.flags = VM_ALLOC;
> +	static_vm.size = PCPU_CHUNK_SIZE;
> +	vm_area_register_early(&static_vm);
> +
> +	/* init static_chunk */
> +	static_chunk = alloc_bootmem(SIZEOF_STRUCT_PCPU_CHUNK);
> +	INIT_LIST_HEAD(&static_chunk->list);
> +	static_chunk->vm = &static_vm;
> +	static_chunk->free_size = PCPU_UNIT_SIZE - pcpu_static_size;
> +	static_chunk->contig_hint = static_chunk->free_size;
> +
> +	/* assign pages and map them */
> +	for_each_possible_cpu(cpu) {
> +		for (i = 0; i < nr_cpu_pages; i++) {
> +			*pcpu_chunk_pagep(static_chunk, cpu, i) = *pages++;
> +			populate_pte_fn(pcpu_chunk_addr(static_chunk, cpu, i));
> +		}
> +	}
> +
> +	err = pcpu_map(static_chunk, 0, nr_cpu_pages);
> +	if (err)
> +		panic("failed to setup static percpu area, err=%d\n", err);
> +
> +	/* link static_chunk in */
> +	pcpu_chunk_relocate(static_chunk, -1);
> +	pcpu_chunk_addr_insert(static_chunk);
> +
> +	/* we're done */
> +	pcpu_base_addr = (void *)pcpu_chunk_addr(static_chunk, 0, 0);
> +	return PCPU_UNIT_SIZE;
> +}

