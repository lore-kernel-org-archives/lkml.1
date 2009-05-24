Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZEXVah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZEXVah (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 17:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbZEXVa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 17:30:29 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:33080 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZEXVa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 17:30:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Si0wyTxuywC0VPLuMJhOvByVvOidYLzBqHcAOz7Ch8+aDVkTeMR9aGJYtffTj5YCbH
         O/TfuvTxpoAlsjSYNNvF3ES83c8nzV3CWx9MzxawPNZH1fGRVgbT8yNcyXmYOMphihsi
         T1IaSvvkLL1pskM2iICBBDRfK3/eCN+0AVuWY=
Date: Sun, 24 May 2009 23:30:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/workqueue: Get rid of searching last
	executed worklet in probe_worklet_complete()
Message-ID: <20090524213028.GE6471@nowhere>
References: <4A153345.3040905@cn.fujitsu.com> <4A1610B6.7010203@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1610B6.7010203@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 10:40:54AM +0800, Zhaolei wrote:
> We don't need search workqueue's worklet list for worklet which was latest
> executed, instead, we can use a pointer in cpu_workqueue_stats to remember
> which worklet was just executed.
> 
> Thanks Oleg for pointing it out.
> 
> Changelog:
> v1->v2: Oleg pointed out that if searching executed workfunc_stats failed
> in probe_worklet_execute(), for example, workfunc_stats's memory allocation
> failed previously, cpu_workqueue_stats->last_workfunc is not set to correct
> value, and it will cause wrong accessing in probe_worklet_complete().
> This problem is fixed in v2.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> Reported-by: Oleg Nesterov <oleg@redhat.com>

Looks good, thanks!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Frederic.


> ---
>  kernel/trace/trace_workqueue.c |   39 ++++++++++++++++-----------------------
>  1 files changed, 16 insertions(+), 23 deletions(-)
> 
> diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
> index c67be60..740de3b 100644
> --- a/kernel/trace/trace_workqueue.c
> +++ b/kernel/trace/trace_workqueue.c
> @@ -25,13 +25,6 @@ struct workfunc_stats {
>  	unsigned int			inserted;
>  	unsigned int			executed;
>  
> -	/*
> -	 * save latest work_struct's pointer to use as identifier in
> -	 * probe_worklet_complete, because we can't use work_struct->...
> -	 * after worklet got executed
> -	 */
> -	void				*work;
> -
>  	/* save execution time temporarily for calculate executed time */
>  	u64				start_time;
>  	u64				max_executed_time;
> @@ -46,10 +39,17 @@ struct cpu_workqueue_stats {
>  	/* Protected by cpu workqueue lock */
>  	unsigned int		inserted;
>  	unsigned int		executed;
> +
>  	/* list of struct workfunc_stats in this workqueue */
>  	struct list_head	workfunclist;
>  
>  	/*
> +	 * pointer to last executed worklet's workfunc_stats in this workqueue,
> +	 * used by probe_worklet_complete()
> +	 */
> +	struct workfunc_stats *last_workfunc;
> +
> +	/*
>  	 * the task maybe destroyed when we read stat file
>  	 * we define it to void * because we only use it as a identifier
>  	 */
> @@ -163,9 +163,10 @@ found_wq:
>  		if (wfnode->func == work->func) {
>  			wfnode->executed++;
>  			wfnode->start_time = trace_clock_global();
> -			wfnode->work = work;
> +			node->last_workfunc = wfnode;
>  			goto found_wf;
>  		}
> +	node->last_workfunc = NULL;
>  	pr_debug("trace_workqueue: worklet not found\n");
>  	goto end;
>  
> @@ -180,7 +181,7 @@ probe_worklet_complete(struct task_struct *wq_thread, void *work)
>  {
>  	int cpu = cpumask_first(&wq_thread->cpus_allowed);
>  	struct cpu_workqueue_stats *node;
> -	struct workfunc_stats *wfnode;
> +	u64 executed_time;
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> @@ -192,22 +193,14 @@ probe_worklet_complete(struct task_struct *wq_thread, void *work)
>  	goto end;
>  
>  found_wq:
> -	list_for_each_entry(wfnode, &node->workfunclist, list) {
> -		u64 executed_time;
> +	if (!node->last_workfunc)
> +		goto end;
>  
> -		if (wfnode->work != work)
> -			continue;
> +	executed_time = trace_clock_global() - node->last_workfunc->start_time;
> +	node->last_workfunc->total_time += executed_time;
> +	if (executed_time > node->last_workfunc->max_executed_time)
> +		node->last_workfunc->max_executed_time = executed_time;
>  
> -		executed_time = trace_clock_global() - wfnode->start_time;
> -		wfnode->total_time += executed_time;
> -		if (executed_time > wfnode->max_executed_time)
> -			wfnode->max_executed_time = executed_time;
> -		goto found_wf;
> -	}
> -	pr_debug("trace_workqueue: worklet not found\n");
> -	goto end;
> -
> -found_wf:
>  end:
>  	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
>  }
> -- 
> 1.5.5.3
> 
> 

