Return-Path: <linux-kernel-owner+w=401wt.eu-S1759963AbZKZKNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963AbZKZKNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 05:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755188AbZKZKNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 05:13:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:37689 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445AbZKZKNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 05:13:43 -0500
Message-ID: <4B0E54C3.7000301@kernel.org>
Date: Thu, 26 Nov 2009 19:13:23 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/4 tip/sched/core] sched: update sched_notifier and add wakeup/sleep
 notifications
References: <20091126190018.88a6dd77.sfr@canb.auug.org.au> <20091126081237.GA31034@elte.hu> <4B0E4741.10509@kernel.org> <20091126092631.GA17253@elte.hu> <4B0E4EFB.2070705@kernel.org> <20091126095154.GE32275@elte.hu>
In-Reply-To: <20091126095154.GE32275@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
Cc: Mike Galbraith <efault@gmx.de>
---
 include/linux/sched.h |   20 +++++++++++++-------
 kernel/sched.c        |   41 ++++++++++++++++++-----------------------
 virt/kvm/kvm_main.c   |    4 ++--
 3 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 68fffe8..e03a754 100644
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
index b5278c2..475da1a 100644
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
@@ -2454,6 +2464,8 @@ out_running:
 		rq->idle_stamp = 0;
 	}
 #endif
+	if (success)
+		fire_sched_notifier(p, wakeup);
 out:
 	task_rq_unlock(rq, &flags);
 	put_cpu();
@@ -2670,25 +2682,6 @@ void sched_notifier_unregister(struct sched_notifier *notifier)
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
@@ -2706,7 +2699,7 @@ static inline void
 prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
-	fire_sched_out_notifiers(prev, next);
+	fire_sched_notifier(current, out, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
 }
@@ -2748,7 +2741,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	prev_state = prev->state;
 	finish_arch_switch(prev);
 	perf_event_task_sched_in(current, cpu_of(rq));
-	fire_sched_in_notifiers(current);
+	fire_sched_notifier(current, in, prev);
 	finish_lock_switch(rq, prev);
 
 	if (mm)
@@ -5441,10 +5434,12 @@ need_resched_nonpreemptible:
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
1.6.5.3

