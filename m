Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbYCJUCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbYCJUCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 16:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYCJUCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 16:02:41 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:42306 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbYCJUCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 16:02:40 -0400
Message-Id: <47D593A5.5060906@ct.jp.nec.com>
Date: Mon, 10 Mar 2008 13:01:41 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, hpj@urpla.net
Subject: Re: [PATCH] sched: fix race in schedule
References: <47D57770.50909@ct.jp.nec.com> <1205174197.8514.159.camel@twins>
In-Reply-To: <1205174197.8514.159.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-03-10 at 11:01 -0700, Hiroshi Shimamoto wrote:
>> Hi Ingo,
>>
>> I found a race condition in scheduler.
>> The first report is the below;
>> http://lkml.org/lkml/2008/2/26/459
>>
>> It took a bit long time to investigate and I couldn't have much time last week.
>> It is hard to reproduce but -rt is little easier because it has preemptible
>> spin lock and rcu.
>>
>> Could you please check the scenario and the patch.
>> It will be needed for the stable, too.
>>
>> ---
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> There is a race condition between schedule() and some dequeue/enqueue
>> functions; rt_mutex_setprio(), __setscheduler() and sched_move_task().
>>
>> When scheduling to idle, idle_balance() is called to pull tasks from
>> other busy processor. It might drop the rq lock.
>> It means that those 3 functions encounter on_rq=0 and running=1.
>> The current task should be put when running.
>>
>> Here is a possible scenario;
>>    CPU0                               CPU1
>>     |                              schedule()
>>     |                              ->deactivate_task()
>>     |                              ->idle_balance()
>>     |                              -->load_balance_newidle()
>> rt_mutex_setprio()                     |
>>     |                              --->double_lock_balance()
>>     *get lock                          *rel lock
>>     * on_rq=0, ruuning=1               |
>>     * sched_class is changed           |
>>     *rel lock                          *get lock
>>     :                                  |
>>                                        :
>>                                    ->put_prev_task_rt()
>>                                    ->pick_next_task_fair()
>>                                        => panic
>>
>> The current process of CPU1(P1) is scheduling. Deactivated P1,
>> and the scheduler looks for another process on other CPU's runqueue
>> because CPU1 will be idle. idle_balance(), load_balance_newidle()
>> and double_lock_balance() are called and double_lock_balance() could
>> drop the rq lock. On the other hand, CPU0 is trying to boost the
>> priority of P1. The result of boosting only P1's prio and sched_class
>> are changed to RT. The sched entities of P1 and P1's group are never
>> put. It makes cfs_rq invalid, because the cfs_rq has curr and no leaf,
>> but pick_next_task_fair() is called, then the kernel panics.
> 
> Very nice catch, this had me puzzled for a while. I'm not quite sure I
> fully understand. Could you explain why the below isn't sufficient?

thanks, your patch looks nice to me.
I had focused setprio, on_rq=0 and running=1 situation, it makes me to
fix these functions.
But one point, I've just noticed. I'm not sure on same situation against
sched_rt. I think the pre_schedule() of rt has chance to drop rq lock.
Is it OK?

> 
> ---
> diff --git a/kernel/sched.c b/kernel/sched.c
> index a0c79e9..ebd9fc5 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4067,10 +4067,11 @@ need_resched_nonpreemptible:
>  		prev->sched_class->pre_schedule(rq, prev);
>  #endif
>  
> +	prev->sched_class->put_prev_task(rq, prev);
> +
>  	if (unlikely(!rq->nr_running))
>  		idle_balance(cpu, rq);
>  
> -	prev->sched_class->put_prev_task(rq, prev);
>  	next = pick_next_task(rq, prev);
>  
>  	sched_info_switch(prev, next);
> 
> 
