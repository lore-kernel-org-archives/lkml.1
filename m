Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbYI2SKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbYI2SKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbYI2SDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:25 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54349 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754008AbYI2SCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:54 -0400
Message-Id: <20080929180253.799091000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:03:17 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 27/31] cpumask: clean time files
Content-Disposition: inline; filename=clean-time
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/hpet.c       |    4 ++--
 arch/x86/kernel/i8253.c      |    2 +-
 arch/x86/kernel/time_64.c    |    2 +-
 include/linux/clockchips.h   |    4 ++--
 include/linux/tick.h         |    4 ++--
 kernel/time/clocksource.c    |    2 +-
 kernel/time/tick-broadcast.c |   26 +++++++++++++-------------
 kernel/time/tick-common.c    |    6 +++---
 8 files changed, 25 insertions(+), 25 deletions(-)

--- struct-cpumasks.orig/arch/x86/kernel/hpet.c
+++ struct-cpumasks/arch/x86/kernel/hpet.c
@@ -265,7 +265,7 @@ static void hpet_legacy_clockevent_regis
 	 * Start hpet with the boot cpu mask and make it
 	 * global after the IO_APIC has been initialized.
 	 */
-	hpet_clockevent.cpumask = cpumask_of_cpu(smp_processor_id());
+	cpus_copy(hpet_clockevent.cpumask, cpumask_of_cpu(smp_processor_id()));
 	clockevents_register_device(&hpet_clockevent);
 	global_clock_event = &hpet_clockevent;
 	printk(KERN_DEBUG "hpet clockevent registered\n");
@@ -512,7 +512,7 @@ static void init_one_hpet_msi_clockevent
 	/* 5 usec minimum reprogramming delta. */
 	evt->min_delta_ns = 5000;
 
-	evt->cpumask = cpumask_of_cpu(hdev->cpu);
+	cpus_copy(evt->cpumask, cpumask_of_cpu(hdev->cpu));
 	clockevents_register_device(evt);
 }
 
--- struct-cpumasks.orig/arch/x86/kernel/i8253.c
+++ struct-cpumasks/arch/x86/kernel/i8253.c
@@ -114,7 +114,7 @@ void __init setup_pit_timer(void)
 	 * Start pit with the boot cpu mask and make it global after the
 	 * IO_APIC has been initialized.
 	 */
-	pit_clockevent.cpumask = cpumask_of_cpu(smp_processor_id());
+	cpus_copy(pit_clockevent.cpumask, cpumask_of_cpu(smp_processor_id()));
 	pit_clockevent.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC,
 				     pit_clockevent.shift);
 	pit_clockevent.max_delta_ns =
--- struct-cpumasks.orig/arch/x86/kernel/time_64.c
+++ struct-cpumasks/arch/x86/kernel/time_64.c
@@ -125,7 +125,7 @@ void __init hpet_time_init(void)
 		setup_pit_timer();
 	}
 
-	irq0.mask = cpumask_of_cpu(0);
+	cpus_copy(irq0.mask, cpumask_of_cpu(0));
 	setup_irq(0, &irq0);
 }
 
--- struct-cpumasks.orig/include/linux/clockchips.h
+++ struct-cpumasks/include/linux/clockchips.h
@@ -82,13 +82,13 @@ struct clock_event_device {
 	int			shift;
 	int			rating;
 	int			irq;
-	cpumask_t		cpumask;
+	cpumask_map_t		cpumask;
 	int			(*set_next_event)(unsigned long evt,
 						  struct clock_event_device *);
 	void			(*set_mode)(enum clock_event_mode mode,
 					    struct clock_event_device *);
 	void			(*event_handler)(struct clock_event_device *);
-	void			(*broadcast)(cpumask_t mask);
+	void			(*broadcast)(const_cpumask_t mask);
 	struct list_head	list;
 	enum clock_event_mode	mode;
 	ktime_t			next_event;
--- struct-cpumasks.orig/include/linux/tick.h
+++ struct-cpumasks/include/linux/tick.h
@@ -84,10 +84,10 @@ static inline void tick_cancel_sched_tim
 
 # ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 extern struct tick_device *tick_get_broadcast_device(void);
-extern cpumask_t *tick_get_broadcast_mask(void);
+extern const_cpumask_t tick_get_broadcast_mask(void);
 
 #  ifdef CONFIG_TICK_ONESHOT
-extern cpumask_t *tick_get_broadcast_oneshot_mask(void);
+extern const_cpumask_t tick_get_broadcast_oneshot_mask(void);
 #  endif
 
 # endif /* BROADCAST */
--- struct-cpumasks.orig/kernel/time/clocksource.c
+++ struct-cpumasks/kernel/time/clocksource.c
@@ -157,7 +157,7 @@ static void clocksource_watchdog(unsigne
 		if (next_cpu >= nr_cpu_ids)
 			next_cpu = cpus_first(cpu_online_map);
 		watchdog_timer.expires += WATCHDOG_INTERVAL;
-		add_timer_on(&watchdog_timer, cpus_next);
+		add_timer_on(&watchdog_timer, next_cpu);
 	}
 	spin_unlock(&watchdog_lock);
 }
--- struct-cpumasks.orig/kernel/time/tick-broadcast.c
+++ struct-cpumasks/kernel/time/tick-broadcast.c
@@ -28,7 +28,7 @@
  */
 
 struct tick_device tick_broadcast_device;
-static cpumask_t tick_broadcast_mask;
+static cpumask_map_t tick_broadcast_mask;
 static DEFINE_SPINLOCK(tick_broadcast_lock);
 static int tick_broadcast_force;
 
@@ -46,9 +46,9 @@ struct tick_device *tick_get_broadcast_d
 	return &tick_broadcast_device;
 }
 
-cpumask_t *tick_get_broadcast_mask(void)
+const_cpumask_t tick_get_broadcast_mask(void)
 {
-	return &tick_broadcast_mask;
+	return (const_cpumask_t)tick_broadcast_mask;
 }
 
 /*
@@ -160,7 +160,7 @@ static void tick_do_broadcast(cpumask_t 
  */
 static void tick_do_periodic_broadcast(void)
 {
-	cpumask_t mask;
+	cpumask_var_t mask;
 
 	spin_lock(&tick_broadcast_lock);
 
@@ -364,9 +364,9 @@ static cpumask_t tick_broadcast_oneshot_
 /*
  * Debugging: see timer_list.c
  */
-cpumask_t *tick_get_broadcast_oneshot_mask(void)
+const_cpumask_t tick_get_broadcast_oneshot_mask(void)
 {
-	return &tick_broadcast_oneshot_mask;
+	return (const_cpumask_t)tick_broadcast_oneshot_mask;
 }
 
 static int tick_broadcast_set_event(ktime_t expires, int force)
@@ -388,7 +388,7 @@ int tick_resume_broadcast_oneshot(struct
 static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
 {
 	struct tick_device *td;
-	cpumask_t mask;
+	cpumask_var_t mask;
 	ktime_t now, next_event;
 	int cpu;
 
@@ -396,7 +396,7 @@ static void tick_handle_oneshot_broadcas
 again:
 	dev->next_event.tv64 = KTIME_MAX;
 	next_event.tv64 = KTIME_MAX;
-	mask = CPU_MASK_NONE;
+	cpus_clear(mask);
 	now = ktime_get();
 	/* Find all expired events */
 	for_each_cpu(cpu, tick_broadcast_oneshot_mask) {
@@ -491,12 +491,12 @@ static void tick_broadcast_clear_oneshot
 	cpu_clear(cpu, tick_broadcast_oneshot_mask);
 }
 
-static void tick_broadcast_init_next_event(cpumask_t *mask, ktime_t expires)
+static void tick_broadcast_init_next_event(const_cpumask_t mask, ktime_t expires)
 {
 	struct tick_device *td;
 	int cpu;
 
-	for_each_cpu(cpu, *mask) {
+	for_each_cpu(cpu, mask) {
 		td = &per_cpu(tick_cpu_device, cpu);
 		if (td->evtdev)
 			td->evtdev->next_event = expires;
@@ -512,7 +512,7 @@ void tick_broadcast_setup_oneshot(struct
 	if (bc->event_handler != tick_handle_oneshot_broadcast) {
 		int was_periodic = bc->mode == CLOCK_EVT_MODE_PERIODIC;
 		int cpu = smp_processor_id();
-		cpumask_t mask;
+		cpumask_var_t mask;
 
 		bc->event_handler = tick_handle_oneshot_broadcast;
 		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
@@ -526,13 +526,13 @@ void tick_broadcast_setup_oneshot(struct
 		 * oneshot_mask bits for those and program the
 		 * broadcast device to fire.
 		 */
-		mask = tick_broadcast_mask;
+		cpus_copy(mask, tick_broadcast_mask);
 		cpu_clear(cpu, mask);
 		cpus_or(tick_broadcast_oneshot_mask,
 			tick_broadcast_oneshot_mask, mask);
 
 		if (was_periodic && !cpus_empty(mask)) {
-			tick_broadcast_init_next_event(&mask, tick_next_period);
+			tick_broadcast_init_next_event(mask, tick_next_period);
 			tick_broadcast_set_event(tick_next_period, 1);
 		} else
 			bc->next_event.tv64 = KTIME_MAX;
--- struct-cpumasks.orig/kernel/time/tick-common.c
+++ struct-cpumasks/kernel/time/tick-common.c
@@ -136,7 +136,7 @@ void tick_setup_periodic(struct clock_ev
  */
 static void tick_setup_device(struct tick_device *td,
 			      struct clock_event_device *newdev, int cpu,
-			      const cpumask_t *cpumask)
+			      const_cpumask_t cpumask)
 {
 	ktime_t next_event;
 	void (*handler)(struct clock_event_device *) = NULL;
@@ -171,8 +171,8 @@ static void tick_setup_device(struct tic
 	 * When the device is not per cpu, pin the interrupt to the
 	 * current cpu:
 	 */
-	if (!cpus_equal(newdev->cpumask, *cpumask))
-		irq_set_affinity(newdev->irq, *cpumask);
+	if (!cpus_equal(newdev->cpumask, cpumask))
+		irq_set_affinity(newdev->irq, cpumask);
 
 	/*
 	 * When global broadcasting is active, check if the current

-- 
