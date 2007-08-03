Return-Path: <linux-kernel-owner+w=401wt.eu-S1763698AbXHCVEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763698AbXHCVEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 17:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758044AbXHCVEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 17:04:25 -0400
Received: from mail.screens.ru ([213.234.233.54]:34504 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756804AbXHCVEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 17:04:25 -0400
Date: Sat, 4 Aug 2007 01:04:41 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] kill an obsolete sub-thread-ptrace stuff
Message-ID: <20070803210441.GA247@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is a couple of subtle checks which were needed to handle ptracing from
the same thread group. This was deprecated a long ago, imho this code just
complicates the understanding.

And, the "->parent->signal->flags & SIGNAL_GROUP_EXIT" check in exit_notify()
is not right. SIGNAL_GROUP_EXIT can mean exec(), not exit_group(). This means
ptracer can lose a ptraced zombie on exec(). Minor problem, but still the bug.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/exit.c~PT_TG	2007-08-03 18:05:52.000000000 +0400
+++ t/kernel/exit.c	2007-08-03 21:10:40.000000000 +0400
@@ -802,7 +802,7 @@ static void exit_notify(struct task_stru
 		__kill_pgrp_info(SIGCONT, SEND_SIG_PRIV, pgrp);
 	}
 
-	/* Let father know we died 
+	/* Let father know we died
 	 *
 	 * Thread signals are configurable, but you aren't going to use
 	 * that to send signals to arbitary processes. 
@@ -815,9 +815,7 @@ static void exit_notify(struct task_stru
 	 * If our self_exec id doesn't match our parent_exec_id then
 	 * we have changed execution domain as these two values started
 	 * the same after a fork.
-	 *	
 	 */
-	
 	if (tsk->exit_signal != SIGCHLD && tsk->exit_signal != -1 &&
 	    ( tsk->parent_exec_id != t->self_exec_id  ||
 	      tsk->self_exec_id != tsk->parent_exec_id)
@@ -837,9 +835,7 @@ static void exit_notify(struct task_stru
 	}
 
 	state = EXIT_ZOMBIE;
-	if (tsk->exit_signal == -1 &&
-	    (likely(tsk->ptrace == 0) ||
-	     unlikely(tsk->parent->signal->flags & SIGNAL_GROUP_EXIT)))
+	if (tsk->exit_signal == -1 && likely(!tsk->ptrace))
 		state = EXIT_DEAD;
 	tsk->exit_state = state;
 
--- t/kernel/signal.c~PT_TG	2007-07-28 16:58:17.000000000 +0400
+++ t/kernel/signal.c	2007-08-03 21:11:59.000000000 +0400
@@ -1561,10 +1561,6 @@ static inline int may_ptrace_stop(void)
 		    (current->ptrace & PT_ATTACHED)))
 		return 0;
 
-	if (unlikely(current->signal == current->parent->signal) &&
-	    unlikely(current->signal->flags & SIGNAL_GROUP_EXIT))
-		return 0;
-
 	/*
 	 * Are we in the middle of do_coredump?
 	 * If so and our tracer is also part of the coredump stopping

