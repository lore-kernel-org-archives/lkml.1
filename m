Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbZI3Mw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbZI3Mw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZI3Mw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:52:59 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48108 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbZI3Mw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:52:58 -0400
Date: Wed, 30 Sep 2009 18:21:24 +0530
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
Subject: [RFC v2 PATCH 2/8] sched: Maintain aggregated tasks count in
	cfs_rq at each hierarchy level
Message-ID: <20090930125124.GC19951@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090930124919.GA19951@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930124919.GA19951@in.ibm.com>
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
 3 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c802dcb..c283d0f 100644
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
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 70c7e0b..f4c30bc 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -214,6 +214,8 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 #ifdef CONFIG_SMP
 	SEQ_printf(m, "  .%-30s: %lu\n", "shares", cfs_rq->shares);
 #endif
+	SEQ_printf(m, "  .%-30s: %ld\n", "nr_tasks_running",
+			cfs_rq->nr_tasks_running);
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
 #endif
 }
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 652e8bd..eeeddb8 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -243,6 +243,27 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 
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
@@ -969,6 +990,7 @@ static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
 		wakeup = 1;
 	}
 
+	add_cfs_rq_tasks_running(&p->se, 1);
 	hrtick_update(rq);
 }
 
@@ -991,6 +1013,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int sleep)
 		sleep = 1;
 	}
 
+	sub_cfs_rq_tasks_running(&p->se, 1);
 	hrtick_update(rq);
 }
 
