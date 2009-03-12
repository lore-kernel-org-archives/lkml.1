Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbZCLNgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbZCLNgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbZCLNgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:36:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58978 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbZCLNgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:36:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/10] PM: Rework handling of interrupts during suspend-resume (rev. 5)
Date: Thu, 12 Mar 2009 14:36:20 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-tst; KDE/4.2.1; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
References: <200902221837.49396.rjw@sisk.pl> <alpine.LFD.2.00.0903112238280.29264@localhost.localdomain> <alpine.LFD.2.00.0903112342440.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903112342440.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903121436.21504.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 March 2009, Thomas Gleixner wrote:
> On Wed, 11 Mar 2009, Thomas Gleixner wrote:
> > On Wed, 11 Mar 2009, Rafael J. Wysocki wrote:
> > > On Wednesday 11 March 2009, Thomas Gleixner wrote:
> > > > > +EXPORT_SYMBOL_GPL(suspend_device_irqs);
> > > > 
> > > >   I'm not too enthusiastic about this open coded implementation of
> > > >   disable_irq() with slightly different semantics.
> > > 
> > > The difference in semantics is important IMO, otherwise I woulndn't have
> > > done that.  In particular, IMO, the condition should be under the spinlock IMO
> > > and I'd rather not synchronize all interrupts we don't really disable here.
> > 
> > I don't say that the difference is not relevant. But the code is
> > almost the same and disable_irq() could have the sync_irq optimization
> > as well.
> 
> Thought more about that. Avoiding the sync_irq() for irqs which have
> no action associated is fine, but you need to catch the following case
> as well:
> 
>    driver code calls disable_irq_nosyc() from the handler (which is
>    still running)
> 
>    suspend code skips the sync due to depth > 0
> 
> The sync operation is not that expensive.

OK, what about this (untested, irrelevant parts skipped)?

Index: linux-2.6/kernel/irq/pm.c
===================================================================
--- /dev/null
+++ linux-2.6/kernel/irq/pm.c
@@ -0,0 +1,79 @@
+/*
+ * linux/kernel/irq/pm.c
+ *
+ * Copyright (C) 2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+ *
+ * This file contains power management functions related to interrupts.
+ */
+
+#include <linux/irq.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+
+#include "internals.h"
+
+/**
+ * suspend_device_irqs - disable all currently enabled interrupt lines
+ *
+ * During system-wide suspend or hibernation device interrupts need to be
+ * disabled at the chip level and this function is provided for this purpose.
+ * It disables all interrupt lines that are enabled at the moment and sets the
+ * IRQ_SUSPENDED flag for them.
+ */
+void suspend_device_irqs(void)
+{
+	struct irq_desc *desc;
+	int irq;
+
+	for_each_irq_desc(irq, desc) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&desc->lock, flags);
+		__disable_irq(desc, irq, true);
+		spin_unlock_irqrestore(&desc->lock, flags);
+	}
+
+	for_each_irq_desc(irq, desc)
+		if (desc->status & IRQ_SUSPENDED)
+			synchronize_irq(irq);
+}
+EXPORT_SYMBOL_GPL(suspend_device_irqs);
+
+/**
+ * resume_device_irqs - enable interrupt lines disabled by suspend_device_irqs()
+ *
+ * Enable all interrupt lines previously disabled by suspend_device_irqs() that
+ * have the IRQ_SUSPENDED flag set.
+ */
+void resume_device_irqs(void)
+{
+	struct irq_desc *desc;
+	int irq;
+
+	for_each_irq_desc(irq, desc) {
+		unsigned long flags;
+
+		if (!(desc->status & IRQ_SUSPENDED))
+			continue;
+
+		spin_lock_irqsave(&desc->lock, flags);
+		__enable_irq(desc, irq, true);
+		spin_unlock_irqrestore(&desc->lock, flags);
+	}
+}
+EXPORT_SYMBOL_GPL(resume_device_irqs);
+
+/**
+ * check_wakeup_irqs - check if any wake-up interrupts are pending
+ */
+int check_wakeup_irqs(void)
+{
+	struct irq_desc *desc;
+	int irq;
+
+	for_each_irq_desc(irq, desc)
+		if ((desc->status & IRQ_WAKEUP) && (desc->status & IRQ_PENDING))
+			return -EBUSY;
+
+	return 0;
+}
Index: linux-2.6/kernel/irq/Makefile
===================================================================
--- linux-2.6.orig/kernel/irq/Makefile
+++ linux-2.6/kernel/irq/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_GENERIC_IRQ_PROBE) += autop
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
 obj-$(CONFIG_NUMA_MIGRATE_IRQ_DESC) += numa_migrate.o
+obj-$(CONFIG_PM_SLEEP) += pm.o
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -162,6 +162,20 @@ static inline int do_irq_select_affinity
 }
 #endif
 
+void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
+{
+	if (suspend) {
+		if (desc->action && (desc->action->flags & IRQF_TIMER))
+			return;
+		desc->status |= IRQ_SUSPENDED;
+	}
+
+	if (!desc->depth++) {
+		desc->status |= IRQ_DISABLED;
+		desc->chip->disable(irq);
+	}
+}
+
 /**
  *	disable_irq_nosync - disable an irq without waiting
  *	@irq: Interrupt to disable
@@ -182,10 +196,7 @@ void disable_irq_nosync(unsigned int irq
 		return;
 
 	spin_lock_irqsave(&desc->lock, flags);
-	if (!desc->depth++) {
-		desc->status |= IRQ_DISABLED;
-		desc->chip->disable(irq);
-	}
+	__disable_irq(desc, irq, false);
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
 EXPORT_SYMBOL(disable_irq_nosync);
@@ -215,15 +226,19 @@ void disable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(disable_irq);
 
-static void __enable_irq(struct irq_desc *desc, unsigned int irq)
+void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
 {
+	if (resume)
+		desc->status &= ~IRQ_SUSPENDED;
+
 	switch (desc->depth) {
 	case 0:
-		WARN(1, KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
-		break;
+		goto err_out;
 	case 1: {
 		unsigned int status = desc->status & ~IRQ_DISABLED;
 
+		if (desc->status & IRQ_SUSPENDED)
+			goto err_out;
 		/* Prevent probing on this irq: */
 		desc->status = status | IRQ_NOPROBE;
 		check_irq_resend(desc, irq);
@@ -232,6 +247,11 @@ static void __enable_irq(struct irq_desc
 	default:
 		desc->depth--;
 	}
+
+	return;
+
+ err_out:
+	WARN(true, KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
 }
 
 /**
@@ -253,7 +273,7 @@ void enable_irq(unsigned int irq)
 		return;
 
 	spin_lock_irqsave(&desc->lock, flags);
-	__enable_irq(desc, irq);
+	__enable_irq(desc, irq, false);
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
 EXPORT_SYMBOL(enable_irq);
@@ -511,7 +531,7 @@ __setup_irq(unsigned int irq, struct irq
 	 */
 	if (shared && (desc->status & IRQ_SPURIOUS_DISABLED)) {
 		desc->status &= ~IRQ_SPURIOUS_DISABLED;
-		__enable_irq(desc, irq);
+		__enable_irq(desc, irq, false);
 	}
 
 	spin_unlock_irqrestore(&desc->lock, flags);
Index: linux-2.6/kernel/irq/internals.h
===================================================================
--- linux-2.6.orig/kernel/irq/internals.h
+++ linux-2.6/kernel/irq/internals.h
@@ -12,6 +12,8 @@ extern void compat_irq_chip_set_default_
 
 extern int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		unsigned long flags);
+extern void __disable_irq(struct irq_desc *desc, unsigned int irq, bool susp);
+extern void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume);
 
 extern struct lock_class_key irq_desc_lock_class;
 extern void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr);

Thanks,
Rafael
