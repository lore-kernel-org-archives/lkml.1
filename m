Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbZDVWHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbZDVWHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 18:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbZDVWHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 18:07:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46845 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555AbZDVWHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 18:07:39 -0400
Date: Thu, 23 Apr 2009 00:04:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ptracee data structures cleanup
Message-ID: <20090422220400.GA22755@redhat.com>
References: <20090330185146.D525AFC3AB@magilla.sf.frob.com> <20090408203954.GA26816@redhat.com> <20090416204004.GA28013@redhat.com> <20090416232430.4DAE4FC3C6@magilla.sf.frob.com> <20090420183718.GC32527@redhat.com> <20090421011354.4B19EFC3C7@magilla.sf.frob.com> <20090421214819.GA22845@redhat.com> <20090422032205.B8D39FC3C7@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <20090422032205.B8D39FC3C7@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 04/21, Roland McGrath wrote:
>
> [We have been on fine details here that are quite purely ptrace innards for
> a while now.  I think discussion at this level of detail about this stuff
> quite far from utrace per se belongs on LKML.]

Agreed. s/utrace-devel/lkml/.

> > > The clean-up should get rid of PT_DTRACE entirely.
> >
> > Agreed. But this needs another patch...
>
> Yes, or several.  It always gets fiddly when to get lots of little arch
> changes merged.  The 90% that are just one-liner removal of wholly unused
> PT_DTRACE can probably go in as a single patch to Linus instead of tiny
> ones through each arch tree.

OK. I'd like to finally do at least something. Please look at the 4 patches
attached.

Unfortunately, I know nothing about these arches, so I can only rely on grep.
But it really looks like nobody except arch/um actually uses DTRACE.

There are also some strange defines in blackfin and m68k, PF_DTRACE_BIT and
PT_DTRACE_BIT, which seems to be unused too. At least I failed to find
anything related in asm. Perhaps I should learn how to cross compile.

Oleg.


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="DT_1_NOP.patch"

h8300 "defines" PT_DTRACE for asm but never uses it, kill this.

DEFINE(PT_PTRACED, PT_PTRACED) seems to be unused too.

--- PTRACE/arch/h8300/kernel/asm-offsets.c~DT_1_NOP	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/h8300/kernel/asm-offsets.c	2009-04-22 21:29:00.000000000 +0200
@@ -55,7 +55,6 @@ int main(void)
 	DEFINE(LRET,  offsetof(struct pt_regs, pc)       - sizeof(long));
 
 	DEFINE(PT_PTRACED, PT_PTRACED);
-	DEFINE(PT_DTRACE, PT_DTRACE);
 
 	return 0;
 }

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="DT_2_CLEAR.patch"

avr32, mn10300, parisc, s390, sh, xtensa:

they never set PT_DTRACE, but clear it after do_execve().

--- PTRACE/arch/avr32/kernel/process.c~DT_2_CLEAR	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/avr32/kernel/process.c	2009-04-22 21:35:25.000000000 +0200
@@ -394,8 +394,6 @@ asmlinkage int sys_execve(char __user *u
 		goto out;
 
 	error = do_execve(filename, uargv, uenvp, regs);
-	if (error == 0)
-		current->ptrace &= ~PT_DTRACE;
 	putname(filename);
 
 out:
--- PTRACE/arch/mn10300/kernel/process.c~DT_2_CLEAR	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/mn10300/kernel/process.c	2009-04-22 21:38:00.000000000 +0200
@@ -281,9 +281,6 @@ asmlinkage long sys_execve(char __user *
 	error = PTR_ERR(filename);
 	if (!IS_ERR(filename)) {
 		error = do_execve(filename, argv, envp, __frame);
-		if (error == 0)
-			current->ptrace &= ~PT_DTRACE;
-
 		putname(filename);
 	}
 
--- PTRACE/arch/parisc/hpux/fs.c~DT_2_CLEAR	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/parisc/hpux/fs.c	2009-04-22 21:39:00.000000000 +0200
@@ -44,11 +44,6 @@ int hpux_execve(struct pt_regs *regs)
 	error = do_execve(filename, (char __user * __user *) regs->gr[25],
 		(char __user * __user *) regs->gr[24], regs);
 
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 
 out:
--- PTRACE/arch/parisc/kernel/process.c~DT_2_CLEAR	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/parisc/kernel/process.c	2009-04-22 21:41:57.000000000 +0200
@@ -349,11 +349,6 @@ asmlinkage int sys_execve(struct pt_regs
 		goto out;
 	error = do_execve(filename, (char __user * __user *) regs->gr[25],
 		(char __user * __user *) regs->gr[24], regs);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 out:
 
--- PTRACE/arch/parisc/kernel/sys_parisc32.c~DT_2_CLEAR	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/parisc/kernel/sys_parisc32.c	2009-04-22 21:42:19.000000000 +0200
@@ -77,11 +77,6 @@ asmlinkage int sys32_execve(struct pt_re
 		goto out;
 	error = compat_do_execve(filename, compat_ptr(regs->gr[25]),
 				 compat_ptr(regs->gr[24]), regs);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 out:
 
--- PTRACE/arch/s390/kernel/compat_linux.c~DT_2_CLEAR	2009-04-22 20:49:07.000000000 +0200
+++ PTRACE/arch/s390/kernel/compat_linux.c	2009-04-22 21:45:01.000000000 +0200
@@ -461,9 +461,6 @@ asmlinkage long sys32_execve(void)
 		result = rc;
 		goto out_putname;
 	}
-	task_lock(current);
-	current->ptrace &= ~PT_DTRACE;
-	task_unlock(current);
 	current->thread.fp_regs.fpc=0;
 	asm volatile("sfpc %0,0" : : "d" (0));
 	result = regs->gprs[2];
--- PTRACE/arch/s390/kernel/process.c~DT_2_CLEAR	2009-04-06 00:03:36.000000000 +0200
+++ PTRACE/arch/s390/kernel/process.c	2009-04-22 21:45:27.000000000 +0200
@@ -265,9 +265,6 @@ SYSCALL_DEFINE0(vfork)
 
 asmlinkage void execve_tail(void)
 {
-	task_lock(current);
-	current->ptrace &= ~PT_DTRACE;
-	task_unlock(current);
 	current->thread.fp_regs.fpc = 0;
 	if (MACHINE_HAS_IEEE)
 		asm volatile("sfpc %0,%0" : : "d" (0));
--- PTRACE/arch/sh/kernel/process_32.c~DT_2_CLEAR	2009-04-06 00:03:36.000000000 +0200
+++ PTRACE/arch/sh/kernel/process_32.c	2009-04-22 21:46:30.000000000 +0200
@@ -366,11 +366,6 @@ asmlinkage int sys_execve(char __user *u
 		goto out;
 
 	error = do_execve(filename, uargv, uenvp, regs);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 out:
 	return error;
--- PTRACE/arch/sh/kernel/process_64.c~DT_2_CLEAR	2009-04-06 00:03:36.000000000 +0200
+++ PTRACE/arch/sh/kernel/process_64.c	2009-04-22 21:46:52.000000000 +0200
@@ -529,11 +529,6 @@ asmlinkage int sys_execve(char *ufilenam
 			  (char __user * __user *)uargv,
 			  (char __user * __user *)uenvp,
 			  pregs);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 out:
 	return error;
--- PTRACE/arch/xtensa/kernel/process.c~DT_2_CLEAR	2009-04-06 00:03:37.000000000 +0200
+++ PTRACE/arch/xtensa/kernel/process.c	2009-04-22 21:48:13.000000000 +0200
@@ -331,11 +331,6 @@ long xtensa_execve(char __user *name, ch
 	if (IS_ERR(filename))
 		goto out;
 	error = do_execve(filename, argv, envp, regs);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 out:
 	return error;

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="DT_3_SET.patch"

m68k sets PT_DTRACE in trap_c() but never uses it.

--- PTRACE/arch/m68k/kernel/traps.c~DT_3_SET	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/m68k/kernel/traps.c	2009-04-22 21:52:23.000000000 +0200
@@ -1057,7 +1057,6 @@ asmlinkage void trap_c(struct frame *fp)
 	if (fp->ptregs.sr & PS_S) {
 		if ((fp->ptregs.vector >> 2) == VEC_TRACE) {
 			/* traced a trapping instruction */
-			current->ptrace |= PT_DTRACE;
 		} else
 			bad_super_trap(fp);
 		return;
--- PTRACE/arch/m68knommu/kernel/asm-offsets.c~DT_3_SET	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/m68knommu/kernel/asm-offsets.c	2009-04-22 21:53:46.000000000 +0200
@@ -79,7 +79,6 @@ int main(void)
 	DEFINE(TRAP_TRACE, TRAP_TRACE);
 
 	DEFINE(PT_PTRACED, PT_PTRACED);
-	DEFINE(PT_DTRACE, PT_DTRACE);
 
 	DEFINE(THREAD_SIZE, THREAD_SIZE);
 
--- PTRACE/arch/m68knommu/kernel/traps.c~DT_3_SET	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/m68knommu/kernel/traps.c	2009-04-22 21:54:29.000000000 +0200
@@ -200,7 +200,6 @@ asmlinkage void trap_c(struct frame *fp)
 	if (fp->ptregs.sr & PS_S) {
 		if ((fp->ptregs.vector >> 2) == VEC_TRACE) {
 			/* traced a trapping instruction */
-			current->ptrace |= PT_DTRACE;
 		} else
 			bad_super_trap(fp);
 		return;

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="DT_4_m32r.patch"

m32r: PTRACE_SINGLESTEP sets PT_DTRACE, it is never used except cleared
after do_execve().

--- PTRACE/arch/m32r/kernel/process.c~DT_4_m32r	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/m32r/kernel/process.c	2009-04-22 22:01:44.000000000 +0200
@@ -302,11 +302,6 @@ asmlinkage int sys_execve(char __user *u
 		goto out;
 
 	error = do_execve(filename, uargv, uenvp, &regs);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 out:
 	return error;
--- PTRACE/arch/m32r/kernel/ptrace.c~DT_4_m32r	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/m32r/kernel/ptrace.c	2009-04-22 22:00:13.000000000 +0200
@@ -676,10 +676,6 @@ arch_ptrace(struct task_struct *child, l
 		if (!valid_signal(data))
 			break;
 		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		if ((child->ptrace & PT_DTRACE) == 0) {
-			/* Spurious delayed TF traps may occur */
-			child->ptrace |= PT_DTRACE;
-		}
 
 		/* Compute next pc.  */
 		pc = get_stack_long(child, PT_BPC);

--HlL+5n6rz5pIUxbD--

