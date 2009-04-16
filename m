Return-Path: <linux-kernel-owner+w=401wt.eu-S1758618AbZDPS3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbZDPS3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 14:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756737AbZDPS3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 14:29:32 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:62724 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756261AbZDPS3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 14:29:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiAFABcV50lMQW1W/2dsb2JhbACBU9Alg30G
Date: Thu, 16 Apr 2009 14:29:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/2] tracing/events/lockdep: move tracepoints within
	recursive protection
Message-ID: <20090416182928.GB13940@Krystal>
References: <20090416161543.199331330@goodmis.org> <20090416161746.831882528@goodmis.org> <1239900469.23397.3128.camel@laptop> <alpine.DEB.2.00.0904161259460.20429@gandalf.stny.rr.com> <1239902407.23397.3197.camel@laptop> <alpine.DEB.2.00.0904161335400.20429@gandalf.stny.rr.com> <1239904165.23397.3265.camel@laptop> <alpine.DEB.2.00.0904161351380.20429@gandalf.stny.rr.com> <1239905164.23397.3300.camel@laptop> <alpine.DEB.2.00.0904161411320.20429@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904161411320.20429@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:25:13 up 47 days, 14:51,  1 user,  load average: 0.29, 0.48,
	0.46
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Thu, 16 Apr 2009, Peter Zijlstra wrote:
> > 
> > > That is, at thread context, you are at level 0, if an interrupt comes
> > > in, it sets you to level 1, if another interrupt comes in, it sets you to 
> > > level 2, and so on.
> > > 
> > > I guess we could add this into the irq_enter/exit sofirq_enter/exit and 
> > > nmi_enter/exit.
> > > 
> > > Thus we can have each task with a bitmask. When we start to trace, we set 
> > > the bit coresponding to the level the task is at.
> > > 
> > > Ie. in thread context, we set bit 0, if we are interrupted by a 
> > > softirq/irq/nmi, we set the level bit we are at. Hmm, we might be able to 
> > > do this via the preempt count already :-/
> > > 
> > > Just add the softirq/irq/nmi bits together.
> > > 
> > > The if the bit is already set we can dump out a warning.
> > > 
> > > I'll try that out.
> > 
> > static int *perf_swcounter_recursion_context(struct perf_cpu_context *cpuctx)
> > {
> >         if (in_nmi())
> >                 return &cpuctx->recursion[3];
> > 
> >         if (in_irq())
> >                 return &cpuctx->recursion[2];
> > 
> >         if (in_softirq())
> >                 return &cpuctx->recursion[1];
> > 
> >         return &cpuctx->recursion[0];
> > }
> > 
> > Is what I use for perf-counters.
> 
> But does that allow multi nested interrupts?
> 
> I'll try the preempt_count and let you know.
> 
> Thanks,
> 
> -- Steve
> 

In practice, I have used a "tracing nesting level" detection counter in
LTTng which drops events if they are at a nesting level of about 5 or
more if my memory serves me well. This should be enough to detect
recursive tracer calls before filling the stack while handling some of
the worse nesting we can think of (thread + softirq + irq + nmi).

And it's _really_ easy to implement, arch-independant, and has no
special corner-case.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
