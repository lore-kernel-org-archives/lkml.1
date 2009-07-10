Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbZGJSbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbZGJSbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 14:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbZGJSa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 14:30:56 -0400
Received: from www.tglx.de ([62.245.132.106]:60352 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754906AbZGJSaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 14:30:55 -0400
Date: Fri, 10 Jul 2009 20:29:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>
Subject: Re: [ANNOUNCE] 2.6.29.6-rt23
In-Reply-To: <1247249002.18898.11.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0907102023500.2768@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>  <alpine.LFD.2.00.0904031918090.12916@localhost.localdomain>  <alpine.LFD.2.00.0904081937191.21577@localhost.localdomain>  <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain> 
 <alpine.LFD.2.00.0904110003370.21577@localhost.localdomain>  <alpine.LFD.2.00.0904181204420.21577@localhost.localdomain>  <alpine.LFD.2.00.0904251500150.4529@localhost.localdomain>  <alpine.LFD.2.00.0904290036500.4529@localhost.localdomain> 
 <alpine.LFD.2.00.0905012348200.3375@localhost.localdomain>  <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain>  <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain>  <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain> 
 <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain>  <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>  <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>  <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain> 
 <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain> <1247249002.18898.11.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009, Fernando Lopez-Lezcano wrote:
> On Thu, 2009-07-09 at 20:25 +0200, Thomas Gleixner wrote:
> > We are pleased to announce the next update to our new preempt-rt
> > series.
> >  
> >      - update to 2.6.29.6
> >  
> >      - compile fixes (Wu Zhangjin)
> > 
> >      - powerpc highmem fix
> > 
> >      - hwlat smp_processor_id() fix (Carsten)
> > 
> >      - ktime_get* speedups (Martin)
> 
> I'm getting slightly weird behavior from rt23 in an intel quad core
> machine (my T61 laptop is fine), rt22 was fine. It is some timer issue,
> if I type continuously I get (every few seconds) repeated keys. Nothing
> in the logs, nothing in dmesg that is (significantly) different from an
> rt22 boot. 

Hmm. The only change which touches timer related stuff is the ktime*
speedups. Can you please apply the revert patch below and check
whether that changes anything? If not, then we need to look at the
2.6.29.5 -> .6 delta.

Thanks,

	tglx
-----
diff --git b/kernel/hrtimer.c a/kernel/hrtimer.c
index 93affb0..cb8a15c 100644
--- b/kernel/hrtimer.c
+++ a/kernel/hrtimer.c
@@ -46,6 +46,37 @@
 
 #include <asm/uaccess.h>
 
+/**
+ * ktime_get - get the monotonic time in ktime_t format
+ *
+ * returns the time in ktime_t format
+ */
+ktime_t ktime_get(void)
+{
+	struct timespec now;
+
+	ktime_get_ts(&now);
+
+	return timespec_to_ktime(now);
+}
+EXPORT_SYMBOL_GPL(ktime_get);
+
+/**
+ * ktime_get_real - get the real (wall-) time in ktime_t format
+ *
+ * returns the time in ktime_t format
+ */
+ktime_t ktime_get_real(void)
+{
+	struct timespec now;
+
+	getnstimeofday(&now);
+
+	return timespec_to_ktime(now);
+}
+
+EXPORT_SYMBOL_GPL(ktime_get_real);
+
 /*
  * The timer bases:
  *
@@ -73,6 +104,31 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 	}
 };
 
+/**
+ * ktime_get_ts - get the monotonic clock in timespec format
+ * @ts:		pointer to timespec variable
+ *
+ * The function calculates the monotonic clock from the realtime
+ * clock and the wall_to_monotonic offset and stores the result
+ * in normalized timespec format in the variable pointed to by @ts.
+ */
+void ktime_get_ts(struct timespec *ts)
+{
+	struct timespec tomono;
+	unsigned long seq;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		getnstimeofday(ts);
+		tomono = wall_to_monotonic;
+
+	} while (read_seqretry(&xtime_lock, seq));
+
+	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
+				ts->tv_nsec + tomono.tv_nsec);
+}
+EXPORT_SYMBOL_GPL(ktime_get_ts);
+
 /*
  * Get the coarse grained time at the softirq based on xtime and
  * wall_to_monotonic.
diff --git b/kernel/time/timekeeping.c a/kernel/time/timekeeping.c
index 4c99c98..3192dd0 100644
--- b/kernel/time/timekeeping.c
+++ a/kernel/time/timekeeping.c
@@ -118,75 +118,6 @@ void getnstimeofday(struct timespec *ts)
 
 EXPORT_SYMBOL(getnstimeofday);
 
-ktime_t ktime_get(void)
-{
-	cycle_t cycle_now, cycle_delta;
-	unsigned int seq;
-	s64 secs, nsecs;
-
-	WARN_ON(timekeeping_suspended);
-
-	do {
-		seq = read_seqbegin(&xtime_lock);
-		secs = xtime.tv_sec + wall_to_monotonic.tv_sec;
-		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
-
-		/* read clocksource: */
-		cycle_now = clocksource_read(clock);
-
-		/* calculate the delta since the last update_wall_time: */
-		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-
-		/* convert to nanoseconds: */
-		nsecs += cyc2ns(clock, cycle_delta);
-
-	} while (read_seqretry(&xtime_lock, seq));
-	/*
-	 * Use ktime_set/ktime_add_ns to create a proper ktime on
-	 * 32-bit architectures without CONFIG_KTIME_SCALAR.
-	 */
-	return ktime_add_ns(ktime_set(secs, 0), nsecs);
-}
-EXPORT_SYMBOL_GPL(ktime_get);
-
-/**
- * ktime_get_ts - get the monotonic clock in timespec format
- * @ts:		pointer to timespec variable
- *
- * The function calculates the monotonic clock from the realtime
- * clock and the wall_to_monotonic offset and stores the result
- * in normalized timespec format in the variable pointed to by @ts.
- */
-void ktime_get_ts(struct timespec *ts)
-{
-	cycle_t cycle_now, cycle_delta;
-	struct timespec tomono;
-	unsigned int seq;
-	s64 nsecs;
-
-	WARN_ON(timekeeping_suspended);
-
-	do {
-		seq = read_seqbegin(&xtime_lock);
-		*ts = xtime;
-		tomono = wall_to_monotonic;
-
-		/* read clocksource: */
-		cycle_now = clocksource_read(clock);
-
-		/* calculate the delta since the last update_wall_time: */
-		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-
-		/* convert to nanoseconds: */
-		nsecs = cyc2ns(clock, cycle_delta);
-
-	} while (read_seqretry(&xtime_lock, seq));
-
-	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
-				ts->tv_nsec + tomono.tv_nsec + nsecs);
-}
-EXPORT_SYMBOL_GPL(ktime_get_ts);
-
 /**
  * do_gettimeofday - Returns the time of day in a timeval
  * @tv:		pointer to the timeval to be set
@@ -278,65 +209,10 @@ static void change_clocksource(void)
 	       clock->name);
 	 */
 }
-#else /* GENERIC_TIME */
+#else
 static inline void clocksource_forward_now(void) { }
 static inline void change_clocksource(void) { }
-
-/**
- * ktime_get - get the monotonic time in ktime_t format
- *
- * returns the time in ktime_t format
- */
-ktime_t ktime_get(void)
-{
-	struct timespec now;
-
-	ktime_get_ts(&now);
-
-	return timespec_to_ktime(now);
-}
-EXPORT_SYMBOL_GPL(ktime_get);
-
-/**
- * ktime_get_ts - get the monotonic clock in timespec format
- * @ts:		pointer to timespec variable
- *
- * The function calculates the monotonic clock from the realtime
- * clock and the wall_to_monotonic offset and stores the result
- * in normalized timespec format in the variable pointed to by @ts.
- */
-void ktime_get_ts(struct timespec *ts)
-{
-	struct timespec tomono;
-	unsigned long seq;
-
-	do {
-		seq = read_seqbegin(&xtime_lock);
-		getnstimeofday(ts);
-		tomono = wall_to_monotonic;
-
-	} while (read_seqretry(&xtime_lock, seq));
-
-	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
-				ts->tv_nsec + tomono.tv_nsec);
-}
-EXPORT_SYMBOL_GPL(ktime_get_ts);
-#endif /* !GENERIC_TIME */
-
-/**
- * ktime_get_real - get the real (wall-) time in ktime_t format
- *
- * returns the time in ktime_t format
- */
-ktime_t ktime_get_real(void)
-{
-	struct timespec now;
-
-	getnstimeofday(&now);
-
-	return timespec_to_ktime(now);
-}
-EXPORT_SYMBOL_GPL(ktime_get_real);
+#endif
 
 /**
  * getrawmonotonic - Returns the raw monotonic time in a timespec
