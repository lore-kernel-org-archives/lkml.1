Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab0CDDLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:11:41 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:39319 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab0CDDLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:11:32 -0500
From: John Stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] time: Cleanup warp_clock
Date: Wed,  3 Mar 2010 19:11:18 -0800
Message-Id: <1267672280-21386-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not critical, 2.6.35 material.

warp_clock() currently accesses timekeeping internal state directly, which
is unnecessary. Convert it to use the proper timekeeping interfaces.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 kernel/time.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/time.c b/kernel/time.c
index 8047980..abe1c1b 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -133,12 +133,11 @@ SYSCALL_DEFINE2(gettimeofday, struct timeval __user *, tv,
  */
 static inline void warp_clock(void)
 {
-	write_seqlock_irq(&xtime_lock);
-	wall_to_monotonic.tv_sec -= sys_tz.tz_minuteswest * 60;
-	xtime.tv_sec += sys_tz.tz_minuteswest * 60;
-	update_xtime_cache(0);
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
+	struct timespec delta, adjust;
+	delta.tv_sec = sys_tz.tz_minuteswest * 60;
+	delta.tv_nsec = 0;
+	adjust = timespec_add_safe(current_kernel_time(), delta);	
+	do_settimeofday(&adjust);
 }
 
 /*
-- 
1.6.0.4

