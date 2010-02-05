Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab0BEJp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 04:45:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38089 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab0BEJp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 04:45:28 -0500
Subject: Re: [PATCH 10/11] tracing/perf: Fix lock events recursions in the
 fast path
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <4B6B84A1.60805@cn.fujitsu.com>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
	 <1265188475-23509-11-git-send-regression-fweisbec@gmail.com>
	 <20100204154700.GE6676@linux.vnet.ibm.com>  <4B6B84A1.60805@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 10:45:02 +0100
Message-ID: <1265363102.22001.286.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-05 at 10:38 +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> > On Wed, Feb 03, 2010 at 10:14:34AM +0100, Frederic Weisbecker wrote:
> >> There are rcu locked read side areas in the path where we submit
> >> a trace events. And these rcu_read_(un)lock() trigger lock events,
> >> which create recursive events.
> >>
> >> One pair in do_perf_sw_event:
> >>
> >> __lock_acquire
> >>       |
> >>       |--96.11%-- lock_acquire
> >>       |          |
> >>       |          |--27.21%-- do_perf_sw_event
> >>       |          |          perf_tp_event
> >>       |          |          |
> >>       |          |          |--49.62%-- ftrace_profile_lock_release
> >>       |          |          |          lock_release
> >>       |          |          |          |
> >>       |          |          |          |--33.85%-- _raw_spin_unlock
> >>
> >> Another pair in perf_output_begin/end:
> >>
> >> __lock_acquire
> >>       |--23.40%-- perf_output_begin
> >>       |          |          __perf_event_overflow
> >>       |          |          perf_swevent_overflow
> >>       |          |          perf_swevent_add
> >>       |          |          perf_swevent_ctx_event
> >>       |          |          do_perf_sw_event
> >>       |          |          perf_tp_event
> >>       |          |          |
> >>       |          |          |--55.37%-- ftrace_profile_lock_acquire
> >>       |          |          |          lock_acquire
> >>       |          |          |          |
> >>       |          |          |          |--37.31%-- _raw_spin_lock
> >>
> >> The problem is not that much the trace recursion itself, as we have a
> >> recursion protection already (though it's always wasteful to recurse).
> >> But the trace events are outside the lockdep recursion protection, then
> >> each lockdep event triggers a lock trace, which will trigger two
> >> other lockdep events. Here the recursive lock trace event won't
> >> be taken because of the trace recursion, so the recursion stops there
> >> but lockdep will still analyse these new events:
> >>
> >> To sum up, for each lockdep events we have:
> >>
> >> 	lock_*()
> >> 	     |
> >>              trace lock_acquire
> >>                   |
> >>                   ----- rcu_read_lock()
> >>                   |          |
> >>                   |          lock_acquire()
> >>                   |          |
> >>                   |          trace_lock_acquire() (stopped)
> >>                   |          |
> >> 		  |          lockdep analyze
> >>                   |
> >>                   ----- rcu_read_unlock()
> >>                              |
> >>                              lock_release
> >>                              |
> >>                              trace_lock_release() (stopped)
> >>                              |
> >>                              lockdep analyze
> >>
> >> And you can repeat the above two times as we have two rcu read side
> >> sections when we submit an event.
> >>
> >> This is fixed in this pacth by using the non-lockdep versions of
> >> rcu_read_(un)lock.
> > 
> > Hmmm...  Perhaps I should rename __rcu_read_lock() to something more
> > meaningful if it is to be used outside of the RCU files.  In the
> > meantime:
> > 
> > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> 
> Perhaps we can use the existed rcu_read_lock_sched_notrace().
> 
> not relate to this patchset, but RCU & lockdep:
> 
> We need to remove lockdep from rcu_read_lock_*().

I'm not at all convinced we need to do any such thing, remember its
debugging stuff, performance, while nice, doesn't really count.


> 1) rcu_read_lock() is deadlock-immunity,
>    we get very little benefit from lockdep.

Except it detects things like failing to unlock, or going into userspace
while holding an rcu_read_lock()

Also, Paul has been spending lots of effort on getting rcu_dereference()
annotated.

> rcu_read_lock()
>    lock_acquire(read=2,check=1)
> 
>  * Values for check:
>  *
>  *   0: disabled
>  *   1: simple checks (freeing, held-at-exit-time, etc.)
>  *   2: full validation
>  */
> 
> We can check it by other methods.
> 
> 2) popular distributions and some companies enable lockdep for their kernel.
>    rcu_read_lock_*() are the most frequent lock in kernel.
>    lock_acquire() is not fast enough, it is a big function for RCU.

Its debug stuff, get over it, we're not going to limit its coverage
because people do silly things.

