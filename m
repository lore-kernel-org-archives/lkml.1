Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbZBTDGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbZBTDGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 22:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZBTDGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 22:06:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116AbZBTDGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 22:06:39 -0500
Date: Thu, 19 Feb 2009 19:04:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH 09/10] percpu: implement new dynamic percpu allocator
Message-Id: <20090219190417.c664bff4.akpm@linux-foundation.org>
In-Reply-To: <499E16D5.9070106@kernel.org>
References: <1234958676-27618-1-git-send-email-tj@kernel.org>
	<1234958676-27618-10-git-send-email-tj@kernel.org>
	<20090219021015.aac6ea43.akpm@linux-foundation.org>
	<499E16D5.9070106@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Feb 2009 11:35:01 +0900 Tejun Heo <tj@kernel.org> wrote:

> Hello, Andrew.
> 
> >> +		align = PAGE_SIZE;
> >> +	}
> >> +
> >> +	ptr = __alloc_percpu(size, align);
> >> +	if (!ptr)
> >> +		printk(KERN_WARNING
> >> +		       "Could not allocate %lu bytes percpu data\n", size);
> > 
> > A dump_stack() here would be useful.
> 
> Hmmm... Is it customary to dump stack on allocation failure?  AFAICS,
> kmalloc or vmalloc isn't doing it.

The page allocator (and hence kmalloc) will do it.

But a more important question is "is a trace useful".  I'd say "yes". 
Because being told that something ran out of memory isn't terribly
useful.  The very first question is "OK, well _what_ ran out of
memory?".

> >> +#define SIZEOF_STRUCT_PCPU_CHUNK					\
> >> +	(sizeof(struct pcpu_chunk) +					\
> >> +	 (num_possible_cpus() << PCPU_UNIT_PAGES_SHIFT) * sizeof(struct page *))
> > 
> > This macro generates real code.  It is misleading to pretend that it is
> > a compile-time constant.  Suggest that it be converted to a plain old C
> > function.
> 
> Please see below.
> 
> >> +static int __pcpu_unit_pages_shift = PCPU_MIN_UNIT_PAGES_SHIFT;
> >> +static int __pcpu_unit_pages;
> >> +static int __pcpu_unit_shift;
> >> +static int __pcpu_unit_size;
> >> +static int __pcpu_chunk_size;
> >> +static int __pcpu_nr_slots;
> >> +
> >> +/* currently everything is power of two, there's no hard dependency on it tho */
> >> +#define PCPU_UNIT_PAGES_SHIFT	((int)__pcpu_unit_pages_shift)
> >> +#define PCPU_UNIT_PAGES		((int)__pcpu_unit_pages)
> >> +#define PCPU_UNIT_SHIFT		((int)__pcpu_unit_shift)
> >> +#define PCPU_UNIT_SIZE		((int)__pcpu_unit_size)
> >> +#define PCPU_CHUNK_SIZE		((int)__pcpu_chunk_size)
> >> +#define PCPU_NR_SLOTS		((int)__pcpu_nr_slots)
> > 
> > hm.  Why do these exist?
> 
> Because those parameters are initialized during boot but should work
> as constant once they're set up.  I wanted to make sure that these
> values don't get assigned to or changed and make that clear by making
> them look like constants as except for the init code they're constants
> for all purposes.

Well, there are an infinite number of ways in which people can later introduce
bugs.  Why defend against just one?  Particularly in a way which muckies up
the code?

If you really want to defend against alterations, access these things
via function calls rather than via nastycasts which masquerade as
constants?

static inline int pcpu_unit_pages_shift(void)
{
	return __pcpu_unit_pages_shift;
}

> >> +/**
> >> + * pcpu_realloc - versatile realloc
> >> + * @p: the current pointer (can be NULL for new allocations)
> >> + * @size: the current size (can be 0 for new allocations)
> >> + * @new_size: the wanted new size (can be 0 for free)
> > 
> > So the allocator doesn't internally record the size of each hunk?
> > 
> > <squints at the undocumented `free_size'>
> 
> This one is a utility function used only inside allocator
> implementation as I wanted something more robust than krealloc.  It
> has nothing to do with the free_size or chunk management.
> 
> ...
> > This function can be called under spinlock if new_size>PAGE_SIZE and
> > the kernel won't (I think) warn.  If new_size<=PAGE_SIZE, the kernel
> > will warn.
> > 
> > Methinks vmalloc() should have a might_sleep().  Dunno.
> 
> I can add that but it's an internal utility function which is called
> from a few well known obvious call sites to replace krealloc, so I
> don't thinks it's a big deal.  Maybe the correct thing to do is adding
> might_sleep() to vmalloc?

I think so.  It perhaps already has one, via indirect means.

> >> + * pcpu_populate_chunk - populate and map an area of a pcpu_chunk
> >> + * @chunk: chunk of interest
> >> + * @off: offset to the area to populate
> >> + * @size: size of the area to populate
> >> + *
> >> + * For each cpu, populate and map pages [@page_start,@page_end) into
> >> + * @chunk.  The area is cleared on return.
> >> + */
> >> +static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
> >> +{
> >> +	const gfp_t alloc_mask = GFP_KERNEL | __GFP_HIGHMEM | __GFP_COLD;
> > 
> > A designed decision has been made to not permit the caller to specify
> > the allocation mode?
> 
> The design decision was inherited from the original percpu allocator.

That doesn't mean it's right ;)

But I don't recall us ever wishing that the gfp_t arg had been
included.

> >> +static void free_pcpu_chunk(struct pcpu_chunk *chunk)
> >> +{
> >> +	if (!chunk)
> >> +		return;
> > 
> > afaict this test is unneeded.
> 
> I think it's better to put NULL test to free functions in general.
> People expect free functions to take NULL argument and swallow it.
> Doint it otherwise adds unnecessary danger for subtle bugs later on.

It's a dumb convention.  In the vast majority of cases the pointer is
not NULL.  We add a test-n-branch to 99.999999999% of cases just to
save three seconds of programmer effort a single time.

A better design would have been to have kfree() and
kfree_might_be_null().  (We can still do that by adding a new
kfree_im_not_stupid() which doesn't do the check).

It's a bad tradeoff to expend billions of cycles on millions of
machines to save a little programmer effort.

(And we're not consistent anyway - see pci_free_consistent)

> 
> >> +void *__alloc_percpu(size_t size, size_t align)
> >> +{
> >> +	void *ptr = NULL;
> >> +	struct pcpu_chunk *chunk;
> >> +	int slot, off, err;
> >> +
> >> +	if (unlikely(!size))
> >> +		return NULL;
> > 
> > hm.  Why do we do this?  Perhaps emitting this warning:
> > 
> >> +	if (unlikely(size > PAGE_SIZE << PCPU_MIN_UNIT_PAGES_SHIFT ||
> >> +		     align > PAGE_SIZE)) {
> >> +		printk(KERN_WARNING "illegal size (%zu) or align (%zu) for "
> >> +		       "percpu allocation\n", size, align);
> > 
> > would be more appropriate.
> 
> Maybe.  Dunno.  Returning NULL is what malloc/calloc are allowed to do
> at least.

Yes, but it is probably a programming error in the caller.  We want to
report that asap, not hide it.  The buggy caller will probably now
assume that the memory allocation failed and will bale out altogether,
leaving everyone all confused.

> >> +/**
> >> + * free_percpu - free percpu area
> >> + * @ptr: pointer to area to free
> >> + *
> >> + * Free percpu area @ptr.  Might sleep.
> >> + */
> >> +void free_percpu(void *ptr)
> >> +{
> >> +	void *addr = __pcpu_ptr_to_addr(ptr);
> >> +	struct pcpu_chunk *chunk;
> >> +	int off;
> >> +
> >> +	if (!ptr)
> >> +		return;
> > 
> > Do we ever do this?  Should it be permitted?  Should we warn?
> 
> Dunno but should be allowed, yes, no.  :-)

It adds cycles and hides caller bugs.  Zap it!
