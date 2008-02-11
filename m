Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbYBKNed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbYBKNed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 08:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbYBKNeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 08:34:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49991 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbYBKNeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 08:34:21 -0500
Subject: Re: lock_task_group_list() can be called from the atomic context
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Denis V. Lunev" <den@sw.ru>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       vatsa <vatsa@linux.vnet.ibm.com>
In-Reply-To: <1202731747.13118.20.camel@iris.sw.ru>
References: <1202731747.13118.20.camel@iris.sw.ru>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 14:33:49 +0100
Message-Id: <1202736830.6247.4.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-11 at 15:09 +0300, Denis V. Lunev wrote:

Curious, I hadn't yet seen it... Does the below fix it?

> BUG: sleeping function called from invalid context
> at /home/den/src/linux-netns26/kernel/mutex.c:209
> in_atomic():1, irqs_disabled():0
> no locks held by swapper/0.
> Pid: 0, comm: swapper Not tainted 2.6.24 #304
> 
> Call Trace:
>  <IRQ>  [<ffffffff80252d1e>] ? __debug_show_held_locks+0x15/0x27
>  [<ffffffff8022c2a8>] __might_sleep+0xc0/0xdf
>  [<ffffffff8049f1df>] mutex_lock_nested+0x28/0x2a9
>  [<ffffffff80231294>] sched_destroy_group+0x18/0xea
>  [<ffffffff8023e835>] sched_destroy_user+0xd/0xf
>  [<ffffffff8023e8c1>] free_uid+0x8a/0xab
>  [<ffffffff80233e24>] __put_task_struct+0x3f/0xd3
>  [<ffffffff80236708>] delayed_put_task_struct+0x23/0x25
>  [<ffffffff8026fda7>] __rcu_process_callbacks+0x8d/0x215
>  [<ffffffff8026ff52>] rcu_process_callbacks+0x23/0x44
>  [<ffffffff8023a2ae>] __do_softirq+0x79/0xf8
>  [<ffffffff8020f8c3>] ? profile_pc+0x2a/0x67
>  [<ffffffff8020d38c>] call_softirq+0x1c/0x30
>  [<ffffffff8020f689>] do_softirq+0x61/0x9c
>  [<ffffffff8023a233>] irq_exit+0x51/0x53
>  [<ffffffff8021bd1a>] smp_apic_timer_interrupt+0x77/0xad
>  [<ffffffff8020ce3b>] apic_timer_interrupt+0x6b/0x70
>  <EOI>  [<ffffffff8020b0dd>] ? default_idle+0x43/0x76
>  [<ffffffff8020b0db>] ? default_idle+0x41/0x76
>  [<ffffffff8020b09a>] ? default_idle+0x0/0x76
>  [<ffffffff8020b186>] ? cpu_idle+0x76/0x98

separate the tg->shares protection from the task_group lock.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -232,10 +232,10 @@ static struct cfs_rq *init_cfs_rq_p[NR_C
 static struct sched_rt_entity *init_sched_rt_entity_p[NR_CPUS];
 static struct rt_rq *init_rt_rq_p[NR_CPUS];
 
-/* task_group_mutex serializes add/remove of task groups and also changes to
+/* task_group_lock serializes add/remove of task groups and also changes to
  * a task group's cpu shares.
  */
-static DEFINE_MUTEX(task_group_mutex);
+static DEFINE_SPINLOCK(task_group_lock);
 
 /* doms_cur_mutex serializes access to doms_cur[] array */
 static DEFINE_MUTEX(doms_cur_mutex);
@@ -295,16 +295,6 @@ static inline void set_task_rq(struct ta
 	p->rt.parent = task_group(p)->rt_se[cpu];
 }
 
-static inline void lock_task_group_list(void)
-{
-	mutex_lock(&task_group_mutex);
-}
-
-static inline void unlock_task_group_list(void)
-{
-	mutex_unlock(&task_group_mutex);
-}
-
 static inline void lock_doms_cur(void)
 {
 	mutex_lock(&doms_cur_mutex);
@@ -318,8 +308,6 @@ static inline void unlock_doms_cur(void)
 #else
 
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
-static inline void lock_task_group_list(void) { }
-static inline void unlock_task_group_list(void) { }
 static inline void lock_doms_cur(void) { }
 static inline void unlock_doms_cur(void) { }
 
@@ -7571,6 +7559,7 @@ struct task_group *sched_create_group(vo
 	struct rt_rq *rt_rq;
 	struct sched_rt_entity *rt_se;
 	struct rq *rq;
+	unsigned long flags;
 	int i;
 
 	tg = kzalloc(sizeof(*tg), GFP_KERNEL);
@@ -7620,7 +7609,7 @@ struct task_group *sched_create_group(vo
 		init_tg_rt_entry(rq, tg, rt_rq, rt_se, i, 0);
 	}
 
-	lock_task_group_list();
+	spin_lock_irqsave(&task_group_lock, flags);
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
 		cfs_rq = tg->cfs_rq[i];
@@ -7629,7 +7618,7 @@ struct task_group *sched_create_group(vo
 		list_add_rcu(&rt_rq->leaf_rt_rq_list, &rq->leaf_rt_rq_list);
 	}
 	list_add_rcu(&tg->list, &task_groups);
-	unlock_task_group_list();
+	spin_unlock_irqrestore(&task_group_lock, flags);
 
 	return tg;
 
@@ -7650,9 +7639,10 @@ void sched_destroy_group(struct task_gro
 {
 	struct cfs_rq *cfs_rq = NULL;
 	struct rt_rq *rt_rq = NULL;
+	unsigned long flags;
 	int i;
 
-	lock_task_group_list();
+	spin_lock_irqsave(&task_group_lock, flags);
 	for_each_possible_cpu(i) {
 		cfs_rq = tg->cfs_rq[i];
 		list_del_rcu(&cfs_rq->leaf_cfs_rq_list);
@@ -7660,7 +7650,7 @@ void sched_destroy_group(struct task_gro
 		list_del_rcu(&rt_rq->leaf_rt_rq_list);
 	}
 	list_del_rcu(&tg->list);
-	unlock_task_group_list();
+	spin_unlock_irqrestore(&task_group_lock, flags);
 
 	BUG_ON(!cfs_rq);
 
@@ -7728,13 +7718,16 @@ static void set_se_shares(struct sched_e
 	}
 }
 
+static DEFINE_MUTEX(shares_mutex);
+
 int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 {
 	int i;
 	struct cfs_rq *cfs_rq;
 	struct rq *rq;
+	unsigned long flags;
 
-	lock_task_group_list();
+	mutex_lock(&shares_mutex);
 	if (tg->shares == shares)
 		goto done;
 
@@ -7746,10 +7739,12 @@ int sched_group_set_shares(struct task_g
 	 * load_balance_fair) from referring to this group first,
 	 * by taking it off the rq->leaf_cfs_rq_list on each cpu.
 	 */
+	spin_lock_irqsave(&task_group_lock, flags);
 	for_each_possible_cpu(i) {
 		cfs_rq = tg->cfs_rq[i];
 		list_del_rcu(&cfs_rq->leaf_cfs_rq_list);
 	}
+	spin_unlock_irqrestore(&task_group_lock, flags);
 
 	/* wait for any ongoing reference to this group to finish */
 	synchronize_sched();
@@ -7769,13 +7764,15 @@ int sched_group_set_shares(struct task_g
 	 * Enable load balance activity on this group, by inserting it back on
 	 * each cpu's rq->leaf_cfs_rq_list.
 	 */
+	spin_lock_irqsave(&task_group_lock, flags);
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
 		cfs_rq = tg->cfs_rq[i];
 		list_add_rcu(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
 	}
+	spin_unlock_irqrestore(&task_group_lock, flags);
 done:
-	unlock_task_group_list();
+	mutex_unlock(&shares_mutex);
 	return 0;
 }
 


