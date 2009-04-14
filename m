Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbZDNUnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbZDNUnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 16:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZDNUno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 16:43:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:33473 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbZDNUnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 16:43:43 -0400
Message-ID: <49E4F513.1060709@kernel.org>
Date: Tue, 14 Apr 2009 13:41:55 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Gary Hade <garyhade@us.ibm.com>, lcm@us.ibm.com,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] irq: correct CPUMASKS_OFFSTACK typo -v2
References: <200903231757.53709.rusty@rustcorp.com.au> <20090323165921.GA7559@us.ibm.com> <200903241553.58209.rusty@rustcorp.com.au> <20090402013108.GB7103@us.ibm.com> <20090404003520.GA8847@us.ibm.com> <20090410215515.GC7242@us.ibm.com> <20090411065510.GA11799@elte.hu> <20090413220321.GA11098@us.ibm.com> <49E4146C.7060507@kernel.org> <49E4162A.3060701@kernel.org> <20090414131711.GA4403@elte.hu>
In-Reply-To: <20090414131711.GA4403@elte.hu>
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

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>

---
 include/linux/irq.h       |   27 ++++++++++++++++++---------
 kernel/irq/handle.c       |    9 ++++++---
 kernel/irq/numa_migrate.c |    2 +-
 3 files changed, 25 insertions(+), 13 deletions(-)

Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -424,27 +424,25 @@ extern int set_irq_msi(unsigned int irq,
 
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
@@ -453,18 +451,25 @@ static inline bool init_alloc_desc_masks
 
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
@@ -478,7 +483,7 @@ static inline bool init_alloc_desc_masks
 static inline void init_copy_desc_masks(struct irq_desc *old_desc,
 					struct irq_desc *new_desc)
 {
-#ifdef CONFIG_CPUMASKS_OFFSTACK
+#ifdef CONFIG_CPUMASK_OFFSTACK
 	cpumask_copy(new_desc->affinity, old_desc->affinity);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
@@ -499,12 +504,16 @@ static inline void free_desc_masks(struc
 
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
@@ -115,10 +115,11 @@ static void init_one_irq_desc(int irq, s
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
 
@@ -169,7 +170,8 @@ int __init early_irq_init(void)
 		desc[i].irq = i;
 		desc[i].kstat_irqs = kstat_irqs_legacy + i * nr_cpu_ids;
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
-		init_alloc_desc_masks(&desc[i], 0, true);
+		alloc_desc_masks(&desc[i], 0, true);
+		init_desc_masks(&desc[i]);
 		irq_desc_ptrs[i] = desc + i;
 	}
 
@@ -256,7 +258,8 @@ int __init early_irq_init(void)
 
 	for (i = 0; i < count; i++) {
 		desc[i].irq = i;
-		init_alloc_desc_masks(&desc[i], 0, true);
+		alloc_desc_masks(&desc[i], 0, true);
+		init_desc_masks(&desc[i]);
 		desc[i].kstat_irqs = kstat_irqs_all[i];
 	}
 	return arch_early_irq_init();
Index: linux-2.6/kernel/irq/numa_migrate.c
===================================================================
--- linux-2.6.orig/kernel/irq/numa_migrate.c
+++ linux-2.6/kernel/irq/numa_migrate.c
@@ -37,7 +37,7 @@ static bool init_copy_one_irq_desc(int i
 		 struct irq_desc *desc, int cpu)
 {
 	memcpy(desc, old_desc, sizeof(struct irq_desc));
-	if (!init_alloc_desc_masks(desc, cpu, false)) {
+	if (!alloc_desc_masks(desc, cpu, false)) {
 		printk(KERN_ERR "irq %d: can not get new irq_desc cpumask "
 				"for migration.\n", irq);
 		return false;
