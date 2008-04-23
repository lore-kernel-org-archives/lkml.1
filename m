Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbYDWWIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbYDWWIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 18:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbYDWWIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 18:08:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39937 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbYDWWIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 18:08:39 -0400
Subject: [RFC][PATCH 1/2] sched: higher granularity load on 64bit systems
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
Content-Type: text/plain
Date: Thu, 24 Apr 2008 00:07:56 +0200
Message-Id: <1208988476.2849.8.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

The below is an RFC because for some reason it regresses kbuild by 5% on
my machine (and more on the largesmp that are the reason for it).

I'm failing to see how adding a few shifts can cause this.

---

Subject: sched: higher granularity load on 64bit systems

Group scheduling stretches the 10 bit fixed point arithmetic in two ways:
 1) shares - fraction of a groups weight
 2) group load - recursive fraction of load

Esp. on LargeSMP 1) is a large problem as a group with load 1024 can easily
run into numerical trouble on a 128 CPU machine.

Increase the fixed point fraction to 20 bits on 64-bit machines (as LargeSMP
is hardly available on 32 bit).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    5 +++++
 kernel/sched.c        |   28 ++++++++++++++++++++--------
 kernel/sched_fair.c   |    2 +-
 3 files changed, 26 insertions(+), 9 deletions(-)

Index: linux-2.6-2/include/linux/sched.h
===================================================================
--- linux-2.6-2.orig/include/linux/sched.h
+++ linux-2.6-2/include/linux/sched.h
@@ -686,7 +686,12 @@ enum cpu_idle_type {
 /*
  * Increase resolution of nice-level calculations:
  */
+#if BITS_PER_LONG == 64
+#define SCHED_LOAD_SHIFT	20
+#else
 #define SCHED_LOAD_SHIFT	10
+#endif
+
 #define SCHED_LOAD_SCALE	(1L << SCHED_LOAD_SHIFT)
 
 #define SCHED_LOAD_SCALE_FUZZ	SCHED_LOAD_SCALE
Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -1416,6 +1416,15 @@ static void __resched_task(struct task_s
 }
 #endif
 
+/*
+ * We keep the prio_to_weight and its inverse in base WEIGHT_SHIFT
+ */
+#define WEIGHT_SHIFT 		10
+#define WEIGHT_LOAD_SHIFT	(SCHED_LOAD_SHIFT - WEIGHT_SHIFT)
+
+#define WLS(x)		((x) << WEIGHT_LOAD_SHIFT)
+#define inv_WLS(x)	((x) >> WEIGHT_LOAD_SHIFT)
+
 #if BITS_PER_LONG == 32
 # define WMULT_CONST	(~0UL)
 #else
@@ -1438,10 +1447,13 @@ calc_delta_mine(unsigned long delta_exec
 {
 	u64 tmp;
 
-	if (unlikely(!lw->inv_weight))
-		lw->inv_weight = (WMULT_CONST-lw->weight/2) / (lw->weight+1);
+	if (unlikely(!lw->inv_weight)) {
+		unsigned long inv_wls = inv_WLS(lw->weight);
+
+		lw->inv_weight = 1 + (WMULT_CONST-inv_wls/2) / (inv_wls+1);
+	}
 
-	tmp = (u64)delta_exec * weight;
+	tmp = inv_WLS((u64)delta_exec * weight);
 	/*
 	 * Check whether we'd overflow the 64-bit multiplication:
 	 */
@@ -1960,7 +1972,7 @@ static void dec_nr_running(struct rq *rq
 static void set_load_weight(struct task_struct *p)
 {
 	if (task_has_rt_policy(p)) {
-		p->se.load.weight = prio_to_weight[0] * 2;
+		p->se.load.weight = WLS(prio_to_weight[0] * 2);
 		p->se.load.inv_weight = prio_to_wmult[0] >> 1;
 		return;
 	}
@@ -1969,12 +1981,12 @@ static void set_load_weight(struct task_
 	 * SCHED_IDLE tasks get minimal weight:
 	 */
 	if (p->policy == SCHED_IDLE) {
-		p->se.load.weight = WEIGHT_IDLEPRIO;
+		p->se.load.weight = WLS(WEIGHT_IDLEPRIO);
 		p->se.load.inv_weight = WMULT_IDLEPRIO;
 		return;
 	}
 
-	p->se.load.weight = prio_to_weight[p->static_prio - MAX_RT_PRIO];
+	p->se.load.weight = WLS(prio_to_weight[p->static_prio - MAX_RT_PRIO]);
 	p->se.load.inv_weight = prio_to_wmult[p->static_prio - MAX_RT_PRIO];
 }
 
@@ -8072,7 +8084,7 @@ static void init_tg_cfs_entry(struct tas
 
 	se->my_q = cfs_rq;
 	se->load.weight = tg->shares;
-	se->load.inv_weight = div64_64(1ULL<<32, se->load.weight);
+	se->load.inv_weight = 0;
 	se->parent = parent;
 }
 #endif
@@ -8739,7 +8751,7 @@ static void __set_se_shares(struct sched
 		dequeue_entity(cfs_rq, se, 0);
 
 	se->load.weight = shares;
-	se->load.inv_weight = div64_64((1ULL<<32), shares);
+	se->load.inv_weight = 0;
 
 	if (on_rq)
 		enqueue_entity(cfs_rq, se, 0);
Index: linux-2.6-2/kernel/sched_fair.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_fair.c
+++ linux-2.6-2/kernel/sched_fair.c
@@ -424,7 +424,7 @@ calc_delta_asym(unsigned long delta, str
 {
 	struct load_weight lw = {
 		.weight = NICE_0_LOAD,
-		.inv_weight = 1UL << (WMULT_SHIFT-NICE_0_SHIFT)
+		.inv_weight = 1UL << (WMULT_SHIFT-WEIGHT_SHIFT),
 	};
 
 	for_each_sched_entity(se) {


