Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbXLUB5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbXLUB5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 20:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbXLUB5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 20:57:43 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:35371 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbXLUB5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 20:57:41 -0500
Message-Id: <20071221015730.129750552@polymtl.ca>
References: <20071221015438.433195466@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 20 Dec 2007 20:55:01 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 23/24] Immediate Values Use Arch NMI and MCE Support
Content-Disposition: inline; filename=immediate-values-use-arch-nmi-mce-support.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 21 Dec 2007 01:57:35 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the architecture agnostic code now replaced by architecture specific,
atomic instruction updates.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/immediate.h |   11 ----
 kernel/immediate.c        |  113 +---------------------------------------------
 2 files changed, 4 insertions(+), 120 deletions(-)

Index: linux-2.6-lttng/kernel/immediate.c
===================================================================
--- linux-2.6-lttng.orig/kernel/immediate.c	2007-11-26 12:48:48.000000000 -0500
+++ linux-2.6-lttng/kernel/immediate.c	2007-11-26 13:01:15.000000000 -0500
@@ -19,9 +19,6 @@
 #include <linux/mutex.h>
 #include <linux/immediate.h>
 #include <linux/memory.h>
-#include <linux/cpu.h>
-
-#include <asm/cacheflush.h>
 
 /*
  * Kernel ready to execute the SMP update that may depend on trap and ipi.
@@ -37,111 +34,6 @@ extern const struct __imv __stop___imv[]
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
-
-/**
- * apply_imv_update - update one immediate value
- * @imv: pointer of type const struct __imv to update
- *
- * Update one immediate value. Must be called with imv_mutex held.
- * It makes sure all CPUs are not executing the modified code by having them
- * busy looping with interrupts disabled.
- * It does _not_ protect against NMI and MCE (could be a problem with Intel's
- * errata if we use immediate values in their code path).
- */
-static int apply_imv_update(const struct __imv *imv)
-{
-	unsigned long flags;
-	long online_cpus;
-
-	/*
-	 * If the variable and the instruction have the same value, there is
-	 * nothing to do.
-	 */
-	switch (imv->size) {
-	case 1:	if (*(uint8_t *)imv->imv
-				== *(uint8_t *)imv->var)
-			return 0;
-		break;
-	case 2:	if (*(uint16_t *)imv->imv
-				== *(uint16_t *)imv->var)
-			return 0;
-		break;
-	case 4:	if (*(uint32_t *)imv->imv
-				== *(uint32_t *)imv->var)
-			return 0;
-		break;
-	case 8:	if (*(uint64_t *)imv->imv
-				== *(uint64_t *)imv->var)
-			return 0;
-		break;
-	default:return -EINVAL;
-	}
-
-	if (imv_early_boot_complete) {
-		kernel_text_lock();
-		lock_cpu_hotplug();
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
-		unlock_cpu_hotplug();
-		kernel_text_unlock();
-	} else
-		text_poke_early((void *)imv->imv, (void *)imv->var,
-				imv->size);
-	return 0;
-}
-
 /**
  * imv_update_range - Update immediate values in a range
  * @begin: pointer to the beginning of the range
@@ -154,9 +46,12 @@ void imv_update_range(const struct __imv
 {
 	const struct __imv *iter;
 	int ret;
+
 	for (iter = begin; iter < end; iter++) {
 		mutex_lock(&imv_mutex);
-		ret = apply_imv_update(iter);
+		kernel_text_lock();
+		ret = arch_imv_update(iter, !imv_early_boot_complete);
+		kernel_text_unlock();
 		if (imv_early_boot_complete && ret)
 			printk(KERN_WARNING
 				"Invalid immediate value. "
Index: linux-2.6-lttng/include/linux/immediate.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/immediate.h	2007-11-26 12:48:48.000000000 -0500
+++ linux-2.6-lttng/include/linux/immediate.h	2007-11-26 12:59:27.000000000 -0500
@@ -12,17 +12,6 @@
 
 #ifdef CONFIG_IMMEDIATE
 
-struct __imv {
-	unsigned long var;	/* Pointer to the identifier variable of the
-				 * immediate value
-				 */
-	unsigned long imv;	/*
-				 * Pointer to the memory location of the
-				 * immediate value within the instruction.
-				 */
-	unsigned char size;	/* Type size. */
-} __attribute__ ((packed));
-
 #include <asm/immediate.h>
 
 /**

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
