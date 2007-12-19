Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbXLSUBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbXLSUBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 15:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756691AbXLSUBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 15:01:12 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:42739 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437AbXLSUBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 15:01:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:mime-version:x-mailer:content-transfer-encoding:sender:message-id;
        b=wiVYKA5rMzjbcXpp7EcIC0q0Y032mlvPVe+gYf2CGHaF03JaQAqdA5Sgn2dsVzfiNAHaN56LRLYObaahl4L98m88h0CHzf3gZJ0uNcdGn11WqzPStC3WCAkxh1HNhYGssH+JCVEFIQGRrnr01J/RnlJGh6MY7h5DZcFN3g8Kbps=
References: <20071219194551.315868746@bohmer.net>>
User-Agent: quilt/0.46-1
Date: Wed, 19 Dec 2007 20:45:53 +0100
From: Remy Bohmer <linux@bohmer.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Ingo Molnar <mingo@elte.hu>, Juergen Beisert <jbe@pengutronix.de>,
       Darren Hart <dvhltc@us.ibm.com>, linux-rt-users@vger.kernel.org,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       LKML <linux-kernel@vger.kernel.org>, Remy Bohmer <linux@bohmer.net>
Subject: [patch 2/3] Enable setting of IRQ-thread priorities from kernel
	cmdline (repost:CC to LKML)
Content-Disposition: inline; filename=changing_interrupt_prios_from_kernel_cmdline.patch
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Message-ID: <47697882.2275420a.3951.ffff92ed@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RT-patch originally creates all its IRQ-threads at priority 50.
Of course, this is not a usable default for many realtime systems
and therefor these priorities has to be tuneable for each RT-system.
But, currently there is no way within the kernel to adjust this to
the needs of the user. Some scripts are floating around to do this
from userspace, but for several applications the priorities should
already be set properly by the kernel itself before userland is
started.

This patch changes this by adding a kernel cmd-line option that can
handle a map of priorities.
It is based on the name of the driver that requests an interrupt, it
does NOT use the IRQ-ID to prioritize a certain IRQ thread.
This is designed this way because across several hardware-boards the
IRQ-IDs can change, but not necessarily the drivers 
(interrupt handlers) name.


Remarks:
* There is a check for conflicts added, for situations where 
  IRQ-sharing is detected with different priorities requested
  on the kernel cmd-line.
* Priorities are only set at creation time of the IRQ-thread.
* If userland overrules, it is NOT restored by this code.
* if no new kernel cmdline options are given, the kernel works
  as before, and all IRQ-threads start at 50.
* No wildcards are supported on the cmdline.

See kernel/Documentation/kernel-parameters.txt for usage info.

Signed-off-by: Remy Bohmer <linux@bohmer.net>

---
 Documentation/kernel-parameters.txt |    7 ++
 include/linux/irq.h                 |    1 
 kernel/irq/manage.c                 |  101 ++++++++++++++++++++++++++++++++----
 3 files changed, 98 insertions(+), 11 deletions(-)

Index: linux-2.6.24-rc5-rt1/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.24-rc5-rt1.orig/Documentation/kernel-parameters.txt	2007-12-18 22:09:13.000000000 +0100
+++ linux-2.6.24-rc5-rt1/Documentation/kernel-parameters.txt	2007-12-18 22:09:16.000000000 +0100
@@ -799,6 +799,13 @@ and is between 256 and 4096 characters. 
 	ips=		[HW,SCSI] Adaptec / IBM ServeRAID controller
 			See header of drivers/scsi/ips.c.
 
+	irq_pmap=	[IRQ-threading] List of priorities each interrupt
+			thread must have.
+			Format: irq_pmap=megasas:90,eth0:40,50
+			The first field without ':', is the default prio.
+			If this cmdline argument is ommitted, every thread
+			runs at prio 50.
+
 	ports=		[IP_VS_FTP] IPVS ftp helper module
 			Default is 21.
 			Up to 8 (IP_VS_APP_MAX_PORTS) ports
Index: linux-2.6.24-rc5-rt1/include/linux/irq.h
===================================================================
--- linux-2.6.24-rc5-rt1.orig/include/linux/irq.h	2007-12-18 22:09:13.000000000 +0100
+++ linux-2.6.24-rc5-rt1/include/linux/irq.h	2007-12-18 22:09:16.000000000 +0100
@@ -169,6 +169,7 @@ struct irq_desc {
 	unsigned int		irqs_unhandled;
 	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
 	struct task_struct	*thread;
+	int                     rt_prio;
 	wait_queue_head_t	wait_for_handler;
 	cycles_t		timestamp;
 	raw_spinlock_t		lock;
Index: linux-2.6.24-rc5-rt1/kernel/irq/manage.c
===================================================================
--- linux-2.6.24-rc5-rt1.orig/kernel/irq/manage.c	2007-12-18 22:09:13.000000000 +0100
+++ linux-2.6.24-rc5-rt1/kernel/irq/manage.c	2007-12-18 22:15:43.000000000 +0100
@@ -13,9 +13,19 @@
 #include <linux/kthread.h>
 #include <linux/syscalls.h>
 #include <linux/interrupt.h>
+#include <linux/list.h>
 
 #include "internals.h"
 
+
+#ifdef CONFIG_PREEMPT_HARDIRQS
+
+static char *cmdline;
+static int  default_prio = MAX_USER_RT_PRIO/2;
+
+#endif
+
+
 #ifdef CONFIG_SMP
 
 /**
@@ -260,7 +270,7 @@ void recalculate_desc_flags(struct irq_d
 			desc->status |= IRQ_NODELAY;
 }
 
-static int start_irq_thread(int irq, struct irq_desc *desc);
+static int start_irq_thread(int irq, struct irq_desc *desc, int prio);
 
 /*
  * Internal function that tells the architecture code whether a
@@ -293,6 +303,8 @@ void compat_irq_chip_set_default_handler
 		desc->handle_irq = NULL;
 }
 
+static int get_irq_prio(const char *name);
+
 /*
  * Internal function to register an irqaction - typically used to
  * allocate special interrupts that are part of the architecture.
@@ -328,7 +340,7 @@ int setup_irq(unsigned int irq, struct i
 	}
 
 	if (!(new->flags & IRQF_NODELAY))
-		if (start_irq_thread(irq, desc))
+		if (start_irq_thread(irq, desc, get_irq_prio(new->name)))
 			return -ENOMEM;
 	/*
 	 * The following block of code has to be executed atomically
@@ -811,11 +823,7 @@ static int do_irqd(void * __desc)
 #endif
 	current->flags |= PF_NOFREEZE | PF_HARDIRQ;
 
-	/*
-	 * Set irq thread priority to SCHED_FIFO/50:
-	 */
-	param.sched_priority = MAX_USER_RT_PRIO/2;
-
+	param.sched_priority = desc->rt_prio;
 	sys_sched_setscheduler(current->pid, SCHED_FIFO, &param);
 
 	while (!kthread_should_stop()) {
@@ -850,11 +858,20 @@ static int do_irqd(void * __desc)
 
 static int ok_to_create_irq_threads;
 
-static int start_irq_thread(int irq, struct irq_desc *desc)
+static int start_irq_thread(int irq, struct irq_desc *desc, int prio)
 {
-	if (desc->thread || !ok_to_create_irq_threads)
+	if (!ok_to_create_irq_threads)
 		return 0;
 
+	if (desc->thread) {
+		if (desc->rt_prio != prio)
+			printk(KERN_NOTICE
+			       "irqd: Interrupt sharing detected with "
+			       "conflicting thread priorities, irq:%d!\n", irq);
+		return 0;
+	}
+
+	desc->rt_prio = prio;
 	desc->thread = kthread_create(do_irqd, desc, "IRQ-%d", irq);
 	if (!desc->thread) {
 		printk(KERN_ERR "irqd: could not create IRQ thread %d!\n", irq);
@@ -881,13 +898,13 @@ void __init init_hardirqs(void)
 		irq_desc_t *desc = irq_desc + i;
 
 		if (desc->action && !(desc->status & IRQ_NODELAY))
-			start_irq_thread(i, desc);
+			start_irq_thread(i, desc, get_irq_prio(NULL));
 	}
 }
 
 #else
 
-static int start_irq_thread(int irq, struct irq_desc *desc)
+static int start_irq_thread(int irq, struct irq_desc *desc, int prio)
 {
 	return 0;
 }
@@ -901,3 +918,65 @@ void __init early_init_hardirqs(void)
 	for (i = 0; i < NR_IRQS; i++)
 		init_waitqueue_head(&irq_desc[i].wait_for_handler);
 }
+
+#ifdef CONFIG_PREEMPT_HARDIRQS
+
+/*
+ * Lookup the interrupt thread priority
+ * A map for the priorities can be given on the kernel commandline.
+ * if name is NULL, or no kernel commandline options is given, the default
+ * prio is used, which is either MAX_PRIO/2, or the default given on the
+ * kernel commandline.
+ */
+static int get_irq_prio(const char *name)
+{
+	int prio = default_prio; /* Set the default for all threads */
+
+	/* If no commandline options, use thread prio defaults the old style.*/
+	if (!cmdline)
+		return prio;
+
+	if (!get_map_option(cmdline, name, &prio)) {
+		prio = default_prio;
+		if (name != NULL)
+			printk(KERN_INFO
+				"No IRQ-priority specified for '%s', " \
+				"using default(=%d)\n", name, prio);
+	} else {
+		if ((prio <= 0) || (prio >= MAX_USER_RT_PRIO))
+			prio = default_prio;
+
+		if (name != NULL)
+			printk(KERN_INFO "Using IRQ-priority %d for '%s'\n",
+				prio, name);
+	}
+	return prio;
+}
+
+/*
+ * Store the pointer to the arguments in a global var, and store the
+ * default prio globally
+ */
+static int __init irq_prio_map_setup(char *str)
+{
+	if (!str) /* sanity check */
+		return 1;
+
+	cmdline		= str; /* store it for later use */
+	default_prio	= get_irq_prio(NULL);
+
+	printk(KERN_INFO "Default IRQ-priority: %d\n", default_prio);
+	return 1;
+}
+
+/*
+ * The commandline looks like this: irq_pmap=megasas:90,eth0:40,50
+ * The first field without the ':' is used as the default for all irq-threads.
+ * There is a check for conflicts on irq-sharing.
+ * The priorities are only set on creation of the interrupt threads, thus at
+ * the time a driver uses a certain interrupt thread for the first time.
+ * Unknown or redundant fields are ignored.
+ */
+__setup("irq_pmap=", irq_prio_map_setup);
+
+#endif

-- 

