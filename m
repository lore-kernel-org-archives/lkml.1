Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbZKTErs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbZKTErs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 23:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768AbZKTErp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 23:47:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:45012 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbZKTErn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 23:47:43 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, peterz@infradead.org, johannes@sipsolutions.net
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/19] sched: update sched_notifier and add wakeup/sleep notifications
Date: Fri, 20 Nov 2009 13:46:32 +0900
Message-Id: <1258692407-8985-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258692407-8985-1-git-send-email-tj@kernel.org>
References: <1258692407-8985-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update sched_notifier such that

* in and out ops are symmetric in the parameter they take.

* Use single fire_sched_notifier() macro instead of separate function
  for each op.

* Allow NULL ops.

* Add wakeup and sleep notifications.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/sched.h |   20 +++++++++++++-------
 kernel/sched.c        |   40 +++++++++++++++++-----------------------
 virt/kvm/kvm_main.c   |    4 ++--
 3 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 37c97a1..657372f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1214,15 +1214,21 @@ struct sched_notifier;
 
 /**
  * sched_notifier_ops - notifiers called for scheduling events
- * @in: we're about to be rescheduled:
- *    notifier: struct sched_notifier for the task being scheduled
- *    cpu:  cpu we're scheduled on
- * @out: we've just been preempted
- *    notifier: struct sched_notifier for the task being preempted
- *    next: the task that's kicking us out
+ * @wakeup: we're waking up
+ *    notifier: struct sched_notifier for the task being woken up
+ * @sleep: we're going to bed
+ *    notifier: struct sched_notifier for the task sleeping
+ * @in: we're now running on the cpu
+ *    notifier: struct sched_notifier for the task being scheduled in
+ *    prev: the task which ran before us
+ * @out: we're leaving the cpu
+ *    notifier: struct sched_notifier for the task being scheduled out
+ *    next: the task which will run after us
  */
 struct sched_notifier_ops {
-	void (*in)(struct sched_notifier *notifier, int cpu);
+	void (*wakeup)(struct sched_notifier *notifier);
+	void (*sleep)(struct sched_notifier *notifier);
+	void (*in)(struct sched_notifier *notifier, struct task_struct *prev);
 	void (*out)(struct sched_notifier *notifier, struct task_struct *next);
 };
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 7ef5757..88c0fda 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1389,6 +1389,16 @@ static const u32 prio_to_wmult[40] = {
  /*  15 */ 119304647, 148102320, 186737708, 238609294, 286331153,
 };
 
+#define fire_sched_notifier(p, callback, args...) do {			\
+	struct task_struct *__p = (p);					\
+	struct sched_notifier *__sn;					\
+	struct hlist_node *__pos;					\
+									\
+	hlist_for_each_entry(__sn, __pos, &__p->sched_notifiers, link)	\
+		if (__sn->ops->callback)				\
+			__sn->ops->callback(__sn , ##args);		\
+} while (0)
+
 static void activate_task(struct rq *rq, struct task_struct *p, int wakeup);
 
 /*
@@ -2414,6 +2424,7 @@ out_activate:
 	else
 		schedstat_inc(p, se.nr_wakeups_remote);
 	activate_task(rq, p, 1);
+	fire_sched_notifier(p, wakeup);
 	success = 1;
 
 	/*
@@ -2653,25 +2664,6 @@ void sched_notifier_unregister(struct sched_notifier *notifier)
 }
 EXPORT_SYMBOL_GPL(sched_notifier_unregister);
 
-static void fire_sched_in_notifiers(struct task_struct *curr)
-{
-	struct sched_notifier *notifier;
-	struct hlist_node *node;
-
-	hlist_for_each_entry(notifier, node, &curr->sched_notifiers, link)
-		notifier->ops->in(notifier, raw_smp_processor_id());
-}
-
-static void fire_sched_out_notifiers(struct task_struct *curr,
-				     struct task_struct *next)
-{
-	struct sched_notifier *notifier;
-	struct hlist_node *node;
-
-	hlist_for_each_entry(notifier, node, &curr->sched_notifiers, link)
-		notifier->ops->out(notifier, next);
-}
-
 /**
  * prepare_task_switch - prepare to switch tasks
  * @rq: the runqueue preparing to switch
@@ -2689,7 +2681,7 @@ static inline void
 prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
-	fire_sched_out_notifiers(prev, next);
+	fire_sched_notifier(current, out, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
 }
@@ -2731,7 +2723,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	prev_state = prev->state;
 	finish_arch_switch(prev);
 	perf_event_task_sched_in(current, cpu_of(rq));
-	fire_sched_in_notifiers(current);
+	fire_sched_notifier(current, in, prev);
 	finish_lock_switch(rq, prev);
 
 	if (mm)
@@ -5417,10 +5409,12 @@ need_resched_nonpreemptible:
 	clear_tsk_need_resched(prev);
 
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
-		if (unlikely(signal_pending_state(prev->state, prev)))
+		if (unlikely(signal_pending_state(prev->state, prev))) {
 			prev->state = TASK_RUNNING;
-		else
+		} else {
+			fire_sched_notifier(prev, sleep);
 			deactivate_task(rq, prev, 1);
+		}
 		switch_count = &prev->nvcsw;
 	}
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4e8e33f..006358d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2695,11 +2695,11 @@ static inline struct kvm_vcpu *sched_notifier_to_vcpu(struct sched_notifier *sn)
 	return container_of(sn, struct kvm_vcpu, sched_notifier);
 }
 
-static void kvm_sched_in(struct sched_notifier *sn, int cpu)
+static void kvm_sched_in(struct sched_notifier *sn, struct task_struct *prev)
 {
 	struct kvm_vcpu *vcpu = sched_notifier_to_vcpu(sn);
 
-	kvm_arch_vcpu_load(vcpu, cpu);
+	kvm_arch_vcpu_load(vcpu, smp_processor_id());
 }
 
 static void kvm_sched_out(struct sched_notifier *sn, struct task_struct *next)
-- 
1.6.4.2

