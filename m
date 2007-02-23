Return-Path: <linux-kernel-owner+w=401wt.eu-S1752114AbXBWBpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbXBWBpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 20:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbXBWBpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 20:45:53 -0500
Received: from mga06.intel.com ([134.134.136.21]:40001 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752114AbXBWBpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 20:45:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,208,1170662400"; 
   d="scan'208"; a="200336040:sNHT70674849"
Date: Thu, 22 Feb 2007 17:10:27 -0800
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/5] RT kernel: HPET as per CPU eventsource 
Message-ID: <20070222171027.B27475@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Register HPET as eventsource.
If number of logical CPUs is less than number of HPET channels, HPET provides
a per CPU eventsource (using as many timers as needed). Otherwise, it is a
global eventsource (using only one timer).
HPET timers are programmed in their standard interrupt mapping mode (not
in legacy replacement mode).

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.21-rc-mm/arch/x86_64/kernel/apic.c
===================================================================
--- linux-2.6.21-rc-mm.orig/arch/x86_64/kernel/apic.c
+++ linux-2.6.21-rc-mm/arch/x86_64/kernel/apic.c
@@ -794,17 +794,24 @@ static void lapic_timer_setup(enum clock
 	unsigned long flags;
 
 	local_irq_save(flags);
-	/* Turn off PIT interrupt if we use APIC timer as main timer.
-	   Only works with the PM timer right now
-	   TBD fix it for HPET too. */
-	if ((pmtmr_ioport != 0) &&
-		smp_processor_id() == boot_cpu_id &&
-		apic_runs_main_timer == 1 &&
-		!cpu_isset(boot_cpu_id, timer_interrupt_broadcast_ipi_mask)) {
-		stop_timer_interrupt();
-		apic_runs_main_timer++;
+	if (mode == CLOCK_EVT_MODE_SHUTDOWN) {
+		unsigned long v;
+		v = apic_read(APIC_LVTT);
+		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
+		apic_write(APIC_LVTT, v);
+	} else {
+		/* Turn off IRQ 0 timer if we use APIC timer as main timer. */
+		if ( smp_processor_id() == boot_cpu_id &&
+				apic_runs_main_timer == 1 &&
+				!cpu_isset(boot_cpu_id,
+				timer_interrupt_broadcast_ipi_mask)) {
+			stop_timer_interrupt();
+			apic_runs_main_timer++;
+		}
+		__setup_APIC_LVTT(calibration_result,
+				mode != CLOCK_EVT_MODE_PERIODIC);
 	}
-	__setup_APIC_LVTT(calibration_result, mode != CLOCK_EVT_MODE_PERIODIC);
+
 	local_irq_restore(flags);
 }
 
Index: linux-2.6.21-rc-mm/arch/x86_64/kernel/hpet.c
===================================================================
--- linux-2.6.21-rc-mm.orig/arch/x86_64/kernel/hpet.c
+++ linux-2.6.21-rc-mm/arch/x86_64/kernel/hpet.c
@@ -1,3 +1,4 @@
+
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/init.h>
@@ -7,10 +8,14 @@
 #include <linux/ioport.h>
 #include <linux/acpi.h>
 #include <linux/hpet.h>
+#include <linux/clockchips.h>
+#include <linux/delay.h>
+
 #include <asm/pgtable.h>
 #include <asm/vsyscall.h>
 #include <asm/timex.h>
 #include <asm/hpet.h>
+#include <asm/idle.h>
 
 int nohpet __initdata;
 
@@ -71,7 +76,7 @@ static __init int late_hpet_init(void)
 fs_initcall(late_hpet_init);
 #endif
 
-int hpet_timer_stop_set_go(unsigned long tick)
+static int hpet_timer_stop_set_go(unsigned long tick)
 {
 	unsigned int cfg;
 
@@ -158,11 +163,6 @@ int __init hpet_arch_init(void)
 	return hpet_timer_stop_set_go(hpet_tick);
 }
 
-int hpet_reenable(void)
-{
-	return hpet_timer_stop_set_go(hpet_tick);
-}
-
 /*
  * calibrate_tsc() calibrates the processor TSC in a very simple way, comparing
  * it to the HPET timer of known frequency.
@@ -468,6 +468,7 @@ static int __init nohpet_setup(char *s)
 
 __setup("nohpet", nohpet_setup);
 
+/* Clocksource */
 #define HPET_MASK	0xFFFFFFFF
 #define HPET_SHIFT	22
 
@@ -517,6 +518,454 @@ static int __init init_hpet_clocksource(
 	return clocksource_register(&clocksource_hpet);
 }
 
+/* Eventsource */
+static unsigned int num_timers_used;
+
+#define HPET_DEV_FLAG_ONESHOT	0x1
+#define HPET_DEV_FLAG_PERIODIC	0x2
+#define HPET_DEV_FLAG_TEST	0x10
+
+/* HPET as clockevent */
+struct hpet_dev {
+	unsigned int num;
+	int cpu;
+	cpumask_t cpu_mask;
+	unsigned int irq;
+	unsigned int tick;
+	unsigned int count;
+	unsigned int flags;
+	char name[10];
+};
+
+static struct hpet_dev *cpu_hpet_dev; /* per CPU ptr */
+
+#define HPET_INTERRUPT_TEST_COUNT	5
+
+static irqreturn_t hpet_normal_interrupt(int irq, void *data);
+
+static irqreturn_t hpet_normal_interrupt_test(int irq, void *data)
+{
+	unsigned int readin;
+	struct hpet_dev *dev = (struct hpet_dev *)data;
+
+	dev->count++;
+	if (dev->count < HPET_INTERRUPT_TEST_COUNT) {
+		unsigned long flags;
+
+		local_irq_save(flags);
+		readin = hpet_readl(HPET_COUNTER);
+		hpet_writel(readin + dev->tick, HPET_Tn_CMP(dev->num));
+		local_irq_restore(flags);
+	}
+	return IRQ_HANDLED;
+}
+
+static unsigned int cpu_hpet_irq[NR_CPUS] = {[0 ... NR_CPUS-1] = -1};
+static unsigned int assigned_irqs_map = 0;
+
+/* Called sequentially and hence no synchronization */
+static int hpet_assign_irq(struct hpet_dev *dev)
+{
+	unsigned int irq = -1;
+	unsigned int cpu = dev->cpu;
+	int ret = 0;
+
+	dev->irq = -1;
+	/*
+	 * Simple IRQ allocation policy : One IRQ per CPU and use
+	 * first available for this timer.
+	 */
+	if (cpu > NR_CPUS)
+		return -1;
+
+	if (cpu_hpet_irq[cpu] == -1) {
+		unsigned int possible_irqs_map;
+		unsigned int avail_irqs_map;
+
+		/* Assign a new possible IRQ for this CPU */
+		possible_irqs_map = hpet_readl(HPET_Tn_CFG(dev->num) + 4);
+
+		/*
+		 * TBD: Only use IOAPIC sharable interrupts
+		 * IRQ 20 seems to have some problem on my platform.
+		 * Using 21..24 for now.
+		 */
+		possible_irqs_map &= 0xe00000;
+
+		avail_irqs_map = possible_irqs_map & (~assigned_irqs_map);
+		if (unlikely(!avail_irqs_map))
+			return -1;
+
+		irq = find_first_bit((void *)&avail_irqs_map,
+				sizeof(unsigned int));
+		if (unlikely(irq > 31 || irq < 0))
+			return -1;
+
+		set_bit(irq, &assigned_irqs_map);
+		cpu_hpet_irq[cpu] = irq;
+	}
+
+	dev->irq = cpu_hpet_irq[cpu];
+
+	if (dev->irq != -1) {
+		/*
+		 * BIOS does not list these interrupts in tables.
+		 * We set the routing here.
+		 * HPET is connected to IOAPIC 0 and IRQ and GSI are same.
+		 */
+		ret = io_apic_set_pci_routing(0, irq, irq, 1, 1);
+	}
+
+	return ret;
+}
+
+static void hpet_setup_cfg(struct hpet_dev *dev, int enable)
+{
+	if (enable) {
+		hpet_writel(HPET_TN_ENABLE | HPET_TN_32BIT |
+		       HPET_TN_LEVEL | (dev->irq << HPET_TN_ROUTE_SHIFT),
+		       HPET_Tn_CFG(dev->num));
+	} else {
+		hpet_writel(HPET_TN_32BIT |
+		       HPET_TN_LEVEL | (dev->irq << HPET_TN_ROUTE_SHIFT),
+		       HPET_Tn_CFG(dev->num));
+	}
+}
+
+static int hpet_setup_timer_on(struct hpet_dev *dev)
+{
+	unsigned int readin;
+	cpumask_t mask;
+
+	cpus_clear(mask);
+	cpu_set(dev->cpu, mask);
+	set_pending_irq(dev->irq, mask);
+
+	if (request_irq(dev->irq, hpet_normal_interrupt,
+		       IRQF_SHARED|IRQF_NOBALANCING, dev->name, dev)) {
+		return -1;
+	}
+
+	readin = hpet_readl(HPET_COUNTER);
+	hpet_writel(readin + (unsigned int)hpet_tick, HPET_Tn_CMP(dev->num));
+	hpet_setup_cfg(dev, 1);
+	return 0;
+}
+
+static void hpet_timer_setup(enum clock_event_mode mode,
+			struct clock_event_device *evt);
+
+static int hpet_next_event(unsigned long delta,
+			struct clock_event_device *evt);
+
+static struct clock_event_device clockevent_hpet = {
+	.name		= "hpet",
+	.features	= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC,
+	.mult		= 0, /* set below */
+	.shift		= HPET_SHIFT,
+	.rating		= 110,
+	.set_mode	= hpet_timer_setup,
+	.set_next_event	= hpet_next_event,
+};
+
+static DEFINE_PER_CPU(struct clock_event_device, hpet_events);
+
+static void hpet_timer_setup(enum clock_event_mode mode,
+			struct clock_event_device *evt)
+{
+	struct hpet_dev *hdev = per_cpu_ptr(cpu_hpet_dev, smp_processor_id());
+	unsigned long flags;
+	unsigned int readin;
+
+	local_irq_save(flags);
+
+	hdev->flags &= (~(HPET_DEV_FLAG_ONESHOT | HPET_DEV_FLAG_PERIODIC));
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		hdev->flags |= HPET_DEV_FLAG_PERIODIC;
+		readin = hpet_readl(HPET_COUNTER);
+		hpet_writel(readin + hdev->tick, HPET_Tn_CMP(hdev->num));
+		readin = hpet_readl(HPET_Tn_CFG(hdev->num));
+		hpet_writel(readin | HPET_TN_ENABLE, HPET_Tn_CFG(hdev->num));
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+		hdev->flags |= HPET_DEV_FLAG_ONESHOT;
+		readin = hpet_readl(HPET_COUNTER);
+		hpet_writel(readin + hdev->tick, HPET_Tn_CMP(hdev->num));
+		readin = hpet_readl(HPET_Tn_CFG(hdev->num));
+		hpet_writel(readin | HPET_TN_ENABLE, HPET_Tn_CFG(hdev->num));
+		break;
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		readin = hpet_readl(HPET_Tn_CFG(hdev->num));
+		hpet_writel(readin & (~HPET_TN_ENABLE), HPET_Tn_CFG(hdev->num));
+		break;
+	default:
+		break;
+	}
+
+	local_irq_restore(flags);
+}
+
+static int hpet_next_event(unsigned long delta,
+			struct clock_event_device *evt)
+{
+	struct hpet_dev *hdev = per_cpu_ptr(cpu_hpet_dev, smp_processor_id());
+	unsigned long flags;
+	unsigned int readin;
+
+	local_irq_save(flags);
+	readin = hpet_readl(HPET_COUNTER);
+	hpet_writel(readin + (unsigned int)delta, HPET_Tn_CMP(hdev->num));
+	readin = hpet_readl(HPET_Tn_CFG(hdev->num));
+	hpet_writel(readin | HPET_TN_ENABLE, HPET_Tn_CFG(hdev->num));
+	hdev->count++;
+	local_irq_restore(flags);
+	return 0;
+}
+
+static irqreturn_t hpet_normal_interrupt(int irq, void *data)
+{
+	unsigned int readin, status;
+	struct hpet_dev *dev = (struct hpet_dev *)data;
+	struct clock_event_device *hevt = &__get_cpu_var(hpet_events);
+
+	status = hpet_readl(HPET_STATUS);
+	if (!(status & (0x1 << dev->num))) {
+		return IRQ_NONE;
+	}
+	hpet_writel((0x1 << dev->num), HPET_STATUS);
+
+	if (unlikely(dev->flags & HPET_DEV_FLAG_TEST))
+		return hpet_normal_interrupt_test(irq, data);
+
+	/* TBD: Needed for NMI watchdog? */
+	//add_pda(apic_timer_irqs, 1);
+
+	dev->count++;
+	if (dev->flags & HPET_DEV_FLAG_ONESHOT) {
+		readin = hpet_readl(HPET_Tn_CFG(dev->num));
+		hpet_writel(readin & (~HPET_TN_ENABLE), HPET_Tn_CFG(dev->num));
+	} else if (dev->flags & HPET_DEV_FLAG_PERIODIC) {
+		readin = hpet_readl(HPET_COUNTER);
+		hpet_writel(readin + dev->tick, HPET_Tn_CMP(dev->num));
+	}
+
+	if (!hevt->event_handler) {
+		printk("Spurious HPET timer interrupt on HPET timer %d\n",
+			       dev->num);
+		return IRQ_HANDLED;
+	}
+
+	exit_idle();
+	irq_enter();
+	hevt->event_handler(hevt);
+	irq_exit();
+	return IRQ_HANDLED;
+}
+
+#define HPET_PERCPU_EVENT	1
+#define HPET_GLOBAL_EVENT	2
+
+static void __devinit setup_cpu_hpet_timer(void *param)
+{
+	struct clock_event_device *hevt = &__get_cpu_var(hpet_events);
+
+	memcpy(hevt, &clockevent_hpet, sizeof(*hevt));
+	if ((unsigned long)param == HPET_PERCPU_EVENT)
+		hevt->cpumask = cpumask_of_cpu(smp_processor_id());
+	else if ((unsigned long)param == HPET_GLOBAL_EVENT)
+		hevt->cpumask = cpumask_of_cpu(0);
+
+	clockevents_register_device(hevt);
+}
+
+static int init_hpet_eventsource(void)
+{
+	unsigned int id, cfg;
+	int ret = 0;
+	struct hpet_dev **hdev;
+	unsigned long tmp;
+	unsigned long tmp1;
+	unsigned int num_timers;
+	unsigned int percpu_timer;
+	int i;
+
+
+	id = hpet_readl(HPET_ID);
+	num_timers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT);
+	num_timers++; /* Value read out starts from 0 */
+	if (num_possible_cpus() <= 2 && num_possible_cpus() <= num_timers) {
+		percpu_timer = 1;
+		num_timers_used = num_possible_cpus();
+	} else {
+		percpu_timer = 0;
+		num_timers_used = 1;
+	}
+
+	cpu_hpet_dev = alloc_percpu(struct hpet_dev);
+	if (cpu_hpet_dev == NULL)
+		return -1;
+
+	printk("Dump percpu_timer %d, num_timers_used %d, num_timers %d\n", percpu_timer, num_timers_used, num_timers);
+
+	hdev = kzalloc(sizeof(struct hpet_dev *) * num_timers_used, GFP_KERNEL);
+	if (!hdev)
+		return -1;
+
+	for (i = 0; i < num_timers_used; i++) {
+		hdev[i] = per_cpu_ptr(cpu_hpet_dev, i);
+		hdev[i]->num = i;
+		hdev[i]->cpu = i;
+
+		hdev[i]->tick = hpet_tick;
+		hdev[i]->count = 0;
+		hdev[i]->flags |= HPET_DEV_FLAG_TEST;
+		sprintf(hdev[i]->name, "hpet%d", i);
+		if (hpet_assign_irq(hdev[i]) || (hdev[i]->irq < 0)) {
+			printk(KERN_DEBUG "HPET IRQ allocation failed\n");
+			goto free_exit;
+		}
+	}
+
+	for (i = 0; i < num_timers_used; i++) {
+		if (hpet_setup_timer_on(hdev[i])) {
+			num_timers_used = i-1;
+			goto free_irq_exit;
+		}
+	}
+
+	/* Start the timers and test events */
+	cfg = hpet_readl(HPET_CFG);
+	cfg |= HPET_CFG_ENABLE;
+	hpet_writel(cfg, HPET_CFG);
+
+	msleep(HPET_INTERRUPT_TEST_COUNT * 2 * 1000 / HZ);
+
+	for (i = 0; i < num_timers_used; i++) {
+		hdev[i]->flags &= (~HPET_DEV_FLAG_TEST);
+	}
+
+	for (i = 0; i < num_timers_used; i++) {
+		if (hdev[i]->count < HPET_INTERRUPT_TEST_COUNT)
+			goto free_irq_exit;
+	}
+
+	/*
+	 * Convert hpet_period to ticks/ns and then calculate multiplier with
+	 * HPET_SHIFT
+	 */
+	tmp = (u64)hpet_period;
+	do_div(tmp, FSEC_PER_NSEC);
+
+	tmp1 = 1 << HPET_SHIFT;
+	do_div(tmp1, (u32)tmp);
+
+	clockevent_hpet.mult = (u32)tmp1;
+
+	clockevent_hpet.min_delta_ns =
+		clockevent_delta2ns(hpet_tick, &clockevent_hpet);
+	clockevent_hpet.max_delta_ns =
+		clockevent_delta2ns(0x7FFFFFFF, &clockevent_hpet);
+	printk(KERN_DEBUG "hpet max_delta_ns: %ld\n",
+			clockevent_hpet.max_delta_ns);
+	printk(KERN_DEBUG "hpet min_delta_ns: %ld\n",
+			clockevent_hpet.min_delta_ns);
+	printk(KERN_DEBUG "hpet mult: %ld\n", clockevent_hpet.mult);
+
+	if (percpu_timer) {
+		on_each_cpu(setup_cpu_hpet_timer, (void *)HPET_PERCPU_EVENT,
+			       0, 1);
+	} else {
+		/* Reduce the rating as event device is not per cpu */
+		clockevent_hpet.rating -= 20;
+		setup_cpu_hpet_timer((void *)HPET_GLOBAL_EVENT);
+	}
+
+	kfree(hdev);
+	return ret;
+
+free_irq_exit:
+	/* Cleanup on failure */
+	hpet_timer_stop();
+	for (i = 0; i < num_timers_used; i++) {
+		// TBD: free_irq does not work at this point
+		//free_irq(hdev[i]->irq, hdev[i]);
+	}
+
+free_exit:
+	if (!force_hpet_address) {
+		/* Switch back to legacy mode */
+		hpet_timer_stop_set_go(hpet_tick);
+		num_timers_used = 2;
+	} else {
+		num_timers_used = 0;
+	}
+	kfree(hdev);
+	hdev = NULL;
+	return -1;
+}
+
+/* Core Init */
+static int hpet_timer_reset(unsigned int resume)
+{
+	unsigned int cfg;
+
+	/*
+	 * Stop the timers and reset the main counter.
+	 */
+	cfg = hpet_readl(HPET_CFG);
+	cfg &= ~HPET_CFG_ENABLE;
+	hpet_writel(cfg, HPET_CFG);
+	hpet_writel(0, HPET_COUNTER);
+	hpet_writel(0, HPET_COUNTER + 4);
+
+	if (!resume) {
+		cfg = hpet_readl(HPET_CFG);
+		cfg &= ~(HPET_CFG_ENABLE|HPET_CFG_LEGACY);
+		hpet_writel(cfg, HPET_CFG);
+
+		/* Disable HPET timer 0 and 1 */
+		cfg = hpet_readl(HPET_T0_CFG);
+		hpet_writel((~HPET_TN_ENABLE) & cfg, HPET_T0_CFG);
+		cfg = hpet_readl(HPET_T1_CFG);
+		hpet_writel((~HPET_TN_ENABLE) & cfg, HPET_T1_CFG);
+		return 0;
+	}
+
+	/*
+	 * Set up as many timers as enabled earlier, without enabling
+	 * them. Timer subsystem should issue restart on them as they are
+	 * in one shot mode
+	 */
+	if (cpu_hpet_dev) {
+		int i;
+		for (i = 0; i < num_timers_used; i++) {
+			struct hpet_dev *hdev;
+			hdev = per_cpu_ptr(cpu_hpet_dev, i);
+			hpet_setup_cfg(hdev, 0);
+		}
+	}
+
+	/* Enable global counting */
+	cfg |= HPET_CFG_ENABLE;
+	hpet_writel(cfg, HPET_CFG);
+
+	return 0;
+}
+
+/* Used to halt the timer from time.c */
+int hpet_timer_stop(void)
+{
+	return hpet_timer_reset(0);
+}
+
+/* Used to restart the timer after resume from time.c */
+int hpet_timer_reenable(void)
+{
+	return hpet_timer_reset(1);
+}
+
 static int __init init_hpet_generic_timer(void)
 {
 	int ret;
@@ -524,8 +973,11 @@ static int __init init_hpet_generic_time
 	if (nohpet)
 		return -ENODEV;
 
-	if (!hpet_address)
+	if (!hpet_address) {
 		hpet_address = force_hpet_address;
+	} else {
+		hpet_timer_stop();
+	}
 
 	if (!hpet_address)
 		return -ENODEV;
@@ -541,6 +993,13 @@ static int __init init_hpet_generic_time
 		printk(KERN_DEBUG "HPET clocksource init failed\n");
 	}
 
+	ret |= init_hpet_eventsource();
+	if (!ret) {
+		printk(KERN_DEBUG "Successfully registered HPET eventsource\n");
+	} else {
+		printk(KERN_DEBUG "HPET eventsource init failed\n");
+	}
+
 	if (ret) {
 		unsigned int cfg;
 		cfg = hpet_readl(HPET_CFG);
Index: linux-2.6.21-rc-mm/arch/x86_64/kernel/time.c
===================================================================
--- linux-2.6.21-rc-mm.orig/arch/x86_64/kernel/time.c
+++ linux-2.6.21-rc-mm/arch/x86_64/kernel/time.c
@@ -341,7 +341,7 @@ void __init stop_timer_interrupt(void)
 	char *name;
 	if (hpet_address) {
 		name = "HPET";
-		hpet_timer_stop_set_go(0);
+		hpet_timer_stop();
 	} else {
 		name = "PIT";
 		pit_stop_interrupt();
@@ -417,7 +417,7 @@ static int timer_suspend(struct sys_devi
 static int timer_resume(struct sys_device *dev)
 {
 	if (hpet_address)
-		hpet_reenable();
+		hpet_timer_reenable();
 	else
 		i8254_timer_resume();
 
Index: linux-2.6.21-rc-mm/include/asm-x86_64/hpet.h
===================================================================
--- linux-2.6.21-rc-mm.orig/include/asm-x86_64/hpet.h
+++ linux-2.6.21-rc-mm/include/asm-x86_64/hpet.h
@@ -57,8 +57,8 @@ extern int is_hpet_enabled(void);
 extern int hpet_rtc_timer_init(void);
 extern int apic_is_clustered_box(void);
 extern int hpet_arch_init(void);
-extern int hpet_timer_stop_set_go(unsigned long tick);
-extern int hpet_reenable(void);
+extern int hpet_timer_stop(void);
+extern int hpet_timer_reenable(void);
 extern unsigned int hpet_calibrate_tsc(void);
 
 extern int hpet_use_timer;
