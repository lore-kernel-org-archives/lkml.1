Return-Path: <linux-kernel-owner+w=401wt.eu-S1765095AbXIMXZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765095AbXIMXZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbXIMXZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:25:48 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:15133 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbXIMXZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:25:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JGqM04/sufDKMR4s//qMVMD7WXWmXBLNWB2VlYKML6QTFrhAUIiib3Dx/bHUqZ3Io4jzkK66WoA6DM2+goCcrXUEEuN+xXeSE8LT0wKxITIGnobFzRPE8xcZLfjTChmAFwGXP2TtOMMvS2X+gdJq7iHECLRAa9QD3tNFaeSVLmM=
Subject: Re: [announce] CFS-devel, performance improvements
From: dimm <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roman Zippel <zippel@linux-m68k.org>, Mike Galbraith <efault@gmx.de>,
       dmitry.adamushko@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 14 Sep 2007 01:25:40 +0200
Message-Id: <1189725940.4485.53.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


and here's something a bit more intrusive.

The initial idea was to completely get rid of 'se->fair_key'. It's always equal to 'se->vruntime' for
all runnable tasks but the 'current'. The exact key within the tree for the 'current' has to be known in
order for __enqueue_entity() to work properly (if we just use 'vruntime', we may go a wrong way down the tree
while looking for the correct position for a new element).
Sure, it's possible to cache the current's key in the 'cfs_rq' and add a few additional checks, but that's
not very nice... so what if we don't keep the 'current' within the tree? :-)

The illustration is below. Some bits can be missed so far but a patched kernel boots/works
(haven't done real regression tests yet... can say that the mail client is still working
at this very moment :-).

There are 2 benefits:

(1) no more 'fair_key' ;
(2) entity_tick() is simpler/more effective : 'update_curr()' now vs.
'dequeue_entity() + enqueue_entity()' before.

anyway, consider it as mainly an illustration of idea so far.

---
diff -upr linux-2.6.23-rc6/include/linux/sched.h linux-2.6.23-rc6-my/include/linux/sched.h
--- linux-2.6.23-rc6/include/linux/sched.h	2007-09-13 21:38:49.000000000 +0200
+++ linux-2.6.23-rc6-my/include/linux/sched.h	2007-09-13 23:01:21.000000000 +0200
@@ -890,7 +890,6 @@ struct load_weight {
  *     6 se->load.weight
  */
 struct sched_entity {
-	s64			fair_key;
 	struct load_weight	load;		/* for load-balancing */
 	struct rb_node		run_node;
 	unsigned int		on_rq;
diff -upr linux-2.6.23-rc6/kernel/sched.c linux-2.6.23-rc6-my/kernel/sched.c
--- linux-2.6.23-rc6/kernel/sched.c	2007-09-13 21:52:13.000000000 +0200
+++ linux-2.6.23-rc6-my/kernel/sched.c	2007-09-13 23:00:19.000000000 +0200
@@ -6534,7 +6534,6 @@ void normalize_rt_tasks(void)
 
 	read_lock_irq(&tasklist_lock);
 	do_each_thread(g, p) {
-		p->se.fair_key			= 0;
 		p->se.exec_start		= 0;
 #ifdef CONFIG_SCHEDSTATS
 		p->se.wait_start		= 0;
diff -upr linux-2.6.23-rc6/kernel/sched_debug.c linux-2.6.23-rc6-my/kernel/sched_debug.c
--- linux-2.6.23-rc6/kernel/sched_debug.c	2007-09-13 21:52:13.000000000 +0200
+++ linux-2.6.23-rc6-my/kernel/sched_debug.c	2007-09-13 23:00:50.000000000 +0200
@@ -38,7 +38,7 @@ print_task(struct seq_file *m, struct rq
 
 	SEQ_printf(m, "%15s %5d %15Ld %13Ld %5d ",
 		p->comm, p->pid,
-		(long long)p->se.fair_key,
+		(long long)p->se.vruntime,
 		(long long)(p->nvcsw + p->nivcsw),
 		p->prio);
 #ifdef CONFIG_SCHEDSTATS
diff -upr linux-2.6.23-rc6/kernel/sched_fair.c linux-2.6.23-rc6-my/kernel/sched_fair.c
--- linux-2.6.23-rc6/kernel/sched_fair.c	2007-09-13 21:52:13.000000000 +0200
+++ linux-2.6.23-rc6-my/kernel/sched_fair.c	2007-09-13 23:48:02.000000000 +0200
@@ -125,7 +125,7 @@ set_leftmost(struct cfs_rq *cfs_rq, stru
 
 s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	return se->fair_key - cfs_rq->min_vruntime;
+	return se->vruntime - cfs_rq->min_vruntime;
 }
 
 /*
@@ -167,9 +167,6 @@ __enqueue_entity(struct cfs_rq *cfs_rq, 
 
 	rb_link_node(&se->run_node, parent, link);
 	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
-	update_load_add(&cfs_rq->load, se->load.weight);
-	cfs_rq->nr_running++;
-	se->on_rq = 1;
 }
 
 static void
@@ -179,9 +176,6 @@ __dequeue_entity(struct cfs_rq *cfs_rq, 
 		set_leftmost(cfs_rq, rb_next(&se->run_node));
 
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
-	update_load_sub(&cfs_rq->load, se->load.weight);
-	cfs_rq->nr_running--;
-	se->on_rq = 0;
 }
 
 static inline struct rb_node *first_fair(struct cfs_rq *cfs_rq)
@@ -320,10 +314,6 @@ static void update_stats_enqueue(struct 
 	 */
 	if (se != cfs_rq->curr)
 		update_stats_wait_start(cfs_rq, se);
-	/*
-	 * Update the key:
-	 */
-	se->fair_key = se->vruntime;
 }
 
 static void
@@ -371,6 +361,22 @@ update_stats_curr_end(struct cfs_rq *cfs
  * Scheduling class queueing methods:
  */
 
+static void
+account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	update_load_add(&cfs_rq->load, se->load.weight);
+	cfs_rq->nr_running++;
+	se->on_rq = 1;
+}
+
+static void
+account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	update_load_sub(&cfs_rq->load, se->load.weight);
+	cfs_rq->nr_running--;
+	se->on_rq = 0;
+}
+
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 #ifdef CONFIG_SCHEDSTATS
@@ -446,7 +452,9 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 	}
 
 	update_stats_enqueue(cfs_rq, se);
-	__enqueue_entity(cfs_rq, se);
+	if (se != cfs_rq->curr)
+		__enqueue_entity(cfs_rq, se);
+	account_entity_enqueue(cfs_rq, se);
 }
 
 static void
@@ -465,7 +473,9 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 		}
 	}
 #endif
-	__dequeue_entity(cfs_rq, se);
+	if (se != cfs_rq->curr)
+		__dequeue_entity(cfs_rq, se);
+	account_entity_dequeue(cfs_rq, se);
 }
 
 /*
@@ -511,6 +521,9 @@ static struct sched_entity *pick_next_en
 {
 	struct sched_entity *se = __pick_next_entity(cfs_rq);
 
+	if (se)
+		__dequeue_entity(cfs_rq, se);
+
 	set_next_entity(cfs_rq, se);
 
 	return se;
@@ -522,8 +535,11 @@ static void put_prev_entity(struct cfs_r
 	 * If still on the runqueue then deactivate_task()
 	 * was not called and update_curr() has to be done:
 	 */
-	if (prev->on_rq)
+	if (prev->on_rq) {
 		update_curr(cfs_rq);
+		/* Put the current back into the tree. */
+		__enqueue_entity(cfs_rq, prev);
+	}	
 
 	update_stats_curr_end(cfs_rq, prev);
 
@@ -535,11 +551,9 @@ static void put_prev_entity(struct cfs_r
 static void entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 {
 	/*
-	 * Dequeue and enqueue the task to update its
-	 * position within the tree:
+	 * Update run-time statistics of the 'current'.
 	 */
-	dequeue_entity(cfs_rq, curr, 0);
-	enqueue_entity(cfs_rq, curr, 0);
+	update_curr(cfs_rq);	
 
 	if (cfs_rq->nr_running > 1)
 		check_preempt_tick(cfs_rq, curr);
@@ -890,6 +904,7 @@ static void task_new_fair(struct rq *rq,
 
 	update_stats_enqueue(cfs_rq, se);
 	__enqueue_entity(cfs_rq, se);
+	account_entity_enqueue(cfs_rq, se);
 	resched_task(rq->curr);
 }
 

---


