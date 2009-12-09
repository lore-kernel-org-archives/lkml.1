Return-Path: <linux-kernel-owner+w=401wt.eu-S1755016AbZLIKPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbZLIKPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 05:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbZLIKPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 05:15:20 -0500
Received: from www.tglx.de ([62.245.132.106]:40004 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117AbZLIKPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 05:15:11 -0500
Message-Id: <20091209100706.789059966@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 09 Dec 2009 10:15:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 2/4] sched: Use rcu in sched_get/set_affinity()
References: <20091209100540.511353305@linutronix.de>
Content-Disposition: inline; filename=sched-use-rcu-in-affinity-get-set.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tasklist_lock is held read locked to protect the find_task_by_vpid()
call and to prevent the task going away. sched_setaffinity acquires a
task struct ref and drops tasklist lock right away. The access to the
cpus_allowed mask is protected by rq->lock.

rcu_read_lock() provides the same protection here.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

Index: linux-2.6-tip/kernel/sched.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched.c
+++ linux-2.6-tip/kernel/sched.c
@@ -6535,22 +6535,18 @@ long sched_setaffinity(pid_t pid, const 
 	int retval;
 
 	get_online_cpus();
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 
 	p = find_process_by_pid(pid);
 	if (!p) {
-		read_unlock(&tasklist_lock);
+		rcu_read_unlock();
 		put_online_cpus();
 		return -ESRCH;
 	}
 
-	/*
-	 * It is not safe to call set_cpus_allowed with the
-	 * tasklist_lock held. We will bump the task_struct's
-	 * usage count and then drop tasklist_lock.
-	 */
+	/* Prevent p going away */
 	get_task_struct(p);
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	if (!alloc_cpumask_var(&cpus_allowed, GFP_KERNEL)) {
 		retval = -ENOMEM;
@@ -6636,7 +6632,7 @@ long sched_getaffinity(pid_t pid, struct
 	int retval;
 
 	get_online_cpus();
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 
 	retval = -ESRCH;
 	p = find_process_by_pid(pid);
@@ -6652,7 +6648,7 @@ long sched_getaffinity(pid_t pid, struct
 	task_rq_unlock(rq, &flags);
 
 out_unlock:
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	put_online_cpus();
 
 	return retval;


