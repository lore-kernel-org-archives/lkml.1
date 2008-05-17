Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617AbYEQEV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbYEQEV0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 00:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbYEQEVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 00:21:18 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:13397 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbYEQEVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 00:21:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=rKSZaaeiEnL0vG7DzaSYcwidY+v+cNZHIUXHhJ/y82G59RF+KUmEAyGHb+53mneEy4gjiRcmoMa13km7Rep7x1sc7XjFxSjq3xjt1JyYW/5BFMWPzvyOVeyMeBRDp5EHIXyLsnShCPNPhseztkYdEhVhPW8PZ02o8HFHsis5+P4=
Date: Sat, 17 May 2008 01:24:17 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, matthew@wil.cx
Subject: [PATCH] Remove unused argument from functions invoked by
	open_softirq
Message-ID: <20080517042415.GA7134@Pilar>
References: <20080515141537.GA22826@beyonder.ift.unesp.br> <20080516182807.GA28406@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516182807.GA28406@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused argument from functions invoked by open_softirq

Simplify struct softirq_action to avoid the need of an explicit unused
argument in the functions invoked by open_softirq(). For example,

static void rcu_process_callbacks(struct softirq_action *unused)

can now become

static void rcu_process_callbacks(void)

Signed-off-by: Carlos R. Mafra <crmafra@ift.unesp.br>
---
 block/blk-core.c          |    2 +-
 include/linux/interrupt.h |    4 ++--
 kernel/hrtimer.c          |    2 +-
 kernel/rcuclassic.c       |    2 +-
 kernel/rcupreempt.c       |    2 +-
 kernel/sched.c            |    2 +-
 kernel/softirq.c          |    8 ++++----
 kernel/timer.c            |    2 +-
 net/core/dev.c            |    4 ++--
 9 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 75fdc65..20847b0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1630,7 +1630,7 @@ static int __end_that_request_first(struct request *req, int error,
  * splice the completion data to a local structure and hand off to
  * process_completion_queue() to complete the requests
  */
-static void blk_done_softirq(struct softirq_action *h)
+static void blk_done_softirq(void)
 {
 	struct list_head *cpu_list, local_list;
 
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index a86186d..0fed9e9 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -284,12 +284,12 @@ enum
 
 struct softirq_action
 {
-	void	(*action)(struct softirq_action *);
+	void	(*action)(void);
 };
 
 asmlinkage void do_softirq(void);
 asmlinkage void __do_softirq(void);
-extern void open_softirq(int nr, void (*action)(struct softirq_action *));
+extern void open_softirq(int nr, void (*action)(void));
 extern void softirq_init(void);
 #define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
 extern void raise_softirq_irqoff(unsigned int nr);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 861b408..0d4a864 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1342,7 +1342,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 		raise_softirq(HRTIMER_SOFTIRQ);
 }
 
-static void run_hrtimer_softirq(struct softirq_action *h)
+static void run_hrtimer_softirq(void)
 {
 	run_hrtimer_pending(&__get_cpu_var(hrtimer_bases));
 }
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index f6e01f3..f207525 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -442,7 +442,7 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
 		rcu_do_batch(rdp);
 }
 
-static void rcu_process_callbacks(struct softirq_action *unused)
+static void rcu_process_callbacks(void)
 {
 	__rcu_process_callbacks(&rcu_ctrlblk, &__get_cpu_var(rcu_data));
 	__rcu_process_callbacks(&rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 9dd827d..81322aa 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -948,7 +948,7 @@ void __devinit rcu_online_cpu(int cpu)
 
 #endif /* #else #ifdef CONFIG_HOTPLUG_CPU */
 
-static void rcu_process_callbacks(struct softirq_action *unused)
+static void rcu_process_callbacks(void)
 {
 	unsigned long flags;
 	struct rcu_head *next, *list;
diff --git a/kernel/sched.c b/kernel/sched.c
index 56ea3a2..3dd9137 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4078,7 +4078,7 @@ out:
  * In CONFIG_NO_HZ case, the idle load balance owner will do the
  * rebalancing for all the cpus for whom scheduler ticks are stopped.
  */
-static void run_rebalance_domains(struct softirq_action *h)
+static void run_rebalance_domains(void)
 {
 	int this_cpu = smp_processor_id();
 	struct rq *this_rq = cpu_rq(this_cpu);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 0592568..ff8d401 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -231,7 +231,7 @@ restart:
 
 	do {
 		if (pending & 1) {
-			h->action(h);
+			h->action();
 			rcu_bh_qsctr_inc(cpu);
 		}
 		h++;
@@ -347,7 +347,7 @@ void raise_softirq(unsigned int nr)
 	local_irq_restore(flags);
 }
 
-void open_softirq(int nr, void (*action)(struct softirq_action *))
+void open_softirq(int nr, void (*action)(void))
 {
 	softirq_vec[nr].action = action;
 }
@@ -392,7 +392,7 @@ void __tasklet_hi_schedule(struct tasklet_struct *t)
 
 EXPORT_SYMBOL(__tasklet_hi_schedule);
 
-static void tasklet_action(struct softirq_action *a)
+static void tasklet_action(void)
 {
 	struct tasklet_struct *list;
 
@@ -427,7 +427,7 @@ static void tasklet_action(struct softirq_action *a)
 	}
 }
 
-static void tasklet_hi_action(struct softirq_action *a)
+static void tasklet_hi_action(void)
 {
 	struct tasklet_struct *list;
 
diff --git a/kernel/timer.c b/kernel/timer.c
index b4da888..a7dae57 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1034,7 +1034,7 @@ static inline void calc_load(unsigned long ticks)
 /*
  * This function runs timers and the timer-tq in bottom half context.
  */
-static void run_timer_softirq(struct softirq_action *h)
+static void run_timer_softirq(void)
 {
 	struct tvec_base *base = __get_cpu_var(tvec_bases);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 692d971..d2e029f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1836,7 +1836,7 @@ static inline struct net_device *skb_bond(struct sk_buff *skb)
 }
 
 
-static void net_tx_action(struct softirq_action *h)
+static void net_tx_action(void)
 {
 	struct softnet_data *sd = &__get_cpu_var(softnet_data);
 
@@ -2159,7 +2159,7 @@ void __napi_schedule(struct napi_struct *n)
 EXPORT_SYMBOL(__napi_schedule);
 
 
-static void net_rx_action(struct softirq_action *h)
+static void net_rx_action(void)
 {
 	struct list_head *list = &__get_cpu_var(softnet_data).poll_list;
 	unsigned long start_time = jiffies;
-- 
1.5.5.GIT


