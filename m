Return-Path: <linux-kernel-owner+w=401wt.eu-S1758487AbYAIXe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487AbYAIXe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756915AbYAIXbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:31:05 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:53982 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004AbYAIXax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:30:53 -0500
Message-Id: <20080109233044.777564395@goodmis.org>
References: <20080109232914.676624725@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jan 2008 18:29:30 -0500
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
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
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

Index: linux-compile-i386.git/kernel/time/timekeeping.c
===================================================================
--- linux-compile-i386.git.orig/kernel/time/timekeeping.c	2008-01-09 14:27:26.000000000 -0500
+++ linux-compile-i386.git/kernel/time/timekeeping.c	2008-01-09 14:34:40.000000000 -0500
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
Index: linux-compile-i386.git/include/linux/clocksource.h
===================================================================
--- linux-compile-i386.git.orig/include/linux/clocksource.h	2008-01-09 14:27:51.000000000 -0500
+++ linux-compile-i386.git/include/linux/clocksource.h	2008-01-09 14:29:44.000000000 -0500
@@ -273,6 +273,9 @@ extern int clocksource_register(struct c
 extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
 extern void clocksource_resume(void);
+extern cycle_t get_monotonic_cycles(void);
+extern unsigned long cycles_to_usecs(cycle_t cycles);
+extern cycle_t usecs_to_cycles(unsigned long usecs);
 
 /* used to initialize clock */
 extern struct clocksource clocksource_jiffies;

-- 
