Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbYGGSVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbYGGSVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 14:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755440AbYGGSVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 14:21:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51547 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964AbYGGSVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 14:21:07 -0400
Message-Id: <20080707182104.179063464@goodmis.org>
References: <20080707181649.942597764@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 07 Jul 2008 14:16:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/3] sched_clock: widen the max and min time
Content-Disposition: inline; filename=sched_clock-bigger-max-min-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With keeping the max and min sched time within one jiffy of the gtod clock
was too tight. Just before a schedule tick the max could easily be hit, as
well as just after a schedule_tick the min could be hit. This caused the
clock to jump around by a jiffy.

This patch widens the minimum to
   last gtod + (delta_jiffies ? delta_jiffies - 1 : 0) * TICK_NSECS

and the maximum to
    last gtod + (2 + delta_jiffies) * TICK_NSECS

This keeps the minum to gtod or if one jiffy less than delta jiffies
and the maxim 2 jiffies ahead of gtod. This may cause unstable TSCs to be
a bit more sporadic, but it helps keep a clock with a stable TSC working well.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/sched_clock.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: linux-tip.git/kernel/sched_clock.c
===================================================================
--- linux-tip.git.orig/kernel/sched_clock.c	2008-07-06 22:35:35.000000000 -0400
+++ linux-tip.git/kernel/sched_clock.c	2008-07-06 22:33:49.000000000 -0400
@@ -96,14 +96,21 @@ static void __update_sched_clock(struct 
 	s64 delta = now - scd->prev_raw;
 
 	WARN_ON_ONCE(!irqs_disabled());
-	min_clock = scd->tick_gtod + delta_jiffies * TICK_NSEC;
+
+	min_clock = scd->tick_gtod +
+		(delta_jiffies ? delta_jiffies - 1 : 0) * TICK_NSEC;
 
 	if (unlikely(delta < 0)) {
 		clock++;
 		goto out;
 	}
 
-	max_clock = min_clock + TICK_NSEC;
+	/*
+	 * The clock must stay within a jiffie of the gtod.
+	 * But since we may be at the start of a jiffy or the end of one
+	 * we add another jiffy buffer.
+	 */
+	max_clock = scd->tick_gtod + (2 + delta_jiffies) * TICK_NSEC;
 
 	if (unlikely(clock + delta > max_clock)) {
 		if (clock < max_clock)

-- 
