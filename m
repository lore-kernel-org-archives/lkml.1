Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbXBFKKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbXBFKKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 05:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbXBFKKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 05:10:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40628 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbXBFKKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 05:10:47 -0500
Subject: Re: v2.6.20-rt1, yum/rpm
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20070205065636.GA1652@elte.hu>
References: <20070205065636.GA1652@elte.hu>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 06 Feb 2007 11:10:44 +0100
Message-Id: <1170756645.7324.8.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-05 at 07:56 +0100, Ingo Molnar wrote:
> i have released the v2.6.20-rt1 kernel, which can be downloaded from the 
> usual place:
> 
>   http://redhat.com/~mingo/realtime-preempt/
> 
> more info about the -rt patchset can be found in the RT wiki:
> 
>   http://rt.wiki.kernel.org
> 
> This is a fixes-only release. Since the -rt tree has been closely 
> tracking Linus' upstream kernel since -rc1, no new issues are expected - 
> please re-report if anything is still unfixed.


patch below has 2 tweaks
1) the new RCU feature wakes up once per second, make sure this is using
the new round_jiffies() infrastructure
2) the slab background reap code is waking up once per 2 seconds per
cpu. The patch makes this more dynamic; if no work was done (no activity
on the cpu happened) then this is made to be 4 seconds

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>


Index: linux-2.6.20-rt2/kernel/rcupreempt.c
===================================================================
--- linux-2.6.20-rt2.orig/kernel/rcupreempt.c
+++ linux-2.6.20-rt2/kernel/rcupreempt.c
@@ -465,7 +465,7 @@ static int rcu_booster(void *arg)
 		 * adjust, or eliminate in case of OOM.
 		 */
 
-		schedule_timeout_interruptible(HZ);
+		schedule_timeout_interruptible(round_jiffies_relative(HZ));
 
 		/* Print stats if enough time has passed. */
 
Index: linux-2.6.20-rt2/kernel/rcutorture.c
===================================================================
--- linux-2.6.20-rt2.orig/kernel/rcutorture.c
+++ linux-2.6.20-rt2/kernel/rcutorture.c
@@ -288,7 +288,7 @@ static int rcu_torture_preempt(void *arg
 			cond_resched();
 		if (rcu_torture_completed() == completedstart)
 			rcu_torture_preempt_errors++;
-		schedule_timeout_interruptible(HZ);
+		schedule_timeout_interruptible(round_jiffies_relative(HZ));
 	} while (!kthread_should_stop());
 	return 0;
 }
@@ -660,7 +660,7 @@ rcu_torture_reader(void *arg)
 		if (p == NULL) {
 			/* Wait for rcu_torture_writer to get underway */
 			cur_ops->readunlock(idx);
-			schedule_timeout_interruptible(HZ);
+			schedule_timeout_interruptible(round_jiffies_relative(HZ));
 			continue;
 		}
 		if (p->rtort_mbtest == 0)
Index: linux-2.6.20-rt2/mm/slab.c
===================================================================
--- linux-2.6.20-rt2.orig/mm/slab.c
+++ linux-2.6.20-rt2/mm/slab.c
@@ -1062,7 +1062,7 @@ static int transfer_objects(struct array
 #ifndef CONFIG_NUMA
 
 #define drain_alien_cache(cachep, alien) do { } while (0)
-#define reap_alien(cachep, l3, this_cpu) do { } while (0)
+#define reap_alien(cachep, l3, this_cpu) 0
 
 static inline struct array_cache **alloc_alien_cache(int node, int limit)
 {
@@ -1160,7 +1160,7 @@ static void __drain_alien_cache(struct k
 /*
  * Called from cache_reap() to regularly drain alien caches round robin.
  */
-static void
+static int
 reap_alien(struct kmem_cache *cachep, struct kmem_list3 *l3, int *this_cpu)
 {
 	int node = per_cpu(reap_node, *this_cpu);
@@ -1171,8 +1171,10 @@ reap_alien(struct kmem_cache *cachep, st
 		if (ac && ac->avail && spin_trylock_irq(&ac->lock)) {
 			__drain_alien_cache(cachep, ac, node, this_cpu);
 			spin_unlock_irq(&ac->lock);
+			return 1;
 		}
 	}
+	return 0;
 }
 
 static void drain_alien_cache(struct kmem_cache *cachep,
@@ -2473,7 +2475,7 @@ static void check_spinlock_acquired_node
 #define check_spinlock_acquired_node(x, y) do { } while(0)
 #endif
 
-static void drain_array(struct kmem_cache *cachep, struct kmem_list3 *l3,
+static int drain_array(struct kmem_cache *cachep, struct kmem_list3 *l3,
 			struct array_cache *ac,
 			int force, int node);
 
@@ -4114,15 +4116,16 @@ static int enable_cpucache(struct kmem_c
  * Drain an array if it contains any elements taking the l3 lock only if
  * necessary. Note that the l3 listlock also protects the array_cache
  * if drain_array() is used on the shared array.
+ * returns non-zero if some work is done
  */
-void drain_array(struct kmem_cache *cachep, struct kmem_list3 *l3,
+int drain_array(struct kmem_cache *cachep, struct kmem_list3 *l3,
 		 struct array_cache *ac, int force, int node)
 {
 	int this_cpu = smp_processor_id();
 	int tofree;
 
 	if (!ac || !ac->avail)
-		return;
+		return 0;
 	if (ac->touched && !force) {
 		ac->touched = 0;
 	} else {
@@ -4138,6 +4141,7 @@ void drain_array(struct kmem_cache *cach
 		}
 		slab_spin_unlock_irq(&l3->list_lock, this_cpu);
 	}
+	return 1;
 }
 
 /**
@@ -4157,6 +4161,7 @@ static void cache_reap(struct work_struc
 	int this_cpu = raw_smp_processor_id(), node = cpu_to_node(this_cpu);
 	struct kmem_cache *searchp;
 	struct kmem_list3 *l3;
+	int work_done = 0;
 
 	if (!mutex_trylock(&cache_chain_mutex)) {
 		/* Give up. Setup the next iteration. */
@@ -4175,10 +4180,10 @@ static void cache_reap(struct work_struc
 		 */
 		l3 = searchp->nodelists[node];
 
-		reap_alien(searchp, l3, &this_cpu);
+		work_done += reap_alien(searchp, l3, &this_cpu);
 
-		drain_array(searchp, l3, cpu_cache_get(searchp, this_cpu),
-			    0, node);
+		work_done += drain_array(searchp, l3,
+			    cpu_cache_get(searchp, this_cpu), 0, node);
 
 		/*
 		 * These are racy checks but it does not matter
@@ -4189,7 +4194,7 @@ static void cache_reap(struct work_struc
 
 		l3->next_reap = jiffies + REAPTIMEOUT_LIST3;
 
-		drain_array(searchp, l3, l3->shared, 0, node);
+		work_done += drain_array(searchp, l3, l3->shared, 0, node);
 
 		if (l3->free_touched)
 			l3->free_touched = 0;
@@ -4207,9 +4212,10 @@ next:
 	mutex_unlock(&cache_chain_mutex);
 	next_reap_node();
 	refresh_cpu_vm_stats(smp_processor_id());
+
 	/* Set up the next iteration */
 	schedule_delayed_work(&__get_cpu_var(reap_work),
-		round_jiffies_relative(REAPTIMEOUT_CPUC));
+		round_jiffies_relative((1+!work_done) * REAPTIMEOUT_CPUC));
 }
 
 #ifdef CONFIG_PROC_FS


