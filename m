Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbZBTNAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbZBTNAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 08:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbZBTNAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 08:00:23 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:58316 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbZBTNAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 08:00:22 -0500
Date: Fri, 20 Feb 2009 18:30:05 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de,
       mingo@elte.hu, andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org
Subject: [RFC PATCH 3/4] timers: identifying the existing pinned hrtimers.
Message-ID: <20090220130005.GC19762@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
Mail-Followup-To: linux-kernel@vger.kernel.org,
	linux-pm@lists.linux-foundation.org, a.p.zijlstra@chello.nl,
	ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
	andi@firstfloor.org, venkatesh.pallipadi@intel.com,
	vatsa@linux.vnet.ibm.com, arjan@infradead.org
References: <20090220125516.GB10232@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090220125516.GB10232@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-02-20 18:25:16]:

The following pinned hrtimers have been identified and marked:
1)sched_rt_period_timer
2)tick_sched_timer
3)stack_trace_timer_fn



Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 kernel/sched.c               |    5 +++--
 kernel/time/tick-sched.c     |    7 ++++---
 kernel/trace/trace_sysprof.c |    3 ++-
 3 files changed, 9 insertions(+), 6 deletions(-)

Index: git-2.6/kernel/sched.c
===================================================================
--- git-2.6.orig/kernel/sched.c
+++ git-2.6/kernel/sched.c
@@ -236,7 +236,7 @@ static void start_rt_bandwidth(struct rt
 
 		now = hrtimer_cb_get_time(&rt_b->rt_period_timer);
 		hrtimer_forward(&rt_b->rt_period_timer, now, rt_b->rt_period);
-		hrtimer_start_expires(&rt_b->rt_period_timer,
+		hrtimer_start_expires_pinned(&rt_b->rt_period_timer,
 				HRTIMER_MODE_ABS);
 	}
 	spin_unlock(&rt_b->rt_runtime_lock);
@@ -1129,7 +1129,8 @@ static __init void init_hrtick(void)
  */
 static void hrtick_start(struct rq *rq, u64 delay)
 {
-	hrtimer_start(&rq->hrtick_timer, ns_to_ktime(delay), HRTIMER_MODE_REL);
+	hrtimer_start_pinned(&rq->hrtick_timer, ns_to_ktime(delay),
+				HRTIMER_MODE_REL);
 }
 
 static inline void init_hrtick(void)
Index: git-2.6/kernel/time/tick-sched.c
===================================================================
--- git-2.6.orig/kernel/time/tick-sched.c
+++ git-2.6/kernel/time/tick-sched.c
@@ -348,7 +348,7 @@ void tick_nohz_stop_sched_tick(int inidl
 		ts->idle_expires = expires;
 
 		if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
-			hrtimer_start(&ts->sched_timer, expires,
+			hrtimer_start_pinned(&ts->sched_timer, expires,
 				      HRTIMER_MODE_ABS);
 			/* Check, if the timer was already in the past */
 			if (hrtimer_active(&ts->sched_timer))
@@ -394,7 +394,7 @@ static void tick_nohz_restart(struct tic
 		hrtimer_forward(&ts->sched_timer, now, tick_period);
 
 		if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
-			hrtimer_start_expires(&ts->sched_timer,
+			hrtimer_start_expires_pinned(&ts->sched_timer,
 				      HRTIMER_MODE_ABS);
 			/* Check, if the timer was already in the past */
 			if (hrtimer_active(&ts->sched_timer))
@@ -698,7 +698,8 @@ void tick_setup_sched_timer(void)
 
 	for (;;) {
 		hrtimer_forward(&ts->sched_timer, now, tick_period);
-		hrtimer_start_expires(&ts->sched_timer, HRTIMER_MODE_ABS);
+		hrtimer_start_expires_pinned(&ts->sched_timer,
+						HRTIMER_MODE_ABS);
 		/* Check, if the timer was already in the past */
 		if (hrtimer_active(&ts->sched_timer))
 			break;
Index: git-2.6/kernel/trace/trace_sysprof.c
===================================================================
--- git-2.6.orig/kernel/trace/trace_sysprof.c
+++ git-2.6/kernel/trace/trace_sysprof.c
@@ -203,7 +203,8 @@ static void start_stack_timer(void *unus
 	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer->function = stack_trace_timer_fn;
 
-	hrtimer_start(hrtimer, ns_to_ktime(sample_period), HRTIMER_MODE_REL);
+	hrtimer_start_pinned(hrtimer, ns_to_ktime(sample_period),
+				HRTIMER_MODE_REL);
 }
 
 static void start_stack_timers(void)
