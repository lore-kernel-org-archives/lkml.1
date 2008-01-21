Return-Path: <linux-kernel-owner+w=401wt.eu-S1764149AbYAUPc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764149AbYAUPc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 10:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759334AbYAUPYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 10:24:55 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:42893 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758403AbYAUPYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 10:24:07 -0500
Message-Id: <20080121152352.632634796@goodmis.org>
References: <20080121152231.579118762@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 Jan 2008 10:22:42 -0500
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
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 11/23 -v4] add get_monotonic_cycles
Content-Disposition: inline; filename=get-monotonic-cycles.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latency tracer needs a way to get an accurate time
without grabbing any locks. Locks themselves might call
the latency tracer and cause at best a slow down.

This patch adds get_monotonic_cycles that returns cycles
from a reliable clock source in a monotonic fashion.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/clocksource.h |    3 ++
 kernel/time/timekeeping.c   |   48 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

Index: linux-mcount.git/include/linux/clocksource.h
===================================================================
--- linux-mcount.git.orig/include/linux/clocksource.h	2008-01-17 20:33:41.000000000 -0500
+++ linux-mcount.git/include/linux/clocksource.h	2008-01-17 20:33:43.000000000 -0500
@@ -273,6 +273,9 @@ extern int clocksource_register(struct c
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
--- linux-mcount.git.orig/kernel/time/timekeeping.c	2008-01-17 20:33:41.000000000 -0500
+++ linux-mcount.git/kernel/time/timekeeping.c	2008-01-17 20:33:43.000000000 -0500
@@ -103,6 +103,54 @@ static inline void __get_realtime_clock_
 	timespec_add_ns(ts, nsecs);
 }
 
+cycle_t notrace get_monotonic_cycles(void)
+{
+	cycle_t cycle_now, cycle_delta, cycle_raw, cycle_last;
+
+	do {
+		/*
+		 * cycle_raw and cycle_last can change on
+		 * another CPU and we need the delta calculation
+		 * of cycle_now and cycle_last happen atomic, as well
+		 * as the adding to cycle_raw. We don't need to grab
+		 * any locks, we just keep trying until get all the
+		 * calculations together in one state.
+		 *
+		 * In fact, we __cant__ grab any locks. This
+		 * function is called from the latency_tracer which can
+		 * be called anywhere. To grab any locks (including
+		 * seq_locks) we risk putting ourselves into a deadlock.
+		 */
+		cycle_raw = clock->cycle_raw;
+		cycle_last = clock->cycle_last;
+
+		/* read clocksource: */
+		cycle_now = clocksource_read(clock);
+
+		/* calculate the delta since the last update_wall_time: */
+		cycle_delta = (cycle_now - cycle_last) & clock->mask;
+
+	} while (cycle_raw != clock->cycle_raw ||
+		 cycle_last != clock->cycle_last);
+
+	return cycle_raw + cycle_delta;
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
