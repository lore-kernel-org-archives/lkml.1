Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbYGNOnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbYGNOnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 10:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbYGNOnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 10:43:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54336 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846AbYGNOm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 10:42:59 -0400
Date: Mon, 14 Jul 2008 16:42:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] core/softirq for v2.6.27
Message-ID: <20080714144243.GA21079@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core/softirq changes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/softirq

Thanks,

	Ingo

------------------>
Carlos R. Mafra (1):
      Remove argument from open_softirq which is always NULL

Johannes Berg (1):
      softirq: remove irqs_disabled warning from local_bh_enable

Vegard Nossum (1):
      softirq: remove initialization of static per-cpu variable


 block/blk-core.c          |    2 +-
 include/linux/interrupt.h |    3 +-
 kernel/hrtimer.c          |    2 +-
 kernel/rcuclassic.c       |    2 +-
 kernel/rcupreempt.c       |    2 +-
 kernel/sched.c            |    2 +-
 kernel/softirq.c          |   61 ++++++++++++---------------------------------
 kernel/timer.c            |    2 +-
 net/core/dev.c            |    4 +-
 9 files changed, 25 insertions(+), 55 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1905aab..af094ff 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2045,7 +2045,7 @@ int __init blk_dev_init(void)
 	for_each_possible_cpu(i)
 		INIT_LIST_HEAD(&per_cpu(blk_cpu_done, i));
 
-	open_softirq(BLOCK_SOFTIRQ, blk_done_softirq, NULL);
+	open_softirq(BLOCK_SOFTIRQ, blk_done_softirq);
 	register_hotcpu_notifier(&blk_cpu_notifier);
 
 	return 0;
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index f1fc747..a86186d 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -285,12 +285,11 @@ enum
 struct softirq_action
 {
 	void	(*action)(struct softirq_action *);
-	void	*data;
 };
 
 asmlinkage void do_softirq(void);
 asmlinkage void __do_softirq(void);
-extern void open_softirq(int nr, void (*action)(struct softirq_action*), void *data);
+extern void open_softirq(int nr, void (*action)(struct softirq_action *));
 extern void softirq_init(void);
 #define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
 extern void raise_softirq_irqoff(unsigned int nr);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 421be5f..861b408 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1669,7 +1669,7 @@ void __init hrtimers_init(void)
 			  (void *)(long)smp_processor_id());
 	register_cpu_notifier(&hrtimers_nb);
 #ifdef CONFIG_HIGH_RES_TIMERS
-	open_softirq(HRTIMER_SOFTIRQ, run_hrtimer_softirq, NULL);
+	open_softirq(HRTIMER_SOFTIRQ, run_hrtimer_softirq);
 #endif
 }
 
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index f4ffbd0..f6e01f3 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -529,7 +529,7 @@ static void __cpuinit rcu_online_cpu(int cpu)
 
 	rcu_init_percpu_data(cpu, &rcu_ctrlblk, rdp);
 	rcu_init_percpu_data(cpu, &rcu_bh_ctrlblk, bh_rdp);
-	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks, NULL);
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
 
 static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 5e02b77..902dce2 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -1123,7 +1123,7 @@ void __init __rcu_init(void)
 	for_each_online_cpu(cpu)
 		rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE,	(void *)(long) cpu);
 
-	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks, NULL);
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
 
 /*
diff --git a/kernel/sched.c b/kernel/sched.c
index 3aaa5c8..5695835 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7832,7 +7832,7 @@ void __init sched_init(void)
 #endif
 
 #ifdef CONFIG_SMP
-	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains, NULL);
+	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
 #endif
 
 #ifdef CONFIG_RT_MUTEXES
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 36e0617..2cf2502 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -131,23 +131,17 @@ void _local_bh_enable(void)
 
 EXPORT_SYMBOL(_local_bh_enable);
 
-void local_bh_enable(void)
+static inline void _local_bh_enable_ip(unsigned long ip)
 {
+	WARN_ON_ONCE(in_irq() || irqs_disabled());
 #ifdef CONFIG_TRACE_IRQFLAGS
-	unsigned long flags;
-
-	WARN_ON_ONCE(in_irq());
-#endif
-	WARN_ON_ONCE(irqs_disabled());
-
-#ifdef CONFIG_TRACE_IRQFLAGS
-	local_irq_save(flags);
+	local_irq_disable();
 #endif
 	/*
 	 * Are softirqs going to be turned on now:
 	 */
 	if (softirq_count() == SOFTIRQ_OFFSET)
-		trace_softirqs_on((unsigned long)__builtin_return_address(0));
+		trace_softirqs_on(ip);
 	/*
 	 * Keep preemption disabled until we are done with
 	 * softirq processing:
@@ -159,40 +153,20 @@ void local_bh_enable(void)
 
 	dec_preempt_count();
 #ifdef CONFIG_TRACE_IRQFLAGS
-	local_irq_restore(flags);
+	local_irq_enable();
 #endif
 	preempt_check_resched();
 }
+
+void local_bh_enable(void)
+{
+	_local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+}
 EXPORT_SYMBOL(local_bh_enable);
 
 void local_bh_enable_ip(unsigned long ip)
 {
-#ifdef CONFIG_TRACE_IRQFLAGS
-	unsigned long flags;
-
-	WARN_ON_ONCE(in_irq());
-
-	local_irq_save(flags);
-#endif
-	/*
-	 * Are softirqs going to be turned on now:
-	 */
-	if (softirq_count() == SOFTIRQ_OFFSET)
-		trace_softirqs_on(ip);
-	/*
-	 * Keep preemption disabled until we are done with
-	 * softirq processing:
- 	 */
- 	sub_preempt_count(SOFTIRQ_OFFSET - 1);
-
-	if (unlikely(!in_interrupt() && local_softirq_pending()))
-		do_softirq();
-
-	dec_preempt_count();
-#ifdef CONFIG_TRACE_IRQFLAGS
-	local_irq_restore(flags);
-#endif
-	preempt_check_resched();
+	_local_bh_enable_ip(ip);
 }
 EXPORT_SYMBOL(local_bh_enable_ip);
 
@@ -347,9 +321,8 @@ void raise_softirq(unsigned int nr)
 	local_irq_restore(flags);
 }
 
-void open_softirq(int nr, void (*action)(struct softirq_action*), void *data)
+void open_softirq(int nr, void (*action)(struct softirq_action *))
 {
-	softirq_vec[nr].data = data;
 	softirq_vec[nr].action = action;
 }
 
@@ -360,10 +333,8 @@ struct tasklet_head
 	struct tasklet_struct **tail;
 };
 
-/* Some compilers disobey section attribute on statics when not
-   initialized -- RR */
-static DEFINE_PER_CPU(struct tasklet_head, tasklet_vec) = { NULL };
-static DEFINE_PER_CPU(struct tasklet_head, tasklet_hi_vec) = { NULL };
+static DEFINE_PER_CPU(struct tasklet_head, tasklet_vec);
+static DEFINE_PER_CPU(struct tasklet_head, tasklet_hi_vec);
 
 void __tasklet_schedule(struct tasklet_struct *t)
 {
@@ -503,8 +474,8 @@ void __init softirq_init(void)
 			&per_cpu(tasklet_hi_vec, cpu).head;
 	}
 
-	open_softirq(TASKLET_SOFTIRQ, tasklet_action, NULL);
-	open_softirq(HI_SOFTIRQ, tasklet_hi_action, NULL);
+	open_softirq(TASKLET_SOFTIRQ, tasklet_action);
+	open_softirq(HI_SOFTIRQ, tasklet_hi_action);
 }
 
 static int ksoftirqd(void * __bind_cpu)
diff --git a/kernel/timer.c b/kernel/timer.c
index ceacc66..b4da888 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1502,7 +1502,7 @@ void __init init_timers(void)
 
 	BUG_ON(err == NOTIFY_BAD);
 	register_cpu_notifier(&timers_nb);
-	open_softirq(TIMER_SOFTIRQ, run_timer_softirq, NULL);
+	open_softirq(TIMER_SOFTIRQ, run_timer_softirq);
 }
 
 /**
diff --git a/net/core/dev.c b/net/core/dev.c
index c421a1f..48f1e04 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4585,8 +4585,8 @@ static int __init net_dev_init(void)
 
 	dev_boot_phase = 0;
 
-	open_softirq(NET_TX_SOFTIRQ, net_tx_action, NULL);
-	open_softirq(NET_RX_SOFTIRQ, net_rx_action, NULL);
+	open_softirq(NET_TX_SOFTIRQ, net_tx_action);
+	open_softirq(NET_RX_SOFTIRQ, net_rx_action);
 
 	hotcpu_notifier(dev_cpu_callback, 0);
 	dst_init();
