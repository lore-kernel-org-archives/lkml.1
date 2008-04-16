Return-Path: <linux-kernel-owner+w=401wt.eu-S1761021AbYDPVgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761021AbYDPVgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 17:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbYDPVgC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 17:36:02 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:34937 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbYDPVgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 17:36:00 -0400
Message-Id: <20080416213557.075597889@polymtl.ca>
References: <20080416213426.298498397@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 17:34:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 24/27] Immediate Values Use Arch NMI and MCE Support
Content-Disposition: inline; filename=immediate-values-use-arch-nmi-mce-support.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 16 Apr 2008 21:35:57 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the architecture agnostic code now replaced by architecture specific,
atomic instruction updates.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/immediate.h |   11 ------
 kernel/immediate.c        |   73 +---------------------------------------------
 2 files changed, 3 insertions(+), 81 deletions(-)

Index: linux-2.6-lttng/kernel/immediate.c
===================================================================
--- linux-2.6-lttng.orig/kernel/immediate.c	2008-04-11 09:41:33.000000000 -0400
+++ linux-2.6-lttng/kernel/immediate.c	2008-04-14 18:48:05.000000000 -0400
@@ -19,92 +19,23 @@
 #include <linux/mutex.h>
 #include <linux/immediate.h>
 #include <linux/memory.h>
-#include <linux/cpu.h>
-#include <linux/stop_machine.h>
 
 #include <asm/sections.h>
-#include <asm/cacheflush.h>
 
 /*
  * Kernel ready to execute the SMP update that may depend on trap and ipi.
  */
 static int imv_early_boot_complete;
-static int wrote_text;
 
 extern struct __imv __start___imv[];
 extern struct __imv __stop___imv[];
 
-static int stop_machine_imv_update(void *imv_ptr)
-{
-	struct __imv *imv = imv_ptr;
-
-	if (!wrote_text) {
-		text_poke((void *)imv->imv, (void *)imv->var, imv->size);
-		wrote_text = 1;
-		smp_wmb(); /* make sure other cpus see that this has run */
-	} else
-		sync_core();
-
-	flush_icache_range(imv->imv, imv->imv + imv->size);
-
-	return 0;
-}
-
 /*
  * imv_mutex nests inside module_mutex. imv_mutex protects builtin
  * immediates and module immediates.
  */
 static DEFINE_MUTEX(imv_mutex);
 
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
-		wrote_text = 0;
-		stop_machine_run(stop_machine_imv_update, (void *)imv,
-					ALL_CPUS);
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
@@ -121,7 +52,9 @@ void imv_update_range(const struct __imv
 		mutex_lock(&imv_mutex);
 		if (!iter->imv)	/* Skip removed __init immediate values */
 			goto skip;
-		ret = apply_imv_update(iter);
+		kernel_text_lock();
+		ret = arch_imv_update(iter, !imv_early_boot_complete);
+		kernel_text_unlock();
 		if (imv_early_boot_complete && ret)
 			printk(KERN_WARNING
 				"Invalid immediate value. "
Index: linux-2.6-lttng/include/linux/immediate.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/immediate.h	2008-04-11 09:36:58.000000000 -0400
+++ linux-2.6-lttng/include/linux/immediate.h	2008-04-14 18:46:47.000000000 -0400
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
