Return-Path: <linux-kernel-owner+w=401wt.eu-S1762091AbZEHSSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762091AbZEHSSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001AbZEHSSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:18:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:55404 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621AbZEHSR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:17:59 -0400
Message-Id: <20090508170028.630419454@chello.nl>
References: <20090508165219.469818319@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 08 May 2009 18:52:20 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/5] hrtimer: per-cpu cached values of ktime
Content-Disposition: inline; filename=opt-tick-ktime_get.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regular (hrtimer driven) tick calls ktime_get() 4 times:

hrtimer_interupt()
  ktimer_get()
  __run_hrtimer()
    tick_sched_timer()
      ktimer_get()
      update_process_times()
        run_local_timers()
        rcu_pending()
        printk_tick()
        scheduler_tick()
          sched_clock_tick()
            ktime_get()
          perf_counter_task_tick()
        run_posix_cpu_timers()
      profile_tick()
      hrtimer_forward()
    hrtimer_enqueue()
      tick_program_event()
        tick_dev_program_event()
          ktime_get()

Reduce that to 2 by caching the 1st ktime_get(). By clearing the state on
irq_exit() this always works, even for !hrtimer ticks.

Getting rid of the last ktime_get() is a bit more involved as that code can
also get called from outside of irq context.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/hrtimer.h  |    5 +++++
 kernel/hrtimer.c         |   22 ++++++++++++++++++++--
 kernel/sched_clock.c     |    3 ++-
 kernel/softirq.c         |    2 ++
 kernel/time/tick-sched.c |    2 +-
 5 files changed, 30 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/hrtimer.h
===================================================================
--- linux-2.6.orig/include/linux/hrtimer.h
+++ linux-2.6/include/linux/hrtimer.h
@@ -173,8 +173,13 @@ struct hrtimer_cpu_base {
 	int				hres_active;
 	unsigned long			nr_events;
 #endif
+	ktime_t				ktime_irq;
+	int				ktime_irq_set;
 };
 
+extern ktime_t ktime_irq_get(void);
+extern void ktime_irq_clear(void);
+
 static inline void hrtimer_set_expires(struct hrtimer *timer, ktime_t time)
 {
 	timer->_expires = time;
Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -88,7 +88,6 @@ EXPORT_SYMBOL_GPL(ktime_get_real);
  */
 DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 {
-
 	.clock_base =
 	{
 		{
@@ -104,6 +103,25 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base, 
 	}
 };
 
+ktime_t ktime_irq_get(void)
+{
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+
+	if (!cpu_base->ktime_irq_set) {
+		cpu_base->ktime_irq = ktime_get();
+		cpu_base->ktime_irq_set = 1;
+	}
+
+	return cpu_base->ktime_irq;
+}
+
+void ktime_irq_clear(void)
+{
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+
+	cpu_base->ktime_irq_set = 0;
+}
+
 /**
  * ktime_get_ts - get the monotonic clock in timespec format
  * @ts:		pointer to timespec variable
@@ -1222,7 +1240,7 @@ void hrtimer_interrupt(struct clock_even
 	if (!(++nr_retries % 5))
 		hrtimer_interrupt_hanging(dev, ktime_sub(ktime_get(), now));
 
-	now = ktime_get();
+	now = ktime_irq_get();
 
 	expires_next.tv64 = KTIME_MAX;
 
Index: linux-2.6/kernel/sched_clock.c
===================================================================
--- linux-2.6.orig/kernel/sched_clock.c
+++ linux-2.6/kernel/sched_clock.c
@@ -219,7 +219,7 @@ void sched_clock_tick(void)
 	WARN_ON_ONCE(!irqs_disabled());
 
 	scd = this_scd();
-	now_gtod = ktime_to_ns(ktime_get());
+	now_gtod = ktime_to_ns(ktime_irq_get());
 	now = sched_clock();
 
 	__raw_spin_lock(&scd->lock);
@@ -246,6 +246,7 @@ void sched_clock_idle_wakeup_event(u64 d
 	if (timekeeping_suspended)
 		return;
 
+	ktime_irq_clear();
 	sched_clock_tick();
 	touch_softlockup_watchdog();
 }
Index: linux-2.6/kernel/softirq.c
===================================================================
--- linux-2.6.orig/kernel/softirq.c
+++ linux-2.6/kernel/softirq.c
@@ -282,6 +282,8 @@ void irq_enter(void)
 		tick_check_idle(cpu);
 	} else
 		__irq_enter();
+
+	ktime_irq_clear();
 }
 
 #ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
Index: linux-2.6/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-sched.c
+++ linux-2.6/kernel/time/tick-sched.c
@@ -629,7 +629,7 @@ static enum hrtimer_restart tick_sched_t
 	struct tick_sched *ts =
 		container_of(timer, struct tick_sched, sched_timer);
 	struct pt_regs *regs = get_irq_regs();
-	ktime_t now = ktime_get();
+	ktime_t now = ktime_irq_get();
 	int cpu = smp_processor_id();
 
 #ifdef CONFIG_NO_HZ

-- 

