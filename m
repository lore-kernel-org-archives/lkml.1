Return-Path: <linux-kernel-owner+w=401wt.eu-S933715AbXJPOKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933715AbXJPOKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 10:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758554AbXJPOJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 10:09:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36866 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758669AbXJPOJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 10:09:46 -0400
Date: Tue, 16 Oct 2007 16:09:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       John Stultz <johnstul@us.ibm.com>
Subject: [patch] time: introduce xtime_seconds
Message-ID: <20071016140920.GA11750@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: time: introduce xtime_seconds
From: Ingo Molnar <mingo@elte.hu>

improve performance of sys_time(). sys_time() returns time in seconds, 
but it does so by calling do_gettimeofday() and then returning the 
tv_sec portion of the GTOD time. But the data structure "xtime", which 
is updated by every timer/scheduler tick, already offers HZ granularity 
time.

the patch improves the sysbench oltp macrobenchmark by 4-5% on an AMD 
dual-core system:

v2.6.23:

#threads

   1:     transactions:                        4073   (407.23 per sec.)
   2:     transactions:                        8530   (852.81 per sec.)
   3:     transactions:                        8321   (831.88 per sec.)
   4:     transactions:                        8407   (840.58 per sec.)
   5:     transactions:                        8070   (806.74 per sec.)

v2.6.23 + sys_time-speedup.patch:

   1:     transactions:                        4281   (428.09 per sec.)
   2:     transactions:                        8910   (890.85 per sec.)
   3:     transactions:                        8659   (865.79 per sec.)
   4:     transactions:                        8676   (867.34 per sec.)
   5:     transactions:                        8532   (852.91 per sec.)

and by 4-5% on an Intel dual-core system too:

2.6.23:

  1:     transactions:                        4560   (455.94 per sec.)
  2:     transactions:                        10094  (1009.30 per sec.)
  3:     transactions:                        9755   (975.36 per sec.)
  4:     transactions:                        9859   (985.78 per sec.)
  5:     transactions:                        9701   (969.72 per sec.)

2.6.23 + sys_time-speedup.patch:

  1:     transactions:                        4779   (477.84 per sec.)
  2:     transactions:                        10103  (1010.14 per sec.)
  3:     transactions:                        10141  (1013.93 per sec.)
  4:     transactions:                        10371  (1036.89 per sec.)
  5:     transactions:                        10178  (1017.50 per sec.)

(the more CPUs the system has, the more speedup this patch gives for
this particular workload.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time.c             |    6 +-----
 kernel/time/timekeeping.c |    7 -------
 2 files changed, 1 insertion(+), 12 deletions(-)

Index: linux/kernel/time.c
===================================================================
--- linux.orig/kernel/time.c
+++ linux/kernel/time.c
@@ -57,11 +57,7 @@ EXPORT_SYMBOL(sys_tz);
  */
 asmlinkage long sys_time(time_t __user * tloc)
 {
-	time_t i;
-	struct timespec tv;
-
-	getnstimeofday(&tv);
-	i = tv.tv_sec;
+	time_t i = get_seconds();
 
 	if (tloc) {
 		if (put_user(i,tloc))
Index: linux/kernel/time/timekeeping.c
===================================================================
--- linux.orig/kernel/time/timekeeping.c
+++ linux/kernel/time/timekeeping.c
@@ -49,19 +49,12 @@ struct timespec wall_to_monotonic __attr
 static unsigned long total_sleep_time;		/* seconds */
 EXPORT_SYMBOL(xtime);
 
-
-#ifdef CONFIG_NO_HZ
 static struct timespec xtime_cache __attribute__ ((aligned (16)));
 static inline void update_xtime_cache(u64 nsec)
 {
 	xtime_cache = xtime;
 	timespec_add_ns(&xtime_cache, nsec);
 }
-#else
-#define xtime_cache xtime
-/* We do *not* want to evaluate the argument for this case */
-#define update_xtime_cache(n) do { } while (0)
-#endif
 
 static struct clocksource *clock; /* pointer to current clocksource */
 
