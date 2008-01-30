Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbYA3DVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbYA3DVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 22:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbYA3DTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 22:19:03 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:49362 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbYA3DSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 22:18:50 -0500
Message-Id: <20080130031841.309776679@goodmis.org>
References: <20080130031521.258552785@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jan 2008 22:15:29 -0500
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
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 08/22 -v7] add get_monotonic_cycles
Content-Disposition: inline; filename=get-monotonic-cycles.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latency tracer needs a way to get an accurate time
without grabbing any locks. Locks themselves might call
the latency tracer and cause at best a slow down.

This patch adds get_monotonic_cycles that returns cycles
from a reliable clock source in a monotonic fashion.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/clocksource.h |   54 +++++++++++++++++++++++++++++++++++++-------
 kernel/time/timekeeping.c   |   26 +++++++++++++++++++--
 2 files changed, 70 insertions(+), 10 deletions(-)

Index: linux-mcount.git/include/linux/clocksource.h
===================================================================
--- linux-mcount.git.orig/include/linux/clocksource.h	2008-01-25 21:47:11.000000000 -0500
+++ linux-mcount.git/include/linux/clocksource.h	2008-01-25 21:47:13.000000000 -0500
@@ -88,8 +88,16 @@ struct clocksource {
 	 */
 	struct {
 		cycle_t cycle_last, cycle_accumulated;
-	} ____cacheline_aligned_in_smp;
 
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
 
@@ -175,19 +183,30 @@ static inline cycle_t clocksource_read(s
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
+	/* base_num is shared, and some archs are wacky */
+	smp_read_barrier_depends();
+	now = clocksource_read(cs);
+	offset = (now - cs->base[num].cycle_base_last);
+	offset &= cs->mask;
+	offset += cs->base[num].cycle_base;
+	preempt_enable();
+
 	return offset;
 }
 
@@ -197,11 +216,27 @@ clocksource_get_cycles(struct clocksourc
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
+	/*
+	 * First update the monotonic base portion.
+	 * The dual array update method allows for lock-free reading.
+	 * 'num' is always 1 or 0.
+	 */
+	int num = 1 - cs->base_num;
+	cycle_t offset = (now - cs->base[1-num].cycle_base_last);
+	offset &= cs->mask;
+	cs->base[num].cycle_base = cs->base[1-num].cycle_base + offset;
+	cs->base[num].cycle_base_last = now;
+	/* make sure this array is visible to the world first */
+	smp_wmb();
+	cs->base_num = num;
+
+	/* Now update the cycle_accumulated portion */
+	offset = (now - cs->cycle_last) & cs->mask;
 	cs->cycle_last = now;
 	cs->cycle_accumulated += offset;
 }
@@ -272,6 +307,9 @@ extern int clocksource_register(struct c
 extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
 extern void clocksource_resume(void);
+extern cycle_t get_monotonic_cycles(void);
+extern unsigned long cycles_to_usecs(cycle_t cycles);
+extern cycle_t usecs_to_cycles(unsigned long usecs);
 
 /* used to initialize clock */
 extern struct clocksource clocksource_jiffies;
Index: linux-mcount.git/kernel/time/timekeeping.c
===================================================================
--- linux-mcount.git.orig/kernel/time/timekeeping.c	2008-01-25 21:47:11.000000000 -0500
+++ linux-mcount.git/kernel/time/timekeeping.c	2008-01-25 21:47:13.000000000 -0500
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
@@ -103,6 +105,26 @@ static inline void __get_realtime_clock_
 	timespec_add_ns(ts, nsecs);
 }
 
+cycle_t notrace get_monotonic_cycles(void)
+{
+	return clocksource_get_basecycles(clock);
+}
+
+unsigned long notrace cycles_to_usecs(cycle_t cycles)
+{
+	u64 ret = cyc2ns(clock, cycles);
+
+	ret += NSEC_PER_USEC/2; /* For rounding in do_div() */
+	do_div(ret, NSEC_PER_USEC);
+
+	return ret;
+}
+
+cycle_t notrace usecs_to_cycles(unsigned long usecs)
+{
+	return ns2cyc(clock, (u64)usecs * 1000);
+}
+
 /**
  * getnstimeofday - Returns the time of day in a timespec
  * @ts:		pointer to the timespec to be set

-- 
