Return-Path: <linux-kernel-owner+w=401wt.eu-S1751410AbZCIM4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbZCIM4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 08:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZCIM41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 08:56:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:36099 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZCIM4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 08:56:25 -0400
Subject: [PATCH] sched: optimize ttwu vs group scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 13:56:21 +0100
Message-Id: <1236603381.8389.455.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can avoid the sched domain walk on try_to_wake_up() when we know
there are no groups.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 4414926..188ce3d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -331,6 +331,13 @@ static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
  */
 static DEFINE_SPINLOCK(task_group_lock);
 
+#ifdef CONFIG_SMP
+static int root_task_group_empty(void)
+{
+	return list_empty(&root_task_group->children);
+}
+#endif
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_USER_SCHED
 # define INIT_TASK_GROUP_LOAD	(2*NICE_0_LOAD)
@@ -391,6 +398,13 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 
 #else
 
+#ifdef CONFIG_SMP
+static int root_task_group_empty(void)
+{
+	return 1;
+}
+#endif
+
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
 static inline struct task_group *task_group(struct task_struct *p)
 {
@@ -2363,7 +2377,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 		sync = 0;
 
 #ifdef CONFIG_SMP
-	if (sched_feat(LB_WAKEUP_UPDATE)) {
+	if (sched_feat(LB_WAKEUP_UPDATE) && !root_task_group_empty()) {
 		struct sched_domain *sd;
 
 		this_cpu = raw_smp_processor_id();


