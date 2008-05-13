Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbYEMBKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbYEMBKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 21:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756370AbYEMBKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 21:10:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:64314 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586AbYEMBKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 21:10:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,476,1204531200"; 
   d="scan'208";a="383017360"
Date: Mon, 12 May 2008 18:10:30 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       andi@firstfloor.org, roland@redhat.com, drepper@redhat.com,
       Hongjiu.lu@intel.com
Cc: linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       rmk+lkml@arm.linux.org.uk, dan@debian.org, asit.k.mallick@intel.com
Subject: [RFC] x86: xsave/xrstor support, ucontext_t extensions
Message-ID: <20080513011030.GA31448@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

Appended patch adds the support for xsave/xrstor infrastructure for x86.
xsave/xrstor manages the existing and future processor extended states in x86
architecutre.

More info on xsave/xrstor can be found in the Intel SDM's located at
http://www.intel.com/products/processor/manuals/index.htm

Please let me know your feedback and comments. Specifically, I am not sure
if I break anything or make anyone's life harder with the ucontext_t extensions
that are proposed in the patch.

Similar to fpstate, xsave state need to be saved/restored across signals.
x86 sigcontext doesn't seem to have any unused space, while x86_64 has
some unused space(reserved1[8]) in sigcontext.

To keep it consistent across 32bit and 64bit, ucontext is extended with
the new state context. Please review and let me know if you foresee any
compatibility or other issues with these extensions.

BTW, Traditionally glibc has this definition for struct ucontext.

/* Userlevel context.  */
typedef struct ucontext
  {
    unsigned long int uc_flags;
    struct ucontext *uc_link;
    stack_t uc_stack;
    mcontext_t uc_mcontext;
    __sigset_t uc_sigmask;
    struct _libc_fpstate __fpregs_mem;
  } ucontext_t;

And application uses the same structure for get/setcontext() routines and
to refer process context in signal handler routines.

Kernel which sets up the signal handling context has this definition:

struct ucontext {
	unsigned long	  uc_flags;
	struct ucontext  *uc_link;
	stack_t		  uc_stack;
	struct sigcontext uc_mcontext;
	sigset_t	  uc_sigmask;
};

Though the kernel Vs user ucontext look somewhat similar, kernel's ucontext
struct is different from glibc's ucontext struct because of sigset_t size
differences between user Vs kernel. So fpstate in signal handlers must always
be referred through the pointer in sigcontext, and not directly through
__fpregs_mem in userlevels ucontext struct.

glibc perhaps need to use different context structures, one for
get/setcontext() and another for signal handling? Signal handling
context will be governed by the kernel and context info
referred by get/setcontext() will be governed by glibc. This is specfically
needed if glibc's get/setcontext() want to play with xsave info aswell.

This kernel patch is adding a pointer to ucontext for representing 
xsave context (size of this area will be determined by the processor
and kernel capabilities). If at some point, this state need to be saved/restored
by get/setcontext() glibc routines and if they want to support application usage
like:

ucontext_t context;

void save()
{
	getcontext(&context);
}

void restore()
{
	setcontext(&context);
}

then, context information used by get/setcontext() need to evolve independently
from the signal handler context information provided by the kernel.

Comments?

thanks,
suresh

---
[RFC] x86: xsave/xrstor support

The layout of the xsave/xrstor area extends from the 512-byte FXSAVE/FXRSTOR
layout.  xsave/xrstor area layout consists of:

     - fxsave/fxrstor area (512 bytes)
     - xsave header area (64 bytes)
     - set of save areas, each corresponding to a processor extended state

The number of save areas, the offset and the size of each save area is
enumerated by CPUID leaf function 0xd. 

This patch includes the basic xsave/xrstor infrastructure, which includes:
      - context switch support,  extending traditional lazy restore mechanism
      - signal handling support, extending ucontext_t

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: linux-2.6-x86/arch/x86/kernel/xsave.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-x86/arch/x86/kernel/xsave.c	2008-05-12 13:09:56.000000000 -0700
@@ -0,0 +1,272 @@
+/*
+ * xsave/xrstor support.
+ *
+ * Suresh Siddha <suresh.b.siddha@intel.com>
+ */
+#include <linux/bootmem.h>
+#include <linux/compat.h>
+#include <asm/i387.h>
+
+#ifdef CONFIG_X86_64
+#include <asm/sigcontext32.h>
+#endif
+
+unsigned int pcntxt_hmask, pcntxt_lmask;
+struct xsave_struct *init_xstate_buf;
+
+#ifdef CONFIG_X86_64
+/*
+ * Signal frame handlers.
+ */
+int save_i387_xstate(void __user *buf)
+{
+	struct task_struct *tsk = current;
+	int err = 0;
+
+	if ((unsigned long)buf % 64)
+		printk("save_i387_xstate: bad xstate %p\n", buf);
+
+	clear_used_math(); /* trigger finit */
+	if (task_thread_info(tsk)->status & TS_USEDFPU) {
+		if (cpu_has_xsave)
+			err = save_xstate_checking(buf);
+		else
+			err = save_i387_checking(buf);
+
+		if (err)
+			return err;
+
+		task_thread_info(tsk)->status &= ~TS_USEDFPU;
+		stts();
+	} else {
+		if (__copy_to_user(buf, &tsk->thread.xstate->fxsave,
+				   xstate_size))
+			return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * This restores directly out of user space. Exceptions are handled.
+ */
+int restore_i387_xstate(struct _fpstate __user *buf,
+			struct xstate_cntxt __user *buf1)
+{
+	int err = 0;
+	int size = 0;
+	unsigned int lmask = 0, hmask = 0;
+	struct _xstate __user *xstate = 0;
+
+	if (cpu_has_xsave) {
+		__get_user(size, &buf1->size);
+		__get_user(lmask, &buf1->lmask);
+		__get_user(hmask, &buf1->hmask);
+		__get_user(xstate, &buf1->xstate);
+	}
+
+	if (!buf && !xstate)
+		goto init_state;
+
+	set_used_math();
+	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
+		clts();
+		task_thread_info(current)->status |= TS_USEDFPU;
+	}
+
+	if (xstate) {
+		err = xrestore_checking((struct xsave_struct *) xstate, size,
+					lmask, hmask);
+		if (err)
+			goto init_state;
+		/*
+		 * initialize the other extended state that the kernel
+		 * knows and not specifed in the user restore masks.
+		 */
+		init_xstate(pcntxt_lmask & ~(XSTATE_FPSSE |  lmask),
+			    pcntxt_hmask & ~hmask);
+	} else
+		init_xstate(pcntxt_lmask & ~XSTATE_FPSSE, pcntxt_hmask);
+
+	if (buf) {
+		if (!access_ok(VERIFY_READ, buf, sizeof(*buf))) {
+			err = -1;
+			goto init_state;
+		}
+
+		err = restore_fpu_checking(buf);
+		if (err)
+			goto init_state;
+	} else
+		init_xstate(XSTATE_FPSSE, 0);
+
+	if (!err)
+		return 0;
+
+init_state:
+	if (used_math()) {
+		clear_fpu(current);
+		clear_used_math();
+	}
+
+	return err;
+}
+#endif
+
+#ifndef CONFIG_X86_64
+# define _fpstate_ia32 _fpstate
+# define xstate_cntxt_ia32 xstate_cntxt
+#endif
+
+/*
+ * FP and extended context restore during signal return. Extended state is
+ * restored directly from user space. Exceptions are handled.
+ */
+int restore_user_xstate(struct _fpstate_ia32 __user *buf,
+			struct xstate_cntxt_ia32  __user *buf1)
+{
+	int err = 0;
+	struct task_struct *tsk = current;
+	int size = 0, lmask = 0, hmask = 0;
+	struct _xstate *xstate;
+
+	if (!buf && !buf1)
+		goto init_state;
+
+	set_used_math();
+	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
+		clts();
+		task_thread_info(current)->status |= TS_USEDFPU;
+	}
+
+	__get_user(size, &buf1->size);
+	__get_user(lmask, &buf1->lmask);
+	__get_user(hmask, &buf1->hmask);
+
+#ifdef CONFIG_IA32_EMULATION
+	{
+		u32 tmp;
+		__get_user(tmp, &buf1->xstate);
+		xstate = compat_ptr(tmp);
+	}
+#else
+	__get_user(xstate, &buf1->xstate);
+#endif
+
+	if (xstate) {
+		/*
+		 * Restore directly from the user space and handle the possible
+		 * exception. This way, we don't have to do manual error
+		 * checking on the user buffer contents.
+		 */
+		err = xrestore_checking((__force struct xsave_struct *) xstate,
+					size, lmask, hmask);
+		if (err)
+			return err;
+		/*
+		 * initialize the other extended state that the kernel
+		 * knows and not specifed in the user restore masks.
+		 */
+		init_xstate(pcntxt_lmask & ~(XSTATE_FPSSE |  lmask),
+			    pcntxt_hmask & ~hmask);
+	} else
+		init_xstate(pcntxt_lmask & ~XSTATE_FPSSE, pcntxt_hmask);
+
+	/*
+	 * FP and SSE state can't be restored directly from the userspace
+	 * because of legacy reasons. Lets restore it to the fpstate
+	 * in the task struct.
+	 */
+	unlazy_fpu(tsk);
+
+	if (buf) {
+		/*
+		 * legacy FP and SSE restore.
+		 */
+		err = restore_i387_fxsave(buf);
+		if (err)
+			return err;
+	} else
+		/*
+		 * initialize tasks fpstate in the memory.
+		 */
+		init_task_fpstate(tsk);
+
+	return err;
+
+init_state:
+	if (used_math()) {
+		clear_fpu(current);
+		clear_used_math();
+	}
+
+	return err;
+}
+
+/*
+ * Enable the extended processor state save/restore feature
+ */
+void __cpuinit xsave_init(void)
+{
+	if (!cpu_has_xsave)
+		return;
+
+	set_in_cr4(X86_CR4_OSXSAVE);
+
+	/*
+	 * Enable all the features that the HW is capable of
+	 * and the Linux kernel is aware of.
+	 *
+	 * xsetbv();
+	 */
+	asm volatile(".byte 0x0f,0x01,0xd1"::"c" (0),
+		     "a" (pcntxt_lmask), "d" (pcntxt_hmask));
+}
+
+/*
+ * setup the xstate image representing the init state
+ */
+void setup_xstate_init(void)
+{
+	init_xstate_buf = alloc_bootmem(xstate_size);
+	init_xstate_buf->i387.mxcsr = MXCSR_DEFAULT;
+}
+
+/*
+ * Enable and initialize the xsave feature.
+ */
+void __init xsave_cntxt_init(void)
+{
+	unsigned int eax, ebx, ecx, edx;
+
+	cpuid_count(0xd, 0, &eax, &ebx, &ecx, &edx);
+
+	pcntxt_lmask = eax;
+	pcntxt_hmask = edx;
+
+	if ((pcntxt_lmask & XSTATE_FPSSE) != XSTATE_FPSSE) {
+		printk("FP/SSE not shown under xsave features %x\n",
+		       pcntxt_lmask);
+		BUG();
+	}
+
+	/*
+	 * for now OS knows only about FP/SSE
+	 */
+	pcntxt_lmask = pcntxt_lmask & XCNTXT_LMASK;
+	pcntxt_hmask = pcntxt_hmask & XCNTXT_HMASK;
+
+	xsave_init();
+
+	/*
+	 * Recompute the context size for enabled features
+	 */
+	cpuid_count(0xd, 0, &eax, &ebx, &ecx, &edx);
+
+	xstate_size = ebx;
+
+	setup_xstate_init();
+
+	printk("xsave/xrstor: cntxt size %x, supported lmask %x, hmask %x\n",
+	       xstate_size, pcntxt_lmask, pcntxt_hmask);
+}
Index: linux-2.6-x86/include/asm-x86/xsave.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-x86/include/asm-x86/xsave.h	2008-05-12 14:43:07.000000000 -0700
@@ -0,0 +1,120 @@
+#ifndef __ASM_X86_64_XSAVE_H
+#define __ASM_X86_64_XSAVE_H
+
+#include <asm/processor.h>
+#include <asm/i387.h>
+
+#define XSTATE_FP	0x1
+#define XSTATE_SSE	0x2
+
+#define XSTATE_FPSSE	(XSTATE_FP | XSTATE_SSE)
+
+#define FXSAVE_SIZE	512
+
+/*
+ * These are the masks that OS can handle currently.
+ */
+#define XCNTXT_LMASK	(XSTATE_FP | XSTATE_SSE)
+#define XCNTXT_HMASK	0x0
+
+#ifdef CONFIG_X86_64
+#define REX_PREFIX	"0x48, "
+#else
+#define REX_PREFIX
+#endif
+
+extern unsigned int xstate_size, pcntxt_hmask, pcntxt_lmask;
+extern struct xsave_struct *init_xstate_buf;
+
+extern void xsave_cntxt_init(void);
+extern void xsave_init(void);
+
+static inline void xrstor(struct xsave_struct *fx)
+{
+	asm volatile(".byte " REX_PREFIX "0x0f,0xae,0x2f\n\t"
+		     :: "D" (fx), "m" (*fx), "a" (-1), "d" (-1) : "memory");
+}
+
+static inline int xsave(struct task_struct *tsk)
+{
+	/* This, however, we can work around by forcing the compiler to select
+	   an addressing mode that doesn't require extended registers. */
+	__asm__ __volatile__(".byte " REX_PREFIX "0x0f,0xae,0x27"
+			     ::"D" (&(tsk->thread.xstate->xsave)),
+			       "a" (-1), "d"(-1) : "memory");
+
+	return 0;
+}
+
+static inline int save_xstate_checking(struct xsave_struct __user *buf)
+{
+	int err;
+	__asm__ __volatile__("1: .byte " REX_PREFIX "0x0f,0xae,0x27\n"
+			     "2:\n"
+			     ".section .fixup,\"ax\"\n"
+			     "3:  movl $-1,%[err]\n"
+			     "    jmp  2b\n"
+			     ".previous\n"
+			     ".section __ex_table,\"a\"\n"
+			     _ASM_ALIGN "\n"
+			     _ASM_PTR "1b,3b\n"
+			     ".previous"
+			     : [err] "=r" (err)
+			     : "D" (buf), "a" (-1), "d" (-1), "0" (0)
+			     : "memory");
+	if (unlikely(err) && __clear_user(buf, xstate_size))
+		err = -EFAULT;
+	/* No need to clear here because the caller clears USED_MATH */
+	return err;
+}
+
+static inline int xrestore_checking(struct xsave_struct __user *buf,
+				    int size, unsigned int lmask,
+				    unsigned int hmask)
+{
+	int err;
+	struct xsave_struct *xstate = ((__force struct xsave_struct *)buf);
+	int eax = lmask & ~0x3;
+	int edx = hmask;
+
+	if (!access_ok(VERIFY_READ, buf, size))
+		return -1;
+
+	__asm__ __volatile__("1: .byte " REX_PREFIX "0x0f,0xae,0x2f\n"
+			     "2:\n"
+			     ".section .fixup,\"ax\"\n"
+			     "3:  movl $-1,%[err]\n"
+			     "    jmp  2b\n"
+			     ".previous\n"
+			     ".section __ex_table,\"a\"\n"
+			     _ASM_ALIGN "\n"
+			     _ASM_PTR "1b,3b\n"
+			     ".previous"
+			     : [err] "=r" (err)
+			     : "D" (xstate), "a" (eax), "d" (edx), "0" (0)
+			     : "memory");	//memory required?
+	return err;
+}
+
+static inline void xrstor_state(struct xsave_struct *fx, int lmask, int hmask)
+{
+	asm volatile(".byte " REX_PREFIX "0x0f,0xae,0x2f\n\t"
+		     :: "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
+		     : "memory");
+}
+
+static inline void init_xstate(int lmask, int hmask)
+{
+	if (cpu_has_xsave)
+		xrstor_state(init_xstate_buf, lmask, hmask);
+}
+
+static inline void init_task_fpstate(struct task_struct *tsk)
+{
+	struct xsave_struct *xstate = &tsk->thread.xstate->xsave;
+	if (cpu_has_xsave) {
+		xstate->xsave_hdr.xstate_bv &= ~XSTATE_FPSSE;
+		xstate->i387.mxcsr = MXCSR_DEFAULT;
+	}
+}
+#endif
Index: linux-2.6-x86/include/asm-x86/processor-flags.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor-flags.h	2008-05-12 13:09:03.000000000 -0700
+++ linux-2.6-x86/include/asm-x86/processor-flags.h	2008-05-12 13:09:56.000000000 -0700
@@ -59,6 +59,7 @@
 #define X86_CR4_OSFXSR	0x00000200 /* enable fast FPU save and restore */
 #define X86_CR4_OSXMMEXCPT 0x00000400 /* enable unmasked SSE exceptions */
 #define X86_CR4_VMXE	0x00002000 /* enable VMX virtualization */
+#define X86_CR4_OSXSAVE 0x00040000 /* enable xsave and xrestore */
 
 /*
  * x86-64 Task Priority Register, CR8
Index: linux-2.6-x86/arch/x86/kernel/traps_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/traps_64.c	2008-05-12 13:09:02.000000000 -0700
+++ linux-2.6-x86/arch/x86/kernel/traps_64.c	2008-05-12 13:09:56.000000000 -0700
@@ -1155,7 +1155,7 @@
 	}
 
 	clts();			/* Allow maths ops (or we recurse) */
-	restore_fpu_checking(&me->thread.xstate->fxsave);
+	restore_fpu_xstate(me);
 	task_thread_info(me)->status |= TS_USEDFPU;
 	me->fpu_counter++;
 }
@@ -1191,10 +1191,6 @@
 #endif
        
 	/*
-	 * initialize the per thread extended state:
-	 */
-        init_thread_xstate();
-	/*
 	 * Should be a barrier for any external CPU state.
 	 */
 	cpu_init();
Index: linux-2.6-x86/arch/x86/kernel/signal_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/signal_64.c	2008-05-12 13:09:02.000000000 -0700
+++ linux-2.6-x86/arch/x86/kernel/signal_64.c	2008-05-12 13:09:56.000000000 -0700
@@ -59,7 +59,7 @@
  */
 static int
 restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
-		   unsigned long *pax)
+		   struct xstate_cntxt __user *uc_xstate, unsigned long *pax)
 {
 	unsigned int err = 0;
 
@@ -99,24 +99,11 @@
 		struct _fpstate __user * buf;
 		err |= __get_user(buf, &sc->fpstate);
 
-		if (buf) {
-			if (!access_ok(VERIFY_READ, buf, sizeof(*buf)))
-				goto badframe;
-			err |= restore_i387(buf);
-		} else {
-			struct task_struct *me = current;
-			if (used_math()) {
-				clear_fpu(me);
-				clear_used_math();
-			}
-		}
+		err |= restore_i387_xstate(buf, uc_xstate);
 	}
 
 	err |= __get_user(*pax, &sc->ax);
 	return err;
-
-badframe:
-	return 1;
 }
 
 asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
@@ -137,7 +124,8 @@
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 	
-	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
+	if (restore_sigcontext(regs, &frame->uc.uc_mcontext,
+			       &frame->uc.uc_xstate, &ax))
 		goto badframe;
 
 	if (do_sigaltstack(&frame->uc.uc_stack, NULL, regs->sp) == -EFAULT)
@@ -155,7 +143,8 @@
  */
 
 static inline int
-setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs, unsigned long mask, struct task_struct *me)
+setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs,
+		 unsigned long mask, struct task_struct *me)
 {
 	int err = 0;
 
@@ -207,7 +196,7 @@
 			sp = current->sas_ss_sp + current->sas_ss_size;
 	}
 
-	return (void __user *)round_down(sp - size, 16);
+	return (void __user *)round_down(sp - size, 64);
 }
 
 static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
@@ -219,14 +208,14 @@
 	struct task_struct *me = current;
 
 	if (used_math()) {
-		fp = get_stack(ka, regs, sizeof(struct _fpstate)); 
+		fp = get_stack(ka, regs, xstate_size);
 		frame = (void __user *)round_down(
 			(unsigned long)fp - sizeof(struct rt_sigframe), 16) - 8;
 
-		if (!access_ok(VERIFY_WRITE, fp, sizeof(struct _fpstate)))
+		if (!access_ok(VERIFY_WRITE, fp, xstate_size))
 			goto give_sigsegv;
 
-		if (save_i387(fp) < 0) 
+		if (save_i387_xstate(fp) < 0)
 			err |= -1; 
 	} else
 		frame = get_stack(ka, regs, sizeof(struct rt_sigframe)) - 8;
@@ -249,6 +238,19 @@
 	err |= __put_user(me->sas_ss_size, &frame->uc.uc_stack.ss_size);
 	err |= setup_sigcontext(&frame->uc.uc_mcontext, regs, set->sig[0], me);
 	err |= __put_user(fp, &frame->uc.uc_mcontext.fpstate);
+
+	if (cpu_has_xsave) {
+		err |= __put_user(fp, &frame->uc.uc_xstate.xstate);
+		err |= __put_user(xstate_size, &frame->uc.uc_xstate.size);
+		err |= __put_user(pcntxt_lmask, &frame->uc.uc_xstate.lmask);
+		err |= __put_user(pcntxt_hmask, &frame->uc.uc_xstate.hmask);
+	} else {
+		err |= __put_user(0, &frame->uc.uc_xstate.xstate);
+		err |= __put_user(0, &frame->uc.uc_xstate.size);
+		err |= __put_user(0, &frame->uc.uc_xstate.lmask);
+		err |= __put_user(0, &frame->uc.uc_xstate.hmask);
+	}
+
 	if (sizeof(*set) == 16) { 
 		__put_user(set->sig[0], &frame->uc.uc_sigmask.sig[0]);
 		__put_user(set->sig[1], &frame->uc.uc_sigmask.sig[1]); 
Index: linux-2.6-x86/include/asm-x86/sigcontext.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/sigcontext.h	2008-05-12 13:09:03.000000000 -0700
+++ linux-2.6-x86/include/asm-x86/sigcontext.h	2008-05-12 14:54:21.000000000 -0700
@@ -202,4 +202,26 @@
 
 #endif /* !__i386__ */
 
+struct _xsave_hdr_struct {
+ 	u64 xstate_bv;
+ 	u64 reserved1[2];
+ 	u64 reserved2[5];
+} __attribute__((packed));
+
+struct _xstate {
+	/*
+	 * Applications need to refer to fpstate through fpstate pointer
+	 * in sigcontext. Not here directly.
+	 */
+ 	struct _fpstate fpstate;
+ 	struct _xsave_hdr_struct xsave_hdr;
+ 	/* new processor state extensions will go here */
+} __attribute__ ((aligned (64)));
+
+struct xstate_cntxt {
+	struct  _xstate __user *xstate;
+	u32	size;
+	u32 	lmask;
+	u32	hmask;
+};
 #endif
Index: linux-2.6-x86/arch/x86/ia32/ia32_signal.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/ia32/ia32_signal.c	2008-05-12 13:09:02.000000000 -0700
+++ linux-2.6-x86/arch/x86/ia32/ia32_signal.c	2008-05-12 13:09:56.000000000 -0700
@@ -174,9 +174,10 @@
 	u32 pretcode;
 	int sig;
 	struct sigcontext_ia32 sc;
-	struct _fpstate_ia32 fpstate;
+	struct xstate_cntxt_ia32 xst_cnxt;
 	unsigned int extramask[_COMPAT_NSIG_WORDS-1];
 	char retcode[8];
+	/* fp and rest of the extended context state follows here */
 };
 
 struct rt_sigframe
@@ -187,8 +188,8 @@
 	u32 puc;
 	compat_siginfo_t info;
 	struct ucontext_ia32 uc;
-	struct _fpstate_ia32 fpstate;
 	char retcode[8];
+	/* fp and rest of the extended context state follows here */
 };
 
 #define COPY(x)		{ 		\
@@ -207,7 +208,8 @@
 
 static int ia32_restore_sigcontext(struct pt_regs *regs,
 				   struct sigcontext_ia32 __user *sc,
-				   unsigned int *peax)
+				   unsigned int *peax,
+				   struct xstate_cntxt_ia32 __user *xst_cntxt)
 {
 	unsigned int tmpflags, gs, oldgs, err = 0;
 	struct _fpstate_ia32 __user *buf;
@@ -254,26 +256,13 @@
 
 	err |= __get_user(tmp, &sc->fpstate);
 	buf = compat_ptr(tmp);
-	if (buf) {
-		if (!access_ok(VERIFY_READ, buf, sizeof(*buf)))
-			goto badframe;
-		err |= restore_i387_ia32(buf);
-	} else {
-		struct task_struct *me = current;
 
-		if (used_math()) {
-			clear_fpu(me);
-			clear_used_math();
-		}
-	}
+	err |= restore_i387_xstate_ia32(buf, xst_cntxt);
 
 	err |= __get_user(tmp, &sc->ax);
 	*peax = tmp;
 
 	return err;
-
-badframe:
-	return 1;
 }
 
 asmlinkage long sys32_sigreturn(struct pt_regs *regs)
@@ -281,6 +270,7 @@
 	struct sigframe __user *frame = (struct sigframe __user *)(regs->sp-8);
 	sigset_t set;
 	unsigned int ax;
+	struct xstate_cntxt_ia32 __user *xst_cnxt = &frame->xst_cnxt;
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
@@ -297,7 +287,7 @@
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
-	if (ia32_restore_sigcontext(regs, &frame->sc, &ax))
+	if (ia32_restore_sigcontext(regs, &frame->sc, &ax, xst_cnxt))
 		goto badframe;
 	return ax;
 
@@ -326,7 +316,8 @@
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
-	if (ia32_restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
+	if (ia32_restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax,
+				    &frame->uc.uc_xstate))
 		goto badframe;
 
 	tregs = *regs;
@@ -345,8 +336,9 @@
  */
 
 static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
+				 struct pt_regs *regs, unsigned int mask,
 				 struct _fpstate_ia32 __user *fpstate,
-				 struct pt_regs *regs, unsigned int mask)
+				 struct xsave_struct __user *xstate)
 {
 	int tmp, err = 0;
 
@@ -376,7 +368,7 @@
 	err |= __put_user((u32)regs->flags, &sc->flags);
 	err |= __put_user((u32)regs->sp, &sc->sp_at_signal);
 
-	tmp = save_i387_ia32(fpstate);
+	tmp = save_i387_xstate_ia32(fpstate, xstate);
 	if (tmp < 0)
 		err = -EFAULT;
 	else {
@@ -397,7 +389,9 @@
  * Determine which stack to use..
  */
 static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
-				 size_t frame_size)
+				 int frame_size,
+				 struct _fpstate_ia32 **fpstate,
+				 struct xsave_struct **xstate)
 {
 	unsigned long sp;
 
@@ -416,7 +410,19 @@
 		 ka->sa.sa_restorer)
 		sp = (unsigned long) ka->sa.sa_restorer;
 
-	sp -= frame_size;
+	if (used_math()) {
+		sp = round_down(sp - xstate_size, 64);
+		if (cpu_has_xsave)
+			*xstate = (struct xsave_struct *) sp;
+
+		sp = sp - (sizeof(struct _fpstate_ia32) - FXSAVE_SIZE);
+
+		*fpstate = (struct _fpstate_ia32 *) sp;
+
+		sp = sp - frame_size;
+	} else
+		sp -= frame_size;
+
 	/* Align the stack pointer according to the i386 ABI,
 	 * i.e. so that on function entry ((sp + 4) & 15) == 0. */
 	sp = ((sp + 4) & -16ul) - 4;
@@ -429,6 +435,8 @@
 	struct sigframe __user *frame;
 	void __user *restorer;
 	int err = 0;
+	struct _fpstate_ia32 __user *fpstate = 0;
+	struct xsave_struct __user *xstate = 0;
 
 	/* copy_to_user optimizes that into a single 8 byte store */
 	static const struct {
@@ -443,7 +451,7 @@
 		0,
 	};
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate, &xstate);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
@@ -452,11 +460,24 @@
 	if (err)
 		goto give_sigsegv;
 
-	err |= ia32_setup_sigcontext(&frame->sc, &frame->fpstate, regs,
-					set->sig[0]);
+	err |= ia32_setup_sigcontext(&frame->sc, regs, set->sig[0],
+				     fpstate, xstate);
 	if (err)
 		goto give_sigsegv;
 
+	if (cpu_has_xsave) {
+		err |= __put_user(ptr_to_compat(xstate),
+				  &frame->xst_cnxt.xstate);
+		err |= __put_user(xstate_size, &frame->xst_cnxt.size);
+		err |= __put_user(pcntxt_lmask, &frame->xst_cnxt.lmask);
+		err |= __put_user(pcntxt_hmask, &frame->xst_cnxt.hmask);
+	} else {
+		err |= __put_user(0, &frame->xst_cnxt.xstate);
+		err |= __put_user(0, &frame->xst_cnxt.size);
+		err |= __put_user(0, &frame->xst_cnxt.lmask);
+		err |= __put_user(0, &frame->xst_cnxt.hmask);
+	}
+
 	if (_COMPAT_NSIG_WORDS > 1) {
 		err |= __copy_to_user(frame->extramask, &set->sig[1],
 				      sizeof(frame->extramask));
@@ -518,6 +539,8 @@
 	struct exec_domain *ed = current_thread_info()->exec_domain;
 	void __user *restorer;
 	int err = 0;
+	struct _fpstate_ia32 __user *fpstate = 0;
+	struct xsave_struct __user *xstate = 0;
 
 	/* __copy_to_user optimizes that into a single 8 byte store */
 	static const struct {
@@ -533,7 +556,7 @@
 		0,
 	};
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate, &xstate);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
@@ -553,8 +576,21 @@
 	err |= __put_user(sas_ss_flags(regs->sp),
 			  &frame->uc.uc_stack.ss_flags);
 	err |= __put_user(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
-	err |= ia32_setup_sigcontext(&frame->uc.uc_mcontext, &frame->fpstate,
-				     regs, set->sig[0]);
+	err |= ia32_setup_sigcontext(&frame->uc.uc_mcontext, regs, set->sig[0],
+				     fpstate, xstate);
+
+	if (cpu_has_xsave) {
+		err |= __put_user(ptr_to_compat(xstate), &frame->uc.uc_xstate.xstate);
+		err |= __put_user(xstate_size, &frame->uc.uc_xstate.size);
+		err |= __put_user(pcntxt_lmask, &frame->uc.uc_xstate.lmask);
+		err |= __put_user(pcntxt_hmask, &frame->uc.uc_xstate.hmask);
+	} else {
+		err |= __put_user(0, &frame->uc.uc_xstate.xstate);
+		err |= __put_user(0, &frame->uc.uc_xstate.size);
+		err |= __put_user(0, &frame->uc.uc_xstate.lmask);
+		err |= __put_user(0, &frame->uc.uc_xstate.hmask);
+	}
+
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
 		goto give_sigsegv;
Index: linux-2.6-x86/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/Makefile	2008-05-12 13:09:02.000000000 -0700
+++ linux-2.6-x86/arch/x86/kernel/Makefile	2008-05-12 13:09:56.000000000 -0700
@@ -31,7 +31,7 @@
 
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
 obj-y				+= process.o
-obj-y				+= i387.o
+obj-y				+= i387.o xsave.o
 obj-y				+= ptrace.o
 obj-y				+= ds.o
 obj-$(CONFIG_X86_32)		+= tls.o
Index: linux-2.6-x86/arch/x86/kernel/i387.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/i387.c	2008-05-12 13:09:47.000000000 -0700
+++ linux-2.6-x86/arch/x86/kernel/i387.c	2008-05-12 13:23:10.000000000 -0700
@@ -21,9 +21,10 @@
 # include <asm/sigcontext32.h>
 # include <asm/user32.h>
 #else
-# define save_i387_ia32		save_i387
-# define restore_i387_ia32	restore_i387
+# define save_i387_xstate_ia32	save_i387_xstate
+# define restore_i387_xstate_ia32	restore_i387_xstate
 # define _fpstate_ia32		_fpstate
+# define xstate_cntxt_ia32	xstate_cntxt
 # define user_i387_ia32_struct	user_i387_struct
 # define user32_fxsr_struct	user_fxsr_struct
 #endif
@@ -38,6 +39,21 @@
 unsigned int xstate_size;
 static struct i387_fxsave_struct fx_scratch __cpuinitdata;
 
+void __cpuinit init_thread_xstate(void)
+{
+	if (cpu_has_xsave) {
+		xsave_cntxt_init();
+		return;
+	}
+
+	if (cpu_has_fxsr)
+		xstate_size = sizeof(struct i387_fxsave_struct);
+#ifdef CONFIG_X86_32
+	else
+		xstate_size = sizeof(struct i387_fsave_struct);
+#endif
+}
+
 void __cpuinit mxcsr_feature_mask_init(void)
 {
 	unsigned long mask = 0;
@@ -54,16 +70,6 @@
 	stts();
 }
 
-void __init init_thread_xstate(void)
-{
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
@@ -78,7 +84,12 @@
 
 	write_cr0(oldcr0 & ~(X86_CR0_TS|X86_CR0_EM)); /* clear TS and EM */
 
+	if (!smp_processor_id())
+		init_thread_xstate();
+	xsave_init();
+
 	mxcsr_feature_mask_init();
+
 	/* clean state in init */
 	current_thread_info()->status = 0;
 	clear_used_math();
@@ -181,6 +192,9 @@
 	 */
 	target->thread.xstate->fxsave.mxcsr &= mxcsr_feature_mask;
 
+	if (cpu_has_xsave)
+		 target->thread.xstate->xsave.xsave_hdr.xstate_bv |= XSTATE_FPSSE;
+
 	return ret;
 }
 
@@ -381,6 +395,9 @@
 	if (!ret)
 		convert_to_fxsr(target, &env);
 
+	if (cpu_has_xsave)
+		 target->thread.xstate->xsave.xsave_hdr.xstate_bv |= XSTATE_FP;
+
 	return ret;
 }
 
@@ -393,7 +410,6 @@
 	struct task_struct *tsk = current;
 	struct i387_fsave_struct *fp = &tsk->thread.xstate->fsave;
 
-	unlazy_fpu(tsk);
 	fp->status = fp->swd;
 	if (__copy_to_user(buf, fp, sizeof(struct i387_fsave_struct)))
 		return -1;
@@ -407,8 +423,6 @@
 	struct user_i387_ia32_struct env;
 	int err = 0;
 
-	unlazy_fpu(tsk);
-
 	convert_from_fxsr(&env, tsk);
 	if (__copy_to_user(buf, &env, sizeof(env)))
 		return -1;
@@ -418,14 +432,15 @@
 	if (err)
 		return -1;
 
-	if (__copy_to_user(&buf->_fxsr_env[0], fx,
-			   sizeof(struct i387_fxsave_struct)))
+	if (__copy_to_user(&buf->_fxsr_env[0], fx, xstate_size))
 		return -1;
 	return 1;
 }
 
-int save_i387_ia32(struct _fpstate_ia32 __user *buf)
+int save_i387_xstate_ia32(struct _fpstate_ia32 __user *buf,
+		        struct xsave_struct __user *buf1)
 {
+	struct task_struct *tsk = current;
 	if (!used_math())
 		return 0;
 	/*
@@ -440,7 +455,12 @@
 				       NULL, buf) ? -1 : 1;
 	}
 
+	unlazy_fpu(tsk);
+
 	if (cpu_has_fxsr)
+		/*
+		 * saves the extended state including legacy fxsave.
+		 */
 		return save_i387_fxsave(buf);
 	else
 		return save_i387_fsave(buf);
@@ -450,18 +470,16 @@
 {
 	struct task_struct *tsk = current;
 
-	clear_fpu(tsk);
 	return __copy_from_user(&tsk->thread.xstate->fsave, buf,
 				sizeof(struct i387_fsave_struct));
 }
 
-static int restore_i387_fxsave(struct _fpstate_ia32 __user *buf)
+int restore_i387_fxsave(struct _fpstate_ia32 __user *buf)
 {
 	struct task_struct *tsk = current;
 	struct user_i387_ia32_struct env;
 	int err;
 
-	clear_fpu(tsk);
 	err = __copy_from_user(&tsk->thread.xstate->fxsave, &buf->_fxsr_env[0],
 			       sizeof(struct i387_fxsave_struct));
 	/* mxcsr reserved bits must be masked to zero for security reasons */
@@ -473,22 +491,56 @@
 	return 0;
 }
 
-int restore_i387_ia32(struct _fpstate_ia32 __user *buf)
+int restore_i387_xstate_ia32(struct _fpstate_ia32 __user *buf,
+			   struct xstate_cntxt_ia32 __user *buf1)
 {
-	int err;
+	int err = 0;
+	struct task_struct *tsk = current;
+
+	if (buf && !access_ok(VERIFY_READ, buf, sizeof(*buf))) {
+		err = -1;
+		goto init_state;
+	}
 
 	if (HAVE_HWFP) {
-		if (cpu_has_fxsr)
-			err = restore_i387_fxsave(buf);
-		else
-			err = restore_i387_fsave(buf);
+		clear_fpu(tsk);
+
+		if (!used_math()) {
+			err = init_fpu(tsk);
+			if (err)
+				return err;
+		}
+
+		if (cpu_has_xsave)
+			err = restore_user_xstate(buf, buf1);
+		else {
+			if (!buf)
+				goto init_state;
+
+			if (cpu_has_fxsr)
+				err = restore_i387_fxsave(buf);
+			else
+				err = restore_i387_fsave(buf);
+		}
 	} else {
 		err = fpregs_soft_set(current, NULL,
 				      0, sizeof(struct user_i387_ia32_struct),
 				      NULL, buf) != 0;
 	}
+
+	if (err)
+		goto init_state;
+
 	set_used_math();
 
+	return 0;
+
+init_state:
+	if (used_math()) {
+		clear_fpu(current);
+		clear_used_math();
+	}
+
 	return err;
 }
 
Index: linux-2.6-x86/arch/x86/kernel/signal_32.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/signal_32.c	2008-05-12 13:09:02.000000000 -0700
+++ linux-2.6-x86/arch/x86/kernel/signal_32.c	2008-05-12 13:09:56.000000000 -0700
@@ -26,6 +26,7 @@
 #include <asm/uaccess.h>
 #include <asm/i387.h>
 #include <asm/vdso.h>
+#include <asm/proto.h>
 
 #include "sigframe.h"
 
@@ -116,7 +117,7 @@
  */
 static int
 restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
-		   unsigned long *pax)
+		   unsigned long *pax,  struct xstate_cntxt __user *xst_cntxt)
 {
 	unsigned int err = 0;
 
@@ -162,25 +163,12 @@
 		struct _fpstate __user *buf;
 
 		err |= __get_user(buf, &sc->fpstate);
-		if (buf) {
-			if (!access_ok(VERIFY_READ, buf, sizeof(*buf)))
-				goto badframe;
-			err |= restore_i387(buf);
-		} else {
-			struct task_struct *me = current;
-
-			if (used_math()) {
-				clear_fpu(me);
-				clear_used_math();
-			}
-		}
+
+		err |= restore_i387_xstate(buf, xst_cntxt);
 	}
 
 	err |= __get_user(*pax, &sc->ax);
 	return err;
-
-badframe:
-	return 1;
 }
 
 asmlinkage unsigned long sys_sigreturn(unsigned long __unused)
@@ -189,9 +177,11 @@
 	struct pt_regs *regs;
 	unsigned long ax;
 	sigset_t set;
+	struct xstate_cntxt __user *xst_cnxt;
 
 	regs = (struct pt_regs *) &__unused;
 	frame = (struct sigframe __user *)(regs->sp - 8);
+	xst_cnxt = &frame->xst_cnxt;
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
@@ -206,7 +196,7 @@
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
-	if (restore_sigcontext(regs, &frame->sc, &ax))
+	if (restore_sigcontext(regs, &frame->sc, &ax, xst_cnxt))
 		goto badframe;
 	return ax;
 
@@ -245,7 +235,8 @@
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
-	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
+	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax,
+			       &frame->uc.uc_xstate))
 		goto badframe;
 
 	if (do_sigaltstack(&frame->uc.uc_stack, NULL, regs->sp) == -EFAULT)
@@ -262,8 +253,10 @@
  * Set up a signal frame.
  */
 static int
-setup_sigcontext(struct sigcontext __user *sc, struct _fpstate __user *fpstate,
-		 struct pt_regs *regs, unsigned long mask)
+setup_sigcontext(struct sigcontext __user *sc,
+		 struct pt_regs *regs, unsigned long mask,
+		 struct _fpstate __user *fpstate,
+		 struct xsave_struct __user *xstate)
 {
 	int tmp, err = 0;
 
@@ -289,7 +282,7 @@
 	err |= __put_user(regs->sp, &sc->sp_at_signal);
 	err |= __put_user(regs->ss, (unsigned int __user *)&sc->ss);
 
-	tmp = save_i387(fpstate);
+	tmp = save_i387_xstate(fpstate, xstate);
 	if (tmp < 0)
 		err = 1;
 	else
@@ -306,7 +299,8 @@
  * Determine which stack to use..
  */
 static inline void __user *
-get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size)
+get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
+	     struct _fpstate **fpstate, struct xsave_struct **xstate)
 {
 	unsigned long sp;
 
@@ -332,7 +326,18 @@
 			sp = (unsigned long) ka->sa.sa_restorer;
 	}
 
-	sp -= frame_size;
+	if (used_math()) {
+		sp = round_down(sp - xstate_size, 64);
+		if (cpu_has_xsave)
+			*xstate = (struct xsave_struct *) sp;
+
+		sp = sp - (sizeof(struct _fpstate) - FXSAVE_SIZE);
+
+		*fpstate = (struct _fpstate *) sp;
+
+		sp -= frame_size;
+	} else
+		sp -= frame_size;
 	/*
 	 * Align the stack pointer according to the i386 ABI,
 	 * i.e. so that on function entry ((sp + 4) & 15) == 0.
@@ -350,10 +355,12 @@
 	void __user *restorer;
 	int err = 0;
 	int usig;
+	struct _fpstate __user *fpstate = 0;
+	struct xsave_struct __user *xstate = 0;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate, &xstate);
 
-	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
+	if (!access_ok(VERIFY_WRITE, frame, sizeof (*frame)))
 		goto give_sigsegv;
 
 	usig = current_thread_info()->exec_domain
@@ -366,9 +373,21 @@
 	if (err)
 		goto give_sigsegv;
 
-	err = setup_sigcontext(&frame->sc, &frame->fpstate, regs, set->sig[0]);
+	err = setup_sigcontext(&frame->sc, regs, set->sig[0],
+			       fpstate, xstate);
 	if (err)
 		goto give_sigsegv;
+	if (cpu_has_xsave) {
+		err |= __put_user(xstate, &frame->xst_cnxt.xstate);
+		err |= __put_user(xstate_size, &frame->xst_cnxt.size);
+		err |= __put_user(pcntxt_lmask, &frame->xst_cnxt.lmask);
+		err |= __put_user(pcntxt_hmask, &frame->xst_cnxt.hmask);
+	} else {
+		err |= __put_user(0, &frame->xst_cnxt.xstate);
+		err |= __put_user(0, &frame->xst_cnxt.size);
+		err |= __put_user(0, &frame->xst_cnxt.lmask);
+		err |= __put_user(0, &frame->xst_cnxt.hmask);
+	}
 
 	if (_NSIG_WORDS > 1) {
 		err = __copy_to_user(&frame->extramask, &set->sig[1],
@@ -427,8 +446,10 @@
 	void __user *restorer;
 	int err = 0;
 	int usig;
+	struct _fpstate __user *fpstate = 0;
+	struct xsave_struct __user *xstate = 0;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate, &xstate);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
@@ -453,8 +474,20 @@
 	err |= __put_user(sas_ss_flags(regs->sp),
 			  &frame->uc.uc_stack.ss_flags);
 	err |= __put_user(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
-	err |= setup_sigcontext(&frame->uc.uc_mcontext, &frame->fpstate,
-				regs, set->sig[0]);
+	err |= setup_sigcontext(&frame->uc.uc_mcontext, regs, set->sig[0],
+				fpstate, xstate);
+	if (cpu_has_xsave) {
+		err |= __put_user(xstate, &frame->uc.uc_xstate.xstate);
+		err |= __put_user(xstate_size, &frame->uc.uc_xstate.size);
+		err |= __put_user(pcntxt_lmask, &frame->uc.uc_xstate.lmask);
+		err |= __put_user(pcntxt_hmask, &frame->uc.uc_xstate.hmask);
+	} else {
+		err |= __put_user(0, &frame->uc.uc_xstate.xstate);
+		err |= __put_user(0, &frame->uc.uc_xstate.size);
+		err |= __put_user(0, &frame->uc.uc_xstate.lmask);
+		err |= __put_user(0, &frame->uc.uc_xstate.hmask);
+	}
+
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
 		goto give_sigsegv;
Index: linux-2.6-x86/include/asm-x86/cpufeature.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/cpufeature.h	2008-05-12 13:09:03.000000000 -0700
+++ linux-2.6-x86/include/asm-x86/cpufeature.h	2008-05-12 13:09:56.000000000 -0700
@@ -90,6 +90,7 @@
 #define X86_FEATURE_CX16	(4*32+13) /* CMPXCHG16B */
 #define X86_FEATURE_XTPR	(4*32+14) /* Send Task Priority Messages */
 #define X86_FEATURE_DCA		(4*32+18) /* Direct Cache Access */
+#define X86_FEATURE_XSAVE	(4*32+26) /* XSAVE */
 
 /* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 */
 #define X86_FEATURE_XSTORE	(5*32+ 2) /* on-CPU RNG present (xstore insn) */
@@ -187,6 +188,7 @@
 #define cpu_has_gbpages		boot_cpu_has(X86_FEATURE_GBPAGES)
 #define cpu_has_arch_perfmon	boot_cpu_has(X86_FEATURE_ARCH_PERFMON)
 #define cpu_has_pat		boot_cpu_has(X86_FEATURE_PAT)
+#define cpu_has_xsave		boot_cpu_has(X86_FEATURE_XSAVE)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
Index: linux-2.6-x86/include/asm-x86/i387.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/i387.h	2008-05-12 13:09:47.000000000 -0700
+++ linux-2.6-x86/include/asm-x86/i387.h	2008-05-12 14:46:43.000000000 -0700
@@ -18,6 +18,8 @@
 #include <asm/sigcontext.h>
 #include <asm/user.h>
 #include <asm/uaccess.h>
+#include <asm/xsave.h>
+#include <asm/percpu.h>
 
 extern void fpu_init(void);
 extern void mxcsr_feature_mask_init(void);
@@ -31,10 +33,19 @@
 
 #ifdef CONFIG_IA32_EMULATION
 struct _fpstate_ia32;
-extern int save_i387_ia32(struct _fpstate_ia32 __user *buf);
-extern int restore_i387_ia32(struct _fpstate_ia32 __user *buf);
+struct xstate_cntxt_ia32;
+extern int save_i387_xstate_ia32(struct _fpstate_ia32 __user *buf,
+				 struct xsave_struct __user *buf1);
+extern int restore_i387_xstate_ia32(struct _fpstate_ia32 __user *buf,
+				    struct xstate_cntxt_ia32 __user *buf1);
+extern int restore_user_xstate(struct _fpstate_ia32 __user *buf,
+			       struct xstate_cntxt_ia32 __user *buf1);
+
+extern int restore_i387_fxsave(struct _fpstate_ia32 __user *buf);
 #endif
 
+#define X87_FSW_ES (1 << 7)	/* Exception Summary */
+
 #ifdef CONFIG_X86_64
 
 /* Ignore delayed exceptions from user space */
@@ -45,9 +56,13 @@
 		     _ASM_EXTABLE(1b, 2b));
 }
 
-static inline int restore_fpu_checking(struct i387_fxsave_struct *fx)
+static inline int restore_fpu_checking(struct _fpstate __user *buf)
 {
 	int err;
+	struct i387_fxsave_struct *fx = ((__force  struct i387_fxsave_struct *) buf);
+
+	if (!access_ok(VERIFY_READ, buf, sizeof(*buf)))
+		return -1;
 
 	asm volatile("1:  rex64/fxrstor (%[fx])\n\t"
 		     "2:\n"
@@ -62,20 +77,42 @@
 #else
 		     : [fx] "cdaSDb" (fx), "m" (*fx), "0" (0));
 #endif
-	if (unlikely(err))
-		init_fpu(current);
 	return err;
 }
 
-#define X87_FSW_ES (1 << 7)	/* Exception Summary */
+static inline void __fxrstor(struct i387_fxsave_struct *fx)
+{
+	asm volatile("1:  rex64/fxrstor (%[fx])\n\t"
+#if 0 /* See comment in __fxsave_clear() below. */
+		     :: [fx] "r" (fx), "m" (*fx));
+#else
+		     :: [fx] "cdaSDb" (fx), "m" (*fx));
+#endif
+}
+
+static inline void restore_fpu_xstate(struct task_struct *tsk)
+{
+	if (cpu_has_xsave)
+		xrstor(&tsk->thread.xstate->xsave);
+	else
+		__fxrstor(&tsk->thread.xstate->fxsave);
+}
 
 /* AMD CPUs don't save/restore FDP/FIP/FOP unless an exception
    is pending. Clear the x87 state here by setting it to fixed
    values. The kernel data segment can be sometimes 0 and sometimes
    new user value. Both should be ok.
    Use the PDA as safe address because it should be already in L1. */
-static inline void clear_fpu_state(struct i387_fxsave_struct *fx)
+static inline void clear_fpu_state(struct xsave_struct *xstate)
 {
+	struct i387_fxsave_struct *fx = (struct i387_fxsave_struct *) xstate;
+
+	/*
+	 * Header may indicate the init state of the FP.
+	 */
+	if (cpu_has_xsave && !(xstate->xsave_hdr.xstate_bv & XSTATE_FP))
+		return;
+
 	if (unlikely(fx->swd & X87_FSW_ES))
 		asm volatile("fnclex");
 	alternative_input(ASM_NOP8 ASM_NOP2,
@@ -108,7 +145,7 @@
 	return err;
 }
 
-static inline void __save_init_fpu(struct task_struct *tsk)
+static inline void __fxsave(struct task_struct *tsk)
 {
 	/* Using "rex64; fxsave %0" is broken because, if the memory operand
 	   uses any extended registers for addressing, a second REX prefix
@@ -133,55 +170,23 @@
 			     : "=m" (tsk->thread.xstate->fxsave)
 			     : "cdaSDb" (&tsk->thread.xstate->fxsave));
 #endif
-	clear_fpu_state(&tsk->thread.xstate->fxsave);
-	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
-/*
- * Signal frame handlers.
- */
-
-static inline int save_i387(struct _fpstate __user *buf)
+static inline void __save_init_fpu(struct task_struct *tsk)
 {
-	struct task_struct *tsk = current;
-	int err = 0;
-
-	BUILD_BUG_ON(sizeof(struct user_i387_struct) !=
-			sizeof(tsk->thread.xstate->fxsave));
-
-	if ((unsigned long)buf % 16)
-		printk("save_i387: bad fpstate %p\n", buf);
+	if (cpu_has_xsave)
+		xsave(tsk);
+	else
+		__fxsave(tsk);
 
-	if (!used_math())
-		return 0;
-	clear_used_math(); /* trigger finit */
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {
-		err = save_i387_checking((struct i387_fxsave_struct __user *)
-					 buf);
-		if (err)
-			return err;
-		task_thread_info(tsk)->status &= ~TS_USEDFPU;
-		stts();
-	} else {
-		if (__copy_to_user(buf, &tsk->thread.xstate->fxsave,
-				   sizeof(struct i387_fxsave_struct)))
-			return -1;
-	}
-	return 1;
+	clear_fpu_state(&tsk->thread.xstate->xsave);
+	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
-
 /*
- * This restores directly out of user space. Exceptions are handled.
+ * Signal frame handlers...
  */
-static inline int restore_i387(struct _fpstate __user *buf)
-{
-	set_used_math();
-	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
-		clts();
-		task_thread_info(current)->status |= TS_USEDFPU;
-	}
-	return restore_fpu_checking((__force struct i387_fxsave_struct *)buf);
-}
+extern int save_i387_xstate(void __user *buf);
+extern int restore_i387_xstate(struct _fpstate *buf, struct xstate_cntxt *buf1);
 
 #else  /* CONFIG_X86_32 */
 
@@ -190,8 +195,12 @@
 	asm volatile("fnclex ; fwait");
 }
 
-static inline void restore_fpu(struct task_struct *tsk)
+static inline void restore_fpu_xstate(struct task_struct *tsk)
 {
+	if (cpu_has_xsave) {
+		xrstor(&tsk->thread.xstate->xsave);
+		return;
+	}
 	/*
 	 * The "nop" is needed to make the instructions the same
 	 * length.
@@ -217,6 +226,21 @@
  */
 static inline void __save_init_fpu(struct task_struct *tsk)
 {
+	if (cpu_has_xsave) {
+		struct xsave_struct *xstate = &tsk->thread.xstate->xsave;
+		struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
+
+		xsave(tsk);
+
+		/*
+	 	 * Header may indicate the init state of the FP.
+	 	 */
+		if (!(xstate->xsave_hdr.xstate_bv & XSTATE_FP))
+			goto end;
+
+		if (unlikely(fx->swd & X87_FSW_ES))
+			asm volatile("fnclex");
+	} else {
 	/* Use more nops than strictly needed in case the compiler
 	   varies code */
 	alternative_input(
@@ -226,6 +250,7 @@
 		X86_FEATURE_FXSR,
 		[fx] "m" (tsk->thread.xstate->fxsave),
 		[fsw] "m" (tsk->thread.xstate->fxsave.swd) : "memory");
+	}
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
 	   values. safe_address is a random variable that should be in L1 */
@@ -235,15 +260,18 @@
 		"fildl %[addr]", 	/* set F?P to defined value */
 		X86_FEATURE_FXSAVE_LEAK,
 		[addr] "m" (safe_address));
+end:
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
-/*
- * Signal frame handlers...
- */
-extern int save_i387(struct _fpstate __user *buf);
-extern int restore_i387(struct _fpstate __user *buf);
+extern int save_i387_xstate(struct _fpstate __user *buf,
+			  struct xsave_struct __user *buf1);
+extern int restore_i387_xstate(struct _fpstate __user *buf,
+			     struct xstate_cntxt __user *buf1);
+extern int restore_user_xstate(struct _fpstate __user *buf,
+			       struct xstate_cntxt __user *buf1);
 
+extern int restore_i387_fxsave(struct _fpstate __user *buf);
 #endif	/* CONFIG_X86_64 */
 
 static inline void __unlazy_fpu(struct task_struct *tsk)
Index: linux-2.6-x86/include/asm-x86/processor.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor.h	2008-05-12 13:09:03.000000000 -0700
+++ linux-2.6-x86/include/asm-x86/processor.h	2008-05-12 14:53:38.000000000 -0700
@@ -351,10 +351,23 @@
 	u32			entry_eip;
 };
 
+struct xsave_hdr_struct {
+ 	u64 xstate_bv;
+ 	u64 reserved1[2];
+	u64 reserved2[5];
+} __attribute__((packed));
+
+struct xsave_struct {
+ 	struct i387_fxsave_struct i387;
+ 	struct xsave_hdr_struct xsave_hdr;
+ 	/* new processor state extensions will go here */
+} __attribute__ ((packed, aligned (64)));
+
 union thread_xstate {
 	struct i387_fsave_struct	fsave;
 	struct i387_fxsave_struct	fxsave;
 	struct i387_soft_struct		soft;
+	struct xsave_struct		xsave;
 };
 
 #ifdef CONFIG_X86_64
Index: linux-2.6-x86/arch/x86/kernel/cpu/feature_names.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/cpu/feature_names.c	2008-05-12 13:09:02.000000000 -0700
+++ linux-2.6-x86/arch/x86/kernel/cpu/feature_names.c	2008-05-12 13:09:56.000000000 -0700
@@ -46,7 +46,7 @@
 	"pni", NULL, NULL, "monitor", "ds_cpl", "vmx", "smx", "est",
 	"tm2", "ssse3", "cid", NULL, NULL, "cx16", "xtpr", NULL,
 	NULL, NULL, "dca", "sse4_1", "sse4_2", NULL, NULL, "popcnt",
-	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+	NULL, NULL, "xsave", NULL, NULL, NULL, NULL, NULL,
 
 	/* VIA/Cyrix/Centaur-defined */
 	NULL, NULL, "rng", "rng_en", NULL, NULL, "ace", "ace_en",
Index: linux-2.6-x86/include/asm-x86/ucontext.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/ucontext.h	2008-05-12 13:09:03.000000000 -0700
+++ linux-2.6-x86/include/asm-x86/ucontext.h	2008-05-12 15:15:12.000000000 -0700
@@ -6,7 +6,10 @@
 	struct ucontext  *uc_link;
 	stack_t		  uc_stack;
 	struct sigcontext uc_mcontext;
-	sigset_t	  uc_sigmask;	/* mask last for extensibility */
+	sigset_t	  uc_sigmask;
+	/* Allow for uc_sigmask growth.  Glibc uses a 1024-bit sigset_t.  */
+	int		  __unused[32 - (sizeof (sigset_t) / sizeof (int))];
+	struct xstate_cntxt  uc_xstate;
 };
 
 #endif /* _ASM_X86_UCONTEXT_H */
Index: linux-2.6-x86/include/asm-x86/ia32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/ia32.h	2008-05-12 13:09:03.000000000 -0700
+++ linux-2.6-x86/include/asm-x86/ia32.h	2008-05-12 13:09:56.000000000 -0700
@@ -41,6 +41,7 @@
 	stack_ia32_t	  uc_stack;
 	struct sigcontext_ia32 uc_mcontext;
 	compat_sigset_t	  uc_sigmask;	/* mask last for extensibility */
+	struct xstate_cntxt_ia32 uc_xstate;
 };
 
 /* This matches struct stat64 in glibc2.2, hence the absolutely
Index: linux-2.6-x86/include/asm-x86/sigcontext32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/sigcontext32.h	2008-05-12 13:09:03.000000000 -0700
+++ linux-2.6-x86/include/asm-x86/sigcontext32.h	2008-05-12 13:09:56.000000000 -0700
@@ -43,6 +43,13 @@
 	__u32	padding[56];
 };
 
+struct xstate_cntxt_ia32 {
+	u32 xstate;	/* really (struct _xstate *) */
+	u32 size;
+	u32 lmask;
+	u32 hmask;
+};
+
 struct sigcontext_ia32 {
        unsigned short gs, __gsh;
        unsigned short fs, __fsh;
Index: linux-2.6-x86/arch/x86/kernel/sigframe.h
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/sigframe.h	2008-05-12 13:09:02.000000000 -0700
+++ linux-2.6-x86/arch/x86/kernel/sigframe.h	2008-05-12 13:09:56.000000000 -0700
@@ -3,9 +3,10 @@
 	char __user *pretcode;
 	int sig;
 	struct sigcontext sc;
-	struct _fpstate fpstate;
+	struct xstate_cntxt xst_cnxt;
 	unsigned long extramask[_NSIG_WORDS-1];
 	char retcode[8];
+	/* fp and rest of the extended context state follows here */
 };
 
 struct rt_sigframe {
@@ -15,8 +16,8 @@
 	void __user *puc;
 	struct siginfo info;
 	struct ucontext uc;
-	struct _fpstate fpstate;
 	char retcode[8];
+	/* fp and rest of the extended context state follows here */
 };
 #else
 struct rt_sigframe {
Index: linux-2.6-x86/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/traps_32.c	2008-05-12 13:09:02.000000000 -0700
+++ linux-2.6-x86/arch/x86/kernel/traps_32.c	2008-05-12 13:09:56.000000000 -0700
@@ -1178,7 +1178,7 @@
 	}
 
 	clts();				/* Allow maths ops (or we recurse) */
-	restore_fpu(tsk);
+	restore_fpu_xstate(tsk);
 	thread->status |= TS_USEDFPU;	/* So we fnsave on switch_to() */
 	tsk->fpu_counter++;
 }
@@ -1255,7 +1255,6 @@
 
 	set_bit(SYSCALL_VECTOR, used_vectors);
 
-	init_thread_xstate();
 	/*
 	 * Should be a barrier for any external CPU state:
 	 */
Index: linux-2.6-x86/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/cpu/common.c	2008-05-12 13:09:02.000000000 -0700
+++ linux-2.6-x86/arch/x86/kernel/cpu/common.c	2008-05-12 13:27:21.000000000 -0700
@@ -742,6 +742,10 @@
 	current_thread_info()->status = 0;
 	clear_used_math();
 	mxcsr_feature_mask_init();
+
+	if (!smp_processor_id())
+		init_thread_xstate();
+	xsave_init();
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
