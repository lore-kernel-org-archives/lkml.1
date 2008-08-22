Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbYHVMZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbYHVMZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 08:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbYHVMZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 08:25:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40333 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbYHVMZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 08:25:00 -0400
Date: Fri, 22 Aug 2008 14:24:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] timer fixes
Message-ID: <20080822122445.GA4542@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

Thanks,

	Ingo

------------------>
Miao Xie (1):
      nohz: fix wrong event handler after online an offlined cpu


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
index f5da526..7a46bde 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -643,17 +643,21 @@ void tick_setup_sched_timer(void)
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
