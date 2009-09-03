Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbZICIe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbZICIe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 04:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbZICIe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 04:34:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:21013 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbZICIez convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 04:34:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="183617076"
Date: Thu, 3 Sep 2009 16:32:53 +0800
From: Feng Tang <feng.tang@intel.com>
To: <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] hrtimers: Remove the "timer_stats_active" check when
 setting the start info
Message-ID: <20090903163253.1d846628@feng-desktop>
Organization: intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi tglx,

Please review this patch (generated against v2.6.31-rc8)

Thanks,
Feng

>From 8c6b53a0ead71590a0dd5556c9ad409f0c1ad2d1 Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Thu, 3 Sep 2009 15:51:10 +0800
Subject: [PATCH] hrtimers: Remove the "timer_stats_active" check when setting the start info

Recent hrtimer code will set the start info to a hrtimer only when that
flag is set, then the start info of all hrtimers will always be uninitialised
before a "echo 1 > /proc/timer_stats", thus the /proc/timer_lists will have
something like:

active timers:
 #0: <c27d46b0>, tick_sched_timer, S:01, <(null)>, /-1
 # expires at 91062000000-91062000000 nsecs [in 156071 to 156071 nsecs]
 #1: <efb81b6c>, hrtimer_wakeup, S:01, <(null)>, /-1
 # expires at 91062300331-91062350331 nsecs [in 456402 to 506402 nsecs]
 #2: <efac9b6c>, hrtimer_wakeup, S:01, <(null)>, /-1
 # expires at 91068699811-91068749811 nsecs [in 6855882 to 6905882 nsecs]
 #3: <efacdb6c>, hrtimer_wakeup, S:01, <(null)>, /-1
 # expires at 91068755511-91068805511 nsecs [in 6911582 to 6961582 nsecs]
 #4: <efa95b6c>, hrtimer_wakeup, S:01, <(null)>, /-1
 # expires at 91068806066-91068856066 nsecs [in 6962137 to 7012137 nsecs]
 .....

This patch will fix it.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 include/linux/hrtimer.h |    2 --
 kernel/hrtimer.c        |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 4759917..c2ae96b 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -459,8 +459,6 @@ extern void __timer_stats_hrtimer_set_start_info(struct hrtimer *timer,
 
 static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
 {
-	if (likely(!timer_stats_active))
-		return;
 	__timer_stats_hrtimer_set_start_info(timer, __builtin_return_address(0));
 }
 
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 49da79a..9bf3211 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -778,7 +778,7 @@ static inline void hrtimer_init_timer_hres(struct hrtimer *timer) { }
 #ifdef CONFIG_TIMER_STATS
 void __timer_stats_hrtimer_set_start_info(struct hrtimer *timer, void *addr)
 {
-	if (timer->start_site)
+	if (timer->start_site == addr && timer->start_pid == current->pid)
 		return;
 
 	timer->start_site = addr;
-- 
1.5.6.3
