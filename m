Return-Path: <linux-kernel-owner+w=401wt.eu-S1760460AbZE1JUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760460AbZE1JUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 05:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbZE1JTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 05:19:55 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:47120 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbZE1JTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 05:19:53 -0400
Date: Thu, 28 May 2009 18:19:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback sched_clock().
Message-ID: <20090528091936.GA27545@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Daniel Walker <dwalker@fifo99.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Linus Walleij <linus.ml.walleij@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Andrew Victor <linux@maxim.org.za>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk,
	John Stultz <johnstul@linux.vnet.ibm.com>
References: <20090526061532.GD9188@linux-sh.org> <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com> <1243348681.23657.14.camel@twins> <alpine.LFD.2.00.0905262209160.1762@localhost.localdomain> <20090526230855.GA27218@linux-sh.org> <alpine.LFD.2.00.0905270140030.1762@localhost.localdomain> <20090527001543.GA8493@linux-sh.org> <1243441525.28705.19.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243441525.28705.19.camel@desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 09:25:25AM -0700, Daniel Walker wrote:
> On Wed, 2009-05-27 at 09:15 +0900, Paul Mundt wrote:
> 
> >  unsigned long long __attribute__((weak)) sched_clock(void)
> >  {
> > +	/*
> > +	 * Use the current clocksource when it becomes available later in
> > +	 * the boot process, and ensure that it is usable for sched_clock().
> > +	 */
> > +	if (clock && (clock->flags & CLOCK_SOURCE_USE_FOR_SCHED_CLOCK))
> > +		return cyc2ns(clock, clocksource_read(clock));
> > +
> > +	/* Otherwise just fall back on jiffies */
> >  	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
> 
> Do we really need all this complexity in a fast path? the jiffies
> clocksource is static and always ready. Could we instead remove the
> usage of "clock" and create a new pointer called "sched_clocksource" and
> initialize it to the jiffies clock, and allow the clocksource management
> code to update that new pointer based on the
> CLOCK_SOURCE_USE_FOR_SCHED_CLOCK flag when new clocksources are
> registered/removed/marked unstable etc..
> 
> that would eliminate all the code in sched_clock except one line,
> 
> unsigned long long __attribute__((weak)) sched_clock(void)
> {
> 	return cyc2ns(sched_clocksource, clocksource_read(sched_clocksource));
> }
> 
Ok, there were some ordering problems with the early platform code, but
I've played with this a bit more and got it to the point where this now
also works. I can live with this over the v3 version if people prefer
this approach instead.

--

 include/linux/clocksource.h |    4 +++-
 kernel/sched_clock.c        |    4 ++--
 kernel/time/clocksource.c   |    4 ++++
 kernel/time/jiffies.c       |    2 +-
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index c56457c..2109940 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -202,7 +202,8 @@ struct clocksource {
 #endif
 };
 
-extern struct clocksource *clock;	/* current clocksource */
+extern struct clocksource *clock;		/* current clocksource */
+extern struct clocksource *sched_clocksource;	/* sched_clock() clocksource */
 
 /*
  * Clock source flags bits::
@@ -212,6 +213,7 @@ extern struct clocksource *clock;	/* current clocksource */
 
 #define CLOCK_SOURCE_WATCHDOG			0x10
 #define CLOCK_SOURCE_VALID_FOR_HRES		0x20
+#define CLOCK_SOURCE_USE_FOR_SCHED_CLOCK	0x40
 
 /* simplify initialization of mask field */
 #define CLOCKSOURCE_MASK(bits) (cycle_t)((bits) < 64 ? ((1ULL<<(bits))-1) : -1)
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index e1d16c9..c06c285 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -30,6 +30,7 @@
 #include <linux/percpu.h>
 #include <linux/ktime.h>
 #include <linux/sched.h>
+#include <linux/clocksource.h>
 
 /*
  * Scheduler clock - returns current time in nanosec units.
@@ -38,8 +39,7 @@
  */
 unsigned long long __attribute__((weak)) sched_clock(void)
 {
-	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
-					* (NSEC_PER_SEC / HZ);
+	return cyc2ns(sched_clocksource, clocksource_read(sched_clocksource));
 }
 
 static __read_mostly int sched_clock_running;
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 80189f6..d148a75 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -109,6 +109,7 @@ EXPORT_SYMBOL(timecounter_cyc2time);
 
 /* XXX - Would like a better way for initializing curr_clocksource */
 extern struct clocksource clocksource_jiffies;
+struct clocksource *sched_clocksource = &clocksource_jiffies;
 
 /*[Clocksource internal variables]---------
  * curr_clocksource:
@@ -362,6 +363,9 @@ static struct clocksource *select_clocksource(void)
 	if (next == curr_clocksource)
 		return NULL;
 
+	if (next->flags & CLOCK_SOURCE_USE_FOR_SCHED_CLOCK)
+		sched_clocksource = next;
+
 	return next;
 }
 
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index c3f6c30..727d881 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -52,7 +52,7 @@
 
 static cycle_t jiffies_read(struct clocksource *cs)
 {
-	return (cycle_t) jiffies;
+	return (cycle_t) (jiffies - INITIAL_JIFFIES);
 }
 
 struct clocksource clocksource_jiffies = {
