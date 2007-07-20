Return-Path: <linux-kernel-owner+w=401wt.eu-S934819AbXGTPMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934819AbXGTPMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934105AbXGTPMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:12:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49524 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934096AbXGTPMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:12:24 -0400
Date: Fri, 20 Jul 2007 17:12:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regression with sys_time() speedup patch
Message-ID: <20070720151213.GA32043@elte.hu>
References: <s5hps2nqg4w.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hps2nqg4w.wl%tiwai@suse.de>
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


* Takashi Iwai <tiwai@suse.de> wrote:

> Hi Ingo,
> 
> 2.6.22-git as of today caused some regression on my P4 machine.  For 
> example, automount process takes 10-30% CPU time constantly, and 
> sometimes vim couldn't write files properly.

does the patch below fix it?

	Ingo

--------------->
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
 kernel/time/timekeeping.c |   28 ++++++++++++++++++++++++----
 3 files changed, 41 insertions(+), 25 deletions(-)

Index: linux/include/linux/time.h
===================================================================
--- linux.orig/include/linux/time.h
+++ linux/include/linux/time.h
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
Index: linux/kernel/time.c
===================================================================
--- linux.orig/kernel/time.c
+++ linux/kernel/time.c
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
-		write_seqlock_irqsave(&xtime_lock, flags);
-		update_wall_time();
-		write_sequnlock_irqrestore(&xtime_lock, flags);
-	}
+	update_xtime_seconds(sec);
 }
 EXPORT_SYMBOL(do_gettimeofday);
 
Index: linux/kernel/time/timekeeping.c
===================================================================
--- linux.orig/kernel/time/timekeeping.c
+++ linux/kernel/time/timekeeping.c
@@ -45,14 +45,28 @@ EXPORT_SYMBOL(xtime_lock);
  * used instead.
  */
 struct timespec xtime __attribute__ ((aligned (16)));
-struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
-static unsigned long total_sleep_time;		/* seconds */
-
 EXPORT_SYMBOL(xtime);
 
+struct timespec wall_to_monotonic __attribute__ ((aligned (16))) __read_mostly;
+static unsigned long total_sleep_time __read_mostly;	/* seconds */
+
+unsigned long xtime_seconds __read_mostly;
+EXPORT_SYMBOL(xtime_seconds);
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
@@ -100,6 +113,8 @@ static inline void __get_realtime_clock_
 	} while (read_seqretry(&xtime_lock, seq));
 
 	timespec_add_ns(ts, nsecs);
+
+	update_xtime_seconds(ts->tv_sec);
 }
 
 /**
@@ -256,6 +271,8 @@ void __init timekeeping_init(void)
 	clock->cycle_last = clocksource_read(clock);
 
 	xtime.tv_sec = sec;
+	update_xtime_seconds(sec);
+
 	xtime.tv_nsec = 0;
 	set_normalized_timespec(&wall_to_monotonic,
 		-xtime.tv_sec, -xtime.tv_nsec);
@@ -290,6 +307,8 @@ static int timekeeping_resume(struct sys
 		unsigned long sleep_length = now - timekeeping_suspend_time;
 
 		xtime.tv_sec += sleep_length;
+		update_xtime_seconds(xtime.tv_sec);
+
 		wall_to_monotonic.tv_sec -= sleep_length;
 		total_sleep_time += sleep_length;
 	}
@@ -464,6 +483,7 @@ void update_wall_time(void)
 			clock->xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
 			xtime.tv_sec++;
 			second_overflow();
+			update_xtime_seconds(xtime.tv_sec);
 		}
 
 		/* interpolator bits */
