Return-Path: <linux-kernel-owner+w=401wt.eu-S1751861AbXDHGTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbXDHGTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 02:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbXDHGTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 02:19:45 -0400
Received: from [58.147.177.5] ([58.147.177.5]:43374 "EHLO localhost.onetbd.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751861AbXDHGTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 02:19:44 -0400
X-Greylist: delayed 2335 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Apr 2007 02:19:43 EDT
Subject: [PATCH] Scheduler: Improving the scheduler performance.
From: root <swordfish@onetbd.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Message-Id: <1175967725.5798.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.4.6-1mdk 
Date: Sat, 07 Apr 2007 23:42:20 +0600
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] Scheduler: Improving the scheduler performance.

As we know that, linux scheduler use separate runqueue for every CPU of
a multiprocessor system, which having an active and an expired array.If
we use only one expired array, then the CPUs of a multiprocessor system
will be able to share their expired task via the accumulated expired
array,which will be declared outside of the runqueue array.Here,the
accumulated expired array has been called global expired array(declared
as "glo_expired").So, any CPU without active task, will check the global
expired array.Now,with separate expired array the chance of an empty
expired array is high,than the accumulated expired array(global expired
array).As a result CPU will be less idle.When a task will finish its
timeslice,then it will kept in the global expired array(if the task
isn't 'interactive').And the pressure will be less over the schedule
domain.So, I think it will help to improve the performance of the linux
scheduler.Here,struct prio_array *expired has been removed from the
runqueue structure and has been declared outside of the runqueue array
for making it global,thus every CPU can access it with ease.Then in the
__activate_task function, after a check for batch task expired array of
the runqueue were put into the target.Now we've to put the glo_expired
array into the target.Then in the move_tasks function, the balancing
operation within the domain will be over the active array,because there
is no expired array in the runqueue.Then in the skip_bitmap section,
check will be made against only busiest->active->nr_active,because in
runqueue there is no expired array.In scheduler_tick function,in place
of rq->expired array will replaced by glo_expired array.In the main
function schedule,before call idle_balance function a check is made
against rq->nr_running and glo_expired->nr_running.Because, if both
active and glo_expired array are empty then a CPU becomes idle.Then
switching will be between active and glo_expired array.In the
sys_sched_yield function,rq->expired will be replaced by the glo_expired
array.So,scheduler will use only one expired array instead of separate
expired array of a multiprocessor system.And the necessary changes are
very simple,so it won't cause much problem.But will help in improving
performance. This patch has been applied on kernel 
version-2.6.18 .[NOTE: In prio_array structure,the number of active
processes,might needs to be increased,if the number of CPU is too
much,then unsigned long would be helpful instead of int.]

		Developer's Certificate of Origin 1.1

        By making a contribution to this project, I certify that:

        (a) The contribution was created in whole or in part by me and I
            have the right to submit it under the open source license
            indicated in the file; or

        (b) The contribution is based upon previous work that, to the
best
            of my knowledge, is covered under an appropriate open source
            license and I have the right under that license to submit
that
            work with modifications, whether created in whole or in part
            by me, under the same open source license (unless I am
            permitted to submit under a different license), as indicated
            in the file; or

        (c) The contribution was provided directly to me by some other
            person who certified (a), (b) or (c) and I have not modified
            it.

	(d) I understand and agree that this project and the contribution
	    are public and that a record of the contribution (including all
	    personal information I submit with it, including my sign-off) is
	    maintained indefinitely and may be redistributed consistent with
	    this project or the open source license(s) involved.

	Signed-off-by:Md.Rakib Hassan Mullick <Rakib.Mullick@gmail.com>
					      <swordfish@onetbd.com>


--- /root/devel/linux-2.6.18/kernel/sched.c	2006-09-20
09:42:06.000000000 +0600
+++ /usr/src/linux-2.6.18/kernel/sched.c	2007-04-05 22:20:24.000000000
+0600
@@ -228,7 +228,7 @@ struct rq {
 	unsigned long long timestamp_last_tick;
 	struct task_struct *curr, *idle;
 	struct mm_struct *prev_mm;
-	struct prio_array *active, *expired, arrays[2];
+	struct prio_array *active,  arrays[2];
 	int best_expired_prio;
 	atomic_t nr_iowait;
 
@@ -265,6 +265,8 @@ struct rq {
 	struct lock_class_key rq_lock_key;
 };
 
+struct prio_array *glo_expired;		
+
 static DEFINE_PER_CPU(struct rq, runqueues);
 
 /*
@@ -834,7 +836,7 @@ static void __activate_task(struct task_
 	struct prio_array *target = rq->active;
 
 	if (batch_task(p))
-		target = rq->expired;
+		target = glo_expired;   	
 	enqueue_task(p, target);
 	inc_nr_running(p, rq);
 }
@@ -2120,13 +2122,10 @@ static int move_tasks(struct rq *this_rq
 	 * be cache-cold, thus switching CPUs has the least effect
 	 * on them.
 	 */
-	if (busiest->expired->nr_active) {
-		array = busiest->expired;
-		dst_array = this_rq->expired;
-	} else {
-		array = busiest->active;
-		dst_array = this_rq->active;
-	}
+	
+	array = busiest->active;
+	dst_array = this_rq->active;
+	
 
 new_array:
 	/* Start searching at priority 0: */
@@ -2137,7 +2136,7 @@ skip_bitmap:
 	else
 		idx = find_next_bit(array->bitmap, MAX_PRIO, idx);
 	if (idx >= MAX_PRIO) {
-		if (array == busiest->expired && busiest->active->nr_active) {
+		if (busiest->active->nr_active) {
 			array = busiest->active;
 			dst_array = this_rq->active;
 			goto new_array;
@@ -3041,7 +3040,7 @@ void scheduler_tick(void)
 		if (!rq->expired_timestamp)
 			rq->expired_timestamp = jiffies;
 		if (!TASK_INTERACTIVE(p) || expired_starving(rq)) {
-			enqueue_task(p, rq->expired);
+			enqueue_task(p, glo_expired);	
 			if (p->static_prio < rq->best_expired_prio)
 				rq->best_expired_prio = p->static_prio;
 		} else
@@ -3328,7 +3327,8 @@ need_resched_nonpreemptible:
 	}
 
 	cpu = smp_processor_id();
-	if (unlikely(!rq->nr_running)) {
+	if (unlikely(!rq->nr_running) && (!glo_expired->nr_active)) {
+		
 		idle_balance(cpu, rq);
 		if (!rq->nr_running) {
 			next = rq->idle;
@@ -3344,8 +3344,8 @@ need_resched_nonpreemptible:
 		 * Switch the active and expired arrays.
 		 */
 		schedstat_inc(rq, sched_switch);
-		rq->active = rq->expired;
-		rq->expired = array;
+		rq->active = glo_expired; 
+		glo_expired = array;		
 		array = rq->active;
 		rq->expired_timestamp = 0;
 		rq->best_expired_prio = MAX_PRIO;
@@ -4411,7 +4411,7 @@ asmlinkage long sys_sched_getaffinity(pi
 asmlinkage long sys_sched_yield(void)
 {
 	struct rq *rq = this_rq_lock();
-	struct prio_array *array = current->array, *target = rq->expired;
+	struct prio_array *array = current->array, *target = glo_expired; 
 
 	schedstat_inc(rq, yld_cnt);
 	/*
@@ -4426,9 +4426,9 @@ asmlinkage long sys_sched_yield(void)
 
 	if (array->nr_active == 1) {
 		schedstat_inc(rq, yld_act_empty);
-		if (!rq->expired->nr_active)
+		if (!glo_expired->nr_active)		
 			schedstat_inc(rq, yld_both_empty);
-	} else if (!rq->expired->nr_active)
+	} else if (!glo_expired->nr_active)		
 		schedstat_inc(rq, yld_exp_empty);
 
 	if (array != target) {
@@ -6738,7 +6738,7 @@ void __init sched_init(void)
 		lockdep_set_class(&rq->lock, &rq->rq_lock_key);
 		rq->nr_running = 0;
 		rq->active = rq->arrays;
-		rq->expired = rq->arrays + 1;
+		glo_expired = rq->arrays + 1;    
 		rq->best_expired_prio = MAX_PRIO;
 
 #ifdef CONFIG_SMP


