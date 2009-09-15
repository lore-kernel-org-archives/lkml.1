Return-Path: <linux-kernel-owner+w=401wt.eu-S934291AbZIOCEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934291AbZIOCEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 22:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934258AbZIOCD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 22:03:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62996 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934265AbZIOCD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 22:03:58 -0400
Message-ID: <4AAEF5DC.4070308@cn.fujitsu.com>
Date: Tue, 15 Sep 2009 10:03:08 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: + generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch
 added to -mm tree
References: <200907310030.n6V0Uqgw001644@imap1.linux-foundation.org>	 <1252616988.7205.102.camel@laptop>  <4AAA0001.2060703@cn.fujitsu.com>	 <1252696132.3756.21.camel@sbs-t61.sc.intel.com>	 <4AADEF2F.5080504@cn.fujitsu.com> <1252973802.2899.88.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1252973802.2899.88.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Suresh Siddha wrote:
> On Mon, 2009-09-14 at 00:22 -0700, Xiao Guangrong wrote:
>> Suresh Siddha wrote:
>>
>>>> CPU A call smp_call_function_many(wait=0) that want CPU B to call
>>>> a specific function, after smp_call_function_many() return, we let
>>>> CPU A offline immediately. Unfortunately, if CPU B receives this
>>>> IPI interrupt after CPU A down, it will crash like above description.
>>> How can cpu B receive the IPI interrupt after cpu A is down?
>>>
>>> As part of the cpu A going down, we first do the stop machine. i.e.,
>>> schedule the stop machine worker threads on each cpu. So, by the time
>>> all the worker threads on all the cpu's get scheduled and synchronized,
>>> ipi on B should get delivered.
>>>
>> Actually, those two examples have the same reason, that is how long
>> the destination CPU will receive the IPI interruption?
>>
>> If the stop machine threads can schedule in CPU B during the IPI
>> interruption delivering, It will occur those issue.
>>
>> I understand what you say but let me confuse is how we ensure it? The IPI
>> interruption is delivered over the APIC bus, It need several CPU instruction
>> cycle I guess, I also have read the spec of Intel 64 and IA-32, but not find
>> the answer, could you point out for me?
> 
> Xiao, There is quite a bit of time between the time a particular cpu
> sends a smp call function IPI (with wait == 0) and the time that cpu
> starts running the stop machine thread and the whole system proceeds
> with stop machine. With in this time, typically the smp call function
> destination will receive the ipi interrupt. But theoretically the
> problem you explain might happen.
> 

Yeah, though this case is very infrequent, but we can't avoid it.

>>From P4 onwards, interrupts are delivered over system bus and with NHM
> it is QPI. Also, the mechanism of scheduling the stop machine thread on
> a particular cpu involves resched IPI etc.
> 
> Nevertheless, Have you seen a real hang or system crash due to this? If
> so, on what platform?
> 
> Ideally, for xapic based platform, clear status of sender APIC ICR's
> delivery status indicates that the interrupt is registered at the
> receiver. for x2apic based platform, sending another interrupt will
> ensure that the previous interrupt was delivered.
> 
> If you have indeed seen a crash related to this, can you review and give
> the appended patch a try and see if it fixes the issue? If you agree
> with the fix, then I will send the patch with a detailed change log etc.
> 

I not seen this crash, just afraid it's unsafe while I review the code,
I try to generate this crash, but as you know, the race point is hard 
to control.

> Your current fix is not clean and not complete in my opinion (as calling
> interrupt handlers manually and not doing the callbacks etc might cause
> other side affects). Thanks.

It is not the last version and doing the callbacks in another patch,
see below URL please:
http://marc.info/?l=linux-mm-commits&m=124900028228350&w=2

I think we do better handle this in CPU down path in kernel/smp.c, It's very
safe and let people easy to understand.

> ---
> 
> diff --git a/include/linux/smp.h b/include/linux/smp.h
> index 9e3d8af..69ec2a9 100644
> --- a/include/linux/smp.h
> +++ b/include/linux/smp.h
> @@ -93,8 +93,9 @@ void generic_smp_call_function_single_interrupt(void);
>  void generic_smp_call_function_interrupt(void);
>  void ipi_call_lock(void);
>  void ipi_call_unlock(void);
>  void ipi_call_lock_irq(void);
>  void ipi_call_unlock_irq(void);
> +void quiesce_smp_call_functions(void);
>  #endif
>  
>  /*
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 8e21850..d13a888 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -479,6 +479,27 @@ int smp_call_function(void (*func)(void *), void *info, int wait)
>  }
>  EXPORT_SYMBOL(smp_call_function);
>  
> +void quiesce_smp_call_functions(void)
> +{
> +	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
> +	bool empty;
> +	unsigned long flags;
> +
> +	do {
> +		cpu_relax();
> +		spin_lock_irqsave(&q->lock, flags);
> +		empty = list_empty(&q->list);
> +		spin_unlock_irqrestore(&q->lock, flags);
> +	} while (!empty);
> +
> +	do {
> +		cpu_relax();
> +		spin_lock_irqsave(&call_function.lock, flags);
> +		empty = list_empty(&call_function.queue);
> +		spin_unlock_irqrestore(&call_function.lock, flags);
> +	} while (!empty);
> +}
> +

Why we need waiting CPU to handle this? It make no sense because the CPU is dying,
we can simple ignore the IPI request.

>  void ipi_call_lock(void)
>  {
>  	spin_lock(&call_function.lock);
> diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
> index 912823e..dd2d90f 100644
> --- a/kernel/stop_machine.c
> +++ b/kernel/stop_machine.c
> @@ -86,6 +86,9 @@ static void stop_cpu(struct work_struct *unused)
>  			curstate = state;
>  			switch (curstate) {
>  			case STOPMACHINE_DISABLE_IRQ:
> +#ifdef CONFIG_USE_GENERIC_SMP_HELPERS
> +				quiesce_smp_call_functions();
> +#endif

It seems ugly, we can define a noop function if CONFIG_USE_GENERIC_SMP_HELPERS is not
defined.

Another problem is that all CPU must call quiesce_smp_call_functions() here, but only
dying CPU need do it.

>  				local_irq_disable();
>  				hard_irq_disable();

It will cause another race, if CPU A send a IPI interruption after CPU B call
quiesce_smp_call_functions() and disable IRQ, it will case the same problem.
(in this time, CPU B is enter stop machine, but CPU A is not)

Thanks,
Xiao
