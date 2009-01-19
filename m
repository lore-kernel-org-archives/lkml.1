Return-Path: <linux-kernel-owner+w=401wt.eu-S1760334AbZASWJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760334AbZASWJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 17:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbZASWJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 17:09:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38586 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbZASWJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 17:09:07 -0500
Date: Mon, 19 Jan 2009 23:05:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Alan Cox <number6@the-village.bc.nu>,
       Ian Kent <raven@themaw.net>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] pids: kill now unused signal_struct-> __pgrp/__session
	and friends
Message-ID: <20090119220554.GA4219@redhat.com>
References: <20090118143354.GA8159@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090118143354.GA8159@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18, Oleg Nesterov wrote:
>
> On top of
> 	[PATCH] autofs: fix the wrong usage of the deprecated task_pgrp_nr()
> 	[PATCH] autofs4: turn ->oz_pgrp into "struct pid *"
> 	[PATCH] coda: alloc_upcall: s/task_pgrp_nr/task_pgrp_vnr/

OK, it was bad idea. I still think the usage of task_pgrp_nr() in
fs code is wrong, but it turns out this needs more discussion with
maintainers.

Please find the new patch below, it doesn't depend on the patches above.
The only difference is that the new version doesn't kill task_pgrp_nr()
but reimplements it via task_pgrp_nr_ns(tsk, &init_pid_ns).

------
[PATCH -mm] pids: kill signal_struct-> __pgrp/__session and friends

(depends on pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch)

We are wasting 2 words in signal_struct without any reason to implement
task_pgrp_nr() and task_session_nr().

task_session_nr() has no callers since 2e2ba22ea4fd4bb85f0fa37c521066db6775cbef,
we can remove it.

task_pgrp_nr() is still (I believe wrongly) used in fs/autofsX and fs/coda.

This patch reimplements task_pgrp_nr() via task_pgrp_nr_ns(), and kills
__pgrp/__session and the related helpers.

The change in drivers/char/tty_io.c is cosmetic, but hopefully makes sense
anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
TTY-parts-Acked-by: Alan Cox <number6@the-village.bc.nu>

--- CUR/include/linux/sched.h~KILL_S_G_ID	2009-01-19 22:37:53.000000000 +0100
+++ CUR/include/linux/sched.h	2009-01-19 22:45:06.000000000 +0100
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
@@ -1554,6 +1517,12 @@ static inline pid_t task_session_vnr(str
 	return __task_pid_nr_ns(tsk, PIDTYPE_SID, NULL);
 }
 
+/* obsolete, do not use */
+static inline pid_t task_pgrp_nr(struct task_struct *tsk)
+{
+	return task_pgrp_nr_ns(tsk, &init_pid_ns);
+}
+
 /**
  * pid_alive - check that a task structure is not stale
  * @p: Task structure to be checked.
--- CUR/kernel/exit.c~KILL_S_G_ID	2009-01-19 22:37:53.000000000 +0100
+++ CUR/kernel/exit.c	2009-01-19 22:39:40.000000000 +0100
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
--- CUR/kernel/fork.c~KILL_S_G_ID	2009-01-19 22:37:53.000000000 +0100
+++ CUR/kernel/fork.c	2009-01-19 22:39:40.000000000 +0100
@@ -1259,8 +1259,6 @@ static struct task_struct *copy_process(
 			p->signal->leader_pid = pid;
 			tty_kref_put(p->signal->tty);
 			p->signal->tty = tty_kref_get(current->signal->tty);
-			set_task_pgrp(p, task_pgrp_nr(current));
-			set_task_session(p, task_session_nr(current));
 			attach_pid(p, PIDTYPE_PGID, task_pgrp(current));
 			attach_pid(p, PIDTYPE_SID, task_session(current));
 			list_add_tail_rcu(&p->tasks, &init_task.tasks);
--- CUR/kernel/sys.c~KILL_S_G_ID	2009-01-19 22:37:53.000000000 +0100
+++ CUR/kernel/sys.c	2009-01-19 22:39:40.000000000 +0100
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
--- CUR/drivers/char/tty_io.c~KILL_S_G_ID	2009-01-19 22:37:53.000000000 +0100
+++ CUR/drivers/char/tty_io.c	2009-01-19 22:39:40.000000000 +0100
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

