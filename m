Return-Path: <linux-kernel-owner+w=401wt.eu-S934426AbXJRW2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934426AbXJRW2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764975AbXJRWZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:25:49 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:54919 "EHLO
	mail-01.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759508AbXJRWZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:25:44 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 2/5] Use macros instead of TASK_ flags
Date: Thu, 18 Oct 2007 18:25:59 -0400
Message-Id: <11927463622621-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11927463623428-git-send-email-matthew@wil.cx>
References: <11927463623428-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Abstracting away direct uses of TASK_ flags allows us to change the
definitions of the task flags more easily.

Also restructure do_wait() a little

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 arch/ia64/kernel/perfmon.c |    4 +-
 fs/proc/array.c            |    9 +---
 fs/proc/base.c             |    2 +-
 include/linux/sched.h      |   15 +++++++
 include/linux/wait.h       |   11 +++--
 kernel/exit.c              |   90 +++++++++++++++++++------------------------
 kernel/power/process.c     |    7 +--
 kernel/ptrace.c            |    8 ++--
 kernel/sched.c             |   15 +++----
 kernel/signal.c            |    6 +-
 kernel/wait.c              |    2 +-
 11 files changed, 83 insertions(+), 86 deletions(-)

diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index f55fa07..6b0a6cf 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -2630,7 +2630,7 @@ pfm_task_incompatible(pfm_context_t *ctx, struct task_struct *task)
 	 */
 	if (task == current) return 0;
 
-	if ((task->state != TASK_STOPPED) && (task->state != TASK_TRACED)) {
+	if (!is_task_stopped_or_traced(task)) {
 		DPRINT(("cannot attach to non-stopped task [%d] state=%ld\n", task->pid, task->state));
 		return -EBUSY;
 	}
@@ -4790,7 +4790,7 @@ recheck:
 	 * the task must be stopped.
 	 */
 	if (PFM_CMD_STOPPED(cmd)) {
-		if ((task->state != TASK_STOPPED) && (task->state != TASK_TRACED)) {
+		if (!is_task_stopped_or_traced(task)) {
 			DPRINT(("[%d] task not in stopped state\n", task->pid));
 			return -EBUSY;
 		}
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 27b59f5..8939bf0 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -140,13 +140,8 @@ static const char *task_state_array[] = {
 
 static inline const char *get_task_state(struct task_struct *tsk)
 {
-	unsigned int state = (tsk->state & (TASK_RUNNING |
-					    TASK_INTERRUPTIBLE |
-					    TASK_UNINTERRUPTIBLE |
-					    TASK_STOPPED |
-					    TASK_TRACED)) |
-			(tsk->exit_state & (EXIT_ZOMBIE |
-					    EXIT_DEAD));
+	unsigned int state = (tsk->state & TASK_REPORT) |
+			(tsk->exit_state & (EXIT_ZOMBIE | EXIT_DEAD));
 	const char **p = &task_state_array[0];
 
 	while (state) {
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 4fe74d1..e7e1815 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -196,7 +196,7 @@ static int proc_root_link(struct inode *inode, struct dentry **dentry, struct vf
 	(task == current || \
 	(task->parent == current && \
 	(task->ptrace & PT_PTRACED) && \
-	 (task->state == TASK_STOPPED || task->state == TASK_TRACED) && \
+	 (is_task_stopped_or_traced(task)) && \
 	 security_ptrace(current,task) == 0))
 
 static int proc_pid_cmdline(struct task_struct *task, char * buffer)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c204ab0..5ef5253 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -177,6 +177,21 @@ print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 /* in tsk->state again */
 #define TASK_DEAD		64
 
+/* Convenience macros for the sake of wake_up */
+#define TASK_NORMAL		(TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE)
+#define TASK_ALL		(TASK_NORMAL | TASK_STOPPED | TASK_TRACED)
+
+/* get_task_state() */
+#define TASK_REPORT		(TASK_RUNNING | TASK_INTERRUPTIBLE | \
+				 TASK_UNINTERRUPTIBLE | TASK_STOPPED | \
+				 TASK_TRACED)
+
+#define is_task_traced(task)	((task->state & TASK_TRACED) != 0)
+#define is_task_stopped(task)	((task->state & TASK_STOPPED) != 0)
+#define is_task_stopped_or_traced(task)	\
+			((task->state & (TASK_STOPPED | TASK_TRACED)) != 0)
+#define is_task_loadavg(task)	((task->state & TASK_UNINTERRUPTIBLE) != 0)
+
 #define __set_task_state(tsk, state_value)		\
 	do { (tsk)->state = (state_value); } while (0)
 #define set_task_state(tsk, state_value)		\
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 0e68628..0a410a4 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -152,14 +152,15 @@ int FASTCALL(out_of_line_wait_on_bit(void *, int, int (*)(void *), unsigned));
 int FASTCALL(out_of_line_wait_on_bit_lock(void *, int, int (*)(void *), unsigned));
 wait_queue_head_t *FASTCALL(bit_waitqueue(void *, int));
 
-#define wake_up(x)			__wake_up(x, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE, 1, NULL)
-#define wake_up_nr(x, nr)		__wake_up(x, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE, nr, NULL)
-#define wake_up_all(x)			__wake_up(x, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE, 0, NULL)
+#define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL)
+#define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
+#define wake_up_all(x)			__wake_up(x, TASK_NORMAL, 0, NULL)
+#define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL)
+
 #define wake_up_interruptible(x)	__wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
 #define wake_up_interruptible_nr(x, nr)	__wake_up(x, TASK_INTERRUPTIBLE, nr, NULL)
 #define wake_up_interruptible_all(x)	__wake_up(x, TASK_INTERRUPTIBLE, 0, NULL)
-#define	wake_up_locked(x)		__wake_up_locked((x), TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE)
-#define wake_up_interruptible_sync(x)   __wake_up_sync((x),TASK_INTERRUPTIBLE, 1)
+#define wake_up_interruptible_sync(x)	__wake_up_sync((x), TASK_INTERRUPTIBLE, 1)
 
 #define __wait_event(wq, condition) 					\
 do {									\
diff --git a/kernel/exit.c b/kernel/exit.c
index 2c704c8..f3c6e8c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -249,7 +249,7 @@ static int has_stopped_jobs(struct pid *pgrp)
 	struct task_struct *p;
 
 	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
-		if (p->state != TASK_STOPPED)
+		if (!is_task_stopped(p))
 			continue;
 		retval = 1;
 		break;
@@ -613,7 +613,7 @@ reparent_thread(struct task_struct *p, struct task_struct *father, int traced)
 		p->parent = p->real_parent;
 		add_parent(p);
 
-		if (p->state == TASK_TRACED) {
+		if (is_task_traced(p)) {
 			/*
 			 * If it was at a trace stop, turn it into
 			 * a normal stop since it's no longer being
@@ -1354,7 +1354,7 @@ static int wait_task_stopped(struct task_struct *p, int delayed_group_leader,
 
 		exit_code = p->exit_code;
 		if (unlikely(!exit_code) ||
-		    unlikely(p->state & TASK_TRACED))
+		    unlikely(is_task_traced(p)))
 			goto bail_ref;
 		return wait_noreap_copyout(p, pid, uid,
 					   why, (exit_code << 8) | 0x7f,
@@ -1533,60 +1533,51 @@ repeat:
 			}
 			allowed = 1;
 
-			switch (p->state) {
-			case TASK_TRACED:
-				/*
-				 * When we hit the race with PTRACE_ATTACH,
-				 * we will not report this child.  But the
-				 * race means it has not yet been moved to
-				 * our ptrace_children list, so we need to
-				 * set the flag here to avoid a spurious ECHILD
-				 * when the race happens with the only child.
-				 */
-				flag = 1;
-				if (!my_ptrace_child(p))
-					continue;
-				/*FALLTHROUGH*/
-			case TASK_STOPPED:
+			if (is_task_stopped_or_traced(p)) {
 				/*
 				 * It's stopped now, so it might later
 				 * continue, exit, or stop again.
+				 *
+				 * When we hit the race with PTRACE_ATTACH, we
+				 * will not report this child.  But the race
+				 * means it has not yet been moved to our
+				 * ptrace_children list, so we need to set the
+				 * flag here to avoid a spurious ECHILD when
+				 * the race happens with the only child.
 				 */
 				flag = 1;
-				if (!(options & WUNTRACED) &&
-				    !my_ptrace_child(p))
-					continue;
+
+				if (!my_ptrace_child(p)) {
+					if (is_task_traced(p))
+						continue;
+					if (!(options & WUNTRACED))
+						continue;
+				}
+
 				retval = wait_task_stopped(p, ret == 2,
-							   (options & WNOWAIT),
-							   infop,
-							   stat_addr, ru);
+						(options & WNOWAIT), infop,
+						stat_addr, ru);
 				if (retval == -EAGAIN)
 					goto repeat;
 				if (retval != 0) /* He released the lock.  */
 					goto end;
-				break;
-			default:
-			// case EXIT_DEAD:
-				if (p->exit_state == EXIT_DEAD)
+			} else if (p->exit_state == EXIT_DEAD) {
+				continue;
+			} else if (p->exit_state == EXIT_ZOMBIE) {
+				/*
+				 * Eligible but we cannot release it yet:
+				 */
+				if (ret == 2)
+					goto check_continued;
+				if (!likely(options & WEXITED))
 					continue;
-			// case EXIT_ZOMBIE:
-				if (p->exit_state == EXIT_ZOMBIE) {
-					/*
-					 * Eligible but we cannot release
-					 * it yet:
-					 */
-					if (ret == 2)
-						goto check_continued;
-					if (!likely(options & WEXITED))
-						continue;
-					retval = wait_task_zombie(
-						p, (options & WNOWAIT),
-						infop, stat_addr, ru);
-					/* He released the lock.  */
-					if (retval != 0)
-						goto end;
-					break;
-				}
+				retval = wait_task_zombie(p,
+						(options & WNOWAIT), infop,
+						stat_addr, ru);
+				/* He released the lock.  */
+				if (retval != 0)
+					goto end;
+			} else {
 check_continued:
 				/*
 				 * It's running now, so it might later
@@ -1595,12 +1586,11 @@ check_continued:
 				flag = 1;
 				if (!unlikely(options & WCONTINUED))
 					continue;
-				retval = wait_task_continued(
-					p, (options & WNOWAIT),
-					infop, stat_addr, ru);
+				retval = wait_task_continued(p,
+						(options & WNOWAIT), infop,
+						stat_addr, ru);
 				if (retval != 0) /* He released the lock.  */
 					goto end;
-				break;
 			}
 		}
 		if (!flag) {
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 3434940..ac0c27a 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -83,10 +83,10 @@ static void freeze_task(struct task_struct *p)
 		rmb();
 		if (!frozen(p)) {
 			set_freeze_flag(p);
-			if (p->state == TASK_STOPPED)
+			if (is_task_stopped(p))
 				force_sig_specific(SIGSTOP, p);
 			spin_lock_irqsave(&p->sighand->siglock, flags);
-			signal_wake_up(p, p->state == TASK_STOPPED);
+			signal_wake_up(p, is_task_stopped(p));
 			spin_unlock_irqrestore(&p->sighand->siglock, flags);
 		}
 	}
@@ -120,8 +120,7 @@ static int try_to_freeze_tasks(int freeze_user_space)
 				continue;
 
 			if (freeze_user_space) {
-				if (p->state == TASK_TRACED &&
-				    frozen(p->parent)) {
+				if (is_task_traced(p) && frozen(p->parent)) {
 					cancel_freezing(p);
 					continue;
 				}
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index a73ebd3..7d1ef3b 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -50,7 +50,7 @@ void __ptrace_link(struct task_struct *child, struct task_struct *new_parent)
 void ptrace_untrace(struct task_struct *child)
 {
 	spin_lock(&child->sighand->siglock);
-	if (child->state == TASK_TRACED) {
+	if (is_task_traced(child)) {
 		if (child->signal->flags & SIGNAL_STOP_STOPPED) {
 			child->state = TASK_STOPPED;
 		} else {
@@ -78,7 +78,7 @@ void __ptrace_unlink(struct task_struct *child)
 		add_parent(child);
 	}
 
-	if (child->state == TASK_TRACED)
+	if (is_task_traced(child))
 		ptrace_untrace(child);
 }
 
@@ -102,9 +102,9 @@ int ptrace_check_attach(struct task_struct *child, int kill)
 	    && child->signal != NULL) {
 		ret = 0;
 		spin_lock_irq(&child->sighand->siglock);
-		if (child->state == TASK_STOPPED) {
+		if (is_task_stopped(child)) {
 			child->state = TASK_TRACED;
-		} else if (child->state != TASK_TRACED && !kill) {
+		} else if (!is_task_traced(child) && !kill) {
 			ret = -ESRCH;
 		}
 		spin_unlock_irq(&child->sighand->siglock);
diff --git a/kernel/sched.c b/kernel/sched.c
index 92721d1..04f6141 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -961,7 +961,7 @@ static int effective_prio(struct task_struct *p)
  */
 static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
 {
-	if (p->state == TASK_UNINTERRUPTIBLE)
+	if (is_task_loadavg(p))
 		rq->nr_uninterruptible--;
 
 	enqueue_task(rq, p, wakeup);
@@ -973,7 +973,7 @@ static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
  */
 static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep)
 {
-	if (p->state == TASK_UNINTERRUPTIBLE)
+	if (is_task_loadavg(p))
 		rq->nr_uninterruptible++;
 
 	dequeue_task(rq, p, sleep);
@@ -1609,8 +1609,7 @@ out:
 
 int fastcall wake_up_process(struct task_struct *p)
 {
-	return try_to_wake_up(p, TASK_STOPPED | TASK_TRACED |
-				 TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE, 0);
+	return try_to_wake_up(p, TASK_ALL, 0);
 }
 EXPORT_SYMBOL(wake_up_process);
 
@@ -3786,8 +3785,7 @@ void fastcall complete(struct completion *x)
 
 	spin_lock_irqsave(&x->wait.lock, flags);
 	x->done++;
-	__wake_up_common(&x->wait, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE,
-			 1, 0, NULL);
+	__wake_up_common(&x->wait, TASK_NORMAL, 1, 0, NULL);
 	spin_unlock_irqrestore(&x->wait.lock, flags);
 }
 EXPORT_SYMBOL(complete);
@@ -3798,8 +3796,7 @@ void fastcall complete_all(struct completion *x)
 
 	spin_lock_irqsave(&x->wait.lock, flags);
 	x->done += UINT_MAX/2;
-	__wake_up_common(&x->wait, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE,
-			 0, 0, NULL);
+	__wake_up_common(&x->wait, TASK_NORMAL, 0, 0, NULL);
 	spin_unlock_irqrestore(&x->wait.lock, flags);
 }
 EXPORT_SYMBOL(complete_all);
@@ -5172,7 +5169,7 @@ static void activate_idle_task(struct task_struct *p, struct rq *rq)
 {
 	update_rq_clock(rq);
 
-	if (p->state == TASK_UNINTERRUPTIBLE)
+	if (is_task_loadavg(p))
 		rq->nr_uninterruptible--;
 
 	enqueue_task(rq, p, 0);
diff --git a/kernel/signal.c b/kernel/signal.c
index 2124ffa..16c16a3 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -839,7 +839,7 @@ static inline int wants_signal(int sig, struct task_struct *p)
 		return 0;
 	if (sig == SIGKILL)
 		return 1;
-	if (p->state & (TASK_STOPPED | TASK_TRACED))
+	if (is_task_stopped_or_traced(p))
 		return 0;
 	return task_curr(p) || !signal_pending(p);
 }
@@ -1437,7 +1437,7 @@ void do_notify_parent(struct task_struct *tsk, int sig)
 	BUG_ON(sig == -1);
 
  	/* do_notify_parent_cldstop should have been called instead.  */
- 	BUG_ON(tsk->state & (TASK_STOPPED|TASK_TRACED));
+ 	BUG_ON(is_task_stopped_or_traced(tsk));
 
 	BUG_ON(!tsk->ptrace &&
 	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
@@ -1704,7 +1704,7 @@ static int do_signal_stop(int signr)
 			 * so this check has no races.
 			 */
 			if (!t->exit_state &&
-			    !(t->state & (TASK_STOPPED|TASK_TRACED))) {
+			    !is_task_stopped_or_traced(t)) {
 				stop_count++;
 				signal_wake_up(t, 0);
 			}
diff --git a/kernel/wait.c b/kernel/wait.c
index 444ddbf..f987688 100644
--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -215,7 +215,7 @@ void fastcall __wake_up_bit(wait_queue_head_t *wq, void *word, int bit)
 {
 	struct wait_bit_key key = __WAIT_BIT_KEY_INITIALIZER(word, bit);
 	if (waitqueue_active(wq))
-		__wake_up(wq, TASK_INTERRUPTIBLE|TASK_UNINTERRUPTIBLE, 1, &key);
+		__wake_up(wq, TASK_NORMAL, 1, &key);
 }
 EXPORT_SYMBOL(__wake_up_bit);
 
-- 
1.4.4.2

