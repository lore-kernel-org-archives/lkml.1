Return-Path: <linux-kernel-owner+w=401wt.eu-S1751487AbZCNAEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbZCNAEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbZCNAEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:04:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38786 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbZCNAEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:04:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [update, rev. 6] Re: [PATCH 1/10] PM: Rework handling of interrupts during suspend-resume (rev. 5)
Date: Sat, 14 Mar 2009 01:04:00 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-tst; KDE/4.2.1; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
References: <200902221837.49396.rjw@sisk.pl> <200903122243.27452.rjw@sisk.pl> <alpine.LFD.2.00.0903132052240.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903132052240.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903140104.01255.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 March 2009, Thomas Gleixner wrote:
> On Thu, 12 Mar 2009, Rafael J. Wysocki wrote:
> > +/**
> > + * suspend_device_irqs - disable all currently enabled interrupt lines
> > + *
> > + * During system-wide suspend or hibernation device interrupts need to be
> > + * disabled at the chip level and this function is provided for this purpose.
> > + * It disables all interrupt lines that are enabled at the moment and sets the
> > + * IRQ_SUSPENDED flag for them.
> > + */
> > +void suspend_device_irqs(void)
> > +{
> > +	struct irq_desc *desc;
> > +	int irq;
> > +
> > +	for_each_irq_desc(irq, desc) {
> > +		unsigned long flags;
> > +
> > +		spin_lock_irqsave(&desc->lock, flags);
> > +		__disable_irq(desc, irq, true);
> > +		spin_unlock_irqrestore(&desc->lock, flags);
> 
> Can we move the locking into __disable_irq ?
> 
> > +	}
> > +
> > +	for_each_irq_desc(irq, desc)
> > +		if (desc->status & IRQ_SUSPENDED)
> > +			synchronize_irq(irq);
> > +}
> > +EXPORT_SYMBOL_GPL(suspend_device_irqs);
> > +
> > +/**
> > + * resume_device_irqs - enable interrupt lines disabled by suspend_device_irqs()
> > + *
> > + * Enable all interrupt lines previously disabled by suspend_device_irqs() that
> > + * have the IRQ_SUSPENDED flag set.
> > + */
> > +void resume_device_irqs(void)
> > +{
> > +	struct irq_desc *desc;
> > +	int irq;
> > +
> > +	for_each_irq_desc(irq, desc) {
> > +		unsigned long flags;
> > +
> > +		if (!(desc->status & IRQ_SUSPENDED))
> > +			continue;
> > +
> > +		spin_lock_irqsave(&desc->lock, flags);
> > +		__enable_irq(desc, irq, true);
> > +		spin_unlock_irqrestore(&desc->lock, flags);
> 
> Ditto

Well, I guess you'd prefer something like the appended patch, but Ingo probably
won't like it since it contains additional #ifdefs in irq/manage.c .  Sigh.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Introduce functions for suspending and resuming device interrupts

Introduce two helper functions allowing us to prevent device drivers
from getting any interrupts (without disabling interrupts on the CPU)
during suspend (or hibernation) and to make them start to receive
interrupts again during the subsequent resume, respectively.  These
functions make it possible to keep timer interrupts enabled while the
"late" suspend and "early" resume callbacks provided by device
drivers are being executed.

These functions will be used to rework the handling of interrupts
during suspend (hibernation) and resume.  Namely, interrupts will
only be disabled on the CPU right before suspending sysdevs, while
device drivers will be prevented from receiving interrupts, with the
help of the new helper function, before their "late" suspend
callbacks run (and analogously during resume).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/interrupt.h |    5 +++
 include/linux/irq.h       |    1 
 kernel/irq/Makefile       |    1 
 kernel/irq/internals.h    |    2 +
 kernel/irq/manage.c       |   45 ++++++++++++++++++++++++++++---
 kernel/irq/pm.c           |   66 ++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 116 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -65,6 +65,7 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_SPURIOUS_DISABLED	0x00800000	/* IRQ was disabled by the spurious trap */
 #define IRQ_MOVE_PCNTXT		0x01000000	/* IRQ migration from process context */
 #define IRQ_AFFINITY_SET	0x02000000	/* IRQ affinity was set from userspace*/
+#define IRQ_SUSPENDED		0x04000000	/* IRQ has gone through suspend sequence */
 
 #ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -162,6 +162,14 @@ static inline int do_irq_select_affinity
 }
 #endif
 
+static void __disable_irq(struct irq_desc *desc, unsigned int irq)
+{
+	if (!desc->depth++) {
+		desc->status |= IRQ_DISABLED;
+		desc->chip->disable(irq);
+	}
+}
+
 /**
  *	disable_irq_nosync - disable an irq without waiting
  *	@irq: Interrupt to disable
@@ -182,10 +190,7 @@ void disable_irq_nosync(unsigned int irq
 		return;
 
 	spin_lock_irqsave(&desc->lock, flags);
-	if (!desc->depth++) {
-		desc->status |= IRQ_DISABLED;
-		desc->chip->disable(irq);
-	}
+	__disable_irq(desc, irq);
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
 EXPORT_SYMBOL(disable_irq_nosync);
@@ -215,15 +220,32 @@ void disable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(disable_irq);
 
+#ifdef CONFIG_PM_SLEEP
+void suspend_irq(struct irq_desc *desc, unsigned int irq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&desc->lock, flags);
+	if (desc->action && !(desc->action->flags & IRQF_TIMER)) {
+		__disable_irq(desc, irq);
+		desc->status |= IRQ_SUSPENDED;
+	}
+	spin_unlock_irqrestore(&desc->lock, flags);
+}
+#endif
+
 static void __enable_irq(struct irq_desc *desc, unsigned int irq)
 {
 	switch (desc->depth) {
 	case 0:
+ err_out:
 		WARN(1, KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
 		break;
 	case 1: {
 		unsigned int status = desc->status & ~IRQ_DISABLED;
 
+		if (desc->status & IRQ_SUSPENDED)
+			goto err_out;
 		/* Prevent probing on this irq: */
 		desc->status = status | IRQ_NOPROBE;
 		check_irq_resend(desc, irq);
@@ -258,6 +280,21 @@ void enable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(enable_irq);
 
+#ifdef CONFIG_PM_SLEEP
+void resume_irq(struct irq_desc *desc, unsigned int irq)
+{
+	unsigned long flags;
+
+	if (!(desc->status & IRQ_SUSPENDED))
+		return;
+
+	spin_lock_irqsave(&desc->lock, flags);
+	desc->status &= ~IRQ_SUSPENDED;
+	__enable_irq(desc, irq);
+	spin_unlock_irqrestore(&desc->lock, flags);
+}
+#endif
+
 static int set_irq_wake_real(unsigned int irq, unsigned int on)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
Index: linux-2.6/kernel/irq/internals.h
===================================================================
--- linux-2.6.orig/kernel/irq/internals.h
+++ linux-2.6/kernel/irq/internals.h
@@ -12,6 +12,8 @@ extern void compat_irq_chip_set_default_
 
 extern int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		unsigned long flags);
+extern void suspend_irq(struct irq_desc *desc, unsigned int irq);
+extern void resume_irq(struct irq_desc *desc, unsigned int irq);
 
 extern struct lock_class_key irq_desc_lock_class;
 extern void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr);
Index: linux-2.6/kernel/irq/Makefile
===================================================================
--- linux-2.6.orig/kernel/irq/Makefile
+++ linux-2.6/kernel/irq/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_GENERIC_IRQ_PROBE) += autop
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
 obj-$(CONFIG_NUMA_MIGRATE_IRQ_DESC) += numa_migrate.o
+obj-$(CONFIG_PM_SLEEP) += pm.o
Index: linux-2.6/kernel/irq/pm.c
===================================================================
--- /dev/null
+++ linux-2.6/kernel/irq/pm.c
@@ -0,0 +1,66 @@
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
+	for_each_irq_desc(irq, desc)
+		suspend_irq(desc, irq);
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
+	for_each_irq_desc(irq, desc)
+		resume_irq(desc, irq);
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
Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -106,6 +106,11 @@ extern void disable_irq_nosync(unsigned 
 extern void disable_irq(unsigned int irq);
 extern void enable_irq(unsigned int irq);
 
+/* The following three functions are for the core kernel use only. */
+extern void suspend_device_irqs(void);
+extern void resume_device_irqs(void);
+extern int check_wakeup_irqs(void);
+
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
 
 extern cpumask_var_t irq_default_affinity;
