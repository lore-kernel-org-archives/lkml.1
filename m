Return-Path: <linux-kernel-owner+w=401wt.eu-S933729AbZAROho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933729AbZAROho (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 09:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761774AbZAROhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 09:37:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40664 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761066AbZAROhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 09:37:31 -0500
Date: Sun, 18 Jan 2009 15:33:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] pids: kill now unused signal_struct-> __pgrp/__session and
	friends
Message-ID: <20090118143354.GA8159@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On top of
	[PATCH] autofs: fix the wrong usage of the deprecated task_pgrp_nr()
	[PATCH] autofs4: turn ->oz_pgrp into "struct pid *"
	[PATCH] coda: alloc_upcall: s/task_pgrp_nr/task_pgrp_vnr/

task_pgrp_nr() was wiped from fs/ code recently, task_session_nr() has no
callers since 2e2ba22ea4fd4bb85f0fa37c521066db6775cbef. __pgrp/__session
become write-only. Kill them and the related helpers.

The change in drivers/char/tty_io.c is cosmetic, but hopefully makes sense
anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- CUR/include/linux/sched.h~KILL_S_G_ID	2009-01-18 04:39:12.000000000 +0100
+++ CUR/include/linux/sched.h	2009-01-18 14:10:08.000000000 +0100
@@ -531,25 +531,8 @@ struct signal_struct {
 
 	struct list_head cpu_timers[3];
 
-	/* job control IDs */
-
-	/*
-	 * pgrp and session fields are deprecated.
-	 * use the task_session_Xnr and task_pgrp_Xnr routines below
-	 */
-
-	union {
-		pid_t pgrp __deprecated;
-		pid_t __pgrp;
-	};
-
 	struct pid *tty_old_pgrp;
 
-	union {
-		pid_t session __deprecated;
-		pid_t __session;
-	};
-
 	/* boolean value for session group leader */
 	int leader;
 
@@ -1436,16 +1419,6 @@ static inline int rt_task(struct task_st
 	return rt_prio(p->prio);
 }
 
-static inline void set_task_session(struct task_struct *tsk, pid_t session)
-{
-	tsk->signal->__session = session;
-}
-
-static inline void set_task_pgrp(struct task_struct *tsk, pid_t pgrp)
-{
-	tsk->signal->__pgrp = pgrp;
-}
-
 static inline struct pid *task_pid(struct task_struct *task)
 {
 	return task->pids[PIDTYPE_PID].pid;
@@ -1521,11 +1494,6 @@ static inline pid_t task_tgid_vnr(struct
 }
 
 
-static inline pid_t task_pgrp_nr(struct task_struct *tsk)
-{
-	return tsk->signal->__pgrp;
-}
-
 static inline pid_t task_pgrp_nr_ns(struct task_struct *tsk,
 					struct pid_namespace *ns)
 {
@@ -1538,11 +1506,6 @@ static inline pid_t task_pgrp_vnr(struct
 }
 
 
-static inline pid_t task_session_nr(struct task_struct *tsk)
-{
-	return tsk->signal->__session;
-}
-
 static inline pid_t task_session_nr_ns(struct task_struct *tsk,
 					struct pid_namespace *ns)
 {
--- CUR/kernel/exit.c~KILL_S_G_ID	2009-01-16 02:51:48.000000000 +0100
+++ CUR/kernel/exit.c	2009-01-18 14:16:18.000000000 +0100
@@ -359,16 +359,12 @@ static void reparent_to_kthreadd(void)
 void __set_special_pids(struct pid *pid)
 {
 	struct task_struct *curr = current->group_leader;
-	pid_t nr = pid_nr(pid);
 
-	if (task_session(curr) != pid) {
+	if (task_session(curr) != pid)
 		change_pid(curr, PIDTYPE_SID, pid);
-		set_task_session(curr, nr);
-	}
-	if (task_pgrp(curr) != pid) {
+
+	if (task_pgrp(curr) != pid)
 		change_pid(curr, PIDTYPE_PGID, pid);
-		set_task_pgrp(curr, nr);
-	}
 }
 
 static void set_special_pids(struct pid *pid)
--- CUR/kernel/fork.c~KILL_S_G_ID	2009-01-12 23:07:49.000000000 +0100
+++ CUR/kernel/fork.c	2009-01-18 14:11:56.000000000 +0100
@@ -1259,8 +1259,6 @@ static struct task_struct *copy_process(
 			p->signal->leader_pid = pid;
 			tty_kref_put(p->signal->tty);
 			p->signal->tty = tty_kref_get(current->signal->tty);
-			set_task_pgrp(p, task_pgrp_nr(current));
-			set_task_session(p, task_session_nr(current));
 			attach_pid(p, PIDTYPE_PGID, task_pgrp(current));
 			attach_pid(p, PIDTYPE_SID, task_session(current));
 			list_add_tail_rcu(&p->tasks, &init_task.tasks);
--- CUR/kernel/sys.c~KILL_S_G_ID	2009-01-12 23:07:51.000000000 +0100
+++ CUR/kernel/sys.c	2009-01-18 14:14:08.000000000 +0100
@@ -1003,10 +1003,8 @@ asmlinkage long sys_setpgid(pid_t pid, p
 	if (err)
 		goto out;
 
-	if (task_pgrp(p) != pgrp) {
+	if (task_pgrp(p) != pgrp)
 		change_pid(p, PIDTYPE_PGID, pgrp);
-		set_task_pgrp(p, pid_nr(pgrp));
-	}
 
 	err = 0;
 out:
--- CUR/drivers/char/tty_io.c~KILL_S_G_ID	2009-01-12 23:07:40.000000000 +0100
+++ CUR/drivers/char/tty_io.c	2009-01-18 14:50:05.000000000 +0100
@@ -2680,7 +2680,7 @@ void __do_SAK(struct tty_struct *tty)
 	/* Kill the entire session */
 	do_each_pid_task(session, PIDTYPE_SID, p) {
 		printk(KERN_NOTICE "SAK: killed process %d"
-			" (%s): task_session_nr(p)==tty->session\n",
+			" (%s): task_session(p)==tty->session\n",
 			task_pid_nr(p), p->comm);
 		send_sig(SIGKILL, p, 1);
 	} while_each_pid_task(session, PIDTYPE_SID, p);
@@ -2690,7 +2690,7 @@ void __do_SAK(struct tty_struct *tty)
 	do_each_thread(g, p) {
 		if (p->signal->tty == tty) {
 			printk(KERN_NOTICE "SAK: killed process %d"
-			    " (%s): task_session_nr(p)==tty->session\n",
+			    " (%s): task_session(p)==tty->session\n",
 			    task_pid_nr(p), p->comm);
 			send_sig(SIGKILL, p, 1);
 			continue;

