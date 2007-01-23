Return-Path: <linux-kernel-owner+w=401wt.eu-S932498AbXAWWAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbXAWWAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933108AbXAWWAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:00:43 -0500
Received: from www.osadl.org ([213.239.205.134]:35786 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932498AbXAWWAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:00:42 -0500
Message-Id: <20070123211202.200031000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:00:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 01/46] Add irq flag to disable balancing for an interrupt
Content-Disposition: inline; filename=genirq-add-noirqbalance-flag.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Add a flag so we can prevent the irq balancing of an interrupt. Move
the bits, so we have room for more :)

Necessary for the ability to setup clocksources more flexible (e.g. use
the different HPET channels per CPU)

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/i386/kernel/io_apic.c |    4 ++--
 include/linux/interrupt.h  |    3 +++
 include/linux/irq.h        |   40 ++++++++++++++++++++++++----------------
 kernel/irq/manage.c        |    4 ++++
 kernel/irq/proc.c          |    2 +-
 5 files changed, 34 insertions(+), 19 deletions(-)

Index: linux-2.6.20-rc4-mm1-bo/arch/i386/kernel/io_apic.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/arch/i386/kernel/io_apic.c
+++ linux-2.6.20-rc4-mm1-bo/arch/i386/kernel/io_apic.c
@@ -482,8 +482,8 @@ static void do_irq_balance(void)
 		package_index = CPU_TO_PACKAGEINDEX(i);
 		for (j = 0; j < NR_IRQS; j++) {
 			unsigned long value_now, delta;
-			/* Is this an active IRQ? */
-			if (!irq_desc[j].action)
+			/* Is this an active IRQ or balancing disabled ? */
+			if (!irq_desc[j].action || irq_balancing_disabled(j))
 				continue;
 			if ( package_index == i )
 				IRQ_DELTA(package_index,j) = 0;
Index: linux-2.6.20-rc4-mm1-bo/include/linux/interrupt.h
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/include/linux/interrupt.h
+++ linux-2.6.20-rc4-mm1-bo/include/linux/interrupt.h
@@ -41,6 +41,8 @@
  * IRQF_SHARED - allow sharing the irq among several devices
  * IRQF_PROBE_SHARED - set by callers when they expect sharing mismatches to occur
  * IRQF_TIMER - Flag to mark this interrupt as timer interrupt
+ * IRQF_PERCPU - Interrupt is per cpu
+ * IRQF_NOBALANCING - Flag to exclude this interrupt from irq balancing
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -48,6 +50,7 @@
 #define IRQF_PROBE_SHARED	0x00000100
 #define IRQF_TIMER		0x00000200
 #define IRQF_PERCPU		0x00000400
+#define IRQF_NOBALANCING	0x00000800
 
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
Index: linux-2.6.20-rc4-mm1-bo/include/linux/irq.h
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/include/linux/irq.h
+++ linux-2.6.20-rc4-mm1-bo/include/linux/irq.h
@@ -31,7 +31,7 @@ typedef	void fastcall (*irq_flow_handler
 /*
  * IRQ line status.
  *
- * Bits 0-16 are reserved for the IRQF_* bits in linux/interrupt.h
+ * Bits 0-7 are reserved for the IRQF_* bits in linux/interrupt.h
  *
  * IRQ types
  */
@@ -45,27 +45,35 @@ typedef	void fastcall (*irq_flow_handler
 #define IRQ_TYPE_PROBE		0x00000010	/* Probing in progress */
 
 /* Internal flags */
-#define IRQ_INPROGRESS		0x00010000	/* IRQ handler active - do not enter! */
-#define IRQ_DISABLED		0x00020000	/* IRQ disabled - do not enter! */
-#define IRQ_PENDING		0x00040000	/* IRQ pending - replay on enable */
-#define IRQ_REPLAY		0x00080000	/* IRQ has been replayed but not acked yet */
-#define IRQ_AUTODETECT		0x00100000	/* IRQ is being autodetected */
-#define IRQ_WAITING		0x00200000	/* IRQ not yet seen - for autodetection */
-#define IRQ_LEVEL		0x00400000	/* IRQ level triggered */
-#define IRQ_MASKED		0x00800000	/* IRQ masked - shouldn't be seen again */
-#define IRQ_PER_CPU		0x01000000	/* IRQ is per CPU */
+#define IRQ_INPROGRESS		0x00000100	/* IRQ handler active - do not enter! */
+#define IRQ_DISABLED		0x00000200	/* IRQ disabled - do not enter! */
+#define IRQ_PENDING		0x00000400	/* IRQ pending - replay on enable */
+#define IRQ_REPLAY		0x00000800	/* IRQ has been replayed but not acked yet */
+#define IRQ_AUTODETECT		0x00001000	/* IRQ is being autodetected */
+#define IRQ_WAITING		0x00002000	/* IRQ not yet seen - for autodetection */
+#define IRQ_LEVEL		0x00004000	/* IRQ level triggered */
+#define IRQ_MASKED		0x00008000	/* IRQ masked - shouldn't be seen again */
+#define IRQ_PER_CPU		0x00010000	/* IRQ is per CPU */
+#define IRQ_NOPROBE		0x00020000	/* IRQ is not valid for probing */
+#define IRQ_NOREQUEST		0x00040000	/* IRQ cannot be requested */
+#define IRQ_NOAUTOEN		0x00080000	/* IRQ will not be enabled on request irq */
+#define IRQ_DELAYED_DISABLE	0x00100000	/* IRQ disable (masking) happens delayed. */
+#define IRQ_WAKEUP		0x00200000	/* IRQ triggers system wakeup */
+#define IRQ_MOVE_PENDING	0x00400000	/* need to re-target IRQ destination */
+#define IRQ_NO_BALANCING	0x00800000	/* IRQ is excluded from balancing */
+
 #ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
+# define IRQ_NO_BALANCING_MASK	(IRQ_PER_CPU | IRQ_NO_BALANCING)
 #else
 # define CHECK_IRQ_PER_CPU(var) 0
+# define IRQ_NO_BALANCING_MASK	IRQ_NO_BALANCING
 #endif
 
-#define IRQ_NOPROBE		0x02000000	/* IRQ is not valid for probing */
-#define IRQ_NOREQUEST		0x04000000	/* IRQ cannot be requested */
-#define IRQ_NOAUTOEN		0x08000000	/* IRQ will not be enabled on request irq */
-#define IRQ_DELAYED_DISABLE	0x10000000	/* IRQ disable (masking) happens delayed. */
-#define IRQ_WAKEUP		0x20000000	/* IRQ triggers system wakeup */
-#define IRQ_MOVE_PENDING	0x40000000	/* need to re-target IRQ destination */
+static inline int irq_balancing_disabled(unsigned int irq)
+{
+	return irq_desc[irq].status & IRQ_NO_BALANCING_MASK;
+}
 
 struct proc_dir_entry;
 
Index: linux-2.6.20-rc4-mm1-bo/kernel/irq/manage.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/irq/manage.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/irq/manage.c
@@ -281,6 +281,10 @@ int setup_irq(unsigned int irq, struct i
 	if (new->flags & IRQF_PERCPU)
 		desc->status |= IRQ_PER_CPU;
 #endif
+	/* Exclude IRQ from balancing */
+	if (new->flags & IRQF_NOBALANCING)
+		desc->status |= IRQ_NO_BALANCING;
+
 	if (!shared) {
 		irq_chip_set_defaults(desc->chip);
 
Index: linux-2.6.20-rc4-mm1-bo/kernel/irq/proc.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/irq/proc.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/irq/proc.c
@@ -55,7 +55,7 @@ static int irq_affinity_write_proc(struc
 	cpumask_t new_value, tmp;
 
 	if (!irq_desc[irq].chip->set_affinity || no_irq_affinity ||
-				CHECK_IRQ_PER_CPU(irq_desc[irq].status))
+	    irq_balancing_disabled(irq))
 		return -EIO;
 
 	err = cpumask_parse_user(buffer, count, new_value);

--

