Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbYKSGtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbYKSGtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 01:49:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYKSGs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 01:48:56 -0500
Received: from smtp-out.google.com ([216.239.45.13]:7483 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYKSGs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 01:48:56 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:content-transfer-encoding;
	b=vcJpkRHbi7kbYLgjq0dP1T3RIIKiNjKXdpYcGm2JSZdHkr1EAPy82JxbIF7iRa4PI
	K8qZIY+KDsf6lu6B9BVEA==
MIME-Version: 1.0
Date: Tue, 18 Nov 2008 22:48:45 -0800
Message-ID: <b040c32a0811182248s1174c82avf44c720ae2d14804@mail.gmail.com>
Subject: [patch] sched: add locking when update the task_group's cfs_rq[] 
	array.
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add locking when update the task_group's cfs_rq[] array.  tg_shares_up()
can be potentially executed concurrently on multiple CPUs with overlaping
cpu mask depending on where task_cpu() was when a task got woken up.  Lack
of any locking while redistribute tg->shares over cfs_rq[] array opens up
a large window for conflict updates and utimately cause corruptions to the
integrity of per cpu cfs_rq shares. Add a tg_lock to protect the operations.


Signed-off-by: Ken Chen <kenchen@google.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index 1ff78b6..907a44e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -267,6 +267,8 @@ struct task_group {
 	/* runqueue "owned" by this group on each cpu */
 	struct cfs_rq **cfs_rq;
 	unsigned long shares;
+	/* protect integrity of per-cpu cfs_rq[i]->shares */
+	spinlock_t tg_lock;
 #endif

 #ifdef CONFIG_RT_GROUP_SCHED
@@ -1493,13 +1495,11 @@ update_group_shares_cpu
 	if (abs(shares - tg->se[cpu]->load.weight) >
 			sysctl_sched_shares_thresh) {
 		struct rq *rq = cpu_rq(cpu);
-		unsigned long flags;

-		spin_lock_irqsave(&rq->lock, flags);
+		spin_lock(&rq->lock);
 		tg->cfs_rq[cpu]->shares = shares;
-
 		__set_se_shares(tg->se[cpu], shares);
-		spin_unlock_irqrestore(&rq->lock, flags);
+		spin_unlock(&rq->lock);
 	}
 }

@@ -1513,8 +1513,12 @@ static int tg_shares_up
 	unsigned long weight, rq_weight = 0;
 	unsigned long shares = 0;
 	struct sched_domain *sd = data;
+	unsigned long flags;
 	int i;

+	if (!spin_trylock_irqsave(&tg->tg_lock, flags))
+		return 0;
+
 	for_each_cpu_mask(i, sd->span) {
 		/*
 		 * If there are currently no tasks on the cpu pretend there
@@ -1539,6 +1543,7 @@ static int tg_shares_up
 	for_each_cpu_mask(i, sd->span)
 		update_group_shares_cpu(tg, i, shares, rq_weight);

+	spin_unlock_irqrestore(&tg->tg_lock, flags);
 	return 0;
 }

@@ -8195,6 +8200,10 @@ void __init sched_init(void)
 	list_add(&init_task_group.list, &task_groups);
 	INIT_LIST_HEAD(&init_task_group.children);

+#ifdef CONFIG_FAIR_GROUP_SCHED
+	spin_lock_init(&init_task_group.tg_lock);
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+
 #ifdef CONFIG_USER_SCHED
 	INIT_LIST_HEAD(&root_task_group.children);
 	init_task_group.parent = &root_task_group;
@@ -8491,6 +8500,10 @@ int alloc_fair_sched_group

 	tg->shares = NICE_0_LOAD;

+#ifdef CONFIG_FAIR_GROUP_SCHED
+	spin_lock_init(&tg->tg_lock);
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
