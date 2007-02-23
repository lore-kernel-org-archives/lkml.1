Return-Path: <linux-kernel-owner+w=401wt.eu-S932611AbXBWTvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611AbXBWTvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 14:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932616AbXBWTvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 14:51:23 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:51426 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611AbXBWTvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 14:51:22 -0500
Subject: Re: sparc generic time / clockevents
From: john stultz <johnstul@us.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: tglx@linutronix.de, lkml <linux-kernel@vger.kernel.org>,
       Peter Keilty <peter.keilty@hp.com>
In-Reply-To: <20070223.015520.125893182.davem@davemloft.net>
References: <1172165959.25076.192.camel@localhost.localdomain>
	 <20070223.012519.48528691.davem@davemloft.net>
	 <1172224579.25076.219.camel@localhost.localdomain>
	 <20070223.015520.125893182.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 23 Feb 2007 11:51:18 -0800
Message-Id: <1172260279.6261.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-23 at 01:55 -0800, David Miller wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Fri, 23 Feb 2007 10:56:18 +0100
> 
> > On Fri, 2007-02-23 at 01:25 -0800, David Miller wrote:
> > > > Yes, all you need is to omit the CLOCK_EVT_FEAT_PERIODIC flag when you
> > > > register your device.
> > > 
> > > Thanks a lot Thomas.
> > > 
> > > I noticed while doing this work that the generic clock code is
> > > incompatible with the time interpolator, since both provide a
> > > do_{get,set}timeofday() implementation.  Just FYI...
> > 
> > John, can you have a look at this ?
> 
> Note we may not care :-)  All the interpolator does is provide
> a generic tick based gettimeofday implementation, and the generic
> clock code does essentially the same thing.
> 
> And the generic clock code must in fact provide the implementations
> in order to deal with dyntick issues.
> 
> The only other platform using the time interpolator is IA64,
> and after my dyntick implementation on sparc64 the one and
> only user will be IA64 :-)

Yea. I actually have some in-progress patches from Peter Keilty that
convert ia64 and sparc64 time_interpolators to clocksources, then
removes the time_interpolator code.

The ia64 conversion is more complicated due to the fsyscall asm, but I
think the sparc64 conversion (below) is pretty straight forward. I've
only built tested this, so I have no clue if it actually works. 

Any thoughts?

thanks
-john


From: Peter Keilty <peter.keilty@hp.com>

Initial sparc64 conversion to generic clocksource/timekeeping code.

Signed-off-by: Peter Keilty <peter.keilty@hp.com>
Signed-off-by: John Stultz <johnstul@us.ibm.com>


 Kconfig       |    2 +-
 defconfig     |    2 +-
 kernel/time.c |   34 +++++++++++++++++++++++-----------
 3 files changed, 25 insertions(+), 13 deletions(-)

linux-2.6.21-rc1_timeofday-arch-sparc64_C7.patch
============================================
diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index f75a686..13a4547 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -34,7 +34,7 @@ config LOCKDEP_SUPPORT
 	bool
 	default y
 
-config TIME_INTERPOLATION
+config GENERIC_TIME
 	bool
 	default y
 
diff --git a/arch/sparc64/defconfig b/arch/sparc64/defconfig
index 0f44a6a..33e061a 100644
--- a/arch/sparc64/defconfig
+++ b/arch/sparc64/defconfig
@@ -9,7 +9,7 @@ CONFIG_64BIT=y
 CONFIG_MMU=y
 CONFIG_STACKTRACE_SUPPORT=y
 CONFIG_LOCKDEP_SUPPORT=y
-CONFIG_TIME_INTERPOLATION=y
+CONFIG_GENERIC_TIME=y
 CONFIG_ARCH_MAY_HAVE_PC_FDC=y
 # CONFIG_ARCH_HAS_ILOG2_U32 is not set
 # CONFIG_ARCH_HAS_ILOG2_U64 is not set
diff --git a/arch/sparc64/kernel/time.c b/arch/sparc64/kernel/time.c
index f84da4f..497b29b 100644
--- a/arch/sparc64/kernel/time.c
+++ b/arch/sparc64/kernel/time.c
@@ -31,6 +31,7 @@ #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/miscdevice.h>
 #include <linux/rtc.h>
+#include <linux/clocksource.h>
 
 #include <asm/oplib.h>
 #include <asm/mostek.h>
@@ -620,7 +621,7 @@ #endif
 	if (!mregs && !dregs) {
 		prom_printf("Something wrong, clock regs not mapped yet.\n");
 		prom_halt();
-	}		
+	}
 
 	if (mregs) {
 		spin_lock_irq(&mostek_lock);
@@ -820,7 +821,7 @@ #endif
 	}
 
 	set_system_time();
-	
+
 	local_irq_restore(flags);
 
 	return 0;
@@ -975,22 +976,33 @@ static struct notifier_block sparc64_cpu
 
 #endif /* CONFIG_CPU_FREQ */
 
-static struct time_interpolator sparc64_cpu_interpolator = {
-	.source		=	TIME_SOURCE_CPU,
-	.shift		=	16,
-	.mask		=	0xffffffffffffffffLL
+static cycle_t read_sparc64_cpuclock(void)
+{
+        return (cycle_t)get_cycles();
+}
+
+static struct clocksource clocksource_sparc64_cpuclock = {
+	.name           = "sparc64_cpuclock",
+	.rating         = 300,
+	.read           = read_sparc64_cpuclock,
+	.mask           = 0xffffffffffffffffLL,
+	.mult           = 0, /*to be caluclated*/
+	.shift          = 16,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
+
 /* The quotient formula is taken from the IA64 port. */
 #define SPARC64_NSEC_PER_CYC_SHIFT	10UL
 void __init time_init(void)
 {
 	unsigned long clock = sparc64_init_timers();
 
-	sparc64_cpu_interpolator.frequency = clock;
-	register_time_interpolator(&sparc64_cpu_interpolator);
+	clocksource_sparc64_cpuclock.mult = clocksource_hz2mult(clock,
+					clocksource_sparc64_cpuclock.shift);
+	clocksource_register(&clocksource_sparc64_cpuclock);
 
-	/* Now that the interpolator is registered, it is
+	/* Now that the clocksource is registered, it is
 	 * safe to start the timer ticking.
 	 */
 	sparc64_start_timers();
@@ -1025,11 +1037,11 @@ #endif
 	unsigned long flags;
 	u8 tmp;
 
-	/* 
+	/*
 	 * Not having a register set can lead to trouble.
 	 * Also starfire doesn't have a tod clock.
 	 */
-	if (!mregs && !dregs) 
+	if (!mregs && !dregs)
 		return -1;
 
 	if (mregs) {


