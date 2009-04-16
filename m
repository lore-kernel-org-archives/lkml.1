Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbZDPSNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbZDPSNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 14:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbZDPSNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 14:13:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53656 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264AbZDPSNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 14:13:08 -0400
Date: Thu, 16 Apr 2009 14:12:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 2/2] tracing/events/lockdep: move tracepoints within
 recursive protection
In-Reply-To: <1239905164.23397.3300.camel@laptop>
Message-ID: <alpine.DEB.2.00.0904161411320.20429@gandalf.stny.rr.com>
References: <20090416161543.199331330@goodmis.org>  <20090416161746.831882528@goodmis.org> <1239900469.23397.3128.camel@laptop>  <alpine.DEB.2.00.0904161259460.20429@gandalf.stny.rr.com>  <1239902407.23397.3197.camel@laptop>  <alpine.DEB.2.00.0904161335400.20429@gandalf.stny.rr.com>
  <1239904165.23397.3265.camel@laptop>  <alpine.DEB.2.00.0904161351380.20429@gandalf.stny.rr.com> <1239905164.23397.3300.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 16 Apr 2009, Peter Zijlstra wrote:
> 
> > That is, at thread context, you are at level 0, if an interrupt comes
> > in, it sets you to level 1, if another interrupt comes in, it sets you to 
> > level 2, and so on.
> > 
> > I guess we could add this into the irq_enter/exit sofirq_enter/exit and 
> > nmi_enter/exit.
> > 
> > Thus we can have each task with a bitmask. When we start to trace, we set 
> > the bit coresponding to the level the task is at.
> > 
> > Ie. in thread context, we set bit 0, if we are interrupted by a 
> > softirq/irq/nmi, we set the level bit we are at. Hmm, we might be able to 
> > do this via the preempt count already :-/
> > 
> > Just add the softirq/irq/nmi bits together.
> > 
> > The if the bit is already set we can dump out a warning.
> > 
> > I'll try that out.
> 
> static int *perf_swcounter_recursion_context(struct perf_cpu_context *cpuctx)
> {
>         if (in_nmi())
>                 return &cpuctx->recursion[3];
> 
>         if (in_irq())
>                 return &cpuctx->recursion[2];
> 
>         if (in_softirq())
>                 return &cpuctx->recursion[1];
> 
>         return &cpuctx->recursion[0];
> }
> 
> Is what I use for perf-counters.

But does that allow multi nested interrupts?

I'll try the preempt_count and let you know.

Thanks,

-- Steve

