Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab0BMC4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 21:56:10 -0500
Received: from smtp-out.google.com ([216.239.44.51]:58798 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab0BMC4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 21:56:04 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=PVotXNArEUfSZi/88E2QkCWYH6YGZT1PFR4oqskGfD5AJ4LsWqK3eF5d+pW+ZnIjs
	tY7GH8CRTtnV4Fk2/U/+w==
Subject: [RFC PATCH v1 3/4] sched: throttle cfs_rq entities which exceed their
	local quota
To: linux-kernel@vger.kernel.org
From: Paul <pjt@google.com>
Cc: Paul Menage <menage@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>,
       Chris Friesen <cfriesen@nortel.com>, Avi Kivity <avi@redhat.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Nikhil Rao <ncrao@google.com>, Ingo Molnar <mingo@elte.hu>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Mike Waychison <mikew@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>
Date: Fri, 12 Feb 2010 18:55:08 -0800
Message-ID: <20100213025507.23325.53791.stgit@kitami.corp.google.com>
In-Reply-To: <20100213025417.23325.90048.stgit@kitami.corp.google.com>
References: <20100213025417.23325.90048.stgit@kitami.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Turner <pjt@google.com>

In account_cfs_rq_quota() (via update_curr()) we track consumption versus a
cfs_rq's local quota and whether there is global quota available to continue
enabling it in the event we run out.

This patch adds the required support for the latter case, throttling entities
until quota is available to run.  Throttling dequeues the entity in question
and sends a reschedule to the owning cpu so that it can be evicted.

The following restrictions apply to a throttled cfs_rq:
- It is dequeued from sched_entity hierarchy and restricted from being
  re-enqueued.  This means that new/waking children of this entity will be
  queued up to it, but not past it.
- It does not contribute to weight calculations in tg_shares_up
- In the case that the cfs_rq of the cpu we are trying to pull from is throttled
  it is  is ignored by the loadbalancer in __load_balance_fair() and
  move_one_task_fair().

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched.c      |   12 ++++++++-
 kernel/sched_fair.c |   72 +++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 77 insertions(+), 7 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index fb2ffc6..88fd401 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -463,6 +463,7 @@ struct cfs_rq {
 #endif
 #ifdef CONFIG_CFS_BANDWIDTH
 	u64 quota_assigned, quota_used;
+	int throttled;
 #endif
 #endif
 };
@@ -1691,6 +1692,8 @@ static void update_group_shares_cpu(struct task_group *tg, int cpu,
 	}
 }
 
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq);
+
 /*
  * Re-compute the task group their per cpu shares over the given domain.
  * This needs to be done in a bottom-up fashion because the rq weight of a
@@ -1711,7 +1714,14 @@ static int tg_shares_up(struct task_group *tg, void *data)
 	usd_rq_weight = per_cpu_ptr(update_shares_data, smp_processor_id());
 
 	for_each_cpu(i, sched_domain_span(sd)) {
-		weight = tg->cfs_rq[i]->load.weight;
+		/*
+		 * bandwidth throttled entities cannot contribute to load
+		 * balance
+		 */
+		if (!cfs_rq_throttled(tg->cfs_rq[i]))
+			weight = tg->cfs_rq[i]->load.weight;
+		else
+			weight = 0;
 		usd_rq_weight[i] = weight;
 
 		rq_weight += weight;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f2741ab..da85200 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -272,8 +272,21 @@ static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
 	return &tg->cfs_bandwidth;
 }
 
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return cfs_rq->throttled;
+}
+
 static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
 		unsigned long delta_exec);
+
+#else
+
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return 0;
+}
+
 #endif
 
 /**************************************************************
@@ -797,6 +810,12 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
+
+	if (!entity_is_task(se) && (cfs_rq_throttled(group_cfs_rq(se)) ||
+	     !group_cfs_rq(se)->nr_running)) {
+		return;
+	}
+
 	account_entity_enqueue(cfs_rq, se);
 
 	if (flags & ENQUEUE_WAKEUP) {
@@ -833,6 +852,11 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 	 */
 	update_curr(cfs_rq);
 
+	BUG_ON(!entity_is_task(se) && cfs_rq_throttled(group_cfs_rq(se)) &&
+			se->on_rq);
+	if (!entity_is_task(se) && cfs_rq_throttled(group_cfs_rq(se)))
+		return;
+
 	update_stats_dequeue(cfs_rq, se);
 	if (sleep) {
 #ifdef CONFIG_SCHEDSTATS
@@ -1083,6 +1107,9 @@ static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
 			break;
 		cfs_rq = cfs_rq_of(se);
 		enqueue_entity(cfs_rq, se, flags);
+		/* don't continue to enqueue if our parent is throttled */
+		if (cfs_rq_throttled(cfs_rq))
+			break;
 		flags = ENQUEUE_WAKEUP;
 	}
 
@@ -1102,8 +1129,11 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int sleep)
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 		dequeue_entity(cfs_rq, se, sleep);
-		/* Don't dequeue parent if it has other entities besides us */
-		if (cfs_rq->load.weight)
+		/*
+		 * Don't dequeue parent if it has other entities besides us,
+		 * or if it is throttled
+		 */
+		if (cfs_rq->load.weight || cfs_rq_throttled(cfs_rq))
 			break;
 		sleep = 1;
 	}
@@ -1181,6 +1211,27 @@ static u64 tg_request_cfs_quota(struct task_group *tg)
 	return delta;
 }
 
+static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
+{
+	struct sched_entity *se;
+	int sleep = 0;
+
+	se = cfs_rq->tg->se[cfs_rq->rq->cpu];
+
+	for_each_sched_entity(se) {
+		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+		BUG_ON(!se->on_rq);
+		dequeue_entity(cfs_rq, se, sleep);
+
+		if (cfs_rq->load.weight || cfs_rq_throttled(cfs_rq))
+			break;
+
+		sleep = 1;
+	}
+	cfs_rq->throttled = 1;
+}
+
 static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
 		unsigned long delta_exec)
 {
@@ -1189,10 +1240,16 @@ static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
 
 	cfs_rq->quota_used += delta_exec;
 
-	if (cfs_rq->quota_used < cfs_rq->quota_assigned)
+	if (cfs_rq_throttled(cfs_rq) ||
+		cfs_rq->quota_used < cfs_rq->quota_assigned)
 		return;
 
 	cfs_rq->quota_assigned += tg_request_cfs_quota(cfs_rq->tg);
+
+	if (cfs_rq->quota_used >= cfs_rq->quota_assigned) {
+		throttle_cfs_rq(cfs_rq);
+		resched_task(cfs_rq->rq->curr);
+	}
 }
 
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
@@ -1947,9 +2004,10 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		u64 rem_load, moved_load;
 
 		/*
-		 * empty group
+		 * empty group or throttled cfs_rq
 		 */
-		if (!busiest_cfs_rq->task_weight)
+		if (!busiest_cfs_rq->task_weight ||
+				cfs_rq_throttled(busiest_cfs_rq))
 			continue;
 
 		rem_load = (u64)rem_load_move * busiest_weight;
@@ -1997,6 +2055,9 @@ move_one_task_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	cfs_rq_iterator.next = load_balance_next_fair;
 
 	for_each_leaf_cfs_rq(busiest, busy_cfs_rq) {
+		/* skip throttled cfs_rq */
+		if (cfs_rq_throttled(busy_cfs_rq))
+			continue;
 		/*
 		 * pass busy_cfs_rq argument into
 		 * load_balance_[start|next]_fair iterators
@@ -2173,7 +2234,6 @@ static const struct sched_class fair_sched_class = {
 
 	.task_waking		= task_waking_fair,
 #endif
-
 	.set_curr_task          = set_curr_task_fair,
 	.task_tick		= task_tick_fair,
 	.task_fork		= task_fork_fair,

