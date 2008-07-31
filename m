Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbYGaJkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbYGaJkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 05:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbYGaJkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 05:40:15 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:40303 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbYGaJkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 05:40:10 -0400
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, michael@ellerman.id.au,
       jean-pierre.dion@bull.net, gilles.carry@ext.bull.net,
       tinytim@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Sebastien Dugue <sebastien.dugue@bull.net>
Subject: [PATCH] powerpc - Initialize the irq radix tree earlier
Date: Thu, 31 Jul 2008 11:40:39 +0200
Message-Id: <1217497241-10685-2-git-send-email-sebastien.dugue@bull.net>
X-Mailer: git-send-email 1.5.5.rc2.1.gc953.dirty
In-Reply-To: <1217497241-10685-1-git-send-email-sebastien.dugue@bull.net>
References: <1217497241-10685-1-git-send-email-sebastien.dugue@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  The radix tree used for fast irq reverse mapping by the XICS is initialized
late in the boot process, after the first interrupt (IPI) gets registered
and after the first IPI is received.

  This patch moves the initialization of the XICS radix tree earlier into
the boot process in smp_xics_probe() (the mm is already up but no interrupts
have been registered at that point) to avoid having to insert a mapping into
the tree in interrupt context. This will help in simplifying the locking
constraints and move to a lockless radix tree in subsequent patches.

  As a nice side effect, there is no need any longer to check for
(host->revmap_data.tree.gfp_mask != 0) to know if the tree have been
initialized.


Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/kernel/irq.c            |   44 +++++++++------------------------
 arch/powerpc/platforms/pseries/smp.c |    1 +
 include/asm-powerpc/irq.h            |    5 ++++
 3 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 6ac8612..0a1445c 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -840,9 +840,6 @@ void irq_dispose_mapping(unsigned int virq)
 			host->revmap_data.linear.revmap[hwirq] = NO_IRQ;
 		break;
 	case IRQ_HOST_MAP_TREE:
-		/* Check if radix tree allocated yet */
-		if (host->revmap_data.tree.gfp_mask == 0)
-			break;
 		irq_radix_wrlock(&flags);
 		radix_tree_delete(&host->revmap_data.tree, hwirq);
 		irq_radix_wrunlock(flags);
@@ -893,28 +890,28 @@ unsigned int irq_find_mapping(struct irq_host *host,
 }
 EXPORT_SYMBOL_GPL(irq_find_mapping);
 
+void __init irq_radix_revmap_init(void)
+{
+ 	struct irq_host *h;
+
+	list_for_each_entry(h, &irq_hosts, link) {
+		if (h->revmap_type == IRQ_HOST_MAP_TREE)
+			INIT_RADIX_TREE(&h->revmap_data.tree, GFP_ATOMIC);
+	}
+}
 
 unsigned int irq_radix_revmap(struct irq_host *host,
 			      irq_hw_number_t hwirq)
 {
-	struct radix_tree_root *tree;
 	struct irq_map_entry *ptr;
 	unsigned int virq;
 	unsigned long flags;
 
 	WARN_ON(host->revmap_type != IRQ_HOST_MAP_TREE);
 
-	/* Check if the radix tree exist yet. We test the value of
-	 * the gfp_mask for that. Sneaky but saves another int in the
-	 * structure. If not, we fallback to slow mode
-	 */
-	tree = &host->revmap_data.tree;
-	if (tree->gfp_mask == 0)
-		return irq_find_mapping(host, hwirq);
-
-	/* Now try to resolve */
+	/* Try to resolve */
 	irq_radix_rdlock(&flags);
-	ptr = radix_tree_lookup(tree, hwirq);
+	ptr = radix_tree_lookup(&host->revmap_data.tree, hwirq);
 	irq_radix_rdunlock(flags);
 
 	/* Found it, return */
@@ -927,7 +924,7 @@ unsigned int irq_radix_revmap(struct irq_host *host,
 	virq = irq_find_mapping(host, hwirq);
 	if (virq != NO_IRQ) {
 		irq_radix_wrlock(&flags);
-		radix_tree_insert(tree, hwirq, &irq_map[virq]);
+		radix_tree_insert(&host->revmap_data.tree, hwirq, &irq_map[virq]);
 		irq_radix_wrunlock(flags);
 	}
 	return virq;
@@ -1035,23 +1032,6 @@ void irq_early_init(void)
 		get_irq_desc(i)->status |= IRQ_NOREQUEST;
 }
 
-/* We need to create the radix trees late */
-static int irq_late_init(void)
-{
-	struct irq_host *h;
-	unsigned long flags;
-
-	irq_radix_wrlock(&flags);
-	list_for_each_entry(h, &irq_hosts, link) {
-		if (h->revmap_type == IRQ_HOST_MAP_TREE)
-			INIT_RADIX_TREE(&h->revmap_data.tree, GFP_ATOMIC);
-	}
-	irq_radix_wrunlock(flags);
-
-	return 0;
-}
-arch_initcall(irq_late_init);
-
 #ifdef CONFIG_VIRQ_DEBUG
 static int virq_debug_show(struct seq_file *m, void *private)
 {
diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index 9d8f8c8..b143fe7 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -130,6 +130,7 @@ static void smp_xics_message_pass(int target, int msg)
 
 static int __init smp_xics_probe(void)
 {
+	irq_radix_revmap_init();
 	xics_request_IPIs();
 
 	return cpus_weight(cpu_possible_map);
diff --git a/include/asm-powerpc/irq.h b/include/asm-powerpc/irq.h
index 1ef8e30..47b8119 100644
--- a/include/asm-powerpc/irq.h
+++ b/include/asm-powerpc/irq.h
@@ -237,6 +237,11 @@ extern unsigned int irq_find_mapping(struct irq_host *host,
  */
 extern unsigned int irq_create_direct_mapping(struct irq_host *host);
 
+/*
+ * Initialize the radix tree used by some irq controllers
+ */
+extern void __init irq_radix_revmap_init(void);
+
 /**
  * irq_radix_revmap - Find a linux virq from a hw irq number.
  * @host: host owning this hardware interrupt
-- 
1.5.5.1

