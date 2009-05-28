Return-Path: <linux-kernel-owner+w=401wt.eu-S1761177AbZE1LnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761177AbZE1LnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 07:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbZE1Lkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 07:40:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57819 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756222AbZE1Lkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 07:40:39 -0400
Date: Thu, 28 May 2009 13:35:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 10/12 v2] ptrace: mv task_struct->last_siginfo
	ptrace_ctx->infop
Message-ID: <20090528113559.GA18722@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move task_struct->last_siginfo into ptrace_ctx->infop.

 include/linux/sched.h  |    1 -
 include/linux/ptrace.h |    1 +
 kernel/ptrace.c        |    8 ++++----
 kernel/signal.c        |    8 ++++----
 4 files changed, 9 insertions(+), 9 deletions(-)

--- PTRACE/include/linux/sched.h~9_SIGINFO	2009-05-28 10:03:01.000000000 +0200
+++ PTRACE/include/linux/sched.h	2009-05-28 10:45:59.000000000 +0200
@@ -1348,7 +1348,6 @@ struct task_struct {
 	struct io_context *io_context;
 
 	unsigned long ptrace_message;
-	siginfo_t *last_siginfo; /* For ptrace use.  */
 	struct task_io_accounting ioac;
 #if defined(CONFIG_TASK_XACCT)
 	u64 acct_rss_mem1;	/* accumulated rss usage */
--- PTRACE/include/linux/ptrace.h~9_SIGINFO	2009-05-28 10:03:01.000000000 +0200
+++ PTRACE/include/linux/ptrace.h	2009-05-28 11:59:06.000000000 +0200
@@ -78,6 +78,7 @@
 struct ptrace_context {
 	unsigned long		flags;
 	struct task_struct	*tracer;
+	struct siginfo		*infop;
 };
 
 extern int alloc_ptrace_context(struct task_struct *child);
--- PTRACE/kernel/ptrace.c~9_SIGINFO	2009-05-28 10:44:17.000000000 +0200
+++ PTRACE/kernel/ptrace.c	2009-05-28 11:29:45.000000000 +0200
@@ -468,8 +468,8 @@ static int ptrace_getsiginfo(struct task
 
 	if (lock_task_sighand(child, &flags)) {
 		error = -EINVAL;
-		if (likely(child->last_siginfo != NULL)) {
-			*info = *child->last_siginfo;
+		if (likely(child->ptrace_ctx->infop != NULL)) {
+			*info = *child->ptrace_ctx->infop;
 			error = 0;
 		}
 		unlock_task_sighand(child, &flags);
@@ -484,8 +484,8 @@ static int ptrace_setsiginfo(struct task
 
 	if (lock_task_sighand(child, &flags)) {
 		error = -EINVAL;
-		if (likely(child->last_siginfo != NULL)) {
-			*child->last_siginfo = *info;
+		if (likely(child->ptrace_ctx->infop != NULL)) {
+			*child->ptrace_ctx->infop = *info;
 			error = 0;
 		}
 		unlock_task_sighand(child, &flags);
--- PTRACE/kernel/signal.c~9_SIGINFO	2009-05-28 10:03:01.000000000 +0200
+++ PTRACE/kernel/signal.c	2009-05-28 11:24:21.000000000 +0200
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

