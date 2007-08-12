Return-Path: <linux-kernel-owner+w=401wt.eu-S936930AbXHLPxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936930AbXHLPxb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763257AbXHLPxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:53:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58267 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935301AbXHLPxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:53:08 -0400
Date: Sun, 12 Aug 2007 17:52:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Boldi <a1426z@gawab.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Roman Zippel <zippel@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070812155242.GA1977@elte.hu>
References: <200708111344.42934.a1426z@gawab.com> <20070812041736.GA18291@elte.hu> <200708121827.36656.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708121827.36656.a1426z@gawab.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Boldi <a1426z@gawab.com> wrote:

> > so could you please re-check chew jitter behavior with the latest 
> > kernel? (i've attached the standalone patch below, it will apply 
> > cleanly to rc2 too.)
> 
> That fixes it, but by reducing granularity ctx is up 4-fold.

ok, great! (the context-switch rate is obviously up.)

> Mind you, it does have an enormous effect on responsiveness, as 
> negative nice with small granularity can't hijack the system any more.

ok. i'm glad you like the result :-) This makes reniced X (or any 
reniced app) more usable.

> The thing is, this unpredictability seems to exist even at nice level 
> 0, but the smaller granularity covers it all up.  It occasionally 
> exhibits itself as hick-ups during transient heavy workload flux.  But 
> it's not easily reproducible.

In general, "hickups" can be due to many, many reasons. If a task got 
indeed delayed by scheduling jitter that is provable, even if the 
behavior is hard to reproduce, by enabling CONFIG_SCHED_DEBUG=y and 
CONFIG_SCHEDSTATS=y in your kernel. First clear all the stats:

  for N in /proc/*/task/*/sched; do echo 0 > $N; done

then wait for the 'hickup' to happen, and once it happens capture the 
system state (after the hickup) via this script:

  http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

and tell me which specific task exhibited that 'hickup' and send me the 
debug output. Also, could you try the patch below as well? Thanks,

	Ingo

-------------------------------->
Subject: sched: fix sleeper bonus
From: Ingo Molnar <mingo@elte.hu>

Peter Ziljstra noticed that the sleeper bonus deduction code
was not properly rate-limited: a task that scheduled more
frequently would get a disproportionately large deduction.
So limit the deduction to delta_exec.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -75,7 +75,7 @@ enum {
 
 unsigned int sysctl_sched_features __read_mostly =
 		SCHED_FEAT_FAIR_SLEEPERS	*1 |
-		SCHED_FEAT_SLEEPER_AVG		*1 |
+		SCHED_FEAT_SLEEPER_AVG		*0 |
 		SCHED_FEAT_SLEEPER_LOAD_AVG	*1 |
 		SCHED_FEAT_PRECISE_CPU_LOAD	*1 |
 		SCHED_FEAT_START_DEBIT		*1 |
@@ -304,11 +304,9 @@ __update_curr(struct cfs_rq *cfs_rq, str
 	delta_mine = calc_delta_mine(delta_exec, curr->load.weight, lw);
 
 	if (cfs_rq->sleeper_bonus > sysctl_sched_granularity) {
-		delta = calc_delta_mine(cfs_rq->sleeper_bonus,
-					curr->load.weight, lw);
-		if (unlikely(delta > cfs_rq->sleeper_bonus))
-			delta = cfs_rq->sleeper_bonus;
-
+		delta = min(cfs_rq->sleeper_bonus, (u64)delta_exec);
+		delta = calc_delta_mine(delta, curr->load.weight, lw);
+		delta = min((u64)delta, cfs_rq->sleeper_bonus);
 		cfs_rq->sleeper_bonus -= delta;
 		delta_mine -= delta;
 	}
@@ -521,6 +519,8 @@ static void __enqueue_sleeper(struct cfs
 	 * Track the amount of bonus we've given to sleepers:
 	 */
 	cfs_rq->sleeper_bonus += delta_fair;
+	if (unlikely(cfs_rq->sleeper_bonus > sysctl_sched_runtime_limit))
+		cfs_rq->sleeper_bonus = sysctl_sched_runtime_limit;
 
 	schedstat_add(cfs_rq, wait_runtime, se->wait_runtime);
 }
