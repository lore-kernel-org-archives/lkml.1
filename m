Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbZCJBuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbZCJBuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 21:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbZCJBt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 21:49:59 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53986 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbZCJBt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 21:49:58 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: Don't assume possible cpu list have contenious number 
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090310104437.A480.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 10 Mar 2009 10:49:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"for (++cpu ; cpu < num_possible_cpus(); cpu++)" statement assume
possible cpus have contenious number. but that's wrong assumption.

Insted, cpumask_next() should be used.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/trace/trace_workqueue.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index e6c4d00..46b12db 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -91,7 +91,7 @@ static void probe_workqueue_creation(struct task_struct *wq_thread, int cpu)
 	struct cpu_workqueue_stats *cws;
 	unsigned long flags;
 
-	WARN_ON(cpu < 0 || cpu >= num_possible_cpus());
+	WARN_ON(cpu < 0);
 
 	/* Workqueues are sometimes created in atomic context */
 	cws = kzalloc(sizeof(struct cpu_workqueue_stats), GFP_ATOMIC);
@@ -175,12 +175,12 @@ static void *workqueue_stat_next(void *prev, int idx)
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
 	if (list_is_last(&prev_cws->list, &workqueue_cpu_stat(cpu)->list)) {
 		spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
-		for (++cpu ; cpu < num_possible_cpus(); cpu++) {
-			ret = workqueue_stat_start_cpu(cpu);
-			if (ret)
-				return ret;
-		}
-		return NULL;
+		do {
+			cpu = cpumask_next(cpu, cpu_possible_mask);
+			if (cpu >= nr_cpu_ids)
+				return NULL;
+		} while (!(ret = workqueue_stat_start_cpu(cpu)));
+		return ret;
 	}
 	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
 
-- 
1.6.1.2



