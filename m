Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab0BHHBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 02:01:42 -0500
Received: from tango.tkos.co.il ([62.219.50.35]:49089 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab0BHHBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 02:01:41 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: linux-kernel@vger.kernel.org
Cc: Baruch Siach <baruch@tkos.co.il>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH v2] sched: fix unused variable warning when !CONFIG_SMP
Date: Mon,  8 Feb 2010 09:01:10 +0200
Message-Id: <9001dbb8699166c6b3aab195be85ff772845bfe9.1265612317.git.baruch@tkos.co.il>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <de61b5c64f7809ea210c6b4bb3dc3061efe4429c.1265609796.git.baruch@tkos.co.il>
References: <de61b5c64f7809ea210c6b4bb3dc3061efe4429c.1265609796.git.baruch@tkos.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This variable was introduced by fabf318e. Now actually tested.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3a8fb30..faf7021 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2647,9 +2647,10 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 {
 	unsigned long flags;
 	struct rq *rq;
-	int cpu = get_cpu();
 
 #ifdef CONFIG_SMP
+	get_cpu();
+
 	/*
 	 * Fork balancing, do it here and not earlier because:
 	 *  - cpus_allowed can change in the fork path
@@ -2659,8 +2660,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	 * ->cpus_allowed is stable, we have preemption disabled, meaning
 	 * cpu_online_mask is stable.
 	 */
-	cpu = select_task_rq(p, SD_BALANCE_FORK, 0);
-	set_task_cpu(p, cpu);
+	set_task_cpu(p, select_task_rq(p, SD_BALANCE_FORK, 0));
 #endif
 
 	rq = task_rq_lock(p, &flags);
@@ -2675,7 +2675,9 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 		p->sched_class->task_woken(rq, p);
 #endif
 	task_rq_unlock(rq, &flags);
+#ifdef CONFIG_SMP
 	put_cpu();
+#endif
 }
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
-- 
1.6.5

