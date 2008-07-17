Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYGQHbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYGQHbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757519AbYGQH3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:29:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616AbYGQH3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:29:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 08/23] tracehook: tracehook_tracer_task
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:25:41 -0700 <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
X-Shopping-List: (1) Tedious extravagant ants
   (2) Notorious chic money
   (3) Global commendation omissions
   (4) Mexican Piano bums
Message-Id: <20080717072935.D501C15411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:29:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the tracehook_tracer_task() hook to consolidate all forms of
"Who is using ptrace on me?" logic.  This is used for "TracerPid:" in
/proc and for permission checks.  We also clean up the selinux code
the called an identical accessor.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 fs/proc/array.c           |    9 +++++++--
 fs/proc/base.c            |   13 +++++++++----
 include/linux/tracehook.h |   18 ++++++++++++++++++
 security/selinux/hooks.c  |   22 +++-------------------
 4 files changed, 37 insertions(+), 25 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 797d775..0d6eb33 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -80,6 +80,7 @@
 #include <linux/delayacct.h>
 #include <linux/seq_file.h>
 #include <linux/pid_namespace.h>
+#include <linux/tracehook.h>
 
 #include <asm/pgtable.h>
 #include <asm/processor.h>
@@ -168,8 +169,12 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 	rcu_read_lock();
 	ppid = pid_alive(p) ?
 		task_tgid_nr_ns(rcu_dereference(p->real_parent), ns) : 0;
-	tpid = pid_alive(p) && p->ptrace ?
-		task_pid_nr_ns(rcu_dereference(p->parent), ns) : 0;
+	tpid = 0;
+	if (pid_alive(p)) {
+		struct task_struct *tracer = tracehook_tracer_task(p);
+		if (tracer)
+			tpid = task_pid_nr_ns(tracer, ns);
+	}
 	seq_printf(m,
 		"State:\t%s\n"
 		"Tgid:\t%d\n"
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 58c3e6a..6f21daa 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -69,6 +69,7 @@
 #include <linux/mount.h>
 #include <linux/security.h>
 #include <linux/ptrace.h>
+#include <linux/tracehook.h>
 #include <linux/cgroup.h>
 #include <linux/cpuset.h>
 #include <linux/audit.h>
@@ -231,10 +232,14 @@ static int check_mem_permission(struct task_struct *task)
 	 * If current is actively ptrace'ing, and would also be
 	 * permitted to freshly attach with ptrace now, permit it.
 	 */
-	if (task->parent == current && (task->ptrace & PT_PTRACED) &&
-	    task_is_stopped_or_traced(task) &&
-	    ptrace_may_access(task, PTRACE_MODE_ATTACH))
-		return 0;
+	if (task_is_stopped_or_traced(task)) {
+		int match;
+		rcu_read_lock();
+		match = (tracehook_tracer_task(task) == current);
+		rcu_read_unlock();
+		if (match && ptrace_may_access(task, PTRACE_MODE_ATTACH))
+			return 0;
+	}
 
 	/*
 	 * Noone else is allowed.
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 9a5b3be..6468ca0 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -73,6 +73,24 @@ static inline int tracehook_unsafe_exec(struct task_struct *task)
 }
 
 /**
+ * tracehook_tracer_task - return the task that is tracing the given task
+ * @tsk:		task to consider
+ *
+ * Returns NULL if noone is tracing @task, or the &struct task_struct
+ * pointer to its tracer.
+ *
+ * Must called under rcu_read_lock().  The pointer returned might be kept
+ * live only by RCU.  During exec, this may be called with task_lock()
+ * held on @task, still held from when tracehook_unsafe_exec() was called.
+ */
+static inline struct task_struct *tracehook_tracer_task(struct task_struct *tsk)
+{
+	if (task_ptrace(tsk) & PT_PTRACED)
+		return rcu_dereference(tsk->parent);
+	return NULL;
+}
+
+/**
  * tracehook_report_exec - a successful exec was completed
  * @fmt:		&struct linux_binfmt that performed the exec
  * @bprm:		&struct linux_binprm containing exec details
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 63f131f..3481cde 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -25,7 +25,7 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/ptrace.h>
+#include <linux/tracehook.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/security.h>
@@ -1971,22 +1971,6 @@ static int selinux_vm_enough_memory(struct mm_struct *mm, long pages)
 	return __vm_enough_memory(mm, pages, cap_sys_admin);
 }
 
-/**
- * task_tracer_task - return the task that is tracing the given task
- * @task:		task to consider
- *
- * Returns NULL if noone is tracing @task, or the &struct task_struct
- * pointer to its tracer.
- *
- * Must be called under rcu_read_lock().
- */
-static struct task_struct *task_tracer_task(struct task_struct *task)
-{
-	if (task->ptrace & PT_PTRACED)
-		return rcu_dereference(task->parent);
-	return NULL;
-}
-
 /* binprm security operations */
 
 static int selinux_bprm_alloc_security(struct linux_binprm *bprm)
@@ -2238,7 +2222,7 @@ static void selinux_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
 			u32 ptsid = 0;
 
 			rcu_read_lock();
-			tracer = task_tracer_task(current);
+			tracer = tracehook_tracer_task(current);
 			if (likely(tracer != NULL)) {
 				sec = tracer->security;
 				ptsid = sec->sid;
@@ -5247,7 +5231,7 @@ static int selinux_setprocattr(struct task_struct *p,
 		   Otherwise, leave SID unchanged and fail. */
 		task_lock(p);
 		rcu_read_lock();
-		tracer = task_tracer_task(p);
+		tracer = tracehook_tracer_task(p);
 		if (tracer != NULL) {
 			struct task_security_struct *ptsec = tracer->security;
 			u32 ptsid = ptsec->sid;
