Return-Path: <linux-kernel-owner+w=401wt.eu-S1760480AbZDQAvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760480AbZDQAvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbZDQAvC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:51:02 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38164 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbZDQAvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:51:00 -0400
Date: Fri, 17 Apr 2009 02:50:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: [GIT PULL] core fixes
Message-ID: <20090417005053.GA3435@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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
H Hartley Sweeten (1):
      kernel/softirq.c: fix sparse warning

Paul E. McKenney (1):
      rcu: Make hierarchical RCU less IPI-happy


 include/linux/rcutree.h |    3 +--
 kernel/rcutree.c        |   19 ++++---------------
 kernel/rcutree_trace.c  |   14 +++++---------
 kernel/softirq.c        |    4 ++--
 4 files changed, 12 insertions(+), 28 deletions(-)

diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 0cdda00..58b2aa5 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -161,9 +161,8 @@ struct rcu_data {
 	unsigned long offline_fqs;	/* Kicked due to being offline. */
 	unsigned long resched_ipi;	/* Sent a resched IPI. */
 
-	/* 5) state to allow this CPU to force_quiescent_state on others */
+	/* 5) For future __rcu_pending statistics. */
 	long n_rcu_pending;		/* rcu_pending() calls since boot. */
-	long n_rcu_pending_force_qs;	/* when to force quiescent states. */
 
 	int cpu;
 };
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 7f32669..d2a372f 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -530,8 +530,6 @@ static void note_new_gpnum(struct rcu_state *rsp, struct rcu_data *rdp)
 	rdp->qs_pending = 1;
 	rdp->passed_quiesc = 0;
 	rdp->gpnum = rsp->gpnum;
-	rdp->n_rcu_pending_force_qs = rdp->n_rcu_pending +
-				      RCU_JIFFIES_TILL_FORCE_QS;
 }
 
 /*
@@ -578,8 +576,6 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	rsp->gpnum++;
 	rsp->signaled = RCU_GP_INIT; /* Hold off force_quiescent_state. */
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
-	rdp->n_rcu_pending_force_qs = rdp->n_rcu_pending +
-				      RCU_JIFFIES_TILL_FORCE_QS;
 	record_gp_stall_check_time(rsp);
 	dyntick_record_completed(rsp, rsp->completed - 1);
 	note_new_gpnum(rsp, rdp);
@@ -1055,7 +1051,6 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 {
 	unsigned long flags;
 	long lastcomp;
-	struct rcu_data *rdp = rsp->rda[smp_processor_id()];
 	struct rcu_node *rnp = rcu_get_root(rsp);
 	u8 signaled;
 
@@ -1066,16 +1061,13 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		return;	/* Someone else is already on the job. */
 	}
 	if (relaxed &&
-	    (long)(rsp->jiffies_force_qs - jiffies) >= 0 &&
-	    (rdp->n_rcu_pending_force_qs - rdp->n_rcu_pending) >= 0)
+	    (long)(rsp->jiffies_force_qs - jiffies) >= 0)
 		goto unlock_ret; /* no emergency and done recently. */
 	rsp->n_force_qs++;
 	spin_lock(&rnp->lock);
 	lastcomp = rsp->completed;
 	signaled = rsp->signaled;
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
-	rdp->n_rcu_pending_force_qs = rdp->n_rcu_pending +
-				      RCU_JIFFIES_TILL_FORCE_QS;
 	if (lastcomp == rsp->gpnum) {
 		rsp->n_force_qs_ngp++;
 		spin_unlock(&rnp->lock);
@@ -1144,8 +1136,7 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 	 * If an RCU GP has gone long enough, go check for dyntick
 	 * idle CPUs and, if needed, send resched IPIs.
 	 */
-	if ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0 ||
-	    (rdp->n_rcu_pending_force_qs - rdp->n_rcu_pending) < 0)
+	if ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0)
 		force_quiescent_state(rsp, 1);
 
 	/*
@@ -1230,8 +1221,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	if (unlikely(++rdp->qlen > qhimark)) {
 		rdp->blimit = LONG_MAX;
 		force_quiescent_state(rsp, 0);
-	} else if ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0 ||
-		   (rdp->n_rcu_pending_force_qs - rdp->n_rcu_pending) < 0)
+	} else if ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0)
 		force_quiescent_state(rsp, 1);
 	local_irq_restore(flags);
 }
@@ -1290,8 +1280,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	/* Has an RCU GP gone long enough to send resched IPIs &c? */
 	if (ACCESS_ONCE(rsp->completed) != ACCESS_ONCE(rsp->gpnum) &&
-	    ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0 ||
-	     (rdp->n_rcu_pending_force_qs - rdp->n_rcu_pending) < 0))
+	    ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0))
 		return 1;
 
 	/* nothing to do */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 4ee954f..4b1875b 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -49,14 +49,12 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 {
 	if (!rdp->beenonline)
 		return;
-	seq_printf(m, "%3d%cc=%ld g=%ld pq=%d pqc=%ld qp=%d rpfq=%ld rp=%x",
+	seq_printf(m, "%3d%cc=%ld g=%ld pq=%d pqc=%ld qp=%d",
 		   rdp->cpu,
 		   cpu_is_offline(rdp->cpu) ? '!' : ' ',
 		   rdp->completed, rdp->gpnum,
 		   rdp->passed_quiesc, rdp->passed_quiesc_completed,
-		   rdp->qs_pending,
-		   rdp->n_rcu_pending_force_qs - rdp->n_rcu_pending,
-		   (int)(rdp->n_rcu_pending & 0xffff));
+		   rdp->qs_pending);
 #ifdef CONFIG_NO_HZ
 	seq_printf(m, " dt=%d/%d dn=%d df=%lu",
 		   rdp->dynticks->dynticks,
@@ -102,14 +100,12 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 {
 	if (!rdp->beenonline)
 		return;
-	seq_printf(m, "%d,%s,%ld,%ld,%d,%ld,%d,%ld,%ld",
+	seq_printf(m, "%d,%s,%ld,%ld,%d,%ld,%d",
 		   rdp->cpu,
 		   cpu_is_offline(rdp->cpu) ? "\"Y\"" : "\"N\"",
 		   rdp->completed, rdp->gpnum,
 		   rdp->passed_quiesc, rdp->passed_quiesc_completed,
-		   rdp->qs_pending,
-		   rdp->n_rcu_pending_force_qs - rdp->n_rcu_pending,
-		   rdp->n_rcu_pending);
+		   rdp->qs_pending);
 #ifdef CONFIG_NO_HZ
 	seq_printf(m, ",%d,%d,%d,%lu",
 		   rdp->dynticks->dynticks,
@@ -123,7 +119,7 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 
 static int show_rcudata_csv(struct seq_file *m, void *unused)
 {
-	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pqc\",\"pq\",\"rpfq\",\"rp\",");
+	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pqc\",\"pq\",");
 #ifdef CONFIG_NO_HZ
 	seq_puts(m, "\"dt\",\"dt nesting\",\"dn\",\"df\",");
 #endif /* #ifdef CONFIG_NO_HZ */
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 2fecefa..b525dd3 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -472,9 +472,9 @@ void tasklet_kill(struct tasklet_struct *t)
 		printk("Attempt to kill tasklet from interrupt\n");
 
 	while (test_and_set_bit(TASKLET_STATE_SCHED, &t->state)) {
-		do
+		do {
 			yield();
-		while (test_bit(TASKLET_STATE_SCHED, &t->state));
+		} while (test_bit(TASKLET_STATE_SCHED, &t->state));
 	}
 	tasklet_unlock_wait(t);
 	clear_bit(TASKLET_STATE_SCHED, &t->state);
