Return-Path: <linux-kernel-owner+w=401wt.eu-S936187AbYEBT4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936187AbYEBT4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757633AbYEBT4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:56:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56339 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757553AbYEBT4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:56:40 -0400
Subject: 'global' rq->clock (was Re: Horrendous Audio Stutter - current git)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Frans Pop <elendil@planet.nl>, Parag Warudkar <parag.warudkar@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Guillaume Chazarain <guichaz@yahoo.fr>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1209756423.4693.8.camel@marge.simson.net>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com>
	 <1209740523.4776.1.camel@marge.simson.net>
	 <200805021749.10205.elendil@planet.nl>
	 <200805022053.24779.elendil@planet.nl>
	 <1209756423.4693.8.camel@marge.simson.net>
Content-Type: text/plain
Date: Fri, 02 May 2008 21:56:26 +0200
Message-Id: <1209758186.6929.18.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-02 at 21:27 +0200, Mike Galbraith wrote:

That's a quite horrible patch for some of us, but I think I know why you
did that, and I think your fancy Q6600 has a stable enough TSC to pull
it off.

Let me try and come up with something slightly less horrible

> Fix undesirable rq.clock update noops.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
> Index: linux-2.6.26.git/kernel/sched.c
> ===================================================================
> --- linux-2.6.26.git.orig/kernel/sched.c
> +++ linux-2.6.26.git/kernel/sched.c
> @@ -668,9 +668,6 @@ static void __update_rq_clock(struct rq 
>  	s64 delta = now - prev_raw;
>  	u64 clock = rq->clock;
>  
> -#ifdef CONFIG_SCHED_DEBUG
> -	WARN_ON_ONCE(cpu_of(rq) != smp_processor_id());
> -#endif
>  	/*
>  	 * Protect against sched_clock() occasionally going backwards:
>  	 */
> @@ -3009,8 +3006,8 @@ static void double_rq_lock(struct rq *rq
>  			spin_lock(&rq1->lock);
>  		}
>  	}
> -	update_rq_clock(rq1);
> -	update_rq_clock(rq2);
> +	__update_rq_clock(rq1);
> +	__update_rq_clock(rq2);
>  }
>  
>  /*
> @@ -3860,7 +3857,7 @@ redo:
>  		/* Attempt to move tasks */
>  		double_lock_balance(this_rq, busiest);
>  		/* this_rq->clock is already updated */
> -		update_rq_clock(busiest);
> +		__update_rq_clock(busiest);
>  		ld_moved = move_tasks(this_rq, this_cpu, busiest,
>  					imbalance, sd, CPU_NEWLY_IDLE,
>  					&all_pinned);
> @@ -3959,8 +3956,8 @@ static void active_load_balance(struct r
>  
>  	/* move a task from busiest_rq to target_rq */
>  	double_lock_balance(busiest_rq, target_rq);
> -	update_rq_clock(busiest_rq);
> -	update_rq_clock(target_rq);
> +	__update_rq_clock(busiest_rq);
> +	__update_rq_clock(target_rq);
>  
>  	/* Search for an sd spanning us and the target CPU. */
>  	for_each_domain(target_cpu, sd) {
> Index: linux-2.6.26.git/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6.26.git.orig/kernel/sched_fair.c
> +++ linux-2.6.26.git/kernel/sched_fair.c
> @@ -1221,7 +1221,7 @@ static void check_preempt_wakeup(struct 
>  	int se_depth, pse_depth;
>  
>  	if (unlikely(rt_prio(p->prio))) {
> -		update_rq_clock(rq);
> +		__update_rq_clock(rq);
>  		update_curr(cfs_rq);
>  		resched_task(curr);
>  		return;
> 

Ok, the the below would need something that relates tick_timestamp's to
one another.. probably sucks without it..

OTOH, Andi said he was working on a fastish global sched_clock() thingy,
Andi got a link to that code?

Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -560,6 +560,7 @@ struct rq {
 	unsigned long next_balance;
 	struct mm_struct *prev_mm;
 
+	spinlock_t clock_lock;
 	u64 clock, prev_clock_raw;
 	s64 clock_max_delta;
 
@@ -657,20 +658,25 @@ static inline void update_last_tick_seen
 }
 #endif
 
+#define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
+#define this_rq()		(&__get_cpu_var(runqueues))
+#define task_rq(p)		cpu_rq(task_cpu(p))
+#define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
+
 /*
  * Update the per-runqueue clock, as finegrained as the platform can give
  * us, but without assuming monotonicity, etc.:
  */
-static void __update_rq_clock(struct rq *rq)
+static void ___update_rq_clock(struct rq *rq, u64 now)
 {
 	u64 prev_raw = rq->prev_clock_raw;
-	u64 now = sched_clock();
 	s64 delta = now - prev_raw;
 	u64 clock = rq->clock;
 
 #ifdef CONFIG_SCHED_DEBUG
 	WARN_ON_ONCE(cpu_of(rq) != smp_processor_id());
 #endif
+	spin_lock(&rq->clock_lock);
 	/*
 	 * Protect against sched_clock() occasionally going backwards:
 	 */
@@ -699,12 +705,31 @@ static void __update_rq_clock(struct rq 
 
 	rq->prev_clock_raw = now;
 	rq->clock = clock;
+	spin_unlock(&rq->clock_lock);
+}
+
+static void __update_rq_clock(struct rq *rq)
+{
+	___update_rq_clock(rq, sched_clock());
+}
+
+static void __update_remote_rq_clock(struct rq *rq)
+{
+	u64 now = sched_clock();
+	struct rq *this_rq = this_rq();
+
+	now -= this_rq->tick_timestamp;
+	now += rq->tick_timestamp;
+
+	___update_rq_clock(rq, now);
 }
 
 static void update_rq_clock(struct rq *rq)
 {
 	if (likely(smp_processor_id() == cpu_of(rq)))
 		__update_rq_clock(rq);
+	else
+		__update_remote_rq_clock(rq);
 }
 
 /*
@@ -717,11 +742,6 @@ static void update_rq_clock(struct rq *r
 #define for_each_domain(cpu, __sd) \
 	for (__sd = rcu_dereference(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)
 
-#define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
-#define this_rq()		(&__get_cpu_var(runqueues))
-#define task_rq(p)		cpu_rq(task_cpu(p))
-#define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
-
 /*
  * Tunables that become constants when CONFIG_SCHED_DEBUG is off:
  */
@@ -8147,6 +8167,7 @@ void __init sched_init(void)
 
 		rq = cpu_rq(i);
 		spin_lock_init(&rq->lock);
+		spin_lock_init(&rq->clock_lock);
 		lockdep_set_class(&rq->lock, &rq->rq_lock_key);
 		rq->nr_running = 0;
 		rq->clock = 1;



