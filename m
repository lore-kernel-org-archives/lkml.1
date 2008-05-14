Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbYENNfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbYENNfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 09:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758970AbYENNfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 09:35:18 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:55682 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167AbYENNfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 09:35:17 -0400
Date: Wed, 14 May 2008 19:14:14 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
Message-ID: <20080514134414.GA12693@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <1210226013.3453.113.camel@ymzhang> <20080508061125.GC3644@linux.vnet.ibm.com> <20080509155240.GH3612@linux.vnet.ibm.com> <1210556351.3151.2.camel@ymzhang> <20080512023758.GN3612@linux.vnet.ibm.com> <1210563200.3151.10.camel@ymzhang> <20080512045246.GP3612@linux.vnet.ibm.com> <1210568533.3151.13.camel@ymzhang> <1210583090.7402.4.camel@marge.simson.net> <1210584047.6524.12.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210584047.6524.12.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 11:20:47AM +0200, Peter Zijlstra wrote:
> It looks like things like find_busiest_group() just think everything is
> peachy when the imbalance is < 1 task - which with all this grouping
> stuff is not necessarily true.

fwiw, the following hack seems to help bring down regression to ~5%
(b/n 2.6.25 and 2.6.26-rc1 with USER_SCHED):

Also in the patch GROUP_SCALE can probably be less than what I used (and
needs a ifdef GROUP_SCHED) ..

Not-signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>


---
 kernel/sched.c          |    4 ++++
 kernel/sched_fair.c     |   14 +++++---------
 kernel/sched_features.h |    2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

Index: current/kernel/sched.c
===================================================================
--- current.orig/kernel/sched.c
+++ current/kernel/sched.c
@@ -1551,13 +1551,17 @@ static void cpuacct_charge(struct task_s
 static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
 #endif
 
+#define GROUP_SCALE	(2*1024)
+
 static inline void inc_cpu_load(struct rq *rq, unsigned long load)
 {
+	load *= GROUP_SCALE;
 	update_load_add(&rq->load, load);
 }
 
 static inline void dec_cpu_load(struct rq *rq, unsigned long load)
 {
+	load *= GROUP_SCALE;
 	update_load_sub(&rq->load, load);
 }
 
Index: current/kernel/sched_fair.c
===================================================================
--- current.orig/kernel/sched_fair.c
+++ current/kernel/sched_fair.c
@@ -1393,24 +1393,20 @@ load_balance_fair(struct rq *this_rq, in
 		unsigned long this_weight, busiest_weight;
 		long rem_load, max_load, moved_load;
 
+		busiest_weight = tg->cfs_rq[busiest_cpu]->task_weight;
 		/*
 		 * empty group
 		 */
-		if (!aggregate(tg, sd)->task_weight)
+		if (!aggregate(tg, sd)->task_weight || !busiest_weight)
 			continue;
 
 		rem_load = rem_load_move * aggregate(tg, sd)->rq_weight;
 		rem_load /= aggregate(tg, sd)->load + 1;
 
-		this_weight = tg->cfs_rq[this_cpu]->task_weight;
-		busiest_weight = tg->cfs_rq[busiest_cpu]->task_weight;
-
-		imbalance = (busiest_weight - this_weight) / 2;
-
-		if (imbalance < 0)
-			imbalance = busiest_weight;
+		if (!rem_load)
+			continue;
 
-		max_load = max(rem_load, imbalance);
+		max_load = rem_load;
 		moved_load = __load_balance_fair(this_rq, this_cpu, busiest,
 				max_load, sd, idle, all_pinned, this_best_prio,
 				tg->cfs_rq[busiest_cpu]);
Index: current/kernel/sched_features.h
===================================================================
--- current.orig/kernel/sched_features.h
+++ current/kernel/sched_features.h
@@ -6,5 +6,5 @@ SCHED_FEAT(CACHE_HOT_BUDDY, 1)
 SCHED_FEAT(SYNC_WAKEUPS, 1)
 SCHED_FEAT(HRTICK, 1)
 SCHED_FEAT(DOUBLE_TICK, 0)
-SCHED_FEAT(NORMALIZED_SLEEPER, 1)
+SCHED_FEAT(NORMALIZED_SLEEPER, 0)
 SCHED_FEAT(DEADLINE, 1)

-- 
Regards,
vatsa
