Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbZDTVQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbZDTVQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 17:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757386AbZDTVQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 17:16:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46867 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982AbZDTVQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 17:16:16 -0400
Message-ID: <49ECE615.2010800@ti.com>
Date: Mon, 20 Apr 2009 16:16:05 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep for more
 than 2.15 seconds
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

 From reviewing the dynamic tick code, I noticed that the "max_delta_ns"
member of the "clock_event_device" structure, represents the upper limit
between timer events in nanoseconds. The variable, "max_delta_ns", is
defined as an unsigned long. An unsigned long is a 32-bit integer for 
32-bit machines and is a 64-bit integer for 64-bit machines (if -m64 
option is used for gcc). Also see [1].

The variable, "max_delta_ns", is configured by calling function 
"clockevent_delta2ns()". The maximum value that "max_delta_ns" can be 
set to by calling clockevent_delta2ns(), is LONG_MAX. For a 32-bit 
machine LONG_MAX is equal to 0x7fffffff and in nanoseconds this equates 
to ~2.15 seconds. Hence, the maximum sleep time for a 32-bit machine is 
~2.15 seconds, where as for a 64-bit machine it will be many years.

Therefore, I wanted to propose changing the type of max_delta_ns to be 
"unsigned long long" instead of "unsigned long". My understanding is 
that a variable of type "unsigned long long" is 64-bits for both 32-bit 
and 64-bit machines and hence this would allow a 32-bit machine to sleep 
for longer than ~2.15 seconds. Please note that I also ended up making 
"min_delta_ns" of type "unsigned long long" too and although this is 
probably very unnecessary, it made the patch simpler. See below.

Anyway, making this change has allowed my 32-bit machine to sleep for 
longer than ~2.15 seconds and thought this could be of interest to 
others. Your comments/feedback would be appreciated.

[1] http://en.wikipedia.org/wiki/64-bit#64-bit_data_models

Cheers
Jon


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
