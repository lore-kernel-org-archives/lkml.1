Return-Path: <linux-kernel-owner+w=401wt.eu-S1756416AbYGXKwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbYGXKwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbYGXKvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:51:42 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:60265 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029AbYGXKvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:51:40 -0400
Date: Thu, 24 Jul 2008 12:50:44 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: Linux-rt <linux-rt-users@vger.kernel.org>
Cc: linux-ppc <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Tim Chavez <tinytim@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Gilles Carry <Gilles.Carry@ext.bull.net>
Subject: [PATCH 2/2][RT] powerpc - Make the irq reverse mapping radix tree
 lockless
Message-ID: <20080724125044.53b604cb@bull.net>
In-Reply-To: <20080724122352.3bc76bda@bull.net>
References: <20080724122352.3bc76bda@bull.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastien Dugue <sebastien.dugue@bull.net>
Date: Tue, 22 Jul 2008 11:56:41 +0200
Subject: [PATCH][RT] powerpc - Make the irq reverse mapping radix tree lockless

  The radix tree used by interrupt controllers for their irq reverse mapping
(currently only the XICS found on pSeries) have a complex locking scheme
dating back to before the advent of the concurrent radix tree on preempt-rt.

  Take advantage of this and of the fact that the items of the tree are
pointers to a static array (irq_map) elements which can never go under us
to simplify the locking.

  Concurrency between readers and writers are handled by the intrinsic
properties of the concurrent radix tree. Concurrency between the tree
initialization which is done asynchronously with readers and writers access is
handled via an atomic variable (revmap_trees_allocated) set when the tree
has been initialized and checked before any reader or writer access just
like we used to check for tree.gfp_mask != 0 before.

Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>

---
 arch/powerpc/kernel/irq.c |  102 ++++++++++++----------------------------------
 1 file changed, 27 insertions(+), 75 deletions(-)

Index: linux-2.6.25.8-rt7/arch/powerpc/kernel/irq.c
===================================================================
--- linux-2.6.25.8-rt7.orig/arch/powerpc/kernel/irq.c
+++ linux-2.6.25.8-rt7/arch/powerpc/kernel/irq.c
@@ -403,8 +403,7 @@ void do_softirq(void)
 
 static LIST_HEAD(irq_hosts);
 static DEFINE_RAW_SPINLOCK(irq_big_lock);
-static DEFINE_PER_CPU(unsigned int, irq_radix_reader);
-static unsigned int irq_radix_writer;
+static atomic_t revmap_trees_allocated = ATOMIC_INIT(0);
 struct irq_map_entry irq_map[NR_IRQS];
 static unsigned int irq_virq_count = NR_IRQS;
 static struct irq_host *irq_default_host;
@@ -547,57 +546,6 @@ void irq_set_virq_count(unsigned int cou
 		irq_virq_count = count;
 }
 
-/* radix tree not lockless safe ! we use a brlock-type mecanism
- * for now, until we can use a lockless radix tree
- */
-static void irq_radix_wrlock(unsigned long *flags)
-{
-	unsigned int cpu, ok;
-
-	spin_lock_irqsave(&irq_big_lock, *flags);
-	irq_radix_writer = 1;
-	smp_mb();
-	do {
-		barrier();
-		ok = 1;
-		for_each_possible_cpu(cpu) {
-			if (per_cpu(irq_radix_reader, cpu)) {
-				ok = 0;
-				break;
-			}
-		}
-		if (!ok)
-			cpu_relax();
-	} while(!ok);
-}
-
-static void irq_radix_wrunlock(unsigned long flags)
-{
-	smp_wmb();
-	irq_radix_writer = 0;
-	spin_unlock_irqrestore(&irq_big_lock, flags);
-}
-
-static void irq_radix_rdlock(unsigned long *flags)
-{
-	local_irq_save(*flags);
-	__get_cpu_var(irq_radix_reader) = 1;
-	smp_mb();
-	if (likely(irq_radix_writer == 0))
-		return;
-	__get_cpu_var(irq_radix_reader) = 0;
-	smp_wmb();
-	spin_lock(&irq_big_lock);
-	__get_cpu_var(irq_radix_reader) = 1;
-	spin_unlock(&irq_big_lock);
-}
-
-static void irq_radix_rdunlock(unsigned long flags)
-{
-	__get_cpu_var(irq_radix_reader) = 0;
-	local_irq_restore(flags);
-}
-
 static int irq_setup_virq(struct irq_host *host, unsigned int virq,
 			    irq_hw_number_t hwirq)
 {
@@ -752,7 +700,6 @@ void irq_dispose_mapping(unsigned int vi
 {
 	struct irq_host *host;
 	irq_hw_number_t hwirq;
-	unsigned long flags;
 
 	if (virq == NO_IRQ)
 		return;
@@ -784,15 +731,20 @@ void irq_dispose_mapping(unsigned int vi
 		if (hwirq < host->revmap_data.linear.size)
 			host->revmap_data.linear.revmap[hwirq] = NO_IRQ;
 		break;
-	case IRQ_HOST_MAP_TREE:
+	case IRQ_HOST_MAP_TREE: {
+		DEFINE_RADIX_TREE_CONTEXT(ctx, &host->revmap_data.tree);
+
 		/* Check if radix tree allocated yet */
-		if (host->revmap_data.tree.gfp_mask == 0)
+		if (atomic_read(&revmap_trees_allocated) == 0)
 			break;
-		irq_radix_wrlock(&flags);
-		radix_tree_delete(&host->revmap_data.tree, hwirq);
-		irq_radix_wrunlock(flags);
+
+		radix_tree_lock(&ctx);
+		radix_tree_delete(ctx.tree, hwirq);
+		radix_tree_unlock(&ctx);
+
 		break;
 	}
+	}
 
 	/* Destroy map */
 	smp_mb();
@@ -845,22 +797,20 @@ unsigned int irq_radix_revmap(struct irq
 	struct radix_tree_root *tree;
 	struct irq_map_entry *ptr;
 	unsigned int virq;
-	unsigned long flags;
 
 	WARN_ON(host->revmap_type != IRQ_HOST_MAP_TREE);
 
-	/* Check if the radix tree exist yet. We test the value of
-	 * the gfp_mask for that. Sneaky but saves another int in the
-	 * structure. If not, we fallback to slow mode
-	 */
-	tree = &host->revmap_data.tree;
-	if (tree->gfp_mask == 0)
+	/* Check if the radix tree exist yet. */
+	if (atomic_read(&revmap_trees_allocated) == 0)
 		return irq_find_mapping(host, hwirq);
 
-	/* Now try to resolve */
-	irq_radix_rdlock(&flags);
+	/*
+	 * Now try to resolve
+	 * No rcu_read_lock(ing) needed, the ptr returned can't go under us
+	 * as it's referencing an entry in the static irq_map table.
+	 */
+	tree = &host->revmap_data.tree;
 	ptr = radix_tree_lookup(tree, hwirq);
-	irq_radix_rdunlock(flags);
 
 	/* Found it, return */
 	if (ptr) {
@@ -871,9 +821,10 @@ unsigned int irq_radix_revmap(struct irq
 	/* If not there, try to insert it */
 	virq = irq_find_mapping(host, hwirq);
 	if (virq != NO_IRQ) {
-		irq_radix_wrlock(&flags);
-		radix_tree_insert(tree, hwirq, &irq_map[virq]);
-		irq_radix_wrunlock(flags);
+		DEFINE_RADIX_TREE_CONTEXT(ctx, tree);
+		radix_tree_lock(&ctx);
+		radix_tree_insert(ctx.tree, hwirq, &irq_map[virq]);
+		radix_tree_unlock(&ctx);
 	}
 	return virq;
 }
@@ -984,14 +935,15 @@ void irq_early_init(void)
 static int irq_late_init(void)
 {
 	struct irq_host *h;
-	unsigned long flags;
 
-	irq_radix_wrlock(&flags);
 	list_for_each_entry(h, &irq_hosts, link) {
 		if (h->revmap_type == IRQ_HOST_MAP_TREE)
 			INIT_RADIX_TREE(&h->revmap_data.tree, GFP_ATOMIC);
 	}
-	irq_radix_wrunlock(flags);
+
+	/* Make sure the radix trees inits are visible before setting the flag */
+	smp_mb();
+	atomic_set(&revmap_trees_allocated, 1);
 
 	return 0;
 }
