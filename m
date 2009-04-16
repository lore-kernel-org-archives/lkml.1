Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbZDPSGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbZDPSGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 14:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbZDPSGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 14:06:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46100 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbZDPSGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 14:06:22 -0400
Subject: Re: [PATCH 2/2] tracing/events/lockdep: move tracepoints within
 recursive protection
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
In-Reply-To: <alpine.DEB.2.00.0904161351380.20429@gandalf.stny.rr.com>
References: <20090416161543.199331330@goodmis.org>
	 <20090416161746.831882528@goodmis.org> <1239900469.23397.3128.camel@laptop>
	 <alpine.DEB.2.00.0904161259460.20429@gandalf.stny.rr.com>
	 <1239902407.23397.3197.camel@laptop>
	 <alpine.DEB.2.00.0904161335400.20429@gandalf.stny.rr.com>
	 <1239904165.23397.3265.camel@laptop>
	 <alpine.DEB.2.00.0904161351380.20429@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 20:06:04 +0200
Message-Id: <1239905164.23397.3300.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 13:58 -0400, Steven Rostedt wrote:
> 
> [ added Maitheu, since he likes things like this ]
> 
> On Thu, 16 Apr 2009, Peter Zijlstra wrote:
> 
> > On Thu, 2009-04-16 at 13:38 -0400, Steven Rostedt wrote:
> > 
> > > > > Note, that the ring buffer and events are made to be recursive. That is, 
> > > > > it allows one event to trace within another event.
> > > > 
> > > > But surely not in the same context. You could do a 4 level recursion
> > > > protection like I did in perf-counter, not allowing recursion in:
> > > > 
> > > >  nmi, irq, softirq, process - context.
> > > 
> > > Why not allow a nested interrupt to trace?
> > > 
> > > I don't want to add this logic to the lower levels, where only a few
> > > users need the protection. The protecting should be at the user level.
> > 
> > wouldn't you want to disable preemption/softirq/irqs in the tracer -- to
> > avoid such recursion to begin with (preemption isn't even strictly
> > needed if you put the recursion count in the task struct, as each task
> > has a new stack anyway).
> 
> No, we only disable preemption, nothing more. Interrupts and softirqs are 
> free to happen. Also, we allow tracing of NMIs.

Right.

> > I think having a recursion detection in place is far more valuable than
> > being able to recursively trace interrupts and the like, which are
> > exceedingly rare (on x86, and power and other arch with multiple
> > interrupt levels that each have their own stack can extend the recursion
> > levels too).
> 
> Is there any arch generic way to tell what level you are at?

No, on x86 there are a few broken ass pieces of hardware/drivers that
require interrupts enabled in the interrupt handler, and can cause
interrupt recursion -- these should be rare and IMHO can be ignored, esp
for a FTRACE_DEBUG option that detects recursion -- that is, simply
disable interrupts when entering the tracer in irq context.

IRQ level nesting like on power would need some arch support.

> That is, at thread context, you are at level 0, if an interrupt comes
> in, it sets you to level 1, if another interrupt comes in, it sets you to 
> level 2, and so on.
> 
> I guess we could add this into the irq_enter/exit sofirq_enter/exit and 
> nmi_enter/exit.
> 
> Thus we can have each task with a bitmask. When we start to trace, we set 
> the bit coresponding to the level the task is at.
> 
> Ie. in thread context, we set bit 0, if we are interrupted by a 
> softirq/irq/nmi, we set the level bit we are at. Hmm, we might be able to 
> do this via the preempt count already :-/
> 
> Just add the softirq/irq/nmi bits together.
> 
> The if the bit is already set we can dump out a warning.
> 
> I'll try that out.

static int *perf_swcounter_recursion_context(struct perf_cpu_context *cpuctx)
{
        if (in_nmi())
                return &cpuctx->recursion[3];

        if (in_irq())
                return &cpuctx->recursion[2];

        if (in_softirq())
                return &cpuctx->recursion[1];

        return &cpuctx->recursion[0];
}

Is what I use for perf-counters.

