Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbZDROMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbZDROMa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 10:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbZDROMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 10:12:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53880 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789AbZDROMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 10:12:21 -0400
Date: Sat, 18 Apr 2009 10:12:19 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/5] tracing: add same level recursion detection
In-Reply-To: <20090418071111.GB7678@elte.hu>
Message-ID: <alpine.DEB.2.00.0904180956130.1016@gandalf.stny.rr.com>
References: <20090417211135.408179566@goodmis.org> <20090417211231.218150513@goodmis.org> <20090418071111.GB7678@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 18 Apr 2009, Ingo Molnar wrote:
> > +
> > +static void trace_recursive_unlock(void)
> > +{
> > +	int level;
> > +
> > +	level = trace_irq_level();
> > +
> > +	WARN_ON_ONCE(!current->trace_recursion & (1 << level));
> > +
> > +	current->trace_recursion &= ~(1 << level);
> > +}
> > +
> >  static DEFINE_PER_CPU(int, rb_need_resched);
> >  
> >  /**
> > @@ -1514,6 +1548,9 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
> >  	/* If we are tracing schedule, we don't want to recurse */
> >  	resched = ftrace_preempt_disable();
> >  
> > +	if (trace_recursive_lock())
> > +		goto out_nocheck;
> 
> This is obviously a good idea, but i'm nervous about two things 
> here: overhead and placement.

I'm not sure how much overhead is added. It modifies a variable in
current without the need for any atomic operations.

> 
> Firstly, the lock/unlock sequence adds to the critical path of all 
> the tracing infrastructure and makes it slower. Secondly, we do this 
> in ring_buffer_lock_reserve() only - instead of doing it at the 
> outmost layer (where recursion protection is the most effective).

The problem with doing it in the outer most layer is that I may need
to disable preemption. Once I do that, I need to be careful about
calling preempt_enable or preempt_enable_noresched. If you call
preempt enable from within the scheduler, you may end up with an
inifinite recursion. If you use noresched, you may miss a preemption 
point.

the ftrace_preempt_disable handles this, but the enable needs to be done 
in another function, and that means the state needs to be passed to that 
function. It can be done (the ring buffer does this), but instead of 
rewriting the code the ring buffer does, I simply moved the tests into the 
ring buffer.

> 
> So while i've pulled it, it would be nice to rework the concepts 
> here comprehensively. We have a number of atomics, layers, checks, 
> and all that adds overhead and complexity.

Agreed. I added this because I thought the lockdep bug was due to
recurion. It was, but it was due to a spinlock in trace_printk.
I have yet to hit a bug that this code would have detected, so I'm not 
sure yet that it is needed. Especially when the ring buffer becomes 
lockless, then the change of recursion being a problem becomes even more 
minimal.

> 
> The best would be to just face it and disable IRQs via 
> raw_local_irq_save() plus set the trace recursion flag - and do this 
> around all trace point facilities and as early as possible (they are 
> not allowed to sleep anyway).

The ring buffer already disables preemption, but disabling interrupts 
would be even a greater hit on performance. And that gives no protection 
to NMIs, which can also call tracing.

> 
> That would remove many of the "what if an IRQ recurses" uglinesses. 
> CLI/POPF pairs are also very fast on most architectures (a lot of 
> performance-sensitive code in Linux depends on that). This would 
> also improve the end result: IRQs would not mix up the order of 
> trace records occasionally.

Yes, a lot of code in the kernel depends on it, but tracing becomes even a 
bigger hot path. The best tracers give the lowest overhead, and besides, 
it gives no protection to NMIs.

The order is presevered even if an IRQ happens. The first one to hit the 
real "reserve buffer" code will have that order.

I put a lot of work into making sure the buffer can be re-entrant. I would 
hate to just through it away. It is also needed for tracing NMIs. Letting 
interrupts reenter the code gives better testing to know that NMIs would 
work too.

This recursive logic is something that I've even thought about being a 
compiled in option only (DEBUG). Something to try out if we see a failure. 
Again, I wrote this to see if the lockdep hang was caused by the ring 
buffer and even the event tracer. I can move the checks into the events, 
and use a similar approach as the ring buffer does for preempt disable.
But this did not help at all in the debugging but let me know that the 
ring buffer and event tracer were not the reason for the hang. It was the 
spinlock in trace_print that caused the lockup. And I could have sworn I 
wrote a patch for that code before. I think it was lost in the rewrites.

-- Steve

