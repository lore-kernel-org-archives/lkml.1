Return-Path: <linux-kernel-owner+w=401wt.eu-S1759715AbYB0W1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715AbYB0W1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:27:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbYB0W0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:26:25 -0500
Received: from viefep32-int.chello.at ([62.179.121.50]:34950 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbYB0W0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:26:23 -0500
Message-Id: <20080227222542.659932000@chello.nl>
References: <20080227222103.673194000@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 27 Feb 2008 23:21:06 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Jackson <pj@sgi.com>, Max Krasnyanskiy <maxk@qualcomm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 3/4] genirq: system set irq affinities
Content-Disposition: inline; filename=cpuset-system-irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep the affinity of unbound IRQs within the system set.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/alpha/kernel/irq.c |    2 -
 include/linux/irq.h     |    7 -----
 kernel/irq/manage.c     |   62 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/alpha/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq.c
+++ linux-2.6/arch/alpha/kernel/irq.c
@@ -51,7 +51,7 @@ select_smp_affinity(unsigned int irq)
 	if (!irq_desc[irq].chip->set_affinity || irq_user_affinity[irq])
 		return 1;
 
-	while (!cpu_possible(cpu))
+	while (!cpu_possible(cpu) || !cpu_system(cpu))
 		cpu = (cpu < (NR_CPUS-1) ? cpu + 1 : 0);
 	last_cpu = cpu;
 
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -253,14 +253,7 @@ static inline void set_balance_irq_affin
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
 
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -11,6 +11,8 @@
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/interrupt.h>
+#include <linux/cpumask.h>
+#include <linux/cpuset.h>
 
 #include "internals.h"
 
@@ -488,6 +490,24 @@ void free_irq(unsigned int irq, void *de
 }
 EXPORT_SYMBOL(free_irq);
 
+#ifndef CONFIG_AUTO_IRQ_AFFINITY
+int select_smp_affinity(unsigned int irq)
+{
+	cpumask_t online_system;
+
+	if (!irq_can_set_affinity(irq))
+		return 0;
+
+	cpus_and(online_system, cpu_system_map, cpu_online_map);
+
+	set_balance_irq_affinity(irq, online_system);
+
+	irq_desc[irq].affinity = online_system;
+	irq_desc[irq].chip->set_affinity(irq, online_system);
+	return 0;
+}
+#endif
+
 /**
  *	request_irq - allocate an interrupt line
  *	@irq: Interrupt line to allocate
@@ -580,3 +600,45 @@ int request_irq(unsigned int irq, irq_ha
 	return retval;
 }
 EXPORT_SYMBOL(request_irq);
+
+#ifdef CONFIG_CPUSETS
+static int system_irq_notifier(struct notifier_block *nb,
+		unsigned long action, void *cpus)
+{
+	cpumask_t *new_system_map = (cpumask_t *)cpus;
+	int i;
+
+	for (i = 0; i < NR_IRQS; i++) {
+		struct irq_desc *desc = &irq_desc[i];
+
+		if (desc->chip == &no_irq_chip || !irq_can_set_affinity(i))
+			continue;
+
+		if (cpus_match_system(desc->affinity)) {
+			cpumask_t online_system;
+
+			cpus_and(online_system, new_system_map, cpu_online_map);
+
+			set_balance_irq_affinity(i, online_system);
+
+			desc->affinity = online_system;
+			desc->chip->set_affinity(i, online_system);
+		}
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block fn_system_irq_notifier = {
+	.notifier_call = system_irq_notifier,
+};
+
+static int __init init_irq(void)
+{
+	blocking_notifier_chain_register(&system_map_notifier,
+			&fn_system_irq_notifier);
+	return 0;
+}
+
+module_init(init_irq);
+#endif

--

