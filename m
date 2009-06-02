Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbZFBWDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbZFBWDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZFBWDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:03:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54575 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZFBWDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:03:08 -0400
Message-Id: <20090602220309.575197235@goodmis.org>
References: <20090602220212.894951549@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Jun 2009 18:02:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, stable@kernel.org
Subject: [PATCH 1/2] function-graph: move initialization of new tasks up in fork
Content-Disposition: inline; filename=0001-function-graph-move-initialization-of-new-tasks-up-i.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When the function graph tracer is enabled, all new tasks must allocate
a ret_stack to place the return address of functions. This is because
the function graph tracer will replace the real return address with a
call to the tracing of the exit function.

This initialization happens in fork, but it happens too late. If fork
fails, then it will call free_task and that calls the freeing of this
ret_stack. But before initialization happens, the new (failed) task
points to its parents ret_stack. If a fork failure happens during
the function trace, it would be catastrophic for the parent.

Also, there's no need to call ftrace_graph_exit_task from fork, since
it is called by free_task which fork calls on failure.

[ Impact: prevent crash during failed fork running function graph tracer ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/fork.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

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
-- 
1.6.3.1

-- 
