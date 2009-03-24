Return-Path: <linux-kernel-owner+w=401wt.eu-S1763681AbZCXUMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763681AbZCXUMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760735AbZCXUL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:11:58 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:51583 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759773AbZCXUL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:11:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqMFANvYyElMQW1W/2dsb2JhbACBUNFOg3YG
Date: Tue, 24 Mar 2009 16:11:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Christoph Hellwig <hch@infradead.org>
Cc: Jason Baron <jbaron@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 2/9] LTTng instrumentation - irq
Message-ID: <20090324201146.GA4350@Krystal>
References: <20090324155625.420966314@polymtl.ca> <20090324160148.080628193@polymtl.ca> <20090324173354.GC3129@redhat.com> <20090324175049.GC31117@elte.hu> <20090324175750.GE3129@redhat.com> <20090324191252.GA11665@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090324191252.GA11665@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:53:23 up 24 days, 16:19,  1 user,  load average: 0.50, 0.77,
	0.64
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Jason Baron <jbaron@redhat.com> wrote:
> 
> > On Tue, Mar 24, 2009 at 06:50:49PM +0100, Ingo Molnar wrote:
> > > * Jason Baron <jbaron@redhat.com> wrote:
> > > 
> > > > On Tue, Mar 24, 2009 at 11:56:27AM -0400, Mathieu Desnoyers wrote:
> > > > > Instrumentation of IRQ related events : irq_entry, irq_exit and
> > > > > irq_next_handler.
> > > > > 
> > > > > It allows tracers to perform latency analysis on those various types of
> > > > > interrupts and to detect interrupts with max/min/avg duration. It helps
> > > > > detecting driver or hardware problems which cause an ISR to take ages to
> > > > > execute. It has been shown to be the case with bogus hardware causing an mmio
> > > > > read to take a few milliseconds.
> > > > > 
> > > > > Those tracepoints are used by LTTng.
> > > > > 
> > > > > About the performance impact of tracepoints (which is comparable to markers),
> > > > > even without immediate values optimizations, tests done by Hideo Aoki on ia64
> > > > > show no regression. His test case was using hackbench on a kernel where
> > > > > scheduler instrumentation (about 5 events in code scheduler code) was added.
> > > > > See the "Tracepoints" patch header for performance result detail.
> > > > > 
> > > > > irq_entry and irq_exit not declared static because they appear in x86 arch code.
> > > > > 
> > > > > The idea behind logging irq/softirq/tasklet/(and eventually syscall) entry and
> > > > > exit events is to be able to recreate the kernel execution state at a given
> > > > > point in time. Knowing which execution context is responsible for a given trace
> > > > > event is _very_ valuable in trace data analysis.
> > > > > 
> > > > > The IRQ instrumentation instruments the IRQ handler entry and exit. Jason
> > > > > instrumented the irq notifier chain calls (irq_handler_entry/exit). His approach
> > > > > provides information about which handler is being called, but does not map
> > > > > correctly to the fact that _multiple_ handlers are being called from within the
> > > > > same interrupt handler. From an interrupt latency analysis POV, this is
> > > > > incorrect.
> > > > > 
> > > > 
> > > > Since we are passing back the irq number, and we can not be 
> > > > interrupted by the same irq, I think it should be pretty clear we 
> > > > are in the same handler. That said, the extra entry/exit 
> > > > tracepoints could make the sequence of events simpler to decipher, 
> > > > which is important. The code looks good, and provides at least as 
> > > > much information as the patch that I proposed. So i'll be happy 
> > > > either way :)
> > > 
> > > We already have your patch merged up in the tracing tree and it 
> > > gives entry+exit tracepoints.
> > > 
> > > 	Ingo
> > 
> > maybe i wasn't clear. Entry and exit as I proposed and as in the 
> > tracing tree are for entry and exit into each handler per irq. 
> > Mathieu is proposing an entry/exit tracepoint per irq, and a 3rd 
> > tracepoint to tell us which handler is being called and its return 
> > code. hope this is clear.
> 
> Ok, i misunderstood that.
> 
> Mathieu's is slightly more compact, but yours is more logical.
> 
> I believe your pre/post IRQ handler callback is the right model - it 
> decouples device IRQ handling from any notion of 'IRQ'.
> 
> For example, we could correctly express "handler got executed by an 
> IRQ thread" via it - while via Mathieu's scheme it does not really 
> map to that.
> 
> So if then i think there should be a third tracepoint in addition to 
> your two existing tracepoints: a 'raw vector' type of tracepoint. 
> It's added both to do_IRQ() entry point, but also to the various 
> common SMP IPI entry points: reschedule, TLB flush and local timer 
> IRQ tick.
> 
> The best information there to pass to the probe is the raw vector 
> number, and the ptregs structure.
> 
> Hm?
> 

This third type of tracepoint for IRQs you are talking about is actually
what I had in LTTng. I decided to add the irq_next_handler and to add a
action field to irq_entry to include the irq handler information needed
by Jason.

If we want to do this logically, without thinking about tracer
performance impact, we could/should do :

trace_irq_entry(irqno, pt_regs)
  for_each_handler() {
    trace_irq_handler_entry(action)
    action->handler()
    trace_irq_handler_exit(ret)
  }
trace_irq_exit(retval)

And add the irq_entry/irq_exit events to the arch-specific reschedule,
tlb flush, local timer irq, as I have in my lttng tree already.

But given the trace_irq_handler_entry/trace_irq_handler_exit events
could be combined, given we can record action and ret in the
irq_entry/exit events, I decided to remove 2 tracepoints (out of 4) from
the single-handler fast path by adding this information to the irq
entry/exit events, and decided to combine the irq_handler entry/exit
into a single next_handler event, which records the previous ret value
and the next action to execute.

On an interrupt-driven workload, it will have a significant impact.
(2 events vs 4).

If we add interrupt threads to the kernel, then we can switch to the
following scheme :

* instrumentation of the real interrupt handler :

trace_irq_entry(irqno, pt_regs)

trace_irq_exit(ret)

* instrumentation of the irq threads :

trace_irq_thread_entry()

trace_irq_thread_exit()

I don't see why we should mind trying to make the tracepoints "logical",
especially if it hurts performance considerably. Doing these
implementation-specific versions of irq tracepoints would provide the
best performance we can get when tracing. It's up to the tracers to
specialize their analysis based on the underlying IRQ mechanism
(non-threaded vs threaded).

This is actually a very good example of what Christoph Hellwig, Peter
Zijlstra and myself have been trying to warn you about the TRACE_EVENT
macro : it exports the tracepoints to userspace, and thus makes them a
userspace-visible API, when those tracepoints should be tied to the
kernel code and nothing else. An adaptation layer should provide the
abstractions that makes the information presented to the user more
"logical".

Mathieu

> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
