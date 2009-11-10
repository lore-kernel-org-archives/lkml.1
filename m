Return-Path: <linux-kernel-owner+w=401wt.eu-S1757714AbZKJS5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714AbZKJS5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 13:57:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757697AbZKJS5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 13:57:13 -0500
Received: from relay1.sgi.com ([192.48.179.29]:40706 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757687AbZKJS5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 13:57:13 -0500
Date: Tue, 10 Nov 2009 12:57:16 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de
Subject: [PATCH] Remove SMP ifdef from irq_desc
Message-ID: <20091110185716.GA4665@sgi.com>
References: <20091021011233.GB32196@sgi.com> <tip-683c91f85d7a3e1092d7fa3ec5687af8cd379f02@git.kernel.org> <20091108145355.GA8432@elte.hu> <20091109160215.GA14718@sgi.com> <20091110044025.GA7897@elte.hu> <20091110163118.GA13707@sgi.com> <20091110171910.GA25581@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110171910.GA25581@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the CONFIG_SMP ifdef from the irq_desc structure and consolidate
initializers for the smp/non-smp cases.

For the x86_32 case, this adds 4 bytes of text and 128 bytes of data.

For the x86_64 case, this adds 15 bytes of text and 240 bytes of data.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

 include/linux/irq.h |   70 +++++++++++++++++++-----------------------------
 kernel/irq/chip.c   |    2 -
 kernel/irq/handle.c |    4 --
 3 files changed, 29 insertions(+), 47 deletions(-)

Index: linux/include/linux/irq.h
===================================================================
--- linux.orig/include/linux/irq.h	2009-11-10 11:54:52.000000000 -0600
+++ linux/include/linux/irq.h	2009-11-10 11:54:55.000000000 -0600
@@ -193,13 +193,11 @@ struct irq_desc {
 	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
 	unsigned int		irqs_unhandled;
 	spinlock_t		lock;
-#ifdef CONFIG_SMP
 	cpumask_var_t		affinity;
 	unsigned int		node;
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	cpumask_var_t		pending_mask;
 #endif
-#endif
 	atomic_t		threads_active;
 	wait_queue_head_t       wait_for_threads;
 #ifdef CONFIG_PROC_FS
@@ -423,6 +421,35 @@ extern int set_irq_msi(unsigned int irq,
 
 #endif /* !CONFIG_S390 */
 
+static inline void init_desc_masks(struct irq_desc *desc)
+{
+	cpumask_setall(desc->affinity);
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	cpumask_clear(desc->pending_mask);
+#endif
+}
+
+/**
+ * init_copy_desc_masks - copy cpumasks for irq_desc
+ * @old_desc:	pointer to old irq_desc struct
+ * @new_desc:	pointer to new irq_desc struct
+ *
+ * Insures affinity and pending_masks are copied to new irq_desc.
+ * If !CONFIG_CPUMASKS_OFFSTACK the cpumasks are embedded in the
+ * irq_desc struct so the copy is redundant.
+ */
+static inline void init_copy_desc_masks(struct irq_desc *old_desc,
+					struct irq_desc *new_desc)
+{
+#ifdef CONFIG_CPUMASK_OFFSTACK
+	cpumask_copy(new_desc->affinity, old_desc->affinity);
+
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	cpumask_copy(new_desc->pending_mask, old_desc->pending_mask);
+#endif
+#endif
+}
+
 #ifdef CONFIG_SMP
 /**
  * alloc_desc_masks - allocate cpumasks for irq_desc
@@ -455,36 +482,6 @@ static inline bool alloc_desc_masks(stru
 	return true;
 }
 
-static inline void init_desc_masks(struct irq_desc *desc)
-{
-	cpumask_setall(desc->affinity);
-#ifdef CONFIG_GENERIC_PENDING_IRQ
-	cpumask_clear(desc->pending_mask);
-#endif
-}
-
-/**
- * init_copy_desc_masks - copy cpumasks for irq_desc
- * @old_desc:	pointer to old irq_desc struct
- * @new_desc:	pointer to new irq_desc struct
- *
- * Insures affinity and pending_masks are copied to new irq_desc.
- * If !CONFIG_CPUMASKS_OFFSTACK the cpumasks are embedded in the
- * irq_desc struct so the copy is redundant.
- */
-
-static inline void init_copy_desc_masks(struct irq_desc *old_desc,
-					struct irq_desc *new_desc)
-{
-#ifdef CONFIG_CPUMASK_OFFSTACK
-	cpumask_copy(new_desc->affinity, old_desc->affinity);
-
-#ifdef CONFIG_GENERIC_PENDING_IRQ
-	cpumask_copy(new_desc->pending_mask, old_desc->pending_mask);
-#endif
-#endif
-}
-
 static inline void free_desc_masks(struct irq_desc *old_desc,
 				   struct irq_desc *new_desc)
 {
@@ -503,15 +500,6 @@ static inline bool alloc_desc_masks(stru
 	return true;
 }
 
-static inline void init_desc_masks(struct irq_desc *desc)
-{
-}
-
-static inline void init_copy_desc_masks(struct irq_desc *old_desc,
-					struct irq_desc *new_desc)
-{
-}
-
 static inline void free_desc_masks(struct irq_desc *old_desc,
 				   struct irq_desc *new_desc)
 {
Index: linux/kernel/irq/handle.c
===================================================================
--- linux.orig/kernel/irq/handle.c	2009-11-10 11:54:52.000000000 -0600
+++ linux/kernel/irq/handle.c	2009-11-10 11:54:55.000000000 -0600
@@ -110,9 +110,7 @@ static void init_one_irq_desc(int irq, s
 
 	spin_lock_init(&desc->lock);
 	desc->irq = irq;
-#ifdef CONFIG_SMP
 	desc->node = node;
-#endif
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 	init_kstat_irqs(desc, node, nr_cpu_ids);
 	if (!desc->kstat_irqs) {
@@ -173,9 +171,7 @@ int __init early_irq_init(void)
 
 	for (i = 0; i < legacy_count; i++) {
 		desc[i].irq = i;
-#ifdef CONFIG_SMP
 		desc[i].node = node;
-#endif
 		desc[i].kstat_irqs = kstat_irqs_legacy + i * nr_cpu_ids;
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
 		alloc_desc_masks(&desc[i], node, true);
Index: linux/kernel/irq/chip.c
===================================================================
--- linux.orig/kernel/irq/chip.c	2009-11-10 11:54:52.000000000 -0600
+++ linux/kernel/irq/chip.c	2009-11-10 11:54:55.000000000 -0600
@@ -45,12 +45,10 @@ void dynamic_irq_init(unsigned int irq)
 	desc->action = NULL;
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
-#ifdef CONFIG_SMP
 	cpumask_setall(desc->affinity);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	cpumask_clear(desc->pending_mask);
 #endif
-#endif
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
 
