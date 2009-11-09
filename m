Return-Path: <linux-kernel-owner+w=401wt.eu-S1756445AbZKIQCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbZKIQCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 11:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbZKIQCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 11:02:12 -0500
Received: from relay2.sgi.com ([192.48.179.30]:60975 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756387AbZKIQCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 11:02:11 -0500
Date: Mon, 9 Nov 2009 10:02:15 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de
Subject: Re: [tip:x86/apic] x86/apic: Limit irq affinity
Message-ID: <20091109160215.GA14718@sgi.com>
References: <20091021011233.GB32196@sgi.com> <tip-683c91f85d7a3e1092d7fa3ec5687af8cd379f02@git.kernel.org> <20091108145355.GA8432@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091108145355.GA8432@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 03:53:55PM +0100, Ingo Molnar wrote:
> 
> * tip-bot for Dimitri Sivanich <sivanich@sgi.com> wrote:
> 
> > Commit-ID:  683c91f85d7a3e1092d7fa3ec5687af8cd379f02
> > Gitweb:     http://git.kernel.org/tip/683c91f85d7a3e1092d7fa3ec5687af8cd379f02
> > Author:     Dimitri Sivanich <sivanich@sgi.com>
> > AuthorDate: Tue, 3 Nov 2009 12:40:37 -0600
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sun, 8 Nov 2009 13:30:40 +0100
> > 
> > x86/apic: Limit irq affinity
> > 
> > This patch allows for hard numa restrictions to irq affinity on
> > x86 systems.
> 
> -tip testing found a build failure:
> 
> arch/x86/kernel/apic/io_apic.c:1438: error: ‘struct irq_desc’ has no member named ‘node’
> arch/x86/kernel/apic/io_apic.c:3286: error: ‘struct irq_desc’ has no member named ‘node’
>

In the interest of doing some ifdef cleanup as well as fixing the build problem,
can I suggest that we remove the 'ifdef CONFIG_SMP' from the irq_desc?

Here's my suggested patch.


Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

 include/linux/irq.h |   70 +++++++++++++++++++-----------------------------
 kernel/irq/chip.c   |    2 -
 kernel/irq/handle.c |    4 --
 3 files changed, 29 insertions(+), 47 deletions(-)

Index: linux/include/linux/irq.h
===================================================================
--- linux.orig/include/linux/irq.h	2009-11-09 09:18:32.000000000 -0600
+++ linux/include/linux/irq.h	2009-11-09 09:19:50.000000000 -0600
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
--- linux.orig/kernel/irq/handle.c	2009-11-09 09:18:32.000000000 -0600
+++ linux/kernel/irq/handle.c	2009-11-09 09:19:50.000000000 -0600
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
--- linux.orig/kernel/irq/chip.c	2009-11-09 09:18:32.000000000 -0600
+++ linux/kernel/irq/chip.c	2009-11-09 09:19:50.000000000 -0600
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
 
 
