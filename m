Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbYC2DgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbYC2DgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551AbYC2DgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:36:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964AbYC2DgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:36:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 2/2] ptrace children revamp
In-Reply-To: Roland McGrath's message of  Friday, 28 March 2008 20:34:12 -0700 <20080329033412.120EE26FA1D@magilla.localdomain>
References: <20080329033412.120EE26FA1D@magilla.localdomain>
X-Zippy-Says: Are we live or on tape?
Message-Id: <20080329033542.BFF4526FA1D@magilla.localdomain>
Date: Fri, 28 Mar 2008 20:35:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace no longer fiddles with the children/sibling links, and the
old ptrace_children list is gone.  Now using PTRACE_ATTACH on
someone else's child just uses the new ptrace_attach list instead.

There should be no user-visible difference that matters.  The only
change is the order in which do_wait() sees multiple stopped children
and stopped ptrace attachees.  Since wait_task_stopped() was changed
earlier so it no longer reorders the children list, we already know
this won't cause any new problems.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/init_task.h |    2 +-
 include/linux/sched.h     |   27 +++----
 kernel/exit.c             |  180 ++++++++++++++++++++++-----------------------
 kernel/fork.c             |    4 +-
 kernel/ptrace.c           |   18 ++---
 5 files changed, 111 insertions(+), 120 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 1f74e1d..70dbb73 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -157,7 +157,7 @@ extern struct group_info init_groups;
 		.nr_cpus_allowed = NR_CPUS,				\
 	},								\
 	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
-	.ptrace_children= LIST_HEAD_INIT(tsk.ptrace_children),		\
+	.ptrace_attach	= LIST_HEAD_INIT(tsk.ptrace_attach),		\
 	.ptrace_list	= LIST_HEAD_INIT(tsk.ptrace_list),		\
 	.real_parent	= &tsk,						\
 	.parent		= &tsk,						\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6c275e8..5a755a0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1043,12 +1043,6 @@ struct task_struct {
 #endif
 
 	struct list_head tasks;
-	/*
-	 * ptrace_list/ptrace_children forms the list of my children
-	 * that were stolen by a ptracer.
-	 */
-	struct list_head ptrace_children;
-	struct list_head ptrace_list;
 
 	struct mm_struct *mm, *active_mm;
 
@@ -1070,18 +1064,26 @@ struct task_struct {
 	/* 
 	 * pointers to (original) parent process, youngest child, younger sibling,
 	 * older sibling, respectively.  (p->father can be replaced with 
-	 * p->parent->pid)
+	 * p->real_parent->pid)
 	 */
-	struct task_struct *real_parent; /* real parent process (when being debugged) */
-	struct task_struct *parent;	/* parent process */
+	struct task_struct *real_parent; /* real parent process */
+	struct task_struct *parent; /* recipient of SIGCHLD, wait4() reports */
 	/*
-	 * children/sibling forms the list of my children plus the
-	 * tasks I'm ptracing.
+	 * children/sibling forms the list of my natural children
 	 */
 	struct list_head children;	/* list of my children */
 	struct list_head sibling;	/* linkage in my parent's children list */
 	struct task_struct *group_leader;	/* threadgroup leader */
 
+	/*
+	 * ptrace_attach is the list of tasks I have PTRACE_ATTACH'd to,
+	 * excluding my own natural children.
+	 * ptrace_list is my own link on my PTRACE_ATTACHer's list,
+	 * which is p->parent->ptrace_attach.
+	 */
+	struct list_head ptrace_attach;
+	struct list_head ptrace_list;
+
 	/* PID/PID hash table linkage. */
 	struct pid_link pids[PIDTYPE_MAX];
 	struct list_head thread_group;
@@ -1794,9 +1796,6 @@ extern void wait_task_inactive(struct task_struct * p);
 #define wait_task_inactive(p)	do { } while (0)
 #endif
 
-#define remove_parent(p)	list_del_init(&(p)->sibling)
-#define add_parent(p)		list_add_tail(&(p)->sibling,&(p)->parent->children)
-
 #define next_task(p)	list_entry(rcu_dereference((p)->tasks.next), struct task_struct, tasks)
 
 #define for_each_process(p) \
diff --git a/kernel/exit.c b/kernel/exit.c
index f2cf0a1..fdfda5f 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -64,7 +64,7 @@ static void __unhash_process(struct task_struct *p)
 		__get_cpu_var(process_counts)--;
 	}
 	list_del_rcu(&p->thread_group);
-	remove_parent(p);
+	list_del_init(&p->sibling);
 }
 
 /*
@@ -140,6 +140,18 @@ static void delayed_put_task_struct(struct rcu_head *rhp)
 	put_task_struct(container_of(rhp, struct task_struct, rcu));
 }
 
+/*
+ * Do final ptrace-related cleanup of a zombie being reaped.
+ *
+ * Called with write_lock(&tasklist_lock) held.
+ */
+static void ptrace_release_task(struct task_struct *p)
+{
+	ptrace_unlink(p);
+	BUG_ON(!list_empty(&p->ptrace_list));
+	BUG_ON(!list_empty(&p->ptrace_attach));
+}
+
 void release_task(struct task_struct * p)
 {
 	struct task_struct *leader;
@@ -148,8 +160,7 @@ repeat:
 	atomic_dec(&p->user->processes);
 	proc_flush_task(p);
 	write_lock_irq(&tasklist_lock);
-	ptrace_unlink(p);
-	BUG_ON(!list_empty(&p->ptrace_list) || !list_empty(&p->ptrace_children));
+	ptrace_release_task(p);
 	__exit_signal(p);
 
 	/*
@@ -303,9 +314,8 @@ static void reparent_to_kthreadd(void)
 
 	ptrace_unlink(current);
 	/* Reparent to init */
-	remove_parent(current);
 	current->real_parent = current->parent = kthreadd_task;
-	add_parent(current);
+	list_move_tail(&current->sibling, &current->real_parent->children);
 
 	/* Set the exit signal to SIGCHLD so we signal init on exit */
 	current->exit_signal = SIGCHLD;
@@ -616,37 +626,60 @@ static void exit_mm(struct task_struct * tsk)
 	mmput(mm);
 }
 
-static void
-reparent_thread(struct task_struct *p, struct task_struct *father, int traced)
+/*
+ * Detach any ptrace attachees (not our own natural children).
+ * Any that need to be release_task'd are put on the @dead list.
+ *
+ * Called with write_lock(&tasklist_lock) held.
+ */
+static void ptrace_exit(struct task_struct *parent, struct list_head *dead)
 {
-	if (p->pdeath_signal)
-		/* We already hold the tasklist_lock here.  */
-		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
+	struct task_struct *p, *n;
 
-	/* Move the child from its dying parent to the new one.  */
-	if (unlikely(traced)) {
-		/* Preserve ptrace links if someone else is tracing this child.  */
-		list_del_init(&p->ptrace_list);
-		if (p->parent != p->real_parent)
-			list_add(&p->ptrace_list, &p->real_parent->ptrace_children);
-	} else {
-		/* If this child is being traced, then we're the one tracing it
-		 * anyway, so let go of it.
-		 */
-		p->ptrace = 0;
-		remove_parent(p);
-		p->parent = p->real_parent;
-		add_parent(p);
+	list_for_each_entry_safe(p, n, &parent->ptrace_attach, ptrace_list) {
+		__ptrace_unlink(p);
 
-		if (task_is_traced(p)) {
-			/*
-			 * If it was at a trace stop, turn it into
-			 * a normal stop since it's no longer being
-			 * traced.
-			 */
-			ptrace_untrace(p);
+		/*
+		 * If it's a zombie, our attachedness prevented normal
+		 * parent notification or self-reaping.  Do notification
+		 * now if it would have happened earlier.  If it should
+		 * reap itself, add it to the @dead list.  We can't call
+		 * release_task() here because we already hold tasklist_lock.
+		 */
+		if (p->exit_state == EXIT_ZOMBIE) {
+			if (p->exit_signal != -1 && !thread_group_empty(p))
+				do_notify_parent(p, p->exit_signal);
+			if (p->exit_signal == -1)
+				list_add(&p->ptrace_list, dead);
 		}
 	}
+}
+
+/*
+ * Finish up exit-time ptrace cleanup.
+ *
+ * Called without locks.
+ */
+static void ptrace_exit_finish(struct task_struct *parent,
+			       struct list_head *dead)
+{
+	struct task_struct *p, *n;
+
+	BUG_ON(!list_empty(&parent->ptrace_attach));
+
+	list_for_each_entry_safe(p, n, dead, ptrace_list) {
+		list_del_init(&p->ptrace_list);
+		release_task(p);
+	}
+}
+
+static void reparent_thread(struct task_struct *p, struct task_struct *father)
+{
+	if (p->pdeath_signal)
+		/* We already hold the tasklist_lock here.  */
+		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
+
+	list_move_tail(&p->sibling, &p->real_parent->children);
 
 	/* If this is a threaded reparent there is no need to
 	 * notify anyone anything has happened.
@@ -661,7 +694,7 @@ reparent_thread(struct task_struct *p, struct task_struct *father, int traced)
 	/* If we'd notified the old parent about this child's death,
 	 * also notify the new parent.
 	 */
-	if (!traced && p->exit_state == EXIT_ZOMBIE &&
+	if (p->exit_state == EXIT_ZOMBIE &&
 	    p->exit_signal != -1 && thread_group_empty(p))
 		do_notify_parent(p, p->exit_signal);
 
@@ -678,9 +711,7 @@ reparent_thread(struct task_struct *p, struct task_struct *father, int traced)
 static void forget_original_parent(struct task_struct *father)
 {
 	struct task_struct *p, *n, *reaper = father;
-	struct list_head ptrace_dead;
-
-	INIT_LIST_HEAD(&ptrace_dead);
+	LIST_HEAD(ptrace_dead);
 
 	write_lock_irq(&tasklist_lock);
 
@@ -692,58 +723,24 @@ static void forget_original_parent(struct task_struct *father)
 		}
 	} while (reaper->flags & PF_EXITING);
 
+	ptrace_exit(father, &ptrace_dead);
+
 	/*
-	 * There are only two places where our children can be:
-	 *
-	 * - in our child list
-	 * - in our ptraced child list
-	 *
-	 * Search them and reparent children.
+	 * Reparent our natural children.
 	 */
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
-		int ptrace;
-
-		ptrace = p->ptrace;
-
-		/* if father isn't the real parent, then ptrace must be enabled */
-		BUG_ON(father != p->real_parent && !ptrace);
-
-		if (father == p->real_parent) {
-			/* reparent with a reaper, real father it's us */
-			p->real_parent = reaper;
-			reparent_thread(p, father, 0);
-		} else {
-			/* reparent ptraced task to its real parent */
-			__ptrace_unlink (p);
-			if (p->exit_state == EXIT_ZOMBIE && p->exit_signal != -1 &&
-			    thread_group_empty(p))
-				do_notify_parent(p, p->exit_signal);
-		}
-
-		/*
-		 * if the ptraced child is a zombie with exit_signal == -1
-		 * we must collect it before we exit, or it will remain
-		 * zombie forever since we prevented it from self-reap itself
-		 * while it was being traced by us, to be able to see it in wait4.
-		 */
-		if (unlikely(ptrace && p->exit_state == EXIT_ZOMBIE && p->exit_signal == -1))
-			list_add(&p->ptrace_list, &ptrace_dead);
-	}
-
-	list_for_each_entry_safe(p, n, &father->ptrace_children, ptrace_list) {
 		p->real_parent = reaper;
-		reparent_thread(p, father, 1);
+		if (p->parent == father) {
+			ptrace_unlink(p);
+			p->parent = p->real_parent;
+		}
+		reparent_thread(p, father);
 	}
 
 	write_unlock_irq(&tasklist_lock);
 	BUG_ON(!list_empty(&father->children));
-	BUG_ON(!list_empty(&father->ptrace_children));
-
-	list_for_each_entry_safe(p, n, &ptrace_dead, ptrace_list) {
-		list_del_init(&p->ptrace_list);
-		release_task(p);
-	}
 
+	ptrace_exit_finish(father, &ptrace_dead);
 }
 
 /*
@@ -1467,6 +1464,15 @@ static int wait_consider_task(struct task_struct *parent,
 		return 1;
 	}
 
+	if (unlikely(p->parent != parent)) {
+		/*
+		 * This child is hidden by someone else who did PTRACE_ATTACH.
+		 * We aren't allowed to see it now, but eventually we will.
+		 */
+		*retval = 0;
+		return 0;
+	}
+
 	if (task_is_stopped_or_traced(p)) {
 		/*
 		 * It's stopped now, so it might later
@@ -1528,19 +1534,11 @@ static int do_wait_thread(struct task_struct *tsk, int *retval,
 			return 1;
 	}
 
-	/*
-	 * If we never saw an eligile child, check for children stolen by
-	 * ptrace.  We don't leave -ECHILD in *@retval if there are any,
-	 * because we will eventually be allowed to wait for them again.
-	 */
-	if (*retval)
-		list_for_each_entry(p, &tsk->ptrace_children, ptrace_list) {
-			int ret = eligible_child(type, pid, options, p);
-			if (ret) {
-				*retval = unlikely(ret < 0) ? ret : 0;
-				break;
-			}
-		}
+	list_for_each_entry(p, &tsk->ptrace_attach, ptrace_list) {
+		if (wait_consider_task(tsk, p, retval, type, pid, options,
+				       infop, stat_addr, ru))
+			return 1;
+	}
 
 	return 0;
 }
diff --git a/kernel/fork.c b/kernel/fork.c
index 9c042f9..d1098a7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1256,7 +1256,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 */
 	p->group_leader = p;
 	INIT_LIST_HEAD(&p->thread_group);
-	INIT_LIST_HEAD(&p->ptrace_children);
+	INIT_LIST_HEAD(&p->ptrace_attach);
 	INIT_LIST_HEAD(&p->ptrace_list);
 
 	/* Now that the task is set up, run cgroup callbacks if
@@ -1329,7 +1329,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	}
 
 	if (likely(p->pid)) {
-		add_parent(p);
+		list_add_tail(&p->sibling, &p->real_parent->children);
 		if (unlikely(p->ptrace & PT_PTRACED))
 			__ptrace_link(p, current->parent);
 
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index a56a95b..2958ec3 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -34,12 +34,10 @@
 void __ptrace_link(struct task_struct *child, struct task_struct *new_parent)
 {
 	BUG_ON(!list_empty(&child->ptrace_list));
-	if (child->parent == new_parent)
-		return;
-	list_add(&child->ptrace_list, &child->parent->ptrace_children);
-	remove_parent(child);
-	child->parent = new_parent;
-	add_parent(child);
+	if (new_parent != child->real_parent) {
+		list_add(&child->ptrace_list, &new_parent->ptrace_attach);
+		child->parent = new_parent;
+	}
 }
  
 /*
@@ -73,12 +71,8 @@ void __ptrace_unlink(struct task_struct *child)
 	BUG_ON(!child->ptrace);
 
 	child->ptrace = 0;
-	if (!list_empty(&child->ptrace_list)) {
-		list_del_init(&child->ptrace_list);
-		remove_parent(child);
-		child->parent = child->real_parent;
-		add_parent(child);
-	}
+	child->parent = child->real_parent;
+	list_del_init(&child->ptrace_list);
 
 	if (task_is_traced(child))
 		ptrace_untrace(child);
