Return-Path: <linux-kernel-owner+w=401wt.eu-S1764889AbZBYP2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764889AbZBYP2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763424AbZBYPZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:25:52 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45484 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761127AbZBYPZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:25:50 -0500
Date: Wed, 25 Feb 2009 06:19:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: vegard.nossum@gmail.com, mingo@elte.hu, stable@kernel.org,
       akpm@linux-foundation.org, npiggin@suse.de, penberg@cs.helsinki.fi
Subject: [PATCH] v4 Teach RCU that idle task is not quiscent state at boot
Message-ID: <20090225141945.GA28455@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090223161611.GA9563@linux.vnet.ibm.com> <20090223204332.GA19861@linux.vnet.ibm.com> <20090225002937.GA23733@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225002937.GA23733@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug located by Vegard Nossum with the aid of
kmemcheck, updated based on review comments from Nick Piggin,
Ingo Molnar, and Andrew Morton.

The boot CPU runs in the context of its idle thread during boot-up.
During this time, idle_cpu(0) will always return nonzero, which will
fool Classic and Hierarchical RCU into deciding that a large chunk of
the boot-up sequence is a big long quiescent state.  This in turn causes
RCU to prematurely end grace periods during this time.

This patch changes the rcutree.c and rcuclassic.c rcu_check_callbacks()
function to ignore the idle task as a quiescent state until the
system has started up the scheduler in rest_init(), introducing a
new non-API function rcu_idle_now_means_idle() to inform RCU of this
transition.  RCU maintains an internal rcu_idle_cpu_truthful variable
to track this state, which is then used by rcu_check_callback() to
determine if it should believe idle_cpu().

Because this patch has the effect of disallowing RCU grace periods
during long stretches of the boot-up sequence, this patch also introduces
Josh Triplett's UP-only optimization that makes synchronize_rcu() be a
no-op if num_online_cpus() returns 1.  This allows boot-time code that
calls synchronize_rcu() to proceed normally.  Note, however, that RCU
callbacks registered by call_rcu() will likely queue up until later in
the boot sequence.  Although rcuclassic and rcutree can also use this
same optimization after boot completes, rcupreempt must restrict its
use of this optimization to the portion of the boot sequence before the
scheduler starts up, given that an rcupreempt RCU read-side critical
section may be preeempted.

In addition, this patch takes Nick Piggin's suggestion to make the
system_state global variable be __read_mostly.

Changes since v3:

o	WARN_ON(nr_context_switches() > 0) to verify that RCU
	switches out of boot-time mode before the first context
	switch, as suggested by Nick Piggin.

Changes since v2:

o	Created rcu_blocking_is_gp() internal-to-RCU API that
	determines whether a call to synchronize_rcu() is itself
	a grace period.

o	The definition of rcu_blocking_is_gp() for rcuclassic and
	rcutree checks to see if but a single CPU is online.

o	The definition of rcu_blocking_is_gp() for rcupreempt
	checks to see both if but a single CPU is online and if
	the system is still in early boot.

	This allows rcupreempt to again work correctly if running
	on a single CPU after booting is complete.

o	Added check to rcupreempt's synchronize_sched() for there
	being but one online CPU.

Tested all three variants both SMP and !SMP, booted fine, passed a short
rcutorture test on both x86 and Power.

Located-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/rcuclassic.h |    6 ++++++
 include/linux/rcupdate.h   |    4 ++++
 include/linux/rcupreempt.h |   15 +++++++++++++++
 include/linux/rcutree.h    |    6 ++++++
 init/main.c                |    3 ++-
 kernel/rcuclassic.c        |    4 ++--
 kernel/rcupdate.c          |   12 ++++++++++++
 kernel/rcupreempt.c        |    3 +++
 kernel/rcutree.c           |    4 ++--
 9 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index f3f697d..80044a4 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -181,4 +181,10 @@ extern long rcu_batches_completed_bh(void);
 #define rcu_enter_nohz()	do { } while (0)
 #define rcu_exit_nohz()		do { } while (0)
 
+/* A context switch is a grace period for rcuclassic. */
+static inline int rcu_blocking_is_gp(void)
+{
+	return num_online_cpus() == 1;
+}
+
 #endif /* __LINUX_RCUCLASSIC_H */
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 921340a..1e5249d 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -52,6 +52,9 @@ struct rcu_head {
 	void (*func)(struct rcu_head *head);
 };
 
+/* Internal to kernel, but needed by rcupreempt.h. */
+extern int rcu_idle_cpu_truthful;
+
 #if defined(CONFIG_CLASSIC_RCU)
 #include <linux/rcuclassic.h>
 #elif defined(CONFIG_TREE_RCU)
@@ -265,6 +268,7 @@ extern void rcu_barrier_sched(void);
 
 /* Internal to kernel */
 extern void rcu_init(void);
+extern void rcu_idle_now_means_idle(void);
 extern int rcu_needs_cpu(int cpu);
 
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
index 3e05c09..504973d 100644
--- a/include/linux/rcupreempt.h
+++ b/include/linux/rcupreempt.h
@@ -142,4 +142,19 @@ static inline void rcu_exit_nohz(void)
 #define rcu_exit_nohz()		do { } while (0)
 #endif /* CONFIG_NO_HZ */
 
+/*
+ * A context switch is a grace period for rcupreempt synchronize_rcu()
+ * only during early boot, before the scheduler has been initialized.
+ * So, how the heck do we get a context switch?  Well, if the caller
+ * invokes synchronize_rcu(), they are willing to accept a context
+ * switch, so we simply pretend that one happened.
+ *
+ * After boot, there might be a blocked or preempted task in an RCU
+ * read-side critical section, so we cannot then take the fastpath.
+ */
+static inline int rcu_blocking_is_gp(void)
+{
+	return num_online_cpus() == 1 && !rcu_idle_cpu_truthful;
+}
+
 #endif /* __LINUX_RCUPREEMPT_H */
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index d4368b7..a722fb6 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -326,4 +326,10 @@ static inline void rcu_exit_nohz(void)
 }
 #endif /* CONFIG_NO_HZ */
 
+/* A context switch is a grace period for rcutree. */
+static inline int rcu_blocking_is_gp(void)
+{
+	return num_online_cpus() == 1;
+}
+
 #endif /* __LINUX_RCUTREE_H */
diff --git a/init/main.c b/init/main.c
index 8442094..b952287 100644
--- a/init/main.c
+++ b/init/main.c
@@ -97,7 +97,7 @@ static inline void mark_rodata_ro(void) { }
 extern void tc_init(void);
 #endif
 
-enum system_states system_state;
+enum system_states system_state __read_mostly;
 EXPORT_SYMBOL(system_state);
 
 /*
@@ -463,6 +463,7 @@ static noinline void __init_refok rest_init(void)
 	 * at least once to get things moving:
 	 */
 	init_idle_bootup_task(current);
+	rcu_idle_now_means_idle();
 	preempt_enable_no_resched();
 	schedule();
 	preempt_disable();
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index bd5a900..b4377de 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -679,8 +679,8 @@ int rcu_needs_cpu(int cpu)
 void rcu_check_callbacks(int cpu, int user)
 {
 	if (user ||
-	    (idle_cpu(cpu) && !in_softirq() &&
-				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
+	    (idle_cpu(cpu) && rcu_idle_cpu_truthful &&
+	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
 
 		/*
 		 * Get here if this CPU took its interrupt from user
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index d92a76a..ace4fd4 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -44,6 +44,7 @@
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
+#include <linux/kernel_stat.h>
 
 enum rcu_barrier {
 	RCU_BARRIER_STD,
@@ -55,6 +56,7 @@ static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
 static atomic_t rcu_barrier_cpu_count;
 static DEFINE_MUTEX(rcu_barrier_mutex);
 static struct completion rcu_barrier_completion;
+int rcu_idle_cpu_truthful __read_mostly;
 
 /*
  * Awaken the corresponding synchronize_rcu() instance now that a
@@ -80,6 +82,10 @@ void wakeme_after_rcu(struct rcu_head  *head)
 void synchronize_rcu(void)
 {
 	struct rcu_synchronize rcu;
+
+	if (rcu_blocking_is_gp())
+		return;
+
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu(&rcu.head, wakeme_after_rcu);
@@ -175,3 +181,9 @@ void __init rcu_init(void)
 	__rcu_init();
 }
 
+void rcu_idle_now_means_idle(void)
+{
+	WARN_ON(num_online_cpus() != 1);
+	WARN_ON(nr_context_switches() > 0);
+	rcu_idle_cpu_truthful = 1;
+}
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 33cfc50..5d59e85 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -1181,6 +1181,9 @@ void __synchronize_sched(void)
 {
 	struct rcu_synchronize rcu;
 
+	if (num_online_cpus() == 1)
+		return;  /* blocking is gp if only one CPU! */
+
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu_sched(&rcu.head, wakeme_after_rcu);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index b2fd602..b37a7b1 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -948,8 +948,8 @@ static void rcu_do_batch(struct rcu_data *rdp)
 void rcu_check_callbacks(int cpu, int user)
 {
 	if (user ||
-	    (idle_cpu(cpu) && !in_softirq() &&
-				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
+	    (idle_cpu(cpu) && rcu_idle_cpu_truthful &&
+	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
 
 		/*
 		 * Get here if this CPU took its interrupt from user
