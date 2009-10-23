Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbZJWOxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbZJWOxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 10:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbZJWOxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 10:53:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50246 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbZJWOxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 10:53:37 -0400
Date: Fri, 23 Oct 2009 16:53:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20091023145326.GA12564@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Darren Hart (2):
      futex: Check for NULL keys in match_futex
      futex: Move drop_futex_key_refs out of spinlock'ed region

Paul E. McKenney (3):
      rcu: Prevent RCU IPI storms in presence of high call_rcu() load
      rcu: Stopgap fix for synchronize_rcu_expedited() for TREE_PREEMPT_RCU
      rcu: Fix TREE_PREEMPT_RCU CPU_HOTPLUG bad-luck hang

Thomas Gleixner (1):
      futex: Handle spurious wake up


 include/linux/rcutree.h |    6 +-----
 kernel/futex.c          |   24 +++++++++++++++++++-----
 kernel/rcutree.c        |   44 ++++++++++++++++++++++++++++++++++++++------
 kernel/rcutree.h        |   10 +++++++---
 kernel/rcutree_plugin.h |   46 ++++++++++++++++++++++++++++++++++++++--------
 5 files changed, 103 insertions(+), 27 deletions(-)

diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 46e9ab3..9642c6b 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -76,11 +76,7 @@ static inline void __rcu_read_unlock_bh(void)
 
 extern void call_rcu_sched(struct rcu_head *head,
 			   void (*func)(struct rcu_head *rcu));
-
-static inline void synchronize_rcu_expedited(void)
-{
-	synchronize_sched_expedited();
-}
+extern void synchronize_rcu_expedited(void);
 
 static inline void synchronize_rcu_bh_expedited(void)
 {
diff --git a/kernel/futex.c b/kernel/futex.c
index 4949d33..642f3bb 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -150,7 +150,8 @@ static struct futex_hash_bucket *hash_futex(union futex_key *key)
  */
 static inline int match_futex(union futex_key *key1, union futex_key *key2)
 {
-	return (key1->both.word == key2->both.word
+	return (key1 && key2
+		&& key1->both.word == key2->both.word
 		&& key1->both.ptr == key2->both.ptr
 		&& key1->both.offset == key2->both.offset);
 }
@@ -1028,7 +1029,6 @@ static inline
 void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
 			   struct futex_hash_bucket *hb)
 {
-	drop_futex_key_refs(&q->key);
 	get_futex_key_refs(key);
 	q->key = *key;
 
@@ -1226,6 +1226,7 @@ retry_private:
 		 */
 		if (ret == 1) {
 			WARN_ON(pi_state);
+			drop_count++;
 			task_count++;
 			ret = get_futex_value_locked(&curval2, uaddr2);
 			if (!ret)
@@ -1304,6 +1305,7 @@ retry_private:
 			if (ret == 1) {
 				/* We got the lock. */
 				requeue_pi_wake_futex(this, &key2, hb2);
+				drop_count++;
 				continue;
 			} else if (ret) {
 				/* -EDEADLK */
@@ -1791,6 +1793,7 @@ static int futex_wait(u32 __user *uaddr, int fshared,
 					     current->timer_slack_ns);
 	}
 
+retry:
 	/* Prepare to wait on uaddr. */
 	ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
 	if (ret)
@@ -1808,9 +1811,14 @@ static int futex_wait(u32 __user *uaddr, int fshared,
 		goto out_put_key;
 
 	/*
-	 * We expect signal_pending(current), but another thread may
-	 * have handled it for us already.
+	 * We expect signal_pending(current), but we might be the
+	 * victim of a spurious wakeup as well.
 	 */
+	if (!signal_pending(current)) {
+		put_futex_key(fshared, &q.key);
+		goto retry;
+	}
+
 	ret = -ERESTARTSYS;
 	if (!abs_time)
 		goto out_put_key;
@@ -2118,9 +2126,11 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 		 */
 		plist_del(&q->list, &q->list.plist);
 
+		/* Handle spurious wakeups gracefully */
+		ret = -EAGAIN;
 		if (timeout && !timeout->task)
 			ret = -ETIMEDOUT;
-		else
+		else if (signal_pending(current))
 			ret = -ERESTARTNOINTR;
 	}
 	return ret;
@@ -2198,6 +2208,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	debug_rt_mutex_init_waiter(&rt_waiter);
 	rt_waiter.task = NULL;
 
+retry:
 	key2 = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_WRITE);
 	if (unlikely(ret != 0))
@@ -2292,6 +2303,9 @@ out_put_keys:
 out_key2:
 	put_futex_key(fshared, &key2);
 
+	/* Spurious wakeup ? */
+	if (ret == -EAGAIN)
+		goto retry;
 out:
 	if (to) {
 		hrtimer_cancel(&to->timer);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 705f02a..0536125 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -913,7 +913,20 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 			spin_unlock(&rnp->lock); /* irqs remain disabled. */
 			break;
 		}
-		rcu_preempt_offline_tasks(rsp, rnp, rdp);
+
+		/*
+		 * If there was a task blocking the current grace period,
+		 * and if all CPUs have checked in, we need to propagate
+		 * the quiescent state up the rcu_node hierarchy.  But that
+		 * is inconvenient at the moment due to deadlock issues if
+		 * this should end the current grace period.  So set the
+		 * offlined CPU's bit in ->qsmask in order to force the
+		 * next force_quiescent_state() invocation to clean up this
+		 * mess in a deadlock-free manner.
+		 */
+		if (rcu_preempt_offline_tasks(rsp, rnp, rdp) && !rnp->qsmask)
+			rnp->qsmask |= mask;
+
 		mask = rnp->grpmask;
 		spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 		rnp = rnp->parent;
@@ -958,7 +971,7 @@ static void rcu_offline_cpu(int cpu)
  * Invoke any RCU callbacks that have made it to the end of their grace
  * period.  Thottle as specified by rdp->blimit.
  */
-static void rcu_do_batch(struct rcu_data *rdp)
+static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long flags;
 	struct rcu_head *next, *list, **tail;
@@ -1011,6 +1024,13 @@ static void rcu_do_batch(struct rcu_data *rdp)
 	if (rdp->blimit == LONG_MAX && rdp->qlen <= qlowmark)
 		rdp->blimit = blimit;
 
+	/* Reset ->qlen_last_fqs_check trigger if enough CBs have drained. */
+	if (rdp->qlen == 0 && rdp->qlen_last_fqs_check != 0) {
+		rdp->qlen_last_fqs_check = 0;
+		rdp->n_force_qs_snap = rsp->n_force_qs;
+	} else if (rdp->qlen < rdp->qlen_last_fqs_check - qhimark)
+		rdp->qlen_last_fqs_check = rdp->qlen;
+
 	local_irq_restore(flags);
 
 	/* Re-raise the RCU softirq if there are callbacks remaining. */
@@ -1224,7 +1244,7 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 	}
 
 	/* If there are callbacks ready, invoke them. */
-	rcu_do_batch(rdp);
+	rcu_do_batch(rsp, rdp);
 }
 
 /*
@@ -1288,10 +1308,20 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 		rcu_start_gp(rsp, nestflag);  /* releases rnp_root->lock. */
 	}
 
-	/* Force the grace period if too many callbacks or too long waiting. */
-	if (unlikely(++rdp->qlen > qhimark)) {
+	/*
+	 * Force the grace period if too many callbacks or too long waiting.
+	 * Enforce hysteresis, and don't invoke force_quiescent_state()
+	 * if some other CPU has recently done so.  Also, don't bother
+	 * invoking force_quiescent_state() if the newly enqueued callback
+	 * is the only one waiting for a grace period to complete.
+	 */
+	if (unlikely(++rdp->qlen > rdp->qlen_last_fqs_check + qhimark)) {
 		rdp->blimit = LONG_MAX;
-		force_quiescent_state(rsp, 0);
+		if (rsp->n_force_qs == rdp->n_force_qs_snap &&
+		    *rdp->nxttail[RCU_DONE_TAIL] != head)
+			force_quiescent_state(rsp, 0);
+		rdp->n_force_qs_snap = rsp->n_force_qs;
+		rdp->qlen_last_fqs_check = rdp->qlen;
 	} else if ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0)
 		force_quiescent_state(rsp, 1);
 	local_irq_restore(flags);
@@ -1523,6 +1553,8 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptable)
 	rdp->beenonline = 1;	 /* We have now been online. */
 	rdp->preemptable = preemptable;
 	rdp->passed_quiesc_completed = lastcomp - 1;
+	rdp->qlen_last_fqs_check = 0;
+	rdp->n_force_qs_snap = rsp->n_force_qs;
 	rdp->blimit = blimit;
 	spin_unlock(&rnp->lock);		/* irqs remain disabled. */
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index b40ac57..1823c6e 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -167,6 +167,10 @@ struct rcu_data {
 	struct rcu_head *nxtlist;
 	struct rcu_head **nxttail[RCU_NEXT_SIZE];
 	long		qlen;		/* # of queued callbacks */
+	long		qlen_last_fqs_check;
+					/* qlen at last check for QS forcing */
+	unsigned long	n_force_qs_snap;
+					/* did other CPU force QS recently? */
 	long		blimit;		/* Upper limit on a processed batch */
 
 #ifdef CONFIG_NO_HZ
@@ -302,9 +306,9 @@ static void rcu_print_task_stall(struct rcu_node *rnp);
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
-static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
-				      struct rcu_node *rnp,
-				      struct rcu_data *rdp);
+static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
+				     struct rcu_node *rnp,
+				     struct rcu_data *rdp);
 static void rcu_preempt_offline_cpu(int cpu);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 static void rcu_preempt_check_callbacks(int cpu);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c0cb783..ef2a58c 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -304,21 +304,25 @@ static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
  * parent is to remove the need for rcu_read_unlock_special() to
  * make more than two attempts to acquire the target rcu_node's lock.
  *
+ * Returns 1 if there was previously a task blocking the current grace
+ * period on the specified rcu_node structure.
+ *
  * The caller must hold rnp->lock with irqs disabled.
  */
-static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
-				      struct rcu_node *rnp,
-				      struct rcu_data *rdp)
+static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
+				     struct rcu_node *rnp,
+				     struct rcu_data *rdp)
 {
 	int i;
 	struct list_head *lp;
 	struct list_head *lp_root;
+	int retval = rcu_preempted_readers(rnp);
 	struct rcu_node *rnp_root = rcu_get_root(rsp);
 	struct task_struct *tp;
 
 	if (rnp == rnp_root) {
 		WARN_ONCE(1, "Last CPU thought to be offlined?");
-		return;  /* Shouldn't happen: at least one CPU online. */
+		return 0;  /* Shouldn't happen: at least one CPU online. */
 	}
 	WARN_ON_ONCE(rnp != rdp->mynode &&
 		     (!list_empty(&rnp->blocked_tasks[0]) ||
@@ -342,6 +346,8 @@ static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
 			spin_unlock(&rnp_root->lock); /* irqs remain disabled */
 		}
 	}
+
+	return retval;
 }
 
 /*
@@ -393,6 +399,17 @@ void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 EXPORT_SYMBOL_GPL(call_rcu);
 
 /*
+ * Wait for an rcu-preempt grace period.  We are supposed to expedite the
+ * grace period, but this is the crude slow compatability hack, so just
+ * invoke synchronize_rcu().
+ */
+void synchronize_rcu_expedited(void)
+{
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
+
+/*
  * Check to see if there is any immediate preemptable-RCU-related work
  * to be done.
  */
@@ -521,12 +538,15 @@ static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
 
 /*
  * Because preemptable RCU does not exist, it never needs to migrate
- * tasks that were blocked within RCU read-side critical sections.
+ * tasks that were blocked within RCU read-side critical sections, and
+ * such non-existent tasks cannot possibly have been blocking the current
+ * grace period.
  */
-static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
-				      struct rcu_node *rnp,
-				      struct rcu_data *rdp)
+static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
+				     struct rcu_node *rnp,
+				     struct rcu_data *rdp)
 {
+	return 0;
 }
 
 /*
@@ -565,6 +585,16 @@ void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 EXPORT_SYMBOL_GPL(call_rcu);
 
 /*
+ * Wait for an rcu-preempt grace period, but make it happen quickly.
+ * But because preemptable RCU does not exist, map to rcu-sched.
+ */
+void synchronize_rcu_expedited(void)
+{
+	synchronize_sched_expedited();
+}
+EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
+
+/*
  * Because preemptable RCU does not exist, it never has any work to do.
  */
 static int rcu_preempt_pending(int cpu)
