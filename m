Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbZIKGKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbZIKGKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 02:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbZIKGKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 02:10:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65017 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbZIKGKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 02:10:51 -0400
Message-ID: <4AA9E9B3.8060901@cn.fujitsu.com>
Date: Fri, 11 Sep 2009 14:09:55 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: peterz@infradead.org, rjw@sisk.pl, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] sched: fix cpu_down deadlock
References: <4AA0FEBF.7040104@gmail.com> <1252496510-11898-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1252496510-11898-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Jiri Slaby wrote:
>> Thanks, in the end I found it manually. Goddammit! It's an -mm thing:
>> cpu_hotplug-dont-affect-current-tasks-affinity.patch
>>
>> Well, I don't know why, but when the kthread overthere runs under
>> suspend conditions and gets rescheduled (e.g. by the might_sleep()
>> inside) it never returns. pick_next_task always returns the idle task
>> from the idle queue. State of the thread is TASK_RUNNING.
>>
>> Why is it not enqueued into some queue? I tried also
>> sched_setscheduler(current, FIFO, 99) in the thread itself. Unless I did
>> it wrong, it seems like a global scheduler problem?
> 
> Actually not, it definitely seems like a cpu_down problem.
>  
>> Ingo, any ideas?
> 
> Apparently not, but nevermind :). What about the patch below?
> 
> --
> 
> After a cpu is taken down in __stop_machine, the kcpu_thread still may be
> rescheduled to that cpu, but in fact the cpu is not running at that
> moment.
> 
> This causes kcpu_thread to never run again, because its enqueued on another
> runqueue, hence pick_next_task never selects it on the set of newly
> running cpus.
> 
> We do set_cpus_allowed_ptr in _cpu_down_thread, but cpu_active_mask is
> updated to not contain the cpu which goes down even after the thread finishes
> (and _cpu_down returns).
> 
> For me this triggers mostly while suspending a SMP machine with
> FAIR_GROUP_SCHED enabled and
> cpu_hotplug-dont-affect-current-tasks-affinity patch applied. The patch
> adds kthread to the cpu_down pipeline.
> 
> Fix this issue by eliminating the to-be-killed-cpu from active_cpu
> locally.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>  kernel/cpu.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index be9c5ad..17a3635 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -196,6 +196,14 @@ static int __ref _cpu_down_thread(void *_param)
>  	unsigned long mod = param->mod;
>  	unsigned int cpu = param->cpu;
>  	void *hcpu = (void *)(long)cpu;
> +	cpumask_var_t active_mask;
> +
> +	if (!alloc_cpumask_var(&active_mask, GFP_KERNEL))
> +		return -ENOMEM;
> +
> +	/* make sure we are not running on the cpu which goes down,
> +	   cpu_active_mask is altered even after we return! */
> +	cpumask_andnot(active_mask, cpu_active_mask, cpumask_of(cpu));
>  
>  	cpu_hotplug_begin();
>  	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
> @@ -211,7 +219,7 @@ static int __ref _cpu_down_thread(void *_param)
>  	}
>  
>  	/* Ensure that we are not runnable on dying cpu */
> -	set_cpus_allowed_ptr(current, cpu_active_mask);
> +	set_cpus_allowed_ptr(current, active_mask);
>  
>  	err = __stop_machine(take_cpu_down, param, cpumask_of(cpu));
>  	if (err) {
> @@ -237,9 +245,9 @@ static int __ref _cpu_down_thread(void *_param)
>  		BUG();
>  
>  	check_for_tasks(cpu);
> -
>  out_release:
>  	cpu_hotplug_done();
> +	free_cpumask_var(active_mask);
>  	if (!err) {
>  		if (raw_notifier_call_chain(&cpu_chain, CPU_POST_DEAD | mod,
>  					    hcpu) == NOTIFY_BAD)



Hi, Jiri Slaby

Does this bug occur when a cpu is being offlined or
when the system is being suspended?
Or Both?

Lai

