Return-Path: <linux-kernel-owner+w=401wt.eu-S1760975AbYGKUzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975AbYGKUzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbYGKUzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:55:36 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:46855 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbYGKUzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:55:35 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-3.tower-164.messagelabs.com!1215809733!11865301!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH, RFC] use hrtimer in sched_clock
Date: Fri, 11 Jul 2008 22:55:27 +0200
Message-ID: <1215809727-28598-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.6.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 11 Jul 2008 20:55:30.0162 (UTC) FILETIME=[740D4520:01C8E398]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should make it unnecessary to overwrite sched_clock for a higher
precision.
With this patch I get sub-jiffie timing with CONFIG_PRINTK_TIME=y.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
Hello,

I tested the patch on arch-arm/mach-ns9xxx and it seem seams to work.
But I admit I didn't test it deeply and I didn't measure if there is any
overhead.

Best regards
Uwe

 kernel/sched_clock.c      |    6 +++++-
 kernel/time/timekeeping.c |   16 +++++++++-------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index ce05271..12daf55 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -242,5 +242,9 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
  */
 unsigned long long __attribute__((weak)) sched_clock(void)
 {
-	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
+	struct timespec ts;
+
+	ktime_get_ts(&ts);
+
+	return (long long)ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
 }
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e91c29f..49412f2 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -67,16 +67,18 @@ struct clocksource *clock;
 static inline s64 __get_nsec_offset(void)
 {
 	cycle_t cycle_now, cycle_delta;
-	s64 ns_offset;
+	s64 ns_offset = 0;
 
-	/* read clocksource: */
-	cycle_now = clocksource_read(clock);
+	if (likely(clock)) {
+		/* read clocksource: */
+		cycle_now = clocksource_read(clock);
 
-	/* calculate the delta since the last update_wall_time: */
-	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+		/* calculate the delta since the last update_wall_time: */
+		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
-	/* convert to nanoseconds: */
-	ns_offset = cyc2ns(clock, cycle_delta);
+		/* convert to nanoseconds: */
+		ns_offset = cyc2ns(clock, cycle_delta);
+	}
 
 	return ns_offset;
 }
-- 
1.5.6.2

