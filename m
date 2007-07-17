Return-Path: <linux-kernel-owner+w=401wt.eu-S933418AbXGQIWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933418AbXGQIWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762830AbXGQIWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:22:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56757 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933151AbXGQIWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:22:06 -0400
Date: Tue, 17 Jul 2007 10:21:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, clameter@sgi.com
Subject: Re: [patch] sched: fix the all pinned logic in
	load_balance_newidle()
Message-ID: <20070717082159.GC17234@elte.hu>
References: <20070716235402.GE3318@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716235402.GE3318@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:

> nr_moved is not the correct check for triggering all pinned logic. Fix 
> the all pinned logic in the case of load_balance_newidle().

indeeed.

i've applied your patch to my queue. (I've done a trivial style change 
to it, see below.)

	Ingo

--------------------->
Subject: sched: fix the all pinned logic in load_balance_newidle()
From: Suresh Siddha <suresh.b.siddha@intel.com>

nr_moved is not the correct check for triggering all pinned logic. Fix
the all pinned logic in the case of load_balance_newidle().

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -2679,6 +2679,7 @@ load_balance_newidle(int this_cpu, struc
 	unsigned long imbalance;
 	int nr_moved = 0;
 	int sd_idle = 0;
+	int all_pinned = 0;
 	cpumask_t cpus = CPU_MASK_ALL;
 
 	/*
@@ -2717,10 +2718,11 @@ redo:
 		double_lock_balance(this_rq, busiest);
 		nr_moved = move_tasks(this_rq, this_cpu, busiest,
 					minus_1_or_zero(busiest->nr_running),
-					imbalance, sd, CPU_NEWLY_IDLE, NULL);
+					imbalance, sd, CPU_NEWLY_IDLE,
+					&all_pinned);
 		spin_unlock(&busiest->lock);
 
-		if (!nr_moved) {
+		if (unlikely(all_pinned)) {
 			cpu_clear(cpu_of(busiest), cpus);
 			if (!cpus_empty(cpus))
 				goto redo;
