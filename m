Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbYFJQuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbYFJQuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 12:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbYFJQt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 12:49:26 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:37222 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbYFJQtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 12:49:25 -0400
Date: Tue, 10 Jun 2008 20:50:51 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ptrace && SIGKILL fixes
Message-ID: <20080610165051.GA6026@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These 2 patches don't depend on each other. Each change is user visible,
and I am not really sure it can't confuse debuggers/etc. The explicit
ack/nack from maintainers is wanted.

If the first patch won't get Roland's ack, the nasty TASK_TRACED check in
signal_pending_state() should die anyway. Something like the (incomplete)
patch below.

Oleg.

--- include/linux/sched.h
+++ include/linux/sched.h
@@ -173,8 +173,8 @@ extern unsigned long long time_sync_thre
 #define TASK_RUNNING		0
 #define TASK_INTERRUPTIBLE	1
 #define TASK_UNINTERRUPTIBLE	2
-#define __TASK_STOPPED		4
-#define __TASK_TRACED		8
+#define TASK_STOPPED		4
+#define TASK_TRACED		8
 /* in tsk->exit_state */
 #define EXIT_ZOMBIE		16
 #define EXIT_DEAD		32
@@ -184,8 +184,6 @@ extern unsigned long long time_sync_thre
 
 /* Convenience macros for the sake of set_task_state */
 #define TASK_KILLABLE		(TASK_WAKEKILL | TASK_UNINTERRUPTIBLE)
-#define TASK_STOPPED		(TASK_WAKEKILL | __TASK_STOPPED)
-#define TASK_TRACED		(TASK_WAKEKILL | __TASK_TRACED)
 
 /* Convenience macros for the sake of wake_up */
 #define TASK_NORMAL		(TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE)
@@ -2034,9 +2032,6 @@ static inline int signal_pending_state(l
 	if (!signal_pending(p))
 		return 0;
 
-	if (state & (__TASK_STOPPED | __TASK_TRACED))
-		return 0;
-
 	return (state & TASK_INTERRUPTIBLE) || __fatal_signal_pending(p);
 }
 
--- kernel/signal.c
+++ kernel/signal.c
@@ -496,7 +496,7 @@ void signal_wake_up(struct task_struct *
 	 */
 	mask = TASK_INTERRUPTIBLE;
 	if (resume)
-		mask |= TASK_WAKEKILL;
+		mask |= (TASK_WAKEKILL | TASK_STOPPED | TASK_TRACED);
 	if (!wake_up_state(t, mask))
 		kick_process(t);
 }

