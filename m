Return-Path: <linux-kernel-owner+w=401wt.eu-S1756455AbYCVOba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbYCVOba (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 10:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYCVObW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 10:31:22 -0400
Received: from www.tglx.de ([62.245.132.106]:55336 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbYCVObV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 10:31:21 -0400
Date: Sat, 22 Mar 2008 15:30:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Gabriel C <crazy@frugalware.org>
cc: Gabriel C <nix.or.die@googlemail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, andi-bz@firstfloor.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
In-Reply-To: <47E50AF9.5070801@frugalware.org>
Message-ID: <alpine.LFD.1.00.0803221441370.3781@apollo.tec.linutronix.de>
References: <200803170018.52663.rjw@sisk.pl> <47DDB969.1060200@googlemail.com> <alpine.LFD.1.00.0803171716130.3781@apollo.tec.linutronix.de> <47DEB65A.9080907@googlemail.com> <47DF3E8B.6040502@googlemail.com> <47E3D322.1090902@googlemail.com>
 <alpine.LFD.1.00.0803211720340.3781@apollo.tec.linutronix.de> <47E3E66F.9040006@frugalware.org> <47E3FA4F.9060509@frugalware.org> <alpine.LFD.1.00.0803211944250.3781@apollo.tec.linutronix.de> <47E40B1C.30407@frugalware.org> <47E420C5.1050407@frugalware.org>
 <alpine.LFD.1.00.0803212208300.3781@apollo.tec.linutronix.de> <47E42FAB.6000906@frugalware.org> <alpine.LFD.1.00.0803212302390.3781@apollo.tec.linutronix.de> <alpine.LFD.1.00.0803220847020.3781@apollo.tec.linutronix.de> <47E50AF9.5070801@frugalware.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008, Gabriel C wrote:
 > Now some time later CPU1 gets woken by an interrupt/IPI and runs the
> > timer wheel. At this point the pm_timer which is the reference clock
> > has already wrapped around, so the watchdog thinks that there is a
> > huge time difference and marks the TSC unstable.
> > 
> > Aside of that watchdog issue this also affects the other users of
> > add_timer_on(): e.g. queue_delayed_work_on().
> > 
> > Can you please apply the patch below and verify it with Andi's
> > watchdog patch applied ? 
> 
> 
> Did that , git head , Andi's + your patch but TSC is still marked unstable.

Doh, stupid me. We do not reevaluate the timer wheel, when we just
wake up via the smp_reschedule IPI when the resched flag on the other
CPU is not set. That's a separate vector which is not going through
irq_enter() / irq_exit(). 

Does the patch below solve the problem ?

Thanks,

	tglx

---
 include/linux/tick.h     |    4 +++
 kernel/time/tick-sched.c |   50 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/timer.c           |   14 ++++++++++++-
 3 files changed, 67 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/tick.h
===================================================================
--- linux-2.6.orig/include/linux/tick.h
+++ linux-2.6/include/linux/tick.h
@@ -111,6 +111,8 @@ extern void tick_nohz_update_jiffies(voi
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern void tick_nohz_stop_idle(int cpu);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
+extern int tick_nohz_cpu_needs_wakeup(int cpu);
+extern void tick_nohz_rescan_timers_on(int cpu);
 # else
 static inline void tick_nohz_stop_sched_tick(void) { }
 static inline void tick_nohz_restart_sched_tick(void) { }
@@ -123,6 +125,8 @@ static inline ktime_t tick_nohz_get_slee
 }
 static inline void tick_nohz_stop_idle(int cpu) { }
 static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return 0; }
+static inline int tick_nohz_cpu_needs_wakeup(int cpu) { return 0; }
+static inline void tick_nohz_rescan_timers_on(int cpu) { }
 # endif /* !NO_HZ */
 
 #endif
Index: linux-2.6/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-sched.c
+++ linux-2.6/kernel/time/tick-sched.c
@@ -183,6 +183,56 @@ u64 get_cpu_idle_time_us(int cpu, u64 *l
 }
 
 /**
+ * tick_nohz_cpu_needs_wakeup - check possible wakeup of cpu in add_timer_on()
+ *
+ * when add_timer_on() happens on a CPU which is in a long idle sleep,
+ * then we need to wake it up so the timer wheel gets reevaluated.
+ *
+ * Note: we use idle_cpu() which checks the idle state lockless, but
+ * we are ordered against the other cpu which might be on the way to
+ * idle by the timer base lock, which we hold.
+ */
+int tick_nohz_cpu_needs_wakeup(int cpu)
+{
+	return tick_nohz_enabled && idle_cpu(cpu) &&
+		(cpu != smp_processor_id());
+}
+
+/*
+ * Rescan the timer wheel, when
+ *
+ * - the CPU is idle
+ * - the CPU is not processing an interupt
+ * - the need_resched flag is off
+ */
+static void tick_nohz_rescan_timers(void *unused)
+{
+	int cpu = smp_processor_id();
+
+	if (!idle_cpu(cpu) || in_interrupt() || need_resched())
+		return;
+
+	tick_nohz_stop_idle(cpu);
+	tick_nohz_update_jiffies();
+	tick_nohz_stop_sched_tick();
+}
+
+/**
+ * tick_nohz_rescan_timers_on - reevaluate the idle sleep time of a CPU
+ *
+ * When a CPU is idle and a timer got added to this CPU timer wheel
+ * via add_timer_on() then we need to make sure that the CPU
+ * reevaluates the timer wheel. Otherwise the timer might be delayed
+ * for a real long time.
+ */
+void tick_nohz_rescan_timers_on(int cpu)
+{
+	if (tick_nohz_enabled && idle_cpu(cpu))
+		smp_call_function_single(cpu, tick_nohz_rescan_timers, NULL,
+					 0, 0);
+}
+
+/**
  * tick_nohz_stop_sched_tick - stop the idle tick from the idle task
  *
  * When the next event is more than a tick into the future, stop the idle tick
Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -445,15 +445,27 @@ void add_timer_on(struct timer_list *tim
 {
 	struct tvec_base *base = per_cpu(tvec_bases, cpu);
 	unsigned long flags;
+	int wakeidle;
 
 	timer_stats_timer_set_start_info(timer);
 	BUG_ON(timer_pending(timer) || !timer->function);
 	spin_lock_irqsave(&base->lock, flags);
 	timer_set_base(timer, base);
 	internal_add_timer(base, timer);
+	/*
+	 * Check whether the other CPU is idle and needs to be
+	 * triggered to reevaluate the timer wheel when nohz is
+	 * active. We are protected against the other CPU fiddling
+	 * with the timer by holding the timer base lock. This also
+	 * makes sure that a CPU on the way to idle can not evaluate
+	 * the timer wheel.
+	 */
+	wakeidle = tick_nohz_cpu_needs_wakeup(cpu);
 	spin_unlock_irqrestore(&base->lock, flags);
-}
 
+	if (wakeidle)
+		tick_nohz_rescan_timers_on(cpu);
+}
 
 /**
  * mod_timer - modify a timer's timeout
