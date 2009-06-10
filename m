Return-Path: <linux-kernel-owner+w=401wt.eu-S1760823AbZFJXFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823AbZFJXFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 19:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757305AbZFJXE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 19:04:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36782 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123AbZFJXE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 19:04:56 -0400
Date: Thu, 11 Jun 2009 01:04:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: [GIT PULL] tracing/urgent for v2.6.31
Message-ID: <20090610230450.GA8964@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-urgent-for-linus

These are the leftover commits in the tracing/urgent queue that 
didnt end up making it into .30. There's a trivial conflict in 
kernel/trace/ftrace.c.

The reason there's an internal conflict between two tracing-tree 
topics is that we tried a new trick to reduce merge commits: we 
never merged tracing/urgent into tracing/core - we waited for it to 
hit upstream, and then merged upstream back at one of the -rc 
points. The inevitable latency of this process opens up a window for 
conflicts. (Let me know if we should instead avoid the conflict by 
backmerging tracing/urgent more frequently.)

 Thanks,

	Ingo

------------------>
Steven Rostedt (5):
      function-graph: only allocate init tasks if it was not already done
      function-graph: enable the stack after initialization of other variables
      function-graph: add memory barriers for accessing task's ret_stack
      function-graph: move initialization of new tasks up in fork
      function-graph: always initialize task ret_stack


 kernel/fork.c                        |   10 ++++------
 kernel/trace/ftrace.c                |   29 +++++++++++++++++++----------
 kernel/trace/trace_functions_graph.c |    6 ++++++
 3 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index b9e2edd..c4b1e35 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -982,6 +982,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (!p)
 		goto fork_out;
 
+	ftrace_graph_init_task(p);
+
 	rt_mutex_init_task(p);
 
 #ifdef CONFIG_PROVE_LOCKING
@@ -1131,8 +1133,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		}
 	}
 
-	ftrace_graph_init_task(p);
-
 	p->pid = pid_nr(pid);
 	p->tgid = p->pid;
 	if (clone_flags & CLONE_THREAD)
@@ -1141,7 +1141,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (current->nsproxy != p->nsproxy) {
 		retval = ns_cgroup_clone(p, pid);
 		if (retval)
-			goto bad_fork_free_graph;
+			goto bad_fork_free_pid;
 	}
 
 	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? child_tidptr : NULL;
@@ -1233,7 +1233,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		spin_unlock(&current->sighand->siglock);
 		write_unlock_irq(&tasklist_lock);
 		retval = -ERESTARTNOINTR;
-		goto bad_fork_free_graph;
+		goto bad_fork_free_pid;
 	}
 
 	if (clone_flags & CLONE_THREAD) {
@@ -1268,8 +1268,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	cgroup_post_fork(p);
 	return p;
 
-bad_fork_free_graph:
-	ftrace_graph_exit_task(p);
 bad_fork_free_pid:
 	if (pid != &init_struct_pid)
 		free_pid(pid);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f1ed080..bb081f3 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2580,12 +2580,12 @@ static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
 		}
 
 		if (t->ret_stack == NULL) {
-			t->curr_ret_stack = -1;
-			/* Make sure IRQs see the -1 first: */
-			barrier();
-			t->ret_stack = ret_stack_list[start++];
 			atomic_set(&t->tracing_graph_pause, 0);
 			atomic_set(&t->trace_overrun, 0);
+			t->curr_ret_stack = -1;
+			/* Make sure the tasks see the -1 first: */
+			smp_wmb();
+			t->ret_stack = ret_stack_list[start++];
 		}
 	} while_each_thread(g, t);
 
@@ -2643,8 +2643,10 @@ static int start_graph_tracing(void)
 		return -ENOMEM;
 
 	/* The cpu_boot init_task->ret_stack will never be freed */
-	for_each_online_cpu(cpu)
-		ftrace_graph_init_task(idle_task(cpu));
+	for_each_online_cpu(cpu) {
+		if (!idle_task(cpu)->ret_stack)
+			ftrace_graph_init_task(idle_task(cpu));
+	}
 
 	do {
 		ret = alloc_retstack_tasklist(ret_stack_list);
@@ -2736,18 +2738,25 @@ void unregister_ftrace_graph(void)
 /* Allocate a return stack for newly created task */
 void ftrace_graph_init_task(struct task_struct *t)
 {
+	/* Make sure we do not use the parent ret_stack */
+	t->ret_stack = NULL;
+
 	if (atomic_read(&ftrace_graph_active)) {
-		t->ret_stack = kmalloc(FTRACE_RETFUNC_DEPTH
+		struct ftrace_ret_stack *ret_stack;
+
+		ret_stack = kmalloc(FTRACE_RETFUNC_DEPTH
 				* sizeof(struct ftrace_ret_stack),
 				GFP_KERNEL);
-		if (!t->ret_stack)
+		if (!ret_stack)
 			return;
 		t->curr_ret_stack = -1;
 		atomic_set(&t->tracing_graph_pause, 0);
 		atomic_set(&t->trace_overrun, 0);
 		t->ftrace_timestamp = 0;
-	} else
-		t->ret_stack = NULL;
+		/* make curr_ret_stack visable before we add the ret_stack */
+		smp_wmb();
+		t->ret_stack = ret_stack;
+	}
 }
 
 void ftrace_graph_exit_task(struct task_struct *t)
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index d28687e..baeb5fe 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -65,6 +65,12 @@ ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth)
 	if (!current->ret_stack)
 		return -EBUSY;
 
+	/*
+	 * We must make sure the ret_stack is tested before we read
+	 * anything else.
+	 */
+	smp_rmb();
+
 	/* The return trace stack is full */
 	if (current->curr_ret_stack == FTRACE_RETFUNC_DEPTH - 1) {
 		atomic_inc(&current->trace_overrun);
