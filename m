Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbZCDU0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbZCDU0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 15:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756467AbZCDU0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 15:26:30 -0500
Received: from mx1.emlix.com ([193.175.82.87]:58479 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756369AbZCDU00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 15:26:26 -0500
Date: Wed, 4 Mar 2009 21:26:45 +0100
From: Johannes Weiner <jw@emlix.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Zankel <chris@zankel.net>,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>
Subject: Re: [patch 3/3] xtensa: ccount clocksource
References: <E1LeXCe-0006wA-5k@mailer.emlix.com> <E1LeXJ1-00071v-Dy@mailer.emlix.com> <1236102945.5937.1.camel@desktop> <20090303195401.GA2654@cmpxchg.org> <1236116164.5937.22.camel@desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236116164.5937.22.camel@desktop>
User-Agent: Mutt/1.4.2.3i
Message-Id: <E1LexfW-0006Go-KD@mailer.emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 01:36:04PM -0800, Daniel Walker wrote:
> On Tue, 2009-03-03 at 20:54 +0100, Johannes Weiner wrote:
> > On Tue, Mar 03, 2009 at 09:55:45AM -0800, Daniel Walker wrote:
> > > On Tue, 2009-03-03 at 16:30 +0100, Johannes Weiner wrote:
> > > > @ -29,6 +30,19 @@ unsigned long ccount_per_jiffy;              /* per 
> > > >  unsigned long nsec_per_ccount;         /* nsec per ccount increment
> > > > */
> > > >  #endif
> > > >  
> > > > +static cycle_t ccount_read(void)
> > > > +{
> > > > +       return (cycle_t)get_ccount();
> > > > +}
> > > > +
> > > > +static struct clocksource ccount_clocksource = {
> > > > +       .name = "ccount",
> > > > +       .rating = 200,
> > > > +       .read = ccount_read,
> > > > +       .mask = CLOCKSOURCE_MASK(32),
> > > > +       .mult = NSEC_PER_CCOUNT,
> > > > +};
> > > 
> > > You don't want to use the shift field?
> > 
> > Thanks for pointing it out.
> > 
> > To make sure I understood this:
> > 
> > If shift is 0, then a walltime adjustment would be done in 1/2^0
> > steps, meaning an adjustment of counting one nanosecond more or less
> > per ccount.
> 
> The shift and mult are just used to convert your cycle counters current
> count into nanoseconds .. I'm not sure how much a zero shift would
> degrade the conversion to nanoseconds for your cycles counter tho. So it
> could be along the lines of what your suggesting above.
> 
> > To give this a finer granularity and smooth out adjustments, the shift
> > should be a trade-off between too much adjustment and no adjustment
> > progress in a sane amount of time (and, of course, to stay within
> > bounds of the used type).
> > 
> > Does that make sense?
> 
> I don't really look at it in terms of walltime adjustments. The actual
> frequency of kernel time adjustments isn't defined in the clocksource
> structure AFAIK. From my experience you just want the clocksource to
> produce the most accurate nanosecond value your hardware can provide ,
> which would mean setting the shift as high as is safe for your hardware.
> 
> I added John Stultz to the CC so he could comment further if he cares
> too.
> 
> > I found a patch of yours that introduced clocksource_hz2shift() but it
> > seems it hasn't been merged (yet).  Is it yet to get integrated?
> 
> I've been meaning to update it, but haven't gotten around to it. If you
> know the input values you can run that function once just to produce a
> shift which you define statically in the clocksource structure. Then use
> that shift value with the other helper clocksource_hz2mult() to produce
> a mult value.

Ok, here is version 2.  The shift now limits the CPU clock to a
minimum of 1 MHz, comment in the code.  I think the trade-off should
be okay.  John?  Chris?

---
Subject: xtensa: ccount clocksource

From: Johannes Weiner <hannes@cmpxchg.org>

Switch to GENERIC_TIME by using the ccount register as a clock source.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 arch/xtensa/Kconfig       |    3 +
 arch/xtensa/kernel/time.c |  103 +++++++++++++---------------------------------
 2 files changed, 33 insertions(+), 73 deletions(-)

--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -48,6 +48,9 @@ config HZ
 	int
 	default 100
 
+config GENERIC_TIME
+	def_bool y
+
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -14,6 +14,7 @@
 
 #include <linux/errno.h>
 #include <linux/time.h>
+#include <linux/clocksource.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -29,6 +30,26 @@ unsigned long ccount_per_jiffy;		/* per 
 unsigned long nsec_per_ccount;		/* nsec per ccount increment */
 #endif
 
+static cycle_t ccount_read(void)
+{
+	return (cycle_t)get_ccount();
+}
+
+static struct clocksource ccount_clocksource = {
+	.name = "ccount",
+	.rating = 200,
+	.read = ccount_read,
+	.mask = CLOCKSOURCE_MASK(32),
+	/*
+	 * With a shift of 22 the lower limit of the cpu clock is
+	 * 1MHz, where NSEC_PER_CCOUNT is 1000 or a bit less than
+	 * 2^10: Since we have 32 bits and the multiplicator can
+	 * already take up as much as 10 bits, this leaves us with
+	 * remaining upper 22 bits.
+	 */
+	.shift = 22,
+};
+
 static irqreturn_t timer_interrupt(int irq, void *dev_id);
 static struct irqaction timer_irqaction = {
 	.handler =	timer_interrupt,
@@ -38,9 +59,11 @@ static struct irqaction timer_irqaction 
 
 void __init time_init(void)
 {
-	/* The platform must provide a function to calibrate the processor
-	 * speed for the CALIBRATE.
-	 */
+	xtime.tv_nsec = 0;
+	xtime.tv_sec = read_persistent_clock();
+
+	set_normalized_timespec(&wall_to_monotonic,
+		-xtime.tv_sec, -xtime.tv_nsec);
 
 #ifdef CONFIG_XTENSA_CALIBRATE_CCOUNT
 	printk("Calibrating CPU frequency ");
@@ -48,12 +71,10 @@ void __init time_init(void)
 	printk("%d.%02d MHz\n", (int)ccount_per_jiffy/(1000000/HZ),
 			(int)(ccount_per_jiffy/(10000/HZ))%100);
 #endif
-
-	xtime.tv_nsec = 0;
-	xtime.tv_sec = read_persistent_clock();
-
-	set_normalized_timespec(&wall_to_monotonic,
-		-xtime.tv_sec, -xtime.tv_nsec);
+	ccount_clocksource.mult =
+		clocksource_hz2mult(CCOUNT_PER_JIFFY * HZ,
+				ccount_clocksource.shift);
+	clocksource_register(&ccount_clocksource);
 
 	/* Initialize the linux timer interrupt. */
 
@@ -61,69 +82,6 @@ void __init time_init(void)
 	set_linux_timer(get_ccount() + CCOUNT_PER_JIFFY);
 }
 
-
-int do_settimeofday(struct timespec *tv)
-{
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
-}
-
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
@@ -177,4 +135,3 @@ void __cpuinit calibrate_delay(void)
 	       (loops_per_jiffy/(10000/HZ)) % 100);
 }
 #endif
-
