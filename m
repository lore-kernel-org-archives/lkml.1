Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbZHYJtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbZHYJtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbZHYJtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:49:05 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36555 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbZHYJtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:49:03 -0400
Date: Tue, 25 Aug 2009 15:19:14 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: [RFC v1 PATCH 2/7] sched: Maintain aggregated tasks count in
	cfs_rq at each hierarchy level
Message-ID: <20090825094914.GR3663@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090825094729.GP3663@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825094729.GP3663@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: Maintain aggregated tasks count in cfs_rq at each hierarchy level

From: Bharata B Rao <bharata@linux.vnet.ibm.com>

This patch adds a counter to cfs_rq (->nr_tasks_running) to record the
aggregated tasks count at each level in the task group hierarchy.
This is needed by later hard limit patches where it is required to
know how many tasks go off the rq when a throttled group entity
is dequeued.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c       |    4 ++++
 kernel/sched_debug.c |    2 ++
 kernel/sched_fair.c  |   23 +++++++++++++++++++++++
 3 files changed, 29 insertions(+)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -477,6 +477,10 @@ struct cfs_rq {
 	unsigned long rq_weight;
 #endif
 #endif
+	/*
+	 * Number of tasks at this heirarchy.
+	 */
+	unsigned long nr_tasks_running;
 };
 
 /* Real-Time classes' related field in a runqueue: */
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -214,6 +214,8 @@ void print_cfs_rq(struct seq_file *m, in
 #ifdef CONFIG_SMP
 	SEQ_printf(m, "  .%-30s: %lu\n", "shares", cfs_rq->shares);
 #endif
+	SEQ_printf(m, "  .%-30s: %ld\n", "nr_tasks_running",
+			cfs_rq->nr_tasks_running);
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
 #endif
 }
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -243,6 +243,27 @@ find_matching_se(struct sched_entity **s
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
+static void add_cfs_rq_tasks_running(struct sched_entity *se,
+		unsigned long count)
+{
+	struct cfs_rq *cfs_rq;
+
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+		cfs_rq->nr_tasks_running += count;
+	}
+}
+
+static void sub_cfs_rq_tasks_running(struct sched_entity *se,
+		unsigned long count)
+{
+	struct cfs_rq *cfs_rq;
+
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+		cfs_rq->nr_tasks_running -= count;
+	}
+}
 
 /**************************************************************
  * Scheduling class tree data structure manipulation methods:
@@ -969,6 +990,7 @@ static void enqueue_task_fair(struct rq 
 		wakeup = 1;
 	}
 
+	add_cfs_rq_tasks_running(&p->se, 1);
 	hrtick_update(rq);
 }
 
@@ -991,6 +1013,7 @@ static void dequeue_task_fair(struct rq 
 		sleep = 1;
 	}
 
+	sub_cfs_rq_tasks_running(&p->se, 1);
 	hrtick_update(rq);
 }
 
