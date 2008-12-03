Return-Path: <linux-kernel-owner+w=401wt.eu-S1751581AbYLCQGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbYLCQGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbYLCQFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:05:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64542 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbYLCQFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:05:49 -0500
Message-Id: <20081203160547.722050069@goodmis.org>
References: <20081203160448.972919719@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 03 Dec 2008 11:04:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] ftrace: fix race in function graph during fork
Content-Disposition: inline; filename=0002-ftrace-fix-race-in-function-graph-during-fork.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix

There is a nasy race in startup of a new process running the
function graph tracer. In fork.c:

	total_forks++;
	spin_unlock(&current->sighand->siglock);
	write_unlock_irq(&tasklist_lock);
	ftrace_graph_init_task(p);
	proc_fork_connector(p);
	cgroup_post_fork(p);
	return p;

The new task is free to run as soon as the tasklist_lock is released.
This is before the ftrace_graph_init_task. If the task does run
it will be using the same ret_stack and curr_ret_stack as the parent.
This will cause horrible crashes that are nasty to debug.

This patch moves the ftrace_graph_init_task to just after the alloc_pid
code. This fixes the above race.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/fork.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index afb376d..91cca76 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1142,6 +1142,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		}
 	}
 
+	ftrace_graph_init_task(p);
+
 	p->pid = pid_nr(pid);
 	p->tgid = p->pid;
 	if (clone_flags & CLONE_THREAD)
@@ -1150,7 +1152,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (current->nsproxy != p->nsproxy) {
 		retval = ns_cgroup_clone(p, pid);
 		if (retval)
-			goto bad_fork_free_pid;
+			goto bad_fork_free_graph;
 	}
 
 	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? child_tidptr : NULL;
@@ -1243,7 +1245,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		spin_unlock(&current->sighand->siglock);
 		write_unlock_irq(&tasklist_lock);
 		retval = -ERESTARTNOINTR;
-		goto bad_fork_free_pid;
+		goto bad_fork_free_graph;
 	}
 
 	if (clone_flags & CLONE_THREAD) {
@@ -1276,11 +1278,12 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	total_forks++;
 	spin_unlock(&current->sighand->siglock);
 	write_unlock_irq(&tasklist_lock);
-	ftrace_graph_init_task(p);
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
 	return p;
 
+bad_fork_free_graph:
+	ftrace_graph_exit_task(p);
 bad_fork_free_pid:
 	if (pid != &init_struct_pid)
 		free_pid(pid);
-- 
1.5.6.5

-- 
