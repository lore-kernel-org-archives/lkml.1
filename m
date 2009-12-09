Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbZLIKPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbZLIKPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 05:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbZLIKPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 05:15:13 -0500
Received: from www.tglx.de ([62.245.132.106]:39997 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687AbZLIKPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 05:15:08 -0500
Message-Id: <20091209100706.753790977@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 09 Dec 2009 10:14:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 1/4] sched: Use rcu in
	sys_sched_getscheduler/sys_sched_getparam()
References: <20091209100540.511353305@linutronix.de>
Content-Disposition: inline; filename=sched-use-rcu-in-sched_getscheduler.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

read_lock(&tasklist_lock) does not protect sys_sched_getscheduler and
sys_sched_getparam() against a concurrent update of the policy or
scheduler parameters as do_sched_setscheduler() does not take the
tasklist_lock. The accessed integers can be retrieved w/o locking and
are snapshots anyway.

Using rcu_read_lock() to protect find_task_by_vpid() and prevent the
task struct from going away is not changing the above situation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6-tip/kernel/sched.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched.c
+++ linux-2.6-tip/kernel/sched.c
@@ -6477,7 +6477,7 @@ SYSCALL_DEFINE1(sched_getscheduler, pid_
 		return -EINVAL;
 
 	retval = -ESRCH;
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	p = find_process_by_pid(pid);
 	if (p) {
 		retval = security_task_getscheduler(p);
@@ -6485,7 +6485,7 @@ SYSCALL_DEFINE1(sched_getscheduler, pid_
 			retval = p->policy
 				| (p->sched_reset_on_fork ? SCHED_RESET_ON_FORK : 0);
 	}
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	return retval;
 }
 
@@ -6503,7 +6503,7 @@ SYSCALL_DEFINE2(sched_getparam, pid_t, p
 	if (!param || pid < 0)
 		return -EINVAL;
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	p = find_process_by_pid(pid);
 	retval = -ESRCH;
 	if (!p)
@@ -6514,7 +6514,7 @@ SYSCALL_DEFINE2(sched_getparam, pid_t, p
 		goto out_unlock;
 
 	lp.sched_priority = p->rt_priority;
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	/*
 	 * This one might sleep, we cannot do it with a spinlock held ...
@@ -6524,7 +6524,7 @@ SYSCALL_DEFINE2(sched_getparam, pid_t, p
 	return retval;
 
 out_unlock:
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	return retval;
 }
 


