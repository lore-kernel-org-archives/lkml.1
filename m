Return-Path: <linux-kernel-owner+w=401wt.eu-S1030371AbXDVMTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030371AbXDVMTb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 08:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030502AbXDVMTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 08:19:31 -0400
Received: from mail34.syd.optusnet.com.au ([211.29.133.218]:49899 "EHLO
	mail34.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030371AbXDVMTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 08:19:30 -0400
From: Con Kolivas <kernel@kolivas.org>
To: ck@vds.kolivas.org, Michael Gerdau <mgd@technosis.de>
Subject: Re: [ck] Re: [ANNOUNCE] Staircase Deadline cpu scheduler version 0.45
Date: Sun, 22 Apr 2007 22:18:32 +1000
User-Agent: KMail/1.9.5
Cc: Willy Tarreau <w@1wt.eu>, Nick Piggin <npiggin@suse.de>,
       Gene Heskett <gene.heskett@gmail.com>, Al Boldi <a1426z@gawab.com>,
       Bill Huey <billh@gnuppy.monkey.org>, Mike Galbraith <efault@gmx.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Matt Mackall <mpm@selenic.com>
References: <200704221441.48897.kernel@kolivas.org> <20070422091451.GA15913@1wt.eu> <200704222142.52325.kernel@kolivas.org>
In-Reply-To: <200704222142.52325.kernel@kolivas.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 4617
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200704222218.32754.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 April 2007 21:42, Con Kolivas wrote:

Willy I'm still investigating the idle time and fluctuating load as a separate 
issue. Is it possible the multiple ocbench processes are naturally 
synchronising and desynchronising and choosing to sleep and/or run at the 
same time? I can remove the idle time entirely by running ocbench at nice 19 
which means they are all forced to run at basically the same time by the 
scheduler.

Anyway the more important part is... Can you test this patch please? Dump
all the other patches I sent you post 045. Michael, if you could test too
please?

Thanks!

---

It appears load weight still wasn't being set in enough places and changing
where rr_interval was being set a few iterations of SD ago might have revealed
that bug. Ensure load_weight is set whenever p->quota is set and simplify
dramatically the load_weight.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 kernel/sched.c |   35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

Index: linux-2.6.21-rc7-sd/kernel/sched.c
===================================================================
--- linux-2.6.21-rc7-sd.orig/kernel/sched.c	2007-04-22 21:37:25.000000000 +1000
+++ linux-2.6.21-rc7-sd/kernel/sched.c	2007-04-22 22:01:48.000000000 +1000
@@ -102,8 +102,6 @@ unsigned long long __attribute__((weak))
  */
 int rr_interval __read_mostly = 8;
 
-#define DEF_TIMESLICE		(rr_interval * 20)
-
 /*
  * This contains a bitmap for each dynamic priority level with empty slots
  * for the valid priorities each different nice level can have. It allows
@@ -886,16 +884,10 @@ static int task_timeslice(struct task_st
 }
 
 /*
- * Assume: static_prio_timeslice(NICE_TO_PRIO(0)) == DEF_TIMESLICE
- * If static_prio_timeslice() is ever changed to break this assumption then
- * this code will need modification. Scaled as multiples of milliseconds.
- */
-#define TIME_SLICE_NICE_ZERO DEF_TIMESLICE
-#define LOAD_WEIGHT(lp) \
-	(((lp) * SCHED_LOAD_SCALE) / TIME_SLICE_NICE_ZERO)
-#define TASK_LOAD_WEIGHT(p)	LOAD_WEIGHT(task_timeslice(p))
-#define RTPRIO_TO_LOAD_WEIGHT(rp)	\
-	(LOAD_WEIGHT((rr_interval + 20 + (rp))))
+ * The load weight is basically the task_timeslice in ms. Realtime tasks are
+ * special cased to be proportionately larger by their rt_priority.
+ */
+#define RTPRIO_TO_LOAD_WEIGHT(rp)	((rr_interval + 20 + (rp)))
 
 static void set_load_weight(struct task_struct *p)
 {
@@ -912,7 +904,7 @@ static void set_load_weight(struct task_
 #endif
 			p->load_weight = RTPRIO_TO_LOAD_WEIGHT(p->rt_priority);
 	} else
-		p->load_weight = TASK_LOAD_WEIGHT(p);
+		p->load_weight = task_timeslice(p);
 }
 
 static inline void
@@ -995,7 +987,7 @@ static int effective_prio(struct task_st
  * nice -20 = 10 * rr_interval. nice 1-19 = rr_interval / 2.
  * Value returned is in microseconds.
  */
-static unsigned int rr_quota(struct task_struct *p)
+static inline unsigned int rr_quota(struct task_struct *p)
 {
 	int nice = TASK_NICE(p), rr = rr_interval;
 
@@ -1009,6 +1001,13 @@ static unsigned int rr_quota(struct task
 	return MS_TO_US(rr);
 }
 
+/* Every time we set the quota we need to set the load weight */
+static void set_quota(struct task_struct *p)
+{
+	p->quota = rr_quota(p);
+	set_load_weight(p);
+}
+
 /*
  * activate_task - move a task to the runqueue and do priority recalculation
  */
@@ -1036,7 +1035,7 @@ static void activate_task(struct task_st
 				     (now - p->timestamp) >> 20);
 	}
 
-	p->quota = rr_quota(p);
+	set_quota(p);
 	p->prio = effective_prio(p);
 	p->timestamp = now;
 	__activate_task(p, rq);
@@ -3885,8 +3884,7 @@ void set_user_nice(struct task_struct *p
 	p->static_prio = NICE_TO_PRIO(nice);
 	old_prio = p->prio;
 	p->prio = effective_prio(p);
-	p->quota = rr_quota(p);
-	set_load_weight(p);
+	set_quota(p);
 	delta = p->prio - old_prio;
 
 	if (queued) {
@@ -4020,8 +4018,7 @@ static void __setscheduler(struct task_s
 	p->normal_prio = normal_prio(p);
 	/* we are holding p->pi_lock already */
 	p->prio = rt_mutex_getprio(p);
-	p->quota = rr_quota(p);
-	set_load_weight(p);
+	set_quota(p);
 }
 
 /**

-- 
-ck
