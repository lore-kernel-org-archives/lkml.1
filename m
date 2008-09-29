Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbYI2KCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbYI2KCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 06:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYI2KCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 06:02:43 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55671 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbYI2KCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 06:02:42 -0400
Date: Mon, 29 Sep 2008 15:32:27 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: vatsa@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
       aarora@linux.vnet.ibm.com
Subject: [PATCH] sched: minor optimizations in wake_affine and
	select_task_rq_fair
Message-ID: <20080929100227.GA21129@amitarora.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Please consider this patch. It makes a few minor changes to
sched_fair.c.


sched: Minor optimizations in wake_affine and select_task_rq_fair

This patch does following:
o Reduces the number of arguments to wake_affine().
o Removes unused variable "rq".
o Optimizes one of the "if" conditions in wake_affine() - i.e.  if
  "balanced" is true, we need not do rest of the calculations in the
  condition.
o If this cpu is same as the previous cpu (on which woken up task
  was running when it went to sleep), no need to call wake_affine at all.


Signed-off-by: Amit K Arora <aarora@linux.vnet.ibm.com>
CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1143,17 +1143,18 @@ static inline unsigned long effective_lo
 #endif
 
 static int
-wake_affine(struct rq *rq, struct sched_domain *this_sd, struct rq *this_rq,
-	    struct task_struct *p, int prev_cpu, int this_cpu, int sync,
-	    int idx, unsigned long load, unsigned long this_load,
-	    unsigned int imbalance)
+wake_affine(struct sched_domain *this_sd, struct task_struct *p, int prev_cpu,
+	    int this_cpu, int sync, unsigned long load, unsigned long this_load)
 {
+	struct rq *this_rq = cpu_rq(this_cpu);
 	struct task_struct *curr = this_rq->curr;
 	struct task_group *tg;
 	unsigned long tl = this_load;
 	unsigned long tl_per_task;
 	unsigned long weight;
 	int balanced;
+	int idx = this_sd->wake_idx;
+	unsigned int imbalance = 100 + (this_sd->imbalance_pct - 100) / 2;
 
 	if (!(this_sd->flags & SD_WAKE_AFFINE) || !sched_feat(AFFINE_WAKEUPS))
 		return 0;
@@ -1191,8 +1192,8 @@ wake_affine(struct rq *rq, struct sched_
 	schedstat_inc(p, se.nr_wakeups_affine_attempts);
 	tl_per_task = cpu_avg_load_per_task(this_cpu);
 
-	if ((tl <= load && tl + target_load(prev_cpu, idx) <= tl_per_task) ||
-			balanced) {
+	if (balanced || (tl <= load && tl + target_load(prev_cpu, idx) <=
+			tl_per_task)) {
 		/*
 		 * This domain has SD_WAKE_AFFINE and
 		 * p is cache cold in this domain, and
@@ -1211,16 +1212,16 @@ static int select_task_rq_fair(struct ta
 	struct sched_domain *sd, *this_sd = NULL;
 	int prev_cpu, this_cpu, new_cpu;
 	unsigned long load, this_load;
-	struct rq *rq, *this_rq;
 	unsigned int imbalance;
 	int idx;
 
 	prev_cpu	= task_cpu(p);
-	rq		= task_rq(p);
 	this_cpu	= smp_processor_id();
-	this_rq		= cpu_rq(this_cpu);
 	new_cpu		= prev_cpu;
 
+	if (prev_cpu == this_cpu)
+		goto out;
+
 	/*
 	 * 'this_sd' is the first domain that both
 	 * this_cpu and prev_cpu are present in:
@@ -1242,24 +1243,18 @@ static int select_task_rq_fair(struct ta
 		goto out;
 
 	idx = this_sd->wake_idx;
-
-	imbalance = 100 + (this_sd->imbalance_pct - 100) / 2;
-
 	load = source_load(prev_cpu, idx);
 	this_load = target_load(this_cpu, idx);
 
-	if (wake_affine(rq, this_sd, this_rq, p, prev_cpu, this_cpu, sync, idx,
-				     load, this_load, imbalance))
+	if (wake_affine(this_sd, p, prev_cpu, this_cpu, sync, load, this_load))
 		return this_cpu;
 
-	if (prev_cpu == this_cpu)
-		goto out;
-
 	/*
 	 * Start passive balancing when half the imbalance_pct
 	 * limit is reached.
 	 */
 	if (this_sd->flags & SD_WAKE_BALANCE) {
+		imbalance = 100 + (this_sd->imbalance_pct - 100) / 2;
 		if (imbalance*this_load <= 100*load) {
 			schedstat_inc(this_sd, ttwu_move_balance);
 			schedstat_inc(p, se.nr_wakeups_passive);

