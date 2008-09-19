Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbYISMR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbYISMR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 08:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYISMRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 08:17:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38963 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbYISMRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 08:17:04 -0400
Subject: [PATCH 1/2] hrtimer: Remove hrtimer_clock_base::get_softirq_time()
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain
Date: Fri, 19 Sep 2008 13:13:44 +0100
Message-Id: <1221826424.20993.4.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra noticed this 8 months ago and I just noticed
it again.

hrtimer_clock_base::get_softirq_time() is currently unused
in the entire tree. In fact, looking at the logs, it appears
as if it was never used. Remove it.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 include/linux/hrtimer.h |    2 --
 kernel/hrtimer.c        |    4 +---
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 6d93dce..1b079bd 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -145,7 +145,6 @@ struct hrtimer_sleeper {
  * @first:		pointer to the timer node which expires first
  * @resolution:		the resolution of the clock, in nanoseconds
  * @get_time:		function to retrieve the current time of the clock
- * @get_softirq_time:	function to retrieve the current time from the softirq
  * @softirq_time:	the time when running the hrtimer queue in the softirq
  * @offset:		offset of this clock to the monotonic base
  * @reprogram:		function to reprogram the timer event
@@ -157,7 +156,6 @@ struct hrtimer_clock_base {
 	struct rb_node		*first;
 	ktime_t			resolution;
 	ktime_t			(*get_time)(void);
-	ktime_t			(*get_softirq_time)(void);
 	ktime_t			softirq_time;
 #ifdef CONFIG_HIGH_RES_TIMERS
 	ktime_t			offset;
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 03ea137..4d761d5 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1401,9 +1401,7 @@ void hrtimer_run_queues(void)
 		if (!base->first)
 			continue;
 
-		if (base->get_softirq_time)
-			base->softirq_time = base->get_softirq_time();
-		else if (gettime) {
+		if (gettime) {
 			hrtimer_get_softirq_time(cpu_base);
 			gettime = 0;
 		}
-- 
1.5.4.3

