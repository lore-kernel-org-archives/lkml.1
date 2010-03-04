Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab0CDKL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 05:11:56 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57429 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab0CDKKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 05:10:19 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 04 Mar 2010 02:08:53 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 06/12] genericirq: make irq_chip related function to take desc
In-reply-to: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Eric Biederman <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1267697339-5491-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

generic code change....


Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/irq.h    |   19 ++++------
 include/linux/msi.h    |    2 +
 kernel/irq/autoprobe.c |   13 +++----
 kernel/irq/chip.c      |   90 +++++++++++++++++++++++++++++++++--------------
 kernel/irq/handle.c    |   41 ++++++++++++++++++----
 kernel/irq/internals.h |   38 ++++++++++++++++----
 kernel/irq/manage.c    |   67 +++++++++++++++++------------------
 kernel/irq/migration.c |   25 ++++++++-----
 kernel/irq/pm.c        |    4 +-
 kernel/irq/resend.c    |    8 ++--
 kernel/irq/spurious.c  |    4 +-
 11 files changed, 200 insertions(+), 111 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index b686d1e..b9ce77c 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -372,20 +372,17 @@ extern void remove_irq(unsigned int irq, struct irqaction *act);
 
 void move_native_irq(int irq);
 void move_masked_irq(int irq);
+void move_native_irq_desc(struct irq_desc *desc);
+void move_masked_irq_desc(struct irq_desc *desc);
 
 #else /* CONFIG_GENERIC_PENDING_IRQ */
 
-static inline void move_irq(int irq)
-{
-}
+static inline void move_irq(int irq) { }
 
-static inline void move_native_irq(int irq)
-{
-}
-
-static inline void move_masked_irq(int irq)
-{
-}
+static inline void move_native_irq(int irq) { }
+static inline void move_masked_irq(int irq) { }
+static inline void move_native_irq_desc(struct irq_desc *desc) { }
+static inline void move_masked_irq_desc(struct irq_desc *desc) { }
 
 #endif /* CONFIG_GENERIC_PENDING_IRQ */
 
@@ -456,7 +453,7 @@ extern void note_interrupt(unsigned int irq, struct irq_desc *desc,
 			   irqreturn_t action_ret);
 
 /* Resending of interrupts :*/
-void check_irq_resend(struct irq_desc *desc, unsigned int irq);
+void check_irq_resend(struct irq_desc *desc);
 
 /* Enable/disable irq debugging output: */
 extern int noirqdebug_setup(char *str);
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 6991ab5..fdfadc8 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -13,6 +13,8 @@ struct msi_msg {
 struct irq_desc;
 extern void mask_msi_irq(unsigned int irq);
 extern void unmask_msi_irq(unsigned int irq);
+void mask_msi_irq_desc(struct irq_desc *);
+void unmask_msi_irq_desc(struct irq_desc *);
 extern void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
 extern void write_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
 extern void read_msi_msg(unsigned int irq, struct msi_msg *msg);
diff --git a/kernel/irq/autoprobe.c b/kernel/irq/autoprobe.c
index 2295a31..34f4e4f 100644
--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
@@ -57,9 +57,8 @@ unsigned long probe_irq_on(void)
 			 * Some chips need to know about probing in
 			 * progress:
 			 */
-			if (desc->chip->set_type)
-				desc->chip->set_type(i, IRQ_TYPE_PROBE);
-			desc->chip->startup(i);
+			desc_chip_set_type(desc->chip, i, desc, IRQ_TYPE_PROBE);
+			desc_chip_startup(desc->chip, i, desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -76,7 +75,7 @@ unsigned long probe_irq_on(void)
 		raw_spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
 			desc->status |= IRQ_AUTODETECT | IRQ_WAITING;
-			if (desc->chip->startup(i))
+			if (desc_chip_startup(desc->chip, i, desc))
 				desc->status |= IRQ_PENDING;
 		}
 		raw_spin_unlock_irq(&desc->lock);
@@ -98,7 +97,7 @@ unsigned long probe_irq_on(void)
 			/* It triggered already - consider it spurious. */
 			if (!(status & IRQ_WAITING)) {
 				desc->status = status & ~IRQ_AUTODETECT;
-				desc->chip->shutdown(i);
+				desc_chip_shutdown(desc->chip, i, desc);
 			} else
 				if (i < 32)
 					mask |= 1 << i;
@@ -137,7 +136,7 @@ unsigned int probe_irq_mask(unsigned long val)
 				mask |= 1 << i;
 
 			desc->status = status & ~IRQ_AUTODETECT;
-			desc->chip->shutdown(i);
+			desc_chip_shutdown(desc->chip, i, desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -181,7 +180,7 @@ int probe_irq_off(unsigned long val)
 				nr_of_irqs++;
 			}
 			desc->status = status & ~IRQ_AUTODETECT;
-			desc->chip->shutdown(i);
+			desc_chip_shutdown(desc->chip, i, desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index d70394f..5aa93f6 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -294,6 +294,11 @@ static void default_enable(unsigned int irq)
 	desc->chip->unmask(irq);
 	desc->status &= ~IRQ_MASKED;
 }
+static void default_enable_desc(struct irq_desc *desc)
+{
+	desc->chip->desc_unmask(desc);
+	desc->status &= ~IRQ_MASKED;
+}
 
 /*
  * default disable function
@@ -301,6 +306,9 @@ static void default_enable(unsigned int irq)
 static void default_disable(unsigned int irq)
 {
 }
+static void default_disable_desc(struct irq_desc *desc)
+{
+}
 
 /*
  * default startup function
@@ -312,6 +320,11 @@ static unsigned int default_startup(unsigned int irq)
 	desc->chip->enable(irq);
 	return 0;
 }
+static unsigned int default_startup_desc(struct irq_desc *desc)
+{
+	desc->chip->desc_enable(desc);
+	return 0;
+}
 
 /*
  * default shutdown function
@@ -323,12 +336,36 @@ static void default_shutdown(unsigned int irq)
 	desc->chip->mask(irq);
 	desc->status |= IRQ_MASKED;
 }
+static void default_shutdown_desc(struct irq_desc *desc)
+{
+	desc->chip->desc_mask(desc);
+	desc->status |= IRQ_MASKED;
+}
 
 /*
  * Fixup enable/disable function pointers
  */
 void irq_chip_set_defaults(struct irq_chip *chip)
 {
+	if (!chip->desc_enable)
+		chip->desc_enable = default_enable_desc;
+	if (!chip->desc_disable)
+		chip->desc_disable = default_disable_desc;
+	if (!chip->desc_startup)
+		chip->desc_startup = default_startup_desc;
+	/*
+	 * We use chip->disable, when the user provided its own. When
+	 * we have default_disable set for chip->disable, then we need
+	 * to use default_shutdown, otherwise the irq line is not
+	 * disabled on free_irq():
+	 */
+	if (!chip->desc_shutdown)
+		chip->desc_shutdown = chip->desc_disable != default_disable_desc ?
+			chip->desc_disable : default_shutdown_desc;
+	if (!chip->desc_end)
+		chip->desc_end = dummy_irq_chip.desc_end;
+
+
 	if (!chip->enable)
 		chip->enable = default_enable;
 	if (!chip->disable)
@@ -344,20 +381,22 @@ void irq_chip_set_defaults(struct irq_chip *chip)
 	if (!chip->shutdown)
 		chip->shutdown = chip->disable != default_disable ?
 			chip->disable : default_shutdown;
-	if (!chip->name)
-		chip->name = chip->typename;
 	if (!chip->end)
 		chip->end = dummy_irq_chip.end;
+
+	if (!chip->name)
+		chip->name = chip->typename;
 }
 
-static inline void mask_ack_irq(struct irq_desc *desc, int irq)
+static inline void mask_ack_irq(struct irq_desc *desc)
 {
-	if (desc->chip->mask_ack)
-		desc->chip->mask_ack(irq);
+	if (desc->chip->desc_mask_ack)
+		desc->chip->desc_mask_ack(desc);
+	else if (desc->chip->mask_ack)
+		desc->chip->mask_ack(desc->irq);
 	else {
-		desc->chip->mask(irq);
-		if (desc->chip->ack)
-			desc->chip->ack(irq);
+		desc_chip_mask(desc->chip, desc->irq, desc);
+		desc_chip_ack(desc->chip, desc->irq, desc);
 	}
 }
 
@@ -459,7 +498,7 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 	irqreturn_t action_ret;
 
 	raw_spin_lock(&desc->lock);
-	mask_ack_irq(desc, irq);
+	mask_ack_irq(desc);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
@@ -486,8 +525,9 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 
 	if (unlikely(desc->status & IRQ_ONESHOT))
 		desc->status |= IRQ_MASKED;
-	else if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
-		desc->chip->unmask(irq);
+	else if (!(desc->status & IRQ_DISABLED))
+		desc_chip_unmask(desc->chip, irq, desc);
+
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }
@@ -524,8 +564,7 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	action = desc->action;
 	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
 		desc->status |= IRQ_PENDING;
-		if (desc->chip->mask)
-			desc->chip->mask(irq);
+		desc_chip_mask(desc->chip, irq, desc);
 		goto out;
 	}
 
@@ -540,7 +579,7 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	raw_spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
 out:
-	desc->chip->eoi(irq);
+	desc_chip_eoi(desc->chip, irq, desc);
 
 	raw_spin_unlock(&desc->lock);
 }
@@ -576,14 +615,13 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 	if (unlikely((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
 		    !desc->action)) {
 		desc->status |= (IRQ_PENDING | IRQ_MASKED);
-		mask_ack_irq(desc, irq);
+		mask_ack_irq(desc);
 		goto out_unlock;
 	}
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/* Start handling the irq */
-	if (desc->chip->ack)
-		desc->chip->ack(irq);
+	desc_chip_ack(desc->chip, irq, desc);
 
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
@@ -593,7 +631,7 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 		irqreturn_t action_ret;
 
 		if (unlikely(!action)) {
-			desc->chip->mask(irq);
+			desc_chip_mask(desc->chip, irq, desc);
 			goto out_unlock;
 		}
 
@@ -605,7 +643,7 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 		if (unlikely((desc->status &
 			       (IRQ_PENDING | IRQ_MASKED | IRQ_DISABLED)) ==
 			      (IRQ_PENDING | IRQ_MASKED))) {
-			desc->chip->unmask(irq);
+			desc_chip_unmask(desc->chip, irq, desc);
 			desc->status &= ~IRQ_MASKED;
 		}
 
@@ -637,15 +675,13 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 
 	kstat_incr_irqs_this_cpu(irq, desc);
 
-	if (desc->chip->ack)
-		desc->chip->ack(irq);
+	desc_chip_ack(desc->chip, irq, desc);
 
 	action_ret = handle_IRQ_event(irq, desc->action);
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
-	if (desc->chip->eoi)
-		desc->chip->eoi(irq);
+	desc_chip_eoi(desc->chip, irq, desc);
 }
 
 void
@@ -676,13 +712,13 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		desc->chip = &dummy_irq_chip;
 	}
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	raw_spin_lock_irqsave(&desc->lock, flags);
 
 	/* Uninstall? */
 	if (handle == handle_bad_irq) {
 		if (desc->chip != &no_irq_chip)
-			mask_ack_irq(desc, irq);
+			mask_ack_irq(desc);
 		desc->status |= IRQ_DISABLED;
 		desc->depth = 1;
 	}
@@ -693,10 +729,10 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		desc->status &= ~IRQ_DISABLED;
 		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
 		desc->depth = 0;
-		desc->chip->startup(irq);
+		desc_chip_startup(desc->chip, irq, desc);
 	}
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL_GPL(__set_irq_handler);
 
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 76d5a67..204ebbf 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -38,7 +38,7 @@ struct lock_class_key irq_desc_lock_class;
  */
 void handle_bad_irq(unsigned int irq, struct irq_desc *desc)
 {
-	print_irq_desc(irq, desc);
+	print_irq_desc(desc);
 	kstat_incr_irqs_this_cpu(irq, desc);
 	ack_bad_irq(irq);
 }
@@ -295,10 +295,14 @@ void clear_kstat_irqs(struct irq_desc *desc)
 static void ack_bad(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-
-	print_irq_desc(irq, desc);
+	print_irq_desc(desc);
 	ack_bad_irq(irq);
 }
+static void ack_bad_desc(struct irq_desc *desc)
+{
+	print_irq_desc(desc);
+	ack_bad_irq(desc->irq);
+}
 
 /*
  * NOP functions
@@ -306,11 +310,18 @@ static void ack_bad(unsigned int irq)
 static void noop(unsigned int irq)
 {
 }
+static void noop_desc(struct irq_desc *desc)
+{
+}
 
 static unsigned int noop_ret(unsigned int irq)
 {
 	return 0;
 }
+static unsigned int noop_ret_desc(struct irq_desc *des)
+{
+	return 0;
+}
 
 /*
  * Generic no controller implementation
@@ -323,6 +334,13 @@ struct irq_chip no_irq_chip = {
 	.disable	= noop,
 	.ack		= ack_bad,
 	.end		= noop,
+
+	.desc_startup	= noop_ret_desc,
+	.desc_shutdown	= noop_desc,
+	.desc_enable	= noop_desc,
+	.desc_disable	= noop_desc,
+	.desc_ack	= ack_bad_desc,
+	.desc_end	= noop_desc,
 };
 
 /*
@@ -339,6 +357,15 @@ struct irq_chip dummy_irq_chip = {
 	.mask		= noop,
 	.unmask		= noop,
 	.end		= noop,
+
+	.desc_startup	= noop_ret_desc,
+	.desc_shutdown	= noop_desc,
+	.desc_enable	= noop_desc,
+	.desc_disable	= noop_desc,
+	.desc_ack	= noop_desc,
+	.desc_mask	= noop_desc,
+	.desc_unmask	= noop_desc,
+	.desc_end	= noop_desc,
 };
 
 /*
@@ -461,19 +488,19 @@ unsigned int __do_IRQ(unsigned int irq)
 		 * No locking required for CPU-local interrupts:
 		 */
 		if (desc->chip->ack)
-			desc->chip->ack(irq);
+			desc_chip_ack(desc->chip, irq, desc);
 		if (likely(!(desc->status & IRQ_DISABLED))) {
 			action_ret = handle_IRQ_event(irq, desc->action);
 			if (!noirqdebug)
 				note_interrupt(irq, desc, action_ret);
 		}
-		desc->chip->end(irq);
+		desc_chip_end(desc->chip, irq, desc);
 		return 1;
 	}
 
 	raw_spin_lock(&desc->lock);
 	if (desc->chip->ack)
-		desc->chip->ack(irq);
+		desc_chip_ack(desc->chip, irq, desc);
 	/*
 	 * REPLAY is when Linux resends an IRQ that was dropped earlier
 	 * WAITING is used by probe to mark irqs that are being tested
@@ -533,7 +560,7 @@ out:
 	 * The ->end() handler has to deal with interrupts which got
 	 * disabled while the handler was running.
 	 */
-	desc->chip->end(irq);
+	desc_chip_end(desc->chip, irq, desc);
 	raw_spin_unlock(&desc->lock);
 
 	return 1;
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index c63f3bc..8c4133d 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -12,8 +12,8 @@ extern void compat_irq_chip_set_default_handler(struct irq_desc *desc);
 
 extern int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		unsigned long flags);
-extern void __disable_irq(struct irq_desc *desc, unsigned int irq, bool susp);
-extern void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume);
+extern void __disable_irq(struct irq_desc *desc, bool susp);
+extern void __enable_irq(struct irq_desc *desc, bool resume);
 
 extern struct lock_class_key irq_desc_lock_class;
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
@@ -40,17 +40,39 @@ extern int irq_select_affinity_usr(unsigned int irq);
 
 extern void irq_set_thread_affinity(struct irq_desc *desc);
 
+static inline int
+desc_chip_set_type(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc, unsigned int flow_type)
+{
+	if (chip->desc_set_type)
+		return chip->desc_set_type(desc, flow_type);
+	else if (chip->set_type)
+		return chip->set_type(irq, flow_type);
+	return 0;
+}
+static inline int
+desc_chip_set_wake(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc, unsigned int on)
+{
+	if (chip->desc_set_wake)
+		return chip->desc_set_wake(desc, on);
+	else if (chip->set_wake)
+		return chip->set_wake(irq, on);
+	return 0;
+}
 /* Inline functions for support of irq chips on slow busses */
-static inline void chip_bus_lock(unsigned int irq, struct irq_desc *desc)
+static inline void chip_bus_lock(struct irq_desc *desc)
 {
+	if (unlikely(desc->chip->desc_bus_lock))
+		desc->chip->desc_bus_lock(desc);
 	if (unlikely(desc->chip->bus_lock))
-		desc->chip->bus_lock(irq);
+		desc->chip->bus_lock(desc->irq);
 }
 
-static inline void chip_bus_sync_unlock(unsigned int irq, struct irq_desc *desc)
+static inline void chip_bus_sync_unlock(struct irq_desc *desc)
 {
+	if (unlikely(desc->chip->desc_bus_sync_unlock))
+		desc->chip->desc_bus_sync_unlock(desc);
 	if (unlikely(desc->chip->bus_sync_unlock))
-		desc->chip->bus_sync_unlock(irq);
+		desc->chip->bus_sync_unlock(desc->irq);
 }
 
 /*
@@ -61,10 +83,10 @@ static inline void chip_bus_sync_unlock(unsigned int irq, struct irq_desc *desc)
 
 #define P(f) if (desc->status & f) printk("%14s set\n", #f)
 
-static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
+static inline void print_irq_desc(struct irq_desc *desc)
 {
 	printk("irq %d, desc: %p, depth: %d, count: %d, unhandled: %d\n",
-		irq, desc, desc->depth, desc->irq_count, desc->irqs_unhandled);
+		desc->irq, desc, desc->depth, desc->irq_count, desc->irqs_unhandled);
 	printk("->handle_irq():  %p, ", desc->handle_irq);
 	print_symbol("%s\n", (unsigned long)desc->handle_irq);
 	printk("->chip(): %p, ", desc->chip);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index eb6078c..8a150e8 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -118,7 +118,7 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	if (desc->status & IRQ_MOVE_PCNTXT) {
-		if (!desc->chip->set_affinity(irq, cpumask)) {
+		if (!desc_chip_set_affinity(desc->chip, irq, desc, cpumask)) {
 			cpumask_copy(desc->affinity, cpumask);
 			irq_set_thread_affinity(desc);
 		}
@@ -128,7 +128,7 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 		cpumask_copy(desc->pending_mask, cpumask);
 	}
 #else
-	if (!desc->chip->set_affinity(irq, cpumask)) {
+	if (!desc_chip_set_affinity(desc->chip, irq, desc, cpumask)) {
 		cpumask_copy(desc->affinity, cpumask);
 		irq_set_thread_affinity(desc);
 	}
@@ -161,7 +161,7 @@ static int setup_affinity(unsigned int irq, struct irq_desc *desc)
 
 	cpumask_and(desc->affinity, cpu_online_mask, irq_default_affinity);
 set_affinity:
-	desc->chip->set_affinity(irq, desc->affinity);
+	desc_chip_set_affinity(desc->chip, irq, desc, desc->affinity);
 
 	return 0;
 }
@@ -197,7 +197,7 @@ static inline int setup_affinity(unsigned int irq, struct irq_desc *desc)
 }
 #endif
 
-void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
+void __disable_irq(struct irq_desc *desc, bool suspend)
 {
 	if (suspend) {
 		if (!desc->action || (desc->action->flags & IRQF_TIMER))
@@ -207,7 +207,7 @@ void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
 
 	if (!desc->depth++) {
 		desc->status |= IRQ_DISABLED;
-		desc->chip->disable(irq);
+		desc_chip_disable(desc->chip, desc->irq, desc);
 	}
 }
 
@@ -230,11 +230,11 @@ void disable_irq_nosync(unsigned int irq)
 	if (!desc)
 		return;
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	__disable_irq(desc, irq, false);
+	__disable_irq(desc, false);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL(disable_irq_nosync);
 
@@ -263,7 +263,7 @@ void disable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(disable_irq);
 
-void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
+void __enable_irq(struct irq_desc *desc, bool resume)
 {
 	if (resume)
 		desc->status &= ~IRQ_SUSPENDED;
@@ -271,7 +271,7 @@ void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
 	switch (desc->depth) {
 	case 0:
  err_out:
-		WARN(1, KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
+		WARN(1, KERN_WARNING "Unbalanced enable for IRQ %d\n", desc->irq);
 		break;
 	case 1: {
 		unsigned int status = desc->status & ~IRQ_DISABLED;
@@ -280,7 +280,7 @@ void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
 			goto err_out;
 		/* Prevent probing on this irq: */
 		desc->status = status | IRQ_NOPROBE;
-		check_irq_resend(desc, irq);
+		check_irq_resend(desc);
 		/* fall-through */
 	}
 	default:
@@ -307,21 +307,20 @@ void enable_irq(unsigned int irq)
 	if (!desc)
 		return;
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	__enable_irq(desc, irq, false);
+	__enable_irq(desc, false);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL(enable_irq);
 
-static int set_irq_wake_real(unsigned int irq, unsigned int on)
+static int set_irq_wake_real(struct irq_desc *desc, unsigned int on)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	int ret = -ENXIO;
 
 	if (desc->chip->set_wake)
-		ret = desc->chip->set_wake(irq, on);
+		ret = desc_chip_set_wake(desc->chip, desc->irq, desc, on);
 
 	return ret;
 }
@@ -350,7 +349,7 @@ int set_irq_wake(unsigned int irq, unsigned int on)
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	if (on) {
 		if (desc->wake_depth++ == 0) {
-			ret = set_irq_wake_real(irq, on);
+			ret = set_irq_wake_real(desc, on);
 			if (ret)
 				desc->wake_depth = 0;
 			else
@@ -360,7 +359,7 @@ int set_irq_wake(unsigned int irq, unsigned int on)
 		if (desc->wake_depth == 0) {
 			WARN(1, "Unbalanced IRQ %d wake disable\n", irq);
 		} else if (--desc->wake_depth == 0) {
-			ret = set_irq_wake_real(irq, on);
+			ret = set_irq_wake_real(desc, on);
 			if (ret)
 				desc->wake_depth = 1;
 			else
@@ -414,7 +413,7 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 	int ret;
 	struct irq_chip *chip = desc->chip;
 
-	if (!chip || !chip->set_type) {
+	if (!chip || !(chip->set_type || chip->desc_set_type)) {
 		/*
 		 * IRQF_TRIGGER_* but the PIC does not support multiple
 		 * flow-types?
@@ -425,7 +424,7 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 	}
 
 	/* caller masked out all except trigger mode flags */
-	ret = chip->set_type(irq, flags);
+	ret = desc_chip_set_type(chip, irq, desc, flags);
 
 	if (ret)
 		pr_err("setting trigger mode %d for irq %u failed (%pF)\n",
@@ -481,16 +480,16 @@ static int irq_wait_for_interrupt(struct irqaction *action)
  * handler finished. unmask if the interrupt has not been disabled and
  * is marked MASKED.
  */
-static void irq_finalize_oneshot(unsigned int irq, struct irq_desc *desc)
+static void irq_finalize_oneshot(struct irq_desc *desc)
 {
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	raw_spin_lock_irq(&desc->lock);
 	if (!(desc->status & IRQ_DISABLED) && (desc->status & IRQ_MASKED)) {
 		desc->status &= ~IRQ_MASKED;
-		desc->chip->unmask(irq);
+		desc_chip_unmask(desc->chip, desc->irq, desc);
 	}
 	raw_spin_unlock_irq(&desc->lock);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 
 #ifdef CONFIG_SMP
@@ -562,7 +561,7 @@ static int irq_thread(void *data)
 			action->thread_fn(action->irq, action->dev_id);
 
 			if (oneshot)
-				irq_finalize_oneshot(action->irq, desc);
+				irq_finalize_oneshot(desc);
 		}
 
 		wake = atomic_dec_and_test(&desc->threads_active);
@@ -738,7 +737,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		if (!(desc->status & IRQ_NOAUTOEN)) {
 			desc->depth = 0;
 			desc->status &= ~IRQ_DISABLED;
-			desc->chip->startup(irq);
+			desc_chip_startup(desc->chip, irq, desc);
 		} else
 			/* Undo nested disables: */
 			desc->depth = 1;
@@ -772,7 +771,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	 */
 	if (shared && (desc->status & IRQ_SPURIOUS_DISABLED)) {
 		desc->status &= ~IRQ_SPURIOUS_DISABLED;
-		__enable_irq(desc, irq, false);
+		__enable_irq(desc, false);
 	}
 
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
@@ -879,9 +878,9 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 	if (!desc->action) {
 		desc->status |= IRQ_DISABLED;
 		if (desc->chip->shutdown)
-			desc->chip->shutdown(irq);
+			desc_chip_shutdown(desc->chip, irq, desc);
 		else
-			desc->chip->disable(irq);
+			desc_chip_disable(desc->chip, irq, desc);
 	}
 
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
@@ -950,9 +949,9 @@ void free_irq(unsigned int irq, void *dev_id)
 	if (!desc)
 		return;
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	kfree(__free_irq(irq, dev_id));
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL(free_irq);
 
@@ -1059,9 +1058,9 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	action->name = devname;
 	action->dev_id = dev_id;
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	retval = __setup_irq(irq, desc, action);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 
 	if (retval)
 		kfree(action);
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index 2419622..a3b089d 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -4,10 +4,8 @@
 
 #include "internals.h"
 
-void move_masked_irq(int irq)
+void move_masked_irq_desc(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
 
@@ -43,26 +41,35 @@ void move_masked_irq(int irq)
 	 */
 	if (likely(cpumask_any_and(desc->pending_mask, cpu_online_mask)
 		   < nr_cpu_ids))
-		if (!desc->chip->set_affinity(irq, desc->pending_mask)) {
+		if (!desc_chip_set_affinity(desc->chip, desc->irq, desc, desc->pending_mask)) {
 			cpumask_copy(desc->affinity, desc->pending_mask);
 			irq_set_thread_affinity(desc);
 		}
 
 	cpumask_clear(desc->pending_mask);
 }
-
-void move_native_irq(int irq)
+void move_masked_irq(int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
+	move_masked_irq_desc(desc);
+}
+
+void move_native_irq_desc(struct irq_desc *desc)
+{
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
 
 	if (unlikely(desc->status & IRQ_DISABLED))
 		return;
 
-	desc->chip->mask(irq);
-	move_masked_irq(irq);
-	desc->chip->unmask(irq);
+	desc_chip_mask(desc->chip, desc->irq, desc);
+	move_masked_irq_desc(desc);
+	desc_chip_unmask(desc->chip, desc->irq, desc);
 }
+void move_native_irq(int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
 
+	move_native_irq_desc(desc);
+}
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index 0d4005d..a43c93d 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -29,7 +29,7 @@ void suspend_device_irqs(void)
 		unsigned long flags;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
-		__disable_irq(desc, irq, true);
+		__disable_irq(desc, true);
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 
@@ -57,7 +57,7 @@ void resume_device_irqs(void)
 			continue;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
-		__enable_irq(desc, irq, true);
+		__enable_irq(desc, true);
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index 090c376..4f316f0 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -53,14 +53,14 @@ static DECLARE_TASKLET(resend_tasklet, resend_irqs, 0);
  *
  * Is called with interrupts disabled and desc->lock held.
  */
-void check_irq_resend(struct irq_desc *desc, unsigned int irq)
+void check_irq_resend(struct irq_desc *desc)
 {
 	unsigned int status = desc->status;
 
 	/*
 	 * Make sure the interrupt is enabled, before resending it:
 	 */
-	desc->chip->enable(irq);
+	desc_chip_enable(desc->chip, desc->irq, desc);
 
 	/*
 	 * We do not resend level type interrupts. Level type
@@ -70,10 +70,10 @@ void check_irq_resend(struct irq_desc *desc, unsigned int irq)
 	if ((status & (IRQ_LEVEL | IRQ_PENDING | IRQ_REPLAY)) == IRQ_PENDING) {
 		desc->status = (status & ~IRQ_PENDING) | IRQ_REPLAY;
 
-		if (!desc->chip->retrigger || !desc->chip->retrigger(irq)) {
+		if (!desc_chip_retrigger(desc->chip, desc->irq, desc)) {
 #ifdef CONFIG_HARDIRQS_SW_RESEND
 			/* Set it pending and activate the softirq: */
-			set_bit(irq, irqs_resend);
+			set_bit(desc->irq, irqs_resend);
 			tasklet_schedule(&resend_tasklet);
 #endif
 		}
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 89fb90a..5b57e2d 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -79,7 +79,7 @@ static int try_one_irq(int irq, struct irq_desc *desc)
 	 * IRQ controller clean up too
 	 */
 	if (work && desc->chip && desc->chip->end)
-		desc->chip->end(irq);
+		desc_chip_end(desc->chip, irq, desc);
 	raw_spin_unlock(&desc->lock);
 
 	return ok;
@@ -254,7 +254,7 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		printk(KERN_EMERG "Disabling IRQ #%d\n", irq);
 		desc->status |= IRQ_DISABLED | IRQ_SPURIOUS_DISABLED;
 		desc->depth++;
-		desc->chip->disable(irq);
+		desc_chip_disable(desc->chip, irq, desc);
 
 		mod_timer(&poll_spurious_irq_timer,
 			  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
-- 
1.6.4.2

