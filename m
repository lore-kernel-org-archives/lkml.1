Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbZCYCJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbZCYCJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 22:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbZCYCJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 22:09:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454AbZCYCJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 22:09:10 -0400
Date: Tue, 24 Mar 2009 22:09:07 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Jason Baron <jbaron@redhat.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 2/9] LTTng instrumentation - irq
In-Reply-To: <20090324201146.GA4350@Krystal>
Message-ID: <alpine.DEB.2.00.0903242203480.22830@gandalf.stny.rr.com>
References: <20090324155625.420966314@polymtl.ca> <20090324160148.080628193@polymtl.ca> <20090324173354.GC3129@redhat.com> <20090324175049.GC31117@elte.hu> <20090324175750.GE3129@redhat.com> <20090324191252.GA11665@elte.hu> <20090324201146.GA4350@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 24 Mar 2009, Mathieu Desnoyers wrote:
> 
> This third type of tracepoint for IRQs you are talking about is actually
> what I had in LTTng. I decided to add the irq_next_handler and to add a
> action field to irq_entry to include the irq handler information needed
> by Jason.
> 
> If we want to do this logically, without thinking about tracer
> performance impact, we could/should do :
> 
> trace_irq_entry(irqno, pt_regs)
>   for_each_handler() {
>     trace_irq_handler_entry(action)
>     action->handler()
>     trace_irq_handler_exit(ret)
>   }
> trace_irq_exit(retval)
> 
> And add the irq_entry/irq_exit events to the arch-specific reschedule,
> tlb flush, local timer irq, as I have in my lttng tree already.
> 
> But given the trace_irq_handler_entry/trace_irq_handler_exit events
> could be combined, given we can record action and ret in the
> irq_entry/exit events, I decided to remove 2 tracepoints (out of 4) from
> the single-handler fast path by adding this information to the irq
> entry/exit events, and decided to combine the irq_handler entry/exit
> into a single next_handler event, which records the previous ret value
> and the next action to execute.
> 
> On an interrupt-driven workload, it will have a significant impact.
> (2 events vs 4).

I thought tracepoints while not active are very low overhead.

If you only want to use 2 of the 4, would that be just as fast?

> 
> If we add interrupt threads to the kernel, then we can switch to the
> following scheme :
> 
> * instrumentation of the real interrupt handler :
> 
> trace_irq_entry(irqno, pt_regs)
> 
> trace_irq_exit(ret)
> 
> * instrumentation of the irq threads :
> 
> trace_irq_thread_entry()
> 
> trace_irq_thread_exit()
> 
> I don't see why we should mind trying to make the tracepoints "logical",
> especially if it hurts performance considerably. Doing these
> implementation-specific versions of irq tracepoints would provide the
> best performance we can get when tracing. It's up to the tracers to
> specialize their analysis based on the underlying IRQ mechanism
> (non-threaded vs threaded).

Perhaps we want to make them logical so that other things might hook into 
these trace points besides a tracer. I do not agree that the code should 
be modified just to make the trace points faster. The trace points are 
just hooks into code, and should have no effect when disabled. Once the 
code starts to change due to better placement of tracepoints for tracers, 
that's when those trace points should be NACKed.

-- Steve

