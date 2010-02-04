Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632Ab0BDPrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 10:47:09 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36695 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932472Ab0BDPrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 10:47:06 -0500
Date: Thu, 4 Feb 2010 07:47:00 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 10/11] tracing/perf: Fix lock events recursions in the
	fast path
Message-ID: <20100204154700.GE6676@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com> <1265188475-23509-11-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265188475-23509-11-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 10:14:34AM +0100, Frederic Weisbecker wrote:
> There are rcu locked read side areas in the path where we submit
> a trace events. And these rcu_read_(un)lock() trigger lock events,
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
> This is fixed in this pacth by using the non-lockdep versions of
> rcu_read_(un)lock.

Hmmm...  Perhaps I should rename __rcu_read_lock() to something more
meaningful if it is to be used outside of the RCU files.  In the
meantime:

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> ---
>  kernel/perf_event.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 280ae44..98fd360 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -2986,7 +2986,7 @@ int perf_output_begin(struct perf_output_handle *handle,
>  		u64			 lost;
>  	} lost_event;
> 
> -	rcu_read_lock();
> +	__rcu_read_lock();
>  	/*
>  	 * For inherited events we send all the output towards the parent.
>  	 */
> @@ -3051,7 +3051,7 @@ fail:
>  	atomic_inc(&data->lost);
>  	perf_output_unlock(handle);
>  out:
> -	rcu_read_unlock();
> +	__rcu_read_unlock();
> 
>  	return -ENOSPC;
>  }
> @@ -3072,7 +3072,7 @@ void perf_output_end(struct perf_output_handle *handle)
>  	}
> 
>  	perf_output_unlock(handle);
> -	rcu_read_unlock();
> +	__rcu_read_unlock();
>  }
> 
>  static u32 perf_event_pid(struct perf_event *event, struct task_struct *p)
> @@ -4116,7 +4116,7 @@ static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
>  	struct perf_event_context *ctx;
> 
>  	cpuctx = &__get_cpu_var(perf_cpu_context);
> -	rcu_read_lock();
> +	__rcu_read_lock();
>  	perf_swevent_ctx_event(&cpuctx->ctx, type, event_id,
>  				 nr, nmi, data, regs);
>  	/*
> @@ -4126,7 +4126,7 @@ static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
>  	ctx = rcu_dereference(current->perf_event_ctxp);
>  	if (ctx)
>  		perf_swevent_ctx_event(ctx, type, event_id, nr, nmi, data, regs);
> -	rcu_read_unlock();
> +	__rcu_read_unlock();
>  }
> 
>  void __perf_sw_event(u32 event_id, u64 nr, int nmi,
> -- 
> 1.6.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
