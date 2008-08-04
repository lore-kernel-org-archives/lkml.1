Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbYHDKIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbYHDKIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 06:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYHDKIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 06:08:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54636 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbYHDKIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:08:11 -0400
Message-ID: <4896D467.2070700@cn.fujitsu.com>
Date: Mon, 04 Aug 2008 18:05:27 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] nohz: fix wrong event handler after online an offlined cpu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the tickless system(CONFIG_NO_HZ=y and CONFIG_HIGH_RES_TIMERS=n), after I
made an offlined cpu online, I found this cpu's event handler was
tick_handle_periodic, not tick_nohz_handler.

After debuging, I found this bug was caused by the wrong tick mode.
the tick mode is not changed to NOHZ_MODE_INACTIVE when the cpu is offline.

This patch fixes this bug.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

---
 include/linux/tick.h     |    5 ++++-
 kernel/time/tick-sched.c |    6 +++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index d3c0269..8cf8cfe 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -74,10 +74,13 @@ extern struct tick_device *tick_get_device(int cpu);
 extern int tick_init_highres(void);
 extern int tick_program_event(ktime_t expires, int force);
 extern void tick_setup_sched_timer(void);
+# endif
+
+# if defined CONFIG_NO_HZ || defined CONFIG_HIGH_RES_TIMERS
 extern void tick_cancel_sched_timer(int cpu);
 # else
 static inline void tick_cancel_sched_timer(int cpu) { }
-# endif /* HIGHRES */
+# endif
 
 # ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 extern struct tick_device *tick_get_broadcast_device(void);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 825b4c0..661a392 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -645,17 +645,21 @@ void tick_setup_sched_timer(void)
 		ts->nohz_mode = NOHZ_MODE_HIGHRES;
 #endif
 }
+#endif /* HIGH_RES_TIMERS */
 
+#if defined CONFIG_NO_HZ || defined CONFIG_HIGH_RES_TIMERS 
 void tick_cancel_sched_timer(int cpu)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 
+# ifdef CONFIG_HIGH_RES_TIMERS
 	if (ts->sched_timer.base)
 		hrtimer_cancel(&ts->sched_timer);
+# endif
 
 	ts->nohz_mode = NOHZ_MODE_INACTIVE;
 }
-#endif /* HIGH_RES_TIMERS */
+#endif
 
 /**
  * Async notification about clocksource changes
-- 
1.5.4.rc3

