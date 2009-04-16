Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbZDPRtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbZDPRtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 13:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755603AbZDPRth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 13:49:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37422 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173AbZDPRtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 13:49:36 -0400
Subject: Re: [PATCH 2/2] tracing/events/lockdep: move tracepoints within
 recursive protection
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <alpine.DEB.2.00.0904161335400.20429@gandalf.stny.rr.com>
References: <20090416161543.199331330@goodmis.org>
	 <20090416161746.831882528@goodmis.org> <1239900469.23397.3128.camel@laptop>
	 <alpine.DEB.2.00.0904161259460.20429@gandalf.stny.rr.com>
	 <1239902407.23397.3197.camel@laptop>
	 <alpine.DEB.2.00.0904161335400.20429@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 19:49:25 +0200
Message-Id: <1239904165.23397.3265.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 13:38 -0400, Steven Rostedt wrote:

> > > Note, that the ring buffer and events are made to be recursive. That is, 
> > > it allows one event to trace within another event.
> > 
> > But surely not in the same context. You could do a 4 level recursion
> > protection like I did in perf-counter, not allowing recursion in:
> > 
> >  nmi, irq, softirq, process - context.
> 
> Why not allow a nested interrupt to trace?
> 
> I don't want to add this logic to the lower levels, where only a few
> users need the protection. The protecting should be at the user level.

wouldn't you want to disable preemption/softirq/irqs in the tracer -- to
avoid such recursion to begin with (preemption isn't even strictly
needed if you put the recursion count in the task struct, as each task
has a new stack anyway).

I think having a recursion detection in place is far more valuable than
being able to recursively trace interrupts and the like, which are
exceedingly rare (on x86, and power and other arch with multiple
interrupt levels that each have their own stack can extend the recursion
levels too).

> > That allows you to trace an irq while you're tracing something in
> > process context, etc.. But not allow recursion on the same level.
> > 
> > >  If the tracepoint is 
> > > triggered by something within the trace point handler, then we are 
> > > screwed. That needs to be fixed.
> > 
> > Exactly the thing you want to detect and warn about, preferably with a
> > nice stack trace.
> 
> Its hard when you want to allow nesting.

Hard never stopped us before, did it ;-)

> > > I have not seen what is triggering back into locking. The ring buffer and 
> > > what I can see by the event code, does not grab any locks besides raw 
> > > ones.
> > 
> > Well, it used to all work, so something snuck in.
> 
> Note, it seems only the lockdep has issues with nesting. Perhaps when I 
> can publish the lockless ring buffer this will all go away?

I doubt it, it shouldn't happen as it stands -- so this patch only hides
the real issue.

