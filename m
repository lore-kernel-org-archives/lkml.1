Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbZBWUnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbZBWUnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 15:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbZBWUng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 15:43:36 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54929 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbZBWUnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 15:43:35 -0500
Date: Mon, 23 Feb 2009 12:43:32 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: vegard.nossum@gmail.com, mingo@elte.hu, stable@kernel.org,
       akpm@linux-foundation.org, npiggin@suse.de, penberg@cs.helsinki.fi
Subject: [PATCH] v2 Teach RCU that idle task is not quiscent state at boot
Message-ID: <20090223204332.GA19861@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090223161611.GA9563@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223161611.GA9563@linux.vnet.ibm.com>
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
the boot sequence.

In addition, this patch takes Nick Piggin's suggestion to make the
system_state global variable be __read_mostly.

Located-by: Vegard Nossum <vegard.nossum@gmail.com>
Tested-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/rcupdate.h |    2 ++
 init/main.c              |    3 ++-
 kernel/rcuclassic.c      |    4 ++--
 kernel/rcupdate.c        |   10 ++++++++++
 kernel/rcutree.c         |    4 ++--
 5 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 921340a..063c67b 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -265,6 +265,8 @@ extern void rcu_barrier_sched(void);
 
 /* Internal to kernel */
 extern void rcu_init(void);
+extern void rcu_idle_now_means_idle(void);
+extern int rcu_idle_cpu_truthful;
 extern int rcu_needs_cpu(int cpu);
 
 #endif /* __LINUX_RCUPDATE_H */
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
index d92a76a..0f85e18 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -55,6 +55,7 @@ static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
 static atomic_t rcu_barrier_cpu_count;
 static DEFINE_MUTEX(rcu_barrier_mutex);
 static struct completion rcu_barrier_completion;
+int rcu_idle_cpu_truthful __read_mostly;
 
 /*
  * Awaken the corresponding synchronize_rcu() instance now that a
@@ -80,6 +81,10 @@ void wakeme_after_rcu(struct rcu_head  *head)
 void synchronize_rcu(void)
 {
 	struct rcu_synchronize rcu;
+
+	if (num_online_cpus() == 1)
+		return;  /* If UP, synchronize_rcu() is a grace period! */
+
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu(&rcu.head, wakeme_after_rcu);
@@ -175,3 +180,8 @@ void __init rcu_init(void)
 	__rcu_init();
 }
 
+void rcu_idle_now_means_idle(void)
+{
+	WARN_ON(num_online_cpus() != 1);
+	rcu_idle_cpu_truthful = 1;
+}
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
