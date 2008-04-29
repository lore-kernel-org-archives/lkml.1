Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbYD2Mme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbYD2Mme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbYD2Mm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:42:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:45147 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754231AbYD2MmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:42:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18vSWE2mmovpRoZq8/0PbgKrhbdvyYJB80Q5n7PvH
	RD/XAKoWM/QwCB
Subject: [patch] fix sched_debug livelock
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 14:42:21 +0200
Message-Id: <1209472941.4874.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resending, didn't cc lkml)

Revert debugging commit 7ba2e74ab5a0518bc953042952dd165724bc70c9.  print_cfs_rq_tasks()
can induce live-lock if a task is dequeued during list traversal.

Signed-off-by: Mike Galbraith <efault@gmx.de>

index 89fa32b..d72e8b4 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1611,30 +1611,6 @@ static const struct sched_class fair_sched_class = {
 };
 
 #ifdef CONFIG_SCHED_DEBUG
-static void
-print_cfs_rq_tasks(struct seq_file *m, struct cfs_rq *cfs_rq, int depth)
-{
-	struct sched_entity *se;
-
-	if (!cfs_rq)
-		return;
-
-	list_for_each_entry_rcu(se, &cfs_rq->tasks, group_node) {
-		int i;
-
-		for (i = depth; i; i--)
-			seq_puts(m, "  ");
-
-		seq_printf(m, "%lu %s %lu\n",
-				se->load.weight,
-				entity_is_task(se) ? "T" : "G",
-				calc_delta_weight(SCHED_LOAD_SCALE, se)
-				);
-		if (!entity_is_task(se))
-			print_cfs_rq_tasks(m, group_cfs_rq(se), depth + 1);
-	}
-}
-
 static void print_cfs_stats(struct seq_file *m, int cpu)
 {
 	struct cfs_rq *cfs_rq;
@@ -1642,9 +1618,6 @@ static void print_cfs_stats(struct seq_file *m, int cpu)
 	rcu_read_lock();
 	for_each_leaf_cfs_rq(cpu_rq(cpu), cfs_rq)
 		print_cfs_rq(m, cpu, cfs_rq);
-
-	seq_printf(m, "\nWeight tree:\n");
-	print_cfs_rq_tasks(m, &cpu_rq(cpu)->cfs, 1);
 	rcu_read_unlock();
 }
 #endif


