Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbZDWXmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbZDWXmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 19:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbZDWXmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 19:42:31 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:45346 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbZDWXm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 19:42:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q9rDekwlJHDNcqMrMvN0G/jIRyKFw+EQ8TcTLa3BtnXaRMTKm38+eB6RM/R6yLKQG0
         q7Ithr37FD+IpMSlYeQoQnXE1IigSN26tIbSkISr+K8pux190amCBOveq/PQ+loF7gS9
         OV0evUHcqtF6pVxrQRs81Wo/v1CxVJSCgjXko=
Date: Fri, 24 Apr 2009 01:42:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Ingo Molnar <mingo@elte.hu>, Russell King <rmk+kernel@arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-arm@lists.arm.linux.org.uk
Subject: Re: [PATCH] Add function graph tracer support for ARM
Message-ID: <20090423234224.GC5976@nowhere>
References: <49F0AEA2.5010309@am.sony.com> <20090423192022.GA5976@nowhere> <49F0ECCC.70202@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F0ECCC.70202@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 03:33:48PM -0700, Tim Bird wrote:
> Frederic Weisbecker wrote:
> > On Thu, Apr 23, 2009 at 11:08:34AM -0700, Tim Bird wrote:
> >> Add ftrace function-graph tracer support for ARM.
> ...
> 
> >> This works for me with a gcc 4.1.1 compiler on an
> >> OMAP OSK board, with kernel 2.6.29.
> > 
> > 
> > There have been a lot of changes on the function graph tracer
> > since 2.6.29 :)
> 
> LOL.  It serves me right for going on vacation for a week. ;-)
> 
> > I don't know which tree would be the best to rebase this work on, 
> > whether ARM or -tip. But anyway it should really be based against
> > a 2.6.30 development tree.
> Are you talking about -tip of Linus' tree, or is there a
> tracing tree I should getting stuff from?
> 
> As far as I can tell, the ARM bits that this patch applies
> against are relatively stable, so I'd prefer to stay
> in synch with an ftrace tree, since that appears to be
> the more mobile target at the moment.
> 
> ...
> >> --- a/arch/arm/include/asm/ftrace.h
> >> +++ b/arch/arm/include/asm/ftrace.h
> >> @@ -7,8 +7,32 @@
> >>
> >>  #ifndef __ASSEMBLY__
> >>  extern void mcount(void);
> >> -#endif
> >> +#endif /* __ASSEMBLY__ */
> >>
> >> -#endif
> >> +#endif /* CONFIG_FUNCTION_TRACER */
> >> +
> >> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> >> +
> >> +#ifndef __ASSEMBLY__
> >> +
> >> +/*
> >> + * Stack of return addresses for functions of a thread.
> >> + * Used in struct thread_info
> >> + */
> >> +struct ftrace_ret_stack {
> >> +	unsigned long ret;
> >> +	unsigned long func;
> >> +	unsigned long long calltime;
> >> +};
> > 
> > 
> > This one is now on <linux/ftrace.h>
> 
> OK - I'll update this relative to an appropriate
> more recent version.  Thanks.
> 
> >> --- a/arch/arm/kernel/ftrace.c
> >> +++ b/arch/arm/kernel/ftrace.c
> >> @@ -16,6 +16,8 @@
> >>  #include <asm/cacheflush.h>
> >>  #include <asm/ftrace.h>
> >>
> >> +#ifdef CONFIG_DYNAMIC_FTRACE
> >> +
> >>  #define PC_OFFSET      8
> >>  #define BL_OPCODE      0xeb000000
> >>  #define BL_OFFSET_MASK 0x00ffffff
> >> @@ -101,3 +103,147 @@ int __init ftrace_dyn_arch_init(void *da
> >>  	ftrace_mcount_set(data);
> >>  	return 0;
> >>  }
> >> +
> >> +#endif /* CONFIG_DYNAMIC_FTRACE */
> >> +
> >> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> >> +
> >> +/* Add a function return address to the trace stack on thread info.*/
> >> +static int push_return_trace(unsigned long ret, unsigned long long time,
> >> +	unsigned long func, int *depth)
> >> +{
> >> +	int index;
> >> +
> >> +	if (!current->ret_stack)
> >> +		return -EBUSY;
> >> +
> >> +	/* The return trace stack is full */
> >> +	if (current->curr_ret_stack == FTRACE_RETFUNC_DEPTH - 1) {
> >> +		atomic_inc(&current->trace_overrun);
> >> +		return -EBUSY;
> >> +	}
> >> +
> >> +	index = ++current->curr_ret_stack;
> >> +	barrier();
> >> +	current->ret_stack[index].ret = ret;
> >> +	current->ret_stack[index].func = func;
> >> +	current->ret_stack[index].calltime = time;
> >> +	*depth = index;
> >> +
> >> +	return 0;
> >> +}
> > 
> > 
> > This part has been moved as generic code in kernel/trace/trace_function_graph.c
> 
> OK - same as above, and for the following dittos.  I'll
> check the latest and eliminate duplicate stuff.
> 
> >> +	struct ftrace_graph_ret trace;
> >> +	unsigned long ret;
> >> +
> >> +	/* guard against trace entry while handling a trace exit */
> >> +	already_here++;
> > 
> > I don't understand the purpose of this variable. Also it's not atomic,
> > you will rapidly run into an imbalance of its value due to concurrent
> > inc/decrementations.
> 
> It as a quick workaround to solve recursion in the trace system
> itself.  More notes below.
> 
> >> +
> >> +	pop_return_trace(&trace, &ret);
> >> +	trace.rettime = cpu_clock(raw_smp_processor_id());
> >> +	ftrace_graph_return(&trace);
> >> +
> >> +	if (unlikely(!ret)) {
> >> +		ftrace_graph_stop();
> >> +		WARN_ON(1);
> >> +		/* Might as well panic. Where else to go? */
> >> +		ret = (unsigned long)panic;
> >> +	}
> >> +
> >> +	already_here--;
> >> +	return ret;
> >> +}
> >> +
> >> +/*
> >> + * Hook the return address and push it in the stack of return addrs
> >> + * in current thread info.
> >> + */
> >> +
> >> +void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)

> >> +{
> >> +	unsigned long old;
> >> +	unsigned long long calltime;
> >> +
> >> +	struct ftrace_graph_ent trace;
> >> +	unsigned long return_hooker = (unsigned long)
> >> +				&return_to_handler;
> >> +
> >> +	if (already_here)
> >> +		return;
> >> +	already_here++;
> > 
> > 
> > 
> > I really don't understand why you want this.
> > Not only doesn't it protect anything because it's not atomic
> > but moreover this function is supposed to be reentrant.
> 
> It's there for recursion, not (non-recursive) reentrancy.
> If I don't have this, I walk immediately off the stack when
> I enable the trace, because of nested trace entry.
> 
> This solution has, as you point out, several issues.
> It works OK in a UP environment, but would need to be
> per-cpu to be made a proper guard for SMP.
> 
> I don't mind doing something per-cpu, but last time I
> looked at the atomic_inc stuff, it was super-expensive
> on ARM. Is this still the case?


I don't know. But now I understand the point of this guard.
On x86, all these low level functions, such as prepare_ftrace_return,
return_to_handler are using un-traceable functions.

As an example, sched_clock() is protected because x86/kernel/tsc.c
has CFLAGS_REMOVE_tsc.o = -pg
native_sched_clock() (an alias to sched_clock()) is then not traced.
Also it doesn't call any extern traceable functions so this is safe.

There are other CFLAGS_REMOVE_* = -pg around the kernel for critical
places. For exemple kernel_text_address was previously protected when
it was used inside prepare_ftrace_return.

The generic kernel code will of course be the same for arm and
x86 so the files and functions you should care about are in arch/arm.

Just check that you aren't calling one of these from the function graph
tracing code and also do the same check for those which have been moved
in kernel/trace/trace_function_graph.c:

- ftrace_push_return_trace()
- ftrace_pop_return_trace()
- ftrace_return_to_handler()

As an example:

ftrace_push_return_trace() -> trace_clock_local() -> sched_clock()
	-> native_sched_clock() -> .... recursion on arch code?

Three ways to protect a function from tracing:

- __notrace annotations (individual functions), applies on function tracer
  and function graph tracer.
- CFLAGS_REMOVE_tsc.o = -pg (whole files)
- __notrace_funcgraph, same as __notrace but is a nop if !CONFIG_FUNCTION_GRAPH_TRACER
  It is useful in rare cases when we only want to deactivate tracing for
  functions on the function graph tracer but not the function tracer.
  It is rare, I almost only used it for kernel_text_address(). Really
  in doubt it's better to choose __notrace.

Also, the nasty things to debug often happen when you protect a function
but you haven't seen that this function called an extern function which
is traced :-)

Another horrid thing comes when inlined functions are referenced.
It's safe to assume that inline functions are not traced, but if
their address is used as a pointer, then they becomes uninlined
and get traced. It's rare but we have met one of these cases.

Anyway inside trace_graph_entry() or trace_graph_return(),
you can stop worrying about recursion, because these functions
are self protected against recursion.

Concerning the arch functions that you should worry about, you can
start grepping arch/x86 for __notrace and "-pg". But it's only
a start, I guess there are unexpected traps somewhere :)


> 
> > 
> > It's perfectly safe against irq, preemption.
> > It's also not reentrant but safe against NMI if you pick the
> > protection we have in 2.6.30:
> > 
> > if (unlikely(in_nmi()))
> > 	return;
> > 
> > Hmm, btw I should move this protection to a higher level,
> > we should be able to trace NMI in some conditions.
> 
> Pardon my ignorance, but is there an NMI on ARM?


I know know either :)

 
> > 
> >> +
> >> +	if (unlikely(atomic_read(&current->tracing_graph_pause))) {
> >> +		already_here--;
> >> +		return;
> >> +	}
> >> +
> >> +	/* FIXTHIS - need a local_irqsave here?, (to fend off ints?) */
> > 
> > 
> > No you don't need to protect against irq here.
> > This is not racy because an irq will push its return adress to the task stack
> > (in struct task_struct) and on return it will pop its return address.
> > Then the stack of return addresses will be left intact for the current interrupted
> > traced function.
> 
> OK - my already_here will interefere with this (eliminating the trace
> capture of any irqs caught during a trace event).  I'll have to think
> about this more.
> 
> > 
> >> +	/* FIXTHIS - x86 protects against a fault during this operation!*/
> >> +	old = *parent;
> >> +	*parent = return_hooker;
> > 
> > 
> > 
> > Yeah we protect against fault for that. But we never had any fault problem
> > actually. But it's better to keep it, it doesn't impact performances and
> > it can help to debug possible future issues in the function graph tracer itself.
> 
> OK.
> 
> > 
> >> +
> >> +	if (unlikely(!__kernel_text_address(old))) {
> >> +		ftrace_graph_stop();
> >> +		*parent = old;
> >> +		WARN_ON(1);
> >> +		already_here--;
> >> +		return;
> >> +	}
> > 
> > 
> > We removed this check. It impacts performances and we haven't seen
> > any warnings from this place.
> 
> OK.
> 
> > 
> >> +
> >> +	/* FIXTHIS - trace entry appears to nest inside following */
> >> +	calltime = cpu_clock(raw_smp_processor_id());
> > 
> > 
> > 
> > Now we are using the local_clock from kernel/trace/trace_clock.c
> > It's just a wrapping to sched_clock() and sched_clock() is faster
> > though a bit less accurate.
> 
> My personal preference is speed over accuracy, so this is
> OK with me.  It does mean, however, that if I get rid of
> my guard variable, I'll need to add notrace down through
> sched_clock().



Yeah, or may remove -pg on a whole file. I don't know much the arch/arm
place so, it depends on how native_sched_clock() is implemented,
if it calls another functions, whether they are inline, on the same
file or extern...



> 
> > But that's a good beginning. It's great that you've made it work on
> > Arm.
> > 
> > It would be very nice if you could rebase it against latest -tip
> > or Arm though I can't tell you which one would be the best.
> > 
> > -tip is the most up to date with tracing, and Arm is more
> > up to date with...heh Arm :-)
> 
> I'll work on rebasing against latest -tip.  Let me know if
> this means something other than the tip of Linus' tree.



It's not the mainline, it's a tree which handles the tracing
branch and also another things (x86, scheduler, etc...):

http://people.redhat.com/mingo/tip.git/readme.txt


Another thing. How do you handle 64 bits return values?
You get the return value in r0 for most calls but
I suspect a pair of registers (r1:r0 ?) is used for
64 bits return values, which includes a lot of
clock related functions.

In x86, we solved it by always returning the edx:eax pair.

Thanks,
Frederic.

