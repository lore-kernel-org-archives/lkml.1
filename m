Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab0CIIeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 03:34:15 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:50444 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490Ab0CIIeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 03:34:12 -0500
Date: Tue, 9 Mar 2010 09:34:10 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 1/3] lockdep: Move lock events under lockdep recursion
	protection
Message-ID: <20100309083410.GD5768@kernel.dk>
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com> <1267599302-2886-2-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267599302-2886-2-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03 2010, Frederic Weisbecker wrote:
> There are rcu locked read side areas in the path where we submit
> a trace event. And these rcu_read_(un)lock() trigger lock events,
> which create recursive events.
> 
> One pair in do_perf_sw_event:
> 
> __lock_acquire
>       |
>       |--96.11%-- lock_acquire
>       |          |
>       |          |--27.21%-- do_perf_sw_event
>       |          |          perf_tp_event
>       |          |          |
>       |          |          |--49.62%-- ftrace_profile_lock_release
>       |          |          |          lock_release
>       |          |          |          |
>       |          |          |          |--33.85%-- _raw_spin_unlock
> 
> Another pair in perf_output_begin/end:
> 
> __lock_acquire
>       |--23.40%-- perf_output_begin
>       |          |          __perf_event_overflow
>       |          |          perf_swevent_overflow
>       |          |          perf_swevent_add
>       |          |          perf_swevent_ctx_event
>       |          |          do_perf_sw_event
>       |          |          perf_tp_event
>       |          |          |
>       |          |          |--55.37%-- ftrace_profile_lock_acquire
>       |          |          |          lock_acquire
>       |          |          |          |
>       |          |          |          |--37.31%-- _raw_spin_lock
> 
> The problem is not that much the trace recursion itself, as we have a
> recursion protection already (though it's always wasteful to recurse).
> But the trace events are outside the lockdep recursion protection, then
> each lockdep event triggers a lock trace, which will trigger two
> other lockdep events. Here the recursive lock trace event won't
> be taken because of the trace recursion, so the recursion stops there
> but lockdep will still analyse these new events:
> 
> To sum up, for each lockdep events we have:
> 
> 	lock_*()
> 	     |
>              trace lock_acquire
>                   |
>                   ----- rcu_read_lock()
>                   |          |
>                   |          lock_acquire()
>                   |          |
>                   |          trace_lock_acquire() (stopped)
>                   |          |
> 		  |          lockdep analyze
>                   |
>                   ----- rcu_read_unlock()
>                              |
>                              lock_release
>                              |
>                              trace_lock_release() (stopped)
>                              |
>                              lockdep analyze
> 
> And you can repeat the above two times as we have two rcu read side
> sections when we submit an event.
> 
> This is fixed in this patch by moving the lock trace event under
> the lockdep recursion protection.

I went to try this on 2.6.34-rc1 to see how much it would improve things
here. With 2.6.34-rc1, a

$ time sudo perf lock record ls /dev/shm

essentially hangs the box, it ends up crashing hard (not just live
locked like before). With the patch in place, it does eventually finish:

real    0m21.301s
user    0m0.030s
sys     0m21.040s

The directory is empty.

-- 
Jens Axboe

