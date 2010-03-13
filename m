Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935186Ab0CMAWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:22:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:47135 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935162Ab0CMAWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:22:12 -0500
Date: Sat, 13 Mar 2010 00:21:15 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, johnstul@us.ibm.com, takata@linux-m32r.org,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, akpm@linux-foundation.org, tglx@linutronix.de,
       takata@linux-m32r.org
In-Reply-To: <1267675049-12337-11-git-send-email-johnstul@us.ibm.com>
References: <1267675049-12337-11-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] m32r: Convert m32r to use read/update_peristent_clock
Message-ID: <tip-944694716d6ea3c274a73c830bf33e194bad4bcd@git.kernel.org>
Git-Commit-ID: 944694716d6ea3c274a73c830bf33e194bad4bcd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 13 Mar 2010 00:21:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  944694716d6ea3c274a73c830bf33e194bad4bcd
Gitweb:     http://git.kernel.org/tip/944694716d6ea3c274a73c830bf33e194bad4bcd
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Wed, 3 Mar 2010 19:57:25 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 13 Mar 2010 01:14:12 +0100

m32r: Convert m32r to use read/update_peristent_clock

This patch converts the m32r architecture to use the generic
read_persistent_clock and update_persistent_clock interfaces, reducing
the amount of arch specific code we have to maintain, and allowing for
further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers
would be appreciated.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1267675049-12337-11-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m32r/kernel/time.c |   47 +++++++----------------------------------------
 1 files changed, 7 insertions(+), 40 deletions(-)

diff --git a/arch/m32r/kernel/time.c b/arch/m32r/kernel/time.c
index 9cedcef..bda8682 100644
--- a/arch/m32r/kernel/time.c
+++ b/arch/m32r/kernel/time.c
@@ -106,24 +106,6 @@ u32 arch_gettimeoffset(void)
 }
 
 /*
- * In order to set the CMOS clock precisely, set_rtc_mmss has to be
- * called 500 ms after the second nowtime has started, because when
- * nowtime is written into the registers of the CMOS clock, it will
- * jump to the next second precisely 500 ms later. Check the Motorola
- * MC146818A or Dallas DS12887 data sheet for details.
- *
- * BUG: This routine does not handle hour overflow properly; it just
- *      sets the minutes. Usually you won't notice until after reboot!
- */
-static inline int set_rtc_mmss(unsigned long nowtime)
-{
-	return 0;
-}
-
-/* last time the cmos clock got updated */
-static long last_rtc_update = 0;
-
-/*
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
  */
@@ -138,23 +120,6 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
-	/*
-	 * If we have an externally synchronized Linux clock, then update
-	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
-	 * called as close as possible to 500 ms before the new second starts.
-	 */
-	write_seqlock(&xtime_lock);
-	if (ntp_synced()
-		&& xtime.tv_sec > last_rtc_update + 660
-		&& (xtime.tv_nsec / 1000) >= 500000 - ((unsigned)TICK_SIZE) / 2
-		&& (xtime.tv_nsec / 1000) <= 500000 + ((unsigned)TICK_SIZE) / 2)
-	{
-		if (set_rtc_mmss(xtime.tv_sec) == 0)
-			last_rtc_update = xtime.tv_sec;
-		else	/* do it again in 60 s */
-			last_rtc_update = xtime.tv_sec - 600;
-	}
-	write_sequnlock(&xtime_lock);
 	/* As we return to user mode fire off the other CPU schedulers..
 	   this is basically because we don't yet share IRQ's around.
 	   This message is rigged to be safe on the 386 - basically it's
@@ -174,7 +139,7 @@ static struct irqaction irq0 = {
 	.name = "MFT2",
 };
 
-void __init time_init(void)
+void read_persistent_clock(struct timespec *ts)
 {
 	unsigned int epoch, year, mon, day, hour, min, sec;
 
@@ -194,11 +159,13 @@ void __init time_init(void)
 		epoch = 1952;
 	year += epoch;
 
-	xtime.tv_sec = mktime(year, mon, day, hour, min, sec);
-	xtime.tv_nsec = (INITIAL_JIFFIES % HZ) * (NSEC_PER_SEC / HZ);
-	set_normalized_timespec(&wall_to_monotonic,
-		-xtime.tv_sec, -xtime.tv_nsec);
+	ts->tv_sec = mktime(year, mon, day, hour, min, sec);
+	ts->tv_nsec = (INITIAL_JIFFIES % HZ) * (NSEC_PER_SEC / HZ);
+}
 
+
+void __init time_init(void)
+{
 #if defined(CONFIG_CHIP_M32102) || defined(CONFIG_CHIP_XNUX2) \
 	|| defined(CONFIG_CHIP_VDEC2) || defined(CONFIG_CHIP_M32700) \
 	|| defined(CONFIG_CHIP_OPSP) || defined(CONFIG_CHIP_M32104)
