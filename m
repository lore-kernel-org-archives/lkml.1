Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbXKUQAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbXKUQAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 11:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbXKUQAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 11:00:06 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:60024 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755175AbXKUQAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 11:00:05 -0500
Date: Wed, 21 Nov 2007 19:00:27 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 2/3] kill my_ptrace_child()
Message-ID: <20071121160027.GA1175@tv-sign.ru>
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

--- PT/kernel/exit.c~2_my_ptrace_child	2007-11-21 16:50:39.000000000 +0300
+++ PT/kernel/exit.c	2007-11-21 17:09:41.000000000 +0300
@@ -1508,12 +1508,6 @@ static int wait_task_continued(struct ta
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
@@ -1552,22 +1546,11 @@ repeat:
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

