Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbYBXCr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbYBXCr5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 21:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYBXCrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 21:47:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:15053 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbYBXCr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 21:47:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,396,1199692800"; 
   d="scan'208";a="301207132"
Message-Id: <20080224023547.264625000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Sat, 23 Feb 2008 18:34:38 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [patch 1/2] x86,fpu: split FPU state from task struct
Content-Disposition: inline; filename=x86-split-fp-from-task-struct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the FPU save area from the task struct. This allows easy migration
of FPU context, and it's generally cleaner. It also allows the following
two optimizations:

1) only allocate when the application actually uses FPU, so in the first
lazy FPU trap. This could save memory for non-fpu using apps. Next patch
does this lazy allocation.

2) allocate the right size for the actual cpu rather than 512 bytes always.
Patches enabling xsave/xrstor support (coming shortly) will take advantage
of this.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---

Index: linux-2.6-x86/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/process_64.c	2008-02-22 18:33:17.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/process_64.c	2008-02-23 15:04:30.000000000 -0800
@@ -630,7 +630,7 @@
 
 	/* we're going to use this soon, after a few expensive things */
 	if (next_p->fpu_counter>5)
-		prefetch(&next->i387.fxsave);
+		prefetch(FXSAVE(next_p));
 
 	/*
 	 * Reload esp0, LDT and the page table pointer:
Index: linux-2.6-x86/arch/x86/kernel/traps_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/traps_64.c	2008-02-22 18:33:17.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/traps_64.c	2008-02-23 15:04:30.000000000 -0800
@@ -1118,7 +1118,7 @@
 
 	if (!used_math())
 		init_fpu(me);
-	restore_fpu_checking(&me->thread.i387.fxsave);
+	restore_fpu_checking(FXSAVE(me));
 	task_thread_info(me)->status |= TS_USEDFPU;
 	me->fpu_counter++;
 }
@@ -1154,6 +1154,10 @@
 #endif
        
 	/*
+	 * initialize the per thread FP context:
+	 */
+        init_thread_context();
+	/*
 	 * Should be a barrier for any external CPU state.
 	 */
 	cpu_init();
Index: linux-2.6-x86/kernel/fork.c
===================================================================
--- linux-2.6-x86.orig/kernel/fork.c	2008-02-23 15:03:35.000000000 -0800
+++ linux-2.6-x86/kernel/fork.c	2008-02-23 15:08:53.000000000 -0800
@@ -87,6 +87,7 @@
 #ifndef __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
 # define alloc_task_struct()	kmem_cache_alloc(task_struct_cachep, GFP_KERNEL)
 # define free_task_struct(tsk)	kmem_cache_free(task_struct_cachep, (tsk))
+# define memcpy_task_struct(dst, src) do { *dst = *src; } while (0)
 static struct kmem_cache *task_struct_cachep;
 #endif
 
@@ -142,6 +143,8 @@
 	task_struct_cachep =
 		kmem_cache_create("task_struct", sizeof(struct task_struct),
 			ARCH_MIN_TASKALIGN, SLAB_PANIC, NULL);
+#else
+ 	task_struct_slab_init();
 #endif
 
 	/*
@@ -181,7 +184,8 @@
 		return NULL;
 	}
 
-	*tsk = *orig;
+ 	memcpy_task_struct(tsk, orig);
+
 	tsk->stack = ti;
 
 	err = prop_local_init_single(&tsk->dirties);
Index: linux-2.6-x86/arch/x86/kernel/i387.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/i387.c	2008-02-23 15:03:35.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/i387.c	2008-02-23 15:08:53.000000000 -0800
@@ -9,6 +9,7 @@
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/regset.h>
+#include <linux/bootmem.h>
 #include <asm/processor.h>
 #include <asm/i387.h>
 #include <asm/math_emu.h>
@@ -40,16 +41,17 @@
 #endif
 
 static unsigned int mxcsr_feature_mask __read_mostly = 0xffffffffu;
+unsigned int math_cntxt_size;
+static struct i387_fxsave_struct fx_scratch __cpuinitdata;
 
-void mxcsr_feature_mask_init(void)
+void __cpuinit mxcsr_feature_mask_init(void)
 {
 	unsigned long mask = 0;
 	clts();
 	if (cpu_has_fxsr) {
-		memset(&current->thread.i387.fxsave, 0,
-		       sizeof(struct i387_fxsave_struct));
-		asm volatile("fxsave %0" : : "m" (current->thread.i387.fxsave));
-		mask = current->thread.i387.fxsave.mxcsr_mask;
+		memset(&fx_scratch, 0, sizeof(struct i387_fxsave_struct));
+		asm volatile("fxsave %0" : : "m" (fx_scratch));
+		mask = fx_scratch.mxcsr_mask;
 		if (mask == 0)
 			mask = 0x0000ffbf;
 	}
@@ -57,6 +59,17 @@
 	stts();
 }
 
+void __init init_thread_context(void)
+{
+	if (cpu_has_fxsr)
+		math_cntxt_size = sizeof(struct i387_fxsave_struct);
+#ifdef CONFIG_X86_32
+	else
+		math_cntxt_size = sizeof(struct i387_fsave_struct);
+#endif
+	init_task.thread.cntxt = alloc_bootmem(math_cntxt_size);
+}
+
 #ifdef CONFIG_X86_64
 /*
  * Called at bootup to set up the initial FPU state that is later cloned
@@ -65,10 +78,7 @@
 void __cpuinit fpu_init(void)
 {
 	unsigned long oldcr0 = read_cr0();
-	extern void __bad_fxsave_alignment(void);
 
-	if (offsetof(struct task_struct, thread.i387.fxsave) & 15)
-		__bad_fxsave_alignment();
 	set_in_cr4(X86_CR4_OSFXSR);
 	set_in_cr4(X86_CR4_OSXMMEXCPT);
 
@@ -96,18 +106,16 @@
 	}
 
 	if (cpu_has_fxsr) {
-		memset(&tsk->thread.i387.fxsave, 0,
-		       sizeof(struct i387_fxsave_struct));
-		tsk->thread.i387.fxsave.cwd = 0x37f;
+		memset(FXSAVE(tsk), 0, math_cntxt_size);
+		FXSAVE(tsk)->cwd = 0x37f;
 		if (cpu_has_xmm)
-			tsk->thread.i387.fxsave.mxcsr = MXCSR_DEFAULT;
+			FXSAVE(tsk)->mxcsr = MXCSR_DEFAULT;
 	} else {
-		memset(&tsk->thread.i387.fsave, 0,
-		       sizeof(struct i387_fsave_struct));
-		tsk->thread.i387.fsave.cwd = 0xffff037fu;
-		tsk->thread.i387.fsave.swd = 0xffff0000u;
-		tsk->thread.i387.fsave.twd = 0xffffffffu;
-		tsk->thread.i387.fsave.fos = 0xffff0000u;
+		memset(FSAVE(tsk), 0, math_cntxt_size);
+		FSAVE(tsk)->cwd = 0xffff037fu;
+		FSAVE(tsk)->swd = 0xffff0000u;
+		FSAVE(tsk)->twd = 0xffffffffu;
+		FSAVE(tsk)->fos = 0xffff0000u;
 	}
 	/*
 	 * Only the device not available exception or ptrace can call init_fpu.
@@ -135,7 +143,7 @@
 	unlazy_fpu(target);
 
 	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-				   &target->thread.i387.fxsave, 0, -1);
+				   FXSAVE(target), 0, -1);
 }
 
 int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
@@ -151,12 +159,12 @@
 	set_stopped_child_used_math(target);
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-				 &target->thread.i387.fxsave, 0, -1);
+				 FXSAVE(target), 0, -1);
 
 	/*
 	 * mxcsr reserved bits must be masked to zero for security reasons.
 	 */
-	target->thread.i387.fxsave.mxcsr &= mxcsr_feature_mask;
+	FXSAVE(target)->mxcsr &= mxcsr_feature_mask;
 
 	return ret;
 }
@@ -235,7 +243,7 @@
 static void convert_from_fxsr(struct user_i387_ia32_struct *env,
 			      struct task_struct *tsk)
 {
-	struct i387_fxsave_struct *fxsave = &tsk->thread.i387.fxsave;
+	struct i387_fxsave_struct *fxsave = FXSAVE(tsk);
 	struct _fpreg *to = (struct _fpreg *) &env->st_space[0];
 	struct _fpxreg *from = (struct _fpxreg *) &fxsave->st_space[0];
 	int i;
@@ -274,7 +282,7 @@
 			    const struct user_i387_ia32_struct *env)
 
 {
-	struct i387_fxsave_struct *fxsave = &tsk->thread.i387.fxsave;
+	struct i387_fxsave_struct *fxsave = FXSAVE(tsk);
 	struct _fpreg *from = (struct _fpreg *) &env->st_space[0];
 	struct _fpxreg *to = (struct _fpxreg *) &fxsave->st_space[0];
 	int i;
@@ -311,7 +319,7 @@
 
 	if (!cpu_has_fxsr)
 		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-					   &target->thread.i387.fsave, 0, -1);
+					   FSAVE(target), 0, -1);
 
 	if (kbuf && pos == 0 && count == sizeof(env)) {
 		convert_from_fxsr(kbuf, target);
@@ -337,7 +345,7 @@
 
 	if (!cpu_has_fxsr)
 		return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-					  &target->thread.i387.fsave, 0, -1);
+					  FSAVE(target), 0, -1);
 
 	if (pos > 0 || count < sizeof(env))
 		convert_from_fxsr(&env, target);
@@ -358,8 +366,8 @@
 	struct task_struct *tsk = current;
 
 	unlazy_fpu(tsk);
-	tsk->thread.i387.fsave.status = tsk->thread.i387.fsave.swd;
-	if (__copy_to_user(buf, &tsk->thread.i387.fsave,
+	FSAVE(tsk)->status = FSAVE(tsk)->swd;
+	if (__copy_to_user(buf, FSAVE(tsk),
 			   sizeof(struct i387_fsave_struct)))
 		return -1;
 	return 1;
@@ -377,12 +385,12 @@
 	if (__copy_to_user(buf, &env, sizeof(env)))
 		return -1;
 
-	err |= __put_user(tsk->thread.i387.fxsave.swd, &buf->status);
+	err |= __put_user(FXSAVE(tsk)->swd, &buf->status);
 	err |= __put_user(X86_FXSR_MAGIC, &buf->magic);
 	if (err)
 		return -1;
 
-	if (__copy_to_user(&buf->_fxsr_env[0], &tsk->thread.i387.fxsave,
+	if (__copy_to_user(&buf->_fxsr_env[0], FXSAVE(tsk),
 			   sizeof(struct i387_fxsave_struct)))
 		return -1;
 	return 1;
@@ -415,7 +423,7 @@
 {
 	struct task_struct *tsk = current;
 	clear_fpu(tsk);
-	return __copy_from_user(&tsk->thread.i387.fsave, buf,
+	return __copy_from_user(FSAVE(tsk), buf,
 				sizeof(struct i387_fsave_struct));
 }
 
@@ -425,10 +433,10 @@
 	struct task_struct *tsk = current;
 	struct user_i387_ia32_struct env;
 	clear_fpu(tsk);
-	err = __copy_from_user(&tsk->thread.i387.fxsave, &buf->_fxsr_env[0],
+	err = __copy_from_user(FXSAVE(tsk), &buf->_fxsr_env[0],
 			       sizeof(struct i387_fxsave_struct));
 	/* mxcsr reserved bits must be masked to zero for security reasons */
-	tsk->thread.i387.fxsave.mxcsr &= mxcsr_feature_mask;
+	FXSAVE(tsk)->mxcsr &= mxcsr_feature_mask;
 	if (err || __copy_from_user(&env, buf, sizeof(env)))
 		return 1;
 	convert_to_fxsr(tsk, &env);
Index: linux-2.6-x86/include/asm-x86/i387.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/i387.h	2008-02-23 15:03:35.000000000 -0800
+++ linux-2.6-x86/include/asm-x86/i387.h	2008-02-23 15:08:58.000000000 -0800
@@ -23,6 +23,8 @@
 extern void mxcsr_feature_mask_init(void);
 extern void init_fpu(struct task_struct *child);
 extern asmlinkage void math_state_restore(void);
+extern void init_thread_context(void);
+extern unsigned int math_cntxt_size;
 
 extern user_regset_active_fn fpregs_active, xfpregs_active;
 extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get;
@@ -34,6 +36,9 @@
 extern int restore_i387_ia32(struct _fpstate_ia32 __user *buf);
 #endif
 
+#define FSAVE(t)	(&(t->thread.cntxt->fsave))
+#define FXSAVE(t)	(&(t->thread.cntxt->fxsave))
+
 #ifdef CONFIG_X86_64
 
 /* Ignore delayed exceptions from user space */
@@ -116,24 +121,22 @@
 	/* Using "fxsaveq %0" would be the ideal choice, but is only supported
 	   starting with gas 2.16. */
 	__asm__ __volatile__("fxsaveq %0"
-			     : "=m" (tsk->thread.i387.fxsave));
+			     : "=m" (*FXSAVE(tsk)));
 #elif 0
 	/* Using, as a workaround, the properly prefixed form below isn't
 	   accepted by any binutils version so far released, complaining that
 	   the same type of prefix is used twice if an extended register is
 	   needed for addressing (fix submitted to mainline 2005-11-21). */
 	__asm__ __volatile__("rex64/fxsave %0"
-			     : "=m" (tsk->thread.i387.fxsave));
+			     : "=m" (*FXSAVE(tsk)));
 #else
 	/* This, however, we can work around by forcing the compiler to select
 	   an addressing mode that doesn't require extended registers. */
-	__asm__ __volatile__("rex64/fxsave %P2(%1)"
-			     : "=m" (tsk->thread.i387.fxsave)
-			     : "cdaSDb" (tsk),
-				"i" (offsetof(__typeof__(*tsk),
-					      thread.i387.fxsave)));
+	__asm__ __volatile__("rex64/fxsave (%1)"
+			     : "=m" (*FXSAVE(tsk))
+			     : "cdaSDb" (FXSAVE(tsk)));
 #endif
-	clear_fpu_state(&tsk->thread.i387.fxsave);
+	clear_fpu_state(FXSAVE(tsk));
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
@@ -147,7 +150,7 @@
 	int err = 0;
 
 	BUILD_BUG_ON(sizeof(struct user_i387_struct) !=
-			sizeof(tsk->thread.i387.fxsave));
+			sizeof(*FXSAVE(tsk)));
 
 	if ((unsigned long)buf % 16)
 		printk("save_i387: bad fpstate %p\n", buf);
@@ -161,7 +164,7 @@
 		task_thread_info(tsk)->status &= ~TS_USEDFPU;
 		stts();
 	} else {
-		if (__copy_to_user(buf, &tsk->thread.i387.fxsave,
+		if (__copy_to_user(buf, FXSAVE(tsk),
 				   sizeof(struct i387_fxsave_struct)))
 			return -1;
 	}
@@ -198,7 +201,7 @@
 		"nop ; frstor %1",
 		"fxrstor %1",
 		X86_FEATURE_FXSR,
-		"m" ((tsk)->thread.i387.fxsave));
+		"m" (*FXSAVE(tsk)));
 }
 
 /* We need a safe address that is cheap to find and that is already
@@ -222,8 +225,8 @@
 		"fxsave %[fx]\n"
 		"bt $7,%[fsw] ; jnc 1f ; fnclex\n1:",
 		X86_FEATURE_FXSR,
-		[fx] "m" (tsk->thread.i387.fxsave),
-		[fsw] "m" (tsk->thread.i387.fxsave.swd) : "memory");
+		[fx] "m" (*FXSAVE(tsk)),
+		[fsw] "m" (FXSAVE(tsk)->swd) : "memory");
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
 	   values. safe_address is a random variable that should be in L1 */
@@ -324,25 +327,25 @@
 static inline unsigned short get_fpu_cwd(struct task_struct *tsk)
 {
 	if (cpu_has_fxsr) {
-		return tsk->thread.i387.fxsave.cwd;
+		return FXSAVE(tsk)->cwd;
 	} else {
-		return (unsigned short)tsk->thread.i387.fsave.cwd;
+		return (unsigned short)FSAVE(tsk)->cwd;
 	}
 }
 
 static inline unsigned short get_fpu_swd(struct task_struct *tsk)
 {
 	if (cpu_has_fxsr) {
-		return tsk->thread.i387.fxsave.swd;
+		return FXSAVE(tsk)->swd;
 	} else {
-		return (unsigned short)tsk->thread.i387.fsave.swd;
+		return (unsigned short)FSAVE(tsk)->swd;
 	}
 }
 
 static inline unsigned short get_fpu_mxcsr(struct task_struct *tsk)
 {
 	if (cpu_has_xmm) {
-		return tsk->thread.i387.fxsave.mxcsr;
+		return FXSAVE(tsk)->mxcsr;
 	} else {
 		return MXCSR_DEFAULT;
 	}
Index: linux-2.6-x86/include/asm-x86/processor.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor.h	2008-02-23 15:03:35.000000000 -0800
+++ linux-2.6-x86/include/asm-x86/processor.h	2008-02-23 15:08:53.000000000 -0800
@@ -295,7 +295,7 @@
 	u32	entry_eip;
 };
 
-union i387_union {
+union thread_cntxt {
 	struct i387_fsave_struct	fsave;
 	struct i387_fxsave_struct	fxsave;
 	struct i387_soft_struct 	soft;
@@ -307,6 +307,8 @@
 DECLARE_PER_CPU(struct orig_ist, orig_ist);
 #endif
 
+extern unsigned int math_cntxt_size;
+extern void init_thread_context(void);
 extern void print_cpu_info(struct cpuinfo_x86 *);
 extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
@@ -335,8 +337,8 @@
 	unsigned long	debugreg7;
 /* fault info */
 	unsigned long	cr2, trap_no, error_code;
-/* floating point info */
-	union i387_union	i387 __attribute__((aligned(16)));;
+/* floating point and other thread cntxt info */
+	union thread_cntxt *cntxt;
 #ifdef CONFIG_X86_32
 /* virtual 86 mode info */
 	struct vm86_struct __user *vm86_info;
Index: linux-2.6-x86/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/process_32.c	2008-02-22 18:33:17.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/process_32.c	2008-02-23 15:04:30.000000000 -0800
@@ -681,7 +681,7 @@
 
 	/* we're going to use this soon, after a few expensive things */
 	if (next_p->fpu_counter > 5)
-		prefetch(&next->i387.fxsave);
+		prefetch(FXSAVE(next_p));
 
 	/*
 	 * Reload esp0.
Index: linux-2.6-x86/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/traps_32.c	2008-02-22 18:33:17.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/traps_32.c	2008-02-23 15:04:30.000000000 -0800
@@ -1176,11 +1176,6 @@
 #endif
 	set_trap_gate(19,&simd_coprocessor_error);
 
-	/*
-	 * Verify that the FXSAVE/FXRSTOR data will be 16-byte aligned.
-	 * Generate a build-time error if the alignment is wrong.
-	 */
-	BUILD_BUG_ON(offsetof(struct task_struct, thread.i387.fxsave) & 15);
 	if (cpu_has_fxsr) {
 		printk(KERN_INFO "Enabling fast FPU save and restore... ");
 		set_in_cr4(X86_CR4_OSFXSR);
@@ -1200,6 +1195,7 @@
 		set_bit(i, used_vectors);
 	set_bit(SYSCALL_VECTOR, used_vectors);
 
+	init_thread_context();
 	/*
 	 * Should be a barrier for any external CPU state.
 	 */
Index: linux-2.6-x86/include/asm-x86/thread_info.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/thread_info.h	2008-02-23 15:03:35.000000000 -0800
+++ linux-2.6-x86/include/asm-x86/thread_info.h	2008-02-23 15:08:53.000000000 -0800
@@ -3,3 +3,12 @@
 #else
 # include "thread_info_64.h"
 #endif
+
+#ifndef __ASSEMBLY__
+#define __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
+extern struct task_struct * alloc_task_struct(void);
+extern void free_task_struct(struct task_struct *tsk);
+extern void memcpy_task_struct(struct task_struct *dst, struct task_struct *src
+);
+extern void task_struct_slab_init(void);
+#endif
Index: linux-2.6-x86/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/Makefile	2008-02-22 18:33:17.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/Makefile	2008-02-23 15:04:30.000000000 -0800
@@ -29,6 +29,7 @@
 obj-$(CONFIG_X86_64)	+= pci-nommu_64.o bugs_64.o
 obj-y			+= tsc_$(BITS).o io_delay.o rtc.o
 
+obj-y				+= process.o
 obj-y				+= i387.o
 obj-y				+= ptrace.o
 obj-y				+= ds.o
Index: linux-2.6-x86/arch/x86/kernel/process.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-x86/arch/x86/kernel/process.c	2008-02-23 15:08:53.000000000 -0800
@@ -0,0 +1,55 @@
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+
+static struct kmem_cache *task_struct_cachep;
+static struct kmem_cache *task_cntxt_cachep;
+
+struct task_struct * alloc_task_struct(void)
+{
+	struct task_struct *tsk;
+	tsk = kmem_cache_alloc(task_struct_cachep, GFP_KERNEL);
+	if (!tsk)
+		return NULL;
+	tsk->thread.cntxt = kmem_cache_alloc(task_cntxt_cachep, GFP_KERNEL);
+	if (!tsk->thread.cntxt)
+		goto error;
+	WARN_ON((unsigned long)tsk->thread.cntxt & 15);
+	return tsk;
+
+error:
+	kmem_cache_free(task_struct_cachep, tsk);
+	return NULL;
+}
+
+void memcpy_task_struct(struct task_struct *dst, struct task_struct *src)
+{
+	union thread_cntxt *ptr;
+	ptr = dst->thread.cntxt;
+	*dst = *src;
+	dst->thread.cntxt = ptr;
+	memcpy(dst->thread.cntxt, src->thread.cntxt, math_cntxt_size);
+}
+
+void free_task_struct(struct task_struct *tsk)
+{
+	kmem_cache_free(task_cntxt_cachep, tsk->thread.cntxt);
+	tsk->thread.cntxt=NULL;
+	kmem_cache_free(task_struct_cachep, tsk);
+}
+
+void task_struct_slab_init(void)
+{
+ 	/* create a slab on which task_structs can be allocated */
+	task_struct_cachep =
+		kmem_cache_create("task_struct", sizeof(struct task_struct),
+				  1 << INTERNODE_CACHE_SHIFT,
+				  SLAB_PANIC, NULL);
+        task_cntxt_cachep =
+        	kmem_cache_create("task_cntxt", math_cntxt_size,
+				  __alignof__(union thread_cntxt),
+				  SLAB_PANIC, NULL);
+}
Index: linux-2.6-x86/arch/x86/math-emu/fpu_entry.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/math-emu/fpu_entry.c	2008-02-22 18:33:17.000000000 -0800
+++ linux-2.6-x86/arch/x86/math-emu/fpu_entry.c	2008-02-23 15:04:30.000000000 -0800
@@ -677,7 +677,7 @@
 		    unsigned int pos, unsigned int count,
 		    const void *kbuf, const void __user *ubuf)
 {
-	struct i387_soft_struct *s387 = &target->thread.i387.soft;
+	struct i387_soft_struct *s387 = SOFT(target);
 	void *space = s387->st_space;
 	int ret;
 	int offset, other, i, tags, regnr, tag, newtop;
@@ -729,7 +729,7 @@
 		    unsigned int pos, unsigned int count,
 		    void *kbuf, void __user *ubuf)
 {
-	struct i387_soft_struct *s387 = &target->thread.i387.soft;
+	struct i387_soft_struct *s387 = SOFT(target);
 	const void *space = s387->st_space;
 	int ret;
 	int offset = (S387->ftop & 7) * 10, other = 80 - offset;
Index: linux-2.6-x86/arch/x86/math-emu/fpu_system.h
===================================================================
--- linux-2.6-x86.orig/arch/x86/math-emu/fpu_system.h	2008-02-22 18:33:17.000000000 -0800
+++ linux-2.6-x86/arch/x86/math-emu/fpu_system.h	2008-02-23 15:04:30.000000000 -0800
@@ -35,8 +35,9 @@
 #define SEG_EXPAND_DOWN(s)	(((s).b & ((1 << 11) | (1 << 10))) \
 				 == (1 << 10))
 
-#define I387			(current->thread.i387)
-#define FPU_info		(I387.soft.info)
+#define I387			(current->thread.cntxt)
+#define FPU_info		(I387->soft.info)
+#define SOFT(t)			(&(t->thread.cntxt->soft))
 
 #define FPU_CS			(*(unsigned short *) &(FPU_info->___cs))
 #define FPU_SS			(*(unsigned short *) &(FPU_info->___ss))
@@ -46,25 +47,25 @@
 #define FPU_EIP			(FPU_info->___eip)
 #define FPU_ORIG_EIP		(FPU_info->___orig_eip)
 
-#define FPU_lookahead           (I387.soft.lookahead)
+#define FPU_lookahead           (I387->soft.lookahead)
 
 /* nz if ip_offset and cs_selector are not to be set for the current
    instruction. */
-#define no_ip_update		(*(u_char *)&(I387.soft.no_update))
-#define FPU_rm			(*(u_char *)&(I387.soft.rm))
+#define no_ip_update		(*(u_char *)&(I387->soft.no_update))
+#define FPU_rm			(*(u_char *)&(I387->soft.rm))
 
 /* Number of bytes of data which can be legally accessed by the current
    instruction. This only needs to hold a number <= 108, so a byte will do. */
-#define access_limit		(*(u_char *)&(I387.soft.alimit))
+#define access_limit		(*(u_char *)&(I387->soft.alimit))
 
-#define partial_status		(I387.soft.swd)
-#define control_word		(I387.soft.cwd)
-#define fpu_tag_word		(I387.soft.twd)
-#define registers		(I387.soft.st_space)
-#define top			(I387.soft.ftop)
+#define partial_status		(I387->soft.swd)
+#define control_word		(I387->soft.cwd)
+#define fpu_tag_word		(I387->soft.twd)
+#define registers		(I387->soft.st_space)
+#define top			(I387->soft.ftop)
 
-#define instruction_address	(*(struct address *)&I387.soft.fip)
-#define operand_address		(*(struct address *)&I387.soft.foo)
+#define instruction_address	(*(struct address *)&I387->soft.fip)
+#define operand_address		(*(struct address *)&I387->soft.foo)
 
 #define FPU_access_ok(x,y,z)	if ( !access_ok(x,y,z) ) \
 				math_abort(FPU_info,SIGSEGV)
Index: linux-2.6-x86/arch/x86/math-emu/reg_ld_str.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/math-emu/reg_ld_str.c	2008-02-22 18:33:17.000000000 -0800
+++ linux-2.6-x86/arch/x86/math-emu/reg_ld_str.c	2008-02-23 15:04:30.000000000 -0800
@@ -1185,8 +1185,8 @@
 		control_word |= 0xffff0040;
 		partial_status = status_word() | 0xffff0000;
 		fpu_tag_word |= 0xffff0000;
-		I387.soft.fcs &= ~0xf8000000;
-		I387.soft.fos |= 0xffff0000;
+		I387->soft.fcs &= ~0xf8000000;
+		I387->soft.fos |= 0xffff0000;
 #endif /* PECULIAR_486 */
 		if (__copy_to_user(d, &control_word, 7 * 4))
 			FPU_abort;

-- 

