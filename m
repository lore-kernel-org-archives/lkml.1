Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbYHDG0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbYHDG0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbYHDG0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:26:12 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:48905 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbYHDG0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:26:11 -0400
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <20080804055339.GB5444@linux.vnet.ibm.com>
References: <1217474425.25608.150.camel@ymzhang>
	 <1217489463.25608.157.camel@ymzhang> <1217489949.8157.78.camel@twins>
	 <1217490560.25608.168.camel@ymzhang> <1217551154.25608.169.camel@ymzhang>
	 <20080801051407.GA5232@linux.vnet.ibm.com>
	 <1217826278.25608.198.camel@ymzhang>
	 <20080804052228.GA5444@linux.vnet.ibm.com>
	 <1217828278.25608.206.camel@ymzhang>
	 <20080804055339.GB5444@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 08:26:11 +0200
Message-Id: <1217831171.9016.42.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 11:23 +0530, Dhaval Giani wrote:

> Peter, vatsa, any ideas?

---

Revert:
  a7be37ac8e1565e00880531f4e2aff421a21c803  sched: revert the revert of: weight calculations
  c9c294a630e28eec5f2865f028ecfc58d45c0a5a  sched: fix calc_delta_asym()
  ced8aa16e1db55c33c507174c1b1f9e107445865  sched: fix calc_delta_asym, #2

---
diff --git a/kernel/sched.c b/kernel/sched.c
index 21f7da9..7afb0fc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1244,9 +1244,6 @@ static void resched_task(struct task_struct *p)
  */
 #define SRR(x, y) (((x) + (1UL << ((y) - 1))) >> (y))
 
-/*
- * delta *= weight / lw
- */
 static unsigned long
 calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 		struct load_weight *lw)
@@ -1274,6 +1271,12 @@ calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 	return (unsigned long)min(tmp, (u64)(unsigned long)LONG_MAX);
 }
 
+static inline unsigned long
+calc_delta_fair(unsigned long delta_exec, struct load_weight *lw)
+{
+	return calc_delta_mine(delta_exec, NICE_0_LOAD, lw);
+}
+
 static inline void update_load_add(struct load_weight *lw, unsigned long inc)
 {
 	lw->weight += inc;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index cf2cd6c..593af05 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -334,34 +334,6 @@ int sched_nr_latency_handler(struct ctl_table *table, int write,
 #endif
 
 /*
- * delta *= w / rw
- */
-static inline unsigned long
-calc_delta_weight(unsigned long delta, struct sched_entity *se)
-{
-	for_each_sched_entity(se) {
-		delta = calc_delta_mine(delta,
-				se->load.weight, &cfs_rq_of(se)->load);
-	}
-
-	return delta;
-}
-
-/*
- * delta *= rw / w
- */
-static inline unsigned long
-calc_delta_fair(unsigned long delta, struct sched_entity *se)
-{
-	for_each_sched_entity(se) {
-		delta = calc_delta_mine(delta,
-				cfs_rq_of(se)->load.weight, &se->load);
-	}
-
-	return delta;
-}
-
-/*
  * The idea is to set a period in which each task runs once.
  *
  * When there are too many tasks (sysctl_sched_nr_latency) we have to stretch
@@ -390,80 +362,47 @@ static u64 __sched_period(unsigned long nr_running)
  */
 static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	return calc_delta_weight(__sched_period(cfs_rq->nr_running), se);
+	u64 slice = __sched_period(cfs_rq->nr_running);
+
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+
+		slice *= se->load.weight;
+		do_div(slice, cfs_rq->load.weight);
+	}
+
+
+	return slice;
 }
 
 /*
  * We calculate the vruntime slice of a to be inserted task
  *
- * vs = s*rw/w = p
+ * vs = s/w = p/rw
  */
 static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	unsigned long nr_running = cfs_rq->nr_running;
+	unsigned long weight;
+	u64 vslice;
 
 	if (!se->on_rq)
 		nr_running++;
 
-	return __sched_period(nr_running);
-}
-
-/*
- * The goal of calc_delta_asym() is to be asymmetrically around NICE_0_LOAD, in
- * that it favours >=0 over <0.
- *
- *   -20         |
- *               |
- *     0 --------+-------
- *             .'
- *    19     .'
- *
- */
-static unsigned long
-calc_delta_asym(unsigned long delta, struct sched_entity *se)
-{
-	struct load_weight lw = {
-		.weight = NICE_0_LOAD,
-		.inv_weight = 1UL << (WMULT_SHIFT-NICE_0_SHIFT)
-	};
+	vslice = __sched_period(nr_running);
 
 	for_each_sched_entity(se) {
-		struct load_weight *se_lw = &se->load;
-		unsigned long rw = cfs_rq_of(se)->load.weight;
-
-#ifdef CONFIG_FAIR_SCHED_GROUP
-		struct cfs_rq *cfs_rq = se->my_q;
-		struct task_group *tg = NULL
-
-		if (cfs_rq)
-			tg = cfs_rq->tg;
-
-		if (tg && tg->shares < NICE_0_LOAD) {
-			/*
-			 * scale shares to what it would have been had
-			 * tg->weight been NICE_0_LOAD:
-			 *
-			 *   weight = 1024 * shares / tg->weight
-			 */
-			lw.weight *= se->load.weight;
-			lw.weight /= tg->shares;
-
-			lw.inv_weight = 0;
-
-			se_lw = &lw;
-			rw += lw.weight - se->load.weight;
-		} else
-#endif
+		cfs_rq = cfs_rq_of(se);
 
-		if (se->load.weight < NICE_0_LOAD) {
-			se_lw = &lw;
-			rw += NICE_0_LOAD - se->load.weight;
-		}
+		weight = cfs_rq->load.weight;
+		if (!se->on_rq)
+			weight += se->load.weight;
 
-		delta = calc_delta_mine(delta, rw, se_lw);
+		vslice *= NICE_0_LOAD;
+		do_div(vslice, weight);
 	}
 
-	return delta;
+	return vslice;
 }
 
 /*
@@ -480,7 +419,11 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 
 	curr->sum_exec_runtime += delta_exec;
 	schedstat_add(cfs_rq, exec_clock, delta_exec);
-	delta_exec_weighted = calc_delta_fair(delta_exec, curr);
+	delta_exec_weighted = delta_exec;
+	if (unlikely(curr->load.weight != NICE_0_LOAD)) {
+		delta_exec_weighted = calc_delta_fair(delta_exec_weighted,
+							&curr->load);
+	}
 	curr->vruntime += delta_exec_weighted;
 }
 
@@ -687,17 +630,8 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
-		if (sched_feat(NEW_FAIR_SLEEPERS)) {
-			unsigned long thresh = sysctl_sched_latency;
-
-			/*
-			 * convert the sleeper threshold into virtual time
-			 */
-			if (sched_feat(NORMALIZED_SLEEPER))
-				thresh = calc_delta_fair(thresh, se);
-
-			vruntime -= thresh;
-		}
+		if (sched_feat(NEW_FAIR_SLEEPERS))
+			vruntime -= sysctl_sched_latency;
 
 		/* ensure we never gain time by being placed backwards. */
 		vruntime = max_vruntime(se->vruntime, vruntime);
@@ -1277,13 +1211,11 @@ static unsigned long wakeup_gran(struct sched_entity *se)
 	unsigned long gran = sysctl_sched_wakeup_granularity;
 
 	/*
-	 * More easily preempt - nice tasks, while not making it harder for
-	 * + nice tasks.
+	 * More easily preempt - nice tasks, while not making
+	 * it harder for + nice tasks.
 	 */
-	if (sched_feat(ASYM_GRAN))
-		gran = calc_delta_asym(sysctl_sched_wakeup_granularity, se);
-	else
-		gran = calc_delta_fair(sysctl_sched_wakeup_granularity, se);
+	if (unlikely(se->load.weight > NICE_0_LOAD))
+		gran = calc_delta_fair(gran, &se->load);
 
 	return gran;
 }
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 862b06b..6cd8734 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -1,5 +1,4 @@
 SCHED_FEAT(NEW_FAIR_SLEEPERS, 1)
-SCHED_FEAT(NORMALIZED_SLEEPER, 1)
 SCHED_FEAT(WAKEUP_PREEMPT, 1)
 SCHED_FEAT(START_DEBIT, 1)
 SCHED_FEAT(AFFINE_WAKEUPS, 1)
@@ -7,7 +6,6 @@ SCHED_FEAT(CACHE_HOT_BUDDY, 1)
 SCHED_FEAT(SYNC_WAKEUPS, 1)
 SCHED_FEAT(HRTICK, 1)
 SCHED_FEAT(DOUBLE_TICK, 0)
-SCHED_FEAT(ASYM_GRAN, 1)
 SCHED_FEAT(LB_BIAS, 0)
 SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)


