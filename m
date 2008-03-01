Return-Path: <linux-kernel-owner+w=401wt.eu-S933676AbYCABTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676AbYCABTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 20:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757219AbYCABTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 20:19:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:18428 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573AbYCABTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 20:19:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,430,1199692800"; 
   d="scan'208";a="213824477"
Message-Id: <20080301005142.156610000@linux-os.sc.intel.com>
References: <20080301005141.997705000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Feb 2008 16:51:19 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
       hch@infradead.org
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [patch 2/2] x86, fpu: lazy allocation of FPU area - v2
Content-Disposition: inline; filename=x86-lazy-fp-allocation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only allocate the FPU area when the application actually uses FPU, i.e., in the
first lazy FPU trap. This could save memory for non-fpu using apps.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---
v2: Ported to x86.git#testing with some name changes.
---

Index: linux-2.6-x86/arch/x86/kernel/i387.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/i387.c	2008-02-29 16:26:08.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/i387.c	2008-02-29 16:26:14.000000000 -0800
@@ -9,7 +9,6 @@
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/regset.h>
-#include <linux/bootmem.h>
 #include <asm/processor.h>
 #include <asm/i387.h>
 #include <asm/math_emu.h>
@@ -67,7 +66,6 @@
 	else
 		xstate_size = sizeof(struct i387_fsave_struct);
 #endif
-	init_task.thread.xstate = alloc_bootmem(xstate_size);
 }
 
 #ifdef CONFIG_X86_64
@@ -105,6 +103,12 @@
 		return;
 	}
 
+	/*
+	 * Memory allocation at the first usage of the FPU and other state.
+	 */
+	if (!tsk->thread.xstate)
+		tsk->thread.xstate = kmem_cache_alloc(task_xstate_cachep, GFP_KERNEL);
+
 	if (cpu_has_fxsr) {
 		struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
 
Index: linux-2.6-x86/arch/x86/kernel/process.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/process.c	2008-02-29 16:26:08.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/process.c	2008-02-29 16:26:14.000000000 -0800
@@ -5,24 +5,33 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 
-static struct kmem_cache *task_xstate_cachep;
+struct kmem_cache *task_xstate_cachep;
 
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
 	*dst = *src;
-	dst->thread.xstate = kmem_cache_alloc(task_xstate_cachep, GFP_KERNEL);
-	if (!dst->thread.xstate)
-		return -ENOMEM;
-	WARN_ON((unsigned long)dst->thread.xstate & 15);
-	memcpy(dst->thread.xstate, src->thread.xstate, xstate_size);
+	if (src->thread.xstate) {
+		dst->thread.xstate = kmem_cache_alloc(task_xstate_cachep, GFP_KERNEL);
+		if (!dst->thread.xstate)
+			return -ENOMEM;
+		WARN_ON((unsigned long)dst->thread.xstate & 15);
+		memcpy(dst->thread.xstate, src->thread.xstate, xstate_size);
+	}
 	return 0;
 }
 
-void free_thread_info(struct thread_info *ti)
+void free_thread_xstate(struct task_struct *tsk)
 {
-	kmem_cache_free(task_xstate_cachep, ti->task->thread.xstate);
-	ti->task->thread.xstate = NULL;
+	if (tsk->thread.xstate) {
+		kmem_cache_free(task_xstate_cachep, tsk->thread.xstate);
+		tsk->thread.xstate = NULL;
+	}
+}
+
 
+void free_thread_info(struct thread_info *ti)
+{
+	free_thread_xstate(ti->task);
 	free_pages((unsigned long)(ti), get_order(THREAD_SIZE));
 }
 
Index: linux-2.6-x86/include/asm-x86/processor.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor.h	2008-02-29 16:26:08.000000000 -0800
+++ linux-2.6-x86/include/asm-x86/processor.h	2008-02-29 16:26:14.000000000 -0800
@@ -354,6 +354,8 @@
 
 extern void print_cpu_info(struct cpuinfo_x86 *);
 extern unsigned int xstate_size;
+extern void free_thread_xstate(struct task_struct *);
+extern struct kmem_cache *task_xstate_cachep;
 extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
Index: linux-2.6-x86/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/process_32.c	2008-02-29 16:26:08.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/process_32.c	2008-02-29 16:26:14.000000000 -0800
@@ -524,6 +524,10 @@
 	regs->cs		= __USER_CS;
 	regs->ip		= new_ip;
 	regs->sp		= new_sp;
+	/*
+	 * Free the old FP and other extended state
+	 */
+	free_thread_xstate(current);
 }
 EXPORT_SYMBOL_GPL(start_thread);
 
Index: linux-2.6-x86/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/process_64.c	2008-02-29 16:26:08.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/process_64.c	2008-02-29 16:26:14.000000000 -0800
@@ -552,6 +552,10 @@
 	regs->ss		= __USER_DS;
 	regs->flags		= 0x200;
 	set_fs(USER_DS);
+	/*
+	 * Free the old FP and other extended state
+	 */
+	free_thread_xstate(current);
 }
 EXPORT_SYMBOL_GPL(start_thread);
 

-- 

