Return-Path: <linux-kernel-owner+w=401wt.eu-S1758357AbZE0AQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357AbZE0AQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbZE0AP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 20:15:59 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33778 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbZE0AP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 20:15:58 -0400
Date: Wed, 27 May 2009 09:15:43 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback sched_clock().
Message-ID: <20090527001543.GA8493@linux-sh.org>
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
References: <20090526061532.GD9188@linux-sh.org> <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com> <1243348681.23657.14.camel@twins> <alpine.LFD.2.00.0905262209160.1762@localhost.localdomain> <20090526230855.GA27218@linux-sh.org> <alpine.LFD.2.00.0905270140030.1762@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0905270140030.1762@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 01:49:33AM +0200, Thomas Gleixner wrote:
> On Wed, 27 May 2009, Paul Mundt wrote:
> > Ok, so based on this and John's locking concerns, how about something
> > like this? It doesn't handle the wrapping cases, but I wonder if we
> > really want to add that amount of logic to sched_clock() in the first
> > place. Clocksources that wrap frequently could either leave the flag
> > unset, or do something similar to the TSC code where the cyc2ns shift is
> > used. If this is something we want to handle generically, then I'll have
> > a go at generalizing the TSC cyc2ns scaling bits for the next spin.
> 
> Gah. There is no locking issue. As Peter explained before the
> scheduler code can cope with some inaccurate value.
> 
> The wrap issue is completly academic. If the current clock source has
> a wrap issue then it needs to be addressed anyway by frequent enough
> wakeups to assure correctness of timekeeping and that makes it
> suitable for the sched clock domain as well. Also the scheduler can
> not hit a value which has not gone through the irq_enter() based
> update after a long idle sleep.
> 
> So changing your previous patch from
> 
>    if (clock && clock->rating > 100)
> 
> to
> 
>    if (clock && (clock->flags & CLOCK_SOURCE_USE_FOR_SCHED_CLOCK))
> 
> is sufficient.
> 
Works for me.. here's v3 with an updated changelog.

--

sched: Support current clocksource handling in fallback sched_clock(), v3.

There are presently a number of issues and limitations with how the
clocksource and sched_clock() interaction works today. Configurations
tend to be grouped in to one of the following:

	- Platform provides a clocksource unsuitable for sched_clock()
	  and prefers to use the generic jiffies-backed implementation.

	- Platform provides its own clocksource and sched_clock() that
	  wraps in to it.

	- Platform uses a generic clocksource (ie, drivers/clocksource/)
	  combined with the generic jiffies-backed sched_clock().

	- Platform supports multiple sched_clock()-capable clocksources.

This patch adds a new CLOCK_SOURCE_USE_FOR_SCHED_CLOCK flag to address
these issues. The first case simply doesn't set the flag at all (or
clears it, if a clocksource is unstable), while the second case is made
redundant for any sched_clock() implementation that just does the
cyc2ns() case, which tends to be the vast majority of the embedded
platforms.

The remaining cases are handled transparently, in that sched_clock() will
always read from whatever the current clocksource is, as long as it is
has the flag set. This permits switching between multiple clocksources
which may or may not support being used by sched_clock(), and while some
inaccuracy may occur in these corner cases, the scheduler can live with
this.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 include/linux/clocksource.h |    1 +
 kernel/sched_clock.c        |    9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index c56457c..70d156f 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -212,6 +212,7 @@ extern struct clocksource *clock;	/* current clocksource */
 
 #define CLOCK_SOURCE_WATCHDOG			0x10
 #define CLOCK_SOURCE_VALID_FOR_HRES		0x20
+#define CLOCK_SOURCE_USE_FOR_SCHED_CLOCK	0x40
 
 /* simplify initialization of mask field */
 #define CLOCKSOURCE_MASK(bits) (cycle_t)((bits) < 64 ? ((1ULL<<(bits))-1) : -1)
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index e1d16c9..a0c18da 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -30,6 +30,7 @@
 #include <linux/percpu.h>
 #include <linux/ktime.h>
 #include <linux/sched.h>
+#include <linux/clocksource.h>
 
 /*
  * Scheduler clock - returns current time in nanosec units.
@@ -38,6 +39,14 @@
  */
 unsigned long long __attribute__((weak)) sched_clock(void)
 {
+	/*
+	 * Use the current clocksource when it becomes available later in
+	 * the boot process, and ensure that it is usable for sched_clock().
+	 */
+	if (clock && (clock->flags & CLOCK_SOURCE_USE_FOR_SCHED_CLOCK))
+		return cyc2ns(clock, clocksource_read(clock));
+
+	/* Otherwise just fall back on jiffies */
 	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
 					* (NSEC_PER_SEC / HZ);
 }
