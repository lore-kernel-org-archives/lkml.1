Return-Path: <linux-kernel-owner+w=401wt.eu-S966040AbZLHUYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966040AbZLHUYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966014AbZLHUYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:24:32 -0500
Received: from www.tglx.de ([62.245.132.106]:45475 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965988AbZLHUYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:24:32 -0500
Message-Id: <20091208202026.804386447@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 08 Dec 2009 20:24:22 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 2/2] sched: Protect sched_rr_get_param access to
	task->sched_class
Content-Disposition: inline; filename=sched-fix-sched-get-rr-param-race.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_rr_get_param calls task->sched_class->get_rr_interval(task)
without protection against a concurrent sched_setscheduler() call
which modifies task->sched_class.

Serialize the access with task_rq_lock(task);

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6-tip/kernel/sched.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched.c
+++ linux-2.6-tip/kernel/sched.c
@@ -6887,6 +6887,8 @@ SYSCALL_DEFINE2(sched_rr_get_interval, p
 {
 	struct task_struct *p;
 	unsigned int time_slice;
+	unsigned long flags;
+	struct rq *rq;
 	int retval;
 	struct timespec t;
 
@@ -6903,7 +6905,9 @@ SYSCALL_DEFINE2(sched_rr_get_interval, p
 	if (retval)
 		goto out_unlock;
 
+	rq = task_rq_lock(p, &flags);
 	time_slice = p->sched_class->get_rr_interval(p);
+	task_rq_unlock(rq, &flags);
 
 	read_unlock(&tasklist_lock);
 	jiffies_to_timespec(time_slice, &t);


