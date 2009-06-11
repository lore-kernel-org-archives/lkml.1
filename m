Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbZFKFUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbZFKFUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 01:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756336AbZFKFTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 01:19:54 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39251 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbZFKFTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 01:19:54 -0400
Date: Thu, 11 Jun 2009 08:19:54 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, hannes@cmpxchg.org,
       torvalds@linux-foundation.org, yinghai@kernel.org
Subject: [PATCH 1/4] x86: remove some alloc_bootmem_cpumask_var calling
Message-ID: <Pine.LNX.4.64.0906110819320.2258@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

Now that we set up the slab allocator earlier, we can get rid of some
alloc_bootmem_cpumask_var() calls in boot code.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 include/linux/irq.h            |   18 +++++++-----------
 kernel/cpuset.c                |    2 +-
 kernel/profile.c               |    6 ------
 lib/cpumask.c                  |   11 ++---------
 5 files changed, 12 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1946fac..139201a 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -185,8 +185,8 @@ int __init arch_early_irq_init(void)
 	for (i = 0; i < count; i++) {
 		desc = irq_to_desc(i);
 		desc->chip_data = &cfg[i];
-		alloc_bootmem_cpumask_var(&cfg[i].domain);
-		alloc_bootmem_cpumask_var(&cfg[i].old_domain);
+		alloc_cpumask_var(&cfg[i].domain, GFP_NOWAIT);
+		alloc_cpumask_var(&cfg[i].old_domain, GFP_NOWAIT);
 		if (i < NR_IRQS_LEGACY)
 			cpumask_setall(cfg[i].domain);
 	}
diff --git a/include/linux/irq.h b/include/linux/irq.h
index eedbb8e..1e50c34 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -430,23 +430,19 @@ extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
  * Returns true if successful (or not required).
  */
 static inline bool alloc_desc_masks(struct irq_desc *desc, int node,
-								bool boot)
+							bool boot)
 {
-#ifdef CONFIG_CPUMASK_OFFSTACK
-	if (boot) {
-		alloc_bootmem_cpumask_var(&desc->affinity);
+	gfp_t gfp = GFP_ATOMIC;
 
-#ifdef CONFIG_GENERIC_PENDING_IRQ
-		alloc_bootmem_cpumask_var(&desc->pending_mask);
-#endif
-		return true;
-	}
+	if (boot)
+		gfp = GFP_NOWAIT;
 
-	if (!alloc_cpumask_var_node(&desc->affinity, GFP_ATOMIC, node))
+#ifdef CONFIG_CPUMASK_OFFSTACK
+	if (!alloc_cpumask_var_node(&desc->affinity, gfp, node))
 		return false;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
-	if (!alloc_cpumask_var_node(&desc->pending_mask, GFP_ATOMIC, node)) {
+	if (!alloc_cpumask_var_node(&desc->pending_mask, gfp, node)) {
 		free_cpumask_var(desc->affinity);
 		return false;
 	}
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 026facc..d5a7e17 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1857,7 +1857,7 @@ struct cgroup_subsys cpuset_subsys = {
 
 int __init cpuset_init_early(void)
 {
-	alloc_bootmem_cpumask_var(&top_cpuset.cpus_allowed);
+	alloc_cpumask_var(&top_cpuset.cpus_allowed, GFP_NOWAIT);
 
 	top_cpuset.mems_generation = cpuset_mems_generation++;
 	return 0;
diff --git a/kernel/profile.c b/kernel/profile.c
index 7724e04..28cf26a 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -111,12 +111,6 @@ int __ref profile_init(void)
 	/* only text is profiled */
 	prof_len = (_etext - _stext) >> prof_shift;
 	buffer_bytes = prof_len*sizeof(atomic_t);
-	if (!slab_is_available()) {
-		prof_buffer = alloc_bootmem(buffer_bytes);
-		alloc_bootmem_cpumask_var(&prof_cpu_mask);
-		cpumask_copy(prof_cpu_mask, cpu_possible_mask);
-		return 0;
-	}
 
 	if (!alloc_cpumask_var(&prof_cpu_mask, GFP_KERNEL))
 		return -ENOMEM;
diff --git a/lib/cpumask.c b/lib/cpumask.c
index eb23aaa..7bb4142 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -92,15 +92,8 @@ int cpumask_any_but(const struct cpumask *mask, unsigned int cpu)
  */
 bool alloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node)
 {
-	if (likely(slab_is_available()))
-		*mask = kmalloc_node(cpumask_size(), flags, node);
-	else {
-#ifdef CONFIG_DEBUG_PER_CPU_MAPS
-		printk(KERN_ERR
-			"=> alloc_cpumask_var: kmalloc not available!\n");
-#endif
-		*mask = NULL;
-	}
+	*mask = kmalloc_node(cpumask_size(), flags, node);
+
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 	if (!*mask) {
 		printk(KERN_ERR "=> alloc_cpumask_var: failed!\n");
-- 
1.6.0.4

