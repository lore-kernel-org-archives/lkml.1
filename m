Return-Path: <linux-kernel-owner+w=401wt.eu-S1764317AbZDAQjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764317AbZDAQjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759433AbZDAQjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:39:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39872 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbZDAQjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:39:36 -0400
Subject: [PATCH] sched_rt: fix overload bug on rt group scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 01 Apr 2009 18:40:15 +0200
Message-Id: <1238604015.8530.3666.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes an easily triggerable BUG() when setting process affinities.

Make sure to count the number of migratable tasks in the same place:
the root rt_rq. Otherwise the number doesn't make sense and we'll hit
the BUG in set_cpus_allowed_rt().

Also, make sure we only count tasks, not groups (this is probably
already taken care of by the fact that rt_se->nr_cpus_allowed will be 0
for groups, but be more explicit)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Thomas Gleixner <tglx@linutronix.de>
CC: stable@kernel.org
---
 kernel/sched_rt.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index de4469a..c1ee8dc 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -10,6 +10,8 @@ static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
 
 #ifdef CONFIG_RT_GROUP_SCHED
 
+#define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
+
 static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
 {
 	return rt_rq->rq;
@@ -22,6 +24,8 @@ static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
 
 #else /* CONFIG_RT_GROUP_SCHED */
 
+#define rt_entity_is_task(rt_se) (1)
+
 static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
 {
 	return container_of(rt_rq, struct rq, rt);
@@ -73,7 +77,7 @@ static inline void rt_clear_overload(struct rq *rq)
 
 static void update_rt_migration(struct rt_rq *rt_rq)
 {
-	if (rt_rq->rt_nr_migratory && (rt_rq->rt_nr_running > 1)) {
+	if (rt_rq->rt_nr_migratory > 1) {
 		if (!rt_rq->overloaded) {
 			rt_set_overload(rq_of_rt_rq(rt_rq));
 			rt_rq->overloaded = 1;
@@ -86,6 +90,11 @@ static void update_rt_migration(struct rt_rq *rt_rq)
 
 static void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
+	if (!rt_entity_is_task(rt_se))
+		return;
+
+	rt_rq = &rq_of_rt_rq(rt_rq)->rt;
+
 	if (rt_se->nr_cpus_allowed > 1)
 		rt_rq->rt_nr_migratory++;
 
@@ -94,6 +103,11 @@ static void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 
 static void dec_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
+	if (!rt_entity_is_task(rt_se))
+		return;
+
+	rt_rq = &rq_of_rt_rq(rt_rq)->rt;
+
 	if (rt_se->nr_cpus_allowed > 1)
 		rt_rq->rt_nr_migratory--;
 

