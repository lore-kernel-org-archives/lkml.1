Return-Path: <linux-kernel-owner+w=401wt.eu-S1758505AbXKYWJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505AbXKYWJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759003AbXKYWJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:09:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758977AbXKYWJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:09:19 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 25/27] x86: debugctlmsr arch_has_block_step
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Zippy-Says: YOW!!  The land of the rising SONY!!
Message-Id: <20071125220845.0B73E26F8C5@magilla.localdomain>
Date: Sun, 25 Nov 2007 14:08:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This implements user-mode step-until-branch on x86 using the BTF bit
in MSR_IA32_DEBUGCTLMSR.  It's just like single-step, only less so.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/step.c     |   64 +++++++++++++++++++++++++++++++++++++++++--
 arch/x86/kernel/traps_32.c |    6 ++++
 arch/x86/kernel/traps_64.c |    6 ++++
 include/asm-x86/ptrace.h   |    7 +++++
 4 files changed, 80 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index 243bff6..cf4b9da 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -107,7 +107,10 @@ static int is_setting_trap_flag(struct task_struct *child, struct pt_regs *regs)
 	return 0;
 }
 
-void user_enable_single_step(struct task_struct *child)
+/*
+ * Enable single-stepping.  Return nonzero if user mode is not using TF itself.
+ */
+static int enable_single_step(struct task_struct *child)
 {
 	struct pt_regs *regs = task_pt_regs(child);
 
@@ -122,7 +125,7 @@ void user_enable_single_step(struct task_struct *child)
 	 * If TF was already set, don't do anything else
 	 */
 	if (regs->eflags & X86_EFLAGS_TF)
-		return;
+		return 0;
 
 	/* Set TF on the kernel stack.. */
 	regs->eflags |= X86_EFLAGS_TF;
@@ -133,13 +136,68 @@ void user_enable_single_step(struct task_struct *child)
 	 * won't clear it by hand later.
 	 */
 	if (is_setting_trap_flag(child, regs))
-		return;
+		return 0;
 
 	set_tsk_thread_flag(child, TIF_FORCED_TF);
+
+	return 1;
+}
+
+/*
+ * Install this value in MSR_IA32_DEBUGCTLMSR whenever child is running.
+ */
+static void write_debugctlmsr(struct task_struct *child, unsigned long val)
+{
+	child->thread.debugctlmsr = val;
+
+	if (child != current)
+		return;
+
+#ifdef CONFIG_X86_64
+	wrmsrl(MSR_IA32_DEBUGCTLMSR, val);
+#else
+	wrmsr(MSR_IA32_DEBUGCTLMSR, val, 0);
+#endif
+}
+
+/*
+ * Enable single or block step.
+ */
+static void enable_step(struct task_struct *child, bool block)
+{
+	/*
+	 * Make sure block stepping (BTF) is not enabled unless it should be.
+	 * Note that we don't try to worry about any is_setting_trap_flag()
+	 * instructions after the first when using block stepping.
+	 * So noone should try to use debugger block stepping in a program
+	 * that uses user-mode single stepping itself.
+	 */
+	if (enable_single_step(child) && block) {
+		set_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
+		write_debugctlmsr(child, DEBUGCTLMSR_BTF);
+	} else if (test_and_clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR)) {
+		write_debugctlmsr(child, 0);
+	}
+}
+
+void user_enable_single_step(struct task_struct *child)
+{
+	enable_step(child, 0);
+}
+
+void user_enable_block_step(struct task_struct *child)
+{
+	enable_step(child, 1);
 }
 
 void user_disable_single_step(struct task_struct *child)
 {
+	/*
+	 * Make sure block stepping (BTF) is disabled.
+	 */
+	if (test_and_clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR))
+		write_debugctlmsr(child, 0);
+
 	/* Always clear TIF_SINGLESTEP... */
 	clear_tsk_thread_flag(child, TIF_SINGLESTEP);
 
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 298d13e..03d5b41 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -830,6 +830,12 @@ fastcall void __kprobes do_debug(struct pt_regs * regs, long error_code)
 
 	get_debugreg(condition, 6);
 
+	/*
+	 * The processor cleared BTF, so don't mark that we need it set.
+	 */
+	clear_tsk_thread_flag(tsk, TIF_DEBUGCTLMSR);
+	tsk->thread.debugctlmsr = 0;
+
 	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
 					SIGTRAP) == NOTIFY_STOP)
 		return;
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index daf35a8..ec70f5c 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -848,6 +848,12 @@ asmlinkage void __kprobes do_debug(struct pt_regs * regs,
 
 	get_debugreg(condition, 6);
 
+	/*
+	 * The processor cleared BTF, so don't mark that we need it set.
+	 */
+	clear_tsk_thread_flag(tsk, TIF_DEBUGCTLMSR);
+	tsk->thread.debugctlmsr = 0;
+
 	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
 						SIGTRAP) == NOTIFY_STOP)
 		return;
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index d223dec..04204f3 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -150,6 +150,13 @@ enum {
 extern void user_enable_single_step(struct task_struct *);
 extern void user_disable_single_step(struct task_struct *);
 
+extern void user_enable_block_step(struct task_struct *);
+#ifdef CONFIG_X86_DEBUGCTLMSR
+#define arch_has_block_step()	(1)
+#else
+#define arch_has_block_step()	(boot_cpu_data.x86 >= 6)
+#endif
+
 struct user_desc;
 extern int do_get_thread_area(struct task_struct *p, int idx,
 			      struct user_desc __user *info);
