Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab0BWBtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:49:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54908 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab0BWBtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:49:20 -0500
Message-ID: <4B833404.2010807@cn.fujitsu.com>
Date: Tue, 23 Feb 2010 09:48:52 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [regression] cpuset,mm: update tasks' mems_allowed in time (58568d2)
References: <20100218134921.GF9738@laptop> <alpine.DEB.2.00.1002181302430.13707@chino.kir.corp.google.com> <20100219033126.GI9738@laptop> <alpine.DEB.2.00.1002190143040.6293@chino.kir.corp.google.com> <4B827043.3060305@cn.fujitsu.com> <20100222120605.GU9738@laptop>
In-Reply-To: <20100222120605.GU9738@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2010-2-22 20:06, Nick Piggin wrote: 
>>>>> guarantee_online_cpus() truly does require callback_mutex, the 
>>>>> cgroup_scan_tasks() iterator locking can protect changes in the cgroup 
>>>>> hierarchy but it doesn't protect a store to cs->cpus_allowed or for 
>>>>> hotplug.
>>>>
>>>> Right, but the callback_mutex was being removed by this patch.
>>>>
>>>
>>> I was making the case for it to be readded :)
>>
>> But cgroup_mutex is held when someone changes cs->cpus_allowed or doing hotplug,
>> so I think callback_mutex is not necessary in this case.
> 
> So long as that's done consistently (and we should update the comments
> too).

I will update the comments.

>> ---
>> diff --git a/init/main.c b/init/main.c
>> index 4cb47a1..512ba15 100644
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -846,7 +846,7 @@ static int __init kernel_init(void * unused)
>>  	/*
>>  	 * init can allocate pages on any node
>>  	 */
>> -	set_mems_allowed(node_possible_map);
>> +	set_mems_allowed(node_states[N_HIGH_MEMORY]);
>>  	/*
>>  	 * init can run on any cpu.
>>  	 */
>> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
>> index ba401fa..e29b440 100644
>> --- a/kernel/cpuset.c
>> +++ b/kernel/cpuset.c
>> @@ -935,10 +935,12 @@ static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
>>  	struct task_struct *tsk = current;
>>  
>>  	tsk->mems_allowed = *to;
>> +	wmb();
>>  
>>  	do_migrate_pages(mm, from, to, MPOL_MF_MOVE_ALL);
>>  
>>  	guarantee_online_mems(task_cs(tsk),&tsk->mems_allowed);
>> +	wmb();
>>  }
>>  
>>  /*
> 
> You always need to comment barriers (and use smp_ variants unless you're
> doing mmio).

It's my mistake. 
I'll remake a new patch and change it.

Thanks.
Miao

> 
> 
>> @@ -1391,11 +1393,10 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
>>  
>>  	if (cs == &top_cpuset) {
>>  		cpumask_copy(cpus_attach, cpu_possible_mask);
>> -		to = node_possible_map;
>>  	} else {
>>  		guarantee_online_cpus(cs, cpus_attach);
>> -		guarantee_online_mems(cs, &to);
>>  	}
>> +	guarantee_online_mems(cs, &to);
>>  
>>  	/* do per-task migration stuff possibly for each in the threadgroup */
>>  	cpuset_attach_task(tsk, &to, cs);
>> @@ -2090,15 +2091,19 @@ static int cpuset_track_online_cpus(struct notifier_block *unused_nb,
>>  static int cpuset_track_online_nodes(struct notifier_block *self,
>>  				unsigned long action, void *arg)
>>  {
>> +	nodemask_t oldmems;
>> +
>>  	cgroup_lock();
>>  	switch (action) {
>>  	case MEM_ONLINE:
>> -	case MEM_OFFLINE:
>> +		oldmems = top_cpuset.mems_allowed;
>>  		mutex_lock(&callback_mutex);
>>  		top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
>>  		mutex_unlock(&callback_mutex);
>> -		if (action == MEM_OFFLINE)
>> -			scan_for_empty_cpusets(&top_cpuset);
>> +		update_tasks_nodemask(&top_cpuset, &oldmems, NULL);
>> +		break;
>> +	case MEM_OFFLINE:
>> +		scan_for_empty_cpusets(&top_cpuset);
>>  		break;
>>  	default:
>>  		break;
>> diff --git a/kernel/kthread.c b/kernel/kthread.c
>> index fbb6222..84c7f99 100644
>> --- a/kernel/kthread.c
>> +++ b/kernel/kthread.c
>> @@ -219,7 +219,7 @@ int kthreadd(void *unused)
>>  	set_task_comm(tsk, "kthreadd");
>>  	ignore_signals(tsk);
>>  	set_cpus_allowed_ptr(tsk, cpu_all_mask);
>> -	set_mems_allowed(node_possible_map);
>> +	set_mems_allowed(node_states[N_HIGH_MEMORY]);
>>  
>>  	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
>>  
> 
> 
> 


