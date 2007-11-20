Return-Path: <linux-kernel-owner+w=401wt.eu-S1757075AbXKTPW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbXKTPW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 10:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758300AbXKTPWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 10:22:07 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:43891 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759895AbXKTPWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 10:22:05 -0500
Date: Tue, 20 Nov 2007 18:21:36 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 2/2] kill my_ptrace_child()
Message-ID: <20071120152136.GA4549@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now that my_ptrace_child() is trivial we can use the "p->ptrace & PT_PTRACED"
inline and simplify the corresponding logic in do_wait: we can't find the child
in TASK_TRACED state without PT_PTRACED flag set, ptrace_untrace() either sets
TASK_STOPPED or wakes up the tracee.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/exit.c~2_my_ptrace_child	2007-11-20 17:21:52.000000000 +0300
+++ PT/kernel/exit.c	2007-11-20 17:54:07.000000000 +0300
@@ -1510,12 +1510,6 @@ static int wait_task_continued(struct ta
 	return retval;
 }
 
-
-static inline int my_ptrace_child(struct task_struct *p)
-{
-	return p->ptrace & PT_PTRACED;
-}
-
 static long do_wait(pid_t pid, int options, struct siginfo __user *infop,
 		    int __user *stat_addr, struct rusage __user *ru)
 {
@@ -1554,22 +1548,11 @@ repeat:
 				/*
 				 * It's stopped now, so it might later
 				 * continue, exit, or stop again.
-				 *
-				 * When we hit the race with PTRACE_ATTACH, we
-				 * will not report this child.  But the race
-				 * means it has not yet been moved to our
-				 * ptrace_children list, so we need to set the
-				 * flag here to avoid a spurious ECHILD when
-				 * the race happens with the only child.
 				 */
 				flag = 1;
-
-				if (!my_ptrace_child(p)) {
-					if (is_task_traced(p))
-						continue;
-					if (!(options & WUNTRACED))
-						continue;
-				}
+				if (!(p->ptrace & PT_PTRACED) &&
+				    !(options & WUNTRACED))
+					continue;
 
 				retval = wait_task_stopped(p, ret == 2,
 						(options & WNOWAIT), infop,

