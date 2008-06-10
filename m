Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbYFJMeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbYFJMeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 08:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbYFJMeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 08:34:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44829 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbYFJMeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 08:34:08 -0400
Message-Id: <20080610111832.757468709@chello.nl>
References: <20080610111259.766940257@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 10 Jun 2008 13:13:01 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH -rt 2/5] cpu-hotplug: vs page_alloc
Content-Disposition: inline; filename=hotplug-page_alloc.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On -rt we protect per-cpu state by locks instead of disabling preemption/irqs.
This keeps all the code preemptible at the cost of possible remote memory
access.

The race was that cpu-hotplug - which assumes to be cpu local and non-
preemptible, didn't take the per-cpu lock.

This also means that the normal lock acquire needs to be aware of cpus getting
off-lined while its waiting.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/page_alloc.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

Index: linux-2.6.24.7.noarch/mm/page_alloc.c
===================================================================
--- linux-2.6.24.7.noarch.orig/mm/page_alloc.c
+++ linux-2.6.24.7.noarch/mm/page_alloc.c
@@ -176,7 +176,19 @@ static inline void __lock_cpu_pcp(unsign
 static inline void lock_cpu_pcp(unsigned long *flags, int *this_cpu)
 {
 #ifdef CONFIG_PREEMPT_RT
-	(void)get_cpu_var_locked(pcp_locks, this_cpu);
+	spinlock_t *lock;
+	int cpu;
+
+again:
+	cpu = raw_smp_processor_id();
+	lock = &__get_cpu_lock(pcp_locks, cpu);
+
+	spin_lock(lock);
+	if (unlikely(!cpu_online(cpu))) {
+		spin_unlock(lock);
+		goto again;
+	}
+	*this_cpu = cpu;
 	flags = 0;
 #else
 	local_irq_save(*flags);
@@ -2781,12 +2793,17 @@ static inline void free_zone_pagesets(in
 	struct zone *zone;
 
 	for_each_zone(zone) {
-		struct per_cpu_pageset *pset = zone_pcp(zone, cpu);
+		struct per_cpu_pageset *pset;
+		unsigned long flags;
+
+		__lock_cpu_pcp(&flags, cpu);
+		pset = zone_pcp(zone, cpu);
+		zone_pcp(zone, cpu) = NULL;
+		unlock_cpu_pcp(flags, cpu);
 
 		/* Free per_cpu_pageset if it is slab allocated */
 		if (pset != &boot_pageset[cpu])
 			kfree(pset);
-		zone_pcp(zone, cpu) = NULL;
 	}
 }
 
@@ -2812,6 +2829,7 @@ static int __cpuinit pageset_cpuup_callb
 	default:
 		break;
 	}
+
 	return ret;
 }
 

-- 

