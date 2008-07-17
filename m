Return-Path: <linux-kernel-owner+w=401wt.eu-S1760808AbYGQHgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808AbYGQHgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbYGQHbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:31:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760030AbYGQHbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:31:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 22/23] task_current_syscall
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:25:41 -0700 <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080717073135.2445E15411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:31:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the new function task_current_syscall() on machines where the
asm/syscall.h interface is supported (CONFIG_HAVE_ARCH_TRACEHOOK).
It's exported for modules to use in the future.  This function safely
samples the state of a blocked thread to collect what system call it
is blocked in, and the six system call argument registers.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/ptrace.h |    4 ++
 lib/Makefile           |    2 +
 lib/syscall.c          |   75 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index ed69c03..fd31756 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -314,6 +314,10 @@ static inline void user_enable_block_step(struct task_struct *task)
 #define arch_ptrace_stop(code, info)		do { } while (0)
 #endif
 
+extern int task_current_syscall(struct task_struct *target, long *callno,
+				unsigned long args[6], unsigned int maxargs,
+				unsigned long *sp, unsigned long *pc);
+
 #endif
 
 #endif
diff --git a/lib/Makefile b/lib/Makefile
index 2c62a9c..0dd88c4 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -82,6 +82,8 @@ lib-$(CONFIG_GENERIC_BUG) += bug.o
 
 obj-$(CONFIG_HAVE_LMB) += lmb.o
 
+obj-$(CONFIG_HAVE_ARCH_TRACEHOOK) += syscall.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/syscall.c b/lib/syscall.c
new file mode 100644
index 0000000..a4f7067
--- /dev/null
+++ b/lib/syscall.c
@@ -0,0 +1,75 @@
+#include <linux/ptrace.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <asm/syscall.h>
+
+static int collect_syscall(struct task_struct *target, long *callno,
+			   unsigned long args[6], unsigned int maxargs,
+			   unsigned long *sp, unsigned long *pc)
+{
+	struct pt_regs *regs = task_pt_regs(target);
+	if (unlikely(!regs))
+		return -EAGAIN;
+
+	*sp = user_stack_pointer(regs);
+	*pc = instruction_pointer(regs);
+
+	*callno = syscall_get_nr(target, regs);
+	if (*callno != -1L && maxargs > 0)
+		syscall_get_arguments(target, regs, 0, maxargs, args);
+
+	return 0;
+}
+
+/**
+ * task_current_syscall - Discover what a blocked task is doing.
+ * @target:		thread to examine
+ * @callno:		filled with system call number or -1
+ * @args:		filled with @maxargs system call arguments
+ * @maxargs:		number of elements in @args to fill
+ * @sp:			filled with user stack pointer
+ * @pc:			filled with user PC
+ *
+ * If @target is blocked in a system call, returns zero with *@callno
+ * set to the the call's number and @args filled in with its arguments.
+ * Registers not used for system call arguments may not be available and
+ * it is not kosher to use &struct user_regset calls while the system
+ * call is still in progress.  Note we may get this result if @target
+ * has finished its system call but not yet returned to user mode, such
+ * as when it's stopped for signal handling or syscall exit tracing.
+ *
+ * If @target is blocked in the kernel during a fault or exception,
+ * returns zero with *@callno set to -1 and does not fill in @args.
+ * If so, it's now safe to examine @target using &struct user_regset
+ * get() calls as long as we're sure @target won't return to user mode.
+ *
+ * Returns -%EAGAIN if @target does not remain blocked.
+ *
+ * Returns -%EINVAL if @maxargs is too large (maximum is six).
+ */
+int task_current_syscall(struct task_struct *target, long *callno,
+			 unsigned long args[6], unsigned int maxargs,
+			 unsigned long *sp, unsigned long *pc)
+{
+	long state;
+	unsigned long ncsw;
+
+	if (unlikely(maxargs > 6))
+		return -EINVAL;
+
+	if (target == current)
+		return collect_syscall(target, callno, args, maxargs, sp, pc);
+
+	state = target->state;
+	if (unlikely(!state))
+		return -EAGAIN;
+
+	ncsw = wait_task_inactive(target, state);
+	if (unlikely(!ncsw) ||
+	    unlikely(collect_syscall(target, callno, args, maxargs, sp, pc)) ||
+	    unlikely(wait_task_inactive(target, state) != ncsw))
+		return -EAGAIN;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(task_current_syscall);
