Return-Path: <linux-kernel-owner+w=401wt.eu-S1759664AbYCWLAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664AbYCWLAx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 07:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbYCWLAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 07:00:43 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:41845 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbYCWLAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 07:00:42 -0400
Message-ID: <47E63851.7000702@frugalware.org>
Date: Sun, 23 Mar 2008 12:00:33 +0100
From: Gabriel C <crazy@frugalware.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Gabriel C <nix.or.die@googlemail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, andi-bz@firstfloor.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
References: <200803170018.52663.rjw@sisk.pl> <alpine.LFD.1.00.0803171716130.3781@apollo.tec.linutronix.de> <47DEB65A.9080907@googlemail.com> <47DF3E8B.6040502@googlemail.com> <47E3D322.1090902@googlemail.com> <alpine.LFD.1.00.0803211720340.3781@apollo.tec.linutronix.de> <47E3E66F.9040006@frugalware.org> <47E3FA4F.9060509@frugalware.org> <alpine.LFD.1.00.0803211944250.3781@apollo.tec.linutronix.de> <47E40B1C.30407@frugalware.org> <47E420C5.1050407@frugalware.org> <alpine.LFD.1.00.0803212208300.3781@apollo.tec.linutronix.de> <47E42FAB.6000906@frugalware.org> <alpine.LFD.1.00.0803212302390.3781@apollo.tec.linutronix.de> <alpine.LFD.1.00.0803220847020.3781@apollo.tec.linutronix.de> <47E50AF9.5070801@frugalware.org> <alpine.LFD.1.00.0803221441370.3781@apollo.tec.linutronix.de> <47E5221B.5040900@frugalware.org> <alpine.LFD.1.00.0803221730560.3781@apollo.tec.linutronix.de> <alpine.LFD.1.00.0803222113541.3781@apollo.tec.linutronix.de> <47E58B06.8020905@frugalware.org>
In-Reply-To: <47E58B06.8020905@frugalware.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Thomas Gleixner wrote:
>> On Sat, 22 Mar 2008, Thomas Gleixner wrote:
>>> On Sat, 22 Mar 2008, Gabriel C wrote:
>>>> With this one TSC is fine but now I get a warning on boot :
>>> Good. It confirms my assumptions about the root cause.
>>>
>>>> [    0.041037] ------------[ cut here ]------------
>>>> [    0.041052] WARNING: at arch/x86/kernel/smp_32.c:562 native_smp_call_function_mask+0x23/0x11e()
>>> Grr. I'll work out a solution for that one.
>> Gabriel,
>>
>> I'm happy to rack your nerves some more.
> 
> No worries :) 
> 
>> After discussing the issue with Peter and Ingo the following solution
>> seems to be the one which is the least intrusive. 
>>
>> Can you please give it a test ride ?
> 
> Done , git head + Andi's patch + this version of your patch does work here.
> 
> Also time-warp-test is just fine and everything else seems to work.

Also I've tested with my other motherboard and is fine too :)

Feel free to add my Tested-by when you push this patch.

> 
> 
>> ---
>>  include/linux/sched.h |    6 ++++++
>>  kernel/sched.c        |   42 ++++++++++++++++++++++++++++++++++++++++++
>>  kernel/timer.c        |   10 +++++++++-
>>  3 files changed, 57 insertions(+), 1 deletion(-)
>>
>> Index: linux-2.6/include/linux/sched.h
>> ===================================================================
>> --- linux-2.6.orig/include/linux/sched.h
>> +++ linux-2.6/include/linux/sched.h
>> @@ -1541,6 +1541,12 @@ static inline void idle_task_exit(void) 
>>  
>>  extern void sched_idle_next(void);
>>  
>> +#ifdef CONFIG_NO_HZ
>> +extern void wake_up_idle_cpu(int cpu);
>> +#else
>> +static inline void wake_up_idle_cpu(int cpu) { }
>> +#endif
>> +
>>  #ifdef CONFIG_SCHED_DEBUG
>>  extern unsigned int sysctl_sched_latency;
>>  extern unsigned int sysctl_sched_min_granularity;
>> Index: linux-2.6/kernel/sched.c
>> ===================================================================
>> --- linux-2.6.orig/kernel/sched.c
>> +++ linux-2.6/kernel/sched.c
>> @@ -848,6 +848,48 @@ static inline void resched_task(struct t
>>  	__resched_task(p, TIF_NEED_RESCHED);
>>  }
>>  
>> +#ifdef CONFIG_NO_HZ
>> +/*
>> + * When add_timer_on() enqueues a timer into the timer wheel of an
>> + * idle CPU then this timer might expire before the next timer event
>> + * which is scheduled to wake up that CPU. In case of a completely
>> + * idle system the next event might even be infinite time into the
>> + * future. wake_up_idle_cpu() ensures that the CPU is woken up and
>> + * leaves the inner idle loop so the newle added timer is taken into
>> + * account when the CPU goes back to idle and evaluates the timer
>> + * wheel for the next timer event.
>> + */
>> +void wake_up_idle_cpu(int cpu)
>> +{
>> +	struct rq *rq = cpu_rq(cpu);
>> +
>> +	if (cpu == smp_processor_id())
>> +		return;
>> +
>> +	/*
>> +	 * This is safe, as this function is called with the timer
>> +	 * wheel base lock of (cpu) held. When the CPU is on the way
>> +	 * to idle and has not yet set rq->curr to idle then it will
>> +	 * be serialized on the timer wheel base lock and take the new
>> +	 * timer into account automatically.
>> +	 */
>> +	if (rq->curr != rq->idle)
>> +		return;
>> +
>> +	/*
>> +	 * We can set TIF_RESCHED on the idle task of the other CPU
>> +	 * lockless. The worst case is that the other CPU runs the
>> +	 * idle task through an additional NOOP schedule()
>> +	 */
>> +	set_tsk_thread_flag(rq->idle, TIF_NEED_RESCHED);
>> +
>> +	/* NEED_RESCHED must be visible before we test polling */
>> +	smp_mb();
>> +	if (!tsk_is_polling(rq->idle))
>> +		smp_send_reschedule(cpu);
>> +}
>> +#endif
>> +
>>  #ifdef CONFIG_SCHED_HRTICK
>>  /*
>>   * Use HR-timers to deliver accurate preemption points.
>> Index: linux-2.6/kernel/timer.c
>> ===================================================================
>> --- linux-2.6.orig/kernel/timer.c
>> +++ linux-2.6/kernel/timer.c
>> @@ -451,10 +451,18 @@ void add_timer_on(struct timer_list *tim
>>  	spin_lock_irqsave(&base->lock, flags);
>>  	timer_set_base(timer, base);
>>  	internal_add_timer(base, timer);
>> +	/*
>> +	 * Check whether the other CPU is idle and needs to be
>> +	 * triggered to reevaluate the timer wheel when nohz is
>> +	 * active. We are protected against the other CPU fiddling
>> +	 * with the timer by holding the timer base lock. This also
>> +	 * makes sure that a CPU on the way to idle can not evaluate
>> +	 * the timer wheel.
>> +	 */
>> +	wake_up_idle_cpu(cpu);
>>  	spin_unlock_irqrestore(&base->lock, flags);
>>  }
>>  
>> -
>>  /**
>>   * mod_timer - modify a timer's timeout
>>   * @timer: the timer to be modified
> 
