Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbZKEPeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbZKEPeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 10:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755870AbZKEPeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 10:34:14 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:34753 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbZKEPeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 10:34:12 -0500
Date: Thu, 5 Nov 2009 21:04:04 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Avi Kivity <avi@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 4/6] hw-breakpoints: Rewrite the hw-breakpoints layer
	on top of perf events
Message-ID: <20091105153404.GB3229@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com> <1257275474-5285-5-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257275474-5285-5-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 08:11:12PM +0100, Frederic Weisbecker wrote:
[snipped]
> 
>  /* Available HW breakpoint length encodings */
> -#define HW_BREAKPOINT_LEN_1		0x40
> -#define HW_BREAKPOINT_LEN_2		0x44
> -#define HW_BREAKPOINT_LEN_4		0x4c
> -#define HW_BREAKPOINT_LEN_EXECUTE	0x40
> +#define X86_BREAKPOINT_LEN_1		0x40
> +#define X86_BREAKPOINT_LEN_2		0x44
> +#define X86_BREAKPOINT_LEN_4		0x4c
> +#define X86_BREAKPOINT_LEN_EXECUTE	0x40
> 

It had previously been suggested http://lkml.org/lkml/2009/5/28/554
that users be allowed to specify the lengths in numerals. Despite having
some divergent views initially, I see that it would help minimise the
amount of code required to request a breakpoint if numerals (such as 1,
2, 4 and 8 for x86_64) are allowed.

The conversion to encoded values can happen later inside the
bkpt-specific code.

> --- a/include/asm-generic/hw_breakpoint.h
> +++ /dev/null

Can you split this patch into fine granular ones? It is very difficult
to review the changes this way.

> diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
> new file mode 100644
> index 0000000..7eba9b9
> --- /dev/null
> +++ b/include/linux/hw_breakpoint.h

Have you clubbed file renaming along with changes inside the file?
Again, it'd be good to have them in separate patches for easy review.

> +#ifdef CONFIG_HAVE_HW_BREAKPOINT
> +extern struct perf_event *
> +register_user_hw_breakpoint(unsigned long addr,
> +			    int len,
> +			    int type,
> +			    perf_callback_t triggered,
> +			    struct task_struct *tsk,
> +			    bool active);
> +

I don't understand the benefit behind bringing these parameters into the
interfaces' prototype. Besides they will make addition of new attributes
(if needed later) quite cumbersome. Given that these values are
eventually copied into members of perf_event_attr, I'd suggest that they
accept a pointer to an instance of the structure.

> +/* FIXME: only change from the attr, and don't unregister */
> +extern struct perf_event *
> +modify_user_hw_breakpoint(struct perf_event *bp,
> +			  unsigned long addr,
> +			  int len,
> +			  int type,
> +			  perf_callback_t triggered,
> +			  struct task_struct *tsk,
> +			  bool active);
> +
> +/*
> + * Kernel breakpoints are not associated with any particular thread.
> + */
> +extern struct perf_event *
> +register_wide_hw_breakpoint_cpu(unsigned long addr,
> +				int len,
> +				int type,
> +				perf_callback_t triggered,
> +				int cpu,

Can't it be cpumask_t instead of int cpu? Given that per-cpu breakpoints
will be implemented, it should be very different to implement them for a
subset of cpus too.

> +				bool active);
> +
> +extern struct perf_event **
> +register_wide_hw_breakpoint(unsigned long addr,
> +			    int len,
> +			    int type,
> +			    perf_callback_t triggered,
> +			    bool active);
> +

<snipped>

> diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
> index c1f64e6..08f6d01 100644
> --- a/kernel/hw_breakpoint.c
> +++ b/kernel/hw_breakpoint.c
> @@ -15,6 +15,7 @@
>   *
>   * Copyright (C) 2007 Alan Stern
>   * Copyright (C) IBM Corporation, 2009
> + * Copyright (C) 2009, Frederic Weisbecker <fweisbec@gmail.com>
>   */
> 
>  /*
> @@ -35,334 +36,242 @@
>  #include <linux/init.h>
>  #include <linux/smp.h>
> 
> -#include <asm/hw_breakpoint.h>
> +#include <linux/hw_breakpoint.h>
> +
>  #include <asm/processor.h>
> 
>  #ifdef CONFIG_X86
>  #include <asm/debugreg.h>
>  #endif
> -/*
> - * Spinlock that protects all (un)register operations over kernel/user-space
> - * breakpoint requests
> - */
> -static DEFINE_SPINLOCK(hw_breakpoint_lock);

Wouldn't you want to hold this lock while checking for system-wide
availability of debug registers (during rollbacks) to avoid contenders
from checking for the same simultaneously?

<snipped>

> -int register_kernel_hw_breakpoint(struct hw_breakpoint *bp)
> +struct perf_event **
> +register_wide_hw_breakpoint(unsigned long addr,
> +			    int len,
> +			    int type,
> +			    perf_callback_t triggered,
> +			    bool active)
>  {
> -	int rc;
> +	struct perf_event **cpu_events, **pevent, *bp;
> +	long err;
> +	int cpu;
> +
> +	cpu_events = alloc_percpu(typeof(*cpu_events));
> +	if (!cpu_events)
> +		return ERR_PTR(-ENOMEM);
> 
> -	rc = arch_validate_hwbkpt_settings(bp, NULL);
> -	if (rc)
> -		return rc;
> +	for_each_possible_cpu(cpu) {
> +		pevent = per_cpu_ptr(cpu_events, cpu);
> +		bp = register_kernel_hw_breakpoint_cpu(addr, len, type,
> +					triggered, cpu, active);
> 

I'm assuming that there'd be an implementation for system-wide
perf-events (and hence breakpoints) in the forthcoming version(s) of
this patchset.

> -	spin_lock_bh(&hw_breakpoint_lock);
> +		*pevent = bp;
> 
> -	rc = -ENOSPC;
> -	/* Check if we are over-committing */
> -	if ((hbp_kernel_pos > 0) && (!hbp_user_refcount[hbp_kernel_pos-1])) {
> -		hbp_kernel_pos--;
> -		hbp_kernel[hbp_kernel_pos] = bp;
> -		on_each_cpu(arch_update_kernel_hw_breakpoint, NULL, 1);
> -		rc = 0;
> +		if (IS_ERR(bp) || !bp) {
> +			err = PTR_ERR(bp);
> +			goto fail;
> +		}
>  	}
> 
> -	spin_unlock_bh(&hw_breakpoint_lock);
> -	return rc;
> +	return cpu_events;
> +
> +fail:
> +	for_each_possible_cpu(cpu) {
> +		pevent = per_cpu_ptr(cpu_events, cpu);
> +		if (IS_ERR(*pevent) || !*pevent)
> +			break;
> +		unregister_hw_breakpoint(*pevent);
> +	}
> +	free_percpu(cpu_events);
> +	/* return the error if any */
> +	return ERR_PTR(err);
>  }
> -EXPORT_SYMBOL_GPL(register_kernel_hw_breakpoint);
> 

<snipped>

> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 5087125..98dc56b 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -29,6 +29,7 @@
>  #include <linux/kernel_stat.h>
>  #include <linux/perf_event.h>
>  #include <linux/ftrace_event.h>
> +#include <linux/hw_breakpoint.h>
> 
>  #include <asm/irq_regs.h>
> 
> @@ -4229,6 +4230,51 @@ static void perf_event_free_filter(struct perf_event *event)
> 
>  #endif /* CONFIG_EVENT_PROFILE */
> 
> +#ifdef CONFIG_HAVE_HW_BREAKPOINT
> +static void bp_perf_event_destroy(struct perf_event *event)
> +{
> +	release_bp_slot(event);
> +}
> +
> +static const struct pmu *bp_perf_event_init(struct perf_event *bp)
> +{
> +	int err;
> +	/*
> +	 * The breakpoint is already filled if we haven't created the counter
> +	 * through perf syscall
> +	 * FIXME: manage to get trigerred to NULL if it comes from syscalls
> +	 */
> +	if (!bp->callback)
> +		err = register_perf_hw_breakpoint(bp);
> +	else
> +		err = __register_perf_hw_breakpoint(bp);
> +	if (err)
> +		return ERR_PTR(err);
> +
> +	bp->destroy = bp_perf_event_destroy;
> +
> +	return &perf_ops_bp;
> +}
> +
> +void perf_bp_event(struct perf_event *bp, void *regs)
> +{
> +	/* TODO */
> +}
> +#else
> +static void bp_perf_event_destroy(struct perf_event *event)
> +{
> +}
> +
> +static const struct pmu *bp_perf_event_init(struct perf_event *bp)
> +{
> +	return NULL;
> +}
> +
> +void perf_bp_event(struct perf_event *bp, void *regs)
> +{
> +}
> +#endif
> +
>  atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
> 
>  static void sw_perf_event_destroy(struct perf_event *event)
> @@ -4375,6 +4421,11 @@ perf_event_alloc(struct perf_event_attr *attr,
>  		pmu = tp_perf_event_init(event);
>  		break;
> 
> +	case PERF_TYPE_BREAKPOINT:
> +		pmu = bp_perf_event_init(event);
> +		break;
> +
> +
>  	default:
>  		break;
>  	}
> @@ -4686,7 +4737,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
> 
>  	ctx = find_get_context(pid, cpu);
>  	if (IS_ERR(ctx))
> -		return NULL ;
> +		return NULL;
> 
>  	event = perf_event_alloc(attr, cpu, ctx, NULL,
>  				     NULL, callback, GFP_KERNEL);


Have you tested these changes from perf-events' user-space command?
Would you like to re-use the patches from here:
http://lkml.org/lkml/2009/10/29/304 to test them?

Thanks,
K.Prasad

