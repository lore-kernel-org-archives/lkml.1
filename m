Return-Path: <linux-kernel-owner+w=401wt.eu-S1760975AbZEGOxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975AbZEGOxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbZEGOwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:52:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51024 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbZEGOws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:52:48 -0400
Message-ID: <4A02F5A3.3050004@ti.com>
Date: Thu, 7 May 2009 09:52:19 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep for
 more than 2.15 seconds
References: <49ECE615.2010800@ti.com>  <20090421063523.GA8020@elte.hu>	 <1240345936.6080.6.camel@localhost>  <49EE54B4.9020700@ti.com> <1240358525.6080.40.camel@localhost>
In-Reply-To: <1240358525.6080.40.camel@localhost>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


john stultz wrote:
> So yes, while your patch in of itself doesn't create the issue, it does
> open the window a bit more. I'm just saying we need to add the
> clocksource limiting factor in before more odd configs trip over it. :)

Thanks, this helps. I have been looking into this some more and it seems 
to me that the appropriate place in the tick_nohz_stop_sched_tick() 
function to check the clocksource upper limit would be in the following 
code segment:

	/* Read jiffies and the time when jiffies were updated last */
          do {
                  seq = read_seqbegin(&xtime_lock);
                  last_update = last_jiffies_update;
                  last_jiffies = jiffies;
          } while (read_seqretry(&xtime_lock, seq));

          /* Get the next timer wheel timer */
          next_jiffies = get_next_timer_interrupt(last_jiffies);
          delta_jiffies = next_jiffies - last_jiffies;


Here is my thinking...

1). The above do-while is holding the xtime_lock for updating a couple 
variables. Given that we would need to hold this lock when querying the 
max time that the clocksource can be deferred it would seem to make 
sense to do it in this same loop to avoid requesting the same lock twice 
in the same function.

2). The function "get_next_timer_interrupt()" returns the time of when 
the next timer event is due to expire. If we know the maximum number of 
jiffies that can elapse before the clocksource wraps, then we can simply 
compare delta_jiffies with the maximum jiffies for the clocksource and 
adjust delta_jiffies if it is greater than the maximum jiffies.

3). The maximum jiffies that can elapse before a clocksource wraps 
should be a constant value which can be derived from the clocksource 
mask value. Therefore, I was thinking that it would be more 
efficient/optimal to calculate the maximum jiffies that can elapse 
before the clocksource wraps when the clocksource is registered and 
store it in the main clocksource structure.

So taking the above into account, I was thinking of something along the 
lines of the following. Let me know if you have any thoughts/comments.

Cheers
Jon


Signed-off-by: Jon Hunter <jon-hunter@ti.com>
---
  include/linux/clockchips.h  |    6 +++---
  include/linux/clocksource.h |   16 ++++++++++++++++
  include/linux/time.h        |    1 +
  kernel/hrtimer.c            |    2 +-
  kernel/time/clockevents.c   |   10 +++++-----
  kernel/time/clocksource.c   |    6 ++++++
  kernel/time/tick-oneshot.c  |    2 +-
  kernel/time/tick-sched.c    |   17 ++++++++++++++++-
  kernel/time/timekeeping.c   |   10 ++++++++++
  kernel/time/timer_list.c    |    4 ++--
  10 files changed, 61 insertions(+), 13 deletions(-)

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

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 5a40d14..2e45f54 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -151,6 +151,7 @@ extern u64 timecounter_cyc2time(struct timecounter *tc,
   * @mult:		cycle to nanosecond multiplier (adjusted by NTP)
   * @mult_orig:		cycle to nanosecond multiplier (unadjusted by NTP)
   * @shift:		cycle to nanosecond divisor (power of two)
+ * @max_jiffies:	max jiffies that can elapse before the clocksource wraps
   * @flags:		flags describing special propertiesDynamic Tick: Allow 
32-bit machines to sleep for more than 2.15 seconds
   * @vread:		vsyscall based read
   * @resume:		resume function for the clocksource, if necessary
@@ -171,6 +172,7 @@ struct clocksource {
  	u32 mult;
  	u32 mult_orig;
  	u32 shift;
+	unsigned long max_jiffies;
  	unsigned long flags;
  	cycle_t (*vread)(void);
  	void (*resume)(void);
@@ -322,6 +324,20 @@ static inline s64 cyc2ns(struct clocksource *cs, 
cycle_t cycles)
  }

  /**
+ * cyc2jiffies - converts clocksource cycles to jiffies
+ * @cs:         Pointer to clocksource
+ * @cycles:     Cycles
+ *
+ */
+static inline unsigned long cyc2jiffies(struct clocksource *cs, cycle_t 
cycles)
+{
+	struct timespec ts;
+
+	ts = ns_to_timespec(cyc2ns(cs, cycles));
+	return timespec_to_jiffies(&ts);
+}
+
+/**
   * clocksource_calculate_interval - Calculates a clocksource interval 
struct
   *
   * @c:		Pointer to clocksource.
diff --git a/include/linux/time.h b/include/linux/time.h
index 242f624..51f80aa 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -130,6 +130,7 @@ extern void monotonic_to_bootbased(struct timespec *ts);

  extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
  extern int timekeeping_valid_for_hres(void);
+extern unsigned long timekeeping_max_jiffies(void);
  extern void update_wall_time(void);
  extern void update_xtime_cache(u64 nsec);

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
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index ecfd7b5..c6cbf47 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -405,6 +405,12 @@ int clocksource_register(struct clocksource *c)
  	/* save mult_orig on registration */
  	c->mult_orig = c->mult;

+	/*
+	 * calculate max jiffies than can occur
+	 * before clocksource wraps
+	 */
+	c->max_jiffies = cyc2jiffies(c, c->mask);
+
  	spin_lock_irqsave(&clocksource_lock, flags);
  	ret = clocksource_enqueue(c);
  	if (!ret)
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

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d3f1ef4..983eb5f 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -212,7 +212,8 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
   */
  void tick_nohz_stop_sched_tick(int inidle)
  {
-	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies, flags;
+	unsigned long seq, flags;
+	unsigned long last_jiffies, next_jiffies, delta_jiffies, max_jiffies;
  	struct tick_sched *ts;
  	ktime_t last_update, expires, now;
  	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
@@ -264,12 +265,26 @@ void tick_nohz_stop_sched_tick(int inidle)
  		seq = read_seqbegin(&xtime_lock);
  		last_update = last_jiffies_update;
  		last_jiffies = jiffies;
+		max_jiffies = timekeeping_max_jiffies();
  	} while (read_seqretry(&xtime_lock, seq));

  	/* Get the next timer wheel timer */
  	next_jiffies = get_next_timer_interrupt(last_jiffies);
  	delta_jiffies = next_jiffies - last_jiffies;

+	/*
+	 * Make sure that the delta jiffies is not greater than
+	 * the max jiffies for the current clocksource.
+	 */
+	if (delta_jiffies >= max_jiffies) {
+
+		/*
+		 * Set delta jiffies to the maximum number of jiffies
+		 * less 1 to ensure that the clocksource will not wrap.
+		 */
+		delta_jiffies = max_jiffies - 1;
+	}
+
  	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu))
  		delta_jiffies = 1;
  	/*
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 687dff4..cd35bfc 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -271,6 +271,16 @@ int timekeeping_valid_for_hres(void)
  }

  /**
+ * timekeeping_max_jiffies - returns max jiffies the current 
clocksource can count
+ *
+ * IMPORTANT: Must be called with xtime_lock held!
+ */
+unsigned long timekeeping_max_jiffies(void)
+{
+	return clock->max_jiffies;
+}
+
+/**
   * read_persistent_clock -  Return time in seconds from the persistent 
clock.
   *
   * Weak dummy function for arches that do not yet support it.
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
