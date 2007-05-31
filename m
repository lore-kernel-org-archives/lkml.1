Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbXEaOFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbXEaOFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 10:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbXEaOFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 10:05:01 -0400
Received: from ns2.suse.de ([195.135.220.15]:34814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbXEaOFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 10:05:00 -0400
To: Stephane Eranian <eranian@frankl.hpl.hp.com>
Cc: linux-kernel@vger.kernel.org, eranian@hpl.hp.com
Subject: Re: [PATCH 13/22] 2.6.22-rc3 perfmon2 : common core functions
References: <200705291348.l4TDmRvL019775@frankl.hpl.hp.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 31 May 2007 17:01:38 +0200
In-Reply-To: <200705291348.l4TDmRvL019775@frankl.hpl.hp.com>
Message-ID: <p73ira9ca0d.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian <eranian@frankl.hpl.hp.com> writes:

The interface looks very complicated. Is there anything 
in there that you feel is not strictly needed and should be eliminated
before merging? After merging it will be more difficult.

> +/*
> + * number of elements for each type of bitvector
> + * all bitvectors use u64 fixed size type on all architectures.
> + */
> +#define PFM_BVSIZE(x)	(((x)+(sizeof(u64)<<3)-1) / (sizeof(u64)<<3))
> +#define PFM_HW_PMD_BV	PFM_BVSIZE(PFM_ARCH_MAX_HW_PMDS)

Use standard bitmap.h macros? The shifts look over fancy.
> +
> +/*
> + * argument to pfm_create_context() system call
> + * structure shared with user level
> + */
> +struct pfarg_ctx {
> +	__u32		ctx_flags;	  /* noblock/block/syswide */
> +	__u32		ctx_reserved1;	  /* ret arg: fd for context */

Why is it called reserved1 then if it's used according to the comment?

> +	u64 used_pmds[PFM_PMD_BV];    /* used PMDs */
> +	u64 povfl_pmds[PFM_HW_PMD_BV];   /* pending overflowed PMDs */
> +	u64 ovfl_pmds[PFM_HW_PMD_BV];    /* last overflowed PMDs */
> +	u64 reset_pmds[PFM_PMD_BV];   /* union of PMDs to reset */
> +	u64 ovfl_notify[PFM_PMD_BV];  /* notify on overflow */
> +	u64 pmcs[PFM_MAX_PMCS];	      /* PMC values */

Wouldn't array of structs be more cache friendly?
> +
> +/*
> + * perfmon context: encapsulates all the state of a monitoring session
> + */
> +struct pfm_context {
> +	spinlock_t		lock;	/* context protection */
> +
> +	struct pfm_context_flags flags;	/*  flags */
> +	u32			state;	/* state */

unnecessary padding
> +	u64 pfm_restart_count;		/* calls to pfm_restart_count */
> +	u64 ccnt0;
> +	u64 ccnt1;
> +	u64 ccnt2;
> +	u64 ccnt3;
> +	u64 ccnt4;
> +	u64 ccnt5;
> +	u64 ccnt6;

Rename to something descriptive or eliminate if not needed?
> +#define ulp(_x) ((unsigned long *)_x)

Don't use such non standard macros please.
> +
> +static inline void pfm_handle_work(struct pt_regs *regs)
> +{
> +	__pfm_handle_work(regs);
> +}

Unnecessary wrapper

> +
> +static inline void pfm_copy_thread(struct task_struct *task)
> +{
> +	/*
> +	 * context or perfmon TIF state  is NEVER inherited
> +	 * in child task. Holds for per-thread and system-wide
> +	 */
> +	task->pfm_context = NULL;
> +	clear_tsk_thread_flag(task, TIF_PERFMON_CTXSW);
> +	clear_tsk_thread_flag(task, TIF_PERFMON_WORK);
> +}
> +
> +static inline void pfm_ctxsw(struct task_struct *p, struct task_struct *n)
> +{
> +	__pfm_ctxsw(p, n);
> +}

Similar.

> +static inline void pfm_init_percpu(void)
> +{
> +	__pfm_init_percpu(NULL);
> +}
> +
> +static inline void pfm_cpu_disable(void)
> +{
> +	__pfm_cpu_disable();
> +}

Dito.

> +atomic_t perfmon_disabled;	/* >0 if perfmon is disabled */

Why exactly is that an atomic_t? Normal flag should be enough.

> +
> +/*
> + * Reset PMD register flags
> + */
> +#define PFM_PMD_RESET_NONE	0	/* do not reset (pfm_switch_set) */
> +#define PFM_PMD_RESET_SHORT	1	/* use short reset value */
> +#define PFM_PMD_RESET_LONG	2	/* use long reset value  */
> +
> +static union pfarg_msg *pfm_get_new_msg(struct pfm_context *ctx)
> +{
> +	int next;
> +
> +	next = ctx->msgq_head & PFM_MSGQ_MASK;
> +
> +	if ((ctx->msgq_head - ctx->msgq_tail) == PFM_MSGS_COUNT)

Keep a overflow counter somewhere? 


..... didn't read all the rest of this huge file. Please split it up more into logical
chunks.  Some comments on the documentation, but I haven't checked if it actually
follows the code.


> +    A preliminary patch exists to have Oprofile work on top of perfmon non
> +    non Itanium processors. Yet is is not on the OProfile web site and it is
> +    advised not to use it at this point. As such, CONFIG_OPROFILE must be
> +    disabled on non Itanium processors.

That means distributions would need to either disable oprofile or disable
perfmon? Would probably make users quite unhappy. Not everybody is ready
yet for the hundreds of pfmon command line arguments...

> +
> +   * pmd_max_fast_arg(RO): number of perfmon2 syscall arguments copy directly onto the
> +   		stack (copyuser) for pfm_write_pmds()/pfm_read_pmds(). Copying to the
> +		stack avoids having to allocate a buffer. The unit is the number of
> +		pfarg_pmd_t structures.


Weird thing to export. That's purely an internal implementation detail isn't it?

> +
> +   * pmu_desc: subdir containing the PMU register mapping information
> +
> +   * reset_stats(W): echo 0 > reset_stats resets the statistics collected by perfmon2.
> +   		stats are available per-cpu in /sys/devices/system/cpu/cpu*/perfmon
> +   	
> +   * smpl_buffer_mem_cur(RO): reports the amount of memory currently dedicated to sampling
> +   		buffers by the kernel.
> +
> +   * smpl_buffer_mem_max(RW): maximum amount of memory usable for sampling buffers.
> +   		-1 means all that is available.

-1 seems dangerous. 

> +
> +   * sys_group(RW): which users group is allowed to create a system-wide contexts.
> +   		-1 means any group

Wouldn't this better be a capability bit? Then it could be just set
in the normal pam configuration files.

> +
> +   * sys_sessions_count(RO): number of loaded system-wide contexts
> +
> +   * task_group(RW): which users group is allowed to create per-thread contexts.
> +   		-1 means any group

Similar.

-Andi
