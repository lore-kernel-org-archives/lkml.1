Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbZEEWyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbZEEWyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 18:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbZEEWxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 18:53:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60127 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377AbZEEWxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 18:53:24 -0400
Date: Wed, 6 May 2009 00:47:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ptrace: ptrace_attach: check PF_KTHREAD + exit_state
	instead of ->mm
Message-ID: <20090505224722.GA954@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Add PF_KTHREAD check to prevent attaching to the kernel thread
  with a borrowed ->mm.

  With or without this change we can race with daemonize() which
  can set PF_KTHREAD or clear ->mm after ptrace_attach() does the
  check, but this doesn't matter because reparent_to_kthreadd()
  does ptrace_unlink().

- Kill "!task->mm" check. We don't really care about ->mm != NULL,
  and the task can call exit_mm() right after we drop task_lock().
  What we need is to make sure we can't attach after exit_notify(),
  check task->exit_state != 0 instead.

Also, move the "already traced" check down for cosmetic reasons.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/ptrace.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- PTRACE/kernel/ptrace.c~1_KTHREADS	2009-05-05 21:37:26.000000000 +0200
+++ PTRACE/kernel/ptrace.c	2009-05-05 23:17:53.000000000 +0200
@@ -182,6 +182,8 @@ int ptrace_attach(struct task_struct *ta
 	audit_ptrace(task);
 
 	retval = -EPERM;
+	if (unlikely(task->flags & PF_KTHREAD))
+		goto out;
 	if (same_thread_group(task, current))
 		goto out;
 
@@ -191,8 +193,6 @@ int ptrace_attach(struct task_struct *ta
 	retval = mutex_lock_interruptible(&task->cred_exec_mutex);
 	if (retval  < 0)
 		goto out;
-
-	retval = -EPERM;
 repeat:
 	/*
 	 * Nasty, nasty.
@@ -212,23 +212,24 @@ repeat:
 		goto repeat;
 	}
 
-	if (!task->mm)
-		goto bad;
-	/* the same process cannot be attached many times */
-	if (task->ptrace & PT_PTRACED)
-		goto bad;
 	retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH);
 	if (retval)
 		goto bad;
 
-	/* Go */
+	retval = -EPERM;
+	if (unlikely(task->exit_state))
+		goto bad;
+	if (task->ptrace & PT_PTRACED)
+		goto bad;
+
 	task->ptrace |= PT_PTRACED;
 	if (capable(CAP_SYS_PTRACE))
 		task->ptrace |= PT_PTRACE_CAP;
 
 	__ptrace_link(task, current);
-
 	send_sig_info(SIGSTOP, SEND_SIG_FORCED, task);
+
+	retval = 0;
 bad:
 	write_unlock_irqrestore(&tasklist_lock, flags);
 	task_unlock(task);

