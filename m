Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbYBWGTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbYBWGTd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 01:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYBWGTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 01:19:22 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44779 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYBWGTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 01:19:21 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5236"; a="877902"
Message-ID: <47BFBAE6.3040606@qualcomm.com>
Date: Fri, 22 Feb 2008 22:19:18 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC] Genirq and CPU isolation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

While reviewing CPU isolation patches Peter pointed out that instead of
changing arch specific irq handling I should be extending genirq code.
Which makes perfect sense. Why didn't I think of that before :)
Basically the idea is that by default isolated CPUs must not get HW
irqs routed to them (besides IPIs and stuff of course). 
Does the patch included below look like the right approach ?

btw select_smp_affinity() which is currently used only by alpha seemed
out of place. It's called multiple times for shared irqs. ie Every time
new handler is registered irq is moved to a different CPU.
So I moved it under "if (!shared)" check inside setup_irq().

The patch introduces generic version of the select_smp_affinity() that
sets the affinity mask to "online_cpus - isolated_cpus", and updates 
x86_32 and alpha load balancers to ignore isolated cpus.
Booted on Core2 laptop and dual Opteron boxes with and w/o isolcpus=
options and everything seems to work as expected.

I wanted to run this by you before I include it in my patch series.
Thanx
Max


diff --git a/arch/alpha/kernel/irq.c b/arch/alpha/kernel/irq.c
index facf82a..6b01702 100644
--- a/arch/alpha/kernel/irq.c
+++ b/arch/alpha/kernel/irq.c
@@ -51,7 +51,7 @@ select_smp_affinity(unsigned int irq)
 	if (!irq_desc[irq].chip->set_affinity || irq_user_affinity[irq])
 		return 1;
 
-	while (!cpu_possible(cpu))
+	while (!cpu_possible(cpu) || cpu_isolated(cpu))
 		cpu = (cpu < (NR_CPUS-1) ? cpu + 1 : 0);
 	last_cpu = cpu;
 
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index e02e58c..07352b7 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -21,9 +21,7 @@
 
 static cpumask_t flat_target_cpus(void)
 {
-	cpumask_t target;
-	cpus_andnot(target, cpu_online_map, cpu_isolated_map);
-	return target;
+	return cpu_online_map;
 }
 
 static cpumask_t flat_vector_allocation_domain(int cpu)
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 4ca5486..9c8816f 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -468,7 +468,7 @@ static void do_irq_balance(void)
 	for_each_possible_cpu(i) {
 		int package_index;
 		CPU_IRQ(i) = 0;
-		if (!cpu_online(i))
+		if (!cpu_online(i) || cpu_isolated(i))
 			continue;
 		package_index = CPU_TO_PACKAGEINDEX(i);
 		for (j = 0; j < NR_IRQS; j++) {
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 176e5e7..287bc64 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -253,14 +253,7 @@ static inline void set_balance_irq_affinity(unsigned int irq, cpumask_t mask)
 }
 #endif
 
-#ifdef CONFIG_AUTO_IRQ_AFFINITY
 extern int select_smp_affinity(unsigned int irq);
-#else
-static inline int select_smp_affinity(unsigned int irq)
-{
-	return 1;
-}
-#endif
 
 extern int no_irq_affinity;
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 438a014..e74db94 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -376,6 +376,9 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 		} else
 			/* Undo nested disables: */
 			desc->depth = 1;
+
+		/* Set default affinity mask once everything is setup */
+		select_smp_affinity(irq);
 	}
 	/* Reset broken irq detection when installing new handler */
 	desc->irq_count = 0;
@@ -488,6 +491,26 @@ void free_irq(unsigned int irq, void *dev_id)
 }
 EXPORT_SYMBOL(free_irq);
 
+#ifndef CONFIG_AUTO_IRQ_AFFINITY
+/**
+ * Generic version of the affinity autoselector.
+ * Called under desc->lock from setup_irq().
+ * btw Should we rename this to select_irq_affinity() ?
+ */
+int select_smp_affinity(unsigned int irq)
+{
+	cpumask_t usable_cpus;
+
+	if (!irq_can_set_affinity(irq))
+		return 0;
+
+	cpus_andnot(usable_cpus, cpu_online_map, cpu_isolated_map);
+	irq_desc[irq].affinity = usable_cpus;
+	irq_desc[irq].chip->set_affinity(irq, usable_cpus);
+	return 0;
+}
+#endif
+
 /**
  *	request_irq - allocate an interrupt line
  *	@irq: Interrupt line to allocate
@@ -555,8 +578,6 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 	action->next = NULL;
 	action->dev_id = dev_id;
 
-	select_smp_affinity(irq);
-
 #ifdef CONFIG_DEBUG_SHIRQ
 	if (irqflags & IRQF_SHARED) {
 		/*
