Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbYGRKZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbYGRKZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 06:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbYGRKZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 06:25:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43976 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbYGRKZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 06:25:08 -0400
Date: Fri, 18 Jul 2008 12:24:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eric miao <eric.y.miao@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jack Ren <jack.ren@marvell.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] sched: do not stop ticks when cpu is not idle
Message-ID: <20080718102446.GV6875@elte.hu>
References: <f17812d70807172341u92270fdvc80e72cc5599c56f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d70807172341u92270fdvc80e72cc5599c56f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* eric miao <eric.y.miao@gmail.com> wrote:

> Issue: the sched tick would be stopped in some race conditions.

> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4027,7 +4027,8 @@ need_resched_nonpreemptible:
>  		rq->nr_switches++;
>  		rq->curr = next;
>  		++*switch_count;
> -
> +		if (rq->curr != rq->idle)
> +			tick_nohz_restart_sched_tick();
>  		context_switch(rq, prev, next); /* unlocks the rq */

applied to tip/sched/urgent, thanks Eric.

Thomas, Peter, Dmitry, do you concur with the analysis? (commit below) 

It looks a bit ugly to me in the middle of schedule() - is there no wait 
to solve this within kernel/time/*.c ?

	Ingo

-------------->
commit ca1b5a8a9abb3db57562a838f41cdba842f13fe8
Author: eric miao <eric.y.miao@gmail.com>
Date:   Fri Jul 18 14:41:29 2008 +0800

    sched: do not stop ticks when cpu is not idle
    
    Issue: the sched tick would be stopped in some race conditions.
    
    One of issues caused by that is:
    
    Since there is no timer ticks any more from then, the jiffies update will be
    up to other interrupt to happen. The jiffies will not be updated for a long
    time, until next interrupt happens.  That will cause APIs like
    wait_for_completion_timeout(&complete, timeout) to return timeout by mistake,
    since it is using a old jiffies as start time.
    
    Please see comments (1)~(6) inline for how the ticks are stopped
    by mistake when cpu is not idle:
    
    void cpu_idle(void)
    {
    ...
    	while (1) {
    		void (*idle)(void) = pm_idle;
    		if (!idle)
    			idle = default_idle;
    		leds_event(led_idle_start);
    		tick_nohz_stop_sched_tick();
    		while (!need_resched())
    			idle();
    		leds_event(led_idle_end);
    		tick_nohz_restart_sched_tick();
    			(1) ticks are retarted before switch to other tasks
    		preempt_enable_no_resched();
    		schedule();
    		preempt_disable();
    	}
    }
    
    asmlinkage void __sched schedule(void)
    {
    	...
    	...
    need_resched:
    	(6) the idle task will be scheduled out again and switch to next task,
    	 with ticks stopped in (5). So the next task will be running with tick stopped.
    	preempt_disable();
    	cpu = smp_processor_id();
    	rq = cpu_rq(cpu);
    	rcu_qsctr_inc(cpu);
    	prev = rq->curr;
    	switch_count = &prev->nivcsw;
    
    	release_kernel_lock(prev);
    need_resched_nonpreemptible:
    
    	schedule_debug(prev);
    
    	hrtick_clear(rq);
    
    	/*
    	 * Do the rq-clock update outside the rq lock:
    	 */
    	local_irq_disable();
    	__update_rq_clock(rq);
    	spin_lock(&rq->lock);
    	clear_tsk_need_resched(prev); (2) resched flag is clear from idle task
    
    	....
    
    		context_switch(rq, prev, next); /* unlocks the rq */
    		(3) IRQ will be enabled at end of context_swtich( ).
    	...
    	preempt_enable_no_resched();
    	if (unlikely(test_thread_flag(TIF_NEED_RESCHED)))
    			(4) the idle task is scheduled back. If an interrupt happen here,
    				 The irq_exit( ) will be called at end of the irq handler.
    		goto need_resched;
    }
    
    void irq_exit(void)
    {
    ...
    	/* Make sure that timer wheel updates are propagated */
    	if (!in_interrupt() && idle_cpu(smp_processor_id()) && !need_resched())
    		tick_nohz_stop_sched_tick();
    		(5) The ticks will be stopped again since current
    			task is idle task and its resched flag is clear in (2).
    	rcu_irq_exit();
    	preempt_enable_no_resched();
    }
    
    Signed-off-by: Jack Ren <jack.ren@marvell.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1ee18db..e0e0162 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4446,7 +4446,8 @@ need_resched_nonpreemptible:
 		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;
-
+		if (rq->curr != rq->idle)
+			tick_nohz_restart_sched_tick();
 		context_switch(rq, prev, next); /* unlocks the rq */
 		/*
 		 * the context switch might have flipped the stack from under
