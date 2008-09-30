Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbYI3Lqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbYI3Lqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 07:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYI3Lqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 07:46:32 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43339 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbYI3Lqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 07:46:31 -0400
Date: Tue, 30 Sep 2008 17:15:39 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: vatsa@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
       aarora@linux.vnet.ibm.com
Subject: [PATCH][resubmit] sched: minor optimizations in wake_affine and
	select_task_rq_fair
Message-ID: <20080930114539.GB14977@amitarora.in.ibm.com>
References: <20080929100227.GA21129@amitarora.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080929100227.GA21129@amitarora.in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned in http://lkml.org/lkml/2008/9/30/141 , this is the new
patch.


sched: Minor optimizations in wake_affine and select_task_rq_fair

This patch does following:
o Removes unused variable and argument "rq".
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
 kernel/sched_fair.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1143,7 +1143,7 @@ static inline unsigned long effective_lo
 #endif
 
 static int
-wake_affine(struct rq *rq, struct sched_domain *this_sd, struct rq *this_rq,
+wake_affine(struct sched_domain *this_sd, struct rq *this_rq,
 	    struct task_struct *p, int prev_cpu, int this_cpu, int sync,
 	    int idx, unsigned long load, unsigned long this_load,
 	    unsigned int imbalance)
@@ -1191,8 +1191,8 @@ wake_affine(struct rq *rq, struct sched_
 	schedstat_inc(p, se.nr_wakeups_affine_attempts);
 	tl_per_task = cpu_avg_load_per_task(this_cpu);
 
-	if ((tl <= load && tl + target_load(prev_cpu, idx) <= tl_per_task) ||
-			balanced) {
+	if (balanced || (tl <= load && tl + target_load(prev_cpu, idx) <=
+			tl_per_task)) {
 		/*
 		 * This domain has SD_WAKE_AFFINE and
 		 * p is cache cold in this domain, and
@@ -1211,16 +1211,17 @@ static int select_task_rq_fair(struct ta
 	struct sched_domain *sd, *this_sd = NULL;
 	int prev_cpu, this_cpu, new_cpu;
 	unsigned long load, this_load;
-	struct rq *rq, *this_rq;
+	struct rq *this_rq;
 	unsigned int imbalance;
 	int idx;
 
 	prev_cpu	= task_cpu(p);
-	rq		= task_rq(p);
 	this_cpu	= smp_processor_id();
 	this_rq		= cpu_rq(this_cpu);
 	new_cpu		= prev_cpu;
 
+	if (prev_cpu == this_cpu)
+		goto out;
 	/*
 	 * 'this_sd' is the first domain that both
 	 * this_cpu and prev_cpu are present in:
@@ -1248,13 +1249,10 @@ static int select_task_rq_fair(struct ta
 	load = source_load(prev_cpu, idx);
 	this_load = target_load(this_cpu, idx);
 
-	if (wake_affine(rq, this_sd, this_rq, p, prev_cpu, this_cpu, sync, idx,
+	if (wake_affine(this_sd, this_rq, p, prev_cpu, this_cpu, sync, idx,
 				     load, this_load, imbalance))
 		return this_cpu;
 
-	if (prev_cpu == this_cpu)
-		goto out;
-
 	/*
 	 * Start passive balancing when half the imbalance_pct
 	 * limit is reached.
