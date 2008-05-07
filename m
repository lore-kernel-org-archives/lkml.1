Return-Path: <linux-kernel-owner+w=401wt.eu-S1760486AbYEGJer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760486AbYEGJer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 05:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbYEGJeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 05:34:16 -0400
Received: from mga10.intel.com ([192.55.52.92]:5001 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751497AbYEGJeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 05:34:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,447,1204531200"; 
   d="scan'208";a="325371037"
Subject: Re: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080507091611.GA30645@elte.hu>
References: <1210136148.3453.59.camel@ymzhang>
	 <20080507091611.GA30645@elte.hu>
Content-Type: multipart/mixed; boundary="=-Ec+TtMykLMZ7ieqOTOEo"
Date: Wed, 07 May 2008 17:33:12 +0800
Message-Id: <1210152792.3453.84.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ec+TtMykLMZ7ieqOTOEo
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Wed, 2008-05-07 at 11:16 +0200, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > ???Comparing with kernel 2.6.25, sysbench+mysql(oltp, readonly) has many
> > regression with 2.6.26-rc1.
> > 
> > 1) 8-core stoakley: 28%;
> > 2) 16-core tigerton: 20%;
> > 3) Itanium Montvale: 50%.
> > 
> > Bisect located below patch.
> 
> thanks Yanmin, i've queued up your reverter patch.
Sorry. The reverting patch has a comment-out block. I need delete it if you queue the
patch officially.

--=-Ec+TtMykLMZ7ieqOTOEo
Content-Disposition: attachment; filename=revert_fair_weight_calculation.patch
Content-Type: text/x-patch; name=revert_fair_weight_calculation.patch; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

diff -Nraup linux-2.6.26-rc1/kernel/sched.c linux-2.6.26-rc1_oltp/kernel/sched.c
--- linux-2.6.26-rc1/kernel/sched.c	2008-05-06 06:27:56.000000000 +0800
+++ linux-2.6.26-rc1_oltp/kernel/sched.c	2008-05-07 03:57:39.000000000 +0800
@@ -1429,9 +1429,6 @@ static void __resched_task(struct task_s
  */
 #define SRR(x, y) (((x) + (1UL << ((y) - 1))) >> (y))
 
-/*
- * delta *= weight / lw
- */
 static unsigned long
 calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 		struct load_weight *lw)
@@ -1454,6 +1451,12 @@ calc_delta_mine(unsigned long delta_exec
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
diff -Nraup linux-2.6.26-rc1/kernel/sched_fair.c linux-2.6.26-rc1_oltp/kernel/sched_fair.c
--- linux-2.6.26-rc1/kernel/sched_fair.c	2008-05-06 06:27:56.000000000 +0800
+++ linux-2.6.26-rc1_oltp/kernel/sched_fair.c	2008-05-07 10:28:25.000000000 +0800
@@ -334,34 +334,6 @@ int sched_nr_latency_handler(struct ctl_
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
@@ -390,54 +362,47 @@ static u64 __sched_period(unsigned long 
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
+		cfs_rq = cfs_rq_of(se);
 
-		if (se->load.weight < NICE_0_LOAD)
-			se_lw = &lw;
+		weight = cfs_rq->load.weight;
+		if (!se->on_rq)
+			weight += se->load.weight;
 
-		delta = calc_delta_mine(delta,
-				cfs_rq_of(se)->load.weight, se_lw);
+		vslice *= NICE_0_LOAD;
+		do_div(vslice, weight);
 	}
 
-	return delta;
+	return vslice;
 }
 
 /*
@@ -454,7 +419,11 @@ __update_curr(struct cfs_rq *cfs_rq, str
 
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
 
@@ -663,7 +632,8 @@ place_entity(struct cfs_rq *cfs_rq, stru
 		/* sleeps upto a single latency don't count. */
 		if (sched_feat(NEW_FAIR_SLEEPERS)) {
 			if (sched_feat(NORMALIZED_SLEEPER))
-				vruntime -= calc_delta_weight(sysctl_sched_latency, se);
+				vruntime -= calc_delta_fair(sysctl_sched_latency,
+						&cfs_rq->load);
 			else
 				vruntime -= sysctl_sched_latency;
 		}
@@ -1162,10 +1132,11 @@ static unsigned long wakeup_gran(struct 
 	unsigned long gran = sysctl_sched_wakeup_granularity;
 
 	/*
-	 * More easily preempt - nice tasks, while not making it harder for
-	 * + nice tasks.
+	 * More easily preempt - nice tasks, while not making
+	 * it harder for + nice tasks.
 	 */
-	gran = calc_delta_asym(sysctl_sched_wakeup_granularity, se);
+	if (unlikely(se->load.weight > NICE_0_LOAD))
+		gran = calc_delta_fair(gran, &se->load);
 
 	return gran;
 }
@@ -1625,11 +1596,6 @@ print_cfs_rq_tasks(struct seq_file *m, s
 		for (i = depth; i; i--)
 			seq_puts(m, "  ");
 
-		seq_printf(m, "%lu %s %lu\n",
-				se->load.weight,
-				entity_is_task(se) ? "T" : "G",
-				calc_delta_weight(SCHED_LOAD_SCALE, se)
-				);
 		if (!entity_is_task(se))
 			print_cfs_rq_tasks(m, group_cfs_rq(se), depth + 1);
 	}

--=-Ec+TtMykLMZ7ieqOTOEo--

