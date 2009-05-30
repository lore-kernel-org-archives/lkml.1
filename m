Return-Path: <linux-kernel-owner+w=401wt.eu-S1760856AbZE3Wqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760856AbZE3Wqf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759406AbZE3Wne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:43:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48891 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759475AbZE3Wnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:43:33 -0400
Date: Sun, 31 May 2009 00:38:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 10/12 v3] ptrace: mv task_struct->last_siginfo
	ptrace_ctx->infop
Message-ID: <20090530223843.GA30521@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move task_struct->last_siginfo into ptrace_ctx->infop.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h  |    1 -
 include/linux/ptrace.h |    1 +
 kernel/ptrace.c        |    8 ++++----
 kernel/signal.c        |    8 ++++----
 4 files changed, 9 insertions(+), 9 deletions(-)

--- PTRACE/include/linux/sched.h~10_SIGINFO	2009-05-30 23:32:47.000000000 +0200
+++ PTRACE/include/linux/sched.h	2009-05-30 23:55:58.000000000 +0200
@@ -1348,7 +1348,6 @@ struct task_struct {
 	struct io_context *io_context;
 
 	unsigned long ptrace_message;
-	siginfo_t *last_siginfo; /* For ptrace use.  */
 	struct task_io_accounting ioac;
 #if defined(CONFIG_TASK_XACCT)
 	u64 acct_rss_mem1;	/* accumulated rss usage */
--- PTRACE/include/linux/ptrace.h~10_SIGINFO	2009-05-30 23:50:49.000000000 +0200
+++ PTRACE/include/linux/ptrace.h	2009-05-30 23:55:58.000000000 +0200
@@ -78,6 +78,7 @@
 struct ptrace_context {
 	unsigned long		flags;
 	struct task_struct	*tracer;
+	struct siginfo		*infop;
 };
 
 extern int alloc_ptrace_context(struct task_struct *child);
--- PTRACE/kernel/ptrace.c~10_SIGINFO	2009-05-30 23:55:47.000000000 +0200
+++ PTRACE/kernel/ptrace.c	2009-05-30 23:55:58.000000000 +0200
@@ -469,8 +469,8 @@ static int ptrace_getsiginfo(struct task
 
 	if (lock_task_sighand(child, &flags)) {
 		error = -EINVAL;
-		if (likely(child->last_siginfo != NULL)) {
-			*info = *child->last_siginfo;
+		if (likely(child->ptrace_ctx->infop != NULL)) {
+			*info = *child->ptrace_ctx->infop;
 			error = 0;
 		}
 		unlock_task_sighand(child, &flags);
@@ -485,8 +485,8 @@ static int ptrace_setsiginfo(struct task
 
 	if (lock_task_sighand(child, &flags)) {
 		error = -EINVAL;
-		if (likely(child->last_siginfo != NULL)) {
-			*child->last_siginfo = *info;
+		if (likely(child->ptrace_ctx->infop != NULL)) {
+			*child->ptrace_ctx->infop = *info;
 			error = 0;
 		}
 		unlock_task_sighand(child, &flags);
--- PTRACE/kernel/signal.c~10_SIGINFO	2009-05-30 23:50:49.000000000 +0200
+++ PTRACE/kernel/signal.c	2009-05-30 23:55:58.000000000 +0200
@@ -1568,7 +1568,7 @@ static int sigkill_pending(struct task_s
  * This must be called with current->sighand->siglock held.
  *
  * This should be the path for all ptrace stops.
- * We always set current->last_siginfo while stopped here.
+ * We always set ptrace_ctx->infop while stopped here.
  * That makes it a way to test a stopped process for
  * being ptrace-stopped vs being job-control-stopped.
  *
@@ -1603,7 +1603,7 @@ static void ptrace_stop(int exit_code, i
 	if (current->signal->group_stop_count > 0)
 		--current->signal->group_stop_count;
 
-	current->last_siginfo = info;
+	current->ptrace_ctx->infop = info;
 	current->exit_code = exit_code;
 
 	/* Let the debugger run.  */
@@ -1642,11 +1642,11 @@ static void ptrace_stop(int exit_code, i
 
 	/*
 	 * We are back.  Now reacquire the siglock before touching
-	 * last_siginfo, so that we are sure to have synchronized with
+	 * ->infop, so that we are sure to have synchronized with
 	 * any signal-sending on another CPU that wants to examine it.
 	 */
 	spin_lock_irq(&current->sighand->siglock);
-	current->last_siginfo = NULL;
+	current->ptrace_ctx->infop = NULL;
 
 	/*
 	 * Queued signals ignored us while we were stopped for tracing.

