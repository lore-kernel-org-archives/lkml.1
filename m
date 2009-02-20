Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbZBTCfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbZBTCfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 21:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZBTCfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 21:35:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:50207 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbZBTCfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 21:35:31 -0500
Message-ID: <499E16D5.9070106@kernel.org>
Date: Fri, 20 Feb 2009 11:35:01 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH 09/10] percpu: implement new dynamic percpu allocator
References: <1234958676-27618-1-git-send-email-tj@kernel.org>	<1234958676-27618-10-git-send-email-tj@kernel.org> <20090219021015.aac6ea43.akpm@linux-foundation.org>
In-Reply-To: <20090219021015.aac6ea43.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Feb 2009 02:34:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

Andrew Morton wrote:
>> +static void *percpu_modalloc(unsigned long size, unsigned long align,
>> +			     const char *name)
>> +{
>> +	void *ptr;
>> +
>> +	if (align > PAGE_SIZE) {
>> +		printk(KERN_WARNING "%s: per-cpu alignment %li > %li\n",
>> +		       name, align, PAGE_SIZE);
> 
> It used to be the case that PAGE_SIZE has type `unsigned' on some
> architectures and `unsigned long' on others.  I don't know if that was
> fixed - probably not.

The printk has been there long before this patch in the original
percpu_modalloc().  Given the wide build coverage module.c gets, I
wonder whether the PAGE_SIZE type problem still exists.  Grepping...
Simple grep "define[ ^t]*PAGE_SIZE" doesn't show any non UL PAGE_SIZE
definitions although there are places where _AC macro can be used
instead of explicit ifdef or custom macro.

>> +		align = PAGE_SIZE;
>> +	}
>> +
>> +	ptr = __alloc_percpu(size, align);
>> +	if (!ptr)
>> +		printk(KERN_WARNING
>> +		       "Could not allocate %lu bytes percpu data\n", size);
> 
> A dump_stack() here would be useful.

Hmmm... Is it customary to dump stack on allocation failure?  AFAICS,
kmalloc or vmalloc isn't doing it.

>> + * - use pcpu_setup_static() during percpu area initialization to
>> + *   setup kernel static percpu area
>> + */
> 
> afacit nobody has answered your "is num_possible_cpus() ever a lot
> larger than num_online_cpus()" question.
> 
> It is fairly important.

Heh.. People don't seem to agree on this.  I'll write in other replies.

>> +struct pcpu_chunk {
>> +	struct list_head	list;		/* linked to pcpu_slot lists */
>> +	struct rb_node		rb_node;	/* key is chunk->vm->addr */
>> +	int			free_size;
> 
> what's this?

Size of free space in the chunk.  Will add comment.

>> +	int			contig_hint;	/* max contiguous size hint */
>> +	struct vm_struct	*vm;
> 
> ?

vmalloc area for the chunk.

>> +	int			map_used;	/* # of map entries used */
>> +	int			map_alloc;	/* # of map entries allocated */
>> +	int			*map;
> 
> ?

And, area allocation map.

>> +	struct page		*page[];	/* #cpus * UNIT_PAGES */
> 
> "pages" ;)

I kind of bounce between singular and plural when naming arrays, list
heads or whatever collective data structures.  Plural seems better
suited for the field itself but when accessing the elements it's more
natural to use singular form and the naming convention is mixed all
over the kernel.  One way doesn't really have much technical advantage
over the other so it's still better to have some consistency in place.
Maybe we need to decide on either one, put it in code style and stick
with it?

>> +#define SIZEOF_STRUCT_PCPU_CHUNK					\
>> +	(sizeof(struct pcpu_chunk) +					\
>> +	 (num_possible_cpus() << PCPU_UNIT_PAGES_SHIFT) * sizeof(struct page *))
> 
> This macro generates real code.  It is misleading to pretend that it is
> a compile-time constant.  Suggest that it be converted to a plain old C
> function.

Please see below.

>> +static int __pcpu_unit_pages_shift = PCPU_MIN_UNIT_PAGES_SHIFT;
>> +static int __pcpu_unit_pages;
>> +static int __pcpu_unit_shift;
>> +static int __pcpu_unit_size;
>> +static int __pcpu_chunk_size;
>> +static int __pcpu_nr_slots;
>> +
>> +/* currently everything is power of two, there's no hard dependency on it tho */
>> +#define PCPU_UNIT_PAGES_SHIFT	((int)__pcpu_unit_pages_shift)
>> +#define PCPU_UNIT_PAGES		((int)__pcpu_unit_pages)
>> +#define PCPU_UNIT_SHIFT		((int)__pcpu_unit_shift)
>> +#define PCPU_UNIT_SIZE		((int)__pcpu_unit_size)
>> +#define PCPU_CHUNK_SIZE		((int)__pcpu_chunk_size)
>> +#define PCPU_NR_SLOTS		((int)__pcpu_nr_slots)
> 
> hm.  Why do these exist?

Because those parameters are initialized during boot but should work
as constant once they're set up.  I wanted to make sure that these
values don't get assigned to or changed and make that clear by making
them look like constants as except for the init code they're constants
for all purposes.  So, they aren't not constants in technical sense
but are in their semantics, which I think is more important.  Changing
them isn't difficult at all but I think it's better this way.

>> +/**
>> + * pcpu_realloc - versatile realloc
>> + * @p: the current pointer (can be NULL for new allocations)
>> + * @size: the current size (can be 0 for new allocations)
>> + * @new_size: the wanted new size (can be 0 for free)
> 
> So the allocator doesn't internally record the size of each hunk?
> 
> <squints at the undocumented `free_size'>

This one is a utility function used only inside allocator
implementation as I wanted something more robust than krealloc.  It
has nothing to do with the free_size or chunk management.

...
> This function can be called under spinlock if new_size>PAGE_SIZE and
> the kernel won't (I think) warn.  If new_size<=PAGE_SIZE, the kernel
> will warn.
> 
> Methinks vmalloc() should have a might_sleep().  Dunno.

I can add that but it's an internal utility function which is called
from a few well known obvious call sites to replace krealloc, so I
don't thinks it's a big deal.  Maybe the correct thing to do is adding
might_sleep() to vmalloc?

>> +/**
>> + * pcpu_chunk_relocate - put chunk in the appropriate chunk slot
>> + * @chunk: chunk of interest
>> + * @oslot: the previous slot it was on
>> + *
>> + * This function is called after an allocation or free changed @chunk.
>> + * New slot according to the changed state is determined and @chunk is
>> + * moved to the slot.
> 
> Locking requirements?

I thought "one mutex to rule them all" comment was enough.  I'll add
more description about locking to the comment at the top.

>> +		chunk->free_size -= chunk->map[i];
>> +		chunk->map[i] = -chunk->map[i];
> 
> When pcpu_chunk.map gets documented, please also explain the
> significance of negative entries in there.

Hmmm... already explained in the top comment.  I generally find it
more useful to have general overview description of the design at the
top rather than having piecemeal descriptions here and there and try
to write a decent description of the design at the top of the file.

>> +		pcpu_chunk_relocate(chunk, oslot);
>> +		return off;
>> +	}
>> +
>> +	chunk->contig_hint = max_contig;	/* fully scanned */
>> +	pcpu_chunk_relocate(chunk, oslot);
>> +	return -ENOSPC;
> 
> "No space left on device".
> 
> This is not a disk drive.

That error value is an internal code to notify the caller to extend
area and retry and won't be visible to the outside.  I originally used
-EAGAIN but -ENOSPC seemed more fitting.  Which value is used
eventually doesn't really matter tho.  I'll add a comment to explain
what's going on.

>> +	for (i = page_start; i < page_end; i++) {
>> +		for_each_possible_cpu(cpu) {
>> +			struct page **pagep = pcpu_chunk_pagep(chunk, cpu, i);
>> +
>> +			if (!*pagep)
>> +				continue;
>> +
>> +			__free_page(*pagep);
>> +			*pagep = NULL;
> 
> Why did *pagep get zeroed?  Needs comment?

Cuz chunks can be partially occupied and allocation status is
represented by non-NULL values in the page pointer array.  Will add
comment.

>> +/**
>> + * pcpu_populate_chunk - populate and map an area of a pcpu_chunk
>> + * @chunk: chunk of interest
>> + * @off: offset to the area to populate
>> + * @size: size of the area to populate
>> + *
>> + * For each cpu, populate and map pages [@page_start,@page_end) into
>> + * @chunk.  The area is cleared on return.
>> + */
>> +static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
>> +{
>> +	const gfp_t alloc_mask = GFP_KERNEL | __GFP_HIGHMEM | __GFP_COLD;
> 
> A designed decision has been made to not permit the caller to specify
> the allocation mode?

The design decision was inherited from the original percpu allocator.

> Usually a mistake.  Probably appropriate in this case.  Should be
> mentioned up-front and discussed a bit.

percpu allocator had the interface but nobody used it till now.  I can
put the whole thing under spinlock (and increase locking granuality)
and add gfp mask but given the current usage I'm a bit skeptical
whether it would be necessary.

>> +static void free_pcpu_chunk(struct pcpu_chunk *chunk)
>> +{
>> +	if (!chunk)
>> +		return;
> 
> afaict this test is unneeded.

I think it's better to put NULL test to free functions in general.
People expect free functions to take NULL argument and swallow it.
Doint it otherwise adds unnecessary danger for subtle bugs later on.

>> +	if (chunk->vm)
>> +		free_vm_area(chunk->vm);
> 
> I didn't check whether this one is needed.

The function is also called from allocation failure path, so it is
necessary and even if it's not, I think it's better to make free
function (or any kind of backout/shutdown functions) robust.

>> +void *__alloc_percpu(size_t size, size_t align)
>> +{
>> +	void *ptr = NULL;
>> +	struct pcpu_chunk *chunk;
>> +	int slot, off, err;
>> +
>> +	if (unlikely(!size))
>> +		return NULL;
> 
> hm.  Why do we do this?  Perhaps emitting this warning:
> 
>> +	if (unlikely(size > PAGE_SIZE << PCPU_MIN_UNIT_PAGES_SHIFT ||
>> +		     align > PAGE_SIZE)) {
>> +		printk(KERN_WARNING "illegal size (%zu) or align (%zu) for "
>> +		       "percpu allocation\n", size, align);
> 
> would be more appropriate.

Maybe.  Dunno.  Returning NULL is what malloc/calloc are allowed to do
at least.  kmalloc() returns special token.

>> +		return NULL;
>> +	}
>> +
>> +	mutex_lock(&pcpu_mutex);
> 
> OK, so we do GFP_KERNEL allocations under this lock, so vast amounts of
> kernel code (filesystems, page reclaim, block/io) are not allowed to do
> per-cpu allocations.
> 
> I doubt if there's a problem with that, but it's worth pointing out.

Yeah, it's the same restriction inherited from the original percpu
allocator.  Rusty seems to think it's enough and I wanted to keep
things simple but if the gfp flag thing is necessary it can be easily
changed by putting the area allocation under spinlock and doing page
allocation without lock, but given the possibly large number of
allocations percpu allocation has to do, I don't think allowing the
function to be called from non-preemptive context is a wise thing.

>> +	/* allocate area */
>> +	for (slot = pcpu_size_to_slot(size); slot < PCPU_NR_SLOTS; slot++) {
>> +		list_for_each_entry(chunk, &pcpu_slot[slot], list) {
>> +			if (size > chunk->contig_hint)
>> +				continue;
>> +			err = pcpu_alloc_area(chunk, size, align);
>> +			if (err >= 0) {
>> +				off = err;
>> +				goto area_found;
>> +			}
>> +			if (err != -ENOSPC)
>> +				goto out_unlock;
>> +		}
>> +	}
>> +
>> +	/* hmmm... no space left, create a new chunk */
>> +	err = -ENOMEM;
> 
> This statement is unneeded.
>
>> +	chunk = alloc_pcpu_chunk();
>> +	if (!chunk)
>> +		goto out_unlock;
>> +	pcpu_chunk_relocate(chunk, -1);
>> +	pcpu_chunk_addr_insert(chunk);
>> +
>> +	err = pcpu_alloc_area(chunk, size, align);
>> +	if (err < 0)
>> +		goto out_unlock;
>> +	off = err;
> 
> It would be cleaner to do
> 
> 	off = pcpu_alloc_area(chunk, size, align);
> 	if (off < 0)
> 		goto out_unlock;

Yeah, right.  The err thing is remnant of different interface where it
returned ERR_PTR value.  I'll remove it.

>> +/**
>> + * free_percpu - free percpu area
>> + * @ptr: pointer to area to free
>> + *
>> + * Free percpu area @ptr.  Might sleep.
>> + */
>> +void free_percpu(void *ptr)
>> +{
>> +	void *addr = __pcpu_ptr_to_addr(ptr);
>> +	struct pcpu_chunk *chunk;
>> +	int off;
>> +
>> +	if (!ptr)
>> +		return;
> 
> Do we ever do this?  Should it be permitted?  Should we warn?

Dunno but should be allowed, yes, no.  :-)

>> +size_t __init pcpu_setup_static(pcpu_populate_pte_fn_t populate_pte_fn,
>> +				struct page **pages, size_t cpu_size)
>> +{
>> +	static struct vm_struct static_vm;
>> +	struct pcpu_chunk *static_chunk;
>> +	int nr_cpu_pages = DIV_ROUND_UP(cpu_size, PAGE_SIZE);
>> +	unsigned int cpu;
>> +	int err, i;
>> +
>> +	while (1 << __pcpu_unit_pages_shift < nr_cpu_pages)
>> +		__pcpu_unit_pages_shift++;
> 
> Is there an ilog2() hiding in there somewhere?

Will convert.

Thanks.

-- 
tejun
