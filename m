Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbYDNECz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbYDNECz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 00:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbYDNECo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 00:02:44 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:45103 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbYDNECn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 00:02:43 -0400
Date: Sun, 13 Apr 2008 21:02:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, mingo@elte.hu, akpm@linux-foundation.org,
       hch@infradead.org, mmlnx@us.ibm.com, dipankar@in.ibm.com,
       dsmith@redhat.com, rostedt@goodmis.org, adrian.bunk@movial.fi,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, rusty@au1.ibm.com, jkenisto@linux.vnet.ibm.com,
       oleg@tv-sign.ru, jamesclhuang@yahoo.com
Subject: [PATCH 3/5] Add rcu_barrier_sched() and rcu_barrier_bh()
Message-ID: <20080414040235.GC30495@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080414035848.GA30005@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414035848.GA30005@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add rcu_barrier_sched() and rcu_barrier_bh().  With these in place,
rcutorture no longer gives the occasional oops when repeatedly starting
and stopping torturing rcu_bh.  Also adds the API needed to flush out
pre-existing call_rcu_sched() callbacks.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---

 include/linux/rcupdate.h |    2 +
 kernel/rcupdate.c        |   55 +++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 51 insertions(+), 6 deletions(-)

diff -urpNa -X dontdiff linux-2.6.25-rc6-C2-rcuclassic-fixes/include/linux/rcupdate.h linux-2.6.25-rc6-C3-rcu_barrier_sched/include/linux/rcupdate.h
--- linux-2.6.25-rc6-C2-rcuclassic-fixes/include/linux/rcupdate.h	2008-03-20 21:10:42.000000000 -0700
+++ linux-2.6.25-rc6-C3-rcu_barrier_sched/include/linux/rcupdate.h	2008-04-09 13:40:53.000000000 -0700
@@ -260,6 +260,8 @@ extern void call_rcu_bh(struct rcu_head 
 /* Exported common interfaces */
 extern void synchronize_rcu(void);
 extern void rcu_barrier(void);
+extern void rcu_barrier_bh(void);
+extern void rcu_barrier_sched(void);
 extern long rcu_batches_completed(void);
 extern long rcu_batches_completed_bh(void);
 
diff -urpNa -X dontdiff linux-2.6.25-rc6-C2-rcuclassic-fixes/kernel/rcupdate.c linux-2.6.25-rc6-C3-rcu_barrier_sched/kernel/rcupdate.c
--- linux-2.6.25-rc6-C2-rcuclassic-fixes/kernel/rcupdate.c	2008-03-20 21:10:39.000000000 -0700
+++ linux-2.6.25-rc6-C3-rcu_barrier_sched/kernel/rcupdate.c	2008-04-09 13:54:53.000000000 -0700
@@ -45,6 +45,12 @@
 #include <linux/mutex.h>
 #include <linux/module.h>
 
+enum rcu_barrier {
+	RCU_BARRIER_STD,
+	RCU_BARRIER_BH,
+	RCU_BARRIER_SCHED,
+};
+
 static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
 static atomic_t rcu_barrier_cpu_count;
 static DEFINE_MUTEX(rcu_barrier_mutex);
@@ -83,19 +89,30 @@ static void rcu_barrier_callback(struct 
 /*
  * Called with preemption disabled, and from cross-cpu IRQ context.
  */
-static void rcu_barrier_func(void *notused)
+static void rcu_barrier_func(void *type)
 {
 	int cpu = smp_processor_id();
 	struct rcu_head *head = &per_cpu(rcu_barrier_head, cpu);
 
 	atomic_inc(&rcu_barrier_cpu_count);
-	call_rcu(head, rcu_barrier_callback);
+	switch ((enum rcu_barrier)type) {
+	case RCU_BARRIER_STD:
+		call_rcu(head, rcu_barrier_callback);
+		break;
+	case RCU_BARRIER_BH:
+		call_rcu_bh(head, rcu_barrier_callback);
+		break;
+	case RCU_BARRIER_SCHED:
+		call_rcu_sched(head, rcu_barrier_callback);
+		break;
+	}
 }
 
-/**
- * rcu_barrier - Wait until all the in-flight RCUs are complete.
+/*
+ * Orchestrate the specified type of RCU barrier, waiting for all
+ * RCU callbacks of the specified type to complete.
  */
-void rcu_barrier(void)
+static void _rcu_barrier(enum rcu_barrier type)
 {
 	BUG_ON(in_interrupt());
 	/* Take cpucontrol mutex to protect against CPU hotplug */
@@ -111,13 +128,39 @@ void rcu_barrier(void)
 	 * until all the callbacks are queued.
 	 */
 	rcu_read_lock();
-	on_each_cpu(rcu_barrier_func, NULL, 0, 1);
+	on_each_cpu(rcu_barrier_func, (void *)type, 0, 1);
 	rcu_read_unlock();
 	wait_for_completion(&rcu_barrier_completion);
 	mutex_unlock(&rcu_barrier_mutex);
 }
+
+/**
+ * rcu_barrier - Wait until all in-flight call_rcu() callbacks complete.
+ */
+void rcu_barrier(void)
+{
+	_rcu_barrier(RCU_BARRIER_STD);
+}
 EXPORT_SYMBOL_GPL(rcu_barrier);
 
+/**
+ * rcu_barrier_bh - Wait until all in-flight call_rcu_bh() callbacks complete.
+ */
+void rcu_barrier_bh(void)
+{
+	_rcu_barrier(RCU_BARRIER_BH);
+}
+EXPORT_SYMBOL_GPL(rcu_barrier_bh);
+
+/**
+ * rcu_barrier_sched - Wait for in-flight call_rcu_sched() callbacks.
+ */
+void rcu_barrier_sched(void)
+{
+	_rcu_barrier(RCU_BARRIER_SCHED);
+}
+EXPORT_SYMBOL_GPL(rcu_barrier_sched);
+
 void __init rcu_init(void)
 {
 	__rcu_init();
