Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbZDMQRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbZDMQRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 12:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZDMQQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 12:16:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:51807 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbZDMQQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 12:16:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WVl7kA4tzlc/WGLCNsMjzwHWtzALNLp+9i77ccbdt2orVhUyfWIuY7lId22Sad3vBR
         s/ges/bK3dc3CUvjPtSlaL3H1OKvWWdrQAwZr03MbR4brWPqc3z2Bvj7MOZrQwRThu5b
         H0p5zhXkVfpyhmMsSpXRT+BQP40JNqP7tFpCw=
Date: Mon, 13 Apr 2009 18:16:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] ftrace: add max execution time mesurement to
	workqueue tracer
Message-ID: <20090413161649.GH5977@nowhere>
References: <20090413125653.6E01.A69D9226@jp.fujitsu.com> <20090413145105.6E07.A69D9226@jp.fujitsu.com> <20090413145254.6E0D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413145254.6E0D.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 02:53:45PM +0900, KOSAKI Motohiro wrote:
> Subject: [PATCH] ftrace: add max execution time mesurement to workqueue tracer
> 
> Too slow workqueue handler often introduce some trouble to system.
> Then, administrator want to know may handler execution time.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Zhaolei <zhaolei@cn.fujitsu.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/trace/trace_workqueue.c |   48 +++++++++++++++++++++++++++++++++++++----
>  1 file changed, 44 insertions(+), 4 deletions(-)
> 
> Index: b/kernel/trace/trace_workqueue.c
> ===================================================================
> --- a/kernel/trace/trace_workqueue.c	2009-04-13 13:23:59.000000000 +0900
> +++ b/kernel/trace/trace_workqueue.c	2009-04-13 13:59:51.000000000 +0900
> @@ -27,6 +27,10 @@ struct cpu_workqueue_stats {
>   *  on a single CPU.
>   */
>  	unsigned int		    executed;
> +
> +	/* store handler execution time */
> +	u64			    handler_start_time;
> +	u64			    max_executed_time;
>  };



Imho, this is the wrong place to instrument.
I explain my point of view below.



>  /* List of workqueue threads on one cpu */
> @@ -77,6 +81,7 @@ probe_workqueue_entry(struct task_struct
>  							list) {
>  		if (node->pid == wq_thread->pid) {
>  			node->executed++;
> +			node->handler_start_time = trace_clock_global();
>  			goto found;
>  		}
>  	}
> @@ -85,6 +90,29 @@ found:
>  	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
>  }
>  
> +static void probe_workqueue_exit(struct task_struct *wq_thread,
> +				 struct work_struct *work)
> +{
> +	int cpu = cpumask_first(&wq_thread->cpus_allowed);
> +	struct cpu_workqueue_stats *node, *next;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> +	list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
> +							list) {


Do you need the safe version here? You don't seem to remove any entry.

Sidenote: only the workqueue destruction handler might need it if I'm
not wrong.
I placed some of them in other places in this file because I misunderstood the
kernel list concepts in the past :)
(Heh, and probably still today).



> +		if (node->pid == wq_thread->pid) {
> +			u64 start = node->handler_start_time;
> +			u64 executed_time = trace_clock_global() - start;
> +
> +			if (node->max_executed_time < executed_time)
> +				node->max_executed_time = executed_time;
> +			goto found;
> +		}
> +	}
> +found:
> +	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
> +}
> +
>  /* Creation of a cpu workqueue thread */
>  static void probe_workqueue_creation(struct task_struct *wq_thread, int cpu)
>  {
> @@ -195,6 +223,9 @@ static int workqueue_stat_show(struct se
>  	int cpu = cws->cpu;
>  	struct pid *pid;
>  	struct task_struct *tsk;
> +	unsigned long long exec_time = ns2usecs(cws->max_executed_time);
> +	unsigned long exec_usec_rem = do_div(exec_time, USEC_PER_SEC);
> +	unsigned long exec_secs = (unsigned long)exec_time;
>  
>  	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
>  	if (&cws->list == workqueue_cpu_stat(cpu)->list.next)
> @@ -205,8 +236,11 @@ static int workqueue_stat_show(struct se
>  	if (pid) {
>  		tsk = get_pid_task(pid, PIDTYPE_PID);
>  		if (tsk) {
> -			seq_printf(s, "%3d %6d     %6u       %s\n", cws->cpu,
> +			seq_printf(s, "%3d %6d     %6u     %5lu.%06lu"
> +				   "  %s\n",
> +				   cws->cpu,
>  				   atomic_read(&cws->inserted), cws->executed,
> +				   exec_secs, exec_usec_rem,




You are measuring the latency from a workqueue thread point of view.
While I find the work latency measurement very interesting,
I think this patch does it in the wrong place. The _work_ latency point of view
seems to me much more rich as an information source.

There are several reasons for that.

Indeed this patch is useful for workqueues that receive always the same work
to perform so that you can find very easily the guilty worklet.
But the sense of this design is lost once we consider the workqueue threads
that receive random works. Of course the best example is events/%d
One will observe the max latency that happened on event/0 as an exemple but
he will only be able to feel a silent FUD because he has no way to find
which work caused this max latency.


Especially the events/%d latency measurement seems to me very important
because a single work from a random driver can propagate its latency
all over the system.

A single work that consumes too much cpu time, waits for long coming
events, sleeps too much, tries to take too often contended locks, or
whatever... such single work may delay all pending works in the queue
and the only max latency for a given workqueue is not helpful to find
these culprits.

Having this max latency snapshot per work and not per workqueue thread
would be useful for every kind of workqueue latency instrumentation:

- workqueues with single works
- workqueue with random works

A developer will also be able to measure its own worklet action and
find if it takes too much time, even if it isn't the worst worklet in
the workqueue to cause latencies.

The end result would be to have a descending latency sort of works
per cpu workqueue threads (or better: per workqueue group).

What do you think?

Frederic.



>  				   tsk->comm);
>  			put_task_struct(tsk);
>  		}
> @@ -218,8 +252,8 @@ static int workqueue_stat_show(struct se
>  
>  static int workqueue_stat_headers(struct seq_file *s)
>  {
> -	seq_printf(s, "# CPU  INSERTED  EXECUTED   NAME\n");
> -	seq_printf(s, "# |      |         |          |\n");
> +	seq_printf(s, "# CPU  INSERTED  EXECUTED     MAX_TIME  NAME\n");
> +	seq_printf(s, "# |      |         |           |         |\n");
>  	return 0;
>  }
>  
> @@ -259,10 +293,14 @@ int __init trace_workqueue_early_init(vo
>  	if (ret)
>  		goto no_insertion;
>  
> -	ret = register_trace_workqueue_creation(probe_workqueue_creation);
> +	ret = register_trace_workqueue_handler_exit(probe_workqueue_exit);
>  	if (ret)
>  		goto no_handler_entry;
>  
> +	ret = register_trace_workqueue_creation(probe_workqueue_creation);
> +	if (ret)
> +		goto no_handler_exit;
> +
>  	ret = register_trace_workqueue_destruction(probe_workqueue_destruction);
>  	if (ret)
>  		goto no_creation;
> @@ -276,6 +314,8 @@ int __init trace_workqueue_early_init(vo
>  
>  no_creation:
>  	unregister_trace_workqueue_creation(probe_workqueue_creation);
> +no_handler_exit:
> +	unregister_trace_workqueue_handler_exit(probe_workqueue_exit);
>  no_handler_entry:
>  	unregister_trace_workqueue_handler_entry(probe_workqueue_entry);
>  no_insertion:
> 
> 

