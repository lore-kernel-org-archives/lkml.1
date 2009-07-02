Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbZGBSOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbZGBSOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 14:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbZGBSOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 14:14:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36367 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728AbZGBSOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 14:14:35 -0400
Date: Thu, 2 Jul 2009 20:11:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ratan Nalumasu <rnalumasu@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] do not place sub-threads on task_struct->children list
Message-ID: <20090702181145.GA28581@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Roland who pointed out de_thread() issues.

Currently we add sub-threads to ->real_parent->children list. This
buys nothing but slows down do_wait().

With this patch ->children contains only main threads (group leaders).
The only complication is that forget_original_parent() should iterate
over sub-threads by hand, and de_thread() needs another list_replace()
when it changes ->group_leader.

>From now do_wait_thread() can never see task_detached() && !EXIT_DEAD
tasks, we can remove this check (and we can unify do_wait_thread() and
ptrace_do_wait()).

This change can confuse the optimistic search in mm_update_next_owner(),
but this is fixable and minor.

Perhaps badness() and oom_kill_process() should be updated, but they
should be fixed in any case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 fs/exec.c     |    2 ++
 kernel/fork.c |    2 +-
 kernel/exit.c |   36 +++++++++++++++++-------------------
 3 files changed, 20 insertions(+), 20 deletions(-)

--- WAIT/fs/exec.c~4_CHILDREN_NO_THREADS	2009-07-01 20:01:54.000000000 +0200
+++ WAIT/fs/exec.c	2009-07-02 19:27:36.000000000 +0200
@@ -827,7 +827,9 @@ static int de_thread(struct task_struct 
 		attach_pid(tsk, PIDTYPE_PID,  task_pid(leader));
 		transfer_pid(leader, tsk, PIDTYPE_PGID);
 		transfer_pid(leader, tsk, PIDTYPE_SID);
+
 		list_replace_rcu(&leader->tasks, &tsk->tasks);
+		list_replace_init(&leader->sibling, &tsk->sibling);
 
 		tsk->group_leader = tsk;
 		leader->group_leader = tsk;
--- WAIT/kernel/fork.c~4_CHILDREN_NO_THREADS	2009-07-01 20:01:54.000000000 +0200
+++ WAIT/kernel/fork.c	2009-07-02 19:27:36.000000000 +0200
@@ -1245,7 +1245,6 @@ static struct task_struct *copy_process(
 	}
 
 	if (likely(p->pid)) {
-		list_add_tail(&p->sibling, &p->real_parent->children);
 		tracehook_finish_clone(p, clone_flags, trace);
 
 		if (thread_group_leader(p)) {
@@ -1257,6 +1256,7 @@ static struct task_struct *copy_process(
 			p->signal->tty = tty_kref_get(current->signal->tty);
 			attach_pid(p, PIDTYPE_PGID, task_pgrp(current));
 			attach_pid(p, PIDTYPE_SID, task_session(current));
+			list_add_tail(&p->sibling, &p->real_parent->children);
 			list_add_tail_rcu(&p->tasks, &init_task.tasks);
 			__get_cpu_var(process_counts)++;
 		}
--- WAIT/kernel/exit.c~4_CHILDREN_NO_THREADS	2009-07-02 18:44:43.000000000 +0200
+++ WAIT/kernel/exit.c	2009-07-02 19:56:33.000000000 +0200
@@ -68,10 +68,10 @@ static void __unhash_process(struct task
 		detach_pid(p, PIDTYPE_SID);
 
 		list_del_rcu(&p->tasks);
+		list_del_init(&p->sibling);
 		__get_cpu_var(process_counts)--;
 	}
 	list_del_rcu(&p->thread_group);
-	list_del_init(&p->sibling);
 }
 
 /*
@@ -736,12 +736,9 @@ static struct task_struct *find_new_reap
 /*
 * Any that need to be release_task'd are put on the @dead list.
  */
-static void reparent_thread(struct task_struct *father, struct task_struct *p,
+static void reparent_leader(struct task_struct *father, struct task_struct *p,
 				struct list_head *dead)
 {
-	if (p->pdeath_signal)
-		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
-
 	list_move_tail(&p->sibling, &p->real_parent->children);
 
 	if (task_detached(p))
@@ -780,12 +777,18 @@ static void forget_original_parent(struc
 	reaper = find_new_reaper(father);
 
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
-		p->real_parent = reaper;
-		if (p->parent == father) {
-			BUG_ON(task_ptrace(p));
-			p->parent = p->real_parent;
-		}
-		reparent_thread(father, p, &dead_children);
+		struct task_struct *t = p;
+		do {
+			t->real_parent = reaper;
+			if (t->parent == father) {
+				BUG_ON(task_ptrace(t));
+				t->parent = t->real_parent;
+			}
+			if (t->pdeath_signal)
+				group_send_sig_info(t->pdeath_signal,
+						    SEND_SIG_NOINFO, t);
+		} while_each_thread(p, t);
+		reparent_leader(father, p, &dead_children);
 	}
 	write_unlock_irq(&tasklist_lock);
 
@@ -1533,14 +1536,9 @@ static int do_wait_thread(struct wait_op
 	struct task_struct *p;
 
 	list_for_each_entry(p, &tsk->children, sibling) {
-		/*
-		 * Do not consider detached threads.
-		 */
-		if (!task_detached(p)) {
-			int ret = wait_consider_task(wo, tsk, 0, p);
-			if (ret)
-				return ret;
-		}
+		int ret = wait_consider_task(wo, tsk, 0, p);
+		if (ret)
+			return ret;
 	}
 
 	return 0;

