Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbZDOBvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbZDOBvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 21:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbZDOBvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 21:51:31 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60770 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZDOBva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 21:51:30 -0400
Subject: Re: [RFC][PATCH 7/8] Convert sparc to use arch_getoffset()
 infrastructure.
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>, davem@davemloft.net
Cc: rmk+lkml@arm.linux.org.uk, cooloney@kernel.org, starvik@axis.com,
       takata@linux-m32r.org, geert@linux-m68k.org,
       Roman Zippel <zippel@linux-m68k.org>, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
       rth@twiddle.net
In-Reply-To: <1239760000.6064.39.camel@localhost>
References: <1239759163.6064.25.camel@localhost>
	 <1239759251.6064.27.camel@localhost>  <1239759393.6064.30.camel@localhost>
	 <1239759551.6064.33.camel@localhost>  <1239759668.6064.35.camel@localhost>
	 <1239759805.6064.36.camel@localhost>  <1239759877.6064.37.camel@localhost>
	 <1239759929.6064.38.camel@localhost>  <1239760000.6064.39.camel@localhost>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 18:51:26 -0700
Message-Id: <1239760286.6064.44.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Dave,
	You acked this patch earlier, but I've just tried building with a
cross-compiler environment I had access to and had problems getting it
to build.

It seems the pci_do_get/settimeofday() and the bus_do_get/settimeofday()
redirection code is causing some trouble. I'm really not sure how the
BTFIXUPSET_CALL code works, so I don't want to just kill it off. 

Any advice here on how to do this right?

thanks
-john

  
This patch converts sparc to use GENERIC_TIME via the arch_getoffset()
infrastructure 

NOT FOR INCLUSION
Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index cc12cd4..1358aab 100644
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


