Return-Path: <linux-kernel-owner+w=401wt.eu-S1759352AbXEaRRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbXEaRRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 13:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbXEaRQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 13:16:53 -0400
Received: from ccerelbas01.cce.hp.com ([161.114.21.104]:60068 "EHLO
	ccerelbas01.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbXEaRQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 13:16:52 -0400
Date: Thu, 31 May 2007 10:16:17 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/22] 2.6.22-rc3 perfmon2 : common core functions
Message-ID: <20070531171616.GC23939@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <200705291348.l4TDmRvL019775@frankl.hpl.hp.com> <p73ira9ca0d.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73ira9ca0d.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Thu, May 31, 2007 at 05:01:38PM +0200, Andi Kleen wrote:
> Stephane Eranian <eranian@frankl.hpl.hp.com> writes:
> 
> The interface looks very complicated. Is there anything 
> in there that you feel is not strictly needed and should be eliminated
> before merging? After merging it will be more difficult.
> 
Please pinpoint calls/data structure which you find are complicated.
All the features currently supported are used by some tools and have
been requested by users.

> > +/*
> > + * number of elements for each type of bitvector
> > + * all bitvectors use u64 fixed size type on all architectures.
> > + */
> > +#define PFM_BVSIZE(x)	(((x)+(sizeof(u64)<<3)-1) / (sizeof(u64)<<3))
> > +#define PFM_HW_PMD_BV	PFM_BVSIZE(PFM_ARCH_MAX_HW_PMDS)
> 
> Use standard bitmap.h macros? The shifts look over fancy.

For ABI compatibility between 32 and 64 bits, all our bitmaps shared
with user level use u64. bitmap.h uses unsigned long, so I
cannot use BITS_TO_LONG().

Internally, the bitmap.h macros are used to set/test bits. 

> > +
> > +/*
> > + * argument to pfm_create_context() system call
> > + * structure shared with user level
> > + */
> > +struct pfarg_ctx {
> > +	__u32		ctx_flags;	  /* noblock/block/syswide */
> > +	__u32		ctx_reserved1;	  /* ret arg: fd for context */
> 
> Why is it called reserved1 then if it's used according to the comment?
> 
Stale comment. I'll fix that.

> > +	u64 used_pmds[PFM_PMD_BV];    /* used PMDs */
> > +	u64 povfl_pmds[PFM_HW_PMD_BV];   /* pending overflowed PMDs */
> > +	u64 ovfl_pmds[PFM_HW_PMD_BV];    /* last overflowed PMDs */
> > +	u64 reset_pmds[PFM_PMD_BV];   /* union of PMDs to reset */
> > +	u64 ovfl_notify[PFM_PMD_BV];  /* notify on overflow */
> > +	u64 pmcs[PFM_MAX_PMCS];	      /* PMC values */
> 
> Wouldn't array of structs be more cache friendly?

Not necessarily because the kernel code tends to scan the one bitmask at
a time.

> > +
> > +/*
> > + * perfmon context: encapsulates all the state of a monitoring session
> > + */
> > +struct pfm_context {
> > +	spinlock_t		lock;	/* context protection */
> > +
> > +	struct pfm_context_flags flags;	/*  flags */
> > +	u32			state;	/* state */
> 
> unnecessary padding

which padding?

> > +	u64 pfm_restart_count;		/* calls to pfm_restart_count */
> > +	u64 ccnt0;
> > +	u64 ccnt1;
> > +	u64 ccnt2;
> > +	u64 ccnt3;
> > +	u64 ccnt4;
> > +	u64 ccnt5;
> > +	u64 ccnt6;
> 
> Rename to something descriptive or eliminate if not needed?

Those are just stats counters used mostly for debugging.

> > +#define ulp(_x) ((unsigned long *)_x)
> 
> Don't use such non standard macros please.

That goes back to the argument earlier about bitmap.h using unsigned long
and not u64. To avoid compiler warning, I used this macro. I do want
to use the bitmap macros (instead of inventing my own). Andrew once
asked if we should not fix bitmap.h instead.



> > +static inline void pfm_init_percpu(void)
> > +{
> > +	__pfm_init_percpu(NULL);
> > +}
> > +
> > +static inline void pfm_cpu_disable(void)
> > +{
> > +	__pfm_cpu_disable();
> > +}
> 
> Dito.
> 
I'll fix that.

> > +atomic_t perfmon_disabled;	/* >0 if perfmon is disabled */
> 
> Why exactly is that an atomic_t? Normal flag should be enough.
> 
There parameter is checked on entry from perfmon syscalls to fail
if necessary. So there can potentially be a race with the perfmon init.
Yet I do not think this can happen with the existing code base.
I'll simplify that.

> > +
> > +/*
> > + * Reset PMD register flags
> > + */
> > +#define PFM_PMD_RESET_NONE	0	/* do not reset (pfm_switch_set) */
> > +#define PFM_PMD_RESET_SHORT	1	/* use short reset value */
> > +#define PFM_PMD_RESET_LONG	2	/* use long reset value  */
> > +
> > +static union pfarg_msg *pfm_get_new_msg(struct pfm_context *ctx)
> > +{
> > +	int next;
> > +
> > +	next = ctx->msgq_head & PFM_MSGQ_MASK;
> > +
> > +	if ((ctx->msgq_head - ctx->msgq_tail) == PFM_MSGS_COUNT)
> 
> Keep a overflow counter somewhere? 
> 
Are you talking about the overflow of the message queue?

> 
> ..... didn't read all the rest of this huge file. Please split it up more into logical
> chunks.  Some comments on the documentation, but I haven't checked if it actually
> follows the code.
> 
> 
> > +    A preliminary patch exists to have Oprofile work on top of perfmon non
> > +    non Itanium processors. Yet is is not on the OProfile web site and it is
> > +    advised not to use it at this point. As such, CONFIG_OPROFILE must be
> > +    disabled on non Itanium processors.
> 
> That means distributions would need to either disable oprofile or disable
> perfmon? Would probably make users quite unhappy. Not everybody is ready
> yet for the hundreds of pfmon command line arguments...

As I said in the documentation, I have created a proof-of-concept patch for Oprofile
to migrate it on top of perfmon on non-Itanium hardware. It needs more work, and I am
hoping someone from the distrro will pick this up and improve it. From the beginning,
I made sure there was enough features in perfmon to support Oprofile and reuse its
kernel code base. The changes to the user level daemon are fairly limited. It was my
goal to ensure that Oprofile users would not see major disruptions. The wording is
the documentation was maybe too strong.

> > +
> > +   * pmd_max_fast_arg(RO): number of perfmon2 syscall arguments copy directly onto the
> > +   		stack (copyuser) for pfm_write_pmds()/pfm_read_pmds(). Copying to the
> > +		stack avoids having to allocate a buffer. The unit is the number of
> > +		pfarg_pmd_t structures.
> 
> 
> Weird thing to export. That's purely an internal implementation detail isn't it?

Yes, but that could be leveraged by tools to optimize the number of argument they
want to pass per call.

> > +
> > +   * pmu_desc: subdir containing the PMU register mapping information
> > +
> > +   * reset_stats(W): echo 0 > reset_stats resets the statistics collected by perfmon2.
> > +   		stats are available per-cpu in /sys/devices/system/cpu/cpu*/perfmon
> > +   	
> > +   * smpl_buffer_mem_cur(RO): reports the amount of memory currently dedicated to sampling
> > +   		buffers by the kernel.
> > +
> > +   * smpl_buffer_mem_max(RW): maximum amount of memory usable for sampling buffers.
> > +   		-1 means all that is available.
> 
> -1 seems dangerous. 

I could use a % of available memory. Is there another subsystem that ttries to size
its buffer based on available memory at boot time?

> 
> > +
> > +   * sys_group(RW): which users group is allowed to create a system-wide contexts.
> > +   		-1 means any group
> 
> Wouldn't this better be a capability bit? Then it could be just set
> in the normal pam configuration files.
> 
Yes, that would probbaably be better. At least, it would fit the exsiting framework.
I'll fix that as well assuming I understand how to create new capabilities.

Thanks for your comments.

-- 

-Stephane
