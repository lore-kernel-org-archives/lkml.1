Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbYKTBVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbYKTBVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 20:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbYKTBVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 20:21:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbYKTBVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 20:21:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ratan Nalumasu <rnalumasu@gmail.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH] do_wait wakeup optimization
In-Reply-To: Ratan Nalumasu's message of  Wednesday, 19 November 2008 14:04:18 -0800 <93ad5f3f0811191404g28361b1ei329c3e326b21087d@mail.gmail.com>
References: <93ad5f3f0808181334i684e68b7yb61e3586d35880f6@mail.gmail.com>
	<93ad5f3f0808181804m3b74fe68v1fdcf4edf6c7b465@mail.gmail.com>
	<20080819214546.9BD5715426B@magilla.localdomain>
	<93ad5f3f0808191746g44acbccdm715222698ed20ee1@mail.gmail.com>
	<20080820010415.EB87B15449D@magilla.localdomain>
	<93ad5f3f0808191851i1fdd0332g8befbc538551f24@mail.gmail.com>
	<93ad5f3f0808221333pe9b95fp886f6313b4be384e@mail.gmail.com>
	<20080823013655.F3B3615426C@magilla.localdomain>
	<93ad5f3f0808261601g4fa6429dgbcb21e4218e92f2a@mail.gmail.com>
	<20080826230620.5865E154233@magilla.localdomain>
	<93ad5f3f0811191404g28361b1ei329c3e326b21087d@mail.gmail.com>
Emacs: a Lisp interpreter masquerading as ... a Lisp interpreter!
Message-Id: <20081120012017.3CC3C15423A@magilla.localdomain>
Date: Wed, 19 Nov 2008 17:20:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ratan Nalumasu reported that in a process with many threads doing
different, mutually-exclusive waitpid() calls, there were a lot of
unnecessary wakeups.  Every waiting thread in the process wakes up to
loop through the children and see that the only ones it cares about
are still not ready.

Change do_wait() to use init_waitqueue_func_entry with a custom wake
function.  This skips the wakeup for a do_wait() call that is not
interested in the child that's doing wake_up on wait_chldexit.

Signed-off-by: Roland McGrath <roland@redhat.com>
CC: Ratan Nalumasu <rnalumasu@gmail.com>
---
 kernel/exit.c |   90 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 78 insertions(+), 12 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 2d8be7e..3e087c4 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1200,10 +1200,8 @@ static struct pid *task_pid_type(struct task_struct *task, enum pid_type type)
 }
 
 static int eligible_child(enum pid_type type, struct pid *pid, int options,
-			  struct task_struct *p)
+			  struct task_struct *p, int exit_signal)
 {
-	int err;
-
 	if (type < PIDTYPE_MAX) {
 		if (task_pid_type(p, type) != pid)
 			return 0;
@@ -1214,14 +1212,10 @@ static int eligible_child(enum pid_type type, struct pid *pid, int options,
 	 * set; otherwise, wait for non-clone children *only*.  (Note:
 	 * A "clone" child here is one that reports to its parent
 	 * using a signal other than SIGCHLD.) */
-	if (((p->exit_signal != SIGCHLD) ^ ((options & __WCLONE) != 0))
+	if (((exit_signal != SIGCHLD) ^ ((options & __WCLONE) != 0))
 	    && !(options & __WALL))
 		return 0;
 
-	err = security_task_wait(p);
-	if (err)
-		return err;
-
 	return 1;
 }
 
@@ -1567,10 +1561,11 @@ static int wait_consider_task(struct task_struct *parent, int ptrace,
 			      struct siginfo __user *infop,
 			      int __user *stat_addr, struct rusage __user *ru)
 {
-	int ret = eligible_child(type, pid, options, p);
+	int ret = eligible_child(type, pid, options, p, p->exit_signal);
 	if (!ret)
 		return ret;
 
+	ret = security_task_wait(p);
 	if (unlikely(ret < 0)) {
 		/*
 		 * If we have not yet seen any eligible child,
@@ -1669,17 +1664,88 @@ static int ptrace_do_wait(struct task_struct *tsk, int *notask_error,
 	return 0;
 }
 
+/*
+ * This sits on the stack of a thread that is blocked in do_wait().
+ * @wq.private holds the task_struct pointer of that thread.
+ */
+struct do_wait_queue_entry {
+	wait_queue_t wq;
+	struct pid *pid;
+	enum pid_type type;
+	int options;
+};
+
+/*
+ * Here current (@task) is a thread calling do_notify_parent().
+ * Return zero to optimize out the wake-up of a parent thread in
+ * do_wait() that doesn't care about this child.  An extra wake-up
+ * is permissible, but missing one is not.
+ */
+static int needs_wakeup(struct task_struct *task, struct do_wait_queue_entry *w)
+{
+	if ((w->options & __WNOTHREAD) && task->parent != w->wq.private)
+		return 0;
+
+	if (eligible_child(w->type, w->pid, w->options,
+			   task, task->exit_signal))
+		return 1;
+
+	if (thread_group_leader(task)) {
+		/*
+		 * In a group leader, do_notify_parent() may have
+		 * just reset task->exit_signal because SIGCHLD was
+		 * ignored, but that doesn't prevent the wakeup.
+		 */
+		if (!task_detached(task) ||
+		    !eligible_child(w->type, w->pid, w->options,
+				    task, SIGCHLD))
+			return 0;
+	} else {
+		/*
+		 * In a non-leader, this might be the release_task()
+		 * case, where it's the leader rather than task
+		 * whose parent is being woken.
+		 */
+		if (!eligible_child(w->type, w->pid, w->options,
+				    task->group_leader,
+				    task_detached(task->group_leader) ?
+				    SIGCHLD : task->group_leader->exit_signal))
+			return 0;
+	}
+
+	return 1;
+}
+
+static int do_wait_wake_function(wait_queue_t *curr, unsigned mode, int sync,
+				 void *key)
+{
+	struct task_struct *task = current;
+	struct do_wait_queue_entry *w =
+		container_of(curr, struct do_wait_queue_entry, wq);
+
+	if (!needs_wakeup(task, w))
+		return 0;
+
+	return default_wake_function(curr, mode, sync, key);
+}
+
 static long do_wait(enum pid_type type, struct pid *pid, int options,
 		    struct siginfo __user *infop, int __user *stat_addr,
 		    struct rusage __user *ru)
 {
-	DECLARE_WAITQUEUE(wait, current);
+	struct do_wait_queue_entry wait;
 	struct task_struct *tsk;
 	int retval;
 
 	trace_sched_process_wait(pid);
 
-	add_wait_queue(&current->signal->wait_chldexit,&wait);
+	init_waitqueue_func_entry(&wait.wq, do_wait_wake_function);
+	wait.wq.private = current;
+	wait.type = type;
+	wait.pid = pid;
+	wait.options = options;
+
+	add_wait_queue(&current->signal->wait_chldexit, &wait.wq);
 repeat:
 	/*
 	 * If there is nothing that can match our critiera just get out.
@@ -1726,7 +1792,7 @@ repeat:
 
 end:
 	current->state = TASK_RUNNING;
-	remove_wait_queue(&current->signal->wait_chldexit,&wait);
+	remove_wait_queue(&current->signal->wait_chldexit, &wait.wq);
 	if (infop) {
 		if (retval > 0)
 			retval = 0;
