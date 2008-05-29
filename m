Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612AbYE2I4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbYE2I4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYE2I4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:56:03 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17896 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbYE2Iz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:55:56 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, npiggin@suse.de, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 5/10] alpha: convert to generic helpers for IPI function calls
Date: Thu, 29 May 2008 10:58:19 +0200
Message-Id: <1212051504-12561-6-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.6.rc0.40.gd683
In-Reply-To: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com>
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts alpha to use the new helpers for smp_call_function() and
friends, and adds support for smp_call_function_single().

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/alpha/Kconfig              |    1 +
 arch/alpha/kernel/core_marvel.c |    6 +-
 arch/alpha/kernel/smp.c         |  170 +++------------------------------------
 include/asm-alpha/smp.h         |    2 -
 4 files changed, 14 insertions(+), 165 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 729cdbd..dbe8c28 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -528,6 +528,7 @@ config ARCH_MAY_HAVE_PC_FDC
 config SMP
 	bool "Symmetric multi-processing support"
 	depends on ALPHA_SABLE || ALPHA_LYNX || ALPHA_RAWHIDE || ALPHA_DP264 || ALPHA_WILDFIRE || ALPHA_TITAN || ALPHA_GENERIC || ALPHA_SHARK || ALPHA_MARVEL
+	select USE_GENERIC_SMP_HELPERS
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff --git a/arch/alpha/kernel/core_marvel.c b/arch/alpha/kernel/core_marvel.c
index b04f1fe..ced4aae 100644
--- a/arch/alpha/kernel/core_marvel.c
+++ b/arch/alpha/kernel/core_marvel.c
@@ -660,9 +660,9 @@ __marvel_rtc_io(u8 b, unsigned long addr, int write)
 
 #ifdef CONFIG_SMP
 		if (smp_processor_id() != boot_cpuid)
-			smp_call_function_on_cpu(__marvel_access_rtc,
-						 &rtc_access, 1, 1,
-						 cpumask_of_cpu(boot_cpuid));
+			smp_call_function_single(boot_cpuid,
+						 __marvel_access_rtc,
+						 &rtc_access, 1, 1);
 		else
 			__marvel_access_rtc(&rtc_access);
 #else
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 2525692..95c905b 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -62,6 +62,7 @@ static struct {
 enum ipi_message_type {
 	IPI_RESCHEDULE,
 	IPI_CALL_FUNC,
+	IPI_CALL_FUNC_SINGLE,
 	IPI_CPU_STOP,
 };
 
@@ -558,51 +559,6 @@ send_ipi_message(cpumask_t to_whom, enum ipi_message_type operation)
 		wripir(i);
 }
 
-/* Structure and data for smp_call_function.  This is designed to 
-   minimize static memory requirements.  Plus it looks cleaner.  */
-
-struct smp_call_struct {
-	void (*func) (void *info);
-	void *info;
-	long wait;
-	atomic_t unstarted_count;
-	atomic_t unfinished_count;
-};
-
-static struct smp_call_struct *smp_call_function_data;
-
-/* Atomicly drop data into a shared pointer.  The pointer is free if
-   it is initially locked.  If retry, spin until free.  */
-
-static int
-pointer_lock (void *lock, void *data, int retry)
-{
-	void *old, *tmp;
-
-	mb();
- again:
-	/* Compare and swap with zero.  */
-	asm volatile (
-	"1:	ldq_l	%0,%1\n"
-	"	mov	%3,%2\n"
-	"	bne	%0,2f\n"
-	"	stq_c	%2,%1\n"
-	"	beq	%2,1b\n"
-	"2:"
-	: "=&r"(old), "=m"(*(void **)lock), "=&r"(tmp)
-	: "r"(data)
-	: "memory");
-
-	if (old == 0)
-		return 0;
-	if (! retry)
-		return -EBUSY;
-
-	while (*(void **)lock)
-		barrier();
-	goto again;
-}
-
 void
 handle_ipi(struct pt_regs *regs)
 {
@@ -632,31 +588,12 @@ handle_ipi(struct pt_regs *regs)
 			break;
 
 		case IPI_CALL_FUNC:
-		    {
-			struct smp_call_struct *data;
-			void (*func)(void *info);
-			void *info;
-			int wait;
-
-			data = smp_call_function_data;
-			func = data->func;
-			info = data->info;
-			wait = data->wait;
-
-			/* Notify the sending CPU that the data has been
-			   received, and execution is about to begin.  */
-			mb();
-			atomic_dec (&data->unstarted_count);
-
-			/* At this point the structure may be gone unless
-			   wait is true.  */
-			(*func)(info);
-
-			/* Notify the sending CPU that the task is done.  */
-			mb();
-			if (wait) atomic_dec (&data->unfinished_count);
+			generic_smp_call_function_interrupt();
+			break;
+
+		case IPI_CALL_FUNC_SINGLE:
+			generic_smp_call_function_single_interrupt();
 			break;
-		    }
 
 		case IPI_CPU_STOP:
 			halt();
@@ -700,102 +637,15 @@ smp_send_stop(void)
 	send_ipi_message(to_whom, IPI_CPU_STOP);
 }
 
-/*
- * Run a function on all other CPUs.
- *  <func>	The function to run. This must be fast and non-blocking.
- *  <info>	An arbitrary pointer to pass to the function.
- *  <retry>	If true, keep retrying until ready.
- *  <wait>	If true, wait until function has completed on other CPUs.
- *  [RETURNS]   0 on success, else a negative status code.
- *
- * Does not return until remote CPUs are nearly ready to execute <func>
- * or are or have executed.
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
- */
-
-int
-smp_call_function_on_cpu (void (*func) (void *info), void *info, int retry,
-			  int wait, cpumask_t to_whom)
+void arch_send_call_function_ipi(cpumask_t mask)
 {
-	struct smp_call_struct data;
-	unsigned long timeout;
-	int num_cpus_to_call;
-	
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	data.func = func;
-	data.info = info;
-	data.wait = wait;
-
-	cpu_clear(smp_processor_id(), to_whom);
-	num_cpus_to_call = cpus_weight(to_whom);
-
-	atomic_set(&data.unstarted_count, num_cpus_to_call);
-	atomic_set(&data.unfinished_count, num_cpus_to_call);
-
-	/* Acquire the smp_call_function_data mutex.  */
-	if (pointer_lock(&smp_call_function_data, &data, retry))
-		return -EBUSY;
-
-	/* Send a message to the requested CPUs.  */
-	send_ipi_message(to_whom, IPI_CALL_FUNC);
-
-	/* Wait for a minimal response.  */
-	timeout = jiffies + HZ;
-	while (atomic_read (&data.unstarted_count) > 0
-	       && time_before (jiffies, timeout))
-		barrier();
-
-	/* If there's no response yet, log a message but allow a longer
-	 * timeout period -- if we get a response this time, log
-	 * a message saying when we got it.. 
-	 */
-	if (atomic_read(&data.unstarted_count) > 0) {
-		long start_time = jiffies;
-		printk(KERN_ERR "%s: initial timeout -- trying long wait\n",
-		       __func__);
-		timeout = jiffies + 30 * HZ;
-		while (atomic_read(&data.unstarted_count) > 0
-		       && time_before(jiffies, timeout))
-			barrier();
-		if (atomic_read(&data.unstarted_count) <= 0) {
-			long delta = jiffies - start_time;
-			printk(KERN_ERR 
-			       "%s: response %ld.%ld seconds into long wait\n",
-			       __func__, delta / HZ,
-			       (100 * (delta - ((delta / HZ) * HZ))) / HZ);
-		}
-	}
-
-	/* We either got one or timed out -- clear the lock. */
-	mb();
-	smp_call_function_data = NULL;
-
-	/* 
-	 * If after both the initial and long timeout periods we still don't
-	 * have a response, something is very wrong...
-	 */
-	BUG_ON(atomic_read (&data.unstarted_count) > 0);
-
-	/* Wait for a complete response, if needed.  */
-	if (wait) {
-		while (atomic_read (&data.unfinished_count) > 0)
-			barrier();
-	}
-
-	return 0;
+	send_ipi_message(mask, IPI_CALL_FUNC);
 }
-EXPORT_SYMBOL(smp_call_function_on_cpu);
 
-int
-smp_call_function (void (*func) (void *info), void *info, int retry, int wait)
+void arch_send_call_function_single_ipi(int cpu)
 {
-	return smp_call_function_on_cpu (func, info, retry, wait,
-					 cpu_online_map);
+	send_ipi_message(cpumask_of_cpu(cpu), IPI_CALL_FUNC_SINGLE);
 }
-EXPORT_SYMBOL(smp_call_function);
 
 static void
 ipi_imb(void *ignored)
diff --git a/include/asm-alpha/smp.h b/include/asm-alpha/smp.h
index 286e1d8..a9090b6 100644
--- a/include/asm-alpha/smp.h
+++ b/include/asm-alpha/smp.h
@@ -47,8 +47,6 @@ extern struct cpuinfo_alpha cpu_data[NR_CPUS];
 extern int smp_num_cpus;
 #define cpu_possible_map	cpu_present_map
 
-int smp_call_function_on_cpu(void (*func) (void *info), void *info,int retry, int wait, cpumask_t cpu);
-
 #else /* CONFIG_SMP */
 
 #define hard_smp_processor_id()		0
-- 
1.5.6.rc0.40.gd683

