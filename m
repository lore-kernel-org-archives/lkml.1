Return-Path: <linux-kernel-owner+w=401wt.eu-S1761370AbXLTMCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370AbXLTMCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760859AbXLTMA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:00:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758529AbXLTMAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:12 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 21/43] powerpc ptrace user_regset
Message-Id: <20071220115836.CC3B626F98A@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:58:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces all the code for powerpc PTRACE_*REGS* requests with
simple calls to copy_regset_from_user and copy_regset_to_user.  All
the ptrace formats are either the whole corresponding user_regset
format (core dump format) or a leading subset of it, so we can get
rid of all the remaining embedded knowledge of both those layouts
and of the internal data structures they correspond to.  Only the
user_reget accessors need to implement that.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/ptrace.c |  234 +++++++++++-------------------------------
 1 files changed, 59 insertions(+), 175 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 0231e7d..eb27bd9 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -237,24 +237,6 @@ static int fpr_set(struct task_struct *target, const struct user_regset *regset,
 				  &target->thread.fpr, 0, -1);
 }
 
-static int get_fpregs(void __user *data, struct task_struct *task,
-		      int has_fpscr)
-{
-	unsigned int count = has_fpscr ? 33 : 32;
-	if (!access_ok(VERIFY_WRITE, data, count * sizeof(double)))
-		return -EFAULT;
-	return fpr_get(task, NULL, 0, count * sizeof(double), NULL, data);
-}
-
-static int set_fpregs(void __user *data, struct task_struct *task,
-		      int has_fpscr)
-{
-	unsigned int count = has_fpscr ? 33 : 32;
-	if (!access_ok(VERIFY_READ, data, count * sizeof(double)))
-		return -EFAULT;
-	return fpr_set(task, NULL, 0, count * sizeof(double), NULL, data);
-}
-
 
 #ifdef CONFIG_ALTIVEC
 /*
@@ -339,31 +321,6 @@ static int vr_set(struct task_struct *target, const struct user_regset *regset,
 
 	return ret;
 }
-
-/*
- * Get contents of AltiVec register state in task TASK
- */
-static int get_vrregs(unsigned long __user *data, struct task_struct *task)
-{
-	if (!access_ok(VERIFY_WRITE, data,
-		       33 * sizeof(vector128) + sizeof(u32)))
-		return -EFAULT;
-
-	return vr_get(task, NULL, 0, 33 * sizeof(vector128) + sizeof(u32),
-		      NULL, data);
-}
-
-/*
- * Write contents of AltiVec register state into task TASK.
- */
-static int set_vrregs(struct task_struct *task, unsigned long __user *data)
-{
-	if (!access_ok(VERIFY_READ, data, 33 * sizeof(vector128) + sizeof(u32)))
-		return -EFAULT;
-
-	return vr_set(task, NULL, 0, 33 * sizeof(vector128) + sizeof(u32),
-		      NULL, data);
-}
 #endif /* CONFIG_ALTIVEC */
 
 #ifdef CONFIG_SPE
@@ -430,28 +387,6 @@ static int evr_set(struct task_struct *target, const struct user_regset *regset,
 
 	return ret;
 }
-
-/*
- * Get contents of SPE register state in task TASK.
- */
-static int get_evrregs(unsigned long __user *data, struct task_struct *task)
-{
-	if (!access_ok(VERIFY_WRITE, data, 35 * sizeof(u32)))
-		return -EFAULT;
-
-	return evr_get(task, NULL, 0, 35 * sizeof(u32), NULL, data);
-}
-
-/*
- * Write contents of SPE register state into task TASK.
- */
-static int set_evrregs(struct task_struct *task, unsigned long *data)
-{
-	if (!access_ok(VERIFY_READ, data, 35 * sizeof(u32)))
-		return -EFAULT;
-
-	return evr_set(task, NULL, 0, 35 * sizeof(u32), NULL, data);
-}
 #endif /* CONFIG_SPE */
 
 
@@ -732,55 +667,29 @@ void ptrace_disable(struct task_struct *child)
 static long arch_ptrace_old(struct task_struct *child, long request, long addr,
 			    long data)
 {
-	int ret = -EPERM;
-
-	switch(request) {
-	case PPC_PTRACE_GETREGS: { /* Get GPRs 0 - 31. */
-		int i;
-		unsigned long *reg = &((unsigned long *)child->thread.regs)[0];
-		unsigned long __user *tmp = (unsigned long __user *)addr;
-
-		CHECK_FULL_REGS(child->thread.regs);
-		for (i = 0; i < 32; i++) {
-			ret = put_user(*reg, tmp);
-			if (ret)
-				break;
-			reg++;
-			tmp++;
-		}
-		break;
-	}
-
-	case PPC_PTRACE_SETREGS: { /* Set GPRs 0 - 31. */
-		int i;
-		unsigned long *reg = &((unsigned long *)child->thread.regs)[0];
-		unsigned long __user *tmp = (unsigned long __user *)addr;
-
-		CHECK_FULL_REGS(child->thread.regs);
-		for (i = 0; i < 32; i++) {
-			ret = get_user(*reg, tmp);
-			if (ret)
-				break;
-			reg++;
-			tmp++;
-		}
-		break;
-	}
-
-	case PPC_PTRACE_GETFPREGS: { /* Get FPRs 0 - 31. */
-		flush_fp_to_thread(child);
-		ret = get_fpregs((void __user *)addr, child, 0);
-		break;
-	}
-
-	case PPC_PTRACE_SETFPREGS: { /* Get FPRs 0 - 31. */
-		flush_fp_to_thread(child);
-		ret = set_fpregs((void __user *)addr, child, 0);
-		break;
+	switch (request) {
+	case PPC_PTRACE_GETREGS:	/* Get GPRs 0 - 31. */
+		return copy_regset_to_user(child, &user_ppc_native_view,
+					   REGSET_GPR, 0, 32 * sizeof(long),
+					   (void __user *) data);
+
+	case PPC_PTRACE_SETREGS:	/* Set GPRs 0 - 31. */
+		return copy_regset_from_user(child, &user_ppc_native_view,
+					     REGSET_GPR, 0, 32 * sizeof(long),
+					     (const void __user *) data);
+
+	case PPC_PTRACE_GETFPREGS:	/* Get FPRs 0 - 31. */
+		return copy_regset_to_user(child, &user_ppc_native_view,
+					   REGSET_FPR, 0, 32 * sizeof(double),
+					   (void __user *) data);
+
+	case PPC_PTRACE_SETFPREGS:	/* Set FPRs 0 - 31. */
+		return copy_regset_from_user(child, &user_ppc_native_view,
+					     REGSET_FPR, 0, 32 * sizeof(double),
+					     (const void __user *) data);
 	}
 
-	}
-	return ret;
+	return -EPERM;
 }
 
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
@@ -871,85 +780,60 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 #ifdef CONFIG_PPC64
 	case PTRACE_GETREGS64:
 #endif
-	case PTRACE_GETREGS: { /* Get all pt_regs from the child. */
-		int ui;
-	  	if (!access_ok(VERIFY_WRITE, (void __user *)data,
-			       sizeof(struct pt_regs))) {
-			ret = -EIO;
-			break;
-		}
-		CHECK_FULL_REGS(child->thread.regs);
-		ret = 0;
-		for (ui = 0; ui < PT_REGS_COUNT; ui ++) {
-			ret |= __put_user(ptrace_get_reg(child, ui),
-					  (unsigned long __user *) data);
-			data += sizeof(long);
-		}
-		break;
-	}
+	case PTRACE_GETREGS:	/* Get all pt_regs from the child. */
+		return copy_regset_to_user(child, &user_ppc_native_view,
+					   REGSET_GPR,
+					   0, sizeof(struct pt_regs),
+					   (void __user *) data);
 
 #ifdef CONFIG_PPC64
 	case PTRACE_SETREGS64:
 #endif
-	case PTRACE_SETREGS: { /* Set all gp regs in the child. */
-		unsigned long tmp;
-		int ui;
-	  	if (!access_ok(VERIFY_READ, (void __user *)data,
-			       sizeof(struct pt_regs))) {
-			ret = -EIO;
-			break;
-		}
-		CHECK_FULL_REGS(child->thread.regs);
-		ret = 0;
-		for (ui = 0; ui < PT_REGS_COUNT; ui ++) {
-			ret = __get_user(tmp, (unsigned long __user *) data);
-			if (ret)
-				break;
-			ptrace_put_reg(child, ui, tmp);
-			data += sizeof(long);
-		}
-		break;
-	}
-
-	case PTRACE_GETFPREGS: { /* Get the child FPU state (FPR0...31 + FPSCR) */
-		flush_fp_to_thread(child);
-		ret = get_fpregs((void __user *)data, child, 1);
-		break;
-	}
-
-	case PTRACE_SETFPREGS: { /* Set the child FPU state (FPR0...31 + FPSCR) */
-		flush_fp_to_thread(child);
-		ret = set_fpregs((void __user *)data, child, 1);
-		break;
-	}
+	case PTRACE_SETREGS:	/* Set all gp regs in the child. */
+		return copy_regset_from_user(child, &user_ppc_native_view,
+					     REGSET_GPR,
+					     0, sizeof(struct pt_regs),
+					     (const void __user *) data);
+
+	case PTRACE_GETFPREGS: /* Get the child FPU state (FPR0...31 + FPSCR) */
+		return copy_regset_to_user(child, &user_ppc_native_view,
+					   REGSET_FPR,
+					   0, sizeof(elf_fpregset_t),
+					   (void __user *) data);
+
+	case PTRACE_SETFPREGS: /* Set the child FPU state (FPR0...31 + FPSCR) */
+		return copy_regset_from_user(child, &user_ppc_native_view,
+					     REGSET_FPR,
+					     0, sizeof(elf_fpregset_t),
+					     (const void __user *) data);
 
 #ifdef CONFIG_ALTIVEC
 	case PTRACE_GETVRREGS:
-		/* Get the child altivec register state. */
-		flush_altivec_to_thread(child);
-		ret = get_vrregs((unsigned long __user *)data, child);
-		break;
+		return copy_regset_to_user(child, &user_ppc_native_view,
+					   REGSET_VMX,
+					   0, (33 * sizeof(vector128) +
+					       sizeof(u32)),
+					   (void __user *) data);
 
 	case PTRACE_SETVRREGS:
-		/* Set the child altivec register state. */
-		flush_altivec_to_thread(child);
-		ret = set_vrregs(child, (unsigned long __user *)data);
-		break;
+		return copy_regset_from_user(child, &user_ppc_native_view,
+					     REGSET_VMX,
+					     0, (33 * sizeof(vector128) +
+						 sizeof(u32)),
+					     (const void __user *) data);
 #endif
 #ifdef CONFIG_SPE
 	case PTRACE_GETEVRREGS:
 		/* Get the child spe register state. */
-		flush_spe_to_thread(child);
-		ret = get_evrregs((unsigned long __user *)data, child);
-		break;
+		return copy_regset_to_user(child, &user_ppc_native_view,
+					   REGSET_SPE, 0, 35 * sizeof(u32),
+					   (void __user *) data);
 
 	case PTRACE_SETEVRREGS:
 		/* Set the child spe register state. */
-		/* this is to clear the MSR_SPE bit to force a reload
-		 * of register state from memory */
-		flush_spe_to_thread(child);
-		ret = set_evrregs(child, (unsigned long __user *)data);
-		break;
+		return copy_regset_from_user(child, &user_ppc_native_view,
+					     REGSET_SPE, 0, 35 * sizeof(u32),
+					     (const void __user *) data);
 #endif
 
 	/* Old reverse args ptrace callss */
-- 
1.5.3.6

