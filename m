Return-Path: <linux-kernel-owner+w=401wt.eu-S1762225AbZFOPSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762225AbZFOPSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbZFOPSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:18:13 -0400
Received: from tango.0pointer.de ([85.214.72.216]:59689 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761911AbZFOPSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:18:12 -0400
Date: Mon, 15 Jun 2009 17:17:47 +0200
From: Lennart Poettering <lennart@poettering.net>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] scheduler: introduce SCHED_RESET_ON_FORK scheduling policy
	flag
Message-ID: <20090615151747.GA27380@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This is the third version of the patch, only change is to move the
reset_on_fork flag into a bit hole in the task struct and a rebase on
current master, Peter or Ingo, may I ask you to merge that into your
trees?)

This patch introduces a new flag SCHED_RESET_ON_FORK which can be passed
to the kernel via sched_setscheduler(), ORed in the policy parameter. If
set this will make sure that when the process forks a) the scheduling
priority is reset to DEFAULT_PRIO if it was higher and b) the scheduling
policy is reset to SCHED_NORMAL if it was either SCHED_FIFO or SCHED_RR.

Why have this?

Currently, if a process is real-time scheduled this will 'leak' to all
its child processes. For security reasons it is often (always?) a good
idea to make sure that if a process acquires RT scheduling this is
confined to this process and only this process. More specifically this
makes the per-process resource limit RLIMIT_RTTIME useful for security
purposes, because it makes it impossible to use a fork bomb to
circumvent the per-process RLIMIT_RTTIME accounting.

This feature is also useful for tools like 'renice' which can then
change the nice level of a process without having this spill to all its
child processes.

Why expose this via sched_setscheduler() and not other syscalls such as
prctl() or sched_setparam()?

prctl() does not take a pid parameter. Due to that it would be
impossible to modify this flag for other processes than the current one.

The struct passed to sched_setparam() can unfortunately not be extended
without breaking compatibility, since sched_setparam() lacks a size
parameter.

How to use this from userspace? In your RT program simply replace this:

  sched_setscheduler(pid, SCHED_FIFO, &param);

by this:

  sched_setscheduler(pid, SCHED_FIFO|SCHED_RESET_ON_FORK, &param);

Lennart
---
 include/linux/sched.h |    6 ++++++
 kernel/sched.c        |   47 ++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 44 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 83f3564..bd503ce 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -38,6 +38,8 @@
 #define SCHED_BATCH		3
 /* SCHED_ISO: reserved but not implemented yet */
 #define SCHED_IDLE		5
+/* Can be ORed in to make sure the process is reverted back to SCHED_NORMAL on fork */
+#define SCHED_RESET_ON_FORK     0x40000000
 
 #ifdef __KERNEL__
 
@@ -1209,6 +1211,10 @@ struct task_struct {
 	unsigned did_exec:1;
 	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
 				 * execve */
+
+	/* Revert to default priority/policy when forking */
+	unsigned sched_reset_on_fork:1;
+
 	pid_t pid;
 	pid_t tgid;
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 8ec9d13..1db3e4a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2613,12 +2613,26 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	set_task_cpu(p, cpu);
 
 	/*
-	 * Make sure we do not leak PI boosting priority to the child:
+	 * Revert to default priority/policy on fork if requested. Make sure we
+	 * do not leak PI boosting priority to the child.
 	 */
-	p->prio = current->normal_prio;
+	if (current->sched_reset_on_fork &&
+			(p->policy == SCHED_FIFO || p->policy == SCHED_RR))
+		p->policy = SCHED_NORMAL;
+
+	if (current->sched_reset_on_fork &&
+			(current->normal_prio < DEFAULT_PRIO))
+		p->prio = DEFAULT_PRIO;
+	else
+		p->prio = current->normal_prio;
+
 	if (!rt_prio(p->prio))
 		p->sched_class = &fair_sched_class;
 
+	/* We don't need the reset flag anymore after the fork. It has
+	 * fulfilled its duty. */
+	p->sched_reset_on_fork = 0;
+
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (likely(sched_info_on()))
 		memset(&p->sched_info, 0, sizeof(p->sched_info));
@@ -6094,17 +6108,25 @@ static int __sched_setscheduler(struct task_struct *p, int policy,
 	unsigned long flags;
 	const struct sched_class *prev_class = p->sched_class;
 	struct rq *rq;
+	int reset_on_fork;
 
 	/* may grab non-irq protected spin_locks */
 	BUG_ON(in_interrupt());
 recheck:
 	/* double check policy once rq lock held */
-	if (policy < 0)
+	if (policy < 0) {
+		reset_on_fork = p->sched_reset_on_fork;
 		policy = oldpolicy = p->policy;
-	else if (policy != SCHED_FIFO && policy != SCHED_RR &&
-			policy != SCHED_NORMAL && policy != SCHED_BATCH &&
-			policy != SCHED_IDLE)
-		return -EINVAL;
+	} else {
+		reset_on_fork = !!(policy & SCHED_RESET_ON_FORK);
+		policy &= ~SCHED_RESET_ON_FORK;
+
+		if (policy != SCHED_FIFO && policy != SCHED_RR &&
+				policy != SCHED_NORMAL && policy != SCHED_BATCH &&
+				policy != SCHED_IDLE)
+			return -EINVAL;
+	}
+
 	/*
 	 * Valid priorities for SCHED_FIFO and SCHED_RR are
 	 * 1..MAX_USER_RT_PRIO-1, valid priority for SCHED_NORMAL,
@@ -6148,6 +6170,10 @@ recheck:
 		/* can't change other user's priorities */
 		if (!check_same_owner(p))
 			return -EPERM;
+
+		/* normal users shall not reset the sched_reset_on_fork flag */
+		if (p->sched_reset_on_fork && !reset_on_fork)
+			return -EPERM;
 	}
 
 	if (user) {
@@ -6191,6 +6217,8 @@ recheck:
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
+	p->sched_reset_on_fork = reset_on_fork;
+
 	oldprio = p->prio;
 	__setscheduler(rq, p, policy, param->sched_priority);
 
@@ -6307,14 +6335,15 @@ SYSCALL_DEFINE1(sched_getscheduler, pid_t, pid)
 	if (p) {
 		retval = security_task_getscheduler(p);
 		if (!retval)
-			retval = p->policy;
+			retval = p->policy
+				| (p->sched_reset_on_fork ? SCHED_RESET_ON_FORK : 0);
 	}
 	read_unlock(&tasklist_lock);
 	return retval;
 }
 
 /**
- * sys_sched_getscheduler - get the RT priority of a thread
+ * sys_sched_getparam - get the RT priority of a thread
  * @pid: the pid in question.
  * @param: structure containing the RT priority.
  */
-- 
1.6.2.2



Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
