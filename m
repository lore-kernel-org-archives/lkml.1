Return-Path: <linux-kernel-owner+w=401wt.eu-S1762775AbYARXTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762775AbYARXTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 18:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbYARXTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 18:19:37 -0500
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:48873 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751933AbYARXTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 18:19:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FACvDkEdMROHU/2dsb2JhbACBV60q
Date: Fri, 18 Jan 2008 18:19:29 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, Steven Rostedt <srostedt@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
Message-ID: <20080118231928.GA5563@Krystal>
References: <20080116152838.GA970@Krystal> <Pine.LNX.4.58.0801161041010.15998@gandalf.stny.rr.com> <20080116170011.GA3651@Krystal> <Pine.LNX.4.58.0801161428180.14368@gandalf.stny.rr.com> <20080116201713.GA14336@Krystal> <Pine.LNX.4.58.0801171440360.28350@gandalf.stny.rr.com> <20080117203740.GA24397@redhat.com> <Pine.LNX.4.58.0801171555120.28350@gandalf.stny.rr.com> <20080118222637.GA30900@Krystal> <Pine.LNX.4.58.0801181735140.13971@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0801181735140.13971@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:15:57 up 76 days,  4:21,  2 users,  load average: 1.15, 0.66,
	0.76
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Fri, 18 Jan 2008, Mathieu Desnoyers wrote:
> >
> > But I have not seen a lot of situations where that kind of glue-code was
> > needed, so I think it makes sense to keep markers simple to use and
> > efficient for the common case.
> >
> > Then, in this glue-code, we can put trace_mark() and calls to in-kernel
> > tracers.
> 
> I'm almost done with the latency tracer work, and there are only a total
> of 6 hooks that I needed.
> 
>  - schedule context switch
>  - try_to_wake_up
>  - hard_irqs_off (which is already there for lockdep)
>  - hard irqs on (also for lockdep)
>  - lock_contention (already in for the lock contention code)
>  - lock acquire (also in there for contention code)
> 
> With the above, we could have this (if this is what I think you are
> recommending). For example in the context_switch case:
> 
> 	trace_switch_to(prev, next);
> 	switch_to(prev, next, prev);
> 
> and in sched.h I could have:
> 

Almost.. I would add :

static int trace_switch_to_enabled;

> static inline trace_switch_to(struct task_struct *prev,
> 			struct task_struct *next)
> {
    if (likely(!trace_switch_to_enabled))
      return;
> 	trace_mark(kernel_schedudule,
> 		"prev_pid %d next_pid %d prev_state %ld",
> 		prev->pid, next->pid, prev->pid);
> 
> 	trace_context_switch(prev, next);
> }
> 

And some code to activate the trace_switch_to_enabled variable (ideally
keeping a refcount).

By doing this, we would have the minimum impact on the scheduled when
disabled.

But remember that this trace_switch_to_enabled could be enabled for both
markers and your tracer, so you might need to put a branch at the
beginning of trace_context_switch() too.

Mathieu

> and have the trace_context_switch code be something that is turned on with
> the latency tracing utility (config option). That way production code can
> keep it off.
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
