Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab0BPOQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 09:16:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:53583 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab0BPOQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:16:29 -0500
Date: Tue, 16 Feb 2010 14:16:01 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, yanmin_zhang@linux.intel.com, ling.ma@intel.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ling.ma@intel.com, a.p.zijlstra@chello.nl, yanmin_zhang@linux.intel.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix SMT scheduler regression in find_busiest_queue()
Message-ID: <tip-9000f05c6d1607f79c0deacf42b09693be673f4c@git.kernel.org>
Git-Commit-ID: 9000f05c6d1607f79c0deacf42b09693be673f4c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Feb 2010 14:16:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9000f05c6d1607f79c0deacf42b09693be673f4c
Gitweb:     http://git.kernel.org/tip/9000f05c6d1607f79c0deacf42b09693be673f4c
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri, 12 Feb 2010 17:14:22 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 16 Feb 2010 15:13:59 +0100

sched: Fix SMT scheduler regression in find_busiest_queue()

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
Cc: stable@kernel.org [2.6.32.x]
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e3199df..4d78aef 100644
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
+		 * For the load comparisons with the other cpu's, consider
+		 * the weighted_cpuload() scaled with the cpu power, so that
+		 * the load can be moved away from the cpu that is potentially
+		 * running at a lower capacity.
+		 */
+		wl = (wl * SCHED_LOAD_SCALE) / power;
+
 		if (wl > max_load) {
 			max_load = wl;
 			busiest = rq;
