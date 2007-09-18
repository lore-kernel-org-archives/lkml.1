Return-Path: <linux-kernel-owner+w=401wt.eu-S1759161AbXIRTqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbXIRTqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757195AbXIRTqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:46:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:33964 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbXIRTqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:46:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TxNmBl4JyMeEML80DGkQuyjftR6CM72ivrbzqDGmmAcKMwdlQphy/VoDlihzZFoNWLf9vIxZfQVXWioYBar71QtB+wSqQi8jzESMyOeFk1uLPww6p6rX0c5HvDYPPtvD+n1JteGRiKXtruBIUk0yTa3L0PK3orZ2IFpub5yCRXI=
Subject: [git] CFS-devel, group scheduler, fixes
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 18 Sep 2007 21:46:38 +0200
Message-Id: <1190144798.5204.32.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(2)

the 'p' (task_struct) parameter in the sched_class :: yield_task()
is redundant as the caller is always the 'current'. Get rid of it.

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

---
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9fd936f..3728cd6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -857,7 +857,7 @@ struct sched_class {
 
 	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
-	void (*yield_task) (struct rq *rq, struct task_struct *p);
+	void (*yield_task) (struct rq *rq);
 
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 046dae1..361fad8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4535,7 +4535,7 @@ asmlinkage long sys_sched_yield(void)
 	if (unlikely(rq->nr_running == 1))
 		schedstat_inc(rq, yld_act_empty);
 	else
-		current->sched_class->yield_task(rq, current);
+		current->sched_class->yield_task(rq);
 
 	/*
 	 * Since we are going to call schedule() anyway, there's
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5a244e2..9b982ef 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -723,10 +723,12 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int sleep)
 /*
  * sched_yield() support is very simple - we dequeue and enqueue
  */
-static void yield_task_fair(struct rq *rq, struct task_struct *p)
+static void yield_task_fair(struct rq *rq)
 {
+	struct task_struct *curr = rq->curr;
+	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
+
 	if (!sysctl_sched_yield_bug_workaround) {
-		struct cfs_rq *cfs_rq = task_cfs_rq(p);
 		__update_rq_clock(rq);
 
 		/*
@@ -737,7 +739,6 @@ static void yield_task_fair(struct rq *rq, struct task_struct *p)
 	}
 
 	if (sysctl_sched_yield_bug_workaround == 1) {
-		struct cfs_rq *cfs_rq = task_cfs_rq(p);
 		struct sched_entity *next;
 
 		/*
@@ -757,7 +758,7 @@ static void yield_task_fair(struct rq *rq, struct task_struct *p)
 		/*
 		 * Minimally necessary key value to be the second in the tree:
 		 */
-		p->se.vruntime = next->vruntime +
+		curr->se.vruntime = next->vruntime +
 					sysctl_sched_yield_granularity;
 
 		/*
@@ -770,7 +771,7 @@ static void yield_task_fair(struct rq *rq, struct task_struct *p)
 	/*
 	 * Just reschedule, do nothing else:
 	 */
-	resched_task(p);
+	resched_task(curr);
 }
 
 /*
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 45b339f..b86944c 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -59,9 +59,9 @@ static void requeue_task_rt(struct rq *rq, struct task_struct *p)
 }
 
 static void
-yield_task_rt(struct rq *rq, struct task_struct *p)
+yield_task_rt(struct rq *rq)
 {
-	requeue_task_rt(rq, p);
+	requeue_task_rt(rq, rq->curr);
 }
 
 /*

---

Dmitry




