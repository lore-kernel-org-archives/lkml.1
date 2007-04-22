Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbXDVDke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbXDVDke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 23:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932231AbXDVDke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 23:40:34 -0400
Received: from mail27.syd.optusnet.com.au ([211.29.133.168]:52261 "EHLO
	mail27.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932192AbXDVDke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 23:40:34 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] sched: implement staircase deadline scheduler ymf accounting fixes
Date: Sun, 22 Apr 2007 13:40:01 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704221340.02349.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This causes significant improvements on SMP hardware. I don't think the kernel
should be -nicing X by itself; that should be a sysadmin choice so I won't
be including that change in the SD patches. The following change will be in
the next release of SD (v0.45).

Andrew Please apply on top of yaf-fix

---
SMP balancing broke on converting time_slice to usecs.

update_cpu_clock is unnecessarily complex and doesn't allow sub usec values.

Thanks to Willy Tarreau <w@1wt.eu> for picking up SMP idle anomalies.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 kernel/sched.c |   42 +++++++++++++++++-------------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

Index: linux-2.6.21-rc7-sd/kernel/sched.c
===================================================================
--- linux-2.6.21-rc7-sd.orig/kernel/sched.c	2007-04-21 22:50:31.000000000 +1000
+++ linux-2.6.21-rc7-sd/kernel/sched.c	2007-04-22 13:29:29.000000000 +1000
@@ -88,12 +88,10 @@ unsigned long long __attribute__((weak))
 #define SCHED_PRIO(p)		((p)+MAX_RT_PRIO)
 
 /* Some helpers for converting to/from various scales.*/
-#define NS_TO_JIFFIES(TIME)	((TIME) / (1000000000 / HZ))
 #define JIFFIES_TO_NS(TIME)	((TIME) * (1000000000 / HZ))
+#define MS_TO_NS(TIME)		((TIME) * 1000000)
 #define MS_TO_US(TIME)		((TIME) * 1000)
-/* Can return 0 */
-#define MS_TO_JIFFIES(TIME)	((TIME) * HZ / 1000)
-#define JIFFIES_TO_MS(TIME)	((TIME) * 1000 / HZ)
+#define US_TO_MS(TIME)		((TIME) / 1000)
 
 #define TASK_PREEMPTS_CURR(p, curr)	((p)->prio < (curr)->prio)
 
@@ -876,29 +874,28 @@ static void requeue_task(struct task_str
 
 /*
  * task_timeslice - the total duration a task can run during one major
- * rotation. Returns value in jiffies.
+ * rotation. Returns value in milliseconds as the smallest value can be 1.
  */
-static inline int task_timeslice(struct task_struct *p)
+static int task_timeslice(struct task_struct *p)
 {
-	int slice;
+	int slice = p->quota;	/* quota is in us */
 
-	slice = NS_TO_JIFFIES(p->quota);
 	if (!rt_task(p))
 		slice += (PRIO_RANGE - 1 - TASK_USER_PRIO(p)) * slice;
-	return slice;
+	return US_TO_MS(slice);
 }
 
 /*
  * Assume: static_prio_timeslice(NICE_TO_PRIO(0)) == DEF_TIMESLICE
  * If static_prio_timeslice() is ever changed to break this assumption then
- * this code will need modification
+ * this code will need modification. Scaled as multiples of milliseconds.
  */
 #define TIME_SLICE_NICE_ZERO DEF_TIMESLICE
 #define LOAD_WEIGHT(lp) \
 	(((lp) * SCHED_LOAD_SCALE) / TIME_SLICE_NICE_ZERO)
 #define TASK_LOAD_WEIGHT(p)	LOAD_WEIGHT(task_timeslice(p))
 #define RTPRIO_TO_LOAD_WEIGHT(rp)	\
-	(LOAD_WEIGHT((MS_TO_JIFFIES(rr_interval) + 20 + (rp))))
+	(LOAD_WEIGHT((rr_interval + 20 + (rp))))
 
 static void set_load_weight(struct task_struct *p)
 {
@@ -3035,32 +3032,27 @@ static void
 update_cpu_clock(struct task_struct *p, struct rq *rq, unsigned long long now,
 		 int tick)
 {
-	cputime64_t time_diff = now - p->last_ran;
-	const unsigned int min_diff = 1000;
-	int us_time_diff;
+	long time_diff = now - p->last_ran;
 
 	if (tick) {
 		/*
 		 * Called from scheduler_tick() there should be less than two
 		 * jiffies worth, and not negative/overflow.
 		 */
-		if (time_diff > JIFFIES_TO_NS(2) || time_diff < min_diff)
+		if (time_diff > JIFFIES_TO_NS(2) || time_diff < 0)
 			time_diff = JIFFIES_TO_NS(1);
 	} else {
 		/*
 		 * Called from context_switch there should be less than one
-		 * jiffy worth, and not negative/overflowed. In the case when
-		 * sched_clock fails to return high resolution values this
-		 * also ensures at least 1 min_diff gets banked.
+		 * jiffy worth, and not negative/overflow. There should be
+		 * some time banked here so use a nominal 1ms.
 		 */
-		if (time_diff > JIFFIES_TO_NS(1) || time_diff < min_diff)
-			time_diff = min_diff;
+		if (time_diff > JIFFIES_TO_NS(1) || time_diff < 1)
+			time_diff = 1000;
 	}
 	/* time_slice accounting is done in usecs to avoid overflow on 32bit */
-	us_time_diff = time_diff;
-	us_time_diff /= 1000;
 	if (p != rq->idle && p->policy != SCHED_FIFO)
-		p->time_slice -= us_time_diff;
+		p->time_slice -= time_diff / 1000;
 	p->sched_time += time_diff;
 	p->last_ran = rq->most_recent_timestamp = now;
 }
@@ -4636,8 +4628,8 @@ long sys_sched_rr_get_interval(pid_t pid
 	if (retval)
 		goto out_unlock;
 
-	jiffies_to_timespec(p->policy == SCHED_FIFO ?
-				0 : task_timeslice(p), &t);
+	t = ns_to_timespec(p->policy == SCHED_FIFO ? 0 :
+			   MS_TO_NS(task_timeslice(p)));
 	read_unlock(&tasklist_lock);
 	retval = copy_to_user(interval, &t, sizeof(t)) ? -EFAULT : 0;
 out_nounlock:

-- 
-ck
