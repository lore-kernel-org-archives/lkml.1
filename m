Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbYGRGli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbYGRGli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 02:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbYGRGlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 02:41:31 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:42957 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbYGRGla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 02:41:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=CN8JuUQecKdPIuuXbiJ32ezXyLiB5sC3tkHoLVSUAmn+mYPj3Cc9AFEPASDBp/VWey
         gDyLgeipak4xDeRSLhedPiLcwLjGFhPmDpS989JoK4krXPxeZV7R44teOwMdRbGUl/J3
         fJe/KsNJRb1+tewBtEmAq7zCkQptr+gC/8rio=
Message-ID: <f17812d70807172341u92270fdvc80e72cc5599c56f@mail.gmail.com>
Date: Fri, 18 Jul 2008 14:41:29 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: do not stop ticks when cpu is not idle
Cc: "Jack Ren" <jack.ren@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 kernel/sched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ff0a7e2..fd17d74 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4027,7 +4027,8 @@ need_resched_nonpreemptible:
 		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;
-
+		if (rq->curr != rq->idle)
+			tick_nohz_restart_sched_tick();
 		context_switch(rq, prev, next); /* unlocks the rq */
 		/*
 		 * the context switch might have flipped the stack from under
-- 
1.5.4
