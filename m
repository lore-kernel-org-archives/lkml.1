Return-Path: <linux-kernel-owner+w=401wt.eu-S1758914AbXH3JwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914AbXH3JwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 05:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbXH3JwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 05:52:15 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:30390 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbXH3JwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 05:52:14 -0400
Message-ID: <46D69286.4060602@openvz.org>
Date: Thu, 30 Aug 2007 13:48:54 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Emelianov <xemul@openvz.org>
Subject: Re: [PATCH 2.6.21] Return available first timeslice to the	creator,
 not parent
References: <m3fy21qx4p.fsf@dhcp-lab-143.englab.brq.redhat.com> <1188465056.6112.30.camel@twins>
In-Reply-To: <1188465056.6112.30.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2007-08-30 at 09:50 +0200, Vitaly Mayatskikh wrote:
>> Short-living process returns its timeslice to the parent, this affects
>> process that creates a lot of such short-living threads, because its
>> not a parent for new threads. Patch fixes this issue and doesn't break
>> kabi as does the patch from reporter: http://lkml.org/lkml/2007/4/7/21
> 
>> plain text document attachment (2.6.21-timeslice.patch), "proposed
>> patch"
>> diff -up -bB ./include/linux/sched.h.orig ./include/linux/sched.h
>> --- ./include/linux/sched.h.orig	2007-08-21 09:20:22.000000000 +0200
>> +++ ./include/linux/sched.h	2007-08-27 10:14:06.000000000 +0200
>> @@ -827,7 +827,9 @@ struct task_struct {
>>  
>>  	unsigned long policy;
>>  	cpumask_t cpus_allowed;
>> -	unsigned int time_slice, first_time_slice;
>> +	unsigned int time_slice;
>> +	/* Pid of creator */
>> +	unsigned int cpid;
> 
> might as well make that pid_t, or maybe even a struct pid* and keep a
> reference on it - the struct pid police might have an opinion.

Store the struct pid reference itself. In any case you make
the find_get_pid() later to obtain the struct pid itself. This
will even make the sched_exit() work faster.

>>  #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
>>  	struct sched_info sched_info;
>> diff -up -bB ./kernel/sched.c.orig ./kernel/sched.c
>> --- ./kernel/sched.c.orig	2007-08-21 09:20:22.000000000 +0200
>> +++ ./kernel/sched.c	2007-08-27 10:18:44.000000000 +0200
>> @@ -1626,9 +1626,9 @@ void fastcall sched_fork(struct task_str
>>  	p->time_slice = (current->time_slice + 1) >> 1;
>>  	/*
>>  	 * The remainder of the first timeslice might be recovered by
>> -	 * the parent if the child exits early enough.
>> +	 * the creator (not parent!) if the child exits early enough.
>>  	 */
>> -	p->first_time_slice = 1;
>> +	p->cpid = current->pid;
>>  	current->time_slice >>= 1;
>>  	p->timestamp = sched_clock();
>>  	if (unlikely(!current->time_slice)) {
>> @@ -1728,33 +1728,46 @@ void fastcall wake_up_new_task(struct ta
>>  
>>  /*
>>   * Potentially available exiting-child timeslices are
>> - * retrieved here - this way the parent does not get
>> + * retrieved here - this way the creator does not get
>>   * penalized for creating too many threads.
>>   *
>>   * (this cannot be used to 'generate' timeslices
>>   * artificially, because any timeslice recovered here
>> - * was given away by the parent in the first place.)
>> + * was given away by the creator in the first place.)
>>   */
>>  void fastcall sched_exit(struct task_struct *p)
>>  {
>>  	unsigned long flags;
>>  	struct rq *rq;
>> -
>> +	struct task_struct* creator = NULL;
>>  	/*
>>  	 * If the child was a (relative-) CPU hog then decrease
>> -	 * the sleep_avg of the parent as well.
>> +	 * the sleep_avg of the creator as well.
>>  	 */
>> -	rq = task_rq_lock(p->parent, &flags);
>> -	if (p->first_time_slice && task_cpu(p) == task_cpu(p->parent)) {
>> -		p->parent->time_slice += p->time_slice;
>> -		if (unlikely(p->parent->time_slice > task_timeslice(p)))
>> -			p->parent->time_slice = task_timeslice(p);
>> +	if (p->cpid) {
>> +		struct pid *pid = find_get_pid((pid_t)p->cpid);
>> +		if (pid) {
>> +			creator = get_pid_task(pid, PIDTYPE_PID);
>> +			put_pid(pid);
>>  	}
>> -	if (p->sleep_avg < p->parent->sleep_avg)
>> -		p->parent->sleep_avg = p->parent->sleep_avg /
>> +
>> +		if (creator) {
>> +			if (task_cpu(p) == task_cpu(creator)) {
>> +				rq = task_rq_lock(creator, &flags);
>> +
>> +				creator->time_slice += p->time_slice;
>> +				if (unlikely(creator->time_slice > task_timeslice(p)))
>> +					creator->time_slice = task_timeslice(p);
>> +
>> +				if (p->sleep_avg < creator->sleep_avg)
>> +					creator->sleep_avg = creator->sleep_avg /
>>  		(EXIT_WEIGHT + 1) * EXIT_WEIGHT + p->sleep_avg /
>>  		(EXIT_WEIGHT + 1);
>>  	task_rq_unlock(rq, &flags);
>> +			}
>> +			put_task_struct(creator);
>> +		}
>> +	}
>>  }
>>  
>>  /**
>> @@ -3153,7 +3166,7 @@ static void task_running_tick(struct rq 
>>  		 */
>>  		if ((p->policy == SCHED_RR) && !--p->time_slice) {
>>  			p->time_slice = task_timeslice(p);
>> -			p->first_time_slice = 0;
>> +			p->cpid = 0;
>>  			set_tsk_need_resched(p);
>>  
>>  			/* put it at the end of the queue: */
>> @@ -3166,7 +3179,7 @@ static void task_running_tick(struct rq 
>>  		set_tsk_need_resched(p);
>>  		p->prio = effective_prio(p);
>>  		p->time_slice = task_timeslice(p);
>> -		p->first_time_slice = 0;
>> +		p->cpid = 0;
>>  
>>  		if (!rq->expired_timestamp)
>>  			rq->expired_timestamp = jiffies;
> 
> Other than that it looks good, pretty much what I suggested :-)
> 
> 

