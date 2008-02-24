Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbYBXCrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbYBXCrj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 21:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbYBXCr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 21:47:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:15053 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbYBXCr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 21:47:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,396,1199692800"; 
   d="scan'208";a="301207130"
Message-Id: <20080224023547.412501000@linux-os.sc.intel.com>
References: <20080224023547.264625000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Sat, 23 Feb 2008 18:34:39 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [patch 2/2] x86,fpu: lazy allocation of FPU area
Content-Disposition: inline; filename=x86-lazy-fp-allocation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only allocate the FPU area when the application actually uses FPU, i.e., in the
first lazy FPU trap. This could save memory for non-fpu using apps.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---

Index: linux-2.6-x86/arch/x86/kernel/i387.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/i387.c	2008-02-23 18:27:40.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/i387.c	2008-02-23 18:27:41.000000000 -0800
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
 		math_cntxt_size = sizeof(struct i387_fsave_struct);
 #endif
-	init_task.thread.cntxt = alloc_bootmem(math_cntxt_size);
 }
 
 #ifdef CONFIG_X86_64
@@ -105,6 +103,9 @@
 		return;
 	}
 
+	if (!tsk->thread.cntxt)
+                tsk->thread.cntxt = alloc_cntxt_struct();
+
 	if (cpu_has_fxsr) {
 		memset(FXSAVE(tsk), 0, math_cntxt_size);
 		FXSAVE(tsk)->cwd = 0x37f;
Index: linux-2.6-x86/arch/x86/kernel/process.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/process.c	2008-02-23 18:27:40.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/process.c	2008-02-23 18:27:49.000000000 -0800
@@ -8,21 +8,25 @@
 static struct kmem_cache *task_struct_cachep;
 static struct kmem_cache *task_cntxt_cachep;
 
-struct task_struct * alloc_task_struct(void)
+union thread_cntxt *alloc_cntxt_struct(void)
+{
+	return kmem_cache_alloc(task_cntxt_cachep, GFP_KERNEL);
+}
+
+struct task_struct * alloc_task_struct(struct task_struct *src)
 {
 	struct task_struct *tsk;
 	tsk = kmem_cache_alloc(task_struct_cachep, GFP_KERNEL);
-	if (!tsk)
-		return NULL;
-	tsk->thread.cntxt = kmem_cache_alloc(task_cntxt_cachep, GFP_KERNEL);
-	if (!tsk->thread.cntxt)
-		goto error;
-	WARN_ON((unsigned long)tsk->thread.cntxt & 15);
+	if (tsk && src->thread.cntxt) {
+		tsk->thread.cntxt = alloc_cntxt_struct();
+		if (!tsk->thread.cntxt) {
+			kmem_cache_free(task_struct_cachep, tsk);
+			return NULL;
+		}
+		WARN_ON((unsigned long)tsk->thread.cntxt & 15);
+	} else if (tsk)
+		tsk->thread.cntxt = NULL;
 	return tsk;
-
-error:
-	kmem_cache_free(task_struct_cachep, tsk);
-	return NULL;
 }
 
 void memcpy_task_struct(struct task_struct *dst, struct task_struct *src)
@@ -31,13 +35,21 @@
 	ptr = dst->thread.cntxt;
 	*dst = *src;
 	dst->thread.cntxt = ptr;
-	memcpy(dst->thread.cntxt, src->thread.cntxt, math_cntxt_size);
+	if (src->thread.cntxt)
+		memcpy(dst->thread.cntxt, src->thread.cntxt, math_cntxt_size);
+}
+
+void free_cntxt_struct(struct task_struct *tsk)
+{
+	if (tsk->thread.cntxt) {
+		kmem_cache_free(task_cntxt_cachep, tsk->thread.cntxt);
+		tsk->thread.cntxt = NULL;
+	}
 }
 
 void free_task_struct(struct task_struct *tsk)
 {
-	kmem_cache_free(task_cntxt_cachep, tsk->thread.cntxt);
-	tsk->thread.cntxt=NULL;
+	free_cntxt_struct(tsk);
 	kmem_cache_free(task_struct_cachep, tsk);
 }
 
Index: linux-2.6-x86/include/asm-x86/i387.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/i387.h	2008-02-23 18:27:40.000000000 -0800
+++ linux-2.6-x86/include/asm-x86/i387.h	2008-02-23 18:27:41.000000000 -0800
@@ -25,6 +25,7 @@
 extern asmlinkage void math_state_restore(void);
 extern void init_thread_context(void);
 extern unsigned int math_cntxt_size;
+extern union thread_cntxt *alloc_cntxt_struct(void);
 
 extern user_regset_active_fn fpregs_active, xfpregs_active;
 extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get;
Index: linux-2.6-x86/include/asm-x86/processor.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor.h	2008-02-23 18:27:40.000000000 -0800
+++ linux-2.6-x86/include/asm-x86/processor.h	2008-02-23 18:27:41.000000000 -0800
@@ -743,6 +743,8 @@
 	.io_bitmap	= { [0 ... IO_BITMAP_LONGS] = ~0 },		\
 }
 
+extern void free_cntxt_struct(struct task_struct *);
+
 #define start_thread(regs, new_eip, new_esp) do {		\
 	__asm__("movl %0,%%gs": :"r" (0));			\
 	regs->fs = 0;						\
@@ -753,6 +755,7 @@
 	regs->cs = __USER_CS;					\
 	regs->ip = new_eip;					\
 	regs->sp = new_esp;					\
+	free_cntxt_struct(current);				\
 } while (0)
 
 
Index: linux-2.6-x86/include/asm-x86/thread_info.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/thread_info.h	2008-02-23 18:27:40.000000000 -0800
+++ linux-2.6-x86/include/asm-x86/thread_info.h	2008-02-23 18:27:41.000000000 -0800
@@ -6,7 +6,7 @@
 
 #ifndef __ASSEMBLY__
 #define __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
-extern struct task_struct * alloc_task_struct(void);
+extern struct task_struct * alloc_task_struct(struct task_struct *src);
 extern void free_task_struct(struct task_struct *tsk);
 extern void memcpy_task_struct(struct task_struct *dst, struct task_struct *src
 );
Index: linux-2.6-x86/kernel/fork.c
===================================================================
--- linux-2.6-x86.orig/kernel/fork.c	2008-02-23 18:27:40.000000000 -0800
+++ linux-2.6-x86/kernel/fork.c	2008-02-23 18:27:41.000000000 -0800
@@ -85,7 +85,7 @@
 }
 
 #ifndef __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
-# define alloc_task_struct()	kmem_cache_alloc(task_struct_cachep, GFP_KERNEL)
+# define alloc_task_struct(src) kmem_cache_alloc(task_struct_cachep, GFP_KERNEL)
 # define free_task_struct(tsk)	kmem_cache_free(task_struct_cachep, (tsk))
 # define memcpy_task_struct(dst, src) do { *dst = *src; } while (0)
 static struct kmem_cache *task_struct_cachep;
@@ -174,7 +174,7 @@
 
 	prepare_to_copy(orig);
 
-	tsk = alloc_task_struct();
+	tsk = alloc_task_struct(orig);
 	if (!tsk)
 		return NULL;
 

-- 

