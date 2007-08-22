Return-Path: <linux-kernel-owner+w=401wt.eu-S934038AbXHVV0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038AbXHVV0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933705AbXHVVZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:25:49 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:50987 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933563AbXHVVZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:25:47 -0400
Date: Wed, 22 Aug 2007 17:25:30 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       vberk@ists.dartmouth.edu,
       Alberto Pires de Oliveira Neto <apon1@terra.com.br>
Subject: [PATCH 2/2] UML - Fix x86_64 core dump crash
Message-ID: <20070822212530.GA14478@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop UML crashing when trying to dump a process core on x86_64.  This
is the minimal fix to stop the crash - more things are broken here,
and patches are forthcoming.

The immediate thing to do is define ELF_CORE_COPY_REGS and
ELF_CORE_COPY_FPREGS.  Defining ELF_CORE_COPY_FPREGS allows dump_fpu
to go away.  It is defined in terms of save_fp_registers, so that
needs to be added.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/os-Linux/sys-x86_64/registers.c |   16 ++++++++++++
 arch/um/sys-x86_64/ptrace.c             |    6 ----
 include/asm-um/elf-x86_64.h             |   40 ++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 6 deletions(-)

Index: linux-2.6.22/include/asm-um/elf-x86_64.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/elf-x86_64.h	2007-08-22 16:55:38.000000000 -0400
+++ linux-2.6.22/include/asm-um/elf-x86_64.h	2007-08-22 16:56:20.000000000 -0400
@@ -6,7 +6,9 @@
 #ifndef __UM_ELF_X86_64_H
 #define __UM_ELF_X86_64_H
 
+#include <linux/sched.h>
 #include <asm/user.h>
+#include "skas.h"
 
 /* x86-64 relocation types, taken from asm-x86_64/elf.h */
 #define R_X86_64_NONE		0	/* No reloc */
@@ -64,6 +66,44 @@ typedef struct { } elf_fpregset_t;
 	PT_REGS_R15(regs) = 0; \
 } while (0)
 
+#define ELF_CORE_COPY_REGS(pr_reg, regs)		\
+	(pr_reg)[0] = (regs)->regs.gp[0];			\
+	(pr_reg)[1] = (regs)->regs.gp[1];			\
+	(pr_reg)[2] = (regs)->regs.gp[2];			\
+	(pr_reg)[3] = (regs)->regs.gp[3];			\
+	(pr_reg)[4] = (regs)->regs.gp[4];			\
+	(pr_reg)[5] = (regs)->regs.gp[5];			\
+	(pr_reg)[6] = (regs)->regs.gp[6];			\
+	(pr_reg)[7] = (regs)->regs.gp[7];			\
+	(pr_reg)[8] = (regs)->regs.gp[8];			\
+	(pr_reg)[9] = (regs)->regs.gp[9];			\
+	(pr_reg)[10] = (regs)->regs.gp[10];			\
+	(pr_reg)[11] = (regs)->regs.gp[11];			\
+	(pr_reg)[12] = (regs)->regs.gp[12];			\
+	(pr_reg)[13] = (regs)->regs.gp[13];			\
+	(pr_reg)[14] = (regs)->regs.gp[14];			\
+	(pr_reg)[15] = (regs)->regs.gp[15];			\
+	(pr_reg)[16] = (regs)->regs.gp[16];			\
+	(pr_reg)[17] = (regs)->regs.gp[17];			\
+	(pr_reg)[18] = (regs)->regs.gp[18];			\
+	(pr_reg)[19] = (regs)->regs.gp[19];			\
+	(pr_reg)[20] = (regs)->regs.gp[20];			\
+	(pr_reg)[21] = current->thread.arch.fs;			\
+	(pr_reg)[22] = 0;					\
+	(pr_reg)[23] = 0;					\
+	(pr_reg)[24] = 0;					\
+	(pr_reg)[25] = 0;					\
+	(pr_reg)[26] = 0;
+
+static inline int elf_core_copy_fpregs(struct task_struct *t,
+				       elf_fpregset_t *fpu)
+{
+	int cpu = current_thread->cpu;
+	return save_fp_registers(userspace_pid[cpu], (unsigned long *) fpu);
+}
+
+#define ELF_CORE_COPY_FPREGS(t, fpu) elf_core_copy_fpregs(t, fpu)
+
 #ifdef TIF_IA32 /* XXX */
 #error XXX, indeed
         clear_thread_flag(TIF_IA32);
Index: linux-2.6.22/arch/um/os-Linux/sys-x86_64/registers.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/sys-x86_64/registers.c	2007-08-22 16:55:38.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/sys-x86_64/registers.c	2007-08-22 16:56:20.000000000 -0400
@@ -3,11 +3,27 @@
  * Licensed under the GPL
  */
 
+#include <errno.h>
+#include <sys/ptrace.h>
 #define __FRAME_OFFSETS
 #include <asm/ptrace.h>
 #include "longjmp.h"
 #include "user.h"
 
+int save_fp_registers(int pid, unsigned long *fp_regs)
+{
+	if(ptrace(PTRACE_GETFPREGS, pid, 0, fp_regs) < 0)
+		return -errno;
+	return 0;
+}
+
+int restore_fp_registers(int pid, unsigned long *fp_regs)
+{
+	if(ptrace(PTRACE_SETFPREGS, pid, 0, fp_regs) < 0)
+		return -errno;
+	return 0;
+}
+
 unsigned long get_thread_reg(int reg, jmp_buf *buf)
 {
 	switch(reg){
Index: linux-2.6.22/arch/um/sys-x86_64/ptrace.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-x86_64/ptrace.c	2007-08-22 16:55:38.000000000 -0400
+++ linux-2.6.22/arch/um/sys-x86_64/ptrace.c	2007-08-22 16:56:20.000000000 -0400
@@ -156,12 +156,6 @@ int is_syscall(unsigned long addr)
 	return(instr == 0x050f);
 }
 
-int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fpu )
-{
-	panic("dump_fpu");
-	return(1);
-}
-
 int get_fpregs(unsigned long buf, struct task_struct *child)
 {
 	panic("get_fpregs");
