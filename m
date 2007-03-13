Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbXCMPdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbXCMPdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030700AbXCMPdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:33:16 -0400
Received: from mail24.syd.optusnet.com.au ([211.29.133.165]:37460 "EHLO
	mail24.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753272AbXCMPdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:33:14 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Al Boldi <a1426z@gawab.com>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] [RSDL-0.30] sched: rsdl improve latencies with differential nice
Date: Wed, 14 Mar 2007 02:31:27 +1100
User-Agent: KMail/1.9.5
Cc: ck list <ck@vds.kolivas.org>, linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703121553.30462.kernel@kolivas.org> <200703121426.00854.a1426z@gawab.com>
In-Reply-To: <200703121426.00854.a1426z@gawab.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3045
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200703140231.28314.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007 22:26, Al Boldi wrote:
> I think, it should be possible to spread this max expiration latency across
> the rotation, should it not?

Can you try the attached patch please Al and Mike? It "dithers" the priority
bitmap which tends to fluctuate the latency a lot more but in a cyclical
fashion. This tends to make the max latency bound to a smaller value and
should make it possible to run -nice tasks without killing the latency of the
non niced tasks. Eg you could possibly run X nice -10 at a guess like we used
to in 2.4 days. It's not essential of course, but is a workaround for Mike's
testcase.

Thanks.

---
Modify the priority bitmaps of different nice levels to be dithered
minimising the latency likely when different nice levels are used. This
allows low cpu using relatively niced tasks to still get low latency in the
presence of less niced tasks.

Fix the accounting on -nice levels to not be scaled by HZ.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 kernel/sched.c |   69 +++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 45 insertions(+), 24 deletions(-)

Index: linux-2.6.21-rc3-mm2/kernel/sched.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/kernel/sched.c	2007-03-13 23:17:29.000000000 +1100
+++ linux-2.6.21-rc3-mm2/kernel/sched.c	2007-03-14 02:20:37.000000000 +1100
@@ -89,24 +89,34 @@ unsigned long long __attribute__((weak))
 #define SCHED_PRIO(p)		((p)+MAX_RT_PRIO)
 #define MAX_DYN_PRIO		(MAX_PRIO + PRIO_RANGE)
 
-/*
- * Preemption needs to take into account that a low priority task can be
- * at a higher prio due to list merging. Its priority is artificially
- * elevated and it should be preempted if anything higher priority wakes up
- * provided it is not a realtime comparison.
- */
-#define TASK_PREEMPTS_CURR(p, curr) \
-	(((p)->prio < (curr)->prio) || (!rt_task(p) && \
-		((p)->static_prio < (curr)->static_prio && \
-			((curr)->static_prio > (curr)->prio))))
+#define TASK_PREEMPTS_CURR(p, curr)	((p)->prio < (curr)->prio)
 
 /*
  * This is the time all tasks within the same priority round robin.
  * Set to a minimum of 6ms.
  */
-#define RR_INTERVAL		((6 * HZ / 1001) + 1)
+#define __RR_INTERVAL		6
+#define RR_INTERVAL		((__RR_INTERVAL * HZ / 1001) + 1)
 #define DEF_TIMESLICE		(RR_INTERVAL * 20)
 
+/*
+ * This contains a bitmap for each dynamic priority level with empty slots
+ * for the valid priorities each different nice level can have. It allows
+ * us to stagger the slots where differing priorities run in a way that
+ * keeps latency differences between different nice levels at a minimum.
+ * ie, where 0 means a slot for that priority, priority running from left to
+ * right:
+ * nice -20 0000000000000000000000000000000000000000
+ * nice -10 1001000100100010001001000100010010001000
+ * nice   0 1010101010101010101010101010101010101010
+ * nice   5 1101011010110101101011010110101101011011
+ * nice  10 1101110110111011101101110111011011101110
+ * nice  15 1111101111110111111011111011111101111110
+ * nice  19 1111111111111111111011111111111111111111
+  */
+static unsigned long prio_matrix[PRIO_RANGE][BITS_TO_LONGS(PRIO_RANGE)]
+				__read_mostly;
+
 #ifdef CONFIG_SMP
 /*
  * Divide a load by a sched group cpu_power : (load / sg->__cpu_power)
@@ -649,15 +659,6 @@ static inline int task_queued(struct tas
 static inline void set_task_entitlement(struct task_struct *p)
 {
 	__set_bit(USER_PRIO(p->prio), p->bitmap);
-
-	/*
-	 * In the case this task has been part of a merged list that has
-	 * made it to higher priority than it should be, we remove the
-	 * quota from its own priority since it will get a quota at this
-	 * priority.
-	 */
-	if (p->normal_prio < p->static_prio)
-		__set_bit(USER_PRIO(p->static_prio), p->bitmap);
 	p->time_slice = p->quota;
 }
 
@@ -705,7 +706,8 @@ static void dequeue_task(struct task_str
  */
 static inline void task_new_array(struct task_struct *p, struct rq *rq)
 {
-	bitmap_zero(p->bitmap, PRIO_RANGE);
+	bitmap_copy(p->bitmap, prio_matrix[USER_PRIO(p->static_prio)],
+		    PRIO_RANGE);
 	p->rotation = rq->prio_rotation;
 }
 
@@ -833,11 +835,12 @@ static void requeue_task(struct task_str
  */
 static inline unsigned int task_timeslice(struct task_struct *p)
 {
-	unsigned int slice, rr;
+	unsigned int slice;
 
-	slice = rr = p->quota;
+	slice = p->quota;
 	if (likely(!rt_task(p)))
-		slice += (PRIO_RANGE - 1 - TASK_USER_PRIO(p)) * rr;
+		slice += (PRIO_RANGE - 1 - TASK_USER_PRIO(p)) *
+			__RR_INTERVAL / HZ;
 	return slice;
 }
 
@@ -7066,6 +7069,24 @@ void __init sched_init(void)
 	int i, j, k;
 	int highest_cpu = 0;
 
+	for (i = 0; i < PRIO_RANGE; i++) {
+		if (i < 20) {
+			bitmap_zero(prio_matrix[i] , PRIO_RANGE);
+			j = PRIO_RANGE * PRIO_RANGE / (i + 1);
+			for (k = j; k < PRIO_RANGE * PRIO_RANGE; k += j)
+				__set_bit(k / PRIO_RANGE, prio_matrix[i]);
+		} else if (i == 20) {
+			bitmap_fill(prio_matrix[i], PRIO_RANGE);
+			for (k = 1; k < PRIO_RANGE; k += 2)
+				__clear_bit(k, prio_matrix[i]);
+		} else {
+			bitmap_fill(prio_matrix[i], PRIO_RANGE);
+			j = PRIO_RANGE * PRIO_RANGE / (PRIO_RANGE - i + 1);
+			for (k = j; k < PRIO_RANGE * PRIO_RANGE; k += j)
+				__clear_bit(k / PRIO_RANGE, prio_matrix[i]);
+		}
+	}
+
 	for_each_possible_cpu(i) {
 		struct prio_array *array;
 		struct rq *rq;

-- 
-ck
