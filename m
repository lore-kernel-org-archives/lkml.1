Return-Path: <linux-kernel-owner+w=401wt.eu-S1764116AbYBPBjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764116AbYBPBjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 20:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbYBPBi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 20:38:58 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:35881 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762970AbYBPBis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 20:38:48 -0500
Subject: [PATCH 2/3] Fixup ntp interval len merges
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Josip Loncaric <josip@lanl.gov>, Roman Zippel <zippel@linux-m68k.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1203125191.6275.20.camel@jstultz-laptop>
References: <1203125191.6275.20.camel@jstultz-laptop>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 17:38:42 -0800
Message-Id: <1203125922.6275.33.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My first version of the ntp_interval/tick_length inconsistent usage
patch was recently merged as bbe4d18ac2e058c56adb0cd71f49d9ed3216a405

http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=bbe4d18ac2e058c56adb0cd71f49d9ed3216a405

While the fix did greatly improve the situation, Roman correctly pointed
out that it does have a small bug: If the users change clocksources
after the system has been running and NTP has made corrections, the
correctoins made against the old clocksource will be applied against the
new clocksource, causing error.

This patch reverts this previous fix. 


My second attempt, which corrects the issue in the NTP_INTERVAL_LENGTH
definition has also made it up-stream as commit
e13a2e61dd5152f5499d2003470acf9c838eab84

http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e13a2e61dd5152f5499d2003470acf9c838eab84

However, due to the original patch going upstream, the second has no
effect.  So by reverting the first fix, the second will be in use.

It should be noted that Roman has voiced objections to this second patch
as well, and we are continuing to work out the details. However, due to
the severity of the ntp error which both of these patches tries to
address, I'd recommend the second patch remain in place until we come to
an agreed solution.


thanks
-john

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 5b11b0f..cb17979 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
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


