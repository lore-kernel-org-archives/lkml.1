Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbZG1X4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbZG1X4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZG1XuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:50:13 -0400
Received: from kroah.org ([198.145.64.141]:35804 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbZG1XuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:06 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:57 2009
Message-Id: <20090728234156.900371671@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 37/71] sched_rt: Fix overload bug on rt group scheduling
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=sched_rt-fix-overload-bug-on-rt-group-scheduling.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit a1ba4d8ba9f06a397e97cbd67a93ee306860b40a upstream.

Fixes an easily triggerable BUG() when setting process affinities.

Make sure to count the number of migratable tasks in the same place:
the root rt_rq. Otherwise the number doesn't make sense and we'll hit
the BUG in set_cpus_allowed_rt().

Also, make sure we only count tasks, not groups (this is probably
already taken care of by the fact that rt_se->nr_cpus_allowed will be 0
for groups, but be more explicit)

Tested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Gregory Haskins <ghaskins@novell.com>
LKML-Reference: <1247067476.9777.57.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c    |    1 +
 kernel/sched_rt.c |   18 +++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -497,6 +497,7 @@ struct rt_rq {
 #endif
 #ifdef CONFIG_SMP
 	unsigned long rt_nr_migratory;
+	unsigned long rt_nr_total;
 	int overloaded;
 	struct plist_head pushable_tasks;
 #endif
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -10,6 +10,8 @@ static inline struct task_struct *rt_tas
 
 #ifdef CONFIG_RT_GROUP_SCHED
 
+#define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
+
 static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
 {
 	return rt_rq->rq;
@@ -22,6 +24,8 @@ static inline struct rt_rq *rt_rq_of_se(
 
 #else /* CONFIG_RT_GROUP_SCHED */
 
+#define rt_entity_is_task(rt_se) (1)
+
 static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
 {
 	return container_of(rt_rq, struct rq, rt);
@@ -73,7 +77,7 @@ static inline void rt_clear_overload(str
 
 static void update_rt_migration(struct rt_rq *rt_rq)
 {
-	if (rt_rq->rt_nr_migratory && (rt_rq->rt_nr_running > 1)) {
+	if (rt_rq->rt_nr_migratory && rt_rq->rt_nr_total > 1) {
 		if (!rt_rq->overloaded) {
 			rt_set_overload(rq_of_rt_rq(rt_rq));
 			rt_rq->overloaded = 1;
@@ -86,6 +90,12 @@ static void update_rt_migration(struct r
 
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
 
@@ -94,6 +104,12 @@ static void inc_rt_migration(struct sche
 
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
 


