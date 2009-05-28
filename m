Return-Path: <linux-kernel-owner+w=401wt.eu-S1763089AbZE1NUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763089AbZE1NUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 09:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758998AbZE1NUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 09:20:41 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:53231 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761574AbZE1NUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 09:20:40 -0400
Date: Thu, 28 May 2009 22:20:23 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Daniel Walker <dwalker@fifo99.com>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback sched_clock().
Message-ID: <20090528132023.GA29364@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Daniel Walker <dwalker@fifo99.com>,
	Linus Walleij <linus.ml.walleij@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Andrew Victor <linux@maxim.org.za>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk,
	John Stultz <johnstul@linux.vnet.ibm.com>
References: <20090526230855.GA27218@linux-sh.org> <alpine.LFD.2.00.0905270140030.1762@localhost.localdomain> <20090527001543.GA8493@linux-sh.org> <1243441525.28705.19.camel@desktop> <20090528091936.GA27545@linux-sh.org> <1243503281.23657.80.camel@twins> <20090528110902.GA27884@linux-sh.org> <alpine.LFD.2.00.0905281417500.3397@localhost.localdomain> <20090528124207.GA28830@linux-sh.org> <1243515570.6600.96.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243515570.6600.96.camel@laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 02:59:30PM +0200, Peter Zijlstra wrote:
> On Thu, 2009-05-28 at 21:42 +0900, Paul Mundt wrote:
> 
> >  unsigned long long __attribute__((weak)) sched_clock(void)
> >  {
> > -	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
> > -					* (NSEC_PER_SEC / HZ);
> > +	struct clocksource *clock = ACCESS_ONCE(sched_clocksource);
> > +
> > +	return cyc2ns(clock, clocksource_read(clock));
> >  }
> >  
> 
> > @@ -440,7 +444,17 @@ void clocksource_unregister(struct clocksource *cs)
> >  	list_del(&cs->list);
> >  	if (clocksource_override == cs)
> >  		clocksource_override = NULL;
> > +
> >  	next_clocksource = select_clocksource();
> > +
> > +	/*
> > +	 * If select_clocksource() fails to find another suitable
> > +	 * clocksource for sched_clocksource and we are unregistering
> > +	 * it, switch back to jiffies.
> > +	 */
> > +	if (sched_clocksource == cs)
> > +		sched_clocksource = &clocksource_jiffies;
> > +
> >  	spin_unlock_irqrestore(&clocksource_lock, flags);
> >  }
> 
> 
> CPU0                           CPU1
> 
> clock = ACCESS_ONCE(sched_clocksource);
> 
>                                unload module
>                                  clocksource_unregister()
>                                    sched_clocksource = jiffies
>                                  unmap data/text
> 
> cyc2ns(clock, clocksource_read(clock)) <--- fireworks
> 

Right, lets try that again..

--

 include/linux/clocksource.h |    4 +++-
 kernel/sched_clock.c        |   13 +++++++++++--
 kernel/time/clocksource.c   |   19 +++++++++++++++++++
 kernel/time/jiffies.c       |    2 +-
 4 files changed, 34 insertions(+), 4 deletions(-)

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
index e1d16c9..b51d48d 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -30,6 +30,8 @@
 #include <linux/percpu.h>
 #include <linux/ktime.h>
 #include <linux/sched.h>
+#include <linux/clocksource.h>
+#include <linux/rcupdate.h>
 
 /*
  * Scheduler clock - returns current time in nanosec units.
@@ -38,8 +40,15 @@
  */
 unsigned long long __attribute__((weak)) sched_clock(void)
 {
-	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
-					* (NSEC_PER_SEC / HZ);
+	unsigned long long time;
+	struct clocksource *clock;
+
+	rcu_read_lock();
+	clock = rcu_dereference(sched_clocksource);
+	time = cyc2ns(clock, clocksource_read(clock));
+	rcu_read_unlock();
+
+	return time;
 }
 
 static __read_mostly int sched_clock_running;
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 80189f6..3795954 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -25,6 +25,7 @@
  */
 
 #include <linux/clocksource.h>
+#include <linux/rcupdate.h>
 #include <linux/sysdev.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -109,6 +110,7 @@ EXPORT_SYMBOL(timecounter_cyc2time);
 
 /* XXX - Would like a better way for initializing curr_clocksource */
 extern struct clocksource clocksource_jiffies;
+struct clocksource *sched_clocksource = &clocksource_jiffies;
 
 /*[Clocksource internal variables]---------
  * curr_clocksource:
@@ -362,6 +364,9 @@ static struct clocksource *select_clocksource(void)
 	if (next == curr_clocksource)
 		return NULL;
 
+	if (next->flags & CLOCK_SOURCE_USE_FOR_SCHED_CLOCK)
+		sched_clocksource = next;
+
 	return next;
 }
 
@@ -440,7 +445,21 @@ void clocksource_unregister(struct clocksource *cs)
 	list_del(&cs->list);
 	if (clocksource_override == cs)
 		clocksource_override = NULL;
+
 	next_clocksource = select_clocksource();
+
+	/*
+	 * If select_clocksource() fails to find another suitable
+	 * clocksource for sched_clocksource and we are unregistering
+	 * it, switch back to jiffies.
+	 */
+	if (sched_clocksource == cs) {
+		rcu_assign_pointer(sched_clocksource, &clocksource_jiffies);
+		spin_unlock_irqrestore(&clocksource_lock, flags);
+		synchronize_rcu();
+		return;
+	}
+
 	spin_unlock_irqrestore(&clocksource_lock, flags);
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
