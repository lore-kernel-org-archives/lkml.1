Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbYKIV4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbYKIV4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 16:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbYKIV4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 16:56:24 -0500
Received: from www.tglx.de ([62.245.132.106]:47290 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756062AbYKIV4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 16:56:23 -0500
Date: Sun, 9 Nov 2008 22:56:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arjan van de Ven <arjan@infradead.org>
cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, corsac@debian.org, elendil@planet.nl
Subject: Re: Bootup time regression from 2.6.27 to 2.6.28-rc3+
In-Reply-To: <20081109132438.5d81cd74@infradead.org>
Message-ID: <alpine.LFD.2.00.0811092226050.12263@localhost.localdomain>
References: <20081104173300.GF6134@ics.muni.cz> <20081109105159.GA5867@joi> <20081109113304.GE4353@ics.muni.cz> <200811091424.10943.rjw@sisk.pl> <20081109200918.GA4361@ics.muni.cz> <20081109122835.10f410fa@infradead.org> <20081109203432.GB4361@ics.muni.cz>
 <20081109132438.5d81cd74@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Nov 2008, Arjan van de Ven wrote:
> On Sun, 9 Nov 2008 21:34:32 +0100
> Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:
> 
> > On Sun, Nov 09, 2008 at 12:28:35PM -0800, Arjan van de Ven wrote:
> > > for me, the plan is that we need to get Thomas' fixes tested by
> > > someone who can reproduce this very reliably. If they fix it, great.
> > 
> > as for me, 100% of boots require a key hit to proceed in 2.6.28-rc3
> > (more precisely, the current git head).
> > 
> 
> it would be greatly appreciated if those that see this issue can test
> the patch below (which is a combo patch of thomas' fixes, to make
> testing easier) and confirm if this fixes the hangs.
> If they do fix the issue we don't need to disable anything and get better power
> savings as bonus as well.

Just disabling the peek_ahead does not make the key press issue go
away. It makes it less prominent.

> 
> Gautham R Shenoy (1):
>       timers: handle HRTIMER_CB_IRQSAFE_UNLOCKED correctly from softirq context
> 
> Ingo Molnar (2):
>       irq: fix typo
>       nohz: fix SMP race
> 
> Thomas Gleixner (12):
>       nohz: check broadcast on tick restart

>       x86: apic reset counter on shutdown

Not a required bugfix, but harmless and avoids extra wakeups.

>       hrtimer: fix the accounting of hrtimer_peek_ahead()
>       hrtimer: do not peek ahead when the hardware timer has fired already
>       tick: clear broadcast mask when timer is reprogrammed
>       irq: call __irq_enter() before calling the tick_idle_check

>       x86: apic honour irq affinity which was set in early boot
>       genirq: keep affinities set from userspace across free/request_irq()
>       genirq: fix the affinity setting in setup_irq

These three are separate. I discoverd the problems via a report from
Kumar Galak and I fixed it while I tried to find out the root cause of
the nohz / keypress issue. They are not part of the timer fixes and in
a separate tree.

>       tick: cleanup idle checks
>       ACPI: processor_idle: check for spurious wakeups
>       ACPI: idle check for spurious wakeups accounting fix

I worked all week after returning from travelling to get down to the
root cause of this. We had several issues:

1) peek_ahead confused the hell out of the nohz code when it expired
timers when the timer interrupt was already pending

2) the changes I did to prevent the stale jiffies in the nohz case
turned out to be incomplete and wrong versus the broadcast of timers
in deeper C-States

3) the consolidation of the nohz idle checks called the nohz jiffies
update code before calling __irq_enter() which caused useless wakeups
of ksoftirqd

4) A long standing - but until now papered over and therefor unnoticed
- problem of spurious wakeups from deep c-states: 

  If one core gets an interrupt the other core(s) wake up as
  well. The stale jiffies fix and the peek_ahead changes made this
  more visible and is a major part of the reported nohz (more wakeups,
  more power consumption) regression.

  This was there forever, but nobody noticed as it was not accounted
  for.

Find below the lineup of the timers-fixes-for-linus branch of the tip
tree (the same as Arjan posted minus the irq fixes)

Thanks,

	tglx

---

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

Gautham R Shenoy (1):
      timers: handle HRTIMER_CB_IRQSAFE_UNLOCKED correctly from softirq context

Ingo Molnar (1):
      nohz: fix SMP race

Thomas Gleixner (9):
      nohz: check broadcast on tick restart
      x86: apic reset counter on shutdown
      hrtimer: fix the accounting of hrtimer_peek_ahead()
      hrtimer: do not peek ahead when the hardware timer has fired already
      tick: clear broadcast mask when timer is reprogrammed
      irq: call __irq_enter() before calling the tick_idle_check
      tick: cleanup idle checks
      ACPI: processor_idle: check for spurious wakeups
      ACPI: idle check for spurious wakeups accounting fix


 arch/x86/kernel/apic.c        |    1 +
 drivers/acpi/processor_idle.c |   49 ++++++++++++++++++-----
 drivers/cpuidle/cpuidle.c     |    5 ++-
 include/linux/hrtimer.h       |    4 +-
 include/linux/tick.h          |    5 ++
 kernel/hrtimer.c              |   81 +++++++++++++++++++++++++++++--------
 kernel/softirq.c              |    7 ++-
 kernel/time/tick-broadcast.c  |   27 ++++++++++++
 kernel/time/tick-internal.h   |    5 ++
 kernel/time/tick-sched.c      |   88 ++++++++++++++++++++++------------------
 kernel/time/timer_list.c      |    4 +-
 11 files changed, 201 insertions(+), 75 deletions(-)

diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 04a7f96..70003b8 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -441,6 +441,7 @@ static void lapic_timer_setup(enum clock_event_mode mode,
 		v = apic_read(APIC_LVTT);
 		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
 		apic_write(APIC_LVTT, v);
+		apic_write(APIC_TMICT, 0xffffffff);
 		break;
 	case CLOCK_EVT_MODE_RESUME:
 		/* Nothing to do here */
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 81b40ed..371dc42 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -41,6 +41,7 @@
 #include <linux/pm_qos_params.h>
 #include <linux/clockchips.h>
 #include <linux/cpuidle.h>
+#include <linux/tick.h>
 
 /*
  * Include the apic definitions for x86 to have the APIC timer related defines
@@ -1458,6 +1459,7 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
 	u32 t1, t2;
 	struct acpi_processor *pr;
 	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
+	int sleep_ticks = 0;
 
 	pr = __get_cpu_var(processors);
 
@@ -1473,6 +1475,7 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
 		return 0;
 	}
 
+again:
 	if (pr->flags.bm_check)
 		acpi_idle_update_bm_rld(pr, cx);
 
@@ -1480,10 +1483,18 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
 	acpi_idle_do_entry(cx);
 	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 
+	sleep_ticks += ticks_elapsed(t1, t2);
+
 	local_irq_enable();
+
+	/* Check for spurious wakeup */
+	if (check_idle_spurious_wakeup(pr->id) && !need_resched()) {
+		local_irq_disable();
+		goto again;
+	}
 	cx->usage++;
 
-	return ticks_elapsed_in_us(t1, t2);
+	return sleep_ticks;
 }
 
 /**
@@ -1497,7 +1508,7 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 	struct acpi_processor *pr;
 	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
 	u32 t1, t2;
-	int sleep_ticks = 0;
+	int ticks, sleep_ticks = 0;
 
 	pr = __get_cpu_var(processors);
 
@@ -1527,6 +1538,7 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 	 */
 	acpi_state_timer_broadcast(pr, cx, 1);
 
+again:
 	if (pr->flags.bm_check)
 		acpi_idle_update_bm_rld(pr, cx);
 
@@ -1544,12 +1556,19 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 	if (tsc_halts_in_c(cx->type))
 		mark_tsc_unstable("TSC halts in idle");;
 #endif
-	sleep_ticks = ticks_elapsed(t1, t2);
-
+	ticks = ticks_elapsed(t1, t2);
 	/* Tell the scheduler how much we idled: */
-	sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
+	sched_clock_idle_wakeup_event(ticks*PM_TIMER_TICK_NS);
 
 	local_irq_enable();
+	sleep_ticks += ticks;
+
+	/* Check for spurious wakeup */
+	if (check_idle_spurious_wakeup(pr->id) && !need_resched()) {
+		local_irq_disable();
+		goto again;
+	}
+
 	current_thread_info()->status |= TS_POLLING;
 
 	cx->usage++;
@@ -1575,7 +1594,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 	struct acpi_processor *pr;
 	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
 	u32 t1, t2;
-	int sleep_ticks = 0;
+	int ticks, sleep_ticks = 0;
 
 	pr = __get_cpu_var(processors);
 
@@ -1613,14 +1632,16 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 
 	acpi_unlazy_tlb(smp_processor_id());
 
-	/* Tell the scheduler that we are going deep-idle: */
-	sched_clock_idle_sleep_event();
 	/*
 	 * Must be done before busmaster disable as we might need to
 	 * access HPET !
 	 */
 	acpi_state_timer_broadcast(pr, cx, 1);
 
+again:
+	/* Tell the scheduler that we are going deep-idle: */
+	sched_clock_idle_sleep_event();
+
 	acpi_idle_update_bm_rld(pr, cx);
 
 	/*
@@ -1661,11 +1682,19 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 	if (tsc_halts_in_c(ACPI_STATE_C3))
 		mark_tsc_unstable("TSC halts in idle");
 #endif
-	sleep_ticks = ticks_elapsed(t1, t2);
+	ticks = ticks_elapsed(t1, t2);
 	/* Tell the scheduler how much we idled: */
-	sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
+	sched_clock_idle_wakeup_event(ticks*PM_TIMER_TICK_NS);
 
 	local_irq_enable();
+	sleep_ticks += ticks;
+
+	/* Check for spurious wakeup */
+	if (check_idle_spurious_wakeup(pr->id) && !need_resched()) {
+		local_irq_disable();
+		goto again;
+	}
+
 	current_thread_info()->status |= TS_POLLING;
 
 	cx->usage++;
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 5bed733..f3ca665 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -69,7 +69,10 @@ static void cpuidle_idle_call(void)
 	 * run any timers that can be run now, at this point
 	 * before calculating the idle duration etc.
 	 */
-	hrtimer_peek_ahead_timers();
+	if (hrtimer_peek_ahead_timers()) {
+		local_irq_enable();
+		return;
+	}
 
 	/* ask the governor for the next state */
 	next_state = cpuidle_curr_governor->select(dev);
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 07e510a..e3d7d9f 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -294,7 +294,7 @@ static inline int hrtimer_is_hres_active(struct hrtimer *timer)
 	return timer->base->cpu_base->hres_active;
 }
 
-extern void hrtimer_peek_ahead_timers(void);
+extern int hrtimer_peek_ahead_timers(void);
 
 /*
  * The resolution of the clocks. The resolution value is returned in
@@ -318,7 +318,7 @@ extern void hrtimer_peek_ahead_timers(void);
  * is expired in the next softirq when the clock was advanced.
  */
 static inline void clock_was_set(void) { }
-static inline void hrtimer_peek_ahead_timers(void) { }
+static inline int hrtimer_peek_ahead_timers(void) { return 0; }
 
 static inline void hres_timers_resume(void) { }
 
diff --git a/include/linux/tick.h b/include/linux/tick.h
index b6ec818..ff202ac 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -64,6 +64,9 @@ struct tick_sched {
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
 	ktime_t				idle_expires;
+	unsigned long			irq_wakeups;
+	unsigned long			irq_last_wakeups;
+	unsigned long			spurious_wakeups;
 };
 
 extern void __init tick_init(void);
@@ -116,6 +119,7 @@ extern void tick_nohz_stop_sched_tick(int inidle);
 extern void tick_nohz_restart_sched_tick(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
+extern int check_idle_spurious_wakeup(int cpu);
 # else
 static inline void tick_nohz_stop_sched_tick(int inidle) { }
 static inline void tick_nohz_restart_sched_tick(void) { }
@@ -126,6 +130,7 @@ static inline ktime_t tick_nohz_get_sleep_length(void)
 	return len;
 }
 static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
+static inline int check_idle_spurious_wakeup(int cpu) { return 0; }
 # endif /* !NO_HZ */
 
 #endif
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 2b465df..075bc8e 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1209,6 +1209,7 @@ static void run_hrtimer_pending(struct hrtimer_cpu_base *cpu_base)
 		enum hrtimer_restart (*fn)(struct hrtimer *);
 		struct hrtimer *timer;
 		int restart;
+		int emulate_hardirq_ctx = 0;
 
 		timer = list_entry(cpu_base->cb_pending.next,
 				   struct hrtimer, cb_entry);
@@ -1217,10 +1218,24 @@ static void run_hrtimer_pending(struct hrtimer_cpu_base *cpu_base)
 		timer_stats_account_hrtimer(timer);
 
 		fn = timer->function;
+		/*
+		 * A timer might have been added to the cb_pending list
+		 * when it was migrated during a cpu-offline operation.
+		 * Emulate hardirq context for such timers.
+		 */
+		if (timer->cb_mode == HRTIMER_CB_IRQSAFE_PERCPU ||
+		    timer->cb_mode == HRTIMER_CB_IRQSAFE_UNLOCKED)
+			emulate_hardirq_ctx = 1;
+
 		__remove_hrtimer(timer, timer->base, HRTIMER_STATE_CALLBACK, 0);
 		spin_unlock_irq(&cpu_base->lock);
 
-		restart = fn(timer);
+		if (unlikely(emulate_hardirq_ctx)) {
+			local_irq_disable();
+			restart = fn(timer);
+			local_irq_enable();
+		} else
+			restart = fn(timer);
 
 		spin_lock_irq(&cpu_base->lock);
 
@@ -1297,23 +1312,26 @@ static void __run_hrtimer(struct hrtimer *timer)
 #ifdef CONFIG_HIGH_RES_TIMERS
 
 /*
- * High resolution timer interrupt
- * Called with interrupts disabled
+ * High resolution timer interrupt internal worker function called
+ * with interrupts disabled either from hrtimer_interrupt() or from
+ * hrtimer_peek_ahead()
  */
-void hrtimer_interrupt(struct clock_event_device *dev)
+int __hrtimer_interrupt(struct hrtimer_cpu_base *cpu_base, int peekahead)
 {
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	struct hrtimer_clock_base *base;
 	ktime_t expires_next, now;
 	int i, raise = 0;
 
-	BUG_ON(!cpu_base->hres_active);
-	cpu_base->nr_events++;
-	dev->next_event.tv64 = KTIME_MAX;
-
  retry:
 	now = ktime_get();
 
+	/*
+	 * In peek ahead mode bail out, if the hw interrupt is
+	 * imminent:
+	 */
+	if (peekahead && cpu_base->expires_next.tv64 < now.tv64)
+		return -ETIME;
+
 	expires_next.tv64 = KTIME_MAX;
 
 	base = cpu_base->clock_base;
@@ -1370,17 +1388,49 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 		base++;
 	}
 
+	/*
+	 * We just peeked ahead. The hardware timer did not expire. So
+	 * we can leave the timer armed.
+	 */
+	if (peekahead && cpu_base->expires_next.tv64 == expires_next.tv64)
+		goto out;
+
 	cpu_base->expires_next = expires_next;
 
 	/* Reprogramming necessary ? */
 	if (expires_next.tv64 != KTIME_MAX) {
+		/*
+		 * Clear the peeakahead flag once we decided to
+		 * reprogram. Otherwise we break out in the check
+		 * above.
+		 */
+		peekahead = 0;
 		if (tick_program_event(expires_next, 0))
 			goto retry;
 	}
 
+out:
 	/* Raise softirq ? */
 	if (raise)
 		raise_softirq(HRTIMER_SOFTIRQ);
+
+	return 0;
+}
+
+
+/*
+ * High resolution timer interrupt
+ * Called with interrupts disabled
+ */
+void hrtimer_interrupt(struct clock_event_device *dev)
+{
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+
+	BUG_ON(!cpu_base->hres_active);
+	cpu_base->nr_events++;
+	dev->next_event.tv64 = KTIME_MAX;
+
+	__hrtimer_interrupt(cpu_base, 0);
 }
 
 /**
@@ -1392,19 +1442,14 @@ void hrtimer_interrupt(struct clock_event_device *dev)
  * they are run immediately and then removed from the timer queue.
  *
  */
-void hrtimer_peek_ahead_timers(void)
+int hrtimer_peek_ahead_timers(void)
 {
-	struct tick_device *td;
-	unsigned long flags;
+	WARN_ON_ONCE(!irqs_disabled());
 
 	if (!hrtimer_hres_active())
-		return;
+		return 0;
 
-	local_irq_save(flags);
-	td = &__get_cpu_var(tick_cpu_device);
-	if (td && td->evtdev)
-		hrtimer_interrupt(td->evtdev);
-	local_irq_restore(flags);
+	return __hrtimer_interrupt(&__get_cpu_var(hrtimer_bases), 1);
 }
 
 static void run_hrtimer_softirq(struct softirq_action *h)
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 7110dae..e7c69a7 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -269,10 +269,11 @@ void irq_enter(void)
 {
 	int cpu = smp_processor_id();
 
-	if (idle_cpu(cpu) && !in_interrupt())
+	if (idle_cpu(cpu) && !in_interrupt()) {
+		__irq_enter();
 		tick_check_idle(cpu);
-
-	__irq_enter();
+	} else
+		__irq_enter();
 }
 
 #ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f98a1b7..ffb7252 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -397,6 +397,33 @@ void tick_check_oneshot_broadcast(int cpu)
 }
 
 /*
+ * Called from tick_nohz_kick_tick() to check, whether the next
+ * broadcast event is less than a tick_period away or already pending
+ * to avoid reprogramming of the per cpu device.
+ */
+int tick_check_oneshot_broadcast_wakeup(int cpu, ktime_t now)
+{
+	struct clock_event_device *bc;
+	ktime_t delta;
+	int res = 0;
+
+	spin_lock(&tick_broadcast_lock);
+	bc = tick_broadcast_device.evtdev;
+
+	if (bc) {
+		delta =	ktime_sub(bc->next_event, now);
+		if (delta.tv64 <= tick_period.tv64)
+			res = 1;
+		else
+			cpu_clear(cpu, tick_broadcast_oneshot_mask);
+	} else
+		cpu_clear(cpu, tick_broadcast_oneshot_mask);
+
+	spin_unlock(&tick_broadcast_lock);
+	return res;
+}
+
+/*
  * Handle oneshot mode broadcasting
  */
 static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index b1c05bf..b825c39 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -37,6 +37,7 @@ extern void tick_shutdown_broadcast_oneshot(unsigned int *cpup);
 extern int tick_resume_broadcast_oneshot(struct clock_event_device *bc);
 extern int tick_broadcast_oneshot_active(void);
 extern void tick_check_oneshot_broadcast(int cpu);
+extern int tick_check_oneshot_broadcast_wakeup(int cpu, ktime_t now);
 # else /* BROADCAST */
 static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
@@ -47,6 +48,10 @@ static inline void tick_broadcast_switch_to_oneshot(void) { }
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
 static inline int tick_broadcast_oneshot_active(void) { return 0; }
 static inline void tick_check_oneshot_broadcast(int cpu) { }
+static inline int tick_check_oneshot_broadcast_wakeup(int cpu, ktime_t now)
+{
+	return 0;
+}
 # endif /* !BROADCAST */
 
 #else /* !ONESHOT */
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 5bbb104..35a775e 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -134,48 +134,31 @@ __setup("nohz=", setup_tick_nohz);
  * value. We do this unconditionally on any cpu, as we don't know whether the
  * cpu, which has the update task assigned is in a long sleep.
  */
-void tick_nohz_update_jiffies(void)
+static void tick_nohz_update_jiffies(int cpu, struct tick_sched *ts,
+				     ktime_t now)
 {
-	int cpu = smp_processor_id();
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-	unsigned long flags;
-	ktime_t now;
-
-	if (!ts->tick_stopped)
-		return;
-
 	cpu_clear(cpu, nohz_cpu_mask);
-	now = ktime_get();
 	ts->idle_waketime = now;
 
-	local_irq_save(flags);
 	tick_do_update_jiffies64(now);
-	local_irq_restore(flags);
 
 	touch_softlockup_watchdog();
 }
 
-static void tick_nohz_stop_idle(int cpu)
+static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-
-	if (ts->idle_active) {
-		ktime_t now, delta;
-		now = ktime_get();
-		delta = ktime_sub(now, ts->idle_entrytime);
-		ts->idle_lastupdate = now;
-		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
-		ts->idle_active = 0;
+	ktime_t delta =	ktime_sub(now, ts->idle_entrytime);
 
-		sched_clock_idle_wakeup_event(0);
-	}
+	ts->idle_lastupdate = now;
+	ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+	ts->idle_active = 0;
+	sched_clock_idle_wakeup_event(0);
 }
 
 static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 {
-	ktime_t now, delta;
+	ktime_t delta,	now = ktime_get();
 
-	now = ktime_get();
 	if (ts->idle_active) {
 		delta = ktime_sub(now, ts->idle_entrytime);
 		ts->idle_lastupdate = now;
@@ -203,6 +186,21 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 }
 EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
 
+int check_idle_spurious_wakeup(int cpu)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	int ret;
+
+	local_irq_disable();
+	ret= ts->irq_last_wakeups == ts->irq_wakeups;
+
+	ts->irq_last_wakeups = ts->irq_wakeups;
+	ts->spurious_wakeups += ret;
+	local_irq_enable();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(check_idle_spurious_wakeup);
+
 /**
  * tick_nohz_stop_sched_tick - stop the idle tick from the idle task
  *
@@ -413,10 +411,10 @@ void tick_nohz_restart_sched_tick(void)
 	int cpu = smp_processor_id();
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	unsigned long ticks;
-	ktime_t now;
+	ktime_t now = ktime_get();
 
 	local_irq_disable();
-	tick_nohz_stop_idle(cpu);
+	tick_nohz_stop_idle(ts, now);
 
 	if (!ts->inidle || !ts->tick_stopped) {
 		ts->inidle = 0;
@@ -430,7 +428,6 @@ void tick_nohz_restart_sched_tick(void)
 
 	/* Update jiffies first */
 	select_nohz_load_balancer(0);
-	now = ktime_get();
 	tick_do_update_jiffies64(now);
 	cpu_clear(cpu, nohz_cpu_mask);
 
@@ -566,24 +563,20 @@ static void tick_nohz_switch_to_nohz(void)
  * timer and do not touch the other magic bits which need to be done
  * when idle is left.
  */
-static void tick_nohz_kick_tick(int cpu)
+static void tick_nohz_kick_tick(int cpu, struct tick_sched *ts, ktime_t now)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-	ktime_t delta, now;
-
-	if (!ts->tick_stopped)
-		return;
+	ktime_t delta;
 
 	/*
 	 * Do not touch the tick device, when the next expiry is either
 	 * already reached or less/equal than the tick period.
 	 */
-	now = ktime_get();
 	delta =	ktime_sub(hrtimer_get_expires(&ts->sched_timer), now);
 	if (delta.tv64 <= tick_period.tv64)
 		return;
 
-	tick_nohz_restart(ts, now);
+	if (!tick_check_oneshot_broadcast_wakeup(cpu, now))
+		tick_nohz_restart(ts, now);
 }
 
 #else
@@ -597,11 +590,26 @@ static inline void tick_nohz_switch_to_nohz(void) { }
  */
 void tick_check_idle(int cpu)
 {
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ktime_t now;
+
+	ts->irq_wakeups++;
+
 	tick_check_oneshot_broadcast(cpu);
+
 #ifdef CONFIG_NO_HZ
-	tick_nohz_stop_idle(cpu);
-	tick_nohz_update_jiffies();
-	tick_nohz_kick_tick(cpu);
+	if (!ts->tick_stopped && !ts->idle_active)
+		return;
+
+	now = ktime_get();
+
+	if (ts->idle_active)
+		tick_nohz_stop_idle(ts, now);
+
+	if (ts->tick_stopped) {
+		tick_nohz_update_jiffies(cpu, ts, now);
+		tick_nohz_kick_tick(cpu, ts, now);
+	}
 #endif
 }
 
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index a999b92..67c3d60 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -176,6 +176,8 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
 		P(last_jiffies);
 		P(next_jiffies);
 		P_ns(idle_expires);
+		P(irq_wakeups);
+		P(spurious_wakeups);
 		SEQ_printf(m, "jiffies: %Lu\n",
 			   (unsigned long long)jiffies);
 	}
@@ -252,7 +254,7 @@ static int timer_list_show(struct seq_file *m, void *v)
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Timer List Version: v0.4\n");
+	SEQ_printf(m, "Timer List Version: v0.5\n");
 	SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n", HRTIMER_MAX_CLOCK_BASES);
 	SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
 



