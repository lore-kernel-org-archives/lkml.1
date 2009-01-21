Return-Path: <linux-kernel-owner+w=401wt.eu-S1761472AbZAUNSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761472AbZAUNSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 08:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbZAUNSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 08:18:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:57952 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbZAUNSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 08:18:39 -0500
Subject: Re: [PATCH] posixtimers: clock_gettime(CLOCK_*_CPUTIME_ID)	goes
 backward
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4976B897.9060607@jp.fujitsu.com>
References: <49547320.9010302@jp.fujitsu.com> <20081226084320.GC755@elte.hu>
	 <1230282171.9487.278.camel@twins> <20081226090758.GB27747@elte.hu>
	 <4961AFE3.3080102@jp.fujitsu.com>  <4976B897.9060607@jp.fujitsu.com>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 14:18:26 +0100
Message-Id: <1232543906.4847.268.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-21 at 14:54 +0900, Hidetoshi Seto wrote:
> (resend, rebased on today's linux-next 20090121)
> 
> posix-cpu-timers, clock_gettime(CLOCK_THREAD_CPUTIME_ID) and
> clock_gettime(CLOCK_PROCESS_CPUTIME_ID) occasionally go backward.
> 
> From user land (@HZ=250), it looks like:
> 	prev call       current call    diff
>         (0.191195713) > (0.191200456) : 4743
>         (0.191200456) > (0.191205198) : 4742
>         (0.191205198) > (0.187213693) : -3991505
>         (0.187213693) > (0.191218688) : 4004995
>         (0.191218688) > (0.191223436) : 4748
> 
> The reasons are:
> 
>  - Timer tick (and task_tick) can interrups between getting
>    sum_exec_runtime and task_delta_exec(p).  Since task's runtime
>    is updated in the tick, it makes the value of cpu->sched about
>    a tick less than what it should be.
>    So, interrupts should be disabled while sampling runtime and
>    delta.
> 
>  - Queuing task also updates runtime of task running on the rq
>    which a task is going to be enqueued/dequeued.
>    So, runqueue should be locked while sampling runtime and delta.

Correct.

> For thread time (CLOCK_THREAD_CPUTIME_ID), it is easy to solve
> by making a function do all in a block locked by task_rq_lock().
> 
>  # clock_gettime(CLOCK_THREAD_CPUTIME_ID)
>    before:
> 	cpu->sched = p->se.sum_exec_runtime + task_delta_exec(p);
>    after:
> 	cpu->sched = task_total_exec(p);

OK.

> For process time (CLOCK_PROCESS_CPUTIME_ID), proposed fix here
> is moving thread_group_cputime() from include/linux/sched.h to
> kernel/sched.c, and let it use rq-related operations.
> 
>  # clock_gettime(CLOCK_PROCESS_CPUTIME_ID)
>    before:
> 	thread_group_cputime(p,&cputime); /* returns total */
> 	cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
>    after:
> 	thread_group_cputime(p,&cputime); /* total + local delta */
> 	cpu->sched = cputime.sum_exec_runtime;
> 
> [Note]: According to the current code, process timer returns
> "((total runtime of thread group) + (delta of current thread))."
> The former total is total of "banked runtime" in signal structure,
> therefore technically speaking the latter delta should be sum of
> delta of all running thread in the group.  However requesting delta
> for all cpu is quite heavy and nonsense, so I took a realistic
> approach - keep it as is, as return banked total plus local delta.
> In othe words, people should be careful that accuracy of process
> timer is not so good (while clock_getres() returns a resolution of
> 1ns), it can stale about tick*(max(NR_CPUS, num_thread)-1).

IMO process wide clocks and timers should be discouraged anyway. The
proposed restriction in resolution looks perfectly fine (esp as its what
it already was).

However I cannot quite see how its different from before.

We used to do:

  thread_group_cputime(p, &cputime);
    *cputime = *totals
  cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p)

Which is equal to totals.sum_exec_runtime + task_delta_exec(p).

The new code does exactly that, but in a more correct way.

> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
>  include/linux/kernel_stat.h |    2 +-
>  include/linux/sched.h       |   11 +----------
>  kernel/posix-cpu-timers.c   |    4 ++--
>  kernel/sched.c              |   29 +++++++++++++++++++++++++++--
>  4 files changed, 31 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
> index 570d204..50fabb3 100644
> --- a/include/linux/kernel_stat.h
> +++ b/include/linux/kernel_stat.h
> @@ -78,7 +78,7 @@ static inline unsigned int kstat_irqs(unsigned int irq)
>  	return sum;
>  }
>  
> -extern unsigned long long task_delta_exec(struct task_struct *);
> +extern unsigned long long task_total_exec(struct task_struct *);
>  extern void account_user_time(struct task_struct *, cputime_t, cputime_t);
>  extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
>  extern void account_steal_time(cputime_t);
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 8cbd02c..a689b69 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2209,16 +2209,7 @@ static inline int spin_needbreak(spinlock_t *lock)
>   * Thread group CPU time accounting.
>   */
>  
> -static inline
> -void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
> -{
> -	struct task_cputime *totals = &tsk->signal->cputime.totals;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&totals->lock, flags);
> -	*times = *totals;
> -	spin_unlock_irqrestore(&totals->lock, flags);
> -}
> +extern void thread_group_cputime(struct task_struct *, struct task_cputime *);
>  
>  static inline void thread_group_cputime_init(struct signal_struct *sig)
>  {
> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index fa07da9..56c91b9 100644
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -224,7 +224,7 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
>  		cpu->cpu = virt_ticks(p);
>  		break;
>  	case CPUCLOCK_SCHED:
> -		cpu->sched = p->se.sum_exec_runtime + task_delta_exec(p);
> +		cpu->sched = task_total_exec(p);
>  		break;
>  	}
>  	return 0;
> @@ -251,7 +251,7 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
>  		cpu->cpu = cputime.utime;
>  		break;
>  	case CPUCLOCK_SCHED:
> -		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
> +		cpu->sched = cputime.sum_exec_runtime;
>  		break;
>  	}
>  	return 0;
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 7aba647..bb3e806 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4220,10 +4220,10 @@ DEFINE_PER_CPU(struct kernel_stat, kstat);
>  EXPORT_PER_CPU_SYMBOL(kstat);
>  
>  /*
> - * Return any ns on the sched_clock that have not yet been banked in
> + * Return total of runtime which already banked and which not yet
>   * @p in case that task is currently running.
>   */
> -unsigned long long task_delta_exec(struct task_struct *p)
> +unsigned long long task_total_exec(struct task_struct *p)
>  {
>  	unsigned long flags;
>  	struct rq *rq;
> @@ -4239,12 +4239,37 @@ unsigned long long task_delta_exec(struct task_struct *p)
>  		if ((s64)delta_exec > 0)
>  			ns = delta_exec;
>  	}
> +	ns += p->se.sum_exec_runtime;
>  
>  	task_rq_unlock(rq, &flags);
>  
>  	return ns;
>  }
>  
> +void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
> +{
> +	struct task_cputime *totals = &tsk->signal->cputime.totals;
> +	unsigned long flags;
> +	struct rq *rq;
> +	u64 delta_exec = 0;
> +
> +	rq = task_rq_lock(tsk, &flags);
> +
> +	spin_lock(&totals->lock);
> +	*times = *totals;
> +	spin_unlock(&totals->lock);
> +
> +	if (task_current(rq, tsk)) {
> +		update_rq_clock(rq);
> +		delta_exec = rq->clock - tsk->se.exec_start;
> +		if ((s64)delta_exec < 0)
> +			delta_exec = 0;
> +	}
> +	times->sum_exec_runtime += delta_exec;
> +
> +	task_rq_unlock(rq, &flags);
> +}
> +
>  /*
>   * Account user cpu time to a process.
>   * @p: the process that the cpu time gets accounted to

