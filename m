Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbZKEKnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbZKEKnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 05:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbZKEKne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 05:43:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59961 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbZKEKnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 05:43:33 -0500
Message-ID: <4AF2AC30.4000003@cn.fujitsu.com>
Date: Thu, 05 Nov 2009 18:42:56 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl
CC: Mike Galbraith <efault@gmx.de>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de
Subject: There is something with scheduler (was Re: [patch] Re: [regression
 bisect -next] BUG: using smp_processor_id() in preemptible [00000000] code:
 rmmod)
References: <1256784158.2848.8.camel@dhcp231-106.rdu.redhat.com>	 <1256805552.7158.22.camel@marge.simson.net>	 <20091029091411.GE22963@elte.hu>	 <1256807967.7158.58.camel@marge.simson.net>	 <1256813310.7574.3.camel@marge.simson.net>  <20091102182808.GA8950@elte.hu> <1257190811.19608.2.camel@marge.simson.net>
In-Reply-To: <1257190811.19608.2.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo

Mike Galbraith's patch didn't work.

There is something with scheduler.

I still get this bug message:

BUG: using smp_processor_id() in preemptible [00000000] code: events/1/10
caller is vmstat_update+0x2a/0x3e
Pid: 10, comm: events/1 Not tainted 2.6.32-rc6-tip-01796-gd995f1d-dirty #118
Call Trace:
 [<c02a3871>] debug_smp_processor_id+0xa5/0xbc
 [<c01a229e>] vmstat_update+0x2a/0x3e
 [<c014d6df>] worker_thread+0x134/0x1c2
 [<c01a2274>] ? vmstat_update+0x0/0x3e
 [<c0151361>] ? autoremove_wake_function+0x0/0x38
 [<c014d5ab>] ? worker_thread+0x0/0x1c2
 [<c0151298>] kthread+0x66/0x6e
 [<c0151232>] ? kthread+0x0/0x6e
 [<c0102e97>] kernel_thread_helper+0x7/0x10


Ftrace shows events/1 was run at cpu#0

          <idle>-0     [000]   947.573031: set_next_entity <-pick_next_task_fair
          <idle>-0     [000]   947.573032: update_stats_wait_end <-set_next_entity
          <idle>-0     [000]   947.573033: __dequeue_entity <-set_next_entity
          <idle>-0     [000]   947.573034: clear_buddies <-pick_next_task_fair
          <idle>-0     [000]   947.573034: set_next_entity <-pick_next_task_fair
          <idle>-0     [000]   947.573035: update_stats_wait_end <-set_next_entity
          <idle>-0     [000]   947.573036: __dequeue_entity <-set_next_entity
          <idle>-0     [000]   947.573037: hrtick_start_fair <-pick_next_task_fair
          <idle>-0     [000]   947.573038: perf_event_task_sched_out <-schedule
          <idle>-0     [000]   947.573039: memcpy <-tracing_record_cmdline
          <idle>-0     [000]   947.573040: __switch_to <-schedule
        events/1-10    [000]   947.573050: finish_task_switch <-schedule
        events/1-10    [000]   947.573051: perf_event_task_sched_in <-finish_task_switch
        events/1-10    [000]   947.573051: _spin_unlock_irq <-finish_task_switch
        events/1-10    [000]   947.573052: finish_wait <-worker_thread
        events/1-10    [000]   947.573053: kthread_should_stop <-worker_thread
        events/1-10    [000]   947.573054: _spin_lock_irq <-worker_thread
        events/1-10    [000]   947.573055: _spin_lock_irqsave <-probe_workqueue_execution
        events/1-10    [000]   947.573056: _spin_unlock_irqrestore <-probe_workqueue_execution
        events/1-10    [000]   947.573057: _spin_unlock_irq <-worker_thread
        events/1-10    [000]   947.573058: flush_to_ldisc <-worker_thread
        events/1-10    [000]   947.573059: tty_ldisc_ref <-flush_to_ldisc
        events/1-10    [000]   947.573059: tty_ldisc_try <-tty_ldisc_ref
        events/1-10    [000]   947.573060: _spin_lock_irqsave <-tty_ldisc_try
        events/1-10    [000]   947.573061: _spin_unlock_irqrestore <-tty_ldisc_try


events/1 should run at cpu#1, but [000] shows it was run at cpu#0

events/1's cpus_allowed is correct:
# taskset -p 10
pid 10's current affinity mask: 2


Thanks
Lai

Mike Galbraith wrote:
> On Mon, 2009-11-02 at 19:28 +0100, Ingo Molnar wrote:
>> FYI, non-SMP builds broke:
>>
>> kernel/built-in.o: In function `kthread_bind':
>> (.text+0x1d328): undefined reference to `sched_kthread_bind'
>> make: *** [.tmp_vmlinux1] Error 1
> 
> Oops.  Outside the SMP block might work a little better.
> 
> sched: Move the body of kthread_bind() to sched.c.
> 
> Eric Paris reported that commit f685ceacab07d3f6c236f04803e2f2f0dbcc5afb
> causes boot time PREEMPT_DEBUG complaints.
> 
> [    4.590699] BUG: using smp_processor_id() in preemptible [00000000] code: rmmod/1314
> [    4.593043] caller is task_hot+0x86/0xd0
> [    4.593872] Pid: 1314, comm: rmmod Tainted: G        W  2.6.32-rc3-fanotify #127
> [    4.595443] Call Trace:
> [    4.596177]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
> [    4.597337]  [<ffffffff81051d66>] task_hot+0x86/0xd0
> [    4.598320]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
> [    4.599368]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
> [    4.600354]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
> [    4.601545]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
> [    4.602526]  [<ffffffff810d9bee>] stop_machine_create+0x4e/0xd0
> [    4.603811]  [<ffffffff810c5818>] sys_delete_module+0x98/0x250
> [    4.604922]  [<ffffffff810e2505>] ? audit_syscall_entry+0x205/0x290
> [    4.606202]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
> 
> Since kthread_bind() messes with scheduler internals, move the body to sched.c,
> and lock the runqueue.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Reported-by: Eric Paris <eparis@redhat.com>
> LKML-Reference: <new-submission>
> 
> ---
>  kernel/kthread.c |   15 ++++++---------
>  kernel/sched.c   |   31 +++++++++++++++++++++++++++++++
>  2 files changed, 37 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6/kernel/kthread.c
> ===================================================================
> --- linux-2.6.orig/kernel/kthread.c
> +++ linux-2.6/kernel/kthread.c
> @@ -149,6 +149,8 @@ struct task_struct *kthread_create(int (
>  }
>  EXPORT_SYMBOL(kthread_create);
>  
> +extern void sched_kthread_bind(struct task_struct *k, unsigned int cpu);
> +
>  /**
>   * kthread_bind - bind a just-created kthread to a cpu.
>   * @k: thread created by kthread_create().
> @@ -157,18 +159,13 @@ EXPORT_SYMBOL(kthread_create);
>   * Description: This function is equivalent to set_cpus_allowed(),
>   * except that @cpu doesn't need to be online, and the thread must be
>   * stopped (i.e., just returned from kthread_create()).
> + *
> + * The runqueue must be locked, ergo move the body if this function
> + * to sched.c
>   */
>  void kthread_bind(struct task_struct *k, unsigned int cpu)
>  {
> -	/* Must have done schedule() in kthread() before we set_task_cpu */
> -	if (!wait_task_inactive(k, TASK_UNINTERRUPTIBLE)) {
> -		WARN_ON(1);
> -		return;
> -	}
> -	set_task_cpu(k, cpu);
> -	k->cpus_allowed = cpumask_of_cpu(cpu);
> -	k->rt.nr_cpus_allowed = 1;
> -	k->flags |= PF_THREAD_BOUND;
> +	sched_kthread_bind(k, cpu);
>  }
>  EXPORT_SYMBOL(kthread_bind);
>  
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -1992,6 +1992,37 @@ static inline void check_class_changed(s
>  		p->sched_class->prio_changed(rq, p, oldprio, running);
>  }
>  
> +/**
> + * sched_kthread_bind - bind a just-created kthread to a cpu.
> + * @k: thread created by kthread_create().
> + * @cpu: cpu (might not be online, must be possible) for @k to run on.
> + *
> + * Description: This function is equivalent to set_cpus_allowed(),
> + * except that @cpu doesn't need to be online, and the thread must be
> + * stopped (i.e., just returned from kthread_create()).
> + *
> + * Function lives here instead of kthread.c because it messes with
> + * scheduler internals which require locking.
> + */
> +void sched_kthread_bind(struct task_struct *p, unsigned int cpu)
> +{
> +	struct rq *rq = cpu_rq(cpu);
> +	unsigned long flags;
> +
> +	/* Must have done schedule() in kthread() before we set_task_cpu */
> +	if (!wait_task_inactive(p, TASK_UNINTERRUPTIBLE)) {
> +		WARN_ON(1);
> +		return;
> +	}
> +
> +	spin_lock_irqsave(&rq->lock, flags);
> +	set_task_cpu(p, cpu);
> +	p->cpus_allowed = cpumask_of_cpu(cpu);
> +	p->rt.nr_cpus_allowed = 1;
> +	p->flags |= PF_THREAD_BOUND;
> +	spin_unlock_irqrestore(&rq->lock, flags);
> +}
> +
>  #ifdef CONFIG_SMP
>  /*
>   * Is this task likely cache-hot:
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

