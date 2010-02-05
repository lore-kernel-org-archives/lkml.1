Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab0BEKuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 05:50:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48223 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab0BEKuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 05:50:03 -0500
Date: Fri, 5 Feb 2010 11:49:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, paulmck@linux.vnet.ibm.com,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 10/11] tracing/perf: Fix lock events recursions in the
 fast path
Message-ID: <20100205104937.GB29515@elte.hu>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
 <1265188475-23509-11-git-send-regression-fweisbec@gmail.com>
 <20100204154700.GE6676@linux.vnet.ibm.com>
 <4B6B84A1.60805@cn.fujitsu.com>
 <1265363102.22001.286.camel@laptop>
 <1265363441.22001.300.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265363441.22001.300.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2010-02-05 at 10:45 +0100, Peter Zijlstra wrote:
> > On Fri, 2010-02-05 at 10:38 +0800, Lai Jiangshan wrote:
> > > Paul E. McKenney wrote:
> > > > On Wed, Feb 03, 2010 at 10:14:34AM +0100, Frederic Weisbecker wrote:
> > > >> There are rcu locked read side areas in the path where we submit
> > > >> a trace events. And these rcu_read_(un)lock() trigger lock events,
> > > >> which create recursive events.
> > > >>
> > > >> One pair in do_perf_sw_event:
> > > >>
> > > >> __lock_acquire
> > > >>       |
> > > >>       |--96.11%-- lock_acquire
> > > >>       |          |
> > > >>       |          |--27.21%-- do_perf_sw_event
> > > >>       |          |          perf_tp_event
> > > >>       |          |          |
> > > >>       |          |          |--49.62%-- ftrace_profile_lock_release
> > > >>       |          |          |          lock_release
> > > >>       |          |          |          |
> > > >>       |          |          |          |--33.85%-- _raw_spin_unlock
> > > >>
> > > >> Another pair in perf_output_begin/end:
> > > >>
> > > >> __lock_acquire
> > > >>       |--23.40%-- perf_output_begin
> > > >>       |          |          __perf_event_overflow
> > > >>       |          |          perf_swevent_overflow
> > > >>       |          |          perf_swevent_add
> > > >>       |          |          perf_swevent_ctx_event
> > > >>       |          |          do_perf_sw_event
> > > >>       |          |          perf_tp_event
> > > >>       |          |          |
> > > >>       |          |          |--55.37%-- ftrace_profile_lock_acquire
> > > >>       |          |          |          lock_acquire
> > > >>       |          |          |          |
> > > >>       |          |          |          |--37.31%-- _raw_spin_lock
> > > >>
> > > >> The problem is not that much the trace recursion itself, as we have a
> > > >> recursion protection already (though it's always wasteful to recurse).
> > > >> But the trace events are outside the lockdep recursion protection, then
> > > >> each lockdep event triggers a lock trace, which will trigger two
> > > >> other lockdep events. Here the recursive lock trace event won't
> > > >> be taken because of the trace recursion, so the recursion stops there
> > > >> but lockdep will still analyse these new events:
> > > >>
> > > >> To sum up, for each lockdep events we have:
> > > >>
> > > >> 	lock_*()
> > > >> 	     |
> > > >>              trace lock_acquire
> > > >>                   |
> > > >>                   ----- rcu_read_lock()
> > > >>                   |          |
> > > >>                   |          lock_acquire()
> > > >>                   |          |
> > > >>                   |          trace_lock_acquire() (stopped)
> > > >>                   |          |
> > > >> 		  |          lockdep analyze
> > > >>                   |
> > > >>                   ----- rcu_read_unlock()
> > > >>                              |
> > > >>                              lock_release
> > > >>                              |
> > > >>                              trace_lock_release() (stopped)
> > > >>                              |
> > > >>                              lockdep analyze
> > > >>
> > > >> And you can repeat the above two times as we have two rcu read side
> > > >> sections when we submit an event.
> > > >>
> > > >> This is fixed in this pacth by using the non-lockdep versions of
> > > >> rcu_read_(un)lock.
> > > > 
> > > > Hmmm...  Perhaps I should rename __rcu_read_lock() to something more
> > > > meaningful if it is to be used outside of the RCU files.  In the
> > > > meantime:
> > > > 
> > > > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > 
> > > 
> > > Perhaps we can use the existed rcu_read_lock_sched_notrace().
> > > 
> > > not relate to this patchset, but RCU & lockdep:
> > > 
> > > We need to remove lockdep from rcu_read_lock_*().
> > 
> > I'm not at all convinced we need to do any such thing, remember its
> > debugging stuff, performance, while nice, doesn't really count.
> 
> That said, I'm not at all happy about removing lockdep annotations to make 
> the tracer faster, that's really counter productive.

Are there no dynamic techniques that could be used here?

Lockdep obviously wants maximum instrumentation coverage - performance be 
damned.

Lock profiling/tracing/visualization wants the minimum subset of events it is 
interested in - everything else is unnecessary overhead.

	Ingo
