Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZGJKmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZGJKmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbZGJKle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:41:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:37769 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627AbZGJKlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:41:32 -0400
Date: Fri, 10 Jul 2009 10:41:02 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, ghaskins@novell.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de,
       ghaskins@novell.com, mingo@elte.hu
In-Reply-To: <1247067476.9777.57.camel@twins>
References: <1247067476.9777.57.camel@twins>
Subject: [tip:sched/urgent] sched_rt: Fix overload bug on rt group scheduling
Message-ID: <tip-a1ba4d8ba9f06a397e97cbd67a93ee306860b40a@git.kernel.org>
Git-Commit-ID: a1ba4d8ba9f06a397e97cbd67a93ee306860b40a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Jul 2009 10:41:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1ba4d8ba9f06a397e97cbd67a93ee306860b40a
Gitweb:     http://git.kernel.org/tip/a1ba4d8ba9f06a397e97cbd67a93ee306860b40a
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 1 Apr 2009 18:40:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 10:43:29 +0200

sched_rt: Fix overload bug on rt group scheduling

Fixes an easily triggerable BUG() when setting process affinities.

Make sure to count the number of migratable tasks in the same place:
the root rt_rq. Otherwise the number doesn't make sense and we'll hit
the BUG in set_cpus_allowed_rt().

Also, make sure we only count tasks, not groups (this is probably
already taken care of by the fact that rt_se->nr_cpus_allowed will be 0
for groups, but be more explicit)

Tested-by: Thomas Gleixner <tglx@linutronix.de>
CC: stable@kernel.org
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Gregory Haskins <ghaskins@novell.com>
LKML-Reference: <1247067476.9777.57.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c    |    1 +
 kernel/sched_rt.c |   18 +++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7c9098d..a17f3d9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -493,6 +493,7 @@ struct rt_rq {
 #endif
 #ifdef CONFIG_SMP
 	unsigned long rt_nr_migratory;
+	unsigned long rt_nr_total;
 	int overloaded;
 	struct plist_head pushable_tasks;
 #endif
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 9bf0d2a..3918e01 100644
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
+	if (rt_rq->rt_nr_migratory && rt_rq->rt_nr_total > 1) {
 		if (!rt_rq->overloaded) {
 			rt_set_overload(rq_of_rt_rq(rt_rq));
 			rt_rq->overloaded = 1;
@@ -86,6 +90,12 @@ static void update_rt_migration(struct rt_rq *rt_rq)
 
 static void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
+	if (!rt_entity_is_task(rt_se))
+		return;
+
+	rt_rq = &rq_of_rt_rq(rt_rq)->rt;
+
+	rt_rq->rt_nr_total++;
 	if (rt_se->nr_cpus_allowed > 1)
 		rt_rq->rt_nr_migratory++;
 
@@ -94,6 +104,12 @@ static void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 
 static void dec_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
+	if (!rt_entity_is_task(rt_se))
+		return;
+
+	rt_rq = &rq_of_rt_rq(rt_rq)->rt;
+
+	rt_rq->rt_nr_total--;
 	if (rt_se->nr_cpus_allowed > 1)
 		rt_rq->rt_nr_migratory--;
 
