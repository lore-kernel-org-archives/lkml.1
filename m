Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbZDTLgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbZDTLgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 07:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbZDTLgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 07:36:10 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:32841 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbZDTLgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 07:36:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LJhR+I9xcjSWzpD7lXmGYMAVPlKOQodF7QPCFuBturRhEUTXYMUBxJLMzF+PNKEdf7
         qsX+5qa/XvIj/3xB23n7Scr6muW8MHtu24V1SkhKw26/OJa5nhN3E9InV1E/CHQOyqMV
         7tyM0a1qWam76+BExpmijbOTXkydciAMtamfE=
Date: Mon, 20 Apr 2009 13:36:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] trace_workqueue: Add worklet information
Message-ID: <20090420113601.GC6081@nowhere>
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49EC1943.8080606@cn.fujitsu.com> <49EC1F99.9030208@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EC1F99.9030208@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 03:09:13PM +0800, Zhaolei wrote:
> Now workqueue tracer can display per-worklet information as following:
>  # cat [debugfs]/tracing/trace_stat/workqueues
>  # CPU  INSERTED  EXECUTED   TASKNAME:PID
>  # |      |         |        `-WORKFUNC
>  # |      |         |          |
>  CPU  INSERTED  EXECUTED   TASKNAME:PID
>    0    157        157       events/0:5
>    0      1          1        |-reg_todo+0x0/0x648
>    0      3          3        |-check_corruption+0x0/0x2c
>    0      1          1        |-power_supply_changed_work+0x0/0x3c
>    0      2          2        |-console_callback+0x0/0x145
>    0      9          9        |-do_cache_clean+0x0/0x6a
>    0      1          1        |-wq_barrier_func+0x0/0x12
>    0    129        129        |-vmstat_update+0x0/0x33
>    0      8          8        |-mce_work_fn+0x0/0x31
>    0      1          1        |-grace_ender+0x0/0x14
>    0      2          2        `-rt_worker_func+0x0/0x2de
>    0      0          0       cpuset:6
>    0    656        656       khelper:7
>    0    656        656        `-__call_usermodehelper+0x0/0xa0
>    0      0          0       netns:11
>    0    592        592       kblockd/0:13
>    0     39         39        |-blk_unplug_work+0x0/0x1e
>    0    553        553        `-cfq_kick_queue+0x0/0x2f
>    0      0          0       kacpid:412
>    0      0          0       kacpi_notify:415
>    0      0          0       ata/0:463
>    0      0          0       ata_aux:509
>    0      0          0       ksuspend_usbd:515
>    0      0          0       aio/0:717
>    0      0          0       nfsiod:718
>    0      0          0       crypto/0:719
>    0      0          0       kpsmoused:1141
>    0      0          0       kstriped:1248
>    0      0          0       kondemand/0:1259
>    0      0          0       usbhid_resumer:1260
>    0     21         21       rpciod/0:1333
>    0      1          1        |-xs_tcp_connect_worker4+0x0/0x1b
>    0     19         19        |-xs_udp_connect_worker4+0x0/0x130
>    0      1          1        `-xprt_autoclose+0x0/0x2c
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  kernel/trace/trace_workqueue.c |  219 ++++++++++++++++++++++++++++++++--------
>  1 files changed, 175 insertions(+), 44 deletions(-)
> 
> diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
> index 3393c95..c465dbc 100644
> --- a/kernel/trace/trace_workqueue.c
> +++ b/kernel/trace/trace_workqueue.c
> @@ -12,19 +12,33 @@
>  #include "trace_stat.h"
>  #include "trace.h"
>  
> +/* A callback function saved in struct work_struct->func */
> +struct cpu_workqueue_stats;
> +struct workfunc_stats {
> +	struct list_head		list;
> +	struct cpu_workqueue_stats	*parent;
> +
> +	/* Addr of worklet's callback function */
> +	work_func_t			func;
> +	/* Can be inserted from interrupt or user context, need to be atomic */
> +	atomic_t			inserted;
> +	/*
> +	 * Don't need to be atomic, works are serialized in a single workqueue
> +	 * thread on a single CPU.
> +	 */
> +	unsigned int			executed;
> +};
>  
>  /* A cpu workqueue thread */
>  struct cpu_workqueue_stats {
>  	struct list_head            list;
>  	int		            cpu;
>  	pid_t			    pid;
> -/* Can be inserted from interrupt or user context, need to be atomic */
> +	/* Refer to comments of struct workfunc_stats for detail */
>  	atomic_t	            inserted;
> -/*
> - *  Don't need to be atomic, works are serialized in a single workqueue thread
> - *  on a single CPU.
> - */
>  	unsigned int		    executed;
> +	/* list of struct workfunc_stats in this workqueue */
> +	struct list_head            workfunclist;
>  };
>  
>  /* List of workqueue threads on one cpu */
> @@ -39,6 +53,38 @@ struct workqueue_global_stats {
>  static DEFINE_PER_CPU(struct workqueue_global_stats, all_workqueue_stat);
>  #define workqueue_cpu_stat(cpu) (&per_cpu(all_workqueue_stat, cpu))
>  
> +/*
> + * Update record when insert a work into workqueue
> + * Caller need to hold cpu_workqueue_stats spin_lock
> + */
> +int do_workqueue_insertion(struct cpu_workqueue_stats *cws,
> +			   struct work_struct *work)
> +{
> +	struct workfunc_stats *wfstat;
> +
> +	atomic_inc(&cws->inserted);
> +
> +	list_for_each_entry(wfstat, &cws->workfunclist, list)
> +		if (wfstat->func == work->func)
> +			goto found;
> +
> +	/* not found, first insert */
> +
> +	/* work can be inserted from interrupt */
> +	wfstat = kzalloc(sizeof(struct workfunc_stats), GFP_ATOMIC);
> +	if (!wfstat)
> +		return -ENOMEM;
> +
> +	wfstat->parent = cws;
> +	wfstat->func = work->func;
> +
> +	list_add_tail(&wfstat->list, &cws->workfunclist);
> +found:
> +	atomic_inc(&wfstat->inserted);
> +
> +	return 0;
> +}
> +
>  /* Insertion of a work */
>  static void
>  probe_workqueue_insertion(struct task_struct *wq_thread,
> @@ -51,7 +97,8 @@ probe_workqueue_insertion(struct task_struct *wq_thread,
>  	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
>  	list_for_each_entry(node, &workqueue_cpu_stat(cpu)->list, list) {
>  		if (node->pid == wq_thread->pid) {
> -			atomic_inc(&node->inserted);
> +			/* we ignore error of do_workqueue_insertion */
> +			do_workqueue_insertion(node, work);
>  			goto found;
>  		}
>  	}
> @@ -67,17 +114,30 @@ probe_workqueue_execution(struct task_struct *wq_thread,
>  {
>  	int cpu = cpumask_first(&wq_thread->cpus_allowed);
>  	struct cpu_workqueue_stats *node;
> +	struct workfunc_stats *wfnode;
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> -	list_for_each_entry(node, &workqueue_cpu_stat(cpu)->list, list) {
> +
> +	list_for_each_entry(node, &workqueue_cpu_stat(cpu)->list, list)
>  		if (node->pid == wq_thread->pid) {
>  			node->executed++;
> -			goto found;
> +			goto found_wq;
>  		}
> -	}
> -	pr_debug("trace_workqueue: entry not found\n");
> -found:
> +	pr_debug("trace_workqueue: workqueue not found\n");
> +	goto end;
> +
> +found_wq:
> +	list_for_each_entry(wfnode, &node->workfunclist, list)
> +		if (wfnode->func == work->func) {
> +			wfnode->executed++;
> +			goto found_wf;
> +		}
> +	pr_debug("trace_workqueue: worklet not found\n");
> +	goto end;
> +
> +found_wf:
> +end:
>  	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
>  }
>  
> @@ -85,6 +145,7 @@ found:
>  static void probe_workqueue_creation(struct task_struct *wq_thread, int cpu)
>  {
>  	struct cpu_workqueue_stats *cws;
> +	struct workfunc_stats *wfstat;
>  	unsigned long flags;
>  
>  	WARN_ON(cpu < 0);
> @@ -93,16 +154,37 @@ static void probe_workqueue_creation(struct task_struct *wq_thread, int cpu)
>  	cws = kzalloc(sizeof(struct cpu_workqueue_stats), GFP_ATOMIC);
>  	if (!cws) {
>  		pr_warning("trace_workqueue: not enough memory\n");
> -		return;
> +		goto err_alloc_cws;
>  	}
>  	INIT_LIST_HEAD(&cws->list);
>  	cws->cpu = cpu;
>  
>  	cws->pid = wq_thread->pid;
> +	INIT_LIST_HEAD(&cws->workfunclist);
> +
> +	/*
> +	 * add a dummy node to cpu_workqueue_stats->workfunclist to:
> +	 * 1: help print function to print header of work(ex, workqueue info)
> +	 * 2: used as a seq iter if no work exist in workqueue
> +	 */
> +	wfstat = kzalloc(sizeof(struct workfunc_stats), GFP_ATOMIC);
> +	if (!wfstat) {
> +		pr_warning("trace_workqueue: not enough memory\n");
> +		goto err_alloc_wfstat;
> +	}
> +	wfstat->parent = cws;
> +	list_add_tail(&wfstat->list, &cws->workfunclist);
>  
>  	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
>  	list_add_tail(&cws->list, &workqueue_cpu_stat(cpu)->list);
>  	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
> +
> +	return;
> +
> +err_alloc_wfstat:
> +	kfree(cws);
> +err_alloc_cws:
> +	return;
>  }
>  
>  /* Destruction of a cpu workqueue thread */
> @@ -115,12 +197,22 @@ static void probe_workqueue_destruction(struct task_struct *wq_thread)
>  
>  	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
>  	list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
> -							list) {
> -		if (node->pid == wq_thread->pid) {
> -			list_del(&node->list);
> -			kfree(node);
> -			goto found;
> +				 list) {
> +		struct workfunc_stats *wfstat, *wfstatnext;
> +
> +		if (node->pid != wq_thread->pid)
> +			continue;
> +
> +		list_for_each_entry_safe(wfstat, wfstatnext,
> +					 &node->workfunclist, list) {
> +			list_del(&wfstat->list);
> +			kfree(wfstat);
>  		}
> +
> +		list_del(&node->list);
> +		kfree(node);



Sidenote to me: I have to provide a way for a stat
tracer to wait for the end of a pending statistic
output session before the tracer comes to free any
of its exposed entries. Otherwise we could end up
with freed memory dereference.

May be waitqueue.



> +
> +		goto found;
>  	}
>  
>  	pr_debug("trace_workqueue: don't find workqueue to destroy\n");
> @@ -129,17 +221,23 @@ found:
>  
>  }
>  
> -static struct cpu_workqueue_stats *workqueue_stat_start_cpu(int cpu)
> +static struct workfunc_stats *workqueue_stat_start_cpu(int cpu)
>  {
>  	unsigned long flags;
> -	struct cpu_workqueue_stats *ret = NULL;
> -
> +	struct workfunc_stats *ret = NULL;
>  
>  	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
>  
> -	if (!list_empty(&workqueue_cpu_stat(cpu)->list))
> -		ret = list_entry(workqueue_cpu_stat(cpu)->list.next,
> -				 struct cpu_workqueue_stats, list);
> +	if (!list_empty(&workqueue_cpu_stat(cpu)->list)) {
> +		struct cpu_workqueue_stats *cws;
> +		cws = list_entry(workqueue_cpu_stat(cpu)->list.next,
> +			struct cpu_workqueue_stats, list);
> +		/*
> +		 * cpu_workqueue_stats->workfunclist at least have a dummy node
> +		 */
> +		ret = list_entry(cws->workfunclist.next, struct workfunc_stats,
> +			list);
> +	}
>  
>  	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
>  
> @@ -161,43 +259,75 @@ static void *workqueue_stat_start(struct tracer_stat *trace)
>  
>  static void *workqueue_stat_next(void *prev, int idx)
>  {
> -	struct cpu_workqueue_stats *prev_cws = prev;
> -	int cpu = prev_cws->cpu;
> +	struct workfunc_stats *prev_wfstat = prev;
> +	int cpu = prev_wfstat->parent->cpu;
>  	unsigned long flags;
>  	void *ret = NULL;
>  
>  	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> -	if (list_is_last(&prev_cws->list, &workqueue_cpu_stat(cpu)->list)) {
> +
> +	if (!list_is_last(&prev_wfstat->list,
> +	    &prev_wfstat->parent->workfunclist)) {
> +		ret = list_entry(prev_wfstat->list.next, struct workfunc_stats,
> +			list);
>  		spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
> -		do {
> -			cpu = cpumask_next(cpu, cpu_possible_mask);
> -			if (cpu >= nr_cpu_ids)
> -				return NULL;
> -		} while (!(ret = workqueue_stat_start_cpu(cpu)));
>  		return ret;
>  	}
> +
> +	if (!list_is_last(&prev_wfstat->parent->list,
> +	    &workqueue_cpu_stat(cpu)->list)) {
> +		struct cpu_workqueue_stats *cws = list_entry(
> +			prev_wfstat->parent->list.next,
> +			struct cpu_workqueue_stats, list);
> +		ret = list_entry(cws->workfunclist.next, struct workfunc_stats,
> +			list);
> +		spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
> +		return ret;
> +	}
> +
>  	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
>  
> -	return list_entry(prev_cws->list.next, struct cpu_workqueue_stats,
> -			  list);
> +	do {
> +		cpu = cpumask_next(cpu, cpu_possible_mask);
> +		if (cpu >= nr_cpu_ids)


The above test will take the total number of cpus as
the last cpu number. This assumption may be false
if the possible cpus are not contiguous.

Perhaps you'd better use:


for_each_possible_cpu(cpu) {
	ret = workqueue_stat_start_cpu(cpu);
	if (ret)
		break;
}

After a quick look in cpumask.h it seems it will start
from the cpu which follows the one you give in parameter.
So it should be fine.



> +			return NULL;
> +	} while (!(ret = workqueue_stat_start_cpu(cpu)));
> +
> +	return ret;
>  }
>  
>  static int workqueue_stat_show(struct seq_file *s, void *p)
>  {
> -	struct cpu_workqueue_stats *cws = p;
> +	struct workfunc_stats *wfstat = p;
> +	struct cpu_workqueue_stats *cws = wfstat->parent;
>  	struct pid *pid;
>  	struct task_struct *tsk;
>  
> -	pid = find_get_pid(cws->pid);
> -	if (pid) {
> -		tsk = get_pid_task(pid, PIDTYPE_PID);
> -		if (tsk) {
> -			seq_printf(s, "%3d %6d     %6u       %s\n", cws->cpu,
> -				   atomic_read(&cws->inserted), cws->executed,
> -				   tsk->comm);
> -			put_task_struct(tsk);
> +	if (!wfstat->func) {
> +		/* It is first dummy node, need to print workqueue info */
> +		pid = find_get_pid(cws->pid);
> +		if (pid) {
> +			tsk = get_pid_task(pid, PIDTYPE_PID);
> +			if (tsk) {
> +				seq_printf(s, "%3d %6d     %6u       %s:%d\n",
> +					   cws->cpu,
> +					   atomic_read(&cws->inserted),
> +					   cws->executed,
> +					   tsk->comm,
> +					   cws->pid);
> +				put_task_struct(tsk);
> +			}
> +			put_pid(pid);
>  		}
> -		put_pid(pid);
> +	} else {
> +		/* It is effect node, need to print workfunc info */
> +		int lastwf = list_is_last(&wfstat->list, &cws->workfunclist);
> +		seq_printf(s, "%3d %6d     %6u        %c-%pF\n",
> +			cws->cpu,
> +			atomic_read(&wfstat->inserted),
> +			wfstat->executed,
> +			lastwf ? '`' : '|',
> +			wfstat->func);
>  	}
>  
>  	return 0;
> @@ -205,7 +335,8 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
>  
>  static int workqueue_stat_headers(struct seq_file *s)
>  {
> -	seq_printf(s, "# CPU  INSERTED  EXECUTED   NAME\n");
> +	seq_printf(s, "# CPU  INSERTED  EXECUTED   TASKNAME:PID\n");
> +	seq_printf(s, "# |      |         |        `-WORKFUNC\n");
>  	seq_printf(s, "# |      |         |          |\n");
>  	return 0;
>  }
> -- 



Looks very nice, like the rest of the series.

