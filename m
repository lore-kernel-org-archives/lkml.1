Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbZKQGFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbZKQGFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 01:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbZKQGFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 01:05:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:48425 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbZKQGFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 01:05:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,756,1249282800"; 
   d="scan'208";a="570238719"
Subject: [PATCH] Fix clock_gettime vsyscall time warp
From: Lin Ming <ming.m.lin@intel.com>
To: tglx@linutronix.de, schwidefsky@de.ibm.com
Cc: mingo@elte.hu, "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 17 Nov 2009 13:49:50 +0800
Message-Id: <1258436990.17765.83.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

clock_gettime vsyscall time warp was seen on a x86_64 machine with 16
logical cpus and an IA64 machine with 32 logical CPUS.

time-warp-test was downloaded from
http://people.redhat.com/mingo/time-warp-test/ 

I wrote a simple patch to port this test tool to non-x86 platform.
See the attachment time-warp-test.non-x86.patch.

[x86_64]$ ./time-warp-test 4
16 CPUs, running 4 parallel test-tasks.
checking for time-warps via:
- clock_gettime(CLOCK_MONOTONIC) syscall (nsec resolution)

new CLOCK-warp maximum:      -120 nsecs,  00000025c337c537 -> 00000025c337c4bf
new CLOCK-warp maximum:      -147 nsecs,  00000025e1052a7d -> 00000025e10529ea
new CLOCK-warp maximum:      -174 nsecs,  0000002693d58856 -> 0000002693d587a8
new CLOCK-warp maximum:      -176 nsecs,  000000270b0b1c41 -> 000000270b0b1b91
new CLOCK-warp maximum:      -206 nsecs,  0000002746a5e740 -> 0000002746a5e672
new CLOCK-warp maximum:      -209 nsecs,  000000295f170082 -> 000000295f16ffb1
 | CLK: 0.13us, fail:52 /

[ia64]$ ./time-warp-test 
32 CPUs, running 32 parallel test-tasks.
checking for time-warps via:
- clock_gettime(CLOCK_MONOTONIC) syscall (nsec resolution)

new CLOCK-warp maximum:       -54 nsecs,  0000001a8178a9c1 -> 0000001a8178a98b
new CLOCK-warp maximum:       -55 nsecs,  0000001a8d2769fe -> 0000001a8d2769c7
 | CLK: 2.60us, fail:5 |

The root cause is the NTP adjusted clock multiplier(timekeeper.mult) is
not updated to vsyscall gtod data(vsyscall_gtod_data.clock.mult). 

Since commit 0a544198 "timekeeping: Move NTP adjusted clock multiplier
to struct timekeeper", clock->mult is only the unmodified multiplier.

Below patch passes the adjusted clock multiplier to update_vsyscall.
-void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
+void update_vsyscall(struct timespec *wall_time, struct clocksource *clock, u32 mult)

With this patch applied to 2.6.32-rc7, I have been running
time-warp-test for many hours without any time warp on both x86_64 and
ia64 machines.

This patch also touches the powerpc code, so it would be very
appreciated if anyone can help to test it on powerpc.

    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/ia64/kernel/time.c       |    4 ++--
 arch/powerpc/kernel/time.c    |    4 ++--
 arch/s390/kernel/time.c       |    2 +-
 arch/x86/kernel/vsyscall_64.c |    4 ++--
 include/linux/clocksource.h   |    4 ++--
 kernel/time/timekeeping.c     |    6 +++---
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 4990495..a35c661 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -473,7 +473,7 @@ void update_vsyscall_tz(void)
 {
 }
 
-void update_vsyscall(struct timespec *wall, struct clocksource *c)
+void update_vsyscall(struct timespec *wall, struct clocksource *c, u32 mult)
 {
         unsigned long flags;
 
@@ -481,7 +481,7 @@ void update_vsyscall(struct timespec *wall, struct clocksource *c)
 
         /* copy fsyscall clock data */
         fsyscall_gtod_data.clk_mask = c->mask;
-        fsyscall_gtod_data.clk_mult = c->mult;
+        fsyscall_gtod_data.clk_mult = mult;
         fsyscall_gtod_data.clk_shift = c->shift;
         fsyscall_gtod_data.clk_fsys_mmio = c->fsys_mmio;
         fsyscall_gtod_data.clk_cycle_last = c->cycle_last;
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index a136a11..ae4d55f 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -828,7 +828,7 @@ static cycle_t timebase_read(struct clocksource *cs)
 	return (cycle_t)get_tb();
 }
 
-void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
+void update_vsyscall(struct timespec *wall_time, struct clocksource *clock, u32 mult)
 {
 	u64 t2x, stamp_xsec;
 
@@ -841,7 +841,7 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 
 	/* XXX this assumes clock->shift == 22 */
 	/* 4611686018 ~= 2^(20+64-22) / 1e9 */
-	t2x = (u64) clock->mult * 4611686018ULL;
+	t2x = (u64) mult * 4611686018ULL;
 	stamp_xsec = (u64) xtime.tv_nsec * XSEC_PER_SEC;
 	do_div(stamp_xsec, 1000000000);
 	stamp_xsec += (u64) xtime.tv_sec * XSEC_PER_SEC;
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 34162a0..7b1a3a6 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -214,7 +214,7 @@ struct clocksource * __init clocksource_default_clock(void)
 	return &clocksource_tod;
 }
 
-void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
+void update_vsyscall(struct timespec *wall_time, struct clocksource *clock, u32 mult)
 {
 	if (clock != &clocksource_tod)
 		return;
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 8cb4974..0d156eb 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -73,7 +73,7 @@ void update_vsyscall_tz(void)
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
-void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
+void update_vsyscall(struct timespec *wall_time, struct clocksource *clock, u32 mult)
 {
 	unsigned long flags;
 
@@ -82,7 +82,7 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 	vsyscall_gtod_data.clock.vread = clock->vread;
 	vsyscall_gtod_data.clock.cycle_last = clock->cycle_last;
 	vsyscall_gtod_data.clock.mask = clock->mask;
-	vsyscall_gtod_data.clock.mult = clock->mult;
+	vsyscall_gtod_data.clock.mult = mult;
 	vsyscall_gtod_data.clock.shift = clock->shift;
 	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
 	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 83d2fbd..b18e8a2 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -280,10 +280,10 @@ extern struct clocksource * __init __weak clocksource_default_clock(void);
 extern void clocksource_mark_unstable(struct clocksource *cs);
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
-extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
+extern void update_vsyscall(struct timespec *ts, struct clocksource *c, u32 mult);
 extern void update_vsyscall_tz(void);
 #else
-static inline void update_vsyscall(struct timespec *ts, struct clocksource *c)
+static inline void update_vsyscall(struct timespec *ts, struct clocksource *c, u32 mult)
 {
 }
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index c3a4e29..2a6d3e3 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -177,7 +177,7 @@ void timekeeping_leap_insert(int leapsecond)
 {
 	xtime.tv_sec += leapsecond;
 	wall_to_monotonic.tv_sec -= leapsecond;
-	update_vsyscall(&xtime, timekeeper.clock);
+	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
 }
 
 #ifdef CONFIG_GENERIC_TIME
@@ -337,7 +337,7 @@ int do_settimeofday(struct timespec *tv)
 	timekeeper.ntp_error = 0;
 	ntp_clear();
 
-	update_vsyscall(&xtime, timekeeper.clock);
+	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -811,7 +811,7 @@ void update_wall_time(void)
 	update_xtime_cache(nsecs);
 
 	/* check to see if there is a new clocksource to use */
-	update_vsyscall(&xtime, timekeeper.clock);
+	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
 }
 
 /**


