Return-Path: <linux-kernel-owner+w=401wt.eu-S933228AbZHVE71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228AbZHVE71 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 00:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933135AbZHVE7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 00:59:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932283AbZHVE7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 00:59:21 -0400
From: Josh Stone <jistone@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Josh Stone <jistone@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH v3 2/4] tracing: Make syscall_(un)regfunc arch-specific
Date: Fri, 21 Aug 2009 21:58:43 -0700
Message-Id: <1250917125-6174-3-git-send-email-jistone@redhat.com>
In-Reply-To: <1250917125-6174-2-git-send-email-jistone@redhat.com>
References: <1250795373-32363-1-git-send-email-jistone@redhat.com>
 <1250917125-6174-1-git-send-email-jistone@redhat.com>
 <1250917125-6174-2-git-send-email-jistone@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bodies of syscall_regfunc and syscall_unregfunc need the
arch-specific flag TIF_SYSCALL_TRACEPOINT, which only exists
on x86 and s390, so they should live in arch-specific files.

Signed-off-by: Josh Stone <jistone@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 arch/s390/kernel/ptrace.c |   40 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/ptrace.c  |   40 ++++++++++++++++++++++++++++++++++++++++
 kernel/tracepoint.c       |   40 ----------------------------------------
 3 files changed, 80 insertions(+), 40 deletions(-)

diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 9d3dcfa..b6dcd72 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -925,3 +925,43 @@ const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 #endif
 	return &user_s390_view;
 }
+
+#ifdef CONFIG_TRACEPOINTS
+
+static DEFINE_MUTEX(regfunc_mutex);
+static int sys_tracepoint_refcount;
+
+void syscall_regfunc(void)
+{
+	unsigned long flags;
+	struct task_struct *g, *t;
+
+	mutex_lock(&regfunc_mutex);
+	if (!sys_tracepoint_refcount) {
+		read_lock_irqsave(&tasklist_lock, flags);
+		do_each_thread(g, t) {
+			set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
+		} while_each_thread(g, t);
+		read_unlock_irqrestore(&tasklist_lock, flags);
+	}
+	sys_tracepoint_refcount++;
+	mutex_unlock(&regfunc_mutex);
+}
+
+void syscall_unregfunc(void)
+{
+	unsigned long flags;
+	struct task_struct *g, *t;
+
+	mutex_lock(&regfunc_mutex);
+	sys_tracepoint_refcount--;
+	if (!sys_tracepoint_refcount) {
+		read_lock_irqsave(&tasklist_lock, flags);
+		do_each_thread(g, t) {
+			clear_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
+		} while_each_thread(g, t);
+		read_unlock_irqrestore(&tasklist_lock, flags);
+	}
+	mutex_unlock(&regfunc_mutex);
+}
+#endif
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index a909afe..c2adbed 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1549,3 +1549,43 @@ asmregparm void syscall_trace_leave(struct pt_regs *regs)
 	    tracehook_consider_fatal_signal(current, SIGTRAP))
 		send_sigtrap(current, regs, 0, TRAP_BRKPT);
 }
+
+#ifdef CONFIG_TRACEPOINTS
+
+static DEFINE_MUTEX(regfunc_mutex);
+static int sys_tracepoint_refcount;
+
+void syscall_regfunc(void)
+{
+	unsigned long flags;
+	struct task_struct *g, *t;
+
+	mutex_lock(&regfunc_mutex);
+	if (!sys_tracepoint_refcount) {
+		read_lock_irqsave(&tasklist_lock, flags);
+		do_each_thread(g, t) {
+			set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
+		} while_each_thread(g, t);
+		read_unlock_irqrestore(&tasklist_lock, flags);
+	}
+	sys_tracepoint_refcount++;
+	mutex_unlock(&regfunc_mutex);
+}
+
+void syscall_unregfunc(void)
+{
+	unsigned long flags;
+	struct task_struct *g, *t;
+
+	mutex_lock(&regfunc_mutex);
+	sys_tracepoint_refcount--;
+	if (!sys_tracepoint_refcount) {
+		read_lock_irqsave(&tasklist_lock, flags);
+		do_each_thread(g, t) {
+			clear_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
+		} while_each_thread(g, t);
+		read_unlock_irqrestore(&tasklist_lock, flags);
+	}
+	mutex_unlock(&regfunc_mutex);
+}
+#endif
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 43bca1f..2ce4d38 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -578,43 +578,3 @@ static int init_tracepoints(void)
 __initcall(init_tracepoints);
 
 #endif /* CONFIG_MODULES */
-
-#ifdef CONFIG_FTRACE_SYSCALLS
-
-static DEFINE_MUTEX(regfunc_mutex);
-static int sys_tracepoint_refcount;
-
-void syscall_regfunc(void)
-{
-	unsigned long flags;
-	struct task_struct *g, *t;
-
-	mutex_lock(&regfunc_mutex);
-	if (!sys_tracepoint_refcount) {
-		read_lock_irqsave(&tasklist_lock, flags);
-		do_each_thread(g, t) {
-			set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
-		} while_each_thread(g, t);
-		read_unlock_irqrestore(&tasklist_lock, flags);
-	}
-	sys_tracepoint_refcount++;
-	mutex_unlock(&regfunc_mutex);
-}
-
-void syscall_unregfunc(void)
-{
-	unsigned long flags;
-	struct task_struct *g, *t;
-
-	mutex_lock(&regfunc_mutex);
-	sys_tracepoint_refcount--;
-	if (!sys_tracepoint_refcount) {
-		read_lock_irqsave(&tasklist_lock, flags);
-		do_each_thread(g, t) {
-			clear_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
-		} while_each_thread(g, t);
-		read_unlock_irqrestore(&tasklist_lock, flags);
-	}
-	mutex_unlock(&regfunc_mutex);
-}
-#endif
-- 
1.6.2.5

