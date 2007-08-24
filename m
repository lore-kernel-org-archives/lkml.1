Return-Path: <linux-kernel-owner+w=401wt.eu-S1764780AbXHXR6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764780AbXHXR6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764089AbXHXR54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:57:56 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:35498 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762025AbXHXR5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:57:55 -0400
Subject: [PATCH RT 1/3]  time keeping add cycle_raw for actual
	incrementation
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Content-Type: text/plain
Date: Fri, 24 Aug 2007 13:57:09 -0400
Message-Id: <1187978229.2941.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The get_monotonic_cycles needs to produce a monotonic counter as output.
Currently it uses cycles_last as the base to add the delta too.
cycles_last only is the counter that was last measured and is cyclic in
nature (not monotonic).

This patch adds a cycle_raw to produce an accumulative counter.
Unfortunately there is already an cycle_accumulate variable, but that is
used to avoid clock source overflow and can also be decremented
(probably that name should be changed and we should use that for this
patch).


From: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>



Index: linux-2.6-rt/include/linux/clocksource.h
===================================================================
--- linux-2.6-rt.orig/include/linux/clocksource.h	2007-08-24 11:35:27.000000000 -0400
+++ linux-2.6-rt/include/linux/clocksource.h	2007-08-24 11:35:36.000000000 -0400
@@ -77,7 +77,7 @@ struct clocksource {
 	void (*resume)(void);
 
 	/* timekeeping specific data, ignore */
-	cycle_t cycle_accumulated, cycle_interval;
+	cycle_t cycle_accumulated, cycle_interval, cycle_raw;
 	u64	xtime_interval;
 	/*
 	 * Second part is written at each timer interrupt
@@ -198,6 +198,7 @@ static inline void clocksource_accumulat
 	cycle_t offset = (now - cs->cycle_last) & cs->mask;
 	cs->cycle_last = now;
 	cs->cycle_accumulated += offset;
+	cs->cycle_raw += offset;
 }
 
 /**
Index: linux-2.6-rt/kernel/time/timekeeping.c
===================================================================
--- linux-2.6-rt.orig/kernel/time/timekeeping.c	2007-08-24 11:35:27.000000000 -0400
+++ linux-2.6-rt/kernel/time/timekeeping.c	2007-08-24 11:35:47.000000000 -0400
@@ -75,7 +75,7 @@ cycle_t notrace get_monotonic_cycles(voi
 	/* calculate the delta since the last update_wall_time: */
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
-	return clock->cycle_last + cycle_delta;
+	return clock->cycle_raw + cycle_delta;
 }
 
 unsigned long notrace cycles_to_usecs(cycle_t cycles)



