Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbXDMOpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbXDMOpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 10:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbXDMOpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 10:45:17 -0400
Received: from mail12.syd.optusnet.com.au ([211.29.132.193]:40474 "EHLO
	mail12.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753638AbXDMOpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 10:45:15 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>
Subject: [PATCH] sched: implement staircase deadline scheduler rework priomatrix
Date: Sat, 14 Apr 2007 00:44:41 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704140044.41816.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rework the priority matrix used by the staircase-deadline cpu scheduler.

Ensuring every nice level uses priority slot 139 means that niced tasks will
not cause expiration prematurely for less niced tasks that have been sleeping.

This also increases the frequency less niced tasks preempt niced tasks, and
simplifies greatly the code that generates the priority matrix.

Update the documentation accordingly and explain why the priority matrix
exists in the first place.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 Documentation/sched-design.txt |   13 +++++++------
 kernel/sched.c                 |   37 ++++++++++++++++---------------------
 2 files changed, 23 insertions(+), 27 deletions(-)

Index: linux-2.6.21-rc6-mm1/kernel/sched.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/kernel/sched.c	2007-04-14 00:25:36.000000000 +1000
+++ linux-2.6.21-rc6-mm1/kernel/sched.c	2007-04-14 00:25:46.000000000 +1000
@@ -113,15 +113,19 @@ int rr_interval __read_mostly;
  * for the valid priorities each different nice level can have. It allows
  * us to stagger the slots where differing priorities run in a way that
  * keeps latency differences between different nice levels at a minimum.
+ * The purpose of a pre-generated matrix is for rapid lookup of next slot in
+ * O(1) time without having to recalculate every time priority gets demoted.
+ * All nice levels use priority slot 39 as this allows less niced tasks to
+ * get all priority slots better than that before expiration is forced.
  * ie, where 0 means a slot for that priority, priority running from left to
- * right:
+ * right is from prio 0 to prio 39:
  * nice -20 0000000000000000000000000000000000000000
- * nice -10 1001000100100010001001000100010010001000
- * nice   0 0101010101010101010101010101010101010101
- * nice   5 1101011010110101101011010110101101011011
- * nice  10 0110111011011101110110111011101101110111
- * nice  15 0111110111111011111101111101111110111111
- * nice  19 1111111111111111111011111111111111111111
+ * nice -10 1000100010001000100010001000100010010000
+ * nice   0 1010101010101010101010101010101010101010
+ * nice   5 1011010110110101101101011011010110110110
+ * nice  10 1110111011101110111011101110111011101110
+ * nice  15 1111111011111110111111101111111011111110
+ * nice  19 1111111111111111111111111111111111111110
  */
 static unsigned long prio_matrix[PRIO_RANGE][BITS_TO_LONGS(PRIO_RANGE)]
 				 __read_mostly;
@@ -6983,20 +6987,11 @@ void __init sched_init(void)
 
 	/* Generate the priority matrix */
 	for (i = 0; i < PRIO_RANGE; i++) {
-		if (i < 20) {
-			bitmap_zero(prio_matrix[i] , PRIO_RANGE);
-			j = PRIO_RANGE * PRIO_RANGE / (i + 1);
-			for (k = j; k < PRIO_RANGE * PRIO_RANGE; k += j)
-				__set_bit(k / PRIO_RANGE, prio_matrix[i]);
-		} else if (i == 20) {
-			bitmap_fill(prio_matrix[i], PRIO_RANGE);
-			for (k = 1; k < PRIO_RANGE; k += 2)
-				__clear_bit(k, prio_matrix[i]);
-		} else {
-			bitmap_fill(prio_matrix[i], PRIO_RANGE);
-			j = PRIO_RANGE * PRIO_RANGE / (PRIO_RANGE - i + 1);
-			for (k = j; k < PRIO_RANGE * PRIO_RANGE; k += j)
-				__clear_bit(k / PRIO_RANGE, prio_matrix[i]);
+		bitmap_fill(prio_matrix[i], PRIO_RANGE);
+		j = PRIO_RANGE * PRIO_RANGE / (PRIO_RANGE - i);
+		for (k = 0; k <= PRIO_RANGE * (PRIO_RANGE - 1); k += j) {
+			__clear_bit(PRIO_RANGE - 1 - (k / PRIO_RANGE),
+				    prio_matrix[i]);
 		}
 	}
 
Index: linux-2.6.21-rc6-mm1/Documentation/sched-design.txt
===================================================================
--- linux-2.6.21-rc6-mm1.orig/Documentation/sched-design.txt	2007-04-13 17:01:43.000000000 +1000
+++ linux-2.6.21-rc6-mm1/Documentation/sched-design.txt	2007-04-14 00:25:46.000000000 +1000
@@ -268,13 +268,14 @@ there are 40 priority slots where a task
 and the allocation of slots is dependant on nice level. In the
 following table, a zero represents a slot where the task may run.
 
+PRIORITY:0..................20.................39
 nice -20 0000000000000000000000000000000000000000
-nice -10 1001000100100010001001000100010010001000
-nice   0 0101010101010101010101010101010101010101
-nice   5 1101011010110101101011010110101101011011
-nice  10 0110111011011101110110111011101101110111
-nice  15 0111110111111011111101111101111110111111
-nice  19 1111111111111111111011111111111111111111
+nice -10 1000100010001000100010001000100010010000
+nice   0 1010101010101010101010101010101010101010
+nice   5 1011010110110101101101011011010110110110
+nice  10 1110111011101110111011101110111011101110
+nice  15 1111111011111110111111101111111011111110
+nice  19 1111111111111111111111111111111111111110
 
 As can be seen, a nice -20 task runs in every priority slot whereas a nice 19
 task only runs one slot per major rotation. This dithered table allows for the

-- 
-ck
