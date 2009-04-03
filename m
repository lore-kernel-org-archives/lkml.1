Return-Path: <linux-kernel-owner+w=401wt.eu-S1762692AbZDCKi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762692AbZDCKi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763869AbZDCKhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:37:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:42901 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763846AbZDCKhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:37:08 -0400
Date: Fri, 3 Apr 2009 10:36:23 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237898630.25315.83.camel@penberg-laptop>
References: <1237898630.25315.83.camel@penberg-laptop>
Subject: [tip:tracing/kmemtrace-v2] kmemtrace, rcu: fix rcupreempt.c data structure dependencies
Message-ID: <tip-a979241c532f07c201fe94e0a632107268f02578@git.kernel.org>
Git-Commit-ID: a979241c532f07c201fe94e0a632107268f02578
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Apr 2009 10:36:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a979241c532f07c201fe94e0a632107268f02578
Gitweb:     http://git.kernel.org/tip/a979241c532f07c201fe94e0a632107268f02578
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 25 Mar 2009 16:42:24 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Apr 2009 12:23:04 +0200

kmemtrace, rcu: fix rcupreempt.c data structure dependencies

Impact: cleanup

We want to remove percpu.h from rcupreempt.h, but if we do that
the percpu primitives there wont build anymore. Move them to the
.c file instead.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: paulmck@linux.vnet.ibm.com
LKML-Reference: <1237898630.25315.83.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/rcupreempt.h |   51 +++++++------------------------------------
 kernel/rcupreempt.c        |   48 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 53 insertions(+), 46 deletions(-)

diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
index 74304b4..3eb8fdd 100644
--- a/include/linux/rcupreempt.h
+++ b/include/linux/rcupreempt.h
@@ -40,30 +40,15 @@
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 
-struct rcu_dyntick_sched {
-	int dynticks;
-	int dynticks_snap;
-	int sched_qs;
-	int sched_qs_snap;
-	int sched_dynticks_snap;
-};
-
-DECLARE_PER_CPU(struct rcu_dyntick_sched, rcu_dyntick_sched);
-
-static inline void rcu_qsctr_inc(int cpu)
-{
-	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
-
-	rdssp->sched_qs++;
-}
-#define rcu_bh_qsctr_inc(cpu)
+extern void rcu_qsctr_inc(int cpu);
+static inline void rcu_bh_qsctr_inc(int cpu) { }
 
 /*
  * Someone might want to pass call_rcu_bh as a function pointer.
  * So this needs to just be a rename and not a macro function.
  *  (no parentheses)
  */
-#define call_rcu_bh	 	call_rcu
+#define call_rcu_bh		call_rcu
 
 /**
  * call_rcu_sched - Queue RCU callback for invocation after sched grace period.
@@ -117,30 +102,12 @@ extern struct rcupreempt_trace *rcupreempt_trace_cpu(int cpu);
 struct softirq_action;
 
 #ifdef CONFIG_NO_HZ
-
-static inline void rcu_enter_nohz(void)
-{
-	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
-
-	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
-	__get_cpu_var(rcu_dyntick_sched).dynticks++;
-	WARN_ON_RATELIMIT(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1, &rs);
-}
-
-static inline void rcu_exit_nohz(void)
-{
-	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
-
-	__get_cpu_var(rcu_dyntick_sched).dynticks++;
-	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
-	WARN_ON_RATELIMIT(!(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1),
-				&rs);
-}
-
-#else /* CONFIG_NO_HZ */
-#define rcu_enter_nohz()	do { } while (0)
-#define rcu_exit_nohz()		do { } while (0)
-#endif /* CONFIG_NO_HZ */
+extern void rcu_enter_nohz(void);
+extern void rcu_exit_nohz(void);
+#else
+# define rcu_enter_nohz()	do { } while (0)
+# define rcu_exit_nohz()	do { } while (0)
+#endif
 
 /*
  * A context switch is a grace period for rcupreempt synchronize_rcu()
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 5d59e85..ce97a4d 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -147,7 +147,51 @@ struct rcu_ctrlblk {
 	wait_queue_head_t sched_wq;	/* Place for rcu_sched to sleep. */
 };
 
+struct rcu_dyntick_sched {
+	int dynticks;
+	int dynticks_snap;
+	int sched_qs;
+	int sched_qs_snap;
+	int sched_dynticks_snap;
+};
+
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_dyntick_sched, rcu_dyntick_sched) = {
+	.dynticks = 1,
+};
+
+void rcu_qsctr_inc(int cpu)
+{
+	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
+
+	rdssp->sched_qs++;
+}
+
+#ifdef CONFIG_NO_HZ
+
+void rcu_enter_nohz(void)
+{
+	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
+
+	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
+	__get_cpu_var(rcu_dyntick_sched).dynticks++;
+	WARN_ON_RATELIMIT(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1, &rs);
+}
+
+void rcu_exit_nohz(void)
+{
+	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
+
+	__get_cpu_var(rcu_dyntick_sched).dynticks++;
+	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
+	WARN_ON_RATELIMIT(!(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1),
+				&rs);
+}
+
+#endif /* CONFIG_NO_HZ */
+
+
 static DEFINE_PER_CPU(struct rcu_data, rcu_data);
+
 static struct rcu_ctrlblk rcu_ctrlblk = {
 	.fliplock = __SPIN_LOCK_UNLOCKED(rcu_ctrlblk.fliplock),
 	.completed = 0,
@@ -427,10 +471,6 @@ static void __rcu_advance_callbacks(struct rcu_data *rdp)
 	}
 }
 
-DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_dyntick_sched, rcu_dyntick_sched) = {
-	.dynticks = 1,
-};
-
 #ifdef CONFIG_NO_HZ
 static DEFINE_PER_CPU(int, rcu_update_flag);
 
