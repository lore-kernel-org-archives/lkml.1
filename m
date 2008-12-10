Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbYLJTpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbYLJTpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 14:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756058AbYLJToa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 14:44:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:46407 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbYLJTo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 14:44:29 -0500
Message-Id: <20081210194255.370293849@chello.nl>
References: <20081210194048.464111787@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 10 Dec 2008 20:40:50 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, dhaval@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
       cfriesen@nortel.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/2] sched: group nice
Content-Disposition: inline; filename=sched-group-nice.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

allow to use nice values to set group weights

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -8558,6 +8558,17 @@ static inline void unregister_fair_sched
 {
 	list_del_rcu(&tg->cfs_rq[cpu]->leaf_cfs_rq_list);
 }
+
+static int cpu_nice_write(struct cgroup *cgrp, struct cftype *cftype,
+			  s64 niceval)
+{
+	return sched_group_set_nice(cgroup_tg(cgrp), niceval);
+}
+
+static s64 cpu_nice_read(struct cgroup *cgrp, struct cftype *cftype)
+{
+	return sched_group_nice(cgroup_tg(cgrp));
+}
 #else /* !CONFG_FAIR_GROUP_SCHED */
 static inline void free_fair_sched_group(struct task_group *tg)
 {
@@ -8867,6 +8878,29 @@ unsigned long sched_group_weight(struct 
 {
 	return tg->weight;
 }
+
+static int sched_group_set_nice(struct task_group *tg, int nice)
+{
+	unsigned int prio = nice + 20;
+
+	if (prio > ARRAY_SIZE(prio_to_weight))
+		return -EINVAL;
+
+	sched_group_set_weight(tg, prio_to_weight[prio]);
+	return 0;
+}
+
+static int sched_group_nice(struct task_group *tg)
+{
+	unsigned long weight = sched_group_weight(tg);
+	int prio;
+
+	for (prio = 0; prio < ARRAY_SIZE(prio_to_weight); prio++)
+		if (prio_to_weight[prio] <= weight)
+			break;
+
+	return prio - 20;
+}
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -9233,6 +9267,11 @@ static struct cftype cpu_files[] = {
 		.read_u64 = cpu_weight_read_u64,
 		.write_u64 = cpu_weight_write_u64,
 	},
+	{
+		.name = "nice",
+		.read_s64 = cpu_nice_read,
+		.write_s64 = cpu_nice_write,
+	},
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
 	{

-- 

