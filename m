Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbZLIKPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbZLIKPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 05:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbZLIKPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 05:15:33 -0500
Received: from www.tglx.de ([62.245.132.106]:40019 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080AbZLIKPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 05:15:31 -0500
Message-Id: <20091209100706.862897167@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 09 Dec 2009 10:15:11 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 4/4] sched: Use rcu in sched_get_rr_param
References: <20091209100540.511353305@linutronix.de>
Content-Disposition: inline; filename=sched-use-rcu-in-sched-get-rr-param.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

read_lock(&tasklist_lock) does not protect sys_sched_get_rr_param()
against a concurrent update of the policy or scheduler parameters as
do_sched_scheduler() does not take the tasklist_lock.

The access to task->sched_class->get_rr_interval is protected by
task_rq_lock(task).

Use rcu_read_lock() to protect find_task_by_vpid() and prevent the
task struct from going away.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-tip/kernel/sched.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched.c
+++ linux-2.6-tip/kernel/sched.c
@@ -6892,7 +6892,7 @@ SYSCALL_DEFINE2(sched_rr_get_interval, p
 		return -EINVAL;
 
 	retval = -ESRCH;
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	p = find_process_by_pid(pid);
 	if (!p)
 		goto out_unlock;
@@ -6905,13 +6905,13 @@ SYSCALL_DEFINE2(sched_rr_get_interval, p
 	time_slice = p->sched_class->get_rr_interval(rq, p);
 	task_rq_unlock(rq, &flags);
 
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	jiffies_to_timespec(time_slice, &t);
 	retval = copy_to_user(interval, &t, sizeof(t)) ? -EFAULT : 0;
 	return retval;
 
 out_unlock:
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	return retval;
 }
 


