Return-Path: <linux-kernel-owner+w=401wt.eu-S1762296AbYDVIAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762296AbYDVIAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 04:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757248AbYDVH51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 03:57:27 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26337 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405AbYDVH5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 03:57:10 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: npiggin@suse.de, torvalds@linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 8/11] mips: convert to generic helpers for IPI function calls
Date: Tue, 22 Apr 2008 09:57:34 +0200
Message-Id: <1208851058-8500-9-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.5.1.57.g5909c
In-Reply-To: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts mips to use the new helpers for smp_call_function() and
friends, and adds support for smp_call_function_single(). Not tested,
but it compiles.

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/mips/Kconfig              |    5 ++
 arch/mips/kernel/smp-mt.c      |   27 ++++++++-
 arch/mips/kernel/smp.c         |  133 +++-------------------------------------
 arch/mips/kernel/smtc.c        |    7 ++
 arch/mips/sibyte/bcm1480/smp.c |    3 +
 arch/mips/sibyte/sb1250/smp.c  |    2 +
 include/asm-mips/smp.h         |   12 +---
 7 files changed, 53 insertions(+), 136 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 8724ed3..6fdf0f1 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1669,6 +1669,11 @@ config GENERIC_IRQ_PROBE
 	bool
 	default y
 
+config GENERIC_SMP_HELPERS
+	bool
+	depends on SMP
+	default y
+
 config IRQ_PER_CPU
 	bool
 
diff --git a/arch/mips/kernel/smp-mt.c b/arch/mips/kernel/smp-mt.c
index 89e6f6a..31049fc 100644
--- a/arch/mips/kernel/smp-mt.c
+++ b/arch/mips/kernel/smp-mt.c
@@ -38,8 +38,9 @@
 
 #define MIPS_CPU_IPI_RESCHED_IRQ 0
 #define MIPS_CPU_IPI_CALL_IRQ 1
+#define MIPS_CPU_IPI_CALL_SINGLE_IRQ 2
 
-static int cpu_ipi_resched_irq, cpu_ipi_call_irq;
+static int cpu_ipi_resched_irq, cpu_ipi_call_irq, cpu_ipi_call_single_irq;
 
 #if 0
 static void dump_mtregisters(int vpe, int tc)
@@ -115,6 +116,11 @@ static void ipi_call_dispatch(void)
 	do_IRQ(MIPS_CPU_IRQ_BASE + MIPS_CPU_IPI_CALL_IRQ);
 }
 
+static void ipi_call_single_dispatch(void)
+{
+	do_IRQ(MIPS_CPU_IRQ_BASE + MIPS_CPU_IPI_CALL_SINGLE_IRQ);
+}
+
 static irqreturn_t ipi_resched_interrupt(int irq, void *dev_id)
 {
 	return IRQ_HANDLED;
@@ -127,6 +133,13 @@ static irqreturn_t ipi_call_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t ipi_call_single_interrupt(int irq, void *dev_id)
+{
+	smp_call_function_single_interrupt();
+
+	return IRQ_HANDLED;
+}
+
 static struct irqaction irq_resched = {
 	.handler	= ipi_resched_interrupt,
 	.flags		= IRQF_DISABLED|IRQF_PERCPU,
@@ -139,6 +152,12 @@ static struct irqaction irq_call = {
 	.name		= "IPI_call"
 };
 
+static struct irqaction irq_call_single = {
+	.handler	= ipi_call_single_interrupt,
+	.flags		= IRQF_DISABLED|IRQF_PERCPU,
+	.name		= "IPI_call_single"
+};
+
 static void __init smp_copy_vpe_config(void)
 {
 	write_vpe_c0_status(
@@ -376,16 +395,22 @@ static void __init vsmp_prepare_cpus(unsigned int max_cpus)
 	if (cpu_has_vint) {
 		set_vi_handler(MIPS_CPU_IPI_RESCHED_IRQ, ipi_resched_dispatch);
 		set_vi_handler(MIPS_CPU_IPI_CALL_IRQ, ipi_call_dispatch);
+		set_vi_handler(MIPS_CPU_IPI_CALL_SINGLE_IRQ,
+					ipi_call_single_dispatch);
 	}
 
 	cpu_ipi_resched_irq = MIPS_CPU_IRQ_BASE + MIPS_CPU_IPI_RESCHED_IRQ;
 	cpu_ipi_call_irq = MIPS_CPU_IRQ_BASE + MIPS_CPU_IPI_CALL_IRQ;
+	cpu_ipi_call_single_irq = MIPS_CPU_IRQ_BASE +
+						MIPS_CPU_IPI_CALL_SINGLE_IRQ;
 
 	setup_irq(cpu_ipi_resched_irq, &irq_resched);
 	setup_irq(cpu_ipi_call_irq, &irq_call);
+	setup_irq(cpu_ipi_call_single_irq, &irq_call_single);
 
 	set_irq_handler(cpu_ipi_resched_irq, handle_percpu_irq);
 	set_irq_handler(cpu_ipi_call_irq, handle_percpu_irq);
+	set_irq_handler(cpu_ipi_call_single_irq, handle_percpu_irq);
 }
 
 struct plat_smp_ops vsmp_smp_ops = {
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 9d41dab..931c0d9 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -128,145 +128,28 @@ asmlinkage __cpuinit void start_secondary(void)
 	cpu_idle();
 }
 
-DEFINE_SPINLOCK(smp_call_lock);
-
-struct call_data_struct *call_data;
-
-/*
- * Run a function on all other CPUs.
- *
- *  <mask>	cpuset_t of all processors to run the function on.
- *  <func>      The function to run. This must be fast and non-blocking.
- *  <info>      An arbitrary pointer to pass to the function.
- *  <retry>     If true, keep retrying until ready.
- *  <wait>      If true, wait until function has completed on other CPUs.
- *  [RETURNS]   0 on success, else a negative status code.
- *
- * Does not return until remote CPUs are nearly ready to execute <func>
- * or are or have executed.
- *
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler:
- *
- * CPU A                               CPU B
- * Disable interrupts
- *                                     smp_call_function()
- *                                     Take call_lock
- *                                     Send IPIs
- *                                     Wait for all cpus to acknowledge IPI
- *                                     CPU A has not responded, spin waiting
- *                                     for cpu A to respond, holding call_lock
- * smp_call_function()
- * Spin waiting for call_lock
- * Deadlock                            Deadlock
- */
-int smp_call_function_mask(cpumask_t mask, void (*func) (void *info),
-	void *info, int retry, int wait)
+void arch_send_call_function_ipi(cpumask_t mask)
 {
-	struct call_data_struct data;
-	int cpu = smp_processor_id();
-	int cpus;
-
-	/*
-	 * Can die spectacularly if this CPU isn't yet marked online
-	 */
-	BUG_ON(!cpu_online(cpu));
-
-	cpu_clear(cpu, mask);
-	cpus = cpus_weight(mask);
-	if (!cpus)
-		return 0;
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	data.func = func;
-	data.info = info;
-	atomic_set(&data.started, 0);
-	data.wait = wait;
-	if (wait)
-		atomic_set(&data.finished, 0);
-
-	spin_lock(&smp_call_lock);
-	call_data = &data;
-	smp_mb();
-
-	/* Send a message to all other CPUs and wait for them to respond */
 	mp_ops->send_ipi_mask(mask, SMP_CALL_FUNCTION);
-
-	/* Wait for response */
-	/* FIXME: lock-up detection, backtrace on lock-up */
-	while (atomic_read(&data.started) != cpus)
-		barrier();
-
-	if (wait)
-		while (atomic_read(&data.finished) != cpus)
-			barrier();
-	call_data = NULL;
-	spin_unlock(&smp_call_lock);
-
-	return 0;
 }
 
-int smp_call_function(void (*func) (void *info), void *info, int retry,
-	int wait)
+void arch_send_call_function_single_ipi(int cpu)
 {
-	return smp_call_function_mask(cpu_online_map, func, info, retry, wait);
+	mp_ops->send_ipi_mask(cpumask_of_cpu(cpu), SMP_CALL_FUNCTION_SINGLE);
 }
 
 void smp_call_function_interrupt(void)
 {
-	void (*func) (void *info) = call_data->func;
-	void *info = call_data->info;
-	int wait = call_data->wait;
-
-	/*
-	 * Notify initiating CPU that I've grabbed the data and am
-	 * about to execute the function.
-	 */
-	smp_mb();
-	atomic_inc(&call_data->started);
-
-	/*
-	 * At this point the info structure may be out of scope unless wait==1.
-	 */
 	irq_enter();
-	(*func)(info);
+	generic_smp_call_function_interrupt();
 	irq_exit();
-
-	if (wait) {
-		smp_mb();
-		atomic_inc(&call_data->finished);
-	}
 }
 
-int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-			     int retry, int wait)
+void smp_call_function_single_interrupt(void)
 {
-	int ret, me;
-
-	/*
-	 * Can die spectacularly if this CPU isn't yet marked online
-	 */
-	if (!cpu_online(cpu))
-		return 0;
-
-	me = get_cpu();
-	BUG_ON(!cpu_online(me));
-
-	if (cpu == me) {
-		local_irq_disable();
-		func(info);
-		local_irq_enable();
-		put_cpu();
-		return 0;
-	}
-
-	ret = smp_call_function_mask(cpumask_of_cpu(cpu), func, info, retry,
-				     wait);
-
-	put_cpu();
-	return 0;
+	irq_enter();
+	generic_smp_call_function_single_interrupt();
+	irq_exit();
 }
 
 static void stop_this_cpu(void *dummy)
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index b42e71c..434605f 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -884,6 +884,10 @@ static void ipi_resched_interrupt(void)
 	/* Return from interrupt should be enough to cause scheduler check */
 }
 
+static void ipi_call_single_interrupt(void)
+{
+	smp_call_function_single_interrupt();
+}
 
 static void ipi_call_interrupt(void)
 {
@@ -924,6 +928,9 @@ void ipi_decode(struct smtc_ipi *pipi)
 		case SMP_CALL_FUNCTION:
 			ipi_call_interrupt();
 			break;
+		case SMP_CALL_FUNCTION_SINGLE:
+			ipi_call_single_interrupt();
+			break;
 		default:
 			printk("Impossible SMTC IPI Argument 0x%x\n",
 				(int)arg_copy);
diff --git a/arch/mips/sibyte/bcm1480/smp.c b/arch/mips/sibyte/bcm1480/smp.c
index bd9eeb4..76d36ff 100644
--- a/arch/mips/sibyte/bcm1480/smp.c
+++ b/arch/mips/sibyte/bcm1480/smp.c
@@ -29,6 +29,7 @@
 #include <asm/sibyte/bcm1480_int.h>
 
 extern void smp_call_function_interrupt(void);
+extern void smp_call_function_single_interrupt(void);
 
 /*
  * These are routines for dealing with the bcm1480 smp capabilities
@@ -194,4 +195,6 @@ void bcm1480_mailbox_interrupt(void)
 
 	if (action & SMP_CALL_FUNCTION)
 		smp_call_function_interrupt();
+	else if (action & SMP_CALL_FUNCTION_SINGLE)
+		smp_call_function_single_interrupt();
 }
diff --git a/arch/mips/sibyte/sb1250/smp.c b/arch/mips/sibyte/sb1250/smp.c
index 0734b93..8742127 100644
--- a/arch/mips/sibyte/sb1250/smp.c
+++ b/arch/mips/sibyte/sb1250/smp.c
@@ -182,4 +182,6 @@ void sb1250_mailbox_interrupt(void)
 
 	if (action & SMP_CALL_FUNCTION)
 		smp_call_function_interrupt();
+	else if (action & SMP_CALL_FUNCTION_SINGLE)
+		smp_call_function_single_interrupt();
 }
diff --git a/include/asm-mips/smp.h b/include/asm-mips/smp.h
index 84fef1a..d35c0ad 100644
--- a/include/asm-mips/smp.h
+++ b/include/asm-mips/smp.h
@@ -35,18 +35,9 @@ extern int __cpu_logical_map[NR_CPUS];
 
 #define NO_PROC_ID	(-1)
 
-struct call_data_struct {
-	void		(*func)(void *);
-	void		*info;
-	atomic_t	started;
-	atomic_t	finished;
-	int		wait;
-};
-
-extern struct call_data_struct *call_data;
-
 #define SMP_RESCHEDULE_YOURSELF	0x1	/* XXX braindead */
 #define SMP_CALL_FUNCTION	0x2
+#define SMP_CALL_FUNCTION_SINGLE	0x4
 
 extern cpumask_t phys_cpu_present_map;
 #define cpu_possible_map	phys_cpu_present_map
@@ -66,5 +57,6 @@ static inline void smp_send_reschedule(int cpu)
 }
 
 extern asmlinkage void smp_call_function_interrupt(void);
+extern asmlinkage void smp_call_function_single_interrupt(void);
 
 #endif /* __ASM_SMP_H */
-- 
1.5.5.49.gf43e2

