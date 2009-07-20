Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbZGTUis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbZGTUis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZGTUip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:38:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:52109 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbZGTUip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:38:45 -0400
Subject: Re: [PATCH] sched: Provide iowait counters
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
In-Reply-To: <alpine.DEB.2.00.0907201622140.26208@gandalf.stny.rr.com>
References: <4A64B813.1080506@linux.intel.com>
	 <1248117369.23509.33.camel@laptop>
	 <alpine.DEB.2.00.0907201540550.26208@gandalf.stny.rr.com>
	 <1248120676.23509.41.camel@laptop>
	 <alpine.DEB.2.00.0907201622140.26208@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 22:38:36 +0200
Message-Id: <1248122316.23509.48.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 16:26 -0400, Steven Rostedt wrote:
> > +#define _TRACE_PROFILE(call, proto, args, assign)                    \
> >  static void ftrace_profile_##call(proto)                             \
> >  {                                                                    \
> > -     extern void perf_tpcounter_event(int);                          \
> > -     perf_tpcounter_event(event_##call.id);                          \
> > +     extern void perf_tpcounter_event(int, u64, u64);                \
> > +     u64 addr = 0, count = 1;                                        \
> > +     { assign; }                                                     \
> > +     perf_tpcounter_event(event_##call.id, addr, count);             \
> 
> The problem here is that the assign also will do the :
> 
>        TP_fast_assign(
>                __entry->pid    = p->pid;
>                __entry->time   = time;
> 
> part, thus you will probably get errors in processing the __entry part.

Oh, right, no macros wrapping that..

> What about doing instead:
> 
>  TRACE_EVENT(sched_iowait,
>  
>         TP_PROTO(struct task_struct *p, u64 time),
>  
>         TP_ARGS(p, time),
>  
>         TP_STRUCT__entry(
>                 __field(pid_t, pid )
>                 __field(u64,   time)
>         ),
>  
>         TP_fast_assign(
>                 __entry->pid    = p->pid;
>                 __entry->time   = time;
>  
>         ) __perf_count(time),
> 
>         TP_printk("task %d waited for IO for %Lu ns",
>                 __entry->pid, __entry->time)
>  );
>  
> Then we could simply do:
> 
> #undef __perf_count
> #define __perf_count(a)
> 
> [ do all the ftrace event work ]
> 
> #undef TP_fast_assign
> #define TP_fast_assign(a...)
> 
> #undef __perf_count
> #define __perf_count(c) count = (c);

Hmm, should we maybe do something like:

	TP_fast_assign(
		...
	)
	TP_perf_assign(
		addr = 0;
		count = time;
	),

So we can extend it over time?

But otherwise, yes, looks nice. Lets make it happen ;-)

