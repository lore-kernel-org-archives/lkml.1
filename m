Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbYHXPq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbYHXPq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 11:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbYHXPpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 11:45:25 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:60258 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbYHXPpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 11:45:23 -0400
Date: Sun, 24 Aug 2008 19:49:12 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Robert Rex <robert.rex@exasol.com>,
       Roland McGrath <roland@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] pid_ns: (BUG 11391) change ->child_reaper when init->group_leader exits
Message-ID: <20080824154912.GA3780@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't change pid_ns->child_reaper when the main thread of the
subnamespace init exits. As Robert Rex <robert.rex@exasol.com>
pointed out this is wrong.

Yes, the re-parenting itself works correctly, but if the reparented
task exits it needs ->parent->nsproxy->pid_ns in do_notify_parent(),
and if the main thread is zombie its ->nsproxy was already cleared
by exit_task_namespaces().

Introduce the new function, find_new_reaper(), which finds the new
->parent for the re-parenting and changes ->child_reaper if needed.
Kill the now unneeded exit_child_reaper().

Also move the changing of ->child_reaper from zap_pid_ns_processes()
to find_new_reaper(), this consolidates the games with ->child_reaper
and makes it stable under tasklist_lock.

Reported-by: Robert Rex <robert.rex@exasol.com>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 kernel/pid_namespace.c |    6 ---
 kernel/exit.c          |   78 +++++++++++++++++++++----------------------------
 2 files changed, 34 insertions(+), 50 deletions(-)

--- 2.6.27-rc4/kernel/pid_namespace.c~2_SWITCH_REAPER	2008-08-24 17:22:59.000000000 +0400
+++ 2.6.27-rc4/kernel/pid_namespace.c	2008-08-24 18:22:44.000000000 +0400
@@ -179,12 +179,6 @@ void zap_pid_ns_processes(struct pid_nam
 		rc = sys_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 
-	/*
-	 * We can not clear ->child_reaper or leave it alone.
-	 * There may by stealth EXIT_DEAD tasks on ->children,
-	 * forget_original_parent() must move them somewhere.
-	 */
-	pid_ns->child_reaper = init_pid_ns.child_reaper;
 	acct_exit_ns(pid_ns);
 	return;
 }
--- 2.6.27-rc4/kernel/exit.c~2_SWITCH_REAPER	2008-08-24 16:46:51.000000000 +0400
+++ 2.6.27-rc4/kernel/exit.c	2008-08-24 18:22:37.000000000 +0400
@@ -831,26 +831,50 @@ static void reparent_thread(struct task_
  * the child reaper process (ie "init") in our pid
  * space.
  */
+static struct task_struct *find_new_reaper(struct task_struct *father)
+{
+	struct pid_namespace *pid_ns = task_active_pid_ns(father);
+	struct task_struct *thread;
+
+	thread = father;
+	while_each_thread(father, thread) {
+		if (thread->flags & PF_EXITING)
+			continue;
+		if (unlikely(pid_ns->child_reaper == father))
+			pid_ns->child_reaper = thread;
+		return thread;
+	}
+
+	if (unlikely(pid_ns->child_reaper == father)) {
+		write_unlock_irq(&tasklist_lock);
+		if (unlikely(pid_ns == &init_pid_ns))
+			panic("Attempted to kill init!");
+
+		zap_pid_ns_processes(pid_ns);
+		write_lock_irq(&tasklist_lock);
+		/*
+		 * We can not clear ->child_reaper or leave it alone.
+		 * There may by stealth EXIT_DEAD tasks on ->children,
+		 * forget_original_parent() must move them somewhere.
+		 */
+		pid_ns->child_reaper = init_pid_ns.child_reaper;
+	}
+
+	return pid_ns->child_reaper;
+}
+
 static void forget_original_parent(struct task_struct *father)
 {
-	struct task_struct *p, *n, *reaper = father;
+	struct task_struct *p, *n, *reaper;
 	LIST_HEAD(ptrace_dead);
 
 	write_lock_irq(&tasklist_lock);
-
+	reaper = find_new_reaper(father);
 	/*
 	 * First clean up ptrace if we were using it.
 	 */
 	ptrace_exit(father, &ptrace_dead);
 
-	do {
-		reaper = next_thread(reaper);
-		if (reaper == father) {
-			reaper = task_child_reaper(father);
-			break;
-		}
-	} while (reaper->flags & PF_EXITING);
-
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
 		p->real_parent = reaper;
 		if (p->parent == father) {
@@ -959,39 +983,6 @@ static void check_stack_usage(void)
 static inline void check_stack_usage(void) {}
 #endif
 
-static inline void exit_child_reaper(struct task_struct *tsk)
-{
-	if (likely(tsk->group_leader != task_child_reaper(tsk)))
-		return;
-
-	if (tsk->nsproxy->pid_ns == &init_pid_ns)
-		panic("Attempted to kill init!");
-
-	/*
-	 * @tsk is the last thread in the 'cgroup-init' and is exiting.
-	 * Terminate all remaining processes in the namespace and reap them
-	 * before exiting @tsk.
-	 *
-	 * Note that @tsk (last thread of cgroup-init) may not necessarily
-	 * be the child-reaper (i.e main thread of cgroup-init) of the
-	 * namespace i.e the child_reaper may have already exited.
-	 *
-	 * Even after a child_reaper exits, we let it inherit orphaned children,
-	 * because, pid_ns->child_reaper remains valid as long as there is
-	 * at least one living sub-thread in the cgroup init.
-
-	 * This living sub-thread of the cgroup-init will be notified when
-	 * a child inherited by the 'child-reaper' exits (do_notify_parent()
-	 * uses __group_send_sig_info()). Further, when reaping child processes,
-	 * do_wait() iterates over children of all living sub threads.
-
-	 * i.e even though 'child_reaper' thread is listed as the parent of the
-	 * orphaned children, any living sub-thread in the cgroup-init can
-	 * perform the role of the child_reaper.
-	 */
-	zap_pid_ns_processes(tsk->nsproxy->pid_ns);
-}
-
 NORET_TYPE void do_exit(long code)
 {
 	struct task_struct *tsk = current;
@@ -1051,7 +1042,6 @@ NORET_TYPE void do_exit(long code)
 	}
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
-		exit_child_reaper(tsk);
 		hrtimer_cancel(&tsk->signal->real_timer);
 		exit_itimers(tsk->signal);
 	}

