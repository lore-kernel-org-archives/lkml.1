Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbYE2I5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbYE2I5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbYE2I4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:56:06 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17902 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbYE2Iz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:55:56 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, npiggin@suse.de, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
       Jens Axboe <jens.axboe@oracle.com>,
       Hirokazu Takata <takata@linux-m32r.org>
Subject: [PATCH 7/10] m32r: convert to generic helpers for IPI function calls
Date: Thu, 29 May 2008 10:58:21 +0200
Message-Id: <1212051504-12561-8-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.6.rc0.40.gd683
In-Reply-To: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com>
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts m32r to use the new helpers for smp_call_function() and
friends, and adds support for smp_call_function_single(). Not tested,
not even compiled.

Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/m32r/Kconfig             |    1 +
 arch/m32r/kernel/m32r_ksyms.c |    3 -
 arch/m32r/kernel/smp.c        |  128 ++++------------------------------------
 arch/m32r/kernel/traps.c      |    3 +-
 include/asm-m32r/smp.h        |    1 +
 5 files changed, 17 insertions(+), 119 deletions(-)

diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index de153de..a5f864c 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -296,6 +296,7 @@ config PREEMPT
 
 config SMP
 	bool "Symmetric multi-processing support"
+	select USE_GENERIC_SMP_HELPERS
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff --git a/arch/m32r/kernel/m32r_ksyms.c b/arch/m32r/kernel/m32r_ksyms.c
index e6709fe..16bcb18 100644
--- a/arch/m32r/kernel/m32r_ksyms.c
+++ b/arch/m32r/kernel/m32r_ksyms.c
@@ -43,9 +43,6 @@ EXPORT_SYMBOL(dcache_dummy);
 #endif
 EXPORT_SYMBOL(cpu_data);
 
-/* Global SMP stuff */
-EXPORT_SYMBOL(smp_call_function);
-
 /* TLB flushing */
 EXPORT_SYMBOL(smp_flush_tlb_page);
 #endif
diff --git a/arch/m32r/kernel/smp.c b/arch/m32r/kernel/smp.c
index c837bc1..74eb7bc 100644
--- a/arch/m32r/kernel/smp.c
+++ b/arch/m32r/kernel/smp.c
@@ -35,22 +35,6 @@
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 
 /*
- * Structure and data for smp_call_function(). This is designed to minimise
- * static memory requirements. It also looks cleaner.
- */
-static DEFINE_SPINLOCK(call_lock);
-
-struct call_data_struct {
-	void (*func) (void *info);
-	void *info;
-	atomic_t started;
-	atomic_t finished;
-	int wait;
-} __attribute__ ((__aligned__(SMP_CACHE_BYTES)));
-
-static struct call_data_struct *call_data;
-
-/*
  * For flush_cache_all()
  */
 static DEFINE_SPINLOCK(flushcache_lock);
@@ -96,9 +80,6 @@ void smp_invalidate_interrupt(void);
 void smp_send_stop(void);
 static void stop_this_cpu(void *);
 
-int smp_call_function(void (*) (void *), void *, int, int);
-void smp_call_function_interrupt(void);
-
 void smp_send_timer(void);
 void smp_ipi_timer_interrupt(struct pt_regs *);
 void smp_local_timer_interrupt(void);
@@ -565,86 +546,14 @@ static void stop_this_cpu(void *dummy)
 	for ( ; ; );
 }
 
-/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
-/* Call function Routines                                                    */
-/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
-
-/*==========================================================================*
- * Name:         smp_call_function
- *
- * Description:  This routine sends a 'CALL_FUNCTION_IPI' to all other CPUs
- *               in the system.
- *
- * Born on Date: 2002.02.05
- *
- * Arguments:    *func - The function to run. This must be fast and
- *                       non-blocking.
- *               *info - An arbitrary pointer to pass to the function.
- *               nonatomic - currently unused.
- *               wait - If true, wait (atomically) until function has
- *                      completed on other CPUs.
- *
- * Returns:      0 on success, else a negative status code. Does not return
- *               until remote CPUs are nearly ready to execute <<func>> or
- *               are or have executed.
- *
- * Cautions:     You must not call this function with disabled interrupts or
- *               from a hardware interrupt handler, you may call it from a
- *               bottom half handler.
- *
- * Modification log:
- * Date       Who Description
- * ---------- --- --------------------------------------------------------
- *
- *==========================================================================*/
-int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
-	int wait)
+void arch_send_call_function_ipi(cpumask_t mask)
 {
-	struct call_data_struct data;
-	int cpus;
-
-#ifdef DEBUG_SMP
-	unsigned long flags;
-	__save_flags(flags);
-	if (!(flags & 0x0040))	/* Interrupt Disable NONONO */
-		BUG();
-#endif /* DEBUG_SMP */
-
-	/* Holding any lock stops cpus from going down. */
-	spin_lock(&call_lock);
-	cpus = num_online_cpus() - 1;
-
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
-	mb();
-
-	/* Send a message to all other CPUs and wait for them to respond */
-	send_IPI_allbutself(CALL_FUNCTION_IPI, 0);
-
-	/* Wait for response */
-	while (atomic_read(&data.started) != cpus)
-		barrier();
-
-	if (wait)
-		while (atomic_read(&data.finished) != cpus)
-			barrier();
-	spin_unlock(&call_lock);
+	send_IPI_mask(mask, CALL_FUNCTION_IPI, 0);
+}
 
-	return 0;
+void arch_send_call_function_single_ipi(int cpu)
+{
+	send_IPI_mask(cpumask_of_cpu(cpu), CALL_FUNC_SINGLE_IPI, 0);
 }
 
 /*==========================================================================*
@@ -666,27 +575,16 @@ int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
  *==========================================================================*/
 void smp_call_function_interrupt(void)
 {
-	void (*func) (void *info) = call_data->func;
-	void *info = call_data->info;
-	int wait = call_data->wait;
-
-	/*
-	 * Notify initiating CPU that I've grabbed the data and am
-	 * about to execute the function
-	 */
-	mb();
-	atomic_inc(&call_data->started);
-	/*
-	 * At this point the info structure may be out of scope unless wait==1
-	 */
 	irq_enter();
-	(*func)(info);
+	generic_smp_call_function_interrupt();
 	irq_exit();
+}
 
-	if (wait) {
-		mb();
-		atomic_inc(&call_data->finished);
-	}
+void smp_call_function_single_interrupt(void)
+{
+	irq_enter();
+	generic_smp_call_function_single_interrupt();
+	irq_exit();
 }
 
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
diff --git a/arch/m32r/kernel/traps.c b/arch/m32r/kernel/traps.c
index 89ba4a0..46159a4 100644
--- a/arch/m32r/kernel/traps.c
+++ b/arch/m32r/kernel/traps.c
@@ -40,6 +40,7 @@ extern void smp_invalidate_interrupt(void);
 extern void smp_call_function_interrupt(void);
 extern void smp_ipi_timer_interrupt(void);
 extern void smp_flush_cache_all_interrupt(void);
+extern void smp_call_function_single_interrupt(void);
 
 /*
  * for Boot AP function
@@ -103,7 +104,7 @@ void	set_eit_vector_entries(void)
 	eit_vector[186] = (unsigned long)smp_call_function_interrupt;
 	eit_vector[187] = (unsigned long)smp_ipi_timer_interrupt;
 	eit_vector[188] = (unsigned long)smp_flush_cache_all_interrupt;
-	eit_vector[189] = 0;
+	eit_vector[189] = (unsigned long)smp_call_function_single_interrupt;
 	eit_vector[190] = 0;
 	eit_vector[191] = 0;
 #endif
diff --git a/include/asm-m32r/smp.h b/include/asm-m32r/smp.h
index 078e1a5..6a7f3af 100644
--- a/include/asm-m32r/smp.h
+++ b/include/asm-m32r/smp.h
@@ -104,6 +104,7 @@ extern unsigned long send_IPI_mask_phys(cpumask_t, int, int);
 #define LOCAL_TIMER_IPI		(M32R_IRQ_IPI3-M32R_IRQ_IPI0)
 #define INVALIDATE_CACHE_IPI	(M32R_IRQ_IPI4-M32R_IRQ_IPI0)
 #define CPU_BOOT_IPI		(M32R_IRQ_IPI5-M32R_IRQ_IPI0)
+#define CALL_FUNC_SINGLE_IPI	(M32R_IRQ_IPI6-M32R_IRQ_IPI0)
 
 #define IPI_SHIFT	(0)
 #define NR_IPIS		(8)
-- 
1.5.6.rc0.40.gd683

