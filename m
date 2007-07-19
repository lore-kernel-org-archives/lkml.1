Return-Path: <linux-kernel-owner+w=401wt.eu-S939556AbXGSRSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939556AbXGSRSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965718AbXGSRSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:18:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59315 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965719AbXGSRSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:18:05 -0400
Date: Thu, 19 Jul 2007 19:17:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bill Davidsen <davidsen@tmr.com>
Cc: davidsen@posidon.tmr.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ian Kent <raven@themaw.net>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v19
Message-ID: <20070719171753.GA24194@elte.hu>
References: <20070711205556.GA27266@elte.hu> <4697EC49.4070303@tmr.com> <469BE462.9030004@redhat.com> <20070716215541.GA27171@elte.hu> <1184648474.3188.33.camel@raven.themaw.net> <20070717074537.GA13539@elte.hu> <alpine.LFD.0.999.0707180852540.27353@woody.linux-foundation.org> <469E8821.3070700@tmr.com> <20070719143214.GA6387@elte.hu> <469F9A2E.5020107@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469F9A2E.5020107@tmr.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Bill Davidsen <davidsen@tmr.com> wrote:

> Ingo Molnar wrote:
> >* Bill Davidsen <davidsen@tmr.com> wrote:
> >
> >>>Does the patch below help?
> 
> Doesn't seem to apply against 2.6.22.1, I'm trying 2.6.22.6 as soon as 
> I recreate it.

the patch below is merged against 2.6.22.1-cfs-v19 - does it solve the 
autofs problem (without any other bad side-effects)?

	Ingo

------------------->
Subject: time: introduce xtime_seconds
From: Ingo Molnar <mingo@elte.hu>

introduce the xtime_seconds optimization. This is a read-mostly 
low-resolution time source available to sys_time() and kernel-internal 
use. This variable is kept uptodate atomically, and it's monotically 
increased, every time some time interface constructs an xtime-alike time 
result that overflows the seconds value. (it's updated from the timer 
interrupt as well)

this way high-resolution time results update their seconds component at 
the same time sys_time() does it:

 1184858832999989000
 1184858832000000000
 1184858832999992000
 1184858832000000000
 1184858832999996000
 1184858832000000000
 1184858832999999000
 1184858832000000000
 1184858833000003000
 1184858833000000000
 1184858833000006000
 1184858833000000000
 1184858833000009000
 1184858833000000000

 [ these are nsec time results from alternating calls to sys_time() and 
   sys_gettimeofday(), recorded at the seconds boundary. ]

instead of the previous (non-coherent) behavior:

 1184848950999987000
 1184848950000000000
 1184848950999990000
 1184848950000000000
 1184848950999994000
 1184848950000000000
 1184848950999997000
 1184848950000000000
 1184848951000001000
 1184848950000000000
 1184848951000005000
 1184848950000000000
 1184848951000008000
 1184848950000000000
 1184848951000011000
 1184848950000000000
 1184848951000015000

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/time.h      |   13 +++++++++++--
 kernel/time.c             |   25 ++++++-------------------
 kernel/time/timekeeping.c |   26 +++++++++++++++++++++++---
 3 files changed, 40 insertions(+), 24 deletions(-)

Index: linux-cfs-2.6.22.q/include/linux/time.h
===================================================================
--- linux-cfs-2.6.22.q.orig/include/linux/time.h
+++ linux-cfs-2.6.22.q/include/linux/time.h
@@ -91,19 +91,28 @@ static inline struct timespec timespec_s
 extern struct timespec xtime;
 extern struct timespec wall_to_monotonic;
 extern seqlock_t xtime_lock __attribute__((weak));
+extern unsigned long xtime_seconds;
 
 extern unsigned long read_persistent_clock(void);
 void timekeeping_init(void);
 
+extern void __update_xtime_seconds(unsigned long new_xtime_seconds);
+
+static inline void update_xtime_seconds(unsigned long new_xtime_seconds)
+{
+	if (unlikely((long)(new_xtime_seconds - xtime_seconds) > 0))
+		__update_xtime_seconds(new_xtime_seconds);
+}
+
 static inline unsigned long get_seconds(void)
 {
-	return xtime.tv_sec;
+	return xtime_seconds;
 }
 
 struct timespec current_kernel_time(void);
 
 #define CURRENT_TIME		(current_kernel_time())
-#define CURRENT_TIME_SEC	((struct timespec) { xtime.tv_sec, 0 })
+#define CURRENT_TIME_SEC	((struct timespec) { xtime_seconds, 0 })
 
 extern void do_gettimeofday(struct timeval *tv);
 extern int do_settimeofday(struct timespec *tv);
Index: linux-cfs-2.6.22.q/kernel/time.c
===================================================================
--- linux-cfs-2.6.22.q.orig/kernel/time.c
+++ linux-cfs-2.6.22.q/kernel/time.c
@@ -58,11 +58,10 @@ EXPORT_SYMBOL(sys_tz);
 asmlinkage long sys_time(time_t __user * tloc)
 {
 	/*
-	 * We read xtime.tv_sec atomically - it's updated
-	 * atomically by update_wall_time(), so no need to
-	 * even read-lock the xtime seqlock:
+	 * We read xtime_seconds atomically - it's updated
+	 * atomically by update_xtime_seconds():
 	 */
-	time_t i = xtime.tv_sec;
+	time_t i = xtime_seconds;
 
 	smp_rmb(); /* sys_time() results are coherent */
 
@@ -226,11 +225,11 @@ inline struct timespec current_kernel_ti
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-		
+
 		now = xtime;
 	} while (read_seqretry(&xtime_lock, seq));
 
-	return now; 
+	return now;
 }
 
 EXPORT_SYMBOL(current_kernel_time);
@@ -377,19 +376,7 @@ void do_gettimeofday (struct timeval *tv
 	tv->tv_sec = sec;
 	tv->tv_usec = usec;
 
-	/*
-	 * Make sure xtime.tv_sec [returned by sys_time()] always
-	 * follows the gettimeofday() result precisely. This
-	 * condition is extremely unlikely, it can hit at most
-	 * once per second:
-	 */
-	if (unlikely(xtime.tv_sec != tv->tv_sec)) {
-		unsigned long flags;
-
-		write_seqlock_irqsave(&xtime_lock);
-		update_wall_time();
-		write_seqlock_irqrestore(&xtime_lock);
-	}
+	update_xtime_seconds(sec);
 }
 
 EXPORT_SYMBOL(do_gettimeofday);
Index: linux-cfs-2.6.22.q/kernel/time/timekeeping.c
===================================================================
--- linux-cfs-2.6.22.q.orig/kernel/time/timekeeping.c
+++ linux-cfs-2.6.22.q/kernel/time/timekeeping.c
@@ -38,13 +38,26 @@ EXPORT_SYMBOL(xtime_lock);
  * the usual normalization.
  */
 struct timespec xtime __attribute__ ((aligned (16)));
-struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
-
 EXPORT_SYMBOL(xtime);
 
+struct timespec wall_to_monotonic __attribute__ ((aligned (16))) __read_mostly;
+
+unsigned long xtime_seconds __read_mostly;
+
+/* pointer to current clocksource: */
+static struct clocksource *clock __read_mostly;
 
-static struct clocksource *clock; /* pointer to current clocksource */
+/*
+ * Called when either xtime or any xtime-alike result back to
+ * user-space overflows the xtime_seconds field:
+ */
+void __update_xtime_seconds(unsigned long new_xtime_seconds)
+{
+	unsigned long old_xtime_seconds = xtime_seconds;
 
+	if ((long)(new_xtime_seconds - old_xtime_seconds) > 0)
+		cmpxchg(&xtime_seconds, old_xtime_seconds, new_xtime_seconds);
+}
 
 #ifdef CONFIG_GENERIC_TIME
 /**
@@ -92,6 +105,8 @@ static inline void __get_realtime_clock_
 	} while (read_seqretry(&xtime_lock, seq));
 
 	timespec_add_ns(ts, nsecs);
+
+	update_xtime_seconds(ts->tv_sec);
 }
 
 /**
@@ -248,6 +263,8 @@ void __init timekeeping_init(void)
 	clock->cycle_last = clocksource_read(clock);
 
 	xtime.tv_sec = sec;
+	update_xtime_seconds(sec);
+
 	xtime.tv_nsec = 0;
 	set_normalized_timespec(&wall_to_monotonic,
 		-xtime.tv_sec, -xtime.tv_nsec);
@@ -281,6 +298,8 @@ static int timekeeping_resume(struct sys
 		unsigned long sleep_length = now - timekeeping_suspend_time;
 
 		xtime.tv_sec += sleep_length;
+		update_xtime_seconds(xtime.tv_sec);
+
 		wall_to_monotonic.tv_sec -= sleep_length;
 	}
 	/* re-base the last cycle value */
@@ -454,6 +473,7 @@ void update_wall_time(void)
 			clock->xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
 			xtime.tv_sec++;
 			second_overflow();
+			update_xtime_seconds(xtime.tv_sec);
 		}
 
 		/* interpolator bits */
