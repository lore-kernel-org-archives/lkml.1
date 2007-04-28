Return-Path: <linux-kernel-owner+w=401wt.eu-S1163447AbXD1SPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163447AbXD1SPv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161264AbXD1SOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:14:53 -0400
Received: from ns2.suse.de ([195.135.220.15]:38594 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163294AbXD1Rwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:37 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: "Jan Beulich" <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [12/35] x86: consolidate smp_send_stop()
Message-Id: <20070428175236.A08F4151D1@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
Synchronize i386's smp_send_stop() with x86-64's in only try-locking
the call lock to prevent deadlocks when called from panic().
In both version, disable interrupts before clearing the CPU off the
online map to eliminate races with IRQ handlers inspecting this map.
Also in both versions, save/restore interrupts rather than disabling/
enabling them.
On x86-64, eliminate one function used here by folding it into its
single caller, convert to static, and rename for consistency with i386
(lkcd may like this).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/smp.c   |   70 ++++++++++++++++++++++++++---------------------
 arch/x86_64/kernel/smp.c |   28 ++++++------------
 include/asm-x86_64/smp.h |    1 
 3 files changed, 49 insertions(+), 50 deletions(-)

Index: linux/arch/i386/kernel/smp.c
===================================================================
--- linux.orig/arch/i386/kernel/smp.c
+++ linux/arch/i386/kernel/smp.c
@@ -515,35 +515,14 @@ void unlock_ipi_call_lock(void)
 
 static struct call_data_struct *call_data;
 
-/**
- * smp_call_function(): Run a function on all other CPUs.
- * @func: The function to run. This must be fast and non-blocking.
- * @info: An arbitrary pointer to pass to the function.
- * @nonatomic: currently unused.
- * @wait: If true, wait (atomically) until function has completed on other CPUs.
- *
- * Returns 0 on success, else a negative status code. Does not return until
- * remote CPUs are nearly ready to execute <<func>> or are or have executed.
- *
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
- */
-int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
-			int wait)
+static void __smp_call_function(void (*func) (void *info), void *info,
+				int nonatomic, int wait)
 {
 	struct call_data_struct data;
-	int cpus;
+	int cpus = num_online_cpus() - 1;
 
-	/* Holding any lock stops cpus from going down. */
-	spin_lock(&call_lock);
-	cpus = num_online_cpus() - 1;
-	if (!cpus) {
-		spin_unlock(&call_lock);
-		return 0;
-	}
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
+	if (!cpus)
+		return;
 
 	data.func = func;
 	data.info = info;
@@ -565,6 +544,30 @@ int smp_call_function (void (*func) (voi
 	if (wait)
 		while (atomic_read(&data.finished) != cpus)
 			cpu_relax();
+}
+
+/**
+ * smp_call_function(): Run a function on all other CPUs.
+ * @func: The function to run. This must be fast and non-blocking.
+ * @info: An arbitrary pointer to pass to the function.
+ * @nonatomic: currently unused.
+ * @wait: If true, wait (atomically) until function has completed on other CPUs.
+ *
+ * Returns 0 on success, else a negative status code. Does not return until
+ * remote CPUs are nearly ready to execute <<func>> or are or have executed.
+ *
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler.
+ */
+int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
+			int wait)
+{
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	/* Holding any lock stops cpus from going down. */
+	spin_lock(&call_lock);
+	__smp_call_function(func, info, nonatomic, wait);
 	spin_unlock(&call_lock);
 
 	return 0;
@@ -573,11 +576,11 @@ EXPORT_SYMBOL(smp_call_function);
 
 static void stop_this_cpu (void * dummy)
 {
+	local_irq_disable();
 	/*
 	 * Remove this CPU:
 	 */
 	cpu_clear(smp_processor_id(), cpu_online_map);
-	local_irq_disable();
 	disable_local_APIC();
 	if (cpu_data[smp_processor_id()].hlt_works_ok)
 		for(;;) halt();
@@ -590,11 +593,16 @@ static void stop_this_cpu (void * dummy)
 
 void smp_send_stop(void)
 {
-	smp_call_function(stop_this_cpu, NULL, 1, 0);
-
-	local_irq_disable();
+	/* Don't deadlock on the call lock in panic */
+	int nolock = !spin_trylock(&call_lock);
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__smp_call_function(stop_this_cpu, NULL, 0, 0);
+	if (!nolock)
+		spin_unlock(&call_lock);
 	disable_local_APIC();
-	local_irq_enable();
+	local_irq_restore(flags);
 }
 
 /*
Index: linux/arch/x86_64/kernel/smp.c
===================================================================
--- linux.orig/arch/x86_64/kernel/smp.c
+++ linux/arch/x86_64/kernel/smp.c
@@ -452,42 +452,34 @@ int smp_call_function (void (*func) (voi
 }
 EXPORT_SYMBOL(smp_call_function);
 
-void smp_stop_cpu(void)
+static void stop_this_cpu(void *dummy)
 {
-	unsigned long flags;
+	local_irq_disable();
 	/*
 	 * Remove this CPU:
 	 */
 	cpu_clear(smp_processor_id(), cpu_online_map);
-	local_irq_save(flags);
 	disable_local_APIC();
-	local_irq_restore(flags);
-}
-
-static void smp_really_stop_cpu(void *dummy)
-{
-	smp_stop_cpu(); 
 	for (;;) 
 		halt();
 } 
 
 void smp_send_stop(void)
 {
-	int nolock = 0;
+	int nolock;
+	unsigned long flags;
+
 	if (reboot_force)
 		return;
+
 	/* Don't deadlock on the call lock in panic */
-	if (!spin_trylock(&call_lock)) {
-		/* ignore locking because we have panicked anyways */
-		nolock = 1;
-	}
-	__smp_call_function(smp_really_stop_cpu, NULL, 0, 0);
+	nolock = !spin_trylock(&call_lock);
+	local_irq_save(flags);
+	__smp_call_function(stop_this_cpu, NULL, 0, 0);
 	if (!nolock)
 		spin_unlock(&call_lock);
-
-	local_irq_disable();
 	disable_local_APIC();
-	local_irq_enable();
+	local_irq_restore(flags);
 }
 
 /*
Index: linux/include/asm-x86_64/smp.h
===================================================================
--- linux.orig/include/asm-x86_64/smp.h
+++ linux/include/asm-x86_64/smp.h
@@ -37,7 +37,6 @@ extern void lock_ipi_call_lock(void);
 extern void unlock_ipi_call_lock(void);
 extern int smp_num_siblings;
 extern void smp_send_reschedule(int cpu);
-void smp_stop_cpu(void);
 
 extern cpumask_t cpu_sibling_map[NR_CPUS];
 extern cpumask_t cpu_core_map[NR_CPUS];
