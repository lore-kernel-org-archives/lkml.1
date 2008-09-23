Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbYIWTl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbYIWTl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 15:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYIWTlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 15:41:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52469 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbYIWTlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 15:41:17 -0400
Date: Tue, 23 Sep 2008 21:41:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] timer fixes
Message-ID: <20080923194100.GA26034@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

A category of late fixes that solves the problems around regression 
http://bugzilla.kernel.org/show_bug.cgi?id=11611 . Tested by Rafael, and 
tested through on a range of laptops we have access to.

Thanks,

	Ingo

------------------>
Andreas Herrmann (1):
      x86: c1e_idle: don't mark TSC unstable if CPU has invariant TSC

Ingo Molnar (1):
      timers: fix build error in !oneshot case

Thomas Gleixner (6):
      clockevents: prevent cpu online to interfere with nohz
      x86: prevent stale state of c1e_mask across CPU offline/online
      clockevents: prevent stale tick_next_period for onlining CPUs
      clockevents: check broadcast device not tick device
      clockevents: prevent mode mismatch on cpu online
      x86: prevent C-states hang on AMD C1E enabled machines


 arch/x86/kernel/process.c    |   17 ++++++++++++-----
 arch/x86/kernel/process_32.c |    1 +
 arch/x86/kernel/process_64.c |    2 ++
 include/asm-x86/acpi.h       |    2 ++
 include/asm-x86/cpufeature.h |    1 +
 include/asm-x86/idle.h       |    2 ++
 kernel/time/tick-broadcast.c |   12 ++++++++++--
 kernel/time/tick-common.c    |   10 ++++++----
 kernel/time/tick-internal.h  |    7 +++++++
 kernel/time/tick-sched.c     |   11 +++++++----
 10 files changed, 50 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 7fc4d5b..876e918 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -246,6 +246,14 @@ static int __cpuinit check_c1e_idle(const struct cpuinfo_x86 *c)
 	return 1;
 }
 
+static cpumask_t c1e_mask = CPU_MASK_NONE;
+static int c1e_detected;
+
+void c1e_remove_cpu(int cpu)
+{
+	cpu_clear(cpu, c1e_mask);
+}
+
 /*
  * C1E aware idle routine. We check for C1E active in the interrupt
  * pending message MSR. If we detect C1E, then we handle it the same
@@ -253,9 +261,6 @@ static int __cpuinit check_c1e_idle(const struct cpuinfo_x86 *c)
  */
 static void c1e_idle(void)
 {
-	static cpumask_t c1e_mask = CPU_MASK_NONE;
-	static int c1e_detected;
-
 	if (need_resched())
 		return;
 
@@ -265,8 +270,10 @@ static void c1e_idle(void)
 		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
 		if (lo & K8_INTP_C1E_ACTIVE_MASK) {
 			c1e_detected = 1;
-			mark_tsc_unstable("TSC halt in C1E");
-			printk(KERN_INFO "System has C1E enabled\n");
+			if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+				mark_tsc_unstable("TSC halt in AMD C1E");
+			printk(KERN_INFO "System has AMD C1E enabled\n");
+			set_cpu_cap(&boot_cpu_data, X86_FEATURE_AMDC1E);
 		}
 	}
 
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 3b7a1dd..4b3cfdf 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -88,6 +88,7 @@ static void cpu_exit_clear(void)
 	cpu_clear(cpu, cpu_callin_map);
 
 	numa_remove_cpu(cpu);
+	c1e_remove_cpu(cpu);
 }
 
 /* We don't actually take CPU down, just spin without interrupts. */
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 71553b6..e12e0e4 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -93,6 +93,8 @@ DECLARE_PER_CPU(int, cpu_state);
 static inline void play_dead(void)
 {
 	idle_task_exit();
+	c1e_remove_cpu(raw_smp_processor_id());
+
 	mb();
 	/* Ack it */
 	__get_cpu_var(cpu_state) = CPU_DEAD;
diff --git a/include/asm-x86/acpi.h b/include/asm-x86/acpi.h
index 635d764..35d1743 100644
--- a/include/asm-x86/acpi.h
+++ b/include/asm-x86/acpi.h
@@ -140,6 +140,8 @@ static inline unsigned int acpi_processor_cstate_check(unsigned int max_cstate)
 	    boot_cpu_data.x86_model <= 0x05 &&
 	    boot_cpu_data.x86_mask < 0x0A)
 		return 1;
+	else if (boot_cpu_has(X86_FEATURE_AMDC1E))
+		return 1;
 	else
 		return max_cstate;
 }
diff --git a/include/asm-x86/cpufeature.h b/include/asm-x86/cpufeature.h
index 9489283..cfcfb0a 100644
--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -81,6 +81,7 @@
 #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* Lfence synchronizes RDTSC */
 #define X86_FEATURE_11AP	(3*32+19) /* Bad local APIC aka 11AP */
 #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
+#define X86_FEATURE_AMDC1E	(3*32+21) /* AMD C1E detected */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
diff --git a/include/asm-x86/idle.h b/include/asm-x86/idle.h
index d240e5b..cbb6491 100644
--- a/include/asm-x86/idle.h
+++ b/include/asm-x86/idle.h
@@ -10,4 +10,6 @@ void idle_notifier_register(struct notifier_block *n);
 void enter_idle(void);
 void exit_idle(void);
 
+void c1e_remove_cpu(int cpu);
+
 #endif
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f1f3eee..bd70345 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -235,7 +235,7 @@ static void tick_do_broadcast_on_off(void *why)
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
 		if (!cpu_isset(cpu, tick_broadcast_mask)) {
 			cpu_set(cpu, tick_broadcast_mask);
-			if (td->mode == TICKDEV_MODE_PERIODIC)
+			if (bc->mode == TICKDEV_MODE_PERIODIC)
 				clockevents_shutdown(dev);
 		}
 		if (*reason == CLOCK_EVT_NOTIFY_BROADCAST_FORCE)
@@ -245,7 +245,7 @@ static void tick_do_broadcast_on_off(void *why)
 		if (!tick_broadcast_force &&
 		    cpu_isset(cpu, tick_broadcast_mask)) {
 			cpu_clear(cpu, tick_broadcast_mask);
-			if (td->mode == TICKDEV_MODE_PERIODIC)
+			if (bc->mode == TICKDEV_MODE_PERIODIC)
 				tick_setup_periodic(dev, 0);
 		}
 		break;
@@ -575,4 +575,12 @@ void tick_shutdown_broadcast_oneshot(unsigned int *cpup)
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
+/*
+ * Check, whether the broadcast device is in one shot mode
+ */
+int tick_broadcast_oneshot_active(void)
+{
+	return tick_broadcast_device.mode == TICKDEV_MODE_ONESHOT;
+}
+
 #endif
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 019315e..df12434 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -33,7 +33,7 @@ DEFINE_PER_CPU(struct tick_device, tick_cpu_device);
  */
 ktime_t tick_next_period;
 ktime_t tick_period;
-int tick_do_timer_cpu __read_mostly = -1;
+int tick_do_timer_cpu __read_mostly = TICK_DO_TIMER_BOOT;
 DEFINE_SPINLOCK(tick_device_lock);
 
 /*
@@ -109,7 +109,8 @@ void tick_setup_periodic(struct clock_event_device *dev, int broadcast)
 	if (!tick_device_is_functional(dev))
 		return;
 
-	if (dev->features & CLOCK_EVT_FEAT_PERIODIC) {
+	if ((dev->features & CLOCK_EVT_FEAT_PERIODIC) &&
+	    !tick_broadcast_oneshot_active()) {
 		clockevents_set_mode(dev, CLOCK_EVT_MODE_PERIODIC);
 	} else {
 		unsigned long seq;
@@ -148,7 +149,7 @@ static void tick_setup_device(struct tick_device *td,
 		 * If no cpu took the do_timer update, assign it to
 		 * this cpu:
 		 */
-		if (tick_do_timer_cpu == -1) {
+		if (tick_do_timer_cpu == TICK_DO_TIMER_BOOT) {
 			tick_do_timer_cpu = cpu;
 			tick_next_period = ktime_get();
 			tick_period = ktime_set(0, NSEC_PER_SEC / HZ);
@@ -300,7 +301,8 @@ static void tick_shutdown(unsigned int *cpup)
 	if (*cpup == tick_do_timer_cpu) {
 		int cpu = first_cpu(cpu_online_map);
 
-		tick_do_timer_cpu = (cpu != NR_CPUS) ? cpu : -1;
+		tick_do_timer_cpu = (cpu != NR_CPUS) ? cpu :
+			TICK_DO_TIMER_NONE;
 	}
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 }
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 6e9db97..4692487 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -1,6 +1,10 @@
 /*
  * tick internal variable and functions used by low/high res code
  */
+
+#define TICK_DO_TIMER_NONE	-1
+#define TICK_DO_TIMER_BOOT	-2
+
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 extern spinlock_t tick_device_lock;
 extern ktime_t tick_next_period;
@@ -31,6 +35,7 @@ extern void tick_broadcast_oneshot_control(unsigned long reason);
 extern void tick_broadcast_switch_to_oneshot(void);
 extern void tick_shutdown_broadcast_oneshot(unsigned int *cpup);
 extern int tick_resume_broadcast_oneshot(struct clock_event_device *bc);
+extern int tick_broadcast_oneshot_active(void);
 # else /* BROADCAST */
 static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
@@ -39,6 +44,7 @@ static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 static inline void tick_broadcast_oneshot_control(unsigned long reason) { }
 static inline void tick_broadcast_switch_to_oneshot(void) { }
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
+static inline int tick_broadcast_oneshot_active(void) { return 0; }
 # endif /* !BROADCAST */
 
 #else /* !ONESHOT */
@@ -68,6 +74,7 @@ static inline int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 {
 	return 0;
 }
+static inline int tick_broadcast_oneshot_active(void) { return 0; }
 #endif /* !TICK_ONESHOT */
 
 /*
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a87b046..39019b3 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -75,6 +75,9 @@ static void tick_do_update_jiffies64(ktime_t now)
 							   incr * ticks);
 		}
 		do_timer(++ticks);
+
+		/* Keep the tick_next_period variable up to date */
+		tick_next_period = ktime_add(last_jiffies_update, tick_period);
 	}
 	write_sequnlock(&xtime_lock);
 }
@@ -221,7 +224,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	 */
 	if (unlikely(!cpu_online(cpu))) {
 		if (cpu == tick_do_timer_cpu)
-			tick_do_timer_cpu = -1;
+			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
 	}
 
 	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
@@ -303,7 +306,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 		 * invoked.
 		 */
 		if (cpu == tick_do_timer_cpu)
-			tick_do_timer_cpu = -1;
+			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
 
 		ts->idle_sleeps++;
 
@@ -468,7 +471,7 @@ static void tick_nohz_handler(struct clock_event_device *dev)
 	 * this duty, then the jiffies update is still serialized by
 	 * xtime_lock.
 	 */
-	if (unlikely(tick_do_timer_cpu == -1))
+	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
 		tick_do_timer_cpu = cpu;
 
 	/* Check, if the jiffies need an update */
@@ -570,7 +573,7 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 	 * this duty, then the jiffies update is still serialized by
 	 * xtime_lock.
 	 */
-	if (unlikely(tick_do_timer_cpu == -1))
+	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
 		tick_do_timer_cpu = cpu;
 #endif
 
