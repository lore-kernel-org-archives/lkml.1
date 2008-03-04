Return-Path: <linux-kernel-owner+w=401wt.eu-S934495AbYCDXyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934495AbYCDXyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:54:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbYCDXxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:53:51 -0500
Received: from mga03.intel.com ([143.182.124.21]:25887 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbYCDXxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:53:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,444,1199692800"; 
   d="scan'208";a="214889293"
Message-Id: <20080304234003.752305000@linux-os.sc.intel.com>
References: <20080304234003.603501000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 04 Mar 2008 15:37:43 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
       hch@infradead.org
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [patch 2/2] x86, fpu: lazy allocation of FPU area - v4
Content-Disposition: inline; filename=x86-lazy-fp-allocation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only allocate the FPU area when the application actually uses FPU, i.e., in the
first lazy FPU trap. This could save memory for non-fpu using apps.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---
v4: Handles the kmem_cache_alloc() failures.
v3: Fixed the non-atomic calling sequence in atomic context.
v2: Ported to x86.git#testing with some name changes.
---

Index: linux-2.6-x86/arch/x86/kernel/i387.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/i387.c	2008-03-04 15:31:56.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/i387.c	2008-03-04 15:31:57.000000000 -0800
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
@@ -97,12 +95,22 @@
  * value at reset if we support XMM instructions and then
  * remeber the current task has used the FPU.
  */
-void init_fpu(struct task_struct *tsk)
+int init_fpu(struct task_struct *tsk)
 {
 	if (tsk_used_math(tsk)) {
 		if (tsk == current)
 			unlazy_fpu(tsk);
-		return;
+		return 0;
+	}
+
+	/*
+	 * Memory allocation at the first usage of the FPU and other state.
+	 */
+	if (!tsk->thread.xstate) {
+		tsk->thread.xstate = kmem_cache_alloc(task_xstate_cachep,
+						      GFP_KERNEL);
+		if (!tsk->thread.xstate)
+			return -ENOMEM;
 	}
 
 	if (cpu_has_fxsr) {
@@ -124,6 +132,7 @@
 	 * Only the device not available exception or ptrace can call init_fpu.
 	 */
 	set_stopped_child_used_math(tsk);
+	return 0;
 }
 
 int fpregs_active(struct task_struct *target, const struct user_regset *regset)
@@ -140,10 +149,14 @@
 		unsigned int pos, unsigned int count,
 		void *kbuf, void __user *ubuf)
 {
+	int ret;
+
 	if (!cpu_has_fxsr)
 		return -ENODEV;
 
-	init_fpu(target);
+	ret = init_fpu(target);
+	if (ret)
+		return ret;
 
 	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
 				   &target->thread.xstate->fxsave, 0, -1);
@@ -158,7 +171,10 @@
 	if (!cpu_has_fxsr)
 		return -ENODEV;
 
-	init_fpu(target);
+	ret = init_fpu(target);
+	if (ret)
+		return ret;
+
 	set_stopped_child_used_math(target);
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
@@ -314,11 +330,14 @@
 	       void *kbuf, void __user *ubuf)
 {
 	struct user_i387_ia32_struct env;
+	int ret;
 
 	if (!HAVE_HWFP)
 		return fpregs_soft_get(target, regset, pos, count, kbuf, ubuf);
 
-	init_fpu(target);
+	ret = init_fpu(target);
+	if (ret)
+		return ret;
 
 	if (!cpu_has_fxsr)
 		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
@@ -343,7 +362,10 @@
 	if (!HAVE_HWFP)
 		return fpregs_soft_set(target, regset, pos, count, kbuf, ubuf);
 
-	init_fpu(target);
+	ret = init_fpu(target);
+	if (ret)
+		return ret;
+
 	set_stopped_child_used_math(target);
 
 	if (!cpu_has_fxsr)
Index: linux-2.6-x86/arch/x86/kernel/process.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/process.c	2008-03-04 15:31:56.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/process.c	2008-03-04 15:32:23.000000000 -0800
@@ -5,24 +5,34 @@
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
+		dst->thread.xstate = kmem_cache_alloc(task_xstate_cachep,
+						      GFP_KERNEL);
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
--- linux-2.6-x86.orig/include/asm-x86/processor.h	2008-03-04 15:31:56.000000000 -0800
+++ linux-2.6-x86/include/asm-x86/processor.h	2008-03-04 15:31:57.000000000 -0800
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
--- linux-2.6-x86.orig/arch/x86/kernel/process_32.c	2008-03-04 15:31:56.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/process_32.c	2008-03-04 15:31:57.000000000 -0800
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
--- linux-2.6-x86.orig/arch/x86/kernel/process_64.c	2008-03-04 15:31:56.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/process_64.c	2008-03-04 15:31:57.000000000 -0800
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
 
Index: linux-2.6-x86/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/traps_32.c	2008-03-04 15:31:56.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/traps_32.c	2008-03-04 15:31:57.000000000 -0800
@@ -1168,9 +1168,23 @@
 	struct thread_info *thread = current_thread_info();
 	struct task_struct *tsk = thread->task;
 
+	if (!tsk_used_math(tsk)) {
+#ifdef CONFIG_PREEMPT
+		local_irq_enable();
+#endif
+		/*
+		 * does a slab alloc which can sleep
+		 */
+		if (init_fpu(tsk)) {
+			force_sig(SIGSEGV, tsk);
+			return;
+		}
+#ifdef CONFIG_PREEMPT
+		local_irq_disable();
+#endif
+	}
+
 	clts();				/* Allow maths ops (or we recurse) */
-	if (!tsk_used_math(tsk))
-		init_fpu(tsk);
 	restore_fpu(tsk);
 	thread->status |= TS_USEDFPU;	/* So we fnsave on switch_to() */
 	tsk->fpu_counter++;
Index: linux-2.6-x86/arch/x86/kernel/traps_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/traps_64.c	2008-03-04 15:31:56.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/traps_64.c	2008-03-04 15:31:57.000000000 -0800
@@ -1117,10 +1117,15 @@
 asmlinkage void math_state_restore(void)
 {
 	struct task_struct *me = current;
-	clts();			/* Allow maths ops (or we recurse) */
 
-	if (!used_math())
-		init_fpu(me);
+	if (!used_math()) {
+		if (init_fpu(me)) {
+			force_sig(SIGSEGV, me);
+			return;
+		}
+	}
+
+	clts();			/* Allow maths ops (or we recurse) */
 	restore_fpu_checking(&me->thread.xstate->fxsave);
 	task_thread_info(me)->status |= TS_USEDFPU;
 	me->fpu_counter++;
Index: linux-2.6-x86/include/asm-x86/i387.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/i387.h	2008-03-04 15:31:56.000000000 -0800
+++ linux-2.6-x86/include/asm-x86/i387.h	2008-03-04 15:31:57.000000000 -0800
@@ -21,7 +21,7 @@
 
 extern void fpu_init(void);
 extern void mxcsr_feature_mask_init(void);
-extern void init_fpu(struct task_struct *child);
+extern int init_fpu(struct task_struct *child);
 extern asmlinkage void math_state_restore(void);
 extern void init_thread_xstate(void);
 

-- 

