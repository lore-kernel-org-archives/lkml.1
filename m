Return-Path: <linux-kernel-owner+w=401wt.eu-S932998AbZGQFdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998AbZGQFdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 01:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932790AbZGQFds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 01:33:48 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:59533 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932520AbZGQFds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 01:33:48 -0400
Subject: Re: [PATCH] Convert blackfin to use arch_gettimeoffset()
From: john stultz <johnstul@us.ibm.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <8bd0f97a0907161926j258da72cg9dd1ca76ea8be2fb@mail.gmail.com>
References: <1244758210.7192.5.camel@localhost.localdomain>
	 <1247790356.7398.14.camel@localhost.localdomain>
	 <8bd0f97a0907161926j258da72cg9dd1ca76ea8be2fb@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 22:33:45 -0700
Message-Id: <1247808825.674.4.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 22:26 -0400, Mike Frysinger wrote:
> On Thu, Jul 16, 2009 at 20:25, john stultz wrote:
> > This patch converts blackfin to use GENERIC_TIME via the arch_getoffset()
> > infrastructure, reducing the amount of arch specific code we need to
> > maintain.
> >
> > This patch applies on top of Linus' current -git tree (2.6.31-rc3).
> >
> > I've taken my best swing at converting this, but I'm not 100% confident
> > I got it right. My cross-compiler is now out of date (gcc4.2) so I
> > wasn't able to  check if it compiled. Any assistance from arch
> > maintainers or testers to get this merged would be great.
> 
> something seems to be off as the Blackfin defconfig now does:
>   LD      .tmp_vmlinux1
> kernel/built-in.o: In function `clocksource_forward_now':
> kernel/time/timekeeping.c:82: undefined reference to `arch_gettimeoffset'
> kernel/built-in.o: In function `getnstimeofday':
> kernel/time/timekeeping.c:119: undefined reference to `arch_gettimeoffset'
> make: *** [.tmp_vmlinux1] Error 1
> 
> most likely because the Blackfin time.c is the old stuff
> (non-clocksource) while time-ts.c is the newer stuff (clocksource) and
> this change only touches time.c

Ok. So I guess I missed that time.c isn't built if GENERIC_CLOCKEVENTS
isn't enabled, so ARCH_HAS_GETTIMEOFFSET needs to depend on !
GENERIC_CLOCKEVENTS.

Hopefully I've got it cleared up now. Let me know if I'm still causing
trouble.

thanks
-john



This patch converts blackfin to use GENERIC_TIME via the
arch_getoffset() infrastructure, reducing the amount of arch specific
code we need to maintain.

This patch applies on top of Linus' current -git tree (2.6.31-rc3).

I've taken my best swing at converting this, but I'm not 100% confident
I got it right. My cross-compiler is now out of date (gcc4.2) so I
wasn't able to  check if it compiled. Any assistance from arch
maintainers or testers to get this merged would be great.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 7faa2f5..c8f5c3d 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -229,7 +229,7 @@ endchoice
 
 config SMP
 	depends on BF561
-	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
 	bool "Symmetric multi-processing support"
 	---help---
 	  This enables support for systems with more than one CPU,
@@ -612,12 +612,10 @@ comment "Kernel Timer/Scheduler"
 source kernel/Kconfig.hz
 
 config GENERIC_TIME
-	bool "Generic time"
-	default y
+	def_bool y
 
 config GENERIC_CLOCKEVENTS
 	bool "Generic clock events"
-	depends on GENERIC_TIME
 	default y
 
 choice
@@ -652,6 +650,10 @@ config GPTMR0_CLOCKSOURCE
 	depends on GENERIC_CLOCKEVENTS
 	depends on !TICKSOURCE_GPTMR0
 
+config ARCH_USES_GETTIMEOFFSET
+	depends on !GENERIC_CLOCKEVENTS
+	def_bool y
+
 source kernel/time/Kconfig
 
 comment "Misc"
diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
index adb54aa..e5069fe 100644
--- a/arch/blackfin/kernel/time.c
+++ b/arch/blackfin/kernel/time.c
@@ -81,11 +81,11 @@ time_sched_init(irqreturn_t(*timer_routine) (int, void *))
 #endif
 }
 
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 /*
  * Should return useconds since last timer tick
  */
-#ifndef CONFIG_GENERIC_TIME
-static unsigned long gettimeoffset(void)
+u32 arch_gettimeoffset(void)
 {
 	unsigned long offset;
 	unsigned long clocks_per_jiffy;
@@ -184,65 +184,6 @@ void __init time_init(void)
 	time_sched_init(timer_interrupt);
 }
 
-#ifndef CONFIG_GENERIC_TIME
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long flags;
-	unsigned long seq;
-	unsigned long usec, sec;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-		usec = gettimeoffset();
-		sec = xtime.tv_sec;
-		usec += (xtime.tv_nsec / NSEC_PER_USEC);
-	}
-	while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
-	while (usec >= USEC_PER_SEC) {
-		usec -= USEC_PER_SEC;
-		sec++;
-	}
-
-	tv->tv_sec = sec;
-	tv->tv_usec = usec;
-}
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
-	/*
-	 * This is revolting. We need to set the xtime.tv_usec
-	 * correctly. However, the value in this location is
-	 * is value at the last tick.
-	 * Discover what correction gettimeofday
-	 * would have done, and then undo it!
-	 */
-	nsec -= (gettimeoffset() * NSEC_PER_USEC);
-
-	wtm_sec = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-
-	return 0;
-}
-EXPORT_SYMBOL(do_settimeofday);
-#endif /* !CONFIG_GENERIC_TIME */
-
 /*
  * Scheduler clock - returns current time in nanosec units.
  */


