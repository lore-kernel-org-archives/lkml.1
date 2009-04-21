Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbZDUB5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbZDUB5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZDUB5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:57:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50160 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbZDUB5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:57:35 -0400
Message-ID: <49ED27EE.8080600@cn.fujitsu.com>
Date: Tue, 21 Apr 2009 09:57:02 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Re: [PATCH 4/4] trace_workqueue: Add worklet information
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49EC1943.8080606@cn.fujitsu.com> <49EC1F99.9030208@cn.fujitsu.com> <20090420113601.GC6081@nowhere>
In-Reply-To: <20090420113601.GC6081@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
...
>>  /* Destruction of a cpu workqueue thread */
>> @@ -115,12 +197,22 @@ static void probe_workqueue_destruction(struct task_struct *wq_thread)
>>  
>>  	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
>>  	list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
>> -							list) {
>> -		if (node->pid == wq_thread->pid) {
>> -			list_del(&node->list);
>> -			kfree(node);
>> -			goto found;
>> +				 list) {
>> +		struct workfunc_stats *wfstat, *wfstatnext;
>> +
>> +		if (node->pid != wq_thread->pid)
>> +			continue;
>> +
>> +		list_for_each_entry_safe(wfstat, wfstatnext,
>> +					 &node->workfunclist, list) {
>> +			list_del(&wfstat->list);
>> +			kfree(wfstat);
>>  		}
>> +
>> +		list_del(&node->list);
>> +		kfree(node);
> 
> 
> 
> Sidenote to me: I have to provide a way for a stat
> tracer to wait for the end of a pending statistic
> output session before the tracer comes to free any
> of its exposed entries. Otherwise we could end up
> with freed memory dereference.
> 
> May be waitqueue.
> 
> 
> 
>> +
>> +		goto found;
>>  	}
>>  
>>  	pr_debug("trace_workqueue: don't find workqueue to destroy\n");
>> @@ -129,17 +221,23 @@ found:
>>  
>>  }
>>  
>> -static struct cpu_workqueue_stats *workqueue_stat_start_cpu(int cpu)
>> +static struct workfunc_stats *workqueue_stat_start_cpu(int cpu)
>>  {
>>  	unsigned long flags;
>> -	struct cpu_workqueue_stats *ret = NULL;
>> -
>> +	struct workfunc_stats *ret = NULL;
>>  
>>  	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
>>  
>> -	if (!list_empty(&workqueue_cpu_stat(cpu)->list))
>> -		ret = list_entry(workqueue_cpu_stat(cpu)->list.next,
>> -				 struct cpu_workqueue_stats, list);
>> +	if (!list_empty(&workqueue_cpu_stat(cpu)->list)) {
>> +		struct cpu_workqueue_stats *cws;
>> +		cws = list_entry(workqueue_cpu_stat(cpu)->list.next,
>> +			struct cpu_workqueue_stats, list);
>> +		/*
>> +		 * cpu_workqueue_stats->workfunclist at least have a dummy node
>> +		 */
>> +		ret = list_entry(cws->workfunclist.next, struct workfunc_stats,
>> +			list);
>> +	}
>>  
>>  	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
>>  
>> @@ -161,43 +259,75 @@ static void *workqueue_stat_start(struct tracer_stat *trace)
>>  
>>  static void *workqueue_stat_next(void *prev, int idx)
>>  {
>> -	struct cpu_workqueue_stats *prev_cws = prev;
>> -	int cpu = prev_cws->cpu;
>> +	struct workfunc_stats *prev_wfstat = prev;
>> +	int cpu = prev_wfstat->parent->cpu;
>>  	unsigned long flags;
>>  	void *ret = NULL;
>>  
>>  	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
>> -	if (list_is_last(&prev_cws->list, &workqueue_cpu_stat(cpu)->list)) {
>> +
>> +	if (!list_is_last(&prev_wfstat->list,
>> +	    &prev_wfstat->parent->workfunclist)) {
>> +		ret = list_entry(prev_wfstat->list.next, struct workfunc_stats,
>> +			list);
>>  		spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
>> -		do {
>> -			cpu = cpumask_next(cpu, cpu_possible_mask);
>> -			if (cpu >= nr_cpu_ids)
>> -				return NULL;
>> -		} while (!(ret = workqueue_stat_start_cpu(cpu)));
>>  		return ret;
>>  	}
>> +
>> +	if (!list_is_last(&prev_wfstat->parent->list,
>> +	    &workqueue_cpu_stat(cpu)->list)) {
>> +		struct cpu_workqueue_stats *cws = list_entry(
>> +			prev_wfstat->parent->list.next,
>> +			struct cpu_workqueue_stats, list);
>> +		ret = list_entry(cws->workfunclist.next, struct workfunc_stats,
>> +			list);
>> +		spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
>> +		return ret;
>> +	}
>> +
>>  	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
>>  
>> -	return list_entry(prev_cws->list.next, struct cpu_workqueue_stats,
>> -			  list);
>> +	do {
>> +		cpu = cpumask_next(cpu, cpu_possible_mask);
>> +		if (cpu >= nr_cpu_ids)
> 
Hello, Frederic

Thanks for your review and advice.

> 
> The above test will take the total number of cpus as
> the last cpu number. This assumption may be false
> if the possible cpus are not contiguous.
> 
> Perhaps you'd better use:
> 
> 
> for_each_possible_cpu(cpu) {
> 	ret = workqueue_stat_start_cpu(cpu);
> 	if (ret)
> 		break;
> }
IMHO, this code is to choose first cpu who have workqueue.
But we need to choose next cpu, may be we need to:

int nextcpu;
for_each_possible_cpu(nextcpu) {
	/* bypass prev cpus */
	if (nextcpu <= cpu)
		continue;

	ret = workqueue_stat_start_cpu(cpu);
	if (ret) {
		break;
	}
}

By looking cpumask.h, for_each_possible_cpu(nextcpu) always make nextcpu
increase, but if not(in future?), above code is wrong.

Thanks
Zhaolei


> 
> After a quick look in cpumask.h it seems it will start
> from the cpu which follows the one you give in parameter.
> So it should be fine.
> 
> 
> 
>> +			return NULL;
>> +	} while (!(ret = workqueue_stat_start_cpu(cpu)));
>> +
>> +	return ret;
>>  }
>>  
>>  static int workqueue_stat_show(struct seq_file *s, void *p)
>>  {
>> -	struct cpu_workqueue_stats *cws = p;
>> +	struct workfunc_stats *wfstat = p;
>> +	struct cpu_workqueue_stats *cws = wfstat->parent;
>>  	struct pid *pid;
>>  	struct task_struct *tsk;
>>  
>> -	pid = find_get_pid(cws->pid);
>> -	if (pid) {
>> -		tsk = get_pid_task(pid, PIDTYPE_PID);
>> -		if (tsk) {
>> -			seq_printf(s, "%3d %6d     %6u       %s\n", cws->cpu,
>> -				   atomic_read(&cws->inserted), cws->executed,
>> -				   tsk->comm);
>> -			put_task_struct(tsk);
>> +	if (!wfstat->func) {
>> +		/* It is first dummy node, need to print workqueue info */
>> +		pid = find_get_pid(cws->pid);
>> +		if (pid) {
>> +			tsk = get_pid_task(pid, PIDTYPE_PID);
>> +			if (tsk) {
>> +				seq_printf(s, "%3d %6d     %6u       %s:%d\n",
>> +					   cws->cpu,
>> +					   atomic_read(&cws->inserted),
>> +					   cws->executed,
>> +					   tsk->comm,
>> +					   cws->pid);
>> +				put_task_struct(tsk);
>> +			}
>> +			put_pid(pid);
>>  		}
>> -		put_pid(pid);
>> +	} else {
>> +		/* It is effect node, need to print workfunc info */
>> +		int lastwf = list_is_last(&wfstat->list, &cws->workfunclist);
>> +		seq_printf(s, "%3d %6d     %6u        %c-%pF\n",
>> +			cws->cpu,
>> +			atomic_read(&wfstat->inserted),
>> +			wfstat->executed,
>> +			lastwf ? '`' : '|',
>> +			wfstat->func);
>>  	}
>>  
>>  	return 0;
>> @@ -205,7 +335,8 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
>>  
>>  static int workqueue_stat_headers(struct seq_file *s)
>>  {
>> -	seq_printf(s, "# CPU  INSERTED  EXECUTED   NAME\n");
>> +	seq_printf(s, "# CPU  INSERTED  EXECUTED   TASKNAME:PID\n");
>> +	seq_printf(s, "# |      |         |        `-WORKFUNC\n");
>>  	seq_printf(s, "# |      |         |          |\n");
>>  	return 0;
>>  }
>> -- 
> 
> 
> 
> Looks very nice, like the rest of the series.
> 
> 


