Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbXFVS1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbXFVS1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760699AbXFVS0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:26:37 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:64613 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760693AbXFVS0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:26:36 -0400
Message-Id: <20070622182314.922886036@goodmis.org>
References: <20070622182051.859570787@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 22 Jun 2007 14:20:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
Subject: [RFC PATCH 1/5 v2] Convert the RCU tasklet into a softirq
Content-Disposition: inline; filename=convert-rcu-tasklet-to-softirq.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I believe this was originally done by Dipankar Sarma. I pulled these
changes from the -rt kernel.

For better preformance, RCU should use a softirq instead of a
tasklet.

From: Dipankar Sarma <dipankar@in.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6-test/include/linux/interrupt.h
===================================================================
--- linux-2.6-test.orig/include/linux/interrupt.h
+++ linux-2.6-test/include/linux/interrupt.h
@@ -245,6 +245,9 @@ enum
 #ifdef CONFIG_HIGH_RES_TIMERS
 	HRTIMER_SOFTIRQ,
 #endif
+	RCU_SOFTIRQ,	/* Preferable RCU should always be the last softirq */
+	/* Entries after this are ignored in split softirq mode */
+	MAX_SOFTIRQ,
 };
 
 /* softirq mask and active fields moved to irq_cpustat_t in
Index: linux-2.6-test/kernel/rcupdate.c
===================================================================
--- linux-2.6-test.orig/kernel/rcupdate.c
+++ linux-2.6-test/kernel/rcupdate.c
@@ -67,7 +67,6 @@ DEFINE_PER_CPU(struct rcu_data, rcu_data
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data) = { 0L };
 
 /* Fake initialization required by compiler */
-static DEFINE_PER_CPU(struct tasklet_struct, rcu_tasklet) = {NULL};
 static int blimit = 10;
 static int qhimark = 10000;
 static int qlowmark = 100;
@@ -253,7 +252,7 @@ static void rcu_do_batch(struct rcu_data
 	if (!rdp->donelist)
 		rdp->donetail = &rdp->donelist;
 	else
-		tasklet_schedule(&per_cpu(rcu_tasklet, rdp->cpu));
+		raise_softirq(RCU_SOFTIRQ);
 }
 
 /*
@@ -405,7 +404,6 @@ static void rcu_offline_cpu(int cpu)
 					&per_cpu(rcu_bh_data, cpu));
 	put_cpu_var(rcu_data);
 	put_cpu_var(rcu_bh_data);
-	tasklet_kill_immediate(&per_cpu(rcu_tasklet, cpu), cpu);
 }
 
 #else
@@ -417,7 +415,7 @@ static void rcu_offline_cpu(int cpu)
 #endif
 
 /*
- * This does the RCU processing work from tasklet context. 
+ * This does the RCU processing work from softirq context.
  */
 static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
 					struct rcu_data *rdp)
@@ -462,7 +460,7 @@ static void __rcu_process_callbacks(stru
 		rcu_do_batch(rdp);
 }
 
-static void rcu_process_callbacks(unsigned long unused)
+static void rcu_process_callbacks(struct softirq_action *unused)
 {
 	__rcu_process_callbacks(&rcu_ctrlblk, &__get_cpu_var(rcu_data));
 	__rcu_process_callbacks(&rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
@@ -526,7 +524,7 @@ void rcu_check_callbacks(int cpu, int us
 		rcu_bh_qsctr_inc(cpu);
 	} else if (!in_softirq())
 		rcu_bh_qsctr_inc(cpu);
-	tasklet_schedule(&per_cpu(rcu_tasklet, cpu));
+	raise_softirq(RCU_SOFTIRQ);
 }
 
 static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
@@ -549,7 +547,7 @@ static void __devinit rcu_online_cpu(int
 
 	rcu_init_percpu_data(cpu, &rcu_ctrlblk, rdp);
 	rcu_init_percpu_data(cpu, &rcu_bh_ctrlblk, bh_rdp);
-	tasklet_init(&per_cpu(rcu_tasklet, cpu), rcu_process_callbacks, 0UL);
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks, NULL);
 }
 
 static int __cpuinit rcu_cpu_notify(struct notifier_block *self,

-- 
