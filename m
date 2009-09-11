Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbZIKTGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbZIKTGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbZIKTGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:06:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40134 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbZIKTGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:06:21 -0400
Date: Fri, 11 Sep 2009 21:06:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] irq/core for v2.6.32
Message-ID: <20090911190612.GA13901@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-core-for-linus

 Thanks,

	Ingo

------------------>
Bartlomiej Zolnierkiewicz (1):
      irq: Remove superfluous NULL pointer check in check_irq_resend()

Jiri Slaby (1):
      irq: Clean up by removing irqfixup MODULE_PARM_DESC()

Mark Brown (1):
      genirq: Add prototype for handle_nested_irq()

Rafael J. Wysocki (1):
      genirq: Fix comment describing suspend_device_irqs()

Thomas Gleixner (1):
      genirq: Remove obsolete defines and typedefs

Yinghai Lu (3):
      irq: Make sure irq_desc for legacy irq get correct node setting
      irq: Add irq_node() primitive
      pci/intr_remapping: Allocate irq_iommu on node


 Documentation/feature-removal-schedule.txt |    9 ---------
 drivers/pci/intr_remapping.c               |   14 +++-----------
 include/linux/irq.h                        |    8 +-------
 include/linux/irqnr.h                      |    6 ++++++
 kernel/irq/handle.c                        |    5 ++++-
 kernel/irq/pm.c                            |    8 ++++----
 kernel/irq/resend.c                        |    3 +--
 kernel/irq/spurious.c                      |    1 -
 8 files changed, 19 insertions(+), 35 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 09e031c..82e8d1a 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -394,15 +394,6 @@ Who:	Thomas Gleixner <tglx@linutronix.de>
 
 -----------------------------
 
-What:	obsolete generic irq defines and typedefs
-When:	2.6.30
-Why:	The defines and typedefs (hw_interrupt_type, no_irq_type, irq_desc_t)
-	have been kept around for migration reasons. After more than two years
-	it's time to remove them finally
-Who:	Thomas Gleixner <tglx@linutronix.de>
-
----------------------------
-
 What:	fakephp and associated sysfs files in /sys/bus/pci/slots/
 When:	2011
 Why:	In 2.6.27, the semantics of /sys/bus/pci/slots was redefined to
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 4f5b871..4480364 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -55,15 +55,12 @@ static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
 	return desc->irq_2_iommu;
 }
 
-static struct irq_2_iommu *irq_2_iommu_alloc_node(unsigned int irq, int node)
+static struct irq_2_iommu *irq_2_iommu_alloc(unsigned int irq)
 {
 	struct irq_desc *desc;
 	struct irq_2_iommu *irq_iommu;
 
-	/*
-	 * alloc irq desc if not allocated already.
-	 */
-	desc = irq_to_desc_alloc_node(irq, node);
+	desc = irq_to_desc(irq);
 	if (!desc) {
 		printk(KERN_INFO "can not get irq_desc for %d\n", irq);
 		return NULL;
@@ -72,16 +69,11 @@ static struct irq_2_iommu *irq_2_iommu_alloc_node(unsigned int irq, int node)
 	irq_iommu = desc->irq_2_iommu;
 
 	if (!irq_iommu)
-		desc->irq_2_iommu = get_one_free_irq_2_iommu(node);
+		desc->irq_2_iommu = get_one_free_irq_2_iommu(irq_node(irq));
 
 	return desc->irq_2_iommu;
 }
 
-static struct irq_2_iommu *irq_2_iommu_alloc(unsigned int irq)
-{
-	return irq_2_iommu_alloc_node(irq, cpu_to_node(boot_cpu_id));
-}
-
 #else /* !CONFIG_SPARSE_IRQ */
 
 static struct irq_2_iommu irq_2_iommuX[NR_IRQS];
diff --git a/include/linux/irq.h b/include/linux/irq.h
index cb2e77a..9e9eb76 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -220,13 +220,6 @@ static inline struct irq_desc *move_irq_desc(struct irq_desc *desc, int node)
 extern struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node);
 
 /*
- * Migration helpers for obsolete names, they will go away:
- */
-#define hw_interrupt_type	irq_chip
-#define no_irq_type		no_irq_chip
-typedef struct irq_desc		irq_desc_t;
-
-/*
  * Pick up the arch-dependent methods:
  */
 #include <asm/hw_irq.h>
@@ -289,6 +282,7 @@ extern void handle_edge_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_simple_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_percpu_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_nested_irq(unsigned int irq);
 
 /*
  * Monolithic do_IRQ implementation.
diff --git a/include/linux/irqnr.h b/include/linux/irqnr.h
index ec87b21..7bf89bc 100644
--- a/include/linux/irqnr.h
+++ b/include/linux/irqnr.h
@@ -41,6 +41,12 @@ extern struct irq_desc *irq_to_desc(unsigned int irq);
 			;						\
 		else
 
+#ifdef CONFIG_SMP
+#define irq_node(irq)	(irq_to_desc(irq)->node)
+#else
+#define irq_node(irq)	0
+#endif
+
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
 #define for_each_irq_nr(irq)                   \
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 065205b..a81cf80 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -161,7 +161,7 @@ int __init early_irq_init(void)
 
 	desc = irq_desc_legacy;
 	legacy_count = ARRAY_SIZE(irq_desc_legacy);
- 	node = first_online_node;
+	node = first_online_node;
 
 	/* allocate irq_desc_ptrs array based on nr_irqs */
 	irq_desc_ptrs = kcalloc(nr_irqs, sizeof(void *), GFP_NOWAIT);
@@ -172,6 +172,9 @@ int __init early_irq_init(void)
 
 	for (i = 0; i < legacy_count; i++) {
 		desc[i].irq = i;
+#ifdef CONFIG_SMP
+		desc[i].node = node;
+#endif
 		desc[i].kstat_irqs = kstat_irqs_legacy + i * nr_cpu_ids;
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
 		alloc_desc_masks(&desc[i], node, true);
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index 638d8be..a0bb09e 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -15,10 +15,10 @@
 /**
  * suspend_device_irqs - disable all currently enabled interrupt lines
  *
- * During system-wide suspend or hibernation device interrupts need to be
- * disabled at the chip level and this function is provided for this purpose.
- * It disables all interrupt lines that are enabled at the moment and sets the
- * IRQ_SUSPENDED flag for them.
+ * During system-wide suspend or hibernation device drivers need to be prevented
+ * from receiving interrupts and this function is provided for this purpose.
+ * It marks all interrupt lines in use, except for the timer ones, as disabled
+ * and sets the IRQ_SUSPENDED flag for each of them.
  */
 void suspend_device_irqs(void)
 {
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index 89c7117..090c376 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -70,8 +70,7 @@ void check_irq_resend(struct irq_desc *desc, unsigned int irq)
 	if ((status & (IRQ_LEVEL | IRQ_PENDING | IRQ_REPLAY)) == IRQ_PENDING) {
 		desc->status = (status & ~IRQ_PENDING) | IRQ_REPLAY;
 
-		if (!desc->chip || !desc->chip->retrigger ||
-					!desc->chip->retrigger(irq)) {
+		if (!desc->chip->retrigger || !desc->chip->retrigger(irq)) {
 #ifdef CONFIG_HARDIRQS_SW_RESEND
 			/* Set it pending and activate the softirq: */
 			set_bit(irq, irqs_resend);
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 4d56829..114e704 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -297,7 +297,6 @@ static int __init irqfixup_setup(char *str)
 
 __setup("irqfixup", irqfixup_setup);
 module_param(irqfixup, int, 0644);
-MODULE_PARM_DESC("irqfixup", "0: No fixup, 1: irqfixup mode, 2: irqpoll mode");
 
 static int __init irqpoll_setup(char *str)
 {
