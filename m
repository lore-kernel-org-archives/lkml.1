Return-Path: <linux-kernel-owner+w=401wt.eu-S1762514AbXLTMGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762514AbXLTMGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761215AbXLTMAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:00:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760957AbXLTMAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:33 -0500
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
Subject: [PATCH -mm 39/43] x86 user_regset cleanup
Message-Id: <20071220120012.D172626F98E@magilla.localdomain>
Date: Thu, 20 Dec 2007 04:00:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes a bunch of dead code that is no longer needed now
that the user_regset interfaces are being used for all these jobs.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/i387.c        |  105 ++++-------------------------------------
 arch/x86/kernel/process_32.c  |   16 ------
 arch/x86/kernel/process_64.c  |   19 -------
 arch/x86/math-emu/fpu_entry.c |   14 ------
 include/asm-x86/elf.h         |   68 --------------------------
 include/asm-x86/i387.h        |   14 ------
 include/asm-x86/math_emu.h    |    5 --
 7 files changed, 9 insertions(+), 232 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index f0563ed..7e354a3 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -454,113 +454,26 @@ int restore_i387_ia32(struct _fpstate_ia32 __user *buf)
 	return err;
 }
 
-#endif	/* CONFIG_X86_32 || CONFIG_IA32_EMULATION */
-
-#ifdef CONFIG_X86_64
-
-int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *tsk)
-{
-	return xfpregs_get(tsk, NULL, 0, sizeof(*buf), NULL, buf);
-}
-
-int set_fpregs(struct task_struct *tsk, struct user_i387_struct __user *buf)
-{
-	return xfpregs_set(tsk, NULL, 0, sizeof(*buf), NULL, buf);
-}
-
-#else
-
-int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *tsk)
-{
-	return fpregs_get(tsk, NULL, 0, sizeof(*buf), NULL, buf);
-}
-
-int set_fpregs(struct task_struct *tsk, struct user_i387_struct __user *buf)
-{
-	return fpregs_set(tsk, NULL, 0, sizeof(*buf), NULL, buf);
-}
-
-int get_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *tsk)
-{
-	return xfpregs_get(tsk, NULL, 0, sizeof(*buf), NULL, buf);
-}
-
-int set_fpxregs(struct task_struct *tsk, struct user_fxsr_struct __user *buf)
-{
-	return xfpregs_get(tsk, NULL, 0, sizeof(*buf), NULL, buf);
-}
-
-#endif
-
 /*
  * FPU state for core dumps.
+ * This is only used for a.out dumps now.
+ * It is declared generically using elf_fpregset_t (which is
+ * struct user_i387_struct) but is in fact only used for 32-bit
+ * dumps, so on 64-bit it is really struct user_i387_ia32_struct.
  */
-
-static inline void copy_fpu_fsave(struct task_struct *tsk,
-				  struct user_i387_struct *fpu)
-{
-	memcpy(fpu, &tsk->thread.i387.fsave,
-	       sizeof(struct user_i387_struct));
-}
-
-static inline void copy_fpu_fxsave(struct task_struct *tsk,
-				   struct user_i387_struct *fpu)
-{
-	unsigned short *to;
-	unsigned short *from;
-	int i;
-
-	memcpy(fpu, &tsk->thread.i387.fxsave, 7 * sizeof(long));
-
-	to = (unsigned short *)&fpu->st_space[0];
-	from = (unsigned short *)&tsk->thread.i387.fxsave.st_space[0];
-	for (i = 0; i < 8; i++, to += 5, from += 8)
-		memcpy(to, from, 5 * sizeof(unsigned short));
-}
-
 int dump_fpu(struct pt_regs *regs, struct user_i387_struct *fpu)
 {
 	int fpvalid;
 	struct task_struct *tsk = current;
 
 	fpvalid = !!used_math();
-	if (fpvalid) {
-		unlazy_fpu(tsk);
-		if (cpu_has_fxsr) {
-			copy_fpu_fxsave(tsk, fpu);
-		} else {
-			copy_fpu_fsave(tsk, fpu);
-		}
-	}
+	if (fpvalid)
+		fpvalid = !fpregs_get(tsk, NULL,
+				      0, sizeof(struct user_i387_ia32_struct),
+				      fpu, NULL);
 
 	return fpvalid;
 }
 EXPORT_SYMBOL(dump_fpu);
 
-int dump_task_fpu(struct task_struct *tsk, struct user_i387_struct *fpu)
-{
-	int fpvalid = !!tsk_used_math(tsk);
-
-	if (fpvalid) {
-		if (tsk == current)
-			unlazy_fpu(tsk);
-		if (cpu_has_fxsr)
-			copy_fpu_fxsave(tsk, fpu);
-		else
-			copy_fpu_fsave(tsk, fpu);
-	}
-	return fpvalid;
-}
-
-int dump_task_extended_fpu(struct task_struct *tsk,
-			   struct user32_fxsr_struct *fpu)
-{
-	int fpvalid = tsk_used_math(tsk) && cpu_has_fxsr;
-
-	if (fpvalid) {
-		if (tsk == current)
-		       unlazy_fpu(tsk);
-		memcpy(fpu, &tsk->thread.i387.fxsave, sizeof(*fpu));
-	}
-	return fpvalid;
-}
+#endif	/* CONFIG_X86_32 || CONFIG_IA32_EMULATION */
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 1a77643..655902c 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -560,22 +560,6 @@ void dump_thread(struct pt_regs * regs, struct user * dump)
 }
 EXPORT_SYMBOL(dump_thread);
 
-/*
- * Capture the user space registers if the task is not running (in user space)
- */
-int dump_task_regs(struct task_struct *tsk, elf_gregset_t *regs)
-{
-	struct pt_regs ptregs = *task_pt_regs(tsk);
-	ptregs.cs &= 0xffff;
-	ptregs.ds &= 0xffff;
-	ptregs.es &= 0xffff;
-	ptregs.ss &= 0xffff;
-
-	elf_core_copy_regs(regs, &ptregs);
-
-	return 1;
-}
-
 #ifdef CONFIG_SECCOMP
 static void hard_disable_TSC(void)
 {
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index c846108..c6ad1a0 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -533,24 +533,6 @@ out:
  */
 #define loaddebug(thread, r) set_debugreg(thread->debugreg ## r, r)
 
-/*
- * Capture the user space registers if the task is not running (in user space)
- */
-int dump_task_regs(struct task_struct *tsk, elf_gregset_t *regs)
-{
-	struct pt_regs *pp, ptregs;
-
-	pp = task_pt_regs(tsk);
-
-	ptregs = *pp;
-	ptregs.cs &= 0xffff;
-	ptregs.ss &= 0xffff;
-
-	elf_core_copy_regs(regs, &ptregs);
-
-	return 1;
-}
-
 static inline void __switch_to_xtra(struct task_struct *prev_p,
 				    struct task_struct *next_p,
 				    struct tss_struct *tss)
@@ -918,4 +900,3 @@ unsigned long arch_randomize_brk(struct mm_struct *mm)
 	unsigned long range_end = mm->brk + 0x02000000;
 	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
 }
-
diff --git a/arch/x86/math-emu/fpu_entry.c b/arch/x86/math-emu/fpu_entry.c
index cfbdaa1..760baee 100644
--- a/arch/x86/math-emu/fpu_entry.c
+++ b/arch/x86/math-emu/fpu_entry.c
@@ -761,17 +761,3 @@ int fpregs_soft_get(struct task_struct *target,
 
 	return ret;
 }
-
-int save_i387_soft(void *s387, struct _fpstate __user *buf)
-{
-	return fpregs_soft_get(current, NULL,
-			       0, sizeof(struct user_i387_struct),
-			       NULL, buf) ? -1 : 1;
-}
-
-int restore_i387_soft(void *s387, struct _fpstate __user *buf)
-{
-	return fpregs_soft_set(current, NULL,
-			       0, sizeof(struct user_i387_struct),
-			       NULL, buf) ? -1 : 1;
-}
diff --git a/include/asm-x86/elf.h b/include/asm-x86/elf.h
index 123e2d5..d6bf742 100644
--- a/include/asm-x86/elf.h
+++ b/include/asm-x86/elf.h
@@ -104,28 +104,6 @@ typedef struct user_fxsr_struct elf_fpxregset_t;
 	_r->ax = 0; \
 } while (0)
 
-/* regs is struct pt_regs, pr_reg is elf_gregset_t (which is
-   now struct_user_regs, they are different) */
-
-#define ELF_CORE_COPY_REGS(pr_reg, regs)		\
-	pr_reg[0] = regs->bx;				\
-	pr_reg[1] = regs->cx;				\
-	pr_reg[2] = regs->dx;				\
-	pr_reg[3] = regs->si;				\
-	pr_reg[4] = regs->di;				\
-	pr_reg[5] = regs->bp;				\
-	pr_reg[6] = regs->ax;				\
-	pr_reg[7] = regs->ds & 0xffff;			\
-	pr_reg[8] = regs->es & 0xffff;			\
-	pr_reg[9] = regs->fs & 0xffff;			\
-	savesegment(gs,pr_reg[10]);			\
-	pr_reg[11] = regs->orig_ax;			\
-	pr_reg[12] = regs->ip;				\
-	pr_reg[13] = regs->cs & 0xffff;			\
-	pr_reg[14] = regs->flags;			\
-	pr_reg[15] = regs->sp;				\
-	pr_reg[16] = regs->ss & 0xffff;
-
 #define ELF_PLATFORM	(utsname()->machine)
 #define set_personality_64bit()	do { } while (0)
 extern unsigned int vdso_enabled;
@@ -159,41 +137,6 @@ extern unsigned int vdso_enabled;
 	clear_thread_flag(TIF_IA32);			  \
 } while (0)
 
-/* regs is struct pt_regs, pr_reg is elf_gregset_t (which is
-   now struct_user_regs, they are different). Assumes current is the process
-   getting dumped. */
-
-#define ELF_CORE_COPY_REGS(pr_reg, regs)  do {			\
-	unsigned v;						\
-	(pr_reg)[0] = (regs)->r15;				\
-	(pr_reg)[1] = (regs)->r14;				\
-	(pr_reg)[2] = (regs)->r13;				\
-	(pr_reg)[3] = (regs)->r12;				\
-	(pr_reg)[4] = (regs)->bp;				\
-	(pr_reg)[5] = (regs)->bx;				\
-	(pr_reg)[6] = (regs)->r11;				\
-	(pr_reg)[7] = (regs)->r10;				\
-	(pr_reg)[8] = (regs)->r9;				\
-	(pr_reg)[9] = (regs)->r8;				\
-	(pr_reg)[10] = (regs)->ax;				\
-	(pr_reg)[11] = (regs)->cx;				\
-	(pr_reg)[12] = (regs)->dx;				\
-	(pr_reg)[13] = (regs)->si;				\
-	(pr_reg)[14] = (regs)->di;				\
-	(pr_reg)[15] = (regs)->orig_ax;			\
-	(pr_reg)[16] = (regs)->ip;				\
-	(pr_reg)[17] = (regs)->cs;				\
-	(pr_reg)[18] = (regs)->flags;				\
-	(pr_reg)[19] = (regs)->sp;				\
-	(pr_reg)[20] = (regs)->ss;				\
-	(pr_reg)[21] = current->thread.fs;			\
-	(pr_reg)[22] = current->thread.gs;			\
-	asm("movl %%ds,%0" : "=r" (v)); (pr_reg)[23] = v;	\
-	asm("movl %%es,%0" : "=r" (v)); (pr_reg)[24] = v;	\
-	asm("movl %%fs,%0" : "=r" (v)); (pr_reg)[25] = v;	\
-	asm("movl %%gs,%0" : "=r" (v)); (pr_reg)[26] = v;	\
-} while(0);
-
 /* I'm not sure if we can use '-' here */
 #define ELF_PLATFORM       ("x86_64")
 extern void set_personality_64bit(void);
@@ -236,18 +179,7 @@ extern int vdso_enabled;
 
 struct task_struct;
 
-extern int dump_task_regs (struct task_struct *, elf_gregset_t *);
-extern int dump_task_fpu (struct task_struct *, elf_fpregset_t *);
-
-#define ELF_CORE_COPY_TASK_REGS(tsk, elf_regs) dump_task_regs(tsk, elf_regs)
-#define ELF_CORE_COPY_FPREGS(tsk, elf_fpregs) dump_task_fpu(tsk, elf_fpregs)
-
 #ifdef CONFIG_X86_32
-extern int dump_task_extended_fpu (struct task_struct *,
-				   struct user_fxsr_struct *);
-#define ELF_CORE_COPY_XFPREGS(tsk, elf_xfpregs) \
-	dump_task_extended_fpu(tsk, elf_xfpregs)
-#define ELF_CORE_XFPREG_TYPE NT_PRXFPREG
 
 #define VDSO_HIGH_BASE		(__fix_to_virt(FIX_VDSO))
 
diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
index b52b891..3f4c4a5 100644
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -322,20 +322,6 @@ static inline void clear_fpu(struct task_struct *tsk)
 #endif	/* CONFIG_X86_64 */
 
 /*
- * ptrace request handlers...
- */
-extern int get_fpregs(struct user_i387_struct __user *buf,
-		      struct task_struct *tsk);
-extern int set_fpregs(struct task_struct *tsk,
-		      struct user_i387_struct __user *buf);
-
-struct user_fxsr_struct;
-extern int get_fpxregs(struct user_fxsr_struct __user *buf,
-		       struct task_struct *tsk);
-extern int set_fpxregs(struct task_struct *tsk,
-		       struct user_fxsr_struct __user *buf);
-
-/*
  * i387 state interaction
  */
 static inline unsigned short get_fpu_cwd(struct task_struct *tsk)
diff --git a/include/asm-x86/math_emu.h b/include/asm-x86/math_emu.h
index a4b0aa3..9bf4ae9 100644
--- a/include/asm-x86/math_emu.h
+++ b/include/asm-x86/math_emu.h
@@ -1,11 +1,6 @@
 #ifndef _I386_MATH_EMU_H
 #define _I386_MATH_EMU_H
 
-#include <asm/sigcontext.h>
-
-int restore_i387_soft(void *s387, struct _fpstate __user *buf);
-int save_i387_soft(void *s387, struct _fpstate __user *buf);
-
 /* This structure matches the layout of the data saved to the stack
    following a device-not-present interrupt, part of it saved
    automatically by the 80386/80486.
-- 
1.5.3.6

