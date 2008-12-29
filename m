Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbYL2WJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbYL2WJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 17:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbYL2WJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 17:09:21 -0500
Received: from mx04.mailboxcop.com ([206.125.223.74]:41421 "EHLO
	mx04.mailboxcop.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbYL2WJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 17:09:20 -0500
Message-ID: <49594B08.8070004@jaysonking.com>
Date: Mon, 29 Dec 2008 16:11:20 -0600
From: Jayson King <dev@jaysonking.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: problem with "sched: revert back to per-rq vruntime"?
References: <495948E0.8040502@jaysonking.com>
In-Reply-To: <495948E0.8040502@jaysonking.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Canit-CHI2: 0.50
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, outgoing)
X-Spam-Score: 0.10 () [Hold at 5.20] RDNS_NONE,2(1.2),6947(-1.2)
X-CanItPRO-Stream: outgoing (inherits from default)
X-Canit-Stats-ID: 332638412 - 8b7a8ff71898
X-Antispam-Training-Forget: http://mailboxcop.com/canit/b.php?i=332638412&m=8b7a8ff71898&c=f
X-Antispam-Training-Nonspam: http://mailboxcop.com/canit/b.php?i=332638412&m=8b7a8ff71898&c=n
X-Antispam-Training-Spam: http://mailboxcop.com/canit/b.php?i=332638412&m=8b7a8ff71898&c=s
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the patch I refer to:

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 17 Oct 2008 17:27:04 +0000 (+0200)
Subject: sched: revert back to per-rq vruntime
X-Git-Tag: v2.6.28-rc1~43^2~1
X-Git-Url: http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git;a=commitdiff_plain;h=f9c0b0950d5fd8c8c5af39bc061f27ea8fddcac3

sched: revert back to per-rq vruntime

Vatsa rightly points out that having the runqueue weight in the vruntime
calculations can cause unfairness in the face of task joins/leaves.

Suppose: dv = dt * rw / w

Then take 10 tasks t_n, each of similar weight. If the first will run 1
then its vruntime will increase by 10. Now, if the next 8 tasks leave after
having run their 1, then the last task will get a vruntime increase of 2
after having run 1.

Which will leave us with 2 tasks of equal weight and equal runtime, of which
one will not be scheduled for 8/2=4 units of time.

Ergo, we cannot do that and must use: dv = dt / w.

This means we cannot have a global vruntime based on effective priority, but
must instead go back to the vruntime per rq model we started out with.

This patch was lightly tested by doing starting while loops on each nice level
and observing their execution time, and a simple group scenario of 1:2:3 pinned
to a single cpu.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0c4bcac..a0aa38b 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -336,7 +336,7 @@ int sched_nr_latency_handler(struct ctl_table *table, int write,
 #endif
 
 /*
- * delta *= w / rw
+ * delta *= P[w / rw]
  */
 static inline unsigned long
 calc_delta_weight(unsigned long delta, struct sched_entity *se)
@@ -350,15 +350,13 @@ calc_delta_weight(unsigned long delta, struct sched_entity *se)
 }
 
 /*
- * delta *= rw / w
+ * delta /= w
  */
 static inline unsigned long
 calc_delta_fair(unsigned long delta, struct sched_entity *se)
 {
-	for_each_sched_entity(se) {
-		delta = calc_delta_mine(delta,
-				cfs_rq_of(se)->load.weight, &se->load);
-	}
+	if (unlikely(se->load.weight != NICE_0_LOAD))
+		delta = calc_delta_mine(delta, NICE_0_LOAD, &se->load);
 
 	return delta;
 }
@@ -388,26 +386,26 @@ static u64 __sched_period(unsigned long nr_running)
  * We calculate the wall-time slice from the period by taking a part
  * proportional to the weight.
  *
- * s = p*w/rw
+ * s = p*P[w/rw]
  */
 static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	return calc_delta_weight(__sched_period(cfs_rq->nr_running), se);
+	unsigned long nr_running = cfs_rq->nr_running;
+
+	if (unlikely(!se->on_rq))
+		nr_running++;
+
+	return calc_delta_weight(__sched_period(nr_running), se);
 }
 
 /*
  * We calculate the vruntime slice of a to be inserted task
  *
- * vs = s*rw/w = p
+ * vs = s/w
  */
-static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	unsigned long nr_running = cfs_rq->nr_running;
-
-	if (!se->on_rq)
-		nr_running++;
-
-	return __sched_period(nr_running);
+	return calc_delta_fair(sched_slice(cfs_rq, se), se);
 }
 
 /*
@@ -629,7 +627,7 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	 * stays open at the end.
 	 */
 	if (initial && sched_feat(START_DEBIT))
-		vruntime += sched_vslice_add(cfs_rq, se);
+		vruntime += sched_vslice(cfs_rq, se);
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */



