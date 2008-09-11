Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbYIKJBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbYIKJBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 05:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYIKJBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 05:01:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:50786 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbYIKJBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 05:01:04 -0400
Subject: Re: [RFC] CPUMASK: proposal for replacing cpumask_t
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <48C84E9E.7080507@sgi.com>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>
	 <20080906235037.880702000@polaris-admin.engr.sgi.com>
	 <1220783087.8687.73.camel@twins.programming.kicks-ass.net>
	 <48C53C91.70604@sgi.com>
	 <1220886335.12278.31.camel@twins.programming.kicks-ass.net>
	 <20080908183852.GA3713@elte.hu>  <48C84E9E.7080507@sgi.com>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 11:00:30 +0200
Message-Id: <1221123630.4415.1136.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-10 at 15:47 -0700, Mike Travis wrote:
> Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> >>>> NAK
> ....
> > 
> > seconded. Mike, since none of this is v2.6.27 material, lets do it right 
> > with a v2.6.28 target. You know all the cpumask_t using code sites 
> > inside out already, so the know-how is all available already :-) Please 
> > make it finegrained series of patches so that we can resolve conflicts 
> > with other trees more easily.
> > 
> > perhaps propose the new cpumask_t API early (in this thread?), so that 
> > people can comment on it before NAKs come flying against a full patchset 
> > ;-)
> > 
> > 	Ingo
> 
> 
> Here's an initial proposal for abstracting cpumask_t to be either
> an array of 1 or a pointer to an array...   Hopefully this will
> minimize the amount of code changes while providing the capabilities
> this change is attempting to do.
> 
> Comments most welcome. ;-)
> 
> Thanks,
> Mike
> --
> 
> Basically, linux/cpumask.h has the following defines:
> 
> 	typedef struct { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_data;
> 
> 	#if NR_CPUS > BITS_PER_LONG
> 	typedef const cpumask_data	*cpumask_t;
> 	typedef cpumask_data		*cpumask_var;
> 	typedef cpumask_t		cpumask_val;
> 	#define	_NR_CPUS		nr_cpu_ids
> 	#else
> 	typedef const cpumask_data	cpumask_t[1];
> 	typedef cpumask_data		cpumask_var[1];
> 	typedef cpumask_data		cpumask_val;
> 	#define	_NR_CPUS		NR_CPUS
> 	#endif
> 
> So in function prototypes:
> 
> 	cpumask_t function(const cpumask_t *A,
> 			   cpumask_t *B,
> 			   cpumask_t cpumask_C)
> 
> becomes:
> 
> 	cpumask_val function(cpumask_t A,
> 			     cpumask_var B,
> 			     cpumask_t cpumask_C)

I guess we have to stick the const into the typedef otherwise we get a
const pointer instead of a const array member, right?

In which case I much prefer the following names:

 cpumask_data_t  - value

 const_cpumask_t - pointer to constant value
 cpumask_t       - pointer to value

> And in local variables:
> 
> 	cpumask_t ==> cpumask_var  IFF variable is to be written.
> 
> This:
> 
> 	cpumask_t mask = cpu_online_map 
> 	<change mask>
> 
> becomes:
> 
> 	#include <linux/cpumask_alloc.h>
> 
> 	cpumask_var mask;
> 
> 	alloc_cpumask(&mask);

Don't you have to deal with allocation errors?

> 	*mask = *cpu_online_map;
> 	<change mask>
> 	free_cpumask(&mask);
> 
> Currently, alloc_cpumask is:
> 
> 	#define BYTES_PER_CPUMASK (BITS_TO_LONGS(nr_cpu_ids)/sizeof(long))
> 
> 	static inline bool no_cpumask(cpumask_t *m)
> 	{
> 		return (*m == NULL);
> 	}
> 
> 	static inline void alloc_cpumask(cpumask_t *m)
> 	{
> 		cpumask_t d = kmalloc(BYTES_PER_CPUMASK, GFP_KERNEL);
> 		if (no_cpumask(&d))
> 			BUG();

yuckery yuck yuck!

> 		*m = d;
> 	}
> 
> 	static inline void alloc_cpumask_nopanic(cpumask_t *m)
> 	{
> 		cpumask_t d = kmalloc(BYTES_PER_CPUMASK, GFP_KERNEL);
> 
> 		*m = d;
> 	}

gah - at the very least you got the naming wrong, methinks the one
panic-ing should have panic in its name - if you really want to persist
with that variant.

> 	static inline void free_cpumask(cpumask_t *m)
> 	{
> 		kfree(*m);
> 	}
> 
> Other means of obtaining a temporary cpumask_t variable will be provided
> for those cases where kmalloc() is not available.
> 
> Furthermore, system-wide maps become:
> 
> 	extern cpumask_data _cpu_possible_map;			 /* read/write */
> 	extern cpumask_data _cpu_online_map;
> 	extern cpumask_data _cpu_present_map;
> 	extern cpumask_data _cpu_active_map;
> 	#define	cpu_possible_map ((cpumask_t)&_cpu_possible_map) /* read only */
> 	#define	cpu_online_map ((cpumask_t)&_cpu_online_map)
> 	#define	cpu_present_map ((cpumask_t)&_cpu_present_map)
> 	#define	cpu_active_map ((cpumask_t)&_cpu_active_map)
> 
> 
> So code to set these bits would be:
> 
> 	cpu_set(cpu, &_cpu_online_map);
> 	cpu_set(cpu, &_cpu_present_map);
> 	cpu_set(cpu, &_cpu_possible_map);
> 
> Arrays that contain a fixed cpumask would have:
> 
> 	struct xxx {
> 		cpumask_data	cpumask;
> 	};
> 
> .... though we should probably encourage the map to be allocated:
> 
> 	struct xxx {
> 		cpumask_t	readonly_cpumask;
> 		cpumask_var	readwrite_cpumask;
> 	};
> 
> 	alloc_cpumask(&xxx->readonly_cpumask);
> 	alloc_cpumask(&xxx->readwrite_cpumask);
> 
> 
> All the cpu operators become:
> 
> 	#define cpu_XXX(dst, src) _cpu_XXX(dst, src, _NR_CPUS)
> 	static inline void __cpu_XXX(cpumask_var dstp, cpumask_t srcp, int count)
> 	{
> 		XXX_bit(dstp->bits, srcp->bits, count);
> 	}
> 
> (_NR_CPUS being defined to be nr_cpu_ids allows us to allocate variable lengthed arrays.)
> 
> 
> Cpumask initializers become:
> 
> 
> 	#if NR_CPUS <= BITS_PER_LONG
> 
> 	#define INIT_CPU_MASK_ALL					\
> 	(cpumask_t) { {							\
> 		[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD		\
> 	} }
> 
> 	#else
> 	#define INIT_CPU_MASK_ALL					\
> 	(cpumask_data) { {						\
> 		[0 ... BITS_TO_LONGS(NR_CPUS)-2] = ~0UL,		\
> 		[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD		\
> 	} }
> 	#endif
> 
> 	#define INIT_CPU_MASK_NONE					\
> 	(cpumask_data) { {						\
> 		[0 ... BITS_TO_LONGS(NR_CPUS)-1] =  0UL			\
> 	} }
> 
> 	#define INIT_CPU_MASK_CPU0					\
> 	(cpumask_data) { {						\
> 		[0] =  1UL						\
> 	} }
> 
> 	#if NR_CPUS > BITS_PER_LONG
> 	extern cpumask_t cpu_mask_all, cpu_mask_none, cpu_mask_cpu0;
> 	#define CPU_MASK_ALL		(cpu_mask_all)
> 	#define CPU_MASK_NONE		(cpu_mask_none)
> 	#define CPU_MASK_CPU0		(cpu_mask_cpu0)
> 	#else
> 	#define CPU_MASK_ALL		((cpumask_t)&INIT_CPU_MASK_ALL)
> 	#define CPU_MASK_NONE		((cpumask_t)&INIT_CPU_MASK_NONE)
> 	#define CPU_MASK_CPU0		((cpumask_t)&INIT_CPU_MASK_CPU0)
> 	#endif
> 
> And in kernel/cpu.c:
> 
> 	/*
> 	 * provide const cpumask_t's
> 	 */
> 	#if NR_CPUS > BITS_PER_LONG
> 	cpumask_data cpu_mask_all __read_mostly = INIT_CPU_MASK_ALL;
> 	EXPORT_SYMBOL(cpu_mask_all);
> 
> 	cpumask_data cpu_mask_none __read_mostly = INIT_CPU_MASK_NONE;
> 	EXPORT_SYMBOL(cpu_mask_none);
> 
> 	cpumask_data cpu_mask_cpu0 __read_mostly = INIT_CPU_MASK_CPU0;
> 	EXPORT_SYMBOL(cpu_mask_cpu0);
> 	#endif
> 

