Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbXLHSh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbXLHSh5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 13:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbXLHShV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 13:37:21 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:42409 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbXLHShS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 13:37:18 -0500
Date: Sat, 8 Dec 2007 21:38:02 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC,PATCH 3/3] do_wait: fix waiting for stopped group with dead leader
Message-ID: <20071208183802.GA9946@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_wait(WSTOPPED) assumes that p->state must be == TASK_STOPPED, this is not
true if the leader is already dead. Check SIGNAL_STOP_STOPPED instead and use
->signal->group_exit_code.

This patch is not complete if not buggy. At the very minimum it needs cleanup.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/exit.c~6_wait_stop	2007-12-07 20:25:40.000000000 +0300
+++ PT/kernel/exit.c	2007-12-08 20:30:55.000000000 +0300
@@ -1316,6 +1316,11 @@ static int wait_task_zombie(struct task_
 	return retval;
 }
 
+static inline int is_task_wait_stopped(struct task_struct *p)
+{
+	return	is_task_stopped_or_traced(p) ||
+		(p->signal->flags & SIGNAL_STOP_STOPPED);
+}
 /*
  * Handle sys_wait4 work for one task in state TASK_STOPPED.  We hold
  * read_lock(&tasklist_lock) on entry.  If we return zero, we still hold
@@ -1326,29 +1331,28 @@ static int wait_task_stopped(struct task
 			     int noreap, struct siginfo __user *infop,
 			     int __user *stat_addr, struct rusage __user *ru)
 {
-	int retval, exit_code, why;
+	int retval, *p_code, exit_code, why;
 	uid_t uid = 0; /* unneeded, required by compiler */
 	pid_t pid;
 
 	exit_code = 0;
 	spin_lock_irq(&p->sighand->siglock);
+	if (p->ptrace & PT_PTRACED) {
+		if (!is_task_stopped_or_traced(p))
+			goto unlock_sig;
+		p_code = &p->exit_code;
+	} else {
+		if (!(p->signal->flags & SIGNAL_STOP_STOPPED))
+			goto unlock_sig;
+		p_code = &p->signal->group_exit_code;
+	}
 
-	if (unlikely(!is_task_stopped_or_traced(p)))
-		goto unlock_sig;
-
-	if (!(p->ptrace & PT_PTRACED) && p->signal->group_stop_count > 0)
-		/*
-		 * A group stop is in progress and this is the group leader.
-		 * We won't report until all threads have stopped.
-		 */
-		goto unlock_sig;
-
-	exit_code = p->exit_code;
+	exit_code = *p_code;
 	if (!exit_code)
 		goto unlock_sig;
 
 	if (!noreap)
-		p->exit_code = 0;
+		*p_code = 0;
 
 	uid = p->uid;
 unlock_sig:
@@ -1472,7 +1476,7 @@ repeat:
 
 			if (unlikely(ret < 0)) {
 				retval = ret;
-			} else if (is_task_stopped_or_traced(p)) {
+			} else if (is_task_wait_stopped(p)) {
 				/*
 				 * It's stopped now, so it might later
 				 * continue, exit, or stop again.

