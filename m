Return-Path: <linux-kernel-owner+w=401wt.eu-S932364AbZE0OuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbZE0OuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 10:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932117AbZE0Ot7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 10:49:59 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54932 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbZE0Ot6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 10:49:58 -0400
Message-ID: <4A1D52EB.8040107@ti.com>
Date: Wed, 27 May 2009 09:49:15 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/2] Dynamic Tick: Allow 32-bit machines to sleep for more
 than 2.15 seconds
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In the dynamic tick code, "max_delta_ns" (member of the 
"clock_event_device" structure) represents the maximum sleep time that 
can occur between timer events in nanoseconds.

The variable, "max_delta_ns", is defined as an unsigned long which is a 
32-bit integer for 32-bit machines and a 64-bit integer for 64-bit 
machines (if -m64 option is used for gcc). The value of max_delta_ns is 
set by calling the function "clockevent_delta2ns()" which returns a 
maximum value of LONG_MAX. For a 32-bit machine LONG_MAX is equal to 
0x7fffffff and in nanoseconds this equates to ~2.15 seconds. Hence, the 
maximum sleep time for a 32-bit machine is ~2.15 seconds, where as for a 
64-bit machine it will be many years.

This patch changes the type of max_delta_ns to be "unsigned long long" 
instead of "unsigned long" so that this variable is a 64-bit type for 
both 32-bit and 64-bit machines. It also changes the maximum value 
returned by clockevent_delta2ns() to LLONG_MAX. Hence this allows a 
32-bit machine to sleep for longer than ~2.15 seconds. Please note that 
this patch changes "min_delta_ns" to be "unsigned long long" as well and 
although this is probably unnecessary, it makes the patch simpler.

Signed-off-by: Jon Hunter <jon-hunter@ti.com>
---
  include/linux/clockchips.h |    6 +++---
  kernel/hrtimer.c           |    2 +-
  kernel/time/clockevents.c  |   10 +++++-----
  kernel/time/tick-oneshot.c |    2 +-
  kernel/time/timer_list.c   |    4 ++--
  5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 3a1dbba..8154bc6 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -77,8 +77,8 @@ enum clock_event_nofitiers {
  struct clock_event_device {
  	const char		*name;
  	unsigned int		features;
-	unsigned long		max_delta_ns;
-	unsigned long		min_delta_ns;
+	unsigned long long	max_delta_ns;
+	unsigned long long	min_delta_ns;
  	unsigned long		mult;
  	int			shift;
  	int			rating;
@@ -116,7 +116,7 @@ static inline unsigned long div_sc(unsigned long 
ticks, unsigned long nsec,
  }

  /* Clock event layer functions */
-extern unsigned long clockevent_delta2ns(unsigned long latch,
+extern unsigned long long clockevent_delta2ns(unsigned long latch,
  					 struct clock_event_device *evt);
  extern void clockevents_register_device(struct clock_event_device *dev);

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index cb8a15c..5b1cdc4 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1199,7 +1199,7 @@ hrtimer_interrupt_hanging(struct 
clock_event_device *dev,
  	force_clock_reprogram = 1;
  	dev->min_delta_ns = (unsigned long)try_time.tv64 * 3;
  	printk(KERN_WARNING "hrtimer: interrupt too slow, "
-		"forcing clock min delta to %lu ns\n", dev->min_delta_ns);
+		"forcing clock min delta to %llu ns\n", dev->min_delta_ns);
  }
  /*
   * High resolution timer interrupt
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index d13be21..3fa07b3 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -36,10 +36,10 @@ static DEFINE_SPINLOCK(clockevents_lock);
   *
   * Math helper, returns latch value converted to nanoseconds (bound 
checked)
   */
-unsigned long clockevent_delta2ns(unsigned long latch,
+unsigned long long clockevent_delta2ns(unsigned long latch,
  				  struct clock_event_device *evt)
  {
-	u64 clc = ((u64) latch << evt->shift);
+	unsigned long long clc = ((unsigned long long) latch << evt->shift);

  	if (unlikely(!evt->mult)) {
  		evt->mult = 1;
@@ -49,10 +49,10 @@ unsigned long clockevent_delta2ns(unsigned long latch,
  	do_div(clc, evt->mult);
  	if (clc < 1000)
  		clc = 1000;
-	if (clc > LONG_MAX)
-		clc = LONG_MAX;
+	if (clc > LLONG_MAX)
+		clc = LLONG_MAX;

-	return (unsigned long) clc;
+	return clc;
  }

  /**
diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index 2e8de67..857087b 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -50,7 +50,7 @@ int tick_dev_program_event(struct clock_event_device 
*dev, ktime_t expires,
  				dev->min_delta_ns += dev->min_delta_ns >> 1;

  			printk(KERN_WARNING
-			       "CE: %s increasing min_delta_ns to %lu nsec\n",
+			       "CE: %s increasing min_delta_ns to %llu nsec\n",
  			       dev->name ? dev->name : "?",
  			       dev->min_delta_ns << 1);

diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index a999b92..3bf30b4 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -204,8 +204,8 @@ print_tickdevice(struct seq_file *m, struct 
tick_device *td, int cpu)
  		return;
  	}
  	SEQ_printf(m, "%s\n", dev->name);
-	SEQ_printf(m, " max_delta_ns:   %lu\n", dev->max_delta_ns);
-	SEQ_printf(m, " min_delta_ns:   %lu\n", dev->min_delta_ns);
+	SEQ_printf(m, " max_delta_ns:   %llu\n", dev->max_delta_ns);
+	SEQ_printf(m, " min_delta_ns:   %llu\n", dev->min_delta_ns);
  	SEQ_printf(m, " mult:           %lu\n", dev->mult);
  	SEQ_printf(m, " shift:          %d\n", dev->shift);
  	SEQ_printf(m, " mode:           %d\n", dev->mode);
-- 
1.6.1
