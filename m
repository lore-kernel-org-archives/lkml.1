Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbZJZWDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbZJZWDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 18:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbZJZWDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 18:03:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:21909 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291AbZJZWC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 18:02:58 -0400
X-ExtLoop1: 1
Message-Id: <20091026230001.562512739@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 26 Oct 2009 14:24:31 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, ebiederm@xmission.com
Cc: garyhade@us.ibm.com, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org
Subject: [patch 1/6] x86: unify fixup_irqs() for 32-bit and 64-bit kernels
References: <20091026222430.313656103@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=merge_fixup_irqs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to have different fixup_irqs() for 32-bit and 64-bit kernels.
Unify by using the superior 64bit version for both the kernels.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Gary Hade <garyhade@us.ibm.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/kernel/irq.c    |   59 +++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/irq_32.c |   45 -----------------------------------
 arch/x86/kernel/irq_64.c |   58 ----------------------------------------------
 3 files changed, 59 insertions(+), 103 deletions(-)

Index: tree/arch/x86/kernel/irq.c
===================================================================
--- tree.orig/arch/x86/kernel/irq.c
+++ tree/arch/x86/kernel/irq.c
@@ -274,3 +274,62 @@ void smp_generic_interrupt(struct pt_reg
 }
 
 EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
+
+#ifdef CONFIG_HOTPLUG_CPU
+/* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
+void fixup_irqs(void)
+{
+	unsigned int irq;
+	static int warned;
+	struct irq_desc *desc;
+
+	for_each_irq_desc(irq, desc) {
+		int break_affinity = 0;
+		int set_affinity = 1;
+		const struct cpumask *affinity;
+
+		if (!desc)
+			continue;
+		if (irq == 2)
+			continue;
+
+		/* interrupt's are disabled at this point */
+		spin_lock(&desc->lock);
+
+		affinity = desc->affinity;
+		if (!irq_has_action(irq) ||
+		    cpumask_equal(affinity, cpu_online_mask)) {
+			spin_unlock(&desc->lock);
+			continue;
+		}
+
+		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
+			break_affinity = 1;
+			affinity = cpu_all_mask;
+		}
+
+		if (desc->chip->mask)
+			desc->chip->mask(irq);
+
+		if (desc->chip->set_affinity)
+			desc->chip->set_affinity(irq, affinity);
+		else if (!(warned++))
+			set_affinity = 0;
+
+		if (desc->chip->unmask)
+			desc->chip->unmask(irq);
+
+		spin_unlock(&desc->lock);
+
+		if (break_affinity && set_affinity)
+			printk("Broke affinity for irq %i\n", irq);
+		else if (!set_affinity)
+			printk("Cannot set affinity for irq %i\n", irq);
+	}
+
+	/* That doesn't seem sufficient.  Give it 1ms. */
+	local_irq_enable();
+	mdelay(1);
+	local_irq_disable();
+}
+#endif
Index: tree/arch/x86/kernel/irq_32.c
===================================================================
--- tree.orig/arch/x86/kernel/irq_32.c
+++ tree/arch/x86/kernel/irq_32.c
@@ -211,48 +211,3 @@ bool handle_irq(unsigned irq, struct pt_
 
 	return true;
 }
-
-#ifdef CONFIG_HOTPLUG_CPU
-
-/* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
-void fixup_irqs(void)
-{
-	unsigned int irq;
-	struct irq_desc *desc;
-
-	for_each_irq_desc(irq, desc) {
-		const struct cpumask *affinity;
-
-		if (!desc)
-			continue;
-		if (irq == 2)
-			continue;
-
-		affinity = desc->affinity;
-		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
-			printk("Breaking affinity for irq %i\n", irq);
-			affinity = cpu_all_mask;
-		}
-		if (desc->chip->set_affinity)
-			desc->chip->set_affinity(irq, affinity);
-		else if (desc->action)
-			printk_once("Cannot set affinity for irq %i\n", irq);
-	}
-
-#if 0
-	barrier();
-	/* Ingo Molnar says: "after the IO-APIC masks have been redirected
-	   [note the nop - the interrupt-enable boundary on x86 is two
-	   instructions from sti] - to flush out pending hardirqs and
-	   IPIs. After this point nothing is supposed to reach this CPU." */
-	__asm__ __volatile__("sti; nop; cli");
-	barrier();
-#else
-	/* That doesn't seem sufficient.  Give it 1ms. */
-	local_irq_enable();
-	mdelay(1);
-	local_irq_disable();
-#endif
-}
-#endif
-
Index: tree/arch/x86/kernel/irq_64.c
===================================================================
--- tree.orig/arch/x86/kernel/irq_64.c
+++ tree/arch/x86/kernel/irq_64.c
@@ -62,64 +62,6 @@ bool handle_irq(unsigned irq, struct pt_
 	return true;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-/* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
-void fixup_irqs(void)
-{
-	unsigned int irq;
-	static int warned;
-	struct irq_desc *desc;
-
-	for_each_irq_desc(irq, desc) {
-		int break_affinity = 0;
-		int set_affinity = 1;
-		const struct cpumask *affinity;
-
-		if (!desc)
-			continue;
-		if (irq == 2)
-			continue;
-
-		/* interrupt's are disabled at this point */
-		spin_lock(&desc->lock);
-
-		affinity = desc->affinity;
-		if (!irq_has_action(irq) ||
-		    cpumask_equal(affinity, cpu_online_mask)) {
-			spin_unlock(&desc->lock);
-			continue;
-		}
-
-		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
-			break_affinity = 1;
-			affinity = cpu_all_mask;
-		}
-
-		if (desc->chip->mask)
-			desc->chip->mask(irq);
-
-		if (desc->chip->set_affinity)
-			desc->chip->set_affinity(irq, affinity);
-		else if (!(warned++))
-			set_affinity = 0;
-
-		if (desc->chip->unmask)
-			desc->chip->unmask(irq);
-
-		spin_unlock(&desc->lock);
-
-		if (break_affinity && set_affinity)
-			printk("Broke affinity for irq %i\n", irq);
-		else if (!set_affinity)
-			printk("Cannot set affinity for irq %i\n", irq);
-	}
-
-	/* That doesn't seem sufficient.  Give it 1ms. */
-	local_irq_enable();
-	mdelay(1);
-	local_irq_disable();
-}
-#endif
 
 extern void call_softirq(void);
 


