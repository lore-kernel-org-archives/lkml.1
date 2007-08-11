Return-Path: <linux-kernel-owner+w=401wt.eu-S1762329AbXHKAbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762329AbXHKAbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 20:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbXHKAbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 20:31:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35453 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756213AbXHKAbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 20:31:06 -0400
Date: Sat, 11 Aug 2007 02:30:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Willy Tarreau <w@1wt.eu>, Michael Chang <thenewme91@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070811003052.GA18812@elte.hu>
References: <Pine.LNX.4.64.0708011955430.1817@scrub.home> <20070801190556.GA1199@elte.hu> <Pine.LNX.4.64.0708100037460.1817@scrub.home> <20070810054948.GA5908@elte.hu> <Pine.LNX.4.64.0708101459530.1817@scrub.home> <b14e81f00708100954w71e953fcm8a5cca464e4b27df@mail.gmail.com> <Pine.LNX.4.64.0708101919270.1817@scrub.home> <20070810194705.GH6002@1wt.eu> <Pine.LNX.4.64.0708102235320.1817@scrub.home> <20070810213630.GA13910@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810213630.GA13910@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Roman Zippel <zippel@linux-m68k.org> wrote:
> 
> > Well, I've sent him the stuff now...
> 
> received it - thanks alot, looking at it!

everything looks good in your debug output and the TSC dump data, except 
for the wait_runtime values, they are quite out of balance - and that 
balance cannot be explained with jiffies granularity or with any sort of 
sched_clock() artifact. So this clearly looks like a CFS regression that 
should be fixed.

the only relevant thing that comes to mind at the moment is that last 
week Peter noticed a buggy aspect of sleeper bonuses (in that we do not 
rate-limit their output, hence we 'waste' them instead of redistributing 
them), and i've got the small patch below in my queue to fix that - 
could you give it a try?

this is just a blind stab into the dark - i couldnt see any real impact 
from that patch in various workloads (and it's not upstream yet), so it 
might not make a big difference. The trace you did (could you send the 
source for that?) seems to implicate sleeper bonuses though.

if this patch doesnt help, could you check the general theory whether 
it's related to sleeper-fairness, via turning it off:

   echo 30 > /proc/sys/kernel/sched_features

does the bug go away if you do that? If sleeper bonuses are showing too 
many artifacts then we could turn it off for final .23.

	Ingo

--------------------->
Subject: sched: fix sleeper bonus
From: Ingo Molnar <mingo@elte.hu>

Peter Ziljstra noticed that the sleeper bonus deduction code was not 
properly rate-limited: a task that scheduled more frequently would get a 
disproportionately large deduction. So limit the deduction to delta_exec 
and limit production to runtime_limit.

Not-Yet-Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
