Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbZGFNbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbZGFNbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 09:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbZGFNbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 09:31:14 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:59039 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971AbZGFNbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 09:31:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhoFADeZUUpMQWU3/2dsb2JhbACBUcsshBIFgTo
Date: Mon, 6 Jul 2009 09:31:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] ftrace: add tracepoint for itimer
Message-ID: <20090706133108.GA7082@Krystal>
References: <4A51C5C2.20802@cn.fujitsu.com> <4A51C6F9.3080100@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4A51C6F9.3080100@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:28:02 up 128 days,  9:54,  3 users,  load average: 0.99, 1.10,
	1.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Xiao Guangrong (xiaoguangrong@cn.fujitsu.com) wrote:
> Those tracepoints are wanted and useful:
> 1: We can detect a itimer's delay
> 2: We can monitor the lifecycle and behaviors of a itimer
> 
> Thus they help in analysing and debuging.
> 
> Great thanks to Thomas for giving me so many valuable advices.
> 
> There have two case: 
> case 1, if we use ITIMER_REAL itimer:
> Example ftrace output:
>  main-1649  [001]  1674.034138: hrtimer_start: timer=ce97d3a4 func=it_real_fn expires=1679993510723 ns softexpires=1679993510723 ns
>  main-1649  [001]  1674.034140: itimer_state: task=main which=0 state:start timer=ce97d3a4 expires=0 it_value=2.0 it_interval=0.500000
>  main-1649  [001]  1676.029184: hrtimer_expire: timer=ce97d3a4 func=it_real_fn now=1679993511197
>  main-1649  [001]  1676.029185: hrtimer_cancel: timer=ce97d3a4 func=it_real_fn
>  main-1649  [001]  1676.029190: itimer_expire: task=main which=0 now=0
>  main-1649  [001]  1676.034744: itimer_state: task=main which=0 state:cancel timer=ce97d3a4 expires=0 it_value=0.0 it_interval=0.0
> 
> ITIMER_REAL itime use hrtimer to calculate time, so we can cooperate with
> hrtimer's tracepoint to get it's delay.
> 
> from this output information, the process set up a ITIMER_REAL
> iteimr(which=0), use a hrtime which address is ce97d3a4, we can get the
> delay is 1679993511197-1679993510723 = 474 ns
> 
> case 2, if we use ITIMER_VIRTUAL/ITIMER_PROF itimer:
> Example ftrace output:
>  main-1600  [000]   524.081367: itimer_state: task=main which=2 state:start timer=(null) expires=2008 it_value=2.0 it_interval=0.500000
>  main-1600  [000]   526.084820: itimer_expire: task=main which=2 now=2008
>  main-1600  [000]   526.088912: itimer_state: task=main which=2 state:cancel timer=(null) expires=0 it_value=0.0 it_interval=0.0
>  
> from this, we can know the itimer delay is 2008-2008=0 jiffies.
> 
> Changelog v1->v2:
> 1: Remove ktime_to_ns() in TP_fast_assign()
> 2: Combine debugobjects and trace as Thomas's suggestion
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  include/trace/events/timer.h |   66 ++++++++++++++++++++++++++++++++++++++++++
>  kernel/itimer.c              |    3 ++
>  kernel/posix-cpu-timers.c    |    3 ++
>  3 files changed, 72 insertions(+), 0 deletions(-)
> 
> diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
> index 8ffb2e2..66d33e1 100644
> --- a/include/trace/events/timer.h
> +++ b/include/trace/events/timer.h
> @@ -4,6 +4,7 @@
>  #include <linux/tracepoint.h>
>  #include <linux/timer.h>
>  #include <linux/hrtimer.h>
> +#include <linux/time.h>
>  
>  #undef TRACE_SYSTEM
>  #define TRACE_SYSTEM timer
> @@ -282,6 +283,71 @@ TRACE_EVENT(hrtimer_cancel,
>  	TP_printk("timer=%p func=%pf", __entry->timer, __entry->function)
>  );
>  
> +TRACE_EVENT(itimer_state,
> +

Hrm, I'd reserve the use of the *_state namespace for something
different if possible.

In LTTng, we have the ability to list a set of data structures at trace
start (we call this state dump). In this case, we could add a list of
all active timers at trace start. This is useful if the trace started
after timer inits.

So having "_state" without much meaning here might eventually be
confusing.

"_action" or "_call" (like IPCs) might be more appropriate ?

Mathieu

> +	TP_PROTO(int which, struct itimerval *value, cputime_t expires),
> +
> +	TP_ARGS(which, value, expires),
> +
> +	TP_STRUCT__entry(
> +		__field(	int,		which		)
> +		__field(	void *,		timer		)
> +		__field(	int,		state		)
> +		__field(	cputime_t,	expires		)
> +		__field(	long,		value_sec	)
> +		__field(	long,		value_usec	)
> +		__field(	long,		interval_sec	)
> +		__field(	long,		interval_usec	)
> +		__string(	comm,		current->comm	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->which		= which;
> +		__entry->timer		= which == ITIMER_REAL ?
> +						&current->signal->real_timer : NULL;
> +		__entry->state		= (value->it_value.tv_sec != 0 ||
> +					   value->it_value.tv_usec != 0) ? 1 : 0;
> +		__entry->expires	= which == ITIMER_REAL ? 0 : expires;
> +		__entry->value_sec	= value->it_value.tv_sec;
> +		__entry->value_usec	= value->it_value.tv_usec;
> +		__entry->interval_sec	= value->it_interval.tv_sec;
> +		__entry->interval_usec	= value->it_interval.tv_usec;
> +		__assign_str(comm, current->comm);
> +	),
> +
> +	TP_printk("task=%s which=%d state:%s timer=%p expires=%lu "
> +		  "it_value=%lu.%lu it_interval=%lu.%lu",
> +		  __get_str(comm), __entry->which,
> +		  __entry->state ? "start" : "cancel", __entry->timer,
> +		  __entry->expires, __entry->value_sec, __entry->value_usec,
> +		  __entry->interval_sec, __entry->interval_usec)
> +);
> +
> +TRACE_EVENT(itimer_expire,
> +
> +	TP_PROTO(int which, struct task_struct *task, struct pid *pid, cputime_t now),
> +
> +	TP_ARGS(which, task, pid, now),
> +
> +	TP_STRUCT__entry(
> +		__field(	int ,		which			)
> +		__field(	cputime_t,	now			)
> +		__array(	char,		comm,	TASK_COMM_LEN	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->which	= which;
> +		__entry->now	= now;
> +		if (pid)
> +			strcpy(__entry->comm, pid_task(pid, PIDTYPE_PID)->comm);
> +		else
> +			strcpy(__entry->comm, task->comm);
> +	),
> +
> +	TP_printk("task=%s which=%d now=%lu", __entry->comm, __entry->which,
> +		  __entry->now)
> +);
> +
>  #endif /*  _TRACE_TIMER_H */
>  
>  /* This part must be outside protection */
> diff --git a/kernel/itimer.c b/kernel/itimer.c
> index 58762f7..ee3a810 100644
> --- a/kernel/itimer.c
> +++ b/kernel/itimer.c
> @@ -12,6 +12,7 @@
>  #include <linux/time.h>
>  #include <linux/posix-timers.h>
>  #include <linux/hrtimer.h>
> +#include <trace/events/timer.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -123,6 +124,7 @@ enum hrtimer_restart it_real_fn(struct hrtimer *timer)
>  	struct signal_struct *sig =
>  		container_of(timer, struct signal_struct, real_timer);
>  
> +	trace_itimer_expire(ITIMER_REAL, NULL, sig->leader_pid, 0);
>  	kill_pid_info(SIGALRM, SEND_SIG_PRIV, sig->leader_pid);
>  
>  	return HRTIMER_NORESTART;
> @@ -220,6 +222,7 @@ again:
>  	default:
>  		return -EINVAL;
>  	}
> +	trace_itimer_state(which, value, nval);
>  	return 0;
>  }
>  
> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index bece7c0..66d0e28 100644
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -8,6 +8,7 @@
>  #include <linux/math64.h>
>  #include <asm/uaccess.h>
>  #include <linux/kernel_stat.h>
> +#include <trace/events/timer.h>
>  
>  /*
>   * Called after updating RLIMIT_CPU to set timer expiration if necessary.
> @@ -1160,6 +1161,7 @@ static void check_process_timers(struct task_struct *tsk,
>  				sig->it_prof_expires = cputime_add(
>  					sig->it_prof_expires, ptime);
>  			}
> +			trace_itimer_expire(ITIMER_PROF, tsk, NULL, ptime);
>  			__group_send_sig_info(SIGPROF, SEND_SIG_PRIV, tsk);
>  		}
>  		if (!cputime_eq(sig->it_prof_expires, cputime_zero) &&
> @@ -1176,6 +1178,7 @@ static void check_process_timers(struct task_struct *tsk,
>  				sig->it_virt_expires = cputime_add(
>  					sig->it_virt_expires, utime);
>  			}
> +			trace_itimer_expire(ITIMER_VIRTUAL, tsk, NULL, utime);
>  			__group_send_sig_info(SIGVTALRM, SEND_SIG_PRIV, tsk);
>  		}
>  		if (!cputime_eq(sig->it_virt_expires, cputime_zero) &&
> -- 
> 1.6.1.2
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
