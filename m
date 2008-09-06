Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbYIFBGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbYIFBGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 21:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYIFBFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 21:05:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:27220 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbYIFBFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 21:05:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,343,1217833200"; 
   d="scan'208";a="436263631"
Message-Id: <20080906010448.845436000@intel.com>
References: <20080906010214.229910000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 05 Sep 2008 18:02:18 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, shaohua.li@intel.com,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [RFC 4/4] x86: HPET_MSI Initialise per-cpu HPET timers
Content-Disposition: inline; filename=hpet_msi_percpu_timer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize a per CPU HPET MSI timer when possible. We retain the HPET
timer 0 (IRQ 0) and timer 1 (IRQ 8) as is when legacy mode is being used. We
setup the remaining HPET timers as per CPU MSI based timers. This per CPU
timer will eliminate the need for timer broadcasting with IRQ 0 when there
is non-functional LAPIC timer across CPU deep C-states.

If there are more CPUs than number of available timers, CPUs that do not
find any timer to use will continue using LAPIC and IRQ 0 broadcast.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 arch/x86/kernel/hpet.c |  293 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 291 insertions(+), 2 deletions(-)

Index: tip/arch/x86/kernel/hpet.c
===================================================================
--- tip.orig/arch/x86/kernel/hpet.c	2008-09-05 17:20:03.000000000 -0700
+++ tip/arch/x86/kernel/hpet.c	2008-09-05 17:20:58.000000000 -0700
@@ -21,10 +21,19 @@
    NSEC = 10^-9 */
 #define FSEC_PER_NSEC	1000000L
 
+#define HPET_DEV_USED_BIT	2
+#define HPET_DEV_USED		(1 << HPET_DEV_USED_BIT)
+#define HPET_DEV_VALID		0x8
+#define HPET_DEV_FSB_CAP	0x1000
+#define HPET_DEV_PERI_CAP	0x2000
+
+#define EVT_TO_HPET_DEV(evt) container_of(evt, struct hpet_dev, evt)
+
 /*
  * HPET address is set in acpi/boot.c, when an ACPI entry exists
  */
 unsigned long hpet_address;
+unsigned long hpet_num_timers;
 static void __iomem *hpet_virt_address;
 
 struct hpet_dev {
@@ -35,6 +44,8 @@ struct hpet_dev {
 	unsigned int flags;
 	char name[10];
 };
+static struct hpet_dev *hpet_devs;
+static DEFINE_PER_CPU(struct hpet_dev *, cpu_hpet_dev);
 
 unsigned long hpet_readl(unsigned long a)
 {
@@ -145,6 +156,16 @@ static void hpet_reserve_platform_timers
 			Tn_INT_ROUTE_CNF_SHIFT;
 	}
 
+	for (i = 0; i < nrtimers; i++) {
+		struct hpet_dev *hdev = &hpet_devs[i];
+
+		if (!(hdev->flags & HPET_DEV_VALID))
+			continue;
+
+		hd.hd_irq[hdev->num] = hdev->irq;
+		hpet_reserve_timer(&hd, hdev->num);
+	}
+
 	hpet_alloc(&hd);
 
 }
@@ -238,6 +259,8 @@ static void hpet_legacy_clockevent_regis
 	printk(KERN_DEBUG "hpet clockevent registered\n");
 }
 
+static int hpet_setup_msi_irq(unsigned int irq);
+
 static void hpet_set_mode(enum clock_event_mode mode,
 			  struct clock_event_device *evt, int timer)
 {
@@ -279,7 +302,15 @@ static void hpet_set_mode(enum clock_eve
 		break;
 
 	case CLOCK_EVT_MODE_RESUME:
-		hpet_enable_legacy_int();
+		if (timer == 0) {
+			hpet_enable_legacy_int();
+		} else {
+			struct hpet_dev *hdev = EVT_TO_HPET_DEV(evt);
+			hpet_setup_msi_irq(hdev->irq);
+			disable_irq(hdev->irq);
+			irq_set_affinity(hdev->irq, cpumask_of_cpu(hdev->cpu));
+			enable_irq(hdev->irq);
+		}
 		break;
 	}
 }
@@ -311,7 +342,7 @@ static int hpet_legacy_next_event(unsign
 /*
  * HPET MSI Support
  */
-
+#ifdef CONFIG_PCI_MSI
 void hpet_msi_unmask(unsigned int irq)
 {
 	struct hpet_dev *hdev = get_irq_data(irq);
@@ -351,6 +382,253 @@ void hpet_msi_read(unsigned int irq, str
 	msg->address_hi = 0;
 }
 
+static void hpet_msi_set_mode(enum clock_event_mode mode,
+				struct clock_event_device *evt)
+{
+	struct hpet_dev *hdev = EVT_TO_HPET_DEV(evt);
+	hpet_set_mode(mode, evt, hdev->num);
+}
+
+static int hpet_msi_next_event(unsigned long delta,
+				struct clock_event_device *evt)
+{
+	struct hpet_dev *hdev = EVT_TO_HPET_DEV(evt);
+	return hpet_next_event(delta, evt, hdev->num);
+}
+
+static int hpet_setup_msi_irq(unsigned int irq)
+{
+	if (arch_setup_hpet_msi(irq)) {
+		destroy_irq(irq);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int hpet_assign_irq(struct hpet_dev *dev)
+{
+	unsigned int irq;
+
+	irq = create_irq();
+	if (!irq)
+		return -EINVAL;
+
+	set_irq_data(irq, dev);
+
+	if (hpet_setup_msi_irq(irq))
+		return -EINVAL;
+
+	dev->irq = irq;
+	return 0;
+}
+
+static irqreturn_t hpet_interrupt_handler(int irq, void *data)
+{
+	struct hpet_dev *dev = (struct hpet_dev *)data;
+	struct clock_event_device *hevt = &dev->evt;
+
+	if (!hevt->event_handler) {
+		printk(KERN_INFO "Spurious HPET timer interrupt on HPET timer %d\n",
+				dev->num);
+		return IRQ_HANDLED;
+	}
+
+	hevt->event_handler(hevt);
+	return IRQ_HANDLED;
+}
+
+static int hpet_setup_irq(struct hpet_dev *dev)
+{
+
+	if (request_irq(dev->irq, hpet_interrupt_handler,
+			IRQF_SHARED|IRQF_NOBALANCING, dev->name, dev))
+		return -1;
+
+	disable_irq(dev->irq);
+	irq_set_affinity(dev->irq, cpumask_of_cpu(dev->cpu));
+	enable_irq(dev->irq);
+
+	return 0;
+}
+
+/* This should be called in specific @cpu */
+static void init_one_hpet_msi_clockevent(struct hpet_dev *hdev, int cpu)
+{
+	struct clock_event_device *evt = &hdev->evt;
+	uint64_t hpet_freq;
+
+	WARN_ON(cpu != smp_processor_id());
+	if (!(hdev->flags & HPET_DEV_VALID))
+		return;
+
+	if (hpet_setup_msi_irq(hdev->irq))
+		return;
+
+	hdev->cpu = cpu;
+	per_cpu(cpu_hpet_dev, cpu) = hdev;
+	evt->name = hdev->name;
+	hpet_setup_irq(hdev);
+	evt->irq = hdev->irq;
+
+	evt->rating = 110;
+	evt->features = CLOCK_EVT_FEAT_ONESHOT;
+	if (hdev->flags & HPET_DEV_PERI_CAP)
+		evt->features |= CLOCK_EVT_FEAT_PERIODIC;
+
+	evt->set_mode = hpet_msi_set_mode;
+	evt->set_next_event = hpet_msi_next_event;
+	evt->shift = 32;
+
+	/*
+	 * The period is a femto seconds value. We need to calculate the
+	 * scaled math multiplication factor for nanosecond to hpet tick
+	 * conversion.
+	 */
+	hpet_freq = 1000000000000000ULL;
+	do_div(hpet_freq, hpet_period);
+	evt->mult = div_sc((unsigned long) hpet_freq,
+				      NSEC_PER_SEC, evt->shift);
+	/* Calculate the max delta */
+	evt->max_delta_ns = clockevent_delta2ns(0x7FFFFFFF, evt);
+	/* 5 usec minimum reprogramming delta. */
+	evt->min_delta_ns = 5000;
+
+	evt->cpumask = cpumask_of_cpu(hdev->cpu);
+	clockevents_register_device(evt);
+}
+
+#ifdef CONFIG_HPET
+/* Reserve at least one timer for userspace (/dev/hpet) */
+#define RESERVE_TIMERS 1
+#else
+#define RESERVE_TIMERS 0
+#endif
+void hpet_msi_capability_lookup(unsigned int start_timer)
+{
+	unsigned int id;
+	unsigned int num_timers;
+	unsigned int num_timers_used = 0;
+	int i;
+
+	id = hpet_readl(HPET_ID);
+
+	num_timers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT);
+	num_timers++; /* Value read out starts from 0 */
+
+	hpet_devs = kzalloc(sizeof(struct hpet_dev) * num_timers, GFP_KERNEL);
+	if (!hpet_devs)
+		return;
+
+	hpet_num_timers = num_timers;
+
+	for (i = start_timer; i < num_timers - RESERVE_TIMERS; i++) {
+		struct hpet_dev *hdev = &hpet_devs[num_timers_used];
+		unsigned long cfg = hpet_readl(HPET_Tn_CFG(i));
+
+		/* Only consider HPET timer with MSI support */
+		if (!(cfg & HPET_TN_FSB_CAP))
+			continue;
+
+		hdev->flags = 0;
+		if (cfg & HPET_TN_PERIODIC_CAP)
+			hdev->flags |= HPET_DEV_PERI_CAP;
+		hdev->num = i;
+
+		sprintf(hdev->name, "hpet%d", i);
+		if (hpet_assign_irq(hdev))
+			continue;
+
+		hdev->flags |= HPET_DEV_FSB_CAP;
+		hdev->flags |= HPET_DEV_VALID;
+		num_timers_used++;
+		if (num_timers_used == num_possible_cpus())
+			break;
+	}
+
+	printk(KERN_INFO "HPET: %d timers in total, %d timers will be used for per-cpu timer\n",
+		num_timers, num_timers_used);
+}
+
+static struct hpet_dev *hpet_get_unused_timer(void)
+{
+	int i;
+
+	if (!hpet_devs)
+		return NULL;
+
+	for (i = 0; i < hpet_num_timers; i++) {
+		struct hpet_dev *hdev = &hpet_devs[i];
+
+		if (!(hdev->flags & HPET_DEV_VALID))
+			continue;
+		if (test_and_set_bit(HPET_DEV_USED_BIT,
+			(unsigned long *)&hdev->flags))
+			continue;
+		return hdev;
+	}
+	return NULL;
+}
+
+struct hpet_work_struct {
+	struct delayed_work work;
+	struct completion complete;
+};
+
+static void hpet_work(struct work_struct *w)
+{
+	struct hpet_dev *hdev;
+	int cpu = smp_processor_id();
+	struct hpet_work_struct *hpet_work;
+
+	hpet_work = container_of(w, struct hpet_work_struct, work.work);
+
+	hdev = hpet_get_unused_timer();
+	if (hdev)
+		init_one_hpet_msi_clockevent(hdev, cpu);
+
+	complete(&hpet_work->complete);
+}
+
+static int hpet_cpuhp_notify(struct notifier_block *n,
+		unsigned long action, void *hcpu)
+{
+	unsigned long cpu = (unsigned long)hcpu;
+	struct hpet_work_struct work;
+	struct hpet_dev *hdev = per_cpu(cpu_hpet_dev, cpu);
+
+	switch (action & 0xf) {
+	case CPU_ONLINE:
+		INIT_DELAYED_WORK(&work.work, hpet_work);
+		init_completion(&work.complete);
+		/* FIXME: add schedule_work_on() */
+		schedule_delayed_work_on(cpu, &work.work, 0);
+		wait_for_completion(&work.complete);
+		break;
+	case CPU_DEAD:
+		if (hdev) {
+			free_irq(hdev->irq, hdev);
+			hdev->flags &= ~HPET_DEV_USED;
+			per_cpu(cpu_hpet_dev, cpu) = NULL;
+		}
+		break;
+	}
+	return NOTIFY_OK;
+}
+#else
+
+void hpet_msi_capability_lookup(unsigned int start_timer)
+{
+	return;
+}
+
+static int hpet_cpuhp_notify(struct notifier_block *n,
+		unsigned long action, void *hcpu)
+{
+	return NOTIFY_OK;
+}
+
+#endif
+
 /*
  * Clock source related code
  */
@@ -486,8 +764,10 @@ int __init hpet_enable(void)
 
 	if (id & HPET_ID_LEGSUP) {
 		hpet_legacy_clockevent_register();
+		hpet_msi_capability_lookup(2);
 		return 1;
 	}
+	hpet_msi_capability_lookup(0);
 	return 0;
 
 out_nohpet:
@@ -504,6 +784,8 @@ out_nohpet:
  */
 static __init int hpet_late_init(void)
 {
+	int cpu;
+
 	if (boot_hpet_disable)
 		return -ENODEV;
 
@@ -519,6 +801,13 @@ static __init int hpet_late_init(void)
 
 	hpet_reserve_platform_timers(hpet_readl(HPET_ID));
 
+	for_each_online_cpu(cpu) {
+		hpet_cpuhp_notify(NULL, CPU_ONLINE, (void *)(long)cpu);
+	}
+
+	/* This notifier should be called after workqueue is ready */
+	hotcpu_notifier(hpet_cpuhp_notify, -20);
+
 	return 0;
 }
 fs_initcall(hpet_late_init);

-- 

