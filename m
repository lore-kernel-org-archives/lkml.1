Return-Path: <linux-kernel-owner+w=401wt.eu-S1759583AbYEOOQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583AbYEOOQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 10:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbYEOOQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 10:16:18 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:42376 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862AbYEOOQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 10:16:17 -0400
Date: Thu, 15 May 2008 11:15:37 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: matthew@wil.cx
Subject: [PATCH] Remove argument from open_softirq which is always NULL
Message-ID: <20080515141537.GA22826@beyonder.ift.unesp.br>
Mail-Followup-To: linux-kernel@vger.kernel.org, matthew@wil.cx
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9371c45e92c308425c0aad4794f61acb6fe6d140 Mon Sep 17 00:00:00 2001
From: Carlos R. Mafra <crmafra@ift.unesp.br>
Date: Wed, 14 May 2008 18:26:06 -0300
Subject: [PATCH] Remove argument from open_softirq which is always NULL

As git-grep shows, open_softirq() is always called with the last argument
being NULL

block/blk-core.c:       open_softirq(BLOCK_SOFTIRQ, blk_done_softirq, NULL);
kernel/hrtimer.c:       open_softirq(HRTIMER_SOFTIRQ, run_hrtimer_softirq, NULL);
kernel/rcuclassic.c:    open_softirq(RCU_SOFTIRQ, rcu_process_callbacks, NULL);
kernel/rcupreempt.c:    open_softirq(RCU_SOFTIRQ, rcu_process_callbacks, NULL);
kernel/sched.c: open_softirq(SCHED_SOFTIRQ, run_rebalance_domains, NULL);
kernel/softirq.c:       open_softirq(TASKLET_SOFTIRQ, tasklet_action, NULL);
kernel/softirq.c:       open_softirq(HI_SOFTIRQ, tasklet_hi_action, NULL);
kernel/timer.c: open_softirq(TIMER_SOFTIRQ, run_timer_softirq, NULL);
net/core/dev.c: open_softirq(NET_TX_SOFTIRQ, net_tx_action, NULL);
net/core/dev.c: open_softirq(NET_RX_SOFTIRQ, net_rx_action, NULL);

This observation has already been made by Matthew Wilcox in June 2002
(http://www.cs.helsinki.fi/linux/linux-kernel/2002-25/0687.html)

"I notice that none of the current softirq routines use the data element
passed to them."

and the situation hasn't changed since them. So it appears we can safely
remove that extra argument to save 128 (54) bytes of kernel data (text).

Signed-off-by: Carlos R. Mafra <crmafra@ift.unesp.br>
---
 block/blk-core.c          |    2 +-
 include/linux/interrupt.h |    3 +--
 kernel/hrtimer.c          |    2 +-
 kernel/rcuclassic.c       |    2 +-
 kernel/rcupreempt.c       |    2 +-
 kernel/sched.c            |    2 +-
 kernel/softirq.c          |    7 +++----
 kernel/timer.c            |    2 +-
 net/core/dev.c            |    4 ++--
 9 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2987fe4..667efc4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2049,7 +2049,7 @@ int __init blk_dev_init(void)
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
index e1cdf19..9dd827d 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -1125,7 +1125,7 @@ void __init __rcu_init(void)
 	for_each_online_cpu(cpu)
 		rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE,	(void *)(long) cpu);
 
-	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks, NULL);
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
 
 /*
diff --git a/kernel/sched.c b/kernel/sched.c
index 8841a91..80f6661 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8154,7 +8154,7 @@ void __init sched_init(void)
 #endif
 
 #ifdef CONFIG_SMP
-	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains, NULL);
+	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
 #endif
 
 #ifdef CONFIG_RT_MUTEXES
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 36e0617..0592568 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -347,9 +347,8 @@ void raise_softirq(unsigned int nr)
 	local_irq_restore(flags);
 }
 
-void open_softirq(int nr, void (*action)(struct softirq_action*), void *data)
+void open_softirq(int nr, void (*action)(struct softirq_action *))
 {
-	softirq_vec[nr].data = data;
 	softirq_vec[nr].action = action;
 }
 
@@ -503,8 +502,8 @@ void __init softirq_init(void)
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
index a1607bc..692d971 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4559,8 +4559,8 @@ static int __init net_dev_init(void)
 
 	dev_boot_phase = 0;
 
-	open_softirq(NET_TX_SOFTIRQ, net_tx_action, NULL);
-	open_softirq(NET_RX_SOFTIRQ, net_rx_action, NULL);
+	open_softirq(NET_TX_SOFTIRQ, net_tx_action);
+	open_softirq(NET_RX_SOFTIRQ, net_rx_action);
 
 	hotcpu_notifier(dev_cpu_callback, 0);
 	dst_init();
-- 
1.5.4.3

