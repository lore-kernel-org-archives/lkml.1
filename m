Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbYE2I4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbYE2I4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbYE2I4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:56:00 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17894 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbYE2Iz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:55:56 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, npiggin@suse.de, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
       Jens Axboe <jens.axboe@oracle.com>, Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH 6/10] arm: convert to generic helpers for IPI function calls
Date: Thu, 29 May 2008 10:58:20 +0200
Message-Id: <1212051504-12561-7-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.6.rc0.40.gd683
In-Reply-To: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com>
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts arm to use the new helpers for smp_call_function() and
friends, and adds support for smp_call_function_single().

Fixups and testing done by Catalin Marinas <catalin.marinas@arm.com>

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/arm/Kconfig      |    1 +
 arch/arm/kernel/smp.c |  157 +++++--------------------------------------------
 2 files changed, 16 insertions(+), 142 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b786e68..c72dae6 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -650,6 +650,7 @@ source "kernel/time/Kconfig"
 config SMP
 	bool "Symmetric Multi-Processing (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && (REALVIEW_EB_ARM11MP || MACH_REALVIEW_PB11MP)
+	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index eefae1d..6344466 100644
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
-{
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
-}
-
-int smp_call_function(void (*func)(void *info), void *info, int retry,
-                      int wait)
+void arch_send_call_function_ipi(cpumask_t mask)
 {
-	return smp_call_function_on_cpu(func, info, retry, wait,
-					cpu_online_map);
+	send_ipi_message(mask, IPI_CALL_FUNC);
 }
-EXPORT_SYMBOL_GPL(smp_call_function);
 
-int smp_call_function_single(int cpu, void (*func)(void *info), void *info,
-			     int retry, int wait)
+void arch_send_call_function_single_ipi(int cpu)
 {
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
+	send_ipi_message(cpumask_of_cpu(cpu), IPI_CALL_FUNC_SINGLE);
 }
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
+			case IPI_CALL_FUNC_SINGLE:
+				generic_smp_call_function_single_interrupt();
 				break;
 
 			case IPI_CPU_STOP:
@@ -662,14 +536,13 @@ int setup_profiling_timer(unsigned int multiplier)
 }
 
 static int
-on_each_cpu_mask(void (*func)(void *), void *info, int retry, int wait,
-		 cpumask_t mask)
+on_each_cpu_mask(void (*func)(void *), void *info, int wait, cpumask_t mask)
 {
 	int ret = 0;
 
 	preempt_disable();
 
-	ret = smp_call_function_on_cpu(func, info, retry, wait, mask);
+	ret = smp_call_function_mask(mask, func, info, wait);
 	if (cpu_isset(smp_processor_id(), mask))
 		func(info);
 
@@ -738,7 +611,7 @@ void flush_tlb_mm(struct mm_struct *mm)
 {
 	cpumask_t mask = mm->cpu_vm_mask;
 
-	on_each_cpu_mask(ipi_flush_tlb_mm, mm, 1, 1, mask);
+	on_each_cpu_mask(ipi_flush_tlb_mm, mm, 1, mask);
 }
 
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long uaddr)
@@ -749,7 +622,7 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long uaddr)
 	ta.ta_vma = vma;
 	ta.ta_start = uaddr;
 
-	on_each_cpu_mask(ipi_flush_tlb_page, &ta, 1, 1, mask);
+	on_each_cpu_mask(ipi_flush_tlb_page, &ta, 1, mask);
 }
 
 void flush_tlb_kernel_page(unsigned long kaddr)
@@ -771,7 +644,7 @@ void flush_tlb_range(struct vm_area_struct *vma,
 	ta.ta_start = start;
 	ta.ta_end = end;
 
-	on_each_cpu_mask(ipi_flush_tlb_range, &ta, 1, 1, mask);
+	on_each_cpu_mask(ipi_flush_tlb_range, &ta, 1, mask);
 }
 
 void flush_tlb_kernel_range(unsigned long start, unsigned long end)
-- 
1.5.6.rc0.40.gd683

