Return-Path: <linux-kernel-owner+w=401wt.eu-S1761140AbZLJQwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140AbZLJQwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 11:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760945AbZLJQwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 11:52:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49469 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758514AbZLJQwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 11:52:50 -0500
Date: Thu, 10 Dec 2009 17:52:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tim Bird <tim.bird@am.sony.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
Message-ID: <20091210165238.GA13775@elte.hu>
References: <4B202778.4030801@am.sony.com>
 <20091210070800.GB16874@elte.hu>
 <20091210120332.GA5042@nowhere>
 <20091210141121.GB1436@elte.hu>
 <1260456803.2146.167.camel@gandalf.stny.rr.com>
 <20091210153845.GA28230@elte.hu>
 <1260462132.2146.198.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260462132.2146.198.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 2009-12-10 at 16:38 +0100, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > The correctly designed way to express latency tracing is via a new 
> > generic event primitive: connecting two events to a maximum value.
> > 
> > That can be done without forcibly tying it and limiting it to a specific 
> > 'latency tracing' variant as the /debug/tracing/ bits of ftrace do it 
> > right now.
> 
> Sure, when we have that, then we can remove the plugin (and then all 
> plugins when there are superior alternatives).

Ok, that's good to hear.

> > Just off the top of my head we want to be able to trace:
> > 
> >  - max irq service latencies for a given IRQ
> >  - max block IO completion latencies for a app
> >  - max TLB flush latencies in the system
> >  - max sys_open() latencies in a task
> >  - max fork()/exit() latencies in a workload
> >  - max scheduling latencies on a given CPU
> >  - max page fault latencies
> >  - max wakeup latencies for a given task
> >  - max memory allocation latencies
> > 
> >  - ... and dozens and dozens of other things where there's a "start"
> >    and a "stop" event and where we want to measure the time between
> >    them.
> 
> Note, we also need a way to "store" the max. The fly recorder method 
> is not good enough.

Yeah. What we want in the larger scheme of things is to have operations 
connected to events. One such operation would be "start measuring max", 
another would be "stop measuring the max".

[ Whether the max is intrinsic to the context structure, or is perhaps 
  some _third_ event (so the max can be recovered by observing that 
  event) is a detail. ]

Note that other operations make sense as well, such as:

 - if event X happens then enable event Y
 - if event X happens then disable event Y

A popular use of that would be to enable the function events on the 
'start' event of a latency measurement, and disable function events on 
the 'stop' event.

Yet another use would be to enable cache miss events when 'entering' a 
specific function event, and disable cache miss counting on 'exiting' 
that function. (this would be an event of the function graph tracer)
 
This would allow the precise cache miss profiling of a given function 
and all its sub-functions - and only of that function.

Note that the existing filter engine functionality connects in a natural 
way here as well: it can already be used to limit events and thus can be 
used to further shape the behavior of tracing, runtime.

Other interesting event operations are possible as well. Key is to 
expose this via the unified interface and to stop adding new 
functionality-limited crap via the ftrace plugin infrastructure - it's 
clearly not suitable for this purpose. We now have found how to do these 
things properly and cleanly.

And the thing is, _you_ implemented unified ftrace events, all i'm 
asking you is to realize the power of them and to stop adding new 
ftrace-plugins [which are crap in comparison] and contcentrate on 
exposing new tracing functionality via unified ftrace events, ok? ;-)

	Ingo
