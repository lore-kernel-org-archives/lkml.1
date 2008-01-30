Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbYA3COg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbYA3COg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 21:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbYA3CO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 21:14:27 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:54491 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYA3CO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 21:14:26 -0500
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
From: john stultz <johnstul@us.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <Pine.LNX.4.64.0801290439480.17507@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801251349120.17507@scrub.home>
	 <1201573686.6766.13.camel@localhost>
	 <Pine.LNX.4.64.0801290439480.17507@scrub.home>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 18:14:23 -0800
Message-Id: <1201659263.6766.40.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-29 at 05:02 +0100, Roman Zippel wrote:
> Hi,
> 
> On Mon, 28 Jan 2008, john stultz wrote:
> 
> > Regardless, current_tick_length() really is the base interval we're
> > using in the error accumulation loop, so it seems the cleanest interface
> > to use (just to avoid redundancy at least) when establishing the
> > clocksource's interval length. Or do you not agree?
> 
> I see, what you need to use in timex.h for !CONFIG_NO_HZ is:
> 
> #define NTP_INTERVAL_LENGTH ((s64)LATCH * NSEC_PER_SEC) / (s64)CLOCK_TICK_RATE)
> 
> this calculates the base length of a clock tick in nsec.
> 
> current_tick_length() would only work during boot. If you switch clocks 
> later, it would include random adjustments specific to the old clock.

Ah. Good point. How about the following, tested on x86_64 both with and
without CONFIG_NO_HZ?

Thanks for the review and feedback!
-john



Correct NTP drift caused by using inconsistent NTP_INTERVAL_LENGTHs in
clocksource initialization and error accumulation. This corrects a
280ppm drift seen on some systems using acpi_pm, and affects other
clocksources as well (likely to a lesser degree).


Signed-off-by: John Stultz <johnstul@us.ibm.com>


Index: linux/include/linux/timex.h
===================================================================
--- linux.orig/include/linux/timex.h
+++ linux/include/linux/timex.h
@@ -231,7 +231,13 @@ static inline int ntp_synced(void)
 #else
 #define NTP_INTERVAL_FREQ  (HZ)
 #endif
-#define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
+
+#define CLOCK_TICK_OVERFLOW	(LATCH * HZ - CLOCK_TICK_RATE)
+#define CLOCK_TICK_ADJUST	(((s64)CLOCK_TICK_OVERFLOW * NSEC_PER_SEC) / \
+					(s64)CLOCK_TICK_RATE)
+
+/* Because using NSEC_PER_SEC would be too easy */
+#define NTP_INTERVAL_LENGTH ((((s64)TICK_USEC*NSEC_PER_USEC*USER_HZ)+CLOCK_TICK_ADJUST)/NTP_INTERVAL_FREQ)
 
 /* Returns how long ticks are at present, in ns / 2^(SHIFT_SCALE-10). */
 extern u64 current_tick_length(void);
Index: linux/kernel/time/ntp.c
===================================================================
--- linux.orig/kernel/time/ntp.c
+++ linux/kernel/time/ntp.c
@@ -43,10 +43,6 @@ long time_freq;				/* frequency offset (
 static long time_reftime;		/* time at last adjustment (s)	*/
 long time_adjust;
 
-#define CLOCK_TICK_OVERFLOW	(LATCH * HZ - CLOCK_TICK_RATE)
-#define CLOCK_TICK_ADJUST	(((s64)CLOCK_TICK_OVERFLOW * NSEC_PER_SEC) / \
-					(s64)CLOCK_TICK_RATE)
-
 static void ntp_update_frequency(void)
 {
 	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)


