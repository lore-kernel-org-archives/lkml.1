Return-Path: <linux-kernel-owner+w=401wt.eu-S1161256AbXDKGU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161256AbXDKGU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 02:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161257AbXDKGU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 02:20:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59020 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161252AbXDKGU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 02:20:58 -0400
Date: Wed, 11 Apr 2007 08:20:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: [patch] uninline remove/add_parent() APIs
Message-ID: <20070411062041.GA8017@elte.hu>
References: <20070406104301.GB19755@lnx-holt.americas.sgi.com> <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com> <20070406163100.GA554@tv-sign.ru> <20070406173249.GA2517@elte.hu> <m11wix73ut.fsf@ebiederm.dsl.xmission.com> <20070410134814.GA28016@elte.hu> <m17iskz3i8.fsf@ebiederm.dsl.xmission.com> <20070410150650.GA9946@elte.hu> <m1tzvoxniv.fsf@ebiederm.dsl.xmission.com> <20070410155314.GA16267@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070410155314.GA16267@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


here's a (tested) patch i did that should simplify changes done to 
p->children and p->sibling handling.

	Ingo

---------------------->
Subject: [patch] uninline remove/add_parent() APIs
From: Ingo Molnar <mingo@elte.hu>

uninline/simplify remove/add_parent() APIs.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    5 +++--
 kernel/exit.c         |   31 +++++++++++++++++++++----------
 kernel/fork.c         |    2 +-
 kernel/ptrace.c       |   11 ++++-------
 4 files changed, 29 insertions(+), 20 deletions(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -1418,8 +1418,9 @@ extern void wait_task_inactive(struct ta
 #define wait_task_inactive(p)	do { } while (0)
 #endif
 
-#define remove_parent(p)	list_del_init(&(p)->sibling)
-#define add_parent(p)		list_add_tail(&(p)->sibling,&(p)->parent->children)
+extern void
+task_relink_parent(struct task_struct *p, struct task_struct *new_real_parent,
+		   struct task_struct *new_parent);
 
 #define next_task(p)	list_entry(rcu_dereference((p)->tasks.next), struct task_struct, tasks)
 
Index: linux/kernel/exit.c
===================================================================
--- linux.orig/kernel/exit.c
+++ linux/kernel/exit.c
@@ -52,6 +52,20 @@ extern void sem_exit (void);
 
 static void exit_mm(struct task_struct * tsk);
 
+void
+task_relink_parent(struct task_struct *p,
+		   struct task_struct *new_real_parent,
+		   struct task_struct *new_parent)
+{
+	/*
+	 * Move this task to a new parent's children list.
+	 * (if p->parent == new->parent this this requeues from head to tail)
+	 */
+	list_move_tail(&p->sibling, &new_parent->children);
+	p->real_parent = new_real_parent;
+	p->parent = new_parent;
+}
+
 static void __unhash_process(struct task_struct *p)
 {
 	nr_threads--;
@@ -64,7 +78,7 @@ static void __unhash_process(struct task
 		__get_cpu_var(process_counts)--;
 	}
 	list_del_rcu(&p->thread_group);
-	remove_parent(p);
+	list_del_init(&p->sibling);
 }
 
 /*
@@ -268,14 +282,14 @@ static int has_stopped_jobs(struct pid *
  */
 static void reparent_to_init(void)
 {
+	struct task_struct *reaper;
+
 	write_lock_irq(&tasklist_lock);
 
 	ptrace_unlink(current);
 	/* Reparent to init */
-	remove_parent(current);
-	current->parent = child_reaper(current);
-	current->real_parent = child_reaper(current);
-	add_parent(current);
+	reaper = child_reaper(current);
+	task_relink_parent(current, reaper, reaper);
 
 	/* Set the exit signal to SIGCHLD so we signal init on exit */
 	current->exit_signal = SIGCHLD;
@@ -611,9 +625,7 @@ reparent_thread(struct task_struct *p, s
 		 * anyway, so let go of it.
 		 */
 		p->ptrace = 0;
-		remove_parent(p);
-		p->parent = p->real_parent;
-		add_parent(p);
+		task_relink_parent(p, p->real_parent, p->real_parent);
 
 		if (p->state == TASK_TRACED) {
 			/*
@@ -1344,8 +1356,7 @@ bail_ref:
 	}
 
 	/* move to end of parent's list to avoid starvation */
-	remove_parent(p);
-	add_parent(p);
+	task_relink_parent(p, p->real_parent, p->parent);
 
 	write_unlock_irq(&tasklist_lock);
 
Index: linux/kernel/fork.c
===================================================================
--- linux.orig/kernel/fork.c
+++ linux/kernel/fork.c
@@ -1242,7 +1242,7 @@ static struct task_struct *copy_process(
 	}
 
 	if (likely(p->pid)) {
-		add_parent(p);
+		list_add_tail(&p->sibling, &p->parent->children);
 		if (unlikely(p->ptrace & PT_PTRACED))
 			__ptrace_link(p, current->parent);
 
Index: linux/kernel/ptrace.c
===================================================================
--- linux.orig/kernel/ptrace.c
+++ linux/kernel/ptrace.c
@@ -34,11 +34,9 @@ void __ptrace_link(struct task_struct *c
 	if (child->parent == new_parent)
 		return;
 	list_add(&child->ptrace_list, &child->parent->ptrace_children);
-	remove_parent(child);
-	child->parent = new_parent;
-	add_parent(child);
+	task_relink_parent(child, new_parent, child->real_parent);
 }
- 
+
 /*
  * Turn a tracing stop into a normal stop now, since with no tracer there
  * would be no way to wake it up with SIGCONT or SIGKILL.  If there was a
@@ -72,9 +70,8 @@ void __ptrace_unlink(struct task_struct 
 	child->ptrace = 0;
 	if (!list_empty(&child->ptrace_list)) {
 		list_del_init(&child->ptrace_list);
-		remove_parent(child);
-		child->parent = child->real_parent;
-		add_parent(child);
+		task_relink_parent(child, child->real_parent,
+				   child->real_parent);
 	}
 
 	if (child->state == TASK_TRACED)
