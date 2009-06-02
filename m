Return-Path: <linux-kernel-owner+w=401wt.eu-S1759673AbZFBHys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673AbZFBHys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbZFBHyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:54:39 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:34083 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757545AbZFBHyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:54:38 -0400
Date: Tue, 2 Jun 2009 16:54:09 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: sched_clock() clocksource handling.
Message-ID: <20090602075409.GA19294@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Daniel Walker <dwalker@fifo99.com>,
	Linus Walleij <linus.ml.walleij@gmail.com>,
	Andrew Victor <linux@maxim.org.za>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	John Stultz <johnstul@linux.vnet.ibm.com>,
	linux-arm-kernel@lists.arm.linux.org.uk, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20090602071718.GA17710@linux-sh.org> <1243927502.23657.5619.camel@twins> <20090602073515.GB17710@linux-sh.org> <1243928495.23657.5642.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243928495.23657.5642.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 09:41:35AM +0200, Peter Zijlstra wrote:
> On Tue, 2009-06-02 at 16:35 +0900, Paul Mundt wrote:
> > 
> > We already do via select_clocksource(), if we are unregistering the
> > current one then a new one with the flag set is selected. Before that,
> > the override is likewise given preference, and we fall back on jiffies if
> > there is nothing else. I suppose we could try and find the "best" one,
> > but I think the override and manual clocksource selection should be fine
> > for this.
> 
> Ah, ok. So unregister calls select_clocksource again? That does leave us
> a small window with jiffies, but I guess that's ok.
> 
A synchronize_rcu() would fix that up, but I think a small window with
jiffies is less painful than sorting out RCU ordering and synchronization
for a corner case of a corner case ;-)

> > Now that you mention it though, the sched_clocksource() assignment within
> > select_clocksource() happens underneath the clocksource_lock, but is not
> > using rcu_assign_pointer().
> 
> Right, that would want fixing indeed.
> 
> >  If the assignment there needs to use
> > rcu_assign_pointer() then presumably all of the unlock paths that do
> > select_clocksource() will have to synchronize_rcu()?
> 
> No, you only have to do sync_rcu() when stuff that could have referenced
> is going away and you cannot use call_rcu().
> 
> So when selecting a new clocksource, you don't need synchonization
> because stuff doesn't go away (I think :-)

Ok, that keeps things more simplified then. How does this look?

---

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
index 80189f6..f7243f2 100644
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
+		rcu_assign_pointer(sched_clocksource, next);
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
