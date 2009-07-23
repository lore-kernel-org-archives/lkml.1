Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZGWKxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZGWKxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 06:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZGWKxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 06:53:50 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:61457 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbZGWKxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 06:53:48 -0400
Date: Thu, 23 Jul 2009 12:52:45 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][patch 1/5] move clock source related code to
 clocksource.c
Message-ID: <20090723125245.34e84cac@skybase>
In-Reply-To: <1248308900.7592.36.camel@localhost.localdomain>
References: <20090721191745.788551122@de.ibm.com>
	<20090721192057.177653956@de.ibm.com>
	<1248205851.14209.777.camel@desktop>
	<1248213607.3298.107.camel@localhost>
	<20090722092519.772b238b@skybase>
	<1248284733.18789.32.camel@work-vm>
	<1248308900.7592.36.camel@localhost.localdomain>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Wed, 22 Jul 2009 17:28:20 -0700
john stultz <johnstul@us.ibm.com> wrote:

> On Wed, 2009-07-22 at 10:45 -0700, john stultz wrote:
> Hey Martin,
> 	So here's a really quick swipe at breaking apart the clocksource struct
> into a clocksource only portion and a timekeeping portion.
> 
> Caveats:
> 1) This doesn't completely build. The core bits do, but there's still a
> few left-over issues (see following caveats). Its just here to give you
> an idea of what I'm thinking about. I'd of course break it up into more
> manageable chunks before submitting it.

Mine does build but for s390 only - and even there only with a hack ;-)
 
> 2) Structure names aren't too great right now. Not sure timeclock is
> what I want to use, probably system_time or something. Will find/replace
> before the next revision is sent out.

I've picked the name struct timekeeper.

> 3) I still need to unify the clocksource and cyclecounter structures, as
> they're basically redundant now.

I'll leave that up to you.

> 4) I still need to fix the update_vsyscall code (shouldn't be hard, I
> didn't want to run through arch code yet).

Done in my version of the patch below.

> 5) The TSC clocksource uses cycles_last to avoid very slight skew issues
> (that otherwise would not be noticed). Not sure how to fix that if we're
> pulling cycles_last (which is purely timekeeping state) out of the
> clocksource. Will have to think of something.

That is an ugly one. A similar thing exists in the s390 backend where I
want to reset the timekeeping to precise values after the clocksource
switch from jiffies. The proper solution probably is to allow
architectures to override the default clocksource. The jiffies
clocksource doesn't make any sense on s390.

> Other cleanups still out there in the distant future:
> 1) Once all arches are converted to GENERIC_TIME, we can remove the
> ifdefs, and cleanup a lot of the more complicated xtime struct
> manipulation. It will cleanup update_wall_time() nicely.

Well yes, but that will take a few more arch patches. Until we get
there we have to live with the current state of things.

> 2) I have a logarithmic accumulation patch to update_wall_time that will
> remove the need for xtime_cache to be managed and updated. Just have to
> spend some additional time making sure its bugfree.

Interesting. Getting rid of xtime_cache would be a nice cleanup as well.

> 3) Once all arches are converted to using read_persistent_clock(), then
> the arch specific time initialization can be dropped. Removing the
> majority of direct xtime structure accesses.

Only if the read_persistent_clock allows for a better resolution than
seconds. With my cputime accounting hat on: seconds are not good
enough..

> 4) Then once the remaining direct wall_to_monotonic and xtime accessors
> are moved to timekeeping.c we can make those both static and embed them
> into the core timekeeping structure.

Both should not be accessed at a rate that makes it necessary to read
from the values directly. An accessor should be fine I think.

> But let me know if this patch doesn't achieve most of the cleanup you
> wanted to see.

We are getting there. I wonder if it is really necessary to pull
xtime_cache, raw_time, total_sleep_time and timekeeping_suspended into
the struct timeclock. I would prefer the semantics that the struct
timekeeper / timeclock contains the internal values of the timekeeping
code for the currently selected clock source. xtime is not clock
specific.

For reference here is the current stack of patches I have on my disk.
The stop_machine conversion to install a new clocksource is currently missing.

PRELIMINARY PATCHES, USE AT YOUR OWN RISK.
-------------------------------------------------------------------

Subject: [PATCH] introduce timekeeping_leap_insert

From: john stultz <johnstul@us.ibm.com>

---
 include/linux/time.h      |    1 +
 kernel/time/ntp.c         |    7 ++-----
 kernel/time/timekeeping.c |    7 +++++++
 3 files changed, 10 insertions(+), 5 deletions(-)

Index: linux-2.6/include/linux/time.h
===================================================================
--- linux-2.6.orig/include/linux/time.h
+++ linux-2.6/include/linux/time.h
@@ -147,6 +147,7 @@ extern struct timespec timespec_trunc(st
 extern int timekeeping_valid_for_hres(void);
 extern void update_wall_time(void);
 extern void update_xtime_cache(u64 nsec);
+extern void timekeeping_leap_insert(int leapsecond);
 
 struct tms;
 extern void do_sys_times(struct tms *);
Index: linux-2.6/kernel/time/ntp.c
===================================================================
--- linux-2.6.orig/kernel/time/ntp.c
+++ linux-2.6/kernel/time/ntp.c
@@ -194,8 +194,7 @@ static enum hrtimer_restart ntp_leap_sec
 	case TIME_OK:
 		break;
 	case TIME_INS:
-		xtime.tv_sec--;
-		wall_to_monotonic.tv_sec++;
+		timekeeping_leap_insert(-1);
 		time_state = TIME_OOP;
 		printk(KERN_NOTICE
 			"Clock: inserting leap second 23:59:60 UTC\n");
@@ -203,9 +202,8 @@ static enum hrtimer_restart ntp_leap_sec
 		res = HRTIMER_RESTART;
 		break;
 	case TIME_DEL:
-		xtime.tv_sec++;
+		timekeeping_leap_insert(1);
 		time_tai--;
-		wall_to_monotonic.tv_sec--;
 		time_state = TIME_WAIT;
 		printk(KERN_NOTICE
 			"Clock: deleting leap second 23:59:59 UTC\n");
@@ -219,7 +217,6 @@ static enum hrtimer_restart ntp_leap_sec
 			time_state = TIME_OK;
 		break;
 	}
-	update_vsyscall(&xtime, clock);
 
 	write_sequnlock(&xtime_lock);
 
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -58,6 +58,13 @@ void update_xtime_cache(u64 nsec)
 
 struct clocksource *clock;
 
+/* must hold xtime_lock */
+void timekeeping_leap_insert(int leapsecond)
+{
+	xtime.tv_sec += leapsecond;
+	wall_to_monotonic.tv_sec -= leapsecond;
+	update_vsyscall(&xtime, clock);
+}
 
 #ifdef CONFIG_GENERIC_TIME
 /**

-------------------------------------------------------------------

Subject: [PATCH] remove clocksource inline functions

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Remove clocksource_read, clocksource_enable and clocksource_disable
inline functions. No functional change.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 include/linux/clocksource.h |   46 --------------------------------------------
 kernel/time/timekeeping.c   |   32 +++++++++++++++++-------------
 2 files changed, 18 insertions(+), 60 deletions(-)

Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -79,7 +79,7 @@ static void clocksource_forward_now(void
 	cycle_t cycle_now, cycle_delta;
 	s64 nsec;
 
-	cycle_now = clocksource_read(clock);
+	cycle_now = clock->read(clock);
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 	clock->cycle_last = cycle_now;
 
@@ -114,7 +114,7 @@ void getnstimeofday(struct timespec *ts)
 		*ts = xtime;
 
 		/* read clocksource: */
-		cycle_now = clocksource_read(clock);
+		cycle_now = clock->read(clock);
 
 		/* calculate the delta since the last update_wall_time: */
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
@@ -146,7 +146,7 @@ ktime_t ktime_get(void)
 		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
 
 		/* read clocksource: */
-		cycle_now = clocksource_read(clock);
+		cycle_now = clock->read(clock);
 
 		/* calculate the delta since the last update_wall_time: */
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
@@ -186,7 +186,7 @@ void ktime_get_ts(struct timespec *ts)
 		tomono = wall_to_monotonic;
 
 		/* read clocksource: */
-		cycle_now = clocksource_read(clock);
+		cycle_now = clock->read(clock);
 
 		/* calculate the delta since the last update_wall_time: */
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
@@ -274,16 +274,18 @@ static void change_clocksource(void)
 
 	clocksource_forward_now();
 
-	if (clocksource_enable(new))
+	if (new->enable && ! new->enable(new))
 		return;
+	/* save mult_orig on enable */
+	new->mult_orig = new->mult;
 
 	new->raw_time = clock->raw_time;
 	old = clock;
 	clock = new;
-	clocksource_disable(old);
+	if (old->disable)
+		old->disable(old);
 
-	clock->cycle_last = 0;
-	clock->cycle_last = clocksource_read(clock);
+	clock->cycle_last = clock->read(clock);
 	clock->error = 0;
 	clock->xtime_nsec = 0;
 	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
@@ -373,7 +375,7 @@ void getrawmonotonic(struct timespec *ts
 		seq = read_seqbegin(&xtime_lock);
 
 		/* read clocksource: */
-		cycle_now = clocksource_read(clock);
+		cycle_now = clock->read(clock);
 
 		/* calculate the delta since the last update_wall_time: */
 		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
@@ -435,9 +437,12 @@ void __init timekeeping_init(void)
 	ntp_init();
 
 	clock = clocksource_get_next();
-	clocksource_enable(clock);
+	if (clock->enable)
+		clock->enable(clock);
+	/* save mult_orig on enable */
+	clock->mult_orig = clock->mult;
 	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
-	clock->cycle_last = clocksource_read(clock);
+	clock->cycle_last = clock->read(clock);
 
 	xtime.tv_sec = sec;
 	xtime.tv_nsec = 0;
@@ -477,8 +482,7 @@ static int timekeeping_resume(struct sys
 	}
 	update_xtime_cache(0);
 	/* re-base the last cycle value */
-	clock->cycle_last = 0;
-	clock->cycle_last = clocksource_read(clock);
+	clock->cycle_last = clock->read(clock);
 	clock->error = 0;
 	timekeeping_suspended = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
@@ -630,7 +634,7 @@ void update_wall_time(void)
 		return;
 
 #ifdef CONFIG_GENERIC_TIME
-	offset = (clocksource_read(clock) - clock->cycle_last) & clock->mask;
+	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #else
 	offset = clock->cycle_interval;
 #endif
Index: linux-2.6/include/linux/clocksource.h
===================================================================
--- linux-2.6.orig/include/linux/clocksource.h
+++ linux-2.6/include/linux/clocksource.h
@@ -268,52 +268,6 @@ static inline u32 clocksource_hz2mult(u3
 }
 
 /**
- * clocksource_read: - Access the clocksource's current cycle value
- * @cs:		pointer to clocksource being read
- *
- * Uses the clocksource to return the current cycle_t value
- */
-static inline cycle_t clocksource_read(struct clocksource *cs)
-{
-	return cs->read(cs);
-}
-
-/**
- * clocksource_enable: - enable clocksource
- * @cs:		pointer to clocksource
- *
- * Enables the specified clocksource. The clocksource callback
- * function should start up the hardware and setup mult and field
- * members of struct clocksource to reflect hardware capabilities.
- */
-static inline int clocksource_enable(struct clocksource *cs)
-{
-	int ret = 0;
-
-	if (cs->enable)
-		ret = cs->enable(cs);
-
-	/* save mult_orig on enable */
-	cs->mult_orig = cs->mult;
-
-	return ret;
-}
-
-/**
- * clocksource_disable: - disable clocksource
- * @cs:		pointer to clocksource
- *
- * Disables the specified clocksource. The clocksource callback
- * function should power down the now unused hardware block to
- * save power.
- */
-static inline void clocksource_disable(struct clocksource *cs)
-{
-	if (cs->disable)
-		cs->disable(cs);
-}
-
-/**
  * cyc2ns - converts clocksource cycles to nanoseconds
  * @cs:		Pointer to clocksource
  * @cycles:	Cycles

-------------------------------------------------------------------

Subject: [PATCH] cleanup clocksource selection

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Introduce clocksource_dequeue & clocksource_update and move spinlock
calls. clocksource_update does nothing for GENERIC_TIME=n since
change_clocksource does nothing as well.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 kernel/time/clocksource.c |   91 +++++++++++++++++++++++++++-------------------
 1 file changed, 55 insertions(+), 36 deletions(-)

Index: linux-2.6/kernel/time/clocksource.c
===================================================================
--- linux-2.6.orig/kernel/time/clocksource.c
+++ linux-2.6/kernel/time/clocksource.c
@@ -348,21 +348,13 @@ struct clocksource *clocksource_get_next
  */
 static struct clocksource *select_clocksource(void)
 {
-	struct clocksource *next;
-
 	if (list_empty(&clocksource_list))
 		return NULL;
 
 	if (clocksource_override)
-		next = clocksource_override;
-	else
-		next = list_entry(clocksource_list.next, struct clocksource,
-				  list);
-
-	if (next == curr_clocksource)
-		return NULL;
+		return clocksource_override;
 
-	return next;
+	return list_entry(clocksource_list.next, struct clocksource, list);
 }
 
 /*
@@ -371,13 +363,19 @@ static struct clocksource *select_clocks
 static int clocksource_enqueue(struct clocksource *c)
 {
 	struct list_head *tmp, *entry = &clocksource_list;
+	unsigned long flags;
+	int rc;
 
+	spin_lock_irqsave(&clocksource_lock, flags);
+	rc = 0;
 	list_for_each(tmp, &clocksource_list) {
 		struct clocksource *cs;
 
 		cs = list_entry(tmp, struct clocksource, list);
-		if (cs == c)
-			return -EBUSY;
+		if (cs == c) {
+			rc = -EBUSY;
+			goto out;
+		}
 		/* Keep track of the place, where to insert */
 		if (cs->rating >= c->rating)
 			entry = tmp;
@@ -387,10 +385,44 @@ static int clocksource_enqueue(struct cl
 	if (strlen(c->name) == strlen(override_name) &&
 	    !strcmp(c->name, override_name))
 		clocksource_override = c;
+out:
+	spin_unlock_irqrestore(&clocksource_lock, flags);
+	return rc;
+}
 
-	return 0;
+/*
+ * Dequeue a clocksource
+ */
+static void clocksource_dequeue(struct clocksource *cs)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&clocksource_lock, flags);
+	list_del(&cs->list);
+	if (clocksource_override == cs)
+		clocksource_override = NULL;
+	spin_unlock_irqrestore(&clocksource_lock, flags);
 }
 
+#ifdef CONFIG_GENERIC_TIME
+/**
+ * clocksource_update - Check if a better clocksource is available
+ */
+static void clocksource_update(void)
+{
+	struct clocksource *new;
+	unsigned long flags;
+
+	spin_lock_irqsave(&clocksource_lock, flags);
+	new = select_clocksource();
+	if (new)
+		next_clocksource = new;
+	spin_unlock_irqrestore(&clocksource_lock, flags);
+}
+#else /* CONFIG_GENERIC_TIME */
+static inline void clocksource_update(void) { }
+#endif /* CONFIG_GENERIC_TIME */
+
 /**
  * clocksource_register - Used to install new clocksources
  * @t:		clocksource to be registered
@@ -399,16 +431,13 @@ static int clocksource_enqueue(struct cl
  */
 int clocksource_register(struct clocksource *c)
 {
-	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(&clocksource_lock, flags);
 	ret = clocksource_enqueue(c);
-	if (!ret)
-		next_clocksource = select_clocksource();
-	spin_unlock_irqrestore(&clocksource_lock, flags);
-	if (!ret)
+	if (!ret) {
+		clocksource_update();
 		clocksource_check_watchdog(c);
+	}
 	return ret;
 }
 EXPORT_SYMBOL(clocksource_register);
@@ -419,14 +448,10 @@ EXPORT_SYMBOL(clocksource_register);
  */
 void clocksource_change_rating(struct clocksource *cs, int rating)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&clocksource_lock, flags);
-	list_del(&cs->list);
+	clocksource_dequeue(cs);
 	cs->rating = rating;
 	clocksource_enqueue(cs);
-	next_clocksource = select_clocksource();
-	spin_unlock_irqrestore(&clocksource_lock, flags);
+	clocksource_update();
 }
 
 /**
@@ -434,14 +459,8 @@ void clocksource_change_rating(struct cl
  */
 void clocksource_unregister(struct clocksource *cs)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&clocksource_lock, flags);
-	list_del(&cs->list);
-	if (clocksource_override == cs)
-		clocksource_override = NULL;
-	next_clocksource = select_clocksource();
-	spin_unlock_irqrestore(&clocksource_lock, flags);
+	clocksource_dequeue(cs);
+	clocksource_update();
 }
 
 #ifdef CONFIG_SYSFS
@@ -522,13 +541,13 @@ static ssize_t sysfs_override_clocksourc
 	}
 
 	/* Reselect, when the override name has changed */
-	if (ovr != clocksource_override) {
+	if (ovr != clocksource_override)
 		clocksource_override = ovr;
-		next_clocksource = select_clocksource();
-	}
 
 	spin_unlock_irq(&clocksource_lock);
 
+	clocksource_update();
+
 	return ret;
 }

-------------------------------------------------------------------
 
Subject: [PATCH] introduce struct timekeeper

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Add struct timekeeper to keep all the internal values timekeeping.c
needs in regard to the currently selected clock source. This moves
all timekeeping related values out of the struct clocksource.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/ia64/kernel/time.c       |    5 
 arch/powerpc/kernel/time.c    |    5 
 arch/s390/kernel/time.c       |    9 -
 arch/x86/kernel/vsyscall_64.c |    5 
 include/linux/clocksource.h   |   51 ---------
 kernel/time/timekeeping.c     |  224 +++++++++++++++++++++++++++---------------
 6 files changed, 161 insertions(+), 138 deletions(-)

Index: linux-2.6/include/linux/clocksource.h
===================================================================
--- linux-2.6.orig/include/linux/clocksource.h
+++ linux-2.6/include/linux/clocksource.h
@@ -181,20 +181,6 @@ struct clocksource {
 #define CLKSRC_FSYS_MMIO_SET(mmio, addr)      do { } while (0)
 #endif
 
-	/* timekeeping specific data, ignore */
-	cycle_t cycle_interval;
-	u64	xtime_interval;
-	u32	raw_interval;
-	/*
-	 * Second part is written at each timer interrupt
-	 * Keep it in a different cache line to dirty no
-	 * more than one cache line.
-	 */
-	cycle_t cycle_last ____cacheline_aligned_in_smp;
-	u64 xtime_nsec;
-	s64 error;
-	struct timespec raw_time;
-
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 	/* Watchdog related data, used by the framework */
 	struct list_head wd_list;
@@ -202,8 +188,6 @@ struct clocksource {
 #endif
 };
 
-extern struct clocksource *clock;	/* current clocksource */
-
 /*
  * Clock source flags bits::
  */
@@ -283,37 +267,6 @@ static inline s64 cyc2ns(struct clocksou
 	return ret;
 }
 
-/**
- * clocksource_calculate_interval - Calculates a clocksource interval struct
- *
- * @c:		Pointer to clocksource.
- * @length_nsec: Desired interval length in nanoseconds.
- *
- * Calculates a fixed cycle/nsec interval for a given clocksource/adjustment
- * pair and interval request.
- *
- * Unless you're the timekeeping code, you should not be using this!
- */
-static inline void clocksource_calculate_interval(struct clocksource *c,
-					  	  unsigned long length_nsec)
-{
-	u64 tmp;
-
-	/* Do the ns -> cycle conversion first, using original mult */
-	tmp = length_nsec;
-	tmp <<= c->shift;
-	tmp += c->mult_orig/2;
-	do_div(tmp, c->mult_orig);
-
-	c->cycle_interval = (cycle_t)tmp;
-	if (c->cycle_interval == 0)
-		c->cycle_interval = 1;
-
-	/* Go back from cycles -> shifted ns, this time use ntp adjused mult */
-	c->xtime_interval = (u64)c->cycle_interval * c->mult;
-	c->raw_interval = ((u64)c->cycle_interval * c->mult_orig) >> c->shift;
-}
-
 
 /* used to install a new clocksource */
 extern int clocksource_register(struct clocksource*);
@@ -324,10 +277,10 @@ extern void clocksource_change_rating(st
 extern void clocksource_resume(void);
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
-extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
+extern void update_vsyscall(struct timespec *ts, struct clocksource *c, cycle_t cycle_last);
 extern void update_vsyscall_tz(void);
 #else
-static inline void update_vsyscall(struct timespec *ts, struct clocksource *c)
+static inline void update_vsyscall(struct timespec *ts, struct clocksource *c, cycle_t cycle_last)
 {
 }
 
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -19,6 +19,67 @@
 #include <linux/time.h>
 #include <linux/tick.h>
 
+/* Structure holding internal timekeeping values. */
+struct timekeeper {
+	struct clocksource *clock;
+	cycle_t cycle_interval;
+	u64	xtime_interval;
+	u32	raw_interval;
+	u64	xtime_nsec;
+	s64	ntp_error;
+	int	xtime_shift;
+	int	ntp_shift;
+
+	/*
+	 * The following is written at each timer interrupt
+	 * Keep it in a different cache line to dirty no
+	 * more than one cache line.
+	 */
+	cycle_t cycle_last ____cacheline_aligned_in_smp;
+};
+
+struct timekeeper timekeeper;
+
+/**
+ * timekeeper_setup_internals - Set up internals to use clocksource clock.
+ *
+ * @clock:		Pointer to clocksource.
+ *
+ * Calculates a fixed cycle/nsec interval for a given clocksource/adjustment
+ * pair and interval request.
+ *
+ * Unless you're the timekeeping code, you should not be using this!
+ */
+static void timekeeper_setup_internals(struct clocksource *clock)
+{
+	cycle_t interval;
+	u64 tmp;
+
+	timekeeper.clock = clock;
+	timekeeper.cycle_last = clock->read(clock);
+
+	/* Do the ns -> cycle conversion first, using original mult */
+	tmp = NTP_INTERVAL_LENGTH;
+	tmp <<= clock->shift;
+	tmp += clock->mult_orig/2;
+	do_div(tmp, clock->mult_orig);
+	if (tmp == 0)
+		tmp = 1;
+
+	interval = (cycle_t) tmp;
+	timekeeper.cycle_interval = interval;
+
+	/* Go back from cycles -> shifted ns, this time use ntp adjused mult */
+	timekeeper.xtime_interval = (u64) interval * clock->mult;
+	timekeeper.raw_interval =
+		((u64) interval * clock->mult_orig) >> clock->shift;
+
+	timekeeper.xtime_shift = clock->shift;
+	timekeeper.ntp_shift = NTP_SCALE_SHIFT - clock->shift;
+
+	timekeeper.xtime_nsec = 0;
+	timekeeper.ntp_error = 0;
+}
 
 /*
  * This read-write spinlock protects us from races in SMP while
@@ -46,6 +107,11 @@ struct timespec xtime __attribute__ ((al
 struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
 static unsigned long total_sleep_time;		/* seconds */
 
+/*
+ * The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock.
+ */
+struct timespec raw_time;
+
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
@@ -56,32 +122,32 @@ void update_xtime_cache(u64 nsec)
 	timespec_add_ns(&xtime_cache, nsec);
 }
 
-struct clocksource *clock;
-
 /* must hold xtime_lock */
 void timekeeping_leap_insert(int leapsecond)
 {
 	xtime.tv_sec += leapsecond;
 	wall_to_monotonic.tv_sec -= leapsecond;
-	update_vsyscall(&xtime, clock);
+	update_vsyscall(&xtime, timekeeper.clock, timekeeper.cycle_last);
 }
 
 #ifdef CONFIG_GENERIC_TIME
 /**
- * clocksource_forward_now - update clock to the current time
+ * timekeeping_forward_now - update clock to the current time
  *
  * Forward the current clock to update its state since the last call to
  * update_wall_time(). This is useful before significant clock changes,
  * as it avoids having to deal with this time offset explicitly.
  */
-static void clocksource_forward_now(void)
+static void timekeeping_forward_now(void)
 {
 	cycle_t cycle_now, cycle_delta;
+	struct clocksource *clock;
 	s64 nsec;
 
+	clock = timekeeper.clock;
 	cycle_now = clock->read(clock);
-	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-	clock->cycle_last = cycle_now;
+	cycle_delta = (cycle_now - timekeeper.cycle_last) & clock->mask;
+	timekeeper.cycle_last = cycle_now;
 
 	nsec = cyc2ns(clock, cycle_delta);
 
@@ -91,7 +157,7 @@ static void clocksource_forward_now(void
 	timespec_add_ns(&xtime, nsec);
 
 	nsec = ((s64)cycle_delta * clock->mult_orig) >> clock->shift;
-	clock->raw_time.tv_nsec += nsec;
+	timespec_add_ns(&raw_time, nsec);
 }
 
 /**
@@ -103,6 +169,7 @@ static void clocksource_forward_now(void
 void getnstimeofday(struct timespec *ts)
 {
 	cycle_t cycle_now, cycle_delta;
+	struct clocksource *clock;
 	unsigned long seq;
 	s64 nsecs;
 
@@ -114,10 +181,11 @@ void getnstimeofday(struct timespec *ts)
 		*ts = xtime;
 
 		/* read clocksource: */
+		clock = timekeeper.clock;
 		cycle_now = clock->read(clock);
 
 		/* calculate the delta since the last update_wall_time: */
-		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+		cycle_delta = (cycle_now - timekeeper.cycle_last) & clock->mask;
 
 		/* convert to nanoseconds: */
 		nsecs = cyc2ns(clock, cycle_delta);
@@ -135,6 +203,7 @@ EXPORT_SYMBOL(getnstimeofday);
 ktime_t ktime_get(void)
 {
 	cycle_t cycle_now, cycle_delta;
+	struct clocksource *clock;
 	unsigned int seq;
 	s64 secs, nsecs;
 
@@ -146,10 +215,11 @@ ktime_t ktime_get(void)
 		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
 
 		/* read clocksource: */
+		clock = timekeeper.clock;
 		cycle_now = clock->read(clock);
 
 		/* calculate the delta since the last update_wall_time: */
-		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+		cycle_delta = (cycle_now - timekeeper.cycle_last) & clock->mask;
 
 		/* convert to nanoseconds: */
 		nsecs += cyc2ns(clock, cycle_delta);
@@ -174,6 +244,7 @@ EXPORT_SYMBOL_GPL(ktime_get);
 void ktime_get_ts(struct timespec *ts)
 {
 	cycle_t cycle_now, cycle_delta;
+	struct clocksource *clock;
 	struct timespec tomono;
 	unsigned int seq;
 	s64 nsecs;
@@ -186,10 +257,11 @@ void ktime_get_ts(struct timespec *ts)
 		tomono = wall_to_monotonic;
 
 		/* read clocksource: */
+		clock = timekeeper.clock;
 		cycle_now = clock->read(clock);
 
 		/* calculate the delta since the last update_wall_time: */
-		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+		cycle_delta = (cycle_now - timekeeper.cycle_last) & clock->mask;
 
 		/* convert to nanoseconds: */
 		nsecs = cyc2ns(clock, cycle_delta);
@@ -233,7 +305,7 @@ int do_settimeofday(struct timespec *tv)
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 
-	clocksource_forward_now();
+	timekeeping_forward_now();
 
 	ts_delta.tv_sec = tv->tv_sec - xtime.tv_sec;
 	ts_delta.tv_nsec = tv->tv_nsec - xtime.tv_nsec;
@@ -243,10 +315,10 @@ int do_settimeofday(struct timespec *tv)
 
 	update_xtime_cache(0);
 
-	clock->error = 0;
+	timekeeper.ntp_error = 0;
 	ntp_clear();
 
-	update_vsyscall(&xtime, clock);
+	update_vsyscall(&xtime, timekeeper.clock, timekeeper.cycle_last);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -269,38 +341,25 @@ static void change_clocksource(void)
 
 	new = clocksource_get_next();
 
-	if (clock == new)
+	if (timekeeper.clock == new)
 		return;
 
-	clocksource_forward_now();
+	timekeeping_forward_now();
 
 	if (new->enable && ! new->enable(new))
 		return;
 	/* save mult_orig on enable */
 	new->mult_orig = new->mult;
 
-	new->raw_time = clock->raw_time;
-	old = clock;
-	clock = new;
+	old = timekeeper.clock;
+	timekeeper_setup_internals(new);
 	if (old->disable)
 		old->disable(old);
 
-	clock->cycle_last = clock->read(clock);
-	clock->error = 0;
-	clock->xtime_nsec = 0;
-	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
-
 	tick_clock_notify();
-
-	/*
-	 * We're holding xtime lock and waking up klogd would deadlock
-	 * us on enqueue.  So no printing!
-	printk(KERN_INFO "Time: %s clocksource has been installed.\n",
-	       clock->name);
-	 */
 }
 #else /* GENERIC_TIME */
-static inline void clocksource_forward_now(void) { }
+static inline void timekeeping_forward_now(void) { }
 static inline void change_clocksource(void) { }
 
 /**
@@ -370,20 +429,22 @@ void getrawmonotonic(struct timespec *ts
 	unsigned long seq;
 	s64 nsecs;
 	cycle_t cycle_now, cycle_delta;
+	struct clocksource *clock;
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
 		/* read clocksource: */
+		clock = timekeeper.clock;
 		cycle_now = clock->read(clock);
 
 		/* calculate the delta since the last update_wall_time: */
-		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+		cycle_delta = (cycle_now - timekeeper.cycle_last) & clock->mask;
 
 		/* convert to nanoseconds: */
 		nsecs = ((s64)cycle_delta * clock->mult_orig) >> clock->shift;
 
-		*ts = clock->raw_time;
+		*ts = raw_time;
 
 	} while (read_seqretry(&xtime_lock, seq));
 
@@ -403,7 +464,7 @@ int timekeeping_valid_for_hres(void)
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
-		ret = clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
+		ret = timekeeper.clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
 
 	} while (read_seqretry(&xtime_lock, seq));
 
@@ -429,6 +490,7 @@ unsigned long __attribute__((weak)) read
  */
 void __init timekeeping_init(void)
 {
+	struct clocksource *clock;
 	unsigned long flags;
 	unsigned long sec = read_persistent_clock();
 
@@ -441,11 +503,13 @@ void __init timekeeping_init(void)
 		clock->enable(clock);
 	/* save mult_orig on enable */
 	clock->mult_orig = clock->mult;
-	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
-	clock->cycle_last = clock->read(clock);
+
+	timekeeper_setup_internals(clock);
 
 	xtime.tv_sec = sec;
 	xtime.tv_nsec = 0;
+	raw_time.tv_sec = 0;
+	raw_time.tv_nsec = 0;
 	set_normalized_timespec(&wall_to_monotonic,
 		-xtime.tv_sec, -xtime.tv_nsec);
 	update_xtime_cache(0);
@@ -482,8 +546,8 @@ static int timekeeping_resume(struct sys
 	}
 	update_xtime_cache(0);
 	/* re-base the last cycle value */
-	clock->cycle_last = clock->read(clock);
-	clock->error = 0;
+	timekeeper.cycle_last = timekeeper.clock->read(timekeeper.clock);
+	timekeeper.ntp_error = 0;
 	timekeeping_suspended = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -504,7 +568,7 @@ static int timekeeping_suspend(struct sy
 	timekeeping_suspend_time = read_persistent_clock();
 
 	write_seqlock_irqsave(&xtime_lock, flags);
-	clocksource_forward_now();
+	timekeeping_forward_now();
 	timekeeping_suspended = 1;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -539,7 +603,7 @@ device_initcall(timekeeping_init_device)
  * If the error is already larger, we look ahead even further
  * to compensate for late or lost adjustments.
  */
-static __always_inline int clocksource_bigadjust(s64 error, s64 *interval,
+static __always_inline int timekeeping_bigadjust(s64 error, s64 *interval,
 						 s64 *offset)
 {
 	s64 tick_error, i;
@@ -555,7 +619,7 @@ static __always_inline int clocksource_b
 	 * here.  This is tuned so that an error of about 1 msec is adjusted
 	 * within about 1 sec (or 2^20 nsec in 2^SHIFT_HZ ticks).
 	 */
-	error2 = clock->error >> (NTP_SCALE_SHIFT + 22 - 2 * SHIFT_HZ);
+	error2 = timekeeper.ntp_error >> (NTP_SCALE_SHIFT + 22 - 2 * SHIFT_HZ);
 	error2 = abs(error2);
 	for (look_ahead = 0; error2 > 0; look_ahead++)
 		error2 >>= 2;
@@ -564,8 +628,8 @@ static __always_inline int clocksource_b
 	 * Now calculate the error in (1 << look_ahead) ticks, but first
 	 * remove the single look ahead already included in the error.
 	 */
-	tick_error = tick_length >> (NTP_SCALE_SHIFT - clock->shift + 1);
-	tick_error -= clock->xtime_interval >> 1;
+	tick_error = tick_length >> (timekeeper.ntp_shift + 1);
+	tick_error -= timekeeper.xtime_interval >> 1;
 	error = ((error - tick_error) >> look_ahead) + tick_error;
 
 	/* Finally calculate the adjustment shift value.  */
@@ -590,18 +654,18 @@ static __always_inline int clocksource_b
  * this is optimized for the most common adjustments of -1,0,1,
  * for other values we can do a bit more work.
  */
-static void clocksource_adjust(s64 offset)
+static void timekeeping_adjust(s64 offset)
 {
-	s64 error, interval = clock->cycle_interval;
+	s64 error, interval = timekeeper.cycle_interval;
 	int adj;
 
-	error = clock->error >> (NTP_SCALE_SHIFT - clock->shift - 1);
+	error = timekeeper.ntp_error >> (timekeeper.ntp_shift - 1);
 	if (error > interval) {
 		error >>= 2;
 		if (likely(error <= interval))
 			adj = 1;
 		else
-			adj = clocksource_bigadjust(error, &interval, &offset);
+			adj = timekeeping_bigadjust(error, &interval, &offset);
 	} else if (error < -interval) {
 		error >>= 2;
 		if (likely(error >= -interval)) {
@@ -609,15 +673,14 @@ static void clocksource_adjust(s64 offse
 			interval = -interval;
 			offset = -offset;
 		} else
-			adj = clocksource_bigadjust(error, &interval, &offset);
+			adj = timekeeping_bigadjust(error, &interval, &offset);
 	} else
 		return;
 
-	clock->mult += adj;
-	clock->xtime_interval += interval;
-	clock->xtime_nsec -= offset;
-	clock->error -= (interval - offset) <<
-			(NTP_SCALE_SHIFT - clock->shift);
+	timekeeper.clock->mult += adj;
+	timekeeper.xtime_interval += interval;
+	timekeeper.xtime_nsec -= offset;
+	timekeeper.ntp_error -= (interval - offset) << timekeeper.ntp_shift;
 }
 
 /**
@@ -627,53 +690,56 @@ static void clocksource_adjust(s64 offse
  */
 void update_wall_time(void)
 {
+	struct clocksource *clock;
 	cycle_t offset;
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
 		return;
 
+	clock = timekeeper.clock;
 #ifdef CONFIG_GENERIC_TIME
-	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
+	offset = (clock->read(clock) - timekeeper.cycle_last) & clock->mask;
 #else
-	offset = clock->cycle_interval;
+	offset = timekeeper.cycle_interval;
 #endif
-	clock->xtime_nsec = (s64)xtime.tv_nsec << clock->shift;
+	timekeeper.xtime_nsec = (s64)xtime.tv_nsec << timekeeper.xtime_shift;
 
 	/* normally this loop will run just once, however in the
 	 * case of lost or late ticks, it will accumulate correctly.
 	 */
-	while (offset >= clock->cycle_interval) {
+	while (offset >= timekeeper.cycle_interval) {
 		/* accumulate one interval */
-		offset -= clock->cycle_interval;
-		clock->cycle_last += clock->cycle_interval;
+		offset -= timekeeper.cycle_interval;
+		timekeeper.cycle_last += timekeeper.cycle_interval;
 
-		clock->xtime_nsec += clock->xtime_interval;
-		if (clock->xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
-			clock->xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
+		timekeeper.xtime_nsec += timekeeper.xtime_interval;
+		if (timekeeper.xtime_nsec >= (u64)NSEC_PER_SEC << timekeeper.xtime_shift) {
+			timekeeper.xtime_nsec -= (u64)NSEC_PER_SEC << timekeeper.xtime_shift;
 			xtime.tv_sec++;
 			second_overflow();
 		}
 
-		clock->raw_time.tv_nsec += clock->raw_interval;
-		if (clock->raw_time.tv_nsec >= NSEC_PER_SEC) {
-			clock->raw_time.tv_nsec -= NSEC_PER_SEC;
-			clock->raw_time.tv_sec++;
+		raw_time.tv_nsec += timekeeper.raw_interval;
+		if (raw_time.tv_nsec >= NSEC_PER_SEC) {
+			raw_time.tv_nsec -= NSEC_PER_SEC;
+			raw_time.tv_sec++;
 		}
 
 		/* accumulate error between NTP and clock interval */
-		clock->error += tick_length;
-		clock->error -= clock->xtime_interval << (NTP_SCALE_SHIFT - clock->shift);
+		timekeeper.ntp_error += tick_length;
+		timekeeper.ntp_error -= timekeeper.xtime_interval <<
+					timekeeper.ntp_shift;
 	}
 
 	/* correct the clock when NTP error is too big */
-	clocksource_adjust(offset);
+	timekeeping_adjust(offset);
 
 	/*
 	 * Since in the loop above, we accumulate any amount of time
 	 * in xtime_nsec over a second into xtime.tv_sec, its possible for
 	 * xtime_nsec to be fairly small after the loop. Further, if we're
-	 * slightly speeding the clocksource up in clocksource_adjust(),
+	 * slightly speeding the clocksource up in timekeeping_adjust(),
 	 * its possible the required corrective factor to xtime_nsec could
 	 * cause it to underflow.
 	 *
@@ -685,24 +751,24 @@ void update_wall_time(void)
 	 * We'll correct this error next time through this function, when
 	 * xtime_nsec is not as small.
 	 */
-	if (unlikely((s64)clock->xtime_nsec < 0)) {
-		s64 neg = -(s64)clock->xtime_nsec;
-		clock->xtime_nsec = 0;
-		clock->error += neg << (NTP_SCALE_SHIFT - clock->shift);
+	if (unlikely((s64)timekeeper.xtime_nsec < 0)) {
+		s64 neg = -(s64)timekeeper.xtime_nsec;
+		timekeeper.xtime_nsec = 0;
+		timekeeper.ntp_error += neg << timekeeper.ntp_shift;
 	}
 
 	/* store full nanoseconds into xtime after rounding it up and
 	 * add the remainder to the error difference.
 	 */
-	xtime.tv_nsec = ((s64)clock->xtime_nsec >> clock->shift) + 1;
-	clock->xtime_nsec -= (s64)xtime.tv_nsec << clock->shift;
-	clock->error += clock->xtime_nsec << (NTP_SCALE_SHIFT - clock->shift);
+	xtime.tv_nsec = ((s64)timekeeper.xtime_nsec >> timekeeper.xtime_shift) + 1;
+	timekeeper.xtime_nsec -= (s64)xtime.tv_nsec << timekeeper.xtime_shift;
+	timekeeper.ntp_error += timekeeper.xtime_nsec << timekeeper.ntp_shift;
 
 	update_xtime_cache(cyc2ns(clock, offset));
 
 	/* check to see if there is a new clocksource to use */
 	change_clocksource();
-	update_vsyscall(&xtime, clock);
+	update_vsyscall(&xtime, clock, timekeeper.cycle_last);
 }
 
 /**
Index: linux-2.6/arch/ia64/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/time.c
+++ linux-2.6/arch/ia64/kernel/time.c
@@ -473,7 +473,8 @@ void update_vsyscall_tz(void)
 {
 }
 
-void update_vsyscall(struct timespec *wall, struct clocksource *c)
+void update_vsyscall(struct timespec *wall, struct clocksource *c,#
+		     cycle_t cycle_last)
 {
         unsigned long flags;
 
@@ -484,7 +485,7 @@ void update_vsyscall(struct timespec *wa
         fsyscall_gtod_data.clk_mult = c->mult;
         fsyscall_gtod_data.clk_shift = c->shift;
         fsyscall_gtod_data.clk_fsys_mmio = c->fsys_mmio;
-        fsyscall_gtod_data.clk_cycle_last = c->cycle_last;
+        fsyscall_gtod_data.clk_cycle_last = cycle_last;
 
 	/* copy kernel time structures */
         fsyscall_gtod_data.wall_time.tv_sec = wall->tv_sec;
Index: linux-2.6/arch/powerpc/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/time.c
+++ linux-2.6/arch/powerpc/kernel/time.c
@@ -802,7 +802,8 @@ static cycle_t timebase_read(struct cloc
 	return (cycle_t)get_tb();
 }
 
-void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
+void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
+		     cycle_t cycle_last)
 {
 	u64 t2x, stamp_xsec;
 
@@ -819,7 +820,7 @@ void update_vsyscall(struct timespec *wa
 	stamp_xsec = (u64) xtime.tv_nsec * XSEC_PER_SEC;
 	do_div(stamp_xsec, 1000000000);
 	stamp_xsec += (u64) xtime.tv_sec * XSEC_PER_SEC;
-	update_gtod(clock->cycle_last, stamp_xsec, t2x);
+	update_gtod(cycle_last, stamp_xsec, t2x);
 }
 
 void update_vsyscall_tz(void)
Index: linux-2.6/arch/s390/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/time.c
+++ linux-2.6/arch/s390/kernel/time.c
@@ -206,7 +206,8 @@ static struct clocksource clocksource_to
 };
 
 
-void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
+void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
+		     cycle_t cycle_last)
 {
 	if (clock != &clocksource_tod)
 		return;
@@ -214,7 +215,7 @@ void update_vsyscall(struct timespec *wa
 	/* Make userspace gettimeofday spin until we're done. */
 	++vdso_data->tb_update_count;
 	smp_wmb();
-	vdso_data->xtime_tod_stamp = clock->cycle_last;
+	vdso_data->xtime_tod_stamp = cycle_last;
 	vdso_data->xtime_clock_sec = xtime.tv_sec;
 	vdso_data->xtime_clock_nsec = xtime.tv_nsec;
 	vdso_data->wtom_clock_sec = wall_to_monotonic.tv_sec;
@@ -275,8 +276,8 @@ void __init time_init(void)
 	write_seqlock_irqsave(&xtime_lock, flags);
 	now = get_clock();
 	tod_to_timeval(now - TOD_UNIX_EPOCH, &xtime);
-	clocksource_tod.cycle_last = now;
-	clocksource_tod.raw_time = xtime;
+//	clocksource_tod.cycle_last = now;
+//	clocksource_tod.raw_time = xtime;
 	tod_to_timeval(sched_clock_base_cc - TOD_UNIX_EPOCH, &ts);
 	set_normalized_timespec(&wall_to_monotonic, -ts.tv_sec, -ts.tv_nsec);
 	write_sequnlock_irqrestore(&xtime_lock, flags);
Index: linux-2.6/arch/x86/kernel/vsyscall_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vsyscall_64.c
+++ linux-2.6/arch/x86/kernel/vsyscall_64.c
@@ -73,14 +73,15 @@ void update_vsyscall_tz(void)
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
-void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
+void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
+		     cycle_t cycle_last)
 {
 	unsigned long flags;
 
 	write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
 	/* copy vsyscall data */
 	vsyscall_gtod_data.clock.vread = clock->vread;
-	vsyscall_gtod_data.clock.cycle_last = clock->cycle_last;
+	vsyscall_gtod_data.clock.cycle_last = cycle_last;
 	vsyscall_gtod_data.clock.mask = clock->mask;
 	vsyscall_gtod_data.clock.mult = clock->mult;
 	vsyscall_gtod_data.clock.shift = clock->shift;

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

