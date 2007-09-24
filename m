Return-Path: <linux-kernel-owner+w=401wt.eu-S1761453AbXIXQjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761453AbXIXQjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760950AbXIXQ1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:27:49 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33904 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760939AbXIXQ1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:27:47 -0400
Date: Mon, 24 Sep 2007 22:08:26 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
Cc: dmitry.adamushko@gmail.com, linux-kernel@vger.kernel.org,
       dhaval@linux.vnet.ibm.com, containers@lists.osdl.org,
       kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, efault@gmx.de
Subject: [PATCH 2/5] Fix minor bug in yield + add more debug o/p
Message-ID: <20070924163826.GC10291@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070924163326.GA10291@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924163326.GA10291@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


- Fix a minor bug in yield (seen for CONFIG_FAIR_GROUP_SCHED)
- Print nr_running and load information for cfs_rq in /proc/sched_debug
- Print &rq->cfs statistics as well (usefull for group scheduling)


Signed-off-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by : Dhaval Giani <dhaval@linux.vnet.ibm.com>


---
 kernel/sched_debug.c |    2 ++
 kernel/sched_fair.c  |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

Index: current/kernel/sched_debug.c
===================================================================
--- current.orig/kernel/sched_debug.c
+++ current/kernel/sched_debug.c
@@ -136,6 +136,8 @@ void print_cfs_rq(struct seq_file *m, in
 			SPLIT_NS(spread0));
 	SEQ_printf(m, "  .%-30s: %ld\n", "spread0",
 			cfs_rq->nr_sync_min_vruntime);
+	SEQ_printf(m, "  .%-30s: %ld\n", "nr_running", cfs_rq->nr_running);
+	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
 }
 
 static void print_cpu(struct seq_file *m, int cpu)
Index: current/kernel/sched_fair.c
===================================================================
--- current.orig/kernel/sched_fair.c
+++ current/kernel/sched_fair.c
@@ -726,7 +726,7 @@ static void dequeue_task_fair(struct rq 
  */
 static void yield_task_fair(struct rq *rq)
 {
-	struct cfs_rq *cfs_rq = &rq->cfs;
+	struct cfs_rq *cfs_rq = task_cfs_rq(rq->curr);
 	struct rb_node **link = &cfs_rq->tasks_timeline.rb_node;
 	struct sched_entity *rightmost, *se = &rq->curr->se;
 	struct rb_node *parent;
@@ -1025,6 +1025,7 @@ static void print_cfs_stats(struct seq_f
 {
 	struct cfs_rq *cfs_rq;
 
+	print_cfs_rq(m, cpu, &cpu_rq(cpu)->cfs);
 	for_each_leaf_cfs_rq(cpu_rq(cpu), cfs_rq)
 		print_cfs_rq(m, cpu, cfs_rq);
 }

-- 
Regards,
vatsa
