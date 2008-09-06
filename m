Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbYIFPK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbYIFPK7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 11:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYIFPKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 11:10:51 -0400
Received: from www.tglx.de ([62.245.132.106]:49647 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbYIFPKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 11:10:50 -0400
Date: Sat, 6 Sep 2008 17:10:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Venkatesch Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [GIT pull] timer fixes for 2.6.27
Message-ID: <alpine.LFD.1.10.0809061708240.3243@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

This is a rather large update that late in the rc cycle, but it's all
really important bugfixes around the timers/timekeeping code.

The C1E idle support (added in .27) made some long standing bugs in
the timers code more prominent and I spent almost two weeks now going
through the code with a fine comb, creating debug patches and tracking
down the last (and for me most embarrassing) bug in the hpet code
along with a new workaround for hardware bugs^Wfeatures in ATI HPETs
which need a readback of the compare value _before_ reading the count
register to verify that we did not miss the event.

The patches are confirmed by various testers and close a couple of
entries in the regression list [BZ #11145 #11191 #11279] and some
other related bug reports.

Also passed in -tip testing on a broad range of x86 boxes.

I thought about disabling C1E for .27, but the bugs are real and
affect non C1E systems as well. So fixing them is better than hiding
them and hope they wont trigger.

The timekeeping patches vs. acpi_pm and ntp were collected and tested
by Andrew and have been in -mm for some time.

Thanks,

	tglx

------------------>
Dominik Brodowski (2):
      clocksource, acpi_pm.c: use proper read function also in errata mode
      clocksource, acpi_pm.c: check for monotonicity

Maciej W. Rozycki (1):
      ntp: fix calculation of the next jiffie to trigger RTC sync

Thomas Gleixner (8):
      clockevents: prevent endless loop in periodic broadcast handler
      clockevents: enforce reprogram in oneshot setup
      clockevents: prevent multiple init/shutdown
      clockevents: prevent endless loop lockup
      HPET: make minimum reprogramming delta useful
      clockevents: broadcast fixup possible waiters
      x86: HPET fix moronic 32/64bit thinko
      x86: HPET: read back compare register before reading counter

Venkatesh Pallipadi (1):
      clockevents: prevent clockevent event_handler ending up handler_noop


 arch/x86/kernel/hpet.c        |   19 +++++++---
 drivers/clocksource/acpi_pm.c |   54 +++++++++++++++++-----------
 include/linux/clockchips.h    |    2 +
 kernel/time/clockevents.c     |    3 +-
 kernel/time/ntp.c             |    2 +-
 kernel/time/tick-broadcast.c  |   78 ++++++++++++++++++++++++++++++----------
 kernel/time/tick-common.c     |    1 +
 kernel/time/tick-internal.h   |    2 +
 kernel/time/tick-oneshot.c    |   46 +++++++++++++++++++++---
 9 files changed, 151 insertions(+), 56 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 59fd3b6..73deaff 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -210,8 +210,8 @@ static void hpet_legacy_clockevent_register(void)
 	/* Calculate the min / max delta */
 	hpet_clockevent.max_delta_ns = clockevent_delta2ns(0x7FFFFFFF,
 							   &hpet_clockevent);
-	hpet_clockevent.min_delta_ns = clockevent_delta2ns(0x30,
-							   &hpet_clockevent);
+	/* 5 usec minimum reprogramming delta. */
+	hpet_clockevent.min_delta_ns = 5000;
 
 	/*
 	 * Start hpet with the boot cpu mask and make it
@@ -270,15 +270,22 @@ static void hpet_legacy_set_mode(enum clock_event_mode mode,
 }
 
 static int hpet_legacy_next_event(unsigned long delta,
-			   struct clock_event_device *evt)
+				  struct clock_event_device *evt)
 {
-	unsigned long cnt;
+	u32 cnt;
 
 	cnt = hpet_readl(HPET_COUNTER);
-	cnt += delta;
+	cnt += (u32) delta;
 	hpet_writel(cnt, HPET_T0_CMP);
 
-	return ((long)(hpet_readl(HPET_COUNTER) - cnt ) > 0) ? -ETIME : 0;
+	/*
+	 * We need to read back the CMP register to make sure that
+	 * what we wrote hit the chip before we compare it to the
+	 * counter.
+	 */
+	WARN_ON((u32)hpet_readl(HPET_T0_CMP) != cnt);
+
+	return (s32)((u32)hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
 }
 
 /*
diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index 5ca1d80..4eee533 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -21,6 +21,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <linux/delay.h>
 #include <asm/io.h>
 
 /*
@@ -151,13 +152,13 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_LE,
  */
 static int verify_pmtmr_rate(void)
 {
-	u32 value1, value2;
+	cycle_t value1, value2;
 	unsigned long count, delta;
 
 	mach_prepare_counter();
-	value1 = read_pmtmr();
+	value1 = clocksource_acpi_pm.read();
 	mach_countup(&count);
-	value2 = read_pmtmr();
+	value2 = clocksource_acpi_pm.read();
 	delta = (value2 - value1) & ACPI_PM_MASK;
 
 	/* Check that the PMTMR delta is within 5% of what we expect */
@@ -175,10 +176,13 @@ static int verify_pmtmr_rate(void)
 #define verify_pmtmr_rate() (0)
 #endif
 
+/* Number of monotonicity checks to perform during initialization */
+#define ACPI_PM_MONOTONICITY_CHECKS 10
+
 static int __init init_acpi_pm_clocksource(void)
 {
-	u32 value1, value2;
-	unsigned int i;
+	cycle_t value1, value2;
+	unsigned int i, j, good = 0;
 
 	if (!pmtmr_ioport)
 		return -ENODEV;
@@ -187,24 +191,32 @@ static int __init init_acpi_pm_clocksource(void)
 						clocksource_acpi_pm.shift);
 
 	/* "verify" this timing source: */
-	value1 = read_pmtmr();
-	for (i = 0; i < 10000; i++) {
-		value2 = read_pmtmr();
-		if (value2 == value1)
-			continue;
-		if (value2 > value1)
-			goto pm_good;
-		if ((value2 < value1) && ((value2) < 0xFFF))
-			goto pm_good;
-		printk(KERN_INFO "PM-Timer had inconsistent results:"
-			" 0x%#x, 0x%#x - aborting.\n", value1, value2);
-		return -EINVAL;
+	for (j = 0; j < ACPI_PM_MONOTONICITY_CHECKS; j++) {
+		value1 = clocksource_acpi_pm.read();
+		for (i = 0; i < 10000; i++) {
+			value2 = clocksource_acpi_pm.read();
+			if (value2 == value1)
+				continue;
+			if (value2 > value1)
+				good++;
+				break;
+			if ((value2 < value1) && ((value2) < 0xFFF))
+				good++;
+				break;
+			printk(KERN_INFO "PM-Timer had inconsistent results:"
+			       " 0x%#llx, 0x%#llx - aborting.\n",
+			       value1, value2);
+			return -EINVAL;
+		}
+		udelay(300 * i);
+	}
+
+	if (good != ACPI_PM_MONOTONICITY_CHECKS) {
+		printk(KERN_INFO "PM-Timer failed consistency check "
+		       " (0x%#llx) - aborting.\n", value1);
+		return -ENODEV;
 	}
-	printk(KERN_INFO "PM-Timer had no reasonable result:"
-			" 0x%#x - aborting.\n", value1);
-	return -ENODEV;
 
-pm_good:
 	if (verify_pmtmr_rate() != 0)
 		return -ENODEV;
 
diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index c33b0dc..ed3a5d4 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -127,6 +127,8 @@ extern int clockevents_register_notifier(struct notifier_block *nb);
 extern int clockevents_program_event(struct clock_event_device *dev,
 				     ktime_t expires, ktime_t now);
 
+extern void clockevents_handle_noop(struct clock_event_device *dev);
+
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 extern void clockevents_notify(unsigned long reason, void *arg);
 #else
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 3d1e3e1..1876b52 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -177,7 +177,7 @@ void clockevents_register_device(struct clock_event_device *dev)
 /*
  * Noop handler when we shut down an event device
  */
-static void clockevents_handle_noop(struct clock_event_device *dev)
+void clockevents_handle_noop(struct clock_event_device *dev)
 {
 }
 
@@ -199,7 +199,6 @@ void clockevents_exchange_device(struct clock_event_device *old,
 	 * released list and do a notify add later.
 	 */
 	if (old) {
-		old->event_handler = clockevents_handle_noop;
 		clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);
 		list_del(&old->list);
 		list_add(&old->list, &clockevents_released);
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 5125ddd..1ad46f3 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -245,7 +245,7 @@ static void sync_cmos_clock(unsigned long dummy)
 	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2)
 		fail = update_persistent_clock(now);
 
-	next.tv_nsec = (NSEC_PER_SEC / 2) - now.tv_nsec;
+	next.tv_nsec = (NSEC_PER_SEC / 2) - now.tv_nsec - (TICK_NSEC / 2);
 	if (next.tv_nsec <= 0)
 		next.tv_nsec += NSEC_PER_SEC;
 
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 31463d3..2f5a382 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -175,6 +175,8 @@ static void tick_do_periodic_broadcast(void)
  */
 static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
 {
+	ktime_t next;
+
 	tick_do_periodic_broadcast();
 
 	/*
@@ -185,10 +187,13 @@ static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
 
 	/*
 	 * Setup the next period for devices, which do not have
-	 * periodic mode:
+	 * periodic mode. We read dev->next_event first and add to it
+	 * when the event alrady expired. clockevents_program_event()
+	 * sets dev->next_event only when the event is really
+	 * programmed to the device.
 	 */
-	for (;;) {
-		ktime_t next = ktime_add(dev->next_event, tick_period);
+	for (next = dev->next_event; ;) {
+		next = ktime_add(next, tick_period);
 
 		if (!clockevents_program_event(dev, next, ktime_get()))
 			return;
@@ -205,7 +210,7 @@ static void tick_do_broadcast_on_off(void *why)
 	struct clock_event_device *bc, *dev;
 	struct tick_device *td;
 	unsigned long flags, *reason = why;
-	int cpu;
+	int cpu, bc_stopped;
 
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
 
@@ -223,6 +228,8 @@ static void tick_do_broadcast_on_off(void *why)
 	if (!tick_device_is_functional(dev))
 		goto out;
 
+	bc_stopped = cpus_empty(tick_broadcast_mask);
+
 	switch (*reason) {
 	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
@@ -245,9 +252,10 @@ static void tick_do_broadcast_on_off(void *why)
 		break;
 	}
 
-	if (cpus_empty(tick_broadcast_mask))
-		clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
-	else {
+	if (cpus_empty(tick_broadcast_mask)) {
+		if (!bc_stopped)
+			clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
+	} else if (bc_stopped) {
 		if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
 			tick_broadcast_start_periodic(bc);
 		else
@@ -364,16 +372,8 @@ cpumask_t *tick_get_broadcast_oneshot_mask(void)
 static int tick_broadcast_set_event(ktime_t expires, int force)
 {
 	struct clock_event_device *bc = tick_broadcast_device.evtdev;
-	ktime_t now = ktime_get();
-	int res;
-
-	for(;;) {
-		res = clockevents_program_event(bc, expires, now);
-		if (!res || !force)
-			return res;
-		now = ktime_get();
-		expires = ktime_add(now, ktime_set(0, bc->min_delta_ns));
-	}
+
+	return tick_dev_program_event(bc, expires, force);
 }
 
 int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
@@ -491,14 +491,52 @@ static void tick_broadcast_clear_oneshot(int cpu)
 	cpu_clear(cpu, tick_broadcast_oneshot_mask);
 }
 
+static void tick_broadcast_init_next_event(cpumask_t *mask, ktime_t expires)
+{
+	struct tick_device *td;
+	int cpu;
+
+	for_each_cpu_mask_nr(cpu, *mask) {
+		td = &per_cpu(tick_cpu_device, cpu);
+		if (td->evtdev)
+			td->evtdev->next_event = expires;
+	}
+}
+
 /**
  * tick_broadcast_setup_oneshot - setup the broadcast device
  */
 void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
-	bc->event_handler = tick_handle_oneshot_broadcast;
-	clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
-	bc->next_event.tv64 = KTIME_MAX;
+	/* Set it up only once ! */
+	if (bc->event_handler != tick_handle_oneshot_broadcast) {
+		int was_periodic = bc->mode == CLOCK_EVT_MODE_PERIODIC;
+		int cpu = smp_processor_id();
+		cpumask_t mask;
+
+		bc->event_handler = tick_handle_oneshot_broadcast;
+		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
+
+		/* Take the do_timer update */
+		tick_do_timer_cpu = cpu;
+
+		/*
+		 * We must be careful here. There might be other CPUs
+		 * waiting for periodic broadcast. We need to set the
+		 * oneshot_mask bits for those and program the
+		 * broadcast device to fire.
+		 */
+		mask = tick_broadcast_mask;
+		cpu_clear(cpu, mask);
+		cpus_or(tick_broadcast_oneshot_mask,
+			tick_broadcast_oneshot_mask, mask);
+
+		if (was_periodic && !cpus_empty(mask)) {
+			tick_broadcast_init_next_event(&mask, tick_next_period);
+			tick_broadcast_set_event(tick_next_period, 1);
+		} else
+			bc->next_event.tv64 = KTIME_MAX;
+	}
 }
 
 /*
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 80c4336..c477719 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -161,6 +161,7 @@ static void tick_setup_device(struct tick_device *td,
 	} else {
 		handler = td->evtdev->event_handler;
 		next_event = td->evtdev->next_event;
+		td->evtdev->event_handler = clockevents_handle_noop;
 	}
 
 	td->evtdev = newdev;
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index f13f2b7..0ffc291 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -17,6 +17,8 @@ extern void tick_handle_periodic(struct clock_event_device *dev);
 extern void tick_setup_oneshot(struct clock_event_device *newdev,
 			       void (*handler)(struct clock_event_device *),
 			       ktime_t nextevt);
+extern int tick_dev_program_event(struct clock_event_device *dev,
+				  ktime_t expires, int force);
 extern int tick_program_event(ktime_t expires, int force);
 extern void tick_oneshot_notify(void);
 extern int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *));
diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index 450c049..2e35501 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -23,24 +23,58 @@
 #include "tick-internal.h"
 
 /**
- * tick_program_event
+ * tick_program_event internal worker function
  */
-int tick_program_event(ktime_t expires, int force)
+int tick_dev_program_event(struct clock_event_device *dev, ktime_t expires,
+			   int force)
 {
-	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	ktime_t now = ktime_get();
+	int i;
 
-	while (1) {
+	for (i = 0;;) {
 		int ret = clockevents_program_event(dev, expires, now);
 
 		if (!ret || !force)
 			return ret;
+
+		/*
+		 * We tried 2 times to program the device with the given
+		 * min_delta_ns. If that's not working then we double it
+		 * and emit a warning.
+		 */
+		if (++i > 2) {
+			printk(KERN_WARNING "CE: __tick_program_event of %s is "
+			       "stuck %llx %llx\n", dev->name ? dev->name : "?",
+			       now.tv64, expires.tv64);
+			printk(KERN_WARNING
+			       "CE: increasing min_delta_ns %ld to %ld nsec\n",
+			       dev->min_delta_ns, dev->min_delta_ns << 1);
+			WARN_ON(1);
+
+			/* Double the min. delta and try again */
+			if (!dev->min_delta_ns)
+				dev->min_delta_ns = 5000;
+			else
+				dev->min_delta_ns <<= 1;
+			i = 0;
+		}
+
 		now = ktime_get();
-		expires = ktime_add(now, ktime_set(0, dev->min_delta_ns));
+		expires = ktime_add_ns(now, dev->min_delta_ns);
 	}
 }
 
 /**
+ * tick_program_event
+ */
+int tick_program_event(ktime_t expires, int force)
+{
+	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
+
+	return tick_dev_program_event(dev, expires, force);
+}
+
+/**
  * tick_resume_onshot - resume oneshot mode
  */
 void tick_resume_oneshot(void)
@@ -61,7 +95,7 @@ void tick_setup_oneshot(struct clock_event_device *newdev,
 {
 	newdev->event_handler = handler;
 	clockevents_set_mode(newdev, CLOCK_EVT_MODE_ONESHOT);
-	clockevents_program_event(newdev, next_event, ktime_get());
+	tick_dev_program_event(newdev, next_event, 1);
 }
 
 /**
