Return-Path: <linux-kernel-owner+w=401wt.eu-S1422992AbXCOXZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422992AbXCOXZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 19:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422861AbXCOXZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 19:25:23 -0400
Received: from gw.goop.org ([64.81.55.164]:54072 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422993AbXCOXZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 19:25:21 -0400
Message-ID: <45F9D5DD.8040909@goop.org>
Date: Thu, 15 Mar 2007 16:25:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ak@suse.de, linux-kernel@vger.kernel.org, mingo@elte.hu,
       eranian@hpl.hp.com, rdunlap@xenotime.net,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH] i386: Simplify smp_call_function*() by using common implementation
References: <45F5FA97.8070705@goop.org> <20070315110805.262e1fa3.akpm@linux-foundation.org>
In-Reply-To: <20070315110805.262e1fa3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Hopeless, sorry.   It's probably time to start thinking about raising x86
> patches against the x86 tree (at least).
>   

How's this?

    J

Subject: Simplify smp_call_function*() by using common implementation

smp_call_function and smp_call_function_single are almost complete
duplicates of the same logic.  This patch combines them by
implementing them in terms of the more general
smp_call_function_mask().

[ Jan, Andi: This only changes arch/i386; can x86_64 be changed in the
  same way? ]

[ Rebased onto Jan's x86_64-mm-consolidate-smp_send_stop patch ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andrew Morton <akpm@osdl.org>
Cc: Andi Kleen <ak@suse.de>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Ingo Molnar <mingo@elte.hu>

---
 arch/i386/kernel/smp.c |  177 +++++++++++++++++++++++-------------------------
 1 file changed, 86 insertions(+), 91 deletions(-)

===================================================================
--- a/arch/i386/kernel/smp.c
+++ b/arch/i386/kernel/smp.c
@@ -515,14 +515,26 @@ void unlock_ipi_call_lock(void)
 
 static struct call_data_struct *call_data;
 
-static void __smp_call_function(void (*func) (void *info), void *info,
-				int nonatomic, int wait)
+
+static int __smp_call_function_mask(cpumask_t mask,
+				    void (*func)(void *), void *info,
+				    int wait)
 {
 	struct call_data_struct data;
-	int cpus = num_online_cpus() - 1;
+	cpumask_t allbutself;
+	int cpus;
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	allbutself = cpu_online_map;
+	cpu_clear(smp_processor_id(), allbutself);
+
+	cpus_and(mask, mask, allbutself);
+	cpus = cpus_weight(mask);
 
 	if (!cpus)
-		return;
+		return 0;
 
 	data.func = func;
 	data.info = info;
@@ -533,9 +545,12 @@ static void __smp_call_function(void (*f
 
 	call_data = &data;
 	mb();
-	
-	/* Send a message to all other CPUs and wait for them to respond */
-	send_IPI_allbutself(CALL_FUNCTION_VECTOR);
+
+	/* Send a message to other CPUs */
+	if (cpus_equal(mask, allbutself))
+		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
+	else
+		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
 
 	/* Wait for response */
 	while (atomic_read(&data.started) != cpus)
@@ -544,6 +559,34 @@ static void __smp_call_function(void (*f
 	if (wait)
 		while (atomic_read(&data.finished) != cpus)
 			cpu_relax();
+
+	return 0;
+}
+
+/**
+ * smp_call_function_mask(): Run a function on a set of other CPUs.
+ * @mask: The set of cpus to run on.  Must not include the current cpu.
+ * @func: The function to run. This must be fast and non-blocking.
+ * @info: An arbitrary pointer to pass to the function.
+ * @wait: If true, wait (atomically) until function has completed on other CPUs.
+ *
+ * Returns 0 on success, else a negative status code. Does not return until
+ * remote CPUs are nearly ready to execute <<func>> or are or have finished.
+ *
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler.
+ */
+int smp_call_function_mask(cpumask_t mask,
+			     void (*func)(void *), void *info,
+			     int wait)
+{
+	int ret;
+
+	spin_lock(&call_lock);
+	ret = __smp_call_function_mask(mask, func, info, wait);
+	spin_unlock(&call_lock);
+
+	return ret;
 }
 
 /**
@@ -559,20 +602,43 @@ static void __smp_call_function(void (*f
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
  */
-int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
-			int wait)
-{
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	/* Holding any lock stops cpus from going down. */
-	spin_lock(&call_lock);
-	__smp_call_function(func, info, nonatomic, wait);
-	spin_unlock(&call_lock);
-
-	return 0;
+int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
+		      int wait)
+{
+	return smp_call_function_mask(cpu_online_map, func, info, wait);
 }
 EXPORT_SYMBOL(smp_call_function);
+
+/*
+ * smp_call_function_single - Run a function on another CPU
+ * @func: The function to run. This must be fast and non-blocking.
+ * @info: An arbitrary pointer to pass to the function.
+ * @nonatomic: Currently unused.
+ * @wait: If true, wait until function has completed on other CPUs.
+ *
+ * Retrurns 0 on success, else a negative status code.
+ *
+ * Does not return until the remote CPU is nearly ready to execute <func>
+ * or is or has executed.
+ */
+int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
+			     int nonatomic, int wait)
+{
+	/* prevent preemption and reschedule on another processor */
+	int ret;
+	int me = get_cpu();
+	if (cpu == me) {
+		WARN_ON(1);
+		put_cpu();
+		return -EBUSY;
+	}
+
+	ret = smp_call_function_mask(cpumask_of_cpu(cpu), func, info, wait);
+
+	put_cpu();
+	return ret;
+}
+EXPORT_SYMBOL(smp_call_function_single);
 
 static void stop_this_cpu (void * dummy)
 {
@@ -598,7 +664,7 @@ void smp_send_stop(void)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	__smp_call_function(stop_this_cpu, NULL, 0, 0);
+	__smp_call_function_mask(cpu_online_map, stop_this_cpu, NULL, 0);
 	if (!nolock)
 		spin_unlock(&call_lock);
 	disable_local_APIC();
@@ -641,77 +707,6 @@ fastcall void smp_call_function_interrup
 	}
 }
 
-/*
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
- * smp_call_function_single - Run a function on another CPU
- * @func: The function to run. This must be fast and non-blocking.
- * @info: An arbitrary pointer to pass to the function.
- * @nonatomic: Currently unused.
- * @wait: If true, wait until function has completed on other CPUs.
- *
- * Retrurns 0 on success, else a negative status code.
- *
- * Does not return until the remote CPU is nearly ready to execute <func>
- * or is or has executed.
- */
-
-int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-			int nonatomic, int wait)
-{
-	/* prevent preemption and reschedule on another processor */
-	int me = get_cpu();
-	if (cpu == me) {
-		WARN_ON(1);
-		put_cpu();
-		return -EBUSY;
-	}
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	spin_lock_bh(&call_lock);
-	__smp_call_function_single(cpu, func, info, nonatomic, wait);
-	spin_unlock_bh(&call_lock);
-	put_cpu();
-	return 0;
-}
-EXPORT_SYMBOL(smp_call_function_single);
-
 static int convert_apicid_to_cpu(int apic_id)
 {
 	int i;

