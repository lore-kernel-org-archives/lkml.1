Return-Path: <linux-kernel-owner+w=401wt.eu-S933846AbZGQAVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846AbZGQAVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933715AbZGQAVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:21:36 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54960 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933687AbZGQAVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:21:36 -0400
Subject: [PATCH] Convert m68k to use arch_gettimeoffset()
From: john stultz <johnstul@us.ibm.com>
To: geert@linux-m68k.org, Roman Zippel <zippel@linux-m68k.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org
In-Reply-To: <1244758210.7192.5.camel@localhost.localdomain>
References: <1244758210.7192.5.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 17:20:51 -0700
Message-Id: <1247790051.7398.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts m68k to use GENERIC_TIME via the arch_getoffset()
infrastructure, reducing the amount of arch specific code we need to
maintain.

This patch applies on top of Linus' current -git tree (2.6.31-rc3).

I've taken my best swing at converting this, but I'm not 100% confident
I got it right. My cross-compiler is now out of date (gcc4.2) so I
wasn't able to  check if it compiled. Any assistance from arch
maintainers or testers to get this merged would be great.

thanks
-john

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 Kconfig       |    6 ++++
 kernel/time.c |   70 +---------------------------------------------------------
 2 files changed, 8 insertions(+), 68 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index fb87c08..29dd848 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -58,6 +58,12 @@ config HZ
 	int
 	default 100
 
+config GENERIC_TIME
+	def_bool y
+
+config ARCH_USES_GETTIMEOFFSET
+	def_bool y
+
 mainmenu "Linux/68k Kernel Configuration"
 
 source "init/Kconfig"
diff --git a/arch/m68k/kernel/time.c b/arch/m68k/kernel/time.c
index 54d9807..17dc2a3 100644
--- a/arch/m68k/kernel/time.c
+++ b/arch/m68k/kernel/time.c
@@ -91,77 +91,11 @@ void __init time_init(void)
 	mach_sched_init(timer_interrupt);
 }
 
-/*
- * This version of gettimeofday has near microsecond resolution.
- */
-void do_gettimeofday(struct timeval *tv)
+u32 arch_gettimeoffset(void)
 {
-	unsigned long flags;
-	unsigned long seq;
-	unsigned long usec, sec;
-	unsigned long max_ntp_tick = tick_usec - tickadj;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-
-		usec = mach_gettimeoffset();
-
-		/*
-		 * If time_adjust is negative then NTP is slowing the clock
-		 * so make sure not to go into next possible interval.
-		 * Better to lose some accuracy than have time go backwards..
-		 */
-		if (unlikely(time_adjust < 0))
-			usec = min(usec, max_ntp_tick);
-
-		sec = xtime.tv_sec;
-		usec += xtime.tv_nsec/1000;
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
-
-	while (usec >= 1000000) {
-		usec -= 1000000;
-		sec++;
-	}
-
-	tv->tv_sec = sec;
-	tv->tv_usec = usec;
-}
-
-EXPORT_SYMBOL(do_gettimeofday);
-
-int do_settimeofday(struct timespec *tv)
-{
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irq(&xtime_lock);
-	/* This is revolting. We need to set the xtime.tv_nsec
-	 * correctly. However, the value in this location is
-	 * is value at the last tick.
-	 * Discover what correction gettimeofday
-	 * would have done, and then undo it!
-	 */
-	nsec -= 1000 * mach_gettimeoffset();
-
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-	return 0;
+	return mach_gettimeoffset() * 1000;
 }
 
-EXPORT_SYMBOL(do_settimeofday);
-
-
 static int __init rtc_init(void)
 {
 	struct platform_device *pdev;


