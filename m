Return-Path: <linux-kernel-owner+w=401wt.eu-S932609AbXIUWlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609AbXIUWlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762489AbXIUWce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:40487 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761678AbXIUWc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:26 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: Laurent.Vivier@bull.net, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [23/50] x86_64: Implement missing x86_64 function smp_call_function_mask()
Message-Id: <20070921223222.5CBD513DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:22 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Laurent Vivier <Laurent.Vivier@bull.net>

This patch defines the missing function smp_call_function_mask() for x86_64,
this is more or less a cut&paste of i386 function. It removes also some
duplicate code.

This function is needed by KVM to execute a function on some CPUs.

AK: Fixed description
AK: Moved WARN_ON(irqs_disabled) one level up to not warn in the panic case.

 arch/x86_64/kernel/smp.c |  118 ++++++++++++++++++++++++-----------------------
 include/asm-x86_64/smp.h |    2
 arch/x86_64/kernel/smp.c |  119 ++++++++++++++++++++++++-----------------------
 include/asm-x86_64/smp.h |    2 
 2 files changed, 65 insertions(+), 56 deletions(-)

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Andi Kleen <ak@suse.de>


Index: linux/arch/x86_64/kernel/smp.c
===================================================================
--- linux.orig/arch/x86_64/kernel/smp.c
+++ linux/arch/x86_64/kernel/smp.c
@@ -322,17 +322,27 @@ void unlock_ipi_call_lock(void)
 }
 
 /*
- * this function sends a 'generic call function' IPI to one other CPU
- * in the system.
- *
- * cpu is a standard Linux logical CPU number.
+ * this function sends a 'generic call function' IPI to all other CPU
+ * of the system defined in the mask.
  */
-static void
-__smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-				int nonatomic, int wait)
+
+static int
+__smp_call_function_mask(cpumask_t mask,
+			 void (*func)(void *), void *info,
+			 int wait)
 {
 	struct call_data_struct data;
-	int cpus = 1;
+	cpumask_t allbutself;
+	int cpus;
+
+	allbutself = cpu_online_map;
+	cpu_clear(smp_processor_id(), allbutself);
+
+	cpus_and(mask, mask, allbutself);
+	cpus = cpus_weight(mask);
+
+	if (!cpus)
+		return 0;
 
 	data.func = func;
 	data.info = info;
@@ -343,19 +353,55 @@ __smp_call_function_single(int cpu, void
 
 	call_data = &data;
 	wmb();
-	/* Send a message to all other CPUs and wait for them to respond */
-	send_IPI_mask(cpumask_of_cpu(cpu), CALL_FUNCTION_VECTOR);
+
+	/* Send a message to other CPUs */
+	if (cpus_equal(mask, allbutself))
+		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
+	else
+		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
 
 	/* Wait for response */
 	while (atomic_read(&data.started) != cpus)
 		cpu_relax();
 
 	if (!wait)
-		return;
+		return 0;
 
 	while (atomic_read(&data.finished) != cpus)
 		cpu_relax();
+
+	return 0;
+}
+/**
+ * smp_call_function_mask(): Run a function on a set of other CPUs.
+ * @mask: The set of cpus to run on.  Must not include the current cpu.
+ * @func: The function to run. This must be fast and non-blocking.
+ * @info: An arbitrary pointer to pass to the function.
+ * @wait: If true, wait (atomically) until function has completed on other CPUs.
+ *
+ * Returns 0 on success, else a negative status code.
+ *
+ * If @wait is true, then returns once @func has returned; otherwise
+ * it returns just before the target cpu calls @func.
+ *
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler.
+ */
+int smp_call_function_mask(cpumask_t mask,
+			   void (*func)(void *), void *info,
+			   int wait)
+{
+	int ret;
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	spin_lock(&call_lock);
+	ret = __smp_call_function_mask(mask, func, info, wait);
+	spin_unlock(&call_lock);
+	return ret;
 }
+EXPORT_SYMBOL(smp_call_function_mask);
 
 /*
  * smp_call_function_single - Run a function on a specific CPU
@@ -374,6 +420,7 @@ int smp_call_function_single (int cpu, v
 	int nonatomic, int wait)
 {
 	/* prevent preemption and reschedule on another processor */
+	int ret;
 	int me = get_cpu();
 
 	/* Can deadlock when called with interrupts disabled */
@@ -387,51 +434,14 @@ int smp_call_function_single (int cpu, v
 		return 0;
 	}
 
-	spin_lock(&call_lock);
-	__smp_call_function_single(cpu, func, info, nonatomic, wait);
-	spin_unlock(&call_lock);
+	ret = smp_call_function_mask(cpumask_of_cpu(cpu), func, info, wait);
+
 	put_cpu();
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
 /*
- * this function sends a 'generic call function' IPI to all other CPUs
- * in the system.
- */
-static void __smp_call_function (void (*func) (void *info), void *info,
-				int nonatomic, int wait)
-{
-	struct call_data_struct data;
-	int cpus = num_online_cpus()-1;
-
-	if (!cpus)
-		return;
-
-	data.func = func;
-	data.info = info;
-	atomic_set(&data.started, 0);
-	data.wait = wait;
-	if (wait)
-		atomic_set(&data.finished, 0);
-
-	call_data = &data;
-	wmb();
-	/* Send a message to all other CPUs and wait for them to respond */
-	send_IPI_allbutself(CALL_FUNCTION_VECTOR);
-
-	/* Wait for response */
-	while (atomic_read(&data.started) != cpus)
-		cpu_relax();
-
-	if (!wait)
-		return;
-
-	while (atomic_read(&data.finished) != cpus)
-		cpu_relax();
-}
-
-/*
  * smp_call_function - run a function on all other CPUs.
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
@@ -449,10 +459,7 @@ static void __smp_call_function (void (*
 int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
 			int wait)
 {
-	spin_lock(&call_lock);
-	__smp_call_function(func,info,nonatomic,wait);
-	spin_unlock(&call_lock);
-	return 0;
+	return smp_call_function_mask(cpu_online_map, func, info, wait);
 }
 EXPORT_SYMBOL(smp_call_function);
 
@@ -479,7 +486,7 @@ void smp_send_stop(void)
 	/* Don't deadlock on the call lock in panic */
 	nolock = !spin_trylock(&call_lock);
 	local_irq_save(flags);
-	__smp_call_function(stop_this_cpu, NULL, 0, 0);
+	__smp_call_function_mask(cpu_online_map, stop_this_cpu, NULL, 0);
 	if (!nolock)
 		spin_unlock(&call_lock);
 	disable_local_APIC();
Index: linux/include/asm-x86_64/smp.h
===================================================================
--- linux.orig/include/asm-x86_64/smp.h
+++ linux/include/asm-x86_64/smp.h
@@ -37,6 +37,8 @@ extern void lock_ipi_call_lock(void);
 extern void unlock_ipi_call_lock(void);
 extern int smp_num_siblings;
 extern void smp_send_reschedule(int cpu);
+extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
+				  void *info, int wait);
 
 extern cpumask_t cpu_sibling_map[NR_CPUS];
 extern cpumask_t cpu_core_map[NR_CPUS];
