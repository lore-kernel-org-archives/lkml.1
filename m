Return-Path: <linux-kernel-owner+w=401wt.eu-S1758471AbZDPR7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471AbZDPR7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 13:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757506AbZDPR7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 13:59:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49589 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217AbZDPR7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 13:59:16 -0400
Date: Thu, 16 Apr 2009 13:58:42 -0400 (EDT)
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
In-Reply-To: <1239904165.23397.3265.camel@laptop>
Message-ID: <alpine.DEB.2.00.0904161351380.20429@gandalf.stny.rr.com>
References: <20090416161543.199331330@goodmis.org>  <20090416161746.831882528@goodmis.org> <1239900469.23397.3128.camel@laptop>  <alpine.DEB.2.00.0904161259460.20429@gandalf.stny.rr.com>  <1239902407.23397.3197.camel@laptop>  <alpine.DEB.2.00.0904161335400.20429@gandalf.stny.rr.com>
 <1239904165.23397.3265.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



[ added Maitheu, since he likes things like this ]

On Thu, 16 Apr 2009, Peter Zijlstra wrote:

> On Thu, 2009-04-16 at 13:38 -0400, Steven Rostedt wrote:
> 
> > > > Note, that the ring buffer and events are made to be recursive. That is, 
> > > > it allows one event to trace within another event.
> > > 
> > > But surely not in the same context. You could do a 4 level recursion
> > > protection like I did in perf-counter, not allowing recursion in:
> > > 
> > >  nmi, irq, softirq, process - context.
> > 
> > Why not allow a nested interrupt to trace?
> > 
> > I don't want to add this logic to the lower levels, where only a few
> > users need the protection. The protecting should be at the user level.
> 
> wouldn't you want to disable preemption/softirq/irqs in the tracer -- to
> avoid such recursion to begin with (preemption isn't even strictly
> needed if you put the recursion count in the task struct, as each task
> has a new stack anyway).

No, we only disable preemption, nothing more. Interrupts and softirqs are 
free to happen. Also, we allow tracing of NMIs.

> 
> I think having a recursion detection in place is far more valuable than
> being able to recursively trace interrupts and the like, which are
> exceedingly rare (on x86, and power and other arch with multiple
> interrupt levels that each have their own stack can extend the recursion
> levels too).

Is there any arch generic way to tell what level you are at?

That is, at thread context, you are at level 0, if an interrupt comes
in, it sets you to level 1, if another interrupt comes in, it sets you to 
level 2, and so on.

I guess we could add this into the irq_enter/exit sofirq_enter/exit and 
nmi_enter/exit.

Thus we can have each task with a bitmask. When we start to trace, we set 
the bit coresponding to the level the task is at.

Ie. in thread context, we set bit 0, if we are interrupted by a 
softirq/irq/nmi, we set the level bit we are at. Hmm, we might be able to 
do this via the preempt count already :-/

Just add the softirq/irq/nmi bits together.

The if the bit is already set we can dump out a warning.

I'll try that out.


> 
> > > That allows you to trace an irq while you're tracing something in
> > > process context, etc.. But not allow recursion on the same level.
> > > 
> > > >  If the tracepoint is 
> > > > triggered by something within the trace point handler, then we are 
> > > > screwed. That needs to be fixed.
> > > 
> > > Exactly the thing you want to detect and warn about, preferably with a
> > > nice stack trace.
> > 
> > Its hard when you want to allow nesting.
> 
> Hard never stopped us before, did it ;-)

And it may not be that hard if we do the above.

-- Steve

> 
> > > > I have not seen what is triggering back into locking. The ring buffer and 
> > > > what I can see by the event code, does not grab any locks besides raw 
> > > > ones.
> > > 
> > > Well, it used to all work, so something snuck in.
> > 
> > Note, it seems only the lockdep has issues with nesting. Perhaps when I 
> > can publish the lockless ring buffer this will all go away?
> 
> I doubt it, it shouldn't happen as it stands -- so this patch only hides
> the real issue.
> 
> 
