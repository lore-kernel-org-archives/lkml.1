Return-Path: <linux-kernel-owner+w=401wt.eu-S1760867AbXLTMIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760867AbXLTMIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761167AbXLTMBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:01:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761031AbXLTMAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:43 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 31/43] x86 i387 user_regset
Message-Id: <20071220115953.1413F26F98A@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:59:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This revamps the i387 code to be shared across 32-bit, 64-bit,
and 32-on-64.  It does so by consolidating the code in one place
based on the user_regset accessor interfaces.  This switches
32-bit to using the i387_64.h header and 64-bit to using the
i387.c that was previously i387_32.c, but that's what took the
least cleanup in each file.  Here i387.h is stubbed to always
include i387_64.h rather than renaming the file, to keep this
diff smaller and easier to read.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/ia32/Makefile      |    2 +-
 arch/x86/kernel/Makefile_64 |    3 +-
 arch/x86/kernel/i387.c      |  481 ++++++++++++++++++++++---------------------
 include/asm-x86/i387.h      |    6 +-
 include/asm-x86/i387_64.h   |    5 +
 5 files changed, 257 insertions(+), 240 deletions(-)

diff --git a/arch/x86/ia32/Makefile b/arch/x86/ia32/Makefile
index ec71cfe..93a6fda 100644
--- a/arch/x86/ia32/Makefile
+++ b/arch/x86/ia32/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-$(CONFIG_IA32_EMULATION) := ia32entry.o sys_ia32.o ia32_signal.o \
-	ia32_binfmt.o fpu32.o
+	ia32_binfmt.o
 
 sysv-$(CONFIG_SYSVIPC) := ipc32.o
 obj-$(CONFIG_IA32_EMULATION) += $(sysv-y)
diff --git a/arch/x86/kernel/Makefile_64 b/arch/x86/kernel/Makefile_64
index fbb3700..7fcf972 100644
--- a/arch/x86/kernel/Makefile_64
+++ b/arch/x86/kernel/Makefile_64
@@ -7,7 +7,7 @@ CPPFLAGS_vmlinux.lds += -Ux86_64
 
 obj-y	:= process_64.o signal_64.o entry_64.o traps_64.o irq_64.o \
 		time_64.o ioport_64.o ldt.o setup_64.o i8259_64.o sys_x86_64.o \
-		x8664_ksyms_64.o i387_64.o syscall_64.o vsyscall_64.o \
+		x8664_ksyms_64.o syscall_64.o vsyscall_64.o \
 		setup64.o bootflag.o e820_64.o reboot_64.o quirks.o i8237.o \
 		pci-dma_64.o pci-nommu_64.o alternative.o hpet.o tsc_64.o bugs_64.o \
 		i8253.o io_delay.o rtc.o
@@ -16,6 +16,7 @@ obj-y				+= ptrace.o
 obj-y				+= ds.o
 obj-y				+= step.o
 
+obj-y				+= i387.o
 obj-$(CONFIG_IA32_EMULATION)	+= tls.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index bebe034..f0563ed 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -8,6 +8,7 @@
 
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/regset.h>
 #include <asm/processor.h>
 #include <asm/i387.h>
 #include <asm/math_emu.h>
@@ -16,13 +17,29 @@
 #include <asm/ptrace.h>
 #include <asm/uaccess.h>
 
+#ifdef CONFIG_X86_64
+
+#include <asm/sigcontext32.h>
+#include <asm/user32.h>
+
+#else
+
+#define	save_i387_ia32		save_i387
+#define	restore_i387_ia32	restore_i387
+
+#define _fpstate_ia32 		_fpstate
+#define user_i387_ia32_struct	user_i387_struct
+#define user32_fxsr_struct	user_fxsr_struct
+
+#endif
+
 #ifdef CONFIG_MATH_EMULATION
 #define HAVE_HWFP (boot_cpu_data.hard_math)
 #else
 #define HAVE_HWFP 1
 #endif
 
-static unsigned long mxcsr_feature_mask __read_mostly = 0xffffffff;
+unsigned int mxcsr_feature_mask __read_mostly = 0xffffffffu;
 
 void mxcsr_feature_mask_init(void)
 {
@@ -40,6 +57,30 @@ void mxcsr_feature_mask_init(void)
 	stts();
 }
 
+#ifdef CONFIG_X86_64
+/*
+ * Called at bootup to set up the initial FPU state that is later cloned
+ * into all processes.
+ */
+void __cpuinit fpu_init(void)
+{
+	unsigned long oldcr0 = read_cr0();
+	extern void __bad_fxsave_alignment(void);
+
+	if (offsetof(struct task_struct, thread.i387.fxsave) & 15)
+		__bad_fxsave_alignment();
+	set_in_cr4(X86_CR4_OSFXSR);
+	set_in_cr4(X86_CR4_OSXMMEXCPT);
+
+	write_cr0(oldcr0 & ~((1UL<<3)|(1UL<<2))); /* clear TS and EM */
+
+	mxcsr_feature_mask_init();
+	/* clean state in init */
+	current_thread_info()->status = 0;
+	clear_used_math();
+}
+#endif	/* CONFIG_X86_64 */
+
 /*
  * The _current_ task is using the FPU for the first time
  * so initialize it and set the mxcsr to its default
@@ -48,12 +89,18 @@ void mxcsr_feature_mask_init(void)
  */
 void init_fpu(struct task_struct *tsk)
 {
+	if (tsk_used_math(tsk)) {
+		if (tsk == current)
+			unlazy_fpu(tsk);
+		return;
+	}
+
 	if (cpu_has_fxsr) {
 		memset(&tsk->thread.i387.fxsave, 0,
 		       sizeof(struct i387_fxsave_struct));
 		tsk->thread.i387.fxsave.cwd = 0x37f;
 		if (cpu_has_xmm)
-			tsk->thread.i387.fxsave.mxcsr = 0x1f80;
+			tsk->thread.i387.fxsave.mxcsr = MXCSR_DEFAULT;
 	} else {
 		memset(&tsk->thread.i387.fsave, 0,
 		       sizeof(struct i387_fsave_struct));
@@ -62,27 +109,59 @@ void init_fpu(struct task_struct *tsk)
 		tsk->thread.i387.fsave.twd = 0xffffffffu;
 		tsk->thread.i387.fsave.fos = 0xffff0000u;
 	}
-	/* only the device not available exception
-	 * or ptrace can call init_fpu */
+	/*
+	 * Only the device not available exception or ptrace can call init_fpu.
+	 */
 	set_stopped_child_used_math(tsk);
 }
 
-/*
- * FPU lazy state save handling.
- */
+int fpregs_active(struct task_struct *target, const struct user_regset *regset)
+{
+	return tsk_used_math(target) ? regset->n : 0;
+}
 
-void kernel_fpu_begin(void)
+int xfpregs_active(struct task_struct *target, const struct user_regset *regset)
 {
-	struct thread_info *thread = current_thread_info();
+	return (cpu_has_fxsr && tsk_used_math(target)) ? regset->n : 0;
+}
 
-	preempt_disable();
-	if (thread->status & TS_USEDFPU) {
-		__save_init_fpu(thread->task);
-		return;
-	}
-	clts();
+int xfpregs_get(struct task_struct *target, const struct user_regset *regset,
+		unsigned int pos, unsigned int count,
+		void *kbuf, void __user *ubuf)
+{
+	if (!cpu_has_fxsr)
+		return -ENODEV;
+
+	unlazy_fpu(target);
+
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				   &target->thread.i387.fxsave, 0, -1);
+}
+
+int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
+		unsigned int pos, unsigned int count,
+		const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+
+	if (!cpu_has_fxsr)
+		return -ENODEV;
+
+	unlazy_fpu(target);
+	set_stopped_child_used_math(target);
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 &target->thread.i387.fxsave, 0, -1);
+
+	/*
+	 * mxcsr reserved bits must be masked to zero for security reasons.
+	 */
+	target->thread.i387.fxsave.mxcsr &= mxcsr_feature_mask;
+
+	return ret;
 }
-EXPORT_SYMBOL_GPL(kernel_fpu_begin);
+
+#if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
 
 /*
  * FPU tag word conversions.
@@ -94,210 +173,187 @@ static inline unsigned short twd_i387_to_fxsr(unsigned short twd)
 
 	/* Transform each pair of bits into 01 (valid) or 00 (empty) */
 	tmp = ~twd;
-	tmp = (tmp | (tmp >> 1)) & 0x5555; /* 0V0V0V0V0V0V0V0V */
+	tmp = (tmp | (tmp>>1)) & 0x5555; /* 0V0V0V0V0V0V0V0V */
 	/* and move the valid bits to the lower byte. */
 	tmp = (tmp | (tmp >> 1)) & 0x3333; /* 00VV00VV00VV00VV */
 	tmp = (tmp | (tmp >> 2)) & 0x0f0f; /* 0000VVVV0000VVVV */
 	tmp = (tmp | (tmp >> 4)) & 0x00ff; /* 00000000VVVVVVVV */
-
 	return tmp;
 }
 
-static inline unsigned long twd_fxsr_to_i387(struct i387_fxsave_struct *fxsave)
-{
-	struct _fpxreg *st = NULL;
-	unsigned long tos = (fxsave->swd >> 11) & 7;
-	unsigned long twd = (unsigned long) fxsave->twd;
-	unsigned long tag;
-	unsigned long ret = 0xffff0000u;
-	int i;
-
 #define FPREG_ADDR(f, n)	((void *)&(f)->st_space + (n) * 16);
+#define FP_EXP_TAG_VALID	0
+#define FP_EXP_TAG_ZERO		1
+#define FP_EXP_TAG_SPECIAL	2
+#define FP_EXP_TAG_EMPTY	3
+
+static inline u32 twd_fxsr_to_i387(struct i387_fxsave_struct *fxsave)
+{
+	struct _fpxreg *st;
+	u32 tos = (fxsave->swd >> 11) & 7;
+	u32 twd = (unsigned long) fxsave->twd;
+	u32 tag;
+	u32 ret = 0xffff0000u;
+	int i;
 
-	for (i = 0; i < 8; i++) {
+	for (i = 0; i < 8; i++, twd >>= 1) {
 		if (twd & 0x1) {
 			st = FPREG_ADDR(fxsave, (i - tos) & 7);
 
 			switch (st->exponent & 0x7fff) {
 			case 0x7fff:
-				tag = 2;		/* Special */
+				tag = FP_EXP_TAG_SPECIAL;
 				break;
 			case 0x0000:
 				if (!st->significand[0] &&
 				    !st->significand[1] &&
 				    !st->significand[2] &&
-				    !st->significand[3]) {
-					tag = 1;	/* Zero */
-				} else {
-					tag = 2;	/* Special */
-				}
+				    !st->significand[3])
+					tag = FP_EXP_TAG_ZERO;
+				else
+					tag = FP_EXP_TAG_SPECIAL;
 				break;
 			default:
-				if (st->significand[3] & 0x8000) {
-					tag = 0;	/* Valid */
-				} else {
-					tag = 2;	/* Special */
-				}
+				if (st->significand[3] & 0x8000)
+					tag = FP_EXP_TAG_VALID;
+				else
+					tag = FP_EXP_TAG_SPECIAL;
 				break;
 			}
 		} else {
-			tag = 3;			/* Empty */
+			tag = FP_EXP_TAG_EMPTY;
 		}
-		ret |= (tag << (2 * i));
-		twd = twd >> 1;
+		ret |= tag << (2 * i);
 	}
 	return ret;
 }
 
 /*
- * FPU state interaction.
+ * FXSR floating point environment conversions.
  */
 
-unsigned short get_fpu_cwd(struct task_struct *tsk)
-{
-	if (cpu_has_fxsr) {
-		return tsk->thread.i387.fxsave.cwd;
-	} else {
-		return (unsigned short)tsk->thread.i387.fsave.cwd;
-	}
-}
-
-unsigned short get_fpu_swd(struct task_struct *tsk)
+static void convert_from_fxsr(struct user_i387_ia32_struct *env,
+			      struct task_struct *tsk)
 {
-	if (cpu_has_fxsr) {
-		return tsk->thread.i387.fxsave.swd;
-	} else {
-		return (unsigned short)tsk->thread.i387.fsave.swd;
-	}
-}
+	struct i387_fxsave_struct *fxsave = &tsk->thread.i387.fxsave;
+	struct _fpreg *to = (struct _fpreg *) &env->st_space[0];
+	struct _fpxreg *from = (struct _fpxreg *) &fxsave->st_space[0];
+	int i;
 
-#if 0
-unsigned short get_fpu_twd(struct task_struct *tsk)
-{
-	if (cpu_has_fxsr) {
-		return tsk->thread.i387.fxsave.twd;
+	env->cwd = fxsave->cwd | 0xffff0000u;
+	env->swd = fxsave->swd | 0xffff0000u;
+	env->twd = twd_fxsr_to_i387(fxsave);
+
+#ifdef CONFIG_X86_64
+	env->fip = fxsave->rip;
+	env->foo = fxsave->rdp;
+	if (tsk == current) {
+		/*
+		 * should be actually ds/cs at fpu exception time, but
+		 * that information is not available in 64bit mode.
+		 */
+		asm("mov %%ds,%0" : "=r" (env->fos));
+		asm("mov %%cs,%0" : "=r" (env->fcs));
 	} else {
-		return (unsigned short)tsk->thread.i387.fsave.twd;
+		struct pt_regs *regs = task_pt_regs(tsk);
+		env->fos = 0xffff0000 | tsk->thread.ds;
+		env->fcs = regs->cs;
 	}
-}
-#endif  /*  0  */
+#else
+	env->fip = fxsave->fip;
+	env->fcs = fxsave->fcs;
+	env->foo = fxsave->foo;
+	env->fos = fxsave->fos;
+#endif
 
-unsigned short get_fpu_mxcsr(struct task_struct *tsk)
-{
-	if (cpu_has_xmm) {
-		return tsk->thread.i387.fxsave.mxcsr;
-	} else {
-		return 0x1f80;
-	}
+	for (i = 0; i < 8; ++i)
+		memcpy(&to[i], &from[i], sizeof(to[0]));
 }
 
-#if 0
+static void convert_to_fxsr(struct task_struct *tsk,
+			    const struct user_i387_ia32_struct *env)
 
-void set_fpu_cwd(struct task_struct *tsk, unsigned short cwd)
 {
-	if (cpu_has_fxsr) {
-		tsk->thread.i387.fxsave.cwd = cwd;
-	} else {
-		tsk->thread.i387.fsave.cwd = ((long)cwd | 0xffff0000u);
-	}
-}
+	struct i387_fxsave_struct *fxsave = &tsk->thread.i387.fxsave;
+	struct _fpreg *from = (struct _fpreg *) &env->st_space[0];
+	struct _fpxreg *to = (struct _fpxreg *) &fxsave->st_space[0];
+	int i;
 
-void set_fpu_swd(struct task_struct *tsk, unsigned short swd)
-{
-	if (cpu_has_fxsr) {
-		tsk->thread.i387.fxsave.swd = swd;
-	} else {
-		tsk->thread.i387.fsave.swd = ((long)swd | 0xffff0000u);
-	}
-}
+	fxsave->cwd = env->cwd;
+	fxsave->swd = env->swd;
+	fxsave->twd = twd_i387_to_fxsr(env->twd);
+	fxsave->fop = (u16) ((u32) env->fcs >> 16);
+#ifdef CONFIG_X86_64
+	fxsave->rip = env->fip;
+	fxsave->rdp = env->foo;
+	/* cs and ds ignored */
+#else
+	fxsave->fip = env->fip;
+	fxsave->fcs = (env->fcs & 0xffff);
+	fxsave->foo = env->foo;
+	fxsave->fos = env->fos;
+#endif
 
-void set_fpu_twd(struct task_struct *tsk, unsigned short twd)
-{
-	if (cpu_has_fxsr) {
-		tsk->thread.i387.fxsave.twd = twd_i387_to_fxsr(twd);
-	} else {
-		tsk->thread.i387.fsave.twd = ((long)twd | 0xffff0000u);
-	}
+	for (i = 0; i < 8; ++i)
+		memcpy(&to[i], &from[i], sizeof(from[0]));
 }
 
-#endif  /*  0  */
-
-/*
- * FXSR floating point environment conversions.
- */
-
-static int convert_fxsr_to_user(struct _fpstate __user *buf,
-				struct i387_fxsave_struct *fxsave)
+int fpregs_get(struct task_struct *target, const struct user_regset *regset,
+	       unsigned int pos, unsigned int count,
+	       void *kbuf, void __user *ubuf)
 {
-	unsigned long env[7];
-	struct _fpreg __user *to;
-	struct _fpxreg *from;
-	int i;
+	struct user_i387_ia32_struct env;
 
-	env[0] = (unsigned long)fxsave->cwd | 0xffff0000ul;
-	env[1] = (unsigned long)fxsave->swd | 0xffff0000ul;
-	env[2] = twd_fxsr_to_i387(fxsave);
-	env[3] = fxsave->fip;
-	env[4] = fxsave->fcs | ((unsigned long)fxsave->fop << 16);
-	env[5] = fxsave->foo;
-	env[6] = fxsave->fos;
+	if (!HAVE_HWFP)
+		return fpregs_soft_get(target, regset, pos, count, kbuf, ubuf);
 
-	if (__copy_to_user(buf, env, 7 * sizeof(unsigned long)))
-		return 1;
+	unlazy_fpu(target);
 
-	to = &buf->_st[0];
-	from = (struct _fpxreg *) &fxsave->st_space[0];
-	for (i = 0; i < 8; i++, to++, from++) {
-		unsigned long __user *t = (unsigned long __user *)to;
-		unsigned long *f = (unsigned long *)from;
+	if (!cpu_has_fxsr)
+		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+					   &target->thread.i387.fsave, 0, -1);
 
-		if (__put_user(*f, t) ||
-		    __put_user(*(f + 1), t + 1) ||
-		    __put_user(from->exponent, &to->exponent))
-			return 1;
+	if (kbuf && pos == 0 && count == sizeof(env)) {
+		convert_from_fxsr(kbuf, target);
+		return 0;
 	}
-	return 0;
+
+	convert_from_fxsr(&env, target);
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf, &env, 0, -1);
 }
 
-static int convert_fxsr_from_user(struct i387_fxsave_struct *fxsave,
-				  struct _fpstate __user *buf)
+int fpregs_set(struct task_struct *target, const struct user_regset *regset,
+	       unsigned int pos, unsigned int count,
+	       const void *kbuf, const void __user *ubuf)
 {
-	unsigned long env[7];
-	struct _fpxreg *to;
-	struct _fpreg __user *from;
-	int i;
+	int ret;
 
-	if (__copy_from_user(env, buf, 7 * sizeof(long)))
-		return 1;
+	if (!HAVE_HWFP)
+		return fpregs_soft_set(target, regset, pos, count, kbuf, ubuf);
 
-	fxsave->cwd = (unsigned short)(env[0] & 0xffff);
-	fxsave->swd = (unsigned short)(env[1] & 0xffff);
-	fxsave->twd = twd_i387_to_fxsr((unsigned short)(env[2] & 0xffff));
-	fxsave->fip = env[3];
-	fxsave->fop = (unsigned short)((env[4] & 0xffff0000ul) >> 16);
-	fxsave->fcs = (env[4] & 0xffff);
-	fxsave->foo = env[5];
-	fxsave->fos = env[6];
-
-	to = (struct _fpxreg *) &fxsave->st_space[0];
-	from = &buf->_st[0];
-	for (i = 0; i < 8; i++, to++, from++) {
-		unsigned long *t = (unsigned long *)to;
-		unsigned long __user *f = (unsigned long __user *)from;
-
-		if (__get_user(*t, f) ||
-		    __get_user(*(t + 1), f + 1) ||
-		    __get_user(to->exponent, &from->exponent))
-			return 1;
-	}
-	return 0;
+	unlazy_fpu(target);
+	set_stopped_child_used_math(target);
+
+	if (!cpu_has_fxsr)
+		return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+					  &target->thread.i387.fsave, 0, -1);
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 &target->thread.i387.fxsave, 0, -1);
+
+	/*
+	 * mxcsr reserved bits must be masked to zero for security reasons.
+	 */
+	target->thread.i387.fxsave.mxcsr &= mxcsr_feature_mask;
+
+	return ret;
 }
 
 /*
  * Signal frame handlers.
  */
 
-static inline int save_i387_fsave(struct _fpstate __user *buf)
+static inline int save_i387_fsave(struct _fpstate_ia32 __user *buf)
 {
 	struct task_struct *tsk = current;
 
@@ -309,14 +365,16 @@ static inline int save_i387_fsave(struct _fpstate __user *buf)
 	return 1;
 }
 
-static int save_i387_fxsave(struct _fpstate __user *buf)
+static int save_i387_fxsave(struct _fpstate_ia32 __user *buf)
 {
 	struct task_struct *tsk = current;
+	struct user_i387_ia32_struct env;
 	int err = 0;
 
 	unlazy_fpu(tsk);
 
-	if (convert_fxsr_to_user(buf, &tsk->thread.i387.fxsave))
+	convert_from_fxsr(&env, tsk);
+	if (__copy_to_user(buf, &env, sizeof(env)))
 		return -1;
 
 	err |= __put_user(tsk->thread.i387.fxsave.swd, &buf->status);
@@ -330,7 +388,7 @@ static int save_i387_fxsave(struct _fpstate __user *buf)
 	return 1;
 }
 
-int save_i387(struct _fpstate __user *buf)
+int save_i387_ia32(struct _fpstate_ia32 __user *buf)
 {
 	if (!used_math())
 		return 0;
@@ -347,11 +405,13 @@ int save_i387(struct _fpstate __user *buf)
 			return save_i387_fsave(buf);
 		}
 	} else {
-		return save_i387_soft(&current->thread.i387.soft, buf);
+		return fpregs_soft_get(current, NULL,
+				       0, sizeof(struct user_i387_ia32_struct),
+				       NULL, buf) ? -1 : 1;
 	}
 }
 
-static inline int restore_i387_fsave(struct _fpstate __user *buf)
+static inline int restore_i387_fsave(struct _fpstate_ia32 __user *buf)
 {
 	struct task_struct *tsk = current;
 	clear_fpu(tsk);
@@ -359,19 +419,23 @@ static inline int restore_i387_fsave(struct _fpstate __user *buf)
 				sizeof(struct i387_fsave_struct));
 }
 
-static int restore_i387_fxsave(struct _fpstate __user *buf)
+static int restore_i387_fxsave(struct _fpstate_ia32 __user *buf)
 {
 	int err;
 	struct task_struct *tsk = current;
+	struct user_i387_ia32_struct env;
 	clear_fpu(tsk);
 	err = __copy_from_user(&tsk->thread.i387.fxsave, &buf->_fxsr_env[0],
 			       sizeof(struct i387_fxsave_struct));
 	/* mxcsr reserved bits must be masked to zero for security reasons */
 	tsk->thread.i387.fxsave.mxcsr &= mxcsr_feature_mask;
-	return err ? 1 : convert_fxsr_from_user(&tsk->thread.i387.fxsave, buf);
+	if (err || __copy_from_user(&env, buf, sizeof(env)))
+		return 1;
+	convert_to_fxsr(tsk, &env);
+	return 0;
 }
 
-int restore_i387(struct _fpstate __user *buf)
+int restore_i387_ia32(struct _fpstate_ia32 __user *buf)
 {
 	int err;
 
@@ -382,101 +446,52 @@ int restore_i387(struct _fpstate __user *buf)
 			err = restore_i387_fsave(buf);
 		}
 	} else {
-		err = restore_i387_soft(&current->thread.i387.soft, buf);
+		err = fpregs_soft_set(current, NULL,
+				      0, sizeof(struct user_i387_ia32_struct),
+				      NULL, buf) != 0;
 	}
 	set_used_math();
 	return err;
 }
 
-/*
- * ptrace request handlers.
- */
+#endif	/* CONFIG_X86_32 || CONFIG_IA32_EMULATION */
 
-static inline int get_fpregs_fsave(struct user_i387_struct __user *buf,
-				   struct task_struct *tsk)
-{
-	return __copy_to_user(buf, &tsk->thread.i387.fsave,
-			      sizeof(struct user_i387_struct));
-}
-
-static inline int get_fpregs_fxsave(struct user_i387_struct __user *buf,
-				    struct task_struct *tsk)
-{
-	return convert_fxsr_to_user((struct _fpstate __user *)buf,
-				    &tsk->thread.i387.fxsave);
-}
+#ifdef CONFIG_X86_64
 
 int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *tsk)
 {
-	if (HAVE_HWFP) {
-		if (cpu_has_fxsr) {
-			return get_fpregs_fxsave(buf, tsk);
-		} else {
-			return get_fpregs_fsave(buf, tsk);
-		}
-	} else {
-		return save_i387_soft(&tsk->thread.i387.soft,
-				      (struct _fpstate __user *)buf);
-	}
+	return xfpregs_get(tsk, NULL, 0, sizeof(*buf), NULL, buf);
 }
 
-static inline int set_fpregs_fsave(struct task_struct *tsk,
-				   struct user_i387_struct __user *buf)
+int set_fpregs(struct task_struct *tsk, struct user_i387_struct __user *buf)
 {
-	return __copy_from_user(&tsk->thread.i387.fsave, buf,
-				sizeof(struct user_i387_struct));
+	return xfpregs_set(tsk, NULL, 0, sizeof(*buf), NULL, buf);
 }
 
-static inline int set_fpregs_fxsave(struct task_struct *tsk,
-				    struct user_i387_struct __user *buf)
+#else
+
+int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *tsk)
 {
-	return convert_fxsr_from_user(&tsk->thread.i387.fxsave,
-				      (struct _fpstate __user *)buf);
+	return fpregs_get(tsk, NULL, 0, sizeof(*buf), NULL, buf);
 }
 
 int set_fpregs(struct task_struct *tsk, struct user_i387_struct __user *buf)
 {
-	if (HAVE_HWFP) {
-		if (cpu_has_fxsr) {
-			return set_fpregs_fxsave(tsk, buf);
-		} else {
-			return set_fpregs_fsave(tsk, buf);
-		}
-	} else {
-		return restore_i387_soft(&tsk->thread.i387.soft,
-					 (struct _fpstate __user *)buf);
-	}
+	return fpregs_set(tsk, NULL, 0, sizeof(*buf), NULL, buf);
 }
 
 int get_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *tsk)
 {
-	if (cpu_has_fxsr) {
-		if (__copy_to_user(buf, &tsk->thread.i387.fxsave,
-				   sizeof(struct user_fxsr_struct)))
-			return -EFAULT;
-		return 0;
-	} else {
-		return -EIO;
-	}
+	return xfpregs_get(tsk, NULL, 0, sizeof(*buf), NULL, buf);
 }
 
 int set_fpxregs(struct task_struct *tsk, struct user_fxsr_struct __user *buf)
 {
-	int ret = 0;
-
-	if (cpu_has_fxsr) {
-		if (__copy_from_user(&tsk->thread.i387.fxsave, buf,
-				     sizeof(struct user_fxsr_struct)))
-			ret = -EFAULT;
-		/* mxcsr reserved bits must be masked to zero
-		 * for security reasons */
-		tsk->thread.i387.fxsave.mxcsr &= mxcsr_feature_mask;
-	} else {
-		ret = -EIO;
-	}
-	return ret;
+	return xfpregs_get(tsk, NULL, 0, sizeof(*buf), NULL, buf);
 }
 
+#endif
+
 /*
  * FPU state for core dumps.
  */
@@ -538,7 +553,7 @@ int dump_task_fpu(struct task_struct *tsk, struct user_i387_struct *fpu)
 }
 
 int dump_task_extended_fpu(struct task_struct *tsk,
-			   struct user_fxsr_struct *fpu)
+			   struct user32_fxsr_struct *fpu)
 {
 	int fpvalid = tsk_used_math(tsk) && cpu_has_fxsr;
 
diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
index a8bbed3..b2bc005 100644
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -1,5 +1 @@
-#ifdef CONFIG_X86_32
-# include "i387_32.h"
-#else
-# include "i387_64.h"
-#endif
+#include "i387_64.h"
diff --git a/include/asm-x86/i387_64.h b/include/asm-x86/i387_64.h
index 4cea737..b52b891 100644
--- a/include/asm-x86/i387_64.h
+++ b/include/asm-x86/i387_64.h
@@ -12,6 +12,7 @@
 
 #include <linux/sched.h>
 #include <linux/kernel_stat.h>
+#include <linux/regset.h>
 #include <asm/processor.h>
 #include <asm/sigcontext.h>
 #include <asm/user.h>
@@ -23,6 +24,10 @@ extern void mxcsr_feature_mask_init(void);
 extern void init_fpu(struct task_struct *child);
 extern asmlinkage void math_state_restore(void);
 
+extern user_regset_active_fn fpregs_active, xfpregs_active;
+extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get;
+extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set;
+
 #ifdef CONFIG_X86_64
 
 /* Ignore delayed exceptions from user space */
-- 
1.5.3.6

