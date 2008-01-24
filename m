Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbYAXCjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbYAXCjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 21:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbYAXCjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 21:39:00 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43836 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbYAXCi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 21:38:59 -0500
Subject: [PATCH] correct inconsistent ntp interval/tick_length usage
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Roman Zippel <zippel@linux-m68k.org>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 18:38:53 -0800
Message-Id: <1201142334.6383.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently noticed on one of my boxes that when synched with an NTP
server, the drift value reported for the system was ~283ppm. While in
some cases, clock hardware can be that bad, it struck me as unusual as
the system was using the acpi_pm clocksource, which is one of the more
trustworthy and accurate clocksources on x86 hardware.

I brought up another system and let it sync to the same NTP server, and
I noticed a similar 280some ppm drift.

In looking at the code, I found that the acpi_pm's constant frequency
was being computed correctly at boot-up, however once the system was up,
even without the ntp daemon running, the clocksource's frequency was
being modified by the clocksource_adjust() function.

Digging deeper, I realized that in the code that keeps track of how much
the clocksource is skewing from the ntp desired time, we were using
different lengths to establish how long an time interval was. 

The clocksource was being setup with the following interval: 
	NTP_INTERVAL_LENGTH = NSEC_PER_SEC/NTP_INTERVAL_FREQ

While the ntp code was using the tick_length_base value:
	tick_length_base ~= (tick_usec * NSEC_PER_USEC * USER_HZ)
					/NTP_INTERVAL_FREQ

The subtle difference is:
	(tick_usec * NSEC_PER_USEC * USER_HZ) != NSEC_PER_SEC

This difference in calculation was causing the clocksource correction
code to apply a correction factor to the clocksource so the two
intervals were the same, however this results in the actual frequency of
the clocksource to be made incorrect. I believe this difference would
affect all clocksources, although to differing degrees depending on the
clocksource resolution.

The issue was introduced when my HZ free ntp patch landed in 2.6.21-rc1,
so my apologies for the mistake, and for not noticing it until now.

The following patch, corrects the clocksource's initialization code so
it uses the same interval length as the code in ntp.c. After applying
this patch, the drift value for the same system went from ~283ppm to
only 2.635ppm.

I believe this patch to be good, however it does affect all arches and
I've only tested on x86, so some caution is advised. I do think it would
be a likely candidate for a stable 2.6.24.x release.

Any thoughts or feedback would be appreciated.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

Index: linux/kernel/time/timekeeping.c
===================================================================
--- linux.orig/kernel/time/timekeeping.c
+++ linux/kernel/time/timekeeping.c
@@ -208,7 +208,8 @@ static void change_clocksource(void)
 
 	clock->error = 0;
 	clock->xtime_nsec = 0;
-	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
+	clocksource_calculate_interval(clock,
+		(unsigned long)(current_tick_length()>>TICK_LENGTH_SHIFT));
 
 	tick_clock_notify();
 
@@ -265,7 +266,8 @@ void __init timekeeping_init(void)
 	ntp_clear();
 
 	clock = clocksource_get_next();
-	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
+	clocksource_calculate_interval(clock,
+		(unsigned long)(current_tick_length()>>TICK_LENGTH_SHIFT));
 	clock->cycle_last = clocksource_read(clock);
 
 	xtime.tv_sec = sec;


