Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbZA2ELb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbZA2ELb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 23:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbZA2ELU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 23:11:20 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:32775 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbZA2ELS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 23:11:18 -0500
Subject: [RFC][PATCH 9/10] Convert xtensa to use arch_getoffset()
	infrastructure.
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: rmk+lkml@arm.linux.org.uk, cooloney@kernel.org, starvik@axis.com,
       takata@linux-m32r.org, geert@linux-m68k.org,
       Roman Zippel <zippel@linux-m68k.org>, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
       chris@zankel.net, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1233202241.6895.45.camel@localhost.localdomain>
References: <1233201926.6895.25.camel@localhost.localdomain>
	 <1233201995.6895.27.camel@localhost.localdomain>
	 <1233202037.6895.30.camel@localhost.localdomain>
	 <1233202074.6895.33.camel@localhost.localdomain>
	 <1233202104.6895.35.camel@localhost.localdomain>
	 <1233202139.6895.38.camel@localhost.localdomain>
	 <1233202175.6895.40.camel@localhost.localdomain>
	 <1233202206.6895.43.camel@localhost.localdomain>
	 <1233202241.6895.45.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 20:11:13 -0800
Message-Id: <1233202273.6895.47.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts xtensa to use GENERIC_TIME via the arch_getoffset()
infrastructure 

I do not have cross compilers for these architectures, and in some cases
the architectures can be compiles both with and without clocksources. So
I've taken my best swing at converting this, but I'm not confident I got
it right. Any assistance from arch maintainers or testers would be
great.

Signed-off-by: John Stultz <johnstul@us.ibm.com>


diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 6c873dc..ea3fdfe 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -54,6 +54,12 @@ config HZ
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
 
diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index 8df1e84..d49eb9d 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -88,68 +88,13 @@ void __init time_init(void)
 }
 
 
-int do_settimeofday(struct timespec *tv)
+u32 arch_gettimeoffset(void)
 {
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
-	unsigned long delta;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irq(&xtime_lock);
-
-	/* This is revolting. We need to set "xtime" correctly. However, the
-	 * value in this location is the value at the most recent update of
-	 * wall time.  Discover what correction gettimeofday() would have
-	 * made, and then undo it!
-	 */
-
-	delta = CCOUNT_PER_JIFFY;
-	delta += get_ccount() - get_linux_timer();
-	nsec -= delta * NSEC_PER_CCOUNT;
-
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-	write_sequnlock_irq(&xtime_lock);
-	return 0;
+	u32 delta = get_linux_timer() - get_ccount();
+	return ((unsigned long) CCOUNT_PER_JIFFY - delta)
+		 * (unsigned long) NSEC_PER_CCOUNT;
 }
 
-EXPORT_SYMBOL(do_settimeofday);
-
-
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long flags;
-	unsigned long volatile sec, usec, delta, seq;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-
-		sec = xtime.tv_sec;
-		usec = (xtime.tv_nsec / NSEC_PER_USEC);
-
-		delta = get_linux_timer() - get_ccount();
-
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
-	usec += (((unsigned long) CCOUNT_PER_JIFFY - delta)
-		 * (unsigned long) NSEC_PER_CCOUNT) / NSEC_PER_USEC;
-
-	for (; usec >= 1000000; sec++, usec -= 1000000)
-		;
-
-	tv->tv_sec = sec;
-	tv->tv_usec = usec;
-}
-
-EXPORT_SYMBOL(do_gettimeofday);
-
 /*
  * The timer interrupt is called HZ times per second.
  */


