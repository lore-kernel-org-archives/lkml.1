Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbZE2Iiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbZE2Iiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756376AbZE2Iiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:38:46 -0400
Received: from tango.0pointer.de ([85.214.72.216]:42113 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922AbZE2Iip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:38:45 -0400
Date: Fri, 29 May 2009 10:38:40 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org
Subject: [PATCH] scheduler: introduce SCHED_RESET_ON_FORK scheduling policy
	flag, Second try
Message-ID: <20090529083840.GA15516@omega>
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

(Nobody commented so far, but here's an updated version of the
patch. Basically the only change is that the SCHED_RESET_ON_FORK flag
is now reset on fork()).)

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

This current patch compiles but is not otherwise tested. For now, I am
sending this primarily as a request for comments. So please, I'd love to
hear your comments!

Lennart
---
 include/linux/sched.h |    4 ++++
 kernel/sched.c        |   47 ++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b4c38bc..395ebc4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -38,6 +38,8 @@
 #define SCHED_BATCH		3
 /* SCHED_ISO: reserved but not implemented yet */
 #define SCHED_IDLE		5
+/* Can be ORed in to make sure the process is reverted back to SCHED_NORMAL on fork */
+#define SCHED_RESET_ON_FORK     0x40000000
 
 #ifdef __KERNEL__
 
@@ -1429,6 +1431,8 @@ struct task_struct {
 	/* state flags for use by tracers */
 	unsigned long trace;
 #endif
+	/* Revert to default priority/policy when forking */
+	unsigned sched_reset_on_fork:1;
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/kernel/sched.c b/kernel/sched.c
index 26efa47..2a2eb07 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2529,12 +2529,26 @@ void sched_fork(struct task_struct *p, int clone_flags)
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
@@ -5807,17 +5821,25 @@ static int __sched_setscheduler(struct task_struct *p, int policy,
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
@@ -5861,6 +5883,10 @@ recheck:
 		/* can't change other user's priorities */
 		if (!check_same_owner(p))
 			return -EPERM;
+
+		/* normal users shall not reset the sched_reset_on_fork flag */
+		if (p->sched_reset_on_fork && !reset_on_fork)
+			return -EPERM;
 	}
 
 	if (user) {
@@ -5904,6 +5930,8 @@ recheck:
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
+	p->sched_reset_on_fork = reset_on_fork;
+
 	oldprio = p->prio;
 	__setscheduler(rq, p, policy, param->sched_priority);
 
@@ -6020,14 +6048,15 @@ SYSCALL_DEFINE1(sched_getscheduler, pid_t, pid)
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
lennart [at] poettering [dot] net         ICQ# 11060553
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
