Return-Path: <linux-kernel-owner+w=401wt.eu-S1761725AbYCSUok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761725AbYCSUok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbYCSToG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:44:06 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26270 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758254AbYCSToA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:44:00 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: npiggin@suse.de, paulus@samba.org, tglx@linutronix.de, mingo@redhat.com,
       tony.luck@intel.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 5/5] ia64: convert to generic helpers for IPI function calls
Date: Wed, 19 Mar 2008 12:56:12 +0100
Message-Id: <1205927772-31401-6-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com>
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts ia64 to use the new helpers for smp_call_function() and
frieds, and adds support for smp_call_function_single().

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/ia64/kernel/smp.c |  171 +++++++++++++-----------------------------------
 1 files changed, 45 insertions(+), 126 deletions(-)

diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
index 4e446aa..fa26528 100644
--- a/arch/ia64/kernel/smp.c
+++ b/arch/ia64/kernel/smp.c
@@ -61,24 +61,9 @@ static struct local_tlb_flush_counts {
 static DEFINE_PER_CPU(unsigned int, shadow_flush_counts[NR_CPUS]) ____cacheline_aligned;
 
 
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
@@ -89,13 +74,13 @@ extern void cpu_halt (void);
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
@@ -139,32 +124,11 @@ handle_IPI (int irq, void *dev_id)
 
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
+				generic_smp_call_function_single_interrupt();
+				break;
+			      case IPI_CALL_FUNC_SINGLE:
+				generic_smp_call_function_single_interrupt();
+				break;
 
 			      case IPI_CPU_STOP:
 				stop_this_cpu();
@@ -209,6 +173,15 @@ send_IPI_allbutself (int op)
 	}
 }
 
+static inline void
+send_IPI_mask(cpumask_t mask, int op)
+{
+	unsigned int cpu;
+
+	for_each_cpu_mask(cpu, mask)
+		send_IPI_single(cpu, op);
+}
+
 /*
  * Called with preemption disabled.
  */
@@ -345,62 +318,41 @@ smp_flush_tlb_mm (struct mm_struct *mm)
 	on_each_cpu((void (*)(void *))local_finish_flush_tlb_mm, mm, 1, 1);
 }
 
+static void send_cfs_ipi(int cpu)
+{
+	send_IPI_single(cpu, IPI_CALL_FUNC_SINGLE);
+}
+
+void __smp_call_function_single(int cpu, struct call_single_data *data)
+{
+	generic_exec_single(cpu, data, send_cfs_ipi);
+}
+
 /*
- * Run a function on a specific CPU
- *  <func>	The function to run. This must be fast and non-blocking.
- *  <info>	An arbitrary pointer to pass to the function.
- *  <nonatomic>	Currently unused.
- *  <wait>	If true, wait until function has completed on other CPUs.
- *  [RETURNS]   0 on success, else a negative status code.
+ * smp_call_function_single - Run a function on a specific CPU
+ * @func: The function to run. This must be fast and non-blocking.
+ * @info: An arbitrary pointer to pass to the function.
+ * @nonatomic: Currently unused.
+ * @wait: If true, wait until function has completed on other CPUs.
+ *
+ * Retrurns 0 on success, else a negative status code.
  *
  * Does not return until the remote CPU is nearly ready to execute <func>
  * or is or has executed.
  */
-
-int
-smp_call_function_single (int cpuid, void (*func) (void *info), void *info, int nonatomic,
-			  int wait)
+int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
+			      int nonatomic, int wait)
 {
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
+	return generic_smp_call_function_single(cpu, func, info, wait,
+						send_cfs_ipi);
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
+static void send_call_function_ipi(cpumask_t mask)
+{
+	send_IPI_mask(mask, IPI_CALL_FUNC);
+}
+
 /*
  * this function sends a 'generic call function' IPI to all other CPUs
  * in the system.
@@ -423,41 +375,8 @@ EXPORT_SYMBOL(smp_call_function_single);
 int
 smp_call_function (void (*func) (void *info), void *info, int nonatomic, int wait)
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
+	return generic_smp_call_function(func, info, wait, cpu_online_map,
+						send_call_function_ipi);
 }
 EXPORT_SYMBOL(smp_call_function);
 
-- 
1.5.4.GIT

