Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbZE1LJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbZE1LJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 07:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbZE1LJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 07:09:20 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:44449 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbZE1LJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 07:09:19 -0400
Date: Thu, 28 May 2009 20:09:02 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback sched_clock().
Message-ID: <20090528110902.GA27884@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Daniel Walker <dwalker@fifo99.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Walleij <linus.ml.walleij@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Andrew Victor <linux@maxim.org.za>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk,
	John Stultz <johnstul@linux.vnet.ibm.com>
References: <20090526061532.GD9188@linux-sh.org> <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com> <1243348681.23657.14.camel@twins> <alpine.LFD.2.00.0905262209160.1762@localhost.localdomain> <20090526230855.GA27218@linux-sh.org> <alpine.LFD.2.00.0905270140030.1762@localhost.localdomain> <20090527001543.GA8493@linux-sh.org> <1243441525.28705.19.camel@desktop> <20090528091936.GA27545@linux-sh.org> <1243503281.23657.80.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243503281.23657.80.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 11:34:41AM +0200, Peter Zijlstra wrote:
> That's a single assignment, vs two reads on use. Should we be worried
> about the SMP race where we observe two different sched_clocksource
> pointers on read?
> 
> 
> I would suggest we write it as:
> 
> u64 __weak sched_clock(void)
> {
> 	struct clocksource *clock = ACCESS_ONCE(sched_clocksource);
> 
> 	return cyc2ns(clock, clocksource_read(clock));
> }

Here's an updated version, also with an added sanity check in the
unregister path..

--

 include/linux/clocksource.h |    4 +++-
 kernel/sched_clock.c        |    6 ++++--
 kernel/time/clocksource.c   |   13 +++++++++++++
 kernel/time/jiffies.c       |    2 +-
 4 files changed, 21 insertions(+), 4 deletions(-)

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
index e1d16c9..b91190e 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -30,6 +30,7 @@
 #include <linux/percpu.h>
 #include <linux/ktime.h>
 #include <linux/sched.h>
+#include <linux/clocksource.h>
 
 /*
  * Scheduler clock - returns current time in nanosec units.
@@ -38,8 +39,9 @@
  */
 unsigned long long __attribute__((weak)) sched_clock(void)
 {
-	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
-					* (NSEC_PER_SEC / HZ);
+	struct clocksource *clock = ACCESS_ONCE(sched_clocksource);
+
+	return cyc2ns(clock, clocksource_read(clock));
 }
 
 static __read_mostly int sched_clock_running;
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 80189f6..57b011a 100644
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
 
@@ -437,10 +441,19 @@ void clocksource_unregister(struct clocksource *cs)
 	unsigned long flags;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
+
+	if (sched_clocksource == cs) {
+		printk(KERN_WARNING "Refusing to unregister "
+		       "scheduler clocksource %s", cs->name);
+		goto out;
+	}
+
 	list_del(&cs->list);
 	if (clocksource_override == cs)
 		clocksource_override = NULL;
 	next_clocksource = select_clocksource();
+
+out:
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
