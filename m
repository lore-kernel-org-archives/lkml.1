Return-Path: <linux-kernel-owner+w=401wt.eu-S1752326AbXCaIea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbXCaIea (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 04:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbXCaIe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 04:34:29 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:35666 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbXCaIeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 04:34:22 -0400
Message-Id: <20070331083343.133433000@sous-sol.org>
References: <20070331083149.997762000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Sat, 31 Mar 2007 01:31:53 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/5] x86_64: clockevents drivers
Content-Disposition: inline; filename=x86_64-clockevents.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert lapic, pit and hpet based timers to clockevents.
This brings x86_64 in line with i386.  And it is needed
to enable dynticks.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
---
 arch/x86_64/Kconfig       |    8 +
 arch/x86_64/kernel/apic.c |  123 ++++++++++++++++++++-------
 arch/x86_64/kernel/hpet.c |  168 +++++++++++++++++++++++++++++--------
 arch/x86_64/kernel/time.c |  204 ++++++++++++++++------------------------------
 include/asm-x86_64/hpet.h |    2 
 5 files changed, 307 insertions(+), 198 deletions(-)

--- linus-2.6.orig/arch/x86_64/kernel/time.c
+++ linus-2.6/arch/x86_64/kernel/time.c
@@ -42,10 +42,19 @@
 #include <linux/cpufreq.h>
 #include <linux/hpet.h>
 #include <asm/apic.h>
+#include <linux/clockchips.h>
+#include <asm/delay.h>
 #include <asm/hpet.h>
 
 extern void i8254_timer_resume(void);
 extern int using_apic_timer;
+extern struct clock_event_device pit_clockevent;
+/*
+ * HPET replaces the PIT, when enabled. So we need to know, which of
+ * the two timers is used
+ */
+struct clock_event_device *global_clock_event;
+
 
 static char *timename = NULL;
 
@@ -197,34 +206,7 @@ void notify_arch_cmos_timer(void)
 
 void main_timer_handler(void)
 {
-/*
- * Here we are in the timer irq handler. We have irqs locally disabled (so we
- * don't need spin_lock_irqsave()) but we don't know if the timer_bh is running
- * on the other CPU, so we need a lock. We also need to lock the vsyscall
- * variables, because both do_timer() and us change them -arca+vojtech
- */
-
-	write_seqlock(&xtime_lock);
-
-/*
- * Do the timer stuff.
- */
-
-	do_timer(1);
-#ifndef CONFIG_SMP
-	update_process_times(user_mode(get_irq_regs()));
-#endif
-
-/*
- * In the SMP case we use the local APIC timer interrupt to do the profiling,
- * except when we simulate SMP mode on a uniprocessor system, in that case we
- * have to call the local interrupt handler.
- */
-
-	if (!using_apic_timer)
-		smp_local_timer_interrupt();
-
-	write_sequnlock(&xtime_lock);
+	global_clock_event->event_handler(global_clock_event);
 }
 
 static irqreturn_t timer_interrupt(int irq, void *dev_id)
@@ -237,7 +219,7 @@ static irqreturn_t timer_interrupt(int i
 	return IRQ_HANDLED;
 }
 
-static unsigned long get_cmos_time(void)
+unsigned long read_persistent_clock(void)
 {
 	unsigned int year, mon, day, hour, min, sec;
 	unsigned long flags;
@@ -321,38 +303,80 @@ static unsigned int __init pit_calibrate
 #define PIT_MODE 0x43
 #define PIT_CH0  0x40
 
-static void __init __pit_init(int val, u8 mode)
+static void init_pit_timer(enum clock_event_mode mode,
+			   struct clock_event_device *evt)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&i8253_lock, flags);
-	outb_p(mode, PIT_MODE);
-	outb_p(val & 0xff, PIT_CH0);	/* LSB */
-	outb_p(val >> 8, PIT_CH0);	/* MSB */
+
+	switch(mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		/* binary, mode 2, LSB/MSB, ch 0 */
+		outb_p(0x34, PIT_MODE);
+		udelay(10);
+		outb_p(LATCH & 0xff , PIT_CH0); /* LSB */
+		outb(LATCH >> 8 , PIT_CH0);     /* MSB */
+		break;
+
+	case CLOCK_EVT_MODE_ONESHOT:
+		/* One shot setup */
+		outb_p(0x38, PIT_MODE);
+		udelay(10);
+		break;
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	case CLOCK_EVT_MODE_UNUSED:
+		outb_p(0x30, PIT_MODE);
+		outb_p(0, PIT_CH0);	/* LSB */
+		outb_p(0, PIT_CH0);	/* MSB */
+		break;
+	}
 	spin_unlock_irqrestore(&i8253_lock, flags);
 }
 
-void __init pit_init(void)
+static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
 {
-	__pit_init(LATCH, 0x34); /* binary, mode 2, LSB/MSB, ch 0 */
+	unsigned long flags;
+
+	spin_lock_irqsave(&i8253_lock, flags);
+	outb_p(delta & 0xff , PIT_CH0); /* LSB */
+	outb(delta >> 8 , PIT_CH0);     /* MSB */
+	spin_unlock_irqrestore(&i8253_lock, flags);
+
+	return 0;
 }
 
-void __init pit_stop_interrupt(void)
+struct clock_event_device pit_clockevent = {
+	.name		= "pit",
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.set_mode       = init_pit_timer,
+	.set_next_event = pit_next_event,
+	.shift		= 32,
+	.irq		= 0,
+};
+
+void __init stop_timer_interrupt(void)
 {
-	__pit_init(0, 0x30); /* mode 0 */
+	/* XXX this is bogus */
+	clockevents_set_mode(global_clock_event, CLOCK_EVT_MODE_SHUTDOWN);
+	printk(KERN_INFO "timer: %s interrupt stopped.\n", global_clock_event->name);
 }
 
-void __init stop_timer_interrupt(void)
+static void __init setup_pit_timer(void)
 {
-	char *name;
-	if (hpet_address) {
-		name = "HPET";
-		hpet_timer_stop_set_go(0);
-	} else {
-		name = "PIT";
-		pit_stop_interrupt();
-	}
-	printk(KERN_INFO "timer: %s interrupt stopped.\n", name);
+	/*
+	 * Start pit with the boot cpu mask and make it global after the
+	 * IO_APIC has been initialized.
+	 */
+	pit_clockevent.cpumask = cpumask_of_cpu(0);
+
+	pit_clockevent.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, 32);
+	pit_clockevent.max_delta_ns =
+		clockevent_delta2ns(0x7FFF, &pit_clockevent);
+	pit_clockevent.min_delta_ns =
+		clockevent_delta2ns(0xF, &pit_clockevent);
+	clockevents_register_device(&pit_clockevent);
+	global_clock_event = &pit_clockevent;
 }
 
 static struct irqaction irq0 = {
@@ -361,16 +385,8 @@ static struct irqaction irq0 = {
 
 void __init time_init(void)
 {
-	if (nohpet)
-		hpet_address = 0;
-	xtime.tv_sec = get_cmos_time();
-	xtime.tv_nsec = 0;
-
-	set_normalized_timespec(&wall_to_monotonic,
-	                        -xtime.tv_sec, -xtime.tv_nsec);
-
-	if (hpet_arch_init())
-		hpet_address = 0;
+	if (!hpet_arch_init())
+		setup_pit_timer();
 
 	if (hpet_use_timer) {
 		/* set tick_nsec to use the proper rate for HPET */
@@ -378,7 +394,6 @@ void __init time_init(void)
 		cpu_khz = hpet_calibrate_tsc();
 		timename = "HPET";
 	} else {
-		pit_init();
 		cpu_khz = pit_calibrate_tsc();
 		timename = "PIT";
 	}
@@ -398,76 +413,3 @@ void __init time_init(void)
 
 	setup_irq(0, &irq0);
 }
-
-
-static long clock_cmos_diff;
-static unsigned long sleep_start;
-
-/*
- * sysfs support for the timer.
- */
-
-static int timer_suspend(struct sys_device *dev, pm_message_t state)
-{
-	/*
-	 * Estimate time zone so that set_time can update the clock
-	 */
-	long cmos_time =  get_cmos_time();
-
-	clock_cmos_diff = -cmos_time;
-	clock_cmos_diff += get_seconds();
-	sleep_start = cmos_time;
-	return 0;
-}
-
-static int timer_resume(struct sys_device *dev)
-{
-	unsigned long flags;
-	unsigned long sec;
-	unsigned long ctime = get_cmos_time();
-	long sleep_length = (ctime - sleep_start) * HZ;
-
-	if (sleep_length < 0) {
-		printk(KERN_WARNING "Time skew detected in timer resume!\n");
-		/* The time after the resume must not be earlier than the time
-		 * before the suspend or some nasty things will happen
-		 */
-		sleep_length = 0;
-		ctime = sleep_start;
-	}
-	if (hpet_address)
-		hpet_reenable();
-	else
-		i8254_timer_resume();
-
-	sec = ctime + clock_cmos_diff;
-	write_seqlock_irqsave(&xtime_lock,flags);
-	xtime.tv_sec = sec;
-	xtime.tv_nsec = 0;
-	jiffies += sleep_length;
-	write_sequnlock_irqrestore(&xtime_lock,flags);
-	touch_softlockup_watchdog();
-	return 0;
-}
-
-static struct sysdev_class timer_sysclass = {
-	.resume = timer_resume,
-	.suspend = timer_suspend,
-	set_kset_name("timer"),
-};
-
-/* XXX this sysfs stuff should probably go elsewhere later -john */
-static struct sys_device device_timer = {
-	.id	= 0,
-	.cls	= &timer_sysclass,
-};
-
-static int time_init_device(void)
-{
-	int error = sysdev_class_register(&timer_sysclass);
-	if (!error)
-		error = sysdev_register(&device_timer);
-	return error;
-}
-
-device_initcall(time_init_device);
--- linus-2.6.orig/arch/x86_64/kernel/hpet.c
+++ linus-2.6/arch/x86_64/kernel/hpet.c
@@ -4,6 +4,7 @@
 #include <linux/mc146818rtc.h>
 #include <linux/time.h>
 #include <linux/clocksource.h>
+#include <linux/clockchips.h>
 #include <linux/ioport.h>
 #include <linux/acpi.h>
 #include <linux/hpet.h>
@@ -11,6 +12,7 @@
 #include <asm/vsyscall.h>
 #include <asm/timex.h>
 #include <asm/hpet.h>
+#include <asm/delay.h>
 
 #define HPET_MASK	0xFFFFFFFF
 #define HPET_SHIFT	22
@@ -27,6 +29,13 @@ unsigned long hpet_tick;	/* HPET clocks 
 int hpet_use_timer;		/* Use counter of hpet for time keeping,
 				 * otherwise PIT
 				 */
+static int hpet_legacy_int_enabled;
+extern struct clock_event_device *global_clock_event;
+
+static inline int is_hpet_capable(void)
+{
+	return (!nohpet && hpet_address);
+}
 
 #ifdef	CONFIG_HPET
 static __init int late_hpet_init(void)
@@ -34,7 +43,7 @@ static __init int late_hpet_init(void)
 	struct hpet_data	hd;
 	unsigned int 		ntimer;
 
-	if (!hpet_address)
+	if (!is_hpet_capable())
         	return 0;
 
 	memset(&hd, 0, sizeof(hd));
@@ -77,44 +86,107 @@ static __init int late_hpet_init(void)
 fs_initcall(late_hpet_init);
 #endif
 
-int hpet_timer_stop_set_go(unsigned long tick)
-{
-	unsigned int cfg;
+/*
+ * Common hpet info
+ */
+static void hpet_set_mode(enum clock_event_mode mode,
+			  struct clock_event_device *evt);
+static int hpet_next_event(unsigned long delta,
+			   struct clock_event_device *evt);
 
 /*
- * Stop the timers and reset the main counter.
+ * The hpet clock event device
  */
+struct clock_event_device hpet_clockevent = {
+	.name		= "hpet",
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.set_mode	= hpet_set_mode,
+	.set_next_event = hpet_next_event,
+	.shift		= 32,
+	.irq		= 0,
+};
+
+static void hpet_start_counter(void)
+{
+	unsigned long cfg = hpet_readl(HPET_CFG);
 
-	cfg = hpet_readl(HPET_CFG);
-	cfg &= ~(HPET_CFG_ENABLE | HPET_CFG_LEGACY);
+	cfg &= ~HPET_CFG_ENABLE;
 	hpet_writel(cfg, HPET_CFG);
 	hpet_writel(0, HPET_COUNTER);
 	hpet_writel(0, HPET_COUNTER + 4);
+	cfg |= HPET_CFG_ENABLE;
+	hpet_writel(cfg, HPET_CFG);
+}
 
-/*
- * Set up timer 0, as periodic with first interrupt to happen at hpet_tick,
- * and period also hpet_tick.
- */
-	if (hpet_use_timer) {
-		hpet_writel(HPET_TN_ENABLE | HPET_TN_PERIODIC | HPET_TN_SETVAL |
-		    HPET_TN_32BIT, HPET_T0_CFG);
-		hpet_writel(hpet_tick, HPET_T0_CMP); /* next interrupt */
-		hpet_writel(hpet_tick, HPET_T0_CMP); /* period */
-		cfg |= HPET_CFG_LEGACY;
-	}
-/*
- * Go!
- */
+static void hpet_enable_int(void)
+{
+	unsigned long cfg = hpet_readl(HPET_CFG);
 
-	cfg |= HPET_CFG_ENABLE;
+	cfg |= HPET_CFG_LEGACY;
 	hpet_writel(cfg, HPET_CFG);
+	hpet_legacy_int_enabled = 1;
+}
 
-	return 0;
+static void hpet_set_mode(enum clock_event_mode mode,
+			  struct clock_event_device *evt)
+{
+	unsigned long cfg, cmp, now;
+	uint64_t delta;
+
+	switch(mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * hpet_clockevent.mult;
+		delta >>= hpet_clockevent.shift;
+		now = hpet_readl(HPET_COUNTER);
+		cmp = now + (unsigned long) delta;
+		cfg = hpet_readl(HPET_T0_CFG);
+		cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
+		       HPET_TN_SETVAL | HPET_TN_32BIT;
+		hpet_writel(cfg, HPET_T0_CFG);
+		/*
+		 * The first write after writing TN_SETVAL to the
+		 * config register sets the counter value, the second
+		 * write sets the period.
+		 */
+		hpet_writel(cmp, HPET_T0_CMP);
+		udelay(1);
+		hpet_writel((unsigned int) delta, HPET_T0_CMP);
+		break;
+
+	case CLOCK_EVT_MODE_ONESHOT:
+		cfg = hpet_readl(HPET_T0_CFG);
+		cfg &= ~HPET_TN_PERIODIC;
+		cfg |= HPET_TN_ENABLE | HPET_TN_32BIT;
+		hpet_writel(cfg, HPET_T0_CFG);
+		break;
+
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		cfg = hpet_readl(HPET_T0_CFG);
+		cfg &= ~HPET_TN_ENABLE;
+		hpet_writel(cfg, HPET_T0_CFG);
+		break;
+	}
+}
+
+static int hpet_next_event(unsigned long delta,
+			   struct clock_event_device *evt)
+{
+	unsigned long cnt;
+
+	cnt = hpet_readl(HPET_COUNTER);
+	cnt += delta;
+	hpet_writel(cnt, HPET_T0_CMP);
+
+	return ((long)(hpet_readl(HPET_COUNTER) - cnt ) > 0);
 }
 
+/*
+ * Clock source related code
+ */
 static cycle_t read_hpet(void)
 {
-	return (cycle_t)hpet_readl(HPET_COUNTER);
+	return hpet_readl(HPET_COUNTER);
 }
 
 static cycle_t __vsyscall_fn vread_hpet(void)
@@ -136,10 +208,12 @@ struct clocksource clocksource_hpet = {
 int hpet_arch_init(void)
 {
 	unsigned int id;
+	uint64_t hpet_freq;
 	u64 tmp;
 
-	if (!hpet_address)
-		return -1;
+	if (!is_hpet_capable())
+		return 0;
+
 	set_fixmap_nocache(FIX_HPET_BASE, hpet_address);
 	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VSYSCALL_NOCACHE);
 
@@ -150,15 +224,31 @@ int hpet_arch_init(void)
 	id = hpet_readl(HPET_ID);
 
 	if (!(id & HPET_ID_VENDOR) || !(id & HPET_ID_NUMBER))
-		return -1;
+		return 0;
 
 	hpet_period = hpet_readl(HPET_PERIOD);
 	if (hpet_period < 100000 || hpet_period > 100000000)
-		return -1;
+		return 0;
+
+	/*
+	 * The period is a femto seconds value. We need to calculate the
+	 * scaled math multiplication factor for nanosecond to hpet tick
+	 * conversion.
+	 */
+	hpet_freq = 1000000000000000ULL;
+	do_div(hpet_freq, hpet_period);
+	hpet_clockevent.mult = div_sc((unsigned long) hpet_freq,
+				      NSEC_PER_SEC, 32);
+	/* Calculate the min / max delta */
+	hpet_clockevent.max_delta_ns = clockevent_delta2ns(0x7FFFFFFF,
+							   &hpet_clockevent);
+	hpet_clockevent.min_delta_ns = clockevent_delta2ns(0x30,
+							   &hpet_clockevent);
 
 	hpet_tick = (FSEC_PER_TICK + hpet_period / 2) / hpet_period;
 
-	hpet_use_timer = (id & HPET_ID_LEGSUP);
+	/* Start the counter */
+	hpet_start_counter();
 
 	/*
 	 * hpet period is in femto seconds per cycle
@@ -176,12 +266,20 @@ int hpet_arch_init(void)
 	clocksource_hpet.mult = (u32)tmp;
 	clocksource_register(&clocksource_hpet);
 
-	return hpet_timer_stop_set_go(hpet_tick);
-}
+	hpet_use_timer = (id & HPET_ID_LEGSUP);
 
-int hpet_reenable(void)
-{
-	return hpet_timer_stop_set_go(hpet_tick);
+	if (hpet_use_timer) {
+		hpet_enable_int();
+		/*
+		 * Start hpet with the boot cpu mask and make it
+		 * global after the IO_APIC has been initialized.
+		 */
+		hpet_clockevent.cpumask = cpumask_of_cpu(0);
+		clockevents_register_device(&hpet_clockevent);
+		global_clock_event = &hpet_clockevent;
+		return 1;
+	}
+	return 0;
 }
 
 /*
@@ -265,7 +363,7 @@ static unsigned int hpet_t1_cmp; /* cach
 
 int is_hpet_enabled(void)
 {
-	return hpet_address != 0;
+	return is_hpet_capable() && hpet_legacy_int_enabled;
 }
 
 /*
--- linus-2.6.orig/arch/x86_64/Kconfig
+++ linus-2.6/arch/x86_64/Kconfig
@@ -28,6 +28,14 @@ config GENERIC_TIME
 	bool
 	default y
 
+config GENERIC_CLOCKEVENTS_BROADCAST
+	bool
+	default y
+
+config GENERIC_CLOCKEVENTS
+	bool
+	default y
+
 config GENERIC_TIME_VSYSCALL
 	bool
 	default y
--- linus-2.6.orig/arch/x86_64/kernel/apic.c
+++ linus-2.6/arch/x86_64/kernel/apic.c
@@ -26,6 +26,7 @@
 #include <linux/sysdev.h>
 #include <linux/module.h>
 #include <linux/ioport.h>
+#include <linux/clockchips.h>
 
 #include <asm/atomic.h>
 #include <asm/smp.h>
@@ -62,6 +63,26 @@ static cpumask_t timer_interrupt_broadca
 /* Using APIC to generate smp_local_timer_interrupt? */
 int using_apic_timer __read_mostly = 0;
 
+
+static unsigned int calibration_result;
+
+static int lapic_next_event(unsigned long delta,
+			    struct clock_event_device *evt);
+static void lapic_timer_setup(enum clock_event_mode mode,
+			      struct clock_event_device *evt);
+
+static struct clock_event_device lapic_clockevent = {
+	.name		= "lapic",
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT
+			| CLOCK_EVT_FEAT_C3STOP,
+	.shift		= 32,
+	.set_mode	= lapic_timer_setup,
+	.set_next_event	= lapic_next_event,
+	.rating		= 100,
+	.irq		= -1,
+};
+static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
+
 static void apic_pm_activate(void);
 
 void enable_NMI_through_LVT0 (void * dummy)
@@ -734,12 +755,15 @@ void __init init_apic_mappings(void)
 
 #define APIC_DIVISOR 16
 
-static void __setup_APIC_LVTT(unsigned int clocks)
+static void __setup_APIC_LVTT(unsigned int clocks, int oneshot)
 {
 	unsigned int lvtt_value, tmp_value;
 	int cpu = smp_processor_id();
 
-	lvtt_value = APIC_LVT_TIMER_PERIODIC | LOCAL_TIMER_VECTOR;
+	lvtt_value = LOCAL_TIMER_VECTOR;
+	if (!oneshot)
+		lvtt_value |= APIC_LVT_TIMER_PERIODIC;
+
 
 	if (cpu_isset(cpu, timer_interrupt_broadcast_ipi_mask))
 		lvtt_value |= APIC_LVT_MASKED;
@@ -754,35 +778,24 @@ static void __setup_APIC_LVTT(unsigned i
 				& ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE))
 				| APIC_TDR_DIV_16);
 
-	apic_write(APIC_TMICT, clocks/APIC_DIVISOR);
+	if (!oneshot)
+		apic_write(APIC_TMICT, clocks/APIC_DIVISOR);
 }
 
-static void setup_APIC_timer(unsigned int clocks)
+static int lapic_next_event(unsigned long delta,
+			    struct clock_event_device *evt)
+{
+	apic_write(APIC_TMICT, delta);
+	return 0;
+}
+
+static void lapic_timer_setup(enum clock_event_mode mode,
+			      struct clock_event_device *evt)
 {
 	unsigned long flags;
 
 	local_irq_save(flags);
 
-	/* wait for irq slice */
- 	if (hpet_address && hpet_use_timer) {
- 		int trigger = hpet_readl(HPET_T0_CMP);
- 		while (hpet_readl(HPET_COUNTER) >= trigger)
- 			/* do nothing */ ;
- 		while (hpet_readl(HPET_COUNTER) <  trigger)
- 			/* do nothing */ ;
- 	} else {
-		int c1, c2;
-		outb_p(0x00, 0x43);
-		c2 = inb_p(0x40);
-		c2 |= inb_p(0x40) << 8;
-		do {
-			c1 = c2;
-			outb_p(0x00, 0x43);
-			c2 = inb_p(0x40);
-			c2 |= inb_p(0x40) << 8;
-		} while (c2 - c1 < 300);
-	}
-	__setup_APIC_LVTT(clocks);
 	/* Turn off PIT interrupt if we use APIC timer as main timer.
 	   Only works with the PM timer right now
 	   TBD fix it for HPET too. */
@@ -793,9 +806,33 @@ static void setup_APIC_timer(unsigned in
 		stop_timer_interrupt();
 		apic_runs_main_timer++;
 	}
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+	case CLOCK_EVT_MODE_ONESHOT:
+		__setup_APIC_LVTT(calibration_result,
+				  mode != CLOCK_EVT_MODE_PERIODIC);
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		disable_APIC_timer();
+		break;
+	}
+
 	local_irq_restore(flags);
 }
 
+
+static void __devinit setup_APIC_timer(void)
+{
+	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
+
+	memcpy(levt, &lapic_clockevent, sizeof(*levt));
+	levt->cpumask = cpumask_of_cpu(smp_processor_id());
+
+	clockevents_register_device(levt);
+}
+
 /*
  * In this function we calibrate APIC bus clocks to the external
  * timer. Unfortunately we cannot use jiffies and the timer irq
@@ -815,12 +852,13 @@ static int __init calibrate_APIC_clock(v
 {
 	int apic, apic_start, tsc, tsc_start;
 	int result;
+	u64 wallclock_nsecs;
 	/*
 	 * Put whatever arbitrary (but long enough) timeout
 	 * value into the APIC clock, we just want to get the
 	 * counter running for calibration.
 	 */
-	__setup_APIC_LVTT(1000000000);
+	__setup_APIC_LVTT(1000000000, 0);
 
 	apic_start = apic_read(APIC_TMCCT);
 #ifdef CONFIG_X86_PM_TIMER
@@ -828,6 +866,8 @@ static int __init calibrate_APIC_clock(v
 		pmtimer_wait(5000);  /* 5ms wait */
 		apic = apic_read(APIC_TMCCT);
 		result = (apic_start - apic) * 1000L / 5;
+		printk("using pmtimer for lapic calibration\n");
+		wallclock_nsecs = 5000000;
 	} else
 #endif
 	{
@@ -841,6 +881,8 @@ static int __init calibrate_APIC_clock(v
 
 		result = (apic_start - apic) * 1000L * cpu_khz /
 					(tsc - tsc_start);
+		wallclock_nsecs = ((u64)tsc - (u64)tsc_start) * 1000000 / (u64)cpu_khz;
+
 	}
 	printk("result %d\n", result);
 
@@ -848,11 +890,22 @@ static int __init calibrate_APIC_clock(v
 	printk(KERN_INFO "Detected %d.%03d MHz APIC timer.\n",
 		result / 1000 / 1000, result / 1000 % 1000);
 
+
+
+
+	/* Calculate the scaled math multiplication factor */
+	lapic_clockevent.mult = div_sc(apic_start - apic, wallclock_nsecs, 32);
+
+	lapic_clockevent.max_delta_ns =
+		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
+	printk("lapic max_delta_ns: %ld\n", lapic_clockevent.max_delta_ns);
+	lapic_clockevent.min_delta_ns =
+		clockevent_delta2ns(0xF, &lapic_clockevent);
+
+
 	return result * APIC_DIVISOR / HZ;
 }
 
-static unsigned int calibration_result;
-
 void __init setup_boot_APIC_clock (void)
 {
 	if (disable_apic_timer) { 
@@ -869,7 +922,7 @@ void __init setup_boot_APIC_clock (void)
 	/*
 	 * Now set up the timer for real.
 	 */
-	setup_APIC_timer(calibration_result);
+	setup_APIC_timer();
 
 	local_irq_enable();
 }
@@ -877,7 +930,7 @@ void __init setup_boot_APIC_clock (void)
 void __cpuinit setup_secondary_APIC_clock(void)
 {
 	local_irq_disable(); /* FIXME: Do we need this? --RR */
-	setup_APIC_timer(calibration_result);
+	setup_APIC_timer();
 	local_irq_enable();
 }
 
@@ -924,6 +977,13 @@ void switch_APIC_timer_to_ipi(void *cpum
 	    !cpu_isset(cpu, timer_interrupt_broadcast_ipi_mask)) {
 		disable_APIC_timer();
 		cpu_set(cpu, timer_interrupt_broadcast_ipi_mask);
+#ifdef CONFIG_HIGH_RES_TIMERS
+		printk("Disabling NO_HZ and high resolution timers "
+			"due to timer broadcasting\n");
+		for_each_possible_cpu(cpu)
+			per_cpu(lapic_events, cpu).features &=
+				~CLOCK_EVT_FEAT_ONESHOT;
+#endif
 	}
 }
 EXPORT_SYMBOL(switch_APIC_timer_to_ipi);
@@ -1008,6 +1068,9 @@ void smp_apic_timer_interrupt(struct pt_
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
+	int cpu = smp_processor_id();
+	struct clock_event_device *evt = &per_cpu(lapic_events, cpu);
+
 	/*
 	 * the NMI deadlock-detector uses this.
 	 */
@@ -1025,7 +1088,7 @@ void smp_apic_timer_interrupt(struct pt_
 	 */
 	exit_idle();
 	irq_enter();
-	smp_local_timer_interrupt();
+	evt->event_handler(evt);
 	irq_exit();
 	set_irq_regs(old_regs);
 }
--- linus-2.6.orig/include/asm-x86_64/hpet.h
+++ linus-2.6/include/asm-x86_64/hpet.h
@@ -56,8 +56,6 @@
 extern int is_hpet_enabled(void);
 extern int hpet_rtc_timer_init(void);
 extern int hpet_arch_init(void);
-extern int hpet_timer_stop_set_go(unsigned long tick);
-extern int hpet_reenable(void);
 extern unsigned int hpet_calibrate_tsc(void);
 
 extern int hpet_use_timer;

--
