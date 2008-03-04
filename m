Return-Path: <linux-kernel-owner+w=401wt.eu-S1762010AbYCECZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762010AbYCECZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 21:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbYCECZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 21:25:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:64902 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbYCECZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 21:25:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,444,1199692800"; 
   d="scan'208";a="349949775"
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are
	dealocked when cpu is set to offline
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080304150107.GA564@tv-sign.ru>
References: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com>
	 <20080303153154.GA11288@in.ibm.com>
	 <1204555505.3842.4.camel@yangyi-dev.bj.intel.com>
	 <20080304052613.GA28632@in.ibm.com>  <20080304150107.GA564@tv-sign.ru>
Content-Type: text/plain
Organization: Intel
Date: Tue, 04 Mar 2008 22:37:23 +0800
Message-Id: <1204641443.3842.46.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-04 at 18:01 +0300, Oleg Nesterov wrote:
> On 03/04, Gautham R Shenoy wrote:
> >
> > So at times, the callback thread is blocked on kthread_stop(k) in
> > softlockup.c, while other time, it was blocked in
> > cleanup_workqueue_threads() in workqueue.c. 
> 
> From another message:
> >
> > However, it remains in R< state
> 
> What about cwq->thread? Was it TASK_RUNNING too?
> 
> Perhaps, for some reason the task can't get CPU after migrating from
> the now dead CPU.
> 
> I can't reproduce this problem on my one cpu P4-ht, perhaps you can
> try something like the untested/uncompiled patch below?
You need one multiprocessor system to regenerate, 4 CPUs or more are
best.

At the beginning, i thought Detect Soft Lockups
(CONFIG_DETECT_SOFTLOCKUP) is culprit because it added much code to
detect lock dependencies and deadlocks, but the issue is still there
after i disabled soft lock detection, it can be regenerated but will
take much long time.

At this time, group_balance and kblockd are in "R<" state.

[root@harwich-rh ~]# ps aux | grep kstop
root     15466  0.0  0.0      0     0 ?        S<   01:03   0:00 [kstopmachine]
root     15467  0.0  0.0      0     0 ?        Z<   01:03   0:00 [kstopmachine] <defunct>
root     15468  0.0  0.0      0     0 ?        Z<   01:03   0:00 [kstopmachine] <defunct>
root     15469  0.0  0.0      0     0 ?        Z<   01:03   0:00 [kstopmachine] <defunct>
root     15470  0.0  0.0      0     0 ?        Z<   01:03   0:00 [kstopmachine] <defunct>
root     15471  0.0  0.0      0     0 ?        Z<   01:03   0:00 [kstopmachine] <defunct>
root     15472  0.0  0.0      0     0 ?        Z<   01:03   0:00 [kstopmachine] <defunct>
root     15473  0.0  0.0      0     0 ?        Z<   01:03   0:00 [kstopmachine] <defunct>
root     15474  0.0  0.0      0     0 ?        Z<   01:03   0:00 [kstopmachine] <defunct>
root     15475  0.0  0.0      0     0 ?        Z<   01:03   0:00 [kstopmachine] <defunct>
root     15476  0.0  0.0      0     0 ?        Z<   01:03   0:00 [kstopmachine] <defunct>
root     17155  0.0  0.0  61148   708 pts/3    R+   14:47   0:00 grep kstop
[root@harwich-rh ~]# ps aux | grep "R<"
root        35  0.0  0.0      0     0 ?        R<   Mar13   0:00 [group_balance]
root       182  0.1  0.0      0     0 ?        R<   Mar13   1:09 [kblockd/0]
root     17157  0.0  0.0  61148   704 pts/3    R+   14:47   0:00 grep R<
[root@harwich-rh ~]#



> Oleg.
> 
> --- include/linux/sched.h	2008-02-15 16:59:17.000000000 +0300
> +++ include/linux/sched.h	2008-03-04 17:44:53.136738605 +0300
> @@ -1121,6 +1121,7 @@ struct task_struct {
>  /* hung task detection */
>  	unsigned long last_switch_timestamp;
>  	unsigned long last_switch_count;
> +	unsigned long xxx;
>  #endif
>  /* CPU-specific state of this task */
>  	struct thread_struct thread;
> --- kernel/fork.c	2008-02-15 16:59:17.000000000 +0300
> +++ kernel/fork.c	2008-03-04 17:45:14.773033839 +0300
> @@ -1097,6 +1097,7 @@ static struct task_struct *copy_process(
>  #ifdef CONFIG_DETECT_SOFTLOCKUP
>  	p->last_switch_count = 0;
>  	p->last_switch_timestamp = 0;
> +	p->xxx = 0;
>  #endif
>  
>  #ifdef CONFIG_TASK_XACCT
> --- kernel/sched.c	2008-02-15 16:59:17.000000000 +0300
> +++ kernel/sched.c	2008-03-04 17:48:42.308798646 +0300
> @@ -1291,6 +1291,7 @@ static void enqueue_task(struct rq *rq, 
>  	sched_info_queued(p);
>  	p->sched_class->enqueue_task(rq, p, wakeup);
>  	p->se.on_rq = 1;
> +	p->xxx = jiffies | 1;
>  }
>  
>  static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
> @@ -3944,6 +3945,8 @@ need_resched_nonpreemptible:
>  	preempt_enable_no_resched();
>  	if (unlikely(test_thread_flag(TIF_NEED_RESCHED)))
>  		goto need_resched;
> +
> +	current->xxx = 0;
>  }
>  EXPORT_SYMBOL(schedule);
>  
> --- kernel/softlockup.c	2008-02-15 16:59:17.000000000 +0300
> +++ kernel/softlockup.c	2008-03-04 17:49:05.584414763 +0300
> @@ -174,6 +174,27 @@ static void check_hung_task(struct task_
>  	touch_nmi_watchdog();
>  }
>  
> +static void check_running_task(struct task_struct *t, unsigned long now)
> +{
> +	if (!sysctl_hung_task_timeout_secs)
> +		return;
> +
> +	if (time_before(now, t->xxx + HZ * sysctl_hung_task_timeout_secs)
> +		return;
> +
> +	printk(KERN_ERR "INFO: task %s:%d can't get CPU for more than "
> +			"%ld seconds.\n", t->comm, t->pid,
> +			sysctl_hung_task_timeout_secs);
> +
> +	if (!cpus_intersects(t->cpus_allowed, cpu_online_map))
> +		printk(KERN_ERR "bad ->cpus_allowed\n");
> +	if (!cpu_online(task_cpu(t)))
> +		printk(KERN_ERR "bad ->cpu\n");
> +
> +	sched_show_task(t);
> +	touch_nmi_watchdog();
> +}
> +
>  /*
>   * Check whether a TASK_UNINTERRUPTIBLE does not get woken up for
>   * a really long time (120 seconds). If that happens, print out
> @@ -183,6 +204,7 @@ static void check_hung_uninterruptible_t
>  {
>  	int max_count = sysctl_hung_task_check_count;
>  	unsigned long now = get_timestamp(this_cpu);
> +	unsigned long jiff = jiffies;
>  	struct task_struct *g, *t;
>  
>  	/*
> @@ -192,15 +214,17 @@ static void check_hung_uninterruptible_t
>  	if ((tainted & TAINT_DIE) || did_panic)
>  		return;
>  
> -	read_lock(&tasklist_lock);
> +	rcu_read_lock();
>  	do_each_thread(g, t) {
>  		if (!--max_count)
>  			goto unlock;
>  		if (t->state & TASK_UNINTERRUPTIBLE)
>  			check_hung_task(t, now);
> +		if (!t->xxx)
> +			check_running_task(t, jiff);
>  	} while_each_thread(g, t);
>   unlock:
> -	read_unlock(&tasklist_lock);
> +	rcu_read_unlock();
>  }
>  
>  /*
> 

