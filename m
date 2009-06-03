Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbZFCPYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbZFCPYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757919AbZFCPXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:23:54 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:35067 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184AbZFCPXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:23:53 -0400
Message-Id: <20090603152313.281689482@de.ibm.com>
References: <20090603152223.083010123@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 03 Jun 2009 17:22:24 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Rob van der Heij <rvdheij@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Andi Kleen <andi@firstfloor.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 1/2] idle profile hits with NOHZ
Content-Disposition: inline; filename=profile-idle-tick.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

On a NOHZ system the generic clock events code reports a maximum
of 1 tick to the kernel profiler. If the system slept for more than
a single tick or has not been woken by a timer interrupt the number
of ticks reported will be incorrect. This skewes the percentages in
the profile. A good place to report the profile ticks is in
tick_nohz_restart_sched_tick. We calculate the number of ticks for
the cpu accounting anyway. The only obstacle is that we need an
instruction address for the profile ticks. In order to get one
extend the tick_sched structure by an idle_pc field and set it in
tick_nohz_stop_idle which is called from tick_check_idle.
Note: this does not solve the same problem in oprofile.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 include/linux/tick.h     |    1 +
 kernel/time/tick-sched.c |   14 +++++++++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

Index: quilt-2.6/include/linux/tick.h
===================================================================
--- quilt-2.6.orig/include/linux/tick.h
+++ quilt-2.6/include/linux/tick.h
@@ -64,6 +64,7 @@ struct tick_sched {
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
 	ktime_t				idle_expires;
+	unsigned long			idle_pc;
 };
 
 extern void __init tick_init(void);
Index: quilt-2.6/kernel/time/tick-sched.c
===================================================================
--- quilt-2.6.orig/kernel/time/tick-sched.c
+++ quilt-2.6/kernel/time/tick-sched.c
@@ -166,6 +166,8 @@ static void tick_nohz_stop_idle(int cpu)
 		ts->idle_lastupdate = now;
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
 		ts->idle_active = 0;
+		if (in_interrupt())
+			ts->idle_pc = profile_pc(get_irq_regs());
 
 		sched_clock_idle_wakeup_event(0);
 	}
@@ -419,9 +421,7 @@ void tick_nohz_restart_sched_tick(void)
 {
 	int cpu = smp_processor_id();
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	unsigned long ticks;
-#endif
 	ktime_t now;
 
 	local_irq_disable();
@@ -443,19 +443,23 @@ void tick_nohz_restart_sched_tick(void)
 	tick_do_update_jiffies64(now);
 	cpumask_clear_cpu(cpu, nohz_cpu_mask);
 
+	ticks = jiffies - ts->idle_jiffies;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	/*
 	 * We stopped the tick in idle. Update process times would miss the
 	 * time we slept as update_process_times does only a 1 tick
 	 * accounting. Enforce that this is accounted to idle !
-	 */
-	ticks = jiffies - ts->idle_jiffies;
-	/*
+	 *
 	 * We might be one off. Do not randomly account a huge number of ticks!
 	 */
 	if (ticks && ticks < LONG_MAX)
 		account_idle_ticks(ticks);
 #endif
+#ifdef CONFIG_PROFILING
+	/* Create profile hits for all ticks we slept in idle. */
+	if (ticks && ticks < LONG_MAX)
+		profile_hits(CPU_PROFILING, (void *) ts->idle_pc, ticks);
+#endif
 
 	touch_softlockup_watchdog();
 	/*

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

