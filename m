Return-Path: <linux-kernel-owner+w=401wt.eu-S1757824AbZLNQc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824AbZLNQc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 11:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbZLNQcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 11:32:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:34104 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103AbZLNQcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 11:32:53 -0500
Date: Mon, 14 Dec 2009 16:31:03 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091209100706.753790977@linutronix.de>
References: <20091209100706.753790977@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Use rcu in sys_sched_getscheduler/sys_sched_getparam()
Message-ID: <tip-5fe85be081edf0ac92d83f9c39e0ab5c1371eb82@git.kernel.org>
Git-Commit-ID: 5fe85be081edf0ac92d83f9c39e0ab5c1371eb82
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5fe85be081edf0ac92d83f9c39e0ab5c1371eb82
Gitweb:     http://git.kernel.org/tip/5fe85be081edf0ac92d83f9c39e0ab5c1371eb82
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 9 Dec 2009 10:14:58 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Dec 2009 17:11:34 +0100

sched: Use rcu in sys_sched_getscheduler/sys_sched_getparam()

read_lock(&tasklist_lock) does not protect
sys_sched_getscheduler and sys_sched_getparam() against a
concurrent update of the policy or scheduler parameters as
do_sched_setscheduler() does not take the tasklist_lock. The
accessed integers can be retrieved w/o locking and are snapshots
anyway.

Using rcu_read_lock() to protect find_task_by_vpid() and prevent
the task struct from going away is not changing the above
situation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20091209100706.753790977@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 258c73c..1782bee 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6458,7 +6458,7 @@ SYSCALL_DEFINE1(sched_getscheduler, pid_t, pid)
 		return -EINVAL;
 
 	retval = -ESRCH;
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	p = find_process_by_pid(pid);
 	if (p) {
 		retval = security_task_getscheduler(p);
@@ -6466,7 +6466,7 @@ SYSCALL_DEFINE1(sched_getscheduler, pid_t, pid)
 			retval = p->policy
 				| (p->sched_reset_on_fork ? SCHED_RESET_ON_FORK : 0);
 	}
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	return retval;
 }
 
@@ -6484,7 +6484,7 @@ SYSCALL_DEFINE2(sched_getparam, pid_t, pid, struct sched_param __user *, param)
 	if (!param || pid < 0)
 		return -EINVAL;
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	p = find_process_by_pid(pid);
 	retval = -ESRCH;
 	if (!p)
@@ -6495,7 +6495,7 @@ SYSCALL_DEFINE2(sched_getparam, pid_t, pid, struct sched_param __user *, param)
 		goto out_unlock;
 
 	lp.sched_priority = p->rt_priority;
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	/*
 	 * This one might sleep, we cannot do it with a spinlock held ...
@@ -6505,7 +6505,7 @@ SYSCALL_DEFINE2(sched_getparam, pid_t, pid, struct sched_param __user *, param)
 	return retval;
 
 out_unlock:
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	return retval;
 }
 
