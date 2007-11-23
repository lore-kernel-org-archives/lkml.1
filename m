Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbXKWUAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbXKWUAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 15:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757366AbXKWUAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 15:00:45 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:56093 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360AbXKWUAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 15:00:44 -0500
Date: Fri, 23 Nov 2007 22:59:41 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 1/2] wait_task_stopped: remove unneeded delay_group_leader check
Message-ID: <20071123195941.GA163@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

wait_task_stopped() doesn't need the "delay_group_leader" parameter. If the
child is not traced it must be a group leader. With or without subthreads
->group_stop_count == 0 when the whole task is stopped.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/exit.c~5_ck_group_stop	2007-11-22 19:08:43.000000000 +0300
+++ PT/kernel/exit.c	2007-11-23 20:31:21.000000000 +0300
@@ -1348,7 +1348,7 @@ static int wait_task_zombie(struct task_
  * the lock and this task is uninteresting.  If we return nonzero, we have
  * released the lock and the system call should return.
  */
-static int wait_task_stopped(struct task_struct *p, int delayed_group_leader,
+static int wait_task_stopped(struct task_struct *p,
 			     int noreap, struct siginfo __user *infop,
 			     int __user *stat_addr, struct rusage __user *ru)
 {
@@ -1362,8 +1362,7 @@ static int wait_task_stopped(struct task
 	if (unlikely(!is_task_stopped_or_traced(p)))
 		goto unlock_sig;
 
-	if (delayed_group_leader && !(p->ptrace & PT_PTRACED) &&
-	    p->signal->group_stop_count > 0)
+	if (!(p->ptrace & PT_PTRACED) && p->signal->group_stop_count > 0)
 		/*
 		 * A group stop is in progress and this is the group leader.
 		 * We won't report until all threads have stopped.
@@ -1519,7 +1518,7 @@ repeat:
 				    !(options & WUNTRACED))
 					continue;
 
-				retval = wait_task_stopped(p, ret == 2,
+				retval = wait_task_stopped(p,
 						(options & WNOWAIT), infop,
 						stat_addr, ru);
 			} else if (p->exit_state == EXIT_ZOMBIE) {

