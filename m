Return-Path: <linux-kernel-owner+w=401wt.eu-S933788AbZGQAPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788AbZGQAPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933715AbZGQAPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:15:09 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53364 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933689AbZGQAPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:15:05 -0400
Subject: [RESEND][PATCH] Convert m32r to use arch_gettimeoffset()
From: john stultz <johnstul@us.ibm.com>
To: takata@linux-m32r.org
Cc: lkml <linux-kernel@vger.kernel.org>, linux-m32r@ml.linux-m32r.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1244758210.7192.5.camel@localhost.localdomain>
References: <1244758210.7192.5.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 17:09:55 -0700
Message-Id: <1247789395.7398.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts m32r to use GENERIC_TIME via the arch_getoffset()
infrastructure, reducing the amount of arch specific code we need to
maintain.

I also noted that m32r doesn't seem to be taking the xtime write lock
before calling do_timer()!  That looks like a pretty bad bug to me. If
folks agree, let me know and I can move the lock grab to the correct
spot.

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
 kernel/time.c |   74 ++--------------------------------------------------------
 2 files changed, 9 insertions(+), 71 deletions(-)

diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index cabba33..c41234f 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -41,6 +41,12 @@ config HZ
 	int
 	default 100
 
+config GENERIC_TIME
+	def_bool y
+
+config ARCH_USES_GETTIMEOFFSET
+	def_bool y
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff --git a/arch/m32r/kernel/time.c b/arch/m32r/kernel/time.c
index cada3ba..ba61c4c 100644
--- a/arch/m32r/kernel/time.c
+++ b/arch/m32r/kernel/time.c
@@ -48,7 +48,7 @@ extern void smp_local_timer_interrupt(void);
 
 static unsigned long latch;
 
-static unsigned long do_gettimeoffset(void)
+u32 arch_gettimeoffset(void)
 {
 	unsigned long  elapsed_time = 0;  /* [us] */
 
@@ -93,79 +93,10 @@ static unsigned long do_gettimeoffset(void)
 #error no chip configuration
 #endif
 
-	return elapsed_time;
+	return elapsed_time * 1000;
 }
 
 /*
- * This version of gettimeofday has near microsecond resolution.
- */
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long seq;
-	unsigned long usec, sec;
-	unsigned long max_ntp_tick = tick_usec - tickadj;
-
-	do {
-		seq = read_seqbegin(&xtime_lock);
-
-		usec = do_gettimeoffset();
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
-		usec += (xtime.tv_nsec / 1000);
-	} while (read_seqretry(&xtime_lock, seq));
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
- 	long wtm_nsec, nsec = tv->tv_nsec;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irq(&xtime_lock);
-	/*
-	 * This is revolting. We need to set "xtime" correctly. However, the
-	 * value in this location is the value at the most recent update of
-	 * wall time.  Discover what correction gettimeofday() would have
-	 * made, and then undo it!
-	 */
-	nsec -= do_gettimeoffset() * NSEC_PER_USEC;
-
-	wtm_sec = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-
-	return 0;
-}
-
-EXPORT_SYMBOL(do_settimeofday);
-
-/*
  * In order to set the CMOS clock precisely, set_rtc_mmss has to be
  * called 500 ms after the second nowtime has started, because when
  * nowtime is written into the registers of the CMOS clock, it will
@@ -192,6 +123,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 #ifndef CONFIG_SMP
 	profile_tick(CPU_PROFILING);
 #endif
+	/* XXX FIXME. Uh, the xtime_lock should be held here, no? */
 	do_timer(1);
 
 #ifndef CONFIG_SMP


