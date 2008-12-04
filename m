Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbYLDPk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbYLDPk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756389AbYLDPkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:40:05 -0500
Received: from 68-112-229-48.dhcp.oxfr.ma.charter.com ([68.112.229.48]:53196
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756369AbYLDPkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:40:03 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH v3 1/4] sched: cleanup inc/dec_rt_tasks
To: mingo@elte.hu
Cc: peterz@infradead.org, rostedt@goodmis.org, ghaskins@novell.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Date: Thu, 04 Dec 2008 10:43:41 -0500
Message-ID: <20081204154341.21712.37469.stgit@dev.haskins.net>
In-Reply-To: <20081204154100.21712.88806.stgit@dev.haskins.net>
References: <20081204154100.21712.88806.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move some common definitions up to the function prologe to simplify the
body logic.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched_rt.c |   40 +++++++++++++++++-----------------------
 1 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 1bbd990..fb1d4d7 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -550,30 +550,30 @@ static void update_curr_rt(struct rq *rq)
 static inline
 void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
-	WARN_ON(!rt_prio(rt_se_prio(rt_se)));
-	rt_rq->rt_nr_running++;
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
-	if (rt_se_prio(rt_se) < rt_rq->highest_prio) {
+	int prio = rt_se_prio(rt_se);
+#endif
 #ifdef CONFIG_SMP
-		struct rq *rq = rq_of_rt_rq(rt_rq);
+	struct rq *rq = rq_of_rt_rq(rt_rq);
 #endif
 
-		rt_rq->highest_prio = rt_se_prio(rt_se);
+	WARN_ON(!rt_prio(prio));
+	rt_rq->rt_nr_running++;
+#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
+	if (prio < rt_rq->highest_prio) {
+
+		rt_rq->highest_prio = prio;
 #ifdef CONFIG_SMP
 		if (rq->online)
-			cpupri_set(&rq->rd->cpupri, rq->cpu,
-				   rt_se_prio(rt_se));
+			cpupri_set(&rq->rd->cpupri, rq->cpu, prio);
 #endif
 	}
 #endif
 #ifdef CONFIG_SMP
-	if (rt_se->nr_cpus_allowed > 1) {
-		struct rq *rq = rq_of_rt_rq(rt_rq);
-
+	if (rt_se->nr_cpus_allowed > 1)
 		rq->rt.rt_nr_migratory++;
-	}
 
-	update_rt_migration(rq_of_rt_rq(rt_rq));
+	update_rt_migration(rq);
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
 	if (rt_se_boosted(rt_se))
@@ -590,6 +590,7 @@ static inline
 void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
 #ifdef CONFIG_SMP
+	struct rq *rq = rq_of_rt_rq(rt_rq);
 	int highest_prio = rt_rq->highest_prio;
 #endif
 
@@ -611,20 +612,13 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 		rt_rq->highest_prio = MAX_RT_PRIO;
 #endif
 #ifdef CONFIG_SMP
-	if (rt_se->nr_cpus_allowed > 1) {
-		struct rq *rq = rq_of_rt_rq(rt_rq);
+	if (rt_se->nr_cpus_allowed > 1)
 		rq->rt.rt_nr_migratory--;
-	}
 
-	if (rt_rq->highest_prio != highest_prio) {
-		struct rq *rq = rq_of_rt_rq(rt_rq);
-
-		if (rq->online)
-			cpupri_set(&rq->rd->cpupri, rq->cpu,
-				   rt_rq->highest_prio);
-	}
+	if (rq->online && rt_rq->highest_prio != highest_prio)
+		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio);
 
-	update_rt_migration(rq_of_rt_rq(rt_rq));
+	update_rt_migration(rq);
 #endif /* CONFIG_SMP */
 #ifdef CONFIG_RT_GROUP_SCHED
 	if (rt_se_boosted(rt_se))

