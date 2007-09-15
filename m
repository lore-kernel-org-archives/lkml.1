Return-Path: <linux-kernel-owner+w=401wt.eu-S1760384AbXIOJt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760384AbXIOJt5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 05:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbXIOJtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 05:49:50 -0400
Received: from www.osadl.org ([213.239.205.134]:53730 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753238AbXIOJtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 05:49:49 -0400
Subject: Re: cpu hotplug support broken in 2.6.23-rc3
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Chua <jeff.chua.linux@gmail.com>,
       rusty@rustycorp.com.au, vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       kernel list <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
In-Reply-To: <1189775743.3100.9.camel@chaos>
References: <20070827104350.GA2073@elf.ucw.cz>
	 <b6a2187b0708280721w20d5dc44q249642f7946ae55a@mail.gmail.com>
	 <20070903034720.GB3655@ucw.cz> <200709031219.12846.rjw@sisk.pl>
	 <1188822917.3406.0.camel@chaos>
	 <20070904072744.GA30474@atrey.karlin.mff.cuni.cz>
	 <1189713695.3974.23.camel@chaos>  <20070914123816.GE1671@elf.ucw.cz>
	 <1189774257.3100.7.camel@chaos>  <1189775743.3100.9.camel@chaos>
Content-Type: text/plain
Date: Sat, 15 Sep 2007 11:49:41 +0200
Message-Id: <1189849781.4319.5.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel,

On Fri, 2007-09-14 at 15:15 +0200, Thomas Gleixner wrote:
> > Venki sent me an initial patch, but it has issues with the notify
> > ordering. Find below my "cache the broadcast flags" version for testing.
> 
> Hmmpf, the flag is still cleared when the cpu goes offline. Need to take
> a closer look.

I finally tracked it down. There were several ways to turn the box into
a brick. Sigh !

Can you please test the combo patch below ?

The details are available from the for-2.6.23 branch of my hrt git repo:

http://git.kernel.org/?p=linux/kernel/git/tglx/linux-2.6-hrt.git;a=shortlog;h=for-2.6.23

Thanks,

	tglx

Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c	2007-09-15 11:42:09.000000000 +0200
+++ linux-2.6/kernel/time/timekeeping.c	2007-09-15 11:43:03.000000000 +0200
@@ -217,6 +217,7 @@ static void change_clocksource(void)
 }
 #else
 static inline void change_clocksource(void) { }
+static inline s64 __get_nsec_offset(void) { return 0; }
 #endif
 
 /**
@@ -280,6 +281,8 @@ void __init timekeeping_init(void)
 static int timekeeping_suspended;
 /* time in seconds when suspend began */
 static unsigned long timekeeping_suspend_time;
+/* xtime offset when we went into suspend */
+static s64 timekeeping_suspend_nsecs;
 
 /**
  * timekeeping_resume - Resumes the generic timekeeping subsystem.
@@ -305,6 +308,8 @@ static int timekeeping_resume(struct sys
 		wall_to_monotonic.tv_sec -= sleep_length;
 		total_sleep_time += sleep_length;
 	}
+	/* Make sure that we have the correct xtime reference */
+	timespec_add_ns(&xtime, timekeeping_suspend_nsecs);
 	/* re-base the last cycle value */
 	clock->cycle_last = clocksource_read(clock);
 	clock->error = 0;
@@ -325,9 +330,12 @@ static int timekeeping_suspend(struct sy
 {
 	unsigned long flags;
 
+	timekeeping_suspend_time = read_persistent_clock();
+
 	write_seqlock_irqsave(&xtime_lock, flags);
+	/* Get the current xtime offset */
+	timekeeping_suspend_nsecs = __get_nsec_offset();
 	timekeeping_suspended = 1;
-	timekeeping_suspend_time = read_persistent_clock();
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
Index: linux-2.6/drivers/acpi/processor_core.c
===================================================================
--- linux-2.6.orig/drivers/acpi/processor_core.c	2007-09-15 11:42:09.000000000 +0200
+++ linux-2.6/drivers/acpi/processor_core.c	2007-09-15 11:43:03.000000000 +0200
@@ -724,6 +724,25 @@ static void acpi_processor_notify(acpi_h
 	return;
 }
 
+static int acpi_cpu_soft_notify(struct notifier_block *nfb,
+		unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+	struct acpi_processor *pr = processors[cpu];
+
+	if (action == CPU_ONLINE && pr) {
+		acpi_processor_ppc_has_changed(pr);
+		acpi_processor_cst_has_changed(pr);
+		acpi_processor_tstate_has_changed(pr);
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block acpi_cpu_notifier =
+{
+	    .notifier_call = acpi_cpu_soft_notify,
+};
+
 static int acpi_processor_add(struct acpi_device *device)
 {
 	struct acpi_processor *pr = NULL;
@@ -987,6 +1006,7 @@ void acpi_processor_install_hotplug_noti
 			    ACPI_UINT32_MAX,
 			    processor_walk_namespace_cb, &action, NULL);
 #endif
+	register_hotcpu_notifier(&acpi_cpu_notifier);
 }
 
 static
@@ -999,6 +1019,7 @@ void acpi_processor_uninstall_hotplug_no
 			    ACPI_UINT32_MAX,
 			    processor_walk_namespace_cb, &action, NULL);
 #endif
+	unregister_hotcpu_notifier(&acpi_cpu_notifier);
 }
 
 /*
Index: linux-2.6/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-broadcast.c	2007-09-15 11:42:09.000000000 +0200
+++ linux-2.6/kernel/time/tick-broadcast.c	2007-09-15 11:43:03.000000000 +0200
@@ -382,12 +382,23 @@ static int tick_broadcast_set_event(ktim
 
 int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 {
+	int cpu = smp_processor_id();
+
+	/*
+	 * If the CPU is marked for broadcast, enforce oneshot
+	 * broadcast mode. The jinxed VAIO does not resume otherwise.
+	 * No idea why it ends up in a lower C State during resume
+	 * without notifying the clock events layer.
+	 */
+	if (cpu_isset(cpu, tick_broadcast_mask))
+		cpu_set(cpu, tick_broadcast_oneshot_mask);
+
 	clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
 
 	if(!cpus_empty(tick_broadcast_oneshot_mask))
 		tick_broadcast_set_event(ktime_get(), 1);
 
-	return cpu_isset(smp_processor_id(), tick_broadcast_oneshot_mask);
+	return cpu_isset(cpu, tick_broadcast_oneshot_mask);
 }
 
 /*
@@ -549,20 +560,17 @@ void tick_broadcast_switch_to_oneshot(vo
  */
 void tick_shutdown_broadcast_oneshot(unsigned int *cpup)
 {
-	struct clock_event_device *bc;
 	unsigned long flags;
 	unsigned int cpu = *cpup;
 
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
 
-	bc = tick_broadcast_device.evtdev;
+	/*
+	 * Clear the broadcast mask flag for the dead cpu, but do not
+	 * stop the broadcast device!
+	 */
 	cpu_clear(cpu, tick_broadcast_oneshot_mask);
 
-	if (tick_broadcast_device.mode == TICKDEV_MODE_ONESHOT) {
-		if (bc && cpus_empty(tick_broadcast_oneshot_mask))
-			clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
-	}
-
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
Index: linux-2.6/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-sched.c	2007-09-15 11:42:09.000000000 +0200
+++ linux-2.6/kernel/time/tick-sched.c	2007-09-15 11:43:41.000000000 +0200
@@ -160,6 +160,18 @@ void tick_nohz_stop_sched_tick(void)
 	cpu = smp_processor_id();
 	ts = &per_cpu(tick_cpu_sched, cpu);
 
+	/*
+	 * If this cpu is offline and it is the one which updates
+	 * jiffies, then give up the assignment and let it be taken by
+	 * the cpu which runs the tick timer next. If we don't drop
+	 * this here the jiffies might be stale and do_timer() never
+	 * invoked.
+	 */
+	if (unlikely(!cpu_online(cpu))) {
+		if (cpu == tick_do_timer_cpu)
+			tick_do_timer_cpu = -1;
+	}
+
 	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
 		goto end;
 


