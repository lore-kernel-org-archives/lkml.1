Return-Path: <linux-kernel-owner+w=401wt.eu-S1758985AbZEZXNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985AbZEZXNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756253AbZEZXN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:13:28 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:35090 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844AbZEZXN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:13:27 -0400
Date: Wed, 27 May 2009 08:13:13 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback sched_clock().
Message-ID: <20090526231313.GB27218@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Linus Walleij <linus.ml.walleij@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Andrew Victor <linux@maxim.org.za>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk,
	John Stultz <johnstul@linux.vnet.ibm.com>
References: <20090526061532.GD9188@linux-sh.org> <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com> <1243348681.23657.14.camel@twins> <alpine.LFD.2.00.0905262209160.1762@localhost.localdomain> <20090526230855.GA27218@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526230855.GA27218@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 08:08:55AM +0900, Paul Mundt wrote:
> On Tue, May 26, 2009 at 10:17:02PM +0200, Thomas Gleixner wrote:
> > On Tue, 26 May 2009, Peter Zijlstra wrote:
> > > On Tue, 2009-05-26 at 16:31 +0200, Linus Walleij wrote:
> > > > The definition of "rating" from the kerneldoc does not
> > > > seem to imply that, it's a subjective measure AFAICT.
> > 
> >   Right, there is no rating threshold defined, which allows to deduce
> >   that. The TSC on x86 which might be unreliable, but usable as
> >   sched_clock has an initial rating of 300 which can be changed later
> >   on to 0 when the TSC is unusable as a time of day source. In that
> >   case clock is replaced by HPET which has a rating > 100 but is
> >   definitely not a good choice for sched_clock
> > 
> > > > Else you might want an additional criteria, like
> > > > cyc2ns(1) (much less than) jiffies_to_usecs(1)*1000
> > > > (however you do that the best way)
> > > > so you don't pick something
> > > > that isn't substantially faster than the jiffy counter atleast?
> > 
> >   What we can do is add another flag to the clocksource e.g.
> >   CLOCK_SOURCE_USE_FOR_SCHED_CLOCK and check this instead of the
> >   rating.
> > 
> Ok, so based on this and John's locking concerns, how about something
> like this? It doesn't handle the wrapping cases, but I wonder if we
> really want to add that amount of logic to sched_clock() in the first
> place. Clocksources that wrap frequently could either leave the flag
> unset, or do something similar to the TSC code where the cyc2ns shift is
> used. If this is something we want to handle generically, then I'll have
> a go at generalizing the TSC cyc2ns scaling bits for the next spin.
> 
Lets try that again..

---

 include/linux/clocksource.h |    2 ++
 kernel/sched_clock.c        |   22 ++++++++++++++++++++++
 kernel/time/clocksource.c   |    2 +-
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index c56457c..cfd873e 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -203,6 +203,7 @@ struct clocksource {
 };
 
 extern struct clocksource *clock;	/* current clocksource */
+extern spinlock_t clocksource_lock;
 
 /*
  * Clock source flags bits::
@@ -212,6 +213,7 @@ extern struct clocksource *clock;	/* current clocksource */
 
 #define CLOCK_SOURCE_WATCHDOG			0x10
 #define CLOCK_SOURCE_VALID_FOR_HRES		0x20
+#define CLOCK_SOURCE_USE_FOR_SCHED_CLOCK	0x40
 
 /* simplify initialization of mask field */
 #define CLOCKSOURCE_MASK(bits) (cycle_t)((bits) < 64 ? ((1ULL<<(bits))-1) : -1)
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index e1d16c9..c7027cd 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -30,6 +30,7 @@
 #include <linux/percpu.h>
 #include <linux/ktime.h>
 #include <linux/sched.h>
+#include <linux/clocksource.h>
 
 /*
  * Scheduler clock - returns current time in nanosec units.
@@ -38,6 +39,27 @@
  */
 unsigned long long __attribute__((weak)) sched_clock(void)
 {
+	/*
+	 * Use the current clocksource when it becomes available later in
+	 * the boot process. As this needs to be fast, we only make a
+	 * single pass at grabbing the spinlock. If the clock is changing
+	 * out from underneath us, fall back on jiffies and try it again
+	 * the next time around.
+	 */
+	if (clock && _raw_spin_trylock(&clocksource_lock)) {
+		/*
+		 * Only use clocksources suitable for sched_clock()
+		 */
+		if (clock->flags & CLOCK_SOURCE_USE_FOR_SCHED_CLOCK) {
+			cycle_t now = cyc2ns(clock, clocksource_read(clock));
+			_raw_spin_unlock(&clocksource_lock);
+			return now;
+		}
+
+		_raw_spin_unlock(&clocksource_lock);
+	}
+
+	/* If all else fails, fall back on jiffies */
 	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
 					* (NSEC_PER_SEC / HZ);
 }
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 80189f6..437a6cf 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -127,7 +127,7 @@ static struct clocksource *curr_clocksource = &clocksource_jiffies;
 static struct clocksource *next_clocksource;
 static struct clocksource *clocksource_override;
 static LIST_HEAD(clocksource_list);
-static DEFINE_SPINLOCK(clocksource_lock);
+DEFINE_SPINLOCK(clocksource_lock);
 static char override_name[32];
 static int finished_booting;
 
