Return-Path: <linux-kernel-owner+w=401wt.eu-S1751092AbZGXAUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751092AbZGXAUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 20:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbZGXAUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 20:20:13 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49230 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbZGXAUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 20:20:11 -0400
Date: Thu, 23 Jul 2009 17:20:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org
Subject: [PATCH RFC -tip 2/4] Renamings to increase RCU clarity
Message-ID: <20090724002008.GB18282@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090724001429.GA17374@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090724001429.GA17374@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make RCU-sched, RCU-bh, and RCU-preempt be underlying implementations,
with "RCU" defined in terms of one of the three.  Update the outdated
rcu_qsctr_inc() names, as these functions no longer increment anything.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 Documentation/RCU/trace.txt |    7 +--
 include/linux/rcupdate.h    |   21 +++++++++--
 include/linux/rcupreempt.h  |    4 +-
 include/linux/rcutree.h     |    8 ++--
 kernel/rcupreempt.c         |    8 ++--
 kernel/rcutree.c            |   78 +++++++++++++++++++++++++++-----------------
 kernel/rcutree.h            |    4 +-
 kernel/rcutree_trace.c      |   20 +++++------
 kernel/sched.c              |    2 -
 kernel/softirq.c            |    4 +-
 10 files changed, 94 insertions(+), 62 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 02cced1..187bbf1 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -191,8 +191,7 @@ rcu/rcuhier (which displays the struct rcu_node hierarchy).
 
 The output of "cat rcu/rcudata" looks as follows:
 
-rcu:
-rcu:
+rcu_sched:
   0 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=10951/1 dn=0 df=1101 of=0 ri=36 ql=0 b=10
   1 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=16117/1 dn=0 df=1015 of=0 ri=0 ql=0 b=10
   2 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=1445/1 dn=0 df=1839 of=0 ri=0 ql=0 b=10
@@ -306,7 +305,7 @@ comma-separated-variable spreadsheet format.
 
 The output of "cat rcu/rcugp" looks as follows:
 
-rcu: completed=33062  gpnum=33063
+rcu_sched: completed=33062  gpnum=33063
 rcu_bh: completed=464  gpnum=464
 
 Again, this output is for both "rcu" and "rcu_bh".  The fields are
@@ -413,7 +412,7 @@ o	Each element of the form "1/1 0:127 ^0" represents one struct
 
 The output of "cat rcu/rcu_pending" looks as follows:
 
-rcu:
+rcu_sched:
   0 np=255892 qsp=53936 cbr=0 cng=14417 gpc=10033 gps=24320 nf=6445 nn=146741
   1 np=261224 qsp=54638 cbr=0 cng=25723 gpc=16310 gps=2849 nf=5912 nn=155792
   2 np=237496 qsp=49664 cbr=0 cng=2762 gpc=45478 gps=1762 nf=1201 nn=136629
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 3c89d6a..e920f0f 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -157,17 +157,28 @@ extern int rcu_scheduler_active;
  * - call_rcu_sched() and rcu_barrier_sched()
  * on the write-side to insure proper synchronization.
  */
-#define rcu_read_lock_sched() preempt_disable()
-#define rcu_read_lock_sched_notrace() preempt_disable_notrace()
+static inline void rcu_read_lock_sched(void)
+{
+	preempt_disable();
+}
+static inline void rcu_read_lock_sched_notrace(void)
+{
+	preempt_disable_notrace();
+}
 
 /*
  * rcu_read_unlock_sched - marks the end of a RCU-classic critical section
  *
  * See rcu_read_lock_sched for more information.
  */
-#define rcu_read_unlock_sched() preempt_enable()
-#define rcu_read_unlock_sched_notrace() preempt_enable_notrace()
-
+static inline void rcu_read_unlock_sched(void)
+{
+	preempt_enable();
+}
+static inline void rcu_read_unlock_sched_notrace(void)
+{
+	preempt_enable_notrace();
+}
 
 
 /**
diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
index f164ac9..2963f08 100644
--- a/include/linux/rcupreempt.h
+++ b/include/linux/rcupreempt.h
@@ -40,8 +40,8 @@
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 
-extern void rcu_qsctr_inc(int cpu);
-static inline void rcu_bh_qsctr_inc(int cpu) { }
+extern void rcu_sched_qs(int cpu);
+static inline void rcu_bh_qs(int cpu) { }
 
 /*
  * Someone might want to pass call_rcu_bh as a function pointer.
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index e37d5e2..a0852d0 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -30,8 +30,8 @@
 #ifndef __LINUX_RCUTREE_H
 #define __LINUX_RCUTREE_H
 
-extern void rcu_qsctr_inc(int cpu);
-extern void rcu_bh_qsctr_inc(int cpu);
+extern void rcu_sched_qs(int cpu);
+extern void rcu_bh_qs(int cpu);
 
 extern int rcu_pending(int cpu);
 extern int rcu_needs_cpu(int cpu);
@@ -73,7 +73,8 @@ static inline void __rcu_read_unlock_bh(void)
 
 #define __synchronize_sched() synchronize_rcu()
 
-#define call_rcu_sched(head, func) call_rcu(head, func)
+extern void call_rcu_sched(struct rcu_head *head,
+			   void (*func)(struct rcu_head *rcu));
 
 static inline void synchronize_rcu_expedited(void)
 {
@@ -91,6 +92,7 @@ extern void rcu_restart_cpu(int cpu);
 
 extern long rcu_batches_completed(void);
 extern long rcu_batches_completed_bh(void);
+extern long rcu_batches_completed_sched(void);
 
 static inline void rcu_init_sched(void)
 {
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 4300212..788a7ed 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -159,7 +159,7 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_dyntick_sched, rcu_dyntick_sched
 	.dynticks = 1,
 };
 
-void rcu_qsctr_inc(int cpu)
+void rcu_sched_qs(int cpu)
 {
 	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
 
@@ -967,12 +967,12 @@ void rcu_check_callbacks(int cpu, int user)
 	 * If this CPU took its interrupt from user mode or from the
 	 * idle loop, and this is not a nested interrupt, then
 	 * this CPU has to have exited all prior preept-disable
-	 * sections of code.  So increment the counter to note this.
+	 * sections of code.  So invoke rcu_sched_qs() to note this.
 	 *
 	 * The memory barrier is needed to handle the case where
 	 * writes from a preempt-disable section of code get reordered
 	 * into schedule() by this CPU's write buffer.  So the memory
-	 * barrier makes sure that the rcu_qsctr_inc() is seen by other
+	 * barrier makes sure that the rcu_sched_qs() is seen by other
 	 * CPUs to happen after any such write.
 	 */
 
@@ -980,7 +980,7 @@ void rcu_check_callbacks(int cpu, int user)
 	    (idle_cpu(cpu) && !in_softirq() &&
 	     hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
 		smp_mb();	/* Guard against aggressive schedule(). */
-	     	rcu_qsctr_inc(cpu);
+	     	rcu_sched_qs(cpu);
 	}
 
 	rcu_check_mb(cpu);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e4b5d01..47817f7 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -74,26 +74,25 @@ EXPORT_SYMBOL_GPL(rcu_lock_map);
 	.n_force_qs_ngp = 0, \
 }
 
-struct rcu_state rcu_state = RCU_STATE_INITIALIZER(rcu_state);
-DEFINE_PER_CPU(struct rcu_data, rcu_data);
+struct rcu_state rcu_sched_state = RCU_STATE_INITIALIZER(rcu_sched_state);
+DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
 
 struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
 /*
- * Increment the quiescent state counter.
- * The counter is a bit degenerated: We do not need to know
+ * Note a quiescent state.  Because we do not need to know
  * how many quiescent states passed, just if there was at least
- * one since the start of the grace period. Thus just a flag.
+ * one since the start of the grace period, this just sets a flag.
  */
-void rcu_qsctr_inc(int cpu)
+void rcu_sched_qs(int cpu)
 {
-	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
+	struct rcu_data *rdp = &per_cpu(rcu_sched_data, cpu);
 	rdp->passed_quiesc = 1;
 	rdp->passed_quiesc_completed = rdp->completed;
 }
 
-void rcu_bh_qsctr_inc(int cpu)
+void rcu_bh_qs(int cpu)
 {
 	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
 	rdp->passed_quiesc = 1;
@@ -114,11 +113,21 @@ static int qlowmark = 100;	/* Once only this many pending, use blimit. */
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
 
 /*
+ * Return the number of RCU-sched batches processed thus far for debug & stats.
+ */
+long rcu_batches_completed_sched(void)
+{
+	return rcu_sched_state.completed;
+}
+EXPORT_SYMBOL_GPL(rcu_batches_completed_sched);
+
+/*
  * Return the number of RCU batches processed thus far for debug & stats.
+ * @@@ placeholder, maps to rcu_batches_completed_sched().
  */
 long rcu_batches_completed(void)
 {
-	return rcu_state.completed;
+	return rcu_batches_completed_sched();
 }
 EXPORT_SYMBOL_GPL(rcu_batches_completed);
 
@@ -310,7 +319,7 @@ void rcu_irq_exit(void)
 	WARN_ON_RATELIMIT(rdtp->dynticks & 0x1, &rcu_rs);
 
 	/* If the interrupt queued a callback, get out of dyntick mode. */
-	if (__get_cpu_var(rcu_data).nxtlist ||
+	if (__get_cpu_var(rcu_sched_data).nxtlist ||
 	    __get_cpu_var(rcu_bh_data).nxtlist)
 		set_need_resched();
 }
@@ -847,7 +856,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	/*
 	 * Move callbacks from the outgoing CPU to the running CPU.
 	 * Note that the outgoing CPU is now quiscent, so it is now
-	 * (uncharacteristically) safe to access it rcu_data structure.
+	 * (uncharacteristically) safe to access its rcu_data structure.
 	 * Note also that we must carefully retain the order of the
 	 * outgoing CPU's callbacks in order for rcu_barrier() to work
 	 * correctly.  Finally, note that we start all the callbacks
@@ -878,7 +887,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
  */
 static void rcu_offline_cpu(int cpu)
 {
-	__rcu_offline_cpu(cpu, &rcu_state);
+	__rcu_offline_cpu(cpu, &rcu_sched_state);
 	__rcu_offline_cpu(cpu, &rcu_bh_state);
 }
 
@@ -973,17 +982,16 @@ void rcu_check_callbacks(int cpu, int user)
 		 * Get here if this CPU took its interrupt from user
 		 * mode or from the idle loop, and if this is not a
 		 * nested interrupt.  In this case, the CPU is in
-		 * a quiescent state, so count it.
+		 * a quiescent state, so note it.
 		 *
 		 * No memory barrier is required here because both
-		 * rcu_qsctr_inc() and rcu_bh_qsctr_inc() reference
-		 * only CPU-local variables that other CPUs neither
-		 * access nor modify, at least not while the corresponding
-		 * CPU is online.
+		 * rcu_sched_qs() and rcu_bh_qs() reference only CPU-local
+		 * variables that other CPUs neither access nor modify,
+		 * at least not while the corresponding CPU is online.
 		 */
 
-		rcu_qsctr_inc(cpu);
-		rcu_bh_qsctr_inc(cpu);
+		rcu_sched_qs(cpu);
+		rcu_bh_qs(cpu);
 
 	} else if (!in_softirq()) {
 
@@ -991,10 +999,10 @@ void rcu_check_callbacks(int cpu, int user)
 		 * Get here if this CPU did not take its interrupt from
 		 * softirq, in other words, if it is not interrupting
 		 * a rcu_bh read-side critical section.  This is an _bh
-		 * critical section, so count it.
+		 * critical section, so note it.
 		 */
 
-		rcu_bh_qsctr_inc(cpu);
+		rcu_bh_qs(cpu);
 	}
 	raise_softirq(RCU_SOFTIRQ);
 }
@@ -1172,7 +1180,8 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 	 */
 	smp_mb(); /* See above block comment. */
 
-	__rcu_process_callbacks(&rcu_state, &__get_cpu_var(rcu_data));
+	__rcu_process_callbacks(&rcu_sched_state,
+				&__get_cpu_var(rcu_sched_data));
 	__rcu_process_callbacks(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
 
 	/*
@@ -1229,14 +1238,25 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 }
 
 /*
- * Queue an RCU callback for invocation after a grace period.
+ * Queue an RCU-sched callback for invocation after a grace period.
+ */
+void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
+{
+	__call_rcu(head, func, &rcu_sched_state);
+}
+EXPORT_SYMBOL_GPL(call_rcu_sched);
+
+/*
+ * @@@ Queue an RCU callback for invocation after a grace period.
+ * @@@ Placeholder pending rcutree_plugin.h.
  */
 void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 {
-	__call_rcu(head, func, &rcu_state);
+	call_rcu_sched(head, func);
 }
 EXPORT_SYMBOL_GPL(call_rcu);
 
+
 /*
  * Queue an RCU for invocation after a quicker grace period.
  */
@@ -1309,7 +1329,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
  */
 int rcu_pending(int cpu)
 {
-	return __rcu_pending(&rcu_state, &per_cpu(rcu_data, cpu)) ||
+	return __rcu_pending(&rcu_sched_state, &per_cpu(rcu_sched_data, cpu)) ||
 	       __rcu_pending(&rcu_bh_state, &per_cpu(rcu_bh_data, cpu));
 }
 
@@ -1322,7 +1342,7 @@ int rcu_pending(int cpu)
 int rcu_needs_cpu(int cpu)
 {
 	/* RCU callbacks either ready or pending? */
-	return per_cpu(rcu_data, cpu).nxtlist ||
+	return per_cpu(rcu_sched_data, cpu).nxtlist ||
 	       per_cpu(rcu_bh_data, cpu).nxtlist;
 }
 
@@ -1407,7 +1427,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
 
 static void __cpuinit rcu_online_cpu(int cpu)
 {
-	rcu_init_percpu_data(cpu, &rcu_state);
+	rcu_init_percpu_data(cpu, &rcu_sched_state);
 	rcu_init_percpu_data(cpu, &rcu_bh_state);
 }
 
@@ -1534,8 +1554,8 @@ void __init __rcu_init(void)
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-	rcu_init_one(&rcu_state);
-	RCU_DATA_PTR_INIT(&rcu_state, rcu_data);
+	rcu_init_one(&rcu_sched_state);
+	RCU_DATA_PTR_INIT(&rcu_sched_state, rcu_sched_data);
 	rcu_init_one(&rcu_bh_state);
 	RCU_DATA_PTR_INIT(&rcu_bh_state, rcu_bh_data);
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 7cc830a..0024e5d 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -238,8 +238,8 @@ struct rcu_state {
 /*
  * RCU implementation internal declarations:
  */
-extern struct rcu_state rcu_state;
-DECLARE_PER_CPU(struct rcu_data, rcu_data);
+extern struct rcu_state rcu_sched_state;
+DECLARE_PER_CPU(struct rcu_data, rcu_sched_data);
 
 extern struct rcu_state rcu_bh_state;
 DECLARE_PER_CPU(struct rcu_data, rcu_bh_data);
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 0cb52b8..236c050 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -77,8 +77,8 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 
 static int show_rcudata(struct seq_file *m, void *unused)
 {
-	seq_puts(m, "rcu:\n");
-	PRINT_RCU_DATA(rcu_data, print_one_rcu_data, m);
+	seq_puts(m, "rcu_sched:\n");
+	PRINT_RCU_DATA(rcu_sched_data, print_one_rcu_data, m);
 	seq_puts(m, "rcu_bh:\n");
 	PRINT_RCU_DATA(rcu_bh_data, print_one_rcu_data, m);
 	return 0;
@@ -125,8 +125,8 @@ static int show_rcudata_csv(struct seq_file *m, void *unused)
 	seq_puts(m, "\"dt\",\"dt nesting\",\"dn\",\"df\",");
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_puts(m, "\"of\",\"ri\",\"ql\",\"b\"\n");
-	seq_puts(m, "\"rcu:\"\n");
-	PRINT_RCU_DATA(rcu_data, print_one_rcu_data_csv, m);
+	seq_puts(m, "\"rcu_sched:\"\n");
+	PRINT_RCU_DATA(rcu_sched_data, print_one_rcu_data_csv, m);
 	seq_puts(m, "\"rcu_bh:\"\n");
 	PRINT_RCU_DATA(rcu_bh_data, print_one_rcu_data_csv, m);
 	return 0;
@@ -172,8 +172,8 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 
 static int show_rcuhier(struct seq_file *m, void *unused)
 {
-	seq_puts(m, "rcu:\n");
-	print_one_rcu_state(m, &rcu_state);
+	seq_puts(m, "rcu_sched:\n");
+	print_one_rcu_state(m, &rcu_sched_state);
 	seq_puts(m, "rcu_bh:\n");
 	print_one_rcu_state(m, &rcu_bh_state);
 	return 0;
@@ -194,8 +194,8 @@ static struct file_operations rcuhier_fops = {
 
 static int show_rcugp(struct seq_file *m, void *unused)
 {
-	seq_printf(m, "rcu: completed=%ld  gpnum=%ld\n",
-		   rcu_state.completed, rcu_state.gpnum);
+	seq_printf(m, "rcu_sched: completed=%ld  gpnum=%ld\n",
+		   rcu_sched_state.completed, rcu_sched_state.gpnum);
 	seq_printf(m, "rcu_bh: completed=%ld  gpnum=%ld\n",
 		   rcu_bh_state.completed, rcu_bh_state.gpnum);
 	return 0;
@@ -244,8 +244,8 @@ static void print_rcu_pendings(struct seq_file *m, struct rcu_state *rsp)
 
 static int show_rcu_pending(struct seq_file *m, void *unused)
 {
-	seq_puts(m, "rcu:\n");
-	print_rcu_pendings(m, &rcu_state);
+	seq_puts(m, "rcu_sched:\n");
+	print_rcu_pendings(m, &rcu_sched_state);
 	seq_puts(m, "rcu_bh:\n");
 	print_rcu_pendings(m, &rcu_bh_state);
 	return 0;
diff --git a/kernel/sched.c b/kernel/sched.c
index 9ae80be..8251654 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5302,7 +5302,7 @@ need_resched:
 	preempt_disable();
 	cpu = smp_processor_id();
 	rq = cpu_rq(cpu);
-	rcu_qsctr_inc(cpu);
+	rcu_sched_qs(cpu);
 	prev = rq->curr;
 	switch_count = &prev->nivcsw;
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 3a94905..0aedd87 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -227,7 +227,7 @@ restart:
 				preempt_count() = prev_count;
 			}
 
-			rcu_bh_qsctr_inc(cpu);
+			rcu_bh_qs(cpu);
 		}
 		h++;
 		pending >>= 1;
@@ -659,7 +659,7 @@ static int ksoftirqd(void * __bind_cpu)
 			preempt_enable_no_resched();
 			cond_resched();
 			preempt_disable();
-			rcu_qsctr_inc((long)__bind_cpu);
+			rcu_sched_qs((long)__bind_cpu);
 		}
 		preempt_enable();
 		set_current_state(TASK_INTERRUPTIBLE);
