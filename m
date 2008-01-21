Return-Path: <linux-kernel-owner+w=401wt.eu-S932123AbYAUP3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbYAUP3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 10:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760654AbYAUPYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 10:24:46 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:49283 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791AbYAUPYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 10:24:04 -0500
Message-Id: <20080121152352.789802471@goodmis.org>
References: <20080121152231.579118762@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 Jan 2008 10:22:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       John Stultz <johstul@us.ibm.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 12/23 -v4] Use RCU algorithm for monotonic cycles.
Content-Disposition: inline; filename=get-monotonic-rcu-experimental.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: john stultz <johnstul@us.ibm.com>

On Wed, 2008-01-16 at 18:39 -0500, Mathieu Desnoyers wrote:
> I would disable preemption in clocksource_get_basecycles. We would not
> want to be scheduled out while we hold a pointer to the old array
> element.
> 
> > +	int num = cs->base_num;
> 
> Since you deal with base_num in a shared manner (not per cpu), you will
> need a smp_read_barrier_depend() here after the cs->base_num read.
> 
> You should think about reading the cs->base_num first, and _after_ that
> read the real clocksource. Here, the clocksource value is passed as
> parameter. It means that the read clocksource may have been read in the
> previous RCU window.

Here's an updated version of the patch w/ the suggested memory barrier
changes and favored (1-x) inversion change. ;)  Let me know if you see
any other holes, or have any other suggestions or ideas.

Still un-tested (my test box will free up soon, I promise!), but builds.

[ Steven Rostedt has been running this patch with no problems ]

Signed-off-by: John Stultz <johstul@us.ibm.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>

---
 include/linux/clocksource.h |   50 +++++++++++++++++++++++++++++++++++---------
 kernel/time/timekeeping.c   |   36 ++++---------------------------
 2 files changed, 45 insertions(+), 41 deletions(-)

Index: linux-mcount.git/include/linux/clocksource.h
===================================================================
--- linux-mcount.git.orig/include/linux/clocksource.h	2008-01-18 23:48:45.000000000 -0500
+++ linux-mcount.git/include/linux/clocksource.h	2008-01-18 23:48:46.000000000 -0500
@@ -87,9 +87,17 @@ struct clocksource {
 	 * more than one cache line.
 	 */
 	struct {
-		cycle_t cycle_last, cycle_accumulated, cycle_raw;
-	} ____cacheline_aligned_in_smp;
+		cycle_t cycle_last, cycle_accumulated;
 
+		/* base structure provides lock-free read
+		 * access to a virtualized 64bit counter
+		 * Uses RCU-like update.
+		 */
+		struct {
+			cycle_t cycle_base_last, cycle_base;
+		} base[2];
+		int base_num;
+	} ____cacheline_aligned_in_smp;
 	u64 xtime_nsec;
 	s64 error;
 
@@ -175,19 +183,29 @@ static inline cycle_t clocksource_read(s
 }
 
 /**
- * clocksource_get_cycles: - Access the clocksource's accumulated cycle value
+ * clocksource_get_basecycles: - get the clocksource's accumulated cycle value
  * @cs:		pointer to clocksource being read
  * @now:	current cycle value
  *
  * Uses the clocksource to return the current cycle_t value.
  * NOTE!!!: This is different from clocksource_read, because it
- * returns the accumulated cycle value! Must hold xtime lock!
+ * returns a 64bit wide accumulated value.
  */
 static inline cycle_t
-clocksource_get_cycles(struct clocksource *cs, cycle_t now)
+clocksource_get_basecycles(struct clocksource *cs)
 {
-	cycle_t offset = (now - cs->cycle_last) & cs->mask;
-	offset += cs->cycle_accumulated;
+	int num;
+	cycle_t now, offset;
+
+	preempt_disable();
+	num = cs->base_num;
+	smp_read_barrier_depends();
+	now = clocksource_read(cs);
+	offset = (now - cs->base[num].cycle_base_last);
+	offset &= cs->mask;
+	offset += cs->base[num].cycle_base;
+	preempt_enable();
+
 	return offset;
 }
 
@@ -197,14 +215,26 @@ clocksource_get_cycles(struct clocksourc
  * @now:	current cycle value
  *
  * Used to avoids clocksource hardware overflow by periodically
- * accumulating the current cycle delta. Must hold xtime write lock!
+ * accumulating the current cycle delta. Uses RCU-like update, but
+ * ***still requires the xtime_lock is held for writing!***
  */
 static inline void clocksource_accumulate(struct clocksource *cs, cycle_t now)
 {
-	cycle_t offset = (now - cs->cycle_last) & cs->mask;
+	/* First update the monotonic base portion.
+	 * The dual array update method allows for lock-free reading.
+	 */
+	int num = 1 - cs->base_num;
+	cycle_t offset = (now - cs->base[1-num].cycle_base_last);
+	offset &= cs->mask;
+	cs->base[num].cycle_base = cs->base[1-num].cycle_base + offset;
+	cs->base[num].cycle_base_last = now;
+	wmb();
+	cs->base_num = num;
+
+	/* Now update the cycle_accumulated portion */
+	offset = (now - cs->cycle_last) & cs->mask;
 	cs->cycle_last = now;
 	cs->cycle_accumulated += offset;
-	cs->cycle_raw += offset;
 }
 
 /**
Index: linux-mcount.git/kernel/time/timekeeping.c
===================================================================
--- linux-mcount.git.orig/kernel/time/timekeeping.c	2008-01-18 23:48:45.000000000 -0500
+++ linux-mcount.git/kernel/time/timekeeping.c	2008-01-18 23:48:46.000000000 -0500
@@ -71,10 +71,12 @@ static struct clocksource *clock = &cloc
  */
 static inline s64 __get_nsec_offset(void)
 {
-	cycle_t cycle_delta;
+	cycle_t now, cycle_delta;
 	s64 ns_offset;
 
-	cycle_delta = clocksource_get_cycles(clock, clocksource_read(clock));
+	now = clocksource_read(clock);
+	cycle_delta = (now - clock->cycle_last) & clock->mask;
+	cycle_delta += clock->cycle_accumulated;
 	ns_offset = cyc2ns(clock, cycle_delta);
 
 	return ns_offset;
@@ -105,35 +107,7 @@ static inline void __get_realtime_clock_
 
 cycle_t notrace get_monotonic_cycles(void)
 {
-	cycle_t cycle_now, cycle_delta, cycle_raw, cycle_last;
-
-	do {
-		/*
-		 * cycle_raw and cycle_last can change on
-		 * another CPU and we need the delta calculation
-		 * of cycle_now and cycle_last happen atomic, as well
-		 * as the adding to cycle_raw. We don't need to grab
-		 * any locks, we just keep trying until get all the
-		 * calculations together in one state.
-		 *
-		 * In fact, we __cant__ grab any locks. This
-		 * function is called from the latency_tracer which can
-		 * be called anywhere. To grab any locks (including
-		 * seq_locks) we risk putting ourselves into a deadlock.
-		 */
-		cycle_raw = clock->cycle_raw;
-		cycle_last = clock->cycle_last;
-
-		/* read clocksource: */
-		cycle_now = clocksource_read(clock);
-
-		/* calculate the delta since the last update_wall_time: */
-		cycle_delta = (cycle_now - cycle_last) & clock->mask;
-
-	} while (cycle_raw != clock->cycle_raw ||
-		 cycle_last != clock->cycle_last);
-
-	return cycle_raw + cycle_delta;
+	return clocksource_get_basecycles(clock);
 }
 
 unsigned long notrace cycles_to_usecs(cycle_t cycles)

-- 
