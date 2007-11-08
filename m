Return-Path: <linux-kernel-owner+w=401wt.eu-S1759550AbXKHMea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550AbXKHMea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 07:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbXKHMeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 07:34:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42474 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbXKHMeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 07:34:22 -0500
Subject: Re: [patch 01/28] cpu alloc: The allocator
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20071106195157.878563669@sgi.com>
References: <20071106195144.983665861@sgi.com>
	 <20071106195157.878563669@sgi.com>
Content-Type: text/plain
Date: Thu, 08 Nov 2007 13:34:17 +0100
Message-Id: <1194525257.6289.145.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-06 at 11:51 -0800, Christoph Lameter wrote:

> +/*
> + * Lock to protect the bitmap and the meta data for the cpu allocator.
> + */
> +static DEFINE_SPINLOCK(cpu_alloc_map_lock);

I thought you got nightmares from global locks :-)

> +/*
> + * Allocate an object of a certain size
> + *
> + * Returns a special pointer that can be used with CPU_PTR to find the
> + * address of the object for a certain cpu.
> + */
> +void *cpu_alloc(unsigned long size, gfp_t gfpflags, unsigned long align)
> +{
> +	unsigned long start;
> +	int units = size_to_units(size);
> +	void *ptr;
> +	int first;
> +	unsigned long map_size;
> +
> +	BUG_ON(gfpflags & ~(GFP_RECLAIM_MASK | __GFP_ZERO));
> +
> +	spin_lock(&cpu_alloc_map_lock);
> +
> +restart:
> +	map_size = PAGE_SIZE << cpu_alloc_map_order;
> +	first = 1;
> +	start = first_free;
> +
> +	for ( ; ; ) {
> +
> +		start = find_next_zero_bit(cpu_alloc_map, map_size, start);
> +		if (first)
> +			first_free = start;
> +
> +		if (start >= units_total) {
> +			if (expand_cpu_area(gfpflags))
> +				goto out_of_memory;
> +			goto restart;
> +		}
> +
> +		/*
> +		 * Check alignment and that there is enough space after
> +		 * the starting unit.
> +		 */
> +		if (start % (align / UNIT_SIZE) == 0 &&
> +			find_next_bit(cpu_alloc_map, map_size, start + 1)
> +							>= start + units)
> +				break;
> +		start++;
> +		first = 0;
> +	}
> +
> +	if (first)
> +		first_free = start + units;
> +
> +	while (start + units > units_total) {
> +		if (expand_cpu_area(gfpflags))
> +			goto out_of_memory;
> +	}
> +
> +	set_map(start, units);
> +	units_free -= units;
> +	__count_vm_events(CPU_BYTES, units * UNIT_SIZE);
> +
> +	spin_unlock(&cpu_alloc_map_lock);
> +
> +	ptr = cpu_area + start * UNIT_SIZE;
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
> +	spin_unlock(&cpu_alloc_map_lock);
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
> +	int units = size_to_units(size);
> +	int index;
> +	u8 *p = start;
> +
> +	BUG_ON(p < cpu_area);
> +	index = (p - cpu_area) / UNIT_SIZE;
> +	BUG_ON(!test_bit(index, cpu_alloc_map) ||
> +			index >= units_total);
> +
> +	spin_lock(&cpu_alloc_map_lock);
> +
> +	clear_map(index, units);
> +	units_free += units;
> +	__count_vm_events(CPU_BYTES, -units * UNIT_SIZE);
> +	if (index < first_free)
> +		first_free = index;
> +
> +	spin_unlock(&cpu_alloc_map_lock);
> +}
> +EXPORT_SYMBOL(cpu_free);

Why a bitmap allocator and not a heap allocator?

Also, looking at the lock usage, this thing is not IRQ safe, so it
should not be called from hardirq context. Please document this.

> +#ifndef _LINUX_CPU_ALLOC_H_
> +#define _LINUX_CPU_ALLOC_H_
> +
> +#define CPU_OFFSET(__cpu) \
> +	((unsigned long)(__cpu) << (CONFIG_CPU_AREA_ORDER + PAGE_SHIFT))
> +
> +#define CPU_PTR(__p, __cpu) ((__typeof__(__p))((void *)(__p) + \
> +							CPU_OFFSET(__cpu)))
> +
> +#define CPU_ALLOC(type, flags)	cpu_alloc(sizeof(type), flags, \
> +					__alignof__(type))
> +#define CPU_FREE(pointer)	cpu_free(pointer, sizeof(*(pointer)))
> +
> +#define THIS_CPU(__p)	CPU_PTR(__p, smp_processor_id())
> +#define __THIS_CPU(__p)	CPU_PTR(__p, raw_smp_processor_id())
> +
> +/*
> + * Raw calls
> + */
> +void *cpu_alloc(unsigned long size, gfp_t gfp, unsigned long align);
> +void cpu_free(void *cpu_pointer, unsigned long size);
> +
> +#endif /* _LINUX_CPU_ALLOC_H_ */

Like said in the previous mail (which due to creative mailing from your
end never made it out to the lists), I dislike those shouting macros.
Please lowercase them.


