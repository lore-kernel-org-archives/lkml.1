Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbZGUMhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbZGUMhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 08:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbZGUMhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 08:37:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:52971 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911AbZGUMhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 08:37:21 -0400
Date: Tue, 21 Jul 2009 12:36:56 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:irq/urgent] genirq: Delegate irq affinity setting to the irq thread
Message-ID: <tip-591d2fb02ea80472d846c0b8507007806bdd69cc@git.kernel.org>
Git-Commit-ID: 591d2fb02ea80472d846c0b8507007806bdd69cc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 12:36:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  591d2fb02ea80472d846c0b8507007806bdd69cc
Gitweb:     http://git.kernel.org/tip/591d2fb02ea80472d846c0b8507007806bdd69cc
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 21 Jul 2009 11:09:39 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 21 Jul 2009 14:35:07 +0200

genirq: Delegate irq affinity setting to the irq thread

irq_set_thread_affinity() calls set_cpus_allowed_ptr() which might
sleep, but irq_set_thread_affinity() is called with desc->lock held
and can be called from hard interrupt context as well. The code has
another bug as it does not hold a ref on the task struct as required
by set_cpus_allowed_ptr().

Just set the IRQTF_AFFINITY bit in action->thread_flags. The next time
the thread runs it migrates itself. Solves all of the above problems
nicely.

Add kerneldoc to irq_set_thread_affinity() while at it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>



---
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
