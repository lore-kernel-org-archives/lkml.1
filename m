Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab0CIHTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 02:19:05 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:65249 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab0CIHTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 02:19:03 -0500
Message-ID: <4B95F662.4090401@dcl.info.waseda.ac.jp>
Date: Tue, 09 Mar 2010 16:18:58 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/3] lockdep: Move lock events under lockdep recursion
 protection
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com> <1267599302-2886-2-git-send-regression-fweisbec@gmail.com>
In-Reply-To: <1267599302-2886-2-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/10 15:55, Frederic Weisbecker wrote:
> There are rcu locked read side areas in the path where we submit
> a trace event. And these rcu_read_(un)lock() trigger lock events,
> which create recursive events.
>
> One pair in do_perf_sw_event:
>
> __lock_acquire
>        |
>        |--96.11%-- lock_acquire
>        |          |
>        |          |--27.21%-- do_perf_sw_event
>        |          |          perf_tp_event
>        |          |          |
>        |          |          |--49.62%-- ftrace_profile_lock_release
>        |          |          |          lock_release
>        |          |          |          |
>        |          |          |          |--33.85%-- _raw_spin_unlock
>
> Another pair in perf_output_begin/end:
>
> __lock_acquire
>        |--23.40%-- perf_output_begin
>        |          |          __perf_event_overflow
>        |          |          perf_swevent_overflow
>        |          |          perf_swevent_add
>        |          |          perf_swevent_ctx_event
>        |          |          do_perf_sw_event
>        |          |          perf_tp_event
>        |          |          |
>        |          |          |--55.37%-- ftrace_profile_lock_acquire
>        |          |          |          lock_acquire
>        |          |          |          |
>        |          |          |          |--37.31%-- _raw_spin_lock
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
>               trace lock_acquire
>                    |
>                    ----- rcu_read_lock()
>                    |          |
>                    |          lock_acquire()
>                    |          |
>                    |          trace_lock_acquire() (stopped)
>                    |          |
> 		  |          lockdep analyze
>                    |
>                    ----- rcu_read_unlock()
>                               |
>                               lock_release
>                               |
>                               trace_lock_release() (stopped)
>                               |
>                               lockdep analyze
>
> And you can repeat the above two times as we have two rcu read side
> sections when we submit an event.
>
> This is fixed in this patch by moving the lock trace event under
> the lockdep recursion protection.

Thanks a lot, Frederic!

I tested perf lock with your patch, result is like this,

Typical scores:

before:
% sudo ./perf lock record ./perf bench sched messaging
# Running sched/messaging benchmark...
# 20 sender and receiver processes per group
# 10 groups == 400 processes run

      Total time: 3.265 [sec]
[ perf record: Woken up 0 times to write data ]
[ perf record: Captured and wrote 143.952 MB perf.data (~6289344 samples) ]

after:
% sudo ./perf lock record ./perf bench sched messaging
# Running sched/messaging benchmark...
# 20 sender and receiver processes per group
# 10 groups == 400 processes run

      Total time: 1.943 [sec]                       <--- about x1.5 faster!
[ perf record: Woken up 0 times to write data ]
[ perf record: Captured and wrote 98.161 MB perf.data (~4288734 samples) 
]   <--- size of perf.data is also reduced

