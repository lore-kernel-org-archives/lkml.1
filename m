Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbYLZDYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbYLZDYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 22:24:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbYLZDYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 22:24:31 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59060 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbYLZDYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 22:24:30 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH for -tip 2/4] irq: for_each_irq_desc() move to irqnr.h
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081226121703.5CA3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081226121703.5CA3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081226122258.5CA9.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri, 26 Dec 2008 12:24:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


before CONFIG_SPARSE_IRQ age, for_each_irq_desc() sit in irqnr.h and
can be called from generic code.

CONFIG_SPARSE_IRQ break this assumption. but SPARSE_IRQ version
for_each_irq_desc() also can move irqnr.h easily.

Also, this patch unify CONFIG_SPARSE_IRQ and !CONFIG_SPARSE_IRQ for_each_irq_desc().


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
---
 include/linux/irq.h   |   24 ++++--------------------
 include/linux/irqnr.h |   19 +++++++++----------
 kernel/irq/handle.c   |   13 +++++++++++--
 3 files changed, 24 insertions(+), 32 deletions(-)

Index: b/include/linux/irq.h
===================================================================
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -203,33 +203,17 @@ extern void arch_free_chip_data(struct i
 
 #ifndef CONFIG_SPARSE_IRQ
 extern struct irq_desc irq_desc[NR_IRQS];
-
-static inline struct irq_desc *irq_to_desc(unsigned int irq)
-{
-	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
-}
-static inline struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
-{
-	return irq_to_desc(irq);
-}
-
-#else
-
-extern struct irq_desc *irq_to_desc(unsigned int irq);
-extern struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu);
+#else /* CONFIG_SPARSE_IRQ */
 extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int cpu);
 
-# define for_each_irq_desc(irq, desc)		\
-	for (irq = 0, desc = irq_to_desc(irq); irq < nr_irqs; irq++, desc = irq_to_desc(irq))
-# define for_each_irq_desc_reverse(irq, desc)                          \
-	for (irq = nr_irqs - 1, desc = irq_to_desc(irq); irq >= 0; irq--, desc = irq_to_desc(irq))
-
 #define kstat_irqs_this_cpu(DESC) \
 	((DESC)->kstat_irqs[smp_processor_id()])
 #define kstat_incr_irqs_this_cpu(irqno, DESC) \
 	((DESC)->kstat_irqs[smp_processor_id()]++)
 
-#endif
+#endif /* CONFIG_SPARSE_IRQ */
+
+extern struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu);
 
 static inline struct irq_desc *
 irq_remap_to_desc(unsigned int irq, struct irq_desc *desc)
Index: b/include/linux/irqnr.h
===================================================================
--- a/include/linux/irqnr.h
+++ b/include/linux/irqnr.h
@@ -15,20 +15,19 @@
 
 # define for_each_irq_desc_reverse(irq, desc)                          \
 	for (irq = nr_irqs - 1; irq >= 0; irq--)
-#else
+#else /* CONFIG_GENERIC_HARDIRQS */
 
 extern int nr_irqs;
+extern struct irq_desc *irq_to_desc(unsigned int irq);
 
-#ifndef CONFIG_SPARSE_IRQ
+# define for_each_irq_desc(irq, desc)					\
+	for (irq = 0, desc = irq_to_desc(irq); irq < nr_irqs;		\
+	     irq++, desc = irq_to_desc(irq))
+# define for_each_irq_desc_reverse(irq, desc)				\
+	for (irq = nr_irqs - 1, desc = irq_to_desc(irq); irq >= 0;	\
+	     irq--, desc = irq_to_desc(irq))
 
-struct irq_desc;
-# define for_each_irq_desc(irq, desc)		\
-	for (irq = 0, desc = irq_desc; irq < nr_irqs; irq++, desc++)
-# define for_each_irq_desc_reverse(irq, desc)                          \
-	for (irq = nr_irqs - 1, desc = irq_desc + (nr_irqs - 1);        \
-	    irq >= 0; irq--, desc--)
-#endif
-#endif
+#endif /* CONFIG_GENERIC_HARDIRQS */
 
 #define for_each_irq_nr(irq)                   \
        for (irq = 0; irq < nr_irqs; irq++)
Index: b/kernel/irq/handle.c
===================================================================
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -203,7 +203,7 @@ out_unlock:
 	return desc;
 }
 
-#else
+#else /* !CONFIG_SPARSE_IRQ */
 
 struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS-1] = {
@@ -218,7 +218,16 @@ struct irq_desc irq_desc[NR_IRQS] __cach
 	}
 };
 
-#endif
+struct irq_desc *irq_to_desc(unsigned int irq)
+{
+	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
+}
+
+struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
+{
+	return irq_to_desc(irq);
+}
+#endif /* !CONFIG_SPARSE_IRQ */
 
 /*
  * What should we do if we get a hw irq event on an illegal vector?


