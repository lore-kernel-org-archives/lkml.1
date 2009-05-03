Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbZECTBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbZECTBg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 15:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbZECTAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 15:00:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59472 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbZECTAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 15:00:47 -0400
Date: Sun, 3 May 2009 20:55:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ptrace: do not use task_lock() for attach
Message-ID: <20090503185549.GA17087@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the "Nasty, nasty" lock dance in ptrace_attach()/ptrace_traceme().
>From now task_lock() has nothing to do with ptrace at all.

With the recent changes nobody uses task_lock() to serialize with ptrace,
but in fact it was never needed and it was never used consistently.

However ptrace_attach() calls __ptrace_may_access() and needs task_lock()
to pin task->mm for get_dumpable(). But we can call __ptrace_may_access()
before we take tasklist_lock, ->cred_exec_mutex protects us against
do_execve() path which can change creds and MMF_DUMP* flags.

(ugly, but we can't use ptrace_may_access() because it hides the error
 code, so we have to take task_lock() and use __ptrace_may_access()).

Also, kill "if (!task->mm)" check. It buys nothing, we can attach to the
task right before it does exit_mm(). Instead, add PF_KTHREAD check to
prevent attaching to the kernel thread with a borrowed ->mm.

What we need is to make sure we can't attach after exit_notify(), check
task->exit_state.

And finally, move ptrace_traceme() up near ptrace_attach() to keep them
close to each other.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/ptrace.c |  127 ++++++++++++++++++++------------------------------------
 1 file changed, 47 insertions(+), 80 deletions(-)

--- PTRACE/kernel/ptrace.c~2_ATTACH	2009-05-03 19:30:15.000000000 +0200
+++ PTRACE/kernel/ptrace.c	2009-05-03 19:57:11.000000000 +0200
@@ -177,66 +177,79 @@ bool ptrace_may_access(struct task_struc
 int ptrace_attach(struct task_struct *task)
 {
 	int retval;
-	unsigned long flags;
 
 	audit_ptrace(task);
 
 	retval = -EPERM;
+	if (unlikely(task->flags & PF_KTHREAD))
+		goto out;
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
 
-	retval = -EPERM;
-repeat:
-	/*
-	 * Nasty, nasty.
-	 *
-	 * We want to hold both the task-lock and the
-	 * tasklist_lock for writing at the same time.
-	 * But that's against the rules (tasklist_lock
-	 * is taken for reading by interrupts on other
-	 * cpu's that may have task_lock).
-	 */
 	task_lock(task);
-	if (!write_trylock_irqsave(&tasklist_lock, flags)) {
-		task_unlock(task);
-		do {
-			cpu_relax();
-		} while (!write_can_lock(&tasklist_lock));
-		goto repeat;
-	}
-
-	if (!task->mm)
-		goto bad;
-	/* the same process cannot be attached many times */
-	if (task->ptrace & PT_PTRACED)
-		goto bad;
 	retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH);
+	task_unlock(task);
 	if (retval)
-		goto bad;
+		goto unlock_creds;
 
-	/* Go */
-	task->ptrace |= PT_PTRACED;
+	write_lock_irq(&tasklist_lock);
+	retval = -EPERM;
+	if (unlikely(task->exit_state))
+		goto unlock_tasklist;
+	if (task->ptrace)
+		goto unlock_tasklist;
+
+	task->ptrace = PT_PTRACED;
 	if (capable(CAP_SYS_PTRACE))
 		task->ptrace |= PT_PTRACE_CAP;
 
 	__ptrace_link(task, current);
 
 	send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
-bad:
-	write_unlock_irqrestore(&tasklist_lock, flags);
-	task_unlock(task);
+unlock_tasklist:
+	write_unlock_irq(&tasklist_lock);
+unlock_creds:
 	mutex_unlock(&task->cred_exec_mutex);
 out:
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
+	write_lock_irq(&tasklist_lock);
+	/* Are we already being traced? */
+	if (!current->ptrace) {
+		ret = security_ptrace_traceme(current->parent);
+		/*
+		 * Check PF_EXITING to ensure ->real_parent has not passed
+		 * exit_ptrace(). Otherwise we don't report the error but
+		 * pretend ->real_parent untraces us right after return.
+		 */
+		if (!ret && !(current->real_parent->flags & PF_EXITING)) {
+			current->ptrace = PT_PTRACED;
+			__ptrace_link(current, current->real_parent);
+		}
+	}
+	write_unlock_irq(&tasklist_lock);
+
+	return ret;
+}
+
 /*
  * Called with irqs disabled, returns true if childs should reap themselves.
  */
@@ -574,52 +587,6 @@ int ptrace_request(struct task_struct *c
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

