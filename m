Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbYE3E7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbYE3E7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbYE3E6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:58:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751030AbYE3E6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:58:52 -0400
Date: Thu, 29 May 2008 21:58:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 02/41] cpu alloc: The allocator
Message-Id: <20080529215833.469c3cbe.akpm@linux-foundation.org>
In-Reply-To: <20080530040011.084909898@sgi.com>
References: <20080530035620.587204923@sgi.com>
	<20080530040011.084909898@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 20:56:22 -0700 Christoph Lameter <clameter@sgi.com> wrote:

> The per cpu allocator allows dynamic allocation of memory on all
> processors simultaneously. A bitmap is used to track used areas.
> The allocator implements tight packing to reduce the cache footprint
> and increase speed since cacheline contention is typically not a concern
> for memory mainly used by a single cpu. Small objects will fill up gaps
> left by larger allocations that required alignments.
> 
> The size of the cpu_alloc area can be changed via make menuconfig.
> 
> ...
>
> +config CPU_ALLOC_SIZE
> +	int "Size of cpu alloc area"
> +	default "30000"

strange choice of a default?  I guess it makes it clear that there's no
particular advantage in making it a power-of-two or anything like that.

> +	help
> +	  Sets the maximum amount of memory that can be allocated via cpu_alloc
> Index: linux-2.6/mm/Makefile
> ===================================================================
> --- linux-2.6.orig/mm/Makefile	2008-05-29 19:41:21.000000000 -0700
> +++ linux-2.6/mm/Makefile	2008-05-29 20:15:41.000000000 -0700
> @@ -11,7 +11,7 @@ obj-y			:= bootmem.o filemap.o mempool.o
>  			   maccess.o page_alloc.o page-writeback.o pdflush.o \
>  			   readahead.o swap.o truncate.o vmscan.o \
>  			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
> -			   page_isolation.o $(mmu-y)
> +			   page_isolation.o cpu_alloc.o $(mmu-y)
>  
>  obj-$(CONFIG_PROC_PAGE_MONITOR) += pagewalk.o
>  obj-$(CONFIG_BOUNCE)	+= bounce.o
> Index: linux-2.6/mm/cpu_alloc.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/mm/cpu_alloc.c	2008-05-29 20:13:39.000000000 -0700
> @@ -0,0 +1,167 @@
> +/*
> + * Cpu allocator - Manage objects allocated for each processor
> + *
> + * (C) 2008 SGI, Christoph Lameter <clameter@sgi.com>
> + * 	Basic implementation with allocation and free from a dedicated per
> + * 	cpu area.
> + *
> + * The per cpu allocator allows dynamic allocation of memory on all
> + * processor simultaneously. A bitmap is used to track used areas.
> + * The allocator implements tight packing to reduce the cache footprint
> + * and increase speed since cacheline contention is typically not a concern
> + * for memory mainly used by a single cpu. Small objects will fill up gaps
> + * left by larger allocations that required alignments.
> + */
> +#include <linux/mm.h>
> +#include <linux/mmzone.h>
> +#include <linux/module.h>
> +#include <linux/percpu.h>
> +#include <linux/bitmap.h>
> +#include <asm/sections.h>
> +
> +/*
> + * Basic allocation unit. A bit map is created to track the use of each
> + * UNIT_SIZE element in the cpu area.
> + */
> +#define UNIT_TYPE int
> +#define UNIT_SIZE sizeof(UNIT_TYPE)
> +#define UNITS (CONFIG_CPU_ALLOC_SIZE / UNIT_SIZE)
> +
> +static DEFINE_PER_CPU(UNIT_TYPE, area[UNITS]);
> +
> +/*
> + * How many units are needed for an object of a given size
> + */
> +static int size_to_units(unsigned long size)
> +{
> +	return DIV_ROUND_UP(size, UNIT_SIZE);
> +}

Perhaps it should return UNIT_TYPE? (ugh).

I guess there's no need to ever change that type, so no?

> +/*
> + * Lock to protect the bitmap and the meta data for the cpu allocator.
> + */
> +static DEFINE_SPINLOCK(cpu_alloc_map_lock);
> +static DECLARE_BITMAP(cpu_alloc_map, UNITS);
> +static int first_free;		/* First known free unit */

Would be nicer to move these above size_to_units(), IMO.

> +/*
> + * Mark an object as used in the cpu_alloc_map
> + *
> + * Must hold cpu_alloc_map_lock
> + */
> +static void set_map(int start, int length)
> +{
> +	while (length-- > 0)
> +		__set_bit(start++, cpu_alloc_map);
> +}

bitmap_fill()?

> +/*
> + * Mark an area as freed.
> + *
> + * Must hold cpu_alloc_map_lock
> + */
> +static void clear_map(int start, int length)
> +{
> +	while (length-- > 0)
> +		__clear_bit(start++, cpu_alloc_map);
> +}

bitmap_zero()?

> +/*
> + * Allocate an object of a certain size
> + *
> + * Returns a special pointer that can be used with CPU_PTR to find the
> + * address of the object for a certain cpu.
> + */

Should be kerneldoc, I guess.

> +void *cpu_alloc(unsigned long size, gfp_t gfpflags, unsigned long align)
> +{
> +	unsigned long start;
> +	int units = size_to_units(size);
> +	void *ptr;
> +	int first;
> +	unsigned long flags;
> +
> +	if (!size)
> +		return ZERO_SIZE_PTR;

OK, so we reuse ZERO_SIZE_PTR from kmalloc.

> +	spin_lock_irqsave(&cpu_alloc_map_lock, flags);
> +
> +	first = 1;
> +	start = first_free;
> +
> +	for ( ; ; ) {
> +
> +		start = find_next_zero_bit(cpu_alloc_map, UNITS, start);
> +		if (start >= UNITS)
> +			goto out_of_memory;
> +
> +		if (first)
> +			first_free = start;
> +
> +		/*
> +		 * Check alignment and that there is enough space after
> +		 * the starting unit.
> +		 */
> +		if (start % (align / UNIT_SIZE) == 0 &&
> +			find_next_bit(cpu_alloc_map, UNITS, start + 1)
> +							>= start + units)
> +				break;
> +		start++;
> +		first = 0;
> +	}

This is kinda bitmap_find_free_region(), only bitmap_find_free_region()
isn't quite strong enough.

Generally I think it would have been better if you had added new
primitives to the bitmap library (or enhanced existing ones) and used
them here, rather than implementing private functionality.

> +	if (first)
> +		first_free = start + units;
> +
> +	if (start + units > UNITS)
> +		goto out_of_memory;
> +
> +	set_map(start, units);
> +	__count_vm_events(CPU_BYTES, units * UNIT_SIZE);
> +
> +	spin_unlock_irqrestore(&cpu_alloc_map_lock, flags);
> +
> +	ptr = per_cpu_var(area) + start;
> +
> +	if (gfpflags & __GFP_ZERO) {
> +		int cpu;
> +
> +		for_each_possible_cpu(cpu)
> +			memset(CPU_PTR(ptr, cpu), 0, size);
> +	}
> +
> +	return ptr;
> +
> +out_of_memory:
> +	spin_unlock_irqrestore(&cpu_alloc_map_lock, flags);
> +	return NULL;
> +}
> +EXPORT_SYMBOL(cpu_alloc);
> +
> +/*
> + * Free an object. The pointer must be a cpu pointer allocated
> + * via cpu_alloc.
> + */
> +void cpu_free(void *start, unsigned long size)
> +{
> +	unsigned long units = size_to_units(size);
> +	unsigned long index = (int *)start - per_cpu_var(area);
> +	unsigned long flags;
> +
> +	if (!start || start == ZERO_SIZE_PTR)
> +		return;
> +
> +	BUG_ON(index >= UNITS ||
> +		!test_bit(index, cpu_alloc_map) ||
> +		!test_bit(index + units - 1, cpu_alloc_map));

If this assertion triggers for someone, you'll wish like hell that it
had been implemented as three separate BUG_ONs.

> +	spin_lock_irqsave(&cpu_alloc_map_lock, flags);
> +
> +	clear_map(index, units);
> +	__count_vm_events(CPU_BYTES, -units * UNIT_SIZE);
> +
> +	if (index < first_free)
> +		first_free = index;
> +
> +	spin_unlock_irqrestore(&cpu_alloc_map_lock, flags);
> +}
> +EXPORT_SYMBOL(cpu_free);
> Index: linux-2.6/mm/vmstat.c
> ===================================================================
> --- linux-2.6.orig/mm/vmstat.c	2008-05-29 19:41:21.000000000 -0700
> +++ linux-2.6/mm/vmstat.c	2008-05-29 20:13:39.000000000 -0700
> @@ -653,6 +653,7 @@ static const char * const vmstat_text[] 
>  	"allocstall",
>  
>  	"pgrotated",
> +	"cpu_bytes",
>  #ifdef CONFIG_HUGETLB_PAGE
>  	"htlb_buddy_alloc_success",
>  	"htlb_buddy_alloc_fail",
> Index: linux-2.6/include/linux/percpu.h
> ===================================================================
> --- linux-2.6.orig/include/linux/percpu.h	2008-05-29 19:41:21.000000000 -0700
> +++ linux-2.6/include/linux/percpu.h	2008-05-29 20:29:12.000000000 -0700
> @@ -135,4 +135,50 @@ static inline void percpu_free(void *__p
>  #define free_percpu(ptr)	percpu_free((ptr))
>  #define per_cpu_ptr(ptr, cpu)	percpu_ptr((ptr), (cpu))
>  
> +
> +/*
> + * cpu allocator definitions
> + *
> + * The cpu allocator allows allocating an instance of an object for each
> + * processor and the use of a single pointer to access all instances
> + * of the object. cpu_alloc provides optimized means for accessing the
> + * instance of the object belonging to the currently executing processor
> + * as well as special atomic operations on fields of objects of the
> + * currently executing processor.
> + *
> + * Cpu objects are typically small. The allocator packs them tightly
> + * to increase the chance on each access that a per cpu object is already
> + * cached. Alignments may be specified but the intent is to align the data
> + * properly due to cpu alignment constraints and not to avoid cacheline
> + * contention. Any holes left by aligning objects are filled up with smaller
> + * objects that are allocated later.
> + *
> + * Cpu data can be allocated using CPU_ALLOC. The resulting pointer is
> + * pointing to the instance of the variable in the per cpu area provided
> + * by the loader. It is generally an error to use the pointer directly
> + * unless we are booting the system.
> + *
> + * __GFP_ZERO may be passed as a flag to zero the allocated memory.
> + */
> +
> +/* Return a pointer to the instance of a object for a particular processor */
> +#define CPU_PTR(__p, __cpu)	SHIFT_PERCPU_PTR((__p), per_cpu_offset(__cpu))

eek, a major interface function which is ALL IN CAPS!

can we do this in lower-case?  In a C function?

> +/*
> + * Return a pointer to the instance of the object belonging to the processor
> + * running the current code.
> + */
> +#define THIS_CPU(__p)	SHIFT_PERCPU_PTR((__p), my_cpu_offset)
> +#define __THIS_CPU(__p)	SHIFT_PERCPU_PTR((__p), __my_cpu_offset)
> +
> +#define CPU_ALLOC(type, flags)	((typeof(type) *)cpu_alloc(sizeof(type), \
> +					(flags), __alignof__(type)))
> +#define CPU_FREE(pointer)	cpu_free((pointer), sizeof(*(pointer)))

Dittoes.

> +/*
> + * Raw calls
> + */
> +void *cpu_alloc(unsigned long size, gfp_t flags, unsigned long align);
> +void cpu_free(void *cpu_pointer, unsigned long size);
> +
>  #endif /* __LINUX_PERCPU_H */

