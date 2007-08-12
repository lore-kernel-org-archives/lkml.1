Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbXHLESB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbXHLESB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 00:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750701AbXHLERw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 00:17:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46724 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbXHLERv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 00:17:51 -0400
Date: Sun, 12 Aug 2007 06:17:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Boldi <a1426z@gawab.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Roman Zippel <zippel@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070812041736.GA18291@elte.hu>
References: <200708111344.42934.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708111344.42934.a1426z@gawab.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Boldi <a1426z@gawab.com> wrote:

> That's because granularity increases when decreasing nice, and results 
> in larger timeslices, which affects smoothness negatively.  chew.c 
> easily shows this problem with 2 background cpu-hogs at the same 
> nice-level.
> 
> pid 908, prio   0, out for    8 ms, ran for    4 ms, load  37%
> pid 908, prio   0, out for    8 ms, ran for    4 ms, load  37%
> pid 908, prio   0, out for    8 ms, ran for    2 ms, load  26%
> pid 908, prio   0, out for    8 ms, ran for    4 ms, load  38%
> pid 908, prio   0, out for    2 ms, ran for    1 ms, load  47%
> 
> pid 908, prio  -5, out for   23 ms, ran for    3 ms, load  14%
> pid 908, prio  -5, out for   17 ms, ran for    9 ms, load  35%

yeah. Incidentally, i refined this last week and those nice-level 
granularity changes went into the upstream scheduler code a few days 
ago:

  commit 7cff8cf61cac15fa29a1ca802826d2bcbca66152
  Author: Ingo Molnar <mingo@elte.hu>
  Date:   Thu Aug 9 11:16:52 2007 +0200

      sched: refine negative nice level granularity

      refine the granularity of negative nice level tasks: let them
      reschedule more often to offset the effect of them consuming
      their wait_runtime proportionately slower. (This makes nice-0
      task scheduling smoother in the presence of negatively
      reniced tasks.)

      Signed-off-by: Ingo Molnar <mingo@elte.hu>

so could you please re-check chew jitter behavior with the latest 
kernel? (i've attached the standalone patch below, it will apply cleanly 
to rc2 too.)

when testing this, you might also want to try chew-max:

   http://redhat.com/~mingo/cfs-scheduler/tools/chew-max.c

i added a few trivial enhancements to chew.c: it tracks the maximum 
latency, latency fluctuations (noise of scheduling) and allows it to be 
run for a fixed amount of time.

NOTE: if you run chew from any indirect terminal (xterm, ssh, etc.) it's 
best to capture/report chew numbers like this:

  ./chew-max 60 > chew.log

otherwise the indirect scheduling activities of the chew printout will 
disturb the numbers.

> It looks like the larger the granularity, the more unpredictable it 
> gets, which probably means that this unpredictability exists even at 
> smaller granularity but is only exposed with larger ones.

this should only affect non-default nice levels. Note that 99.9%+ of all 
userspace Linux CPU time is spent on default nice level 0, and that is 
what controls the design. So the approach was always to first get nice-0 
right, and then to adjust the non-default nice level behavior too, 
carefully, without hurting nice-0 - to refine all the workloads where 
people (have to) use positive or negative nice levels. In any case, 
please keep re-testing this so that we can adjust it.

	Ingo

--------------------->
commit 7cff8cf61cac15fa29a1ca802826d2bcbca66152
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Aug 9 11:16:52 2007 +0200

    sched: refine negative nice level granularity
    
    refine the granularity of negative nice level tasks: let them
    reschedule more often to offset the effect of them consuming
    their wait_runtime proportionately slower. (This makes nice-0
    task scheduling smoother in the presence of negatively
    reniced tasks.)
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 7a632c5..e91db32 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -222,21 +222,25 @@ niced_granularity(struct sched_entity *curr, unsigned long granularity)
 {
 	u64 tmp;
 
+	if (likely(curr->load.weight == NICE_0_LOAD))
+		return granularity;
 	/*
-	 * Negative nice levels get the same granularity as nice-0:
+	 * Positive nice levels get the same granularity as nice-0:
 	 */
-	if (likely(curr->load.weight >= NICE_0_LOAD))
-		return granularity;
+	if (likely(curr->load.weight < NICE_0_LOAD)) {
+		tmp = curr->load.weight * (u64)granularity;
+		return (long) (tmp >> NICE_0_SHIFT);
+	}
 	/*
-	 * Positive nice level tasks get linearly finer
+	 * Negative nice level tasks get linearly finer
 	 * granularity:
 	 */
-	tmp = curr->load.weight * (u64)granularity;
+	tmp = curr->load.inv_weight * (u64)granularity;
 
 	/*
 	 * It will always fit into 'long':
 	 */
-	return (long) (tmp >> NICE_0_SHIFT);
+	return (long) (tmp >> WMULT_SHIFT);
 }
 
 static inline void
