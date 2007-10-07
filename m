Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbXJGVBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbXJGVBX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 17:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbXJGVAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 17:00:00 -0400
Received: from ns.suse.de ([195.135.220.2]:32801 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074AbXJGU76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 16:59:58 -0400
From: Andi Kleen <ak@suse.de>
References: <200710071059.126674000@suse.de>
In-Reply-To: <200710071059.126674000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: [PATCH] [4/6] scheduler: Refactor normalize_rt_tasks
Message-Id: <20071007205957.6DABB1474B@wotan.suse.de>
Date: Sun,  7 Oct 2007 22:59:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Replace a particularly ugly ifdef with an inline and a new macro.
Also split up the function to be easier readable.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux-2.6-sched-devel/kernel/sched.c
===================================================================
--- linux-2.6-sched-devel.orig/kernel/sched.c
+++ linux-2.6-sched-devel/kernel/sched.c
@@ -74,6 +74,12 @@ unsigned long long __attribute__((weak))
 	return (unsigned long long)jiffies * (1000000000 / HZ);
 }
 
+#ifdef CONFIG_SMP
+#define is_migration_thread(p, rq) ((p) == (rq)->migration_thread)
+#else
+#define is_migration_thread(p, rq) 0
+#endif
+
 /*
  * Convert user-nice values [ -20 ... 0 ... 19 ]
  * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
@@ -6534,12 +6540,25 @@ EXPORT_SYMBOL(__might_sleep);
 #endif
 
 #ifdef CONFIG_MAGIC_SYSRQ
+static void normalize_task(struct rq *rq, struct task_struct *p)
+{
+	int on_rq;
+	update_rq_clock(rq);
+	on_rq = p->se.on_rq;
+	if (on_rq)
+		deactivate_task(rq, p, 0);
+	__setscheduler(rq, p, SCHED_NORMAL, 0);
+	if (on_rq) {
+		activate_task(rq, p, 0);
+		resched_task(rq->curr);
+	}
+}
+
 void normalize_rt_tasks(void)
 {
 	struct task_struct *g, *p;
 	unsigned long flags;
 	struct rq *rq;
-	int on_rq;
 
 	read_lock_irq(&tasklist_lock);
 	do_each_thread(g, p) {
@@ -6563,26 +6582,10 @@ void normalize_rt_tasks(void)
 
 		spin_lock_irqsave(&p->pi_lock, flags);
 		rq = __task_rq_lock(p);
-#ifdef CONFIG_SMP
-		/*
-		 * Do not touch the migration thread:
-		 */
-		if (p == rq->migration_thread)
-			goto out_unlock;
-#endif
 
-		update_rq_clock(rq);
-		on_rq = p->se.on_rq;
-		if (on_rq)
-			deactivate_task(rq, p, 0);
-		__setscheduler(rq, p, SCHED_NORMAL, 0);
-		if (on_rq) {
-			activate_task(rq, p, 0);
-			resched_task(rq->curr);
-		}
-#ifdef CONFIG_SMP
- out_unlock:
-#endif
+		if (!is_migration_thread(p, rq))
+			normalize_task(rq, p);
+
 		__task_rq_unlock(rq);
 		spin_unlock_irqrestore(&p->pi_lock, flags);
 	} while_each_thread(g, p);
