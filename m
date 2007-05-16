Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbXEPUEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbXEPUEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 16:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbXEPUEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 16:04:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756943AbXEPUEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 16:04:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Cc: Steve.Hawkes@motorola.com
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH] recalc_sigpending_tsk fixes
In-Reply-To: <7BFDACCD6948EF4D8FE8F4888A91596A01636E70@tx14exm60.ds.mot.com>
X-Zippy-Says: ..  here I am in 53 B.C. and all I want is a dill pickle!!
Message-Id: <20070516200324.835BC1F8509@magilla.localdomain>
Date: Wed, 16 May 2007 13:03:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Steve Hawkes discovered a problem where recalc_sigpending_tsk was called in
do_sigaction but no signal_wake_up call was made, preventing later signals
from waking up blocked threads with TIF_SIGPENDING already set.

In fact, the few other calls to recalc_sigpending_tsk outside the signals
code are also subject to this problem in other race conditions.

This change makes recalc_sigpending_tsk private to the signals code.
It changes the outside calls, as well as do_sigaction, to use the new
recalc_sigpending_and_wake instead.

Signed-off-by: Roland McGrath <roland@redhat.com>
CC: Steve.Hawkes@motorola.com
CC: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/sched.h  |   22 ++++++++++++----------
 kernel/exit.c          |    7 ++-----
 kernel/power/process.c |    2 +-
 kernel/signal.c        |   48 ++++++++++++++++++++++++++++++------------------
 4 files changed, 45 insertions(+), 34 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a81897e..2ae8859 100644  
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1615,11 +1615,13 @@ static inline int lock_need_resched(spin
 	return 0;
 }
 
-/* Reevaluate whether the task has signals pending delivery.
-   This is required every time the blocked sigset_t changes.
-   callers must hold sighand->siglock.  */
-
-extern FASTCALL(void recalc_sigpending_tsk(struct task_struct *t));
+/*
+ * Reevaluate whether the task has signals pending delivery.
+ * Wake the task if so.
+ * This is required every time the blocked sigset_t changes.
+ * callers must hold sighand->siglock.
+ */
+extern void recalc_sigpending_and_wake(struct task_struct *t);
 extern void recalc_sigpending(void);
 
 extern void signal_wake_up(struct task_struct *t, int resume_stopped);
diff --git a/kernel/exit.c b/kernel/exit.c
index c6d14b8..5b888c2 100644  
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -762,11 +762,8 @@ static void exit_notify(struct task_stru
 		read_lock(&tasklist_lock);
 		spin_lock_irq(&tsk->sighand->siglock);
 		for (t = next_thread(tsk); t != tsk; t = next_thread(t))
-			if (!signal_pending(t) && !(t->flags & PF_EXITING)) {
-				recalc_sigpending_tsk(t);
-				if (signal_pending(t))
-					signal_wake_up(t, 0);
-			}
+			if (!signal_pending(t) && !(t->flags & PF_EXITING))
+				recalc_sigpending_and_wake(t);
 		spin_unlock_irq(&tsk->sighand->siglock);
 		read_unlock(&tasklist_lock);
 	}
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 0884193..6685eb7 100644  
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -81,7 +81,7 @@ static void cancel_freezing(struct task_
 		pr_debug("  clean up: %s\n", p->comm);
 		do_not_freeze(p);
 		spin_lock_irqsave(&p->sighand->siglock, flags);
-		recalc_sigpending_tsk(p);
+		recalc_sigpending_and_wake(p);
 		spin_unlock_irqrestore(&p->sighand->siglock, flags);
 	}
 }
diff --git a/kernel/signal.c b/kernel/signal.c
index 364fc95..0ab3213 100644  
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -96,15 +96,27 @@ static inline int has_pending_signals(si
 
 #define PENDING(p,b) has_pending_signals(&(p)->signal, (b))
 
-fastcall void recalc_sigpending_tsk(struct task_struct *t)
+static int recalc_sigpending_tsk(struct task_struct *t)
 {
 	if (t->signal->group_stop_count > 0 ||
 	    (freezing(t)) ||
 	    PENDING(&t->pending, &t->blocked) ||
-	    PENDING(&t->signal->shared_pending, &t->blocked))
+	    PENDING(&t->signal->shared_pending, &t->blocked)) {
 		set_tsk_thread_flag(t, TIF_SIGPENDING);
-	else
-		clear_tsk_thread_flag(t, TIF_SIGPENDING);
+		return 1;
+	}
+	clear_tsk_thread_flag(t, TIF_SIGPENDING);
+	return 0;
+}
+
+/*
+ * After recalculating TIF_SIGPENDING, we need to make sure the task wakes up.
+ * This is superfluous when called on current, the wakeup is a harmless no-op.
+ */
+void recalc_sigpending_and_wake(struct task_struct *t)
+{
+	if (recalc_sigpending_tsk(t))
+		signal_wake_up(t, 0);
 }
 
 void recalc_sigpending(void)
@@ -744,7 +756,7 @@ force_sig_info(int sig, struct siginfo *
 		action->sa.sa_handler = SIG_DFL;
 		if (blocked) {
 			sigdelset(&t->blocked, sig);
-			recalc_sigpending_tsk(t);
+			recalc_sigpending_and_wake(t);
 		}
 	}
 	ret = specific_send_sig_info(sig, info, t);
@@ -2273,7 +2285,7 @@ int do_sigaction(int sig, struct k_sigac
 			rm_from_queue_full(&mask, &t->signal->shared_pending);
 			do {
 				rm_from_queue_full(&mask, &t->pending);
-				recalc_sigpending_tsk(t);
+				recalc_sigpending_and_wake(t);
 				t = next_thread(t);
 			} while (t != current);
 		}
