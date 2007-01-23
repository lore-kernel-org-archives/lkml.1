Return-Path: <linux-kernel-owner+w=401wt.eu-S965514AbXAWWLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965514AbXAWWLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933133AbXAWWAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:00:45 -0500
Received: from www.osadl.org ([213.239.205.134]:35792 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932939AbXAWWAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:00:43 -0500
Message-Id: <20070123211202.609785000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:00:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 02/46] Add a functions to handle interrupt affinity setting
Content-Disposition: inline; filename=genirq-add-set-affinity-function.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Provide funtions to:
 - check, whether an interrupt can set the affinity
 - pin the interrupt to a given cpu

Necessary for the ability to setup clocksources more flexible (e.g. use
the different HPET channels per CPU)

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 include/linux/irq.h |   20 +++++++++++++++-----
 kernel/irq/manage.c |   40 ++++++++++++++++++++++++++++++++++++++++
 kernel/irq/proc.c   |   22 +---------------------
 3 files changed, 56 insertions(+), 26 deletions(-)

Index: linux-2.6.20-rc4-mm1-bo/include/linux/irq.h
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/include/linux/irq.h
+++ linux-2.6.20-rc4-mm1-bo/include/linux/irq.h
@@ -70,11 +70,6 @@ typedef	void fastcall (*irq_flow_handler
 # define IRQ_NO_BALANCING_MASK	IRQ_NO_BALANCING
 #endif
 
-static inline int irq_balancing_disabled(unsigned int irq)
-{
-	return irq_desc[irq].status & IRQ_NO_BALANCING_MASK;
-}
-
 struct proc_dir_entry;
 
 /**
@@ -241,11 +236,21 @@ static inline void set_pending_irq(unsig
 
 #endif /* CONFIG_GENERIC_PENDING_IRQ */
 
+extern int irq_set_affinity(unsigned int irq, cpumask_t cpumask);
+extern int irq_can_set_affinity(unsigned int irq);
+
 #else /* CONFIG_SMP */
 
 #define move_native_irq(x)
 #define move_masked_irq(x)
 
+static inline int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
+{
+	return -EINVAL;
+}
+
+static inline int irq_can_set_affinity(unsigned int irq) { return 0; }
+
 #endif /* CONFIG_SMP */
 
 #ifdef CONFIG_IRQBALANCE
@@ -267,6 +272,11 @@ static inline int select_smp_affinity(un
 
 extern int no_irq_affinity;
 
+static inline int irq_balancing_disabled(unsigned int irq)
+{
+	return irq_desc[irq].status & IRQ_NO_BALANCING_MASK;
+}
+
 /* Handle irq action chains: */
 extern int handle_IRQ_event(unsigned int irq, struct irqaction *action);
 
Index: linux-2.6.20-rc4-mm1-bo/kernel/irq/manage.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/irq/manage.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/irq/manage.c
@@ -38,6 +38,46 @@ void synchronize_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(synchronize_irq);
 
+/**
+ *	irq_can_set_affinity - Check if the affinity of a given irq can be set
+ *	@irq:		Interrupt to check
+ *
+ */
+int irq_can_set_affinity(unsigned int irq)
+{
+	struct irq_desc *desc = irq_desc + irq;
+
+	if (CHECK_IRQ_PER_CPU(desc->status) || !desc->chip ||
+	    !desc->chip->set_affinity)
+		return 0;
+
+	return 1;
+}
+
+/**
+ *	irq_set_affinity - Set the irq affinity of a given irq
+ *	@irq:		Interrupt to set affinity
+ *	@cpumask:	cpumask
+ *
+ */
+int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
+{
+	struct irq_desc *desc = irq_desc + irq;
+
+	if (!desc->chip->set_affinity)
+		return -EINVAL;
+
+	set_balance_irq_affinity(irq, cpumask);
+
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	set_pending_irq(irq, cpumask);
+#else
+	irq_desc[irq]->affinity = cpumask;
+	irq_desc[irq]->chip->set_affinity(irq, cpumask);
+#endif
+	return 0;
+}
+
 #endif
 
 /**
Index: linux-2.6.20-rc4-mm1-bo/kernel/irq/proc.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/irq/proc.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/irq/proc.c
@@ -16,26 +16,6 @@ static struct proc_dir_entry *root_irq_d
 
 #ifdef CONFIG_SMP
 
-#ifdef CONFIG_GENERIC_PENDING_IRQ
-void proc_set_irq_affinity(unsigned int irq, cpumask_t mask_val)
-{
-	set_balance_irq_affinity(irq, mask_val);
-
-	/*
-	 * Save these away for later use. Re-progam when the
-	 * interrupt is pending
-	 */
-	set_pending_irq(irq, mask_val);
-}
-#else
-void proc_set_irq_affinity(unsigned int irq, cpumask_t mask_val)
-{
-	set_balance_irq_affinity(irq, mask_val);
-	irq_desc[irq].affinity = mask_val;
-	irq_desc[irq].chip->set_affinity(irq, mask_val);
-}
-#endif
-
 static int irq_affinity_read_proc(char *page, char **start, off_t off,
 				  int count, int *eof, void *data)
 {
@@ -73,7 +53,7 @@ static int irq_affinity_write_proc(struc
 		   code to set default SMP affinity. */
 		return select_smp_affinity(irq) ? -EINVAL : full_count;
 
-	proc_set_irq_affinity(irq, new_value);
+	irq_set_affinity(irq, new_value);
 
 	return full_count;
 }

--

