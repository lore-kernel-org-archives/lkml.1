Return-Path: <linux-kernel-owner+w=401wt.eu-S1758072AbYC2De5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbYC2De5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbYC2Det
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:34:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877AbYC2Des (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:34:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 1/2] do_wait reorganization
X-Zippy-Says: RELATIVES!!
Message-Id: <20080329033412.120EE26FA1D@magilla.localdomain>
Date: Fri, 28 Mar 2008 20:34:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This breaks out the guts of do_wait into two subfunctions.
The control flow is less nonobvious without so much goto.
do_wait_thread contains the main work of the outer loop.
wait_consider_task contains the main work of the inner loop.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 kernel/exit.c |  191 +++++++++++++++++++++++++++++++++++----------------------
 1 files changed, 118 insertions(+), 73 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 53872bf..f2cf0a1 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1442,89 +1442,136 @@ static int wait_task_continued(struct task_struct *p, int noreap,
 	return retval;
 }
 
+/*
+ * Consider @p for a wait by @parent.
+ *
+ * -ECHILD should be in *@retval before the first call.
+ * Returns nonzero if we have unlocked tasklist_lock and have
+ * the final return value ready in *@retval.  Returns zero if
+ * the search for a child should continue; then *@retval is 0
+ * if @p is an eligible child, or still -ECHILD.
+ */
+static int wait_consider_task(struct task_struct *parent,
+			      struct task_struct *p, int *retval,
+			      enum pid_type type, struct pid *pid, int options,
+			      struct siginfo __user *infop,
+			      int __user *stat_addr, struct rusage __user *ru)
+{
+	int ret = eligible_child(type, pid, options, p);
+	if (!ret)
+		return 0;
+
+	if (unlikely(ret < 0)) {
+		read_unlock(&tasklist_lock);
+		*retval = ret;
+		return 1;
+	}
+
+	if (task_is_stopped_or_traced(p)) {
+		/*
+		 * It's stopped now, so it might later
+		 * continue, exit, or stop again.
+		 */
+		*retval = 0;
+		if ((p->ptrace & PT_PTRACED) ||
+		    (options & WUNTRACED)) {
+			*retval = wait_task_stopped(p, (options & WNOWAIT),
+						    infop, stat_addr, ru);
+			if (*retval)
+				return 1;
+		}
+	} else if (p->exit_state == EXIT_ZOMBIE && !delay_group_leader(p)) {
+		/*
+		 * We don't reap group leaders with subthreads.
+		 */
+		if (likely(options & WEXITED)) {
+			*retval = wait_task_zombie(p, (options & WNOWAIT),
+						   infop, stat_addr, ru);
+			if (*retval)
+				return 1;
+		}
+	} else if (p->exit_state != EXIT_DEAD) {
+		/*
+		 * It's running now, so it might later
+		 * exit, stop, or stop and then continue.
+		 */
+		*retval = 0;
+		if (unlikely(options & WCONTINUED)) {
+			*retval = wait_task_continued(p, (options & WNOWAIT),
+						      infop, stat_addr, ru);
+			if (*retval)
+				return 1;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Do the work of do_wait() for one thread in the group, @tsk.
+ * -ECHILD should be in *@retval before the first call.
+ * Returns nonzero if we have unlocked tasklist_lock and have
+ * the final return value ready in *@retval.
+ * Returns zero if the search for a child should continue; then
+ * *@retval is 0 if there are any eligible children, or still -ECHILD.
+ */
+static int do_wait_thread(struct task_struct *tsk, int *retval,
+			  enum pid_type type, struct pid *pid, int options,
+			  struct siginfo __user *infop, int __user *stat_addr,
+			  struct rusage __user *ru)
+{
+	struct task_struct *p;
+
+	list_for_each_entry(p, &tsk->children, sibling) {
+		if (wait_consider_task(tsk, p, retval, type, pid, options,
+				       infop, stat_addr, ru))
+			return 1;
+	}
+
+	/*
+	 * If we never saw an eligile child, check for children stolen by
+	 * ptrace.  We don't leave -ECHILD in *@retval if there are any,
+	 * because we will eventually be allowed to wait for them again.
+	 */
+	if (*retval)
+		list_for_each_entry(p, &tsk->ptrace_children, ptrace_list) {
+			int ret = eligible_child(type, pid, options, p);
+			if (ret) {
+				*retval = unlikely(ret < 0) ? ret : 0;
+				break;
+			}
+		}
+
+	return 0;
+}
+
 static long do_wait(enum pid_type type, struct pid *pid, int options,
 		    struct siginfo __user *infop, int __user *stat_addr,
 		    struct rusage __user *ru)
 {
 	DECLARE_WAITQUEUE(wait, current);
 	struct task_struct *tsk;
-	int flag, retval;
+	int retval;
 
 	add_wait_queue(&current->signal->wait_chldexit,&wait);
 repeat:
-	/* If there is nothing that can match our critier just get out */
+	/*
+	 * If there is nothing that can match our critiera just get out.
+	 * We will clear @retval to zero if we see any child that might later
+	 * match our criteria, even if we are not able to reap it yet.
+	 */
 	retval = -ECHILD;
 	if ((type < PIDTYPE_MAX) && (!pid || hlist_empty(&pid->tasks[type])))
 		goto end;
 
-	/*
-	 * We will set this flag if we see any child that might later
-	 * match our criteria, even if we are not able to reap it yet.
-	 */
-	flag = retval = 0;
 	current->state = TASK_INTERRUPTIBLE;
 	read_lock(&tasklist_lock);
 	tsk = current;
 	do {
-		struct task_struct *p;
+		if (do_wait_thread(tsk, &retval, type, pid, options,
+				   infop, stat_addr, ru))
+			goto end;
 
-		list_for_each_entry(p, &tsk->children, sibling) {
-			int ret = eligible_child(type, pid, options, p);
-			if (!ret)
-				continue;
-
-			if (unlikely(ret < 0)) {
-				retval = ret;
-			} else if (task_is_stopped_or_traced(p)) {
-				/*
-				 * It's stopped now, so it might later
-				 * continue, exit, or stop again.
-				 */
-				flag = 1;
-				if (!(p->ptrace & PT_PTRACED) &&
-				    !(options & WUNTRACED))
-					continue;
-
-				retval = wait_task_stopped(p,
-						(options & WNOWAIT), infop,
-						stat_addr, ru);
-			} else if (p->exit_state == EXIT_ZOMBIE &&
-					!delay_group_leader(p)) {
-				/*
-				 * We don't reap group leaders with subthreads.
-				 */
-				if (!likely(options & WEXITED))
-					continue;
-				retval = wait_task_zombie(p,
-						(options & WNOWAIT), infop,
-						stat_addr, ru);
-			} else if (p->exit_state != EXIT_DEAD) {
-				/*
-				 * It's running now, so it might later
-				 * exit, stop, or stop and then continue.
-				 */
-				flag = 1;
-				if (!unlikely(options & WCONTINUED))
-					continue;
-				retval = wait_task_continued(p,
-						(options & WNOWAIT), infop,
-						stat_addr, ru);
-			}
-			if (retval != 0) /* tasklist_lock released */
-				goto end;
-		}
-		if (!flag) {
-			list_for_each_entry(p, &tsk->ptrace_children,
-								ptrace_list) {
-				flag = eligible_child(type, pid, options, p);
-				if (!flag)
-					continue;
-				if (likely(flag > 0))
-					break;
-				retval = flag;
-				goto end;
-			}
-		}
 		if (options & __WNOTHREAD)
 			break;
 		tsk = next_thread(tsk);
@@ -1532,16 +1579,14 @@ repeat:
 	} while (tsk != current);
 	read_unlock(&tasklist_lock);
 
-	if (flag) {
-		if (options & WNOHANG)
-			goto end;
+	if (!retval && !(options & WNOHANG)) {
 		retval = -ERESTARTSYS;
-		if (signal_pending(current))
-			goto end;
-		schedule();
-		goto repeat;
+		if (!signal_pending(current)) {
+			schedule();
+			goto repeat;
+		}
 	}
-	retval = -ECHILD;
+
 end:
 	current->state = TASK_RUNNING;
 	remove_wait_queue(&current->signal->wait_chldexit,&wait);
