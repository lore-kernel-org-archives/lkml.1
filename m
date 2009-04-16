Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbZDPGpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbZDPGpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 02:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbZDPGou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 02:44:50 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:43821 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbZDPGou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 02:44:50 -0400
Date: Thu, 16 Apr 2009 12:14:37 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com, Richard Henderson <rth@twiddle.net>,
       Chris Zankel <chris@zankel.net>, Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Tony Luck <tony.luck@intel.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: [v6 PATCH 2/4] timers: Identifying the existing pinned timers
Message-ID: <20090416064437.GC7510@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090416064136.GA7510@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090416064136.GA7510@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-04-16 12:11:36]:

The following pinned hrtimers have been identified and marked:
1)sched_rt_period_timer
2)tick_sched_timer
3)stack_trace_timer_fn

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |    2 +-
 kernel/sched.c                     |    5 +++--
 kernel/time/tick-sched.c           |    7 ++++---
 kernel/trace/trace_sysprof.c       |    3 ++-
 4 files changed, 10 insertions(+), 7 deletions(-)

Index: linux.trees.git/kernel/sched.c
===================================================================
--- linux.trees.git.orig/kernel/sched.c
+++ linux.trees.git/kernel/sched.c
@@ -236,7 +236,7 @@ static void start_rt_bandwidth(struct rt
 
 		now = hrtimer_cb_get_time(&rt_b->rt_period_timer);
 		hrtimer_forward(&rt_b->rt_period_timer, now, rt_b->rt_period);
-		hrtimer_start_expires(&rt_b->rt_period_timer,
+		hrtimer_start_expires_pinned(&rt_b->rt_period_timer,
 				HRTIMER_MODE_ABS);
 	}
 	spin_unlock(&rt_b->rt_runtime_lock);
@@ -1156,7 +1156,8 @@ static __init void init_hrtick(void)
  */
 static void hrtick_start(struct rq *rq, u64 delay)
 {
-	hrtimer_start(&rq->hrtick_timer, ns_to_ktime(delay), HRTIMER_MODE_REL);
+	hrtimer_start_pinned(&rq->hrtick_timer, ns_to_ktime(delay),
+				HRTIMER_MODE_REL);
 }
 
 static inline void init_hrtick(void)
Index: linux.trees.git/kernel/time/tick-sched.c
===================================================================
--- linux.trees.git.orig/kernel/time/tick-sched.c
+++ linux.trees.git/kernel/time/tick-sched.c
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
Index: linux.trees.git/kernel/trace/trace_sysprof.c
===================================================================
--- linux.trees.git.orig/kernel/trace/trace_sysprof.c
+++ linux.trees.git/kernel/trace/trace_sysprof.c
@@ -203,7 +203,8 @@ static void start_stack_timer(void *unus
 	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer->function = stack_trace_timer_fn;
 
-	hrtimer_start(hrtimer, ns_to_ktime(sample_period), HRTIMER_MODE_REL);
+	hrtimer_start_pinned(hrtimer, ns_to_ktime(sample_period),
+				HRTIMER_MODE_REL);
 }
 
 static void start_stack_timers(void)
Index: linux.trees.git/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux.trees.git/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -455,7 +455,7 @@ static void uv_heartbeat(unsigned long i
 	uv_set_scir_bits(bits);
 
 	/* enable next timer period */
-	mod_timer(timer, jiffies + SCIR_CPU_HB_INTERVAL);
+	mod_timer_pinned(timer, jiffies + SCIR_CPU_HB_INTERVAL);
 }
 
 static void __cpuinit uv_heartbeat_enable(int cpu)
