Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbZGATbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbZGATbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 15:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755821AbZGATb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 15:31:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56827 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072AbZGATb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 15:31:26 -0400
Date: Wed, 1 Jul 2009 21:28:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ptrace: __ptrace_detach: do __wake_up_parent() if we
	reap the tracee
Message-ID: <20090701192844.GA26624@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bug is old, it wasn't cause by recent changes.

Test case:

	static void *tfunc(void *arg)
	{
		int pid = (long)arg;

		assert(ptrace(PTRACE_ATTACH, pid, NULL, NULL) == 0);
		kill(pid, SIGKILL);

		sleep(1);
		return NULL;
	}

	int main(void)
	{
		pthread_t th;
		long pid = fork();

		if (!pid)
			pause();

		signal(SIGCHLD, SIG_IGN);
		assert(pthread_create(&th, NULL, tfunc, (void*)pid) == 0);

		int r = waitpid(-1, NULL, __WNOTHREAD);
		printf("waitpid: %d %m\n", r);

		return 0;
	}

Before the patch this program hangs, after this patch waitpid() correctly
fails with errno == -ECHILD.

The problem is, __ptrace_detach() reaps the EXIT_ZOMBIE tracee if its
->real_parent is our sub-thread and we ignore SIGCHLD. But in this case
we should wake up other threads which can sleep in do_wait().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h |    1 +
 kernel/signal.c       |    9 ---------
 kernel/exit.c         |    5 +++++
 kernel/ptrace.c       |   11 +++++++----
 4 files changed, 13 insertions(+), 13 deletions(-)

--- WAIT/include/linux/sched.h~PT_DETACH_WAKE_PARENT	2009-06-19 01:12:47.000000000 +0200
+++ WAIT/include/linux/sched.h	2009-07-01 20:20:57.000000000 +0200
@@ -1951,6 +1951,7 @@ extern int kill_pgrp(struct pid *pid, in
 extern int kill_pid(struct pid *pid, int sig, int priv);
 extern int kill_proc_info(int, struct siginfo *, pid_t);
 extern int do_notify_parent(struct task_struct *, int);
+extern void __wake_up_parent(struct task_struct *p, struct task_struct *parent);
 extern void force_sig(int, struct task_struct *);
 extern void force_sig_specific(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
--- WAIT/kernel/signal.c~PT_DETACH_WAKE_PARENT	2009-07-01 20:05:07.000000000 +0200
+++ WAIT/kernel/signal.c	2009-07-01 20:22:44.000000000 +0200
@@ -1383,15 +1383,6 @@ ret:
 }
 
 /*
- * Wake up any threads in the parent blocked in wait* syscalls.
- */
-static inline void __wake_up_parent(struct task_struct *p,
-				    struct task_struct *parent)
-{
-	wake_up_interruptible_sync(&parent->signal->wait_chldexit);
-}
-
-/*
  * Let a parent know about the death of a child.
  * For a stopped/continued status change, use do_notify_parent_cldstop instead.
  *
--- WAIT/kernel/exit.c~PT_DETACH_WAKE_PARENT	2009-07-01 20:05:11.000000000 +0200
+++ WAIT/kernel/exit.c	2009-07-01 20:23:42.000000000 +0200
@@ -1563,6 +1563,11 @@ static int ptrace_do_wait(struct wait_op
 	return 0;
 }
 
+void __wake_up_parent(struct task_struct *p, struct task_struct *parent)
+{
+	wake_up_interruptible_sync(&parent->signal->wait_chldexit);
+}
+
 static long do_wait(struct wait_opts *wo)
 {
 	DECLARE_WAITQUEUE(wait, current);
--- WAIT/kernel/ptrace.c~PT_DETACH_WAKE_PARENT	2009-07-01 19:59:01.000000000 +0200
+++ WAIT/kernel/ptrace.c	2009-07-01 20:52:58.000000000 +0200
@@ -266,9 +266,10 @@ static int ignoring_children(struct sigh
  * or self-reaping.  Do notification now if it would have happened earlier.
  * If it should reap itself, return true.
  *
- * If it's our own child, there is no notification to do.
- * But if our normal children self-reap, then this child
- * was prevented by ptrace and we must reap it now.
+ * If it's our own child, there is no notification to do. But if our normal
+ * children self-reap, then this child was prevented by ptrace and we must
+ * reap it now, in that case we must also wake up sub-threads sleeping in
+ * do_wait().
  */
 static bool __ptrace_detach(struct task_struct *tracer, struct task_struct *p)
 {
@@ -278,8 +279,10 @@ static bool __ptrace_detach(struct task_
 		if (!task_detached(p) && thread_group_empty(p)) {
 			if (!same_thread_group(p->real_parent, tracer))
 				do_notify_parent(p, p->exit_signal);
-			else if (ignoring_children(tracer->sighand))
+			else if (ignoring_children(tracer->sighand)) {
+				__wake_up_parent(p, tracer);
 				p->exit_signal = -1;
+			}
 		}
 		if (task_detached(p)) {
 			/* Mark it as in the process of being reaped. */

