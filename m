Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYLPC1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYLPC1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 21:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYLPCYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 21:24:23 -0500
Received: from relay2.sgi.com ([192.48.179.30]:50749 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751842AbYLPCYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 21:24:14 -0500
Message-Id: <20081216022410.932065000@polaris-admin.engr.sgi.com>
References: <20081216022409.679598000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Dec 2008 18:24:17 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 08/16] x86: fixup_irqs() doesnt need an argument.
Content-Disposition: inline; filename=0012-x86-fixup_irqs-doesn-t-need-an-argument.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, remove on-stack cpumask.

The "map" arg is always cpu_online_mask.  Importantly, set_affinity
always ands the argument with cpu_online_mask anyway, so we don't need
to do it in fixup_irqs(), avoiding a temporary.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/include/asm/irq.h |    2 +-
 arch/x86/kernel/irq_32.c   |   13 +++++++------
 arch/x86/kernel/irq_64.c   |   15 ++++++++-------
 arch/x86/kernel/smpboot.c  |    2 +-
 4 files changed, 17 insertions(+), 15 deletions(-)

--- linux-2.6-for-ingo.orig/arch/x86/include/asm/irq.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/irq.h
@@ -37,7 +37,7 @@ extern int irqbalance_disable(char *str)
 
 #ifdef CONFIG_HOTPLUG_CPU
 #include <linux/cpumask.h>
-extern void fixup_irqs(cpumask_t map);
+extern void fixup_irqs(void);
 #endif
 
 extern unsigned int do_IRQ(struct pt_regs *regs);
--- linux-2.6-for-ingo.orig/arch/x86/kernel/irq_32.c
+++ linux-2.6-for-ingo/arch/x86/kernel/irq_32.c
@@ -233,27 +233,28 @@ unsigned int do_IRQ(struct pt_regs *regs
 #ifdef CONFIG_HOTPLUG_CPU
 #include <mach_apic.h>
 
-void fixup_irqs(cpumask_t map)
+/* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
+void fixup_irqs(void)
 {
 	unsigned int irq;
 	static int warned;
 	struct irq_desc *desc;
 
 	for_each_irq_desc(irq, desc) {
-		cpumask_t mask;
+		const struct cpumask *affinity;
 
 		if (!desc)
 			continue;
 		if (irq == 2)
 			continue;
 
-		cpus_and(mask, desc->affinity, map);
-		if (any_online_cpu(mask) == NR_CPUS) {
+		affinity = &desc->affinity;
+		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
 			printk("Breaking affinity for irq %i\n", irq);
-			mask = map;
+			affinity = cpu_all_mask;
 		}
 		if (desc->chip->set_affinity)
-			desc->chip->set_affinity(irq, &mask);
+			desc->chip->set_affinity(irq, affinity);
 		else if (desc->action && !(warned++))
 			printk("Cannot set affinity for irq %i\n", irq);
 	}
--- linux-2.6-for-ingo.orig/arch/x86/kernel/irq_64.c
+++ linux-2.6-for-ingo/arch/x86/kernel/irq_64.c
@@ -83,16 +83,17 @@ asmlinkage unsigned int do_IRQ(struct pt
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-void fixup_irqs(cpumask_t map)
+/* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
+void fixup_irqs(void)
 {
 	unsigned int irq;
 	static int warned;
 	struct irq_desc *desc;
 
 	for_each_irq_desc(irq, desc) {
-		cpumask_t mask;
 		int break_affinity = 0;
 		int set_affinity = 1;
+		const struct cpumask *affinity;
 
 		if (!desc)
 			continue;
@@ -102,23 +103,23 @@ void fixup_irqs(cpumask_t map)
 		/* interrupt's are disabled at this point */
 		spin_lock(&desc->lock);
 
+		affinity = &desc->affinity;
 		if (!irq_has_action(irq) ||
-		    cpus_equal(desc->affinity, map)) {
+		    cpumask_equal(affinity, cpu_online_mask)) {
 			spin_unlock(&desc->lock);
 			continue;
 		}
 
-		cpus_and(mask, desc->affinity, map);
-		if (cpus_empty(mask)) {
+		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
 			break_affinity = 1;
-			mask = map;
+			affinity = cpu_all_mask;
 		}
 
 		if (desc->chip->mask)
 			desc->chip->mask(irq);
 
 		if (desc->chip->set_affinity)
-			desc->chip->set_affinity(irq, &mask);
+			desc->chip->set_affinity(irq, affinity);
 		else if (!(warned++))
 			set_affinity = 0;
 
--- linux-2.6-for-ingo.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6-for-ingo/arch/x86/kernel/smpboot.c
@@ -1346,7 +1346,7 @@ void cpu_disable_common(void)
 	lock_vector_lock();
 	remove_cpu_from_maps(cpu);
 	unlock_vector_lock();
-	fixup_irqs(cpu_online_map);
+	fixup_irqs();
 }
 
 int native_cpu_disable(void)

-- 
