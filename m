Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbZIPP5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbZIPP5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758306AbZIPP5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:57:18 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54943 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbZIPP5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:57:17 -0400
Date: Wed, 16 Sep 2009 08:57:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: RCU callbacks and TREE_PREEMPT_RCU
Message-ID: <20090916155719.GA10588@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1253110641.31751.92.camel@pc1117.cambridge.arm.com> <20090916152929.GA6737@linux.vnet.ibm.com> <1253115255.31751.96.camel@pc1117.cambridge.arm.com> <20090916154716.GC6737@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916154716.GC6737@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 08:47:16AM -0700, Paul E. McKenney wrote:
> On Wed, Sep 16, 2009 at 04:34:15PM +0100, Catalin Marinas wrote:
> > On Wed, 2009-09-16 at 08:29 -0700, Paul E. McKenney wrote:
> > > On Wed, Sep 16, 2009 at 03:17:21PM +0100, Catalin Marinas wrote:
> > > > When TREE_PREEMPT_RCU is enabled, the rcu list traversing above fails
> > > > with access to 0x6b6b6b6b but it is fine with TREE_PREEMPT_RCU=n and
> > > > TREE_RCU=y. During clean-up, kmemleak objects should no longer be freed
> > > > by other means since kmemleak was disabled and all callbacks are
> > > > ignored. The system is a 900Mhz P3, 256MB RAM, CONFIG_SMP=n.
> > > > 
> > > > Is there something I'm doing wrong in kmemleak or a bug with RCU
> > > > preemption? The kernel oops looks like this:
> > > 
> > > From your description and the code above, I must suspect a bug with
> > > RCU preemption.  A new one, as the only bugs I am currently chasing
> > > involve NR_CPUS>32 (>64 on 64-bit systems).
> > > 
> > > CONFIG_SMP=n implies NR_CPUS==1 in your build, correct?
> > 
> > CONFIG_NR_CPUS=1.
> 
> I was afraid of that.  ;-)

PS to previous -- there -is- a bug in mainline for TREE_PREEMPT_RCU for
single-CPU operation, but it is with synchronize_rcu() rather than
call_rcu().  The fix is in tip/core/urgent, commit #366b04ca.  Or see
the following patch.

So, could you please give the following patch a try?

							Thanx, Paul

Commit-ID:  366b04ca60c70479e2959fe8485b87ff380fdbbf
Gitweb:     http://git.kernel.org/tip/366b04ca60c70479e2959fe8485b87ff380fdbbf
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sun, 13 Sep 2009 09:15:11 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 08:43:59 +0200

rcu: Fix synchronize_rcu() for TREE_PREEMPT_RCU

The redirection of synchronize_sched() to synchronize_rcu() was
appropriate for TREE_RCU, but not for TREE_PREEMPT_RCU.

Fix this by creating an underlying synchronize_sched().  TREE_RCU
then redirects synchronize_rcu() to synchronize_sched(), while
TREE_PREEMPT_RCU has its own version of synchronize_rcu().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
LKML-Reference: <12528585111916-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/rcupdate.h |   23 +++++------------------
 include/linux/rcutree.h  |    4 ++--
 kernel/rcupdate.c        |   44 +++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 50 insertions(+), 21 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 95e0615..39dce83 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -52,8 +52,13 @@ struct rcu_head {
 };

 /* Exported common interfaces */
+#ifdef CONFIG_TREE_PREEMPT_RCU
 extern void synchronize_rcu(void);
+#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#define synchronize_rcu synchronize_sched
+#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 extern void synchronize_rcu_bh(void);
+extern void synchronize_sched(void);
 extern void rcu_barrier(void);
 extern void rcu_barrier_bh(void);
 extern void rcu_barrier_sched(void);
@@ -262,24 +267,6 @@ struct rcu_synchronize {
 extern void wakeme_after_rcu(struct rcu_head  *head);

 /**
- * synchronize_sched - block until all CPUs have exited any non-preemptive
- * kernel code sequences.
- *
- * This means that all preempt_disable code sequences, including NMI and
- * hardware-interrupt handlers, in progress on entry will have completed
- * before this primitive returns.  However, this does not guarantee that
- * softirq handlers will have completed, since in some kernels, these
- * handlers can run in process context, and can block.
- *
- * This primitive provides the guarantees made by the (now removed)
- * synchronize_kernel() API.  In contrast, synchronize_rcu() only
- * guarantees that rcu_read_lock() sections will have completed.
- * In "classic RCU", these two guarantees happen to be one and
- * the same, but can differ in realtime RCU implementations.
- */
-#define synchronize_sched() __synchronize_sched()
-
-/**
  * call_rcu - Queue an RCU callback for invocation after a grace period.
  * @head: structure to be used for queueing the RCU updates.
  * @func: actual update function to be invoked after the grace period
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index a893077..00d08c0 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -53,6 +53,8 @@ static inline void __rcu_read_unlock(void)
 	preempt_enable();
 }

+#define __synchronize_sched() synchronize_rcu()
+
 static inline void exit_rcu(void)
 {
 }
@@ -68,8 +70,6 @@ static inline void __rcu_read_unlock_bh(void)
 	local_bh_enable();
 }

-#define __synchronize_sched() synchronize_rcu()
-
 extern void call_rcu_sched(struct rcu_head *head,
 			   void (*func)(struct rcu_head *rcu));

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index bd5d5c8..28d2f24 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -74,6 +74,8 @@ void wakeme_after_rcu(struct rcu_head  *head)
 	complete(&rcu->completion);
 }

+#ifdef CONFIG_TREE_PREEMPT_RCU
+
 /**
  * synchronize_rcu - wait until a grace period has elapsed.
  *
@@ -87,7 +89,7 @@ void synchronize_rcu(void)
 {
 	struct rcu_synchronize rcu;

-	if (rcu_blocking_is_gp())
+	if (!rcu_scheduler_active)
 		return;

 	init_completion(&rcu.completion);
@@ -98,6 +100,46 @@ void synchronize_rcu(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu);

+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+
+/**
+ * synchronize_sched - wait until an rcu-sched grace period has elapsed.
+ *
+ * Control will return to the caller some time after a full rcu-sched
+ * grace period has elapsed, in other words after all currently executing
+ * rcu-sched read-side critical sections have completed.   These read-side
+ * critical sections are delimited by rcu_read_lock_sched() and
+ * rcu_read_unlock_sched(), and may be nested.  Note that preempt_disable(),
+ * local_irq_disable(), and so on may be used in place of
+ * rcu_read_lock_sched().
+ *
+ * This means that all preempt_disable code sequences, including NMI and
+ * hardware-interrupt handlers, in progress on entry will have completed
+ * before this primitive returns.  However, this does not guarantee that
+ * softirq handlers will have completed, since in some kernels, these
+ * handlers can run in process context, and can block.
+ *
+ * This primitive provides the guarantees made by the (now removed)
+ * synchronize_kernel() API.  In contrast, synchronize_rcu() only
+ * guarantees that rcu_read_lock() sections will have completed.
+ * In "classic RCU", these two guarantees happen to be one and
+ * the same, but can differ in realtime RCU implementations.
+ */
+void synchronize_sched(void)
+{
+	struct rcu_synchronize rcu;
+
+	if (rcu_blocking_is_gp())
+		return;
+
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu_sched(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+}
+EXPORT_SYMBOL_GPL(synchronize_sched);
+
 /**
  * synchronize_rcu_bh - wait until an rcu_bh grace period has elapsed.
  *
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

