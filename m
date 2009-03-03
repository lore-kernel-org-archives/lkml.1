Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339AbZCCVJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbZCCVJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 16:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbZCCVJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 16:09:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46957 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198AbZCCVJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 16:09:38 -0500
Date: Tue, 3 Mar 2009 22:09:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] RCU fix
Message-ID: <20090303210918.GA31802@elte.hu>
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

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

This fixes a long-existent RCU / scheduler interaction bug 
resulting in long bootup delays (sometimes hangs) that has 
become more prominent in .29 and which has been tracked down 
recently.

I didnt like the fix of adding yet another boot state flag but 
neither of the alternatives looked too appealing either:

    http://lkml.org/lkml/2009/2/25/321

So i went with this one.

But we can clean up this code if anyone has a good idea how to 
do it better. The main source of the fragility is the fact that 
we run the 'idle' thread as the init task for quite some time. 
But we cannot really create a real init task until we have a 
number of core kernel facilities up and running.

 Thanks,

	Ingo

------------------>
Paul E. McKenney (1):
      rcu: Teach RCU that idle task is not quiscent state at boot


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
index 921340a..528343e 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -52,6 +52,9 @@ struct rcu_head {
 	void (*func)(struct rcu_head *head);
 };
 
+/* Internal to kernel, but needed by rcupreempt.h. */
+extern int rcu_scheduler_active;
+
 #if defined(CONFIG_CLASSIC_RCU)
 #include <linux/rcuclassic.h>
 #elif defined(CONFIG_TREE_RCU)
@@ -265,6 +268,7 @@ extern void rcu_barrier_sched(void);
 
 /* Internal to kernel */
 extern void rcu_init(void);
+extern void rcu_scheduler_starting(void);
 extern int rcu_needs_cpu(int cpu);
 
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
index 3e05c09..74304b4 100644
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
+	return num_online_cpus() == 1 && !rcu_scheduler_active;
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
index 8442094..83697e1 100644
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
+	rcu_scheduler_starting();
 	preempt_enable_no_resched();
 	schedule();
 	preempt_disable();
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index bd5a900..654c640 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -679,8 +679,8 @@ int rcu_needs_cpu(int cpu)
 void rcu_check_callbacks(int cpu, int user)
 {
 	if (user ||
-	    (idle_cpu(cpu) && !in_softirq() &&
-				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
+	    (idle_cpu(cpu) && rcu_scheduler_active &&
+	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
 
 		/*
 		 * Get here if this CPU took its interrupt from user
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index d92a76a..cae8a05 100644
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
+int rcu_scheduler_active __read_mostly;
 
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
 
+void rcu_scheduler_starting(void)
+{
+	WARN_ON(num_online_cpus() != 1);
+	WARN_ON(nr_context_switches() > 0);
+	rcu_scheduler_active = 1;
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
index b2fd602..97ce315 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -948,8 +948,8 @@ static void rcu_do_batch(struct rcu_data *rdp)
 void rcu_check_callbacks(int cpu, int user)
 {
 	if (user ||
-	    (idle_cpu(cpu) && !in_softirq() &&
-				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
+	    (idle_cpu(cpu) && rcu_scheduler_active &&
+	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
 
 		/*
 		 * Get here if this CPU took its interrupt from user
