Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbXHWHgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbXHWHgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 03:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbXHWHf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 03:35:59 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:35886 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbXHWHf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 03:35:58 -0400
Message-ID: <46CD38E5.4000704@bull.net>
Date: Thu, 23 Aug 2007 09:36:05 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
Cc: discuss@x86-64.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Implement missing x86_64 function smp_call_function_mask()
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 23/08/2007 09:41:14,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 23/08/2007 09:41:15,
	Serialize complete at 23/08/2007 09:41:15
Content-Type: multipart/mixed;
 boundary="------------080204080409090509010405"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080204080409090509010405
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1

This patch defines the missing function smp_call_function_mask() for x86_64,
this is more or less a cut&paste of i386 function.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>

--------------080204080409090509010405
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="smp_call_function_mask-x86_64"
Content-Disposition: inline;
 filename="smp_call_function_mask-x86_64"

Index: kvm/arch/x86_64/kernel/smp.c
===================================================================
--- kvm.orig/arch/x86_64/kernel/smp.c	2007-08-22 18:31:37.000000000 +0200
+++ kvm/arch/x86_64/kernel/smp.c	2007-08-22 18:34:32.000000000 +0200
@@ -321,42 +321,6 @@ void unlock_ipi_call_lock(void)
 }
 
 /*
- * this function sends a 'generic call function' IPI to one other CPU
- * in the system.
- *
- * cpu is a standard Linux logical CPU number.
- */
-static void
-__smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-				int nonatomic, int wait)
-{
-	struct call_data_struct data;
-	int cpus = 1;
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
-	send_IPI_mask(cpumask_of_cpu(cpu), CALL_FUNCTION_VECTOR);
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
  * smp_call_function_single - Run a function on a specific CPU
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
@@ -373,6 +337,7 @@ int smp_call_function_single (int cpu, v
 	int nonatomic, int wait)
 {
 	/* prevent preemption and reschedule on another processor */
+	int ret;
 	int me = get_cpu();
 
 	/* Can deadlock when called with interrupts disabled */
@@ -386,9 +351,8 @@ int smp_call_function_single (int cpu, v
 		return 0;
 	}
 
-	spin_lock(&call_lock);
-	__smp_call_function_single(cpu, func, info, nonatomic, wait);
-	spin_unlock(&call_lock);
+	ret = smp_call_function_mask(cpumask_of_cpu(cpu), func, info, wait);
+
 	put_cpu();
 	return 0;
 }
@@ -430,6 +394,75 @@ static void __smp_call_function (void (*
 		cpu_relax();
 }
 
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
+	struct call_data_struct data;
+	cpumask_t allbutself;
+	int cpus;
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	/* Holding any lock stops cpus from going down. */
+	spin_lock(&call_lock);
+
+	allbutself = cpu_online_map;
+	cpu_clear(smp_processor_id(), allbutself);
+
+	cpus_and(mask, mask, allbutself);
+	cpus = cpus_weight(mask);
+
+	if (!cpus) {
+		spin_unlock(&call_lock);
+		return 0;
+	}
+
+	data.func = func;
+	data.info = info;
+	atomic_set(&data.started, 0);
+	data.wait = wait;
+	if (wait)
+		atomic_set(&data.finished, 0);
+
+	call_data = &data;
+	wmb();
+
+	/* Send a message to other CPUs */
+	if (cpus_equal(mask, allbutself))
+		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
+	else
+		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
+
+	/* Wait for response */
+	while (atomic_read(&data.started) != cpus)
+		cpu_relax();
+
+	if (wait)
+		while (atomic_read(&data.finished) != cpus)
+			cpu_relax();
+	spin_unlock(&call_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(smp_call_function_mask);
+
 /*
  * smp_call_function - run a function on all other CPUs.
  * @func: The function to run. This must be fast and non-blocking.
@@ -448,10 +481,7 @@ static void __smp_call_function (void (*
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
 
Index: kvm/include/asm-x86_64/smp.h
===================================================================
--- kvm.orig/include/asm-x86_64/smp.h	2007-08-22 18:31:37.000000000 +0200
+++ kvm/include/asm-x86_64/smp.h	2007-08-22 18:31:48.000000000 +0200
@@ -37,6 +37,8 @@ extern void lock_ipi_call_lock(void);
 extern void unlock_ipi_call_lock(void);
 extern int smp_num_siblings;
 extern void smp_send_reschedule(int cpu);
+extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
+				  void *info, int wait);
 
 extern cpumask_t cpu_sibling_map[NR_CPUS];
 extern cpumask_t cpu_core_map[NR_CPUS];

--------------080204080409090509010405--
