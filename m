Return-Path: <linux-kernel-owner+w=401wt.eu-S1759198AbYDIQ0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198AbYDIQ0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 12:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758211AbYDIQYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 12:24:12 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:59376 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758206AbYDIQYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:24:10 -0400
Message-Id: <20080409152050.389300996@polymtl.ca>
References: <20080409150829.855195878@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 Apr 2008 11:08:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Adrian Bunk <bunk@stusta.de>, Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, akpm@osdl.org
Subject: [patch 11/17] Implement immediate update via stop_machine_run
Content-Disposition: inline; filename=implement-immediate-update-via-stop-machine-run.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed,  9 Apr 2008 16:20:10 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Updating immediate values, cannot rely on smp_call_function() b/c synchronizing
 cpus using IPIs leads to deadlocks. Process A held a read lock on 
 tasklist_lock, then process B called apply_imv_update(). Process A received the 
 IPI and begins executing ipi_busy_loop(). Then process C takes a write lock 
 irq on the task list lock, before receiving the IPI. Thus, process A holds up 
 process C, and C can't get an IPI b/c interrupts are disabled. Solve this 
 problem by using a new 'ALL_CPUS' parameter to stop_machine_run(). Which 
 runs a function on all cpus after they are busy looping and have disabled 
 irqs. Since this is done in a new process context, we don't have to worry 
 about interrupted spin_locks. Also, less lines of code. Has survived 24 hours+
 of testing...

Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Adrian Bunk <bunk@stusta.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: mingo@elte.hu
CC: akpm@osdl.org
---

 kernel/immediate.c |   80 +++++++++++++----------------------------------------
 1 file changed, 21 insertions(+), 59 deletions(-)


Index: linux-2.6-lttng/kernel/immediate.c
===================================================================
--- linux-2.6-lttng.orig/kernel/immediate.c	2008-03-03 10:22:06.000000000 -0500
+++ linux-2.6-lttng/kernel/immediate.c	2008-03-03 10:42:38.000000000 -0500
@@ -20,6 +20,7 @@
 #include <linux/immediate.h>
 #include <linux/memory.h>
 #include <linux/cpu.h>
+#include <linux/stop_machine.h>
 
 #include <asm/cacheflush.h>
 
@@ -27,48 +28,33 @@
  * Kernel ready to execute the SMP update that may depend on trap and ipi.
  */
 static int imv_early_boot_complete;
+static int wrote_text;
 
 extern const struct __imv __start___imv[];
 extern const struct __imv __stop___imv[];
 
+static int stop_machine_imv_update(void *imv_ptr)
+{
+	struct __imv *imv = imv_ptr;
+
+	if (!wrote_text) {
+		text_poke((void *)imv->imv, (void *)imv->var, imv->size);
+		wrote_text = 1;
+		smp_wmb(); /* make sure other cpus see that this has run */
+	} else
+		sync_core();
+
+	flush_icache_range(imv->imv, imv->imv + imv->size);
+
+	return 0;
+}
+
 /*
  * imv_mutex nests inside module_mutex. imv_mutex protects builtin
  * immediates and module immediates.
  */
 static DEFINE_MUTEX(imv_mutex);
 
-static atomic_t wait_sync;
-
-struct ipi_loop_data {
-	long value;
-	const struct __imv *imv;
-} loop_data;
-
-static void ipi_busy_loop(void *arg)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	atomic_dec(&wait_sync);
-	do {
-		/* Make sure the wait_sync gets re-read */
-		smp_mb();
-	} while (atomic_read(&wait_sync) > loop_data.value);
-	atomic_dec(&wait_sync);
-	do {
-		/* Make sure the wait_sync gets re-read */
-		smp_mb();
-	} while (atomic_read(&wait_sync) > 0);
-	/*
-	 * Issuing a synchronizing instruction must be done on each CPU before
-	 * reenabling interrupts after modifying an instruction. Required by
-	 * Intel's errata.
-	 */
-	sync_core();
-	flush_icache_range(loop_data.imv->imv,
-		loop_data.imv->imv + loop_data.imv->size);
-	local_irq_restore(flags);
-}
 
 /**
  * apply_imv_update - update one immediate value
@@ -82,9 +68,6 @@ static void ipi_busy_loop(void *arg)
  */
 static int apply_imv_update(const struct __imv *imv)
 {
-	unsigned long flags;
-	long online_cpus;
-
 	/*
 	 * If the variable and the instruction have the same value, there is
 	 * nothing to do.
@@ -111,30 +94,9 @@ static int apply_imv_update(const struct
 
 	if (imv_early_boot_complete) {
 		kernel_text_lock();
-		get_online_cpus();
-		online_cpus = num_online_cpus();
-		atomic_set(&wait_sync, 2 * online_cpus);
-		loop_data.value = online_cpus;
-		loop_data.imv = imv;
-		smp_call_function(ipi_busy_loop, NULL, 1, 0);
-		local_irq_save(flags);
-		atomic_dec(&wait_sync);
-		do {
-			/* Make sure the wait_sync gets re-read */
-			smp_mb();
-		} while (atomic_read(&wait_sync) > online_cpus);
-		text_poke((void *)imv->imv, (void *)imv->var,
-				imv->size);
-		/*
-		 * Make sure the modified instruction is seen by all CPUs before
-		 * we continue (visible to other CPUs and local interrupts).
-		 */
-		wmb();
-		atomic_dec(&wait_sync);
-		flush_icache_range(imv->imv,
-				imv->imv + imv->size);
-		local_irq_restore(flags);
-		put_online_cpus();
+		wrote_text = 0;
+		stop_machine_run(stop_machine_imv_update, (void *)imv,
+					ALL_CPUS);
 		kernel_text_unlock();
 	} else
 		text_poke_early((void *)imv->imv, (void *)imv->var,

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
