Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbZF0OI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbZF0OI4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 10:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbZF0OI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 10:08:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:56074 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbZF0OIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 10:08:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/6] score: add address space annotations
Date: Sat, 27 Jun 2009 16:08:14 +0200
Message-Id: <a1f8213b9518d0e9124a48a34bdd58b4bc2650e5.1246111364.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1246111364.git.arnd@arndb.de>
References: <cover.1246111364.git.arnd@arndb.de>
In-Reply-To: <cover.1246111364.git.arnd@arndb.de>
References: <cover.1246111364.git.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18hbaqJ07gEajn0hospULFXuwUOkzWJntVDQaZ
 6ndrL/NPSCaRBBY19rsLI3LxwUixJbJFE/G2YZw3LUjmKqOsTL
 uUWbJYbMz06kyEgSrQhrw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annotate the address space for pointers that are used
correctly with __user and __iomem, so that sparse
can better warn about incorrect casts.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/score/include/asm/uaccess.h |    4 ++--
 arch/score/kernel/ptrace.c       |    7 ++++---
 arch/score/kernel/signal.c       |   10 +++++-----
 arch/score/kernel/sys_score.c    |    9 +++++----
 4 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/score/include/asm/uaccess.h b/arch/score/include/asm/uaccess.h
index 43ce28a..6f09e2b 100644
--- a/arch/score/include/asm/uaccess.h
+++ b/arch/score/include/asm/uaccess.h
@@ -13,9 +13,9 @@ extern int fixup_exception(struct pt_regs *regs);
 #ifndef __ASSEMBLY__
 
 #define __range_ok(addr, size)					\
-	((((unsigned long)(addr) >= 0x80000000)			\
+	((((unsigned long __force)(addr) >= 0x80000000)			\
 	|| ((unsigned long)(size) > 0x80000000)			\
-	|| (((unsigned long)(addr) + (unsigned long)(size)) > 0x80000000)))
+	|| (((unsigned long __force)(addr) + (unsigned long)(size)) > 0x80000000)))
 
 #define __access_ok(addr, size) \
 	(__range_ok((addr), (size)) == 0)
diff --git a/arch/score/kernel/ptrace.c b/arch/score/kernel/ptrace.c
index 19911e3..1db876b 100644
--- a/arch/score/kernel/ptrace.c
+++ b/arch/score/kernel/ptrace.c
@@ -267,6 +267,7 @@ long
 arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
 	int ret;
+	unsigned long __user *datap = (void __user *)data;
 
 	switch (request) {
 	/* Read the word at location addr in the USER area.  */
@@ -316,7 +317,7 @@ arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			return -EIO;
 		}
 
-		ret = put_user(tmp, (unsigned long *) data);
+		ret = put_user(tmp, (unsigned int __user *) datap);
 		return ret;
 	}
 
@@ -355,11 +356,11 @@ arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	}
 
 	case PTRACE_GETREGS:
-		ret = ptrace_getregs(child, (void __user *)data);
+		ret = ptrace_getregs(child, (void __user *)datap);
 		break;
 
 	case PTRACE_SETREGS:
-		ret = ptrace_setregs(child, (void __user *)data);
+		ret = ptrace_setregs(child, (void __user *)datap);
 		break;
 
 	default:
diff --git a/arch/score/kernel/signal.c b/arch/score/kernel/signal.c
index 252f6d9..1634aaa 100644
--- a/arch/score/kernel/signal.c
+++ b/arch/score/kernel/signal.c
@@ -131,13 +131,13 @@ void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 	if ((ka->sa.sa_flags & SA_ONSTACK) && (!on_sig_stack(sp)))
 		sp = current->sas_ss_sp + current->sas_ss_size;
 
-	return (void *)((sp - frame_size) & ~7);
+	return (void __user*)((sp - frame_size) & ~7);
 }
 
 int score_sigaltstack(struct pt_regs *regs)
 {
-	const stack_t *uss = (const stack_t *) regs->regs[4];
-	stack_t *uoss = (stack_t *) regs->regs[5];
+	const stack_t __user *uss = (const stack_t __user *) regs->regs[4];
+	stack_t __user *uoss = (stack_t __user *) regs->regs[5];
 	unsigned long usp = regs->regs[0];
 
 	return do_sigaltstack(uss, uoss, usp);
@@ -188,7 +188,7 @@ badframe:
 int setup_rt_frame(struct k_sigaction *ka, struct pt_regs *regs,
 		int signr, sigset_t *set, siginfo_t *info)
 {
-	struct rt_sigframe *frame;
+	struct rt_sigframe __user *frame;
 	int err = 0;
 
 	frame = get_sigframe(ka, regs, sizeof(*frame));
@@ -209,7 +209,7 @@ int setup_rt_frame(struct k_sigaction *ka, struct pt_regs *regs,
 	err |= copy_siginfo_to_user(&frame->rs_info, info);
 	err |= __put_user(0, &frame->rs_uc.uc_flags);
 	err |= __put_user(0, &frame->rs_uc.uc_link);
-	err |= __put_user((void *)current->sas_ss_sp,
+	err |= __put_user((void __user *)current->sas_ss_sp,
 				&frame->rs_uc.uc_stack.ss_sp);
 	err |= __put_user(sas_ss_flags(regs->regs[0]),
 				&frame->rs_uc.uc_stack.ss_flags);
diff --git a/arch/score/kernel/sys_score.c b/arch/score/kernel/sys_score.c
index eb4d2d3..16ace29 100644
--- a/arch/score/kernel/sys_score.c
+++ b/arch/score/kernel/sys_score.c
@@ -87,18 +87,19 @@ int score_clone(struct pt_regs *regs)
  * sys_execve() executes a new program.
  * This is called indirectly via a small wrapper
  */
-int score_execve(struct pt_regs *regs)
+asmlinkage long
+score_execve(struct pt_regs *regs)
 {
 	int error;
 	char *filename;
 
-	filename = getname((char *) (long) regs->regs[4]);
+	filename = getname((char __user*)regs->regs[4]);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		return error;
 
-	error = do_execve(filename, (char **) (long) regs->regs[5],
-			  (char **) (long) regs->regs[6], regs);
+	error = do_execve(filename, (char __user *__user*)regs->regs[5],
+			  (char __user *__user *) regs->regs[6], regs);
 
 	putname(filename);
 	return error;
-- 
1.6.3.1

