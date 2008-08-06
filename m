Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbYHFSCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbYHFSCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 14:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYHFSCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 14:02:15 -0400
Received: from dresden.studentenwerk.mhn.de ([141.84.225.229]:41876 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753927AbYHFSCN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 14:02:13 -0400
X-Greylist: delayed 1725 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Aug 2008 14:02:12 EDT
From: Wolfgang Walter <wolfgang.walter@stwm.de>
Organization: Studentenwerk =?iso-8859-1?q?M=FCnchen?=
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Date: Wed, 6 Aug 2008 19:33:25 +0200
User-Agent: KMail/1.9.5
References: <200807171653.59177.wolfgang.walter@stwm.de> <200807301411.01622.wolfgang.walter@stwm.de> <20080806103354.GA31623@gondor.apana.org.au>
In-Reply-To: <20080806103354.GA31623@gondor.apana.org.au>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808061933.25631.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Herbert,

I think I finally found the problem.

Here a short description again: all our routers with a via C3 using padlock for AES-encryption are
crashing with 2.6.26 while they work fine with 2.6.25. Not using padlock
(i.e. using the i386 assembler version of AES) they just work fine.

After a kernel bisection I found that
fa5c4639419668cbb18ca3d20c1253559a3b43ae works fine,
2adee9b30d1382fba97825b9c50e4f50a0117c36 crashes.

I did not try to bisect the last 4 commits as they seem to be related.

Instead I took a 2.6.26 and reverted the following commits:

e8a496ac8cd00cabbdaa373db4818a9ad19a1c5a
fd3c3ed5d1e3ceb37635cbe6d220ab94aae0781d
2adee9b30d1382fba97825b9c50e4f50a0117c36
1679f2710ac58df580d3716fab1f42ae50a226eb
aa283f49276e7d840a40fb01eee6de97eaa7e012
61c4628b538608c1a85211ed8438136adfeb9a95

and changed
arch/x86/kernel/process.c
by hand.

With such a modified 2.6.26 the problem disappears.


Am Mittwoch, 6. August 2008 12:33 schrieben Sie:
> On Wed, Jul 30, 2008 at 02:11:01PM +0200, Wolfgang Walter wrote:
> > BUG: unable to handle kernel NULL pointer dereference at 000001f0
> > IP: [<c010280c>] __switch_to+0x23/0x103
> > *pde = 00000000
> > Oops: 0002 [#1] PREEMPT
> > Modules linked in:
> >
> > Pid: 1396, comm: dmesg Not tainted (2.6.26 #1)
> > EIP: 0060:[<c010280c>] EFLAGS: 00010002 CPU: 0
> > EIP is at __switch_to+0x23/0x103
> > EAX: 00000000 EBX: de87cdc0 ECX: 000021d9 EDX: de87cdc0
> > ESI: dc4e3810 EDI: de87cfe8 EBP: dc4e3a38 ESP: cfdb5b30
> >  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> > Process dmesg (pid: 1396, ti=cfdb4000 task=dc4e3810 task.ti=cfda4000)
> > Stack: de87cdc0 00000000 cfdbd300 dc4e3810 c039bf79 de87cdc0 00000086
> > d13da410 c0119aca de87cf2c 00000046 d13da410 00000000 7fffffff 00000080
> > cfdb5f9c c039c369 c02381d0 c0234f09 cfdb5be4 00000104 00000000 cf3bb480
> > 00000000 Call Trace:
>

Here is the difference between 2.6.26 and the modified version:


=============================================
diff -ru kernels/linux-2.6.26/arch/x86/kernel/i387.c tests/linux-2.6ww/arch/x86/kernel/i387.c
--- kernels/linux-2.6.26/arch/x86/kernel/i387.c	2008-07-15 11:29:31.000000000 +0200
+++ tests/linux-2.6ww/arch/x86/kernel/i387.c	2008-08-06 18:40:54.000000000 +0200
@@ -35,18 +35,17 @@
 #endif
 
 static unsigned int		mxcsr_feature_mask __read_mostly = 0xffffffffu;
-unsigned int xstate_size;
-static struct i387_fxsave_struct fx_scratch __cpuinitdata;
 
-void __cpuinit mxcsr_feature_mask_init(void)
+void mxcsr_feature_mask_init(void)
 {
 	unsigned long mask = 0;
 
 	clts();
 	if (cpu_has_fxsr) {
-		memset(&fx_scratch, 0, sizeof(struct i387_fxsave_struct));
-		asm volatile("fxsave %0" : : "m" (fx_scratch));
-		mask = fx_scratch.mxcsr_mask;
+		memset(&current->thread.i387.fxsave, 0,
+		       sizeof(struct i387_fxsave_struct));
+		asm volatile("fxsave %0" : : "m" (current->thread.i387.fxsave));
+		mask = current->thread.i387.fxsave.mxcsr_mask;
 		if (mask == 0)
 			mask = 0x0000ffbf;
 	}
@@ -54,21 +53,6 @@
 	stts();
 }
 
-void __init init_thread_xstate(void)
-{
-	if (!HAVE_HWFP) {
-		xstate_size = sizeof(struct i387_soft_struct);
-		return;
-	}
-
-	if (cpu_has_fxsr)
-		xstate_size = sizeof(struct i387_fxsave_struct);
-#ifdef CONFIG_X86_32
-	else
-		xstate_size = sizeof(struct i387_fsave_struct);
-#endif
-}
-
 #ifdef CONFIG_X86_64
 /*
  * Called at bootup to set up the initial FPU state that is later cloned
@@ -77,6 +61,10 @@
 void __cpuinit fpu_init(void)
 {
 	unsigned long oldcr0 = read_cr0();
+	extern void __bad_fxsave_alignment(void);
+
+	if (offsetof(struct task_struct, thread.i387.fxsave) & 15)
+		__bad_fxsave_alignment();
 
 	set_in_cr4(X86_CR4_OSFXSR);
 	set_in_cr4(X86_CR4_OSXMMEXCPT);
@@ -96,53 +84,32 @@
  * value at reset if we support XMM instructions and then
  * remeber the current task has used the FPU.
  */
-int init_fpu(struct task_struct *tsk)
+void init_fpu(struct task_struct *tsk)
 {
 	if (tsk_used_math(tsk)) {
-		if (HAVE_HWFP && tsk == current)
+		if (tsk == current)
 			unlazy_fpu(tsk);
-		return 0;
-	}
-
-	/*
-	 * Memory allocation at the first usage of the FPU and other state.
-	 */
-	if (!tsk->thread.xstate) {
-		tsk->thread.xstate = kmem_cache_alloc(task_xstate_cachep,
-						      GFP_KERNEL);
-		if (!tsk->thread.xstate)
-			return -ENOMEM;
-	}
-
-#ifdef CONFIG_X86_32
-	if (!HAVE_HWFP) {
-		memset(tsk->thread.xstate, 0, xstate_size);
-		finit();
-		set_stopped_child_used_math(tsk);
-		return 0;
+		return;
 	}
-#endif
 
 	if (cpu_has_fxsr) {
-		struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
-
-		memset(fx, 0, xstate_size);
-		fx->cwd = 0x37f;
+		memset(&tsk->thread.i387.fxsave, 0,
+		       sizeof(struct i387_fxsave_struct));
+		tsk->thread.i387.fxsave.cwd = 0x37f;
 		if (cpu_has_xmm)
-			fx->mxcsr = MXCSR_DEFAULT;
+			tsk->thread.i387.fxsave.mxcsr = MXCSR_DEFAULT;
 	} else {
-		struct i387_fsave_struct *fp = &tsk->thread.xstate->fsave;
-		memset(fp, 0, xstate_size);
-		fp->cwd = 0xffff037fu;
-		fp->swd = 0xffff0000u;
-		fp->twd = 0xffffffffu;
-		fp->fos = 0xffff0000u;
+		memset(&tsk->thread.i387.fsave, 0,
+		       sizeof(struct i387_fsave_struct));
+		tsk->thread.i387.fsave.cwd = 0xffff037fu;
+		tsk->thread.i387.fsave.swd = 0xffff0000u;
+		tsk->thread.i387.fsave.twd = 0xffffffffu;
+		tsk->thread.i387.fsave.fos = 0xffff0000u;
 	}
 	/*
 	 * Only the device not available exception or ptrace can call init_fpu.
 	 */
 	set_stopped_child_used_math(tsk);
-	return 0;
 }
 
 int fpregs_active(struct task_struct *target, const struct user_regset *regset)
@@ -159,17 +126,13 @@
 		unsigned int pos, unsigned int count,
 		void *kbuf, void __user *ubuf)
 {
-	int ret;
-
 	if (!cpu_has_fxsr)
 		return -EIO;
 
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
+	init_fpu(target);
 
 	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-				   &target->thread.xstate->fxsave, 0, -1);
+				   &target->thread.i387.fxsave, 0, -1);
 }
 
 int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
@@ -181,19 +144,16 @@
 	if (!cpu_has_fxsr)
 		return -EIO;
 
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
-
+	init_fpu(target);
 	set_stopped_child_used_math(target);
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-				 &target->thread.xstate->fxsave, 0, -1);
+				 &target->thread.i387.fxsave, 0, -1);
 
 	/*
 	 * mxcsr reserved bits must be masked to zero for security reasons.
 	 */
-	target->thread.xstate->fxsave.mxcsr &= mxcsr_feature_mask;
+	target->thread.i387.fxsave.mxcsr &= mxcsr_feature_mask;
 
 	return ret;
 }
@@ -273,7 +233,7 @@
 static void
 convert_from_fxsr(struct user_i387_ia32_struct *env, struct task_struct *tsk)
 {
-	struct i387_fxsave_struct *fxsave = &tsk->thread.xstate->fxsave;
+	struct i387_fxsave_struct *fxsave = &tsk->thread.i387.fxsave;
 	struct _fpreg *to = (struct _fpreg *) &env->st_space[0];
 	struct _fpxreg *from = (struct _fpxreg *) &fxsave->st_space[0];
 	int i;
@@ -313,7 +273,7 @@
 			    const struct user_i387_ia32_struct *env)
 
 {
-	struct i387_fxsave_struct *fxsave = &tsk->thread.xstate->fxsave;
+	struct i387_fxsave_struct *fxsave = &tsk->thread.i387.fxsave;
 	struct _fpreg *from = (struct _fpreg *) &env->st_space[0];
 	struct _fpxreg *to = (struct _fpxreg *) &fxsave->st_space[0];
 	int i;
@@ -342,19 +302,15 @@
 	       void *kbuf, void __user *ubuf)
 {
 	struct user_i387_ia32_struct env;
-	int ret;
-
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
 
 	if (!HAVE_HWFP)
 		return fpregs_soft_get(target, regset, pos, count, kbuf, ubuf);
 
+	init_fpu(target);
+
 	if (!cpu_has_fxsr) {
 		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-					   &target->thread.xstate->fsave, 0,
-					   -1);
+					   &target->thread.i387.fsave, 0, -1);
 	}
 
 	if (kbuf && pos == 0 && count == sizeof(env)) {
@@ -374,18 +330,15 @@
 	struct user_i387_ia32_struct env;
 	int ret;
 
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
-
-	set_stopped_child_used_math(target);
-
 	if (!HAVE_HWFP)
 		return fpregs_soft_set(target, regset, pos, count, kbuf, ubuf);
 
+	init_fpu(target);
+	set_stopped_child_used_math(target);
+
 	if (!cpu_has_fxsr) {
 		return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-					  &target->thread.xstate->fsave, 0, -1);
+					  &target->thread.i387.fsave, 0, -1);
 	}
 
 	if (pos > 0 || count < sizeof(env))
@@ -405,11 +358,11 @@
 static inline int save_i387_fsave(struct _fpstate_ia32 __user *buf)
 {
 	struct task_struct *tsk = current;
-	struct i387_fsave_struct *fp = &tsk->thread.xstate->fsave;
 
 	unlazy_fpu(tsk);
-	fp->status = fp->swd;
-	if (__copy_to_user(buf, fp, sizeof(struct i387_fsave_struct)))
+	tsk->thread.i387.fsave.status = tsk->thread.i387.fsave.swd;
+	if (__copy_to_user(buf, &tsk->thread.i387.fsave,
+			   sizeof(struct i387_fsave_struct)))
 		return -1;
 	return 1;
 }
@@ -417,7 +370,6 @@
 static int save_i387_fxsave(struct _fpstate_ia32 __user *buf)
 {
 	struct task_struct *tsk = current;
-	struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
 	struct user_i387_ia32_struct env;
 	int err = 0;
 
@@ -427,12 +379,12 @@
 	if (__copy_to_user(buf, &env, sizeof(env)))
 		return -1;
 
-	err |= __put_user(fx->swd, &buf->status);
+	err |= __put_user(tsk->thread.i387.fxsave.swd, &buf->status);
 	err |= __put_user(X86_FXSR_MAGIC, &buf->magic);
 	if (err)
 		return -1;
 
-	if (__copy_to_user(&buf->_fxsr_env[0], fx,
+	if (__copy_to_user(&buf->_fxsr_env[0], &tsk->thread.i387.fxsave,
 			   sizeof(struct i387_fxsave_struct)))
 		return -1;
 	return 1;
@@ -464,7 +416,8 @@
 {
 	struct task_struct *tsk = current;
 
-	return __copy_from_user(&tsk->thread.xstate->fsave, buf,
+	clear_fpu(tsk);
+	return __copy_from_user(&tsk->thread.i387.fsave, buf,
 				sizeof(struct i387_fsave_struct));
 }
 
@@ -474,10 +427,11 @@
 	struct user_i387_ia32_struct env;
 	int err;
 
-	err = __copy_from_user(&tsk->thread.xstate->fxsave, &buf->_fxsr_env[0],
+	clear_fpu(tsk);
+	err = __copy_from_user(&tsk->thread.i387.fxsave, &buf->_fxsr_env[0],
 			       sizeof(struct i387_fxsave_struct));
 	/* mxcsr reserved bits must be masked to zero for security reasons */
-	tsk->thread.xstate->fxsave.mxcsr &= mxcsr_feature_mask;
+	tsk->thread.i387.fxsave.mxcsr &= mxcsr_feature_mask;
 	if (err || __copy_from_user(&env, buf, sizeof(env)))
 		return 1;
 	convert_to_fxsr(tsk, &env);
@@ -488,16 +442,6 @@
 int restore_i387_ia32(struct _fpstate_ia32 __user *buf)
 {
 	int err;
-	struct task_struct *tsk = current;
-
-	if (HAVE_HWFP)
-		clear_fpu(tsk);
-
-	if (!used_math()) {
-		err = init_fpu(tsk);
-		if (err)
-			return err;
-	}
 
 	if (HAVE_HWFP) {
 		if (cpu_has_fxsr)
diff -ru kernels/linux-2.6.26/arch/x86/kernel/process.c tests/linux-2.6ww/arch/x86/kernel/process.c
--- kernels/linux-2.6.26/arch/x86/kernel/process.c	2008-07-15 11:29:31.000000000 +0200
+++ tests/linux-2.6ww/arch/x86/kernel/process.c	2008-08-06 18:43:11.000000000 +0200
@@ -7,43 +7,7 @@
 #include <linux/module.h>
 #include <linux/pm.h>
 
-struct kmem_cache *task_xstate_cachep;
-
-int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
-{
-	*dst = *src;
-	if (src->thread.xstate) {
-		dst->thread.xstate = kmem_cache_alloc(task_xstate_cachep,
-						      GFP_KERNEL);
-		if (!dst->thread.xstate)
-			return -ENOMEM;
-		WARN_ON((unsigned long)dst->thread.xstate & 15);
-		memcpy(dst->thread.xstate, src->thread.xstate, xstate_size);
-	}
-	return 0;
-}
-
-void free_thread_xstate(struct task_struct *tsk)
-{
-	if (tsk->thread.xstate) {
-		kmem_cache_free(task_xstate_cachep, tsk->thread.xstate);
-		tsk->thread.xstate = NULL;
-	}
-}
-
-void free_thread_info(struct thread_info *ti)
-{
-	free_thread_xstate(ti->task);
-	free_pages((unsigned long)ti, get_order(THREAD_SIZE));
-}
-
-void arch_task_cache_init(void)
-{
-        task_xstate_cachep =
-        	kmem_cache_create("task_xstate", xstate_size,
-				  __alignof__(union thread_xstate),
-				  SLAB_PANIC, NULL);
-}
+static struct kmem_cache *task_xstate_cachep;
 
 static void do_nothing(void *unused)
 {
diff -ru kernels/linux-2.6.26/arch/x86/kernel/process_32.c tests/linux-2.6ww/arch/x86/kernel/process_32.c
--- kernels/linux-2.6.26/arch/x86/kernel/process_32.c	2008-07-15 11:29:31.000000000 +0200
+++ tests/linux-2.6ww/arch/x86/kernel/process_32.c	2008-08-06 18:40:54.000000000 +0200
@@ -412,10 +412,6 @@
 	regs->cs		= __USER_CS;
 	regs->ip		= new_ip;
 	regs->sp		= new_sp;
-	/*
-	 * Free the old FP and other extended state
-	 */
-	free_thread_xstate(current);
 }
 EXPORT_SYMBOL_GPL(start_thread);
 
@@ -598,7 +594,7 @@
 
 	/* we're going to use this soon, after a few expensive things */
 	if (next_p->fpu_counter > 5)
-		prefetch(next->xstate);
+		prefetch(&next->i387.fxsave);
 
 	/*
 	 * Reload esp0.
diff -ru kernels/linux-2.6.26/arch/x86/kernel/process_64.c tests/linux-2.6ww/arch/x86/kernel/process_64.c
--- kernels/linux-2.6.26/arch/x86/kernel/process_64.c	2008-07-15 11:29:31.000000000 +0200
+++ tests/linux-2.6ww/arch/x86/kernel/process_64.c	2008-08-06 18:40:54.000000000 +0200
@@ -417,10 +417,6 @@
 	regs->ss		= __USER_DS;
 	regs->flags		= 0x200;
 	set_fs(USER_DS);
-	/*
-	 * Free the old FP and other extended state
-	 */
-	free_thread_xstate(current);
 }
 EXPORT_SYMBOL_GPL(start_thread);
 
@@ -570,7 +566,7 @@
 
 	/* we're going to use this soon, after a few expensive things */
 	if (next_p->fpu_counter>5)
-		prefetch(next->xstate);
+		prefetch(&next->i387.fxsave);
 
 	/*
 	 * Reload esp0, LDT and the page table pointer:
diff -ru kernels/linux-2.6.26/arch/x86/kernel/traps_32.c tests/linux-2.6ww/arch/x86/kernel/traps_32.c
--- kernels/linux-2.6.26/arch/x86/kernel/traps_32.c	2008-07-15 11:29:32.000000000 +0200
+++ tests/linux-2.6ww/arch/x86/kernel/traps_32.c	2008-08-06 18:40:54.000000000 +0200
@@ -1149,22 +1149,9 @@
 	struct thread_info *thread = current_thread_info();
 	struct task_struct *tsk = thread->task;
 
-	if (!tsk_used_math(tsk)) {
-		local_irq_enable();
-		/*
-		 * does a slab alloc which can sleep
-		 */
-		if (init_fpu(tsk)) {
-			/*
-			 * ran out of memory!
-			 */
-			do_group_exit(SIGKILL);
-			return;
-		}
-		local_irq_disable();
-	}
-
 	clts();				/* Allow maths ops (or we recurse) */
+	if (!tsk_used_math(tsk))
+		init_fpu(tsk);
 	restore_fpu(tsk);
 	thread->status |= TS_USEDFPU;	/* So we fnsave on switch_to() */
 	tsk->fpu_counter++;
@@ -1222,6 +1209,11 @@
 #endif
 	set_trap_gate(19, &simd_coprocessor_error);
 
+	/*
+	 * Verify that the FXSAVE/FXRSTOR data will be 16-byte aligned.
+	 * Generate a build-time error if the alignment is wrong.
+	 */
+	BUILD_BUG_ON(offsetof(struct task_struct, thread.i387.fxsave) & 15);
 	if (cpu_has_fxsr) {
 		printk(KERN_INFO "Enabling fast FPU save and restore... ");
 		set_in_cr4(X86_CR4_OSFXSR);
@@ -1242,7 +1234,6 @@
 
 	set_bit(SYSCALL_VECTOR, used_vectors);
 
-	init_thread_xstate();
 	/*
 	 * Should be a barrier for any external CPU state:
 	 */
diff -ru kernels/linux-2.6.26/arch/x86/kernel/traps_64.c tests/linux-2.6ww/arch/x86/kernel/traps_64.c
--- kernels/linux-2.6.26/arch/x86/kernel/traps_64.c	2008-07-15 11:29:32.000000000 +0200
+++ tests/linux-2.6ww/arch/x86/kernel/traps_64.c	2008-08-06 18:40:54.000000000 +0200
@@ -1124,24 +1124,11 @@
 asmlinkage void math_state_restore(void)
 {
 	struct task_struct *me = current;
-
-	if (!used_math()) {
-		local_irq_enable();
-		/*
-		 * does a slab alloc which can sleep
-		 */
-		if (init_fpu(me)) {
-			/*
-			 * ran out of memory!
-			 */
-			do_group_exit(SIGKILL);
-			return;
-		}
-		local_irq_disable();
-	}
-
 	clts();			/* Allow maths ops (or we recurse) */
-	restore_fpu_checking(&me->thread.xstate->fxsave);
+
+	if (!used_math())
+		init_fpu(me);
+	restore_fpu_checking(&me->thread.i387.fxsave);
 	task_thread_info(me)->status |= TS_USEDFPU;
 	me->fpu_counter++;
 }
@@ -1177,10 +1164,6 @@
 #endif
        
 	/*
-	 * initialize the per thread extended state:
-	 */
-        init_thread_xstate();
-	/*
 	 * Should be a barrier for any external CPU state.
 	 */
 	cpu_init();
diff -ru kernels/linux-2.6.26/arch/x86/math-emu/fpu_entry.c tests/linux-2.6ww/arch/x86/math-emu/fpu_entry.c
--- kernels/linux-2.6.26/arch/x86/math-emu/fpu_entry.c	2008-07-15 11:29:32.000000000 +0200
+++ tests/linux-2.6ww/arch/x86/math-emu/fpu_entry.c	2008-08-06 18:40:54.000000000 +0200
@@ -30,7 +30,6 @@
 #include <asm/uaccess.h>
 #include <asm/desc.h>
 #include <asm/user.h>
-#include <asm/i387.h>
 
 #include "fpu_system.h"
 #include "fpu_emu.h"
@@ -147,13 +146,6 @@
 	unsigned long code_limit = 0;	/* Initialized to stop compiler warnings */
 	struct desc_struct code_descriptor;
 
-	if (!used_math()) {
-		if (init_fpu(current)) {
-			do_group_exit(SIGKILL);
-			return;
-		}
-	}
-
 #ifdef RE_ENTRANT_CHECKING
 	if (emulating) {
 		printk("ERROR: wm-FPU-emu is not RE-ENTRANT!\n");
@@ -161,6 +153,11 @@
 	RE_ENTRANT_CHECK_ON;
 #endif /* RE_ENTRANT_CHECKING */
 
+	if (!used_math()) {
+		finit();
+		set_used_math();
+	}
+
 	SETUP_DATA_AREA(arg);
 
 	FPU_ORIG_EIP = FPU_EIP;
@@ -681,7 +678,7 @@
 		    unsigned int pos, unsigned int count,
 		    const void *kbuf, const void __user *ubuf)
 {
-	struct i387_soft_struct *s387 = &target->thread.xstate->soft;
+	struct i387_soft_struct *s387 = &target->thread.i387.soft;
 	void *space = s387->st_space;
 	int ret;
 	int offset, other, i, tags, regnr, tag, newtop;
@@ -733,7 +730,7 @@
 		    unsigned int pos, unsigned int count,
 		    void *kbuf, void __user *ubuf)
 {
-	struct i387_soft_struct *s387 = &target->thread.xstate->soft;
+	struct i387_soft_struct *s387 = &target->thread.i387.soft;
 	const void *space = s387->st_space;
 	int ret;
 	int offset = (S387->ftop & 7) * 10, other = 80 - offset;
diff -ru kernels/linux-2.6.26/arch/x86/math-emu/fpu_system.h tests/linux-2.6ww/arch/x86/math-emu/fpu_system.h
--- kernels/linux-2.6.26/arch/x86/math-emu/fpu_system.h	2008-07-15 11:29:32.000000000 +0200
+++ tests/linux-2.6ww/arch/x86/math-emu/fpu_system.h	2008-08-06 18:40:54.000000000 +0200
@@ -35,8 +35,8 @@
 #define SEG_EXPAND_DOWN(s)	(((s).b & ((1 << 11) | (1 << 10))) \
 				 == (1 << 10))
 
-#define I387			(current->thread.xstate)
-#define FPU_info		(I387->soft.info)
+#define I387			(current->thread.i387)
+#define FPU_info		(I387.soft.info)
 
 #define FPU_CS			(*(unsigned short *) &(FPU_info->___cs))
 #define FPU_SS			(*(unsigned short *) &(FPU_info->___ss))
@@ -46,25 +46,25 @@
 #define FPU_EIP			(FPU_info->___eip)
 #define FPU_ORIG_EIP		(FPU_info->___orig_eip)
 
-#define FPU_lookahead           (I387->soft.lookahead)
+#define FPU_lookahead           (I387.soft.lookahead)
 
 /* nz if ip_offset and cs_selector are not to be set for the current
    instruction. */
-#define no_ip_update		(*(u_char *)&(I387->soft.no_update))
-#define FPU_rm			(*(u_char *)&(I387->soft.rm))
+#define no_ip_update		(*(u_char *)&(I387.soft.no_update))
+#define FPU_rm			(*(u_char *)&(I387.soft.rm))
 
 /* Number of bytes of data which can be legally accessed by the current
    instruction. This only needs to hold a number <= 108, so a byte will do. */
-#define access_limit		(*(u_char *)&(I387->soft.alimit))
+#define access_limit		(*(u_char *)&(I387.soft.alimit))
 
-#define partial_status		(I387->soft.swd)
-#define control_word		(I387->soft.cwd)
-#define fpu_tag_word		(I387->soft.twd)
-#define registers		(I387->soft.st_space)
-#define top			(I387->soft.ftop)
+#define partial_status		(I387.soft.swd)
+#define control_word		(I387.soft.cwd)
+#define fpu_tag_word		(I387.soft.twd)
+#define registers		(I387.soft.st_space)
+#define top			(I387.soft.ftop)
 
-#define instruction_address	(*(struct address *)&I387->soft.fip)
-#define operand_address		(*(struct address *)&I387->soft.foo)
+#define instruction_address	(*(struct address *)&I387.soft.fip)
+#define operand_address		(*(struct address *)&I387.soft.foo)
 
 #define FPU_access_ok(x,y,z)	if ( !access_ok(x,y,z) ) \
 				math_abort(FPU_info,SIGSEGV)
diff -ru kernels/linux-2.6.26/arch/x86/math-emu/reg_ld_str.c tests/linux-2.6ww/arch/x86/math-emu/reg_ld_str.c
--- kernels/linux-2.6.26/arch/x86/math-emu/reg_ld_str.c	2008-07-15 11:29:32.000000000 +0200
+++ tests/linux-2.6ww/arch/x86/math-emu/reg_ld_str.c	2008-08-06 18:40:54.000000000 +0200
@@ -1180,8 +1180,8 @@
 		control_word |= 0xffff0040;
 		partial_status = status_word() | 0xffff0000;
 		fpu_tag_word |= 0xffff0000;
-		I387->soft.fcs &= ~0xf8000000;
-		I387->soft.fos |= 0xffff0000;
+		I387.soft.fcs &= ~0xf8000000;
+		I387.soft.fos |= 0xffff0000;
 #endif /* PECULIAR_486 */
 		if (__copy_to_user(d, &control_word, 7 * 4))
 			FPU_abort;
Only in tests/linux-2.6ww/drivers/ide: cris
diff -ru kernels/linux-2.6.26/include/asm-x86/i387.h tests/linux-2.6ww/include/asm-x86/i387.h
--- kernels/linux-2.6.26/include/asm-x86/i387.h	2008-07-15 11:29:34.000000000 +0200
+++ tests/linux-2.6ww/include/asm-x86/i387.h	2008-08-06 18:40:54.000000000 +0200
@@ -21,9 +21,8 @@
 
 extern void fpu_init(void);
 extern void mxcsr_feature_mask_init(void);
-extern int init_fpu(struct task_struct *child);
+extern void init_fpu(struct task_struct *child);
 extern asmlinkage void math_state_restore(void);
-extern void init_thread_xstate(void);
 
 extern user_regset_active_fn fpregs_active, xfpregs_active;
 extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get;
@@ -118,22 +117,24 @@
 	/* Using "fxsaveq %0" would be the ideal choice, but is only supported
 	   starting with gas 2.16. */
 	__asm__ __volatile__("fxsaveq %0"
-			     : "=m" (tsk->thread.xstate->fxsave));
+			     : "=m" (tsk->thread.i387.fxsave));
 #elif 0
 	/* Using, as a workaround, the properly prefixed form below isn't
 	   accepted by any binutils version so far released, complaining that
 	   the same type of prefix is used twice if an extended register is
 	   needed for addressing (fix submitted to mainline 2005-11-21). */
 	__asm__ __volatile__("rex64/fxsave %0"
-			     : "=m" (tsk->thread.xstate->fxsave));
+			     : "=m" (tsk->thread.i387.fxsave));
 #else
 	/* This, however, we can work around by forcing the compiler to select
 	   an addressing mode that doesn't require extended registers. */
-	__asm__ __volatile__("rex64/fxsave (%1)"
-			     : "=m" (tsk->thread.xstate->fxsave)
-			     : "cdaSDb" (&tsk->thread.xstate->fxsave));
+	__asm__ __volatile__("rex64/fxsave %P2(%1)"
+			     : "=m" (tsk->thread.i387.fxsave)
+			     : "cdaSDb" (tsk),
+				"i" (offsetof(__typeof__(*tsk),
+					      thread.i387.fxsave)));
 #endif
-	clear_fpu_state(&tsk->thread.xstate->fxsave);
+	clear_fpu_state(&tsk->thread.i387.fxsave);
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
@@ -147,7 +148,7 @@
 	int err = 0;
 
 	BUILD_BUG_ON(sizeof(struct user_i387_struct) !=
-			sizeof(tsk->thread.xstate->fxsave));
+			sizeof(tsk->thread.i387.fxsave));
 
 	if ((unsigned long)buf % 16)
 		printk("save_i387: bad fpstate %p\n", buf);
@@ -163,7 +164,7 @@
 		task_thread_info(tsk)->status &= ~TS_USEDFPU;
 		stts();
 	} else {
-		if (__copy_to_user(buf, &tsk->thread.xstate->fxsave,
+		if (__copy_to_user(buf, &tsk->thread.i387.fxsave,
 				   sizeof(struct i387_fxsave_struct)))
 			return -1;
 	}
@@ -175,15 +176,7 @@
  */
 static inline int restore_i387(struct _fpstate __user *buf)
 {
-	struct task_struct *tsk = current;
-	int err;
-
-	if (!used_math()) {
-		err = init_fpu(tsk);
-		if (err)
-			return err;
-	}
-
+	set_used_math();
 	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
 		clts();
 		task_thread_info(current)->status |= TS_USEDFPU;
@@ -193,8 +186,6 @@
 
 #else  /* CONFIG_X86_32 */
 
-extern void finit(void);
-
 static inline void tolerant_fwait(void)
 {
 	asm volatile("fnclex ; fwait");
@@ -210,7 +201,7 @@
 		"nop ; frstor %1",
 		"fxrstor %1",
 		X86_FEATURE_FXSR,
-		"m" (tsk->thread.xstate->fxsave));
+		"m" ((tsk)->thread.i387.fxsave));
 }
 
 /* We need a safe address that is cheap to find and that is already
@@ -234,8 +225,8 @@
 		"fxsave %[fx]\n"
 		"bt $7,%[fsw] ; jnc 1f ; fnclex\n1:",
 		X86_FEATURE_FXSR,
-		[fx] "m" (tsk->thread.xstate->fxsave),
-		[fsw] "m" (tsk->thread.xstate->fxsave.swd) : "memory");
+		[fx] "m" (tsk->thread.i387.fxsave),
+		[fsw] "m" (tsk->thread.i387.fxsave.swd) : "memory");
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
 	   values. safe_address is a random variable that should be in L1 */
@@ -336,25 +327,25 @@
 static inline unsigned short get_fpu_cwd(struct task_struct *tsk)
 {
 	if (cpu_has_fxsr) {
-		return tsk->thread.xstate->fxsave.cwd;
+		return tsk->thread.i387.fxsave.cwd;
 	} else {
-		return (unsigned short)tsk->thread.xstate->fsave.cwd;
+		return (unsigned short)tsk->thread.i387.fsave.cwd;
 	}
 }
 
 static inline unsigned short get_fpu_swd(struct task_struct *tsk)
 {
 	if (cpu_has_fxsr) {
-		return tsk->thread.xstate->fxsave.swd;
+		return tsk->thread.i387.fxsave.swd;
 	} else {
-		return (unsigned short)tsk->thread.xstate->fsave.swd;
+		return (unsigned short)tsk->thread.i387.fsave.swd;
 	}
 }
 
 static inline unsigned short get_fpu_mxcsr(struct task_struct *tsk)
 {
 	if (cpu_has_xmm) {
-		return tsk->thread.xstate->fxsave.mxcsr;
+		return tsk->thread.i387.fxsave.mxcsr;
 	} else {
 		return MXCSR_DEFAULT;
 	}
diff -ru kernels/linux-2.6.26/include/asm-x86/processor.h tests/linux-2.6ww/include/asm-x86/processor.h
--- kernels/linux-2.6.26/include/asm-x86/processor.h	2008-07-15 11:29:34.000000000 +0200
+++ tests/linux-2.6ww/include/asm-x86/processor.h	2008-08-06 18:40:54.000000000 +0200
@@ -350,7 +350,7 @@
 	u32			entry_eip;
 };
 
-union thread_xstate {
+union i387_union {
 	struct i387_fsave_struct	fsave;
 	struct i387_fxsave_struct	fxsave;
 	struct i387_soft_struct		soft;
@@ -361,9 +361,6 @@
 #endif
 
 extern void print_cpu_info(struct cpuinfo_x86 *);
-extern unsigned int xstate_size;
-extern void free_thread_xstate(struct task_struct *);
-extern struct kmem_cache *task_xstate_cachep;
 extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
@@ -396,8 +393,8 @@
 	unsigned long		cr2;
 	unsigned long		trap_no;
 	unsigned long		error_code;
-	/* floating point and extended processor state */
-	union thread_xstate	*xstate;
+	/* Floating point info: */
+	union i387_union	i387 __attribute__((aligned(16)));;
 #ifdef CONFIG_X86_32
 	/* Virtual 86 mode info */
 	struct vm86_struct __user *vm86_info;
diff -ru kernels/linux-2.6.26/include/asm-x86/thread_info.h tests/linux-2.6ww/include/asm-x86/thread_info.h
--- kernels/linux-2.6.26/include/asm-x86/thread_info.h	2008-07-15 11:29:34.000000000 +0200
+++ tests/linux-2.6ww/include/asm-x86/thread_info.h	2008-08-06 18:40:54.000000000 +0200
@@ -1,14 +1,5 @@
-#ifndef _ASM_X86_THREAD_INFO_H
 #ifdef CONFIG_X86_32
 # include "thread_info_32.h"
 #else
 # include "thread_info_64.h"
 #endif
-
-#ifndef __ASSEMBLY__
-extern void arch_task_cache_init(void);
-extern void free_thread_info(struct thread_info *ti);
-extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
-#define arch_task_cache_init arch_task_cache_init
-#endif
-#endif /* _ASM_X86_THREAD_INFO_H */
diff -ru kernels/linux-2.6.26/include/asm-x86/thread_info_32.h tests/linux-2.6ww/include/asm-x86/thread_info_32.h
--- kernels/linux-2.6.26/include/asm-x86/thread_info_32.h	2008-07-15 11:29:34.000000000 +0200
+++ tests/linux-2.6ww/include/asm-x86/thread_info_32.h	2008-08-06 18:40:54.000000000 +0200
@@ -102,6 +102,8 @@
 	__get_free_pages(GFP_KERNEL, get_order(THREAD_SIZE)))
 #endif
 
+#define free_thread_info(info)	free_pages((unsigned long)(info), get_order(THREAD_SIZE))
+
 #else /* !__ASSEMBLY__ */
 
 /* how to get the thread information struct from ASM */
diff -ru kernels/linux-2.6.26/include/asm-x86/thread_info_64.h tests/linux-2.6ww/include/asm-x86/thread_info_64.h
--- kernels/linux-2.6.26/include/asm-x86/thread_info_64.h	2008-07-15 11:29:34.000000000 +0200
+++ tests/linux-2.6ww/include/asm-x86/thread_info_64.h	2008-08-06 18:40:54.000000000 +0200
@@ -85,6 +85,8 @@
 #define alloc_thread_info(tsk)						\
 	((struct thread_info *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER))
 
+#define free_thread_info(ti) free_pages((unsigned long) (ti), THREAD_ORDER)
+
 #else /* !__ASSEMBLY__ */
 
 /* how to get the thread information struct from ASM */
diff -ru kernels/linux-2.6.26/kernel/fork.c tests/linux-2.6ww/kernel/fork.c
--- kernels/linux-2.6.26/kernel/fork.c	2008-07-15 11:29:34.000000000 +0200
+++ tests/linux-2.6ww/kernel/fork.c	2008-08-06 18:40:54.000000000 +0200
@@ -133,14 +133,6 @@
 		free_task(tsk);
 }
 
-/*
- * macro override instead of weak attribute alias, to workaround
- * gcc 4.1.0 and 4.1.1 bugs with weak attribute and empty functions.
- */
-#ifndef arch_task_cache_init
-#define arch_task_cache_init()
-#endif
-
 void __init fork_init(unsigned long mempages)
 {
 #ifndef __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
@@ -153,9 +145,6 @@
 			ARCH_MIN_TASKALIGN, SLAB_PANIC, NULL);
 #endif
 
-	/* do the arch specific task caches init */
-	arch_task_cache_init();
-
 	/*
 	 * The default maximum number of threads is set to a safe
 	 * value: the thread structures can take up at most half
@@ -175,13 +164,6 @@
 		init_task.signal->rlim[RLIMIT_NPROC];
 }
 
-int __attribute__((weak)) arch_dup_task_struct(struct task_struct *dst,
-					       struct task_struct *src)
-{
-	*dst = *src;
-	return 0;
-}
-
 static struct task_struct *dup_task_struct(struct task_struct *orig)
 {
 	struct task_struct *tsk;
@@ -200,15 +182,15 @@
 		return NULL;
 	}
 
- 	err = arch_dup_task_struct(tsk, orig);
-	if (err)
-		goto out;
-
+	*tsk = *orig;
 	tsk->stack = ti;
 
 	err = prop_local_init_single(&tsk->dirties);
-	if (err)
-		goto out;
+	if (err) {
+		free_thread_info(ti);
+		free_task_struct(tsk);
+		return NULL;
+	}
 
 	setup_thread_stack(tsk, orig);
 
@@ -224,11 +206,6 @@
 #endif
 	tsk->splice_pipe = NULL;
 	return tsk;
-
-out:
-	free_thread_info(ti);
-	free_task_struct(tsk);
-	return NULL;
 }
 
 #ifdef CONFIG_MMU
======================================================================


Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
