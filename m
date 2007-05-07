Return-Path: <linux-kernel-owner+w=401wt.eu-S966697AbXEGUgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966697AbXEGUgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966691AbXEGUf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:35:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:43541 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966682AbXEGUf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:35:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,502,1170662400"; 
   d="scan'208";a="240431750"
Date: Mon, 7 May 2007 13:33:28 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 6/8] use HPET timer in standard interrupt delivery mode
Message-ID: <20070507203328.GF3926@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Add support for HPET timers in "standard" interrupt delivery mode as opposed
to "legacy replacement" mode. This enables HPET timer to be
tied to regular IRQ lines and can enable different HPET timers to
be targetted to different CPUs. And with this change, HPET timer need not have
to overstep on legacy IRQ0 or IRQ8 lines.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.21-tolkml/include/asm-i386/hpet.h
===================================================================
--- linux-2.6.21-tolkml.orig/include/asm-i386/hpet.h	2007-05-07 09:54:47.000000000 -0700
+++ linux-2.6.21-tolkml/include/asm-i386/hpet.h	2007-05-07 10:17:50.000000000 -0700
@@ -43,15 +43,18 @@
 #define HPET_CFG	0x010
 #define HPET_STATUS	0x020
 #define HPET_COUNTER	0x0f0
-#define HPET_T0_CFG	0x100
-#define HPET_T0_CMP	0x108
-#define HPET_T0_ROUTE	0x110
-#define HPET_T1_CFG	0x120
-#define HPET_T1_CMP	0x128
-#define HPET_T1_ROUTE	0x130
-#define HPET_T2_CFG	0x140
-#define HPET_T2_CMP	0x148
-#define HPET_T2_ROUTE	0x150
+
+#define HPET_Tn_OFFSET		0x20
+#define HPET_Tn_CFG(n)		(0x100 + (n) * HPET_Tn_OFFSET)
+#define HPET_Tn_ROUTE(n)	(0x104 + (n) * HPET_Tn_OFFSET)
+#define HPET_Tn_CMP(n)		(0x108 + (n) * HPET_Tn_OFFSET)
+
+#define HPET_T0_CFG	HPET_Tn_CFG(0)
+#define HPET_T0_CMP	HPET_Tn_CMP(0)
+#define HPET_T1_CFG	HPET_Tn_CFG(1)
+#define HPET_T1_CMP	HPET_Tn_CMP(1)
+#define HPET_T2_CFG	HPET_Tn_CFG(2)
+#define HPET_T2_CMP	HPET_Tn_CMP(2)
 
 #define HPET_ID_LEGSUP	0x00008000
 #define HPET_ID_NUMBER	0x00001f00
@@ -63,11 +66,18 @@
 #define	HPET_LEGACY_8254	2
 #define	HPET_LEGACY_RTC		8
 
-#define HPET_TN_ENABLE		0x004
-#define HPET_TN_PERIODIC	0x008
-#define HPET_TN_PERIODIC_CAP	0x010
-#define HPET_TN_SETVAL		0x040
-#define HPET_TN_32BIT		0x100
+#define HPET_TN_LEVEL		0x0002
+#define HPET_TN_ENABLE		0x0004
+#define HPET_TN_PERIODIC	0x0008
+#define HPET_TN_PERIODIC_CAP	0x0010
+#define HPET_TN_64BIT_CAP	0x0020
+#define HPET_TN_SETVAL		0x0040
+#define HPET_TN_32BIT		0x0100
+#define HPET_TN_ROUTE		0x3e00
+#define HPET_TN_FSB		0x4000
+#define HPET_TN_FSB_CAP		0x8000
+
+#define HPET_TN_ROUTE_SHIFT	9
 
 /* Use our own asm for 64 bit multiply/divide */
 #define ASM_MUL64_REG(eax_out,edx_out,reg_in,eax_in) 			\
Index: linux-2.6.21-tolkml/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.21-tolkml.orig/arch/i386/kernel/hpet.c	2007-05-07 09:54:47.000000000 -0700
+++ linux-2.6.21-tolkml/arch/i386/kernel/hpet.c	2007-05-07 10:22:02.000000000 -0700
@@ -5,9 +5,11 @@
 #include <linux/init.h>
 #include <linux/sysdev.h>
 #include <linux/pm.h>
+#include <linux/cpu.h>
 
 #include <asm/hpet.h>
 #include <asm/io.h>
+#include <asm/io_apic.h>
 
 extern struct clock_event_device *global_clock_event;
 
@@ -23,6 +25,12 @@
 unsigned long hpet_address;
 static void __iomem * hpet_virt_address;
 
+static enum {
+	HPET_INT_NONE = 0,
+	HPET_INT_LEGACY,
+	HPET_INT_STD
+} hpet_preferred_int_mode;
+
 static inline unsigned long hpet_readl(unsigned long a)
 {
 	return readl(hpet_virt_address + a);
@@ -280,6 +288,445 @@
 }
 
 /*
+ * Setting up HPET interrupts in standard mode
+ * (as opposed to legacy replacement mode)
+ */
+
+/* Eventsource */
+static unsigned int hpet_num_timers_used;
+
+#define HPET_DEV_FLAG_ONESHOT	0x1
+#define HPET_DEV_FLAG_TEST	0x10
+
+#define HPET_PERCPU_EVENT	1
+#define HPET_GLOBAL_EVENT	2
+
+#define HPET_INTERRUPT_TEST_COUNT	5
+
+/* HPET as clockevent in normal int mode */
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
+static struct hpet_dev *cpu_hpet_dev; /* per CPU ptr */
+
+static irqreturn_t hpet_std_interrupt(int irq, void *data);
+
+static irqreturn_t hpet_std_interrupt_test(int irq, void *data)
+{
+	unsigned int readin;
+	struct hpet_dev *dev = (struct hpet_dev *)data;
+
+	dev->count++;
+	if (dev->count < HPET_INTERRUPT_TEST_COUNT) {
+		readin = hpet_readl(HPET_COUNTER);
+		hpet_writel(readin + dev->tick, HPET_Tn_CMP(dev->num));
+	}
+	return IRQ_HANDLED;
+}
+
+static unsigned int cpu_hpet_irq[NR_CPUS] = {[0 ... NR_CPUS-1] = -1};
+static unsigned long assigned_irqs_map = 0;
+
+/* Called sequentially and hence no synchronization */
+static int hpet_assign_irq(struct hpet_dev *dev)
+{
+	unsigned int irq = -1;
+	unsigned int cpu = dev->cpu;
+	int ret = 0;
+
+	dev->irq = irq;
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
+		avail_irqs_map = possible_irqs_map & (~assigned_irqs_map);
+		if (unlikely(!avail_irqs_map))
+			return -1;
+
+		irq = find_first_bit((void *)&avail_irqs_map,
+				sizeof(unsigned int));
+
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
+static void hpet_setup_timer_on(struct hpet_dev *dev)
+{
+#ifdef CONFIG_SMP
+	cpumask_t mask;
+
+	/* Interrupt is directed to specific CPU with balancing disabled */
+	cpus_clear(mask);
+	cpu_set(dev->cpu, mask);
+	set_pending_irq(dev->irq, mask);
+#endif
+	hpet_writel((HPET_TN_32BIT | HPET_TN_LEVEL |
+	             (dev->irq << HPET_TN_ROUTE_SHIFT)),
+		    HPET_Tn_CFG(dev->num));
+}
+
+static int hpet_setup_int(struct hpet_dev *dev)
+{
+	unsigned int readin;
+
+	if (request_irq(dev->irq, hpet_std_interrupt,
+		       IRQF_SHARED|IRQF_NOBALANCING, dev->name, dev)) {
+		return -1;
+	}
+
+	readin = hpet_readl(HPET_Tn_CFG(dev->num));
+	hpet_writel(HPET_TN_ENABLE | readin, HPET_Tn_CFG(dev->num));
+
+	return 0;
+}
+
+static void hpet_std_timer_setup(enum clock_event_mode mode,
+			struct clock_event_device *evt);
+
+static int hpet_std_next_event(unsigned long delta,
+			struct clock_event_device *evt);
+
+static struct clock_event_device hpet_std_clockevent = {
+	.name		= "hpet",
+	.features	= CLOCK_EVT_FEAT_ONESHOT,
+	.mult		= 0, /* set below */
+	.shift		= HPET_SHIFT,
+	.rating		= 110,
+	.set_mode	= hpet_std_timer_setup,
+	.set_next_event	= hpet_std_next_event,
+};
+
+static struct clock_event_device *cpu_hpet_event; /* per CPU ptr */
+
+static void hpet_std_timer_setup(enum clock_event_mode mode,
+			struct clock_event_device *evt)
+{
+	unsigned int cpu = first_cpu(evt->cpumask);
+	struct hpet_dev *hdev = per_cpu_ptr(cpu_hpet_dev, cpu);
+	unsigned int readin;
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_ONESHOT:
+		hdev->flags |= HPET_DEV_FLAG_ONESHOT;
+		readin = hpet_readl(HPET_Tn_CFG(hdev->num));
+		hpet_writel(readin | HPET_TN_ENABLE, HPET_Tn_CFG(hdev->num));
+		break;
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		hdev->flags &= (~HPET_DEV_FLAG_ONESHOT);
+		readin = hpet_readl(HPET_Tn_CFG(hdev->num));
+		hpet_writel(readin & (~HPET_TN_ENABLE), HPET_Tn_CFG(hdev->num));
+		break;
+	default:
+		break;
+	}
+}
+
+static int hpet_std_next_event(unsigned long delta,
+			struct clock_event_device *evt)
+{
+	unsigned int cpu = first_cpu(evt->cpumask);
+	struct hpet_dev *hdev = per_cpu_ptr(cpu_hpet_dev, cpu);
+	unsigned int cnt, cfg;
+
+	cnt = hpet_readl(HPET_COUNTER);
+	cnt += (unsigned int)delta;
+	hpet_writel(cnt, HPET_Tn_CMP(hdev->num));
+	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
+	hpet_writel(cfg | HPET_TN_ENABLE, HPET_Tn_CFG(hdev->num));
+
+	return ((long)(hpet_readl(HPET_COUNTER) - cnt ) > 0) ? -ETIME : 0;
+}
+
+static irqreturn_t hpet_std_interrupt(int irq, void *data)
+{
+	unsigned int readin, status;
+	struct hpet_dev *dev = (struct hpet_dev *)data;
+	struct clock_event_device *hevt = per_cpu_ptr(cpu_hpet_event, dev->cpu);
+
+	status = hpet_readl(HPET_STATUS);
+	if (!(status & (0x1 << dev->num))) {
+		return IRQ_NONE;
+	}
+	hpet_writel((0x1 << dev->num), HPET_STATUS);
+
+	if (unlikely(dev->flags & HPET_DEV_FLAG_TEST))
+		return hpet_std_interrupt_test(irq, data);
+
+	dev->count++;
+
+	if (dev->flags & HPET_DEV_FLAG_ONESHOT) {
+		readin = hpet_readl(HPET_Tn_CFG(dev->num));
+		hpet_writel(readin & (~HPET_TN_ENABLE), HPET_Tn_CFG(dev->num));
+	}
+
+	if (!hevt->event_handler) {
+		printk("Spurious HPET timer interrupt on HPET timer %d\n",
+			       dev->num);
+		return IRQ_HANDLED;
+	}
+
+	hevt->event_handler(hevt);
+
+	return IRQ_HANDLED;
+}
+
+static void setup_cpu_hpet_timer(void *param, int cpu)
+{
+	struct clock_event_device *hevt = per_cpu_ptr(cpu_hpet_event, cpu);
+	struct hpet_dev *hdev = per_cpu_ptr(cpu_hpet_dev, cpu);
+
+	memcpy(hevt, &hpet_std_clockevent, sizeof(*hevt));
+	if ((unsigned long)param == HPET_PERCPU_EVENT) {
+		hevt->cpumask = cpumask_of_cpu(cpu);
+		hevt->irq = hdev->irq;
+	} else if ((unsigned long)param == HPET_GLOBAL_EVENT) {
+		hevt->cpumask = cpumask_of_cpu(0);
+		hevt->irq = hdev->irq;
+	}
+
+	clockevents_register_device(hevt);
+	if ((unsigned long)param == HPET_GLOBAL_EVENT)
+		global_clock_event = hevt;
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+static int hpet_cpu_callback(struct notifier_block *nfb,
+					unsigned long action, void *hcpu)
+{
+	int cpu = (unsigned long)hcpu;
+	struct hpet_dev *dev = per_cpu_ptr(cpu_hpet_dev, cpu);
+
+	if (action == CPU_ONLINE) {
+		cpumask_t irq_mask;
+		cpumask_t saved_mask;
+
+		saved_mask = current->cpus_allowed;
+		set_cpus_allowed(current, cpumask_of_cpu(cpu));
+
+		cpus_clear(irq_mask);
+		cpu_set(dev->cpu, irq_mask);
+		set_pending_irq(dev->irq, irq_mask);
+		setup_cpu_hpet_timer((void *)HPET_PERCPU_EVENT, cpu);
+		set_cpus_allowed(current, saved_mask);
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata hpet_cpu_notifier =
+{
+    .notifier_call = hpet_cpu_callback,
+};
+#endif
+
+static int hpet_std_clockevent_register(void)
+{
+	unsigned int id, cfg;
+	int ret = 0;
+	struct hpet_dev **hdev;
+	unsigned long long tmp;
+	unsigned long long tmp1;
+	unsigned int num_timers;
+	unsigned int percpu_timer;
+	int i;
+	unsigned int pre;
+	uint64_t hpet_freq;
+	unsigned long hpet_tick;
+
+	if (!hpet_virt_address)
+		return -ENODEV;
+
+	/*
+	 * The period is a femto seconds value. We need to calculate the
+	 * scaled math multiplication factor for nanosecond to hpet tick
+	 * conversion.
+	 */
+	hpet_freq = 1000000000000000ULL;
+	do_div(hpet_freq, hpet_period);
+	do_div(hpet_freq, HZ);
+	hpet_tick = (unsigned int)hpet_freq;
+
+	id = hpet_readl(HPET_ID);
+	num_timers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT);
+	num_timers++; /* Value read out starts from 0 */
+
+	if (num_possible_cpus() <= 2 &&
+	    num_possible_cpus() == num_online_cpus() &&
+	    num_possible_cpus() <= num_timers) {
+		percpu_timer = 1;
+		hpet_num_timers_used = num_possible_cpus();
+	} else {
+		percpu_timer = 0;
+		hpet_num_timers_used = 1;
+	}
+
+	cpu_hpet_dev = alloc_percpu(struct hpet_dev);
+	if (cpu_hpet_dev == NULL)
+		return -1;
+
+	cpu_hpet_event = alloc_percpu(struct clock_event_device);
+	if (cpu_hpet_event == NULL)
+		goto free_percpu_1_exit;
+
+	hdev = kzalloc(sizeof(struct hpet_dev *) * hpet_num_timers_used,
+	               GFP_KERNEL);
+	if (!hdev)
+		goto free_percpu_exit;
+
+	for (i = 0; i < hpet_num_timers_used; i++) {
+		hdev[i] = per_cpu_ptr(cpu_hpet_dev, i);
+		hdev[i]->num = i;
+		hdev[i]->cpu = i;
+
+		hdev[i]->tick = hpet_tick;
+		hdev[i]->count = 0;
+		hdev[i]->flags |= HPET_DEV_FLAG_TEST;
+		sprintf(hdev[i]->name, "hpet%d", i);
+
+		if (hpet_assign_irq(hdev[i]) || (hdev[i]->irq < 0)) {
+			printk(KERN_DEBUG "HPET IRQ allocation failed\n");
+			goto free_exit;
+		}
+	}
+
+	for (i = 0; i < hpet_num_timers_used; i++) {
+		hpet_setup_timer_on(hdev[i]);
+		if (hpet_setup_int(hdev[i])) {
+			printk(KERN_DEBUG "HPET setup interrupt failed\n");
+			hpet_num_timers_used = i-1;
+			goto free_irq_exit;
+		}
+	}
+
+	/* Stop the timers until we setup the test events */
+	cfg = hpet_readl(HPET_CFG);
+	cfg &= (~HPET_CFG_ENABLE);
+	hpet_writel(cfg, HPET_CFG);
+
+	pre = hpet_readl(HPET_COUNTER);
+	for (i = 0; i < hpet_num_timers_used; i++)
+		hpet_writel(pre + hpet_tick, HPET_Tn_CMP(i));
+
+	/* Start the timers and test events */
+	cfg = hpet_readl(HPET_CFG);
+	cfg |= HPET_CFG_ENABLE;
+	hpet_writel(cfg, HPET_CFG);
+
+	msleep(HPET_INTERRUPT_TEST_COUNT * 2 * 1000 / HZ);
+
+	for (i = 0; i < hpet_num_timers_used; i++)
+		hdev[i]->flags &= (~HPET_DEV_FLAG_TEST);
+
+	for (i = 0; i < hpet_num_timers_used; i++) {
+		if (hdev[i]->count < HPET_INTERRUPT_TEST_COUNT) {
+			printk("HPET interrupt test failed on timer %d. "
+				"expected int %d, got %d\n",
+				i, HPET_INTERRUPT_TEST_COUNT, hdev[i]->count);
+			goto free_irq_exit;
+		}
+	}
+
+	/*
+	 * Convert hpet_period to ticks/ns and then calculate multiplier with
+	 * HPET_SHIFT
+	 */
+	tmp = (u64)hpet_period;
+
+	do_div(tmp, FSEC_PER_NSEC);
+
+	tmp1 = 1 << HPET_SHIFT;
+	do_div(tmp1, (u32)tmp);
+
+	hpet_std_clockevent.mult = (u32)tmp1;
+
+	hpet_std_clockevent.min_delta_ns =
+		clockevent_delta2ns(hpet_tick, &hpet_std_clockevent);
+	hpet_std_clockevent.max_delta_ns =
+		clockevent_delta2ns(0x7FFFFFFF, &hpet_std_clockevent);
+
+	if (percpu_timer) {
+		cpumask_t saved_mask;
+
+		saved_mask = current->cpus_allowed;
+		for_each_online_cpu(i) {
+			set_cpus_allowed(current, cpumask_of_cpu(i));
+			setup_cpu_hpet_timer((void *)HPET_PERCPU_EVENT, i);
+		}
+		set_cpus_allowed(current, saved_mask);
+#ifdef CONFIG_HOTPLUG_CPU
+		register_hotcpu_notifier(&hpet_cpu_notifier);
+#endif
+	} else {
+		cpumask_t saved_mask;
+		saved_mask = current->cpus_allowed;
+		set_cpus_allowed(current, cpumask_of_cpu(0));
+		/* Reduce the rating as event device is not per cpu */
+		hpet_std_clockevent.rating -= 20;
+		setup_cpu_hpet_timer((void *)HPET_GLOBAL_EVENT, 0);
+		set_cpus_allowed(current, saved_mask);
+	}
+
+	kfree(hdev);
+	return ret;
+
+	/* Cleanup on failure */
+free_irq_exit:
+	for (i = 0; i < hpet_num_timers_used; i++) {
+		unsigned int readin;
+
+		readin = hpet_readl(HPET_Tn_CFG((hdev[i])->num));
+		hpet_writel(HPET_TN_ENABLE | readin,
+		            HPET_Tn_CFG((hdev[i])->num));
+
+		free_irq(hdev[i]->irq, hdev[i]);
+	}
+
+free_exit:
+	kfree(hdev);
+
+free_percpu_exit:
+	free_percpu(cpu_hpet_event);
+free_percpu_1_exit:
+	free_percpu(cpu_hpet_dev);
+	hpet_num_timers_used = 0;
+	return -1;
+}
+
+/*
  * Try to setup the HPET timer
  */
 int __init hpet_enable(void)
@@ -318,7 +765,10 @@
 
 	hpet_clocksource_register();
 
-	if (id & HPET_ID_LEGSUP) {
+	if (hpet_preferred_int_mode == HPET_INT_STD) {
+		hpet_reserve_platform_timers(id);
+		return hpet_std_clockevent_register();
+	} else if (id & HPET_ID_LEGSUP) {
 		hpet_reserve_platform_timers(id);
 		hpet_legacy_clockevent_register();
 		return 1;
@@ -335,6 +785,8 @@
 
 static int __init hpet_late_init(void)
 {
+	int ret;
+
 	if (boot_hpet_disable)
 		return -ENODEV;
 
@@ -343,8 +795,9 @@
 			return -ENODEV;
 
 		hpet_address = force_hpet_address;
-		hpet_enable();
-		if (!hpet_virt_address)
+		hpet_preferred_int_mode = HPET_INT_STD;
+		ret = hpet_enable();
+		if (ret < 0 || !hpet_virt_address)
 			return -ENODEV;
 	}
 
@@ -583,16 +1036,21 @@
 
 static int hpet_resume(struct sys_device *sys_device)
 {
-	unsigned int id;
-
+	unsigned int id = hpet_readl(HPET_ID);
+ 
+	if (hpet_legacy_int_enabled && (id & HPET_ID_LEGSUP))
+ 		hpet_enable_legacy_int();
+	else if (cpu_hpet_dev) {
+		int i;
+		for (i = 0; i < hpet_num_timers_used; i++) {
+			struct hpet_dev *hdev;
+			hdev = per_cpu_ptr(cpu_hpet_dev, i);
+			hpet_setup_timer_on(hdev);
+		}
+	}
+ 
 	hpet_start_counter();
-
-	id = hpet_readl(HPET_ID);
-
-	if (id & HPET_ID_LEGSUP)
-		hpet_enable_legacy_int();
-
-	return 0;
+ 	return 0;
 }
 
 static struct sysdev_class hpet_class = {
Index: linux-2.6.21-tolkml/include/asm-i386/io_apic.h
===================================================================
--- linux-2.6.21-tolkml.orig/include/asm-i386/io_apic.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21-tolkml/include/asm-i386/io_apic.h	2007-05-07 10:09:15.000000000 -0700
@@ -144,6 +144,12 @@
 extern int io_apic_get_redir_entries (int ioapic);
 extern int io_apic_set_pci_routing (int ioapic, int pin, int irq, int edge_level, int active_high_low);
 extern int timer_uses_ioapic_pin_0;
+#else
+static inline int io_apic_set_pci_routing(int ioapic, int pin, int irq,
+				int edge_level, int active_high_low)
+{
+	return -1;
+}
 #endif /* CONFIG_ACPI */
 
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);
@@ -151,6 +157,11 @@
 #else  /* !CONFIG_X86_IO_APIC */
 #define io_apic_assign_pci_irqs 0
 static inline void disable_ioapic_setup(void) { }
+static inline int io_apic_set_pci_routing(int ioapic, int pin, int irq,
+				int edge_level, int active_high_low)
+{
+	return -1;
+}
 #endif
 
 #endif
