Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbZFKFUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbZFKFUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 01:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761256AbZFKFUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 01:20:06 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39251 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761432AbZFKFUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 01:20:06 -0400
Date: Thu, 11 Jun 2009 08:20:08 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, hannes@cmpxchg.org,
       torvalds@linux-foundation.org, yinghai@kernel.org
Subject: [PATCH 2/4] irq/cpumask: make memoryless node zero happy
Message-ID: <Pine.LNX.4.64.0906110819550.2258@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

Don't hardcode to node zero for early boot IRQ setup memory allocations.

[ penberg@cs.helsinki.fi: minor cleanups ]
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/kernel/apic/io_apic.c |    6 ++++--
 kernel/irq/handle.c            |    9 +++++----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 139201a..94605e7 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -177,16 +177,18 @@ int __init arch_early_irq_init(void)
 	struct irq_cfg *cfg;
 	struct irq_desc *desc;
 	int count;
+	int node;
 	int i;
 
 	cfg = irq_cfgx;
 	count = ARRAY_SIZE(irq_cfgx);
+	node= cpu_to_node(boot_cpu_id);
 
 	for (i = 0; i < count; i++) {
 		desc = irq_to_desc(i);
 		desc->chip_data = &cfg[i];
-		alloc_cpumask_var(&cfg[i].domain, GFP_NOWAIT);
-		alloc_cpumask_var(&cfg[i].old_domain, GFP_NOWAIT);
+		alloc_cpumask_var_node(&cfg[i].domain, GFP_NOWAIT, node);
+		alloc_cpumask_var_node(&cfg[i].old_domain, GFP_NOWAIT, node);
 		if (i < NR_IRQS_LEGACY)
 			cpumask_setall(cfg[i].domain);
 	}
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index a600184..e161999 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -150,6 +150,7 @@ int __init early_irq_init(void)
 {
 	struct irq_desc *desc;
 	int legacy_count;
+	int node;
 	int i;
 
 	init_irq_default_affinity();
@@ -160,20 +161,20 @@ int __init early_irq_init(void)
 
 	desc = irq_desc_legacy;
 	legacy_count = ARRAY_SIZE(irq_desc_legacy);
+ 	node = first_online_node;
 
 	/* allocate irq_desc_ptrs array based on nr_irqs */
 	irq_desc_ptrs = alloc_bootmem(nr_irqs * sizeof(void *));
 
 	/* allocate based on nr_cpu_ids */
-	/* FIXME: invert kstat_irgs, and it'd be a per_cpu_alloc'd thing */
-	kstat_irqs_legacy = alloc_bootmem(NR_IRQS_LEGACY * nr_cpu_ids *
-					  sizeof(int));
+	kstat_irqs_legacy = kzalloc_node(NR_IRQS_LEGACY * nr_cpu_ids *
+					  sizeof(int), GFP_NOWAIT, node);
 
 	for (i = 0; i < legacy_count; i++) {
 		desc[i].irq = i;
 		desc[i].kstat_irqs = kstat_irqs_legacy + i * nr_cpu_ids;
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
-		alloc_desc_masks(&desc[i], 0, true);
+		alloc_desc_masks(&desc[i], node, true);
 		init_desc_masks(&desc[i]);
 		irq_desc_ptrs[i] = desc + i;
 	}
-- 
1.6.0.4

