Return-Path: <linux-kernel-owner+w=401wt.eu-S1764634AbXLMROl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764634AbXLMROl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790AbXLMROb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:14:31 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:36069 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761483AbXLMRO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:14:29 -0500
Date: Thu, 13 Dec 2007 22:44:04 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E McKenney <paulmck@us.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Ted Tso <tytso@us.ibm.com>, dvhltc@us.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 1/6] Preempt-RCU: Use softirq instead of tasklets for
	RCU
Message-ID: <20071213171404.GB25981@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071213170348.GA25981@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213170348.GA25981@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preempt-RCU: Use softirq instead of tasklets for RCU

From: Dipankar Sarma <dipankar@in.ibm.com>

This patch makes RCU use softirq instead of tasklets.

It also adds a memory barrier after raising the softirq
inorder to ensure that the cpu sees the most recently updated
value of rcu->cur while processing callbacks.
The discussion of the related theoretical race pointed out
by James Huang can be found here --> http://lkml.org/lkml/2007/11/20/603

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dipankar Sarma <dipankar@in.ibm.com>
---

 include/linux/interrupt.h |    1 +
 kernel/rcupdate.c         |   25 +++++++++++++++++--------
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 2306920..c3db4a0 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -256,6 +256,7 @@ enum
 #ifdef CONFIG_HIGH_RES_TIMERS
 	HRTIMER_SOFTIRQ,
 #endif
+	RCU_SOFTIRQ, 	/* Preferable RCU should always be the last softirq */
 };
 
 /* softirq mask and active fields moved to irq_cpustat_t in
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index a66d4d1..8658948 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -73,8 +73,6 @@ static struct rcu_ctrlblk rcu_bh_ctrlblk = {
 DEFINE_PER_CPU(struct rcu_data, rcu_data) = { 0L };
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data) = { 0L };
 
-/* Fake initialization required by compiler */
-static DEFINE_PER_CPU(struct tasklet_struct, rcu_tasklet) = {NULL};
 static int blimit = 10;
 static int qhimark = 10000;
 static int qlowmark = 100;
@@ -231,6 +229,18 @@ void rcu_barrier(void)
 }
 EXPORT_SYMBOL_GPL(rcu_barrier);
 
+/* Raises the softirq for processing rcu_callbacks. */
+static inline void raise_rcu_softirq(void)
+{
+	raise_softirq(RCU_SOFTIRQ);
+	/*
+	 * The smp_mb() here is required to ensure that this cpu's
+	 * __rcu_process_callbacks() reads the most recently updated
+	 * value of rcu->cur.
+	 */
+	smp_mb();
+}
+
 /*
  * Invoke the completed RCU callbacks. They are expected to be in
  * a per-cpu list.
@@ -260,7 +270,7 @@ static void rcu_do_batch(struct rcu_data *rdp)
 	if (!rdp->donelist)
 		rdp->donetail = &rdp->donelist;
 	else
-		tasklet_schedule(&per_cpu(rcu_tasklet, rdp->cpu));
+		raise_rcu_softirq();
 }
 
 /*
@@ -412,7 +422,6 @@ static void rcu_offline_cpu(int cpu)
 					&per_cpu(rcu_bh_data, cpu));
 	put_cpu_var(rcu_data);
 	put_cpu_var(rcu_bh_data);
-	tasklet_kill_immediate(&per_cpu(rcu_tasklet, cpu), cpu);
 }
 
 #else
@@ -424,7 +433,7 @@ static void rcu_offline_cpu(int cpu)
 #endif
 
 /*
- * This does the RCU processing work from tasklet context. 
+ * This does the RCU processing work from softirq context.
  */
 static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
 					struct rcu_data *rdp)
@@ -469,7 +478,7 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
 		rcu_do_batch(rdp);
 }
 
-static void rcu_process_callbacks(unsigned long unused)
+static void rcu_process_callbacks(struct softirq_action *unused)
 {
 	__rcu_process_callbacks(&rcu_ctrlblk, &__get_cpu_var(rcu_data));
 	__rcu_process_callbacks(&rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
@@ -533,7 +542,7 @@ void rcu_check_callbacks(int cpu, int user)
 		rcu_bh_qsctr_inc(cpu);
 	} else if (!in_softirq())
 		rcu_bh_qsctr_inc(cpu);
-	tasklet_schedule(&per_cpu(rcu_tasklet, cpu));
+	raise_rcu_softirq();
 }
 
 static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
@@ -556,7 +565,7 @@ static void __devinit rcu_online_cpu(int cpu)
 
 	rcu_init_percpu_data(cpu, &rcu_ctrlblk, rdp);
 	rcu_init_percpu_data(cpu, &rcu_bh_ctrlblk, bh_rdp);
-	tasklet_init(&per_cpu(rcu_tasklet, cpu), rcu_process_callbacks, 0UL);
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks, NULL);
 }
 
 static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
