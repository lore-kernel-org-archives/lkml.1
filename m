Return-Path: <linux-kernel-owner+w=401wt.eu-S1760049AbZDWWeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbZDWWeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 18:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753681AbZDWWeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 18:34:12 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:59609 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751575AbZDWWeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 18:34:11 -0400
X-BigFish: VPS-50(zz1432R98dR936eQ1805M179dR936fK1804Kzz1202hzzz2fh6bh)
X-FB-SS: 5,13,
Message-ID: <49F0ECCC.70202@am.sony.com>
Date: Thu, 23 Apr 2009 15:33:48 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Russell King <rmk+kernel@arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-arm@lists.arm.linux.org.uk
Subject: Re: [PATCH] Add function graph tracer support for ARM
References: <49F0AEA2.5010309@am.sony.com> <20090423192022.GA5976@nowhere>
In-Reply-To: <20090423192022.GA5976@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Apr 2009 22:33:49.0397 (UTC) FILETIME=[92699850:01C9C463]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Apr 23, 2009 at 11:08:34AM -0700, Tim Bird wrote:
>> Add ftrace function-graph tracer support for ARM.
...

>> This works for me with a gcc 4.1.1 compiler on an
>> OMAP OSK board, with kernel 2.6.29.
> 
> 
> There have been a lot of changes on the function graph tracer
> since 2.6.29 :)

LOL.  It serves me right for going on vacation for a week. ;-)

> I don't know which tree would be the best to rebase this work on, 
> whether ARM or -tip. But anyway it should really be based against
> a 2.6.30 development tree.
Are you talking about -tip of Linus' tree, or is there a
tracing tree I should getting stuff from?

As far as I can tell, the ARM bits that this patch applies
against are relatively stable, so I'd prefer to stay
in synch with an ftrace tree, since that appears to be
the more mobile target at the moment.

...
>> --- a/arch/arm/include/asm/ftrace.h
>> +++ b/arch/arm/include/asm/ftrace.h
>> @@ -7,8 +7,32 @@
>>
>>  #ifndef __ASSEMBLY__
>>  extern void mcount(void);
>> -#endif
>> +#endif /* __ASSEMBLY__ */
>>
>> -#endif
>> +#endif /* CONFIG_FUNCTION_TRACER */
>> +
>> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
>> +
>> +#ifndef __ASSEMBLY__
>> +
>> +/*
>> + * Stack of return addresses for functions of a thread.
>> + * Used in struct thread_info
>> + */
>> +struct ftrace_ret_stack {
>> +	unsigned long ret;
>> +	unsigned long func;
>> +	unsigned long long calltime;
>> +};
> 
> 
> This one is now on <linux/ftrace.h>

OK - I'll update this relative to an appropriate
more recent version.  Thanks.

>> --- a/arch/arm/kernel/ftrace.c
>> +++ b/arch/arm/kernel/ftrace.c
>> @@ -16,6 +16,8 @@
>>  #include <asm/cacheflush.h>
>>  #include <asm/ftrace.h>
>>
>> +#ifdef CONFIG_DYNAMIC_FTRACE
>> +
>>  #define PC_OFFSET      8
>>  #define BL_OPCODE      0xeb000000
>>  #define BL_OFFSET_MASK 0x00ffffff
>> @@ -101,3 +103,147 @@ int __init ftrace_dyn_arch_init(void *da
>>  	ftrace_mcount_set(data);
>>  	return 0;
>>  }
>> +
>> +#endif /* CONFIG_DYNAMIC_FTRACE */
>> +
>> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
>> +
>> +/* Add a function return address to the trace stack on thread info.*/
>> +static int push_return_trace(unsigned long ret, unsigned long long time,
>> +	unsigned long func, int *depth)
>> +{
>> +	int index;
>> +
>> +	if (!current->ret_stack)
>> +		return -EBUSY;
>> +
>> +	/* The return trace stack is full */
>> +	if (current->curr_ret_stack == FTRACE_RETFUNC_DEPTH - 1) {
>> +		atomic_inc(&current->trace_overrun);
>> +		return -EBUSY;
>> +	}
>> +
>> +	index = ++current->curr_ret_stack;
>> +	barrier();
>> +	current->ret_stack[index].ret = ret;
>> +	current->ret_stack[index].func = func;
>> +	current->ret_stack[index].calltime = time;
>> +	*depth = index;
>> +
>> +	return 0;
>> +}
> 
> 
> This part has been moved as generic code in kernel/trace/trace_function_graph.c

OK - same as above, and for the following dittos.  I'll
check the latest and eliminate duplicate stuff.

>> +	struct ftrace_graph_ret trace;
>> +	unsigned long ret;
>> +
>> +	/* guard against trace entry while handling a trace exit */
>> +	already_here++;
> 
> I don't understand the purpose of this variable. Also it's not atomic,
> you will rapidly run into an imbalance of its value due to concurrent
> inc/decrementations.

It as a quick workaround to solve recursion in the trace system
itself.  More notes below.

>> +
>> +	pop_return_trace(&trace, &ret);
>> +	trace.rettime = cpu_clock(raw_smp_processor_id());
>> +	ftrace_graph_return(&trace);
>> +
>> +	if (unlikely(!ret)) {
>> +		ftrace_graph_stop();
>> +		WARN_ON(1);
>> +		/* Might as well panic. Where else to go? */
>> +		ret = (unsigned long)panic;
>> +	}
>> +
>> +	already_here--;
>> +	return ret;
>> +}
>> +
>> +/*
>> + * Hook the return address and push it in the stack of return addrs
>> + * in current thread info.
>> + */
>> +
>> +void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
>> +{
>> +	unsigned long old;
>> +	unsigned long long calltime;
>> +
>> +	struct ftrace_graph_ent trace;
>> +	unsigned long return_hooker = (unsigned long)
>> +				&return_to_handler;
>> +
>> +	if (already_here)
>> +		return;
>> +	already_here++;
> 
> 
> 
> I really don't understand why you want this.
> Not only doesn't it protect anything because it's not atomic
> but moreover this function is supposed to be reentrant.

It's there for recursion, not (non-recursive) reentrancy.
If I don't have this, I walk immediately off the stack when
I enable the trace, because of nested trace entry.

This solution has, as you point out, several issues.
It works OK in a UP environment, but would need to be
per-cpu to be made a proper guard for SMP.

I don't mind doing something per-cpu, but last time I
looked at the atomic_inc stuff, it was super-expensive
on ARM. Is this still the case?

> 
> It's perfectly safe against irq, preemption.
> It's also not reentrant but safe against NMI if you pick the
> protection we have in 2.6.30:
> 
> if (unlikely(in_nmi()))
> 	return;
> 
> Hmm, btw I should move this protection to a higher level,
> we should be able to trace NMI in some conditions.

Pardon my ignorance, but is there an NMI on ARM?

> 
>> +
>> +	if (unlikely(atomic_read(&current->tracing_graph_pause))) {
>> +		already_here--;
>> +		return;
>> +	}
>> +
>> +	/* FIXTHIS - need a local_irqsave here?, (to fend off ints?) */
> 
> 
> No you don't need to protect against irq here.
> This is not racy because an irq will push its return adress to the task stack
> (in struct task_struct) and on return it will pop its return address.
> Then the stack of return addresses will be left intact for the current interrupted
> traced function.

OK - my already_here will interefere with this (eliminating the trace
capture of any irqs caught during a trace event).  I'll have to think
about this more.

> 
>> +	/* FIXTHIS - x86 protects against a fault during this operation!*/
>> +	old = *parent;
>> +	*parent = return_hooker;
> 
> 
> 
> Yeah we protect against fault for that. But we never had any fault problem
> actually. But it's better to keep it, it doesn't impact performances and
> it can help to debug possible future issues in the function graph tracer itself.

OK.

> 
>> +
>> +	if (unlikely(!__kernel_text_address(old))) {
>> +		ftrace_graph_stop();
>> +		*parent = old;
>> +		WARN_ON(1);
>> +		already_here--;
>> +		return;
>> +	}
> 
> 
> We removed this check. It impacts performances and we haven't seen
> any warnings from this place.

OK.

> 
>> +
>> +	/* FIXTHIS - trace entry appears to nest inside following */
>> +	calltime = cpu_clock(raw_smp_processor_id());
> 
> 
> 
> Now we are using the local_clock from kernel/trace/trace_clock.c
> It's just a wrapping to sched_clock() and sched_clock() is faster
> though a bit less accurate.

My personal preference is speed over accuracy, so this is
OK with me.  It does mean, however, that if I get rid of
my guard variable, I'll need to add notrace down through
sched_clock().


> But that's a good beginning. It's great that you've made it work on
> Arm.
> 
> It would be very nice if you could rebase it against latest -tip
> or Arm though I can't tell you which one would be the best.
> 
> -tip is the most up to date with tracing, and Arm is more
> up to date with...heh Arm :-)

I'll work on rebasing against latest -tip.  Let me know if
this means something other than the tip of Linus' tree.

Thanks very much for the feedback.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

