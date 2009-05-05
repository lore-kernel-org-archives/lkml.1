Return-Path: <linux-kernel-owner+w=401wt.eu-S1752923AbZEEWxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbZEEWxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 18:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbZEEWxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 18:53:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60128 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbZEEWxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 18:53:23 -0400
Date: Wed, 6 May 2009 00:47:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ptrace: cleanup check/set of PT_PTRACED during attach
Message-ID: <20090505224727.GA958@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace_attach() and ptrace_traceme() are the last functions which look as
if the untraced task can have task->ptrace != 0, this must not be possible.
Change the code to just check ->ptrace != 0 and s/|=/=/ to set PT_PTRACED.

Also, a couple of trivial whitespace cleanups in ptrace_attach().

And move ptrace_traceme() up near ptrace_attach() to keep them close to each
other.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/ptrace.c |  102 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 51 insertions(+), 51 deletions(-)

--- PTRACE/kernel/ptrace.c~2_PTRACE	2009-05-05 23:17:53.000000000 +0200
+++ PTRACE/kernel/ptrace.c	2009-05-05 23:49:15.000000000 +0200
@@ -186,12 +186,12 @@ int ptrace_attach(struct task_struct *ta
 		goto out;
 	if (same_thread_group(task, current))
 		goto out;
-
-	/* Protect exec's credential calculations against our interference;
+	/*
+	 * Protect exec's credential calculations against our interference;
 	 * SUID, SGID and LSM creds get determined differently under ptrace.
 	 */
 	retval = mutex_lock_interruptible(&task->cred_exec_mutex);
-	if (retval  < 0)
+	if (retval < 0)
 		goto out;
 repeat:
 	/*
@@ -219,10 +219,10 @@ repeat:
 	retval = -EPERM;
 	if (unlikely(task->exit_state))
 		goto bad;
-	if (task->ptrace & PT_PTRACED)
+	if (task->ptrace)
 		goto bad;
 
-	task->ptrace |= PT_PTRACED;
+	task->ptrace = PT_PTRACED;
 	if (capable(CAP_SYS_PTRACE))
 		task->ptrace |= PT_PTRACE_CAP;
 
@@ -238,6 +238,52 @@ out:
 	return retval;
 }
 
+/**
+ * ptrace_traceme  --  helper for PTRACE_TRACEME
+ *
+ * Performs checks and sets PT_PTRACED.
+ * Should be used by all ptrace implementations for PTRACE_TRACEME.
+ */
+int ptrace_traceme(void)
+{
+	int ret = -EPERM;
+
+	/*
+	 * Are we already being traced?
+	 */
+repeat:
+	task_lock(current);
+	if (!current->ptrace) {
+		/*
+		 * See ptrace_attach() comments about the locking here.
+		 */
+		unsigned long flags;
+		if (!write_trylock_irqsave(&tasklist_lock, flags)) {
+			task_unlock(current);
+			do {
+				cpu_relax();
+			} while (!write_can_lock(&tasklist_lock));
+			goto repeat;
+		}
+
+		ret = security_ptrace_traceme(current->parent);
+
+		/*
+		 * Check PF_EXITING to ensure ->real_parent has not passed
+		 * exit_ptrace(). Otherwise we don't report the error but
+		 * pretend ->real_parent untraces us right after return.
+		 */
+		if (!ret && !(current->real_parent->flags & PF_EXITING)) {
+			current->ptrace = PT_PTRACED;
+			__ptrace_link(current, current->real_parent);
+		}
+
+		write_unlock_irqrestore(&tasklist_lock, flags);
+	}
+	task_unlock(current);
+	return ret;
+}
+
 /*
  * Called with irqs disabled, returns true if childs should reap themselves.
  */
@@ -575,52 +621,6 @@ int ptrace_request(struct task_struct *c
 }
 
 /**
- * ptrace_traceme  --  helper for PTRACE_TRACEME
- *
- * Performs checks and sets PT_PTRACED.
- * Should be used by all ptrace implementations for PTRACE_TRACEME.
- */
-int ptrace_traceme(void)
-{
-	int ret = -EPERM;
-
-	/*
-	 * Are we already being traced?
-	 */
-repeat:
-	task_lock(current);
-	if (!(current->ptrace & PT_PTRACED)) {
-		/*
-		 * See ptrace_attach() comments about the locking here.
-		 */
-		unsigned long flags;
-		if (!write_trylock_irqsave(&tasklist_lock, flags)) {
-			task_unlock(current);
-			do {
-				cpu_relax();
-			} while (!write_can_lock(&tasklist_lock));
-			goto repeat;
-		}
-
-		ret = security_ptrace_traceme(current->parent);
-
-		/*
-		 * Check PF_EXITING to ensure ->real_parent has not passed
-		 * exit_ptrace(). Otherwise we don't report the error but
-		 * pretend ->real_parent untraces us right after return.
-		 */
-		if (!ret && !(current->real_parent->flags & PF_EXITING)) {
-			current->ptrace |= PT_PTRACED;
-			__ptrace_link(current, current->real_parent);
-		}
-
-		write_unlock_irqrestore(&tasklist_lock, flags);
-	}
-	task_unlock(current);
-	return ret;
-}
-
-/**
  * ptrace_get_task_struct  --  grab a task struct reference for ptrace
  * @pid:       process id to grab a task_struct reference of
  *

