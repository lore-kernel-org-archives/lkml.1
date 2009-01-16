Return-Path: <linux-kernel-owner+w=401wt.eu-S1764302AbZAPF6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764302AbZAPF6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 00:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbZAPF5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 00:57:24 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39643 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbZAPF5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 00:57:23 -0500
Date: Fri, 16 Jan 2009 06:55:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] pids: refactor vnr/nr_ns helpers to make them safe
Message-ID: <20090116055520.GA28131@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inho, the safety rules for vnr/nr_ns helpers are horrible and buggy.

task_pid_nr_ns(task) needs rcu/tasklist depending on task == current.

As for "special" pids, vnr/nr_ns helpers always need rcu. However,
if task != current, they are unsafe even under rcu lock, we can't
trust task->group_leader without the special checks.

And almost every helper has a callsite which needs a fix.

Also, it is a bit annoying that the implementations of, say,
task_pgrp_vnr() and task_pgrp_nr_ns() are not "symmetrical".

This patch introduces the new helper, __task_pid_nr_ns(), which is
always safe to use, and turns all other helpers into the trivial
wrappers.

If this patch is acceptable, I'll send another one which converts
task_tgid_xxx() as well, there are a bit special.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- CUR/include/linux/sched.h~SP_3_NR	2009-01-16 02:13:50.000000000 +0100
+++ CUR/include/linux/sched.h	2009-01-16 04:16:12.000000000 +0100
@@ -1481,17 +1481,23 @@ struct pid_namespace;
  *
  * see also pid_nr() etc in include/linux/pid.h
  */
+pid_t __task_pid_nr_ns(struct task_struct *task, enum pid_type type,
+			struct pid_namespace *ns);
 
 static inline pid_t task_pid_nr(struct task_struct *tsk)
 {
 	return tsk->pid;
 }
 
-pid_t task_pid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns);
+static inline pid_t task_pid_nr_ns(struct task_struct *tsk,
+					struct pid_namespace *ns)
+{
+	return __task_pid_nr_ns(tsk, PIDTYPE_PID, ns);
+}
 
 static inline pid_t task_pid_vnr(struct task_struct *tsk)
 {
-	return pid_vnr(task_pid(tsk));
+	return __task_pid_nr_ns(tsk, PIDTYPE_PID, NULL);
 }
 
 
@@ -1513,11 +1519,15 @@ static inline pid_t task_pgrp_nr(struct 
 	return tsk->signal->__pgrp;
 }
 
-pid_t task_pgrp_nr_ns(struct task_struct *tsk, struct pid_namespace *ns);
+static inline pid_t task_pgrp_nr_ns(struct task_struct *tsk,
+					struct pid_namespace *ns)
+{
+	return __task_pid_nr_ns(tsk, PIDTYPE_PGID, ns);
+}
 
 static inline pid_t task_pgrp_vnr(struct task_struct *tsk)
 {
-	return pid_vnr(task_pgrp(tsk));
+	return __task_pid_nr_ns(tsk, PIDTYPE_PGID, NULL);
 }
 
 
@@ -1526,14 +1536,17 @@ static inline pid_t task_session_nr(stru
 	return tsk->signal->__session;
 }
 
-pid_t task_session_nr_ns(struct task_struct *tsk, struct pid_namespace *ns);
+static inline pid_t task_session_nr_ns(struct task_struct *tsk,
+					struct pid_namespace *ns)
+{
+	return __task_pid_nr_ns(tsk, PIDTYPE_SID, ns);
+}
 
 static inline pid_t task_session_vnr(struct task_struct *tsk)
 {
-	return pid_vnr(task_session(tsk));
+	return __task_pid_nr_ns(tsk, PIDTYPE_SID, NULL);
 }
 
-
 /**
  * pid_alive - check that a task structure is not stale
  * @p: Task structure to be checked.
--- CUR/kernel/pid.c~SP_3_NR	2009-01-16 02:54:26.000000000 +0100
+++ CUR/kernel/pid.c	2009-01-16 05:40:43.000000000 +0100
@@ -452,11 +452,24 @@ pid_t pid_vnr(struct pid *pid)
 }
 EXPORT_SYMBOL_GPL(pid_vnr);
 
-pid_t task_pid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
+pid_t __task_pid_nr_ns(struct task_struct *task, enum pid_type type,
+			struct pid_namespace *ns)
 {
-	return pid_nr_ns(task_pid(tsk), ns);
+	pid_t nr = 0;
+
+	rcu_read_lock();
+	if (!ns)
+		ns = current->nsproxy->pid_ns;
+	if (likely(pid_alive(task))) {
+		if (type != PIDTYPE_PID)
+			task = task->group_leader;
+		nr = pid_nr_ns(task->pids[type].pid, ns);
+	}
+	rcu_read_unlock();
+
+	return nr;
 }
-EXPORT_SYMBOL(task_pid_nr_ns);
+EXPORT_SYMBOL(__task_pid_nr_ns);
 
 pid_t task_tgid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
 {
@@ -464,18 +477,6 @@ pid_t task_tgid_nr_ns(struct task_struct
 }
 EXPORT_SYMBOL(task_tgid_nr_ns);
 
-pid_t task_pgrp_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
-{
-	return pid_nr_ns(task_pgrp(tsk), ns);
-}
-EXPORT_SYMBOL(task_pgrp_nr_ns);
-
-pid_t task_session_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
-{
-	return pid_nr_ns(task_session(tsk), ns);
-}
-EXPORT_SYMBOL(task_session_nr_ns);
-
 struct pid_namespace *task_active_pid_ns(struct task_struct *tsk)
 {
 	return ns_of_pid(task_pid(tsk));

