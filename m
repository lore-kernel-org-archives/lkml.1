Return-Path: <linux-kernel-owner+w=401wt.eu-S1751775AbXLYXJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbXLYXJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 18:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbXLYXJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 18:09:27 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40661 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751083AbXLYXJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 18:09:26 -0500
Date: Wed, 26 Dec 2007 00:07:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [RFC] sleepy linux
Message-ID: <20071225230731.GA29030@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is RFC. It does not even work for me... it sleeps but it will not
wake up, because SATA wakeup code is missing. Code attached for illustration.

I wonder if this is the right approach? What is right interface to the
drivers?


		Sleepy Linux
		~~~~~~~~~~~~

Copyright 2007 Pavel Machek <pavel@suse.cz>
	  GPLv2

Current Linux versions can enter suspend-to-RAM just fine, but only
can do it on explicit request. But suspend-to-RAM is important, eating
something like 10% of power needed for idle system. Starting suspend
manually is not too convinient; it is not an option on multiuser
machine, and even on single user machine, some things are not easy:

1) Download this big chunk in mozilla, then go to sleep

2) Compile this, then go to sleep

3) You can sleep now, but wake me up in 8:30 with mp3 player

Todays hardware is mostly capable of doing better: with correctly set
up wakeups, machine can sleep and successfully pretend it is not
sleeping -- by waking up whenever something interesting happens. Of
course, it is easier on machines not connected to the network, and on
notebook computers.

Requirements:

0) Working suspend-to-RAM, with kernel being able to bring video back.

1) RTC clock that can wake up system

2) Lid that can wake up a system,
   or keyboard that can wake up system and does not loose keypress
   or special screensaver setup

3) Network card that is either down
   or can wake up system on any packet (and not loose too many packets)



diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 9663c2a..0f65aa9 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -178,6 +178,7 @@ void cpu_idle(void)
 	/* endless idle loop with no priority at all */
 	while (1) {
 		tick_nohz_stop_sched_tick();
+		detect_idle();
 		while (!need_resched()) {
 			void (*idle)(void);
 
diff --git a/drivers/input/input-polldev.c b/drivers/input/input-polldev.c
index 92b3598..83a8046 100644
--- a/drivers/input/input-polldev.c
+++ b/drivers/input/input-polldev.c
@@ -151,7 +151,7 @@ int input_register_polled_device(struct 
 
 	INIT_DELAYED_WORK(&dev->work, input_polled_device_work);
 	if (!dev->poll_interval)
-		dev->poll_interval = 500;
+		dev->poll_interval = 50000;
 	input->private = dev;
 	input->open = input_open_polled_device;
 	input->close = input_close_polled_device;
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 307c7b5..2deca60 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -263,8 +263,14 @@ void input_event(struct input_dev *dev,
 {
 	unsigned long flags;
 
-	if (is_event_supported(type, dev->evbit, EV_MAX)) {
+	if ((type == EV_SW) && (code == SW_LID)) {
+		int is_closed = value;
+		printk("LID: %d\n", value);
+		if (is_closed) atomic_dec(&cpu_needed);
+		else atomic_inc(&cpu_needed);
+	}
 
+	if (is_event_supported(type, dev->evbit, EV_MAX)) {
 		spin_lock_irqsave(&dev->event_lock, flags);
 		add_input_randomness(type, code, value);
 		input_handle_event(dev, type, code, value);
@@ -1575,6 +1581,8 @@ static int __init input_init(void)
 		goto fail2;
 	}
 
+	/* FIXME: should only inc it if LID is open */
+	atomic_inc(&cpu_needed);
 	return 0;
 
  fail2:	input_proc_exit();
diff --git a/drivers/rtc/rtc-sysfs.c b/drivers/rtc/rtc-sysfs.c
index 2ae0e83..ba5e806 100644
--- a/drivers/rtc/rtc-sysfs.c
+++ b/drivers/rtc/rtc-sysfs.c
@@ -149,16 +149,6 @@ rtc_sysfs_set_wakealarm(struct device *d
 
 	alarm = simple_strtoul(buf, NULL, 0);
 	if (alarm > now) {
-		/* Avoid accidentally clobbering active alarms; we can't
-		 * entirely prevent that here, without even the minimal
-		 * locking from the /dev/rtcN api.
-		 */
-		retval = rtc_read_alarm(rtc, &alm);
-		if (retval < 0)
-			return retval;
-		if (alm.enabled)
-			return -EBUSY;
-
 		alm.enabled = 1;
 	} else {
 		alm.enabled = 0;
diff --git a/include/linux/pm.h b/include/linux/pm.h
index 09a309b..991af06 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -246,6 +246,10 @@ #define device_init_wakeup(dev,val) \
 		device_set_wakeup_enable(dev,val); \
 	} while(0)
 
+void detect_idle(void);
+void enter_auto_sleep(void);
+extern atomic_t cpu_needed;
+
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_PM_H */
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 3cdf95b..fc1c7c1 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -22,6 +22,8 @@ #include <linux/freezer.h>
 #include <linux/vmstat.h>
 #include <linux/syscalls.h>
 
+#include <asm/percpu.h>
+
 #include "power.h"
 
 BLOCKING_NOTIFIER_HEAD(pm_chain_head);
@@ -145,6 +147,8 @@ static int suspend_enter(suspend_state_t
  *	suspend_devices_and_enter - suspend devices and enter the desired system sleep
  *			  state.
  *	@state:		  state to enter
+ *
+ *	Needs to be called from process state and may sleep.
  */
 int suspend_devices_and_enter(suspend_state_t state)
 {
@@ -224,6 +228,8 @@ static inline int valid_state(suspend_st
  *	happen when we wake up.
  *	Then, do the setup for suspend, enter the state, and cleaup (after
  *	we've woken up).
+ *
+ *	Needs to be called from process context, and may sleep.
  */
 static int enter_state(suspend_state_t state)
 {
@@ -253,6 +259,40 @@ static int enter_state(suspend_state_t s
 	return error;
 }
 
+/* Returns how long it waited in ms */
+//extern long (*panic_blink)(long time);
+
+int slept;
+
+int
+do_auto_sleep(void)
+{
+	int error,i;
+	int state = PM_SUSPEND_MEM;
+
+	if (slept)
+		return;
+	slept++;
+	suspend_enter(state);
+
+	for (i=0; i<10; i++) {
+		panic_blink(10);
+		mdelay(100);
+	}
+
+//	if (suspend_ops->finish)
+//		suspend_ops->finish();
+
+	return 0;
+}
+
+void
+enter_auto_sleep(void)
+{
+	int error = do_auto_sleep();
+	if (error)
+		printk("enter auto sleep failed: %d\n", error);
+}
 
 /**
  *	pm_suspend - Externally visible function for suspending system.
@@ -321,6 +361,30 @@ #endif
 	p = memchr(buf, '\n', n);
 	len = p ? p - buf : n;
 
+	if (len == 4 && !strncmp(buf, "auto", len)) {
+		static int acpi_ready = 0;
+		if (!acpi_ready) {
+			int error;
+			int state = PM_SUSPEND_MEM;
+
+			if (suspend_ops->set_target) {
+				error = suspend_ops->set_target(state);
+				if (error)
+					return error;
+			}
+
+			if (suspend_ops->prepare) {
+				error = suspend_ops->prepare();
+				if (error)
+					return error;
+			}
+			acpi_ready = 1;
+		}
+		atomic_dec(&cpu_needed);
+		error = 0;
+  goto Exit;
+	}
+
 	/* First, check if we are requested to hibernate */
 	if (len == 4 && !strncmp(buf, "disk", len)) {
 		error = hibernate();
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index cb89fa8..456a662 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -9,7 +9,7 @@
  *
  *  Started by: Thomas Gleixner and Ingo Molnar
  *
- *  For licencing details see kernel-base/COPYING
+ *  Distribute under GPLv2.
  */
 #include <linux/cpu.h>
 #include <linux/err.h>
@@ -502,7 +508,7 @@ #endif /* NO_HZ */
  */
 #ifdef CONFIG_HIGH_RES_TIMERS
 /*
- * We rearm the timer until we get disabled by the idle code
+ * We rearm the timer until we get disabled by the idle code.
  * Called with interrupts disabled and timer->base->cpu_base->lock held.
  */
 static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 12c5f4c..645ec51 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -65,9 +65,9 @@ #ifdef CONFIG_TIMER_STATS
 	SEQ_printf(m, ", %s/%d", tmp, timer->start_pid);
 #endif
 	SEQ_printf(m, "\n");
-	SEQ_printf(m, " # expires at %Lu nsecs [in %Lu nsecs]\n",
+	SEQ_printf(m, " # expires at %Lu nsecs [in %Ld nsecs]\n",
 		(unsigned long long)ktime_to_ns(timer->expires),
-		(unsigned long long)(ktime_to_ns(timer->expires) - now));
+		(long long)(ktime_to_ns(timer->expires) - now));
 }
 
 static void
@@ -285,3 +285,82 @@ static int __init init_timer_list_procfs
 	return 0;
 }
 __initcall(init_timer_list_procfs);
+
+/*
+ * Sleepy linux support
+ */
+
+#include <linux/suspend.h>
+#include <asm/atomic.h>
+
+atomic_t cpu_needed = ATOMIC_INIT(1);
+
+static s64
+detect_active_timers(struct hrtimer_clock_base *base, s64 first_timer)
+{
+	struct hrtimer *timer, tmp;
+	unsigned long next = 0, i;
+	struct rb_node *curr;
+	unsigned long flags;
+
+next_one:
+	i = 0;
+	spin_lock_irqsave(&base->cpu_base->lock, flags);
+
+	curr = base->first;
+	/*
+	 * Crude but we have to do this O(N*N) thing, because
+	 * we have to unlock the base when printing:
+	 */
+	while (curr && i < next) {
+		curr = rb_next(curr);
+		i++;
+	}
+
+	if (curr) {
+		timer = rb_entry(curr, struct hrtimer, node);
+		tmp = *timer;
+		spin_unlock_irqrestore(&base->cpu_base->lock, flags);
+
+//		printk("[%Ld]", ktime_to_ns(tmp.expires));
+		first_timer = min_t(s64, first_timer, ktime_to_ns(tmp.expires));
+
+		next++;
+		goto next_one;
+	}
+	spin_unlock_irqrestore(&base->cpu_base->lock, flags);
+	return first_timer;
+}
+
+void detect_idle(void)
+{
+	int i;
+	s64 first_timer = (3600ULL*NSEC_PER_SEC);
+	int cpu;
+	s64 now;
+
+	if (num_online_cpus() != 1)
+		return;
+
+	for_each_online_cpu(cpu) {
+		struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
+		for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
+//			printk("_");
+			first_timer = detect_active_timers(cpu_base->clock_base + i, first_timer);
+		}
+	}
+	now = ktime_to_ns(ktime_get());
+	if (first_timer ==3600ULL*NSEC_PER_SEC) {
+		printk("nohz: No timers at all?!\n");
+		if (!atomic_read(&cpu_needed)) {
+			printk("Auto sleep\n");
+			enter_auto_sleep();
+		}
+	} else if (first_timer > (now + 3ULL*NSEC_PER_SEC)) {
+		printk("nohz: Ready for ~ %Ld msec wait, %d\n", (long long) first_timer - (long long) now, atomic_read(&cpu_needed));
+		if (!atomic_read(&cpu_needed)) {
+			printk("Auto sleep\n");
+			enter_auto_sleep();
+		}
+	}
+}
diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index c36bb7e..417da8c 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -26,7 +26,7 @@
  * the pid and cmdline from the owner process if applicable.
  *
  * Start/stop data collection:
- * # echo 1[0] >/proc/timer_stats
+ * # echo [1|0] >/proc/timer_stats
  *
  * Display the information collected so far:
  * # cat /proc/timer_stats
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 52d5e7c..dc7f748 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -220,6 +220,7 @@ int queue_delayed_work_on(int cpu, struc
 	struct timer_list *timer = &dwork->timer;
 	struct work_struct *work = &dwork->work;
 
+	timer_stats_timer_set_start_info(&dwork->timer);
 	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
 		BUG_ON(timer_pending(timer));
 		BUG_ON(!list_empty(&work->entry));
@@ -581,6 +582,7 @@ EXPORT_SYMBOL(schedule_delayed_work);
 int schedule_delayed_work_on(int cpu,
 			struct delayed_work *dwork, unsigned long delay)
 {
+	timer_stats_timer_set_start_info(&dwork->timer);
 	return queue_delayed_work_on(cpu, keventd_wq, dwork, delay);
 }
 EXPORT_SYMBOL(schedule_delayed_work_on);
diff --git a/mm/slab.c b/mm/slab.c
index 2e338a5..8a5d988 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -945,7 +945,7 @@ static void __cpuinit start_cpu_timer(in
 		init_reap_node(cpu);
 		INIT_DELAYED_WORK(reap_work, cache_reap);
 		schedule_delayed_work_on(cpu, reap_work,
-					__round_jiffies_relative(HZ, cpu));
+					 __round_jiffies_relative(HZ*10000, cpu)); /* FIXME !*/
 	}
 }
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index e8d846f..7fd3dbb 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -794,7 +794,7 @@ #endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
-int sysctl_stat_interval __read_mostly = HZ;
+int sysctl_stat_interval __read_mostly = 10000 * HZ;
 
 static void vmstat_update(struct work_struct *w)
 {

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
