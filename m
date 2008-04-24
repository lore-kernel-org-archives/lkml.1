Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbYDXWzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbYDXWzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 18:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbYDXWzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 18:55:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60479 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbYDXWzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 18:55:44 -0400
Date: Fri, 25 Apr 2008 00:55:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler/misc fixes
Message-ID: <20080424225530.GA8717@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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


Linus, please pull the latest scheduler/misc fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-fixes.git for-linus

a scheduler fix, a (long-standing) seqlock fix and a softlockup+nohz 
fix.

Thanks,

	Ingo

------------------>
Ingo Molnar (2):
      seqlock: livelock fix
      softlockup: fix NOHZ wakeup

Peter Zijlstra (1):
      sched: fix share (re)distribution

 include/linux/seqlock.h  |   46 ++++++++++++++++++++++++++++----------------
 kernel/sched.c           |   47 +--------------------------------------------
 kernel/time/tick-sched.c |    1 +
 3 files changed, 32 insertions(+), 62 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 26e4925..632205c 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -85,23 +85,29 @@ static inline int write_tryseqlock(seqlock_t *sl)
 /* Start of read calculation -- fetch last complete writer token */
 static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
 {
-	unsigned ret = sl->sequence;
+	unsigned ret;
+
+repeat:
+	ret = sl->sequence;
 	smp_rmb();
+	if (unlikely(ret & 1)) {
+		cpu_relax();
+		goto repeat;
+	}
+
 	return ret;
 }
 
-/* Test if reader processed invalid data.
- * If initial values is odd, 
- *	then writer had already started when section was entered
- * If sequence value changed
- *	then writer changed data while in section
- *    
- * Using xor saves one conditional branch.
+/*
+ * Test if reader processed invalid data.
+ *
+ * If sequence value changed then writer changed data while in section.
  */
-static __always_inline int read_seqretry(const seqlock_t *sl, unsigned iv)
+static __always_inline int read_seqretry(const seqlock_t *sl, unsigned start)
 {
 	smp_rmb();
-	return (iv & 1) | (sl->sequence ^ iv);
+
+	return (sl->sequence != start);
 }
 
 
@@ -122,20 +128,26 @@ typedef struct seqcount {
 /* Start of read using pointer to a sequence counter only.  */
 static inline unsigned read_seqcount_begin(const seqcount_t *s)
 {
-	unsigned ret = s->sequence;
+	unsigned ret;
+
+repeat:
+	ret = s->sequence;
 	smp_rmb();
+	if (unlikely(ret & 1)) {
+		cpu_relax();
+		goto repeat;
+	}
 	return ret;
 }
 
-/* Test if reader processed invalid data.
- * Equivalent to: iv is odd or sequence number has changed.
- *                (iv & 1) || (*s != iv)
- * Using xor saves one conditional branch.
+/*
+ * Test if reader processed invalid data because sequence number has changed.
  */
-static inline int read_seqcount_retry(const seqcount_t *s, unsigned iv)
+static inline int read_seqcount_retry(const seqcount_t *s, unsigned start)
 {
 	smp_rmb();
-	return (iv & 1) | (s->sequence ^ iv);
+
+	return s->sequence != start;
 }
 
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 0014b03..85e1721 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1657,42 +1657,6 @@ void aggregate_group_weight(struct task_group *tg, struct sched_domain *sd)
 }
 
 /*
- * Redistribute tg->shares amongst all tg->cfs_rq[]s.
- */
-static void __aggregate_redistribute_shares(struct task_group *tg)
-{
-	int i, max_cpu = smp_processor_id();
-	unsigned long rq_weight = 0;
-	unsigned long shares, max_shares = 0, shares_rem = tg->shares;
-
-	for_each_possible_cpu(i)
-		rq_weight += tg->cfs_rq[i]->load.weight;
-
-	for_each_possible_cpu(i) {
-		/*
-		 * divide shares proportional to the rq_weights.
-		 */
-		shares = tg->shares * tg->cfs_rq[i]->load.weight;
-		shares /= rq_weight + 1;
-
-		tg->cfs_rq[i]->shares = shares;
-
-		if (shares > max_shares) {
-			max_shares = shares;
-			max_cpu = i;
-		}
-		shares_rem -= shares;
-	}
-
-	/*
-	 * Ensure it all adds up to tg->shares; we can loose a few
-	 * due to rounding down when computing the per-cpu shares.
-	 */
-	if (shares_rem)
-		tg->cfs_rq[max_cpu]->shares += shares_rem;
-}
-
-/*
  * Compute the weight of this group on the given cpus.
  */
 static
@@ -1701,18 +1665,11 @@ void aggregate_group_shares(struct task_group *tg, struct sched_domain *sd)
 	unsigned long shares = 0;
 	int i;
 
-again:
 	for_each_cpu_mask(i, sd->span)
 		shares += tg->cfs_rq[i]->shares;
 
-	/*
-	 * When the span doesn't have any shares assigned, but does have
-	 * tasks to run do a machine wide rebalance (should be rare).
-	 */
-	if (unlikely(!shares && aggregate(tg, sd)->rq_weight)) {
-		__aggregate_redistribute_shares(tg);
-		goto again;
-	}
+	if ((!shares && aggregate(tg, sd)->rq_weight) || shares > tg->shares)
+		shares = tg->shares;
 
 	aggregate(tg, sd)->shares = shares;
 }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d358d4e..b854a89 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -393,6 +393,7 @@ void tick_nohz_restart_sched_tick(void)
 		sub_preempt_count(HARDIRQ_OFFSET);
 	}
 
+	touch_softlockup_watchdog();
 	/*
 	 * Cancel the scheduled timer and restore the tick
 	 */
