Return-Path: <linux-kernel-owner+w=401wt.eu-S1751591AbZLIIZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbZLIIZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 03:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZLIIZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 03:25:48 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:50898 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbZLIIZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 03:25:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bww869NqmZY5outHSHTqaM0a88Jko53Cq7PEOZL9GHXhPKeoneeiGsWDdVqXGnC83r
         F1H8KBwS8QgD82x0LBS03cykK96sVvxbLq9FWtAGPoI1ELT0W+LlvEA7iNIdZhj3FTCu
         oRgZQ8sS3VmLZxmdTqjEq8Jo0iLnQe6N1+ZIM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Prasad <prasad@linux.vnet.ibm.com>
Subject: [PATCH] hw-breakpoints: Modify breakpoints without unregistering them
Date: Wed,  9 Dec 2009 09:25:48 +0100
Message-Id: <1260347148-5519-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when ptrace needs to modify a breakpoint, like disabling
it, changing its address, type or len, it calls
modify_user_hw_breakpoint(). This latter will perform the heavy and
racy task of unregistering the old breakpoint and registering a new
one.

This is racy as someone else might steal the reserved breakpoint slot
under us, which is undesired as the breakpoint is only supposed to be
modified, sometimes in the middle of a debugging workflow. We don't
want our slot to be stolen in the middle.

So instead of unregistering/registering the breakpoint, just disable
it while we modify its breakpoint fields and re-enable it after if
necessary.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
---
 arch/x86/kernel/ptrace.c      |   57 ++++++++++++++++++----------------------
 include/linux/hw_breakpoint.h |    4 +-
 include/linux/perf_event.h    |    5 +++-
 kernel/hw_breakpoint.c        |   42 +++++++++++++++++++++++-------
 kernel/perf_event.c           |    4 +-
 5 files changed, 66 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index b361d28..7079dda 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -595,7 +595,7 @@ static unsigned long ptrace_get_dr7(struct perf_event *bp[])
 	return dr7;
 }
 
-static struct perf_event *
+static int
 ptrace_modify_breakpoint(struct perf_event *bp, int len, int type,
 			 struct task_struct *tsk, int disabled)
 {
@@ -609,11 +609,11 @@ ptrace_modify_breakpoint(struct perf_event *bp, int len, int type,
 	 * written the address register first
 	 */
 	if (!bp)
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	err = arch_bp_generic_fields(len, type, &gen_len, &gen_type);
 	if (err)
-		return ERR_PTR(err);
+		return err;
 
 	attr = bp->attr;
 	attr.bp_len = gen_len;
@@ -658,28 +658,17 @@ restore:
 				if (!second_pass)
 					continue;
 
-				thread->ptrace_bps[i] = NULL;
-				bp = ptrace_modify_breakpoint(bp, len, type,
+				rc = ptrace_modify_breakpoint(bp, len, type,
 							      tsk, 1);
-				if (IS_ERR(bp)) {
-					rc = PTR_ERR(bp);
-					thread->ptrace_bps[i] = NULL;
+				if (rc)
 					break;
-				}
-				thread->ptrace_bps[i] = bp;
 			}
 			continue;
 		}
 
-		bp = ptrace_modify_breakpoint(bp, len, type, tsk, 0);
-
-		/* Incorrect bp, or we have a bug in bp API */
-		if (IS_ERR(bp)) {
-			rc = PTR_ERR(bp);
-			thread->ptrace_bps[i] = NULL;
+		rc = ptrace_modify_breakpoint(bp, len, type, tsk, 0);
+		if (rc)
 			break;
-		}
-		thread->ptrace_bps[i] = bp;
 	}
 	/*
 	 * Make a second pass to free the remaining unused breakpoints
@@ -737,26 +726,32 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 		attr.disabled = 1;
 
 		bp = register_user_hw_breakpoint(&attr, ptrace_triggered, tsk);
+
+		/*
+		 * CHECKME: the previous code returned -EIO if the addr wasn't
+		 * a valid task virtual addr. The new one will return -EINVAL in
+		 *  this case.
+		 * -EINVAL may be what we want for in-kernel breakpoints users,
+		 * but -EIO looks better for ptrace, since we refuse a register
+		 * writing for the user. And anyway this is the previous
+		 * behaviour.
+		 */
+		if (IS_ERR(bp))
+			return PTR_ERR(bp);
+
+		t->ptrace_bps[nr] = bp;
 	} else {
+		int err;
+
 		bp = t->ptrace_bps[nr];
-		t->ptrace_bps[nr] = NULL;
 
 		attr = bp->attr;
 		attr.bp_addr = addr;
-		bp = modify_user_hw_breakpoint(bp, &attr);
+		err = modify_user_hw_breakpoint(bp, &attr);
+		if (err)
+			return err;
 	}
-	/*
-	 * CHECKME: the previous code returned -EIO if the addr wasn't a
-	 * valid task virtual addr. The new one will return -EINVAL in this
-	 * case.
-	 * -EINVAL may be what we want for in-kernel breakpoints users, but
-	 * -EIO looks better for ptrace, since we refuse a register writing
-	 * for the user. And anyway this is the previous behaviour.
-	 */
-	if (IS_ERR(bp))
-		return PTR_ERR(bp);
 
-	t->ptrace_bps[nr] = bp;
 
 	return 0;
 }
diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 42da1ce..69f07a9 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -55,7 +55,7 @@ register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    struct task_struct *tsk);
 
 /* FIXME: only change from the attr, and don't unregister */
-extern struct perf_event *
+extern int
 modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr);
 
 /*
@@ -91,7 +91,7 @@ static inline struct perf_event *
 register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
 			    struct task_struct *tsk)	{ return NULL; }
-static inline struct perf_event *
+static inline int
 modify_user_hw_breakpoint(struct perf_event *bp,
 			  struct perf_event_attr *attr)	{ return NULL; }
 static inline struct perf_event *
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 7a67a64..da7bdc2 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -872,6 +872,8 @@ extern void perf_output_copy(struct perf_output_handle *handle,
 			     const void *buf, unsigned int len);
 extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
+extern void perf_event_enable(struct perf_event *event);
+extern void perf_event_disable(struct perf_event *event);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task, int cpu)		{ }
@@ -902,7 +904,8 @@ static inline void perf_event_fork(struct task_struct *tsk)		{ }
 static inline void perf_event_init(void)				{ }
 static inline int  perf_swevent_get_recursion_context(void)  { return -1; }
 static inline void perf_swevent_put_recursion_context(int rctx)		{ }
-
+static inline void perf_event_enable(struct perf_event *event)		{ }
+static inline void perf_event_disable(struct perf_event *event)		{ }
 #endif
 
 #define perf_output_put(handle, x) \
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index b102217..dbcbf6a 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -320,18 +320,40 @@ EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
  * @triggered: callback to trigger when we hit the breakpoint
  * @tsk: pointer to 'task_struct' of the process to which the address belongs
  */
-struct perf_event *
-modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr)
+int modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr)
 {
-	/*
-	 * FIXME: do it without unregistering
-	 * - We don't want to lose our slot
-	 * - If the new bp is incorrect, don't lose the older one
-	 */
-	unregister_hw_breakpoint(bp);
+	u64 old_addr = bp->attr.bp_addr;
+	int old_type = bp->attr.bp_type;
+	int old_len = bp->attr.bp_len;
+	int err = 0;
+
+	perf_event_disable(bp);
+
+	bp->attr.bp_addr = attr->bp_addr;
+	bp->attr.bp_type = attr->bp_type;
+	bp->attr.bp_len = attr->bp_len;
+
+	if (attr->disabled)
+		goto end;
 
-	return perf_event_create_kernel_counter(attr, -1, bp->ctx->task->pid,
-						bp->overflow_handler);
+	err = arch_validate_hwbkpt_settings(bp, bp->ctx->task);
+	if (!err)
+		perf_event_enable(bp);
+
+	if (err) {
+		bp->attr.bp_addr = old_addr;
+		bp->attr.bp_type = old_type;
+		bp->attr.bp_len = old_len;
+		if (!bp->attr.disabled)
+			perf_event_enable(bp);
+
+		return err;
+	}
+
+end:
+	bp->attr.disabled = attr->disabled;
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(modify_user_hw_breakpoint);
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 08f5718..35f102c 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -567,7 +567,7 @@ static void __perf_event_disable(void *info)
  * is the current context on this CPU and preemption is disabled,
  * hence we can't get into perf_event_task_sched_out for this context.
  */
-static void perf_event_disable(struct perf_event *event)
+void perf_event_disable(struct perf_event *event)
 {
 	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *task = ctx->task;
@@ -971,7 +971,7 @@ static void __perf_event_enable(void *info)
  * perf_event_for_each_child or perf_event_for_each as described
  * for perf_event_disable.
  */
-static void perf_event_enable(struct perf_event *event)
+void perf_event_enable(struct perf_event *event)
 {
 	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *task = ctx->task;
-- 
1.6.2.3

