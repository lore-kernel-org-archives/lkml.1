Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbYHDN6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbYHDN6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbYHDN6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:58:18 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:42335 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbYHDN6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:58:16 -0400
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, michael@ellerman.id.au,
       jean-pierre.dion@bull.net, gilles.carry@ext.bull.net,
       tinytim@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Sebastien Dugue <sebastien.dugue@bull.net>
Subject: [PATCH 2/3] powerpc - Separate the irq radix tree insertion and lookup
Date: Mon,  4 Aug 2008 13:08:43 +0200
Message-Id: <1217848124-3719-3-git-send-email-sebastien.dugue@bull.net>
X-Mailer: git-send-email 1.5.5.rc2.1.gc953.dirty
In-Reply-To: <1217848124-3719-1-git-send-email-sebastien.dugue@bull.net>
References: <1217848124-3719-1-git-send-email-sebastien.dugue@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  irq_radix_revmap() currently serves 2 purposes, irq mapping lookup
and insertion which happen in interrupt and process context respectively.

  Separate the function into its 2 components, one for lookup only and one
for insertion only.


Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
---
 arch/powerpc/include/asm/irq.h        |   18 ++++++++++--
 arch/powerpc/kernel/irq.c             |   46 +++++++++++++++-----------------
 arch/powerpc/platforms/pseries/xics.c |   11 +++-----
 3 files changed, 41 insertions(+), 34 deletions(-)

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
index 9bef9f3..ba24efd 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -821,9 +821,6 @@ void irq_dispose_mapping(unsigned int virq)
 			host->revmap_data.linear.revmap[hwirq] = NO_IRQ;
 		break;
 	case IRQ_HOST_MAP_TREE:
-		/* Check if radix tree allocated yet */
-		if (host->revmap_data.tree.gfp_mask == 0)
-			break;
 		irq_radix_wrlock(&flags);
 		radix_tree_delete(&host->revmap_data.tree, hwirq);
 		irq_radix_wrunlock(flags);
@@ -875,43 +872,44 @@ unsigned int irq_find_mapping(struct irq_host *host,
 EXPORT_SYMBOL_GPL(irq_find_mapping);
 
 
-unsigned int irq_radix_revmap(struct irq_host *host,
-			      irq_hw_number_t hwirq)
+unsigned int irq_radix_revmap_lookup(struct irq_host *host,
+				     irq_hw_number_t hwirq)
 {
-	struct radix_tree_root *tree;
 	struct irq_map_entry *ptr;
-	unsigned int virq;
+	unsigned int virq = NO_IRQ;
 	unsigned long flags;
 
 	WARN_ON(host->revmap_type != IRQ_HOST_MAP_TREE);
 
-	/* Check if the radix tree exist yet. We test the value of
-	 * the gfp_mask for that. Sneaky but saves another int in the
-	 * structure. If not, we fallback to slow mode
+	/* Note: It is safe to call radix_tree_lookup() here, even before the
+	 * tree gets initialized because the struct irq_host is zallocated
+	 * and radix_tree_lookup() returns NULL when root->rnode is found
+	 * to be NULL.
+	 * IOW, for any interrupt taken before the tree is initialized, we
+	 * return NO_IRQ.
 	 */
-	tree = &host->revmap_data.tree;
-	if (tree->gfp_mask == 0)
-		return irq_find_mapping(host, hwirq);
-
-	/* Now try to resolve */
 	irq_radix_rdlock(&flags);
-	ptr = radix_tree_lookup(tree, hwirq);
+	ptr = radix_tree_lookup(&host->revmap_data.tree, hwirq);
 	irq_radix_rdunlock(flags);
 
-	/* Found it, return */
-	if (ptr) {
+	if (ptr)
 		virq = ptr - irq_map;
-		return virq;
-	}
 
-	/* If not there, try to insert it */
-	virq = irq_find_mapping(host, hwirq);
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
 	if (virq != NO_IRQ) {
 		irq_radix_wrlock(&flags);
-		radix_tree_insert(tree, hwirq, &irq_map[virq]);
+		radix_tree_insert(&host->revmap_data.tree, hwirq, &irq_map[virq]);
 		irq_radix_wrunlock(flags);
 	}
-	return virq;
 }
 
 unsigned int irq_linear_revmap(struct irq_host *host,
diff --git a/arch/powerpc/platforms/pseries/xics.c b/arch/powerpc/platforms/pseries/xics.c
index d6e28f9..8c7f058 100644
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

