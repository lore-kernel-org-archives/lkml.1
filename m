Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbZGWTWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbZGWTWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 15:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbZGWTWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 15:22:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48184 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbZGWTVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 15:21:12 -0400
Message-Id: <20090723191957.495377385@chello.nl>
References: <20090723191642.780643661@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 21:16:52 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 10/13] sched: Optimize unused cgroup configuration
Content-Disposition: inline; filename=sched-opt-cgroup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cgroup group scheduling is build in, skip some code paths if we
don't have any (but the root) cgroups configured.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1616,8 +1616,14 @@ static int tg_load_down(struct task_grou
 
 static void update_shares(struct sched_domain *sd)
 {
-	u64 now = cpu_clock(raw_smp_processor_id());
-	s64 elapsed = now - sd->last_update;
+	s64 elapsed;
+	u64 now;
+
+	if (root_task_group_empty())
+		return;
+
+	now = cpu_clock(raw_smp_processor_id());
+	elapsed = now - sd->last_update;
 
 	if (elapsed >= (s64)(u64)sysctl_sched_shares_ratelimit) {
 		sd->last_update = now;
@@ -1627,6 +1633,9 @@ static void update_shares(struct sched_d
 
 static void update_shares_locked(struct rq *rq, struct sched_domain *sd)
 {
+	if (root_task_group_empty())
+		return;
+
 	spin_unlock(&rq->lock);
 	update_shares(sd);
 	spin_lock(&rq->lock);
@@ -1634,6 +1643,9 @@ static void update_shares_locked(struct 
 
 static void update_h_load(long cpu)
 {
+	if (root_task_group_empty())
+		return;
+
 	walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
 }
 

-- 

