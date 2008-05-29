Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbYE2I6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbYE2I6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbYE2I4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:56:10 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17937 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbYE2Iz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:55:59 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, npiggin@suse.de, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
       Jens Axboe <jens.axboe@oracle.com>,
       Kyle McMartin <kyle@parisc-linux.org>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>
Subject: [PATCH 9/10] parisc: convert to generic helpers for IPI function calls
Date: Thu, 29 May 2008 10:58:23 +0200
Message-Id: <1212051504-12561-10-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.6.rc0.40.gd683
In-Reply-To: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com>
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts parisc to use the new helpers for smp_call_function() and
friends, and adds support for smp_call_function_single(). Not tested,
not even compiled.

Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/parisc/Kconfig      |    1 +
 arch/parisc/kernel/smp.c |  134 +++++++--------------------------------------
 2 files changed, 22 insertions(+), 113 deletions(-)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index bc7a19d..a7d4fd3 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -199,6 +199,7 @@ endchoice
 
 config SMP
 	bool "Symmetric multi-processing support"
+	select USE_GENERIC_SMP_HELPERS
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index 85fc775..126105c 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -84,19 +84,11 @@ EXPORT_SYMBOL(cpu_possible_map);
 
 DEFINE_PER_CPU(spinlock_t, ipi_lock) = SPIN_LOCK_UNLOCKED;
 
-struct smp_call_struct {
-	void (*func) (void *info);
-	void *info;
-	long wait;
-	atomic_t unstarted_count;
-	atomic_t unfinished_count;
-};
-static volatile struct smp_call_struct *smp_call_function_data;
-
 enum ipi_message_type {
 	IPI_NOP=0,
 	IPI_RESCHEDULE=1,
 	IPI_CALL_FUNC,
+	IPI_CALL_FUNC_SINGLE,
 	IPI_CPU_START,
 	IPI_CPU_STOP,
 	IPI_CPU_TEST
@@ -187,33 +179,12 @@ ipi_interrupt(int irq, void *dev_id)
 
 			case IPI_CALL_FUNC:
 				smp_debug(100, KERN_DEBUG "CPU%d IPI_CALL_FUNC\n", this_cpu);
-				{
-					volatile struct smp_call_struct *data;
-					void (*func)(void *info);
-					void *info;
-					int wait;
-
-					data = smp_call_function_data;
-					func = data->func;
-					info = data->info;
-					wait = data->wait;
-
-					mb();
-					atomic_dec ((atomic_t *)&data->unstarted_count);
-
-					/* At this point, *data can't
-					 * be relied upon.
-					 */
-
-					(*func)(info);
-
-					/* Notify the sending CPU that the
-					 * task is done.
-					 */
-					mb();
-					if (wait)
-						atomic_dec ((atomic_t *)&data->unfinished_count);
-				}
+				generic_smp_call_function_interrupt();
+				break;
+
+			case IPI_CALL_FUNC_SINGLE:
+				smp_debug(100, KERN_DEBUG "CPU%d IPI_CALL_FUNC_SINGLE\n", this_cpu);
+				generic_smp_call_function_single_interrupt();
 				break;
 
 			case IPI_CPU_START:
@@ -256,6 +227,14 @@ ipi_send(int cpu, enum ipi_message_type op)
 	spin_unlock_irqrestore(lock, flags);
 }
 
+static void
+send_IPI_mask(cpumask_t mask, enum ipi_message_type op)
+{
+	int cpu;
+
+	for_each_cpu_mask(cpu, mask)
+		ipi_send(cpu, op);
+}
 
 static inline void
 send_IPI_single(int dest_cpu, enum ipi_message_type op)
@@ -295,86 +274,15 @@ smp_send_all_nop(void)
 	send_IPI_allbutself(IPI_NOP);
 }
 
-
-/**
- * Run a function on all other CPUs.
- *  <func>	The function to run. This must be fast and non-blocking.
- *  <info>	An arbitrary pointer to pass to the function.
- *  <retry>	If true, keep retrying until ready.
- *  <wait>	If true, wait until function has completed on other CPUs.
- *  [RETURNS]   0 on success, else a negative status code.
- *
- * Does not return until remote CPUs are nearly ready to execute <func>
- * or have executed.
- */
-
-int
-smp_call_function (void (*func) (void *info), void *info, int retry, int wait)
+void arch_send_call_function_ipi(cpumask_t mask)
 {
-	struct smp_call_struct data;
-	unsigned long timeout;
-	static DEFINE_SPINLOCK(lock);
-	int retries = 0;
-
-	if (num_online_cpus() < 2)
-		return 0;
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	/* can also deadlock if IPIs are disabled */
-	WARN_ON((get_eiem() & (1UL<<(CPU_IRQ_MAX - IPI_IRQ))) == 0);
-
-	
-	data.func = func;
-	data.info = info;
-	data.wait = wait;
-	atomic_set(&data.unstarted_count, num_online_cpus() - 1);
-	atomic_set(&data.unfinished_count, num_online_cpus() - 1);
-
-	if (retry) {
-		spin_lock (&lock);
-		while (smp_call_function_data != 0)
-			barrier();
-	}
-	else {
-		spin_lock (&lock);
-		if (smp_call_function_data) {
-			spin_unlock (&lock);
-			return -EBUSY;
-		}
-	}
-
-	smp_call_function_data = &data;
-	spin_unlock (&lock);
-	
-	/*  Send a message to all other CPUs and wait for them to respond  */
-	send_IPI_allbutself(IPI_CALL_FUNC);
-
- retry:
-	/*  Wait for response  */
-	timeout = jiffies + HZ;
-	while ( (atomic_read (&data.unstarted_count) > 0) &&
-		time_before (jiffies, timeout) )
-		barrier ();
-
-	if (atomic_read (&data.unstarted_count) > 0) {
-		printk(KERN_CRIT "SMP CALL FUNCTION TIMED OUT! (cpu=%d), try %d\n",
-		      smp_processor_id(), ++retries);
-		goto retry;
-	}
-	/* We either got one or timed out. Release the lock */
-
-	mb();
-	smp_call_function_data = NULL;
-
-	while (wait && atomic_read (&data.unfinished_count) > 0)
-			barrier ();
-
-	return 0;
+	send_IPI_mask(mask, IPI_CALL_FUNC);
 }
 
-EXPORT_SYMBOL(smp_call_function);
+void arch_send_call_function_single_ipi(int cpu)
+{
+	send_IPI_single(cpu, IPI_CALL_FUNC_SINGLE);
+}
 
 /*
  * Flush all other CPU's tlb and then mine.  Do this with on_each_cpu()
-- 
1.5.6.rc0.40.gd683

