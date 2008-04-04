Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbYDDUR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbYDDUR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 16:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbYDDURt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 16:17:49 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:43715 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbYDDURs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 16:17:48 -0400
Subject: [PATCH] Close small window for vsyscall time inconsistencies
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 13:17:44 -0700
Message-Id: <1207340264.6222.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So Thomas and Ingo pointed out to me that they were occasionally seeing
small 1ns inconsistencies from clock_gettime() (and more rarely, 1us
inconsistencies from gettimeofday() when the 1ns inconsistency occurred
on a us boundary)

Looking over the code, the only possible reason I could find would be
from an interaction with the vsyscall code.

In update_wall_time(), if we read the hardware at time A and start
accumulating time, and adjusting the clocksource frequency, slowing it
for ntp. 

Right before we call update_vsyscall(), another processor makes a
vsyscall gettimeofday call, reading the hardware at time B, but using
the clocksource frequency and offsets from pre-time A. 

The update_vsyscall then runs, and updates the clocksource frequency
with a slower frequency.

Another processor immediately calls vsyscall gettimeofday, reading the
hardware (lets imagine its very slow hardware) at time B (or very
shortly there after), and then uses the post-time A clocksource
frequency which has been slowed. 

Since we're using basically the same hardware value B, but using
different frequencies, its possible for a very small 1ns time
inconsistency to occur.

The solution, is to block the vsyscall reads prior to the hardware read
at time A. Basically synchronizing the vsyscall gettimeofday calls with
the entire update_wall_time function() rather then just the
update_vsyscall call. 

Since each update_vsyscall is implemented in an arch specific way, we've
added a update_vsyscall_lock/unlock function pair that can be called
from arch generic code.

Paul, Tony: I'd appreciate a careful review for the non-x86_64 bits, as
I'm less familiar with the subtleties there.

Build tested for x86_64, powerpc, ia64, and alpha.

thanks
-john

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 17fda52..bc76c2e 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -349,11 +349,22 @@ void update_vsyscall_tz(void)
 {
 }
 
-void update_vsyscall(struct timespec *wall, struct clocksource *c)
+/* update_vsyscall_lock/unlock:
+ *    methods for timekeeping core to block vsyscalls during update
+ */
+void update_vsyscall_lock(unsigned long *flags)
 {
-        unsigned long flags;
+        write_seqlock_irqsave(&fsyscall_gtod_data.lock, *flags);
+}
 
-        write_seqlock_irqsave(&fsyscall_gtod_data.lock, flags);
+void update_vsyscall_unlock(unsigned long *flags)
+{
+        write_sequnlock_irqrestore(&fsyscall_gtod_data.lock, *flags);
+}
+
+/* Assumes fsyscall_gtod_data.lock has been taken via update_vsyscall_lock() */
+void update_vsyscall(struct timespec *wall, struct clocksource *c)
+{
 
         /* copy fsyscall clock data */
         fsyscall_gtod_data.clk_mask = c->mask;
@@ -375,7 +386,5 @@ void update_vsyscall(struct timespec *wall, struct clocksource *c)
 		fsyscall_gtod_data.monotonic_time.tv_nsec -= NSEC_PER_SEC;
 		fsyscall_gtod_data.monotonic_time.tv_sec++;
 	}
-
-        write_sequnlock_irqrestore(&fsyscall_gtod_data.lock, flags);
 }
 
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 3b26fbd..c51d2f8 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -456,8 +456,6 @@ static inline void update_gtod(u64 new_tb_stamp, u64 new_stamp_xsec,
 	vdso_data->tb_to_xs = new_tb_to_xs;
 	vdso_data->wtom_clock_sec = wall_to_monotonic.tv_sec;
 	vdso_data->wtom_clock_nsec = wall_to_monotonic.tv_nsec;
-	smp_wmb();
-	++(vdso_data->tb_update_count);
 }
 
 #ifdef CONFIG_SMP
@@ -801,6 +799,23 @@ static cycle_t timebase_read(void)
 	return (cycle_t)get_tb();
 }
 
+/* update_vsyscall_lock/unlock:
+ *    methods for timekeeping core to block vsyscalls during update
+ */
+void update_vsyscall_lock(unsigned long *flags)
+{
+	/* Make userspace gettimeofday spin until we're done. */
+	++vdso_data->tb_update_count;
+	smp_mb();
+}
+
+void update_vsyscall_unlock(unsigned long *flags)
+{
+	smp_wmb();
+	++(vdso_data->tb_update_count);
+}
+
+/* Assumes update_vsyscall_lock() has been called */
 void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 {
 	u64 t2x, stamp_xsec;
@@ -808,10 +823,6 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 	if (clock != &clocksource_timebase)
 		return;
 
-	/* Make userspace gettimeofday spin until we're done. */
-	++vdso_data->tb_update_count;
-	smp_mb();
-
 	/* XXX this assumes clock->shift == 22 */
 	/* 4611686018 ~= 2^(20+64-22) / 1e9 */
 	t2x = (u64) clock->mult * 4611686018ULL;
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index edff4c9..8a2eb77 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -69,11 +69,22 @@ void update_vsyscall_tz(void)
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
-void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
+/* update_vsyscall_lock/unlock:
+ *    methods for timekeeping core to block vsyscalls during update
+ */
+void update_vsyscall_lock(unsigned long *flags)
 {
-	unsigned long flags;
+	write_seqlock_irqsave(&vsyscall_gtod_data.lock, *flags);
+}
 
-	write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
+void update_vsyscall_unlock(unsigned long *flags)
+{
+	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, *flags);
+}
+
+/* Assumes vsyscall_gtod_data.lock has been taken via update_vsyscall_lock() */
+void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
+{
 	/* copy vsyscall data */
 	vsyscall_gtod_data.clock.vread = clock->vread;
 	vsyscall_gtod_data.clock.cycle_last = clock->cycle_last;
@@ -83,7 +94,6 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
 	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
 	vsyscall_gtod_data.wall_to_monotonic = wall_to_monotonic;
-	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
 /* RED-PEN may want to readd seq locking, but then the variable should be
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 85778a4..78d9bc0 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -221,9 +221,19 @@ extern void clocksource_change_rating(struct clocksource *cs, int rating);
 extern void clocksource_resume(void);
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
+void update_vsyscall_lock(unsigned long *flags);
+void update_vsyscall_unlock(unsigned long *flags);
 extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
 extern void update_vsyscall_tz(void);
 #else
+static inline void update_vsyscall_lock(unsigned long *flags)
+{
+}
+
+static inline void update_vsyscall_unlock(unsigned long *flags)
+{
+}
+
 static inline void update_vsyscall(struct timespec *ts, struct clocksource *c)
 {
 }
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index a3fa587..47ca292 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -129,7 +129,7 @@ EXPORT_SYMBOL(do_gettimeofday);
  */
 int do_settimeofday(struct timespec *tv)
 {
-	unsigned long flags;
+	unsigned long flags, vflags;
 	time_t wtm_sec, sec = tv->tv_sec;
 	long wtm_nsec, nsec = tv->tv_nsec;
 
@@ -137,6 +137,7 @@ int do_settimeofday(struct timespec *tv)
 		return -EINVAL;
 
 	write_seqlock_irqsave(&xtime_lock, flags);
+	update_vsyscall_lock(&vflags);
 
 	nsec -= __get_nsec_offset();
 
@@ -152,6 +153,7 @@ int do_settimeofday(struct timespec *tv)
 
 	update_vsyscall(&xtime, clock);
 
+	update_vsyscall_unlock(&vflags);
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	/* signal hrtimers about time change */
@@ -442,12 +444,15 @@ static void clocksource_adjust(s64 offset)
  */
 void update_wall_time(void)
 {
+	unsigned long flags;
 	cycle_t offset;
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
 		return;
 
+	/* grab the vsyscall lock to block vsyscalls during update */
+	update_vsyscall_lock(&flags);
 #ifdef CONFIG_GENERIC_TIME
 	offset = (clocksource_read(clock) - clock->cycle_last) & clock->mask;
 #else
@@ -487,6 +492,7 @@ void update_wall_time(void)
 	/* check to see if there is a new clocksource to use */
 	change_clocksource();
 	update_vsyscall(&xtime, clock);
+	update_vsyscall_unlock(&flags);
 }
 
 /**


