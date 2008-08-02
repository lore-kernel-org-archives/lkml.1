Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbYHBA1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbYHBA1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 20:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYHBAZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 20:25:14 -0400
Received: from c-98-210-159-26.hsd1.ca.comcast.net ([98.210.159.26]:46993 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752085AbYHBAZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 20:25:05 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 5 of 8] smp_function_call: add multiple queues for scalability
X-Mercurial-Node: e65580c39ebd03ebb0188b59df9c185dc9805d7e
Message-Id: <e65580c39ebd03ebb018.1217636090@localhost>
In-Reply-To: <patchbomb.1217636085@localhost>
Date: Fri, 01 Aug 2008 17:14:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows an architecture to have multiple smp_call_function
queues, in order to reduce contention on a single queue and lock.  By
default there is still one queue, so this patch makes no functional
change.

However, an architecture can set CONFIG_GENERIC_SMP_QUEUES to enable a
certain number of queues.  It's expected it will will set up an IPI
vector for each queue, and it should pass the appropriate queue number
into generic_smp_call_function_interrupt.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/alpha/kernel/smp.c             |    2 -
 arch/arm/kernel/smp.c               |    2 -
 arch/ia64/kernel/smp.c              |    2 -
 arch/m32r/kernel/smp.c              |    2 -
 arch/mips/kernel/smp.c              |    2 -
 arch/parisc/kernel/smp.c            |    2 -
 arch/powerpc/kernel/smp.c           |    2 -
 arch/sparc64/kernel/smp.c           |    2 -
 arch/x86/kernel/smp.c               |    2 -
 arch/x86/mach-voyager/voyager_smp.c |    2 -
 arch/x86/xen/smp.c                  |    2 -
 include/linux/smp.h                 |    2 -
 kernel/smp.c                        |   70 ++++++++++++++++++++++++++++-------
 13 files changed, 69 insertions(+), 25 deletions(-)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -588,7 +588,7 @@
 			break;
 
 		case IPI_CALL_FUNC:
-			generic_smp_call_function_interrupt();
+			generic_smp_call_function_interrupt(0);
 			break;
 
 		case IPI_CALL_FUNC_SINGLE:
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -481,7 +481,7 @@
 				break;
 
 			case IPI_CALL_FUNC:
-				generic_smp_call_function_interrupt();
+				generic_smp_call_function_interrupt(0);
 				break;
 
 			case IPI_CALL_FUNC_SINGLE:
diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
--- a/arch/ia64/kernel/smp.c
+++ b/arch/ia64/kernel/smp.c
@@ -114,7 +114,7 @@
 				stop_this_cpu();
 				break;
 			case IPI_CALL_FUNC:
-				generic_smp_call_function_interrupt();
+				generic_smp_call_function_interrupt(0);
 				break;
 			case IPI_CALL_FUNC_SINGLE:
 				generic_smp_call_function_single_interrupt();
diff --git a/arch/m32r/kernel/smp.c b/arch/m32r/kernel/smp.c
--- a/arch/m32r/kernel/smp.c
+++ b/arch/m32r/kernel/smp.c
@@ -576,7 +576,7 @@
 void smp_call_function_interrupt(void)
 {
 	irq_enter();
-	generic_smp_call_function_interrupt();
+	generic_smp_call_function_interrupt(0);
 	irq_exit();
 }
 
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -151,7 +151,7 @@
 {
 	irq_enter();
 	generic_smp_call_function_single_interrupt();
-	generic_smp_call_function_interrupt();
+	generic_smp_call_function_interrupt(0);
 	irq_exit();
 }
 
diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -179,7 +179,7 @@
 
 			case IPI_CALL_FUNC:
 				smp_debug(100, KERN_DEBUG "CPU%d IPI_CALL_FUNC\n", this_cpu);
-				generic_smp_call_function_interrupt();
+				generic_smp_call_function_interrupt(0);
 				break;
 
 			case IPI_CALL_FUNC_SINGLE:
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -98,7 +98,7 @@
 {
 	switch(msg) {
 	case PPC_MSG_CALL_FUNCTION:
-		generic_smp_call_function_interrupt();
+		generic_smp_call_function_interrupt(0);
 		break;
 	case PPC_MSG_RESCHEDULE:
 		/* XXX Do we have to do this? */
diff --git a/arch/sparc64/kernel/smp.c b/arch/sparc64/kernel/smp.c
--- a/arch/sparc64/kernel/smp.c
+++ b/arch/sparc64/kernel/smp.c
@@ -811,7 +811,7 @@
 void smp_call_function_client(int irq, struct pt_regs *regs)
 {
 	clear_softint(1 << irq);
-	generic_smp_call_function_interrupt();
+	generic_smp_call_function_interrupt(0);
 }
 
 void smp_call_function_single_client(int irq, struct pt_regs *regs)
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -189,7 +189,7 @@
 {
 	ack_APIC_irq();
 	irq_enter();
-	generic_smp_call_function_interrupt();
+	generic_smp_call_function_interrupt(0);
 #ifdef CONFIG_X86_32
 	__get_cpu_var(irq_stat).irq_call_count++;
 #else
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -957,7 +957,7 @@
 static void smp_call_function_interrupt(void)
 {
 	irq_enter();
-	generic_smp_call_function_interrupt();
+	generic_smp_call_function_interrupt(0);
 	__get_cpu_var(irq_stat).irq_call_count++;
 	irq_exit();
 }
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -391,7 +391,7 @@
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
 {
 	irq_enter();
-	generic_smp_call_function_interrupt();
+	generic_smp_call_function_interrupt(0);
 #ifdef CONFIG_X86_32
 	__get_cpu_var(irq_stat).irq_call_count++;
 #else
diff --git a/include/linux/smp.h b/include/linux/smp.h
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -73,7 +73,7 @@
  */
 #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 void generic_smp_call_function_single_interrupt(void);
-void generic_smp_call_function_interrupt(void);
+void generic_smp_call_function_interrupt(unsigned queue);
 void ipi_call_lock(void);
 void ipi_call_unlock(void);
 void ipi_call_lock_irq(void);
diff --git a/kernel/smp.c b/kernel/smp.c
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -11,9 +11,19 @@
 #include <linux/rculist.h>
 #include <linux/smp.h>
 
+#ifdef CONFIG_GENERIC_SMP_QUEUES
+#define	NQUEUES	CONFIG_GENERIC_SMP_QUEUES
+#else
+#define	NQUEUES	1
+#endif
+
 static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
-static LIST_HEAD(call_function_queue);
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(call_function_lock);
+struct ____cacheline_aligned queue {
+	struct list_head list;
+	spinlock_t lock;
+};
+
+static __cacheline_aligned struct queue call_function_queues[NQUEUES];
 
 enum {
 	CSD_FLAG_WAIT		= 0x01,
@@ -96,17 +106,20 @@
  * Invoked by arch to handle an IPI for call function. Must be called with
  * interrupts disabled.
  */
-void generic_smp_call_function_interrupt(void)
+void generic_smp_call_function_interrupt(unsigned queue_no)
 {
 	struct call_function_data *data;
+	struct queue *queue;
 	int cpu = get_cpu();
+
+	queue = &call_function_queues[queue_no];
 
 	/*
 	 * It's ok to use list_for_each_rcu() here even though we may delete
 	 * 'pos', since list_del_rcu() doesn't clear ->next
 	 */
 	rcu_read_lock();
-	list_for_each_entry_rcu(data, &call_function_queue, csd.list) {
+	list_for_each_entry_rcu(data, &queue->list, csd.list) {
 		int refs;
 
 		if (!cpu_isset(cpu, data->cpumask))
@@ -124,9 +137,9 @@
 		if (refs)
 			continue;
 
-		spin_lock(&call_function_lock);
+		spin_lock(&queue->lock);
 		list_del_rcu(&data->csd.list);
-		spin_unlock(&call_function_lock);
+		spin_unlock(&queue->lock);
 
 		if (data->csd.flags & CSD_FLAG_WAIT) {
 			/*
@@ -285,6 +298,8 @@
 	cpumask_t allbutself;
 	unsigned long flags;
 	int cpu, num_cpus;
+	unsigned queue_no;
+	struct queue *queue;
 
 	/* Can deadlock when called with interrupts disabled */
 	WARN_ON(irqs_disabled());
@@ -294,6 +309,9 @@
 	cpu_clear(cpu, allbutself);
 	cpus_and(mask, mask, allbutself);
 	num_cpus = cpus_weight(mask);
+
+	queue_no = cpu % NQUEUES;
+	queue = &call_function_queues[queue_no];
 
 	/*
 	 * If zero CPUs, return. If just a single CPU, turn this request
@@ -323,9 +341,9 @@
 	data->refs = num_cpus;
 	data->cpumask = mask;
 
-	spin_lock_irqsave(&call_function_lock, flags);
-	list_add_tail_rcu(&data->csd.list, &call_function_queue);
-	spin_unlock_irqrestore(&call_function_lock, flags);
+	spin_lock_irqsave(&queue->lock, flags);
+	list_add_tail_rcu(&data->csd.list, &queue->list);
+	spin_unlock_irqrestore(&queue->lock, flags);
 
 	/* Send a message to all CPUs in the map */
 	arch_send_call_function_ipi(mask);
@@ -366,20 +384,46 @@
 
 void ipi_call_lock(void)
 {
-	spin_lock(&call_function_lock);
+	int i;
+
+	for(i = 0; i < NQUEUES; i++)
+		spin_lock(&call_function_queues[i].lock);
 }
 
 void ipi_call_unlock(void)
 {
-	spin_unlock(&call_function_lock);
+	int i;
+
+	for(i = 0; i < NQUEUES; i++)
+		spin_unlock(&call_function_queues[i].lock);
 }
 
 void ipi_call_lock_irq(void)
 {
-	spin_lock_irq(&call_function_lock);
+	int i;
+
+	for(i = 0; i < NQUEUES; i++)
+		spin_lock_irq(&call_function_queues[i].lock);
 }
 
 void ipi_call_unlock_irq(void)
 {
-	spin_unlock_irq(&call_function_lock);
+	int i;
+
+	for(i = 0; i < NQUEUES; i++)
+		spin_unlock_irq(&call_function_queues[i].lock);
 }
+
+
+static int __init init_smp_function_call(void)
+{
+	int i;
+
+	for(i = 0; i < NQUEUES; i++) {
+		INIT_LIST_HEAD(&call_function_queues[i].list);
+		spin_lock_init(&call_function_queues[i].lock);
+	}
+
+	return 0;
+}
+early_initcall(init_smp_function_call);


