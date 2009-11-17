Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbZKQKzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbZKQKzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 05:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbZKQKzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 05:55:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:43679 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbZKQKzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 05:55:21 -0500
Date: Tue, 17 Nov 2009 10:54:44 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       schwidefsky@de.ibm.com, yanmin_zhang@linux.intel.com,
       tony.luck@intel.com, benh@kernel.crashing.org, ming.m.lin@intel.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yanmin_zhang@linux.intel.com, schwidefsky@de.ibm.com,
       tony.luck@intel.com, benh@kernel.crashing.org, ming.m.lin@intel.com,
       tglx@linutronix.de
In-Reply-To: <1258436990.17765.83.camel@minggr.sh.intel.com>
References: <1258436990.17765.83.camel@minggr.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] timekeeping: Fix clock_gettime vsyscall time warp
Message-ID: <tip-0696b711e4be45fa104c12329f617beb29c03f78@git.kernel.org>
Git-Commit-ID: 0696b711e4be45fa104c12329f617beb29c03f78
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0696b711e4be45fa104c12329f617beb29c03f78
Gitweb:     http://git.kernel.org/tip/0696b711e4be45fa104c12329f617beb29c03f78
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Tue, 17 Nov 2009 13:49:50 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 17 Nov 2009 11:52:34 +0100

timekeeping: Fix clock_gettime vsyscall time warp

Since commit 0a544198 "timekeeping: Move NTP adjusted clock multiplier
to struct timekeeper" the clock multiplier of vsyscall is updated with
the unmodified clock multiplier of the clock source and not with the
NTP adjusted multiplier of the timekeeper.

This causes user space observerable time warps:
new CLOCK-warp maximum: 120 nsecs,  00000025c337c537 -> 00000025c337c4bf

Add a new argument "mult" to update_vsyscall() and hand in the
timekeeping internal NTP adjusted multiplier.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Cc: "Zhang Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tony Luck <tony.luck@intel.com>
LKML-Reference: <1258436990.17765.83.camel@minggr.sh.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/ia64/kernel/time.c       |    4 ++--
 arch/powerpc/kernel/time.c    |    5 +++--
 arch/s390/kernel/time.c       |    3 ++-
 arch/x86/kernel/vsyscall_64.c |    5 +++--
 include/linux/clocksource.h   |    6 ++++--
 kernel/time/timekeeping.c     |    6 +++---
 6 files changed, 17 insertions(+), 12 deletions(-)

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
index a136a11..3971331 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -828,7 +828,8 @@ static cycle_t timebase_read(struct clocksource *cs)
 	return (cycle_t)get_tb();
 }
 
-void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
+void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
+		     u32 mult)
 {
 	u64 t2x, stamp_xsec;
 
@@ -841,7 +842,7 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 
 	/* XXX this assumes clock->shift == 22 */
 	/* 4611686018 ~= 2^(20+64-22) / 1e9 */
-	t2x = (u64) clock->mult * 4611686018ULL;
+	t2x = (u64) mult * 4611686018ULL;
 	stamp_xsec = (u64) xtime.tv_nsec * XSEC_PER_SEC;
 	do_div(stamp_xsec, 1000000000);
 	stamp_xsec += (u64) xtime.tv_sec * XSEC_PER_SEC;
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 34162a0..68e1ecf 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -214,7 +214,8 @@ struct clocksource * __init clocksource_default_clock(void)
 	return &clocksource_tod;
 }
 
-void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
+void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
+		     u32 mult)
 {
 	if (clock != &clocksource_tod)
 		return;
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 8cb4974..62f39d7 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -73,7 +73,8 @@ void update_vsyscall_tz(void)
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
-void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
+void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
+		     u32 mult)
 {
 	unsigned long flags;
 
@@ -82,7 +83,7 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 	vsyscall_gtod_data.clock.vread = clock->vread;
 	vsyscall_gtod_data.clock.cycle_last = clock->cycle_last;
 	vsyscall_gtod_data.clock.mask = clock->mask;
-	vsyscall_gtod_data.clock.mult = clock->mult;
+	vsyscall_gtod_data.clock.mult = mult;
 	vsyscall_gtod_data.clock.shift = clock->shift;
 	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
 	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 83d2fbd..95e4995 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -280,10 +280,12 @@ extern struct clocksource * __init __weak clocksource_default_clock(void);
 extern void clocksource_mark_unstable(struct clocksource *cs);
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
-extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
+extern void
+update_vsyscall(struct timespec *ts, struct clocksource *c, u32 mult);
 extern void update_vsyscall_tz(void);
 #else
-static inline void update_vsyscall(struct timespec *ts, struct clocksource *c)
+static inline void
+update_vsyscall(struct timespec *ts, struct clocksource *c, u32 mult)
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
