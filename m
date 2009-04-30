Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbZD3BP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbZD3BP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 21:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZD3BPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 21:15:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61995 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbZD3BPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 21:15:47 -0400
Message-ID: <49F8FB97.7050504@cn.fujitsu.com>
Date: Thu, 30 Apr 2009 09:15:03 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH 4/4] tracing/workqueue: Add max execution time	mesurement
 for per worklet
References: <49F6DFB5.2040901@cn.fujitsu.com> <49F6E10A.5050203@cn.fujitsu.com> <20090428171444.GC27584@redhat.com>
In-Reply-To: <20090428171444.GC27584@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> I have no idea how the code actually looks with these patches applied,
> so please don't take my words seriously, but
> 
> On 04/28, Zhaolei wrote:
>> @@ -24,6 +24,17 @@ struct workfunc_stats {
>>  	/* Protected by cpu workqueue lock */
>>  	unsigned int			inserted;
>>  	unsigned int			executed;
>> +
>> +	/*
>> +	 * save latest work_struct's pointer to use as identifier in
>> +	 * probe_worklet_complete, because we can't use work_struct->...
>> +	 * after worklet got executed
>> +	 */
>> +	void				*work;
> 
> Do we really need it ?
> 
>> @@ -143,6 +154,8 @@ found_wq:
>>  	list_for_each_entry(wfnode, &node->workfunclist, list)
>>  		if (wfnode->func == work->func) {
>>  			wfnode->executed++;
>> +			wfnode->start_time = trace_clock_global();
>> +			wfnode->work = work;
>>  			goto found_wf;
>>  		}
>>  	pr_debug("trace_workqueue: worklet not found\n");
>> @@ -153,6 +166,43 @@ end:
>>  	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
>>  }
>>
>> +/* Complete of a work */
>> +static void
>> +probe_worklet_complete(struct task_struct *wq_thread, void *work)
>> +{
>> +	int cpu = cpumask_first(&wq_thread->cpus_allowed);
>> +	struct cpu_workqueue_stats *node;
>> +	struct workfunc_stats *wfnode;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
>> +
>> +	list_for_each_entry(node, &workqueue_cpu_stat(cpu)->list, list)
>> +		if (node->task == wq_thread)
>> +			goto found_wq;
>> +	pr_debug("trace_workqueue: workqueue not found\n");
>> +	goto end;
>> +
>> +found_wq:
>> +	list_for_each_entry(wfnode, &node->workfunclist, list) {
>> +		u64 executed_time;
>> +
>> +		if (wfnode->work != work)
>> +			continue;
> 
> Perhaps we can add node->last_work (or whatever) instead? It should be
> recorded by the "entry" handler. In this case probe_worklet_complete()
> doesn't need to search for this work (and it doesn't need the argument).
> We know that wfnode == node->last_work.
Hello, Oleg

Sorry for reply late.

Thanks for review of this patch.
This is indeed a good idea, I will change to this way

Thanks
Zhaolei

> 
> Oleg.
> 
> 


