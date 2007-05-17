Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbXEQSLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbXEQSLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbXEQSLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:11:32 -0400
Received: from h155.mvista.com ([63.81.120.155]:25027 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754114AbXEQSLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:11:31 -0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com> (by way of Sergei
	Shtylyov <sshtylyov@dev.rtsoft.ru>)
Organization: MontaVista Software Inc.
Subject: [PATCH 2.6.21-rt2] PowerPC: implement read_persistent_clock()
Date: Thu, 17 May 2007 22:13:01 +0400
User-Agent: KMail/1.5
To: tglx@linutronix.de, mingo@elte.hu
MIME-Version: 1.0
Content-Disposition: inline
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200705172213.01877.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the read_persistent_clock() implementation for PowerPC.

I'm deliberately renaming get_boot_time() despite it's not static as it
doesn't get called from anywhere else.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
Have almost forgotten about this one... :-)
This patch hasn't received a good testing though -- at least it doesn't break
without RTC... ;-)

 arch/powerpc/kernel/time.c |   62 ++++++++++++++++++++-------------------------
 1 files changed, 28 insertions(+), 34 deletions(-)

Index: linux-2.6/arch/powerpc/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/time.c
+++ linux-2.6/arch/powerpc/kernel/time.c
@@ -762,31 +762,46 @@ void __init generic_calibrate_decr(void)
 #endif
 }
 
-unsigned long get_boot_time(void)
+unsigned long read_persistent_clock(void)
 {
-	struct rtc_time tm;
+	unsigned long time = 0;
+	static int first = 1;
+
+	if (first && ppc_md.time_init) {
+		timezone_offset = ppc_md.time_init();
+
+		/* If platform provided a timezone (pmac), we correct the time */
+		if (timezone_offset) {
+			sys_tz.tz_minuteswest = -timezone_offset / 60;
+			sys_tz.tz_dsttime = 0;
+		}
+	}
 
 	if (ppc_md.get_boot_time)
-		return ppc_md.get_boot_time();
-	if (!ppc_md.get_rtc_time)
-		return 0;
-	ppc_md.get_rtc_time(&tm);
-	return mktime(tm.tm_year+1900, tm.tm_mon+1, tm.tm_mday,
-		      tm.tm_hour, tm.tm_min, tm.tm_sec);
+		time = ppc_md.get_boot_time();
+	else if (ppc_md.get_rtc_time) {
+		struct rtc_time tm;
+
+		ppc_md.get_rtc_time(&tm);
+		time = mktime(tm.tm_year+1900, tm.tm_mon+1, tm.tm_mday,
+			      tm.tm_hour, tm.tm_min, tm.tm_sec);
+	}
+	time -= timezone_offset;
+
+	if (first) {
+		last_rtc_update = time;
+		first = 0;
+	}
+	return time;
 }
 
 /* This function is only called on the boot processor */
 void __init time_init(void)
 {
-	unsigned long flags;
-	unsigned long tm = 0;
 	struct div_result res;
 	u64 scale, x;
 	unsigned shift;
 
-        if (ppc_md.time_init != NULL)
-                timezone_offset = ppc_md.time_init();
-
 	if (__USE_RTC()) {
 		/* 601 processor: dec counts down by 128 every 128ns */
 		ppc_tb_freq = 1000000000;
@@ -860,27 +875,6 @@ void __init time_init(void)
 	tb_to_ns_scale = scale;
 	tb_to_ns_shift = shift;
 
-	tm = get_boot_time();
-
-	write_seqlock_irqsave(&xtime_lock, flags);
-
-	/* If platform provided a timezone (pmac), we correct the time */
-        if (timezone_offset) {
-		sys_tz.tz_minuteswest = -timezone_offset / 60;
-		sys_tz.tz_dsttime = 0;
-		tm -= timezone_offset;
-        }
-
-	xtime.tv_sec = tm;
-	xtime.tv_nsec = 0;
-
-	time_freq = 0;
-
-	last_rtc_update = xtime.tv_sec;
-	set_normalized_timespec(&wall_to_monotonic,
-	                        -xtime.tv_sec, -xtime.tv_nsec);
-	write_sequnlock_irqrestore(&xtime_lock, flags);
-
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 	decrementer_clockevent.mult = div_sc(ppc_tb_freq, NSEC_PER_SEC,
 					     decrementer_clockevent.shift);

