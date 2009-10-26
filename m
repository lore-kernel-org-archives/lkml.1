Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbZJZWDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbZJZWDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 18:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbZJZWDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 18:03:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:19890 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464AbZJZWCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 18:02:34 -0400
X-ExtLoop1: 1
Message-Id: <20091026230001.848830905@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 26 Oct 2009 14:24:34 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, ebiederm@xmission.com
Cc: garyhade@us.ibm.com, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org
Subject: [patch 4/6] x86: force irq complete move during cpu offline
References: <20091026222430.313656103@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=fix_assign_irq_vector_cpu_offline.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a cpu goes offline, fixup_irqs() try to move irq's currently
destined to the offline cpu to a new cpu. But this attempt will fail
if the irq is recently moved to this cpu and the irq still hasn't
arrived at this cpu (for non intr-remapping platforms this is when we free the
vector allocation at the previous destination) that is about to go offline.

This will endup with the interrupt subsystem still pointing the irq to
the offline cpu, causing that irq to not work any more.

Fix this by forcing the irq to complete its move (its been a long time
we moved the irq to this cpu which we are offlining now) and then
move this irq to a new cpu before this cpu goes offline.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Gary Hade <garyhade@us.ibm.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/include/asm/irq.h     |    1 +
 arch/x86/kernel/apic/io_apic.c |   18 +++++++++++++++---
 arch/x86/kernel/irq.c          |    7 +++++++
 3 files changed, 23 insertions(+), 3 deletions(-)

Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -2450,21 +2450,33 @@ unlock:
 	irq_exit();
 }
 
-static void irq_complete_move(struct irq_desc **descp)
+static void __irq_complete_move(struct irq_desc **descp, unsigned vector)
 {
 	struct irq_desc *desc = *descp;
 	struct irq_cfg *cfg = desc->chip_data;
-	unsigned vector, me;
+	unsigned me;
 
 	if (likely(!cfg->move_in_progress))
 		return;
 
-	vector = ~get_irq_regs()->orig_ax;
 	me = smp_processor_id();
 
 	if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
 		send_cleanup_vector(cfg);
 }
+
+static void irq_complete_move(struct irq_desc **descp)
+{
+	__irq_complete_move(descp, ~get_irq_regs()->orig_ax);
+}
+
+void irq_force_complete_move(int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_cfg *cfg = desc->chip_data;
+
+	__irq_complete_move(&desc, cfg->vector);
+}
 #else
 static inline void irq_complete_move(struct irq_desc **descp) {}
 #endif
Index: tip/arch/x86/kernel/irq.c
===================================================================
--- tip.orig/arch/x86/kernel/irq.c
+++ tip/arch/x86/kernel/irq.c
@@ -303,6 +303,13 @@ void fixup_irqs(void)
 			continue;
 		}
 
+		/*
+		 * Complete the irq move. This cpu is going down and for
+		 * non intr-remapping case, we can't wait till this interrupt
+		 * arrives at this cpu before completing the irq move.
+		 */
+		irq_force_complete_move(irq);
+
 		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
 			break_affinity = 1;
 			affinity = cpu_all_mask;
Index: tip/arch/x86/include/asm/irq.h
===================================================================
--- tip.orig/arch/x86/include/asm/irq.h
+++ tip/arch/x86/include/asm/irq.h
@@ -34,6 +34,7 @@ static inline int irq_canonicalize(int i
 #ifdef CONFIG_HOTPLUG_CPU
 #include <linux/cpumask.h>
 extern void fixup_irqs(void);
+extern void irq_force_complete_move(int);
 #endif
 
 extern void (*x86_platform_ipi_callback)(void);


