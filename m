Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYGaJkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYGaJkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 05:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYGaJkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 05:40:13 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:40293 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbYGaJkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 05:40:10 -0400
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, michael@ellerman.id.au,
       jean-pierre.dion@bull.net, gilles.carry@ext.bull.net,
       tinytim@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Sebastien Dugue <sebastien.dugue@bull.net>
Subject: [PATCH] powerpc - Separate the irq radix tree insertion and lookup
Date: Thu, 31 Jul 2008 11:40:40 +0200
Message-Id: <1217497241-10685-3-git-send-email-sebastien.dugue@bull.net>
X-Mailer: git-send-email 1.5.5.rc2.1.gc953.dirty
In-Reply-To: <1217497241-10685-1-git-send-email-sebastien.dugue@bull.net>
References: <1217497241-10685-1-git-send-email-sebastien.dugue@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  irq_radix_revmap() currently serves 2 purposes, irq mapping lookup
and insertion which happen in interrupt and process context respectively.

  Separate the function into its 2 components, one for lookup only and one
for insertion only.


Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/kernel/irq.c             |   25 ++++++++++++++-----------
 arch/powerpc/platforms/pseries/xics.c |   11 ++++-------
 include/asm-powerpc/irq.h             |   18 +++++++++++++++---
 3 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 0a1445c..083b181 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -900,34 +900,37 @@ void __init irq_radix_revmap_init(void)
 	}
 }
 
-unsigned int irq_radix_revmap(struct irq_host *host,
-			      irq_hw_number_t hwirq)
+unsigned int irq_radix_revmap_lookup(struct irq_host *host,
+				     irq_hw_number_t hwirq)
 {
 	struct irq_map_entry *ptr;
-	unsigned int virq;
+	unsigned int virq = NO_IRQ;
 	unsigned long flags;
 
 	WARN_ON(host->revmap_type != IRQ_HOST_MAP_TREE);
 
-	/* Try to resolve */
 	irq_radix_rdlock(&flags);
 	ptr = radix_tree_lookup(&host->revmap_data.tree, hwirq);
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
 		radix_tree_insert(&host->revmap_data.tree, hwirq, &irq_map[virq]);
 		irq_radix_wrunlock(flags);
 	}
-	return virq;
 }
 
 unsigned int irq_linear_revmap(struct irq_host *host,
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
diff --git a/include/asm-powerpc/irq.h b/include/asm-powerpc/irq.h
index 47b8119..5c88acf 100644
--- a/include/asm-powerpc/irq.h
+++ b/include/asm-powerpc/irq.h
@@ -243,15 +243,27 @@ extern unsigned int irq_create_direct_mapping(struct irq_host *host);
 extern void __init irq_radix_revmap_init(void);
 
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
-- 
1.5.5.1

