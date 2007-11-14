Return-Path: <linux-kernel-owner+w=401wt.eu-S1762415AbXKNAUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762415AbXKNAUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761953AbXKNATJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:19:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761537AbXKNATD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:19:03 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/9] AOUT: Suppress A.OUT library support if
	!CONFIG_ARCH_SUPPORTS_AOUT [try #6]
To: torvalds@osdl.org, akpm@linux-foundation.org, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-am33-list@redhat.com,
       dhowells@redhat.com
Date: Wed, 14 Nov 2007 00:18:47 +0000
Message-ID: <20071114001847.27662.15871.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071114001832.27662.8437.stgit@warthog.procyon.org.uk>
References: <20071114001832.27662.8437.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Suppress A.OUT library support if CONFIG_ARCH_SUPPORTS_AOUT is not set.

Not all architectures support the A.OUT binfmt, so the ELF binfmt should not
be permitted to go looking for A.OUT libraries to load in such a case.  Not
only that, but under such conditions A.OUT core dumps are not produced either.

To make this work, this patch also does the following:

 (1) Makes the existence of the contents of linux/a.out.h contingent on
     CONFIG_ARCH_SUPPORTS_AOUT.

 (2) Renames dump_thread() to aout_dump_thread() as it's only called by A.OUT
     core dumping code.

 (3) Moves aout_dump_thread() into asm/a.out-core.h and makes it inline.  This
     is then included only where needed.  This means that this bit of arch
     code will be stored in the appropriate A.OUT binfmt module rather than
     the core kernel.

 (4) Drops A.OUT support for Blackfin (according to Mike Frysinger it's not
     needed) and FRV.

This patch depends on the previous patch to move STACK_TOP[_MAX] out of
asm/a.out.h and into asm/processor.h as they're required whether or not A.OUT
format is available.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/alpha/kernel/process.c         |   62 ---------------------------
 arch/arm/kernel/process.c           |   29 -------------
 arch/blackfin/kernel/bfin_ksyms.c   |    1 
 arch/blackfin/kernel/process.c      |   45 -------------------
 arch/m68k/kernel/process.c          |   47 --------------------
 arch/sparc/kernel/process.c         |   32 --------------
 arch/sparc/kernel/sparc_ksyms.c     |    2 -
 arch/sparc64/kernel/binfmt_aout32.c |    3 +
 arch/sparc64/kernel/process.c       |   11 -----
 arch/um/kernel/ksyms.c              |    1 
 arch/um/kernel/process.c            |    5 --
 arch/x86/kernel/process_32.c        |   43 -------------------
 fs/Kconfig.binfmt                   |    3 +
 fs/binfmt_aout.c                    |    3 +
 fs/binfmt_elf.c                     |   34 +++++++++++----
 fs/exec.c                           |    2 -
 include/asm-alpha/a.out-core.h      |   81 +++++++++++++++++++++++++++++++++++
 include/asm-arm/a.out-core.h        |   50 ++++++++++++++++++++++
 include/asm-frv/a.out.h             |    5 --
 include/asm-generic/Kbuild.asm      |    2 +
 include/asm-m68k/a.out-core.h       |   69 ++++++++++++++++++++++++++++++
 include/asm-sparc/a.out-core.h      |   55 ++++++++++++++++++++++++
 include/asm-sparc64/a.out-core.h    |   31 +++++++++++++
 include/asm-um/a.out-core.h         |   27 ++++++++++++
 include/asm-x86/a.out-core.h        |   67 +++++++++++++++++++++++++++++
 include/linux/Kbuild                |    2 +
 include/linux/a.out.h               |   12 +++++
 include/linux/kernel.h              |    2 -
 28 files changed, 429 insertions(+), 297 deletions(-)

diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 92b6162..9aed477 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -318,68 +318,6 @@ copy_thread(int nr, unsigned long clone_flags, unsigned long usp,
 }
 
 /*
- * Fill in the user structure for an ECOFF core dump.
- */
-void
-dump_thread(struct pt_regs * pt, struct user * dump)
-{
-	/* switch stack follows right below pt_regs: */
-	struct switch_stack * sw = ((struct switch_stack *) pt) - 1;
-
-	dump->magic = CMAGIC;
-	dump->start_code  = current->mm->start_code;
-	dump->start_data  = current->mm->start_data;
-	dump->start_stack = rdusp() & ~(PAGE_SIZE - 1);
-	dump->u_tsize = ((current->mm->end_code - dump->start_code)
-			 >> PAGE_SHIFT);
-	dump->u_dsize = ((current->mm->brk + PAGE_SIZE-1 - dump->start_data)
-			 >> PAGE_SHIFT);
-	dump->u_ssize = (current->mm->start_stack - dump->start_stack
-			 + PAGE_SIZE-1) >> PAGE_SHIFT;
-
-	/*
-	 * We store the registers in an order/format that is
-	 * compatible with DEC Unix/OSF/1 as this makes life easier
-	 * for gdb.
-	 */
-	dump->regs[EF_V0]  = pt->r0;
-	dump->regs[EF_T0]  = pt->r1;
-	dump->regs[EF_T1]  = pt->r2;
-	dump->regs[EF_T2]  = pt->r3;
-	dump->regs[EF_T3]  = pt->r4;
-	dump->regs[EF_T4]  = pt->r5;
-	dump->regs[EF_T5]  = pt->r6;
-	dump->regs[EF_T6]  = pt->r7;
-	dump->regs[EF_T7]  = pt->r8;
-	dump->regs[EF_S0]  = sw->r9;
-	dump->regs[EF_S1]  = sw->r10;
-	dump->regs[EF_S2]  = sw->r11;
-	dump->regs[EF_S3]  = sw->r12;
-	dump->regs[EF_S4]  = sw->r13;
-	dump->regs[EF_S5]  = sw->r14;
-	dump->regs[EF_S6]  = sw->r15;
-	dump->regs[EF_A3]  = pt->r19;
-	dump->regs[EF_A4]  = pt->r20;
-	dump->regs[EF_A5]  = pt->r21;
-	dump->regs[EF_T8]  = pt->r22;
-	dump->regs[EF_T9]  = pt->r23;
-	dump->regs[EF_T10] = pt->r24;
-	dump->regs[EF_T11] = pt->r25;
-	dump->regs[EF_RA]  = pt->r26;
-	dump->regs[EF_T12] = pt->r27;
-	dump->regs[EF_AT]  = pt->r28;
-	dump->regs[EF_SP]  = rdusp();
-	dump->regs[EF_PS]  = pt->ps;
-	dump->regs[EF_PC]  = pt->pc;
-	dump->regs[EF_GP]  = pt->gp;
-	dump->regs[EF_A0]  = pt->r16;
-	dump->regs[EF_A1]  = pt->r17;
-	dump->regs[EF_A2]  = pt->r18;
-	memcpy((char *)dump->regs + EF_SIZE, sw->fp, 32 * 8);
-}
-EXPORT_SYMBOL(dump_thread);
-
-/*
  * Fill in the user structure for a ELF core dump.
  */
 void
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 4f1a031..436380a 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -368,35 +368,6 @@ int dump_fpu (struct pt_regs *regs, struct user_fp *fp)
 EXPORT_SYMBOL(dump_fpu);
 
 /*
- * fill in the user structure for a core dump..
- */
-void dump_thread(struct pt_regs * regs, struct user * dump)
-{
-	struct task_struct *tsk = current;
-
-	dump->magic = CMAGIC;
-	dump->start_code = tsk->mm->start_code;
-	dump->start_stack = regs->ARM_sp & ~(PAGE_SIZE - 1);
-
-	dump->u_tsize = (tsk->mm->end_code - tsk->mm->start_code) >> PAGE_SHIFT;
-	dump->u_dsize = (tsk->mm->brk - tsk->mm->start_data + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	dump->u_ssize = 0;
-
-	dump->u_debugreg[0] = tsk->thread.debug.bp[0].address;
-	dump->u_debugreg[1] = tsk->thread.debug.bp[1].address;
-	dump->u_debugreg[2] = tsk->thread.debug.bp[0].insn.arm;
-	dump->u_debugreg[3] = tsk->thread.debug.bp[1].insn.arm;
-	dump->u_debugreg[4] = tsk->thread.debug.nsaved;
-
-	if (dump->start_stack < 0x04000000)
-		dump->u_ssize = (0x04000000 - dump->start_stack) >> PAGE_SHIFT;
-
-	dump->regs = *regs;
-	dump->u_fpvalid = dump_fpu (regs, &dump->u_fp);
-}
-EXPORT_SYMBOL(dump_thread);
-
-/*
  * Shuffle the argument into the correct register before calling the
  * thread function.  r1 is the thread argument, r2 is the pointer to
  * the thread function, and r3 points to the exit function.
diff --git a/arch/blackfin/kernel/bfin_ksyms.c b/arch/blackfin/kernel/bfin_ksyms.c
index 2198afe..99ea57c 100644
--- a/arch/blackfin/kernel/bfin_ksyms.c
+++ b/arch/blackfin/kernel/bfin_ksyms.c
@@ -39,7 +39,6 @@
 EXPORT_SYMBOL(__ioremap);
 EXPORT_SYMBOL(strcmp);
 EXPORT_SYMBOL(strncmp);
-EXPORT_SYMBOL(dump_thread);
 
 EXPORT_SYMBOL(ip_fast_csum);
 
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 9124467..1a8cf33 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -239,51 +239,6 @@ copy_thread(int nr, unsigned long clone_flags,
 }
 
 /*
- * fill in the user structure for a core dump..
- */
-void dump_thread(struct pt_regs *regs, struct user *dump)
-{
-	dump->magic = CMAGIC;
-	dump->start_code = 0;
-	dump->start_stack = rdusp() & ~(PAGE_SIZE - 1);
-	dump->u_tsize = ((unsigned long)current->mm->end_code) >> PAGE_SHIFT;
-	dump->u_dsize = ((unsigned long)(current->mm->brk +
-					 (PAGE_SIZE - 1))) >> PAGE_SHIFT;
-	dump->u_dsize -= dump->u_tsize;
-	dump->u_ssize = 0;
-
-	if (dump->start_stack < TASK_SIZE)
-		dump->u_ssize =
-		    ((unsigned long)(TASK_SIZE -
-				     dump->start_stack)) >> PAGE_SHIFT;
-
-	dump->u_ar0 = (struct user_regs_struct *)((int)&dump->regs - (int)dump);
-
-	dump->regs.r0 = regs->r0;
-	dump->regs.r1 = regs->r1;
-	dump->regs.r2 = regs->r2;
-	dump->regs.r3 = regs->r3;
-	dump->regs.r4 = regs->r4;
-	dump->regs.r5 = regs->r5;
-	dump->regs.r6 = regs->r6;
-	dump->regs.r7 = regs->r7;
-	dump->regs.p0 = regs->p0;
-	dump->regs.p1 = regs->p1;
-	dump->regs.p2 = regs->p2;
-	dump->regs.p3 = regs->p3;
-	dump->regs.p4 = regs->p4;
-	dump->regs.p5 = regs->p5;
-	dump->regs.orig_p0 = regs->orig_p0;
-	dump->regs.a0w = regs->a0w;
-	dump->regs.a1w = regs->a1w;
-	dump->regs.a0x = regs->a0x;
-	dump->regs.a1x = regs->a1x;
-	dump->regs.rets = regs->rets;
-	dump->regs.astat = regs->astat;
-	dump->regs.pc = regs->pc;
-}
-
-/*
  * sys_execve() executes a new program.
  */
 
diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index 3ee9186..5f45567 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -316,53 +316,6 @@ int dump_fpu (struct pt_regs *regs, struct user_m68kfp_struct *fpu)
 EXPORT_SYMBOL(dump_fpu);
 
 /*
- * fill in the user structure for a core dump..
- */
-void dump_thread(struct pt_regs * regs, struct user * dump)
-{
-	struct switch_stack *sw;
-
-/* changed the size calculations - should hopefully work better. lbt */
-	dump->magic = CMAGIC;
-	dump->start_code = 0;
-	dump->start_stack = rdusp() & ~(PAGE_SIZE - 1);
-	dump->u_tsize = ((unsigned long) current->mm->end_code) >> PAGE_SHIFT;
-	dump->u_dsize = ((unsigned long) (current->mm->brk +
-					  (PAGE_SIZE-1))) >> PAGE_SHIFT;
-	dump->u_dsize -= dump->u_tsize;
-	dump->u_ssize = 0;
-
-	if (dump->start_stack < TASK_SIZE)
-		dump->u_ssize = ((unsigned long) (TASK_SIZE - dump->start_stack)) >> PAGE_SHIFT;
-
-	dump->u_ar0 = (struct user_regs_struct *)((int)&dump->regs - (int)dump);
-	sw = ((struct switch_stack *)regs) - 1;
-	dump->regs.d1 = regs->d1;
-	dump->regs.d2 = regs->d2;
-	dump->regs.d3 = regs->d3;
-	dump->regs.d4 = regs->d4;
-	dump->regs.d5 = regs->d5;
-	dump->regs.d6 = sw->d6;
-	dump->regs.d7 = sw->d7;
-	dump->regs.a0 = regs->a0;
-	dump->regs.a1 = regs->a1;
-	dump->regs.a2 = regs->a2;
-	dump->regs.a3 = sw->a3;
-	dump->regs.a4 = sw->a4;
-	dump->regs.a5 = sw->a5;
-	dump->regs.a6 = sw->a6;
-	dump->regs.d0 = regs->d0;
-	dump->regs.orig_d0 = regs->orig_d0;
-	dump->regs.stkadj = regs->stkadj;
-	dump->regs.sr = regs->sr;
-	dump->regs.pc = regs->pc;
-	dump->regs.fmtvec = (regs->format << 12) | regs->vector;
-	/* dump floating point stuff */
-	dump->u_fpvalid = dump_fpu (regs, &dump->m68kfp);
-}
-EXPORT_SYMBOL(dump_thread);
-
-/*
  * sys_execve() executes a new program.
  */
 asmlinkage int sys_execve(char __user *name, char __user * __user *argv, char __user * __user *envp)
diff --git a/arch/sparc/kernel/process.c b/arch/sparc/kernel/process.c
index 77460e3..a248e81 100644
--- a/arch/sparc/kernel/process.c
+++ b/arch/sparc/kernel/process.c
@@ -567,38 +567,6 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
 }
 
 /*
- * fill in the user structure for a core dump..
- */
-void dump_thread(struct pt_regs * regs, struct user * dump)
-{
-	unsigned long first_stack_page;
-
-	dump->magic = SUNOS_CORE_MAGIC;
-	dump->len = sizeof(struct user);
-	dump->regs.psr = regs->psr;
-	dump->regs.pc = regs->pc;
-	dump->regs.npc = regs->npc;
-	dump->regs.y = regs->y;
-	/* fuck me plenty */
-	memcpy(&dump->regs.regs[0], &regs->u_regs[1], (sizeof(unsigned long) * 15));
-	dump->uexec = current->thread.core_exec;
-	dump->u_tsize = (((unsigned long) current->mm->end_code) -
-		((unsigned long) current->mm->start_code)) & ~(PAGE_SIZE - 1);
-	dump->u_dsize = ((unsigned long) (current->mm->brk + (PAGE_SIZE-1)));
-	dump->u_dsize -= dump->u_tsize;
-	dump->u_dsize &= ~(PAGE_SIZE - 1);
-	first_stack_page = (regs->u_regs[UREG_FP] & ~(PAGE_SIZE - 1));
-	dump->u_ssize = (TASK_SIZE - first_stack_page) & ~(PAGE_SIZE - 1);
-	memcpy(&dump->fpu.fpstatus.fregs.regs[0], &current->thread.float_regs[0], (sizeof(unsigned long) * 32));
-	dump->fpu.fpstatus.fsr = current->thread.fsr;
-	dump->fpu.fpstatus.flags = dump->fpu.fpstatus.extra = 0;
-	dump->fpu.fpstatus.fpq_count = current->thread.fpqdepth;
-	memcpy(&dump->fpu.fpstatus.fpq[0], &current->thread.fpqueue[0],
-	       ((sizeof(unsigned long) * 2) * 16));
-	dump->sigcode = 0;
-}
-
-/*
  * fill in the fpu structure for a core dump.
  */
 int dump_fpu (struct pt_regs * regs, elf_fpregset_t * fpregs)
diff --git a/arch/sparc/kernel/sparc_ksyms.c b/arch/sparc/kernel/sparc_ksyms.c
index ef647ac..62f6221 100644
--- a/arch/sparc/kernel/sparc_ksyms.c
+++ b/arch/sparc/kernel/sparc_ksyms.c
@@ -214,8 +214,6 @@ EXPORT_SYMBOL(kunmap_atomic);
 EXPORT_SYMBOL(svr4_setcontext);
 EXPORT_SYMBOL(svr4_getcontext);
 
-EXPORT_SYMBOL(dump_thread);
-
 /* prom symbols */
 EXPORT_SYMBOL(idprom);
 EXPORT_SYMBOL(prom_root_node);
diff --git a/arch/sparc64/kernel/binfmt_aout32.c b/arch/sparc64/kernel/binfmt_aout32.c
index 92c1b36..9877f2d 100644
--- a/arch/sparc64/kernel/binfmt_aout32.c
+++ b/arch/sparc64/kernel/binfmt_aout32.c
@@ -32,6 +32,7 @@
 #include <asm/uaccess.h>
 #include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
+#include <asm/a.out-core.h>
 
 static int load_aout32_binary(struct linux_binprm *, struct pt_regs * regs);
 static int load_aout32_library(struct file*);
@@ -101,7 +102,7 @@ static int aout32_core_dump(long signr, struct pt_regs *regs, struct file *file,
 	current->flags |= PF_DUMPCORE;
        	strncpy(dump.u_comm, current->comm, sizeof(dump.u_comm));
 	dump.signal = signr;
-	dump_thread(regs, &dump);
+	aout_dump_thread(regs, &dump);
 
 /* If the size of the dump file exceeds the rlimit, then see what would happen
    if we wrote the stack, but not the data area.  */
diff --git a/arch/sparc64/kernel/process.c b/arch/sparc64/kernel/process.c
index ca7cdfd..6e21785 100644
--- a/arch/sparc64/kernel/process.c
+++ b/arch/sparc64/kernel/process.c
@@ -725,17 +725,6 @@ pid_t kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
 	return retval;
 }
 
-/*
- * fill in the user structure for a core dump..
- */
-void dump_thread(struct pt_regs * regs, struct user * dump)
-{
-	/* Only should be used for SunOS and ancient a.out
-	 * SparcLinux binaries...  Not worth implementing.
-	 */
-	memset(dump, 0, sizeof(struct user));
-}
-
 typedef struct {
 	union {
 		unsigned int	pr_regs[32];
diff --git a/arch/um/kernel/ksyms.c b/arch/um/kernel/ksyms.c
index 1b388b4..d3a81dd 100644
--- a/arch/um/kernel/ksyms.c
+++ b/arch/um/kernel/ksyms.c
@@ -65,7 +65,6 @@ EXPORT_SYMBOL(os_accept_connection);
 EXPORT_SYMBOL(os_rcv_fd);
 EXPORT_SYMBOL(run_helper);
 EXPORT_SYMBOL(start_thread);
-EXPORT_SYMBOL(dump_thread);
 
 #ifdef CONFIG_SMP
 
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 0eae00b..7ff5598 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -4,6 +4,7 @@
  * Licensed under the GPL
  */
 
+#include "linux/module.h"
 #include "linux/stddef.h"
 #include "linux/err.h"
 #include "linux/hardirq.h"
@@ -303,10 +304,6 @@ char *current_cmd(void)
 #endif
 }
 
-void dump_thread(struct pt_regs *regs, struct user *u)
-{
-}
-
 int __cant_sleep(void) {
 	return in_atomic() || irqs_disabled() || in_interrupt();
 	/* Is in_interrupt() really needed? */
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 7b89958..0c99e05 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -513,49 +513,6 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long esp,
 	return err;
 }
 
-/*
- * fill in the user structure for a core dump..
- */
-void dump_thread(struct pt_regs * regs, struct user * dump)
-{
-	int i;
-
-/* changed the size calculations - should hopefully work better. lbt */
-	dump->magic = CMAGIC;
-	dump->start_code = 0;
-	dump->start_stack = regs->esp & ~(PAGE_SIZE - 1);
-	dump->u_tsize = ((unsigned long) current->mm->end_code) >> PAGE_SHIFT;
-	dump->u_dsize = ((unsigned long) (current->mm->brk + (PAGE_SIZE-1))) >> PAGE_SHIFT;
-	dump->u_dsize -= dump->u_tsize;
-	dump->u_ssize = 0;
-	for (i = 0; i < 8; i++)
-		dump->u_debugreg[i] = current->thread.debugreg[i];  
-
-	if (dump->start_stack < TASK_SIZE)
-		dump->u_ssize = ((unsigned long) (TASK_SIZE - dump->start_stack)) >> PAGE_SHIFT;
-
-	dump->regs.ebx = regs->ebx;
-	dump->regs.ecx = regs->ecx;
-	dump->regs.edx = regs->edx;
-	dump->regs.esi = regs->esi;
-	dump->regs.edi = regs->edi;
-	dump->regs.ebp = regs->ebp;
-	dump->regs.eax = regs->eax;
-	dump->regs.ds = regs->xds;
-	dump->regs.es = regs->xes;
-	dump->regs.fs = regs->xfs;
-	savesegment(gs,dump->regs.gs);
-	dump->regs.orig_eax = regs->orig_eax;
-	dump->regs.eip = regs->eip;
-	dump->regs.cs = regs->xcs;
-	dump->regs.eflags = regs->eflags;
-	dump->regs.esp = regs->esp;
-	dump->regs.ss = regs->xss;
-
-	dump->u_fpvalid = dump_fpu (regs, &dump->i387);
-}
-EXPORT_SYMBOL(dump_thread);
-
 /* 
  * Capture the user space registers if the task is not running (in user space)
  */
diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index d4fc609..94840ac 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -57,7 +57,8 @@ config BINFMT_SHARED_FLAT
 
 config BINFMT_AOUT
 	tristate "Kernel support for a.out and ECOFF binaries"
-	depends on X86_32 || ALPHA || ARM || M68K || SPARC32
+	depends on ARCH_SUPPORTS_AOUT && \
+		(X86_32 || ALPHA || ARM || M68K || SPARC32)
 	---help---
 	  A.out (Assembler.OUTput) is a set of formats for libraries and
 	  executables used in the earliest versions of UNIX.  Linux used
diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index e176d19..d78a18a 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -28,6 +28,7 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
+#include <asm/a.out-core.h>
 
 static int load_aout_binary(struct linux_binprm *, struct pt_regs * regs);
 static int load_aout_library(struct file*);
@@ -118,7 +119,7 @@ static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, u
 	dump.u_ar0 = (void *)(((unsigned long)(&dump.regs)) - ((unsigned long)(&dump)));
 #endif
 	dump.signal = signr;
-	dump_thread(regs, &dump);
+	aout_dump_thread(regs, &dump);
 
 /* If the size of the dump file exceeds the rlimit, then see what would happen
    if we wrote the stack, but not the data area.  */
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index ba8de7c..59e09df 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -464,6 +464,7 @@ out:
 	return error;
 }
 
+#ifdef CONFIG_ARCH_SUPPORTS_AOUT
 static unsigned long load_aout_interp(struct exec *interp_ex,
 		struct file *interpreter)
 {
@@ -509,6 +510,14 @@ static unsigned long load_aout_interp(struct exec *interp_ex,
 out:
 	return elf_entry;
 }
+#else
+/* dummy extern - the function should never be called if !CONFIG_AOUT_BINFMT */
+static inline unsigned long load_aout_interp(struct exec *interp_ex,
+					     struct file *interpreter)
+{
+	return -ELIBACC;
+}
+#endif
 
 /*
  * These are the functions used to load ELF style executables and shared
@@ -516,9 +525,15 @@ out:
  */
 
 #define INTERPRETER_NONE 0
-#define INTERPRETER_AOUT 1
 #define INTERPRETER_ELF 2
 
+#ifdef CONFIG_ARCH_SUPPORTS_AOUT
+#define INTERPRETER_AOUT 1
+#define IS_AOUT_INTERP(x) ((x) == INTERPRETER_AOUT)
+#else
+#define IS_AOUT_INTERP(x) (0)
+#endif
+
 #ifndef STACK_RND_MASK
 #define STACK_RND_MASK (0x7ff >> (PAGE_SHIFT - 12))	/* 8MB of VA */
 #endif
@@ -734,6 +749,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	/* Some simple consistency checks for the interpreter */
 	if (elf_interpreter) {
 		static int warn;
+#ifdef CONFIG_ARCH_SUPPORTS_AOUT
 		interpreter_type = INTERPRETER_ELF | INTERPRETER_AOUT;
 
 		/* Now figure out which format our binary is */
@@ -741,11 +757,13 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 		    (N_MAGIC(loc->interp_ex) != ZMAGIC) &&
 		    (N_MAGIC(loc->interp_ex) != QMAGIC))
 			interpreter_type = INTERPRETER_ELF;
-
+#else
+		interpreter_type = INTERPRETER_ELF;
+#endif
 		if (memcmp(loc->interp_elf_ex.e_ident, ELFMAG, SELFMAG) != 0)
 			interpreter_type &= ~INTERPRETER_ELF;
 
-		if (interpreter_type == INTERPRETER_AOUT && warn < 10) {
+		if (IS_AOUT_INTERP(interpreter_type) && warn < 10) {
 			printk(KERN_WARNING "a.out ELF interpreter %s is "
 				"deprecated and will not be supported "
 				"after Linux 2.6.25\n", elf_interpreter);
@@ -774,7 +792,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 
 	/* OK, we are done with that, now set up the arg stuff,
 	   and then start this sucker up */
-	if ((!bprm->sh_bang) && (interpreter_type == INTERPRETER_AOUT)) {
+	if (IS_AOUT_INTERP(interpreter_type) && !bprm->sh_bang) {
 		char *passed_p = passed_fileno;
 		sprintf(passed_fileno, "%d", elf_exec_fileno);
 
@@ -961,7 +979,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	}
 
 	if (elf_interpreter) {
-		if (interpreter_type == INTERPRETER_AOUT)
+		if (IS_AOUT_INTERP(interpreter_type))
 			elf_entry = load_aout_interp(&loc->interp_ex,
 						     interpreter);
 		else
@@ -990,7 +1008,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 
 	kfree(elf_phdata);
 
-	if (interpreter_type != INTERPRETER_AOUT)
+	if (!IS_AOUT_INTERP(interpreter_type))
 		sys_close(elf_exec_fileno);
 
 	set_binfmt(&elf_format);
@@ -1006,14 +1024,14 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	compute_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
 	retval = create_elf_tables(bprm, &loc->elf_ex,
-			  (interpreter_type == INTERPRETER_AOUT),
+			  IS_AOUT_INTERP(interpreter_type),
 			  load_addr, interp_load_addr);
 	if (retval < 0) {
 		send_sig(SIGKILL, current, 0);
 		goto out;
 	}
 	/* N.B. passed_fileno might not be initialized? */
-	if (interpreter_type == INTERPRETER_AOUT)
+	if (IS_AOUT_INTERP(interpreter_type))
 		current->mm->arg_start += strlen(passed_fileno) + 1;
 	current->mm->end_code = end_code;
 	current->mm->start_code = start_code;
diff --git a/fs/exec.c b/fs/exec.c
index 2c942e2..f21aa9f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1188,7 +1188,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 {
 	int try,retval;
 	struct linux_binfmt *fmt;
-#ifdef __alpha__
+#if defined(__alpha__) && defined(CONFIG_ARCH_SUPPORTS_AOUT)
 	/* handle /sbin/loader.. */
 	{
 	    struct exec * eh = (struct exec *) bprm->buf;
diff --git a/include/asm-alpha/a.out-core.h b/include/asm-alpha/a.out-core.h
new file mode 100644
index 0000000..d1f215c
--- /dev/null
+++ b/include/asm-alpha/a.out-core.h
@@ -0,0 +1,81 @@
+/* a.out coredump register dumper
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_A_OUT_CORE_H
+#define _ASM_A_OUT_CORE_H
+
+#ifdef __KERNEL__
+
+#include <linux/user.h>
+
+/*
+ * Fill in the user structure for an ECOFF core dump.
+ */
+static inline void
+aout_dump_thread(struct pt_regs *pt, struct user *dump)
+{
+	/* switch stack follows right below pt_regs: */
+	struct switch_stack *sw = ((struct switch_stack *) pt) - 1;
+
+	dump->magic = CMAGIC;
+	dump->start_code  = current->mm->start_code;
+	dump->start_data  = current->mm->start_data;
+	dump->start_stack = rdusp() & ~(PAGE_SIZE - 1);
+	dump->u_tsize = ((current->mm->end_code - dump->start_code)
+			 >> PAGE_SHIFT);
+	dump->u_dsize = ((current->mm->brk + PAGE_SIZE-1 - dump->start_data)
+			 >> PAGE_SHIFT);
+	dump->u_ssize = (current->mm->start_stack - dump->start_stack
+			 + PAGE_SIZE-1) >> PAGE_SHIFT;
+
+	/*
+	 * We store the registers in an order/format that is
+	 * compatible with DEC Unix/OSF/1 as this makes life easier
+	 * for gdb.
+	 */
+	dump->regs[EF_V0]  = pt->r0;
+	dump->regs[EF_T0]  = pt->r1;
+	dump->regs[EF_T1]  = pt->r2;
+	dump->regs[EF_T2]  = pt->r3;
+	dump->regs[EF_T3]  = pt->r4;
+	dump->regs[EF_T4]  = pt->r5;
+	dump->regs[EF_T5]  = pt->r6;
+	dump->regs[EF_T6]  = pt->r7;
+	dump->regs[EF_T7]  = pt->r8;
+	dump->regs[EF_S0]  = sw->r9;
+	dump->regs[EF_S1]  = sw->r10;
+	dump->regs[EF_S2]  = sw->r11;
+	dump->regs[EF_S3]  = sw->r12;
+	dump->regs[EF_S4]  = sw->r13;
+	dump->regs[EF_S5]  = sw->r14;
+	dump->regs[EF_S6]  = sw->r15;
+	dump->regs[EF_A3]  = pt->r19;
+	dump->regs[EF_A4]  = pt->r20;
+	dump->regs[EF_A5]  = pt->r21;
+	dump->regs[EF_T8]  = pt->r22;
+	dump->regs[EF_T9]  = pt->r23;
+	dump->regs[EF_T10] = pt->r24;
+	dump->regs[EF_T11] = pt->r25;
+	dump->regs[EF_RA]  = pt->r26;
+	dump->regs[EF_T12] = pt->r27;
+	dump->regs[EF_AT]  = pt->r28;
+	dump->regs[EF_SP]  = rdusp();
+	dump->regs[EF_PS]  = pt->ps;
+	dump->regs[EF_PC]  = pt->pc;
+	dump->regs[EF_GP]  = pt->gp;
+	dump->regs[EF_A0]  = pt->r16;
+	dump->regs[EF_A1]  = pt->r17;
+	dump->regs[EF_A2]  = pt->r18;
+	memcpy((char *)dump->regs + EF_SIZE, sw->fp, 32 * 8);
+}
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_A_OUT_CORE_H */
diff --git a/include/asm-arm/a.out-core.h b/include/asm-arm/a.out-core.h
new file mode 100644
index 0000000..bcdb198
--- /dev/null
+++ b/include/asm-arm/a.out-core.h
@@ -0,0 +1,50 @@
+/* a.out coredump register dumper
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_A_OUT_CORE_H
+#define _ASM_A_OUT_CORE_H
+
+#ifdef __KERNEL__
+
+#include <linux/user.h>
+#include <linux/elfcore.h>
+
+/*
+ * fill in the user structure for an a.out core dump
+ */
+static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
+{
+	struct task_struct *tsk = current;
+
+	dump->magic = CMAGIC;
+	dump->start_code = tsk->mm->start_code;
+	dump->start_stack = regs->ARM_sp & ~(PAGE_SIZE - 1);
+
+	dump->u_tsize = (tsk->mm->end_code - tsk->mm->start_code) >> PAGE_SHIFT;
+	dump->u_dsize = (tsk->mm->brk - tsk->mm->start_data + PAGE_SIZE - 1) >>
+		PAGE_SHIFT;
+	dump->u_ssize = 0;
+
+	dump->u_debugreg[0] = tsk->thread.debug.bp[0].address;
+	dump->u_debugreg[1] = tsk->thread.debug.bp[1].address;
+	dump->u_debugreg[2] = tsk->thread.debug.bp[0].insn.arm;
+	dump->u_debugreg[3] = tsk->thread.debug.bp[1].insn.arm;
+	dump->u_debugreg[4] = tsk->thread.debug.nsaved;
+
+	if (dump->start_stack < 0x04000000)
+		dump->u_ssize = (0x04000000 - dump->start_stack) >> PAGE_SHIFT;
+
+	dump->regs = *regs;
+	dump->u_fpvalid = dump_fpu(regs, &dump->u_fp);
+}
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_A_OUT_CORE_H */
diff --git a/include/asm-frv/a.out.h b/include/asm-frv/a.out.h
deleted file mode 100644
index dd3b7e5..0000000
--- a/include/asm-frv/a.out.h
+++ /dev/null
@@ -1,5 +0,0 @@
-/*
- * FRV doesn't do AOUT format. This header file should be removed as
- * soon as fs/exec.c and fs/proc/kcore.c and the archs that require
- * them to include linux/a.out.h are fixed.
- */
diff --git a/include/asm-generic/Kbuild.asm b/include/asm-generic/Kbuild.asm
index 8fd8171..f1184d0 100644
--- a/include/asm-generic/Kbuild.asm
+++ b/include/asm-generic/Kbuild.asm
@@ -1,4 +1,6 @@
+ifeq ($(wildcard include/asm-$(SRCARCH)/a.out.h),include/asm-$(SRCARCH)/a.out.h)
 unifdef-y += a.out.h
+endif
 unifdef-y += auxvec.h
 unifdef-y += byteorder.h
 unifdef-y += errno.h
diff --git a/include/asm-m68k/a.out-core.h b/include/asm-m68k/a.out-core.h
new file mode 100644
index 0000000..ced8e10
--- /dev/null
+++ b/include/asm-m68k/a.out-core.h
@@ -0,0 +1,69 @@
+/* a.out coredump register dumper
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_A_OUT_CORE_H
+#define _ASM_A_OUT_CORE_H
+
+#ifdef __KERNEL__
+
+#include <linux/user.h>
+#include <linux/elfcore.h>
+
+/*
+ * fill in the user structure for an a.out core dump
+ */
+static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
+{
+	struct switch_stack *sw;
+
+	/* changed the size calculations - should hopefully work better. lbt */
+	dump->magic = CMAGIC;
+	dump->start_code = 0;
+	dump->start_stack = rdusp() & ~(PAGE_SIZE - 1);
+	dump->u_tsize = ((unsigned long) current->mm->end_code) >> PAGE_SHIFT;
+	dump->u_dsize = ((unsigned long) (current->mm->brk +
+					  (PAGE_SIZE-1))) >> PAGE_SHIFT;
+	dump->u_dsize -= dump->u_tsize;
+	dump->u_ssize = 0;
+
+	if (dump->start_stack < TASK_SIZE)
+		dump->u_ssize =
+			((unsigned long) (TASK_SIZE - dump->start_stack)) >>
+			PAGE_SHIFT;
+
+	dump->u_ar0 = (struct user_regs_struct *)((int)&dump->regs - (int)dump);
+	sw = ((struct switch_stack *)regs) - 1;
+	dump->regs.d1 = regs->d1;
+	dump->regs.d2 = regs->d2;
+	dump->regs.d3 = regs->d3;
+	dump->regs.d4 = regs->d4;
+	dump->regs.d5 = regs->d5;
+	dump->regs.d6 = sw->d6;
+	dump->regs.d7 = sw->d7;
+	dump->regs.a0 = regs->a0;
+	dump->regs.a1 = regs->a1;
+	dump->regs.a2 = regs->a2;
+	dump->regs.a3 = sw->a3;
+	dump->regs.a4 = sw->a4;
+	dump->regs.a5 = sw->a5;
+	dump->regs.a6 = sw->a6;
+	dump->regs.d0 = regs->d0;
+	dump->regs.orig_d0 = regs->orig_d0;
+	dump->regs.stkadj = regs->stkadj;
+	dump->regs.sr = regs->sr;
+	dump->regs.pc = regs->pc;
+	dump->regs.fmtvec = (regs->format << 12) | regs->vector;
+	/* dump floating point stuff */
+	dump->u_fpvalid = dump_fpu(regs, &dump->m68kfp);
+}
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_A_OUT_CORE_H */
diff --git a/include/asm-sparc/a.out-core.h b/include/asm-sparc/a.out-core.h
new file mode 100644
index 0000000..8ec7733
--- /dev/null
+++ b/include/asm-sparc/a.out-core.h
@@ -0,0 +1,55 @@
+/* a.out coredump register dumper
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_A_OUT_CORE_H
+#define _ASM_A_OUT_CORE_H
+
+#ifdef __KERNEL__
+
+#include <linux/user.h>
+
+/*
+ * fill in the user structure for an a.out core dump
+ */
+static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
+{
+	unsigned long first_stack_page;
+
+	dump->magic = SUNOS_CORE_MAGIC;
+	dump->len = sizeof(struct user);
+	dump->regs.psr = regs->psr;
+	dump->regs.pc = regs->pc;
+	dump->regs.npc = regs->npc;
+	dump->regs.y = regs->y;
+	/* fuck me plenty */
+	memcpy(&dump->regs.regs[0], &regs->u_regs[1],
+	       (sizeof(unsigned long) * 15));
+	dump->uexec = current->thread.core_exec;
+	dump->u_tsize = (((unsigned long) current->mm->end_code) -
+		((unsigned long) current->mm->start_code)) & ~(PAGE_SIZE - 1);
+	dump->u_dsize = ((unsigned long) (current->mm->brk + (PAGE_SIZE-1)));
+	dump->u_dsize -= dump->u_tsize;
+	dump->u_dsize &= ~(PAGE_SIZE - 1);
+	first_stack_page = (regs->u_regs[UREG_FP] & ~(PAGE_SIZE - 1));
+	dump->u_ssize = (TASK_SIZE - first_stack_page) & ~(PAGE_SIZE - 1);
+	memcpy(&dump->fpu.fpstatus.fregs.regs[0],
+	       &current->thread.float_regs[0],
+	       sizeof(unsigned long) * 32);
+	dump->fpu.fpstatus.fsr = current->thread.fsr;
+	dump->fpu.fpstatus.flags = dump->fpu.fpstatus.extra = 0;
+	dump->fpu.fpstatus.fpq_count = current->thread.fpqdepth;
+	memcpy(&dump->fpu.fpstatus.fpq[0], &current->thread.fpqueue[0],
+	       ((sizeof(unsigned long) * 2) * 16));
+	dump->sigcode = 0;
+}
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_A_OUT_CORE_H */
diff --git a/include/asm-sparc64/a.out-core.h b/include/asm-sparc64/a.out-core.h
new file mode 100644
index 0000000..3499b3c
--- /dev/null
+++ b/include/asm-sparc64/a.out-core.h
@@ -0,0 +1,31 @@
+/* a.out coredump register dumper
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_A_OUT_CORE_H
+#define _ASM_A_OUT_CORE_H
+
+#ifdef __KERNEL__
+
+#include <linux/user.h>
+
+/*
+ * fill in the user structure for an a.out core dump
+ */
+static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
+{
+	/* Only should be used for SunOS and ancient a.out
+	 * SparcLinux binaries...  Not worth implementing.
+	 */
+	memset(dump, 0, sizeof(struct user));
+}
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_A_OUT_CORE_H */
diff --git a/include/asm-um/a.out-core.h b/include/asm-um/a.out-core.h
new file mode 100644
index 0000000..995643b
--- /dev/null
+++ b/include/asm-um/a.out-core.h
@@ -0,0 +1,27 @@
+/* a.out coredump register dumper
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef __UM_A_OUT_CORE_H
+#define __UM_A_OUT_CORE_H
+
+#ifdef __KERNEL__
+
+#include <linux/user.h>
+
+/*
+ * fill in the user structure for an a.out core dump
+ */
+static inline void aout_dump_thread(struct pt_regs *regs, struct user *u)
+{
+}
+
+#endif /* __KERNEL__ */
+#endif /* __UM_A_OUT_CORE_H */
diff --git a/include/asm-x86/a.out-core.h b/include/asm-x86/a.out-core.h
new file mode 100644
index 0000000..c44fde9
--- /dev/null
+++ b/include/asm-x86/a.out-core.h
@@ -0,0 +1,67 @@
+/* a.out coredump register dumper
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_A_OUT_CORE_H
+#define _ASM_A_OUT_CORE_H
+
+#ifdef __KERNEL__
+#ifdef CONFIG_X86_32
+
+#include <linux/user.h>
+#include <linux/elfcore.h>
+
+/*
+ * fill in the user structure for an a.out core dump
+ */
+static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
+{
+	int i;
+
+/* changed the size calculations - should hopefully work better. lbt */
+	dump->magic = CMAGIC;
+	dump->start_code = 0;
+	dump->start_stack = regs->esp & ~(PAGE_SIZE - 1);
+	dump->u_tsize = ((unsigned long) current->mm->end_code) >> PAGE_SHIFT;
+	dump->u_dsize = ((unsigned long)
+			 (current->mm->brk + (PAGE_SIZE-1))) >> PAGE_SHIFT;
+	dump->u_dsize -= dump->u_tsize;
+	dump->u_ssize = 0;
+	for (i = 0; i < 8; i++)
+		dump->u_debugreg[i] = current->thread.debugreg[i];
+
+	if (dump->start_stack < TASK_SIZE)
+		dump->u_ssize = ((unsigned long)
+				 (TASK_SIZE - dump->start_stack)) >> PAGE_SHIFT;
+
+	dump->regs.ebx = regs->ebx;
+	dump->regs.ecx = regs->ecx;
+	dump->regs.edx = regs->edx;
+	dump->regs.esi = regs->esi;
+	dump->regs.edi = regs->edi;
+	dump->regs.ebp = regs->ebp;
+	dump->regs.eax = regs->eax;
+	dump->regs.ds = regs->xds;
+	dump->regs.es = regs->xes;
+	dump->regs.fs = regs->xfs;
+	savesegment(gs, dump->regs.gs);
+	dump->regs.orig_eax = regs->orig_eax;
+	dump->regs.eip = regs->eip;
+	dump->regs.cs = regs->xcs;
+	dump->regs.eflags = regs->eflags;
+	dump->regs.esp = regs->esp;
+	dump->regs.ss = regs->xss;
+
+	dump->u_fpvalid = dump_fpu(regs, &dump->i387);
+}
+
+#endif /* CONFIG_X86_32 */
+#endif /* __KERNEL__ */
+#endif /* _ASM_A_OUT_CORE_H */
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 37bfa19..80df38c 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -17,7 +17,9 @@ header-y += usb/
 
 header-y += affs_hardblocks.h
 header-y += aio_abi.h
+ifeq ($(wildcard include/asm-$(SRCARCH)/a.out.h),include/asm-$(SRCARCH)/a.out.h)
 header-y += a.out.h
+endif
 header-y += arcfb.h
 header-y += atmapi.h
 header-y += atmbr2684.h
diff --git a/include/linux/a.out.h b/include/linux/a.out.h
index f913cc3..d1c6b15 100644
--- a/include/linux/a.out.h
+++ b/include/linux/a.out.h
@@ -1,6 +1,8 @@
 #ifndef __A_OUT_GNU_H__
 #define __A_OUT_GNU_H__
 
+#ifdef CONFIG_ARCH_SUPPORTS_AOUT
+
 #define __GNU_EXEC_MACROS__
 
 #ifndef __STRUCT_EXEC_OVERRIDE__
@@ -9,6 +11,8 @@
 
 #endif /* __STRUCT_EXEC_OVERRIDE__ */
 
+#ifndef __ASSEMBLY__
+
 /* these go in the N_MACHTYPE field */
 enum machine_type {
 #if defined (M_OLDSUN2)
@@ -264,5 +268,11 @@ struct relocation_info
 };
 #endif /* no N_RELOCATION_INFO_DECLARED.  */
 
-
+#endif /*__ASSEMBLY__ */
+#else /* CONFIG_ARCH_SUPPORTS_AOUT */
+#ifndef __ASSEMBLY__
+struct exec {
+};
+#endif
+#endif /* CONFIG_ARCH_SUPPORTS_AOUT */
 #endif /* __A_OUT_GNU_H__ */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 94bc996..c34055a 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -172,8 +172,6 @@ extern int kernel_text_address(unsigned long addr);
 struct pid;
 extern struct pid *session_of_pgrp(struct pid *pgrp);
 
-extern void dump_thread(struct pt_regs *regs, struct user *dump);
-
 #ifdef CONFIG_PRINTK
 asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));

