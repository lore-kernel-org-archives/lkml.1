Return-Path: <linux-kernel-owner+w=401wt.eu-S1762262AbXLTMEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762262AbXLTMEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761053AbXLTMAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:00:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760348AbXLTMAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:22 -0500
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
Subject: [PATCH -mm 38/43] x86 ptrace user_regset
Message-Id: <20071220120008.B183626F98E@magilla.localdomain>
Date: Thu, 20 Dec 2007 04:00:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up the PTRACE_*REGS* request code so each one is just a
simple call to copy_regset_to_user or copy_regset_from_user.  The
ptrace layouts already match the user_regset formats (core dump formats).

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/ptrace.c |  236 +++++++++++++++-------------------------------
 1 files changed, 77 insertions(+), 159 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index ede27e9..e8c2ba3 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -750,9 +750,13 @@ void ptrace_disable(struct task_struct *child)
 	}
 }
 
+#if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
+static const struct user_regset_view user_x86_32_view; /* Initialized below. */
+#endif
+
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
-	int i, ret;
+	int ret;
 	unsigned long __user *datap = (unsigned long __user *)data;
 
 	switch (request) {
@@ -805,82 +809,46 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		}
 		break;
 
-	case PTRACE_GETREGS: { /* Get all gp regs from the child. */
-		if (!access_ok(VERIFY_WRITE, datap, sizeof(struct user_regs_struct))) {
-			ret = -EIO;
-			break;
-		}
-		for (i = 0; i < sizeof(struct user_regs_struct); i += sizeof(long)) {
-			__put_user(getreg(child, i), datap);
-			datap++;
-		}
-		ret = 0;
-		break;
-	}
-
-	case PTRACE_SETREGS: { /* Set all gp regs in the child. */
-		unsigned long tmp;
-		if (!access_ok(VERIFY_READ, datap, sizeof(struct user_regs_struct))) {
-			ret = -EIO;
-			break;
-		}
-		for (i = 0; i < sizeof(struct user_regs_struct); i += sizeof(long)) {
-			__get_user(tmp, datap);
-			putreg(child, i, tmp);
-			datap++;
-		}
-		ret = 0;
-		break;
-	}
-
-	case PTRACE_GETFPREGS: { /* Get the child FPU state. */
-		if (!access_ok(VERIFY_WRITE, datap,
-			       sizeof(struct user_i387_struct))) {
-			ret = -EIO;
-			break;
-		}
-		ret = 0;
-		if (!tsk_used_math(child))
-			init_fpu(child);
-		get_fpregs((struct user_i387_struct __user *)data, child);
-		break;
-	}
-
-	case PTRACE_SETFPREGS: { /* Set the child FPU state. */
-		if (!access_ok(VERIFY_READ, datap,
-			       sizeof(struct user_i387_struct))) {
-			ret = -EIO;
-			break;
-		}
-		set_stopped_child_used_math(child);
-		set_fpregs(child, (struct user_i387_struct __user *)data);
-		ret = 0;
-		break;
-	}
+	case PTRACE_GETREGS:	/* Get all gp regs from the child. */
+		return copy_regset_to_user(child,
+					   task_user_regset_view(current),
+					   REGSET_GENERAL,
+					   0, sizeof(struct user_regs_struct),
+					   datap);
+
+	case PTRACE_SETREGS:	/* Set all gp regs in the child. */
+		return copy_regset_from_user(child,
+					     task_user_regset_view(current),
+					     REGSET_GENERAL,
+					     0, sizeof(struct user_regs_struct),
+					     datap);
+
+	case PTRACE_GETFPREGS:	/* Get the child FPU state. */
+		return copy_regset_to_user(child,
+					   task_user_regset_view(current),
+					   REGSET_FP,
+					   0, sizeof(struct user_i387_struct),
+					   datap);
+
+	case PTRACE_SETFPREGS:	/* Set the child FPU state. */
+		return copy_regset_from_user(child,
+					     task_user_regset_view(current),
+					     REGSET_FP,
+					     0, sizeof(struct user_i387_struct),
+					     datap);
 
 #ifdef CONFIG_X86_32
-	case PTRACE_GETFPXREGS: { /* Get the child extended FPU state. */
-		if (!access_ok(VERIFY_WRITE, datap,
-			       sizeof(struct user_fxsr_struct))) {
-			ret = -EIO;
-			break;
-		}
-		if (!tsk_used_math(child))
-			init_fpu(child);
-		ret = get_fpxregs((struct user_fxsr_struct __user *)data, child);
-		break;
-	}
-
-	case PTRACE_SETFPXREGS: { /* Set the child extended FPU state. */
-		if (!access_ok(VERIFY_READ, datap,
-			       sizeof(struct user_fxsr_struct))) {
-			ret = -EIO;
-			break;
-		}
-		set_stopped_child_used_math(child);
-		ret = set_fpxregs(child, (struct user_fxsr_struct __user *)data);
-		break;
-	}
+	case PTRACE_GETFPXREGS:	/* Get the child extended FPU state. */
+		return copy_regset_to_user(child, &user_x86_32_view,
+					   REGSET_XFP,
+					   0, sizeof(struct user_fxsr_struct),
+					   datap);
+
+	case PTRACE_SETFPXREGS:	/* Set the child extended FPU state. */
+		return copy_regset_from_user(child, &user_x86_32_view,
+					     REGSET_XFP,
+					     0, sizeof(struct user_fxsr_struct),
+					     datap);
 #endif
 
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
@@ -1244,90 +1212,40 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 		ret = putreg32(child, addr, data);
 		break;
 
-	case PTRACE_GETREGS: { /* Get all gp regs from the child. */
-		int i;
-
-		if (!access_ok(VERIFY_WRITE, datap, 16*4)) {
-			ret = -EIO;
-			break;
-		}
-		ret = 0;
-		for (i = 0; i < sizeof(struct user_regs_struct32); i += sizeof(__u32)) {
-			getreg32(child, i, &val);
-			ret |= __put_user(val, (u32 __user *)datap);
-			datap += sizeof(u32);
-		}
-		break;
-	}
-
-	case PTRACE_SETREGS: { /* Set all gp regs in the child. */
-		unsigned long tmp;
-		int i;
-
-		if (!access_ok(VERIFY_READ, datap, 16*4)) {
-			ret = -EIO;
-			break;
-		}
-		ret = 0;
-		for (i = 0; i < sizeof(struct user_regs_struct32); i += sizeof(u32)) {
-			ret |= __get_user(tmp, (u32 __user *)datap);
-			putreg32(child, i, tmp);
-			datap += sizeof(u32);
-		}
-		break;
-	}
-
-	case PTRACE_GETFPREGS:
-		ret = -EIO;
-		if (!access_ok(VERIFY_READ, compat_ptr(data),
-			       sizeof(struct user_i387_struct)))
-			break;
-		save_i387_ia32(child, datap, childregs, 1);
-		ret = 0;
-			break;
-
-	case PTRACE_SETFPREGS:
-		ret = -EIO;
-		if (!access_ok(VERIFY_WRITE, datap,
-			       sizeof(struct user_i387_struct)))
-			break;
-		ret = 0;
-		/* don't check EFAULT to be bug-to-bug compatible to i386 */
-		restore_i387_ia32(child, datap, 1);
-		break;
-
-	case PTRACE_GETFPXREGS: {
-		struct user32_fxsr_struct __user *u = datap;
-
-		init_fpu(child);
-		ret = -EIO;
-		if (!access_ok(VERIFY_WRITE, u, sizeof(*u)))
-			break;
-			ret = -EFAULT;
-		if (__copy_to_user(u, &child->thread.i387.fxsave, sizeof(*u)))
-			break;
-		ret = __put_user(childregs->cs, &u->fcs);
-		ret |= __put_user(child->thread.ds, &u->fos);
-		break;
-	}
-	case PTRACE_SETFPXREGS: {
-		struct user32_fxsr_struct __user *u = datap;
-
-		unlazy_fpu(child);
-		ret = -EIO;
-		if (!access_ok(VERIFY_READ, u, sizeof(*u)))
-			break;
-		/*
-		 * no checking to be bug-to-bug compatible with i386.
-		 * but silence warning
-		 */
-		if (__copy_from_user(&child->thread.i387.fxsave, u, sizeof(*u)))
-			;
-		set_stopped_child_used_math(child);
-		child->thread.i387.fxsave.mxcsr &= mxcsr_feature_mask;
-		ret = 0;
-		break;
-	}
+	case PTRACE_GETREGS:	/* Get all gp regs from the child. */
+		return copy_regset_to_user(child, &user_x86_32_view,
+					   REGSET_GENERAL,
+					   0, sizeof(struct user_regs_struct32),
+					   datap);
+
+	case PTRACE_SETREGS:	/* Set all gp regs in the child. */
+		return copy_regset_from_user(child, &user_x86_32_view,
+					     REGSET_GENERAL, 0,
+					     sizeof(struct user_regs_struct32),
+					     datap);
+
+	case PTRACE_GETFPREGS:	/* Get the child FPU state. */
+		return copy_regset_to_user(child, &user_x86_32_view,
+					   REGSET_FP, 0,
+					   sizeof(struct user_i387_ia32_struct),
+					   datap);
+
+	case PTRACE_SETFPREGS:	/* Set the child FPU state. */
+		return copy_regset_from_user(
+			child, &user_x86_32_view, REGSET_FP,
+			0, sizeof(struct user_i387_ia32_struct), datap);
+
+	case PTRACE_GETFPXREGS:	/* Get the child extended FPU state. */
+		return copy_regset_to_user(child, &user_x86_32_view,
+					   REGSET_XFP, 0,
+					   sizeof(struct user32_fxsr_struct),
+					   datap);
+
+	case PTRACE_SETFPXREGS:	/* Set the child extended FPU state. */
+		return copy_regset_from_user(child, &user_x86_32_view,
+					     REGSET_XFP, 0,
+					     sizeof(struct user32_fxsr_struct),
+					     datap);
 
 	case PTRACE_GETEVENTMSG:
 		ret = put_user(child->ptrace_message,
-- 
1.5.3.6

