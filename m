Return-Path: <linux-kernel-owner+w=401wt.eu-S1758943AbYAJUwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943AbYAJUwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 15:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758331AbYAJUwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 15:52:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758238AbYAJUwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 15:52:20 -0500
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] remove task_ppid_nr_ns
Emacs: there's a reason it comes with a built-in psychotherapist.
Message-Id: <20080110205210.67B0326F9A6@magilla.localdomain>
Date: Thu, 10 Jan 2008 12:52:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_ppid_nr_ns is called in three places.  One of these should never
have called it.  In the other two, using it broke the existing
semantics.  This was presumably accidental.  If the function had not
been there, it would have been much more obvious to the eye that those
patches were changing the behavior.  We don't need this function.

In task_state, the pid of the ptracer is not the ppid of the ptracer.

In do_task_stat, ppid is the tgid of the real_parent, not its pid.
I also moved the call outside of lock_task_sighand, since it doesn't
need it.

In sys_getppid, ppid is the tgid of the real_parent, not its pid.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 fs/proc/array.c       |    4 ++--
 include/linux/sched.h |   13 -------------
 kernel/timer.c        |    2 +-
 3 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 65c62e1..0000000 100644  
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -169,7 +169,7 @@ static inline char *task_state(struct ta
 	ppid = pid_alive(p) ?
 		task_tgid_nr_ns(rcu_dereference(p->real_parent), ns) : 0;
 	tpid = pid_alive(p) && p->ptrace ?
-		task_ppid_nr_ns(rcu_dereference(p->parent), ns) : 0;
+		task_pid_nr_ns(rcu_dereference(p->parent), ns) : 0;
 	buffer += sprintf(buffer,
 		"State:\t%s\n"
 		"Tgid:\t%d\n"
@@ -426,6 +426,7 @@ static int do_task_stat(struct task_stru
 	cgtime = gtime = cputime_zero;
 
 	rcu_read_lock();
+	ppid = task_tgid_nr_ns(task->real_parent, ns);
 	if (lock_task_sighand(task, &flags)) {
 		struct signal_struct *sig = task->signal;
 
@@ -465,7 +466,6 @@ static int do_task_stat(struct task_stru
 
 		sid = task_session_nr_ns(task, ns);
 		pgid = task_pgrp_nr_ns(task, ns);
-		ppid = task_ppid_nr_ns(task, ns);
 
 		unlock_task_sighand(task, &flags);
 	}
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 80cb536..0000000 100644  
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1255,13 +1255,6 @@ struct pid_namespace;
  *
  * set_task_vxid()   : assigns a virtual id to a task;
  *
- * task_ppid_nr_ns() : the parent's id as seen from the namespace specified.
- *                     the result depends on the namespace and whether the
- *                     task in question is the namespace's init. e.g. for the
- *                     namespace's init this will return 0 when called from
- *                     the namespace of this init, or appropriate id otherwise.
- *
- *
  * see also pid_nr() etc in include/linux/pid.h
  */
 
@@ -1317,12 +1310,6 @@ static inline pid_t task_session_vnr(str
 }
 
 
-static inline pid_t task_ppid_nr_ns(struct task_struct *tsk,
-		struct pid_namespace *ns)
-{
-	return pid_nr_ns(task_pid(rcu_dereference(tsk->real_parent)), ns);
-}
-
 /**
  * pid_alive - check that a task structure is not stale
  * @p: Task structure to be checked.
diff --git a/kernel/timer.c b/kernel/timer.c
index 0bffb87..0000000 100644  
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -976,7 +976,7 @@ asmlinkage long sys_getppid(void)
 	int pid;
 
 	rcu_read_lock();
-	pid = task_ppid_nr_ns(current, current->nsproxy->pid_ns);
+	pid = task_tgid_nr_ns(current->real_parent, current->nsproxy->pid_ns);
 	rcu_read_unlock();
 
 	return pid;
