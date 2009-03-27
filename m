Return-Path: <linux-kernel-owner+w=401wt.eu-S1760885AbZC0TVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885AbZC0TVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 15:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760405AbZC0TVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 15:21:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48520 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760151AbZC0TVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 15:21:17 -0400
Date: Fri, 27 Mar 2009 15:18:35 -0400
From: Jason Baron <jbaron@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca, Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 2/9] LTTng instrumentation - irq
Message-ID: <20090327191835.GC15313@redhat.com>
References: <20090324155625.420966314@polymtl.ca> <20090324160148.080628193@polymtl.ca> <20090324173354.GC3129@redhat.com> <20090324175049.GC31117@elte.hu> <20090324175750.GE3129@redhat.com> <20090324191252.GA11665@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324191252.GA11665@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 08:12:52PM +0100, Ingo Molnar wrote:
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

yes, this was my thinking too. The handler tracepoints are useful in and
of themselves...and I was planning to do a separate patch, instrumenting what
you are calling the 'raw vector'...

thanks,

-Jason


