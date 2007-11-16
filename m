Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbXKPRY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbXKPRY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 12:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbXKPRYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 12:24:37 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:57181 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642AbXKPRYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:24:36 -0500
Date: Fri, 16 Nov 2007 20:24:13 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, Kees Cook <kees@ubuntu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] wait_task_stopped: tidy up the noreap case
Message-ID: <20071116172413.GA7296@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

wait_task_stopped(WNOWAIT) unlocks tasklist_lock and re-checks ->exit_code and
->exit_state. This is not needed: both were valid before we dropped the lock,
and without tasklist_lock both are not stable anyway.

Read the exit_code under tasklist and report the cached value without re-check.
In fact this fixes the race with the dying child, we can report a completely
false exit_code if ->exit_state is not visible yet.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 24/kernel/exit.c~2_NOREAP	2007-11-16 18:13:54.000000000 +0300
+++ 24/kernel/exit.c	2007-11-16 18:18:24.000000000 +0300
@@ -1356,10 +1356,10 @@ static int wait_task_stopped(struct task
 			     int noreap, struct siginfo __user *infop,
 			     int __user *stat_addr, struct rusage __user *ru)
 {
-	int retval, exit_code;
+	int retval, exit_code = p->exit_code;
 	pid_t pid;
 
-	if (!p->exit_code)
+	if (!exit_code)
 		return 0;
 	if (delayed_group_leader && !(p->ptrace & PT_PTRACED) &&
 	    p->signal->group_stop_count > 0)
@@ -1384,9 +1384,6 @@ static int wait_task_stopped(struct task
 		uid_t uid = p->uid;
 		int why = (p->ptrace & PT_PTRACED) ? CLD_TRAPPED : CLD_STOPPED;
 
-		exit_code = p->exit_code;
-		if (unlikely(!exit_code) || unlikely(p->exit_state))
-			goto bail_ref;
 		return wait_noreap_copyout(p, pid, uid,
 					   why, (exit_code << 8) | 0x7f,
 					   infop, ru);
@@ -1417,7 +1414,6 @@ static int wait_task_stopped(struct task
 		 * resumed, or it resumed and then died.
 		 */
 		write_unlock_irq(&tasklist_lock);
-bail_ref:
 		put_task_struct(p);
 		/*
 		 * We are returning to the wait loop without having successfully

