Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbZEEWxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbZEEWxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 18:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbZEEWxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 18:53:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60125 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbZEEWxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 18:53:09 -0400
Date: Wed, 6 May 2009 00:47:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ptrace: do not use task_lock() for attach
Message-ID: <20090505224729.GA965@redhat.com>
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

NOTE: this change assumes that LSM hooks, security_ptrace_may_access() and
security_ptrace_traceme(), can be called without task_lock() held.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/ptrace.c |   59 ++++++++++++--------------------------------------------
 1 file changed, 13 insertions(+), 46 deletions(-)

--- PTRACE/kernel/ptrace.c~3_TASK_LOCK	2009-05-05 23:49:15.000000000 +0200
+++ PTRACE/kernel/ptrace.c	2009-05-06 00:16:17.000000000 +0200
@@ -177,7 +177,6 @@ bool ptrace_may_access(struct task_struc
 int ptrace_attach(struct task_struct *task)
 {
 	int retval;
-	unsigned long flags;
 
 	audit_ptrace(task);
 
@@ -193,34 +192,19 @@ int ptrace_attach(struct task_struct *ta
 	retval = mutex_lock_interruptible(&task->cred_exec_mutex);
 	if (retval < 0)
 		goto out;
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
-	task_lock(task);
-	if (!write_trylock_irqsave(&tasklist_lock, flags)) {
-		task_unlock(task);
-		do {
-			cpu_relax();
-		} while (!write_can_lock(&tasklist_lock));
-		goto repeat;
-	}
 
+	task_lock(task);
 	retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH);
+	task_unlock(task);
 	if (retval)
-		goto bad;
+		goto unlock_creds;
 
+	write_lock_irq(&tasklist_lock);
 	retval = -EPERM;
 	if (unlikely(task->exit_state))
-		goto bad;
+		goto unlock_tasklist;
 	if (task->ptrace)
-		goto bad;
+		goto unlock_tasklist;
 
 	task->ptrace = PT_PTRACED;
 	if (capable(CAP_SYS_PTRACE))
@@ -230,9 +214,9 @@ repeat:
 	send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
 
 	retval = 0;
-bad:
-	write_unlock_irqrestore(&tasklist_lock, flags);
-	task_unlock(task);
+unlock_tasklist:
+	write_unlock_irq(&tasklist_lock);
+unlock_creds:
 	mutex_unlock(&task->cred_exec_mutex);
 out:
 	return retval;
@@ -248,26 +232,10 @@ int ptrace_traceme(void)
 {
 	int ret = -EPERM;
 
-	/*
-	 * Are we already being traced?
-	 */
-repeat:
-	task_lock(current);
+	write_lock_irq(&tasklist_lock);
+	/* Are we already being traced? */
 	if (!current->ptrace) {
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
 		ret = security_ptrace_traceme(current->parent);
-
 		/*
 		 * Check PF_EXITING to ensure ->real_parent has not passed
 		 * exit_ptrace(). Otherwise we don't report the error but
@@ -277,10 +245,9 @@ repeat:
 			current->ptrace = PT_PTRACED;
 			__ptrace_link(current, current->real_parent);
 		}
-
-		write_unlock_irqrestore(&tasklist_lock, flags);
 	}
-	task_unlock(current);
+	write_unlock_irq(&tasklist_lock);
+
 	return ret;
 }
 

