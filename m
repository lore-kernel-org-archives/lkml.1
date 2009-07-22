Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZGVO5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZGVO5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 10:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbZGVO5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 10:57:05 -0400
Received: from www.tglx.de ([62.245.132.106]:58308 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbZGVO5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 10:57:02 -0400
Date: Wed, 22 Jul 2009 16:56:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] genirq fixes for 2.6.31
Message-ID: <alpine.LFD.2.00.0907221655130.2813@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

The affinity problem went unnoticed in reviews and testing and just
exploded nicely in the preempt-rt tree where we force thread all
interrupts.

Thanks,

	tglx

------------------>
Thomas Gleixner (1):
      genirq: Delegate irq affinity setting to the irq thread


 include/linux/interrupt.h |    2 +
 kernel/irq/internals.h    |    3 +-
 kernel/irq/manage.c       |   50 +++++++++++++++++++++++++++++++++++++++-----
 kernel/irq/migration.c    |    2 +-
 4 files changed, 48 insertions(+), 9 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 2721f07..88b056a 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -64,11 +64,13 @@
  * IRQTF_RUNTHREAD - signals that the interrupt handler thread should run
  * IRQTF_DIED      - handler thread died
  * IRQTF_WARNED    - warning "IRQ_WAKE_THREAD w/o thread_fn" has been printed
+ * IRQTF_AFFINITY  - irq thread is requested to adjust affinity
  */
 enum {
 	IRQTF_RUNTHREAD,
 	IRQTF_DIED,
 	IRQTF_WARNED,
+	IRQTF_AFFINITY,
 };
 
 typedef irqreturn_t (*irq_handler_t)(int, void *);
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 7346825..e70ed55 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -42,8 +42,7 @@ static inline void unregister_handler_proc(unsigned int irq,
 
 extern int irq_select_affinity_usr(unsigned int irq);
 
-extern void
-irq_set_thread_affinity(struct irq_desc *desc, const struct cpumask *cpumask);
+extern void irq_set_thread_affinity(struct irq_desc *desc);
 
 /*
  * Debugging printout:
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 50da676..f0de36f 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -80,14 +80,22 @@ int irq_can_set_affinity(unsigned int irq)
 	return 1;
 }
 
-void
-irq_set_thread_affinity(struct irq_desc *desc, const struct cpumask *cpumask)
+/**
+ *	irq_set_thread_affinity - Notify irq threads to adjust affinity
+ *	@desc:		irq descriptor which has affitnity changed
+ *
+ *	We just set IRQTF_AFFINITY and delegate the affinity setting
+ *	to the interrupt thread itself. We can not call
+ *	set_cpus_allowed_ptr() here as we hold desc->lock and this
+ *	code can be called from hard interrupt context.
+ */
+void irq_set_thread_affinity(struct irq_desc *desc)
 {
 	struct irqaction *action = desc->action;
 
 	while (action) {
 		if (action->thread)
-			set_cpus_allowed_ptr(action->thread, cpumask);
+			set_bit(IRQTF_AFFINITY, &action->thread_flags);
 		action = action->next;
 	}
 }
@@ -112,7 +120,7 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 	if (desc->status & IRQ_MOVE_PCNTXT) {
 		if (!desc->chip->set_affinity(irq, cpumask)) {
 			cpumask_copy(desc->affinity, cpumask);
-			irq_set_thread_affinity(desc, cpumask);
+			irq_set_thread_affinity(desc);
 		}
 	}
 	else {
@@ -122,7 +130,7 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 #else
 	if (!desc->chip->set_affinity(irq, cpumask)) {
 		cpumask_copy(desc->affinity, cpumask);
-		irq_set_thread_affinity(desc, cpumask);
+		irq_set_thread_affinity(desc);
 	}
 #endif
 	desc->status |= IRQ_AFFINITY_SET;
@@ -176,7 +184,7 @@ int irq_select_affinity_usr(unsigned int irq)
 	spin_lock_irqsave(&desc->lock, flags);
 	ret = setup_affinity(irq, desc);
 	if (!ret)
-		irq_set_thread_affinity(desc, desc->affinity);
+		irq_set_thread_affinity(desc);
 	spin_unlock_irqrestore(&desc->lock, flags);
 
 	return ret;
@@ -444,6 +452,34 @@ static int irq_wait_for_interrupt(struct irqaction *action)
 }
 
 /*
+ * Check whether we need to change the affinity of the interrupt thread.
+ */
+static void
+irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
+{
+	cpumask_var_t mask;
+
+	if (!test_and_clear_bit(IRQTF_AFFINITY, &action->thread_flags))
+		return;
+
+	/*
+	 * In case we are out of memory we set IRQTF_AFFINITY again and
+	 * try again next time
+	 */
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL)) {
+		set_bit(IRQTF_AFFINITY, &action->thread_flags);
+		return;
+	}
+
+	spin_lock_irq(&desc->lock);
+	cpumask_copy(mask, desc->affinity);
+	spin_unlock_irq(&desc->lock);
+
+	set_cpus_allowed_ptr(current, mask);
+	free_cpumask_var(mask);
+}
+
+/*
  * Interrupt handler thread
  */
 static int irq_thread(void *data)
@@ -458,6 +494,8 @@ static int irq_thread(void *data)
 
 	while (!irq_wait_for_interrupt(action)) {
 
+		irq_thread_check_affinity(desc, action);
+
 		atomic_inc(&desc->threads_active);
 
 		spin_lock_irq(&desc->lock);
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index cfe767c..fcb6c96 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -45,7 +45,7 @@ void move_masked_irq(int irq)
 		   < nr_cpu_ids))
 		if (!desc->chip->set_affinity(irq, desc->pending_mask)) {
 			cpumask_copy(desc->affinity, desc->pending_mask);
-			irq_set_thread_affinity(desc, desc->pending_mask);
+			irq_set_thread_affinity(desc);
 		}
 
 	cpumask_clear(desc->pending_mask);
