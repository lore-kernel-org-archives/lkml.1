Return-Path: <linux-kernel-owner+w=401wt.eu-S1758975AbZEARIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975AbZEARIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZEARIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:08:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:42739 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbZEARIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:08:11 -0400
Date: Fri, 1 May 2009 17:06:31 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49F6546E.3040406@kernel.org>
References: <49F6546E.3040406@kernel.org>
Subject: [tip:irq/numa] irq, cpumask: correct CPUMASKS_OFFSTACK typo and fix fallout
Message-ID: <tip-9ec4fa271faf2db3b8e1419c998da1ca6b094eb6@git.kernel.org>
Git-Commit-ID: 9ec4fa271faf2db3b8e1419c998da1ca6b094eb6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 01 May 2009 17:06:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ec4fa271faf2db3b8e1419c998da1ca6b094eb6
Gitweb:     http://git.kernel.org/tip/9ec4fa271faf2db3b8e1419c998da1ca6b094eb6
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 27 Apr 2009 17:57:18 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 28 Apr 2009 12:21:14 +0200

irq, cpumask: correct CPUMASKS_OFFSTACK typo and fix fallout

CPUMASKS_OFFSTACK is not defined anywhere (it is CPUMASK_OFFSTACK).
It is a typo and init_allocate_desc_masks() is called before it set
affinity to all cpus...

Split init_alloc_desc_masks() into all_desc_masks() and init_desc_masks().

Also use CPUMASK_OFFSTACK in alloc_desc_masks().

[ Impact: fix smp_affinity copying/setup when moving irq_desc between CPUs ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
LKML-Reference: <49F6546E.3040406@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/irq.h       |   27 ++++++++++++++++++---------
 kernel/irq/handle.c       |    9 ++++++---
 kernel/irq/numa_migrate.c |    2 +-
 3 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index b7cbeed..c4953cf 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -424,27 +424,25 @@ extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
 
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
@@ -453,18 +451,25 @@ static inline bool init_alloc_desc_masks(struct irq_desc *desc, int cpu,
 
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
@@ -478,7 +483,7 @@ static inline bool init_alloc_desc_masks(struct irq_desc *desc, int cpu,
 static inline void init_copy_desc_masks(struct irq_desc *old_desc,
 					struct irq_desc *new_desc)
 {
-#ifdef CONFIG_CPUMASKS_OFFSTACK
+#ifdef CONFIG_CPUMASK_OFFSTACK
 	cpumask_copy(new_desc->affinity, old_desc->affinity);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
@@ -499,12 +504,16 @@ static inline void free_desc_masks(struct irq_desc *old_desc,
 
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
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index d82142b..882c798 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -115,10 +115,11 @@ static void init_one_irq_desc(int irq, struct irq_desc *desc, int cpu)
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
diff --git a/kernel/irq/numa_migrate.c b/kernel/irq/numa_migrate.c
index 44bbdcb..5760d72 100644
--- a/kernel/irq/numa_migrate.c
+++ b/kernel/irq/numa_migrate.c
@@ -37,7 +37,7 @@ static bool init_copy_one_irq_desc(int irq, struct irq_desc *old_desc,
 		 struct irq_desc *desc, int cpu)
 {
 	memcpy(desc, old_desc, sizeof(struct irq_desc));
-	if (!init_alloc_desc_masks(desc, cpu, false)) {
+	if (!alloc_desc_masks(desc, cpu, false)) {
 		printk(KERN_ERR "irq %d: can not get new irq_desc cpumask "
 				"for migration.\n", irq);
 		return false;
