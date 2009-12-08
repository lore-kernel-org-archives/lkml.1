Return-Path: <linux-kernel-owner+w=401wt.eu-S966049AbZLHUYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966049AbZLHUYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966026AbZLHUYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:24:34 -0500
Received: from www.tglx.de ([62.245.132.106]:45476 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965996AbZLHUYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:24:32 -0500
Message-Id: <20091208202026.769251187@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 08 Dec 2009 20:24:16 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 1/2] sched: Protect task->cpus_allowed access in
	sched_getaffinity()
Content-Disposition: inline;
	filename=sched-fix-sched-get-affinity-racy-access.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_getaffinity() is not protected against a concurrent modification
of the tasks affinity.

Serialize the access with task_rq_lock(task).

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6-tip/kernel/sched.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched.c
+++ linux-2.6-tip/kernel/sched.c
@@ -6631,6 +6631,8 @@ SYSCALL_DEFINE3(sched_setaffinity, pid_t
 long sched_getaffinity(pid_t pid, struct cpumask *mask)
 {
 	struct task_struct *p;
+	unsigned long flags;
+	struct rq *rq;
 	int retval;
 
 	get_online_cpus();
@@ -6645,7 +6647,9 @@ long sched_getaffinity(pid_t pid, struct
 	if (retval)
 		goto out_unlock;
 
+	rq = task_rq_lock(p, &flags);
 	cpumask_and(mask, &p->cpus_allowed, cpu_online_mask);
+	task_rq_unlock(rq, &flags);
 
 out_unlock:
 	read_unlock(&tasklist_lock);


