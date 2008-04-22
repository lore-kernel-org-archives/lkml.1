Return-Path: <linux-kernel-owner+w=401wt.eu-S1762481AbYDVH7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762481AbYDVH7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 03:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbYDVH5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 03:57:25 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26335 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756602AbYDVH5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 03:57:09 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: npiggin@suse.de, torvalds@linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>, Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH 6/11] arm: convert to generic helpers for IPI function calls
Date: Tue, 22 Apr 2008 09:57:32 +0200
Message-Id: <1208851058-8500-7-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.5.1.57.g5909c
In-Reply-To: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts arm to use the new helpers for smp_call_function() and
friends, and adds support for smp_call_function_single(). Not tested
at all, not even compiled.

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/arm/Kconfig      |    5 ++
 arch/arm/kernel/smp.c |  148 ++++---------------------------------------------
 2 files changed, 16 insertions(+), 137 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index d8d2532..b34cedb 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -79,6 +79,11 @@ config GENERIC_HARDIRQS
 	bool
 	default y
 
+config GENERIC_SMP_HELPERS
+	bool
+	depends on SMP
+	default y
+
 config STACKTRACE_SUPPORT
 	bool
 	default y
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index eefae1d..9c85329 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -68,20 +68,10 @@ enum ipi_msg_type {
 	IPI_TIMER,
 	IPI_RESCHEDULE,
 	IPI_CALL_FUNC,
+	IPI_CALL_FUNC_SINGLE,
 	IPI_CPU_STOP,
 };
 
-struct smp_call_struct {
-	void (*func)(void *info);
-	void *info;
-	int wait;
-	cpumask_t pending;
-	cpumask_t unfinished;
-};
-
-static struct smp_call_struct * volatile smp_call_function_data;
-static DEFINE_SPINLOCK(smp_call_function_lock);
-
 int __cpuinit __cpu_up(unsigned int cpu)
 {
 	struct cpuinfo_arm *ci = &per_cpu(cpu_data, cpu);
@@ -366,114 +356,15 @@ static void send_ipi_message(cpumask_t callmap, enum ipi_msg_type msg)
 	local_irq_restore(flags);
 }
 
-/*
- * You must not call this function with disabled interrupts, from a
- * hardware interrupt handler, nor from a bottom half handler.
- */
-static int smp_call_function_on_cpu(void (*func)(void *info), void *info,
-				    int retry, int wait, cpumask_t callmap)
+void arch_send_call_function_ipi(cpumask_t mask)
 {
-	struct smp_call_struct data;
-	unsigned long timeout;
-	int ret = 0;
-
-	data.func = func;
-	data.info = info;
-	data.wait = wait;
-
-	cpu_clear(smp_processor_id(), callmap);
-	if (cpus_empty(callmap))
-		goto out;
-
-	data.pending = callmap;
-	if (wait)
-		data.unfinished = callmap;
-
-	/*
-	 * try to get the mutex on smp_call_function_data
-	 */
-	spin_lock(&smp_call_function_lock);
-	smp_call_function_data = &data;
-
-	send_ipi_message(callmap, IPI_CALL_FUNC);
-
-	timeout = jiffies + HZ;
-	while (!cpus_empty(data.pending) && time_before(jiffies, timeout))
-		barrier();
-
-	/*
-	 * did we time out?
-	 */
-	if (!cpus_empty(data.pending)) {
-		/*
-		 * this may be causing our panic - report it
-		 */
-		printk(KERN_CRIT
-		       "CPU%u: smp_call_function timeout for %p(%p)\n"
-		       "      callmap %lx pending %lx, %swait\n",
-		       smp_processor_id(), func, info, *cpus_addr(callmap),
-		       *cpus_addr(data.pending), wait ? "" : "no ");
-
-		/*
-		 * TRACE
-		 */
-		timeout = jiffies + (5 * HZ);
-		while (!cpus_empty(data.pending) && time_before(jiffies, timeout))
-			barrier();
-
-		if (cpus_empty(data.pending))
-			printk(KERN_CRIT "     RESOLVED\n");
-		else
-			printk(KERN_CRIT "     STILL STUCK\n");
-	}
-
-	/*
-	 * whatever happened, we're done with the data, so release it
-	 */
-	smp_call_function_data = NULL;
-	spin_unlock(&smp_call_function_lock);
-
-	if (!cpus_empty(data.pending)) {
-		ret = -ETIMEDOUT;
-		goto out;
-	}
-
-	if (wait)
-		while (!cpus_empty(data.unfinished))
-			barrier();
- out:
-
-	return 0;
+	send_ipi_message(mask, IPI_CALL_FUNC);
 }
 
-int smp_call_function(void (*func)(void *info), void *info, int retry,
-                      int wait)
+void arch_send_call_function_single_ipi(int cpu)
 {
-	return smp_call_function_on_cpu(func, info, retry, wait,
-					cpu_online_map);
+	send_ipi_message(cpumask_of_cpu(cpu), IPI_CALL_FUNC_SINGLE);
 }
-EXPORT_SYMBOL_GPL(smp_call_function);
-
-int smp_call_function_single(int cpu, void (*func)(void *info), void *info,
-			     int retry, int wait)
-{
-	/* prevent preemption and reschedule on another processor */
-	int current_cpu = get_cpu();
-	int ret = 0;
-
-	if (cpu == current_cpu) {
-		local_irq_disable();
-		func(info);
-		local_irq_enable();
-	} else
-		ret = smp_call_function_on_cpu(func, info, retry, wait,
-					       cpumask_of_cpu(cpu));
-
-	put_cpu();
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(smp_call_function_single);
 
 void show_ipi_list(struct seq_file *p)
 {
@@ -521,27 +412,6 @@ asmlinkage void __exception do_local_timer(struct pt_regs *regs)
 }
 #endif
 
-/*
- * ipi_call_function - handle IPI from smp_call_function()
- *
- * Note that we copy data out of the cross-call structure and then
- * let the caller know that we're here and have done with their data
- */
-static void ipi_call_function(unsigned int cpu)
-{
-	struct smp_call_struct *data = smp_call_function_data;
-	void (*func)(void *info) = data->func;
-	void *info = data->info;
-	int wait = data->wait;
-
-	cpu_clear(cpu, data->pending);
-
-	func(info);
-
-	if (wait)
-		cpu_clear(cpu, data->unfinished);
-}
-
 static DEFINE_SPINLOCK(stop_lock);
 
 /*
@@ -611,7 +481,11 @@ asmlinkage void __exception do_IPI(struct pt_regs *regs)
 				break;
 
 			case IPI_CALL_FUNC:
-				ipi_call_function(cpu);
+				generic_smp_call_function_interrupt();
+				break;
+
+			case IPI_CALL_FUNC:
+				generic_smp_call_function_single_interrupt();
 				break;
 
 			case IPI_CPU_STOP:
@@ -669,7 +543,7 @@ on_each_cpu_mask(void (*func)(void *), void *info, int retry, int wait,
 
 	preempt_disable();
 
-	ret = smp_call_function_on_cpu(func, info, retry, wait, mask);
+	ret = smp_call_function_mask(mask, func, info, retry, wait);
 	if (cpu_isset(smp_processor_id(), mask))
 		func(info);
 
-- 
1.5.5.49.gf43e2

