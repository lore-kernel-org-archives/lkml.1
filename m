Return-Path: <linux-kernel-owner+w=401wt.eu-S1759686AbYD2H0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686AbYD2H0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 03:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbYD2HZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 03:25:46 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17203 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbYD2HZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 03:25:43 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, npiggin@suse.de, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
       Jens Axboe <jens.axboe@oracle.com>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 4/10] ia64: convert to generic helpers for IPI function calls
Date: Tue, 29 Apr 2008 09:26:24 +0200
Message-Id: <1209453990-7735-5-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.5.1.57.g5909c
In-Reply-To: <1209453990-7735-1-git-send-email-jens.axboe@oracle.com>
References: <1209453990-7735-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts ia64 to use the new helpers for smp_call_function() and
friends, and adds support for smp_call_function_single().

Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/ia64/Kconfig      |    1 +
 arch/ia64/kernel/smp.c |  239 +++---------------------------------------------
 include/asm-ia64/smp.h |    3 -
 3 files changed, 16 insertions(+), 227 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 3aa6c82..9e1e115 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -286,6 +286,7 @@ config VIRT_CPU_ACCOUNTING
 
 config SMP
 	bool "Symmetric multi-processing support"
+	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, say N.  If you have a system with more
diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
index 9a9d4c4..c5dcd03 100644
--- a/arch/ia64/kernel/smp.c
+++ b/arch/ia64/kernel/smp.c
@@ -60,25 +60,9 @@ static struct local_tlb_flush_counts {
 
 static DEFINE_PER_CPU(unsigned int, shadow_flush_counts[NR_CPUS]) ____cacheline_aligned;
 
-
-/*
- * Structure and data for smp_call_function(). This is designed to minimise static memory
- * requirements. It also looks cleaner.
- */
-static  __cacheline_aligned DEFINE_SPINLOCK(call_lock);
-
-struct call_data_struct {
-	void (*func) (void *info);
-	void *info;
-	long wait;
-	atomic_t started;
-	atomic_t finished;
-};
-
-static volatile struct call_data_struct *call_data;
-
 #define IPI_CALL_FUNC		0
 #define IPI_CPU_STOP		1
+#define IPI_CALL_FUNC_SINGLE	2
 #define IPI_KDUMP_CPU_STOP	3
 
 /* This needs to be cacheline aligned because it is written to by *other* CPUs.  */
@@ -89,13 +73,13 @@ extern void cpu_halt (void);
 void
 lock_ipi_calllock(void)
 {
-	spin_lock_irq(&call_lock);
+	spin_lock_irq(&call_function_lock);
 }
 
 void
 unlock_ipi_calllock(void)
 {
-	spin_unlock_irq(&call_lock);
+	spin_unlock_irq(&call_function_lock);
 }
 
 static void
@@ -139,32 +123,12 @@ handle_IPI (int irq, void *dev_id)
 
 			switch (which) {
 			      case IPI_CALL_FUNC:
-			      {
-				      struct call_data_struct *data;
-				      void (*func)(void *info);
-				      void *info;
-				      int wait;
-
-				      /* release the 'pointer lock' */
-				      data = (struct call_data_struct *) call_data;
-				      func = data->func;
-				      info = data->info;
-				      wait = data->wait;
-
-				      mb();
-				      atomic_inc(&data->started);
-				      /*
-				       * At this point the structure may be gone unless
-				       * wait is true.
-				       */
-				      (*func)(info);
-
-				      /* Notify the sending CPU that the task is done.  */
-				      mb();
-				      if (wait)
-					      atomic_inc(&data->finished);
-			      }
-			      break;
+				generic_smp_call_function_interrupt();
+				break;
+
+			      case IPI_CALL_FUNC_SINGLE:
+				generic_smp_call_function_single_interrupt();
+				break;
 
 			      case IPI_CPU_STOP:
 				stop_this_cpu();
@@ -185,6 +149,8 @@ handle_IPI (int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+
+
 /*
  * Called with preemption disabled.
  */
@@ -358,190 +324,15 @@ smp_flush_tlb_mm (struct mm_struct *mm)
 	on_each_cpu((void (*)(void *))local_finish_flush_tlb_mm, mm, 1, 1);
 }
 
-/*
- * Run a function on a specific CPU
- *  <func>	The function to run. This must be fast and non-blocking.
- *  <info>	An arbitrary pointer to pass to the function.
- *  <nonatomic>	Currently unused.
- *  <wait>	If true, wait until function has completed on other CPUs.
- *  [RETURNS]   0 on success, else a negative status code.
- *
- * Does not return until the remote CPU is nearly ready to execute <func>
- * or is or has executed.
- */
-
-int
-smp_call_function_single (int cpuid, void (*func) (void *info), void *info, int nonatomic,
-			  int wait)
-{
-	struct call_data_struct data;
-	int cpus = 1;
-	int me = get_cpu(); /* prevent preemption and reschedule on another processor */
-
-	if (cpuid == me) {
-		local_irq_disable();
-		func(info);
-		local_irq_enable();
-		put_cpu();
-		return 0;
-	}
-
-	data.func = func;
-	data.info = info;
-	atomic_set(&data.started, 0);
-	data.wait = wait;
-	if (wait)
-		atomic_set(&data.finished, 0);
-
-	spin_lock_bh(&call_lock);
-
-	call_data = &data;
-	mb();	/* ensure store to call_data precedes setting of IPI_CALL_FUNC */
-  	send_IPI_single(cpuid, IPI_CALL_FUNC);
-
-	/* Wait for response */
-	while (atomic_read(&data.started) != cpus)
-		cpu_relax();
-
-	if (wait)
-		while (atomic_read(&data.finished) != cpus)
-			cpu_relax();
-	call_data = NULL;
-
-	spin_unlock_bh(&call_lock);
-	put_cpu();
-	return 0;
-}
-EXPORT_SYMBOL(smp_call_function_single);
-
-/**
- * smp_call_function_mask(): Run a function on a set of other CPUs.
- * <mask>	The set of cpus to run on.  Must not include the current cpu.
- * <func> 	The function to run. This must be fast and non-blocking.
- * <info>	An arbitrary pointer to pass to the function.
- * <wait>	If true, wait (atomically) until function
- *		has completed on other CPUs.
- *
- * Returns 0 on success, else a negative status code.
- *
- * If @wait is true, then returns once @func has returned; otherwise
- * it returns just before the target cpu calls @func.
- *
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
- */
-int smp_call_function_mask(cpumask_t mask,
-			   void (*func)(void *), void *info,
-			   int wait)
+void arch_send_call_function_single_ipi(int cpu)
 {
-	struct call_data_struct data;
-	cpumask_t allbutself;
-	int cpus;
-
-	spin_lock(&call_lock);
-	allbutself = cpu_online_map;
-	cpu_clear(smp_processor_id(), allbutself);
-
-	cpus_and(mask, mask, allbutself);
-	cpus = cpus_weight(mask);
-	if (!cpus) {
-		spin_unlock(&call_lock);
-		return 0;
-	}
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
-	call_data = &data;
-	mb(); /* ensure store to call_data precedes setting of IPI_CALL_FUNC*/
-
-	/* Send a message to other CPUs */
-	if (cpus_equal(mask, allbutself))
-		send_IPI_allbutself(IPI_CALL_FUNC);
-	else
-		send_IPI_mask(mask, IPI_CALL_FUNC);
-
-	/* Wait for response */
-	while (atomic_read(&data.started) != cpus)
-		cpu_relax();
-
-	if (wait)
-		while (atomic_read(&data.finished) != cpus)
-			cpu_relax();
-	call_data = NULL;
-
-	spin_unlock(&call_lock);
-	return 0;
-
+	send_IPI_single(cpu, IPI_CALL_FUNC_SINGLE);
 }
-EXPORT_SYMBOL(smp_call_function_mask);
 
-/*
- * this function sends a 'generic call function' IPI to all other CPUs
- * in the system.
- */
-
-/*
- *  [SUMMARY]	Run a function on all other CPUs.
- *  <func>	The function to run. This must be fast and non-blocking.
- *  <info>	An arbitrary pointer to pass to the function.
- *  <nonatomic>	currently unused.
- *  <wait>	If true, wait (atomically) until function has completed on other CPUs.
- *  [RETURNS]   0 on success, else a negative status code.
- *
- * Does not return until remote CPUs are nearly ready to execute <func> or are or have
- * executed.
- *
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
- */
-int
-smp_call_function (void (*func) (void *info), void *info, int nonatomic, int wait)
+void arch_send_call_function_ipi(cpumask_t mask)
 {
-	struct call_data_struct data;
-	int cpus;
-
-	spin_lock(&call_lock);
-	cpus = num_online_cpus() - 1;
-	if (!cpus) {
-		spin_unlock(&call_lock);
-		return 0;
-	}
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
-	call_data = &data;
-	mb();	/* ensure store to call_data precedes setting of IPI_CALL_FUNC */
-	send_IPI_allbutself(IPI_CALL_FUNC);
-
-	/* Wait for response */
-	while (atomic_read(&data.started) != cpus)
-		cpu_relax();
-
-	if (wait)
-		while (atomic_read(&data.finished) != cpus)
-			cpu_relax();
-	call_data = NULL;
-
-	spin_unlock(&call_lock);
-	return 0;
+	send_IPI_mask(mask, IPI_CALL_FUNC);
 }
-EXPORT_SYMBOL(smp_call_function);
 
 /*
  * this function calls the 'stop' function on all other CPUs in the system.
diff --git a/include/asm-ia64/smp.h b/include/asm-ia64/smp.h
index ec5f355..4fa733d 100644
--- a/include/asm-ia64/smp.h
+++ b/include/asm-ia64/smp.h
@@ -38,9 +38,6 @@ ia64_get_lid (void)
 	return lid.f.id << 8 | lid.f.eid;
 }
 
-extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
-				  void *info, int wait);
-
 #define hard_smp_processor_id()		ia64_get_lid()
 
 #ifdef CONFIG_SMP
-- 
1.5.5.1.57.g5909c

