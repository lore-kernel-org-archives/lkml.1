Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbYGIESg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbYGIESg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 00:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbYGIES1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 00:18:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45596 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYGIES1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 00:18:27 -0400
Message-Id: <20080709041825.202101777@goodmis.org>
References: <20080709041530.668120406@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 00:15:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] sched_clock: only update deltas with local reads.
Content-Disposition: inline; filename=sched_clock-update-only-local-cpu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reading the CPU clock should try to stay accurate within the CPU.
By reading the CPU clock from another CPU and updating the deltas can
cause unneeded jumps when reading from the local CPU.

This patch changes the code to update the last read TSC only when read
from the local CPU.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/sched_clock.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

Index: linux-tip.git/kernel/sched_clock.c
===================================================================
--- linux-tip.git.orig/kernel/sched_clock.c	2008-07-07 19:29:40.000000000 -0400
+++ linux-tip.git/kernel/sched_clock.c	2008-07-08 11:03:05.000000000 -0400
@@ -124,7 +124,7 @@ static int check_max(struct sched_clock_
  *  - filter out backward motion
  *  - use jiffies to generate a min,max window to clip the raw values
  */
-static void __update_sched_clock(struct sched_clock_data *scd, u64 now)
+static void __update_sched_clock(struct sched_clock_data *scd, u64 now, u64 *time)
 {
 	unsigned long now_jiffies = jiffies;
 	long delta_jiffies = now_jiffies - scd->tick_jiffies;
@@ -162,8 +162,12 @@ static void __update_sched_clock(struct 
 	if (unlikely(clock < min_clock))
 		clock = min_clock;
 
-	scd->prev_raw = now;
-	scd->clock = clock;
+	if (time)
+		*time = clock;
+	else {
+		scd->prev_raw = now;
+		scd->clock = clock;
+	}
 }
 
 static void lock_double_clock(struct sched_clock_data *data1,
@@ -207,15 +211,18 @@ u64 sched_clock_cpu(int cpu)
 		now -= scd->tick_gtod;
 
 		__raw_spin_unlock(&my_scd->lock);
+
+		__update_sched_clock(scd, now, &clock);
+
+		__raw_spin_unlock(&scd->lock);
+
 	} else {
 		__raw_spin_lock(&scd->lock);
+		__update_sched_clock(scd, now, NULL);
+		clock = scd->clock;
+		__raw_spin_unlock(&scd->lock);
 	}
 
-	__update_sched_clock(scd, now);
-	clock = scd->clock;
-
-	__raw_spin_unlock(&scd->lock);
-
 	return clock;
 }
 
@@ -234,7 +241,7 @@ void sched_clock_tick(void)
 	now_gtod = ktime_to_ns(ktime_get());
 
 	__raw_spin_lock(&scd->lock);
-	__update_sched_clock(scd, now);
+	__update_sched_clock(scd, now, NULL);
 	/*
 	 * update tick_gtod after __update_sched_clock() because that will
 	 * already observe 1 new jiffy; adding a new tick_gtod to that would

-- 
