Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbYGRLVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbYGRLVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbYGRLVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:21:14 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:8102 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbYGRLVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:21:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pNhnctWmkjvxQ9+G8scqSLVAPdTswseloG76wknukQu2f/tHZTyjRkSe70PLZAA4IA
         EIctoRTtUOF3HjstKFWYFGF39iBagQsxy+gPXHwSIv1i5B03+wnVK4WgsGYAe0zBof2J
         1hWaKW8aDzVbQUOoMR1eIL1qKlhwOyXicpY94=
Message-ID: <b647ffbd0807180421p5674ec0bga15bdebe364d889f@mail.gmail.com>
Date: Fri, 18 Jul 2008 13:21:11 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] sched: do not stop ticks when cpu is not idle
Cc: LKML <linux-kernel@vger.kernel.org>, "Jack Ren" <jack.ren@marvell.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "eric miao" <eric.y.miao@gmail.com>
In-Reply-To: <f17812d70807172341u92270fdvc80e72cc5599c56f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f17812d70807172341u92270fdvc80e72cc5599c56f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/18 eric miao <eric.y.miao@gmail.com>:
> Issue: the sched tick would be stopped in some race conditions.
>
> One of issues caused by that is:
>
> Since there is no timer ticks any more from then, the jiffies update will be
> up to other interrupt to happen. The jiffies will not be updated for a long
> time, until next interrupt happens.  That will cause APIs like
> wait_for_completion_timeout(&complete, timeout) to return timeout by mistake,
> since it is using a old jiffies as start time.
>
> Please see comments (1)~(6) inline for how the ticks are stopped
> by mistake when cpu is not idle:
>
> void cpu_idle(void)
> {
> ...
>        while (1) {
>                void (*idle)(void) = pm_idle;
>                if (!idle)
>                        idle = default_idle;
>                leds_event(led_idle_start);
>                tick_nohz_stop_sched_tick();
>                while (!need_resched())
>                        idle();
>                leds_event(led_idle_end);
>                tick_nohz_restart_sched_tick();
>                        (1) ticks are retarted before switch to other tasks
>                preempt_enable_no_resched();
>                schedule();
>                preempt_disable();
>        }
> }
>
> asmlinkage void __sched schedule(void)
> {
>        ...
>        ...
> need_resched:
>        (6) the idle task will be scheduled out again and switch to next task,
>         with ticks stopped in (5). So the next task will be running with tick stopped.
>        preempt_disable();
>        cpu = smp_processor_id();
>        rq = cpu_rq(cpu);
>        rcu_qsctr_inc(cpu);
>        prev = rq->curr;
>        switch_count = &prev->nivcsw;
>
>        release_kernel_lock(prev);
> need_resched_nonpreemptible:
>
>        schedule_debug(prev);
>
>        hrtick_clear(rq);
>
>        /*
>         * Do the rq-clock update outside the rq lock:
>         */
>        local_irq_disable();
>        __update_rq_clock(rq);
>        spin_lock(&rq->lock);
>        clear_tsk_need_resched(prev); (2) resched flag is clear from idle task
>
>        ....
>
>                context_switch(rq, prev, next); /* unlocks the rq */
>                (3) IRQ will be enabled at end of context_swtich( ).
>        ...
>        preempt_enable_no_resched();
>        if (unlikely(test_thread_flag(TIF_NEED_RESCHED)))
>                        (4) the idle task is scheduled back. If an interrupt happen here,
>                                 The irq_exit( ) will be called at end of the irq handler.
>                goto need_resched;

(I've taken just a quick look so far, that's maybe why I'm a bit confused)

So what did set TIF_NEED_RESCHED flag here in (4)?

- at first, it was cleared in (2) - ok.
- An interrupt happens somewhere after context_switch() [ btw., what's
about archs that do ctx-switches with interrupts enabled... ]

irq_exit() calls tick_nohz_stop_sched_tick() _only_ when
!need_resched(), meaning TIF_NEED_RESCHED is _not_ set for rq->idle
(no new tasks were activated)
.

So do we have 2 interruts in a raw?

my (likely wrong) interpretation:

(1) schedule() some task - (switch to) -> idle

idle becomes active but is still running in schedule()

(2) an interrupt happens at (3), then irq_exit() calls
tick_nohz_stop_sched_tick()

so far, idle should still run -> this interrupt didn't lead to new
tasks having been activated

(3) another interrupt happens which actually wakes up a task;

TIF_NEED_RESCHED is set

(4) this fact is detected at (4) and --> goto need_resched() to pick
up a new task.

(5) we kind of have idle -> new task reschedule but cpu_idle() never
happened to be called _so_ sched-ticks were not resterted...

is it like this or I'm missing something?


> }
>
> void irq_exit(void)
> {
> ...
>        /* Make sure that timer wheel updates are propagated */
>        if (!in_interrupt() && idle_cpu(smp_processor_id()) && !need_resched())
>                tick_nohz_stop_sched_tick();
>                (5) The ticks will be stopped again since current
>                        task is idle task and its resched flag is clear in (2).
>        rcu_irq_exit();
>        preempt_enable_no_resched();
> }
>
> Signed-off-by: Jack Ren <jack.ren@marvell.com>
> ---
>  kernel/sched.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index ff0a7e2..fd17d74 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4027,7 +4027,8 @@ need_resched_nonpreemptible:
>                rq->nr_switches++;
>                rq->curr = next;
>                ++*switch_count;
> -
> +               if (rq->curr != rq->idle)
> +                       tick_nohz_restart_sched_tick();
>                context_switch(rq, prev, next); /* unlocks the rq */
>                /*
>                 * the context switch might have flipped the stack from under
> --
> 1.5.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Best regards,
Dmitry Adamushko
