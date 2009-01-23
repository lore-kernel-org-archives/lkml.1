Return-Path: <linux-kernel-owner+w=401wt.eu-S1762313AbZAWGYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762313AbZAWGYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761168AbZAWGQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:16:45 -0500
Received: from kroah.org ([198.145.64.141]:36333 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761089AbZAWGQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:16:42 -0500
Date: Thu, 22 Jan 2009 22:14:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Roman Zippel <zippel@linux-m68k.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 22/40] clocksource: introduce clocksource_forward_now()
Message-ID: <20090123061409.GV2922@kroah.com>
References: <20090123001330.046404396@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="clocksource-introduce-clocksource_forward_now.patch"
In-Reply-To: <20090123001908.GA7397@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roman Zippel <zippel@linux-m68k.org>

commit 9a055117d3d9cb562f83f8d4cd88772761f4cab0 upstream.

To keep the raw monotonic patch simple first introduce
clocksource_forward_now(), which takes care of the offset since the last
update_wall_time() call and adds it to the clock, so there is no need
anymore to deal with it explicitly at various places, which need to make
significant changes to the clock.

This is also gets rid of the timekeeping_suspend_nsecs, instead of
waiting until resume, the value is accumulated during suspend. In the end
there is only a single user of __get_nsec_offset() left, so I integrated
it back to getnstimeofday().

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/timekeeping.c |   71 +++++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 38 deletions(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -61,27 +61,23 @@ struct clocksource *clock;
 
 #ifdef CONFIG_GENERIC_TIME
 /**
- * __get_nsec_offset - Returns nanoseconds since last call to periodic_hook
+ * clocksource_forward_now - update clock to the current time
  *
- * private function, must hold xtime_lock lock when being
- * called. Returns the number of nanoseconds since the
- * last call to update_wall_time() (adjusted by NTP scaling)
+ * Forward the current clock to update its state since the last call to
+ * update_wall_time(). This is useful before significant clock changes,
+ * as it avoids having to deal with this time offset explicitly.
  */
-static inline s64 __get_nsec_offset(void)
+static void clocksource_forward_now(void)
 {
 	cycle_t cycle_now, cycle_delta;
-	s64 ns_offset;
+	s64 nsec;
 
-	/* read clocksource: */
 	cycle_now = clocksource_read(clock);
-
-	/* calculate the delta since the last update_wall_time: */
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+	clock->cycle_last = cycle_now;
 
-	/* convert to nanoseconds: */
-	ns_offset = cyc2ns(clock, cycle_delta);
-
-	return ns_offset;
+	nsec = cyc2ns(clock, cycle_delta);
+	timespec_add_ns(&xtime, nsec);
 }
 
 /**
@@ -92,6 +88,7 @@ static inline s64 __get_nsec_offset(void
  */
 void getnstimeofday(struct timespec *ts)
 {
+	cycle_t cycle_now, cycle_delta;
 	unsigned long seq;
 	s64 nsecs;
 
@@ -101,7 +98,15 @@ void getnstimeofday(struct timespec *ts)
 		seq = read_seqbegin(&xtime_lock);
 
 		*ts = xtime;
-		nsecs = __get_nsec_offset();
+
+		/* read clocksource: */
+		cycle_now = clocksource_read(clock);
+
+		/* calculate the delta since the last update_wall_time: */
+		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+
+		/* convert to nanoseconds: */
+		nsecs = cyc2ns(clock, cycle_delta);
 
 	} while (read_seqretry(&xtime_lock, seq));
 
@@ -134,22 +139,22 @@ EXPORT_SYMBOL(do_gettimeofday);
  */
 int do_settimeofday(struct timespec *tv)
 {
+	struct timespec ts_delta;
 	unsigned long flags;
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
 
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 
-	nsec -= __get_nsec_offset();
+	clocksource_forward_now();
+
+	ts_delta.tv_sec = tv->tv_sec - xtime.tv_sec;
+	ts_delta.tv_nsec = tv->tv_nsec - xtime.tv_nsec;
+	wall_to_monotonic = timespec_sub(wall_to_monotonic, ts_delta);
 
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
+	xtime = *tv;
 
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
 	update_xtime_cache(0);
 
 	clock->error = 0;
@@ -175,22 +180,17 @@ EXPORT_SYMBOL(do_settimeofday);
 static void change_clocksource(void)
 {
 	struct clocksource *new;
-	cycle_t now;
-	u64 nsec;
 
 	new = clocksource_get_next();
 
 	if (clock == new)
 		return;
 
-	new->cycle_last = 0;
-	now = clocksource_read(new);
-	nsec =  __get_nsec_offset();
-	timespec_add_ns(&xtime, nsec);
+	clocksource_forward_now();
 
 	clock = new;
-	clock->cycle_last = now;
-
+	clock->cycle_last = 0;
+	clock->cycle_last = clocksource_read(new);
 	clock->error = 0;
 	clock->xtime_nsec = 0;
 	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
@@ -205,8 +205,8 @@ static void change_clocksource(void)
 	 */
 }
 #else
+static inline void clocksource_forward_now(void) { }
 static inline void change_clocksource(void) { }
-static inline s64 __get_nsec_offset(void) { return 0; }
 #endif
 
 /**
@@ -268,8 +268,6 @@ void __init timekeeping_init(void)
 
 /* time in seconds when suspend began */
 static unsigned long timekeeping_suspend_time;
-/* xtime offset when we went into suspend */
-static s64 timekeeping_suspend_nsecs;
 
 /**
  * timekeeping_resume - Resumes the generic timekeeping subsystem.
@@ -295,8 +293,6 @@ static int timekeeping_resume(struct sys
 		wall_to_monotonic.tv_sec -= sleep_length;
 		total_sleep_time += sleep_length;
 	}
-	/* Make sure that we have the correct xtime reference */
-	timespec_add_ns(&xtime, timekeeping_suspend_nsecs);
 	update_xtime_cache(0);
 	/* re-base the last cycle value */
 	clock->cycle_last = 0;
@@ -322,8 +318,7 @@ static int timekeeping_suspend(struct sy
 	timekeeping_suspend_time = read_persistent_clock();
 
 	write_seqlock_irqsave(&xtime_lock, flags);
-	/* Get the current xtime offset */
-	timekeeping_suspend_nsecs = __get_nsec_offset();
+	clocksource_forward_now();
 	timekeeping_suspended = 1;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -464,10 +459,10 @@ void update_wall_time(void)
 	 */
 	while (offset >= clock->cycle_interval) {
 		/* accumulate one interval */
-		clock->xtime_nsec += clock->xtime_interval;
-		clock->cycle_last += clock->cycle_interval;
 		offset -= clock->cycle_interval;
+		clock->cycle_last += clock->cycle_interval;
 
+		clock->xtime_nsec += clock->xtime_interval;
 		if (clock->xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
 			clock->xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
 			xtime.tv_sec++;

