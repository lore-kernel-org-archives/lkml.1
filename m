Return-Path: <linux-kernel-owner+w=401wt.eu-S1757011AbYHDN7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbYHDN7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbYHDN6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:58:20 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:42325 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbYHDN6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:58:16 -0400
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, michael@ellerman.id.au,
       jean-pierre.dion@bull.net, gilles.carry@ext.bull.net,
       tinytim@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Sebastien Dugue <sebastien.dugue@bull.net>
Subject: [PATCH 3/3] powerpc - Make the irq reverse mapping radix tree lockless
Date: Mon,  4 Aug 2008 13:08:44 +0200
Message-Id: <1217848124-3719-4-git-send-email-sebastien.dugue@bull.net>
X-Mailer: git-send-email 1.5.5.rc2.1.gc953.dirty
In-Reply-To: <1217848124-3719-1-git-send-email-sebastien.dugue@bull.net>
References: <1217848124-3719-1-git-send-email-sebastien.dugue@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  The radix trees used by interrupt controllers for their irq reverse mapping
(currently only the XICS found on pSeries) have a complex locking scheme
dating back to before the advent of the lockless radix tree.

  Take advantage of this and of the fact that the items of the tree are
pointers to a static array (irq_map) elements which can never go under us
to simplify the locking.

  Concurrency between readers and writers is handled by the intrinsic
properties of the lockless radix tree. Concurrency between writers is handled
with a spinlock added to the irq_host structure.


Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
---
 arch/powerpc/include/asm/irq.h        |    1 +
 arch/powerpc/kernel/irq.c             |   71 ++++-----------------------------
 arch/powerpc/platforms/pseries/xics.c |    1 +
 3 files changed, 10 insertions(+), 63 deletions(-)

diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
index 0a51376..43b6062 100644
--- a/arch/powerpc/include/asm/irq.h
+++ b/arch/powerpc/include/asm/irq.h
@@ -119,6 +119,7 @@ struct irq_host {
 		} linear;
 		struct radix_tree_root tree;
 	} revmap_data;
+	spinlock_t	       tree_lock;
 	struct irq_host_ops	*ops;
 	void			*host_data;
 	irq_hw_number_t		inval_irq;
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index ba24efd..5d63255 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -439,8 +439,6 @@ void do_softirq(void)
 
 static LIST_HEAD(irq_hosts);
 static DEFINE_SPINLOCK(irq_big_lock);
-static DEFINE_PER_CPU(unsigned int, irq_radix_reader);
-static unsigned int irq_radix_writer;
 struct irq_map_entry irq_map[NR_IRQS];
 static unsigned int irq_virq_count = NR_IRQS;
 static struct irq_host *irq_default_host;
@@ -583,57 +581,6 @@ void irq_set_virq_count(unsigned int count)
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
@@ -788,7 +735,6 @@ void irq_dispose_mapping(unsigned int virq)
 {
 	struct irq_host *host;
 	irq_hw_number_t hwirq;
-	unsigned long flags;
 
 	if (virq == NO_IRQ)
 		return;
@@ -821,9 +767,9 @@ void irq_dispose_mapping(unsigned int virq)
 			host->revmap_data.linear.revmap[hwirq] = NO_IRQ;
 		break;
 	case IRQ_HOST_MAP_TREE:
-		irq_radix_wrlock(&flags);
+		spin_lock(&host->tree_lock);
 		radix_tree_delete(&host->revmap_data.tree, hwirq);
-		irq_radix_wrunlock(flags);
+		spin_unlock(&host->tree_lock);
 		break;
 	}
 
@@ -877,7 +823,6 @@ unsigned int irq_radix_revmap_lookup(struct irq_host *host,
 {
 	struct irq_map_entry *ptr;
 	unsigned int virq = NO_IRQ;
-	unsigned long flags;
 
 	WARN_ON(host->revmap_type != IRQ_HOST_MAP_TREE);
 
@@ -888,9 +833,11 @@ unsigned int irq_radix_revmap_lookup(struct irq_host *host,
 	 * IOW, for any interrupt taken before the tree is initialized, we
 	 * return NO_IRQ.
 	 */
-	irq_radix_rdlock(&flags);
+	/*
+	 * No rcu_read_lock(ing) needed, the ptr returned can't go under us
+	 * as it's referencing an entry in the static irq_map table.
+	 */
 	ptr = radix_tree_lookup(&host->revmap_data.tree, hwirq);
-	irq_radix_rdunlock(flags);
 
 	if (ptr)
 		virq = ptr - irq_map;
@@ -901,14 +848,12 @@ unsigned int irq_radix_revmap_lookup(struct irq_host *host,
 void irq_radix_revmap_insert(struct irq_host *host, unsigned int virq,
 			     irq_hw_number_t hwirq)
 {
-	unsigned long flags;
-
 	WARN_ON(host->revmap_type != IRQ_HOST_MAP_TREE);
 
 	if (virq != NO_IRQ) {
-		irq_radix_wrlock(&flags);
+		spin_lock(&host->tree_lock);
 		radix_tree_insert(&host->revmap_data.tree, hwirq, &irq_map[virq]);
-		irq_radix_wrunlock(flags);
+		spin_unlock(&host->tree_lock);
 	}
 }
 
diff --git a/arch/powerpc/platforms/pseries/xics.c b/arch/powerpc/platforms/pseries/xics.c
index 8c7f058..014439f 100644
--- a/arch/powerpc/platforms/pseries/xics.c
+++ b/arch/powerpc/platforms/pseries/xics.c
@@ -556,6 +556,7 @@ static struct irq_host_ops xics_host_ops = {
 void __init xics_radix_revmap_init(void)
 {
 	INIT_RADIX_TREE(&xics_host->revmap_data.tree, GFP_ATOMIC);
+	spin_lock_init(&xics_host->tree_lock);
 }
 
 static void __init xics_init_host(void)
-- 
1.5.5.1

