Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbYB2Ety@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbYB2Ety (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 23:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754438AbYB2Etq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 23:49:46 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:52155 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104AbYB2Etp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 23:49:45 -0500
Date: Fri, 29 Feb 2008 05:49:35 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] Remove obsolete CLOCK_TICK_ADJUST
In-Reply-To: <1203647951.6150.80.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0802290547320.2723@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0801251349120.17507@scrub.home>  <1201573686.6766.13.camel@localhost>
  <Pine.LNX.4.64.0801290439480.17507@scrub.home>  <1201659263.6766.40.camel@localhost>
  <Pine.LNX.4.64.0801310251090.17507@scrub.home>  <1201745776.6195.14.camel@localhost.localdomain>
  <Pine.LNX.4.64.0801310404480.17507@scrub.home>  <1201914175.6216.46.camel@jstultz-laptop>
  <Pine.LNX.4.64.0802081718040.3378@scrub.home>  <1202523452.6174.45.camel@localhost.localdomain>
  <Pine.LNX.4.64.0802101917030.3378@scrub.home>  <1202774999.5984.106.camel@localhost>
  <Pine.LNX.4.64.0802120335170.3378@scrub.home>  <1202963796.6195.141.camel@localhost.localdomain>
  <Pine.LNX.4.64.0802150436300.1822@scrub.home>  <1203382940.5984.242.camel@localhost>
  <Pine.LNX.4.64.0802190219360.2723@scrub.home>  <1203472250.6123.98.camel@localhost>
  <Pine.LNX.4.64.0802200348230.2723@scrub.home> <1203647951.6150.80.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Can we please clean up the current mess and get the patch below merged?

bye, Roman


Revert bbe4d18ac2e058c56adb0cd71f49d9ed3216a405 and
e13a2e61dd5152f5499d2003470acf9c838eab84 and remove CLOCK_TICK_ADJUST
completely. Add a optional kernel parameter ntp_tick_adj instead to allow
adjusting of a large base drift and thus keeping ntpd happy.
The CLOCK_TICK_ADJUST mechanism was introduced at a time PIT was the
primary clock, but we have a varity of clock sources now, so a global PIT
specific adjustment makes little sense anymore.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 include/linux/timex.h     |    9 +--------
 kernel/time/ntp.c         |   11 ++++++++++-
 kernel/time/timekeeping.c |    6 ++----
 3 files changed, 13 insertions(+), 13 deletions(-)

Index: linux-2.6/include/linux/timex.h
===================================================================
--- linux-2.6.orig/include/linux/timex.h
+++ linux-2.6/include/linux/timex.h
@@ -232,14 +232,7 @@ static inline int ntp_synced(void)
 #else
 #define NTP_INTERVAL_FREQ  (HZ)
 #endif
-
-#define CLOCK_TICK_OVERFLOW	(LATCH * HZ - CLOCK_TICK_RATE)
-#define CLOCK_TICK_ADJUST	(((s64)CLOCK_TICK_OVERFLOW * NSEC_PER_SEC) / \
-					(s64)CLOCK_TICK_RATE)
-
-/* Because using NSEC_PER_SEC would be too easy */
-#define NTP_INTERVAL_LENGTH ((((s64)TICK_USEC * NSEC_PER_USEC * USER_HZ) + \
-			      CLOCK_TICK_ADJUST) / NTP_INTERVAL_FREQ)
+#define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
 
 /* Returns how long ticks are at present, in ns / 2^(SHIFT_SCALE-10). */
 extern u64 current_tick_length(void);
Index: linux-2.6/kernel/time/ntp.c
===================================================================
--- linux-2.6.orig/kernel/time/ntp.c
+++ linux-2.6/kernel/time/ntp.c
@@ -42,12 +42,13 @@ long time_esterror = NTP_PHASE_LIMIT;	/*
 long time_freq;				/* frequency offset (scaled ppm)*/
 static long time_reftime;		/* time at last adjustment (s)	*/
 long time_adjust;
+long ntp_tick_adj;
 
 static void ntp_update_frequency(void)
 {
 	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
 				<< TICK_LENGTH_SHIFT;
-	second_length += (s64)CLOCK_TICK_ADJUST << TICK_LENGTH_SHIFT;
+	second_length += (s64)ntp_tick_adj << TICK_LENGTH_SHIFT;
 	second_length += (s64)time_freq << (TICK_LENGTH_SHIFT - SHIFT_NSEC);
 
 	tick_length_base = second_length;
@@ -400,3 +401,11 @@ leave:	if ((time_status & (STA_UNSYNC|ST
 	notify_cmos_timer();
 	return(result);
 }
+
+static int __init ntp_tick_adj_setup(char *str)
+{
+	ntp_tick_adj = simple_strtol(str, NULL, 0);
+	return 1;
+}
+
+__setup("ntp_tick_adj=", ntp_tick_adj_setup);
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -187,8 +187,7 @@ static void change_clocksource(void)
 
 	clock->error = 0;
 	clock->xtime_nsec = 0;
-	clocksource_calculate_interval(clock,
-		(unsigned long)(current_tick_length()>>TICK_LENGTH_SHIFT));
+	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 
 	tick_clock_notify();
 
@@ -245,8 +244,7 @@ void __init timekeeping_init(void)
 	ntp_clear();
 
 	clock = clocksource_get_next();
-	clocksource_calculate_interval(clock,
-		(unsigned long)(current_tick_length()>>TICK_LENGTH_SHIFT));
+	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 	clock->cycle_last = clocksource_read(clock);
 
 	xtime.tv_sec = sec;
