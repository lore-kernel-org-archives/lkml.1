Return-Path: <linux-kernel-owner+w=401wt.eu-S1757115AbZDPBls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115AbZDPBls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 21:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756576AbZDPBl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 21:41:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:49494 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753757AbZDPBl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 21:41:27 -0400
Message-ID: <49E68C80.2090709@kernel.org>
Date: Wed, 15 Apr 2009 18:40:16 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/8] irq: correct CPUMASKS_OFFSTACK typo -v3
References: <49E68C41.4020801@kernel.org>
In-Reply-To: <49E68C41.4020801@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix smp_affinity copying when moving irq_desc

CPUMASKS_OFFSTACK is not defined anywhere. it is a typo
and init_allocate_desc_masks called before it set affinity to all cpus...

split init_alloc_desc_masks() into all_desc_masks() and init_desc_masks()
so in the init_copy_desc_masks could use CPUMASK_OFFSTACK there.
aka copy path will not calling init_desc_masks anymore.

also could use that CPUMASK_OFFSTACK in alloc_desc_masks()

v3: update after "remove numa_migrate irq_desc"

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>

---
 include/linux/irq.h |   27 ++++++++++++++++++---------
 kernel/irq/handle.c |    9 ++++++---
 2 files changed, 24 insertions(+), 12 deletions(-)

Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -414,27 +414,25 @@ extern int set_irq_msi(unsigned int irq,
 
 #ifdef CONFIG_SMP
 /**
- * init_alloc_desc_masks - allocate cpumasks for irq_desc
+ * alloc_desc_masks - allocate cpumasks for irq_desc
  * @desc:	pointer to irq_desc struct
  * @cpu:	cpu which will be handling the cpumasks
  * @boot:	true if need bootmem
  *
  * Allocates affinity and pending_mask cpumask if required.
  * Returns true if successful (or not required).
- * Side effect: affinity has all bits set, pending_mask has all bits clear.
  */
-static inline bool init_alloc_desc_masks(struct irq_desc *desc, int cpu,
+static inline bool alloc_desc_masks(struct irq_desc *desc, int cpu,
 								bool boot)
 {
+#ifdef CONFIG_CPUMASK_OFFSTACK
 	int node;
 
 	if (boot) {
 		alloc_bootmem_cpumask_var(&desc->affinity);
-		cpumask_setall(desc->affinity);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 		alloc_bootmem_cpumask_var(&desc->pending_mask);
-		cpumask_clear(desc->pending_mask);
 #endif
 		return true;
 	}
@@ -443,18 +441,25 @@ static inline bool init_alloc_desc_masks
 
 	if (!alloc_cpumask_var_node(&desc->affinity, GFP_ATOMIC, node))
 		return false;
-	cpumask_setall(desc->affinity);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	if (!alloc_cpumask_var_node(&desc->pending_mask, GFP_ATOMIC, node)) {
 		free_cpumask_var(desc->affinity);
 		return false;
 	}
-	cpumask_clear(desc->pending_mask);
+#endif
 #endif
 	return true;
 }
 
+static inline void init_desc_masks(struct irq_desc *desc)
+{
+	cpumask_setall(desc->affinity);
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	cpumask_clear(desc->pending_mask);
+#endif
+}
+
 /**
  * init_copy_desc_masks - copy cpumasks for irq_desc
  * @old_desc:	pointer to old irq_desc struct
@@ -468,7 +473,7 @@ static inline bool init_alloc_desc_masks
 static inline void init_copy_desc_masks(struct irq_desc *old_desc,
 					struct irq_desc *new_desc)
 {
-#ifdef CONFIG_CPUMASKS_OFFSTACK
+#ifdef CONFIG_CPUMASK_OFFSTACK
 	cpumask_copy(new_desc->affinity, old_desc->affinity);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
@@ -489,12 +494,16 @@ static inline void free_desc_masks(struc
 
 #else /* !CONFIG_SMP */
 
-static inline bool init_alloc_desc_masks(struct irq_desc *desc, int cpu,
+static inline bool alloc_desc_masks(struct irq_desc *desc, int cpu,
 								bool boot)
 {
 	return true;
 }
 
+static inline void init_desc_masks(struct irq_desc *desc)
+{
+}
+
 static inline void init_copy_desc_masks(struct irq_desc *old_desc,
 					struct irq_desc *new_desc)
 {
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -117,10 +117,11 @@ static void init_one_irq_desc(int irq, s
 		printk(KERN_ERR "can not alloc kstat_irqs\n");
 		BUG_ON(1);
 	}
-	if (!init_alloc_desc_masks(desc, cpu, false)) {
+	if (!alloc_desc_masks(desc, cpu, false)) {
 		printk(KERN_ERR "can not alloc irq_desc cpumasks\n");
 		BUG_ON(1);
 	}
+	init_desc_masks(desc);
 	arch_init_chip_data(desc, cpu);
 }
 
@@ -171,7 +172,8 @@ int __init early_irq_init(void)
 		desc[i].irq = i;
 		desc[i].kstat_irqs = kstat_irqs_legacy + i * nr_cpu_ids;
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
-		init_alloc_desc_masks(&desc[i], 0, true);
+		alloc_desc_masks(&desc[i], 0, true);
+		init_desc_masks(&desc[i]);
 		irq_desc_ptrs[i] = desc + i;
 	}
 
@@ -258,7 +260,8 @@ int __init early_irq_init(void)
 
 	for (i = 0; i < count; i++) {
 		desc[i].irq = i;
-		init_alloc_desc_masks(&desc[i], 0, true);
+		alloc_desc_masks(&desc[i], 0, true);
+		init_desc_masks(&desc[i]);
 		desc[i].kstat_irqs = kstat_irqs_all[i];
 	}
 	return arch_early_irq_init();
