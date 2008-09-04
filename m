Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbYIDMiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbYIDMiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 08:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbYIDMhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:37:25 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:42027 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbYIDMhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:37:21 -0400
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, michael@ellerman.id.au,
       jean-pierre.dion@bull.net, gilles.carry@ext.bull.net,
       tinytim@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       dwalker@mvista.com, sebastien.dugue@bull.net
Subject: [PATCH 1/2] powerpc - Separate the irq radix tree insertion and lookup
Date: Thu,  4 Sep 2008 14:37:07 +0200
Message-Id: <1220531828-9732-2-git-send-email-sebastien.dugue@bull.net>
X-Mailer: git-send-email 1.5.5.rc2.1.gc953.dirty
In-Reply-To: <1220531828-9732-1-git-send-email-sebastien.dugue@bull.net>
References: <1220531828-9732-1-git-send-email-sebastien.dugue@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  irq_radix_revmap() currently serves 2 purposes, irq mapping lookup
and insertion which happen in interrupt and process context respectively.

  Separate the function into its 2 components, one for lookup only and one
for insertion only.

  Fix the only user of the revmap tree (XICS) to use the new functions.

  Also, move the insertion into the radix tree of those irqs that were
requested before it was initialized at said tree initialization.

  Mutual exclusion between the tree initialization and readers/writers is
handled via a state variable (revmap_trees_allocated) set to 1 when the tree
has been initialized and set to 2 after the already requested irqs have been
inserted in the tree by the init path. This state is checked before any reader
or writer access just like we used to check for tree.gfp_mask != 0 before.

Finally, now that we're not any longer inserting nodes into the radix-tree
in interrupt context, turn the GFP_ATOMIC allocations into GFP_KERNEL ones.


Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
---
 arch/powerpc/include/asm/irq.h        |   18 +++++-
 arch/powerpc/kernel/irq.c             |   97 ++++++++++++++++++++++++++-------
 arch/powerpc/platforms/pseries/xics.c |   11 ++---
 3 files changed, 95 insertions(+), 31 deletions(-)

diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
index a372f76..0a51376 100644
--- a/arch/powerpc/include/asm/irq.h
+++ b/arch/powerpc/include/asm/irq.h
@@ -236,15 +236,27 @@ extern unsigned int irq_find_mapping(struct irq_host *host,
 extern unsigned int irq_create_direct_mapping(struct irq_host *host);
 
 /**
- * irq_radix_revmap - Find a linux virq from a hw irq number.
+ * irq_radix_revmap_insert - Insert a hw irq to linux virq number mapping.
+ * @host: host owning this hardware interrupt
+ * @virq: linux irq number
+ * @hwirq: hardware irq number in that host space
+ *
+ * This is for use by irq controllers that use a radix tree reverse
+ * mapping for fast lookup.
+ */
+extern void irq_radix_revmap_insert(struct irq_host *host, unsigned int virq,
+				    irq_hw_number_t hwirq);
+
+/**
+ * irq_radix_revmap_lookup - Find a linux virq from a hw irq number.
  * @host: host owning this hardware interrupt
  * @hwirq: hardware irq number in that host space
  *
  * This is a fast path, for use by irq controller code that uses radix tree
  * revmaps
  */
-extern unsigned int irq_radix_revmap(struct irq_host *host,
-				     irq_hw_number_t hwirq);
+extern unsigned int irq_radix_revmap_lookup(struct irq_host *host,
+					    irq_hw_number_t hwirq);
 
 /**
  * irq_linear_revmap - Find a linux virq from a hw irq number.
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index d972dec..2656924 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -441,6 +441,7 @@ static LIST_HEAD(irq_hosts);
 static DEFINE_SPINLOCK(irq_big_lock);
 static DEFINE_PER_CPU(unsigned int, irq_radix_reader);
 static unsigned int irq_radix_writer;
+static unsigned int revmap_trees_allocated;
 struct irq_map_entry irq_map[NR_IRQS];
 static unsigned int irq_virq_count = NR_IRQS;
 static struct irq_host *irq_default_host;
@@ -821,8 +822,12 @@ void irq_dispose_mapping(unsigned int virq)
 			host->revmap_data.linear.revmap[hwirq] = NO_IRQ;
 		break;
 	case IRQ_HOST_MAP_TREE:
-		/* Check if radix tree allocated yet */
-		if (host->revmap_data.tree.gfp_mask == 0)
+		/*
+		 * Check if radix tree allocated yet, if not then nothing to
+		 * remove.
+		 */
+		smp_rmb();
+		if (revmap_trees_allocated < 1)
 			break;
 		irq_radix_wrlock(&flags);
 		radix_tree_delete(&host->revmap_data.tree, hwirq);
@@ -875,43 +880,62 @@ unsigned int irq_find_mapping(struct irq_host *host,
 EXPORT_SYMBOL_GPL(irq_find_mapping);
 
 
-unsigned int irq_radix_revmap(struct irq_host *host,
-			      irq_hw_number_t hwirq)
+unsigned int irq_radix_revmap_lookup(struct irq_host *host,
+				     irq_hw_number_t hwirq)
 {
-	struct radix_tree_root *tree;
 	struct irq_map_entry *ptr;
 	unsigned int virq;
 	unsigned long flags;
 
 	WARN_ON(host->revmap_type != IRQ_HOST_MAP_TREE);
 
-	/* Check if the radix tree exist yet. We test the value of
-	 * the gfp_mask for that. Sneaky but saves another int in the
-	 * structure. If not, we fallback to slow mode
+	/*
+	 * Check if the radix tree exists and has bee initialized.
+	 * If not, we fallback to slow mode
 	 */
-	tree = &host->revmap_data.tree;
-	if (tree->gfp_mask == 0)
+	if (revmap_trees_allocated < 2)
 		return irq_find_mapping(host, hwirq);
 
 	/* Now try to resolve */
 	irq_radix_rdlock(&flags);
-	ptr = radix_tree_lookup(tree, hwirq);
+	ptr = radix_tree_lookup(&host->revmap_data.tree, hwirq);
 	irq_radix_rdunlock(flags);
 
-	/* Found it, return */
-	if (ptr) {
+	/*
+	 * If found in radix tree, then fine.
+	 * Else fallback to linear lookup - this should not happen in practice
+	 * as it means that we failed to insert the node in the radix tree.
+	 */
+	if (ptr)
 		virq = ptr - irq_map;
-		return virq;
-	}
+	else
+		virq = irq_find_mapping(host, hwirq);
+
+	return virq;
+}
+
+void irq_radix_revmap_insert(struct irq_host *host, unsigned int virq,
+			     irq_hw_number_t hwirq)
+{
+	unsigned long flags;
+
+	WARN_ON(host->revmap_type != IRQ_HOST_MAP_TREE);
+
+	/*
+	 * Check if the radix tree exists yet.
+	 * If not, then the irq will be inserted into the tree when it gets
+	 * initialized.
+	 */
+	smp_rmb();
+	if (revmap_trees_allocated < 1)
+		return;
 
-	/* If not there, try to insert it */
-	virq = irq_find_mapping(host, hwirq);
 	if (virq != NO_IRQ) {
 		irq_radix_wrlock(&flags);
-		radix_tree_insert(tree, hwirq, &irq_map[virq]);
+		radix_tree_insert(&host->revmap_data.tree, hwirq,
+				  &irq_map[virq]);
 		irq_radix_wrunlock(flags);
 	}
-	return virq;
 }
 
 unsigned int irq_linear_revmap(struct irq_host *host,
@@ -1021,14 +1045,45 @@ static int irq_late_init(void)
 {
 	struct irq_host *h;
 	unsigned long flags;
+	unsigned int i;
 
-	irq_radix_wrlock(&flags);
+	/*
+	 * No mutual exclusion with respect to accessors of the tree is needed
+	 * here as the synchronization is done via the state variable
+	 * revmap_trees_allocated.
+	 */
 	list_for_each_entry(h, &irq_hosts, link) {
 		if (h->revmap_type == IRQ_HOST_MAP_TREE)
-			INIT_RADIX_TREE(&h->revmap_data.tree, GFP_ATOMIC);
+			INIT_RADIX_TREE(&h->revmap_data.tree, GFP_KERNEL);
+	}
+
+	/*
+	 * Make sure the radix trees inits are visible before setting
+	 * the flag
+	 */
+	smp_wmb();
+	revmap_trees_allocated = 1;
+
+	/*
+	 * Insert the reverse mapping for those interrupts already present
+	 * in irq_map[].
+	 */
+	irq_radix_wrlock(&flags);
+	for (i = 0; i < irq_virq_count; i++) {
+		if (irq_map[i].host &&
+		    (irq_map[i].host->revmap_type == IRQ_HOST_MAP_TREE))
+			radix_tree_insert(&irq_map[i].host->revmap_data.tree,
+					  irq_map[i].hwirq, &irq_map[i]);
 	}
 	irq_radix_wrunlock(flags);
 
+	/*
+	 * Make sure the radix trees insertions are visible before setting
+	 * the flag
+	 */
+	smp_wmb();
+	revmap_trees_allocated = 2;
+
 	return 0;
 }
 arch_initcall(irq_late_init);
diff --git a/arch/powerpc/platforms/pseries/xics.c b/arch/powerpc/platforms/pseries/xics.c
index 0fc830f..6b1a005 100644
--- a/arch/powerpc/platforms/pseries/xics.c
+++ b/arch/powerpc/platforms/pseries/xics.c
@@ -310,12 +310,6 @@ static void xics_mask_irq(unsigned int virq)
 
 static unsigned int xics_startup(unsigned int virq)
 {
-	unsigned int irq;
-
-	/* force a reverse mapping of the interrupt so it gets in the cache */
-	irq = (unsigned int)irq_map[virq].hwirq;
-	irq_radix_revmap(xics_host, irq);
-
 	/* unmask it */
 	xics_unmask_irq(virq);
 	return 0;
@@ -346,7 +340,7 @@ static inline unsigned int xics_remap_irq(unsigned int vec)
 
 	if (vec == XICS_IRQ_SPURIOUS)
 		return NO_IRQ;
-	irq = irq_radix_revmap(xics_host, vec);
+	irq = irq_radix_revmap_lookup(xics_host, vec);
 	if (likely(irq != NO_IRQ))
 		return irq;
 
@@ -530,6 +524,9 @@ static int xics_host_map(struct irq_host *h, unsigned int virq,
 {
 	pr_debug("xics: map virq %d, hwirq 0x%lx\n", virq, hw);
 
+	/* Insert the interrupt mapping into the radix tree for fast lookup */
+	irq_radix_revmap_insert(xics_host, virq, hw);
+
 	get_irq_desc(virq)->status |= IRQ_LEVEL;
 	set_irq_chip_and_handler(virq, xics_irq_chip, handle_fasteoi_irq);
 	return 0;
-- 
1.5.5.1

