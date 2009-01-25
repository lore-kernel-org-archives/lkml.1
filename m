Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbZAYP45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbZAYP45 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 10:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbZAYP4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 10:56:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:55364 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbZAYP4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 10:56:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L1X2wJoKmqJGH/Hk1BqLDcb7RjmBpOY82iEjYWSkHDAFjvrJS1UhFM5rX9bwenqORw
         Y8JSMGVwSiSaYY73uL6tZWou4t+kJsrQtnQpXeYaK4X0csczuK7IaHGuyWLcQIOeQaiu
         Q8jW+LiZ8Usua7Fo2pkwh7O1LhKRwPScFEO18=
Date: Sun, 25 Jan 2009 16:56:40 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] tracing/workqueue: separate singlethreaded
	workqueues
Message-ID: <20090125155639.GA6749@nowhere>
References: <497917de.1ade660a.79da.ffffb9f7@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497917de.1ade660a.79da.ffffb9f7@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 05:05:34PM -0800, Frederic Weisbecker wrote:
> When a singlethread thread is added on the list, it is
> appended to the first cpu workqueues. This is a mistake because
> singlethreaded workqueues are not bounded to specific cpu but
> on all online cpus.
> 
> On their cpu column, we will now find a * character.
> 
> # CPU  INSERTED  EXECUTED   NAME
> # |      |         |          |
> 
>   *      0          0       kpsmoused
>   *      0          0       ata_aux
>   *      0          0       cqueue
>   *      0          0       kacpi_notify
>   *      0          0       kacpid
>   *    998        998       khelper
>   *      0          0       cpuset
> 
>   1      0          0       hda0/1
>   1     42         42       reiserfs/1
>   1      0          0       scsi_tgtd/1
>   1      0          0       aio/1
>   1      0          0       ata/1
>   1    193        193       kblockd/1
>   1      0          0       kintegrityd/1
>   1      4          4       work_on_cpu/1
>   1   1244       1244       events/1
> 
>   0      0          0       hda0/0
>   0     63         63       reiserfs/0
>   0      0          0       scsi_tgtd/0
>   0      0          0       aio/0
>   0      0          0       ata/0
>   0    188        188       kblockd/0
>   0      0          0       kintegrityd/0
>   0     16         16       work_on_cpu/0
>   0   1360       1360       events/0
> 
> Hmm, it looks like most of these workqueues are pointless :-)
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  include/trace/workqueue.h      |   16 +++--
>  kernel/trace/trace_workqueue.c |  143 +++++++++++++++++++++++++++-------------
>  kernel/workqueue.c             |   11 ++-
>  3 files changed, 115 insertions(+), 55 deletions(-)
> 
> diff --git a/include/trace/workqueue.h b/include/trace/workqueue.h
> index 867829d..4769c2d 100644
> --- a/include/trace/workqueue.h
> +++ b/include/trace/workqueue.h
> @@ -5,13 +5,17 @@
>  #include <linux/workqueue.h>
>  #include <linux/sched.h>
>  
> +#define SINGLETHREAD_CPU	-1
> +
>  DECLARE_TRACE(workqueue_insertion,
> -	   TPPROTO(struct task_struct *wq_thread, struct work_struct *work),
> -	   TPARGS(wq_thread, work));
> +	   TPPROTO(struct task_struct *wq_thread, struct work_struct *work,
> +		   int singlethread),
> +	   TPARGS(wq_thread, work, singlethread));
>  
>  DECLARE_TRACE(workqueue_execution,
> -	   TPPROTO(struct task_struct *wq_thread, struct work_struct *work),
> -	   TPARGS(wq_thread, work));
> +	   TPPROTO(struct task_struct *wq_thread, struct work_struct *work,
> +		   int singlethread),
> +	   TPARGS(wq_thread, work, singlethread));
>  
>  /* Trace the creation of one workqueue thread on a cpu */
>  DECLARE_TRACE(workqueue_creation,
> @@ -19,7 +23,7 @@ DECLARE_TRACE(workqueue_creation,
>  	   TPARGS(wq_thread, cpu));
>  
>  DECLARE_TRACE(workqueue_destruction,
> -	   TPPROTO(struct task_struct *wq_thread),
> -	   TPARGS(wq_thread));
> +	   TPPROTO(struct task_struct *wq_thread, int singlethread),
> +	   TPARGS(wq_thread, singlethread));
>  
>  #endif /* __TRACE_WORKQUEUE_H */
> diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
> index 4664990..38a1291 100644
> --- a/kernel/trace/trace_workqueue.c
> +++ b/kernel/trace/trace_workqueue.c
> @@ -12,7 +12,6 @@
>  #include "trace_stat.h"
>  #include "trace.h"
>  
> -
>  /* A cpu workqueue thread */
>  struct cpu_workqueue_stats {
>  	struct list_head            list;
> @@ -41,18 +40,28 @@ struct workqueue_global_stats {
>  static DEFINE_PER_CPU(struct workqueue_global_stats, all_workqueue_stat);
>  #define workqueue_cpu_stat(cpu) (&per_cpu(all_workqueue_stat, cpu))
>  
> +static struct workqueue_global_stats singlethread_stat;
> +
> +
>  /* Insertion of a work */
>  static void
>  probe_workqueue_insertion(struct task_struct *wq_thread,
> -			  struct work_struct *work)
> +			  struct work_struct *work, int singlethread)
>  {
> -	int cpu = cpumask_first(&wq_thread->cpus_allowed);
> +	struct workqueue_global_stats *stats;
>  	struct cpu_workqueue_stats *node, *next;
>  	unsigned long flags;
> +	int cpu;
> +
> +	if (singlethread)
> +		stats = &singlethread_stat;
> +	else {
> +		cpu = cpumask_first(&wq_thread->cpus_allowed);
> +		stats = workqueue_cpu_stat(cpu);
> +	}
>  
> -	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> -	list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
> -							list) {
> +	spin_lock_irqsave(&stats->lock, flags);
> +	list_for_each_entry_safe(node, next, &stats->list, list) {
>  		if (node->pid == wq_thread->pid) {
>  			atomic_inc(&node->inserted);
>  			goto found;
> @@ -60,21 +69,28 @@ probe_workqueue_insertion(struct task_struct *wq_thread,
>  	}
>  	pr_debug("trace_workqueue: entry not found\n");
>  found:
> -	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
> +	spin_unlock_irqrestore(&stats->lock, flags);
>  }
>  
>  /* Execution of a work */
>  static void
>  probe_workqueue_execution(struct task_struct *wq_thread,
> -			  struct work_struct *work)
> +			  struct work_struct *work, int singlethread)
>  {
> -	int cpu = cpumask_first(&wq_thread->cpus_allowed);
>  	struct cpu_workqueue_stats *node, *next;
> +	struct workqueue_global_stats *stats;
>  	unsigned long flags;
> +	int cpu;
> +
> +	if (singlethread)
> +		stats = &singlethread_stat;
> +	else {
> +		cpu = cpumask_first(&wq_thread->cpus_allowed);
> +		stats = workqueue_cpu_stat(cpu);
> +	}
>  
> -	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> -	list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
> -							list) {
> +	spin_lock_irqsave(&stats->lock, flags);
> +	list_for_each_entry_safe(node, next, &stats->list, list) {
>  		if (node->pid == wq_thread->pid) {
>  			node->executed++;
>  			goto found;
> @@ -82,17 +98,16 @@ probe_workqueue_execution(struct task_struct *wq_thread,
>  	}
>  	pr_debug("trace_workqueue: entry not found\n");
>  found:
> -	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
> +	spin_unlock_irqrestore(&stats->lock, flags);
>  }
>  
>  /* Creation of a cpu workqueue thread */
>  static void probe_workqueue_creation(struct task_struct *wq_thread, int cpu)
>  {
> +	struct workqueue_global_stats *stats;
>  	struct cpu_workqueue_stats *cws;
>  	unsigned long flags;
>  
> -	WARN_ON(cpu < 0 || cpu >= num_possible_cpus());
> -
>  	/* Workqueues are sometimes created in atomic context */
>  	cws = kzalloc(sizeof(struct cpu_workqueue_stats), GFP_ATOMIC);
>  	if (!cws) {
> @@ -103,27 +118,39 @@ static void probe_workqueue_creation(struct task_struct *wq_thread, int cpu)
>  
>  	INIT_LIST_HEAD(&cws->list);
>  	cws->cpu = cpu;
> -
>  	cws->pid = wq_thread->pid;
>  
> -	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> -	if (list_empty(&workqueue_cpu_stat(cpu)->list))
> +	if (cpu == SINGLETHREAD_CPU)
> +		stats = &singlethread_stat;
> +	else
> +		stats = workqueue_cpu_stat(cpu);
> +
> +
> +	spin_lock_irqsave(&stats->lock, flags);
> +	if (list_empty(&stats->list))
>  		cws->first_entry = true;
> -	list_add_tail(&cws->list, &workqueue_cpu_stat(cpu)->list);
> -	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
> +	list_add_tail(&cws->list, &stats->list);
> +	spin_unlock_irqrestore(&stats->lock, flags);
>  }
>  
>  /* Destruction of a cpu workqueue thread */
> -static void probe_workqueue_destruction(struct task_struct *wq_thread)
> +static void probe_workqueue_destruction(struct task_struct *wq_thread,
> +					int singlethread)
>  {
> -	/* Workqueue only execute on one cpu */
> -	int cpu = cpumask_first(&wq_thread->cpus_allowed);
>  	struct cpu_workqueue_stats *node, *next;
> +	struct workqueue_global_stats *stats;
>  	unsigned long flags;
> +	int cpu;
>  
> -	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> -	list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
> -							list) {
> +	if (singlethread)
> +		stats = &singlethread_stat;
> +	else {
> +		cpu = cpumask_first(&wq_thread->cpus_allowed);
> +		stats = workqueue_cpu_stat(cpu);
> +	}
> +
> +	spin_lock_irqsave(&stats->lock, flags);
> +	list_for_each_entry_safe(node, next, &stats->list, list) {
>  		if (node->pid == wq_thread->pid) {
>  			list_del(&node->list);
>  			kfree(node);
> @@ -133,23 +160,28 @@ static void probe_workqueue_destruction(struct task_struct *wq_thread)
>  
>  	pr_debug("trace_workqueue: don't find workqueue to destroy\n");
>  found:
> -	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
> +	spin_unlock_irqrestore(&stats->lock, flags);
>  
>  }
>  
>  static struct cpu_workqueue_stats *workqueue_stat_start_cpu(int cpu)
>  {
>  	unsigned long flags;
> +	struct workqueue_global_stats *stats;
>  	struct cpu_workqueue_stats *ret = NULL;
>  
> +	if (cpu == SINGLETHREAD_CPU)
> +		stats = &singlethread_stat;
> +	else
> +		stats = workqueue_cpu_stat(cpu);
>  
> -	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> +	spin_lock_irqsave(&stats->lock, flags);
>  
> -	if (!list_empty(&workqueue_cpu_stat(cpu)->list))
> -		ret = list_entry(workqueue_cpu_stat(cpu)->list.next,
> +	if (!list_empty(&stats->list))
> +		ret = list_entry(stats->list.next,
>  				 struct cpu_workqueue_stats, list);
>  
> -	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
> +	spin_unlock_irqrestore(&stats->lock, flags);
>  
>  	return ret;
>  }
> @@ -170,41 +202,59 @@ static void *workqueue_stat_start(void)
>  static void *workqueue_stat_next(void *prev, int idx)
>  {
>  	struct cpu_workqueue_stats *prev_cws = prev;
> +	struct workqueue_global_stats *stats;
>  	int cpu = prev_cws->cpu;
>  	unsigned long flags;
>  	void *ret = NULL;
>  
> -	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> -	if (list_is_last(&prev_cws->list, &workqueue_cpu_stat(cpu)->list)) {
> -		spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
> +	if (cpu == SINGLETHREAD_CPU)
> +		stats = &singlethread_stat;
> +	else
> +		stats = workqueue_cpu_stat(cpu);
> +
> +	spin_lock_irqsave(&stats->lock, flags);
> +	if (list_is_last(&prev_cws->list, &stats->list)) {
> +		spin_unlock_irqrestore(&stats->lock, flags);
> +		if (cpu == SINGLETHREAD_CPU)
> +			return NULL;
>  		for (++cpu ; cpu < num_possible_cpus(); cpu++) {
>  			ret = workqueue_stat_start_cpu(cpu);
>  			if (ret)
>  				return ret;
>  		}
> -		return NULL;
> +		/* Display singlethreaded at last */
> +		return workqueue_stat_start_cpu(SINGLETHREAD_CPU);
>  	}
> -	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
> +	ret = list_entry(prev_cws->list.next, struct cpu_workqueue_stats, list);
> +	spin_unlock_irqrestore(&stats->lock, flags);
>  
> -	return list_entry(prev_cws->list.next, struct cpu_workqueue_stats,
> -			  list);
> +	return ret;
>  }
>  
>  static int workqueue_stat_show(struct seq_file *s, void *p)
>  {
>  	struct cpu_workqueue_stats *cws = p;
> +	struct workqueue_global_stats *stats;
>  	unsigned long flags;
>  	int cpu = cws->cpu;
>  
> -	seq_printf(s, "%3d %6d     %6u       %s\n", cws->cpu,
> -		   atomic_read(&cws->inserted),
> -		   cws->executed,
> -		   trace_find_cmdline(cws->pid));
> +	if (cpu == SINGLETHREAD_CPU) {
> +		stats = &singlethread_stat;
> +		seq_printf(s, "  * ");
> +	} else {
> +		stats = workqueue_cpu_stat(cpu);
> +		seq_printf(s, "%3d ", cpu);
> +	}
> +
>  
> -	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> -	if (&cws->list == workqueue_cpu_stat(cpu)->list.next)
> +	seq_printf(s, "%6d     %6u       %s\n", atomic_read(&cws->inserted),
> +						cws->executed,
> +					     trace_find_cmdline(cws->pid));
> +
> +	spin_lock_irqsave(&stats->lock, flags);
> +	if (&cws->list == stats->list.next)
>  		seq_printf(s, "\n");
> -	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
> +	spin_unlock_irqrestore(&stats->lock, flags);
>  
>  	return 0;
>  }
> @@ -265,6 +315,9 @@ int __init trace_workqueue_early_init(void)
>  		INIT_LIST_HEAD(&workqueue_cpu_stat(cpu)->list);
>  	}
>  
> +	spin_lock_init(&singlethread_stat.lock);
> +	INIT_LIST_HEAD(&singlethread_stat.list);
> +
>  	return 0;
>  
>  no_creation:
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index e53ee18..936b037 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -131,7 +131,7 @@ DEFINE_TRACE(workqueue_insertion);
>  static void insert_work(struct cpu_workqueue_struct *cwq,
>  			struct work_struct *work, struct list_head *head)
>  {
> -	trace_workqueue_insertion(cwq->thread, work);
> +	trace_workqueue_insertion(cwq->thread, work, cwq->wq->singlethread);
>  
>  	set_wq_data(work, cwq);
>  	/*
> @@ -291,7 +291,9 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
>  		 */
>  		struct lockdep_map lockdep_map = work->lockdep_map;
>  #endif
> -		trace_workqueue_execution(cwq->thread, work);
> +		struct workqueue_struct *wq = cwq->wq;
> +
> +		trace_workqueue_execution(cwq->thread, work, wq->singlethread);
>  		cwq->current_work = work;
>  		list_del_init(cwq->worklist.next);
>  		spin_unlock_irq(&cwq->lock);
> @@ -796,7 +798,8 @@ static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
>  		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
>  	cwq->thread = p;
>  
> -	trace_workqueue_creation(cwq->thread, cpu);
> +	trace_workqueue_creation(cwq->thread, wq->singlethread ?
> +					      SINGLETHREAD_CPU : cpu);
>  
>  	return 0;
>  }
> @@ -904,7 +907,7 @@ static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
>  	 * checks list_empty(), and a "normal" queue_work() can't use
>  	 * a dead CPU.
>  	 */
> -	trace_workqueue_destruction(cwq->thread);
> +	trace_workqueue_destruction(cwq->thread, cwq->wq->singlethread);
>  	kthread_stop(cwq->thread);
>  	cwq->thread = NULL;
>  }
> -- 
> 1.6.0.4
> 
> 


Cc'ed Lai!

