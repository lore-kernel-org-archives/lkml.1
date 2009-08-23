Return-Path: <linux-kernel-owner+w=401wt.eu-S933281AbZHWJDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281AbZHWJDi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 05:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932792AbZHWJDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 05:03:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:36995 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932937AbZHWJDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 05:03:35 -0400
Date: Sun, 23 Aug 2009 09:02:56 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <125097461311-git-send-email->
References: <125097461311-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Simplify rcu_pending()/rcu_check_callbacks() API
Message-ID: <tip-a157229cabd6dd8cfa82525fc9bf730c94cc9ac2@git.kernel.org>
Git-Commit-ID: a157229cabd6dd8cfa82525fc9bf730c94cc9ac2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 23 Aug 2009 09:02:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a157229cabd6dd8cfa82525fc9bf730c94cc9ac2
Gitweb:     http://git.kernel.org/tip/a157229cabd6dd8cfa82525fc9bf730c94cc9ac2
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sat, 22 Aug 2009 13:56:51 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 23 Aug 2009 10:32:39 +0200

rcu: Simplify rcu_pending()/rcu_check_callbacks() API

All calls from outside RCU are of the form:

	if (rcu_pending(cpu))
		rcu_check_callbacks(cpu, user);

This is silly, instead we put a call to rcu_pending() in
rcu_check_callbacks(), and then make the outside calls be to
rcu_check_callbacks().  This cuts down on the code a bit and
also gives the compiler a better chance of optimizing.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josht@linux.vnet.ibm.com
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
LKML-Reference: <125097461311-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/ia64/xen/time.c       |    3 +--
 include/linux/rcupreempt.h |    1 -
 include/linux/rcutree.h    |    1 -
 kernel/rcupreempt.c        |   10 ++++++++--
 kernel/rcutree.c           |    5 ++++-
 kernel/timer.c             |    3 +--
 6 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/ia64/xen/time.c b/arch/ia64/xen/time.c
index fb83326..dbeadb9 100644
--- a/arch/ia64/xen/time.c
+++ b/arch/ia64/xen/time.c
@@ -133,8 +133,7 @@ consider_steal_time(unsigned long new_itm)
 		account_idle_ticks(blocked);
 		run_local_timers();
 
-		if (rcu_pending(cpu))
-			rcu_check_callbacks(cpu, user_mode(get_irq_regs()));
+		rcu_check_callbacks(cpu, user_mode(get_irq_regs()));
 
 		scheduler_tick();
 		run_posix_cpu_timers(p);
diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
index 6c9dd9c..aff4772 100644
--- a/include/linux/rcupreempt.h
+++ b/include/linux/rcupreempt.h
@@ -66,7 +66,6 @@ extern void call_rcu_sched(struct rcu_head *head,
 
 extern void __rcu_read_lock(void);
 extern void __rcu_read_unlock(void);
-extern int rcu_pending(int cpu);
 extern int rcu_needs_cpu(int cpu);
 
 #define __rcu_read_lock_bh()	{ rcu_read_lock(); local_bh_disable(); }
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 8a0222c..c739d90 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -33,7 +33,6 @@
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 
-extern int rcu_pending(int cpu);
 extern int rcu_needs_cpu(int cpu);
 
 static inline void __rcu_read_lock(void)
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 7d777c9..0053ce5 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -159,6 +159,8 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_dyntick_sched, rcu_dyntick_sched
 	.dynticks = 1,
 };
 
+static int rcu_pending(int cpu);
+
 void rcu_sched_qs(int cpu)
 {
 	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
@@ -961,7 +963,10 @@ static void rcu_check_mb(int cpu)
 void rcu_check_callbacks(int cpu, int user)
 {
 	unsigned long flags;
-	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
+	struct rcu_data *rdp;
+
+	if (!rcu_pending(cpu))
+		return; /* if nothing for RCU to do. */
 
 	/*
 	 * If this CPU took its interrupt from user mode or from the
@@ -976,6 +981,7 @@ void rcu_check_callbacks(int cpu, int user)
 	 * CPUs to happen after any such write.
 	 */
 
+	rdp = RCU_DATA_CPU(cpu);
 	if (user ||
 	    (idle_cpu(cpu) && !in_softirq() &&
 	     hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
@@ -1382,7 +1388,7 @@ int rcu_needs_cpu(int cpu)
 		rdp->waitschedlist != NULL);
 }
 
-int rcu_pending(int cpu)
+static int rcu_pending(int cpu)
 {
 	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 7c51508..4ce3adc 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -111,6 +111,7 @@ static int qhimark = 10000;	/* If this many pending, ignore blimit. */
 static int qlowmark = 100;	/* Once only this many pending, use blimit. */
 
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
+static int rcu_pending(int cpu);
 
 /*
  * Return the number of RCU-sched batches processed thus far for debug & stats.
@@ -974,6 +975,8 @@ static void rcu_do_batch(struct rcu_data *rdp)
  */
 void rcu_check_callbacks(int cpu, int user)
 {
+	if (!rcu_pending(cpu))
+		return; /* if nothing for RCU to do. */
 	if (user ||
 	    (idle_cpu(cpu) && rcu_scheduler_active &&
 	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
@@ -1329,7 +1332,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
  * by the current CPU, returning 1 if so.  This function is part of the
  * RCU implementation; it is -not- an exported member of the RCU API.
  */
-int rcu_pending(int cpu)
+static int rcu_pending(int cpu)
 {
 	return __rcu_pending(&rcu_sched_state, &per_cpu(rcu_sched_data, cpu)) ||
 	       __rcu_pending(&rcu_bh_state, &per_cpu(rcu_bh_data, cpu));
diff --git a/kernel/timer.c b/kernel/timer.c
index a7f07d5..a3d25f4 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1156,8 +1156,7 @@ void update_process_times(int user_tick)
 	/* Note: this timer irq context must be accounted for as well. */
 	account_process_tick(p, user_tick);
 	run_local_timers();
-	if (rcu_pending(cpu))
-		rcu_check_callbacks(cpu, user_tick);
+	rcu_check_callbacks(cpu, user_tick);
 	printk_tick();
 	scheduler_tick();
 	run_posix_cpu_timers(p);
