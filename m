Return-Path: <linux-kernel-owner+w=401wt.eu-S1760381AbYGQHc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760381AbYGQHc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757609AbYGQHaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:30:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433AbYGQHae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:30:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 13/23] tracehook: syscall
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:25:41 -0700 <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080717073029.5658015411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:30:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds standard tracehook.h inlines for arch code to call when
TIF_SYSCALL_TRACE has been set.  This replaces having each arch
implement the ptrace guts for its syscall tracing support.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/tracehook.h |   70 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 8b4c15e..3548694 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -66,6 +66,76 @@ static inline int tracehook_expect_breakpoints(struct task_struct *task)
 	return (task_ptrace(task) & PT_PTRACED) != 0;
 }
 
+/*
+ * ptrace report for syscall entry and exit looks identical.
+ */
+static inline void ptrace_report_syscall(struct pt_regs *regs)
+{
+	int ptrace = task_ptrace(current);
+
+	if (!(ptrace & PT_PTRACED))
+		return;
+
+	ptrace_notify(SIGTRAP | ((ptrace & PT_TRACESYSGOOD) ? 0x80 : 0));
+
+	/*
+	 * this isn't the same as continuing with a signal, but it will do
+	 * for normal use.  strace only continues with a signal if the
+	 * stopping signal is not SIGTRAP.  -brl
+	 */
+	if (current->exit_code) {
+		send_sig(current->exit_code, current, 1);
+		current->exit_code = 0;
+	}
+}
+
+/**
+ * tracehook_report_syscall_entry - task is about to attempt a system call
+ * @regs:		user register state of current task
+ *
+ * This will be called if %TIF_SYSCALL_TRACE has been set, when the
+ * current task has just entered the kernel for a system call.
+ * Full user register state is available here.  Changing the values
+ * in @regs can affect the system call number and arguments to be tried.
+ * It is safe to block here, preventing the system call from beginning.
+ *
+ * Returns zero normally, or nonzero if the calling arch code should abort
+ * the system call.  That must prevent normal entry so no system call is
+ * made.  If @task ever returns to user mode after this, its register state
+ * is unspecified, but should be something harmless like an %ENOSYS error
+ * return.
+ *
+ * Called without locks, just after entering kernel mode.
+ */
+static inline __must_check int tracehook_report_syscall_entry(
+	struct pt_regs *regs)
+{
+	ptrace_report_syscall(regs);
+	return 0;
+}
+
+/**
+ * tracehook_report_syscall_exit - task has just finished a system call
+ * @regs:		user register state of current task
+ * @step:		nonzero if simulating single-step or block-step
+ *
+ * This will be called if %TIF_SYSCALL_TRACE has been set, when the
+ * current task has just finished an attempted system call.  Full
+ * user register state is available here.  It is safe to block here,
+ * preventing signals from being processed.
+ *
+ * If @step is nonzero, this report is also in lieu of the normal
+ * trap that would follow the system call instruction because
+ * user_enable_block_step() or user_enable_single_step() was used.
+ * In this case, %TIF_SYSCALL_TRACE might not be set.
+ *
+ * Called without locks, just before checking for pending signals.
+ */
+static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
+{
+	ptrace_report_syscall(regs);
+}
+
 /**
  * tracehook_unsafe_exec - check for exec declared unsafe due to tracing
  * @task:		current task doing exec
