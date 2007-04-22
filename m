Return-Path: <linux-kernel-owner+w=401wt.eu-S1030932AbXDVOsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030932AbXDVOsA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 10:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030934AbXDVOsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 10:48:00 -0400
Received: from mail11.syd.optusnet.com.au ([211.29.132.192]:52517 "EHLO
	mail11.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030932AbXDVOsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 10:48:00 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Willy Tarreau <w@1wt.eu>
Subject: [PATCH] sched: implement staircase deadline scheduler load weight fix
Date: Mon, 23 Apr 2007 00:47:22 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704230047.23027.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The task load_weight needs to be set every time the quota is set and wasn't
being set in activate_task which assumed it would not have changed. Due to
changes in where the default rr_interval is set on SMP this assumption
failed. Also if one were to change rr_interval on the fly it would break
again.

set_load_weight was unnecessarily complex in the relationship as it could
be simply set to the task_timeslice in milliseconds. It also would not scale
enough to pick up nice 19 tasks and could give them 0 weight with a small
enough rr_interval.

Thanks to Willy Tarreau <w@1wt.eu> for spotting more smp balancing problems.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 kernel/sched.c |   36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

Index: linux-2.6.21-rc7-sd/kernel/sched.c
===================================================================
--- linux-2.6.21-rc7-sd.orig/kernel/sched.c	2007-04-22 21:37:25.000000000 +1000
+++ linux-2.6.21-rc7-sd/kernel/sched.c	2007-04-22 23:04:34.000000000 +1000
@@ -102,8 +102,6 @@ unsigned long long __attribute__((weak))
  */
 int rr_interval __read_mostly = 8;
 
-#define DEF_TIMESLICE		(rr_interval * 20)
-
 /*
  * This contains a bitmap for each dynamic priority level with empty slots
  * for the valid priorities each different nice level can have. It allows
@@ -886,16 +884,11 @@ static int task_timeslice(struct task_st
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
+ * special cased to be proportionately larger than nice -20 by their
+ * rt_priority. The weight for rt tasks can only be arbitrary at best.
+ */
+#define RTPRIO_TO_LOAD_WEIGHT(rp)	(rr_interval * 20 * (40 + rp))
 
 static void set_load_weight(struct task_struct *p)
 {
@@ -912,7 +905,7 @@ static void set_load_weight(struct task_
 #endif
 			p->load_weight = RTPRIO_TO_LOAD_WEIGHT(p->rt_priority);
 	} else
-		p->load_weight = TASK_LOAD_WEIGHT(p);
+		p->load_weight = task_timeslice(p);
 }
 
 static inline void
@@ -995,7 +988,7 @@ static int effective_prio(struct task_st
  * nice -20 = 10 * rr_interval. nice 1-19 = rr_interval / 2.
  * Value returned is in microseconds.
  */
-static unsigned int rr_quota(struct task_struct *p)
+static inline unsigned int rr_quota(struct task_struct *p)
 {
 	int nice = TASK_NICE(p), rr = rr_interval;
 
@@ -1009,6 +1002,13 @@ static unsigned int rr_quota(struct task
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
@@ -1036,7 +1036,7 @@ static void activate_task(struct task_st
 				     (now - p->timestamp) >> 20);
 	}
 
-	p->quota = rr_quota(p);
+	set_quota(p);
 	p->prio = effective_prio(p);
 	p->timestamp = now;
 	__activate_task(p, rq);
@@ -3885,8 +3885,7 @@ void set_user_nice(struct task_struct *p
 	p->static_prio = NICE_TO_PRIO(nice);
 	old_prio = p->prio;
 	p->prio = effective_prio(p);
-	p->quota = rr_quota(p);
-	set_load_weight(p);
+	set_quota(p);
 	delta = p->prio - old_prio;
 
 	if (queued) {
@@ -4020,8 +4019,7 @@ static void __setscheduler(struct task_s
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
