Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbYE2I5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbYE2I5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbYE2I4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:56:04 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17910 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbYE2Iz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:55:56 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, npiggin@suse.de, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
       Jens Axboe <jens.axboe@oracle.com>, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 8/10] mips: convert to generic helpers for IPI function calls
Date: Thu, 29 May 2008 10:58:22 +0200
Message-Id: <1212051504-12561-9-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.6.rc0.40.gd683
In-Reply-To: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com>
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts mips to use the new helpers for smp_call_function() and
friends, and adds support for smp_call_function_single(). Not tested,
but it compiles.

mips shares the same IPI for smp_call_function() and
smp_call_function_single(), since not all hardware has enough available
IPIs available to support seperate setups.

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/mips/Kconfig       |    1 +
 arch/mips/kernel/smp.c  |  139 ++++-------------------------------------------
 arch/mips/kernel/smtc.c |    1 -
 include/asm-mips/smp.h  |   10 ----
 4 files changed, 12 insertions(+), 139 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index e5a7c5d..ea70d5a 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1763,6 +1763,7 @@ config SMP
 	bool "Multi-Processing support"
 	depends on SYS_SUPPORTS_SMP
 	select IRQ_PER_CPU
+	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 63370cd..c75b26c 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -131,145 +131,28 @@ asmlinkage __cpuinit void start_secondary(void)
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
+/*
+ * We reuse the same vector for the single IPI
+ */
+void arch_send_call_function_single_ipi(int cpu)
 {
-	return smp_call_function_mask(cpu_online_map, func, info, retry, wait);
+	mp_ops->send_ipi_mask(cpumask_of_cpu(cpu), SMP_CALL_FUNCTION);
 }
 
+/*
+ * Call into both interrupt handlers, as we share the IPI for them
+ */
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
+	generic_smp_call_function_single_interrupt();
+	generic_smp_call_function_interrupt();
 	irq_exit();
-
-	if (wait) {
-		smp_mb();
-		atomic_inc(&call_data->finished);
-	}
-}
-
-int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-			     int retry, int wait)
-{
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
 }
 
 static void stop_this_cpu(void *dummy)
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index 3e86318..a516286 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -877,7 +877,6 @@ static void ipi_resched_interrupt(void)
 	/* Return from interrupt should be enough to cause scheduler check */
 }
 
-
 static void ipi_call_interrupt(void)
 {
 	/* Invoke generic function invocation code in smp.c */
diff --git a/include/asm-mips/smp.h b/include/asm-mips/smp.h
index 84fef1a..5222587 100644
--- a/include/asm-mips/smp.h
+++ b/include/asm-mips/smp.h
@@ -35,16 +35,6 @@ extern int __cpu_logical_map[NR_CPUS];
 
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
 
-- 
1.5.6.rc0.40.gd683

