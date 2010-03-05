Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0CECgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 21:36:40 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:55481 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab0CECgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 21:36:39 -0500
From: John Stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] s390: Cleanup xtime usage in s390 code
Date: Thu,  4 Mar 2010 18:36:35 -0800
Message-Id: <1267756595-30385-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces direct xtime usage in the s390 arch with timekeeping accessors,
so we can further clean up the timekeeping core.

Uncompiled and untested.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/s390/kernel/time.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index a8f93f1..8b22e7f 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -73,15 +73,15 @@ unsigned long long monotonic_clock(void)
 }
 EXPORT_SYMBOL(monotonic_clock);
 
-void tod_to_timeval(__u64 todval, struct timespec *xtime)
+void tod_to_timeval(__u64 todval, struct timespec *xt)
 {
 	unsigned long long sec;
 
 	sec = todval >> 12;
 	do_div(sec, 1000000);
-	xtime->tv_sec = sec;
+	xt->tv_sec = sec;
 	todval -= (sec * 1000000) << 12;
-	xtime->tv_nsec = ((todval * 1000) >> 12);
+	xt->tv_nsec = ((todval * 1000) >> 12);
 }
 EXPORT_SYMBOL(tod_to_timeval);
 
@@ -216,8 +216,8 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
 	++vdso_data->tb_update_count;
 	smp_wmb();
 	vdso_data->xtime_tod_stamp = clock->cycle_last;
-	vdso_data->xtime_clock_sec = xtime.tv_sec;
-	vdso_data->xtime_clock_nsec = xtime.tv_nsec;
+	vdso_data->xtime_clock_sec = wall_time->tv_sec;
+	vdso_data->xtime_clock_nsec = wall_time->tv_nsec;
 	vdso_data->wtom_clock_sec = wall_to_monotonic.tv_sec;
 	vdso_data->wtom_clock_nsec = wall_to_monotonic.tv_nsec;
 	smp_wmb();
-- 
1.6.0.4

