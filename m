Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbYGXWMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbYGXWMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 18:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYGXWME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 18:12:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:32360 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYGXWMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 18:12:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=DYUA2bmW/LFBz3MH61BDq5D/ARXZf+KQXF2Wwq3FL1I+hZEgXg8GUAwuGIDvLzeQms
         Es6B1l0p5Se1+SUUKDZTwwD3GRLYzJyhAmTmBolZKt4jv2oHU2C2Sxgaep0WODSLXF+t
         uwEtiWE2B/aIyNXIcc/Ruo6JnHu3Hcw2JnpV0=
Subject: [patch, rfc: 1/2] sched, hotplug: safe use of rq->migration_thread
	and find_busiest_queue()
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 00:11:57 +0200
Message-Id: <1216937517.5368.11.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: sched, hotplug: safe use of rq->migration_thread
and find_busiest_queue()

---

    sched, hotplug: safe use of rq->migration_thread and find_busiest_queue()
    
    (1) make usre rq->migration_thread is valid when we access it in set_cpus_allowed_ptr()
    after releasing the rq-lock;
    
    (2) in load_balance() and load_balance_idle()
    
    ensure that we don't get 'busiest' which can disappear as a result of cpu_down()
    while we are manipulating it. For this goal, we choose 'busiest' only amongst
    'cpu_active_map' cpus.
    
    load_balance() and load_balance_idle() get called with preemption being disabled
    so synchronize_sched() in cpu_down() should get us synced.
    
    IOW, as soon as synchronize_sched() has been done in cpu_down(cpu), the run-queue for
    can't be manipulated/accessed by the load-balancer.
    
    Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index 6acf749..b4ccc8b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3409,7 +3409,14 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	struct rq *busiest;
 	unsigned long flags;
 
-	cpus_setall(*cpus);
+	/*
+	 * Ensure that we don't get 'busiest' which can disappear
+	 * as a result of cpu_down() while we are manipulating it.
+	 *
+	 * load_balance() gets called with preemption being disabled
+	 * so synchronize_sched() in cpu_down() should get us synced.
+	 */
+	*cpus = cpu_active_map;
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -3571,7 +3578,14 @@ load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd,
 	int sd_idle = 0;
 	int all_pinned = 0;
 
-	cpus_setall(*cpus);
+	/*
+	 * Ensure that we don't get 'busiest' which can disappear
+	 * as a result of cpu_down() while we are manipulating it.
+	 *
+	 * load_balance_newidle() gets called with preemption being disabled
+	 * so synchronize_sched() in cpu_down() should get us synced.
+	 */
+	*cpus = cpu_active_map;
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -5764,9 +5778,14 @@ int set_cpus_allowed_ptr(struct task_struct *p, const cpumask_t *new_mask)
 		goto out;
 
 	if (migrate_task(p, any_online_cpu(*new_mask), &req)) {
-		/* Need help from migration thread: drop lock and wait. */
+		/* Need to wait for migration thread (might exit: take ref). */
+		struct task_struct *mt = rq->migration_thread;
+
+		get_task_struct(mt);
 		task_rq_unlock(rq, &flags);
-		wake_up_process(rq->migration_thread);
+		wake_up_process(mt);
+		put_task_struct(mt);
+
 		wait_for_completion(&req.done);
 		tlb_migrate_finish(p->mm);
 		return 0;


