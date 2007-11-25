Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbXKYV7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbXKYV7e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 16:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756012AbXKYV7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 16:59:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757342AbXKYV7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 16:59:22 -0500
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
Subject: [PATCH 04/27] x86: arch_has_single_step
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Zippy-Says: ..  I don't understand the HUMOR of the THREE STOOGES!!
Message-Id: <20071125215915.D381C26F8C5@magilla.localdomain>
Date: Sun, 25 Nov 2007 13:59:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This defines the new standard arch_has_single_step macro.  It makes the
existing set_singlestep and clear_singlestep entry points global, and
renames them to the new standard names user_enable_single_step and
user_disable_single_step, respectively.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace_32.c |   12 ++++++------
 arch/x86/kernel/ptrace_64.c |   12 ++++++------
 include/asm-x86/ptrace.h    |    7 +++++++
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/ptrace_32.c b/arch/x86/kernel/ptrace_32.c
index 2b4fcb5..d1d74e1 100644
--- a/arch/x86/kernel/ptrace_32.c
+++ b/arch/x86/kernel/ptrace_32.c
@@ -218,7 +218,7 @@ static inline int is_setting_trap_flag(struct task_struct *child, struct pt_regs
 	return 0;
 }
 
-static void set_singlestep(struct task_struct *child)
+void user_enable_single_step(struct task_struct *child)
 {
 	struct pt_regs *regs = get_child_regs(child);
 
@@ -249,7 +249,7 @@ static void set_singlestep(struct task_struct *child)
 	child->ptrace |= PT_DTRACE;
 }
 
-static void clear_singlestep(struct task_struct *child)
+void user_disable_single_step(struct task_struct *child)
 {
 	/* Always clear TIF_SINGLESTEP... */
 	clear_tsk_thread_flag(child, TIF_SINGLESTEP);
@@ -269,7 +269,7 @@ static void clear_singlestep(struct task_struct *child)
  */
 void ptrace_disable(struct task_struct *child)
 {
-	clear_singlestep(child);
+	user_disable_single_step(child);
 	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
 }
 
@@ -403,7 +403,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		}
 		child->exit_code = data;
 		/* make sure the single step bit is not set. */
-		clear_singlestep(child);
+		user_disable_single_step(child);
 		wake_up_process(child);
 		ret = 0;
 		break;
@@ -419,7 +419,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			break;
 		child->exit_code = SIGKILL;
 		/* make sure the single step bit is not set. */
-		clear_singlestep(child);
+		user_disable_single_step(child);
 		wake_up_process(child);
 		break;
 
@@ -435,7 +435,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
 
 		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		set_singlestep(child);
+		user_enable_single_step(child);
 		child->exit_code = data;
 		/* give it a chance to run. */
 		wake_up_process(child);
diff --git a/arch/x86/kernel/ptrace_64.c b/arch/x86/kernel/ptrace_64.c
index e907e2e..c2e1a13 100644
--- a/arch/x86/kernel/ptrace_64.c
+++ b/arch/x86/kernel/ptrace_64.c
@@ -170,7 +170,7 @@ static int is_setting_trap_flag(struct task_struct *child, struct pt_regs *regs)
 	return 0;
 }
 
-static void set_singlestep(struct task_struct *child)
+void user_enable_single_step(struct task_struct *child)
 {
 	struct pt_regs *regs = task_pt_regs(child);
 
@@ -201,7 +201,7 @@ static void set_singlestep(struct task_struct *child)
 	child->ptrace |= PT_DTRACE;
 }
 
-static void clear_singlestep(struct task_struct *child)
+void user_disable_single_step(struct task_struct *child)
 {
 	/* Always clear TIF_SINGLESTEP... */
 	clear_tsk_thread_flag(child, TIF_SINGLESTEP);
@@ -221,7 +221,7 @@ static void clear_singlestep(struct task_struct *child)
  */
 void ptrace_disable(struct task_struct *child)
 {
-	clear_singlestep(child);
+	user_disable_single_step(child);
 }
 
 static int putreg(struct task_struct *child,
@@ -461,7 +461,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		clear_tsk_thread_flag(child, TIF_SINGLESTEP);
 		child->exit_code = data;
 		/* make sure the single step bit is not set. */
-		clear_singlestep(child);
+		user_disable_single_step(child);
 		wake_up_process(child);
 		ret = 0;
 		break;
@@ -504,7 +504,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		clear_tsk_thread_flag(child, TIF_SINGLESTEP);
 		child->exit_code = SIGKILL;
 		/* make sure the single step bit is not set. */
-		clear_singlestep(child);
+		user_disable_single_step(child);
 		wake_up_process(child);
 		break;
 
@@ -513,7 +513,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		if (!valid_signal(data))
 			break;
 		clear_tsk_thread_flag(child,TIF_SYSCALL_TRACE);
-		set_singlestep(child);
+		user_enable_single_step(child);
 		child->exit_code = data;
 		/* give it a chance to run. */
 		wake_up_process(child);
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index 105d153..fe75422 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -140,6 +140,13 @@ enum {
 
 #ifdef __KERNEL__
 
+/*
+ * These are defined as per linux/ptrace.h, which see.
+ */
+#define arch_has_single_step()	(1)
+extern void user_enable_single_step(struct task_struct *);
+extern void user_disable_single_step(struct task_struct *);
+
 struct user_desc;
 extern int do_get_thread_area(struct task_struct *p, int idx,
 			      struct user_desc __user *info);
