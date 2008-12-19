Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbYLSQDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbYLSQDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYLSQBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:01:51 -0500
Received: from relay1.sgi.com ([192.48.179.29]:59235 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751260AbYLSQBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:01:47 -0500
Message-Id: <20081219160145.144162000@polaris-admin.engr.sgi.com>
References: <20081219160144.697518000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 08:01:47 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/8] cpumask: convert kernel time functions
Content-Disposition: inline; filename=cpumask:convert-kernel_time.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Reduce stack usage, use new cpumask API.

Convert kernel/time functions to use struct cpumask *.

Note the ugly bitmap declarations in tick-broadcast.c.  These should
be cpumask_var_t, but there was no obvious initialization function to
put the alloc_cpumask_var() calls in.  This was safe.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/tick.h         |    4 -
 kernel/time/clocksource.c    |    9 +--
 kernel/time/tick-broadcast.c |  115 ++++++++++++++++++++++---------------------
 kernel/time/tick-common.c    |    6 +-
 4 files changed, 69 insertions(+), 65 deletions(-)

--- linux-2.6-for-ingo.orig/include/linux/tick.h
+++ linux-2.6-for-ingo/include/linux/tick.h
@@ -84,10 +84,10 @@ static inline void tick_cancel_sched_tim
 
 # ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 extern struct tick_device *tick_get_broadcast_device(void);
-extern cpumask_t *tick_get_broadcast_mask(void);
+extern struct cpumask *tick_get_broadcast_mask(void);
 
 #  ifdef CONFIG_TICK_ONESHOT
-extern cpumask_t *tick_get_broadcast_oneshot_mask(void);
+extern struct cpumask *tick_get_broadcast_oneshot_mask(void);
 #  endif
 
 # endif /* BROADCAST */
--- linux-2.6-for-ingo.orig/kernel/time/clocksource.c
+++ linux-2.6-for-ingo/kernel/time/clocksource.c
@@ -145,10 +145,11 @@ static void clocksource_watchdog(unsigne
 		 * Cycle through CPUs to check if the CPUs stay
 		 * synchronized to each other.
 		 */
-		int next_cpu = next_cpu_nr(raw_smp_processor_id(), cpu_online_map);
+		int next_cpu = cpumask_next(raw_smp_processor_id(),
+					    cpu_online_mask);
 
 		if (next_cpu >= nr_cpu_ids)
-			next_cpu = first_cpu(cpu_online_map);
+			next_cpu = cpumask_first(cpu_online_mask);
 		watchdog_timer.expires += WATCHDOG_INTERVAL;
 		add_timer_on(&watchdog_timer, next_cpu);
 	}
@@ -173,7 +174,7 @@ static void clocksource_check_watchdog(s
 			watchdog_last = watchdog->read();
 			watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
 			add_timer_on(&watchdog_timer,
-				     first_cpu(cpu_online_map));
+				     cpumask_first(cpu_online_mask));
 		}
 	} else {
 		if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS)
@@ -195,7 +196,7 @@ static void clocksource_check_watchdog(s
 				watchdog_timer.expires =
 					jiffies + WATCHDOG_INTERVAL;
 				add_timer_on(&watchdog_timer,
-					     first_cpu(cpu_online_map));
+					     cpumask_first(cpu_online_mask));
 			}
 		}
 	}
--- linux-2.6-for-ingo.orig/kernel/time/tick-broadcast.c
+++ linux-2.6-for-ingo/kernel/time/tick-broadcast.c
@@ -28,7 +28,9 @@
  */
 
 struct tick_device tick_broadcast_device;
-static cpumask_t tick_broadcast_mask;
+/* FIXME: Use cpumask_var_t. */
+static DECLARE_BITMAP(tick_broadcast_mask, CONFIG_NR_CPUS);
+static DECLARE_BITMAP(tmpmask, CONFIG_NR_CPUS);
 static DEFINE_SPINLOCK(tick_broadcast_lock);
 static int tick_broadcast_force;
 
@@ -46,9 +48,9 @@ struct tick_device *tick_get_broadcast_d
 	return &tick_broadcast_device;
 }
 
-cpumask_t *tick_get_broadcast_mask(void)
+struct cpumask *tick_get_broadcast_mask(void)
 {
-	return &tick_broadcast_mask;
+	return to_cpumask(tick_broadcast_mask);
 }
 
 /*
@@ -72,7 +74,7 @@ int tick_check_broadcast_device(struct c
 
 	clockevents_exchange_device(NULL, dev);
 	tick_broadcast_device.evtdev = dev;
-	if (!cpus_empty(tick_broadcast_mask))
+	if (!cpumask_empty(tick_get_broadcast_mask()))
 		tick_broadcast_start_periodic(dev);
 	return 1;
 }
@@ -104,7 +106,7 @@ int tick_device_uses_broadcast(struct cl
 	 */
 	if (!tick_device_is_functional(dev)) {
 		dev->event_handler = tick_handle_periodic;
-		cpu_set(cpu, tick_broadcast_mask);
+		cpumask_set_cpu(cpu, tick_get_broadcast_mask());
 		tick_broadcast_start_periodic(tick_broadcast_device.evtdev);
 		ret = 1;
 	} else {
@@ -116,7 +118,7 @@ int tick_device_uses_broadcast(struct cl
 		if (!(dev->features & CLOCK_EVT_FEAT_C3STOP)) {
 			int cpu = smp_processor_id();
 
-			cpu_clear(cpu, tick_broadcast_mask);
+			cpumask_clear_cpu(cpu, tick_get_broadcast_mask());
 			tick_broadcast_clear_oneshot(cpu);
 		}
 	}
@@ -125,9 +127,9 @@ int tick_device_uses_broadcast(struct cl
 }
 
 /*
- * Broadcast the event to the cpus, which are set in the mask
+ * Broadcast the event to the cpus, which are set in the mask (mangled).
  */
-static void tick_do_broadcast(cpumask_t mask)
+static void tick_do_broadcast(struct cpumask *mask)
 {
 	int cpu = smp_processor_id();
 	struct tick_device *td;
@@ -135,22 +137,21 @@ static void tick_do_broadcast(cpumask_t 
 	/*
 	 * Check, if the current cpu is in the mask
 	 */
-	if (cpu_isset(cpu, mask)) {
-		cpu_clear(cpu, mask);
+	if (cpumask_test_cpu(cpu, mask)) {
+		cpumask_clear_cpu(cpu, mask);
 		td = &per_cpu(tick_cpu_device, cpu);
 		td->evtdev->event_handler(td->evtdev);
 	}
 
-	if (!cpus_empty(mask)) {
+	if (!cpumask_empty(mask)) {
 		/*
 		 * It might be necessary to actually check whether the devices
 		 * have different broadcast functions. For now, just use the
 		 * one of the first device. This works as long as we have this
 		 * misfeature only on x86 (lapic)
 		 */
-		cpu = first_cpu(mask);
-		td = &per_cpu(tick_cpu_device, cpu);
-		td->evtdev->broadcast(&mask);
+		td = &per_cpu(tick_cpu_device, cpumask_first(mask));
+		td->evtdev->broadcast(mask);
 	}
 }
 
@@ -160,12 +161,11 @@ static void tick_do_broadcast(cpumask_t 
  */
 static void tick_do_periodic_broadcast(void)
 {
-	cpumask_t mask;
-
 	spin_lock(&tick_broadcast_lock);
 
-	cpus_and(mask, cpu_online_map, tick_broadcast_mask);
-	tick_do_broadcast(mask);
+	cpumask_and(to_cpumask(tmpmask),
+		    cpu_online_mask, tick_get_broadcast_mask());
+	tick_do_broadcast(to_cpumask(tmpmask));
 
 	spin_unlock(&tick_broadcast_lock);
 }
@@ -228,13 +228,13 @@ static void tick_do_broadcast_on_off(voi
 	if (!tick_device_is_functional(dev))
 		goto out;
 
-	bc_stopped = cpus_empty(tick_broadcast_mask);
+	bc_stopped = cpumask_empty(tick_get_broadcast_mask());
 
 	switch (*reason) {
 	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
-		if (!cpu_isset(cpu, tick_broadcast_mask)) {
-			cpu_set(cpu, tick_broadcast_mask);
+		if (!cpumask_test_cpu(cpu, tick_get_broadcast_mask())) {
+			cpumask_set_cpu(cpu, tick_get_broadcast_mask());
 			if (tick_broadcast_device.mode ==
 			    TICKDEV_MODE_PERIODIC)
 				clockevents_shutdown(dev);
@@ -244,8 +244,8 @@ static void tick_do_broadcast_on_off(voi
 		break;
 	case CLOCK_EVT_NOTIFY_BROADCAST_OFF:
 		if (!tick_broadcast_force &&
-		    cpu_isset(cpu, tick_broadcast_mask)) {
-			cpu_clear(cpu, tick_broadcast_mask);
+		    cpumask_test_cpu(cpu, tick_get_broadcast_mask())) {
+			cpumask_clear_cpu(cpu, tick_get_broadcast_mask());
 			if (tick_broadcast_device.mode ==
 			    TICKDEV_MODE_PERIODIC)
 				tick_setup_periodic(dev, 0);
@@ -253,7 +253,7 @@ static void tick_do_broadcast_on_off(voi
 		break;
 	}
 
-	if (cpus_empty(tick_broadcast_mask)) {
+	if (cpumask_empty(tick_get_broadcast_mask())) {
 		if (!bc_stopped)
 			clockevents_shutdown(bc);
 	} else if (bc_stopped) {
@@ -272,7 +272,7 @@ out:
  */
 void tick_broadcast_on_off(unsigned long reason, int *oncpu)
 {
-	if (!cpu_isset(*oncpu, cpu_online_map))
+	if (!cpumask_test_cpu(*oncpu, cpu_online_mask))
 		printk(KERN_ERR "tick-broadcast: ignoring broadcast for "
 		       "offline CPU #%d\n", *oncpu);
 	else
@@ -303,10 +303,10 @@ void tick_shutdown_broadcast(unsigned in
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
 
 	bc = tick_broadcast_device.evtdev;
-	cpu_clear(cpu, tick_broadcast_mask);
+	cpumask_clear_cpu(cpu, tick_get_broadcast_mask());
 
 	if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC) {
-		if (bc && cpus_empty(tick_broadcast_mask))
+		if (bc && cpumask_empty(tick_get_broadcast_mask()))
 			clockevents_shutdown(bc);
 	}
 
@@ -342,10 +342,10 @@ int tick_resume_broadcast(void)
 
 		switch (tick_broadcast_device.mode) {
 		case TICKDEV_MODE_PERIODIC:
-			if(!cpus_empty(tick_broadcast_mask))
+			if (!cpumask_empty(tick_get_broadcast_mask()))
 				tick_broadcast_start_periodic(bc);
-			broadcast = cpu_isset(smp_processor_id(),
-					      tick_broadcast_mask);
+			broadcast = cpumask_test_cpu(smp_processor_id(),
+						     tick_get_broadcast_mask());
 			break;
 		case TICKDEV_MODE_ONESHOT:
 			broadcast = tick_resume_broadcast_oneshot(bc);
@@ -360,14 +360,15 @@ int tick_resume_broadcast(void)
 
 #ifdef CONFIG_TICK_ONESHOT
 
-static cpumask_t tick_broadcast_oneshot_mask;
+/* FIXME: use cpumask_var_t. */
+static DECLARE_BITMAP(tick_broadcast_oneshot_mask, CONFIG_NR_CPUS);
 
 /*
- * Debugging: see timer_list.c
+ * Exposed for debugging: see timer_list.c
  */
-cpumask_t *tick_get_broadcast_oneshot_mask(void)
+struct cpumask *tick_get_broadcast_oneshot_mask(void)
 {
-	return &tick_broadcast_oneshot_mask;
+	return to_cpumask(tick_broadcast_oneshot_mask);
 }
 
 static int tick_broadcast_set_event(ktime_t expires, int force)
@@ -389,7 +390,7 @@ int tick_resume_broadcast_oneshot(struct
  */
 void tick_check_oneshot_broadcast(int cpu)
 {
-	if (cpu_isset(cpu, tick_broadcast_oneshot_mask)) {
+	if (cpumask_test_cpu(cpu, to_cpumask(tick_broadcast_oneshot_mask))) {
 		struct tick_device *td = &per_cpu(tick_cpu_device, cpu);
 
 		clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_ONESHOT);
@@ -402,7 +403,6 @@ void tick_check_oneshot_broadcast(int cp
 static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
 {
 	struct tick_device *td;
-	cpumask_t mask;
 	ktime_t now, next_event;
 	int cpu;
 
@@ -410,13 +410,13 @@ static void tick_handle_oneshot_broadcas
 again:
 	dev->next_event.tv64 = KTIME_MAX;
 	next_event.tv64 = KTIME_MAX;
-	mask = CPU_MASK_NONE;
+	cpumask_clear(to_cpumask(tmpmask));
 	now = ktime_get();
 	/* Find all expired events */
-	for_each_cpu_mask_nr(cpu, tick_broadcast_oneshot_mask) {
+	for_each_cpu(cpu, tick_get_broadcast_oneshot_mask()) {
 		td = &per_cpu(tick_cpu_device, cpu);
 		if (td->evtdev->next_event.tv64 <= now.tv64)
-			cpu_set(cpu, mask);
+			cpumask_set_cpu(cpu, to_cpumask(tmpmask));
 		else if (td->evtdev->next_event.tv64 < next_event.tv64)
 			next_event.tv64 = td->evtdev->next_event.tv64;
 	}
@@ -424,7 +424,7 @@ again:
 	/*
 	 * Wakeup the cpus which have an expired event.
 	 */
-	tick_do_broadcast(mask);
+	tick_do_broadcast(to_cpumask(tmpmask));
 
 	/*
 	 * Two reasons for reprogram:
@@ -476,15 +476,16 @@ void tick_broadcast_oneshot_control(unsi
 		goto out;
 
 	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
-		if (!cpu_isset(cpu, tick_broadcast_oneshot_mask)) {
-			cpu_set(cpu, tick_broadcast_oneshot_mask);
+		if (!cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
+			cpumask_set_cpu(cpu, tick_get_broadcast_oneshot_mask());
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
 			if (dev->next_event.tv64 < bc->next_event.tv64)
 				tick_broadcast_set_event(dev->next_event, 1);
 		}
 	} else {
-		if (cpu_isset(cpu, tick_broadcast_oneshot_mask)) {
-			cpu_clear(cpu, tick_broadcast_oneshot_mask);
+		if (cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
+			cpumask_clear_cpu(cpu,
+					  tick_get_broadcast_oneshot_mask());
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
 			if (dev->next_event.tv64 != KTIME_MAX)
 				tick_program_event(dev->next_event, 1);
@@ -502,15 +503,16 @@ out:
  */
 static void tick_broadcast_clear_oneshot(int cpu)
 {
-	cpu_clear(cpu, tick_broadcast_oneshot_mask);
+	cpumask_clear_cpu(cpu, tick_get_broadcast_oneshot_mask());
 }
 
-static void tick_broadcast_init_next_event(cpumask_t *mask, ktime_t expires)
+static void tick_broadcast_init_next_event(struct cpumask *mask,
+					   ktime_t expires)
 {
 	struct tick_device *td;
 	int cpu;
 
-	for_each_cpu_mask_nr(cpu, *mask) {
+	for_each_cpu(cpu, mask) {
 		td = &per_cpu(tick_cpu_device, cpu);
 		if (td->evtdev)
 			td->evtdev->next_event = expires;
@@ -526,7 +528,6 @@ void tick_broadcast_setup_oneshot(struct
 	if (bc->event_handler != tick_handle_oneshot_broadcast) {
 		int was_periodic = bc->mode == CLOCK_EVT_MODE_PERIODIC;
 		int cpu = smp_processor_id();
-		cpumask_t mask;
 
 		bc->event_handler = tick_handle_oneshot_broadcast;
 		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
@@ -540,13 +541,15 @@ void tick_broadcast_setup_oneshot(struct
 		 * oneshot_mask bits for those and program the
 		 * broadcast device to fire.
 		 */
-		mask = tick_broadcast_mask;
-		cpu_clear(cpu, mask);
-		cpus_or(tick_broadcast_oneshot_mask,
-			tick_broadcast_oneshot_mask, mask);
-
-		if (was_periodic && !cpus_empty(mask)) {
-			tick_broadcast_init_next_event(&mask, tick_next_period);
+		cpumask_copy(to_cpumask(tmpmask), tick_get_broadcast_mask());
+		cpumask_clear_cpu(cpu, to_cpumask(tmpmask));
+		cpumask_or(tick_get_broadcast_oneshot_mask(),
+			   tick_get_broadcast_oneshot_mask(),
+			   to_cpumask(tmpmask));
+
+		if (was_periodic && !cpumask_empty(to_cpumask(tmpmask))) {
+			tick_broadcast_init_next_event(to_cpumask(tmpmask),
+						       tick_next_period);
 			tick_broadcast_set_event(tick_next_period, 1);
 		} else
 			bc->next_event.tv64 = KTIME_MAX;
@@ -585,7 +588,7 @@ void tick_shutdown_broadcast_oneshot(uns
 	 * Clear the broadcast mask flag for the dead cpu, but do not
 	 * stop the broadcast device!
 	 */
-	cpu_clear(cpu, tick_broadcast_oneshot_mask);
+	cpumask_clear_cpu(cpu, tick_get_broadcast_oneshot_mask());
 
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
--- linux-2.6-for-ingo.orig/kernel/time/tick-common.c
+++ linux-2.6-for-ingo/kernel/time/tick-common.c
@@ -254,7 +254,7 @@ static int tick_check_new_device(struct 
 		curdev = NULL;
 	}
 	clockevents_exchange_device(curdev, newdev);
-	tick_setup_device(td, newdev, cpu, &cpumask_of_cpu(cpu));
+	tick_setup_device(td, newdev, cpu, cpumask_of(cpu));
 	if (newdev->features & CLOCK_EVT_FEAT_ONESHOT)
 		tick_oneshot_notify();
 
@@ -299,9 +299,9 @@ static void tick_shutdown(unsigned int *
 	}
 	/* Transfer the do_timer job away from this cpu */
 	if (*cpup == tick_do_timer_cpu) {
-		int cpu = first_cpu(cpu_online_map);
+		int cpu = cpumask_first(cpu_online_mask);
 
-		tick_do_timer_cpu = (cpu != NR_CPUS) ? cpu :
+		tick_do_timer_cpu = (cpu < nr_cpu_ids) ? cpu :
 			TICK_DO_TIMER_NONE;
 	}
 	spin_unlock_irqrestore(&tick_device_lock, flags);

-- 
