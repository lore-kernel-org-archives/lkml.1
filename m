Return-Path: <linux-kernel-owner+w=401wt.eu-S1760675AbZE3WqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675AbZE3WqZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759384AbZE3Wn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:43:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48884 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759358AbZE3Wn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:43:26 -0400
Date: Sun, 31 May 2009 00:38:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 09/12 v3] ptrace: introduce ptrace_tracer() helper
Message-ID: <20090530223841.GA30514@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce ptrace_tracer() to simplify/cleanup the code which needs the
tracer and checks task_ptrace(). From now nobody else uses ->tracer
except ptrace_link/ptrace_unlink.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/ptrace.h |   17 ++++++++++++-----
 kernel/ptrace.c        |    2 +-
 kernel/signal.c        |   20 +++++++++-----------
 3 files changed, 22 insertions(+), 17 deletions(-)

--- PTRACE/include/linux/ptrace.h~09_PT_TRACER	2009-05-30 23:32:47.000000000 +0200
+++ PTRACE/include/linux/ptrace.h	2009-05-30 23:50:49.000000000 +0200
@@ -119,10 +119,17 @@ static inline int task_ptrace(struct tas
 		task->ptrace_ctx->flags : 0;
 }
 
-static inline int ptrace_reparented(struct task_struct *child)
+static inline struct task_struct *ptrace_tracer(struct task_struct *task)
 {
-	return unlikely(task_ptrace(child)) &&
-		child->ptrace_ctx->tracer != child->real_parent;
+	if (task->ptrace_ctx)
+		return task->ptrace_ctx->tracer;
+	return NULL;
+}
+
+static inline bool ptrace_reparented(struct task_struct *child)
+{
+	struct task_struct *tracer = ptrace_tracer(child);
+	return unlikely(tracer) && tracer != child->real_parent;
 }
 
 static inline void ptrace_unlink(struct task_struct *child)
@@ -170,9 +177,9 @@ static inline void ptrace_init_task(stru
 	INIT_LIST_HEAD(&child->ptrace_entry);
 	INIT_LIST_HEAD(&child->ptraced);
 
-	if (unlikely(child->ptrace_ctx) && task_ptrace(current))
+	if (unlikely(child->ptrace_ctx) && ptrace_tracer(current))
 		ptrace_link(child, task_ptrace(current),
-				current->ptrace_ctx->tracer);
+				ptrace_tracer(current));
 }
 
 /**
--- PTRACE/kernel/ptrace.c~09_PT_TRACER	2009-05-30 23:32:47.000000000 +0200
+++ PTRACE/kernel/ptrace.c	2009-05-30 23:55:26.000000000 +0200
@@ -108,7 +108,7 @@ int ptrace_check_attach(struct task_stru
 	 * be changed by us so it's not changing right after this.
 	 */
 	read_lock(&tasklist_lock);
-	if (task_ptrace(child) && child->ptrace_ctx->tracer == current) {
+	if (ptrace_tracer(child) == current) {
 		ret = 0;
 		/*
 		 * child->sighand can't be NULL, release_task()
--- PTRACE/kernel/signal.c~09_PT_TRACER	2009-05-30 23:32:47.000000000 +0200
+++ PTRACE/kernel/signal.c	2009-05-30 23:50:49.000000000 +0200
@@ -1411,10 +1411,7 @@ int do_notify_parent(struct task_struct 
 	BUG_ON(!task_ptrace(tsk) &&
 	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
 
-	if (task_ptrace(tsk))
-		parent = tsk->ptrace_ctx->tracer;
-	else
-		parent = tsk->real_parent;
+	parent = ptrace_tracer(tsk) ?: tsk->real_parent;
 
 	info.si_signo = sig;
 	info.si_errno = 0;
@@ -1489,9 +1486,8 @@ static void do_notify_parent_cldstop(str
 	struct task_struct *parent;
 	struct sighand_struct *sighand;
 
-	if (task_ptrace(tsk))
-		parent = tsk->ptrace_ctx->tracer;
-	else {
+	parent = ptrace_tracer(tsk);
+	if (likely(!parent)) {
 		tsk = tsk->group_leader;
 		parent = tsk->real_parent;
 	}
@@ -1538,7 +1534,9 @@ static void do_notify_parent_cldstop(str
 
 static inline int may_ptrace_stop(void)
 {
-	if (!likely(task_ptrace(current)))
+	struct task_struct *tracer = ptrace_tracer(current);
+
+	if (!likely(tracer))
 		return 0;
 	/*
 	 * Are we in the middle of do_coredump?
@@ -1550,7 +1548,7 @@ static inline int may_ptrace_stop(void)
 	 * is safe to enter schedule().
 	 */
 	if (unlikely(current->mm->core_state) &&
-	    unlikely(current->mm == current->ptrace_ctx->tracer->mm))
+	    unlikely(current->mm == tracer->mm))
 		return 0;
 
 	return 1;
@@ -1783,8 +1781,8 @@ static int ptrace_signal(int signr, sigi
 		info->si_code = SI_USER;
 
 		rcu_read_lock();
-		tracer = current->ptrace_ctx->tracer;
-		if (task_ptrace(current)) {
+		tracer = ptrace_tracer(current);
+		if (likely(tracer)) {
 			info->si_pid = task_pid_vnr(tracer);
 			info->si_uid = task_uid(tracer);
 		} else {

