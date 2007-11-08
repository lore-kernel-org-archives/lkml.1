Return-Path: <linux-kernel-owner+w=401wt.eu-S1761630AbXKHRRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761630AbXKHRRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 12:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760895AbXKHRQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 12:16:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760348AbXKHRQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 12:16:35 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/6] Suppress A.OUT library support if !CONFIG_BINFMT_AOUT
	[try #4]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-am33-list@redhat.com,
       dhowells@redhat.com
Date: Thu, 08 Nov 2007 17:16:17 +0000
Message-ID: <20071108171617.26590.43707.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071108171612.26590.4348.stgit@warthog.procyon.org.uk>
References: <20071108171612.26590.4348.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Suppress A.OUT library support if CONFIG_BINFMT_AOUT is not set.

Not all architectures support the A.OUT binfmt, so the ELF binfmt should not
be permitted to go looking for A.OUT libraries to load in such a case.  Not
only that, but under such conditions A.OUT core dumps are not produced either.

To make this work, this patch also does the following:

 (1) Makes the existence of the contents of linux/a.out.h more or less
     contingent on one of:

	CONFIG_BINFMT_AOUT=[ym]
	CONFIG_IA32_AOUT=[ym]
	CONFIG_BINFMT_AOUT32=[ym]

 (2) Moves STACK_TOP[_MAX] out of asm/a.out.h and into asm/processor.h as
     they're required whether or not A.OUT format is available.

 (3) Renames dump_thread() to aout_dump_thread() as it's only called by A.OUT
     core dumping code.

 (4) Moves aout_dump_thread() into asm/a.out-core.h and makes it inline.  This
     is then included only where needed.  This means that this bit of arch
     code will be stored in the appropriate A.OUT binfmt module rather than
     the core kernel.

 (5) Removes a lot of now obsolete {linux,asm}/a.out.h inclusions.

 (6) Drops A.OUT support for Blackfin (according to Mike Frysinger it's not
     needed).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/alpha/kernel/osf_sys.c         |    1 
 arch/alpha/kernel/process.c         |   63 ---------------------------
 arch/alpha/kernel/setup.c           |    1 
 arch/arm/kernel/process.c           |   30 -------------
 arch/blackfin/kernel/bfin_ksyms.c   |    1 
 arch/blackfin/kernel/process.c      |   46 --------------------
 arch/m68k/kernel/process.c          |   48 ---------------------
 arch/m68k/kernel/traps.c            |    1 
 arch/sparc/kernel/process.c         |   33 --------------
 arch/sparc/kernel/setup.c           |    1 
 arch/sparc/kernel/sparc_ksyms.c     |    3 -
 arch/sparc/mm/loadmmu.c             |    1 
 arch/sparc/mm/srmmu.c               |    1 
 arch/sparc64/kernel/binfmt_aout32.c |    3 +
 arch/sparc64/kernel/binfmt_elf32.c  |    2 -
 arch/sparc64/kernel/process.c       |   12 -----
 arch/sparc64/kernel/setup.c         |    1 
 arch/sparc64/kernel/sparc64_ksyms.c |    1 
 arch/sparc64/kernel/sys_sparc.c     |    1 
 arch/sparc64/kernel/sys_sparc32.c   |    1 
 arch/um/kernel/ksyms.c              |    2 -
 arch/um/kernel/process.c            |    5 --
 arch/x86/kernel/process_32.c        |   44 -------------------
 arch/x86/kernel/process_64.c        |    1 
 arch/x86/kernel/setup_64.c          |    1 
 fs/binfmt_aout.c                    |    3 +
 fs/binfmt_elf.c                     |   30 ++++++++++---
 fs/exec.c                           |    3 -
 fs/proc/kcore.c                     |    1 
 include/asm-alpha/a.out-core.h      |   81 +++++++++++++++++++++++++++++++++++
 include/asm-alpha/a.out.h           |    8 ---
 include/asm-alpha/processor.h       |    5 ++
 include/asm-arm/a.out-core.h        |   49 +++++++++++++++++++++
 include/asm-arm/a.out.h             |    6 ---
 include/asm-arm/processor.h         |    6 +++
 include/asm-avr32/a.out.h           |    7 ---
 include/asm-avr32/processor.h       |    5 ++
 include/asm-blackfin/a.out.h        |    6 ---
 include/asm-blackfin/processor.h    |    4 ++
 include/asm-cris/a.out.h            |    6 ---
 include/asm-cris/processor.h        |    3 +
 include/asm-generic/Kbuild.asm      |    3 +
 include/asm-h8300/a.out.h           |    7 ---
 include/asm-h8300/processor.h       |    5 ++
 include/asm-ia64/a.out.h            |    3 -
 include/asm-m32r/a.out.h            |    7 ---
 include/asm-m32r/processor.h        |    5 ++
 include/asm-m68k/a.out-core.h       |   67 +++++++++++++++++++++++++++++
 include/asm-m68k/a.out.h            |    7 ---
 include/asm-m68k/processor.h        |    5 ++
 include/asm-mips/a.out.h            |   13 ------
 include/asm-mips/processor.h        |    7 +++
 include/asm-parisc/a.out.h          |   10 ----
 include/asm-parisc/processor.h      |   10 ++++
 include/asm-powerpc/a.out.h         |   19 --------
 include/asm-powerpc/processor.h     |   19 ++++++++
 include/asm-s390/a.out.h            |    7 ---
 include/asm-s390/processor.h        |    7 +++
 include/asm-sh/a.out.h              |    7 ---
 include/asm-sh/processor.h          |    7 +++
 include/asm-sh64/a.out.h            |    7 ---
 include/asm-sparc/a.out-core.h      |   52 ++++++++++++++++++++++
 include/asm-sparc/a.out.h           |    9 ----
 include/asm-sparc/processor.h       |    4 ++
 include/asm-sparc/uaccess.h         |    1 
 include/asm-sparc64/a.out-core.h    |   31 +++++++++++++
 include/asm-sparc64/a.out.h         |   12 -----
 include/asm-sparc64/processor.h     |   13 +++++-
 include/asm-sparc64/uaccess.h       |    1 
 include/asm-sparc64/user.h          |    2 -
 include/asm-um/a.out-core.h         |   27 ++++++++++++
 include/asm-um/a.out.h              |   13 ------
 include/asm-um/processor-generic.h  |    8 +++
 include/asm-x86/a.out-core.h        |   65 ++++++++++++++++++++++++++++
 include/asm-x86/a.out.h             |   10 ----
 include/asm-x86/processor_32.h      |    2 +
 include/asm-x86/processor_64.h      |    2 +
 include/asm-xtensa/a.out.h          |    5 --
 include/asm-xtensa/processor.h      |    2 +
 include/linux/Kbuild                |    3 +
 include/linux/a.out.h               |   17 +++++++
 include/linux/kernel.h              |    2 -
 82 files changed, 542 insertions(+), 488 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 6413c5f..c8cf2f9 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -22,7 +22,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/utsname.h>
 #include <linux/time.h>
 #include <linux/timex.h>
diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 92b6162..96ed82f 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -19,7 +19,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/utsname.h>
 #include <linux/time.h>
 #include <linux/major.h>
@@ -318,68 +317,6 @@ copy_thread(int nr, unsigned long clone_flags, unsigned long usp,
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
diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
index bd5e68c..c044db0 100644
--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -18,7 +18,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/screen_info.h>
 #include <linux/delay.h>
 #include <linux/mc146818rtc.h>
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 4f1a031..46bf2ed 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -18,7 +18,6 @@
 #include <linux/unistd.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/delay.h>
 #include <linux/reboot.h>
 #include <linux/interrupt.h>
@@ -368,35 +367,6 @@ int dump_fpu (struct pt_regs *regs, struct user_fp *fp)
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
index 9124467..8bf6b96 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -31,7 +31,6 @@
 #include <linux/smp_lock.h>
 #include <linux/unistd.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/uaccess.h>
 #include <linux/fs.h>
 #include <linux/err.h>
@@ -239,51 +238,6 @@ copy_thread(int nr, unsigned long clone_flags,
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
index 3ee9186..5de4e4e 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -23,7 +23,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/reboot.h>
 #include <linux/init_task.h>
 #include <linux/mqueue.h>
@@ -316,53 +315,6 @@ int dump_fpu (struct pt_regs *regs, struct user_m68kfp_struct *fpu)
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
diff --git a/arch/m68k/kernel/traps.c b/arch/m68k/kernel/traps.c
index 97f556f..fd4858e 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -23,7 +23,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/module.h>
-#include <linux/a.out.h>
 #include <linux/user.h>
 #include <linux/string.h>
 #include <linux/linkage.h>
diff --git a/arch/sparc/kernel/process.c b/arch/sparc/kernel/process.c
index 77460e3..19186ce 100644
--- a/arch/sparc/kernel/process.c
+++ b/arch/sparc/kernel/process.c
@@ -20,7 +20,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/smp.h>
 #include <linux/reboot.h>
 #include <linux/delay.h>
@@ -567,38 +566,6 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long sp,
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
diff --git a/arch/sparc/kernel/setup.c b/arch/sparc/kernel/setup.c
index f822838..dbd1f6d 100644
--- a/arch/sparc/kernel/setup.c
+++ b/arch/sparc/kernel/setup.c
@@ -16,7 +16,6 @@
 #include <linux/initrd.h>
 #include <asm/smp.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/screen_info.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
diff --git a/arch/sparc/kernel/sparc_ksyms.c b/arch/sparc/kernel/sparc_ksyms.c
index ef647ac..c1025e5 100644
--- a/arch/sparc/kernel/sparc_ksyms.c
+++ b/arch/sparc/kernel/sparc_ksyms.c
@@ -51,7 +51,6 @@
 #ifdef CONFIG_PCI
 #include <asm/ebus.h>
 #endif
-#include <asm/a.out.h>
 #include <asm/io-unit.h>
 #include <asm/bug.h>
 
@@ -214,8 +213,6 @@ EXPORT_SYMBOL(kunmap_atomic);
 EXPORT_SYMBOL(svr4_setcontext);
 EXPORT_SYMBOL(svr4_getcontext);
 
-EXPORT_SYMBOL(dump_thread);
-
 /* prom symbols */
 EXPORT_SYMBOL(idprom);
 EXPORT_SYMBOL(prom_root_node);
diff --git a/arch/sparc/mm/loadmmu.c b/arch/sparc/mm/loadmmu.c
index 36b4d24..2d9cd65 100644
--- a/arch/sparc/mm/loadmmu.c
+++ b/arch/sparc/mm/loadmmu.c
@@ -14,7 +14,6 @@
 #include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/a.out.h>
 #include <asm/mmu_context.h>
 #include <asm/oplib.h>
 
diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
index 17b485f..dc98e38 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -34,7 +34,6 @@
 #include <asm/sbus.h>
 #include <asm/asi.h>
 #include <asm/msi.h>
-#include <asm/a.out.h>
 #include <asm/mmu_context.h>
 #include <asm/io-unit.h>
 #include <asm/cacheflush.h>
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
diff --git a/arch/sparc64/kernel/binfmt_elf32.c b/arch/sparc64/kernel/binfmt_elf32.c
index 1587a29..bf635be 100644
--- a/arch/sparc64/kernel/binfmt_elf32.c
+++ b/arch/sparc64/kernel/binfmt_elf32.c
@@ -151,8 +151,6 @@ MODULE_AUTHOR("Eric Youngdale, David S. Miller, Jakub Jelinek");
 #undef MODULE_DESCRIPTION
 #undef MODULE_AUTHOR
 
-#include <asm/a.out.h>
-
 #undef TASK_SIZE
 #define TASK_SIZE STACK_TOP32
 
diff --git a/arch/sparc64/kernel/process.c b/arch/sparc64/kernel/process.c
index ca7cdfd..1b23791 100644
--- a/arch/sparc64/kernel/process.c
+++ b/arch/sparc64/kernel/process.c
@@ -24,7 +24,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/reboot.h>
 #include <linux/delay.h>
 #include <linux/compat.h>
@@ -725,17 +724,6 @@ pid_t kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
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
diff --git a/arch/sparc64/kernel/setup.c b/arch/sparc64/kernel/setup.c
index 0f5be82..94c5f8c 100644
--- a/arch/sparc64/kernel/setup.c
+++ b/arch/sparc64/kernel/setup.c
@@ -15,7 +15,6 @@
 #include <linux/slab.h>
 #include <asm/smp.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/screen_info.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
diff --git a/arch/sparc64/kernel/sparc64_ksyms.c b/arch/sparc64/kernel/sparc64_ksyms.c
index 60765e3..29a5af5 100644
--- a/arch/sparc64/kernel/sparc64_ksyms.c
+++ b/arch/sparc64/kernel/sparc64_ksyms.c
@@ -53,7 +53,6 @@
 #include <asm/ebus.h>
 #include <asm/isa.h>
 #endif
-#include <asm/a.out.h>
 #include <asm/ns87303.h>
 #include <asm/timer.h>
 #include <asm/cpudata.h>
diff --git a/arch/sparc64/kernel/sys_sparc.c b/arch/sparc64/kernel/sys_sparc.c
index c56573a..134d801 100644
--- a/arch/sparc64/kernel/sys_sparc.c
+++ b/arch/sparc64/kernel/sys_sparc.c
@@ -28,7 +28,6 @@
 #include <asm/uaccess.h>
 #include <asm/utrap.h>
 #include <asm/perfctr.h>
-#include <asm/a.out.h>
 #include <asm/unistd.h>
 
 /* #define DEBUG_UNIMP_SYSCALL */
diff --git a/arch/sparc64/kernel/sys_sparc32.c b/arch/sparc64/kernel/sys_sparc32.c
index 78caff9..d1f2a22 100644
--- a/arch/sparc64/kernel/sys_sparc32.c
+++ b/arch/sparc64/kernel/sys_sparc32.c
@@ -58,7 +58,6 @@
 #include <asm/fpumacro.h>
 #include <asm/semaphore.h>
 #include <asm/mmu_context.h>
-#include <asm/a.out.h>
 #include <asm/compat_signal.h>
 
 asmlinkage long sys32_chown16(const char __user * filename, u16 user, u16 group)
diff --git a/arch/um/kernel/ksyms.c b/arch/um/kernel/ksyms.c
index 1b388b4..9d5b64c 100644
--- a/arch/um/kernel/ksyms.c
+++ b/arch/um/kernel/ksyms.c
@@ -5,7 +5,6 @@
 
 #include "linux/module.h"
 #include "linux/syscalls.h"
-#include "asm/a.out.h"
 #include "asm/tlbflush.h"
 #include "asm/uaccess.h"
 #include "as-layout.h"
@@ -65,7 +64,6 @@ EXPORT_SYMBOL(os_accept_connection);
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
index 7b89958..7c4ceea 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -23,7 +23,6 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/interrupt.h>
 #include <linux/utsname.h>
 #include <linux/delay.h>
@@ -513,49 +512,6 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long esp,
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
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6309b27..2faae97 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -27,7 +27,6 @@
 #include <linux/slab.h>
 #include <linux/user.h>
 #include <linux/module.h>
-#include <linux/a.out.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/ptrace.h>
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 238633d..6a7c1d3 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -15,7 +15,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/screen_info.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
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
index ba8de7c..b734848 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -464,6 +464,7 @@ out:
 	return error;
 }
 
+#ifdef CONFIG_BINFMT_AOUT
 static unsigned long load_aout_interp(struct exec *interp_ex,
 		struct file *interpreter)
 {
@@ -509,6 +510,10 @@ static unsigned long load_aout_interp(struct exec *interp_ex,
 out:
 	return elf_entry;
 }
+#else
+extern unsigned long load_aout_interp(struct exec *interp_ex,
+				      struct file *interpreter);
+#endif
 
 /*
  * These are the functions used to load ELF style executables and shared
@@ -516,9 +521,15 @@ out:
  */
 
 #define INTERPRETER_NONE 0
-#define INTERPRETER_AOUT 1
 #define INTERPRETER_ELF 2
 
+#ifdef CONFIG_BINFMT_AOUT
+#define INTERPRETER_AOUT 1
+#define IS_AOUT_INTERP(x) ((x) == INTERPRETER_AOUT)
+#else
+#define IS_AOUT_INTERP(x) (0)
+#endif
+
 #ifndef STACK_RND_MASK
 #define STACK_RND_MASK (0x7ff >> (PAGE_SHIFT - 12))	/* 8MB of VA */
 #endif
@@ -734,6 +745,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	/* Some simple consistency checks for the interpreter */
 	if (elf_interpreter) {
 		static int warn;
+#ifdef CONFIG_BINFMT_AOUT
 		interpreter_type = INTERPRETER_ELF | INTERPRETER_AOUT;
 
 		/* Now figure out which format our binary is */
@@ -741,11 +753,13 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
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
@@ -774,7 +788,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 
 	/* OK, we are done with that, now set up the arg stuff,
 	   and then start this sucker up */
-	if ((!bprm->sh_bang) && (interpreter_type == INTERPRETER_AOUT)) {
+	if (IS_AOUT_INTERP(interpreter_type) && !bprm->sh_bang) {
 		char *passed_p = passed_fileno;
 		sprintf(passed_fileno, "%d", elf_exec_fileno);
 
@@ -961,7 +975,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	}
 
 	if (elf_interpreter) {
-		if (interpreter_type == INTERPRETER_AOUT)
+		if (IS_AOUT_INTERP(interpreter_type))
 			elf_entry = load_aout_interp(&loc->interp_ex,
 						     interpreter);
 		else
@@ -990,7 +1004,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 
 	kfree(elf_phdata);
 
-	if (interpreter_type != INTERPRETER_AOUT)
+	if (!IS_AOUT_INTERP(interpreter_type))
 		sys_close(elf_exec_fileno);
 
 	set_binfmt(&elf_format);
@@ -1006,14 +1020,14 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
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
index 2c942e2..aba5362 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -25,7 +25,6 @@
 #include <linux/slab.h>
 #include <linux/file.h>
 #include <linux/mman.h>
-#include <linux/a.out.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
 #include <linux/smp_lock.h>
@@ -1188,7 +1187,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 {
 	int try,retval;
 	struct linux_binfmt *fmt;
-#ifdef __alpha__
+#if defined(__alpha__) && defined(CONFIG_BINFMT_AOUT)
 	/* handle /sbin/loader.. */
 	{
 	    struct exec * eh = (struct exec *) bprm->buf;
diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 1be7308..916cfd9 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -12,7 +12,6 @@
 #include <linux/mm.h>
 #include <linux/proc_fs.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/capability.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
diff --git a/include/asm-alpha/a.out-core.h b/include/asm-alpha/a.out-core.h
new file mode 100644
index 0000000..573def2
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
+	struct switch_stack * sw = ((struct switch_stack *) pt) - 1;
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
diff --git a/include/asm-alpha/a.out.h b/include/asm-alpha/a.out.h
index e43cf61..02ce847 100644
--- a/include/asm-alpha/a.out.h
+++ b/include/asm-alpha/a.out.h
@@ -98,11 +98,5 @@ struct exec
 	set_personality (((BFPM->sh_bang || EX.ah.entry < 0x100000000L \
 			   ? ADDR_LIMIT_32BIT : 0) | PER_OSF4))
 
-#define STACK_TOP \
-  (current->personality & ADDR_LIMIT_32BIT ? 0x80000000 : 0x00120000000UL)
-
-#define STACK_TOP_MAX	0x00120000000UL
-
-#endif
-
+#endif /* __KERNEL__ */
 #endif /* __A_OUT_GNU_H__ */
diff --git a/include/asm-alpha/processor.h b/include/asm-alpha/processor.h
index 425b7b6..94afe58 100644
--- a/include/asm-alpha/processor.h
+++ b/include/asm-alpha/processor.h
@@ -20,6 +20,11 @@
  */
 #define TASK_SIZE (0x40000000000UL)
 
+#define STACK_TOP \
+  (current->personality & ADDR_LIMIT_32BIT ? 0x80000000 : 0x00120000000UL)
+
+#define STACK_TOP_MAX	0x00120000000UL
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff --git a/include/asm-arm/a.out-core.h b/include/asm-arm/a.out-core.h
new file mode 100644
index 0000000..93d04ac
--- /dev/null
+++ b/include/asm-arm/a.out-core.h
@@ -0,0 +1,49 @@
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
+	dump->u_dsize = (tsk->mm->brk - tsk->mm->start_data + PAGE_SIZE - 1) >> PAGE_SHIFT;
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
+	dump->u_fpvalid = dump_fpu (regs, &dump->u_fp);
+}
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_A_OUT_CORE_H */
diff --git a/include/asm-arm/a.out.h b/include/asm-arm/a.out.h
index d7165e8..79489fd 100644
--- a/include/asm-arm/a.out.h
+++ b/include/asm-arm/a.out.h
@@ -27,12 +27,6 @@ struct exec
 
 #define M_ARM 103
 
-#ifdef __KERNEL__
-#define STACK_TOP	((current->personality == PER_LINUX_32BIT) ? \
-			 TASK_SIZE : TASK_SIZE_26)
-#define STACK_TOP_MAX	TASK_SIZE
-#endif
-
 #ifndef LIBRARY_START_TEXT
 #define LIBRARY_START_TEXT	(0x00c00000)
 #endif
diff --git a/include/asm-arm/processor.h b/include/asm-arm/processor.h
index 1bbf161..bd8029e 100644
--- a/include/asm-arm/processor.h
+++ b/include/asm-arm/processor.h
@@ -22,6 +22,12 @@
 #include <asm/ptrace.h>
 #include <asm/types.h>
 
+#ifdef __KERNEL__
+#define STACK_TOP	((current->personality == PER_LINUX_32BIT) ? \
+			 TASK_SIZE : TASK_SIZE_26)
+#define STACK_TOP_MAX	TASK_SIZE
+#endif
+
 union debug_insn {
 	u32	arm;
 	u16	thumb;
diff --git a/include/asm-avr32/a.out.h b/include/asm-avr32/a.out.h
index 9f398ab..e46375a 100644
--- a/include/asm-avr32/a.out.h
+++ b/include/asm-avr32/a.out.h
@@ -17,11 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* __ASM_AVR32_A_OUT_H */
diff --git a/include/asm-avr32/processor.h b/include/asm-avr32/processor.h
index 6a64833..545520e 100644
--- a/include/asm-avr32/processor.h
+++ b/include/asm-avr32/processor.h
@@ -13,6 +13,11 @@
 
 #define TASK_SIZE	0x80000000
 
+#ifdef __KERNEL__
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+#endif
+
 #ifndef __ASSEMBLY__
 
 static inline void *current_text_addr(void)
diff --git a/include/asm-blackfin/a.out.h b/include/asm-blackfin/a.out.h
index d37a684..6c3d652 100644
--- a/include/asm-blackfin/a.out.h
+++ b/include/asm-blackfin/a.out.h
@@ -16,10 +16,4 @@ struct exec {
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-
-#endif
-
 #endif				/* __BFIN_A_OUT_H__ */
diff --git a/include/asm-blackfin/processor.h b/include/asm-blackfin/processor.h
index c571e95..1033e5c 100644
--- a/include/asm-blackfin/processor.h
+++ b/include/asm-blackfin/processor.h
@@ -30,6 +30,10 @@ static inline void wrusp(unsigned long usp)
 extern unsigned long memory_end;
 #define TASK_SIZE	(memory_end)
 
+#ifdef __KERNEL__
+#define STACK_TOP	TASK_SIZE
+#endif
+
 #define TASK_UNMAPPED_BASE	0
 
 struct thread_struct {
diff --git a/include/asm-cris/a.out.h b/include/asm-cris/a.out.h
index 919b34a..c82e9f9 100644
--- a/include/asm-cris/a.out.h
+++ b/include/asm-cris/a.out.h
@@ -6,11 +6,6 @@
  * wants to know about a.out even if there is no interpreter available...
  */
 
-/* grabbed from the intel stuff  */   
-#define STACK_TOP TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-
 struct exec
 {
   unsigned long a_info;		/* Use macros N_MAGIC, etc for access */
@@ -28,5 +23,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-
 #endif
diff --git a/include/asm-cris/processor.h b/include/asm-cris/processor.h
index 568da1d..cdc0c1d 100644
--- a/include/asm-cris/processor.h
+++ b/include/asm-cris/processor.h
@@ -17,6 +17,9 @@
 
 struct task_struct;
 
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff --git a/include/asm-generic/Kbuild.asm b/include/asm-generic/Kbuild.asm
index 8fd8171..d99b89f 100644
--- a/include/asm-generic/Kbuild.asm
+++ b/include/asm-generic/Kbuild.asm
@@ -1,4 +1,7 @@
+# -*- makefile -*-
+ifeq ($(wildcard include/asm-$(SRCARCH)/a.out.h),include/asm-$(SRCARCH)/a.out.h)
 unifdef-y += a.out.h
+endif
 unifdef-y += auxvec.h
 unifdef-y += byteorder.h
 unifdef-y += errno.h
diff --git a/include/asm-h8300/a.out.h b/include/asm-h8300/a.out.h
index aa5d227..ded780f 100644
--- a/include/asm-h8300/a.out.h
+++ b/include/asm-h8300/a.out.h
@@ -17,11 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* __H8300_A_OUT_H__ */
diff --git a/include/asm-h8300/processor.h b/include/asm-h8300/processor.h
index 49fc886..69e8a34 100644
--- a/include/asm-h8300/processor.h
+++ b/include/asm-h8300/processor.h
@@ -39,6 +39,11 @@ static inline void wrusp(unsigned long usp) {
  */
 #define TASK_SIZE	(0xFFFFFFFFUL)
 
+#ifdef __KERNEL__
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+#endif
+
 /*
  * This decides where the kernel will search for a free chunk of vm
  * space during mmap's. We won't be using it
diff --git a/include/asm-ia64/a.out.h b/include/asm-ia64/a.out.h
index 7293ac1..193dcfb 100644
--- a/include/asm-ia64/a.out.h
+++ b/include/asm-ia64/a.out.h
@@ -29,7 +29,4 @@ struct exec {
 #define N_SYMSIZE(x)	0
 #define N_TXTOFF(x)	0
 
-#ifdef __KERNEL__
-#include <asm/ustack.h>
-#endif
 #endif /* _ASM_IA64_A_OUT_H */
diff --git a/include/asm-m32r/a.out.h b/include/asm-m32r/a.out.h
index 6a1b5d4..ab150f5 100644
--- a/include/asm-m32r/a.out.h
+++ b/include/asm-m32r/a.out.h
@@ -17,11 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* _ASM_M32R_A_OUT_H */
diff --git a/include/asm-m32r/processor.h b/include/asm-m32r/processor.h
index 32755bf..1a997fc 100644
--- a/include/asm-m32r/processor.h
+++ b/include/asm-m32r/processor.h
@@ -60,6 +60,11 @@ extern struct cpuinfo_m32r cpu_data[];
 #define TASK_SIZE  (0x00400000UL)
 #endif
 
+#ifdef __KERNEL__
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+#endif
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff --git a/include/asm-m68k/a.out-core.h b/include/asm-m68k/a.out-core.h
new file mode 100644
index 0000000..b4dafe7
--- /dev/null
+++ b/include/asm-m68k/a.out-core.h
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
+/* changed the size calculations - should hopefully work better. lbt */
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
+		dump->u_ssize = ((unsigned long) (TASK_SIZE - dump->start_stack)) >> PAGE_SHIFT;
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
+	dump->u_fpvalid = dump_fpu (regs, &dump->m68kfp);
+}
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_A_OUT_CORE_H */
diff --git a/include/asm-m68k/a.out.h b/include/asm-m68k/a.out.h
index 6fc86a2..3885fe4 100644
--- a/include/asm-m68k/a.out.h
+++ b/include/asm-m68k/a.out.h
@@ -17,11 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* __M68K_A_OUT_H__ */
diff --git a/include/asm-m68k/processor.h b/include/asm-m68k/processor.h
index 4453ec3..1f61ef5 100644
--- a/include/asm-m68k/processor.h
+++ b/include/asm-m68k/processor.h
@@ -41,6 +41,11 @@ static inline void wrusp(unsigned long usp)
 #define TASK_SIZE	(0x0E000000UL)
 #endif
 
+#ifdef __KERNEL__
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+#endif
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff --git a/include/asm-mips/a.out.h b/include/asm-mips/a.out.h
index bf55a5b..cad8371 100644
--- a/include/asm-mips/a.out.h
+++ b/include/asm-mips/a.out.h
@@ -32,17 +32,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#ifdef CONFIG_32BIT
-#define STACK_TOP	TASK_SIZE
-#endif
-#ifdef CONFIG_64BIT
-#define STACK_TOP	\
-      (test_thread_flag(TIF_32BIT_ADDR) ? TASK_SIZE32 : TASK_SIZE)
-#endif
-#define STACK_TOP_MAX	TASK_SIZE
-
-#endif
-
 #endif /* _ASM_A_OUT_H */
diff --git a/include/asm-mips/processor.h b/include/asm-mips/processor.h
index 83bc945..612f99e 100644
--- a/include/asm-mips/processor.h
+++ b/include/asm-mips/processor.h
@@ -39,6 +39,7 @@ extern unsigned int vced_count, vcei_count;
  * so don't change it unless you know what you are doing.
  */
 #define TASK_SIZE	0x7fff8000UL
+#define STACK_TOP	TASK_SIZE
 
 /*
  * This decides where the kernel will search for a free chunk of vm
@@ -57,6 +58,8 @@ extern unsigned int vced_count, vcei_count;
  */
 #define TASK_SIZE32	0x7fff8000UL
 #define TASK_SIZE	0x10000000000UL
+#define STACK_TOP	\
+      (test_thread_flag(TIF_32BIT_ADDR) ? TASK_SIZE32 : TASK_SIZE)
 
 /*
  * This decides where the kernel will search for a free chunk of vm
@@ -67,6 +70,10 @@ extern unsigned int vced_count, vcei_count;
 		PAGE_ALIGN(TASK_SIZE32 / 3) : PAGE_ALIGN(TASK_SIZE / 3))
 #endif
 
+#ifdef __KERNEL__
+#define STACK_TOP_MAX	TASK_SIZE
+#endif
+
 #define NUM_FPU_REGS	32
 
 typedef __u64 fpureg_t;
diff --git a/include/asm-parisc/a.out.h b/include/asm-parisc/a.out.h
index 23e2c90..eb04e34 100644
--- a/include/asm-parisc/a.out.h
+++ b/include/asm-parisc/a.out.h
@@ -17,14 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-/* XXX: STACK_TOP actually should be STACK_BOTTOM for parisc.
- * prumpf */
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	DEFAULT_TASK_SIZE
-
-#endif
-
 #endif /* __A_OUT_GNU_H__ */
diff --git a/include/asm-parisc/processor.h b/include/asm-parisc/processor.h
index 6b294fb..802c86c 100644
--- a/include/asm-parisc/processor.h
+++ b/include/asm-parisc/processor.h
@@ -46,6 +46,16 @@
 #define DEFAULT_MAP_BASE	DEFAULT_MAP_BASE32
 #endif
 
+#ifdef __KERNEL__
+
+/* XXX: STACK_TOP actually should be STACK_BOTTOM for parisc.
+ * prumpf */
+
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	DEFAULT_TASK_SIZE
+
+#endif
+
 #ifndef __ASSEMBLY__
 
 /*
diff --git a/include/asm-powerpc/a.out.h b/include/asm-powerpc/a.out.h
index 5c5ea83..89cead6 100644
--- a/include/asm-powerpc/a.out.h
+++ b/include/asm-powerpc/a.out.h
@@ -17,23 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-#ifdef __powerpc64__
-
-#define STACK_TOP_USER64 TASK_SIZE_USER64
-#define STACK_TOP_USER32 TASK_SIZE_USER32
-
-#define STACK_TOP (test_thread_flag(TIF_32BIT) ? \
-		   STACK_TOP_USER32 : STACK_TOP_USER64)
-
-#define STACK_TOP_MAX STACK_TOP_USER64
-
-#else /* __powerpc64__ */
-
-#define STACK_TOP TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif /* __powerpc64__ */
-#endif /* __KERNEL__ */
-
 #endif /* _ASM_POWERPC_A_OUT_H */
diff --git a/include/asm-powerpc/processor.h b/include/asm-powerpc/processor.h
index dba7c94..a16d4a2 100644
--- a/include/asm-powerpc/processor.h
+++ b/include/asm-powerpc/processor.h
@@ -112,6 +112,25 @@ extern struct task_struct *last_task_used_spe;
 		TASK_UNMAPPED_BASE_USER32 : TASK_UNMAPPED_BASE_USER64 )
 #endif
 
+#ifdef __KERNEL__
+#ifdef __powerpc64__
+
+#define STACK_TOP_USER64 TASK_SIZE_USER64
+#define STACK_TOP_USER32 TASK_SIZE_USER32
+
+#define STACK_TOP (test_thread_flag(TIF_32BIT) ? \
+		   STACK_TOP_USER32 : STACK_TOP_USER64)
+
+#define STACK_TOP_MAX STACK_TOP_USER64
+
+#else /* __powerpc64__ */
+
+#define STACK_TOP TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+
+#endif /* __powerpc64__ */
+#endif /* __KERNEL__ */
+
 typedef struct {
 	unsigned long seg;
 } mm_segment_t;
diff --git a/include/asm-s390/a.out.h b/include/asm-s390/a.out.h
index 46158dc..8d6bd9c 100644
--- a/include/asm-s390/a.out.h
+++ b/include/asm-s390/a.out.h
@@ -29,11 +29,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	DEFAULT_TASK_SIZE
-
-#endif
-
 #endif /* __A_OUT_GNU_H__ */
diff --git a/include/asm-s390/processor.h b/include/asm-s390/processor.h
index 21d40a1..3ade4c4 100644
--- a/include/asm-s390/processor.h
+++ b/include/asm-s390/processor.h
@@ -80,6 +80,13 @@ extern struct task_struct *last_task_used_math;
 
 #endif /* __s390x__ */
 
+#ifdef __KERNEL__
+
+#define STACK_TOP		TASK_SIZE
+#define STACK_TOP_MAX		DEFAULT_TASK_SIZE
+
+#endif
+
 #define HAVE_ARCH_PICK_MMAP_LAYOUT
 
 typedef struct {
diff --git a/include/asm-sh/a.out.h b/include/asm-sh/a.out.h
index 685d0f6..1f93130 100644
--- a/include/asm-sh/a.out.h
+++ b/include/asm-sh/a.out.h
@@ -17,11 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* __ASM_SH_A_OUT_H */
diff --git a/include/asm-sh/processor.h b/include/asm-sh/processor.h
index ab0028d..97e77d9 100644
--- a/include/asm-sh/processor.h
+++ b/include/asm-sh/processor.h
@@ -85,6 +85,13 @@ extern struct sh_cpuinfo cpu_data[];
  */
 #define TASK_SIZE	0x7c000000UL
 
+#ifdef __KERNEL__
+
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+
+#endif
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff --git a/include/asm-sh64/a.out.h b/include/asm-sh64/a.out.h
index 237ee4e..c55b85b 100644
--- a/include/asm-sh64/a.out.h
+++ b/include/asm-sh64/a.out.h
@@ -28,11 +28,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* __ASM_SH64_A_OUT_H */
diff --git a/include/asm-sparc/a.out-core.h b/include/asm-sparc/a.out-core.h
new file mode 100644
index 0000000..e8fd338
--- /dev/null
+++ b/include/asm-sparc/a.out-core.h
@@ -0,0 +1,52 @@
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
+	memcpy(&dump->regs.regs[0], &regs->u_regs[1], (sizeof(unsigned long) * 15));
+	dump->uexec = current->thread.core_exec;
+	dump->u_tsize = (((unsigned long) current->mm->end_code) -
+		((unsigned long) current->mm->start_code)) & ~(PAGE_SIZE - 1);
+	dump->u_dsize = ((unsigned long) (current->mm->brk + (PAGE_SIZE-1)));
+	dump->u_dsize -= dump->u_tsize;
+	dump->u_dsize &= ~(PAGE_SIZE - 1);
+	first_stack_page = (regs->u_regs[UREG_FP] & ~(PAGE_SIZE - 1));
+	dump->u_ssize = (TASK_SIZE - first_stack_page) & ~(PAGE_SIZE - 1);
+	memcpy(&dump->fpu.fpstatus.fregs.regs[0], &current->thread.float_regs[0], (sizeof(unsigned long) * 32));
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
diff --git a/include/asm-sparc/a.out.h b/include/asm-sparc/a.out.h
index 917e042..744cfe6 100644
--- a/include/asm-sparc/a.out.h
+++ b/include/asm-sparc/a.out.h
@@ -87,13 +87,4 @@ struct relocation_info /* used when header.a_machtype == M_SPARC */
 
 #define N_RELOCATION_INFO_DECLARED 1
 
-#ifdef __KERNEL__
-
-#include <asm/page.h>
-
-#define STACK_TOP	(PAGE_OFFSET - PAGE_SIZE)
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif /* __KERNEL__ */
-
 #endif /* __SPARC_A_OUT_H__ */
diff --git a/include/asm-sparc/processor.h b/include/asm-sparc/processor.h
index 6fbb3f0..40b1e41 100644
--- a/include/asm-sparc/processor.h
+++ b/include/asm-sparc/processor.h
@@ -33,6 +33,10 @@
  * we can make our access_ok test faster
  */
 #define TASK_SIZE	PAGE_OFFSET
+#ifdef __KERNEL__
+#define STACK_TOP	(PAGE_OFFSET - PAGE_SIZE)
+#define STACK_TOP_MAX	STACK_TOP
+#endif /* __KERNEL__ */
 
 struct task_struct;
 
diff --git a/include/asm-sparc/uaccess.h b/include/asm-sparc/uaccess.h
index 3cf132e..366b116 100644
--- a/include/asm-sparc/uaccess.h
+++ b/include/asm-sparc/uaccess.h
@@ -13,7 +13,6 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <asm/vac-ops.h>
-#include <asm/a.out.h>
 #endif
 
 #ifndef __ASSEMBLY__
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
diff --git a/include/asm-sparc64/a.out.h b/include/asm-sparc64/a.out.h
index 902e07f..53c95bd 100644
--- a/include/asm-sparc64/a.out.h
+++ b/include/asm-sparc64/a.out.h
@@ -93,18 +93,6 @@ struct relocation_info /* used when header.a_machtype == M_SPARC */
 
 #define N_RELOCATION_INFO_DECLARED 1
 
-#ifdef __KERNEL__
-
-#define STACK_TOP32	((1UL << 32UL) - PAGE_SIZE)
-#define STACK_TOP64	(0x0000080000000000UL - (1UL << 32UL))
-
-#define STACK_TOP (test_thread_flag(TIF_32BIT) ? \
-		   STACK_TOP32 : STACK_TOP64)
-
-#define STACK_TOP_MAX STACK_TOP64
-
-#endif
-
 #endif /* !(__ASSEMBLY__) */
 
 #endif /* !(__SPARC64_A_OUT_H__) */
diff --git a/include/asm-sparc64/processor.h b/include/asm-sparc64/processor.h
index 66dd2fa..8da484c 100644
--- a/include/asm-sparc64/processor.h
+++ b/include/asm-sparc64/processor.h
@@ -14,7 +14,6 @@
 #define current_text_addr() ({ void *pc; __asm__("rd %%pc, %0" : "=r" (pc)); pc; })
 
 #include <asm/asi.h>
-#include <asm/a.out.h>
 #include <asm/pstate.h>
 #include <asm/ptrace.h>
 #include <asm/page.h>
@@ -36,7 +35,19 @@
 #else
 #define VPTE_SIZE	(1 << (VA_BITS - PAGE_SHIFT + 3))
 #endif
+
 #define TASK_SIZE	((unsigned long)-VPTE_SIZE)
+#ifdef __KERNEL__
+
+#define STACK_TOP32	((1UL << 32UL) - PAGE_SIZE)
+#define STACK_TOP64	(0x0000080000000000UL - (1UL << 32UL))
+
+#define STACK_TOP	(test_thread_flag(TIF_32BIT) ? \
+			 STACK_TOP32 : STACK_TOP64)
+
+#define STACK_TOP_MAX	STACK_TOP64
+
+#endif
 
 #ifndef __ASSEMBLY__
 
diff --git a/include/asm-sparc64/uaccess.h b/include/asm-sparc64/uaccess.h
index 93720e7..d8547b8 100644
--- a/include/asm-sparc64/uaccess.h
+++ b/include/asm-sparc64/uaccess.h
@@ -10,7 +10,6 @@
 #include <linux/compiler.h>
 #include <linux/sched.h>
 #include <linux/string.h>
-#include <asm/a.out.h>
 #include <asm/asi.h>
 #include <asm/system.h>
 #include <asm/spitfire.h>
diff --git a/include/asm-sparc64/user.h b/include/asm-sparc64/user.h
index fce4e85..02b1389 100644
--- a/include/asm-sparc64/user.h
+++ b/include/asm-sparc64/user.h
@@ -8,7 +8,7 @@
 #ifndef _SPARC64_USER_H
 #define _SPARC64_USER_H
 
-#include <asm/a.out.h>
+#include <linux/a.out.h>
 struct sunos_regs {
 	unsigned int psr, pc, npc, y;
 	unsigned int regs[15];
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
diff --git a/include/asm-um/a.out.h b/include/asm-um/a.out.h
index 9281dd8..754181e 100644
--- a/include/asm-um/a.out.h
+++ b/include/asm-um/a.out.h
@@ -8,17 +8,4 @@
 
 #include "asm/arch/a.out.h"
 
-#undef STACK_TOP
-#undef STACK_TOP_MAX
-
-extern unsigned long stacksizelim;
-
-extern unsigned long host_task_size;
-
-#define STACK_ROOM (stacksizelim)
-
-#define STACK_TOP task_size
-
-#define STACK_TOP_MAX STACK_TOP
-
 #endif
diff --git a/include/asm-um/processor-generic.h b/include/asm-um/processor-generic.h
index 78c0599..4b4bb18 100644
--- a/include/asm-um/processor-generic.h
+++ b/include/asm-um/processor-generic.h
@@ -98,9 +98,17 @@ static inline void mm_copy_segments(struct mm_struct *from_mm,
  * User space process size: 3GB (default).
  */
 extern unsigned long task_size;
+extern unsigned long stacksizelim;
+extern unsigned long host_task_size;
 
 #define TASK_SIZE	(task_size)
 
+#undef STACK_TOP
+#undef STACK_TOP_MAX
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+#define STACK_ROOM	(stacksizelim)
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff --git a/include/asm-x86/a.out-core.h b/include/asm-x86/a.out-core.h
new file mode 100644
index 0000000..e0d6fa5
--- /dev/null
+++ b/include/asm-x86/a.out-core.h
@@ -0,0 +1,65 @@
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
+	dump->u_dsize = ((unsigned long) (current->mm->brk + (PAGE_SIZE-1))) >> PAGE_SHIFT;
+	dump->u_dsize -= dump->u_tsize;
+	dump->u_ssize = 0;
+	for (i = 0; i < 8; i++)
+		dump->u_debugreg[i] = current->thread.debugreg[i];  
+
+	if (dump->start_stack < TASK_SIZE)
+		dump->u_ssize = ((unsigned long) (TASK_SIZE - dump->start_stack)) >> PAGE_SHIFT;
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
+	savesegment(gs,dump->regs.gs);
+	dump->regs.orig_eax = regs->orig_eax;
+	dump->regs.eip = regs->eip;
+	dump->regs.cs = regs->xcs;
+	dump->regs.eflags = regs->eflags;
+	dump->regs.esp = regs->esp;
+	dump->regs.ss = regs->xss;
+
+	dump->u_fpvalid = dump_fpu (regs, &dump->i387);
+}
+
+#endif /* CONFIG_X86_32 */
+#endif /* __KERNEL__ */
+#endif /* _ASM_A_OUT_CORE_H */
diff --git a/include/asm-x86/a.out.h b/include/asm-x86/a.out.h
index a62443e..4684f97 100644
--- a/include/asm-x86/a.out.h
+++ b/include/asm-x86/a.out.h
@@ -17,14 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-# include <linux/thread_info.h>
-# define STACK_TOP	TASK_SIZE
-# ifdef CONFIG_X86_32
-#  define STACK_TOP_MAX	STACK_TOP
-# else
-#  define STACK_TOP_MAX	TASK_SIZE64
-# endif
-#endif
-
 #endif /* _ASM_X86_A_OUT_H */
diff --git a/include/asm-x86/processor_32.h b/include/asm-x86/processor_32.h
index 13976b0..7976787 100644
--- a/include/asm-x86/processor_32.h
+++ b/include/asm-x86/processor_32.h
@@ -214,6 +214,8 @@ extern int bootloader_type;
  * User space process size: 3GB (default).
  */
 #define TASK_SIZE	(PAGE_OFFSET)
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
 
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
diff --git a/include/asm-x86/processor_64.h b/include/asm-x86/processor_64.h
index e4f1997..6b9b33f 100644
--- a/include/asm-x86/processor_64.h
+++ b/include/asm-x86/processor_64.h
@@ -148,6 +148,8 @@ static inline void clear_in_cr4 (unsigned long mask)
 #define TASK_SIZE_OF(child) 	((test_tsk_thread_flag(child, TIF_IA32)) ? IA32_PAGE_OFFSET : TASK_SIZE64)
 
 #define TASK_UNMAPPED_BASE	PAGE_ALIGN(TASK_SIZE/3)
+#define STACK_TOP		TASK_SIZE
+#define STACK_TOP_MAX		TASK_SIZE64
 
 /*
  * Size of io_bitmap.
diff --git a/include/asm-xtensa/a.out.h b/include/asm-xtensa/a.out.h
index 05a2f67..fdf1370 100644
--- a/include/asm-xtensa/a.out.h
+++ b/include/asm-xtensa/a.out.h
@@ -14,11 +14,6 @@
 #ifndef _XTENSA_A_OUT_H
 #define _XTENSA_A_OUT_H
 
-/* Note: the kernel needs the a.out definitions, even if only ELF is used. */
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
 struct exec
 {
   unsigned long a_info;
diff --git a/include/asm-xtensa/processor.h b/include/asm-xtensa/processor.h
index 35145bc..96408f4 100644
--- a/include/asm-xtensa/processor.h
+++ b/include/asm-xtensa/processor.h
@@ -34,6 +34,8 @@
  */
 
 #define TASK_SIZE	__XTENSA_UL_CONST(0x40000000)
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
 
 /*
  * General exception cause assigned to debug exceptions. Debug exceptions go
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 37bfa19..e7e0964 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -1,3 +1,4 @@
+# -*- makefile -*-
 header-y += byteorder/
 header-y += dvb/
 header-y += hdlc/
@@ -17,7 +18,9 @@ header-y += usb/
 
 header-y += affs_hardblocks.h
 header-y += aio_abi.h
+ifeq ($(wildcard include/asm-$(SRCARCH)/a.out.h),include/asm-$(SRCARCH)/a.out.h)
 header-y += a.out.h
+endif
 header-y += arcfb.h
 header-y += atmapi.h
 header-y += atmbr2684.h
diff --git a/include/linux/a.out.h b/include/linux/a.out.h
index f913cc3..faf6786 100644
--- a/include/linux/a.out.h
+++ b/include/linux/a.out.h
@@ -1,6 +1,13 @@
 #ifndef __A_OUT_GNU_H__
 #define __A_OUT_GNU_H__
 
+#if defined(CONFIG_BINFMT_AOUT) || \
+	defined(CONFIG_BINFMT_AOUT_MODULE) || \
+	defined(CONFIG_IA32_AOUT) || \
+	defined(CONFIG_IA32_AOUT_MODULE) ||\
+	defined(CONFIG_BINFMT_AOUT32) || \
+	defined(CONFIG_BINFMT_AOUT32_MODULE)
+
 #define __GNU_EXEC_MACROS__
 
 #ifndef __STRUCT_EXEC_OVERRIDE__
@@ -9,6 +16,8 @@
 
 #endif /* __STRUCT_EXEC_OVERRIDE__ */
 
+#ifndef __ASSEMBLY__
+
 /* these go in the N_MACHTYPE field */
 enum machine_type {
 #if defined (M_OLDSUN2)
@@ -264,5 +273,11 @@ struct relocation_info
 };
 #endif /* no N_RELOCATION_INFO_DECLARED.  */
 
-
+#endif /*__ASSEMBLY__ */
+#else /* CONFIG_BINFMT_AOUT||CONFIG_IA32_AOUT */
+#ifndef __ASSEMBLY__
+struct exec {
+};
+#endif
+#endif /* CONFIG_BINFMT_AOUT||CONFIG_IA32_AOUT */
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

