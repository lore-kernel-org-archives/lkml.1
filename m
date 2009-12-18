Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbZLRM7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbZLRM7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 07:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZLRM6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 07:58:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:45280 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbZLRM5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 07:57:41 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, peterz@infradead.org, johannes@sipsolutions.net,
       andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Tony Luck <tony.luck@intel.com>, Andi Kleen <ak@linux.intel.com>,
       Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 27/27] workqueue: increase max_active of keventd and kill current_is_keventd()
Date: Fri, 18 Dec 2009 21:58:08 +0900
Message-Id: <1261141088-2014-28-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1261141088-2014-1-git-send-email-tj@kernel.org>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define WQ_MAX_ACTIVE and create keventd with max_active set to half of
it which means that keventd now can process upto WQ_MAX_ACTIVE / 2 - 1
works concurrently.  Unless some combination can result in dependency
loop longer than max_active, deadlock won't happen and thus it's
unnecessary to check whether current_is_keventd() before trying to
schedule a work.  Kill current_is_keventd().

(Lockdep annotations are broken.  We need lock_map_acquire_read_norecurse())

NOT_SIGNED_OFF_YET: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 arch/ia64/kernel/smpboot.c |    2 +-
 arch/x86/kernel/smpboot.c  |    2 +-
 include/linux/workqueue.h  |    3 +-
 kernel/workqueue.c         |   54 +++----------------------------------------
 4 files changed, 8 insertions(+), 53 deletions(-)

diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index de100aa..3a46feb 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -516,7 +516,7 @@ do_boot_cpu (int sapicid, int cpu)
 	/*
 	 * We can't use kernel_thread since we must avoid to reschedule the child.
 	 */
-	if (!keventd_up() || current_is_keventd())
+	if (!keventd_up())
 		c_idle.work.func(&c_idle.work);
 	else {
 		schedule_work(&c_idle.work);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 678d0b8..93175af 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -724,7 +724,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 		goto do_rest;
 	}
 
-	if (!keventd_up() || current_is_keventd())
+	if (!keventd_up())
 		c_idle.work.func(&c_idle.work);
 	else {
 		schedule_work(&c_idle.work);
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index adb3080..f43a260 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -214,6 +214,8 @@ enum {
 	WQ_FREEZEABLE		= 1 << 0, /* freeze during suspend */
 	WQ_SINGLE_CPU		= 1 << 1, /* only single cpu at a time */
 	WQ_RESCUER		= 1 << 2, /* has an rescue worker */
+
+	WQ_MAX_ACTIVE		= 256,    /* I like 256, better ideas? */
 };
 
 extern struct workqueue_struct *
@@ -267,7 +269,6 @@ extern int schedule_delayed_work(struct delayed_work *work, unsigned long delay)
 extern int schedule_delayed_work_on(int cpu, struct delayed_work *work,
 					unsigned long delay);
 extern int schedule_on_each_cpu(work_func_t func);
-extern int current_is_keventd(void);
 extern int keventd_up(void);
 
 extern void init_workqueues(void);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9baf7a8..4ffaad2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2239,7 +2239,6 @@ EXPORT_SYMBOL(schedule_delayed_work_on);
 int schedule_on_each_cpu(work_func_t func)
 {
 	int cpu;
-	int orig = -1;
 	struct work_struct *works;
 
 	works = alloc_percpu(struct work_struct);
@@ -2248,23 +2247,12 @@ int schedule_on_each_cpu(work_func_t func)
 
 	get_online_cpus();
 
-	/*
-	 * When running in keventd don't schedule a work item on
-	 * itself.  Can just call directly because the work queue is
-	 * already bound.  This also is faster.
-	 */
-	if (current_is_keventd())
-		orig = raw_smp_processor_id();
-
 	for_each_online_cpu(cpu) {
 		struct work_struct *work = per_cpu_ptr(works, cpu);
 
 		INIT_WORK(work, func);
-		if (cpu != orig)
-			schedule_work_on(cpu, work);
+		schedule_work_on(cpu, work);
 	}
-	if (orig >= 0)
-		func(per_cpu_ptr(works, orig));
 
 	for_each_online_cpu(cpu)
 		flush_work(per_cpu_ptr(works, cpu));
@@ -2311,41 +2299,6 @@ int keventd_up(void)
 	return keventd_wq != NULL;
 }
 
-int current_is_keventd(void)
-{
-	bool found = false;
-	unsigned int cpu;
-
-	/*
-	 * There no longer is one-to-one relation between worker and
-	 * work queue and a worker task might be unbound from its cpu
-	 * if the cpu was offlined.  Match all busy workers.  This
-	 * function will go away once dynamic pool is implemented.
-	 */
-	for_each_possible_cpu(cpu) {
-		struct global_cwq *gcwq = get_gcwq(cpu);
-		struct worker *worker;
-		struct hlist_node *pos;
-		unsigned long flags;
-		int i;
-
-		spin_lock_irqsave(&gcwq->lock, flags);
-
-		for_each_busy_worker(worker, i, pos, gcwq) {
-			if (worker->task == current) {
-				found = true;
-				break;
-			}
-		}
-
-		spin_unlock_irqrestore(&gcwq->lock, flags);
-		if (found)
-			break;
-	}
-
-	return found;
-}
-
 static struct cpu_workqueue_struct *alloc_cwqs(void)
 {
 	const size_t size = sizeof(struct cpu_workqueue_struct);
@@ -2393,7 +2346,8 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	struct workqueue_struct *wq;
 	unsigned int cpu;
 
-	max_active = clamp_val(max_active, 1, INT_MAX);
+	WARN_ON(max_active < 1 || max_active > WQ_MAX_ACTIVE);
+	max_active = clamp_val(max_active, 1, WQ_MAX_ACTIVE);
 
 	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
 	if (!wq)
@@ -3136,6 +3090,6 @@ void __init init_workqueues(void)
 		spin_unlock_irq(&gcwq->lock);
 	}
 
-	keventd_wq = create_workqueue("events");
+	keventd_wq = __create_workqueue("events", 0, WQ_MAX_ACTIVE / 2);
 	BUG_ON(!keventd_wq);
 }
-- 
1.6.4.2

