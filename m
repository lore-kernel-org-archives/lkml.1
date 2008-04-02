Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbYDBLYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbYDBLYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 07:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbYDBLXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 07:23:51 -0400
Received: from www.tglx.de ([62.245.132.106]:35600 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573AbYDBLXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:23:49 -0400
Date: Wed, 2 Apr 2008 13:22:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <johnstul@us.ibm.com>
cc: Tim Ricketts <tr@earth.li>, Michael Smith <msmith@xiph.org>,
       LKML <linux-kernel@vger.kernel.org>, Andy Wingo <wingo@fluendo.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: gettimeofday() jumping into the future
In-Reply-To: <1206979407.6175.2.camel@jstultz-laptop>
Message-ID: <alpine.LFD.1.10.0804021254420.3219@apollo.tec.linutronix.de>
References: <3c1737210708230408i7a8049a9m5db49e6c4d89ab62@mail.gmail.com>  <Pine.LNX.4.64.0803302210060.3056@falcon.foo>  <alpine.LFD.1.10.0803311048170.3219@apollo.tec.linutronix.de> <1206979407.6175.2.camel@jstultz-laptop>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2008, John Stultz wrote:
> 
> On Mon, 2008-03-31 at 10:55 +0200, Thomas Gleixner wrote:
> > 
> > > +     if (cycle_now < clock->cycle_last)
> > > +             return 0;
> > > +
> > 
> > No, this breaks wrapping clocksources e.g. pmtimer. We need a
> > different sanity check for that TSC crap.
> 
> Yea. If you're going to do that sort of logic (which requires a costly
> cmpxchg as well), it should be done in the read() function of the
> clocksource.

We can get away without a cmpxchg(). See patch below.

Tim, Michael, does this solve your problems ?

Thanks,

	tglx

----------->

Subject: x86: tsc prevent time going backwards
From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 01 Apr 2008 19:45:18 +0200

We already catch most of the TSC problems by sanity checks, but there
is a subtle bug which has been in the code for ever. This can cause
time jumps in the range of hours.

This was reported in:
     http://lkml.org/lkml/2007/8/23/96
and
     http://lkml.org/lkml/2008/3/31/23

I was able to reproduce the problem with a gettimeofday loop test on a
dual core and a quad core machine which both have sychronized
TSCs. The TSCs seems not to be perfectly in sync though, but the
kernel is not able to detect the slight delta in the bootup sync
check. There exists an extremly small window where this delta can be
observed with a real big time jump. So far I was only able to
reproduce this with the vsyscall gettimeofday implementation, but in
theory this might be observable with the syscall based version as
well.

CPU 0 updates the clock source variables under xtime/vyscall lock and
CPU1, where the TSC is slighty behind CPU0, is reading the time right
after the seqlock was unlocked.

The clocksource reference data was updated with the TSC from CPU0 and
the value which is read from TSC on CPU1 is less than the reference
data. This results in a huge delta value due to the unsigned
subtraction of the TSC value and the reference value. This algorithm
can not be changed due to the support of wrapping clock sources like
pm timer.

The huge delta is converted to nanoseconds and added to xtime, which
is then observable by the caller. The next gettimeofday call on CPU1
will show the correct time again as now the TSC has advanced above the
reference value.

To prevent this TSC specific wreckage we need to compare the TSC value
against the reference value and return the latter when it is larger
than the actual TSC value.

I pondered to mark the TSC unstable when the readout is smaller than
the reference value, but this would render an otherwise good and fast
clocksource unusable without a real good reason.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/tsc_32.c |   15 ++++++++++++++-
 arch/x86/kernel/tsc_64.c |   23 ++++++++++++++++++++---
 2 files changed, 34 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/tsc_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tsc_32.c
+++ linux-2.6/arch/x86/kernel/tsc_32.c
@@ -287,14 +287,27 @@ core_initcall(cpufreq_tsc);
 /* clock source code */
 
 static unsigned long current_tsc_khz = 0;
+static struct clocksource clocksource_tsc;
 
+/*
+ * We compare the TSC to the cycle_last value in the clocksource
+ * structure to avoid a nasty time-warp issue. This can be observed in
+ * a very small window right after one CPU updated cycle_last under
+ * xtime lock and the other CPU reads a TSC value which is smaller
+ * than the cycle_last reference value due to a TSC which is slighty
+ * behind. This delta is nowhere else observable, but in that case it
+ * results in a forward time jump in the range of hours due to the
+ * unsigned delta calculation of the time keeping core code, which is
+ * necessary to support wrapping clocksources like pm timer.
+ */
 static cycle_t read_tsc(void)
 {
 	cycle_t ret;
 
 	rdtscll(ret);
 
-	return ret;
+	return ret >= clocksource_tsc.cycle_last ?
+		ret : clocksource_tsc.cycle_last;
 }
 
 static struct clocksource clocksource_tsc = {
Index: linux-2.6/arch/x86/kernel/tsc_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tsc_64.c
+++ linux-2.6/arch/x86/kernel/tsc_64.c
@@ -11,6 +11,7 @@
 #include <asm/hpet.h>
 #include <asm/timex.h>
 #include <asm/timer.h>
+#include <asm/vgtod.h>
 
 static int notsc __initdata = 0;
 
@@ -290,18 +291,34 @@ int __init notsc_setup(char *s)
 
 __setup("notsc", notsc_setup);
 
+static struct clocksource clocksource_tsc;
 
-/* clock source code: */
+/*
+ * We compare the TSC to the cycle_last value in the clocksource
+ * structure to avoid a nasty time-warp. This can be observed in a
+ * very small window right after one CPU updated cycle_last under
+ * xtime/vsyscall_gtod lock and the other CPU reads a TSC value which
+ * is smaller than the cycle_last reference value due to a TSC which
+ * is slighty behind. This delta is nowhere else observable, but in
+ * that case it results in a forward time jump in the range of hours
+ * due to the unsigned delta calculation of the time keeping core
+ * code, which is necessary to support wrapping clocksources like pm
+ * timer.
+ */
 static cycle_t read_tsc(void)
 {
 	cycle_t ret = (cycle_t)get_cycles();
-	return ret;
+
+	return ret >= clocksource_tsc.cycle_last ?
+		ret : clocksource_tsc.cycle_last;
 }
 
 static cycle_t __vsyscall_fn vread_tsc(void)
 {
 	cycle_t ret = (cycle_t)vget_cycles();
-	return ret;
+
+	return ret >= __vsyscall_gtod_data.clock.cycle_last ?
+		ret : __vsyscall_gtod_data.clock.cycle_last;
 }
 
 static struct clocksource clocksource_tsc = {


