Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbZFAUUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbZFAUUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZFAUUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:20:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38766 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbZFAUUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:20:37 -0400
Date: Mon, 1 Jun 2009 22:15:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ptrace: tracehook_report_clone: fix false positives
Message-ID: <20090601201528.GA23437@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(does not depend on other -mm patches, perhaps for 2.6.30)

The "trace || CLONE_PTRACE" check in tracehook_report_clone() is not right,

- If the untraced task does clone(CLONE_PTRACE) the new child is not traced,
  we must not queue SIGSTOP.

- If we forked the traced task, but the tracer exits and untraces both the
  forking task and the new child (after copy_process() drops tasklist_lock),
  we should not queue SIGSTOP too.

Change the code to check task_ptrace() != 0 instead. This is still racy, but
the race is harmless.

We can race with another tracer attaching to this child, or the tracer can
exit and detach in parallel. But giwen that we didn't do wake_up_new_task()
yet, the child must have the pending SIGSTOP anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
---

 include/linux/tracehook.h |   11 +++++------
 kernel/fork.c             |    2 +-
 2 files changed, 6 insertions(+), 7 deletions(-)

--- PTRACE/include/linux/tracehook.h~REPORT_CLONE	2009-05-30 23:32:47.000000000 +0200
+++ PTRACE/include/linux/tracehook.h	2009-06-01 20:51:34.000000000 +0200
@@ -291,14 +291,12 @@ static inline void tracehook_finish_clon
 
 /**
  * tracehook_report_clone - in parent, new child is about to start running
- * @trace:		return value from tracehook_prepare_clone()
  * @regs:		parent's user register state
  * @clone_flags:	flags from parent's system call
  * @pid:		new child's PID in the parent's namespace
  * @child:		new child task
  *
- * Called after a child is set up, but before it has been started
- * running.  @trace is the value returned by tracehook_prepare_clone().
+ * Called after a child is set up, but before it has been started running.
  * This is not a good place to block, because the child has not started
  * yet.  Suspend the child here if desired, and then block in
  * tracehook_report_clone_complete().  This must prevent the child from
@@ -308,13 +306,14 @@ static inline void tracehook_finish_clon
  *
  * Called with no locks held, but the child cannot run until this returns.
  */
-static inline void tracehook_report_clone(int trace, struct pt_regs *regs,
+static inline void tracehook_report_clone(struct pt_regs *regs,
 					  unsigned long clone_flags,
 					  pid_t pid, struct task_struct *child)
 {
-	if (unlikely(trace) || unlikely(clone_flags & CLONE_PTRACE)) {
+	if (unlikely(task_ptrace(child))) {
 		/*
-		 * The child starts up with an immediate SIGSTOP.
+		 * It doesn't matter who attached/attaching to this
+		 * task, the pending SIGSTOP is right in any case.
 		 */
 		sigaddset(&child->pending.signal, SIGSTOP);
 		set_tsk_thread_flag(child, TIF_SIGPENDING);
--- PTRACE/kernel/fork.c~REPORT_CLONE	2009-05-30 23:05:12.000000000 +0200
+++ PTRACE/kernel/fork.c	2009-06-01 20:51:34.000000000 +0200
@@ -1413,7 +1413,7 @@ long do_fork(unsigned long clone_flags,
 		}
 
 		audit_finish_fork(p);
-		tracehook_report_clone(trace, regs, clone_flags, nr, p);
+		tracehook_report_clone(regs, clone_flags, nr, p);
 
 		/*
 		 * We set PF_STARTING at creation in case tracing wants to

