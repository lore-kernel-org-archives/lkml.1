Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab0BMBPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 20:15:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:7366 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab0BMBPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 20:15:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,464,1262592000"; 
   d="scan'208";a="492148334"
Subject: [patch] sched: fix SMT scheduler regression in find_busiest_queue()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, ego@in.ibm.com,
       svaidy@linux.vnet.ibm.com
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 12 Feb 2010 17:14:22 -0800
Message-Id: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PeterZ/Ingo,

Ling Ma and Yanmin reported this SMT scheduler regression which lead to
the condition where both the SMT threads on a core are busy while the
other cores in the same socket are completely idle, causing major
performance regression. I have appended a fix for this. This is
relatively low risk fix and if you agree with both the fix and
risk-assessment, can we please push this to Linus so that we can address
this in 2.6.33.

thanks,
suresh
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: sched: fix SMT scheduler regression in find_busiest_queue()

Fix a SMT scheduler performance regression that is leading to a scenario
where SMT threads in one core are completely idle while both the SMT threads
in another core (on the same socket) are busy.

This is caused by this commit (with the problematic code highlighted)

   commit bdb94aa5dbd8b55e75f5a50b61312fe589e2c2d1
   Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
   Date:   Tue Sep 1 10:34:38 2009 +0200

   sched: Try to deal with low capacity

   @@ -4203,15 +4223,18 @@ find_busiest_queue()
   ...
	for_each_cpu(i, sched_group_cpus(group)) {
   +	unsigned long power = power_of(i);

   ...

   -	wl = weighted_cpuload(i);
   +	wl = weighted_cpuload(i) * SCHED_LOAD_SCALE;
   +	wl /= power;

   -	if (rq->nr_running == 1 && wl > imbalance)
   +	if (capacity && rq->nr_running == 1 && wl > imbalance)
		continue;

On a SMT system, power of the HT logical cpu will be 589 and
the scheduler load imbalance (for scenarios like the one mentioned above)
can be approximately 1024 (SCHED_LOAD_SCALE). The above change of scaling
the weighted load with the power will result in "wl > imbalance" and
ultimately resulting in find_busiest_queue() return NULL, causing
load_balance() to think that the load is well balanced. But infact
one of the tasks can be moved to the idle core for optimal performance.

We don't need to use the weighted load (wl) scaled by the cpu power to
compare with  imabalance. In that condition, we already know there is only a
single task "rq->nr_running == 1" and the comparison between imbalance,
wl is to make sure that we select the correct priority thread which matches
imbalance. So we really need to compare the imabalnce with the original
weighted load of the cpu and not the scaled load.

But in other conditions where we want the most hammered(busiest) cpu, we can
use scaled load to ensure that we consider the cpu power in addition to the
actual load on that cpu, so that we can move the load away from the
guy that is getting most hammered with respect to the actual capacity,
as compared with the rest of the cpu's in that busiest group.

Fix it.

Reported-by: Ma Ling <ling.ma@intel.com>
Initial-Analysis-by: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org [2.6.32.x]
---

diff --git a/kernel/sched.c b/kernel/sched.c
index 3a8fb30..bef5369 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4119,12 +4119,23 @@ find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
 			continue;
 
 		rq = cpu_rq(i);
-		wl = weighted_cpuload(i) * SCHED_LOAD_SCALE;
-		wl /= power;
+		wl = weighted_cpuload(i);
 
+		/*
+		 * When comparing with imbalance, use weighted_cpuload()
+		 * which is not scaled with the cpu power.
+		 */
 		if (capacity && rq->nr_running == 1 && wl > imbalance)
 			continue;
 
+		/*
+ 		 * For the load comparisons with the other cpu's, consider
+ 		 * the weighted_cpuload() scaled with the cpu power, so that
+ 		 * the load can be moved away from the cpu that is potentially
+ 		 * running at a lower capacity.
+ 		 */
+		wl = (wl * SCHED_LOAD_SCALE) / power;
+
 		if (wl > max_load) {
 			max_load = wl;
 			busiest = rq;


