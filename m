Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbZA2EK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbZA2EK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 23:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbZA2EKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 23:10:47 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:49716 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbZA2EKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 23:10:46 -0500
Subject: [RFC][PATCH 8/10] Convert sparc to use arch_getoffset()
	infrastructure.
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: rmk+lkml@arm.linux.org.uk, cooloney@kernel.org, starvik@axis.com,
       takata@linux-m32r.org, geert@linux-m68k.org,
       Roman Zippel <zippel@linux-m68k.org>, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
       chris@zankel.net, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1233202206.6895.43.camel@localhost.localdomain>
References: <1233201926.6895.25.camel@localhost.localdomain>
	 <1233201995.6895.27.camel@localhost.localdomain>
	 <1233202037.6895.30.camel@localhost.localdomain>
	 <1233202074.6895.33.camel@localhost.localdomain>
	 <1233202104.6895.35.camel@localhost.localdomain>
	 <1233202139.6895.38.camel@localhost.localdomain>
	 <1233202175.6895.40.camel@localhost.localdomain>
	 <1233202206.6895.43.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 20:10:41 -0800
Message-Id: <1233202241.6895.45.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts sparc to use GENERIC_TIME via the arch_getoffset()
infrastructure 

I do not have cross compilers for these architectures, and in some cases
the architectures can be compiles both with and without clocksources. So
I've taken my best swing at converting this, but I'm not confident I got
it right. Any assistance from arch maintainers or testers would be
great.

Signed-off-by: John Stultz <johnstul@us.ibm.com>


diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index c3ea215..a5b465f 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -55,8 +55,11 @@ config BITS
 	default 64 if SPARC64
 
 config GENERIC_TIME
+	def_bool y
+
+config ARCH_USES_GETTIMEOFFSET
 	bool
-	default y if SPARC64
+	default y if SPARC32
 
 config GENERIC_CMOS_UPDATE
 	bool
diff --git a/arch/sparc/kernel/time_32.c b/arch/sparc/kernel/time_32.c
index 614ac7b..e946b55 100644
--- a/arch/sparc/kernel/time_32.c
+++ b/arch/sparc/kernel/time_32.c
@@ -227,7 +227,7 @@ void __init time_init(void)
 	sbus_time_init();
 }
 
-static inline unsigned long do_gettimeoffset(void)
+u32 arch_gettimeoffset(void)
 {
 	unsigned long val = *master_l10_counter;
 	unsigned long usec = (val >> 10) & 0x1fffff;
@@ -236,84 +236,7 @@ static inline unsigned long do_gettimeoffset(void)
 	if (val & 0x80000000)
 		usec += 1000000 / HZ;
 
-	return usec;
-}
-
-/* Ok, my cute asm atomicity trick doesn't work anymore.
- * There are just too many variables that need to be protected
- * now (both members of xtime, et al.)
- */
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long flags;
-	unsigned long seq;
-	unsigned long usec, sec;
-	unsigned long max_ntp_tick = tick_usec - tickadj;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
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
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
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
-	int ret;
-
-	write_seqlock_irq(&xtime_lock);
-	ret = bus_do_settimeofday(tv);
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-	return ret;
-}
-
-EXPORT_SYMBOL(do_settimeofday);
-
-static int sbus_do_settimeofday(struct timespec *tv)
-{
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	/*
-	 * This is revolting. We need to set "xtime" correctly. However, the
-	 * value in this location is the value at the most recent update of
-	 * wall time.  Discover what correction gettimeofday() would have
-	 * made, and then undo it!
-	 */
-	nsec -= 1000 * do_gettimeoffset();
-
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-	return 0;
+	return usec * 1000;
 }
 
 static int set_rtc_mmss(unsigned long secs)


