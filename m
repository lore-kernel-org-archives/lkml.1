Return-Path: <linux-kernel-owner+w=401wt.eu-S932214AbXHXTDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbXHXTDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 15:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757610AbXHXTDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 15:03:44 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:35989 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831AbXHXTDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 15:03:43 -0400
Subject: [PATCH RT 3/3 - take two ] fix get_monotonic_cycles for latency
	tracer
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <1187978236.2941.19.camel@localhost.localdomain>
References: <1187978236.2941.19.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 24 Aug 2007 15:02:29 -0400
Message-Id: <1187982149.4574.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Added comment about not being able to take the xtime lock in  
 get_monotonic_cycles - suggested by John Stultz]

The latency tracer on SMP was given crazy results. It was found that the
get_monotonic_cycles that it uses was not returning a monotonic counter.
The cause of this was that clock->cycles_raw and clock->cycles_last can
be updated on another CPU and make the cycles_now variable out-of-date.
So the delta that was calculated from cycles_now - cycles_last was
incorrect.

This patch adds a loop to make sure that the cycles_raw and cycles_last
are consistent through out the calculation (otherwise it performs the
loop again).

With this patch the latency_tracer can produce normal results again.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6-rt/kernel/time/timekeeping.c
===================================================================
--- linux-2.6-rt.orig/kernel/time/timekeeping.c	2007-08-24 13:41:28.000000000 -0400
+++ linux-2.6-rt/kernel/time/timekeeping.c	2007-08-24 14:58:02.000000000 -0400
@@ -75,15 +75,35 @@ s64 __get_nsec_offset(void)
 
 cycle_t notrace get_monotonic_cycles(void)
 {
-	cycle_t cycle_now, cycle_delta;
+	cycle_t cycle_now, cycle_delta, cycle_raw, cycle_last;
 
-	/* read clocksource: */
-	cycle_now = clocksource_read(clock);
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
 
-	/* calculate the delta since the last update_wall_time: */
-	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+	} while (cycle_raw != clock->cycle_raw ||
+		 cycle_last != clock->cycle_last);
 
-	return clock->cycle_raw + cycle_delta;
+	return cycle_raw + cycle_delta;
 }
 
 unsigned long notrace cycles_to_usecs(cycle_t cycles)


