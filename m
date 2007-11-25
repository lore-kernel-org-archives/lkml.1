Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbXKYWEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbXKYWEf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757289AbXKYWEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:04:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756890AbXKYWEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:04:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Subject: [PATCH 13/27] powerpc: arch_has_single_step
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Shopping-List: (1) Fluent dirt
   (2) Aesthetic warriors
   (3) Impudent annoyer griddles
Message-Id: <20071125220334.ACACB26F8C5@magilla.localdomain>
Date: Sun, 25 Nov 2007 14:03:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This defines the new standard arch_has_single_step macro.  It makes the
existing set_single_step and clear_single_step entry points global, and
renames them to the new standard names user_enable_single_step and
user_disable_single_step, respectively.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/ptrace.c |   12 ++++++------
 include/asm-powerpc/ptrace.h |    7 +++++++
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 3e17d15..b970d79 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -256,7 +256,7 @@ static int set_evrregs(struct task_struct *task, unsigned long *data)
 #endif /* CONFIG_SPE */
 
 
-static void set_single_step(struct task_struct *task)
+void user_enable_single_step(struct task_struct *task)
 {
 	struct pt_regs *regs = task->thread.regs;
 
@@ -271,7 +271,7 @@ static void set_single_step(struct task_struct *task)
 	set_tsk_thread_flag(task, TIF_SINGLESTEP);
 }
 
-static void clear_single_step(struct task_struct *task)
+void user_disable_single_step(struct task_struct *task)
 {
 	struct pt_regs *regs = task->thread.regs;
 
@@ -313,7 +313,7 @@ static int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
 void ptrace_disable(struct task_struct *child)
 {
 	/* make sure the single step bit is not set. */
-	clear_single_step(child);
+	user_disable_single_step(child);
 }
 
 /*
@@ -456,7 +456,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 		child->exit_code = data;
 		/* make sure the single step bit is not set. */
-		clear_single_step(child);
+		user_disable_single_step(child);
 		wake_up_process(child);
 		ret = 0;
 		break;
@@ -473,7 +473,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			break;
 		child->exit_code = SIGKILL;
 		/* make sure the single step bit is not set. */
-		clear_single_step(child);
+		user_disable_single_step(child);
 		wake_up_process(child);
 		break;
 	}
@@ -483,7 +483,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		if (!valid_signal(data))
 			break;
 		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		set_single_step(child);
+		user_enable_single_step(child);
 		child->exit_code = data;
 		/* give it a chance to run. */
 		wake_up_process(child);
diff --git a/include/asm-powerpc/ptrace.h b/include/asm-powerpc/ptrace.h
index 13fccc5..3063363 100644
--- a/include/asm-powerpc/ptrace.h
+++ b/include/asm-powerpc/ptrace.h
@@ -119,6 +119,13 @@ do {									      \
 } while (0)
 #endif /* __powerpc64__ */
 
+/*
+ * These are defined as per linux/ptrace.h, which see.
+ */
+#define arch_has_single_step()	(1)
+extern void user_enable_single_step(struct task_struct *);
+extern void user_disable_single_step(struct task_struct *);
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
