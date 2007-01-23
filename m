Return-Path: <linux-kernel-owner+w=401wt.eu-S933014AbXAWFxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbXAWFxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 00:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933025AbXAWFxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 00:53:48 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:2708 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933014AbXAWFxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 00:53:45 -0500
Message-Id: <20070123055344.743809585@mvista.com>
References: <20070123055255.338254780@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Mon, 22 Jan 2007 21:52:56 -0800
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] timekeeping: create kernel/time/timekeeping.c
Content-Disposition: inline; filename=timekeeping_move_out_of_timer_c.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the generic timekeeping code from kernel/timer.c to
kernel/time/timekeeping.c . This requires some glue code which is
added to the include/linux/timekeeping.h header.

Signed-Off-By: Daniel Walker <dwalker@mvista.com> 

---
 include/linux/clocksource.h |    3 
 include/linux/timekeeping.h |   19 +
 kernel/time/Makefile        |    2 
 kernel/time/clocksource.c   |    3 
 kernel/time/timekeeping.c   |  639 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/timer.c              |  630 -------------------------------------------
 6 files changed, 663 insertions(+), 633 deletions(-)

Index: linux-2.6.19/include/linux/clocksource.h
===================================================================
--- linux-2.6.19.orig/include/linux/clocksource.h
+++ linux-2.6.19/include/linux/clocksource.h
@@ -18,6 +18,9 @@
 /* clocksource cycle base type */
 typedef u64 cycle_t;
 
+/* XXX - Would like a better way for initializing curr_clocksource */
+extern struct clocksource clocksource_jiffies;
+
 /**
  * struct clocksource - hardware abstraction for a free running counter
  *	Provides mostly state-free accessors to the underlying hardware.
Index: linux-2.6.19/include/linux/timekeeping.h
===================================================================
--- /dev/null
+++ linux-2.6.19/include/linux/timekeeping.h
@@ -0,0 +1,19 @@
+#ifndef _LINUX_TIMEKEEPING_H
+#define _LINUX_TIMEKEEPING_H
+
+#include <linux/clocksource.h>
+
+extern void update_wall_time(void);
+
+#ifdef CONFIG_GENERIC_TIME
+
+extern struct clocksource *clock;
+
+#else /* CONFIG_GENERIC_TIME */
+static inline int change_clocksource(void)
+{
+	return 0;
+}
+#endif /* !CONFIG_GENERIC_TIME */
+
+#endif /* _LINUX_TIMEKEEPING_H */
Index: linux-2.6.19/kernel/time/Makefile
===================================================================
--- linux-2.6.19.orig/kernel/time/Makefile
+++ linux-2.6.19/kernel/time/Makefile
@@ -1,4 +1,4 @@
-obj-y += ntp.o clocksource.o jiffies.o timer_list.o
+obj-y += ntp.o clocksource.o jiffies.o timer_list.o timekeeping.o
 
 obj-$(CONFIG_GENERIC_CLOCKEVENTS)	+= clockevents.o
 obj-$(CONFIG_TIMER_STATS)		+= timer_stats.o
Index: linux-2.6.19/kernel/time/clocksource.c
===================================================================
--- linux-2.6.19.orig/kernel/time/clocksource.c
+++ linux-2.6.19/kernel/time/clocksource.c
@@ -29,9 +29,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 
-/* XXX - Would like a better way for initializing curr_clocksource */
-extern struct clocksource clocksource_jiffies;
-
 /*[Clocksource internal variables]---------
  * curr_clocksource:
  *	currently selected clocksource. Initialized to clocksource_jiffies.
Index: linux-2.6.19/kernel/time/timekeeping.c
===================================================================
--- /dev/null
+++ linux-2.6.19/kernel/time/timekeeping.c
@@ -0,0 +1,639 @@
+
+
+#include <linux/module.h>
+#include <linux/timekeeping.h>
+#include <linux/time.h>
+#include <linux/hrtimer.h>
+
+/*
+ * flag for if timekeeping is suspended
+ */
+static int timekeeping_suspended;
+
+/*
+ * time in seconds when suspend began
+ */
+static unsigned long timekeeping_suspend_time;
+
+/*
+ * Clock used for timekeeping
+ */
+struct clocksource *clock = &clocksource_jiffies;
+
+/*
+ * The current time
+ * wall_to_monotonic is what we need to add to xtime (or xtime corrected
+ * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
+ * at zero at system boot time, so wall_to_monotonic will be negative,
+ * however, we will ALWAYS keep the tv_nsec part positive so we can use
+ * the usual normalization.
+ */
+struct timespec xtime __attribute__ ((aligned (16)));
+struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
+
+EXPORT_SYMBOL(xtime);
+
+#ifdef CONFIG_GENERIC_TIME
+/**
+ * __get_nsec_offset - Returns nanoseconds since last call to periodic_hook
+ *
+ * private function, must hold xtime_lock lock when being
+ * called. Returns the number of nanoseconds since the
+ * last call to update_wall_time() (adjusted by NTP scaling)
+ */
+static inline s64 __get_nsec_offset(void)
+{
+	cycle_t cycle_now, cycle_delta;
+	s64 ns_offset;
+
+	/* read clocksource: */
+	cycle_now = clocksource_read(clock);
+
+	/* calculate the delta since the last update_wall_time: */
+	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+
+	/* convert to nanoseconds: */
+	ns_offset = cyc2ns(clock, cycle_delta);
+
+	return ns_offset;
+}
+
+/**
+ * __get_realtime_clock_ts - Returns the time of day in a timespec
+ * @ts:		pointer to the timespec to be set
+ *
+ * Returns the time of day in a timespec. Used by
+ * do_gettimeofday() and get_realtime_clock_ts().
+ */
+static inline void __get_realtime_clock_ts(struct timespec *ts)
+{
+	unsigned long seq;
+	s64 nsecs;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+
+		*ts = xtime;
+		nsecs = __get_nsec_offset();
+
+	} while (read_seqretry(&xtime_lock, seq));
+
+	timespec_add_ns(ts, nsecs);
+}
+
+/**
+ * getnstimeofday - Returns the time of day in a timespec
+ * @ts:		pointer to the timespec to be set
+ *
+ * Returns the time of day in a timespec.
+ */
+void getnstimeofday(struct timespec *ts)
+{
+	__get_realtime_clock_ts(ts);
+}
+
+EXPORT_SYMBOL(getnstimeofday);
+
+/**
+ * do_gettimeofday - Returns the time of day in a timeval
+ * @tv:		pointer to the timeval to be set
+ *
+ * NOTE: Users should be converted to using get_realtime_clock_ts()
+ */
+void do_gettimeofday(struct timeval *tv)
+{
+	struct timespec now;
+
+	__get_realtime_clock_ts(&now);
+	tv->tv_sec = now.tv_sec;
+	tv->tv_usec = now.tv_nsec/1000;
+}
+
+EXPORT_SYMBOL(do_gettimeofday);
+/**
+ * do_settimeofday - Sets the time of day
+ * @tv:		pointer to the timespec variable containing the new time
+ *
+ * Sets the time of day to the new time and update NTP and notify hrtimers
+ */
+int do_settimeofday(struct timespec *tv)
+{
+	unsigned long flags;
+	time_t wtm_sec, sec = tv->tv_sec;
+	long wtm_nsec, nsec = tv->tv_nsec;
+
+	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
+		return -EINVAL;
+
+	write_seqlock_irqsave(&xtime_lock, flags);
+
+	nsec -= __get_nsec_offset();
+
+	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
+	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
+
+	set_normalized_timespec(&xtime, sec, nsec);
+	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
+
+	clock->error = 0;
+	ntp_clear();
+
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	/* signal hrtimers about time change */
+	clock_was_set();
+
+	return 0;
+}
+
+EXPORT_SYMBOL(do_settimeofday);
+
+/**
+ * change_clocksource - Swaps clocksources if a new one is available
+ *
+ * Accumulates current time interval and initializes new clocksource
+ */
+static int change_clocksource(void)
+{
+	struct clocksource *new;
+	cycle_t now;
+	u64 nsec;
+	new = clocksource_get_next();
+	if (clock != new) {
+		now = clocksource_read(new);
+		nsec =  __get_nsec_offset();
+		timespec_add_ns(&xtime, nsec);
+
+		clock = new;
+		clock->cycle_last = now;
+		printk(KERN_INFO "Time: %s clocksource has been installed.\n",
+		       clock->name);
+		return 1;
+	} else if (clock->update_callback) {
+		return clock->update_callback();
+	}
+	return 0;
+}
+
+/**
+ * timeofday_is_continuous - check to see if timekeeping is free running
+ */
+int timekeeping_is_continuous(void)
+{
+	unsigned long seq;
+	int ret;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+
+		ret = clock->is_continuous;
+
+	} while (read_seqretry(&xtime_lock, seq));
+
+	return ret;
+}
+#endif /* CONFIG_GENERIC_TIME */
+
+/**
+ * read_persistent_clock -  Return time in seconds from the persistent clock.
+ *
+ * Weak dummy function for arches that do not yet support it.
+ * Returns seconds from epoch using the battery backed persistent clock.
+ * Returns zero if unsupported.
+ *
+ *  XXX - Do be sure to remove it once all arches implement it.
+ */
+unsigned long __attribute__((weak)) read_persistent_clock(void)
+{
+	return 0;
+}
+
+/*
+ * timekeeping_init - Initializes the clocksource and common timekeeping values
+ */
+void __init timekeeping_init(void)
+{
+	unsigned long flags;
+	unsigned long sec = read_persistent_clock();
+
+	write_seqlock_irqsave(&xtime_lock, flags);
+
+	ntp_clear();
+
+	clock = clocksource_get_next();
+	clocksource_calculate_interval(clock, tick_nsec);
+	clock->cycle_last = clocksource_read(clock);
+
+	xtime.tv_sec = sec;
+	xtime.tv_nsec = 0;
+	set_normalized_timespec(&wall_to_monotonic,
+		-xtime.tv_sec, -xtime.tv_nsec);
+
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+}
+
+
+/* flag for if timekeeping is suspended */
+static int timekeeping_suspended;
+/* time in seconds when suspend began */
+static unsigned long timekeeping_suspend_time;
+
+/**
+ * timekeeping_resume - Resumes the generic timekeeping subsystem.
+ * @dev:	unused
+ *
+ * This is for the generic clocksource timekeeping.
+ * xtime/wall_to_monotonic/jiffies/etc are
+ * still managed by arch specific suspend/resume code.
+ */
+static int timekeeping_resume(struct sys_device *dev)
+{
+	unsigned long flags;
+	unsigned long now = read_persistent_clock();
+
+	write_seqlock_irqsave(&xtime_lock, flags);
+
+	if (now && (now > timekeeping_suspend_time)) {
+		unsigned long sleep_length = now - timekeeping_suspend_time;
+		xtime.tv_sec += sleep_length;
+		jiffies_64 += (u64)sleep_length * HZ;
+	}
+	/* re-base the last cycle value */
+	clock->cycle_last = clocksource_read(clock);
+	clock->error = 0;
+	timekeeping_suspended = 0;
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	hrtimer_notify_resume();
+
+	return 0;
+}
+
+static int timekeeping_suspend(struct sys_device *dev, pm_message_t state)
+{
+	unsigned long flags;
+
+	write_seqlock_irqsave(&xtime_lock, flags);
+	timekeeping_suspended = 1;
+	timekeeping_suspend_time = read_persistent_clock();
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+	return 0;
+}
+
+/* sysfs resume/suspend bits for timekeeping */
+static struct sysdev_class timekeeping_sysclass = {
+	.resume		= timekeeping_resume,
+	.suspend	= timekeeping_suspend,
+	set_kset_name("timekeeping"),
+};
+
+static struct sys_device device_timer = {
+	.id		= 0,
+	.cls		= &timekeeping_sysclass,
+};
+
+static int __init timekeeping_init_device(void)
+{
+	int error = sysdev_class_register(&timekeeping_sysclass);
+	if (!error)
+		error = sysdev_register(&device_timer);
+	return error;
+}
+
+device_initcall(timekeeping_init_device);
+
+/*
+ * If the error is already larger, we look ahead even further
+ * to compensate for late or lost adjustments.
+ */
+static __always_inline int clocksource_bigadjust(s64 error, s64 *interval,
+						 s64 *offset)
+{
+	s64 tick_error, i;
+	u32 look_ahead, adj;
+	s32 error2, mult;
+
+	/*
+	 * Use the current error value to determine how much to look ahead.
+	 * The larger the error the slower we adjust for it to avoid problems
+	 * with losing too many ticks, otherwise we would overadjust and
+	 * produce an even larger error.  The smaller the adjustment the
+	 * faster we try to adjust for it, as lost ticks can do less harm
+	 * here.  This is tuned so that an error of about 1 msec is adusted
+	 * within about 1 sec (or 2^20 nsec in 2^SHIFT_HZ ticks).
+	 */
+	error2 = clock->error >> (TICK_LENGTH_SHIFT + 22 - 2 * SHIFT_HZ);
+	error2 = abs(error2);
+	for (look_ahead = 0; error2 > 0; look_ahead++)
+		error2 >>= 2;
+
+	/*
+	 * Now calculate the error in (1 << look_ahead) ticks, but first
+	 * remove the single look ahead already included in the error.
+	 */
+	tick_error = current_tick_length() >>
+		(TICK_LENGTH_SHIFT - clock->shift + 1);
+	tick_error -= clock->xtime_interval >> 1;
+	error = ((error - tick_error) >> look_ahead) + tick_error;
+
+	/* Finally calculate the adjustment shift value.  */
+	i = *interval;
+	mult = 1;
+	if (error < 0) {
+		error = -error;
+		*interval = -*interval;
+		*offset = -*offset;
+		mult = -1;
+	}
+	for (adj = 0; error > i; adj++)
+		error >>= 1;
+
+	*interval <<= adj;
+	*offset <<= adj;
+	return mult << adj;
+}
+
+/*
+ * Adjust the multiplier to reduce the error value,
+ * this is optimized for the most common adjustments of -1,0,1,
+ * for other values we can do a bit more work.
+ */
+static void clocksource_adjust(struct clocksource *clock, s64 offset)
+{
+	s64 error, interval = clock->cycle_interval;
+	int adj;
+
+	error = clock->error >> (TICK_LENGTH_SHIFT - clock->shift - 1);
+	if (error > interval) {
+		error >>= 2;
+		if (likely(error <= interval))
+			adj = 1;
+		else
+			adj = clocksource_bigadjust(error, &interval, &offset);
+	} else if (error < -interval) {
+		error >>= 2;
+		if (likely(error >= -interval)) {
+			adj = -1;
+			interval = -interval;
+			offset = -offset;
+		} else
+			adj = clocksource_bigadjust(error, &interval, &offset);
+	} else
+		return;
+
+	clock->mult += adj;
+	clock->xtime_interval += interval;
+	clock->xtime_nsec -= offset;
+	clock->error -= (interval - offset) <<
+			(TICK_LENGTH_SHIFT - clock->shift);
+}
+
+/**
+ * update_wall_time - Uses the current clocksource to increment the wall time
+ *
+ * Called from the timer interrupt, must hold a write on xtime_lock.
+ */
+void update_wall_time(void)
+{
+	cycle_t offset;
+
+	/* Make sure we're fully resumed: */
+	if (unlikely(timekeeping_suspended))
+		return;
+
+#ifdef CONFIG_GENERIC_TIME
+	offset = (clocksource_read(clock) - clock->cycle_last) & clock->mask;
+#else
+	offset = clock->cycle_interval;
+#endif
+	clock->xtime_nsec += (s64)xtime.tv_nsec << clock->shift;
+
+	/* normally this loop will run just once, however in the
+	 * case of lost or late ticks, it will accumulate correctly.
+	 */
+	while (offset >= clock->cycle_interval) {
+		/* accumulate one interval */
+		clock->xtime_nsec += clock->xtime_interval;
+		clock->cycle_last += clock->cycle_interval;
+		offset -= clock->cycle_interval;
+
+		if (clock->xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
+			clock->xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
+			xtime.tv_sec++;
+			second_overflow();
+		}
+
+		/* interpolator bits */
+		time_interpolator_update(clock->xtime_interval
+						>> clock->shift);
+
+		/* accumulate error between NTP and clock interval */
+		clock->error += current_tick_length();
+		clock->error -= clock->xtime_interval << (TICK_LENGTH_SHIFT - clock->shift);
+	}
+
+	/* correct the clock when NTP error is too big */
+	clocksource_adjust(clock, offset);
+
+	/* store full nanoseconds into xtime */
+	xtime.tv_nsec = (s64)clock->xtime_nsec >> clock->shift;
+	clock->xtime_nsec -= (s64)xtime.tv_nsec << clock->shift;
+
+	/* check to see if there is a new clocksource to use */
+	if (change_clocksource()) {
+		clock->error = 0;
+		clock->xtime_nsec = 0;
+		hrtimer_clock_notify();
+		clocksource_calculate_interval(clock, tick_nsec);
+	}
+	update_vsyscall(&xtime, clock);
+}
+
+#ifdef CONFIG_TIME_INTERPOLATION
+
+struct time_interpolator *time_interpolator __read_mostly;
+static struct time_interpolator *time_interpolator_list __read_mostly;
+static DEFINE_SPINLOCK(time_interpolator_lock);
+
+static inline cycles_t time_interpolator_get_cycles(unsigned int src)
+{
+	unsigned long (*x)(void);
+
+	switch (src)
+	{
+		case TIME_SOURCE_FUNCTION:
+			x = time_interpolator->addr;
+			return x();
+
+		case TIME_SOURCE_MMIO64	:
+			return readq_relaxed((void __iomem *)time_interpolator->addr);
+
+		case TIME_SOURCE_MMIO32	:
+			return readl_relaxed((void __iomem *)time_interpolator->addr);
+
+		default: return get_cycles();
+	}
+}
+
+static inline u64 time_interpolator_get_counter(int writelock)
+{
+	unsigned int src = time_interpolator->source;
+
+	if (time_interpolator->jitter)
+	{
+		cycles_t lcycle;
+		cycles_t now;
+
+		do {
+			lcycle = time_interpolator->last_cycle;
+			now = time_interpolator_get_cycles(src);
+			if (lcycle && time_after(lcycle, now))
+				return lcycle;
+
+			/* When holding the xtime write lock, there's no need
+			 * to add the overhead of the cmpxchg.  Readers are
+			 * force to retry until the write lock is released.
+			 */
+			if (writelock) {
+				time_interpolator->last_cycle = now;
+				return now;
+			}
+			/* Keep track of the last timer value returned. The use of cmpxchg here
+			 * will cause contention in an SMP environment.
+			 */
+		} while (unlikely(cmpxchg(&time_interpolator->last_cycle, lcycle, now) != lcycle));
+		return now;
+	}
+	else
+		return time_interpolator_get_cycles(src);
+}
+
+void time_interpolator_reset(void)
+{
+	time_interpolator->offset = 0;
+	time_interpolator->last_counter = time_interpolator_get_counter(1);
+}
+
+#define GET_TI_NSECS(count,i) (((((count) - i->last_counter) & (i)->mask) * (i)->nsec_per_cyc) >> (i)->shift)
+
+unsigned long time_interpolator_get_offset(void)
+{
+	/* If we do not have a time interpolator set up then just return zero */
+	if (!time_interpolator)
+		return 0;
+
+	return time_interpolator->offset +
+		GET_TI_NSECS(time_interpolator_get_counter(0), time_interpolator);
+}
+
+#define INTERPOLATOR_ADJUST 65536
+#define INTERPOLATOR_MAX_SKIP 10*INTERPOLATOR_ADJUST
+
+void time_interpolator_update(long delta_nsec)
+{
+	u64 counter;
+	unsigned long offset;
+
+	/* If there is no time interpolator set up then do nothing */
+	if (!time_interpolator)
+		return;
+
+	/*
+	 * The interpolator compensates for late ticks by accumulating the late
+	 * time in time_interpolator->offset. A tick earlier than expected will
+	 * lead to a reset of the offset and a corresponding jump of the clock
+	 * forward. Again this only works if the interpolator clock is running
+	 * slightly slower than the regular clock and the tuning logic insures
+	 * that.
+	 */
+
+	counter = time_interpolator_get_counter(1);
+	offset = time_interpolator->offset +
+			GET_TI_NSECS(counter, time_interpolator);
+
+	if (delta_nsec < 0 || (unsigned long) delta_nsec < offset)
+		time_interpolator->offset = offset - delta_nsec;
+	else {
+		time_interpolator->skips++;
+		time_interpolator->ns_skipped += delta_nsec - offset;
+		time_interpolator->offset = 0;
+	}
+	time_interpolator->last_counter = counter;
+
+	/* Tuning logic for time interpolator invoked every minute or so.
+	 * Decrease interpolator clock speed if no skips occurred and an offset is carried.
+	 * Increase interpolator clock speed if we skip too much time.
+	 */
+	if (jiffies % INTERPOLATOR_ADJUST == 0)
+	{
+		if (time_interpolator->skips == 0 && time_interpolator->offset > tick_nsec)
+			time_interpolator->nsec_per_cyc--;
+		if (time_interpolator->ns_skipped > INTERPOLATOR_MAX_SKIP && time_interpolator->offset == 0)
+			time_interpolator->nsec_per_cyc++;
+		time_interpolator->skips = 0;
+		time_interpolator->ns_skipped = 0;
+	}
+}
+
+static inline int
+is_better_time_interpolator(struct time_interpolator *new)
+{
+	if (!time_interpolator)
+		return 1;
+	return new->frequency > 2*time_interpolator->frequency ||
+	    (unsigned long)new->drift < (unsigned long)time_interpolator->drift;
+}
+
+void
+register_time_interpolator(struct time_interpolator *ti)
+{
+	unsigned long flags;
+
+	/* Sanity check */
+	BUG_ON(ti->frequency == 0 || ti->mask == 0);
+
+	ti->nsec_per_cyc = ((u64)NSEC_PER_SEC << ti->shift) / ti->frequency;
+	spin_lock(&time_interpolator_lock);
+	write_seqlock_irqsave(&xtime_lock, flags);
+	if (is_better_time_interpolator(ti)) {
+		time_interpolator = ti;
+		time_interpolator_reset();
+	}
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	ti->next = time_interpolator_list;
+	time_interpolator_list = ti;
+	spin_unlock(&time_interpolator_lock);
+}
+
+void
+unregister_time_interpolator(struct time_interpolator *ti)
+{
+	struct time_interpolator *curr, **prev;
+	unsigned long flags;
+
+	spin_lock(&time_interpolator_lock);
+	prev = &time_interpolator_list;
+	for (curr = *prev; curr; curr = curr->next) {
+		if (curr == ti) {
+			*prev = curr->next;
+			break;
+		}
+		prev = &curr->next;
+	}
+
+	write_seqlock_irqsave(&xtime_lock, flags);
+	if (ti == time_interpolator) {
+		/* we lost the best time-interpolator: */
+		time_interpolator = NULL;
+		/* find the next-best interpolator */
+		for (curr = time_interpolator_list; curr; curr = curr->next)
+			if (is_better_time_interpolator(curr))
+				time_interpolator = curr;
+		time_interpolator_reset();
+	}
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+	spin_unlock(&time_interpolator_lock);
+}
+#endif /* CONFIG_TIME_INTERPOLATION */
+
Index: linux-2.6.19/kernel/timer.c
===================================================================
--- linux-2.6.19.orig/kernel/timer.c
+++ linux-2.6.19/kernel/timer.c
@@ -35,6 +35,7 @@
 #include <linux/syscalls.h>
 #include <linux/delay.h>
 #include <linux/kallsyms.h>
+#include <linux/timekeeping.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -761,447 +762,6 @@ unsigned long next_timer_interrupt(void)
 
 #endif
 
-/******************************************************************/
-
-/* 
- * The current time 
- * wall_to_monotonic is what we need to add to xtime (or xtime corrected 
- * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
- * at zero at system boot time, so wall_to_monotonic will be negative,
- * however, we will ALWAYS keep the tv_nsec part positive so we can use
- * the usual normalization.
- */
-struct timespec xtime __attribute__ ((aligned (16)));
-struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
-
-EXPORT_SYMBOL(xtime);
-
-
-/* XXX - all of this timekeeping code should be later moved to time.c */
-#include <linux/clocksource.h>
-static struct clocksource *clock; /* pointer to current clocksource */
-
-#ifdef CONFIG_GENERIC_TIME
-/**
- * __get_nsec_offset - Returns nanoseconds since last call to periodic_hook
- *
- * private function, must hold xtime_lock lock when being
- * called. Returns the number of nanoseconds since the
- * last call to update_wall_time() (adjusted by NTP scaling)
- */
-static inline s64 __get_nsec_offset(void)
-{
-	cycle_t cycle_now, cycle_delta;
-	s64 ns_offset;
-
-	/* read clocksource: */
-	cycle_now = clocksource_read(clock);
-
-	/* calculate the delta since the last update_wall_time: */
-	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-
-	/* convert to nanoseconds: */
-	ns_offset = cyc2ns(clock, cycle_delta);
-
-	return ns_offset;
-}
-
-/**
- * __get_realtime_clock_ts - Returns the time of day in a timespec
- * @ts:		pointer to the timespec to be set
- *
- * Returns the time of day in a timespec. Used by
- * do_gettimeofday() and get_realtime_clock_ts().
- */
-static inline void __get_realtime_clock_ts(struct timespec *ts)
-{
-	unsigned long seq;
-	s64 nsecs;
-
-	do {
-		seq = read_seqbegin(&xtime_lock);
-
-		*ts = xtime;
-		nsecs = __get_nsec_offset();
-
-	} while (read_seqretry(&xtime_lock, seq));
-
-	timespec_add_ns(ts, nsecs);
-}
-
-/**
- * getnstimeofday - Returns the time of day in a timespec
- * @ts:		pointer to the timespec to be set
- *
- * Returns the time of day in a timespec.
- */
-void getnstimeofday(struct timespec *ts)
-{
-	__get_realtime_clock_ts(ts);
-}
-
-EXPORT_SYMBOL(getnstimeofday);
-
-/**
- * do_gettimeofday - Returns the time of day in a timeval
- * @tv:		pointer to the timeval to be set
- *
- * NOTE: Users should be converted to using get_realtime_clock_ts()
- */
-void do_gettimeofday(struct timeval *tv)
-{
-	struct timespec now;
-
-	__get_realtime_clock_ts(&now);
-	tv->tv_sec = now.tv_sec;
-	tv->tv_usec = now.tv_nsec/1000;
-}
-
-EXPORT_SYMBOL(do_gettimeofday);
-/**
- * do_settimeofday - Sets the time of day
- * @tv:		pointer to the timespec variable containing the new time
- *
- * Sets the time of day to the new time and update NTP and notify hrtimers
- */
-int do_settimeofday(struct timespec *tv)
-{
-	unsigned long flags;
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irqsave(&xtime_lock, flags);
-
-	nsec -= __get_nsec_offset();
-
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	clock->error = 0;
-	ntp_clear();
-
-	write_sequnlock_irqrestore(&xtime_lock, flags);
-
-	/* signal hrtimers about time change */
-	clock_was_set();
-
-	return 0;
-}
-
-EXPORT_SYMBOL(do_settimeofday);
-
-/**
- * change_clocksource - Swaps clocksources if a new one is available
- *
- * Accumulates current time interval and initializes new clocksource
- */
-static int change_clocksource(void)
-{
-	struct clocksource *new;
-	cycle_t now;
-	u64 nsec;
-	new = clocksource_get_next();
-	if (clock != new) {
-		now = clocksource_read(new);
-		nsec =  __get_nsec_offset();
-		timespec_add_ns(&xtime, nsec);
-
-		clock = new;
-		clock->cycle_last = now;
-		printk(KERN_INFO "Time: %s clocksource has been installed.\n",
-		       clock->name);
-		return 1;
-	} else if (clock->update_callback) {
-		return clock->update_callback();
-	}
-	return 0;
-}
-#else
-static inline int change_clocksource(void)
-{
-	return 0;
-}
-#endif
-
-/**
- * timeofday_is_continuous - check to see if timekeeping is free running
- */
-int timekeeping_is_continuous(void)
-{
-	unsigned long seq;
-	int ret;
-
-	do {
-		seq = read_seqbegin(&xtime_lock);
-
-		ret = clock->is_continuous;
-
-	} while (read_seqretry(&xtime_lock, seq));
-
-	return ret;
-}
-
-/**
- * read_persistent_clock -  Return time in seconds from the persistent clock.
- *
- * Weak dummy function for arches that do not yet support it.
- * Returns seconds from epoch using the battery backed persistent clock.
- * Returns zero if unsupported.
- *
- *  XXX - Do be sure to remove it once all arches implement it.
- */
-unsigned long __attribute__((weak)) read_persistent_clock(void)
-{
-	return 0;
-}
-
-/*
- * timekeeping_init - Initializes the clocksource and common timekeeping values
- */
-void __init timekeeping_init(void)
-{
-	unsigned long flags;
-	unsigned long sec = read_persistent_clock();
-
-	write_seqlock_irqsave(&xtime_lock, flags);
-
-	ntp_clear();
-
-	clock = clocksource_get_next();
-	clocksource_calculate_interval(clock, tick_nsec);
-	clock->cycle_last = clocksource_read(clock);
-
-	xtime.tv_sec = sec;
-	xtime.tv_nsec = 0;
-	set_normalized_timespec(&wall_to_monotonic,
-		-xtime.tv_sec, -xtime.tv_nsec);
-
-	write_sequnlock_irqrestore(&xtime_lock, flags);
-}
-
-
-/* flag for if timekeeping is suspended */
-static int timekeeping_suspended;
-/* time in seconds when suspend began */
-static unsigned long timekeeping_suspend_time;
-
-/**
- * timekeeping_resume - Resumes the generic timekeeping subsystem.
- * @dev:	unused
- *
- * This is for the generic clocksource timekeeping.
- * xtime/wall_to_monotonic/jiffies/etc are
- * still managed by arch specific suspend/resume code.
- */
-static int timekeeping_resume(struct sys_device *dev)
-{
-	unsigned long flags;
-	unsigned long now = read_persistent_clock();
-
-	write_seqlock_irqsave(&xtime_lock, flags);
-
-	if (now && (now > timekeeping_suspend_time)) {
-		unsigned long sleep_length = now - timekeeping_suspend_time;
-		xtime.tv_sec += sleep_length;
-		jiffies_64 += (u64)sleep_length * HZ;
-	}
-	/* re-base the last cycle value */
-	clock->cycle_last = clocksource_read(clock);
-	clock->error = 0;
-	timekeeping_suspended = 0;
-	write_sequnlock_irqrestore(&xtime_lock, flags);
-
-	hrtimer_notify_resume();
-
-	return 0;
-}
-
-static int timekeeping_suspend(struct sys_device *dev, pm_message_t state)
-{
-	unsigned long flags;
-
-	write_seqlock_irqsave(&xtime_lock, flags);
-	timekeeping_suspended = 1;
-	timekeeping_suspend_time = read_persistent_clock();
-	write_sequnlock_irqrestore(&xtime_lock, flags);
-	return 0;
-}
-
-/* sysfs resume/suspend bits for timekeeping */
-static struct sysdev_class timekeeping_sysclass = {
-	.resume		= timekeeping_resume,
-	.suspend	= timekeeping_suspend,
-	set_kset_name("timekeeping"),
-};
-
-static struct sys_device device_timer = {
-	.id		= 0,
-	.cls		= &timekeeping_sysclass,
-};
-
-static int __init timekeeping_init_device(void)
-{
-	int error = sysdev_class_register(&timekeeping_sysclass);
-	if (!error)
-		error = sysdev_register(&device_timer);
-	return error;
-}
-
-device_initcall(timekeeping_init_device);
-
-/*
- * If the error is already larger, we look ahead even further
- * to compensate for late or lost adjustments.
- */
-static __always_inline int clocksource_bigadjust(s64 error, s64 *interval,
-						 s64 *offset)
-{
-	s64 tick_error, i;
-	u32 look_ahead, adj;
-	s32 error2, mult;
-
-	/*
-	 * Use the current error value to determine how much to look ahead.
-	 * The larger the error the slower we adjust for it to avoid problems
-	 * with losing too many ticks, otherwise we would overadjust and
-	 * produce an even larger error.  The smaller the adjustment the
-	 * faster we try to adjust for it, as lost ticks can do less harm
-	 * here.  This is tuned so that an error of about 1 msec is adusted
-	 * within about 1 sec (or 2^20 nsec in 2^SHIFT_HZ ticks).
-	 */
-	error2 = clock->error >> (TICK_LENGTH_SHIFT + 22 - 2 * SHIFT_HZ);
-	error2 = abs(error2);
-	for (look_ahead = 0; error2 > 0; look_ahead++)
-		error2 >>= 2;
-
-	/*
-	 * Now calculate the error in (1 << look_ahead) ticks, but first
-	 * remove the single look ahead already included in the error.
-	 */
-	tick_error = current_tick_length() >>
-		(TICK_LENGTH_SHIFT - clock->shift + 1);
-	tick_error -= clock->xtime_interval >> 1;
-	error = ((error - tick_error) >> look_ahead) + tick_error;
-
-	/* Finally calculate the adjustment shift value.  */
-	i = *interval;
-	mult = 1;
-	if (error < 0) {
-		error = -error;
-		*interval = -*interval;
-		*offset = -*offset;
-		mult = -1;
-	}
-	for (adj = 0; error > i; adj++)
-		error >>= 1;
-
-	*interval <<= adj;
-	*offset <<= adj;
-	return mult << adj;
-}
-
-/*
- * Adjust the multiplier to reduce the error value,
- * this is optimized for the most common adjustments of -1,0,1,
- * for other values we can do a bit more work.
- */
-static void clocksource_adjust(struct clocksource *clock, s64 offset)
-{
-	s64 error, interval = clock->cycle_interval;
-	int adj;
-
-	error = clock->error >> (TICK_LENGTH_SHIFT - clock->shift - 1);
-	if (error > interval) {
-		error >>= 2;
-		if (likely(error <= interval))
-			adj = 1;
-		else
-			adj = clocksource_bigadjust(error, &interval, &offset);
-	} else if (error < -interval) {
-		error >>= 2;
-		if (likely(error >= -interval)) {
-			adj = -1;
-			interval = -interval;
-			offset = -offset;
-		} else
-			adj = clocksource_bigadjust(error, &interval, &offset);
-	} else
-		return;
-
-	clock->mult += adj;
-	clock->xtime_interval += interval;
-	clock->xtime_nsec -= offset;
-	clock->error -= (interval - offset) <<
-			(TICK_LENGTH_SHIFT - clock->shift);
-}
-
-/**
- * update_wall_time - Uses the current clocksource to increment the wall time
- *
- * Called from the timer interrupt, must hold a write on xtime_lock.
- */
-static void update_wall_time(void)
-{
-	cycle_t offset;
-
-	/* Make sure we're fully resumed: */
-	if (unlikely(timekeeping_suspended))
-		return;
-
-#ifdef CONFIG_GENERIC_TIME
-	offset = (clocksource_read(clock) - clock->cycle_last) & clock->mask;
-#else
-	offset = clock->cycle_interval;
-#endif
-	clock->xtime_nsec += (s64)xtime.tv_nsec << clock->shift;
-
-	/* normally this loop will run just once, however in the
-	 * case of lost or late ticks, it will accumulate correctly.
-	 */
-	while (offset >= clock->cycle_interval) {
-		/* accumulate one interval */
-		clock->xtime_nsec += clock->xtime_interval;
-		clock->cycle_last += clock->cycle_interval;
-		offset -= clock->cycle_interval;
-
-		if (clock->xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
-			clock->xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
-			xtime.tv_sec++;
-			second_overflow();
-		}
-
-		/* interpolator bits */
-		time_interpolator_update(clock->xtime_interval
-						>> clock->shift);
-
-		/* accumulate error between NTP and clock interval */
-		clock->error += current_tick_length();
-		clock->error -= clock->xtime_interval << (TICK_LENGTH_SHIFT - clock->shift);
-	}
-
-	/* correct the clock when NTP error is too big */
-	clocksource_adjust(clock, offset);
-
-	/* store full nanoseconds into xtime */
-	xtime.tv_nsec = (s64)clock->xtime_nsec >> clock->shift;
-	clock->xtime_nsec -= (s64)xtime.tv_nsec << clock->shift;
-
-	/* check to see if there is a new clocksource to use */
-	if (change_clocksource()) {
-		clock->error = 0;
-		clock->xtime_nsec = 0;
-		hrtimer_clock_notify();
-		clocksource_calculate_interval(clock, tick_nsec);
-	}
-	update_vsyscall(&xtime, clock);
-}
-
 /*
  * Called from the timer interrupt handler to charge one tick to the current 
  * process.  user_tick is 1 if the tick is user time, 0 for system.
@@ -1733,194 +1293,6 @@ void __init init_timers(void)
 	open_softirq(TIMER_SOFTIRQ, run_timer_softirq, NULL);
 }
 
-#ifdef CONFIG_TIME_INTERPOLATION
-
-struct time_interpolator *time_interpolator __read_mostly;
-static struct time_interpolator *time_interpolator_list __read_mostly;
-static DEFINE_SPINLOCK(time_interpolator_lock);
-
-static inline cycles_t time_interpolator_get_cycles(unsigned int src)
-{
-	unsigned long (*x)(void);
-
-	switch (src)
-	{
-		case TIME_SOURCE_FUNCTION:
-			x = time_interpolator->addr;
-			return x();
-
-		case TIME_SOURCE_MMIO64	:
-			return readq_relaxed((void __iomem *)time_interpolator->addr);
-
-		case TIME_SOURCE_MMIO32	:
-			return readl_relaxed((void __iomem *)time_interpolator->addr);
-
-		default: return get_cycles();
-	}
-}
-
-static inline u64 time_interpolator_get_counter(int writelock)
-{
-	unsigned int src = time_interpolator->source;
-
-	if (time_interpolator->jitter)
-	{
-		cycles_t lcycle;
-		cycles_t now;
-
-		do {
-			lcycle = time_interpolator->last_cycle;
-			now = time_interpolator_get_cycles(src);
-			if (lcycle && time_after(lcycle, now))
-				return lcycle;
-
-			/* When holding the xtime write lock, there's no need
-			 * to add the overhead of the cmpxchg.  Readers are
-			 * force to retry until the write lock is released.
-			 */
-			if (writelock) {
-				time_interpolator->last_cycle = now;
-				return now;
-			}
-			/* Keep track of the last timer value returned. The use of cmpxchg here
-			 * will cause contention in an SMP environment.
-			 */
-		} while (unlikely(cmpxchg(&time_interpolator->last_cycle, lcycle, now) != lcycle));
-		return now;
-	}
-	else
-		return time_interpolator_get_cycles(src);
-}
-
-void time_interpolator_reset(void)
-{
-	time_interpolator->offset = 0;
-	time_interpolator->last_counter = time_interpolator_get_counter(1);
-}
-
-#define GET_TI_NSECS(count,i) (((((count) - i->last_counter) & (i)->mask) * (i)->nsec_per_cyc) >> (i)->shift)
-
-unsigned long time_interpolator_get_offset(void)
-{
-	/* If we do not have a time interpolator set up then just return zero */
-	if (!time_interpolator)
-		return 0;
-
-	return time_interpolator->offset +
-		GET_TI_NSECS(time_interpolator_get_counter(0), time_interpolator);
-}
-
-#define INTERPOLATOR_ADJUST 65536
-#define INTERPOLATOR_MAX_SKIP 10*INTERPOLATOR_ADJUST
-
-void time_interpolator_update(long delta_nsec)
-{
-	u64 counter;
-	unsigned long offset;
-
-	/* If there is no time interpolator set up then do nothing */
-	if (!time_interpolator)
-		return;
-
-	/*
-	 * The interpolator compensates for late ticks by accumulating the late
-	 * time in time_interpolator->offset. A tick earlier than expected will
-	 * lead to a reset of the offset and a corresponding jump of the clock
-	 * forward. Again this only works if the interpolator clock is running
-	 * slightly slower than the regular clock and the tuning logic insures
-	 * that.
-	 */
-
-	counter = time_interpolator_get_counter(1);
-	offset = time_interpolator->offset +
-			GET_TI_NSECS(counter, time_interpolator);
-
-	if (delta_nsec < 0 || (unsigned long) delta_nsec < offset)
-		time_interpolator->offset = offset - delta_nsec;
-	else {
-		time_interpolator->skips++;
-		time_interpolator->ns_skipped += delta_nsec - offset;
-		time_interpolator->offset = 0;
-	}
-	time_interpolator->last_counter = counter;
-
-	/* Tuning logic for time interpolator invoked every minute or so.
-	 * Decrease interpolator clock speed if no skips occurred and an offset is carried.
-	 * Increase interpolator clock speed if we skip too much time.
-	 */
-	if (jiffies % INTERPOLATOR_ADJUST == 0)
-	{
-		if (time_interpolator->skips == 0 && time_interpolator->offset > tick_nsec)
-			time_interpolator->nsec_per_cyc--;
-		if (time_interpolator->ns_skipped > INTERPOLATOR_MAX_SKIP && time_interpolator->offset == 0)
-			time_interpolator->nsec_per_cyc++;
-		time_interpolator->skips = 0;
-		time_interpolator->ns_skipped = 0;
-	}
-}
-
-static inline int
-is_better_time_interpolator(struct time_interpolator *new)
-{
-	if (!time_interpolator)
-		return 1;
-	return new->frequency > 2*time_interpolator->frequency ||
-	    (unsigned long)new->drift < (unsigned long)time_interpolator->drift;
-}
-
-void
-register_time_interpolator(struct time_interpolator *ti)
-{
-	unsigned long flags;
-
-	/* Sanity check */
-	BUG_ON(ti->frequency == 0 || ti->mask == 0);
-
-	ti->nsec_per_cyc = ((u64)NSEC_PER_SEC << ti->shift) / ti->frequency;
-	spin_lock(&time_interpolator_lock);
-	write_seqlock_irqsave(&xtime_lock, flags);
-	if (is_better_time_interpolator(ti)) {
-		time_interpolator = ti;
-		time_interpolator_reset();
-	}
-	write_sequnlock_irqrestore(&xtime_lock, flags);
-
-	ti->next = time_interpolator_list;
-	time_interpolator_list = ti;
-	spin_unlock(&time_interpolator_lock);
-}
-
-void
-unregister_time_interpolator(struct time_interpolator *ti)
-{
-	struct time_interpolator *curr, **prev;
-	unsigned long flags;
-
-	spin_lock(&time_interpolator_lock);
-	prev = &time_interpolator_list;
-	for (curr = *prev; curr; curr = curr->next) {
-		if (curr == ti) {
-			*prev = curr->next;
-			break;
-		}
-		prev = &curr->next;
-	}
-
-	write_seqlock_irqsave(&xtime_lock, flags);
-	if (ti == time_interpolator) {
-		/* we lost the best time-interpolator: */
-		time_interpolator = NULL;
-		/* find the next-best interpolator */
-		for (curr = time_interpolator_list; curr; curr = curr->next)
-			if (is_better_time_interpolator(curr))
-				time_interpolator = curr;
-		time_interpolator_reset();
-	}
-	write_sequnlock_irqrestore(&xtime_lock, flags);
-	spin_unlock(&time_interpolator_lock);
-}
-#endif /* CONFIG_TIME_INTERPOLATION */
-
 /**
  * msleep - sleep safely even with waitqueue interruptions
  * @msecs: Time in milliseconds to sleep for

-- 
