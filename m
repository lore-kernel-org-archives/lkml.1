Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbZDNKBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbZDNKBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbZDNKBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:01:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:45727 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbZDNKBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:01:21 -0400
Date: Tue, 14 Apr 2009 10:00:36 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, anton@au1.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, anton@au1.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <12396834793575-git-send-email->
References: <12396834793575-git-send-email->
Subject: [tip:core/rcu] rcu: Make hierarchical RCU less IPI-happy
Message-ID: <tip-ef631b0ca01655d24e9ca7e199262c4a46416a26@git.kernel.org>
Git-Commit-ID: ef631b0ca01655d24e9ca7e199262c4a46416a26
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 10:00:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef631b0ca01655d24e9ca7e199262c4a46416a26
Gitweb:     http://git.kernel.org/tip/ef631b0ca01655d24e9ca7e199262c4a46416a26
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 13 Apr 2009 21:31:16 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 14 Apr 2009 11:31:50 +0200

rcu: Make hierarchical RCU less IPI-happy

This patch fixes a hierarchical-RCU performance bug located by Anton
Blanchard.  The problem stems from a misguided attempt to provide a
work-around for jiffies-counter failure.  This work-around uses a per-CPU
n_rcu_pending counter, which is incremented on each call to rcu_pending(),
which in turn is called from each scheduling-clock interrupt.  Each CPU
then treats this counter as a surrogate for the jiffies counter, so
that if the jiffies counter fails to advance, the per-CPU n_rcu_pending
counter will cause RCU to invoke force_quiescent_state(), which in turn
will (among other things) send resched IPIs to CPUs that have thus far
failed to pass through an RCU quiescent state.

Unfortunately, each CPU resets only its own counter after sending a
batch of IPIs.  This means that the other CPUs will also (needlessly)
send -another- round of IPIs, for a full N-squared set of IPIs in the
worst case every three scheduler-clock ticks until the grace period
finally ends.  It is not reasonable for a given CPU to reset each and
every n_rcu_pending for all the other CPUs, so this patch instead simply
disables the jiffies-counter "training wheels", thus eliminating the
excessive IPIs.

Note that the jiffies-counter IPIs do not have this problem due to
the fact that the jiffies counter is global, so that the CPU sending
the IPIs can easily reset things, thus preventing the other CPUs from
sending redundant IPIs.

Note also that the n_rcu_pending counter remains, as it will continue to
be used for tracing.  It may also see use to update the jiffies counter,
should an appropriate kick-the-jiffies-counter API appear.

Located-by: Anton Blanchard <anton@au1.ibm.com>
Tested-by: Anton Blanchard <anton@au1.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: anton@samba.org
Cc: akpm@linux-foundation.org
Cc: dipankar@in.ibm.com
Cc: manfred@colorfullife.com
Cc: cl@linux-foundation.org
Cc: josht@linux.vnet.ibm.com
Cc: schamp@sgi.com
Cc: niv@us.ibm.com
Cc: dvhltc@us.ibm.com
Cc: ego@in.ibm.com
Cc: laijs@cn.fujitsu.com
Cc: rostedt@goodmis.org
Cc: peterz@infradead.org
Cc: penberg@cs.helsinki.fi
Cc: andi@firstfloor.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
LKML-Reference: <12396834793575-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/rcutree.h |    3 +--
 kernel/rcutree.c        |   19 ++++---------------
 kernel/rcutree_trace.c  |   14 +++++---------
 3 files changed, 10 insertions(+), 26 deletions(-)

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
